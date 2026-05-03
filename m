Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D06CFF886F
	for <linux-mm@archiver.kernel.org>; Sun,  3 May 2026 17:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B4A6B008A; Sun,  3 May 2026 13:17:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B466B008C; Sun,  3 May 2026 13:17:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8797A6B0092; Sun,  3 May 2026 13:17:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7B09D6B008A
	for <linux-mm@kvack.org>; Sun,  3 May 2026 13:17:39 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D46CB8C92D
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:17:38 +0000 (UTC)
X-FDA: 84726765396.06.0E41971
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf08.hostedemail.com (Postfix) with ESMTP id A21A4160008
	for <linux-mm@kvack.org>; Sun,  3 May 2026 17:17:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VfUWqIal;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EIdPwBQw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VfUWqIal;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EIdPwBQw;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777828656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDlKlMHbVinipLNw9LrA+knbIJA6L8a+g0vJK+dN85M=;
	b=nYXdeZAfpUNV8bvpMfdFP2a6ApMW76lmj3/2iWIjVVsHFaYJXPNSADo9u5vm3NJRUGSbMV
	TQVeltUa9FUX2jZsg8ZpqXOc9Kb3b86RcbG/6Jc+6zyPNjBjJwHlNprv/powUvXsae5bbt
	TzTm1hQGc/hFa7V+4i0c4a029tG+1C4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777828656; a=rsa-sha256;
	cv=none;
	b=q4ZY6JM3ltfnKJQgwNwX/dA5dL5KLopJtZOpwZk9ixpyPng0e3VoM0PCkKhC0EVuYMdncv
	48hqQgbmO14mYfSvV6X103/2Xv0K/BL2evClm4lYJ+a3UEBuILCnFmj+9Xw2z+8aHOxaeD
	aWbeKuiOJtQTDcDK5pPA141slFFK31E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VfUWqIal;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EIdPwBQw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=VfUWqIal;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=EIdPwBQw;
	spf=pass (imf08.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1C1805BF55;
	Sun,  3 May 2026 17:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777828655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KDlKlMHbVinipLNw9LrA+knbIJA6L8a+g0vJK+dN85M=;
	b=VfUWqIal8zUZxua+OX+zlAT8qGOtxWgZdFmCWJFangvLdJYL62hKCI7XhV7FZv0uk6ydwp
	ZcwJW4rKvy9juzaKbjBCG5mUTcjC4u9xmuVR7RgLboZFwk97HFw1oRiNgP7NeruIQJCVlH
	bC0giDhlkn/KbypGsq3Roay3pH/34po=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777828655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KDlKlMHbVinipLNw9LrA+knbIJA6L8a+g0vJK+dN85M=;
	b=EIdPwBQwsxRtZUGDu6VTg/ER7tZhcSskFKrnHwwAHQwD+uvSGM4Sh3N5dqNBMyDMGa9q7Y
	oSbGt8aOozQoKsAg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1777828655; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KDlKlMHbVinipLNw9LrA+knbIJA6L8a+g0vJK+dN85M=;
	b=VfUWqIal8zUZxua+OX+zlAT8qGOtxWgZdFmCWJFangvLdJYL62hKCI7XhV7FZv0uk6ydwp
	ZcwJW4rKvy9juzaKbjBCG5mUTcjC4u9xmuVR7RgLboZFwk97HFw1oRiNgP7NeruIQJCVlH
	bC0giDhlkn/KbypGsq3Roay3pH/34po=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1777828655;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KDlKlMHbVinipLNw9LrA+knbIJA6L8a+g0vJK+dN85M=;
	b=EIdPwBQwsxRtZUGDu6VTg/ER7tZhcSskFKrnHwwAHQwD+uvSGM4Sh3N5dqNBMyDMGa9q7Y
	oSbGt8aOozQoKsAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D9553593A6;
	Sun,  3 May 2026 17:17:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id stqeNC6D92kPXQAAD6G6ig
	(envelope-from <jack@suse.cz>); Sun, 03 May 2026 17:17:34 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 3CEC3A0799; Sun, 03 May 2026 19:11:42 +0200 (CEST)
Date: Sun, 3 May 2026 19:11:42 +0200
From: Jan Kara <jack@suse.cz>
To: Souvik Banerjee <souvik@amlalabs.com>
Cc: dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz, 
	apopple@nvidia.com, linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] fs/dax: check for empty/zero entries before calling
 pfn_to_page()
