Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712F8606A324
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Z5e53RJF
Received: by kanga.kvack.org (Postfix)
	id 80F2F6B05C3; Sat, 31 Oct 2026 05:42:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E73E6B05C4; Sat, 31 Oct 2026 05:42:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FC7D6B05C5; Sat, 31 Oct 2026 05:42:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C7BE6B05C3
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:42:38 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC6C3405FF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:42:37 +0000 (UTC)
X-FDA: 85382431554.21.D866C2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 156D5180004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:42:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z5e53RJF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PCXji8t2YghBn8zNO97WnfB06mhFIwWKCiaxVt0zvRk=;
	b=COYWa4/R0JrNWMJ84C4zGdkJLZVllYBX8LvskCyR2gV/+VjRV1gl4j8xh1V2/J9LQdnXMc
	w8rmx1oftVL6XcBsaaWM+O7v8UznC5+VYbULtS9lN7zXAyyJUlTYx1IFG4kY8FN6r52M9b
	bBHNXo9jIgGUrS7pCg+8aeYd3Jx58ys=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z5e53RJF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439756;
	b=CqwOWu/H31OchDrpCaOxyBGiHUDjH2xaVowT2HddfBi7kiOZTamMHUleRG6kI0RgCghwld
	V83mh3vYpWWIMwJv4k5Ko1PH0/KWivZpnrJXoVsH5ltlnl1VcNnVeU1gKiQitnt+I1xqf9
	tHCjqF90fkOSskQ0WyM5HWuai/HvMsY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 904B8600C8;
	Sat, 31 Oct 2026 09:42:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C6831F0093A;
	Sat, 31 Oct 2026 09:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439755;
	bh=PCXji8t2YghBn8zNO97WnfB06mhFIwWKCiaxVt0zvRk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Z5e53RJFYXZm94nrWWOWfz98i5n0k7Vq1mlTIUq5K8+xJc8k6dpaYYzSZsF4CgBGh
	 v4KYqINsYG9kt2cDdfKy0eTyGyYpv6J5W5NiuEPWdzqHf88nGhb0V60FfXxzWiLdX3
	 QmdhnZrltq4DP3/sy1XSUvGTC8FipG5eXCbz9AOB+hjr5+MIg4VzYpuGk4ssaJpufB
	 TQO0s/RKG+JX4ALqjZDzvmreezhmYOe5sHjpVmP0tZoPQLouAFH7bKEQyTb3phuSOY
	 jUGQIHVgorDoKoHm4liePBrx/LWneHktnw6p09RxrbfVYcoo6un0Z7fj/dn2+TFapn
	 MVKDKVJ5kogzA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:38 +0100
Subject: [PATCH v3 09/47] mm/rmap: handle device-exclusive entries in
 folio_referenced_one()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261031-fixes_core-v3-9-d6437171ecc3@kernel.org>
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3393; i=david@kernel.org;
 h=from:subject:message-id; bh=glmREPecf3Soxf23A8cAtJsaeHFT2ex5UzHoQI9g+28=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk8TXHrRW3j5ImPXqRM2+EWeLvBgOzKltzWl/Yf1J
 /Wu2evmdpSyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjARpheMDFNaAhtDhL1kNO1c
 dGdue3/ixn6rTU5ud9Ss+l5+3C7szsbwk7Fgs0P+Td/7KsFuhndbzDKmPefPbc5Li/3Itfb6dNY
 p3AA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 156D5180004
