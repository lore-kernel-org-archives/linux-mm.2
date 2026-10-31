Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4998C606A33C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:51:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gARMRHKR
Received: by kanga.kvack.org (Postfix)
	id 5D63B6B05F2; Sat, 31 Oct 2026 05:51:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5876D6B05F3; Sat, 31 Oct 2026 05:51:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479176B05F4; Sat, 31 Oct 2026 05:51:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 17D8A6B05F2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:51:30 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AE47C0953
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:51:29 +0000 (UTC)
X-FDA: 85382453898.09.E43299E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id CC55FA0005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:51:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gARMRHKR;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440287;
	b=U1C5EEq7Wjbg51oYDFMgdBOWtyHe4zI90ZQRFPG+gYeZzS+LTljg9Auimp+Mup9a/wC+2m
	Ue9hsHaT+NQHjezkeABORzBqYP8cJyc7HmWQKXiaHSguitQ7b9D9UYi+GmXkB3BKj6vTib
	kotfu+L7DZOUUYWZchoY7pW8CtKnjP4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bt7ehAYquGHqadXRoM20dpnXtFEOJTcVdVq62A0TzPE=;
	b=DwstWy96twHHin0OzjcnWxjvmgZgA/uFTdd2/bun/fOLAkgPZ4b/9OEARUDubcHw2PMUlf
	+iZOPs9GJBlZpo3kpEwey6UnCPJoER/FNye24tzE1UL2ax7W9zmTjeYNvv6f3daje2JLAv
	Gh2pwFJqmKP+4J7nPY+hI5lIvvuVxgE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gARMRHKR;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1045C417D9;
	Sat, 31 Oct 2026 09:51:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A3DA1F000C1;
	Sat, 31 Oct 2026 09:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440286;
	bh=Bt7ehAYquGHqadXRoM20dpnXtFEOJTcVdVq62A0TzPE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gARMRHKRSZW+Rtn51q/B3p7bChiPz7SGx8rC55xE7b3IrYX8Hj8UEXyO/8oTRo7MA
	 tclLcy+C+oiRiDlftxUmjcKLtHhFhBeCCZPB59ygvtYYk4k4lnQh81+p9hz+VLyt/+
	 wTZMZmGtCUYvka44gGyB12TS5bsKX6mMQTMDmeUqN0Y1O7ljdslf+TFxMvgcQQh9gS
	 7u+2MOe4G3It29EuWxOwZ5ZDqYLwjFzMEd2gDHz5Jl62fvUEVdcYz4zD/FacfohV3z
	 sts78ZnyYnNydgh9uoToJ2bFLqDddPMs8ZZWlKoWwu5KTbRMp+F6aUVpT1gWwEF3pp
	 ZF4J8T/RlvAmw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:12 +0100
Subject: [PATCH v3 43/47] mm/huge_memory: split huge PUDs when adjusting
 VMA boundaries
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-43-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
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
 stable@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4044; i=david@kernel.org;
 h=from:subject:message-id; bh=ux76JCpmRxhgE3mwKD3Uu8GXf+p+Ys6S4PuFPm9MXlM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs/S1Hat1n96YGfGsWoN9RPHS5TWzKv4P6HUg5X1L
 l9U8+UZHaUsDGIcDLJiiixBwfcNXr5cV1vtxscMM4eVCWQIAxenAExEIZjhf7V0KNe+grtTFm9o
 mRbyMLbjIeeboHlP0j8Y9QbyJGnEnWdkmPpcvVthq8WqtilXkzatnytud3yB97UE1pZbBe0TqkO
 PcAAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: ps53af655akcy6qc8q38a5oywfk6gb34
X-Rspamd-Queue-Id: CC55FA0005
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793440287-757610
X-HE-Meta: U2FsdGVkX18GFk6J1zupTXbXsii5VGaClQa18betRoYes5ARep9navT/R0lDCt30mp+N69PSckyEqymqT58YiQqLg1U87WDp9qNwitHpctLMMdHQdzktMH5RjNTJ1Zo9a81gfVQkvEyNvOFzkEzjbTVTBMrK4GhP6Jmqf69xIeifGwU2zoB1rrval2sg4QHOLT/C8VWvERDsVWus8JwGk+EtrwbVjOjvI+AtMg1/pFhSJDD9t3hHrxzn+Lt7Fnv6X8nFKoImMunGlC6axktydE8psacnyVTgNnEefgGjAaK553A213VbDckQQg+5ycIdisv93/PXa+GXW+F4wtjrFs2jrPWWysEwqfqVIp93bCSyRDb+pWxiPvbP5PTQShoeDFBq9A/8pIlJ2LHFCPuh/oUprdu1DgwV9C2y0BBeczxsMyclLbccC0Uv0fduRiq6AdPmM9fb0FkodbPWCU7w0Fz2ciiMAw0gMLp6so0nKxvNx+KBZishspGg7Ybm08wm6wBjtVTD1RHFRvaOdlW4nHYNTNzuW9Y4Acjpy0AuolFIyPosvj/FzTlmpTRlnenCOc/cjlFhIgAjiWA5bv1Mf1ghu1RIUwrmq30dGVyNdeww7mEuVizQkqt7iZqnC8SZNFQgZOCyv4fumjSonL6ws2S6PiH6zhZwwbygg/DKZ/pHfYrwrPaljZ4MtcGYhg/s+Hed+b3hrrmKrQZ08sjdJVk6RAhz6rwmyS1WWaG7o6FLn1Hmbw6rVOOS1ARPJYshgNoFJTXevNIZWNmd/GI/qi/lNY05mUGvLctrYsqxi9F4aBvnQRyNpVA3I+sI4YE1vk/5Gv8O5aYK6XffRXLCWKhpcywRIvB62E5+nEJBrvh+M7Yd1lgnHbdJkQdDEYwCPrwj4kh2zgElgKBjLeNBb1+X9k+sNSXmhjxA7dm/KGbKqm/bQbqLujM5TIVBDxa8/olsLExFUw5D3BznmRZ
 xZr0kOFf
 tWE3zMoH44w+jlzu0aPbKJQqpLN6Zefxu9enXbspWf3gSueMmQPqnR5M82ZWbUyRYY9SV3pzVzE5dyMYKfupVJP3n2ZZTh3z6IJvWJViYDcdhTfwnAi4dDFav3i/jzPweRTQRAQHo5rWnUbu7PBcqYukrkl07ERGBda0M/Dv0z2QebPyELIxrDdSzHnm7x7B+hukU+qZKyxG3X/5VhY/F3figbH97mYkOn4NLZJpG2mhwuue2IalPG2umzEFwAgZnzFCTdqruunoK0o12VY1zt0BBfYcRSa+ExZDSl4twfjToRBJWiI1nCh4PDPVEmRiKNDrGbpOG5sy6QLQSAXMv0pQfJIn1yjgO8qVdbSpQhzMifij2JjgkQ20uiRZYBVMBk3TxuATTzpMDNwGuY0pxc1yKSGSi38oWBTsZyk7IB9TLh25RonsU0JUAubgzmcJc3cCvdTZxwEBqBKeJYJoDXIxiKiDOFRu53ZA0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

