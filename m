Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC8C606A327
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UGGzr8wX
Received: by kanga.kvack.org (Postfix)
	id 5647D6B05CD; Mon, 26 Oct 2026 19:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53B5D6B05CE; Mon, 26 Oct 2026 19:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 451206B05CF; Mon, 26 Oct 2026 19:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3236B05CD
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:22:59 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 81A2B1206D5
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:22:58 +0000 (UTC)
X-FDA: 85366354836.15.BD4928C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id B086D20005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:22:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGGzr8wX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=reZzVNI4A/Jr+bC2MZiSR78czx3ygjp7lEPtfND7Hn0=;
	b=hSnGUBSFKYq2ptpKYRA3QvFBz4bJ7tXYwzITaUx18JRRsBWU7KiRervwtUcXaK4ki//oth
	LfbMVMos1Y5xyew9mbQ6PPZcwoL2IAL/czlTR1tQFOevQWeMwLbNjtYs7IYjMSqqqgBILc
	2O7zWwFI1j5W8dBJWYNqu7QP6bZM5vk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UGGzr8wX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056976;
	b=nE9pR6INQdSe5W/cyl4gI7JXre6Fpg+3whdDqxkNf8LbCVdSWb2PcaY4SGgWgVXy4t88wq
	IbhJxLByuchsqcxeEpTeSFGAqEITLGyN94L/NXUzf8lzSFMaFKB6TaYqkwvsACrgja9Fjg
	22QKpuvSeNV0hsIxhhz1MxFwFeFsnBg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D47334017C;
	Mon, 26 Oct 2026 23:22:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D9C51F031E2;
	Mon, 26 Oct 2026 23:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056975;
	bh=reZzVNI4A/Jr+bC2MZiSR78czx3ygjp7lEPtfND7Hn0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UGGzr8wX/g8GZ9SFIoq0C/I/5mPwnV0HghDWeu54SifXDSCR3TUH+tv2sLf3to4FV
	 eVjgLWM6JQTJZxq4p+d2XJnK3hUtgQuaXKEBOKZatmZEPp4KRCWWT55wBWLeUY68Q8
	 QLsAcUK0QMIYVDDvOrVcya/a8ucdM9+JAS2CrnIlQ/7WYoPaq5bRdoEmbG3Cw8+KUL
	 uctg3F9yHVCoCzUZdwGTxIKFVGrBf1WFQEHil89WvsvfUWekxvcRYZxhg7pAwfCjKR
	 MwWIYTVXeIBgtLxWDHeCJy4ZFqIYoKtQG/g3wUqOoc4TIl8CUacM1aW5rMSHpr1J8M
	 JO5QoXq6LztMA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:36 +0100
Subject: [PATCH 16/46] mm/khugepaged: fix PMD table lock leak in
 try_collapse_pte_mapped_thp()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-16-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2280; i=david@kernel.org;
 h=from:subject:message-id; bh=UXoBnlCMAf+wGbJLfiFGKUQg+DKe15pWriilK/O7tD8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/6Qa9JT8qTS+xv1eW+fONpAS8+8S9fd+4wL3NK8
 d2Xf/y2d5SyMIhxMMiKKbIEBd83ePlyXW21Gx8zzBxWJpAhDFycAjCRsimMDPvDCy7yrdKY/OJO
 s3D01Ye377da50sqHgh1qIq22/Z5mxPD/4B9cToayy4/KGz/dKT3bIbO+7Jlz7S2dVz7J2UVLlv
 0iwEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: B086D20005
