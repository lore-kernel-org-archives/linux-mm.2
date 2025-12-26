Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0844E8FDA0
	for <linux-mm@archiver.kernel.org>; Fri, 26 Dec 2025 07:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 94CE46B0088; Fri, 26 Dec 2025 02:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB076B0089; Fri, 26 Dec 2025 02:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806FB6B008A; Fri, 26 Dec 2025 02:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6C39B6B0088
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 02:48:25 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D150B140C92
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 07:48:24 +0000 (UTC)
X-FDA: 84260844528.18.95E5B4E
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf28.hostedemail.com (Postfix) with ESMTP id 21E09C000B
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 07:48:22 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3xj1OaQkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3xj1OaQkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766735303; a=rsa-sha256;
	cv=none;
	b=M7RPs3ly8nvo8p3OdkSZnzwb6hE8pM4ZqSRrel/OPwdaRzFzbpeUO+fQKrwRXBOw8pbt8X
	BosJOvizs0HwB6bUB916WUevrr30XRsBAOlc8aTS3PeS/I8m/Gr6/HZ+/fEOraEfMXUWOR
	QAgBv6hnlchNqwkdu558NbZ6t/rp7qY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf28.hostedemail.com: domain of 3xj1OaQkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3xj1OaQkbAMs9FG1r22v8r66zu.x55x2vB9v8t54Av4A.t53@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766735303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=CMy3W/CORxiPTFsq4jt3wkE5Je3EDF3781UqGbOTHTs=;
	b=KA7ws1L49erq4nckR5vgbXr39+3OdrUKlYNqkPa3LgJiFaX0ehom00KO4Sd5pw/TOdEAKC
	G/zxaSvVDZ9tA6D8oA9ZryPH58NPfX40Ap3mRNOQddtLm0c7tYeXYdOzaUcHVpYUnVyOW2
	0SCKCC5AQp+u7N3KOwHyLkmbuobjvQM=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-65d0318e02eso13138556eaf.1
        for <linux-mm@kvack.org>; Thu, 25 Dec 2025 23:48:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766735302; x=1767340102;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CMy3W/CORxiPTFsq4jt3wkE5Je3EDF3781UqGbOTHTs=;
        b=sYAguWCfQw62NdzVlEqLGA7bzRAcaKiKeVCojhsPmmQHA+TH7VtZxaMWsZcbf9Pp1Z
         kK3K/pKofs0Us/9HcebJdIEWJZdbAE4o7+rvXLDvXdAi/CP6ra2Psep+DhkmRv3nQGAU
         7gwf3Xh7/FgxlIWRS+v2jh0QeCbY4P4BMA4PDjXJtwpMvu5MWOUkdZY54MHHAa6fEBdy
         8dD1cRwqGakbQC52ELH+G1TMu7jvPbSodD5IaxAMkko8M2Yz2/MespuCUID/jbKr0zL6
         I0t0tEKQhIGz8hRxl+ABUjbsqM3MoOvBI4Ce+AyWS55swvTaUaG5PKnulnvM97i9kHAB
         tHSw==
X-Forwarded-Encrypted: i=1; AJvYcCVWHo5EoeHVJaxgVHDjkiHjxpcavZ+zksuzIdJybkMUZc97I6OC4AlgAErARmyUQ9B28PUl/cqL8Q==@kvack.org
X-Gm-Message-State: AOJu0YzPNC6jmMqgG1aUAeORLw+zVh38ZxYE33OlxzFx/9AC6dCat/yE
	rTJFvFZ8b+1/QEcN6b9i/g8zj0L0bud1iLOgXdhnFsNkhJNmgQ5mzFYNmW6az5kRMxtqlLn1qr7
	wdsdFSeudCiXiF8BswMfJYEszlWHzuQir39uyIYISsnHUUYSryZiCLbPbUvs=
X-Google-Smtp-Source: AGHT+IH1NY8Zt9tx7FYAckbZHV+pQwHwwUGxDAagAWw6J2MkFWBCCkzBWSXXsAZouDArZ3jblJxKhnm/WqdIaDUzXSJIo846l3hH
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4814:b0:65d:697:2d52 with SMTP id
 006d021491bc7-65d0e9f049fmr6272282eaf.37.1766735302191; Thu, 25 Dec 2025
 23:48:22 -0800 (PST)
