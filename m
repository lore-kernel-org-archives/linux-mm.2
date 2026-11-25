Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FE32606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZB7LieBF
Received: by kanga.kvack.org (Postfix)
	id 5899B6B0B0C; Wed, 25 Nov 2026 17:36:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 560966B0B0D; Wed, 25 Nov 2026 17:36:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4771D6B0B0E; Wed, 25 Nov 2026 17:36:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C0D06B0B0C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:36:57 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 911481A016E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:36:56 +0000 (UTC)
X-FDA: 85475102832.07.AE9C136
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id C3CA42000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:36:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZB7LieBF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646214;
	b=Uqgnll7ZCEvICaPfAirkkq8fg93tEh9Qvd4HDG+JPAtLAtFe+aZCyHKhAAlNX0rIduN4Lp
	jbaSdIpR41+515+NdzVv46xhFD3Rokq01st+rcbL6rLwNnkho4T0PYtk8kQZVMIhl98Mqf
	3FvOLZnXoXHy6Y2jG/OfRgapVbcRIHI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646214;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9a4+ol4fW9w7mVe+P7Yw2e1ikrG/Wpcw8NzLXYIPUMo=;
	b=WxZ8S56wzv9FThs7XQjCJB7co83xr8E1AJnoDJi2gsNQvYgmMqN8mUdqcnZdTsZbrsLldf
	fbB7Ql/fmtyLvymE8Kh3OZkVpZfu3v5Q8CBbph5OzMt75LnhGsZYMYmTChDEUszQk7Rz3q
	QL82pU9V5EEI6ZZf6nAaXuehcCMzPgc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZB7LieBF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 63F1962730;
	Wed, 25 Nov 2026 22:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA00E1F000D0;
	Wed, 25 Nov 2026 22:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646213;
	bh=9a4+ol4fW9w7mVe+P7Yw2e1ikrG/Wpcw8NzLXYIPUMo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZB7LieBFBaTInE7q8GBF/FhD4n/O5DvDFl+AY/qCTN5uSEixJvYjP5O5fchcmBX0U
	 renXHHDkdnXZf7XJwlRQU6MqSY7gk2GbkvFonTHAIS7n/ZOlHmZpO45+8Tv3pwXERS
	 iFA+3PTwZIMyxkoVuyyj1TE9UpL/DAxHKpxfvH9x12A5qzJZwVt059z63Kf8EE1CiL
	 5oRMz9GPt+iPKmMGFQoGznW1OgtkViAzgo0WOJ8DtRf75uG2x5ILSHRGtrVo1S6tyf
	 fF9lefAj/pGvfVarO0RpD9Qex/Nx9JcUb4xODag2KjwLygx0gB9K3trTL7+ItnsnQJ
	 dhHkGO+zu5J7Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:11 +0100
