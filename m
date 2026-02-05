Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79E5BECD9AA
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 21:44:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76CC16B0088; Thu,  5 Feb 2026 16:44:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71A8F6B0089; Thu,  5 Feb 2026 16:44:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 618EF6B008A; Thu,  5 Feb 2026 16:44:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4BC516B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:44:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED5B51B273E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:44:35 +0000 (UTC)
X-FDA: 84411732510.12.2E10EDC
Received: from mail-oo1-f78.google.com (mail-oo1-f78.google.com [209.85.161.78])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4525B80002
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:44:34 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 3QQ-FaQkbAMY4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3QQ-FaQkbAMY4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770327874; a=rsa-sha256;
	cv=none;
	b=5tTBDIDdocbAEwwAYV2UwRITU7+liyFZcJgaz6gnB49OYPMhQSuzlRZrV7hyoj1VD7ZgI9
	xfm6s6yDMk55+f+GziMrcERWBtLYkl6+RS+8nYmzI4nt5+17ARSBqQEyCfbP+SvoZM9Hvl
	X+IHWEgx7jM+WpUk7YBReMJPEIJbgWE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=appspotmail.com (policy=none);
	spf=pass (imf02.hostedemail.com: domain of 3QQ-FaQkbAMY4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com designates 209.85.161.78 as permitted sender) smtp.mailfrom=3QQ-FaQkbAMY4ABwmxxq3m11up.s00sxq64q3o0z5qz5.o0y@M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770327874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=khr2EWUEjPlWBW4Wf/RUyF0L5fTr3UH1vYrHqzu9ESw=;
	b=3xqqQseZkhCwqjrSJ+bWOALSZfMPCapEucIcNmQ64P1gne/6ct/qJvZAifiUKinJsVQMrN
	qBIPDT7d7yF6JQ1pd52lBZRiZNALNo+A/iCx0zFkuDp6+tezgcwNG+rqv1M56lNEQVU71i
	cdf6ocwfMJHt+DuLOEqS2PtSzr2VGSI=
Received: by mail-oo1-f78.google.com with SMTP id 006d021491bc7-6640dc1ca05so6157368eaf.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 13:44:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770327873; x=1770932673;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=khr2EWUEjPlWBW4Wf/RUyF0L5fTr3UH1vYrHqzu9ESw=;
        b=XImJqJcK0a2R+RfB3zbzehWzx6Q+RbxxWCrbMZJxNLi8isfGqvBf1TqumQWluLPutx
         iBPQMA6uAixMC5KAiyUCn8hgA2gzXgsom0qqfxiXnW2DyS+oHB5GFzJJowQgZPZJU1vf
         yjLKwDCS/GdjcOkRJINUrtcwmlR1TpWLD6aiFWY+w7DTGWA8mE6IhZFLPt+0Hstva8Tl
         Phe4oeLfYSGxNT4I3KWz37fCeFp6wvUB2bXaoW66wgdoPeec4R0bhLpC0Kk1I2kpHOyR
         enWx/z0zvOJTv1z63pJZyKQf8aQupAjtjzFFR2jYGAMFv+jllWXiJwqqn2qisxEZZfNx
         sypQ==
X-Forwarded-Encrypted: i=1; AJvYcCUVPW2ceZ4FfX36vLbUaSjSpUjSPHrLdBRQwK7OeZLv3Ko9zOKEmblmxRrvHbuyVsv6KSdi+xHkeg==@kvack.org
X-Gm-Message-State: AOJu0Ywb6xcPLXrw8qEonK16jsnxUD+bVEacsJQmSDwmSGw7jLYMIhMo
	RaDjmaTjE/P6jDQYVPYo9yMJYKoAM7JgI/zDv79SYuSqRpFoKinL37HT1SOTs/CNGf9hoEfwvRd
	5Bm4xT/WHf/CLHgfoujtJKhmrYn+vpsVdgqQWmz5xrApCBCssaW92tBpQirE=
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c9f:b0:664:86ce:df5a with SMTP id
 006d021491bc7-66d09cb2a11mr396150eaf.10.1770327873382; Thu, 05 Feb 2026
 13:44:33 -0800 (PST)
Date: Thu, 05 Feb 2026 13:44:33 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69850f41.a00a0220.34fa92.001d.GAE@google.com>
Subject: [syzbot] [mm?] possible deadlock in gup_fast_fallback (2)
From: syzbot <syzbot+c8461425abb63bfd3445@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@kernel.org, jgg@ziepe.ca, 
	jhubbard@nvidia.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	peterx@redhat.com, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4525B80002
