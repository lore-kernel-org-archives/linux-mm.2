Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7AE606A32E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oYkOuaEL
Received: by kanga.kvack.org (Postfix)
	id A50FB6B05F3; Mon, 26 Oct 2026 19:28:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28916B05F4; Mon, 26 Oct 2026 19:28:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93E096B05F5; Mon, 26 Oct 2026 19:28:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6E3816B05F3
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:28:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF265A0917
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:28:53 +0000 (UTC)
X-FDA: 85366369746.05.8E020F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2DC67140006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:28:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oYkOuaEL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gF7dfVW7ww5vbIAncWUWYvaJygRoZ4DG20xiWs3pPy4=;
	b=mp79k4PnnMtPW/adR6A5+s8F16XB43bLhjq2puMe856bO0PEhv8PtPvylID5+5/gqlkUh0
	mO4yMNF2cm7pbXa1befiIGSMqAqWxCiG+rg3Ff0wn4kg31M9dBedcVi7qbkoA/FlYV6std
	4VnR9DYGGkdgKjtWvf3dMakzdmBldbY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oYkOuaEL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057332;
	b=XEBxk2GrcZbeU/Ekql2LzCsZUC/Ki/o31DLIUqJTt711gZ8U2+IVfMDHHLgHFK2n9jBvyz
	KCdHMb9YdjrXKnaia2VzAFgo1CJYsN98HjAuL/A7f7+9siqhs/rxFbbdRnwXHX50i4U3i5
	Taemar6CXw4hF+kzM1g1AmDrPHqPbp0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C7A9444F1;
	Mon, 26 Oct 2026 23:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BF101F01828;
	Mon, 26 Oct 2026 23:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057331;
	bh=gF7dfVW7ww5vbIAncWUWYvaJygRoZ4DG20xiWs3pPy4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oYkOuaELaYMUn17YBdlpQyUseXxC4wzgiNnmDJaOQTYshvN5UKt+eOpxgTs6OFsxO
	 irMDteaP8DmEIM3rhJcEOqcTu332c0EkcHZETz328y29O2fbdk+g0ZFbQAEefQ99Te
	 TPiw9Y3vJv79FrLCvRwXbSvKBfgiLZijII0zrAyFBAOCbu4l1P7wowb7pkTHIntZHC
	 Qo4FTDYJEtsdK9kUbjP6LyiotCNfu+HkqWY3VIX9YwVY0oulNyftXZdvydxGWYsJhF
	 glBeBeUDY2xyh7jPwJD9ALhbgDfPl9Ej9TheUjtZTpWni9hCMhjzEJEpA8qTcqoQya
	 adO2jQ9DmgIjw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:55 +0100
Subject: [PATCH 35/46] mm: fix unmap_mapping_range() beyond 4 GiB on 32-bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-35-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2194; i=david@kernel.org;
 h=from:subject:message-id; bh=yohgL4i9AjCKZukx2CMHvMiMRro+7y2Mtk1tuDA6CqQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu359uMWti+vt6tyzNqsIFL978VPj9+m3+/xAF/UNbF
 O1m/efm6ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAi3wIYfjKeuiChaXFpBi9L
 y88Ne++/nanp0+U/z/bhwwsuQVlWqpIMf6VXeGYpJt/pz/YO87x+1KhG2j3HwqvfzPD9RNXVTlL
 SjAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2DC67140006
