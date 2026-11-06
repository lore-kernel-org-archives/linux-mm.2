Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D304E606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 23:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HjCG0g1a
Received: by kanga.kvack.org (Postfix)
	id F19CE6B05B4; Fri,  6 Nov 2026 18:29:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF1D86B05B5; Fri,  6 Nov 2026 18:29:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E07906B05B6; Fri,  6 Nov 2026 18:29:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE6AA6B05B4
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:29:05 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 553224025B
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:29:05 +0000 (UTC)
X-FDA: 85406287050.16.0CE9345
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9073CC0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:29:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HjCG0g1a;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794007743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=D5Lg8q3KbQTAAjZNb67nMqqiPJ3mZrmihVYvOJgZmWY=;
	b=rdhiSCJ065uccGgiqpsnK9lGjMaD1PCjMOPLnG2csJHRPM24X6Se73L0luk+h0wd/vCGAn
	lt9pTQvayBwOVwqhBwmUAYBmE1wVQMZpwoVx2h3LyBDiR7xNHeYkX5bktpdj/rWi1CKioN
	mH2G0MxGfGDriUB83NjRMfH+YHm1nzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794007743;
	b=00LVH4qO2otGu1coBrODSLlwirbWgoYn24rywunKr00apzDkunofvJYxaD0MvI2G/dz93k
	yohu8kDQ5ZnEO+PND0w6tFpsGe60BBJRKOQPrxvnyelOG3+9rYCvVbZQMcWaz2p0X5H9XW
	p1UXqM/J9aQxPnB4gOldUXRS5s8FUVQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HjCG0g1a;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ABEE460D09;
	Fri,  6 Nov 2026 23:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0891F0089F;
	Fri,  6 Nov 2026 23:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794007742;
	bh=D5Lg8q3KbQTAAjZNb67nMqqiPJ3mZrmihVYvOJgZmWY=;
	h=From:Date:Subject:To:Cc;
	b=HjCG0g1aTWciy3pkJyDNFBUBv9stFTaNjuMAfqZBTNGjzbPDRP7Hv5yTgJ4UfSbAb
	 8AxuShUqRnxXJCFO5FCHTSOYL3nrnKrzHtk6Tl77YM0rJzMq8iXYBPMX2R98m4JqLs
	 ZyRPBLxrk0v/d4wZWElK8BXnP6C+6ss9SyrIOzVt+N10ncpCv301mHppiSZ1eQ1gzV
	 ELs3u9tQK4Mli8Ghkzmj8g6k9J9aeIVI69a5hfW7hOhfdFyEDIECTHlFtpjg5Mx+6T
	 tUrKZ/99debrBN6/xNPxbnXA+zVGkT8NhD6v4IanHAWaNfVpF/AOxCnpB5b2HmzPJu
	 Of59IvMcDOgCQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 07 Nov 2026 00:28:55 +0100
Subject: [PATCH] mm/mprotect: don't skip uffd marker install when racing
 with PTE table reclaim
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261107-uffd_shmem_marker-v1-1-91fa2d653cfe@kernel.org>
X-B4-Tracking: v=1; b=H4sIALZi7moC/yXMTQqDMBBA4avIrA0kFvzpVYpITCZ1lNgyo0UQ7
 260y2/x3g6CTCjwzHZg/JHQZ04weQZusPMbFflkKHRRGqMrtYbgOxkixi5anpCV1X1Tl42v6oe
 D1H0ZA23389X+LWs/oluuERzHCXdNXQh1AAAA
X-Change-ID: 20261107-uffd_shmem_marker-a0b9869d783c
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Peter Xu <peterx@redhat.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Tal Zussman <tz2294@columbia.edu>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3788; i=david@kernel.org;
 h=from:subject:message-id; bh=nwDMBOfI116Kjc7OUedjQY4U7ETBhxHwaczK3QvYfAM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeJe06+bZNLohnk7Vi/M/oJTzn4/O97u7y2pIkbxVcv
 4y76LpVRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABOJSmNkWLDDuTVVPOV+18zZ
 8sF39HM9v5hVK6zkX2x270ZNNMOpU4wMrwWiHe6u/bnGquXkq03B3fVPbXR9FnHrmh4/ufLI5t0
 BrAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9073CC0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: euypt1f1u8hi8e91gxfxwb6mbtau9dua
