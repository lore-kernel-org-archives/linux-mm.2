Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CB27C531CC
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 04:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04B576B007B; Sun, 26 Jul 2026 00:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F166A6B0088; Sun, 26 Jul 2026 00:30:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDF276B008A; Sun, 26 Jul 2026 00:30:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB4B26B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 00:30:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3558D401F7
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 04:30:40 +0000 (UTC)
X-FDA: 85029651840.29.9598E6B
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf13.hostedemail.com (Postfix) with ESMTP id 69E6220005
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 04:30:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GiFdDpLs;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785040238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fk0u0C46PSOxjn1bmvTNC2VObm0AdVqBqTpTwS4dVgg=;
	b=BoS3zYmO9RJXd9p3uLcYpbcPszGNJs/KIAjkGOOasU6rxPdTnwKFc4LmcdMJgsgW9U7Gik
	zWe8Kay6yT/Ou/uIdznJfGVB0tncKHTA3d+Jme1MgINUejmlA5/2slgrd5DnsO/T2ynxON
	oUCSdyxEiX6FokaGsRrTtiaEEdu0Sog=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GiFdDpLs;
	spf=pass (imf13.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785040238;
	b=DMMGh3p64+eqXvJD8Z9MNXczNMx4matNot7JAqE3eRz21ganw0vlp0Sn3LmEBa0hsM/YCm
	Dr+xSWFXa4gDOGM4h7VDcyX8pJF5Vu4qS2JjMVbNogd7j+F21lSqLWnLoTLt6AoPclth6k
	FJOSE5dionJBmuKwXwTbEGRUYY7SrpM=
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785040233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fk0u0C46PSOxjn1bmvTNC2VObm0AdVqBqTpTwS4dVgg=;
	b=GiFdDpLsCY9O1i08dsREM5xkTYbyL+dVDaGJel+m+k75TqnYJ//NhZM7IkH78BNqN+0Ivj
	T/D3mNCoYJOIdJLpLPcHgCDLByC4Hoz+CjiLxoA5m3MA5p1hjFFd7O15tEQe2b+mTFSaLH
	9a0ivHwWzxxZsjbaxUhaWVdqbywg/pU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 03/17] mm/mm_init: skip initializing shared vmemmap
 tail pages
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260720093127.540540-4-songmuchun@bytedance.com>
Date: Sun, 26 Jul 2026 12:30:17 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <5005C7D3-B3ED-4C62-B611-8465D2BC69FD@linux.dev>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-4-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 69E6220005
X-Stat-Signature: xtrai7ogx8injyga7wr3beq9898xtwsi
X-HE-Tag: 1785040236-960676
X-HE-Meta: U2FsdGVkX1+OKoUytpePW2ZkmxpI5oWdlHGl91K0nCU0ldMKL2EJfbJVB3wdI8p+vY9ZUM/obiSdGsdYYEOHRugCjjG26nNQwnttn2N4v6krQx91SjQo1G1Sjj1+cWPbB6nUN69Vi1s3kwYQrzaDI9M0/60iGj8FdUMH/uiVxQg+ilzm6iCC0YbjZRGeB4ytgyRg8WoensGH9JQ0yk3p0fU5CuTuQaJAgGFNO1ofAerbMqBMOt+LWHJPiRlO6FbEKkyVmRZ150dvhpSy2whlDIXtDegtiW4i7OQl1I8wpq2ML7c+nIOAP1qICCUaq7DxettsjON/SUrLVCut8DB8/tyjmbOYGdNdS9jNXu0zmmNEwwN9Aovv55YVYCsYdhT1ZOV4Iu4aqzb+3gsk9JgHkVkZgA2R5IDu/u8qUtanhN53Kxmnva6du1LkflNAWgyJgE2byw5ESv+lYZ/Rq7dff22REUdwcf6FK+RounMn0O6BZ56snDQPideannIVpoafXg3Rqm/MRSjrvqAQPctcV6/xiixAsI5s5nOO3748jKCfHo8ZvhLk2MQuoNODD1SV5fTh4e/EjrBaWqfLz5g3gX/47MByzWUsg/RmmveSoid6D1FeGJpW/7kPmk1qhzTj9+jwAS3x+jXGjBLf9l1GevbyiuHABN7K2y/pXefF4hYjD62iqoTf/YI8KKlCwRAxwPSwdGnD2LLL7PV8+0eQ4+0RXPXvnHxRF2MJdZwI5mS5RGn6MinvyBWNC5II9LDyZOJS6C9YEJl1v8fuG1AAukHHMSJ6G0SLsWGpBtYrcyZW3r0j05NT2Whrpv6n/D2xsLTpkn5cHJRYJs2hgC0zq9Ino3N/NOAH8S1B3DnfpXxC/s+WpJ48GIGP90LvaqallpzqGhVWws2WSd5jg4wXGuzDtQlErwot8PQP/5YLjz/f88ghTgMBRQHB31dh0q9zanxbVXvuY7CnpmYSCCi
 JQgmdbs3
 lXbauPXIVomDUlmsnuXrVm5ISRT3PCq+yhnd6dbon2YICf761fonKSzQOWaTez5vIJvHx0Jsqq/dbATB8Bj/7vhSiKm7kNAMIOH/rztzH+VR46kg7/7FYeTUPk6Mj34Qj1Qmx90iAo4LIkw2hI+7/mUpK+X7la46+2wDaiSKlSN7b+/HnLOUYX0974pN+Goan6uI9XIrio4gUZzUbVyf6Ns9fFKdOQe7IX7hRGcrmHRbOOi/9f3qj+FBMYUjolLjv4hY2QyDHAa8xExaW4zpRNBMdhBGg1cYTIVrCEEm3KR0NAMHAD31OkSgSVx8vGVDD69TnhHF3nW5YMW1sk7okxwl+NqrQ/b65O1pnXcjRcXhlhV6oqA3fqlyuTGEwPepK2LIf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 20, 2026, at 17:31, Muchun Song <songmuchun@bytedance.com> =
