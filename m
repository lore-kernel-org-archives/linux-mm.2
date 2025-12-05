Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB486D374A8
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 21:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2601F6B02F6; Fri,  5 Dec 2025 16:36:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210A86B02F7; Fri,  5 Dec 2025 16:36:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126E96B02F8; Fri,  5 Dec 2025 16:36:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F32FF6B02F6
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:36:20 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5ED089679
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:36:20 +0000 (UTC)
X-FDA: 84186726120.15.032B1EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 327F640012
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:36:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oHYdEQHh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764970579; a=rsa-sha256;
	cv=none;
	b=oJcLodqOjyXO38QcXcLx2yei0mjD6ROYeg/R2BPCdyrq8fDDZGSMmlLypmHSWAxEmAtsSG
	0FzVzTx+TeclTJNQamBe+n/q0SFuiX9WR5YVUZoa0LL0KGhVeHZb9S0qIfF4XmCOxYKIqs
	I02D8HqaxJ9aWn/NGuqVu8LoWnR9DYs=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oHYdEQHh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764970579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jVC6VesUxfQp3ofv08hSHXtW0mJNQNHQwnel+r7mByE=;
	b=OW1dtVSQhiPu8I5qK7p52AmyWyj8OT25qyI1OceoucKccwMbvEXisX7vw/ZuKdB0RNUzp9
	UHWnFqfuzwXTrtNxv1uzafgea1+7DstUfR86FlbVigbvFzjzcMiq9bXNGQJ+hhvro5iIC6
	jUyzhLA/ppwjypm+8LW/P4MSgz2BF6M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BC5160156;
	Fri,  5 Dec 2025 21:36:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA95C116C6;
	Fri,  5 Dec 2025 21:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764970578;
	bh=2CZCIDkLmGunOu6Tc+ZDX2KNREuKlHY6VUGQM/n7JqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oHYdEQHhqNxtQApXBc8PMgap7tUgp4g/Vcy0n+BnyqcJe7wEsJAV3sIS99fvmxONa
	 Kr0hNpGGzEAvKWI68T7RZc/BG6wGr3UY7WxX2WpMG5LTKFaT6TdHyudu0b1fjCKhAL
	 TBsjaGlJ80FnO/XSLefeR9u1V/6j9b9U61huVbEJUGGmcM59nN1T1T1CvJ9mGFIA+E
	 AljylqjiN9c64Lfbe9F/KIz7vRQem3CUB78KusoFr4L9+gwXGALO4yWVTDUAj4vPG9
	 k2Pq5OZ9Vk8IAQrOAFZ7jJW8naPZuEdQveEZCuY0dofFaUZY/C+8iwHoTWuMAhaceY
	 Crs9nK09NQA8w==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>,
	Liu Shixin <liushixin2@huawei.com>
