Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 937DCCD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:19:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AB136B0093; Fri, 22 May 2026 07:19:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 854316B0095; Fri, 22 May 2026 07:19:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742A46B0096; Fri, 22 May 2026 07:19:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 608646B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:19:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F26E840695
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:19:56 +0000 (UTC)
X-FDA: 84794811192.24.4F9D90B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4F36114000A
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:19:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQ+hluqM;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779448795; a=rsa-sha256;
	cv=none;
	b=lYOTZvtLz7p4bIjvGfxbtpSRLO/Jdc7DB+yMQM9ft4PK21WzpwADx+CROEDW5rESK5iVzW
	FJp8MFcxti6i2mA6KDXSPIWE/GWQnYjUHbFmH7uiVadKK/ho7tSSG6M8hG9z+1xujmL9qN
	aL73Wp9g99+mAgKrK7gUS48qbm6FMpE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CQ+hluqM;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779448795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=385qrBW1EQYKW/EHtsGF8/FRYRiGYCeEt5ozPxIr+kY=;
	b=wMBbEWIbMdLQa5ABKqrcC/cvdl86yS+JsP9gDIxVS1+0nSq0duhDOCXgc1t386ScF45Kfw
	HEqamhY55mE8lOI5e5CUHIyERA9zRZ6NSFFWGcsJQOjLb2RpMZyd+b9b6bBKku31Jsh91x
	2Z2Gbi2U9jvrdqsaMV3wzI+pGCFomJc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A56DD60136;
	Fri, 22 May 2026 11:19:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A871F000E9;
	Fri, 22 May 2026 11:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779448794;
	bh=385qrBW1EQYKW/EHtsGF8/FRYRiGYCeEt5ozPxIr+kY=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=CQ+hluqMHKtYZ+KzRNGbbt9yvin2AQWBs2RwtVfXudNxAnUt/UX24SELfoN5UG36q
	 LkviNnAbaA+BUqYvLUOtTf810RlocA6Co5JsUX273Xu8IryuEK/rgb266EmjZt/go6
	 ZGAql5yfiZERkdG4R3PloSu1uCHCsWIOq7Jr4sBzwK2QWw1O40oWwKtM1ZT0T02L2R
	 JifhNk8V3w4feaj+KcMtjB8DzfrsLdyXWp94A2v13x0Nlhly10Ur5+406cbvAMOBst
	 hvQQcEqaW84VLEUENZUZsGdH1wtCbjNU4TmpC5839qZh8q24MFzMNxTYJssPONld9i
	 7+XmP0jAf2v1Q==
