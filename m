Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED4F3CD98E6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:04:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15A4A6B00CA; Tue, 16 Jun 2026 17:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBECD6B00CD; Tue, 16 Jun 2026 17:04:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D84AF6B00CE; Tue, 16 Jun 2026 17:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B17EA6B00CA
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:04:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2108AA011A
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:54:47 +0000 (UTC)
X-FDA: 84885921414.06.F7B24F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6054A1C0003
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:54:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gkxHyt5A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781618085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xpx08SY611J6Pr/74Bo3MmKEz6teaPqWyHRCMC9He/8=;
	b=ksH9VG+UTpBIHyLf9BqVMIPamoJAZS5erhhoOtc4s8WaD77FtLI+4Xzazhk0Yj+a7yT9HZ
	TMDwg6mEp1mCKPMW8/eChshMdxxB/XG0qu0agnnSXB6lGBPZ8OP/vnJseUd0zHzVrzP6E/
	qOYMqJ/f6pfpn8/o3cBNWMUhXh1aHlA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gkxHyt5A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781618085;
	b=yGk2+ZqHT0vIHKNNT/owCqsWuOKdHnzF1skQavKVdmzrYXRiYc9u4HFWg2ay6VWnzK1Lz7
	fsxxJky5nLGDxUH40rFJITzdzLn+4zZjBUz72zMVxBkFGvPWZRQuWBncyPsleEOMLmJny4
	j/3BNCSZWP4BcQ55Z2LDiY5W8zM3pcY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D701E600AB;
	Tue, 16 Jun 2026 13:54:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BA221F000E9;
	Tue, 16 Jun 2026 13:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618082;
	bh=Xpx08SY611J6Pr/74Bo3MmKEz6teaPqWyHRCMC9He/8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gkxHyt5A8udro5GTv6E1KYahAMFj5L7vsu05TMHtUr8KCgDFke79bpkrsHB20vgBP
	 OaItxE+Pci8Wp4HIN2U/Fy5WT2F/5EcJLaIPxPSnja9GuR/wSeGOObxGLNRuzQ1NNR
	 beR+yQLrWw2JQQT9Pd09OkioCWr9YC+1rBbi/KajsVIjXS+ZozLepELqHAjW5Uataz
	 6tp7Fo1CCSdI7RyOXrBlFo1X7E/UqHeYhkPrYF434pYFmzm/gIc1l9LhE6wFzj5y/n
	 afrxyu2x0Z0js+rlSvNgcw9vHeg3MaT39BD4dSa2NiIoMdva4KQbdw5MBIv4WTiAnw
	 8Rle5hCEjof2A==
