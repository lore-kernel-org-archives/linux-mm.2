Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1096FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:53:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F146F6B0088; Mon, 29 Jun 2026 10:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3CE6B010F; Mon, 29 Jun 2026 10:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8BD86B0118; Mon, 29 Jun 2026 10:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B284B6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:53:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3AC1A87CE9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:53:54 +0000 (UTC)
X-FDA: 84933244788.28.6D2A6AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 49F5440006
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:53:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LlI2kWZj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744832;
	b=CuaE94khMUXexk9xpTZywxfYaNiWOgjenGJvTU/B5Uunw4DOczpsIjXlb2fe/5HRP28wqi
	nqiYGzZiq+k3gOLd1BxZWtyz/H2HZwgF7POd8Q1143qgsfpIFin+zDGplNk0OztFMBr+cy
	Ko35AVTwOyKHWuOsPftbI6Ne2RqDRBg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s4VhTl4gCqM8Ky+x9qzAr1fbtUEk7+DIkvjnRs42Zt4=;
	b=AHiNDtqSt6taKELBoO9hjhOiK0ix2O4rIDhpBeFJ7SffXNrSMpfBUCkdGtgyA6CMoIBwhM
	hY3ntSXhIo334dlREerRjw8aBNQbbCtFvUfEaSNXkizgII4SWVF0Qb5fJR0XJe/4noPUd4
	PR2Wgs4sZSZoPzq9c8I/kosY83fPmWM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LlI2kWZj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 529EC43850;
	Mon, 29 Jun 2026 14:53:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2AC91F000E9;
	Mon, 29 Jun 2026 14:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744831;
	bh=s4VhTl4gCqM8Ky+x9qzAr1fbtUEk7+DIkvjnRs42Zt4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=LlI2kWZjYNMvV8j50tEwPH3CWa5JeNC84gTm0y/3FyhWfX32+yoreGPoFmnXkg2FF
	 25rsY0R3V7hxbqPdMg04oiRO7MSdlzM7YdnCmlicv7M7HllEiFD+FMMwmtQRLn4NMm
	 nHW4e5Ovut2VHqkLRuQIqDMkYLCYz0sxCQ2IQAILrW8pIAEJTSxvAteAve4li3z11j
	 5xHtAxkK2xA2PK93Id3u5Je3BwN0BQ/ive/cCs2PkKQymRFw3uxN/aTIhGII8HFUDE
	 n+IxgvV729xiQcbDTy39hFSJ8yrLer6wu28HjfK9M0ngHsRhD3NGYVTAaMl7R1P7iD
	 g43yaRuo4Szmw==
