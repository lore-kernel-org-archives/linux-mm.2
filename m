Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5079DC79F9E
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 18:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91FC16B0096; Sun,  6 Sep 2026 14:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F6AB6B0098; Sun,  6 Sep 2026 14:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 833686B0099; Sun,  6 Sep 2026 14:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E8086B0096
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:44:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D45F7C052A
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:28 +0000 (UTC)
X-FDA: 85184213016.27.C414280
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4AD651C0006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dml+ayEr;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788720267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvOnZdXRT1oYcTh0OqGiqvrYhRphtRi0kIGud2JHRJM=;
	b=27VXJZwqBK11r7EUZ/0zg1xS8RLFVzau+pwKLqQXq5BDtUkGf2PMfK74kcqnNBhM5kL2UF
	SYLdan4mQUXIaxKL4a/FuC3it5jtLLeJMu+gjeiUf3bu9toUtfQf85WchmfVI2oDQAqd1k
	e3WXdj2+BtlTrgQQBkROK5Rwrh3gnDs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788720267;
	b=zzam/+iSUUojCRR4/geSsMb9a1E7oFuq4rYEQC1mNbNC1xs39Ez9TPLOtGSCbX/uHwlXoD
	4MYK4DjP67nt/uxsSmjCoWALZUQLfT6yBJtKAYIavdBSxhjtkot2UQMplqQ4JkR0HY1M0A
	qqPMM8SwUTg/v0cw9vX56WcUyHn+vdQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dml+ayEr;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C87E60A82;
	Sun,  6 Sep 2026 18:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EBF31F00AC4;
	Sun,  6 Sep 2026 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788720266;
	bh=XvOnZdXRT1oYcTh0OqGiqvrYhRphtRi0kIGud2JHRJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dml+ayEr24UUZMmalGx6HoHSRg65X9HJ6baZH7/ZPWpn7t/kf9eT1Eg8MJY2m5k3O
	 8fn/FqG8+5CpIyntoIkqMeztKJeGOel0ka+hOpzxFu4JaCsvntcoW0MxTpBvb/pBb0
	 SU0AWPKOZFLHzJEDsjjBBpIc8kvrif2l51bgHSQ5Kx+wWnN7qmtqwQPJZJoaTH5gaX
	 zNkCJyrDTiVNBE8d/JQoJnuR4Jr2wzNisZO+DN/vMz2y+10mSlSf4OlD0PMSndARDu
	 U5/+O1WWZ4vpDyeYZtVqsi1VEmwzXMVQPEpuemy+W9bblhZuDEvyjeb5Ks+wG7irQo
	 r15TYuhcXAHOQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/5] mm/damon/vaddr: support pgidle_unset probe filter type
Date: Sun,  6 Sep 2026 11:44:15 -0700
Message-ID: <20260906184417.96621-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906184417.96621-1-sj@kernel.org>
References: <20260906184417.96621-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4AD651C0006
X-Stat-Signature: j5cqp46xw5gn94dezixgwu9qgzcsexw7
X-HE-Tag: 1788720267-463606
X-HE-Meta: U2FsdGVkX1+5hTvDpEZFKEogEA+90cxzRAIyIdfIpYdMNngZQ8WQ3zTJb5XTZTBjHyM+UvKoiZFi/Olcl3WBVAk3V0pDK4aXZjh7vq4WhGG8O6Td7Mq0q2tGfem2gymbjJDt++2Yt63uQ+5HOKhXPU4PJtyPg912E5bXeyBbajNko96HNv7YgciNj3ktLr3x0BKeDPk3ehVk6y1j/PCeU/o64Kgk7zsEnD+t+AeaLzDaXFwe+NRF2WUw047Et4s2c6clmqx63aPdEAeNK+4w7SSnoozl3NCuScK7gDDdKQduApIZZ+gXEW/TbF87lIg2tmrS9v7xjWJ/Phlu4AEl+qkSKFxPC8Lk7n4CPIjulz7Yc18QzoAb30wLE2hevobL/ovUzI4tNUdmUYUjZySwVn1M0AE4SJ4CWyrmCYgxWQDiZosC5qav6vrqpEvjK/9PFEo3meoHmgqzF6ePuOeq3xhf44qLUcDns1aiov7JggzeZY9I+oD5//7B8fxfG1eBy0PZUtkmb1e4SQWAZyR68sZZ4EGiuchpLITOiSEhtd+PGxTNl9zubJmn/23ymjZ+kKGA5XzSny4aC1YB09tdOws8zmSnRZrcjCd5zpvFVclE/ylw45a/zRqUlwraGplc0fR1UR5o5McwtiQxTeIcqqC2ttwXfiMOHbSdhczNoVKmfXxKcryL0zE/JkHizTxJbmw7Oc8pP3N0BrNfrtvkJbLsZBmZzRfM8LQixeIoH2nSmkuoDnEhgGRC9M5cwk5HvgBXPGarN3cVPj9EqR5Cjyz/yW/oEAWbcKemJKRTUAxzXNfO/vQpg2i+TJQ0oYaHJfuynJ/nnRbh+uDImuxEUko6xDYVbe6uA0zzPYG9L4iqMQycmG8+im6PZvDhYKXM1nR+qrszqQpQpfoDWd7kJGtcGWviFMLsTLQliEDw6ZGwqK7yfezw8JTHVUAI4j7n1sOEjNy4+hYcmL2EyBM
 lDWjGh3s
 cwTVXUcz30KkWQA/mch1xVPlw5Jn2zG43hgRPHdZOfbrYNUsSON6Pf6/1fqWxL9wBGFHsLLwrkAmHCNEgVNx3qRziLN1OCYguBWGQUSEdsm6fp6T6uPA9G2GFpx7oYQBgk6+eOvzd7K6erVJr9PVCG0Xn47XFd7QmChR73ntz3xvPZ9O0SpPvY8EZxBWoAhO4xzIotjTi3IdR9dhGSMVh+6lF8If85iub9zP7M6UzTv84BZAHQNATFT6QIHebXGZQvmdK2eSAwm/4E+qfLyewdsHnOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON virtual address space operation set (vaddr) does not support
