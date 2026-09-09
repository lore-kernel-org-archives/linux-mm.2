Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C2ABC79FBB
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D07606B00A4; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7D26B00A6; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B80286B00A9; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 86F9F6B00A4
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:04:20 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2B6ECA0248
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:20 +0000 (UTC)
X-FDA: 85194393480.28.6001365
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 83FF81A000F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:04:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpeBgT0T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788962658;
	b=IBFUDTkFTw+1GkU22NMan5t1p5hXIMDukxpCf+Nz1ZGhsYHOuHsxCYJFxDTI27zehhqv1d
	lZ7/qkg1IarbCXnZEoZlHx6sdiw5FapLv4Z4cw2sbPeNFOG6Lv7Q0wsM5G2p/t+P8qbuDB
	nmvzLrxAWJdvNYWG5oGQaghFVV/936Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YpeBgT0T;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788962658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvOnZdXRT1oYcTh0OqGiqvrYhRphtRi0kIGud2JHRJM=;
	b=WEYta4RvTY2R0GlFw3aEp2yPI4mwJ3ID47k0Za9KLPZhL5+NjOA/8xrD7OFqUYhpkNoxBc
	FdHfHiNZ6ZkDg1AOihhkZRDctiw8wB/0Q07BaIhXfNCBYl9t1O2t0CtgJ6wnnp9DiHepXi
	llCyxXxbz+isVxGqOwrpAdsz4qJcu9I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDD6860230;
	Wed,  9 Sep 2026 14:04:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A6441F00AC4;
	Wed,  9 Sep 2026 14:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962657;
	bh=XvOnZdXRT1oYcTh0OqGiqvrYhRphtRi0kIGud2JHRJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YpeBgT0TICnF9MYO0bH+bAV4LO6GtLbLvnZxUU498U1z4TDRjxPYX9wrjCOoKBK5w
	 9BUwtDs6dvIvZmcX/YVZsqzwTYUSkZfs9xIdWyodB8lh8uSypybKybSotJVPFBc8JW
	 FcN1vV1M6Gmy2wT/pr/xXUUN9hDuRYtuKSofh+M5BxYKboIU+vn1G9Fsia9p0pYFiG
	 hhv0ZaukGfgqavbwglUUouF/XvDlZPgwHubXyQTlGQy3TKJOB9I7srQDivvOljYx4T
	 tHYh0CgN1Y+NIrYjKleZUa3ZHTFXWTiMXwVxXrM2edkwU4uJyEfKeso+SGNAJyGx95
	 x2FLIyVii9osQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH REPOST 5/5] mm/damon/vaddr: support pgidle_unset probe filter type
Date: Wed,  9 Sep 2026 07:04:07 -0700
Message-ID: <20260909140408.104699-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260909140408.104699-1-sj@kernel.org>
References: <20260909140408.104699-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 83FF81A000F
X-Stat-Signature: f6aqrpc3z39qktidf3w9eoombujm6q15
X-HE-Tag: 1788962658-657539
X-HE-Meta: U2FsdGVkX19yrnsdphYw9R4ewqtsZftZfRlDKN6I31FjvyMWp2zpphi6Re7SFQwg+4YA+BNqwSSdfgjOYTTgW1e5g6UujWkdJOF1u5PgxFvQrdg5oGcQ3HKW6fNXoIABbhtBxQs+UVZvXfJSc37M5r4N3wLtc8ikt3fzBgR+FO2LlfwsNbYKHd9+tFla1XGW5OP4av43NWhBMPG3acMLGwjXRWc8kDrFPdtJcKAo7dLcGqGpRtBh4iiRTpAGOr++NCUPhnBdO7p+uiZU//zFnszur+qm+EwdjyOLq/AYwr8f0SH7PjQ6Do9nwi1etGFDrOQCqtvKkkdwfzYnEzCO5BHqexOvVSHMSwB+GzYgJXcTHSwMBtgAVkPKlrEPHw++guFZcfaL4vXYpn38UzMkApEQ3GMtPpPZtOnH0XraDxtc4SPpu7xmLzDkr8iCC1w8Xvd/sI2klN67l2a6hWmhKY326XNCop9MVuQhXN5NdZhF96sa7fVQBQH+5bHu3YSTRQ6W06sK4GvZQxnfS+3acAJjXIRwXMssoeU3wpXQI+9ZS2EKJCxdlDNnEJwVj4H5qsb3T/2h2WJasu4uBnG30U1Lve2o8yfPUlUv4zYF/iVgvTSjOvZS0J3bMFoVu48P/kMydgw5NtHE8mhOj0O6Nx5ui5cInr81kWbpFXWxruNIT6rErgEp0OE3oklITJybzryt+hw0ZfO0Za/Hp5fyICMkASS7TuHAwOv60tX2+SlNyK3b2mHGlyZvpft/tAL2YP0rn52kG+8pdZkhBbQd5UIrVTkhRMSLgWTOfMkSRTQzR7sLheVjb8rzQCcT9xso1cZipCdlKmOkqBPCzze6K1v2RUNS9kejuoIDUO4d5PU19Rvtj8ruN8HNA4PEm31cQed6Z7faaIgXABTiIlMEUq/0QWbCJHCSWYAdzuM3N+WpCMUz3c6Ls0chdEPWo6eYbmrA6lRpG0HxNC77MVR
 6ZKMIOiD
 Xeli/p8TXZSkfIS3En5Id6eggCy3sZ+bQH7+rVY+BMoqsHsehWdZ+pJzLTUaitMh+Z+57x8VxR02BRmPon2ciec1AHq2KdH/Y5ovcqsCo0T0ISjJqyDhrCWQTpnN/t2I30pjGHtWlKvG7qAoatkxdwAbEkYF7hK5zFdd39axIpIQJj1PwXqB4oy8XRcJeYafFAynV7RGuE4GWLUW/BBoD1yaMglARtMh8sVvTnVW8XXtmlq/bzyP3V+JEYBo07yNipicrDwgeXbAUwrbSrgyULIgqqA==
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

