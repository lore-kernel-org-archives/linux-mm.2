Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A232F606A330
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C9PRLCVq
Received: by kanga.kvack.org (Postfix)
	id 67D116B05B5; Thu,  5 Nov 2026 15:57:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7E96B05B6; Thu,  5 Nov 2026 15:57:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6C66B05B7; Thu,  5 Nov 2026 15:57:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 227346B05B5
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:57:51 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D8C1160C09
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:57:50 +0000 (UTC)
X-FDA: 85402277100.11.DFF4013
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id C9228140004
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:57:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C9PRLCVq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793912269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QfJg8wkFPeif1+e98mwm8oEPJ/2Ruuy8X0jDmVvrlO4=;
	b=H6JT/28IDNND8Fb6c6shrXufwjHnpkJ6J7tsXHuY7FNkJEotTA0JzsGTFIoU1XQ2H1FKTn
	wIL/FM8DvW6Fb+pQcxeD//RpnEQsmlJfaqL2aDGWCDv0dLs/RPgUfqQyo15Lsi27w1P8KP
	AE/WSw6H2Tr5b4FvV0TCSI1xNvp/zsY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793912269;
	b=bR9TZFgPY6sY1YfGGjqtD11UfSvHHYPxJ5mck+E0U2hiPNLjfpNH1qqwiz9pm/b27S27es
	1UfA1wqlZHBMZ+lp1FpYCJ0SEE7Glg7Pj4fWILExXIt9y98pDrXR34hj4ijobLwtuckDf6
	PKt6DrJUflri9x2yo2nFlo8ensPsmEQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C9PRLCVq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C46740735;
	Thu,  5 Nov 2026 20:57:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E825E1F008A6;
	Thu,  5 Nov 2026 20:57:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912268;
	bh=QfJg8wkFPeif1+e98mwm8oEPJ/2Ruuy8X0jDmVvrlO4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C9PRLCVq9Hxv5W1z4+P9L1x56gY2K2TKoPRUr4Dz6ZOCqf619N3jfuUuHtyMvHvFA
	 goEDfiaU6p5euWj6UJmvCbq4z5SGk4ERxOMd6VDt7FTHbzUrT+xxOvijkA5wxjq9v9
	 iWDYU+6GJDYitX7lZuiIsEx8qD4kVVl/vHy38T8+uaawJ4yHdgvBpmSzjDV486LT8d
	 fbJKZ1GFfRprc2cgPAGuOpsBg2aCxh4VXXwuSdJO2rf+TlGRJoP5qKfUI24RXd6+Pr
	 QD+F0AECKGGwv3w4RozSM5tLKyV7oYE4WTXQV6p/RON/z3CezGMhOT/DQX3nyVF3fv
	 /oadnkNpbiJ7Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 20:57:23 +0000
