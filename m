Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD623C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 15:13:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 793B26B008A; Wed,  8 Jul 2026 11:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744CF6B0092; Wed,  8 Jul 2026 11:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60EF46B0093; Wed,  8 Jul 2026 11:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 380EC6B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:13:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B580F1C78C2
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:13:33 +0000 (UTC)
X-FDA: 84965953506.04.48357ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8DA19A0013
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 15:13:31 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b172Ftkd;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783523611;
	b=NFrfAEIdeU1wNaBpn1aeg7Q91Uw89jyOD2Lx91G5ZWYijEytU7UYDermZI0Y825IqH5uRw
	7Wmmqq1kotukBTVGUXv66T2gRKNQ/9a3eysrvJ554+MEgsHTsdufux5TuCGfGYtfqmsBPW
	0yuVFPTOIXa5A0a70ZotQDmafUa66J8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b172Ftkd;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783523611;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dY3UhUcYvYikZtGBYs+3zTBokdgjfjfU+WDdt96CQOU=;
	b=10fjcu+n288duiOuf2JKPmlHjy0eVYDtFXUdtO0zyuaz1LG5R11c8ae1aQBHbg2pNVR+kq
	QzobE485OmUZg75d43noHfieFt7fdIYZzfobtkuIXOQLnuobeWuPgG1fVLhc9ANl5BaYma
	1xfCcUjeHJz4fcC+KIoyCxn28nmrPnY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 728AA42AAF;
	Wed,  8 Jul 2026 15:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E062A1F000E9;
	Wed,  8 Jul 2026 15:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783523610;
	bh=dY3UhUcYvYikZtGBYs+3zTBokdgjfjfU+WDdt96CQOU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b172FtkdibBF/k8qkdVxwxVxIoxhk5PUXuLfSOQ7NIgWDpyJiB5oHp2Cwis1F1Acn
	 mYkDzjL3ltm+oX1pUW4W7R9+SDSsMB0L3BPLtGEsHeXrhPXSyVKi/pXskqC7uwZfXR
	 AlWQ3oFqrjN1RqIHOyB2xXwUrQ+z6f1FOJXVvv2+iWBhVti1ziuzWXnII0b2U/SVLi
	 K07SFb5qMFexZYq8G31KTP2VkISk/Gl15rwNKkFIPURnzWsPpiZhuT+CYIrW3IsG+c
	 msmTCOAoNIPeRx6zu14UEW7nMgVQ1eJnHAEi7px2+8RkVmtdCex1cSEYz9pCQ/+jkh
	 51O8uPaiOQxKA==
Message-ID: <dd1bfb6a-4e3d-40dc-b1b1-6c169279b366@kernel.org>
Date: Wed, 8 Jul 2026 17:13:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 02/10] mm: provide free_reserved_pages(), removing x86
 variant
To: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-s390@vger.kernel.org
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
 <20260708-bootmem_info_part2-v1-2-156ce4986598@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260708-bootmem_info_part2-v1-2-156ce4986598@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8DA19A0013
X-Stat-Signature: 66xq6byenepkhfnj6ff1tg54uukoispb
X-HE-Tag: 1783523611-458640
X-HE-Meta: U2FsdGVkX1/wxs8qjuwnDSi2/SMjIRKBDuO1AVRCEG3zWk5xmdnnixYMjnusY7D+TPbSiEavlfhby1sWDPxZrsyEcqwjA8r6Zo51W+K1aI8ep6yX/VkU8apYqhrwXYhYiaMtVojUu4S+Rg8hm05FEMJHh1KA0Ezz7ZUw+ZkFrz9ZuayjBUGlE1CKKmvq0SiD+cmM8FsNBBPYhjbUrTMZkpiWPB7QXW0yhFlwb9hUL0Rjjh/HuRa6WxHzq/yVjn/PUvNR2+e9EDm+a4Dh48pTp9cVKYwnS6pFbLrFUCXoMEGMgReNqX9rkEvVVmbexlAaRMf1IdSeTqaRhsFuuD/yiI0LwnYZZQxFzuy3cQCiABeeZ950jpkcZj9wgGgiHrec+DC+xbdLpy6/Xfvip3zQdDCDG6JSyYXMFiqNWgKX6IWldBhKoBUfCAhj4dbxjDerSbCQlWOwAC6DnoDAKPI6aijHLUAKCMcPj5CQOPYsZQfjCL3SQqFYtZJ/Tbew2F0/cSX4BM0P3DT3xQ6wIpKFUxEuNrjCCTb7f+LJgLHv4w+Rcd6ZGUjrx7heG3//CT5YfPcj+6ZJgB0ziVPKCb/NChiJq4+ca/CXKKI3EpGsaYoNq++brd/RLW2o31TdLlrQbAMGMMkxo2BOFA/g2/thBaX4+fm6Vz0j23yBYyXCeNOELzIl7+FRKMh9p67fiQFOtl1D0zfKmeY4fLtI+tbYh9PsrQYBoXfQA6e3fFCFuoYXyta8DkyayTpxs4nn6QBev1NPCVn9IjkyFFpsc0sJp5Z+rR7cBSFiM2KiCNi3XpOY10Oogdj+3q1fiA3ywnBHTfRAoXheWQi8kyjN2xJ9RZhxaIPGIWOnMlOuCSgndrpZPt0k8EajU/kQZ4cagq/4Q5fUJx0HwaPuI+OFenJrAZezjWM3r+6hBWueXsoDOHCaJab9XVUfktQGlbIY6O3i6IUeJrqbTRWfk4IzDKZ
 Kwj+La5p
 7TMTNskuuufnhEuxNVj3nNSA52PnoRvJwnDqAVTJrMZKKIITGTlOxKfJdM2HuyAsu0pud122gBFDNWMVxBl4y+SlVlP7b8kjjWZr75qXktsjC+O4A+w+O7sqXmdtm8If8EMhdGzc3USojv0UZFmfm6iJPhHvXracRy662ri3Q1ZoOufQyxdLj1YDI49e3YiAYZwtNmsjXfM2B87TiCB1OrzETCGwGqQD7STc9BeRg934YmVtpu59NUEMyijPTiAIwwReoE75MELQ13+DPCKHnsUjmX1TlzeOO+8nGdi5hvieAvAF8TFlYMYFb6MnMQN05OjC84/suKv46F4U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/8/26 16:10, David Hildenbrand (Arm) wrote:
> Let's extend free_reserved_page() in page_alloc.c to free_reserved_pages(),
> dropping the custom x86 variant. The common-code variant will consume an
> order, so adjust the x86 callers accordingly.
> 
> Make free_reserved_pages() assume that we are freeing ordinary
> high-order pages, just with the special "reserved" flavor. The target
> use case for now is freeing vmemmap PMD pages.
> 
> Set the refcount directly to 0 (instead of 1) and call
> __free_frozen_pages(). Add some kerneldoc. Use a single
> adjust_managed_page_count() call.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  arch/x86/mm/init_64.c |  8 +-------
>  include/linux/mm.h    |  8 ++++++--
>  mm/page_alloc.c       | 33 ++++++++++++++++++++++++++-------
>  3 files changed, 33 insertions(+), 16 deletions(-)
> 
> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
> index 69e36f02a663a..320e742b0bb3f 100644
> --- a/arch/x86/mm/init_64.c
> +++ b/arch/x86/mm/init_64.c
> @@ -1000,12 +1000,6 @@ int arch_add_memory(int nid, u64 start, u64 size,
>  	return add_pages(nid, start_pfn, nr_pages, params);
>  }
>  
> -static void free_reserved_pages(struct page *page, unsigned long nr_pages)
> -{
> -	while (nr_pages--)
> -		free_reserved_page(page++);
> -}
> -
>  static void __meminit free_pagetable(struct page *page)
>  {
>  	/* bootmem page has reserved flag */
> @@ -1038,7 +1032,7 @@ static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
>  			while (nr_pages--)
>  				put_page_bootmem(page++);
>  		} else {
> -			free_reserved_pages(page, nr_pages);
> +			free_reserved_pages(page, order);
>  		}
>  	} else {
>  		__free_pages(page, order);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 113e1752548c2..62b261cccf16f 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3993,8 +3993,12 @@ extern unsigned long free_reserved_area(void *start, void *end,
>  
>  extern void adjust_managed_page_count(struct page *page, long count);
>  
> -/* Free the reserved page into the buddy system, so it gets managed. */
> -void free_reserved_page(struct page *page);
> +void free_reserved_pages(struct page *page, unsigned int order);
> +
> +static inline void free_reserved_page(struct page *page)
> +{
> +	free_reserved_pages(page, 0);
> +}
>  
>  static inline void mark_page_reserved(struct page *page)
>  {
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index a63733dac659e..9311d1f3793ad 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6381,15 +6381,34 @@ void adjust_managed_page_count(struct page *page, long count)
>  }
>  EXPORT_SYMBOL(adjust_managed_page_count);
>  
> -void free_reserved_page(struct page *page)
> +/**
> + * free_reserved_pages - free reserved pages
> + * @page: First page to free.
> + * @order: The page order to free.
> + *
> + * Free pages allocated through memblock during boot, letting the buddy
> + * manage them from now on.
> + *
> + * @page must be naturally aligned to the order and the order must not
> + * exceed MAX_PAGE_ORDER. All pages must be reserved.
> + */
> +void free_reserved_pages(struct page *page, unsigned int order)
>  {
> -	clear_page_tag_ref(page);
> -	ClearPageReserved(page);
> -	init_page_count(page);
> -	__free_page(page);
> -	adjust_managed_page_count(page, 1);
> +	const unsigned long nr_pages = 1UL << order;
> +	int i;
> +
> +	VM_WARN_ON_ONCE(!IS_ALIGNED(page_to_pfn(page), nr_pages));
> +	VM_WARN_ON_ONCE(order > MAX_PAGE_ORDER);
> +
> +	for (i = 0; i < nr_pages; i++) {
> +		clear_page_tag_ref(page + i);
> +		ClearPageReserved(page + i);
> +		set_page_count(page + i, 0);

Sashiko raises in reply to #4 that PFN walkers trying to grab pages could see
their reference getting overridden.

While that is not something we should be worrying about (or fixing in old code),
I think it's best to ClearPageReserved() after set_page_count(), so someone
actually trying to grab a reference would have the chance to rely on
PageReserved from being a reliable indication.

-- 
Cheers,

David

