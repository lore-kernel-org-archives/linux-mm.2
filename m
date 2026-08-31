Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC326C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:01:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4B886B009E; Mon, 31 Aug 2026 05:01:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24526B009F; Mon, 31 Aug 2026 05:01:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61766B00A0; Mon, 31 Aug 2026 05:01:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 859246B009E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:01:35 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EFF4B1A03F2
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:01:34 +0000 (UTC)
X-FDA: 85160971308.06.170B848
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8204B140013
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:01:32 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atsmSRP0;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166892;
	b=0r5vI/nDwLpqeslu26SQihMzJEC1woe2ap32gkxKBwB0X01Ewinmut4nH8eHgZmEZk7Spn
	3yH2Eje4wtNIRHeybwJibd70yS+P5G2IMFz09dDf7o/53b8Dkjjn6DwSJ8mFXUlo+70acq
	T4H9EvkbtAl1scdjzMMHBIZHZNorsRw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=atsmSRP0;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IFUViO5z4Y+XAB5uPhbTOwoEc6WJIUEHXXu3zrTrA4M=;
	b=PFLYnOz5LMraJtHfsHEGsf9fzJo+FFJ+x1eXZIL0u8d9HoxiBb0Br0Xm+1fTzaB+C6i4CL
	bsS21ATuWmUofI0xM0B+BXh35ylIyYFVxxIxSso4KGSxafN4A3K1nKXSO6zPIO6EkcWLDr
	d/eVw/LAWBX10UKsev1ZW54Yn6rWw18=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 29E7660120;
	Mon, 31 Aug 2026 09:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112871F000E9;
	Mon, 31 Aug 2026 09:01:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788166891;
	bh=IFUViO5z4Y+XAB5uPhbTOwoEc6WJIUEHXXu3zrTrA4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=atsmSRP0yTem4BuDZMH4FBRRe/Fsouc7fL5l8UIs5ZEdOAVY8OX6/MCoUiZ7Q6s6d
	 Q+cm5WB7bQ8BQyBa+QMyfw0iRTW+SQZ9cExjiQxMu0n4uCoPDSYLxuUaYJ7ONhma2i
	 PJFRtzXGzQEYNuHAlnSF50cdG6Vz62latGOGtA7OElUGUThBUq9jOhVrH05eI/TCqx
	 hMaUcgVbT7y4zoBmmejGF2ILrpS941ENdEqRS+RVqZgVqguSIL/YuY6tnU3Mh69RIO
	 EaQvXwYfqa8IiiGkygQxDD+lT9vlltnFEQY05yKUAIA7mCdE1FvGbZJqTtZ5nzh7Zq
	 V4lyv/5RfUhlg==
