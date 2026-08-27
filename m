Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B520C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:05:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B21D6B0092; Thu, 27 Aug 2026 13:05:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 064206B009B; Thu, 27 Aug 2026 13:05:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D7C6B009D; Thu, 27 Aug 2026 13:05:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5DBB6B0092
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:05:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E404F40110
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:05:30 +0000 (UTC)
X-FDA: 85147675620.23.3FA4999
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id EA70414001A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:05:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TACTRK+I;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787850329;
	b=02Jqv4MJ9JgpRQgYg5yaERDDo4Wx2jiCULZeJj0EwkL+K8bFjwZ2HTI7H5Xyt8706ZHJ4W
	SgNIl2CSRKv6AEktoPN8dLSKXo1blIB9CisPTjdGTNHxWq7m+7PX1UtIND11AbHIxgStJP
	8UWXMTOVRiTgUYNtMerz7xmywdxRWl8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TACTRK+I;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787850329;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I1lufsy6Im7NFt6gh/akpxHBSyR/Rxm6eWceVNKlW2g=;
	b=bmC2msxCLMDmcndndi8Qk4NLBbYUjvLTd/hdWMYcKxq9uDZRjP8QBIzbF+2+FGOHqrLLEx
	dxxH9bLjD6FK6vNxXbWiQZtFIhGTHXFitxLxOxZSF75GH1J+SRhN6mwyd6KOyYSryRmTfW
	rjzMxtV1oLr2FgTcXBirOdSp+esbP+E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D752842E18;
	Thu, 27 Aug 2026 17:05:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D953C1F000E9;
	Thu, 27 Aug 2026 17:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787850327;
	bh=I1lufsy6Im7NFt6gh/akpxHBSyR/Rxm6eWceVNKlW2g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TACTRK+IOCMglSMFUPOyndXcTKYnKOgh5FybKkMq9h/FnqoOsf9eibohXzbUoE6kI
	 U+Wk5sA6pKUcf/AmHtw8iWWcCDMPMSjPfikBDWpYsUEFq9xru871uaWIyNMdyfqLxL
	 nku5/C9TzWJM+SzPhRFKwtMfhiOZcK1YDPftnwG6+LxoCw6qRPCkoGAFSuWVSteog3
	 z+C0wenTac1qFktXGT5JHIBRsbhkgCl8tDM/UVsbmEKyMY+rCQOuzfkKdrQd4fPSsq
	 8+0U27G5Mt66hdxlP/t/3pk/MWFCTkUOJNnPZ4QVW+qXaY6FpMnmvrVSkAtyFZE5EM
	 61Sr2IH44g4ug==
Message-ID: <6d855beb-1d24-4a6e-ae62-ac9e05e358e5@kernel.org>
Date: Thu, 27 Aug 2026 19:05:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/mempolicy: use vm_normal_folio_pmd() in
 queue_folios_pmd()
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, liam@infradead.org, ljs@kernel.org,
 vbabka@kernel.org, jannh@google.com, ziy@nvidia.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
 peterx@redhat.com, jgg@ziepe.ca, sashiko-bot <sashiko-bot@kernel.org>,
 stable@vger.kernel.org
References: <20260821144947.167382-1-gourry@gourry.net>
 <20260821144947.167382-2-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260821144947.167382-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 68u8kcmof51mm6uftnferw1zknakamet
X-Rspamd-Queue-Id: EA70414001A
X-Rspamd-Server: rspam06
X-HE-Tag: 1787850328-823417
X-HE-Meta: U2FsdGVkX1+grdByCZjfEltblDeT86EJoWUZp7LrfPiiRqvXTbdwpdrA0oyRKT+v28KDqT2RoG3opMfNSTEudksWR9AHANj+U1B8p+Fc93qnWfPuBgzr9IK7QScl8T9HVd7z/+iD6IYBiuHOxYlMkww2Hnhvmi3dQ2nGbfo+KuBkxK1omghbeeFUnUZcRh5a230WiZ/Uf/8doSIVuq6lpE5M11qTwqq0KWlu5T/PCPq+5JnAKIE1gpN9na4H2qZdX3ZQBFRaXCOXPXZ55yebYCGzeT6KmyCFM0QDP+UmN9FjXkS200zfrz7Nz8O+KC7QyiXyJVrdywGkp7cw2sslS3D8OXotia2+bCGWYQnV0FUOkIQ39WGSsXzUFpS07cYM/IlSkWNxa4S+bN/oOUQN4/WJNazY3a4dj1qHHL7I2DZmA2kKoWxYqplOLG52Mb7gnlNQXeVLX04riVHcsH0UdraAEeasWyqhHPV6NVoXjK6knpQ3bc/DRrvtjFau1Lt/zGlTFBok2doYlMq9BWl78oHzVxG8MfSjhpuLqClEGnh+7FNsKy1PZfL56QhQ0/SsjzYcPvJhUWR65uiGlrauDcPYTNs3yQ0GWpNrdyLNKiBCpDow9cx0j9H1sm/n4wNCO9NJU7LpX0Cfp2CMUwk1tVeVlbD4PFgD+PyOaIlpteJWwuOcRv0lUKIgPhny7CZljA9ukqrMRsdwEtaEuCdq5g1ZZegBa+XPA+PkEKfOgPbc52jgtrWohGvURCP1aeGAqSuUz8T9pUgSlqClHTtV/7sED8mIDzrLRNBdfWra/d/hhkSnuhaCceJoL+MIvWzO5HvXIqSmW+wV1S7L2SXJZUXwu1pKL824x5G5vH+bV9KTQEpL7eL/IDrhF8yH1isTXyOQoxTayphTUl5CxftaBMH5HSfg9JxA0eXB3ILPWGqrzThuXKXxVDW4spsp11jrGKEwg1nU6jyzXzm4yck
 dJl6Qukw
 fOE348GdBOrbHflwt8zX2vo/9chfWuT0sfX2ZYej1RkV53jVwrkS8I5MkoDYo0glmZaIF5mEVSz0zlr+i3Nqg5cDtMfzsTz5qeLM/jmHlvhC90ygcLGcRfjIAouXZsP9diHg8nFpv4yjkVoSSyrMKwn7zZl2dzSSZmVQnnPMVCuTCqzwRlffPKElE276L3oz7cUa/lclyr8Ccsvm0ptRzC5BdrLDeJaSmw9QVjmcPRx7jxiGb5mHQ0IecheVSAmKFGAR8NTGmMFmf2dUuWe/oRoOrRO+w/xHZ4APp0/xtRCmczmA2kXToA3W79VEtmfSDsJI3sW5vuK9zCn3Jxmzel3LBJ9Rm6MiI2tVkj/Q9f8dtv1P+fMzT0aTpg3cA6UIjWg6U5f7/kpAbuhCcjRVTcCIXE4BiE3T1JQVXvX316c29y+mzL3TehiJf42dya/SFCoQNCzQVbXiNweyM02w8r4xBzZ4fVFkhz9/vtz8JGBToahuxDuGbqIHzo881JtPeyCO1Lsmt6u2XaKk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/21/26 16:49, Gregory Price wrote:
> mmap a VM_PFNMAP region whose ->huge_fault installs a PMD through
> vmf_insert_pfn_pmd() - a vfio-pci MMIO BAR does this - then
> 
> 	mbind(p, len, MPOL_BIND, &mask, maxnode, MPOL_MF_STRICT);
> 
> With a stand-in module for the driver:
> 
>   BUG: unable to handle page fault for address: fffff96dc0000008
>   RIP: 0010:queue_folios_pte_range+0xaf/0x440
>    walk_pgd_range+0x52b/0xaf0
>    __walk_page_range+0x6a/0x1d0
>    walk_page_range_mm_unsafe+0x193/0x230
>    queue_pages_range+0x64/0xa0
>    do_mbind+0x25e/0x640
> 
> queue_folios_pmd(), inlined above, calls pmd_folio() on that PMD.  The pfn
> is raw MMIO with no memmap entry, so the folio lands in unpopulated
> vmemmap.  Neither guard stops the walk:
> 
>   walk_page_test()         skips VM_PFNMAP, but queue_pages_walk_ops
>                            supplies ->test_walk, so it never runs
>   queue_pages_test_walk()  honours vma_migratable(), but only while
>                            MPOL_MF_STRICT is clear
> 
> A VM_MIXEDMAP vma needs neither flag, being vma_migratable(), so plain
> mbind(MPOL_MF_MOVE) reaches this too - and there the bad folio carries on
> into migrate_folio_add() and folio_isolate_lru().  mshv_vtl_low is such a
> mapping.
> 
> Use vm_normal_folio_pmd() and skip on NULL, as the PTE loop in
> queue_folios_pte_range() already does with vm_normal_folio().  The huge
> zero PMD moves ahead of the lookup, since vm_normal_folio_pmd() returns
> NULL for it and its ACTION_CONTINUE would be lost.
> 
> mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP region now returns 0
> rather than -EIO.  The PTE loop already returned 0 there.
> 
> Fixes: 3c8e44c9b369 ("mm: mark special bits for huge pfn mappings when inject")
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
> Cc: stable@vger.kernel.org
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  mm/mempolicy.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index f1aba551f9f1..85803c845965 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -650,7 +650,8 @@ static inline bool queue_folio_required(struct folio *folio,
>  	return node_isset(nid, *qp->nmask) == !(flags & MPOL_MF_INVERT);
>  }
>  
> -static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
> +static void queue_folios_pmd(pmd_t *pmd, unsigned long addr,
> +			     struct mm_walk *walk)
>  {
>  	struct folio *folio;
>  	struct queue_pages *qp = walk->private;
> @@ -661,13 +662,15 @@ static void queue_folios_pmd(pmd_t *pmd, struct mm_walk *walk)
>  			qp->nr_failed++;
>  		return;
>  	}
> -	folio = pmd_folio(pmdval);
> -	if (folio_is_zone_device(folio))
> -		return;
> -	if (is_huge_zero_folio(folio)) {
> +	if (is_huge_zero_pmd(pmdval)) {
>  		walk->action = ACTION_CONTINUE;
>  		return;
>  	}
> +	folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
> +	if (!folio)
> +		return


I think this is best written as:

folio = vm_normal_folio_pmd(walk->vma, addr, pmdval);
if (!folio) {
	if (is_huge_zero_pmd(pmdval)) {
		walk->action = ACTION_CONTINUE;
		return;
	}
	return;
}
That way we minimize checks on the expected path.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

