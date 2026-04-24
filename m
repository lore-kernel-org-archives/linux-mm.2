Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C164FED3C5
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:02:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76086B00A0; Fri, 24 Apr 2026 09:02:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B27246B00A2; Fri, 24 Apr 2026 09:02:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63CA6B00A6; Fri, 24 Apr 2026 09:02:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 958B56B00A0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:02:26 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3562B40180
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:02:26 +0000 (UTC)
X-FDA: 84693463092.09.1DCC69F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 57D9D180024
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:02:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oXcu333O;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777035744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjowfAfr1hYSnzTyRQLbGXcnq+NpdAota2IwzvCgU/E=;
	b=UuVgqcYJv3BjagXgnwo7O3Z6m0jA9xq2kbYM4ulIt7MZkc5uKvU4fv7LUZC7dlBd5HfgfI
	BFJ0Hjz22MhdeniW/Vi/3eCCaF50nceoRL1kHay8yc0Sof5a2CiWEie8vH9epBxbdVcbPN
	O2Xry9ppNa0WwkNk1c4WXNCC6nb94wI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oXcu333O;
	spf=pass (imf06.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777035744; a=rsa-sha256;
	cv=none;
	b=MwPVtj67clD6ko3FtTIwbG+jLP9lb3mMxuRFGD+Qp1WCUNVE9UE/q6Uv6nJEBLnbBOzSQ3
	YdCzKVKnBkA5PbBpMqgvmZJOz4DfikjLCbXZKRHUWRJJCJ27VEZD8u+Cls5Tr5TDPsGqny
	hbGBMzMazrJV3r6p7F9Z+uuN9UAfToQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A0AC51BB0;
	Fri, 24 Apr 2026 06:02:17 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 635893F641;
	Fri, 24 Apr 2026 06:02:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777035743; bh=orwvIT1NW1/FJElOASW5FpIR2+QTAU/sj9g+OTacCeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oXcu333OFMWTxoUHUEhDo+F+TLgTg4GvdV8uewai7Ub+RJP3aATmvdyWvWhhrddZB
	 RwB4GUMp22pbW1kwZhXb+J5H7oBH9dYRAUMRhI+opuD2XsAy9XB5aApUFokoYaCOIZ
	 cKuo7XwGH+27sthd1aAJCDbRHkZXLpLfvWwvkryk=
From: Dev Jain <dev.jain@arm.com>
To: arnd@arndb.de,
	kees@kernel.org,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	urezki@gmail.com
Cc: dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	tglx@kernel.org,
	usama.anjum@arm.com,
	mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH v3 1/3] vmalloc: add __GFP_SKIP_KASAN support
Date: Fri, 24 Apr 2026 18:31:55 +0530
Message-Id: <20260424130157.3163009-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260424130157.3163009-1-dev.jain@arm.com>
References: <20260424130157.3163009-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 57D9D180024
X-Stat-Signature: s7p5qugmmstdfyo8btbk9z7yizc5y75p
X-Rspam-User: 
X-HE-Tag: 1777035744-39979
X-HE-Meta: U2FsdGVkX1/MoBnSfz2cdE4ltYLbT9OPYbAhCB6Iah9so4JB5rJRUZrVsBRdRpp+8yd5sXu2vCmQOldmpt97rrbvUYwEaKdQvB6kdIMeZKKIt07Hm+YvTETEEJPcRjzD4nWkt9Yqb1W2UQ6001laTeu6ljG0oE9oWOuEi7YAzlxw29v68lr5y5dkWgNqGRpnzeX52Ar2Ip+EBCyODXwkm4KLoDf4nsmSCgDKTees2ElHVbQbYuRPhNlDj9S0XRiswlvA/eJB3CSSOfDupPnZ3m56ErKEOT9Y5dCIWqgctOpnfdZYt9Hj1x5YAYovM6EZH6GYhjJ949bhFWxkcgJ9299gks0yNP16VkyVMqn4cVNHSg6OpP295yYrbyAy8cFC26jhHgltusuFQ8qcfAbjljlZ48Jznt1d7jTX3yqLpnqlOnwT/zu/ES3z+Ca0X8z6Qc2oAuU/gOM3rGpwYL2j22oEm2bjWbP+1QkNsf9D5sMXuD+/Vbs/acOhb0ZB4iqmB6ZL+4YiJJIYkO+u4llNlf8iRJkOhTVo0b85KEJq9lTHS5vYfP7Qm3s+dM1Pz5a0mhPkRaIa7bFbPtFK52Wznx6kK0iNfmi17eG6uIe5IQOCEkcRNxasGVgp0pm5B5uhKyjEFAUDog6oBVbtnaXD1ARCXufiLGbTpydPBgP2O7T4+NeNgvkxEH8dCyqr1f+HDuywdETkaUi5KWxAMDtnxxBJ7WA0b3mcyvvkwNMdlBglsuMLn0hNK1rHzT5/gznKQTrmHvgxa+IqgVAUNGN85o9WhzeuZXzzRGstWdooPjtnhqVr959PK/4zYM5Pvwl9l6XPRvtnNu/OMs4XAaQoDv3KwH2uOmHrkmXGfUHJJbdEI+sMCPj6E+YIz83L1T+aOJQHNvuliA8bt6oOTJGTQD/fHG//IdW8ocRIo2pn/3kG7LoWoIfGG8q8+sHm5gGZR7S0A2wMeNK/7N3Qadw
 eCH0bAE0
 3JMu7sZsKOa6OJk0VQJkvTEB4QU0/Rn8q5p/11VGtjOekRdPahzZh2XDaUKxZuqNJOQVGfgZ+JZ+Qy8RE+gVUGFcLPMfkPBKD5fUbnve+vS8sUumnRExUnkZ+Bt4PDeaCq18U6jfmCUKvbK5cqdkPinj1dFOL3fsDafUTE0PahNVRpgTzHsGr2Y/HA3cXvCaYBkIvRS44Y44OnBrujhSC5WSdKsaticWD5s1PL4GBUVDaNOu6PzwHSGLnJwyz/LA2Y5ZHqRSjSgHcp0a2Y16VZTklPHgAQGsX1zJgyZt9e4EZRKEWTHNp5pfsHxYT2HMJEbTZcbvOO8Mxct0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muhammad Usama Anjum <usama.anjum@arm.com>

