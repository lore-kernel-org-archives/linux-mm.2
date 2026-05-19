Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 521D9CD5BAB
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 13:33:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991876B008C; Tue, 19 May 2026 09:33:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 942506B0092; Tue, 19 May 2026 09:33:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858316B0093; Tue, 19 May 2026 09:33:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 747116B008C
	for <linux-mm@kvack.org>; Tue, 19 May 2026 09:33:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A8C91C1040
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:33:46 +0000 (UTC)
X-FDA: 84784262052.22.1E63850
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9AD50C001A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 13:33:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eau0cman;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779197624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8tDEDF47lmmor5B3dnH0s0HGKympEpVrQWKFC3NXQyA=;
	b=CzWU894bS9JgSYxga9UHbMrVQoC7MC7x5zgP05D8VPBvukMNO0bd6BNyBygcxisSAATvLH
	LT7HcayAa4sbgmqG1tNVHed+4pJbjlIpTakw6b4fR4IlpbGrSqYsQF6Xul5v90vcNP4ZA8
	7F7f7wyxPDh+9N+feZqk9z3igSyEvVQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Eau0cman;
	spf=pass (imf22.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779197624; a=rsa-sha256;
	cv=none;
	b=53UqwgLuU6a033Tx/zKvRLxwwJxTsWFjeGMfATBRf97CIUqlbsmMoMAcAKkGXdH5dk7ajm
	flJv/6STM0UN7EJdOFsw5eNLlmgr2neVeVzNQ6z2X6ekOFqwngCxsNgooprDDV2CwBT99W
	sLX+u9K6yAf+BNzBtsTvrbBk2gy5QHM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0ECC060129;
	Tue, 19 May 2026 13:33:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D31C2BCB3;
	Tue, 19 May 2026 13:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779197623;
	bh=JxQkTyZSRlzMs7ib8qBrrp+DMXE6y2eWvhI1wckhkbU=;
	h=From:To:Cc:Subject:Date:From;
	b=Eau0cmanZKHslnj0CVI8LxPTFGCh1FTLiuC+Lkq1wU6hXTEkwm3YjuIn13sBtWjTU
	 5k+RRgEs8l1OjQqtmCeVW6GFmcWX6zZs2+HnvOx4PEGYX259ZNIPI0FTwxEj8onqAj
	 +RXegkCMlEwSyn7oFbe6erQM01UBm2ucDcfDEV3jv0+Vxs4jFFBF53fBL7TOC8Haam
	 jeIPjJESRmjSJcflE3K6FL5vNeZ8Q63KLJ5B03EYRgXAhHoVgZmKLwfxU5yEOWbOSK
	 l9aAnt+zDwBdIG8b3mNwWnGUe9gWji6Qz0n3KOlgA2spnUYYs7J6kFWFu1S2rRvO3p
	 /wc8VgON+0C5Q==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] kho: fix order calculation for kho_unpreserve_pages()
Date: Tue, 19 May 2026 15:33:30 +0200
Message-ID: <20260519133332.2498092-1-pratyush@kernel.org>
X-Mailer: git-send-email 2.54.0.563.g4f69b47b94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9AD50C001A
X-Stat-Signature: oiyt5pkftmc7gt4hsmj7fbb8xrdibs9x
X-HE-Tag: 1779197624-565170
X-HE-Meta: U2FsdGVkX1/lZ+yuCh4KcHcXZBXtKepbA5lGno6H1G1RByVljCS5KKP3KwNdHdot2riawWouttS1Q4Tm3Auzf3RuZevwI++rT+/OORZ76rK8X1398DJ0dlvIE25MiFzAQwFHqthmm2tr3zT4j1bvqKwFIJOP3W8ngxBPs4ZslcTuf+7x+HHduprj9r+GhwkUhw6D2WJk36dEte73cq+ReteFfHV2F+O6zj0cUDQ4X/uDAmCMzgxxi3V32G6GwmgpdkCbLAQ3uOneoK2Pxt/bzcgiU+JEzHCxofhNWh20R9oWHeuTZU/ddZo9Kbv2Mdbf44w63kzFrbrRquDm1QQ+k6jvw7ItPOzKxt2lIq5co5agfqUu846exTcowVMWdTv7Wlx1lnOLl1f2ty4SMPK4+8JG5hVwHXAY7N/cIe0s7aqE9nEItMbWNPJoQKS4+GgwEP60w7cHT9EO4KhVywNg3OcjyCxamxKQq7PQlEsSDNLBHwJec7TZs5jNarp4jqUplvSUFaZgtFze4hsZcmaatQOksDPyKVjfK3EYSdMnZXjL9id4q/2WvmO2Ka/t1pK22pEeodRLaSshQqup9uakVx+hqHeuM5kIRMRstpApyYPDnqTcnwu+RCVvmWZmLkDakYazIHXPVQvU9w/o2kSnnIx7rEBodzYFMJlkIeO8Vdo+Xtg5Fs9r0eU54YcmFAQCBJGWjxai9MsXZiyHwzUMt4xXQ52wXDhA1ZRgCJ1llUQ1Hrw8/ktuOlQf27Jo5dykNiqQsaWKCU9s2THmfXArOK5izVd0rtvRjPxr5PwVL2epu1ZYyynpaY4dJFK2GCQzuwIU0u2lgjhxTel2tpwjFk5e3AnwjIH0QzuPrronG+Qqk9siKT3y/3wtlGP65XZjyp9EQmtLM2DF1Lnr7eAVyTs3DaQJsD+uu2+eMHUqxIt8hVmVeB5LwmQU5M+F2tauz8kLeR1OtlKdkvORqFC
 4Py1GhWo
 PuuizQN9lJHt5FiYVeVSzdHRjHNy948LO0amdPmGLaUFiex9EY2ZpCQ/0oLhNhE1YnVZvCCJwIUekoJKSdfGuNVR0OQyp+UQZWYWvqAn9Ufq63eOlcl27cxvLbXYmgzZdRBgcbEcxTSF1tAswxoQauPPKuDQsK+69i0IBV8xNUh6mb6vZIVkj18UCmUu2wia8JqYpqBVq+1PeDQEFq2jHzh4yXqX+AY2syy2VMFwhRhuPFX0bckyVtAQg48WDAbDQ9M3KMzNCbpViKt9hvqsKghlF+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Pratyush Yadav (Google)" <pratyush@kernel.org>

