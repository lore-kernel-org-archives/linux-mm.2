Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 093C1606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 22:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bhk50nlb
Received: by kanga.kvack.org (Postfix)
	id 07EBC6B00EF; Tue,  3 Nov 2026 17:20:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 030016B05B1; Tue,  3 Nov 2026 17:20:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87BD6B05B4; Tue,  3 Nov 2026 17:20:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C354C6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 17:20:53 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3505B1C3E1A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:20:53 +0000 (UTC)
X-FDA: 85395228786.04.F57E246
Received: from mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5DC66A0003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:20:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bhk50nlb;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793744451;
	b=As4+GhSc+i2GLHPxo4mm7+FKhfKWes/5O0C1lyGLevc+Cme5yC4+cf4NUiemKZY+dbgAUy
	qHUldvCRRV7shS8oAreTCs+pD1/5StQIaqpzgi6UGl6962+OmDpyOIWGBjd6xtCjj7luzK
	ohN5VkGqF4RYTQrSpCCHRqpPhyHGM6U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793744451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JcRKYYhCDyV4n2ewkF4zDB+VLlR9fSLMZCr8vYcg00=;
	b=RyWxHzl9qutWU83H5nFddAOM/Nh/WIzr75BCcgu+3GAj4JjpnIWVKkS35WPKXc16Lx6twr
	BdrpqlGUplzyq6fSzEKHyFmKu8U4+t1Cw7PNRCwMgAxMT12cSGpwUi6/FEvWlFsvnna33L
	xTfkIl5g/cI9vq/bIK2T0A52hmrtVFo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bhk50nlb;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=oRY6ZJSe9wEUPbxPKDQuBBH9NjUT7AFk9vpxsLa6GKs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793744448; v=1; x=1794349248;
 b=bhk50nlbY6zDyd9K6RygscJ3Ufc348IRuhcGHJJNZoTcpqvKRyJlXXg2ufEc2K9DaZu2vmd7
 MMmuvtNkSyywQmxQ61qKK64X+6VSmsBXqbo3yq5zrKJ9vc9sDRPTI+bxH8+GgLm7Go9/J5PI4BT
 9f8WvwyusZiW7t+U2iCGT+VE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id aaf02a928ca210b4;
	Tue, 03 Nov 2026 22:20:47 +0000
X-Mizu-Trace-ID: aaf02a928ca210b4
X-Migadu-Flow: FLOW_OUT
Message-ID: <a16f1f8e-d3b6-4145-890b-51ce3c0a7f03@linux.dev>
Date: Tue, 3 Nov 2026 22:20:43 +0000
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/4] mm/huge_memory: add a per-order counter for
 underused splits
