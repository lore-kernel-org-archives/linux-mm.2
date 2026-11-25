Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97FE3606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 12:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=d32DnldT
Received: by kanga.kvack.org (Postfix)
	id E4DBF6B09E1; Wed, 25 Nov 2026 07:00:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23C96B09E3; Wed, 25 Nov 2026 07:00:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13756B09E4; Wed, 25 Nov 2026 07:00:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A50F86B09E1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:00:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2303AA0EDE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:00:11 +0000 (UTC)
X-FDA: 85473498222.17.D1781AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 67D33180011
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 12:00:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d32DnldT;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795608009;
	b=ecLJM4k2XyWstZkZRh/qPuU/84bHH1D7aTb92iDsuubriKZJ3Fk+avtrh1sQO8nI5JmNKr
	LfoYwegikeEJ9vOFzeU7FKuRsvz8dUoJNyI1rQbxz8WLrj9+7d1RhVt2gYfuoc2FQdJ52w
	z0XigOE8YABt3ataqGbaofhpu8BzHA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795608009;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06lPMTFGD0RFB03sZ5oxAw8CmPV1Zq/ZI/RrRxDPVF8=;
	b=uT9GnkksOvOsnJjYcuHW7TkNW6mkcH6z7k5PoWSjSCC7pF9TCz6Cnf0VpxjYD/m1o5QGE2
	jiUiu0npGl9lkHmlPbrzEYhoOjpe2EhyP+a7gEGowwGeps0IR5CjIGwB16obp+RyqjJTiR
	ieYgJ8bHBJInZ67x8dFlpZfmXNoTIXE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d32DnldT;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECB2B623EA;
	Wed, 25 Nov 2026 12:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFBA1F000C6;
	Wed, 25 Nov 2026 12:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795608008;
	bh=06lPMTFGD0RFB03sZ5oxAw8CmPV1Zq/ZI/RrRxDPVF8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=d32DnldTRcvPnFuYSaYf+Gvz9REb2/pVbxA9S6xkQ5L8ColjVd4R6spj5OoXlIZZE
	 ufYmGyMvpdzdh5aqClvEQ0hVgvv3g+tNznCUHtE96FzK9KgEhZv5AuHLJdCLdFILax
	 2FsG1ChJoIwPPRN8Cq1XOdKDfJhrfDeQCCi5dUHAXcOLZ7T49BS49j2Sgf5ZpLX3AH
	 6mYQQoI0Kv2Uo7Pms4n0jdmmxA5pyGfSgD1ybZ9Bq8R35CJVH098cwpRrM/ejNss3O
	 HENpYdUvDqnqRvcXE/i6CLKfjxd5WPUOVO6qINAABmBKgM/HVmno6MeU8NUfB0YU7M
	 d9yXz+ywbjNIw==
Message-ID: <sashiko-outbox-233316@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 7/8] fs: Protect deferred inode reclaim from freezing
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jan Kara" <jack@suse.cz>, "Christian Brauner" <brauner@kernel.org>
Cc: "Christoph Hellwig" <hch@infradead.org>, linux-mm@kvack.org, "Mikhail
 Rudenko" <xyzzy@yandex-team.ru>, "Andreas Gruenbacher" <agruenba@redhat.com>
