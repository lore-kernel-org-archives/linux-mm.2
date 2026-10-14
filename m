Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 423DBCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 11:21:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F2A86B008A; Wed, 14 Oct 2026 07:21:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C9F06B008C; Wed, 14 Oct 2026 07:21:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B94A6B0092; Wed, 14 Oct 2026 07:21:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D14796B008A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 07:21:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 642ACA8040
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:21:47 +0000 (UTC)
X-FDA: 85320991854.21.1C216EC
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0608E100005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:21:44 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v5aryRzQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nQGRuDzi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v5aryRzQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nQGRuDzi;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791976905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y1sGcjjJPHmNpXo6cQ7qcW0PcSuB1I3YLh0buAsrEm0=;
	b=WmUDTV+7toqSd8UyT/5ZEsfrYWjvBU8LIFiZ1ugA2vvDHWWQyb+bjIZ3LbOtwWYDlvK3pY
	t14zWML141jMew8YICSU+a3+Z27D1EH7G66onV6D+x/2xR3IKLmISSt2XkanTqpP9Qn3YS
	6WG0m8UYMUfjb/Kh7C/VkeQzLzoD+i0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v5aryRzQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nQGRuDzi;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=v5aryRzQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=nQGRuDzi;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791976905;
	b=CcFXJ8Prk4lqz9WWnVp4C5iTUPCH8DWWUcg2qwJEshofs/pnw0u0t0Dnz+S0f0qLJO8qA7
	18tMIiYXWsiBzXb27wHjfcQzWFwhtw0QZ8ndQWQeBEtwYNj1UQmLH+c0cYPr12kl2B4VYF
	VnaYRIAYhZZUNpMJR3zuKHaHVXBFpSw=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 52ADE1FB14;
	Wed, 14 Oct 2026 11:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791976903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y1sGcjjJPHmNpXo6cQ7qcW0PcSuB1I3YLh0buAsrEm0=;
	b=v5aryRzQwO6Hzssjls/4garI7bi/cOUrTnFQ2AQ4IxVGwr+QOEdvL00t9ZVoHBEbvkeHnT
	o089OHj3nXZpXx+4a6/mPzPS4WtToLoEZEkLj5fiL7l4Nw2anh7ezxW7+77nMxyO6lFlkG
	hTc4XZQby3IRFBlNUPvbX25GJ1I+yj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791976903;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y1sGcjjJPHmNpXo6cQ7qcW0PcSuB1I3YLh0buAsrEm0=;
	b=nQGRuDzisVkgcwCdIVXNIrJS7FxNMaj8PoKjOitZFri6okGcfkXQm4UWdoJnsmz9mzruLk
	KvGgMQittpxkW/CQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1791976903; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y1sGcjjJPHmNpXo6cQ7qcW0PcSuB1I3YLh0buAsrEm0=;
	b=v5aryRzQwO6Hzssjls/4garI7bi/cOUrTnFQ2AQ4IxVGwr+QOEdvL00t9ZVoHBEbvkeHnT
	o089OHj3nXZpXx+4a6/mPzPS4WtToLoEZEkLj5fiL7l4Nw2anh7ezxW7+77nMxyO6lFlkG
	hTc4XZQby3IRFBlNUPvbX25GJ1I+yj0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1791976903;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=y1sGcjjJPHmNpXo6cQ7qcW0PcSuB1I3YLh0buAsrEm0=;
	b=nQGRuDzisVkgcwCdIVXNIrJS7FxNMaj8PoKjOitZFri6okGcfkXQm4UWdoJnsmz9mzruLk
	KvGgMQittpxkW/CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0EDEF133F1;
	Wed, 14 Oct 2026 11:21:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id W16aNsZlz2rALQAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 14 Oct 2026 11:21:43 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1BC77A1411; Wed, 14 Oct 2026 13:21:42 +0200 (CEST)
