Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FB6CF94CB0
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 21:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60C106B0088; Tue, 21 Apr 2026 17:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4836B0089; Tue, 21 Apr 2026 17:27:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F9676B008A; Tue, 21 Apr 2026 17:27:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 33F7E6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:27:53 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A9A48160603
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:27:52 +0000 (UTC)
X-FDA: 84683850384.09.9A4D1D4
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf08.hostedemail.com (Postfix) with ESMTP id CB5DE160003
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:27:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I/9fN0wS";
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776806871;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLngV7i7xXsVSW/9A1y+b0ATWT3UU2g57XAEnBa4PaM=;
	b=pNVqr3Rhy7Asi5AK9LubsoxnqMGoy39Yz0JdisM6+EpEKTkWnU2PS8MTtswYyVtkkI0Y7Z
	u3eQDAyNCi6G4vZBHCiVWDseatfGM1JfACUw7QjW+xSJ0KbscVgASnmmBm9WqiTycsUS9b
	G/9hpwl0UYipBf2mioLZQKvqbL4ylV0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776806871; a=rsa-sha256;
	cv=none;
	b=Zsmg2fiOkBObl+mGGiuVLQqr/zOujnmYEVbDsTZxURZVUotNbBQQoIkC4CcQDjm0Ilk8F5
	abgNRPidZaLT4SEforAUEbvUKt96SsJL4rkCREXcARpMPKairG6Fu1MLs3mtcx6I0tgUk1
	908vqiq+oo7qjt27BTrAGwUBGiWLi5I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I/9fN0wS";
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 21 Apr 2026 14:27:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776806867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MLngV7i7xXsVSW/9A1y+b0ATWT3UU2g57XAEnBa4PaM=;
	b=I/9fN0wSbBLd4WWEzbUfhYMd603LYslIlLhtVN9IqcY5z7niHfs3SFIDfLQssHZDKUl0Qz
	/7zQM5mwdhaR1IZgAXPzbR0lC3/lEMwxr8UEeF59BaoER/aAohf0GzdOI0wRwwk5GsaMCM
	KSAaXOgB264c+gIDOAq8LNWvqA6Kk1o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: syzbot <syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, david@kernel.org, 
	hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, syzkaller-bugs@googlegroups.com, weixugc@google.com, 
	yuanchu@google.com, zhengqi.arch@bytedance.com, brauner@kernel.org, 
	djwong@kernel.org, jack@suse.cz
