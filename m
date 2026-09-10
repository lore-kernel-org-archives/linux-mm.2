Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E91AC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:03:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ED176B00A2; Thu, 10 Sep 2026 08:03:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19EB06B00A3; Thu, 10 Sep 2026 08:03:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03F4A6B00A4; Thu, 10 Sep 2026 08:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C25E36B00A2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:03:01 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 546DB1404D2
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:01 +0000 (UTC)
X-FDA: 85197716562.27.FF81E42
Received: from fout-b8-smtp.messagingengine.com (fout-b8-smtp.messagingengine.com [202.12.124.151])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5B5F52000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:02:59 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M 6QwsyH";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EZs4UQag;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="M 6QwsyH";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=EZs4UQag;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.151 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041779;
	b=SgAN0JhBbQhA3dRSnWW8axMxJ5O0I9yzcFeicDynVM80Y53RgOIP4z1YwS8RNiIHx7WnAA
	fxxjehfbjPIgsfFoeDSNHNPCga06OCoKJ5UqrnbZWzm4Ta3vnif65ITR62LPx3dUdDix3U
	llHiiBQHo0KnHD27wXl4AGDa69tN2o8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zi9Br7spViFzIpBHYvoM9/hr0EidxdhOJvgib0JvV/I=;
	b=JQnYMtpEGWfXhZoGRpJ4nZlMLCTAuFAtvokS9aG9llglT+hb8J5OMv+MZJJZAt5dvwfKIi
	XNqEM38enaqGqpQElQVSVHk33P6H2MVh7RLj2RkbxH39XE56e/EKPC9KUwSJUrpG9KjRdF
	iM3PRAbf09R+1qmUKl4se6w7wohlEdA=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.stl.internal (Postfix) with ESMTP id 596D11D00082;
	Thu, 10 Sep 2026 08:02:58 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 10 Sep 2026 08:02:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041778; x=
	1789128178; bh=Zi9Br7spViFzIpBHYvoM9/hr0EidxdhOJvgib0JvV/I=; b=M
	6QwsyHSzHhQjQyRp9IhCMxwVtmN40c0rvhcww5pPaMc3Q5wjBHVKSnogCng9hQ8h
	eXMq/ksU948pcoz157P7Y+JdnOTtZC6DQqm9DGzoYHN/64yyHi5IRq9Yb/P0kYv5
	RF4F6v7ctLsCc0p+PQxjSuoflhNGJ34ZfG01LJo27DAGSquFHJOaQdXg+nuUcqvN
	lzB1a9m8uoAhRNcpbHPBEFeMJK6vpEMHS5d4tY4QHY21jRx86BQzUjGVGyzaZAix
	mzIKQ4AnZwDQqChUndsSGr5QLKx7nX4GvqaMVVT4K6xT9AKc2En+H/0td60bAr28
	um6q6XGoP/ADeb20UX03A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041778; x=1789128178; bh=Z
	i9Br7spViFzIpBHYvoM9/hr0EidxdhOJvgib0JvV/I=; b=EZs4UQagWnjMRJY8n
	dwul6dhnRsNVBbOGkbxuB55G8b590Ft2DKL3WEA4wTSlStDdHbSIVhL3OCHo7ij2
	ZUaz4EltcBkmDUHA6fT3l+GaufNCbJKr+941BKolRymhpGfUrhA3/ZQKgxWntHbp
	VO9ZU8/rt2exzldrQrexAJnXvyM8/9vqXpYeP0A6f3Lgpxyt2ZPeeTB9cjs5sVbE
	iuacJp2TJ9r+CcMmb61HenV8EOy2XybtB0aA60pKJUTFGHoDhs5vrYTPsdTTChZQ
	6qftDozxQaT3J2s2YKiV1qg19jkZSSUpEf3wjW3wpNMXlW6VginIgvvSmkPMrDFz
	CEWlg==
