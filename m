Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A69F860A260B
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wERo8I2l;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8HWqkJop;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wERo8I2l;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=8HWqkJop
Received: by kanga.kvack.org (Postfix)
	id B0F516B0690; Tue, 27 Oct 2026 06:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A98FB6B0691; Tue, 27 Oct 2026 06:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 987E46B0692; Tue, 27 Oct 2026 06:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBE76B0690
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:30:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 057AC1C437F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:30:46 +0000 (UTC)
X-FDA: 85368037692.23.7BA8122
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf18.hostedemail.com (Postfix) with ESMTP id D1D651C0004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:30:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wERo8I2l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8HWqkJop;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wERo8I2l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8HWqkJop;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793097044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CfsimHztCruO2Wg5kbGqSZxP4HQYNhZ0++xp8V5kraE=;
	b=iyLKwJjeshl16SWI5vQPTrG0TOBqhOX9mvKdFkORSBpgltDuYkKLLS96InQWYor7jmRlo2
	GW4rygSMB8y05+Ls+8iNW8B0HPe14I6W7i6rmnayU0Fum9ZtrXLsPjNJ1gCst2zFD46kmz
	BGJNGe9lzE8wWUY05Y616Vv++VkS+k4=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wERo8I2l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8HWqkJop;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wERo8I2l;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=8HWqkJop;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf18.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793097044;
	b=xpOIMQv3C0QVTmgEhozCXFs06LoDs14FTHcmTbMOOzx0PwOnrslQ1L/qzyncQ0hbjzP+6Q
	px4H7lINuy6v76GAzsphL3eDiSmiHlSAUJa5B1pM6aecrTXwlywNr1HzbTIfPbEMBZGGPX
	2TcfYfoV+Igzp864uII200e+RZmRh5M=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 371831F7E9;
	Tue, 27 Oct 2026 10:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793097042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CfsimHztCruO2Wg5kbGqSZxP4HQYNhZ0++xp8V5kraE=;
	b=wERo8I2l80Tbc7zJzgDVpUtP8F4hNH5xHai1+6lKUZPKwS4vDftwCXE/JroFhBufP60rJ0
	B/oCs7boHDjA0SGhsKWWb1V9o5NDenKsZHKq1syJC63/jbUrF6n4/ZPg19Hl/dxyjMZeqJ
	xNmRFjrv1LVl1hvgYjA99EMcOdJD7+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793097042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CfsimHztCruO2Wg5kbGqSZxP4HQYNhZ0++xp8V5kraE=;
	b=8HWqkJopKnjpTl2rDCb/W7qDTjgk+JL8glEff3Y7OL45XtiNrvHKtDVQBZvE1sSYQ2NkeN
	PF5hAv8OYKoavEDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793097042; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CfsimHztCruO2Wg5kbGqSZxP4HQYNhZ0++xp8V5kraE=;
	b=wERo8I2l80Tbc7zJzgDVpUtP8F4hNH5xHai1+6lKUZPKwS4vDftwCXE/JroFhBufP60rJ0
	B/oCs7boHDjA0SGhsKWWb1V9o5NDenKsZHKq1syJC63/jbUrF6n4/ZPg19Hl/dxyjMZeqJ
	xNmRFjrv1LVl1hvgYjA99EMcOdJD7+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793097042;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=CfsimHztCruO2Wg5kbGqSZxP4HQYNhZ0++xp8V5kraE=;
	b=8HWqkJopKnjpTl2rDCb/W7qDTjgk+JL8glEff3Y7OL45XtiNrvHKtDVQBZvE1sSYQ2NkeN
	PF5hAv8OYKoavEDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 507801321C;
	Tue, 27 Oct 2026 10:30:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /jBeBlB94GqiEQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 10:30:40 +0000
Date: Tue, 27 Oct 2026 10:30:34 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, 
	jack@suse.cz, djwong@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, hch@lst.de, ngocthang2710.1999@gmail.com, 
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, stable@vger.kernel.org
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in
 collapse_file()
Message-ID: <auB9CHQh0acOxXpZ@pedro-suse.tail5790ac.ts.net>
References: <at9_1mf2kLqMX8-W@pedro-suse.tail5790ac.ts.net>
 <20261027025507.59451-1-lance.yang@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027025507.59451-1-lance.yang@linux.dev>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Rspamd-Queue-Id: D1D651C0004
