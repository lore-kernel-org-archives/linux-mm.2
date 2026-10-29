Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7A6606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Cs7/GV6p
Received: by kanga.kvack.org (Postfix)
	id 755F36B05E2; Thu, 29 Oct 2026 16:41:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72DA46B05E3; Thu, 29 Oct 2026 16:41:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D886B05E4; Thu, 29 Oct 2026 16:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 381786B05E2
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:41:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C79DA1204DA
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:41:24 +0000 (UTC)
X-FDA: 85376834088.13.2130710
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id D986740005
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:41:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cs7/GV6p";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306483;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dCA7l8Qcb+zVMAoQ+u8vRDzaCWYfUWbDIcwuPkJnxE=;
	b=doOCmizswNTzfTn30NJA4YTG+8dZRR0UZtWEFpyEBYuV1g0MEPpr7VjUVj4z5cLBZvZudl
	IslDFXAyLRXmQlzzJ+qxd57qn7k5oHwo/ZbkjC9Zgc3fNrna0Z73+l3R/+/qL6lDfCE25s
	5cZsBrlxxOcwD9DGGQ+4lOwhztlMRvc=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cs7/GV6p";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306483;
	b=L4jy3G+2s5Ize0Z9sk+8LOCcEyC6GqFlSSy2B0exxwm/MpX0NnFSYxAOFXJCGSLI24/jUM
	2RcHcu4mr7pBjrtCh8254VxDGMsKb8KNDfEHB2JqZmnqrJWLoah1/ecuwvn/SSXJ2dmMmL
	4Q0A08PSWSe7SkooVoTUcO7WrS++50A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 01E7140E4D;
	Thu, 29 Oct 2026 20:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9C4C1F01824;
	Thu, 29 Oct 2026 20:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306481;
	bh=6dCA7l8Qcb+zVMAoQ+u8vRDzaCWYfUWbDIcwuPkJnxE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Cs7/GV6pq6eMLJFnqbR9+QKwK6ShcOEk4QCMZXclq06zJpivW8mGEnMOZW9YEUEFr
	 me7PFVPeK46BJU1hjQNgFbL9/Ot6d2rPuJ6UQP4THorxpWzVRPECaHsgmeLmeQaRON
	 Qz3YkhJPUWzx9FFcChAKrp6TTNfjeGiMQn3b2VQ+bZ35CbukcS1MZ9fuoJYnDyK6lG
	 AUytHBl6JsN8niXhnFNeFcHIlaRbkFht1w9q9lGzvdPO5tqDfSobnLfmLK7CA9Um/U
	 /nVJ+0XtYKdEenTS0MtJI5vr91YRIY3EYdRZLofvgfQHN7xXwyvcFndR9Tor8730zm
	 oJFwe5HvlcUCg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:27 +0100
Subject: [PATCH v2 32/47] mm/mremap: fix moving PUD leaves
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-32-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2222; i=david@kernel.org;
 h=from:subject:message-id; bh=/15IZZT8ry+ExEMoaMWjieutil1+NN7piBMJHRZeGuI=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+3odp3/SFVqszD/9KmpUY5brG9yzZ8jcP7lKREXI
 8UDqbdLOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZjIG2FGhi0fIzf8PaAuzKQZ
 dYKBuzLwhYbeshPx4vtiqgxnXdy2z5aR4doFmTtHUgTvnzzV//uy0tLr5xwkZ8wVz4721PU8ELn
 WkhEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D986740005
X-Stat-Signature: fn7pw31ioj5s74hhjbgfa3ahj4a8fjcn
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306482-224372
X-HE-Meta: U2FsdGVkX19B5LCUASTuiX8Xpoy0d7CaKF7IYtzU0tzCEaarsZSWeYj3KxdU2b45p+tP8yHIpbJ3N9xfMjFFiOPHmCOXPuOERpF4qmUTcRwgOc8a2LYHDpEYaeqb6phpk49IzEJ50kPcbmPJXs/nHZv7WQeq9bQ3dokOsKvTS8+dR01aKL5yM5MHfr+8lgexSeLb/vMbDurinabliBom/vRgLpo/e8zHEjSBXVaP3uboBhlRNgA81ABbbH/8tzUu2sLMG8QEJzyKxNZgxfUE95HuyPnJ7UPqK8KZTdAwjNp3bisSaW5AUaLlrgKmHdMpGuvFDk+snWUkWjU2ypfRBg1jt507orJbIswr7ts6G4RrTWy000BT/q3yfKwkFJMBSJI9o/Y8DOvqO/SOydtWpJ6/7AxwazIC2suQrq6kR97nP7aCbhgw3l4dwbBM1AsZixwNfA9MkCUJSfoClnoz0OHSl2cMCB/aoEqBtTBh3FGyKoAwYMacFc2GOHcHjeApnnlutKW6+ExrqtbVjWanz7OGUuUjYGAyotF89TRSwK7Wd7XSPgE8t85cKPgEtDdTOtFjfCiUvobWoDKVHO1i129d+0vos5gBt68xhST5CO2R9Oj0w4SHiHFZvmjeaKf1uXM/bRhJk1UkZGh5QvA0Tub5lVNLGs4oABswnEvXHJ94YG5hrh2uMZ7hFLanwsj0lLttwEUaqoB+EgWgajb2VDBYu3gpbvkC9ApOOaE+RMm+coE1kAMROabMP6Mck0/iyCdva4vuTlIZoYuXgH1GV+6kjnSumum39Tbjz+mc4322Oxa/vhGhTulkM/rwAwFiK7RSeYoqsmak3HNRN9oDsJ7H8sKWyZSdd2jP+tS1TcGkIAzKempWGjaprVAQ4wSAGzYS942oqBME9mmD+cr54ezb7GTXu63/sUZdM+xzZX/orHLl7EKI1q4429R+XbrFvvDTdKLPc7Uxbesg257
 k298GRtS
 iyvqwaQV4K0/CDXpzr3F5tdChic7pnZ1Dxn5fchcM4Fo7MZOoSK4fG1GGOeA5Sq2yitrCS05KmahQLUgrjAEOB5KEi8oEPnKMRKw+ZK9/qrjh6eX2Il5tzJJSI8reH4+dAGdfFDwZP/DQHGJ1nQ/xmQVUwdt+Gq//mYfCjae+UKKatP4tdSlMIaR+gm9eXnrx+lRphNUWrrqAWy5fJbEPTnFHKcYepT4gKmntxOHjtAZbRTL3MAXkOLWiZdwTsLRwY4re8oAHXuIkdN1lsNDE1X6VwI7lyGpkLH2UGTo8tNnjm7X62l0i18Hr17zsoefnT4szeo14PHCqcGAM9oEu6mOiDq305kFRqGBcMV4s1fbh36adqqsIotuNB3+c+tgCP4+z
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
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mremap.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index 91f0865f6aee..1237718848f5 100644
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


