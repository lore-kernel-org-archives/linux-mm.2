Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F2E4606A332
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 18:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BJX0St54
Received: by kanga.kvack.org (Postfix)
	id DBD486B05BD; Mon, 16 Nov 2026 13:30:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D95E96B05BE; Mon, 16 Nov 2026 13:30:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5BFD6B05BF; Mon, 16 Nov 2026 13:30:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 830A16B05BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 13:30:44 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C87B41C2AD5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:43 +0000 (UTC)
X-FDA: 85441823166.01.BE4C83C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id F40A21C000E
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:30:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BJX0St54;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794853842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M/EvVqPPmCZCcKVeR3NdpNWETVcV9F4mtjWBr1K1Fac=;
	b=T2m5LwR3EbLuzf9ga/VbbOgxuxN6RNFdvNyOPVwgdekRjBrYQue6yCgRmUuFAHK/8t5AAs
	BphVVPZft2Rwwu3a9GhxQ9vEP+2hGaVKg8M13wf7+JBe0WK6ZqWD0QDBIPwS2r0zgEzLC1
	Ijp8aurw0w8sBb2qlwQCyzsQlaeFRYE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BJX0St54;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794853842;
	b=pXojtgtPoPmRwSNKCY0G8TvrXG9p4aIgBEU2uNKRt1y42a5IT+Swes5jnYZlwr9ueXaUCA
	DLUj4A4ntbdUASco70/t2GAfq/cOdVfdAL5jM+y+0IS2piHg+bSQwdYYeSIX91lUVYmhxQ
	5j+G7WG5ED2zug2zI7BzcmK2HsXXu4w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4CA0C43DCF;
	Mon, 16 Nov 2026 18:30:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A13BF1F000CB;
	Mon, 16 Nov 2026 18:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794853841;
	bh=M/EvVqPPmCZCcKVeR3NdpNWETVcV9F4mtjWBr1K1Fac=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=BJX0St54r0eyFgfrrTGabY2Ky8SRdxy27FtZljILl7LSaa1m7IpomKvFfwQnugQDg
	 f+Qppe5eJ7DKAENfq+CHom7h77RkbjprQtUQ2uPHrz5rgcA17y37plUUUuSo0biAA0
	 O6JAPTMuN0CBQjA7NXdIKfBUp67mKfUUqu8+3iRLqJ2pULSmLoDhWcubfzdRqORkge
	 3xu5VVS3Uiq6s46G3jEHfp86nGYSbsKuI0tJkk3xohc23ezvGGr2v3/UzDChxvZUPo
	 2AyPOERdNDticSAW65tfGIreyPnk+68orni4JFQ3RqfM+TSlS60ve3ErRM90Z1RvUL
	 SzhH89h+7likQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Mon, 16 Nov 2026 19:29:27 +0100
Subject: [PATCH v2 06/15] mm/hugetlb: fix mremap() racing with page
 migration
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-fixes_hugetlb-v2-6-4dd9e94ea9ac@kernel.org>
References: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
In-Reply-To: <20261116-fixes_hugetlb-v2-0-4dd9e94ea9ac@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@suse.de>, 
 Andy Whitcroft <apw@canonical.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Dave Airlie <airlied@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Peter Xu <peterx@redhat.com>, 
 Breno Leitao <leitao@debian.org>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Gerd Hoffmann <kraxel@redhat.com>, linux-doc@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-s390@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3798; i=david@kernel.org;
 h=from:subject:message-id; bh=ffMP6p7X0B7O7y0oXzxGIwviCt5laHHSvycoU7Pl2jg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLJ+e3ccXaNxO8NOT7ovct2mU49nMs0LtjqVHLFZzzv5/
 7r97A4lHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAEzEloXhn/XdA1u5e1PaLGzP
 cRfc/pgcdXNlRRPzcTZjrjntb9rfPGX4Z7Hk6rx7/Q/dpkhZyNSctv0atm/17kq2HWzsu4pCxI1
 iGQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F40A21C000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: b6xcxfn31cccm1k3sbwb3ptd5k6a9hg8
