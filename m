Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9C3CC87FD2
	for <linux-mm@archiver.kernel.org>; Sat,  2 Aug 2025 11:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24DF46B008C; Sat,  2 Aug 2025 07:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200026B0092; Sat,  2 Aug 2025 07:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0527B6B0093; Sat,  2 Aug 2025 07:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD4B06B008C
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 07:53:08 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4194114B35
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 11:53:08 +0000 (UTC)
X-FDA: 83731656456.04.722AD76
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id B8669C0005
	for <linux-mm@kvack.org>; Sat,  2 Aug 2025 11:53:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QVWUe7QT;
	spf=pass (imf28.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754135586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+l1QuFgekZN0Ih/n7UkLBKW9hzcvuL72STInIzLZ4ZY=;
	b=f7AQpV0rU46U7T0vuZMCBrj4SHJla/vLqEXaOXZoA7GIxHkw/b71+ZJI6zjEvIeDnNz4st
	W4tEzCAmZqKkjriWYFZUgYp/w+gtb1TqaUTV3U0kLBaf7Ka1DzoM/zLyGG05aNubpe0TqN
	3tFgcoxm43fwgVfRUrx03wgsfNFCWEs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754135586; a=rsa-sha256;
	cv=none;
	b=1pVmZw5zRhH3/CdJh9URG3Qcb+hiJd+R6gVsU5WkEdcn6B+tH0EggzNtEha0C3XUqj6/tN
	8NqjAbA3DMR5DdxX6Ao0Xk3Lsv/1d/9zI9Esl6kF40VJbBbo+xn5z2pcrifT9XrxAQyvRu
	MN1ptf3pWf/Rv41eh5FHBrzHT2dsi0Q=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=QVWUe7QT;
	spf=pass (imf28.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-615622ed677so4263808a12.1
        for <linux-mm@kvack.org>; Sat, 02 Aug 2025 04:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754135585; x=1754740385; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+l1QuFgekZN0Ih/n7UkLBKW9hzcvuL72STInIzLZ4ZY=;
        b=QVWUe7QTFzI1LGJVbRRmMbkg08j6yRfcqBF+g1uEfCbsnM4fUrJNh6jceJ2fiOVkGo
         mlj0lUPTzqgP2jshzQ2Nkuq7P9S58a4/nKuFd/cgS0TCq+xfgWjObORob1czVKewL74k
         DeCRHwmsioAnmab5vh9zeJv/YXoNlhEu38e0116N7EysMrM0qKAvIYR6M1je4DGCyRUD
         ko3jLjT7bWTZMYk3yatGVmj/RKrRhtvOJks+G0P2iEcUtjUd0Tvn3VJzVBIkS2AhhKDm
         yLi9qo1KwZ1ld7QBmh9wYqOczHztKGH1l6HosRUMFEEbUTuVsZ012N6i4FH4nSturojd
         zr8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754135585; x=1754740385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+l1QuFgekZN0Ih/n7UkLBKW9hzcvuL72STInIzLZ4ZY=;
        b=JPSrKpdgx6GwbkgUnw/ClHlFCT2x9cqODdpNJyAiT2RUUckxHtTNilCGVEhpT2q/iY
         Z6MkNM0V4Kf5nr0Eejs5g2LUHwVO4ShEfs6QZzSf9d10jclg1FyshYaG2GsUdMWWvf1j
         zxIH+cBsb9gJz5lmlb6BquvtpPRNmaW1nX5Z3HUXun4hULahLLnrnG9UEsTNB4Y4gDqs
         uuvUrw2/oV5YEY/eE045CXSKRrhR8CxNbFL/Ra+aBOCq8zGEFcc8nKwNrXx3IZRHIyZ3
         PF2A5MJ2lyO+hNeN85Ovcjny+UaP8vX3SJLLRSFCV/Oxivjzb53+tnJG1bMT4W8k8k2I
         btKA==
X-Forwarded-Encrypted: i=1; AJvYcCX1rhIh7CM8JnZl8qykikXUJkNwZEq0EAEzR3bzRLIT1sNcRpfZnrzsy4NOVnOGCtGKdTFtWjIqfw==@kvack.org
X-Gm-Message-State: AOJu0YwHP2AFB7jiubKtZ3CcatWmagFTRjaZUB9B1B+1wirzJAPGsLGm
	UyCnnZamE3muTYXxcSLh8XzXhel1/6TyY/fgRb7ktpTkAYGmkJ6Xkboa
X-Gm-Gg: ASbGnctBvKXQKLTT9p+CxeziUxahjZge/rJz2YmOMMeYTwX1iuYaQi/SrJlrvi3OW9n
	S2HdFtjhsiB8MqtY9EjKEQGr/av/Q0nfTERVOjssCj9wqhYE430KiVGLfW8gnn3qsikiU1ZUbsO
	VhXyLW1fNcWPI+vi0PufyHJYzDLmXXGs5z0nx2KBlSNFlCxTQqtzrpQDtR8ShPC1GdfuxMRYNkA
	qXjtxC60XnYKudTSHZ/j7LWbjziAkK/8YaNEoVURGeug/m7UVNzHzWz8G5+SBHo0BZ2ZS38U/NT
	XsaHWRntb6FdYlvfEvJJoK952Fm/dvGjTBs5RR/MVzjjM2kb3E+VRtbvCJgIoq+ygsdmVdw6894
	XqyC+Axzh7DQuR8Nv2Fk3GkjdsMyawFnSXHFukytU4TNmVExT6UhTzlvofYXWDiygmE9eb+U=
X-Google-Smtp-Source: AGHT+IEp2fGxaGZZ5CaBRX0BcTcZyFdhDrJCsMO6vtGysJGYlHpKp+oG0jgs4nIVGThUtInH3wGG+Q==
X-Received: by 2002:a17:907:2d27:b0:ae0:a359:a95c with SMTP id a640c23a62f3a-af9401adbf6mr294558466b.34.1754135584954;
        Sat, 02 Aug 2025 04:53:04 -0700 (PDT)
Received: from rs3labsrv8.iccluster.epfl.ch (nat-icclus-192-26-29-9.epfl.ch. [192.26.29.9])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af91a0753f9sm425028166b.20.2025.08.02.04.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Aug 2025 04:53:04 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Yueyang Pan <pyyjason@gmail.com>
Subject: [PATCH v4 2/2] mm/damon/vaddr: support stat-purpose DAMOS filters
Date: Sat,  2 Aug 2025 11:52:46 +0000
Message-ID: <264a4b5ea202fd73c01b349c9694d8bf9978c441.1754135312.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1754135312.git.pyyjason@gmail.com>
References: <cover.1754135312.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B8669C0005
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: mgm8sdyjtxtms57jopejs17riw5msys5
X-HE-Tag: 1754135586-958940
X-HE-Meta: U2FsdGVkX183Ui2TTvAvPqLmrLgO7xO7kLjdy01dfNaQcpmPnhCTMVNGuPueEKm9jXAsEsxAqIbNdXTnT74akzsO8RMuycU+LNTiVZrGSRxNY/6sPFIabrv3vqJSr8heDJ7W3rIyN6LLdVsbl+1CxKZb+X0itGw/oouwJG7VyH7WnVyNb/GNYH+S39mjizuL5/mHlCiu5YB4ErCBJ2OJUFihomBzKIx2eKlOwh8uGP2GqRCUaXMQJcZcw2ArQDv2wbb/+ZjeIEIeIvzcxi6kxnn/CUsaQtDL/4Azv+DWwRE/038iN/nH+w3OvDKpb3mgWIaD/V3iMVFbdLuhhN2RkV703SVOkCfNmNfcegmxzOdYaTs/BJ3m/edEcjC6hMU2AXsp/f8lphY1DPYeAZ9ZFBe8bvoIsrxHE6mMw6ka8COhFQQUuTrSQ7vzbM+Q/iP17+tJrjiiQ1QtMwhwJywXc22rZcXXR6v4Sr+Mj1Il1dUusjKrb0kW0hgVC/PhegnBPp2Yd6UijAseEV3vDGKiG/fLNYvfKrXx2HXxCq3CONekoI9vfz4xxiFsrt874vvngnZBfxReq3RTL5RO8kk11xFCZJW/EvQucdV1Nlr+s6ZC3XyqQnOvOIX9f11Hafr8AgzNovjOZZRcS+Y4N2aUk4+UcLDDAsZkst/DY6wgx1VEoZPwL6OC+hBXHTaSWAfi2ahCX8aefOZ4DFNdRvZrc2z2kcufANmjjUbNp/OZrp6UxFdZZU8ebl1M+R3Ie5g59IjdjFdfyc8Ur/bNNSazts/dS+rsnYAt7WIEDiJa8CxmnT/AVgjUO3bi5K7e3Lgcwg4BH8PM3QbEM8UnhrlCAo5iwqu9obyPqrsiOYepAjIeZrnTWGho0LPlSbghtTRDC00lIiWuid3E7MAe4BSm3t0BdaVyhdrhcGU/xteMqEN3QJ3Gg5s5rSiuzEobWt5M+kRYz+TUigSn6hHx6KN
 iy1vz0LS
 U8P0Co6asnW+OOGL3lXGc9DzGCo3x3ZBwWx43Tsj4eKI1JEAW3MeQOhQVe28e6Bey2jDTaNv+SlXv3q3yZLeq14IKM3cbyEP2Psqhw17dJ4kIoE6jIZSiOwwzs9+6vd8v4cOvSxnNypG9/lNGOpdim4NGmPqxfhRbxq3o73aamOeeITV7TiB5yBl2MxQ3CQL5I6AMauEUr6stObOej1KNAekabSRyKi3BckyDR3lxCWuMySLHtbDbP7k4G4UMudaixKtlqpbwypQP0bHGmZ5Tbg1u0m2gPgtPGayBqh5ErVp5DLZwb1jvWuaUBadFDD5hkuy92LgTLigNVnWlqcgPnFXu/z9hWRfDHqMz9op0vj2Kyi7AIZb9ezjBl6UHvDjqrfMctpO2HUYw2NH1awA3kJKosBpqYo4u0vNUxudi8zjW1Yyr83viW9D/AfeuNb0ke/BS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch extends DAMOS_STAT handling of the DAMON operations
sets for virtual address spaces for ops-level DAMOS filters.
It leverages the walk_page_range to walk the page table and gets
the folio from page table. The last folio scanned is stored in
damos->last_applied to prevent double counting.

Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
---
 mm/damon/vaddr.c | 103 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 102 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 87e825349bdf..66ef9869eafe 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -890,6 +890,107 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	return applied * PAGE_SIZE;
 }
 
+struct damos_va_stat_private {
+	struct damos *scheme;
+	unsigned long *sz_filter_passed;
+};
+
+static inline bool damos_va_invalid_folio(struct folio *folio,
+		struct damos *s)
+{
+	return !folio || folio == s->last_applied;
+}
+
+static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
+		unsigned long next, struct mm_walk *walk)
+{
+	struct damos_va_stat_private *priv = walk->private;
+	struct damos *s = priv->scheme;
+	unsigned long *sz_filter_passed = priv->sz_filter_passed;
+	struct vm_area_struct *vma = walk->vma;
+	struct folio *folio;
+	spinlock_t *ptl;
+	pte_t *start_pte, *pte, ptent;
+	int nr;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (pmd_trans_huge(*pmd)) {
+		pmd_t pmde;
+
+		ptl = pmd_trans_huge_lock(pmd, vma);
+		if (!ptl)
+			return 0;
+		pmde = pmdp_get(pmd);
+		if (!pmd_present(pmde))
+			goto huge_unlock;
+
+		folio = vm_normal_folio_pmd(vma, addr, pmde);
+
+		if (damos_va_invalid_folio(folio, s))
+			goto huge_unlock;
+
+		if (!damos_va_filter_out(s, folio, vma, addr, NULL, pmd))
+			*sz_filter_passed += folio_size(folio);
+		s->last_applied = folio;
+
+huge_unlock:
+		spin_unlock(ptl);
+		return 0;
+	}
+#endif
+	start_pte = pte = pte_offset_map_lock(vma->vm_mm, pmd, addr, &ptl);
+	if (!start_pte)
+		return 0;
+
+	for (; addr < next; pte += nr, addr += nr * PAGE_SIZE) {
+		nr = 1;
+		ptent = ptep_get(pte);
+
+		if (pte_none(ptent) || !pte_present(ptent))
+			continue;
+
+		folio = vm_normal_folio(vma, addr, ptent);
+
+		if (damos_va_invalid_folio(folio, s))
+			continue;
+
+		if (!damos_va_filter_out(s, folio, vma, addr, pte, NULL))
+			*sz_filter_passed += folio_size(folio);
+		nr = folio_nr_pages(folio);
+		s->last_applied = folio;
+	}
+	pte_unmap_unlock(start_pte, ptl);
+	return 0;
+}
+
+static unsigned long damos_va_stat(struct damon_target *target,
+		struct damon_region *r, struct damos *s,
+		unsigned long *sz_filter_passed)
+{
+	struct damos_va_stat_private priv;
+	struct mm_struct *mm;
+	struct mm_walk_ops walk_ops = {
+		.pmd_entry = damos_va_stat_pmd_entry,
+		.walk_lock = PGWALK_RDLOCK,
+	};
+
+	priv.scheme = s;
+	priv.sz_filter_passed = sz_filter_passed;
+
+	if (!damos_ops_has_filter(s))
+		return 0;
+
+	mm = damon_get_mm(target);
+	if (!mm)
+		return 0;
+
+	mmap_read_lock(mm);
+	walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
+	mmap_read_unlock(mm);
+	mmput(mm);
+	return 0;
+}
+
 static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
@@ -916,7 +1017,7 @@ static unsigned long damon_va_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_MIGRATE_COLD:
 		return damos_va_migrate(t, r, scheme, sz_filter_passed);
 	case DAMOS_STAT:
-		return 0;
+		return damos_va_stat(t, r, scheme, sz_filter_passed);
 	default:
 		/*
 		 * DAMOS actions that are not yet supported by 'vaddr'.
-- 
2.43.0


