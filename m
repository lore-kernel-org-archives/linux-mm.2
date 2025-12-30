Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11986EE49B4
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 20:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71B136B0089; Tue, 30 Dec 2025 15:34:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C6526B008A; Tue, 30 Dec 2025 15:34:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FF616B008C; Tue, 30 Dec 2025 15:34:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 505ED6B0089
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 15:34:05 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A3821A02D6
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:34:05 +0000 (UTC)
X-FDA: 84277289250.02.DA01138
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C069A0012
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 20:34:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PrAmyVvE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767126843; a=rsa-sha256;
	cv=none;
	b=MJ3ffsjfwKmPYIr25PjL1F6kuwUzR1REsi2WxgD/OWziUcJeVJxc8VoSUXjMv+JmULBPm+
	ghYfqWfoaVo/FnhyKNl6G/WcEQqXiE+FGimJG2XPF7TdRLknqbOC5abHzqQLDI8gCKPFnr
	MkKgVN4Yr+S20d20+jgBA9wNwKAVL1o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PrAmyVvE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767126843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vd5GVVA+b01dqeU3K3JWb3U+hMT3fCcsxq5twwrCu0E=;
	b=4drt3EUX/L4uG4iyBNJNBhl7BDAVvQmBDMnbTx7rogVha4LYjBRTJk+DnkGy99YB3WaldF
	pa54X6IQHBvcKaeERgK09T3eUtBPLzKIt6scjxtk9tMkeWiV1AByUl+RxbExkyBPbyOtkz
	ZzZ12+bVLtsECIZXWcu23+VRbLBOva4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E2DA60017;
	Tue, 30 Dec 2025 20:34:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E9BC4CEFB;
	Tue, 30 Dec 2025 20:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767126842;
	bh=4IHtShbZ7SkTOAYLBZj9TSKXtSMlwo4nI5tswNsLZWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PrAmyVvEnpZ4yRI0wUa+185Y7q0FM/Tw3glVvKO5aACCa44jDc+P3QXzXw4+OfTfo
	 gOr9uPnI9cTfK7MH1w1F81H84Ygc0l7FXK2cLSASh6Q2r8VSoz07W59zj3BUPoCN2D
	 BPalls68LBODQR68nQJuK+fPOz9D9ZAuJKLlPwctvqVEefMmhTueXozTyHCpOMRbQz
	 NqXfiidlc2SnQsUfOKDlVwSYUVdhxWXlrSkUjpKnT/GMUcIPbYL/lbgpXZ6188Gs8G
	 nMoCTTrrsk7d+STX9wdSJ7qliax3KSJGjlULX2X/L8zszSXrBY+P4cg+HUh1eMVQzC
	 k4LOD1usLY82A==
Message-ID: <f4d5548d-6045-47a3-b233-0a67702bb477@kernel.org>
Date: Tue, 30 Dec 2025 21:33:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] mm: embed TLB flush IPI check in
 tlb_remove_table_sync_one()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com, arnd@arndb.de,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
 shy828301@gmail.com, riel@surriel.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20251229145245.85452-1-lance.yang@linux.dev>
 <20251229145245.85452-4-lance.yang@linux.dev>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251229145245.85452-4-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C069A0012
X-Stat-Signature: ugsd1ru3erczt6hdfk3kyaa39p8316jo
X-HE-Tag: 1767126843-999716
X-HE-Meta: U2FsdGVkX1+GZK7XzCwx2Qk3M/fHWB6ugvqP1M7E6WQndEu5QhiZKb6CF9ETWd9AvRer5k9BXRkuRWaMWgqTJDS+siXsqMcJCC9cQ8wItPlB3p+AtvHaidTO5E+q1KvqIXTBqtwPHhNBuukRHoDKCLaqAzJNlQNKZN4xtrj3vNOjRyT3XLAFfa3r+wJFeXV3xmZzpoJZtviIPOfXlaVO2qpoJXvQPMcq5EV5vG9eND8lcvYi6sdE5BwpUC4eR9HJA0OaP6EGbxxWnPlfnveDXAlfYhLiz00XRz3xqAvwawlUeW27ua7AF65pDnLrINKqfWbBA1ldZJGWRcWrnASNhZmed4x06mjf82U429DsArWZuTui05EQ8dP6qhAIc7UKxH6/HoaKmJFnSn9Bxpk5+aUMZq04OULirpYHstnxjed9qkcolc4zqLqSGV8rrirdQLljG8rlUsR/CQUalKsK/KJgO5zIRNyvdKEusurHLhpVJtpWKFRZhCJp7uA6aD5t8tJaqszz8FdU0L5gUmx66EdMyAEDxS8HcJnsQyzp2CDE5N00iCjZOefd8nRvrNJWpAt5HsIiDd9t11bh+qIqgjyiDi2xZYKF5fGwa2v9qtsu0rxtTharm7Uf/fXCA7ZAouJ+1hICzo8h73//h339aERLX00/0MJFQIBW8ZxW3dntwIRe5FVvuZ4RptNM+6t5SyAHjPNAvfU4N2fO5dOfB3t5VuaAzmNpUokYOBhSnYuGhKhMinD+ptfy2sSEK1zpdOiAGkIcwV3F3DRnY6E1QFAN40+d3G7MN6lU1u72bGv+HMKJxc/ae+kvD2542FBAFQ3rxqVfuQ7y6c+bIzkagxkJ++kpbxVWAfzZfxGliIC4i6ms8I+UmQnbBhHlcNurfJrVKcxk669SO03Dvdyq8WOTuwQxbEIu4Ft/eYh+8rKpJ5Gx6e5tzSHxD+b9dNS1zu3rnxpIgxhw8OH19cQ
 EKHblqwm
 k/6LOgHhDHMSrFhNvznTaGE+nVtlZBLerGipnTiqH4F0dEhHhR9LQJoRvkovryn/zSMEuxa61J+DKDEuGgoYuRn1H7PjPOVJ6+vW6u7hqw37Fa+OnYCdgH1tVdwPewEQhYBtdAq8EYRIuemx0WzzbsPl9cXJBsGY/NsB4YX5BparfdBG+g5ebIXv76m/E32ng+rADKu3OWDQGEZt+YrHm6y1okrgdt6m4UAxR227mlUQx/DW05B0q7rYgiPYru0Xgv1/EFEisquUmDJ8z1vXj1fJ+s0Z6PAE8AvLB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/29/25 15:52, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Embed the tlb_table_flush_implies_ipi_broadcast() check directly inside
