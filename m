Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82772D58E7A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9A9F6B0005; Mon,  2 Mar 2026 04:11:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E48456B008C; Mon,  2 Mar 2026 04:11:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00156B0092; Mon,  2 Mar 2026 04:11:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BDB296B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:11:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4F744C31F2
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:11:32 +0000 (UTC)
X-FDA: 84500554824.05.51D5F28
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id C426A40003
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:11:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Gy3YI4c/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vKrhrjxe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bOOHWhwH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Jl1vtw9k;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772442690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAnmRLMm8a2fR89ZeXIizBJSqoFgJNl3qhftcyIkWPs=;
	b=oQrD2/ZQxTgRl8LWjTXYYE6UM+70nwUsXXxl+6lE4HBxMKvqZIC+YeaP8cZ/mFyVeInr1K
	xqUe3BToc85EC/ZETSn6czgCjmVnnP5IK4Oz+FdgbkQ0SIimwD/LoHLUl8Af7Sm940H64O
	D7Ss+innx+CGV4gtb0ZUcbWwm1rNNpk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772442690; a=rsa-sha256;
	cv=none;
	b=ihZdz1CRVkh1eJor5Sn/t9b47mfJU1RipRxCmYPP3rsyjeJQEwXLuq8PvsNO25+utvNLh/
	0eHNVNE5yr4zlYebzec6toC75L1tTc4i3GO25+PJgd32FxftWbTjaZSqa5f9uQwqR8CrVO
	PjsBPNUrK3YtYv0k9+AILC37avcctYc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Gy3YI4c/";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vKrhrjxe;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=bOOHWhwH;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Jl1vtw9k;
	spf=pass (imf11.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D28C83E847;
	Mon,  2 Mar 2026 09:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772442688; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vAnmRLMm8a2fR89ZeXIizBJSqoFgJNl3qhftcyIkWPs=;
	b=Gy3YI4c/TA5IPlDYK/sR9YAq7mKf4gdDPZXpcrAycscCVHGhZ+MIbmoRz60ax+tZLE6VNI
	VuiiOlNONvwt+fCCPsPOSpleSdUf6opje+n8qn7i+dUCXfDcdXCAwXLnRgdy+enHoNE6nD
	O6ylxNNedFo1d/HFn8wt+Z8uspK4e3o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772442688;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vAnmRLMm8a2fR89ZeXIizBJSqoFgJNl3qhftcyIkWPs=;
	b=vKrhrjxeQ7Nv+IrOBKPcHIu8uF3ffMnbXQm2oJwIme8zxNGosBGXgsaQ69xARhqGjcGr9c
	tb9x1hg/rmPBI9Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1772442687; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vAnmRLMm8a2fR89ZeXIizBJSqoFgJNl3qhftcyIkWPs=;
	b=bOOHWhwHHl7EkUzBk5e9XNf9DdNQygJO1DSqd4VFEq4JKe2xShPDpedsnCxTtWye42Ukhd
	qQ68F546vbiZObAyu3DiS0PBeIcSUMzNAsQyDKUP5EHxNEPsh4pu3raM4i3P6B1QeW7cm9
	c6FZAsnUXJ1tsgyMhRFZr08ew6PPUKw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1772442687;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=vAnmRLMm8a2fR89ZeXIizBJSqoFgJNl3qhftcyIkWPs=;
	b=Jl1vtw9kkBwXJbPBFO2LkD5OfmmoruLfHAjXA1LmOzHqVpqBGmp86yyDD/OcXa1dS3HlXl
	GJnbiyyY4xwSBHCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A56403EA69;
	Mon,  2 Mar 2026 09:11:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id Rp1eKD9UpWm/XgAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 02 Mar 2026 09:11:27 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 56F97A0AAA; Mon,  2 Mar 2026 10:11:19 +0100 (CET)
Date: Mon, 2 Mar 2026 10:11:19 +0100
From: Jan Kara <jack@suse.cz>
To: Tal Zussman <tz2294@columbia.edu>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH RFC v3 1/2] filemap: defer dropbehind invalidation from
 IRQ context
