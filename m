Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85762607636A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 20:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=DDBzKqAJ
Received: by kanga.kvack.org (Postfix)
	id 9B7826B05B3; Wed,  4 Nov 2026 15:41:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 941246B05B5; Wed,  4 Nov 2026 15:41:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 724E26B05B4; Wed,  4 Nov 2026 15:41:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD8C6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:41:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A00DF1207FB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:41:41 +0000 (UTC)
X-FDA: 85398607602.26.969D71E
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf09.hostedemail.com (Postfix) with ESMTP id CFBAD140006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 20:41:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=DDBzKqAJ;
	spf=pass (imf09.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793824900;
	b=ZboeLS7MYzDNaR8ADgWG3wxD76uzLCFLAbg2gsjZehrAphBNtm6sZO5H9xYnRd5pL7gb4f
	0NI0+q11lewKS7SMS6YcutEO0RotwgLRGYqhlZQY48kTthMcI+tZJ6sbs2dfPR07tC41CF
	lfY4q23GwXwtP4L+xejfCO8Gh1DHQEU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=DDBzKqAJ;
	spf=pass (imf09.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793824900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3piSQtfQuOg8u1CZlEVUJlwdFZ/horJKCFdnF6JPx4=;
	b=C6Aj/cktr5ThDk/2tbCf1sROkqxVPPqwYtENN2R8DQQpFZ69LTw0+EGxkjXpCagkL6J+Cz
	yjlJbk4O2O0ie2WPaa8q5hQ7gfhl+XBBWF+RJxssAm9f3Ql/U7MqDWC1QzM0twYeKUxWFC
	HalUACTMMvn8cRweU6Qq7nqEwvRX0rU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=m3piSQtfQuOg8u1CZlEVUJlwdFZ/horJKCFdnF6JPx4=; b=DDBzKqAJss7bD2+bm2s
	P43Ux94h7IIe1ucOVYhz/ySnXcvWnMh9XoWdZm8KeW6DY/q73P2mKFhh6N+Ccv3TpXk4XShi5yDgz
	Y2er5iXun3HEJnILlYYWT4SenaR37N99ZrIjsn8ykdiwlkJqVcJ+VXfchpxwcvdia6CkmXLnujaV6
	B+Af3uGmljDQGYvGH0oG5c45wQz4wt4xmiAtWmGa8vAbHVnAXzTH+dVbQuU/uh5L9G2sGPvdI86F7
	6JlWBQi3OTBZk/QzdJ8AnEfyKzyyRCprkGF2Hh5dfyIPXGRyRGiNvV1rtR3vz7dwp272P6Dr1w3o3
	GrfBqrrkkMO03Ow==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xOhjA-0018X2-2O;
	Wed, 04 Nov 2026 21:41:04 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 04 Nov 2026 21:40:57 +0100
Subject: [PATCH v5 3/4] mm/huge_memory: read a special PMD under the lock
 in copy_huge_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-3-c56d0d26f970@virtuozzo.com>
References: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
In-Reply-To: <20261104-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v5-0-c56d0d26f970@virtuozzo.com>
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
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4033;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=py+hRT0j2W1iu9s6HX+poqDtbv0blfBMcY8NUrWKcd0=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq65hdLggzNygo5KJ93r3G6e7Ax8It/B3P0I8J4
 2DyVb7vwnGJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCauuYXQAKCRBRlgpH+WFc
 KkO7D/4nfFyvxkBgfdLQmB0YnnwJdSop86K3UxtoZgUM1vbtX2DXJsNtW9nEvRYTiUdPpkyfJWJ
 Zuin+uFVhJ0JVYdpt/UstEVsUeqs5VJ63zT0SQXGJJelixu8VtBEhRFxxT8nJX/R7b5NMeM6aCi
 cr9/Dve6+gKqvSS2TVDW3Kd98uh+MwKAHHGqzTRMhurwnUsxj9/xCtpnOIw3BrGpC1yB321PF2r
 zsr7MCVyUmc4O+P77YDDuNc6jZOh2+YPtkqgMaGdIsvQfX+u8h67SH+1g4h1jPCkTdNfGYJQBGZ
 GKtfplP4Igaoak5QdpyIdg7te9QrD+ddbX6BagGJakPfmFcQrAvOJjktlbByiAVoFVXOVuvg9Z0
 eY3AdCvvjWdB/VDGnWjyFWL9JfDsD2MIfXkSh7TxdKxMBlZLmyPXQVGfHHElY66LoEYIiXG1ztM
 2bYdW8FjQQ0zCDuMPw3VB8Sh5xGCQ8u5wiPexpNfPzbo+z0QcpMgf0BLXrzc9R0rs8ec4+Gh+tl
 aOm12Jl6cTC/aiva3Sqmd1a+VPusSoUssugj4shG6uiHmKd7GelE+oTcNckkN55nZvJqbBpgelB
 kyu23cA32rlq9Biyz9BnUUNhWUbRADxuXjNBqs+nekl1wlbY+0pdrF2Hfuzu6rt+F0IPt1heSL+
 3gvOLpNZWs7rJBg==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Stat-Signature: t7f45o9g4grifo86obxxhnbhozj1uos9
X-Rspamd-Queue-Id: CFBAD140006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793824899-938961
X-HE-Meta: U2FsdGVkX1+cvP/NEdR+E3lbmoO8IbB8nINiDEfv53uW27qFDYygRb/zWeb3K9HGgr+V/okh86odRcJcR+Gf4DEkjUqnJ1Z5eFD0CmZaCs79dB9+jUR/k7BUg8/GoyGU3us5f7BmagD2yNj00gGV+BZ341DBQd/SK179uuJrADYKY+MWQAuWzyq474dj0VCQ4mNjeNZM9MS4w01byL4FMalnsh68XEtc3CNdP58Dk5RDNflv8nhJ0e1cw7caffYy9MOcTbW9/WbYNX+ZZInU1P0B8GqGZlSSP0dxKeHTT+00UBgn72BFduNJGtkbLE6dRpd+YBjJXgpe+dsSa0ftFHwqpA81LtKLtJ1mZUGJZDlWHNg0Kgp6x8DvWwCIxG2IhlPc67jzIxhwP0hV4icml8dSYoNriAKq2jmmoxc83ZetSDUys8opamBPy+k/4u4Zo74W/wQKVdniU+XTcMybu051kNWuqh1zW/IPBaonj84+RQDBS4oieG39Qu1qkpQefc0ycmof5Db6QDH69TpAhhTnZYK4WBSjIZyaTrikLbscngxMWRtaXGa4dwr4H10ri22sTOJLHgQoNmdAdzZcA4aXYJfvs5zeVR6r4GKtNQKKuH8BhphkETa0xbM91RPE5tpQj0KotP+Oo6qAuVhqZPiuU8JawYb8Nb6fJGVeiRZ9stbABwz9VL8iRkjw2dlikuyg2k8IJlPV+Q7J1RBBxKCYIBz9SOK3ti8mfuqA91sYQZnTJBHyxn/n5UfQcpRA5GNRgxuW5crtS66a/kVagYq9u+GE/fDZg1uClSHqVv9E8NpGM3KtCoTmwLmGy5UM5t+hVvH4tTKvITaKjOnBS520UWDWMldpEd/YvDX1ljzvjs3+Z/yOTWAF1ZxBwMy4vceTlRogNT/Yt37EVfdplveZr+HZOS0LNewoU0eAoCtOzao97jZDZxtZ+J1JRA2AQzEFBREECKU8tGSv4h4
 OdEm5BVc
 8r0ED78jCxpASLGRMJ2OwN4SmUGaCvEQSlsExVJLoluxCUnI0tA3Ju1YjLswZj+CAlR4HU9Fbe92+GMRikE/gTwtzvfHMZ+GcF8bikxtGNSh2EbTz7vkJHNfPhjJZdB7KbMHjhVxCQ7IYetwBaNFKFW7QyNIQa8qoTd20BncYmM3G3P9n+0PDaivVlKuZNEOyD/+7CJIHpFbMm0fvhkLIsw246dkAhYdcSzUHLLh2zud3m6NZ1vpiVzsHUwQgZ5surSGEaRONtkQZ3gAqQy8yMh0+dirwm12lzeHuItlvoAYFom8Dhe26+VNgVT9TKeAFDRwsyUxLENDaB4IrrMOWbNnPQOj7PnI7SPckhRrhC7H4izud/ufWVrmNWfEA6mJB7DgNZitPcg0nqiWUxXHwruyNpsGEfq4vBNYlfFQvnmA1QFSLE3Kunykd7la9ZZzE0vufCPynr9AHl0K7PC2TASOuWigrWKlA9ydZsm+x4tZXfMqBUDDR6kN9l82Rma1AUK3r4b131+x/EHo=
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
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 mm/huge_memory.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e00632edb3856..9cb5f99aba87f 100644
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


