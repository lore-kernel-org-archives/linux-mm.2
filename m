Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF289CA9EC5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 01:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04DCB6B0088; Mon, 12 Oct 2026 21:56:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40D16B008A; Mon, 12 Oct 2026 21:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E57836B008C; Mon, 12 Oct 2026 21:56:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7083D6B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 21:56:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DAFCD40611
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 01:56:43 +0000 (UTC)
X-FDA: 85315939086.24.7B8BC4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 228DC20002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 01:56:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="X1X/jbZH";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791856602;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KYZ/wTZK72AM/wy3Q6MVawdzdE2hlMOXUt6upTAZTvs=;
	b=nH3ELhmqat1RiCq6ZRQVxZ6hkOSnHaiuem/9vTyb0EJS5dYCQ2rdtyxCafAIfRJESXtGkr
	3hPTXIfoDP+uI+ur0ZTafJSmIc2Xk3CEhfACcve5eZ12ds6IlyS7vA0ipayPJ/Y8qiZUjX
	+IoD/KVV9MNjvUlEBmVqmV9JI+3Ap74=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="X1X/jbZH";
	dmarc=none;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791856602;
	b=CSPJCPPYZSMMkX4/nGMqC05/k6olIqhdpfuIL2nvp0Foqm2WwUX+YfAMdUVJg/MWfXVoIF
	loOoRbtjYcuDx+AO0CuyJ5lgxTOjKGQEmL+raiO1jMOEdSh7uqpBQMphffu1RFS4h7bGZK
	2mkCDVR9igni0CAIYXIGUme9SI8k6oE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 242D86020A;
	Tue, 13 Oct 2026 01:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0C81F000FF;
	Tue, 13 Oct 2026 01:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791856600;
	bh=KYZ/wTZK72AM/wy3Q6MVawdzdE2hlMOXUt6upTAZTvs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X1X/jbZHVMqMNrHjCi0JcVAL+HBtPFr5UZ4Sau+R11YEnf35j6+P4b7B8z+e0ncVF
	 X3nzDt0w+1fvKzMgjcldU1OfT5L4U5xf2Kh1X/qgLw1i+HZp7ZxgxBIDtqz4dHNFsI
	 M2CvIgVWndJg3VkJFeMn+EHUQJO9LDaVU8GWfnpA=