Commit 91e74fa8b1bc ("kho: make sure preservations do not span multiple
NUMA nodes") made sure preservations from kho_preserve_pages() do not
span multiple NUMA nodes. If they do, the order is reduced and tried
again.

The same logic was not implemented for kho_unpreserve_pages(). This can
result in unpreserve calculating a different order than preserve, and
thus not actually unpreserving the pages.

Fix this by moving the order calculation logic to
__kho_preserve_pages_order() and use it from both preserve and
unpreserve paths.

Move __kho_unpreserve() down to avoid having a forward declaration. Its
users are further down in the file anyway. Also, it results in grouping
for all the page-level preservation and unpreservation functions. This
unfortunately makes the diff hard to read, but the main change in
__kho_unpreserve() is to call __kho_preserve_pages_order() instead of
open-coding the order calculation.

Fixes: 91e74fa8b1bc ("kho: make sure preservations do not span multiple NUMA nodes")
Cc: stable@vger.kernel.org
Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 56 +++++++++++++++++-------------
 1 file changed, 32 insertions(+), 24 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4fde8325c49f..11855e275397 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -357,20 +357,6 @@ int kho_radix_walk_tree(struct kho_radix_tree *tree,
 }
 EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
 
-static void __kho_unpreserve(struct kho_radix_tree *tree,
-			     unsigned long pfn, unsigned long end_pfn)
-{
-	unsigned int order;
-
-	while (pfn < end_pfn) {
-		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-
-		kho_radix_del_page(tree, pfn, order);
-
-		pfn += 1 << order;
-	}
-}
-
 /* For physically contiguous 0-order pages. */
 static void kho_init_pages(struct page *page, unsigned long nr_pages)
 {
@@ -855,6 +841,37 @@ void kho_unpreserve_folio(struct folio *folio)
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
 
+static unsigned int __kho_preserve_pages_order(unsigned long start_pfn,
+					       unsigned long end_pfn)
+{
+	unsigned int order = min(count_trailing_zeros(start_pfn),
+				 ilog2(end_pfn - start_pfn));
+
+	/*
+	 * Make sure all the pages in a single preservation are in the same NUMA
+	 * node. The restore machinery can not cope with a preservation spanning
+	 * multiple NUMA nodes.
+	 */
+	while (pfn_to_nid(start_pfn) != pfn_to_nid(start_pfn + (1UL << order) - 1))
+		order--;
+
+	return order;
+}
+
+static void __kho_unpreserve(struct kho_radix_tree *tree,
+			     unsigned long pfn, unsigned long end_pfn)
+{
+	unsigned int order;
+
+	while (pfn < end_pfn) {
+		order = __kho_preserve_pages_order(pfn, end_pfn);
+
+		kho_radix_del_page(tree, pfn, order);
+
+		pfn += 1 << order;
+	}
+}
+
 /**
  * kho_preserve_pages - preserve contiguous pages across kexec
  * @page: first page in the list.
@@ -880,16 +897,7 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
 	}
 
 	while (pfn < end_pfn) {
-		unsigned int order =
-			min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
-
-		/*
-		 * Make sure all the pages in a single preservation are in the
-		 * same NUMA node. The restore machinery can not cope with a
-		 * preservation spanning multiple NUMA nodes.
-		 */
-		while (pfn_to_nid(pfn) != pfn_to_nid(pfn + (1UL << order) - 1))
-			order--;
+		unsigned int order = __kho_preserve_pages_order(pfn, end_pfn);
 
 		err = kho_radix_add_page(tree, pfn, order);
 		if (err) {

base-commit: b1378127003b61930ce30064328640503ad3ef6d
-- 
2.54.0.563.g4f69b47b94-goog


