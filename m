Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4E67FB3CE5
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 09:56:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BDE56B0096; Mon, 30 Mar 2026 05:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 595326B0098; Mon, 30 Mar 2026 05:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB326B0099; Mon, 30 Mar 2026 05:56:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 336E76B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 05:56:29 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF8E0C2882
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:56:28 +0000 (UTC)
X-FDA: 84602274456.14.4CB378E
Received: from mail-ot1-f80.google.com (mail-ot1-f80.google.com [209.85.210.80])
	by imf10.hostedemail.com (Postfix) with ESMTP id 10CF2C000F
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:56:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of 3ykjKaQkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3ykjKaQkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774864587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=yxuDKAfUW3Y7GAWNIJw+4bXige/pPgHrw8euvpH8ocM=;
	b=keU7WIve1NORL90AVLlbURDKvJtUZvz86jDcSzoG9fjNjXCFqoLeXdioMyRb0AU3Li2ZXn
	WFITuj/+HezAPlE6mMNy3m6Ai1CsajcAJVThJ0F7P+63bRJtreo6Mkp36AbvK/c4v77vW1
	BVxxFlLbgTl3xgauiWiGHpoI6mM87S0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of 3ykjKaQkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.210.80 as permitted sender) smtp.mailfrom=3ykjKaQkbANkNTUF5GG9M5KKD8.BJJBG9PN9M7JIO9IO.7JH@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774864587; a=rsa-sha256;
	cv=none;
	b=fKy9Om9aLPG3ZJyq8fPeY1x1M+OfDnQPIBf3wWVobaemu/RWN7p6qJ3G7dkff/cQNTulec
	f/Ywg+ha2P1rv5E6lZKXau1tnsK4laAXDZBCH6WCkQ1yNiSmW35BoWY9rbMG81t+DxJsG8
	zwgQUjwKj4k38CRMHhVM6YJjS61GR18=
Received: by mail-ot1-f80.google.com with SMTP id 46e09a7af769-7d7510702e6so11344073a34.3
        for <linux-mm@kvack.org>; Mon, 30 Mar 2026 02:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774864586; x=1775469386;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yxuDKAfUW3Y7GAWNIJw+4bXige/pPgHrw8euvpH8ocM=;
        b=lfoXw2NL04RY9MMc/joffomjOQf2sUQQViJMLaVhlKUcGGlsdLZXbqKP5pla/fHNbu
         0tMVAzZAjSxyT7R+t6Ww0EPjaumLbadTYxiqd/Ka16FSE2h1sYArqVleWw+LeBHyk4Y6
         ibD3k8oZxN4muET3nl//DQnK3RUxpUyxE8uLN/lc7WaILn/cFc6ndj7qAwtdCGf8cPnK
         JOyJNAy0LWvpIcqYDwcnAiD7EtlMhrRjVkXX5ZZZJbKyjbWTXIsAeiNp2vuT9h5DgFFx
         T9+a28rAkeaf1nfKeowhqAKuyUOWGkW0xVbUD6nV0JfZDRkmqu0+D4U5e76hayMBNJJ1
         mEyg==
X-Forwarded-Encrypted: i=1; AJvYcCVT5002xoPJeqlUY9W46XXjadT24Zi7EfNbgSBSM3VbQhBYUX0myAvFW6R1VmmSmzLA/MRjzIToJg==@kvack.org
X-Gm-Message-State: AOJu0YySiKvYLzETM11222PgcN11awQBZvGGK8hYp37bW+0YenUbdrDK
	nR543VRmBCOCT6ckPAf3RQk4FG8IDIC+rQuiXovh0HYW76IeNHAJWAI12ZFWwP2zDuMIn4L1iAk
	cl0Yj3i5xAtdzMUwQmhRhTzd2n6i0D1kSNe3E9atdxjPXqz41C8h3qz9JXgc=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1526:b0:67d:e4e8:5d1f with SMTP id
 006d021491bc7-67e18609035mr6784625eaf.17.1774864586093; Mon, 30 Mar 2026
 02:56:26 -0700 (PDT)
