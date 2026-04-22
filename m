Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32811F94CB7
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 01:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60E126B0005; Tue, 21 Apr 2026 21:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC506B0088; Tue, 21 Apr 2026 21:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5234A6B0089; Tue, 21 Apr 2026 21:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F51A6B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 21:22:10 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BDF8D8D999
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:22:09 +0000 (UTC)
X-FDA: 84684440778.22.CF9674D
Received: from r3-20.sinamail.sina.com.cn (r3-20.sinamail.sina.com.cn [202.108.3.20])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9B7251C0005
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 01:22:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=e1roxzjE;
	spf=pass (imf18.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.20 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776820928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZCCn5Ztz/b9AIPQOIfvyV+R0/WR0VIG4AjqGHyWFOSk=;
	b=qIn9nN+S0xnQu6JC1f1DQ+xu5hmXOGe5V0+eijNCuNSPTA4ZmYnNiYiOmwulytvu7Gk+Cw
	3lThCTOxjAnBHrvvuWiCtzTNfRWyoKrExWL6r//vY/k7rgiaqPY3NMevRv+QoJdBMak3FB
	6+h4Uy71Nxj6N0RFUWd5hKVFrvvSB5E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=sina.com header.s=201208 header.b=e1roxzjE;
	spf=pass (imf18.hostedemail.com: domain of hdanton@sina.com designates 202.108.3.20 as permitted sender) smtp.mailfrom=hdanton@sina.com;
	dmarc=pass (policy=none) header.from=sina.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776820928; a=rsa-sha256;
	cv=none;
	b=X+HGu+a7sgdxy9Kis7onuetvdSTYLebQU7Brr1ltXbpYdoI7fw+zacbezjGvYoXytUTRpn
	FydE+/rz+QNA0Lneyz6jETto6bzrvez2fjwqHuJPNG+7HbQkqjwG86omLI4IjtWfbVosCP
	4K4AR5IhgBVSmhuU0zvhhVny/I9PSbA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sina.com; s=201208; t=1776820926;
	bh=ZCCn5Ztz/b9AIPQOIfvyV+R0/WR0VIG4AjqGHyWFOSk=;
	h=From:Subject:Date:Message-ID;
	b=e1roxzjES2X+7wMz8hYP7QrItiPZ+Rax7QLfx7hxZjqdZsvXGKhtvw9lVjVEFvVLj
	 x5rh8HXomSJBwFLj1GF8ycJYcD9arjqgE/VFW6jeSXk9jF2pt/pPDkcepCoKhlOGPh
	 MeRisExI6tfdsRn7TnP4jxTqcSEGu1w40Hy9W5/E=
X-SMAIL-HELO: localhost.localdomain
Received: from unknown (HELO localhost.localdomain)([114.249.62.144])
	by sina.com (10.54.253.32) with ESMTP
	id 69E822B5000042F8; Wed, 22 Apr 2026 09:21:59 +0800 (CST)
X-Sender: hdanton@sina.com
X-Auth-ID: hdanton@sina.com
X-SMAIL-MID: 2348744457004
X-SMAIL-UIID: 28D39FAF596B4650A5087061345A094E-20260422-092159-1
From: Hillf Danton <hdanton@sina.com>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: syzbot <syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	syzkaller-bugs@googlegroups.com,
	brauner@kernel.org,
	djwong@kernel.org,
	jack@suse.cz
Subject: Re: [syzbot] [mm?] possible deadlock in rhashtable_free_and_destroy
Date: Wed, 22 Apr 2026 09:21:47 +0800
Message-ID: <20260422012148.1994-1-hdanton@sina.com>
In-Reply-To: <aefpEFTg-4KitXxF@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1y1ujqkdtsn5dp4ep91w4hefhsh8x8a8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9B7251C0005
X-HE-Tag: 1776820926-87435
X-HE-Meta: U2FsdGVkX19XL6ZXhvWtpn1qOVZ2QwWoJlQcNBzDEULvBLVohBrmHF0FD+qB0Uw1CLzVqkfQrdKxS32PpjOLnkKa7zLiWe35y3qvbU96pSChzz0PAFWezO9XE6omtzWIMSaPxjnehQsOEEmmIHpJhSp+2u50KRLwgeR6j36ozW5r4MjhLhl53dmLXXjE5TWexA1+ocEekxHNfSP6plSY2nd8blNjI/DvyHuZmPJnzuE45tOex9QAD4upFVDRPujizpfv/wmBwqam676Fs7HZeDTIhKSzjekzirh/vj22ARdVMKzfCesysRsaLfsvQl7NEDIxc9EoDVkmitkBjuGW6jX+ShAKsMBmcU8uPEYjx+Rm+S8g0wjxwrQ8qnaOiUu2wNG4RTEDzm2/dXrHuABu4mZv5+Q3xEJ6TvCNgMMXgegbPoi9+ilflFBkdxsYVTZNHmFymalxIyTzVdqtnlimnuWPSlOgJ4d/+W1CoQ/jL3xRR9vRjhTBhVaVEcPGjq6C7SNGlr5elGwmTCY1atqOCQp4ZgVRC4Gb2kXCWKqzcvEIQOD1SYXoxM13oVDGexyRjzg1MeKCN6dghq17ehyBxCAmKxd+fhDc5KP5E6NRKz/e/XEDZOJkO4jo8wWE822dtDqAXgesF/cKz+aAZiXd5iW+yCti15H8jwVGbIYZzFLIYklFRlIXnPn2AV1uW0TddOU3YmNwybW5GfLLFFhYoW+mdVZs8mttnUGTM1JSYs/GtdLsy/V4ppWtkmWw7S01IzQEWvjxhFSy3nqAnjlMOzx63iryJDdpOdUyBaZqmZVLMAkl06pkyYUy3zriZvxkU7zjkm56giOdGSr37j73VnQUpkTAmxB+BNNjHWMpo3tcrNJmR5oRRAfxhYdxFfjH5LfaKjSL6EckYL6m1FV6w9BiiIOTXInIWratH0x5HRIWxzA45AklKYICztOrmmCxVtsq4GGr0pDlXtDddu1
 Vu9Z2Cyr
 Ea6jB6otMMIm4ukIYj08C/KuXBe8Rn4TxSfDXZjQa57BDyL1b3nwMS/hXfbGfgrhRnK4JFrfx8Xca5DurDCvLiabnx9kFVjRq9ZLdwZUIIXQnKJ6baO53U8vJFSUnoU8zXClu4hXfH3qhJQng+dw8MfI313FFpQ1/fJdhjfYzQbsp6tpEY7nIA0M44yMNezEUT9obRrH8L9owLGBPOpF7KGeoW2GVCVrx+B78MFmhceVkJ4yLg98OdgxZIlZRTavTIZLTUnrJmXtA4tcRZQ4xe+JhdxB324j61ChHE3il08A96LkTxJimyFa/ERRpM4yT8HTmzsmlhdJuxlKxh+fJPUKVBKHVTCv61Jqzj7DSrsa1DFFJnXg3lwlS5+V33kBfA9TSrmitO5ztzDP5+l0kRFGZHX+nzUwsLJZygmutk0ST3hchep+B4TKVFU005PjZE289VXXzn0HvcWGLuZEz38DM+sAUJBtEIbIY+hTOPNZcOJPlR7BNnEG5Y3miYBiSrcVg1eSy1a5tTbczgcdLJCYVNZEDsF6cYjyevZTfx5c6RnKmQ/rCYk/4zohecxbiNJaEjCoUa83LkpFiZgIbrqpev9XAsWEo+lFq0MX6dGDTudprYP5X1IYy01/ZEbd+KVVdAsLM9cpGf6kddCTUTELLOuyv7p2MyS+/PUlttduD3+zlP6kkoF2WiHxEDZYmAGGI4Be0hCpqv9Tvs869/LeiYjLa7a9zqpdSzYwFGYOd0p3QrMekIl1qqtJIrFOXu7q7FXrnlXrLTnZj3AGyGfNO+18Vz7eTlgmmotmUOvfig9d/osnMG1EWaK6yYZPvnSL0pa5kY2aK3nsx73DmHXf3BYNP3lleE3Q2bp5YSiGC4cA99e7AAGElo87U5DJOMhvMrgJoz0tj8TcXnLkAW9ZLPpyvkwOVVTlqFtRaBadwz6xN4x+2HR1+PqgVztn2FQeUmDV1ETvJZcI4v8Dl/8A/xaGW
 PAMT9N5Q
 aSOMW1N+p2Vm9WZBapNcY0EV0DF3ErTS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Apr 2026 14:27:35 -0700 Shakeel Butt wrote:
>Ccing relevant folks as this seems related to recent change of moving
>simple_xattrs from rbtree to rhastable.
>
>On Tue, Apr 21, 2026 at 08:34:22AM -0700, syzbot wrote:
>> Hello,
>> 
>> syzbot found the following issue on:
>> 
>> HEAD commit:    8541d8f725c6 Merge tag 'mtd/for-7.1' of git://git.kernel.o..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=15380836580000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=7e54da1916e8d11f
>> dashboard link: https://syzkaller.appspot.com/bug?extid=5af806780f38a5fe691f
>> compiler:       gcc (Debian 14.2.0-19) 14.2.0, GNU ld (GNU Binutils for Debian) 2.44
>> 
>> Unfortunately, I don't have any reproducer for this issue yet.
>> 
>> Downloadable assets:
>> disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/d900f083ada3/non_bootable_disk-8541d8f7.raw.xz
>> vmlinux: https://storage.googleapis.com/syzbot-assets/22dfea2c37c2/vmlinux-8541d8f7.xz
>> kernel image: https://storage.googleapis.com/syzbot-assets/e2f93ad68fe3/bzImage-8541d8f7.xz
>> 
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+5af806780f38a5fe691f@syzkaller.appspotmail.com
>> 
>> ======================================================
>> WARNING: possible circular locking dependency detected
>> syzkaller #0 Tainted: G             L     
>> ------------------------------------------------------
>> kswapd0/108 is trying to acquire lock:
>> ffff888056f3c4e8 (&ht->mutex){+.+.}-{4:4}, at: rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154
>> 
>> but task is already holding lock:
>> ffffffff8e9b0800 (fs_reclaim){+.+.}-{0:0}, at: balance_pgdat+0xb5d/0x1ac0 mm/vmscan.c:7102
>> 
>> which lock already depends on the new lock.
>> 
>> 
>> the existing dependency chain (in reverse order) is:
>> 
>> -> #1 (fs_reclaim){+.+.}-{0:0}:
>>        __fs_reclaim_acquire mm/page_alloc.c:4327 [inline]
>>        fs_reclaim_acquire+0xc4/0x100 mm/page_alloc.c:4341
>>        might_alloc include/linux/sched/mm.h:317 [inline]
>>        slab_pre_alloc_hook mm/slub.c:4520 [inline]
>>        slab_alloc_node mm/slub.c:4875 [inline]
>>        __do_kmalloc_node mm/slub.c:5294 [inline]
>>        __kvmalloc_node_noprof+0xcc/0xa00 mm/slub.c:6828
>>        bucket_table_alloc.isra.0+0x88/0x460 lib/rhashtable.c:186
>>        rhashtable_rehash_alloc+0x68/0x110 lib/rhashtable.c:368
>>        rht_deferred_worker+0x1d9/0x1fd0 lib/rhashtable.c:429
>>        process_one_work+0xa0e/0x1980 kernel/workqueue.c:3302
>>        process_scheduled_works kernel/workqueue.c:3385 [inline]
>>        worker_thread+0x5ef/0xe50 kernel/workqueue.c:3466
>>        kthread+0x370/0x450 kernel/kthread.c:436
>>        ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>> 
>> -> #0 (&ht->mutex){+.+.}-{4:4}:
>>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>>        __lock_acquire+0x14b8/0x2630 kernel/locking/lockdep.c:5237
>>        lock_acquire kernel/locking/lockdep.c:5868 [inline]
>>        lock_acquire+0x1b1/0x370 kernel/locking/lockdep.c:5825
>>        __mutex_lock_common kernel/locking/mutex.c:632 [inline]
>>        __mutex_lock+0x1a4/0x1b10 kernel/locking/mutex.c:806
>
> The cancel_work_sync(&ht->run_work) in rhashtable_free_and_destroy() should
> avoid concurrent mutex lockers from rht_deferred_worker(). Seems like false

Yes.

> positive as all rhastables share single static lockdep class for the ht->mutex.
>
Nope, given schedule_work() in the &ht->run_work callback, if the run_work is
scheduled once more, the race window between the destroy and work callback is
still open. And simple fix looks like disableing the work item before cancel.

> Simple fix would be to move rhashtable_rehash_alloc() to use NOFS allocation or
> we can introduce more fine grained lockdep classes for rhashtables. 
>
>>        rhashtable_free_and_destroy+0x3d/0x9b0 lib/rhashtable.c:1154
>>        shmem_evict_inode+0x1ae/0xc40 mm/shmem.c:1429
>>        evict+0x3c2/0xad0 fs/inode.c:841
>>        iput_final fs/inode.c:1960 [inline]
>>        iput.part.0+0x605/0xf50 fs/inode.c:2009
>>        iput+0x35/0x40 fs/inode.c:1975
>>        dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
>>        __dentry_kill+0x1d0/0x600 fs/dcache.c:670
>>        finish_dput+0x76/0x480 fs/dcache.c:879
>>        dput.part.0+0x456/0x570 fs/dcache.c:928
>>        dput+0x1f/0x30 fs/dcache.c:920
>>        ovl_destroy_inode+0x3e/0x190 fs/overlayfs/super.c:217
>>        destroy_inode+0xcb/0x1c0 fs/inode.c:394
>>        evict+0x599/0xad0 fs/inode.c:865
>>        iput_final fs/inode.c:1960 [inline]
>>        iput.part.0+0x605/0xf50 fs/inode.c:2009
>>        iput+0x35/0x40 fs/inode.c:1975
>>        dentry_unlink_inode+0x2a1/0x490 fs/dcache.c:467
>>        __dentry_kill+0x1d0/0x600 fs/dcache.c:670
>>        shrink_kill fs/dcache.c:1147 [inline]
>>        shrink_dentry_list+0x180/0x5e0 fs/dcache.c:1174
>>        prune_dcache_sb+0xea/0x150 fs/dcache.c:1256
>>        super_cache_scan+0x328/0x550 fs/super.c:223
>>        do_shrink_slab+0x416/0x1240 mm/shrinker.c:440
>>        shrink_slab_memcg mm/shrinker.c:557 [inline]
>>        shrink_slab+0xa7d/0x12e0 mm/shrinker.c:635
>>        shrink_one+0x398/0x7f0 mm/vmscan.c:4932
>>        shrink_many mm/vmscan.c:4993 [inline]
>>        lru_gen_shrink_node mm/vmscan.c:5071 [inline]
>>        shrink_node+0x2673/0x3dc0 mm/vmscan.c:6059
>>        kswapd_shrink_node mm/vmscan.c:6913 [inline]
>>        balance_pgdat+0xaaf/0x1ac0 mm/vmscan.c:7089
>>        kswapd+0x557/0xb60 mm/vmscan.c:7362
>>        kthread+0x370/0x450 kernel/kthread.c:436
>>        ret_from_fork+0x72b/0xd50 arch/x86/kernel/process.c:158
>>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>> 
>> other info that might help us debug this:
>> 
>>  Possible unsafe locking scenario:
>> 
>>        CPU0                    CPU1
>>        ----                    ----
>>   lock(fs_reclaim);
>>                                lock(&ht->mutex);
>>                                lock(fs_reclaim);
>>   lock(&ht->mutex);
>> 
>>  *** DEADLOCK ***

