Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90BBF606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cfpLrqmh
Received: by kanga.kvack.org (Postfix)
	id 968A66B05C4; Wed, 11 Nov 2026 01:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 918686B05C6; Wed, 11 Nov 2026 01:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BA626B05C7; Wed, 11 Nov 2026 01:47:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 55B006B05C4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:50 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A68E6120216
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:49 +0000 (UTC)
X-FDA: 85421907858.08.3E43967
Received: from mta0.migadu.com (out-9.mta0.migadu.com [91.218.175.9])
	by imf20.hostedemail.com (Postfix) with ESMTP id B92931C0004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cfpLrqmh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.9 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F7M/ZhGLoFak/PJL0fDdgMXUJRkp736gJ7FlUGI9L4w=;
	b=rcFstgOGW+ssGjDp/WwvWqjeHg/X0fdgWmp8UcjcVDA00iNrted0SPo3Kb8CjOoKdS+Nmq
	8KMNx9x3e3wFTY8NHWYvAEwoC01zvim4KkJvubZ0jZTzq7THhQt56S+l5OADmvE8srET2V
	HWkyKSvXH8OgxQlHzZiP4MsFWUzf+fY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379668;
	b=rpLhPRTajitf0cPM6nGCN7w1MvTQEujLkuuU1w4sT9kHBiFbYjnJ09tJ0n4gl3BPPsCDi0
	2Y4Ryew+4stDYiI2ownnwzp1tvPg8skt2mK5dDP7MSxWB1ZuOoxCs0NFBrQV6vYgigcfGz
	z+H4gEqWEnLMiQN51XJGFfaSkSYCZbQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cfpLrqmh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.9 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CyrF+6zOUIdoWIi0r/h1EvqhIeae82jXO4tYB0TkHx4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794379666; v=1; x=1794984466;
 b=cfpLrqmhwJJSEliryqhAtj3rr4P6RN4PhBhrTyf8xlUpPxkKHYYlNQ+HBkik6E7bhaS5AXdb
 FW7HPhAkYdrI6Yr6tLbvgh3PBQvAfsesFgU/Nvq7mp5d5BQdhp8rqygAWfgX2ooWHza6GYrO3PH
 E71rVcTI8f+pT8wwZl+6FjzA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 439764ee18b4fcfd;
	Wed, 11 Nov 2026 06:47:46 +0000
X-Mizu-Trace-ID: 439764ee18b4fcfd
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org,
	"Oscar Salvador (SUSE)" <osalvador@kernel.org>
