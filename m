Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43210606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UOHFpuhe
Received: by kanga.kvack.org (Postfix)
	id 51D6E6B05E9; Mon, 26 Oct 2026 19:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F55B6B05EA; Mon, 26 Oct 2026 19:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4496B05EB; Mon, 26 Oct 2026 19:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A6496B05E9
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:27:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A37BA14083C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:27:19 +0000 (UTC)
X-FDA: 85366365798.25.38AE971
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id E8A5CA0003
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:27:17 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UOHFpuhe;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mTs2GwunrLwQHmmSbQHxry+Q3bjPD02b5DRaizzO8u0=;
	b=xF2N+uqLmEvrKs4nHHphkr3GCMZtPqqFUooJ/WD0XrNQt0z06Bb5RXd/BW0veEKRBGr8fa
	oVnZO827pIrMCVx5YVd0a4xUQInd90lDrPFG5euJe3aC73d5ru7l0MjJFY4s4ilr/poO4t
	g4hEiZdvg8wa/uBNr0MzACzFzQfZNeI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UOHFpuhe;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057237;
	b=ZpQLVkn07Nro34fu/FbEGhKynpI2L9x3xNWjZxMhOzoC7ZfaO01jXPlE1h1rZBZ1yRL7GC
	pvhL26AVEuR2C0GJermbfXY5MTp+YnVVqVybl/RWSD82P3cmBUwb+5sqwva3eViITjEzvE
	bYKCtJKKpDCHBX1Wx7FIPOmfJNbFuWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 764C6601FB;
	Mon, 26 Oct 2026 23:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97F21F01829;
	Mon, 26 Oct 2026 23:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057237;
	bh=mTs2GwunrLwQHmmSbQHxry+Q3bjPD02b5DRaizzO8u0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UOHFpuheZQHsTAc56z0KufOjEShFawYMdcpWG4L9/RyqdOhOQsL5R8Sbu7NayWn+S
	 x/mtr1q0KjP/gxenYKzidAb0IIWRucgx7F4GratJpJ9LE1diQSB+4cDmGcUM0DBgil
	 Jt9+/7a4DnuFwWE8xkyYwZthGOGRFbNki1fdHP+qsFHcQufZ9T1f+FQy9fVPQiVR8S
	 iNthWlpixuHd8TTlBW+CAeyS6sUknd0khcSYxQn6KUUfrAs5i3CwFSqpJPZaDW6T0m
	 xLToTVLa+KO7t9J4BS8w0MTMXRtsX51LB9c7gDMrS8glPBDvTxW5BFBXGwiuJrBRsk
	 YBMypIhsGQMoQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:50 +0100
