Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C16D9606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VF/MjO4V
Received: by kanga.kvack.org (Postfix)
	id E49B86B05B9; Tue,  3 Nov 2026 03:28:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E000B6B05BA; Tue,  3 Nov 2026 03:28:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC1896B05BB; Tue,  3 Nov 2026 03:28:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC1926B05B9
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:28:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3599120335
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:21 +0000 (UTC)
X-FDA: 85393130802.09.E622DFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id F3E8B4000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:28:19 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VF/MjO4V";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793694500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HsU7vqGV4zKcR0xzOlLwVFOnYeenz76WhiQbmAur/gw=;
	b=5KK61O9HJ/d0BlxA1PWmXAOvZNHXf8vqPKXSsnnR+W132IL91Bx01inkqjQOkz19peDoUi
	DaXBKUywAnNIl7D8VZmJWw/+cO+mkn78gs03ud+nWfODbXjgz4Ykbo2VDTlfHGSiM3qV8I
	FgqDxglIc+XlLUM1iLpxZKyoLgxLpyE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793694500;
	b=ES995XiMC6si1ZEUMFWMFskrIzqmNeM/kVhaUnHuPrOeFeqfQUwnyrmYy1v/6O1ZGrPnMb
	hGygYHKpAgU7FA/RUTnWbF7lcP7eehOeOyClGQea359e++6LRyccu0nmEI24W5u4TWo09M
	Vn5U8Y88amlw7UdMZzQWo77lOQgBVUU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VF/MjO4V";
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2DC0D4036A;
	Tue,  3 Nov 2026 08:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39CFE1F000C1;
	Tue,  3 Nov 2026 08:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793694499;
	bh=HsU7vqGV4zKcR0xzOlLwVFOnYeenz76WhiQbmAur/gw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VF/MjO4VQPvJbsTdhSxc+0MJKdEjqryzjEgdG8c2adRvAchbzj5B6ai2szK1F0ydG
	 fSVHNNpyc2vnrnSA8VgFKqrGPdZrvDx26NdErWFk9Y6AMZuIVO1Isv//oVlnqMGOni
	 743VRFXyiPfI2emKzuq1EembdYHF4SMK8rXNk9REST+nP7DcdN5mGn8mBSG0PXIpI7
	 NS1QiUP6OTbLE+6hAACDbGLLh5HhBIusmIH9WEw5Y822H6nQab357khV+fFyrSZfcO
	 Z650piC8n7ilYLr+HgcXrWTNpGftz7Q8xnXKPWXWvdeq8wOLOLQt3yetgeb0DGoa9Y
	 +kmgG85TDbckg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 03 Nov 2026 08:27:43 +0000
Subject: [PATCH 2/5] mm/khugepaged: scan mm's more efficiently under
 mmap_lock contention
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-khugepaged-latency-fix-v1-2-a07ab16ac860@kernel.org>
References: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
In-Reply-To: <20261103-khugepaged-latency-fix-v1-0-a07ab16ac860@kernel.org>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Will Deacon <will@kernel.org>, Boqun Feng <boqun@kernel.org>, 
 Waiman Long <longman@redhat.com>, Suren Baghdasaryan <surenb@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Yonghong Song <yonghong.song@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
 Andrii Nakryiko <andrii@kernel.org>, Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
 Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
 Jiri Olsa <jolsa@kernel.org>, Emil Tsalapatis <emil@etsalapatis.com>, 
 Ihor Solodrai <ihor.solodrai@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=7639; i=ljs@kernel.org;
 h=from:subject:message-id; bh=yteJ6h2vAGTeR9YuoTU+OYu1yFPwDvdCdviaFPqbXdY=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJezuYREzpS9OrdvJnedorlXxYEP3p7cXKavs19xgtHX
 ymbzpsY3VHKwiDGxSArpsjy/Iv4/iCRsHmdF/zdYOawMoEMYeDiFICJ+Bxh+B96YM/zujiFo7od
 s3vnZaacfMn4z3GN0JpfBystCiI/Pehj+GcWkNHOfHSKpmt4oHt2uq4Lg/2ExQWnjz9+HLHA8Wr
 GZk4A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam06
