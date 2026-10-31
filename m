Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5EDD8606A31E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OuJTn2CD
Received: by kanga.kvack.org (Postfix)
	id 8894C6B05BC; Sat, 31 Oct 2026 05:45:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A706B05D4; Sat, 31 Oct 2026 05:45:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 729C46B05D5; Sat, 31 Oct 2026 05:45:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D5F96B05BC
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:45:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC2CA1408B9
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:45:13 +0000 (UTC)
X-FDA: 85382438106.13.CC1802D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 23C7B100005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:45:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OuJTn2CD;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439912;
	b=faVxsE/DagjJoQpyyGn9dC2UvyHrk/Hw1IKljUhPlksyBPsbSTqnooWcpAzGMhuA27PtGN
	h5KuIHB6nW6Q7cxgo6vJMb/KTYUcbDhxtUxZpUfu6P6hGbJCaMxR5hlQGhOpWTrBtx/N48
	3ND6j1EQucnzJB4sXhxwyhXjvJmz9dM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OuJTn2CD;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgdswAlJ0tHrgdwu7xvdEotoJ4wfivizA8ZmpyMq/2w=;
	b=OqLJaQLQAKcjEz9fUOm+WdaRtm7JiVm/3vS3epu+Imo1nu/A9M8ohC7FKenf/oVg2MBtWg
	flhuh8eI8cLII2KpIA5OJIRJ2p4RJ3x5imRP+Rew82RrQiTdqhcv3FuVrrqKSTgG3s/RAH
	PBr0vyXiSRDdvKtEWx4rn1MiS2U2HBU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9E002600DA;
	Sat, 31 Oct 2026 09:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4351F00919;
	Sat, 31 Oct 2026 09:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439911;
	bh=pgdswAlJ0tHrgdwu7xvdEotoJ4wfivizA8ZmpyMq/2w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OuJTn2CDjkl/uIunKqHqMrRV00wX4O0o6oCMdWE9SY/BSDh/8zK6CFbafNYsWX3lh
	 Shr49y/05lbGdr26yIwqOrJ9MqkGi5jE9gI5Ghw9JU2zWQj7vKFsV4KqIBDUD++cdB
	 /+eT0L2pCCZHRoP/cFbj78tWpFoNeHoBXE8SLEsoOuWBfj3at07+hhSnqV+ugYvF3y
	 Kp5Qzc4oIRFJOCiQLf31cSKVfmv2r0a8R5GBvUmnuAbO6YCZePXCPPe+ZHSxz3RPX8
	 JN4lFv6aC4cOokc2Ii9d0yUZNMzdoAGLV0A6bc2LVPDtt/qISQhJ7YzYmbL/VKLPj6
	 W/2MeEvW/oU3w==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:48 +0100
Subject: [PATCH v3 19/47] mm/gup: recheck the PUD under PTL in
 follow_pud_mask()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-19-d6437171ecc3@kernel.org>
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3852; i=david@kernel.org;
 h=from:subject:message-id; bh=T72hxHsP6c9yHdsWHqOEwt8fC5kOdXgBHBMzKN7/ZJo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk8vsLBP+Hq6ev6Ud+VsBTvXz2TlufK5LtSo0XnV5
 nUGi85P6ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiu+IYGZ6VbvAuUKxW5zmw
 uC0la4pMZ5yxfmP1+4u7dq2daTCNJ5Xhn4px0+z2pZYnJt/QKFu3PtW2qXmy1fFTeo7t3AlLr5z
 g5AAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 23C7B100005
