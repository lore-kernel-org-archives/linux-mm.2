Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17E91C5DF70
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 10:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38336B0251; Tue, 18 Aug 2026 06:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0FAC6B026A; Tue, 18 Aug 2026 06:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C9F6B026C; Tue, 18 Aug 2026 06:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBBAA6B0251
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 06:51:21 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4017940BB8
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:51:21 +0000 (UTC)
X-FDA: 85114073562.12.FCC33B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8A3D44000A
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 10:51:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IU7ibEVD;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787050279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/r1q9aoLnp9aEHT/nQ5T+KzdqplXpUML9DRN9EYw2k=;
	b=U3lqSoo5K4LmJJPllPKymXXfl6CJ/6q8Zu2ecLRmf2PMUZoBiJ4K6PEQKixqXHJN0MZm3g
	UgFWPJFmCZpcOlNx5LFhjMYdtIj9WAglVS/c4RtxP7tY8e4krgDbhDV4cn50ZNKZk/Clt4
	US3QvkePD7ULfnlUwTG4vQRT8bn4URg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787050279;
	b=vE3VIDjwGakKpbcMvA4jGgqFw8P2c19sgXcxhdPrGgHLDHrb0d+Z5gY68v7gthP+onafQF
	Yx0ZMa9rSZI4wxOdiEPhFt1uJb+Fq4fRvjOIycCLpVoAogKPYo7SIv9FUR033aBAJ2r/7s
	FWw/8Y0+uC7a8+ONfiaGFGeS43xMr2M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IU7ibEVD;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A38BA43494;
	Tue, 18 Aug 2026 10:51:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA2881F000E9;
	Tue, 18 Aug 2026 10:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787050278;
	bh=v/r1q9aoLnp9aEHT/nQ5T+KzdqplXpUML9DRN9EYw2k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IU7ibEVDFlaLQyDaxdtw1Xdg2N0NmY3zns0fCrt1pYivktpYFzSGfPIrf4nNS1Uxj
	 pRDOrF5Wx6cPpExqhlrekUj+Yk0kVSx2C11adSZ8cnMXBVWBVJp3QixWTIduhFMvXM
	 QgsvQKgbYdyad5eJFj8jwLE6q4ynkJMF1klnfWiBqNG4NZT/nXzOKZIY2A+bfn6PUJ
	 Trb8q7pWfh6+cDPqV36MZEoh5mcN5a4gIdvtu5GBgljQy4aNnSBjz4W81BRVxLmDYl
	 lQG9WJZ9m2GDsey/X1jtdWlw5KKT8pF3mDouKTTR+75U/nmNHBcMzFYMZb61IqmEBf
	 RiLF5HUPxfVJQ==
Date: Tue, 18 Aug 2026 11:50:55 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: akpm@linux-foundation.org, david@kernel.org, nico.pache@linux.dev, 
	baolin.wang@linux.alibaba.com, baohua@kernel.org, dev.jain@arm.com, hughd@google.com, 
	lance.yang@linux.dev, liam@infradead.org, mhocko@suse.com, rppt@kernel.org, 
	ryan.roberts@arm.com, shuah@kernel.org, surenb@google.com, usama.arif@linux.dev, 
	vbabka@kernel.org, ziy@nvidia.com, usama.anjum@arm.com, agordeev@linux.ibm.com, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kas@kernel.org, jannh@google.com, willy@infradead.org, pfalcato@suse.de, 
	rostedt@goodmis.org, mhiramat@kernel.org, linux-trace-kernel@vger.kernel.org, 
	bpf@vger.kernel.org
Subject: Re: [RFC PATCH 03/57] mm/collapse: add collapse.h for the shared
 collapse state
Message-ID: <aoQ47NMwUddi8h1M@lucifer>
References: <20260816224609.308019-1-kirill@shutemov.name>
 <20260816224609.308019-4-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816224609.308019-4-kirill@shutemov.name>
