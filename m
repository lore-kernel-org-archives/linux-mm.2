Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4D44606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SBYWyFJB
Received: by kanga.kvack.org (Postfix)
	id BBBF16B05CD; Sat, 31 Oct 2026 05:44:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B932E6B05CE; Sat, 31 Oct 2026 05:44:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD01D6B05CF; Sat, 31 Oct 2026 05:44:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 821946B05CD
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:44:12 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02DA41404D2
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:44:11 +0000 (UTC)
X-FDA: 85382435544.27.E0595D6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 357F81C0004
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:44:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SBYWyFJB;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dD8bNaZIuViD1rMmSH8A86u/ZWtm1YEV/epD2uKBbxE=;
	b=br0dTKLNbl1u/vr47pPy9gLYHv01/gDub5ummn16SOq9knJPrcMUMnGxLrEibz7Iq6cEq/
	jRkCqrxTQh+Hh08/jZJV+11m1FNHkdTDBhC8GHNFL7CjANxNiMOpAOAZYV2DWjbVlBucY9
	B5EZttH8jk25hX7PO69/Y8ppELz61sQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439850;
	b=JxkHvmF/u7Y/J2dFVJ5b5KneJJmw9RnNnjweJ8DeZJ2hjbv/T9J81TVjoItgOxtmMffOGm
	wvqSCO1K8r8OE6aGYITaLlyyLU/LmBaMDaswWfCYPLu/8MhXwNl3fLZ1Ph7FhQuU7CVKGe
	IAkRs+tOiC7EczVk9c9BAEY94h/G0sI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SBYWyFJB;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 64362406FB;
	Sat, 31 Oct 2026 09:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBBC31F0093A;
	Sat, 31 Oct 2026 09:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439849;
	bh=dD8bNaZIuViD1rMmSH8A86u/ZWtm1YEV/epD2uKBbxE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SBYWyFJBjrqmvQU0SLK/yXNYDG03UfEHLHBfhq+cgw3Mp75MofH2A8dc6wPjeEDVv
	 OgsCgMr8avGx4SVXvGmJOt4L0WLdm8QTqbVfd3IgM2F9nzP1NKoikT78JhjLalaX6y
	 MJa8/PAIKKtuVGZ6zyGm2qn8asC2gEIT2/RlnUQdveNPyGdqArZM+nJ3oFiB4QJBUD
	 FqHedcFM3LOFsdKvRRAW7qIWlFNsNLMIvP2f0hRzi9q6829DtyPX0OMj/JaKxv8REN
	 3jH/Ga4Nqjvn8Vw5Hr0RDErkQgv1hA578/T4CTyi0+/C11MmrghwGE7RVwyCq1+EpW
	 sR34AEi7oNxPg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:44 +0100
Subject: [PATCH v3 15/47] mm/khugepaged: always recheck the pmd in
 try_collapse_pte_mapped_thp()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-15-d6437171ecc3@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1665; i=david@kernel.org;
 h=from:subject:message-id; bh=CS7nU47snOvzHXKT1Jq5YnXJ98oWY8rgSlPg1efCrZ0=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk9PenzlJu+Me5oLPjgcPt+x3vBE0sRXv9/FJ7pPE
 V46WSm6vaOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJnF7PyNBhvkr/s0eeQtOS
 xA+ZX8KZxEMW5rmvFv7Ty3PvlKhu4G9Ghhu37Loa9P4Ieh2Osa9PXXbdul0vIGFp3yn3w0uKr5Z
 OYAYA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 357F81C0004
