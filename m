Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4453C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:22:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25BC6B0095; Fri, 10 Jul 2026 08:22:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7326B0096; Fri, 10 Jul 2026 08:22:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC66B6B0098; Fri, 10 Jul 2026 08:22:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EE1B6B0095
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:22:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 43E2F16957F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:22:13 +0000 (UTC)
X-FDA: 84972779346.24.895D6A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6C95F160006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:22:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SDXK/0wx";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783686131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDgjRBlYu1xxBnZ1IMeHj51O6m+GeaRvDabt0r9az68=;
	b=C8noFaTXLogteEkWDk7T58iFC85x1KElFwRD8FdwTz6q9dIXH4o3SeAi6N5bxXEVsZXXyz
	vimlgleBUNQrd+hREsPDy1uZaw0JgfPLi0DmaZjxLReSgxIHv7E7FQYdVg78iYES1fMJ4G
	os2r9Q/t1CK0oI1l5kjCQbvyocV6bdk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="SDXK/0wx";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783686131;
	b=JTDf7/a0CTQq1LWIwBx4MSGLCeSCJPqpDGDKp4+KNeqLGpoAvlII+yqDIjXE09Co2FHBMJ
	w+sZ8G5UF1lMNphXh39sJIE7ZgPhUY3rxG1hqsniCTkErguf94b6GcJwK8j0Y/0rIzSswN
	97I5Qf1sdRNdcGr34NqG2jz135464FM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98662405D2;
	Fri, 10 Jul 2026 12:22:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DAE1F0155A;
	Fri, 10 Jul 2026 12:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783686130;
	bh=fDgjRBlYu1xxBnZ1IMeHj51O6m+GeaRvDabt0r9az68=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SDXK/0wxM+vVK5Aq9AxQaVGqL3/lAKIHy1sJwPtT4QLKGiyAwSKhXKd1G9DrHgsas
	 ve4xSKX2z1MWh9cMllqIqSzkrxvJLiPfr34a5Zu9v0ERWAMykx6UVg6eDHjivhqESK
	 NmGg9NMzLOVemntDlyZHzhB6warnBuU0ZHNV3ruxdMudK2Q2MGFxf6060nUEAFY1zB
	 DbwRHu6rgoHVw3DWF2XoJ0X7jS+QnF16R7uZwjvzhUaWC7ENs0qyKmS6UL/XrSgLXX
	 j8UfhpgN4jmgZeUuVMkQIFyfonnp/Hi0Oh1c8xJkhH+GTtP8IpnQ+U8tlQWkCj4ItL
	 vqEeSka/ysxiQ==
Message-ID: <87b94730-7543-487e-8f3e-c13251a00a21@kernel.org>
Date: Fri, 10 Jul 2026 14:22:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/5] mm/rmap: convert page -> folio for hwpoison checks
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de
Cc: riel@surriel.com, liam@infradead.org, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260710055915.638659-1-dev.jain@arm.com>
 <20260710055915.638659-2-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260710055915.638659-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6C95F160006