Date: Mon, 31 Aug 2026 10:01:25 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [Patch v2] mm: adjust out-dated document of __GFP_NOFAIL
Message-ID: <apVC3tNDMx0AGsQj@gremlin>
References: <20260829025847.26779-1-richard.weiyang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829025847.26779-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Stat-Signature: t6h1o4jib3d1oupz7djr5xh4xc5dg5dy
X-Rspamd-Queue-Id: 8204B140013
X-Rspamd-Server: rspam06
X-HE-Tag: 1788166892-410127
X-HE-Meta: U2FsdGVkX19O47KAWFLLTGRoSBgMe2Jspng72Q5VM67DgBABZltGtL62JGltYplzeR5fYRVHeHUpcDbbzwhE7YJ/uzDoNJtdz7JLnNqBqYbj+luKAiVlpVppFBMBlz5GpzyfHKv661UcCjv7levx3pUP7Rajkn12kfIo/TsPo70wzIs7a4yUxA5caw655H/wKUrypb+bD3oVjc3V3fjJhzgnLOC0gmWJaaJIeO2rr5/MDPBY3ufD13pAo1UXtK76v91JV0tjO+yfembczj6nUe/qgHdETv+wf0seT3n2GIMfDkr7+BoTDqOC9Tci/VmjBmLGmOl6JqqoiLwIrmNECOvNoRfec0my576AhpiLxVZh/KD3kvc3G06A1GEt5BI1hUGG7bHpCUVU3fPKm0mIx8i9mEy/d/crEscqU3+Rg9BrpWwFCLroCWtGgjC4HPWml1AhjmlwPqI9rpgta+/K/qD65nfhoBX0gSybP5Y4GXaE3zDvmBaOurIVsBje7gk8ywZCCGvR/0fMlLrDlNgnn1os8vs8wbm9fx0NcNGdzUO/TiXBdjUSswz2os06exSPAS2jCNeQaUeNeLlhU+Ox664PKoc62cAMV7uVAJ6nQccL7lwS+QiB/zn7wDxqiyTkwRNRRY1gPf6EQ9TP6rg3+h7l3EG/bPWIBIOEAygXXCFcAnAthanV1X+TzXdhEGXs40sF1dYx/KWssLlJ/WWfnP0avePDZgSSHRGlCUwtriIcpjIETluNBNk9gyC3G9lCS0dRaNh5zhNYO3iFhvZutMb85d9HGkcvE5ylgHmv6WBi0VRhChmEitPuB39fIUrihFErGnbUYz64YaXSabRtCBjqulOcwwrCvcr+l3MVB2DpOG5fMXBB6qBMu4lE9U/xlWwiyj5ZJYMFCP7NWD2Cj+vfFvc/Bj3qxj0+kvxkpTO2tjstdJZh6zakxfyrmizONfz7UX65KhtGlAeCUxU
 ilffWO+z
 Eo+isrZdQBPZcpcsJiUHHgad6VsvaPGC+D6fNZF+gY3AokPGWg1hOeQGinAVSal6siC25Cx2LjPpKFR3eOnbzKWnsUWIx8r4GYiJrIIICl1V8TL+idYLEpCTs6UGn/zxUIjx1KkA6NIX75x3JnSQtISbgirq9+Y2E0jCP3gZuaxG0yDhgeTccJ1O6ixUWkj46i3jFe1cZceLyA3o24a3rm2qvjAT5ZCivlBg/JC4iolZ8BoQhe96WqH9BjrO9Dq9X68PJHm/c4zIfVq9xUrZYD2UMUsxPMqCgfg23yCzUCufpA4DZb49C2upRL/RvovmFvyPSXOoKIWJHVTNDB7Gr5ouV2gqnFGsSwjUo8miJk2cSKDb41XjTqKnP4fiFoxoslxkpgMaVPlqi7lVhJ94mIZs5PkqIGYIeC95yChRYSZjH51g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 02:58:47AM +0000, Wei Yang wrote:
> Commit ee040cbd6e48 ("mm/page_alloc: don't warn about large allocations
> with __GFP_NOFAIL") remove a warning on allocating large folio with
> __GFP_NOFAIL, which was placed there by commit 903edea6c53f ("mm: warn
> about illegal __GFP_NOFAIL usage in a more appropriate location and
> manner").
>
> While in that commit, it also documented this behavior which is
> out-dated now.
>
> Adjust the document to align to current code, and adjust the comment
> while at it.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> ---
> v2:
>   * s/is adjusted/was placed there/ in change log
>   * instead of removing the document, say "is discouraged"
>
> v1: https://lore.kernel.org/all/20260827030548.16631-1-richard.weiyang@gmail.com/T/#u
> ---
>  include/linux/gfp_types.h | 2 +-
>  mm/page_alloc.c           | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 190191411009..bfd4c43ed777 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -244,7 +244,7 @@ enum {
>   * definitely preferable to use the flag rather than opencode endless
>   * loop around allocator.
>   * Allocating pages from the buddy with __GFP_NOFAIL and order > 1 is
> - * not supported. Please consider using kvmalloc() instead.
> + * discouraged. Please consider using kvmalloc() instead if possible.
>   */
>  #define __GFP_IO	((__force gfp_t)___GFP_IO)
>  #define __GFP_FS	((__force gfp_t)___GFP_FS)
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ab385bc252cc..146f7e0a9462 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4804,7 +4804,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>
>  	if (unlikely(nofail)) {
>  		/*
> -		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
> +		 * We don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
>  		 * otherwise, we may result in lockup.
>  		 */
>  		WARN_ON_ONCE(!can_direct_reclaim);
> --
> 2.34.1
>

--
Cheers, Lorenzo

