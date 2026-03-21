Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E61701099B54
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 05:59:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01F5F6B0088; Sat, 21 Mar 2026 01:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F12A76B008C; Sat, 21 Mar 2026 01:59:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E28286B0092; Sat, 21 Mar 2026 01:59:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D34BD6B0088
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 01:59:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7D89DC1D9B
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:59:46 +0000 (UTC)
X-FDA: 84569018772.08.9C806BB
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf27.hostedemail.com (Postfix) with ESMTP id E3B5A40006
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:59:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Y4E82WxM;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774072784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tB8N/EDzD0rrPaEsXZHYue0cF2DWaunMlW/oScwdeko=;
	b=RCCRsZ9AcBiaIgPVFpn1upiTpneKrVd3NGdNjLkIcECERoHwqD6swyYuUIyVYTA/9dp4bx
	mWL86j+kCTcjAtfs+AYzw410GAHKqBAdCragQZFoSbNihVSGlJcNjCmd8eHB79fZUbatkO
	QDGhlmlvDawjteaepZa3kqOgM5hdu0Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774072784; a=rsa-sha256;
	cv=none;
	b=OBesGkPU3iuX3KmXDaNVq4CvUmcw7b5PoA/KFCtR1AAT2fEWo/e9GAuyGeWm71I1nsuRBU
	7SGh8dfy4n2KrsBOBrJN8J4jVmTcY020tRAmINwD8ZzNdRsAEfnSva9HCSUy0OrZ2oBk1f
	qCW8xHvrGc9ImyDMaDcE0I75RDGyFBk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Y4E82WxM;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774072780; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=tB8N/EDzD0rrPaEsXZHYue0cF2DWaunMlW/oScwdeko=;
	b=Y4E82WxMPvLsIsD2eGair6Q8Mc9i71iHmHAbXb7Vpwjmm3+bM8y43Hc1jxPYE8X4ioNYQrcIwK9JBqbByGqr6NpCeE8kjOI2kCGEM/sMi+R9f5GRR8rCq+s5FneTGNuh6nxlN3d1cKVQzBWzPwWHdeLQC7cTOqCZR7sjpY+LyOc=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0X.O8CIH_1774072775;
Received: from 30.42.98.36(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.O8CIH_1774072775 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 21 Mar 2026 13:59:36 +0800
Message-ID: <ce065f40-38a6-4601-845a-78021af80f04@linux.alibaba.com>
Date: Sat, 21 Mar 2026 13:59:34 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/13] mm/huge_memory: separate out the folio part of
 zap_huge_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1774029655.git.ljs@kernel.org>
 <6c4db67952f5529da4db102a6149b9050b5dda4e.1774029655.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <6c4db67952f5529da4db102a6149b9050b5dda4e.1774029655.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: o6pn9qjrxmo46sq1ob7p9jqhqrh8bdzs