Date: Thu, 25 Dec 2025 23:48:22 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694e3dc6.050a0220.35954c.0066.GAE@google.com>
Subject: [syzbot] [mm?] KASAN: slab-use-after-free Read in folio_remove_rmap_ptes
From: syzbot <syzbot+5272541ccbbb14e2ec30@syzkaller.appspotmail.com>
To: Liam.Howlett@oracle.com, akpm@linux-foundation.org, david@kernel.org, 
	harry.yoo@oracle.com, jannh@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, riel@surriel.com, 
	syzkaller-bugs@googlegroups.com, vbabka@suse.cz
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 21E09C000B
X-Rspamd-Server: rspam10
X-Stat-Signature: 7y6iww4ufna33byh6kefer8d3qyxkomb
X-HE-Tag: 1766735302-964742
X-HE-Meta: U2FsdGVkX1+FMCZeeZXdZXrAwLQEpUA3pQBuOvdRVhM60AHKWdqGaNLDhXRlkYG3xZ4T9iEH0FczIMWI8T6Dw7PQ+KppnjeOoguSWHF0KM/5VoQdxQjzzIGJU144qWxvI1o5U9z3jCm7Vn25gR7IUhDCQjViDSXaaqK7pOsb5eoOpzLApudT3ob2PRgBNphQEjerPRcPF4fg/PAtEf+lKYJd6KyfeOjsLA0YB008zjziRV+rfsVJCYlxh1007YXrGSM7z246bWrIV0DE6aiJK+axAZAXwtf4Jaj8MCAWT9BqjjhHcpjUuttXHOD4kVk1928WGIulQ8bpm7gybVyoW4+V/1enmaBu3cm0mT8G39qFjZIiFeiC5U5HXIB41gf/RjQXj1GKqCtXtxQQcZPLQdhwx6TDf5l1UWoT8p/DyTsBNmSeJH0zpG/FGYlC1ZaX3AFqetZQacjHYhaKq9/7zNPh0ObN+jxoMoCt88jfFRxPCF0dOZ5QtNEKOORD86rCpVU8nx1+cQD42mLrZUy3lLEV/F80VlLTKQ1c+L9GXKMZaAjyjlvlFtinm7ao9SM4SL+o6foRsYWmyTGOQUp2k5PrViolxZlSeqK+wNnDqxh+1BBhXB01jAD27ld9U/cVXrkuJWUcROQbia6+2Y8+O1NATIEAiedzv8qVB1HTmVB4aNoPc103N4sJGfK4Wmejc0hQ2WEf794QZ8mG9orApApxOr53e16w/tzL/Cg2K3ozgZS4itFyQfOVsCZ+hbFte9f24TxxjdiTJCPfGinv7cyspipqos6/NW7+901f8tFsrT7zCf3fLXm876SVGjng3jm42kNtQNiauF2xeyraIqDLfqmQx8hiKC0lxuItyu06dcRnqmYwqsLcszfJA+iaqMaVVi2/7kdA9Nk0aQhDLuN08eU5yLX8L9KsPgzU5xh7wE4ltNWHjx/qLm3dOqL5a3Hbif+lOIXV33uGFDk
 UFwKMPQQ
 QpGnObr8iepb59W1T/8z5ij+s6AJO1lwIqUrt7sQ0ALH/RquOfJ8fL4wXhQOaVypjKHVSl3nsxNElZ9cWZzafDqFGDouxwtzfZUHUJtR0Xn2AP3qU/I66ZUwxUyvU5/Uhy31aPQdQSeWPbNIX8ySeFeURgobsl4faBH/26T1YmxxGP4raOV9V9QhilRQsNfWJp4ILuM9v7rfzMp+7mV/hAcHIuIt5dT90x6rGINxrDoaqDoOZ6Gg+HICFuvhvGYguwTRuvQXBdUDi+mHvKTSVfwMNZaCz0Z2XxDrVUgVN1I4G3D2kdPB7Z4AeeqSXvM49KsDSBAbvblRmnCcntWwKxfBoispibNIOqQcK2Z5B1i426FdH4+7JvitmtHWFcomCBi8bVSbkp1xsyzqxDVoRvrd5vrBUJBUoUkl3NiH6Y/tHiVjTwDkdmwD5R1skElfH1bmD+H7HfIRdqIjObRI1mlbYg4VzTHfZ7eQoipQv8EcwlrSCbp6flbs3rL+VUvhqV+A0mpqDcaXm/QscQsVw/mIRNAWq0hWc+aiH+Vkw4x15LxW3Y9kiBArrYW9b9plB46OVcdCjjZl5WCGQBqodkI8Cbacif8gmMWRqnAE/wPZdgw+ZZ9bSUJP/xMYuJ0iEvGT4oeiG5aaXLBl8SbLLl/0CaO9V8NMwaBlBqbH00rsCyjPRzBPYEKzbLFXjxMMLgis3aY4pXShLnqoLlCy4/QnUmqRuqDBX8/y9SVRxjzE4S/szEAlJlRc+koU+H262GXxN5Xaqh1NeRw6dNC8VvJi84HqndMJKFyCc0b3utvyuRmQtdm6n6aUjHr1/rCl4w+j7cG8hKNxpUMeFWkY5nPcsN0JL3AIAszT6sJlKq2/3E9NNfZAjWoU1y6WJsgfjMconlAfnB7tGBLXI4u7sYa90WI6waKWZjjT3wuWXvF4CL/MuihfyJCSoy3e14YuZ7RLwPnLhNzf1stFQQ3Z+q6aPTlbi
 wCbrnqqs
 0r9QXJmQ7EgjCkIVvAhcKSS3k39zNhoL3LpYFpbYGfiofVJKSBM79/6MEgwd5l9PwhdawuNbt1JpFEpobZ27ICgdXqQa54oI1p/zXYySUClwbH6Ebhvd0CU6UpzRh3vumxnn+p11TlNUJzmaqBmhRJnydZyWsjTR7Uq/jVAKL9sw7ZyYY++IzGv68YMmja0IAqcOuNs2xKlPzDFBWEMmUKBpaPH2xTbm4waXVO8W6DxXsgX4l4I3iRWB6RTtIBjhGpaI6uy198cBl3GGxv4koU16RPhA27fMHbNLy8+f0KI0WWFqYALyNB3UP9uZ8dGVVIM8udSAm7MUi9p3IOmIFlcwHWvslnn3t3vG3rQ4MRmIpsCvWYmUXvHSIFEOsF2zLnwav2ozZ94c1ynNhdoaf1Fi+wwXJriEhRHgngltkmaQ7hiLyYiCQ5RHdPRInBLj2fSbLGgnN3k5CpAIrHhNDgrClrP22ZrIc0o7Akhps8Fia+q49pB5We0A7K8URaOp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    9094662f6707 Merge tag 'ata-6.19-rc2' of git://git.kernel...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=17c4db1a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a11e0f726bfb6765
