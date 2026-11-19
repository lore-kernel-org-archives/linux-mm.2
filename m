Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99DE3606A335
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:44:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=QzByG199
Received: by kanga.kvack.org (Postfix)
	id 6CF846B0656; Thu, 19 Nov 2026 08:44:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650736B0658; Thu, 19 Nov 2026 08:44:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D1636B0654; Thu, 19 Nov 2026 08:44:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16BEE6B0654
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:44:43 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9FB061606BC
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:44:42 +0000 (UTC)
X-FDA: 85451988804.08.A074AA2
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf03.hostedemail.com (Postfix) with ESMTP id C6EB520008
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:44:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=QzByG199;
	spf=pass (imf03.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795095881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nbB8McM+pZsP1nWFy++Avpejx7qyy0NzIjLQT0z2hjc=;
	b=HNh8JqOQlYu2P0Rn0s4FXO+EGqRNpCUQoJBkarDbg8WggEkAGEAWLo3RNCDrQprrmU4dh4
	mDA46L6lQuFlkL9uSp9pXwgq5klbCbfz8ZqCaBQAzCQyztZ8vLAiTiPgOwhEZ+7UTxWgm9
	5QYXWPLx56BqWEjpsjcrmQ0LEfVw08c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=QzByG199;
	spf=pass (imf03.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795095881;
	b=xdBIhC6Bh0fOVg1PLdftEirfOSVU4wCTAfDoGMYLEt3n/ooZ+xQkce7uLVoEUxwNjrlxDk
	FTEZB5WU/BFhfzVkDw4VbsE7LTvBAJ0OLGGkZpc3iXN3sXofuPuNI0FOKm6EDmwXXhIhbJ
	F79Jn8ve/AsrBhBFSYqHAH9TDCcmvy0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=nbB8McM+pZsP1nWFy++Avpejx7qyy0NzIjLQT0z2hjc=; b=QzByG199OY9wUoYkzrg
	DPhUwBEew+cryv6qFjom7gBw0UeNqytujh+Q+kBpgavYFY3wiqAs7Xun+tveG/sqUEdWKbNSaO6Kw
	N8iJ5bqIMBjyVh17oHXC2E6nJ2PpZqNgZOQLYrrezy93+s89Kr5v4+ASTJfzbS9eWtC7yD5t+zdZU
	keh71avNmAB+GINqp+EVNdq91FtBCDlaWP2CiPH084rjsJRF0rKkDZ8Zbhw4CoXInwxGcX8pt7arx
	UcTFhAIyKP5xltkYIbSAtBfTAoGZHFNwIl9LSKaomb4dUmLHdm5UY1nnFNWFqRpPqC3e2QPkKiHtm
	HegkEpsm4YvT8uw==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xU2R7-00FBqZ-17;
	Thu, 19 Nov 2026 14:44:25 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Thu, 19 Nov 2026 14:44:04 +0100
Subject: [PATCH v6 3/4] mm/huge_memory: read a special PMD under the lock
 in copy_huge_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-3-efa7817a2bb3@virtuozzo.com>
References: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com>
In-Reply-To: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org, 
 Sashiko <sashiko-bot@kernel.org>, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4194;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=0KbTMYxwQGgCuwBNwt1Pek/vi+cv68YluLjm3ssgOAk=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq/v03feVsR9uS5X8yS8SIHKVuDw/Cs0h9NcRGk
 G1L467BasCJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCav79NwAKCRBRlgpH+WFc
 KtsaD/4upDZ3XOtGVuDlVMtEZc6ok0w47ytJX2pe4pZSlEyhwyYu2hNNv7HOVvaTxVdOJwB8t10
 R4bYNeK2RHBH32+UrYqVTMdv4KCU5XtpCW3Dcvv7tKgYraXEO4J3ZchXA9qYonPXblA/Cx2H03w
 l8G6NqMFhFhC0Es4AfG09RdLDoDGT0o73ildtP02dN0HsDsq5tk3IXZc0YFrVEyO2/ubPoR4LgM
 FmyvZSN8S8uaUnA9InrJGifkTJ1p3Hu9lkJ7pSWucQcl8eIPnP2/55JVtx1ZPN1tbDviOBiyopQ
 1yFbfeGc6aVE6+wRNQjjbbaN7NnNHoNVc4u9uKwRMxc6DpeoHFBb08oTNHaPV4pcXEVe6/2ZAOV
 ihWRAfsHlDC9k8qPXMdM0h1mjo0i70ayiHMbMJYE8m+HPr8Mtt/8HcaDAcDc7HpnUEpnX9+bnLs
 HOx7QnnfgckSuJErP7G26GWKsErWQyc4lDOVQvr3ijPBipiZ6+FH1udhQHUEpBkCK/ilzlG5fCo
 QENePxvVh8xXHLuF0WEy4NIgggm84eK/WNiSyVPvkSDY3aIh9D4+MReR0r3YIXRHA2oByJwPOSp
 apRhB7ACPdHpBkMynndAtijGBWcFBa7CoRRIJZDAX1ufjBJ4HyjIUiQkyk46ISBTz+EuywI4TRS
 TEQ5SXwEBP98vyA==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Stat-Signature: 7oszc4mcrzc8pddmajd9yps69ox7trkz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C6EB520008
X-HE-Tag: 1795095880-20462
X-HE-Meta: U2FsdGVkX1+QdaF5i6L1zHz+JbfUW0EKzG8tLu/KFMrn0w9Nt2ZEILCd1URzexVJaPy1zIeUIVQ/4h79Ub3lMb6u5bfMBbmsNKVsUJUk1W1uaVviF5QmHLCyvi4H6cA54nMCt3urskn4k1FSLJb77vPFVAddPMRmzPhB5wh4SdqAiyso6+JA9hXzWuLsFoeeLaeKWd8Yln09X2z5XmcQnFkDbuKbJFrB6+m1CnQkE5KoKl/PsDzlJFPq6hR2K80DmxLv6ZlvmE/j8f+hndSMawG6oiVhA3OHc49SpGnK8OiniTjoDRnylLo29qSx9q27M/ID3NSLAhgd1npRWFBJGxaC453sw/tD/GHqpdhMcH6DFx5TFLFnbYtPdsAj5FAtb8+H2zgUT2YA1l6GISRstgjA2znorJS+5ffgpK52UGdop1RgQE3kKSljh5Nwyg+cvBV+SrpcHf9SGBYZDetmlZz39YXDfO0zLKJR2KzjkfmIXUXGDhf9bd8oAUxLtMG5Vl6U0qa3OMzaFWqJwNb0CZkI0GzXUZ6I4mDAH4/x2bjtR8v5jWahHDcTahkdFQ2NnuYkSF19O69NQgVw/pKZNdpkUQz1pmKuownG06sKLKTur+js2UTgNby27REyALIsblC60uxMGhS2ASyXNRt9FcxYLjMJjF8IwYae86SMQXL82c/YmWAkwNd9ckhqtgjb2iHIKbQ9kUky2Sa1vr6gNzxGQJNxbKviEYu2Hmghb/V0gvsYoHx3jGzUxV0dCTLYnlEtmNBc9X/J05f5jI6GLuvsKbjJ6GngFIGphz6lYWr1fVg6RclfzBBbrbwy2dDE9bdLvdX/UhM+WD7mn34BRXTtEnJCDLwyRU94Ws5Z84YVVtcjEP/B14urPGx2AvowgAs6zp/BWBJgOpWNkJ8x4OrQTi4IAiY7mb84lF2ibDi8vcJO03HVps4+JYsXt6BZkWLRDJ0FqrW7185+Q7N
 FNFovBsm
 gV9s/mOFu2Mdyl1+G1CwNfhLoYpY8SBqb1GmNAbNxTEOZ+C+2INCM8xFfiUWSDh0iBAH0upqNvEPAYcS9xwAOCjr0+BNvqg5P50+nqao5vtJxGXasJClYy8WY7sk9k6EXa1NrPPDCbNNl0sThH94d9qACaj5u1ha9DZT7RD2gIPeK+Ja/SNyVWShEk3t8bQzWiRGBED2znTJjcsHStgUYSTLRb7M79selWroLvnYqWDbL6oh0aRJoP2bqarPDFvedB8QgHzBkrj1XN03DScKCjYxefJoUoLiEG8XvCZl37N5SOnL1GMiAE7CjWCZQx+wolY7goYc65x/Pq9JqqpO41MR1xnJQtlVi5WAQc884arclu8NLe/x9PEIjVIEwMeyn1hXE/ULTZFAOattSoQh9pr6X1wT4y5awwS64tWFfm0mlCYLrjf1I0efFlG8fH2i4NF0xj7gsN24hS+XfrXiPZ+jecefuiUUipRlBsJnFZ3KS42bInRWJDx8dj5yHAafcRYR8EA+N0M2URdI1epk9hi+5pwHcoz2U30AGB5nXulhbj0VrPoR2nl3+NQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

copy_huge_pmd() reads a special PMD without the page table lock and
copies that value to the child. The mmap write lock held by fork does
not stop unmap_mapping_range(): it zaps under i_mmap_rwsem and the PMD
lock.

The zap visits the parent VMA before the child's, as dup_mmap() links
the child right after the parent in i_mmap. If it clears the parent PMD
after fork has read it, and passes the child before fork copies it, the
child keeps a mapping the driver has revoked, for example:

- vfio-pci: the child reaches the BAR after the device memory was
  disabled or the device was reset, instead of getting SIGBUS;
- panthor: the child maps the pages of an evicted buffer object after
  the driver has released them.

The same branch deposits no page table under the copy. ppc64 in hash
mode keeps the hash slot array of every huge PMD in that table, so the
child dereferences a NULL table on the first hash fault, in
__hash_page_thp(), and on the zap, in hash__pmdp_huge_get_and_clear().

Take the locks first and let vm_normal_page_pmd() tell a PFN mapping
from a folio under them, as copy_present_ptes() does with
vm_normal_page(). The zap clears the parent PMD under the same lock, so
either fork finds it none and skips it, or the copy is in place before
the zap reaches the child.

The copy of a PFN mapping then goes through the same tail as a folio:

- it gets a page table where the architecture needs one;
- in a shared mapping it is marked clean in the child, as a PTE is;
- in a CoW mapping, which only VM_MIXEDMAP allows, both sides are write
  protected instead of a warning being printed.

Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
Fixes: d1503aa9ab80 ("powerpc/64s: Add support for huge pfnmaps")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Tested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com> #PowerPC
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 mm/huge_memory.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 277d27a8a4364..adf3ca088bf41 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1977,25 +1977,6 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	int ret = -ENOMEM;
 	bool writable;
 
-	pmd = pmdp_get_lockless(src_pmd);
-	if (unlikely(pmd_present(pmd) && pmd_special(pmd) &&
-		     !is_huge_zero_pmd(pmd))) {
-		dst_ptl = pmd_lock(dst_mm, dst_pmd);
-		src_ptl = pmd_lockptr(src_mm, src_pmd);
-		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
-		/*
-		 * No need to recheck the pmd, it can't change with write
-		 * mmap lock held here.
-		 *
-		 * Meanwhile, making sure it's not a CoW VMA with writable
-		 * mapping, otherwise it means either the anon page wrongly
-		 * applied special bit, or we made the PRIVATE mapping be
-		 * able to wrongly write to the backend MMIO.
-		 */
-		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
-		goto set_pmd;
-	}
-
 	if (vma_is_anonymous(dst_vma) || arch_needs_pgtable_deposit()) {
 		pgtable = pte_alloc_one(dst_mm);
 		if (unlikely(!pgtable))
@@ -2037,7 +2018,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		goto copy_pmd;
 	}
 
-	src_page = pmd_page(pmd);
+	src_page = vm_normal_page_pmd(src_vma, addr, pmd);
+	if (!src_page)
+		goto copy_pmd;
 	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
 	src_folio = page_folio(src_page);
 
@@ -2088,7 +2071,6 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	}
 	if (src_vma->vm_flags & VM_SHARED)
 		pmd = pmd_mkclean(pmd);
-set_pmd:
 	pmd = pmd_mkold(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 

-- 
2.43.0


