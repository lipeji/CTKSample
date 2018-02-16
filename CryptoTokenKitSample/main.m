//
//  main.m
//  CryptoTokenKitSample
//
//  Created by admin on 14.02.18.
//  Copyright © 2018 admin. All rights reserved.
//

#import <CryptoTokenKit/CryptoTokenKit.h>

int main(int argc, const char * argv[]) {
    TKSmartCardSlotManager * mngr;
    mngr = [TKSmartCardSlotManager defaultManager];
    
    // Use the first reader/slot found
    NSArray<NSString *> *slotNames = [mngr slotNames];
    if([slotNames count] < 1)
    {
        NSLog(@"No smart card reader found!");
        return 0;
    }
    
    NSUInteger index = 1;
    for (NSString *slotName in slotNames)
    {
        NSLog(@"Slot %lu: %@", (unsigned long)index, slotName);
        index++;
    }
    NSString *slotName = [mngr slotNames][0];
    
    // connect to the slot
    [mngr getSlotWithName:slotName reply:^(TKSmartCardSlot *slot)
     {
         // connect to the card
         TKSmartCard *card = [slot makeSmartCard];
         if (card)
         {
             // begin a session
             [card beginSessionWithReply:^(BOOL success, NSError *error)
              {
                  if (success)
                  {
                      // send 1st APDU
                      uint8_t aid[] = {0xA0, 0x00, 0x00, 0x00, 0x63, 0x50, 0x4b, 0x43, 0x53, 0x2d, 0x31, 0x35};
                      NSData *data = [NSData dataWithBytes:aid length:sizeof aid];
                      [card sendIns:0xA4 p1:0x04 p2:0x0c data:data le:nil reply:^(NSData *replyData, UInt16 sw, NSError *error)
                       {
                           if (error)
                           {
                               NSLog(@"sendIns error: %@", error);
                           }
                           else
                           {
                               NSLog(@"Response: %@ 0x%04X", replyData, sw);
                               
                               // send 2nd APDU
                               NSData *data = [NSData dataWithBytes: nil length: 0];
                               [card sendIns:0xca p1:0x01 p2:0x82 data:data le:@200
                                       reply:^(NSData *replyData, UInt16 sw, NSError *error)
                                {
                                    if (error)
                                    {
                                        NSLog(@"sendIns error: %@", error);
                                    }
                                    else
                                    {
                                        NSLog(@"Response: %@ 0x%04X", replyData, sw);
                                        NSString *newString = [[NSString alloc] initWithData:replyData encoding:NSASCIIStringEncoding];
                                        NSLog(@"%@", newString);
                                    }
                                }];
                           }
                       }];
                  }
                  else
                  {
                      NSLog(@"Session error: %@", error);
                  }
              }];
         } else
         {
             NSLog(@"No card found");
         }
     }];
    
    // wait for the asynchronous blocks to finish
    sleep(1);
    
    return 0;
}