X-Rspamd-Queue-Id: E3B5A40006
X-Rspamd-Server: rspam03
X-HE-Tag: 1774072783-381854
X-HE-Meta: U2FsdGVkX1+ciwNLL9L8z1DtteDxKuknJwlYQkZ9j8PT08dPpx0feeRvUn3vlHDamgdAdkoYTL+m+9peDkB2N4sU7GhEuYeN3Tpb7dmJrSWHVs5mztsi23NEmxbbSDye1pbOMI62Z7zI2AGPiiYjtCCbzjB+y+tjEqk5V3gtruiEx84W2aiVebAmOtbGES+1e/rlWVkcgqlb8TEa8NfwxbJqkeTH0oRznIeYOFMy73m8fMt1zOkQScZ6ntsm3yv19FJkzci1oviwaOai85AfEY5ajCLjIQEf34tZccj+6J+Te18+6QMjSscgSFPyVi6fViiJAnMTYZ8jeyTxpIzREoFIVrTTy91mkn9O/yVCYPxxSIGN1iGtq7CDlMvw5EHVV+N/kusl27zZVY6KZ7ptf7JYMu5DmEWMfJ7Dsst+skI/G/oIaccY7q/FLwUhVxIbBoGQ65kd/lwoQF1D3nGVttXL0z0BeK495OclbAuuNxZqWmLu3kjSqT1bFBrq53A9A8/jAlorHwmgIxf5r4e4A6usuATmGD9P+QsjQuRxL5W/vhEnIP0WfwSJwgqaB4vjpvOMJuyxoIVHfmVho3r4gw+gq9e8+p+13jD8iRU6FrlF14OhOz4bRbs9NcgKfzmfIjLUfrWbpluExRWY6npebWziOcLVIlW6Sm9d9GhlQIy+PFp6xkvbhhQb5dqGibgORQHqehfH1ohbEc9m4LS19zj4oxIRmnLN82FVfPHqi8a3NtOgmnJtYxX9TIYj01QgZ4idPLtO19eEgfm0KZlQSD4eqUb5fVOTEewNgPzQH59x9s2Ee1mm93FoVBb24FrEp1v7B8ZuJJPvhY4P/1HHRsZT++1sZwIhj9vjjSKXeRgFdobGdVQe/YpMCgx32IiW8j63FN6DVu5s8N/8Qw2MczrdQpqTicYlybs/H48EKZtYZ/2C1YoZ4AB5hcI3XJqbVoHoD9F6AjCGbXU240t
 GAPGrmGh
 glWl+mkPC9XMSLp54ChjpXGll8hzKVQX1X1gE8U1Tl0CQCivUSwwC0GPFSshSLD3VE/T61n4Ak4fp6/amh/iCTgZ/oPgJlIZex+BVJ4119EPEUBZTKrgKt1qoqbkR0+bx6XKklI54QaWeliDwCn85XMpMefxJ2D6q2ExoL7ogCb6eZu2tQJoNJ4tsKutBk63VNMn1QIOj8RBdIwC8JaBuNMmrVIlB3XkGoFrZqhKjkozSjj+vV8KzST/wXs1y+TC2WQRyPJ3LlhvIruPUlGW/QGvttZS8p/opXG4uVfYCmJGs6RfRq+qRuARTvhSqxEeyG2lvwlrHfYG2m6dy13hnmO02WRDvG3oNWa60AFcu10MQJyeAas3INYHK9/wCo07GEUpQBIkSkBQtI/lZO7FFQ+xJpA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/21/26 2:07 AM, Lorenzo Stoakes (Oracle) wrote:
> Place the part of the logic that manipulates counters and possibly updates
> the accessed bit of the folio into its own function to make zap_huge_pmd()
> more readable.
> 
> Also rename flush_needed to is_present as we only require a flush for
> present entries.
> 
> Additionally add comments as to why we're doing what we're doing with
> respect to softleaf entries.
> 
> This also lays the ground for further refactoring.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>   mm/huge_memory.c | 61 +++++++++++++++++++++++++++---------------------
>   1 file changed, 35 insertions(+), 26 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 673d0c4734ad..9ddf38d68406 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2325,6 +2325,37 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
>   	mm_dec_nr_ptes(mm);
>   }
>   
> +static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
> +		pmd_t pmdval, struct folio *folio, bool is_present,
> +		bool *has_deposit)
> +{
> +	const bool is_device_private = folio_is_device_private(folio);
> +
> +	/* Present and device private folios are rmappable. */
> +	if (is_present || is_device_private)
> +		folio_remove_rmap_pmd(folio, &folio->page, vma);
> +
> +	if (folio_test_anon(folio)) {
> +		*has_deposit = true;
> +		add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
> +	} else {
> +		add_mm_counter(mm, mm_counter_file(folio),
> +			       -HPAGE_PMD_NR);
> +
> +		/*
> +		 * Use flush_needed to indicate whether the PMD entry
> +		 * is present, instead of checking pmd_present() again.
> +		 */
> +		if (is_present && pmd_young(pmdval) &&
> +		    likely(vma_has_recency(vma)))
> +			folio_mark_accessed(folio);

Nit: these comments were added by me to explain why 'flush_needed' was 
used:). Since it has been renamed to the more readable 'is_present', 
these comments are now redundant and can be removed.

With that,
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

