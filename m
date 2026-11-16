Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B71A606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ao0kEzZi
Received: by kanga.kvack.org (Postfix)
	id 9EB776B05BC; Mon, 16 Nov 2026 13:30:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99F236B05BD; Mon, 16 Nov 2026 13:30:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864336B05BE; Mon, 16 Nov 2026 13:30:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56A4E6B05BC
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:30:34 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E6C3D801FD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:33 +0000 (UTC)
X-FDA: 85441822746.15.C2C053B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 05C20120013
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ao0kEzZi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MAbycF0/+XNvdgeJe8qDtyiq8qtlOjB5ajoOuaStxBM=;
	b=5wfgA/hEtQh3sQES8zUZ970eM0d7wIZjpAgjn6jy1zcwt+RQQa3dJpJ65P7ETI+YYmP4C9
	a0+sYAMZWyb44eZH48rSJ2yUIQzbSduHvcrsIbLFBJ/g46ZoBZP8zfplzajPpazu6ZRPE6
	Ql/0YJrueOXWyc1E8pcn9vSBIKnoKTA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ao0kEzZi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853832;
	b=gONLNVCun1siblBpGf7hBkGa8kYREwgYEoUH41L5TYjZLaw7sCmwPqrBghUpO8hHDDhsNa
	h3rKoGro+mum2qk5VNv2JEMU3t5Zkcin1+AFj7A/sf7jTZ+3HvPDgBOBCBKeOsC8efyCEP
	t2ddiEcE//VAlspjJQLZEluo2E3gaDk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7148D623DA;
	Mon, 16 Nov 2026 18:30:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99E21F000CA;
	Mon, 16 Nov 2026 18:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853831;
	bh=MAbycF0/+XNvdgeJe8qDtyiq8qtlOjB5ajoOuaStxBM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ao0kEzZi0S4R/6HFc6vYp6H66hH146HshELvMNuBfW3wDR4Xmqa14Du85e8ZFtYdo
	 hvuqCh0o6GCANSyjeuo2+hv/FO5YxSQmPhJXy7Sq4EVSLs0fdJ2zaQ3Y3ok28eINhb
	 ZNgdfN6vjxHRgYTaCkCO8n5Y7k9jBnWYEToOxRaiByQpzmxn8d+wb3O+H0YlD3/uGg
	 YJ8uSV59VdqufDfbYEgO58HCx+atM6cK6mxldpSD2scA4lq5x2X8L2Anvg4SOj2TKN
	 b4AClfHx6Gj0WMRgdJbDKPpjiUm+WlgvpqH9Mhaod2pkQ7Zuo7EzBgtKcaq7qxHvNp
	 BLv60SWdKwK9w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:26 +0100
Subject: [PATCH v2 05/15] mm/hugetlb: keep surplus folios when the pool
 shrinks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-5-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, stable@kernel.org, 
 "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3099; i=david@kernel.org;
 h=from:subject:message-id; bh=p2A2APQ/0/VopuKu/gGhIyLBtoUy7qw63EWyI85Mq8Y=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3fcFpl3cplx2jfuP8529fZ9dkEu3IVJznEs07ueX
 Yg/4SzUUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwEQmvWH4n9FZeSPt1btNe/fd
 Wbv1anHLI+nl7ZvzCxlkQhYI/yy7HsTI8MJgrX2xw8/k1L8uHEFK85kduT4fd7/DViXUfO2y/pd
 DnAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 05C20120013
