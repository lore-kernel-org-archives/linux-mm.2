Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 066E1CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 21:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56A9F6B0093; Fri, 22 May 2026 17:47:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 541E16B0095; Fri, 22 May 2026 17:47:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45F0C6B0096; Fri, 22 May 2026 17:47:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 357396B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:47:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF6C4161625
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:47:44 +0000 (UTC)
X-FDA: 84796393248.22.4E05ADD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E9827100010
	for <linux-mm@kvack.org>; Fri, 22 May 2026 21:47:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQFXKOfk;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779486463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dljCxK1YsQZK68Gu9mqCcSDyHCzwiebiXLJPqO1ehDg=;
	b=8hkKk3twkyvO724yUKosEEqvWTyiglyLJZFH7VJcSzpouTNNCXbxOGkH9YA6SoiuNtZHg4
	QygeZLGXH+2pEZFziAB59wBq3DTmW1+JdbQhoeyJ6EBEMr/MomRu+z5mJ0sGXW4U1lcnel
	87qngYlm6QVxUz4fJSsfeumBGDOMUSk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQFXKOfk;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779486463; a=rsa-sha256;
	cv=none;
	b=02GovQeZPsqabF9ryBFNdGttvRVEj6mF5CNJDwUvXTJz3bheqDc30pxWYB5ovR7q6DvIra
	LLoQNidHQCaC8Ak3NrVPU/zaXfTW+L38T+3ViOCpR0DJRNw0Qu65ilqjj5++ayMMyNSesv
	ApCXcprHcXW/VIARCWge1YbNa4EWshM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCACC42A93;
	Fri, 22 May 2026 21:47:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9531F000E9;
	Fri, 22 May 2026 21:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779486461;
	bh=dljCxK1YsQZK68Gu9mqCcSDyHCzwiebiXLJPqO1ehDg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NQFXKOfkWjqTi+NS7Vynjpq9Z7Lngi3QzlylGeaZ114+OMZfavNUzkIR0G8inmBDj
	 H346fIolGEZCV1B55hPO1XYWFoMPyr+ruDlBgXWbbLzjfQ2IcJ37hfsrobCXH9PFb0
	 9waRpIVjasjyzEWSomq2KOW9ChUnvNXE9f4AVq5tatndZPBYQOe9GUxYegSrfH8qo/
	 VBJOsNgnAcN2Cfg1GeZifTa6EUHLC+2C7MUKh5RQQ7/VwrYbYbRwvfE+IpkdCtWu0m
	 C/nM7SpktkbhFg8Wvj9wBKi4O+YBlFkT1sMu7IW8ohEVECKUVP2yBn2HAmTJrarZ2B
	 3Iicltj3psmcQ==
Message-ID: <eabb0c67-e595-4215-b88b-9c821b4de01d@kernel.org>
Date: Fri, 22 May 2026 23:47:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize
 collapse_huge_page for mTHP collapse
To: Nico Pache <npache@redhat.com>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-trace-kernel@vger.kernel.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jack@suse.cz, jackmanb@google.com, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 liam@infradead.org, ljs@kernel.org, mathieu.desnoyers@efficios.com,
 matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com,
 peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com,
 rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com,
 rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com,
 shivankg@amd.com, sunnanyong@huawei.com, surenb@google.com,
 thomas.hellstrom@linux.intel.com, tiwai@suse.de, usamaarif642@gmail.com,
 vbabka@suse.cz, vishal.moola@gmail.com, wangkefeng.wang@huawei.com,
 will@kernel.org, willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com,
 Usama Arif <usama.arif@linux.dev>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-7-npache@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260522150009.121603-7-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E9827100010
X-Rspam-User: 
X-Stat-Signature: ucmturmionsszt15h8p6sufuhk6udfsd
X-HE-Tag: 1779486462-954950
X-HE-Meta: U2FsdGVkX1/gR9nHYT/4cNlTYaaOBq8u6LcZofnAUwEW9izPDJ9vNF5kpCaw8Y9QUisZ4Th7DiVQYCqSKIIdlW9sh5pC0/ajz5O3XkKHCuI4uRjESugWIo6Tam8i4K4WbcQErErO9liz6/95GZtf7h6NlM3Xn9qzF5KK2uG2hN/jyOam1zoLuivdzn34AqJvMITSrXMvRNDUmMcCe8YkbXXnqmf+LpErZJ6FKsxrDypET02TNWqr7ZrcyylH8p+klCPgtiKaUajITdSpS/6jB18YwmCHhchjUmf2/uzS+pCfGz3v7w0CRokQccoIu7csaMr7ocgVx17Srgts/Hr4n9WlLVTurMN2cR4TnVX2WMRPQId1sYGRELy4tWAsqqm5b4qdCbteaAd2jm2GodGiLE8vJkxHZ1l57qFF3H+rbiHBrgP3Q0mgzbmMXTpxM4nVw0ythcrtscd1/F6n5RKukLjoPwMrdegK84xMVS+jn8horTd+Y/8YyPcTl1EDnz0iOOnsGh+FIQYblH83iWhEHwbEij9hV14bLIK7C6M1GJ4XjWzR0ci3xApNODiEfXETfRgij8yTrAx9V3ByykM+rjhIczxNCUbYeVeggEM/xTUV5C0yYXcrVsOPoZCsAqyXwYUnvjn6qgGYYwYA5jZmrp98emWvtN7jFM1bxwoP0ns8Xrxg+ufmelt7VzWITFJRDyoEa6ZVYNN1RB8FAzS8tGMQn0DYCSVl4EaEGjTApWALBHKPGBswc5tm6pyQXkmEsu8wHJfOP1OsATozKkPgEJatoVnpt/bt9MhEc+oOf2Ei1F5AVQP8mnlOHsKAsj+ficKGzHrIA+nYrWw1MIAm5Qm2SkEpIVVh3f+lYrB1Knm2IfJHfzRtcWG9o9Mzzmgp9z8y3taEzVlKZQgjoPagjCs6A9g1f+B2N02dVwlabh04pRR70Dly1io0O4Vd5z/duMdc6dPV8QuGcNil3M6
 W9UPhxZC
 4kX0vcrvX0DPOg412S8zH/aTIQESsMwqoHqKHAQsHX3OAvjJRrMHqK4TkqfriiNGeDVC5sQQaQyH8vCSrkUn8rcPLQIjiyeehVp0S0ipgPi4Y55weXHuaOZbmh7wmCHepyCNkYAHGcZBWeTNT6tvoBNvCW0pm6LaQYIsudSrvkOlZs3TrlAVWboAwUdzHy1+YcLTPKP3anUUWD+uP7Qlez3ymukkgL429F3x4Up1D8L+5tOEs3XsDBDDzQ+Qr7rnRLtYb7jTrYChwTto1oaYrcTwux/s2ERXEVQS0rvjOB2naj/bDyuh2b7MOtzIxw1hwN11grHbZ59BWuHiok0c/RBrSvayQk6594GDtR4FuRLVFN/BMpN0ewEoOL2DInb/yHk86pZlngkOXiiwKjqLTxIQUREn/Vhev54zkuAZuth1G2Rk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/22/26 17:00, Nico Pache wrote:
> Pass an order and offset to collapse_huge_page to support collapsing anon
> memory to arbitrary orders within a PMD. order indicates what mTHP size we
> are attempting to collapse to, and offset indicates were in the PMD to
> start the collapse attempt.
> 
> For non-PMD collapse we must leave the anon VMA write locked until after
> we collapse the mTHP-- in the PMD case all the pages are isolated, but in
> the mTHP case this is not true, and we must keep the lock to prevent
> access/changes to the page tables. This can happen if the rmap walkers hit
> a pmd_none while the PMD entry is currently unavailable due to being
> temporarily removed during the collapse phase.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Nico Pache <npache@redhat.com>
> ---

I guess we should add a comment here like:

/*
 * Only notify about the PTE range we will actually modify. While we
 * temporary unmap the whole PTE table for mTHP collapse, we'll remap
 * it later, leaving other PTEs effectively unmodified. The locks we hold
 * prevent anybody from stumbling over such temporarily unmapped PTE tables.
 */

>  
> -	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
> -				address + HPAGE_PMD_SIZE);
> +	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, start_addr,
> +				end_addr);
>  	mmu_notifier_invalidate_range_start(&range);
>  
>  	pmd_ptl = pmd_lock(mm, pmd); /* probably unnecessary */
> @@ -1294,26 +1297,23 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  	 * Parallel GUP-fast is fine since GUP-fast will back off when
>  	 * it detects PMD is changed.
>  	 */
> -	_pmd = pmdp_collapse_flush(vma, address, pmd);
> +	_pmd = pmdp_collapse_flush(vma, pmd_addr, pmd);
>  	spin_unlock(pmd_ptl);
>  	mmu_notifier_invalidate_range_end(&range);
>  	tlb_remove_table_sync_one();
>  
> -	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
> +	pte = pte_offset_map_lock(mm, &_pmd, start_addr, &pte_ptl);
>  	if (pte) {
> -		result = __collapse_huge_page_isolate(vma, address, pte, cc,
> -						      HPAGE_PMD_ORDER,
> -						      &compound_pagelist);
> +		result = __collapse_huge_page_isolate(vma, start_addr, pte, cc,
> +						      order, &compound_pagelist);
>  		spin_unlock(pte_ptl);
>  	} else {
>  		result = SCAN_NO_PTE_TABLE;
>  	}
>  
>  	if (unlikely(result != SCAN_SUCCEED)) {
> -		if (pte)
> -			pte_unmap(pte);
>  		spin_lock(pmd_ptl);
> -		BUG_ON(!pmd_none(*pmd));
> +		WARN_ON_ONCE(!pmd_none(*pmd));

Likely VM_WARN_ON_ONCE is sufficient.

>  		/*
>  		 * We can only use set_pmd_at when establishing
>  		 * hugepmds and never for establishing regular pmds that
> @@ -1321,21 +1321,24 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  		 */
>  		pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>  		spin_unlock(pmd_ptl);
> -		anon_vma_unlock_write(vma->anon_vma);
>  		goto out_up_write;
>  	}
>  
>  	/*
> -	 * All pages are isolated and locked so anon_vma rmap
> -	 * can't run anymore.
> +	 * For PMD collapse all pages are isolated and locked so anon_vma
> +	 * rmap can't run anymore. For mTHP collapse the PMD entry has been
> +	 * removed and not all pages are isolated and locked, so we must hold
> +	 * the lock to prevent neighboring folios from attempting to access
> +	 * this PMD until its reinstalled.
>  	 */

That makes sense. I was wondering whether there was another reason for dropping
the anon_vma lock ... I guess it was just for latency purposes given that there
was no actual need for the lock anymore once all folios in the range were
isolate+locked.


With the two its above addressed

Acked-by: David Hildenbrand (arm) <david@kernel.org>

-- 
Cheers,

David

