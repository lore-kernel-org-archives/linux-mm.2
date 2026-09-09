Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF49FC79FBB
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7117B6B00A7; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 676B56B00A6; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42FF86B00A7; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 16BDB6B00A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 462B5A022F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:19 +0000 (UTC)
X-FDA: 85194393438.21.6726B27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9A6BAA0007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcZwPB0q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fT43lELJTSuTapSRQfge6uMBnWbBQLknesZmv7ILLgU=;
	b=W84EWu6VSkVRdyi//QEdUbwSi5UkxBI3jYp3L0pZIDylvrlPLxqGCHeQ1/iBbeETO3wMdS
	ixhTffjhJ5yYWA8coK+W476dZvqMZBQRGaKlHrCWMUfyC8C5UcenrFbUT2z51GU8xCDJo9
	ksMK13YrwNQT8u7bFYs7PKik9cMEPkU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962657;
	b=O953j7Xw1PXLx8D8b8Tk2oF/GSB3GtpIHSiC0GcEVLDvHKhx/1R49qX0ih3INxT9VwHm6n
	XWBdYei9q+4wvkUDdIthoZkRUBZNTCZYmlt0S71GbF6VpiK2U6ms9o/hb7GjbUZIrxTlBC
	ScK2uVd7RKqY/xl2wgSXGtNsL+DvLpM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcZwPB0q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 334C06020C;
	Wed,  9 Sep 2026 14:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6BE01F00ACF;
	Wed,  9 Sep 2026 14:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962656;
	bh=fT43lELJTSuTapSRQfge6uMBnWbBQLknesZmv7ILLgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcZwPB0qrB/sK2rmHLrOG8VFxqZzdxLD+Yrt5RErfNb3SK0iwJtfGaOZXUrzvLNma
	 XOF3Ujgi4A8RMqKAPK2Pb075WlT4Ix4xmTGxfSHxY3oIAC8EfggxNgFykJiZ4cihE4
	 nISmtQ6Ki/BTKWztzWUQRg0o/IRc3XFgAx+F7Hm5mxiz5m6vONdneB0axFrgf4yF/z
	 LvclTuxEFyJJJA2sO71mCPKllk4MvwtprPvzOIGyUGdf7M+YDFEyJ3OuvXc4qvDmAS
	 +RPMfxn3uTAdTGVWimMNfhCG3D3DCzdilmsR6SVS+LDwim0MoBfq8GaERlKd/juuzh
	 /HGeD0r5WOZHg==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH REPOST 3/5] mm/damon/vaddr: support apply_probe
Date: Wed,  9 Sep 2026 07:04:05 -0700
Message-ID: <20260909140408.104699-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909140408.104699-1-sj@kernel.org>
References: <20260909140408.104699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9A6BAA0007
X-Stat-Signature: gin8o9mggp95e51w759zp4rkucyi45zn
X-HE-Tag: 1788962657-729396
X-HE-Meta: U2FsdGVkX1+nDbrEFljcnDwnph0osg8ZOyFcDJdQacngudNjelBrKrp5Sa6MhlOTRA1knWvkF/TP0yOTeQDywlbzSmrFpSVTzRS+LB5wXoAtKKfZhsmDyQ6g3+8MJj2GMFMCReBKLD/f/DzSIvhU2GLluhXt64nq6a0Gc8ulr8wCs2TjIAi8WRwOoMot9SbDQPG1QubgHXFTuC3MAj5uhi1FlluAkGZizQ0H/hSn130paaowb3uoiAlca3GeJcsSIRtv9C0cXz7B0ftnEYYPUb4+TpwIKfasI5gngjhQTFqaL0TmsBidbM6xQYk9vJwtB6PZ3TCHnkuPh/R67c+WDCDpsyWJnQFw9aHmFoWiWG1+/LRXKsqnj4pmPArMJqxur0iz6oluGkZl3tXY9eKmYHVcVt6YOU3ST5Ae4+JdPM7QmM+hXsx2xyW61OAdjPL8zMiGA8e7ua4/J8xMFsngJYrvPlsisiVnzQoFtrFLgr3sxhqEhs9KnaPqsT/6OqkyaRpUvNlYCiYmX2Sk1hncBMHS0mmJYsWLdKbSszFpvWN51V+V1X/gcbHaKyrGaWK46mq0uWtxuvngQKlZPK0KutJBv7NrIONXEMyLumyDhKr+EPjGsGjRFtRJDhjasnPTYzI/Ym/G0ltli3IFsX51A0dcy+F2Sl1BexXusBEkgctiPEwQRIHYyOdc+UwYjMD5/IbB5vOgi51LIDomGz6O6M2qa2z66y7tFGJbO6/RkrCBTj+5phWWCfmlW7jpSwXNmsPSnk4O/LCAZT7tKt+sAtS9p4WNEPyQzaYx4BJm6lDIpLXDUh16iK3O9NAY4OpmPi4kAwJbA7nGntigwhuu8vdbMVnFwjrA5w5dUKVPrV9Mq/1k46u0sGQ4uADTEaCaNupIznWmYNQvcW1nRlI2o5DgUSoQaCgNB/y1QZ9tbzuqsiAyrKu8BurO4QGg2GWC8dLlemsZvKl/+iV8SgO
 Chv6cAU+
 nT7vaM4FLskPqUWs/JE99cJCoqdDx3Lm4EM7v3NaCng0Cp7/3M2RS+Ob8O978nS1A5a2+VTS8nYnyW/1lGspLTbdFjoRGIHjvYz+QC3mL0w+aaukJlh0KVAOivm9So7jkfMjUhZ7Kz38KMxfXJl5HnL7cnF2QTbbFy4uwc7tXN1XCjiOyEiFNzUL+/4B0ic2JadLR52LpCJJkWzFm9w2MN0dvInqIrefqIo8/B7Y8D3hwbWHTMWOHUDJzdA+lXC0pqzfZTf7MJLFTST4gYM6SrNKT7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON virtual address space operation set (vaddr) is not supporting