X-ME-Sender: <xms:cZyiaqDSm96tCpOqrsjwHAKEBU3zuXVNQXtMFWG9Gn1vxz3K549_PA>
    <xme:cZyiavNGutX_K9JM8MS302TPhdiTExXgBxgJH3NgWFOYpB8CLZEKl6BuDJlEuzbLR
    8y180O-z79ztK5468JT0DEbzNoBqdVycZiy_oJm6W0jxdM57N4BjTU>
X-ME-Received: <xmr:cZyiakM60ooeiQSn3gDO-hBQKeN8LS9F-rfin2SiHEcjLRXSQbVtTBPstB4>
X-ME-Proxy-Cause: dmFkZTEVCHaom43ud29NDpH2Ao3u7HJ/1ECQvA0KKWbvYxhttLa4TfzKR6zF5UuYx3UdSX
    No90AnuR4y57x1CX4a9AAsMV1JR4eQYCvRkfoTmW6C9Lc6lI8AZbTNwmqz4UTzT3vnk7qg
    ph+TCI1xI7srBtDO6Tg5MLzI4vqgzAzQGVqRHCjhPRmxizMOs2MvZfOp4fytB88FrNmNEM
    gORbCSjN6PT3vgIUt7WNrJZsAWFpVymtt3pMoPYb3jF9rU+m42uK7S67tVqaIc+biyrQXs
    /trDbiCnZfBDKlB4R/Y3z4EcguiWXCyuMp2o4aP4AZn5jbn1xeIsCoHcLAwPh3Pk2CuofT
    Jefx/QVBBT5LzvkNKCImwRofU2KfKrzkA4sXRxOF4SJL0A+7dONvQ+g1Y7GP6Gq0rb6iub
    Lq5y978/FBTb820ej2lIE86TqP1eiz+NuLTZEKg8TiQhQL/DDETAtan/Ue1rQ5SofX5Fha
    OtoWUgjOPaFtfglWmw09XiGyPtRgIg8Udwy64ywQhxVQ1phhpr7lhREjVv4JsCNPiChw79
    NpqsbF3hbiDxD3GNnoRt+PEUME8+8lMjxgM/FxKu0ylP3usgudkvQx6n1IwTWjQHqvEPHs
    guiSvWmdQPYmA6Skyd27PB0qtwtUDhaDCFYKFXCrzfE85+3ErRmW4pa/U/Xg
X-ME-Proxy: <xmx:cZyiajucx2gWnxfnbo776yVHj1qOpaGqly9GxXSx_ltW8L5hyKSjyA>
    <xmx:cpyiap-mXW5G5gHlCanq4yXDXp2izjLYvGeJNHX9VZV9N7gF2nIjqA>
    <xmx:cpyiavFiQQAiYfWYo1rrBjS0y3J2IEv-2lj4CDtTX3hXS15DDvA2kA>
    <xmx:cpyiagRmnqrmxCUhvaMk1Nf8Zi7jz0fD6-eARJUY6rrJoCACRbOJ1w>
    <xmx:cpyial7HQwo-JLuipw9wBhdn5XjP7kAQD9IWyjjJPdL6Kdcf20ov3yEl>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:02:57 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 05/12] mm/collapse: state what a collapse may do in the policy
