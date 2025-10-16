Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E01CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 35CEE8E0023; Thu, 16 Oct 2025 16:53:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3344B8E0002; Thu, 16 Oct 2025 16:53:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FBB38E0023; Thu, 16 Oct 2025 16:53:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 020728E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:53:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 86AC013AC54
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:53:26 +0000 (UTC)
X-FDA: 84005178012.24.777CC48
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id D4DB580006
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:53:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U7CXmAsJ;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760648004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a+D1c6tm4Fv2HZPGuJLeSD7J+Kdcl4bDd+4956SpFpE=;
	b=wPc7p4e2NX1jeBepyzh4DVoUhA71D8V0OXRJqKJ9x0yCL/o9epTKShvAkCj3gzRCPNCGje
	2SOP6YmgbxEnyX1O/OScXYZ3g0tInHHNzyx72vV+p7iMQmK79X14T+kW/Eeig/FM5Ursgy
	m1ggidFw/bqGoenpRHcFjVv7h7PeajY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=U7CXmAsJ;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760648004; a=rsa-sha256;
	cv=none;
	b=U34YPJzhOmMWVH/IEY4unhdBhz3QWE8w/DGYg+sEtV8O2+3OWzY9g6ahoD0ISo21fiZMjE
	swux+9gLICb9skb6RnjSLTaib/Qc3+U7pTjBkU3M1ghodNdnarywixaojjNkanXw9QSnFe
	LS9+f72rSni/77fJMzeT8pXaGotuUXA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760648003;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=a+D1c6tm4Fv2HZPGuJLeSD7J+Kdcl4bDd+4956SpFpE=;
	b=U7CXmAsJ5G3ro0kkqvdnsNhMaaN8h5MzXRr0N+QWP8v/saRKjn8Sv0luCU3oSNDwcyoGnQ
	WFk0MmGBbVx4VrmRkptvGCHoBIHlD37yrgu1CUpgM5vDrZ6A9xP5OumnwIMqn0xCoWLzxy
	Ym/FOQLoeuaKfY6s40k58Y5EOchEwfA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-528-epAPd2ZWPd24elpVXvusKg-1; Thu, 16 Oct 2025 16:53:21 -0400
X-MC-Unique: epAPd2ZWPd24elpVXvusKg-1
X-Mimecast-MFC-AGG-ID: epAPd2ZWPd24elpVXvusKg_1760648000
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-47108163eeaso6337635e9.3
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760648000; x=1761252800;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=a+D1c6tm4Fv2HZPGuJLeSD7J+Kdcl4bDd+4956SpFpE=;
        b=G7rqtr1/B1WnnPAKHC3rqYhh21gyfjha38L9wn4R98bAwlAE1FnYPgNvkWyt8Rt/dh
         lanrPKpu6XLDPPJGZCVXAd5AdPpYTVSKs4LUt00uhUlkJ5kQHtjX3SWojOldEUPTL23a
         BmbbHUmfOAs8NnK9WceiHYgUqirmpQiawQv9IoqxXTGC2/SqEAizipP4GSMS4svaJH6Q
         HcgHVjPEY2nKOsOMwq5j7DoEWWujTP/hd9ldEdqaEjvz3lAl3wgNvXMKeF+daNVXH1OO
         xAnEPOxTKGZr+DfHSjtYaKtVsjJPWq2b9tPQGEcQaujQEFJFIUuZccQGXBh518BXRxPK
         Xifw==
X-Forwarded-Encrypted: i=1; AJvYcCVsaITGsd4t1tfpcSQhaN1ySnjc5NsVo/YOi5bsPKildKQBHsJcHp/tuzGAiyNnaEJ6aqEveIvSnQ==@kvack.org
X-Gm-Message-State: AOJu0Yx9bJSXX8+owHxAQ5vwpM6m+SiCkxYRhiI1fPUp9kJR/BkTCY1y
	CQRLLPbcekgTIlipg1sFQhxVtAAfxPbtfxNLgh2NF1WKKp4kKQHO6fKtAvryS9fDlvono9lISj9
	99O9IxCHwAqcp485X7PZRuE8CdlGRoYWPNXWp3I+hV7MpMLWjCyXP
