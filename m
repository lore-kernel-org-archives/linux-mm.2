Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F04C624DB
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 20:27:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB3376B009F; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E15716B00AA; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C196E6B009F; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84B0A6B00A9
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1767BA46CF
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:47 +0000 (UTC)
X-FDA: 85180842054.11.8872590
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 667DB80002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bPeXXfgN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788640005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fT43lELJTSuTapSRQfge6uMBnWbBQLknesZmv7ILLgU=;
	b=jf85Yo2oWwYoZkcJWMPxks84D2/fMcDE7Qwti87WlqHsSRYDb9HgjhwnVLIMZPWRgHT4xa
	hOhuMLgOdN89R6pc/2ED8SFqN2uNCH1XAiy3yDYGVSg2JfmXpJ4ZbXz5rWsoT76Pfr87wN
	SYrg0Cihy+vp5vGoQ8lHRsl8tmQcGtU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788640005;
	b=fA59OGf87wexUDTPzV7w88LCZwZse3O2N7FJxD9GcNxOM+MzIO0+cZAtMFNbw1fdV6TFLn
	TEM5Pvko4trsX5XdcxdTuKO1fGHKSr8K6bYe0jKliL7/RCLzCZKWz/xhVuWMJqmHajrTaV
	0j1k1OTlC8QBOpPPytJbNpmlvC94xxs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bPeXXfgN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C58843FD2;
	Sat,  5 Sep 2026 20:26:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499021F00A3F;
	Sat,  5 Sep 2026 20:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788640004;
	bh=fT43lELJTSuTapSRQfge6uMBnWbBQLknesZmv7ILLgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bPeXXfgNTpyOh45yiXs2EzQRjiiM6Wt1vHoDx5xyU3NeX364Av3sKdvtQDCbe8qHy
	 pVrw5uyfZslrQTGnMJJasukhfK/kewkIoknKBdkSBLEMhTE9E4ODOSrnzrX7rpzEHo
	 QgtK8vLfNpLpe5syT0GsPjo7G0199vs3no+yzWpZumPhCEurk7s4LvdJHsWnnGVqLT
	 C2hzhdWIKS34Trmn5Csy6ojjaWxau7D/uI5UBRj0PFR+iqBmedA24zakW5HI3Fg1tO
	 jaxK70+w3xpBepaL+SqxW0AOB+SfZL9rulaq3Pese1xLqJGD8V5QVyh2D88yvSB1ez
	 fbk0FOHkW2E0A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/5] mm/damon/vaddr: support apply_probe
Date: Sat,  5 Sep 2026 13:26:25 -0700
Message-ID: <20260905202634.88102-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260905202634.88102-1-sj@kernel.org>
References: <20260905202634.88102-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 667DB80002
X-Stat-Signature: b75ijdsub6943as4e9migwnggb7po9zf
X-Rspam-User: 
X-HE-Tag: 1788640005-894308
X-HE-Meta: U2FsdGVkX18eRYlrrKSib+86RJwjQhjAIgUwdP7JU8xV4lD/ahDwVlCKAGGsKfL3DofWvej1E0DXcuDOio/Qaq9CDw1+6yqmwnpX/lRhCX4sz5OWYycTst3j3SzJpp8uAjBXZsVIf+Qx7boHijZaxRndfmSY6xUIjwgkH0NhVLA31i620t9EET1Xbh4J3iyMalZECW77IqISggYjIGv9dUPBlclmaCDbKS7n6p9ApTLZptz7pSx7eysRcjl4UcnofJ26q+85sZCWyWhlsTjB9VwxHUqJFGTbKZTVbk17gudKg+UCxjDJ5pYoRSY4sLj8YpxN6akCUbezY9dpwMsxeEa2p8UIPTWGvxVMXcdPfs/mOlYY/WBpQgrs2IJaVB1UwVgeI12DhXjY4h9gFOL7g71kFfQqAlM2t/VrsSTf5bAqBRi1Ne5NTITAL+foacZxPaEN8iujhEWnKCCdHVlk5TlpEAAfODfz+Y/KiqKbryU+fHfTm6//NtKv7I9Nd0UsP7dpi6YrVpOJCWNOsYTQtqZpetz76ZmeKiibJloyhm6za5/ptRffdhKOzSVbRxEgg/9hgNiPvzq3HP29+77RYObPJ0vHwOH6PJd27txWLFzBg6rKs/bjmlfgIV+UOjJWgfK+Qhw9Ym2g3jNuxQXfBCbmTvJIureh4xOjIScBKG6yoHkwZm3v7wRTUyFP5zvGpELv8vU2A1Pht0PjcpxPN/l+1cW9eDLzvDe7zG+rZHSoOjzo7zbHk8PpJeP0wg1x6O4bEC5H2o0wApPcBAOMMOS0IsI1U2IadgEa0IsvG2U1Ake/ZNsNGv9YUyexdKh3wpzwNX66zfcIh0dwIGj72BFV87xm7isJU3V57KL7p1u/1V9GBwY8mt/39l35b6dOqSZNdv5w0L5CYfIiTOHe2oFHFhvVnR9Wsu5i0GPBIVdWBqf7TOxYTS5w2qIdMDS0HhZcRaXkEDVtT4A6tcS
 7FmTkUvh
 Ai1SVulS58sGtzb8BGNDzfyJj69sSv8d4g0rU7G8CefYwwXL7QuS00WmOL6K4InR/+6GweMJYr/Xm4DPjdRJMpZBIWjP6HynLGur5kdwO7iVur6FNPaUWNYtwO6Y2rqqXqGNvxU3TZzUr06dnipql0R/55GnWdyCtYpQM3OEyQ41Hzx0i+vXL1FWqE36SaZUcdp1w+TF3qjDtHHfoIXc8S81JZ5Uhl+xco0rOBU3p7ep+q74rNIptl01XlfwiMZ7eEorOxmB3N9xSsDuq1LdNHO8QOQ==
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

