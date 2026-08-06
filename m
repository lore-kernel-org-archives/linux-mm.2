Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 693F2C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:26:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8141E6B0095; Thu,  6 Aug 2026 09:26:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C5016B0096; Thu,  6 Aug 2026 09:26:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B31A6B0098; Thu,  6 Aug 2026 09:26:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4499C6B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:26:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD15A120731
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:26:02 +0000 (UTC)
X-FDA: 85070917764.04.6F3DB7A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id F0FDE40009
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:26:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITCw7sbp;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786022761;
	b=ma/QATHU0My4FwzxY0RklV3hccPXweaocX2iCdkovliIof2I65CdPWjHtlS5hEW6G1u6+2
	QG3QEz/ukc/rszhFWGyRY1jP6fY/ULvQl4q1Fvcw1cXfzEr1fIXg/46esaYn7ShVqakAxm
	FgSKeFks+zjvXpBbq08T28Q9lSDv1ag=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ITCw7sbp;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786022761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ExN7aW1e4/LM/S0DFXynYmziaG42HPd3YEBb4sTiQKI=;
	b=FKB84pYV9yeERAaFPubbERrFXMhKUwc6M09JkWbEnZ60V1BWhEcfDAOtRrKP8cYP3FtUSO
	m3cEVmtfz+4KLPG8q6VQDfESN50pR5Qh1uBeQe8Hvs/VmFODGPhA8UHpABkSMY+j56rZJz
	e7DKO35nTVWvxxvYaztSF0Qllr+fzf8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1A91742DBB;
	Thu,  6 Aug 2026 13:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D45F91F00A3A;
	Thu,  6 Aug 2026 13:25:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786022760;
	bh=ExN7aW1e4/LM/S0DFXynYmziaG42HPd3YEBb4sTiQKI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ITCw7sbpr90J19cMvruOSywf8EepUGUHbl0bOFeh30yQ7XpnqbF99F0vPeJk0lJY0
	 L9imioaC3YRILYr/nVAXmeUm1+TpOnM12Q2SFexH+NawPaY6CMNqE/dGEg9xTVMICw
	 UwUjf63GkTlb+sv38Itzkxn0vF1JvRpj4zSkELroTji9QZJDfr8Uwn63YQ3tA5eNXl
	 KixuXMa2BzFJYAAqCoEwoU8PJtdoTPTin6nPcDEJzsL+TYPtpU3m30pXGK112Oo5rX
	 rkHxPNK7GncJfhIj0qXTe1wkSQNF0Y/ip0JsU3n1HEKx/wTq0SrE+iXfXZfHsj0cpD
	 7VvHvdJ81mLqg==
Message-ID: <82f6afba-756c-4ffd-bd5d-c3432179af28@kernel.org>
Date: Thu, 6 Aug 2026 15:25:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/mempolicy: skip zone device folios when queueing
 folios
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: damon@lists.linux.dev, linux-kernel@vger.kernel.org,
 kernel-team@meta.com, sj@kernel.org, akpm@linux-foundation.org,
 ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 usama.arif@linux.dev, vbabka@kernel.org, jannh@google.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com
References: <20260728194714.3713735-1-gourry@gourry.net>
 <20260728194714.3713735-5-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260728194714.3713735-5-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F0FDE40009
