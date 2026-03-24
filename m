Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8798FE9A772
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 11:32:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C99E86B008A; Tue, 24 Mar 2026 07:32:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5176B0092; Tue, 24 Mar 2026 07:32:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFBF6B008A; Tue, 24 Mar 2026 07:32:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 84BD06B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 07:32:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 48DDEBF588
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:11 +0000 (UTC)
X-FDA: 84580742862.14.27A64FE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B9AB380018
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 11:32:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gdTQywvJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774351929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wv21UAvos+dcOJtiIARIvKkAUCHJG15RByGlUFVeZU4=;
	b=o6YwcmS2cpAHlyodCLDAOl2TV23GebLmOi0TpsRdXVcSF14uc3YGFFI0b0Hi1hx2NS49aw
	U2hrdteYQAo6uWlbcgztjtuYt5vMtDetlWetJ0AgFrXpQLoPNKQRcISxY4ZAMHApIc3Qfj
	UUQED/iYx8h7EkKeetMJcrNAOoGs9IY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774351929; a=rsa-sha256;
	cv=none;
	b=x4W60RxtEZEKL45AU73uDP8MuERRGmfDdibDKVWW+oF9+f4QLG07naDCu2B6IEBFjsQBXx
	usn/Khy3RjIewPXB/8JszhH2RcOmKsnA2Rl5AWjyeJnTY8wzEhM0LvVgd5YMTadKkjuJ6A
	04UAx5GZg16Mks5j9ORBhLuzm4lINug=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gdTQywvJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1B2FD60127;
	Tue, 24 Mar 2026 11:32:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAC1C19424;
	Tue, 24 Mar 2026 11:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774351928;
	bh=ghTkbaISTVGwDGdA3ofgsDMiPDJsD2fR76jePcCVtn8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gdTQywvJUHqTM8SHvK9LND9LZNAyWA3XHuGnsBBPewALH0XwY7l7m1Dh9G09BBe0r
	 YpNDsa8WvrZx2731jLLyM0YPm7c3Rrj0nfWHpklrA/9qNyKXuBJ0DxHYd3q+h0TDCn
	 9kUGznlu4df8ATmJmbY6daoyF4Uv4B11ykUU/+AYmPLJujKaI39a8/bDY55VMtelPy
	 KrNSfbXV9S2lFYLfy8zUYXvDWZ1fg/WG3OrV0dCIrvXt0u2sCIVHfk0gU+sn58IecF
	 oN8LuMs1R7bgOQ0pLd5IPS7h+QXmUuQ226FIBcEOqnaAwBGiE1NbLb3MivWMNLYXw+
	 I8pFl+C1rQUhg==
Date: Tue, 24 Mar 2026 11:32:06 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Dave Chinner <david@fromorbit.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/7] mm: list_lru: deduplicate unlock_list_lru()
Message-ID: <ce74a9a0-cbfe-46b4-bf86-a5c3796e815f@lucifer.local>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
 <20260318200352.1039011-3-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260318200352.1039011-3-hannes@cmpxchg.org>
X-Rspamd-Queue-Id: B9AB380018
X-Stat-Signature: 6o3uta6o6qoqd3c6pe9awnqrwsrswfwq
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774351929-540152
X-HE-Meta: U2FsdGVkX1/5EM6db5PfRVTAre6JdN5tXc7BqOdQssP6/USOPCg11BtuJwO5lVANnYu+wZeZ1XYNzapQUwLtn5LV9oERSkun+LViZms1cPZ9QwMMCZJGoWMkqAt8HmGEZratECYRXekJJVpQb+e/S0TbpNzEDDoN7dIaMBfF0KqrlthoGh3lRTuqKWWcJpkrxzKyGPRRs8EeKeIDZApZOipedTY1hyjzCdzP1rdS3g1DYDKuNBoDlmILNqKTuoR6YC2xJ+U3YIbHcqaqWP0T7AmJhGG4ivfRY5Ie488gedFQIZT4zoS96r5XiQDYdeUYGQXooO6GF2AyMQhQoygHW66HfdXwOGtgmdG6NfwNhc+T23b/YUWDt8kntUz+0ajIjRDpluKMR+nwnGbq9Llc0zbqYajrIQxiU5qsDd+HWKeYpqQNtZHqYS03+Qb1FeaZi6vvx4MoL23kBEkzVxzLqWnKIrKRf75t/xyWxNi/S+LHsnIF/1TqBOvvJeA007OuUBAstYzsqYHXiPHyV8eNpULz3C8K+0Ui4tbEra5jpbZyi4HqtH9ZlmAl4vnyRtqsDitafn0ARXSpIM9hTuKnZKQjrNY9EyheoQM/OVfykeT7auUrTBugKz/q4Ke5iUqVRHStzzJvaQpcbMPYuwmVYoQDjQmNsswaBVsk7dpX6ozsBuZA+IniOhMqdKEvEWLkxK+rZmhw87Zp0l+tjobm8KMMbyCdlENcCweun0pGuhH3UzE/a+o77hRKU244k7T7YaTjpgKvmnzdYX6tMrmMj3TAWo7LoH7cqDa0WkoPpk16wVkeGW8C8LB0JEzOI/V1W3/u91VlQ64aW7/s7Yui/96FleSvL+tu9E4ZzTyvLT15ylL1VkMzzHRxdzLfJ10xEq/nxpUAP2fXWG+PbP3xitd1egU1GR42Ikr9mqLv4QbDm9yyeoHB0m+9sZdG7HbgGDVwe9EzJRD0ErtPqfc
 9TGPo3eS
 /NMGKwuhfGKdAilYP2nBe3A44M8sd35xVLURHRRiUz3IDSpOS3shUR857VKjOc/2BRzDAfvudTuYGJFs5LfOAkeQmxWXK1+qraRW6AOLG1ugB9WcIcYrYmFGzEozYlKdezYvahLkuiXvq/G8cGKucU4kAnMG0dzomCD2znyDhwIx8QPqxHVkH8LK5Qc48+Prd060kD4D8eI+BSKSXRRUpj4t2/oeOUGfwWeMO76rPDCu6Ptvpcgw7ZhSH2CpytFeE19G6Io3gLn9uc6lG2IOmnOabyNamKnWyB7z2bGeEFS8l4OYYhOZ1za4KjccvnLsn1tGFvAur3Hp68XGwAIBuVLWtfOpyOG/DXYeZ/3Rm549jOKsWSa58kRmINfUCpCTni8Y6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 03:53:20PM -0400, Johannes Weiner wrote:
> The MEMCG and !MEMCG variants are the same. lock_list_lru() has the
> same pattern when bailing. Consolidate into a common implementation.
>
> Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Nice, LGTM so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  mm/list_lru.c | 29 +++++++++--------------------
>  1 file changed, 9 insertions(+), 20 deletions(-)
>
> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index d96fd50fc9af..e873bc26a7ef 100644
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
> 2.53.0
>

