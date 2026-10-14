Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C23CCC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 12:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 536A06B0088; Wed, 14 Oct 2026 08:09:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E2D06B008C; Wed, 14 Oct 2026 08:09:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30CCC6B0088; Wed, 14 Oct 2026 08:09:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07B8D6B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:09:56 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 889621C2B34
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:09:55 +0000 (UTC)
X-FDA: 85321113150.21.9F8D6C4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1B17D180006
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 12:09:52 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e6QYeMly;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Tyzs/yEa";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2dF0wrT0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jdy6FgGG;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791979793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8FG5Tah1XFpijIMiq2vBWdaYOek2OfSTBQJQ4IjqohI=;
	b=LHahgG3VaqgnM9hVTyIxqoz/z7A9VXr8Ce9y+be2BqyN+lfuS4KwwdCxG8rcH0wjy/npum
	mfxWyAVFefWjQHMxDIu6YeUjJ81WyqH7WGLpTRdmuJdJKLLiy8JoZG6YGcAU+bMq2sTNUv
	nTl33Aux6eSd5xVFbHMIiu0h7Dc9xss=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791979793;
	b=ipOO7hiRnbh2JR0d6yOE5yYBvQ4rya6Pq0SrFoRi378HLueOz4z6GOeDcvHwA3E+HWbuRg
	X5pB7aYlUhPq+cJHEKPBp6ODeIoN60N2JbWF6Q90Ll55JwGUNOH7mOYSkqFF1Jwzl7VMxF
	MddoavwIe4riANq5aXjw/vw/9Z8X+sI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=e6QYeMly;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="Tyzs/yEa";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=2dF0wrT0;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=jdy6FgGG;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9A8DB1FB16;
	Wed, 14 Oct 2026 12:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791979791; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8FG5Tah1XFpijIMiq2vBWdaYOek2OfSTBQJQ4IjqohI=;
	b=e6QYeMlyErvroqgWWLsoabOGbYpqE+ml/27X9Kb9Mx9eG8XpJrXdMZSHyPipaqvWdOwRix
	LUswbPM38pCqmHj0DkJscpjwHFhfdF07hEejDWBj8lm/SJW/ccLY+WXJmd/Zuj4jLocsbL
	pPdjU66DcMqcN39pH2fPU7kBBEyvUf0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791979791;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8FG5Tah1XFpijIMiq2vBWdaYOek2OfSTBQJQ4IjqohI=;
	b=Tyzs/yEa2Hir3/5hezH+6xh/1fOZDkKAeK2HeZpFtSX9jWSxlmMuTIpChWYhzUD5YhH2Jv
	hzup+InVPVEe5pAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791979790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8FG5Tah1XFpijIMiq2vBWdaYOek2OfSTBQJQ4IjqohI=;
	b=2dF0wrT0CdwJsq2qHRGWGrNOtSEkCs3DDIt/hsDiPnp+7NYniZ4gAzZwwQx+OD+0K/1mLY
	vhpuEyOl5lypxdjYGL4VFZGairFBw2xdHvbfh2TRzmY1Q18NGazkBwZ6mWdCqZq0DEqk1e
	BAD+POMnezJphMyAbIAtS8AXw5i4uBE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791979790;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8FG5Tah1XFpijIMiq2vBWdaYOek2OfSTBQJQ4IjqohI=;
	b=jdy6FgGGAz2LbRNEV9BtK6Js0l2B1fA0/8UbgHr8DE/LKAESVh8KRy9UgbgEt4i480KyQp
	wX6Q4Rn0F79NW3CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42CCD1373B;
	Wed, 14 Oct 2026 12:09:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id PgImBw5xz2rcYgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 14 Oct 2026 12:09:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 10904A1410; Wed, 14 Oct 2026 09:50:11 +0200 (CEST)
Date: Wed, 14 Oct 2026 09:50:11 +0200
From: Jan Kara <jack@suse.cz>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ian@honeycomb.io
Subject: Re: [PATCH v6 2/3] writeback: let foreign flushes reach dying cgwbs
Message-ID: <t62ngd3bfuqgu4542jcsqp5mtahopcyd4dmkjk6c5kzepqvs4d@spdimb7v5iah>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
 <20261002-wb-dying-cgwb-flush-v6-2-1991b4e2dcff@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-2-1991b4e2dcff@honeycomb.io>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1B17D180006
