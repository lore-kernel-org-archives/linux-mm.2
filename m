Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56CD6D3ABEF
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F8A06B000E; Mon,  8 Dec 2025 01:30:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581636B0010; Mon,  8 Dec 2025 01:30:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF496B0011; Mon,  8 Dec 2025 01:30:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 38F206B000E
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:01 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EF68913BF5B
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:00 +0000 (UTC)
X-FDA: 84195328560.16.4B53536
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3369F1C0004
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ChdeafpH;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mi4kZ1HcWEGoo2TO8+D7Kmn8urbymUqIL0LPjzAiLx8=;
	b=rOoeLx4I1yGnGK5E0aeFfQuIIELDq1B/oRB420Qg2d74H9QDRZQiAgWuoqsf/Xt1qxWNkG
	rlBZaPuIdR6SK68u7y2Wwx4whM8vdKbfbBYbpdyhWL8vesJgqA0zc4uQYEH6mjamYLvDEK
	4nwzXao8EHbis1Ue1s9WO+686G2WBgs=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ChdeafpH;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175399; a=rsa-sha256;
	cv=none;
	b=J+l1P2M1fWRgLrTviAfG0z5x58+DWuHvjeGTD98gjhGWEq6ULDICtbpZ+FuOZkdJWgeyyA
	d245DF64f/uh1BGUdNDzgaIsUzoLbNwmfde0x6sfrAmr8vm2Rf18xfUAotlEBByKtuT4C0
	+4ujDP1r+o26btD+Z6RDVvhfgU+djr8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A65B44393;
	Mon,  8 Dec 2025 06:29:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52020C4CEF1;
	Mon,  8 Dec 2025 06:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175398;
	bh=FU7PUMIztU6bHn9o0PvCgnBq3cHVYIdbgyjQa5N1taw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ChdeafpH4rH6YL3o1OKRhEuJQnPqQu9MWx0FDHaiJjG2zbJafy/3MUasBBnoQ6ERw
	 8+RMDYPSMQ+pQtclPsOp/r6aNzokcl/inkk19+vYiY8FJ7pA58bWrpi14lANsZukl7
	 v0z7oACIteOEGOzdjcln69EjPOT1UAQIgQ3UbdJWpvjhLq2yZZORheMgWQQGXMNk8L
	 XuziggKbS2BuzHsZ8rl1O+5R28lNck8cQjOZFnftcgl0/ReiHNbauEqMjxBxb1zJbD
	 3Bcuc20nOgtGmJ68jLXrUEyi4yXMNKphfR5Ol8MsHs6c10Qp8xuwzX4+emNNQx3RfG
	 gIuiMu3ys40mQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 06/37] mm/damon/paddr: support page fault access check primitive
