Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4611BF45A1C
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 05:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A1806B0088; Tue, 14 Apr 2026 01:47:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62ACC6B008A; Tue, 14 Apr 2026 01:47:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2C46B0092; Tue, 14 Apr 2026 01:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1D66B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 01:47:11 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E15621A01CB
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:47:10 +0000 (UTC)
X-FDA: 84656078220.14.043A106
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 104F9180006
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:47:08 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iQBMeGi6;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iQBMeGi6;
	spf=pass (imf16.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776145629; a=rsa-sha256;
	cv=none;
	b=alN+iPO2yjLdhCDyI3TaLtycSrYCnsxIqIzNb7wQ+ZKWPA49uWTDfoZ5fm3ud/wkcfr6jL
	QR/LeSqRCOxc9Z65CFI/Xgei3e+q38/j5LdyusperOUtlA76vow8wYE4X+gJaRqexOmBdy
	8MXEHB6AQ/wZn2J3Yh/aCZnh4Rq6QoQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776145629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmY9ihAtf4ekmMVgXu0dtHQlxfscSPRnYbwyRkb48+U=;
	b=XLUuKAp4Pf6f6OkYwaohbVkD7GhZW0hvwbwAliMfJPOihNAdnN2vi/QYvLg0k26zioLCmG
	COyonrUytGxZHU4vDq7SK7Dc9MWcNQjmNkmfQuzKJAB66JCIkpukx549usBbBGU0bafa5S
	+QIJb8VXHSSeGSA+0xfNEECH+6Eh6L4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3C8BF4EE4;
	Mon, 13 Apr 2026 22:47:02 -0700 (PDT)
Received: from [10.164.148.48] (MacBook-Pro.blr.arm.com [10.164.148.48])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 052E03F7B4;
	Mon, 13 Apr 2026 22:46:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776145627; bh=W5wCrGEAWO8HkuC+xu/FnjB1AdfwSJhUSgv1NRa0lT4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iQBMeGi6YLTp229qB+PhAAChcuBCNiAg0FSXJ5oi3l3Jbh7cM9Szog/JUl5Aw/gV/
	 ANM37lILc0V+iubwGtRf328rlhldqM3Pma5hY2wU6Mbc54BN1XzQohgru0rjn0HCcJ
	 zAyv3x1OBU1F7rr2RGbPG0x6V4Fuh4NXMj5acKII=
Message-ID: <e926fe75-2abe-4665-b433-c0811b422062@arm.com>
Date: Tue, 14 Apr 2026 11:16:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/9] mm/memory: Batch set uffd-wp markers during
 zapping
To: akpm@linux-foundation.org, david@kernel.org, hughd@google.com,
 chrisl@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com,
 qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 riel@surriel.com, harry@kernel.org, jannh@google.com, pfalcato@suse.de,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260410103204.120409-1-dev.jain@arm.com>
 <20260410103204.120409-5-dev.jain@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260410103204.120409-5-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 104F9180006
