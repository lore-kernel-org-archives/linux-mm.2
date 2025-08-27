Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32096CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 21:55:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6259E6B0025; Wed, 27 Aug 2025 17:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5FBC76B0026; Wed, 27 Aug 2025 17:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5117F6B0027; Wed, 27 Aug 2025 17:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3AA876B0025
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:55:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 00A84C088B
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:55:33 +0000 (UTC)
X-FDA: 83823894588.20.FF7AC26
Received: from mail-il1-f207.google.com (mail-il1-f207.google.com [209.85.166.207])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4C76A40007
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:55:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of 3036vaAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3036vaAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756331732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=xF+jtFQ9b8zMRrU/Cm5qYAVQe6xzCcpYtRD3ii11fhQ=;
	b=kDLWAI7r65RworCyCTrvtOOxlFGva9ZSLP2HO6Pc1Un9EKLBNA0OKZCcWkuWl2iQ/qA101
	62bb0XW+Bkr7Pbu1OnYL4FaZInXO6vUxcLXAqhQrUJiU6s3UsbPrf31qRYyVzTGJ3GQmZ4
	8Cz5f2aVGyiJ4Aq4hUKhGErM6B3AA6c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756331732; a=rsa-sha256;
	cv=none;
	b=8DdxQBp9Khh6WTMOqjdjCMQEJ3Cv5OlNGTn4rQ7diaSXCvkhzKC2dOLVwW4uz+7O438G5S
	V+yMHV48lMke5xczam1FTjgnHMDD9KGLccTrWs+WeiMTWO1xHpAzFLqEVczwEbEQgOYq9k
	0r0P8oRNv3yrEK//WN7Q6Glrb9p3x/k=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf04.hostedemail.com: domain of 3036vaAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.207 as permitted sender) smtp.mailfrom=3036vaAkbANoOUVG6HHAN6LLE9.CKKCHAQOAN8KJPAJP.8KI@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f207.google.com with SMTP id e9e14a558f8ab-3f0d4ad1c3aso4042045ab.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 14:55:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756331731; x=1756936531;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xF+jtFQ9b8zMRrU/Cm5qYAVQe6xzCcpYtRD3ii11fhQ=;
        b=XkYIUtPb5mC2oBCkxin6rCI4Wik7l8phgIA0G12pzOUPLke2W+09Wf3UNIFC4Q4lN5
         WQ8/vgF8VO8a4N6H12I1s9wbCS9D5bjny45vAQmBQxL5+jrAIKQVwbeFOxlud475CiGi
         CkuGHdi0xjYx319RCWdF+OqoeUODfY9Q7oFvw8OKyzbC8/ZwUVNDp1ME5hsCf6qA8fE0
         qGwn3xI/HRPI4nlq8F9jWfLz5QoDyuGJCqcmHtl0Xh7svVtM4KVLRP4y1bhepVqfiKGe
         haGP1Ocl+2Q/2P5ELjhzDPHMOA0l8z2i6d/m5VZs+qGALftidrApFOgQ2zjp9/D0KICC
         vBiA==
X-Forwarded-Encrypted: i=1; AJvYcCV5zaaeUY4eiytDUmaxeDk6K1zdTfyngnoN/11k93aQzu+LFBJSCKts2cvE3mJQ788uLsAHpJTuAA==@kvack.org
X-Gm-Message-State: AOJu0Ywx/osVJ5pOQE+bNBynk3Ju7FLVvwUbInDgq1bUYq8xyMAiJusK
	pOFTYZ3EsLg9kCgb0kq4rxr/1waNA2TX349JF8wZLu1ds/Dr/w2M7NYwBFBuke74nw+9WUjwYQd
	ZtKuRX+Ml7MAVzPuvmdWEtvhaJUWJjZOc0UMXyt1Uh5yYUFabTWnaDSrNmx4=
X-Google-Smtp-Source: AGHT+IES9W9i5BDPnigPWHyPwFFVK8HYOg02PCDU4wDRx1cddarSx3N77jLS8b/A0OljZ6ZaxmpeRG+Ewn6Lzi0PSQIKRrS28joC
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:148f:b0:3f0:78c3:8fc5 with SMTP id
 e9e14a558f8ab-3f078c392cdmr43149115ab.5.1756331731412; Wed, 27 Aug 2025
 14:55:31 -0700 (PDT)
Date: Wed, 27 Aug 2025 14:55:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68af7ed3.a00a0220.2929dc.0004.GAE@google.com>
Subject: [syzbot] [mm?] [usb?] WARNING in __alloc_skb (4)
From: syzbot <syzbot+5a2250fd91b28106c37b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com, 
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-usb@vger.kernel.org, 
	matthew.brost@intel.com, rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4C76A40007
