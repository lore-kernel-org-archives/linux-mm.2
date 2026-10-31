Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A418606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=T2bzvm+r
Received: by kanga.kvack.org (Postfix)
	id 247716B05D0; Sat, 31 Oct 2026 05:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F8B26B05D1; Sat, 31 Oct 2026 05:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9416B05D2; Sat, 31 Oct 2026 05:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB7806B05D0
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:44:42 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6D209405FF
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:44:42 +0000 (UTC)
X-FDA: 85382436804.10.5BE854C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id C0A3A40005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:44:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2bzvm+r;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Wa3C2xG00DqQeoX0IE5SZmfSUJ/EgLcgZVnEIOFPnM=;
	b=wFiIqwl3n6AjRVhtCU0NXTPKJbs0Vn+bY9nS38ayr1mGElsSINR9gi7c1+gv7t2Bp22IkV
	eolJrDALXQ9LvGkjVn5iYxsP19o3lF2JFi6I+BcNhGLyBvY9vRS3pBwEwXi8QreEkGkuo9
	YC78Lr0E3L+4jBiCzjuWwX9oWw2hBSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439880;
	b=ABBnzla89CAhbHo8Xfeoh6DlWKq5Q298NyAQWZ99WUubnvrF9UXKv6ASvkgd38BetvB6Lv
	7uE5zbLPMJXDebrdbQGcYtLN916wFJuO8kIKehXzWFLylgUUFPLtmTeKohBhaZZmYpaGzn
	A/UU+DaBhpISjhBiC6H0LaqsseCJ7Yw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T2bzvm+r;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 64811605D6;
	Sat, 31 Oct 2026 09:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349821F00A16;
	Sat, 31 Oct 2026 09:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439880;
	bh=5Wa3C2xG00DqQeoX0IE5SZmfSUJ/EgLcgZVnEIOFPnM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=T2bzvm+ru2+7cwP8E0yxMJ/sp9KoxH0UYhdJNE8wXIhEoHwEm4mcCdf26VhVT2JNn
	 3IoDZ6z4lCxSnRa0L+FZqLhwbyJVD/4rB+3H/Fwa05CWLxjF2qFsPDelKb3ATmPyCs
	 Rp4ztACMJM8u1YQoWDvGJ3PTuh0O8Xt4Z7ysQdttuehVHPZlb2xY3vs8DKkIBwk662
	 ugOc3Lz8ba1yqU+0LbKJG8u/9hguctyosLs4GOHr6My5vBXYNOyndRlVIslPoTFJxb
	 aSFSC05l6z8juO6thj5l3QfzlxswhtM3zGzYkMO6kLxw0eKoeFEcmanqwZTaogJbn9
	 l4OOmIXTldeVg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:46 +0100