Date: Mon, 12 Oct 2026 18:56:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot <syzbot+9d97402eade2fc0c065c@syzkaller.appspotmail.com>
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 muchun.song@linux.dev, qi.zheng@linux.dev, roman.gushchin@linux.dev,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot] [mm?] possible deadlock in igrab
Message-Id: <20261012185640.5568805f927f4de127bf0f28@linux-foundation.org>
In-Reply-To: <6acd315b.8cdf6287.1eb53.0133.GAE@google.com>
References: <6acd315b.8cdf6287.1eb53.0133.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n8dsc367y8fxd9gscohccsek3t95fx91
X-Rspam-User: 
X-Rspamd-Queue-Id: 228DC20002
X-Rspamd-Server: rspam08
X-HE-Tag: 1791856601-945457
X-HE-Meta: U2FsdGVkX1+gIpbM7WQr1QBqClgSSMVVkc7hjo8LFRy16TpPlpmzHNFKV5AlCxAEdo6SPXsShN6cxxiJ/EL8+wXxxcudcVseM9IaiXbxLmSrHVAolUu0A6+MyYjdWEDRNYUPRgzhZ1LXMk5hQWWcCft/uSCLKV0OiFpxu15r2j3eEVTQOLkv+ufKOSRiOjtNPuoarZIXyLZvtaCdaqZJo+/29wuMmQCjnDWNUkl9iZX627kWB1rGsJ4W68pqi91VCtd11cQoXBMmPIbv4Lry44n5XX2DNfwhT3Em0mC0Igsnt2ICnYOqSBe5C5RWwqL69lM0/4SuHvlk6bCKnm/he3LpSp515K6SUwxNbUbdzI6eKgBmaQsbutmeLPfMZwtHkhvZmVsXHA/dZkK9qH3Eu9qLIJfdgjZ6oPE2x47zO5l4fd7en13suCsubEtxc+4RaxMl+Z/sxRp7n/pyvq6GLEN4DXvMI/Vne/IYDf2lzL0HYEDHDfKXxqYNGbnpHI9dPDZpgke5NHf/1Z8o7uJuM2fskX9eCc5vZ/jxox2zNxKWaabuiwZhIPs6uekRmuGBC1Lp2bFibfFVtBfVSr7uhgKs3WS/Z8OWOFlqwuNzEDztK3yHfLxBN3UTkAya4gwjm9TELRaaV0+BqzQXDZx2kD3VQkquebldtgZM4J23r7E8wtHmuskeR35ltf2YvVwZXd0Vb7wO6q5y9ek9zjLn9ddUdzjd5P0Wcb2ZxVYa+dsO2ktWsg+0Zu6FR8S8OEufY/G9qJYS9WL6899juPaVVSmXhFyljkFmzw4BfAXcAr1u+au1iixTN2UKOG/TFs6qcd0URyjljOAgW+uVMdg1l8UMuU1uyB67w4hjIEy3eKDK9GjYWm6ayk93wWaDywC0JG7aRShVwd/Av8Ul7CFJs4ot5DKvElpf+YCrtlLRS8h4SlLzdtQVvVUjMfgLrHgGl+hJG549x/MjbMPQA+f
 E5SvqGae
 CdwBg+dKmxOGwl9yq+35d3piD0hPmfm74TpStsPqGaQEz+ze2a8S/YuiMRleGIZYDhCceKIX7DdIuxlPqzsXRa989U6xVBdoQNf+lxfXT4uXSeIo8bzm2k4vGMsPfyXUcvnHHolK6ktbpFdDZncrMWCY/0IymKS/0uU8ckwiogY6DKsbPP9hybIAj7jBUBrObxnTJeCGiE5JY95+KP70m+1iR5j+gxINo/NIHxveKkZrH7R00+j9gBfbArsTzirFlWEcbfuqv03moN1RnXtqQLDNtmPJsegygIk8KQJNY4CiGvmgkzRvig6NDiQu67tDs5ZIU05+Jw2p8EblYNflEVGAYYYfBW5p2EeJ9gA4BLowYM36sXVikOtNHbIUJusE34sCu3Mkb7V/LSBeAvjbBb/4uQtFZ4Pn9C6iA1s46SqpQqQSHgm4NpAiQlVyNh8mrFICH2jxuGiyk1oZtVXjJe17Dm5MvzR1HGdChAsFSMSBG9QQP3jCA8RzV4g/KyJxmYsmndP67C8DsaQilpjqaZmLVta3DtzclBFOHdm8DpLxmshvwrUsO9kKZq8JU//a/9Vv5wjyfdX00CbmY5NfziWjNkHF8Zvcs5/svYks4Rvf+WbFF24J6ym6LKP+DJTOkzwuaavQZwrMk6saAOYuHOM2EAZNXXR+gjviEh/D2xpGpEHNSADUvu4VAPu1KbsF2jpi7SHzvv+QMaCd9+ZQLCioXL2TCvDpRxs9f1hMr57jNEz7XvqeKe2hBOscO6uBCDGiYmCAr4Olu6Kp65QVogUzsSJBcN/EDl5xpQNRNKwy1M0HB5KaBpq7H8z3P5WRV6LW7lmMPGBrE5KR4G+gp3MK8Ad5c8pPwNR6dJ8a3JOlDBVWKI+nk20STG/PI/meZJ2Qe2eVxUJ15p/TrX0Y/2asyw1jILK9iX6hdI090ojRxVumRJIMzJu9zbk80/aK649TaoGjNUaawAjfeb6miwaISSiZU
 0wScK6xj
 HgN+Lzde6H3Y9+FkUJJ3EnZ8qmtcbU2fGPqeJflrqLmiaYAT2AkFet4rnlW1n52BtX0alxFXbFQf2qsteJxxodm18V0o2vjOTfYGKfzUUkJhZ3z3tRg+qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Oct 2026 12:13:31 -0700 syzbot <syzbot+9d97402eade2fc0c065c@syzkaller.appspotmail.com> wrote:

> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    b01868671970 Add linux-next specific files for 20261007
> git tree:       linux-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=17ab503c580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=9ac1ab2cf2112eb1
> dashboard link: https://syzkaller.appspot.com/bug?extid=9d97402eade2fc0c065c
> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/20420067bb60/disk-b0186867.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/14149d837264/vmlinux-b0186867.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/17346f8094aa/bzImage-b0186867.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9d97402eade2fc0c065c@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------

Thanks.

LLM firmly points at mm-stable's 743e7d025d2f ("mm: shmem: make unused
huge shrinker memcg aware").

This comes at an awkward time.  The three patch series "make unused
huge shrinker memcg aware", v4 reverts cleanly so I'm inclined to do
that.

If people can come up with a confident fix which we can upstream as a
hotfix during 7.4-rcX then maybe OK.

