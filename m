Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FD79CCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 15:34:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA51E80060; Mon, 27 Oct 2025 11:34:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A55B98000A; Mon, 27 Oct 2025 11:34:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D1680060; Mon, 27 Oct 2025 11:34:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 79A298000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 11:34:54 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 424321392C3
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:34:54 +0000 (UTC)
X-FDA: 84044292108.21.EC605F9
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id E2C5B1C000C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 15:34:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XpUhomsW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ph6lNcB5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XpUhomsW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ph6lNcB5;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761579292; a=rsa-sha256;
	cv=none;
	b=owXekHHL4shp0pQBeqTbs8d0ywzcFgAmNysg2FsBRD7qBwWdf7b8igS3P46acqc3ciNljR
	afgCeQFKCsZFy2Z6XAmpkaGSK+ketokvnLI5zyASknQfAhiMLCsfIHfz/rPixmeD/bBgPU
	7ol+wCBUdAAK9I3S3qgwCv6X34PVzmc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XpUhomsW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ph6lNcB5;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=XpUhomsW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ph6lNcB5;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761579292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkCzjDITEmu3iQxYf6mZpY8gvpmTVbipkrkmE98m6bo=;
	b=R6/OjuxBgbZd7y1WqoUT9RfggKSSia4vE+SuBEsl6jgtCvdP8izuC15abqHWLIgrf1CrW/
	N/Huz3XJ3tGWmpUDc9VqddCTi2YHugXecy50XijDmIaFTRFOgOUoBnVKBBhc01eQRhXvLM
	ag/f/kSNzqSRIYAaMFzfrFil6N38+Tw=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 57BF0216E5;
	Mon, 27 Oct 2025 15:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761579290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fkCzjDITEmu3iQxYf6mZpY8gvpmTVbipkrkmE98m6bo=;
	b=XpUhomsWvl2pT+PCBK443uB7hrYG/EHz5cjIQTWG1UL1u79ffepvEX5YmoswY9Lk2Oun0Q
	V9R3sYS+tKzzVVvQGGc7KVHC/x0YAgWAemJ/5XS71fYtrvrcR79gDSXkb4biE+96lHS7MA
	fNUaE9Im0xT2URwfiVOTCJhwJOjMBCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761579290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fkCzjDITEmu3iQxYf6mZpY8gvpmTVbipkrkmE98m6bo=;
	b=Ph6lNcB5hORsusJa9YZn+nnyTcltzvRFJ6pBRRZrC7vtrZNJ9vzg6Ec92C9r0TcSU7oC8S
	C5evCAG7JVSxfUAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1761579290; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fkCzjDITEmu3iQxYf6mZpY8gvpmTVbipkrkmE98m6bo=;
	b=XpUhomsWvl2pT+PCBK443uB7hrYG/EHz5cjIQTWG1UL1u79ffepvEX5YmoswY9Lk2Oun0Q
	V9R3sYS+tKzzVVvQGGc7KVHC/x0YAgWAemJ/5XS71fYtrvrcR79gDSXkb4biE+96lHS7MA
	fNUaE9Im0xT2URwfiVOTCJhwJOjMBCc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1761579290;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=fkCzjDITEmu3iQxYf6mZpY8gvpmTVbipkrkmE98m6bo=;
	b=Ph6lNcB5hORsusJa9YZn+nnyTcltzvRFJ6pBRRZrC7vtrZNJ9vzg6Ec92C9r0TcSU7oC8S
	C5evCAG7JVSxfUAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 31771136CF;
	Mon, 27 Oct 2025 15:34:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FTU0CxqR/2ifUgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 27 Oct 2025 15:34:50 +0000