Subject: [PATCH v2 2/3] mm/khugepaged: scan mm's more efficiently under
 mmap_lock contention
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-khugepaged-latency-fix-v2-2-4384bbfe4606@kernel.org>
References: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
In-Reply-To: <20261105-khugepaged-latency-fix-v2-0-4384bbfe4606@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6463; i=ljs@kernel.org;
 h=from:subject:message-id; bh=majzr9fTZ+ztvtfMwTgPIbuLZbdLbln8kr4/AIX1TW4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevD1YdfOA4cSSU8saCoQdj7/SkbNKqp7xIqtGOVip+
 cDidctXdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiu7cwMqycLJRrE2nJaFSU
 sfdzd1i/uPB9u0de9yfKBj2IM/m/1Jvhf8qhr2EFjpo9d7wvtGwvkV4Tys/pfHVla+npuSvPb9y
 uxQIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: w5cxte3mm5xhut33gzgfc1cxi91gueqz
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C9228140004
X-HE-Tag: 1793912268-377218
X-HE-Meta: U2FsdGVkX1/ZeCxgZ8Ng3wp8s9Tq83CA7wKpWO/lj5yxn/hgRGKfC7kydHYN80y6K3ty+tqRiCLaYCBqChw6mvorLI7btVBCBvqdvrjhLQI2WkPs4icMjvGzyuy+DHCNm5kc11agzzdsWyivNFNGB9I/GNhyUQhA0Or8zlpI2vHlV94DYycGglhw6fbBvV2ffVvGbrChlK+XWSVDXaNFSsML99ORcF7QHl2ZKjYZBv5GtFMbSzgjARFTLWxFxJqArgyF3H20NlutABn3P7qLe3u+IlbAind4ISj7UlfKMc2v8S1z4ItMwAN5Qn5chAt3wckBzeUkYqoA1zoRPhbNrp1MvhfU6F56Upcp1v3ZAu0UJwB7zUK8mW9Vz1F5RFsqB/mWrjY79px6A7qFYv6IQ8IIffIBA9KfMoMMQqv9/eiOrQ+7EJzBCia2kTNGcnAuGNV+NA3OP72g1bqBge/i8t3PX5VOZcKzIIDD6bgh6WxwOB2JfzU+1w2ZQ75xwzOHRlg/jrdULtMzlO+uEm1ukVsFQUbmHaaic8zj/jZfVu/xm+TggwS/xRaXt3UHQ+EBHN9fgUf8SsdTWoS5grIuiQAt/T2vaeTiU4mgSteEWancMDGTsbbRxLGYRBFFVDrq0cWgnWsqnXfRQo3E32qZQjzM3+gg2SSaJA00I7l/VV8J3wXQzNEazvAyA/L4feGb68+0K0lKaCqdmcXTiBBFst773SDwdwvVpNrt6TJCIYEbtI/cmEiF4dhfpOD7H9tSLyaxdb6nR2ELSwoucWjLHuKnAcMbjCFx9uGiSATfLx6Zk/9+fP+Ss30jB0bgsAsgsgt33FYpP7k41zUMwwlM0kMYXkLQ9AKhKWggow8sXwx1aRNx76I19vdYzy4BVspMiAxBBFw6VmtL8pOw5cK6Cojx6duVtFszj9z3wHewtzjmAh3yrP88PT5pAXa/Dp9bdYqXmPQdXR7VanH9/Ab
 Fcmyv9yy
 ofrcpK5iNHAZl8uWyS7u08V28fOTdIC8jv3i0M5xg0n69fCyBj52TrlA1KZhdotIrfQG/hPYLpuJ7shDNW/vA9/aqkMUlYwm68/wrbKOx2qok70EDWlbCL5+MKB7KUbDgTaGOsk0BJh3AdabOLMxlwQWJLEAP+RWe6hee80Ut5ZCmtAkzq11vHdTBVr0NO8Gtp4sB4NjtKTEiccwIQ7xNvYPkbLXVeAJkpH3sagJtFEa3rTwl9NlxqH/ohJBCnL90lkiIv0fpAfp0kJieOAB5E4S+Qff/Pm24ECk7reSNR3b56Vg=
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
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/khugepaged.c | 38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index aad8797f8d5a..216c4b8d28c4 100644
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
 
@@ -2948,38 +2947,38 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			cc->progress++;
 			break;
 		}
-		if (!collapse_possible_orders(vma, vma->vm_flags,
-					      TVA_KHUGEPAGED)) {
+		if (!collapse_possible_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
+			/* Unable to collapse, skip to the next candidate. */
+			mm_slot->address = ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
 			cc->progress++;
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
@@ -2993,12 +2992,16 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
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
@@ -3013,7 +3016,6 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 			slot = list_next_entry(slot, mm_node);
 			khugepaged_scan.mm_slot =
 				mm_slot_entry(slot, struct khugepaged_mm_slot, slot);
-			khugepaged_scan.address = 0;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
 			khugepaged_full_scans++;

-- 
2.56.0


