Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 836B4CCD185
	for <linux-mm@archiver.kernel.org>; Fri, 10 Oct 2025 13:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA03B8E000D; Fri, 10 Oct 2025 09:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29A38E0003; Fri, 10 Oct 2025 09:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91D658E000D; Fri, 10 Oct 2025 09:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7781A8E0003
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 09:29:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 13B0B86C43
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:29:55 +0000 (UTC)
X-FDA: 83982287550.22.7734330
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0D832C0010
	for <linux-mm@kvack.org>; Fri, 10 Oct 2025 13:29:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e7ZMDMM8;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760102993;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ug5oFUj5EB8IPBlCRo95a1xL+zEjN6ZeISyw9VBFCCk=;
	b=TJfsmojcB9DX31PdabCASbAV1ZGQvojvYZt8Udbu9rErdi0t3RkR9k8MOqlR1XtFA046vV
	xrjqw6UVSEb9B3gFPmDsSGtlyKtYlGlSNt3DDp9ST72htyEKxmI71AYNDlql4wpp57Bnr1
	cmNgsIsWU6AKXPhOhxSDvzCALdvFXEk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=e7ZMDMM8;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.42 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760102993; a=rsa-sha256;
	cv=none;
	b=XmBbfmPvpYk69zOwFgyJXGa+5QLAjCKEBj26Qb68mJSV5r7D/plaAxjnW81Eew3f8oQI2j
	5bUFfngnqSnS96yR1M3njJPwcWd/BZClHPi5HXfPgh9S7ms2JcTZPZ6Dkw2nSVJzuDvcdO
	MuyHP1OIZIAlGPMPnTbkLNFuFz2a6LM=
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-b54f55a290cso241696166b.2
        for <linux-mm@kvack.org>; Fri, 10 Oct 2025 06:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760102991; x=1760707791; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ug5oFUj5EB8IPBlCRo95a1xL+zEjN6ZeISyw9VBFCCk=;
        b=e7ZMDMM8RX4FVi8/fI8qSXRGj5h8gbps8absoCYv2kWHxfCbaSy9hAfRJzkEhgmIdi
         jFClgKNITmJORHycrTEFa1AdZG7xiI6x5O9d0rlmEqkR8nPSaxDzyNH+2QyBWLKdLZsG
         7PhRPkqWglV03GnvDlrM9Mx73sVWFa04xRN4MZLxAo23nycpVrmNFAoU5tAUbK/e0d8U
         3t3fxmNje84PpEEaVqrNlz+OGoYMQKjqym2u+8Sb8KMSXP1WiAx3YMavJE/V2eQ0Y4wg
         oMscBK9hIYiVLfJ6CuM/lDIXQgsUbzT/CbtizPXSvVBy8j3KqHNyXtat65L2nIqdL4WB
         7yOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760102991; x=1760707791;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Ug5oFUj5EB8IPBlCRo95a1xL+zEjN6ZeISyw9VBFCCk=;
        b=DgSguQVGZOeFv3EP6CFM0NwUUTHBRw81afqtZupkM4VdoVYN95BYo/BOUfRfhaTvXB
         buOMf6le2BubDvmCDGdzH88GmYo2/8695aeoDOKkntFgOSvnu3zhSOqfhmFmpY+Aj2iT
         W9Eqy/kfVpgoObtrLuP6paKF7IR+zk6aca5bIC4KCj3oEoURi0pTIw25yLVPPUokLM1M
         nzmn7hwJiSyg7dcMYL+WiQIx9TQKC+uq1c7NSPsHTWT7KrYFtyZLmYSG1EFIe38XC06b
         8lXtlHaCn/bW6GnLC7UWvLvShtagY82Tfw2svqt5ntm7Uh6M/hyg235YPeNfxcj4/cRK
         Ssgg==
X-Forwarded-Encrypted: i=1; AJvYcCVdblU1irsAUg93Fw3dKX9bILcyYnrDua5zzNGeUNs3A/j4Q4E0UjNHqBT85qTUsTPLmeXDhkUCHQ==@kvack.org
X-Gm-Message-State: AOJu0YwOqqLbBdQQizU4kzHVKX/HnoAtaHo4egqlRuV6kxPiVtIBuCoK
	oEvOUAI/Ql25Ih+kVQOqwbv5MEMveUo9GwSlkA/mOVXeKA7thBuF/VNO