Message-ID: <fc6434a8-21fe-4924-95fc-5a1fd1f3d197@suse.cz>
Date: Mon, 27 Oct 2025 16:34:49 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/17] slab: Reimplement page_slab()
Content-Language: en-US
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>
Cc: Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>,
 linux-mm@kvack.org, Dmitry Vyukov <dvyukov@google.com>,
 kasan-dev <kasan-dev@googlegroups.com>
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-2-willy@infradead.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251024204434.2461319-2-willy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 39r69ordgsh6zibt1qn8xmtr5bfogwzq
X-Rspamd-Queue-Id: E2C5B1C000C
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761579291-948237
X-HE-Meta: U2FsdGVkX1/1Aje45TNAmTtjN6OE1WFlFEWNMBxsPSQ58OyjP4W3hIGkZFc6Qy50B1LXzrL1x0Ffozoi6QbFp6FuB44e31NLPqeaFnyFHYL/1fMHUTz5Hs8s0/A2em0kFkure2625mbEvMxF4dlCvwzbn6lXfdbEmxU1kguaGWotb8GM2wi9DMK5dABNKrCRYnoSwA2iGbpAz5rnYwNUnNcZSsfqzBlbYg5dy07Rt32eaQF31Ud2+/WLNyN+VUjpzUWoDZUOkvUzj9kurH8ssMRSP4t+WhcPFL4KFEx7z+jphSXuseVww+TZwe7TOaEU67QBz1cF4CA8DF/w/lVytNZus6gGDm61UhTbKH5HB5taHPZhCNSNSqhsPIkYNF28f2Ei2cdLyu7ndLOQuN6rZ66lBYd2eAQO06GGhMgVGRI6SzYRNDG6B1mAmkz+N1zujRLqGUnx1hostDU4O6aeMn1qZTWM+KTsd7UCiQ4HrVUg7G9v/UabwyDVNpwk1Bz7+mOYWF+m1gZtEtcgpfYeByNs9UA62bdXgunayXyy96UFV69gdNa/CtftPYkmNzdm/QfiqEzEcg9NmdIjP1+Lv9ACiDbtxFkIA2xW8bLwd1Gs0lVf1ZIXqnXgfat6MRy6UrUAIE34hHfTeX8Xq/EF8UqrNZUtmpi1AQJVT9/9KxLCLmPWnQSVpgnmGPi2cO5pLoP4w6gsx+XuROz0ATSfcVpfoosj1CFGzcux47K/0PZinmpEGHQSZGySP0uVANLtDUktpdHEbRTSJQU5n5Clq6COgrdK7CczQW2ntkhGcMmKS7LACD4/XaYNsDEdyFt+jNTJEOS2W9ddRHxX2i4idXMF7YP/RuE/spcn7AmyntbVFdirGz2Tq5dP3OCwxv12R+dLWc52k/kjSt5riMMwLi6YK6TLp01c+wu5hwiD+NSyC1BsdPUgJeGdawhZTyeOBtlcYvKl248PprYIpvl
 1QuJg8fs
 gaeWto7l62hnVD8c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/24/25 22:44, Matthew Wilcox (Oracle) wrote:
> In order to separate slabs from folios, we need to convert from any page
> in a slab to the slab directly without going through a page to folio
> conversion first.  page_slab() is a little different from other memdesc
> converters we have in that it will return NULL if the page is not part
> of a slab.  This will be the normal style for memdesc converters in
> the future.
> 
> kfence was the only user of page_slab(), so adjust it to the new way
> of working.  It will need to be touched again when we separate slab
> from page.

+Cc KFENCE folks.

> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Otherwise LGTM.