X-Rspam-User: 
X-Stat-Signature: ur8hfct8rcooqs9knaqh59y73iqcajhz
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8A3D44000A
X-HE-Tag: 1787050279-432166
X-HE-Meta: U2FsdGVkX1+w3Q5VbyKpLEnsUE9pi0erwi8KtUBeTxBgrmD7VG95dBhE5Z+gARYeQ9ZQz2Us3rOyyCoyEc837yCLBpndXgN5LlTUtPYGO1yBNNDkd/eFVmruSxzMkXFSNI4GqHBtPARr5LxX28UMPMbYSUMcdFpbyFn+CjEY82+llPm0GRae8ETcDUS3IgXAb7GF4JKL+BdN5EbqiXnPjxn8hgi4mhWSE7pIIrB+5zns+Kcy4kmz8Rph161+MUcCttOziL1OOjLkTM1LG/UYgZHlQYPtyYLAk4D6mTzcyAtjiuKPbbv/E7tr/o5BZHX1iFr7DvXGrTdlkPR0ts0XkmBEGo0a6yqO+xw9Gij2JMp8se/QYSxpK8sJEaYxY4p+IBXm/ruYAmV33h9eT2bV011vA+C4yMMsqt4T6bCGVr2CbDVWO2CGMKwbm8RLb6SwfBJrG2GQMYeiw2YqqJ/hDPppljZKBxSuqOF32GCVIjKJ0rX0DPkenMM+jjE4qbWf3jBRtYtFlzIZUI0fJuYaqwpC3HzBsQx5+gV/4CsUbp5kYDzppgtRaBfaYmwUUXxXrVBDO36smS61JigekXRmnpWw/4aepU4UpfGEs3dOTfVT1K7qBEdxNryFt5e4xK0sJ5LjP17hlgmXP2SUMyixd+aUUMFEF0Q1Mdb1RpHyJGgt6rCX3OWAI0D6eHZAWGlQ1EPMz1IvgZnFPuKIiYdHo9Se5d81wiHnze3TlngIgeKHcWi5CxI/gOBcswlfijvQurFf/j/C2+/mjIZo6vMNFn4qFbqGNRkUTeT2rAC4SCck71zZh7OHSJX5/WFtX8IVpaufpFd9cusHIHIFAld1Re9kATbClfVk8qD1IKopZONCXnuTmAqTsJqjMdhgXLX+Z3zrupm7nRoBM8b6NxJ99CeOqLHC6PG5b+YN+Yf6rdl5D3HEDu/I8RH9k4JvVfn3Ozf6mpGSG9PxElKRIH0
 NFxuDaFF
 76FWLNZo+mgH47B3St6Nnhep2bEDVluyaJbbD9Cfm8Kw1yYqTy54Xas++KTfbJK0h32GazLRhImU6OtsAxv5PLX92aalcNmVQAH5XVwX3Xh063GkHbb30XkAAKnWuMDsE17BNeyGIAYFJsYWwT8RKfC3NTv5VQixMMg9ebFoeIIztvf1DnHr2QLqVxIw7md2hvzuLdLA9Veukjh3VkmhvPzPSV0TM+vjKDa+jDfCISTHU+w46t/bauaIR9xL2keTr1gNDt5YPXb8N9AhfSrPKK4agBxAXYSFuN2vH3oGWc+DhGRuUmQocMLpWUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 11:45:15PM +0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>
> Preparation for building the new collapse engine in its own file.  The
> engine and khugepaged.c need to agree on what a collapse result is and
> what state a scan carries.
>
> Move enum scan_result and struct collapse_control into a new
> mm/collapse.h.
>
> No functional change intended.
>
> Assisted-by: Claude-Code:claude-opus-5
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Any change that introduces a new file should in the same change update
MAINTAINERS (in the THP section to which this belongs :)

