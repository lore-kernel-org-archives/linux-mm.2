Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B47ECAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 17:44:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D448E0007; Sun, 28 Sep 2025 13:44:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE3D8E0001; Sun, 28 Sep 2025 13:44:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E3928E0007; Sun, 28 Sep 2025 13:44:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3BC628E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 13:44:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5465160147
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 17:44:30 +0000 (UTC)
X-FDA: 83939383500.30.8697233
Received: from mail-io1-f77.google.com (mail-io1-f77.google.com [209.85.166.77])
	by imf18.hostedemail.com (Postfix) with ESMTP id 345C51C0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 17:44:29 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3_HPZaAkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3_HPZaAkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759081469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=JfHz+kVBBN6qxDi9w6vxoz4MHOeNlBqzhi/tIoFuRPE=;
	b=R5hNpFWE9R+hPgqlP0vcMDczw0TPSEmXKuJCQai6U+BV43qE6it44eOLVxFwpAuTMlFslt
	bD0AJu3h3t2LcauU6GbJNZJ9VBdL/JvB5KWxIfXXF3pHThUFxGdaVu5p7VCsOorY5spjtA
	3qanE8OdPM/yA+7mhprGUtStluz3P1E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759081469; a=rsa-sha256;
	cv=none;
	b=Fg9HWWx521n7F9vrqowIK3rsBIMm70rk88kiAMONpdPwdttQwDd0fb+v7CaDOCpusYyQPB
	L4lhvdSOYYTitASaNwSs2iHatLdDnHx+a5vSUktekr33rAclLD6jeM9Y16dtyRq1lWNcCU
	LFqGAG27dJwaqyIWg+8as3YW5gps+k0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	spf=pass (imf18.hostedemail.com: domain of 3_HPZaAkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.77 as permitted sender) smtp.mailfrom=3_HPZaAkbAJcJPQB1CC5I1GG94.7FF7C5LJ5I3FEK5EK.3FD@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
Received: by mail-io1-f77.google.com with SMTP id ca18e2360f4ac-8ccb7d90c82so472512539f.2
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:44:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759081468; x=1759686268;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JfHz+kVBBN6qxDi9w6vxoz4MHOeNlBqzhi/tIoFuRPE=;
        b=gcb9IS0I3OnuaJ1qWmqbGZ53vs36pRXDlPKg8MufS+vMVy0Xzviy3LRHFO13Wjh6Mc
         bFWzBNrMggNQsBVjKZ2RKXCyhEVN2iNWbRsdA7+SW6Oc46kpdwiHb0mqOYHVjh6qkWyO
         s0AJg01Xykbi39phr1yWURz3pSYm8tbU2LxxGIUHPTI0uiQHiY7mBzJrtIU07A7EhrSU
         Xuk3nHTAmL0cux7JlApP5IUOhrfecYBmG5WvmUQu3/RQjrcAdOLo4x6RCjUfJC/RHExO
         x0S9g2F00i2uayWTUzX1SYZBl/2ljpHjRdfvEJ57pn/tWw7J9PAcdaz2NvjIQi3cqwto
         c+iw==
X-Forwarded-Encrypted: i=1; AJvYcCUSXtP8ZSADOkG36jBmQSWTrHSueewaaJRkCF+HKcA3a5KtsOdThgXjHjPbS7S6PMrLO6ig9/DzQQ==@kvack.org
X-Gm-Message-State: AOJu0YwfrZrF+VLT/inpxrbHpdUaZ9NtjuPVWiMFTH/mmCkLzhC0k8oX
	ItPTJTGLWW6rjLmJuv6+CvdP8GeMzBOA6VnBBoGwpgV/GBIzqmIug+FczukUG51v/mLi6quffXA
	SESYjNB7mpP5vGCXxMlbmN0WtEzHRDwIKaVyueYtUw2qymN0rGDmxr+7ZGiI=
X-Google-Smtp-Source: AGHT+IFMLHheYfBzpYXH2L+A8ieG9iaNLiHGhD/LJKn1x6lDumvntoi3looYvzugPONUK1RFSwCI0/btp5SXrDxyLfRc9saqMxq8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12cc:b0:428:c370:d972 with SMTP id
 e9e14a558f8ab-428c370dba4mr79681495ab.7.1759081468228; Sun, 28 Sep 2025
 10:44:28 -0700 (PDT)
Date: Sun, 28 Sep 2025 10:44:28 -0700
In-Reply-To: <6861c281.a70a0220.3b7e22.0ab8.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d973fc.a00a0220.102ee.002b.GAE@google.com>
Subject: Re: [syzbot] [mm?] WARNING in xfs_init_fs_context
From: syzbot <syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org, 
	byungchul@sk.com, cem@kernel.org, david@fromorbit.com, david@redhat.com, 
	gourry@gourry.net, harry.yoo@oracle.com, joshua.hahnjy@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org, 
	matthew.brost@intel.com, mhocko@suse.com, penguin-kernel@i-love.sakura.ne.jp, 
	rakie.kim@sk.com, syzkaller-bugs@googlegroups.com, vbabka@suse.cz, 
	willy@infradead.org, ying.huang@linux.alibaba.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 345C51C0006