X-Gm-Gg: ASbGncs3QSEtWlIjAOZfIKavbfUvqqU94AVconcBubur3FxdvFslEbypUSyVdepS1YU
	j+rQD0VRghZ0eYaSdz4mBPv11UAUFVUg6WDS9ouPt6anyJuuUit2q9ORGba4zYqtq8Rte5e2+4E
	TPhQNOWgoCdjqOuCDk6/Y85i89qeO3h6JDVs/hHlHT374wbGVRTAZtKtEf1uthDUMqyRZXKtzMV
	x8Eods7CCUAd2roEga6+8gknDgI7G5HT8IR0RJnigqP7iCD9Peou3a6BKWl2XI1863uqjHAapst
	hl4U53YwXccIJkEN0ylHolOgmYxhhQv9FZ8bs2vcEPFJMhGBYLV2RoNamRzC0BowErIuxA4KBNv
	nmUv05VWvz9UW3hYDPFZ597Sj2dLs8tt2l/KnkGyK
X-Google-Smtp-Source: AGHT+IHQoMcu7TJHvzBvarT7XKSM3ouzdFFKivDkPdJXOBygQlFKGONGflmp8270sQLMkzU4rdlviQ==
X-Received: by 2002:a17:907:970f:b0:b41:a3db:a53a with SMTP id a640c23a62f3a-b50a73da0d5mr1228167966b.0.1760102991092;
        Fri, 10 Oct 2025 06:29:51 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b55d9525bd1sm229030866b.81.2025.10.10.06.29.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 10 Oct 2025 06:29:50 -0700 (PDT)
Date: Fri, 10 Oct 2025 13:29:50 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	ziy@nvidia.com, baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
	dev.jain@arm.com, baohua@kernel.org, ioworker0@gmail.com,
	richard.weiyang@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH mm-new v3 3/3] mm/khugepaged: merge PTE scanning logic
 into a new helper
Message-ID: <20251010132950.yx6bmvub3a46gcl3@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251008043748.45554-1-lance.yang@linux.dev>
 <20251008043748.45554-4-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251008043748.45554-4-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: syfrfx3e7skaqichogksqcfcdx8nhje9
