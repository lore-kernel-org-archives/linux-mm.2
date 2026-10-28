Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01EC2606A326
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jmbv7PW3
Received: by kanga.kvack.org (Postfix)
	id 88BAD6B05BD; Wed, 28 Oct 2026 16:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83BB36B05BE; Wed, 28 Oct 2026 16:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DA2A6B05BF; Wed, 28 Oct 2026 16:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC2B6B05BD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:46 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 910121601DB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:45 +0000 (UTC)
X-FDA: 85373138130.11.52648DE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id D4160C0006
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jmbv7PW3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTRazsZdBI8g+CFMzwwOmm+CDhczykCZW+7EwaTrQQg=;
	b=4CsgV7yZVuN9647GFMIbXfvGaLlP/PamDTD5BEnpEGEOTpKzvmkXPjNGAm4V7ce6rY9Ok9
	HDXJu1GoQGxQssDdwak1G1L/FeQLXNOpy4qZgvAMjOIY40VymRC1NZyF4J/GTBfdXgoVC7
	fy8JKDK2t9/jbAcaGIPuI5gtpfuljbM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jmbv7PW3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218483;
	b=a+6o8x0g9nGmFFk0Cu9I87xMKb8JRbn0Oan4VwmtkG2FWsm9AgePu4GgPTi/5hPf9qa8H2
	IgpQByl00tammo+pSJsgP1Bf1v7jVZ5eTy6DYWew1zUdhdvOJWHcfeWlVo3SRyCHXD249s
	EX7FA6ILv1TG7rh4s3nthKYWxl9by30=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6975B6022E;
	Wed, 28 Oct 2026 20:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64AE1F031E1;
	Wed, 28 Oct 2026 20:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218483;
	bh=bTRazsZdBI8g+CFMzwwOmm+CDhczykCZW+7EwaTrQQg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jmbv7PW3v2cjt4B/n2gTzkTl1YD8RUeM0qObl+iD4RdBCN8Ek23lk4Z8KQKt65+B3
	 2sQVi/yY2kV0mjN8MNtMe625va5FiXAROuuWOmuqk9Xgd1cFlSOoIE3Hk/KLEzS+BC
	 1DF4r86g2wmroWD9Cy2SPF+fYsyuA79OynxZh48vgrBtMFbWLN7avYYoUKhbKBQCZd
	 DyXMusa4MA4j/Nr/halMKmH5c5MzfOHXbmAb5dMpbaElac3Lo+EzqiJMgse7WXPZgq
	 iy5H9v0k/OeB89xyOJb6buLXxVYfDbpHEYuFsJkkbVuWCViPvBhTAdWzi2LeM2P9qt
	 0/3HQH1WNGjDg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:33 +0100
Subject: [PATCH 05/15] mm/hugetlb: keep surplus folios when the pool
 shrinks
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-5-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
In-Reply-To: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2997; i=david@kernel.org;
 h=from:subject:message-id; bh=Hat0z9s8tQAupFoGz/eDgT1MoLADnvCUPqvsqVk5s+4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZfyXf5wdOWCO8uc/h3rfn34VaxZTElISGdKSfV5s
 y0qcV/SOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIvYWMDGd3fr72m7fsa+Um
 F5vrh+rvzz53blJp2ySzz/qTIhevj13MyLCW1Wdh9m3hND3fj4/ZV2dbqLUoyHWn/Bfl70heVHR
 YihkA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: D4160C0006
X-Stat-Signature: s6r5reofqc3ux616en1ehkp4y4yd7jcy
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793218483-90024
X-HE-Meta: U2FsdGVkX1+QQzU4C8p+5jtbdOhslLyyoxxNkjWaUye6pkmj/UfNhDtvR/mb31ggnNwc4/B4Rs1DkZK2WxdxYYNewj7yMt54r404P6vyBSXiZkJumikAeYt4R4G3yXvsJ1BhTPsy/vJ9zw6rpp8z1qrS3O9QJDWavxsUEIknqGw2SbIZBprR6P2JzLNUuT//9cVQEqmlD0oIEqgeqRhjH+bENXcjayQCExLaWwZeyQTabshtdAdiMCVkbDD5OT+SlqcA5RZQ6f8TdpmpqgTJfbnEVpf2bZJ23TtJREoMH5wB+3wlAHKC5wgbkvmt5M3fckbtu2dxJgxDvkE12ZL892N41VfrBhS3xzsJf5ROFE1W1GZda0RxMt+9qw4RBLKmoLC2JsoCffvGFhj2CXyXUEqKiUfhBpx9aXpQPS2hug/l0/++7BUYfI4K+TPBacPVafspCW830ad9um2Iq265+Hz84lpLj/mkMQZBGoPfiW7Q6WM+J3x3xjKbuQXYdtFqMT868FPN/MZwMBOs59in9JM/iVTYNJBTQYiBNhsmUCPrEtTCVCDgR3NzuHu+HBA+ok2+K9+xjFLmSZFFTYIhIxi+oauw4NHJ7WZxC1tQhhnzQ+7bj+8n8tslVV1zr9/7fP2FzEKGe7hY7bGdWXyBUzKVhDgnQ+pX2/fYizE+8ZQnj5yNLKKt2XGxxMOq131J6pJ43AX0olDMhG+Mo6+qJ/3el4NejxiPQPqLWkp7hMtw4WthmmSfdj0Deg0a5pUMH5s0rm/m0N11U0jVsbliFgkrwXnFBcgzEcx4IorJL6SPMKyjMHQdBfm1h3W5dhS3VyIpkS4ACZJ9aO/3CpilGHstUKBzq16rXY7DgyKqYQQdBcNq3sl4NjtczSUvVAY+uXZAiAQILbz/NJUx9qwA4cFhlkPb1Vhthk+8zvSG634rwuiiK7VhWDduJB5XxmAyJG6/eCrHBtNmE+8ADrP
 OnYrqhsv
 z2bs6rW/XOy1lkibi5rBEysZVF5SkanAToVLZ2ulHfNZ1CmMGRpWVQWDtfrbi9P+ZZI2FKG/MJF3Mtt2+RYxfqlPGH8VbNWz2zdaVOmaTpHly3oLsS8WIkhu8Z+e3FmJLNr4zJ9utUIMUNSMOg+60DFBlUL//U/n+LlsMIck3Br2z4xaVu/8yRxkkxWwwKBuPEPQsRnfAjerkGZqF4N62XaedYV8a6Bqz6++2QVdgwbuzJF0w3XZGgjf6p6C2/AIGKPKPj9D0/TaD3IJgk2t+6KlhAqQ7Wdqc7sqoI/5mPbdI7Ju0GMTv8ujaUb3vSJGR/WIZldgZdQNUBXFPsJ4pCgHUCP+HRWXYpNQ0X3m0Kq4JWkdEP84JXjquCnQohy+SWggg
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 110a5c2d9e50..55f7d692ed0d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1955,17 +1955,25 @@ static struct folio *remove_pool_hugetlb_folio(struct hstate *h,
 
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
2.43.0


