Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D340E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 09:16:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9D0A6B008C; Wed, 18 Feb 2026 04:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5DCA6B0092; Wed, 18 Feb 2026 04:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D53A46B0093; Wed, 18 Feb 2026 04:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BEDEC6B008C
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 04:16:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7567D1402B8
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:16:41 +0000 (UTC)
X-FDA: 84457022202.04.7FAACBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id A8B62C0009
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:16:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZhPzVG3G;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771406199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GxnUQPC220LzxlqA/XW9TlI9GMTpYPaM4RAJPZCgVjg=;
	b=kXAagzmvkYOHohvPHMb9UXuhvax54z5M2LyUcecYvgP6RVhz6CxGujPI6rvvL/vv8AY6o/
	SSOdVlCSxSvUA6mAaUReFFXI3voOWZGdcRcFoWprolDV8imE4NUvNhd9uHJeGTCFawynFR
	Wnpn4eXSiJI1unFMGUorwPSQ8zDGUyE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZhPzVG3G;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771406199; a=rsa-sha256;
	cv=none;
	b=cPRMYwEhzevlIZSfod1E8OkfX6m/pSoMpJdd1Fojy+Wwcg4MXLwceBfmtOB3rAV+A1Vwmb
	kQLK7mnSoKUk3zNDVPS7RJQpXUXlAh/8jzKKbAaNOcTTgYxY0vHbnqh+jPdJW3xdM5e/wN
	ZAJfmf9PvHQbMeVIAdLcrzfbVZ51lMM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A3B5943DF6;
	Wed, 18 Feb 2026 09:16:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B0FC19421;
	Wed, 18 Feb 2026 09:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771406198;
	bh=FvCGn+vM6YhHtL1UqvN63UrcQQ83+2nhjMQm6GmxbB0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhPzVG3GTF2v2t7OXgf6sT2S2p6vfahE/KxLoI94shA9LE0v9jB+GB6GTMSlKDdrK
	 blMA9kzFZDBQMCBqF/0wdH7Dbe1wx3+0qTP7k+D4KI5khI6nVAE4MXNVEAbraNnYmo
	 n5PsgK7PU9XmdGd2LWaH2vUTfZXiLs01tsaG8Ze+NmmQ0R3Tv1aHxx7OlpCsFH3zIR
	 H38y7DrPxzn7MALvWq+itzhgah/jK+LMVoH1C8jKF1itKQUHP1gkAIiYBrcQkGq9y6
	 /liyV4Lk038Ked3YeSnqSHhaKEPpxFhKrpbTvJE4hxS5bRDkGnV9rGKa/ORnsyb5gl
	 d8X+jmRux6NkA==
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
Subject: [PATCH 6.1.y 3/4] mm/hugetlb: fix two comments related to huge_pmd_unshare()
Date: Wed, 18 Feb 2026 10:16:06 +0100
Message-ID: <20260218091608.25726-4-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218091608.25726-1-david@kernel.org>
References: <2026012605-uncorrupt-yanking-4155@gregkh>
 <20260218091608.25726-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: A8B62C0009
X-Rspamd-Server: rspam02
X-Stat-Signature: o3h9iwerfg4c1w5sxcwki3rfibbj5u5f
X-HE-Tag: 1771406199-752556
X-HE-Meta: U2FsdGVkX1/CfIGIEm04bprKlv7PKZYi2w2apNcsDkAv3HeIHv8Dqr/EOUanqbibPCAM02zZA2qGS8GchR2T4qAnLHFP97sdv5E6E4bgoSkjhQq/wPctf5n48pcTI4kjcYC4G49oWeVQUBG4A9vVyAoTpQlHM4T3TJXhprCBf+jjYArOXRhhPAQGoQq33Tng3OPbGsbe246Byh3tU5QkT7Jku3MbrIhb29Y7wM8fOlqI9GNtTT/2XrtvZesh/hUhM30Zd0M/YnWVi5OS7rW+sT1ZmlJjGga+pLMYu3YXL2VWpAd+LuC0xE9HL2Vo8b0GL6bi4GUX2ExtInI6yEr1YN9AYJj+f7jfzHEyQXvLm2U9uGZ49lPOJLkzeBz6+bCQ6gLFy43/cPVYi8KWe+UCkdjwCVqRA1wK1txGXMfcmZB5mtjlKhszb2xn3iqA7t4oPr/9ZteUjrgODvoKsA+q8pc/k2PAwrNO76Duylt/pKs2EBCJ6KlN+VRl9GswbF6K2wGoIMU8Tl0fpZQZSdHpfcPwiMu6dKZu8OD2NpBxNBPamArKYfNiqx3DnESleFlSGzYcJnscTP9ohIJPdhmtnIEPpRsFsbCQRvaockMrm4ZJaf2LbFnly25I/CjgW2vWgqAE5xsC2vDjF+OKTLk/ozYAj3V+LhLsnqVHYOntPfH6ykqsd/HsJpaECIEtD1MBib/9iIH6O7S20A9R5nsBzzga7M1r5znBGU7CUczs2jLv5SGC8TV3T/kaxvnFewGyMIHiC5pGMpWshRgmRpIVl3FMcVtnP7t1oz7cObK14OJhJJn2glVyS9WGnGgKm627xMa191aBBVwu3btFDH+Rljoz2ZbBb58B2u0cP9j9Y6BFtWPsqTr4p/vwwojXGpFX0V0o9KAfVYXjEAUt9swjG62c9SKSm6i+78Mn7XWpY5C5Vp/h5Uh+1tO9h7ndWbOU445sEAIVCdq9CSCRFEo
 gd5YPQYd
 ChuCJRe3FJ5dL46nRjbY572tWdS47SKDDhkF2UoLFUMRV9HG7lYKei4IhtnDk4w9/5t7LmrSZfyDdzLK2yUdQRMZw+PUqPlm2b3b2pRUGH/0p4BEk6YdwNV+r7ieJ1/p1xNCqY3qrBRHEBrlVAqeMRjCOjFjb8nQeStbfRwsxujwhjXfOBEVrlYZ1Sb9DbZ8mhsCuLRKzvQUv08D5WS+Ga14sq/vn77vPM0KOka96fZTQUZksK8UOuU9MOPnHchWBDFFsi9ulNMorFbkgGAZZUKq6lDfZ841wDNnnRrd7wLBi9OtWqvP+JglDFS+BTDHPfZXhMUk9ZiX1xSBijgHip2oQMJ8eMbAY18SXjG1QAUGsdTutSGpKMVUXfdef8nCyvCO0r5yVWwFheUbTgMA58hDgrNN9nFLDrlGgHd5CWpXfNrV5zgUXdz8mF3CpP1nMgJtDKA4Vhn3r8atX2Goj0mw0tw==
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
index b07b332beabb..86218b9e647b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5432,17 +5432,10 @@ static void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct
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
@@ -6781,11 +6774,10 @@ long hugetlb_change_protection(struct vm_area_struct *vma,
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