In-Reply-To: <20261124115850.3512-15-jack@suse.cz>
References: <20261124113450.3451-1-jack@suse.cz>
 <20261124115850.3512-15-jack@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 25 Nov 2026 12:00:07 +0000
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 67D33180011
X-Stat-Signature: g9zum6ns16hf88jxwnh733jsh6nrmhym
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795608009-767786
X-HE-Meta: U2FsdGVkX18BLLehhASsjaoXjZvhyaJ2Ag72WvmA4ItXKXPSpA/WM9WICA9zBUo0sYY8Tpfb5fgGXlem9KHBhKuFBvmgkQUjda9xJzMbP9NpVmFHPmXePT+IkPx1jmC/aJZlzyQ/qfQknEJveAO2A0P4VTEACLjMw0Z0dvU76hou06oGQ5nz2k7/Jt2b0+t7g6v7YfHUx++c/h5/9o7SrZiH+QgLJs8ZKBhqWnUROYdsnRa/r0U9HaZHsiFzR9FzEbflP8P0u33r3zZMB+8ih+ekGJiUHaav+KK2cyhqi7kK8aXXuGcsCGNVO3cL5jDy/69e7GhEazpgPru37kWFhBth/5xMY1cO/UIR75Jc2yBPIY2xGq36PV+wbbvG7QFx04bZ2Wk7aMTyQQOQDUK9psOY9pmxHA/nHcGzxOHmNvSpOm0+IkHBeAmBdvsyrbbzcwOJYg3HzSOG0CT0CQxuSciNvBNkPLRpvY2DJhnXxPdCOKxHoIHJKvQ5Qjfr5NHRbb89Oyh8AaPqmSaVLbtUTp8NAMLdvHapxiTj93ppZmSV1gVDoKEDJWPo5DY4ESn5i8xvh4f9J3SlIardwaFd5L+nYQkmFinC4tAW8CntIwyMmzdA75JOHDbpTF4tU/tjL+YyvfivlAdtqits2RUvToMwjHZsyU4aRWbQBIo9kTjHkM7Pcu2IA3erT1OmwhCTKB7rnQEKuEMZKb93p4eWra1rwpvVOLvdk+e/Rhnl4Ql38wDSDP3/cDRbNqxFKKl2ahRXFO1UGyRGn1lRypp6n2xN6a9++zEgg8LBgzyGDairlK9/3LS6y7cu5XJ7wBVde8L/C6yUaTVOUJDn7z4uuxlw97N2/dtplII5/5H6nTHYgPbWpJQK0RZUOQlGmNntwcxjWvg6B55/jPeIhIVUIN5arWoJmNxfWhpROexThP8pG2RFrnOLVKw1qtq6XEHLaiC5jZS1yJsUpqsPCWz
 d4P2oqGr
 zvBGGohw/Aj+iFnsadftPd339csbflDP/Jdj8ylt//lonCH/xYbMyhBi4WW+JJJ1gVInvZZ3CZ/12GykreSzbjp5Fjii/dtAwXuFxssrfwOwlSPMSMR9FXK4DsTp8m5s5Nfgt4/MEigKza2dN6cyshP3pUzyAszMfRO8tnzufFSEJCbzn24DPf6zCHLpTO+Ws3UpNjEsYgVLfNxnh2DBs3eMsCynf6K/1WJNqmdBa7p3ytD4wj9OAAK0LfJZkg9hZoZ1EM4oKZxvUUUslbvSnu059oQtVeKZoSR7rklONOeXe93B9xDjaY3f9kTw83wi5I9k0Zji/ES2pICfd3HL4xvv+3tRb3k7VcLnpgpfgQ+EQ9SWnGLblfhawUrR2pO6lGpKd6pejzB16HQrfuNvO93kuU57wA58A+dpZ+AYeTMX3DycmlQPVvW5KqcA3955hVcQ7WJr2/qn1z9Q49QVPC6IDR+rL5F3E0H205f38KQawGHlnzwPvX+JRwUVetDaQ+5ztHr5AICtEI7EvAk3tV4jsMMWJ0qlxEX6YYDZqRmxNFaz4LeFWahNB7zFQe4n05BwqfmLJ3Kbehxfdfpo5eJ+GfzZJqZBTKGJ6VQUmk3ABbVBlWCYxf+eOBeQgJ21RB5HZAQAPdUAQ4FWlkus5Ejzc5/j53lPpmrlzbTU7g/8VRd3cmJEuJRPCmmUIVe5ZDnP1BhUbYjk72AG32JZ0VEn58je7zZj6AC89f0J44LiOT7nTVjiHgkIOrjKPNE12DE5zV4eEtIYL/YVPRY+hZxNuV6o6fvpscrAQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 5 potential
issues to consider:
- [High] fs: skipping I_FREEING inodes during freeze deadlocks inode
  lookups
- [Medium] fs: state mismatch during thaw causes busy loop in
  inode_reclaim_deferred()
- [Medium] fs: skipped frozen inodes at head of queue->list cause O(N)
  rescans
- [Medium] fs: deferred reclaim of stacked inode can block on frozen
  lower fs
- [Low] fs: queue_deferred_reclaim() wakes workers during freeze stages
--

commit 52eb2fd15de6155077a87f493e0148deba16ccc7
Author: Jan Kara <jack@suse.cz>

fs: Protect deferred inode reclaim from freezing

This commit protects running deferred inode reclaim against filesystem
freezing and skips starting new deferred reclaim for inodes on a frozen
filesystem.

