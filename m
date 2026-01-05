Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 852E0C79FA8
	for <linux-mm@archiver.kernel.org>; Mon,  5 Jan 2026 16:18:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD986B0187; Mon,  5 Jan 2026 11:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C78366B0189; Mon,  5 Jan 2026 11:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7B2C6B018A; Mon,  5 Jan 2026 11:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9F47B6B0187
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 11:18:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 47C6219A55
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:18:00 +0000 (UTC)
X-FDA: 84298416720.06.5B2D02F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id A5CA88000B
	for <linux-mm@kvack.org>; Mon,  5 Jan 2026 16:17:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767629878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GEX4MkpC0jBNCkQWrEumFF8hkzLlxpmiUcOZMcLoJBA=;
	b=TbuApLbJHxAUr/G+flwgZxIsrHQPryCNvwp3QbhruaSIG4hIkKgZneX45u4l+0K2ex3cT4
	CfOne37PMzQKezqOAvK1E6lwXZfOO7U44BRkxkRitYvAehaJ1WALpX9A5XCs/LA7UujV3J
	4Y2AoRstcFuqdTMowlF9megSioZ0Loo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf02.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767629878; a=rsa-sha256;
	cv=none;
	b=Z61qGWHLPHTTlK8NNeB4bbw1KDx7zb7HjCyEE/2OWK9WSAVgguBx1Kq3PNuhshn//VM4c3
	zJRJi6qh8axDNkOm9RI6m/JMrb0IOFl7vQXhyQQ5MEm57/Vq6Bdh7f29gWlPMLujnJwWOh
	mKV01HMkfjKxZazGZFhyhGQrgcvA7Ao=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C66C7339;
	Mon,  5 Jan 2026 08:17:50 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C1F973F6A8;
	Mon,  5 Jan 2026 08:17:55 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 2/2] vmalloc: Optimize vfree
Date: Mon,  5 Jan 2026 16:17:38 +0000
Message-ID: <20260105161741.3952456-3-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260105161741.3952456-1-ryan.roberts@arm.com>
References: <20260105161741.3952456-1-ryan.roberts@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A5CA88000B
X-Stat-Signature: huyihormkgu37bmyenxc1sz9qadz6zp3
X-HE-Tag: 1767629878-959488
X-HE-Meta: U2FsdGVkX19kh0WYCalW2hJgNAIoNQ1GNu4yO0jAD28C5Kn2TS7bMYA5+pvrv54ZwU/re7TkWYCSorzNezE44uqbxDTpL9aXJLg/3M13YSGl/A/b31N2n3dQdItm+lzNjp2SfRSmpLXFRNfx25tQnEGHi1B9/buEJv2MwxHZaIEsI+DbT+rKY+NDjzkQOnVZDCP+4itIMu+eOhoaz3Hj3gnoPUKMHgjvGHb0gsWGaJmg0EerbhTgbHpENiD/rH0DvHAaF2lZm+txqxgnUGDxE+JWO+XFj+8+vn4iy3h0uuhzxbMc8RX7hGC1mIb4gC10OCI0Mf5IAhRJS3XT8v41aTy4gnIXvsVfmVmJMj2A+47f/FdJWtqULcPDFm8Ei5TvqzqbF9Alc7JFCuf/MCBnj5KYwipGPwJCRiSEnql+5wSS5qb1iUYMItBr82+IUvoxbt8N1C3Bo/2r5T3s34IsfEIP59sbl7aHnVs6akmHJF9wIFKqYaHcJiGvIWBVhqjUAPRDe6pErFEOHh9ZERp3C7ObtRlgYPfJURic8hw9ZozOGacEIIIx8UvWzrcCDE2LuvxiIoVWgvtiokpnjUhzQhrha8ddSKV3NKBehp2bp3vILkhEhWC3ht8yiGhz1R8MqMvJ3ic/5HBXfFsQ3/gaop797kjxmYF/LHSwJFAmvMSd2QuFxr/Xoa811SKEa3W2EoVOSmT245+2y6xk6HOA9+Km57RwcnSCSE3t50lEeWzpW1TRPa76yDtDBWGb8Gpamo8NijzsYfJc6EaNACQ+6bgXWrqbMah6f1cigvP4UAqqgXQwuTTZiUgmt7Cr4fL3s3+zUZ7oO6CKoJX5tGmtsNcalHURhHtVsjfQJuyNIYbN8Y4LYARj3WQhbhjZi+m17H0x1hgt8l17/+1aPDyQAJ99IEgc58AVfjYNWBpsnItp7vuxSY1/vVoanXg7rUtqoIUE/IYYt4tP5gLh63X
 qG7iGOa8
 LA6NnDs3JxEpSsE5/DNMPKdQWeJvHfxJ78GB18CYmd3C8bnnDPq9eeJUCxz2y0Do7T2ebzAGNS/B/jzFYZai5SBfuAixGcvpdibagrINK3gJi+JmGCefqfQgaqm/tqkcybuxYXDVShUh/zxdmV+5IWBGk4ZkcPnOJGgAqbLrjSccevjW4cJIPCKTSILAmNy2j3uwhYMEb6JLo47cwhcHJvqeJyyzcHlD1LA3MWkYSyzX46ARAG1PTo5UKPWx7/xdsfLACUoa5gJLMGBm2UXQNqHSx9dbfDmhndzCO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Whenever vmalloc allocates high order pages (e.g. for a huge mapping) it
