Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759AB606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T1yDptkd
Received: by kanga.kvack.org (Postfix)
	id 4EAAC6B0B05; Wed, 25 Nov 2026 17:36:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C2546B0B07; Wed, 25 Nov 2026 17:36:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B1B26B0B08; Wed, 25 Nov 2026 17:36:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 12AEE6B0B05
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:36:10 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9533CA0191
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:36:09 +0000 (UTC)
X-FDA: 85475100858.03.0F806BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8D30120005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:36:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T1yDptkd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646168;
	b=6Oi9YYy2c71sO2t5kW/0AIYbZeDBmW9Q7UjCk7bT/ZhxC3nCdOeNCBGiRmORuMuPPFZ8vR
	ZotzbG5bChnDsAOHqtkI/PL4dOGrP1sL1JV9NE5BMpyY0cfKuvIrfrBYuosMXJ4b0/6WAN
	B4U7tA3uvxoDU6sd7Er/j07K4gLMB8A=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1rYByMhz0KjcnKxiH/WuOpBmwN+k1Zzr7v4FN4dO+g=;
	b=tQKUdMrGZAU47CqRwTELCcAVbfzKjohniUXM0MT50dozKpBlzjnl7rT7OwD7sUkLuCiQny
	Qs5GL+OCuiBzz+sKcKDm/000//BZvu89kTA1qQ039xcTXqfCiZXKxyO3cuBnhnlHys+SzZ
	xbAV5bBYIeoqOWlqtKbUfkmP3wApgcU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T1yDptkd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F351044470;
	Wed, 25 Nov 2026 22:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1AFC1F000C4;
	Wed, 25 Nov 2026 22:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795646166;
	bh=p1rYByMhz0KjcnKxiH/WuOpBmwN+k1Zzr7v4FN4dO+g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T1yDptkdGkhkS4DIxHYWR8qc1deBMKJOGNiY/8Xr9dtoAjuu7hzpJcLvYs/dh5moW
	 aM53gd1HM9rf9K8UIiY+slvhsN2H5X1EvzGOHbSPaBv6wlo7/VANCAznNVbD3oTer8
	 EsLOZULLTDbrBDytJ/eDRNyUjkvmA5jZdsuvtKJIIqmOfbnpIRoPAVYCM/cov6t8m7
	 vIni4++pC828MD8grzV/M/r0dGpUPl4/8MWkeddfXXSn+4AjOjKbHwN4tfkCDdM4fD
	 S06jjQJHPI8hYCdvtWSWmcHddQODiIkcAsjmMpJefrliTd/utiosAWJKwkEAjYuhSu
	 bnsDBqlJ1C1IQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 25 Nov 2026 23:33:08 +0100
Subject: [PATCH 10/21] mm/hugetlb: only check PMD table sharing for
 PMD-sized folios
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-hugetlb_fixes_2-v1-10-db27fd2f71a8@kernel.org>
References: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
In-Reply-To: <20261125-hugetlb_fixes_2-v1-0-db27fd2f71a8@kernel.org>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Jinmeng Zhou <jinmengzhou22@gmail.com>, Hongfu Li <lihongfu@kylinos.cn>, 
 Andrea Arcangeli <aarcange@redhat.com>, 
 Mike Kravetz <mike.kravetz@oracle.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Dave Airlie <airlied@redhat.com>, 
 Vivek Kasireddy <vivek.kasireddy@intel.com>, 
 Gerd Hoffmann <kraxel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Mel Gorman <mel@csn.ul.ie>, Dave McCracken <dave.mccracken@oracle.com>, 
 Andy Whitcroft <apw@shadowen.org>, Adam Litke <agl@us.ibm.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Rik van Riel <riel@surriel.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
 Lance Yang <lance.yang@linux.dev>, James Houghton <jthoughton@google.com>, 
 Yang Shi <shy828301@gmail.com>, Suren Baghdasaryan <surenb@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 Gregory Price <gourry@gourry.net>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, 
 Wanpeng Li <liwanp@linux.vnet.ibm.com>, Andi Kleen <ak@linux.intel.com>, 
 Kenneth W Chen <kenneth.w.chen@intel.com>, Hugh Dickins <hugh@veritas.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Joern Engel <joern@logfs.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Michal Hocko <mhocko@suse.cz>, 
 "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, 
 KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, 
 "Kirill A. Shutemov" <kirill@shutemov.name>, 
 Sasha Levin <sasha.levin@oracle.com>, 
 Guillaume Morin <guillaume@morinfr.org>, Wanpeng Li <liwp.linux@gmail.com>