apply_probe.  Add a minimum support.  Do not support hugetlb pages and
PGIDLE_UNSET filter type for simplicity.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 123 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 123 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 20f4784f17817..7c548ec0cf6b5 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -522,6 +522,128 @@ static void damon_va_prep_probes(struct damon_ctx *ctx, bool set_samples)
 	}
 }
 
+static bool damon_va_filter_pass(struct folio *folio, struct damon_probe *p)
+{
+	struct damon_filter *f;
+	bool pass = true;
+
+	damon_for_each_filter(f, p) {
+		if (damon_ops_filter_match(f, folio)) {
+			pass = f->allow;
+			break;
+		}
+		pass = !f->allow;
+	}
+	return pass;
+}
+
+struct damon_va_probe_walk_private {
+	struct damon_ctx *ctx;
+	struct damon_region *r;
+};
+
+static void damon_va_probe_folio(struct damon_ctx *ctx,
+		struct damon_region *r, struct folio *folio)
+{
+	struct damon_probe *probe;
+	int i = 0;
+
+	damon_for_each_probe(probe, ctx) {
+		if (damon_va_filter_pass(folio, probe))
+			r->probe_hits[i]++;
+		i++;
+	}
+}
+
+static int damon_va_probe_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
+{
+	pte_t *pte;
+	pte_t ptent;
+	spinlock_t *ptl;
+	struct folio *folio;
+	struct damon_va_probe_walk_private *priv = walk->private;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
+
+		if (!pmd_present(pmde))
+			goto huge_out;
+		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
+		if (!folio)
+			goto huge_out;
+		damon_va_probe_folio(priv->ctx, priv->r, folio);
+
+huge_out:
+		spin_unlock(ptl);
+		return 0;
+	}
+#endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
+
+	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
+	if (!pte)
+		return 0;
+	ptent = ptep_get(pte);
+	if (!pte_present(ptent))
+		goto out;
+	folio = vm_normal_folio(walk->vma, addr, ptent);
+	if (!folio)
+		goto out;
+	damon_va_probe_folio(priv->ctx, priv->r, folio);
+
+out:
+	pte_unmap_unlock(pte, ptl);
+	return 0;
+}
+
+static void __damon_va_apply_probes(struct damon_ctx *ctx,
+		struct mm_struct *mm,  struct damon_region *r)
+{
+	struct damon_va_probe_walk_private arg = {
+		.ctx = ctx,
+		.r = r,
+	};
+	struct mm_walk_ops damon_probe_walk_ops = {
+		.pmd_entry = damon_va_probe_pmd_entry,
+		.hugetlb_entry = NULL,
+	};
+	unsigned long addr = r->sampling_addr;
+
+	if (!mm)
+		return;
+
+	damon_va_walk_page_range(mm, addr, addr + 1, &damon_probe_walk_ops,
+			&arg);
+}
+
+static unsigned int damon_va_apply_probes(struct damon_ctx *ctx,
+		bool set_samples, bool return_max_wsum)
+{
+	struct damon_target *t;
+	struct mm_struct *mm;
+	struct damon_region *r;
+	unsigned int max_wsum = 0;
+
+	damon_for_each_target(t, ctx) {
+		mm = damon_get_mm(t);
+		damon_for_each_region(r, t) {
+			if (set_samples)
+				r->sampling_addr = damon_rand(ctx, r->ar.start,
+						r->ar.end);
+			__damon_va_apply_probes(ctx, mm, r);
+			if (return_max_wsum)
+				max_wsum = max(damon_probe_hits_wsum(r, false,
+							ctx), max_wsum);
+		}
+		if (mm)
+			mmput(mm);
+	}
+
+	return max_wsum;
+}
+
 static bool damos_va_filter_young_match(struct damos_filter *filter,
 		struct folio *folio, struct vm_area_struct *vma,
 		unsigned long addr, pte_t *ptep, pmd_t *pmdp)
@@ -951,6 +1073,7 @@ static int __init damon_va_initcall(void)
 		.prepare_access_checks = damon_va_prepare_access_checks,
 		.check_accesses = damon_va_check_accesses,
 		.prep_probes = damon_va_prep_probes,
+		.apply_probes = damon_va_apply_probes,
 		.target_valid = damon_va_target_valid,
 		.cleanup_target = damon_va_cleanup_target,
 		.apply_scheme = damon_va_apply_scheme,
-- 
2.47.3

