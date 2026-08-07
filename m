Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB9C1C5AC7C
	for <linux-mm@archiver.kernel.org>; Fri,  7 Aug 2026 09:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 19B3B6B0096; Fri,  7 Aug 2026 05:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1450A6B0098; Fri,  7 Aug 2026 05:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0346B6B0099; Fri,  7 Aug 2026 05:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D82966B0096
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 05:24:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B8EA16029B
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:24:51 +0000 (UTC)
X-FDA: 85073938782.12.E04277B
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id A9D6D180011
	for <linux-mm@kvack.org>; Fri,  7 Aug 2026 09:24:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b7uq61go;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786094689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZ7BfDw8IdELpVl1v0XbwQYrJXlm7dQ+k8WFQ5Z2DJA=;
	b=RrIpGT34Svu/Max3kjRxEV8FZmQt+UQqm4DpX9BumHbbOZziJiujav/CQLtlzJvNWBEbqb
	NKWmJ7fDSXI9U5tKyuZJihplkf9uN/XYszZUpBhVgXaZcuEC7TQkoAfvKLBdLHdsGgGIdC
	CtPKvEj1J/T+kgq/Q8MjRv6//GlmP80=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=b7uq61go;
	spf=pass (imf24.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786094689;
	b=HSJH2T6HNmayMrdVMBqSoJyd7PgFs+z7ZK3DTzRvqnwlGSCXx8ScLyFelpaSpVzzTFcxGr
	VQ/hwFIUPOqA2qCpRAcJ4FE8y0Nz3xGP1s+wz1j+cKNm5oDr+kDwR/zt2dpFfsP4AugNiE
	Ond1W7+HPjsnqjqiq4af4MEfYoQ9Rlw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786094688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZZ7BfDw8IdELpVl1v0XbwQYrJXlm7dQ+k8WFQ5Z2DJA=;
	b=b7uq61govvjgbteN+q/1DdxO8sprNFEJT0E4eAeGhR+OOh670CTz7PsyLRZexagU4bTa5G
	V2I5FleF9z1hl4/SoNppDdzAnX1Oh6ePnEyFKHS7if5WgY2pTuFNWsyLCbo8i3N4w3sbJp
	GJ0hekSSWsETMRCevuZRJS+Z3+WYH8I=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	kasong@tencent.com,
	baohua@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Baoquan He <baoquan.he@linux.dev>
Subject: [PATCH 4/4] mm/mglru: invalidate empty-walk skip on page fault and migration
Date: Fri,  7 Aug 2026 17:23:41 +0800
Message-ID: <20260807092343.4123734-4-baoquan.he@linux.dev>
In-Reply-To: <20260807092343.4123734-1-baoquan.he@linux.dev>
References: <anRqew3VikVzxJJb@MiWiFi-R3L-srv>
 <20260807092343.4123734-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4o4oxdb3871u5scp34nq84rxka35qjyz
X-Rspamd-Queue-Id: A9D6D180011
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786094689-883382
X-HE-Meta: U2FsdGVkX1+xYTX7RWp45bxBURwQaNl3BsnN71Ctv8vnp3vldOzg9SFjeYY7ZLY/zcb4F8hrU8bJLT/G3Ru/NlvIfKv/q5YX9Wm9pHTMj/D0n+HEp6YvGVojsRiYk812DHIKX8HAUx4UGCilN13XRof2XyAyghFWJ/pFVXhNV1CtNPRy1upE3Vkp7f+jYCgVh5XgkTCnLTx+LN7ZmvdPUZOwUidILyZKVFc8wrz49zb7KTj425L3I2user8Alz3DijXVjbEfeNsvIJlbmtRJOiwiuvPZ3dF2pu521drHGxmwxxeY62xlYIK38FLpoOwlNbOZT2raO1zgFSl3KN7907l3VCZnkYvMmYGSVyHBhcYNndYQ5EkhkQvtdaelJn6gh6iwkLk3MqXR92Y8iE8b4S3+Isb0PB7/EMZjTqluo2U3GAlPHc7JCOLcJ6D6aQDcI4SurzYnCSzU5Yrha/2g5jFYJVNRf4dZIjmJhw8w4ISxMCgvGedoiGspxtgqlWj33HEVstr0+yg53/nE2gesjuHaGdz409g5BXVlVIYQ3fs7S4KSdVHk0xTeRNhUAArb/mmF6UZZNcbmfGmspo3E1cyufT3KuoKy7pg7apF+q8rp93Cdi43id7LMrKia78aX80zcI9oDHSO7uPKyV0Wx19sFy9VK1GOR/5d1uxAnsmDFkG5y6Vtvs4MhvR6Dqj2kqAo9L1F03HFHdmnuvvhHy6uLZZPdfnzpSIKCBiouVtKkI1C7JYD/Rd3TW4tkNLoDE70WvuGcl0QTkyuML+v7V3PWEEAMY5pTDIHT9oocyru7Z7DvEtIs8TORR3ae0g4PY/hSaz5o41PgDI3FUh6243OGXwoQMmfT7yvIKxM5moWOUeysTH97KKq0cE3qrx4dPTaBcvF+ISRY8l6kJSrzyfXkruDBwmfX3lNmc2kP277rERYuQgYLRHg7ILFN8nnoXDxBAeyrBXFIcTYxwND
 Drt0CHPn
 G0l4waWWX9YmdOJXLeJC/6aIhsk59KQ2qqMxsN2vkJYgApBOB6lpWLNDeAhsDpZLmkgRgF3C+zuwt34rmAf0D1o6BbZIGOCB/ggOSyc2CL3UHAWoLrKSPBEJak1jHtm3C+pCR+unqbiGgSCsvsCFGq3HPnTHyZx1G1z+y8JKpzBKtNRUKxruxXYw8wb+UyjURQeFTdXWV/celzAQrg6AYf/4cAGJawsoZKEKq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

empty_map skips an mm on a node for up to K generations after an empty
walk, leaving a window where pages that appear on that node are not aged
until the forced rescan. Notify MGLRU when a page of the mm appears:
set the node's bitmap bit and clear its empty_map bit. Fault and
migration are both software events, so the invalidation is complete - a
node marked empty has no pages there, so a page can only appear via a
fault or a migration.

- mm/memory.c do_anonymous_page()/finish_fault(): mark the folio's node
  after the page is allocated (anon and file/COW faults).
- mm/migrate.c remove_migration_pte(): mark the folio's destination node
  (also covers NUMA-balancing migration).

The bitmap bit is mostly redundant with schedule-time marking, but is
needed when migration targets an idle mm whose bits were already
cleared by a previous walk.

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/mm_types.h | 18 ++++++++++++++++++
 mm/memory.c              |  7 +++++++
 mm/migrate.c             |  3 +++
 3 files changed, 28 insertions(+)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 68ec8bb2ab71..89b723483675 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1531,6 +1531,20 @@ static inline void lru_gen_use_mm(struct mm_struct *mm)
 	WRITE_ONCE(mm->lru_gen.bitmap, -1);
 }
 