X-Stat-Signature: n9h7h6i43zkifuxkgu5etzt4nw75rsss
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793057332-451290
X-HE-Meta: U2FsdGVkX19Vb1gM/Cb4/pLDqZkaNCtCuqqY5TTdUptF8YltSci/TshoZhVmHHr01Dvk2ixbuP0zWA44LElgvOKNPrYXQxNMYN3bnptYfF0RCe9ZLryJLzVW8ewMUxEdsOtrzFJNRCWxbP+4Vrxs/G7vX5eqEdnTXtN+TeZwy1AfbbvCc3ucXmvbBPg4tLnsLHxg4l5ZGJ4/IgDgERL4LDEw1M0q5GJQ3L1rQDPwqs4FHw3iLYm7foMpRnTLEpdFOBBPzje8THq7f9LgpzgDcc9Uksr/t1LAwLmQA9UKf4yTVZNUFc8b2t97DgwGnxl0zK8auJtX70zpGZvFZ7Fzstn8NC4ut/tbB7oAogMbv4m6j7BxAQXQ9tDyA1SafMtXENBkjVbBWSBN9TIEfoymTaVQSQqEnJxR3oQxQHj7RogbMFl/FK1xK/J0BU2zwkOAp5WEo5V/UN3w3Ncw33o6QrOY8V3mYEFFs60kecOIwo+6+6FUsWEPGFSmti9IvoSGXxR/jwGuQ/hjB1sGDg2SVg8Bdf+ETURqpiWtjM0YiR+Asvb3i0AGaxJWgaXWXGpp2ta0CvZYE+hfyN8O0fhE8DzWaA8Yu7Yz2+8ga2SruS5+BswKuh526X0blCE97FWwbsyPYq1hZRsLPOHw76aOREWKwLaJzXLgehLM4jJ5HDTpQ4/RPV0HlAVK2vXxvcxuimwMCJJH+kjTWB7oAGkZ0DmgINVAbOaVGBmntECXZb1o/lrVhyBtivDAFgPKTb29kOOBVHCCApJmKeBNTWYBAqwB85p3NmZbY88D9SszMb5Cn24fNbN0+P6aYTGyplxrwEm+uzuJRxG1RyFI/HvnKVO61RkF3En9YlRfEfWiD5zecpV1ZdzfrQTGojoQd/mD0WNHSrEA/fHLemB1xpVMZOjIbVW/E5UOP4CsTShk7IVq0c8J8p7WKN/PQ/VyKvHBKTP7vnxnFFRQYp5Frao
 WdXRbRfh
 Sj+ZEzwpNzMtna3p/HQX8CDyqdCKAb+lrBqIA9xOiDwjuNj5iiFlB5zR8VgAzzbS/DkCNF1q7Fuyslz7baLGHlPT6+iU3hxtmIE0rHgjl1I7dZsYLDst0T+NnSSnNIwHVmKZv+QrxRLDdFN4XdcBX4ivm3TeSCwq9UJL509jyrx1lHCTUfl+5fAbuB6ihTlZQcUqyOYloUhKtWEIW4xoYizbHH+X39UjPU54XO0LcthwaqYHKw6cdTl8kGaXy46HzhuNysv/Gp2J9FKKcJlXS3MlMSgrEfdb73hnN2Y3zW7cVuIk8uWz74zO41hBRMYbg8YqPkBxPvs/Ry+srgEDs3nwdQdVzdQ4ue1jfX2XSsHg6s/40va8UivklK4iHXNR28pcpqZ0ddeAJxKqbJQQWr+YKMmDT/27bcRlrZrQViyVq8Ww=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

Commit 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
made holebegin and holelen unsigned before they are shifted, by casting
them to pgoff_t. That is an unsigned long: on a 32-bit kernel the cast
cuts off the upper half of the two loff_t values, so a hole which begins
at 4 GiB or beyond is taken for one in the first 4 GiB of the file.

truncate_pagecache() passes the new size of the file and asks for private
COWed pages to be unmapped as well. If a file of 6 GiB is truncated to
5 GiB, everything from 1 GiB on is unmapped, and what a process has
written to a private mapping of the range between 1 GiB and 5 GiB is
lost: it reads the contents of the file again.

Where the range has an end, the wrong range is unmapped instead of the
right one. The page cache copes with that, as it unmaps every folio that
it removes. The callers which only have unmap_mapping_range() to get
rid of user mappings do not, for example drm_vma_node_unmap(), whose fake
offsets reach beyond 4 GiB on 32-bit, and revoke_iomem() with physical
addresses of more than 32 bits.

Cast to u64 instead. Nothing changes for 64-bit kernels.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ec7a1397ab833..5c5f326b8bcbe 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4649,8 +4649,8 @@ EXPORT_SYMBOL_GPL(unmap_mapping_pages);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows)
 {
-	pgoff_t hba = (pgoff_t)(holebegin) >> PAGE_SHIFT;
-	pgoff_t hlen = ((pgoff_t)(holelen) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pgoff_t hba = (u64)holebegin >> PAGE_SHIFT;
+	pgoff_t hlen = ((u64)holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* Check for overflow. */
 	if (sizeof(holelen) > sizeof(hlen)) {

-- 
2.43.0


