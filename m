Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 089B4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 05:01:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E880E6B0095; Mon, 13 Jul 2026 01:01:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E38E66B0096; Mon, 13 Jul 2026 01:01:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D756A6B0098; Mon, 13 Jul 2026 01:01:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2C5C6B0095
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 01:01:22 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 45B5D1C9530
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:22 +0000 (UTC)
X-FDA: 84982554804.10.30028EE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 64E8840007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 05:01:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jxHAmGsj;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783918880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFjiQ+Lukl9aahtW5kZyLFmjkM3bZRQjyI7Tw4Ekqpg=;
	b=EDbGbse6LHIKIrw2hA+cRPlVzdQR9NH21X5xw8v0lDPNDmvvSnAZLB3wF+n1ViOUHIX2xI
	PGJd1v0PP48KXKtd3aAC/394BuqCw0vszWnODnDhPNDLPLwbMLbtjnyEr45+TAdnoIOPNz
	kZeWnPl6pB3k/thtCpT2t7boJkRLAto=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=jxHAmGsj;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783918880;
	b=1vdY+E1fvTJhiSENC1qt6aj/qtD0znEt+Nz/5UZJ2UxrsyUwQa8/PsCzcg1xukGFsaYoqB
	JdMV0GxJrGiSCTvs/KhwbvQQ7TS/JGBhYo82SlF5c7QLthcdnB13TyvlgjupiFcUpvpavr
	TI/HPzo4MSez3ilvwUT1xiS73lMjH1U=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6D7361655;
	Sun, 12 Jul 2026 22:01:15 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2A1873F93E;
	Sun, 12 Jul 2026 22:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783918879; bh=SvhKsGVBha/6Pbjr3cHzdJEAYRNO3VDq0Q/GPRDynEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jxHAmGsjRn6Ql2PbTCFfAJ+nX8wPkP/WElYcRhp597N74uY83LwWm5qbJjiF1ZdS3
	 QmyB4BcGQaGWb8xtc2OidD+cAG81YyApQfZNL5GhgvraXO6kM43oh993LMXw2OTN+f
	 z41PJB01HGUP39vt4hzj/VTj72chLIgBpyY27V5M=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 3/5] mm/rmap: refactor some code around lazyfree folio unmapping
Date: Mon, 13 Jul 2026 05:00:46 +0000
Message-ID: <20260713050050.1017741-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260713050050.1017741-1-dev.jain@arm.com>
References: <20260713050050.1017741-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 64E8840007
X-Stat-Signature: eezk691eg1h7xug91sqopcofxzrxut8d
X-HE-Tag: 1783918880-951288
X-HE-Meta: U2FsdGVkX1+kXQ8yvg/saL4/eBfJ9asGJfBr94+3LOUF8fbLNV8/V2QjnUOHoyJtkO0RJhGU2lfVc0ZsicZXP4h9gyuPlfvR5iunlYR02zlCzTYRQLnhx4pqAb6jutfoEaxX56TtQf5zMA+jaRR3svDBYQUoxRHZnVwfnkjA5GTCZlvPQAvB/5eEBIG381kVfu5MKUl4fVwmCQDMVcd/M1wNc9bQ1h9HGJUG78aHmZqqBqsjEQFXmSIdaloq0QhKE1DDSxpzTqhp4Y2QLoKJSBbrbb+K8aa8wSfTsbFMJk9ySVt/h+WQuMeLw0wIIRCkXFsRVLA8f61+KrG35VLEZFKOS3CDklFmkSlB/tyB0UXlbn3J/DbvYaiRCo2HLbx4VbrPILp+ee7SIczePop6UBidCmKI/of44tRKJVK9D7qqOtxzuB+iK8ROjshMu752Zbh/lddNOfSjaw8NYj9rHrUm/WljME2Z6SVMmz7wZmvufEX9XbjVLGvROTCQ2Z/kARX9jXTA6Hvlts+eQFQ3i7j4UvzyKltdLc2eZw+WS0d2MMTzYMr9apG2CgHHW6yCVCaPWgRRRKixonPiWCheooTZ9QR1QKxooQ83IxDCuRrvR5tV2L/iSRlP90+sARJHKWmOy86uODnCFBerqHWVjqsznTalSKbmhQlgoX9eO8bUN+AWXIQEfyXX4+UZxdagoR2xmSxObxeYKh+BEfdVQcM4rzZAyVSyomqFzaf2CBOc8+lkToyRR7mOEAGHROl1vJrMIguxkiYDOn/OWFUTecO1KZZfTmhL8ToG9GIscRZOOXrOC2ev2k+nYCRqZObxYVSRD5ca2WSsca+peSykuFMFm09+1s7lOe6+QmiuMG3XYqORovL542MxA07olbOx5/PFrAu8VjOvLtTKL64qyVMYQsgRcz+Yol0HmrpnsTPFjbFkk/uv6U35JqPMChmjWokeJV5K5NWY19a+SD2
 TJG8jfUB
 VYib7ujwusMeuwH52YhcrAkeCly8e1TpHVbUXarWTlsiyuMr3W8FsAS+59fcWg97dr8u0Qo7nb4xFJJdt0RSoXzMxgWFs1y7vA7sxDgRrn5PuylvsfBavdqNUoRXAmFx+bofkFkw7p0Cw5Ol1IQDz2tvWFYo5RO607gPEzpY3fRI9hYQyy/rypjjInq/eakFRHFMGs0XF48yWuvFWEbTnbp9mUR27rlCl3nOI2NW23OT8ZnsoA+rL1ELUuDNu8oMj9VYC4F+XxTq9T7k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For lazyfree folio unmapping, after clearing the ptes we must abort the
