Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E277AC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36266B008A; Thu,  6 Aug 2026 09:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0E156B0092; Thu,  6 Aug 2026 09:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4ADA6B0093; Thu,  6 Aug 2026 09:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A1ACB6B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:38:22 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2168212067B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:38:22 +0000 (UTC)
X-FDA: 85070948844.01.B73655A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 92CCAA000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:38:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NZzxC51Q;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786023500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NxZMgXsKRknhZFPwvdBDKIyW4s144q58cHNdT366tnc=;
	b=zrpmy2WVYGwjDOwG+XPMzatewHqwp2KLABGF2y1PoNX+Ehs4BWJZztQ6eoW/XEHhufPD+E
	3Cusst8yLLpQpYLSc5W6XOGOYpOzxfOAV41ylpSUduXRMV3Xl5Y64rSosCkjOGWSax+c4D
	UX2N7Ov92t+vMX49dep/+kXZQ7tanlY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NZzxC51Q;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786023500;
	b=xc3UgSO0f8crOhq5U4satKKpFkd1QD79frnhCoJJwVYBPhsTlTztP811xEdGObKzJkbsxA
	OrtSNSfTHNu8TyC8VhrVxLLw/de/CYU8e4WFQLlKFM/JHmwORaVCZgSYk/XgwUf4/gIpev
	xAy6yFnO04h2Np0A6KxJbRNRNMgXyeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2C69760A70;
	Thu,  6 Aug 2026 13:38:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EDC1F00A3D;
	Thu,  6 Aug 2026 13:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786023499;
	bh=NxZMgXsKRknhZFPwvdBDKIyW4s144q58cHNdT366tnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NZzxC51QwJ4HjDg4ylYDO1RhiuPNVDAiyi/Qp2vbT/LeJC+CS9MU+FtrmQXgLrbmG
	 3B/cGawdM5aM8ETI5tETxhCV4iPEZDEQRE1VMt2Ho/gqmcdKLZDLMATzHnhO9fyGaT
	 V6UPD0wiNtHQi/hwuS4GFHzMG9GXgOqEtH6kaCWqrtLLo2FHORfbtyc/7YxZlFMRSF
	 fQRe0aHDpeT9NNjnrhriqVYxXAcYCS+fcYucDJ9DkNTEg5LFO+jB3DnyF0ybRd8GT6
	 YmdSBSRr6KeLKkX4lavQ32yZ4jTRpt34WHUHZhqV0WANllyHOymgKXsBypISDLRge8
	 ByyqAT58/NUWQ==
Date: Thu, 6 Aug 2026 14:37:59 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, damon@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, sj@kernel.org, akpm@linux-foundation.org, 
	david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, vbabka@kernel.org, 
	jannh@google.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com
Subject: Re: [PATCH 1/4] mm/damon: defensively skip zone device folios in
 damon_get_folio()
