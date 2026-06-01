Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE00CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 14:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 099D36B0182; Mon,  1 Jun 2026 10:07:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023316B017C; Mon,  1 Jun 2026 10:07:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E563F6B0127; Mon,  1 Jun 2026 10:07:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D29F36B03B9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 10:07:46 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9ADECC25E4
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:07:46 +0000 (UTC)
X-FDA: 84831522132.15.56BE970
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0250514000F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 14:07:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fwZuGsqW;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780322865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xV5oIFC9FNSfUrc/Tw1WKRTCW2A5//7Qu9iRmyYgTvM=;
	b=e+dQqRV38J6sUgmY3CjbdNJkMuRdP8tCOoEeWILdJrYetoLZvAFYIkQ2fpUjjjdSflJds7
	ClQPGQVIldvWZMtpsLDIvB/VzUUJlCKNzPtnkf99oBaFP4d4mFF2uvmjDfnGzzJ9mmV2si
	/O64ozos1k/yy3XHaF9rfYKXcXa3oFM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fwZuGsqW;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780322865; a=rsa-sha256;
	cv=none;
	b=dlKdAmf2IbXBaRcxRjOqm61yDaxhVFGLyVdzWG9bG8u5iH0F5QF/+w6PjeE/kNJwOFDE9U
	VWSKFLxd7okP1EFl0/t1eU4yXc9MKmnIc6DTrcCUUco+cikJknNiHwMxsFdq8mlKc3SFld
	jk1/D1hIvxxDqwziSqd0GsHqeDpPMMw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5EA64600AA;
	Mon,  1 Jun 2026 14:07:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939081F00893;
	Mon,  1 Jun 2026 14:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780322864;
	bh=xV5oIFC9FNSfUrc/Tw1WKRTCW2A5//7Qu9iRmyYgTvM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fwZuGsqWBa6HD8SGBpxDRBSQcOHZrYGDQmAKJ4dA6W4CsME7Y3sOPejh2PD2bdYMB
	 Np2hqbz4QLVteWzCVcczlkJCyPaSOcJHMz03gaaBqG439JZ9sT3M0wFAtyyu0O5EfF
	 MLww95kfytpWxPtUuFxvIOuBnyW0scY4lVMM3eqokX6tBRhFVyHB2WCjVLx6R1w49n
	 aB4NJH7P/LughfryadrV63GoqDoh96o9LsOLVn1TNLwouHtVilsjDf8EmZEMD5Nh9D
	 P0855nIPngyprB/6KkMmz58FaNV738ca80fE0H0uXDgO90P7jMtyeml8HzRijMkkhi
	 QtXHYjI5Fuxqg==
Date: Mon, 1 Jun 2026 15:07:29 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Nico Pache <npache@redhat.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jack@suse.cz, 
	jackmanb@google.com, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, liam@infradead.org, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
Subject: Re: [PATCH mm-unstable v18 05/14] mm/khugepaged: require
 collapse_huge_page to enter/exit with the lock dropped
Message-ID: <ah2Ro54tMDMsPevk@lucifer>
References: <20260522150009.121603-1-npache@redhat.com>
 <20260522150009.121603-6-npache@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522150009.121603-6-npache@redhat.com>
