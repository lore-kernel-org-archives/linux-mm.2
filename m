Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01034C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 17:14:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7DE26B0092; Thu, 24 Sep 2026 13:14:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E4F6B0093; Thu, 24 Sep 2026 13:14:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1DE66B0095; Thu, 24 Sep 2026 13:14:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0D976B0092
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:14:10 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 30DFFA679D
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:14:10 +0000 (UTC)
X-FDA: 85249303860.18.D9802A8
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 10CE220009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 17:14:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YcwYBzzm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="xt/ozwdj";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J9E1Mzd2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="2/tb7eyd";
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790270048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34QQgnL9tMrF4G/KJQ0uguI6HdkWU17L//R1PcmpFQM=;
	b=CDvkWZS8YrDYB0oC6lrFLUMzdGGJ0JdTOBXHJkSisMfJrVtHBZOHo/vr2Mx+oAD9wqWiw5
	i5Ji+fNPDbxEcUNiX6zwM9eXyNzsFsGzuYadmN21W47dIt0uBDSKiiUIeU3/df/wY5/F69
	xnKNTL/3VHedRm7Z3rGIAWlrx7Yq/VE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790270048;
	b=R7VI70Xc9Hga4i7bCiZgdguCgWWaofytOQi+/OzN0J7L6lFTeM5Qcy0/ubrq4zL311B7O3
	6g1NFyx0zB/HB7ZXNj3c5Qz59lxOg9EFqEol+KsCS5t4g08GBVCNIGUx3TohpbkPw7pN8z
	XqIyjJv8UldDkZecaVH9eqAIz8o2FyI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=YcwYBzzm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="xt/ozwdj";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=J9E1Mzd2;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="2/tb7eyd";
	spf=pass (imf13.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A9EDA200B7;
	Thu, 24 Sep 2026 17:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790270042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=34QQgnL9tMrF4G/KJQ0uguI6HdkWU17L//R1PcmpFQM=;
	b=YcwYBzzmZfxI8Mj8KPD5qI+LRFPVIYk6J8XfUGcZsPoeZWH+kX8Kc27bEwTOzHqVXEHhWw
	0XK9rAjaQBmJzi8Yf/T+mM8Ir0hoU86YVXh8C9OGsK5Dg/ylrYpIQBlQN6zyX8FuuI9MSm
	p9O754uUooxWPmE8++U1+9pNxFr3kWE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790270042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=34QQgnL9tMrF4G/KJQ0uguI6HdkWU17L//R1PcmpFQM=;
	b=xt/ozwdj1lmOrBTO0sDaW+P9HXIjoA/cFkK6tTKyUnz9yeVX8UPMKA1lCvGWsCgYDlsq1R
	/sRZ2oEXTuEW5kDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1790270038; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=34QQgnL9tMrF4G/KJQ0uguI6HdkWU17L//R1PcmpFQM=;
	b=J9E1Mzd2/1OXwQfm9fi7WrroIgHKnW7cGM8Q30ds98l74lLXvNNLMAW/SsIfPW9y94D3d6
	ceD0mP0vmk7R9RBC/DindpP6w1lPXnN69eWbL9xKNLSwD0mEjU1Pj3w/BrNJ8HbgUTrVmS
	IjRW9/Bvb5wNdW/IpxAQJpt2lVDHNVw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1790270038;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=34QQgnL9tMrF4G/KJQ0uguI6HdkWU17L//R1PcmpFQM=;
	b=2/tb7eyduZRuPIEktXTsi4L2DCfBb7A//qLEeztFP0I6AhvxeLPPLI+0orFufABmBJkClK
	BpkCwVvg6LdNfUCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 814DB13354;
	Thu, 24 Sep 2026 17:13:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id YtAUF1ZatWpKbgAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 24 Sep 2026 17:13:58 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0FE15A132E; Thu, 24 Sep 2026 19:13:58 +0200 (CEST)
Date: Thu, 24 Sep 2026 19:13:58 +0200
From: Jan Kara <jack@suse.cz>
To: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Mikhail Rudenko <xyzzy@yandex-team.ru>
Subject: Re: [PATCH v2 3/5] fs: Basic infrastructure for offloading inode
 reclaim
Message-ID: <vqrehgmhhunigf65ldm7wttjsokbhfdyy2nmi7woteimd33mfr@q7kdegk5gwzb>
References: <20260923200927.1834507-1-agruenba@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260923200927.1834507-1-agruenba@redhat.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Stat-Signature: 1zw6wsnqc4uiied3fkj9kr3fgc5xdxu7
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 10CE220009
X-HE-Tag: 1790270047-743365
X-HE-Meta: U2FsdGVkX1/ZBPR9h7zCRO7UzCzIjyi2wsD0FE4J8GQR0YqFJI9AoZbYpC9Tm6oRXjF0Q8C8PaMKg/Ap+JEIBNqPl+4NrzUC8gzhMiSV+368NF4ifhHb65JaUG1p0A0Et7jJcJtgi59d/SW4eApnUQKwy/hzaoCaqRJiq/sDi5b5HNEZeIRK3wSxnBU1kXwI+v9mnCLqMEdLz8s5zyDAzdrQv0ClsnLsLRsDRBFMUNzjizz28E8Ow6lzOn9lho0WtQ0sw8ReVoJl54J6tOdToOjvZD17DSj862ruQUlM3lI2wiZs9bL0XtZMdQ6GrINvw2mfeFf9cvCHePQ87i/Sy3QoAjcNit6ouBjDDIWeijd3P/FL9PLU+r40X/T3RBLQKtGIYNCIbplS+SvmYlDnFZK9ycv5zRDP8wTsoZ0VtDnHt4K/hRaPeOivGTfg8ssWtBgLEh9uERb7JJWXvkg5o56dRnONu2HeHOfI/eN4zmqnb8xiHmYdlxavQ3iSvdZdPsDq22ImqaB7rl/wejiRaCOoy4TESWgHV8BaTq4sEviRnbgCevBp0d16ua49FpNymilvYcH2v1q4wXm0OOQjC8rX6FNgqWvN07H8lZR3sSkd2LbDw53PX27nFvmMzr7wugyiE9zg3UwMKaqLS6QWoizHCA+NB5t1jmeYvWrOq8HKybRyjkhpVemUn4USfyixvBoX1s7AAWPAtmIviXhVbGIfdbmqxgO93EF4CVUcJAnpaDNBdqY4ZolqpjBkT95UElkFLb9ZeU+n7V2Hnhk2CWMr6qK21ilugSEBa8P+wExPtWQWUTccuYQt2Cz7lve7KxrV1UCPFmaV2SlGbsatH0UjQ/YVBbWSWsYIXaGIXn7ikG7ugufnuH8c/7wk9wOjNPPPoCWgkC5y7TrPViM8TrzHGEWakX4Krka8BbsNVIPXa8Tcd5wF7D9nH2JpPod/yXweWY3AK2l2cuNBcys
 EiL4yMZU
 dCItC8X+y+PY+rmnOi/1yPBP+MxXPOP52UzYkThyo/JDyt6jL7eYcCUE2/Yco8wso/VtDhw4s8J6jN0RrkhxeRgFIkeTDxB5dd9OqgyYqvaMvOxml5jA3L18iJd56VZgrX395NwS+cRKYkSJrHZULpmcbof72/IQ9pwXgu79sJCvTBuaRR1PzyBIZ2TlKFARWx7fOaiWlqos2AtllP0WmfqcWnqrp47w+ZyhIGFlBw6CmSld3tND24cGD7WJnnipyr5qJJr3ipBNt4FdW5WCD/7wWqCzW8vqIydTmzCDSEnF7V/iZS2r3odAO7tBNhfOqmUe6rGNZqjyeUkl7ZAKvIthaAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 23-09-26 22:09:26, Andreas Gruenbacher wrote:
> Jan,
> 
> it seems that we don't really need struct inodes_to_prune; see below.

Thanks. Nice simplifications! I'll fold them in.

								Honza

> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 7c69ef44619a..f8303af66fcd 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -938,12 +938,6 @@ void evict_inodes(struct super_block *sb)
>  }
>  EXPORT_SYMBOL_GPL(evict_inodes);
>  
> -struct inodes_to_prune {
> -	struct list_head freeable;
> -	struct list_head deferred;
> -	unsigned int deferred_count;
> -};
> -
>  /*
>   * Isolate the inode from the LRU in preparation for freeing it.
>   *
> @@ -958,7 +952,7 @@ struct inodes_to_prune {
>  static enum lru_status inode_lru_isolate(struct list_head *item,
>  		struct list_lru_one *lru, void *arg)
>  {
> -	struct inodes_to_prune *lists = arg;
> +	struct list_head *freeable = arg;
>  	struct inode	*inode = container_of(item, struct inode, i_lru);
>  
>  	/*
> @@ -1013,13 +1007,7 @@ static enum lru_status inode_lru_isolate(struct list_head *item,
>  
>  	WARN_ON(inode_state_read(inode) & I_NEW);
>  	inode_state_set(inode, I_FREEING);
> -	/* Inode will take long time to cleanup. Offload that to worker. */
> -	if (inode_state_read(inode) & I_DEFER_RECLAIM) {
> -		list_lru_isolate_move(lru, &inode->i_lru, &lists->deferred);
> -		lists->deferred_count++;
> -	} else {
> -		list_lru_isolate_move(lru, &inode->i_lru, &lists->freeable);
> -	}
> +	list_lru_isolate_move(lru, &inode->i_lru, freeable);
>  	spin_unlock(&inode->i_lock);
>  
>  	this_cpu_dec(nr_unused);
> @@ -1042,27 +1030,34 @@ static int get_deferred_sb_id(struct super_block *sb)
>   */
>  long prune_icache_sb(struct super_block *sb, struct shrink_control *sc)
>  {
> -	struct inodes_to_prune lists = {
> -		.freeable = LIST_HEAD_INIT(lists.freeable),
> -		.deferred = LIST_HEAD_INIT(lists.deferred),
> -	};
> -	long freed;
> +	struct inode *inode, *tmp;
> +	long freed, deferred = 0;
> +	LIST_HEAD(freeable);
>  
>  	freed = list_lru_shrink_walk(&sb->s_inode_lru, sc,
> -				     inode_lru_isolate, &lists);
> -	dispose_list(&lists.freeable);
> -	if (!list_empty(&lists.deferred)) {
> +				     inode_lru_isolate, &freeable);
> +
> +	list_for_each_entry_safe(inode, tmp, &freeable, i_lru) {
> +		if (inode_state_read(inode) & I_DEFER_RECLAIM) {
> +			deferred++;
> +			continue;
> +		}
> +		list_del_init(&inode->i_lru);
> +		evict(inode);
> +		cond_resched();
> +	}
> +
> +	if (!list_empty(&freeable)) {
>  		int id = get_deferred_sb_id(sb);
>  		int i, wake_count;
>  
>  		spin_lock(&deferred_reclaim.queues[id].lock);
> -		list_splice_tail(&lists.deferred,
> -				 &deferred_reclaim.queues[id].list);
> -		atomic_add(lists.deferred_count, &sb->s_deferred_reclaim_count);
> +		list_splice_tail(&freeable, &deferred_reclaim.queues[id].list);
> +		atomic_add(deferred, &sb->s_deferred_reclaim_count);
>  		spin_unlock(&deferred_reclaim.queues[id].lock);
>  
>  		/* Queue works to process inodes we've added to the list */
> -		wake_count = (lists.deferred_count + INODE_RECLAIM_BATCH_SIZE)
> +		wake_count = (deferred + INODE_RECLAIM_BATCH_SIZE)
>  						/ INODE_RECLAIM_BATCH_SIZE;
>  		if (wake_count > deferred_reclaim.workers)
>  			wake_count = deferred_reclaim.workers;
> -- 
> 2.55.0
> 
> Thanks,
> Andreas
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

