Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8B3606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:03:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=T6IUlNeu;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CnR14YGq;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=T6IUlNeu;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CnR14YGq
Received: by kanga.kvack.org (Postfix)
	id 018AE6B05B0; Fri, 27 Nov 2026 15:03:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31D86B05B1; Fri, 27 Nov 2026 15:03:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1FC96B05B2; Fri, 27 Nov 2026 15:03:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFA076B05B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:03:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9C391A7D3C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:03:48 +0000 (UTC)
X-FDA: 85481974536.16.8063580
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf29.hostedemail.com (Postfix) with ESMTP id 46FED120018
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:03:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T6IUlNeu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CnR14YGq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T6IUlNeu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CnR14YGq;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795809826;
	b=kYvKGjci7akHKe+3+gBNV4c5cCV6dfvSs/iIqcPaGZnLXfSO9G2GDJhJ2esEj0Lp9NDZcH
	8dKzpNDHhe6xkAQXS0F819HZYaeKez4nHiNJZNNz7bwwQG8x8iHAZvmdbJASV4lmc573BA
	ed8ZT/OLM+JcYtXApNoJeKAGaeGKKDU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795809826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvZJXkmOW+tv79uf7dO5s2nHqtahsAeoQ64d4cbHpIY=;
	b=ib+8jLN0Tttio7zO9STGIwPkWSzzlyn99Cbqnaq7mJGn+dmY9zsXbPRzVTa4VIFmLohzuR
	B4lbkuuOz6XbMSeqrOqteq3/5eiXyxnViYXZE7j7SLFK0guDFZpFEZ4VeIJ6/k7mtMTj96
	L47giLwoSXjvLKFb5sCVI3NR9e1tupk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T6IUlNeu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CnR14YGq;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=T6IUlNeu;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=CnR14YGq;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D7CED1F836;
	Fri, 27 Nov 2026 20:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795809824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gvZJXkmOW+tv79uf7dO5s2nHqtahsAeoQ64d4cbHpIY=;
	b=T6IUlNeutJW8Ij42lojNMkDB8E7fpE8A0kydtEHKYIsrCcSzd8XtWsB652I3q4eATcaa3Y
	i9faGFih/l29IhKO9rwuv2tVYR2XHuIiPpiM4rIus0zxzN1VQnXeAR0/OLho0bYTxmKmIN
	LElkhSJ4/pzmZCs+tBV4Pw031ywXPOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795809824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gvZJXkmOW+tv79uf7dO5s2nHqtahsAeoQ64d4cbHpIY=;
	b=CnR14YGqQf/1rpJv7xuvPKF5ExyjWIzHCeWUXXSzkioChWRdaSJQyMCkNuMGWmaVv/sM5a
	Tp1wM2e3Ll5YRjBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795809824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gvZJXkmOW+tv79uf7dO5s2nHqtahsAeoQ64d4cbHpIY=;
	b=T6IUlNeutJW8Ij42lojNMkDB8E7fpE8A0kydtEHKYIsrCcSzd8XtWsB652I3q4eATcaa3Y
	i9faGFih/l29IhKO9rwuv2tVYR2XHuIiPpiM4rIus0zxzN1VQnXeAR0/OLho0bYTxmKmIN
	LElkhSJ4/pzmZCs+tBV4Pw031ywXPOQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795809824;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gvZJXkmOW+tv79uf7dO5s2nHqtahsAeoQ64d4cbHpIY=;
	b=CnR14YGqQf/1rpJv7xuvPKF5ExyjWIzHCeWUXXSzkioChWRdaSJQyMCkNuMGWmaVv/sM5a
	Tp1wM2e3Ll5YRjBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B4111134E8;
	Fri, 27 Nov 2026 20:03:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tR5NJSDiCWu/KAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Nov 2026 20:03:44 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 43F755110C; Fri, 27 Nov 2026 21:03:44 +0100 (CET)
Date: Fri, 27 Nov 2026 21:03:44 +0100
From: Jan Kara <jack@suse.cz>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Mikhail Rudenko <xyzzy@yandex-team.ru>, 
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v2 7/8] fs: Protect deferred inode reclaim from freezing
Message-ID: <q4yof5quxzttmn3pjqq3tm3lhupwsmxdwfn2zjrlm57qjdmip3@mukbj3ii55h7>
References: <20261124113450.3451-1-jack@suse.cz>
 <20261124115850.3512-15-jack@suse.cz>
 <sashiko-outbox-233316@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-233316@kernel.org>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspam-User:
X-Rspamd-Queue-Id: 46FED120018
X-Stat-Signature: yhh4xi4dz9ietrx4xueqtggdjrzim8yg
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795809826-818385
X-HE-Meta: U2FsdGVkX19fd24IpkD6uHZjexlepKT+TDpBVxRIWW7kTMmAd51qsVTUVnYf+4XTebiJ5N9dLj7gZ1DAVLYE3h0mc1kWVl+fCY8JjBP4tNh8wHAp0Jo05EOQKk3FKvfflE/8OonfCWP6j3F5D2znX8fH23xGZwFEot+fljJB6YhRoDhiL8NKeT5FzhBw18SgzYROWfS4XWGuOb+QaQ1G3UnOKHw7GICePbReQcXgLubohkXWJ1haMIXxqFAR+q9Z8WoofUnNNoFEK9NKX+bWiq2FqERRVOXmiNyPnYnamLrFGd+LueEFhwyWPN7rmk7ZmxkpKJC9TyiUDu2T61TcMuYJIzbApZezXpE+1qdp+ZSx3LHWBSVhcbRjC7FVHil/wFeFJ1RiM+sw9WDA8HyJc4zrQQQxvYfzhxz6GMPhCzV7x0cyWzX45Kup5lTewRN6P8ozUuVnM9E+z8Df1ESdIX9xWrzRBb7y3GpPKYmtdI7/PD248C0U+Y0hLxH36aWYNewtEKHsLXVlYZ0VML+SezFQi/tDIUVC3YFJd7c2Ndb9alv670vQES/By7fUV70y5Ad3VxS2hk6axUblrtq3C18SDP0qQQUdPYH6xfKQh/gZtcf9lNyd9IGmCwqeMIJhun5Qb7krmVN/yUTZA6FpNGBzBpkOaFC9xIQnLF3+Vg7IN4YYdHkcBf++/SNTIKiZvTXQneX0uz0DFiZFHeaRqLH7oHA7IOAZdOSyd74hVNFvxiRfWKPWes5wAyAsE4gk0qNv7cf8J2vsNhYaUh/VKMswCPAVobjNLv+V/+3ULFk9+iQI1qrFc8f+ZYFkqRbwY1OAFm/LLKPCAFVgEDJYHEAATHDxQzhfddv9rjqqVBiB9ru3MPRKJ4uanAXaLKKtJiiQNdhJdgm3xqPKmp9yc4ZKJ0Wc1X99GfEf5E7YVLydKQSZ8Jz4KSXncuy6AAgy6IsG3vJDpXVk2KZcHqy
 i0MFDUtT
 tzEcmytLUlk7FeGCd6RRrgM7aCofgoHC2I2qm6IOFg1yq9MXuLdA5BYxhbXvIXsVyxqUDgnQv65rRSQIW5SsrYBXs0U2IiVVjpyJtvPFvzedToo7XXpm1uf0PpkfU/LkUIOAq/qv+Yi7LCbpyQQJiSyfhm5LMJ1z5AYx1JtnO0twRMMc+Kznc4FXgF0eAHYMyBm91WiSUEcTU8+04XImbOc08Nd+dyMTLXZ47MciaqcwdaPA69ok8/neX03AUBeUkdSNW2de2Pxf29SyHm14WaCz1M2pibwqfeQ0PL/AKTwhZ03P1fF3ZvK2eszr4EJ2wt1CW4YlB2qeaQKm7l81rqRYBqR1ZRv3eXfyrus02k05TyOQEs3VxLvqhBrngndYthi66pOnNwBhPQcxu0qr5MQvkj3a0sET0J2n90rHc401FVkg+iYk1516nWrt5JpjLPPydxdFARudr3e9GjM43fhepBLJwQqXXOzvBKf2yZJoPvdcVVV0JYUfq+SWVE3KHr7c8Nive06gxTy/fP08jMpNK/CurmqThYMOE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 12:00:07, sashiko-bot@kernel.org wrote:
