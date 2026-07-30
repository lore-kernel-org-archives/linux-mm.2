Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71252C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:46:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DCDE6B00AC; Thu, 30 Jul 2026 05:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33FC26B00AD; Thu, 30 Jul 2026 05:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B8F46B00AE; Thu, 30 Jul 2026 05:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E1E926B00AC
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:46:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5771EC085A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:43 +0000 (UTC)
X-FDA: 85044963486.06.65A19FE
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 810ED80010
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:46:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iritiyb1;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785404801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0br+5DD9mDF0ZgI47lj49Bq9owmCTHLez1KgR4+1NE=;
	b=ZgEfbg+BhhrkyDf6WPTx1WZmdM0wJ2o3YsqCKBnlCOoVIOpcoAUQleqmEW2saAm0mKW8VK
	xlNwumd/MzcXRqn3ClPzmPT7tE+U+xv49TEbJQFT6Bn8p3d/sYaiiVsuN9GQrMIZ6CXkt3
	Yo5p8Vx+qDD1y2vw0dWuPCUCCyx7rIk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785404801;
	b=keQl+hdFBi0k8r/HVrCpaA9YqhoAiLYPXZ63BbuyXeKQnPQzsA8m24kIN/ZkgsF19o4k0R
	kj16JkYT3MUnZAbACU0iKKcW0quaZaoVWDxE+IONaxEkv1CC7AqW33MCvSafEdLuU+hWET
	fnikFtaDMcWL7a/MliLeRCpPXzQEpIw=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iritiyb1;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFAAC204C;
	Thu, 30 Jul 2026 02:46:36 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 926333F763;
	Thu, 30 Jul 2026 02:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785404800; bh=fUPL8NwsfMTNY3AcQ9Ge4EO4BNuY6qAMDvEtjOVXobY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iritiyb1yPp7hLOz8GBNuWaXYD47CW6hpLWL/ruvg7Wv/jjHIehz8vEchwFwabStV
	 dlrldL4wyGkAWajGz5HRyNc6R6MYnFv39Ac0Dc3loRSbHfm0bk9QFWU1r8pIBesP+y
	 9pXr5YV9lYkY1maI09EbO/jt3pqHHA1iyibH8IK8=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 5/5] mm/rmap: add anon folio unmap dispatcher
Date: Thu, 30 Jul 2026 09:45:56 +0000
Message-ID: <20260730094559.418003-6-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260730094559.418003-1-dev.jain@arm.com>
References: <20260730094559.418003-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 810ED80010
X-Stat-Signature: kyrkj3eaox78ywor936timtbhsr8t8ge
X-Rspam-User: 
X-HE-Tag: 1785404801-303050
X-HE-Meta: U2FsdGVkX1+G9RAidIp0apK4FZnpK8lNxUhJdeuPVn+zyQET3c+0nQox1b4JGYnnWr9lnqq9/IXNUfm2UD+MiaqVJaggKJCAg7ew1EOqwqDgojnPlKoeqoYF/HYW5yk+aBCBBIYAp0eKlelJDKiw/GrTGC+LvdYXxB1cJcYICZhe8uQ4BWoEHIlvyUaOnMmFoQZDZts3xxXW89mNTXAlVBTd78Bh1jolTCeEm7KsmxQE/1dhgkvxWe48clTXpCOsjTrovTB4IPyZfAcoXrue1LdJ8qqaSrCr8P0mRIHxQEtzskHWCc4RPpiX02Zs+AaQpHQL+wxLG1KzYFSHdV2Olzc++WdNH+DhIRK3H4nhHOS3huqvlPEvCaiEpx5zZrwtihmROaFe42KtYUkfBScIhppxbOsE63mQnWfQd28/KI7NnLLyo3Wc2+KUkPQOy7ca4CU2309MbPVftmWQKv8WJxltoc0mweXXO4DGwuu90DwEDwCfExSN65s7hLYnf0mGn3jyZXm3y1gRLuU4mg2NCFwKLVRIkCFCA+dM8hNmwSDeJ22T2PZuKMDIYwDvcdeBGHwuqMBlxQFpFQwGghGhRJRh8YCL6tUkFqcej2ynyYevQJimsZeqc+EO2KiXcuL+7oOs70IPcWv5qo++297D9eTGMjrwxum78GGiguhYFmIb3vUa+WxfdYW58fnrd0HK+iK4df+xyQXOCeOTRBKaDG+USWNf1Xiugr5BSeVLn19VpqsCBPkaetLx/3a7pV5fx7NBcv0uypnonzjo2xA+t7hosF3KZ01bf1eRBgTEBEmwJkRnTpKHMv7jrED4+JmGdoXglufvINpn9kGyTCmuffbpGnhz3xJzywlPYz988dn4Tq4sYHasASHakUtLVycyquRRxDEOTEmQ8TtNE3rmQYgqrfNeidUZBkFRFch3nK42qNX9vvtDxfeavN7MVXQhmTVSyIZ9tyR2y6e8bdd
 nLk8wIX8
 khxPmOSAqkrL7W8x43nYnyxO1ZGreynWyocLOJKar10y9KiJIIm59pl7hqpG2GqNCwo69aW/J13APR6Xg2j7QYcbPAFUQURxIkgU4kEa/SK/2IvYdXJhuHRt536msmAAyrL0dZJyKI0GDH/kF2XtGAiAxR0vHYZSjkOkjKohlMePi8CTMwT+dsb7KQ7oGuhx5DRyVpmWLJe1XCTuNW8QyutJFeKzCBfxvTUADefnNShMufuYm36c30VoFJ+U+MOWWsowCrl4+HW2NFAI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add ttu_anon_folio() as the common entry point for anonymous folio
