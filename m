Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0D75606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 17:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WUqKp8IB
Received: by kanga.kvack.org (Postfix)
	id E7D596B05C4; Tue, 10 Nov 2026 12:19:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E34FA6B05C5; Tue, 10 Nov 2026 12:19:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF5726B05C6; Tue, 10 Nov 2026 12:19:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0DF66B05C4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:19:33 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C5851409E6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:19:33 +0000 (UTC)
X-FDA: 85419871026.10.3F57850
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3EC6A40011
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:19:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WUqKp8IB;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794331171;
	b=zqFo8pccmKv7o/rIwipZaoDa3hwKjDBbfMmCsCf2hgojzwTB3mXnSQtOfccIEt0WaavMSN
	JAZl3tuYIxGjS5hF/FdsueGf7Tx6LaOf4F2kB5ra8DvdsOHUbGMvu6QkXCwi01lvJENDpU
	d+tIdQlUzorL09PHCXb9odq/osZe+xc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WUqKp8IB;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794331171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyJSAOI5cV0OZGbq6jv4rygFqgWHpSF5mbAAv1LcAlc=;
	b=49+8IPY4Hs/IKeQQ6zcFSNhdGSMb4NNeuqZZuGfYbdKdgYjsOnIrnGCcN2KlVGEEprWq06
	o9R6nAtfhWzfthmOZ0G5ONGq97pcEtlbSfTRwNCXoR/tY7tikQMxLCcsX3Kn9wYoyW4Ryr
	YmXDoL04HFx63tLH5HcpECpSDpz8KSU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 86ADA43530;
	Tue, 10 Nov 2026 17:19:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AF61F008A1;
	Tue, 10 Nov 2026 17:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794331170;
	bh=HyJSAOI5cV0OZGbq6jv4rygFqgWHpSF5mbAAv1LcAlc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WUqKp8IBFer85bnNOk/GOLP5YcXGtPvGoq98qr8JaB/oDyynxkHd2pe1tBBXiBjfz
	 mQddxWnP0TI4X4nUiclpz7v0TFphw89j+dwn/6S9ckj2voxSViM/4FSEOXE/KgsqHO
	 Q+kIQyQGpuaCDnO9WJ4vtHeNujAZEkBxYjVlsHZU2LI0BJUT0Twlp4+JsfDRYffJCx
	 kSvDQtekguoO+a/kblY4CuM2gOOdqJb8q8f3gZ9gL/YDSdHuXWi6/2PdgIQFJ3WgLQ
	 V3rc2NuONIKym2WThsgXPEvWLCRNSW6mn60Ye9pczhk4O7rkS5sISbQ48vFYcQYziK
	 yFE70+yOv/Bgg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 17:19:12 +0000
Subject: [PATCH v3 2/3] mm/khugepaged: scan mm's more efficiently under
 mmap_lock contention
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-khugepaged-latency-fix-v3-2-6eea743cf9a3@kernel.org>
References: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
In-Reply-To: <20261110-khugepaged-latency-fix-v3-0-6eea743cf9a3@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6746; i=ljs@kernel.org;
 h=from:subject:message-id; bh=/+O/N71sBontPdzFFvWWsWrpO/LB8NaZnq+rO9eNFgk=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI+B4nKv+DmPJn/KTWww2l1qumRcNNPnw6eNnGUWJHD8
 0NNP7m7o5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABNRXcfIMGeVwsHiE6unl/UL
 Zk1kuzW1OqpVU/C53d9FCvlyGvGZsgz/vaoulRba/t/9KfVvx4a/bPYSDPu+6R+7yb+9nv3Nv/0
 TWQE=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3EC6A40011
