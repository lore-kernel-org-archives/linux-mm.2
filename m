Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 260AECD37AC
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 17:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A94C6B00AF; Wed, 13 May 2026 13:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 681096B00B0; Wed, 13 May 2026 13:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BE066B00B1; Wed, 13 May 2026 13:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D2E36B00AF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 13:19:18 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECE0F1203DA
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:19:17 +0000 (UTC)
X-FDA: 84763057554.29.9C7E110
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4C0F0140014
	for <linux-mm@kvack.org>; Wed, 13 May 2026 17:19:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iGJBov3y;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778692756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YamQK5kK22KcPqnNr/iGuvjFT3pL4Ay0dZyeztw/mJw=;
	b=XPMeoKjKR8eR1dZSgLeEI1KyGOSCisaXqeLop0ToHeteshC8CyIY0FjIAQwEYhgoVOSvfL
	3gXDXM2aQMGoOvJ1y/oHbXjwGgIE3brAM5vi5ZpB4oEF6ls67/XBmwEs2bD2cO7msKQhP9
	iLPvg7X3N70Ni08LhDvnbDmy9wSvvec=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iGJBov3y;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778692756; a=rsa-sha256;
	cv=none;
	b=oreOB1Y38cRSKfjVe+2GjeVdr6LBrX4AG3vEmNCagsP8/gn8UtPghECupEGWRC3oQyFg6C
	wmXWbI+mSnyJ1mLvz05qmFsV43uMSQMEpd+liFdH85hthyWuGgLIRGamhGM82MCbTznk8v
	JvUZzPJshty21+cHk3zNB5r5FdrSt2g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AA29960121;
	Wed, 13 May 2026 17:19:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B24C19425;
	Wed, 13 May 2026 17:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778692755;
	bh=a2m0H9bRkehtzq1C47bsY9lKLcn1BhGr/BABwJip2hU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iGJBov3y/YQVckiqnx77E8+ICLFUz4bhqGcVM6VJaS/O6Yz03Ti1LQWVHcKH1fVFu
	 AtN57f+nCsK4WgzJ2b38M9JmXzTFElLiuh9CqGyG1HH/VXM7fEFFXmWe/duVezBZdC
	 8PGJhEoYNEHfkWfdsF/tcR8cMIhRZ9fBxmcn0h92TNSMhuWcftmrxwyIyujE2msDfu
	 uBHuVeQulmw985uYf2gBoVxu7bqvYxzGfbUBPzMeQ4xGLo5k317DmK+07AzEixx3ec
	 SMs9AijHSttEKjdOgoPiyoRXkB2VoXrrUg5v/ZG8JIFqDwpWTF9RPAqjNlPqhMcmtl
	 09CJNtLSeBiqg==
Message-ID: <4074a816-9e75-45a6-8141-25459bcc106b@kernel.org>
Date: Wed, 13 May 2026 19:19:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/page_alloc: remove ifdefs from pindex helpers
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
 <20260513-page_alloc-unmapped-prep-v1-4-dacdf5402be8@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260513-page_alloc-unmapped-prep-v1-4-dacdf5402be8@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4C0F0140014
