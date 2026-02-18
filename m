Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17219E9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:05:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 743D46B0089; Wed, 18 Feb 2026 03:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BC8A6B008A; Wed, 18 Feb 2026 03:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474BC6B008C; Wed, 18 Feb 2026 03:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FFAF6B0089
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:05:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EC8BF160239
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:05:31 +0000 (UTC)
X-FDA: 84456842862.28.D3BCFDB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4F2CE8000B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:05:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uAvxNEih;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771401930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pfSEsV3YEVwn+nj37XqCibAFTZ5L+HpfePa6+fODmv4=;
	b=Txw30vfUj/Dk581swPvGW18iTvLTJlf/NmLu0t1Q4XZe11jKpQZnE76zGUqQoM/+av5lF9
	COm3iKmpjkPYvprhJALfsQa5Miv/MQAQh6+Vwh+MJtNnqNDb3sMbUkg3CjB1U2iA4ehr4z
	l/KQF1SUJo3fGn7YDr+34XT2QRP1qmU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uAvxNEih;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771401930; a=rsa-sha256;
	cv=none;
	b=B6JFvlopZA45hfGwViAtZlBit3XTFULPzgkG97xaechM7ptPSrHheg2eT1gWPECR1agALk
	oLwkYDjkSiIBS7ioueNzCtRuOFTB771HT6u+uQ9QSzjLKVxCycJfHDJpHx89cfCHO9E4dc
	WG+gZcO2ovn/jy4SxSRT9PtqGqRlRw8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 034EE419F5;
	Wed, 18 Feb 2026 08:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D307DC19422;
	Wed, 18 Feb 2026 08:05:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771401928;
	bh=R25EWQcZmpLh52pHZNBSbXColeIIA4ixJkSBb2dyFZM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uAvxNEih8aY+95MRiMbW2SidZngGTowBmlD9cvJ+7+Dj2cFq8wiqWLP135ediQhex
	 /iJnlyPWK3lAzpsEOaEAg/FWmlttWZRqAJQpKBwhgtqASDh4NYJSBM6Nu7tApAv8kc
	 5AlaiL8VnQmc3K9z2+4zRzSLd2Q/sCQ0qagAuzXDIixjkELLBttKFzwbXV2803s4ZH
	 ZGQoHsbgb/D966TWMXzHh1RaoA+PcQm2tfB9t97DbGGQFUAyeF8i6GKZAdok2XXIYp
	 iS6KFG/ildp+nN/+Ay/CWZ6vC+MJa2I+oRvc4GpVu1U5r27RTaedP+BGvZ6NIbqydd
	 H+gkCPQejBhVg==
Date: Wed, 18 Feb 2026 10:05:24 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-mm@kvack.org
Subject: Re: [PATCH v2] mm: Fix memblock_free_late() when using deferred
 struct page
Message-ID: <aZVyxKVS8y-rqwrK@kernel.org>
References: <ec2aaef14783869b3be6e3c253b2dcbf67dbc12a.camel@kernel.crashing.org>
 <bbffd0db46460cebd604f5c1e6668984fd4cc435.camel@kernel.crashing.org>
 <14295eba34f10f5896e6cb7d3e1abd36199cd918.camel@kernel.crashing.org>
 <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4d93284349178a783725539b66dca25725fa779d.camel@kernel.crashing.org>
