Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDE67606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 20:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gx5kUXfc
Received: by kanga.kvack.org (Postfix)
	id B96A26B05BE; Wed, 28 Oct 2026 16:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1FC56B05BF; Wed, 28 Oct 2026 16:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E9D6B05C0; Wed, 28 Oct 2026 16:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8DC6B05BE
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:56 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 80E82A6FDC
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:55 +0000 (UTC)
X-FDA: 85373138550.16.7E6FDF4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C1F33180002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 20:14:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gx5kUXfc;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793218493;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aoGdqsTvzLA1760x2UeODapQMueGdwb7A8k2qy/4a8M=;
	b=YX8qxmfRgKPrnZVukeCzsw4vN3P89QqaI3BSru06zlqcxyDK82Z+EYlBT6HPmHy+nCRFVj
	QYAerCkUnQ22PzUX/qgwNZYjrFwx1R2tI7fL0m3ENaXoX83sxkaQOA3salHSizgvrPDamC
	JSvxHZnEmzp9TfL8LKV2mEL6VJZcxUw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gx5kUXfc;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793218493;
	b=5rvkvewh+vHzD1MLRr1OIInGud6vU/Smt+rIKJEfZuy2SPujfVjXvLIfR8/LN8OUlqhc5O
	fs1+z2FdLs6hbi8yNcU+KDZNk8fCdHug3JTq5TYHeZAflWu7Ko1EhpiqTljAa/jKlzDiE1
	0ZpTRnZ+3Jrb8NFNKx06ZU5UrhXbYxs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 58FE060219;
	Wed, 28 Oct 2026 20:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DD81F01828;
	Wed, 28 Oct 2026 20:14:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793218493;
	bh=aoGdqsTvzLA1760x2UeODapQMueGdwb7A8k2qy/4a8M=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Gx5kUXfch19iSs0VosFuRnCOol2TCuQBci3Yh4uo7Ahb4fBAy70eN6icqJVjgW7Td
	 wEUWghFTxvzygcoC+fYINVklUz87RmXT+kDWUItm3z3ykDitSp3CSSgkegkKePnudq
	 D6fTHv/KjjaInn7b3PIfy/LH8NcSp/G7gXh298s8/zhjeWeyY+vf5F0VISfpbvbU5Q
	 6Vp0khcsHBlB87Iiz9hz7Yb9WyGDwKoDKy9wVuDMZP6tUH/kibXc+g4T6mT0CdKLhH
	 XD9R8UsWl4JYQ6d4FfbC82iaqrYhZ6Xxn3Qc4bmom3HDBL4XJsgASn/tr9DpfHQqGR
	 R6HPs2vEJF9tw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 28 Oct 2026 21:13:34 +0100
Subject: [PATCH 06/15] mm/hugetlb: fix mremap() racing with page migration
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261028-fixes_hugetlb-v1-6-a0a033db180f@kernel.org>
References: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
In-Reply-To: <20261028-fixes_hugetlb-v1-0-a0a033db180f@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3709; i=david@kernel.org;
 h=from:subject:message-id; bh=nOGM/hZpyKq4A/tgBj98h+EqgdeB+UfqBF1GKLD20YY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIehZdOPRm1NHSHLe8co+kLjB5rdh/M5pVuldjxb/mZG
 76HDuyc0VHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBE/CMZGU7ceKzyfksgC6fi
 rPfmjOH/Mlal9X5eP7Nwn/7OS5MD268yMsxzcA8KvC92ZJbTxMlsjHt0n3JHC69bVZbY+PWzcGT
 dbwYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C1F33180002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: d1hwm7c7kd1i7p4qkaxbmc4e3uxqyogs
