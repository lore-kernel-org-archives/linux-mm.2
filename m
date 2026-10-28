Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 95D8A606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VTRwxKvl
Received: by kanga.kvack.org (Postfix)
	id A5CB66B05BB; Wed, 28 Oct 2026 16:14:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0E156B05BC; Wed, 28 Oct 2026 16:14:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC9A6B05BD; Wed, 28 Oct 2026 16:14:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 65E846B05BB
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:36 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F3E5E1A02B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:35 +0000 (UTC)
X-FDA: 85373137710.13.A3326EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2879BC0002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTRwxKvl;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218474;
	b=FMEIVfcNeEdlAd155JbffLLpG5XSnglQLYGG2RA+H3Z9Fua6XKYTBLMu8NS5hWyMj3I4vx
	QQYt0TWP9DEN9OIo6XB/xsjV4o1OgvR813FJMpvj2Ai4Di4ITeDRnA4iVM1d5YaTzNb8mS
	3wLeUETX5/whMjfF6sz9R7rEqIF7Gcc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VTRwxKvl;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/NM9XFFGSO65qxsWQ2ClcDwcNb/R+WuaFpARUDvIeT8=;
	b=E63NdynRS7XRozwcYF3LapaRwtrF7evY1+SUgWsVoxKIXnKotFcLJj3QXUrE/wqpfPKPet
	mdKHTuAVAmIpJC35D2Eu8rZJwdcg036O6SrVksFKE+DxjF+79WAEfXQrKDziuAbCMqsPlv
	s+mlm2BO57In3M/iszaslMN10bmME/Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4C52E42A18;
	Wed, 28 Oct 2026 20:14:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E00021F01825;
	Wed, 28 Oct 2026 20:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218473;
	bh=/NM9XFFGSO65qxsWQ2ClcDwcNb/R+WuaFpARUDvIeT8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VTRwxKvlDtuGNct7+ct1WzfF91occy+dZHEIHXyanlTfJ+2qXoqwbgNti68rGsrt1
	 U7fV17hTyFnZuGJJ6Z2MiBltroBzbbQLm18Gd8mjCSp8S1yQDzMKPyLo9wZP/8MR2e
	 xLJwjbWbX3gYlJMM4Pt0FG7jywafkO3NOvxGzUtABtuNynGtMEz/KiZSQCMoCeZ+Ff
	 rkz6gVr3O96wljkGVYVZSr/olkf5JfOmIy6s/NhctieKDs21n50ROG/Z55BN8BdaGv
	 5MoDeDB2/FubHkOEy6OiWIJI5xb2Im3x97ksFmWPgffdr+zJ9ZUC9m4gDFTm6ahJdY
	 nQLY7pkXYiXpQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:32 +0100
Subject: [PATCH 04/15] mm/hugetlb: account temporary folios separately
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-4-a0a033db180f@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8747; i=david@kernel.org;
 h=from:subject:message-id; bh=j5/vZkhhc7lfw42jVaGiP44VlJrSmAd3z2CLNENWPRg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZcq20erO7R+2Ky5VktiYg/Hi0YNAQkzP8XNFdc2T
 fH/+OZHRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABNpt2FkWPFm8ZwlvzcoSd+Q
 CC6KvuFzOOPz68tb9t2Q9s2Yx6uktYThn9GkwKkP+ZZX6wYuyRVP8hNj0s3uufRNfvIUqZPmaoW
 z+QA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 2879BC0002
