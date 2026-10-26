Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5FF606A333
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OyCW9vSO
Received: by kanga.kvack.org (Postfix)
	id 746066B05F7; Mon, 26 Oct 2026 19:30:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E126B05F8; Mon, 26 Oct 2026 19:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634536B05F9; Mon, 26 Oct 2026 19:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32B826B05F7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:30:22 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 93B39408EF
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:30:21 +0000 (UTC)
X-FDA: 85366373442.12.50D02CA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id BC730A0012
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:30:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OyCW9vSO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tgIUTZH4PgusnbQa76T2+ZJUPuByGpIjWfRmOr1XBOo=;
	b=mOasQ+hpQnt+2+oXpl6JW36sCZhKv0W3L0rkMEV/Ue8h9ZMJPWO/EC80VKR+nFxzTIfY+a
	bZT1HxuxCg7s+8xP9scchdrS7Qipqn+Orv1ya1pgGfaKDQnOcfcO+yi5obRaZrz7lGJAjn
	HkDZEsklIOpUq81uNKkVYs5U+YL7wr4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OyCW9vSO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057419;
	b=0dHkpRhVfIyPo7jKGPsexOng1HD5gCtY6hhcSPtJj8zqudsJV1KV2RkbwCpepGMIa7FjfO
	weYaWhxOaVlbHrgh28QJPzGxfs5EpouU+bhbmSNMtvDjyE6rHxp3kqnjAt8J1qd36cngso
	9yvXt/lXuvqXJSzDmbKogzqmtGi33Tk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1101342A01;
	Mon, 26 Oct 2026 23:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 533541F01825;
	Mon, 26 Oct 2026 23:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057418;
	bh=tgIUTZH4PgusnbQa76T2+ZJUPuByGpIjWfRmOr1XBOo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OyCW9vSOg8eavYxYZzEiEehRHAlr6iPe8gzG5UjieW/QKs/QXG//2w4aLNsaHbFlZ
	 zdtKtpMRREWtG8k1ti0nF1t2/gMaK9QDU8/4gdr4ROsUXKLROf+6dHW5PZJcwVP4lo
	 6bhDGzf6Le2orGv5Dtf+8j7vkgyEIPa1xCyEdTtx3bW6T3mPKk6EaDyhF91HcvsntZ
	 rLI0TL/UpNXat9KnS7av3Yv4Q49iEpy7dcorsH4TB/71IAKsxHWSm+8i/noCEd3/No
	 Nh7yI0stMIR+R+lys7a0UVmQvXbONcQON4YdXl+GBKOFETFMr7RJqihANuskNyySq1
	 1ZPZn8kK3fjng==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:59 +0100
Subject: [PATCH 39/46] mm/ksm: fix use of a freed anon_vma at swap-in
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261027-fixes_core-v1-39-6f74bec9a5bb@kernel.org>
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
 stable@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=5956; i=david@kernel.org;
 h=from:subject:message-id; bh=kHEhdZ3IVdP6/aauhoZYc6UVViKZ1syE/dbFJpqQu0E=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/xscj3+s+nHgt++GqssNiR9kxv1XyWzTdmLmDnm
 649X854QkcpC4MYB4OsmCJLUPB9g5cv19VWu/Exw8xhZQIZwsDFKQATiatlZDggHJIwb/l95lU2
 dsV/WjUfaiw8t0N4Q+ov6ecfH51z/83A8E8juOP9slMHPfxdpgY6J8eLBqY1N+2Vv3X05qq4rOR
 fj3gA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: BC730A0012
