Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A72606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PVvbRksS
Received: by kanga.kvack.org (Postfix)
	id C8E596B05CC; Mon, 26 Oct 2026 19:22:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C66246B05CD; Mon, 26 Oct 2026 19:22:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7D736B05CE; Mon, 26 Oct 2026 19:22:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 963BB6B05CC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:22:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 142531208CC
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:22:39 +0000 (UTC)
X-FDA: 85366354038.04.CFB3B96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 32598A0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:22:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVvbRksS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PONecBNGwAC37JtDon9HRvZi6sk21qH9zGaaJ3qYwM=;
	b=QiXQGF4KIOvCgmZ51bWBhvPIki9+79cUynZaXaouQbZacv1LBD0h5fFzYjoOlc+Cs2WLti
	G5jdcqN3aqTymwy+r4iHyQ0pEwk9Vaelp8/Kuo4HLLhPhQUaFWEzIwyJZnvpmFOgum9iOr
	efFrbTKhkf5ooql3LfQyz5KNUDfuEGg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PVvbRksS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056957;
	b=Uy8hgn7enfUIcmu7PVUEJyd/yvzZnDx9xZIaofEARsAi0ODf1/SmnVqUgGYjQGOG0k9qqu
	mJEy0LSYPjbqntS2vWXDrn8OapQoUzRHtqQuMdnqxp8MhGHtR89EUX64Ad2y5U/nc0deDZ
	/5yDMxxTwLq467M9UDnyPdZaUkc7lDI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7AACC4017C;
	Mon, 26 Oct 2026 23:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E7D1F01825;
	Mon, 26 Oct 2026 23:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056956;
	bh=9PONecBNGwAC37JtDon9HRvZi6sk21qH9zGaaJ3qYwM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PVvbRksSFwPLqVK97JfuGRK/yyQ7vgKqfwNLBuwg7tRyER/6D481w8uhIlExbvJlF
	 3Bu3BiC6oN4wuYX83Y+otwZqJERUGRe1XFi0KZ7UsLHZ/O4mJV3ZcTn/vc9WZT9EJX
	 wPLTosWMrpja6FYcetEEULvCUUTsRwH1Wx4GCZRVT5tvL3HyQE+itWahkkZ0Dz60Ct
	 XlR6V2Yu3twGvjCbCxFmeWQT5axPeMCrXg6qf9ZLt0Dkzq7EMrgWGUq4VcoD45xmNI
	 0JiJEmKhSJUPzB+HtPGHZQbcS0lXuOgWw7vLR2o9H5MUKaVvozkgATVGIROQa8biF8
	 hMVaFTFvhIV7Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:35 +0100
Subject: [PATCH 15/46] mm/khugepaged: always recheck the pmd in
 try_collapse_pte_mapped_thp()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-15-6f74bec9a5bb@kernel.org>
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
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1502; i=david@kernel.org;
 h=from:subject:message-id; bh=tUVUPC0JtoDS0vcvc31VLhuGDhArP2SMJJKTyHtlpxc=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu359SPM9j88bSt686WqQe8L9xbvg+r1Tw8tRHcz37n
 s7RmJFY1FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBE5jcx/BU29ki5fl+GO4jN
 wXS6x7vf0VKJzI6z82R5Fk6a9kRS25nhv2NW248SjrK9fx+kGgX4OdfM0y+eYzZ9l+uy4BN7Is4
 9ZAAA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 32598A0003
X-Stat-Signature: bt17fkmpszemz5idxe658rm1r8unk41f
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793056957-615487
X-HE-Meta: U2FsdGVkX18bdeeF2tnUVtdcMQ/U4R3sTnGFT94OSciq819x7EDueXlPEkmS4wyyfphzHujsR0O59pcRnf5/oh9+kEr/bI89MLRaRiTTUa6bttxMaAgR+MWxEbK3nu+/zN1xejMSRi3jWgesBh/0T/D0vlEzkZcVsw5BmB0OK45R18bHwTVFGaaOLDKbIKPo9q3DxECoh60KblXM2ASJPUUY1ye+fVvxRiGg44i2/IN0225BKbgj5g+gh/MXb6FZlqTiy7hdVfXhbnJ/tq/+udfrzw5iytI41nz7x5+gVTz7jW7FsKOFvfmkKNgemDx5kfIHDu2THoxXyld15SxOPz6THpySZqpGjZKovtGD+HOK3wG6zAj/SdiZ1p74CqLerbB9CS+Xme9lBZr/giZi7HnFeS4IXAQEXdZG5ah3RzpXI2ReISuEalp7qbb5ZohWyRdmCyc+0OEUif3GQixNl8Cys524QpvIh7U6a4XnUIMgHnXU+cWgf91fMHoHNDNkYO2GspaUYs9mjjtT4oJ2USLhRUJxhP3LEpl76vJD0V2cELia18cNrMM2CA/sC8o8ME3ZJa6lk26j0SDtcQrmWC5Au2fjiIlyAnqE43Zq4SacWICOSQV2/5jlyETHl1XRBkNJuvEPCN9TBPh/Kt84Wys8uf4IxvVzAzqQ8OCV9lFegD3esSuThYy7AkAe5dhVaio1eoKf+dpDiafSWxlTal4Jbe5zB1C/82i5YKziJbd7NslcJFpG7CKBcmVhknKLUkxUpFacLlTl+vjs5aUjvURVsd6EubdpPOJacc9Vaz5CAEAI66QznUhEfehWOVjNG1uEqWEHrFJZWgk2kEgMmRGhVdztcLdqsqA55f4X62dqsK5KyTRM4IlO7kpzKSzlYBKSZVuxOyM9Rw/6poAFjOAXrnPPp7leRi9Vwu0FOMQNOHDttEOkChyad6SDn3nFFNtP78mDIxfTk+lBRur
 /Z0JqxUh
 ELoqdpBmbDZvL0AvAEEPbYcsfNvbo88EM/b9trplDe9zUNC1hplDpR35SwdP/63cjYzm5cZS2O2ljaK5Jm2X2LWxTg5p+OslOHjpGhOaVHQPh5h0zzqAp09HWWdGetH2MLsm0l8FONIyCzZyB40QuvUWObr4RFssvJaepRGIKpNrhLBtVCZESvNjlE/GkxGIvKqB0rIYbKrJvZJDwX3XxX81m2XAZYo3mHz+RZVERPcUN7zuslpLpzsh0Zj3pHj3TQGkfTFQvFmR5Cuz1m8SOMnDrcVp+GahzqOfbklkpbDVmf2zXyIQw2/JiSYURu2u//JibS/vPSY2MhJnBzew/EAAY4cyD9HQ4a5k6T63NSQhM0aztQPrB9G5mw/FA9rjhjF61XSqiqKWeg015DUB04p6g9jw2rH24iGYIh0qJ1yFL/uw=
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4b71d010b2aff..f53c50507c83d 100644
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


