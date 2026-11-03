Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CE9606A32C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 17:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IuGtwCYS
Received: by kanga.kvack.org (Postfix)
	id 99C5E6B05B9; Tue,  3 Nov 2026 12:01:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979AE6B05BA; Tue,  3 Nov 2026 12:01:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 889BA6B05BB; Tue,  3 Nov 2026 12:01:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6CC06B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 12:01:07 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51DA5404CA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:01:07 +0000 (UTC)
X-FDA: 85394422974.23.26838CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 70F5640010
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:01:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IuGtwCYS;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793725265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wqUvTXfukWXNzOCriNVHhFLZ147TTmxYwIoKaQEo0dQ=;
	b=WM8MpxWwwjc2EACic/AQRqm1Y5v0ZuEww7F/WUcXmSid9sK7DsH5Wj11siiDwE/1/sGByH
	UI+VUfvsRhU9MXkhz9FyXcH0r2bqftwPE5fGLhjZbJxdmpuHvC0TS2dz5cSsz8tg6Fu9gq
	ok7votW3ZRGzpBlcx+y98Gj4iW97+dc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793725265;
	b=hn6KrKsAobQwuaAg4T6NH1AEwWUoeW3mkjtEszgge9w9Zmf7MLJ0ZCSQDxjYVkzeT92Hdf
	J+fmgUNWfoqn5NS3YWv9j8xDQ03H5e15gOrvRIp0LReANFGCvdT1a8SSWUyicvLnLx2HJ+
	4Lqfz17nz7YIySvx+EmL8a6wFadEOnE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IuGtwCYS;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B45BE60136;
	Tue,  3 Nov 2026 17:01:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1A41F000C1;
	Tue,  3 Nov 2026 17:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793725264;
	bh=wqUvTXfukWXNzOCriNVHhFLZ147TTmxYwIoKaQEo0dQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IuGtwCYS8X5aygLJmD5gCSCrg4nEfgzGqpox6wW6mjjUVvWzLybK67dvHxyGOqdEH
	 yeU5ZpJeMqVbVO03qEMAxxIOlobDgpA/jxoT4cpv1JkQPeioCLBIM43pC+Tls5I9wp
	 v2y73whOt5ZWNRVIMFC4rbNrEfZu50SkCCKFHANhUXGWHKlLSn4/EQj4VaDavZFiPs
	 oB8HOPcNvHfi0JokBTShLxYv8Li3O6kkPi94E2duvwn6AvmFq63TYtR0Xwap9PGWIC
	 3Jtpp5fHN0DXSL8l1VjX+sYw43NzlHlINi2M1zH8czg55i8ahvmATgu78aZPkcZ1e7
	 2mWeWLfA4ahuw==