X-Stat-Signature: dxc65dtqgdjpqce4uodjthmhpzo3na5a
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F2CE8000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1771401930-800192
X-HE-Meta: U2FsdGVkX1+G+d22/ukPwdAl4FET/VdlrapbWwMal7PvbfAIl3IeZhxnmQK+zuqrh27UBcOhDbENYSjWlGNKwHFpEgzFJ04br1L0RQOe6661eCgSBMPqwM86opogjLw8P1Wm8UkP8fF3EgxzC+cZD59va7qRrLKaHRzdR/aZmoShCARV3un4AJoPWzRVg0Clgq/yZC+4yyhGL4n1WhqcX2FebwRua5KbRfFl7Z9QqaRvnDCg2FP4LU8CX9ayAmh8GuitIcaRmrO0PDx2KMduasK6KGkXQ2cYM+tVHZpC1Yjpz9lQWCgy7XZkSU/cEROspLtAuzCKiacXKAL3+W4CAhePBMP4NYZdnviUsM/+bYg7nDGHaiFfO/H+Mm3wto2Js791HnkqHaLYQCtLXAB8Foehe8xvsIOMrVE+YSANvHWibDsRSQIjkazwmWm1Ab9lKdlKqjqmre1JEmWzs0zUQgsEZu95qTYgglUzlUnShuABH5WYb8U/9g/7UaHWhZff2TQk1ZnGQE5Xd3ioBYmuqv5bkFcdXa5G9mR9tQ9jFR3amyRJjReZE7UfuAI0s+tLHMnco1Y6otBy908EaxU4k0W9mE8LOpimvNg76GOcxX1YsYJerY41Gmprpuf/vF4SZ/0ylc1srFt7Dd1yTXFKK9E8+1ov9I4ThLp7WXZcE0KFd7khjbfV+09Us3PpqxuvQPlfplYg+Cny7xcyxgUqaf26kbP/eb45ysM4t164QYDtPtsnZ+oIh/qjzJuiYZ+L/0jN7q0XHQQnSMglvq4oU5faqN5OzLTjWdoTfwrnZYvOvKsJc+6FIjA8wtXYuo+IkSm9dlHITxYlQFm6klcTD26vFlzvM3KBW9ImFoYv/9lWn8p9iaqfuHePuC6qFcc2QzY7+bsycYfCvOyiBdnszm1vcmQV+WrzMQ6SSmwscZui7vrjzOrlHQ0TffedI5YxWZwJknGUZ4/1NOFkBTI
 8+1jnzBj
 vrHt/UXq3gFaHpQbEscNKNL1jr3siLIzO9sZspbap63v6h+gu04Tiro9cXmqvss2ozpicf7UtRdkkVzmXI9+6jRTg2Ftf/fBFLawb8QUauo2A4T6DtgMfm4QwYxbqO+CZqin4wvQnow9ris06c1nCtHyxeMwD9BpBol5CJ6rvBL/E19Hr1rn7QGRnE0OTlA+CiYLoxu6Uydr/z3TdUlXwt9NQ+MwgP6UvwWWFeWqF7aXYo+G6H+Q8DB1a37/+q+NlwT5UiIHLLPQIXaudmgMm3dg/0wB/r9MiXs4GpUiQsCILmQ4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 11:15:59AM +1100, Benjamin Herrenschmidt wrote:
> On Wed, 2026-02-18 at 08:47 +1100, Benjamin Herrenschmidt wrote:
> > There is definitely something fishy going on, though I don't know what,
> > as the page is reserved so it should *not* be touched by the deferred
> > initialization... Could there be an issue by which we incorrectly go
> > look at the head page (which hasn't been initialized) of a *potential*
> > compound/huge page ?
> 
> So ... not 100% certain but I see this in __free_one_page():
> 
> 
>   buddy = find_buddy_page_pfn(page, pfn, order, &buddy_pfn);
> 
> Then goes do things with the buddy. find_buddy_page_pfn() is
> (stripping comments):
> 
> static inline unsigned long
> __find_buddy_pfn(unsigned long page_pfn, unsigned int order)
> {
> 	return page_pfn ^ (1 << order);
> }
> 
> static inline struct page *find_buddy_page_pfn(struct page *page,
> 			unsigned long pfn, unsigned int order, unsigned long *buddy_pfn)
> {
> 	unsigned long __buddy_pfn = __find_buddy_pfn(pfn, order);
> 	struct page *buddy;
> 
> 	buddy = page + (__buddy_pfn - pfn);
> 	if (buddy_pfn)
> 		*buddy_pfn = __buddy_pfn;
> 
> 	if (page_is_buddy(page, buddy, order))
> 		return buddy;
> 	return NULL;
> }
> 
> Now what happens if order is 0, page_pfn is a reserved page whose
> "buddy" isn't reserved ... and whose struct page is not initialized
> yet due to deferral ?
> 
> Unless I'm mistaken, we are going to poke around at uninitialized
> struct pages and things can go anywhere from there, can't they ?

It's possible.
 
> Or am I missing a piece of the puzzle ?

Apparently we do miss some piece of the puzzle, otherwise you'd see no
crashes :)

I think an easy and backportable fix would be to make
efi_free_boot_services() an initcall, so that it will surely run after
deferred pages are initialized.
And since the boot services memory is not memblock_alloc()ed but rather
memblock_reserve()ed, it should be freed with free_reserved_area().

With the symptom fixed, we can audit memblock_free_late() and
free_reserved_area() callers and see how to make this all less messy and
more robust.
 
> Cheers,
> Ben.
> 

-- 
Sincerely yours,
Mike.

