Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1838606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 17:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Q45v8UTn;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YYqSy+wZ;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Q45v8UTn;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=YYqSy+wZ
Received: by kanga.kvack.org (Postfix)
	id 89C886B05B2; Fri, 27 Nov 2026 12:44:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84CB66B05B3; Fri, 27 Nov 2026 12:44:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763146B05B4; Fri, 27 Nov 2026 12:44:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A18B6B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 12:44:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A900D1C399B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:44:11 +0000 (UTC)
X-FDA: 85481622702.10.8774B83
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5EB32120006
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:44:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q45v8UTn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YYqSy+wZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q45v8UTn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YYqSy+wZ;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795801449;
	b=Wg0qOEefmlTe/IjB00MwKbNUSLSko5RIoYNIY6vjISTbUg+3FttIP0HK/i0zkfuZ/Qnoe2
	vFwfB1GN3yKlppe9U5r41HzFVwybrZjt7fSIA1RnmweH5JO50gCM3IKrdPLAKAY0y24MpO
	cyDEFSbdltyR93GJAuc8Nvly1Gtc52s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795801449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Egyy1vePPhNOEn0FzYth/QHCU9MBJzPS/xb+Rlwtu4=;
	b=z9NVNbiFkRasqgiDyWOBuchT3Oux4z59nbwhMme4yR1Rb21Te3kx/x8hNEWfGdn44uOuHF
	ZVnMPgbNEY6MFomKLXD1H/Wss0OeQT1WKrWP5ukN5SDyRWAwWHTi7WXryKaQJefCmNRDXT
	nImUGW2lVZ+B36Exb0uKZ5YOqS79J8U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q45v8UTn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YYqSy+wZ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Q45v8UTn;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=YYqSy+wZ;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 32A96229B5;
	Fri, 27 Nov 2026 17:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795801448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Egyy1vePPhNOEn0FzYth/QHCU9MBJzPS/xb+Rlwtu4=;
	b=Q45v8UTn/pqG57nIwZvWRw7wFUKaevlaeLwlJTvg6Y2kKjyy9CwrpGpoO6ATQhmN6LUXif
	IqmvRsgbSwwGn/IT8xbeGanHnHFgjoi2B9tn6lTlSEWGbKKB1YVLoviKKLPnyjSLwqb3BB
	P4VbDkmtsF49MOSsKRWsw+hAVZ+adVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795801448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Egyy1vePPhNOEn0FzYth/QHCU9MBJzPS/xb+Rlwtu4=;
	b=YYqSy+wZkDUX+WWvdhqlrP5WaBEaNIYgupecNZmlFe5pBjV4rnfKHFKFFW3STL+yYYtCyf
	Q9X296hyctV9bACQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795801448; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Egyy1vePPhNOEn0FzYth/QHCU9MBJzPS/xb+Rlwtu4=;
	b=Q45v8UTn/pqG57nIwZvWRw7wFUKaevlaeLwlJTvg6Y2kKjyy9CwrpGpoO6ATQhmN6LUXif
	IqmvRsgbSwwGn/IT8xbeGanHnHFgjoi2B9tn6lTlSEWGbKKB1YVLoviKKLPnyjSLwqb3BB
	P4VbDkmtsF49MOSsKRWsw+hAVZ+adVo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795801448;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7Egyy1vePPhNOEn0FzYth/QHCU9MBJzPS/xb+Rlwtu4=;
	b=YYqSy+wZkDUX+WWvdhqlrP5WaBEaNIYgupecNZmlFe5pBjV4rnfKHFKFFW3STL+yYYtCyf
	Q9X296hyctV9bACQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0938C134E8;
	Fri, 27 Nov 2026 17:44:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VA8PNmfBCWu0HAAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Nov 2026 17:44:08 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 8A7A5510C7; Fri, 27 Nov 2026 18:44:03 +0100 (CET)