X-Stat-Signature: ka18zd9i8mekissdq5rhh4awnb73ahfr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1759081469-86646
X-HE-Meta: U2FsdGVkX1/j+R1MwdviadWvL9IUsgvKzOzpLxsPz+1s29Fqt59ebVk4eCJalVloyZO7OTCq9Hcfa9/XtdRT84OI2sDEyHax3mWmqDP2r/xVwG4LpYP7E4zhsHUmAqvlEY3fLmorRIdsQi/oVXIwxwgnhZ/od2LlTB6grKNUTAuc4pR27ypct/KW+LopVcSdqSKZC+Nb3lzpMIfzQNEHiq5TqD0GWzz3ovuSzkHiZrbcRn6KB83o1CYPNiSnhvlTn5Mwg09KitgbBBqVcZ5/MBVHT7bdYWEcwz9gKZ2XVWDjOgfhNkVnAiOYxUmfVD6Y38SRQJRNXsmbBIj7UezEOZzon1/IFb8aJz/ev4vc4hfpGet5q0/vDxKyHB+aFlqxpJxA0dBYAtbYp1XpUfTN7Cd3kz52IJlsBRay1hIz3Kuv/N3d/HCNvdFWsXH3LkBj3e9P/vQCzRHcaSYPrG8xTsb6/DrPCx+/B6Z2WjFxTMbOsEJng60rhfUWHVXUtiXsWtgpt6t/8Nfsu6vnwFspbcKQtHwsvSVu5B8oUvdZYBnmwDZkGP59pwm1ugO5ofVbBb6MDqe/PAmkGQng0rCLZ4+0zPKRqcd6BOQfw/YVLHhF3fIykOoiIkx6VpbTVRnmDoiOtuCFaFonjXUvi2Yy7HD7C1A0pQRbKejqvjhX7yep6+iU+YTFKSS03voa1Gpq943+2pAbVOemCOA0VMV4bwVtvtxZVSTe8N+C+QTwwO2dtzP9mSOnvGPycewT4bcSEyqSfp8HcusYoYdOdlcjMBz/ESxf4RCDISLn4eXZ1olEpT0OOD47oTk+LwrFTKdxhpIueLu1jjve5FV2OGt/kA0HpesLPda0028kPAp4NoqiArwWcmHDDopM449qsbEWDS2uSXr2y7HlBR9lcaBbylnZX9aAEBo9HQhm8kui5Uhw4YN7bvtqIwvbz+WoEcyVTtVQHBy7yFAL4Xo1V17
 TLfAGD8X
 rmxkYcYUqvNE1g9bnqVn3OK1GRYYDy9IKiMduXv99SjsoT1H5++U4T7nXicLWXM0TTxBO+1kFiUgC6R0mKfJYYQ/7n7QT4APv1jPJlvAClmDImrdre5swgDrjVXrUwP5bENydUBJChlFubiuHYwUvLS43WwWp/DLsIlQGEGElAxUhpHoD+MVYjtsDJkn4GceSD8ZdrOw9rWWmgBU7vc+s6pRk6Y3tOdaGK6rmpI76razG4tlyb6zoA9rebrYJPtainR4YF91IbfOpS9hOwDINlpYsV8F9b8pwopjFwp4/8q281Eecuq1BT/V6D3jAtcUis4HUhudNrhswmRocQoFLMTzvLiwzDYHTslztW+YXeoFw7BFOCWsxHsPhubiEnXjxSXYtpgJ/Tk8T9im4MJxSqNZYU2gPARz/gP0wwzQinEZATNDYFj8Sms8+3CaHzjMqKD+C/V4RPLeA0qE0HRo/8ZcI5orTnt9bgVnZtFcGdwWgAopHySfgujqJ7HpRo9id1JybEsUi5sJ5xIfD7C/qhkrFpwAEg2WNnV1TeNGPfiJnQvixOgFiTNF5HLwp3MKlwAn4gNmBcNm+gU2CKS8I7ub/oremDj6N5iyvRkv/fiWiplflM6t5iYj65ekJjE8aStPXo3fShq4RNheV/an9M00pds9dEOZ0jk0vSOksXaGa98tQzL97xXlbdcbqDoXNmoqN+L/5Dgum9PgaoH6KY1K4T/5F0woW6uBxdVsaV7zAYphulEmpg068nRWyMlRrudStKiez0y8RblWr/mQkSUOqxWJOHUexL3Yk+NvifipLSnEsbCmz8eswAZQCUaf8xeTBguK14YYARyM1jXrWNWlCVjTqreMOvMVqFmWNcjkQTJBM5z70WauAR5biFyNAzvU/BR3erkpXjccvbZMsysTBa3VGB9dSBdCGnR0UK0HDjajzPnrGVuXQ/hjcJZ9HLQPmyL4kv5C22kS/myXKwn0SB413
 hiaUp+LJ
 /DDno3y0mkWWsaqIP+j+3nKzoe2VDhn79lfr46o/CYSmQ8GaL+u6Axhkeutf4TZQMqHSgwX0D+PfuL3mLYeYNw6QJl5OvwXGUbz4DIAwgoRfTUx4zFPtoxaYx9HpabGFEqkedALl1gLmGqEsIErcrvODpeWZJl49z0H1sSPrJTZdBSfJFjRvLx3RA3jZw8uadtnAWAtkNEtBSNxBPliL6FSlIFV6ijTbgW7p4VGeBcGx4OzgxUqvN3Cv8ev43bdXV4nbab0cRL39BPbGHGEGt6IjVEvcyca8SjmVeRFlUjpqloknjvxqvx8WAkCmCDqZOPSsSiD+L4IDh9SuneQT0RYMeVnWyQmBE3B9AHAl2D3cAsYSdHDVlCbom/hArC7TehiF/szsUZv19bTs7zJWabZq7pl34+Zb2QnrFHYnwHDXlM4lMA2R8nbJ6PeVH0aP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    51a24b7deaae Merge tag 'trace-tools-v6.17-rc5' of git://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1268bf12580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bf99f2510ef92ba5