> tlb_remove_table_sync_one() instead of requiring every caller to check
> it explicitly. This relies on callers to do the right thing: flush with
> freed_tables=true or unshared_tables=true beforehand.
> 
> All existing callers satisfy this requirement:
> 
> 1. mm/khugepaged.c:1188 (collapse_huge_page):
> 
>     pmdp_collapse_flush(vma, address, pmd)
>     -> flush_tlb_range(vma, address, address + HPAGE_PMD_SIZE)
>        -> flush_tlb_mm_range(mm, ..., freed_tables = true)
>           -> flush_tlb_multi(mm_cpumask(mm), info)
> 
>     So freed_tables=true before calling tlb_remove_table_sync_one().
> 
> 2. include/asm-generic/tlb.h:861 (tlb_flush_unshared_tables):
> 
>     tlb_flush_mmu_tlbonly(tlb)
>     -> tlb_flush(tlb)
>        -> flush_tlb_mm_range(mm, ..., unshared_tables = true)
>           -> flush_tlb_multi(mm_cpumask(mm), info)
> 
>     unshared_tables=true (equivalent to freed_tables for sending IPIs).
> 
> 3. mm/mmu_gather.c:341 (__tlb_remove_table_one):
> 
>     When we can't allocate a batch page in tlb_remove_table(), we do:
> 
>     tlb_table_invalidate(tlb)
>     -> tlb_flush_mmu_tlbonly(tlb)
>        -> flush_tlb_mm_range(mm, ..., freed_tables = true)
>           -> flush_tlb_multi(mm_cpumask(mm), info)
> 
>     Then:
>     tlb_remove_table_one(table)
>     -> __tlb_remove_table_one(table) // if !CONFIG_PT_RECLAIM
>        -> tlb_remove_table_sync_one()
> 
>     freed_tables=true, and this should work too.
> 
>     Why is tlb->freed_tables guaranteed? Because callers like
>     pte_free_tlb() (via free_pte_range) set freed_tables=true before
>     calling __pte_free_tlb(), which then calls tlb_remove_table().
>     We cannot free page tables without freed_tables=true.
> 
>     Note that tlb_remove_table_sync_one() was a NOP on bare metal x86
>     (CONFIG_MMU_GATHER_RCU_TABLE_FREE=n) before commit a37259732a7d
>     ("x86/mm: Make MMU_GATHER_RCU_TABLE_FREE unconditional").
> 
> 4-5. mm/khugepaged.c:1683,1819 (pmdp_get_lockless_sync macro):
> 
>     Same as #1. These also use pmdp_collapse_flush() beforehand.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>

LGTM. I think we should document that somewhere. Can we add some 
kerneldoc for tlb_remove_table_sync_one() where we document that it 
doesn't to any sync if a previous TLB flush when removing/unsharing page 
tables would have already performed an IPI?

> ---
>   mm/mmu_gather.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
> index 7468ec388455..7b588643cbae 100644
> --- a/mm/mmu_gather.c
> +++ b/mm/mmu_gather.c
> @@ -276,6 +276,10 @@ static void tlb_remove_table_smp_sync(void *arg)
>   
>   void tlb_remove_table_sync_one(void)
>   {
> +	/* Skip the IPI if the TLB flush already synchronized with other CPUs. */
> +	if (tlb_table_flush_implies_ipi_broadcast())
> +		return;
> +
>   	/*
>   	 * This isn't an RCU grace period and hence the page-tables cannot be
>   	 * assumed to be actually RCU-freed.


-- 
Cheers

David