+/*
+ * A page of this mm appeared on (or was accessed on) node @nid — e.g. a page
+ * fault or a migration. Set that node's bitmap bit so the aging walker walks
+ * the mm, and clear the empty-walk skip so a page that just appeared on a node
+ * previously marked empty is not ignored for up to K generations.
+ */
+static inline void lru_gen_mm_accessed(struct mm_struct *mm, int nid)
+{
+	unsigned long key = nid % BITS_PER_TYPE(mm->lru_gen.bitmap);
+
+	set_bit(key, &mm->lru_gen.bitmap);
+	clear_bit(key, &mm->lru_gen.empty_map);
+}
+
 #else /* !CONFIG_LRU_GEN_WALKS_MMU */
 
 static inline void lru_gen_add_mm(struct mm_struct *mm)
@@ -1553,6 +1567,10 @@ static inline void lru_gen_use_mm(struct mm_struct *mm)
 {
 }
 
+static inline void lru_gen_mm_accessed(struct mm_struct *mm, int nid)
+{
+}
+
 #endif /* CONFIG_LRU_GEN_WALKS_MMU */
 
 struct vma_iterator {
diff --git a/mm/memory.c b/mm/memory.c
index 428eb555ecb7..e3d7c8f7ca7d 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5512,6 +5512,9 @@ static vm_fault_t do_anonymous_page(struct vm_fault *vmf)
 		folio_put(folio);
 		return handle_userfault(vmf, VM_UFFD_MISSING);
 	}
+	/* a new page of this mm lands on this node: invalidate any empty skip */
+	lru_gen_mm_accessed(vma->vm_mm, folio_nid(folio));
+
 	map_anon_folio_pte_pf(folio, vmf->pte, vma, addr,
 			      vmf_orig_pte_uffd_wp(vmf));
 unlock:
@@ -5772,6 +5775,10 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 		page = vmf->page;
 
 	folio = page_folio(page);
+
+	/* mapping a page of this mm on this node: invalidate any empty skip */
+	lru_gen_mm_accessed(vma->vm_mm, folio_nid(folio));
+
 	/*
 	 * check even for read faults because we might have lost our CoWed
 	 * page
diff --git a/mm/migrate.c b/mm/migrate.c
index b937cbd76480..2e0674e89ba8 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -354,6 +354,9 @@ static bool remove_migration_pte(struct folio *folio,
 	struct rmap_walk_arg *rmap_walk_arg = arg;
 	DEFINE_FOLIO_VMA_WALK(pvmw, rmap_walk_arg->folio, vma, addr, PVMW_SYNC | PVMW_MIGRATION);
 
+	/* the folio ends up on folio_nid(): notify MGLRU for this mm */
+	lru_gen_mm_accessed(vma->vm_mm, folio_nid(folio));
+
 	while (page_vma_mapped_walk(&pvmw)) {
 		rmap_t rmap_flags = RMAP_NONE;
 		pte_t old_pte;
-- 
2.54.0


