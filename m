Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7F53606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=oDfG8JRC
Received: by kanga.kvack.org (Postfix)
	id EB51C6B05D1; Mon, 26 Oct 2026 19:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C006B05D2; Mon, 26 Oct 2026 19:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA20E6B05D3; Mon, 26 Oct 2026 19:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD70D6B05D1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:23:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3E8018086B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:23:54 +0000 (UTC)
X-FDA: 85366357188.16.DEC5349
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E83B100006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:23:52 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oDfG8JRC;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrWRwWI1TX1mcUZCYDX7YGV/LWEOTto0e1Zbca5EuMo=;
	b=1MBTbfWHF7RnGCUwpGqQhE8gUFaMS98H7rAnBZ4mjaS5yN4/azBXG7NQdb5gsstuqklZgi
	3IuHxdwUOTaoG6eDiIXfIG+2+oOJB7ZyXMOdceagDOJS7wT5qL+RMAVRvpXteaQ/LodI1j
	poOzriOUsn+aK7ShnilGdqh+yJnCZRE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oDfG8JRC;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057032;
	b=sGrDiDV92preWBPOx3e9xBaJO5vAH3vP9zqAvaOyJWLcMMotYKfXh5VQPZ+9LB+7aKVexf
	QuxJXMKBMtvD3x9KifEsD5jeh1EKFGFfYoC8+Z8yHvrVelwkI3/vZA7nv9dVpGFNe+WguX
	bZlULRYU2N6JflKhR/R0fsmWX/kCxAg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A570E40C2A;
	Mon, 26 Oct 2026 23:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167181F01829;
	Mon, 26 Oct 2026 23:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057031;
	bh=yrWRwWI1TX1mcUZCYDX7YGV/LWEOTto0e1Zbca5EuMo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oDfG8JRCj/HnI05JYJpdQeNsDVitwtOPsqwFt+Y3DiM5wFzRClDxE6A11o1/HZEfq
	 h14PPV5dH6x2rp1uZyFJOu841a10mxF/gCFopjhJg0X8cKhgjQFXxAMV+QRg5lD4V2
	 H9cn6S0rxc+ey7SCMwJe6uHugFTfTIZon+3EBRBaAQhBh+BZivcerCauhQJPkOFwq5
	 E8UaueuP28d3TSNTE4s0mf+KsJgxtw1fQ3t77075G5E1QAx7rIVJR0W1igJSkKKfOj
	 x9kkm86s2G0a5xY6JVZdpqPt7JLURP7bhcdXnG4ab/tq3//Tx9cB7jFElNIecScCS/
	 D3pNbzACczyFQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:39 +0100
Subject: [PATCH 19/46] mm/gup: recheck the PUD under PTL in
 follow_pud_mask()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-19-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3797; i=david@kernel.org;
 h=from:subject:message-id; bh=fBfRL/hNgbZlBR9ozQBVYIeZUTHsd1pHD95a8NK5vT4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu358qaqN8TWk+X4z5G7PV95qeTBPYdKVqHs+8GVlSn
 Zs3Z/+M6ChlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiLK8ZGVa90jZ9XaiRe6wx
 UIDvpS/zseWK071r3z9OWBMnUfRSyp/hf6pW8DKR59oeHRuNv/kx/XzHZGF/3eTr79k1uXvqY1Z
 +5gQA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E83B100006
X-Stat-Signature: zewxfk8hksu1ud9t6r8k1j5gqwyx8511
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793057032-134837
X-HE-Meta: U2FsdGVkX1/QjNxCtbbusGkPvrTdlsMgxUEd6fA/SXAki5NqPiTMxcPsO5x0wpkLxskkmH0CixRx6VWK+RqSKZDV2bsFSoGF/wNE2jZqLPpsFaiBz7xdOyQ/M9fE7Z8PnwQsI7yd7q5AV8BwBRxzA7NyTyhFlonvQVY7c4xEz0+cNlD+L2P/wHGxFyMx59wuUnFgVtPB5+mmz1PgSaFvjXJZtXa4NTuJH/0WHzI16c9GDo1SWu04MfsT6DL+pyKGsTds151qg98PiC2wiyS31M0bL7wLReeT3qbKbNKGetxXsuVazBccjomv1pJ8HFQKyGnjf3B82W7bFMN4DnfXkWkuRX1aeEnmeuWCuLQk01wAYu1gV4ANTGqjysXX+UHZBpOjZNdPmHM+DJaNjL4mFhsrOQ+vCbI8WTIIBwPwrOjl9jFFtNXYM/E13K9YskqcpXb2x5c5F1Sql+GXiX8nCYZM6nWpTxXfy+Lj5d224HJbmh9M+7Lve0vfuRL2WTyofwfmEaKdiJcGUMJYFiWeafM7jlO5Uy7PlDXHgOVazWJvEzwL9ajL5n+TMUHAAey3AQ3vqD8327o+t/8YoY50myhteRC97UsAv37QWYpQrt4JOPnihx3/sNZP0TsoWLAxLdCMh+1/3ogDmETEeK5mnEQ32rfDPK/U6LDIOVzOBpO/lt9nJqkBMCYYX8nRfFqlojcc8zxYlaOEp/xVxbdxaehYIHwV6i+uDVn3q2XC0zpeLUdThgbRGnOqOXSPK6ofTkzSIqPJ8bctXJyttI/442uqaCDYS+Gdp5erHOzoRUzIPlRhjyj9iGde6jdiQXxNVMr7HA0DCFtI2g9wEz0Hcd3KOFQNHHNxIm2VgnZbmqEhq4yoIuVaMW2gFFlYpGYewByWFQYtxt7XUXuoc+Xwe7jhWtQEAwiZIRNraLfsYWlk6bRW76yQpm7gXOLYWT3uQLr0pchLeRraz+fGTqt
 Y+b8yeQs
 oTa46vXVRk65x63561yXpP2NyVVpmGHI2vFT5VnEx1VZOTK2RjhGbK4WGcr1cEgxSiPFrTgu6KeHPR6k1OjVUAlQ2kjsnYjbejGDIz7svNMq4GBLadMUCsMleKurcV/N61fm8o0QJCfNEMT0XnpG5kUbHazYwP/GYOCZkZOzBNPt++I0CoaEyo65T7fdt1irfdNSodKGsZKxSG92HNyoYsPbV3+xKbgoUpN5xnKEaUI1z0/cECSXtYKHrlZxtdek3lknKLPbpanSBLUMcLAWrxSQ4nBP4MVl/tf516eHsxINaG4WO2FXYaOu8hEXM/m9cpfryq1VCYXizG1t/wl6hfIhAeLgbFRLo+8MjaD2CYn4UTkWY/ou0yyDSXCFUBZuJkkbNd+3N2gwr1huXaq3D2hGyAqFfmtjsIXepdzGrwSGDrkk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

