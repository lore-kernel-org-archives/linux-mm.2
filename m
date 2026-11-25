Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A575606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XS55ov+z
Received: by kanga.kvack.org (Postfix)
	id 44C836B0AFC; Wed, 25 Nov 2026 17:34:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FC296B0AFD; Wed, 25 Nov 2026 17:34:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C48F6B0AFE; Wed, 25 Nov 2026 17:34:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0442D6B0AFC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:34:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82F8C160152
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:34:49 +0000 (UTC)
X-FDA: 85475097498.16.5399A78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id AC883140007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:34:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XS55ov+z;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646087;
	b=Py143YEV2rCwy5LhrSpyGy+Z5HHIUY10HuVgdrRDx70Y8zNbtmqHUZA8YRR1zg997YvY/6
	NhCglr/LgFQknhkYEm2zcv02ulY4oAD2FkNMmceteFRs1QHOA4OzLcru0ShKis6wl1kbm9
	h7Kj6aKalTltiLwGzmmTuducjkm46fc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+7eQOKRTJo3SLTBv1Jd05JmL/1qkaOFv7kkY51zdPi8=;
	b=a9Xn/KVUVmrgcxx4dE9mHdDb98LDgrYRMxyNVxxdQyeQL15W9f4Go+Y4UnGkX0Rp4Tx2Sz
	1ijumYRjugsso/N5rdkh76hBE2WOQsDlK3Mg/UvW2YvkJWaC6RqjsTaf4nNyNGnZKFvbyg
	aSotxbG5zswPSYfc5T9kC347BTsGac4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XS55ov+z;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D1E1D43E73;
	Wed, 25 Nov 2026 22:34:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2211F000E6;
	Wed, 25 Nov 2026 22:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646086;
	bh=+7eQOKRTJo3SLTBv1Jd05JmL/1qkaOFv7kkY51zdPi8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XS55ov+zqWoVcnX4hPssMBTYab88z/dEVQhSp3UYfJX8JimTbKs5+14jIjxvktxOv
	 CmlOhqWq9d1GIPrDcgOgRzNHTg8A3LxMHspSf/h5cRwVX6dtsWLHSuoOpPTMx8BvPT
	 oq2zzO3tNyTrWvrlilSG99kw0BF0O/NLxKEbdUCu1ilDUwNsfHqdzGfK/A5S2m421W
	 T2sXkbyk++z1LuqN9xr2ENeAhfGOHOfH9RHjWJR/foZBRcfqGR5TYBkVN9XlqsMIN5
	 cdGugAAMR9VWpn0gbVllfwqz2SQq8YbbzPeRJjEEOnozWftq+AqrVFTPeVxGLKQ4RZ
	 NW+RVHKlnx0SA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:03 +0100
Subject: [PATCH 05/21] mm/hugetlb: free surplus folios of other nodes on
 free
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-5-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4706; i=david@kernel.org;
 h=from:subject:message-id; bh=TlH3URFqdFZZwxSAcYE/TmvkYUeArrst3wv1uC1N/aE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1QuVaQ35Nxa47v6yKM3ry7+KD2/+/fnD4kF0r/sc
 mRls38od5SyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjAR86sM/8uXxx5IUmJRTX7w
 t1Xwv872I9vuthqXPZlyhuetpMv0Fc8YGV5vluE/H3auWvxGi+Gfnh95bAW7+B4bmR1iXz2DY6I
 jOxMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC883140007