dashboard link: https://syzkaller.appspot.com/bug?extid=5272541ccbbb14e2ec30
compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-9094662f.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/5bec9d32a91c/vmlinux-9094662f.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3df82e1a3cec/bzImage-9094662f.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5272541ccbbb14e2ec30@syzkaller.appspotmail.com

uprobe: syz.3.982:12970 failed to unregister, leaking uprobe
==================================================================
BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux/instrumented.h:68 [inline]
BUG: KASAN: slab-use-after-free in atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
BUG: KASAN: slab-use-after-free in __folio_rmap_sanity_checks include/linux/rmap.h:462 [inline]
BUG: KASAN: slab-use-after-free in __folio_remove_rmap mm/rmap.c:1663 [inline]
BUG: KASAN: slab-use-after-free in folio_remove_rmap_ptes+0x245/0xfb0 mm/rmap.c:1779
Read of size 4 at addr ffff88802407b1a0 by task syz.3.982/12970

CPU: 2 UID: 0 PID: 12970 Comm: syz.3.982 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xcd/0x630 mm/kasan/report.c:482
 kasan_report+0xe0/0x110 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:194 [inline]
 kasan_check_range+0x100/0x1b0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
 __folio_rmap_sanity_checks include/linux/rmap.h:462 [inline]
 __folio_remove_rmap mm/rmap.c:1663 [inline]
 folio_remove_rmap_ptes+0x245/0xfb0 mm/rmap.c:1779
 zap_present_folio_ptes mm/memory.c:1650 [inline]
 zap_present_ptes mm/memory.c:1708 [inline]
 do_zap_pte_range mm/memory.c:1810 [inline]
 zap_pte_range mm/memory.c:1854 [inline]
 zap_pmd_range mm/memory.c:1946 [inline]
 zap_pud_range mm/memory.c:1975 [inline]
 zap_p4d_range mm/memory.c:1996 [inline]
 unmap_page_range+0x1b7d/0x43c0 mm/memory.c:2017
 unmap_single_vma+0x153/0x240 mm/memory.c:2059
 unmap_vmas+0x218/0x470 mm/memory.c:2101
 exit_mmap+0x1b0/0xb60 mm/mmap.c:1277
 __mmput+0x12a/0x410 kernel/fork.c:1173
 mmput+0x62/0x70 kernel/fork.c:1196
 exit_mm kernel/exit.c:581 [inline]
 do_exit+0x7d7/0x2bd0 kernel/exit.c:959
 do_group_exit+0xd3/0x2a0 kernel/exit.c:1112
 get_signal+0x2671/0x26d0 kernel/signal.c:3034
 arch_do_signal_or_restart+0x8f/0x7e0 arch/x86/kernel/signal.c:337
 __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
 exit_to_user_mode_loop+0x8c/0x540 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x4ee/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2c0938f7c9
