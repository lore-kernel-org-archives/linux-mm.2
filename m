Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13C8F606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TBb3ZJbC
Received: by kanga.kvack.org (Postfix)
	id 4247B6B05B3; Thu, 29 Oct 2026 16:42:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FAE66B05E9; Thu, 29 Oct 2026 16:42:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 311786B05EA; Thu, 29 Oct 2026 16:42:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 117DB6B05E9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:42:24 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 27B331A04C6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:42:23 +0000 (UTC)
X-FDA: 85376836566.05.70C22F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 54DF140007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:42:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TBb3ZJbC;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306541;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7RYg5h2D7p8QXMl+okHSyCLmxQpieD4Ay9U30Ul4Os=;
	b=hCxSx0OW6770zXJUWbbAu+W2p7wOqiJPkbcnPKzNftQm13Pjv7P67SJPz8j6B4dIC0oLX5
	SUJ6DD0oypcQuBW0zr0El1rfZvW/VoQId6bxuV8L0IC6+PusZ4BsqF+OPsQRenz8kG2UTV
	BezQMznrnfY9EMdgwqSrz2+jNeLn/E4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TBb3ZJbC;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306541;
	b=s9hiMF11DhljgKxSvvCYLmb+KLdDWnvZ6N0selTm5UTi7ODWzP+ho9tLcbl3/Lv3X7NYec
	iiwQwRbjvszW+S8pxNjj3C+whNqdUXzix8mI/N2jrAWY7Bkbc7xPPnbTvZRfK6TKAmTEUq
	31/T0Qedav90na8TMmNuBvD8+iQq6yE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 94E9941A18;
	Thu, 29 Oct 2026 20:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F6521F01828;
	Thu, 29 Oct 2026 20:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306540;
	bh=t7RYg5h2D7p8QXMl+okHSyCLmxQpieD4Ay9U30Ul4Os=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TBb3ZJbCQasNHJ9vehOgkMBuvVuxUnA36Qy5qE1aq+MkrIUVvYyQfmLsrZ1G2wl5K
	 W5zLXmeYPlK7j17PamK961yty+mZimw5UxdunC19gNXpSQa7Y3AOY6CLlkyWTzMdY2
	 /DGe1y8MXhbxfngyG9fv1FgTQlIRX3eZ2Uw3wrT1zLXNkniVWoDNppVY6YrZPhrZg+
	 A70Q5xhY7fkYbNjOrJDkXHi+fsXT7YNtPJBP34l7R3IRZCbZYvQcGPxX34mHcmnyUM
	 hNyc6ue5xF4ZnbzL/QAg0anhjNIk5nrHjfAz1cy6iVu0/+Vo2b6vVi5shq5xWSv29r
	 yqF7fhnnFVDLw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:31 +0100
Subject: [PATCH v2 36/47] mm: fix unmap_mapping_range() beyond 4 GiB on
 32-bit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-36-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2239; i=david@kernel.org;
 h=from:subject:message-id; bh=FaMGvBz2T3vWhwVxRPgiVx8avhRKMEtK+bszIc5YQPg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+3UYBdOdc4OsRe4dcYm/IWlRsLr4/8u6jRYlmQKs
 m76JWLbUcrCIMbBICumyBIUfN/g5ct1tdVufMwwc1iZQIYwcHEKwETmuzAyXCj+uuyi290tD3zU
 dPIsJ7toCFryWsZe4PSNseAPXraEkeGfouF9z1zh1MDXleEbpm8V5fqXbFjDdG+fl/L0BTF6S7c
 wAAA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54DF140007