X-Stat-Signature: r1nwzby4iixj86gihiew4fi1pbjkikh6
X-HE-Tag: 1783686131-119817
X-HE-Meta: U2FsdGVkX18RFLbFsAgSN5K9Cy1Ms0UvwAhqnnJQZokqg6mb5l2a9FoIprl4qLQhKU3wSVJCet8kjPvcM93VU6JTd+RajG/pE/fKHzhYzQPmEdv8Zn6KaF+npUVY8YKDaJqGBD7+1IUvSCEqTBsZSIqCRlUuW5zuHkTu4y1cjzGBd2f1rAUyi3t2NEKind76GzkrkfmNtV9IMLpD7EcPWuRvF4oGFNJxzSsvA4HqvE8CZEkN4jk/3ASwmgWJkyv2AEY5lktXDCeSUaF41UnnMUTBaXur06pjXssJaUr3Ly1N2WFfeq59POTtn84YQ1TquUhfIKJYhvcEMaJoRYfy96ojx6Axk5frP+2sXj4cuW+Xj7D27zVQcC5XMqjjqbDqRNcIH+/P5HbhaSq73FQ85BLV6eTHxC5L7oCvk+DPyCV69BUfQCJUmXJTZciChBOr2/jFMxEu/Su1jmybufZlh0C+a/JOe/6HR3y4XILf4ocr2R6xPnikoeetpY1zYBoZaQrEm9g8drf3jXX5D1g5kDK94+hPAgWH3b9aM3An9sFZNr+EAPnybdQLD4mz+ww6A8aVVBh0RkxwWr05Ap8XMpUZdoaByOH/+5zZ6YoB73uCHOyBje5x3cp/ynE105vG9HNEBwWs6hWd/uyrh2V+3w7ywNl95vxEpS8QxlSHxo01gns+HfXVnIyaCaO5BojfR3rwaU6zj4tCI19swij+BsBfdsAIfu35uv9YiTnJuF3Qk7EMewtD8qNbsNTQMTOpKQzBCRBl8S7J2t1qNf62m2C+SOwwe9Uze4YJEkh0mdegQgAcEj4Jyt5b86t22ZeoOT2obDTqnlCx5BdgkDfjV0s2D+Elg10QljG2rfIs4tgK8QYQ2J6VmM6l6l2D87yU2d2W+LeWrxUbJCiA7zYQMmtIt65iM2aK+jLNW/vU8sQ8Bd7lBkMmQzv0Te06XJiwJfEVVxiAabeNod5iQsB
 6a6VHEBs
 JZAI2vHP9kZpsQNkoRa8RX2DPr1B6dPLYRS/HZ0ZuFqvDyYeLMEcm2qZh9/LhW10EFzlN/4ZxchKqlgIbKRr00lrkfDiRz3JTqkioXN1AYTfpLpEeuZpTrI1lrpvlYNCch6rYe+3nLprOvc0CqwGBA1t4K1lFTtvZj/q9txYVLI8Hw5Km7R3lNVxP5tJRckmlZ5hppcyU8Ss3mi0m5es7ZMaXvSpS1qMMnnwNvI5LUoJz0LODQil7zdazX0cHRQx2nT9VqW0eKod461M5RUSHspmunoTVXTwpFG3ibiKCYYrg8ijx7+NDqWdRoaHRbKlUFTkAWUQk8ZpOFZFdCTvJwTq1JA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/10/26 07:59, Dev Jain wrote:
> try_to_unmap() receives hugetlb folios only from the hwpoison path.
> hugetlb_update_hwpoison() sets the hugetlb folio's head-page
> hwpoison bit, and page_vma_mapped_walk() reports the hugetlb mapping at
> the head PFN, so the previous PageHWPoison(subpage) check happened to
> work for hugetlb.
> 
> For non-hugetlb folios, unmap_poisoned_folio() currently rejects large
> folios before calling try_to_unmap(). Hence it is always the case that
> if try_to_unmap_one() handles an hwpoisoned folio, then the head page is
> marked with the poison bit.
> 
> Therefore, convert the poisoned subpage checks to folio_test_hwpoison().
> 
> No functional change intended, except that, while at it,
> convert VM_BUG_* to VM_WARN_*.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 9939400e77c79..dbb077f8443e3 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2122,10 +2122,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  			bool anon = folio_test_anon(folio);
>  
>  			/*
> -			 * The try_to_unmap() is only passed a hugetlb page
> -			 * in the case where the hugetlb page is poisoned.
> +			 * The try_to_unmap() is only passed a hugetlb folio
> +			 * in the case where the hugetlb folio contains a
> +			 * poisoned page.
>  			 */
> -			VM_BUG_ON_PAGE(!PageHWPoison(subpage), subpage);
> +			VM_WARN_ON_FOLIO(!folio_test_hwpoison(folio), folio);
>  			/*
>  			 * huge_pmd_unshare may unmap an entire PMD page.
>  			 * There is no way of knowing exactly which PMDs may
> @@ -2204,7 +2205,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		/* Update high watermark before we lower rss */
>  		update_hiwater_rss(mm);
>  
> -		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
> +		/*
> +		 * With TTU_HWPOISON, we only expect small folios or hugetlb
> +		 * folios here for now.
> +		 */

Is this comment helpful given that you change that in patch #2, where you forget
to update the comment? :)

-- 
Cheers,

David