X-Rspamd-Queue-Id: 0D832C0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760102992-707311
X-HE-Meta: U2FsdGVkX18VjdpcN5yLEI7ISYRQUrfk2X0lGyQt+NVeFlLjMIR3ONJnCYnH3pzhR2mucUfzHH5+4YlU/VuV9kHYODhi5v1bW6wPIUl74QVwPRwCqGTY5eNluD4Shcnhu2Xr/TJLfc7Wwvxq0bfF0li2rf57oPiveZoxthJxd5ZXi80ikLtXt/i+0MbdiTFO8r9Dut+ZX/Ca9P0wmeygZPdjiPNuOD3XGWTkybIC/Y6z+7cSCpwd1UKaHPHv3XmI0VeY5Mt1vpJIglsmdyTUXSagEDgDaWHWyp1XIWhDU7kmj2D8peyAMXHcDyMKnlBXTCWMF7YGGVrhQaIeBhAls/vF5BJx0PtbKU2uolPYZlP8OPh/G6hTm0va152UJFSIuB+712949BBWefi2osmsv7YyhpzNK1Iw2jG8S4aIcwy7fTNSls1mw/g3fsl5VXq70u1x1TlnWolDSwddg5fqN+YwcvVk9In4M9FxdYsqVDzrGRU7XwFAXYVjqAOcg4R8LuY7WjczjFdk0di31xvZDxsIJR3gr86iadrkFy8AgNq188Nxo+Kj6x/tmYM2tc/3Ga1KSn22S6eZQe4FKx+bkCPi0NmaT74/k0wbL+qZjEOqEJiMVl1qcQ+VIJ7Dd0IMR5mW+SYao1lulICZAkqz/KACvElF6Uc7snd1pS1n4saOmLnLxVtD7mx0YgXr0r9ni7M7DxDlNChkPhgvDBM1yV4xq4Rt/n+nq9bRQjX3BnKrWr9Pj/KqdwD8Z9LZTS/W/cnjtYwUvPDb21j2kOjBXJBMD7Gy98gP9XF9R2mnSjfhnyJd08YBAY8khFr4oPQvmsVJNVHL8bO3oqREADM0aLEQEqyZR/FtyZENwzIzAkrClXWFDraZ+NoGy5n2pUoTiqmbpzYx2xvDt5tQ4rmJOdUVtTW8RkwmQgYjSsZyLGgpkoxtAvr9QwGNdbA/k4Tn0/uTYl9EJm9GFaXmwfI
 5sLO7gnG
 6h8MXbSK0b5lnZ7hOD8fdEqNADBMpBRtRHzHpSR911MomW3hbIhGLdEm8hldDko6V+uTsNmg/sSFIX9UkYRUCkkAHtNCoUQN0ECqoC+48fNbWxexAEVrBBaK1cxvu6Eng0b/9vQu91r/l2/SxAOi3WL2mqwb7tSsQhmTm0Kfk8tZlzTimK551PQt1XjcWT/jZLkddf1dZRU36WK4pKEDFQBH4yjAXzE6yG++Fzb97G5Ocffn8r7INbMJFHfAHkXHVnjovsqsYpAXdqOHl/5hT+ucs+iHuTMOxodcKu+4RaqbL4Gtv9MQoE1AtHW0N1LE6XJGaZ1oOn8jsRN9ZuXD4u2koH+MSyzHhk4R1GgDHG0ErUoTa387KpE1/KH5ea5nrO8fGK3Do8tgj5gpV/w/uWdGv+C6LQye6+WxJGmJ4dj1Zz2vfZxDrr85R6FPpMemQR/mDVq7qQHn9ZjBHzyluUqOFFEleBdj5V/Oc4Yd/WnkrmDNp0PAfEU6uvt6slUbuXm6jLKzcfyUVw0I9OPlsZ+xQKdq4w3YX9NMHM/NzTZ0g7+YJUhV166Hb1lwiun18L1XLOUDfJ09LvM0yKLzMjTJKNs3FkkzXWx2F9rbt16eAi/v87cxc3pT9OhIAkwmUOXZGqcHNYVYwNoWvM1vjeTe/+0AhnJ1bCJqsqcgc+xRohVOxtuTl+VdsRx5UQC0KA7M4ayjA62VUIz/KgHKgqQ64i5B9UGUG7ZHQOWchU72iaV+Rm7gWX2XKSrOUPzLUM9k5Mswo3QrPg/azezjori1qdJRAHs8FDyZe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 08, 2025 at 12:37:48PM +0800, Lance Yang wrote:
>From: Lance Yang <lance.yang@linux.dev>
>
>As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>and __collapse_huge_page_isolate() was almost duplicated.
>
>This patch cleans things up by moving all the common PTE checking logic
>into a new shared helper, thp_collapse_check_pte(). While at it, we use
>vm_normal_folio() instead of vm_normal_page().
>
>Suggested-by: David Hildenbrand <david@redhat.com>
>Suggested-by: Dev Jain <dev.jain@arm.com>
>Signed-off-by: Lance Yang <lance.yang@linux.dev>
>---
> mm/khugepaged.c | 243 ++++++++++++++++++++++++++----------------------
> 1 file changed, 130 insertions(+), 113 deletions(-)
>
>diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>index b5c0295c3414..7116caae1fa4 100644
>--- a/mm/khugepaged.c
>+++ b/mm/khugepaged.c
>@@ -61,6 +61,12 @@ enum scan_result {
> 	SCAN_PAGE_FILLED,
> };
> 
>+enum pte_check_result {
>+	PTE_CHECK_SUCCEED,
>+	PTE_CHECK_CONTINUE,
>+	PTE_CHECK_FAIL,
>+};
>+
> #define CREATE_TRACE_POINTS
> #include <trace/events/huge_memory.h>
> 
>@@ -533,62 +539,139 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
> 	}
> }
> 
>+/*
>+ * thp_collapse_check_pte - Check if a PTE is suitable for THP collapse
>+ * @pte:           The PTE to check
>+ * @vma:           The VMA the PTE belongs to
>+ * @addr:          The virtual address corresponding to this PTE
>+ * @foliop:        On success, used to return a pointer to the folio
>+ *                 Must be non-NULL
>+ * @none_or_zero:  Counter for none/zero PTEs. Must be non-NULL
>+ * @unmapped:      Counter for swap PTEs. Can be NULL if not scanning swaps
>+ * @shared:        Counter for shared pages. Must be non-NULL
>+ * @scan_result:   Used to return the failure reason (SCAN_*) on a
>+ *                 PTE_CHECK_FAIL return. Must be non-NULL
>+ * @cc:            Collapse control settings
>+ *
>+ * Returns:
>+ *   PTE_CHECK_SUCCEED  - PTE is suitable, proceed with further checks
>+ *   PTE_CHECK_CONTINUE - Skip this PTE and continue scanning
>+ *   PTE_CHECK_FAIL     - Abort collapse scan
>+ */
>+static inline int thp_collapse_check_pte(pte_t pte, struct vm_area_struct *vma,
>+		unsigned long addr, struct folio **foliop, int *none_or_zero,
>+		int *unmapped, int *shared, int *scan_result,
>+		struct collapse_control *cc)
>+{
>+	struct folio *folio = NULL;
>+
>+	if (pte_none(pte) || is_zero_pfn(pte_pfn(pte))) {
>+		(*none_or_zero)++;
>+		if (!userfaultfd_armed(vma) &&
>+		    (!cc->is_khugepaged ||
>+		     *none_or_zero <= khugepaged_max_ptes_none)) {
>+			return PTE_CHECK_CONTINUE;
>+		} else {
>+			*scan_result = SCAN_EXCEED_NONE_PTE;
>+			count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>+			return PTE_CHECK_FAIL;
>+		}
>+	} else if (!pte_present(pte)) {
>+		if (!unmapped) {
>+			*scan_result = SCAN_PTE_NON_PRESENT;
>+			return PTE_CHECK_FAIL;
>+		}
>+
>+		if (non_swap_entry(pte_to_swp_entry(pte))) {
>+			*scan_result = SCAN_PTE_NON_PRESENT;
>+			return PTE_CHECK_FAIL;
>+		}
>+
>+		(*unmapped)++;
>+		if (!cc->is_khugepaged ||
>+		    *unmapped <= khugepaged_max_ptes_swap) {
>+			/*
>+			 * Always be strict with uffd-wp enabled swap
>+			 * entries. Please see comment below for
>+			 * pte_uffd_wp().
>+			 */
>+			if (pte_swp_uffd_wp(pte)) {
>+				*scan_result = SCAN_PTE_UFFD_WP;
>+				return PTE_CHECK_FAIL;
>+			}
>+			return PTE_CHECK_CONTINUE;
>+		} else {
>+			*scan_result = SCAN_EXCEED_SWAP_PTE;
>+			count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>+			return PTE_CHECK_FAIL;
>+		}
>+	} else if (pte_uffd_wp(pte)) {
>+		/*
>+		 * Don't collapse the page if any of the small PTEs are
>+		 * armed with uffd write protection. Here we can also mark
>+		 * the new huge pmd as write protected if any of the small
>+		 * ones is marked but that could bring unknown userfault
>+		 * messages that falls outside of the registered range.
>+		 * So, just be simple.
>+		 */
>+		*scan_result = SCAN_PTE_UFFD_WP;
>+		return PTE_CHECK_FAIL;
>+	}
>+
>+	folio = vm_normal_folio(vma, addr, pte);
>+	if (unlikely(!folio) || unlikely(folio_is_zone_device(folio))) {
>+		*scan_result = SCAN_PAGE_NULL;
>+		return PTE_CHECK_FAIL;
>+	}
>+
>+	if (!folio_test_anon(folio)) {
>+		VM_WARN_ON_FOLIO(true, folio);
>+		*scan_result = SCAN_PAGE_ANON;
>+		return PTE_CHECK_FAIL;
>+	}
>+
>+	/*
>+	 * We treat a single page as shared if any part of the THP
>+	 * is shared.
>+	 */
>+	if (folio_maybe_mapped_shared(folio)) {
>+		(*shared)++;
>+		if (cc->is_khugepaged && *shared > khugepaged_max_ptes_shared) {
>+			*scan_result = SCAN_EXCEED_SHARED_PTE;
>+			count_vm_event(THP_SCAN_EXCEED_SHARED_PTE);
>+			return PTE_CHECK_FAIL;
>+		}
>+	}
>+
>+	*foliop = folio;
>+
>+	return PTE_CHECK_SUCCEED;
>+}
>+

This one looks much better.

While my personal feeling is this is not a complete work to merge the scanning
logic. We still have folio_expected_ref_count() and pte_young() check present
both in __collapse_huge_page_isolate() and huge_collapse_scan_pmd().

-- 
Wei Yang
Help you, Help me

