Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38BABCD6E60
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 13:09:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5FBC6B03BC; Tue,  2 Jun 2026 09:09:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10126B03BE; Tue,  2 Jun 2026 09:09:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9260E6B03C0; Tue,  2 Jun 2026 09:09:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D8C06B03BC
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 09:09:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4536292A8B
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:09:03 +0000 (UTC)
X-FDA: 84835002966.29.E7C6C35
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf21.hostedemail.com (Postfix) with ESMTP id 23BFA1C0006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 13:09:00 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E3xf2kLY;
	spf=pass (imf21.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780405741;
	b=7kCuyNKK5aDlemNgP5w1iP3oo8VFWPUQ1cIfbpLuDMlVKHX/0s+pyiCeqwmYLW4T++QU5I
	HGtuMqhlxYRDOkQ+yNRF76b2Vz5S57jRbxFkqg0ObfNcmkUPZ77IFqicfgBI+zFLVem167
	40VDRTCgc/Rv98OGBJZOD8yhvN+EA1c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E3xf2kLY;
	spf=pass (imf21.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780405741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=X71Ko2dwlaj1eXjcSWID0o4QdsL8TgXl6KYElkJpbB4=;
	b=0zRX7JiRit1DoSwXmFzUaS85xMjDR6Bq2nvouViK4EPU2ruoYA+aNnPixqKl0A8lP/w074
	R7Em6Ozs31Ty4Q3LUZhbBxJASQkNMN6gWc5KwkaQVn8RUY9S03Z5T2ZKkkrWlDhOMsH5jS
	8avVdQNNaXaHTZY+EJa+4+1cOID/xso=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780405739;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=X71Ko2dwlaj1eXjcSWID0o4QdsL8TgXl6KYElkJpbB4=;
	b=E3xf2kLYo/hEXeRgNzPWIANuBWg5nOEsdshaf/ZbrauMZNH1+5xEYvCsid3Lh37+3Etk7j
	MO1Q+tIpL+DqcDqabvNVwPuxqYLzZbHhBJNlQi0w9NwJUf4izgZTbbWzsTAQkCV1FBFcji
	NaTNfNlC2SqgPbSQFzE2XlG4G/5K96s=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: Liu Shixin <liushixin2@huawei.com>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v2] mm: page_isolation: avoid unsafe folio reads while scanning compound pages
Date: Tue,  2 Jun 2026 21:07:55 +0800
Message-ID: <20260602130755.38794-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 23BFA1C0006
X-Stat-Signature: k9gmznmgya9cbb4mfwmd3cw44qqi1iqt
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780405740-668135
X-HE-Meta: U2FsdGVkX1//HXHTJuSFZbRALoT3NSHzLkFksKvMMC998/ymvN8J6zZrEiKwwgAHytAgOIrXbC9J+ycZDWtMEXayyiXBMTLOJX4nOOLj+5LxBD18Fg2Ul7JMVp7mejrdb87Be6zYbPPKi8nsKjZ0jBHPhSDnP19vGzq3otYClobEoBZ8FO435rINJd5JFozOEPl8slemG9koXXZrEebiaSU1HjZMtIXrOG+Pc+vIIuY7xIofTJNZXtdaTrhnAIBimiW2CO5KVXzqqt9ru4+/0ShRYe6poPyXQV3hB+hGnEoOC2kiE2I5A9ezoIYVUmww898fMGcpBgDemLkNFre/ldalMkkwSNcQy26h5rOFU2wIhszMMsM4w8FBFX/YrqZrdanVKgtOdOjpXpi1f+99Rg5YftU6d4FNokbvqYOgIuu/zaE+9i6cIimKtZtUBUOc4jWyxveBP1duHJi4Xnb/V7o5J9NIe2PZyTz+TNs44Tw6kjKejYVqhyvpSjMdRoEy2HeHLbwAls0eYzoJWPQuB9rZQB/NaUh6W0opPsiGDso32P+34JAAbV/wL0sdca0lZBTOJvgWeXkGOPcWFCRVPuIzQesltfgmqvF4tAnsjRIJOEAsp2UKZjB/+tucuZJVi3ZYBQbhByfp9OVg7pxw+IGRq9ixuQlJEvMX5ZbJvhD7cNpitJUp8FuwHTmIUzF44IhKS99l+jaPTf4w2bPqJbJYtQIGnNnDe3DjRTOHdIlpVSqaXJbuqVTuf+K9jTQSMNdBQEGUXKOQ8JKvSLXbnx5jyTXnb35pCD0OsfU5dpKsuQtsH5nbDQ8AwZN65z3az/mEW/o1I4YZOJdMXCTb6HdhHcUoRzF2K/cs1tuI2mTo82FLqOVTUr+TrIXJHVzbYk8fSd+dthOH540CFpq7V+6p12+OAAkFBJYv+i1/nnm9lbfAvHsRybG3dCP1mOD2TuzBU3qTODmeDU1oJf5
 tT3tarQf
 iNpqCOD08OsapuATFccxgQXLvx0Ul/Lf5Y2YNbtQFPSE5W7ApSN4KDn67hggKbCrAtEVmJF7ZnvkSkLL6VMEM2nhUv3Ww1Lq0Dsppc1FuXROcTLDKDGgPJXa0m6cgZkHEIwjfp1FfbHfzv3AlD0X7FRjCfQidmLPwMrinfD2DW4aD5ypSGjy+3Lv30HTg8YV146/08IECNCJCw0v3iUWan4tcqlxWRQHnNEqIpm9MQ9k7jxH+Fe5I9Fjl2l96cTjFjWbLRohJOnFipHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

page_is_unmovable() can inspect compound pages without holding a folio
reference or any lock. The folio can therefore be freed, split or reused
while the scanner is still looking at it.

The existing HugeTLB handling already avoids folio_hstate() for this
reason, but it still derives the hstate from folio_size() and later
derives the scan step from folio_nr_pages() and folio_page_idx().
These helpers rely on the folio still being a valid folio head. If
the folio changed concurrently, the scanner can read inconsistent folio
metadata and compute a wrong step. In the worst case, folio_nr_pages()
can return 1 for what used to be a tail page and the subtraction from
folio_page_idx() can underflow.

There is a similar issue for non-Hugetlb compound pages: folio_test_lru()
expects a valid folio. If the previously observed head page has been
reused as a tail page of another compound page, the folio flag checks
can trigger VM_BUG_ON_PGFLAGS().

Read the compound order once with compound_order(), reject obviously
bogus orders, and derive the hstate and scan step from that order
instead of querying folio size information again. Also use PageLRU(page),
which is safe for the page being scanned, instead of folio_test_lru()
on a potentially stale folio pointer.

Treat an unknown HugeTLB hstate as unmovable so the scanner does not try
to skip over an unstable HugeTLB folio.

Fixes: a0a9f2180b90 ("mm: page_isolation: avoid calling folio_hstate() without hugetlb_lock")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
Changes in v2:
- Avoid unsafe folio metadata reads in the unlocked scanner by deriving
  the hstate and scan step from compound_order(). (David Hildenbrand,
  Andrew Morton)
- Treat invalid compound orders or unknown HugeTLB hstates as unmovable.
- Use PageLRU(page) instead of folio_test_lru(folio) to avoid folio flag
  checks on a stale folio pointer. ()
- Update the commit log (David Hildenbrand)

Link to v1:
https://lore.kernel.org/all/20260519121646.40833-1-kaitao.cheng@linux.dev/

---
 mm/page_isolation.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index 7a9d631945a3..32ce8a7d9df3 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -41,8 +41,14 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
 	 * We need not scan over tail pages because we don't
 	 * handle each tail page individually in migration.
 	 */
-	if (PageHuge(page) || PageCompound(page)) {
+	if (PageCompound(page)) {
 		struct folio *folio = page_folio(page);
+		unsigned long nr_pages, pfn;
+		unsigned int order;
+
+		order = compound_order(&folio->page);
+		if (order > MAX_FOLIO_ORDER)
+			return true;
 
 		if (folio_test_hugetlb(folio)) {
 			struct hstate *h;
@@ -54,15 +60,16 @@ bool page_is_unmovable(struct zone *zone, struct page *page,
 			 * The huge page may be freed so can not
 			 * use folio_hstate() directly.
 			 */
-			h = size_to_hstate(folio_size(folio));
-			if (h && !hugepage_migration_supported(h))
+			h = size_to_hstate(PAGE_SIZE << order);
+			if (!h || !hugepage_migration_supported(h))
 				return true;
-
-		} else if (!folio_test_lru(folio)) {
+		} else if (!PageLRU(page)) {
 			return true;
 		}
 
-		*step = folio_nr_pages(folio) - folio_page_idx(folio, page);
+		nr_pages = 1UL << order;
+		pfn = page_to_pfn(page);
+		*step = (pfn | (nr_pages - 1)) + 1 - pfn;
 		return false;
 	}
 
-- 
2.43.0


