Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E44C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0796B00C2; Mon, 21 Sep 2026 08:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7836B00C3; Mon, 21 Sep 2026 08:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF30F6B00C7; Mon, 21 Sep 2026 08:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AFCE06B00C2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:03:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB1871C0999
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:03:16 +0000 (UTC)
X-FDA: 85237633992.18.B5829F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 02FE140010
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:03:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W2SadKpx;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789992195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mpg5926h34Bs19sqds9l3xd0hZ+AgGPbZWYnHshxVF0=;
	b=zB6kxom0A5emFHWyBWwqda+9APr/JJRHNDv7ugyn77MIMBc8U5gYvJxbOw6MmTlz6Ca3qF
	dYgZhJkppkd8+oLgeRCnsLZuJ7YsUiVAbYDqIq2YltdyVelbZcnUG38F0PI8Je6t0zK6CF
	ozEGBziLDhtcBJmRTVwcUqJe6G9E9+E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789992195;
	b=2lti2R1uCBSeslnmNMjqhdPv7pez4Ab0ERC8D0QkW+jLSYJ/I+RvzYeX4NgbSZEOWa+nzW
	4mlg+S53r/LKRrDhVxVo7vax83PwkPzXAv2GDDRshydZnpPP+eWTbvapA7c0xsjaN4Sq3C
	RxhG42jLB1PrhTmh4bTMZ/UgRwp3n2I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W2SadKpx;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14A714365E;
	Mon, 21 Sep 2026 12:03:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8F71F000FF;
	Mon, 21 Sep 2026 12:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789992194;
	bh=Mpg5926h34Bs19sqds9l3xd0hZ+AgGPbZWYnHshxVF0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W2SadKpxtPg29h2QNCnTPsl4SyrVbj7D+Oz6AkVxLdbBLix4P5XrDQ1/61SoZRycf
	 cnkBq1ZwvbvdlX5wpHNvZjPpMfyJr0V4rsxAatZ3WtDtnfbEvoSiDL9Td28tFOW82f
	 5IRbih1CL6ciudCmxnorWvNWE80UjyKsJ7C2NRK3M/7lV17UZ2xbQA7vIrOye76trs
	 ObdP2NiHPtrqHIvg4KNlfJ8TPEci1JH+iqHdyCJE82LDVmoZBpigwqgpzMbSe0x74J
	 5yDB8pmtBsOEfcgdLWLYyYahKovtwECZQiQMEqIuU0AIpJej4d2qdyMCVuV6nGqh39
	 UzMV0z0hV23NQ==
Date: Mon, 21 Sep 2026 13:03:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] mm: disallow raw PFN mappings of huge/shared
 zeropage
