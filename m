Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26767606A327
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 13:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hvVXYC3O
Received: by kanga.kvack.org (Postfix)
	id 503EE6B05B2; Mon,  2 Nov 2026 08:30:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B3F16B05B5; Mon,  2 Nov 2026 08:30:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A3AB6B05B6; Mon,  2 Nov 2026 08:30:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 158E56B05B2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:30:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A599A0C9C
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:30:56 +0000 (UTC)
X-FDA: 85390264512.26.D443CF4
Received: from mta1.migadu.com (out-236.mta1.migadu.com [95.215.58.236])
	by imf10.hostedemail.com (Postfix) with ESMTP id D6779C0004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 13:30:52 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hvVXYC3O;
	spf=pass (imf10.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.236 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793626253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xd4Zxt0dW9wnj47lwp9JjLaVdRyyCLyZMnAjVqO7/fo=;
	b=Zrs5B1OJ/WFZhirjaCC46Kr7PHul3fkI2U0oK/pdFkfQP4lq+oQg8gJniHTekN+D/iVPPy
	+ju9RntZvoAITfI8VpOtcvqZOdueOodadsVSq4RbtY2ioMvatPYxrFnzbyJVyzvNbNeUp5
	4fGJRk7pBfw8oQTiMgts6WTzdMKGb9U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793626253;
	b=WBKSdewmkpteA5pNxJ0SW90YyVh8i6fNc9Z3Yg9RVebNSv4wFFcduvbkQLpLB9O79ULeQx
	bod9qlX6ZXHp7ij710Z2O/mOxvEXTjxT2sxhzGs5silSpXlBRM9eBErKEYb/IoP7ZPXxvf
	UFdDITp3kTZkigvGddKM63mnk4Tv9o8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hvVXYC3O;
	spf=pass (imf10.hostedemail.com: domain of xu.xin@linux.dev designates 95.215.58.236 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=s4yg0ta58nGIz9mkSZjODrgZj5rI7gGZ4K62KqyBrVw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793626251; v=1; x=1794231051;
 b=hvVXYC3O0k/1i7DS/ONyv7diNjKqbFYeozdjlhUI8eIgoBOCwGZ/ysnn46uqFBmxfTRsil1m
 MlJ8Fh64PVxSgdSdgtax4m9o/O0g5aYeroI1UTG+6QZtQF0TCoWkWRICChBYb8aHwzpLdDH402K
 4Tt/ro5nfNLvqF5YIHyyh+t4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 931b8975140fde70;
	Mon, 02 Nov 2026 13:30:19 +0000
X-Mizu-Trace-ID: 931b8975140fde70
X-Migadu-Flow: FLOW_OUT
From: xu.xin@linux.dev
To: xu.xin@linux.dev
Cc: acme@kernel.org,
	adrian.hunter@intel.com,
	agordeev@linux.ibm.com,
	akpm@linux-foundation.org,
	alexander.shishkin@linux.intel.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	borntraeger@linux.ibm.com,
	byungchul@sk.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	dev.jain@arm.com,
	gerald.schaefer@linux.ibm.com,
	gor@linux.ibm.com,
	gourry@gourry.net,
	harry@kernel.org,
	hca@linux.ibm.com,
	irogers@google.com,
	james.clark@linaro.org,
	jannh@google.com,
	jolsa@kernel.org,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	ljs@kernel.org,
	mark.rutland@arm.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	mingo@redhat.com,
	namhyung@kernel.org,
	nico.pache@linux.dev,
	oleg@redhat.com,
	peterz@infradead.org,
	riel@surriel.com,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	surenb@google.com,
	svens@linux.ibm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	xialonglong2025@163.com
Subject: [PATCH v2 3/4] mm/ksm: make break_ksm() more scalable
Date: Mon,  2 Nov 2026 21:29:56 +0800
Message-Id: <20261102132956.302480-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102132416.300084-1-xu.xin@linux.dev>
References: <20261102132416.300084-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D6779C0004
X-Stat-Signature: bhp1wt373mwtb6ny45yje4mp96sip7p6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793626252-939827
X-HE-Meta: U2FsdGVkX19nKZcQEh3xu3KMJCbZ5yU0okFJdeiV0XfY/PcMWtjTQfP8PaGDBDm6wqsKHAjlJ/y+EVoF13c5OzNe1ypuJJuojzylPlaHkju7bSJCsuIKs/9V5THPMa+ft2Tag21Zv/wE2MMBDB6XTec2JIHxg35SX6Ry3CdGT4o9T7kzx2sb7XAHwD7wTQ4gd3GiZt6ALkI2Cv/fZmuTAXYz9f8BsN7wRRswln6iWYX70E5t40nZTngf5OdBX44JHKhMndHgLfvRa+0vwOI6PShh4AGDNLPSUNLiCFegSi2bKf4u7rTh3NbwAqzL5NoSN6xrEpAM93YJ8v0arZ/ynsAq+DDBea6SxSUbN6DrVD9zjOB6Da0m4zVwOWlIaUTmGhSUBAiKMx5To+DrK07vC6ZEZC+CtY4A723jQuATdYG0pwtc1ziRN8hIofZb99M6Fxgj2TvFkkRAgZ9ryymIn4qwjDFfqOmDuucaT1KydljhRPSM+cWWiXHUtQUP13IudQWfm5K8wdbxqFpCAY5y4de6sETx5RtFrzBJwz1t7H4pCcPMLgsupNOm+nn9XaaW4Hm6MXFsAw/9WvRIGyWWWabft026iY08Ya9nJalfYP9MG8kpnVD3sJlzQ8qeBz0I+L8zmDHr4zeLf9FT4eCJxxkAkCrAI3SPRwRBsIxXkd8fC41IbYuMlNbEwjOvH9q7lorTE8b6DF8TseLLCcHjFYFTFGcyvhb0EmL82/Jowf24S8ZdsGkBDwI9O0iANfCUCZXcQ8nnDzruDiY1/i4lJrXOykGn5KxPrGS1pLzdECvH+18kCzgGK46ZxdX53q6yGQC57Mt4SGyIJyebx3wXscIpLPiofEPANotIqCJdfi9/RofhNJVQQib3gwohZmBMFi4dC4gFifOoqrqzvPPCOQWzCgbvabUTiSpRHWmt8HZTBPlFo5LkH+Mdmowz+lszwGa74R7dKIBuVbYVLq7
 fIBCHCdz
 mrtdMxQQrQ95MWoEV7rJU3RAQFcqQZgwUKxmm83c8l+OmThUV/koLx0dYv+v7UvvDop2yNO/KBfzi0EW5+jIXspTBi0aAtZublTipMUhL3ccaC1ildrRZKMOcoB2vBw2kU8/mOD3Z+UyBcnIe+zWHtdosdJjFqiFSy2ulppLXEl1xYXLse6mwEqln8iogor7MBIgOew2i7yasWXj8EkwnVZGnEsSCbLG782C2Xl/mbIyt6ChTlMwCIKo8zrJgKp7SG/jtMt+B4uk9dagAF/f0TsND/mvGpsvrk/Vqzc80dt7t5Uh6dY/t9oCJIgqW3lTzGBmA6TerZnGb1bzRikuwm7m1NlUcs5af6h3R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Xu Xin <xu.xin@linux.dev>

break_ksm() currently takes a boolean 'lock_vma' to select between two
static mm_walk_ops tables.  This is fragile: the ops struct is full of
function pointers and making it mutable (to switch walk_lock at runtime)
turns it into a juicy target for attackers.

Replace the boolean with a KSM-local enum ksm_walk_lock and build the
mm_walk_ops on the stack, so the table stays const and there is no
shared mutable state.  This also prepares for the later patch that
switches break_ksm() to per-VMA read-locking, where a third locking
mode will be needed.

No functional change intended.

Signed-off-by: Xu Xin <xu.xin@linux.dev>
---
 mm/ksm.c | 42 +++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 15 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index d4fc0b0965aa..84d363dabdc8 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -661,15 +661,25 @@ static int break_ksm_pmd_entry(pmd_t *pmdp, unsigned long addr, unsigned long en
 	return found;
 }
 
-static const struct mm_walk_ops break_ksm_ops = {
-	.pmd_entry = break_ksm_pmd_entry,
-	.walk_lock = PGWALK_RDLOCK,
+/*
+ * Locking contexts in which break_ksm() may walk the page tables.
+ */
+enum ksm_walk_lock {
+	/* walk under mmap_read_lock() */
+	KSM_WALK_MMAP_RDLOCK,
+	/* walk under mmap_write_lock() */
+	KSM_WALK_MMAP_WRLOCK,
 };
 
-static const struct mm_walk_ops break_ksm_lock_vma_ops = {
-	.pmd_entry = break_ksm_pmd_entry,
-	.walk_lock = PGWALK_WRLOCK,
-};
+static enum page_walk_lock ksm_walk_lock_to_pgwalk(enum ksm_walk_lock lock)
+{
+	switch (lock) {
+	case KSM_WALK_MMAP_WRLOCK:
+		return PGWALK_WRLOCK;
+	default:
+		return PGWALK_RDLOCK;
+	}
+}
 
 /*
  * Though it's very tempting to unmerge rmap_items from stable tree rather
@@ -697,17 +707,19 @@ static const struct mm_walk_ops break_ksm_lock_vma_ops = {
  * protection keys here anyway.
  */
 static int break_ksm(struct vm_area_struct *vma, unsigned long addr,
-		unsigned long end, bool lock_vma)
+		unsigned long end, enum ksm_walk_lock walk_lock)
 {
 	vm_fault_t ret = 0;
-	const struct mm_walk_ops *ops = lock_vma ?
-				&break_ksm_lock_vma_ops : &break_ksm_ops;
+	struct mm_walk_ops ops = {
+		.pmd_entry = break_ksm_pmd_entry,
+		.walk_lock = ksm_walk_lock_to_pgwalk(walk_lock),
+	};
 
 	do {
 		int ksm_page;
 
 		cond_resched();
-		ksm_page = walk_page_range_vma(vma, addr, end, ops, &addr);
+		ksm_page = walk_page_range_vma(vma, addr, end, &ops, &addr);
 		if (ksm_page <= 0)
 			return ksm_page;
 		ret = handle_mm_fault(vma, addr,
@@ -809,7 +821,7 @@ static void break_cow(struct ksm_rmap_item *rmap_item)
 	mmap_read_lock(mm);
 	vma = find_mergeable_vma(mm, addr);
 	if (vma)
-		break_ksm(vma, addr, addr + PAGE_SIZE, false);
+		break_ksm(vma, addr, addr + PAGE_SIZE, KSM_WALK_MMAP_RDLOCK);
 	mmap_read_unlock(mm);
 }
 
@@ -1247,7 +1259,7 @@ static int unmerge_and_remove_all_rmap_items(void)
 		for_each_vma(vmi, vma) {
 			if (!(vma->vm_flags & VM_MERGEABLE) || !vma_has_anon_rmap(vma))
 				continue;
-			err = break_ksm(vma, vma->vm_start, vma->vm_end, false);
+			err = break_ksm(vma, vma->vm_start, vma->vm_end, KSM_WALK_MMAP_RDLOCK);
 			if (err)
 				goto error;
 		}
@@ -2896,7 +2908,7 @@ static int __ksm_del_vma(struct vm_area_struct *vma)
 		return 0;
 
 	if (vma_has_anon_rmap(vma)) {
-		err = break_ksm(vma, vma->vm_start, vma->vm_end, true);
+		err = break_ksm(vma, vma->vm_start, vma->vm_end, KSM_WALK_MMAP_WRLOCK);
 		if (err)
 			return err;
 	}
@@ -3048,7 +3060,7 @@ int ksm_madvise(struct vm_area_struct *vma, unsigned long start,
 			return 0;		/* just ignore the advice */
 
 		if (vma_has_anon_rmap(vma)) {
-			err = break_ksm(vma, start, end, true);
+			err = break_ksm(vma, start, end, KSM_WALK_MMAP_WRLOCK);
 			if (err)
 				return err;
 		}
-- 
2.34.1


