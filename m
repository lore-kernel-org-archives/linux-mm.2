Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 604D7607623A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 07:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vlqCJjlJ
Received: by kanga.kvack.org (Postfix)
	id 62EB06B05BB; Tue, 10 Nov 2026 02:45:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DF536B05BC; Tue, 10 Nov 2026 02:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51D016B05BD; Tue, 10 Nov 2026 02:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 323006B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 02:45:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 970351C42B4
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:45:26 +0000 (UTC)
X-FDA: 85418424252.28.0B173A6
Received: from mta0.migadu.com (out-238.mta0.migadu.com [91.218.175.238])
	by imf25.hostedemail.com (Postfix) with ESMTP id EFE7FA000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:45:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vlqCJjlJ;
	spf=pass (imf25.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.238 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794296725;
	b=PTSeSqj0P/cQmZoiffm78H437lYVp+kopkACN23lxdzTcdXvsmLGp7wZwLYgar8brLbJKO
	LI6EVkU7CFyzK5lywMDNVi70s+J1hhTOJTQrbljSNHdgwrVgZJK5L4n5eKq6W5Jq3sJs5i
	FB0KWP0Tdz9FEUz7qgI5sC5XAA+RU3U=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vlqCJjlJ;
	spf=pass (imf25.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.238 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794296725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bYjIYJm+n4nfDEAiZsWWktm7zzoyMcwgpbOm01w6spo=;
	b=rhfrftvfZ+4EZ5r8sc4iJeX5+BH2ICx4n4f1y3AxgXyppesUKC0Mesxhsx8IuAqzj+WeG6
	V2mf7cNHiYOG6OvDwN4Obn7me7lGBuMprIuWB3+aoSNBlnf+dIVZWJWymmueomtxno8G0N
	NdGM9Liim6HQbpIzX0665/InVZ2pZ3o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=eY4VzD6wuof/JGdxP9nVKDJYmUFOxcoqpj+Y4Rp/P/w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794296721; v=1; x=1794901521;
 b=vlqCJjlJyhHO7JNbh8wajhkg5NO2nXDKM909lNOFUfkvgpW5VMjfwx25/Ij7r4IAoc3qN9jO
 pvKoFU0KTLNqAH5FS6p7MEbW8dboYwgKqMDNyHnEDT077oFgIzFKurSY4FboJMkAIQaAG2+6jjm
 Wzn+O01jdKSBSvqiJwnfISLo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id d048f83d76d25cf6;
	Tue, 10 Nov 2026 07:45:20 +0000
X-Mizu-Trace-ID: d048f83d76d25cf6
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: xu.xin@linux.dev
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	corbet@lwn.net,
	david@kernel.org,
	link@vivo.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	odys.yuan@gmail.com,
	rppt@kernel.org,
	surenb@google.com,
	tujinjiang@huawei.com,
	vbabka@kernel.org,
	xiao.wang@vivo.com
Subject: [PATCH 2/4] ksm: skip rmap_item allocation for non-zero pages under only_merge_zero_pages
Date: Tue, 10 Nov 2026 15:44:49 +0800
Message-Id: <20261110074451.220524-2-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261110074451.220524-1-xu.xin@linux.dev>
References: <20261110074312.219847-1-xu.xin@linux.dev>
 <20261110074451.220524-1-xu.xin@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gkq7df7ozucdz3x5ixx7sm3uwg59nabb
X-Rspamd-Queue-Id: EFE7FA000D
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794296722-16840
X-HE-Meta: U2FsdGVkX18Behtq/Uhs1gvb0VePdjPZMmpuACxwxZTLcTKsHE3psaiy3H4gyb8lfzzPmEeasjQvIwJmk6Ao7Kh9zoyRTWHvL14Ih+17eNhnD2FnTF6/CtdGDYnDpQ/PwUR5CMmDagVTv1Ae37sUyqZb7zfvIwsj4R0iUagOpBMJJkxt6VNxzOyy7UY2N0yr5uLh8Godv6C5LGBPTEMZT5XaVvtivOQsHcbGoOhovMIgal7Mk9Xqgg7YPAcMRwGK3jy18QzKJZnsO+ToK6WOWrRmMwSoXWa4oMeFNzs92+qCe5OH7jXFdtRHotyZiOlclRXzNh4Ec+gFL6aOMYdOQKOaGkPeal+d6i+6kyrPTHzWjnZyfaYkWMRoa6QG78K01ZnhZqjo4lfib7LLTCvUxaQCM4kfjeDa4nqneRxPkxRhYIfJAlbdF81ne52GB/pGyYA3QnI9R5buJe4R/wJzv6JlBwu+3aSXJm7XmojngXruPIcP9CxsddgduPzZgDFeWp0T8xs+PJnbAdR7E4tNTnk6h5j3odzW0mYnfIJZmWk+bv4+or/QAyNl7/gceq3whAvkrlMPGHar9VfPqmaqQDdirpcjWNvKZqGXX498iy604T+36OJq3BY0IzugxEUjNIhoQJ7PISmsxQ4aOjMMhbhBrCvnMlgGfLjJorr9pUhFO3BoA0KGvDZpUgc54L755sQpw/oH4r18UPeS/7oZqTFVej1LZx70wPgvK2TmETgPK9hjRlMxtrx9GGXIDyiWUx9XJJ0qfVczj8wZ81482CBBEuEo6RFM4yktaVdZMsw8xspMYsBIlGNT0ntQySLoyNdJ8bgQ2vJqiy082WSmMns4xYiKpDDxZhPkhWJA4z/mO0LKNHS9avhS2mMC3FCeG4Jp4THWj3TuJQ2oanZcZdMnRpf+cJSG/8GoiziIcaB+RuWJVanaW4tJ6MEYKCBwiRMLQCogC26MRCxNOSc
 16a6UJKB
 L1W19Al2ODmxu6yoNK6oP7D8xQVpNaCOLsLRfHdvVjgLlpmWTpoIn88zeCEaAZoOFYsdx9gceHymE0AJoE8zO74r63VivRx5FxE8GhWTnczTA6XBt3DutQnt/y6z/NhmUzNY2LnFhCvuZxyujMVtvpK8xwrpzDSxM0BPfJ6pbKteb0NndW/vsKC8U2lZ+dqpZpUwWx0kVgiiYx4t7KvrSxhYIkpS0c1rCBglmzfSybDFb/T1ClSw1PZTQBsFkdzl8mwpxs8uOVmFfM/W8v/T8XtqgWt6LIo3bo51BDFXT0G113u4cK+4GB9tII09hN9x4HCUCY27AHomw5+1meyaEGFUaxfeldF48EIwdSeGF1NG71Y63kjtAh4WBpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When only_merge_zero_pages is enabled, ksmd only ever merges empty
(zeroed) anonymous pages with the kernel zero page. A page that carries
data can never be merged, yet the current code still allocates an
rmap_item for it in scan_get_next_rmap_item() before cmp_and_merge_page()
decides to skip it.

On workloads with a large amount of non-mergeable anonymous memory this
is a real cost: every scanned non-zero page pays for an rmap_item
allocation, and the rmap_items accumulate in the per-mm pending list.
For example, a MySQL instance with hundreds of gigabytes of anonymous
memory (mostly buffer pool pages that cannot be merged) ends up with
ksmd creating rmap_item metadata for each candidate page; the metadata
overhead can wipe out any gain from the zero-page merging and even turn
the net benefit negative.

Add should_skip_non_zero_page(), called in scan_get_next_rmap_item() before
get_next_rmap_item(), which, when only_merge_zero_pages is enabled,
checks whether the candidate page is all zeros. A non-zero page is
skipped entirely: no rmap_item is allocated for it, and any stale
pending rmap_items below it are freed (as get_next_rmap_item() would).
The page is reported back to ksm_do_scan() as ERR_PTR(-EAGAIN), which
counts it as scanned and continues, so the pages_to_scan budget is
preserved.

The all-zero check (pages_identical() against the kernel zero page) reads
the whole page. For a non-zero page this is a net win: the extra page read
is cheaper than the rmap_item allocation and the stable/unstable tree
operations it would otherwise trigger.

A page that is zero now but is written before cmp_and_merge_page() runs
is still handled correctly, because the checksum-based decision in
cmp_and_merge_page() (added by the previous patch) is the authoritative
one.

Signed-off-by: Xu Xin (vivo) <xu.xin@linux.dev>
Co-developed-by: Jinjiang Tu <tujinjiang@huawei.com>
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 mm/ksm.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 82 insertions(+)

diff --git a/mm/ksm.c b/mm/ksm.c
index 49f3728a3d03..e641c37ee096 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2535,6 +2535,69 @@ static bool should_skip_rmap_item(struct folio *folio,
 	return true;
 }
 
+/*
+ * Determines whether a candidate page should be skipped entirely when
+ * only_merge_zero_pages is enabled, before an rmap_item is allocated for
+ * it.
+ *
+ * A page that is not all zeros carries data and can never be merged with
+ * the kernel zero page, so there is no point in allocating an rmap_item
+ * for it. Skipping it here avoids the rmap_item metadata cost that full
+ * KSM would otherwise pay for every non-mergeable page.
+ *
+ * @rmap_list: head of the per-mm pending rmap_item list
+ * @addr:      address of the candidate page
+ * @folio:     folio containing the candidate page
+ * @page:      the candidate page
+ *
+ * Returns true if the page should be skipped (and any stale pending
+ * rmap_items below @addr are freed), false if it should be processed.
+ */
+static bool should_skip_non_zero_page(struct ksm_rmap_item **rmap_list,
+			     unsigned long addr, struct folio *folio,
+			     struct page *page)
+{
+	struct ksm_rmap_item *rmap_item;
+
+	if (!ksm_only_merge_zero_pages)
+		return false;
+
+	/*
+	 * Pages already merged by KSM are handled by cmp_and_merge_page();
+	 * do not skip them here.
+	 */
+	if (folio_test_ksm(folio))
+		return false;
+
+	/*
+	 * An all-zero page is exactly what we want to merge with the kernel
+	 * zero page; process it.
+	 */
+	if (pages_identical(page, ZERO_PAGE(0)))
+		return false;
+
+	/*
+	 * The page carries data: free any pending rmap_items that are below
+	 * it (they are stale, as get_next_rmap_item() would), and skip it so
+	 * no rmap_item is allocated for it.
+	 *
+	 * Compare the masked address, unlike get_next_rmap_item() which
+	 * compares the raw rmap_item->address (which may carry the
+	 * UNSTABLE/STABLE_FLAG bits). That is intentional: a pending
+	 * rmap_item at the same address as a non-zero page is stale and must
+	 * be freed here, not returned for processing.
+	 */
+	while (*rmap_list) {
+		rmap_item = *rmap_list;
+		if ((rmap_item->address & PAGE_MASK) > addr)
+			break;
+		*rmap_list = rmap_item->rmap_list;
+		remove_rmap_item_from_tree(rmap_item);
+		free_rmap_item(rmap_item);
+	}
+	return true;
+}
+
 struct ksm_next_page_arg {
 	struct folio *folio;
 	struct page *page;
@@ -2737,6 +2800,16 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 			if (tmp_page) {
 				flush_anon_page(vma, tmp_page, ksm_scan.address);
 				flush_dcache_page(tmp_page);
+
+				if (should_skip_non_zero_page(ksm_scan.rmap_list,
+						     ksm_scan.address, folio,
+						     tmp_page)) {
+					folio_put(folio);
+					ksm_scan.address += PAGE_SIZE;
+					mmap_read_unlock(mm);
+					return ERR_PTR(-EAGAIN);
+				}
+
 				rmap_item = get_next_rmap_item(mm_slot,
 					ksm_scan.rmap_list, ksm_scan.address);
 				if (rmap_item) {
@@ -2839,6 +2912,15 @@ static void ksm_do_scan(unsigned int scan_npages)
 		rmap_item = scan_get_next_rmap_item(&page);
 		if (!rmap_item)
 			return;
+		if (rmap_item == ERR_PTR(-EAGAIN)) {
+			/*
+			 * A non-zero page was skipped under
+			 * only_merge_zero_pages: it was examined but not
+			 * merged, so count it as scanned and keep going.
+			 */
+			ksm_pages_scanned++;
+			continue;
+		}
 		cmp_and_merge_page(page, rmap_item);
 		put_page(page);
 		ksm_pages_scanned++;
-- 
2.34.1