X-Stat-Signature: noytncxf7gf5wknu4hshzxk3i9zctoio
X-Rspam-User: 
X-HE-Tag: 1776145628-505955
X-HE-Meta: U2FsdGVkX19y2vmAh1hBjxT7LaGRPztoBj3W2FETm8Xr9+zukZ9YuEYTlPmHK0UFdm6Vd0okTB+qU3MaSeO5varY7FcAfIDyWBLsBSP1RI1di89M2khjmoB2BGzvYV5Mh1NOwiCmEPb4DYFTNDASkLk7OGzwCPIWOhYYb4Mkr9DaLSRKpEG7O2anaadjWTfPOAK2aNnGp8A7j/tR+sg/U376fIuGudd4usM+w85LdSZPT9XO/hOpsDljbrezrYu90rat7d6/dC/lZSPaGYDLBMTCdTDWiVBi2XvIPE4QCslI0wPwUVox4zRJkg4+PlaCVklfZaV7+ahsuzXxnHZncTDsdTBCnH5cvQaj+HAy3wpqe52Y26X49O7P3ZlVOa47F9ECF1lgEGvwS9wOxgsS0xl1ZeVs8Eu2xEJUFPVZlqz6V1i7f4egT5B0SYXySW/lCAPzxvZhJ+D1+z2ng19DG7/gcWz1XgC6kzI0OxMzR+xElLaeU60Pok3XcYCxLxBWW55rDf0NZQjGHWh+HvBcohdt8c1eTS76JmhqpabB+EUCvX5DRX8WK3Dg/lAleXkaummNuO0e+juEvmYe27RR4xppNfUXIUq1zOop0k5XpcC93DBSRWnJw5NJiKVwId08EX3j3ci6i2mUP/75/QB9ymG6tJqKG23C2BuBZFntY/P3d3/gEHSRRBRYiIY2KjNOwZ+merkvwoCvfHwadtomsI9PWNfXAtPdUBZHXtHfmTDPc5W02tZWb9pNEzhTfclnm+U5pHRJ5XpAczPWyl6UG12us203m7IFOPpJH2T4yZ0DT6T7KK8y6rUj8VSZ+J48rBlwcp41G/zkqzDBykNWkjA2e23ekKKqvZHqbWohFAaqGmOXiUHSSzcYYv/xW1LJmhG6z1itKBkqKHaydjRg4r60wAsYYiwuxz0fPJam3IaroyqPjDcIngVJacleJ87Wdjskl/MNi/jFLIVIY5v
 BhmQ4lpu
 AeeCdiPUWQmQYS5AwybnbNgGFFo8PxpE3lT0qYfV6BtBYPOaZqycPZ4E/Cpcvg/QKAgpgl0geg1IH0p0/pPRd77R17tX4zFljEOtbsKD1/poVp7ghLJ499i/8A0YNhxpstpEzLaltPikeFmcDH3CKIVtdam33c10T41wOCSIZkv0C6AW8PK54DH+mv9SoJAC8zn8Is0SexLvq00bo91oaAsKbDQcbxYafL5eQTrVv8Ikl0qUg0Y+UOx/3DuK3OCsJuznZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/04/26 4:01 pm, Dev Jain wrote:
> In preparation for the next patch, enable batch setting of uffd-wp ptes.
> 
> The code paths passing nr > 1 to zap_install_uffd_wp_if_needed() produce
> that nr through either folio_pte_batch or swap_pte_batch, guaranteeing that
> all ptes are the same w.r.t belonging to the same type of VMA (anonymous
> or non-anonymous, wp-armed or non-wp-armed), and all being marked with
> uffd-wp or all being not marked.
> 
> Note that we will have to use set_pte_at() in a loop instead of set_ptes()
> since the latter cannot handle present->non-present conversion for
> nr_pages > 1.
> 
> Convert documentation of install_uffd_wp_ptes_if_needed to kerneldoc
> format.
> 
> No functional change is intended.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  include/linux/mm_inline.h | 32 ++++++++++++++++++++------------
>  mm/memory.c               | 20 +-------------------
>  mm/rmap.c                 |  2 +-
>  3 files changed, 22 insertions(+), 32 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index a171070e15f05..20c34d14ad539 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -566,9 +566,17 @@ static inline pte_marker copy_pte_marker(
>  	return dstm;
>  }
>  
> -/*
> - * If this pte is wr-protected by uffd-wp in any form, arm the special pte to
> - * replace a none pte.  NOTE!  This should only be called when *pte is already
> +/**
> + * install_uffd_wp_ptes_if_needed - install uffd-wp marker on PTEs that map
> + *				    consecutive pages of the same large folio.
> + * @vma: The VMA the pages are mapped into.
> + * @addr: Address the first page of this batch is mapped at.
> + * @ptep: Page table pointer for the first entry of this batch.
> + * @pteval: old value of the entry pointed to by ptep.
> + * @nr_ptes: Number of entries to clear (batch size).
> + *
> + * If the ptes were wr-protected by uffd-wp in any form, arm special ptes to
> + * replace none ptes.  NOTE!  This should only be called when *pte is already
>   * cleared so we will never accidentally replace something valuable.  Meanwhile
>   * none pte also means we are not demoting the pte so tlb flushed is not needed.
>   * E.g., when pte cleared the caller should have taken care of the tlb flush.
> @@ -576,11 +584,11 @@ static inline pte_marker copy_pte_marker(
>   * Must be called with pgtable lock held so that no thread will see the none
>   * pte, and if they see it, they'll fault and serialize at the pgtable lock.
>   *
> - * Returns true if an uffd-wp pte was installed, false otherwise.
> + * Returns true if uffd-wp ptes were installed, false otherwise.
>   */
>  static inline bool
> -pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
> -			      pte_t *pte, pte_t pteval)
> +install_uffd_wp_ptes_if_needed(struct vm_area_struct *vma, unsigned long addr,
> +			      pte_t *pte, pte_t pteval, unsigned long nr_ptes)