Date: Thu, 10 Sep 2026 13:02:25 +0100
Message-ID: <20260910120238.2529819-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B5F52000D
X-Stat-Signature: t51p5mfqq49sd7aohpohnbqber8hmdaj
X-Rspamd-Server: rspam01
X-HE-Tag: 1789041779-803669
X-HE-Meta: U2FsdGVkX1+q9gKjEDVGjJrEdOcTXo1DQiD5WCpfXQEjFJC5jFSa5Awp9Ep4AZSGPFBFCUa50c8lRld+wG8hUKNSafUI/gQtHUpCO7tokFtnn/D8rKCyEv9fgWNKJpBBihO5qAVi4MRMiCJIPPG+f/T/s9TuBM/sQTzbM2VJGnjTBmUCVJt1/RtO8DQgvXQXPQqirBuGs+KXK1Fp6J/HVUct6Lisye4UyVOZegO9Xhu8AQhFcXRsYGrGTV0mg4KflUFtEmVDZcvppYxAOVmUIpc3tsO/Rj8llyUlhbXN1CDd6P+CF2GMKOKL/IOECpH6Hs0/TAZqKtJSMfT71H3e/mZOhTxQutCgkbM2jRaVj54rRYDTeypcKXrvMsXdpraMy/+15JjDn7Tm98cpQwhzb1v3ziNC4bMKy7lFdyWw+tD5rIfXQbtW13Ki1i3Pu4v/HugK+5AcrNrNfR+o7gBNXTCPq/Rhw/06WjrTivVsRxzEadKZROfGpz8qSmLkuVOFgznTNUpWNyHCV9a6IBeZGF29SUAyvhFCSC6jk9wuNFrpVrdps363YpBABtp4WiK94VlW6I7lE95n/nrCpUhGTHHdQ20y9rDh31682jFF0gddsbLJUPMHmLO8Jj2Rl9s0bZqVRmAdBPQWowi/PdkvlGgGxyXuu04o6hjz4tOGYZmi9hb3GpUav00mCA2wQ3imE/oQUSKHZWWGw89ffdp/xCPYkjMEA9+CLXbw+Btjpl//NgfD7axkoNY0QWSO/4qpAXWRKHyHlKpqFE21rZnsokrR9ZO9+UVQBnmPIeJdYgz/ZTLux0+f8ixo2hOPVhj+8IRPiQ+jwO2gqG/iqeaHLtaSrb6XmsLv53amSJxhbEyY5ZRtD68HMW7fkb6pSzgvsdMWwfc5KdwA5E7ZcimPLlE/VMVljWIPGK5Sp6GHxqKaGwbMv5o/dPvB6JkiillNjcm+JViHAPLx9y0Vk0J
 h9HtjzNH
 1cGKI5msC00XFC2w2oiKCZ8wb5sLIrP1bdSymhAqTU9QTQ2aGM6Vm1RXsj6Nz2CFf1OXYACoQq+9dcxcbPCvKbhDdQEZUJWsIP8rjtWE8ElTTTWCF0xYV/BtcRbNXOHwqaRpM4JpYZ0dxXsilajwM6ztsbb6ECN6JBq77nIR9814wTGD5fYaDP08//A7bXNWWXpsunTbORCartLw/Bo/2Qi9Q+EC4TVsdgov+NYskZ5lOLRt+Qo5GDM441FXuyYpNb3IxlVF41Hd7Z3lru67wTbdWWrxuwQfSNm1ZeCCe5O1mHzg2iay4nTjh24Ah+0V/Mg0TvKev09/VFY/wprSn5Fozuli1YPMazAFJIHI3s60scJg7gBlFplAP8JfR3xfZLZ3L2q8ReTvgu9P6sXqG6aWQebr74ZCsIlqDWP50CZeGwZRHa6hBOYQ41ssQhCbE+FWaXnSI+WGgEQQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Tests scattered through the collapse path decide what a collapse is
allowed to do by asking whether khugepaged started it.  Between them they
settle:

 - which VMAs are eligible, and how hard to try for a folio;
 - how many empty, swapped-out or shared PTEs a window may contain, and
   whether a sub-PMD window is held to a stricter rule than a PMD;
 - whether a range has to look used, and whether a MADV_FREE'd page is
   left alone;
 - whether the PMD is mapped as part of the request, and whether dirty
   pages are worth writing back and retrying.

None of those is a fact about khugepaged.  Each is something the caller
decided before asking, and the collapse code should not have to look up
who called to find out.

Add struct collapse_policy for the caller to fill: khugepaged from its
own settings, MADV_COLLAPSE from the fact that a user asked explicitly.
Every test becomes a read of a field, and cc->is_khugepaged goes, having
no reader left.

khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
call.  That is the one change in behaviour.  The max_ptes_* limits and the
defrag setting behind the allocation mask are sampled once per pass rather
than on every table.  A table scanned early in a pass and one scanned late
are then judged alike.