X-Stat-Signature: fcsp3ae6o31r4bgxn9bkjbpgdseawjr3
X-Rspam-User: 
X-HE-Tag: 1794331171-583407
X-HE-Meta: U2FsdGVkX1/+IlIHxVRTmaivR0/kpDsxZTT5Ifiu8rBvPAykrdgJX7xnCZ33DVZAkeZxLbOjvEaK/ZHMqEa08U9+kBsBtDV2UsGSkoHId+U74cmLpXp5xYiM8USRe21TtmLUJNI0vYeZ6eAawB1T0ShXi0nTWtUShvknyogLWfy6JQqk5K6Ve9LpEB4JZCu7q/BpYU4JBQemGI/ROcqp0xhIwSzHZCAr8aL4c1vfpg4Gr8GhfylLipodJE5espad/+JmRG9veFQP5v+MJzmUM3iPiSM6MDIshg8Knu3K7KzaUey8ELBbpDu9ZX6SnSU5OD2lOOmWPq8Jj1TjJcBjUfwK4j6p4iGrgDI5eWGRbHzdliXjcaCqpdmK85KbWVG9IrHJi2f8P8ADV+kt6sOu/bgXzqDKkXWFELjrtEM3agKW4V2PyTu7gRTZuRM2nl+lkUvdOs7k5i6zSTFbCVlQQPmsly1cxsOUmWtNYsdFLfb52CicxGaqwNky/t8Q1k01pt/mZMPj/XgbJAFYbxs1+TE+OlCllWziMXLGb5aRfg4QKkl/bBel4qTmareS1O/RSt81GWshVHiE6ObvWXFSvWM/BvCzy5RIXlxSy5Sjps7UgFFtK8zXTo4lCrNL6WqopIPzb8tDV3l7bmSiAfy8PphmVritmTwRJvIegduedd35YFIpsLLVBIklB/TV7kj45efdWc1qrZg2dmHu4bY5FA7gPIMnFApb79Sr/Uv8WnUYzJfqE8xop1J2hEhJsJq6YScXGECyh9Ngrk1VmtVlrRVAF3pMRssvzuk9xDN5qhRGA2b7GAc7WOYeZ/ri7Pj+IQQEhYxVBncFssj5BZhwP9EHlScvGeID2JXLgVvlvns3hQ+m3gwxFIYaj7+f2mFyNeGnLnuaAHZB15RCLvyY59MjlNYiJzvIZpL8BQSvH5r5K99Ica4B8I0NjThtBonxIW8KiuTuADK4vnL0E/Q
 F6Rp2yrb
 dJjztWtTO5GfX28oN45ERvmGIGAIStekERYtjl9uHCYDtpPElSnertEv9NVvPdZ8o2htvujU0qnuw3n4WV5ExPZqSjsfOB+rZS2W7MEBkuoECv3fKeoXCJQV2FLt21ncdqdgu1fxF9vcItjsiBUHpP9022fldpduPI7qBaRJQjSOZokjnR9SCHMn/hJiaXkmpsbnFAHMriNm3KLCLc1u1/1eR67TfhafxFvoIvMrZBH2Nxd9kilZUFnlxg7AjWRVV1LRrEaVcdyOpUJExrfTHgsjbGj1bgWIZskLz+cIjNq2DX7xVORUqMEQp2Gl/X9Xkl4juxbDiI9L0umq4QNiv8rmSMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

khugepaged scans VMAs in collapse_scan_mm_slot() in the same mm until it is
about to be torn down, prctl(PR_SET_THP_DISABLE) disables THP for it,
mm->mmap_lock contention occurs, or all its VMAs have been scanned.

When lock contention causes the function to bail out, khugepaged doesn't
keep track of where it left off, so when the mm is next scanned, it starts
from address 0 again.

If there's a lot of mmap_lock contention this can significantly slow down
collapse later in the mm, since the /sys/.../pages_to_scan budget can run
out before the end of the mm is reached.

The budget is incremented (as tracked in cc->progress) at a rate of 1 page
per ineligible VMA, but the budget is only checked once eligible VMAs are
encountered.

Then, it only takes the combined total of ineligible VMAs and eligible but
non-collapsible pages to exceed the /sys/.../pages_to_scan budget for the
rest of the mm to be skipped.

For a system with 4 KiB page size and default sysctl settings this only
requires 4096 ineligible VMAs/uncollapsible pages to be skipped before this
happens.

Resolve the issue by simply tracking the last examined address in the
khugepaged_mm_slot object, so when the mm is resumed, the scan starts from
where it left off.

Additionally, skip to the next candidate if a VMA cannot be collapsed.

This issue was noticed during some work in which an mm was instantiated
with a large number of small VMAs under significant mmap_lock contention,
during which collapse was observed to take 10.8s. With this patch applied
it took 3.6s to collapse the same mm.

Also, while here, update a couple VM_BUG_ON()'s to VM_WARN_ON_ONCE()'s.