Subject: [PATCH v3 17/47] mm/khugepaged: preserve dirty bits when
 collapsing PTE-mapped THPs
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-17-d6437171ecc3@kernel.org>
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
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2246; i=david@kernel.org;
 h=from:subject:message-id; bh=837bmTNyZDFxi4Sf80pnh4aEoyUZxI11ZPuZCTv9/sQ=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk8X+frqeqH38feda3+b/Xdb3PvmIzvf120fqh8tl
 rJgmnVhS0cpC4MYB4OsmCJLUPB9g5cv19VWu/Exw8xhZQIZwsDFKQATmcDD8L/CrmbqlZiH9snp
 x18rs4nt6a6WOTlVRyG7dsGrgtN3DjsyMpyNMjTUy8thmW7Vd9yP00f+/9l4ywNMNv/uvZa1ubr
 kAQ8A
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0A3A40005
X-Stat-Signature: btwta8w7sb9quq586dc3ynbr7a9t577p
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439880-863663
X-HE-Meta: U2FsdGVkX19XZ6OYVhDpgZHT6zQO388WE/AU7QZWiCWo+kQdVV2MYxINwPYu9O1hVwwnP2iaCycb2QmCZ39BwKGn9hhrFRbe/akYT7QSmm8sXKVO4hk+jG0CCq0rPqnh4OEjV9hXupyX7BbP/psmmXngxdDtaPhwyGw8NU9Toc9SNw93lTPU4+C7b+Lhdx4MSWyKD17GcbcKcn04gyPBQqm5T3umKK89Duf/NS2dqN6J5Dh8J63gb6od92Ps3jH9MCmysiCYgYfVGZ2FOMRIEXX2tfBIdZs5mvwXJ9WyNODwvCGq65117Nm8tRU01wWw7k8ni6hpNcxgP7r1n08dLSwT+s16mBeVHrqk1WIrPhTscKRlMoCQ9n0cerhfwvkf852WNbGRn5TTVZZQtWYjfEnkcxtnaxdILLmunCBB1bv35fGfZ5ldnz9INV7++slBRPGwAI5gMDp1HqrS4C/CL7ffKePq0wNOI5A+oAZtXKJa7eFsHOFODsw4t6sl9utFRy74S8SlcolSKbPhqSua+7grkTZ9BVx894bq5jesaOUuGg9rzDHXgNVFhFLZPa4NY6pZ7ZozeMaLrGZdjhE6Er2GSN917ZY9m2hkedhHIQ4MlnQuHyD/8XANk8EasfE/4RbLNwj6lOkU7VqPqGyifs1VyB9P2eXLv9bhZOaypKwAoFNEJdlUHvgM80BrMu4q5x7viO+YOakWt+Gg6/5NUcSxz/VTpu3tRVDoCJfJyJeAdHNj+XZcjY0R3ywSv2daWqLD8jEvxTjoY9v1zg3kvyYnin9u/LXLiNlxxB5sgJNdEuq2iwjVLx5+DMBomX7v8KDAj3E2g9CtBduw94d3zScZYPj+5uFHOWNDfzFaKea73FPqNlIBz4uV4qdRd4zao4LUDs9CQIxxaYlCR6lS6EWGwqyBXsXKOFmSaHAgMvURfKhgkzntye2hecvGCi3jiKpq1RDtkp9D8era9S6
 tKyHykid
 ETiDHBje4OnkYGfzuv+JHhmujVA7AKX/pSRWG0l8xr687gDT5vGTdI+rjK7Wif5JZ0/g0zFeVzA9cJUZzni+niieAjxq3UGJ2vjmdVdu/9vJZDl7JOW1w+bhoRkwluykQJgAKGwIiO61TiPazHh5nCyxfPcWnGAn7h/k45pTFjjpI7BrIlIvgUz7etVpLvyiUTkrZo8dcQldiRVp0VLzd3r6V63EoACJF6HIDRRTWhgx6ZdBgkxEDopK/l6eUWwmjcARSLETUOXiCLhDHiQ1MyNny88xEvFPSYb0UZ8i2NllXmCV5jZZnI3vimlbX73EWT1dgvruoitsrhDTuPyrFjcYtQmv7EtA7uUPPA005wyS8HUpvFK3hQxttkDKGL0VuQfj+8OLioNiEZk+gnYZB00lWikjwNAqlcuWnrWwL6IPB44a1sYAtroHTXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

try_collapse_pte_mapped_thp() clears PTEs without transferring their dirty
bits to the folio. A shmem read fault can map a clean folio writable, so
a later store only dirties the PTE. Losing that dirty bit allows reclaim
to discard modified data.

The assumption that regular files are read-only is also obsolete since
commit 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse
for writable files"). In any case, transferring PTE dirty bits to the folio
when removing mappings (and while the folio is still mapped) is the right
thing to do.

Use get_and_clear_ptes() to collect the dirty bits and mark the folio
dirty before unmapping it. Update the comment.

This was reproduced with shmem using MADV_COLLAPSE followed by
MADV_PAGEOUT.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 27e1f8273113 ("khugepaged: enable collapse pmd for pte-mapped THP")
Fixes: 1b6444331bebb ("mm/khugepaged: enable clean pagecache folio collapse for writable files")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: adjust comment; simplify description; cover file-thp as well ]
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/khugepaged.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 34ebb37c862c0..ce794d9760a87 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1995,9 +1995,10 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		/*
 		 * Must clear entry, or a racing truncate may re-remove it.
 		 * TLB flush can be left until pmdp_collapse_flush() does it.
-		 * PTE dirty? Shmem page is already dirty; file is read-only.
 		 */
-		clear_ptes(mm, addr, pte, nr_batch_ptes);
+		ptent = get_and_clear_ptes(mm, addr, pte, nr_batch_ptes);
+		if (pte_dirty(ptent))
+			folio_mark_dirty(folio);
 		folio_remove_rmap_ptes(folio, page, nr_batch_ptes, vma);
 		nr_mapped_ptes += nr_batch_ptes;
 	}

-- 
2.43.0