> ---
>  include/linux/page-flags.h | 14 +-------------
>  mm/kfence/core.c           | 12 ++++++++----
>  mm/slab.h                  | 28 ++++++++++++++++------------
>  3 files changed, 25 insertions(+), 29 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 0091ad1986bf..6d5e44968eab 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -1048,19 +1048,7 @@ PAGE_TYPE_OPS(Table, table, pgtable)
>   */
>  PAGE_TYPE_OPS(Guard, guard, guard)
>  
> -FOLIO_TYPE_OPS(slab, slab)
> -
> -/**
> - * PageSlab - Determine if the page belongs to the slab allocator
> - * @page: The page to test.
> - *
> - * Context: Any context.
> - * Return: True for slab pages, false for any other kind of page.
> - */
> -static inline bool PageSlab(const struct page *page)
> -{
> -	return folio_test_slab(page_folio(page));
> -}
> +PAGE_TYPE_OPS(Slab, slab, slab)
>  
>  #ifdef CONFIG_HUGETLB_PAGE
>  FOLIO_TYPE_OPS(hugetlb, hugetlb)
> diff --git a/mm/kfence/core.c b/mm/kfence/core.c
> index 727c20c94ac5..b16e73fd5b68 100644
> --- a/mm/kfence/core.c
> +++ b/mm/kfence/core.c
> @@ -612,13 +612,15 @@ static unsigned long kfence_init_pool(void)
>  	 * enters __slab_free() slow-path.
>  	 */
>  	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
> +		struct page *page;
>  		struct slab *slab;
>  
>  		if (!i || (i % 2))
>  			continue;
>  
> -		slab = page_slab(pfn_to_page(start_pfn + i));
> -		__folio_set_slab(slab_folio(slab));
> +		page = pfn_to_page(start_pfn + i);
> +		__SetPageSlab(page);
> +		slab = page_slab(page);
>  #ifdef CONFIG_MEMCG
>  		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
>  				 MEMCG_DATA_OBJEXTS;
> @@ -665,16 +667,18 @@ static unsigned long kfence_init_pool(void)
>  
>  reset_slab:
>  	for (i = 0; i < KFENCE_POOL_SIZE / PAGE_SIZE; i++) {
> +		struct page *page;
>  		struct slab *slab;
>  
>  		if (!i || (i % 2))
>  			continue;
>  
> -		slab = page_slab(pfn_to_page(start_pfn + i));
> +		page = pfn_to_page(start_pfn + i);
> +		slab = page_slab(page);
>  #ifdef CONFIG_MEMCG
>  		slab->obj_exts = 0;
>  #endif
> -		__folio_clear_slab(slab_folio(slab));
> +		__ClearPageSlab(page);
>  	}
>  
>  	return addr;
> diff --git a/mm/slab.h b/mm/slab.h
> index 078daecc7cf5..a64b9b2c8731 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -146,20 +146,24 @@ static_assert(IS_ALIGNED(offsetof(struct slab, freelist), sizeof(freelist_aba_t)
>  	struct slab *:		(struct folio *)s))
>  
>  /**
> - * page_slab - Converts from first struct page to slab.
> - * @p: The first (either head of compound or single) page of slab.
> + * page_slab - Converts from struct page to its slab.
> + * @page: A page which may or may not belong to a slab.
>   *
> - * A temporary wrapper to convert struct page to struct slab in situations where
> - * we know the page is the compound head, or single order-0 page.
> - *
> - * Long-term ideally everything would work with struct slab directly or go
> - * through folio to struct slab.
> - *
> - * Return: The slab which contains this page
> + * Return: The slab which contains this page or NULL if the page does
> + * not belong to a slab.  This includes pages returned from large kmalloc.
>   */
> -#define page_slab(p)		(_Generic((p),				\
> -	const struct page *:	(const struct slab *)(p),		\
> -	struct page *:		(struct slab *)(p)))
> +static inline struct slab *page_slab(const struct page *page)
> +{
> +	unsigned long head;
> +
> +	head = READ_ONCE(page->compound_head);
> +	if (head & 1)
> +		page = (struct page *)(head - 1);
> +	if (data_race(page->page_type >> 24) != PGTY_slab)
> +		page = NULL;
> +
> +	return (struct slab *)page;
> +}
>  
>  /**
>   * slab_page - The first struct page allocated for a slab


