Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6984DC9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 02:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43F0E6B0088; Fri, 25 Sep 2026 22:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EFAF6B008A; Fri, 25 Sep 2026 22:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305A46B008C; Fri, 25 Sep 2026 22:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0F836B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 22:48:37 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AA1C160827
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:48:37 +0000 (UTC)
X-FDA: 85254380274.04.44223C8
Received: from mail-dy2-f42.google.com (mail-dy2-f42.google.com [74.125.229.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id A8D631C0002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 02:48:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WYOt6WBK;
	spf=pass (imf21.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.229.42 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790390915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4AfLUjZGBh+NyiRXQ29ny/IyjFejnXIP1LQYn6XeZ2o=;
	b=tIXFvfS78igAKHqz1ZDLTfjjQI8HtO0Qm89mBx5L1Knng6N0S6yz3fTN1Ohztuu5rM6a28
	jPBTMNgEvhcp3auQMJS+3YcISXoiyC9rYYmTIpICqfbwxASyc697bK04yxuHF8ueoSNOQ3
	YAb36qh5GD7qzWV6EQ52kozQLClxN7M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WYOt6WBK;
	spf=pass (imf21.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.229.42 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790390915;
	b=KR7lzZ4/nJPLO0jB5j9Zj8k3DfXBXxLBb7XQL0RBuiCAcwJ1+C48hV3Ae9rQoUY/Einm7E
	j1szrdv2JPCvH0NXukVOVdWSIsZGScc71KZMdOz0XIWsFohRy6cOlIL9sU/NasuQeXuUtS
	pzLYbp1TIYQuYFa/8lfwBAqIMc0BNgk=
Received: by mail-dy2-f42.google.com with SMTP id 5a478bee46e88-3411e0ace19so732214eec.3
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790390914; x=1790995714; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=4AfLUjZGBh+NyiRXQ29ny/IyjFejnXIP1LQYn6XeZ2o=;
        b=WYOt6WBKxhuIAxFcsJQ3QA3Sii8J1K2u2eaN3FYTIcmcZ2kFVmGg1padAx2FDmKj6C
         HASEMo6ATAX+T+zew9qrUH1kKt5kvl2LZZVfqmDATRldhKADHSbwhLiFc73ZQDh0KDId
         OMqSDR3Kg2nMSSRInMY0PQljY8/hFA5liJ61Vkp0PcC+7oNOOLo0qO3usuDpq5PzGhzS
         YyB5pxiUTChMV9lAnaIguYCeB1R9+oshAwocvx3KDJfbRG5z/boro+jwvtBtXJApYHpD
         /bVkZN03fUDvLIHw5HSxVey8rnM+sKzK28TQvESvw6PiFrx6quIZcgLt5qW9eCG1gwJw
         XXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790390914; x=1790995714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=4AfLUjZGBh+NyiRXQ29ny/IyjFejnXIP1LQYn6XeZ2o=;
        b=RUjDXGlPFuBo6itLaubJyrLDrJzyr2U36Q7xSK3gSoQQQ7OauJr51+Z1lEiatNhHE4
         EZIKHiuObenTGxwbSaEJCXfZOO/xtX5yu6UZYYclOW5j+SFeP/sJJcWK/ENGyC2eRt6l
         Zn09a3cj3nYvb1k+qLFnQ0tCQmIRirbfD+vVvU1W2Z90FhHayc8Z2Cew/6/TBmOlMIGl
         GZ2Y3lnTy9foYkMu6JZcGUVBipGZLs566ASISaOEuZd1jfpqYv5PigglrD+0B8P4CDZC
         2K3XNsufNwIZM9POL0w5xFEZ424s8eywN09NUx+Y43DObYOF9tbzAMmF44OXamI2bmNl
         pJPg==
X-Forwarded-Encrypted: i=1; AKwUvBwyTH3sRURJK5jHZfcXtsE6/t7JHtk8ERrjC03J3JijP4Y+LTf8p5FTdIen/zrwCttTwugSoPOAgA==@kvack.org
X-Gm-Message-State: AFuF++krr1XJqsqY2ZduhTYtuobQ/RwOO7b4v7SG1dPooxNdZ8GVdxr+
	5JGFDg5aVkQUY9qpI6bIh6i2UCQF5uat4tW+r5Fm037XVDU6YaxurwTe
X-Gm-Gg: AYBFou1Gyxr1r9VDcZr5Z7MzZ75JI6YsA5DY0r1oMSoFA5lIORpXNkhOZAW9Wj5ZoP/
	MDFW6gLLa4nOvscFsrUcO9ZcppjKG/cMRpmvUAhkerEkii5fp3uF5qjaQkLDHFZkkuMlrA4dkhg
	TYT1yIO+DbqRG2zUgRpUJX1IscvRLMgh4n77xEi8WHwCneFhi9kHB1QgeK9+iPf3vHjePHFVgY7
	RV6jP7THgQeQrKd+H/ToFSdQ+N19tJLBonkkBSWQNxCsXq/Y7IHu+jl5/4btfQyJfFuvN7+WVRx
	qpmoEmUkCrATSIds+DOK9DqxXQGXBr1DTGgFHFuRzYNk2YCRgmFa9IC4QhCZU2qswa+lo0/Jf18
	VkkXbyoWPUdDU0//WxPKJ7pOKAi8+DbIuC6EUyDNH303kS9ZaL1wKk1XQ50Kt9sMuyVwbx9SDKk
	9wEtYoY2C9M8Krb3MadqHk3P0Amrj/AvDWaxyiDEgmtyrcSRM86Pl10gxnvBweB2lcOk5/Y/6BE
	4JGdQwQKOPlKtDf+/xEtjgvOvVhAAzNGICtnI35bnxm2Z7BkeGBCz29yWxZ5sGbzyFk1x6OdWem
	pP+STuEYV9CwDeYDd4W+o7IIXJL//l8MIJMdbXU/jfzkuU4XAzzKew25asU=
X-Received: by 2002:a05:7300:4fa5:b0:33b:d8b2:8fba with SMTP id 5a478bee46e88-342700bdd29mr1509975eec.7.1790390914091;
        Fri, 25 Sep 2026 19:48:34 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-341f2b18cbfsm7115584eec.30.2026.09.25.19.48.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 19:48:33 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	brauner@kernel.org,
	hch@infradead.org,
	xyzzy@yandex-team.ru,
	tytso@mit.edu,
	djwong@kernel.org,
	agruenba@redhat.com
Subject: Re: [PATCH v2 0/5] fs: Deferred inode reclaim
Date: Sat, 26 Sep 2026 10:48:29 +0800
Message-ID: <20260926024829.3051410-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911081309.14137-1-jack@suse.cz>
References: <20260911081309.14137-1-jack@suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xdq8bcyboarfe67kc66fzx7mqcf4em9n
X-Rspamd-Queue-Id: A8D631C0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790390915-388474
X-HE-Meta: U2FsdGVkX19mWuVCfwOiEF4lOLY4EBlTmpHyUHLwNxn8YueaHINrlnnMlPNDS93YMa/SUrdl7Td4c7vQOqxoESHSus3kV1x/GqqcUgDTCFxMR8KyW6qgI7DB6oAUvH6CFb8jURf0LAE8ZTPPLg3s52NTHJOYV7wRM9BMRaoHVJx63PXLxVuQSpuHZBKOEQkOhy98Z43QvNuxjztaatqfg8USY0Qk1CJfr/CKOhewdirRrbQ8JXuQICQs8+dCfyd2tjs6+VeqwteXhB4D9kmPURc3PdHUVTrUJYguefA/UWRyj43XTN7mf9Qusy81l/qjBQfqng2AjIl2w29Evnt1XrjEdbENqKt6jrNUTBP/aalH+o4TNrpaqI7yKuGOIh88JjzJR9zh8WFJgwMRCEQdmfTOA5K7oh9IQYPLbCP+BgSBVUoYcCfX7PjffMkhqh8m7Z3lmW4ds5Z200ghENhD5PnLa/I2wy+knMyqBKAsZXveI5428tkS/GN8UPT55fe3yMXEUSf6aaIX0Aw8SbmNZeB+TYppk7zslvJ51iwC9wWdswTOp+U9Na2wWnuUjkfUoqgjGMK/cDycEuA8Ad70AL8g6DDelq8WeWPBPrK0JSjozUoMPPjWdKj2kVdlS7VH1aGF0oLiI3j7UwUAhWp4DPeUkXblOqIRefOwd052v1Xn9s8kZCbgPhrq1E0J/NRbu8JrfZMwYlhQ0JdnJfYSODS2yO5gOYY3DrxE90qbxAbo+bSiMJoXdjSE9vwA6kJ+XvlMGY5cO+X/fMHgwzFW7w9p1XEGV5fAsbNp5uABE0EV0ONUPzL9EitZR99oKHZu5+jWyK6RS6B5D7nSki75QCo+qevaOdYbnFJBRk/qrfKubQNope88eYoff5M0Tg148hrhlxteUXb2d1HL1xxnzF/Sx3E8QqEGn3l9iGyFHInGvuynq3B4EIBwHzBTcW1sXV++GlGKgZG0uqHVpqq
 ZEKz8xaG
 meGGAlP9/3D0dpH5riPyA36YbHkzu6hhLO11tviuNyXQLyP+eRGuEp4e0h7eI8nvsY4yamkKplyEfwq5n8X437ca5GBp1A6nUayif+515O9wTF2JxYdZC3HdSElOSoPKA5nnlIaBEGhU24VQpIGkX6iXrYwRs4RwChOoiVNtnLtfJrwjbaSG04HA/CP14ykU2b3fYUwI2IZT2BYZMGsVyb98ea4Et6S0yj/MtiSKgLb017gXaimfx27KUA2oL1yB8PgslpZIuTd3DpUISpGRWbdq79DhEhpMuiNLuoUthXQvOQWOWI5SlYrP63i60XAS0Q8FV1WKk453Ocq+E1He+mttxoWLeb9VpKf0tYQ+0FqhgDb4vdKh061ZvvaGPiZwrKVJMz1WTJtrJt30quirv4Q5mDlJAtjY6rf0TiQePM1Ke9iWlA/dUpefULszcZ/bjfSMFZ7aPrbWlPH2VT/3RrKBWma7UpcWGU7t1W59UoH6fq6SOBk1mZH8c6A2knnF0hFF6QeeQP+yAqNI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Honza,

I ran v2 against its base in QEMU, on syzbot's disk image with a config
close to syzbot's (KASAN, lockdep):

- Lazytime churn on ext4 under memory pressure: the PF_MEMALLOC warning
  fired with the sync_lazytime() stack in all 5 base runs, four times
  from kswapd, and in none of 5 runs with the series, which evicted as
  many inodes in reclaim context without reading ext4 metadata there.
  The workload also runs drop_caches=2 under memalloc_noreclaim_save()
  from a debug patch.

- Hibernation cycles with /sys/power/pm_test set to devices under that
  load, with inodes that 5/5 defers queued in each cycle, and with
  freeze_filesystems 0 and 1: no freezer timeouts and no hang involving
  the queue.  The stalls in throttle_direct_reclaim() from
  hibernate_preallocate_memory(), and lockdep's warning in
  __set_task_frozen() with freeze_filesystems=1, happen on the base
  kernel too.

- One path the series does not cover, see below: with the series
  applied, unlinked ext4 inodes under an overlay are still deleted in
  reclaim context, and the warning fired in 2 of 3 runs, as without it.

The reproducers and the debug patch are at
https://github.com/matthiasgoergens/linux/tree/deferred-reclaim-repro
and I can post them here if you prefer.  The Tested-by below covers the
lazytime and hibernation runs.

In 3/5:

> @@ -988,13 +1013,27 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>  	inode_state_set(inode, I_FREEING);
> -	list_lru_isolate_move(lru, &inode->i_lru, freeable);
> +	/* Inode will take long time to cleanup. Offload that to worker. */
> +	if (inode_state_read(inode) & I_DEFER_RECLAIM) {
> +		list_lru_isolate_move(lru, &inode->i_lru, &lists->deferred);

This is the only place I_DEFER_RECLAIM queues an inode, also with
Andreas's simplification folded in.  An inode that ->drop_inode() drops
on its last iput(), which for ext4 means every unlinked inode, never
gets here: iput_final() calls evict() directly, in whatever context the
iput() came from.

syzbot hits that under reclaim with overlayfs on top of ext4, in the
same bug as the lazytime trace in your 2/5:

  https://syzkaller.appspot.com/bug?extid=7f94fe3ce0f6613e12b8
  https://syzkaller.appspot.com/text?tag=CrashReport&x=12764a15580000
  https://syzkaller.appspot.com/text?tag=CrashReport&x=13530905580000

Direct reclaim prunes overlayfs dentries, and dropping the overlay inode
puts the last reference to an unlinked lower ext4 inode, so
ext4_evict_inode() runs its deletion path under PF_MEMALLOC.  My
reproducer above does the same: stat files through an overlay on ext4,
unlink them in the lower or upper directory, then apply memory pressure.

Is that path meant to be covered?  Handing such inodes to the queue from
iput_final() under PF_MEMALLOC, as gfs2_drop_inode() does for gfs2,
mostly just delays things: blocks and quota come back later, lookups by
inode number wait in __wait_on_freeing_inode(), and umount would need
the inode counted in s_deferred_reclaim_count, as 3/5 does for its own.
But it does not work as is with freezing: ext4_evict_inode() takes
sb_start_intwrite() on the deletion path, so a worker evicting an
unlinked inode of a frozen filesystem sleeps until the thaw, holding a
batch of up to 16 inodes taken from any queue, and enough of those stop
the queue.  XFS keeps inodegc per mount and stops it in xfs_fs_sync_fs()
before SB_FREEZE_FS; this queue would need something like that before it
could take unlinked inodes.

On Ted's question (https://lore.kernel.org/r/aqQV6Uwma_KjUH0O@mit.edu):
with this WQ_FREEZABLE queue I would not wait either.  A non-freezable
queue would need draining before anything is frozen, because an eviction
after the hibernation snapshot writes to disk behind the image, and
draining later can wait on kjournald2 or on sb_start_intwrite().
Freezing the workers with the kernel threads avoids both.

One catch: a work item already blocked on something frozen earlier keeps
freeze_workqueues_busy() true until the freezer times out, and the
suspend or hibernation is aborted.  With /sys/power/freeze_filesystems=1
the filesystems are frozen before the freezer runs, so an eviction
waiting in sb_start_intwrite() is enough.  ext4 only takes that on the
deletion path, so 5/5 is not affected, but unlinked inodes routed
through the queue would be.

Tested-by: Matthias Goergens <matthias.goergens@gmail.com>

Thanks,
Matthias