Subject: Re: [syzbot] [mm?] possible deadlock in rhashtable_free_and_destroy
Message-ID: <aefpEFTg-4KitXxF@linux.dev>
References: <69e798fe.050a0220.24bfd3.0032.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69e798fe.050a0220.24bfd3.0032.GAE@google.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bo9zejxfwwyuohnjea6hegsyzrnnaquf
X-Rspam-User: 
X-Rspamd-Queue-Id: CB5DE160003
X-Rspamd-Server: rspam05
X-HE-Tag: 1776806870-797328
X-HE-Meta: U2FsdGVkX19LutR7J+f49dtVqEhOOIuSB8v3RR5cGtC2xV/El6Qg9bJVLVptP1f6yILnf3pEO14VyDO3frPcKPiX+MfmEWJgsAAKjhMQacefsH9ZFs4TKghZ0I0gB2qk6THLvE7vn07WWTcX17SbNMdbqmZF6IwbrdAtIHJVXFgdRLVQozfbzRD60sbu4IE3q7Fbvj7S+4CArlmvah3QT0FyZsERwtvaymKzUOnkPyTY8PT/gTFq0/nDkolZ5zCc4YWrUdtqhWropFblu+4oRT6x/DRoe+Q3Kf0i+dcccNuVoHGc5isyf9GVp4tS8vaU7i4mWcLszwynH9rjhTkCEhSEeG4qorQLhA0gyBByPKKj7f1PZ9egnECyJdSddppTjT0P4byopy4SVUZHnr3Al6NvZ/B06xa/RyYxsa62xLym+zZ69rBycTILOzXXV3vJSlk/gaPF1shkd3/XB29lGDj+x7GwpBVwkorHoe8w6w+L0XuitF7CoYl/PJ5ItQ4nOAie/7Qap4LZVv8AvGfIAG7pYDDzi5cjfAUwu4FzTU12/ZDf7ODdsTfqavH/J4YBIfuB7oUdyRVVpjb06UDEgfeAhbmJ+jKWy7l0eS3uVkiXkCeIEURMzrFDY8Fnrvh5R31OBwP1ZR4dvpOQ2rah1Y17Kz0zrgh6c2Z732fCs5syq4s6P+Ous+exENLG0H6M8FGiVXuIsKnUNdqe/UFe2Z6fu+uZhw3DmvXS9ZhYVACJkDlZEx5xWJjBYFYtye96h0GzVCsScUbTm5fDjzYB/sLmIb9bDLwYokRLgiXiV1I8yL3PUo6g0UqiKa1OQxZSFWIVtLAB3eVWO6KcUmh99hDq1GBOjU0Ioif2hEoga5z7WFNkwUOrjUFbyrUr2Gn8J7JqIG4kjZkNOePutKKSSEx4jxPwlBlzcWJnkBK+5QZKuwP2rDthCw1vKAvXtr6Jk/OZZ0nDduRAOPdE2OT
 g/crX+XA
 0ZkjxM/1/Aai6rYOhJNMHswSGz9Ba8qFA1Q6FkoQ3SGIGzAq+fKE9mGPSQPaJVjaXLj3zdelIsrko3564H+tRGJC1eWNFQF6S+5S4Bt/d1OF2qCBDK3zkN43O3aVcAgKc/IdStCosHFi4VbfPJ6PnnylY1GVnUvYjpzP5i9c2eKvCnRBRsgo8+HJYiLX5ah1Ds+0ZSPYBDUVYf8TNtldWiI3bWyW7pzwGrRLY96oHXtubBmP7rf1kUUfFJpKHqFxDynqISCxrgE1sbAkjTL+/WHA3I9sW4FRk8CZzT938FYE1KG8DqLANAgl/qfjxWE6GkJ0FeaabunOTsynmBVThxQm9pgOO/lqsjc5LWVQLxq72NJgrJcjj4D7aQEeTBgvzePVtiUegOKJLUUF4nsD7MYucsmFZeXDGbDDBW1ILgrwz+Kjb5q2ZpvIHPWhJB9v8/5cAO+3q6WSHuoHnHsjZmx3l7SKMNuueeJMNh1akXdtfHrOTt0wZMBpkHwk8vFG5L2FnbZDJUx3pkYSnWUOaSC6yvxQtRkLKrSNxSqJtuP1Xo5x41iMswlTuj1RqaBZ2PdwE98IYdENNb2SeG0/0cLx5IopLL0q8G+rO5DDjEC/JbfITkisKe7lNfKylkLWw6c2w8mlIrow2dO1jWlWEwiHW5yCJnbGe5VkTyhWbbLJjOg25JiKnx4879lIQy6ljRuTGuRHOxw9+teLS8fMWfmrIc07PLVWzJBY4heCaGxqSejRSyZVBLZllQf5Rzbp16GHJILnYM4dLvKlRumAmYirtIzcQFW0DxFnQoBMOMt2jIj5docEETAtDqesHBD/7XP9AQ4L+3KIi3Qdvjr5/0OTDjgZZqdgFKedtSC1VgDQIc85IWpCwNuvbA4pPPI6xgKiEHF32YBoFTOrLhVkhKX2DSau9/JLdc/QsesBk3ri1YPwsV+LxDotJCTJ8lJ6vUAK1dtsg0GhOxbo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ccing relevant folks as this seems related to recent change of moving
simple_xattrs from rbtree to rhastable.

