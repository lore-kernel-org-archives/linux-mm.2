Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17212D2502E
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 13:42:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62E646B0088; Sun, 11 Jan 2026 08:42:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B1DA6B0089; Sun, 11 Jan 2026 08:42:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE206B008A; Sun, 11 Jan 2026 08:42:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3CA6B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 08:42:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C655B13BAEA
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:42:18 +0000 (UTC)
X-FDA: 84319797156.20.3407CF1
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id B621F20003
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 13:42:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jxPsPKHi;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768138937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AcaRG6W2GHf2TJkOHLOa6E9Px941H/52oDWSAloAQHQ=;
	b=pEBASW7cdx6xBmn2yyHSnOwxvmN81EXpMILM0eiLAukX8CBoWbMtV63wlT2rezGh3PEdH8
	Wqk5pvI8E+iHeHr1VOf1J/eq0CyN7bcgT7QcCbYr3sCCOd2HDGeouZhEk0AaxFaA9fr3uP
	5gmEJsJO2z3c14WexGhBRjtO+EqgtCk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=jxPsPKHi;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768138937; a=rsa-sha256;
	cv=none;
	b=UC8+mgRPkAbWQ8C7YSEiLWTKgJNCZOWOCmP1Kh8Zz7Tea2T7plEHKnr2Ug83AzwFIfXCpy
	nVMYbrOeKiFkSZzXyyAGn82Xd781QVIvAYD9B1HjT1WO9+gO8eemp/leOie4HOE5uhkqcl
	QuE8QII+UMMP0AevfkcaBEiWmgemsMU=
Message-ID: <78a2ab5b-5ece-4d82-a229-594fb8672108@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768138934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AcaRG6W2GHf2TJkOHLOa6E9Px941H/52oDWSAloAQHQ=;
	b=jxPsPKHivZ9cUz8HAyuKq24MJq+Bq95285K4NFNc5HaVLwyGwesCTyUZ6RtBMrVTjAOnOI
	zS20FEQMVyGJtTKK/A/V+2eq+DwbQzemBDt+iyjUCNPf5tH8eNrSY7owefBeHlojoVmRrD
	ut6TdBDAyUh9BAWiopZG1jVSWGBVuwI=
