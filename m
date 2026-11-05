Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 21577606D809
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=VczYSozw
Received: by kanga.kvack.org (Postfix)
	id C69A86B05DE; Thu,  5 Nov 2026 13:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3B506B05DF; Thu,  5 Nov 2026 13:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABCB76B05E0; Thu,  5 Nov 2026 13:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 896EC6B05DE
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:42:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F42D80BCF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:10 +0000 (UTC)
X-FDA: 85401935220.26.F8228F4
Received: from mta1.migadu.com (out-101.mta1.migadu.com [95.215.58.101])
	by imf03.hostedemail.com (Postfix) with ESMTP id 483032000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:08 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VczYSozw;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904128;
	b=ctAKrWu8/b+Uzp1C1SjqP7ASnD3nAflw3xspR1bsjqzY/5X5dz8tKfnKkGHOP3Qus6RXfJ
	HZh60ZkgAKfVhNi8j/5R/keKK2+Xp4IICbEmcVXJdUbn43TDz5FKuodcspgw47Vo8pl0mo
	NzvkUAOm8afCxr2RwhAGtSh0R9OoZu4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VczYSozw;
	spf=pass (imf03.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.101 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64IaiU1Jn8/to2KlNcEKMRMIAfHn34Xc+y2Zc/87onE=;
	b=zUiTRoDARt+QV9xx+rNIDR6NV61Fzo6RizbjKWcR7JX2OvE96I81cbWIfH/dAjPsE66CQS
	sImjtTpVFbvippsosMrFNBEr5C00sVD9DrHr39F9FvmNoS/TUQXTiFdsmrpkPkvMcLoGA3
	N5gR7qosOfk8hmvgqyrWbYrw5OkLnE0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=53KC29oKTGdq1sHS30FhbmUhH+DwEHBLzotfAuJMBTQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904127; v=1; x=1794508927;
 b=VczYSozwZEpf3GQl0f+OdB/qMZ/Kg6H9n0kzZNL2pWhn6e6B+eMKDhmQSlhXd4as1LTLdeP+
 pNFyZgk/twuKr44bq1nozMOOt6GIexFThn4EuD8kaZOZOli7tCvmV6VXKWaN163tgpOXLgbWPWq
 mMyoBpaEHpBR6w+pF8PDer1I=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id c2998befc35801a0;
	Thu, 05 Nov 2026 18:42:07 +0000
X-Mizu-Trace-ID: c2998befc35801a0
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 25/32] mm/mincore: report PMD swap-cache residency
Date: Thu,  5 Nov 2026 10:39:09 -0800
Message-ID: <20261105183940.2236717-26-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: je5r916x5jytrib6zbrsnftb5q5p8b36
X-Rspamd-Queue-Id: 483032000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793904128-785890
X-HE-Meta: U2FsdGVkX1/vEabjea8dqQch8AAg3XwHW+4DlRxEs/pbTiVdsfagi3ogTRPMexc1d1NK4OPZrm/vMNpspQsGADuOjZiqV9K8oQuRecv7I1gjEmzEE+gUvuWWV4I2v/vwwwvfi9ddhwAqhMqj/VohAO8eVREI5MD4CbrBr6WyX0GfqoiOZ8u7Z8qU4oN2acHvQgfwsE6Xsbd90dukGT6ZkMNNNw7fQHe8c8/XYX0bLl70tIeFfRnSWPb9msFZGLZPXXSXOng8BA+2TewSAEMYSG2S2DPa/UUkS5+RiLdhzyqolkTpUchrJI4JmCxFeS9r7J+HuGLLdwYtVwuAe6/J576cyX7mAVDG6mp96S8vCuQW9AHPfK5hY0a8TERM63QXp75hyDKixJUi/6UCKfflT+TGeC7fT0w5Sd6+Tyg+nfa0CaIq4gbnUXMNz/KICvtCG6Px0X5SI0QyDqq80TYx9oBkj3j0Jd4K7ZYyz5r9+8baRvEd+ft2yEQHXl6xqld1brFabWbXxOhNpSxdUg3YJOY0gLA0VUWLa2l/EfZq4iCAYGVhRFhBRPSaHk4g+7dONzNxnfUPHnkh5W+7s5OcGpP///uD7x/fCdBniVL4dcgkIG7mg8r1nUAE8nJUW9UNDYT357/E/JlweOYjM4CUcvzkkNlRzqSpNyL9y5gWVgmNlIeAQ6wkrPNLY1V5e+JcovEMARgWVBWoUe/xiNloEKghCLakGnBcTDVEPRZGQBKtdZc1FwmHhWUgcpNuh9ZNjbotRVyCn3td/gtQDpK596cW/MfI9EScPwzVfx9c4aiDE5R8kHRYbN3+jgrQNKWKmHshAAdyhbK4UP0IhzdDZdjhDMLUpxknuVUredvR9SWDSCZjbrsQjM6BX0DKKy2JnsvUUgqdLeLrtvv4XS3GIiK/j9SOf5p/RxjFFUAwEZtExGHlSRlcpSxaSAJdsErxR5edfJjuZCc1TSvv1uT
 PtkXB/wJ
 tOgOZuSLYBzDRu/aeI2AqMleZ0DKeTCshiHR9RVTw+haD3413mVJFLeRAL9JeGo71chyO1Lx9skYdF4AmmjZA7hca2psp0WCTz4e23st0YgFGxn/4ZDSCIEGh2NgjmHMApvgw1CkVJ5JYm7zHZAURII7jxmluGygKfT3Ubi04tWmE540LC5hmqXV7KpaU7CZzEUS573eHm+0mg5qPKjjnjZujb3cOe3edGrYhbzmoQFkhLR8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