Code: Unable to access opcode bytes at 0x7f2c0938f79f.
RSP: 002b:00007f2c0a231038 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: fffffffffffffffc RBX: 00007f2c095e6090 RCX: 00007f2c0938f7c9
RDX: 0000000000000040 RSI: 00002000000003c0 RDI: 000000000000001c
RBP: 00007f2c09413f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2c095e6128 R14: 00007f2c095e6090 R15: 00007ffd86729c78
 </TASK>

Allocated by task 12971:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_save_track+0x14/0x30 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:339 [inline]
 __kasan_slab_alloc+0x89/0x90 mm/kasan/common.c:365
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_noprof+0x25e/0x770 mm/slub.c:5270
 anon_vma_alloc mm/rmap.c:93 [inline]
 __anon_vma_prepare+0x344/0x5e0 mm/rmap.c:201
 __vmf_anon_prepare+0x11c/0x240 mm/memory.c:3673
 vmf_anon_prepare mm/internal.h:432 [inline]
 do_cow_fault mm/memory.c:5775 [inline]
 do_fault+0x18b/0x1ad0 mm/memory.c:5891
 do_pte_missing mm/memory.c:4401 [inline]
 handle_pte_fault mm/memory.c:6273 [inline]
 __handle_mm_fault+0x1919/0x2bb0 mm/memory.c:6411
 handle_mm_fault+0x3fe/0xad0 mm/memory.c:6580
 faultin_page mm/gup.c:1126 [inline]
 __get_user_pages+0x54e/0x3590 mm/gup.c:1428
 __get_user_pages_locked mm/gup.c:1692 [inline]
 get_user_pages_remote+0x243/0xab0 mm/gup.c:2614
 uprobe_write+0x22b/0x24f0 kernel/events/uprobes.c:529
 uprobe_write_opcode+0x99/0x1a0 kernel/events/uprobes.c:493
 set_swbp+0x112/0x200 arch/x86/kernel/uprobes.c:1090
 install_breakpoint+0x6a4/0xa20 kernel/events/uprobes.c:1170
 uprobe_mmap+0x512/0x10e0 kernel/events/uprobes.c:1629
 vma_complete+0xa09/0xe80 mm/vma.c:397
 __split_vma+0xac3/0x1050 mm/vma.c:561
 vms_gather_munmap_vmas+0x1cb/0x1340 mm/vma.c:1362
 __mmap_setup mm/vma.c:2366 [inline]
 __mmap_region+0x47c/0x2a00 mm/vma.c:2690
 mmap_region+0x1ab/0x3f0 mm/vma.c:2786
 do_mmap+0xa3e/0x1210 mm/mmap.c:558
 vm_mmap_pgoff+0x29e/0x470 mm/util.c:581
 ksys_mmap_pgoff+0x32c/0x5c0 mm/mmap.c:604
 __do_sys_mmap arch/x86/kernel/sys_x86_64.c:89 [inline]
 __se_sys_mmap arch/x86/kernel/sys_x86_64.c:82 [inline]
 __x64_sys_mmap+0x125/0x190 arch/x86/kernel/sys_x86_64.c:82
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 0:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_save_track+0x14/0x30 mm/kasan/common.c:77
 kasan_save_free_info+0x3b/0x60 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5f/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2540 [inline]
 slab_free_after_rcu_debug+0x10c/0x300 mm/slub.c:6729
 rcu_do_batch kernel/rcu/tree.c:2605 [inline]
 rcu_core+0x79c/0x15f0 kernel/rcu/tree.c:2857
 handle_softirqs+0x219/0x950 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0x109/0x170 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1056 [inline]
 sysvec_apic_timer_interrupt+0xa4/0xc0 arch/x86/kernel/apic/apic.c:1056
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697

Last potentially related work creation:
 kasan_save_stack+0x33/0x60 mm/kasan/common.c:56
 kasan_record_aux_stack+0xa7/0xc0 mm/kasan/generic.c:556
 slab_free_hook mm/slub.c:2501 [inline]
 slab_free mm/slub.c:6670 [inline]
 kmem_cache_free+0x15e/0x770 mm/slub.c:6781
 anon_vma_free mm/rmap.c:136 [inline]
 __put_anon_vma+0x114/0x3a0 mm/rmap.c:2780
 put_anon_vma include/linux/rmap.h:117 [inline]
 unlink_anon_vmas+0x58a/0x820 mm/rmap.c:443
 dontunmap_complete mm/mremap.c:1265 [inline]
 move_vma+0x14de/0x1790 mm/mremap.c:1314
 mremap_to+0x1b7/0x450 mm/mremap.c:1416
 remap_move mm/mremap.c:1890 [inline]
 do_mremap+0x13a8/0x2020 mm/mremap.c:1933
 __do_sys_mremap+0x119/0x170 mm/mremap.c:1997
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88802407b100
 which belongs to the cache anon_vma of size 208