must immediately split_page() to order-0 so that it remains compatible
with users that want to access the underlying struct page.
Commit a06157804399 ("mm/vmalloc: request large order pages from buddy
allocator") recently made it much more likely for vmalloc to allocate
high order pages which are subsequently split to order-0.

Unfortunately this had the side effect of causing performance
regressions for tight vmalloc/vfree loops (e.g. test_vmalloc.ko
benchmarks). See Closes: tag. This happens because the high order pages
must be gotten from the buddy but then because they are split to
order-0, when they are freed they are freed to the order-0 pcp.
Previously allocation was for order-0 pages so they were recycled from
the pcp.

It would be preferable if when vmalloc allocates an (e.g.) order-3 page
that it also frees that order-3 page to the order-3 pcp, then the
regression could be removed.

So let's do exactly that; use the new __free_contig_range() API to
batch-free contiguous ranges of pfns. This not only removes the
regression, but significantly improves performance of vfree beyond the
baseline.

A selection of test_vmalloc benchmarks running on AWS m7g.metal (arm64)
system. v6.18 is the baseline. Commit a06157804399 ("mm/vmalloc: request
large order pages from buddy allocator") was added in v6.19-rc1 where we
see regressions. Then with this change performance is much better. (>0
is faster, <0 is slower, (R)/(I) = statistically significant
Regression/Improvement):

+----------------------------------------------------------+-------------+-------------+
| test_vmalloc benchmark                                   |   v6.19-rc1 |   v6.19-rc1 |
|                                                          |             |    + change |
+==========================================================+=============+=============+
| fix_align_alloc_test: p:1, h:0, l:500000 (usec)          | (R) -40.69% |   (I) 4.85% |
| fix_size_alloc_test: p:1, h:0, l:500000 (usec)           |       0.10% |      -1.04% |
| fix_size_alloc_test: p:4, h:0, l:500000 (usec)           | (R) -22.74% |  (I) 14.12% |
| fix_size_alloc_test: p:16, h:0, l:500000 (usec)          | (R) -23.63% |  (I) 43.81% |
| fix_size_alloc_test: p:16, h:1, l:500000 (usec)          |      -1.58% | (I) 102.28% |
| fix_size_alloc_test: p:64, h:0, l:100000 (usec)          | (R) -24.39% |  (I) 89.64% |
| fix_size_alloc_test: p:64, h:1, l:100000 (usec)          |   (I) 2.34% | (I) 181.42% |
| fix_size_alloc_test: p:256, h:0, l:100000 (usec)         | (R) -23.29% | (I) 111.05% |
| fix_size_alloc_test: p:256, h:1, l:100000 (usec)         |   (I) 3.74% | (I) 213.52% |
| fix_size_alloc_test: p:512, h:0, l:100000 (usec)         | (R) -23.80% | (I) 118.28% |
| fix_size_alloc_test: p:512, h:1, l:100000 (usec)         |  (R) -2.84% | (I) 427.65% |
| full_fit_alloc_test: p:1, h:0, l:500000 (usec)           |       2.74% |      -1.12% |
| kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |       0.58% |      -0.79% |
| kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, l:500000 (usec) |      -0.66% |      -0.91% |
| long_busy_list_alloc_test: p:1, h:0, l:500000 (usec)     | (R) -25.24% |  (I) 70.62% |
| pcpu_alloc_test: p:1, h:0, l:500000 (usec)               |      -0.58% |      -1.27% |
| random_size_align_alloc_test: p:1, h:0, l:500000 (usec)  | (R) -45.75% |  (I) 11.11% |
| random_size_alloc_test: p:1, h:0, l:500000 (usec)        | (R) -28.16% |  (I) 59.47% |
| vm_map_ram_test: p:1, h:0, l:500000 (usec)               |      -0.54% |      -0.85% |
+----------------------------------------------------------+-------------+-------------+

Fixes: a06157804399 ("mm/vmalloc: request large order pages from buddy allocator")
Closes: https://lore.kernel.org/all/66919a28-bc81-49c9-b68f-dd7c73395a0d@arm.com/
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 mm/vmalloc.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 32d6ee92d4ff..86407178b6d1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3434,7 +3434,8 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	struct vm_struct *vm;
-	int i;
+	unsigned long start_pfn;
+	int i, nr;
 
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
@@ -3460,17 +3461,25 @@ void vfree(const void *addr)
 	/* All pages of vm should be charged to same memcg, so use first one. */
 	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
 		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
-	for (i = 0; i < vm->nr_pages; i++) {
-		struct page *page = vm->pages[i];
 
-		BUG_ON(!page);
-		/*
-		 * High-order allocs for huge vmallocs are split, so
-		 * can be freed as an array of order-0 allocations
-		 */
-		__free_page(page);
-		cond_resched();
+	if (vm->nr_pages) {
+		start_pfn = page_to_pfn(vm->pages[0]);
+		nr = 1;
+		for (i = 1; i < vm->nr_pages; i++) {
+			unsigned long pfn = page_to_pfn(vm->pages[i]);
+
+			if (start_pfn + nr != pfn) {
+				__free_contig_range(start_pfn, nr);
+				start_pfn = pfn;
+				nr = 1;
+				cond_resched();
+			} else {
+				nr++;
+			}
+		}
+		__free_contig_range(start_pfn, nr);
 	}
+
 	if (!(vm->flags & VM_MAP_PUT_PAGES))
 		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
 	kvfree(vm->pages);
-- 
2.43.0