follow_pud_mask() reads the PUD without a lock. If it is a leaf, it takes
the lock and calls follow_huge_pud(), which reads the entry again, but
only tests whether it is present.

A leaf can be zapped concurrently and a page fault can fill the empty
entry with a page table.

This currently only applies when device-dax makes use of PUD entries,
and the fault after e.g., MADV_DONTNEED would find THPs to be disabled.

That requires a sequence like

1) Fault in the PUD
2) Disable THP
3) Have GUP race against concurrent MADV_DONTNEED + refault

Which is rather unlikely to happen in practice, which is why we never
received a report about such a problem.

Before commit 1b1676180246 ("mm/gup: handle huge pud for
follow_pud_mask()"), we performed that check in follow_devmap_pud() by
testing for pud_devmap().

Let's fix it by just structuring follow_pud_mask() similar to
follow_pmd_mask(), minus protnone stuff that does not apply and minus
FOLL_SPLIT_PMD handling. That makes it much easier to spot any such
inconsistencies.

Perform the pud_bad() check early in follow_pmd_mask() and just forward
the PUD value. We can drop the pud_present() check in follow_huge_pud(),
just like we have in follow_huge_pmd().

Even though we are performing more changes than strictly necessary, the
fix should be easy to backport.

Fixes: 1b1676180246 ("mm/gup: handle huge pud for follow_pud_mask()")
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/gup.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index f166acf794e30..efc9aa2654625 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -658,9 +658,6 @@ static struct page *follow_huge_pud(struct vm_area_struct *vma,
 
 	assert_spin_locked(pud_lockptr(mm, pudp));
 
-	if (!pud_present(pud))
-		return NULL;
-
 	if ((flags & FOLL_WRITE) &&
 	    !can_follow_write_pud(pud, pfn_to_page(pfn), vma, flags))
 		return NULL;
@@ -896,15 +893,17 @@ static struct page *follow_page_pte(struct vm_area_struct *vma,
 }
 
 static struct page *follow_pmd_mask(struct vm_area_struct *vma,
-				    unsigned long address, pud_t *pudp,
-				    unsigned int flags,
-				    unsigned long *page_mask)
+		unsigned long address, pud_t *pudp, pud_t pud,
+		unsigned int flags, unsigned long *page_mask)
 {
 	pmd_t *pmd, pmdval;
 	spinlock_t *ptl;
 	struct page *page;
 	struct mm_struct *mm = vma->vm_mm;
 
+	if (unlikely(pud_bad(pud)))
+		return no_page_table(vma, flags, address);
+
 	pmd = pmd_offset(pudp, address);
 	pmdval = pmdp_get_lockless(pmd);
 	if (pmd_none(pmdval))
@@ -953,18 +952,23 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
 	pud = pudp_get(pudp);
 	if (!pud_present(pud))
 		return no_page_table(vma, flags, address);
-	if (pud_leaf(pud)) {
-		ptl = pud_lock(mm, pudp);
-		page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+	if (!pud_leaf(pud))
+		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask);
+
+	ptl = pud_lock(mm, pudp);
+	pud = *pudp;
+	if (unlikely(!pud_present(pud))) {
 		spin_unlock(ptl);
-		if (page)
-			return page;
 		return no_page_table(vma, flags, address);
 	}
-	if (unlikely(pud_bad(pud)))
-		return no_page_table(vma, flags, address);
+	if (unlikely(!pud_leaf(pud))) {
+		spin_unlock(ptl);
+		return follow_pmd_mask(vma, address, pudp, pud, flags, page_mask);
+	}
 
-	return follow_pmd_mask(vma, address, pudp, flags, page_mask);
+	page = follow_huge_pud(vma, address, pudp, flags, page_mask);
+	spin_unlock(ptl);
+	return page;
 }
 
 static struct page *follow_p4d_mask(struct vm_area_struct *vma,

-- 
2.43.0