This patch is also a prerequisite for the next patch in the series.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/khugepaged.c | 46 ++++++++++++++++++++++++++++------------------
 1 file changed, 28 insertions(+), 18 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index aad8797f8d5a..7d1414a9b2a5 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -69,23 +69,23 @@ static struct kmem_cache *mm_slot_cache __ro_after_init;
 /**
  * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
  * @slot: hash lookup from mm to mm_slot
+ * @address: the next address inside that to be scanned
  */
 struct khugepaged_mm_slot {
 	struct mm_slot slot;
+	unsigned long address;
 };
 
 /**
  * struct khugepaged_scan - cursor for scanning
  * @mm_head: the head of the mm list to scan
  * @mm_slot: the current mm_slot we are scanning
- * @address: the next address inside that to be scanned
  *
  * There is only the one khugepaged_scan instance of this cursor structure.
  */
 struct khugepaged_scan {
 	struct list_head mm_head;
 	struct khugepaged_mm_slot *mm_slot;
-	unsigned long address;
 };
 
 static struct khugepaged_scan khugepaged_scan = {
@@ -2921,7 +2921,6 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 		slot = list_first_entry(&khugepaged_scan.mm_head,
 				     struct mm_slot, mm_node);
 		mm_slot = mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
-		khugepaged_scan.address = 0;
 		khugepaged_scan.mm_slot = mm_slot;
 	}
 	spin_unlock(&khugepaged_mm_lock);
@@ -2939,7 +2938,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	if (unlikely(collapse_test_exit_or_disable(mm)))
 		goto breakouterloop;
 
-	vma_iter_init(&vmi, mm, khugepaged_scan.address);
+	vma_iter_init(&vmi, mm, mm_slot->address);
 	for_each_vma(vmi, vma) {
 		unsigned long hstart, hend;
 
@@ -2948,38 +2947,46 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible_orders(vma, vma->vm_flags,
-					      TVA_KHUGEPAGED)) {
+		if (!collapse_possible_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+			const unsigned long next =
+				ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
+
 			cc->progress++;
+			/* Check for overflow. */
+			if (unlikely(next < vma->vm_end)) {
+				vma = NULL;
+				break;
+			}
+			/* Unable to collapse, skip to the next candidate. */
+			mm_slot->address = next;
 			continue;
 		}
 		hstart = ALIGN(vma->vm_start, HPAGE_PMD_SIZE);
 		hend = ALIGN_DOWN(vma->vm_end, HPAGE_PMD_SIZE);
-		if (khugepaged_scan.address > hend) {
+		if (mm_slot->address > hend) {
 			cc->progress++;
 			continue;
 		}
-		if (khugepaged_scan.address < hstart)
-			khugepaged_scan.address = hstart;
-		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
+		if (mm_slot->address < hstart)
+			mm_slot->address = hstart;
+		VM_WARN_ON_ONCE(mm_slot->address & ~HPAGE_PMD_MASK);
 
-		while (khugepaged_scan.address < hend) {
+		while (mm_slot->address < hend) {
 			bool lock_dropped = false;
 
 			cond_resched();
 			if (unlikely(collapse_test_exit_or_disable(mm)))
 				goto breakouterloop;
 
-			VM_WARN_ON_ONCE(khugepaged_scan.address < hstart ||
-				  khugepaged_scan.address + HPAGE_PMD_SIZE >
-				  hend);
+			VM_WARN_ON_ONCE(mm_slot->address < hstart ||
+					mm_slot->address + HPAGE_PMD_SIZE > hend);
 
-			*result = collapse_single_pmd(khugepaged_scan.address,
+			*result = collapse_single_pmd(mm_slot->address,
 						      vma, &lock_dropped, cc);
 			if (*result == SCAN_SUCCEED)
 				khugepaged_pages_collapsed++;
 			/* move to next address */
-			khugepaged_scan.address += HPAGE_PMD_SIZE;
+			mm_slot->address += HPAGE_PMD_SIZE;
 			if (lock_dropped)
 				/*
 				 * We released mmap_lock so break loop.  Note
@@ -2993,12 +3000,16 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 				goto breakouterloop;
 		}
 	}
+	/* Every VMA has been examined, so reset. */
+	if (!vma)
+		mm_slot->address = 0;
+
 breakouterloop:
 	mmap_read_unlock(mm); /* exit_mmap will destroy ptes after this */
 breakouterloop_mmap_lock:
 
 	spin_lock(&khugepaged_mm_lock);
-	VM_BUG_ON(khugepaged_scan.mm_slot != mm_slot);
+	VM_WARN_ON_ONCE(khugepaged_scan.mm_slot != mm_slot);
 	/*
 	 * Release the current mm_slot if this mm is about to die, or
 	 * if we scanned all vmas of this mm, or THP got disabled.
@@ -3013,7 +3024,6 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			slot = list_next_entry(slot, mm_node);
 			khugepaged_scan.mm_slot =
 				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
-			khugepaged_scan.address = 0;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
 			khugepaged_full_scans++;

-- 
2.56.0