Message-ID: <anSOKjTerc97fCGx@lucifer>
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-2-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728194714.3713735-2-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 92CCAA000A
X-Stat-Signature: mb71n7wr6ais8oiywrz4znq5ny4mcirf
X-HE-Tag: 1786023500-275916
X-HE-Meta: U2FsdGVkX19fuiSWiRk2+Bq9D4Nk4Y0NsOIDAibzDFInsiPH5oWWW6vD5SKkS5nrYGLtJd2jmKErhU5FfgPS1y9u8OW3JQ7M7tUcHXk7YSND2ZAAqMyNJ4QpIjtlAMXISU2PQHa1GIu7WK1T5P8DZougbM+gzY5zbNCEGH0yhZdtKdpPfzy1m4U0tIA5oPnKY2SOfILGBckbZ2XnBRhHnlImSBGaeYus/jU30l93kcK4P4MVH8knn0lKIdFfXraWqM21M1G7Rj71F4DSgJgOZPBjLROQiNGc8yEuIP6Wu0GkkENeNJHNt/xgHMjH3RvdOl02z8qDaAVh8+S1dF4ixeqAW6iVOau+M4aq4kEij+ApWLS3zlIJBQKYQgKD6LDuQcllcPm4WjBi9gk95bKRQ/HwWBP28vgTcBSXwD+VDMq2oDPTySqpSZ3bFXTFsdhgtG17IRZ0UFGAY1vym0MjSC9LZwLch7nsZaHXuSDHTK6TbsISSg6WDDRf+b6x1XFGaoLCJOjuktLvrq/sCuflEyyaE6/RKj/AR388ejfxgZIi6SI2F6dfjUVbPceOdWnm/FsnJJJZA/oOLrTVhYidxYK9GMsh5m7QJwqqcZClt2tMKnk1UpkV49Xi0/k8RfyGfq8C7330Q0R68iPyKbaJV+4lw6M1Q5cRvzbF5dwkmHHLgMdn9J/GFoyet6dJXuGEbkAeAjGkh2OytvrdlPe6YLsm5hlNLoLBRDqW/EVvEGGC+Dv9uwVJrNHTvyNCnMpQZbLOO/cDZZqC7nSVqce3A6DzS5Exycl8wahT9r3lGFf/krNwutkJoSElSX92sfiHTNCTZ1pUej0vFg4/Eiubwi6Dz9mnzq4e7lmM89GQcj6w50M5ibYCDlOuBzUm3BLS/St23ZcQ3vu2Otb3Wic0ufFuntPfwWr2+83qpaPE0S+/o6Tdiy+EHb/ZB19gI4pXL+wYUf13d/bfy+4gpKz
 Ifn3GeO8
 5Th2dQzEF8D0Hx3Br+YXz1ufrG/UN4WPfZPFm0uAin5QrmF+rfRJodQwYKoQs3ou0XQ+gKmxt1jZkCEJLVbu3jAHwP5LICF3zj4Uyuq4PAAkJNK96/gY4iR9qm/kwDww1YXQieLj1mCV4kbyEFuszmfC/332Ic/J8sQSk97u7BWvyy7RouFlA/TmZVWiGt5URpGKvrtuQjj8i+XxC/zrbhdJTqVGkUnsdFriYPOItPrRW+3amaha5RBMvz59SSWXGQmxTweSnH/RmBNPzzZ6F4tNhpkYe0XxSxgw1PBIaZ3Pr1CFwYlnMoZKE98euELwf25LGi2fYCUrKgkicnmglpOYBaH9mHWhvttfjRUoG0UDgUm2I4KXPhyRMJuWcsIivd+VNrSEM/KkZhX/xu/3nI/661uIozCrsqBac3UomaMdloEZgnga+JO5zN180sK281rCgo4PaWrwmxlw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 03:47:11PM -0400, Gregory Price wrote:
> All DAMON physical- and virtual-address operations obtain their folios
> through damon_get_folio(). That helper already excludes ZONE_DEVICE
> memory implicitly via pfn_to_online_page() and folio_test_lru(), but
> this is inconsistent with other callers in mm/ which test explicitly.
>
> Add an explicit folio_is_zone_device() rejection in damon_get_folio()
> so the guarantee lives in one place and covers every caller uniformly,
> consistent with other mm walkers that reject zone device folios.
>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

Thanks, nice to make it explicit!

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/damon/ops-common.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
> index d7d7f100389b..d8bca7355b4f 100644
> --- a/mm/damon/ops-common.c
> +++ b/mm/damon/ops-common.c
> @@ -32,7 +32,8 @@ struct folio *damon_get_folio(unsigned long pfn)
>  	folio = page_folio(page);
>  	if (!folio_try_get(folio))
>  		return NULL;
> -	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio)) {
> +	if (unlikely(page_folio(page) != folio) || !folio_test_lru(folio) ||
> +	    folio_is_zone_device(folio)) {
>  		folio_put(folio);
>  		folio = NULL;
>  	}
> --
> 2.55.0
>

--
Cheers, Lorenzo

