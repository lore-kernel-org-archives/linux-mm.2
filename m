Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16DF0606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 22:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hNbROSYs
Received: by kanga.kvack.org (Postfix)
	id 37D966B05B7; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 350216B05BF; Fri, 27 Nov 2026 17:27:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1058F6B05B7; Fri, 27 Nov 2026 17:27:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C7C4C6B05B8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 17:27:31 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4136B16050C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:31 +0000 (UTC)
X-FDA: 85482336702.29.98C26A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A28B240009
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 22:27:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNbROSYs;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795818449;
	b=hqX1vFU75hS8giaPtXYZ5oP7tralBkyhO1sSLajFPyliI8IYHvh7X6wJ77x8Gdi+X9+ZqO
	hW3DBrIy8fFXVn1KwsOvSaMdWrTceaPEb4vVT/WKivcIFka/LjCq2R6+QcJGaXN3kiTFsd
	Q+EgupzXQBCgOZkicu1MV/aCcUUj2TY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795818449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nq8Fa7b2wVh3jUy0Qj4Fty4yFd7PbnbaXmqxKuMGOfA=;
	b=OEM0ddqdOfPdOr/uSqyQth0agEzvjLy1xgTWA128V6arBGIXZf7d8tOMIJa+4E0ZtVeMKy
	TzECP+qlONryBzctsTzIZFZkNvsawhHHgchs5K1m5dxaH2vDC7EcB/2RyUcotZvWoKWIR9
	VGfXE9mGYRCdNKZlbiYgv4seciNsiks=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hNbROSYs;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 043294082A;
	Fri, 27 Nov 2026 22:27:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFBD31F00897;
	Fri, 27 Nov 2026 22:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795818447;
	bh=nq8Fa7b2wVh3jUy0Qj4Fty4yFd7PbnbaXmqxKuMGOfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hNbROSYsdvH1w/S4paE27JdqWidZw29VsLhvVbN0bNkNMn2p9CjgjICY3ypxnUQXF
	 q5LFMkADXQ9eJdUBoCRnHUpHnF8kyJJTVHzpzeOrG5nG1igNuy1S5oLX77GQugGMNa
	 zg1DHoJ8Yv0sfGuv3ZhVHIRSmDWdIdFMbtKGTrUHjv2DF0qiriXkBh0R8cTA37fnRo
	 SE7whVqoylW51cTCVTMOkIe/x/IKf8PbF0exa42uGVEhnZcTZhAwbVH85Z2WyrAxdg
	 A+748mN340/MKoLjyGWXj7ojVL5ni5pUSsXmRKYfntUmgCDfcaycYtaJu4N2rnDArq
	 M3UI388tq61aQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 2/7] mm/damon/vaddr: use damos->last_applied for migrate action
