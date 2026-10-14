Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F58C3DA7A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 17:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38F6D6B00A0; Wed, 14 Oct 2026 13:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3653D6B00A1; Wed, 14 Oct 2026 13:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27BF86B00A2; Wed, 14 Oct 2026 13:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E27796B00A0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 13:12:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7ABD91606F1
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:15 +0000 (UTC)
X-FDA: 85321875030.03.C10E6BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 55973C0005
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:12:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ME0w3mwo;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791997933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHbhAjvVCr6qg+54r5Uo/OYsd7AlcLdNQIe07Q/6O4Q=;
	b=tbisgimqvrEykcsswhALizHv8x9cUWrmVa9cEr2sNUtvfbOCAmipZrQCwRx8Baj0qiKEpb
	k7kqe1ZLDOsUY2vRuEeJP08K/vMGSs1C3bBFwJ8VI8BRxwZp4/au/gVIVaA8N73zb0CoQv
	/x2q8ujS3Bfmi9tP1YAAe5GAdv5xpJI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ME0w3mwo;
	spf=pass (imf10.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791997933;
	b=NIMCnKNaCbdrFVoVE4dSbZC+5DllSmT88zYldKhuox69gjwDyxrUnY8XcHV+shY60uwryD
	pfg7F6Aixy0YeggV2F9DlzCawoMFcfdxrRXWm2kqwVHxnpzop6qakOTzhHElKUfq13c8fP
	80qeL+q39toNRIGL4LA9UWkLj0F0Y9U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A286443FDE;
	Wed, 14 Oct 2026 17:12:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06371F000C6;
	Wed, 14 Oct 2026 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791997932;
	bh=sHbhAjvVCr6qg+54r5Uo/OYsd7AlcLdNQIe07Q/6O4Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ME0w3mwodDaqgNcMrr4JwqaPOnPDVQ91TYW1EjjPEGuk5FBprmY7ax1YSSnr1co7v
	 QAgs55hkhjomVB8U9gsY9wh8G+LSiDzOFEyZuPM0zW6O7VT6cRX4XRS/O4E4zAEvQx
	 +R74TXx4pBjlLIaI9ZJyE0/8WLmk8ebBe4X86P2GGfGm10sAFZfpKwWlfgbF4yOI5Z
	 TPKWmr13vBWzZNyhpZOTNoTSZe7rTNUQZ+44bM7Mz6rtFn2IjtVyyW2/O6lRx6kdeF
	 x8pUELlvmi4fleUoG0WapX5iPi2VIWjp634gBYkUz36gitapYIa7ZFvSdzx1geYeXe
	 SJ7cCAbnO35iQ==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.ams.internal (Postfix) with ESMTP id F140E1980047;
	Wed, 14 Oct 2026 13:12:08 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Wed, 14 Oct 2026 13:12:10 -0400
X-ME-Sender: <xms:6LfPalm-8t3ZEa-IeI8GZKvPI7aqQa86K1uh-Bleywmi_WutcXaqPw>
    <xme:6LfPaszAr4j6awZ0wGGELRxFhApXsg8DDpbDmDLJeko8CmwzTEDW5hpamfI8Zb3oy
    CEmASy1tdcS5H6PVt-vOLryKkM-8H5tqcE2Tsm3Uvlc93tYLqUEAss>
X-ME-Received: <xmr:6LfPahz7_YB-5kNTcZNB8UbDbQbPxFzTZHbB9iuG2QYeMkrUVyZccjkMwhI>
X-ME-Proxy-Cause: dmFkZTEOl4NfFwPDLSBmMqKx+7N39IeMIni7MK/u+VvxaGQ1bs8GfI9RPH3ayDujSspKBR
    qyKM+cOOmgGIjV1p99esKFBZjBYm+2fZxsu+dp6kV/40GtAwNmLs0lveP2Nu4w+lTJFNGX
    +PHSDDgHqCL4KFJyfY61faoRzA0h8vW6kqyfQ8QWLAhZGC4dGYbGOPKI1Rz1FZYlfQX1qS
    ZyU+Kn8XAf7cjImjIHoCIXuQM1OjXWl7zezG3uHTMAWWFgZp5y0YQrE07Fctth46IOKxOe
    Y9yLqjV8DtTpJEgGM7OnnqWtPPljjv3Jg1+LTtq+j0gFbbCdpQA4+mOsItlGLpSNkwSLKs
    rY1qsMTEWpTRn1agK67E3rWztIBJ1i53zyztIoAOV1t1WZRqgLWeBn6uK1W5hRIErJod0S
    wzfO07MhVKX/sSzF3UNsmTI4QJsvvYdgyw1VeEdLC2mHpl60VdfmST8k/A9849pcoaR+L0
    nPuuBp4QHMEaQAriY/j/FwRTMbTq5LwIWsLumpPXZY7D+pvH7Tz9ycpkC1rJd9sueDccS4
    KbWVmFl4bMf1tSvNGYGfeE1HWuP6hmlG0aKsryQULLMwWG4+QukYOP3qlBdvJ4QEr3hAdZ
    XeSxzJvaKTR9fH7rRJdwy5rzt6/us+HEsIcdNbWhdrbWpdbHEqCs5dajsOeA
X-ME-Proxy: <xmx:6LfPar_rNARNMHjbvyiWjkmXd9KBjUZsp2HY8xJwW1L0fvJjgT5gJg>
    <xmx:6LfPah-tKVklcggqBT5C5fWwjjOyUtrNxvlSdZE5QU3AHyLZ1eJ39Q>
    <xmx:6LfPaucrBYAsqM9Aehd1yVJCy1Up0CEzEFuFutb9Cl5jWjE78bY2XA>
    <xmx:6LfPattaOD3hQCH-ANJGynorB-G2y2l3OQMEXWomM3fJrO8lJI18FA>
    <xmx:6LfPan0InsCpTFR6jCehXCBAezhvwsCorovydKB6-vIsV_urDBnHZ4w5>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 14 Oct 2026 13:12:07 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v5 5/9] mm/collapse: state what a collapse may do in the policy
