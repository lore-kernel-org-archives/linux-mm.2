Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C718FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:40:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 866626B00A0; Wed, 29 Apr 2026 09:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D4E6B00A1; Wed, 29 Apr 2026 09:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DF376B00A2; Wed, 29 Apr 2026 09:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4396B00A0
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:40:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1B1398A89E
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:08 +0000 (UTC)
X-FDA: 84711702096.27.B24FEBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 503BE4000D
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:40:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LJb8v1/h";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777470006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u11kOx0qSgfZ3Lz8QmF+bGDRYmL355hw50UAdmG9kDg=;
	b=haUx6W4+L8Dpwjhf9xmt3Mu6DeDw0XOL0YuQeFE65BFyvbXQ/BNr1bWToQubhJr7s4lI3N
	KYRp4ong5m2hlWYC2c0cimHSqKBguVDf2dSue9HyXZ8XjkUTpxrhZSu4lgGJ6ocVkjpMrX
	WPh0ervQmuTioNQ0wcXk+LYhdOkh32o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777470006; a=rsa-sha256;
	cv=none;
	b=71IMJ5WKSJyKGOp8P4UqE5oMOGJEiie1C81ezCSdotbOKJhavTjzvfaTtkXiBiiqeCHw8i
	01rudmREZx2teKXO/prBSi8AVfUfbkFjwPtWPl/HUwkGt1dd1t63fHrV8LnOKjKZTAU1Le
	yfJ2W04NfG42YtJezD7S/GHtGMnsHtg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="LJb8v1/h";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 70F9B44516;
	Wed, 29 Apr 2026 13:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E00C2BCC7;
	Wed, 29 Apr 2026 13:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777470005;
	bh=IHiLzF9pidNOJYX260CdZehqWF3kTGgKyTVeh/Y6T5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LJb8v1/h5ggsVkAcUDM2gHnjHQ5ZNE0SkWuM9Do3bFIL7WSg0SOVEX9YJi41meDtW
	 WDuCxpnW1ljTV4ZAzRiTYeb4aV1SO53NetPnmiFEtkGbbdzjrUHdqt8iqzBVjm4kYJ
	 z6q4T81iMtJ0NcpENL7TtU2ziJ1fZiHso9lukIiW9FlbT5yBye+sMUbQl8j66fDora
	 l9oZNpH6BJsiIKywHvuBPnF2GVkJmsHpis0yi/N5YYk9T+/eYKeXqrsPQ8zvsRbQ75
	 5mFGzhI/QYT/AI6wMNzyyrUGs5SJAzzY1ZO0Qv31MGqTtAumGT+b0IeZ805JEEr4hY
	 5gajINmizwp2A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/12] memblock: introduce MEMBLOCK_KHO_SCRATCH_EXT
