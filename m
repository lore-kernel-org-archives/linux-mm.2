Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4846606A321
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 06:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CV0mW+bm
Received: by kanga.kvack.org (Postfix)
	id C8C4E6B05B1; Thu, 12 Nov 2026 01:12:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15C56B05B2; Thu, 12 Nov 2026 01:12:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE4A6B05B3; Thu, 12 Nov 2026 01:12:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86D876B05B1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:12:45 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE9BB404CF
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:12:42 +0000 (UTC)
X-FDA: 85425448164.23.FC3C993
Received: from mta1.migadu.com (out-50.mta1.migadu.com [95.215.58.50])
	by imf29.hostedemail.com (Postfix) with ESMTP id E36CF120005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:12:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CV0mW+bm;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.50 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794463961;
	b=6bei7Po5lc9xZG/u7RKOeKuqIP2j3JZCWnRZPjj3M/Cw7ptvMBpEMZQsL5WvkuSGN9J7/b
	ldIlg5w2AF+ECk4t/5vpBJsm3455h79QrBd/8tKFKt/7hM5Gu60Hb+vaC2pwdz0TJva9Du
	EN0f4lx6AO/o1iNs+JyCGIXHsJWMnns=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CV0mW+bm;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.50 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794463961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1+gXg/vjFn6nzZA2EVEP765YusEY5R4QCzjg5NvcKa0=;
	b=YJVPh5eZahQNxfegVXDiSz3xq5Lh45Ebw+lPgQlX1D1mDjn4TILVK3QfAk6t/a55uR4xh/
	eDluT/rMOD5pCi7BS0Y1nhZTbqnWN7PqpFotGnLPPgr8P/z+yiXSu4BG9LDeM+XyfDM+7S
	YGg51oTSLyBYGutJ1VZhQM3DfYHB5Jk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=5q5l1kzky20TOdvCOQkbVc5c+2wT9HJYJXXnkXqYupc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794463959; v=1; x=1795068759;
 b=CV0mW+bmuW46y0b3t+nZ2OsdGfraTo0JvwQxnvSCV8iGpfduEaA/lvZiaE68xMfEcUjYINQK
 T11ymgH/8LhOq1EYs178Y+jWessBXwc06WZVgzzprPUoyqroV90PEl0QDzcPae6uDM4MIsUjTtU
 ikz/If4ez9/tY48GWylpZrvI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 42ff7a47c71756af;
	Thu, 12 Nov 2026 06:12:39 +0000
X-Mizu-Trace-ID: 42ff7a47c71756af
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Chinner <david@fromorbit.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chris Mason <mason@kernel.org>
Subject: [PATCH v2] mm: list_lru: fix NULL deref when a folio moves to the root memcg
Date: Wed, 11 Nov 2026 22:12:31 -0800
Message-ID: <20261112061231.2469026-1-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: smxpzz7cry8ans8nik3xeu5np8ngi7w3
X-Rspamd-Queue-Id: E36CF120005
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794463960-5913
X-HE-Meta: U2FsdGVkX18xl+2RvPh8zgq3oF79ZfBQMSTBgSfYFARrgJgohv0NtmuchZZOJgmYr+bECoEd5TFSH7HOnnR2r+iip+iRm2FB1seTrbc8F5UWx4uKozcvDUORXAzdzKU+thCWQcSL8aISS2CEkTDQFsGD5efiISvSOJ4t4wI/uB7jvz4uqNULfzTwnQBAvDIJogCu4m1fTcZILYN1MkqdzqAisQXyJ2EcwQBYNcjZlQmVdI1K+zPTc6rF0g2mVnrqgENTdFqZwwLuzMi8HWdULGi0DqVP5xL8scxIvAsnWkRsm1MY75OX7IQ5A7ep5A7A+HVo56HkERTYE9TDb1p6LITJTGy+g5uXGQtfJeCxMdpmHq6yTul2C/hJcji6KFJ2PNGm9OiT22rOuavNKXR+UaXaQAbI8t1nfjiMm8YWH6R92qthlFNOd4fY6yxkS2/lmGNj/cFB4lMzGhjmJfG9Y8g75ZzPu1tfRDNZ9yAX5TUBNf0CV+0Ut78cKabXXtelrkYgUHfiOzKOe+qEQlSxM+d+5mibrbmDrfLpLFQsFxTI0fBEByRZu89Od+ZXZmlDdGd+lqQUmMrxP/N4H2zwPgng5QQInLRGzH048k/D87EQS9DH9M5epNBYsp50chkBwQsZNlNI7EPuGNDs+Zak4CHODRYs+tCMd5gYZxp16RAnmWE+6fDMO2CCV45q7eQJBelNH68pQLx4QMvW9yt0toeI+aattQk7Ysfd0LNugojoiDVD4hBoPp1dlP8ux9NNX4LXmHIV9K0clRwCXc2xrNY+zZJQwEsXiIhagGUNPy/N19k2LDqa6bTnwa2PGi5hT4LXHGMMFDImOaKLd/XmOwuPLGtaxvXbqmnQttODQuJ2Yfu5/rMD//3QM21Qe6TjqnGIZPWZyevzaZq9q5XLT+wA0gd2FivZFnoqsjZcO1xoE7i1qfLcplE7+pj+8G71mEUK7rnADTI0ZepfGBp
 AjedHDgl
 4hyRetdguZgsWxVGZDSZ+Br8K1piyBnTiPn2XIZfR+lCQ6yhoeFHjsGnbGY9LR1j3Zb3UrQgvGSMepT8fjsRhJ/QTQrkT5o2TIBhazadsEOFT1RNyF9KPhV01Er/72MYi7jl+XwU49xNB8Vy4Gwl8XQgtppty/nnXW3nj4Z9dA708i00hhow5Sgx8uEBqROrQkvF9UPNNVU+JkgRrQ0yEnAXe4lrGFrN5RP3QOjDbW/NDOWpRfbcl0PM5yNonAZwpuqFILjnr1Rg0ooTdnCXFAzj8ZjJ3MIDqdRnfyykBsslqRQ7r6GUzm67UlO/Ld5emtev/58g77sNrl+M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_memcg_list_lru_alloc() makes sure that a folio's memcg has its
