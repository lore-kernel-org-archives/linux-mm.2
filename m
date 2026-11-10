Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D14C606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 08:10:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bxFnCQ1v
Received: by kanga.kvack.org (Postfix)
	id 849AF6B05BF; Tue, 10 Nov 2026 03:10:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BCC26B05C0; Tue, 10 Nov 2026 03:10:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AF536B05C2; Tue, 10 Nov 2026 03:10:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 43E296B05BF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:10:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B65A114088E
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:10:42 +0000 (UTC)
X-FDA: 85418487924.15.D172416
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1EC23140006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:10:40 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bxFnCQ1v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794298241;
	b=zfZc1u/qJ12kgkbs68xK6y3fHogZ2X4feRikNTz25ZusXO6GKkT4+sQPBLD+Drlm91Wf38
	KkncBf7WXAMu4J3UgDkj6PhvsvsVdugbbfKhbsKhLnr58lzmcZUR4bHik1vrXSlAWlmn7E
	dL/tHmfwv8QK4pJu73dK0RbgZil3dVQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794298241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ui3CpIlEJ97q+nx0KroTiGNw6xa+MjE5Cl5DE9+vJM8=;
	b=M4CBgzlUKZRHhKnycfxDZg6DbjacdGaGOSQ+Z2N05dWKm1UuBX+7pg/UV8ezjdITPeXeCc
	MWEYlWs2alPG8lj3fRo3eLQ2z9ughUalXhWEqf/BtARif+B4jkuwHbEVHXPT4zvJEnqGjA
	2lmzm2K73ccTAe4OgrFsGCDWdQ1y3A0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bxFnCQ1v;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7883663793;
	Tue, 10 Nov 2026 08:10:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8BAC1F0089F;
	Tue, 10 Nov 2026 08:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794298240;
	bh=ui3CpIlEJ97q+nx0KroTiGNw6xa+MjE5Cl5DE9+vJM8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=bxFnCQ1vPDFtFhBtQXiw1XsFAyyZg6NDQfzLHIRS/5b13h5u4kxxfAjjPkKbKvBe2
	 jhlpGMLgkSD9sxDvSMWVG4LyQEueUBCf1S8+y03mKbbkRPIT9aaYtnyG4LMZGTaqZH
	 ZbIy4osRecG4YG+xtlQgRFUZYnhFVS4oc8s2lJ3ps7+ywH2RhrsgHy1ox6TrXOVZWN
	 K1iZSFF5NdfNaC0ngnKtFtrzC7ZCEet1bpagm3ORVeAPera5uPloH3yhsY4MrTlBEx
	 vZ/nvI32EiOiBtPEzh3d7FrmhSARS93F/rMbBvOffiE4/oCTeL/2PLtvbBLzPaBdJr
	 NrvGVJnjSPnYA==
Date: Tue, 10 Nov 2026 10:10:33 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Ivy Lopez <skunkolee@gmail.com>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/cma: simplify cma_declare_contiguous_multi()
Message-ID: <avLReYfv2iMARmk2@kernel.org>
References: <20261106-cma-multi-v1-1-054eae6e2c1c@kernel.org>
 <4acf6df8-8cdf-4f71-830d-9233db151b2a@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4acf6df8-8cdf-4f71-830d-9233db151b2a@kernel.org>
