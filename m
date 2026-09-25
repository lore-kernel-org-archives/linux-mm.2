Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D60C98321
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 14:19:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE1466B0088; Fri, 25 Sep 2026 10:19:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B925B6B008A; Fri, 25 Sep 2026 10:19:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A81066B008C; Fri, 25 Sep 2026 10:19:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88A896B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 10:19:41 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 880B580647
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:19:40 +0000 (UTC)
X-FDA: 85252492920.25.D9D1C7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id E2C92140004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 14:19:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GXewc01/";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790345979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O90HcrDUDgs2gPlyP4PnGmdYEEb1BqgRZEgL2Xb6ukw=;
	b=33Hqj7z54VA0N6C2bVJJ6wTJTz8taD1au7ehudDWsYfngrl8ZSE0s8najdHJDssAZnvQDT
	bPQqqdmsNRm4jogv6aOw+KHo69gqbXsigsFGzkf5HsoVCX7Ea7qhjs454nM4y4SsHSnJI6
	AktNqirYSaeefXpF7sGak6wogaMOnhw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GXewc01/";
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790345979;
	b=FApGEOtyuTBQL6AvGB/yyLzTfQdnCu82SbUPQym6hCvQ9r2l76QqbCtoywRpmDVoTZ6duX
	lfprFaY9hcd59nbIcFOZt6f+ymq9tUXkm8jxBA/jgSOXxVrs7+trIiOwrmHOVeJTpERf9d
	kNy1McZvsm4fa/rJREJNwZrvkKw6Vq4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 71EC442339;
	Fri, 25 Sep 2026 14:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7401F000FF;
	Fri, 25 Sep 2026 14:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790345977;
	bh=O90HcrDUDgs2gPlyP4PnGmdYEEb1BqgRZEgL2Xb6ukw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GXewc01/R8D6CuSugKRzRVSbYHz161gyghKdjbBLXgPoxnBYiwvlYMDy19RpgyO7z
	 RoAzuRyYQ1wUfenQJmIctyatSXZcfRy5yPXkHfRwbN+jNZkFNP/CXJyPMBv0PPf7wA
	 vB4GnsqGDG7W6YJJqHefdXeSqauBqsOF18fAxiPxFr4KmGyX6xqGN7XED4SE+qWjGm
	 09Cm5j0x/RqY/Gb9iU2wNz3k8E3P0NuRI2X8cyJSIGHBi6WON277di/UhPFcHYlrH7
	 ORuvIf6RIOXvnNbe1wqxNAHRMUBuWZJgB+cw5tuDSNk4IgY47Z91uDoVBFO+TD2xKU
	 zCpLfnfzWlt7Q==
Date: Fri, 25 Sep 2026 15:19:31 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, hughd@google.com, david@kernel.org, 
	ziy@nvidia.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, 
	kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: shmem: ignore sysfs configs for shmem forced
 collapse