unmapping. It dispatches to the lazyfree or swapbacked helper as
appropriate.

Keep restoration of cleared PTEs in the caller, where the PTEs were
removed.

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/rmap.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 15efde4d1fc9..867db2b61573 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2172,6 +2172,26 @@ static bool ttu_anon_swapbacked_folio(struct vm_area_struct *vma,
 	return true;
 }
 
+static bool ttu_anon_folio(struct vm_area_struct *vma, struct folio *folio,
+		struct page *page, unsigned long address, pte_t *ptep,
+		pte_t pteval, unsigned long nr_pages)
+{
+	/*
+	 * Store the swap location in the pte.
+	 * See handle_pte_fault() ...
+	 */
+	if (WARN_ON_ONCE(folio_test_swapbacked(folio) !=
+			 folio_test_swapcache(folio)))
+		return false;
+
+	if (!folio_test_swapbacked(folio))
+		return ttu_anon_lazyfree_folio(vma, folio, nr_pages);
+
+	/* nr_pages > 1 not supported yet */
+	return ttu_anon_swapbacked_folio(vma, folio, page, address, ptep,
+					 pteval);
+}
+
 /*
  * @arg: enum ttu_flags will be passed to this argument
  */
@@ -2349,31 +2369,12 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 			 */
 			dec_mm_counter(mm, mm_counter(folio));
 		} else if (folio_test_anon(folio)) {
-			/*
-			 * Store the swap location in the pte.
-			 * See handle_pte_fault() ...
-			 */
-			if (unlikely(folio_test_swapbacked(folio) !=
-					folio_test_swapcache(folio))) {
-				WARN_ON_ONCE(1);
+			if (!ttu_anon_folio(vma, folio, page, address,
+					    pvmw.pte, pteval, nr_pages)) {
+				set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
 				goto walk_abort;
 			}
 
-			/* MADV_FREE page check */
-			if (!folio_test_swapbacked(folio)) {
-				if (!ttu_anon_lazyfree_folio(vma, folio,
-							     nr_pages)) {
-					set_ptes(mm, address, pvmw.pte, pteval, nr_pages);
-					goto walk_abort;
-				}
-				goto finish_unmap;
-			}
-
-			if (!ttu_anon_swapbacked_folio(vma, folio, page, address,
-						pvmw.pte, pteval)) {
-				set_pte_at(mm, address, pvmw.pte, pteval);
-				goto walk_abort;
-			}
 			goto finish_unmap;
 		} else {
 			/*
-- 
2.43.0