own lists in a list_lru, such as the THP deferred split queue. It looks
up the folio's memcg twice: a fast path under RCU checks if the lists
exist, and a slow path takes a reference and allocates them. The fast
path returns early for the root memcg, which uses the global lists.
The slow path does not check for the root.

The memcg can change between the two lookups: when a cgroup is
removed, its folios are moved to the parent memcg. If the folio is
moved up to the root in between, the slow path gets the root, and
__memcg_list_lru_alloc() dereferences the root's parent, which is NULL.

Users see a NULL pointer dereference oops while a THP is allocated,
such as in a page fault, in khugepaged or at swap-in. tmpfs huge pages
are affected too, and for them the oops can also happen in reclaim,
for example in kswapd. The task that hits the oops is killed, or the
machine panics if panic_on_oops is set.

The race is narrow: the folio has to be moved up to the root right
between the two lookups. For example, its cgroup is directly below the
root and is removed, or has its memory controller disabled, at that
moment.

Fix it by checking memcg_list_lru_allocated() again in the slow path,
like the fast path does. It returns true for the root, which needs no
lists of its own.

Fixes: ae64f07a6a40 ("mm: list_lru: introduce folio_memcg_list_lru_alloc()")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
Changes in v2:
- Check memcg_list_lru_allocated() instead of mem_cgroup_is_root(), like
  the fast path does, and update the comment to match (Muchun).
- Link to v1: https://lore.kernel.org/20261112024140.648088-1-shakeel.butt@linux.dev

 mm/list_lru.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index d1d256822ccc..ca8de3793166 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -645,9 +645,16 @@ int folio_memcg_list_lru_alloc(struct folio *folio, struct list_lru *lru,
 	if (likely(res))
 		return 0;
 
-	/* Allocation may block, pin the memcg */
+	/*
+	 * Allocation may block, so pin the memcg. If the folio's cgroup
+	 * was removed after the check above, the folio has moved up to a
+	 * parent memcg. That memcg may already have its lists, or may be
+	 * the root, which uses the global lists and has no parent. So
+	 * check again before allocating.
+	 */
 	memcg = get_mem_cgroup_from_folio(folio);
-	res = __memcg_list_lru_alloc(memcg, lru, gfp);
+	if (!memcg_list_lru_allocated(memcg, lru))
+		res = __memcg_list_lru_alloc(memcg, lru, gfp);
 	mem_cgroup_put(memcg);
 	return res;
 }
-- 
2.53.0-Meta