Subject: [PATCH v1 2/4] mm/hugetlb: fix two comments related to huge_pmd_unshare()
Date: Fri,  5 Dec 2025 22:35:56 +0100
Message-ID: <20251205213558.2980480-3-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251205213558.2980480-1-david@kernel.org>
References: <20251205213558.2980480-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 327F640012
X-Stat-Signature: j8d6z4k759j5ra5tu7b1zde46kq1zruf
X-Rspam-User: 
X-HE-Tag: 1764970579-343689
X-HE-Meta: U2FsdGVkX1/LoKKhKHr0aViwCEOAYX+IilHjayfS0cMeffD/6aOcMHGXLpk/tKAqJ2+LQ9nLDtH0jrcMSPgkMhKUk9/e81UtmXG3wEL/rpNjuw7hJPgfrar+e9YZn/IGA0jd2BCvuD/MFTOiZQN4Gfigx2fwnRw1Zimrmjqc1Ak/GBKC2/wqOwN0B/DUl/0XLW44bPh2/aHJ/B/uEHzPBCCrVd8bB5gVb8+CF3eP3nA88QEZutQtAUZoR8ruyyhJJk4oozO9+P401GyHd/m0tG/o6LRbC6httFY9hbxSHaiH8064jCA/B4/MInPSizXRn5rTydj5/EXk4rPYzkV4BpQ+wOfYQwfZZDXjt5MjEyAYR59KIUKk3566eAsscYac//nzsGb5pwnf0Os/zg4MkGHDuF2HMSy7BdcPo4Eef8BEoUP+d5ORUQpVYwmxaRqeY/R1JtVNqVXEeQk73LQSnIg36YHnFj0mzu+VbHbd4HcQ9Ftsr/7nS7s75h905+bqyvjEFF9S3e3BgzUdXPfLGrqCD3rWo35hX+Vxb9gHGKo0DYtbcVdOMF1i1jvGqmc4w14yOxP7wfKNQIcr7c5naCqR4oTFIXO61emauiq94Pw+HZV92m/5eCkN90urID7AMrKosp2gNVhHxQw5bf3NPikq/haBT9mjM3gd1FF/fDmAI/6rj7EMEx6t97KH35wb6R7Fg/xQXsAc0DHRee+zCq9RKLx+ctHwTLD2SbiKoCpBeJ5GCwKqfFmyDr2yG73t/uHBC+vftaD0Q0GhB51kiVRsdrd31Rd7HJRQhQKWIKDfoJIY8HCNOTRCAyxZRtCWYlFtjIB4+mfk5WSvDIDklB0+bK6WNqlYZdVOuKUvibxinfNkfIRogEezFN4ESUeop/CJBgzWGHyYJmk4ZZVeB6icA28g/Fw0AIyqSPW6d3kP6TpP2eBRjUdM6Oybvgpwni2cOU71Y+wgf96Ph0u
 m3yRS5Pd
 cq/YAYx8MLNnCvDn5NvMx69M5z8BU4MCtIN1JIpaGglLJctOhXCvBFSPNqV7Od0qPfynd3OrfF+NWBeMUVfJ65sK6/JmiTniwP88g2uiRNX+3OLYsCqq72A7CcSSmnaNnARnbjvN3zhZQgcPiMn/duFS+LQiYZdxVfK2/U3RV1BszygGyTt+VfCe1IVLw7VVMkJCFr0SdtREiY3rEXBW3Z0lxLicecIOs8ixU5CVkG5gMSJIZbTcfQXO05WQvNAqJtDKwgYXu70c74GKGfGpMQKk7YfazmXmSyu4VB5hWK4kwarzw+FlcirdtDwfoHD2CUEl9rZmmfFhiSMJqRLjoBesULA3uKfZGV4NnQ7dN+2Yjb75mQVeSyN7SRA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Ever since we stopped using the page count to detect shared PMD
page tables, these comments are outdated.

The only reason we have to flush the TLB early is because once we drop
the i_mmap_rwsem, the previously shared page table could get freed (to
then get reallocated and used for other purpose). So we really have to
flush the TLB before that could happen.

So let's simplify the comments a bit.

The "If we unshared PMDs, the TLB flush was not recorded in mmu_gather."
part introduced as in commit a4a118f2eead ("hugetlbfs: flush TLBs
correctly after huge_pmd_unshare") was confusing: sure it is recorded
in the mmu_gather, otherwise tlb_flush_mmu_tlbonly() wouldn't do
anything. So let's drop that comment while at it as well.

We'll centralize these comments in a single helper as we rework the code
next.

Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Cc: Liu Shixin <liushixin2@huawei.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 mm/hugetlb.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 51273baec9e5d..3c77cdef12a32 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5304,17 +5304,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	tlb_end_vma(tlb, vma);
 
 	/*
-	 * If we unshared PMDs, the TLB flush was not recorded in mmu_gather. We
-	 * could defer the flush until now, since by holding i_mmap_rwsem we
-	 * guaranteed that the last reference would not be dropped. But we must
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
@@ -6536,11 +6529,10 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
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
2.52.0


