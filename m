Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBD80C4450B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 03:10:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 692666B0092; Tue, 14 Jul 2026 23:10:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 669DA6B0096; Tue, 14 Jul 2026 23:10:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A6946B0098; Tue, 14 Jul 2026 23:10:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21B806B0092
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 23:10:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9B673140505
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:15 +0000 (UTC)
X-FDA: 84989532390.02.797EAB8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 06E10100008
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 03:10:13 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AzNtQ1lY;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784085014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dZ7Hztpv9AG3ym6rD1iyRftJCr5BqjDTKMYF5vaHn/Y=;
	b=WIbsBSkhvbJT0e2bfZocGlQMyLGZUPQGNF0vK7wbu46iXx6R0s2JQeCNCZZysUfJODHiMc
	yVLJd+9c0NRWrF9hkl+1vOVsE4qP1U3Qsn5dFtNiCUVS5PAj23/fgwRZnLDTzK27kneRnD
	v7vYf448FElWvYYqYuoUM+nxTqBa2O8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AzNtQ1lY;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784085014;
	b=lmYyHcMOklUjnVotUXwgZPBJTkNEDBZhtIRuKObClLmPDD1PHBAdoW0CAg97aX03LV9pZM
	uYweC7lxz+VOD/pSUSRsrAn8iP0ptk/wRKb51uTvM/rbSAFh05PAL92z3upweQ9PD8UNQ1
	75DNPJfDziH+qUpv+4akFmL/SOxVMbw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 932DA600FF;
	Wed, 15 Jul 2026 03:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00CF41F00A3F;
	Wed, 15 Jul 2026 03:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784085013;
	bh=dZ7Hztpv9AG3ym6rD1iyRftJCr5BqjDTKMYF5vaHn/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzNtQ1lY5/HLdHtijvU/aYjoir0gb4du3YuUZmu74pb5RWlPnYQaQwxROd31rSGYP
	 sKz05Te5tg5zmZmeBsDsRzkliw2OYnSGNFOGmQHaSkyJSo1Q6yssfTEJT5CLlxMKjb
	 KXVKVu9aD7hJAxOKJljpgcYMASoDuLCF4WgZM1cr4U3HYGzPSoNKlHwCkU6Lnsdhwb
	 +gwJkxoxIAgr3LLj7omr2wJZlDjfcpGVuu7WtUQPilZh8GL2PqtR+b1++7D5Jpg48+
	 7L7hxUBEUwEK43oiuoBTnmsmZdoObt2tDS6gFbxycoj+L6S24iDtqvcyq6DmoaRZee
	 suTccnmomWBDQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1.1 3/6] mm/damon/vaddr: drop last same folio access check optimization
Date: Tue, 14 Jul 2026 20:09:58 -0700
Message-ID: <20260715031002.108504-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260715031002.108504-1-sj@kernel.org>
References: <20260715031002.108504-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 06E10100008
X-Stat-Signature: m8o1ienbwwfzy5tf3z16sqe3npe9a4ue
X-HE-Tag: 1784085013-149108
X-HE-Meta: U2FsdGVkX1/sO91cOTEY3olpLEHJ86sIJCu7iHRrkxQKuetKSAE92Id0AMSeo60wa42+sc3x1r6kCIz2xFfq3MB/CfROoNgUcsBEroumre4sYNEMQ5MQgF5umgpNYuzgM6IbNLFhLuosWfL/0gx6H9fm5yRT42qepBN/S2DNtWvaOSbO5/w7UcAEzbrahAFm0R5OftGKlnauzxllH+x3ZhHasZsE+G+LQ9gzVrJ4/0u/DjlGAg1Mqks6QhrqaFTbhS79eOQphaKlNjUpNmXgKqc+lNBqB6UEUCbOkTdtZ08Vsjc2lYPofjJOWBXz1QicHkRKRSB/8vhk4SWA31OOn37tzUMn/gcv5DufLDk+m20rSOhVvl0E7tjpHRyu4Kl0RFLySsl3AndD1mhgRkVHlvu8qZt40I0CDv2KASs+kP3AyonJM08JqRtJRnvMNJOGRqZAPleM+10xiIqKvBalD47BoA49Trqz+0XfVjMA6Uiel1kSmhOP0Obn0Gs0EjdPm61krjcenJ1PsYhaSbh7xoaJYdJgRNzjgHZocHD8+A4/q9ymUfk2nWm0PrytwjaNhewfKKIaXYITbZrt0v4NYxaaWHCsQcSkr0wPhKgpKS0u7w4ZXbAFSWkWhEmfa9KAQw3BYThh6CQQBIOs9rIELs5L507togrcoQ8Ls2W8Pq6OglAU0eoRQIw/vCLogs5yymVIk+FeD+i5pX6pazFsqWd9ZRJllB5TWaylLC1Xt7zosHOMLo/hZgtj9l+gMtUraUh6DPIG0SqiUWPMr/VZGytU3XAgORA1CKb4DomsQTkSukEN9e8mTqgQuNf7XOVd7S1cEDkSY1lT/nqInpZd9aa/mroILVZSSnh2d10o+pkfV82eg4lAyAg6vN0eJ3IAsALq1kblK9FuubnkJs067KIt9WMbc/OougDd9xYh/qgawF8GNs0cOEx9X4yRwXO3PE+CAOjTrpyZR9X8XO4
 8HiRc1rA
 5TaYDatB16er/Hh1LANzW4PeDl6Kf8jgfK5IlHhCd0A8/+Nj73xdFoMoonRPsu7sDjEfBxAW0wxtCw0CHDHKe0jts+YNzl6XGIJiXoZpZOsoHhoTVJPhkLGIf/p7pgUeBsrvmdnfFeLxkPqElhLKsvS+SOlxQmYGiX1SMfDIKZu1V82LNMOh4TrE7FFASOmiibOXVPPlJ9KWPMiiNvC5hx+acsuKMhDWZW8QGpXZvnRaQLroJEmGlgu+NRRinK4WlaIQFpt5Gz9IojB2YIBGqpdaScuAsM5JwUtk4AROnBjShql7Jue9AeJY1z1utlegFapeK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The optimization can race when multiple kdamonds are running.