> > +static void queue_deferred_reclaim(struct super_block *sb, int count,
> > +				   struct list_head *list)
> > +{
> > +	int id = get_deferred_sb_id(sb);
> > +	struct deferred_reclaim_queue *queue =
> > +					&deferred_reclaim.queues[id];
> > +
> > +	spin_lock(&queue->lock);
> > +	list_splice_tail(list, &queue->list);
> > +	atomic_add(count, &sb->s_deferred_reclaim_count);
> > +	/*
> > +	 * Make sure queued inodes are visible before we check whether deferred
> > +	 * reclaim is blocked. Pairs with the barrier in thaw_super_locked().
> > +	 */
> > +	smp_mb__after_atomic();
> > +	spin_unlock(&queue->lock);
> > +
> > +	/*
> > +	 * Skip waking up workers for frozen filesystem. They'd skip the inodes
> > +	 * anyway.
> > +	 */
> > +	if (atomic_read(&sb->s_deferred_reclaim_running) < 0)
> > +		return;
> > +
> > +	wake_deferred_reclaim_workers(sb, count);
> > +}
> 
> [Severity: Low]
> Does this still wake workers unnecessarily during the earlier stages of
> freeze_super()?
> 
> freeze_super() sets sb->s_writers.frozen to SB_FREEZE_WRITE and
> SB_FREEZE_PAGEFAULT before sb_wait_write() and sync_filesystem(), while
> s_deferred_reclaim_running is only set to -1 after sync_filesystem()
> completes.  During that window, queue_deferred_reclaim() wakes workers
> even though __get_inode_reclaim_batch() will immediately skip all inodes
> from sb because s_writers.frozen != SB_UNFROZEN.

Yes, not really harmful but it makes sense to make
__get_inode_reclaim_batch() also check s_deferred_reclaim_running which
avoids these pointless wakeups.

