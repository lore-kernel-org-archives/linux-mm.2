Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3099CCF9E5
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 21:18:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B9BA8009D; Mon, 27 Oct 2025 17:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26A5C8009B; Mon, 27 Oct 2025 17:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159008009D; Mon, 27 Oct 2025 17:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F20C58009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:18:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A9DAD1A0284
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:18:34 +0000 (UTC)
X-FDA: 84045158148.30.4074BD7
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf07.hostedemail.com (Postfix) with ESMTP id 002864000D
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:18:32 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of 3qOH_aAkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3qOH_aAkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761599913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=q4EkWfyUu2EKMYSWMO58Kw2PSZVDedjYKfMXcj2zumE=;
	b=oW4kiVgTYPuQjgAsfk04gRSxVbtzK1i1gjdWzB5n6PhY0CvAjVxFzWq2pIiPJ6ho/P7Vk/
	y3YUYDETDD3mMU2VDVkIhGg9C6GmlfEzwMY0A+Wyox7NGXR76VS6YBGdFkgNzyJOIJTyX2
	+rmJYiB68vmnkKZtATWVx4ASUidELRM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of 3qOH_aAkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3qOH_aAkbALkrxyjZkkdqZoohc.fnnfkdtrdqbnmsdms.bnl@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761599913; a=rsa-sha256;
	cv=none;
	b=VZP7NscvRaUC3T9xhkdwCgwMgIEcScL/IMNCXWUN5kUGA2pD95C/+kaCBw+Zi/SNBGOcNk
	j1gZeiaY8QCJYwB1axVO+WWgo8EAix1x+GNxPuRFd7Ee/0KiSSy3R9Ea2yO2EDwYhrQ0f2
	PLpzEAmCad0J19EWU56Ypv/JHdNpNcE=
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-430d003e87eso189070915ab.3
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 14:18:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761599912; x=1762204712;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q4EkWfyUu2EKMYSWMO58Kw2PSZVDedjYKfMXcj2zumE=;
        b=o8dvDpHnztIE9yM+ZWAuB/VbAHTOENGzA/rRmEQad6c47vt8Cvp2mNNXQ9njXqCCFE
         shl5fBTFQtwHjgAtp0lb5ECy0n//qNV7CXCi25AAYOFBAU74nGkcevVe4Fv7XxZb8Enk
         EnxFxDxfFHya1bjIfvS4CJnBli3rbJlYY3WgGjIzZeP/kx3uc9UbNgMyzX9XuwFNCd18
         nx0VYg/JwlaKa+M/rO5B3gc4G+A/fYKnclbg8y7BD4VFDIQ2IdBr3xtQA+m1SKsG6zHQ
         K6EbJ3PL/K0WQFuB9cxWkEcWV+3WRlB2K6x9eqxRIX8jnmQ234FMfo4aXTC3Lemgt+ms
         T5ZA==
X-Forwarded-Encrypted: i=1; AJvYcCX9v81J1FiGuGIxbti6+i6iEUBOMJYe27zHmy0PxMN5FlzUpJ65AR4fUXxxxw1+6oyDnLynV+MjCw==@kvack.org
X-Gm-Message-State: AOJu0YwHHw5Ir/0O7GAJTBZFQB3XaQQF4BwcbzCdpi6N3tS0Ce0Smj9q
	8wuzugGG+fy6/tA9uUFmiXn3EDi0CmkNR74lC/+TczoBaTjo8RY5vY5VTwXuLAMyw+Gf6vZedF3
	FFlO23NGw3nQbBnJMthP3/ere4M8BT397DTOIize9Rm86pAiBly00kPzkQrc=
X-Google-Smtp-Source: AGHT+IGSIx4R/X+4T/h9VAdXT+ZzvTHIkrzU8hH3yNfGn1bm9RGGyFg81lGOQFSxvhErxsCtiLjf5GstT11RlozeYZbsRr+x/HDB
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:148f:b0:430:c394:15a3 with SMTP id
 e9e14a558f8ab-4320f841926mr20056985ab.22.1761599912043; Mon, 27 Oct 2025
 14:18:32 -0700 (PDT)