Subject: [PATCH 13/21] mm/hugetlb: unshare PMDs of a split VMA if
 allocating its lock fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-13-db27fd2f71a8@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=6125; i=david@kernel.org;
 h=from:subject:message-id; bh=7MsnuWJ1skmmesv5nHIUCHqiHHC5JHXJq+5r6rKajHA=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1TvuT64VCrxJV+g61tcvf36leVnVvkFnE+bJ5nIN
 +ux9C72jlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZy+zkjQ3/NZOb7a+OneoVW
 685nT/hbnSrBmGTzKYY5aq7b6UXKexkZfi87HbemlsNj1325PsXQv8e/brrj/dtARqv63L+6Br6
 5XAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C3CA42000A
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: d5np8kp89cwqb19pr73jb5yf78osiswn
X-HE-Tag: 1795646214-36369
X-HE-Meta: U2FsdGVkX18Hd2fxRjk1XeMOoqV7XOBXrdb/8xRnm1k6xT+rDI4KvHv/wc5wSGHr50DLWMngK/REpWXDnYL85/0qC6bUOUQ1Ka/g60hiO7Zo2z1zyLTp+IVXkH0ILR4kKgKZR1sNhEzcJlI5ALJo9s1Zr8sRi+bpjV02HTeogvdpBLpPFLUjvqcyGIaG7TEd/gBFDMUff5bNKamgEHZhE8oqa4ZfOScvk5ZRt+M2XzxghUvgAtbNR0YczYRp1mrfk4ZuYhkNkQGx9YXH5xLriDkVnXA7M+IBv61/Vb6OiRtorMjfwHq88XZbNWIudUo4wecICsvxk2ZjFOAAbtwBfj7ht8umre2r226WHyXHZGBmEhipgJ5N+Oq8hUASOo/VI3i7v3yppTUQEnDtWOsxUoHtCpd0xJvLgrm8CrDJypFGixfz2Q9tRhxYtmWPUvRUwppDwxh6MbiFcTkd1zYNJ3rtAIKDiHQh+bQW7MuLUsWPvrjVXEyLj1mo5C1EMDU4oWtj6iIziK3+iVXJzr3LqcaZfTjLniTN74ti7gTAMpLCMzkTy475qXsIjQn000NlxadP0LLhevQPMVmjS73SuVbNm5Uv4HISY6VNYz8SPahBot/MWyDmexQRI98I5bZIrFcwH1Xn2SXgRfRxb6HjlmiYndLQ2p3vvRDndGoiLN6zh+QbG6SzvBNjlWOjegNnQ0c09qCLU8p0v6Z7aTfCWZCFI/8CFGun/t/2lgW0cpFFpisyEsllwBt7tSaszeZ2+FmLJCbws+kN3OMJpUn9o8KORxFrtmCrCzXXXjUxPPJTACcEPLIt6u01e/1pQEaQr5G3g9Z1sNZMNhhKACgHdOSD2BrcmH5IllneOXeCL24zzY9ryzOax5icn94J8iWqdqb1+nlobnCruH8+tCLCfAhC5T6Gpyqz1cBQ4LK9Jb0XIrXGJjny4870psNijeLwl7ttuPvncgyWC8T9Epk
 gWn9yOEH
 U81I3Guk7Uw3C1FwvKxaq045YEHiMcYzhd72snYh/5fRhLrLFfcT7wxlqNccMNH/omHA+YIuBsVGsDoqBDOGrYo0+Bo22zuAVEqpEvifthbAfp3NV1QAYKlufvMgO9t+nwLnTsZCUO+97BRTOJ+xKnQaQXbh8f40mquKo4ZySwJ2p4qBNKgQtdm+7h7C+NJxEO4WPK+PyET3zRgBLGg0OlhFvdz3m8KFqumyJ52JYrqhhvBLX+ghbanKaNnnoz4TkClbP73dj0KH2t+8UrpPCgwK7hvGz80tBBJf3xhDoJAfDudBbdP968WscGldtgNg7lEgjUASdYhEYpmFi8p6wPa04KuOEPElchNqeqZniYBl7/wn9rtahw3XyV1ey+uV/Q1sObN6HtzfIuZgPdygPzicbqOsVN5BYCGKF0H6pZC9HgCV/Kn9dxm7eT0krGuzmPiKn/kDqkvsx07xP1mroh/ioS0R1U25KvpCpJg4XXwdD020siCn3o7pffmXaVLz7lc8dcHlp/wyzeidXkf1XC3J65hGFGGr6XvE2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

If we split a VMA that has shared PMD page tables mapped, and allocating
the hugetlb VMA lock for the new VMA fails, a fault in the new VMA can
race with a hole punch and access page tables that were already freed.

__split_vma() calls hugetlb_vm_op_open() for the new VMA, which
allocates its hugetlb VMA lock in hugetlb_vma_lock_alloc(). If that
allocation fails, the new VMA is left without a lock.

A VMA that has shared PMD page tables needs the hugetlb VMA lock, since
the lock synchronizes huge_pmd_unshare() with concurrent page table
walks, including faults.

want_pmd_share() and page_table_shareable() prevent new sharing without
the lock, but a split leaves previously shared page tables in place for
the new VMA, and hugetlb_vm_op_open() can't currently return an error if
the allocation fails.

This can, for example, happen for an OOM victim. Then, nothing prevents
a hole punch from unsharing the page table of the new VMA while a fault
in the new VMA is still using it, and the last other sharer from freeing
it:

    fault in the new VMA             hole punch, then munmap()
    ====================             =========================
    hugetlb_vma_lock_read()
      no lock, does nothing
    huge_pte_alloc()
      pointer into shared table
    folio_zero_user()
                                     hugetlb_vma_trylock_write()
                                       no lock, returns 1
                                     huge_pmd_unshare(new VMA)
                                       pud_clear()
                                     last sharer frees the table
    huge_pte_lock()
    set_huge_pte_at()

Let's fix it by unsharing the PMD page tables of a new VMA that has no
lock. Also, exit hugetlb_split() early if the original VMA has no lock,
as it cannot have shared PMD page tables then.

This has low urgency, as it requires allocating the hugetlb VMA lock to
fail during a split, which is practically only possible for OOM victims,
and a race with a hole punch.

