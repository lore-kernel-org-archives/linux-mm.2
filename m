Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BCF6C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B7A26B00A2; Tue,  7 Jul 2026 09:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 068486B00A5; Tue,  7 Jul 2026 09:00:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E72876B00A6; Tue,  7 Jul 2026 09:00:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B17346B00A2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:00:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1FABF140415
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:00:35 +0000 (UTC)
X-FDA: 84961989630.17.BB20F5B
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf26.hostedemail.com (Postfix) with ESMTP id 04BA9140015
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:00:32 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Eo3qK+q9;
	spf=pass (imf26.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783429233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5W5DUkb1JUBfDdw5NFLWUB/50kxa7q0vorvfnztH0I4=;
	b=cm4W2ev39wvrw7tFkepB+j5Dca8xnm1PprMAlb9EYnlv3iWEG+yVaP0N2jpz4fMW3WIlFP
	CU+DdCNGi0LfWWnbIaJXgT1OkpXGjwXoxeNbIyNYcq/Ya0ZTZgetGtamGKQK2XU6bSZFN8
	hCqPkXlcq6TCoKq969bLKIpdFkAEsUc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Eo3qK+q9;
	spf=pass (imf26.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783429233;
	b=x8FbJAavYYCQ95gQ++BIXSTsruYcWnkzpEcpaMtYsxjKKXwpGIfUivvSLHET9+nHlHU8Hh
	SkbvNFjAe/SruAcQHOR06bz2DCG+VWeSAZ9kS6PixxwBCpCCO3/SjdZ0psbR+1OL2sctdc
	JhCxbDPf61IZ433Jid22HRBxbZqDgMk=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-c999d839661so796994a12.0
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 06:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783429232; x=1784034032; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5W5DUkb1JUBfDdw5NFLWUB/50kxa7q0vorvfnztH0I4=;
        b=Eo3qK+q9+zrMoHyQmh/BaIv7Raf6gZQfF06+ycl/VSEhmNhRnezc+X9H/gm0qZGDuN
         99S6TjxbKZ/q8JsHk6eQXAg7wNfhQAlG0ASsNZ/gSgcz4W6WWIZ+GqbB38m1ce9AEJhB
         bRBeVUU2yQdlvsTaFqBrdGICxArsm0SiZgJCoovBybPmMGFNrOSZ6OO6+b/t1NQdFdqu
         8kwHZaqeVt157vsZ5/te9xNplwsPsV3eqqGFzKtzZzsvauUa1+/4rLDRd42nHRdoZlbA
         xOD2cNW0wi/mnFw1TmZV/AeDOYqGVnCIU0CTusaW6o7kxAwhRMvx4bLqz74ez/f+e5nM
         NENQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783429232; x=1784034032;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5W5DUkb1JUBfDdw5NFLWUB/50kxa7q0vorvfnztH0I4=;
        b=J4QrK/Vd9Z8dwPzRx4xaXsL9F1T5Q1yorZEfIXkIU9ra9KCokzbBLjOe66RliWteTA
         yXniglKzml222LysPvNVkws9CAQENdI7/QAqP269V/u83vGt7A8NAf2WdjHHzXBbgbwQ
         ThbVQB6F5/iQcsbNNDwba/pPWMQR48pqI+PupT6UfbkOJiNxgJG97SuMY9/IEj+N8IHv
         AiM/feTyRcnTKODLkRVB2+VA95VzPwE88/VdZQ9XC82oNXg+OKS2I6zifcNYCW8RjFst
         NOkXFkOGUAvIBb1NQaFmVD4t+uFAQPjRagg+UpNtDEFlfo1lb6KaMrNiqVO4DoUs0/Mq
         nycw==
X-Forwarded-Encrypted: i=1; AHgh+RpX1jjC0SQ9m/AqfNLP8KyNmg/kng8Bwp5GOazNR6TosapvQsRQM0z8fxp8aDitTX70LSYwR6romQ==@kvack.org
X-Gm-Message-State: AOJu0Ywbbbix1CNM4LYwwLnGyA7fxwdI+C7+uEQApJlgDk+UDTk+qzMo
	DfTyrUodyiqoo7UfSG9DDBrtpvEGSvfwqEG6ZWbC7cuwk62O4VOP5PVD
X-Gm-Gg: AfdE7clL8QWk9XUnHN3XJvDrV5ubNG2zBfzJJ+hi1nKBPN7S6W8wKB8FgG3ZIEIqUN7
	QKUbFaz3MGkshVEVC+I4SVtBqFt1Glq0Bsut+kzK9n4A5q63NwF43YVvpNr2jkHCm1kpBALLtDJ
	77zvkojXkv9BjwzH7BRAx4kfB480dbS/P+CkkIQnBJE/wHyEmkFrWcf+m54vRi4aeEK1SksKYO3
	eYUsh0a1StO85qKdGi5sBt+ZjUT3EaNtf2k5aI/4SC/xiMwaOB11l/o99Ybn7y6KfztRR4F6+HT
	AyQx8ohyPl2R7y0sezS7kKfO1Ezz3X9G9XWqJosv62KNEvDWlte5WjmplhP4+Zb8MjsTVf0CTu4
	ttUsD8i/UYN2S+/Jy+l73ikXHrdg2NJUTGDc0iSF3uy17xKMPPtLguMeatTBKchKAzrUngvOsMi
	fytk9l+BX+pKBwUQRa0Ig1tt5wsw==
X-Received: by 2002:a05:6a00:1819:b0:847:8b1d:22fe with SMTP id d2e1a72fcca58-84826df12a7mr4541501b3a.50.1783429231350;
        Tue, 07 Jul 2026 06:00:31 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6b5e566sm5415983b3a.3.2026.07.07.06.00.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 06:00:30 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: vbabka@kernel.org,
	david@kernel.org,
	rostedt@goodmis.org,
	mhiramat@kernel.org,
	Alexander.Krabler@kuka.com,
	hughd@google.com,
	fvdl@google.com,
	bigeasy@linutronix.de,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Cc: akpm@linux-foundation.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	pfalcato@suse.de
Subject: [PATCH v2 4/4] mm/mlock: migrate folios out of CMA when mlocking a range
Date: Tue,  7 Jul 2026 20:59:25 +0800
Message-ID: <20260707125925.3725177-5-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260707125925.3725177-1-chenwandun1@gmail.com>
References: <20260707125925.3725177-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 04BA9140015
X-Stat-Signature: hz1yft5it7tohm54rg9iwis14eweufij
X-HE-Tag: 1783429232-826023
X-HE-Meta: U2FsdGVkX1+T8qgWGAGRJ0fb90Mc9prL5b+eg2qL1x+A393tzwVqbqBZbmP/fTPhxHHV1QAHQNznDUUolgv8mbaeEKOl14WcEWKWxpWIwesPMaUp1z6hmBYKRkqIpRkRr6Ikphd+cgt9oaXghcnM/pqAVM7qjv2yQWPm5W35B008AuXyFVRdW7XdCqhDHdJp9oYHibCp7KTXnpEEQSJMXSAuEvPJK7C3UpyV+hrinfV1BKZreerbpzCQUx5p5TfKirtB8bzCUW1rkFGpO/27/e2IgziOTSmlnSohaqV3YVSBZ0+qxmnSBQKxPd2dWLKQ0yru051a4/gz5orLGvyLBZzK2f7O6A/LZrnuQcK8x3XRRojX6gjumRNOCr832CnQgk9ES6eGElabIqVoGrpsC8LHl/R787/m5xqsmVLWQa6EYIFqDV/+QV2oLSvXWqUDkWSTkz2FMZgTteJbBD4Pq1XOLbME2itTPWbKrEXEieyTXRfot2YLTqlDkPaY+083QaLQyI52n2mkWuy6LUHKAeOas0SotMgKzOVWRQ2rNX1+PNWOWAfqxUFweF/ntn11GBWCP2/C3IdmL1WSy8LSXm08Mgj9NB2au6z38f4VD/ZqzGP+Om3qmU8zTl0k3Qq/N0yHmzQ4bOaHTRgQp4im8bYwvk2oK4TrTbs8dMP0C6DEVtnBsuZvqIcH7YjlYhIcKPE1LHZnvyRy7x8t5PBATfBVSuu+jjrl5ht5lj0XWAh+udiAayn12+tVqxG8j/6TRehonMGoQLXkWMzpu2OJgu2uDZ4MZzW50B8Gg5ssKE4K0HIXVyUURPJDCWGeOp2yesftJGewGB0ufrhByvNxwnb3OzgL5U1budCGxPdRV0KDrHfGRo990OpZBD0WqWXWFJpEvgS4VVVdSEd7xDyPO06yBsfhpjb8eWrmZf2mKiNEFBqlQ/Y/2rm6AxJYK5MJozSLxjHmo5Z+dRJEFWR
 jgbjEkQz
 l+mRrVt83dW5uCK/mpNOG/ygphc9unCs6TeYC/C4CPsvYJa8tSW7217FdN7B01x3k1iIaroWA8yvz+Af7bOxQ1dosxVFlwgqswrtSa1tJjjr0j4fkIuCMjKzLwQkQdoM+h7pXvOs6CL+GdNzjQvhdrPr3lXBWi/bRDYRe6F/XPec5lPF8I4SZVRJFvw4lq58YeEXJL9FlsrbiQRjIOU7kSAmVwdqB9kWSbfqvXeauir/p1xTeYdR9D6U1hJOTIYA8lEnfR81/mocWDUCaGNLxA2106FRcCXgCzVrjdxKVJ9lG0HGJy2peLnURocnIR82GnUxYfno1KPuLWrKE2bA7Qpj/DYYaS853UMLV/BYKxw//eM745HniTHYDxXIlptisBNzy8mq1Ye6vdqegZJSGiKsUVbsbc8rRLpcHp6kPm6A3L15QLWEJ/6TucLwj04838+CmND7LjQO86Y2Usr+AKOuship7qEUHNHTcLFL0iVbd2A40sQee2sVKP8PgEvDAwQ6CXIFF1/b6pWejNmDOCFbvKWIVnSODtwPAEbjLuoJHE7Q2rHEfwPuexQz3v7tmHeqViYo518lvV3g3GuyQ30vvNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

The region covered by mlock[all] may contain CMA pages. cma_alloc installs
migration entries in the page table, if a memory access occurs at this
point, it must wait for the migration to complete, which may cause
latency spikes on the RT kernels.

Try to move the migration cost into the mlock[all] caller, which is
typically a setup path. So reduce the chance of latency spikes on RT
kernels by migrating the currently mapped CMA pages out of CMA region.

Suggested-by: Frank van der Linden <fvdl@google.com>
Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Link: https://lore.kernel.org/all/CAPTztWZpnX1j8-7yeppVUsxE=O9hbVeqricDjZt8_pnN7a-kBQ@mail.gmail.com/#t
---
 mm/mlock.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 118 insertions(+), 1 deletion(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index ac65de40b22b..f56c685533f5 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -25,6 +25,7 @@
 #include <linux/memcontrol.h>
 #include <linux/mm_inline.h>
 #include <linux/secretmem.h>
+#include <linux/migrate.h>
 #include <linux/compaction.h>
 
 #include "internal.h"
@@ -428,6 +429,119 @@ static int mlock_pte_range(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 
+#ifdef CONFIG_CMA
+static int mlock_collect_migratable_pte_range(pmd_t *pmd, unsigned long addr,
+			unsigned long end, struct mm_walk *walk)
+{
+	struct vm_area_struct *vma = walk->vma;
+	struct list_head *folio_list = walk->private;
+	spinlock_t *ptl;
+	pte_t *start_pte, *pte;
+	pte_t ptent;
+	struct folio *folio;
+	unsigned int step = 1;
+
+	if (!(vma->vm_flags & VM_LOCKED))
+		return 0;
+
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
+		if (!pmd_present(*pmd)) {
+			if (unlikely(softleaf_is_migration(softleaf_from_pmd(*pmd)))) {
+				spin_unlock(ptl);
+				pmd_migration_entry_wait(vma->vm_mm, pmd);
+				walk->action = ACTION_AGAIN;
+				return 0;
+			}
+			goto out;
+		}
+		if (is_huge_zero_pmd(*pmd))
+			goto out;
+		folio = pmd_folio(*pmd);
+		if (folio_is_zone_device(folio))
+			goto out;
+		if (is_migrate_cma_page(&folio->page))
+			isolate_folio_to_list(folio, folio_list);
+		goto out;
+	}
+
+	start_pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!start_pte) {
+		walk->action = ACTION_AGAIN;
+		return 0;
+	}
+
+	for (pte = start_pte; addr != end; pte += step, addr += step * PAGE_SIZE) {
+		step = 1;
+		ptent = ptep_get(pte);
+		if (!pte_present(ptent)) {
+			if (unlikely(softleaf_is_migration(softleaf_from_pte(ptent)))) {
+				pte_unmap_unlock(start_pte, ptl);
+				migration_entry_wait(vma->vm_mm, pmd, addr);
+				walk->action = ACTION_AGAIN;
+				return 0;
+			}
+			continue;
+		}
+		folio = vm_normal_folio(vma, addr, ptent);
+		if (!folio || folio_is_zone_device(folio))
+			continue;
+		step = folio_mlock_step(folio, pte, addr, end);
+		if (is_migrate_cma_page(&folio->page))
+			continue;
+		isolate_folio_to_list(folio, folio_list);
+	}
+	pte_unmap(start_pte);
+out:
+	spin_unlock(ptl);
+	cond_resched();
+	return 0;
+}
+
+static const struct mm_walk_ops mlock_collect_migratable_ops = {
+	.pmd_entry	= mlock_collect_migratable_pte_range,
+	.walk_lock	= PGWALK_RDLOCK,
+};
+
+static void mlock_migrate_cma_range(unsigned long start, unsigned long len)
+{
+	struct mm_struct *mm = current->mm;
+	unsigned long end = start + len;
+	LIST_HEAD(folio_list);
+	struct migration_target_control mtc = {
+		.nid = NUMA_NO_NODE,
+		.gfp_mask = GFP_HIGHUSER | __GFP_NOWARN,
+		.reason = MR_SYSCALL,
+	};
+
+	if (compaction_allow_unevictable())
+		return;
+
+	lru_cache_disable();
+
+	if (mmap_read_lock_killable(mm))
+		goto out;
+
+	walk_page_range(mm, start, end, &mlock_collect_migratable_ops,
+			&folio_list);
+	mmap_read_unlock(mm);
+
+	if (list_empty(&folio_list))
+		goto out;
+
+	if (migrate_pages(&folio_list, alloc_migration_target, NULL,
+			  (unsigned long)&mtc, MIGRATE_SYNC, MR_SYSCALL, NULL))
+		putback_movable_pages(&folio_list);
+out:
+	lru_cache_enable();
+}
+#else
+static inline void mlock_migrate_cma_range(unsigned long start,
+					   unsigned long len)
+{
+}
+#endif /* CONFIG_CMA */
+
 /*
  * mlock_vma_pages_range() - mlock any pages already in the range,
  *                           or munlock all pages in the range.
@@ -678,6 +792,7 @@ static __must_check int do_mlock(unsigned long start, size_t len, vm_flags_t fla
 	error = __mm_populate(start, len, 0);
 	if (error)
 		return __mlock_posix_error_return(error);
+	mlock_migrate_cma_range(start, len);
 	return 0;
 }
 
@@ -790,8 +905,10 @@ SYSCALL_DEFINE1(mlockall, int, flags)
 	    capable(CAP_IPC_LOCK))
 		ret = apply_mlockall_flags(flags);
 	mmap_write_unlock(current->mm);
-	if (!ret && (flags & MCL_CURRENT))
+	if (!ret && (flags & MCL_CURRENT)) {
 		mm_populate(0, TASK_SIZE);
+		mlock_migrate_cma_range(0, TASK_SIZE);
+	}
 
 	return ret;
 }
-- 
2.43.0