On Tue, Apr 21, 2026 at 08:34:22AM -0700, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    8541d8f725c6 Merge tag 'mtd/for-7.1' of git://git.kernel.o..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=15380836580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=7e54da1916e8d11f
> dashboard link: https://syzkaller.appspot.com/bug?extid=5af806780f38a5fe691f
> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8541d8f7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/22dfea2c37c2/vmlinux-8541d8f7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/e2f93ad68fe3/bzImage-8541d8f7.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
> 
> ======================================================
> WARNING: possible circular locking dependency detected
> syzkaller #0 Tainted: G             L     
> ------------------------------------------------------
> kswapd0/108 is trying to acquire lock:
> ffff888056f3c4e8 (&ht->mutex){+.+.}-{4:4}, at: rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154
> 
> but task is already holding lock:
> ffffffff8e9b0800 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xb5d/0x1ac0 mm/vmscan.c:7102
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (fs_reclaim){+.+.}-{0:0}:
>        __fs_reclaim_acquire mm/page_alloc.c:4327 [inline]
>        fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4341
>        might_alloc include/linux/sched/mm.h:317 [inline]
>        slab_pre_alloc_hook mm/slub.c:4520 [inline]
>        slab_alloc_node mm/slub.c:4875 [inline]
>        __do_kmalloc_node mm/slub.c:5294 [inline]
>        __kvmalloc_node_noprof+0xcc/0xa00 mm/slub.c:6828
>        bucket_table_alloc.isra.0+0x88/0x460 lib/rhashtable.c:186
>        rhashtable_rehash_alloc+0x68/0x110 lib/rhashtable.c:368
>        rht_deferred_worker+0x1d9/0x1fd0 lib/rhashtable.c:429
>        process_one_work+0xa0e/0x1980 kernel/workqueue.c:3302
>        process_scheduled_works kernel/workqueue.c:3385 [inline]
>        worker_thread+0x5ef/0xe50 kernel/workqueue.c:3466
>        kthread+0x370/0x450 kernel/kthread.c:436
>        ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> -> #0 (&ht->mutex){+.+.}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x14b8/0x2630 kernel/locking/lockdep.c:5237
>        lock_acquire kernel/locking/lockdep.c:5868 [inline]
>        lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
>        __mutex_lock_common kernel/locking/mutex.c:632 [inline]
>        __mutex_lock+0x1a4/0x1b10 kernel/locking/mutex.c:806

The cancel_work_sync(&ht->run_work) in rhashtable_free_and_destroy() should
avoid concurrent mutex lockers from rht_deferred_worker(). Seems like false
positive as all rhastables share single static lockdep class for the ht->mutex.

Simple fix would be to move rhashtable_rehash_alloc() to use NOFS allocation or
we can introduce more fine grained lockdep classes for rhashtables. 

