Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 736D7606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=bl2ixjO1
Received: by kanga.kvack.org (Postfix)
	id 1D5F86B05B9; Wed, 28 Oct 2026 07:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15FB76B05BA; Wed, 28 Oct 2026 07:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 075D26B05BB; Wed, 28 Oct 2026 07:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D84756B05B9
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:33:49 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 67209A890D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:49 +0000 (UTC)
X-FDA: 85371825378.14.C33AF46
Received: from mta1.migadu.com (out-218.mta1.migadu.com [95.215.58.218])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8330240008
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bl2ixjO1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dDUOitKwAW+3VTNHIPufF1Hg0ej/fAOtjzL/v/aRs4g=;
	b=OP9uilfajR42KcYZ4nZTYfM3GOZSq8UP3mToqLtHQwviX0pokW4w6xm53kRMsKdZtyty1S
	faY/yOHkwrGDMY1dYJGXS81Sjfe772iUOQnLRvaxNs2SpRvQjHScmTfIZOvvXRcdB0VnIh
	3R8sb4PvUwkmb8DUXG5VxlRjcfjowp0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bl2ixjO1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.218 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187227;
	b=jkQk/nhtxkyWZHobyGGpMGeo3HY9szFvYFoqdEPTyhv69pwGiyxo+dFyvoiHjxkPqtIEid
	jdF9PFDTc+z9s8xBsfngA3DtPJnbYlxajVxhRd7Zqy2ZFYbXs7b95XEL+mFdGOkHOch1ya
	DWzd19wLEh63IbhdX5ETv4m0lmSUI/M=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=p43Uh4QBygC4J7FaMvkYnDy+vZa3XCqhD7uuuVVkH9Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793187226; v=1; x=1793792026;
 b=bl2ixjO1thuQ87whdtgDcso+QayHJmPNY/bHCc//DGltM+tFHbY0ABNJ1/u+IsyzLohxX5ZS
 TjnDvIzBMkcIqVidBfr/lOwIhaAZS7R06O2Jr+PcWc/UQ3xm0lYe/nE7PPcJQa4trGSk4mNQCFF
 awWlFKyefFjPa79sG5WzbBjo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ece0e52f5c4e19b0;
	Wed, 28 Oct 2026 11:33:45 +0000