PFN mappings such as VFIO PCI BAR mappings can use PUD leaves while
allowing VMA splits at page granularity. However, vma_adjust_trans_huge()
only handles PMDs.

After faulting a writable PUD-sized VFIO BAR mapping, changing its first
page to read-only with mprotect() makes the PMD walk treat the PUD leaf
as a PMD table. Applying MADV_DONTFORK to the first PMD-sized chunk leaves
the PUD spanning two VMAs: the PMD-aligned boundary skips splitting.

Walk the page tables once at each adjusted boundary and split a huge
PUD or PMD leaf as needed. Handle PUD leaves even when the boundary is
PMD-aligned.

Fixes: f9e54c3a2f5b7 ("vfio/pci: implement huge_fault support")
Cc: stable@vger.kernel.org
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/huge_memory.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 10 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 196de7fe6b4ee..63607ff1efecc 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3504,16 +3504,66 @@ void split_huge_pmd_address(struct vm_area_struct *vma, unsigned long address,
 	__split_huge_pmd(vma, pmd, address, freeze);
 }
 
-static inline void split_huge_pmd_if_needed(struct vm_area_struct *vma, unsigned long address)
+static bool pud_split_required(const struct vm_area_struct *vma,
+		unsigned long address)
 {
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD))
+		return false;
+	if (IS_ALIGNED(address, HPAGE_PUD_SIZE))
+		return false;
 	/*
-	 * If the new address isn't hpage aligned and it could previously
-	 * contain an hugepage: check if we need to split an huge pmd.
+	 * Only selected VMAs support mapping PUDs for now. Lift the
+	 * restriction once this changes.
 	 */
-	if (!IS_ALIGNED(address, HPAGE_PMD_SIZE) &&
-	    range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
-			 ALIGN(address, HPAGE_PMD_SIZE)))
-		split_huge_pmd_address(vma, address, false);
+	if (!vma_is_dax(vma) && !vma_test_any(vma, VMA_PFNMAP_BIT, VMA_MIXEDMAP_BIT))
+		return false;
+	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PUD_SIZE),
+			    ALIGN(address, HPAGE_PUD_SIZE));
+}
+
+static bool pmd_split_required(const struct vm_area_struct *vma,
+		unsigned long address)
+{
+	if (IS_ALIGNED(address, HPAGE_PMD_SIZE))
+		return false;
+
+	return range_in_vma(vma, ALIGN_DOWN(address, HPAGE_PMD_SIZE),
+			    ALIGN(address, HPAGE_PMD_SIZE));
+}
+
+static void split_huge_leaf(struct vm_area_struct *vma,
+		unsigned long address)
+{
+	const bool split_pud = pud_split_required(vma, address);
+	const bool split_pmd = pmd_split_required(vma, address);
+	pgd_t *pgd;
+	p4d_t *p4d;
+	pud_t *pud;
+	pmd_t *pmd;
+
+	/*
+	 * mmap, VMA and rmap write locks protect the walk; the split helpers
+	 * take the page table locks.
+	 */
+	if (!split_pud && !split_pmd)
+		return;
+
+	pgd = pgd_offset(vma->vm_mm, address);
+	if (!pgd_present(*pgd))
+		return;
+
+	p4d = p4d_offset(pgd, address);
+	if (!p4d_present(*p4d))
+		return;
+
+	pud = pud_offset(p4d, address);
+	if (pud_leaf(*pud))
+		__split_huge_pud(vma, pud, address);
+	if (!split_pmd || !pud_present(*pud))
+		return;
+
+	pmd = pmd_offset(pud, address);
+	__split_huge_pmd(vma, pmd, address, false);
 }
 
 void vma_adjust_trans_huge(struct vm_area_struct *vma,
@@ -3522,14 +3572,14 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
 			   struct vm_area_struct *next)
 {
 	/* Check if we need to split start first. */
-	split_huge_pmd_if_needed(vma, start);
+	split_huge_leaf(vma, start);
 
 	/* Check if we need to split end next. */
-	split_huge_pmd_if_needed(vma, end);
+	split_huge_leaf(vma, end);
 
 	/* If we're incrementing next->vm_start, we might need to split it. */
 	if (next)
-		split_huge_pmd_if_needed(next, end);
+		split_huge_leaf(next, end);
 }
 
 /*

-- 
2.43.0


