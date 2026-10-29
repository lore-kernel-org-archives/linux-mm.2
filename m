Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03ADB60A2619
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:37:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dnPvAICq
Received: by kanga.kvack.org (Postfix)
	id 1A8D76B05CA; Thu, 29 Oct 2026 16:37:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180FD6B05CB; Thu, 29 Oct 2026 16:37:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01C696B05CC; Thu, 29 Oct 2026 16:37:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D6A236B05CA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:37:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 643874050D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:37:14 +0000 (UTC)
X-FDA: 85376823588.25.AD0CFCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 93FDA2000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:37:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnPvAICq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNxobpWlUXNjZHphvvtOgvNQKSqjJiSYupG+wXJMVoE=;
	b=Xl8mjb2pE/+E5IopxampZV3ezlr4o0kZjz8DObnLtEJOqESjGaCY8u0E9MjfxOIaf4tRNP
	eGMDuLzDD6WA9UemzAvnR2aM+D6tOuWPhcHvNUVKR0XZVDb0h8Ownljsc5uw7NevFyhc2I
	etq9J6Ryp5U6WhmRIjEi0yRCwMosDaE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dnPvAICq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306232;
	b=uK5Vptwr5DhN02bqy373rC7JFQxSqhDTgWRfPyIYJA8V4cuw2q9LmjKCeJACXfPWjfOj0f
	cIK85n1oBRPiEt9jQB8UVBf+tVT5QHSlwWNVIB5lC42VeWwuJv+NcRRTWhkGGR5ipdLdsi
	UYvLf+dFUAcVMI3cNzA+oLvHdcOcodc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3597B6020F;
	Thu, 29 Oct 2026 20:37:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 800E91F01816;
	Thu, 29 Oct 2026 20:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306231;
	bh=tNxobpWlUXNjZHphvvtOgvNQKSqjJiSYupG+wXJMVoE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dnPvAICqs5R8ijwgTMhLfxbmgHzO9ja4TQwnVekFvzI4/Y7pZ5RiY6O6tVJsThGVV
	 0+fRYRkM1yM1n6cFK+iCf3ZqyzqyhwSxWilIYYeoHZzbo9N29g9v86q9A13gDR/zAg
	 8DtvbNaMzwDgGrBUQB5UExtEwWaK0Dn9sbaFts/LVGL/R1SW2YpAU0BrON2RUO4yYy
	 cu/4SgzAJ0FHs5/Ri+ZxG/yPhlMK/kh2s08tuIv4giMR88cv5B14Ge4CBnqQ8xk6oa
	 1CwTQSEOwzHx7AbzR0KZQSktdzwEh8USZEjLO2tgQvbt5Dkn/jHz3doUQYIsiZKPxC
	 3UQpIdOeycdlw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:10 +0100
Subject: [PATCH v2 15/47] mm/khugepaged: always recheck the pmd in
 try_collapse_pte_mapped_thp()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-15-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1608; i=david@kernel.org;
 h=from:subject:message-id; bh=KkwG8uxQMmQsjX2diZyIiRGRbeEH7cv/itYGtmQ0sPg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer23LVcs0DZ+Vey1b3SqpnrEvsuh3u9sunSOS0y9ke
 OvO3DSho5SFQYyDQVZMkSUo+L7By5fraqvd+Jhh5rAygQxh4OIUgIl0pTD8Zglw/6lYZenzR8hk
 r8l90wVv172VFuh9dvaBH8e5W5P3izP8DzWJnPD4TI3eYUNe26sd69i/56mUL3HNdaxgFvxTHXi
 AAQA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 93FDA2000B
X-Stat-Signature: 8sdidwnw48pkdp9xjaty59u88rhydaf5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793306232-328444
X-HE-Meta: U2FsdGVkX19pdgAHUFf79CQ56K0i5t2kEqdq2VCyEhXN6l3+jqFV65miDBy3OFoLpm6SJxVwJuV+Vq/pUsJJDE5LlT9zxc57qBOy3nSnShjBRADa+gkjJwmIeaWFGmnSfGPcT7eaXCHsLoaTUv/A7qbhFh3JR0SgoHQ/yr4d9TgPzlLA6hSi9sD2CuVmEV4aiNBzJZUeva4taK+ovDlNHFM7BoqfZH2t+XnfVVREKaS17P34fJigwiyxj9wTK17Eh5jI01a21YxH6EX7mfXhUgMT82M8aBWrXlTB2+H5DhnMMWj0/aMzglDbaqakBA85dW+S7hGv3smQgUsdSAdMUhhnMcCV8uUKovz+llCP06ngVJtkY6tTqoFrNkzOT5DAyGlBLC+YlDEscNjorY5v9rKqxewLXfh8b+xrVbnwQIKeDEj8Bz53cAbpEFeqGULV0xvVVBS5k2kRCoHjaifwqixqRNqa29/NiYHU6T1LX+F39M+iJrL0yuZKFg2uKsTduRUMicUZydwEm9Es4I8PhmM0FbyjgSn7Dy9aTPM6dujxrKIaz5khLf2T7YJTdwsmp4JhdZIFE6uyQIRuBMOtsJ/Ro1dR0SvTNSxEGgZ8ydBtXIOfa3YZliBXezdI1a/ubx3i5SqrnwWKsSHjnNmv3AulWCa6hvf9ZDxjoA56Y+dIN6/CY1DGlpQ9nTCEJ8JrPHNuyrjv6CU5KSRN2f6LYgZ5tI8SdVy3J9PeU/pjrnsVXdVhnwZDJh1wPJmXgaOYHNqjx56F3B7DQDOzoOBoD3PmpJlOgH1prMRx+5ngH1ENN1lAuv6zGTlBQ9JaUoYF9rRUO559K9YYYSsS7mXpl/4wxkJBBHwigqTOKnHLFLFwZbC4jC6chEy+Jh1mQg7CjADUH0SJG5Sbv9At6wSGWTPau+YU0S0+Rl+MnUeVANrQle0Jh8WxeWRQl5/30zH05Rku/sFVVMX52Lh7kmj
 JE1L/7OG
 TbWkWRspvPevHllFjAKXgRiU0EkjnkkOW4Vpd1Xq5JGnDo7Qzszg1yWbyo4x6cfGm3fep8pQP2Y9IThthzpHgwfAyhXxlkvBtLADh45+0h6VWx2HEx4yQ/GzsmS4poZ1biPy4d7KxocxDVMNYWTYqu5f9oucGcLAjF/0FSd1+U05tCw7NroGRDG4kURY1D8y1PQGMbchz3WPzjRWYIAZyJBet0Zy3xNCXnzLF21r3p5QRh0vEz2dgEgoQ42wybty/4GrDPl9jKzxYefsxAGPL6qTHA8fxUR2vzDaaJrDnSslOb+cvFry5vQcP2FYm6OT6jTFyr0xL6lqDxkU9u+W++4qrlNoeGyVeTAHTO8gUlAv6clLiCqDuYfeWt0bnsAmYCgOuFsqwTaIhIZqk3EYbNuc+bR0mGJ8tFHCnOPScTdh7pRd9NkEGAn79hMv5tVdXwLt9N8gVG1qI8GYjia94S3XHuJvzO/kQEwyc
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4b71d010b2af..f53c50507c83 100644
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


