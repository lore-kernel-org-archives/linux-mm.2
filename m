Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BFAE606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 20:36:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=p1quoMtK
Received: by kanga.kvack.org (Postfix)
	id E11F76B079F; Wed, 21 Oct 2026 16:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE9256B07A3; Wed, 21 Oct 2026 16:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C90D26B07A2; Wed, 21 Oct 2026 16:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 78C866B079F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 16:36:33 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DD51E14062C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:36:32 +0000 (UTC)
X-FDA: 85347791424.26.2D5E3A5
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2646FA0009
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 20:36:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=p1quoMtK;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf25.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792614991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xRYTM7fnAWcOHXN6sYtLFwsf0RsyMtzXmlCvmvLIHrg=;
	b=LJURiOWA27WlSpvGRlY7ssGDzytT6yhdGRHzX0X/35nhw9GJlmRfpskxqN4GyNdflhv0AF
	yl4BZLD8zrHNbPAvHWc8uIXTCMHmpo7f2yvBXGKUBuP+2fnLVsdAak4UXobdFAF5sq6wk+
	B1h6kgk5n0ePijdBVHsJZewOX5I+bJU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=p1quoMtK;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com;
	spf=pass (imf25.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792614991;
	b=xY7NNKmk9nNr3VzxCzPTjY2NLK9NODTN0UPg2WeZkJ3GFhp1pI7NSWesZSwg+co8irfowU
	jNo7R6ItW87pFcqToXCooslwUBOEVFFfArNe2wkqiq0d6C5JScjW8OKXbrFvuFHcExkuhQ
	SJC4GH8C/mwMSSSNVOInF0eJP44Vjts=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=xRYTM7fnAWcOHXN6sYtLFwsf0RsyMtzXmlCvmvLIHrg=; b=p1quoMtKV/aLG7i8AqC
	+uQWoPkWgpRohfDSu68uHYpqbvwecEc4rFnPgAmHzKor+I+lYSquFiKrOHalKmbcA9UnKrVXs/Yqb
	DswZLGW8KkMxm0Ni3AjlYLQCJI0lrXmrWfnzD22iG8hBSdoo+AhawAXh98HAJohnPRplxNItaekci
	z5rfXpbzxF1dSlPbwStc/Gaqsj9jYrBl7axb4mExcYEXS3Cu7xWJsMqJGbKF4X3too7lH9KBn1h8+
	lqqgGP2+Oo22zvS2Ntxce1m/CGgcjsR4DGOJHaInE4FA/u3FDRwAH/mTmhCjJgPGMWGcv3DzDuxtv
	kWa3dBE9l0o/dDg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xJcz6-00D9zC-1k;
	Wed, 21 Oct 2026 22:36:11 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 21 Oct 2026 22:36:02 +0200
Subject: [PATCH v4 3/4] mm/huge_memory: read a special PMD under the lock
 in copy_huge_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-3-66f00b7a564c@virtuozzo.com>
References: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
In-Reply-To: <20261021-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v4-0-66f00b7a564c@virtuozzo.com>
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
 Jason Gunthorpe <jgg@ziepe.ca>, Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3894;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=livbJIVllqi9tjof4xcSXNlwj+qMnVMZzyODwKG/KkA=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq2SI4OzYdMkv0y22/iMTVTPGRPBuq7eyDakOFD
 eYKcKYE9OGJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCatkiOAAKCRBRlgpH+WFc
 Ki0OEACM5t9icGUbUfF7oM2+7vDjg6uiZ/QlwAXRXORLzo6PdOir8qcZhQ2Dxp4vS7e/BtF9xYE
 Am5NxUVCXW/owrlYnm1bLHQ+2ylTm6JlCLOCh7ooy4ILlAFDJyUvv5nfoLHhk6ydEhlQ/lO9OLY
 QqAUJWsK+CdOArLzZ+wB160FQiBufc4zHI50sZ0rA5fuGDuoiJdu3UJNc2q7+SJho2qlTdmIEPL
 +4z05HFrk80HSM7o8vibRwzGbfHUSpJyf4/fGolfMYm8X97VQ4fHl/Hc+f7XqshSZPrI0Hi82hI
 2kRwr/rUw2QqTn2KyBtUSSMieLe+FTcHVOB2o1rKMBmy5kTvYCjrsbHJLHA2N71zGittHvdFQAV
 wc+CRV5a4yJ+i7wj9g8sBSXJYtl2oc+Nh3YoFgonmxrsr4gqVGHh0p19j4QU3uKT79elyogWliL
 igktAc782Hv4OTeQEw/mOWzRD9KPuEBmYe7RV+vez9WQ5phkrIUO7KMODcMGrQ7m56j2UQgODJC
 +jnUCGDIFF7udwOHWjbtMgOT7iBJj2rMVJaPPjPKHWG65w8dK0lkgKGgVE3c5iLC1VO4TO60kpt
 r73GPnlPIIN6sFFV/KhwFfnUD5kZMhrKgeZL7gLF+7azWsgH31FT8y1gkMNuThqR4EAn0bTzxKI
 mnF4/gQ14YUWGGQ==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Queue-Id: 2646FA0009
X-Stat-Signature: 9s6p6asj7qri7yndyyq57mmcit7pn19o
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792614991-455386
X-HE-Meta: U2FsdGVkX1+iIhc0UT29156enBSyRP7lkU53inX8C6dJE/CjDgPQIPE4Gkrvl6/f7gY3GccaKc5ZuD39DtIOWr3MBOLxLZUHeaBf7L2fSgx4hti/EGtR5duoT6yCCVY7veo8JQpDDwA+ykjUufZXUSseytkeC2gSeSdMRcR6Lzitl7Gm9lPEWIKlH3OCQHk9XlK1JF5Jq1iaNh98hzFGUyK0O6fBhS+oSA0QOUkjRcCYXNGvRsDGyvat5fK8TGzTg30xEArSLbPx/nEMLelG6h+J21XOwXg14fQtBrzKyNwlATnIi2a8XPj2KFQELBF0i47ThIBPtq3s2UrxWS0JKSte9QJjKOOKhrrxduQHQILpK79eSVMrvhp8QcyfOX8T5UbNfN74LpkqWWHFi0x4ExiS5/Dpt9PVROxygCWKrMxin5UR3iDTd/gJiUKfb9mS37NQJtytjWoV1/mGEcx7TJ1FOTyVw1UVjve0eEHpo1J6emhopI0IzW2Dd3O2SQMnvgHAy04WETGmuVjF0wPv3VaDUT7EN2cBdmy7EAiqAmHRaTQWkVPbZnzURjO0oebO/+9MD3zfYTcRQHQCVOBVVZgtFnWQsL+28W/6hfdztBpewZdZSIlFOgS87y1+S/c3bUH+Vk0vLpOf4Nc+cYn916DiDCDl1QPlltvt1GrsfPhhPbsSCIc03/XRJiQU0rlHzWONWcesXDDLv9fPaEwwydyEfNSZZyVj0UYNJhmtAQm9lYHvrA9dxs5MyMNi/yp/tUOps8sp18R9auCuEh4vKcn+feJODbVSriWkS2EdWjvfrIfE2JmzNcGpXejUlzzkFfj1WYed5RqmNK37RMca46K7UoBepF1z4kkJl8Z6qMKRFNO1mLGw9k6vUHeKYsYistpRSFd40LxsCqU7jHqDIplrp1oFUag4iuwo9EmVSCgOp6K7ZaGL5SfGxda0J+xcEnXz/nHLL/83cvmBmeb
 A4/NNyT/
 qD0Rmv2qjgQt4jmx5DnStDCUxbRIn3x98mN9L9sCMf5Ics/mduis/UX9INHYyMrWaVXTwvgR2q8ikazcwRHGzfpXxOPk1SmN426po0rJfD6kOqM1EcciZtlrAD1OmF3et78SvngDq2KSdgU5xWHGt9RNb/1C5YEAfPoWEN4r9ENA7x1lo0qlxUfuV5IvNvfo3vZJ551FxmbKDV/whWe93/viEq1rWLFlA9DRD8ip3ioBy1SN9z/ScFxt61vBhRRtpOl4YIc5T/J4yUv+/MhuIzXmpmxzIuMtPIw6Fhvp817F/PjrXkGWN9ev6d000AIeDowok055cSCxffBNE11hGjDlfND5ZNC11IWtnYnQgDeuHQjCktqb9acqqzs5NPt4xOcnHe81ceXvyZhXQ+hon8AhtPmKMZIG3oVNd+42NXxPF9FyVRI6tCMoIK3I2PsX0nAJMhc5N4U8hn2vsrtChN8N9Ji8BGSXQvvHYektZ8AP8v7bbALQIzlIWArWYu4pfgXng7MPZSpXPklo=
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
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v1-1-d225c60bc316@virtuozzo.com?part=1
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 mm/huge_memory.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 13e3674fb6115..da5918a0ade87 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1961,25 +1961,6 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
@@ -2021,7 +2002,9 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		goto copy_pmd;
 	}
 
-	src_page = pmd_page(pmd);
+	src_page = vm_normal_page_pmd(src_vma, addr, pmd);
+	if (!src_page)
+		goto copy_pmd;
 	VM_BUG_ON_PAGE(!PageHead(src_page), src_page);
 	src_folio = page_folio(src_page);
 
@@ -2061,7 +2044,6 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 	}
 	if (src_vma->vm_flags & VM_SHARED)
 		pmd = pmd_mkclean(pmd);
-set_pmd:
 	pmd = pmd_mkold(pmd);
 	set_pmd_at(dst_mm, addr, dst_pmd, pmd);
 

-- 
2.43.0


