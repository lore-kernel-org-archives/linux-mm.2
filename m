Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F00D606A32D
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YlKsdyMX
Received: by kanga.kvack.org (Postfix)
	id 2BEA66B05D5; Thu, 29 Oct 2026 16:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 295ED6B05D6; Thu, 29 Oct 2026 16:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 185456B05D7; Thu, 29 Oct 2026 16:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E92D96B05D5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:39:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7CC3E1C39BC
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:39:27 +0000 (UTC)
X-FDA: 85376829174.26.14EAB7A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BAD1280012
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:39:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlKsdyMX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=93rB4MhysMhGYbksem4hKuOQyLx77syArI3hVZIrAK4=;
	b=S8BDFiPRyEc/oMP8jYB5BvAKwnIdPbr1jGa2DQIM6dXsrGyIvNtK0MGjVmN2ocg8YAvWv0
	58gsipJXbJirt5Z8j7vDxHV9jlywdGeDonGGinsktzSal+GapK/HmtfcrNg6D0eloNCf6n
	fBsvg25yH9mDE6bY5m5okvijcWscHaM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlKsdyMX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306365;
	b=ITzvMcVM6sZrudWKEKJPAYhNHMFfIGQxOrVuwnnNoOCmQ8hJ5nj44EwRQAoil1lvpOBBY8
	4wKylaKJD1r21Cf/rlCxK+rFGRIw+gF1JQaPFabARsMIlNj7gRQvdaiBNUU9XS+I9tZQ5F
	y1n4asuP5x1juT7vV22fIshAM3dVDXw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A4836060F;
	Thu, 29 Oct 2026 20:39:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46BD1F01816;
	Thu, 29 Oct 2026 20:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306365;
	bh=93rB4MhysMhGYbksem4hKuOQyLx77syArI3hVZIrAK4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YlKsdyMXMe5uYCu83iB8MjgJNBo9ihA41CeTCek8Yphz+cIivFiF1PQxyAHfKlko2
	 0QD32dcJV7Ck4q1Js/ZOHyaLk5WAydTF1kdrarTAi71AJ2YwjxMAGMNmEnCtnAQv2X
	 /S+Ch98lQzbrbvWpHx+QzNZiP2EkyoOo6wYgdlvQ6g5ScFZPceMS3op53bXt/B+Enq
	 BED4rLyLLGRwSKp0Qq4/93GOyLtpiPv7fa0DrCe1bq0HxIbRnbojjtmW2X4vwKwoCA
	 6slZ9Mrrp4KHRhq1orGCO3BkyyXd1JC+utuS4SS3T8j4nbPnctubqyoD23R0oW24tJ
	 liZ86yXMtu6FQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:19 +0100
Subject: [PATCH v2 24/47] mm/userfaultfd: wake all waiters on unregister
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-24-a64ce7f83abb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2376; i=david@kernel.org;
 h=from:subject:message-id; bh=IeP32edqUnfVhMXgZn9k/7GJXHBVF4YDItB/FrA9iCo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer21fZssROqlhS+ofnxNzpMU1gq+eX5g3y+T4lOjXX
 xuvrzmU2FHKwiDGwSArpsgSFHzf4OXLdbXVbnzMMHNYmUCGMHBxCsBEbh9m+Kd00U3ugNZCHgbl
 956f3Nxt3+u73ZzEdEiM7/CD6oz54b8YGbZURRyZ7WzlLbfCpOulgpFegap5/aGGTfnfm7o63Vr
 msQMA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: BAD1280012