X-HE-Tag: 1793218493-985151
X-HE-Meta: U2FsdGVkX1/ge6936vZGZcG7Nf1sSQOvE/LdvGGC9azFy7jMxQUzZ6Zv414UClAzoKstfSPd6YfwNJQP1q3BCV16GxF7gL/X5QkDBaRIuIMLLy/GqaF7yt4r9FdvssbpRgf48bvhYhnT79rGojM+u4FV4ScbXzbKmzQai7kgyCJ7+506gMnSO+bVP23zjddrZUiKjxoHyMLT7X8wHZTgUTr2/zCUQYjHXiVQtQj+c7YA3yV/N/UUWeX9E8L0EiaqIzXbOtziOaCMf2FSBjkilZ9mIZQ9qmSQz6oQD/lvAmEH3/NRRv+ZEFaAOGA+PiHgzimR+vuUpLWPl9R8bdUH+SIykwyUwKKyIzEjwpuXoCrdd4fy6tGLRdGP+vzAenzeeYfKFBdiMYaQwkSPUs5hG9H6An5POSZQxNcXVjeS05XPDLDxpq9AzSLZLlYXtw/q87PdW8e2QaaUA4R/uMYqQRYGd0Y+lS+6ai1DQKzkyG8ATUn5TId3FkYc0G92MZGeNHFofLlAxUa/Dlyk8HySqQov/zHMMJigNwtEC99zyWTV3DuZ2etxxq/cA94lB8nQC+i8FMA5fea//7ofSS8Xg1NbJ8vgNAbDnb8fVKaKqs91IQ/+2AyWZnw7XQGFfB/t1hxyJL6G+DqsbAF5NnfuhmrYiV5dhDO5C11p1+grryeGiavz++BhGDtai7To4PT+FpblMO7m4G3p9pBvsN3SDcMjA+zgMUOEmZSXSei7tcMkzx4I9xU4N6YATK4dw8A6//ITjyZyxSb9nqL02JjvEqpVM4tOo7LMNCVzUCWH5Gq3UWR4o8F7XuWCOfimx7bmD7Tq86S0VPLDIJzC8JBO5kuOTfIAuAWL/JuAQXaYxO3Q4Vm3U1czvpauqfWRK6KhEEh2GL8yKf633APr5Q5ict25oOkc3zcdvWIrwM+FB5Q5cV8YXTT+wJbtAd0k/NghEn07d9pcpy3hasOMAvM
 89XTUJcq
 SSvaMIW9q5y1eiuEXWvLxmwG1JhfI1IDHCoyefb/fgf2Antb9XTRllTsOVkwYzItTA4BcW4Ee/2Kz/nHtUEuf2nPyqXneP+5Df7CDevwbMHHJ+JQ2jqrv1orHcoIOoAmApo039/z0aElND1WZxUzJo0m/9cJfffmGmBgUMSd5WPrnDtnLXe6/VOIpYy/YyuGwYurKysJEFCJ7mOkDuglRA6bjGVCQRI7sykwcUyUq+ri7eAKVz1twW86a9ycaWII1QtLPDymxv52mwaKARZfqoXzLHslnM1xk6MjYRtucX/fDFaHaZ0iyUE2IOaZ0NpkT6hjX
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 55f7d692ed0d..2fdd72897db8 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5219,6 +5219,7 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 {
 	struct hstate *h = hstate_vma(vma);
 	struct address_space *mapping = vma->vm_file->f_mapping;
+	struct anon_vma *anon_vma = vma->anon_vma;
 	unsigned long sz = huge_page_size(h);
 	struct mm_struct *mm = vma->vm_mm;
 	unsigned long old_end = old_addr + len;
@@ -5242,6 +5243,8 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 	/* Prevent race with file truncation */
 	hugetlb_vma_lock_write(vma);
 	i_mmap_lock_write(mapping);
+	if (anon_vma)
+		anon_vma_lock_write(anon_vma);
 	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
 		const unsigned long offset_to_last_entry =
 			(old_addr | last_addr_mask) - old_addr;
@@ -5261,7 +5264,20 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
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
 
@@ -5269,7 +5285,10 @@ int move_hugetlb_page_tables(struct vm_area_struct *vma,
 		tlb_remove_huge_tlb_entry(h, &tlb, src_pte, old_addr);
 	}
 
+	/* Flush pending moves before allowing migration to walk the entries. */
 	tlb_flush_mmu_tlbonly(&tlb);
+	if (anon_vma)
+		anon_vma_unlock_write(anon_vma);
 	huge_pmd_unshare_flush(&tlb, vma);
 
 	mmu_notifier_invalidate_range_end(&range);

-- 
2.43.0