> > @@ -1108,18 +1126,24 @@ static void __get_inode_reclaim_batch(int *start, int end,
> >  	for (i = *start; i < end; i++) {
> >  		struct deferred_reclaim_queue *queue =
> >  						&deferred_reclaim.queues[i];
> > -		struct list_head *entry, tmp;
> > +		struct inode *inode, *next;
> >  
> >  		if (list_empty_careful(&queue->list))
> >  			continue;
> >  		spin_lock(&queue->lock);
> > -		list_for_each(entry, &queue->list) {
> > -			if (*count >= INODE_RECLAIM_BATCH_SIZE)
> > +		list_for_each_entry_safe(inode, next, &queue->list, i_lru) {
> > +			/*
> > +			 * Skip inodes on frozen fs as we'd likely block. We
> > +			 * always accept inodes from read-only fs as there
> > +			 * eviction cannot require writing.
> > +			 */
> > +			if (!sb_rdonly(inode->i_sb) &&
> > +			    inode->i_sb->s_writers.frozen != SB_UNFROZEN)
> > +				continue;
> 
> [Severity: High]
> Can skipping queued inodes here deadlock freeze_super() and stall inode
> lookups?
> 
> Inodes queued for deferred reclaim via prune_icache_sb() or iput_final()
> already have I_FREEING set, but remain hashed in inode_hashtable (and
> filesystem lookup tables such as XFS per-AG radix trees) until evict()
> runs in inode_reclaim_deferred().  Any lookup of such an inode blocks in
> __wait_on_freeing_inode() waiting for evict() to finish.
> 
> CPU0 (freeze_super)       CPU1 (in-flight writer)   CPU2 (reclaim worker)
> -------------------       -----------------------   ---------------------
> s_writers.frozen =
>   SB_FREEZE_WRITE
>                           sb_start_write() held
>                           iget_locked(ino)
>                             __wait_on_freeing_inode()
>                                                     __get_inode_reclaim_batch()
>                                                       s_writers.frozen !=
>                                                         SB_UNFROZEN
>                                                       -> skips inode
> sb_wait_write(
>   SB_FREEZE_WRITE)
>   <-- deadlocks
> 
> Also, while the filesystem is frozen, super_cache_scan() ->
> prune_icache_sb() continues isolating inodes with I_DEFER_RECLAIM or
> I_METADATA_WRITEBACK, setting I_FREEING and queuing them where they will
> not be evicted until thaw, causing any reader looking up those inodes to
> hang uninterruptibly in __wait_on_freeing_inode().

Hum, right. This is actually not a new thing - previously prune_icache_sb()
accumulated inodes with I_FREEING set on its list and evict() could block
on frozen fs when evicting some particular inode and following lookups
would stall the same way. But now we're more paranoid with the freeze
protection so we'll block on frozen filesystem even if evict() actually
would not block (but we don't know). I'll put some more thought to this if
we can improve.

> > +			list_move_tail(&inode->i_lru, list);
> > +			if (++(*count) >= INODE_RECLAIM_BATCH_SIZE)
> >  				break;
> > -			(*count)++;
> >  		}
> > -		list_cut_before(&tmp, &queue->list, entry);
> > -		list_splice_tail(&tmp, list);
> >  		spin_unlock(&queue->lock);
> 
> [Severity: Medium]
> Does leaving skipped inodes from a frozen superblock at the head of
> queue->list cause O(N) rescans under queue->lock?
> 
> Because deferred_reclaim.queues are shared across superblocks and
> queue_deferred_reclaim() appends new batches at the tail, every batch
> dequeued for an unfrozen superblock on the same queue must walk past all
> frozen inodes at the front under queue->lock.  Moreover, when any other
> worker collects fewer than INODE_RECLAIM_BATCH_SIZE inodes from its own
> queue, get_inode_reclaim_batch() wraps around across all queues, seeing
> !list_empty_careful(&queue->list) and locking and scanning all N frozen
> inodes on that queue only to skip them.
> 

Yes, this is variation of the above... Easy to solve this particular one
but the solution depends on what I'll decide to do with the problem above.

> > @@ -1210,6 +1260,13 @@ static void inode_reclaim_deferred(struct work_struct *work)
> >  				sb = inode->i_sb;
> >  				count = 0;
> >  				start = ktime_get_ns();
> > +				/* Protect us from filesystem freezing */
> > +				if (!sb_deferred_reclaim_get(sb)) {
> > +					inode_reclaim_skip_inodes(&inode_batch,
> > +								  sb);
> > +					sb = NULL;
> > +					continue;
> > +				}
> >  			}
> >  			count++;
> >  			list_del_init(&inode->i_lru);
> 
> [Severity: Medium]
> Can evicting a stacked filesystem inode (such as overlayfs or ecryptfs) in
> inode_reclaim_deferred() still block the worker on a frozen lower
> filesystem?
> 
> When iput_final() drops the last reference to an unlinked stacked inode
> under PF_MEMALLOC, it queues the stacked inode to deferred_reclaim:
> 
> fs/inode.c:iput_final() {
>     ...
> 	if (current->flags & PF_MEMALLOC && !inode->i_nlink) {
> 		LIST_HEAD(defer);
> 
> 		list_add(&inode->i_lru, &defer);
> 		queue_deferred_reclaim(sb, 1, &defer);
> 		return;
> 	}
> 	evict(inode);
> }
> 
> __get_inode_reclaim_batch() and sb_deferred_reclaim_get() only check the
> stacked superblock (inode->i_sb), which is unfrozen.  When the worker runs
> evict(inode), current->flags does not have PF_MEMALLOC set, so dropping
> the underlying unlinked dentry/inode in ovl_destroy_inode() or
> ecryptfs_evict_inode() enters iput_final() -> evict() synchronously on the
> frozen lower writable filesystem and blocks on sb_start_intwrite().

This looks a bit artificial. Two layers of stacked filesystems, the lowest
filesystem is frozen and that can block deferred reclaim worker in evict().
If this causes practical problems, we could mark reclaim workers
PF_MEMALLOC but I'm not convinced it's worth it at this point.

> > diff --git a/fs/super.c b/fs/super.c
> > index fa345d5027bff..77e6ab6383b8b 100644
> > --- a/fs/super.c
> > +++ b/fs/super.c
> 
> [ ... ]
> 
> > @@ -2648,6 +2678,7 @@ static int thaw_super_locked(struct super_block *sb, enum freeze_holder who,
> >  	sb->s_writers.frozen = SB_UNFROZEN;
> >  	sb->s_writers.freeze_owner = NULL;
> >  	sb_freeze_wake(sb);
> >  	sb_freeze_unlock(sb, SB_FREEZE_FS);
> > +	sb_unblock_deferred_reclaim(sb);
> >  out_deactivate:
> >  	deactivate_locked_super(sb);
> >  	return 0;
> 
> [Severity: Medium]
> Can setting sb->s_writers.frozen = SB_UNFROZEN before
> sb_unblock_deferred_reclaim(sb) cause inode_reclaim_deferred() to spin in
> a tight loop without calling cond_resched()?
> 
> In both thaw_super_locked() and the freeze_fs() error path of
> freeze_super(), s_writers.frozen becomes SB_UNFROZEN before
> s_deferred_reclaim_running is reset from -1 to 0 in
> sb_unblock_deferred_reclaim().  During that window,
> __get_inode_reclaim_batch() only checks s_writers.frozen != SB_UNFROZEN
> and moves the inodes to inode_batch, after which
> sb_deferred_reclaim_get(sb) fails, inode_reclaim_skip_inodes() splices
> them back onto queue->list, and inode_reclaim_deferred() continues
> without reaching cond_resched(), immediately re-dequeuing the same inodes
> on the next iteration.  Calling sb_unblock_deferred_reclaim(sb) before
> setting s_writers.frozen = SB_UNFROZEN (or also checking
> s_deferred_reclaim_running in __get_inode_reclaim_batch()) would avoid
> this window.

Mostly harmless but easy to improve by making __get_inode_reclaim_batch()
check s_deferred_reclaim_running. I'll do that.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

