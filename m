Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11BAAC56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 14:05:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09B8D6B009E; Thu,  6 Aug 2026 10:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 024F26B009F; Thu,  6 Aug 2026 10:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2F336B00A0; Thu,  6 Aug 2026 10:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B69346B009E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:05:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6122EC0769
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:05:05 +0000 (UTC)
X-FDA: 85071016170.02.0B3718A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id BD55F100006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 14:05:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7uNVDin;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786025103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6APqpoAC3496oI8IPDgumvxehVxwgctdvlogEWJB54=;
	b=aj0mzt25E8iMjP497fgzc1YZxqsfEcoCklgZplcIvhAR7/5Did0LIOtzxLcvjqt1SQCe8K
	yTYYRcQKlaa3dB03roEoFb0YEWCsw1Gir7nPE8a3NqMGkMBVEDqAqv/fngeMlohLjXUr+H
	flVjPpQHxOVLygpJMq+tuoYBes+n3aU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e7uNVDin;
	spf=pass (imf14.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786025103;
	b=I25QbCW20TKlw1skQR/By7uxSeKofQNSyNP4XvUQtmF/NVGkVqrVlsXo0QEAzF/a8nbIzI
	kv09XyoSkexnhgWgvdfHyYFTGS5Q5qn6c0qn690sPkC2VXokUDFKzYxYH5o5RPNgdbzs+t
	/+3jIuPrl4xJ/qhM7DohlQKvwHPxJCg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3558060A69;
	Thu,  6 Aug 2026 14:05:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A35F1F000E9;
	Thu,  6 Aug 2026 14:04:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786025102;
	bh=Y6APqpoAC3496oI8IPDgumvxehVxwgctdvlogEWJB54=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e7uNVDinolId4oTkkdWmLABrN7spjecvFSAiaGhptvu+n+kbdbWcmCcSmzLfmrtba
	 Sipuirytwl0u7KG8zwUJ7JOH9qDbSKgVSB7yWU23pRUQGY1SjR4Ky2075A642KcR+d
	 LC8t37EWOQ6t3y+k/TxyaZF6ZQLaguCMGda3y084/E+y6JS1oKXp1VyyzXRfzWDKzO
	 8PdaFkqMFd6ja8+epLmFc+Or+hozyPpNPP0K6dLNyhSQrJDIx+f32ATANefVs954KO
	 q8AMAsfmd5cyfTswesD4Em2OpTCEwqsLe65KOP7EAUoVA9H7FVUKkeq8bSlnV/1Pzt
	 vwJwAmtToXmSA==
Date: Thu, 6 Aug 2026 15:04:42 +0100
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
Subject: Re: [PATCH 3/4] mm/madvise: skip zone device folios in cold/pageout
 PMD range
Message-ID: <anSUb_KvuBEMnAMq@lucifer>
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-4-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728194714.3713735-4-gourry@gourry.net>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD55F100006
X-Stat-Signature: q5kr5drnu55eqk9idtq4uhs7zyxggq6j
X-HE-Tag: 1786025103-598600
X-HE-Meta: U2FsdGVkX18UaEIfQ0yzgGwce+qdq5IG+HKlNENs1qRrC4vhPt29iPisgv5WHXKBsbh02QxLQ3TDvu5eEF53wDK82DkhmGQ92N36XJpyVqH1PVC8EdVCdVYFF6rgxxUSrGK/VmsvahiPpVFlFpDPXMH5l7aCj1qN/dQR6/h9eVmh3oGmoT81ln3LvFZ68DntfL6Yjf87zPFxxJ8ghORKuKsiCToyDg50v6O/sPBQCAiEqkG23Vg6P5XARseWdsfw9avo1PrRJaOsvery1xbXPKLr8lW/YYeL2QveU+T11KBxlxH42UcjYdraP7Ao9KTMJO2Byi2q9QltOQToWHILAxFMPVegvZy3DDcjMq+wRS97bA3PXtGfsXTU2Lrn/P1zPdXREu9olCo2pNqlSSPGShJ7pCcvsvu8G4x7HjDQNmuQy8O421HdIxViOZc3MpJxpQHL7xsjYqDLyPA9ojR3oAVyEZ/WdtsyBYEDdlqCZzdpks+zNvv+e3XBJvTTD6PpFLlQVgc3DWulDklWCGqvuHKaxRHggR/4ugh8zir3UgTP2grYPeEgpT3+eDBtdjICCUPHZzVd+vLBZ6ORExNh2AKMIMaYc8qSnSteDO99DL0fiU2SksfnG47/1rwfMhAfVb165zLStvbWzrt8aOUVesnRyY3qpgX6t0a7LnxbnJ5mUQhI7kqJ3ZlVUFchvuqMk+3HyPfz1wlB+c8Y8sLH0aUqOkbQLU32oH7XMfJ1RHeuU9JySCCwNkBPl/7th8IV6z5iR4FX6QQ0eyDJKHM/os+wWOZcD4IU091vbi51p1ljLkqGT5OSsA/pdFQn6TIdqiFzluhK3w1xQtmVj0pfu1S3pYd//o4GyfB/0cRq6Xbp0aZgzqkkvaeYYA0E+8WaiTzQsMpK14YXiCVVUF4Z1R1j8Xa5H+MI52xGDerIGQTaYIxqARhfrlfMKmi8gAZVWNon2GCd01aJyjHTAaw
 VfmnGSuV
 ZJmFy5++QnaRSj5chge16+6KLucKBHwR0teCbMBYeyIgQt1QAuzgvQiK7vI75/tr2REpheKA+UyPQXe4zQheDn2YRuvCj1lPdaEJpb8sLGfQsNPaR17Iag140HLdcczOJ/lq3ErLGgfq4V1ULEq9GoaRjuuF+I9opUXQNxUjFibQEBOjG170S1lhnfSeFvyEGJ1sRK9p860JObtxFtiN91HuMMoyAH7xtMYe9dHTKOZTlEJx2vGtCtnfoU9KwOE9dzDPIpLy0Efs5oAi1GTleMtId4gBkUDz8Mjq1gV+3xEPnp2iAzH0zO+G04OJrR7/lkd+cOJmoNAAw1EMCpw1PwpAs20FDgv7GbBoHbjdaBn3yBdoXywDdDfmmrmYDDk0DJ1pLHw5spEywj2U1MXA22EqstD9sHB0wFA4H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 03:47:13PM -0400, Gregory Price wrote:
> madvise_cold_or_pageout_pte_range() resolves the folio backing a PMD
> via pmd_folio() and ages or reclaims it without checking for zone
> device memory.
>
> The surrounding guards do not cover every zone device case:
>
>   - can_madv_lru_vma() excludes VM_PFNMAP and VM_HUGETLB VMAs
>     (so device DAX is filtered)
>
>   - !pmd_present() branch above rejects device-private and
>     migration entries, which are non-present.
>
>   - A present zone device PMD - e.g. a device-coherent THP - is
>     not filtered by any of these, nor by pmd_folio() (unlike
>     vm_normal_page_pmd(), it performs no special/pfnmap check),
>     and would be aged or paged out here.
>
> Skip ZONE_DEVICE folios explicitly during MADV_COLD/PAGEOUT.
>
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>

LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  mm/madvise.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 07a21ca31bad..ffd6a68320a8 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -395,6 +395,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
>
>  		folio = pmd_folio(orig_pmd);
>
> +		if (folio_is_zone_device(folio))
> +			goto huge_unlock;
> +
>  		/* Do not interfere with other mappings of this folio */
>  		if (folio_maybe_mapped_shared(folio))
>  			goto huge_unlock;
> --
> 2.55.0
>

--
Cheers, Lorenzo