The buggy address is located 160 bytes inside of
 freed 208-byte region [ffff88802407b100, ffff88802407b1d0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x2407a
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff888021c50001
flags: 0xfff00000000040(head|node=0|zone=1|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 00fff00000000040 ffff88801b44dcc0 ffffea0000f7d080 dead000000000002
raw: 0000000000000000 00000000801e001e 00000000f5000000 ffff888021c50001
head: 00fff00000000040 ffff88801b44dcc0 ffffea0000f7d080 dead000000000002
head: 0000000000000000 00000000801e001e 00000000f5000000 ffff888021c50001
head: 00fff00000000001 ffffea0000901e81 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 1, tgid 1 (init), ts 24478689872, free_ts 23304373426
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x1af/0x220 mm/page_alloc.c:1846
 prep_new_page mm/page_alloc.c:1854 [inline]
 get_page_from_freelist+0xd0b/0x31a0 mm/page_alloc.c:3915
 __alloc_frozen_pages_noprof+0x25f/0x2430 mm/page_alloc.c:5210
 alloc_pages_mpol+0x1fb/0x550 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab mm/slub.c:3248 [inline]
 new_slab+0x2c3/0x430 mm/slub.c:3302
 ___slab_alloc+0xe18/0x1c90 mm/slub.c:4656
 __slab_alloc.constprop.0+0x63/0x110 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 kmem_cache_alloc_noprof+0x44d/0x770 mm/slub.c:5270
 anon_vma_alloc mm/rmap.c:93 [inline]
 __anon_vma_prepare+0x344/0x5e0 mm/rmap.c:201
 __vmf_anon_prepare+0x11c/0x240 mm/memory.c:3673
 vmf_anon_prepare mm/internal.h:432 [inline]
 do_cow_fault mm/memory.c:5775 [inline]
 do_fault+0x18b/0x1ad0 mm/memory.c:5891
 do_pte_missing mm/memory.c:4401 [inline]
 handle_pte_fault mm/memory.c:6273 [inline]
 __handle_mm_fault+0x1919/0x2bb0 mm/memory.c:6411
 handle_mm_fault+0x3fe/0xad0 mm/memory.c:6580
 do_user_addr_fault+0x60c/0x1370 arch/x86/mm/fault.c:1336
 handle_page_fault arch/x86/mm/fault.c:1476 [inline]
 exc_page_fault+0x64/0xc0 arch/x86/mm/fault.c:1532
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1395 [inline]
 __free_frozen_pages+0x7df/0x1170 mm/page_alloc.c:2943
 discard_slab mm/slub.c:3346 [inline]
 __put_partials+0x130/0x170 mm/slub.c:3886
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x4c/0xf0 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x195/0x1e0 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x69/0x90 mm/kasan/common.c:349
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 __do_kmalloc_node mm/slub.c:5656 [inline]
 __kmalloc_node_track_caller_noprof+0x30b/0x930 mm/slub.c:5764
 __do_krealloc mm/slub.c:7014 [inline]
 krealloc_node_align_noprof+0xfb/0x3d0 mm/slub.c:7073
 krealloc_array_noprof include/linux/slab.h:1034 [inline]
 add_sysfs_param+0x19c/0xa10 kernel/params.c:663
 kernel_add_sysfs_param kernel/params.c:812 [inline]
 param_sysfs_builtin kernel/params.c:851 [inline]
 param_sysfs_builtin_init+0x307/0x4c0 kernel/params.c:987
 do_one_initcall+0x123/0x680 init/main.c:1378
 do_initcall_level init/main.c:1440 [inline]
 do_initcalls init/main.c:1456 [inline]
 do_basic_setup init/main.c:1475 [inline]
 kernel_init_freeable+0x5c8/0x920 init/main.c:1688
 kernel_init+0x1c/0x2b0 init/main.c:1578
 ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

Memory state around the buggy address:
 ffff88802407b080: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88802407b100: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88802407b180: fb fb fb fb fb fb fb fb fb fb fc fc fc fc fc fc
                               ^
 ffff88802407b200: fc fc fa fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88802407b280: fb fb fb fb fb fb fb fb fb fb fb fb fc fc fc fc
==================================================================


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