Date: Wed, 29 Apr 2026 15:39:11 +0200
Message-ID: <20260429133928.850721-10-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
In-Reply-To: <20260429133928.850721-1-pratyush@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 503BE4000D
X-Stat-Signature: yix5hojkxgeeakkstq4594whkbanh9bn
X-Rspam-User: 
X-HE-Tag: 1777470006-405670
X-HE-Meta: U2FsdGVkX1+86nuYuooJ94m+ldh1QBJNbEsLwm/bHsNbsJIWlY8q/8JfQgkZN58c858sx5iwoxzJRLCJQ4Noq9JyIUlG73wtQJtF6hV0OGSyfC8/6ZKuJKlkhiKcGtCCyyTKAAIsd7Ut7ZJWZ9NKYKskherXq3X0nImJvPl43ir28xtRf8RPBN2sbvKbtsMp/th6m6hshWGk/HJpVDoGJIhLaPuigP/WdnoX2kojTADStuvRj0OrINnfuG4zQkFJaZP77GvFsDekl+MuAAtMNt3qdq925B23RoOD3Is4EZzqB1hvlwwZeKfp3QyTazX2jV8uQOYpa2fYiOyd5BB5l0OpKwwPf0NxFRkLlRyAvpyF5rwaIkDkrvr0CQosE0599wOJfoL+IBvEUXd99WBATqRUejbQEGAwybUYMRKcF5OlCmxJrzkRTnRR7iCJfodP1AmgCc6WMK8QReew7aohu0pw60I4fe0znBETn3arDJr6zbBtgrjpW3ebaHDX9fYLF5pQsRhXGfnGQvGkoylPCNmAtFWdzBzsi20JvPMTRWQdRDl3M9PF/HggSWpk4z+cgDxP5WLtnsNGGrGAlXUia8cS3RXO1QvsiKVDHMkcdti5ubhvZOlTpOTZozxamyCBai7FWnICxS0jNqlHiLPKCJDXWHB6CPAciYQ1mPQi/VPnbMnmqAFTQs0HfKJOOB6/2PpcP6ZH9ug2BRhae5AWO540SmgOaCAfEfv4jEOx5iThNyP/v5m4V2/Xr8f0ihN301o7vbbzAl9k7GmR+I1/LRviOV+SBMRihifLvAYZ5QJRBS3I26MiU4SXaZF9RB5QWV1K1NMMDTMF/F5QAe3NAbjcM8DPEALDkURpkcqAX7eugVLKD0hxVMhgRs8efRO+gQIgHfvOyZ9QMgEJ28zn17WsIwJbMCedScOIw25lGqN5GXcE7uv3U1mTG9qVsUyJTXFlXdiMXOrV+Hr/P8k
 MfYGi/bN
 EBOioPhW+w4/09iGiU57t674r6JBW14FeRrBSSD7LyPoong9pHxzVyg3nPuZ+exlsHiL/8SeIH0Qs8OYyF4EXpWUS9oPToUvw1CR4NR6J2+6n2b0cndMbqns//l/nuBDn+n3Mx0WbfalW0F8/V7fMl5l2r+L5U82FdkCGmuQ1kFKHnBBssm4pL6qyYrXCeHrxwmNhvFJ6SWogVet7MXpmW7TMYPr6J3gsQ09BqEF6IG2hjrdDWXzZLHBd0Jg9FP+J0h07kwfS3lJI7Z/hgn9NdXQzBQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

In the upcoming commits, the KHO will learn how to discover free blocks
of memory by walking the KHO radix tree. It will then mark those regions
as scratch to allow memory allocation in case scratch runs low.

To differentiate the extended scratch areas from the main scratch areas,
introduce MEMBLOCK_KHO_SCRATCH_EXT. Use it when choosing memblock flags
for allocations during scratch-only. Teach should_skip_region() to check
for both flags before deciding if the region should be skipped.

Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---

Notes:
    Checkpatch complains about no space after MEMBLOCK_KHO_SCRATCH_EXT in
    the declaration, but doing so makes it nicely align with all the other
    numbers. Mike, if you'd like I can add some whitespace.

 include/linux/memblock.h | 10 ++++++++++
 mm/memblock.c            | 41 ++++++++++++++++++++++++++++++++++------
 2 files changed, 45 insertions(+), 6 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5afcd99aa8c1..4f535ca4947a 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -51,6 +51,9 @@ extern unsigned long long max_possible_pfn;
  * memory reservations yet, so we get scratch memory from the previous
  * kernel that we know is good to use. It is the only memory that
  * allocations may happen from in this phase.
+ * @MEMBLOCK_KHO_SCRATCH_EXT: same as MEMBLOCK_KHO_SCRATCH but was discovered at
+ * boot time by finding gaps in preserved memory instead of being passed from
+ * previous kernel. Does not get passed to the next kernel.
  */
 enum memblock_flags {
 	MEMBLOCK_NONE		= 0x0,	/* No special request */
@@ -61,6 +64,7 @@ enum memblock_flags {
 	MEMBLOCK_RSRV_NOINIT	= 0x10,	/* don't initialize struct pages */
 	MEMBLOCK_RSRV_KERN	= 0x20,	/* memory reserved for kernel use */
 	MEMBLOCK_KHO_SCRATCH	= 0x40,	/* scratch memory for kexec handover */
+	MEMBLOCK_KHO_SCRATCH_EXT= 0x80, /* extended scratch memory for KHO */
 };
 
 /**
@@ -157,6 +161,7 @@ int memblock_clear_nomap(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_noinit(phys_addr_t base, phys_addr_t size);
 int memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t size);
 int memblock_mark_kho_scratch(phys_addr_t base, phys_addr_t size);
+int memblock_mark_kho_scratch_ext(phys_addr_t base, phys_addr_t size);
 int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size);
 
 void memblock_free(void *ptr, size_t size);
@@ -304,6 +309,11 @@ static inline bool memblock_is_kho_scratch(struct memblock_region *m)
 	return m->flags & MEMBLOCK_KHO_SCRATCH;
 }
 
+static inline bool memblock_is_kho_scratch_ext(struct memblock_region *m)
+{
+	return m->flags & MEMBLOCK_KHO_SCRATCH_EXT;
+}
+
 int memblock_search_pfn_nid(unsigned long pfn, unsigned long *start_pfn,
 			    unsigned long  *end_pfn);
 void __next_mem_pfn_range(int *idx, int nid, unsigned long *out_start_pfn,
diff --git a/mm/memblock.c b/mm/memblock.c
index 01a962681726..79443e004361 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -182,7 +182,7 @@ static enum memblock_flags __init_memblock choose_memblock_flags(void)
 {
 	/* skip non-scratch memory for kho early boot allocations */
 	if (kho_scratch_only)
-		return MEMBLOCK_KHO_SCRATCH;
+		return MEMBLOCK_KHO_SCRATCH | MEMBLOCK_KHO_SCRATCH_EXT;
 
 	return system_has_some_mirror ? MEMBLOCK_MIRROR : MEMBLOCK_NONE;
 }