X-Stat-Signature: u9ydcrzxyamyejpfxjcafrr6cfy31x4p
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793218473-513976
X-HE-Meta: U2FsdGVkX183IKz1SgTuZ0yLAA81kSvvQ052c6oyz3oEZYHVC9mekIAKzNoME8bSKfk7kdoCc/seMtR5zKQepAVAnOivewBGYdu72eGRUD3r7TubuStlAJQdyN8EbQgRlFH/0Q1T6Ru5BILQhGVZHyz5Cy5fxrl2ML1DVPRqdEukhfn8HIfTuoRfIe2EYPKf1lIAZJk03UCGo9hld0moxxRYi7RwnkQqm2mGHycV488NuZ+c9pCVEvkOkCHU1rNwEXVSq/K2TdCx97E7fWopq1QybWcgSWyJj4Bg38Z0G05+o3geAebSRMGmSd+in06P7mcDuFRBHDWiZxVlDszwa35KNWUo0my8R41Dda0MOF0lWfy4IuM171psG2zpfW6mm+8LtIPExTNWZ130RcXEtXanLAcx4iwYYo/e11+JxJ2goeIrZTEipr94uim1u0GAS3WFSvzKVtB5GXW2PFQNcIgd//HY6q33SHjhbaSDhCrXxaoe3cMDk/8N9BZl4LEo0KduvdXwX5J5ggL1wr9Peh1UHpkW31FFpCyF8sQhaJTJQAq1bVIyEpqxpOnPGnx0vspbsjs5TzbEey6UJJce6BZ/ufWc8gUX6evTu/ng4zx2M0jnp82SLkwQ6aglavgApZVJspSB4psSFjdcjGe95Vu8w01MfMYDGsmFJRSdFetUw+dWCYdxZYhI1Bi7oeZbRE71SJzPwPBiQM5iDNKfguvsP6IlOKW5omWefA0N3FWkqyHwU5gK6VfmCFwlDEqydUAxe/D3f6dimd7JpMN1sHqxQ2eY/abC+8CrpYIHkMKm73hn+r9YVeHDMYX9th9FvP0mVf7eC9lJ+59LlceXZYPPmgRu0aJTSIRLkziCfyg4cNjO8NS3J9RzYDoiFNQkaFc0mVdy+8nLsAaJMEddJEPehuF8FNnIpOGlPINcDuCn1zByh0y0P1aEYE55YoZE9hOsUSuGHggocGF1yUx
 832ohnnZ
 E14byko75sPP78iYMG93F3a+t1b2Wi82cgGvVw6YGkQ9RMSXZf9IUd7m+Zovo9uiTnWmFqXfDQ8B3Gmybgr5C0wmPM7+7zv+GuLYY063Jy1/2f9Sap5KDl8TCf+nKU690B5KpMZ+7eQ3v5uCg252GziddmsF9ZZ7E28Yl7vg8mWIKrqvdFdaCl+e5ztrBGXe+zpqRuBQ8sdj6BHGYyw5azrjD1Pt0ZGg/lOufsTDQqUUMCDh1OTWxvDR0ykt+YHgK1KLww3xZtxhMP6eI0Ij3Dvp1Q5Noldk3LczUnDoyO1/IEgQ3Hs2/TGr5BdzYuHhniZZddpkROe3y+1Cl/xsP6QMkFus/7d6vLY8FkzLyrt1VxV3W+EBYR7IinqwDR6EvH7/S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hugetlb migration might have to allocate a temporary folio through
alloc_migrate_hugetlb_folio(). Such folios are currently accounted in
"nr_huge_pages" but not in "surplus_huge_pages". persistent_huge_pages()
can mistake them as persistent huge pages, as it merely calculates the
difference.

If set_max_huge_pages() shrinks the pool at the wrong time, it will turn
hugetlb folios into surplus folios until persistent_huge_pages() returns
the desired number.

After the migration (successful or unsuccessful) either the new (temporary)
folio or the old folio gets freed: this will reduce "nr_huge_pages" but
not "surplus_huge_pages", to undo what was done when allocating a
temporary folio.

This can result in having more surplus folios than actually allocated
folios:

  HugePages_Total:       0
  HugePages_Surp:        1

From then on persistent_huge_pages() returns garbage.

To fix it, add internal temporary counters and subtract them when
calculating persistent pool sizes. Update persistent_huge_pages() and add
persistent_huge_pages_node() to make the code easier to read.

Count migration targets and rejected surplus allocations as temporary.
Transfer the per-node temporary count along with the temporary flag on
migration, such that folio freeing will always do the right thing.

Take care of calling account_new_hugetlb_folio() only after setting the
folios to be temporary.

For now, keep temporary folios in nr_huge_pages, so HugePages_Total and
Hugetlb continue to include them and overcommit accounting remains
unchanged. The new temporary counters are internal for now and are not
exported to userspace.

Fixes: ab5ac90aecf5 ("mm, hugetlb: do not rely on overcommit limit during migration")
Cc: stable@kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h |  3 +++
 mm/hugetlb.c            | 65 +++++++++++++++++++++++++++++--------------------
 2 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 5029c7241863..d49cb15d13e6 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -701,6 +701,8 @@ struct hstate {
 	unsigned long free_huge_pages;
 	unsigned long resv_huge_pages;
 	unsigned long surplus_huge_pages;
+	/* Included in nr_huge_pages; not exported separately to userspace. */
+	unsigned long temporary_huge_pages;
 	unsigned long nr_overcommit_huge_pages;
 	struct list_head hugepage_activelist;
 	struct list_head hugepage_freelists[MAX_NUMNODES];
@@ -708,6 +710,7 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
+	unsigned int temporary_huge_pages_node[MAX_NUMNODES];
 	char name[HSTATE_NAME_LEN];
 };
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index a78b2487c20c..110a5c2d9e50 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -115,7 +115,7 @@ early_param(str, func##args)
 
 /*
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
- * free_huge_pages, and surplus_huge_pages.
+ * free_huge_pages, surplus_huge_pages, and temporary_huge_pages.
  */
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(hugetlb_lock);
 
@@ -1337,7 +1337,13 @@ static unsigned long available_huge_pages(struct hstate *h)
 
 static unsigned long persistent_huge_pages(struct hstate *h)
 {
-	return h->nr_huge_pages - h->surplus_huge_pages;
+	return h->nr_huge_pages - h->surplus_huge_pages - h->temporary_huge_pages;
+}
+
+static unsigned long persistent_huge_pages_node(struct hstate *h, int nid)
+{
+	return h->nr_huge_pages_node[nid] - h->surplus_huge_pages_node[nid] -
+	       h->temporary_huge_pages_node[nid];
 }
 
 static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
@@ -1422,6 +1428,10 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 		h->surplus_huge_pages--;
 		h->surplus_huge_pages_node[nid]--;
 	}