Date: Mon, 30 Mar 2026 02:56:26 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ca48ca.050a0220.183828.001a.GAE@google.com>
Subject: [syzbot] [mm?] KASAN: use-after-free Read in copy_folio_from_iter_atomic
 (2)
From: syzbot <syzbot+6cc93ec9a4035badb85f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 10CF2C000F
X-Stat-Signature: 5shp4m9ojywzep8sgcy7ybtaed6nzcak
X-Rspam-User: 
X-HE-Tag: 1774864586-436064
X-HE-Meta: U2FsdGVkX19nA6W9V8VBA/x78BFChf3I0JQ9LLmUBC6p0Otq98YAfuJFir+mLL0jiOGLnhGKOTvywPyi7fIRk3mAz7ra2q1jVoxCaswE9p5+7b015zuujpAXvIkIN5xSQLNDlh+HGXewP4VQMfI+xk2841g95SC2UHccUVosoeuJhT14XN0/Na6VAD9pULylj82DAM44BgpGGUjCMsKXuK1E2kSND5iZ21udYBd5RDwAyydwz50CK+QP/S9At2zHPCOpY12XOdHCc1YZPqIlGcUfPiXksuczrmolwt0x7OAy4aTYfUNUccpnaRkwe7fSGNIZpetRXh64UCjh038tkC5iDNASVghmT6GkI5VLO+bau0/91MFyL6tSq8nhQRW+13l+IYFX2TkbPyDrVFuyTS9AL7ST69dSJDCh140BDYAQD7HJ4I9ChP/U3fRGA1WgR+bgJmjJV7EbZ5Ayr5LFsH37AdFPwCztHbgkIsaQjae/gfkmA6+/WSM0JQFC6nUS9nwR4mdfWDbvCRPl/6iocSEVv2eNbCtwnls73ZJW77Pja6f040K/MhMHo+DyCC5Y8HnQ+Ec3lVV/b4Q+iDy2dULj4R9RAJrA0k5UDX3tLXyHKczXSvQsDzR9fMrkcg06S+uq3GNlXPKpv2VmC44FQE/4hT7aQHC1TmJJZ5SavZDbqKofIOF7P28+EMZlVF61LuIbBj6YfiW/KO2g0ylJXTRPD5qA0h3xr6GYmslFTKlQxGFYdJcbFqUpkBZD4pNem0nHiV6uZBeAlyWn2rs+lSk+dpiW1oLaLRr6vq/zOq04MeEliX5dd8L18+FdikjucuH8ufCf0tY8ZbCSDoh2vfl/Po5mkeKZfIpVjM5A0mgWx3GauzHEposTa3WFPcox7X+Vnzmu2ro4zWFcl0YQ07NsPw/zWUBi3rcaebGBNyh5tYhMMOCjlPDEmpCaSU39gFRYVl5gXXSu6IFR8g3
 YHBjlwz2
 TwqPvfmqImp2wHfG1t0babRWrGLZeigxukcsMu2UuUaPjWb7QMe1Hr101uBivKUTkHQszNsxvY3f2ZOtA7YzUj7Hx0i5QeZz7Fr8XX3+Tz8BZwMz8xd56+Cb6iW3jtT4Ou+M74bCockyzjtcJvvo08XUOhOhjrXzp3R6PbjxrC6DfYW2ol1tWj+k0QvqxP6KsySQ05K6eAtcWWAF8MpfGxBrxW+HstPtLBUaC5FPT2fVWskCjuYDTwVsl/SGL2ZxZCp8fjtZBtdnNwsYCdIck8fFN2QUExsaPOAMXleFQxMogm7yiENpzLJtZDiLWeaYXZ6Vhebf86K1NS8qK0Kn3vmX/5/A7jbUelqrDWMg3k1HCW/0MQoH4PG8n5BVbpoFNkFbKRJLLGWZMJYA4deVj82Tqc7+n7291qM6Ckjxdf5kM6RG3hIkCttJNFDub0D8c+RdwuTHf9UZBRfWv3dQh6mWdfyJO+VYctXwnJ5vVkkLrEADcYimBPlLigSpr4tjW0YmU3I/h5i9bfg7mJOj9ZiY+e4rZfPt8/Cys5dAXi7tGo1W58FUwkC/TPnRTKPIwvKOpntxG9QcPiJZr6+6mWJdJQiMCYv0fXKaKaWFHWMhR+aNVNBBvtdH9qaRpRRxZ57E5YsLzzvabN0IZpn6xVjNlibLEANwim+bVl3lQw1RQpmMdw8xZv0rh0CLFmpuaxK4/zVbZk/aYlD7mHbkK+r8NrKtfX3msFP1uXfFIMI4UVBnNV3Ao/XC2Niidc9BQCQ/c65XQe5Kyb1YGzb/FLl9n0NHzwzh4+rczfEpmUrNVV9/tULQjgPXYfMa9jPIomwhIdQEqpyKvXXsdfwRQDSql2NjPEkZ82Oubwws3r3hSAhhLsZJpRSgGJotrodjighBcfEwX11oMKzGFDjhxhm68z4rWMyw5tVfuw117cASZ/Ivmg4uwP8ElHHneitbj6umqlSZsjk69jf0NkNB1T+6f0vvv
 TpAskTBQ
 AHTyvHIeP3iW9zN496sm540BJI4QN+6JeXXjAAIdtE0id1f/2xZcUJaGNvdNESLzXXv6Vv9/JQo5676oY8XTkfqlyHqMsarTusxltddUm9eWJuCeyRwbwqjldej/gkTujcAYIFBBMXuMQBc4ezqS516VSu2zwsH9AyUKH/YWLMpnzsPbaT7G1FeaOgLb0K5N2U28X1t7dms9ge77LBADT7XjsoGIVQguj9pzqDRa/XNCj7/jreOiXvpNipanDvMbS3fsiagsH3NzcjtMtDuP2PQyC2NP4idtlIeq/PdLEh+Zgd2WsnYtQ1guUAodLW8/DS+Z08tu43IcdHGeHjx8hUHzENsLySL+Lr83EqGzB6FtdH0d06M5bXsLIKcHomtYo2vdfKVSwpgDvL+RADu1xLl6K+yE1G34T8rvJLguUPHI0pdcE87slz+v9jEqN6kUi2LV6F4REm8DiPIX0oiwyxIXxclyMgBQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    24d479d26b25 Linux 6.19-rc6
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15454e3a580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c33bf4a3a0c7a4f1
dashboard link: https://syzkaller.appspot.com/bug?extid=6cc93ec9a4035badb85f
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/f0555f920605/disk-24d479d2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/ae277d28fcd2/vmlinux-24d479d2.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b4f8db4a51a6/bzImage-24d479d2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6cc93ec9a4035badb85f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in memcpy_from_iter lib/iov_iter.c:85 [inline]
BUG: KASAN: use-after-free in iterate_bvec include/linux/iov_iter.h:123 [inline]
BUG: KASAN: use-after-free in iterate_and_advance2 include/linux/iov_iter.h:306 [inline]
BUG: KASAN: use-after-free in iterate_and_advance include/linux/iov_iter.h:330 [inline]
BUG: KASAN: use-after-free in __copy_from_iter lib/iov_iter.c:261 [inline]
BUG: KASAN: use-after-free in copy_folio_from_iter_atomic+0xa6c/0x1950 lib/iov_iter.c:491
Read of size 4096 at addr ffff88803177d000 by task kworker/u8:9/1219