X-Stat-Signature: qshggeds56rt1b88bdhncobz9e5cbncs
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786022760-238673
X-HE-Meta: U2FsdGVkX1+4ACfoEYXtJ+vGM4xPqalKeU2dde1Nug49vOo63T7zlcqOo3JRWGZGS0rDkKDaePJXBCZj+sF7sRysWrq493wkiE72llfFZ3zbw1m+3T8UFxH4OZy5XP8AgVm1EbiUtgxrUiJBYb0+j2g/abfcBNvfNY8aUskvo99wJIHLRxJFs9dbVq24b5GwGfqZxLQb05PVwEd3kMrz5hnXOPMbX6+XTeHkQzlwryRu8gaVijOtpOwU1aRNh3L/kU5KsOJsAP4d5LPH0t/XC7Ynjk1wSbqYjOiJNKE58xl/aNaWWkVDENHjM+9KBYnsEeFNL1bKhVDMBf0bzu5Zryad1kzsphB1JPL2ogUKk55Z0ReXyXkH8Y8Z3Fmsb2BL9pJhLYZ7lj4X/Ze6QN62kTAhv5A7+rhU0Ytbn+4XehayYQEfI38f3xa/L4FezgYickwErF3AcQZ0nvpBvBcDWTmCqeS/5n6SPDTDqxTrtb72Y2QCnOpmi6Yzn+AXR9bP0QI3YmyDFEO9/ZmWcLNyJugRISzfJl/SZ26i0vOvinJh+mU57sdsvPy3hwImXfLZ6zC8j+RuGrkc20f3NBPvE7/XDqvMEEiv6PPZd8o1KlQYjlwynO+aVzGuUj+Hj6xCCTPT2OiOTzhUGAMxd1A+vXMAdYY7jCMWVDWleKxud5sd9PnMxPPF3c1EXdInSgJZNud+ZP/KYQNi2QymNrqXOc4Dj4NLcs2bQeokcl2sim1HLkPY4pqBw9Yl7pTvRXioDhXuyisrmuge8srSnMkhQT+GyijZwZj7Jt80JlVkE2bCr18KIN32FKr339Z3giDpuFMDOUjw6CkobfGVRTg/zIlRMTTlJLRUBsP0Pk2D1dZs8EemTRVoHn5yuOCS/ZUL37mVamYGgOfQ6LvQppROTYcSn+5P4mdnRQwyqHylnUIjvipJyyAHqFibVXgqNd1Hz4jeKQTP6u/DZoVqIVF
 5NfA9mQk
 YnOS+uHeTTqeEwuoS9TRhLkkdUgrCqJEjImjvOsuDltrQIgPMizPIFIjK3pp/r6ESe6Y+c/hQ7etpK45feI7zO347BnEyL+dk14q0DJ2hkCIvuTCbDxnWxvlZ15O7bTbo/hMtxoZwSjRv2jH/UyRY/JNRxZCwWF3yveTIroHla3Gms120GF1SKad+A9MNju6IDSH6OqacaHZj68BQixi+pu1Nq28hmyvPS7WoImJhvRTHledr9dkanrqThQWAEYYFySfKbxQkwzooH7M6E63JLYomaJ8MRfMAFeDOvZgPd1ePDCK6T5ZEqePC1r5PqojjPtVQB3+sq2QJ56zaSDTQo5EbeC/uqqL9W7SGiYNVoyFonypVJaf0FJT+nltoJRtndv2IuUpFis8mCtQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/28/26 21:47, Gregory Price wrote:
> queue_folios_pte_range() already pairs vm_normal_folio() with an
> explicit folio_is_zone_device() check before adding folios to the
> migration pagelist.
> 
> vm_normal_folio() alone does not reject zone device memory (a present
> device-coherent page in a normal VMA is returned as "normal").
> 
> Mirror the explicit check in the two other walkers.
> 
> queue_folios_pmd() uses pmd_folio() directly and can encounter a present
> zone device PMD - e.g. a device-coherent THP.
> 
> This is not filtered by existing checks:
>   !pmd_present()   - only rejects non-present device-private and
>                      migration entries
> 
>   vma_migratable() - excludes DAX and VM_PFNMAP.
> 
> The early return also means such a folio is no longer counted in
> qp->nr_failed under MPOL_MF_STRICT.  This is the same pattern used
> by queue_folios_pte_range() (skipping zone device without failing).
> 
> queue_folios_hugetlb() cannot see zone device memory - hugetlb folios
> are never ZONE_DEVICE - so the check there is purely defensive and keeps
> all three walkers consistent.
> 

No fixes tag?

> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 5720f7f54d94..bd79e61a40d1 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -668,6 +668,8 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
>  	}
>  	if (!queue_folio_required(folio, qp))
>  		return;
> +	if (folio_is_zone_device(folio))
> +		return;

Why not before the queue_folio_required() check like the PMD case does?

>  	if (!(qp->flags & (MPOL_MF_MOVE | MPOL_MF_MOVE_ALL)) ||
>  	    !vma_migratable(walk->vma) ||
>  	    !migrate_folio_add(folio, qp->pagelist, qp->flags))
> @@ -797,6 +799,8 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
>  	folio = pfn_folio(pte_pfn(ptep));
>  	if (!queue_folio_required(folio, qp))
>  		goto unlock;
> +	if (folio_is_zone_device(folio))
> +		goto unlock;

Leave the hugetlb part alone. hugetlb folios will never be ZONE_DEVICE.

-- 
Cheers,

David

