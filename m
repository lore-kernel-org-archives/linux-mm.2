Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A38BEA8133
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 15:40:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33D36B0005; Tue, 10 Feb 2026 10:40:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1886B0089; Tue, 10 Feb 2026 10:40:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B95836B008A; Tue, 10 Feb 2026 10:40:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AB9726B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:40:39 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 576BB597A9
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:40:39 +0000 (UTC)
X-FDA: 84428959398.13.5946CC1
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf20.hostedemail.com (Postfix) with ESMTP id 146401C000B
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 15:40:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R07jyVUr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vro/yLie";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y948V8dL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ImZ6N4Ck;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770738037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w1SBLCqUDehKLVPMXDlPrAAaq85Rv1cIjWdbaILAeeM=;
	b=habIsHr/LEP8FaDbbakmWuE8DmoaCSRa8Ufc7OTNkmviEUTMorVEoaQQNfURvAhG4Z0Q7j
	La8l6Pkh807h1g/lzJsws1f0X+HMpPjckl3YNda8PB5HaYqYwP3xi4EyzHl590/vZIyon0
	r3A5v/2ZyLGY4SdE2fDk7CaMMtzb0sc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=R07jyVUr;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="vro/yLie";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Y948V8dL;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=ImZ6N4Ck;
	spf=pass (imf20.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770738037; a=rsa-sha256;
	cv=none;
	b=SXNtHsbq1ZkyKIo2pUQh2kvjICJti53JdfMdzsyw6J8hz6Izb0Hb/hbkw+joGq4Ss1LS97
	CVH3FhMCPbulD/dh9QGyvpHD8ZLbeNuYokMQmgFMGlAY9k5B7AFdsz2AF3TOghh0cpB5Di
	parnkxXEF3b3Mr4FQ4mkCWqFz8kxpXM=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 845DB5BD70;
	Tue, 10 Feb 2026 15:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770738035; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w1SBLCqUDehKLVPMXDlPrAAaq85Rv1cIjWdbaILAeeM=;
	b=R07jyVUrORVmME1tz6d4RAcxWtYFSxWruoYeWOgeKxj/oXwfoKORCI2Qyg2T08C2+MgsDJ
	/znzwTCoSMjQjW12XYhz8kBE7luRX+qO45YENuYsD+bZZhx20c/4TUgoZOeSyheBH7GlJj
	zq7bcTbyXj+cCfcLS0U5U5KSdWFqLlQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770738035;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w1SBLCqUDehKLVPMXDlPrAAaq85Rv1cIjWdbaILAeeM=;
	b=vro/yLieGuw6paUeVmci1At6eI3Ahp/S6PtPoMNDXXG/zClgKfVTfxVvzmpnCgWmrkGm6p
	c5vSnK/Gw1rIzYCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1770738034; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w1SBLCqUDehKLVPMXDlPrAAaq85Rv1cIjWdbaILAeeM=;
	b=Y948V8dLau51t+6BB1cC/p1m2+JQMMnbAdgk7g0rLQcebP1LYqJE0CZznfBdh997VQYkmc
	7k1ohgLVwN/Mami0n7j4Ouev3cUhQ6i7dc6pBE9bLY28vvIhJbpFOpknapjNjlinA6RIzk
	QcQ+W6upfrqeIv5VWx5EOQsi+GLv9tQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1770738034;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=w1SBLCqUDehKLVPMXDlPrAAaq85Rv1cIjWdbaILAeeM=;
	b=ImZ6N4Ck9+LL7JcKWdCAdPyiK+Vrw/yHZU+ozaIVDUA6hW77kj+EyMas8oGDv+9XnhOCRt
	ISC3+HdBvNI1iwBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 416E53EA62;
	Tue, 10 Feb 2026 15:40:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KVJmDnJRi2k7ewAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 10 Feb 2026 15:40:34 +0000
Message-ID: <12237347-e997-489b-9a62-dfb8ae00c9e3@suse.cz>
Date: Tue, 10 Feb 2026 16:40:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv6 07/17] mm: Rework compound_head() for power-of-2
 sizeof(struct page)
Content-Language: en-US
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@redhat.com>,
 Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>,
 Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley
 <paul.walmsley@sifive.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, kernel-team@meta.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-8-kas@kernel.org>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20260202155634.650837-8-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: mo8zjq11rdfakaejzosqebmxfwnmjcnw