CPU: 0 UID: 0 PID: 1219 Comm: kworker/u8:9 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/25/2025
Workqueue: loop1 loop_workfn
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 memcpy_from_iter lib/iov_iter.c:85 [inline]
 iterate_bvec include/linux/iov_iter.h:123 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:306 [inline]
 iterate_and_advance include/linux/iov_iter.h:330 [inline]
 __copy_from_iter lib/iov_iter.c:261 [inline]
 copy_folio_from_iter_atomic+0xa6c/0x1950 lib/iov_iter.c:491
 generic_perform_write+0x5b1/0x8b0 mm/filemap.c:4332
 shmem_file_write_iter+0xfb/0x120 mm/shmem.c:3490
 lo_rw_aio+0xc80/0xf00 include/linux/percpu-rwsem.h:-1
 do_req_filebacked drivers/block/loop.c:434 [inline]
 loop_handle_cmd drivers/block/loop.c:1947 [inline]
 loop_process_work+0x637/0x11b0 drivers/block/loop.c:1982
 process_one_work kernel/workqueue.c:3257 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
 worker_thread+0x89f/0xd90 kernel/workqueue.c:3421
 kthread+0x726/0x8b0 kernel/kthread.c:463
 ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88803177d000 pfn:0x3177d
flags: 0x80000000000000(node=0|zone=1)
raw: 0080000000000000 ffffea00016beb08 ffffea00009e42c8 0000000000000000
raw: ffff88803177d000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xdc0(GFP_KERNEL|__GFP_ZERO), pid 6876, tgid 6875 (syz.1.137), ts 163020649815, free_ts 163886382057
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x228/0x280 mm/page_alloc.c:1884
 prep_new_page mm/page_alloc.c:1892 [inline]
 get_page_from_freelist+0x28bb/0x2950 mm/page_alloc.c:3945
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5240
 alloc_pages_mpol+0xd1/0x380 mm/mempolicy.c:2486
 alloc_frozen_pages_noprof mm/mempolicy.c:2557 [inline]
 alloc_pages_noprof+0xce/0x1e0 mm/mempolicy.c:2577
 lbmLogInit fs/jfs/jfs_logmgr.c:1815 [inline]
 lmLogInit+0x357/0x1a00 fs/jfs/jfs_logmgr.c:1269
 open_inline_log fs/jfs/jfs_logmgr.c:1175 [inline]
 lmLogOpen+0x4e1/0xfa0 fs/jfs/jfs_logmgr.c:1069
 jfs_mount_rw+0xee/0x670 fs/jfs/jfs_mount.c:257
 jfs_fill_super+0x754/0xd80 fs/jfs/super.c:532
 get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1691
 vfs_get_tree+0x92/0x2a0 fs/super.c:1751
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3636 [inline]
 do_new_mount+0x329/0xa50 fs/namespace.c:3712
 do_mount fs/namespace.c:4035 [inline]
 __do_sys_mount fs/namespace.c:4224 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4201
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5804 tgid 5804 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1433 [inline]
 __free_frozen_pages+0xfc1/0x1130 mm/page_alloc.c:2973
 lbmLogShutdown fs/jfs/jfs_logmgr.c:1863 [inline]
 lmLogShutdown+0x44e/0x850 fs/jfs/jfs_logmgr.c:1683
 lmLogClose+0x28a/0x520 fs/jfs/jfs_logmgr.c:1459
 jfs_umount+0x2ef/0x3c0 fs/jfs/jfs_umount.c:114
 jfs_put_super+0x8c/0x190 fs/jfs/super.c:194
 generic_shutdown_super+0x135/0x2c0 fs/super.c:643
 kill_block_super+0x44/0x90 fs/super.c:1722
 deactivate_locked_super+0xbc/0x130 fs/super.c:474
 cleanup_mnt+0x437/0x4d0 fs/namespace.c:1318
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2b7/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88803177cf00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88803177cf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88803177d000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff88803177d080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88803177d100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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

