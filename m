Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E166606A334
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MVghdw1b
Received: by kanga.kvack.org (Postfix)
	id 3A8856B05B6; Mon, 16 Nov 2026 13:30:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37FEF6B05B9; Mon, 16 Nov 2026 13:30:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD556B05BA; Mon, 16 Nov 2026 13:30:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 121996B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:30:05 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C08E2C025C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:03 +0000 (UTC)
X-FDA: 85441821486.05.852AFF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id EF3FC14000B
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MVghdw1b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MVghdw1b;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853802;
	b=udPUCAf/quJPJgiYtSLZM0/j7tNMTikKAyg9o1WF8tc424lAkM4HAHSnvj+BBZd/zdyy8l
	efXEZLufmjkIxmbLd2zkLEHRMqebK3LGzGoT5/v9lYdWLgb/jaTW8B/We/P0XEwhr0bMgF
	ji+Hw1NhOWURIOpYbAa+zW+gJqCJljg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvDJKGzSv+kEo6DEGZGlP63nUWVKpmSYnaml8ai5PMU=;
	b=3XCYipbVWWqWkwdF7oTFTREXohovrn6S1suM5bbiwvDL7uXmCpdD2Ubbe5ENbHrZyLGVj6
	t5bceHhA4UvD0ByKY87+oA0Ghla3Fpjx4ArnPFc6nfaV5ZwguxtVC6f38Iqcj6z0WRnUqg
	CKF2Czv2U+6adTLQGH2quHkYwHcqKn4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3698B4060B;
	Mon, 16 Nov 2026 18:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD43F1F000C4;
	Mon, 16 Nov 2026 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853801;
	bh=QvDJKGzSv+kEo6DEGZGlP63nUWVKpmSYnaml8ai5PMU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MVghdw1bb5iVAEe0Y7asR8AvaEXIsJlTi4w1KL+/JJw1mfwRUospv8ANEfvFlzWxA
	 mEU2xGXDXZDfpFWf7+WrdKg1IRfbMPUtafZgFtnJLaiSugcOglYeBBNNoM4st9ioru
	 K9FOBte25cl2QUh4dOaV6nBuCt4oFNYluKRT5YdvGcWpxveFWxDuko389MlODaiVBi
	 3sUnehV/Zn15VkWRZ82iz44K8b7a8UDJQHVHs0DfF53iVEqJqLdTdLrz1fZHXfF4U2
	 06fr1GrIl0t+raEYtlXTLDSYgrdB2eWVsS6UUNIf7q7P5xSokMucIpcnNIL94LjR3p
	 A7GZLrlJGlx1g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:23 +0100