X-Rspam-User:
X-Stat-Signature: 1teb3hbrteoy7rjq53rq6gm49iudd4ar
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795646087-486694
X-HE-Meta: U2FsdGVkX18GjeiXx0gepxfwcBYjzghtDOop3ijpbXY70lzxy/aDV9iBamKwkHJzqQ7JPlwK3ws+XNAj3sgh15GG6g8LMRiZc5hiHdbfGSroei+z+kwZgqsjKM57CPYnYoEDsZrXK5HI3/BPeMf8q1d8EfyPlQFYVk43/EbniLuPFfTOIXgJSn8lu5/+ESzQZ8fgIbMciqfmIOr4+QQ4nZQCJhzoBIR6DYbnyqLVATqmnikhOcS+FwWYFK8sTs++6v7uZI5AX6wOw9NyFaVKIXiIMtcsq+7ZQHYDhGuLF0HcY41TJEh3sV+brfbMCOgWMwUqWaXmwwCM3Mz+KP65Cdb+wKu12s7YLHxYnokOuxbjZFEXzkBBHxZBr0U/VHBNmVIUw6233vWm+GQgo646BOsRgJlZ+RKzxCqq11rVsjnUKFTrDap+JHbvluWzGiNoSlHq1Z2ARKNN3SIOk3aK0paRhQ6aYoeEDyTSPfPBdtTUxJFHnwoweAhDwVjEL/RlhZP22ZXrBLFGybB0N6aVncVVmzjiKLC7sEtkMByPTQ5JUncVUq2dghCIeWyE4aOzJf+QtjgpOhyHkO9CgP2zovnvhl5srv8JMXrHlck4qg8y1mLnM5YMw2hubtJuZoZBWS/iEIFkPCDa32SDUYB5tOgcQEKdY52NKviwOSg6BBpnA51a5e1/tn9JPnQfigW/TnF8nLmSy5hqAG+96+pgIFz94BeqUja1nPkk7LiCq7aeN6FgSMxMAs6Ubb1f+PTDoSi7id33KOj/4vg5etHRRr8O7iPNKfl/IunEwijkL2ib2yHkm8DjZyXCwagwig3gn0kptRvy5/89ct4YivNpcbr11A0/l1OjmZuNxu1eHH+E6eeZWIaAnE8PiUzrlXRlFvqvOsGiecHd+KetWUN2FEAc9X0QAGqmnHM3/tmT2qGAC8zrboEaial5e+jB2vd20Gf4O+amVawhd9IAdWH
 Fu5McLYK
 YhCg5iCuPCOwbUWJSfIabLmiTIUudSFoBEE8O91dwH7b0GvVi6bvWEdAu+PH3XxA/bIhCf5v5drdsOCY6lAi6uB6twmRT1v+I0HL/h0Y8YyQJN71QbQtzK1x58NCQ0/DZpRM7Hl0fF7wDfYvsHOxWAiA13atRupCHPM60IyJw6MjaEOB+7hYAAGHfQK40D9QtlvS9C8J2CPCGLLg0Q7Rq/BVtMlxSxjeAjuf67+3kVUDbP4jq3hPVrSEsuHQOi0Gyp8rhWF4ZP69NlBqEEOLGwIauOvLI+eBtOGvBTYxLn+4L4RTwLW/G+Dn+snnNSfujtjn5OSUXk+QnQPWC2AQypygfR+KJtwwfxWsZe4k79CtT2+mvJkyr1A6DH0cKhaQBOLEWJJlsXpVoYkBBBaPCoPIe3BVmn3lb0PBbJ6j1g3dn9U65jTwUA7AP+tqHiYL3aLl/jBuWQz7BUf29m3HmDsWJ87xXLfQ7SOilP0MFJuLAj289UCyAj2qHwlrozIdQO8kYl1/PLsB0Uy78Z9JyyAtbCnhCaOTla7sQyL3G4lxI1OQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Surplus hugetlb folios are accounted per node, but reservations are
global. When free_huge_folio() frees a hugetlb folio whose node doesn't
have any surplus folios, we currently keep it as a free hugetlb folio.

However, we might then have surplus folios on other nodes that are no
longer required for the global reservations.