Date: Sun,  7 Dec 2025 22:29:10 -0800
Message-ID: <20251208062943.68824-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: arzos6y3hmbt1c9zh9yh41yr84ji64mp
X-Rspamd-Queue-Id: 3369F1C0004
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765175398-717881
X-HE-Meta: U2FsdGVkX19kfZGQpQE3R4DSp2ZXQbGbnB3yXTJUh2iTW7T9UoDEMYVR+Ua01pKIwNu4OuBvh4ouxfbJ0aerfBmxeaBiyMsQ4Rl/OSWPjKayfx5qIdZ6zjrn/kj/5Nv7iyFp9kmQDkWxN4fLV5HR5vA1Ll4ukjgVF74VxEhboy0hVAgAw2th+mm01tyeZd5YtzDpILDpNMId/Gvw4fQ70bZvIzpLnoHDTWFnVWZDp0aEVxFaiT9kwFIjVsx+jI2Uci5vgZJgNhJJ5j1b7XF4OyLsYtP1FkhPEaLj28CJDqmnIikqhrbDhpYUysxj2bp1FuGv90FTp/FQ4iOLCGCGqt+eW6sZyiUsyxkcoL+saqHOc7Sm9dBXiAxfzzKLAIzqNBqgql+eW2a/1Us8Hje4OSuuE9c140Sw8aftjCwq8wYR7PCQ40SlfBoY+jitdWXogeJ5fgf50uzmMhQa35QJt517hI/pbyqrafkcS3PrgxCQuZ6HzyNMHUsxcSYVKTZt15zU76NRhpB1A6Yb1gJpdXwc4/Ml9iZWdji9qMDHrQuI5WDju11VVfcl3PV1n5jHezV37jj0LGRqE98UPvlncB37y3W6igY8mF8tHSr97xtjd+PUMiYM4hMTaGnz1uCdyUt2dP4wnoZuKAbijqMT6DX91bPvkXEQLbC6g0umehQZWJMt1NqGlmUVn/lNfYpDtKF9yzB8nKOxI03bAAYFrLPi63trsPh8DwAhNEHsGrYbzZauu4ADdnCttN/h5w1yBjix+Lhi9GI4PvqFBEijV9ziyI444s5EkygjIVEppT5GyueMze2RUhpQbAzpp3Jda/sr46Lz/nScp4n9kf4K0ETLUAn4aYTP9GKXwqOFU07qEYmNfXT62eAqAGadoeMf901Epz6/AEiwnwvkYfnLi30t3E1TOoV+88fn3W1qC5/J78Xfwr+jrlZEyCegBtqVXK1P91BuThB7kLxY+bP
 JsWHQG0M
 ZpIJCL4EN5cFuQjyljNDqzQWvfYyIVtXvv+mTv2ySNibElgyn20ETyXe0gyfQUCiPHWv30NhYmxhqXMvrsuC0/MT7J8qY5T8U573P1KnoSRJDI325YY07rRZ7lbZzVYegim4S6YBqqLCm9SQF4luGZSinIOD0NBW15x5YI6stOmVmU69fqhjVBBevZayZGeRmRzG9pCSQraIh0HaZoaX1TQ2MWYwHGlp41s3vaCMQfut/spR79yomDPNp88mivVD3EurcOCW2C86sthdVp/fserP77RuEK1izU+LUfrls6gK/cCI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend DAMON operation set for the physical address space (paddr) to
support page fault access check primitive.  When DAMON core layer asks
it to use page fault events as its access check primitive, paddr will
install PROT_NONE protection to access sampling target pages, in a way
similar to NUMA_HINT_FAULTS, using the non-upstreamable hack that was
added by the previous commit.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 66 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 65 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 07a8aead439e..698ca6b9dde6 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -14,6 +14,7 @@
 #include <linux/swap.h>
 #include <linux/memory-tiers.h>
 #include <linux/mm_inline.h>
+#include <asm/tlb.h>
 
 #include "../internal.h"
 #include "ops-common.h"
@@ -56,7 +57,8 @@ static void __damon_pa_prepare_access_check(struct damon_region *r,
 	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, addr_unit));
 }
 
-static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
+/* Use page table accessed bits */
+static void damon_pa_prepare_access_checks_abit(struct damon_ctx *ctx)
 {
 	struct damon_target *t;
 	struct damon_region *r;
@@ -67,6 +69,68 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 	}
 }
 
+static bool damon_pa_change_protection_one(struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr, void *arg)
+{
+	/* todo: batch or remove tlb flushing */
+	struct mmu_gather tlb;
+
+	if (!vma_is_accessible(vma))
+		return true;
+
+	tlb_gather_mmu(&tlb, vma->vm_mm);
+
+	change_protection(&tlb, vma, addr, addr + PAGE_SIZE, MM_CP_DAMON);
+
+	tlb_finish_mmu(&tlb);
+	return true;
+}
+
+static void damon_pa_change_protection(unsigned long paddr)
+{
+	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
+	struct rmap_walk_control rwc = {
+		.rmap_one = damon_pa_change_protection_one,
+		.anon_lock = folio_lock_anon_vma_read,
+	};
+	bool need_lock;
+
+	if (!folio)
+		return;
+	if (!folio_mapped(folio) || !folio_raw_mapping(folio))
+		return;
+
+	need_lock = !folio_test_anon(folio) || folio_test_ksm(folio);
+	if (need_lock && !folio_trylock(folio))
+		return;
+
+	rmap_walk(folio, &rwc);
+
+	if (need_lock)
+		folio_unlock(folio);
+}
+
+static void damon_pa_prepare_access_checks_faults(struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t) {
+			r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
+			damon_pa_change_protection(r->sampling_addr);
+		}
+	}
+}
+
+static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
+{
+	if (ctx->sample_control.primitives_enabled.page_table)
+		damon_pa_prepare_access_checks_abit(ctx);
+	if (ctx->sample_control.primitives_enabled.page_fault)
+		damon_pa_prepare_access_checks_faults(ctx);
+}
+
 static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
-- 
2.47.3