Message-ID: <43b67098-b9b3-448f-aa7a-43b7ef678e1c@kernel.org>
Date: Mon, 29 Jun 2026 16:53:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm/page_alloc: make sure subpage->private is zero at
 page free time
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-3-f4ce3930d10f@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260628-keep-subpage-private-zero-at-free-v1-3-f4ce3930d10f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 49F5440006
X-Rspam-User: 
X-Stat-Signature: 7diwo4em33tzext38wcf3bhp55uprg57
X-HE-Tag: 1782744832-6064
X-HE-Meta: U2FsdGVkX18nT4oc28xnLg6AwaX9cA+lcL5zkSBn6W5+HEFSSquoXvqdQJYYGVSV0QN/BGwjtQWwslCP8df5EyZp7fKGA0G6c62CBpSK/JhNc/fhrcgl2i7ha1zNHa+GRznEhoIv+HRH4TDO21JPaexi/7Zn+mOCoiChgaP32u3Hs3FcF2QHxi1WvNMbtn2pUSouQc2QPfQsHxKg/yozBGvGtM4RGrinuMnwjRQ6ZKTWJQ20BrBjOmtcCj5Pil1UQtOm+pIZdF1mUaLQ0s3me8IXRNx7BDwxFOXMTItulZs3Kt/+kfpVuLt47+3t66eJTk3JEW4k3TWvwpdjH+iEVhhCSJK/Lvvqe3V7cF17gtPziLeNLn2T32o75ovp0q7IOSaD/NtWiXRgZAMcuLKMZsGK4f5EwHBljN6hXpyRi8XIz0NzMrm+la+I7UkRWtSmjFbexiHyTyz1cdcK3g0iDPB1MIDU8FkfI8KqH2AVinVF/y5tJW6eEffmbqUHAIOsTV31blZ3S8rIyhWGpp+GsndOgZVfe5+5QGgq1t5cmsjMPvRZkydjlMhc5wcEdKdCcwFKE7s6jyrReLwWcF0EDxx2IEXoS/rxAbuBzNtEkv7uCz70HWuY+6CfgqObOfhHhjnMZ6qGDZx8vPWiFz9xMArURrhA31HK97P7UF6bYPW8j+8wS6qSwTKa65SDRY3b6qqbnynd/uzJTydzw0wJaljQMMdwXqyLsY3cctVPVhny20g/hpOWMkyeopEYcd+iR6V388Q7QDH62aiZltOi5aFXGSFHeqo1L4VncUaPHnKLzdsR6eg5ubDKpjnDL+RUc6TBdQHPnoaes2R+Vvzs/4dep10tc3ioCtZWxT/LmrEt6clLcBfkVi+GOgLLSTcnR0RSkW9wwHGEFyb5OV6Y3Qoav0VWZtjNGksTFa28TQzOj/3o2TCMXrhR+t+xNb5XExo0jRQEUkFxb0IZU2o
 seB+5x/r
 M1nMZvSFmhtuU7Sa7TZ5KtcR6TXfu5RJP5eJQyaSBKHOOWezcUGsY2Bf2xLWWEK/jgP42Ig78K5P9kuwpNN8KQRl1VpsRzsS0B6sVAQeM23bu25rnQnAai16x3g8mDbEGwyMNU5YT9vLDQtNUO1vNHsCJhw778RIBQv8MrFe9blO8MRNRqWMeHELRboq4SrqaSdy6cJ4uiu7Zahl7Gz5X51YZBCP+S6tvqXDP3Yw2mFNynMq4WJnXm1Y138hYhJ6oszhANqc+Bye6chWX6Pqu9vVX2GM+60hB7ukFvW2jDGaddL5IbiHTPczuJ9xPfsMgdNVhHB1CBzf7zzKU7Q73ldXoyLPQnFtLXCz2+g6dT4DEJ9/ALjQaxxWWYci4o3FFlLBJ5zX8XUI1THgHNhAOLYaymc0FheLGGwCX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 04:56, Zi Yan wrote:
> Any code using subpage->private of a folio, a compound page or a high-order
> page is supposed to reset it after use, otherwise ->private data can leak
> to new page user and cause unexpected issues. Add a bad_page() check at
> page free path for it.
> 
> Assisted-by: Codex:gpt-5 # add the missing "return false" after bad_page()
> Signed-off-by: Zi Yan <ziy@nvidia.com>

I noticed the word 'subpage' is now frowned upon ;)
See https://lore.kernel.org/all/20260623125723.2503832-1-dev.jain@arm.com/

since this is about tail pages, just call them as such?

> ---
>  mm/page_alloc.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee902a468c2f..13c2655e24fb 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1374,15 +1374,21 @@ static __always_inline bool __free_pages_prepare(struct page *page,
>  #endif
>  		}
>  		for (i = 1; i < (1 << order); i++) {

i starts at 1

> +			struct page *subpage = page + i;

so "tail_page" is accurate?

> +
>  			if (compound)
> -				bad += free_tail_page_prepare(page, page + i);
> +				bad += free_tail_page_prepare(page, subpage);
>  			if (is_check_pages_enabled()) {
> -				if (free_page_is_bad(page + i)) {
> +				if (free_page_is_bad(subpage)) {
>  					bad++;
>  					continue;
>  				}
>  			}
> -			(page + i)->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +			subpage->flags.f &= ~PAGE_FLAGS_CHECK_AT_PREP;
> +			if (subpage->private) {
> +				bad_page(subpage, "nonzero private");
> +				return false;
> +			}

Also why not put this check into the is_check_pages_enabled() block and
handle it the same way?

>  		}
>  	}
>  	if (folio_test_anon(folio)) {
> 


