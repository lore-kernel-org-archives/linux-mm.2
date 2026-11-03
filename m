Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC81F606D814
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:01:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=uoMofLeV
Received: by kanga.kvack.org (Postfix)
	id 231416B05D5; Tue,  3 Nov 2026 03:01:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20AA56B05D6; Tue,  3 Nov 2026 03:01:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AC126B05D7; Tue,  3 Nov 2026 03:01:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D36B86B05D5
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:01:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C7EFC0304
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:40 +0000 (UTC)
X-FDA: 85393063560.11.A78B641
Received: from mta0.migadu.com (out-111.mta0.migadu.com [91.218.175.111])
	by imf03.hostedemail.com (Postfix) with ESMTP id 55A0D20008
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:38 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uoMofLeV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JYQyQkhetD6ZOaLMew7rXre3mg1MOm9HF6woZrkOd8Q=;
	b=F4TLevwCYJHjF8JluEpuSF03BE3qVELSj5jFXpRllWKdqgyDRMdtX0MeBk5nu5hDRdDzZ/
	u85Wyp7SWK/FYOhmUIkV1KOPR7CvpxmLbSy5LnPEs5IU105V9jYP1SW11Idr3B3E/y+LYA
	sGp5KOzSc9ALTdiMCpKGnIAHKcQp4rs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uoMofLeV;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.111 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692898;
	b=tUUmYbb8r9cQcM2tV0PEPas1hx2NJJg0v8ruCKCExDvuJSACX4abowa9ra13i7dT0M9IMt
	/a7whZohOpYzgEpkACAIN+AZs4Bp6GTcvxL9dwjGL/jWjVW7rKOCGON8ffouqZ5LzKhPfm
	CMFHPSaru+uvgEY/jT31u818T2RldaQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=f4MZEPomACo+JF2HOCbhbkGFHnL8N31Hjwf6Gqd4q3w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793692897; v=1; x=1794297697;
 b=uoMofLeVG/Ky2QC9sXVRMsOMWQkkJWpYo9yF02Y4Nc1np6EnpTtjqxqU8685L+rM5SOrGNax
 QKzf9hQcjZGS5lqoAOiSLM8Zfma/Hl+Ol1bP7Tdv2opBrzAKUOi4CMoKBSVNrBGlA8AIN8bwH1h
 uDvrNRWnNVQtmX2DU3c2fQIo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 25ecdb623a230149;
	Tue, 03 Nov 2026 08:01:36 +0000
