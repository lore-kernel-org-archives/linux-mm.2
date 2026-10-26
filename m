Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D53A9606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:18:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=N0Io6SX8
Received: by kanga.kvack.org (Postfix)
	id CFCC16B05B4; Mon, 26 Oct 2026 19:18:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CACF06B05B6; Mon, 26 Oct 2026 19:18:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B9D6B05B7; Mon, 26 Oct 2026 19:18:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88F076B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:18:17 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19A5B408E6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:18:17 +0000 (UTC)
X-FDA: 85366343034.07.C163A97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 42EB0C0002
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:18:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N0Io6SX8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NUBP2xRnXTWkvkzljjau88QTTUDveY6Hz9RAZJBGdTA=;
	b=KE1Gs1NDxN152S3zKZJMiEZu7cwi6UI6WUhHL+JcJK5XLcnEWcpthGc4vW7VvEct1w2xsE
	/uhJNQUzS2hYjzszx+GIHymrUyAjadqlM/4ogWuGZ2Nlp53VYSNDb/CMj+piBNTR0RihkV
	MCmzrKKp8EzWdzTSGVThpzmxpm0M9S4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N0Io6SX8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056695;
	b=3T8eAaf/PSiJ85xvbNfndyJ12JYEqQmoFwVeB5I0aKbnvLbW9RVWDuNvVuHZCZaXNc2bvH
	gLN/a/SYt+kZmy5aLJmk0fbrJqV8ANANyCPJJaGyQfPkQHgl5WyJbtLO2ephq5TCr8ivJy
	CdIm7T75FlDfOdA8TIzbEk4IsSUA+po=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7390C4095A;
	Mon, 26 Oct 2026 23:18:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4034A1F01828;
	Mon, 26 Oct 2026 23:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056694;
	bh=NUBP2xRnXTWkvkzljjau88QTTUDveY6Hz9RAZJBGdTA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=N0Io6SX8cBzzTDOb7cpNCY6FTZU/h+KZanqCjpiuERrlKcwqPUmds2XacPzDJEdk4
	 PYZRLj+AoUQoLE6z+36JUW94y4Bp88f3cJod9gQlvbGbNdqQlAhw18OBaLdHFRSS/q
	 AmNfMdre4JdR5YYAE/k4Rm8QdRbDk1YvBQqj3ljM08SjJ/W5VLEH6Of+WTIkuE7YcM
	 aAnkYNndmFBxnm4FtuLiESvFhlCip+lgP5vzefuhDl3xbxXkMESzxxRjpavTYuronn
	 umBEwX+v+06COBgPtWP50OU+jEh3Dd9mcFm9RqijNKNh6N3UEEBuJYsTMOvJ5UqGVT
	 OMLDSeCDpWsOA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:21 +0100
Subject: [PATCH 01/46] mm/mglru: don't use stack pointers when walking PUD
 and PMD tables
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2223; i=david@kernel.org;
 h=from:subject:message-id; bh=35PvaXKWWy0wg30tuDie4oWbed0+71n+0SGauq9bLs4=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu35+kxCFy6tE/r17VSuMD+w0ueUdwpk73e7hsKZNdZ
 IP9v4zojlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACZyJ5nhD5c65/fu+Q1lbuVX
 lQuzF8Wx5tbVeTgvc1zKKt+8aWesCiPDfdkuFpbL603lW0oeZNmsVj9stXrGL6G3u6s954V9rgn
 hAwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 42EB0C0002