X-Stat-Signature: wu6z3f5coscess7rpwhh1b1a6wq8fqif
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793439755-610496
X-HE-Meta: U2FsdGVkX183TBB8FkHefS9+FrXoD9I9oiJ92JArgeFO67iThz22aYjQDA42OZmFD9EHCkXct6wFX0yb8IvG439+9FC+IZ6uP/GBimbYAxJgVJHNMxZJ3OGtrCwDAG8AR9SSIk66cbDc0bd/+XLj3oQZtUws96y4MO+hpGSA7uLUotd9O4OXP2KKPRiAoHKLf7tGebsI1VfEIxOcvOxnhyqzN4NA15YAvdR0vL/rfBnDIQL9gAxzCch3ierrciXWpuRG+Cm5kpbRXmvcPpE2gx48JJrBUK3tRtBc5ZbFWb+yyOTmUvYBS+PGdmlxpHvHIen3QL/4bRo9i2Fq3q5jghcfs2bDLaPhh67oRk9GXyZJByDW3snE0t2hZBO9leCf95l0KPSVtw4D5hvRXwvR+NfrKC0nRwq1AD1dMGgITFxMSXRjaaCab8LIBkhSBtls1sOaoLyFbZV3vfl6LWejXmYGQbxVuY+YFAT+Z06ZYVkUR/Ziyd1923EDHXEUotD/dFuORUuOrrIzhQpMX541jjWIK8Bd4DIxXQMv716B3VD1e5oRSEkRdvlptxb75QsFj40zwjA8gFCsBDuIe39xgad5hCgr8wrwti1CFyzA+btl5MqK+t48lqEqWwG3FjyGvdRiM7fjQkDwc/IyQ814S4ZKVr/nnuBom5icgq1CdFtkLYmkQG9TX3f6I2heY55ydG7tEX1h8nTO7V6M8A0bIuWeYlDm1rpuIHfkvK9yIftlw7gWXXn4dQpz7u/4UL4+OzcdylXz/Z0ROrvf+Ja2iDG5IatRjI0yTB58sxITZ0/Ueqfr4xFlZyjqvn1q3OymKxVpH00m0BBkKz+CQ//mdzgsyZqFfRMkIkT49gBC1bdIGDitSOnzhbDNM4H4J3BpWumttxJPaz01p2MYal6Fom2DHljQY9K03VHPPq0QyJGuasZDpJQBJQ692osbIXKua0fGEtInud314IkqVtK
 +XehCMd8
 Sg/garaWq+z+hh3J06zCKGTmAjWxgX/N87wQbce1stcpbsC5QZsxC/NNpWZX5huFpZeLWmz3nwEVFx6DBxTMwQ8TH7OtInb5EITDrPCk552cpqYAbghOktRANggNROr5w2Dw7tD+YwOADJEmHoZ0Zzt+LUIPzLzvioA8SgovIpbn3mDgFwwuXC1W0mhLQeH+TgRKFzVPz/NrtQ5YojEt07hpbFz+IJDZ3iSFUkZaITfNmerLq6mxNBLljl0cRAYq+e32K1BXlEwW+YxL30Pvrw6lnwP7l26TLqGlDHqu6xDWORF+yz+sLo7pm7lO/jeibzPAy8iuDMjJGxbfsUABkdDYEr70quf4plZyCj2Qqr718Vd+xh6GU4xgqJYd48Y3snZlQlyJ3bDVZ8baMvimqPfL4rStFLuzhDuX7U5bbmbhJteZ3C7YHd2sth3oaL4o0GYBcpVXhkivIp/jv8gJL/yYazoOC+EbIxMa9K3oWsywkcqYg4CAit6Ce3hl7ibPetJhB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

page_vma_mapped_walk() can return non-present device-exclusive entries,
but folio_referenced_one() passes them to PTE young-bit accessors that
require present PTEs.

We must neither call clear_flush_young_ptes_notify() nor
folio_pte_batch() with non-present entries. For example, clearing the
young bit on non-present PTEs can corrupt the entry: on arm64
PTE_AF overlaps the swap type, so clearing it turns a device-exclusive
entry into an ordinary swap entry.

folio_pte_batch() will VM_WARN_ON_FOLIO.

Apply the same approach as the previous fixes to e.g., damon_ptep_mkold():
treat these entries as old from the CPU's perspective and obtain their
young state through the MMU notifier.

Skip PTE batching and MGLRU look-around for non-present entries, and
don't modify non-present PTEs.

Fixes: b756a3b5e7ea ("mm: device exclusive memory access")
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Cc: stable@vger.kernel.org
Reported-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Dev Jain <dev.jain@arm.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/rmap.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index 1131b76bbbc28..0faef46806e5c 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -924,6 +924,7 @@ static bool folio_referenced_one(struct folio *folio,
 	DEFINE_FOLIO_VMA_WALK(pvmw, folio, vma, address, 0);
 	int ptes = 0, referenced = 0;
 	unsigned int nr;
+	pte_t pteval;
 
 	while (page_vma_mapped_walk(&pvmw)) {
 		address = pvmw.address;
@@ -968,10 +969,12 @@ static bool folio_referenced_one(struct folio *folio,
 			return false;
 		}
 
-		if (pvmw.pte && folio_test_large(folio)) {
+		if (pvmw.pte)
+			pteval = ptep_get(pvmw.pte);
+
+		if (pvmw.pte && pte_present(pteval) && folio_test_large(folio)) {
 			const unsigned long end_addr = pmd_addr_end(address, vma->vm_end);
 			const unsigned int max_nr = (end_addr - address) >> PAGE_SHIFT;
-			pte_t pteval = ptep_get(pvmw.pte);
 
 			nr = folio_pte_batch(folio, pvmw.pte, pteval, max_nr);
 		}
@@ -981,11 +984,23 @@ static bool folio_referenced_one(struct folio *folio,
 		 * are. —they could be on active/inactive lists or on MGLRU. So the
 		 * simplest approach is to disable this look-around optimization.
 		 */
-		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte) {
+		if (lru_gen_enabled() && !lru_gen_switching() && pvmw.pte &&
+		    pte_present(pteval)) {
 			if (lru_gen_look_around(&pvmw, nr))
 				referenced++;
 		} else if (pvmw.pte) {
-			if (clear_flush_young_ptes_notify(vma, address, pvmw.pte, nr))
+			bool young = false;
+
+			/*
+			 * PFN swap PTEs, such as device-exclusive ones, that
+			 * actually map pages are "old" from a CPU perspective.
+			 * The MMU notifier takes care of any device aspects.
+			 */
+			if (pte_present(pteval))
+				young = clear_flush_young_ptes(vma, address, pvmw.pte, nr);
+			young |= mmu_notifier_clear_flush_young(vma->vm_mm, address,
+								address + nr * PAGE_SIZE);
+			if (young)
 				referenced++;
 		} else if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 			if (pmdp_clear_flush_young_notify(vma, address,

-- 
2.43.0