Message-ID: <17c5f031-17e5-44c3-b572-ee224cb294cd@kernel.org>
Date: Tue, 16 Jun 2026 15:54:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 08/12] mm/swapfile: Add batched version of
 folio_put_swap
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-9-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260526063635.61721-9-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6054A1C0003
X-Stat-Signature: eyzxgw511x6jhug5gbybhw8bddps1m3q
X-HE-Tag: 1781618085-886927
X-HE-Meta: U2FsdGVkX19yF/2XI653NYh6naMxObutTvXw93kOQPprnYq0Vss2bon/Bp6YuITwa9Rv7rSMSzsgxqhiG34TPGcZ6CnEYl8IpFsqV5m4wWi4F9lxpGhaDVMk8ny+OaxvLIcn/RoopkPrB0CdMSGrySOf3QVQtgqeIGk1OfQCC8UF0KnuqdXacnLMwR1CAPN/+T/npqJWy937Uky1V1m6HoBwtCKaqBjbdCGDDDPdoU2KftKyEsm34cX64h6aJADr9Gb+0Ru33INYGIK8ZoazkeNlTV+fsiC6Ku4lUDk83GMOSzdOl0/bnYD0q5QGC6BAxNb8oXr0vV+zTfzacZoV1ZvUetMWOwJHdySKQ2Qk2pUtGE6Q5zuOvLhM/n0AysEM8TBerNN8zj61L6jH96EqL/RgD6h7BSTkl7Yynoh+0h73ciqTO2WwUfbYdkU+vkHB8oIRxuTY71DIGlVp1KaQWZDA/IkXJkuK5RcHV0wJqvNXnsHbrsVCEacU8qAmYYQwxpfB+/YlWOMATNT1iXBCZo1b+BywaQsCfmvFoc7CHSdOWBzG+SPeM9crpN9PdRr2uOLKWGr+qmAJ9nwgZjiAI386Tp1DyUqMmslsUwmKHjSmoKw9FpYWwOU9NWylPft3OI4oWu94osspaOv5SF9H5HWaMuvSmy7S0aECIX38Zlc9RzdwbG+ZP97H5ztvfkGuebXu9cr/Ce/ynPk7dsrSfbW1e5FMgMToYgoqdAXSmRVvPUELO5RLsPhCasHNFaqbGqnx1drsHKAaRnTN/rUivPql1z+zhfr2yXolSDUY5QIDLNtQNio26sWz12MCmCjqTqGX7HNNQ4IvGJZSPh2e2G//cWLW/shV1iz2v3dEIdFX1Ngc5ZIIY/WW6S0t+K6dBM+jKGmTQ3KII+JQcFOz2bAb7zhTZ3jV8bYx2pjU3eRZ6MQb/BOdaX6vsRpO6zVkz1VgtQuZCk0IqrxvOpO
 0fYf4ymb
 zu9MnYQHhfjWdj/GQ1ZuvGeDqt621xxdFd2wI/l8ChoPqoj7d9hPCGehcG4br5ucix8rMo8guN5LRuSXTpRlbVTiXErDIx8+9E81eMUDnLTMJSgahZVMRtgiwzwQQk4S4w/aW2jrJ+66tll3Bnyqh7/0c9ctCJRDKbCD38J25CbvzhdeB1fRmDcHxZsLYRcGpqncMC3xo6giUyArwKLN42WQ9PK4q8xIADTC9Ftmima4mnG8Lh1PPThWfB9ifRv/aoNKwcc/+vCshCagivniFLfaXXRlfBcf7ps+eytSeBG3zv75sJ1izZwyFSVEEUY6lImnK1tO2Bu234/+B00FG6t5yTZJvG7M0aqZpIcp5MzteIpv8hfJ1OBUzotjZgVMxLIiXorULK6g3k20=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/26/26 08:36, Dev Jain wrote:
> Add folio_put_swap_pages to handle a batch of consecutive pages. Note
> that folio_put_swap already can handle a subset of this: nr_pages == 1 and
> nr_pages == folio_nr_pages(folio). Generalize this to any nr_pages.
> 
> Currently we have a not-so-nice logic of passing in subpage == NULL if
> we mean to exercise the logic on the entire folio, and subpage != NULL if
> we want to exercise the logic on only that subpage. Remove this
> indirection: the caller invokes folio_put_swap_pages() if it wants to
> operate on a range of pages in the folio (i.e nr_pages may be anything
> between 1 till folio_nr_pages()), and invokes folio_put_swap() if it

"between 1 and folio_nr_pages()" ?

> wants to operate on the entire folio.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---


[...]

> +++ b/mm/swap.h
> @@ -208,7 +208,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
>  int folio_alloc_swap(struct folio *folio);
>  int folio_dup_swap_pages(struct folio *folio, struct page *page,
>  			 unsigned long nr_pages);
> -void folio_put_swap(struct folio *folio, struct page *page);
> +void folio_put_swap_pages(struct folio *folio, struct page *page,
> +			  unsigned long nr_pages);

Nit \tab\tab (same below)

>  
>  /* For internal use */
>  extern void __swap_cluster_free_entries(struct swap_info_struct *si,
> @@ -397,7 +398,8 @@ static inline int folio_dup_swap_pages(struct folio *folio, struct page *page,
>  	return -EINVAL;
>  }
>  


[...]

>  
>  	swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);
>  }
> @@ -2499,7 +2497,8 @@ static int unuse_pte(struct vm_area_struct *vma, pmd_t *pmd,
>  		new_pte = pte_mkuffd_wp(new_pte);
>  setpte:
>  	set_pte_at(vma->vm_mm, addr, pte, new_pte);
> -	folio_put_swap(swapcache, folio_file_page(swapcache, swp_offset(entry)));
> +	folio_put_swap_pages(swapcache,
> +			     folio_file_page(swapcache, swp_offset(entry)), 1);
>  out:
>  	if (pte)
>  		pte_unmap_unlock(pte, ptl);


We could consider having a simple folio_put_swap_page() helper. But maybe most
of these will be converted to batching in the long run either way.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