X-Stat-Signature: mkma3ux19g3ufjhygt44uxk6sbzognbb
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793306365-870555
X-HE-Meta: U2FsdGVkX19q08wCTBmUbt78Yesd1OnCo2VGsdmRN/qSjOWoHxuyvjzquPLSTIwNS0f2z8gNZbpBsPfYBQKRdb5S2SC9aXZIAn1+oslWIDpvZu67thNviq5VzS03+YfUdy74+V2bRy1zb8SpmiTna9VRE1HN0g5FKbaEkW2j8+fo0XFH8gmvI/pHMRfS3JXheqyu5jlBChedD3yecWM04ddtuz5WwbTCwBIOqvOllOkjS6KxDoRSPURb1GF5cV1/9B+5zMfJTEkX9ruQwxtmSGv0FKtxs0OgLZPQ1sSLc3oG/xGm2eo8A6Zfts4pRKMuy5mJUZmh/WlWTNSw8Me6sQfE7jjq/xCe3FJ5V2N/S3uVY9hIWMHWstHtoAtRJSz37ud63/t9cSrHBP5w+DqTAYs2gmSsifV+YTyOzFN/qmCyx6NqvWpm2WsUcxOBvyGoKLDhfnW1gfkPvvOVc1UVh2LUx5DY578vh9kB4pRryXSz5q3RUxqskUeE3Vc815F7xKJv9JoHXBR2GNSkzstFQhym+aFPoA+p6lRn85SD4VzgvCHcg2XC7jCemUtvT5G6TkTUxpsH/ew9eRhNLCAVI+vBMtXbnC+rHEayZl9UYGDi4qrm/jHrgvChbI6FSR6fkfQM3/pBijxwk9m3GfRysX1ST0RWA51Eo7Gs2mLnLSkza90vrMkIJGqAQmHuoTB8aWadfFn8/fgQ/aU7jPVzIpxH40GGSsSdsFucYi+3AmpLNioZ6fnGje+R2U+oFibP1wHCEClQtEuR5ZKxeUUU3jfq9r3kVuLl7eb1CYpN3kqBRctwWe8o40GFCtPh2yKC5bazygBBpqiIwt3y7k2GMmDOz7buXT20awEET/7KfAXOqnhgjbgUFbSQ4Bjy9zJQ329/oyLOx0ey11489SHJaLbnwRA9GHjAXwai8yBBYFuwrdBHLmZ6Ity8S4WquOR3R/mbI5P3zKxVBW1nWNi
 2YIFVB6E
 t14il0rGfhKnemUN7LOagnJSDEbYmifAWT6P5/P4g6seK0ka9kngt5L4xXzfOqJLwUHWUmVmkxQ3H5tuZzM3WAUN2PsH1urjMIdKnzvTX0Hn7uNj4evKbkjdPu0FP5jk/ektdMhLSoFCEb4jJeCnyh4a8KnCYQMEcm7pNuux+k0m5fMoQ1XOtGG9f6eHz0YdnGke2I8724eUkply+QwMVTUlTu1KptLp0uFXK1sne++vIpLc4vR6QlTf/g+7Q5T8BSTCzA9OJrL6/4AsxHEvVLc5hKqTv+7i7J6Ngt8o/GjWZnGqNLGlpyhaB4owOEQNmkwHdUA0GUGDWk9w3368810jNsSUlox/H7s/E1MaRlhlKtNbXfL6k0sKAyKX6oD+OPRHC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

UFFDIO_UNREGISTER only wakes pending faults if VM_UFFD_MISSING is set.
Threads waiting on write-protect, minor or RWP faults can therefore remain
asleep after unregistering a range that does not track missing faults.

Wake pending faults regardless of the registration mode so they can retry
without an explicit UFFDIO_WAKE or closing the userfaultfd. This matches
the existing behavior for missing faults, including removing unread fault
messages for the woken waiters.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: rebase; simplify description ]
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/userfaultfd.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 3ca04b582329..be630674fda9 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -3977,6 +3977,8 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 
 	ret = 0;
 	for_each_vma_range(vmi, vma, end) {
+		struct userfaultfd_wake_range range;
+
 		cond_resched();
 
 		/* VMA not registered with userfaultfd. */
@@ -3994,18 +3996,14 @@ static int userfaultfd_unregister(struct userfaultfd_ctx *ctx,
 		/* Prevent new userfaults from being queued after the wakeup. */
 		vma_start_write(vma);
 
-		if (userfaultfd_missing(vma)) {
-			/*
-			 * Wake any concurrent pending userfault while
-			 * we unregister, so they will not hang
-			 * permanently and it avoids userland to call
-			 * UFFDIO_WAKE explicitly.
-			 */
-			struct userfaultfd_wake_range range;
-			range.start = start;
-			range.len = vma_end - start;
-			wake_userfault(vma->vm_userfaultfd_ctx.ctx, &range);
-		}
+		/*
+		 * Wake any concurrent pending userfault while we unregister,
+		 * so they will not hang permanently and it avoids userland to
+		 * call UFFDIO_WAKE explicitly.
+		 */
+		range.start = start;
+		range.len = vma_end - start;
+		wake_userfault(ctx, &range);
 
 		vma = userfaultfd_clear_vma(&vmi, prev, vma,
 					    start, vma_end);

-- 
2.43.0