Date: Wed, 14 Oct 2026 18:11:38 +0100
Message-ID: <20261014171145.3292736-6-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014171145.3292736-1-kas@kernel.org>
References: <20261014171145.3292736-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 55973C0005
X-Rspam-User: 
X-Stat-Signature: gf6o55kb4e1pbkte8mwyw1tuns5qkgdf
X-HE-Tag: 1791997933-990475
X-HE-Meta: U2FsdGVkX1/j4Wr/hTCNq6yLldlT8tO7bihbgDrHvB00a48wfyHFjyoBYGFS0fV0LIKxDaVn9YLj932UPg9vPPXo56g0xgRtV5VLerWtHHxVWmd9pk5b36eVjiH+QKQmkdpl/0rAJUw4AoEo1m8Ro9s7al2nyads3wfEom9fffP6to5wztZNaY/kfNQ748+ajVwk2WgmY5CDFZ0h61wkOvdicYd+F/7/aGuKQbMpuKOGHgCOXcVmBEs30f4arl5W1LEsg1mvka2iR+eTjwUmObSX0a2/42HkvfQGbKAoVhY6BCHuMEqNK+Y8lzdTzczYnnfMrNcwq7FMEt5fLLry9+DUzSvM/C3U6ZYoTBSyvDwBDdZxXAG9KKGqsnOFim2rtzDtSLebojOy9ZpMCrL4sHHeOnJoEVbRQPUZa/ByKRbK+SoFVqPFeZBR8DMrsof/5viHzQznUTFEqd3p/vY7RaEnUsVN2n307/72Tnzx70S6hLYt8xHjUhcXRmrjdLW1juVXjmkrVm2sNBwhHhp+gDseJ+822nD3o366q0eTMZUPojpvMTpVb3pKi0wk4qF8i/vQmCjU28wcBk+FlUlEz6tPpXzd1nlCpje+6Nww1SK6QMzt0KHs+zQ1/I3ximhDAvMsRG8ygE3d29p7WoduXvDPHk8+T/P9UK3nhfkJnOLk3ghFCX82mXD7jbel/X2uVnTyqYLCe0Ae0ugQEN4x4QYkPP0EzoEXfrxcMSxCxomBou82e5cU8t3sOELQlwnZ5BFV27kxIn5f8SWVH2NVG2miPgYmLONFxUdKOHzYHubsn/EHn3JUhYn/vHo0PJXKlVn8jlsEgneYfcmmtKZPp+zfDkxnDQo/xGMq7Ge0XAf13BU/ouhQorMCE1dCVq0hgsO8qPFuHJvpneh1mizI/ivQoWxaWvy5d73TvvPlMVEoNE/zhj9Ojd4KS3v+j8SkGJTxvx9zi1HpjJtzv4m
 wjIRnKZs
 bKDqGCnUyQ3WqNEOTRUfDw9Rvuu/Qax6+fs3U/wzvwTFAEP6T7KSkIg2QxmDkfx9/1ztkZhfJFyLQAaNK/4b3hNJqVKS9purnCLIIBEKas7mV6tqT5Fr/6HtjXCm4zD1xm1KaVT1ST1pA+PBom2OHEVhUGfSeJ3yzCqxKrhWeu8h7JqtUUopuXQgRN500G10dVuVVFShbQZoaHl0psoEfzmhuohnmnxMpAmlmKngFVUvpKrv+xKgd8gjqZENhYVeAGk4M/4pzPfxeEZSY8fThFR5BV02a/jfPfHMD2pVjWdBa/mB/CgIeTzbukg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