Subject: [PATCH v2 02/15] mm/hugetlb: compare against persistent count when
 freeing lowmem folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-2-4dd9e94ea9ac@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1998; i=david@kernel.org;
 h=from:subject:message-id; bh=U2I3f0NptKRK+FQV1BsF9XE/Zx46VPb3vBH3cA0Buow=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3dM6dXZ+XB2/LTrrV/frX1Rft9+kthBZl/HxxdjT
 qUcCyoy7ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiy74yMkwu6kgQ7Xpqwvl3
 9plFzGff7tL4c0Hh9Mpky1R999KLcpyMDK+3qaSKn9zxzUhcXe5oYnGqmbTg2RPXKwWv/PPvjDf
 W5AEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: zye5s571nboha6tx6osorybxpqkfn6u3
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Queue-Id: EF3FC14000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1794853801-641835
X-HE-Meta: U2FsdGVkX18035CEaY5j3NiJMXC52QJl6AKmp+Rj4YHO37dtCp1cI2G8YLmXF9AYlKuQOBC1UO/OwZ0Pe+nZ7OIqsK2LT2ik9UMTzE85L0ZP++GsMtVmMmTcNDsaSfmviM7xfZ7x1px//EGQ6c6pXsBmKLeQME2bP2wNodKO2rAfQNc54yX5XjQdXYm2hlxQzTOT12FwUjtfC88IW98KfiZVnydxXJUStRGkiNhErhn3FR2bO6N2px6L4ctaWQa2oeo3DPuRNMt/i2ZhW5nNXwXJq175JghnpS11SPOLplNpiM/nsW6+Zzq0oJnjV0bMke4Px/LQl4WNrlerXS/ivahWUroDCbIm/yfPOUMYILiMGyPmXgiVqvisDiYy8Z4nxuhOzi04CuWCsmdM6sJaNeIHGv9ZYrHig7DIm8MsKV5KP0zGS1cekrBKd6U8FNlHloVuAiWNwR85hJuEBsZH/oYw/0E11B1C0PmSTsWBfBlMX4uhA/jtEABrEAWaXes/vtNYbxtaAsv5gUonYRTkSYd1B4l8sa522BLX5d+hiXb1UYAG+Btve7VSEvGm781mEHGuphR/jewIfyybKFcUvPqV95EfpboeyzrV3R3RQESVp7YFd8KaGyS06klptle9mRu72QsX7Fon2U5ambxdLxdSf3cfL4eSRemmaEnthtn6OCn1Sk2MIE0fxpMyedyw2CtaP4M5qoavSyjhfqdzPO4W5aUpOOgzPk+c2WAvCjr/5DLTSrKtuGPl+Xm1fTVBtxjqCaCdEjf1ptCpLCEb2xw9mv43y0ro6py79TU9qk4xdWoC6xX0f1x2oesFr9lJTuNwrcQ7d6CY22nrY9NS2s9/7Qsp3dXIpBal9mZYQVSEClwB8a6HiIVHK9VnWMWSkq4aCPJJcjBFNYYoo4tQdlbSKi8/YSL+OdYAzFBHhTqiczfO01OmQS7pjpF7GzxmuhKR9uEmn0wTVrCxkI8
 a0F6nBkl
 1vRbPNg3DkE/Vunt3aFgtyvWXb06X4BeAkuuCeWEND4pXHEfjPAFAVuDjdwqo0pUWfCl5/KT/F07l/eAxzsb1zY9JtkfS2EQJXNbffo2M1rVNf0+Ag+0zVDcYEAxggJOcicqOEWw92daCHR2NWGDgmUIgy0yeVlbdY9RnbRdwbadd0hq2UkBhrO1cuKaIVvjfb4brv2VYSdtf369b6GOXXYxu0YtcuQidInX2dXiqyh9FSMSmBXr7716f7FBbUM8C17r43BQ0nR67ZRKrwk/yh5GjwxMwka+Mtjdo47J9UJauAZ+V25zfIRT9lcovsmxP7i5n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

try_to_free_low() gets a target number of persistent folios, but
compares it with "nr_huge_pages", which includes surplus folios. As a
result, it can free lowmem folios below that target.

For example, with two persistent folios and one surplus folio, a target
of two can still end up freeing one persistent folio.

Compare against persistent_huge_pages() instead. Convert the macro to a
helper function and place it before try_to_free_low().

Fixes: 7893d1d505d5 ("hugetlb: Try to grow hugetlb pool for MAP_PRIVATE mappings")
Cc: stable@kernel.org
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 630c96cd1e880..349d45b932d9b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1339,6 +1339,11 @@ static unsigned long available_huge_pages(struct hstate *h)
 	return h->free_huge_pages - h->resv_huge_pages;
 }
 
+static unsigned long persistent_huge_pages(const struct hstate *h)
+{
+	return h->nr_huge_pages - h->surplus_huge_pages;
+}
+
 static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
 					   struct mempolicy_interpreted *mpoli)
 {
@@ -3723,7 +3728,7 @@ static void try_to_free_low(struct hstate *h, unsigned long count,
 		struct folio *folio, *next;
 		struct list_head *freel = &h->hugepage_freelists[i];
 		list_for_each_entry_safe(folio, next, freel, lru) {
-			if (count >= h->nr_huge_pages)
+			if (count >= persistent_huge_pages(h))
 				goto out;
 			if (folio_test_highmem(folio))
 				continue;
@@ -3777,7 +3782,6 @@ static int adjust_pool_surplus(struct hstate *h, nodemask_t *nodes_allowed,
 	return 1;
 }
 
-#define persistent_huge_pages(h) (h->nr_huge_pages - h->surplus_huge_pages)
 static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 			      nodemask_t *nodes_allowed)
 {

-- 
2.56.1