X-Stat-Signature: fam5baxzwxc1gtfik5fbsuq36zx1sgrh
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793097043-335525
X-HE-Meta: U2FsdGVkX18M657zCPF+ZTO6tv4y2te+rj2Rbet/ZNkmSx3/BMV8HYX4US7sgLwupcPbai4LMUD4E4D8UYdGBab3BIbZ5rDLgbCL1UEd9dREIprY71M1/NYbxF0xx9P8WjFJI7WsI3IiiKwGbQ1WMPYXSW4cI8hj2u2TqIaYawA+aLIXJoafpHFJSTpGW8xCKMAFwuYKxuqMoxxp4Wp5PWv7JiBKhXRXfNQbf1F1npXRaW5oNqUzASkvh/R/d00uVFzDgiJsTw0iWX+cKxfzwQPGpSOSgJEIb7vu3sJtwsvSQQ3rnbWSTbaRoGEI/6L1xrroyWLTrvbwotgSsN7XmajnYUd3hCcyG6ZeLt2ewls9OY0iCflfYs0ZJfNCxPaIoG/0dNOFMtsYoiSqwmZt5HppzYDDb9dXjlwJAsTY3aJ8B1ZJGpjgz685+SuGC6uD+yTXxPw9xsPiJ8uttR1F0pU2fm5w7sXyXt9WzohbsPnCMpd0gb6FTy0FeZzElqaz43RrTZIbsZpnxHNjQp+LfGobiIfkGvmP0vxVxdkQ2xWVYkqKQfDVt86hxCx56J1DZV9ZoiobuV1f8g0zn6T3aPsoUBC8xYY/Yr7NizAjckwERi4lOpIRM6V5yGL5YuM98sZ/YTzOWwGllbKR6oZV0ETcTOqoIWziClBUcDDQoepYeWXO0aA8RT5OgJpWP5HzhHSFdhshqaYWmfJtC96uVbWxSaCAlo/Ly1cPnfNkeWWUvjyqAfvuYkvbCsBh6T1Oh8CP3LxVOnd3ebFt5AHrh1EjMFuVlyvMUtt19KFryzag7zRUFHRxHS6bfUpt58jrTDPJVgejRSsZYXVKkYZpfZAuJrsWKFZe8ykpWtPW5+5qA0uDvcbP4xWLk9iAtQUqbUaCzvPRePKAoZErN9dsrk+o9SrOZ3GtqlpopmmWwS7J3N+Ww7LQjOFjcnY7cc02zzhe2hGVK3KvTPr6AZl
 uzpv0H54
 xNoJgtFT5mBmS8yAIHAO0eI2TqpLbdOY1BrbvjaShkg/ovnMGeCR2b0Doy0pufuK8vxxu7o2cqYzQSJdFhJUF82XmkGo7FU2O8JUTc1ygjFH0037w4xHLgJBDV/fSqjxzxu82AJdE4/q47oz6hc5NxvlhvxZYreI0a9kSzd8uf/KVE23ajvyQ3HF8gFGgXEGK+6bpdR0qyr5aW8+bGS6F+H28bSLCRnV6KABUWUG01jjrQ0FgWhJ50vD2zbOxbhncgENWCyoKCNZA5yrZW9m91lbrQv7aVzj5VnduI0xFqu9flj8XPcXHGew1KXCZ4Bq3HDhn9pDH3Tm4RnltKQrRmZMr5jRa1SHUuGJufcm+YkzNZUAndW19VWX8NiR7ipWaNor+BH0exRsEakuAeYmL9/DBqQil7cE+A5+tOSqyqpjnwKHvumycITLukjAxBpRbJ4voXDdZvrlU++TcdzCpEFrIr+D45RnnJPtd9vW4behYGmjnnLjeapbAKPLx+KrmWAjhGprhU/+hpu4VzYHhBBX1YYBq+bIacRzWHhyYJ99aovi58MSfM9iWG7G/3eaHPTlWXjqUmxc2a3M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 10:55:07AM +0800, Lance Yang wrote:
