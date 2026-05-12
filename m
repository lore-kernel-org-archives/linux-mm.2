Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA23ECD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:46:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20FDD6B0088; Tue, 12 May 2026 03:46:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF9E6B008A; Tue, 12 May 2026 03:46:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE7C6B008C; Tue, 12 May 2026 03:46:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF1326B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:46:05 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 88A1F403F6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:46:05 +0000 (UTC)
X-FDA: 84757984290.10.1CEFB60
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2BF9F180007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:46:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vhCjewmX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yAfrDtkA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vhCjewmX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yAfrDtkA;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHLdHCWpIuvrGHleD2Jqy4bV6mXhHYzDchTWJ+uooJg=;
	b=hz69LV3aqNspcOjQfTXgS+QKjBXAhYeJM4dM69xYyng6BmUIkOba5ndzlDPEHZA6dn0rFs
	2APUy6pm5NAHAuGJbbSb8Om7/dC34AfCbDhsR5lAzr3HTi72DG4okkUB2wirOShK4gbhdh
	1mVd+i3Xketm3BRjmRDC3NiGKH8gjt8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571963; a=rsa-sha256;
	cv=none;
	b=c8bUaO+DEvHFLDLWx+GHKtKzpXSadqzNhEAdJMYiFp23WjxmytwGSIvcf76ThVURuxmQCF
	ASW34Bb03w7GkBR/GM/EXrtoBvfjyiFB//7zy/IJjki4cggsXIXlgHfVpRLwF2EbTn9swv
	KiwS9AbOhy6P06mvh21mOUK1VqH2yPo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vhCjewmX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yAfrDtkA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=vhCjewmX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=yAfrDtkA;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6F8CC75987;
	Tue, 12 May 2026 07:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778571961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yHLdHCWpIuvrGHleD2Jqy4bV6mXhHYzDchTWJ+uooJg=;
	b=vhCjewmXJ14jmPxoyoPljvGVqja25tFl+s2LtOwZBYRHdxqohEUQP9+OmLdjVXs8m0R0IJ
	+drJoUe94iejebihfZ/mn7KVSfqrfqLxYHevtfXm0ZpXJuybWLi5j6g94obqX/j09ke8Co
	OC4F9P3U7ejHYNiY0kU7VKyAVCkuHG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778571961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yHLdHCWpIuvrGHleD2Jqy4bV6mXhHYzDchTWJ+uooJg=;
	b=yAfrDtkAVLmGnC96QM2rmP/5S8skAObsrOQl7kUXYCPBAV5FakoKumbQ6tnx3xhz4JzGf8
	t4aWG1a8tk0RPgCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1778571961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yHLdHCWpIuvrGHleD2Jqy4bV6mXhHYzDchTWJ+uooJg=;
	b=vhCjewmXJ14jmPxoyoPljvGVqja25tFl+s2LtOwZBYRHdxqohEUQP9+OmLdjVXs8m0R0IJ
	+drJoUe94iejebihfZ/mn7KVSfqrfqLxYHevtfXm0ZpXJuybWLi5j6g94obqX/j09ke8Co
	OC4F9P3U7ejHYNiY0kU7VKyAVCkuHG8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1778571961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yHLdHCWpIuvrGHleD2Jqy4bV6mXhHYzDchTWJ+uooJg=;
	b=yAfrDtkAVLmGnC96QM2rmP/5S8skAObsrOQl7kUXYCPBAV5FakoKumbQ6tnx3xhz4JzGf8
	t4aWG1a8tk0RPgCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 648F6593A9;
	Tue, 12 May 2026 07:46:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id DbmBGLnaAmpYUQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 12 May 2026 07:46:01 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 0758CA093D; Tue, 12 May 2026 09:45:52 +0200 (CEST)
Date: Tue, 12 May 2026 09:45:52 +0200
From: Jan Kara <jack@suse.cz>
To: Souvik Banerjee <souvik@amlalabs.com>
Cc: djbw@kernel.org, david@kernel.org, willy@infradead.org, jack@suse.cz, 
	apopple@nvidia.com, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