pgidle_unset probe filter type.  Add the support.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 55 ++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 7 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 45239f05e113b..9a38dc89a156e 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -522,13 +522,49 @@ static void damon_va_prep_probes(struct damon_ctx *ctx, bool set_samples)
 	}
 }
 
-static bool damon_va_filter_pass(struct folio *folio, struct damon_probe *p)
+static bool damon_va_young_addr(struct folio *folio, pte_t *pte, pmd_t *pmd,
+		struct mm_struct *mm, unsigned long addr)
+{
+	bool young = false;
+
+	if (pte)
+		young = pte_young(*pte);
+	else if (pmd)
+		young = pmd_young(*pmd);
+	young = young || !folio_test_idle(folio) ||
+		mmu_notifier_test_young(mm, addr);
+	return young;
+}
+
+static bool damon_va_filter_match(struct damon_filter *filter,
+		struct folio *folio, pte_t *pte, pmd_t *pmd,
+		struct mm_struct *mm, unsigned long addr)
+{
+	bool matched = false;
+
+	switch (filter->type) {
+	case DAMON_FILTER_TYPE_PGIDLE_UNSET:
+		if (!folio)
+			matched = false;
+		else
+			matched = damon_va_young_addr(folio, pte, pmd, mm,
+					addr);
+		break;
+	default:
+		return damon_ops_filter_match(filter, folio);
+	}
+	return matched == filter->matching;
+}
+
+static bool damon_va_filter_pass(struct folio *folio, struct damon_probe *p,
+		pte_t *pte, pmd_t *pmd, struct mm_struct *mm,
+		unsigned long addr)
 {
 	struct damon_filter *f;
 	bool pass = true;
 
 	damon_for_each_filter(f, p) {
-		if (damon_ops_filter_match(f, folio)) {
+		if (damon_va_filter_match(f, folio, pte, pmd, mm, addr)) {
 			pass = f->allow;
 			break;
 		}
@@ -543,13 +579,15 @@ struct damon_va_probe_walk_private {
 };
 
 static void damon_va_probe_folio(struct damon_ctx *ctx,
-		struct damon_region *r, struct folio *folio)
+		struct damon_region *r, struct folio *folio,
+		pte_t *pte, pmd_t *pmd, struct mm_struct *mm)
 {
 	struct damon_probe *probe;
 	int i = 0;
 
 	damon_for_each_probe(probe, ctx) {
-		if (damon_va_filter_pass(folio, probe))
+		if (damon_va_filter_pass(folio, probe, pte, pmd, mm,
+					r->sampling_addr))
 			r->probe_hits[i]++;
 		i++;
 	}
@@ -574,7 +612,8 @@ static int damon_va_probe_pmd_entry(pmd_t *pmd, unsigned long addr,
 		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
 		if (!folio)
 			goto huge_out;
-		damon_va_probe_folio(priv->ctx, priv->r, folio);
+		damon_va_probe_folio(priv->ctx, priv->r, folio, NULL, &pmde,
+				walk->vma->vm_mm);
 
 huge_out:
 		spin_unlock(ptl);
@@ -591,7 +630,8 @@ static int damon_va_probe_pmd_entry(pmd_t *pmd, unsigned long addr,
 	folio = vm_normal_folio(walk->vma, addr, ptent);
 	if (!folio)
 		goto out;
-	damon_va_probe_folio(priv->ctx, priv->r, folio);
+	damon_va_probe_folio(priv->ctx, priv->r, folio, &ptent, NULL,
+			walk->vma->vm_mm);
 
 out:
 	pte_unmap_unlock(pte, ptl);
@@ -615,7 +655,8 @@ static int damon_va_probe_hugetlb_entry(pte_t *pte, unsigned long hmask,
 
 	folio = pfn_folio(pte_pfn(entry));
 	folio_get(folio);
-	damon_va_probe_folio(priv->ctx, priv->r, folio);
+	damon_va_probe_folio(priv->ctx, priv->r, folio, &entry, NULL,
+			walk->vma->vm_mm);
 	folio_put(folio);
 
 out:
-- 
2.47.3

