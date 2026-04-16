Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F262AF8A146
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 10:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59B606B0005; Thu, 16 Apr 2026 06:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54B846B0089; Thu, 16 Apr 2026 06:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 413ED6B008A; Thu, 16 Apr 2026 06:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4676B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:23:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 06527E48A0
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:23:34 +0000 (UTC)
X-FDA: 84664032348.04.67C49A2
Received: from mail-oo1-f80.google.com (mail-oo1-f80.google.com [209.85.161.80])
	by imf22.hostedemail.com (Postfix) with ESMTP id 55C51C000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:23:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf22.hostedemail.com: domain of 3o7jgaQkbAOwgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3o7jgaQkbAOwgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776335012; a=rsa-sha256;
	cv=none;
	b=X9s/g1A/CXhrNWr9SKWJOlU4v2i5Kg+Xc1WVdquDxdyOcSB63Hh+6siQkcloLfF1YuwNgn
	IAFjpqvddIlw1276vVZcApAiYRIg0hm1smwZ1R4B8sTzio+ffuZCodkIYA7Nmuo9BQLtUc
	HsEPrHxofCnvXbZ8wQEUG1hmjYsvfaM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf22.hostedemail.com: domain of 3o7jgaQkbAOwgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.80 as permitted sender) smtp.mailfrom=3o7jgaQkbAOwgmnYOZZSfOddWR.UccUZSigSfQcbhSbh.Qca@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776335012;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references;
	bh=JEaj6fnSOKXp4q3360HUqOm88OpwUS+0PKrmb3o9nY8=;
	b=onBnJQUdc9HWKM3fXeq+aQkm4jkjPAR011s+XHSkZU7mwXxNyt6abShC6MB4pyLcUuynCn
	sqox6C5LHnQ6iriIIMYIYNB3S8emyZUumKBcNpBtWzNGLjB2tmgZOtWqbUDfsUgw8YUU5B
	bU6wZ1SN4WYC+jmSu9GWKYu/8HM0Qig=
Received: by mail-oo1-f80.google.com with SMTP id 006d021491bc7-68cfc614246so10010119eaf.3
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776335011; x=1776939811;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JEaj6fnSOKXp4q3360HUqOm88OpwUS+0PKrmb3o9nY8=;
        b=Drx06LJdMbI/fs++M8MDdSTepAF7sDRMvmneCtNDVyU+uur6I4rq+U2GnGjz0PXm5E
         HHGmi3Sv0ihUyIqQktQgzuAksFJV7i0m0563Z6uaq+uzW7ZWoacCspbgXbZ3se5Mpj5f
         MaR4tELj6mEtYrlZJ0sSpUQj+4991Mrljd6G1w9ZQeij9/H7CHBEC7cIV07+PH1Rli85
         cnDm8TvqXkkWN/R/zypw3+xsRbiBwww/HsMRkvE5QBYqFUKcsDV5WgBfC1EojMYbYNhf
         ynpzFdUKVyPcTb+SOVmnKq5Eb9Uwwa45wPnONeYK+t4N8fyO1dZYNs+yMya5ser3A9sO
         sWLw==
X-Forwarded-Encrypted: i=1; AFNElJ95RDRL96iBOoi6BMSlcehM405awxDkrvxkd9ukuHKW2WfBpNwghJBWvDdP5Dy0BKSiV5r+5wCL1A==@kvack.org
X-Gm-Message-State: AOJu0YzypTS73CNjQoN6pEp6N5Itff3ZfW4lRc413KDAD8k/SwzUuLhs
	eT1yO2wcoqDYkKqlWbss53WbNbORo18y4zo9ap7jV6g+VM2qPma5PrpH8X/yhWg4/8e44RZJ8Vl
	N0t7T8khuwco34GKl2lZ6JJ4YmIGOHjOg3s/ar8SRO920rmiIZjrrx6ke4jw=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4dcb:b0:68e:b666:74 with SMTP id
 006d021491bc7-68eb6754550mr8852634eaf.30.1776335011373; Thu, 16 Apr 2026
 03:23:31 -0700 (PDT)
