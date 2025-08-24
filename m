Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0912CA0FE8
	for <linux-mm@archiver.kernel.org>; Sun, 24 Aug 2025 13:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CA4E8E0009; Sun, 24 Aug 2025 09:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07B928E0001; Sun, 24 Aug 2025 09:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED31A8E0009; Sun, 24 Aug 2025 09:24:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8B768E0001
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 09:24:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84EF81D3192
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:24:54 +0000 (UTC)
X-FDA: 83811721308.15.EB6C91F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id C680F18000A
	for <linux-mm@kvack.org>; Sun, 24 Aug 2025 13:24:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SquWihWK;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756041893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTgVSQ/agc49mf+WMVj/m/VVuvPKZX5i68p4dayRd8w=;
	b=UukvlV3pQseopq2q3IAkd//sDeXWdGOzpeLyKPGzUL2tZQAYkduV0jVP7reFSFgjcLClFF
	sQR3yS+VE5FYIxYTFOEPNfUf/OrIhAGg2vyBsLgmNh0+4TDhtROkXSKNGB+KfVgQT9cDld
	OknJZp0l1TCxGYIM5yLWMBhit1EICdQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SquWihWK;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756041893; a=rsa-sha256;
	cv=none;
	b=5U+/LyRXUDoj5qyLhDYtA3mGX3dH+i6atKMT96e49SVO55wRpaYKMZLGZiPS9IBM/AC3Sz
	iIDJCPG4hjEy54Ay+fefgNMFYIHJ2YbgQNGSMBhp2Ej6W2MBFg8+gKByfNSIa6ex4opDSL
	yigu7SItsAI0aIXhmRZdplTs9ICgsdo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D3EC43442;
	Sun, 24 Aug 2025 13:24:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4638C4CEEB;
	Sun, 24 Aug 2025 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756041880;
	bh=ULWSWvx5qOQocuXhhEVwmUdZJ/jQrpo8zzXV1kr+XYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SquWihWK3f+VpRPVHREvb/KU1Ip2U18TP7N1MuJITOAx4rQrPZH3cvqtkOP5SvK7q
	 i6NO1TPVUbZk8RWkAk3LTCsFqBTBZ14HIKev8nasvhFuIsLkIUiO3cKzio2Q51II/F
	 wyed5FtAlddWEWPif7U0YGP0VU7Jz0WnTx8oiBRZXCVwF7SJXztCvl7h61L8oudm/m
	 ZzJcPQiQ6a3vkdslZGaL+map5bzuxrOH69hNlp4a8gDkADVHKqlXnjP6H9fUKUPAle
	 G5RP+5YSDJFPCZAOfsIK30ngRx5fl+uNMhMZuFtvohYRU68gjsyw/nUrRlnisE/5CR
	 1GDLoGVBUCvXA==
Date: Sun, 24 Aug 2025 16:24:23 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 12/35] mm: limit folio/compound page sizes in
 problematic kernel configs
