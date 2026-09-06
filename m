Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8313C79FA0
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 18:44:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D65696B0095; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D39EB6B0096; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB4E56B0099; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9017A6B0096
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 14:44:28 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A5EC1605DE
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:28 +0000 (UTC)
X-FDA: 85184213016.25.F92FF78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8C695140006
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 18:44:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQbWV+hl;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788720266;
	b=kSpO56WpFtMbnYXkcDVPggapKEQSQqtCguZ4rgEh7d8IXyY9zxosb2P53eSfJRapDqvXf7
	9JHocOM+eCdBepISQu/a08RCC0RNEPkpEDDQyIxsaUEiMJnwa4/3xv3XHygOEtLOBOvc9O
	Va8z00ifOF08yAsaq+mjpnhXChc/H50=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UQbWV+hl;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788720266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljZqDnomsr/PzAJ3OgMACOqJ7QipPXHSesCap1Ut72A=;
	b=SL3+NDo8AkFftkil5dsSC//RpQve2pvlEY7MoxKW+nqT0RIYa5w03vUATTKQaaHk8sxt1h
	IKV3xaz5OxBMmuSK8pvG8y5tRRIdiyq6M4FUtdrZfCu36LnsclbqIVGMkxmRefYuPLPNRa
	PFxydDPv5QS3NpVR2PdGpz/zkRBEyAQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EC77602BE;
	Sun,  6 Sep 2026 18:44:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E3C1F00ACA;
	Sun,  6 Sep 2026 18:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788720265;
	bh=ljZqDnomsr/PzAJ3OgMACOqJ7QipPXHSesCap1Ut72A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UQbWV+hlw1vP2O5XL/zZT6lPjnNM7O1MsGOLh72/QmjDPEoUvAjuL2kB2yemHuDuX
	 htZe3KwQFoIAto4At5KPdjdhTcdaW41ZBRdGx0gundK+lsNHissbNMzSHFYYdKO/nM
	 NEV2lzx5az1U+YdCQxefM9AofJxPVczIKLH8lOG9UWBxrJ0Z3KX13sZhlLqcf6tcCF
	 4INaBVaMJSBU5BsslNSFCdTZsdeYhACYdMdUTCZfw6KT+5kiEeeXSckmSsmYOEEOgQ
	 9G0qcI318d3dTsDT8Nq8RtJHDLz19aChc1GL5hjdF1kfyTdUf9larTwQLElO3v/SvB
	 z5aSLBSzbGT9w==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/5] mm/damon/vaddr: extend apply_probes() for hugetlb
