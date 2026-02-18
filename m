Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B537BE9A049
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2382A6B0092; Wed, 18 Feb 2026 06:01:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20F186B0093; Wed, 18 Feb 2026 06:01:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10E586B0095; Wed, 18 Feb 2026 06:01:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E7C3E6B0092
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:01:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B303C1404E1
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:51 +0000 (UTC)
X-FDA: 84457287222.10.74FD601
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2342C140008
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wc77tLJf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771412510; a=rsa-sha256;
	cv=none;
	b=ua4jXoEbLs/1qAsbfWb1zXTnRJb/1qmk39MfxFS9RNw64GjuWEAn49n/VSbau549059tvO
	BWlJnKML72uCe7jVIERP8ozpAM8stxUZ3HGgBKZ6PKR3ErjLzFAkhWMtgPhH/giTM1Nm7j
	KSKj61Fn/slixTWNTF2el1SnjAsY5Dw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Wc77tLJf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771412510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vbbS6l4iFEaCelf5D+3OXZ6P3cRkcpO7sbQ1eI9AGKg=;
	b=whfxeAo31ljGPQi2iif8ZWAIGY/4ds0o8L94JqDYW6a4EvF0RGKzKuHeOQQa7LlNmu6GeC
	fvMS2nEDGySVLkCLpa2mdu/Z/O56qk8pb2O52LY1lU8HJNhA1Ok+QXLeRNXmvC0b2LV7xI
	mR6dmrxjuJAxpTEWNrQCNsz4ZbHgMB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id AB3CC61860;
	Wed, 18 Feb 2026 11:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B93AC19421;
	Wed, 18 Feb 2026 11:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771412509;
	bh=xq7RDHxXyG4+GP3mt0XXBfeaGjlLlK7CH6liKrYPpKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wc77tLJflHeu1sFqTJif6dGhr6t6k5UG7VUaweIZY2TWQDG1Bj0cklPW+3VdZonsP
	 Q5VAyCKnQWmATzPPm5+63qspSAHqnSKS3OWDvlU2m95uwOiFFmIqSwXo0OMnRN2J4P
	 c7ucLiaCweCZVPcwzk+pTc/BzAeDLmPfkOOluni59ugLgzaha0fyMRDpR/TcrQKrA7
	 TrV5gv6PNEteMUCXJY1090g3RmajBXFJggcPy5HQ5e43PdQK58doCV+SwcC9mCVkgb
	 mchLX62Xyy3ScxFVtApawyedkmetRmEvTMcG/xVWSDFXmUQqol1XAOQIDjyka6OAab
	 /ztSsigc7LDKQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Harry Yoo <harry.yoo@oracle.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Uschakow, Stanislav" <suschako@amazon.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15.y 4/6] mm/hugetlb: fix two comments related to huge_pmd_unshare()
Date: Wed, 18 Feb 2026 12:01:27 +0100
Message-ID: <20260218110129.41578-5-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218110129.41578-1-david@kernel.org>
References: <2026012608-tulip-moisten-c6f6@gregkh>
 <20260218110129.41578-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2342C140008