X-Mizu-Trace-ID: ece0e52f5c4e19b0
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Frank van der Linden <fvdl@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 3/3] mm/hugetlb: fix NR_HUGETLB accounting for unused surplus folios
Date: Wed, 28 Oct 2026 19:33:19 +0800
Message-ID: <20261028113319.38544-4-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261028113319.38544-1-kaitao.cheng@linux.dev>
References: <20261028113319.38544-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8330240008
X-Stat-Signature: db3nhhbem4b9f6ns911bb6r5czqh7z5k
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793187227-756747
X-HE-Meta: U2FsdGVkX18PIGiyZvwIdBBuOuEtfkFQfOezJ3Lm4US7HNQxntmvObE9C44Ed2CoDUb26lOfOEFAG6IomforABX4OP+eA+HQVlOg3LqwNqXTWQiMCaxZti0Z1W4WygctpFvlsaommHny4bcQyAKFV8t+TjRbRPl2xpmLqfpUreO/4ncHrwP/RB8vgIkKBCYqvbchRbbuAyiUwpFTUFf9aCpcp1J8bOxiM4sg0jjT5YgBUEAKNq3I2cDh7bIK/RpeaPM2sE9TKv91sQCyyGghMkKtBh6qgdb2pO7SVhV3w3fsLQIf6182ZKDZnnKOgsItob4A2R8QqhzkIe/xTNps+If3sT/Jtb7b9d0/CuXWzzoP0KlILld0XI2liNw03YX981iCLMTzfC3SnyHS4i6rSWn3ZXtSvkNvGRWpkkF7J3Gvwh0EQQkvEqe/NkPBwFEZZxEQC69WMrLoEVWlmssouEBc57lGIVsMQOCX3nzSEUqJDbm5lzBVMxrbCowQ5G1H1VhCJ73YhAVf4dVsaPYBjccdnLxYkU4TAljfk1VcWbSPebA4q6BXRdV9CUzV7F05j8jiri9+skFSzD9B/B2QSZz5zmDITJghbt0yH7DK4UPGt58PT1kip1+GH/foyUsh0hhyJgcVzKFTFwAclqAJovh1XtFib7eJTjBzgOM15RpTRFrDUgEV73OY6+MY/X7562QLSsS9tpA2UWA6Tcvrch/h6IMDg6Jy1+SPBWyx0TmRdEy7I+4Ru/Ffbb4zl8I4tvaAtZqvaIkMHpWlpZcvUTG1WFtGWhDVP2jv824bNxhBX20+5PmldDUENa48Nd8YSlap9f8gchG0oqxhG2vhbZV+3rdG7Vo+a33c7kDelFWUBKSiGH4NUbxjrV+UZZRv916i/FKDNDhj70cFkHAOZQ458HEioHUFOCflaZRbWXZ72ypLppZdnAOAmhBaKn5jsjycgQ/BbkLHQpvaPl7
 bB7ypTNo
 Eqyz2+S4RSC7NynbqqWHAu23uMTiHLAxs2VurqgkwiA1VeCoPbQxOPzG9giAtRUkxdns3jHOmyug18qLwt3bj6P6cCrpj8nxD38AvJO7fEy9c9LheuI5+wMFS4T/yXtv4Xs7qqGuNMmU0bi/LADsXASxHLZ/nNgt6f2+Q1rr8d3Z5RY5L5zKLa6ufIh7IlNJqcUQfbv+YZAZoPWyDecFYYZ4ckBOeZVrmYwRAmvNVNCuauTjlZyJj+LU0G1YRExIKRkbfWMeQtY0cZ/Pk5xKxaGSxP7ZKjDjOAqhbF8IdRvXH3VtUOPg8Xs6L+mVPByzykjw1IbfF3Uh7FUWqycDG/MIrDUUxkBOga77zJFGZSHdoRE2heq78B8spnzk3TvSI5WvyiqN6vcK9eWYPOfeoAo+IWoNz6co7/uMd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

free_huge_folio() unconditionally decrements NR_HUGETLB, but freshly
allocated surplus folios can be freed before the counter has been
incremented.

This happens when alloc_surplus_hugetlb_folio() rejects a fresh folio
after its second surplus limit check. It also happens when
gather_surplus_pages() frees folios because a reservation cannot be
satisfied, or because concurrent pool changes leave excess folios
after the reservation succeeds.

These paths leave unmatched decrements, causing HugeTLB usage to be
underreported and potentially underflowing the counter.

Increment NR_HUGETLB before calling free_huge_folio() in both paths
to balance its unconditional decrement.

Fixes: 05d4532b60e3 ("memcg/hugetlb: add hugeTLB counters to memcg")
Closes: https://sashiko.dev/#/bug/linux-860a3b8f-0b07-4cd5-a122-aa2288463bee
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8da4bab676c9..d564e6935e61 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2132,6 +2132,8 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		folio_set_hugetlb_temporary(folio);
 		spin_unlock_irq(&hugetlb_lock);
+		/* Balance the NR_HUGETLB decrement in free_huge_folio(). */
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 		free_huge_folio(folio);
 		return NULL;
 	}
@@ -2376,9 +2378,13 @@ static int gather_surplus_pages(struct hstate *h, long delta)
 	/*
 	 * Free unnecessary surplus pages to the buddy allocator.
 	 * Pages have no ref count, call free_huge_folio directly.
+	 * These pages were not accounted in NR_HUGETLB, so balance the
+	 * decrement in free_huge_folio().
 	 */
-	list_for_each_entry_safe(folio, tmp, &surplus_list, lru)
+	list_for_each_entry_safe(folio, tmp, &surplus_list, lru) {
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
 		free_huge_folio(folio);
+	}
 	spin_lock_irq(&hugetlb_lock);
 
 	return ret;
-- 
2.53.0