Date: Sun,  6 Sep 2026 11:44:14 -0700
Message-ID: <20260906184417.96621-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260906184417.96621-1-sj@kernel.org>
References: <20260906184417.96621-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8C695140006
X-Stat-Signature: 79kjmqi8obappzzd4fhg7wa3w919gcg3
X-HE-Tag: 1788720266-736038
X-HE-Meta: U2FsdGVkX1/5y5MrlmRyg/4jowRZs/Cw1H0RflVexY3iM8MX28J3okwyRBuwcQf3YvwKpb93+fexcJ8fXs6ZxKZ6GSRoYnYYJ+7ze255SeQqwh4RGPRRcHUFBnX1p3tOFfopm+NY0YaevJhNYtftMMntJUC+e3ND082jRB7dQohges2mmB9LP+fYTLSshi3diRD4YUirnMVaiNi/Y3rYNTaH9gjUZ5UxaFYlu3EVdd92cmas2Yeg401XuQ/2c0fD1WaSLFezlpj6i4pG4JvVR5yveQTAubEmTFRZZi/X1I92Gtybn37Bc/VBRLwhK2O8LOc1XwUV7YT6HPeLy9AZboa32Z+El0ug5zJ7DK5kVq2rEzDoGUHGjlqERIB+J7socYqosQMUPv3i7th0v85Q5yW30567j+3oSNKwcvSMU7F1t/cqY4g+q6CiyAc5KYcrNUjls/kSbQ1Z7KEyQzYYJ6LygdKBsWLnOXqIN1f7ZRH2UcpkXCVaKZ19BWrvZDoaVVOXbrDZN04IN4uFWAkBuhYh+uS1nNaeOXE6c1yDfEY5D5bM5RcCqZozXEVcXgmWEVWVL+Si91nBFSDNMobubkzzgwLJd2TiLIPwgOQeLr5pKg2o/+YvvGYVeKvL4AXJfvp7OS1zoRsKY8co6OT8CyNpxOOM0Q7DlRGKnXyks0pk+FJryHNMs6JYMZNRNv1TKFZPO4dcjUJMvhXmbm8Mo6QddlY4FvDOTu1Y18JgHvVIZSIBDxZ7cAw/LsulhROfQJZIAedsEuR7X60iTModHzwvdmaKFabDep4bl5YWh2VgGE8AQ1o5XP9mr2iY5HIwLuurbhIbatzZlKS9y3RqeymOezIpv59hJZmRMo57iiZK5//ELJOOQn7RgTpD2vMkm9tlEwA+QE1i1kHoQTC4mw6eRUst22YVdphvUaqXt7wQXeMd0CCT3u1bEmIJe/ETqHh7S9TlSB+UcKtW5ro
 FE5F6Jpc
 lzbGHTZskVkqs04UOV4U7fQCahTqT9bjcEmnigT+GhGF6ctqD1HrzENBYyx8jj8xGGAJMWGqH9Z2VcJvsP+KFRCYHa+7+0CuQlIu+tZA+BBekJdFolsVBXbr1XSs7FyaHC4IZFFOdn/6DCtr/4lUr1CsmqVkmNurQgcbxMPAkdZjFKwAtQMOCvMwCHeuZ8/zfdD+ARha1dAseJG2AsO3u8VF6RwBjXfpHnTTyw6QjflgVOPMvvOWsyI/jTan2fBR2o0dZXF6TOhqjSONy225DAymCrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON virtual address space operation set(vaddr) does not support
hugetlb pages in apply_probes.  Extend it for hugetlb pages.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 7c548ec0cf6b5..45239f05e113b 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -598,6 +598,34 @@ static int damon_va_probe_pmd_entry(pmd_t *pmd, unsigned long addr,
 	return 0;
 }
 
+#ifdef CONFIG_HUGETLB_PAGE
+static int damon_va_probe_hugetlb_entry(pte_t *pte, unsigned long hmask,
+		unsigned long addr, unsigned long end, struct mm_walk *walk)
+{
+	struct damon_va_probe_walk_private *priv = walk->private;
+	struct hstate *h = hstate_vma(walk->vma);
+	struct folio *folio;
+	spinlock_t *ptl;
+	pte_t entry;
+
+	ptl = huge_pte_lock(h, walk->mm, pte);
+	entry = huge_ptep_get(walk->mm, addr, pte);
+	if (!pte_present(entry))
+		goto out;
+
+	folio = pfn_folio(pte_pfn(entry));
+	folio_get(folio);
+	damon_va_probe_folio(priv->ctx, priv->r, folio);
+	folio_put(folio);
+
+out:
+	spin_unlock(ptl);
+	return 0;
+}
+#else
+#define damon_va_probe_hugetlb_entry NULL
+#endif /* CONFIG_HUGETLB_PAGE */
+
 static void __damon_va_apply_probes(struct damon_ctx *ctx,
 		struct mm_struct *mm,  struct damon_region *r)
 {
@@ -607,7 +635,7 @@ static void __damon_va_apply_probes(struct damon_ctx *ctx,
 	};
 	struct mm_walk_ops damon_probe_walk_ops = {
 		.pmd_entry = damon_va_probe_pmd_entry,
-		.hugetlb_entry = NULL,
+		.hugetlb_entry = damon_va_probe_hugetlb_entry,
 	};
 	unsigned long addr = r->sampling_addr;
 
-- 
2.47.3