X-Stat-Signature: pjc947nia7j6fnn3a5epbqx9ztysnwf9
X-HE-Tag: 1770327874-523997
X-HE-Meta: U2FsdGVkX1+PEcS7cr/Lu6wLqQqq0Ns6gWV9BMulfAX8kOqYGBe/fTZVks27sRgbmtcfR8xlG39rqm+O1AxValhjJ4E/pgzfLkA/jrP9VOV+RsYOYssEYi23+nhCACjAUb4nhepTozAQi29mYV6DYxnzqoRE7jeI78F6efOUaSd6fmRxuyE5ybslfQx0c52MVp0tpK2o4Ss9y4kWTYbltRh3Te2a7+GWeK3px5Is36NgkkrCGxyn2s9aFyRiCXcSJuE/97lkRUiV69QJqsFKUGTe3Hs+xM+ELv5YLpmRJWjqFlVnRo2yjMSJWTRWCyHuf4YB3lfDTzPDMVGjvLDQKDGv/2Bs3ctzi3daiX9tEG1a0mOER0Uk6nPN/9iA8wbaTQGU3LnvexP5f8Og2BwuJv8iIK0MgsZLs5XijJf0e/C68ef2ASMW3aEfYP2JIcKmWuqxG8zh1UKQL9sJj7fyf3Bw9Jw3LA4O+cftJiCYy72IFWHjelmdL4tk2gklJ/tXtQY/i/EuRqESieDJNoTMHtdkdzhtzw6CoOVo5QHT8pW5zHOCDIur+Vgg8HRhUm32iOJY4ONAGHd/AUT2HeCKt77tuJ2e0qHyViuTSN0GMmVaNhHQv6WeBXlIifkkjOzm85NY7oOEevpxnfHz2bjTqRcE01RrgOz9Ij5xQdi5CvId41/c/bO8p4rKlUPa6RpzgZAQmMxT67m3y2jgHz0zUzcP0RJLrMpkPwHZXT8+aarUsRoS1Nnyo4FgMO3r4trp4ctmAVTOg4oQMW0thUgQpLRpo3RzWdIHtidioKr2LQmgP66OHSEZE258rI03N8pHrsneY0rifkV1OKkI4I4i6pgt55A4WgWdkXc5oW+Q4hacm58wZynwp1+j2kfvUdrpI8SNOu9y4lt6ZP1r4Ve5FrMjX/5tRV8JnyQZg0RxntpkI7CqKWLddKC5hRyFEVP1Kq0VaXu+DPAxIitFG2C
 qlTbOCos
 44zjZuIJHKh21in64FCMaONOjAdR9ZqS3zNxuUF5ZVqzlR17KoB++KxSwlx1Q1kad7U4+CHVshbwxnBC6Bu+l5p+oBlzJXAcJNVXFzE689L+FbD8Y6hkljol1Bs9fSSW5wv597+tRKj+1Bj/N27wMDM2QRCxD06R4N7sSjN611KRlor2CO7O4wwTHnclQV3rqPqcRDyJsztWNPwpyfzB7wIXCHv5RHRrlRI5klkikWZ7BlbToQn/FpxVdQlo2v83PEWheuAgPDGbFZWlb7Sw+nkihZplNVJFUJ6Wr7cmYohzW0urEL3OMDXhjR/CNG1wVrwErK739xYjdnShX6mjPwBSuPDR6B5flgeLSed5zOmQBxs5JuJb3J+NOD097zz3A2V8/UY3VciznvoK3NlXMXYkaZCmuncSq1EehWUwWW6F9Ijq/JWmbcnt2yC7V1VIVzVu8VVTfrUDWgdgPpXyF3TS2EAk+xSeWPOEGt3n8Lge3F5x0rqUemsYBJwv7ny+AEvkKQ3n+qyLS4A40Eau3+d6faHkQMtR7i0+Sr0ZNq8bRrIaa3bE8n7s13pXsaMIimSVyLrf+63NcPVLdL8ou7wPMbLpDSyNr7TO1EFTxX1gwz/g7B9V+Tv373xkd4T5zNXLj4mMRIqMbzHbIaPOxYlj3UmVpXYB1T77xDUeOJy88Udq845bYR6BMH/6IdMYe8dvI7l17nsWVYuWiXOqTcm9cTfPN25ljNVmD6OP0vYXbURmLK/D9kIgxMpysjTRRnRXaIGX2z06ysKH97n5gYioPyHVKoeyOK/jdt0nBG6/sZcBsDPzzcWpUme7qs9GIsgnxnDg/4q2pDiZbZy1bxaAQM0WYkCp6OmYr7skwITZtN7gWR+pqN/1y2U4mcBk9WCmAmct5FZZefXqVMQAdZoKrWy3ZaAVk1o/M19UuIvk92vGsGE0DfncK/PwnFplB3bZ+BRLo5SkNDiHYPpMLPTR8Hluo
 rIvLFk2c
 z481FthLPDJ6n3e+NMIJ4SANeae8DcLPOVtndeYeWWBA/FZ52woCsRCBxUN3EPlD03BaGlxNIJlBK/fMjPALTI9hhd7Tw0LQl01eHGqVegR/6vrZ0nAsjAR3wVCnwA73f8+f0qO5Uf2fxiIisMIR7qyNYmESna3RSBdsYpuXpiVYapCqRENmda6MXTVeOZQ5ML+W+m3Kum23eV5TSO8vaNWBfWoCqq2k4FaaOVugkK6QwpHrRsi6pr7MtivWZNrEW7WKXAi3gtbzJIjWgmThz8SHgKGBkF26ulJkW59DREXsoi+iPhiDCLSpMB0ZpiFDrpfzfZ4OsdYS6EaAJ6GURL+Ho78F2i76dvO5KF6UP7yGj4JY4m2EbiMjY4bzqGpFqWO/GWIgi6l4nfgjyPRlvo1OwGjbeQTH7BKP1y76OJAl692llcu8X1Kt6TP/RP8+7gF6bHS/AChvpziRY34QBpYOT2igBA8s
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

