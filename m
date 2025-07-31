Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD047C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 14:52:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9756B0092; Thu, 31 Jul 2025 10:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C17C6B0095; Thu, 31 Jul 2025 10:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FE586B0096; Thu, 31 Jul 2025 10:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 429AF6B0092
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 10:52:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 10CA01A06F5
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:52:37 +0000 (UTC)
X-FDA: 83724851154.08.4D0BF2C
Received: from mail-io1-f79.google.com (mail-io1-f79.google.com [209.85.166.79])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8F93B1C0005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 14:52:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 3MoOLaAkbALEjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=3MoOLaAkbALEjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753973555; a=rsa-sha256;
	cv=none;
	b=Nfpt/DHVCd+X2KJSKc2KOaeTbOR857uF8Mk4pMzyVnPVODwpuhvGK3IcUsTn439XoTx9/C
	YS000/2VAXVIn7cVk8VqnrJMRQ1Ds3UxUsCiMgC1gln9obLc8udd+gOZSv87iCdNMLOa1g
	7VTEI4Fz+BWsROgV7c7Fq7vDc3DJXlo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf20.hostedemail.com: domain of 3MoOLaAkbALEjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.166.79 as permitted sender) smtp.mailfrom=3MoOLaAkbALEjpqbRccViRggZU.XffXcVljViTfekVek.Tfd@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753973555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=Ymwzw1M9GyTwkEtdG06+DHmrfOOeM02MHVcedVv5kx8=;
	b=z3u9CJHOWSCzLV6iCLTXAzqApePbTSaNxltCybRjykaV6NDimo0uNW4cvaLEU2F2G1K2Aw
	DV76BnK2nHglW5GDGXtvDLT7RpSWJTnOhpZuYnjNO99p1f8aNA3TMXkKhovuerm8qDR4Tc
	Mjm9LZIEKv79oqePrylS1XmKN0mpPE4=
Received: by mail-io1-f79.google.com with SMTP id ca18e2360f4ac-87c41047044so208989639f.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 07:52:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753973554; x=1754578354;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ymwzw1M9GyTwkEtdG06+DHmrfOOeM02MHVcedVv5kx8=;
        b=Wc6sGh8N7nvDD00AMRbfsVw0HS7C6qF20nNZQdIYKLoZ/iQBN8yhkE6GxaQMi02uHy
         01Eeg5vLHyhb9CFgSl/CTJbkaz+Y12misAH+lS4H0k8qqeTonKq31Om/vz1Wt8ABJeB5
         k3fXTp+mk2HVnSNGog/YXENoCEJ2Pq4Rr6QExmz7CFte5xQcURqa4PL1XFIiuf2u+8gn
         aLXmr9xP0YU0/mWt7CtYrEJQiRH7plCp9QdRZNtKt8MT6ZIYqiLe4gsYTjv/Ew+vN+B+
         YU2SKtiLo4vm2JbT3uTMdG5tIjx+pENHzB/TAqTnBZJPRoqgJ5YGDQ7eRtyng8ZAkSFn
         Ngzg==
X-Forwarded-Encrypted: i=1; AJvYcCWMLiWtviVEqe8mDxbciUDaCf/fsYabwIkQ33+UHN7NeEnhs/RAPn9EwBBy/8MrA/PlegfonaT7lw==@kvack.org
X-Gm-Message-State: AOJu0YxRKxmzNIyGC0EmUwgNR6moDXTtsoU+uMVlAoKvGhTI6WWFVf8x
	Y7jEOgZAh8wGk3wRdj8t1lOaWvE9Ie9UCHzRSeExhWRe8OE1o0wVt0hvl8kE0v2Vdz6uj3F+RqG
	CBx3SZOApdS2aULFVQbPcq5CszM7snz3exx26A286D0t+sZbYUBBwBPYECDc=
X-Google-Smtp-Source: AGHT+IG25XfNbNYUv28uJ3XUFspdMt70vNFmzQpYG4SVQz9FyRSMrC4L9Ta/bpkNQYeWCsCnyUrA/9iX2K79azVp/cNTsBE28sJ/
MIME-Version: 1.0
X-Received: by 2002:a92:cb83:0:b0:3e3:e732:aef6 with SMTP id
 e9e14a558f8ab-3e3f62802e9mr126564965ab.18.1753973554618; Thu, 31 Jul 2025
 07:52:34 -0700 (PDT)
Date: Thu, 31 Jul 2025 07:52:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688b8332.a00a0220.26d0e1.0044.GAE@google.com>
Subject: [syzbot] [bpf?] WARNING in trace_suspend_resume
From: syzbot <syzbot+99d4fec338b62b703891@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, andrii@kernel.org, ast@kernel.org, 
	bpf@vger.kernel.org, daniel@iogearbox.net, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: hufjqzyzzchhwfibo5arnadk4d9s4chj
