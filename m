Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67754D79779
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 07:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 858EB6B008C; Mon,  2 Feb 2026 02:46:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D9D6B0092; Mon,  2 Feb 2026 02:46:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70FAF6B0093; Mon,  2 Feb 2026 02:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6448E6B008C
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 02:46:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3068B13BFBE
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:46:59 +0000 (UTC)
X-FDA: 84398735358.20.143FE04
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 653F9100003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 07:46:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pdjfUjRg;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770018417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ic7TrnN6sGlm3l1wxhH2nfdOKdVnIN7B0hP0aUO2aOY=;
	b=2EVEiyvHJzVnD9WocrFOc2xBO6JrXWZUpI3iaNBEyXbqCf8OoMjQepvJ4ZYZhSWoEf2AZU
	LzWQrftGcHeQnRU4ESsr8TBIaLZP2E14JSkgoZ4QbKhzbrcwPrJANTsiq2Na2XCA9/2yI4
	ltEz6JBiP3XS7cu3NtRxRDxv6F99bkg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pdjfUjRg;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770018417; a=rsa-sha256;
	cv=none;
	b=SuzK9bt/xmGqqytY0cnqHDdM5Kj9clvgj/330cRq8sz8OD83N3X3XA8PCBh1DYbSbbyC6D
	gyietVgsIjZvxgXVRUc0x+ZNV1xCIi1IC+oIehcylfFVqQCwR+tppfSXRNsqfrAdUJQvoE
	QtefcGFwyVrdbFOib6lyh8x97jaiePQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770018415;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ic7TrnN6sGlm3l1wxhH2nfdOKdVnIN7B0hP0aUO2aOY=;
	b=pdjfUjRgbpxEevSg5ni8YXtztpS1GezhbgKFAamXf1e+YuJlVEd442UU8eyB74Flpb+8jl
	b7x8L4yO0lU1g9rOZipEkWSVE/vqgsI+7A37FZZZxk48NTkJmLeQED7u46+9MTI0gptwG5
	WMDJBHLqce/JaxPiVm1gYjFcmWeJ99A=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	dave.hansen@intel.com,
	dave.hansen@linux.intel.com,
	ypodemsk@redhat.com,
	hughd@google.com,
	will@kernel.org,
	aneesh.kumar@kernel.org,
	npiggin@gmail.com,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	arnd@arndb.de,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	shy828301@gmail.com,
	riel@surriel.com,
	jannh@google.com,
	jgross@suse.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	boris.ostrovsky@oracle.com,
	virtualization@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ioworker0@gmail.com,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v4 2/3] mm: switch callers to tlb_remove_table_sync_mm()
Date: Mon,  2 Feb 2026 15:45:56 +0800
Message-ID: <20260202074557.16544-3-lance.yang@linux.dev>
In-Reply-To: <20260202074557.16544-1-lance.yang@linux.dev>
References: <20260202074557.16544-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: hrtc3t374to9xprri7ws46zssgjed4cn
X-Rspam-User: 
X-Rspamd-Queue-Id: 653F9100003
X-HE-Tag: 1770018417-712410
X-HE-Meta: U2FsdGVkX1859tiJTrdff+sqSZpK06XA48+T+TwzrrAG026qyYRpzbeRdVbWNfSXN0MrqgEkKobYVhxAzJkf5V6EKPoLhBi6PABRF9lugO6WzU2DF0yOwty0no5WYpf2Zg5J0HWawxZZeVQCYW+jazmOtyftEqLTlUXSxKQ+s/PrGqGMdpmnsanqBYZ/ywh1vdgyymPZKu46RoaV6LpjmtIA1sW+qks5/i9eJiVPbz5k4e2DIMTkbjaWT1IlaQ2tY+4ONwFuvAjETBIEmFh1b08g29WigHPl0CxEvYIELOu9+x/1qJ0ZV9ZUqLr/JyKFsA7MWC+z6KxX4eHZTiUsoGu+mVs3iopg6dXomIJFZ7wK9fTNwbCPw8Eb7tSXjtD0ZvotiFAMbG6ccQ5NAWCXRLD6f78ZvMetBPSIzkjfLaLS0PLLTnmJXFyGJM1GPaQM1eK5CiLrDkV7sj41htR5kJlULqo7Sg+J2htpt8+w9+jdvC3/JXYR3bFBUaXglc7/eeOMdOdN7BPVGa61SGMPe/rX/Oq+jxtn66NgNDEyZg/Ljw2qGUgeFK23MLjSyV/bePfRCmOKyLaCAGbVgC2px+OL2EtWh771NPvhrExDaVTIx+bYW6AJIbavZ6z+qui1O9XPCwR9+o6yDUDqHiOFt7fSjGXJVlQOL9uaoJ8nxNLUjj3cuhrffde1a3Do6bJuUaA2pF7OMRjgZFKLy7KfqVw/SozyTCKkaHisNZ3Ub5paCilqLh6/Z0lT12BoSxUJV2hy22oSa3p6phq3hSCjUyDDWVav8m05vARJ3p+xsJscvfZeuFsQYlkLxnyvRlEjKtIpLKtajQnOOiMTZpIx9nCMtCqOTbgCJ3xjSiAnZ9wNFWqNPiiXQiqanaaVhgjGHpWcE1bDX28p6+lmJqZcFyllqi/1RmWCOF3eXWBogbu/W03bPU6keMhjcXkvcjzPjjpljuxjbCSWfD5LX77
 hP4rc2+S
 k5x1/fZYR+1kf8vSqigi0ongxhi5m6OMbC9nT909c19aUmHjA9RPkFXjQ3i6U//zxTiyVXNd9wOMSUbec0EPo44jWA+IAx3Ab1b9/xMAd7HC5ImxO8nzAXZhSPjtTAHACeOeyKDIgXI/7vZZS6Yo2Eqy9Rglh7+1T6ARQIwqy/b/wGZloaW7UNktmV+wVVnLFIVVEpmARSqTsHr++/nAHRGVZk4xYBxIkbDD4B2+gl7EgAyCp7NlyWicY5IxNFohrvBAMRqLwawyvneZ6PUM/oR/l/PDclImJGkije3qlJOtori+OO01CXLwJlA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lance Yang <lance.yang@linux.dev>

