Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D0E606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oCPQaEyu
Received: by kanga.kvack.org (Postfix)
	id 8050C6B05BA; Mon, 16 Nov 2026 05:43:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DCD76B05BB; Mon, 16 Nov 2026 05:43:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F30C6B05BC; Mon, 16 Nov 2026 05:43:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4713A6B05BA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:43:12 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2295160521
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:43:11 +0000 (UTC)
X-FDA: 85440644982.25.E32A62F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 168421C0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:43:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oCPQaEyu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794825790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2mPmAY7zwrcecu1heIJ2BvdNaHui2QL8RC2C/8dWPU=;
	b=pP8L2it0+5/XaOX/UOOU3MB43sErmdJWU3OL43J3C7NVPWjeWsN+yfyl9wqcK1cTaDkQBC
	AKfPQW0snmHUadyzpdb1Gg1GczYlVkd7ugJfMIfX2lwl/uz+yTlTdPpWaB34ZiEHpc6vUA
	KS4PDxZZdNqZfFgkIArCZgcNzOr1gmU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oCPQaEyu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794825790;
	b=PB4z6CsSxfHw0rSUQMHWbZhhI5AO4wrBIkjuhrRXGrPn0iqJuCZzl8mEbW+hMNeEst4ZAR
	R+jYrwEQebHPsBWQq/A3nbjPGxnvLvXgOzRJV0/S+F0Zu20IfkTVBON4oJbEONGGfeosy6
	2WqvokSTDv29zS2tmK/txdIqFMN48+M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A9FB361358;
	Mon, 16 Nov 2026 10:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613A91F000C9;
	Mon, 16 Nov 2026 10:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794825789;
	bh=D2mPmAY7zwrcecu1heIJ2BvdNaHui2QL8RC2C/8dWPU=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=oCPQaEyu7Dw7pDWc6HhM89NOVPmqfWZvd8EZKHjqBBIVjtvzKNE4g4/OIKYeFxrOa
	 5aXtZ8pERlSoaF+67JMoZaOFmqfVMN5650dukmH8w0+Smz2ytGmvFzfDWxpvqO2rRz
	 Y05Qb/NnMYS8UKI+kxS+JxMp6AKC9bXF8a0ChPeovZKbvaDwzmQLM/pI/rB8rJsJQ+
	 BkKptcBIhMVBSManwdXhnD2IfL+cGOdTiM5DTX7O3ouyjrgo4QHDazlvttK9Jk+aIB
	 NQQChSP+RJWA5NQqnE/580z30qopKQXOVEmYc6MKAAjU+OAXI4jwX5q9KnQh09gzFG
	 qDp+yZpgquz5w==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 06/14] mm/mm_init: factor out frozen compound page
 initialization
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261113033442.62970-7-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-7-songmuchun@bytedance.com>
Date: Mon, 16 Nov 2026 12:42:48 +0200
Message-Id: <179482576829.2379196.14870002582501235383.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 168421C0004
X-Stat-Signature: n8zzjas65n7pkqqzgz3fjumxin35kjfx
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794825789-821491
X-HE-Meta: U2FsdGVkX192jZohkFNWqAluI2Ipv2tOrNmfKnQzz1I5pLdaGL2zjmudPue5qPqk6aHKTfhK7i5u+qaVuao+NwuLTGTPUqWAHvsa1lBSKhlvAyFR3bVTnH3shLTYG3g3P7oW/jqCRR/FRhCTomeMqnSGrmBCGFcuAhf0kxvoJYAI3cZgVO0B2Vr4RZKnI0OS6ajkiYEFzbgPhwK5lZK1AeTzxCs4zMMHnQFBskLid0EIgU5co1ooQ8nPrJ1/hL5hg99b5IT5+eJEHtvse61AeR9NUsZnnxoiJW5l+KkmESQWuzzFhGeYP0CZ9aevDLPbF/qLZdu/Xc1omXiWJjdi9KOxn2ygNV6O4Ip9N6X7lhvVJvgOtBcSbgwno2/+Q/9M/Q107SoPlEzk4YYavhucJ0B8xHYHms4DbU1b8z2jfQ5t6+RdzoN89GMPu5AQ2RDvrjikYru5RbN+7tgE8hMutYuOONiDEdMKu3T4LhACAuDwwsp3xWXtIgA9enfeGEfmnxdbIDb/TDX8cZGtAGk8lFDHUsDVVJe5lVPciHD47Nk3T9IU2v121wDI40pS147c+iaO73sQBnUM+yaK/W60/mVsnPF7jwbctP4Bdw34yf53yM8hl2MJx16ysVDAzQM2nFULRT7LzDysmKwoCYNLD2qcfKeWGK2KusjdPRJU7nU3wC6bR58rRhpUHXPJETrag08jNhKLNxn50aqUvvWPV1kyjb3Qk3snWeVawX91hH3H2AqyGUN7TWnK3m0TJpbEDXyycY4GnELnneciuuVZp8TaAP+r1P1JhTAEq1ML21Kvk1B4H8WINrIVDTbEFstxrUL69CsnxGId1ffbPIx2aRcr896CV0uo8QeuwH6zQW04IVG8H9sCSYtEheiVZS1VNhrYjFXRnfIZTHa4F3RqW8+tyik0yu+aYrsXWIXlxiN6Rcl7dTzW2g0LZM043oA8qrrLHf35uEegl5c7SJG
 o/LXN4wp
 WqOeNM2/mZIA0TtH5ABJO+s9GX6QlNw4iu0W4V01w/e12mOX0Olqe3areydKy1OG6YXPZzqzYaqjRQCR3/m3EumJZhealvpUE73x5rhINY9CIfrf2gRlrkHGFPGBgS/gBO1r638Bxy20aj4KRzX3Afa41kfxJQSwjElYCHzOCXzLTF0L5ZMhQtXjMRuu1C8Gx2a0oPkb8D1DKmaEx28OXsH+akCjuLqyOX9StqUnx4i6xaeSlrTIk9bsBCB7I46SH8b6Emx8q+w8Ku9xQaqn4uuVq+k4SS7iChKi0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