Date: Sun, 11 Jan 2026 21:41:59 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new v4 4/6] mm: add folio_is_lazyfree helper
Content-Language: en-US
To: Vernon Yang <vernon2gm@gmail.com>
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, akpm@linux-foundation.org,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>,
 david@kernel.org
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-5-yanglincheng@kylinos.cn>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260111121909.8410-5-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: iuhd6tc9pa8o98paox8dwfxws5cnjent
X-Rspamd-Queue-Id: B621F20003
X-Rspamd-Server: rspam04
X-HE-Tag: 1768138936-944073
X-HE-Meta: U2FsdGVkX18xs3E7klh7d8jJmYaXM6d76PMbUr3jOkyiD/E5alfNJ43dp69p4/vy6TNk/gIZJhF/2Rk0b4XMx7cWoHXslk4Og8y/as0z5h5dEitVHCrfzUCqWM5SxxLBfbHqRSCm+r43lZI6mjX3bvh6YdbdQpHG/eJU4bk9XZ1njBx0w66SGyjBytaY6lPbYxF/81JCJAbGWKFgggTBx015CcmsP679BWgxrTEUrPs0v69TyFZu0eEoouz+pRqRncWDbxAHb0uAnvQm+RtsMEIBaoz1PpBJTyYxz4TVDkPULA6Zb/Xpg90oP957RLq+H4byoCI+EHzdhdKUBrp6UBNx6at3dMmwq3Sm1TX8E5JQbcwAbP6ZNd4SgRYvFuFhWPiINPasd36p3nJbHUHhq4RfJ3GCIWwamJdA0PAwDaoyJOkGJTDt39+C5pokTRtG7Ctcyn4J2CT5BfHUYHhigEUrgHkernmnvpEVHJV/M4BnfEQZN81ODz3VLXA6ToI7IVqKjI1pmKq8fuyFBXEWV6lI62jt9HreMYJmY/UQg6inf4fiUQ3xQRdirTqJZCjvZRkbovw2h7Z0DTlIBN8qrI2rWm9J5/O4tmw/n9HgDtQSfMRiw9lClBhRCZYbj2kM0fH+xPch//EzY8nNiouJca4Mct1HklR72d2N02Ry36/5ewMPUbcJMvUecNQmnnpEd7tNaS7PUAiuJd/vnRE9HT9sqSdsSwoNQAf+BmmY6fwR5lJZ1CZQum8TInmNApM9F513i0NJZLF+MntX1Ikz+NpZ9FlLmpI/TBXZgs+RrYW2yZFkRYa5yOyrqf5/19RgGNTipLE5kc3XaoDYJr02Gyh4mrMSJndISzrQJWoHaGe4wxjlePmU9Zhrd9Wv/mFV493I5l0kKYORBapbueDjifiLQeRGbf1m/FVpA6Q99oo6P/srwGjkDYaaUTg5IdwUwEmnWRiKXp2UKEKdvq/
 TzDUhlXT
 HX/t7vtYiZZaiVveYWfuWJLa4M4x0q8PzHxfk8P0glIzIXglQsOlxRsycCIBWJMjhtl/idG1bNVE3qnV3V+9y7tUKZXF7yyEpytLdVXElvu7UhnVh6Abdrp32U+A0b2Xw/LzitS9H017goba/dEmytEgEaVWwp2S5ZKyDzfWMATfZDRH7A3zOnil41SFII5sFR3cd8nypN0DDQMVZgGnfMBtPzhFbLqf8JQFI9BaaksaZvPCU8dEQGjhJfwsNTZbuaHXSb9/6ugodTBI2Ssj2PfbVhAxYdlSRexE8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/1/11 20:19, Vernon Yang wrote:
> Add folio_is_lazyfree() function to identify lazy-free folios to improve
> code readability.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   include/linux/mm_inline.h | 5 +++++
>   mm/rmap.c                 | 2 +-
>   mm/vmscan.c               | 5 ++---
>   3 files changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index fa2d6ba811b5..65a4ae52d915 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -35,6 +35,11 @@ static inline int page_is_file_lru(struct page *page)
>   	return folio_is_file_lru(page_folio(page));
>   }
>   
> +static inline int folio_is_lazyfree(const struct folio *folio)
> +{

It's 2026, could we use bool instead of int?

Yeah, I see folio_is_file_lru() uses int but that's legacy ...

> +	return folio_test_anon(folio) && !folio_test_swapbacked(folio);
> +}
> +
>   static __always_inline void __update_lru_size(struct lruvec *lruvec,
>   				enum lru_list lru, enum zone_type zid,
>   				long nr_pages)
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 336b27e00238..fd335b171ea7 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2042,7 +2042,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>   		}
>   
>   		if (!pvmw.pte) {
> -			if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
> +			if (folio_is_lazyfree(folio)) {
>   				if (unmap_huge_pmd_locked(vma, pvmw.address, pvmw.pmd, folio))
>   					goto walk_done;
>   				/*
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 81828fa625ed..ad3516ff1381 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -964,8 +964,7 @@ static void folio_check_dirty_writeback(struct folio *folio,
>   	 * They could be mistakenly treated as file lru. So further anon
>   	 * test is needed.
>   	 */
> -	if (!folio_is_file_lru(folio) ||
> -	    (folio_test_anon(folio) && !folio_test_swapbacked(folio))) {
> +	if (!folio_is_file_lru(folio) || folio_is_lazyfree(folio)) {
>   		*dirty = false;
>   		*writeback = false;
>   		return;
> @@ -1506,7 +1505,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
>   			}
>   		}
>   
> -		if (folio_test_anon(folio) && !folio_test_swapbacked(folio)) {
> +		if (folio_is_lazyfree(folio)) {
>   			/* follow __remove_mapping for reference */
>   			if (!folio_ref_freeze(folio, 1))
>   				goto keep_locked;

Otherwise, LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