To: Joanne Koong <joannelkoong@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
Cc: baohua@kernel.org, hannes@cmpxchg.org, kas@kernel.org, alex@ghiti.fr,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-4-joannelkoong@gmail.com>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20261103212004.1356327-4-joannelkoong@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: jjnwugbz9skhscb9f4soaudcrryiy1be
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 5DC66A0003
X-HE-Tag: 1793744449-766916
X-HE-Meta: U2FsdGVkX181Lc7xqRDrGVsa99SLgoJuFxe59FSAGEbTmLCmDyhSP4oYR9XUkjOhWoWJuqnPvqCmq78EXY0u83IXo3i2qosPEG53PUzQCHYplgXjeVJWjfWVeQW5ZfJblqFzjdGHF6Bu1J2tYsGrwa1BuAWsdhXVCRdgKam85NubY02qtVA1+oPLMLE7zVe2ShvMtPBKteDkdrHbIZIy4Iji3GvG49lHxrlUWPXyEYRr8i9tLWZkEdd/Ei2j26BRJUaiT1FLAvO+6vUM3aMrxaTu2kS+sHg2AIjJb8sfRDgV8+YapMXLYAYK2Idl2aVdjMyks144b8xE55YC8raQrGLM7rNE8AciI1X5hHPktyMArpn15pHAEJMRe7mYQc8ZOLr3rmmox6Pfcv6y/1taIDbOUK2Gn054gPBwhiVCClt7pt9zEWxztkuyiEIPyVrxkMPbbMZJsOrJFlR0sYTLar9bEsDjqXoSakFf9V/7lveCqNkLrRLLwL94UrNfNhw6hXumixKmEyaX2wQyUjFap9WMyRMPdQGIK3x15aPCZAOjB+CRf3rX8v7QrMqN8iFvbAaSyo8C2vbRXHcPbmdxQtU+s8oXVQvkNst+LzKDwxsI0LJ+DyxG2l2/SwJNFensTiaU69IXvxr7TIcxO+EIkvKrdG9TKj6jfF66TuC8t6Q9upaZv1VJZNjUFCjL0m5K5fLMBs9VOBBQhlMnGRsJW6GghTO0HQIye8/kMYyRwS3m2ikbobOhYHgL1wfsu93nOtJs/vNBznGEYn4QPoynwN7wTqwNOpeGlistT3+9SqqsZ29X20LtTwZW5MwNoM8ubCjavdB0RQ0G06fvnQIdeEZovqylNJZuySwZC/itxa/Sr8W2t7OZ3axOuK4waRvCt2/dEsBuK9Sav/47XVkKsUkO/Szn1hjcxJEJevzHuuXEbUDkgDVIeLWngrF58HSaH+KkSfB6EyarZ5qjZAx
 yugYXk7B
 OrfURCzOfcTVzUOeqzHmJrNH9cBkxEYi8+U10Be/7nMZuWTL/QzGDmAvAdsCPFWeXKC+ENOJ6C7HgFAXGtrsLVZzFrhtIgKkpoHR6NHwKCExbSqUfYdUOh9vTQHtsPz6cvqpIH74VJ3dIDd+D+V94hUMIThK1YiepltG4GIhVwBy57+zrFocf1OiLqEgIgmBikvqXQBYahLgTu0Y1YReEtYFbwkLih8haZsSv+Zw10hzPKCtrTu2vpAEOId30OGkNGa4Uo/edB8lk9Ujiai4vPcLtg215mzmLgs0525XUUynKD4TdxievOUKp29Uebqi9h/2TkizVZVKY04Xnm/REfB98fJ3adlZS2S4gh8zMcCn7WGXxU7w2VnLybS3Kw5r1OOwvV1s8RtrU0DXtZNe5xnJOSSdEOuHDXfKMXhsrm1yfVy6PZrIs6X7sb8geQyWAiEucsjqIIY1UBvKn5sSkQWeGaezdB/XsKalvgqvsw0dM+rEVfE78+jmh0VrM4Wb7E7HN1efblDejR+c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 03/11/2026 21:20, Joanne Koong wrote:
> thp_underused_split_page counts every folio that the deferred split
> shrinker splits for being underused. Today that is only ever a
> PMD-sized folio, but a later patch queues anonymous mTHP folios for
> underused splitting too, at which point this counter would start
> counting mTHP splits as well.
> 
> thp_underused_split_page could then end up larger than thp_split_page,
> and there would be no per-order count of underused splits. That doesn't
> match how the other THP split stats work. In /proc/vmstat,
> thp_split_page and thp_deferred_split_page only count PMD-sized folios.
> Splits of every size, PMD included, are counted per order in the split
> and split_deferred stats under hugepages-<size>/stats/.
> 
> Do the same for underused splits. Only count PMD-sized folios in
> thp_underused_split_page, and add a per-order split_underused stat that
> counts underused splits of every size. The folio's order has to be read
> before splitting it, since the folio is no longer large once the split
> succeeds.
> 
> There is no functional change to thp_underused_split_page yet, as only
> PMD-sized folios are split for being underused today.
> 
> Suggested-by: Kiryl Shutsemau <kas@kernel.org>
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> ---
>  Documentation/admin-guide/mm/transhuge.rst |  6 ++++++
>  include/linux/huge_mm.h                    |  1 +
>  mm/huge_memory.c                           | 10 ++++++++--
>  3 files changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/transhuge.rst b/Documentation/admin-guide/mm/transhuge.rst
> index b187d618452f..6f2d92a2a556 100644
> --- a/Documentation/admin-guide/mm/transhuge.rst
> +++ b/Documentation/admin-guide/mm/transhuge.rst
> @@ -719,6 +719,12 @@ split_deferred
>          it would free up some memory. Pages on split queue are going to
>          be split under memory pressure, if splitting is possible.
>  