X-Gm-Gg: ASbGncutYHQ1MfsMDjAcXcKNLt1nzltZPRwVguwDN2QB3zxu02oKxKvMjUNaNB3kl6a
	kTJHebG6qxeAQ95TpcXifpcO32yF39yjbCFobzCLaQAsr5Dv6OSZDWXzGT8aknmH/u1oww8yXec
	xWHd5jyNm+iYR5ZYm86waCfyHa9M3N+JckiO5pMSl4wRkqOPImCW0NpyUFAAyzCi9BGBpORUfsh
	Mkh3/t59JksLFqWOxnvx5dAmrgVRTcG9/XkDmWQk9/UWVJK2B6iF0NcHY9bLHyYgWxx3KiI4y40
	BbQ2JIbkIBexw1NgD9bGEeyc3Hc/KjTFZhL0KLF6UTJKlFl24XC4xYYJxrOwMpdFhBPrIryDUXb
	9ILUNFRd80LKjguhE2KNJoWgb9CL52tmGH/38qlI7vsMFtjFHp/h68LtV6vK7KFqwrtIeh+f3f5
	FqIBea8cxz/NkEzG7aZhWJ5C46AM8=
X-Received: by 2002:a05:600c:3e07:b0:471:13fc:e356 with SMTP id 5b1f17b1804b1-471178760f8mr9558845e9.3.1760648000351;
        Thu, 16 Oct 2025 13:53:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbKG76GPYFtBEaUnUqchQl1tDe2GlZLqhe8RgYKQ4IhgYJrC5m6ZBa0qxWWC5S5xj/4LtZaw==
X-Received: by 2002:a05:600c:3e07:b0:471:13fc:e356 with SMTP id 5b1f17b1804b1-471178760f8mr9558765e9.3.1760647999904;
        Thu, 16 Oct 2025 13:53:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711442932esm46204595e9.6.2025.10.16.13.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 13:53:19 -0700 (PDT)
Message-ID: <e1f7ca22-a249-4b24-b308-d46afb2afb29@redhat.com>
Date: Thu, 16 Oct 2025 22:53:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm: page_alloc: add
 alloc_contig_{range_frozen,frozen_pages}()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com, Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
 <20251013133854.2466530-4-wangkefeng.wang@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251013133854.2466530-4-wangkefeng.wang@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l6t1gFnm_-BJA69mrejjw2_NKS8GsKacOkXoITOfIOk_1760648000
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D4DB580006
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: u91rr6xtq4jgx7q65f85f6kfjd51ewo6
X-HE-Tag: 1760648003-471599
X-HE-Meta: U2FsdGVkX1934AfMAqQLfAwXfJUee+rT0O3BrIY05U2wTGD3UsUdYO081OKoCTZUuHX8KpSgj11uisONwqJ+itmc532MHmzU5EBBM9smlhdxYSRumMWgJcVXMnWKmRefiEJeHqiaLsTVCLodJZslk0AP+Pu+eF8Jgo6hXz1cUFQsPWKG57Wzz9HuUk3CpO6v8A7y0RpnVF+E5UJqa8x4qIoEjJyaerWfC5T7JRy9XuTrJHXsb5QNJHAhfLZsjfnZYM6Myzd93PqRoMpqrxRer9SqWDYDzkIGnqUAQ3HXl2wT7rhYnfyz6g+iHvAZiKUwd/1Mev9vLRWKZaBEgU8UIi6TRkLrAfC+F9Vpvb31U8oDF+QqwfL6s0PJRKXxziEscK0DJI868z1qkbJ+wRg1ioP7o1Un7l++AMBzpctha1mbqMNvdQsC0Tr6do/HDS5frdSKnUYAkdSm+IJa5zNms36JKSXBF96VcivzLt1BzFjnEwE2gIRa7B4Gvf3kd74BvrFhT2cQDlMdobqtM8WkjpxVHmhecQzbIyJI8SFm99K0Pg+qGUoMy4ZOkUPL0w2MqRzPsvCi+o0Ex7EP51Vj1Z7N+iS66RkarS1Dq49bMoJXtAtFKJ+hRkEj6K097jGFbzulwOTzpA4BQBtHJl58xF4lU5ojBm/5ftbrL8BNUY5EjS8XtMTqWF0Nm8t6FQmMWtiVEnIh87v08SGH8qN9NqNqhVydQixenRvCD8PqjbVcVamSzt5bRZGw+27g0NnVg/4YiDWWpbRC49jtuk8hO9ri8PSRzFytlfSm/GSdgzFrSZNeg3UKfZBT/QplTxRDMFvJI9CSNqacNU8PZh2Isz3Lsfjsa4cDi30UtP4RusdPgIFFRNcxzRx07CjNFlVWFReWMuApCLcMgqVTyRzd5tHcRdkjCJO6SHVN6uXvTqMayBkgOybWR/o0zJEUtSct0XT6V0t42wNEio8HgAx
 bGxza81a
 Fd58e2WPjSmD5gZos8oOOoomPXhkzEey8m39CYK4HZbhqVDSDqwmc3nGNOrHqqh8mabbG0KFKiHihch90XPlquTV+YFApzITKfKFay/1DGw8zirtJ7Pa2xUlPWpPOYLauuIr6WIqJFHcuNkShd4m9PIOWCPvo5XCJ2Rz/lhJ0v7SJBFJywJTDcd2LeURhDHBcsyUqRiom3+vbz0hXGardO3X7VYVKMtX7LmY7E2SEiz+yhwiJ4Ni3gDPAlokNpToL0IIQeUn+meNDZFzxoVZzaRz2H0lBoF0gCfaOvHw45Fu8SloxGLYKMvEk4IY6S3b9irzMkQTuLsCjeJtCihjKOUbEFZ1C6FkAsZMpQvEmAeeD9BnEqnSZqK/su2u3geqQsSS2jdKeRHQfEk7jMpMBfyW/3REYD0DILilHbejrn/oBCnbVVoVdx/AzjsFJxZ5YciINw1sWcUN4d9Zny5vWQZO2JaMN3+iRO2xU54DDKRmvDvAPR+DbqVvTzw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 13.10.25 15:38, Kefeng Wang wrote:
> In order to allocate given range of pages or allocate compound
> pages without incrementing their refcount, adding two new helper
> alloc_contig_{range_frozen,frozen_pages}() which may be beneficial
> to some users (eg hugetlb), also free_contig_range_frozen() is
> provided to match alloc_contig_range_frozen(), but it is better to
> use free_frozen_pages() to free frozen compound pages.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   include/linux/gfp.h |  29 +++++--
>   mm/page_alloc.c     | 183 +++++++++++++++++++++++++++++---------------
>   2 files changed, 143 insertions(+), 69 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 1fefb63e0480..fbbdd8c88483 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -429,14 +429,27 @@ typedef unsigned int __bitwise acr_flags_t;
>   #define ACR_FLAGS_CMA ((__force acr_flags_t)BIT(0)) // allocate for CMA
>   
>   /* The below functions must be run on a range from a single zone. */
> -extern int alloc_contig_range_noprof(unsigned long start, unsigned long end,
> -				     acr_flags_t alloc_flags, gfp_t gfp_mask);
> -#define alloc_contig_range(...)			alloc_hooks(alloc_contig_range_noprof(__VA_ARGS__))
> -
> -extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> -					      int nid, nodemask_t *nodemask);
> -#define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
> -
> +int alloc_contig_range_frozen_noprof(unsigned long start, unsigned long end,
> +		acr_flags_t alloc_flags, gfp_t gfp_mask);

Just wondering: given alloc_contig_pages() vs. alloc_contig_frozen_pages_()

Shouldn't it be alloc_contig_range() vs. alloc_contig_frozen_range()

And then free_contig_frozen_range()?


Do we want kerneldoc here as well?