X-HE-Tag: 1794853841-652197
X-HE-Meta: U2FsdGVkX18XC0Txka56r6CdGPBGWrpDc963QkKtkT4zstjZWNIjTqRHwVmXgqUhAYRmsQUYorrWHb90HVdzXEcGqRGJRjD1nEjDOSDVXIiwZ3Esf4rT541ZJYAzvNLalRPcigqwnw4qO6tQGRUgarIWSpOWN+kcKlq4M0C9EeKI5Z2firdiD4LBatYE9owcNjVrDqPVpG5Nb7+OCwi/RPrfmTq8iFZGvG9r+kAE2zScAfYewgLU7SnHPw22DmrzyRLPT2N325h8gF0//9sZBsm1umojud1QakHhBm1t1r4GD64zx1ZJuhKBg60+lVdzgyqZbCwwX3dVZTCi9tLn+pU6l5tEqW/i4LBO0pykdhmSYza1DOHrBcXvzJusGNgE2ZgOv2mktPvpfswuSNYBWxdqvQ3fxm//w/bijwegx7/NbQ31xMZ2jar+jmJ2149j0Z+yDLjQr6qSXsZLpC+kBeQRfTASv6mKlERAhsMfh69rEaPMg6IY/aFRSoTvBWC1Thg24PLw1VOMfpqqTZ2UNIT5rnxyywTVURRt1pPfaz2NSWnr1ux2FwbHVzS++lkmT6qXEWRaZQf3a9gVCtvqZQR8Yx4MgGH8iI45h9D3LxByaEL9Kakan8jEF4NarMVBk/SbYXuGmwGv/hcfEUTuJGWz7jmNqMCXsPa7cogLFWNWMxP+FW3BNoo3vSzQ8DumvXKA97qq7woDKkFqlJFGvRyYT4twx8OTs3CCujNaRyDGPVPLhFg42RRN0XhDuHnYc8zCn81QmS2D91vF9GRFOmRowok+HcaPfh10kAPpLHXn+TqGb9fE+HmV2YwXgveJDLxoWbXDU7TvEeCIixpdAMy0xWDpzZitPK+NGELWOIik+srgtnhkObW2LaydKNeAG9q4K8EipYkCoBMjyxkvPV9/AtRrVA6fUX9mpLzlzwyk/l8wdCHU0Bmq0txqg0jzGFfaflEr2jOtPn281Xe
 wuMPHMK+
 8xDT9UfABtUVaYzUbMVQjTYTZ1Mi2bCn8tob1RSuWq9TggoFse0SJTmoAHitQ/+UwvanQ87yC7wqrfTjCsCQFEZx63sspvAbSiAuspEukK0q1roPsgCz4fzBB3bgqI/QzOxOY/YP553H/ovoMfxzOks5pUU9wkniweYz+R6EKNqzG/xHe2C3+yB5NH3c67G1k5t2q/+JN/L5p7vJjJN6fcQlI2T5XfzDAsZUTpvEgrV+BWp9JbLjIVW+AMgry2xCd130GoXqm/ccTgI2sFvB0cmvTHNeqihAuIA7G9BnYcTwf1R6/BPRSqMpO0ueAUFCebpYv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Migration of anon hugetlb folios walks the anon_vma, so the file's
i_mmap_rwsem does not serialize it against move_hugetlb_page_tables().

There are various issues with that. Most importantly, move_huge_pte()
releases both page table locks before the TLB is flushed. Migration can
then find the destination entry and finish migration, reusing the old
folio while the TLB still has entries cached.

Hold the anon_vma write lock across the move and the final TLB flush.
This also prevents concurrent rmap walks from missing entries moved
during rollback.

When we must allocate a destination page table, flush the TLB before
dropping the anon_vma lock, then reacquire it after allocation.

Dropping the lock only works around lockdep: hugetlb folios are not
reclaimed or migrated by allocation compaction, but their anon_vmas
share the lock class used by ordinary anonymous memory. Having a
separate lock class for hugetlb's anon_vma (like already done for
i_mmap_rwsem via hugetlbfs_i_mmap_rwsem_key) requires more thought.

There is a concern that this can block page migration of anonymous
folios quite a while ... which is not really different to what happens
to page-cache folios today. If ever a problem, we can temporarily
release the lock.

So let's keep it simple for now.

It is a shame that hugetlb has to implement everything core-mm implements
in a different way that just screams for problems.

Fixes: 550a7d60bd5e ("mm, hugepages: add mremap() support for hugepage backed vma")
Cc: stable@kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 3ffd87eb9e45f..4a24819733730 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5214,6 +5214,7 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 {
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct anon_vma *anon_vma = vma->anon_vma;
 	unsigned long sz = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long old_end = old_addr + len;
@@ -5237,6 +5238,8 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 	/* Prevent race with file truncation */
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
+	if (anon_vma)
+		anon_vma_lock_write(anon_vma);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		const unsigned long offset_to_last_entry =
 			(old_addr | last_addr_mask) - old_addr;
@@ -5276,7 +5279,20 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 			continue;
 		}
 
-		dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
+		dst_pte = hugetlb_walk(new_vma, new_addr, sz);
+		if (!dst_pte) {
+			/*
+			 * We can allocate memory under anon_vma lock with hugetlb,
+			 * but lockdep does not know about that. So for now we simply
+			 * flush the TLB and temporarily drop the lock.
+			 */
+			tlb_flush_mmu_tlbonly(&tlb);
+			if (anon_vma)
+				anon_vma_unlock_write(anon_vma);
+			dst_pte = huge_pte_alloc(mm, new_vma, new_addr, sz);
+			if (anon_vma)
+				anon_vma_lock_write(anon_vma);
+		}
 		if (!dst_pte)
 			break;
 
@@ -5284,7 +5300,10 @@ unsigned long move_hugetlb_page_tables(struct vm_area_struct *vma,
 		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
 	}
 
+	/* Flush pending moves before allowing migration to walk the entries. */
 	tlb_flush_mmu_tlbonly(&tlb);
+	if (anon_vma)
+		anon_vma_unlock_write(anon_vma);
 	huge_pmd_unshare_flush(&tlb, vma);
 
 	mmu_notifier_invalidate_range_end(&range);

-- 
2.56.1