Message-ID: <arEc39hzhJ75v_6D@gremlin>
References: <20260921054225.28537-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260921054225.28537-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 02FE140010
X-Stat-Signature: gs9h4ur6kkd6qht7ossu1wecke4d8jji
X-Rspam-User: 
X-HE-Tag: 1789992194-71536
X-HE-Meta: U2FsdGVkX1/2qumzgl2H4f7UPdDLlNsnby0Kmnn6xVum1V8ZJd3xi0AIaD4WYAZKpKL5KJRI05/wgqZ/M0nuf531mnBGomjUrFCIKaJuF27xZtjqB58G2w9BGkToTeNB96Uzz9/e++znWqQPlL2Pbkfh0cOnNn4iKjfn3DRCLKx14Qt/B9FC3Yv0NRRodCfSfqn/efdiPe6xnYTXb5t5MbYJtih9IF46unPUdxYcssO5ntRtRQi2Lk5GAzz6829W1yk5r15H7m2viTNeg55tBQqm0b0jMe1Vz1lVVSeOAZye1L3jet8A6ASIF4tPpkwyjpnBdj1YJ6AOqrOVmSbwSJ2z2upw80tl//17YLccj8NUBeTSNLGh89OK0rVTIdS5GRwgmb6zSPEQw2mkPZvoGroYtJKLl6fdopKhKqmdDsLG+xkEHQpJ+DSPH+KBiQg5UDap+EJfw1FYHMLziJfUGYM+1uLQ1H9ywtAhtZ5+4s1DufBou26IODE8OHxpcWDdFFYkLC4bt0umm6yjM/DGDgJrEwZP6+3VobUbUynMz3cCMu/6juUGbFY1jtt4hHgUJL8P3qFH7L0/StLPPIhIVXaF5KGJ8/wmcB4gMYIpIDjoxWsKMX+3YUMptWVQytxyAJb8zunvQ42SDVTu6kzD1AkqIXkV2REAUZBiL4Tq39lAO8ZEfNFIlbKdD2XEO05I4UVyuVDgZOWuHyX8fibywBuAMoWldFxagxpHAU9gCvgDbpTl6dsLKvri7eeNN8ZQkFdO3wDEaNtcQra2pahl6NfuXgQq8b4X+1ZnJeCnA6/3qzLbzKUX36cxnM3c2IxQq6bQj043lnI0DLKikPETDEgnaHFig8yIb6cm+SfOgRnCXM+mwUaFi2GoImd25XNSLVKDnzWtbV6lwDYu2GfYzebJU8wVpK8ayUvrTInofofsuNfNvyVoFT1cntxvp72UEaRMJzvyL/8XiYc8ZN8
 1sXKnwPH
 PvqwZJk9ZpqjsFfjKv85NjZPPkBAzk+bvEP1t96m/7nlLpy3Q3ibgCMS5sYOSid+R5LmhQbcvlGhPghTEHezLe3OhkNigiAi2ciZpXRWdjicYOYeSERbzNRyAVk8RaPqXUb3wqsCqOjmVD/rhyGT9ygpjSprFE1DNH7+xhl5WJU7Knse1xlHKvU3tIUxhRS90jR8YD+ikG0cdI/SaiNfoT4i1KzNvEI0p1vXxubs6xx4HgXV9JJr1MYEyyHNvAlv4AKLXvOHHmmYtEGsop7hI+NffWnlyt/Lr0wv/C7tQIIHVfrXdNE5FsbrQRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 01:42:25PM +0800, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> Handling the huge/shared zeropage correctly in vmf_insert_pfn_pmd() and
> vmf_insert_pfn_prot() is more involved. We would need to check whether the
> VMA allows it and keep the mapping read-only, similar to the checks in
> vm_mixed_ok().
>
> No in-tree user needs that support, so reject these mappings with
> VM_FAULT_SIGBUS rather than complicate the code for now.
>
> Link: https://lore.kernel.org/all/20260917121010.60966-1-lance.yang@linux.dev/
> Suggested-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

Seems sensible to me!

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> v1 -> v2:
>  - Reject the shared zeropage in vmf_insert_pfn_prot() (per Kiryl) - thanks!
>  - Explain the VMA validation and read-only requirements (per David) - thanks!
>  - Pick up Kiryl's Reviewed-by tag.
>  - https://lore.kernel.org/all/20260917121010.60966-1-lance.yang@linux.dev/
>
>  mm/huge_memory.c | 3 +++
>  mm/memory.c      | 3 +++
>  2 files changed, 6 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8aa2daba3739..1d4fe4452c98 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1728,6 +1728,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
>  						(VM_PFNMAP|VM_MIXEDMAP));
>  	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
>
> +	if (unlikely(is_huge_zero_pfn(pfn)))
> +		return VM_FAULT_SIGBUS;
> +
>  	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
>
>  	return insert_pmd(vma, addr, vmf->pmd, fop, pgprot, write);
> diff --git a/mm/memory.c b/mm/memory.c
> index 926276d41920..7d821b110df0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2860,6 +2860,9 @@ vm_fault_t vmf_insert_pfn_prot(struct vm_area_struct *vma, unsigned long addr,
>  	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
>  	BUG_ON((vma->vm_flags & VM_MIXEDMAP) && pfn_valid(pfn));
>
> +	if (unlikely(is_zero_pfn(pfn)))
> +		return VM_FAULT_SIGBUS;
> +
>  	if (addr < vma->vm_start || addr >= vma->vm_end)
>  		return VM_FAULT_SIGBUS;
>
> --
> 2.49.0

--
Cheers, Lorenzo

