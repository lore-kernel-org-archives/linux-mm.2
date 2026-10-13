Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C63CA9EC5
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 02:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1CEC6B008A; Mon, 12 Oct 2026 22:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF4DE6B008C; Mon, 12 Oct 2026 22:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE4526B0092; Mon, 12 Oct 2026 22:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A6E8A6B008A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:17:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2D0E71C3DFF
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:17:59 +0000 (UTC)
X-FDA: 85315992678.20.9689EA8
Received: from mta0.migadu.com (out-67.mta0.migadu.com [91.218.175.67])
	by imf16.hostedemail.com (Postfix) with ESMTP id DBBA2180002
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 02:17:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KlUKhBqT;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791857877;
	b=IqWn6Zom8ta74mEfP97NItiCktxV2xDDekwQE6G67DbaB/EBHTDqY3/sAhxJKTK4SPYg+4
	loWYu1V/+TxUBl2o8Qyx//8bwP8cKfckF/na3ritx4BzgYDR+PxbesFhIKslNzDHNGdFT0
	wayA7bWPTjcSt1cimNRc8H1ydRIOWe0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KlUKhBqT;
	spf=pass (imf16.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.67 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791857877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XcbY6GHXx+u6I4bK/WphO8g/dkWhMlhBY/sW3Qz0PsU=;
	b=t5/kPTis8Is7hhJcyI3y2AmZ2+XPFnpd2BYUcw2+6uy85EZLolB5CQnAwNZcsm6ZdXUHnO
	Taup6LpqKjJrJQdim1QPlFDpeiHV+XwVjmibeqSU9zmrR3SFPkHcu44Hk5hvdm4CMDl59n
	/wtrJZCbv0VaRMkod9yq5CoMp/rssSk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jqBD77UOTyYWp8LQl19v9uNbH02DwyMcdp1Km7VJIyU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791857875; v=1; x=1792462675;
 b=KlUKhBqTHE3cMyZVH8jSiitjq5XDDDcw5npLF/shy+ElifwoTmQ5o82dVY+c2NEVUybi8EJP
 z4b1r7PgpddjhiGuXjndBA5Sp5KMoz6Htm8/ful8el/7KKeQ9k3Sc/ElklqPEaaI9bpRLuFy8Vz
 tT0djsw8PRydg/b9wM+7vK4c=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 665a5cf49eac3c84;
	Tue, 13 Oct 2026 02:17:55 +0000
X-Mizu-Trace-ID: 665a5cf49eac3c84
X-Migadu-Flow: FLOW_OUT
Message-ID: <103d5ab1-b9b5-4cf6-bf87-87771b91eea1@linux.dev>
Date: Tue, 13 Oct 2026 10:17:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [mm?] possible deadlock in igrab
To: Andrew Morton <akpm@linux-foundation.org>,
 syzbot <syzbot+9d97402eade2fc0c065c@syzkaller.appspotmail.com>
Cc: david@fromorbit.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 muchun.song@linux.dev, roman.gushchin@linux.dev,
 syzkaller-bugs@googlegroups.com
References: <6acd315b.8cdf6287.1eb53.0133.GAE@google.com>
 <20261012185640.5568805f927f4de127bf0f28@linux-foundation.org>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261012185640.5568805f927f4de127bf0f28@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: png4mezuubyhc84wsjs4pwb8fdeuhnz3
X-Rspamd-Queue-Id: DBBA2180002
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791857876-333210
X-HE-Meta: U2FsdGVkX1/B+Udv4uYz/Nng0Y4DoPJPL/0gnPesRBucXFNhGOCNqRPKGT/jTclIwpsbGl+K+KWmF9lsUU1yGwGKs8PuDrfeAzF9WJFJgXGCnWr7Mvw444pnvyPm2nvP+HXG7GXan6nWsRSq5ooOhG3IrQQk0CqtwTd6lieLfIKRMOsU4ak9O5OfBnmPtuDe7VYuPlxM4PMF+stFVfPh3SdGK/ggd5kuO8zje7Sw6yK+BtFeZMI9y4WrZARl+arQ5UNUcRjzLy4W/1C1gK4S8I+X8XAR6SUnj1BOs86Dg7n5kYXlJH+Tvdf+WuNultfOIUVGtM2dxkupHRTPzofGvXGraS2iLBo3aZfitD3Wy64XEhn1kpngXz4rrudazXdGb1WXXnhSk+/0NZelcnqwpsk9UNEzsdqr9bekxiSedmwWCBbt+A7w5sRlPBo8ghoWsJcVDl9Hezi9Y/JX6G9J3RsmOo+qZaq7qLzdCGimszUbxTowa0aPEDee3CqPVcYaq588rQbM07+3uUCby2BylLFkn1o2IcQJOx1UEx5ccTfztwb4wDHIAB8ELvQVzeN1b5cNW9E8iyfbU5eu4SFVxKueF5SvKDo0q7r1aAY6d7Zlha+kXPi6dhzac5ThZqbflk1zz4GI2/HfHHQQBc8QqO9gkcOvt+Bc40XPbQU5n+rxHIldD1MBbEiW7EMIALWK6/uYfq7ngqdfG+GuoZFB74311xZun7s4i69gX310UtDFJKGnKA6mtjFe6971OJDE8U4GUJ4lCT9PzJJpNuwQJQEu7DtIYdHwqji0+eKiuKnrHJtZDBTghuWysn8S+ReOy95uQepoLH1EvKYAiCQnql1o9Hn1OQpKfRVWiNZyPgCYjNgQ0Tv8EUxL0YMBDnCMJA6UE0hTq9UsGiZxaA0Mta1RdGiQxwUifOwiP4CLQnt/ODjV/XEjtmOzdMcsLPz1z9rdGK5Bxw8u8paEoJX
 XrC82u1D
 imrWh/f+z08NgQloOC7qB/0rISHJ8p585QiYTQ/v1bh/Md6CaMLrBe1TBGP7tnkTDLl3JeyP9wrU8+06vbMpS92zoR+umnwHm+H93s7RXBFncBMyWAzJp6b02GahJ4neDB7LmjSQ2zUUGSjraU+ovKPTIbcqg0oeN14/473jlQt5rcW63bD8m902UHDETzUzTsvuUHvz0tMdHtXFsbDkGsxf9jIkJMsKC2TamQGOaj2dodX6AWz0Es/otjTXPeKhDqtrfNusdZ/wKpX3NeNjbkT9O4BE1ry0PI+qhWn5SFXDeTZpYpE0hQM7hH9vCFjoIs3VQYay/Tn4oRMMzO35b49xdEXtZZiv2pDbHvdzBXsoxltRt0/TFBS7p+vKZGhv+AXr5G9g6/OqJ7O6bvsMlj8s6BtiYjW4BohXIOFlmd6tPm35hMgJpeWSfEglHhL2gv531+mIuasZ4M08ZMnxSovHY7ZSTWRQSC9l9CXq7GpReqp2X4gavfHAk2v16ARBqM9QODTAOq9rHliPlcv5awXsO/Pq9/gVeD+bibQlS3eriQGZee8sg/9m2sh6nubtNLoz65QzIFh499ubMauZDKFRcRql5TsVIw6+b2NVmVlz+lkAlByXl277G5QDBval9KDzCuhBair60G5crcJPdvsrwvpf7QH+4QSEGKdIoo4K3zc4On2Fz5UTbInWYWSS4gDMEXdRedOvomdkEoWUohLO94oIlEWJMUVuO1CEpvp1PgBSDTMzOxuWQBk1fWLb3tEQVta8VmC2DjyZ7rwjez9fV7VpFVr5h3V6A/ukacaAeBSU35f5q4g7s3GHf4cvQKAqrU/YxpSOs9u0SOU4Zt0avfb0aMwjWIYTXur5CCvqIV46BcE3an38yi5TU4UYbOAsKE5m7D7Rmd56zKc9IkyorZsqY1mOU9pBng8ZSZlSvUNqThB/02WB/uBywAtJSXiMCcEH0aFNI+zIradFOO1V/zgna
 IEzD66wa
 dn4wnIiG+Jl14fTD3Ry3tKWx7g1aNghDFAS+PyPqTTENk6bOCD+s+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

On 10/13/26 9:56 AM, Andrew Morton wrote:
> On Mon, 12 Oct 2026 12:13:31 -0700 syzbot <syzbot+9d97402eade2fc0c065c@syzkaller.appspotmail.com> wrote:
> 
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    b01868671970 Add linux-next specific files for 20261007

Looks like this doesn't include my latest fix patch in the testing.

Fix patch: 
https://lore.kernel.org/all/20261011045956.30277-1-qi.zheng@linux.dev/

>> git tree:       linux-next
>> console output: https://syzkaller.appspot.com/x/log.txt?x=17ab503c580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=9ac1ab2cf2112eb1
>> dashboard link: https://syzkaller.appspot.com/bug?extid=9d97402eade2fc0c065c
>> compiler:       Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
>>
>> Unfortunately, I don't have any reproducer for this issue yet.
>>
>> Downloadable assets:
>> disk image: https://storage.googleapis.com/syzbot-assets/20420067bb60/disk-b0186867.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/14149d837264/vmlinux-b0186867.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/17346f8094aa/bzImage-b0186867.xz
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+9d97402eade2fc0c065c@syzkaller.appspotmail.com
>>
>> ======================================================
>> WARNING: possible circular locking dependency detected
>> syzkaller #0 Not tainted
>> ------------------------------------------------------
> 
> Thanks.
> 
> LLM firmly points at mm-stable's 743e7d025d2f ("mm: shmem: make unused
> huge shrinker memcg aware").
> 
> This comes at an awkward time.  The three patch series "make unused
> huge shrinker memcg aware", v4 reverts cleanly so I'm inclined to do
> that.
> 
> If people can come up with a confident fix which we can upstream as a
> hotfix during 7.4-rcX then maybe OK.

Does the issue still reproduce after applying the fix patch above?

Thanks,
Qi

> 
>> syz.5.203/6616 is trying to acquire lock:
>> ffff88807e4d81e0 (&sb->s_type->i_lock_key){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:347 [inline]
>> ffff88807e4d81e0 (&sb->s_type->i_lock_key){+.+.}-{3:3}, at: igrab+0xfb/0x2f0 fs/inode.c:1595
>>
>> but task is already holding lock:
>> ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:347 [inline]
>> ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: lock_list_lru mm/list_lru.c:26 [inline]
>> ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: lock_list_lru_of_memcg+0x261/0x4c0 mm/list_lru.c:96
>>
>> which lock already depends on the new lock.
>>
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #2 (&l->lock){+.+.}-{3:3}:
>>         __raw_spin_lock include/linux/spinlock_api_smp.h:190 [inline]
>>         _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:173
>>         spin_lock include/linux/spinlock.h:347 [inline]
>>         lock_list_lru mm/list_lru.c:26 [inline]
>>         lock_list_lru_of_memcg+0x261/0x4c0 mm/list_lru.c:96
>>         list_lru_lock mm/list_lru.c:156 [inline]
>>         list_lru_add+0x57/0x290 mm/list_lru.c:229
>>         list_lru_add_obj+0x191/0x270 mm/list_lru.c:254
>>         d_lru_add+0xd8/0x1a0 fs/dcache.c:522
>>         retain_dentry fs/dcache.c:912 [inline]
>>         fast_dput+0x55c/0x690 fs/dcache.c:1005
>>         dput+0x2b/0x60 fs/dcache.c:1054
>>         path_put fs/namei.c:722 [inline]
>>         put_link+0x112/0x190 fs/namei.c:1201
>>         walk_component fs/namei.c:2316 [inline]
>>         link_path_walk+0x12da/0x1910 fs/namei.c:2682
>>         path_openat+0x1c4/0x1da0 fs/namei.c:5036
>>         do_file_open+0x23e/0x4a0 fs/namei.c:5069
>>         do_open_execat+0x12b/0x590 fs/exec.c:786
>>         open_exec fs/exec.c:822 [inline]
>>         bprm_open_interpreter+0x85/0xb0 fs/exec.c:1455
>>         load_elf_binary+0x1a5d/0x28d0 fs/binfmt_elf.c:904
>>         search_binary_handler fs/exec.c:1777 [inline]
>>         exec_binprm fs/exec.c:1809 [inline]
>>         bprm_execve+0x930/0x1590 fs/exec.c:1865
>>         kernel_execve+0x8af/0x9a0 fs/exec.c:2009
>>         try_to_run_init_process+0x13/0x60 init/main.c:1489
>>         kernel_init+0xb2/0x1d0 init/main.c:1619
>>         ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>>         ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>
>> -> #1 (&lockref->lock){+.+.}-{3:3}:
>>         __raw_spin_lock include/linux/spinlock_api_smp.h:190 [inline]
>>         _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:173
>>         spin_lock include/linux/spinlock.h:347 [inline]
>>         d_instantiate+0x72/0xb0 fs/dcache.c:2252
>>         d_make_root+0x59/0x80 fs/dcache.c:2294
>>         shmem_fill_super+0xcbc/0x1150 mm/shmem.c:5290
>>         get_tree_super fs/super.c:1400 [inline]
>>         get_tree_nodev+0xbb/0x150 fs/super.c:1420
>>         vfs_get_tree+0x92/0x2a0 fs/super.c:1943
>>         fc_mount fs/namespace.c:1278 [inline]
>>         vfs_kern_mount+0x15b/0x220 fs/namespace.c:1316
>>         kern_mount+0x43/0x90 fs/namespace.c:6500
>>         shmem_init+0x37/0x170 mm/shmem.c:5610
>>         mnt_init+0x19b/0x1f0 fs/namespace.c:6481
>>         vfs_caches_init+0x22/0x30 fs/dcache.c:3686
>>         start_kernel+0x351/0x3e0 init/main.c:1170
>>         x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
>>         x86_64_start_kernel+0x137/0x1b0 arch/x86/kernel/head64.c:291
>>         common_startup_64+0x13e/0x157
>>
>> -> #0 (&sb->s_type->i_lock_key){+.+.}-{3:3}:
>>         check_prev_add kernel/locking/lockdep.c:3209 [inline]
>>         check_prevs_add kernel/locking/lockdep.c:3328 [inline]
>>         validate_chain kernel/locking/lockdep.c:3952 [inline]
>>         __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
>>         lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>>         __raw_spin_lock include/linux/spinlock_api_smp.h:190 [inline]
>>         _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:173
>>         spin_lock include/linux/spinlock.h:347 [inline]
>>         igrab+0xfb/0x2f0 fs/inode.c:1595
>>         shmem_unused_huge_isolate+0x4f/0x290 mm/shmem.c:874
>>         __list_lru_walk_one+0x171/0x440 mm/list_lru.c:362
>>         list_lru_walk_one+0x3c/0x50 mm/list_lru.c:399
>>         list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
>>         shmem_unused_huge_shrink+0x173/0x1270 mm/shmem.c:966
>>         super_cache_scan+0x411/0x4a0 fs/super.c:231
>>         do_shrink_slab+0x6d0/0x10d0 mm/shrinker.c:445
>>         shrink_slab_memcg mm/shrinker.c:562 [inline]
>>         shrink_slab+0x838/0x1210 mm/shrinker.c:640
>>         drop_slab_node mm/vmscan.c:488 [inline]
>>         drop_slab+0x140/0x280 mm/vmscan.c:506
>>         drop_caches_sysctl_handler+0xc7/0x170 fs/drop_caches.c:68
>>         proc_sys_call_handler+0x4c1/0x830 fs/proc/proc_sysctl.c:600
>>         do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
>>         vfs_writev+0x343/0x990 fs/read_write.c:1058
>>         do_writev+0x154/0x2e0 fs/read_write.c:1104
>>         do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>>         do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> other info that might help us debug this:
>>
>> Chain exists of:
>>    &sb->s_type->i_lock_key --> &lockref->lock --> &l->lock
>>
>>   Possible unsafe locking scenario:
>>
>>         CPU0                    CPU1
>>         ----                    ----
>>    lock(&l->lock);
>>                                 lock(&lockref->lock);
>>                                 lock(&l->lock);
>>    lock(&sb->s_type->i_lock_key);
>>
>>   *** DEADLOCK ***
>>
>> locks held by syz.5.203/6616: 5, last CPU#0:
>>   #0: ffff88807a2ef270 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x118/0x160 fs/file.c:1408
>>   #1: ffff8880582de460 (sb_writers#3){.+.+}-{0:0}, at: file_start_write include/linux/fs.h:2756 [inline]
>>   #1: ffff8880582de460 (sb_writers#3){.+.+}-{0:0}, at: vfs_writev+0x2af/0x990 fs/read_write.c:1056
>>   #2: ffff88807fe9e0e8 (&type->s_umount_key#56){++++}-{4:4}, at: super_trylock_shared fs/super.c:670 [inline]
>>   #2: ffff88807fe9e0e8 (&type->s_umount_key#56){++++}-{4:4}, at: super_cache_scan+0x94/0x4a0 fs/super.c:200
>>   #3: ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:347 [inline]
>>   #3: ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: lock_list_lru mm/list_lru.c:26 [inline]
>>   #3: ffff888062a65640 (&l->lock){+.+.}-{3:3}, at: lock_list_lru_of_memcg+0x261/0x4c0 mm/list_lru.c:96
>>   #4: ffff88807e4d8018 (&info->lock){+.+.}-{3:3}, at: spin_trylock include/linux/spinlock.h:359 [inline]
>>   #4: ffff88807e4d8018 (&info->lock){+.+.}-{3:3}, at: shmem_unused_huge_isolate+0x26/0x290 mm/shmem.c:870
>>
>> stack backtrace:
>> CPU: 0 UID: 0 PID: 6616 Comm: syz.5.203 Not tainted syzkaller #0 PREEMPT(full)
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/16/2026
>> Call Trace:
>>   <TASK>
>>   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>   print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
>>   check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
>>   check_prev_add kernel/locking/lockdep.c:3209 [inline]
>>   check_prevs_add kernel/locking/lockdep.c:3328 [inline]
>>   validate_chain kernel/locking/lockdep.c:3952 [inline]
>>   __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
>>   lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>>   __raw_spin_lock include/linux/spinlock_api_smp.h:190 [inline]
>>   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:173
>>   spin_lock include/linux/spinlock.h:347 [inline]
>>   igrab+0xfb/0x2f0 fs/inode.c:1595
>>   shmem_unused_huge_isolate+0x4f/0x290 mm/shmem.c:874
>>   __list_lru_walk_one+0x171/0x440 mm/list_lru.c:362
>>   list_lru_walk_one+0x3c/0x50 mm/list_lru.c:399
>>   list_lru_shrink_walk include/linux/list_lru.h:332 [inline]
>>   shmem_unused_huge_shrink+0x173/0x1270 mm/shmem.c:966
>>   super_cache_scan+0x411/0x4a0 fs/super.c:231
>>   do_shrink_slab+0x6d0/0x10d0 mm/shrinker.c:445
>>   shrink_slab_memcg mm/shrinker.c:562 [inline]
>>   shrink_slab+0x838/0x1210 mm/shrinker.c:640
>>   drop_slab_node mm/vmscan.c:488 [inline]
>>   drop_slab+0x140/0x280 mm/vmscan.c:506
>>   drop_caches_sysctl_handler+0xc7/0x170 fs/drop_caches.c:68
>>   proc_sys_call_handler+0x4c1/0x830 fs/proc/proc_sysctl.c:600
>>   do_iter_readv_writev+0x612/0x8c0 fs/read_write.c:-1
>>   vfs_writev+0x343/0x990 fs/read_write.c:1058
>>   do_writev+0x154/0x2e0 fs/read_write.c:1104
>>   do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>>   do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>> RIP: 0033:0x7fe53d79e199
>> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
>> RSP: 002b:00007fe53e739028 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
>> RAX: ffffffffffffffda RBX: 00007fe53da25fa0 RCX: 00007fe53d79e199
>> RDX: 0000000000000001 RSI: 00002000000000c0 RDI: 0000000000000004
>> RBP: 00007fe53d835888 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
>> R13: 00007fe53da26038 R14: 00007fe53da25fa0 R15: 00007ffc0e7c9828
>>   </TASK>
>> syz.5.203 (6616): drop_caches: 2
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>
>> If the report is already addressed, let syzbot know by replying with:
>> #syz fix: exact-commit-title
>>
>> If you want to overwrite report's subsystems, reply with:
>> #syz set subsystems: new-subsystem
>> (See the list of subsystem names on the web dashboard)
>>
>> If the report is a duplicate of another one, reply with:
>> #syz dup: exact-subject-of-another-report
>>
>> If you want to undo deduplication, reply with:
>> #syz undup


