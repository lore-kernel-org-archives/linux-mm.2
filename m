Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFEE0C88E4D
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 08:25:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F896B0088; Sat, 12 Sep 2026 04:25:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940CF6B008C; Sat, 12 Sep 2026 04:25:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 856CE6B0092; Sat, 12 Sep 2026 04:25:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 666576B0088
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 04:25:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3518C0416
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:25:46 +0000 (UTC)
X-FDA: 85204426692.05.5804F4C
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0368540002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 08:25:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ISqqJMZc;
	spf=pass (imf27.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789201545;
	b=CQQbtsDBHPRbxo5wviv0R8FPS9rq2kn/triBXa8G6lhRnuc2eDIhlGJOiT8tzj4/4f6a5i
	BcJhXJ03lGVGs/gibCnzKeQoVO4/GwyqwUZRWLZPoREBRS/zdL7nloYqmlW8Kz/zaLXsr3
	ADo6Eyy39pQVauflLK+sf8sJMrk+CeQ=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=ISqqJMZc;
	spf=pass (imf27.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789201545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yncf0PxijlZoQpU9WpOljLbavmoG2PB3EBdY+B+ayfA=;
	b=QOfo8300ic/9/usjGqahhMCV+P8tN3sHcYbeLYa89Pfh7LRqvyO4YGyaHs47Q32v8P2L1n
	C9TQN04Q4B+unRtAr6TuJvu85KL1H35TVm9ZWxKVzeCeBd1PvHPE90/N95bASIVCq5wTed
	syFpJ/b+cvIwaP39Ajf5uX8bQjUdcbU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Yn
	cf0PxijlZoQpU9WpOljLbavmoG2PB3EBdY+B+ayfA=; b=ISqqJMZcXy0NipoBmQ
	DGy+LrADHOcT2G5d3Giav/XLw7t9GyjKbu8FlOV0xqA3zVQFcEWdW/cildYiwUnh
	YTY1sTDIiCu4d94LimVip3iwJte2sei5ZfwxWTq8G7YAXW9/itMbazDCUDSI1ULp
	n6m3SUEhuJr+nBhKAsZ0lzUEY=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgDnr7FODKVqmfMoSQ--.44660S5;
	Sat, 12 Sep 2026 16:24:50 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: xu.xin16@zte.com.cn
Cc: akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	borntraeger@linux.ibm.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	harry@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nico.pache@linux.dev,
	peterz@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH RFC 3/3] mm/ksm: scan VMAs with per-VMA locks
Date: Sat, 12 Sep 2026 16:24:07 +0800
Message-ID: <20260912082407.75875-4-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260912082407.75875-1-xialonglong2025@163.com>
References: <20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn>
 <20260912082407.75875-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgDnr7FODKVqmfMoSQ--.44660S5
X-Coremail-Antispam: 1Uf129KBjvJXoW3JrW8KFW3Xw48ZFy8GF4rXwb_yoW7Ww15pF
	ZrJa98Wr45Cw4fXFZ3XF48CrWagw4vga1UJr43Cwna9wnxtrsxuF4rKayUAF98Crn3Xa4a
	vr4jyFnxCF1avaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j9yCXUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xMbFGqlDFOSjwAA3m
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0368540002
X-Stat-Signature: u3j9zn86cxiy7sz5qw4y5aoru8pw1ygf
X-Rspam-User: 
X-HE-Tag: 1789201543-794413
X-HE-Meta: U2FsdGVkX19OWnDNKMdwrqqKwX6sUAHeL9vfC7Xd/CjrtuU5seU6Qf0CnWxOlej0PjlY761TRRIjNzNu51JaIofUnX0W1idxUmfzM5zFN6CfBg0524VH0SpG1ZwXIA8VY9L+UC1qsmhhn2taSjvtTd78KeFqmcrKYBNdpIggbODL1GJBWcyR/WQpEPUPc00PIR/ZetgsBEcvYW0gPxAv0xkcl79X+UyDnN35Dc4FJUaTumhgtb8+EPrxh1NGNrEfPnrzZOe8pvffEeK5xtdNRz4q4jlG1d89GUCVgjTQAdXs04tqn5XBI2UIdR6UgRYkXC46FxlJ+HaznALr95J3UYOai3Dnx4KXlslK91jb51A+2/jOOZa/NbKNemWtLDTlLNQUQJG+XnoN9//pcNMKvDEalqP9biArnLJnoCx+L+q1h1w1guraGBy+vvh2AxMP0ijYch+4RN5iPKe2b64yLQLKSIIx3wR1GxpWJkkLo2xCj6/KU+KQjMzr/9UOD5iZ1Sn2gebKcpZkIywlomHaZ9pu46GUJCuTVc35nPrlUPyl/k4kn7PlXyyGvhS8gOVqx1CsXlQpzAYs8EEVq5MEvRTclv4EhxPhsJ+SJHGC3G3Ap3jtia3SZGW0E4MUTuzxgvrd9pdua+c6cZR6uZjHaHxggoMr5q3BraAmV42Y7UWU2malQCxxpGx2yHXL079lkwwAKKxXLfMMbH72ubdMYcrsDtWQRl9E1dYH0n2Y5YE24cdbnocFURdH503cDt9L9G/CwAVYuiUYsztHqv1GFzgybYxONfQ2u9lW3DAlJK52SqwA/nm+zU4A+DHjfOzqGsN9Viu0qMPll2JOIEUhThUpVRSrikXCyjML/QTcIdh+1asOo+obu5HOq282z5KLFiFL9isVczNJFZRQ4IWZXzxz92tX+FU4OFHZx+MVq1zCDR2HnzdmXmq//B1s6dNJKHQrlYDygVPxTnXITKZ
 aG+j3ITW
 Omnlc8wJN+nQasUAGPwc7tUt2HFLFzVO/S+S7uTWBP8PLViQ0LbtUQlEIkHhSv16lJCPQER7UPtEmY6gvqOMxBQLUsFYArVcBUAObTr494nNg+/S0uLRfRm5o7qAmVlwWb7oH6O5OupSxdJFlGkDIPBqRZ9L/P4oSP4TfVOss6oEto4Ju15TPRx0r0zts3pVe/NGBCEm+duRLomw8TT+lj1tnUcgMjlTOKYKKpy2kcLaFPV075tPql/AMWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

KSM currently holds mm->mmap_lock while scanning the VMAs of an mm. Use
lock_next_vma() and walk_page_range_vma() to acquire each VMA's read lock
and release it after finding a candidate page, allowing unrelated VMA
updates to proceed while ksmd scans.

Pin mm_users for the duration of the lockless VMA traversal to keep page
tables alive, and retain the mmap-lock scan as a fallback when a VMA lock
cannot be acquired or per-VMA locking is disabled. Allocation failures
preserve the existing early-stop semantics. This reduces mmap_lock
contention for workloads with concurrent address-space updates while
preserving existing scan semantics.

When the per-VMA scan completes without finding a candidate, remember the
complete traversal and revalidate the mmap-lock sequence before entering
the fallback. If the address space is unchanged, skip the duplicate VMA
walk; if a VMA writer raced with the traversal, restart the fallback walk.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/ksm.c | 107 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 107 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index aee1a1b49b1b..2c0b2adb83d4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2647,6 +2647,98 @@ static struct mm_walk_ops ksm_next_page_ops = {
 	.walk_lock = PGWALK_RDLOCK,
 };
 
+#ifdef CONFIG_PER_VMA_LOCK
+static const struct mm_walk_ops ksm_next_page_vma_ops = {
+	.pmd_entry = ksm_next_page_pmd_entry,
+	.walk_lock = PGWALK_VMA_RDLOCK_VERIFY,
+};
+
+/* Return true when a candidate was processed, including allocation failure. */
+static bool scan_get_next_rmap_item_vma(struct ksm_mm_slot *mm_slot,
+		struct page **page, struct ksm_rmap_item **result,
+		bool *complete, unsigned int *mm_wr_seq)
+{
+	struct mm_struct *mm = mm_slot->slot.mm;
+	unsigned long address = ksm_scan.address;
+	struct vm_area_struct *vma;
+	struct vma_iterator vmi;
+	bool done = false;
+	bool mmap_unlocked;
+
+	if (!mmget_not_zero(mm))
+		return false;
+
+	mmap_unlocked = mmap_lock_speculate_try_begin(mm, mm_wr_seq);
+
+	for (;;) {
+		rcu_read_lock();
+		vma_iter_init(&vmi, mm, address);
+		vma = lock_next_vma(mm, &vmi, address);
+		rcu_read_unlock();
+		if (IS_ERR_OR_NULL(vma))
+			break;
+
+		address = vma->vm_end;
+		if (!(vma->vm_flags & VM_MERGEABLE))
+			goto next_vma;
+		if (ksm_scan.address < vma->vm_start)
+			ksm_scan.address = vma->vm_start;
+		if (!vma->anon_vma)
+			ksm_scan.address = vma->vm_end;
+
+		while (ksm_scan.address < vma->vm_end) {
+			struct ksm_next_page_arg arg;
+			struct ksm_rmap_item *rmap_item;
+			int found;
+
+			found = walk_page_range_vma(vma, ksm_scan.address,
+					vma->vm_end, &ksm_next_page_vma_ops, &arg);
+			if (found <= 0) {
+				VM_WARN_ON_ONCE(found < 0);
+				ksm_scan.address = vma->vm_end;
+				break;
+			}
+
+			ksm_scan.address = arg.addr;
+			flush_anon_page(vma, arg.page, arg.addr);
+			flush_dcache_page(arg.page);
+			rmap_item = get_next_rmap_item(mm_slot,
+					ksm_scan.rmap_list, arg.addr);
+			if (rmap_item) {
+				ksm_scan.rmap_list = &rmap_item->rmap_list;
+				if (should_skip_rmap_item(arg.folio, rmap_item)) {
+					folio_put(arg.folio);
+					ksm_scan.address += PAGE_SIZE;
+					cond_resched();
+					continue;
+				}
+				ksm_scan.address += PAGE_SIZE;
+				*page = arg.page;
+			} else {
+				folio_put(arg.folio);
+			}
+			*result = rmap_item;
+			done = true;
+			vma_end_read(vma);
+			goto out;
+		}
+next_vma:
+		/*
+		 * Don't advance ksm_scan.address for VMAs the mmap-lock loop
+		 * skips with a plain continue: the cursor has to stay 0 when
+		 * this mm holds no VM_MERGEABLE vma, so the fallback walk can
+		 * remove the mm from the scan list at the end of the pass.
+		 */
+		vma_end_read(vma);
+		cond_resched();
+	}
+	*complete = mmap_unlocked && !vma;
+out:
+	mmput_async(mm);
+	return done;
+}
+#endif
+
 static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 {
 	struct mm_struct *mm;
@@ -2655,6 +2747,9 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 	struct vm_area_struct *vma;
 	struct ksm_rmap_item *rmap_item;
 	struct vma_iterator vmi;
+	bool skip_vma_scan = false;
+	bool vma_scan_complete = false;
+	unsigned int mm_wr_seq;
 	int nid;
 
 	if (list_empty(&ksm_mm_head.slot.mm_node))
@@ -2719,12 +2814,23 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 
 	slot = &mm_slot->slot;
 	mm = slot->mm;
+#ifdef CONFIG_PER_VMA_LOCK
+	rmap_item = NULL;
+	if (scan_get_next_rmap_item_vma(mm_slot, page, &rmap_item,
+			&vma_scan_complete, &mm_wr_seq))
+		return rmap_item;
+#endif
+	/* Recheck the end of the scan under mmap_lock before removing the mm. */
 	vma_iter_init(&vmi, mm, ksm_scan.address);
 
 	mmap_read_lock(mm);
+	if (vma_scan_complete && !mmap_lock_speculate_retry(mm, mm_wr_seq))
+		skip_vma_scan = true;
 	if (ksm_test_exit(mm))
 		goto no_vmas;
 
+	if (skip_vma_scan)
+		goto scan_cleanup;
 	for_each_vma(vmi, vma) {
 		if (!(vma->vm_flags & VM_MERGEABLE))
 			continue;
@@ -2785,6 +2891,7 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		}
 	}
 
+scan_cleanup:
 	if (ksm_test_exit(mm)) {
 no_vmas:
 		ksm_scan.address = 0;
-- 
2.43.0


