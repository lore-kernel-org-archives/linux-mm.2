Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A765B606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NQmtDO3o
Received: by kanga.kvack.org (Postfix)
	id 9764D6B05BB; Mon, 16 Nov 2026 13:30:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 927316B05BC; Mon, 16 Nov 2026 13:30:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8161F6B05BD; Mon, 16 Nov 2026 13:30:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DF236B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:30:24 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AE3B580275
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:23 +0000 (UTC)
X-FDA: 85441822326.28.EE83110
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3E8818000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQmtDO3o;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853822;
	b=iju0BrA1b6mqrr9VmGQuPiudlom30bMqDBLaVZh/8lW1TaSVG/G2af6F1BPaIuHpzVvsQo
	P42P4Sq8H+boPIdYD1nX9bNqIO4+uDVoR9HlzXw1AqfC3ATv/JZdRGwrT/7t5vVuglceFJ
	JuDBfQ+Wajb5kMMjeNwgJV0UNw1QldA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NQmtDO3o;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=60r2Hy1OQ6q2qCI9QU1AVO4xWJsPeUzpCHelxn0nYYw=;
	b=TMN8OGFcU82g40+mNwSbPkz/yTgrGGaZWMbvlsdsD/gt5tesJr45DGOvu+3/FXPrTPZLJK
	2RxXjwmDpM+uZvx2QdUMwKQSlADDyYyPu/EbHBHppHqrILIc1FSNoAGMbHpX9IeKg/rM5s
	ISnoF+K/ZrVJ/xTs+9/P3XtNE6+h+1s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7623C623DA;
	Mon, 16 Nov 2026 18:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FF661F000CA;
	Mon, 16 Nov 2026 18:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853821;
	bh=60r2Hy1OQ6q2qCI9QU1AVO4xWJsPeUzpCHelxn0nYYw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NQmtDO3okVfVTVHAxx36OhYItqGYKuBz6ClClwsl0Cb3+DwVkxjTZStaSMgdQ6T5+
	 8zkhIj9p8ZOOU3PVi+PUOheA+597J7D9R0tapGfp9HhniWwljHW431QfpNYHV1Hva9
	 /PD/Vs9DyLEGIdD7EAAcK+wRXa/8yxBWEbOh/uNQJqE4sjITJp5pqFhR1XZZT5H0nl
	 qnuzOpfhn6AgQviSot5KwzgO/2fMiHuqP692lgnxoVWkw+PyIDCQCNGFPaB2oRqMCc
	 5cTohRI8RiqDVb4OJW7ZJgrGdtFAxDbmRbgU6YfbmAabDt0jQhr30Z104R5yVv112/
	 Bwm9NFqOKRPXw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:25 +0100