@@ -1178,8 +1178,9 @@ int __init_memblock memblock_reserved_mark_kern(phys_addr_t base, phys_addr_t si
  * @base: the base phys addr of the region
  * @size: the size of the region
  *
- * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH will be considered
- * for allocations during early boot with kexec handover.
+ * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH or
+ * %MEMBLOCK_KHO_SCRATCH_EXT will be considered for allocations during early
+ * boot with kexec handover.
  *
  * Return: 0 on success, -errno on failure.
  */
@@ -1203,6 +1204,23 @@ __init int memblock_clear_kho_scratch(phys_addr_t base, phys_addr_t size)
 				    MEMBLOCK_KHO_SCRATCH);
 }
 
+/**
+ * memblock_mark_kho_scratch_ext - Mark a memory region as MEMBLOCK_KHO_SCRATCH_EXT.
+ * @base: the base phys addr of the region
+ * @size: the size of the region
+ *
+ * Only memory regions marked with %MEMBLOCK_KHO_SCRATCH or
+ * %MEMBLOCK_KHO_SCRATCH_EXT will be considered for allocations during early
+ * boot with kexec handover.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+__init int memblock_mark_kho_scratch_ext(phys_addr_t base, phys_addr_t size)
+{
+	return memblock_setclr_flag(&memblock.memory, base, size, 1,
+				    MEMBLOCK_KHO_SCRATCH_EXT);
+}
+
 static bool should_skip_region(struct memblock_type *type,
 			       struct memblock_region *m,
 			       int nid, int flags)
@@ -1236,10 +1254,20 @@ static bool should_skip_region(struct memblock_type *type,
 
 	/*
 	 * In early alloc during kexec handover, we can only consider
-	 * MEMBLOCK_KHO_SCRATCH regions for the allocations
+	 * MEMBLOCK_KHO_SCRATCH or MEMBLOCK_KHO_SCRATCH_EXT regions for the
+	 * allocations.
 	 */
-	if ((flags & MEMBLOCK_KHO_SCRATCH) && !memblock_is_kho_scratch(m))
-		return true;
+	if (flags & (MEMBLOCK_KHO_SCRATCH | MEMBLOCK_KHO_SCRATCH_EXT)) {
+		bool skip = true;
+
+		if ((flags & MEMBLOCK_KHO_SCRATCH) && memblock_is_kho_scratch(m))
+			skip = false;
+
+		if ((flags & MEMBLOCK_KHO_SCRATCH_EXT) && memblock_is_kho_scratch_ext(m))
+			skip = false;
+
+		return skip;
+	}
 
 	return false;
 }
@@ -2799,6 +2827,7 @@ static const char * const flagname[] = {
 	[ilog2(MEMBLOCK_RSRV_NOINIT)] = "RSV_NIT",
 	[ilog2(MEMBLOCK_RSRV_KERN)] = "RSV_KERN",
 	[ilog2(MEMBLOCK_KHO_SCRATCH)] = "KHO_SCRATCH",
+	[ilog2(MEMBLOCK_KHO_SCRATCH_EXT)] = "KHO_SCRATCH_EXT",
 };
 
 static int memblock_debug_show(struct seq_file *m, void *private)
-- 
2.54.0.545.g6539524ca2-goog