X-Stat-Signature: othxt9gech5mtntd6k6ypu9fu1aw3qc7
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793057419-958985
X-HE-Meta: U2FsdGVkX19WOvBtu7AWw9RXy71kJYR9lM9qtcwr2jorBMdnI4fHYP2Nmg5pZxuB5dqvhLbemx6CfLEyta2BMXrGKP2lh/RpeFHc1ej0GjaC3cCwAai1f/tYVjIxrrd9x8Tuf5du33xIHukJWqpObvyR1yVN0ZvuchfGumHdC2EnZCMf2e3u5MFf/EhKilpSm2fCh9psada195clxJr5KYRUq1qKusi9SmBVL+66Q7XKX5YUutBR6CCMcU+X8n9z80gQ97XUJV/P7Gzx1f33gK0f9Ic/jdBAiz/ZIbUwNa4vB9F3JYYhWo4S+DTK9xfjXLeSkZo/dkMygeL8U2sGq4siBRD76GB5y6YtSUk7DEQGmPfRWjDEOaZ69s9+pXOmLuV0FK/gMbiU7/+LyT7xi58NPzICpBKmEmU/Jb0n+BNq1dG526FryFz5fZ90OKwnH2mwGxEEflJpdVYJXSH/DDFZRq5f0u4OWnnfpzYNprqBlnxzXt053u6ib2BvEVM7SnWbdpeGrmTnL8MSxP2Jlq04aMtH+IjlEDmH4Mj0lVK3WJj1xALQwjZz/qtUT9HSydwPlgFf7k56+1vrx7oTfS/aXxR+jhkmAEOs+UNXqfaeia6eoUD0Pg4dnhIgqw0/hzbtJgMj/Us3qrD7OGUAc013igbmHU36Qu70fb8sMtjW5VEq49vWOJJp5hpmx/FHwp+KY2LckGm3hPJKM3F0uK6WJoSLElMIQZkItasn55L3e3KhyqHqEUS8PVrErAecFH9mAgpSaTIgCXAAS5q0PDm+YiovfrAUmxyPADkiDelLNTmj8WUpuIrZ+g2IuIIKXhH/mjjirRqt8eg0voBRBTDKvPg38eFU+YlecqSIsjML5akH/at388Tjzz0Lcttx3jBVWWhb4PKsIqF3eIicoTEwCXXkM8fYeOPkLPycNaG/x5PnOuCfHZhPxbiGe9hVBd6ynd11gvySxebM9CA
 t7TKVxd4
 A8epIxN1+znEoanh4qUDVw7aIy4nOA3Gr6gcgUIunqLt9eAjF4mrXhkvg63vAogmbh1QwJGGt3ENpYiL9AgLkZElQ2e3SIX8QWLORAteb5Ui2Hh/8wOOVaZZn5WTIB3vh+FLxAVE0e2lEU63W/9gJfSqDQsHhKQ+X5SaS79+1EqLY9UlYot5ErKqsy0QQIOdlmxVimp3reFFeve7y5Tq1os/kCSeQFeMp20cs2z2RPoNbzj6RfADLIcris+Jae1s0xUxhz7uaT9SKMJ2JqPmwTuYogI6NyS0tF4SMtVMh1f0aQftQrEXUjJDLT8a0jTPNaF2QCFU50AYbsTfZma361tv5Ale7j2ZvLpAR/x4dU+ISuwO81696QnY406SIOioswrBIvlmAqu0LKa4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A folio read from a swap slot previously shared by KSM can remain in the
swap cache after the process that first mapped it exits. Its anon_vma
can then be freed, so ksm_might_need_to_copy() must not dereference it
to compare roots.

Doing so can result in some false-positives, resulting in the reverse
mapping missing the new folio mapping, preventing migration and reclaim.

SLAB_TYPESAFE_BY_RCU allows individual anon_vma objects to be reused
immediately after freeing. A stale pointer can then refer to another
anon_vma whose root matches, even though the target VMA is not linked
to that anon_vma.

Move the anonymous rmap compatibility checks into
folio_anon_rmap_compatible(). Keep the page-index check and compare the
folio's anon_vma pointer against the VMA's own anon_vma and root first.

If neither matches, bite the bullet and walk the VMA's anon_vma_chain.
The VMA keeps these anon_vmas alive, and finding a match guarantees that
reverse mapping can find the new mapping.

Lorenzo Stoakes says in a private discussion:

  "This isn't quite equivalent to the existing check.

  Every anon_vma in an anon_vma_chain shares the same root, but if you
  split a VMA then fork both of them like this:

                  VMA A
               /        \         <split>
            VMA B      VMA C
               \        /
        root <- anon_vma 1
               ----^ ^----        <fork>
              /   parent  \
        anon_vma 2   anon_vma 3
             |            |
           VMA D        VMA E

  VMA's D and E both get their own new
  anon_vma's such that:

  VMA D: anon_vma 2 -> anon_vma 1 -> root
  VMA E: anon_vma 3 -> anon_vma 1 -> root

  And if you found a folio referencing anon_vma 2, the existing check:

	anon_vma->root == vma->anon-vma->root

  Would be true for VMA's B, C, D & E.

  However after your change it'd be true for VMA D only, as it's the only
  one with anon_vma 2 in its anon_vma_chain.

  Whether or not that could actually happen in practice... 🙂 I don't
  know.

  [...] after your change it'd be true for VMA D only, as it's the only
  one with anon_vma 2 in its anon_vma_chain. [...] I would [...] say that
  you are making the test stricter but more correct.
