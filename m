Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA06C79F8B
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 20:27:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A53C6B00A6; Sat,  5 Sep 2026 16:26:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E08B6B00A9; Sat,  5 Sep 2026 16:26:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A76B6B00AB; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD3C96B00A9
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 16:26:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6DF021C1F57
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:47 +0000 (UTC)
X-FDA: 85180842054.08.0140551
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id C7BCA180004
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 20:26:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JK7RdAfx;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788640005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XvOnZdXRT1oYcTh0OqGiqvrYhRphtRi0kIGud2JHRJM=;
	b=6pnJ3H4YnUITbLR4Ci8kedCL7Y+nLCaelGpR8gGS1XUhx7pJ1H+Q2eCZ4UXTJrXyDnIRnK
	mKXDONXAKWnipq6c2GpW/pkvbCFDPxL/7p3PiUigXhoE807UVlpoL+Gttu/tE2odmYV76O
	xYP+fmCoIJ72yQHY1yDRrw6AHuDP3Hg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788640005;
	b=6fFsQ3IagWLbndvZ+y6cBdXrM9DHXzap9Uk4S7/LzNyuLCrZovbGNy64m3UO6E+pOvP/VG
	8pnai2YQRWg2zyDjWjHQYriTWQ5Jrvxrdr4z2DAGd2nljOB+WnDbzXJ/3N3I7pcGFKFdvx
	c7Hm73j2uXfN6nKKyGr97j7O0wT8Mww=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JK7RdAfx;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F565601DB;
	Sat,  5 Sep 2026 20:26:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43DF1F00ACA;
	Sat,  5 Sep 2026 20:26:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788640005;
	bh=XvOnZdXRT1oYcTh0OqGiqvrYhRphtRi0kIGud2JHRJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JK7RdAfxkHkGQH62f0Lo5rVGUMzihKR7KLtA2YyPKLdfNzvFXtlSBqYSF6DEvMdn2
	 TOB9OpSAO1mjtNOyy/m6bAMU64WhF42+OljZTh+xh88/G4KI08JS6HikzAECJVOMEM
	 W3YEWJzBZDk6DpEynrqv7E9T7+nTAOX+Tz8P9djTfs+pVZ5vL/Z9N4xUfQJCeBBxYu
	 0ME5Rx0NNxPr7J/7aPlDMdv4qaR66dnCIR64X1edAmYQxsDpIbz2dVjambKjvL9AJA
	 KqGCkYVpu8Pde9R3++I6BWmdLwR5NQhDdTh56eaWeAUbr5rbdfNmD1l0qHEz0bqyLY
	 olHr4BKts/aUg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/5] mm/damon/vaddr: support pgidle_unset probe filter type
Date: Sat,  5 Sep 2026 13:26:27 -0700
Message-ID: <20260905202634.88102-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260905202634.88102-1-sj@kernel.org>
References: <20260905202634.88102-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C7BCA180004
X-Stat-Signature: gyzb3k387t3xpgyfuhyrg9ctywu6t9fx
X-HE-Tag: 1788640005-779628
X-HE-Meta: U2FsdGVkX1/7STUiRiAAcLVH+uPXZpAVNeV6R23X6oq8wF+MNDSxmZEJHoANHMuZbidUjtdW7287+8J7Qu1pRuPNty9p3YvE+n2Rm2evcQadebATWgVJ2NX/LIUYGcZSf/kRkVTj+6OFYoIqpMLzvuGnw+D7XyjnPzQZcXyJebUj8Z6h6m+Iv5f69wnTxs44A+t7TUe4b6hi9tp8iLhHrFs/CxXh2wqah9ucwPfpXqpLgZQgOQyCrflrEQZ5SC0dyyLDNs0AJe53XhD41hPs1p4LFF/9OR0q0dr6AUaoOLvdBH8rEp1ykrXA/K3LAlfN1DJAP/ZXnbWilgJ2WRjpqfS1lyF5tErnUL9dTzPVPf9D0CtYb+WVXvHLNRTKAuhkKZGnglYE/24jfZxPCt17HSvwmBwvSkEc0D9gl8LpHJGwDgoC0/DC7TMRFDVfVvn/LwH5NhD6PO4u645aJVJQmEjrrQYDFfqtcTWJKYDb+DcO8VvD5Z3+eCAIbGx9qLnTtcKF69FmRprIRCbd+vtsK/CHxcfhj9/REqN3KF/LzIG6+VcObrfiXRxW7/8D4EeOu5mpkDztLBf49PHcEYWPOmiO3e0CdzURml7/41jRJ0PWJFNgrz1uht3JoIscrAnTAPEKd1nGCScwCI46F0H6DkwaluJ+vGy+IkliFXKETqocOnAPdJjPnTcXzzyA8u8hxyjqYhCYg51Q5BQ3LHG/iC9VbJVYvhSZ+xtQ3G8ry3R+HtBtaOOu7CjxkCNsw1um5VR/JzevZNzDxGjx9OvVH7tA8stID1h1To7ZWavZLSyqk7B/ENLkO6aEi1u5SwMrp0hxaUSJvkCAqpXlfbv9wL6By96QdB8V9ccV0jBErFDJByBEOmUi/xrjhcwTHAJO8kLt7yFnz/O5sytWQFE902KAWI1Jiy2jxsY9nwvEzk0/mC6jvHyYtqLvz4exZC0vyd8THCU/VXlXl634dUA
 Mp0j6LTy
 YTWIQHucnoaHe0C172Mbhwll9SvZ2uL0/H7C/ZHVTRe8ZWPMCKoBlS0hDs+VIQhR03hzWxJ/D7W/l6cESavvrMiXG2rdsz5Pf71saD998zLNliAbqvaMkSRafgHdJRLeUsriN4u5imwKVN8qVuR4Wfh3Q0miqK+Ia8UWK9aXd+rmYmM/fiC3e/ixc2KbsUWc/ROaXJE7z7VqqwJ2XWhpmz84fs3cT7GaR1fT4u7kBQBZ4eF3jBxXEu2Oqoo1wmikwpRA2lKwx+w28HbRUarmBQvJdAA==
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