X-Stat-Signature: c4imor4w1uwcr1sz3guicnrkirph31ap
X-HE-Tag: 1791979792-453798
X-HE-Meta: U2FsdGVkX1/gH5mvX8h+6ftLqF4ZIFUsOtbSEqMhsysGqD6pibndySynfrmS2fgC2o4NzNZSs/mHQ+m5PYoFvSwwCfbZprPwFuNqvDaMWRQ8L4FSK3tFiEAchSYPufR87rkpw4f2LZfhBZJVoVPpJlY6Odi4MdZHo02fgfwzCwV1Scr3W0Jd9JdGTL2rR5QZ9k8OF05zBL54c0+pvlr20YFqH/E6bLk1ShKtVrJv9ncLQlD3Aek91K1d/UjzzZu0j/yBrKpJE2OjwBShbMgH7b0fV9m7aVot1NPg3SzLLkfc9lCaeEKpb8YAEQ2VRZI/mhPaGncz+wkYr5GzFOMiMwICitfh3hlNPGbTX4IwzE8jVEOQlaKNkCLLhZlEK6rTDA3ajAqxVpi8E7Z4qcsePzfdNVgZOhdlRMOpHFB+ZBHJidkPnAcqOakGGArx9s/6AZ798szrogffDuB21E/2Hrcmb4v1MCrj4IZracWK9cmAceJtyJ/4La/3MvJF9ufiytdZMfIFBeZSeLXnzCckEAkfeF0WWspsXUTsTsJnSPOO+rKroGyosPs314c8+aOxbk5HCWrqvzaMMassI7tz/5Wpbbe+9PVsUm6BFAJBsEwyqPM2fIhMWnjy5q4HWPD98ELq58g7gQIh/I3xL6GVmo9NeUCh+32FjXr665SVRqqnwoufXSIp70PL3UH/aXe0Vl2XdOiqk7OpC8ZJk4oHK2t3thMx0+tiDbUuXjI7Zr216Fn6sipB3EYc8YHWgsw+VbOuBU9nhcJDj8MtdksgHlRPZoBdOvPwb27BQZYHIAasE8Mi7hHzjjhrVLRCBvyJ007ChdMIxMHn4AFQ8DTLtsaYvnof6Pk8hD9WT2xJP0scCPlgDvEkFXj9ISKgRmtj9hBFusVpBSaZRqY1D2wSOPaBipvyefMcKsR+D6Q+SUegj6GNdmiM/ECjQZM4G4wbx6WK8chsmlV84PEqA3+
 VO5EBN1D
 uemMHWdB/CkSn+JjLW65CpFEJve9+w/hQNAdj6d75QqkxETsMc7TCzKVE4w0jxwz3AtgK2ILObOO9Jhp5vi9KeVGTKZ2wKfLaX4c1mH/mbsFZVYfB4pDGSzWmdpiD3j129zeXJKb0q2XotGRPaoyAlh2u60yB5PZwBAEUUMMGdxV5jyGPbJMy6aTEaTs0rFAJ9iBc6fL5uqgag87bcGg7cshqL4y47UrUPgi3ALNA0cMxLNx5L7REUTsDHmh/h8bh50vg0aa0fldk5yQmRtRpRCgHzuwEaCZbSFBQKKcJV3k4umRq+wj6La97McB+7rUENmBrc5IDvU1LNaqGXhPHKJrjPnfMR13e6g7iI6auQNij//Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 02-10-26 21:40:46, Liz Fong-Jones wrote:
