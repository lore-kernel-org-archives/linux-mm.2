Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 260F8606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:20:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZuADOBD7
Received: by kanga.kvack.org (Postfix)
	id 3D9626B05C0; Mon, 26 Oct 2026 19:20:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0B56B05C1; Mon, 26 Oct 2026 19:20:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C89B6B05C2; Mon, 26 Oct 2026 19:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 022886B05C0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:20:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7BDE81C4293
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:20:45 +0000 (UTC)
X-FDA: 85366349250.21.31CF293
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id A8B8840004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:20:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZuADOBD7;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6+gzYQp6lQKmnHV0p/bmjsvdO24Tz6PsMaqLI3Ia+mk=;
	b=as+DfTZ3t7ghOBoL5NiCbNfEJ5IcmYVGuONNYkBrDMXaGc63LDwnJlbAvHohWxoCbxgi72
	HmcixfbKX1f392T1tul/ysKALoj/a0BH2GafrfEACwBbZ7AKfnYPNeEVeEXrLQmN/D8raF
	uHAb6ll2Kr+TKpAymdIyGU7IqJ9lYng=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZuADOBD7;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056843;
	b=IQ4VHBzNlAQTsPvwo5d2XI8MYCFfqhup+pniZ7v2DU1JT8rIs3gdz5avFWBzd1DrdSFYA5
	NIoqVHyFfQZfB/9zbrkNmbG8hbkjS/oVyJIYml4fcUnBHtiM1z7CeUx+uWcu2znfrfHVhJ
	r3mbBvPZvgy8Z5y3gceZlSGUS8V00Xw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E5A0543588;
	Mon, 26 Oct 2026 23:20:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A58C1F01825;
	Mon, 26 Oct 2026 23:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056842;
	bh=6+gzYQp6lQKmnHV0p/bmjsvdO24Tz6PsMaqLI3Ia+mk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZuADOBD74c+0IEKa27h0VWHF4Fwh4hDQg2ZPJxGJ9JNaYFulNoe0acYVvsse86UEU
	 rkJFSfGzcj5mO5BSB4+yKP3TepmOFSOBwO6PDS1TAGmzIDGdXt87IkwxD3lt+N6XHG
	 0sEuxBEc+CCzAqcvHYS4JvAH4pM63FvCeCa2FUKJtZg5u/2Y9DTpq/wLKsuDW9uPNN
	 qkWlVUM316yrt9U3AiQI+82Ff064uf9aMs/PdMvtfO9X0FU4pbtirRWHo0GvBSnD+Y
	 UbCn46/RAtNN2468Ds1AWN9cZmxRv6WMcTcCZaJOty8DA1lsi2IW7I/kkZbcvbttz+
	 6BnIyAsK0ebjQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:29 +0100
Subject: [PATCH 09/46] mm/rmap: handle device-exclusive entries in
 folio_referenced_one()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20261027-fixes_core-v1-9-6f74bec9a5bb@kernel.org>
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
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3201; i=david@kernel.org;
 h=from:subject:message-id; bh=5NdltRGk2kAjkCt9hyC9MFUfoZY1PF6asfKrPYTa0rM=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35+iueVIn9OjO7wtfLkKak2XCz9N4ww92X/nDO9+i
 5XTRG/s7ShlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAiErsYGWbOfT79VIbxxA7P
 +CsGvOL1Ts80rlnKrXwuuFz716ewL1oM//3PXspLrNSMmuPUV/8oU2bqgr9WEqcfnj0dFhb+3KZ
 TjhMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8B8840004
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: dhsxo8duzamq4s4on9djf1xtwjdpccun
X-HE-Tag: 1793056843-395982
X-HE-Meta: U2FsdGVkX195v6Q+WJRnfPRU9vHbzA1QOrXzU4UXtlch3MDd3Pv1iEgGjjghzk/R9yPoGztL5ayJKJxoyHJfAjN+Pq9FDJz4wVsrLaGZ9hNvu+P40XEafWXLYk8trMUMo0zyzUGdHSYuzxP0vCZM2yewRLKWjj+oyDTonrsPULiBq8FqGmHhDIVkHCT4IO7AiPFGUWWA7cuOmzkhVk3i6v/KhRiaxm0EXimlkm4vDRluo4rK9ri67KCl3hcYJY0bF7kvUziYwluAHsXilaQBpGyCfeZCnnwJoMhiOyPrGJxceJCJKDl+Zqy1m2tZqbFCLSfFBiJKJ1xisxDIEp+swwlifIx1+fml4QbdEea/UOB4tLorhoQeU17jTidU0XRTIOr+AhYyLnnZUAmrOUs6WfuLxQM/2NLTdsE7hjot6GeQE4Z1yAW7doZO5Qa04oX7NSCME0HrSqKZiF8ExT9o9rqXkSfndjE5DbbsjUbiZY8K30D2A4gs2phmo8TyhPhb9dt9wG/Ke2AtdTCAbPaVREuTB3M/xbsyNAcUgx6c8xm9Fn4tSIaZJ8P0YOqtMrKiE9hJtopvmgKBdl0IwI/Ol5bu0s447bLqrsiXm2I7rPyyZpZrI+dr1G+5mGsiwK9yQhiYogyq4zEczNvYpLAo9dgyP+EKpbD1GQUOOzcOPBF2wYs1GwIyAu6Wf+CKBkvLu1uu2HIdSl7jgkN4A+YJOKskUxS/itxtBiUpBvx4jqHUkIoetDaPd6A+w8Aad+fIMbJU9hY5IHFaNMFdWcjoe0GCT8i1L6avmAEfT5nejflF9CXN73SFsliiLA8Dci5WcRLQ+HiWqcEMhnx6J03wWNRaUN4zOU85KOf49zXm8RfSUgSTWAwxgJHGmfk9sL5XkTF9jyPISO+XURbo1BM64CIu065ou9y0k7OULdeNBJ/J8K+S9ru8QxKEwMTeMQ4SkJjpmLkrg5bh2RUm017
 5o7L0xjs
 g75T/k1aiUumvYt4t7CH/cWyr1xILf3RzmUBsDr8Jr0SlW1NZ18aR81lcrsxlHzF4FxJ/7J/g70dknr+4nj0qCpV0mvln2pPR1kS+0qj7KtT3BIyKVBb92V9OS6jikg5DTwAoQb47OF9YDPmjpjvg2/iwlYNvo9aoN0819DC7sCKfBY7YiJl2QHL7L00+VLU17h5C0e9w2ejaXpG9g9BRvVWNvCOGDaiWavuJ99IvLCXELiFS57XERH4ruA1B4y46x0cnrJkX1ragWxJqhClUdBT6X3wkczWFjyTOIjQokKu4mvGYpGDgsDpnd3MaJzrwg/UJ4St+MHWmxLM+vdn1pjLlCVShqq6NKs62Ory0IGkJ5lmRE8RmhTbMpO2Yziso9e3aGKhd2lxMKSvcEaDx6YU/LTko5rXbN9FfKrAuN0ZZdJXlezkvemNDDrmRz5rlkSrtwesJS/8o2YA=
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