Fixes: 131a79b474e9 ("hugetlb: fix vma lock handling during split vma and range unmapping")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: return early if the original VMA has no lock, adjust comment
  and description ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/hugetlb.h           |  6 ++++--
 mm/hugetlb.c                      | 17 ++++++++++++++++-
 mm/vma.c                          |  2 +-
 tools/testing/vma/include/stubs.h |  3 ++-
 4 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 49dad5ae57512..aea18895e1459 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -274,7 +274,8 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
 		unsigned long cp_flags);
 void hugetlb_unshare_all_pmds(struct vm_area_struct *vma);
 void fixup_hugetlb_reservations(struct vm_area_struct *vma);
-void hugetlb_split(struct vm_area_struct *vma, unsigned long addr);
+void hugetlb_split(struct vm_area_struct *vma, struct vm_area_struct *new,
+		unsigned long addr);
 
 unsigned int arch_hugetlb_cma_order(void);
 
@@ -457,7 +458,8 @@ static inline void fixup_hugetlb_reservations(struct vm_area_struct *vma)
 {
 }
 
-static inline void hugetlb_split(struct vm_area_struct *vma, unsigned long addr) {}
+static inline void hugetlb_split(struct vm_area_struct *vma,
+		struct vm_area_struct *new, unsigned long addr) {}
 
 #endif /* !CONFIG_HUGETLB_PAGE */
 
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 0b0f6e17b8b06..2bba0940a40d5 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4887,7 +4887,8 @@ static int hugetlb_vm_op_split(struct vm_area_struct *vma, unsigned long addr)
 	return 0;
 }
 
-void hugetlb_split(struct vm_area_struct *vma, unsigned long addr)
+void hugetlb_split(struct vm_area_struct *vma, struct vm_area_struct *new,
+		unsigned long addr)
 {
 	/*
 	 * PMD sharing is only possible for PUD_SIZE-aligned address ranges
@@ -4898,8 +4899,13 @@ void hugetlb_split(struct vm_area_struct *vma, unsigned long addr)
 	 * walks (except hardware and gup_fast()).
 	 */
 	vma_assert_write_locked(vma);
+	vma_assert_write_locked(new);
 	i_mmap_assert_write_locked(vma->vm_file->f_mapping);
 
+	/* Shared PMDs require a hugetlb VMA lock. */
+	if (!__vma_shareable_lock(vma))
+		return;
+
 	if (addr & ~PUD_MASK) {
 		unsigned long floor = addr & PUD_MASK;
 		unsigned long ceil = floor + PUD_SIZE;
@@ -4918,6 +4924,15 @@ void hugetlb_split(struct vm_area_struct *vma, unsigned long addr)
 			hugetlb_unshare_pmds(vma, floor, ceil, /* take_locks = */ false);
 		}
 	}
+
+	/*
+	 * If we failed to allocate the hugetlb VMA lock, unshare everything
+	 * that the new VMA covers.
+	 */
+	if (!__vma_shareable_lock(new))
+		hugetlb_unshare_pmds(new, ALIGN(new->vm_start, PUD_SIZE),
+				     ALIGN_DOWN(new->vm_end, PUD_SIZE),
+				     /* take_locks = */ false);
 }
 
 static unsigned long hugetlb_vm_op_pagesize(struct vm_area_struct *vma)
diff --git a/mm/vma.c b/mm/vma.c
index c82e9306b11ac..183bfb8ba4703 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -590,7 +590,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	 */
 	vma_adjust_trans_huge(vma, vma->vm_start, addr, NULL);
 	if (vma_is_hugetlb(vma))
-		hugetlb_split(vma, addr);
+		hugetlb_split(vma, new, addr);
 
 	if (new_below) {
 		vma->vm_start = addr;
diff --git a/tools/testing/vma/include/stubs.h b/tools/testing/vma/include/stubs.h
index 9f5b8e996abf6..6ddecf587d9be 100644
--- a/tools/testing/vma/include/stubs.h
+++ b/tools/testing/vma/include/stubs.h
@@ -466,7 +466,8 @@ static inline void vma_adjust_trans_huge(struct vm_area_struct *vma,
 {
 }
 
-static inline void hugetlb_split(struct vm_area_struct *, unsigned long) {}
+static inline void hugetlb_split(struct vm_area_struct *,
+		struct vm_area_struct *, unsigned long) {}
 
 static inline bool vma_supports_mlock(const struct vm_area_struct *vma)
 {

-- 
2.56.1


