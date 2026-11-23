Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54454606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 05:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CWn3P95f
Received: by kanga.kvack.org (Postfix)
	id 768AC6B05BB; Mon, 23 Nov 2026 00:36:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 719616B05BC; Mon, 23 Nov 2026 00:36:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6088C6B05BD; Mon, 23 Nov 2026 00:36:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3346E6B05BB
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 00:36:29 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A98A41A0678
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:28 +0000 (UTC)
X-FDA: 85465273656.12.29D1037
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 10B3E40006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 05:36:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CWn3P95f;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795412187;
	b=YhIr5W1pZBzpsSOWAAJ1yVl0Gj6Beh6iC1JYlNPqfbAvzr6xLRAQp1JEozn1Bv5+2v5Jut
	7VYPnVIo8q9lIC+P7TtmOhz8PLV11kLNrcTSKrBpSz5MKsI6YAsrwwwxfgBS1yJu0CfLWu
	tS9NGMKyVHnL9H/4EnlSeGMzp29iI3Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795412187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9sFOK+KXs6sLeJ4ZdoBhzgS5Tlddtxrz1lvI51ztL8=;
	b=p2H5gSqnw48YJSKMG+tXSJbdXYVlY6RkXN4cgh4fB17v77ItyIE6M6iPpey0fD3oJa9Xyr
	ZBEFjVmlJ/7xopVAA2mlM775iTsav20QpBbDShfofNOlrV3NE0VyKiMvql5nfujOMYiKq+
	CpB+QkgVds/LFIPTX0uIBITHHuNXFWs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CWn3P95f;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E5FC1688;
	Sun, 22 Nov 2026 21:36:23 -0800 (PST)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 63B753F632;
	Sun, 22 Nov 2026 21:36:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795412186; bh=yvhMH2OakXvEYE35OXI/rcsFGlC57o9zZR8B69rR+M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWn3P95fO+sqwEHSr7kr81LnE+T2a3zswsAG8LVFnj5YXKlKmX8gcmeun0wTsSWgS
	 UnV1m5KKq5ALtyHDCV3GDytyZEr4xQxHZsuRj/6Z75qhbYB4AV/4EzofE7vNJNxQc6
	 UrF3sureAQXBQSWqFUMEtHcT76p09NMdFEv6axXU=
From: Dev Jain <dev.jain@arm.com>
To: david@kernel.org,
	ljs@kernel.org,
	akpm@linux-foundation.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v5 4/8] mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
Date: Mon, 23 Nov 2026 05:35:38 +0000
Message-ID: <20261123053543.295467-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261123053543.295467-1-dev.jain@arm.com>
References: <20261123053543.295467-1-dev.jain@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hcrgjma4pmgwkj6atpygmmkni5yqm6rk
X-Rspam-User:
X-Rspamd-Queue-Id: 10B3E40006
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795412186-912790
X-HE-Meta: U2FsdGVkX1/4r0nnYwlUOvJCtdlPtBTgQG0czb2pTKoY1F67915gNb3Sa5JGhL0pEHGj/Gy+HF5ie4YDOIdnWLlogdJwxVyXtS6KVQK4zWJLy3YaEucEJFXsk1a7j0zE1dgBZYGiGy/zLqg0/lkzUvT/pUL4KyKhNrCve+dszcFpbfwjizvjjxgzhynJGrAlYT2IA/376VpeGoLdES8qjrhVXz+hOdQgQBK5leS+u7dvLSHkNOJqr+Us8OIhNy1SCbWaEQkZHQe+Bkw0Iqb2idMZrSO7ZC1OBFf8GBXgOb/Ux4WFABL/ZDWIyPUZzGczqOtuov8mlrNFGxYCIJrANlWAo/XjRW6XaB+HN7cVZOSNAfdXD7ttclKUzeEbScYNA6lS4ZD0JycVvFq5skzg94tM0QVu8gkIzcDnDdDHxrgMM0Y8SLJVXXLUxLASF8C+CPaPfqCCASlv2DT+neVa30DB3UiG6CFHVafSyj3UAamPKzblImprLYEXECrKL39EibuiNJukXdhPbgBgmXWex1lm1kSefH8PZJtxyU3Oh9jxtAji1w06MiJnLrhEWhDhO0g0LMwysPLQE/xI9BKMegf8cGbrpbKAn6KMFWGBMiQ5iPrfMned7XexsmVFuQtSLagJbgBFy6+rJkUskzDHlSQowS9yFPdnvKmCb3UbBDtlrSPf4IjujoMbYks06bEwo9L3xfRuinq5Xl7B8aF+CNHNIQvKJRXH96ylwECJbWHVhfakUdN4NyU8dR7N5+Ri0FIxYHHXF58jfvmtaGq4AMS7lEYyXukS+Az4xr9K/4UPEPIUHrV7Xt5pEs4jNR0DIpji+VEpgn1hZY8/Oq9RwFAN0J4NLtlLBGvUgNxspJR+DIDmO8xXkKiHSWauTKSj7k7rwzQfnSR/8lU9oltTXyRH1BPrHvgVqHDEcrvJBqCndDxwqkVk97GGg24KoYG7cDGv4ZtIHCqbh2eJzPI
 52lDPXo+
 neFOTxYETZ5zR9I0i+wreZHt8+E2B6Svhan0CpX9GWDZGwmtbVqhIA4y/Rw93r8itamfTEVPR//CEjHawo7rAvkjN8vVMGo/fw18gYQb5SJvmeDAvZqd/RNpdFpYd9IH/GLi2bhIN0JsbClUzchRSXV5iaxP5v2E7CjwVO7PyZh6S5xI+6ZmEkNNDu+jYb/e6L3ietS3U2hBlor4BHmdP0FopYH82On/NU91rHXbvlxa7K7H43ggt08Wrl057S1zYww0NbLZ9TnageWT+mG8D/6mXbIuDddK5z6DaIRZ41TsNwEaPwKHT4q0MHpNtaAAmulKe/DhhMCPvK/Zm8vSlbjinIoygpJYp0UbX6ezOckr0ZW0NEHyLJOsPx9I6KPPco0HDmpoLG1cHhzqYwSvVM4QNYXZzxRG6r2NztNO+ap4WaEl0uZmu/aqReY2hdEB/bQ7kJOyKW4QYweloYSQYCdq56Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