> ZONE_DEVICE initializes compound struct pages while their refcounts remain
> frozen. The setup is open-coded in memmap_init_compound(), including the
> per-page initialization and compound tail preparation.
> 
> Factor the common setup into memmap_init_compound_page_frozen(). Keep the
> pgmap association and MEMORY_DEVICE_GENERIC refcount handling in the
> ZONE_DEVICE-specific path.
> 
> This provides an MM-internal helper for other early memmap users to
> share.
> 
> No functional change is intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
> v2:
> - Rebase on memmap_init_page_from_template().
> - Rename memmap_init_zone_device_head_page to memmap_init_zone_device_head_fields.
> ---
>  mm/mm_init.c | 114 +++++++++++++++++++++++++--------------------------
>  mm/mm_init.h |   2 +
>  2 files changed, 59 insertions(+), 57 deletions(-)
>
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index bf943ae72a3e5..f1e539aec3d91 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -738,6 +738,28 @@ void __meminit memmap_init_page_from_template(struct page *page,
>  	vmemmap_optimization_verify_zone(page);
>  }
>  
> +void __meminit memmap_init_compound_page_frozen(struct page *head,
> +		unsigned long pfn, const struct zone *zone, unsigned int order)

Do we really need the _frozen suffix here?

> +{
> +	unsigned long nr_pages = 1UL << order;
> +	struct page template;
> +
> +	memmap_init_page_common(&template, zone_idx(zone), zone_to_nid(zone));
> +	prep_compound_tail(&template, head, order);
> +
> +	/* Initialize the head page. */
> +	__init_single_page(head, pfn, zone_idx(zone), zone_to_nid(zone));
> +	set_page_count(head, 0);
> +	__SetPageHead(head);
> +
> +	if (vmemmap_optimizable_order(pfn_to_section_compound_order(pfn)))
> +		nr_pages = VMEMMAP_OPTIMIZATION_NR_STRUCT_PAGES;
> +	/* Initialize the tail pages from PFN-independent template page. */
> +	for (unsigned long i = 1; i < nr_pages; i++)
> +		memmap_init_page_from_template(head + i, pfn + i, zone, &template);
> +	prep_compound_head(head, order);
> +}
> +
>  struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
>  {
>  	pg_data_t *pgdat = NODE_DATA(nid);
> @@ -1063,44 +1085,39 @@ static void __init memmap_init(void)
>  }
>  
>  #ifdef CONFIG_ZONE_DEVICE
> -/*
> - * With compound page geometry and when struct pages are stored in ram most
> - * tail pages are reused. Consequently, the amount of unique struct pages to
> - * initialize is a lot smaller that the total amount of struct pages being
> - * mapped. This is a paired / mild layering violation with explicit knowledge
> - * of how the sparse_vmemmap internals handle compound pages in the lack
> - * of an altmap.
> - */
> -static inline unsigned long compound_nr_pages(unsigned long pfn,
> -					      struct dev_pagemap *pgmap)
> +static void memmap_init_zone_device_head_fields(struct page *head,
> +		struct dev_pagemap *pgmap)

I can't say I like this name. Essentailly we initialize ZONE_DEVICE
folio here, so maybe it can be

	memmap_init_zone_device_folio(struct folio *folio)

>  {
> -	const struct mem_section *ms = __pfn_to_section(pfn);
> -
> -	if (!section_vmemmap_optimizable(ms))
> -		return pgmap_vmemmap_nr(pgmap);
> -
> -	return VMEMMAP_OPTIMIZATION_PAGES * (PAGE_SIZE / sizeof(struct page));
> +	/*
> +	 * MEMORY_DEVICE_GENERIC pages start with a refcount of one; other
> +	 * ZONE_DEVICE pages raise it when handed out. Use atomic_set() because
> +	 * @head may be a stack template, while init_page_count() expects a
> +	 * memmap-backed page.
> +	 */
> +	if (pgmap->type == MEMORY_DEVICE_GENERIC)
> +		atomic_set(&head->_refcount, 1);
> +	/*
> +	 * ZONE_DEVICE pages union ->lru with a ->pgmap back pointer and
> +	 * zone_device_data. It is a bug if a ZONE_DEVICE page is ever freed
> +	 * or placed on a driver-private list.
> +	 */
> +	((struct folio *)head)->pgmap = pgmap;

... and then we won't need this cast and the caller will just pass
page_folio() here.

> +	head->zone_device_data = NULL;
>  }
>  
> -static void __ref memmap_init_compound(struct page *head,
> -				       unsigned long head_pfn,
> -				       unsigned long zone_idx, int nid,
> -				       struct dev_pagemap *pgmap,
> -				       unsigned long nr_pages)
> +static void memmap_init_zone_device_basepages(unsigned long start, unsigned long end,
> +		const struct zone *zone, struct dev_pagemap *pgmap)

_basepages sounds odd for me, maybe _pages will do?

-- 
Sincerely yours,
Mike.


