Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9BB8F606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lxeF63YQ
Received: by kanga.kvack.org (Postfix)
	id ADC856B05EF; Thu, 29 Oct 2026 16:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB3D06B05F0; Thu, 29 Oct 2026 16:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAAB6B05F1; Thu, 29 Oct 2026 16:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71B376B05EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:43:22 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 00AB6804C1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:43:21 +0000 (UTC)
X-FDA: 85376839044.16.A2446ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4BA5DA000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:43:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lxeF63YQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yQnqLaEhsJZDZQiQXLxV9X+lF54eRYn7Ww6geWf1QZw=;
	b=Q5XX3CXCHKnKhJCEqDxAYLkTA4EwQpyQn3Q6QAInAeooqq/3mjd5Ai0rfHf5L4PQDMeyX6
	+xnpro8EKC9Znsx+UjgT/ut10+5rJ4XSaSnl2AolU4GpsbvS7i7zLRPZwtK86oqgekzHwB
	JlIXEgD0oVnKDcu2PfGSKZlAGIr2fWA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lxeF63YQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306600;
	b=PFzm8Y7EWBVCre1YYotzR4UmAT+E04VP0WvLdcWkZRqlvGktnX2pxxI5uB/YJs7YanF6Wy
	g05FPR29dGPUdEt3wKuvg5sNNi3p3Lm4BBmFvDScIFFmx57k7x/Q9G+/AAORVOFVUkc+c4
	XII2ya4DbELapqI3AZxHVz6KzsvL8iA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D0AEA600DA;
	Thu, 29 Oct 2026 20:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243251F01816;
	Thu, 29 Oct 2026 20:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306599;
	bh=yQnqLaEhsJZDZQiQXLxV9X+lF54eRYn7Ww6geWf1QZw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lxeF63YQFJJ/+XQ1nKhqIj0w0bilMMDyUEqz6TAJmSfD4k1gY2szSiICglDwDHga6
	 VIiOBv00CLMPJJ+o6rva1soNmT+ykIjzUf577nQbaOGc9An7nSRhke1U4NTx+4scdq
	 b8sKytj+/S3XoeL/oRoAEBIa5MHsZaSbq5G0FBLZecxAdpTkhTMGik1bT6p0rr2KEP
	 04HE5nXsIqQ0tw+lwb7wjhObeN2E7nsrhgYUwr9xbYZwtD7RoCjxHJCezR+jdFTgbw
	 eu7TE8Q3HQh25zZ+90tK5nrxcqL8piZpV5vwZvHzg4lcE8Fo09OIMp7yCBjVLt1wkq
	 xzz859cxecnXA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:35 +0100
Subject: [PATCH v2 40/47] mm/ksm: fix use of a freed anon_vma at swap-in
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261029-fixes_core-v2-40-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=5952; i=david@kernel.org;
 h=from:subject:message-id; bh=kkxSpuAzd3ayVbIamzbiuyVrNHFCuPg3p8/sm8anyic=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+1kabPS4ml+lj7Zefdyh2rD4jurrQobvDpzfjOce
 zTXZM6UjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZyfSrDPzMRQzGRA8u8ZjF/
 WmbRKPdcT/fU73K5m+dnqBxiMnPo2svwV8zj5YI7hxvPbIu5XXrqyp0FW9y4VzGltzLsX+5l9ly
 UkQUA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4BA5DA000A
X-Stat-Signature: bm6pk6pd6bpai6aukxfd39banucu4zio
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306600-565173
X-HE-Meta: U2FsdGVkX1+FutHyYo730lbRc3QDweO73kESM7Bh+w7t0vmC/fYl3d7QNIgY7CXp2tpLZurSs4Fk7D1fBNJzwbPGxMODKvd+o7vnNOiKaKT72W/YYQzVMd0/eDSYuSpdJGqnGpEbr0tCud0kAxjUy/+Jx/+ItNBLBJ60yJIJ5tXacuJZ0e7Q9HFT5lXUJVFz1dH+f0iXigO5eNgsnnZFIJ7WtfYMOzP80gck2s0nmb9pAY0Lu/2u3NEddEDWjDOKQxgO/6E9cwfiPqBSrOd0/cQwrbZ/koT6oRL9sez1cl4PoHsUFBJLtORKkI0HrUjsidGimKdeSkTeBXqn/DtsC2qk3EzFsU4jeajxEZWZzgWzFEyV+KKHnWK4ryRRHoOA8WYpZ2HgCp06dGrcS8UuqtwnJUD2BxVxhEmu+if+KaLl5Cs5VFIofuowbKGxnugRAqy8RzoBc9VQWI6GZAv+q6vHSxf2skLJj4qOu8jE5sawGpS7zXVPUlbf8fJukBfzjPipVVQ73HBRzzkXPQm5D3lr5cJBVe4vQ7+HGea+gOapUzoLN0hkOVS9cEEMYW3ulmfiKso45jHSIPY2Q0A2bFq5r8FBoI6DXKoQbPgBSoxBKv5eU9Y/m6KZCVYuG71I7lMc2CfeL6GJI+cK/TZOUZlTH+o0V8CqeykOK0qmhAhHv3HCGL4eZnibJE4QiXp1cIHX7R3ddkopCxFiGpwaMZsPwNZY/4kaYBBDdAVxIRGlHlnS/yLin/Z9caqtqd2y+QEjRVU+2yu0BBgEXH+Y7Rkrh9QXi5+ewCvQFa70wbJgqx1vurMGwemInMy4jutpkUbdwg0buuF3zfxMDJKqJ3vLH7qZYuipXiV80gOtQbgwdRx1C5LQzTbjMRYsF80p8PR+3raei5HKO2dV6ZTSgOEt3aHEfaMZvBjTlZbUvtD6ChkA+aHED/FbjwIlayDdQYHIELrg981sivG0dPO
 qkkXOFtQ
 RWb/0H+Eujg0qyDsUL+2aCmNIavQtS85G4/9hA+B/sln4HvIOqCYM2a2AiOX9/ia88u0/Ev/l6zt7WASJe8rZrCmb8j4Sbt7DnG178rFAnNYJmoloG5vI2EmyoRZYATSV7R31str9m7GgpefQGUw/Yn5Z+Wa5g72yi8wzr+o4SxmMQIFAzegLVEiZiROuZGcaivaUuWuiPqOBpnQqOB5LQ83MsHTP+njSv11NUjdqHsBicWTxPs8DEm+lRUI3lPW+niFZ+zEoaTOR7W/kAK74Ky/eu7PjNCLvRMbZoIK30IWp4CqCmnp7RKlG9XsHVGIyuIVH7JKSLCDqIZIYV63/+zkiH4TBRKBtHkr1KGfPFU7mXAm4TdvGhaVpc2WHy/RLmgOraTMq2YQt1nk=
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
index 9c51925825cb..e050b1bdf810 100644
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
index 8acfe2148ba5..80f6c714844f 100644
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