The PTE limits come as two sets, one for a PMD-sized window and one for
anything smaller, so that the helpers pick a set for the order and read
it.  khugepaged takes no swapped-out or shared PTE into a sub-PMD window,
and empty PTEs only when the knob says all or nothing; the warning for a
knob value in between moves to where khugepaged fills its policy.  The
fields only one side reads say which: anon_ or file_.  David Hildenbrand
asked for both.

khugepaged fills the policy once per scan pass, MADV_COLLAPSE once per
call.  That is the one change in behaviour.  The max_ptes_* limits and the
defrag setting behind the allocation mask are sampled once per pass rather
than on every table.  A table scanned early in a pass and one scanned late
are then treated alike.

collapse_file() also drops a NULL check on the collapse_control.  It has
one call site, reached only from collapse_single_pmd(), which dereferences
cc unconditionally, so the check was already dead.

Assisted-by: LLM
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   |  41 +++++++++++++-
 mm/khugepaged.c | 147 +++++++++++++++++++++++++-----------------------
 2 files changed, 118 insertions(+), 70 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index b115034d9018..dcd117071955 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -45,8 +45,47 @@ enum scan_result {
 	SCAN_PAGE_DIRTY_OR_WRITEBACK,
 };
 
+/* How many PTEs of a window may be missing, swapped out or shared */
+struct collapse_limits {
+	/* Counted over a PMD-sized window; HPAGE_PMD_NR means "no limit" */
+	unsigned int max_ptes_none;
+	unsigned int max_ptes_swap;
+	unsigned int max_ptes_shared;
+};
+
+/* What a collapse is allowed to do, decided by the caller that asks for it */
+struct collapse_policy {
+	/* Limits for a PMD-sized window */
+	struct collapse_limits pmd;
+
+	/*
+	 * Limits for a smaller window.  Its max_ptes_none is either 0 or
+	 * COLLAPSE_MAX_PTES_LIMIT, the latter meaning all but one PTE of the
+	 * window whatever its order; any other value counts as 0.
+	 */
+	struct collapse_limits sub_pmd;
+
+	/* Leave clean lazyfree folios to reclaim rather than collapse them */
+	bool anon_skip_lazyfree;
+
+	/* Refuse an anonymous range with no sign of use */
+	bool anon_require_referenced;
+
+	/* Map the PMD over a file collapse instead of leaving it to a fault */
+	bool file_install_pmd;
+
+	/* Write dirty pages back and retry once instead of refusing them */
+	bool file_writeback_dirty;
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
index 8889f75cf45f..667216ae15dd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -314,30 +314,17 @@ static bool pte_none_or_zero(pte_t pte)
 static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 		struct vm_area_struct *vma, unsigned int order)
 {
-	const unsigned int max_ptes_none = khugepaged_max_ptes_none;
+	unsigned int max_ptes_none;
 
 	if (vma && userfaultfd_armed(vma))
 		return 0;
-	/* for MADV_COLLAPSE, allow any empty/shared zeropage PTEs */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/* for PMD collapse, respect the user defined maximum */
 	if (is_pmd_order(order))
-		return max_ptes_none;
-	/*
-	 * for mTHP collapse with the sysctl value set to COLLAPSE_MAX_PTES_LIMIT,
-	 * scale the maximum number of PTEs to the order of the collapse.
-	 */
+		return cc->policy.pmd.max_ptes_none;
+
+	/* Below PMD order: all but one PTE of the window, or none */
+	max_ptes_none = cc->policy.sub_pmd.max_ptes_none;
 	if (max_ptes_none == COLLAPSE_MAX_PTES_LIMIT)
 		return (1 << order) - 1;
-	/*
-	 * For mTHP collapse of values other than 0 or COLLAPSE_MAX_PTES_LIMIT,
-	 * emit a warning and return 0.
-	 */
-	if (max_ptes_none)
-		pr_warn_once("mTHP collapse does not support max_ptes_none"
-		     " values other than 0 or %u, defaulting to 0.\n",
-		     COLLAPSE_MAX_PTES_LIMIT);
 	return 0;
 }
 