To enable batched unmapping of anonymous folios, we need to handle the
sharing of exclusive pages. Hence, a batched version of
folio_try_share_anon_rmap_pte is required.

Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on a
batch of nr_pages. Refactor the function such that the clearing of the bit
can be done at one place without duplication.

Note that __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR
from the PMD path, but currently we only clear the bit on the head page.
Retain this behaviour by setting nr_pages = 1 in case the caller is
folio_try_share_anon_rmap_pmd.

While at it, convert nr_pages to unsigned long to future-proof from
overflow in case P4D-huge mappings etc get supported down the road.
I haven't made such a change in each function receiving nr_pages in
try_to_unmap_one - perhaps this can be done incrementally.

Add two WARN's: check that the batch is entirely exclusive (for PMD
callers, need to check only head page), and that there are only
PTE/PMD paths converging into __folio_try_share_anon_rmap.

Reviewed-by: Barry Song <baohua@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/rmap.h | 58 +++++++++++++++++++++++++++++++-------------
 1 file changed, 41 insertions(+), 17 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index ec1e85855be1..d65de8184ecb 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -746,17 +746,25 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 }
 
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum pgtable_level level)
+		struct page *page, unsigned long nr_pages, enum pgtable_level level)
 {
+	/* device private folios cannot get pinned via GUP. */
+	const bool pinnable = !folio_is_device_private(folio);
+	bool exclusive __maybe_unused;
+
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
+
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
-	/* device private folios cannot get pinned via GUP. */
-	if (unlikely(folio_is_device_private(folio))) {
-		ClearPageAnonExclusive(page);
-		return 0;
-	}
+	VM_WARN_ON_ONCE(level != PGTABLE_LEVEL_PTE && level != PGTABLE_LEVEL_PMD);
+
+	/* We only clear anon-exclusive from head page of PMD folio. */
+	if (level == PGTABLE_LEVEL_PMD)
+		nr_pages = 1;
+
+	VM_WARN_ON_FOLIO(page_anon_exclusive_batch(0, nr_pages, page,
+					       &exclusive) != nr_pages, folio);
 
 	/*
 	 * We have to make sure that when we clear PageAnonExclusive, that
@@ -800,29 +808,38 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 	 * so we use explicit ones here.
 	 */
 
-	/* Paired with the memory barrier in try_grab_folio(). */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
-		smp_mb();
+	if (likely(pinnable)) {
+		/* Paired with the memory barrier in try_grab_folio(). */
+		if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+			smp_mb();
 
-	if (unlikely(folio_maybe_dma_pinned(folio)))
-		return -EBUSY;
-	ClearPageAnonExclusive(page);
+		if (unlikely(folio_maybe_dma_pinned(folio)))
+			return -EBUSY;
+	}
+
+	for (;;) {
+		ClearPageAnonExclusive(page);
+		if (--nr_pages == 0)
+			break;
+		page++;
+	}
 
 	/*
 	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
 	 * gup_must_unshare().
 	 */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+	if (likely(pinnable) && IS_ENABLED(CONFIG_HAVE_GUP_FAST))
 		smp_mb__after_atomic();
 	return 0;
 }
 
 /**
- * folio_try_share_anon_rmap_pte - try marking an exclusive anonymous page
- *				   mapped by a PTE possibly shared to prepare
+ * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
+ *				   mapped by PTEs possibly shared to prepare
  *				   for KSM or temporary unmapping
  * @folio:	The folio to share a mapping of
- * @page:	The mapped exclusive page
+ * @page:	The first mapped exclusive page of the batch in the folio
+ * @nr_pages:	The number of pages to share in the folio (batch size)
  *
  * The caller needs to hold the page table lock and has to have the page table
  * entries cleared/invalidated.
@@ -838,10 +855,17 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
  * Returns 0 if marking the mapped page possibly shared succeeded. Returns
  * -EBUSY otherwise.
  */
+static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
+		struct page *page, unsigned long nr_pages)
+{
+	return __folio_try_share_anon_rmap(folio, page, nr_pages,
+					   PGTABLE_LEVEL_PTE);
+}
+
 static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
 		struct page *page)
 {
-	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
+	return folio_try_share_anon_rmap_ptes(folio, page, 1);
 }
 
 /**
-- 
2.43.0