Subject: [PATCH v4 3/3] mm: hugetlb: fix GFP mask propagation to CMA
Date: Wed, 11 Nov 2026 14:46:52 +0800
Message-ID: <1c5e8c4ae230dc238a16f2f42d65bffac6244ad3.1794379434.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1794379433.git.zhengqi.arch@bytedance.com>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8o8yb9cxz94qjnymmg8tbeixqbne6mb4
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B92931C0004
X-HE-Tag: 1794379667-903859
X-HE-Meta: U2FsdGVkX1+ZxmjF5SqS2vKtwcczhgt2EDy65/ronnaQ/uEvL9eJdQ6Rv6Ru5xR5ECzN0UeVngFnxNv6pKfyYy0F84+bBXC8dBNWJxaQW683+ET57A2vamE6jN32sUtu4FacVLmdEQ3on6QH1z8OTTb8hhxhThQe3Ea6UzDIbRERfM/8R7r/KOwJX6Fl0khxtOwjaHuk05wtO0yTB141HgHFgza/eOQi91lCpmE+fvzzmgLW1vqExLCmQfMgXAZCzOIXwzvEA57zQ7iOWTs0lszX9r95ms8mY3h/L2xOEA9BDu+TOqNYJgEqHelGXaQ4nRPzJEmHkt/Xzaic3Ggs5/d2H4vg8yliVGVH2AWH2dksQDb2uYpHIAx2eZjpdSqr8fQve6lkO8ilG+YZ/gnH6HkwfUEzmkTMpa0QxwetvorLh9NxhVlF32D0T1PSK8uM+rOf6T1mmLYdz8tJpod78wIOMC/QottiR+ViT9+aa1pmqpKu1nBjbTD7gmujR6sVXYfqWSlQRFCGhv8YiBDzhy3gOUtEiFBYjcz3WPWy6X9pj97i+4OFC/fzpvHiSimOypJr6VBfKaFIfCcHZoN+20Polj9Wd/hWG9VvBOW0GmYjZIRUDZRXwfAPQQ+o3mYspfAL4MAc5JxD32RRUIsTeGz+wNDm2TSr6cPcXTwihr94shSHqViZ05R3dYkoSRxIWIHmJR8IcOAdmiCKaroHIa5b55q//zdX/SplsYRD+mEt3Gh7uUpbkjiio17soZGDK6YMC3r8OPl9msEDz3E37pVhK9jlVT1XRGgUpoquZhqyDNuVmfR3p54t+nbhOW4+1kTeTLyJcI4oXWopnGod68XxTbg7/xpbM8mxLVC00+/xSPwC9MKCrWEmL3W62fn3tZbVLi9TjsJj9xpU16OH1XYYjI+FTUhL6JhMjv8w+hWdQxSbwD9ATtB1OQwqJFdvw/f/w0B3VbGttVFVsvg
 0P+1qgxM
 UKr6WS+UqGAHuQf/56lpNwPmZVLQO1yt8DQvFqQARLmJqC/kS0TiAVDqMKH3iaEZInK094/58stCGWm0BAWtT+EZ6STx9K2uaZjaljJ9RRXm/G9w97lcvRdO6wbei0JyD1+vGsJ40EJOec1ZEcA4WgPfpTQnQavrp9NvTJSMOs4bM7ouTM0YBcQNXIhAAWhsY6FyAEQNIN60dghqXd2QvkEstBs33HkVonLNKsRSl7yFHCtTEtJv36WqjwGhvoOJvMbZJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
during the first MPOL_PREFERRED_MANY allocation attempt even though
the caller clears __GFP_DIRECT_RECLAIM.

Pass the caller's GFP mask through the helper so CMA respects its
reclaim constraints when trying the preferred nodes.

Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
Cc: stable@vger.kernel.org
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>
---
 include/linux/cma.h |  2 +-
 mm/cma.c            | 10 ++++++++--
 mm/hugetlb_cma.c    |  4 ++--
 3 files changed, 11 insertions(+), 5 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 8555d38a97b1a..4539ea5f2c4e8 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -53,7 +53,7 @@ extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long
 
 struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 		unsigned int align, bool no_warn);
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp);
 bool cma_release_frozen(struct cma *cma, const struct page *pages,
 		unsigned long count);
 
diff --git a/mm/cma.c b/mm/cma.c
index 9ec1d1fd5dff5..a7c47c0e7d070 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -933,9 +933,15 @@ struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
 	return __cma_alloc_frozen(cma, count, align, gfp);
 }
 
-struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order, gfp_t gfp)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+	/*
+	 * The only caller of cma_alloc_frozen_compound() is hugetlb, and
+	 * hugetlb constructs its gfp mask via htlb_alloc_mask(), which already
+	 * sets __GFP_COMP. Check here for usecases bypassing htlb_alloc_mask().
+	 */
+	if (WARN_ON_ONCE(!(gfp & __GFP_COMP)))
+		return NULL;
 
 	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
 }
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index cd6a64986278a..3e5a30571524a 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -69,14 +69,14 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
 	}
 
 	if (hugetlb_cma[nid] && node_isset(nid, *nmask))
-		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
+		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order, gfp_mask);
 
 	if (!page && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nmask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			page = cma_alloc_frozen_compound(hugetlb_cma[node], order);
+			page = cma_alloc_frozen_compound(hugetlb_cma[node], order, gfp_mask);
 			if (page)
 				break;
 		}
-- 
2.54.0