X-Stat-Signature: b9xwyadaq9a4bgntsitkeestotzstcqh
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306541-236123
X-HE-Meta: U2FsdGVkX1/3SUEAyBmds578ntM5G9W7eeZLVotp6SY3rtPwlAEGqgDzNSTLYjxS8WR4FAd3ZP3K3sim7PUgMNMZD6Wj/E6r0pyE7IWF3EkUEanybyibBcGjr/qIFzTnJ73SlMpiEPUcjQdXQjAIwqy/ATxanEE1d8HRzipqT7UVnB7YtGMVp8FuWswQvi0R9NTUMxsFTvKuGnipw+unr9NgXkX80D3H4Fr8vukRbGvCi43rra2WypljAps6iNZPRR7hV97Y888hQ7L1G0ZuFIyC8sKh+1SH0yTuJbb80lhOCTXRNOUiUoQvwThkdvNh3JmIaw00wI3P4jWB3w48ouX8cGPo5OIzBpgH6GaXDT3ZbS6mYwFOsi61Wyq57Vsp+PfpfY/ZvHJclrEP2+Mg8zOk8z/2VMAtEILwUdOQAgi27eFjGaMgbf5Q7Czi6Rt7Ayq9VVhlzh8eJsXtNwFEziyv3ANBmjqbiY2rRELFFFIJpU2MkofIl6CAgw4juS40/xjOaQjW/Q30edpGTLCvYjoq5SKWjPqKu/kAlyQqSGW/Ib4iSAyUt+CCfiz77qkxd0olS9BXFCnMwXKIVgddQ8UmNpb4Pvrt0LoWF2knSEtka1/ua5ufr1+bI5qtemhi5ixpkYf2TUDj5cDYglHZS/SjXBwq9ytKOfLVwCgsKgnNFlKnPw4HFInHFJ0gIWy0AXe25d+MeN+aNIFb752st6Xsu0tpLAx6wLyjRDGuFC/C9Do8RTLxkpopWUPgBUJaTjJVNmXmWdmeAUtzl6IBk78Kv3PLobpwiuHlglv34Kp1n7Asx1wmvp3t6DPcBXXb6fxo4sGLjCNrPKyLiPLBzjGx7/mvYN4Crkx517Ns7Zvw6EcaqE6nYZXiefC1jpj07qg2wHRXdj681wD7Brcwq/atzYpA0WzaP4MY6wlvZO+wr8xGHl6P1f3arAzlldMQm4vjqjkk8ZM6p+gGCl7
 fJEs2opg
 fkVahDEMLq8yjfxXFiDxlVAz2ia+ChJ21dSJ+QXitJ1I78qNAZx+KZBl86YhvXLuTidgFJRrqwD0wEw9dJGqDBjxKIkWTlwzu14GopCj6n7U2EjncRcDmcqSEK0eN6mPFpQ7cgWz+TBhe1HMNLLlgMFu9dRyz1It+1DDe0mQeVkei7nZIi1U5nk83JRR/zIdtkOPrHfK7y/Y54LJPg1r8/RsUD/j+plvEEdX5Igb2XQRGkkM+OYPhDH5DcvnGJ+WR2qopqEX5QuIDH9yBQ4bC85DIVYHw+Kb2sCZFzyzUHNihBPq0kGl7LXZksfAvp/MTumOoL30G9P9uqduab+/ZboHq999esi6Mb9UKkkrhDhbXrRe+0i77K9IrOv5dXqv0LYDeTx2BpLXrHbYX6tN9mvaftl8PkgMtxkoyCFgvjQGwaqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

Commit 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
made holebegin and holelen unsigned before they are shifted, by casting
them to pgoff_t. That is an unsigned long: on a 32-bit kernel the cast
cuts off the upper half of the two loff_t values, so a hole which begins
at 4 GiB or beyond is taken for one in the first 4 GiB of the file.

truncate_pagecache() passes the new size of the file and asks for private
COWed pages to be unmapped as well. If a file of 6 GiB is truncated to
5 GiB, everything from 1 GiB on is unmapped, and what a process has
written to a private mapping of the range between 1 GiB and 5 GiB is
lost: it reads the contents of the file again.

Where the range has an end, the wrong range is unmapped instead of the
right one. The page cache copes with that, as it unmaps every folio that
it removes. The callers which only have unmap_mapping_range() to get
rid of user mappings do not, for example drm_vma_node_unmap(), whose fake
offsets reach beyond 4 GiB on 32-bit, and revoke_iomem() with physical
addresses of more than 32 bits.

Cast to u64 instead. Nothing changes for 64-bit kernels.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 9eab0421fa94 ("mm: fix unmap_mapping_range high bits shift bug")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index ae8d567bc6ba..732b8f926de6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4649,8 +4649,8 @@ EXPORT_SYMBOL_GPL(unmap_mapping_pages);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows)
 {
-	pgoff_t hba = (pgoff_t)(holebegin) >> PAGE_SHIFT;
-	pgoff_t hlen = ((pgoff_t)(holelen) + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pgoff_t hba = (u64)holebegin >> PAGE_SHIFT;
+	pgoff_t hlen = ((u64)holelen + PAGE_SIZE - 1) >> PAGE_SHIFT;
 
 	/* Check for overflow. */
 	if (sizeof(holelen) > sizeof(hlen)) {

-- 
2.43.0