X-Stat-Signature: qa6crqf1r64rf99rbp1b5cqcofrz1s1q
X-Rspamd-Queue-Id: 0250514000F
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1780322864-545933
X-HE-Meta: U2FsdGVkX1+7950W1bYf4t3yOcWSNqqV5dI1QV7agqXmQOMqTzJXMwaLiOALb/e6p56NBQW/wjR0sGB4CeMu0ZWNMrppXsZTupkyG8f3P0GC8TPc6louhFYbmTp4Jvi6EZdZS8Bgk/HlKTf5befjiUgwJ5axKRgq9ifn7f8OBP04EYwgWjxGwanm1I52GVWtk3Sf7j7FhjlgSfcrhxapoFiC1TyzbcR2KM0JjHCdR29AQdrEDIUXiBp9RfaqLF5gHUUGknPEDbEQGUyaTJlc1wB1j7AUIbvpmccHrHaelYpXvxziJpla1qJjULw7/V8gIfyhn9K4vmcO2F6F2IoG2G/5BMx9iGBcl429T+AXjweBNYRRFryD2QMSBXH5xGMo5+r90kdd8wsUGXUeeUQBpWY+9PTosmHJW38K7kYkVhH1XO7SHNupuF1hkaDUBvGzobvA9o/yRs0b4TF4J3T7wU7MGBYSj1KsXAj867u36BL7IQYYrLiFS/uzxBPDoN8BZ2Ly+Trtvr3WrXroiSp+RjNzml24xuclB3J6k718nOhnnPCrZOgfm1Cn5AUFk1GfB7RsfsfF2hse9IoyKJ4+DzblPJDQ/NF5J6gwtbCV+HsnXwm4KHAz3RUwW7kEcwbfh+j48/qJ7+/ujCmJkrtULddX509zGKyhiRkQMPUNGsr0L3Lls3VU8KG13djTCHbFIxm2esikwIdDOcMWGfakchKpuWfB1jTij7M6ITGt16cP/9SGw4xXTD31rvar88vOEauTtKxH1QZIGsWhPLPABj3M+eD7HVNQp+yVT+yWcwrjnyE1F1VzoB269u+OEEroNt3RfxJ3BGXbMWL2hmF6sVZuoJuFllpVIc0oy1nm/D+0vrdqJ4vI+jjOhkNf/PpvKn1zdBh+OMsewNrqT/9qO2Vc2PJjEeqVCwM4BXpsIFN8vgrgqHCYv9oU4L6EpONS9HkWa3wN+SN8jqAq3kH
 JtxieEH7
 SKVlELk5QW6V6QuiEv8k1YO3+xuUJlzkwvQK42/RjHklHfeQA5LYZ+C5QJyAwGULfBK5RGN6FunvwbJcmbW1BgkJG4FX/RnLoCmfjyRySXw7EmiZQQzGJ6Zct6Zugm2YhhTzOel/EThLq1D9rjiyBd7x5aI6gVPOKZwgiOMCCzPl6PzgzL+d/2kDYF6QBVGyYyLAY9jkIpWL1Fqo9Jo3oru9yQyVmoOS/37+QHraLnyglR7maj2TSzt+noSJ3p1p4MqIFpnyLsfeHYmNJH/E+Onc69DjSYnQuY8ylJXnBlXm2rWWx8EOGRGYG0U1ChRolxS32UlV6JBT4z+MzChPTkaIsKVTur9P6T9XzWWv/VAzvJtiXxpA5q74QEz0Humyji0PTtezSobE6l1u1NbY2u2FBYKBf8dZYvfg7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 09:00:00AM -0600, Nico Pache wrote:
> Currently the collapse_huge_page function requires the mmap_read_lock to
> enter with it held, and exit with it dropped. This function moves the
> unlock into its parent caller, and changes this semantic to requiring it
> to enter/exit with it always unlocked.
>
> In future patches, we need this expectation, as for in mTHP collapse, we
> may have already have dropped the lock, and do not want to conditionally
> check for this by passing through the lock_dropped variable.
>
> No functional change is expected as one of the first things the
> collapse_huge_page function does is drop this lock before allocating the
> hugepage.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache <npache@redhat.com>

One small nit below, otherwise LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/khugepaged.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index e98ba5b15163..fab35d318641 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1208,6 +1208,12 @@ static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_stru
>  	return SCAN_SUCCEED;
>  }
>
> +/*
> + * collapse_huge_page expects the mmap_lock to be unlocked before entering and
> + * will always return with the lock unlocked, to avoid holding the mmap_lock
> + * while allocating a THP, as that could trigger direct reclaim/compaction.
> + * Note that the VMA must be rechecked after grabbing the mmap_lock again.
> + */
>  static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long address,
>  		int referenced, int unmapped, struct collapse_control *cc)
>  {
> @@ -1223,14 +1229,6 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>
>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>
> -	/*
> -	 * Before allocating the hugepage, release the mmap_lock read lock.
> -	 * The allocation can take potentially a long time if it involves
> -	 * sync compaction, and we do not need to hold the mmap_lock during
> -	 * that. We will recheck the vma after taking it again in write mode.
> -	 */
> -	mmap_read_unlock(mm);
> -

NIT: Maybe worth an mmap_assert_locked()?

>  	result = alloc_charge_folio(&folio, mm, cc, HPAGE_PMD_ORDER);
>  	if (result != SCAN_SUCCEED)
>  		goto out_nolock;
> @@ -1535,6 +1533,8 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>  out_unmap:
>  	pte_unmap_unlock(pte, ptl);
>  	if (result == SCAN_SUCCEED) {
> +		/* collapse_huge_page expects the lock to be dropped before calling */
> +		mmap_read_unlock(mm);
>  		result = collapse_huge_page(mm, start_addr, referenced,
>  					    unmapped, cc);
>  		/* collapse_huge_page will return with the mmap_lock released */
> --
> 2.54.0
>

Cheers, Lorenzo