Date: Fri, 27 Nov 2026 14:27:13 -0800
Message-ID: <20261127222719.105510-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261127222719.105510-1-sj@kernel.org>
References: <20261127222719.105510-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A28B240009
X-Stat-Signature: g9hpiqsxdwnrru5jk5siqr7usb6ar1yc
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795818449-565309
X-HE-Meta: U2FsdGVkX1+W3BdgzDMOy9bLUFqdJb7zkgMszl3dcV5tzaKx04Gc9DGSdmpG9XxJ3VMb9wPK0aU4OdPE+quFi5HtuldGLOq+rofJ+Q2bE4EYlVHbjcVV4lGlW9apAg1GgfLtx//OBu5UsyDL0ugJKkdRqJFh/ovnkuUhqkcx5OmfIgEercVTBrWl0k4kN5bn8niJFBQ2MHO9aY++1ywEqQY/qdUT8aXzlPesmlXQUP7isIm0TD6m/lBnjbSeVp5KaiAa7kJdJxNSd0NhLTfTshmINvXdr7URmecB1riUxIxsv772FIG31n3bkVKpuvVeMkbQRMWgflZ3czxysGshLkWGi+PjSQvMJcMv1mt/6M8U3tBtOiClCxBP0UDPdJAAf20phS0wmalq4nQRxTpzGuXfsFiT+ebI3I0RZh1pOQy+HXsXSXoTAgmDHM/atc8IZ0mzBzW+oJkwdtzAbEcQ9GH2oxwtHr3PQYniyktAMN5fAOOO9qQjmLtBoeG+kAE3geg5nMLdcFWaofufZ0fpIxv3r7RtpvNNKClQSTKYH5ju2X+nFOD+Poqh2J9SN97vQ1oOjNqaKURWKB6q6B8MrUK4PUvEXI2g6z03by8Uaj5ZD5RG19TKyWbUUJ5IR2x3GHNSkWVHmlGDXj41308N3EUPvcHUWcQRcfheAOT5FoFkT0K/L5empIc6X8yYlvE2/xZeJTrC2R4nuPHM7v2P6g29HG1RNbVqLMOEVZqBPRbG0BcMBk3vhuhwSGoRJ+KQPl9nkTAEvExh/6zt/gfNXAIicQUWJyJ5max023L00HMrLR1jYvq0V3rq9nJ5Xqxeatngi7I2EH2bHY+L7IKvRHfE2oVf+rLZEdKzK+VeJBLk0JFRUIvYEH8auxA5zS0Gd6daQnhVLfwrQVIQH0+6G2N2fqgFnj3Aqzh9on/B0T0wg6Nccxo4g4AugvNtVv9fU+4E8aaISZyiQt6Lz2r
 6bg6VNvT
 UobFF4LHsdglN6g3AzcReXF5TYMIdlWzOhAYe6On18tFZy06PUXVtM+GrfDXUX5VxwekvomnpmxEqzvda8O7x8YbL81h3CiV6wDf+jPQNXWp44GJPhzlNUf1arurqG8rC1VenlyQZnlxV8SExIm8WoqRztTy4DwYMYQ0YwS+M0Uk2ef6Gol76K4bZYbV3m8jQzySZ2wyiawTias74lzPNwxYEfS1HVHd7oFRFbSOPJtOVRZ+dc1l8CX9uMegX1N0zERecs/6u9rS59hcoApTeHTvLlxmXPh+4Bvaa8CgXY59mD9XMaGgCdg6NHWjQnlsMoAN+cGTXjUFtghRyLZFSuhb8a/Uf3tM0X95yMxv/wM1Mka9QpJ+p2QLfX+vMpIcJz4VZgGW7J6x/D2KLA+Lkl/vIOhfY0PTkUW11BNn7kCkrsW+0bcdHBJHMmO4ZByOEDec3G2bURLM0xEjjWV0W1SgFF7EXYZkXxPAGufls6+6OvJ6asbkEN2G3eMxInP/VS9fN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

To avoid applying the same DAMOS action multiple times to folios that
are located across adjacent regions, damos->last_applied was introduced.
DAMOS_MIGRATE_{HOT,COLD} action support in vaddr is not utilizing it.
Use it to avoid unnecessarily applying the same action to the same folio
multiple times.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index ca7ce9bd96e7..c8f93a19c840 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -837,6 +837,12 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 	list_add(&folio->lru, &migration_lists[i]);
 }
 
+static inline bool damos_va_invalid_folio(struct folio *folio,
+		struct damos *s)
+{
+	return !folio || folio == s->last_applied;
+}
+
 static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
@@ -856,8 +862,9 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		if (!pmd_present(pmde))
 			goto huge_out;
 		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
-		if (!folio)
+		if (damos_va_invalid_folio(folio, s))
 			goto huge_out;
+		s->last_applied = folio;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
 			goto huge_out;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
@@ -881,10 +888,11 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		if (pte_none(ptent) || !pte_present(ptent))
 			continue;
 		folio = vm_normal_folio(walk->vma, addr, ptent);
-		if (!folio)
-			continue;
 		page_idx = folio_page_idx(folio, pte_page(ptent));
 		nr = folio_nr_pages(folio) - page_idx;
+		if (damos_va_invalid_folio(folio, s))
+			continue;
+		s->last_applied = folio;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, s,
@@ -993,12 +1001,6 @@ struct damos_va_stat_private {
 	unsigned long *sz_filter_passed;
 };
 
-static inline bool damos_va_invalid_folio(struct folio *folio,
-		struct damos *s)
-{
-	return !folio || folio == s->last_applied;
-}
-
 static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
-- 
2.47.3