X-Rspam-User: 
X-HE-Tag: 1794007743-653591
X-HE-Meta: U2FsdGVkX18Xx3opqEDPVChXvDhEqVbcLSiZqKKwhcrkwkPeoKGmga2BWTPRcHlzJQnAJpAu6Pi/n65PUtmdrNnclZfu6sy8+zuNRDgku/IMSTniQDgtlHP5AYjCghS3ZbO7oLvMx9fl7APh41KY9EvYiCub1dHE8uh7oEpqO3RJMpQEjpUFlYgGeuG24oAMgKxXi6qUWgGcr0T4XXMcsKs2mjqAio4aPAf22iUAtpW6ReUq0IgK8FTcLqnw+pXKn8cIKQQrNweFBE89qpqGC3KsrFof7IO4MHScspeB5lt9wxsWeJZPHdf/HGBv5gUf78gzKLrdFoRYbTquuwzqs2krS6Jeqprx3DfJK+Xj0jnZmnPwn+fQ7QtLsLiF+0rPMRF05ZYrD+t/PZUTEhKVbvvR1UajDadWK0zqy84yNFsW19akQ8Hy43WKg6vc2WxpGSp6W0SgLSWj8KjP9RfRbXS1fkDf0uw8ENIaYxpw+b0n4PmSOwVjrGq/VYjO4BluNSB+OTJukYYtDRA0xQ83R2LXznF2X9Y5NolrMQGfwcD6IBJoaP+fJ7f4N+TwviO+dX5c1KWgK7fZlZlq8jRPBPuTK2hy7dU2vSTmygol3q5J9jE/0yYPUm8jLm9BxroI5KNZ7apsRvixD1I+tj/0srrsXAhQpWHYHqzxx4gQuQVgKQvvqIMNapMfX1n1EJxSh5j7b/zUmt6Hihl6tIHsInFcOE/VnmUtORtb1xZyHhCK7uFMvksYvgjpUSuC6QitRbVvZV4cDcyrcq+3whWWNgBsCwpwonPec0VA8oU9DV58Opt66GoWdjUgwDdldCJt2m/Vknl/a+i7TJ42cCtpr3on9HwNhsznjYYJ4ui6X0llNvknVFF6aXe2Z57L8e5d+S+poWdIexd6JvbWocb1xcBoxxMcIMsqjWDP0shD3hc8iAe3Q34C9lmAxTl/R8lkdcGuI/rpcerCxX8NHOp
 aJC/aZRZ
 645NR5exzZQktMGKg60DwI+NzMdeXExdbHphCah0jO2bv6EUzvZNiHVuPqDC/fjBvSvj5EMA2ejZSoe1T2wVU/Pf1d4GzKS7BIec7h1hMG+UkVhsqd5mrgamB0WxG2b5Kmzka1Wo2pE0VpTL6Kf+amo3FKLz6YF7/eu9dw193ZJxfDmk7nFzu33r880ifWROiDugXokZ2QiK5phtOeamg65dFf/ZM4WEs7NIgerwY4JBFgkPWwGTj70+FFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

change_pmd_range() populates PTE tables before installing uffd-wp
markers. An empty PTE table can be removed after change_pmd_prepare()
returns but before the pmd_none() check.

That check then skips the range, allowing UFFDIO_WRITEPROTECT to report
success without installing the required markers. Subsequent writes by
userspace to these areas will not trigger uffd events.

PTE table reclaim during MADV_DONTNEED and page table retraction during
khugepaged can trigger this.

Retry page-table allocation in that case. Simplify the code, getting
rid of change_pmd_prepare() by routing all code through the "again" label.

It's a small race though, so likely this is not very urgent.

Fixes: fe2567eb5521 ("mm/shmem: allow uffd wr-protect none pte for file-backed mem")
Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
I expect Andrew to pick this up.
---
 mm/mprotect.c | 48 +++++++++++-------------------------------------
 1 file changed, 11 insertions(+), 37 deletions(-)

diff --git a/mm/mprotect.c b/mm/mprotect.c
index e18d4e12fc341..ef4e7188e24da 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -470,25 +470,8 @@ pgtable_populate_needed(struct vm_area_struct *vma, unsigned long cp_flags)
 }
 
 /*
- * Populate the pgtable underneath for whatever reason if requested.
- * When {pte|pmd|...}_alloc() failed we treat it the same way as pgtable
- * allocation failures during page faults by kicking OOM and returning
- * error.
- */
-#define  change_pmd_prepare(vma, pmd, cp_flags)				\
-	({								\
-		long err = 0;						\
-		if (unlikely(pgtable_populate_needed(vma, cp_flags))) {	\
-			if (pte_alloc(vma->vm_mm, pmd))			\
-				err = -ENOMEM;				\
-		}							\
-		err;							\
-	})
-
-/*
- * This is the general pud/p4d/pgd version of change_pmd_prepare(). We need to
- * have separate change_pmd_prepare() because pte_alloc() returns 0 on success,
- * while {pmd|pud|p4d}_alloc() returns the valid pointer on success.
+ * Populate the lower-level page table if marker installation requires it.
+ * Return -ENOMEM on allocation failure.
  */
 #define  change_prepare(vma, high, low, addr, cp_flags)			\
 	  ({								\
@@ -517,30 +500,21 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 again:
 		next = pmd_addr_end(addr, end);
 
-		ret = change_pmd_prepare(vma, pmd, cp_flags);
-		if (ret) {
-			pages = ret;
-			break;
-		}
-
-		if (pmd_none(*pmd))
+		if (unlikely(pgtable_populate_needed(vma, cp_flags))) {
+			if (pte_alloc(vma->vm_mm, pmd)) {
+				pages = -ENOMEM;
+				break;
+			}
+		} else if (pmd_none(*pmd)) {
 			goto next;
+		}
 
 		_pmd = pmdp_get_lockless(pmd);
 		if (pmd_is_huge(_pmd)) {
 			if ((next - addr != HPAGE_PMD_SIZE) ||
 			    pgtable_split_needed(vma, cp_flags)) {
 				__split_huge_pmd(vma, pmd, addr, false);
-				/*
-				 * For file-backed, the pmd could have been
-				 * cleared; make sure pmd populated if
-				 * necessary, then fall-through to pte level.
-				 */
-				ret = change_pmd_prepare(vma, pmd, cp_flags);
-				if (ret) {
-					pages = ret;
-					break;
-				}
+				goto again;
 			} else {
 				ret = change_huge_pmd(tlb, vma, pmd,
 						addr, newprot, cp_flags);
@@ -554,7 +528,7 @@ static inline long change_pmd_range(struct mmu_gather *tlb,
 					goto next;
 				}
 			}
-			/* fall through, the trans huge pmd just split */
+			/* The PMD might have been split. */
 		}
 
 		ret = change_pte_range(tlb, vma, pmd, addr, next, newprot,

---

base-commit: a3d27154a205f6b32000e7e2734b2a6a4d22c65b

change-id: 20261107-uffd_shmem_marker-a0b9869d783c

--

Cheers,

David


