Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD8B9C79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 18:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF3CF6B0092; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF106B0095; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796556B0096; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48AC76B0092
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CCA784057D
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:27 +0000 (UTC)
X-FDA: 85184212974.11.1F1F2E0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 42B82100003
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:26 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fptJiqML;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788720266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fT43lELJTSuTapSRQfge6uMBnWbBQLknesZmv7ILLgU=;
	b=7XAvBvX5OVlWinYZJbIUiAZAFYeoy90S7un0jK7cfAE8ppJnASkxP/FDlCNSkbyQr3FGKV
	XBZLaypY0l/9PJa528K42sCQAvJ8QNoX6l7lTipQHxkIWUJwyG0DrIXPrBkmeV8XPJdMxc
	P77oQTf5nEPYH8ilRfTQ4wf6iKcndIA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fptJiqML;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788720266;
	b=7FbGieNxweJ+ilIuuZI2/+YLCpQ5EpE3MYOXzDyS2x0PYyEudhL+2jjjsoNh+bGK/Yl/Bl
	VjlK4jZJ0ENxgprNiOD99gYzgWaTmRNGbQOnI/t1nVioZmBQ1E4DaS/B7VFo3gP/n43NGr
	LIfbORbWMpiC2oe8nLWfyvioz7iu29Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D512D60A7A;
	Sun,  6 Sep 2026 18:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E031F00A3D;
	Sun,  6 Sep 2026 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788720265;
	bh=fT43lELJTSuTapSRQfge6uMBnWbBQLknesZmv7ILLgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fptJiqMLnFoVvfozWpflit8hevz2h9egLe3eLwRM1ZWLB1vr1jgbNLvtmVZ9QTtNM
	 hHIhvoTYrh6QFgcY0zExLRS5mTJLPoUF1AdSYgxZScibjbzo5C9Uda9//e3c/R3mV2
	 P5G81GhcCt47JWewuBi/ynEsgAgcDIediO/VqR8sKukHb+0Pq6fHdPSsddJLULPEzr
	 KTqE5U+Par+YUVuHtG0jXimxJLGf6KssOgu67owr3sXUxpSrCDiRCjRfOn9P4GdPuO
	 dINeqPbO6bwKPr+aAjn/JBMI08NiYSxjdJPKQz/gFrcg0oQZ+z4PmIYjnvHKuwxmE8
	 WHI0hCx0xzT6A==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/5] mm/damon/vaddr: support apply_probe
Date: Sun,  6 Sep 2026 11:44:13 -0700
Message-ID: <20260906184417.96621-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906184417.96621-1-sj@kernel.org>
References: <20260906184417.96621-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 42B82100003
X-Stat-Signature: 3tz7ehyn374g6ftdrueyad7qdu9qaacg
X-Rspam-User: 
X-HE-Tag: 1788720266-799778
X-HE-Meta: U2FsdGVkX18wJOialp9fqLwXcsrHt972yEVmpajW8HPuIOvpTAxAVldZtGnmORcXQOCAMRfBklISvDXyTLR8TIT+tQsDfUiBPIrYS6rgphWj5q99NotA89jW1WFsje8+d1pVwu2e3JD5wm0ZLDds5e8WlUDhcK1txO5GhdE1PnP/WN7EMTHi5mM3zDkwZcyAkzzAEkFkmRKDL+o92Qp0gGzZgU2KYhRmsFL4Sbq3cBq604CeK6muiEPYZECi4PURzct8QCoO4LJT1Wa8o1CfgeF6ieqMAc21fCQOeg3Hht9W1q5QSmN/VqDG9sfXK0QMphSVLZeQsRDWRXqYMAgQX1mfAWt3GeVRsCM5BPVXM5lZ5pCo++nFN6b3TwH22Bh6PBVsZTC79SyVzjAIsUC3VkkhoI3jHySQmB1dsg9hSBnkivU4YyjeXUshkylDYSHqjDJMaIS0NIXmtyCwBnvuzBdYkll711II8WPtaQgJ1Et5gTxI0e8BBRG0aAmkBpcc7bcap36XjsmbbLWR5gV56d/vyjhDUZwWqOvhgeWKq68x0ytoSYSQBEqUj93Uf736ccXkuC5uSARqtDsx8sqEZLOHaEYk61oY5pXz5fYhMYzrGxgdV7N7vy/RO4ze0OGyvOcV0u9BtpW2zN6K3HCAR62UTebUxn9IFg5D7wzPsmYcJ5KZIyDiqQduBukmdgLnOsa+RqpBssu9ygnVHDDxXDZwsZyn3tZdMZlrIdZbzGsEeRS9jotACo/jUrWLPYTEneczht1JSLpytGk/xoCSb6lp38AhUcoPQycM4RYmpHt1SfpR0Igy6L/LlUdXohSnihoouAsZYH8XA37YqQsJz/cVRlWNaLsT1julsm0+JeJFi6jXL0RIcSBYabPxLbeIwxSwgu2SXe0y8LEZGvejPo3imsY6/1l4/tQlotspfIDiKRiN7TLdea5ZxMbVL4ahX9PdcG+M2hpY7ESL2fv
 9cewNEJK
 s1cvIFZ7cPIuzQNEO29kKjEt6WkBLEVQqviKZi9RlJ2/35vtqhEY9+7QVNPCB1JmGRxWVzHCvSq541REcuNuEL9CQDGJgvuxhBoGhBEpy7yv38poyaNIKopDjfGSdyGKeXTNuKKNkeNg1qNTsxPbaXOEuEyLeoIO4XwytOXl21edUCY1/dZZ5VcjgsRdd1uS1lmHOF4JbP4/aYBvTcgQp3behIufPEz1Z7MbBeSYOxwGmTIv7O7qCsXeZk3L4YZXtUzZ/WxJUBfxwe0gxkrFor7FZjg==
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