wrote:
>=20
> memmap_init_range() initializes every struct page in the target range.
> For compound pages with vmemmap optimization, the tail struct pages =
are
> backed by a shared vmemmap page.
>=20
> Initializing those tail struct pages would overwrite the shared
> vmemmap page contents, requiring users such as HugeTLB to restore the
> metadata afterwards.
>=20
> Track the compound order for HVO-backed sections and use that metadata
> to detect struct pages that fall into the shared tail vmemmap range.
> Skip those shared tail pages in memmap_init_range(), then initialize
> pageblock migratetypes for the processed range with a helper after the
> per-page initialization loop.
>=20
> The !SPARSEMEM __pfn_to_section() stub is needed only for the build:
> memmap_init_range() references __pfn_to_section() after checking
> pfn_vmemmap_optimizable(), and !SPARSEMEM builds still have to compile
> that code even though pfn_vmemmap_optimizable() folds to false.
>=20
> This is a preparatory change for consolidating handling across users =
of
> vmemmap optimization, and it also avoids redundant initialization of
> shared tail vmemmap pages during early boot.
>=20
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Fold section order tracking into the first user instead of keeping a
>  standalone API-only patch (suggested by Mike Rapoport)
> - Rename page_vmemmap_optimizable() to pfn_vmemmap_optimizable() and
>  pass a PFN directly (suggested by Mike Rapoport)
> - Initialize pageblock migratetypes from a helper after the per-page
>  loop (suggested by Mike Rapoport)
> - Use a 1G PFN chunk for cond_resched() in the pageblock helper
>  (suggested by Mike Rapoport)
> - Guard section_order() with CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP so
>  it returns 0 when HVO is disabled and lets the compiler optimize the
>  code as much as possible (suggested by Mike Rapoport)
> - Explain why the !SPARSEMEM __pfn_to_section() stub belongs here
>  (suggested by Mike Rapoport)
> ---
> include/linux/mmzone.h | 14 ++++++++++++++
> mm/mm_init.c           | 33 +++++++++++++++++----------------
> mm/sparse.h            | 23 +++++++++++++++++++++++
> 3 files changed, 54 insertions(+), 16 deletions(-)
>=20
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 82b0155d886f..2a32101d55e6 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -2011,6 +2011,14 @@ struct mem_section {
> unsigned long section_mem_map;
>=20
> struct mem_section_usage *usage;
> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> + 	/*
> +	 * Normally, sections hold regular (order-0) pages. However, for
> +	 * sections with HVO enabled, this tracks the compound page =
order
> +	 * to enable deduplication of redundant vmemmap pages.
> +	 */
> + 	unsigned int order;
> +#endif
> #ifdef CONFIG_PAGE_EXTENSION
> 	/*
> 	 * If SPARSEMEM, pgdat doesn't have page_ext pointer. We use
> @@ -2365,8 +2373,14 @@ static inline unsigned long =
next_present_section_nr(unsigned long section_nr)
> #endif
>=20
> #else
> +struct mem_section;
> +
> #define sparse_vmemmap_init_nid_early(_nid) do {} while (0)
> #define pfn_in_present_section pfn_valid
> +static inline struct mem_section *__pfn_to_section(unsigned long pfn)
> +{
> + 	return NULL;
> +}

I'd like to propose an alternative implementation that doesn't require
exposing the mem_section. The idea is to add a new helper function,
pfn_to_section_order(), so that for non-sparse-memory configurations,
the mem_section concept stays hidden internally. I'd really appreciate
any thoughts or concerns =E2=80=94 if everyone is comfortable with it, I =
can go
ahead and implement this in the next version.

Muchun,
Thanks.


