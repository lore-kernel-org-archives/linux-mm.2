Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B62BC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 352D46B008A; Thu, 10 Sep 2026 03:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3058D6B00A1; Thu, 10 Sep 2026 03:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F5DA6B00A2; Thu, 10 Sep 2026 03:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E9A576B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:53:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A879AA0490
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:53:27 +0000 (UTC)
X-FDA: 85197087654.14.6F9E58F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 032AA1C0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:53:25 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhV9mmVJ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789026806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KRB916lj3l/kaoIROZgvEq5UY1QI+PbW3M7goiEHvOE=;
	b=HdAeTScEubmuFp79d6ZBap5eOLVjs5//TthdVKKjoRD595pZUVkexru/ok4bga+LSXKnWV
	W+A1TGysAPYFKZFOMrBMXdEfvkWr+V6ZDa9WVBezfR/EShku4XzhaRwskmtQxHJP/3Cfbd
	+mEQUGyeFgEmYLJGsFMMEHdLMdTCWTY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PhV9mmVJ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789026806;
	b=s/x5ScGPmivi6MTx5vh/xI+b47LvEUTZW0Dr4Zu9glDhOB6eMbnHnHH5j1mRlEH9z6/52p
	joyHQRt3GI7guMFg6kCVbQ44lM2FMxcuCNeAGRmsIVEiVLbxkxfsa0j1Mo9PKSnSSQGhkI
	n2z3rEuKPRW+dKKoJDoweV8eqltkCi0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CD00601EF;
	Thu, 10 Sep 2026 07:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5A31F0089A;
	Thu, 10 Sep 2026 07:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789026805;
	bh=KRB916lj3l/kaoIROZgvEq5UY1QI+PbW3M7goiEHvOE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PhV9mmVJj8HaWPabBYhvMSsgZMBm/iNmNrVKbOAwBrvBUDAS3kQzPqHIsoQoErIZ+
	 kUhMB7AiLoWxhuQwHEtRsLJ+TcYl/HFfQkIH0iosT9Vlfk/ZtkRrN7667NE1qNLDHA
	 3AWysrlhQkVoPGtjqmN2K0E1FN0qTC1lIjb5S6M3W7UXsmbTNfwG4r9hY0DDdOA4r9
	 39KEZ4ww4zwmSXesWcJRj8jYzQ6s5AlQXWTz5KJiYZ7+480u/c5Ev5cs/GMeJ6Ikl5
	 m+vjuqsmPW9pRo8g5Hx1mk/LubFTe1VuqHcmHEu7leARLCHxOafE/t+y+DHmEzvslm
	 eEdS7mvZL1hnw==
Message-ID: <b803e45f-76c2-44bd-a913-9ce310319f41@kernel.org>
Date: Thu, 10 Sep 2026 09:50:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 03/11] mm/sparse-vmemmap: open-code
 init_compound_tail()
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>
References: <20260908030335.96549-1-songmuchun@bytedance.com>
 <20260908030335.96549-4-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260908030335.96549-4-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 032AA1C0004