X-Rspam-User: 
X-Rspamd-Queue-Id: 8F93B1C0005
X-Rspamd-Server: rspam02
X-HE-Tag: 1753973555-949487
X-HE-Meta: U2FsdGVkX1/g6v7+EPlyvTbswZj+I6cGqlbC8J+Z2rdPa12yAi8tqmybDnXzeHXcpsA+gj5qltzPobE07XaPNYxLWqxh4E3WSdK64cKFoTiXzO7cY14NHpPmr6yoo7rKqNHYKTD9iGrEXLjYaNU0N96Dmus7m/K2g9dpgqKXKyHXXbjnK+8R0MklZFihpKKV97EjO6OGrPS4HF5ms/RXcHeyWjOMRddpJcAxs0/pppfvfuBD0uDNn7rNRyGJmQq8ALIfH/6/hdFFCCs3b+fb+OwFo1YSXCdDgO+D//zydGBeBJTfpezQ/7Qo6k211/VkfpuQCU5GdZ+dvh/ibutADWgpgB+6MPTGRygcxp1RxqOdezezTfE8GgedlIvThnlIrEHhiqYScmD9JO4f2K917x1P4oBoIg2fe5I8pyuATBA9tOfkpqeUOnyRn7jEfGO0LohhyfeXbMCs8wlWPS4DA12anXEQlFIFqqpSFTBoHYC5/gTcdTklpUbB+YgCCVbimtmQkKlJ7wYlAcCLCKElj0s1VnHxn2vIkuPWrdstvjuozn/5lJX0+aZNGOj4DujCOIXbMdrtzQ7h7qF1hAZFqdN4hhtVrUziXaqBFVwGNBTRBgXCuwhu/P7auQtPlQgaHFCwUPjIv5SyaFszbW+OsCnYjyfJZ6KN2Icea1eRfZvD0dEK72+XELu6umQBLsur4iuskbXur/OnkiXHr7AmXMdUTsDA1Kk3JFoKzJA5kOGd9UOiNR5RLaeDPfb747aPSfLO4pX3rS0y7YO48yUhTt5GLt3a10Bd5xfhYyF+pj1DzRhDC4XThiTmFL1K6OSAc2ECFJvfEPkhftkTi8cDrkz60DvK2f7yBNgmBc1OOjaWD3E3Nj9MUiZi7JJ5hXqH9NLy474mcDUWFxN039iBm5Y/3QiAjoe+QKTBU5Jth3uyb7l5q48gkqZywnRpz1eVSvOTHad6lWYwsnBGGX1
 WUdQ0Czr
 TwCIVmfg5hoYiTnoPP3VgUkrLfHd1SB6FcgokJbmFVHViO0V/EECGG9QpzvY/I9Fz6/UQMhXAwYY9SR0jSfOG9HiKbVFsLbSBVG0gvCk4MNF/bd7aODGXWwRy2ntlRW7xRlb+D4ZpThRENVqPROKri9DZzubi2dLYJe3K7hrFXReRnKMOZsSO68Y2Jy/DwRHgLR3I31UDgrJLCVrW/vPYnBWyOjrN98seO/RwahIAk4B9wjWiDLRL7YEFDTRaepTITGeI6RR15jkhJ3pv39Qzdh109rSZ8oCQ20nWzm5SGhUbqRUO5xZ44iKR5pYU7T9HvDS+Rv5A1Uh1tEU2kMoUCY91Pdz5J+yt36hqeekE6e44cHZjp5F9F0ndvDYGJc2/S8W4/Wb7N6LYDyXDydhNmIAfg9cXmT1+RZJ6xTeFmwNfzF7z3ApUixU3FIsALhMdXn2nS32jKmP+b85yFUAU1AiXRJDF8joNXEmzOWKxtBcU0RnEeU2sA9uZEJLbsK2ViPwOk7q1lejurPo1MufJbRhrEtHeubzQv0t6UW2eo79iezz67p7kOoPwm31vm5zbJVdBCXtmZYn7R4mM+rxiGPlngoZ0/+7SRQP/kl9HdC7jXzyIbIV+s/j8bo47vuOEecHjUWJFGHGo4BoMgwRsdMIpfCg+0hl2NVNeSV91Vm8yMjfRmm6BLfR1F4ETh0wR8YUesD+KG2YRM9o2Ol7QCm8b2D241vaqpwjvWCpAgaAQ8zk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    260f6f4fda93 Merge tag 'drm-next-2025-07-30' of https://gi..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=102f69bc580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=af26dbd5a30735