Meanwhile, the impact of the optimization is quite doubtful.  Just
remove it.

The user impact of the issue should be quite trivial.  After all, the
race can happen only when the user intentionally setup DAMON in the way.
Even if it happens, it would be rare and only degrade the best-effort
monitoring results.  No critical consequences like kernel panic or
memory corruption happen.

The race possibility was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260621204050.10993-1-sj@kernel.org

Fixes: 3f49584b262c ("mm/damon: implement primitives for the virtual memory address spaces")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 33 ++++++---------------------------
 1 file changed, 6 insertions(+), 27 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d10b8042adb5b..d487b7a4a1042 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -383,8 +383,6 @@ static void damon_va_prepare_access_checks(struct damon_ctx *ctx)
 }
 
 struct damon_young_walk_private {
-	/* size of the folio for the access checked virtual memory address */
-	unsigned long *folio_sz;
 	bool young;
 };
 
@@ -411,7 +409,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 					mmu_notifier_test_young(walk->mm,
 						addr))
 			priv->young = true;
-		*priv->folio_sz = HPAGE_PMD_SIZE;
 huge_out:
 		spin_unlock(ptl);
 		return 0;
@@ -430,7 +427,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 	if (pte_young(ptent) || !folio_test_idle(folio) ||
 			mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = folio_size(folio);
 out:
 	pte_unmap_unlock(pte, ptl);
 	return 0;
@@ -458,7 +454,6 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 	if (pte_young(entry) || !folio_test_idle(folio) ||
 	    mmu_notifier_test_young(walk->mm, addr))
 		priv->young = true;
-	*priv->folio_sz = huge_page_size(h);
 
 	folio_put(folio);
 
@@ -470,11 +465,9 @@ static int damon_young_hugetlb_entry(pte_t *pte, unsigned long hmask,
 #define damon_young_hugetlb_entry NULL
 #endif /* CONFIG_HUGETLB_PAGE */
 
-static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
-		unsigned long *folio_sz)
+static bool damon_va_young(struct mm_struct *mm, unsigned long addr)
 {
 	struct damon_young_walk_private arg = {
-		.folio_sz = folio_sz,
 		.young = false,
 	};
 
@@ -494,28 +487,17 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
  * r	the region to be checked
  */
 static void __damon_va_check_access(struct mm_struct *mm,
-				struct damon_region *r, bool same_target)
+				struct damon_region *r)
 {
-	static unsigned long last_addr;
-	static unsigned long last_folio_sz = PAGE_SIZE;
-	static bool last_accessed;
+	bool accessed;
 
 	if (!mm) {
 		damon_update_region_access_rate(r, false);
 		return;
 	}
 
-	/* If the region is in the last checked page, reuse the result */
-	if (same_target && (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz))) {
-		damon_update_region_access_rate(r, last_accessed);
-		return;
-	}
-
-	last_accessed = damon_va_young(mm, r->sampling_addr, &last_folio_sz);
-	damon_update_region_access_rate(r, last_accessed);
-
-	last_addr = r->sampling_addr;
+	accessed = damon_va_young(mm, r->sampling_addr);
+	damon_update_region_access_rate(r, accessed);
 }
 
 static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
@@ -524,15 +506,12 @@ static unsigned int damon_va_check_accesses(struct damon_ctx *ctx)
 	struct mm_struct *mm;
 	struct damon_region *r;
 	unsigned int max_nr_accesses = 0;
-	bool same_target;
 
 	damon_for_each_target(t, ctx) {
 		mm = damon_get_mm(t);
-		same_target = false;
 		damon_for_each_region(r, t) {
-			__damon_va_check_access(mm, r, same_target);
+			__damon_va_check_access(mm, r);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
-			same_target = true;
 		}
 		if (mm)
 			mmput(mm);
-- 
2.47.3

