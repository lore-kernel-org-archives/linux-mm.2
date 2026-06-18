Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87077CD98F3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 12:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 555776B009B; Thu, 18 Jun 2026 08:40:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 506B36B009D; Thu, 18 Jun 2026 08:40:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F5326B009E; Thu, 18 Jun 2026 08:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DF886B009B
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:40:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 97ED21C27B6
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:40:45 +0000 (UTC)
X-FDA: 84892992450.15.8C0AFB0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C31A820010
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:40:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vx0kr2+Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781786443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0Qt6RbY1neuLDO23KPJWejF29MxVnzzExSz3cNAVJrE=;
	b=im07FjhwwiYnxZvzja9P4xI21wo45mC6qkF2mw1oGM3wrkZZYGrVz1JXzSdzlezWzRSy8P
	tg9H80xHIVaqWTwlbWEwmJUBNKg0FvexDiMZB25F1VQ7cUXXP7yS3PT9tvBzeo4s7hfYI3
	Ctr/pFtfxE28odb8kGlX6atquOjd6cc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vx0kr2+Z;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781786443;
	b=N5YEr023k9jCx4oT0GtmJZraJJuAKXu337b+Gsoxzoo9yTxvMzt7PVYZbewmO5dOQ4xUJy
	qTjUopTR8IWXKIOV8IVs0b2vDWPA1rnIXcNsl68ButRzFi/pohXwCO3Xjf7w8NotxGI13m
	VYrBNmmeeSfg+GxFK65IZ3wBWwRQ3F8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C511843430;
	Thu, 18 Jun 2026 12:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15CCA1F00A3D;
	Thu, 18 Jun 2026 12:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781786442;
	bh=0Qt6RbY1neuLDO23KPJWejF29MxVnzzExSz3cNAVJrE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vx0kr2+Zfio79QB+wqpIIQZskH9Yx1qGM7ROGWVuSUqewye0PzwhA3OjOyXNzUlRP
	 Conhx2Ha25bcy8NDg+HV9CBDAk78HUrPwlbslVJbrmN43thlFkwqEDJkQGhSSW/HkY
	 0hheO/BrAJxP+VYQxwL1hl+HYnQpCXSZevLKOzUuimPlgTOmdX90mwC2hFwR6O8wrU
	 vk7OaDthsWee6tFMYpegh3Eur5vI/wG3pXTlnjfHiqp+6/cSZoV+c/jzgT76kqqP/8
	 W2UVvyiUwdDB128TQ82BVT2vDqTl9SWTGT3QW2GZXxACVBU7hB51PmN4fYOxhqFKCr
	 94M+yWeBQwTqA==
Message-ID: <167eca2f-8338-4c95-93c7-b2d2a11bfef0@kernel.org>
Date: Thu, 18 Jun 2026 14:40:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: remove PageTransCompound()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Xu Xin <xu.xin16@zte.com.cn>,
 Chengming Zhou <chengming.zhou@linux.dev>
References: <20260618113523.3913307-1-wangkefeng.wang@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260618113523.3913307-1-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C31A820010
X-Rspam-User: 
X-Stat-Signature: ghnas3rqe5bmhm99ur7ymkgap1pjrzwf
X-Rspamd-Server: rspam09
X-HE-Tag: 1781786443-175276
X-HE-Meta: U2FsdGVkX1/IaZfnj7Ex+BgKh1Ot/Lx+xuigEpB518m3C2MhGW7vmg665sUHovOs9Wrq/mLGm7piYldvamKWuP3xiQi1BBNAepyoUbGrHu/ljf7S1c0KcuOJtuKdu+j0cB3pvIScy49EO5At65II0Jl142eN2IwW66k0ehx037fGruK5N7lTlVo9ZQnEw/yqK7AhNaI4OiCrLGlgxQ5NEj7cZvBqi8ZIblI7mx6ZRUPwCGNVSEeCr4Y6zaGRM9viyDGLmjJ2/T2q/YfXuDwnYYByQCSYJgDNoQSrJdakJFmeRqAjJmdENTCG6AfchdOp68bOn93SBQVn0Zm2jQQEoMvgOSReRZZjHPXG2YyItTaYQIrXoeUdzWRj2SkztwDugVpdBzIZbcWOQPjs7ZFcGNGeHmB4GnJoKXLPlzrplQm78YQtgGCsE7JHG+j9lg4MDPrVqYTkvakmtCy9c3rvpI0IYaZAI9qGbAq+sXIdLkJj6gdEvDfnqXyRwoK4KNnS9ZmHKTbqqraQahhdDmZDASKkXl6IwRgFLZn1oE+hKeN1DBbt34iaeqXcj4oIvtp5EXk9+gbc/djHAxpP/4u6j5GIzcP3Le2SOwVEY28TCRWHagCml2DdGqNU+MqLv8H/IovIfpOC5UMRn8frtJK5yROUJODuS4SECDGeqF1qD+RjKjg1a8fQgNF+mohGtrRUl7CZ7s/DOuKUQ6DiSddrqQ2p4wS/OuoucSSF8CyRxvjQviNVl4q34xOjpE8ypXf+d+yiTsQoXC8r/pviEItj+8FGvfqlfs6JJuYbxi5xAFBs0TRKY/ziaf/lhqze3HhXUkD+6aLrmiactU6JsUEIAg5np4BVnEUCznLFEbAsfimaU2EhFJJt06u+Dxmpc0jv3EsxhactmJRh/zwubHbjGoVaT2TUEsUiyJdm15gt/gaVKfVuOA7ghY4gqvQTVa3Zj5rV4C63MbtiHIEJkb/
 aulu/eBp
 5gFLbrvlievCSHbz4uoLn8sVhaDJpo1SxoKJDy0Dsgo6OpHOF94yBuyE4af9lQHJkf0aAkAYpMMnf1m7x5k4PC0pjV+CrIt7mHJ4hj1LyBtJYVJRonSdiv8hYV7OmEvBgMVsrAFzB2zDsZfeOd5bVuPN7fe1AHeN24yqD4Ww7X/eyP/HVTQQqvkKnNALlN0NLUrYcEBOvUneZvTWHbcENqWJ9n890lWHGchHfH+jfDDIJN7RqzbhmN3jvs0XG/zXFfxM95tEJpV/C2IeDjHZupKzB0+OFQ4mw9J0rzlszgVlsYLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/18/26 13:35, Kefeng Wang wrote:
> Remove the last user of PageTransCompound() in ksm and
> get rid of PageTransCompound().
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
> v2:
> - use more folio in cmp_and_merge_page(), suggested by David
> 
>  include/linux/page-flags.h | 14 --------------
>  mm/ksm.c                   | 17 +++++++++--------
>  2 files changed, 9 insertions(+), 22 deletions(-)
> 
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 7223f6f4e2b4..7a863572adce 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -879,20 +879,6 @@ FOLIO_FLAG_FALSE(partially_mapped)
>  
>  #define PG_head_mask ((1UL << PG_head))
>  
> -#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -/*
> - * PageTransCompound returns true for both transparent huge pages
> - * and hugetlbfs pages, so it should only be called when it's known
> - * that hugetlbfs pages aren't involved.
> - */
> -static inline int PageTransCompound(const struct page *page)
> -{
> -	return PageCompound(page);
> -}
> -#else
> -TESTPAGEFLAG_FALSE(TransCompound, transcompound)
> -#endif
> -
>  #if defined(CONFIG_MEMORY_FAILURE) && defined(CONFIG_TRANSPARENT_HUGEPAGE)
>  /*
>   * PageHasHWPoisoned indicates that at least one subpage is hwpoisoned in the
> diff --git a/mm/ksm.c b/mm/ksm.c
> index 7d5b76478f0b..41ab25aa2a82 100644
> --- a/mm/ksm.c
> +++ b/mm/ksm.c
> @@ -2327,23 +2327,24 @@ static void cmp_and_merge_page(struct page *page, struct ksm_rmap_item *rmap_ite
>  	tree_rmap_item =
>  		unstable_tree_search_insert(rmap_item, page, &tree_page);
>  	if (tree_rmap_item) {
> +		struct folio *tree_folio;
>  		bool split;
>  
>  		kfolio = try_to_merge_two_pages(rmap_item, page,
>  						tree_rmap_item, tree_page);
> +		tree_folio = page_folio(tree_page);
>  		/*
> -		 * If both pages we tried to merge belong to the same compound
> -		 * page, then we actually ended up increasing the reference
> -		 * count of the same compound page twice, and split_huge_page
> -		 * failed.
> +		 * If both pages we tried to merge belong to the same (large)
> +		 * folio, then we actually ended up increasing the reference
> +		 * count of the same folio twice, and split_huge_page failed.
> +		 *
>  		 * Here we set a flag if that happened, and we use it later to
> -		 * try split_huge_page again. Since we call put_page right
> +		 * try split_huge_page again. Since we call folio_put() right
>  		 * afterwards, the reference count will be correct and
>  		 * split_huge_page should succeed.
>  		 */
> -		split = PageTransCompound(page)
> -			&& compound_head(page) == compound_head(tree_page);
> -		put_page(tree_page);
> +		split = folio == tree_folio;
> +		folio_put(tree_folio);
>  		if (kfolio) {
>  			/*
>  			 * The pages were successfully merged: insert new

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

