Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5301FD8FC3
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 15:17:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC27D6B00C2; Thu, 26 Feb 2026 10:17:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E90796B00C3; Thu, 26 Feb 2026 10:17:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD0E6B00C4; Thu, 26 Feb 2026 10:17:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC1706B00C2
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 10:17:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 701E2B72E4
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:17:39 +0000 (UTC)
X-FDA: 84486962238.19.68D7F71
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 91A2D100005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:17:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mvqsq0kU;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772119057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9IVuzAh8l8k2Ho42HZeAf1DAkI7UJxrVDY6waCJOU7o=;
	b=sX0SBb412EyRh3TijyzjeVORh05ruWROGjC2p86sl4pC9jCH68N+VsHguNOPHkJyl/mUeR
	TRxzo77uP/j7zyjQBbIefi7rKulHQkJh4rosdBog4MksWW+ypRZ7r7mBbsJUFEFN/82LmG
	hfC3PvxC7X5UsRo0ZHsU3Z8NeleORR0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772119057; a=rsa-sha256;
	cv=none;
	b=m2cVLNng4B6MPdkGO8jordzBpjyZcByOMVAoOxRt0R54qZvonu9bs1ECAO/CTclwyvtyfj
	TMsaHIa53+L4IPCJJhcNmk6Mx80fBpZfmjgq/coMF+uII0CNV6u72M7LMaPaUJmptQkW2u
	Z+E27ZSyxnihXpj59ubpoNxwPUtHcAI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mvqsq0kU;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A8DF44401C;
	Thu, 26 Feb 2026 15:17:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A073DC116C6;
	Thu, 26 Feb 2026 15:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772119056;
	bh=aLGd9kkNNgUcYFmtIiy7QnU197IGoyxW/VYrnzMnoP0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mvqsq0kUH13XZgmV8wElxnONJYeKXRqcfRRtYItlQjBVZKxpIE/dc+ITxNhd6S1p3
	 T2AjMG/TXthk8J2aulk2q2MatA2xW+lUiBrhq/dJfzPp0Tvh1M45a6xqx+nCoimZB8
	 Pa2p1cUOqejG1LVB6MWXxv7ibGazvHkWUonN7OkkMkvDkN7+rPQj7hKLdKOjCbSJgJ
	 Qs3pYm9sEqtL0C1RQDAZtPzelk+G+G4c8UXhxne2nTIChYjR15eVMDKR1l7R9/JRD3
	 WkhmvwuAcYqgQkKVomgYxqh5obrOaPBcUtP6Y0HGiJQzdwcykcopRA2JFm+oEdE2Gg
	 4xNbTcjO4nhSQ==
Message-ID: <6147cf80-9d02-4c5c-ab81-8cb9b00044f0@kernel.org>
Date: Thu, 26 Feb 2026 16:17:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/huge_memory: Prevent huge zeropage refcount
 corruption in PMD move