X-Rspamd-Queue-Id: 146401C000B
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770738036-170535
X-HE-Meta: U2FsdGVkX18CLL1CxacZ5/IKVx1dRL0jdGvABo7xBmCQlhV13fLzIY+UFB8cBzFDOfZdY/uvCSOw5Q5iPdPlBN6oo4ebwa7c1lvzP26MdDK39F8VFyQITixHx4WKtf64SaxrMl9yaATWzuT0cmNjZhBOUQU5VZRsOJ/WWvrtQz6vdZ5ca8/XKtYQ/GyHA/Mo0JJr6nwAFCn81CmCQTZXudne12ppVt9PDrCDCImpcEZRdFCrVPG8+fUGlsXfX7JhjeE6pwYe0znKolsgt2ELnwvzkZ8TOxgfW0RlWY+IYzJdgOsMQ1YtQQVNTHSVPdIarCMSRgzetHmKVz6e5Kgdx6lMupQH3zNSKlJvGSyS1nEvJ0i0vbkyEKCh0KrIWYSjF8fvwi59kC1bRDVHKX+xpgwKl7KR1fNJoSdvtbIWFMRmmmRZdxQeOGHth3whrRZsSwHCZgbEVl4GD/v7Tzwed6EjkjxeBcr5U2HAftZcNUVbuAtsO9Q+aDu0vFMzbUl6TzV/FjNFbpQ/kArQca2v/DCCc3+2t1y8Rp0SGkLvjyqlyZiAgcbz0GmBWZkVlfhuG7Okhvy5z0rfVH/X0w5F9k+sxnx9x/TiPxu7SISefHy3WQZPHhwt/Exs1igqj+GzWlopVbg7RoIDtBQkwm5falwRvcj6hE6fJNACi0kXb/S6vdiDGpHEU+1SPvwTBbG+G/1nsJo8LOc+ehxGp/CoO3a45hK0IJCKZ2TkfUhP83sCT0fOm4H3MNAEMQdmaK7vp50gMxXHBKrT1BONSyTFpzI+tQdTP8MkpqvUCqx851mqS9CNMJZMeZuELRUa9WrLmOV5i5e0nmZo39KDoMyJYWpEN82Qsj4hYIQ1AigpuoeBeQgcfhKEnUKD5HHQq2JWiOuktitAr6wsLg1qXMrGJvRJAH70wjOudyexhiUXZFsX56dyZlkOM/hTwRQ8kESzw6mMeDnKcSVVULV7Hhl
 iY4DRxRB
 3MQIT802sBrdM1IM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/2/26 16:56, Kiryl Shutsemau wrote:
> For tail pages, the kernel uses the 'compound_info' field to get to the
> head page. The bit 0 of the field indicates whether the page is a
> tail page, and if set, the remaining bits represent a pointer to the
> head page.
> 
> For cases when size of struct page is power-of-2, change the encoding of
> compound_info to store a mask that can be applied to the virtual address
> of the tail page in order to access the head page. It is possible
> because struct page of the head page is naturally aligned with regards
> to order of the page.
> 
> The significant impact of this modification is that all tail pages of
> the same order will now have identical 'compound_info', regardless of
> the compound page they are associated with. This paves the way for
> eliminating fake heads.
> 
> The HugeTLB Vmemmap Optimization (HVO) creates fake heads and it is only
> applied when the sizeof(struct page) is power-of-2. Having identical
> tail pages allows the same page to be mapped into the vmemmap of all
> pages, maintaining memory savings without fake heads.
> 
> If sizeof(struct page) is not power-of-2, there is no functional
> changes.
> 
> Limit mask usage to HugeTLB vmemmap optimization (HVO) where it makes
> a difference. The approach with mask would work in the wider set of
> conditions, but it requires validating that struct pages are naturally
> aligned for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

nit:

> ---
>  include/linux/page-flags.h | 81 ++++++++++++++++++++++++++++++++++----
>  mm/slab.h                  | 16 ++++++--
>  mm/util.c                  | 16 ++++++--
>  3 files changed, 97 insertions(+), 16 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index d14a17ffb55b..8f2c7fbc739b 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -198,6 +198,29 @@ enum pageflags {
>  
>  #ifndef __GENERATING_BOUNDS_H
>  
> +/*
> + * For tail pages, if the size of struct page is power-of-2 ->compound_info
> + * encodes the mask that converts the address of the tail page address to
> + * the head page address.
> + *
> + * Otherwise, ->compound_info has direct pointer to head pages.
> + */
> +static __always_inline bool compound_info_has_mask(void)
> +{
> +	/*
> +	 * Limit mask usage to HugeTLB vmemmap optimization (HVO) where it
> +	 * makes a difference.
> +	 *
> +	 * The approach with mask would work in the wider set of conditions,
> +	 * but it requires validating that struct pages are naturally aligned
> +	 * for all orders up to the MAX_FOLIO_ORDER, which can be tricky.
> +	 */
> +	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
> +		return false;
> +
> +	return is_power_of_2(sizeof(struct page));
> +}
> +
>  #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
>  DECLARE_STATIC_KEY_FALSE(hugetlb_optimize_vmemmap_key);
>  
> @@ -210,6 +233,10 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
>  	if (!static_branch_unlikely(&hugetlb_optimize_vmemmap_key))
>  		return page;
>  
> +	/* Fake heads only exists if compound_info_has_mask() is true */
> +	if (!compound_info_has_mask())
> +		return page;
> +

Could we move this compile-time-constant test above the static branch test?

>  	/*
>  	 * Only addresses aligned with PAGE_SIZE of struct page may be fake head
>  	 * struct page. The alignment check aims to avoid access the fields (
> @@ -223,10 +250,14 @@ static __always_inline const struct page *page_fixed_fake_head(const struct page
>  		 * because the @page is a compound page composed with at least
>  		 * two contiguous pages.
>  		 */
> -		unsigned long head = READ_ONCE(page[1].compound_info);
> +		unsigned long info = READ_ONCE(page[1].compound_info);
>  
> -		if (likely(head & 1))
> -			return (const struct page *)(head - 1);
> +		/* See set_compound_head() */
> +		if (likely(info & 1)) {
> +			unsigned long p = (unsigned long)page;
> +
> +			return (const struct page *)(p & info);
> +		}
>  	}
>  	return page;
>  }

