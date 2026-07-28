Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CE6C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:08:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FB016B007B; Tue, 28 Jul 2026 11:08:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1DE6B0088; Tue, 28 Jul 2026 11:08:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E91D6B008C; Tue, 28 Jul 2026 11:08:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5F6CD6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:08:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id ECF7040395
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:08:40 +0000 (UTC)
X-FDA: 85038517200.29.A82D9CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 05C521C000B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:08:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CoFCWSgF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785251319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A01dsvmvPovSklIMIdap8aKveNfjd1QsKAFfuCGTiYs=;
	b=Yg02Fiul8h+UgUxDq/GirotgsuGPANzB28NFdL7ZLbyKz+Ji+c2vz0gwIMGZdBi6+uK3QI
	suDm8nmXxzyzmz2VGTo3PbQvUjBIXfnyawFvFUp19IEUI5pn7BcafPT4FrJfiKQkOtcZWR
	mzXhL8xo1epg7qDIT6GtxNT1PZbeM18=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CoFCWSgF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785251319;
	b=mdooM0p1PTv6/iNZcBxAAYqNNbiaaA7b7U7zKPUnQMfrt1t6faKO+LgiwMBtLa5MoBsIH/
	YNZY4oY3mAyP8DZ3R/ZmP1SiIxufruVjXPA34vuubxRmlCVFwM70ND1q6T3mnb7SUX2Kr4
	lL862TzTlJJfA/szFrCZaoPd2fuenr4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 89D2160A5E;
	Tue, 28 Jul 2026 15:08:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A12201F00A3A;
	Tue, 28 Jul 2026 15:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785251318;
	bh=A01dsvmvPovSklIMIdap8aKveNfjd1QsKAFfuCGTiYs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CoFCWSgF/UJWb2ACHZXA1oTMsIpWIaBDrMDL55x6JlrKzIWbknzBPMRRb6dx5QP83
	 DE4/Tr6A7wu/1JNFFrySHEeFC1BF5z01+VtDsZ6urwLclVyy+AamNDn/PWMv9/2Pga
	 eOJFHRO4F6NQy9W/pubFLGGzXzc8lyE6otP2Z9CRbePlxvWwXBhkS8RsRSrPI4haAY
	 7xSqpfIpdl4GuxjSUk/roknkFq7X8sx/9APKOQJ9lbLhFLY+kP2zIVe32n3mRtWx/9
	 pmNjMJo7YZPZcJBcXw1gnraH+e5GEUiwANnwg8i20KaDjoJb+Kt+XV3X07bU9Hu6mp
	 d/WESoZmJjvQQ==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id BE81DF40071;
	Tue, 28 Jul 2026 11:08:36 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Tue, 28 Jul 2026 11:08:36 -0400
X-ME-Sender: <xms:9MVoajoo4BBH3gOnmfRK0FFM92XU3sByOr9w1OG4jEc47WisOA6sSw>
    <xme:9MVoagw_McjUFEZ8T37px6rLf630437EJy_kRgIkKpxYZiagh_1Gho5FVgtE2_gRJ
    NE9-n5RTraNcFj21XyMovDV5f7ICSzTVwykfQuGof_G_q2cuwvRT-ki>
X-ME-Received: <xmr:9MVoatox7SaRaCgUCG4USRsLnP4Z7AmT3lg91hzRYzCjPydsK90XGjG5ixWcLA>
X-ME-Proxy-Cause: dmFkZTGnznuykIxwCjE96rgdIqIrtInVcRhsVSLqoLYVMWqLd1lwbp/cUtW0TdmzMkCMBq
    EMa41Jzs4xu2zV6VfMrl8K2JJIWS9V7FeK+xSsLO966TEJtLBAoFITIyeGIYnCn9YkL4lJ
    pbKQJ8J4qDpvqqcYDkqrt7+/G7tgjikyq+XhUX4Y1YkdPrTHtHFw0gtqXTIBDlTi6nZyr+
    yroaHoGMEoNAwoceceiIS/sDNcQVOx2TXONSHiN894/1IVjiGTYjhWWdtU/AX7KmCqaHsU
    loHlxxPat/68JghIk2kGOTx/0VE/ZyUwKyGNVGRABIH56t975hdWmaF1ZV595ak+GHhSsJ
    vI/CrxU7XiRRjktFA4Dk05g3FGqbW6BOBXYuUk0mRDxmFrr5c/LS+ig8Ehw/lXrASiOAZ3
    ULQvVKRO3VC082jCZR2dYCIdJkR1FBgwT1GQlPL45SXccuCHTEYlZ4WBYqanU5B+MagzUO
    FQUDukLWU1m7bq6kMG96Se2CBlKnbumUSZDukaFlNku9basMD1bDJG6+xL0vLMS5Br2WTV
    V2RvBwwZL9W2u0uQpFiG7KAGf2PlL5NsmQ4BmeB0f+srSBdUpf44aOhxyb+zOTCmJA9NXO
    xAKKMFcLB0HlcJlt7jqSXUK6t9KP9bUC+wzwpu4EmDfV6ungfFy/KBDd0FLQ
