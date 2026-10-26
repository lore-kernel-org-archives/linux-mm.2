Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10EC60A2608
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=evu1XW/7
Received: by kanga.kvack.org (Postfix)
	id EBAA86B05EB; Mon, 26 Oct 2026 19:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E97E66B05EC; Mon, 26 Oct 2026 19:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAB556B05ED; Mon, 26 Oct 2026 19:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB9016B05EB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:27:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 473EFA08B6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:27:39 +0000 (UTC)
X-FDA: 85366366638.29.C58C898
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8A51BC0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:27:37 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="evu1XW/7";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793057257;
	b=vInCLXYfyevEFlDbj/hGDAYPHFQNk+rUC8hlvH+9My+NAoIdvtEdpqd5ba9WRw++fOi5dJ
	ljnqUGyn77+3JwAupRfuYXQuoTtQGoOrOuYxmq9PN8BkwL5o2H3NhPigEiu7gxkHUGpbSG
	iwK3991x4qDaoIeVrxVjZFU1sxtKUlc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="evu1XW/7";
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793057257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7+b44oyozv46Rxfjs2BdSgv4+W+us3N9SjMGx4NrpQ=;
	b=K3HPtA+IKdph4nffrsUxOsXwm4xs7pQkm+vGLVAEHQi6a9xstYzzDtQheoEyAZl2OjccsN
	037y3Px/S1mRTsX6+3SqkNjRff/B7tt6E8l7LildQEeOmtubEMBkPKzQb8Q4tzruhPnWaU
	0pxX7A6liXgfMlHy6Ie1AoIqa4QFLew=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 239F8601FB;
	Mon, 26 Oct 2026 23:27:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19781F01825;
	Mon, 26 Oct 2026 23:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793057256;
	bh=W7+b44oyozv46Rxfjs2BdSgv4+W+us3N9SjMGx4NrpQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=evu1XW/7y1R64K47ukh34E+hAs/6HfE3JuNKx2qvcK11wZMq86dZPM3DsMEp/EC+J
	 p82x7dsIx59ezC5CkSB4jD1ZOKsPv598Qz4acNyP3aEwCNi0XShjPBGHlKOv0HV/N4
	 NSoQGgLBupcZtuemFQo0kEG4lyMup7+do3oA7kILcP3NxBBesLVl0UdbIcKqGpOSx7
	 VcBkLBkGa/sGXBxgWW7om8v3vJ6tPDxEdfIbxw1jhhUBD/VtoLzaQ8Q1+gcgnUbAxD
	 UeeDOGx05fXjprwHz1vXYI3mcjV2luOlB+4p806KHfYlIbeeXbp48/u/Y/kRdKtHFT
	 duoIbzi2a7gwA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:51 +0100
Subject: [PATCH 31/46] mm/mremap: fix moving PUD leaves
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-31-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2177; i=david@kernel.org;
 h=from:subject:message-id; bh=xaFHaOsTg/KKNqVl7kj20OnAYFH/hrUerHWjoic7u1E=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35/u8LPiwNykGsmlh4tmBoRHZGrmm0hZn8xguGt8+
 kZ9foZCRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABPhK2L4Z3xhmcexC+anMk7X
 7HWTz59XxGDnY2N+9ivT1mbFWVNeSDIyvI2atG6Ge5X1mqkuar+2vj3snufgxW9T0aN29EaI1A1
 LFgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Queue-Id: 8A51BC0004
