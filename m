Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26615606A332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LQj2IY9n
Received: by kanga.kvack.org (Postfix)
	id AC2C06B05B7; Thu,  5 Nov 2026 15:57:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4C0E6B05B8; Thu,  5 Nov 2026 15:57:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914AC6B05B9; Thu,  5 Nov 2026 15:57:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7B86B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:57:54 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3F03160C04
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:57:53 +0000 (UTC)
X-FDA: 85402277226.10.404ACD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 325FF40005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:57:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQj2IY9n;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793912272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xdqtRluB5cup6GxSgXqpPix6FEngw788DfFRYAFbYQ=;
	b=pZE6MNu7Xl+VTMd5D54tMDCDAwNkC8zw+5ClKi0KAEQl0Kc3thCWMM4LD0uO6kBWlEZ/ft
	XPSdl++AmGMTppb4UioYHRNtVA97ii2gkssYrkqPi5OzbzP+U2lFp4+3+0ER95Lq9uroD2
	H+uskAVVOaqtJ40ZRGwK8pnlTM170Mk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793912272;
	b=ysSkl3+jc8xA/YNmlxSbrGRHbaA8RR//4H1vIu2dMoFLy2PElky8Q/lmRsWRapBAYWqeU9
	kCnimXWY6qDdWEX1Rtt1IOHrgl3b9Ge8KcDX9o29Pko8CGuqmHQPzPptovbuRLed8CT/wU
	II8XCKpnuSXxBpsGaXbtEfS+ViAXXMU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LQj2IY9n;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBA59602D4;
	Thu,  5 Nov 2026 20:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F3F1F0089F;
	Thu,  5 Nov 2026 20:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793912271;
	bh=7xdqtRluB5cup6GxSgXqpPix6FEngw788DfFRYAFbYQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=LQj2IY9nFKHkOEffPPb8K+DnflcDR5ZszPHu6UFORi8e716U0QBk48/uh4E6uCBEt
	 uMAtwlHbzn6NA9/Sl+pittFtC+t9OMIDdJ1XO08NYpVhs6E9BwdzSOfpAq6Ukym0e9
	 NP6bNxv29/hrPbR3qLXmXc2trCNPFAz0rNnCMbY1keGlWQaaENF7BOeDsg4ZnmBoik
	 m+mLIpuCLc8IpzZBhqEhk+GHyDBGeXH59shKfBJRbgvGn7bmawmYw6suu4crfCSfWf
	 y0FNroeQlCxN2DGv6kibMzQsTkI4m9UMWOuq6vPspGW5jX9HKlDvfrja73qUWQ+hlt
	 EWONfDc7SALcA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 20:57:24 +0000
Subject: [PATCH v2 3/3] mm/khugepaged: release contended mmap read lock
 after scanning enough VMAs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-khugepaged-latency-fix-v2-3-4384bbfe4606@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4235; i=ljs@kernel.org;
 h=from:subject:message-id; bh=wTj1jzVxGSI+LKIQFtrQdvwrFwZUi3YFGMYMG09Fs1g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLevD2oIB2c1mZ//msz+7SM5suGYQde6kyWXil4/JY4o
 03fxoabHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIbneG/3WBB1cp3L14TXpN
 yTNFebNw787vLg8fepuey85Z6qfZr8/wP2HV91N+hueELS7P25HDFaA/V5iTe9+/Z2xXsmWKhDt
 m8gIA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: xnpdrdyips6ggytdnqat3fui5k8zjsas
X-Rspamd-Queue-Id: 325FF40005
X-Rspam-User: 
X-HE-Tag: 1793912272-756968
X-HE-Meta: U2FsdGVkX1/ZvRtjYZerVkmZD06E0llB5hDutELziwDF2ysWrJ3/I4lEOQMXNw4H5EK2w4vy2r7Bq327q1kzdQyFVrw10F+w/GcOtNv00U/mj+wqQiSyfb95BUfIGBrIlPLHc9Gl5f3C2dJtceNyRL9+mKewKi/4yy0+XMukgg7NQcruU/I4hrEF77GbatxuRPga/8FYWul2pWt+7UgsyuvJCdYvsAYvUtq028gR2Ts209Tq1WjxI5l2aFaczyssdAgOqlfBwqqJxG9liu+oK9SOZXhSJUtFulftN1UX1rHM6mjAywZbb8xJ00AE6EBZSzW1VJkhYRiFxQmTwwAK92ouw3gIHPTQOlSzStGwS6GoEDyzDI+OPwS7l4EWV8qF9yNafuTCvrMyC6hDKD8+DePO9z0WW/BWcGXnBE9SK+CrahF68mZVm3pPwtxeWDdpCYkv4j61Rh9oidZl4B50/jYz+mceDPs0SsF1wRjiiD1QbZV/MOlUXDEbX1XxRAdkaJuFIuQJn1XYJm5TNxdHLjuCmwSXLnFiZBOd2ft2uIl5NowC9hDf036LWX10y8Y4BAoWr7YP7yDfNEN8ZJu1/yH/c3pd4MsP+A/FG925n6K7slADGXVtMfjX6Rl2SC8dcv1ChIwu/fhOwn18WK8mw++eaPZhrK+peew72vKqAqeUUkAS1q7HM5PgOgPthsBW02XAPxXjkmpTZIFf/MRNwfrHLFlAYoxTgv2pdesXVOC6hErc/bmv030Ytizys5xph7ABfho7i2QMYHTpIhpnZCCnY/4mK/VHRmPjXfKZGWPFOx1iwxEKcxZqZfT+7nEbdKyNeP9scutZhbLyaI/ABO5IszYzH1Uw+JCKOqI7PixjaLpc2PN66OFR0FHwrFJ1hya319Un2PXHAmGoB/FVslEgtjvLt7CLMJpnI/q1hZ6IkZixPElRLdTM5A+aN+9hFpgaI/TjH3pkapDri2/
 LitGLx0B
 FjGulnkLVWG7JJs68G8Pgmq7blVZIY1mlEobju/Qrb/yEdQGVINYe3pD4LeJDOsqaDsDfc0WR5hXLv9fIkO58nBhcwIY0V2rhuvtugV+Lbo+bomXENLxVg602rUzarNtHDJIFP4p8qd7Y5p687/TvRY8qRe7TB4xzNBY/oXYUyEJaQO27+aOM2Q+w8KI3d1QqyAtCRzHjJQT/fONSgqq3w3fXpnU1r1mNWXl+BT6hyPnYehf0XVvzpEnBZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