Message-ID: <6ba62058-e5f8-4212-b1a8-56047b4977db@kernel.org>
Date: Fri, 22 May 2026 13:19:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/dmapool: remove redundant DMAPOOL_DEBUG macro
Content-Language: en-US
To: lirongqing <lirongqing@baidu.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>
References: <20260522105346.2215-1-lirongqing@baidu.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260522105346.2215-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4F36114000A
X-Rspamd-Server: rspam03
X-Stat-Signature: bkxm4853xhhobwaomm4ibihqnu55utst
X-HE-Tag: 1779448795-321322
X-HE-Meta: U2FsdGVkX18R3DNYsggSr5PZoIkbg9RwIUTcsmVlLmQEFjZVUcHCCNtxxvtujKsvHF/YpNHO5CGml7JVD3GqoWWuAimgDTceI8ShNNt02G18HT+cpx99Lclnhr0zf1QirFxLoD29YxjBRCWjPpCDBLDI2umQ4SmO5F9Loib+/GOuRnMN4Ae+SrHcPPhLlpjNJR7lUr+7HqmRon+UiyNlzWQNYAoK4G5DQ6yFWV6WvNgAOjPlZkPSny0YALe/0T7vILMSpbaaix9YiIgqE7kUQaZuBf1CwhF+IYNfCnCQdW11o6CKSdo4ZZOxFRnkznxvl2k4y3f03l/zVI7soAFnnMYxiA+OwA9mwWG0jfVM4VEinFm7C/CZv49UkcW7RqE22j4TWQuCQonmFfYqt4GsZQ8sxKKqTZtwPaTZmvIbyIDiehEEpBXv5Zp06A81iVc5jHx1ZhXMHOeFqIK1GBhyYrihQB8rIutpFivxMDKGFjboLU9+ePM0gXW5R9l/x9W88VXPExoYFZiICCWWD98j3+RWlepULXLcaXq1MrOMGoA1Ubg/RprNTC8qWaN1vW2RxsX4MRkPr/3Rm1jznZjEdY7+mnNm+cEfQv3ObIgKpnhWblkDVeNZcuvNjARxWit5KZ2mETUD9BfPn37/ASo56dV0JD+IPt61dxMqowSsmmBAh/jf+WjkLSydQtgy80zlYGp46vBBO87DP53B63090njJfhUtMnaYlcn54r/xfVieAdKTmHdC+ZheH7rl6wBLHcXyhQAvzFW87PLqzgRYeD84vkiB95M1fnGFnmI3ggLvdjWqyeiHWo7hwBO3yk6fN0XIIPiBNKTLDv5Nz3pMCh+fHW2lo5imFHXlvM5AFa5KyCNOzGEQWBkv3DLszb47o6c72QzX5QvlUO+rCfLD8NeJBVkFwvigyBPjN9Ics5EKorVVqbZEYQjnitLauU4ZFxRVe+G9641d03Cov9r
 6UITpvUs
 3TmA3R6znKzGitQ7PQ2RVy4r01OfXXogW35myY2oMQVWUkUtqPLOnvtFu3HzZNm6Aa2/Wmao4YHOWTfMjx+h168IC83bvmIb4/VCGa0Ke32KBex5+rCxN6tLMTeo51egjMsJxEQcoRDLXF+QTJZLPmh3lFrE98J3LUUeJoBofiLAVDL9itseIco7fQltukif52oEkbyh12arGWRkeQF1mURZ3mplLIFE+sLm/n+uKAmfaOX5IXVyNpSnJBQmqZU2htqbdYse8wdvDrjbS9+Av4aCdNhFFTtwoegwwfHEZDgJg8JjZ6rHoqXuPYZjQLoDqZ315hNQdLwr82Gtj1coOorWxC8UoZpIl841upbAF8hVPVlU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 12:53, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> The DMAPOOL_DEBUG macro is only defined when CONFIG_SLUB_DEBUG_ON is
> enabled, and it is used exclusively to guard the pool_check_block()
> function. Wrapping CONFIG_SLUB_DEBUG_ON in another local macro adds
> unnecessary indirection.
> 
> Simplify the code by removing DMAPOOL_DEBUG entirely and using the
> standard CONFIG_SLUB_DEBUG_ON config option directly.
> 
> Signed-off-by: Li RongQing <lirongqing@baidu.com>

I think a more useful change would be to remove the usage of
CONFIG_SLUB_DEBUG_ON completely and rather (re)use a boot option that uses a
static key. CONFIG_SLUB_DEBUG_ON is only useful for bots running
randconfigs, otherwise normally for debugging a specific problem one doesn't
want to rebuild a kernel with CONFIG_SLUB_DEBUG_ON, but just reboot with a
boot option slab_debug[=...] (for slab itself) or debug_pagealloc=on etc.

(same thing should be done for the usage in mm/mempool.c btw)

> ---
>  mm/dmapool.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/mm/dmapool.c b/mm/dmapool.c
> index 5d8af6e..af43f1a 100644
> --- a/mm/dmapool.c
> +++ b/mm/dmapool.c
> @@ -36,10 +36,6 @@
>  #include <linux/types.h>
>  #include <linux/wait.h>
>  
> -#ifdef CONFIG_SLUB_DEBUG_ON
> -#define DMAPOOL_DEBUG 1
> -#endif
> -
>  struct dma_block {
>  	struct dma_block *next_block;
>  	dma_addr_t dma;
> @@ -92,7 +88,7 @@ static ssize_t pools_show(struct device *dev, struct device_attribute *attr, cha
>  
>  static DEVICE_ATTR_RO(pools);
>  
> -#ifdef DMAPOOL_DEBUG
> +#ifdef CONFIG_SLUB_DEBUG_ON
>  static void pool_check_block(struct dma_pool *pool, struct dma_block *block,
>  			     gfp_t mem_flags)
>  {