> ---
>  mm/collapse.h   | 60 +++++++++++++++++++++++++++++++++++++++++++++++++
>  mm/khugepaged.c | 52 +-----------------------------------------
>  2 files changed, 61 insertions(+), 51 deletions(-)
>  create mode 100644 mm/collapse.h
>
> diff --git a/mm/collapse.h b/mm/collapse.h
> new file mode 100644
> index 000000000000..26dbac7beddd
> --- /dev/null
> +++ b/mm/collapse.h
> @@ -0,0 +1,60 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef __MM_COLLAPSE_H
> +#define __MM_COLLAPSE_H
> +
> +#include <linux/nodemask.h>
> +#include <linux/pgtable.h>
> +#include <linux/types.h>
> +
> +enum scan_result {
> +	SCAN_FAIL,
> +	SCAN_SUCCEED,
> +	SCAN_NO_PTE_TABLE,
> +	SCAN_PMD_MAPPED,
> +	SCAN_EXCEED_NONE_PTE,
> +	SCAN_EXCEED_SWAP_PTE,
> +	SCAN_EXCEED_SHARED_PTE,
> +	SCAN_PTE_NON_PRESENT,
> +	SCAN_PTE_UFFD,
> +	SCAN_PTE_MAPPED_HUGEPAGE,
> +	SCAN_LACK_REFERENCED_PAGE,
> +	SCAN_PAGE_NULL,
> +	SCAN_SCAN_ABORT,
> +	SCAN_PAGE_COUNT,
> +	SCAN_PAGE_LRU,
> +	SCAN_PAGE_LOCK,
> +	SCAN_PAGE_ANON,
> +	SCAN_PAGE_LAZYFREE,
> +	SCAN_PAGE_COMPOUND,
> +	SCAN_ANY_PROCESS,
> +	SCAN_VMA_NULL,
> +	SCAN_VMA_CHECK,
> +	SCAN_ADDRESS_RANGE,
> +	SCAN_DEL_PAGE_LRU,
> +	SCAN_ALLOC_HUGE_PAGE_FAIL,
> +	SCAN_CGROUP_CHARGE_FAIL,
> +	SCAN_TRUNCATED,
> +	SCAN_PAGE_HAS_PRIVATE,
> +	SCAN_STORE_FAILED,
> +	SCAN_COPY_MC,
> +	SCAN_PAGE_FILLED,
> +	SCAN_PAGE_DIRTY_OR_WRITEBACK,
> +};
> +
> +struct collapse_control {
> +	bool is_khugepaged;
> +
> +	/* Num pages scanned per node */
> +	u32 node_load[MAX_NUMNODES];
> +
> +	/* Num pages scanned (see khugepaged_pages_to_scan) */
> +	unsigned int progress;
> +
> +	/* nodemask for allocation fallback */
> +	nodemask_t alloc_nmask;
> +
> +	/* Each bit represents a single occupied (!none/zero) page. */
> +	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
> +};
> +
> +#endif	/* __MM_COLLAPSE_H */
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5f7126cf42f5..804b1d35f52a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -26,45 +26,11 @@
>  #include <linux/cleanup.h>
>
>  #include <asm/tlb.h>
> +#include "collapse.h"
>  #include "internal.h"
>  #include "page_alloc.h"
>  #include "mm_slot.h"
>
> -enum scan_result {
> -	SCAN_FAIL,
> -	SCAN_SUCCEED,
> -	SCAN_NO_PTE_TABLE,
> -	SCAN_PMD_MAPPED,
> -	SCAN_EXCEED_NONE_PTE,
> -	SCAN_EXCEED_SWAP_PTE,
> -	SCAN_EXCEED_SHARED_PTE,
> -	SCAN_PTE_NON_PRESENT,
> -	SCAN_PTE_UFFD,
> -	SCAN_PTE_MAPPED_HUGEPAGE,
> -	SCAN_LACK_REFERENCED_PAGE,
> -	SCAN_PAGE_NULL,
> -	SCAN_SCAN_ABORT,
> -	SCAN_PAGE_COUNT,
> -	SCAN_PAGE_LRU,
> -	SCAN_PAGE_LOCK,
> -	SCAN_PAGE_ANON,
> -	SCAN_PAGE_LAZYFREE,
> -	SCAN_PAGE_COMPOUND,
> -	SCAN_ANY_PROCESS,
> -	SCAN_VMA_NULL,
> -	SCAN_VMA_CHECK,
> -	SCAN_ADDRESS_RANGE,
> -	SCAN_DEL_PAGE_LRU,
> -	SCAN_ALLOC_HUGE_PAGE_FAIL,
> -	SCAN_CGROUP_CHARGE_FAIL,
> -	SCAN_TRUNCATED,
> -	SCAN_PAGE_HAS_PRIVATE,
> -	SCAN_STORE_FAILED,
> -	SCAN_COPY_MC,
> -	SCAN_PAGE_FILLED,
> -	SCAN_PAGE_DIRTY_OR_WRITEBACK,
> -};
> -
>  #define CREATE_TRACE_POINTS
>  #include <trace/events/huge_memory.h>
>
> @@ -103,22 +69,6 @@ static struct kmem_cache *mm_slot_cache __ro_after_init;
>
>  #define KHUGEPAGED_MIN_MTHP_ORDER	2
>
> -struct collapse_control {
> -	bool is_khugepaged;
> -
> -	/* Num pages scanned per node */
> -	u32 node_load[MAX_NUMNODES];
> -
> -	/* Num pages scanned (see khugepaged_pages_to_scan) */
> -	unsigned int progress;
> -
> -	/* nodemask for allocation fallback */
> -	nodemask_t alloc_nmask;
> -
> -	/* Each bit represents a single occupied (!none/zero) page. */
> -	DECLARE_BITMAP(mthp_present_ptes, MAX_PTRS_PER_PTE);
> -};
> -
>  /**
>   * struct khugepaged_scan - cursor for scanning
>   * @mm_head: the head of the mm list to scan
> --
> 2.54.0
>

--
Cheers, Lorenzo