Date: Thu, 16 Apr 2026 03:23:31 -0700
In-Reply-To: <69ca48ca.050a0220.183828.001a.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e0b8a3.a00a0220.8f24c.017a.GAE@google.com>
Subject: Re: [syzbot] [mm?] KASAN: use-after-free Read in copy_folio_from_iter_atomic
 (2)
From: syzbot <syzbot+6cc93ec9a4035badb85f@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, hughd@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	syzkaller-bugs@googlegroups.com, tahernady45@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 55C51C000C
X-Stat-Signature: 3d19ruswe5bf5bxdw36uwic9jbd8udqh
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776335012-794042
X-HE-Meta: U2FsdGVkX18XUdkavVfXWqIAanCuoyhCPdXbzHqe/MHMVFYJl9Lbjjs9JVVh5+g2BuxmKOxaXgCPJklYWVLNq5izzB8yMvc/VTQTUqsVt6DZnR5KYucX3qIzY2DsPJhvychedvcfk0Sg3jzjKfFugfWVx7ArhAq2r9y0Y1RK+jTYOrjyx02YkuEeWdcG58oO3rb98yrxyXkjoIrJkV4sMUl6CCUiQcnUx5XGzgOBsjkl6h9dFv0FVOQqWeTKWKf3U6jjQOdsF30fTP59ew0mB1yJ9ZPe6B+uQ3iqoZFarTc/zPAJdM7NG0S5ub+Gd/rhu/CR55Yii1yEjRukqCk293+tsq2K1xk64kwxj8gSAFF1zn627MUl3Lxoz1AvvjkQLuyxQXRDZ073Ivoz9RgW29CC1d+e965mlbGzwtgi6shCOcntol4NncqU0T0bikZEJpdeIOHYJm9Tb7XozHwPnLaY4CLvhBROMVjiI3ctDR6a/N/I3QtDpy3jJ/Ye/isIuMvD6+iOc4NfMA24sSo1QA5+Wvt2czrNuidgHuHZ/8rexmHdnVhDgrpjuC7S4Cdp2ppW5bpsFCllsiwb6cjuScCI79IdHah+93GnZcYJqFck7XDvNNm4LToZLfHH1PlA2RzvkMW/B9N4xhu1tp1T3ewCvAaWNcmUpqM0unsgDC1Rod7/Y6q5KxrpWrofINoqP0SEjSf5klw3QAl7LcIS8HyMn/xluJ3tiRe0942zFW2Lzm2g+NmbNvSSCR/1hk6cbaAAebYcu8sr3SMVM2mw7FqTD81VC0U6qBYoDa748qKZuoVQ7GThxjyp6ysRG9Jm3xHmnGj3mEDxhBTmhA+a/rJtuaiaR0YEUHb5VYND/QGuz3BfB4hye8DoN5OTCfn9zNnuFu7hjcoOcLXuTgkxKvRnZTVCe1WaITuGv5EcqxfBYfiqMo1qqcYbrZFtbh6ikpLplPX8ouc+NjVV/R0
 Os8LDUPb
 EvSyghQV4BXIolcuQDSiY8B1M5MBUkChP2vJk0gctoxx9cLe18RKdXYACQ6l7pJkH+2ZN42/lXu1YvvicIAkJOFMi1uYL0VExfBAzkgzCFxlhb0FDi2kceXPMlWMJJarg3LzcyPWEp9Oh8AoKN2LEoHSwZGf95SzhFXmDpYvs6nJ19Mmo1zfzxJ4N1d3+d//1xTATV0DF2KfAf2CSJ5dcWlQg7tYYx0MlXuTmrEx2yPhEYBZDNYBDJHZBX6JRqfVr25NZZpbPNNMC0efpO5N8W1llymFT8zyVrZhz4z56ff6zdXEaeiUo+v6Rbc7E59rE+hKJCW2nqHPve5DsfYvkOgHu8BuSHxtkJ8DHfh8Zbfl6W0Ij565n80UqhQK+YeFQ5XHyy7drhWcR9WWauy5jdtH7RUF9WG9bJ7GFSsEoN3DrvRjunyrTDgxirHuIPflnimx3iY/YFzQi50AyBKyYjG9aCtvePJdnUoFcz0iaaNR6UyHNowNWCfgWRorCryXiY1XWNa0jV2oxNIDrrYopeBbq6m9/yznH+QTvdAaw/dmDv9my+uvWfZ3nUCdRHzvbQtAN+zCVfKYVjPjLuPU+FWHYP+bUEbaGLXHngrvUPxb32YQ2+6x5oGRL+5wq7SH9MiUb7t0tyD0aJAa7gH5qqzN297vaAZ9oun3uqHunjnbHiziHMnTrQwNa51A29Og/gMtXr8IFW0TWq94+srbST4UqH56VJNKkKlEZ2+Fe0reGRQPwIjB/kABG0MPqxDQ3OgNtAr96Fz+6NRymJYhyP/2tM3jPFuifrkcOsj3emWwF4CGge9lSXaLmAuG6DDWMlbLEHgNYznSequWKBTLskL3micedv+fQvVl/b5digA0UKPFD+KKluePthABMKO/By2dNI4J02UoukyvD/5Sp5Ef+vWEwR9AaA9xaiUzS8EgjHlvmfBwB+HUcX5aD72v1rBQWpcNHEGQyx1gXX3WPDGZPSYpo
 1s04xfcd
 qEuYPiTeIuY5qXcLOqs3dLzwjCmjPC5ZFp4eKgNixnvCBE+9TGRwn80Wsm2JPy5nTykdN6qZldgroNL8rv9ujL9n1AfpROxesFt4LPhemZBFC49a1vncy8Rp17mH8bInWXhLDmaxMJ62ic7Q+X17Tn7XI8F7oIVZwtqLBWJJGEXKtGTdjlBcg75nP9RCjCDS1qA7DuVQ6eMH2HAfcJAuS9AFCYHkUh9sWJJbs9505HuxEzPul45FaSIfHD9xVT6Kfjeiimgrdug0x9Y0U9phFjlF6mChkEby4HRQb3iwJBSRm4IVpzCUlKjbhdc88peAFfSWRh999PJMEM+JbBOnmdSU+/s/CWc2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot has found a reproducer for the following issue on:

HEAD commit:    e6efabc0afca Add linux-next specific files for 20260414
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=17908702580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=56c2b36de3316f1b
dashboard link: https://syzkaller.appspot.com/bug?extid=6cc93ec9a4035badb85f
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14c798ce580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1142c4ce580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/e7099cbf73e4/disk-e6efabc0.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/439c402df1b9/vmlinux-e6efabc0.xz
kernel image: https://storage.googleapis.com/syzbot-assets/fc0c0175fc76/bzImage-e6efabc0.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/94fa7bad6be9/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=17017b16580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+6cc93ec9a4035badb85f@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in memcpy_from_iter lib/iov_iter.c:85 [inline]
BUG: KASAN: use-after-free in iterate_bvec include/linux/iov_iter.h:123 [inline]
BUG: KASAN: use-after-free in iterate_and_advance2 include/linux/iov_iter.h:306 [inline]
BUG: KASAN: use-after-free in iterate_and_advance include/linux/iov_iter.h:330 [inline]
BUG: KASAN: use-after-free in __copy_from_iter lib/iov_iter.c:261 [inline]
BUG: KASAN: use-after-free in copy_folio_from_iter_atomic+0xbb5/0x1ad0 lib/iov_iter.c:491
Read of size 4096 at addr ffff888037cb3000 by task kworker/u8:7/1020