Message-ID: <wen63cjbk3k54mjzgw7zftsuze6bzxmdk5u5wdjabzdiqg645k@67666k5lrevh>
References: <20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu>
 <20260227-blk-dontcache-v3-1-cd309ccd5868@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260227-blk-dontcache-v3-1-cd309ccd5868@columbia.edu>
X-Stat-Signature: tqhawu1tquhafcsdb18w8ttiawos8u1c
X-Rspam-User: 
X-Rspamd-Queue-Id: C426A40003
X-Rspamd-Server: rspam12
X-HE-Tag: 1772442689-362402
X-HE-Meta: U2FsdGVkX188lcxBVWy/+OaAui8vJxuh66LiNCnBSuevKZWhpkFkvOFtK0kIedNLsMKIqmUHMqjsn6Wgo1KwBiEPrMcb4J1b47T4o3aJ2N1vd04StcR32vH0mRLDzC+JXaDIT/LnaxpLcUNnmXvSZG4bcqUg8+4iGJdRgIa31B6lqBpYscYzl3cEg3TwvsQs9E3Co4s+LABEeiB3+2P7+txvSn4Yzj/QcXmSJ5JZDqIu8muD9pUgSz7wO0G5+VSNTgYLIggQbrv0/jqtQrTilqb6BSBrHAy/KHe1Jj6JsnIgZ/djcv5Lc2/RCv06gbuAve8FaUSIikiLy/tZut/cHdbBserRgY8ZG6X3kyPUXKodYF1MD1U1vizyg5zAXCGgsUBMHOK4JpDkPHxbawxekAaDkdA2lgd4bK4YTPjEkcuArjcEcaUz0l5bAen0nlfgbiu9EqQ8jqVxnFhskuQhXQ5fz0HaTY8gflAXqsBIqRoratMM9llFXwkOdZuw6rGNCcpv22sUX6oyo7/q4CQY0RP48uqR3T5LBIayN5ebR9lA3SoCzvLVlFE0uASIaxUyGis5Lzyg/9bJMpw6nPG1MK4Gq/5VaQ4R4kElzfeC28dz+f7fVTxyXyN+RHSOT2jnZZG6lfBhEeJoaWuN+os12fcFbArvWvCl7DKJpxOhaiw2pfwy8o4i39ea7sNMsNMLBvcM4qyLUgh4cF6a9XfeUYWWiCgvT9W5R+qsIgTtWOmKGZOos47kQkKU6svZ1nZt9BNKzrK/y3q6aBW6giDMb97zmgLo0ryxURN+hRQ0HcpEfI2jEsfDQtUbzCxE3jYo+cKe6a1L5XCTVuFym+vwlc6PaMpvRQWdv6F9pjXrtPm7aYOTawYUSWv7o/s8E9UbxSitZZ8kq8oq5JrJghJMko8TQSjXt+rrbl0JeOHOgYETZLMYT5iUoLPSx8cD2fyVmQtPYR6eRERpHaE3HiN
 Pg0/8Lv0
 jTlQVURN7SIt7orE7ERy4cOI37jMajHO+1pUDlYiApA56aKj753iGRXs9p86vOeL/DV+Tvwi4HR088P7Gx3iCps10rfOZPYfcF7ZlAFkbvWSUdfJ3ZbZySLk7cAsE15W+4cuSfVRcbQNoySRtzG2rTtCIkoiWi0NYds2N2Pl2AlMDMlN3BF20GgtvLBrXVXzUGK38Zn5pJUaYDv3S2xRRL8JTnLJtQ1qpWGLIqHHEMc3EGm8OFwqCKHLSr/DfPZVttyIaxqFXw5OmgrZJKZpHy9X+PBqCEa24e2z5hc2po1Vz40bkoZf4aF0eeZ4PYlxtX/Kog4SS6eik590r5TWMd1d1kg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 27-02-26 11:41:07, Tal Zussman wrote:
> folio_end_dropbehind() is called from folio_end_writeback(), which can
> run in IRQ context through buffer_head completion.
> 
> Previously, when folio_end_dropbehind() detected !in_task(), it skipped
> the invalidation entirely. This meant that folios marked for dropbehind
> via RWF_DONTCACHE would remain in the page cache after writeback when
> completed from IRQ context, defeating the purpose of using it.
> 
> Fix this by adding folio_end_dropbehind_irq() which defers the
> invalidation to a workqueue. The folio is added to a per-cpu folio_batch
> protected by a local_lock, and a work item pinned to that CPU drains the
> batch. folio_end_writeback() dispatches between the task and IRQ paths
> based on in_task().
> 
> A CPU hotplug dead callback drains any remaining folios from the
> departing CPU's batch to avoid leaking folio references.
> 
> This unblocks enabling RWF_DONTCACHE for block devices and other
> buffer_head-based I/O.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Thanks for the patch. Couple of comments below:

> @@ -1613,26 +1617,131 @@ static void filemap_end_dropbehind(struct folio *folio)
>   * If folio was marked as dropbehind, then pages should be dropped when writeback
>   * completes. Do that now. If we fail, it's likely because of a big folio -
>   * just reset dropbehind for that case and latter completions should invalidate.
> + *
> + * When called from IRQ context (e.g. buffer_head completion), we cannot lock
> + * the folio and invalidate. Defer to a workqueue so that callers like
> + * end_buffer_async_write() that complete in IRQ context still get their folios
> + * pruned.
> + */
> +struct dropbehind_batch {
> +	local_lock_t lock_irq;
> +	struct folio_batch fbatch;
> +	struct work_struct work;
> +};
> +
> +static DEFINE_PER_CPU(struct dropbehind_batch, dropbehind_batch) = {
> +	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
> +};
> +
> +static void dropbehind_work_fn(struct work_struct *w)
> +{
> +	struct dropbehind_batch *db_batch;
> +	struct folio_batch fbatch;
> +
> +again:
> +	local_lock_irq(&dropbehind_batch.lock_irq);
> +	db_batch = this_cpu_ptr(&dropbehind_batch);
> +	fbatch = db_batch->fbatch;
> +	folio_batch_reinit(&db_batch->fbatch);
> +	local_unlock_irq(&dropbehind_batch.lock_irq);
> +
> +	for (int i = 0; i < folio_batch_count(&fbatch); i++) {
> +		struct folio *folio = fbatch.folios[i];
> +
> +		if (folio_trylock(folio)) {
> +			filemap_end_dropbehind(folio);
> +			folio_unlock(folio);
> +		}
> +		folio_put(folio);
> +	}

This logic of take folio batch and call filemap_end_dropbehind() for each
folio repeats twice in this patch - perhaps we can factor it out into a
helper function fbatch_end_dropbehind()?

> +
> +	/* Drain folios that were added while we were processing. */
> +	local_lock_irq(&dropbehind_batch.lock_irq);
> +	if (folio_batch_count(&db_batch->fbatch)) {
> +		local_unlock_irq(&dropbehind_batch.lock_irq);
> +		goto again;

I'm somewhat nervous from this potentially unbounded loop if someone is
able to feed folios into db_batch fast enough. That could hog the CPU for
quite a long time causing all sorts of interesting effects. If nothing else
we should abort this loop if need_resched() is true.

> +	}
> +	local_unlock_irq(&dropbehind_batch.lock_irq);
> +}
> +
> +/*
> + * Drain a dead CPU's dropbehind batch. The CPU is already dead so no
> + * locking is needed.
> + */
> +void dropbehind_drain_cpu(int cpu)
> +{
> +	struct dropbehind_batch *db_batch = per_cpu_ptr(&dropbehind_batch, cpu);
> +	struct folio_batch *fbatch = &db_batch->fbatch;
> +
> +	for (int i = 0; i < folio_batch_count(fbatch); i++) {
> +		struct folio *folio = fbatch->folios[i];
> +
> +		if (folio_trylock(folio)) {
> +			filemap_end_dropbehind(folio);
> +			folio_unlock(folio);
> +		}
> +		folio_put(folio);
> +	}
> +	folio_batch_reinit(fbatch);
> +}
> +
> +static void __init dropbehind_init(void)
> +{
> +	int cpu;
> +
> +	for_each_possible_cpu(cpu) {
> +		struct dropbehind_batch *db_batch = per_cpu_ptr(&dropbehind_batch, cpu);
> +
> +		folio_batch_init(&db_batch->fbatch);
> +		INIT_WORK(&db_batch->work, dropbehind_work_fn);
> +	}
> +}
> +
> +/*
> + * Must be called from task context. Use folio_end_dropbehind_irq() for
> + * IRQ context (e.g. buffer_head completion).
>   */
>  void folio_end_dropbehind(struct folio *folio)
>  {
>  	if (!folio_test_dropbehind(folio))
>  		return;
>  
> -	/*
> -	 * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
> -	 * but can happen if normal writeback just happens to find dirty folios
> -	 * that were created as part of uncached writeback, and that writeback
> -	 * would otherwise not need non-IRQ handling. Just skip the
> -	 * invalidation in that case.
> -	 */
> -	if (in_task() && folio_trylock(folio)) {
> +	if (folio_trylock(folio)) {
>  		filemap_end_dropbehind(folio);
>  		folio_unlock(folio);
>  	}
>  }
>  EXPORT_SYMBOL_GPL(folio_end_dropbehind);
>  
> +/*
> + * In IRQ context we cannot lock the folio or call into the invalidation
> + * path. Defer to a workqueue. This happens for buffer_head-based writeback
> + * which runs from bio IRQ context.
> + */
> +static void folio_end_dropbehind_irq(struct folio *folio)
> +{
> +	struct dropbehind_batch *db_batch;
> +	unsigned long flags;
> +
> +	if (!folio_test_dropbehind(folio))
> +		return;
> +
> +	local_lock_irqsave(&dropbehind_batch.lock_irq, flags);
> +	db_batch = this_cpu_ptr(&dropbehind_batch);
> +
> +	/* If there is no space in the folio_batch, skip the invalidation. */
> +	if (!folio_batch_space(&db_batch->fbatch)) {
> +		local_unlock_irqrestore(&dropbehind_batch.lock_irq, flags);
> +		return;

Folio batches are relatively small (31 folios). With 4k folios it is very
easy to overflow the batch with a single IO completion. Large folios will
obviously make this less likely but I'm not sure reasonable working of
dropbehind should be dependent on large folios... Not sure how to best
address this though. We could use larger batches but that would mean using
our own array of folios instead of folio_batch.

> +	}
> +
> +	folio_get(folio);
> +	folio_batch_add(&db_batch->fbatch, folio);
> +	local_unlock_irqrestore(&dropbehind_batch.lock_irq, flags);
> +
> +	schedule_work_on(smp_processor_id(), &db_batch->work);
> +}
> +
>  /**
>   * folio_end_writeback_no_dropbehind - End writeback against a folio.
>   * @folio: The folio.
> @@ -1685,7 +1794,10 @@ void folio_end_writeback(struct folio *folio)
>  	 */
>  	folio_get(folio);
>  	folio_end_writeback_no_dropbehind(folio);
> -	folio_end_dropbehind(folio);
> +	if (in_task())
> +		folio_end_dropbehind(folio);
> +	else
> +		folio_end_dropbehind_irq(folio);

I think it would be more elegant to have folio_end_dropbehind() which based
on context decides whether to offload to workqueue or not. Because
folio_end_dropbehind() is never safe in irq context so I don't think it
makes sense to ever give users possibility to call it in wrong context.

>  	folio_put(folio);
>  }
>  EXPORT_SYMBOL(folio_end_writeback);

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