From Sashiko - kernel doc mismatch. I'll rename pte to ptep.

>  {
>  	bool arm_uffd_pte = false;
>  
> @@ -610,13 +618,13 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
>  	if (unlikely(pte_swp_uffd_wp_any(pteval)))
>  		arm_uffd_pte = true;
>  
> -	if (unlikely(arm_uffd_pte)) {
> -		set_pte_at(vma->vm_mm, addr, pte,
> -			   make_pte_marker(PTE_MARKER_UFFD_WP));
> -		return true;
> -	}
> +	if (likely(!arm_uffd_pte))
> +		return false;
>  
> -	return false;
> +	for (int i = 0; i < nr_ptes; ++i, ++pte, addr += PAGE_SIZE)
> +		set_pte_at(vma->vm_mm, addr, pte, make_pte_marker(PTE_MARKER_UFFD_WP));
> +
> +	return true;
>  }
>  
>  static inline bool vma_has_recency(const struct vm_area_struct *vma)
> diff --git a/mm/memory.c b/mm/memory.c
> index ea65685711311..eef144fa293d4 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1594,29 +1594,11 @@ zap_install_uffd_wp_if_needed(struct vm_area_struct *vma,
>  			      unsigned long addr, pte_t *pte, int nr,
>  			      struct zap_details *details, pte_t pteval)
>  {
> -	bool was_installed = false;
> -
> -	if (!uffd_supports_wp_marker())
> -		return false;
> -
> -	/* Zap on anonymous always means dropping everything */
> -	if (vma_is_anonymous(vma))
> -		return false;
> -
>  	if (zap_drop_markers(details))
>  		return false;
>  
> -	for (;;) {
> -		/* the PFN in the PTE is irrelevant. */
> -		if (pte_install_uffd_wp_if_needed(vma, addr, pte, pteval))
> -			was_installed = true;
> -		if (--nr == 0)
> -			break;
> -		pte++;
> -		addr += PAGE_SIZE;
> -	}
> +	return install_uffd_wp_ptes_if_needed(vma, addr, pte, pteval, nr);
>  
> -	return was_installed;
>  }
>  
>  static __always_inline void zap_present_folio_ptes(struct mmu_gather *tlb,
> diff --git a/mm/rmap.c b/mm/rmap.c
> index fa5d6599dedf0..20e1fb81c33fc 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2263,7 +2263,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>  		 * we may want to replace a none pte with a marker pte if
>  		 * it's file-backed, so we don't lose the tracking info.
>  		 */
> -		pte_install_uffd_wp_if_needed(vma, address, pvmw.pte, pteval);
> +		install_uffd_wp_ptes_if_needed(vma, address, pvmw.pte, pteval, 1);
>  
>  		/* Update high watermark before we lower rss */
>  		update_hiwater_rss(mm);