X-Stat-Signature: nt3p636mhag4b1cqesdqmaobpuonmwmf
X-Rspam-User: 
X-HE-Tag: 1756331732-85236
X-HE-Meta: U2FsdGVkX1/BOwZBp4RCQseoouhxK1VjamM0Jf8azKtmixsomRYGsuMJAGjCtBG/HaQ0avAo7l+9C1FyrkRvQaE57xHTlXISm6OCBUbaqgQneAs+p5UhSsh77dX0B0F75Ih0TvF6tp+p1LnGGWVbJjHTTEGSG6PwuKT6KES5Vhb8ZWzIKzntHh2O6kk91fHeq5gBxJkdVAK1TSwfQb8HLFhGXBME/srVzFcE99VjgzhSueWOGPSXdIoh93n5EKYcUwZw/OjFB0ptUc2FVFs+3b1B5vxaZ/9Of7/A9ybTo6rR0WOXUi4qhkRG4KExwvbwF7Yj+pAtjAEBY5Q+3Yji6xM9RZt3gKwrOJucbxt1H0+K+NR1kwZWnCN/mKJ/AvaFSPZQ5kw/tIHDFMDaP35AOcLfDj13l9NBD5JNkR+EAk3Ov1wtTqjvXiKlYpMG18MRRTuqXhUzW0f8SAURPdmI6Ix+OFgxIDmN13k8AvMG18SWlMAOsBRgV8SVjOSUlX/GNQ16NhVhoTi478TUVP1EGN5sEuiAH/TWtwYbxsLrx+k80J6EL8xBJX/4ZEuDgecxTuAua8BDPVT8cCgj8Ptb7R5bBg0zbOyaT0idk7hNloFGugDQrA1UjraAsG7B4iAOPnOXi4fc8NXMMNASYZ8J6MeQWtfSkU3Uwqcr7qTLeFsRmoNJhMkpxreSuoEtwLmlZrSmvoW8awx5o2dAUGZdfB0Lj8VCeItZxTP/SrL3fEgIaJCIX0iP0YAEFlCafHdU3KljKiIAEHTMdjl+UW+7215e6U8ntIJsSzuAYQ7D0Wuw028iAqsofdGEDIfE85gI7iHb/ZeTJXJoiBHd7kfuiBRY3ygk5C71Qdhke9P/uwgU4DKFv8q3/4WB0vd1Sb7Twpzlp3iZXMQtNbO91pL4uX651DD3zI6ki7iZpAuZLaC+CAxL4ZPFghxc9nJRIY2IoDrO5xw9ogqaV/15pG7
 IxeTLSsB
 yuUhzcSqtG8O5SmTaB5pxz/bCVu+q+amCV0jf5Py4eC2NjMEHLHq0xlG0YEvH3/pnjAVIH0dlSJCK4TiFWsWgSFIQuXL40Mre0WKIhL/x/A69xGgHG9sJ55LmFkHI5puOozVexvjTDbbsYaZPNvdRoJZst/4FJBmbOnb8s0JR8N7tLU0B4SfHLYejW60kJxXp1UdrLHN43TYvdfUanZBu6Z1rxOAD8XLfcixT87oJePdu209Y/rZ4x8tHpcyQPz8vvQ3qvtOp7r0IqZC2oyO1aedSS0lhMfx92QtL9PGAka9lGXGs1Suz/+pPDzDok18ezzL8lS61CDkYb0JY4vRjRkpaHTguTMTnt/Tn+our51xOXttM9v34xh9mbY2HeCLo5HF/2YJdFH0eEO6iZhtZZaRGNpMLS2uewUPDDgKfi8vqINIORFZaqsWwWvchM9t6LX0b429Q7LYY7kT3VRAnvL/Qv846rvGq66g9S5fsUIyAq1zy+OG+qNU7kkzhO8Q6cAAoFOr3oUdcIHEKfanWyYrhkYxwvzwAQXbpWnVZMI/jLs5A6bCghpstyyu3Fnhns2B137sSHahGt8KZYH01DJpxle66b39+5Jzvx5tYwA+g1XQxbJXM1aZmUgfT4D1J3F9fbUP2opVjCMFhMd0S5hdW8NqavrlJAOXxXvrtuMkbUkSnrbwcVIGklC2cP7FDX8M01xG/bX4cOOQ2fn4zhUfOLR0+EVyQFNCvkwtTs60V46fb5O+BBM4zKhWgJ/AA+2lg9+hKUBXnGMvv90PO1EwrvICfv+JY7RMTuPV8ht17HQyvAWNo3FTz0Wj90euGIWxQ02YidPuQ8JUcRO/Ayr85RO2IhDqbEEM5QmeGPZmF0GlL9w+9jyr66gyDL5MJstp+abjHAOyYqNUjVwhhbGhDrSSZ03IP86K6pfp/0Kj0Kzy1jWj9SU9fF9YRFDL8VAVv+QwBO47O0vA61hA8UFtyJ/VX
 Swijomrt
 qfwlVOg33OSoSjwFiUk6sS+TuDIlfwc7thwFjtc0LXVxNiWHp8AC4HkNmhuSkxcaYB18RMG3Zu2fjqZwinHxr29cD6w2AwLrume/9Sdsn+boONt05oPPCwUVkeRCFy1uHybC9xl0RuAj02iURrOL0AeyamP/+qXiZRrK3Okign8TTh5jzFrzaoqP7qoAnb+mKyMCPfOOyeBTdF4AUPqJ5wXoUsqalgrbNdBLtikgrmaaHJWXu+sYWhlH84h3dj73Icik3P8vfp81bqYFzI3sAnbW/fU2XI5nLftGVVnBmSlbnFV9IhGAhOXg97VC+Cf6aKzxBLCrGz09C46AXyx/JyPnPMjHc+gh7yOQB5t9eTlXs8fxoESsBTtpyTg6A5gV6pm8wQE/A/kYj4sBoQo94ZoPkkjKSEf8a7NbK06RbniwQHE/H6+K7Iw1qBZLlHyQwYrpUPwvNH8q/WE1h525ohOJvHh46zrpoxQjLsmL3/ORezYzNVYbOA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    7fa4d8dc380f Add linux-next specific files for 20250821
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=11fecc42580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ae76068823a236b3
dashboard link: https://syzkaller.appspot.com/bug?extid=5a2250fd91b28106c37b
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c94858580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=108ea7bc580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/63178c6ef3f8/disk-7fa4d8dc.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/c5c27b0841e0/vmlinux-7fa4d8dc.xz
kernel image: https://storage.googleapis.com/syzbot-assets/9a8832715cca/bzImage-7fa4d8dc.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5a2250fd91b28106c37b@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: mm/page_alloc.c:5124 at __alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5124, CPU#0: dhcpcd/5530
Modules linked in:
CPU: 0 UID: 0 PID: 5530 Comm: dhcpcd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 07/12/2025
RIP: 0010:__alloc_frozen_pages_noprof+0x2c8/0x370 mm/page_alloc.c:5124
Code: 74 10 4c 89 e7 89 54 24 0c e8 f4 11 0d 00 8b 54 24 0c 49 83 3c 24 00 0f 85 a5 fe ff ff e9 a6 fe ff ff c6 05 fe aa b7 0d 01 90 <0f> 0b 90 e9 18 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
RSP: 0018:ffffc90000007780 EFLAGS: 00010246
RAX: ffffc90000007700 RBX: 0000000000000014 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc900000077e8
RBP: ffffc90000007870 R08: ffffc900000077e7 R09: 0000000000000000
R10: ffffc900000077c0 R11: fffff52000000efd R12: 0000000000000000
R13: 1ffff92000000ef4 R14: 0000000000060820 R15: dffffc0000000000
FS:  00007f4fd75a9740(0000) GS:ffff8881257c4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffebb07e018 CR3: 000000001dadc000 CR4: 00000000003526f0
Call Trace:
 <IRQ>
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 ___kmalloc_large_node+0x5f/0x1b0 mm/slub.c:4306
 __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:4337
 __do_kmalloc_node mm/slub.c:4353 [inline]
 __kmalloc_node_track_caller_noprof+0x34d/0x4a0 mm/slub.c:4384
 kmalloc_reserve+0x1b8/0x290 net/core/skbuff.c:608
 __alloc_skb+0x142/0x2d0 net/core/skbuff.c:669
 __netdev_alloc_skb+0x108/0x970 net/core/skbuff.c:733
 rx_submit+0x100/0xab0 drivers/net/usb/usbnet.c:-1
 rx_alloc_submit+0xa6/0x140 drivers/net/usb/usbnet.c:1538
 usbnet_bh+0x9a5/0xd70 drivers/net/usb/usbnet.c:1607
 process_one_work kernel/workqueue.c:3236 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
 bh_worker+0x2b1/0x600 kernel/workqueue.c:3579
 tasklet_action+0xc/0x70 kernel/softirq.c:854
 handle_softirqs+0x283/0x870 kernel/softirq.c:579
 do_softirq+0xec/0x180 kernel/softirq.c:480
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
 __dev_open+0x694/0x880 net/core/dev.c:1690
 __dev_change_flags+0x1ea/0x6d0 net/core/dev.c:9549
 netif_change_flags+0x88/0x1a0 net/core/dev.c:9612
 dev_change_flags+0x130/0x260 net/core/dev_api.c:68
 devinet_ioctl+0xbb4/0x1b50 net/ipv4/devinet.c:1200
 inet_ioctl+0x3c0/0x4c0 net/ipv4/af_inet.c:1001
 sock_do_ioctl+0xd9/0x300 net/socket.c:1238
 sock_ioctl+0x576/0x790 net/socket.c:1359
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:598 [inline]
 __se_sys_ioctl+0xf9/0x170 fs/ioctl.c:584
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4fd76a9378
Code: 00 00 48 8d 44 24 08 48 89 54 24 e0 48 89 44 24 c0 48 8d 44 24 d0 48 89 44 24 c8 b8 10 00 00 00 c7 44 24 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 07 89 d0 c3 0f 1f 40 00 48 8b 15 49 3a 0d
RSP: 002b:00007ffc26f40168 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000016 RCX: 00007f4fd76a9378
RDX: 00007ffc26f50360 RSI: 0000000000008914 RDI: 0000000000000016
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffc26f60500
R13: 00007f4fd75a96c8 R14: 0000000000000028 R15: 0000000000008914
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