X-Rspam-User: 
X-Stat-Signature: 8aahxaazie471bi9nmdqsa645fdakbzf
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793056976-210617
X-HE-Meta: U2FsdGVkX192vbU+STJeR33f56oAOO05vU5C6k2k2qX4qqEwgfRaO+NKYHt2OzJE2Cn5KLKX4mnniHa+YiC9mg7uSJpF6zHnDbgbWVK1ZxDzk5a30R/ZzO44zKNjC5EvzVWKjag5V8kDvmXs2wOI4G6p7q5kfb0voX6+579FxkXw3qU2psBCJUfAI6X6HOcn/w5i0VhSKrYu7sD3JzHYD9SupkGc2c2v2EA8ltyOAAb+HBjdSl2w6uFhFpHBnUV5bm74454otw68DdjLL8P4MGbBqqPHoUH9H6k/qSqFrdV6kgNLnWPmqSke2rGp4325ccqSZmJpMa2c7lUZpTz7wMGua8Y4B6tH7IKVLSvuScDPKpv7DS569t+k3bUcPswqOgUWQgvoIWM1D814bqFZxIfnF3bBi285ixZJ5RnnILaykMN3eFWQyM3K4QNE2FgMKu5pVABBHrAQtykbSlxH+fdTs+HG/Reb+ziSX/k3tRe/5dF6kQjvxha6T8b2HEcukqjdxLmOUgQjQP96bwDe2bCWMiPVH8FWIqOExMiAM+WfheDOf0mejLj626GeMyKdzcUn9TbhhJDbKAWg5mTjPwYoe6bAbrRimQENV/FZjUaEkGN+0X4hMIAgirr7tsm3lLy3LA8LxnkZ6++XdNskG7RMD5xMPNTaAj9DHAUopus+JrgQUuk52mewKJiPm7+dHvUSCnZyjXHsXmYI1x8FB66hnUpAfcpupTVibTcajkvs4ksTFESUvs1z6TcpsNwuKoAe5WbxbTejkISpcTwE6N0QlDPUXZ+baBH6KSxRvYSYWlDgZX/lO/04vCn9zm792g8xYkfx1qouK+oz/fDeOyMa7wshveY/ODMqa8MaeJH0oILa+kle/SbFg/A0t1i/Ndrzku9cSHgWeaoZ4It5MnVnskOYFQlph6NTZgKhcPl0qUcm2t22DCIxPh2/tLD+8gKt2GdauVY497sQc8L
 NAw943bZ
 aN1LjIDVfENQ6xweocssV6M5pUCS6w1bjIKb3YzBsOLFNqgT6ay0HBi3XqbS3NZqBLX6GFaeWE+kM4CpQHXCq5su1MadRDi00cI8laMVbjycKttfGmMc6NkU+V9Bp401KAiZda5hhg5FhsVKTFyBA7ky2jnM5NVEER6oa2l2HuFIrfkFZe4HrNTOXFfyg9k9LBGYmMlPmdtVqKHMMITroMqt/P/QfskbVtdenrit62KrKVAfc4mO8QjJ3Ye+BH/Wf1VHnBKVqGr0NKUv8Di2P2V7VKQjdbf5gPxmWKEI0dxrSw9T8wUIrUlJ0qSfnC9g7+Lfrm+J+n4N+d0Wu2S9UJMZgEtoll6PR3p1f2iLmSRlrTi9re0yEPNvYP45gDD7VXqJjoxqID5ApdA/UnZ7X9wbPf8lZUFg9qmKnfEFwZxoJKHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

For a private mapping with userfaultfd, try_collapse_pte_mapped_thp()
takes the PMD table lock before it maps the page table for the second time.
If that (pte_offset_map_rw_nolock) fails, because the page table vanished
in the meantime due to concurrent page table reclaim, it leaves through
the abort label, where the PMD table lock is unlocked if it differs from
PTE table lock.

In case the PMD table lock and the PTE table lock match, which is the
case without CONFIG_SPLIT_PTE_PTLOCKS after pte_offset_map_rw_nolock()
failed, we miss to unlock the PMD table.

To fix it, forget the PTE table lock when we unmap+unlock the PTE table.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 6375e95f381e ("mm: pgtable: reclaim empty PTE page in madvise(MADV_DONTNEED)")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: move the ptl = NULL handling; rewrite description, drop wrong comments ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index f53c50507c83d..04d9bb21ff524 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1904,7 +1904,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 
 	result = SCAN_FAIL;
 	start_pte = pte_offset_map_lock(mm, pmd, haddr, &ptl);
-	if (!start_pte)		/* mmap_lock + page lock should prevent this */
+	if (!start_pte)
 		goto drop_folio;
 
 	/* step 1: check all mapped PTEs are to the right huge page */
@@ -1935,6 +1935,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 	}
 
 	pte_unmap_unlock(start_pte, ptl);
+	ptl = NULL;
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm,
 				haddr, haddr + HPAGE_PMD_SIZE);
 	mmu_notifier_invalidate_range_start(&range);
@@ -1952,7 +1953,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		pml = pmd_lock(mm, pmd);
 
 	start_pte = pte_offset_map_rw_nolock(mm, pmd, haddr, &pgt_pmd, &ptl);
-	if (!start_pte)		/* mmap_lock + page lock should prevent this */
+	if (!start_pte)
 		goto abort;
 	if (!pml)
 		spin_lock(ptl);

-- 
2.43.0