X-Mizu-Trace-ID: 25ecdb623a230149
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH 4/4] mm: hugetlb: respect cpuset restrictions for surplus allocations
Date: Tue,  3 Nov 2026 16:01:07 +0800
Message-ID: <d1e41a65970ced879715a73ce2607de7ad102fb2.1793692578.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1793692578.git.zhengqi.arch@bytedance.com>
References: <cover.1793692578.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 55A0D20008
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: otzktahziwpir69ed5obsb61fhzpm64d
X-HE-Tag: 1793692898-367469
X-HE-Meta: U2FsdGVkX19s3GoElbm8qRtHccULBIzOD3qUv/bakZF9EL8mFVx86uLrTBO7T3DMA0DVAFHa2/d7F8Q7NTmNvyW6NKkvmvPAnc9hfd5DX1Vs1KA4Dzz8I/PXKMIe5CBSEiCXR3WRMOLjZnu3s4iE5C4DQfBibQic9uu2iPuzGtQ1RBQFzlJZ6v/66mPly2g23vWgyZU2CuWhpx1gpPofX9fDbLhSyh+8/WgvFnEL34PCoKJ689PZy/AIigusDM6yN8Ni0YHP8m+l/3uCrTWrvaB0Kr+LTzIfzHbeLWAjT12IyxkwOv1Bh0xCCpXZTzkBdL21VATJP9N2BX+JWC8EncF1zpA6DnsVhKBweLAYGy2wPravy2STWCMGlGXA6LHxnS3ATnwstOt4iiXa9hLRTi/0BR2EcnHyd4+kjy6G+Q5lM2mjzwOvZGb690w8Z3O/QqUWfWpZ5KDW7Uk0JrwjlIsmVB0h3v57vpn/68I3/jkakPYUAvSr3yEGnd5AMQKCuzsdB2CAQ/LXXdkR1ffBgTPQY9iEauBEAOsP/gHDgXEFl25p1tkCkhW+w4HrwcBN7rRx+KnkitbeE2qfMlQV3zPlSr2IhO53sXZgCbHB3h7CI/K9huFa0R+Pl05I/fifj+0QYNHamisUmiY+9NNTtwab/Q8dadx+SdKrmVqXpKOKBPSV+HKnxwDsi6Vq8Ef4jWn456Yfd9SLLnVufennEfb2FrB1nOz+2S2L5RHSkr0/4Cn8M15cwUAecMYDWecfkKstwznBJyU7mY7HPPpPtGfKPWIXtXsGLa8fvONgr4ATq8yTsxg0Ui9STc9luYJKXLN8xDfJJDGwbD2YkTh5uudfS9altah5tPRkIP3iu7tp4ee+GVYua3Iip1Cq5SQhV09+yRo0VUpoI02ah4+FAtt1ouLcYEfhURAceez20TGXwerPc2sbsDbtf4sCYCS9O6bX211YOJIg3T7SoGT
 QlKfmliU
 UNmUFHnsBHBQGx04HGse+6X0NhsiecENdUeh5qls77WAUzKJVnWhdNu8mREiAdIH6c2TR0OAcEzPVBGsVkvaZ2G3nTLcOvwP55ujhsCng0VWYtTSPR4M+43XYhUKsq5BrNEJudfp/XpDBdLwQHrSQiDwDjfzD2+RGX3Cb+s0Ym51Ia+jYZLKVIbajqRSly5sbJo5uuSv4GFL4gnsSe+uEjaG2mB//uDLDs9H/BDWNUAtBN3c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Gigantic surplus allocations can escape the faulting task's cpuset.
CMA and the contiguous allocator trust the supplied nodemask without
checking the current cpuset.

For example, a shared HugeTLB VMA has MPOL_BIND={0,1}, and T is a
non-leader thread. With surplus allocation enabled and no eligible free
HugeTLB folio, the following sequence can occur:

  CPU0 (cgroup v1 migration)       CPU1 (thread T)
  -------------------------       ---------------
  cpuset_attach_task(..., T)
    T->mems_allowed = {0}
    /* Non-leader: skip
       mpol_rebind_mm(). */
                                  /* Fault; VMA policy is still {0,1}. */
                                  policy_nodemask()
                                    /* {0,1} intersects {0}. */
                                    nodemask = {0,1}
                                  hugetlb_cma_alloc_frozen_folio()
                                    /* node0 fails; node1 succeeds. */

The 1 GiB folio is allocated on node1 despite T being restricted to node0.

Intersect the interpreted policy with the current cpuset before surplus
allocation, preserving MPOL_BIND and MPOL_PREFERRED_MANY fallback rules.
Apply the restriction at the policy-aware entry point to preserve
per-node pool management semantics.

If the cpuset changes during allocation, rebuild the mask and revalidate
any allocated folio against the current constraints. Keep it if it is
still eligible: freeing an HVO-optimized folio can defer returning its
range to CMA, so discarding a usable folio can cause a needless allocation
failure. Only release the folio and allocate again if it is no longer
eligible.

Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages")
Cc: stable@vger.kernel.org
Reported-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/hugetlb.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ce9c8e57b8e5c..6fd6e58ace869 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2181,22 +2181,46 @@ struct folio *alloc_buddy_hugetlb_folio(struct hstate *h,
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
+
+	if (folio) {
+		if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
+			goto retry;
+
+		if (node_isset(folio_nid(folio), alloc_nodemask))
+			return folio;
+
+		/* Balance free_huge_folio()'s decrement before caller accounting */
+		lruvec_stat_mod_folio(folio, NR_HUGETLB, pages_per_huge_page(h));
+		free_huge_folio(folio);
+		folio = NULL;
+	}
 
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
+	if (unlikely(read_mems_allowed_retry(cpuset_mems_cookie)))
+		goto retry;
 
 	return folio;
 }
-- 
2.54.0