Message-ID: <7hos254p3ta422rfs5bqpvz3p6fmgdagvsxw7nb7vgqew3icq3@77wflvbcdwln>
References: <20260511214020.208939-1-souvik@amlalabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511214020.208939-1-souvik@amlalabs.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2BF9F180007
X-Stat-Signature: 8zryotti9bgergfyrbdauatkhynu45uw
X-Rspam-User: 
X-HE-Tag: 1778571962-321139
X-HE-Meta: U2FsdGVkX19ATg25RDawFVbQeQTTc4wA1gSbD53BUR8OT+3dukmUKGzVALveTRwnpiQ+Bx4d8KVJS1Grjp8whEuig02ndZnVoWjECZVzgjahDqpF1BlAixKrF3twrnDGh3EkrK5RURGnBBuVF6R6IsbwaYZzDa/Cqwt+s9dKlmr6iHTwkCL0z+HJnjenbvsPDgsNRQenyUIQsRFbKXu1yt9E7/Njqnfx9AbaLfoZTyG7BybrX1CLGz1szJJZ5t8MArl6dHMaJYig2GKI2jhg7bfiUEiXOKg12Tbd33OQIAhq38k8vA2CKkv0gRHVqZOiTpa1gYmjLJi/7xn9a4mZbgnV4LajhorJ1klnZ6D4kmaQH3DEOqXIEC/hSgugnhCnKhmvRPaNjbIxYY/oO0D85jRwKfbvdrvgToVYtVKAfQcjslkkoftkuzwKPl5kaaX3XdoTIacGUUMR86i+q+9wcSNnXCDqtuBMlt29JCxrCgyTnAUyzPJ8Wmu7DHQmyOXvwuvNGffXyVkqRlUfeaf1FPWNV8KjI+5xVV4pmNDAnFy3QkUu11bz86onQWBYXCZelxlOPGcS8pHGKjkOdR217+HMdtUYlF0AFeOMI3oezeubY6J5k+YF0X4Bq1voLiR0UkY+yBYH+a0CgZ8eqyEOLDromhyYtYj/NZp63AYKYPJWeidR/PHsXpaNVDlIdNOUvaX7rIQJ/oODI8uSMIvJ3LjfKk8oQnoXmgYiDHk56eR+Q05Q2b8bt8N7Q5TjPhgukhRp5xYVdyZlQi8mJgb4wiRE3Lz+15ZMiF0llwpv58rS6XtzOgr84ZggArEEauC+DYxHXYI6IUJM2H5KB+20iowEAUoPmy2lORhjXsK9X3VI6x8FMllV8X7lbjR8Ice9OXoedyTlfQBkwy/gIEJTCeHNqf0a8YjcROH3ufETsxhc0jLcfmyzpxHXMpIGdo5gD690ds5NR2DB8BpP2pG
 K8yaxdpL
 6u5fLYshJz9Tr3/NeBoi++G+UghCVrd1QpnW+6LKgwiggOmZjmsuJv77sCPpRhbP7PuJCexqWxx58dWO0pFmhgZaSUpuIbQfi9umrHUD2I0OPEP+g11U1El4273OGePhkosxwXjz0HboZ9z5zNukBmhJqHSih2TwpvejE9ZZZYOOpZWxmJWofuo5BbI+53XCerg0blYrmZlsN9kBdsUdD1301tcSIwV2qD49vI3QTBjSZfnudPOw0Df69eIUi4OdIr4AB2IAJvXkBcZBHteZl+hxaYFdm4yniIpdmXl9OgFZRe+B01w+9dN0j6RT9zFd8+vVMRTUXMGgIaAMUqPRz3kjaNPEyB5iHIGed42cd0pKU50bhfiPLwmu+cCxkOhmIsvyPRXD8ULwHEoJx/s5up9NC+1mD2KfU6J6pN8aJC9vglM7m26311HSJeOZxckywRFiPx8jHQXOsdFyOvf+UFtd77LQ6ms0VdHIXeTPjzX0jRoFXFp62X6rUmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 11-05-26 21:40:20, Souvik Banerjee wrote:
> Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> added zero/empty-entry early returns to dax_associate_entry() and
> dax_disassociate_entry(), but placed them *after* the
> `struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
> expands to page_folio(pfn_to_page(dax_to_pfn(entry))), which calls
> _compound_head() and performs READ_ONCE(page->compound_info) -- a real
> dereference of the struct page pointer derived from a bogus PFN
> extracted from the empty/zero XA value.
> 
> On systems where vmemmap covers all of RAM that dereference reads
> garbage and is harmless: the early return then discards the result.
> On virtio-pmem with altmap (vmemmap stored inside the device), only
> the real device PFN range is mapped, so the dereference triggers a
> kernel paging fault from the truncate / invalidate path and from the
> PMD-downgrade branch of dax_iomap_pte_fault when an entry is being
> freed:
> 
>   Unable to handle kernel paging request at
>   virtual address ffff_fdff_bf00_0008 (vmemmap region)
>   Call trace:
>    dax_disassociate_entry.isra.0+0x20/0x50
>    dax_iomap_pte_fault
>    dax_iomap_fault
>    erofs_dax_fault
> 
> Close the residual gap by moving the dax_to_folio() call after the
> zero/empty guard in both dax_associate_entry() and
> dax_disassociate_entry().  Apply the same treatment to dax_busy_page(),
> which has the identical pattern but was not touched by the prior fix.
> dax_associate_entry() is reachable with a zero entry via
> dax_insert_entry() -> dax_associate_entry(new_entry, ...), where
> new_entry can carry DAX_ZERO_PAGE (built by dax_make_entry() in
> dax_load_hole() / dax_pmd_load_hole()).  dax_disassociate_entry() and
> dax_busy_page() additionally see DAX_EMPTY entries created by
> grab_mapping_entry().
> 
> The remaining users of dax_to_folio() / dax_to_pfn() in fs/dax.c are
> either guarded or only reachable on real-PFN entries, so this exhausts
> the anti-pattern.
> 
> Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> Cc: stable@vger.kernel.org # v6.15+
> Cc: Alistair Popple <apopple@nvidia.com>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>

Looks good to me. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
> Changes in v2:
>   - Also fix dax_associate_entry() (Suggested-by: David Hildenbrand,
>     confirmed by Alistair Popple).  The same anti-pattern existed there:
>     dax_to_folio(entry) ran before the zero/empty guard.  new_entry on
>     that path can carry DAX_ZERO_PAGE via dax_load_hole() /
>     dax_pmd_load_hole(), so the dereference reads a struct page derived
>     from the zero-page PFN before the early return discards it.
>   - Audited remaining dax_to_folio() / dax_to_pfn() call sites in fs/dax.c;
>     no further instances of the pattern.
>   - Updated the page_folio() expansion in the commit message to refer to
>     the current field name (page->compound_info via _compound_head()).
> 
> v1: https://lore.kernel.org/all/20260501233933.2614302-1-souvik@amlalabs.com/
> 
>  fs/dax.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6d175cd47a99..4bca6e2bc342 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -480,11 +480,12 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>  				unsigned long address, bool shared)
>  {
>  	unsigned long size = dax_entry_size(entry), index;
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return;
>  
> +	folio = dax_to_folio(entry);
>  	index = linear_page_index(vma, address & ~(size - 1));
>  	if (shared && (folio->mapping || dax_folio_is_shared(folio))) {
>  		if (folio->mapping)
> @@ -505,21 +506,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
>  static void dax_disassociate_entry(void *entry, struct address_space *mapping,
>  				bool trunc)
>  {
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return;
>  
> +	folio = dax_to_folio(entry);
>  	dax_folio_put(folio);
>  }
>  
>  static struct page *dax_busy_page(void *entry)
>  {
> -	struct folio *folio = dax_to_folio(entry);
> +	struct folio *folio;
>  
>  	if (dax_is_zero_entry(entry) || dax_is_empty_entry(entry))
>  		return NULL;
>  
> +	folio = dax_to_folio(entry);
>  	if (folio_ref_count(folio) - folio_mapcount(folio))
>  		return &folio->page;
>  	else
> -- 
> 2.51.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