X-Rspam-User: 
X-Stat-Signature: bskwo5eqosz73dudd3rzhzmgjzct4f66
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794853831-442760
X-HE-Meta: U2FsdGVkX1+yttc3xG5/wUp6z5t/+9weCaUanlgNktWECPDuIvja6HNt3FLhJpKlmG3KKaz21GXchDVnLSPe1Lk/cM3u/S1Uu1alSm09Olcc6/SDHN9e8uxINhicwUts7U4T5tVqHKM4LOf5v9Kwwtps3925gUP5vs9jji98Q4TiNF+f8XH2h0Dc7t1grrISAkuZaacp2fSk8RaJG4Lg/mxeTUzi6YmdI1UGXS8wCJQglmSXlwiPgWj/9pC5CL4kOZY/qA0hTWbolbwi2qx2yZliihXco9ikOKl8p6kG2OfpTSiTbIXvCuedV7gtuN+tdIhJQIlhR5L5EnNKvulmGPkCcOaODpJ07SCMmqaaXCnz1AqpzB5YjzMLLg/ej5rSXNF0AnkqEOVGSze2OmF4WXWf5swuEl0GkvrvnUOKodvP3mIuJ9J7PEAwCwvkdV50P950rM8QzlZmDfbM/RNw8gGcqxEjFqOG7MazRZrcFeuOEwwPyq8+dk2+SDqSG37p8XZ+y5heN0Snk49EnNynofWe/9U1WaZ1MfWE0QrJlivHwsrRZZEdzkWkVOW8krn/qDCDJSD2ZjyK/cZzclePYhg8304iNfqfrg2YEUTDwRJWw+Ne/HTk4EerWmA6cVJfbs09BMQxgUi6nExKp3syqlmyL4wnmH+znz8a3rj4h4U6gwvs2pIve5XY3l03pLirmBQCLTIfKNGoWa4bagZ4dTAF75pIYSVuheoMJYNAke5BJ0Ewf0JwxashHi6I6qDWzCCPS+yWkpJS1UtDcgrF8j628QDLSYDGHd7oG0CROjzNfJebzdNGvNCO3RIcrww24HieCr1GQ61c84m/t1TJ4tmIf6q05+rwnl7cY0Pp5zoZ5eIiakuXqr79S5ygBBGaTJrPKSnGPnOWpE/y9N9bESbbOt0JCRQGZ3/gvh3gfNIeUatmIghZDA/BfVOLSbWgAt4ya4MHtj5JXRtfs8m
 ACCut2hH
 KgrzkkK20pEoy3ev6/Ef7VZDpDO7i2635Gttp83MAIIOmcKCfelsoiper8ocSTFHmmiAqLTVj+7Vbi0vKr7uDmBLQb2vQ4ArDgnqLplnzRjU45HlfMD8Zt1K4Cf5yri79W4IG+pBaYB1Pi1G6Mske9zuAwtrCjTAJjSp47B/uS7rV53/gQ3lLkgfa1/FWeSPLimpxQSdXodmmjt2LzqEl3ZWUJeQoxigtdD7orjhHW2N76KWq004YRVMz5Xj0oE4FkfauKnUk0zXHo7GzOc3AuBQgDx572FQoSQxTLzUondUYUvaUJAqQHjs2oz11C+3cCjU3yHnVUV+hiUGbigftWPhGZStqnZX5IlRYYNbuQna7c8wmrGKl2e2wzERNM5KdLUY2tsi6acHPqr0iAuu+DRa+OhOmDdVzAb+lXBs/a9ivloUY4PFcG2/pSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

Surplus folios are accounted per node. When shrinking the pool,
set_max_huge_pages() removes free folios through
remove_pool_hugetlb_folio() and accounts them as persistent folios.

It can select a node whose folios are all surplus and leave its surplus
count larger than its total count. Free surplus folios can back
reservations created by gather_surplus_pages().

For example, with nr_overcommit_hugepages = 8 on two nodes:

  (node columns show total/free/surplus)

                                      total free surp   node0   node1
  mmap() of one page, bound to node 0     1    1    1   1 1 1   0 0 0
  node1/nr_hugepages = 7                  8    8    1   1 1 1   7 7 0
  nr_hugepages = 6                        7    7    1   0 0 1   7 7 0
  munmap()                                7    7    1   0 0 1   7 7 0
  nr_hugepages = 0                        1    1    1   0 0 1   1 1 0

After shrinking to six persistent folios, node 0 has no folios but its
surplus count is still one. Releasing the reservation cannot clear that
count, and shrinking the pool to zero leaves one free page on node 1.

A later write to node0/nr_hugepages underflows the unsigned per-node
persistent count: 0 - 1, resulting in allocation of many folios.

Use persistent_huge_pages_node() to skip nodes with no persistent folios,
as adjust_pool_surplus() does. This also excludes temporary folios.

Fixes: e4e574b767ba ("hugetlb: Try to grow hugetlb pool for MAP_SHARED mappings")
Cc: stable@kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: cleanup code and description ]
Acked-by: Muchun Song <muchun.song@linux.dev>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d7c71025d166b..3ffd87eb9e45f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1959,17 +1959,25 @@ static struct folio *remove_pool_hugetlb_folio(struct hstate *h,
 
 	lockdep_assert_held(&hugetlb_lock);
 	for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
+		if (list_empty(&h->hugepage_freelists[node]))
+			continue;
+
 		/*
 		 * If we're returning unused surplus pages, only examine
-		 * nodes with surplus pages.
+		 * nodes with surplus pages. If we're shrinking the pool, only
+		 * examine nodes with persistent folios.
 		 */
-		if ((!acct_surplus || h->surplus_huge_pages_node[node]) &&
-		    !list_empty(&h->hugepage_freelists[node])) {
-			folio = list_entry(h->hugepage_freelists[node].next,
-					  struct folio, lru);
-			remove_hugetlb_folio(h, folio, acct_surplus);
-			break;
+		if (acct_surplus) {
+			if (!h->surplus_huge_pages_node[node])
+				continue;
+		} else if (!persistent_huge_pages_node(h, node)) {
+			continue;
 		}
+
+		folio = list_first_entry(&h->hugepage_freelists[node],
+					 struct folio, lru);
+		remove_hugetlb_folio(h, folio, acct_surplus);
+		break;
 	}
 
 	return folio;

-- 
2.56.1


