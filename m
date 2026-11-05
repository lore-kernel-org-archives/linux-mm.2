Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B4FD7606A332
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=RUDGX5v7
Received: by kanga.kvack.org (Postfix)
	id BF52B6B05B7; Wed,  4 Nov 2026 23:08:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCD626B05B8; Wed,  4 Nov 2026 23:08:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE2E16B05B9; Wed,  4 Nov 2026 23:08:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 863D66B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:08:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F279040909
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:08:31 +0000 (UTC)
X-FDA: 85399733622.08.FB39D91
Received: from mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	by imf25.hostedemail.com (Postfix) with ESMTP id 05DF4A0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:08:29 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RUDGX5v7;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.28 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793851710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hxAdYOiZMDWVnhrVJerUgUeo3FuklgjtpnZJkBnaqj0=;
	b=xiFtbOZ81vMtInhlyL2++NooVvpGQ4GbX5rxXYB1unmSigUpqw0gtuEnN88o+sVQRyXKVz
	ESKvn7BnWgL9HPR45l0PGnBYnWirbPUpJTVigne+tUSb1QiVuxPqFvzDho5rxaNoM/Pg5i
	WhdUW5JZvJaROJol1rCnPSfiFc/73WE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793851710;
	b=kVnE/r4PhW3L6tPyelLGzauobQg5tG3XcYU2pKyuJicMd5Ui8WUSiHWM3HfTS0M/5XhUDg
	UL5waAwYxsioMgFR7DuDLQ5lp1cTvJoJzbegQinYw+ap29CVfD1P5WkEB89GyiLQbTR70a
	LNw82O36jDmvrWPYGDW9hCrQY4KYBTo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=RUDGX5v7;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.28 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4zR6GuXHlYIEiJeN1rNCRlmHY2SNfG3wyJTdYXq1hOg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793851708; v=1; x=1794456508;
 b=RUDGX5v78X1j40xqFE1muXfgcFojzyNxW8vviBxIFY9jVQ7/B74hJWUZKU0PPNicHuBmqF1W
 hkn0V+3VAdchOTtdJ2RAT3njv5eed/swXVGlb58FHPqIzibbAAvXZ/As297LqhZIxHTgcfk13eD
 q5o0pTXAf6TYvlPSm9lkfgis=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 39f390051dfdd29d;
	Thu, 05 Nov 2026 04:08:28 +0000
X-Mizu-Trace-ID: 39f390051dfdd29d
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
	stable@vger.kernel.org
Subject: [PATCH v2 4/4] mm: hugetlb: fix cpuset violations in gigantic surplus allocations
Date: Thu,  5 Nov 2026 12:07:46 +0800
Message-ID: <046fd77e49ee8bb35e3bcc4104b9275d2e72ea5e.1793850539.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1793850539.git.zhengqi.arch@bytedance.com>
References: <cover.1793850539.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 1uyo5faq6chwbi1gnaii68wmjhx6bdbk
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 05DF4A0006
X-Rspam-User: 
X-HE-Tag: 1793851709-106853
X-HE-Meta: U2FsdGVkX18z2jNrveoqTXcppjFMQk2f7+YhUk3lhXtEhlv/AE9FpVjDWrQ4QfFhL6sixYZMxHS2/3CqGXo6zrEdV9crXkJhjQUZm/4GhVlMa9ukDyN9iSo4URgC8iSICGpeCjRcPNSMLJhfE39J9J0KtO61r5+vGsXzgm/15aVRhaq3/E+2OwP48ER6G79QurFfYLb2bhcNn0JIQg3QKQpqia0sFUNANLVDS28bwkilLt8K8vXJUZwU0ehBaYkHVJbxtmRRQHbP1SuA6Oby1J7zU8mBvLC7eV9+Iwlwi9yuda/2cVWfGYEaVVYUzEljwvMSu3/+SfTD/8z2ZqrLI5Z6Ru0p/UdbmK2bHBwCI7aKIvxyHN+aXFoPbZrXEndOpVmD+sPqTRGHOkY/SWF5pNBXezR3jqZvJGoK40eZ1Kw8h1N33IQcSPSerN9wB8mxllzTg4mkqOXl91XgEzP38/aSEyXmI8NABhc4Ig9iWvJDilcHu+H38vcCqyE0fGNf20YNdeA3pGJB7cFQiyFC7vKIEcD7mWh4tfeXS50TFMISvYHcPEBucWMzKYwCqIJZ9hrDjg58VBxiHvT6mhBpGLrBk8J6cuuAmAfKTbijfMCHmL8oY80ueB9VsLDcaH8GzJRBLLqrOP1kKuopkSFmjBc2SH1DfpoiM6b5j0JGLJgWQ9lLo+Ar5R/Ml+KVhZechLNJuM6p8hR6XYyFcEPqUJpdczX4MPQSEGcl+j1hu3QPhzm3XXIWCxSgA2s0ZVqHnUxacsvzi8A/qFoAfccC2Fp8VIlgzAZ97d5eTXm2MKN6mxKGAFnCyQeUHj5NraWg7MslG37uua0wti1wXOk9MKmSxsIyvlcMHsKnN/lm41qtRrMC+OpGJtd6H6qL04f2Kkomm57jW4IvcWFGEZzwQkSQP0hZfQcJamP0U/hxVoElqd6i49Y+mYriKDmqoLede8igOYBh7kdfwhGaDeg
 3CVHYO1b
 T5DzWYUF2ctstf8zuCFBfcwiWF+1QBaNvjo/6bGbCkEDJX0JaTvLbit4oJ5TQ68/g/A/DerCedA3bdNIpJ9Lex5N/hJvCusQumUapu3Py0j+1EW05p26DnCAveq3wXmGJtK+PjhS5xp4J5JTLuOppJjSiDTvZ0+OCPLuSejvnu0d2cVoyieYl6vg9WCI96edHvK9KqxGr7Ci5bPoTlS+AUoT3U1jf7xNXfTwe4z/fXvKpvxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