> diff --git a/fs/inode.c b/fs/inode.c
> index fdab88f875454..c0460c0780e00 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -1045,20 +1045,11 @@ static int get_deferred_sb_id(struct super_block =
*sb)
>  	return hash_ptr(sb, 32) % deferred_reclaim.workers;
>  }
> =20
> -static void queue_deferred_reclaim(struct super_block *sb, int count,
> -				   struct list_head *list)
> +void wake_deferred_reclaim_workers(struct super_block *sb, int count)
>  {
>  	int id =3D get_deferred_sb_id(sb);
> -	struct deferred_reclaim_queue *queue =3D
> -					&deferred_reclaim.queues[id];
>  	int i, wake_count;
> =20
> -	spin_lock(&queue->lock);
> -	list_splice_tail(list, &queue->list);
> -	atomic_add(count, &sb->s_deferred_reclaim_count);
> -	spin_unlock(&queue->lock);
> -
> -	/* Queue works to process inodes we've added to the list */
>  	wake_count =3D DIV_ROUND_UP(count, INODE_RECLAIM_BATCH_SIZE);
>  	if (wake_count > deferred_reclaim.workers)
>  		wake_count =3D deferred_reclaim.workers;
> @@ -1069,6 +1060,33 @@ static void queue_deferred_reclaim(struct super_bl=
ock *sb, int count,
>  	}
>  }
> =20
> +static void queue_deferred_reclaim(struct super_block *sb, int count,
> +				   struct list_head *list)
> +{
> +	int id =3D get_deferred_sb_id(sb);
> +	struct deferred_reclaim_queue *queue =3D
> +					&deferred_reclaim.queues[id];
> +
> +	spin_lock(&queue->lock);
> +	list_splice_tail(list, &queue->list);
> +	atomic_add(count, &sb->s_deferred_reclaim_count);
> +	/*
> +	 * Make sure queued inodes are visible before we check whether deferred
> +	 * reclaim is blocked. Pairs with the barrier in thaw_super_locked().
> +	 */
> +	smp_mb__after_atomic();
> +	spin_unlock(&queue->lock);
> +
> +	/*
> +	 * Skip waking up workers for frozen filesystem. They'd skip the inodes
> +	 * anyway.
> +	 */
> +	if (atomic_read(&sb->s_deferred_reclaim_running) < 0)
> +		return;
> +
> +	wake_deferred_reclaim_workers(sb, count);
> +}

[Severity: Low]
Does this still wake workers unnecessarily during the earlier stages of
freeze_super()?

freeze_super() sets sb->s_writers.frozen to SB_FREEZE_WRITE and
SB_FREEZE_PAGEFAULT before sb_wait_write() and sync_filesystem(), while
s_deferred_reclaim_running is only set to -1 after sync_filesystem()
completes.  During that window, queue_deferred_reclaim() wakes workers
even though __get_inode_reclaim_batch() will immediately skip all inodes
from sb because s_writers.frozen !=3D SB_UNFROZEN.