> When a container is replaced and the new one keeps appending to files
> the old one left dirty, the new one can stall in balance_dirty_pages()
> for seconds to minutes, with little CPU use and its write lag growing
> linearly before it recovers. This matches a 30-60s stall after each
> deploy of a container at Honeycomb that reads from Kafka and writes
> columnar files to a host volume.
> 
> Trigger: a cgroup dirties files and is removed while they are still
> dirty, and a sibling keeps appending to the same files under a parent
> memory limit. cgwb_kill() takes the removed memcg's wbs out of
> bdi->cgwb_tree, but the inodes stay attached to them, so the sibling's
> foreign flushes fail with -ENOENT in wb_get_lookup().
> 
> Keep killed wbs in bdi->cgwb_tree until they are released, so that
> cgroup_writeback_by_id() finds them through the regular lookup. The
> creation paths skip dying wbs, and a new wb takes over the slot of a
> dying one when the memcg's blkcg association changes; release only
> removes a wb that still owns its slot. The blkcg association check moves
> from wb_get_lookup() to the creation side: once a memcg with io enabled
> is removed, cgroup_get_e_css() returns an ancestor's io css and its
> dying wb would not match.
> 
> With commit 168a8c13159c ("writeback: size foreign flushes by target
> wb dirty pages"), the flush is then sized from the wb's own dirty
> pages and writes out what the replacement dirtied.
> 
> Test, on top of that commit: a cgroup appends to 1000 files at
> 250MiB/s and is removed, then a second cgroup keeps appending to the
> same files under a 4G parent limit. Worst lag of the second writer
> behind schedule over 120s, in three runs:
> 
>   without this patch   85.3s  46.9s  52.1s
>   with this patch       1.0s   1.2s   1.2s
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
> Assisted-by: Claude:claude-fable-5-1
> Acked-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  include/linux/backing-dev-defs.h | 22 ++++++++--
>  include/linux/backing-dev.h      |  2 +-
>  mm/backing-dev.c                 | 90 ++++++++++++++++++++++++++++++----------
>  3 files changed, 86 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index 4f1084937315..33e06b1b1e1c 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -100,8 +100,10 @@ struct wb_completion {
>   * refcounted with the number of inodes attached to it, and pins the memcg
>   * and the corresponding blkcg.  As the corresponding blkcg for a memcg may
>   * change as blkcg is disabled and enabled higher up in the hierarchy, a wb
> - * is tested for blkcg after lookup and removed from index on mismatch so
> - * that a new wb for the combination can be created.
> + * is tested for blkcg after lookup and killed on mismatch so that a new wb
> + * for the combination can be created.  A killed wb stays in the index until
> + * it is released or a new wb takes over its slot, so that foreign flushes
> + * can still reach it.
>   *
>   * Each bdi_writeback that is not embedded into the backing_dev_info must hold
>   * a reference to the parent backing_dev_info.  See cgwb_create() for details.
> @@ -196,7 +198,7 @@ struct backing_dev_info {
>  	struct bdi_writeback wb;  /* the root writeback info for this bdi */
>  	struct list_head wb_list; /* list of all wbs */
>  #ifdef CONFIG_CGROUP_WRITEBACK
> -	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
> +	struct radix_tree_root cgwb_tree; /* radix tree of cgroup wbs, incl. killed */
>  	struct mutex cgwb_release_mutex;  /* protect shutdown of wb structs */
>  	struct rw_semaphore wb_switch_rwsem; /* no cgwb switch while syncing */
>  #endif
> @@ -229,6 +231,17 @@ static inline bool wb_tryget(struct bdi_writeback *wb)
>  	return true;
>  }
>  
> +/**
> + * wb_tryget_live - try to increment a wb's refcount if it hasn't been killed
> + * @wb: bdi_writeback to get
> + */
> +static inline bool wb_tryget_live(struct bdi_writeback *wb)
> +{
> +	if (wb != &wb->bdi->wb)
> +		return percpu_ref_tryget_live(&wb->refcnt);
> +	return true;
> +}
> +
>  /**
>   * wb_get - increment a wb's refcount
>   * @wb: bdi_writeback to get
> @@ -271,7 +284,8 @@ static inline void wb_put(struct bdi_writeback *wb)
>   * wb_dying - is a wb dying?
>   * @wb: bdi_writeback of interest
>   *
> - * Returns whether @wb is unlinked and being drained.
> + * Returns whether @wb has been killed and is being drained.  A dying wb may
> + * still be in bdi->cgwb_tree, see cgwb_kill().
>   */
>  static inline bool wb_dying(struct bdi_writeback *wb)
>  {
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index c2284466e7aa..f7ef5895625a 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -222,7 +222,7 @@ wb_get_create_current(struct backing_dev_info *bdi, gfp_t gfp)
>  
>  	rcu_read_lock();
>  	wb = wb_find_current(bdi);
> -	if (wb && unlikely(!wb_tryget(wb)))
> +	if (wb && unlikely(!wb_tryget_live(wb)))
>  		wb = NULL;
>  	rcu_read_unlock();
>  
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index cecbcf9060a6..85b2c95a920c 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -614,6 +614,12 @@ static void cgwb_release_workfn(struct work_struct *work)
>  						release_work);
>  	struct backing_dev_info *bdi = wb->bdi;
>  
> +	scoped_guard(spinlock_irq, &cgwb_lock) {
> +		/* a newer wb may have taken the slot, see cgwb_create() */
> +		radix_tree_delete_item(&bdi->cgwb_tree, wb->memcg_css->id, wb);
> +		list_del(&wb->offline_node);
> +	}
> +
>  	mutex_lock(&wb->bdi->cgwb_release_mutex);
>  	wb_shutdown(wb);
>  
> @@ -627,10 +633,6 @@ static void cgwb_release_workfn(struct work_struct *work)
>  
>  	fprop_local_destroy_percpu(&wb->memcg_completions);
>  
> -	spin_lock_irq(&cgwb_lock);
> -	list_del(&wb->offline_node);
> -	spin_unlock_irq(&cgwb_lock);
> -
>  	wb_exit(wb);
>  	bdi_put(bdi);
>  	WARN_ON_ONCE(!list_empty(&wb->b_attached));
> @@ -645,11 +647,16 @@ static void cgwb_release(struct percpu_ref *refcnt)
>  	queue_work(cgwb_release_wq, &wb->release_work);
>  }
>  
> +/*
> + * A killed wb stays in bdi->cgwb_tree until it is released or replaced in
> + * cgwb_create(), so that foreign flushes can still find it through
> + * wb_get_lookup().  Inodes attached to it can keep collecting dirty pages
> + * from other memcgs until they are written back and switched away.
> + */
>  static void cgwb_kill(struct bdi_writeback *wb)
>  {
>  	lockdep_assert_held(&cgwb_lock);
>  
> -	WARN_ON(!radix_tree_delete(&wb->bdi->cgwb_tree, wb->memcg_css->id));
>  	list_del(&wb->memcg_node);
>  	list_del(&wb->blkcg_node);
>  	list_add(&wb->offline_node, &offline_cgwbs);
> @@ -669,7 +676,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
>  	struct mem_cgroup *memcg;
>  	struct cgroup_subsys_state *blkcg_css;
>  	struct list_head *memcg_cgwb_list, *blkcg_cgwb_list;
> -	struct bdi_writeback *wb;
> +	struct bdi_writeback *wb, *old_wb;
> +	void __rcu **slot;
>  	unsigned long flags;
>  	int ret = 0;
>  
> @@ -681,6 +689,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
>  	/* look up again under lock and discard on blkcg mismatch */
>  	spin_lock_irqsave(&cgwb_lock, flags);
>  	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
> +	if (wb && wb_dying(wb))
> +		wb = NULL;
>  	if (wb && wb->blkcg_css != blkcg_css) {
>  		cgwb_kill(wb);
>  		wb = NULL;
> @@ -727,8 +737,22 @@ static int cgwb_create(struct backing_dev_info *bdi,
>  	spin_lock_irqsave(&cgwb_lock, flags);
>  	if (test_bit(WB_registered, &bdi->wb.state) &&
>  	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
> -		/* we might have raced another instance of this function */
> -		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
> +		/*
> +		 * We might have raced another instance of this function.  A
> +		 * dying wb keeps its slot until released; take it over.
> +		 */
> +		slot = radix_tree_lookup_slot(&bdi->cgwb_tree, memcg_css->id);
> +		if (!slot) {
> +			ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
> +		} else {
> +			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
> +			if (wb_dying(old_wb)) {
> +				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
> +				ret = 0;
> +			} else {
> +				ret = -EEXIST;
> +			}
> +		}
>  		if (!ret) {
>  			list_add_tail_rcu(&wb->bdi_node, &bdi->wb_list);
>  			list_add(&wb->memcg_node, memcg_cgwb_list);
> @@ -765,13 +789,27 @@ static int cgwb_create(struct backing_dev_info *bdi,
>   * @bdi: target bdi
>   * @memcg_css: cgroup_subsys_state of the target memcg (must have positive ref)
>   *
> - * Try to get the wb for @memcg_css on @bdi.  The returned wb has its
> - * refcount incremented.
> - *
> - * This function uses css_get() on @memcg_css and thus expects its refcnt
> - * to be positive on invocation.  IOW, rcu_read_lock() protection on
> - * @memcg_css isn't enough.  try_get it before calling this function.
> - *
> + * Try to get the wb in @memcg_css's slot on @bdi, killed or not.  The
> + * returned wb has its refcount incremented.
> + */
> +struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
> +				    struct cgroup_subsys_state *memcg_css)
> +{
> +	struct bdi_writeback *wb;
> +
> +	if (!memcg_css->parent)
> +		return &bdi->wb;
> +
> +	rcu_read_lock();
> +	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
> +	if (wb && !wb_tryget(wb))
> +		wb = NULL;
> +	rcu_read_unlock();
> +
> +	return wb;
> +}
> +
> +/*
>   * A wb is keyed by its associated memcg.  As blkcg implicitly enables
>   * memcg on the default hierarchy, memcg association is guaranteed to be
>   * more specific (equal or descendant to the associated blkcg) and thus can
> @@ -783,8 +821,8 @@ static int cgwb_create(struct backing_dev_info *bdi,
>   * each lookup.  On mismatch, the existing wb is discarded and a new one is
>   * created.
>   */
> -struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
> -				    struct cgroup_subsys_state *memcg_css)
> +static struct bdi_writeback *cgwb_get_live(struct backing_dev_info *bdi,
> +					   struct cgroup_subsys_state *memcg_css)
>  {
>  	struct bdi_writeback *wb;
>  
> @@ -798,7 +836,7 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
>  
>  		/* see whether the blkcg association has changed */
>  		blkcg_css = cgroup_get_e_css(memcg_css->cgroup, &io_cgrp_subsys);
> -		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget(wb)))
> +		if (unlikely(wb->blkcg_css != blkcg_css || !wb_tryget_live(wb)))
>  			wb = NULL;
>  		css_put(blkcg_css);
>  	}
> @@ -813,8 +851,12 @@ struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
>   * @memcg_css: cgroup_subsys_state of the target memcg (must have positive ref)
>   * @gfp: allocation mask to use
>   *
> - * Try to get the wb for @memcg_css on @bdi.  If it doesn't exist, try to
> - * create one.  See wb_get_lookup() for more details.
> + * Try to get the live wb for @memcg_css on @bdi.  If it doesn't exist, try
> + * to create one.  See cgwb_get_live() for more details.
> + *
> + * This function uses css_get() on @memcg_css and thus expects its refcnt
> + * to be positive on invocation.  IOW, rcu_read_lock() protection on
> + * @memcg_css isn't enough.  try_get it before calling this function.
>   */
>  struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
>  				    struct cgroup_subsys_state *memcg_css,
> @@ -825,7 +867,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
>  	might_alloc(gfp);
>  
>  	do {
> -		wb = wb_get_lookup(bdi, memcg_css);
> +		wb = cgwb_get_live(bdi, memcg_css);
>  	} while (!wb && !cgwb_create(bdi, memcg_css, gfp));
>  
>  	return wb;
> @@ -858,8 +900,10 @@ static void cgwb_bdi_unregister(struct backing_dev_info *bdi)
>  	WARN_ON(test_bit(WB_registered, &bdi->wb.state));
>  
>  	spin_lock_irq(&cgwb_lock);
> -	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
> -		cgwb_kill(*slot);
> +	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0) {
> +		if (!wb_dying(*slot))
> +			cgwb_kill(*slot);
> +	}
>  	spin_unlock_irq(&cgwb_lock);
>  
>  	mutex_lock(&bdi->cgwb_release_mutex);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

