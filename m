Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F706606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yr9l+Fh+
Received: by kanga.kvack.org (Postfix)
	id 511D46B05ED; Sat, 31 Oct 2026 05:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C1D86B05EE; Sat, 31 Oct 2026 05:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 38A306B05EF; Sat, 31 Oct 2026 05:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 067886B05ED
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:50:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7FD9A1A092B
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:50:43 +0000 (UTC)
X-FDA: 85382451966.11.5EEA3ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BC5F540002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:50:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yr9l+Fh+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VYlMeH+q4hS08pWQrgQz/Zl4BVbNdljyBojnlqTTFgI=;
	b=QKlDKxaY3evkGh04QLNui6aL1MQfrQMuHYmIue4jtqna3DjCoHGcEUqGzibnhjAKXgeou7
	2KW4Ksofr7Y0xn2P8D/0kh9J5Lu0F41QLBzHayrlkqCzUvKYoPBXj2wfTzs07VocQX6djc
	OvP7m0RW1yLq8xY9KY554cbKlkVauYU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yr9l+Fh+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440241;
	b=GeR3aVLqzNgRSDz5RKalThty0+GRfWWduvn5HIHUzTiu4F8DLilMX9z7sotIGcm9Mg2T7N
	fS65pscPWWg9TqUUyC7HAki9QZqGs/lZqvECp26PRRmZYt4JGLf3n7ftlq7hvns3qmZmVT
	tnCVzjDEuP+8rpreCH2iDyGB4EtWY84=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5A3E6061D;
	Sat, 31 Oct 2026 09:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2871F00919;
	Sat, 31 Oct 2026 09:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440239;
	bh=VYlMeH+q4hS08pWQrgQz/Zl4BVbNdljyBojnlqTTFgI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Yr9l+Fh+pf6zFn9EkhXVHrqHodWFP/3jvyRpjpmBWcx8JjtCbiIuRHptcMrztZgp3
	 xz5ypGp89btb7Lor8BgzY7X0/CKKkdTUFMGeidSnO/gyReZTIInyi5ARFKjHj86Pes
	 ze2A85JCyUVEQ4GOM0lwt68V41FnOJ93sDpvP6mFyGnk3XmHptyk0lvXUYSaZiFjHJ
	 FlQy63tZOgqGXB0UpG/RhwdO5RSDdOXQhV8W3HuH9kozLXUjiXDamnKUb9VYrLFENM
	 sEoydXOLV8Kh5t01uIGtMTcZFGXBtZkCQf9yZSiJk0Y8cuSUJAc27B0uRp1qrMh7nJ
	 ZMUkvrp9l3rEQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:09 +0100
Subject: [PATCH v3 40/47] mm/ksm: fix use of a freed anon_vma at swap-in
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261031-fixes_core-v3-40-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
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
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6048; i=david@kernel.org;
 h=from:subject:message-id; bh=Z78lq+MMz7mlQo8hJjX2bkGO/ohrcRkdBZioXy6jyEo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs+y5Z7KpLF2su5SK0n5dKOmGweTS3+WyVX4fTz4K
 n7Snl/dHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExkRzEjw8su08kyTcXuZuZL
 v25fMWvt1cTpz7Yv92QrS9hw+uB75XhGhicP3fxORy6MWq39vPG867acZWvKv/kVh1zQfajM0R7
 PwQcA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: BC5F540002
X-Rspam-User: 
X-Stat-Signature: 7at1wt4qbzdmeqwmarkmgxo9wc74tfjk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793440241-191690
X-HE-Meta: U2FsdGVkX19+LXrLLVtFoLLEqEHFHBe9AcPJEK/JxyX7BAn4IB7/maz3OLyU2b2RINB7o+qHgI6ZwIQ2P8wEVOAtZo5b+/nHHrrRdYFCOuKH5McNphA+8UW757bJaRlbFITLCujxFrsVwxaPSQhxSjmazGvVq0mO1L1yigQjYUZxQ2zHW5ZZiY45g8QGK9XnTVlivcdGrntrdA/B2rjFt/Z8/dxtcKO8lnmpcr+zT0s/lm5k3r0016ANfJmljjXdFceStZFDqDgbM6alS+L21ENw3J9W/+s2+OAcyUSDgLJp6w8R2k2T96BGu7VRb4N+qcUh+FpVYIo8pyNj7RedBmeZgLctedd+EcZiAbtgKxLplNFLbDdwuR22g2pnO/gtn1oik0LBoYAWfsgiE4nRfzYsGW/H5WhlpJ7VtR84iPQecxjS5RyyECUT7MoyMyMDQ5vzZU0+FwyymuyoHdftI0FelwylYIOfVDkZ2oLYXcYGtZ8U+/1CJi5cGx30vlWDodLxg5wDdSjH7Bdxdec5M5Xk1t8qTiO5iQOTRsoaO/GocN4TubWRS7HzbixmGX36TktutvVvZ9BZ4tWfdE3omnJNefqHEEcKhfcLUF5h94Q1X/creUeEjcvdM6JosuH2x02cAEQDmkntT7F8QIwyDXTD2uUXCEs586m9p62EeurA5exGk4pHzK64Rd2rHk9j23PWZMYZAwJYCrYj2lWjnTfxTekmuWJEBCNYrCbpINkmpotfohm0i3DP9mpIjFpss+8GK/uw8K+QeyCava+2TSKsWhToRQjL1pYVJaUR6dV52XksvqUIG14Fqv8WYNk55Gn5dHiTbmFk2Wdo13l7y6HgV1qX68YrGgazwOc6wscsyrYl0amrMdU1NmzoHfXi08ZSKmapW/5qEla02MrlT+xyflxrZLVCHBwqPrkSKwg0fEJeWRmDvnMC2EYyIxiRkl2lJScQKXNGL6L/YNm
 miMlIhxW
 lGj9JzDO3zxZggiNJk8oCQxKmT3T0CdetmCiYRGfL4/3BHiGn2pJ+BqDRM8cMvnf5Fm8/S5kGRRwCqYkcm3eQDZyJfyJtLlcsRxyUGkk4YLmEt5shNosGeQ0xl5Zaul3TsIoyYZSyPp5yUh+TJ1ExNSXNZG80vdmq3C6BMmxUuDi/mYOBXt8/OvjDcWXOhhW91ESKGgPTgmKKVyFoVCGBN4SSpPPJtp5UPARIku/uHvvSGpKV0Hc+O7/k/yuHw2/L3UxsncIsU+uz2UkX7jcAOxOatQtIXWLibWkSSKO03Qo73W9+BcWXTsLijsN2acNMVuZFqtDCA0VeyZ+60dJ4ApT7jRq8CNE+cjqz/zVua6+Za/iie3X7Q4CPVy4sUHxmUt2A7dXfe2dmO3tHGDEBpFQTnNCaHgg+ANe/J8Wf7BskKz5xAoQao7gfLPKMw6WbaFlSEHhSIxO9esw=
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
Acked-by: Xu Xin <xu.xin@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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
index 8acfe2148ba52..80f6c714844f2 100644
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


