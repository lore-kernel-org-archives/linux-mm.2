Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EADAE606D810
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k8hYkPZm
Received: by kanga.kvack.org (Postfix)
	id 1BCF26B05BC; Thu,  5 Nov 2026 16:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18D006B05BD; Thu,  5 Nov 2026 16:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A2B96B05BE; Thu,  5 Nov 2026 16:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D7B6C6B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:33:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F03240C4C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:33:09 +0000 (UTC)
X-FDA: 85402366098.18.731FACF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9D11240006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:33:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k8hYkPZm;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m7GxaMyT1RDDZjvYUJ0P1FPXnvCLADlxook/8V9dsi8=;
	b=n1SZwv0FQbJEoxm517vvPzibemLSpTUBAEE2DOJ7Mmq9Aq65hiYT3QAE54dSReL3eBVUBT
	PWxFBB64iY3u9QVGHbhVlBXqyQQHV6i4VPGekTkVy7XaLRIjUSI6p2nvCPGgZxIPXu5MYX
	a9xBR01hE9g2LNFzyB57gqLeUO6wN10=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914387;
	b=EraWMUIZDuHl3L/ylKRwYTXGNS13XyuKkNNm6DEqJt22iTytKsSEWN2zWJbXx0zGc6d8aS
	0cDFiPNcuop9PUCAK4/c+QUMzVtAze5kqd2XrxowOZr0dHnYSEBSeMNEgjOhOILl/K5T8w
	htoJTIlUJMDEtpsP/HZSuDhzOpX0roE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k8hYkPZm;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D278943A33;
	Thu,  5 Nov 2026 21:33:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8151C1F008A1;
	Thu,  5 Nov 2026 21:32:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914386;
	bh=m7GxaMyT1RDDZjvYUJ0P1FPXnvCLADlxook/8V9dsi8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=k8hYkPZm2/pNrZ7EGT5yfX1hDqkfbsiN5BZQAc2alxhZN/lO2EIADVG1XZZszS2Mm
	 wPm8qPwfKSjXE8ccdOrrhF/5qV9Ihrlkg6W1gXymeRMxbacxWePAzLTmTTTV7pL/yi
	 fJMX/FMrz82+OboTjaVsB5vXJ64A96eA4XLSV/z914xzmGvQdZIPkJTL6WPxqXmqpL
	 lfF1+qnBw3S5+53BBL+/xcxy+q+sUoZjHkaps5OG2W/QOMJBWiIDxCsBg3pAvKRrJo
	 gUyWzSb/72LF5NGz71qtcXALC/C+7CGw8ijhXRkAUE0qP6azBge/ey+mLe0scRvKMF
	 2v7rVxyxRR19w==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Thu, 05 Nov 2026 21:30:56 +0000
Subject: [PATCH 05/13] mm: convert THP VMA flag tests to use vma_flags_t
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-late-2026-vma-flags-v1-5-0d3cd15ab75f@kernel.org>
References: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
In-Reply-To: <20261105-late-2026-vma-flags-v1-0-0d3cd15ab75f@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Rik van Riel <riel@surriel.com>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, 
 SJ Park <sj@kernel.org>, Rakie Kim <rakie.kim@sk.com>, 
 David Rientjes <rientjes@google.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 James Clark <james.clark@linaro.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
 John Johansen <john.johansen@canonical.com>, 
 Georgia Garcia <georgia.garcia@canonical.com>, 
 Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
 "Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
 Roberto Sassu <roberto.sassu@huawei.com>, 
 Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
 Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>, 
 =?utf-8?q?Ondrej_Mosn=C3=A1=C4=8Dek?= <omosnacek@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, 
 kvm@vger.kernel.org, damon@lists.linux.dev, 
 linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
 apparmor@lists.ubuntu.com, linux-security-module@vger.kernel.org, 
 linux-integrity@vger.kernel.org, selinux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=6667; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+McSI8JCXbJ4PzexpVY3WU43TmwTyEjeJI5zg9kZGWw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLefF0Wsdj93LoFi5b56wudeiIyh6nvw08l7tB7nce9M
 iytTp5Q7ChlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBElsQw/A+7Gvc3UvOikrbK
 yiMsMYfmH1aP43h5dkfn/AI9EdEb7DcY/gpdm7eOZdH/ewou/jEzt1+M/mz5qILXzdOpX0tL6vy
 99cwA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: n5cjtw4kmakpn8m7zar19oqbuuhfyw3x