Date: Fri, 27 Nov 2026 18:44:03 +0100
From: Jan Kara <jack@suse.cz>
To: sashiko-reviews@lists.linux.dev
Cc: Jan Kara <jack@suse.cz>, Christian Brauner <brauner@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, Mikhail Rudenko <xyzzy@yandex-team.ru>, 
	Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH v2 6/8] fs: Add throttling to deferred inode reclaim
Message-ID: <a3zxiwdovphr2vywf3kficx5hgz22log5xdbl3lupqinkzozd4@ggvcd7ux3vro>
References: <20261124113450.3451-1-jack@suse.cz>
 <20261124115850.3512-14-jack@suse.cz>
 <sashiko-outbox-233315@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <sashiko-outbox-233315@kernel.org>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspam-User:
X-Stat-Signature: cxd7x8f9zpcb6aha1xizxas4x758b17z
X-Rspamd-Queue-Id: 5EB32120006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795801449-389919
X-HE-Meta: U2FsdGVkX19cU7iS/UQNBLmwD5qYfsgqjDzPKbdJ8nud3OOLqz4QkaseKhHT530SLVS7HLAP1cvbjqjumdufWg4uLezOMmeHhbJsPfDFzXRHws/UtYRZtpxvuGuP12xiWfojxPaHTYfENhmoeSjtEZZq0HMDBl1oOu/8R5Sf5ePxpJmgspktF430HCk9JH/OzD6H1Dm2Hb39ys4u4zomU0UB/xfjLO1WoPDsqXKzIbe2GVyX31Kr62svjM7Y15ZgKKonvLClErsCbEHW/26xKiarn5HIDo6faw8xQctFj44v4DCsMde36QurBHc1hq5ptZNO24l4MulWW5UZRdJ+CCKJhuYew/EN+/LG1KHk4kYaPz74QVTmeVbEOjQgGHY8UKLp59wAhLczaeH9IIuS1y4VqBgEbAfnopVh3/qXGPEB3tCe6X6aRAQ2hI0DAvvICLLPgK9ONX2Oyzqti3yOSNsrhqdHVPM8sl1qOOv9VethYrOenk5agkqtLtxFZkkzl6M3a9CDJ/UpqLLPY23p7hu90f8JsFjsTBTYT2DbOyc2Z0BHDKekXBH9UH+Wdxzcq0XqWquPxPSYHAn6NMIIadXYU9scEipU9o1LL6PSQ0cbsgtkL0QDn+xZ9u9h+URUYY6E/EJeJb4blqFOml/nnZqZQm1ytr9LjVvWNOj3QOKM3C8/q0ZZSe60TZSuIbw7dExyY7pUKSs98jEjCOcz6tcM84Id7wToq+vwMgUGfhhACHw6CFNGwbN8vfYhzdMGkVvhbx17nnyEtHpuXmzA5pLAZEfJ3WcKUJkCaAdV1eprXTI8yUmmIwnU/MIS47TIC2TIjnvuPljmc3FxqyzGfaygNBo1iPsKmq691ctIkfQVCftwNszhBFEK0ygnaTZei8kLDOvSx1w2kQW/TdK+wYphZvTGdQTvqCcBVhUhLjK9RZhKRDv0nR7FCQZyV0JAvTcJ//SDWLL/z0OoV9t
 OXormYgX
 D4T+sG90aBj6wfYyYiWIgAixrmL1A5COn3rte6LwInMxumIhgoNQYBbd/tn8l7YpKQRYdtlOXB/MmfsgAbSITG/JO0in31Zr4JWscbuEd6OHkjLtMGD0TqmL2yYQ45KXBFUAlREc04jB/w+EcEKztZVFoiSOZmCJsJ50IiRbFZftdln1sQJrqrhWy3UKcA7l892BxZQB/EgHUiFHTUBBU7hZbt9p94SF68luacIX5LuCN1OmXkwyxP2w4j77eLp/JinnjokstW2rkyD8tRe+wesU42O9UgO1H2KaZxBH+eq5RNFLMEyryDwYnwzIre3sTJg8TtPl1JIImnaENeLHEmNhne6B3aVsWozg2PX0swv0j5L6qY1LTyepqyVoI7J8OHtDfQ7Ap1xS6YAIlxDv06jXI3i+ju0FQ9c2BCh0elzD4F6SX5ky4Oq1M8CqIzuwXgf366KAqTDnwSW0pfe/xHeVj+aZ7Gp+WpsYlS6FZPWy9HxrP7nNioAklrkgX6XtNKcuD7UXclRO2hFWWI+iq15NXeM4Vtc0ybQlC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 12:00:05, sashiko-bot@kernel.org wrote:
> > +	len = atomic_read(&sb->s_deferred_reclaim_count);
> > +	if (len > INODE_DEFERRED_RECLAIM_LIMIT) {
> > +		u64 delay = READ_ONCE(sb->s_deferred_reclaim_delay);
> > +		struct deferred_reclaim_delay *dd;
> > +
> > +		if (!delay)
> > +			return;
> > +
> > +		dd = kmalloc_obj(*dd, GFP_NOFS | __GFP_NORETRY);
> > +		/*
> > +		 * If the allocation failed, don't bother. Throttling is
> > +		 * approximate anyway and next time we'll throttle more.
> > +		 */
> > +		if (!dd)
> > +			return;
> 
> [Severity: Low]
> Since allocation failure is intentionally ignored here, should this include
> __GFP_NOWARN so a failed slab expansion under memory pressure does not trigger
> warn_alloc() and slab_out_of_memory() splats in dmesg?  Also, MM guidelines
> prefer scoped memalloc_nofs_save()/memalloc_nofs_restore() (or
> GFP_NOWAIT | __GFP_NOWARN) over passing GFP_NOFS directly.

Not really, I think we want a warning here if allocation fails.

> > +
> > +		/*
> > +		 * Scale the delay based on how much we exceed the limit. Wait
> > +		 * at most 4x as long as estimated time to reclaim the inode.
> > +		 */
> > +		len = min(len, 5 * INODE_DEFERRED_RECLAIM_LIMIT);
> > +		delay = div_u64(delay * (len - INODE_DEFERRED_RECLAIM_LIMIT),
> > +				INODE_DEFERRED_RECLAIM_LIMIT);
> 
> [Severity: Medium]
> Does passing nsecs_to_jiffies(dd->delay) to schedule_timeout_killable() stall
> tasks for a full jiffy whenever the scaled nanosecond delay is sub-jiffy or 0?
> 
> throttle_inode_deferred_reclaim() checks !delay and allocates dd before
> scaling delay down by (len - 8192) / 8192, so a small s_deferred_reclaim_delay
> near the limit scales to 0 ns and still queues deferred_delay_work().
> Even when the scaled delay is non-zero, any sub-jiffy value is truncated to
> 0 jiffies by nsecs_to_jiffies(), and schedule_timeout(0) does not return
> immediately: it arms a timer for jiffies + 1 and sleeps until the next timer
> tick (1 to 10 ms depending on HZ), defeating the proportional ramp-up.
> 
> Scaling delay before checking !delay and allocating dd, and sleeping with
> schedule_hrtimeout() in deferred_delay_work(), would avoid queuing 0-ns waits
> and preserve sub-jiffy delays.

Yes, I'll move the condition to avoid pointless schedule().

> > diff --git a/include/trace/events/writeback.h b/include/trace/events/writeback.h
> > index c2a5b492a71a5..d371d1112843f 100644
> > --- a/include/trace/events/writeback.h
> > +++ b/include/trace/events/writeback.h
> [ ... ]
> > +TRACE_EVENT(mark_inode_reclaim_deferred_throttle,
> > +	TP_PROTO(struct inode *inode, unsigned int len, u64 delay),
> > +	TP_ARGS(inode, len, delay),
> 
> [Severity: Low]
> This isn't a bug, but tracepoint names normally follow the subsystem_event
> convention (such as inode_reclaim_throttle, matching inode_reclaim_update_stat
> above) rather than starting with the verb mark_.

No. The trace point is named after the function where it is.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