Message-ID: <0f7a599b-0b22-442b-bfb3-435a85abd550@kernel.org>
Date: Tue, 3 Nov 2026 18:00:56 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/4] mm: gup: batch PTE-mapped large folios in
 gup_fast_pte_range()
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Rik van Riel <riel@surriel.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261102-refactor_gup_fast-v2-0-bc1ac018c834@arm.com>
 <20261102-refactor_gup_fast-v2-4-bc1ac018c834@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261102-refactor_gup_fast-v2-4-bc1ac018c834@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 70F5640010
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: zi5fhbmdtxtgere5bbsn5ccqt4ejqecx
X-Rspam-User: 
X-HE-Tag: 1793725265-113463
X-HE-Meta: U2FsdGVkX19UtsNnD3JRjON1Bgeao014Xv0XTjQL1kyHP9TkWLcZAwp+2IAnxcX1OcEb6s1q4g3mUoGR2RJ6SLuWDeVKMaZ1TVa98ed9cEyzEaXXx9IdsJ6hkw2LZ4KgWVKI+J2j8wT6a615ZhgCHvQ4AAtyUhGps5xbmHMTQR5CPY9/YG/gqXVcoNsZneSfueow7jOr+jnQu9JyBejS/cCI5qW5nRE7D/K/IGz5urUkA2lsJI0I8V3si+gT8JIPofAHHyIU1jDtqOei4SiRKkbSxEPQZPGKQkSSzKPBzSDKz0kd8927d+DbUiT+Tmo3T7gGjY1EMdM1fBvgIpWqAA5zJ+zM8bAxM3u11RqWimmtKDNr5XeXWThT/aEH13+KB88wL6OoGiUjbcAYmiuK7tOeGipdcixTjFonUr6sq0lWEW3SOH5XFkHuiKFH06a+f1WPW6A85f0iotL0SiCMWTprmCdk6HlX9xf8rV9pNmeR6HzNoHgEs9pgDMixwu1KxqzZD2wIC/g+Gt3PgvnkcRog3BA1Z8MoFJcR/K+NxlzyO51dCCq/ctj5HsFsZ7h6ADWslPKS0dosDmPmpmQGIEB9ZisAx1Bb3lkwdGvWYOwR+zaVMmgq3OtSnzwOrSysmTEfY2K4hGgG53yNPP1rZjqhJKLhxI0mqzgEUOwKaQJ6U/msU2fM5mqQV7wVBWnygEwS48PMCj7H/GlkxQluzjFYnz5LiN6EiFcBYNxfaWAQkNZEFjOBryrM+WmqUgtU2Odskf48C8ndg354TSLvgYkhMDYZWNUb6jt0H0UNM2c3fGNSRBO+6UPjS+HuLnmXYw4KdMxkU6rW7RA5pmZraEAqap7zedkPOrcTNOb1waEL402WFh5fbD95FVJ74ah9OJMdjYHTnSN+WsxdciHWbYV8+JCgHQYKe0orgHrmtppoDsz0LqCgGzx3p18buE2VIn8vl/sLlgnn+UgUDkk
 CckEOOZP
 5yWNNIIaOoWmjo+hhz47vDl7ytSDDfyDh4urg4hEQIvg5ByOfNH9ZEPBjZXiNfx75p1sdBFflrLBfEIFQmlJbT84Pk/E20DP7mF39FY6nhc6tGEqD5Zonj0z9fBZxJwnnOTYze4fCIcQa59PeD87zaP/qIV0coDV0sfGbDTFOqa7JDWpr97AVf/lS/1ZZdFv+PYIgXVpN6gNZ+wjb/Z2mY5lSYIF6zIN5f6lOI6fpBAl0zZb/WAx0uFn5rGI/+8cJYqYQTdLrLug1ROXaZzxrGImJ0wk6nWxPqEfvKd/lXhHNKKMZSaHaDFTtg9ou9z1xPjEV1q3eSpnj58KujyqVUeCaTxL6gMaoIGAyUe5+xka8plqnOcrNj0bKn1A4Ng/TtP00gtJK8HBA50I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/2/26 12:30, Yeoreum Yun wrote:
> GUP-fast grabs a PTE-mapped large folio one page at a time.  Every PTE
> costs a try_grab_folio_fast() (a refcount cmpxchg, plus the pincount
> atomic, a full barrier and a node stat update for FOLL_PIN), a
> gup_fast_folio_allowed() and a folio_set_referenced(), so a 64 kB mTHP
> pays sixteen of each and a PTE-mapped 2 MB THP pays 512.
> 
> The users are the hot ones: iov_iter_extract_user_pages() pins every
> O_DIRECT buffer through pin_user_pages_fast(), io_uring registers its
> buffers through it, and so does RDMA memory registration.
> With mTHP those buffers are PTE-mapped large folios.
> 
> After the head page has been grabbed and verified as before, extend the
> run to the following PTEs that map the next pages of the same folio
> with the same protection bits, take the remaining references for the
> run with try_grab_folio(), and fill pages[] from the run.
> The PTEs of the run are read while the reference on the folio is held,
> so the folio can neither be collapsed, freed nor split underneath the scan.
> A read-only run of an anonymous folio stops at the first page
> that gup_must_unshare() rejects, so the per-page exclusivity guarantee for
> FOLL_PIN is kept.
> 
> folio_pte_batch_flags() does the scan.  It reads the entries with
> ptep_get(), which is not safe without the page table lock on
> CONFIG_GUP_GET_PXX_LOW_HIGH (x86 PAE, mips32, sh) or with arm64 contpte,
> and GUP-fast reads every PTE with ptep_get_lockless() for that reason.
> Add FPB_LOCKLESS to make the helper do the same; it is inlined per call
> site, so the other callers do not change.
> 
> The order-0 path keeps its instruction sequence.  The folio flags are
> tested before folio_set_referenced() on purpose: a load of the flags
> right after that locked instruction cost about 25% on order-0 pages in
> the gup_test benchmark below, and reading them first brings that path
> back to the baseline.
> 
> gup_test ioctl over a 256 MB anonymous region, FOLL_WRITE, 65536 pages
> per call, median of 15 runs, two baseline boots / one patched boot, on
> an x86-64 VM:
> 
>                        get_user_pages_fast()   pin_user_pages_fast()
>                        before       after      before       after
>   4 kB pages           849/789 us   783 us     1174/1138 us 1094 us
>   64 kB mTHP           812/811 us   126 us     1215/1113 us  188 us
>   1 MB mTHP            799/774 us    59 us     1185/1077 us   64 us
>   2 MB THP, PTE-mapped 803/786 us    57 us     1159/1120 us   58 us
>   2 MB THP, PMD-mapped  42/40 us     40 us       46/41 us     42 us
> 
> fio O_DIRECT randread of a null_blk device (CPU bound) with the I/O
> buffer in 64 kB mTHP, median of 15 five-second runs:
> 
>   bs=1M psync                 126.2/125.6 GB/s  ->  220.6 GB/s
>   bs=1M io_uring, iodepth 16   71.2/71.6 GB/s   ->  112.1 GB/s
>   bs=64k io_uring, iodepth 16  50.2/50.7 GB/s   ->   60.1 GB/s
> 
> IORING_REGISTER_BUFFERS of 1 GB, median of 15:
> 
>   64 kB mTHP           6179/5998 us  ->  1599 us
>   1 MB mTHP            5790/5801 us  ->   893 us
>   4 kB pages           7173/6741 us  ->  6763 us
> 
> Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---
>  mm/gup.c | 46 +++++++++++++++++++++++++++++-----------------
>  1 file changed, 29 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 49681f63950ec..94a9dc45e5953 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2901,7 +2901,8 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
>  		unsigned long addr, unsigned long end,
>  		unsigned int flags, struct page **pages)
>  {
> -	unsigned long nr_pages = 0;
> +	unsigned long nr_pages = 0, nr_batch;
> +	struct folio *folio = NULL;
>  	pte_t *ptep, *ptem;
>  
>  	ptem = ptep = pte_offset_map(&pmd, addr);
> @@ -2910,7 +2911,9 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
>  	do {
>  		pte_t pte = ptep_get_lockless(ptep);
>  		struct page *page;
> -		struct folio *folio;
> +		unsigned long i;
> +
> +		nr_batch = 1;
>  
>  		/*
>  		 * Always fallback to ordinary GUP on PROT_NONE-mapped pages:
> @@ -2937,19 +2940,21 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
>  			goto pte_unmap;
>  
>  		if (unlikely(pmd_val(pmd) != pmd_val(pmdp_get_lockless(pmdp))) ||
> -		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep)))) {
> -			gup_put_folio(folio, 1, flags);
> +		    unlikely(pte_val(pte) != pte_val(ptep_get_lockless(ptep))))
>  			goto pte_unmap;
> -		}

As discussed, we should really add some more details why each of these
comparisons is required. Let's do that in a separate patch.

(I recall the pte check is required for concurrent PTE changes like
unmap/protection etc and the pmd check is for THP collapse on architectures
without IPI during TLB flushes)

>  
> -		if (!gup_fast_folio_allowed(folio, flags)) {
> -			gup_put_folio(folio, 1, flags);
> +		if (!gup_fast_folio_allowed(folio, flags))
>  			goto pte_unmap;
> -		}
>  
> -		if (!pte_write(pte) && gup_must_unshare(NULL, flags, folio, page)) {
> -			gup_put_folio(folio, 1, flags);
> -			goto pte_unmap;
> +		if (folio_test_large(folio))
> +			nr_batch = folio_pte_batch_flags(folio, NULL, ptep, &pte,
> +							 (end - addr) >> PAGE_SHIFT,
> +							 FPB_LOCKLESS | FPB_RESPECT_WRITE);

Batching after the checks above, when we already stabilized the folio by
grabbing a reference should indeed be correct.

Concurrent collapse should already see the raised reference and back off.

> +
> +		if (!pte_write(pte)) {
> +			nr_batch = gup_unshared_pages(NULL, flags, folio, page, nr_batch);
> +			if (nr_batch == 0)

!nr_batch

> +				goto pte_unmap;
>  		}
>  
>  		/*
> @@ -2958,16 +2963,23 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
>  		 * see Documentation/core-api/pin_user_pages.rst for
>  		 * details.
>  		 */
> -		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio)) {
> -			gup_put_folio(folio, 1, flags);
> +		if ((flags & FOLL_PIN) && arch_make_folio_accessible(folio))
>  			goto pte_unmap;

The label is now slightly misnamed.

> -		}
> +
> +		if (nr_batch > 1 && try_grab_folio(folio, nr_batch - 1, flags))
> +			nr_batch = 1;
> +
>  		folio_set_referenced(folio);
> -		pages[nr_pages] = page;
> -		nr_pages++;
> -	} while (ptep++, addr += PAGE_SIZE, addr != end);
> +		for (i = 0; i < nr_batch; i++) {
> +			pages[nr_pages + i] = page + i;
> +		}

No need for {}. Rik will replace that with a proper helper later.

> +		nr_pages += nr_batch;
> +		folio = NULL;
> +	} while (ptep += nr_batch, addr += nr_batch * PAGE_SIZE, addr != end);
>  
>  pte_unmap:
> +	if (folio)
> +		gup_put_folio(folio, 1, flags);
>  	pte_unmap(ptem);
>  	return nr_pages;
>  }
> 


-- 
Cheers,

David