X-Stat-Signature: mcow6ok456qu85tf1juiouufra5u5fdj
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793056695-935708
X-HE-Meta: U2FsdGVkX181FRh7iAsxAPQSW00/jLUSbyp07gap3yYDDj85wvEhkumawXsdM9SzOsss/RTEr337/Dhc6KfNM03VGxgwqhGIWxn3l5SmpKXWR3Z5mEBeIPz960uHnudgfxN3nHRygEZzW9VMEwJO7WHFJacxExGmcS1YTEtJH5ud29gpMbhpo4UvUmh1iQfko/0m9UFnYTxLM3ui83fasRMTgr6ESo0PpegTdrAMF16Hd68MdsyZgoWAzyF1HOME1MVX6Sr87wUvCVVEhxI+x/oSbfHxF4ctwE0N7vBwdBflzdhYajLdb9G6qTM34Xqndk6awKNh4rXz3ho+lr/7nOpQVSS8DvUl4dI3P+6x7RgSClYGNjchoVZlA6KlT6mQgGGCwyvHOD7Rw51NCRbU2/oTu6z5IowZgX8Ys0gjcXAi9i1242vM9wBtylwcmd91esKZr48z36RcHj+Vs+QeGnGoxaWk2UWOEruAiN5kpgepksFXQrcFGUvY5sYNEPnkWxl721nYmojsfV/sdyWRyCJKY8jSZf5i/ayoCSmKFB38sMTuhHhNXepvMYbbum1Slyu9AhRqEKLp0bxjZ9TS2Pd1XYMX34xOiz/av/OOH9ssUMQOBFCvm98ZCNTfYbtMDHdpuFPGm5St6nr3OWqOSdd88gV4t/yxigiZZG51wdtdyr3Kcn0MxO37X2I0NZyixVJUDAC+rA6PO1hx5MkDhAL0yACKnHkMsaOxOXgFtdfASj31x5V3y7vrswF43z905koJ2L93DwpfKuAfSeVpXIE2ZwxMkiqcXBMMgA5XoppguApSSay9A1U6jJv0XJ8C5bdOrsR8Bwg7dPnxWsawqriYEeH5lDjcufUvQmoBaoxs5BLUT7egzGvg9YhhUq057+ev97zJ/hP7bRLEuGYSD19yKgOW6UriWhTuqQYZ6tZKK+8X5UP4NZ2Cctd/46MO+PA+UsVE9nFyXny8uIM
 l44ePkOf
 euovkEx//86UeXxR99hBU8BsFes7/HxtKcMEU7BhFp3g+l8uVMXTcaoXcYnkyGOekLJArmLUwhMMKGNFCnIK5DLTDQey7fJ8CKEP10xYoB63MJwYTLf8oWznaDyq3rdBZLHdso1jakaa0Bw2JP8teJ6Zape88bl0ftiW3oohK6VdCQ90VrJjtyvQnfpN6sAGoLcYYVx2Ymq/kdPIHxdxljbJi7sIS43CtMGnnEKytFw/6nt/qIyvmf3bAZposaTc6ccW5IDyYCaX0nuh6q5udLdJMT9O3Zo18esoeAA4V/ANidB5eEGah6lJIGMCbNqImCj1XdLXKY4+Oaly9gOtJykRK/Ecx8otKZcIjGHImM9ST1+sjzxMhHwDhmlBSvRIPxCP2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

MGLRU passes stack copies of page-table entries in walk_pud_range() and
walk_pmd_range() when walking to the next level. These copies can become
stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
table concurrently.

This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
support page table walks"). Likely, earlier locking masked the latent
bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
retract_page_tables() without mmap or vma lock") allowed concurrent
retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
for MGLRU") dropped the walker's outer RCU protection.

The fix is simple, so just fix the original commit so we don't have to
speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
RCU-protected lookup and validation against the live PMD. Note that the PUD
handling is required as well to handle folded page tables correctly in all
cases.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: handle walk_pud_range() as well, clarify+simplify description,
         adjust Fixes: ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce83..6a1af9b92349f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3911,7 +3911,7 @@ static void walk_pmd_range(pud_t *pud, unsigned long start, unsigned long end,
 
 		walk->mm_stats[MM_NONLEAF_FOUND]++;
 
-		if (!walk_pte_range(&val, addr, next, args))
+		if (!walk_pte_range(pmd + i, addr, next, args))
 			continue;
 
 		walk->mm_stats[MM_NONLEAF_ADDED]++;
@@ -3947,7 +3947,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
 		if (!pud_present(val) || WARN_ON_ONCE(pud_leaf(val)))
 			continue;
 
-		walk_pmd_range(&val, addr, next, args);
+		walk_pmd_range(pud + i, addr, next, args);
 
 		if (need_resched() || walk->batched >= MAX_LRU_BATCH) {
 			end = (addr | ~PUD_MASK) + 1;

-- 
2.43.0