collapse_file() also drops a NULL check on the collapse_control.  It has
one call site, reached only from collapse_single_pmd(), which dereferences
cc unconditionally, so the check was already dead.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   |  31 ++++++++++++-
 mm/khugepaged.c | 114 ++++++++++++++++++++++++++----------------------
 2 files changed, 93 insertions(+), 52 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index b115034d9018..7044dc71c7c2 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -45,8 +45,37 @@ enum scan_result {
 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
+/* What a collapse is allowed to do, decided by the caller that asks for it */
+struct collapse_policy {
+	/* Limits, stated per PMD; HPAGE_PMD_NR means "no limit" */
+	unsigned int max_ptes_none;
+	unsigned int max_ptes_swap;
+	unsigned int max_ptes_shared;
+
+	/* Take no swapped-out or shared PTE into a sub-PMD collapse */
+	bool strict_sub_pmd;
+
+	/* Leave clean lazyfree folios to reclaim rather than collapse them */
+	bool skip_lazyfree;
+
+	/* Refuse a range with no sign of use */
+	bool require_referenced;
+
+	/* Map the PMD over a file collapse instead of leaving it to a fault */
+	bool install_pmd;
+
+	/* Write dirty pages back and retry once instead of refusing them */
+	bool writeback_dirty;
+
+	/* How hard to try for a destination folio */
+	gfp_t gfp;
+
+	/* Which VMAs are eligible, as thp_vma_allowable_orders() spells it */
+	enum tva_type tva_type;
+};
+
 struct collapse_control {
-	bool is_khugepaged;
+	struct collapse_policy policy;
 
 	/* Num pages scanned per node */
 	u32 node_load[MAX_NUMNODES];
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8889f75cf45f..16cb94ea3455 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -314,15 +314,12 @@ static bool pte_none_or_zero(pte_t pte)
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
-	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
+	const unsigned int max_ptes_none = cc->policy.max_ptes_none;
 
 	if (vma && userfaultfd_armed(vma))
 		return 0;
-	/* for MADV_COLLAPSE, allow any empty/shared zeropage PTEs */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/* for PMD collapse, respect the user defined maximum */
-	if (is_pmd_order(order))
+	/* The limit as given, at the PMD order and wherever it is not capped */
+	if (is_pmd_order(order) || !cc->policy.strict_sub_pmd)
 		return max_ptes_none;
 	/*
 	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
@@ -354,19 +351,12 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
 		unsigned int order)
 {
 	/*
-	 * For MADV_COLLAPSE, do not restrict the number of PTEs that map shared
-	 * anonymous pages.
+	 * A sub-PMD window held to the strict rule takes no shared page at all:
+	 * an mTHP is not worth the CoW-breaking.
 	 */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/*
-	 * for mTHP collapse do not allow collapsing anonymous memory pages that
-	 * are shared between processes.
-	 */
-	if (!is_pmd_order(order))
+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
 		return 0;
-	/* for PMD collapse, respect the user defined maximum */
-	return khugepaged_max_ptes_shared;
+	return cc->policy.max_ptes_shared;
 }
 
 /**
@@ -382,16 +372,12 @@ static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 		unsigned int order)
 {
 	/*
-	 * For MADV_COLLAPSE, do not restrict the number PTEs entries or
-	 * pagecache entries that are non-present.
+	 * A sub-PMD window held to the strict rule takes nothing non-present:
+	 * reading pages back to build an mTHP is not worth the latency.
 	 */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/* for mTHP collapse do not allow any non-present PTEs or pagecache entries */
-	if (!is_pmd_order(order))
+	if (!is_pmd_order(order) && cc->policy.strict_sub_pmd)
 		return 0;
-	/* for PMD collapse, respect the user defined maximum */
-	return khugepaged_max_ptes_swap;
+	return cc->policy.max_ptes_swap;
 }
 
 int hugepage_madvise(struct vm_area_struct *vma,
@@ -678,7 +664,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			goto out;
@@ -767,12 +753,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		if (cc->is_khugepaged &&
+		if (cc->policy.require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 
-	if (unlikely(cc->is_khugepaged && !referenced)) {
+	if (unlikely(cc->policy.require_referenced && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -938,9 +924,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-static struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
+static struct collapse_control khugepaged_collapse_control;
 
 static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
@@ -976,6 +960,36 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 	return khugepaged_defrag() ? GFP_TRANSHUGE : GFP_TRANSHUGE_LIGHT;
 }
 
+/* khugepaged collapses on its own initiative, so it obeys its own settings */
+static void collapse_policy_khugepaged(struct collapse_policy *p)
+{
+	p->max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
+	p->max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
+	p->max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
+	p->strict_sub_pmd = true;
+	p->skip_lazyfree = true;
+	p->require_referenced = true;
+	p->install_pmd = false;
+	p->writeback_dirty = false;
+	p->gfp = alloc_hugepage_khugepaged_gfpmask();
+	p->tva_type = TVA_KHUGEPAGED;
+}
+
+/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
+static void collapse_policy_forced(struct collapse_policy *p)
+{
+	p->max_ptes_none = HPAGE_PMD_NR;
+	p->max_ptes_swap = HPAGE_PMD_NR;
+	p->max_ptes_shared = HPAGE_PMD_NR;
+	p->strict_sub_pmd = false;
+	p->skip_lazyfree = false;
+	p->require_referenced = false;
+	p->install_pmd = true;
+	p->writeback_dirty = true;
+	p->gfp = GFP_TRANSHUGE;
+	p->tva_type = TVA_FORCED_COLLAPSE;
+}
+
 #ifdef CONFIG_NUMA
 static int collapse_find_target_node(struct collapse_control *cc)
 {
@@ -1013,8 +1027,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
-	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
-				 TVA_FORCED_COLLAPSE;
+	enum tva_type type = cc->policy.tva_type;
 
 	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -1197,8 +1210,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 		struct collapse_control *cc, unsigned int order)
 {
-	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
-		     GFP_TRANSHUGE);
+	gfp_t gfp = cc->policy.gfp;
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
@@ -1551,7 +1563,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	enum tva_type tva_flags = cc->policy.tva_type;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1651,7 +1663,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			failed_pfn = folio_pfn(folio);
@@ -1717,13 +1729,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			goto out_unmap;
 		}
 
-		if (cc->is_khugepaged &&
+		if (cc->policy.require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
-	if (cc->is_khugepaged &&
-		   (!referenced ||
-		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
+	if (cc->policy.require_referenced &&
+	    (!referenced ||
+	     (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -2582,11 +2594,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	xas_unlock_irq(&xas);
 
 	/*
-	 * Remove pte page tables, so we can re-fault the page as huge.
-	 * If MADV_COLLAPSE, adjust result to call try_collapse_pte_mapped_thp().
+	 * Remove pte page tables, so we can re-fault the page as huge.  A
+	 * caller that wants the PMD mapped now is told to go and do that.
 	 */
 	retract_page_tables(mapping, start);
-	if (cc && !cc->is_khugepaged)
+	if (cc->policy.install_pmd)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 	folio_unlock(new_folio);
 
@@ -2773,11 +2785,8 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 retry:
 	result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
-	/*
-	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
-	 * then retry the collapse one time.
-	 */
-	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	/* Dirty pages are worth a writeback and one more try, if asked for */
+	if (cc->policy.writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
 	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
 		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
 		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
@@ -2794,7 +2803,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 			result = SCAN_ANY_PROCESS;
 		else
 			result = try_collapse_pte_mapped_thp(mm, addr,
-							     !cc->is_khugepaged);
+							cc->policy.install_pmd);
 		if (result == SCAN_PMD_MAPPED)
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
@@ -2943,6 +2952,9 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 
 	lru_add_drain_all();
 
+	/* One policy for the whole pass, so every table is judged the same */
+	collapse_policy_khugepaged(&cc->policy);
+
 	cc->progress = 0;
 	while (true) {
 		cond_resched();
@@ -3170,7 +3182,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
-	cc->is_khugepaged = false;
+	collapse_policy_forced(&cc->policy);
 	cc->progress = 0;
 
 	lru_add_drain_all();
-- 
2.54.0


