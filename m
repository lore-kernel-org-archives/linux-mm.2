Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40A22C43458
	for <linux-mm@archiver.kernel.org>; Sat, 11 Jul 2026 18:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B6C6B008C; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 905076B0092; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77FAB6B0093; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D9FA6B0092
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 14:04:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A84911207AD
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:23 +0000 (UTC)
X-FDA: 84977270406.25.E390524
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id D71BA80007
	for <linux-mm@kvack.org>; Sat, 11 Jul 2026 18:04:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=op3h4Blz;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783793062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5xW2GMWQ2fJulemhF10bJTV6JcOyhTF3brjsm/0yqc=;
	b=TRTvrarkKo77x2fDDHcMDzjSzFy6qQi989ThmGOPmAFZrTHastc8JkEii5LmiJuk6SQlYA
	bPNg7wC7AiuT/YxOnJs+ddq1LpZ0c3MKSTKwLXOCOOhO+bgyFNMsYQI9uDDbkv5i7VisqM
	cZZOsSnWcxsrif7Nl03C7ML1UqgZ3Vs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=op3h4Blz;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783793062;
	b=w3CqeG2i6pdArVAaFk9QZzFwVToVbXIXPbXqNEW4Pq3QBBOisWPLAhKDbRBKgrJsT1/42k
	0+FWFLo+MPdW/33q5fKDi7Mo0lJQzELOmb8Pvg4r/IKZ7bBpTmowJxeN7vMD97+9FlhxvY
	k76OCaAFVP4g3oxDN04S+iL9a5TafFw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3642A4373D;
	Sat, 11 Jul 2026 18:04:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5FC1F00A3E;
	Sat, 11 Jul 2026 18:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783793061;
	bh=Y5xW2GMWQ2fJulemhF10bJTV6JcOyhTF3brjsm/0yqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=op3h4BlzzWxIRL9mMkFVjIL13nQaru6+YNQBVr6INCZjs+9GzxN/GXZHy5xhq8qb4
	 KmOGyQomZpWjvKKZICQR4wvSxurZaj9z4vJIF3lM7OSfHTEK+r1ReYAeCS9nkAvapC
	 +aDBbobBMNq3Ctp/B98N41tFowCT/zJng8zVEH3CALzvf0DY3BDxL+SXsw2TlmVaA9
	 jfalGPF8MN0H5XO2B96UqZlTg+yvraVNioWHxDFHXApcS3c7f4ciur+GF2U+dGFPr+
	 ogxUThR+9T77WwaMkv3t7gkUSyOTDqQYGfUqhQ1f//1YcnzMREHk3PWV80X0RuWOQT
	 ohQ7Aarudbv3g==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Fernand Sieber <sieberf@amazon.com>,
	Leonard Foerster <foersleo@amazon.de>,
	SeongJae Park <sjpark@amazon.de>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 3/5] mm/damon/vaddr: drop last same folio access check optimization
Date: Sat, 11 Jul 2026 11:04:06 -0700
Message-ID: <20260711180409.82093-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260711180409.82093-1-sj@kernel.org>
References: <20260711180409.82093-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q4son7cbd8arp6fofis3uo6mmz1u7umi
X-Rspamd-Queue-Id: D71BA80007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783793061-775281
X-HE-Meta: U2FsdGVkX18rESy0D29xPHLDW0zRqArKg5y1YENCR70eZxlTn9y4ju69fdRn+XXT5QpnXvIaciZP1H96o2fM5sFOhDxuKrbaiEkef/e9zoAQzdyGq9J+yuE9zXKhHMZiUUA/zu863sJD3DvE49H+24gw6LdUN/t+SaAPuqq2/W90XMDKnEAm65RsPu+DIF1DhiVunLRTMO3sP+1JJH0Jlr6soAM8djsy8VFQyM6Eg5IlwjaEbUzBYk4lSHrtWU12ZR5FfTGYEPDO5jQ7O0xL6nwM8Na+uijurft5Xx9rjHnSKGN1sCnlOfE3I4kLTHlaM3A0zIptFi3wXgY693UIifv5CyzWM5TZWJIHKPQj4LYuI8YUMg3E9pm+b8CjLEQEyPK9tycDwqp+KgL7Qmmg51CGjWBmfywFegqjpg6tci+cCWfOrnAGExjB8wzWYBU1QREJVYcQYHLwWS7FL9DzNdBuIFV+fnLimQm7a9WP68zQZWFXOjptgn3IQ/sbdT8ebFpCXJBpcx3LvNbNFITXtxY2WJ1X7gY4msAoBKovQdcmV1/hCNgFSqcXB2ufuP7q1hJ5hmhu8hvIp/gtnFX8rfisxltyGwvZUv7XpkAuuaTUS01KmcwpVv91Er9oD131i06Y0iMbR2LXJUlg3Z3Yg6I0LhirFBg8X64NDDC9k2DTdYHAxcotFccGIdzoL0tpA3E3mumzQ+Us0sQUWwEta/1nig6ELr8om0E89u+pfstkpZ8oDp8qYvdYU8tK7WU96R1r6J7xe8DGEwBvu59Lhl4lY4wRMieb+Vj/J6GTwpum90I/L7AmpxRLHKJGR1P7A9JjhYgqgvp6Mv0kLeQqZVFngR5JTVZm87mAg78+UWMUiCyMpP3z1NzKgWeBHRGS8G5kZCxcMd/jsyMavnTFS+5plTclN4DmgKPT1Am7OCKvKyx7uqDH2tZVPHY5BLWDUblgOFiMSB1KF0rlVME
 fkLeR3zA
 7K8XWVM4t5Fyt1VFeJaBYN2tvdrrYjys8DoNw4IGJpauFu/ywnCIJ/fyALH9/Uf1jm5WU01W8xBnH0HlewOmCO4s34mCFqPlT9229eq+ifY7KGpqqWxBXSbTPJK+hRSEuNt9GsHVGhHJScJgLVV2JfogkybPkXCe0fYBSKzTHl4fHw+OXNfP91ByDWTavYiVHLf0/v8pkc6CTCG5VRZP0G7AF+a/YWQbuM72BLgERSuqyCZ4=
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
 mm/damon/vaddr.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index d10b8042adb5b..16fe210d2042a 100644
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
 
@@ -496,26 +489,15 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
 static void __damon_va_check_access(struct mm_struct *mm,
 				struct damon_region *r, bool same_target)
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
-- 
2.47.3