CMA and the contiguous allocator trust a supplied nodemask without
checking the current cpuset. Gigantic surplus allocations can therefore
use nodes forbidden to the faulting thread.

For example, moving a non-leader thread to another cgroup v1 cpuset
updates its mems_allowed without rebinding the shared VMA policy:

  CPU0 (cpuset attach)             CPU1 (thread T)
  -------------------             ---------------
  T->mems_allowed = {0}
  /* Skip mpol_rebind_mm()
     for a non-leader. */
                                  /* VMA MPOL_BIND remains {0,1}. */
                                  hugetlb_cma_alloc_frozen_folio()
                                    /* node0 fails; node1 succeeds. */

Intersect the allocation mask with the current cpuset, preserving
MPOL_BIND and MPOL_PREFERRED_MANY fallback rules. Retry only failed
allocations when the cpuset changes.

Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Cc: stable@vger.kernel.org
Reported-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/hugetlb.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6fba92b0f6749..09b64f7c11dd2 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2181,22 +2181,33 @@ struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
 		gfp_t gfp_mask, struct mempolicy_interpreted *mpoli)
 {
 	struct folio *folio = NULL;
-	nodemask_t *nodemask = mpoli->nodemask;
+	nodemask_t alloc_nodemask;
+	unsigned int cpuset_mems_cookie;
+
+retry:
+	cpuset_mems_cookie = read_mems_allowed_begin();
+	alloc_nodemask = cpuset_current_mems_allowed;
+	if (mpoli->mode == MPOL_BIND && mpoli->nodemask &&
+	    nodes_intersects(*mpoli->nodemask, alloc_nodemask))
+		nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask);
 
 	if (mpoli->mode == MPOL_PREFERRED_MANY) {
 		gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
 
+		nodes_and(alloc_nodemask, alloc_nodemask, *mpoli->nodemask);
 		folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid,
-						    nodemask);
+						    &alloc_nodemask);
 
-		/* Fallback to all nodes if page==NULL */
-		nodemask = NULL;
+		/* Fallback to all nodes allowed by the current cpuset */
+		alloc_nodemask = cpuset_current_mems_allowed;
 	}
 
-	if (!folio) {
+	if (!folio)
 		folio = alloc_surplus_hugetlb_folio(h, gfp_mask, mpoli->nid,
-						    nodemask);
-	}
+						    &alloc_nodemask);
+
+	if (!folio && unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
+		goto retry;
 
 	return folio;
 }
-- 
2.54.0