X-Rspamd-Queue-Id: 9D11240006
X-Rspam-User: 
X-HE-Tag: 1793914387-43399
X-HE-Meta: U2FsdGVkX1/wqtGOHdNsW86XKSfy6PeqQgM4BNsBnBygr6p55ZPBV0lEcFGvo4J3f4PVsJZMs69j/m0EW1tWiczdVBSo7EbnPWtE9rjOWesQ1ZrcdX4JRJKzFERRcQkcjleYme47WILClJj/Z36ArFk+qResYa4pgpDjiDwm66vtPCJEu0LRN1P7cLxHSwTUXB70iWNCy0U7qffSr6D2gpKrwsRi8yF74bbJocvzC/a9gMdn/PJF+40UDtLCDvr7Oh6znRXubYKnyua2hjAciFECQFrig4bMf7ulo2trkpVAFKh0+rL6gZY2LI4TD5LfTUaSKPoJNZYpVd/rTD/liYn3dvXfqPv0WwERGJS3kPPXsqXRVh+AUFLM/1fZaLi+ii1qL65rd5yzAk3pbeOacoeYEHxZVc4NGNVKsk1QYjU6gopLMQ14sBlnnYCPOA90MYk1FujwvTqdeNiFCTwWj7WEAleqTKnhC5FN10iGyIM8Qq3zTRuQvHXHj2VYJVsu5grzCHayp3Pk6kpJ81IFoJjB0JhguhoyOKFKseqzn9OFa/NpAGTuS9qUKm0p9OkWuqxgaIvAK8u8EgpermOV6gOkoVcs9BXuAJS/MOAr/AlHflDG+2fsmnq32QBUxqCxefP+II6AKLQhsyCpKObbdz8Ni7HOVRTGAXAfoRx4h33Do57xSGRmb2gUm5awbXjMRhoj3Urubsc4i3nww0Zp/NSg34z/P1qoVnCpFYQt/SMXj16kVXhzaPyxQyR232UrL+9UxleA/v4YyDBthJO9/L1tg9G91UNyC+tpXYVquCpRzcPWD1CQdw7Q5VyiLKkNsfnvyUOZy7iNmDbfWA0zcokCj/wB7TdeFX3ScWMTcrVr/cNvCxaevYU9TYR9N7VurR4IFWv/2Dv8ZK9Wsx0Fzjs07JHfqa0bYsbwP9RubAzB1al49kSdiUQl4DskLmMtW2bp3blucCd/NFYrl96
 Yhqkmb4/
 3d32VqzNmQX77TKMV0quG5HAuNY0sB6nZwa0fpZxklBowHqoCh89jOTupWxTVJEtPPH33McWnybTS0hm3yLrEDw0bvF8WUYdQNuz6QgUdLdLLduIDhq6wlt3dCsyDV+n6Onec8hnztV4mVNvFuEx+z2pcp+9obIz0p070u/n7HPwpg9uU3lJg0Ht4A9CL/SUcvjntQUzLxOPtVbolPRGjm8gaK3LrCSa8clWa44wF4ZD0H+We/EhGMtztnNY4OKTlHag2C8daHnCMdlWUTUDbS0WdcF7F/5GY73nT2iF0W+/WYg/Bz+qvdC4/VSOHNs9pLcWfnrLlvI3QB5tOii+MFwbYgsh0/nZy7DZKAn0j5ZzWVISiMek5W4ODuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Replace use of the legacy vm_flags_t flags with vma_flags_t values where
VMA flags are tested directly in the THP and khugepaged logic.

The thp_vma_allowable_orders() family of functions, hugepage_madvise() and
khugepaged_enter_vma() continue to take legacy flags for the time being.

Also update BUG_ON()'s to VM_WARN_ON_ONCE() while here.

No functional change intended.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/huge_memory.c | 32 ++++++++++++++++----------------
 mm/khugepaged.c  |  8 +++++---
 2 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7e589a2fb02d..764e693b422f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1257,7 +1257,7 @@ __setup("thp_anon=", setup_thp_anon);
 
 pmd_t maybe_pmd_mkwrite(pmd_t pmd, struct vm_area_struct *vma)
 {
-	if (likely(vma->vm_flags & VM_WRITE))
+	if (likely(vma_test(vma, VMA_WRITE_BIT)))
 		pmd = pmd_mkwrite(pmd, vma);
 	return pmd;
 }
@@ -1517,7 +1517,7 @@ vm_fault_t do_huge_pmd_device_private(struct vm_fault *vmf)
  */
 gfp_t vma_thp_gfp_mask(struct vm_area_struct *vma)
 {
-	const bool vma_madvised = vma && (vma->vm_flags & VM_HUGEPAGE);
+	const bool vma_madvised = vma && vma_test(vma, VMA_HUGEPAGE_BIT);
 
 	/* Always do synchronous compaction */
 	if (test_bit(TRANSPARENT_HUGEPAGE_DEFRAG_DIRECT_FLAG, &transparent_hugepage_flags))
@@ -1716,10 +1716,9 @@ vm_fault_t vmf_insert_pfn_pmd(struct vm_fault *vmf, unsigned long pfn,
 	 * but we need to be consistent with PTEs and architectures that
 	 * can't support a 'special' bit.
 	 */
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
-	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
-						(VM_PFNMAP|VM_MIXEDMAP));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
+	VM_WARN_ON_ONCE(!vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT));
+	VM_WARN_ON_ONCE(vma_test_all(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT));
+	VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT) && vma_is_cow_mapping(vma));
 
 	if (unlikely(is_huge_zero_pfn(pfn)))
 		return VM_FAULT_SIGBUS;