> +int alloc_contig_range_frozen_noprof(unsigned long start, unsigned long end,
> +		acr_flags_t alloc_flags, gfp_t gfp_mask)
>   {
>   	const unsigned int order = ilog2(end - start);
>   	unsigned long outer_start, outer_end;
> @@ -7003,19 +6982,18 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>   	}
>   
>   	if (!(gfp_mask & __GFP_COMP)) {
> -		split_free_pages(cc.freepages, gfp_mask);
> +		split_free_frozen_pages(cc.freepages, gfp_mask);
>   
>   		/* Free head and tail (if any) */
>   		if (start != outer_start)
> -			free_contig_range(outer_start, start - outer_start);
> +			free_contig_range_frozen(outer_start, start - outer_start);
>   		if (end != outer_end)
> -			free_contig_range(end, outer_end - end);
> +			free_contig_range_frozen(end, outer_end - end);
>   	} else if (start == outer_start && end == outer_end && is_power_of_2(end - start)) {
>   		struct page *head = pfn_to_page(start);
>   
>   		check_new_pages(head, order);
>   		prep_new_page(head, order, gfp_mask, 0);
> -		set_page_refcounted(head);
>   	} else {
>   		ret = -EINVAL;
>   		WARN(true, "PFN range: requested [%lu, %lu), allocated [%lu, %lu)\n",
> @@ -7025,16 +7003,48 @@ int alloc_contig_range_noprof(unsigned long start, unsigned long end,
>   	undo_isolate_page_range(start, end);
>   	return ret;
>   }
> -EXPORT_SYMBOL(alloc_contig_range_noprof);
>   
> -static int __alloc_contig_pages(unsigned long start_pfn,
> -				unsigned long nr_pages, gfp_t gfp_mask)
> +/**
> + * alloc_contig_range() -- tries to allocate given range of pages
> + * @start:	start PFN to allocate
> + * @end:	one-past-the-last PFN to allocate
> + * @alloc_flags:	allocation information
> + * @gfp_mask:	GFP mask. Node/zone/placement hints are ignored; only some
> + *		action and reclaim modifiers are supported. Reclaim modifiers
> + *		control allocation behavior during compaction/migration/reclaim.
> + *
> + * The PFN range does not have to be pageblock aligned. The PFN range must
> + * belong to a single zone.
> + *
> + * The first thing this routine does is attempt to MIGRATE_ISOLATE all
> + * pageblocks in the range.  Once isolated, the pageblocks should not
> + * be modified by others.
> + *
> + * Return: zero on success or negative error code.  On success all
> + * pages which PFN is in [start, end) are allocated for the caller and
> + * need to be freed with free_contig_range().
> + */
> +int alloc_contig_range_noprof(unsigned long start, unsigned long end,
> +			      acr_flags_t alloc_flags, gfp_t gfp_mask)
>   {
> -	unsigned long end_pfn = start_pfn + nr_pages;
> +	int ret;
> +
> +	ret = alloc_contig_range_frozen_noprof(start, end, alloc_flags, gfp_mask);
> +	if (ret)
> +		return ret;
> +
> +	if (gfp_mask & __GFP_COMP) {
> +		set_page_refcounted(pfn_to_page(start));
> +	} else {
> +		unsigned long pfn;
> +
> +		for (pfn = start; pfn < end; pfn++)
> +			set_page_refcounted(pfn_to_page(pfn));
> +	}

Might read better as

unsigned long pfn;

...

if (gfp_mask & __GFP_COMP) {
	set_page_refcounted(pfn_to_page(start));
	return 0;
}

for (pfn = start; pfn < end; pfn++)
	set_page_refcounted(pfn_to_page(pfn));
return 0;


One could also do something fancy like

unsigned long pfn;
...

for (pfn = start; pfn < end; pfn++) {
	set_page_refcounted(pfn_to_page(pfn));
	if (gfp_mask & __GFP_COMP)
		break;
}
return 0:


>   
> -	return alloc_contig_range_noprof(start_pfn, end_pfn, ACR_FLAGS_NONE,
> -					 gfp_mask);
> +	return 0;
>   }
> +EXPORT_SYMBOL(alloc_contig_range_noprof);
>   
>   static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
>   				   unsigned long nr_pages)
> @@ -7067,31 +7077,8 @@ static bool zone_spans_last_pfn(const struct zone *zone,
>   	return zone_spans_pfn(zone, last_pfn);
>   }


... kerneldoc? :)

> +struct page *alloc_contig_frozen_pages_noprof(unsigned long nr_pages,
> +		gfp_t gfp_mask, int nid, nodemask_t *nodemask)
>   {
>   	unsigned long ret, pfn, flags;
>   	struct zonelist *zonelist;
> @@ -7114,7 +7101,9 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>   				 * and cause alloc_contig_range() to fail...
>   				 */
>   				spin_unlock_irqrestore(&zone->lock, flags);
> -				ret = __alloc_contig_pages(pfn, nr_pages,
> +				ret = alloc_contig_range_frozen_noprof(pfn,
> +							pfn + nr_pages,
> +							ACR_FLAGS_NONE,
>   							gfp_mask);
>   				if (!ret)
>   					return pfn_to_page(pfn);
> @@ -7126,6 +7115,78 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
>   	}
>   	return NULL;
>   }
> +EXPORT_SYMBOL(alloc_contig_range_frozen_noprof);
> +

kerneldoc? :)

> +void free_contig_range_frozen(unsigned long pfn, unsigned long nr_pages)
> +{
> +	struct folio *folio = pfn_folio(pfn);
> +
> +	if (folio_test_large(folio)) {
> +		int expected = folio_nr_pages(folio);
> +
> +		WARN_ON(folio_ref_count(folio));
> +
> +		if (nr_pages == expected)
> +			free_frozen_pages(&folio->page, folio_order(folio));
> +		else
> +			WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
> +			     pfn, nr_pages, expected);
> +		return;
> +	}
> +
> +	for (; nr_pages--; pfn++) {
> +		struct page *page = pfn_to_page(pfn);
> +
> +		WARN_ON(page_ref_count(page));
> +		free_frozen_pages(page, 0);
> +	}

