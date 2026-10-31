Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32EA5606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QoEpOhUZ
Received: by kanga.kvack.org (Postfix)
	id 319816B05E0; Sat, 31 Oct 2026 05:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1D16B05E1; Sat, 31 Oct 2026 05:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18A046B05E2; Sat, 31 Oct 2026 05:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E73D76B05E0
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:48:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D76780899
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:48:21 +0000 (UTC)
X-FDA: 85382446002.17.D25C87C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id ADCBD160002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:48:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QoEpOhUZ;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793440099;
	b=YBiiDbNPkPeVk8dqnlgy4A+QnhXAiXji40KD34aE4lxL1xDxCX0Ijx7i/MN3aALxjxu1dJ
	LddupLfxW4SWEetZpkNdkHTVZULy21VZM2qvPIfF1Yd01rISeisfYajIm6siKgw10bucuy
	BEwQzX+PO/VmY3LaVRV99lh+IqfR2fc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QoEpOhUZ;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793440099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DxsTnHZLfef+ZwV+bvdRNnaTqozvDnboMuYB5CYD3jE=;
	b=dc33+D3hBdI6OmTWR/QBn0zAUH3RhxCe7K2RDQlWWzu2DMfys7KjC/Mm0g8yxVQd4dfb+W
	S4R5WTMRw/uYTyBPWUDIc6EwN8k47KWur/s7Kb9ClyRtplLNKT9mcT6Ucxy1zI+niuDq5D
	hMwksuu4FMAcGWe5G2kEClmQi3rONMQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB9B5407F0;
	Sat, 31 Oct 2026 09:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CADAB1F00A18;
	Sat, 31 Oct 2026 09:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793440098;
	bh=DxsTnHZLfef+ZwV+bvdRNnaTqozvDnboMuYB5CYD3jE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QoEpOhUZRVT5ren8mNvEjqn1fyrCuCi3IqzacLFBc1u2HJO2oZExxcKCe19eR+RGQ
	 8iwI8BvPZqNo5/jrqNSTGGo88w098M0MYwCIhUk6LpVbPz2i7KC/apSep2/KNgnikI
	 CCZGsUUg6SYpN5WNaqgo8h1JdSLlrj3hYY7CzMCHMtG1ewJfyApyunEHXCarGJoL5Y
	 prMZdGWKplHeXSIkx1fzFbYsB0I7gZ7MmULj4BhOGc7AQjO7OtPdPPIl2SKAWZRQVo
	 g2l/0yxLop/YPFutY9Vnr3DZWe2nReOil0JTX8tcvbh73/vuVLd2Z0v/zRvWBDB3E/
	 ebhBYFeK5WLLQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:40:00 +0100
Subject: [PATCH v3 31/47] mm/mremap: recheck PUDs under the page table lock
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-31-d6437171ecc3@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2437; i=david@kernel.org;
 h=from:subject:message-id; bh=YLac1XnofZU1UqgkNCzS2hgJEvURcnZijflAh/9PoUE=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebs/M2sG2+2aZx+o8Q2HJ9yX+F78wragxXn+sMS6Ri
 WfxVTGfjlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACbyw4vhN4t60MezWt6cQpaK
 d97fOyKk439i2WG5kKkXGDQZLs+zLWRkWKKb/J/dqOvfq/UKWfytT/oFeqdGrpN5+3lT6H7Tbt3
 //AA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: ADCBD160002
X-Stat-Signature: poqrc31h7of5p6dey3j378hzan8dxzs8
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793440099-667084
X-HE-Meta: U2FsdGVkX1+u7wzlFWYhZfQeDMc5zD4uQHiuuGiSxPIIrA9krnbyQMXjIw+jw253MlVbJJhpD0v2Mz9yt4Fmt/l72T6kLcFXzsvuaX+vbfEyi27H/jAlr6GjNGcOwtROiUt8ISCEz5GnDYEkUNIp003dx0EkOcEQbWb1UBphScp1wv9EXhDxrQsJAOzt/9Y5Y2LcKEjuusQ1GFyOvl/gtOPlFMfsFEW1kmrMF+kTDv/ZxJHOnw6PBhfPzLQZfZUqgdSd/CEnm5BfEbmMe2z06uecLzwgQaLZNreWjoRoezd7luHuH9llHJIMoDQizzZPljb9KQcg0qrz3RHCXa0ztq7Nuk3mpYJ3dntzpDAP0BgWyrsvBMoz23hORuJeNr9Id5QfBNiq81xCc0bCSMOl07vEo6w7q0cAhYZnJ8Dvu3YHiGFA0fNCvv9Euv+JDi04Tzs0zKW4kSwzfxaxX683tm1/jPR6xFIoO0e+AHYMpoNZb8QcoZTVIRygss2Vsz5NBRqhgK0f1v1Z7oMue/RoxFdskLhRYstdZmeBucgOA03sFCXcQ5IVcKxPdYuoBD19H9Yc1Pt8dUX6oqgcXV/DQh0dHJChyqku6PkJebz/uzsE40mVsCzUaoNQ6byaUOWZwoY0h8vh19mEuV/EGFlllIl5emlGOvAmc09Y994SP5JApUT26Cxy7ph+iZcuVPMLEBjBWurK0qXvs8pWlT1rkugXepI3j6q6aMhUDk3hgVz5SiwMES/XF4+BOvAaJQpCncBBGGA87MuCAO2xkPqOX5OAqDad7HjCxn351bJ95zw5JaRCH1KdQn+C4/F6K2nuQflf7WgXKNCpvLxtmTVDjertsEChV/0fZo+qB6HlBjN0/24tUcDqho4EIUfOej1BgmL6zI8bo+Jn0p3d5L7/y6RVwHatqOPOqve8ySYKpmNQr0Pgn40ezUfgkFYc/ujn7YlLZFmh/wg+ul+uPqG
 uXLYSy8s
 edtb99DfpVdCN3l2o2l22qgU6OrFj+9ZUhzxQ53H9WQXw6pzZZmMIV6KXlJOC7hlN27oEolczEMnUSRWEuiwDg4j+EojWLwIsb9NqrPqxi8dEViD0f4v5NwLZw8HhwPmkvNJcfIOvzR77RjtQWo3zGkBhn/c/yUPf+joXrEvDnnkGFd187pKn317X0F/Nd5i7yp1E3KFDl0KysdcjHEWo/ok52em1eGX6JLouCEPhd+7Tvkn/44CP6cGCszRvsDZkIIaYG3zCOnlGrucqGOW62V6lv3y8I98oXWfeGMEuHBuE6JLYboPRcEnLCoMy6uSm0xLc4+VaSOh3RLWvLlNP4zCGgXCi94mM76A5qIdvrRwKBT4PbtcpSHzQpfYyM3tqc1Js
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
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
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


