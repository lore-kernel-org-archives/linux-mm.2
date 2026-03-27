Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B32A010ED674
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 12:57:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28F926B0098; Fri, 27 Mar 2026 08:57:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2675F6B0099; Fri, 27 Mar 2026 08:57:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17CCF6B009B; Fri, 27 Mar 2026 08:57:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 062246B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:57:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C86A21410D1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:57:47 +0000 (UTC)
X-FDA: 84591844974.01.A6A54EA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id F19AC100005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:57:45 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vedtCy6d;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774616266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJMvUTaWi9bVQJRwL5OtdkaFOJWuBYYFxLts5x007Qg=;
	b=qAHIZBP8d934fRdP+CY14eu3iiDiGPLSOukOmJtftiRWGP1JngXHrIw7pI63PVuJwNYlyu
	riJxDEn/ki6kM4PwKBlgKjgm+0/Siw04SI+0wRR7SJt+IlU1OWWOfYMfzmhUVZsx6dUGff
	evQ1Np+QVDI0naCEI4c7AwvXMemLla8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=vedtCy6d;
	spf=pass (imf05.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774616266; a=rsa-sha256;
	cv=none;
	b=kjUdSYXd3rm1juxbYd7K9A+3szCNukzOARNn9t/YAea+Oj1MtR5KtFgmfcc1VFHa2PKIML
	0JPEGruVxiQtrqnh/iQgRU67ThVBizqfo4eBDScgyohaNPVeGmB8bTafpZt2es4Q6qD8vf
	lIGBSA6tNKW1/ZNRH0VFBDgiQS4VkmI=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01E8F35A1;
	Fri, 27 Mar 2026 05:57:39 -0700 (PDT)
Received: from e142334-100.cambridge.arm.com (e142334-100.cambridge.arm.com [10.1.194.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 08DFE3F905;
	Fri, 27 Mar 2026 05:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1774616264; bh=U/ncK0j4auSiim1AZ43YtKYV2rZY6C5VfPkBzb2+7f4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vedtCy6da8VZEeX8xyArTIgFESd5s5gSC/l6pJhebIgd3O1RsVXPKni2xxSF/3Rv+
	 e/rYCKBI9mBgj8potQ+WL49SMMJY8ze0IWosgHrW1RejrNCZ5C75edd9PMm8/GS3+l
	 PQ8jUVvD5rWEzPjORH1Zze0549hyupEBzJrt7VIw=
From: Muhammad Usama Anjum <usama.anjum@arm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Nick Terrell <terrelln@fb.com>,
	David Sterba <dsterba@suse.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	Ryan.Roberts@arm.com,
	david.hildenbrand@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Subject: [PATCH v4 3/3] mm/page_alloc: Optimize __free_contig_frozen_range()
Date: Fri, 27 Mar 2026 12:57:15 +0000
Message-ID: <20260327125720.2270651-4-usama.anjum@arm.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260327125720.2270651-1-usama.anjum@arm.com>
References: <20260327125720.2270651-1-usama.anjum@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F19AC100005
X-Stat-Signature: ck4hjzre7rb4o1pf9is4jjrwxyqnuhod
X-Rspamd-Server: rspam06
X-HE-Tag: 1774616265-814176
X-HE-Meta: U2FsdGVkX18C5UMPUtM9c3a4g5yHatoZC2lp7CkPRR8p3pgNbaGxCHd1KL6NiChHGC7TdyNt9h6XI/iIQAYpuAzx62j0hOb9uYqDYxrh5bT9ALGpIPM3kL3cB4wj5f5WS1rbC8rgvV7YnZ16+tX7AT8Yra0vICo7hyWrMn5JVLUXLvz8lXE63JtwXQSGtdNsEv4m6mlhIp3VtHLfHhh3Nynv+/hpIjx97GtimzFz3tD4Fmtb8wzmHPYuy5AbXHiMVWJJ6AewGfMPE8Q3ikvf1PjR5AfKKTBaQtomoZY+m3kjOSWh4CsVtHFwkWRWMrkUTA/Q9N1rd2TllX8qLytPOevgvkDkaq5klIdDT060ghXWdio6FXuaYdIwSCTYPjvcpipvmN7KNKGwdOzxhpOb7ymbzlSw0WfnREoltNDdj/bqVyffMXJi2HwqN6E6+Hr3iLA5k7m1In15m78ojRGgb/7sfaRcCyfBK3MiNpypUu4yBFmNdE61v7Rc7COTtynbH3DMFyitEU6ZSCHo323fLoASPrHQEnHqvUq49lFGiwCA9GtLoWbRut0JVZnt71X+lHXkZiayljhXEflIuMbdwHeI7LKKaZBefoeQyGq/XALBSuqLMgF5DdaviguIavEIhWcmmpDeVhvkeWygp9QHrEsPOixM4X/90Ne9cCw3t1Hkf13+Oc0ZPIpcTKRZOjNRAoxWLGNxgYQ3Xy5dow8vfshSaVt+4Z7tInl/bEW3cqOHb1Fsi3T+JCCgkX+silQEhHOIAc0mrrk+A3EqMszxb0OxktA+XbkKQjPkhfUmW393l9QYIgzYxRK17DAzVHhqcCGm118WoV+aPMMl+C+xwN13JIL3NiQ8PscjqGKsMWWt1Gkv2lCPfM/Umu31ouvrM/fSgtRoY35HhcMPRXzZKxbSyYZiov4n95smn+SUpvLzxYf5w0G1dSRTX92mcbUKMYa8AZe5SfqHi0WHEh9
 AbjizWqC
 O9ctemq0TrJTHkOYzmAnJy6wNVvZRtq0lNFyQtTqVsl8GZ4pb9v3BcwsIMIZJyVx3lnCc28NcRqYPP5aRdomVtDcp8WdE4vnaMtxiP4TXOIVhYV6GyvmtxpF2vd7jR9Xn2y1g8zJKExlXVw0taaZpXHVGw7+xXMu6sHsE8O4X1iinjBLMY68t9Vb+sPCDeL/95NEBlAUn/49aApmcYt1BXIyuLV5+iXv+zas6EtWxgFuW5o+1JFOEaY9W6kfVqbhCv7he2mr0CxflkGLAHiHG41zLhWrAf73kqZrkyK0/avkoQxu33kPoNtfyzjVFrmwWWRRtBt6tbgHiIXB7O/8JyiVGY9Z0He7UN+LeQyx7ffA1gl3gJUjJ4gf9s9L7yAv6ccst
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apply the same batch-freeing optimization from free_contig_range() to the
frozen page path. The previous __free_contig_frozen_range() freed each
order-0 page individually via free_frozen_pages(), which is slow for the
same reason the old free_contig_range() was: each page goes to the
order-0 pcp list rather than being coalesced into higher-order blocks.

Rewrite __free_contig_frozen_range() to call free_pages_prepare() for
each order-0 page, then batch the prepared pages into the largest
possible power-of-2 aligned chunks via free_prepared_contig_range().
If free_pages_prepare() fails (e.g. HWPoison, bad page) the page is
deliberately not freed; it should not be returned to the allocator.

I've tested CMA through debugfs. The test allocates 16384 pages per
allocation for several iterations. There is 3.5x improvement.

Before: 1406 usec per iteration
After:   402 usec per iteration

Before:

    70.89%     0.69%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
            |
            |--70.20%--free_contig_frozen_range
            |          |
            |          |--46.41%--__free_frozen_pages
            |          |          |
            |          |           --36.18%--free_frozen_page_commit
            |          |                     |
            |          |                      --29.63%--_raw_spin_unlock_irqrestore
            |          |
            |          |--8.76%--_raw_spin_trylock
            |          |
            |          |--7.03%--__preempt_count_dec_and_test
            |          |
            |          |--4.57%--_raw_spin_unlock
            |          |
            |          |--1.96%--__get_pfnblock_flags_mask.isra.0
            |          |
            |           --1.15%--free_frozen_page_commit
            |
             --0.69%--el0t_64_sync

After:

    23.57%     0.00%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
            |
            ---free_contig_frozen_range
               |
               |--20.45%--__free_contig_frozen_range
               |          |
               |          |--17.77%--free_pages_prepare
               |          |
               |           --0.72%--free_prepared_contig_range
               |                     |
               |                      --0.55%--__free_frozen_pages
               |
                --3.12%--free_pages_prepare

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
---
Changes since v3:
- Use newly introduced __free_contig_range_common() as the pattern was
  very similar to __free_contig_range()

Changes since v2:
- Rework the loop to check for memory sections just like __free_contig_range()
- Didn't add reviewed-by tags because of rework
---
 mm/page_alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 64be8a9019dca..110e912fa785e 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7059,8 +7059,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
 
 static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
 {
-	for (; nr_pages--; pfn++)
-		free_frozen_pages(pfn_to_page(pfn), 0);
+	__free_contig_range_common(pfn, nr_pages, true);
 }
 
 /**
-- 
2.47.3