X-Stat-Signature: 39zdgz79f6m916ss5ykt9bddcksfenog
X-Rspam-User: 
X-HE-Tag: 1789026805-374138
X-HE-Meta: U2FsdGVkX1+bJ7aCJHnGd07VSlkR2mcuhqCckLUBVqw0X9/C4JaUszCsDIq2qQZjqa6UHMTpIa3OEh9Jnbd/P/kIy+K8iWjQo0KOkRB7swvDuOsVEzdC3NCHzSkLE5Dppk2UfgesOROX6IXnTfu0wsSVpS/sXh98MzmB9i6ulcULurez/Zb0XghnSKgl0LjkweDeBuM523yP1xtW4tr7LwUA9iNucXCe84QUZ+Ydo211V1Urmie/xZP3RbElKkoyfPb0hzOIcl6G6+rtnGyWI3xKED+AwAZbyDR4zmWvy7DEux6gPaUGAiK2j9iXErawWbs2IAmUaEdoLIS5PMfAcng9ffSd+6rc/GlZtIqGtu6x80H/AJ1If2l12YPyFv2A+bZ3jHWWVqC7NEZtAkyzPk3UxwjkKbCXQKqL80PbOl6uUpj5PPHpXkaZSVdhxvRM7vnYnkxxrRWknLCCwoHPsKlsv8H6lxKIZ00/fb2Cc4RERgqiJVf7u/pFB94YwqygKtY7aP10s//o0kaHmR9MH6/KX2lJ1648tPwQLFOg95sFAz6Tw4YcOW+Z15jsx6J99bm+7AYeHMeUwL42V/+rM/uOyWhRp2xyfGgQg1lt8RhsGwWZpoHTlD/0BrcUInShW+Vpsj1DKaZUjWh3wI/cLezbiNOjQJ0BCt0IZcCNsAO8erT2i4I/ojozl2fc6SJiEMZqU32ILGRxcCpkmLf0nwDXS02c5WFXu7it18GGe0YTDK/kB1IwhYCT9PRt8++f9lrm23nMfvioM0FR/7bBD9JtTSA2MUD1c/bmi4kpkAhOfcKJVQIicGwlsPp+FUBpu5TfXVG9oXrfvcB12bEypomQLUbCxr7lwzstAA6DI4C3YVxBOYor+TmqktdkMyd/bbDTa3EVYXFdHrQflPYiisMkK0J4kGg/A2DdMgHu+Jeecc9ffOYBejr04VBX6tr0daxMRAuuhaWGDiCVyw3
 Pg/LVwM/
 u5Xev+jlX1q79LOVkgBCN5wMjTGiIBzgZU1hx8cS352PGYh4bicwlZsOPJSJhawGf2dfW2QPcoUHMZtQvqs1R+iBqzJV8sPoFJA/6LccUwjTmfgIvV/vVkMyUr5aEIOZcuenv+S3umhmwbkUUT41qRj04tOTFaelMVG/9QEAlAugWh5bpWEktVGqhs4PZNMix+JkqcurhbWmJsysFisdTEvBBz5HOP6daE15MvMSKdJt6UYBkcVZnTgm6G/MQjyQdcoTmWV9oQWA33QW93YMmZsl7tPo1nkzyfJduuQBduLi4iHet3knnYx4d5+4IJmCXr08gKBgF1P9is1H+T+fg53O5fAD6UGSxx5NP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 05:03, Muchun Song wrote:
> init_compound_tail() is only used by vmemmap_shared_tail_page(), where
> the shared tail page setup intentionally passes NULL as the compound head.
> 
> Keeping this helper in mm/internal.h exposes that special case to the rest
> of the MM code and can make the NULL head argument look generally valid.
> Open-code the initialization at the only call site so the special-case use
> stays local to sparse vmemmap optimization.
> 
> No functional change intended.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> ---
> v2:
> - Collect Acked-by from Qi Zheng
> ---
>  mm/internal.h       | 9 ---------
>  mm/sparse-vmemmap.c | 5 ++++-
>  2 files changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index da14c56fb24e..0dca33db068f 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -786,15 +786,6 @@ static inline void prep_compound_tail(struct page *tail,
>  	VM_WARN_ON_ONCE(tail->private);
>  }
>  
> -static inline void init_compound_tail(struct page *tail,
> -		const struct page *head, unsigned int order, struct zone *zone)
> -{
> -	atomic_set(&tail->_mapcount, -1);
> -	set_page_node(tail, zone_to_nid(zone));
> -	set_page_zone(tail, zone_idx(zone));
> -	prep_compound_tail(tail, head, order);
> -}
> -
>  #if defined CONFIG_COMPACTION || defined CONFIG_CMA
>  
>  /*
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 70143dd8b579..e453ce4675a0 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -189,7 +189,10 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
>  	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
>  		page = (struct page *)addr + i;
>  		mm_zero_struct_page(page);
> -		init_compound_tail(page, NULL, order, zone);
> +		atomic_set(&page->_mapcount, -1);
> +		set_page_node(page, zone_to_nid(zone));
> +		set_page_zone(page, zone_idx(zone));
> +		prep_compound_tail(page, NULL, order);
>  	}
>  
>  	page = virt_to_page(addr);

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