Subject: [PATCH 30/46] mm/mremap: recheck PUDs under the page table lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-30-6f74bec9a5bb@kernel.org>
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
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2335; i=david@kernel.org;
 h=from:subject:message-id; bh=XqIc47B98euy1xZsTgJLG+HPEvLDbYPwpls8mFrjLko=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/+nuloHL+i7Gzt5riT7MeNJr+acemve9vTq+v+d
 W3MX695oaOUhUGMg0FWTJElKPi+wcuX62qr3fiYYeawMoEMYeDiFICJiL1lZPisIqzaaFonkqp7
 puGr1eKbr55WXg5cXsKUG9A9pzZ8/RqG/66nHXc6y3b+luLN7V/qYqv/hLN04okSz31TJcxn27v
 MYwMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8A5CA0003
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: dmsjczu7fpbfnw6hzjfks9tk8qsytijk
X-HE-Tag: 1793057237-971460
X-HE-Meta: U2FsdGVkX1+r48FrDiEFlhtJ23d8KIgRUmJvDl0/Jutc9WF8oGWQHLJoEBJ2Zmmn/hiAUE77+uEjc9xLrfGs3279lQcyYjjOW18pCNVNgCj17PBPMc5EFQTjac8x2wybXZkBotlE871/97Q3eCvKn2McMXznT4oYPBidKPoMaVbHexV7bamylLqtyC6MIPF++nKbNl7J2+4uY8EBDtg/f+opKpxLGat1rSu+JVxIJn0RJaWQ+iK2LpvC6e0cVqcj+CVC8zj0LVkIO9ISmI9Jkd6XxJDqczaIA1yb+s/VuyY6x09AfFJ1UJc+PSZlUEAJww5dQYyw9wrHf9WVIxnoqB9UCgQvasQ3JH4YwkuhRyL4RzbP7c4PgI6SFT5ljs0JX/Dq3PXsXo/Y9Dk3Q/GS8HneWNe8qzUer/IsPIptLzWynYmJFovT94cVQN2VJJhMpjubAsuulbcy7a/djHUxjJ/5N1GxnsC8v6cRfPtAWZKVFtUdEH3TVVi+0YUuIbWnaWX/z0UTcGSMN7UtlXsG7RwTtUL2YA8GZlMkfNbU6pEE6+5lV6TCw9gkx2+MPyYbJGpDOZBjBYcmUdrAIcxf9WSagLh8tk6u1JgdiywsSc2e67rz3sdyT75GH4R807YaVKL7hK/1J036Tmx7u8XPUYQNXg/XqP68c8O3RF5zCJOo4jr2ipp79zPnI2PqVvQd0tEu+LtMGYIjinYlBT35ytGJ39gRZivRQAX2LbyEMsYKLCdRIiP89mOfE/0NkhPwtCB24Yqn7dwBMbTLGHCDtVZ9Q1LwbZyYwRar5FFkx9C/RNBRVUo4+5OpVm0efwd93/EJPKr3I6N1TdsncojNa6dOY1z3idTREb30Cpzjx53lSaxy38SpVuxXUxfRFa2blFOc2et5nFuBGVQkkplDlj22yFM1olG2hbnZL7JuZ5f5pp1XIAvhNQ39DGAg4nlRQ7izf3CyL6+jh461s4U
 0FqF7Rib
 BjjeMD9G+v0ALfTrqjE6V3xEnw7VL7QKTXWoDerpVV7aVaayDvixB5xS7My/D08XO/yCnH481Uu3+ZyOiiOUyHS2HDwSW+AExqoI+AiYZ4qXDVgIdWDoz7LRL1Q1/wQjFLpnLJQpMQL3bR2JBVZWDP+cMbL1/8oyx0oVyHngBIZSVkUDdv/4rtL0AABjvIC6ilPIxl6a/DVbVTuxAB1gZxKmms4lvf+m9t3NAH6P+y+P7SGOgXOSlewBQ5M5o1WvpsopyRQwxTa6+9p2ctQ7tTufV0hS21PNGpBg8BB2KHdkQoEOv4wV8kZH64SY7AOThE7+L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Once get_old_pud() is fixed to accept PUD leaves, unmap_mapping_range() can
clear a leaf between the lookup and the move. Holding mmap_lock in write
mode does not prevent this.

If the zap happens before move_page_tables() tests the entry, an empty
PUD can reach move_normal_pud(), where pud_populate() turns it into a
present page table entry. If it happens after the test, move_huge_pud()
can instead try to move an empty entry, triggering CONFIG_DEBUG_VM
warnings on powerpc.

Recheck the source under the page table lock in both helpers. Treat an
empty source in move_normal_pud() as a completed move, and use
__pud_trans_huge_lock() in move_huge_pud().

In the future we should likely have the code lookup a PUD/PMD lockless
once, instead of multiple times, because one of the problematic bits
here is the:

	pud_trans_huge(*old_pud)

Fixes: 0881ace292b6 ("mm/mremap: use pmd/pud_poplulate to update page table entries")
Cc: stable@vger.kernel.org
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mremap.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 16e736c72d9cb..91f0865f6aeea 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -461,14 +461,18 @@ static bool move_normal_pud(struct pagetable_move_control *pmc,
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);
 
-	/* Clear the pud */
 	pud = *old_pud;
+	if (unlikely(pud_none(pud)))
+		goto out_unlock;
+
+	/* Clear the pud */
 	pud_clear(old_pud);
 
 	VM_BUG_ON(!pud_none(*new_pud));
 
 	pud_populate(mm, new_pud, pud_pgtable(pud));
 	flush_tlb_range(vma, pmc->old_addr, pmc->old_addr + PUD_SIZE);
+out_unlock:
 	if (new_ptl != old_ptl)
 		spin_unlock(new_ptl);
 	spin_unlock(old_ptl);
@@ -503,7 +507,9 @@ static bool move_huge_pud(struct pagetable_move_control *pmc,
 	 * We don't have to worry about the ordering of src and dst
 	 * ptlocks because exclusive mmap_lock prevents deadlock.
 	 */
-	old_ptl = pud_lock(mm, old_pud);
+	old_ptl = __pud_trans_huge_lock(old_pud, vma);
+	if (unlikely(!old_ptl))
+		return false;
 	new_ptl = pud_lockptr(mm, new_pud);
 	if (new_ptl != old_ptl)
 		spin_lock_nested(new_ptl, SINGLE_DEPTH_NESTING);

-- 
2.43.0