dashboard link: https://syzkaller.appspot.com/bug?extid=359a67b608de1ef72f65
compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a20334580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-51a24b7d.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2d2422223a2d/vmlinux-51a24b7d.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3f33b7e0feca/bzImage-51a24b7d.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/345ccb8f827e/mount_8.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=161e6ae2580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+359a67b608de1ef72f65@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
------------[ cut here ]------------
WARNING: CPU: 0 PID: 6463 at mm/page_alloc.c:4619 __alloc_pages_slowpath+0xcb3/0xce0 mm/page_alloc.c:4619
Modules linked in:
CPU: 0 UID: 0 PID: 6463 Comm: syz.0.279 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
RIP: 0010:__alloc_pages_slowpath+0xcb3/0xce0 mm/page_alloc.c:4619
Code: d8 48 c1 e8 03 0f b6 04 08 84 c0 75 2e f6 43 01 08 48 8b 14 24 0f 84 a2 f3 ff ff 90 0f 0b 90 e9 99 f3 ff ff e8 3e 9e 64 09 90 <0f> 0b 90 f7 c5 00 04 00 00 75 bc 90 0f 0b 90 eb b6 89 d9 80 e1 07
RSP: 0018:ffffc9000e2ff8f0 EFLAGS: 00010246
RAX: 97af8c55b4e88b00 RBX: 0000000000000002 RCX: dffffc0000000000
RDX: ffffc9000e2ffa00 RSI: 0000000000000002 RDI: 0000000000048cc0
RBP: 0000000000048cc0 R08: ffff88805ffd7297 R09: 1ffff1100bffae52
R10: dffffc0000000000 R11: ffffed100bffae53 R12: ffffc9000e2ffa00
R13: 1ffff92001c5ff3c R14: 0000000000048cc0 R15: dffffc0000000000
FS:  00007fb4ec9696c0(0000) GS:ffff88808d007000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb4ebb72b60 CR3: 00000000516af000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __alloc_frozen_pages_noprof+0x319/0x370 mm/page_alloc.c:5161
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:2492 [inline]
 allocate_slab+0xd9/0x370 mm/slub.c:2668
 new_slab mm/slub.c:2714 [inline]
 ___slab_alloc+0xbeb/0x1420 mm/slub.c:3901
 __slab_alloc mm/slub.c:3992 [inline]
 __slab_alloc_node mm/slub.c:4067 [inline]
 slab_alloc_node mm/slub.c:4228 [inline]
 __kmalloc_cache_noprof+0x296/0x3d0 mm/slub.c:4402
 kmalloc_noprof include/linux/slab.h:905 [inline]
 kzalloc_noprof include/linux/slab.h:1039 [inline]
 xfs_init_fs_context+0x54/0x500 fs/xfs/xfs_super.c:2278
 alloc_fs_context+0x64e/0x7d0 fs/fs_context.c:318
 do_new_mount+0x16f/0x9e0 fs/namespace.c:3787
 do_mount fs/namespace.c:4136 [inline]
 __do_sys_mount fs/namespace.c:4347 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4324
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb4ebb9066a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb4ec968e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fb4ec968ef0 RCX: 00007fb4ebb9066a
RDX: 0000200000009600 RSI: 0000200000009640 RDI: 00007fb4ec968eb0
RBP: 0000200000009600 R08: 00007fb4ec968ef0 R09: 0000000000200800
R10: 0000000000200800 R11: 0000000000000246 R12: 0000200000009640
R13: 00007fb4ec968eb0 R14: 0000000000009644 R15: 00002000000002c0
 </TASK>


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