This can be reproduced with two NUMA nodes, nr_hugepages=1 on node 0 and
nr_overcommit_hugepages=1:

 (1) Allocate the single hugetlb folio on node 0 from the pool.
 (2) With MPOL_BIND to node 1, mmap(MAP_SHARED) a hugetlb memfd that
     needs a single folio. This will reserve + allocate a surplus folio
     on node 1.
 (3) Free the folio from (1).
 (4) With MPOL_BIND to node 0, fault in the folio of the memfd, which
     consumes the reservation and allocates node 0's free folio, and
     immediately punch a hole, freeing the folio without restoring the
     reservation. Node 0 has no surplus folios, so the folio is kept.

The pool ends up with a free surplus folio on node 1 that nobody
reserved:

  HugePages_Total:       2
  HugePages_Free:        2
  HugePages_Rsvd:        0
  HugePages_Surp:        1

Let's fix it by freeing a surplus folio of another node when
free_huge_folio() keeps a folio whose node has no surplus folios, using
the same rule as for the folio's own node: the free folios cover all
reservations without it.

With this fix, the surplus folio is already freed in (3), as the two
free folios then exceed the single reservation, and we correctly end up
with a single free folio on node 0 and no surplus folios.

Note that the freed surplus folio might have been required by a task
that was bound to that node. But we don't care about that: reservations
are inherently not NUMA aware, and anybody who needs guarantees on
specific nodes has to preallocate, like QEMU does, for example.

This has low urgency.

Fixes: 7893d1d505d5 ("hugetlb: Try to grow hugetlb pool for MAP_PRIVATE mappings")
Cc: <stable@vger.kernel.org>
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 31 +++++++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c67f9bc3fa3bc..0f3db932266d7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -142,6 +142,8 @@ static void hugetlb_unmap_range(struct mmu_gather *tlb,
 				unsigned long end, struct folio *folio,
 				zap_flags_t zap_flags);
 static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
+static struct folio *remove_pool_hugetlb_folio(struct hstate *h,
+		nodemask_t *nodes_allowed, bool acct_surplus);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -1760,6 +1762,7 @@ void free_huge_folio(struct folio *folio)
 	struct hstate *h = folio_hstate(folio);
 	int nid = folio_nid(folio);
 	struct hugepage_subpool *spool = hugetlb_folio_subpool(folio);
+	struct folio *surplus_folio = NULL;
 	bool restore_reserve;
 	unsigned long flags;
 
@@ -1808,19 +1811,35 @@ void free_huge_folio(struct folio *folio)
 		folio_clear_hugetlb_temporary(folio);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
+		return;
 	} else if (h->surplus_huge_pages_node[nid] &&
 		   h->free_huge_pages >= h->resv_huge_pages) {
 		/* Free this surplus folio that is not required globally. */
 		remove_hugetlb_folio(h, folio, true);
 		spin_unlock_irqrestore(&hugetlb_lock, flags);
 		update_and_free_hugetlb_folio(h, folio, true);
-	} else {
-		mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
-				    -(long)pages_per_huge_page(h));
-		arch_clear_hugetlb_flags(folio);
-		enqueue_hugetlb_folio(h, folio);
-		spin_unlock_irqrestore(&hugetlb_lock, flags);
+		return;
 	}
+
+	mod_node_page_state(folio_pgdat(folio), NR_HUGETLB,
+			    -(long)pages_per_huge_page(h));
+	arch_clear_hugetlb_flags(folio);
+	enqueue_hugetlb_folio(h, folio);
+
+	/*
+	 * This is not a surplus folio on this node, but we might have surplus
+	 * folios on other nodes that are no longer required, as reservations
+	 * are global and surplus folios are per node. So free another folio
+	 * instead.
+	 */
+	if (h->surplus_huge_pages &&
+	    h->free_huge_pages > h->resv_huge_pages)
+		surplus_folio = remove_pool_hugetlb_folio(h, &node_states[N_MEMORY],
+							  /* acct_surplus= */ true);
+	spin_unlock_irqrestore(&hugetlb_lock, flags);
+	/* We might be in atomic context, but freeing might need vmemmap pages. */
+	if (surplus_folio)
+		update_and_free_hugetlb_folio(h, surplus_folio, true);
 }
 
 /*

-- 
2.56.1