@@ -353,20 +340,9 @@ static unsigned int collapse_max_ptes_none(struct collapse_control *cc,
 static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
 		unsigned int order)
 {
-	/*
-	 * For MADV_COLLAPSE, do not restrict the number of PTEs that map shared
-	 * anonymous pages.
-	 */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/*
-	 * for mTHP collapse do not allow collapsing anonymous memory pages that
-	 * are shared between processes.
-	 */
-	if (!is_pmd_order(order))
-		return 0;
-	/* for PMD collapse, respect the user defined maximum */
-	return khugepaged_max_ptes_shared;
+	if (is_pmd_order(order))
+		return cc->policy.pmd.max_ptes_shared;
+	return cc->policy.sub_pmd.max_ptes_shared;
 }
 
 /**
@@ -381,17 +357,9 @@ static unsigned int collapse_max_ptes_shared(struct collapse_control *cc,
 static unsigned int collapse_max_ptes_swap(struct collapse_control *cc,
 		unsigned int order)
 {
-	/*
-	 * For MADV_COLLAPSE, do not restrict the number PTEs entries or
-	 * pagecache entries that are non-present.
-	 */
-	if (!cc->is_khugepaged)
-		return HPAGE_PMD_NR;
-	/* for mTHP collapse do not allow any non-present PTEs or pagecache entries */
-	if (!is_pmd_order(order))
-		return 0;
-	/* for PMD collapse, respect the user defined maximum */
-	return khugepaged_max_ptes_swap;
+	if (is_pmd_order(order))
+		return cc->policy.pmd.max_ptes_swap;
+	return cc->policy.sub_pmd.max_ptes_swap;
 }
 
 int hugepage_madvise(struct vm_area_struct *vma,
@@ -678,7 +646,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			goto out;
@@ -767,12 +735,12 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		if (folio_test_large(folio))
 			list_add_tail(&folio->lru, compound_pagelist);
 next:
-		if (cc->is_khugepaged &&
+		if (cc->policy.anon_require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
 
-	if (unlikely(cc->is_khugepaged && !referenced)) {
+	if (unlikely(cc->policy.anon_require_referenced && !referenced)) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -938,9 +906,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-static struct collapse_control khugepaged_collapse_control = {
-	.is_khugepaged = true,
-};
+static struct collapse_control khugepaged_collapse_control;
 
 static bool collapse_scan_abort(int nid, struct collapse_control *cc)
 {
@@ -976,6 +942,52 @@ static inline gfp_t alloc_hugepage_khugepaged_gfpmask(void)
 	return khugepaged_defrag() ? GFP_TRANSHUGE : GFP_TRANSHUGE_LIGHT;
 }
 
+/* khugepaged collapses on its own initiative, so it obeys its own settings */
+static void collapse_policy_khugepaged(struct collapse_policy *p)
+{
+	p->pmd.max_ptes_none = READ_ONCE(khugepaged_max_ptes_none);
+	p->pmd.max_ptes_swap = READ_ONCE(khugepaged_max_ptes_swap);
+	p->pmd.max_ptes_shared = READ_ONCE(khugepaged_max_ptes_shared);
+
+	/*
+	 * A sub-PMD window takes no swapped-out and no shared PTE: reading
+	 * pages back or breaking CoW is not worth it for an mTHP.  Empty PTEs
+	 * it takes all or nothing, since anything in between would let one
+	 * collapse feed the next.
+	 */
+	p->sub_pmd.max_ptes_none = p->pmd.max_ptes_none;
+	if (p->sub_pmd.max_ptes_none &&
+	    p->sub_pmd.max_ptes_none != COLLAPSE_MAX_PTES_LIMIT)
+		pr_warn_once("mTHP collapse does not support max_ptes_none values other than 0 or %u, defaulting to 0.\n",
+			     COLLAPSE_MAX_PTES_LIMIT);
+	p->sub_pmd.max_ptes_swap = 0;
+	p->sub_pmd.max_ptes_shared = 0;
+
+	p->anon_skip_lazyfree = true;
+	p->anon_require_referenced = true;
+	p->file_install_pmd = false;
+	p->file_writeback_dirty = false;
+	p->gfp = alloc_hugepage_khugepaged_gfpmask();
+	p->tva_type = TVA_KHUGEPAGED;
+}
+
+/* MADV_COLLAPSE was asked for explicitly, so it is not held to those */
+static void collapse_policy_madvise(struct collapse_policy *p)
+{
+	p->pmd.max_ptes_none = HPAGE_PMD_NR;
+	p->pmd.max_ptes_swap = HPAGE_PMD_NR;
+	p->pmd.max_ptes_shared = HPAGE_PMD_NR;
+	/* Never read: MADV_COLLAPSE collapses to PMD order only */
+	p->sub_pmd = p->pmd;
+
+	p->anon_skip_lazyfree = false;
+	p->anon_require_referenced = false;
+	p->file_install_pmd = true;
+	p->file_writeback_dirty = true;
+	p->gfp = GFP_TRANSHUGE;
+	p->tva_type = TVA_FORCED_COLLAPSE;
+}
+
 #ifdef CONFIG_NUMA
 static int collapse_find_target_node(struct collapse_control *cc)
 {
@@ -1013,8 +1025,7 @@ static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned l
 		struct collapse_control *cc, unsigned int order)
 {
 	struct vm_area_struct *vma;
-	enum tva_type type = cc->is_khugepaged ? TVA_KHUGEPAGED :
-				 TVA_FORCED_COLLAPSE;
+	enum tva_type type = cc->policy.tva_type;
 
 	if (unlikely(collapse_test_exit_or_disable(mm)))
 		return SCAN_ANY_PROCESS;
@@ -1197,8 +1208,7 @@ static enum scan_result __collapse_huge_page_swapin(struct mm_struct *mm,
 static enum scan_result alloc_charge_folio(struct folio **foliop, struct mm_struct *mm,
 		struct collapse_control *cc, unsigned int order)
 {
-	gfp_t gfp = (cc->is_khugepaged ? alloc_hugepage_khugepaged_gfpmask() :
-		     GFP_TRANSHUGE);
+	gfp_t gfp = cc->policy.gfp;
 	int node = collapse_find_target_node(cc);
 	struct folio *folio;
 
@@ -1551,7 +1561,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	const unsigned int max_ptes_shared = collapse_max_ptes_shared(cc, HPAGE_PMD_ORDER);
 	const unsigned int max_ptes_swap = collapse_max_ptes_swap(cc, HPAGE_PMD_ORDER);
 	unsigned int max_ptes_none = collapse_max_ptes_none(cc, vma, HPAGE_PMD_ORDER);
-	enum tva_type tva_flags = cc->is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
+	enum tva_type tva_flags = cc->policy.tva_type;
 	pmd_t *pmd;
 	pte_t *pte, *_pte, pteval;
 	int i;
@@ -1651,7 +1661,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			failed_pfn = folio_pfn(folio);
@@ -1717,13 +1727,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 			goto out_unmap;
 		}
 
-		if (cc->is_khugepaged &&
+		if (cc->policy.anon_require_referenced &&
 		    folio_pte_referenced(folio, vma, addr, pteval))
 			referenced++;
 	}
-	if (cc->is_khugepaged &&
-		   (!referenced ||
-		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
+	if (cc->policy.anon_require_referenced &&
+	    (!referenced ||
+	     (unmapped && referenced < HPAGE_PMD_NR / 2))) {
 		result = SCAN_LACK_REFERENCED_PAGE;
 	} else {
 		result = SCAN_SUCCEED;
@@ -2582,11 +2592,11 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	xas_unlock_irq(&xas);
 
 	/*
-	 * Remove pte page tables, so we can re-fault the page as huge.
-	 * If MADV_COLLAPSE, adjust result to call try_collapse_pte_mapped_thp().
+	 * Remove pte page tables, so we can re-fault the page as huge.  A
+	 * caller that wants the PMD mapped now is told to go and do that.
 	 */
 	retract_page_tables(mapping, start);
-	if (cc && !cc->is_khugepaged)
+	if (cc->policy.file_install_pmd)
 		result = SCAN_PTE_MAPPED_HUGEPAGE;
 	folio_unlock(new_folio);
 
@@ -2773,11 +2783,8 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 retry:
 	result = collapse_scan_file(mm, addr, file, pgoff, cc);
 
-	/*
-	 * For MADV_COLLAPSE, when encountering dirty pages, try to writeback,
-	 * then retry the collapse one time.
-	 */
-	if (!cc->is_khugepaged && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
+	/* Dirty pages are worth a writeback and one more try, if asked for */
+	if (cc->policy.file_writeback_dirty && result == SCAN_PAGE_DIRTY_OR_WRITEBACK &&
 	    !triggered_wb && mapping_can_writeback(file->f_mapping)) {
 		const loff_t lstart = (loff_t)pgoff << PAGE_SHIFT;
 		const loff_t lend = lstart + HPAGE_PMD_SIZE - 1;
@@ -2794,7 +2801,7 @@ static enum scan_result collapse_single_pmd(unsigned long addr,
 			result = SCAN_ANY_PROCESS;
 		else
 			result = try_collapse_pte_mapped_thp(mm, addr,
-							     !cc->is_khugepaged);
+							cc->policy.file_install_pmd);
 		if (result == SCAN_PMD_MAPPED)
 			result = SCAN_SUCCEED;
 		mmap_read_unlock(mm);
@@ -2943,6 +2950,8 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 
 	lru_add_drain_all();
 
+	collapse_policy_khugepaged(&cc->policy);
+
 	cc->progress = 0;
 	while (true) {
 		cond_resched();
@@ -3170,7 +3179,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 	cc = kmalloc_obj(*cc);
 	if (!cc)
 		return -ENOMEM;
-	cc->is_khugepaged = false;
+	collapse_policy_madvise(&cc->policy);
 	cc->progress = 0;
 
 	lru_add_drain_all();
-- 
2.54.0