X-Stat-Signature: gacsdg1tg5fw5awdof1gdx8pco6r34uk
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439911-218624
X-HE-Meta: U2FsdGVkX1+VmvQqR5o3h4ESvpjcvqFkRpukrEiLviKenTmrU+tsTi+X4PF863JrrX7oB70wKpHyqulhKYicgpJGFaz4e4Db9soAy9t9QKg/fqgQ/njho0Al/amXubthuA48Fz+WjTbJ7gXpSCjoumBfPU4oSHxom68ETR3bjZh8cC0LZqW2i2My4BTRJCP3EZ7ihhg+0NDPqa3+FW6JJwlVstVumENbke/tfI0HI4dKsOwIoxa8ru54LeGxEfM/z6l3TreQSVU42Bg7HVzG5DGBxHV/BvPIMrJNNT8VisY+i7iw0Su5A2PIk2ez1aWrVkr3rfavWFOdtbqDx7vyTW42VlZ8txuVkY3qAqDmurShhKNMQybxs2/Ufn7QjXNASLap471A4NnKyJoWtPZpqCaYBqvSUIQ5f9SAvX+YaWdUOxSd65Pg447o/I23YXydSv6/Q0QezvyyTmU92TvFiq2exXEXE/tPhkN0cr9oUxX2l3GgcrLZqa9Y+jKf1IuIkBuJG0OK0faM55zP5g3D9HDhe4eQojj9OaZxw0eJzWXiHji66wQZ63vQmDw2TK8yx3pqH/5kcibNKi7AqUZ6OyqAfamC/dGk/5lLGtIRDiVq3a8QTG6jqLFNAQskUc5KTvMbK3p4fqPYUYLVWPHzNKh0ufzRLY6NmM67fGr5usDnThRI1SuQd6IuxUgb9PD67d5ky071x0aAsWI5PY4WJx7TIbcFVTj6YO0Y1Jyxcnsi7p7HLHwoD00c2fkW52SVC7mzZ6vNrTg8TZU5jpieFGUbUGZOrATabMbU1CMDOl3uNkJULTJ6PgsqlzT2ruCMVkDOcHmySMYP0cuSCKcFu0Rgb44dfY9iS9/4EpptIDN9pIX49w+XF6DD5Gq9quirTPPFhIORR30e5HtdFu8OWXloJVQ9fcFEwkecTyhQUXkWz/kotaGxbwynZXzudT37CD+BSH1Fa21jWoETtGe
 vTkHO1zf
 OoIm88xL6FRkS2T4GjCRgZT0DPwAPvtwGO5iHjbJPLhp5lMZPts02UMUQYtgAhDeqJ1hJ3wuvQRHiaROLl/LxS0wyKBMarebiHJ9MjYmOItA/xDwSW9HVTvlZm0Ch0gEEjNDDqOYp43trEfxlTIJbfz/v6RtCAoRApK7AQVJP0Ukbi9z76zzN9S2jDVbeRyel/yIJWcDBzODF6b3/X0vZml+cC39FioCKIrKGc+JZEZhYj94plmlEcOp0WNkeCUWXtOSw5i9b1K0coGElch8D6pFHgiURnjPECXjDu+5VTslIXU/SwQlLtW66JjLNaqiFXB5OAEDTc8R5XP8WalwPWapiAzWIonr1XsOhIEAIUTrS317Vum640SHaemnjsHaePwuBXRCNWI0nvfazPDF4aRK8cehx/PAfv+E23Ew3hwyGJq1al3cpBLDAXZUi6aIWaLzUuurABEtlUYcVukQP5dcVveSZFjinvlBiA2PbTL03Gjg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_pud_mask() reads the PUD without a lock. If it is a leaf, it takes
the lock and calls follow_huge_pud(), which reads the entry again, but
only tests whether it is present.

A leaf can be zapped concurrently and a page fault can fill the empty
entry with a page table.

This currently only applies when device-dax makes use of PUD entries,
and the fault after e.g., MADV_DONTNEED would find THPs to be disabled.

That requires a sequence like

1) Fault in the PUD
2) Disable THP
3) Have GUP race against concurrent MADV_DONTNEED + refault

Which is rather unlikely to happen in practice, which is why we never
received a report about such a problem.

Before commit 1b1676180246 ("mm/gup: handle huge pud for
follow_pud_mask()"), we performed that check in follow_devmap_pud() by
testing for pud_devmap().

Let's fix it by just structuring follow_pud_mask() similar to
follow_pmd_mask(), minus protnone stuff that does not apply and minus
FOLL_SPLIT_PMD handling. That makes it much easier to spot any such
inconsistencies.

Perform the pud_bad() check early in follow_pmd_mask() and just forward
the PUD value. We can drop the pud_present() check in follow_huge_pud(),
just like we have in follow_huge_pmd().

Even though we are performing more changes than strictly necessary, the
fix should be easy to backport.

Fixes: 1b1676180246 ("mm/gup: handle huge pud for follow_pud_mask()")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 7d43ce717b246..f809361227e7e 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -658,9 +658,6 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 
 	assert_spin_locked(pud_lockptr(mm, pudp));
 
-	if (!pud_present(pud))
-		return NULL;
-
 	if ((flags & FOLL_WRITE) &&
 	    !can_follow_write_pud(pud, pfn_to_page(pfn), vma, flags))
 		return NULL;
@@ -896,15 +893,17 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 }
 
 static struct page *follow_pmd_mask(struct vm_area_struct *vma,
-				    unsigned long address, pud_t *pudp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+		unsigned long address, pud_t *pudp, pud_t pud,
+		unsigned int flags, unsigned long *page_mask)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
 	struct page *page;
 	struct mm_struct *mm = vma->vm_mm;
 
+	if (unlikely(pud_bad(pud)))
+		return no_page_table(vma, flags, address);
+
 	pmd = pmd_offset(pudp, address);
 	pmdval = pmdp_get_lockless(pmd);
 	if (pmd_none(pmdval))
@@ -953,18 +952,23 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
-	if (pud_leaf(pud)) {
-		ptl = pud_lock(mm, pudp);
-		page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+	if (!pud_leaf(pud))
+		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask);
+
+	ptl = pud_lock(mm, pudp);
+	pud = *pudp;
+	if (unlikely(!pud_present(pud))) {
 		spin_unlock(ptl);
-		if (page)
-			return page;
 		return no_page_table(vma, flags, address);
 	}
-	if (unlikely(pud_bad(pud)))
-		return no_page_table(vma, flags, address);
+	if (unlikely(!pud_leaf(pud))) {
+		spin_unlock(ptl);
+		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask);
+	}
 
-	return follow_pmd_mask(vma, address, pudp, flags, page_mask);
+	page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+	spin_unlock(ptl);
+	return page;
 }
 
 static struct page *follow_p4d_mask(struct vm_area_struct *vma,

-- 
2.43.0