operation if the folio got dirtied or it has unexpected references.

Refactor this logic into a function which will return whether we need
to abort or not.

If we abort, we restore the ptes and bail out of try_to_unmap_one.
Otherwise adjust the rss stats of the mm and jump to a label.

Also rename that label from "discard" to "finish_unmap"; the former
is appropriate in the lazyfree context, but the code following the label
is executed for other successful unmap code paths too, so 'discard' does
not sound correct for them.

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 87 ++++++++++++++++++++++++++++++-------------------------
 1 file changed, 48 insertions(+), 39 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 7720c49ada4c3..4465c88ddb77b 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2068,6 +2068,50 @@ static bool try_to_unmap_hugetlb_one(struct folio *folio,
 	return ret;
 }
 
+static bool ttu_anon_lazyfree_folio(struct vm_area_struct *vma,
+		struct folio *folio, unsigned long nr_pages)
+{
+	int ref_count, map_count;
+
+	/*
+	 * Synchronize with gup_pte_range():
+	 * - clear PTE; barrier; read refcount
+	 * - inc refcount; barrier; read PTE
+	 */
+	smp_mb();
+
+	ref_count = folio_ref_count(folio);
+	map_count = folio_mapcount(folio);
+
+	/*
+	 * Order reads for page refcount and dirty flag
+	 * (see comments in __remove_mapping()).
+	 */
+	smp_rmb();
+
+	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+		/*
+		 * redirtied either using the page table or a previously
+		 * obtained GUP reference.
+		 */
+		folio_set_swapbacked(folio);
+		return false;
+	}
+
+	/*
+	 * Additional references could be due to GUP or speculative lookups.
+	 * GUP users must mark the folio dirty if there was a modification.
+	 * This folio cannot be reclaimed right now either way, so act just
+	 * like nothing happened. We'll come back here later and detect if the
+	 * folio was dirtied when the additional reference is gone.
+	 */
+	if (ref_count != 1 + map_count)
+		return false;
+
+	add_mm_counter(vma->vm_mm, MM_ANONPAGES, -nr_pages);
+	return true;
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2261,47 +2305,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 
 			/* MADV_FREE page check */
 			if (!folio_test_swapbacked(folio)) {
-				int ref_count, map_count;
-
-				/*
-				 * Synchronize with gup_pte_range():
-				 * - clear PTE; barrier; read refcount
-				 * - inc refcount; barrier; read PTE
-				 */
-				smp_mb();
-
-				ref_count = folio_ref_count(folio);
-				map_count = folio_mapcount(folio);
-
-				/*
-				 * Order reads for page refcount and dirty flag
-				 * (see comments in __remove_mapping()).
-				 */
-				smp_rmb();
-
-				if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
-					/*
-					 * redirtied either using the page table or a previously
-					 * obtained GUP reference.
-					 */
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					folio_set_swapbacked(folio);
-					goto walk_abort;
-				} else if (ref_count != 1 + map_count) {
-					/*
-					 * Additional reference. Could be a GUP reference or any
-					 * speculative reference. GUP users must mark the folio
-					 * dirty if there was a modification. This folio cannot be
-					 * reclaimed right now either way, so act just like nothing
-					 * happened.
-					 * We'll come back here later and detect if the folio was
-					 * dirtied when the additional reference is gone.
-					 */
+				if (!ttu_anon_lazyfree_folio(vma, folio,
+							     nr_pages)) {
 					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 					goto walk_abort;
 				}
-				add_mm_counter(mm, MM_ANONPAGES, -nr_pages);
-				goto discard;
+				goto finish_unmap;
 			}
 
 			if (folio_dup_swap(folio, subpage) < 0) {
@@ -2359,7 +2368,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
 		}
-discard:
+finish_unmap:
 		folio_remove_rmap_ptes(folio, subpage, nr_pages, vma);
 		if (vma->vm_flags & VM_LOCKED)
 			mlock_drain_local();
-- 
2.43.0