mincore_pte_range() reports every page under a huge PMD as resident. That
is wrong for a swapped-out one: mincore() would tell userspace that memory
it will have to fault in is already in core.

A PMD swap entry is only a compact encoding for HPAGE_PMD_NR slots, so
answer from the swap cache instead. One PMD-sized folio covering the range
makes every page resident exactly when that folio is uptodate; an empty
cache makes none of them; and if the folio was split while the entry stayed
in place, fall back to looking up each covered slot as mincore_swap() does
for a PTE swap entry.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/mincore.c | 47 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 46 insertions(+), 1 deletion(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 0fe50f8a7e629..bc144118e039e 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -85,6 +85,48 @@ static unsigned char mincore_swap(swp_entry_t entry, bool shmem)
 	return present;
 }
 
+#ifdef CONFIG_THP_SWAP
+static void mincore_pmd_swap(swp_entry_t entry, unsigned long addr,
+			     unsigned long end, unsigned char *vec)
+{
+	unsigned long haddr = addr & HPAGE_PMD_MASK;
+	unsigned long start = (addr - haddr) >> PAGE_SHIFT;
+	unsigned long nr = (end - addr) >> PAGE_SHIFT;
+	struct folio *folio;
+	enum swap_pmd_cache state;
+	int i;
+
+	state = swap_pmd_cache_lookup(entry, &folio);
+	if (state == SWAP_PMD_CACHE_HUGE) {
+		memset(vec, folio_test_uptodate(folio), nr);
+		folio_put(folio);
+		return;
+	}
+
+	if (state == SWAP_PMD_CACHE_EMPTY) {
+		memset(vec, 0, nr);
+		return;
+	}
+
+	/*
+	 * The PMD swap entry is only a compact encoding for consecutive swap
+	 * slots. If the PMD-sized swapcache folio was split, report residency
+	 * from the individual slots covered by this mincore() range.
+	 */
+	for (i = 0; i < nr; i++)
+		vec[i] = mincore_swap(swp_entry(swp_type(entry),
+						swp_offset(entry) + start + i),
+				      false);
+}
+#else	/* !CONFIG_THP_SWAP */
+static void mincore_pmd_swap(swp_entry_t entry, unsigned long addr,
+			     unsigned long end, unsigned char *vec)
+{
+	/* Nothing produces PMD swap entries without CONFIG_THP_SWAP. */
+	memset(vec, 0, (end - addr) >> PAGE_SHIFT);
+}
+#endif	/* CONFIG_THP_SWAP */
+
 /*
  * Later we can get more picky about what "in core" means precisely.
  * For now, simply check to see if the page is in the page cache,
@@ -171,7 +213,10 @@ static int mincore_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 
 	ptl = pmd_trans_huge_lock(pmd, vma);
 	if (ptl) {
-		memset(vec, 1, nr);
+		if (pmd_is_swap_entry(*pmd))
+			mincore_pmd_swap(softleaf_from_pmd(*pmd), addr, end, vec);
+		else
+			memset(vec, 1, nr);
 		spin_unlock(ptl);
 		goto out;
 	}
-- 
2.53.0-Meta


