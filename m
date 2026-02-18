Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEE34E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 13:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CAD66B0093; Wed, 18 Feb 2026 08:06:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B9B6B0095; Wed, 18 Feb 2026 08:06:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1639B6B0096; Wed, 18 Feb 2026 08:06:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 042776B0093
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:06:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCBEDB5E4D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:24 +0000 (UTC)
X-FDA: 84457601088.02.BF5FD74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 217CCA0006
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 13:06:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cELbw2+W;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771419983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r77hyfItmVAocfwmynd+ENBJK9aci9jOptcl2HKubb0=;
	b=J+HFZrSEnGqHMIpZOVRps10k0JN/1DLG6E5WjG0350/wd2zTXVt1/1Hd1/lnkwuYwRVRix
	LQlYu1EK/mSFHl62dXnvL1G6t9DmTrIjt1EWEzr2FXSeTk7VZXtGUBE4PPI07WQQrw96zX
	bS7GnCTZihBF8QpKICDTNU2AXYJJ4aU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cELbw2+W;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771419983; a=rsa-sha256;
	cv=none;
	b=hsV+hJ4DXHmOh1zD3Ng7S3bOvKSuKhKKgLRHZSQoC9wvBnh5nJoAmj6ksdW+Db8AecePMP
	wPHSwxAHDLFMjCA3GkmpjV2S9ZErD2lMNlbIOliYZ//sgidmLrmfRHuSWBHwyCvp5e/cey
	3qEUK+ck6Lq04sre4t7lJeaDt35NPk8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A9EF561858;
	Wed, 18 Feb 2026 13:06:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67778C19424;
	Wed, 18 Feb 2026 13:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771419982;
	bh=XFxLmYJpOQUoGc/jsLto3GXjYYXTDz8YQNFIGhVm3k4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cELbw2+WihSjaMuD2Xr+N5BGaoURaaKZCyZBt71eWg/syY7Gs2leHEOlYvAxlTtDx
	 qsIMU9DeQtMQh4qDdmK7lr2R2zVmj7NXgNjeh8chO6W1NGFiu3DI4vVT2ns+rfcIbc
	 8Qsomh5LvToy201PuudKb2Lz+vdnICDLFhIGTfDXL3g2vrWEUe2GcsjDDcEw09F6zv
	 tBgyB3fvR/dn7u9SxFor9FPx5nWpj7LCJyhXEbqSVycdM1XCakt+0nVtIPEY9YNzPA
	 k+XIMRIqhAz1in8UfSY4D9sZXdlkd1mQTEa9QT+UgD1doekdPPv0kz6HJtFNUBDcuD
	 5ZOEJfzobEK1g==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Jann Horn <jannh@google.com>,
	Liu Shixin <liushixin2@huawei.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lance Yang <lance.yang@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	James Houghton <jthoughton@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Uschakow, Stanislav" <suschako@amazon.de>
Subject: [PATCH 5.10.y 5/7] mm/hugetlb: fix two comments related to huge_pmd_unshare()
Date: Wed, 18 Feb 2026 14:05:50 +0100
Message-ID: <20260218130552.55727-6-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218130552.55727-1-david@kernel.org>
References: <2026012610-absolve-ducktail-3c64@gregkh>
 <20260218130552.55727-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a18pduukzrfpft9431im7y3okgyxasqd
X-Rspam-User: 
X-Rspamd-Queue-Id: 217CCA0006
X-Rspamd-Server: rspam01
X-HE-Tag: 1771419982-114068
X-HE-Meta: U2FsdGVkX19UP6Ko9BcR8rd7mCjVzDZAsV8nBmqNRvPZB64QjYlMg9ZBNAdRNkJkLQuKUgxrK4MeqNiKtrj0euoQ3/qFJJIIwrCQ7AUt+cV/cAHZIOSHY2TukuHsaVGBzTbm6XwsEicHWyhL2QQ/83C3OEr+/f4s70zfePkYvEswVHIS5QkBdFnkcmk9kOayiMlQw1VzfMrr8muszmsp5l/ZwKi55Wej4YgRZfyv9Q8Ck0iIWFsBQIRttgcZwDP3QORCAfZiLqobrKWhc/Z0yN+cYI0Vec5GjTDgJp9gmsTJz1Y2SdBfYa0LLalnM2/mC4oQfcQ+yvJFllnMw7eRNDMibV8v7Zpu9eBhpJlMWRNOWQ6zV6V35rBqNSDEec1A3RPAkPFtAsiJmvcTR4nlHiIuR2od+mDgoTCa2l1KjuKRBfKiBNu9/VRx+gnaVAs/DAhDNFq+iadxJ+W/wQajFJavxkPtvsZ7fJdSMVepEHoELfy9XswtWWwFHdK7UN0PI0ntKhiUcGt4fkDKSmd51M5J+j03KKaQis3XICda7VUPs0zEPG4nRe542IGzeH0xmWEB0ZnB/rx4hjWbMOc1Sqm9e7lWfEE3sfzHPCfHesl5CAkrUZ9FxnkGVDriBDCntAXUZRdpiDkwJL9hlyHB81+2TudXxQ76t0a22GEM8EoRCXs/sDKah1fSQBtUoS0jue6pCyUGRDShVabG3sTmXTe3I2Uzajg8W4OJmwhRjl33r5SXOIN+DInvwQ/YEbqcEEUS8LD5oK5B9smd6VHlQlZzgY/y4t2iKnKIWBivIG3khvKsSJNWLQ6J2a8lnhkn8FXUAH4oPVW7RvlmGS1r20tE1gPurG7zm2suCmwC0m0X5woFsGHb10oy+3+b7w4sDP0sCQNPmxM01LmXPgV3dv3kP8u/CcuSrpIDw5BgJFG+Sype1+OZh6ix9WjkozCD69ZP7x1Cq7pQP/NaXe+
 j6iYiCX/
 If1Y5ez5rbUU47M3Y+4z+og8nBg5cBjY5QgmAcmuCBa/y6N9URZsCeVwQaREey3PbwzXf6lQX+RTR+oWi28y1OaIhE8dx0q1STBYUUhpfzDCwqB91isWD5cLamD9Ed9M4fpsewEsnwLnSnA4lXjwjMnzJNqpfKRwEDpc83RJMneHGkoabwb8xfrRZIXtsr+AqDoI2rUdquO/Bcyja5LG6nyeWCxkXxSLgVqGmOtMbSkRjNFRw3SQPr/gsFyvlH3rhU0hNIxmIyPf23kU+KuA0E5ke6NB+8UPlBNoyOa+7CFug+CW9QCs3WmMvAE1hjZql2kXbXIny1dzeX0RF9uGfWbGnEJI8vZI6h2ywnpN0zl+1oX6025oJmRn4EmSbTgUchdcDfhvueK/4+ckPuYUGoBcAFLNpZLCdfGPmW8G9W8yKx/f8tsF2SZDhO8clgMtaqUFrOMXVtDTQr83+eMEhE1Z7Ig==
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
index 8fa34032bc17..33302279ab5f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4027,17 +4027,10 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
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
@@ -5113,11 +5106,10 @@ unsigned long hugetlb_change_protection(struct vm_area_struct *vma,
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