X-Rspamd-Queue-Id: 1EC23140006
X-Rspamd-Server: rspam12
X-Stat-Signature: gn9farwt47tfxhzmna7ripkg5cc9qxt3
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794298240-898196
X-HE-Meta: U2FsdGVkX1/DXy6ICiU045uuGXKDuklMctd+aGE4cYhmjH6LXFqIq0FF7GWd+ABmGA4lmt1UzbabguNquGiKdHFPx4gzsQV7+lJ5g8lhdu1lLdNwUwYDiHe6uHZueT1VSNNZM0TGuDXkFamaJSmy6aDgDcZjHQiikDuFbfC5zDVANEfbmswwjsub6L6PS8I0awIfW4GnigeZ0BH5Eo8ow9kvhdFTRDqY4Epo7SBCIK361QEnpvQQOYFDVlomFJDfVrQO/ydarAxHYvo+gGVlNb/+3rVme2sYcp+2dLb7/pJkDzBn4IUl3xEYLwV9862H9Omh4g6Qz1ju1+INlKurka5geqTR34Pmsj9xjZG5Jv0AOV7cQL0xQfeLZtKprUKqTmgzTW65KGvGIfR4Ga+tsLl7RIrfTxtBBnw2L1Yht9Ju3tA+UHVJr4niUSeBWphBSkOeDOpzqQWmNPF9bAf05s/bZetFodlBQjTeqUxwx51lIgymDFZ8yMWBiUCvXAlCTaHKr5KYvA1ehEgLs8hm0A48y6AFg7c1YkumqyYh/7f9uZLYWqyWMPyzkcjBbg9B+SZYsQxPM1I/ysVyCR8IAhWbvKfBtDs3DC4/LcVdrmDTXsa1c5igFd2/Ek90eAzf93htCiKZXxZ1/6PPSM0H77l1YaFB5j+FEd+ElhzIdm9o5efXbqS5dMEcEXbsABU/DjIujVh31m+NX6UnoL8jTD7VBiWc9PQcdamllKSPLQENMxa0CD4RmEk65Q6x1m/yXBjLsTUB5VCquvGM768AaUJouigdZdfT7RlzTIyOUnKkCqZtn7OLLmxJva//wVDSyHpb6FXdmAhuHDhdt//g/u1R/8ohBbwVtMxGEGeXc6jbTJQdexq+YGRiPKwDvwwEriX/j1sGHqgXuW52al4rIfeF3s6BcBtSgwRM6RoeEKbBkb0lenPrxVr1bfuPaf4Oq6KWVrw74Nnpk5EovnQ
 0Ek71ILc
 1b02fsqmGEhwQuZ4Cr1EVnn0M80hDqRMwqOKYKmmLBS/49/A6PCfBOMwKFM6eFwkXWZvmGJuDVZREDhqr91vET9AZjaIqrR79C8q8uaTBLyAKON5Hw77tdUcQaeKkfMj/erzV/xIQ8ub0to+2oakiOe3MOUYsgEXQCNsp9QJlKPn684LO3mN6mbhwBs48q0Y+34Vzqj2LJzuee0/CI/Wa9DoH3m0suNunAoXn3QeIZYS//v90O8uFXwyztdRDTLbeYOwG/La4oxEziWPK5b/iWneXuvxNb3AHTjoNpSTUYAQdQ4J9KkaT8tuRtix2EkFjMUTmucSNfsbSiY2zHVlUVkM7mtX3WFpaU+yQRe32y+WPPiG9oGv5rWPgDjbfGpXVdpyRX3rxj0uW+lde0vgVnClY9u/ohYRSzADrs5umktv9PoNjTL6myAyDCW+gjG4Q+Y2SmUBW/uiehkRT1/44tPkv6AzzJPSRWh4Gpmus7ufm7baFXpu+8JebUg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 09:56:20PM +0100, David Hildenbrand (Arm) wrote:
> On 11/6/26 13:56, Mike Rapoport (Microsoft) wrote:
> > When cma_declare_contiguous_multi() cannot allocate a CMA area as a
> > single range, it falls back to collecting a list of up to CMA_MAX_RANGES
> > largest free ranges above 4G, reserves them in memblock and adds them to
> > cma->ranges.
> > 
> > The list and subsequently cma->ranges are supposed to be sorted in the
> > order of base addresses of the "allocated" ranges.
> > 
> > This implementation has two bugs:
> > 
> > * The allocation may fail even when there is enough free memory because
> >   list_insert_sorted() sorts the list in the wrong order.
> > 
> >   When the list is full, the largest range is evicted rather than the
> >   smallest, the final list is not sorted by address, and the smallest
> >   ranges are used first.
> > 
> > * the function may report success while it reserved less memory than
> >   requested because sizesum accounts for ranges that were skipped.
> > 
> > And overall it is a lot of list management and open coded range
> > selection for no real gain.
> > 
> > Replace the current code with a loop that finds the largest free range
> > above 4G, reserves as much of it as needed and repeats until the entire
> > area is reserved or CMA_MAX_RANGES ranges are used.
> > 
> > After successful alocation sort the cma->ranges by their base address.
> > 
> > The new code scans free memory once for every range rather than once
> > for all ranges, so it is slightly slower, but it is way simpler and more
> > robust.
> > 
> > Fixes: c009da4258f9 ("mm, cma: support multiple contiguous ranges, if requested")
> > Reported-by: Ivy Lopez <skunkolee@gmail.com>
> > Closes: https://lore.kernel.org/all/cover.1792032699.git.skunkolee@gmail.com
> > Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> 
> [...]
> 
> 
> Quite the simplification :)
> 
> >  int __init cma_declare_contiguous_multi(phys_addr_t total_size,
> >  			phys_addr_t align, unsigned int order_per_bit,
> >  			const char *name, struct cma **res_cma, int nid)
> >  {
> > -	phys_addr_t start = 0, end;
> > -	phys_addr_t size, sizesum, sizeleft;
> > -	struct cma_init_memrange *mrp, *mlp, *failed;
> > +	unsigned long size_mb = (unsigned long)total_size / SZ_1M;
> 
> Nit: could be const.

Ack.
 
> > +	phys_addr_t size, remaining, size_align;
> >  	struct cma_memrange *cmrp;
> > -	LIST_HEAD(ranges);
> > -	LIST_HEAD(final_ranges);
> > -	struct list_head *mp, *next;
> > -	int ret, nr = 1;
> > -	u64 i;
> > +	phys_addr_t start = 0;
> >  	struct cma *cma;
> > +	int nr = 0;
> > +	int ret;
> >  
> >  	/*
> >  	 * First, try it the normal way, producing just one range.
> >  	 */
> >  	ret = __cma_declare_contiguous_nid(&start, total_size, 0, align,
> >  			order_per_bit, false, name, res_cma, nid);
> > +	if (!ret) {
> > +		pr_info("Reserved %lu MiB at %pa\n", size_mb, &start);
> > +		return 0;
> > +	}
> >  	if (ret != -ENOMEM)
> > -		goto out;
> > +		goto err;
> >  
> >  	/*
> >  	 * Couldn't find one range that fits our needs, so try multiple
> > @@ -572,151 +556,56 @@ int __init cma_declare_contiguous_multi(phys_addr_t total_size,
> >  	 * aligned to @align, and a size that is aligned to
> >  	 * both @align and @order_to_bit, things will work out.
> >  	 */
> > -	nr = 0;
> > -	sizesum = 0;
> > -	failed = NULL;
> > -
> >  	ret = cma_new_area(name, total_size, order_per_bit, &cma);
> > -	if (ret != 0)
> > -		goto out;
> > +	if (ret)
> > +		goto err;
> >  
> >  	align = max_t(phys_addr_t, align, CMA_MIN_ALIGNMENT_BYTES);
> > -	/*
> > -	 * Create a list of ranges above 4G, largest range first.
> > -	 */
> > -	for_each_free_mem_range(i, nid, MEMBLOCK_NONE, &start, &end, NULL) {
> > -		if (upper_32_bits(start) == 0)
> > -			continue;
> > -
> > -		start = ALIGN(start, align);
> > -		if (start >= end)
> > -			continue;
> > -
> > -		end = ALIGN_DOWN(end, align);
> > -		if (end <= start)
> > -			continue;
> > +	size_align = max_t(phys_addr_t, align, PAGE_SIZE << order_per_bit);
> >  
> > -		size = end - start;
> > -		size = ALIGN_DOWN(size, (PAGE_SIZE << order_per_bit));
> > +	remaining = total_size;
> > +	while (remaining && nr < CMA_MAX_RANGES) {
> > +		size = cma_find_free_range(align, size_align, nid, &start);
> 
> That's more a memblock helper than a cma helper :)

I'd keep it here in order not to encourage broader use :)
 
> [...]
> 
> > +	/* allocate from lower addresses first */
> > +	sort(cma->ranges, nr, sizeof(cma->ranges[0]), cma_range_cmp, NULL);
> 
> That's nice.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks! 
 
> -- 
> Cheers,
> 
> David

-- 
Sincerely yours,
Mike.