To: Chris Down <chris@chrisdown.name>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, kernel-team@fb.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <aaBVz7eb6-VBCvaz@chrisdown.name>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aaBVz7eb6-VBCvaz@chrisdown.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 91A2D100005
X-Stat-Signature: ff7hmkmjxgm1upjz35jkzywprg5w781y
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772119057-361383
X-HE-Meta: U2FsdGVkX19HOzFD4FExVZ4jDBJZcroBokAIDe/gE8RKfhX1KRyt/NoEDyssDt+HyGeDrWzAVRER3oDBojYs8ve0Rvv3nTkBajnuyWCCpdk8F7m15X5Qbx0aspQH6kPIVFQ3ouo/4dtctoF7Dagz2yO3STaTtWE28lZ41cPWVNybT82xXrnNdirXSP09RqrfwmVYjwmOzRhcOhi5d4swoiQFb3Vsqz1D65Xf4q9YYzTGfeJEeu34sWg4ONW97OW+14uSMcFCds2f+TyrAwZPUNfg03XfdqL07HsEWAUCCmvUtNC2l2kpSw8BbC5wL7byFb//IOK4Yik5dZqGIPAxyv5javgsy8mpC/5N6aOZCmYLcKsBl+a0R9qaw9Ch/7zcCd8/cOZu1duj8ssrVR/O7bvoR/KITqMwatPwL2rkKXVOugMF+Ft+FPCnwfAIWMLiQ2D/7sp1we2t+zSCJC+yfZzD7TYalGrg1EYLn2A1l7umC8fuSYx/sL/ZtPCxnWVt/1Vg0N4/uuGGe4RyoiP2Ibj4Hnh5DoXoTy/Q4IyIN1TrwKwQhvSZ4BpF02O/yv9Qf41kJCJwkTnuxpWoWxjtDGXr8IB1OUiEKcCBYLqklPOhBU64k7w2JXHqGM3tt7AF+SEc7/5HZUE33C5enPjS7iVi1UYoirjSoMsIsfQweXYPtFnpvRycJOKAwauo+t9Fv60QHjktPps2CW5mt++UbwtIrq3xxIWOXgWF+6F4c+8ywKKT9vCaKxm+yiB5xpuNEaC0GBcL4ypB1y0++EuIedLkSSSOIQbV6ilF099d14hl0IGgvSZCrOIzeuRkDd3CC3BTJ8FNdbpvJlPHLMeuRqPi9JmVEksAwmoZWK0LGS0kvBnal/9yhwVi1/NJSVmOZ0x11kR1ppI/uUlAzQ8dq+Vyb3C7XKPFiqwd3TY55bl8qkeyFOWPWXeqUOem77NplNtL9lHn4rwGKfyaThw
 +qsPphPK
 SDVUY+kv1AVpqb0Ed4/dw8gJVDt1BQ0OpHwAcL6BKhWHfnquu+u7JTJlvIjw6pSYUtxummS0mRCJ0cOhATamYJukDRa/Bc+RCwK1foSY6NRfUAQ368S/fjexdL8nPdolNCmJZkK+gbi2K6slDvV45/suzjalKtlMRVtDeBvYH+H+Peceipcal3rcUyWuFP2lWJDFFDx1ZNC8Emu1xBVk5LN7Ptr6yjb+8fTahHadC+PxW+n5KtAfhgZqTjJkHfHwszxxl+RbC3TVZSMvDw0JKrBy3a+/06V8s7IxyDj8Itra0P1R/8xOABoodOX7jKfEdbHD1CE3OqDUXGDY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/26/26 15:16, Chris Down wrote:
> After commit d82d09e48219 ("mm/huge_memory: mark PMD mappings of the
> huge zero folio special"), moved huge zero PMDs must remain special so
> vm_normal_page_pmd() continues to treat them as special mappings.
> 
> move_pages_huge_pmd() currently reconstructs the destination PMD in the
> huge zero page branch, which drops PMD state such as pmd_special() on
> architectures with CONFIG_ARCH_HAS_PTE_SPECIAL. As a result,
> vm_normal_page_pmd() can treat the moved huge zero PMD as a normal page
> and corrupt its refcount.
> 
> Instead of reconstructing the PMD from the folio, derive the destination
> entry from src_pmdval after pmdp_huge_clear_flush(), then handle the PMD
> metadata the same way move_huge_pmd() does for moved entries by marking
> it soft-dirty and clearing uffd-wp.
> 
> Fixes: d82d09e48219 ("mm/huge_memory: mark PMD mappings of the huge zero folio special")
> Cc: stable@vger.kernel.org
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  mm/huge_memory.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index fed57951a7cd..8166b5e871ad 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2794,7 +2794,8 @@ int move_pages_huge_pmd(struct mm_struct *mm, pmd_t *dst_pmd, pmd_t *src_pmd, pm
>  		_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);
>  	} else {
>  		src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
> -		_dst_pmd = folio_mk_pmd(page_folio(src_page), dst_vma->vm_page_prot);
> +		_dst_pmd = move_soft_dirty_pmd(src_pmdval);
> +		_dst_pmd = clear_uffd_wp_pmd(_dst_pmd);

Please squash that patch directly in #1.

It doesn't make sense to leave something partially fixed in #1. It's
been completely broken from the start. folio_mk_pmd() should never have
been used.

Apart from that, the end results LGTM, thanks

-- 
Cheers,

David