dashboard link: https://syzkaller.appspot.com/bug?extid=99d4fec338b62b703891
compiler:       arm-linux-gnueabi-gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
userspace arch: arm

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/98a89b9f34e4/non_bootable_disk-260f6f4f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/091b40479433/vmlinux-260f6f4f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/54ef37cd1da7/zImage-260f6f4f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+99d4fec338b62b703891@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 4102 at mm/highmem.c:622 kunmap_local_indexed+0x20c/0x224 mm/highmem.c:622
Modules linked in:
Kernel panic - not syncing: kernel: panic_on_warn set ...
CPU: 0 UID: 0 PID: 4102 Comm: syz.0.84 Not tainted 6.16.0-syzkaller #0 PREEMPT 
Hardware name: ARM-Versatile Express
Call trace: 
[<80201a24>] (dump_backtrace) from [<80201b20>] (show_stack+0x18/0x1c arch/arm/kernel/traps.c:257)
 r7:00000000 r6:8281f77c r5:00000000 r4:8224af5c
[<80201b08>] (show_stack) from [<8021faf0>] (__dump_stack lib/dump_stack.c:94 [inline])
[<80201b08>] (show_stack) from [<8021faf0>] (dump_stack_lvl+0x54/0x7c lib/dump_stack.c:120)
[<8021fa9c>] (dump_stack_lvl) from [<8021fb30>] (dump_stack+0x18/0x1c lib/dump_stack.c:129)
 r5:00000000 r4:82a6bd18
[<8021fb18>] (dump_stack) from [<80202624>] (vpanic+0x10c/0x360 kernel/panic.c:440)
[<80202518>] (vpanic) from [<802028ac>] (trace_suspend_resume+0x0/0xd8 kernel/panic.c:574)
 r7:804bdb5c
[<80202878>] (panic) from [<802548dc>] (check_panic_on_warn kernel/panic.c:333 [inline])
[<80202878>] (panic) from [<802548dc>] (get_taint+0x0/0x1c kernel/panic.c:328)
 r3:8280c684 r2:00000001 r1:82231a24 r0:822393ec
[<80254868>] (check_panic_on_warn) from [<80254a40>] (__warn+0x80/0x188 kernel/panic.c:845)
[<802549c0>] (__warn) from [<80254cc0>] (warn_slowpath_fmt+0x178/0x1f4 kernel/panic.c:872)
 r8:00000009 r7:82265508 r6:df9f9d1c r5:83a93000 r4:00000000
[<80254b4c>] (warn_slowpath_fmt) from [<804bdb5c>] (kunmap_local_indexed+0x20c/0x224 mm/highmem.c:622)
 r10:00000000 r9:deb56a18 r8:debb2f48 r7:00a00000 r6:00000003 r5:83a93000
 r4:ffefd000
[<804bd950>] (kunmap_local_indexed) from [<80538be4>] (__kunmap_local include/linux/highmem-internal.h:102 [inline])
[<804bd950>] (kunmap_local_indexed) from [<80538be4>] (move_pages_pte mm/userfaultfd.c:1457 [inline])
[<804bd950>] (kunmap_local_indexed) from [<80538be4>] (move_pages+0xb24/0x19c8 mm/userfaultfd.c:1868)
 r7:00a00000 r6:00000000 r5:846e9ec4 r4:84add6c0
[<805380c0>] (move_pages) from [<805c02ec>] (userfaultfd_move fs/userfaultfd.c:1914 [inline])
[<805380c0>] (move_pages) from [<805c02ec>] (userfaultfd_ioctl+0xff8/0x21c4 fs/userfaultfd.c:2037)
 r10:84add6c0 r9:df9f9e98 r8:21000000 r7:00000001 r6:00000000 r5:20000040
 r4:85955000
[<805bf2f4>] (userfaultfd_ioctl) from [<80568ccc>] (vfs_ioctl fs/ioctl.c:51 [inline])
[<805bf2f4>] (userfaultfd_ioctl) from [<80568ccc>] (do_vfs_ioctl fs/ioctl.c:552 [inline])
[<805bf2f4>] (userfaultfd_ioctl) from [<80568ccc>] (__do_sys_ioctl fs/ioctl.c:596 [inline])
[<805bf2f4>] (userfaultfd_ioctl) from [<80568ccc>] (sys_ioctl+0x130/0xba0 fs/ioctl.c:584)
 r10:83a93000 r9:00000003 r8:85935840 r7:20000040 r6:85935841 r5:00000000
 r4:c028aa05
[<80568b9c>] (sys_ioctl) from [<80200060>] (ret_fast_syscall+0x0/0x1c arch/arm/mm/proc-v7.S:67)
Exception stack(0xdf9f9fa8 to 0xdf9f9ff0)
9fa0:                   00000000 00000000 00000003 c028aa05 20000040 00000000
9fc0: 00000000 00000000 002f6300 00000036 002e0000 00000000 00006364 76b450bc
9fe0: 76b44ec0 76b44eb0 000193a4 00131fc0
 r10:00000036 r9:83a93000 r8:8020029c r7:00000036 r6:002f6300 r5:00000000
 r4:00000000
Rebooting in 86400 seconds..


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

