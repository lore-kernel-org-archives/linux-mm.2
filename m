Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B5D2CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 17:16:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB8336B009F; Thu, 21 May 2026 13:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8DBE6B00A0; Thu, 21 May 2026 13:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCCB36B00A1; Thu, 21 May 2026 13:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA7E36B009F
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:16:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 801498FBD7
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:16:55 +0000 (UTC)
X-FDA: 84792081990.01.3D93E08
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 00D80180010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:16:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ub0Ujck9;
	spf=none (imf24.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779383814; a=rsa-sha256;
	cv=none;
	b=YbZ4YJRYgiN8W74bTFafJ8LJ5RpuqXuPfGFKI0PGOjXBLtkuUPrKQ4BaBGqEwbzyDNuGIP
	WrLKGVPtAW8qjy/scS1hWkPcKozqHkgmyGd/qR/eZE7cAtvWu2pImTJI2DIq9lb9F13/5Q
	TFSVbb/AWp96CEWCASRHglkcGqL4+ME=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ub0Ujck9;
	spf=none (imf24.hostedemail.com: domain of liam@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=liam@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779383814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZvUjhf1UU/IohtHymqimCuPKGDaSQBsrsNMlIA60drc=;
	b=ePYwF16N3lhnjeG9gr6FUFFhBksSviyDmTTdxe+pyFLwkp0rMYFJN43BKN80LQk8FHceK+
	RDhXOb5mW0/aG9v2ftmzPP1rpvyBTMeEfPLzPGO+169WPn81HJUkvlucDCrGS7u5YEa6m0
	fLrWVpq7KYqt0gOK6iRH3GHOUoNMkPw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZvUjhf1UU/IohtHymqimCuPKGDaSQBsrsNMlIA60drc=; b=ub0Ujck9hnxGESg0BOKgJ4xVXT
	L1UOhZJowMMFbByRnTcfSo15BTAqDPdk7zOqWTaGvE2CGQ5Ta2NxXuUtaxhH//STzNDdmUpM3ZaRI
	ajidiw6tUhsGiUqNgzIUVmcMXShVld5lLotoOnRZE09/J9Uqf/mwUfTebkDlnHGMEzxS9KZAXdo9H
	ygdQibwbGeghHNYLcVwoyghEFmClmSbNCbvmtDSlNrPizo0ojNQEZ8vY3P4KrCRZSuyb4G6AJSj7P
	QyCTnCURVpxfSG3jlDxuHMfuQuZLKPnJDtWH/qd8Ep5QdJwmj0MeWrHwiDN9VICp68T21wvOHUCKF
	mTppm22w==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQ70o-00000008bi0-02sn;
	Thu, 21 May 2026 17:16:46 +0000
Date: Thu, 21 May 2026 13:16:43 -0400
From: "Liam R . Howlett" <liam@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Dave Chinner <david@fromorbit.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Kairui Song <ryncsn@gmail.com>, Mikhail Zaslonko <zaslonko@linux.ibm.com>, 
	Vasily Gorbik <gor@linux.ibm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/8] mm: list_lru: deduplicate unlock_list_lru()
Message-ID: <x6zjeg2tlnuz22ofpvlpmnskiw3gnkhkghomfgdasfajwwye55@pbz76jdh2tru>
References: <20260521150330.1955924-1-hannes@cmpxchg.org>
 <20260521150330.1955924-3-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260521150330.1955924-3-hannes@cmpxchg.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 00D80180010
X-Rspamd-Server: rspam03
X-Stat-Signature: pf9tf5cb88qyek1j1ea8pm1pj6839oye
X-HE-Tag: 1779383813-531904
X-HE-Meta: U2FsdGVkX18GDmFLLhVgEI4DdMasDy0bPPX48RrNk69772dq1Rx92zL3V5cJcy3kSPDS4J0u4g2VvPdKo+JOwyHX6urn18shR2U3wkdNyhNVkKXxvYbR/faE0WimJUmUETJZ0VyZspH4Re2LiMfU9KYaF/puWThxg4Bt2z/E9/iWVfdTvoV0udRL+vD3tcTlw2ht6J529QpctzMljqJ/x+ggnSeQHncF8VvLsDe8OpEAZ34NPrMLjd62mGbUSLH+RGDfKIPaSIMAo8k9n0uDnlBDv6ORwOuH8EQ4mMtF7hm5+tt8MhDr1DNfFIJApl3hvdHAhJ6dDwwyOMxFLf6sKuvY0K373dhDIs9mKylApDO/ISp0oz5AVbpvEvgsvHBaYHiQZ9bzc9LMmrqqhL/IinLOARTzHXoC6JR9+fd/QHl7+G+HtTuiX8zqsD1bSZ8fAtv78fyTAwjqfOmUFq3P2m6zl95JeTzyaKYHAvkpHEIDvFZBhi7uhhyda0I9YBslbApP2gRefifEAnwJ5ZMMCBuCQ21hh/OwJQ3Py9XpSIFJRQxSgrk9gag0JClpomiMMNOU2iPRui6GrXbYxvyxbLZ1sTJpwEYPNZsN9q2IzByb4xmHCNUzH468kIhKZ9mDyX4EDV/Kwl9VT3tBTRTHnuOwRO5bGfLQGU8kR2FdM1qvVRhhFuHYn5zHWRYp4AlZzn3R/46sOkk35Z7q5wAEM2+TAYO0FtePavC8sU3d4msHlRc7zhNFxV04RF9jyuvmZ+xfP4slnJiIchHBazW1FJWOGlxQ2mI/UnBBAwFI7UNiAOJM573brr5KFwEzD1QUMFvRcSEFLcpvUMGzRyKZgr3OjtoThkDLS0Gb1ijUDOOdRx/m1vwt5zKeIM7/SxDgOX35rqvsm7Gy0hyMqsDexIIT+k7MkGz241YiRjQp3J37EzFhCvkGfVtTjflMsjWT3qxVI3MX22499n9Ji/l
 AojVA+G5
 s8tDrUxHtXkz29AaLZZ+qLnXQrLQ400ZNiggcRmb2ppiaer4xgonwVm//usMhyNmgyWcEod0vwhewyw+kaWB7TonitEaVZ0CbAlKnRhGr/fcfT/wjdIiSMOz2y5MnyMLNngH6ypwGvTIRYEf+rPUFLBe0QJ/aO0M2vMzcgJeJlPGYZ7+yY/YYcVEMpPCyzNyC3AKjPqGAD1wboivxe64OUwS8Cu3D1NG1QiIpjBknMt+numsczxdPMy+dzi3k5xIwkV7Ne8PwefmgHmP56MxAlfYSJ43gGquo6L83l5K1FUYks2NnjJQdryKYv02+ZYScR35RjnVc3x7e5nYEoG4ddOFyoCCgH7Kg0xBbOekf+w4oxeP1NzutWuCxAifYcKJAOrpJxPW2prsTZIdbtCL/m2VMgCNrfzt2ns3rVsHJOoYHQPCoYRp7qqhzmueIDIJSzFvES81tWRufYwQRur2mf3Ms4S6YPMIvig6Q5tiOUcEFJecWpAyG/neTzEK3l9dvg+zp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/05/21 11:02AM, Johannes Weiner wrote:
> The MEMCG and !MEMCG variants are the same. lock_list_lru() has the
> same pattern when bailing. Consolidate into a common implementation.
> 
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Liam R. Howlett (Oracle) <liam@infradead.org>

> ---
>  mm/list_lru.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index d3619961a7ac..9a68177619bf 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -15,6 +15,14 @@
>  #include "slab.h"
>  #include "internal.h"
>  
> +static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
> +{
> +	if (irq_off)
> +		spin_unlock_irq(&l->lock);
> +	else
> +		spin_unlock(&l->lock);
> +}
> +
>  #ifdef CONFIG_MEMCG
>  static LIST_HEAD(memcg_list_lrus);
>  static DEFINE_MUTEX(list_lrus_mutex);
> @@ -67,10 +75,7 @@ static inline bool lock_list_lru(struct list_lru_one *l, bool irq)
>  	else
>  		spin_lock(&l->lock);
>  	if (unlikely(READ_ONCE(l->nr_items) == LONG_MIN)) {
> -		if (irq)
> -			spin_unlock_irq(&l->lock);
> -		else
> -			spin_unlock(&l->lock);
> +		unlock_list_lru(l, irq);
>  		return false;
>  	}
>  	return true;
> @@ -101,14 +106,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  	memcg = parent_mem_cgroup(memcg);
>  	goto again;
>  }
> -
> -static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
> -{
> -	if (irq_off)
> -		spin_unlock_irq(&l->lock);
> -	else
> -		spin_unlock(&l->lock);
> -}
>  #else
>  static void list_lru_register(struct list_lru *lru)
>  {
> @@ -147,14 +144,6 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
>  
>  	return l;
>  }
> -
> -static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
> -{
> -	if (irq_off)
> -		spin_unlock_irq(&l->lock);
> -	else
> -		spin_unlock(&l->lock);
> -}
>  #endif /* CONFIG_MEMCG */
>  
>  /* The caller must ensure the memcg lifetime. */
> -- 
> 2.54.0
> 