CPU: 0 UID: 0 PID: 1020 Comm: kworker/u8:7 Not tainted syzkaller #0 PREEMPT_{RT,(full)} 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 03/18/2026
Workqueue: loop0 loop_workfn
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 __asan_memcpy+0x29/0x70 mm/kasan/shadow.c:105
 memcpy_from_iter lib/iov_iter.c:85 [inline]
 iterate_bvec include/linux/iov_iter.h:123 [inline]
 iterate_and_advance2 include/linux/iov_iter.h:306 [inline]
 iterate_and_advance include/linux/iov_iter.h:330 [inline]
 __copy_from_iter lib/iov_iter.c:261 [inline]
 copy_folio_from_iter_atomic+0xbb5/0x1ad0 lib/iov_iter.c:491
 generic_perform_write+0x5b1/0x8b0 mm/filemap.c:4342
 shmem_file_write_iter+0xfb/0x120 mm/shmem.c:3478
 lo_rw_aio+0xc80/0xf00 include/linux/percpu-rwsem.h:-1
 do_req_filebacked drivers/block/loop.c:433 [inline]
 loop_handle_cmd drivers/block/loop.c:1925 [inline]
 loop_process_work+0x637/0x11b0 drivers/block/loop.c:1960
 process_one_work kernel/workqueue.c:3308 [inline]
 process_scheduled_works+0xb68/0x1910 kernel/workqueue.c:3399
 worker_thread+0xa90/0x1040 kernel/workqueue.c:3485
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x38 pfn:0x37cb3
flags: 0x80000000000000(node=0|zone=1)
raw: 0080000000000000 ffffea0000d17548 ffffea0001353448 0000000000000000
raw: 0000000000000038 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xdc0(GFP_KERNEL|__GFP_ZERO), pid 6098, tgid 6098 (syz.0.91), ts 154383709391, free_ts 154428922615
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x231/0x280 mm/page_alloc.c:1858
 prep_new_page mm/page_alloc.c:1866 [inline]
 get_page_from_freelist+0x27d6/0x2850 mm/page_alloc.c:3946
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
 alloc_pages_mpol+0xd1/0x380 mm/mempolicy.c:2490
 alloc_frozen_pages_noprof mm/mempolicy.c:2561 [inline]
 alloc_pages_noprof+0xd2/0x2f0 mm/mempolicy.c:2581
 lbmLogInit fs/jfs/jfs_logmgr.c:1813 [inline]
 lmLogInit+0x357/0x1a00 fs/jfs/jfs_logmgr.c:1267
 open_inline_log fs/jfs/jfs_logmgr.c:1173 [inline]
 lmLogOpen+0x4e1/0xfa0 fs/jfs/jfs_logmgr.c:1067
 jfs_mount_rw+0xee/0x670 fs/jfs/jfs_mount.c:257
 jfs_fill_super+0x754/0xd80 fs/jfs/super.c:532
 get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1694
 vfs_get_tree+0x92/0x2a0 fs/super.c:1754
 fc_mount fs/namespace.c:1193 [inline]
 do_new_mount_fc fs/namespace.c:3758 [inline]
 do_new_mount+0x341/0xd30 fs/namespace.c:3834
 do_mount fs/namespace.c:4167 [inline]
 __do_sys_mount fs/namespace.c:4399 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4376
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5945 tgid 5945 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 __free_pages_prepare mm/page_alloc.c:1402 [inline]
 __free_frozen_pages+0xf9b/0x10f0 mm/page_alloc.c:2943
 lbmLogShutdown fs/jfs/jfs_logmgr.c:1861 [inline]
 lmLogShutdown+0x44e/0x850 fs/jfs/jfs_logmgr.c:1681
 lmLogClose+0x28a/0x520 fs/jfs/jfs_logmgr.c:1457
 jfs_umount+0x2fb/0x3d0 fs/jfs/jfs_umount.c:124
 jfs_put_super+0x8c/0x190 fs/jfs/super.c:194
 generic_shutdown_super+0x13d/0x2d0 fs/super.c:646
 kill_block_super+0x44/0x90 fs/super.c:1725
 deactivate_locked_super+0xbc/0x130 fs/super.c:476
 cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:328 [inline]
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888037cb2f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888037cb2f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888037cb3000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                   ^
 ffff888037cb3080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888037cb3100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
==================================================================


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.