> syz.5.203/6616 is trying to acquire lock:
> ffff88807e4d81e0 (&sb->s_type->i_lock_key){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:347 [inline]
> ffff88807e4d81e0 (&sb->s_type->i_lock_key){+.+.}-{3:3}, at: igrab+0xfb/0x2f0 fs/inode.c:1595
> 
> but task is already holding lock:
> ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:347 [inline]
> ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: lock_list_lru mm/list_lru.c:26 [inline]
> ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: lock_list_lru_of_memcg+0x261/0x4c0 mm/list_lru.c:96
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&l->lock){+.+.}-{3:3}:
>        __raw_spin_lock include/linux/spinlock_api_smp.h:190 [inline]
>        _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:173
>        spin_lock include/linux/spinlock.h:347 [inline]
>        lock_list_lru mm/list_lru.c:26 [inline]
>        lock_list_lru_of_memcg+0x261/0x4c0 mm/list_lru.c:96
>        list_lru_lock mm/list_lru.c:156 [inline]
>        list_lru_add+0x57/0x290 mm/list_lru.c:229
>        list_lru_add_obj+0x191/0x270 mm/list_lru.c:254
>        d_lru_add+0xd8/0x1a0 fs/dcache.c:522
>        retain_dentry fs/dcache.c:912 [inline]
>        fast_dput+0x55c/0x690 fs/dcache.c:1005
>        dput+0x2b/0x60 fs/dcache.c:1054
>        path_put fs/namei.c:722 [inline]
>        put_link+0x112/0x190 fs/namei.c:1201
>        walk_component fs/namei.c:2316 [inline]
>        link_path_walk+0x12da/0x1910 fs/namei.c:2682
>        path_openat+0x1c4/0x1da0 fs/namei.c:5036
>        do_file_open+0x23e/0x4a0 fs/namei.c:5069
>        do_open_execat+0x12b/0x590 fs/exec.c:786
>        open_exec fs/exec.c:822 [inline]
>        bprm_open_interpreter+0x85/0xb0 fs/exec.c:1455
>        load_elf_binary+0x1a5d/0x28d0 fs/binfmt_elf.c:904
>        search_binary_handler fs/exec.c:1777 [inline]
>        exec_binprm fs/exec.c:1809 [inline]
>        bprm_execve+0x930/0x1590 fs/exec.c:1865
>        kernel_execve+0x8af/0x9a0 fs/exec.c:2009
>        try_to_run_init_process+0x13/0x60 init/main.c:1489
>        kernel_init+0xb2/0x1d0 init/main.c:1619
>        ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> -> #1 (&lockref->lock){+.+.}-{3:3}:
>        __raw_spin_lock include/linux/spinlock_api_smp.h:190 [inline]
>        _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:173
>        spin_lock include/linux/spinlock.h:347 [inline]
>        d_instantiate+0x72/0xb0 fs/dcache.c:2252
>        d_make_root+0x59/0x80 fs/dcache.c:2294
>        shmem_fill_super+0xcbc/0x1150 mm/shmem.c:5290
>        get_tree_super fs/super.c:1400 [inline]
>        get_tree_nodev+0xbb/0x150 fs/super.c:1420
>        vfs_get_tree+0x92/0x2a0 fs/super.c:1943
>        fc_mount fs/namespace.c:1278 [inline]
>        vfs_kern_mount+0x15b/0x220 fs/namespace.c:1316
>        kern_mount+0x43/0x90 fs/namespace.c:6500
>        shmem_init+0x37/0x170 mm/shmem.c:5610
>        mnt_init+0x19b/0x1f0 fs/namespace.c:6481
>        vfs_caches_init+0x22/0x30 fs/dcache.c:3686
>        start_kernel+0x351/0x3e0 init/main.c:1170
>        x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
>        x86_64_start_kernel+0x137/0x1b0 arch/x86/kernel/head64.c:291
>        common_startup_64+0x13e/0x157
> 
> -> #0 (&sb->s_type->i_lock_key){+.+.}-{3:3}:
>        check_prev_add kernel/locking/lockdep.c:3209 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3328 [inline]
>        validate_chain kernel/locking/lockdep.c:3952 [inline]
>        __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
>        lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>        __raw_spin_lock include/linux/spinlock_api_smp.h:190 [inline]
>        _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:173
>        spin_lock include/linux/spinlock.h:347 [inline]
>        igrab+0xfb/0x2f0 fs/inode.c:1595
>        shmem_unused_huge_isolate+0x4f/0x290 mm/shmem.c:874
>        __list_lru_walk_one+0x171/0x440 mm/list_lru.c:362
>        list_lru_walk_one+0x3c/0x50 mm/list_lru.c:399
>        list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
>        shmem_unused_huge_shrink+0x173/0x1270 mm/shmem.c:966
>        super_cache_scan+0x411/0x4a0 fs/super.c:231
>        do_shrink_slab+0x6d0/0x10d0 mm/shrinker.c:445
>        shrink_slab_memcg mm/shrinker.c:562 [inline]
>        shrink_slab+0x838/0x1210 mm/shrinker.c:640
>        drop_slab_node mm/vmscan.c:488 [inline]
>        drop_slab+0x140/0x280 mm/vmscan.c:506
>        drop_caches_sysctl_handler+0xc7/0x170 fs/drop_caches.c:68
>        proc_sys_call_handler+0x4c1/0x830 fs/proc/proc_sysctl.c:600
>        do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
>        vfs_writev+0x343/0x990 fs/read_write.c:1058
>        do_writev+0x154/0x2e0 fs/read_write.c:1104
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> other info that might help us debug this:
> 
> Chain exists of:
>   &sb->s_type->i_lock_key --> &lockref->lock --> &l->lock
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&l->lock);
>                                lock(&lockref->lock);
>                                lock(&l->lock);
>   lock(&sb->s_type->i_lock_key);
> 
>  *** DEADLOCK ***
> 
> locks held by syz.5.203/6616: 5, last CPU#0:
>  #0: ffff88807a2ef270 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x118/0x160 fs/file.c:1408
>  #1: ffff8880582de460 (sb_writers#3){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2756 [inline]
>  #1: ffff8880582de460 (sb_writers#3){.+.+}-{0:0}, at: vfs_writev+0x2af/0x990 fs/read_write.c:1056
>  #2: ffff88807fe9e0e8 (&type->s_umount_key#56){++++}-{4:4}, at: super_trylock_shared fs/super.c:670 [inline]
>  #2: ffff88807fe9e0e8 (&type->s_umount_key#56){++++}-{4:4}, at: super_cache_scan+0x94/0x4a0 fs/super.c:200
>  #3: ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:347 [inline]
>  #3: ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: lock_list_lru mm/list_lru.c:26 [inline]
>  #3: ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: lock_list_lru_of_memcg+0x261/0x4c0 mm/list_lru.c:96
>  #4: ffff88807e4d8018 (&info->lock){+.+.}-{3:3}, at: spin_trylock include/linux/spinlock.h:359 [inline]
>  #4: ffff88807e4d8018 (&info->lock){+.+.}-{3:3}, at: shmem_unused_huge_isolate+0x26/0x290 mm/shmem.c:870
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 6616 Comm: syz.5.203 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2026
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
>  check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
>  check_prev_add kernel/locking/lockdep.c:3209 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3328 [inline]
>  validate_chain kernel/locking/lockdep.c:3952 [inline]
>  __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>  __raw_spin_lock include/linux/spinlock_api_smp.h:190 [inline]
>  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:173
>  spin_lock include/linux/spinlock.h:347 [inline]
>  igrab+0xfb/0x2f0 fs/inode.c:1595
>  shmem_unused_huge_isolate+0x4f/0x290 mm/shmem.c:874
>  __list_lru_walk_one+0x171/0x440 mm/list_lru.c:362
>  list_lru_walk_one+0x3c/0x50 mm/list_lru.c:399
>  list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
>  shmem_unused_huge_shrink+0x173/0x1270 mm/shmem.c:966
>  super_cache_scan+0x411/0x4a0 fs/super.c:231
>  do_shrink_slab+0x6d0/0x10d0 mm/shrinker.c:445
>  shrink_slab_memcg mm/shrinker.c:562 [inline]
>  shrink_slab+0x838/0x1210 mm/shrinker.c:640
>  drop_slab_node mm/vmscan.c:488 [inline]
>  drop_slab+0x140/0x280 mm/vmscan.c:506
>  drop_caches_sysctl_handler+0xc7/0x170 fs/drop_caches.c:68
>  proc_sys_call_handler+0x4c1/0x830 fs/proc/proc_sysctl.c:600
>  do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
>  vfs_writev+0x343/0x990 fs/read_write.c:1058
>  do_writev+0x154/0x2e0 fs/read_write.c:1104
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe53d79e199
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe53e739028 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
> RAX: ffffffffffffffda RBX: 00007fe53da25fa0 RCX: 00007fe53d79e199
> RDX: 0000000000000001 RSI: 00002000000000c0 RDI: 0000000000000004
> RBP: 00007fe53d835888 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe53da26038 R14: 00007fe53da25fa0 R15: 00007ffc0e7c9828
>  </TASK>
> syz.5.203 (6616): drop_caches: 2
> 
> 
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> 
> If the report is already addressed, let syzbot know by replying with:
> #syz fix: exact-commit-title
> 
> If you want to overwrite report's subsystems, reply with:
> #syz set subsystems: new-subsystem
> (See the list of subsystem names on the web dashboard)
> 
> If the report is a duplicate of another one, reply with:
> #syz dup: exact-subject-of-another-report
> 
> If you want to undo deduplication, reply with:
> #syz undup