"

If this affects performance when KSM was never even involved, we could
just track whether KSM ever merged anything and just skip these checks.

There isn't really a lot we can do otherwise: for mapped folios we might
be able to use folio_get_anon_vma(), but for unmapped folios there really
is no easy way to see if the anon_vma is still valid.

Document the (confusing) lifetime requirements of folio_anon_vma().

Fixes: ba6f0ff3981e ("ksm: fix ksm swapin time optimization")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/ksm.c  | 36 +++++++++++++++++++++++++++++++-----
 mm/util.c | 13 +++++++++++++
 2 files changed, 44 insertions(+), 5 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 9c51925825cbf..e050b1bdf810d 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3137,11 +3137,40 @@ void __ksm_exit(struct mm_struct *mm)
 	trace_ksm_exit(mm);
 }
 
+static bool folio_anon_rmap_compatible(const struct folio *folio,
+		struct vm_area_struct *vma, unsigned long addr)
+{
+	const struct anon_vma *anon_vma = folio_anon_vma(folio);
+	struct anon_vma_chain *avc;
+
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_large(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(folio_test_ksm(folio), folio);
+	vma_assert_stabilised(vma);
+
+	if (!anon_vma)
+		return true;
+	if (folio->index != linear_anon_page_index(vma, addr))
+		return false;
+
+	/*
+	 * Careful: anon_vma might have been freed, so we cannot safely
+	 * dereference it. Add a fast path before we walk the anon_vma chain.
+	 */
+	if (anon_vma == vma->anon_vma || anon_vma == vma->anon_vma->root)
+		return true;
+
+	list_for_each_entry(avc, &vma->anon_vma_chain, same_vma) {
+		if (avc->anon_vma == anon_vma)
+			return true;
+	}
+	return false;
+}
+
 struct folio *ksm_might_need_to_copy(struct folio *folio,
 			struct vm_area_struct *vma, unsigned long addr)
 {
 	struct page *page = folio_page(folio, 0);
-	struct anon_vma *anon_vma = folio_anon_vma(folio);
 	struct folio *new_folio;
 
 	if (folio_test_large(folio))
@@ -3151,10 +3180,7 @@ struct folio *ksm_might_need_to_copy(struct folio *folio,
 		if (folio_stable_node(folio) &&
 		    !(ksm_run & KSM_RUN_UNMERGE))
 			return folio;	/* no need to copy it */
-	} else if (!anon_vma) {
-		return folio;		/* no need to copy it */
-	} else if (folio->index == linear_anon_page_index(vma, addr) &&
-			anon_vma->root == vma->anon_vma->root) {
+	} else if (folio_anon_rmap_compatible(folio, vma, addr)) {
 		return folio;		/* still no need to copy it */
 	}
 	if (PageHWPoison(page))
diff --git a/mm/util.c b/mm/util.c
index 7f374bb8bf363..67f8fca3b2056 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -697,6 +697,19 @@ void *vcalloc_noprof(size_t n, size_t size)
 }
 EXPORT_SYMBOL(vcalloc_noprof);
 
+/**
+ * folio_anon_vma - Get a folio's raw anon_vma pointer.
+ * @folio: The folio.
+ *
+ * The returned pointer may be stale for an unmapped folio. The caller
+ * must ensure the anon_vma stays alive before dereferencing it. A folio
+ * reference or lock alone is insufficient; use folio_get_anon_vma() when
+ * the anon_vma's lifetime is not otherwise protected. Note that
+ * folio_get_anon_vma() is only useful for folios that are still mapped.
+ *
+ * Return: The raw anon_vma pointer for an anonymous, non-KSM folio, or
+ * %NULL otherwise.
+ */
 struct anon_vma *folio_anon_vma(const struct folio *folio)
 {
 	unsigned long mapping = (unsigned long)folio->mapping;

-- 
2.43.0