> 
> On Mon, Oct 26, 2026 at 04:33:08PM +0000, Pedro Falcato wrote:
> >On Mon, Oct 26, 2026 at 11:20:13PM +0800, Lance Yang wrote:
> >> collapse_file() can call page_cache_sync_readahead() while still holding
> >> source folios locked. If truncate holds mapping->invalidate_lock
> >> exclusively and waits for one of those folios, readahead waits for
> >> invalidate_lock and neither side can make progress.
> >> 
> >> We need to release those folio locks before starting readahead. On a page
> >> cache miss, roll back first, populate the collapse range, and retry once.
> >> Doing readahead after rollback avoids an extra pass when all folios are
> >> already present. If another miss occurs on retry, give up rather than keep
> >> retrying while truncate or reclaim removes folios.
> >> 
> >> Keep page_cache_sync_readahead() and wait for read I/O with
> >> filemap_lock_folio(), releasing each folio before moving to the next. The
> >> existing uptodate check during collapse still handles read errors.
> >> 
> >> Shmem uses shmem_get_folio() for swapin and fallocated folios without
> >> taking mapping->invalidate_lock, so it is unaffected.
> >> 
> >> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> >> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> >> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
> >> Cc: stable@vger.kernel.org
> >> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> >
> >Thanks for the patch! This looks almost perfect!
> 
> Thanks Pedro!
> 
> >
> >> ---
> >> v3 -> v4:
> >>  - Move readahead after rollback and retry collapse once (per Pedro).
> >>  - Drop the preparation pass and its redundant uptodate check (per
> >>    Baolin and Pedro). Thanks!
> >>  - https://lore.kernel.org/all/20261016065920.4153-1-lance.yang@linux.dev/
> >> 
> >>  mm/khugepaged.c | 44 +++++++++++++++++++++++++++++++++-----------
> >>  1 file changed, 33 insertions(+), 11 deletions(-)
> >> 
> >> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >> index da91762f6358..0d3bd9e23613 100644
> >> --- a/mm/khugepaged.c
> >> +++ b/mm/khugepaged.c
> >> @@ -2239,6 +2239,8 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >>  	enum scan_result result = SCAN_SUCCEED;
> >>  	int nr_none = 0;
> >>  	bool is_shmem = shmem_file(file);
> >> +	bool do_readahead = false;
> >> +	bool readahead_done = false;
> >>  
> >>  	/*
> >>  	 * MADV_COLLAPSE ignores shmem huge config, so do not check shmem
> >> @@ -2256,6 +2258,10 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >>  
> >>  	mapping_set_update(&xas, mapping);
> >>  
> >> +retry:
> >> +	result = SCAN_SUCCEED;
> >> +	do_readahead = false;
> >> +	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
> >>  	__folio_set_locked(new_folio);
> >>  	if (is_shmem)
> >>  		__folio_set_swapbacked(new_folio);
> >> @@ -2320,17 +2326,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >>  			}
> >>  		} else {	/* !is_shmem */
> >>  			if (!folio || xa_is_value(folio)) {
> >> -				xas_unlock_irq(&xas);
> >> -				page_cache_sync_readahead(mapping, &file->f_ra,
> >> -							  file, index,
> >> -							  end - index);
> >> -				/* drain lru cache to help folio_isolate_lru() */
> >> -				lru_add_drain();
> >> -				folio = filemap_lock_folio(mapping, index);
> >> -				if (IS_ERR(folio)) {
> >> -					result = SCAN_FAIL;
> >> -					goto xa_unlocked;
> >> -				}
> >> +				do_readahead = !readahead_done;
> >> +				result = SCAN_FAIL;
> >> +				goto xa_locked;
> >>  			} else if (folio_test_dirty(folio)) {
> >>  				/*
> >>  				 * This page is dirty because it hasn't
> >> @@ -2657,6 +2655,30 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
> >>  	new_folio->mapping = NULL;
> >>  
> >>  	folio_unlock(new_folio);
> >> +
> >> +	/* Readahead may take invalidate_lock; source folios are unlocked. */
> >> +	if (do_readahead) {
> >> +		for (index = start; index < end;) {
> >> +			folio = filemap_lock_folio(mapping, index);
> >
> >I'm not sure if there's a point in locking the folio. If we are retrying,
> >then the logic above will lock it anyway and check uptodate. So I don't
> >think there's much of a point doing it here. Right?
> >
> >So I think we could get away with a filemap_get_folio() here, and no
> >filemap_lock_folio() after RA. Unless you're intent on waiting for RA
> >right before failing, but I don't see a point in that.
> 
> Right, waiting for RA is what I intended here. Without that wait, the
> retry can hit folio_trylock() while the read is still in flight and bail
> out with SCAN_PAGE_LOCK, before it even gets to the uptodate check.
> 
> If the read completes successfully, we can continue with collapse.
> That's why I kept the wait before retrying. Do you think waiting isn't
> worth it here, and we'd be better off leaving collapse to a later
> attempt?

Hmm, yes, thanks for the explanation. I had a fresh look at the code and your
patch preserves that bit of behavior. Isolating folios is simply trylocking,
and only does a hard folio_lock after RA. So, LGTM!

-- 
Pedro