That's mostly a copy-and-paste of free_contig_range().

I wonder if there is some way to avoid duplicating a lot of
free_contig_range() here. Hmmm.

Also, the folio stuff in there looks a bit weird I'm afraid.

Can't we just refuse to free compound pages throught this interface and
free_contig_range() ? IIRC only hugetlb uses it and uses folio_put() either way?

Then we can just document that compound allocations are to be freed differently.

And do something like

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 600d9e981c23d..776b4addc3685 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7123,29 +7123,25 @@ struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
  }
  #endif /* CONFIG_CONTIG_ALLOC */
  
-void free_contig_range(unsigned long pfn, unsigned long nr_pages)
+static inline void __free_contig_range(unsigned long pfn, unsigned long nr_pages, bool put_ref)
  {
-       unsigned long count = 0;
-       struct folio *folio = pfn_folio(pfn);
-
-       if (folio_test_large(folio)) {
-               int expected = folio_nr_pages(folio);
-
-               if (nr_pages == expected)
-                       folio_put(folio);
-               else
-                       WARN(true, "PFN %lu: nr_pages %lu != expected %d\n",
-                            pfn, nr_pages, expected);
-               return;
-       }
+       if (WARN_ON_ONCE(PageHead(pfn_to_page(pfn))))
+               break;
  
         for (; nr_pages--; pfn++) {
                 struct page *page = pfn_to_page(pfn);
  
-               count += page_count(page) != 1;
-               __free_page(page);
+               if (put_ref)
+                       page_ref_dec(page);
+               if (WARN_ON_ONCE(page_count(page)))
+                       continue;
+               free_frozen_pages(page, 0);
         }
-       WARN(count != 0, "%lu pages are still in use!\n", count);
+}
+
+void free_contig_range(unsigned long pfn, unsigned long nr_pages)
+{
+       return __free_contig_range(pfn, nr_pages, /* put_ref= */ true);
  }
  EXPORT_SYMBOL(free_contig_range);
  

Just a thought, I dislike current free_contig_range() and the duplicated
variant.

> +}
> +EXPORT_SYMBOL(free_contig_range_frozen);
> +
> +/**
> + * alloc_contig_pages() -- tries to find and allocate contiguous range of pages
> + * @nr_pages:	Number of contiguous pages to allocate
> + * @gfp_mask:	GFP mask. Node/zone/placement hints limit the search; only some
> + *		action and reclaim modifiers are supported. Reclaim modifiers
> + *		control allocation behavior during compaction/migration/reclaim.
> + * @nid:	Target node
> + * @nodemask:	Mask for other possible nodes
> + *
> + * This routine is a wrapper around alloc_contig_range(). It scans over zones
> + * on an applicable zonelist to find a contiguous pfn range which can then be
> + * tried for allocation with alloc_contig_range(). This routine is intended
> + * for allocation requests which can not be fulfilled with the buddy allocator.
> + *
> + * The allocated memory is always aligned to a page boundary. If nr_pages is a
> + * power of two, then allocated range is also guaranteed to be aligned to same
> + * nr_pages (e.g. 1GB request would be aligned to 1GB).
> + *
> + * Allocated pages can be freed with free_contig_range() or by manually calling
> + * __free_page() on each allocated page.
> + *
> + * Return: pointer to contiguous pages on success, or NULL if not successful.
> + */
> +struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_mask,
> +		int nid, nodemask_t *nodemask)
> +{
> +	struct page *page;
> +
> +	page =  alloc_contig_frozen_pages_noprof(nr_pages, gfp_mask, nid,
> +						 nodemask);
> +	if (!page)
> +		return NULL;
> +
> +	if (gfp_mask & __GFP_COMP) {
> +		set_page_refcounted(page);
> +	} else {
> +		unsigned long pfn = page_to_pfn(page);
> +
> +		for (; nr_pages--; pfn++)
> +			set_page_refcounted(pfn_to_page(pfn));
> +	}
> +
> +	return page;

Same here, might be able to make it easier to read like I suggested for the
alloc_contig_range_noprof().

Or that part can just be factored out?

void set_pages_refcounted(struct page *page, unsigned long nr_pages, gfp_t gfp_mask)

or better

void set_pages_refcounted(struct page *page, unsigned long nr_pages)

And deriving __GFP_COMP from PageHead().

-- 
Cheers

David / dhildenb