X-Stat-Signature: dqhieuhez4hr7cq7b31thrg4tbz4gfbb
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793057257-858120
X-HE-Meta: U2FsdGVkX18houafPzLSqcHnkC720wfjt6uAECbu2v7eEcekQeruLe3tOznrjr+7G4tt3IE9fzkeNE4/ZOiR8sBEGorKfaLNYrw2IrT78VAyb9dXu6AKc+uDMrMu/AE5BC38dt/dTtJKbTtnNXDcRofyp2P+cCiYZ1C0Ujr3pwOLfuZukMkD0Y800FEr7PZAGN+vgxNOy+T0Od911/u8dEMzNdhNdCDKmowOvipROQ7dREXBtw6wKpsJdsS+pw84fq99AkVIGhJRRRamyVLbOLyTn1G3NehVUDjrvMEYAEC8OPgzmKoEcrP+XRBWKAd9qJBNTG+zGf8Pnc4ZRwd02oBNN1enrrQTwJxeOn/va+lejpJhBwW0p65UIW+sHBJmb1VeBL3OJvR3VN+NLJ3FXGEARuJ2QWbLPtetKLUn90Mxul4aMUyfibT0GF1ndhgvKDuRQ5yRHoDdCQAIAb3eypdDL4rcazDGmKUiBuD91h+nEoVgV5mNWrc8/xQ4Pm+MVpOn37FsaPKlcK+GY8lJTI9BPgSiY0io01RPO9EQ/5PiIl6kboK0wbZT4IAOa4gQcgZLCuJLnUXuBbHvTyp1mUiFkQII//apOpcVze3xBcOPMNV2pqNCs5VSdslpaBAdXe1lUSGfUjG1cw/yL/HaesGusU0kNSzjSsM99H7vfxfRMXdAwF2EZVvvXqt3GoRqLg42iwwpmbMIzlAded/xGPfwlvC5Tv27FZdO/C4aQcXNpPwPpO1MWSG4/OP68grndLIAaKetTu7xr7uJINqsT75gnuw9Z2RkKtCDbQHmbrBsPxrdV3HSaQBrj0OXCSmiqB4l2c1QWZ6Hs3eYyPyGNhc/pRtCeNk6XJgfv+Pln9CbzPqSb8xtwmGCfVcK2xbHrqBBwJH72w6XKnQFkUzcrV7g7od0K6iOC9jiO/N12GEkJRDe1LHiWLfqqk+daxAAxkMMvbdPu6MJJdwG76/
 eKrOErh7
 9ti7AHpD5Yi7PP/sKW7y0E3uZsaC4ylRJT+O6EHX8P0uoaSlwwMydPC77XVFTr55YncqlzHxwgUbpWWhHwDfBdXZeyQ6IommU65Mq9zZ10q1/Jb6pIb7otmqgIhngr700IC2DTk6srW8zijWmYA9LiQjdJIR5v5PN6d+Zq65ukn9sCMfTRrCTRdn9wO5AKIubjPSOfpZRK1yBXlut4tCai9SIcHWtrBvjIJnZbxQqu1KXHGruRys77oHFlqWDgSozwcYXLx+2Yk815oDmK9GrZ5wOdSQKNT2XrU6hm4bt1aSg8zdXkQHk7WLPSqnMa6+nHutDDBrZELslWJ2HivWy06hqhQDc9dH5anxeWCp6GnnUOLsf9/b6wRBClPNQJ67zPvrF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

pud_none_or_clear_bad() only really works on page tables. PUD leaves
confuse the check and make us clear the page table entry and print a
warning.

Since commit aed877c2b4257 ("device/dax: properly refcount device dax pages
when mapping"), this also leaks device-DAX folio references, mapcounts
and RSS accounting, resulting in "Bad rss-counter state" warnings on exit.

Allow PUD leaves in get_old_pud(). If a PUD leaf cannot be moved as a
whole or the move fails, split it. This unmaps it with proper accounting
instead of treating the leaf entry as a PMD table.

Keep using pud_trans_huge() for now, in the future this code should be
cleaned up to just check for PUD leaves.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
[ david: fallthrough after splitting ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mremap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 91f0865f6aeea..1237718848f5c 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -87,7 +87,7 @@ static pud_t *get_old_pud(struct mm_struct *mm, unsigned long addr)
 		return NULL;
 
 	pud = pud_offset(p4d, addr);
-	if (pud_none_or_clear_bad(pud))
+	if (!pud_trans_huge(*pud) && pud_none_or_clear_bad(pud))
 		return NULL;
 
 	return pud;
@@ -847,11 +847,10 @@ unsigned long move_page_tables(struct pagetable_move_control *pmc)
 		if (!new_pud)
 			break;
 		if (pud_trans_huge(*old_pud)) {
-			if (extent == HPAGE_PUD_SIZE) {
-				move_pgt_entry(pmc, HPAGE_PUD, old_pud, new_pud);
-				/* We ignore and continue on error? */
+			if (extent == HPAGE_PUD_SIZE &&
+			    move_pgt_entry(pmc, HPAGE_PUD, old_pud, new_pud))
 				continue;
-			}
+			split_huge_pud(pmc->old, old_pud, pmc->old_addr);
 		} else if (IS_ENABLED(CONFIG_HAVE_MOVE_PUD) && extent == PUD_SIZE) {
 			if (move_pgt_entry(pmc, NORMAL_PUD, old_pud, new_pud))
 				continue;

-- 
2.43.0