X-ME-Proxy: <xmx:9MVoareU4r3DoxnaDeBUFk1rv41cUUwdWW9liZg7hFvVxf_EKBkjjg>
    <xmx:9MVoahjqpnCIXYgQ92a7x95HvYhek4-T660RWgkB0uKIXkZrWmYIhg>
    <xmx:9MVoasIfDonbC770PmvAmmigdmgVMtpXjZDShVBgWHoRlGj5PzLjEQ>
    <xmx:9MVoanmDlVivCUPG3KCGvfFKeG-9WWTN-GRZ0a6ZlvA0Zvdbwee0lw>
    <xmx:9MVoagRG7P0c08ZPRUkGLfYjAtgEyt2h_x0owQry3GAhzv0Te36sanZb>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Jul 2026 11:08:35 -0400 (EDT)
Date: Tue, 28 Jul 2026 16:08:35 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Pankaj Raghav <p.raghav@samsung.com>, 
	Hannes Reinecke <hare@suse.de>, Hugh Dickins <hughd@google.com>, Yang Shi <shy828301@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hengbin Zhang <uqbarz@gmail.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes 1/2] mm/huge_memory: separate out
 CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic
Message-ID: <amjD1MtOiXBRDxVi@thinkstation>
References: <20260728-fix-refcounted-huge-zero-v1-0-3f261f5447b4@kernel.org>
 <20260728-fix-refcounted-huge-zero-v1-1-3f261f5447b4@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-fix-refcounted-huge-zero-v1-1-3f261f5447b4@kernel.org>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 05C521C000B
X-Rspam-User: 
X-Stat-Signature: tj6q55muongmgg5mhmrueq3979gxzt34
X-HE-Tag: 1785251318-840252
X-HE-Meta: U2FsdGVkX1+ECgWtDqOFM9jnJJO8GBYya4yT6bRx+DzrispeKCnkgUWi4Pn0svZkvrXyyuJ4yLndyRnMlw3Hp+/EZR8ZKjQsztYyETomi7FhSYLUS6JvK+qDMyFMHGMIZUQUBnhIIOLWO25de1lzxTBsHhS7ONSt2dbNhaM6KLy4mRHRfKHsbWLuRDJvT7ZF/Sxpb8Z+rVn4nJ5uMXny0T/hLMcbtna2hYyrXUCloW7eRnYkcYgy6MJEaXLyH7HayyTast58GsCjwYj8+rEBXcw4bq0fvRUI65+T6gZZcnCus9cyUQhccFEYjamQIC5GISw2i/NjuxruXVLLDi0P+cIWzvMi+d6DV1gC599bo8q1zbJghHrRzQsKRwGpKurk+jATtFgBfApiZLoEpve6OMIvibh6Ahf6So+Wh3noyQLCWL33RKK28to/1WHJ8fZ070g8BRd3NdeGb+OIsl/7cMR7dAPu3ar0UfS93VmjEeu0w7q/S1wTQmIK4oVmJImWOoAJOSp4csGoo66RlVLt4l6qtcYK0kLkDAKeTfM7Eb/IgXtDQkq6JcWH5435AkmIaTiSbTFWEMR4O1D9jcwa2W8/oA2pc822IgLU7S66dRFsDJ1XjdOS4rXsVWn4erx11fQifDNitjiW+ZQQRzfqTlWka1M1Jtj9Nez/487QBtCWi+GtqOIM0tDT39N4OJdYFFTUVOqdgKGyB0gAtdUZ/JQpUJBvLs55NpsUGjSuler5ZZ6UedPbPp0tTXaSCp6mukUbarnxnYMP+DPewjnPVH7Hg5Y7QoaTgXmOP3nZgNoHVAwty8y08IjOq/ZLYC0FLVfb2Pf2vWJL63B74OQGnMJ0GQzNCvG9jMEIMU2SjQ9JmLQqxAD7Z0GWOpMTiIYZAiWfCUEE9zNCSv6fxOgK7My2KjJ/1E9/aLQqBkB0A/zkxJxyQyRFC4JgF//jy/GFXdzzzRcA1QGV3VbD99v
 s0Tey/SZ
 /Jgt2i9c/zmUbGXRFgi9jKEv/Y71eUkK/dXkNvlAYjm3ja8PRE1muArXpP29Iss/75rx7u8wVtpxM4Gr/s2PSxPAiWyaN7ToB6EWjKQKrIelfoMXIzxW9WetjOwIYK6I+Z2ZIsgsSk2PxNzVDjgUboNBRTkCMvUw563hp8TCqmdQZiexmknsFQcSAVaHN3v4Idb05qvtkchlw9HBtnlj+SNLhl9Xq5u1r8+Lyfdb/TBCq1ZRbvAXmoW5gfuRFu7QMS536VKJuoUR7B05z+bl4+3YvwD/sANOwwJczKM0ufPg0Y7ij56XDQpd0bcaZgfov4vuQspyuHyBCpBVd/UmkPbbxfP7ezvULU8bE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 01:05:44PM +0100, Lorenzo Stoakes (ARM) wrote:
> Rather than mixing the refcounted and non-refcounted
> CONFIG_PERSISTENT_HUGE_ZERO_FOLIO logic, separate the two out cleanly
> so it is clear what happens when this configuration option is set and what
> happens when it is not.
> 
> Introduce HUGE_ZERO_UNSET_PFN to abstract the ~0UL assignment, only
> introduce the refcount and shrinker if !CONFIG_PERSISTENT_HUGE_ZERO_FOLIO,
> abstract initialisation and teardown, abstract the huge zero folio
> allocation from refcounting.
> 
> Also change a BUG_ON() to WARN_ON_ONCE() while we're at it.
> 
> Without this change, the subsequent fix for a subtle race is harder to
> understand thus this is a dependency of it.
> 
> Cc: stable@vger.kernel.org # 6.18.x: dependency of subsequent fix
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/huge_memory.c | 159 ++++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 94 insertions(+), 65 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 032702a4637b..0f60bc82e87a 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -77,9 +77,14 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>  					 struct shrink_control *sc);
>  static bool split_underused_thp = true;
>  
> -static atomic_t huge_zero_refcount;
> +#define HUGE_ZERO_UNSET_PFN (~0UL)
>  struct folio *huge_zero_folio __read_mostly;
> -unsigned long huge_zero_pfn __read_mostly = ~0UL;
> +unsigned long huge_zero_pfn __read_mostly = HUGE_ZERO_UNSET_PFN;
> +#ifndef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
> +static atomic_t huge_zero_refcount;
> +static struct shrinker *huge_zero_folio_shrinker;
> +#endif
> +
>  unsigned long huge_anon_orders_always __read_mostly;
>  unsigned long huge_anon_orders_madvise __read_mostly;
>  unsigned long huge_anon_orders_inherit __read_mostly;
> @@ -221,22 +226,58 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	return orders;
>  }
>  
> -static bool get_huge_zero_folio(void)
> +static struct folio *alloc_huge_zero_folio(void)
>  {
>  	struct folio *zero_folio;
> -retry:
> -	if (likely(atomic_inc_not_zero(&huge_zero_refcount)))
> -		return true;
>  
>  	zero_folio = folio_alloc((GFP_TRANSHUGE | __GFP_ZERO | __GFP_ZEROTAGS) &
>  				 ~__GFP_MOVABLE,
>  			HPAGE_PMD_ORDER);
>  	if (!zero_folio) {
>  		count_vm_event(THP_ZERO_PAGE_ALLOC_FAILED);
> -		return false;
> +		return NULL;
> +	}
> +	folio_clear_large_rmappable(zero_folio); /* Explicitly not rmappable. */
> +	return zero_folio;
> +}
> +
> +#ifdef CONFIG_PERSISTENT_HUGE_ZERO_FOLIO
> +static int __init huge_zero_init(void)
> +{
> +	huge_zero_folio = alloc_huge_zero_folio();
> +	if (!huge_zero_folio) {
> +		pr_warn("Allocating persistent huge zero folio failed\n");

I am not sure the warn is enough. mm_get_huge_zero_folio() will produce
NULL pointer now without any attempts to allocate again.

Have you considered moving huge_zero_folio to BSS for
CONFIG_PERSISTENT_HUGE_ZERO_FOLIO=y?

> @@ -308,7 +323,46 @@ static unsigned long shrink_huge_zero_folio_scan(struct shrinker *shrink,
>  	return 0;
>  }
>  
> -static struct shrinker *huge_zero_folio_shrinker;
> +static int __init huge_zero_init(void)
> +{
> +	huge_zero_folio_shrinker = shrinker_alloc(0, "thp-zero");
> +	if (!huge_zero_folio_shrinker) {
> +		shrinker_free(deferred_split_shrinker);
> +		list_lru_destroy(&deferred_split_lru);

Hm. What? Why does huge_zero_init() touches deferred_*?
That's caller business.

>  static void __init thp_shrinker_exit(void)
>  {
> -	shrinker_free(huge_zero_folio_shrinker);
>  	shrinker_free(deferred_split_shrinker);
>  	list_lru_destroy(&deferred_split_lru);
> +	huge_zero_shrinker_exit();

Any reason behind the reorder?

>  }

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