Date: Mon, 27 Oct 2025 14:18:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ffe1a8.050a0220.3344a1.03a0.GAE@google.com>
Subject: [syzbot] [mm?] WARNING in raw_alloc_io_data
From: syzbot <syzbot+a894fe5447d0543e89c9@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, matthew.brost@intel.com, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 002864000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 46b5qwe34dqrjgjcnsfsjxdswaftic9o
X-HE-Tag: 1761599912-903723
X-HE-Meta: U2FsdGVkX1/2InnddUpFZZiV2397RByFHNDAmaNyUkQHVzKuuLvcVIbNdr9YTMXLm1TXcJJoU7PHnKtIXlOjE2b3nR412nhOWuEmsbxnb1E9we9Rre3W1F6qOm4q88cr7WcWSdoskmwQ++9VDgXONruWRsugBS4b78LG/pvMwDkay7jLanJOWTmaI9nmvRI5RzqNY+pzow5kDOXkTbiYyBhMaQe/aOfFhJI4op91/xX9SJqhbD5sBlA/3H+ExJwH1+TD/dqN3W4hUtrqxMJHLGBoA3cmj96tBwKAlsucg68Jgqcev77Buqfu0jEN2qTPupCpufwBHJHmd8o1zhXUg50v5R/MGCJKgpAEiTu+7yLRuQ7AoLN+LPi9lgmpSQsx526/wAstkMx+UlJq6UavIWKXMShOJ8aR2McFfiXJ0pW7ooR8AB1pc6epozLM/SVtMkqITU2PahyjydRLPOI5sDaFfCrhYUseF9/LonrCAqAU4fZquEO4+EkuwuA9vC/zIYY7oXtEqBetRlXwBwM6eVsX67mX/RvHf6FDdcpD/Y8kFJTuPuf+kqPXljLK2bd22k2Q8ieYLp92bfqHiiVkkRgPSavcdk6wRhaZNpHm+fI9YoFh45AqxJ7qh1XJ2shc6aSj5GUHxN2MAqRuY9xbAT3y1MuEb6OYbloPSBIJXuhDNEFMFI79R2n2CwJSJETVrhTrGRBYe9KfKDoIoORCNn21FUDlHeL/aZptVFN9QjvC/HaQhqDkBYSSd1LFVMabNNJcrpSDEvPEVWuUUeRrX/rNWrqWVElgTaZwlC20LNQeAUlEj6YU17PfIwv5BxvUwxpI4b6bupoDH8C1I3furIuh0y3cxMCWNxyuofouPxrnFlakaXDUxd3uYK+l7blM5In13JSV6PkUYLKq9JW7VB05wsn6k2I7Hzd2cJG91RfNREWiJunPw/+Ennyxj6ucdDsf1LPrh2GFM71bb8b
 LlpxRylU
 okDH4J4yxcWxhLGTyoDtBwp9KDOWwzFXRbntAbIK8PNNuIhBDff1cd2hgBrMB6XBP/mWuTW0kgNOC0bMjoL3e8xDguhhFVSo8cEu6USP504kGNsxcfX9Pf4iq6MZkEBYW5EqeFZhJTKHqqSCcmei54P1+N9iBsdO6MtTM8Zz0wNzZV+0grweEd9Ypc2bGr2iyonygA0Xa9B3Tr115Nt244NWUa+EDGCEyessvYwA5mY2qk7BkvhPnirxlTUgm4t04e5c97kfynQUy2ONSwRI7b+VWd1/HJfHLpCwnGQe633bbpK3UAhQQ0gh67J3UbyEnv58+j6ih41ClewS2Pj2aba7tD/wODQL276hK9by1SQjS8cjBRSAe33RaZUUaxaPe5bjmTHE+S1Y71lqbdUJvLbjPQPOgN4pFb0rkCreVSiFC9mOwtUof8b7nfBRT0p2RPTPfBejMm/hsNraEfQHVzf9u+3A/uuNibDsvtDA9/vH4VEU5F3EXdOvxVCrvycmcPc3728HYmyyIU9rLY4LMtSpz1+QtqpXY0SS6v7uLtMtv+987+q3SHwbyzLDQDhl/D0ieDxt+sVqB2qIoCadOQiDLpNj0PHfOovq4Fof7AqOUnP5JOwY3Fae842PiDxREgK+cRpQ9Huon95jta17qdgT5uQ8Nf4w/QZHx/4T1OzgubrXWrK45TT3cbIrwz3LklqFPaZwTUjQMtX/mNiMtjkXQv0PpZ4cQLPMooZDh8bOXBKMBWWypUDILZehfPmF/xduu80vWOS1QQA4KIMomQV4n/wu7ovg4YlMo5nGdBKtidTzfIJlYPAL1Is8jzMzjSax3fn0dsSKEFcf8wmhhOdRVIs+PSfVNbrHoBO0dO4JKVztME1VU2bYD7Kc708+r2XD8HIPdIBKJShJrv/3zzftSPyKFLeUSC/3h9UvixVtCKBLmQDSKNKmcFoUahg6P6S4lyHzxtq53dNVQCnH8fog+e42L
 G4JujVCi
 f3x3UxlxLgaNTEsQ4C8mrUemL9mi7b0H5Wk8y2NJReJHYav6nUn5AZFHpSviQRY1ZCPyO+T6M6cgtcAKkJ95BvuIztjBMbio7uOwyA21kTx8ag6WuFS/VBJ39DBxUzHmOf1Nr8KwuBwE9rXK90ACCUKR7QZK7UMUcXikngiFpniTlFu7dtTntFAtTEnY+l3HFqe9Y36pm7+qwNtBeMVl8UlISrMaTx8oL3uiVlkUgr5BUz2gNBkU6nfb/dZMNyracWCNBqA7YXeodlUHm1MjselUf6WjagddT60ZmNoHmBku2Sfzb9d19RJlfgqw9EqNMgjoy5qut+ZFd3T+V7be7gKprMpG2FGuYu8P7UDSZ6jxmoR4HKzkZLWq+7mBrvgwBbazEUPvyEh4eg8nI683YU9DODPPr/I0z5anePTLH9wdjkCTmbVMldZTjosheXtXemI27gwnGsbY9cDJNlGbBctZIsAsWS0rOg8gW8KO5Xp4zEe0wxVoPe/1bcfaUv5WH/rE/MusltANM2D5IKIJ6/R/jz6jFME2fJP1cXoqDWfSG8lmsouFsz2wPDn0rOe1wexvNFXueqg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    dcb6fa37fd7b Linux 6.18-rc3
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=160597e2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=609c87dcb0628493
dashboard link: https://syzkaller.appspot.com/bug?extid=a894fe5447d0543e89c9
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11af27e2580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c2d614580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-dcb6fa37.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/61176fd888a1/vmlinux-dcb6fa37.xz
kernel image: https://storage.googleapis.com/syzbot-assets/84e7e9924c22/bzImage-dcb6fa37.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+a894fe5447d0543e89c9@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 3 PID: 6091 at mm/page_alloc.c:5159 __alloc_frozen_pages_noprof+0x309/0x2470 mm/page_alloc.c:5159
Modules linked in:
CPU: 3 UID: 0 PID: 6091 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__alloc_frozen_pages_noprof+0x309/0x2470 mm/page_alloc.c:5159
Code: f0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 cc cc cc cc 83 fe 0a 0f 86 0c fe ff ff 80 3d d4 63 52 0e 00 75 0b c6 05 cb 63 52 0e 01 90 <0f> 0b 90 45 31 f6 eb 81 4d 85 f6 74 22 44 89 fa 89 ee 4c 89 f7 e8
RSP: 0018:ffffc9000371f9f8 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000014 RDI: 0000000000040cc0
RBP: 0000000000000014 R08: 0000000000000005 R09: 0000000000000009
R10: 0000000000000014 R11: 0000000000000001 R12: 0000000000040cc0
R13: 1ffff920006e3f55 R14: ffffffff9ab2c464 R15: 0000000000000014
FS:  000055557bf92500(0000) GS:ffff8880d6d0a000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f84d9710300 CR3: 0000000032452000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2416
 ___kmalloc_large_node+0xed/0x160 mm/slub.c:5583
 __kmalloc_large_node_noprof+0x1c/0x70 mm/slub.c:5614
 __do_kmalloc_node mm/slub.c:5630 [inline]
 __kmalloc_noprof.cold+0xc/0x62 mm/slub.c:5654
 kmalloc_noprof include/linux/slab.h:961 [inline]
 raw_alloc_io_data drivers/usb/gadget/legacy/raw_gadget.c:673 [inline]
 raw_alloc_io_data+0x12c/0x1a0 drivers/usb/gadget/legacy/raw_gadget.c:659
 raw_ioctl_ep0_read drivers/usb/gadget/legacy/raw_gadget.c:776 [inline]
 raw_ioctl+0x1397/0x2c30 drivers/usb/gadget/legacy/raw_gadget.c:1313
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl fs/ioctl.c:583 [inline]
 __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f84d938efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe768729f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f84d95e5fa0 RCX: 00007f84d938efc9
RDX: 0000200000000080 RSI: 00000000c0085504 RDI: 0000000000000006
RBP: 00007f84d9411f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f84d95e5fa0 R14: 00007f84d95e5fa0 R15: 0000000000000003
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