Subject: [PATCH v2 04/15] mm/hugetlb: account temporary folios separately
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-4-4dd9e94ea9ac@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=8810; i=david@kernel.org;
 h=from:subject:message-id; bh=e9zl9SoNkFhZsZMegJuB4Uar/yJQrySYnGO4SS5tfRc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3dIz+zyMdBQSHLbtsL5Q/rxX8XVBpOS/DI7XjT8r
 LY67H6no5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgImw5zL8L/v08nP+hI52i31t
 rvefR7gt2B25dKb4+hlXhR0W7OTTzWT4X6+8eOoSs+rFlxQvs0ZOazp5+u3rz68dazcILF2cfzd
 AgxUA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: jggps9913gqwoh71phg8ct9ghu9jx4b1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E3E8818000E
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794853821-235138
X-HE-Meta: U2FsdGVkX1815fb1xLqWyxa6+om+5uL1Ie3WTZ9mhi4fiwH4anQiRANnsfpbdEBgDUE4YrgJdXPCb2G2iAZiixUKhsmr8Fh1m5H8feLtshERtp86SNCea9Xm4HBQ9IR0IRXwiq+SKHdU98Ho0ni/eDWJ/r2akn/8+jr2vku/Ldl6LxoNRc9Dv1U48u//nxyKsJrOo/rRZXA4Axfqsc/uY/qsRjSSxAtFUklh7cPxqRMK7ufjWSIZtTDuLXZIcRvTBvVL+7pFuGFlZVIIRor8Dz8z0IGFA+VovMTSsXN44ZMdiZcsmimePnkDs9EfEYEM4Ncryi+uL+/Dz3tfp8RCW/Ew6c8xmqan2P+oqfTvg/+npwscp7220DUA95vgA1MUBoGec2UhEMzOb99uyvIz1pDj7AJ0aaSfu7F61S16zU6uHKwz1lTsWZvwerIS0gitu1HS+n7Q/Bljndye/g+HNwytID9rlkd3jIwUZd2wjbolWV3fkJPGGcufosT2ZE3aO0gOJ6iUUq/MN9+3wouNZj7OiSuwGQYJQeT4rsBnuWLA2QHN9lbS4xH1NP1oVaZmcdYgV3H3aNdR7zZxiV9elySgEYwolx6yjQ/1Zoicac7F/eJuYWhmhZBDeWWDg7s/JHXU4Zq5FlBn189QisJLoEJy2mPl8yzqFyGZChY2sfv/zsKzSQ6b3++DLukD91GQWJs6gSK1ZzuO7YccVkl+WH1vO1u+DTh+yWJrvk7XQF49QaTdeJ8s7DxhRPZd1exvLVAFmV9vTFeWERcPAWSwpwpLLfhj8TUsdV1OLKZ6KoxbqfrRcdRyPNB5bRGN7tI3knSVwKZx+oCvjXjSDbAj5uEP/UW6m4ixWQy/W0AJx6hN5e9VnVO9UHEk7VGmQ9Ph63XOM/54pMA/Hr1aeGsMBzubMQpAF2Spz2TgTA7utGRSAqq+h8MEGTtXrdIRxnOWOqZvillNe/AWTIw61jz
 QfH9bzS4
 06jSfWRFgfnScSFrafU08Tf70Faiuwg6iZAmWHXaNcy/19tKnfZeuWZLFBHoTS1afU9J+TjWbZstZxisZAAxq2SezTttnRZ4cWyd/bAskdhF1wbnCVSvO647xzsjoFkqGEEGRZifH0HyOlEpPCA0nsg2c5o0JTDeF7BlnOEB1oSpfSztgWyhwZyLwTEoPmMizuTeR3KLRq5xM8x6Csnq4Qz6TeLubAixJVet8dxhIUHkrxGHi1liBP/VU0M5ppnLoDTm3hZ+8UiRnBXpVQLScepbf8for6ig2y5kUPhP6n/OonR9be3wXLliqXUjsdtteIi5aI2ru3igDP2/D3JchPne1d0ZMj4FipVQrPkmiv+MB1tOf9Re0O0JCJyOiNoqw8BYi
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
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h |  3 +++
 mm/hugetlb.c            | 65 +++++++++++++++++++++++++++++--------------------
 2 files changed, 42 insertions(+), 26 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 58f755e70e966..80ae65c7849b9 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -698,6 +698,8 @@ struct hstate {
 	unsigned long free_huge_pages;
 	unsigned long resv_huge_pages;
 	unsigned long surplus_huge_pages;
+	/* Included in nr_huge_pages; not exported separately to userspace. */
+	unsigned long temporary_huge_pages;
 	unsigned long nr_overcommit_huge_pages;
 	struct list_head hugepage_activelist;
 	struct list_head hugepage_freelists[MAX_NUMNODES];
@@ -705,6 +707,7 @@ struct hstate {
 	unsigned int nr_huge_pages_node[MAX_NUMNODES];
 	unsigned int free_huge_pages_node[MAX_NUMNODES];
 	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
+	unsigned int temporary_huge_pages_node[MAX_NUMNODES];
 	char name[HSTATE_NAME_LEN];
 };
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0b071bef226ac..d7c71025d166b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -115,7 +115,7 @@ early_param(str, func##args)
 
 /*
  * Protects updates to hugepage_freelists, hugepage_activelist, nr_huge_pages,
- * free_huge_pages, and surplus_huge_pages.
+ * free_huge_pages, surplus_huge_pages, and temporary_huge_pages.
  */
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(hugetlb_lock);
 
@@ -1341,7 +1341,13 @@ static unsigned long available_huge_pages(struct hstate *h)
 
 static unsigned long persistent_huge_pages(const struct hstate *h)
 {
-	return h->nr_huge_pages - h->surplus_huge_pages;
+	return h->nr_huge_pages - h->surplus_huge_pages - h->temporary_huge_pages;
+}
+
+static unsigned long persistent_huge_pages_node(const struct hstate *h, int nid)
+{
+	return h->nr_huge_pages_node[nid] - h->surplus_huge_pages_node[nid] -
+	       h->temporary_huge_pages_node[nid];
 }
 
 static struct folio *dequeue_hugetlb_folio(struct hstate *h, gfp_t gfp_mask,
@@ -1426,6 +1432,10 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 		h->surplus_huge_pages--;
 		h->surplus_huge_pages_node[nid]--;
 	}
+	if (folio_test_hugetlb_temporary(folio)) {
+		h->temporary_huge_pages--;
+		h->temporary_huge_pages_node[nid]--;
+	}
 
 	/*
 	 * We can only clear the hugetlb flag after allocating vmemmap
@@ -1768,9 +1778,15 @@ void free_huge_folio(struct folio *folio)
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
@@ -2117,13 +2133,6 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
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
@@ -2133,11 +2142,18 @@ static struct folio *alloc_surplus_hugetlb_folio(struct hstate *h,
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
 
@@ -2159,17 +2175,17 @@ static struct folio *alloc_migrate_hugetlb_folio(struct hstate *h, gfp_t gfp_mas
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
@@ -3761,8 +3777,7 @@ static int adjust_pool_surplus(struct hstate *h, nodemask_t *nodes_allowed,
 		}
 	} else {
 		for_each_node_mask_to_free(h, nr_nodes, node, nodes_allowed) {
-			if (h->surplus_huge_pages_node[node] <
-					h->nr_huge_pages_node[node])
+			if (persistent_huge_pages_node(h, node))
 				goto found;
 		}
 	}
@@ -3811,9 +3826,7 @@ static int set_max_huge_pages(struct hstate *h, unsigned long count, int nid,
 	if (nid != NUMA_NO_NODE) {
 		unsigned long old_count = count;
 
-		count += persistent_huge_pages(h) -
-			 (h->nr_huge_pages_node[nid] -
-			  h->surplus_huge_pages_node[nid]);
+		count += persistent_huge_pages(h) - persistent_huge_pages_node(h, nid);
 		/*
 		 * User may have specified a large count value which caused the
 		 * above calculation to overflow.  In this case, they wanted
@@ -7459,9 +7472,8 @@ void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
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
@@ -7470,13 +7482,14 @@ void move_hugetlb_state(struct folio *old_folio, struct folio *new_folio,
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
2.56.1