Cc: linux-mm@kvack.org, Jason Gunthorpe <jgg@ziepe.ca>, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 Andrew Morton <akpm@osdl.org>, linux-doc@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>, stable@vger.kernel.org, 
 Chris Mason <mason@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3518; i=david@kernel.org;
 h=from:subject:message-id; bh=HG9FVeHkf3r0GJ2DWJD6urls2DRbMkH6Rwt8+2D/97s=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLZk1R6m1me+71ZUHJi1ga2I7lVS1vbHrv2XazSX/Xyl
 P008Xq5jlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZi9ofhnyVj/g+BQ2/zX7y9
 6fytvlqwhNVJNVlJ49bB5mJPTd6fyxkZdkbM+L3vy4qZibnTnlteatu/4sedOKblnZ1dBrxldq9
 7GQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C8D30120005
X-Stat-Signature: zhtei1df44wz449xkuspe3qwiuxfagpq
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795646167-473473
X-HE-Meta: U2FsdGVkX18goBqoPhKhXi6sTuc2uTDgkcUpeGHTOynPnfWVluQ+1ug2S5lkYdknEo7Mj9PJwq/Msmy1+LoL3i9LF+M3spgM+MRiWnJMpCKDQopTJYWsrQaVMDCqlxYFKr2FjZ+Bu6fu33/zAM1D6XCCafkXJfcKAUfvO0ICVM5m/Q+CO0RfEuAZU+54mXZFFuc3RYEvb4IMEb2RPfe3Zfe/wfOw4/RQuFIkXXhQVgY7qReCPyzQxvFWg7bf5qBMDj8O31z9UsvRITF5HQosal4y+5z05jF9Cy+A9w24DR/LEWsKNYyEj/K+K0n3Cw76fBVSmlrH+dbPQLlyFRDe0Ntmhps77okxMlwhRXolJj9p6gvgwse0mPoMiKE20WlVZ/RlrW5tb5rvIq1MOwIA3HawNkfAhYeYI3f8e52yirztbjuYD/y6gerQ7Az3aWLZSzZI2javhi4YklYGB9BMqxyPIfOO90Va0sIzXYxxtofZnzDB5MWYFdqzy7ZaBFjXkJhaed8nS5+rTSyLvmnfa4564H7/LD7QD51nvbi5N0FR/VyGL8w/+1Z0CspznNK2dPq4G79IzEGJCyQsMOt/bajKsYcSA6U0JU9t2BuU29k8B76SNlyomOqAJAe43F1SACDZL2B6GZ8noHd4APgrjRrpdodK7uNHYcazLVYhsWjcrkLOkXy1YJAkwzHMMkjb3UEWh+4/8tGyR72l22A50DrZKLoEVr3eQcpaMThTdRK4djmkHls4X/jdzPoBYFTUG+WaD3Y29w8QlEIdPanWlXNhzN0RxF/g520yC1e4PmFZOMtcQwpzg4YCGoRLyHOEYOfymdi6V/PjAVYxhEQ4xQj1pVbeqS0dXIf8UEVkLhZKHe7GjAr6Npwk2FpTG6au1uCl3kYXB8YmUdwx4fZhGhIUbFOt5HBLO+IE/y7K8+CLt0/cLD3uv8uclxIGKu2DCY3VRXxc/85Y9U+ZON3
 EoL5U04o
 +gV4OY+HgXV7W3IQ9UZ5T19nquX9icxsJf2PGeM6fzawLuubrgwhe2JA7Y3gNlaP3hKVGUk2ttFT/MkQJR1oZ7ZdyE+89APcey6gCUXFT7NrCcCLBsGjJ+LlQbv9Z5MVllXRMCMh2uSe6io2a/X8bFxNphvVlEK6Kc4IALmOHjzuB7uoBB98A89J/+w1bweMPP52CvQc7TM84MzjPv+8bwLzr39jWUNmsGLdNkFooM6NW9CTiMQmiQLVd/s8HmWfC13WQayb5r8TKyD3rAnp3V3w2QtinDCPH0T6e9bsWxsdmBYjxGamuLyikUgGHUODdlTrn5umOaR1U3s5p5UWWN3joSnH7bdtELDkFLVUKJFApH3s4wNnvHMOGa8/SO6kX85aO9XvwtzxeAvcXuMQ4Mz6ClHQ5rmMPUj8pD7fhZPcZ5gu6J3kClRHM0TcHGBQ1w9ZCGlAqyVCCsmDgjaPITzP3Ej6d6QGv4qXDg9gbD4o0JbdcbTibnGDgQ15IRd5bTgaAUs7t8MNjxF85W4DOCj5+qHhfO3V1V9mJ+6DsZbDnqSQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