Now that we have tlb_remove_table_sync_mm(), convert callers from
tlb_remove_table_sync_one() to enable targeted IPIs instead of broadcast.

Three callers updated:

1) collapse_huge_page() - after flushing the old PMD, only IPIs CPUs
   walking this mm instead of all CPUs.

2) tlb_flush_unshared_tables() - when unsharing hugetlb page tables,
   use tlb->mm for targeted IPIs.

3) __tlb_remove_table_one() - updated to take mmu_gather parameter so
   it can use tlb->mm when batch allocation fails.

Note that pmdp_get_lockless_sync() (PAE only) also calls
tlb_remove_table_sync_one() under PTL to ensure all ongoing PMD split-reads
complete between pmdp_get_lockless_{start,end}; the critical section is
very short. I'm inclined not to convert it since PAE systems typically
don't have many cores.

Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
 include/asm-generic/tlb.h | 11 ++++++-----
 mm/khugepaged.c           |  2 +-
 mm/mmu_gather.c           | 12 ++++++------
 3 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/asm-generic/tlb.h b/include/asm-generic/tlb.h
index b6b06e6b879f..40eb74b28f9d 100644
--- a/include/asm-generic/tlb.h
+++ b/include/asm-generic/tlb.h
@@ -831,17 +831,18 @@ static inline void tlb_flush_unshared_tables(struct mmu_gather *tlb)
 	/*
 	 * Similarly, we must make sure that concurrent GUP-fast will not
 	 * walk previously-shared page tables that are getting modified+reused
-	 * elsewhere. So broadcast an IPI to wait for any concurrent GUP-fast.
+	 * elsewhere. So send an IPI to wait for any concurrent GUP-fast.
 	 *
-	 * We only perform this when we are the last sharer of a page table,
-	 * as the IPI will reach all CPUs: any GUP-fast.
+	 * We only perform this when we are the last sharer of a page table.
+	 * Use targeted IPI to CPUs actively walking this mm instead of
+	 * broadcast.
 	 *
-	 * Note that on configs where tlb_remove_table_sync_one() is a NOP,
+	 * Note that on configs where tlb_remove_table_sync_mm() is a NOP,
 	 * the expectation is that the tlb_flush_mmu_tlbonly() would have issued
 	 * required IPIs already for us.
 	 */
 	if (tlb->fully_unshared_tables) {
-		tlb_remove_table_sync_one();
+		tlb_remove_table_sync_mm(tlb->mm);
 		tlb->fully_unshared_tables = false;
 	}
 }
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa1e57fd2c46..7781d6628649 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1173,7 +1173,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
 	_pmd = pmdp_collapse_flush(vma, address, pmd);
 	spin_unlock(pmd_ptl);
 	mmu_notifier_invalidate_range_end(&range);
-	tlb_remove_table_sync_one();
+	tlb_remove_table_sync_mm(mm);
 
 	pte = pte_offset_map_lock(mm, &_pmd, address, &pte_ptl);
 	if (pte) {
diff --git a/mm/mmu_gather.c b/mm/mmu_gather.c
index 35c89e4b6230..76573ec454e5 100644
--- a/mm/mmu_gather.c
+++ b/mm/mmu_gather.c
@@ -378,7 +378,7 @@ static inline void __tlb_remove_table_one_rcu(struct rcu_head *head)
 	__tlb_remove_table(ptdesc);
 }
 
-static inline void __tlb_remove_table_one(void *table)
+static inline void __tlb_remove_table_one(struct mmu_gather *tlb, void *table)
 {
 	struct ptdesc *ptdesc;
 
@@ -386,16 +386,16 @@ static inline void __tlb_remove_table_one(void *table)
 	call_rcu(&ptdesc->pt_rcu_head, __tlb_remove_table_one_rcu);
 }
 #else
-static inline void __tlb_remove_table_one(void *table)
+static inline void __tlb_remove_table_one(struct mmu_gather *tlb, void *table)
 {
-	tlb_remove_table_sync_one();
+	tlb_remove_table_sync_mm(tlb->mm);
 	__tlb_remove_table(table);
 }
 #endif /* CONFIG_PT_RECLAIM */
 
-static void tlb_remove_table_one(void *table)
+static void tlb_remove_table_one(struct mmu_gather *tlb, void *table)
 {
-	__tlb_remove_table_one(table);
+	__tlb_remove_table_one(tlb, table);
 }
 
 static void tlb_table_flush(struct mmu_gather *tlb)
@@ -417,7 +417,7 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
 		*batch = (struct mmu_table_batch *)__get_free_page(GFP_NOWAIT);
 		if (*batch == NULL) {
 			tlb_table_invalidate(tlb);
-			tlb_remove_table_one(table);
+			tlb_remove_table_one(tlb, table);
 			return;
 		}
 		(*batch)->nr = 0;
-- 
2.49.0