@@ -1750,7 +1749,7 @@ EXPORT_SYMBOL_GPL(vmf_insert_folio_pmd);
 #ifdef CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD
 static pud_t maybe_pud_mkwrite(pud_t pud, struct vm_area_struct *vma)
 {
-	if (likely(vma->vm_flags & VM_WRITE))
+	if (likely(vma_test(vma, VMA_WRITE_BIT)))
 		pud = pud_mkwrite(pud);
 	return pud;
 }
@@ -1827,10 +1826,9 @@ vm_fault_t vmf_insert_pfn_pud(struct vm_fault *vmf, unsigned long pfn,
 	 * but we need to be consistent with PTEs and architectures that
 	 * can't support a 'special' bit.
 	 */
-	BUG_ON(!(vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)));
-	BUG_ON((vma->vm_flags & (VM_PFNMAP|VM_MIXEDMAP)) ==
-						(VM_PFNMAP|VM_MIXEDMAP));
-	BUG_ON((vma->vm_flags & VM_PFNMAP) && vma_is_cow_mapping(vma));
+	VM_WARN_ON_ONCE(!vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT));
+	VM_WARN_ON_ONCE(vma_test_all(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT));
+	VM_WARN_ON_ONCE(vma_test(vma, VMA_PFNMAP_BIT) && vma_is_cow_mapping(vma));
 
 	pfnmap_setup_cachemode_pfn(pfn, &pgprot);
 
@@ -2262,7 +2260,7 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 {
 	struct page *page;
 
-	if (WARN_ON_ONCE(!(vma->vm_flags & VM_WRITE)))
+	if (WARN_ON_ONCE(!vma_test(vma, VMA_WRITE_BIT)))
 		return false;
 
 	/* Don't touch entries that are not even readable (NUMA hinting). */
@@ -2277,7 +2275,7 @@ static inline bool can_change_pmd_writable(struct vm_area_struct *vma,
 	if (userfaultfd_huge_pmd_wp(vma, pmd))
 		return false;
 
-	if (!(vma->vm_flags & VM_SHARED)) {
+	if (!vma_test(vma, VMA_SHARED_BIT)) {
 		/* See can_change_pte_writable(). */
 		page = vm_normal_page_pmd(vma, addr, pmd);
 		return page && PageAnon(page) && PageAnonExclusive(page);
@@ -3568,7 +3566,8 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 
 	if (pmd_dirty(orig_pmd))
 		folio_set_dirty(folio);
-	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+	if (folio_test_dirty(folio) &&
+	    !vma_test_single_mask(vma, VMA_DROPPABLE)) {
 		folio_set_swapbacked(folio);
 		return false;
 	}
@@ -3600,7 +3599,8 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 	 */
 	if (pmd_dirty(orig_pmd))
 		folio_set_dirty(folio);
-	if (folio_test_dirty(folio) && !(vma->vm_flags & VM_DROPPABLE)) {
+	if (folio_test_dirty(folio) &&
+	    !vma_test_single_mask(vma, VMA_DROPPABLE)) {
 		folio_set_swapbacked(folio);
 		set_pmd_at(mm, addr, pmdp, orig_pmd);
 		return false;
@@ -3614,7 +3614,7 @@ static bool __discard_anon_folio_pmd_locked(struct vm_area_struct *vma,
 	folio_remove_rmap_pmd(folio, pmd_page(orig_pmd), vma);
 	zap_deposited_table(mm, pmdp);
 	add_mm_counter(mm, MM_ANONPAGES, -HPAGE_PMD_NR);
-	if (vma->vm_flags & VM_LOCKED)
+	if (vma_test(vma, VMA_LOCKED_BIT))
 		mlock_drain_local();
 	folio_put(folio);
 
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0d3bd9e23613..a2c7c6a0768d 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -640,7 +640,8 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.anon_skip_lazyfree &&
+		    !vma_test_single_mask(vma, VMA_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			goto out;
@@ -1683,7 +1684,8 @@ static enum scan_result collapse_scan_anon(struct vm_area_struct *vma,
 		 * If the vma has the VM_DROPPABLE flag, the collapse will
 		 * preserve the lazyfree property without needing to skip.
 		 */
-		if (cc->policy.anon_skip_lazyfree && !(vma->vm_flags & VM_DROPPABLE) &&
+		if (cc->policy.anon_skip_lazyfree &&
+		    !vma_test_single_mask(vma, VMA_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
 			failed_pfn = folio_pfn(folio);
@@ -1948,7 +1950,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	 * So page lock of folio does not protect from it, so we must not drop
 	 * ptl before pgt_pmd is removed, so uffd private needs pml taken now.
 	 */
-	if (userfaultfd_armed(vma) && !(vma->vm_flags & VM_SHARED))
+	if (userfaultfd_armed(vma) && !vma_test(vma, VMA_SHARED_BIT))
 		pml = pmd_lock(mm, pmd);
 
 	start_pte = pte_offset_map_rw_nolock(mm, pmd, haddr, &pgt_pmd, &ptl);

-- 
2.56.0