Date: Wed, 14 Oct 2026 13:21:42 +0200
From: Jan Kara <jack@suse.cz>
To: Liz Fong-Jones <lizf@honeycomb.io>
Cc: Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Tejun Heo <tj@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jens Axboe <axboe@kernel.dk>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Xin Yin <yinxin.x@bytedance.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ian@honeycomb.io
Subject: Re: [PATCH v6 3/3] writeback: switch a replaced cgwb's inodes to its
 successor
Message-ID: <pmvqotiw5cvzdk4sduczbmgrqh7o3qf4jb6l6qzep7iy4fsl7d@y2uis3u6v3qp>
References: <20261002-wb-dying-cgwb-flush-v6-0-1991b4e2dcff@honeycomb.io>
 <20261002-wb-dying-cgwb-flush-v6-3-1991b4e2dcff@honeycomb.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261002-wb-dying-cgwb-flush-v6-3-1991b4e2dcff@honeycomb.io>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0608E100005
X-Stat-Signature: z5wbc94cmtf543mpww8modmk3nahynkz
X-HE-Tag: 1791976904-909548
X-HE-Meta: U2FsdGVkX18kp4ofIGguzrGHWvo1g/J82nSaeLfTeqsAHN+a+fxr/K9CA65aJlSj+FSqkBLmYhblDVm0Z4wn5MmyNtQAWY86xPHywP2BApllCkDIuNReNCsH3pYOr58yds0ql4veNRGRclRJat0I4zFKtHZHosSb4pvynOb0QozAGKy2xbW6dmuk0PJTvFWAclYfSZlmB9piOqkdZaWVf27XwRn674TFDJkyF20zC5gSS8iqWlvyrtF7/YKXEYhDoNORWKdODZCcmlZLq7uita82hVQCXh11Oica5c3nJj6AKb3VAOek5rc2ZFY4162aLDtYR3huHWFgScv3OeLH4a4hhOhwsnhg+YQ4kinFIFWErvs5uB+KA4NP5ebYxSjqzEYhHPA1dSW7wmAjlEUT29ZXAQL2Gwdd0jkji9rlywRpVvbEezAceeiWETLW/fmbyB25i/KFYI0N+4z7jaPl2bJtLwc4bMlDVe6ybiWdt+8/HU/lLl7LE0gJPf/XjIwiVZyvVad+Fgj77c+2vEsPhPxAIopWM6Jr1csnEH///Wb7LpTYYsG7pp7NJS1+Q3eUvKlH7txWQeOF3T9pq3XIw8J3otvcBAIBKTVhFJupSN+jLSnHF/YcXRb0OqLQAjYaHO2rx2/5kyrm4d6C2O6g/xLAbxbqPRjzYTmfsYCFp4D7bEHs+KUI4aBzWO3xiYbnSQtGNkPq8DQQ7U7eIvUlWe0HjMYEB1DUWGpQHi3y9PM76G6pgMLcVqgznsndQ0iGuU5lnV3nQb8bg/BNo/bP54sXsd9c3anqlbQn4rSc78Ywmih/4dqnthx3uo3XWE0C6Qa76KT7Bp2U9FYx/GdWyzyjNOQ+NQhhlrBLGcysWA1x4H4hxtPGrRyVMbWzsub2YPG4d+BNEbnT9M/axWlsHmDTpaF0V4S6Y2fvcNf4vd2g0akw2tV0SQ6MZc3U5SDxaBxfvGcV0WeMR4uRsZc
 w+l+N18X
 6E1srV1Ci+l2Mi0MR7MkICxdCVXcXhzqzWGgCU+8+C1gjtrrhrgmr810DGUtepTq7cX+nT5WX3zr2XLRkUbVTBeG+zPQeJ6CCllIXd+9CBBz/Pg/AxXo8FmWF9lDJT3HPHPMI+nbO7Jf4/5EP0hyKuBRHCly+P6UJTT1TLsDlAkU0AJPX7geeLuM3ll/Akb13VeLz8k0XmGxpE8/cJzO3ChDRAJc7RtJEZSf+lFApRZTN5K3fDntIs/VPs96h+f46pMyErgt6j3QPf1jJjDGUOCEktYeAOSc0sjkP5EHjJHhv5ScyeKzZ2eGAE3ExKCEGVR5g0hMmFWAUqYQVIPMfd9vulNQu9gs56u2Ii4t6PSH/lO8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 02-10-26 21:40:48, Liz Fong-Jones wrote:
> When a live memcg's blkcg association changes, cgwb_create() replaces
> its killed wb in bdi->cgwb_tree. Foreign flushes for the memcg then
> find the new wb, but the inodes, dirty or not, are still attached to the
> old one, and they only move over as they are written back (see
> wbc_attach_and_unlock_inode()). Until then, other memcgs appending to
> those inodes stall in balance_dirty_pages().
> 
> After the takeover, queue a work item that switches all of the old wb's
> inodes to the wb foreign flushes now find, like cleanup_offline_cgwb()
> does for b_attached and b_dirty_time, but including b_dirty, b_io and
> b_more_io. The switch carries the dirty and writeback page counts, so
> nothing needs to be written back first. cgwb_create() can run with
> interrupts disabled (folio_account_dirtied() -> inode_attach_wb()), so
> it only queues the work. A switch to the old wb that was queued before
> it was replaced can land after the work ran, so
> inode_switch_wbs_work_fn() queues the work again when the wb it switched
> inodes to is dying and no longer owns its slot. An inode attached to the
> old wb as it is replaced (see __inode_attach_wb()) still moves over only
> when written back. If the successor is already gone, fall back like
> cleanup_offline_cgwb() does, to the nearest live ancestor's wb or the
> root wb.
> 
> Test: a live cgroup appends to 5000 files on XFS at 250MiB/s, io is
> disabled on its parent so its wb is killed, it creates a file (the
> takeover), and a sibling keeps appending to its files under a 4G parent
> limit. Worst lag of the sibling behind schedule over 30s, in three runs:
> 
>   without this patch    9.1s   4.0s   1.0s
>   with this patch       1.0s   1.1s   1.1s
> 
> Without this patch, moving the old wb's inodes over took up to 11s,
> first switch to last; with it, all 5001 were switched in a 27-39ms
> window, with up to 311MiB of the old cgroup's pages dirty.
> 
> Suggested-by: Tejun Heo <tj@kernel.org>
> Assisted-by: Claude:claude-opus-5-5 checkpatch sparse
> Assisted-by: Claude:claude-fable-5-1
> Signed-off-by: Liz Fong-Jones <lizf@honeycomb.io>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c                | 61 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/backing-dev-defs.h |  1 +
>  include/linux/backing-dev.h      |  1 +
>  include/linux/writeback.h        |  1 +
>  mm/backing-dev.c                 | 49 ++++++++++++++++++++++++++++++++
>  5 files changed, 113 insertions(+)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 050d507aa554..7e80f3935dce 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -624,6 +624,8 @@ void inode_switch_wbs_work_fn(struct work_struct *work)
>  
>  	llist_for_each_entry_safe(isw, next_isw, list, list)
>  		process_inode_switch_wbs(new_wb, isw);
> +	/* @new_wb may have been replaced while the switches were queued */
> +	cgwb_kick_replaced(new_wb);
>  	wb_put(new_wb);
>  }
>  
> @@ -809,6 +811,65 @@ bool cleanup_offline_cgwb(struct bdi_writeback *wb)
>  	return restart;
>  }
>  
> +/**
> + * switch_replaced_cgwb - switch a replaced wb's inodes to its successor
> + * @wb: target wb, replaced in bdi->cgwb_tree by another wb of its memcg
> + *
> + * Switch all inodes attached to @wb, dirty or not, to the wb that foreign
> + * flushes now find for @wb's memcg.  If that one is already gone, fall back
> + * like cleanup_offline_cgwb() does, to the nearest live ancestor's wb or the
> + * root wb.  The switch carries the dirty and writeback page counts, so
> + * nothing needs to be written back first.  Returns %true if not all inodes
> + * were switched and the function has to be restarted.
> + */
> +bool switch_replaced_cgwb(struct bdi_writeback *wb)
> +{
> +	struct cgroup_subsys_state *memcg_css;
> +	struct inode_switch_wbs_context *isw;
> +	struct bdi_writeback *new_wb;
> +	bool restart;
> +	int nr = 0;
> +
> +	new_wb = wb_get_lookup(wb->bdi, wb->memcg_css);
> +	for (memcg_css = wb->memcg_css->parent; !new_wb && memcg_css;
> +	     memcg_css = memcg_css->parent)
> +		new_wb = wb_get_create(wb->bdi, memcg_css, GFP_KERNEL);
> +	if (!new_wb)
> +		new_wb = &wb->bdi->wb; /* wb_get() is noop for bdi's wb */
> +	if (WARN_ON_ONCE(new_wb == wb)) {
> +		wb_put(new_wb);
> +		return false;
> +	}
> +
> +	isw = kzalloc_flex(*isw, inodes, WB_MAX_INODES_PER_ISW);
> +	if (!isw) {
> +		wb_put(new_wb);
> +		return false;
> +	}
> +
> +	atomic_inc(&isw_nr_in_flight);
> +
> +	spin_lock(&wb->list_lock);
> +	restart = isw_prepare_wbs_switch(new_wb, isw, &wb->b_attached, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_io, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_more_io, &nr) ||
> +		  isw_prepare_wbs_switch(new_wb, isw, &wb->b_dirty_time, &nr);
> +	spin_unlock(&wb->list_lock);
> +
> +	if (nr == 0) {
> +		atomic_dec(&isw_nr_in_flight);
> +		wb_put(new_wb);
> +		kfree(isw);
> +		return restart;
> +	}
> +
> +	trace_inode_switch_wbs_queue(wb, new_wb, nr);
> +	wb_queue_isw(new_wb, isw);
> +
> +	return restart;
> +}
> +
>  /**
>   * wbc_attach_and_unlock_inode - associate wbc with target inode and unlock it
>   * @wbc: writeback_control of interest
> diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
> index 33e06b1b1e1c..7713fd60c985 100644
> --- a/include/linux/backing-dev-defs.h
> +++ b/include/linux/backing-dev-defs.h
> @@ -162,6 +162,7 @@ struct bdi_writeback {
>  					 * to this wb */
>  	struct llist_head switch_wbs_ctxs;	/* queued contexts for
>  						 * writeback switching */
> +	struct work_struct replaced_work;	/* see switch_replaced_cgwb() */
>  
>  	union {
>  		struct work_struct release_work;
> diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
> index f7ef5895625a..84057fa92f24 100644
> --- a/include/linux/backing-dev.h
> +++ b/include/linux/backing-dev.h
> @@ -151,6 +151,7 @@ static inline void bdi_wb_stat_mod(struct inode *inode, enum wb_stat_item item,
>  
>  struct bdi_writeback *wb_get_lookup(struct backing_dev_info *bdi,
>  				    struct cgroup_subsys_state *memcg_css);
> +void cgwb_kick_replaced(struct bdi_writeback *wb);
>  struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
>  				    struct cgroup_subsys_state *memcg_css,
>  				    gfp_t gfp);
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index b749a9a5a5ee..88e4b5049698 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -209,6 +209,7 @@ int cgroup_writeback_by_id(u64 bdi_id, int memcg_id,
>  			   enum wb_reason reason, struct wb_completion *done);
>  void cgroup_writeback_umount(struct super_block *sb);
>  bool cleanup_offline_cgwb(struct bdi_writeback *wb);
> +bool switch_replaced_cgwb(struct bdi_writeback *wb);
>  
>  /**
>   * inode_attach_wb - associate an inode with its wb
> diff --git a/mm/backing-dev.c b/mm/backing-dev.c
> index 85b2c95a920c..e401293c260a 100644
> --- a/mm/backing-dev.c
> +++ b/mm/backing-dev.c
> @@ -637,9 +637,51 @@ static void cgwb_release_workfn(struct work_struct *work)
>  	bdi_put(bdi);
>  	WARN_ON_ONCE(!list_empty(&wb->b_attached));
>  	WARN_ON_ONCE(work_pending(&wb->switch_work));
> +	WARN_ON_ONCE(work_pending(&wb->replaced_work));
>  	call_rcu(&wb->rcu, cgwb_free_rcu);
>  }
>  
> +static void cgwb_replaced_workfn(struct work_struct *work)
> +{
> +	struct bdi_writeback *wb = container_of(work, struct bdi_writeback,
> +						replaced_work);
> +
> +	do {
> +		cond_resched_tasks_rcu_qs();
> +	} while (switch_replaced_cgwb(wb));
> +	wb_put(wb);
> +}
> +
> +/* called with cgwb_lock held, possibly with interrupts disabled */
> +static void cgwb_queue_replaced_work(struct bdi_writeback *wb)
> +{
> +	lockdep_assert_held(&cgwb_lock);
> +
> +	if (wb_tryget(wb) && !queue_work(system_dfl_wq, &wb->replaced_work))
> +		wb_put(wb);
> +}
> +
> +/**
> + * cgwb_kick_replaced - switch inodes away from @wb again if it was replaced
> + * @wb: wb that inodes were just switched to
> + *
> + * An inode switch pins its target wb before the switch lands, and the wb
> + * may be replaced in cgwb_create() and have its replaced_work run in
> + * between.  Kick the work again so that those inodes reach the successor
> + * too.  A dying wb that still owns its slot is left alone: foreign flushes
> + * can reach it, and the work would look up @wb itself.
> + */
> +void cgwb_kick_replaced(struct bdi_writeback *wb)
> +{
> +	if (!wb_dying(wb))
> +		return;
> +
> +	spin_lock_irq(&cgwb_lock);
> +	if (radix_tree_lookup(&wb->bdi->cgwb_tree, wb->memcg_css->id) != wb)
> +		cgwb_queue_replaced_work(wb);
> +	spin_unlock_irq(&cgwb_lock);
> +}
> +
>  static void cgwb_release(struct percpu_ref *refcnt)
>  {
>  	struct bdi_writeback *wb = container_of(refcnt, struct bdi_writeback,
> @@ -724,6 +766,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
>  	INIT_WORK(&wb->switch_work, inode_switch_wbs_work_fn);
>  	init_llist_head(&wb->switch_wbs_ctxs);
>  	INIT_WORK(&wb->release_work, cgwb_release_workfn);
> +	INIT_WORK(&wb->replaced_work, cgwb_replaced_workfn);
>  	set_bit(WB_registered, &wb->state);
>  	bdi_get(bdi);
>  
> @@ -748,6 +791,12 @@ static int cgwb_create(struct backing_dev_info *bdi,
>  			old_wb = radix_tree_deref_slot_protected(slot, &cgwb_lock);
>  			if (wb_dying(old_wb)) {
>  				radix_tree_replace_slot(&bdi->cgwb_tree, slot, wb);
> +				/*
> +				 * @old_wb is out of foreign flushes' reach
> +				 * but may still have inodes attached, dirty
> +				 * or not.  Switch them over to @wb.
> +				 */
> +				cgwb_queue_replaced_work(old_wb);
>  				ret = 0;
>  			} else {
>  				ret = -EEXIST;
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

