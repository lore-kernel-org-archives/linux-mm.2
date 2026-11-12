Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFACD606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 19:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TR+LDZyn
Received: by kanga.kvack.org (Postfix)
	id 68C5C6B05BD; Thu, 12 Nov 2026 14:00:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CEC6B05BE; Thu, 12 Nov 2026 14:00:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 57AA76B05BF; Thu, 12 Nov 2026 14:00:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25B056B05BD
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:00:56 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6E0CA8850
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:00:55 +0000 (UTC)
X-FDA: 85427384070.21.9DBE4C9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id DEB831C000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:00:53 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TR+LDZyn;
	spf=pass (imf20.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794510054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSazvgQX+Qmd6+1HZzV4RWQVLrPIoD/3reVpBuAHRK0=;
	b=QqBySHO/PCH9Dl1zc1Xx90VogkwFQBwoZ/0Ck5t8HUdiKbuRvVEnapNTvXmusyQdauwILo
	cENnGaTpY1TZzl8BYzkwBI3U+P+TklbYVXRJkbJmJ3/y1DivxlCBnH6+4oePOZbzXybtkh
	cznuoyEykpojUBDgMM6GVYpK/Bw/Bu0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794510054;
	b=8H1VFc3a74lU5Jaq6ajGulcppAsNBjDJO25B+WfjSXPoHSWTnIhdryEEQxjwRO0YRXjSuX
	NSeFHm9tZXCeMDWEuOpGf/Wqv0k0QSI2USKpQOmlDQq9S+kUQJQP0esu9Um1cmQikaMKno
	InRHfMuHYiYR7K5Q/PXDCC4X9z98Wnc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TR+LDZyn;
	spf=pass (imf20.hostedemail.com: domain of snitzer@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=snitzer@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AD0940F19;
	Thu, 12 Nov 2026 19:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD97B1F000C4;
	Thu, 12 Nov 2026 19:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794510052;
	bh=XSazvgQX+Qmd6+1HZzV4RWQVLrPIoD/3reVpBuAHRK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TR+LDZynPGXmBcvY97hLMt6nUSCCRxQxa1gWgXFLQqbta/zpUmWlUi1Gro7xFd39e
	 v5B31ZUrUpjiXBVWGjKyuFeHKvtJH/VPNmCcGRYuYuaQkltJ+LR9b48B/9BxbshEsb
	 mUaAS15IJ2UU0fO0bfkr8YQxsHtxjwdE1qtjzhnVtF9Z6ZefkPHK8LkBPd4H2k7Gra
	 aS/WHsiLN1kPqDVEs/czCQfC+SzQ456M7VKmS2A2vG6+uXbYy2QsnXAUEdV3fiN3m8
	 AqXp0SmXvV6IxF1Z/rq8n4BJ0k473ptZWS2J6I9CiN0iNpJHEAwwzIFU9TXSzFCLRN
	 14oNpXifxbwiw==
Date: Thu, 12 Nov 2026 14:00:51 -0500
From: Mike Snitzer <snitzer@kernel.org>
To: sashiko-bot@kernel.org
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>,
	Chuck Lever <cel@kernel.org>, Jeff Layton <jlayton@kernel.org>,
	Anna Schumaker <anna@kernel.org>
Subject: Re: [PATCH v11 4/7] mm: add folio_mark_dropbehind() to mark a folio
 dropbehind and account it
Message-ID: <avYM41SXJgRMWb2V@kernel.org>
References: <20261111015607.46338-1-snitzer@kernel.org>
 <20261111015607.46338-5-snitzer@kernel.org>
 <sashiko-outbox-210121@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-210121@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: dqxap77p5ptwxypnzphinogn1pgr3knn
X-Rspamd-Queue-Id: DEB831C000A
X-Rspam-User: 
X-HE-Tag: 1794510053-187586
X-HE-Meta: U2FsdGVkX1/NsMZHOG/ZUgVaNX1iv78whG1hqNh+MCQKS/oTGGhXhQNZgotC5C2bN1JJMYpaqMPKKBtSt8sm4ZMqolSL0MVzbFLTDn7/H13JHEDX/Jpy2JllUoRTmWIQeoWLV6gik2b7uOmxqi7IgCawMidYf05dIEb2o/k7wJXbn+6M3N9zY1n4zz0Si1tYNXxpjhZVgjFypp6r5seJ5VV5huK86Mb3AAJOBOxOO3TOtSBQIsWL1YlFeDLyZUBkVJXyETahDWHPblOtnhT4WIWYfHVfpmW/5LEAMDhnPmcHlUyFqlpN7zpX7Sg2zHms214deS1DQjC4zfrWfKXxXHVy1PVYE8RJZu+anzxHqBsy44pphD9MXwJi8s7ITWEJINyralJVkRePZdYdY/Vxl3AVhgz2AAyXoJbId2TxQbjgPQnYyXht6xOS43ii6Ny+7CozBPCxDvGuvy5b2jwZEZ0SLlDiIDH0icD8zhnfFmYFH8t9nMQsjzuB9xnuTqyvne6sT4gMZIC0ZRKc91OuSIsmUFZ1S4B5uGbD+kVDVEHbhcTwcWnDavrhRW0a6P1yMfHSp1ZDJZrx6xevG9bjZev8PR0LN81+EJhDe1BRGJWsSWsFkfmVlwO2fEdSL2njmxfh5muk1wNc/TXjDaRK6OjtMgeHWaEiHbP2brFSh546aOndn6XTmX3aVoxjHkc6MLZJCmS4q4ENRX7ikTuKt75VRuL3Lh/Zw2bCSR66U9w54Ce5ICsKzTQvO6Tficm2UG5SalHeE54C/CE0umzsR8A4VelY9h1Mp9Fbq6fXuKu38BqX8jWj9ZmES/Nust2X4oZrShSi3+1rZIAJIwARCziDr9p5G4y+IMC65Fx75BkAzFEzAxaSy9l91Fji7pCxoRC3ZU9xB6sqz0zJGjQr99NNvDcWmDY5USdvnc7jV/lkCVvycG8gQ5wL5XWoeReUKv+Gx60ITg0hdTKFPXS
 9MmjnULu
 /lsh6bHrkReqLZ8eicVIQCqFgo3J4hR4N20lZHuGEyhmvNxaRGsMEAq1UQghCxZcDgIBC436LIUrU/Gw9dJj1aVGjGBQwlpBd3ebl4d25Pq1NtHmRO8m5y/Grzuyx9NJtT/NaP9v493wBet7BxrUy2+ZQ9cUmU7OjykFt7PO4pwX9hfmgGJal3Zz1R++wzs035ihbGyJO568Cpv1GgvTn89XHwEKOAHtwpmRv6KuUCzyJoVtf3nSjUYgQ/mC9lGDhk/8LDzAizpZDqtqFx4ykS67+eUZPOYSbCaCfOuf59iIh9ioXrX1DMOri5EUrTGJDHStmLbzILB8oAOOgdQG8eIk0gjIUYTkro4bIdFv6ppsQgykf9NDoMeD4cMd42YLV55/hfkFmFm0kThxnDUUTsnC5gPco8xNoY8r4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 12, 2026 at 01:56:48AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm: double WB_DONTCACHE_DIRTY accounting in
>   folio_mark_dropbehind()
> --
> 
> commit 99c7597afc26e4465bf2ced6117179f389f8476b
> Author: Mike Snitzer <snitzer@kernel.org>
> 
> mm: add folio_mark_dropbehind() to mark a folio dropbehind and account it
> 
> This commit adds folio_mark_dropbehind() to set PG_dropbehind on a locked
> folio and account it in WB_DONTCACHE_DIRTY if the folio is already dirty.
> 
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index 98ce955404127..a54d0fbd37222 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -1654,6 +1654,38 @@ void folio_end_dropbehind(struct folio *folio)
> >  }
> >  EXPORT_SYMBOL_GPL(folio_end_dropbehind);
> >  
> > +/**
> > + * folio_mark_dropbehind - mark an existing folio dropbehind
> > + * @folio: the folio, locked by the caller
> > + *
> > + * Mark @folio so that the writeback that cleans it drops it.  If the folio
> > + * is already counted as dirty, which with the i_pages lock held means both
> > + * PG_dirty and the dirty tag are set, add it to WB_DONTCACHE_DIRTY so that
> > + * the clean that subtracts it leaves the counter balanced.
> > + */
> > +void folio_mark_dropbehind(struct folio *folio)
> > +{
> > +	struct address_space *mapping = folio->mapping;
> > +	unsigned long flags;
> > +
> > +	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
> > +
> > +	if (folio_test_dropbehind(folio))
> > +		return;
> > +	if (!mapping || !mapping_can_writeback(mapping)) {
> > +		folio_set_dropbehind(folio);
> > +		return;
> > +	}
> > +	xa_lock_irqsave(&mapping->i_pages, flags);
> > +	folio_set_dropbehind(folio);
> > +	if (folio_test_dirty(folio) &&
> > +	    xa_get_mark(&mapping->i_pages, folio->index, PAGECACHE_TAG_DIRTY))
> > +		wb_stat_mod(inode_to_wb(mapping->host), WB_DONTCACHE_DIRTY,
> > +			    folio_nr_pages(folio));
> > +	xa_unlock_irqrestore(&mapping->i_pages, flags);
> > +}
> > +EXPORT_SYMBOL_GPL(folio_mark_dropbehind);
> 
> [Severity: Medium]
> Can this double-account WB_DONTCACHE_DIRTY when racing with an unlocked
> dirtier on a folio that still has a leftover PAGECACHE_TAG_DIRTY mark?
> 
> __folio_cancel_dirty() clears PG_dirty and uncounts the folio without
> clearing PAGECACHE_TAG_DIRTY in mapping->i_pages.  Because callers such as
> zap_present_folio_ptes() -> folio_mark_dirty() -> filemap_dirty_folio()
> dirty mapped folios under the PTE lock without holding the folio lock,
> they can set PG_dirty before acquiring mapping->i_pages.xa_lock:
> 
> CPU0 (holds folio lock)           CPU1 (holds PTE lock)
> __folio_cancel_dirty(folio)
>   folio_test_clear_dirty(folio)
>   folio_account_cleaned(folio)
>   /* PAGECACHE_TAG_DIRTY stays set */
>                                   filemap_dirty_folio(mapping, folio)
>                                     folio_test_set_dirty(folio)
> folio_mark_dropbehind(folio)
>   xa_lock_irqsave(&mapping->i_pages)
>   folio_set_dropbehind(folio)
>   /* PG_dirty && TAG_DIRTY both set */
>   wb_stat_mod(..., WB_DONTCACHE_DIRTY, +nr)
>   xa_unlock_irqrestore(&mapping->i_pages)
>                                     __folio_mark_dirty(folio, mapping, ...)
>                                       xa_lock_irqsave(&mapping->i_pages)
>                                       folio_account_dirtied(folio, mapping)
>                                         if (folio_test_dropbehind(folio))
>                                           wb_stat_mod(...,
>                                             WB_DONTCACHE_DIRTY, +nr)
>                                             <-- counted twice
> 
> When the folio is later cleaned, folio_clear_dirty_for_io() or
> folio_account_cleaned() only subtracts folio_nr_pages(folio) once,
> leaving WB_DONTCACHE_DIRTY permanently inflated and causing
> wb_check_start_dontcache() to trigger extra writeback.
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261111015607.46338-1-snitzer@kernel.org?part=4

This is the third time sashiko has raised this race: as v9 3/6, as v10
4/7 and now as v11 4/7.

But I've finally fixed it, I now have a Kunit test that reproduces this
race and have verified it is now fixed with the following changes.

Will post v12 shortly.

folio_mark_dropbehind() will now return early for mapped folios, here is
the incremental change on v11 4/7 that I'll be folding into v12's 4/7:

  @@ -1651,7 +1651,8 @@ EXPORT_SYMBOL_GPL(folio_end_dropbehind);
    * Mark @folio so that the writeback that cleans it drops it.  If the folio
    * is already counted as dirty, which with the i_pages lock held means both
    * PG_dirty and the dirty tag are set, add it to WB_DONTCACHE_DIRTY so that
  - * the clean that subtracts it leaves the counter balanced.
  + * the clean that subtracts it leaves the counter balanced.  A mapped folio
  + * is left unmarked.
    */
   void folio_mark_dropbehind(struct folio *folio)
   {
  @@ -1662,6 +1663,15 @@ void folio_mark_dropbehind(struct folio *folio)

        if (folio_test_dropbehind(folio))
                return;
  +     /*
  +      * Through its page table, a mapped folio can be dirtied without the
  +      * folio lock, and PG_dirty set before the folio is counted: with a
  +      * stale dirty tag it would be counted twice.  The folio lock keeps
  +      * an unmapped folio unmapped.  filemap_end_dropbehind() does not drop
  +      * a mapped folio either.
  +      */
  +     if (folio_mapped(folio))
  +             return;
        if (!mapping || !mapping_can_writeback(mapping)) {
                folio_set_dropbehind(folio);
                return;

And for 6/7, filemap_dontcache_edge_complete() will skip every mapped
folio -- not just clean ones.  Incremental that'll be folded into v12's 6/7:

  @@ -1757,8 +1767,8 @@ EXPORT_SYMBOL_GPL(filemap_dontcache_edge_completes);
    * @pos: any byte offset within the folio
    *
    * Call once the write, and any sync of it, is done.  A dirty folio is marked
  - * for the writeback that cleans it, and a clean unmapped folio is dropped now.
  - * A clean mapped folio stays cached, as filemap_end_dropbehind() leaves it.
  + * for the writeback that cleans it, and a clean folio is dropped now.  A
  + * mapped folio stays cached, as folio_mark_dropbehind() leaves it.
    */
   void filemap_dontcache_edge_complete(struct address_space *mapping, loff_t pos)
   {
  @@ -1773,10 +1783,12 @@ void filemap_dontcache_edge_complete(struct address_space *mapping, loff_t pos)
                goto out;
        /* Writeback in flight was submitted unmarked and would not drop it. */
        folio_wait_writeback(folio);
  +     if (folio_mapped(folio))
  +             goto out;
        if (folio_test_dirty(folio)) {
                folio_mark_dropbehind(folio);
                kick = true;
  -     } else if (!folio_mapped(folio)) {
  +     } else {
                /*
                 * Drop it now, unmarked: a mark cleared outside the i_pages
                 * lock could miss a store that counts the folio.

Thanks,
Mike

