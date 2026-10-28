Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCA07606A327
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cJbsOXPg
Received: by kanga.kvack.org (Postfix)
	id EA82E6B05B7; Wed, 28 Oct 2026 07:33:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7EF66B05B8; Wed, 28 Oct 2026 07:33:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95B86B05B9; Wed, 28 Oct 2026 07:33:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B64006B05B7
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:33:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5164A140C25
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:43 +0000 (UTC)
X-FDA: 85371825126.11.F8B583A
Received: from mta1.migadu.com (out-208.mta1.migadu.com [95.215.58.208])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7007BC000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:33:41 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cJbsOXPg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.208 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793187221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eZqrRAG8TXvwglBXLrHZsQwJkLFjvZPLEOndgDiI778=;
	b=H9PvsOe9j7yyBCJj8mupMNTMtmnFyLjp4gufIsUmS7mC+yqx6biwYxqFPOore8NvH8oocj
	ITdzKiavK5Qgegqe65uU1ikV2PXO7NNAf+9dOp3Xnfiq4vBlA+R/NZPpum+hUCB10tG1Iy
	cHcTgCXSYZrzp50fiS44A64+Q0AzK9o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cJbsOXPg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of kaitao.cheng@linux.dev designates 95.215.58.208 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793187221;
	b=BSbAeN0L51v6Vt5m0MBSqQAL0ohkgwuyGwA2Fazr+xGvRskZdB4CRsLVkR+U5Pb6OI0DUH
	tQ5WcWgS9UfgHuxXEVdlF1c2FBPw6ft1AB5M+pjBUBvqa/D8wdj7tmuX23yD4mXKntezRa
	9FliGzgAff5RB1S+RVSsnyRpTvu8uvM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YIi5cqsLiN4R7MlgUKWwk2aRnfwmDatK/C8j4Mm1VPw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793187220; v=1; x=1793792020;
 b=cJbsOXPg1eiyW6Q19AS227PbMKVR1RRB6NBAsYxGXvQGcDXq8HnIJDr9nVb2pSOtFly873f8
 tYJTC8BkU6mPcj7004twsRVNb4q9MYZFEMEmOcK/I6daUo22ce8QfHqNEI9Hs4m38cPp03mQ6Fm
 vGt/eYv9zwbJ1fjV+xp68Meo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d9ad0361b8284d86;
	Wed, 28 Oct 2026 11:33:40 +0000
