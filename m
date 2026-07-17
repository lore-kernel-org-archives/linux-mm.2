Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 193B9C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDFD86B00AB; Fri, 17 Jul 2026 13:01:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B90466B00AC; Fri, 17 Jul 2026 13:01:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A59416B00AE; Fri, 17 Jul 2026 13:01:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72CA26B00AB
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:01:12 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECCA61A01EA
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:11 +0000 (UTC)
X-FDA: 84998883942.20.EDADB02
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5A01420007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:01:10 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=eg8ad3Ri;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784307670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PpNZRbQ47/WqGdrrUHhpvYqGIuM8bItP00+DgG6LDXo=;
	b=tPW/wQa8EOF3y+9bc2y10aJEpHpaEkv2wcC9c+QN7DzET18BSstzrLNTCcPnKeXroIBNzp
	dDZmQOlfZdYxzYx5Yyz+ZYf7XJFkrxzdt61H8XJAibmh00fzmiGpT+HXPqnxZvNWitOc1I
	SzvK+k9qJiZnq1qcNcAztVM51tI2zGs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=eg8ad3Ri;
	dmarc=none;
	spf=pass (imf03.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784307670;
	b=Ki1q6P+2JcOHM+6KIhDVq+fRakc41kgFl1aRYM7NCMHRUT2SFmWNDP8bbvNaCnbzqJPrfn
	6/54bwDQQzMYCJcrCcMGILDUabOrFBlvgRs9cMugrkepQRwl6P9jkqLjYOYNKYXZtMTxWt
	Kkaorkr72LALQz+V1aLz9+hsSCxWUns=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=PpNZRbQ47/WqGdrrUHhpvYqGIuM8bItP00+DgG6LDXo=; b=eg8ad3RiFa8lAL5pChcMMgF1Si
	LEbP5CZ1dBogtdyeKd+q0TUhTbit02LiVOpp6m6hBnGvr3J9MKzB6Gabf/w1RkeB/xjPyNSXCmw5n
	9x33pv/WFy+Cz5on5MbJSN3T/Z45sBaO10W/t8w9GivVYQG03zc6Xa/DNv1fDl/uDl2quDe+ASJIr
	08PV+2sy2+JnkIATDRgGx/E0LfZjXBGhUyOBCM4nxowH0d9AumHwwizfilLbnOyXaZdXf/Rwm9Mkf
	puhrOFc1ywQuSWaJpvYYHdbml9Y+yFXm6E4fQBHczEfQ91zkLtR2xjQlUqzJwkLH0P84hz83lyxP/
	etyWm5xg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wklvS-000000001w4-0RAd;
	Fri, 17 Jul 2026 13:00:38 -0400
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kernel-team@meta.com,
	Rik van Riel <riel@surriel.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	linux-trace-kernel@vger.kernel.org
Subject: [PATCH RFC v3 3/6] mm: rename get_user_page_vma_remote() to get_user_page_lookup_vma()
Date: Fri, 17 Jul 2026 13:00:33 -0400
Message-ID: <20260717170036.743149-4-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260717170036.743149-1-riel@surriel.com>
References: <20260717170036.743149-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ds1zus1rtxts5zyss3b1cdtxpb6bnixa
X-Rspamd-Queue-Id: 5A01420007
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784307670-919902
X-HE-Meta: U2FsdGVkX18v7mqKCzvTybDOguY8AXWpf2Ib3UsStScH+ZiDmmLLeWu6Anyf5a/r6YCYbYJqIYOE6BNHyMlVGxhiN9FgPzM/T0tH9Wrmqo6445jND5MUSx7cBF0SPKh7cT1foaYs5gBqJqNkQCWLiv9ilAKpb/bh4hAboi11BNZlbyX6hm1bujnTmnOUOKBymXlddfkvdZqfEn9wTWQhv/zp1i+kyaIY7ZHW9oZQUw2FVA4Foe6cf93UJnP2lkrRU8llW1kMr4G1utTHg42Sr9BbI0iJBG+0GMmCnAzgLlUudSsERLrZwmo0j2Xa5xsA37nQJfimpAmBJQ/a4cMCJxrxoIr4b4nB8cTHb0i4skH5UBEqkqEYN9wnlx1zcWFlLel9Tdr2Y7m5dze2Aky/ZFIAnrC4H7m2BkmMrb5a5BMtNPML9LOlqVYnJh8U6pLAcXq7eRyEeIudejJe31o1GJbnXrVHZvZbShPOkogvaARtjIaINQsa1bcFVWQ1hxwH7ceAlplvG7zBJkO1K+FMGUhpruaUVoWsI3/dytC6O1WWd/BsIm3OyUjW7kvHEydH/5NYhd6/Z5j0L6faFzuvMTN/h+K5+XnekTe5YPmV6YA2Y86hf5hmFa7U4vv+Jsu6GLxYMgU2tv9mMAcfg+GxukFVLoLFX553a6WLonSz3UIzbfcvfheMCxF/GaqWkC9g2oQOQVwW/j/290KC3C4GbrlWEujbRHtYXn8JoxOe8Z6mU92KCujxcAWs+VIK/6XHO+2vXPRyhJx65Iq3XO1nT30SFfdLnIxeGARLSUgiWgf5G98yk79OrFWZGd/g6LNtLRXUwZGEzDvwoO5krTox/cGtqwk2hKdtkDTePgLgo++MX8k4McqHhIQiAQgJ1iFaZ1DOylKfoByAnUWrHTCCA77is8p/OKXHUF4xjR9WPR92HpBm1JPtuOid7LhU+48HSSp0XgkThjiMVdygfsq
 OoadT0eD
 mgf5zEarFuG00tt9YZkpe4JQJHT+CDOv1+EFkKqG4HsM1ut+qRGFo7DvuKPODm38phmymLQ2VveccFSUzTabDab6TUaQIx6mRHV5MReEfBVqwbDljdxGlFWs8FDjkQrA9AjlOp6lr/+s9vVE1BD1+8zh9CV52NiBdyUimhH7MeZhwTEzwiLLI0U08RbLURbLwxLH0ZJx3+4oXM6OKkaAqQIXNqAskYqJ2ftDECmKvvFZoebS8Mi9wcfv8nE6Fc+13PYxxEgHqJzCuTtkhgXrWgXSsx0NDOR/7fJzRMZWGouYg8BbEn2jE5P0pjT33Y8rtm3zL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_user_page_vma_remote() faults in the page at @addr in a remote mm and
also looks up the VMA that covers it, handing both back to the caller.

This cleans up the name space for adding a get_user_page_vma() variant
where the caller already has the vma.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 arch/arm64/kernel/mte.c   | 2 +-
 arch/x86/kernel/uprobes.c | 2 +-
 include/linux/mm.h        | 2 +-
 mm/memory.c               | 4 ++--
 mm/rmap.c                 | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
index 1a9aad6ef22a..7a6ecc3d9294 100644
--- a/arch/arm64/kernel/mte.c
+++ b/arch/arm64/kernel/mte.c
@@ -459,7 +459,7 @@ static int __access_remote_tags(struct mm_struct *mm, unsigned long addr,
 		struct vm_area_struct *vma;
 		unsigned long tags, offset;
 		void *maddr;
-		struct page *page = get_user_page_vma_remote(mm, addr,
+		struct page *page = get_user_page_lookup_vma(mm, addr,
 							     gup_flags, &vma);
 		struct folio *folio;
 
diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
index 3af979fb41d3..329efac0cfb3 100644
--- a/arch/x86/kernel/uprobes.c
+++ b/arch/x86/kernel/uprobes.c
@@ -1036,7 +1036,7 @@ static int copy_from_vaddr(struct mm_struct *mm, unsigned long vaddr, void *dst,
 	struct vm_area_struct *vma;
 	struct page *page;
 
-	page = get_user_page_vma_remote(mm, vaddr, gup_flags, &vma);
+	page = get_user_page_lookup_vma(mm, vaddr, gup_flags, &vma);
 	if (IS_ERR(page))
 		return PTR_ERR(page);
 	uprobe_copy_from_page(page, vaddr, dst, len);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..24ead14b4790 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3238,7 +3238,7 @@ long pin_user_pages_remote(struct mm_struct *mm,
 /*
  * Retrieves a single page alongside its VMA. Does not support FOLL_NOWAIT.
  */
-static inline struct page *get_user_page_vma_remote(struct mm_struct *mm,
+static inline struct page *get_user_page_lookup_vma(struct mm_struct *mm,
 						    unsigned long addr,
 						    int gup_flags,
 						    struct vm_area_struct **vmap)
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe92..3b86eeaf084f 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7039,7 +7039,7 @@ static int __access_remote_vm(struct mm_struct *mm, unsigned long addr,
 		void *maddr;
 		struct folio *folio;
 		struct vm_area_struct *vma = NULL;
-		struct page *page = get_user_page_vma_remote(mm, addr,
+		struct page *page = get_user_page_lookup_vma(mm, addr,
 							     gup_flags, &vma);
 
 		if (IS_ERR(page)) {
@@ -7167,7 +7167,7 @@ static int __copy_remote_vm_str(struct mm_struct *mm, unsigned long addr,
 		struct page *page;
 		struct vm_area_struct *vma = NULL;
 
-		page = get_user_page_vma_remote(mm, addr, gup_flags, &vma);
+		page = get_user_page_lookup_vma(mm, addr, gup_flags, &vma);
 		if (IS_ERR(page)) {
 			/*
 			 * Treat as a total failure for now until we decide how
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..b36f2e219b8f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2838,7 +2838,7 @@ struct page *make_device_exclusive(struct mm_struct *mm, unsigned long addr,
 	 * (non-device-exclusive) PTE and issue a MMU_NOTIFY_EXCLUSIVE.
 	 */
 retry:
-	page = get_user_page_vma_remote(mm, addr,
+	page = get_user_page_lookup_vma(mm, addr,
 					FOLL_GET | FOLL_WRITE | FOLL_SPLIT_PMD,
 					&vma);
 	if (IS_ERR(page))
-- 
2.53.0-Meta