Message-ID: <wxna5633rfnyte56h77bezw4duqlbdyxpt6wejywebatfutgh6@w2czfecq5zhr>
References: <20260501233933.2614302-1-souvik@amlalabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260501233933.2614302-1-souvik@amlalabs.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A21A4160008
X-Rspam-User: 
X-Stat-Signature: fpqjeu549s53qeyttzce7tr1mi85rni7
X-HE-Tag: 1777828656-692680
X-HE-Meta: U2FsdGVkX1/7IhhRrPfkt86Mca/EIZEJQudUpmHkVGtexVQ3GLyTMOIgQVqx4VtEjb8q1TWRumQvVQrwoHJzH43fGwlYwwB+b0iinS+wYlKnOWw9+fiHos1T3TbzYyGAqoHuHVUUsPKgossNghG0mF5ky5MUqm9YNmyRnf3s56m4IDPM75xTzBWHJsx6Dk4nWzFcDfNTpa/XDGim6lRTYbt9s8joUHJv6xS4zPXWJgnMNYLs3yAEMeyXxMoEuBcI13mEcYBtEGd8OHjZOu6ced4tyLpLM+u3/yYWhu4lYsVmI3O2BHU092h+7aKPHxIWAIAFsf2o1CzSlrho+qZXSpB0m/pwdrps+T56GBV0qUFWVeMhCECHfQyLIgI3BfNJd3xMggLr1vPA+LtUwDZ6CAvHPERQBYFMC10mSaALFMQU7aWYaNBVYSUPpNbkMRoszCNTU1FBgIUzIr9YKMvs8dU0VtidOHYJk6+CS5MG8TUtBK9Tepbu2pEZjZQCRDnsOz0rz+GZE3i0z+cjQC0ncX3pZOqweATa7kzVhsynQU7oaDmyLHBjcoXraYd7Qz4aI3TX+cmTf1dXcvexbEc2k1124uP+ru5TWeP3/8tosMrP/w+cF3XybCC90wSZFnEtGTckQINkoHmAV+IXT0cb5rQoC9DN5HRaw3oWorXqlOudND/9dm3U7F6oqLwwvM1iitIBwhAWGgNWaxq7pcvAVoVlQ7yqjLt5GDgF2nFodkvBhjgsAZSMAiIqQTkIKIvrC73kWi7LUqY2+nkxp/uuFUzX85cq7Pm4B0DJkVM1U8bo/SfEs60rbjZGY9tJfcaLtZ0ZSEtncCzdevzFbbm+w0nW037dbUjTnpuA0spIV9/fZDmisnVA+MvSeDcaq0LEbuYNyBBVCVGnBOGKlps5IdblrPCNze+jQmFTKoVWJPVPITE1Nr9CtNk7X7NOdmvQVlq9xNrrrb/WWihTZza
 YM7IQH3U
 Zbe4ckgME6zu6joXalJ8poDoQ/S5yc87wQktKnnyPQSfa15sjwvpfK1h+a6wy2wNbHM+EuxpCbBQDRQD5zu09TfPb85U+N1tm2PEWgcdpasgdYiBHruLc896dPOB7xKFgQ7NmKLj6piYZrQnIOQXh7cgUkJAuUbStb2Vhw8t028pDJKU7eGw2T8qZFm2ySjw/tep8nSDLsJ4pWZAUvTjE5VCEuqdJTfx+UicvkoRmfwH07jmRFBLeM/m0NvHy97GdPwPZWpGS93PbaGdy208kL2yTuiDifomiLOIgEje3PH6KWQ/ocV6L04ZFiRAynH165uzMV8EGHqRmaYybwU+eLhGTvg7x+SnrZB3tOuYZVEf7OWYuxrc0fsa7n5MuS3dswt41KJuVSRNIiTimFN10U+PKynrffc8SWD9O7tQUmTQoOgeDjXczeQC9G6IDFWhCc8lOQbCL4ZjS6zU5f/Ph8w66RXgWykYFaLwQVH/KDtBBiceU+sgUalvC8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 01-05-26 23:39:33, Souvik Banerjee wrote:
> Commit 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> added zero/empty-entry early returns to dax_associate_entry() and
> dax_disassociate_entry(), but placed them *after* the
> `struct folio *folio = dax_to_folio(entry);` line.  dax_to_folio()
> expands to page_folio(pfn_to_page(dax_to_pfn(entry))), and page_folio()
> performs READ_ONCE(page->compound_head) -- a real dereference of the
> struct page pointer derived from a bogus PFN extracted from the
> empty/zero XA value.
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
> zero/empty guard in dax_disassociate_entry().  Apply the same
> treatment to dax_busy_page(), which has the identical pattern but
> was not touched by the prior fix.
> 
> Fixes: 98c183a4fccf ("fs/dax: don't disassociate zero page entries")
> Fixes: 38607c62b34b ("fs/dax: properly refcount fs dax pages")
> Cc: stable@vger.kernel.org # v6.15+
> Cc: Alistair Popple <apopple@nvidia.com>
> Signed-off-by: Souvik Banerjee <souvik@amlalabs.com>

Yeah, good catch. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/dax.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 6d175cd47a99..6878473265bb 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -505,21 +505,23 @@ static void dax_associate_entry(void *entry, struct address_space *mapping,
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