hugetlb_pmd_shared() reads "pt_share_count" from the ptdesc of the page
table that maps a hugetlb folio, independent of the folio size, to tell
whether that page table is shared. Only PMD tables have a valid
"pt_share_count"; for other folio sizes, such as 1 GiB folios on x86
that are mapped by a PUD table, we read whatever another user of the
union left behind.

As a result, such folios might be reported as shared in smaps and as not
exclusively mapped in pagemap, and mbind(MPOL_MF_MOVE) and
migrate_pages() might skip them.

Let's fix it by adding hugetlb_folio_maybe_mapped_shared(), which
combines folio_maybe_mapped_shared(), documented to not care about page
table sharing, with a check for PMD table sharing only for PMD-sized
folios, and using it in the affected callers.

This has low urgency.

Fixes: ca1a47cd3f5f ("mm/hugetlb: fix hugetlb_pmd_shared()")
Cc: <stable@vger.kernel.org>
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/task_mmu.c      |  6 ++----
 include/linux/hugetlb.h | 16 ++++++++++++++++
 mm/mempolicy.c          |  2 +-
 3 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d2a524c6ad4b9..41b280ab7b19d 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1211,8 +1211,7 @@ static int smaps_hugetlb_range(pte_t *pte, unsigned long hmask,
 
 	if (folio) {
 		/* We treat non-present entries as "maybe shared". */
-		if (!present || folio_maybe_mapped_shared(folio) ||
-		    hugetlb_pmd_shared(pte))
+		if (!present || hugetlb_folio_maybe_mapped_shared(folio, pte))
 			mss->shared_hugetlb += huge_page_size(hstate_vma(vma));
 		else
 			mss->private_hugetlb += huge_page_size(hstate_vma(vma));
@@ -2131,8 +2130,7 @@ static int pagemap_hugetlb_range(pte_t *ptep, unsigned long hmask,
 		if (!folio_test_anon(folio))
 			flags |= PM_FILE;
 
-		if (!folio_maybe_mapped_shared(folio) &&
-		    !hugetlb_pmd_shared(ptep))
+		if (!hugetlb_folio_maybe_mapped_shared(folio, ptep))
 			flags |= PM_MMAP_EXCLUSIVE;
 
 		if (huge_pte_uffd(pte))
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0d5414392d870..49dad5ae57512 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -1386,6 +1386,22 @@ static inline bool hugetlb_pmd_shared(pte_t *pte)
 }
 #endif
 
+#ifdef CONFIG_HUGETLB_PAGE
+static inline bool hugetlb_folio_maybe_mapped_shared(struct folio *folio,
+		pte_t *ptep)
+{
+	if (folio_maybe_mapped_shared(folio))
+		return true;
+	return folio_size(folio) == PMD_SIZE && hugetlb_pmd_shared(ptep);
+}
+#else /* !CONFIG_HUGETLB_PAGE */
+static inline bool hugetlb_folio_maybe_mapped_shared(struct folio *folio,
+		pte_t *ptep)
+{
+	return true;
+}
+#endif /* CONFIG_HUGETLB_PAGE */
+
 bool want_pmd_share(struct vm_area_struct *vma, unsigned long addr);
 
 #ifndef __HAVE_ARCH_FLUSH_HUGETLB_TLB_RANGE
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 6f800fb961aec..229efcdb2c7db 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -833,7 +833,7 @@ static int queue_folios_hugetlb(pte_t *pte, unsigned long hmask,
 	 * cannot easily detect if a folio is shared.
 	 */
 	if ((flags & MPOL_MF_MOVE_ALL) ||
-	    (!folio_maybe_mapped_shared(folio) && !hugetlb_pmd_shared(pte)))
+	    !hugetlb_folio_maybe_mapped_shared(folio, pte))
 		if (!folio_isolate_hugetlb(folio, qp->pagelist))
 			qp->nr_failed++;
 unlock:

-- 
2.56.1