X-Stat-Signature: kpepu6fbhf9ci44zh6ng6uoibgtbjfdk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: F3E8B4000A
X-Rspam-User: 
X-HE-Tag: 1793694499-696600
X-HE-Meta: U2FsdGVkX1980XuQWcOLgKh2NCqtuJf0f/GgHkvqWDVCdz5gYnGgpuuOdggTe6svKfWJdoeqUGrQXN66WV0Owu+u8K/yxI1nKCJggs++ius9QNaDdjMJ7Oi/KHzmaDePgDJjlJu+NCCBO47W+H8mjpSbp+n83u00wg9Vez4JW2KBY0HXCFeYdYMNeBfZri+P3hb8Np8IrQvmtA6TnwnIIo4BrAFCEg2AgzLYAq2PMvdJJnvUEi4JN1Y3F9UODzk9fRVLjfWtTsvtY3J/jvS3LKHqKL1K+dSJHT+IZP+C0SXyKPbmR/g777w6N0df47cq+0cwN2pKjSazfg9FLbBEe6T9B0Mv7lk2fWIAUtEZX7/XlmBYspjnQ6apf53Uy3jk73Dvlpppp2uexO8pv8DjLRa1p2ewPoxc9x7OyfJbpvfDvq0e7T8Yrc8vibf1sNwh8PtFUSiY1aAtIB7U7t7W+wp6tILq20eSJJlvb3b/LUDt46ElrTXADyxQekljU2JhZLl4VqAv/xsmWoiTgxAmn4OO2h0mbDOm/aYuBJy36M4G43QcE+yggIeu6u79Jn+HPORkqxhqngxCsKRg41gSEGB4BpSRJxSbcf/LPS0byedv5u33sIhw01teWtrHkGUrnTjNsijwzPa0+awFCVZkEhHBpV5mamkI4Wq5qNOaLEtARPrDb/3gj4pLZ3lTEcCw92ZmgNW+fF6CuHmFaKYBXb2yqv4LhXMpHg4H4PRTVJZ2CP5/ZUGv4ck6dC6sDDHWlI49TayTAbJC4+NG/fegl+M+85MVvYRIZ8oPlXuzytpCqT9yPW/4RUBJJEtfJxQhBUOy+4KkAIBZBRPhzaCjM+hivEdBULaCa/icR4V45g1JQXqY/Z6+MKcuAE8vbVCYvHbULLr3/lVRm/4AqGdlOEPg13jhk12csRuM3+Ktpnj6UE1Am9AogYrvhw7VtzhIRS6OwKbn3tO77qUQqJ9
 belHGygq
 mkylMQDjNhXEdKsO2LrvttTY8lvxwvElZzFYrScQ0XAc61OeIG4UepSSRM6o3sowYApCmXlpojqW/zll/jUqSQpWf0kHh6ib2ckXIMUiyYqHenvOgIZJZpmm3+iOJYMxDsE1jTF04r2KKo5vuT/Dei+SPI+tNEz7T4zB6SyrQyTmZag6tw10DickvG8nCnX7Hhc0KttyNsI2Hxz/Plpy1DtnvxewbqjwnakfnELZ3Yxo3jvKNsFcM1fcTNOh9oLi06Ot4xsOdwNdcjwzHX3HmvxsR82LeIOw2rU8Zli6LO1b1pf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Ostensibly khugepaged collapse traverses eligible mm's, scanning up to
/sys/kernel/mm/transparent_hugepage/khugepaged/pages_to_scan eligible pages
at a time, sleeping for /sys/.../scan_sleep_millisecs between each
traversal.

mm's are scanned in collapse_scan_mm_slot() under the mmap read lock,
obtained using mmap_read_trylock(), skipping the mm if there is lock
contention, and dropping the lock before allocation.

khugepaged will keep scanning the same mm until it is about to be torn
down, prctl(PR_SET_THP_DISABLE) disables THP for it, mm->mmap_lock
contention occurs, or all its VMAs have been scanned.

When any of these occur, khugepaged doesn't keep track of where it left
off, as the current address is tracked in
khugepaged_scan.address (essentially a global value), which is reset.

This is a problem when lock contention occurs, as when the mm is next
scanned, it starts from address 0 again.

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

Examples of eligible but uncollapsible ranges are those containing a large
number of forked PTE entries (more than /sys/.../max_ptes_shared), swapped
out PTE entries (more than /sys/.../max_ptes_swap) or none or zero-page PTE
entries (more than /sys/.../max_ptes_none).

The latter might seem unlikely to happen given /sys/.../max_ptes_none
defaults to HPAGE_PMD_NR - 1 and CONFIG_PT_RECLAIM frees PTE page tables,
however CONFIG_PT_RECLAIM only removes the page table if the zapped range
spans at least a PMD size (see pte_table_reclaim_possible()).

Thus, userland software that applies madvise(..., MADV_DONTNEED) across
sub-PMD ranges can thwart this, which is quite feasible for memory
allocators and GC heaps, for instance.

Resolve the issue by simply tracking the last examined address in the
khugepaged_mm_slot object, so when the mm is resumed, the scan starts from
where it left off.

Additionally, skip to the next candidate if a VMA cannot be collapsed.

This issue was noticed during some work in which an mm was instantiated
with a large number of small VMAs under significant mmap_lock contention,
during which collapse was observed to take 10.8s. With this patch applied
it took 3.6s to collapse the same mm.

Also, while here, update a couple VM_BUG_ON()'s to VM_WARN_ON_ONCE()'s.

This patch is also a pre-requisite for a later patch in this series.

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


