Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6005CD715DE
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 11:32:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6236B05B1; Sat, 24 Jan 2026 06:32:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5B66B05B2; Sat, 24 Jan 2026 06:32:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27CF86B05B3; Sat, 24 Jan 2026 06:32:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 002436B05B1
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 06:32:09 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7498E1A0278
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 11:32:09 +0000 (UTC)
X-FDA: 84366643578.19.1BC0462
Received: from smtp153-171.sina.com.cn (smtp153-171.sina.com.cn [61.135.153.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id B26BDC0006
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 11:32:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="E/NIEcrJ";
	spf=pass (imf22.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.171 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769254327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkOEQgaEwy9leZy1ujQ4H2JefbzU2lHbydy/pVzpG10=;
	b=KyBXbgkeVVHcXVWglXUuAUHlCr0IWjqi5f5ykzFnDm+0/f7ZGbWi1iUFUq0h9eNwA0Lr1Q
	FcsixHDwxH7dsIoJezbS02H5C3GfMmoJxsrVFIfXZT6004C0LrCAnTOPPODrlLbz2CRBM9
	DlzkEgEpxTOcwGY1gnES7cV5BbWHD48=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b="E/NIEcrJ";
	spf=pass (imf22.hostedemail.com: domain of hdanton@sina.com designates 61.135.153.171 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769254327; a=rsa-sha256;
	cv=none;
	b=54vlMBG43VLVg1LuDcT5vbQ2odT/qHN+4DfEbDdmXzOiqne4oCwOVpnkimo2f7MxpzdWpT
	A2UN+rvVjVgs3pB70EjyDpW7G+F+QO4Slf1SroKf7tbwY2bn2wJ2TYWIG+/cip7W+du/TN
	wQiFoLJ01aegtWQa78NLdYM1zGOBZEE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1769254326;
	bh=qkOEQgaEwy9leZy1ujQ4H2JefbzU2lHbydy/pVzpG10=;
	h=From:Subject:Date:Message-ID;
	b=E/NIEcrJfk84TjDmBvvZc8snPGSDOJGX70Pt/MPSGWfYxAhU1sTnI7a385AsOprtw
	 aRmwWXvxoGs1LRI11mawWiHTQ+Jz1QL/UM4ALl/RcW2fAq/ATTyF3Hd1mEKcbLX++e
	 xXQHFtYw34W8WV75PZ4/IGNxvsWY8nc8XGIYI1+c=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.58.160])
	by sina.com (10.54.253.34) with ESMTP
	id 6974ADAE00002209; Sat, 24 Jan 2026 19:32:01 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 1296846291920
X-SMAIL-UIID: 99F37E143FD540628EBE341A8B8EE97B-20260124-193201-1
From: Hillf Danton <hdanton@sina.com>
To: syzbot <syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com>
Cc: axboe@kernel.dk,
	linux-block@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [block?] possible deadlock in blkdev_read_iter
Date: Sat, 24 Jan 2026 19:31:47 +0800
Message-ID: <20260124113148.2398-1-hdanton@sina.com>
In-Reply-To: <697400dc.a70a0220.35de72.000a.GAE@google.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B26BDC0006
X-Stat-Signature: 6wrwu1qo3tct8tbzuqcet84ef4cjrnm1
X-Rspam-User: 
X-HE-Tag: 1769254325-826174
X-HE-Meta: U2FsdGVkX1/dFzFsfZU2lkbRVWH2eMLfcBfm7IjUwPoKI0csHpuD6Dn1KwpErC7ZB7/vIXPhWwE4ePBV/NPYRjvs0iZwacv4BxtKv7xIIPFKxV4GwHsyK8AYYloo74YKbTwXkP8xqjHKZwsLOgFEIuJTNgZrNwMHpGvcv3dLa1xno8ecYvrhSBJpUX42qXrMm2M2hUYirV5WSokWKLnR26UvjB4NiZxQ/WJQuarTBzIsBWWTg4GE2SMF/hWD0lTArpShoiRTzxFhnSheelP5VfikJIcHyj6GQTIwSknElJFVx6tiC1uX7fZmFUEDPWwNYeVjWfOI0Nl6DjCPhpL/O1RC41n3TyAHHlIfad/420DIuBQB0Da8H3elskGs7zzeQ4u3HoTwOPHK1akXkH2AA769a8+Chcizv9nhqnBM6KfveoAWv9ptcu1Pp21Gh+oCouWk6rejLm3afJ0Mzh3hClSqVQmEfFaUWiRrdvkZP+yOwxt8NhE+HW0Jv63SXWY5iJHKulECEEcdvswbxpi0NubzheQci2Xlfv37WgcZpL5/7ysIJ+UWI7hYpNmNNnUcHfSwley/LvrBDDTckSXLl6R7cUQIdaHn+fUu+uMVx7iDFK4S9SR7rE6eO1ecx32QwK97CKYw350TleNYnxfjBBoGZ1pLI3RqJv7ffonbcDQpXmhzv7dNGpCmfEuKMHpqrkYfS1kpZMWmddU9jaNgwbdscwKJwQMU0nF1+YFKh4GR128pRGczLSPwkjHql5wbWtxe/mK/WyLiieFHz0CvXlFh7vePtpNCxFt0p2EjtyV98pJaL2biS4VwvgWu9aLNoNeNDi6Iadiq0QzQskV+RCUkuKAOgCvs0oBVOQXXJwSdQe77o5f5n2KjzJIY/RlkETBfPXnSs0p+/TEWl54T0WYMJ9Fo3hC5KKOszA6nn3ViodqZp8dEiuy/5z1ZW4MSb3S5wTM5rEwRs8Nqvgf
 u9B7+38Y
 6Ce+auV2lP6fUCE20zofDc02cyre51iBcGsfNtbR+GEz2S6fhJu/qh6/6nRiMXm5Ad1GwkJ8Qf3zKuX4RPBqfSPEU9aZfmY5jM062aIF1ic/NM9merbwSJtqLQopoZlcaVDW+58jNeec7qgrT3fl4R1O0wapYpd22YnxmDM7KM6MOqJi+owFquaK8Z0w7pW+zX1Z3bgWehSTbvXoB/UGNGudHHnP6O/e0ozv9U7ClzdiIH477WPjUn0zFSYplB2WbP7mBkIooNDuRrwzUSPu053HVl+yxYykk/hTp+igejubNGzqLWi5HotF84mRGst7E41WPZ14CR5kXz75JYn+NJnNkqe1d0JKfHG4e/PgB/bP/e3hS5FAt9mWje+DUJ1wc6enFVjZr0v8Jr+JoXBdtLsk16OgZMTSxI4381yhjyHJBSWH0A+vLXpSRFrdd9rBIfrVtfzDuhU5dj6PqnYif18/dPa6P3zX7PzugNZLl+9nGaJg422ESxAPPFCAxfAFIQShKxlCvIRP0IFnFDGHRr0s1IGfEW1ShNNt11pApa/ksDTHqIDEDBCtkKCAl7y7WCXiXjR3dqlYN5obKICGOxAIT7stGELJBSwd6iarAgvzUkdAwxjPrn9aUAW6SBHiTv7Vl1QfHI68Ll6z48AbvIrv/9EE41m5eqpHV6r0YG85DwWJ/SXUDxzSMT4FFHbE00B6hsTgcks7TfcaShz83bCI/ixR+yYMV+UuDaUcJJV0hUuZfFPfprJsBnwGgOIrBTd40Z/SfpJyMuiRAgwj+aI9T6RU3qAVbTZsQ42g75xZtpy9yyLV/x+FaCA7irYv+rCcxw9kYIZbRbq785/H7p9pF0KiWHSd6cS/W00L4u7rZ0W/Pg3Zmo2bjL/6GRiNTYdr6Y1Gzr/00iNWe5PhYmK1jaUFqoX3PDqHqsRXOtfnYY+2MpRHzoJIksFB9ZNvOhuywPdLVVkVQ4yFSmSxPJDVCzNh0
 DDySuwRi
 xfW8+YhP7yz97DpB2TIxN9a0x+7BvVwAw9LbmgusIJsESzs1hJOoyF8iknXG0IHU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Lorenzo and Suren

> Date: Fri, 23 Jan 2026 15:14:36 -0800
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    24d479d26b25 Linux 6.19-rc6
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=100033fa580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=1859476832863c41
> dashboard link: https://syzkaller.appspot.com/bug?extid=4e70c8e0a2017b432f7a
> compiler:       gcc (Debian 12.2.0-14+deb12u1) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11451b9a580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1045e852580000
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-24d479d2.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/d0f3c47f6869/vmlinux-24d479d2.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/800231513703/bzImage-24d479d2.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+4e70c8e0a2017b432f7a@syzkaller.appspotmail.com
> 
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.0.17/6091 is trying to acquire lock:
> ffff8881061287a8 (
> &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: inode_lock_shared include/linux/fs.h:1042 [inline]
> &sb->s_type->i_mutex_key#8){++++}-{4:4}, at: blkdev_read_iter+0x19e/0x500 block/fops.c:855
> 
> but task is already holding lock:
> ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+0x10e/0xed0 mm/mmap_lock.c:334
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (vm_lock){++++}-{0:0}:
>        __vma_enter_locked+0x260/0x770 mm/mmap_lock.c:72
>        __vma_start_write+0x21/0x160 mm/mmap_lock.c:104
>        vma_start_write include/linux/mmap_lock.h:213 [inline]
>        mprotect_fixup+0x4e3/0xb80 mm/mprotect.c:768
>        setup_arg_pages+0x4a2/0xbb0 fs/exec.c:670
>        load_elf_binary+0xb5b/0x4fe0 fs/binfmt_elf.c:1028
>        search_binary_handler fs/exec.c:1669 [inline]
>        exec_binprm fs/exec.c:1701 [inline]
>        bprm_execve fs/exec.c:1753 [inline]
>        bprm_execve+0x8c2/0x1620 fs/exec.c:1729
>        kernel_execve+0x2ef/0x3b0 fs/exec.c:1919
>        try_to_run_init_process init/main.c:1506 [inline]
>        kernel_init+0x14a/0x2b0 init/main.c:1634
>        ret_from_fork+0x983/0xb10 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> 
> -> #1 (&mm->mmap_lock){++++}-{4:4}:
>        __might_fault mm/memory.c:7174 [inline]
>        __might_fault+0x113/0x190 mm/memory.c:7168
>        _copy_to_iter+0x1c2/0x1710 lib/iov_iter.c:196
>        copy_page_to_iter lib/iov_iter.c:374 [inline]
>        copy_page_to_iter+0x12a/0x1e0 lib/iov_iter.c:361
>        copy_folio_to_iter include/linux/uio.h:204 [inline]
>        filemap_read+0x6b1/0xe40 mm/filemap.c:2851
>        blkdev_read_iter+0x1ac/0x500 block/fops.c:856
>        new_sync_read fs/read_write.c:491 [inline]
>        vfs_read+0x8bf/0xcf0 fs/read_write.c:572
>        ksys_read+0x12a/0x250 fs/read_write.c:715
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> -> #0 (&sb->s_type->i_mutex_key#8){++++}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
>        lock_acquire kernel/locking/lockdep.c:5868 [inline]
>        lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
>        down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
>        inode_lock_shared include/linux/fs.h:1042 [inline]
>        blkdev_read_iter+0x19e/0x500 block/fops.c:855
>        __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
>        freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
>        __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
>        do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
>        procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
>        vfs_ioctl fs/ioctl.c:51 [inline]
>        __do_sys_ioctl fs/ioctl.c:597 [inline]
>        __se_sys_ioctl fs/ioctl.c:583 [inline]
>        __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   &sb->s_type->i_mutex_key#8 --> &mm->mmap_lock --> vm_lock
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   rlock(vm_lock);
>                                lock(&mm->mmap_lock);
>                                lock(vm_lock);
>   rlock(&sb->s_type->i_mutex_key#8);
> 
>  *** DEADLOCK ***
> 
> 1 lock held by syz.0.17/6091:
>  #0: ffff888012aa0448 (vm_lock){++++}-{0:0}, at: lock_next_vma+0x10e/0xed0 mm/mmap_lock.c:334
> 
> stack backtrace:
> CPU: 2 UID: 0 PID: 6091 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2~bpo12+1 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x116/0x1f0 lib/dump_stack.c:120
>  print_circular_bug+0x275/0x340 kernel/locking/lockdep.c:2043
>  check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>  __lock_acquire+0x1669/0x2890 kernel/locking/lockdep.c:5237
>  lock_acquire kernel/locking/lockdep.c:5868 [inline]
>  lock_acquire+0x179/0x330 kernel/locking/lockdep.c:5825
>  down_read+0x9b/0x460 kernel/locking/rwsem.c:1537
>  inode_lock_shared include/linux/fs.h:1042 [inline]
>  blkdev_read_iter+0x19e/0x500 block/fops.c:855
>  __kernel_read+0x3f3/0xbf0 fs/read_write.c:530
>  freader_fetch+0x1d7/0x9d0 lib/buildid.c:100
>  __build_id_parse.isra.0+0xdd/0x6c0 lib/buildid.c:297
>  do_procmap_query+0xb0e/0x1080 fs/proc/task_mmu.c:733
>  procfs_procmap_ioctl+0x9d/0xe0 fs/proc/task_mmu.c:813
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl fs/ioctl.c:583 [inline]
>  __x64_sys_ioctl+0x18e/0x210 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xcd/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff1a238f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffebbe538b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007ff1a25e5fa0 RCX: 00007ff1a238f7c9
> RDX: 0000200000000180 RSI: 00000000c0686611 RDI: 0000000000000004
> RBP: 00007ff1a2413f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff1a25e5fa0 R14: 00007ff1a25e5fa0 R15: 0000000000000003
>  </TASK>