+	if (folio_test_hugetlb_temporary(folio)) {
+		h->temporary_huge_pages--;
+		h->temporary_huge_pages_node[nid]--;
+	}
 
 	/*
 	 * We can only clear the hugetlb flag after allocating vmemmap
@@ -1764,9 +1774,15 @@ void free_huge_folio(struct folio *folio)
  */
 static void account_new_hugetlb_folio(struct hstate *h, struct folio *folio)
 {
+	const int nid = folio_nid(folio);
+
 	lockdep_assert_held(&hugetlb_lock);
 	h->nr_huge_pages++;
-	h->nr_huge_pages_node[folio_nid(folio)]++;
+	h->nr_huge_pages_node[nid]++;
+	if (folio_test_hugetlb_temporary(folio)) {
+		h->temporary_huge_pages++;
+		h->temporary_huge_pages_node[nid]++;
+	}
 }
 
 void init_new_hugetlb_folio(struct folio *folio)
@@ -2113,13 +2129,6 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 		return NULL;
 
 	spin_lock_irq(&hugetlb_lock);
-	/*
-	 * nr_huge_pages needs to be adjusted within the same lock cycle
-	 * as surplus_pages, otherwise it might confuse
-	 * persistent_huge_pages() momentarily.
-	 */
-	account_new_hugetlb_folio(h, folio);
-
 	/*
 	 * We could have raced with the pool size change.
 	 * Double check that and simply deallocate the new page
@@ -2129,11 +2138,18 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
 	 */
 	if (h->surplus_huge_pages >= h->nr_overcommit_huge_pages) {
 		folio_set_hugetlb_temporary(folio);
+		account_new_hugetlb_folio(h, folio);
 		spin_unlock_irq(&hugetlb_lock);
 		free_huge_folio(folio);
 		return NULL;
 	}
 
+	/*
+	 * nr_huge_pages needs to be adjusted within the same lock cycle
+	 * as surplus_pages, otherwise it might confuse
+	 * persistent_huge_pages() momentarily.
+	 */
+	account_new_hugetlb_folio(h, folio);
 	h->surplus_huge_pages++;
 	h->surplus_huge_pages_node[folio_nid(folio)]++;
 
@@ -2155,17 +2171,17 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
 	if (!folio)
 		return NULL;
 
+	/*
+	 * Count temporary folios separately so that pool resizing does not
+	 * mistake them for persistent pages.
+	 */
 	spin_lock_irq(&hugetlb_lock);
+	folio_set_hugetlb_temporary(folio);
 	account_new_hugetlb_folio(h, folio);
 	spin_unlock_irq(&hugetlb_lock);
 
 	/* fresh huge pages are frozen */
 	folio_ref_unfreeze(folio, 1);
-	/*
-	 * We do not account these pages as surplus because they are only
-	 * temporary and will be released properly on the last reference
-	 */
-	folio_set_hugetlb_temporary(folio);
 
 	return folio;
 }
@@ -3757,8 +3773,7 @@ static int adjust_pool_surplus(struct hstate *h, nodemask_t *nodes_allowed,
 		}
 	} else {
 		for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
-			if (h->surplus_huge_pages_node[node] <
-					h->nr_huge_pages_node[node])
+			if (persistent_huge_pages_node(h, node))
 				goto found;
 		}
 	}
@@ -3807,9 +3822,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 	if (nid != NUMA_NO_NODE) {
 		unsigned long old_count = count;
 
-		count += persistent_huge_pages(h) -
-			 (h->nr_huge_pages_node[nid] -
-			  h->surplus_huge_pages_node[nid]);
+		count += persistent_huge_pages(h) - persistent_huge_pages_node(h, nid);
 		/*
 		 * User may have specified a large count value which caused the
 		 * above calculation to overflow.  In this case, they wanted
@@ -7440,9 +7453,8 @@ void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
 	 * be final while the old one will be freed so it takes over
 	 * the temporary status.
 	 *
-	 * Also note that we have to transfer the per-node surplus state
-	 * here as well otherwise the global surplus count will not match
-	 * the per-node's.
+	 * Transfer the per-node temporary count to the old folio's node,
+	 * and any surplus count in the opposite direction.
 	 */
 	if (folio_test_hugetlb_temporary(new_folio)) {
 		int old_nid = folio_nid(old_folio);
@@ -7451,13 +7463,14 @@ void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
 		folio_set_hugetlb_temporary(old_folio);
 		folio_clear_hugetlb_temporary(new_folio);
 
-
 		/*
-		 * There is no need to transfer the per-node surplus state
-		 * when we do not cross the node.
+		 * There is no need to transfer the per-node state when we do
+		 * not cross the node.
 		 */
 		if (new_nid != old_nid) {
 			spin_lock_irq(&hugetlb_lock);
+			h->temporary_huge_pages_node[new_nid]--;
+			h->temporary_huge_pages_node[old_nid]++;
 			if (h->surplus_huge_pages_node[old_nid]) {
 				h->surplus_huge_pages_node[old_nid]--;
 				h->surplus_huge_pages_node[new_nid]++;

-- 
2.43.0