syzbot found the following issue on:

HEAD commit:    f14faaf3a1fb Merge tag 'tsm-fixes-for-6.19' of git://git.k..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=10928a52580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=4aae00ac5a9d2645
dashboard link: https://syzkaller.appspot.com/bug?extid=c8461425abb63bfd3445
compiler:       Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17078a5a580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14df4b22580000

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-f14faaf3.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2fe7f2219e97/vmlinux-f14faaf3.xz
kernel image: https://storage.googleapis.com/syzbot-assets/b1acb6ecfb89/bzImage-f14faaf3.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/c52bcc06e784/mount_0.gz
  fsck result: failed (log: https://syzkaller.appspot.com/x/fsck.log?x=13a5c7fa580000)

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+c8461425abb63bfd3445@syzkaller.appspotmail.com

loop0: detected capacity change from 0 to 32768
XFS (loop0): Mounting V5 Filesystem bfdc47fc-10d8-4eed-a562-11a831b3f791
XFS (loop0): Ending clean mount
======================================================
WARNING: possible circular locking dependency detected
syzkaller #0 Not tainted
------------------------------------------------------
syz.0.17/5488 is trying to acquire lock:
ffff888044e06540 (&mm->mmap_lock){++++}-{4:4}, at: gup_fast_fallback+0x20d/0x22e0 mm/gup.c:3204

but task is already holding lock:
ffff8880467da130 (&sb->s_type->i_mutex_key#24){++++}-{4:4}, at: xfs_ilock_demote+0xbd/0x290 fs/xfs/xfs_inode.c:285

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (&sb->s_type->i_mutex_key#24){++++}-{4:4}:
       down_read_nested+0x49/0x2e0 kernel/locking/rwsem.c:1662
       xfs_ilock+0x109/0x360 fs/xfs/xfs_inode.c:152
       xfs_ilock_iocb fs/xfs/xfs_file.c:195 [inline]
       xfs_file_buffered_read+0x15b/0x330 fs/xfs/xfs_file.c:284
       xfs_file_read_iter+0x280/0x510 fs/xfs/xfs_file.c:312
       __kernel_read+0x504/0x9b0 fs/read_write.c:530
       freader_fetch+0x1cb/0xa00 lib/buildid.c:100
       __build_id_parse+0x168/0x870 lib/buildid.c:297
       do_procmap_query fs/proc/task_mmu.c:733 [inline]
       procfs_procmap_ioctl+0x7ae/0xd50 fs/proc/task_mmu.c:813
       vfs_ioctl fs/ioctl.c:51 [inline]
       __do_sys_ioctl fs/ioctl.c:597 [inline]
       __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> #1 (vm_lock){++++}-{0:0}:
       __vma_enter_locked+0x243/0x710 mm/mmap_lock.c:72
       __vma_start_write+0x23/0x140 mm/mmap_lock.c:104
       vma_start_write include/linux/mmap_lock.h:213 [inline]
       mprotect_fixup+0x5e1/0xa50 mm/mprotect.c:768
       setup_arg_pages+0x565/0xae0 fs/exec.c:670
       load_elf_binary+0xc5e/0x2980 fs/binfmt_elf.c:1028
       search_binary_handler fs/exec.c:1669 [inline]
       exec_binprm fs/exec.c:1701 [inline]
       bprm_execve+0x93d/0x1410 fs/exec.c:1753
       kernel_execve+0x8ef/0x9e0 fs/exec.c:1919
       try_to_run_init_process+0x13/0x60 init/main.c:1506
       kernel_init+0xad/0x1d0 init/main.c:1634
       ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
       ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

-> #0 (&mm->mmap_lock){++++}-{4:4}:
       check_prev_add kernel/locking/lockdep.c:3165 [inline]
       check_prevs_add kernel/locking/lockdep.c:3284 [inline]
       validate_chain kernel/locking/lockdep.c:3908 [inline]
       __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
       lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
       gup_fast_fallback+0x226/0x22e0 mm/gup.c:3204
       iov_iter_extract_user_pages lib/iov_iter.c:1763 [inline]
       iov_iter_extract_pages+0x37b/0x5f0 lib/iov_iter.c:1826
       __bio_iov_iter_get_pages block/bio.c:1237 [inline]
       bio_iov_iter_get_pages+0x4a8/0x14b0 block/bio.c:1359
       iomap_dio_bio_iter+0xcb3/0x14d0 fs/iomap/direct-io.c:460
       iomap_dio_iter fs/iomap/direct-io.c:-1 [inline]
       __iomap_dio_rw+0xf57/0x1e10 fs/iomap/direct-io.c:753
       iomap_dio_rw+0x45/0xb0 fs/iomap/direct-io.c:847
       xfs_file_dio_write_aligned+0x36a/0x450 fs/xfs/xfs_file.c:707
       xfs_file_dio_write fs/xfs/xfs_file.c:910 [inline]
       xfs_file_write_iter+0x7dd/0x920 fs/xfs/xfs_file.c:1122
       new_sync_write fs/read_write.c:593 [inline]
       vfs_write+0x61d/0xb90 fs/read_write.c:686
       ksys_write+0x150/0x270 fs/read_write.c:738
       do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
       do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
       entry_SYSCALL_64_after_hwframe+0x77/0x7f

other info that might help us debug this:

Chain exists of:
  &mm->mmap_lock --> vm_lock --> &sb->s_type->i_mutex_key#24

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(&sb->s_type->i_mutex_key#24);
                               lock(vm_lock);
                               lock(&sb->s_type->i_mutex_key#24);
  rlock(&mm->mmap_lock);

 *** DEADLOCK ***

2 locks held by syz.0.17/5488:
 #0: ffff888031ac6420 (sb_writers#12){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2683 [inline]
 #0: ffff888031ac6420 (sb_writers#12){.+.+}-{0:0}, at: vfs_write+0x227/0xb90 fs/read_write.c:682
 #1: ffff8880467da130 (&sb->s_type->i_mutex_key#24){++++}-{4:4}, at: xfs_ilock_demote+0xbd/0x290 fs/xfs/xfs_inode.c:285

stack backtrace:
CPU: 0 UID: 0 PID: 5488 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
 check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
 check_prev_add kernel/locking/lockdep.c:3165 [inline]
 check_prevs_add kernel/locking/lockdep.c:3284 [inline]
 validate_chain kernel/locking/lockdep.c:3908 [inline]
 __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
 gup_fast_fallback+0x226/0x22e0 mm/gup.c:3204
 iov_iter_extract_user_pages lib/iov_iter.c:1763 [inline]
 iov_iter_extract_pages+0x37b/0x5f0 lib/iov_iter.c:1826
 __bio_iov_iter_get_pages block/bio.c:1237 [inline]
 bio_iov_iter_get_pages+0x4a8/0x14b0 block/bio.c:1359
 iomap_dio_bio_iter+0xcb3/0x14d0 fs/iomap/direct-io.c:460
 iomap_dio_iter fs/iomap/direct-io.c:-1 [inline]
 __iomap_dio_rw+0xf57/0x1e10 fs/iomap/direct-io.c:753
 iomap_dio_rw+0x45/0xb0 fs/iomap/direct-io.c:847
 xfs_file_dio_write_aligned+0x36a/0x450 fs/xfs/xfs_file.c:707
 xfs_file_dio_write fs/xfs/xfs_file.c:910 [inline]
 xfs_file_write_iter+0x7dd/0x920 fs/xfs/xfs_file.c:1122
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:686
 ksys_write+0x150/0x270 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f85b679aeb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd910b1588 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f85b6a15fa0 RCX: 00007f85b679aeb9
RDX: 000000000000f000 RSI: 0000200000000200 RDI: 0000000000000007
RBP: 00007f85b6808c1f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f85b6a15fac R14: 00007f85b6a15fa0 R15: 00007f85b6a15fa0
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