> @@ -1108,18 +1126,24 @@ static void __get_inode_reclaim_batch(int *start,=
 int end,
>  	for (i =3D *start; i < end; i++) {
>  		struct deferred_reclaim_queue *queue =3D
>  						&deferred_reclaim.queues[i];
> -		struct list_head *entry, tmp;
> +		struct inode *inode, *next;
> =20
>  		if (list_empty_careful(&queue->list))
>  			continue;
>  		spin_lock(&queue->lock);
> -		list_for_each(entry, &queue->list) {
> -			if (*count >=3D INODE_RECLAIM_BATCH_SIZE)
> +		list_for_each_entry_safe(inode, next, &queue->list, i_lru) {
> +			/*
> +			 * Skip inodes on frozen fs as we'd likely block. We
> +			 * always accept inodes from read-only fs as there
> +			 * eviction cannot require writing.
> +			 */
> +			if (!sb_rdonly(inode->i_sb) &&
> +			    inode->i_sb->s_writers.frozen !=3D SB_UNFROZEN)
> +				continue;

[Severity: High]
Can skipping queued inodes here deadlock freeze_super() and stall inode
lookups?

Inodes queued for deferred reclaim via prune_icache_sb() or iput_final()
already have I_FREEING set, but remain hashed in inode_hashtable (and
filesystem lookup tables such as XFS per-AG radix trees) until evict()
runs in inode_reclaim_deferred().  Any lookup of such an inode blocks in
__wait_on_freeing_inode() waiting for evict() to finish.

CPU0 (freeze_super)       CPU1 (in-flight writer)   CPU2 (reclaim worker)
-------------------       -----------------------   ---------------------
s_writers.frozen =3D
  SB_FREEZE_WRITE
                          sb_start_write() held
                          iget_locked(ino)
                            __wait_on_freeing_inode()
                                                    __get_inode_reclaim_bat=
ch()
                                                      s_writers.frozen !=3D
                                                        SB_UNFROZEN
                                                      -> skips inode
sb_wait_write(
  SB_FREEZE_WRITE)
  <-- deadlocks

Also, while the filesystem is frozen, super_cache_scan() ->
prune_icache_sb() continues isolating inodes with I_DEFER_RECLAIM or
I_METADATA_WRITEBACK, setting I_FREEING and queuing them where they will
not be evicted until thaw, causing any reader looking up those inodes to
hang uninterruptibly in __wait_on_freeing_inode().

> +			list_move_tail(&inode->i_lru, list);
> +			if (++(*count) >=3D INODE_RECLAIM_BATCH_SIZE)
>  				break;
> -			(*count)++;
>  		}
> -		list_cut_before(&tmp, &queue->list, entry);
> -		list_splice_tail(&tmp, list);
>  		spin_unlock(&queue->lock);

[Severity: Medium]
Does leaving skipped inodes from a frozen superblock at the head of
queue->list cause O(N) rescans under queue->lock?

Because deferred_reclaim.queues are shared across superblocks and
queue_deferred_reclaim() appends new batches at the tail, every batch
dequeued for an unfrozen superblock on the same queue must walk past all
frozen inodes at the front under queue->lock.  Moreover, when any other
worker collects fewer than INODE_RECLAIM_BATCH_SIZE inodes from its own
queue, get_inode_reclaim_batch() wraps around across all queues, seeing
!list_empty_careful(&queue->list) and locking and scanning all N frozen
inodes on that queue only to skip them.

[ ... ]

> @@ -1210,6 +1260,13 @@ static void inode_reclaim_deferred(struct work_str=
uct *work)
>  				sb =3D inode->i_sb;
>  				count =3D 0;
>  				start =3D ktime_get_ns();
> +				/* Protect us from filesystem freezing */
> +				if (!sb_deferred_reclaim_get(sb)) {
> +					inode_reclaim_skip_inodes(&inode_batch,
> +								  sb);
> +					sb =3D NULL;
> +					continue;
> +				}
>  			}
>  			count++;
>  			list_del_init(&inode->i_lru);

[Severity: Medium]
Can evicting a stacked filesystem inode (such as overlayfs or ecryptfs) in
inode_reclaim_deferred() still block the worker on a frozen lower
filesystem?

When iput_final() drops the last reference to an unlinked stacked inode
under PF_MEMALLOC, it queues the stacked inode to deferred_reclaim:

fs/inode.c:iput_final() {
    ...
	if (current->flags & PF_MEMALLOC && !inode->i_nlink) {
		LIST_HEAD(defer);

		list_add(&inode->i_lru, &defer);
		queue_deferred_reclaim(sb, 1, &defer);
		return;
	}
	evict(inode);
}

__get_inode_reclaim_batch() and sb_deferred_reclaim_get() only check the
stacked superblock (inode->i_sb), which is unfrozen.  When the worker runs
evict(inode), current->flags does not have PF_MEMALLOC set, so dropping
the underlying unlinked dentry/inode in ovl_destroy_inode() or
ecryptfs_evict_inode() enters iput_final() -> evict() synchronously on the
frozen lower writable filesystem and blocks on sb_start_intwrite().

> diff --git a/fs/super.c b/fs/super.c
> index fa345d5027bff..77e6ab6383b8b 100644
> --- a/fs/super.c
> +++ b/fs/super.c

[ ... ]

> @@ -2648,6 +2678,7 @@ static int thaw_super_locked(struct super_block *sb=
, enum freeze_holder who,
>  	sb->s_writers.frozen =3D SB_UNFROZEN;
>  	sb->s_writers.freeze_owner =3D NULL;
>  	sb_freeze_wake(sb);
>  	sb_freeze_unlock(sb, SB_FREEZE_FS);
> +	sb_unblock_deferred_reclaim(sb);
>  out_deactivate:
>  	deactivate_locked_super(sb);
>  	return 0;

[Severity: Medium]
Can setting sb->s_writers.frozen =3D SB_UNFROZEN before
sb_unblock_deferred_reclaim(sb) cause inode_reclaim_deferred() to spin in
a tight loop without calling cond_resched()?

In both thaw_super_locked() and the freeze_fs() error path of
freeze_super(), s_writers.frozen becomes SB_UNFROZEN before
s_deferred_reclaim_running is reset from -1 to 0 in
sb_unblock_deferred_reclaim().  During that window,
__get_inode_reclaim_batch() only checks s_writers.frozen !=3D SB_UNFROZEN
and moves the inodes to inode_batch, after which
sb_deferred_reclaim_get(sb) fails, inode_reclaim_skip_inodes() splices
them back onto queue->list, and inode_reclaim_deferred() continues
without reaching cond_resched(), immediately re-dequeuing the same inodes
on the next iteration.  Calling sb_unblock_deferred_reclaim(sb) before
setting s_writers.frozen =3D SB_UNFROZEN (or also checking
s_deferred_reclaim_running in __get_inode_reclaim_batch()) would avoid
this window.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261124115850.3512=
-9-jack@suse.cz?part=3D7