X-Mizu-Trace-ID: d9ad0361b8284d86
X-Migadu-Flow: FLOW_OUT
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Frank van der Linden <fvdl@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Chris Down <chris@chrisdown.name>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 2/3] mm/hugetlb: preserve CMA flag when returning folios to the pool
Date: Wed, 28 Oct 2026 19:33:18 +0800
Message-ID: <20261028113319.38544-3-kaitao.cheng@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261028113319.38544-1-kaitao.cheng@linux.dev>
References: <20261028113319.38544-1-kaitao.cheng@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7007BC000D
X-Stat-Signature: ft1k69whtofjyw1qj7rh8rb4nc3exki1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793187221-710845
X-HE-Meta: U2FsdGVkX1/6+/reuJl3dw5ScaO0ljW9cNm2BBHVXzM0i+nTgFVAblUWINU3GrSU9E+b/13P1R8OQghi6pGKaXvVUoSy/Ie0V/PD9waFFYawC6x9VDcrAYeFI93glYgQsx/4Vklk5zuLIdTecMsjh19YMIpKKPKke3MpLpzUdE5h2IMG77oZYaH9mi/U/2YMT+YLuLtPuENwfBSYWWXGdAkcdYlDeJ7jfpcKlzoiofey39TarCBX1qvS7dAV96e8GNsstjSkg6LJH9yiQkwjpJbkG2negWoynnsKiKHzETRx5Z1WYAFvuiDWqbLzcObp4IloSJ8BxKJjQhAFH/dz+qB66C+KxF/VwgLVQrE3ua2nxuvN5RoEUnNHgBTZG5rlolXLusM3WBZAZ7bS1T9gRzaZo8Ij1Ji7DyuxPkg/6NCR15y0lTpE1MxjmrIgADVKVEUlu5lH9USdiN/jWEH0bPsb/AzS2NT6LqQErdRcAX3QUiLkwc3THEEuEXbea6k6rPw9ZmjMd5ZztchcQ1rqkIItHaIPetIxXVpWzPbXbzmrh5HWxrajvD0jTfx5kotJQ4qs5j2GAX5efmIHHzXat4B91MSJibcHrVgU3HwQgnH2buqTwaa8wLumoy8YYGjKnpQ2nyl56VELnTpGcw+mCaPZrCxYOPDW2PyYOUAHbC9E1WwFGO6eHWEWgNYX8dvgIQB57MHuoHtsi9Tqy4XZolpeN1lUkvKXVMzGy4xSf+o71pQ1+fuHfy3rp7H+F+fynyGSsbSin2zjaBGwl4xx6xtR4ILtGghiHJsd2xKfr0vadPLR+a9FFm8o1uFN2QLISeQ5AP0md7lsIoRroirLPgKPAcCCNPCaqIlQkUFT2UcJmlYJ5z7moQWZnGPob85ZwuNyLccyWoVm7N+9mjhriIpmJSUCPy9A2Oh/Cw8fGfjbYNtho0crTrfzMXMxcZhDaO3WmxneY8/9TdAT7Sa
 EqpirLbs
 z68NG2E6eHgjroX3pCuHWs/O0e6ZKbki42jWc2u6+Hn8YlFpg7Gw09LGACDsY9eNQyBuSvzl9j0Wpb9QSoaYfKfoEC7HbmYGrh3/N+C48XX17uTaSCabudIZt0HthQQaT1s4dXWCQ+ViKRUpIJflQTYJ/kHpk6wdRwwipC8YA/HHwOq63pPvYd5sW8y1uxOE9PbdORiA9YrekMAPaQi+R0Oe7i8ghaLqtA/DFjmmGreSuOARxWkbfDvb8L8iN+b+9AOsZmCLGtaq8yB1AgsP2VOXdMi/E9+gkRWt2CDk6nPAQwUOt31/zjSabOaUd3ElJyz7BrkkqnIxyx8mMMf74XA+9IS7ppumn4w6D7uc0fdpeZNA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kaitao Cheng <chengkaitao@kylinos.cn>

When vmemmap restoration fails, add_hugetlb_folio() returns the folio
to the hugetlb pool. It clears folio->private and restores only
HPG_vmemmap_optimized, losing HPG_cma on CMA-allocated folios.

A later successful free then bypasses hugetlb_cma_free_frozen_folio()
and returns the pages through free_frozen_pages(). The CMA allocation
bitmap remains set, so the range is unavailable for future CMA
allocations.

Save the CMA flag before resetting folio->private and restore it along
with the vmemmap optimization flag.

Fixes: d2d786714080 ("mm/hugetlb: enable bootmem allocation from CMA areas")
Closes: https://sashiko.dev/#/bug/linux-5363eb09-9c3c-4f8b-9f3c-a998a8c4b258
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/hugetlb.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 4a008afaedf9..8da4bab676c9 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1437,6 +1437,7 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 		       bool adjust_surplus)
 {
+	bool cma = folio_test_hugetlb_cma(folio);
 	int nid = folio_nid(folio);
 
 	VM_BUG_ON_FOLIO(!folio_test_hugetlb_vmemmap_optimized(folio), folio);
@@ -1453,9 +1454,11 @@ void add_hugetlb_folio(struct hstate *h, struct folio *folio,
 	}
 
 	__folio_set_hugetlb(folio);
-	/* Clear all folio->private flags except hugetlb_vmemmap_optimized. */
+	/* Preserve the vmemmap optimization state and CMA allocation origin. */
 	folio->private = NULL;
 	folio_set_hugetlb_vmemmap_optimized(folio);
+	if (cma)
+		folio_set_hugetlb_cma(folio);
 
 	arch_clear_hugetlb_flags(folio);
 	enqueue_hugetlb_folio(h, folio);
-- 
2.53.0