X-Rspam-User: 
X-Stat-Signature: a8uc765tqdyjhkqk6hh6don4rebdo9en
X-HE-Tag: 1778692756-86989
X-HE-Meta: U2FsdGVkX18SRVBbZ5V1mBvZUzgZBDGb2QYlALgfQplxJp1HqNuCtMA8i3QBgmjeduVL5qQDLajcx2ifnrTGt+l/YeqDaT43wieVfMtPid2gP5GQEeNfEDk8WMMWARw2X8/Tz54JZpDWMEbekfaq9wPbscrZ1UpdaXXj1iat71nZtXfuHxAK2YCuogql+gTCgitOV8AseRQQVy/Y3E2+SCuRAslPoPoKnXyDy9xVVMDENWId+PdP7UglvbbAb2nSStgSbmhF7qiSSzyN8uMdY2gFYmHbYg35OixoLuJs/wgJKGv2ZBFCbhLHQtfL8PmunIQeuR0LgTsCHQVRjrYcB9Y0EGmNHIJGeCki8u8l46HfJNzEEV+qvRAHYtxRASMmy6zCBDkq7rbrUgZBq79TGO0/kO0Bsc97rLHJwPKllaKID5c6bP1DAMTeUvRQpbKuDvPGIM0SASRZum0KoCu0TrQ4ME/SM+BdvGp9oYAvv0OXatCRq8Dw8E7OldHAkn180OwpvPPEPGAwOkBk+KXWh8C3LZgrRhFzJ/sK3Iut3iPGyT6Sex0WkurNYyTz0ailzda/RKtjmuWys7/PaK860KZ4oOtG4A1CeSH8L/Zora73N+SlIdpWJ2tIbuFAUpcEmBhojOZ6V9UkcHYD5iEZRvjaFBzGEFhR+B8PHB2JxYI5g8e5yWcmH0883egW+/Zx0GK5a0A6GctxZnbaoHz5oWw5vqDktmNEpHY7z8dlu9Q7T/P3dJ0TgEAn5GDLv6SJuvb5tCthwck9vy761LRT8cdfRodhYbYrV5DWx76ix0YH1n+HJMceGcgPUymtIDT8wc7PUWMuUc7Sfqjvdbh4RtQeFN1NItzQil1cjhyPy7ZR8P3WwcaZQ+3RULwb3mm59oEg0I+PJ3pQdAlmMqIegGrJYsRgQQs4ilp0CPODqOD3d+VIEGs10d9t6f2nVptG8zDdXU29Zajdgbtl3n+
 dQMBvM2+
 HUWsTrG7klyqxCvQT9XuguiySvZDJWviFMyq7SAbX8VVdB+ZI8gvNGbiglnhyxuMQJ1tSr4oOkDBatHj8Qx1rGjO8mMrVTCDhkLLDGFCsBvaPPUp4H2fWDK8hbwfRShuMXkxq2MxO+Lnguo7KH2nlEMRJxlmAw9QYvml5Gc8Rf/kzF6Q4KOiL9OUWMMMU1D9q0PZEdRRyeAhEQdB1ZD6a3ByzkH6yAxePCB7kzXS0LxMQOI5Q3g9XdrO+bGaW2E6BOyI5zXN0FuK3ASPWwCwewHpivFfUBEDdk+roGBmrrWagYUoCCLib5SkSRt7NeIZ/yUasj1/2oqeCZxwiB8eHFOnz+gsFhyfNqsN0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/13/26 14:35, Brendan Jackman wrote:
> The ifdefs are not technically needed here, everything used here is
> always defined.
> 
> Switching to IS_ENABLED() makes the code a bit less tiresome to read.
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/page_alloc.c | 30 ++++++++++++++----------------
>  1 file changed, 14 insertions(+), 16 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5d6144c8860ed10fd641184f389c4953465d5178..2985ad0ab1044bdfda8ccc7aaed2ded19b5ac7ed 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -650,19 +650,17 @@ static void bad_page(struct page *page, const char *reason)
>  
>  static inline unsigned int order_to_pindex(int migratetype, int order)
>  {
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> +		bool movable = migratetype == MIGRATE_MOVABLE;
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	bool movable;
> -	if (order > PAGE_ALLOC_COSTLY_ORDER) {
> -		VM_BUG_ON(!is_pmd_order(order));
> +		if (order > PAGE_ALLOC_COSTLY_ORDER) {
> +			VM_BUG_ON(!is_pmd_order(order));
>  
> -		movable = migratetype == MIGRATE_MOVABLE;
> -
> -		return NR_LOWORDER_PCP_LISTS + movable;
> +			return NR_LOWORDER_PCP_LISTS + movable;
> +		}
> +	} else {
> +		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
>  	}
> -#else
> -	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
> -#endif

Uh yeah, VM_BUG_ONs are frowned upon now. But doing a VM_WARN_ON_ONCE here
makes little sense. There's no safe fallback if we end up here with a wrong
value. And it's all internal to page alloc so I'd just drop those checks
completely at this point.

>  	return (MIGRATE_PCPTYPES * order) + migratetype;
>  }
> @@ -671,12 +669,12 @@ static inline int pindex_to_order(unsigned int pindex)
>  {
>  	int order = pindex / MIGRATE_PCPTYPES;
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -	if (pindex >= NR_LOWORDER_PCP_LISTS)
> -		order = HPAGE_PMD_ORDER;
> -#else
> -	VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
> -#endif
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
> +		if (pindex >= NR_LOWORDER_PCP_LISTS)
> +			order = HPAGE_PMD_ORDER;
> +	} else {
> +		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
> +	}
>  
>  	return order;
>  }
> 