For allocations that will be accessed only with match-all pointers
(e.g., kernel stacks), setting tags is wasted work. If the caller
already set __GFP_SKIP_KASAN, skip tag setting of vmalloc pages.

Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
APIs. So it wasn't being checked. Now its being checked and acted
upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
defined there.

This is a preparatory patch for optimizing kernel stack allocations.

Co-developed-by: Ryan Roberts <ryan.roberts@arm.com>
Co-developed-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
 mm/vmalloc.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b31b208f6ecb3..c94fcb2725b6b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 				__GFP_NOFAIL | __GFP_ZERO |\
 				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
 				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
-				GFP_USER | __GFP_NOLOCKDEP)
+				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
 
 static gfp_t vmalloc_fix_flags(gfp_t flags)
 {
@@ -3980,6 +3980,9 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
  *
  * %__GFP_NOWARN can be used to suppress failure messages.
  *
+ * %__GFP_SKIP_KASAN can be used to skip unpoisoning of mapped pages
+ * (when prot=%PAGE_KERNEL).
+ *
  * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
  */
@@ -3993,6 +3996,10 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
 	unsigned long original_align = align;
 	unsigned int shift = PAGE_SHIFT;
+	bool skip_vmalloc_kasan = gfp_mask & __GFP_SKIP_KASAN;
+
+	/* Don't skip metadata kasan unpoisoning */
+	gfp_mask &= ~__GFP_SKIP_KASAN;
 
 	if (WARN_ON_ONCE(!size))
 		return NULL;
@@ -4041,7 +4048,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	 * kasan_unpoison_vmalloc().
 	 */
 	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
-		if (kasan_hw_tags_enabled()) {
+		if (kasan_hw_tags_enabled() && !skip_vmalloc_kasan) {
 			/*
 			 * Modify protection bits to allow tagging.
 			 * This must be done before mapping.
@@ -4054,6 +4061,12 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 			 * poisoned and zeroed by kasan_unpoison_vmalloc().
 			 */
 			gfp_mask |= __GFP_SKIP_KASAN | __GFP_SKIP_ZERO;
+		} else if (skip_vmalloc_kasan) {
+			/*
+			 * Skip page_alloc unpoisoning physical pages backing
+			 * VM_ALLOC mapping, as requested by caller.
+			 */
+			gfp_mask |= __GFP_SKIP_KASAN;
 		}
 
 		/* Take note that the mapping is PAGE_KERNEL. */
@@ -4078,7 +4091,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
 	    (gfp_mask & __GFP_SKIP_ZERO))
 		kasan_flags |= KASAN_VMALLOC_INIT;
 	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
-	area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
+	if (!skip_vmalloc_kasan)
+		area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
 
 	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
-- 
2.34.1