khugepaged walks an mm's VMAs under the mmap read lock in
collapse_scan_mm_slot(), checking for ineligible VMAs first, and skipping
them if encountered.

It charges cc->progress 1 page against the /sys/.../pages_to_scan budget
when these are encountered, however only checking this budget once an
eligible PMD-spanning VMA is encountered.

It can therefore hold the mmap read lock for a long time if there are a
large number of ineligible VMAs present in an mm, over which time no mmap
write locks (and thus no VMA write locks) can be acquired.

Address this by checking whether the mmap lock is contended after every
KHUGEPAGED_MAX_VMA_SCAN_BATCH VMAs walked, that is a quarter of the
pages_to_scan budget, and if so dropping and re-acquiring the mmap read
lock before resuming the walk from the per-mm cursor.

As the walk is resumed from the cursor rather than the VMA that was current
when the lock was dropped, the cursor must never move backwards. A VMA
ending at the top of the address space causes ALIGN() to wrap the cursor to
zero, so treat such a VMA as the last in the mm rather than skipping past
it.

This was tested locally with ~1M ineligible VMAs mapped ahead of a
collapsible region of memory, and resulted in a reduced mmap_lock hold time
of 170us down from 95ms.

This was also observed to reduce mmap_lock stalls in concurrent threads of
a similar duration. Note that a reader re-acquiring the lock can currently
steal it from a writer that is queued but not yet running, so the full
benefit to writers depends on the separate rwsem change at [0].

Local measurements indicated no change for ordinary use cases, so this is
all upside.

This work came out of investigations into mmap stalls when getting latency
numbers for an unrelated patch series.

[0]: https://lore.kernel.org/all/20261105-rwsem-dont-steal-from-queued-writer-v1-1-275e070f426f@kernel.org/

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/khugepaged.c | 31 +++++++++++++++++++++++++++++--
 1 file changed, 29 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 216c4b8d28c4..eaa01dae5a03 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -66,6 +66,12 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
 
 static struct kmem_cache *mm_slot_cache __ro_after_init;
 
+/*
+ * The number of VMAs to walk before checking for, and relieving, mmap lock
+ * contention, as a function of the pages_to_scan budget.
+ */
+#define KHUGEPAGED_MAX_VMA_SCAN_BATCH(pages_to_scan) ((pages_to_scan) / 4)
+
 /**
  * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
  * @slot: hash lookup from mm to mm_slot
@@ -2910,6 +2916,7 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	struct mm_struct *mm;
 	struct vm_area_struct *vma;
 	unsigned int progress_prev = cc->progress;
+	unsigned int nr_vmas_batch = 0;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 	*result = SCAN_FAIL;
@@ -2942,15 +2949,35 @@ static void collapse_scan_mm_slot(unsigned int progress_max,
 	for_each_vma(vmi, vma) {
 		unsigned long hstart, hend;
 
+		/* Relieve mmap lock contention after walking a batch of VMAs. */
+		if (nr_vmas_batch++ >= KHUGEPAGED_MAX_VMA_SCAN_BATCH(progress_max)) {
+			nr_vmas_batch = 0;
+			if (mmap_lock_is_contended(mm)) {
+				mmap_read_unlock(mm);
+				cond_resched();
+				mmap_read_lock(mm);
+				vma_iter_set(&vmi, mm_slot->address);
+				continue;
+			}
+		}
+
 		cond_resched();
 		if (unlikely(collapse_test_exit_or_disable(mm))) {
 			cc->progress++;
 			break;
 		}
 		if (!collapse_possible_orders(vma, vma->vm_flags, TVA_KHUGEPAGED)) {
-			/* Unable to collapse, skip to the next candidate. */
-			mm_slot->address = ALIGN(vma->vm_end, HPAGE_PMD_SIZE);
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

-- 
2.56.0