Message-ID: <aKsSh0OEjf4GLmIG@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-13-david@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-13-david@redhat.com>
X-Stat-Signature: 3u635bh8qc519bser9fh7bmtophkg5u5
X-Rspam-User: 
X-Rspamd-Queue-Id: C680F18000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1756041892-359013
X-HE-Meta: U2FsdGVkX1/bSabyEmi3Sf36ClVg+2ZXXM3Nj5Ga40A9RKOlkTKvnxNkaBYKECouFNT5RANeeAzY7SvJyKjY7Dsa8D0iyFQC16eH/vusENWIPclyDuHS0tXV62WWze0aZBq866jTIqGleunYtkzWRjhmX0NZi3Wzw3cNkgv3adIgb7vnWvHaDhRa37xaJqDCeXzRjEVGccjFecbOTf9X8grCPqNwt/YbLi1zmGB1rcqtoVbYXwaki4WtC3J2vZqMzDAOq2jeqsN429OI7IAjnI/DY30ADMT3znJQvHC/shdQEI6fwXE79oAwYoSDrkBFo/yztI+IdegsPRjzw+RFglhUl209hYnjMoHaBE8Lh7qaV1v981unNQX4k6XC5W4jfW8tgR1MRzjTpP1tCpoOsJ4c7SMirLeSJFDwL6qo6GPO6ORhJAA1dWnYLoCWGZRxUnoGre4/KHmcoXQeDVavnyc7dTwlhe3YiLzIyeBRzyqaFASp0y4Vom7cBs9ANsBDSmUqlh8gXKcgTZsOn7G6lsiEYPTPhF5YyJ1dxHEuZ0eJLO06MpFGibSFkG6wnsmjb8XDRMVi9PVEN29ZTxAxiSCbt5CbLkz9MsFm2bfwf4XQx8LLPDilUmteREwNloTeCW9tAJsA/UHnPBAkSr+9pCqeb5NetuVLP3DCpn3HiKyRGuzPTHcPVLHEpN0a+sXxZeAJJarCi8YN43KVs7XknVIFrPKkzZ2KnM59kC6DeWCnHVOQ+Rf/6iCWQ7uu+NysZsj+9GCXBfC+gnXx7C/V8VzmZhP4igmo2Qo4TTokt912JX4qbhxMdhpkUymQ1aKf1Gks/tRy+3s7tosXA+3suvP0Fj8HXRRaCGSOsWuJjuwrnv/lH3fOBP3q0gwQmQObG9xS1a3Ow9IvqGdVdnw25L3ztUrz2xRohdzd6xF7kiQFvtS0CkywKcNu481ztWvhSgf16AmSG7pTwY8Gyr4
 cf8i6TwZ
 W0iJB+Z9klgE3VeZPrr/xb5TNn/9IIhM4lYnYhPbh1gJQkG1mvWQnC2adFgshsKYFEWGliYF7wr+IgzeFShTTZ80cWyWVILfwR30pePU7SHyu8aHPFv8/uX6tVqLQiXIDfAFWHZnjKDbXv1U+KKctdcn7ZPh71tix8KgIZpLAsGr08PieRkl4rc4brxV4nq9ElrflJukDdJaN5EXH5gl8zh0yfBhbGogndm5jrl7GBtTvrTUn160wqoqL5zMG0TbRbJ4tyM3mXOvUNwOuKyMDGxqHqDXi6xxvvgFd1LU1D7BngnQfpu02LbvgoN0+jaesfdRSZtO5ZNuG6qI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 10:06:38PM +0200, David Hildenbrand wrote:
> Let's limit the maximum folio size in problematic kernel config where
> the memmap is allocated per memory section (SPARSEMEM without
> SPARSEMEM_VMEMMAP) to a single memory section.
> 
> Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
> but not SPARSEMEM_VMEMMAP: sh.
> 
> Fortunately, the biggest hugetlb size sh supports is 64 MiB
> (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
> (SECTION_SIZE_BITS == 26), so their use case is not degraded.
> 
> As folios and memory sections are naturally aligned to their order-2 size
> in memory, consequently a single folio can no longer span multiple memory
> sections on these problematic kernel configs.
> 
> nth_page() is no longer required when operating within a single compound
> page / folio.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 77737cbf2216a..48a985e17ef4e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
>  	return folio_large_nr_pages(folio);
>  }
>  
> -/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> -#define MAX_FOLIO_ORDER		PUD_ORDER
> -#else
> +#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
> +/*
> + * We don't expect any folios that exceed buddy sizes (and consequently
> + * memory sections).
> + */
>  #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
> +#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +/*
> + * Only pages within a single memory section are guaranteed to be
> + * contiguous. By limiting folios to a single memory section, all folio
> + * pages are guaranteed to be contiguous.
> + */
> +#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> +#else
> +/*
> + * There is no real limit on the folio size. We limit them to the maximum we
> + * currently expect.
> + */
> +#define MAX_FOLIO_ORDER		PUD_ORDER
>  #endif
>  
>  #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