>        rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154
>        shmem_evict_inode+0x1ae/0xc40 mm/shmem.c:1429
>        evict+0x3c2/0xad0 fs/inode.c:841
>        iput_final fs/inode.c:1960 [inline]
>        iput.part.0+0x605/0xf50 fs/inode.c:2009
>        iput+0x35/0x40 fs/inode.c:1975
>        dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
>        __dentry_kill+0x1d0/0x600 fs/dcache.c:670
>        finish_dput+0x76/0x480 fs/dcache.c:879
>        dput.part.0+0x456/0x570 fs/dcache.c:928
>        dput+0x1f/0x30 fs/dcache.c:920
>        ovl_destroy_inode+0x3e/0x190 fs/overlayfs/super.c:217
>        destroy_inode+0xcb/0x1c0 fs/inode.c:394
>        evict+0x599/0xad0 fs/inode.c:865
>        iput_final fs/inode.c:1960 [inline]
>        iput.part.0+0x605/0xf50 fs/inode.c:2009
>        iput+0x35/0x40 fs/inode.c:1975
>        dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
>        __dentry_kill+0x1d0/0x600 fs/dcache.c:670
>        shrink_kill fs/dcache.c:1147 [inline]
>        shrink_dentry_list+0x180/0x5e0 fs/dcache.c:1174
>        prune_dcache_sb+0xea/0x150 fs/dcache.c:1256
>        super_cache_scan+0x328/0x550 fs/super.c:223
>        do_shrink_slab+0x416/0x1240 mm/shrinker.c:440
>        shrink_slab_memcg mm/shrinker.c:557 [inline]
>        shrink_slab+0xa7d/0x12e0 mm/shrinker.c:635
>        shrink_one+0x398/0x7f0 mm/vmscan.c:4932
>        shrink_many mm/vmscan.c:4993 [inline]
>        lru_gen_shrink_node mm/vmscan.c:5071 [inline]
>        shrink_node+0x2673/0x3dc0 mm/vmscan.c:6059
>        kswapd_shrink_node mm/vmscan.c:6913 [inline]
>        balance_pgdat+0xaaf/0x1ac0 mm/vmscan.c:7089
>        kswapd+0x557/0xb60 mm/vmscan.c:7362
>        kthread+0x370/0x450 kernel/kthread.c:436
>        ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> 
> other info that might help us debug this:
> 
>  Possible unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(fs_reclaim);
>                                lock(&ht->mutex);
>                                lock(fs_reclaim);
>   lock(&ht->mutex);
> 
>  *** DEADLOCK ***
> 
> 2 locks held by kswapd0/108:
>  #0: ffffffff8e9b0800 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xb5d/0x1ac0 mm/vmscan.c:7102
>  #1: ffff88801347c0d8 (&type->s_umount_key#76){++++}-{4:4}, at: super_trylock_shared fs/super.c:565 [inline]
>  #1: ffff88801347c0d8 (&type->s_umount_key#76){++++}-{4:4}, at: super_cache_scan+0x98/0x550 fs/super.c:198
> 
> stack backtrace:
> CPU: 2 UID: 0 PID: 108 Comm: kswapd0 Tainted: G             L      syzkaller #0 PREEMPT(full) 
> Tainted: [L]=SOFTLOCKUP
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:94 [inline]
>  dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>  print_circular_bug.cold+0x178/0x1c7 kernel/locking/lockdep.c:2043
>  check_noncircular+0x146/0x160 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>  __lock_acquire+0x14b8/0x2630 kernel/locking/lockdep.c:5237
>  lock_acquire kernel/locking/lockdep.c:5868 [inline]
>  lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
>  __mutex_lock_common kernel/locking/mutex.c:632 [inline]
>  __mutex_lock+0x1a4/0x1b10 kernel/locking/mutex.c:806
>  rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154
>  shmem_evict_inode+0x1ae/0xc40 mm/shmem.c:1429
>  evict+0x3c2/0xad0 fs/inode.c:841
>  iput_final fs/inode.c:1960 [inline]
>  iput.part.0+0x605/0xf50 fs/inode.c:2009
>  iput+0x35/0x40 fs/inode.c:1975
>  dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
>  __dentry_kill+0x1d0/0x600 fs/dcache.c:670
>  finish_dput+0x76/0x480 fs/dcache.c:879
>  dput.part.0+0x456/0x570 fs/dcache.c:928
>  dput+0x1f/0x30 fs/dcache.c:920
>  ovl_destroy_inode+0x3e/0x190 fs/overlayfs/super.c:217
>  destroy_inode+0xcb/0x1c0 fs/inode.c:394
>  evict+0x599/0xad0 fs/inode.c:865
>  iput_final fs/inode.c:1960 [inline]
>  iput.part.0+0x605/0xf50 fs/inode.c:2009
>  iput+0x35/0x40 fs/inode.c:1975
>  dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
>  __dentry_kill+0x1d0/0x600 fs/dcache.c:670
>  shrink_kill fs/dcache.c:1147 [inline]
>  shrink_dentry_list+0x180/0x5e0 fs/dcache.c:1174
>  prune_dcache_sb+0xea/0x150 fs/dcache.c:1256
>  super_cache_scan+0x328/0x550 fs/super.c:223
>  do_shrink_slab+0x416/0x1240 mm/shrinker.c:440
>  shrink_slab_memcg mm/shrinker.c:557 [inline]
>  shrink_slab+0xa7d/0x12e0 mm/shrinker.c:635
>  shrink_one+0x398/0x7f0 mm/vmscan.c:4932
>  shrink_many mm/vmscan.c:4993 [inline]
>  lru_gen_shrink_node mm/vmscan.c:5071 [inline]
>  shrink_node+0x2673/0x3dc0 mm/vmscan.c:6059
>  kswapd_shrink_node mm/vmscan.c:6913 [inline]
>  balance_pgdat+0xaaf/0x1ac0 mm/vmscan.c:7089
>  kswapd+0x557/0xb60 mm/vmscan.c:7362
>  kthread+0x370/0x450 kernel/kthread.c:436
>  ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
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