X-Stat-Signature: i1xtzeizejjq5shjqocorgtkt68qsxum
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439849-230766
X-HE-Meta: U2FsdGVkX19AMNAL9Epopfuszm7w6IlZMToT9lHSVQwrc3KxlRVoaVdwOTYpi22XGR1Bw1kGa8GREh+szfcYn6CXSQsQJZX9ZihGqf1sq8Mz8pK8u4NaAa63RYqJEPTN3m9l2xRW+nottTI7Z/11YClt2ptHC52wofF6TIFyiplAodnU2w6DAreM6JetJfmg1h19xudkBvZMRTGhu9fj1jM78pTLxIUY49oDxxKNZ7L2jpyFKvirHXsNApb81fu2YfvbUnqOPSLesyeVluzQ2abYzgf4+9ha2YaUQn6m8WOLwxTOPaK75gQG+rqm+DiGOKl4Pe+8sO/cJjKoL9CqsmcUFvZTsMIUot9ZMi6ky5zTGtca19oJQegJZHPZezwlPYQyG7NXK0eDBtnRUcj3Y6NgzoQwU7Zpycsx8/SPeF4Cmcgi1LTOHecK9Eh2Pr6nwlSIu5jlI9fL/c5q2Lr3xKYkfYYDEUrpLn55kQ/eCamxG5demgr0DTC/c0JtqcU3zIUG7uUDpHKaMwGW3qwqln9J3yhBhQUW74Y5VMVoCUDLngx1DK3jyn1dxoqQVQlFdUihBPvdtunAbr2zMm+lp5+c3RAm36XoQy7hniAwCqGn+ax4JZgbxWV8wz9RWC1VBoprcxSNOe04hlZX2ujv0OlIr7AcRR3de5CZlv7ZVIy+mz5si7d8pCePqajK0L/Uaxygpk0m77i3NGJ52BxoqSNXTt7TR0VkAPaEQJj9lfmuUOARPEa0zPPvrDO+dGFahQkO9DRmnQx/m2am2y5K8GaU+kGSi1LGLsYQ4hiy1HL/xrCWse+eIlKi128fRya1aIBene2K7YWRx/mLX8kMDgE+1BigeFLtVmw1y0r1FLASt+i1TxUr5dBwLAQzjlfzatGzFq53naqVqXgWwNQFsbE5Le4mnU9dJuHO+UyLJMYXmw6C7M2wlNUNvw6bvloHFHK9zIS5vc1LWLusiqf
 6ITKGLjG
 78yQYOYGaM5eauBIXxD7bVhkEKYisbY/A+xLMJDRXUm/q9euodLu9JOux3c04tVqg25sDiC2qNZXuEVZ09O50uSO5eI8OuORZY1WCUyV4eIOoZVn2wrOtHmEtzWKFWFKF+TZx/AvJnCa86tZMuOXskS8ezTvljqwMafXLgj7k2L0vpc1TXcPM5ukRY4GOmb5geBBJocE5EBK56UnSbLf0CiRTQJpwCaFTltt3KW2+DQTNASrplh2JcZFnKg0W0tJTyKqXvVmA/bjN6ipvhfZccn88a0TUrjv0vunz4yegxepM7Hibz84eldcyIIkWTwYzBeWjxk+exJ2yxfHN1p0ezocXmzmdXzAJNi6UznE7HrKkzxaLQp8/OyJRX/ashElqf9z2+LQcpWc8ZJk4nRFPpb0idbt99zv2oOdBZuhMuL3uW1oSFv+hOJluODCwn+ECoig5ECfoUIp/qObRFMW7XXNQHnTRZF+vScOiZoFSsnqlqCmJcjDzCT0rIgSv+yWDK7CfqA3FMBhngYkZ8N+DTIf/IPTj6ttZq7reCj4FhH1x/G4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

try_collapse_pte_mapped_thp() drops the PTE lock after it has cleared the
page table, and takes the PMD lock and the PTE lock to remove it.

In between, MADV_DONTNEED with CONFIG_PT_RECLAIM can reclaim the
page table. The pmd_same() check is supposed to handle this, but it is
only done with CONFIG_SPLIT_PTE_PTLOCKS.

Fix it by performing the check unconditionally.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: adjust description ]
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 3a6f4b7b28453..81496887d827e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2013,12 +2013,11 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	/* step 4: remove empty page table */
 	if (!pml) {
 		pml = pmd_lock(mm, pmd);
-		if (ptl != pml) {
+		if (ptl != pml)
 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
-			if (unlikely(!pmd_same(pgt_pmd, pmdp_get_lockless(pmd)))) {
-				flush_tlb_mm(mm);
-				goto unlock;
-			}
+		if (unlikely(!pmd_same(pgt_pmd, pmdp_get_lockless(pmd)))) {
+			flush_tlb_mm(mm);
+			goto unlock;
 		}
 	}
 	pgt_pmd = pmdp_collapse_flush(vma, haddr, pmd);

-- 
2.43.0