Message-ID: <araC3bWDouc4_i4X@gremlin>
References: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <063f655b4d6c4234f3aa27ed6ecab10283ecb880.1789351825.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2C92140004
X-Stat-Signature: kyfqfw8f9sdzsaj8s1mrc93jm7w1zge7
X-Rspam-User: 
X-HE-Tag: 1790345978-589887
X-HE-Meta: U2FsdGVkX1/s3RMCjzT+KFioAjEc02a/Syj9n7NMazh9tQ0QcAAK4jwSHfn5bwP+4RzR8psm6thgfEWp+XsqyaKs31Tbe1AEL5pysxjIBqcw6aPBnJD67YVOqRvyPEbvU4bTOTtBfx52PUxVLsH7/BgvttVX/OHjWo/j+qDM7d4nUaO4kd9yDa7Umwr45DNWSiHIzlWWxWaBi3CpU9ykJdjBwZeik+W9YrnNZxXRzx0zuWm4FWEkwrpWJJxvOd+zKZ0iQoirZQ7/j0R1AzWi27ogl8l3hyosiFt0lo+6p9eYm1DQVTnrbl8w6XYJD5cGK7ITHp3awHEGNs6xws9yIgy1LFiVkiEuJJkOct2uuwDrAv887Xgq9KrgFWJ9/+w/9dml7saSSHV9XHYQMahecA5IiBJDcu5WdzfaA/fLBTAXXYi+pGid68AjUL87DFxK0MdJ8tvePVQm3gqU8niKkvoZsTU3/kwrtibLYM15S6RlVsvDZBrsiAhNhAcbbLemKkdyLQFHPgKpwYoPmPAxGZAAhLt0EHdKj0yJ3ZsmGy9NF6XZTt49kJ8NBQVXo+EPNgl2muUzo3ikQU0BbQNaZSPiy5ZVKx54Qib0hHTe5vVynPvohwLkiO/r/neaAyuMw05IgQD/HlcdBwlRNsIdQPK0nsB0S2R5m3QarE6uawqUV0uFUQcL+7LH/oWorjCK8JaSHKil4IdkWsAARL4N3Rn/+ZLC/IzS9UNwM1mjtSOz+yTJXxtNeagpTpB/O8r5k4069AnvfyQIdoqf49eOEMKCyFjwLw1IJ2ylFcl8PcXak16C/RC3zb63pi9DYcG558AUqwjofb0RNFKthxKiGJPTIz9j3uAqPEcYtKSPQfuqvD7zMkog3YpGJDdyAKsmpAO5p1/WG9UsXii1OjUURzRYdxsdTlbaOSLsRZA0pGfTlNcq94K7YzJt84Aq4a4cYU6vGbutU9uFb9fXtes
 BQx0LgJB
 I67ZORkC19jHlonHiajIQU20Odji01fcGggpqtTMVTx2HNLuT/FcIHt92lhdA5DIzkoEo22R8iHF/fM0KYYFGS78Z6r89jvstwNtVx26bnqyRivDW+WbBITcGrKwGTmdKrqKjkHBtZIlsI/3C+pAgg888nKFGVihO7O9Jb524GNUhHQTF9vP7SbWX5Occm0yOZBdbO08tIKNasZziXO2MgGRDU/irVDOJUBtQhijAFASXWipO6PrYPrnaKWTNsZI+Kae12xAEu00XlCVMO7klUAFF6UDhZbuGabwjXCn4Oapa0HzsKQnvPFn4TnfmmlXSk964TAxhRxUhPc0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 14, 2026 at 10:12:41AM +0800, Baolin Wang wrote:
> According to Documentation/mm/transhuge.rst, MADV_COLLAPSE is expected to
> ignore any THP or mTHP interface settings.
>
> However, after commit 26c7d8413aaf ("mm: thp: support "THPeligible" semantics
> for mTHP with anonymous shmem"), performing MADV_COLLAPSE on shmem will
> depend on /sys/.../hugepages-2048kB/shmem_enabled being set to "inherit"
> (although that is the default), which can cause MADV_COLLAPSE to fail
> unexpectedly.
>
> Fix this by returning the result of shmem_huge_global_enabled() directly
> when MADV_COLLAPSE is requested, allowing PMD-order collapse while ignoring
> shmem THP/mTHP settings.
>
> Fixes: 26c7d8413aaf ("mm: thp: support "THPeligible" semantics for mTHP with anonymous shmem")
> Reported-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Closes: https://lore.kernel.org/all/20260908125105.1510704-7-kirill@shutemov.name/
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Seemes reasonable!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes from v1:
>  - Use the correct fixes tag (per Kiryl).
>  - Collect reviewed tags from Kiryl, Zi and Lance. Thanks.
> ---
>  mm/shmem.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index c92ed17dbc4a..b572c60f2af8 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2049,8 +2049,11 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>
>  	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>  						  shmem_huge_force, vma, vm_flags);
> -	/* Tmpfs huge pages allocation */
> -	if (!vma || !vma_is_anon_shmem(vma))
> +	/*
> +	 * Tmpfs huge pages allocation or forced collapse ignores
> +	 * sysfs configs.
> +	 */
> +	if (!vma || !vma_is_anon_shmem(vma) || shmem_huge_force)
>  		return global_orders;
>
>  	/*
> --
> 2.47.3
>

--
Cheers, Lorenzo