In this same commit, would you mind also doing s/THP/PMD mapped THP/ in
thp_underused_split_page section in /proc/vmstat section?

Apart from that, LGTM

Acked-by: Usama Arif <usama.arif@linux.dev>

> +split_underused
> +	is incremented when a huge page on the split queue was split
> +	because it was underused. This happens when the number of zero-filled
> +	pages in the huge page is above a certain threshold scaled from
> +	/sys/kernel/mm/transparent_hugepage/khugepaged/max_ptes_none.
> +
>  nr_anon
>         the number of anonymous THP we have in the whole system. These THPs
>         might be currently entirely mapped or have partially unmapped/unused
> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> index c745f7ad2298..421217aca4ed 100644
> --- a/include/linux/huge_mm.h
> +++ b/include/linux/huge_mm.h
> @@ -142,6 +142,7 @@ enum mthp_stat_item {
>  	MTHP_STAT_SPLIT,
>  	MTHP_STAT_SPLIT_FAILED,
>  	MTHP_STAT_SPLIT_DEFERRED,
> +	MTHP_STAT_SPLIT_UNDERUSED,
>  	MTHP_STAT_NR_ANON,
>  	MTHP_STAT_NR_ANON_PARTIALLY_MAPPED,
>  	MTHP_STAT_COLLAPSE_EXCEED_SWAP,
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 903bbe972011..8f90fb609e57 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -822,6 +822,7 @@ DEFINE_MTHP_STAT_ATTR(shmem_fallback_charge, MTHP_STAT_SHMEM_FALLBACK_CHARGE);
>  DEFINE_MTHP_STAT_ATTR(split, MTHP_STAT_SPLIT);
>  DEFINE_MTHP_STAT_ATTR(split_failed, MTHP_STAT_SPLIT_FAILED);
>  DEFINE_MTHP_STAT_ATTR(split_deferred, MTHP_STAT_SPLIT_DEFERRED);
> +DEFINE_MTHP_STAT_ATTR(split_underused, MTHP_STAT_SPLIT_UNDERUSED);
>  DEFINE_MTHP_STAT_ATTR(nr_anon, MTHP_STAT_NR_ANON);
>  DEFINE_MTHP_STAT_ATTR(nr_anon_partially_mapped, MTHP_STAT_NR_ANON_PARTIALLY_MAPPED);
>  DEFINE_MTHP_STAT_ATTR(collapse_exceed_swap_pte, MTHP_STAT_COLLAPSE_EXCEED_SWAP);
> @@ -842,6 +843,7 @@ static struct attribute *anon_stats_attrs[] = {
>  	&swpout_fallback_attr.attr,
>  #endif
>  	&split_deferred_attr.attr,
> +	&split_underused_attr.attr,
>  	&nr_anon_attr.attr,
>  	&nr_anon_partially_mapped_attr.attr,
>  	&collapse_exceed_swap_pte_attr.attr,
> @@ -4703,6 +4705,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  					    deferred_split_isolate, &dispose);
>  
>  	list_for_each_entry_safe(folio, next, &dispose, _deferred_list) {
> +		const unsigned int order = folio_order(folio);
>  		bool did_split = false;
>  		bool underused = false;
>  
> @@ -4724,8 +4727,11 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  			goto requeue;
>  		if (!split_folio(folio)) {
>  			did_split = true;
> -			if (underused)
> -				count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
> +			if (underused) {
> +				if (is_pmd_order(order))
> +					count_vm_event(THP_UNDERUSED_SPLIT_PAGE);
> +				count_mthp_stat(order, MTHP_STAT_SPLIT_UNDERUSED);
> +			}
>  			split++;
>  		}
>  		folio_unlock(folio);