X-Stat-Signature: btz8i6z16dpk1fqftuhbij3zqg14to4y
X-HE-Tag: 1771412510-552721
X-HE-Meta: U2FsdGVkX1+2BCa4VbDxKlXOZ/bM3dct/Fxq76pXWU/5/hJu2kqCLxM7xd7stCeRaJDqWv6273XzAvWi2oK2eBRiRmv+b00My8G3cpOG4gqZF6eJxBOTKdVG2QyYNmQH7WqJBNIAWgduZby6eICXGFqKQ4pPxOGrBT3Gp6FnvbucefLeS8oGClgOkaKNyNctYh6agLiWg8A2gBYbPqbGQanlk1UzbwowY9JXfUid2wgbC4fBj2M82RvxKrUu7hZCblEiQddysFsXSQ9bV+VVzdrpx/jBI06krvVDGp/2uAfyghTHaiPp+vbD34ekpwgjusDfl6iVjOaUVCmdfEP/Q+R9tNDE/UX4g6EZN6e8GTtPOgnYuelgXXs2ldaYh5a/rqVymttKc+mGZtV1OqOf28fzWnlZ+Zg0svH/FDYlz9GUlFNPvW/FPtHBD2hHvL4E7LZxs1sFhDmUs8vBCWIKzRgFs1ydvDvsYEERzhA2ItxtT4y4PcYuCzzkQzRKm0NwJFigBKXzDOErWWVXp7ez/zNrBMk8qYJQjt/SJlZX2kspEx24VnLd4YHN53G40/2YJjGup8YYHo3TDSnuZoCq3KvB4osphZ115jnWZaPAskCQxRtZspMYWXqmmcfJTzrKwp3ddAPMqKjbKuFF4F/YWNez/Tn+Rrv0PIeuNThxq1mBiA3TohSsKY1I12bwfZgj4r4qQ9L3VTHaVYyByD7dpt1kjtTaQLqB5wiTVPwmlIvRR8wj/sgISpWF/BzsjccB393YiS0dK+iTvCnY7VKaSa4tENlKlcKHdcml/dDklx2UO1Qv4EWpN8LrnM2sR9eMiAV4MtQaszdudD4w+QniDzx7h87bAtkB0v9cqsndUeafmZwNMlhC8t4tfpS5oWjurkhAFozngVNpU2Ve5+EHL+OD0Drj4P3gyp6Nsj/CNPnOAKhTd13vLOB3G9zOPvM5uMYc/YY44ODBFYfw42R
 0cOY015x
 +ZaEM+MChK6rYvl9R/nWzsKHy289cuhRiuDow+0sMq1bebLYb9H+LECLZj5A+1oJRmoAJ2mrVXACVNrYrnlM206XNqG2TZpnHY3fAumyF+oIcDRdTiKRh2hRqRwh9/KFpe/r8bKnQ4+CIDS0lMqGGuBJs+feXXQKBPg82yMf7vov2rHtv9xn2pTFDUbVZJx/BVL8WYnG4oTlnd9R48MFN2QQoMO1FkX2RqXBR7McP0LreqZ5+u2Rc7D8Zia0SttG7QLidiI6jcawjRcEW+oVPEq+NzycNSYhXX0EC7js/P3EZBWOEqW+2/BwRARIRWglZkwTS6SmhxePpSpGcK7sAy87bM6EAmnZZDKyrExmiC5M2yfm32IPiipdXV3gBWPCYzYp/3tmnRpZHHRDnU2Kq4kbpku+gb2FrUJyDrgXGEh3ggkwBnwS/dR0W4bXQQ3BPAhfZaALm9PLXK+oSWRcXimjR6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Red Hat)" <david@kernel.org>

Ever since we stopped using the page count to detect shared PMD page
tables, these comments are outdated.

The only reason we have to flush the TLB early is because once we drop the
i_mmap_rwsem, the previously shared page table could get freed (to then
get reallocated and used for other purpose).  So we really have to flush
the TLB before that could happen.

So let's simplify the comments a bit.

The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
correctly after huge_pmd_unshare") was confusing: sure it is recorded in
the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do anything.
So let's drop that comment while at it as well.

We'll centralize these comments in a single helper as we rework the code
next.

Link: https://lkml.kernel.org/r/20251223214037.580860-3-david@kernel.org
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 3937027caecb4f8251e82dd857ba1d749bb5a428)
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8268943e05eb..6780e45e5204 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4552,17 +4552,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	tlb_end_vma(tlb, vma);
 
 	/*
-	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
-	 * could defer the flush until now, since by holding i_mmap_rwsem we
-	 * guaranteed that the last refernece would not be dropped. But we must
-	 * do the flushing before we return, as otherwise i_mmap_rwsem will be
-	 * dropped and the last reference to the shared PMDs page might be
-	 * dropped as well.
-	 *
-	 * In theory we could defer the freeing of the PMD pages as well, but
-	 * huge_pmd_unshare() relies on the exact page_count for the PMD page to
-	 * detect sharing, so we cannot defer the release of the page either.
-	 * Instead, do flush now.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (force_flush)
 		tlb_flush_mmu_tlbonly(tlb);
@@ -5708,11 +5701,10 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
 		cond_resched();
 	}
 	/*
-	 * Must flush TLB before releasing i_mmap_rwsem: x86's huge_pmd_unshare
-	 * may have cleared our pud entry and done put_page on the page table:
-	 * once we release i_mmap_rwsem, another task can do the final put_page
-	 * and that page table be reused and filled with junk.  If we actually
-	 * did unshare a page of pmds, flush the range corresponding to the pud.
+	 * There is nothing protecting a previously-shared page table that we
+	 * unshared through huge_pmd_unshare() from getting freed after we
+	 * release i_mmap_rwsem, so flush the TLB now. If huge_pmd_unshare()
+	 * succeeded, flush the range corresponding to the pud.
 	 */
 	if (shared_pmd)
 		flush_hugetlb_tlb_range(vma, range.start, range.end);
-- 
2.43.0


