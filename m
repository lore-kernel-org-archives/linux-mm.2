Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AFE7CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 17:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD0B66B008C; Fri, 15 May 2026 13:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AB66B0092; Fri, 15 May 2026 13:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A49D46B0093; Fri, 15 May 2026 13:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F82C6B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:20:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 305021A019D
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:20:43 +0000 (UTC)
X-FDA: 84770318766.26.894A51A
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf23.hostedemail.com (Postfix) with ESMTP id 78377140009
	for <linux-mm@kvack.org>; Fri, 15 May 2026 17:20:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eLcDOAKi;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778865641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=B+gjGpKlxU8y7+0y5q8kDTxRVJrx4COiQ/G069Vfv7I=;
	b=Mett8x+pzmD2NhVTkRAH/e/b2qxPafS3+3frBpwL13710kO3Evtzffpb4b/bxIwST07hne
	AtxBdrDrNwtZrGYNoKBRGIS0wVggGG4tt+ihtdPIoiN8JXuhPaq/UjZRD9x/+DcEpFFPIM
	BsoBdhOM0biOKDSLaMOG7hh3nWqNRwk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778865641; a=rsa-sha256;
	cv=none;
	b=p8t61SNvMJAkfGOhV8Vdn/lTyENymSWB2N41kux+EboEDhykcYTgLJuDhNBsD6qu+CheKN
	9ID5xTZIoLutrrmj49KW3mpzURfDIk+WaVpHliRFs4a13CNMoNLesqrwPeM6/1tvM6IuIj
	DvqzpGgUOFCGmoaTrvGTgDKIGHp4Q5k=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eLcDOAKi;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778865639;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=B+gjGpKlxU8y7+0y5q8kDTxRVJrx4COiQ/G069Vfv7I=;
	b=eLcDOAKim84FlWMX3j2N/CWmKi5YYyXdduXkEnjm6fiPTjvo6cs01DM1sSwCyhKiulS+Vt
	bkMcHj/085lEvUQyXQ7NmwFUQK3ipwd0wVYVS7SY+FKqHB/icSwWCxl+CtMDhECBjhiAkh
	Oq/BkODkiR0A5bA1iclyLUxa367OYyY=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH] memcg: cache obj_stock by memcg, not by objcg pointer
Date: Fri, 15 May 2026 10:19:53 -0700
Message-ID: <20260515171953.2224503-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 78377140009
X-Stat-Signature: ktdcbx77fxdqqjs53nxzxsqstfmf6m6c
X-Rspam-User: 
X-HE-Tag: 1778865641-128373
X-HE-Meta: U2FsdGVkX1+hZvPGNAsnJwA66G2SU5RcKe5V4iYZN6mK9ij8gYok5poRm+IYqUQCloyAESNJJRsjdWrKtVxhjUG24ztMlH/YEgA9VwAhLLGOihVmtpxJ1SQM9tfs1lkUGLAJ+oTuBs9E1vI/JpxV4WYJ29/4kCtDVcdtSHBnGp6S4BUmkhyZZz3Bzh/uiM3R8nY0ttS/isNQXRLYw8JMtXRS9xlDi5bdZKW/TZ3ZSWML7bdGVz2z90447hvY3/xkFi7OfUecSZRLuZKrgEBOvlIzmEzy4CIhWN5J23aiPn+3Fcsf9aXSF4T9KoNsWpq09Za49h2phX2gzyrD1IfGbAclcDxLruDy3alLRgTBuehnPD2EjAdEE0hMuA1P1W4zj3l4KhWDXw8Jaj+HYVNymlKzpN2apPSmwAaYISV2eUZl/ETampSEse1X3PVwH4xGN7r1wWGH4yOPBECS4n1ByvySS+36vezRgPa0TA3lYAj7WMNg5AFO5iICwzs6d2fsyhCiILXKJpfgqTZ46DGInyqbnhfgc2cP0n9kJmhINXa5PIkasIE9Dw5tFIf9fFJltkSq1GJ1cdt2lU9sxCmvS3tTPg+dm6EQ5Ve4H+ETIBPr8Wc20IQFm6AU/iGDBTzL4QVmStmgUHQYXo1CwrcGoJG5M1PQyl5PiPBppfCnpPbu/vPPFsIlBet4QHOG3fO8TjN1TCBkKP0shDWgISXQBAkyz9FWwaeSgWgeT4zOdFfRVYdzYuwx7WSmKPxqILeTBHvChacwRUbCK/LBB8F4Yd9tXEjsXWPEkUHa8IuU+fWjxVNGigej+xADmlqlmYnffxIOY5oLeMtMYk1gdkGgecrzFWPTv0TbUqG9ZHDoEuU2JbJs0p+xaiFv3iCuvom6d2evlyOxWdqyBJPfdd7K57CdyVfPh9ppDHMeOfCR0Eh/ob58357Q8EQPqaCZN2eUTd0u3a9ScfmOFvEPpON
 lv53D62A
 B1foZi9LDa0KN347Bw5llrGGJ9joOHEUGcKQgucQPe39QVs1VEyJnnpYG6rn2DUhteSrlQVuXAmd85V4N4WnjFOq/Go0OmLgtBz5oxXU8DVxRrms14D9CILMsA8APQBRB5JyB6TRDdEzyqrmo5oKsWWkLkaDcLwyIX/OGMRPgQaj93Pfoan0C+I9KklkEfQttaqSevlfXjBt2QBxFHovBStkKQZaOtM9WsChBVe/l9+gqTZKWTC2aCVgWv6plcam3jNqQrt+B5uEo1ojPTNfi8D5oaPJ4bPuRS8/3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA
node, but the per-CPU obj_stock_pcp still keys cached_objcg by
pointer. Cross-NUMA workloads now see a drain on every refill and a
miss on every consume that targets a sibling per-node objcg of the
same memcg, producing the 67.7% stress-ng switch-mq regression
reported by LKP.

stock->nr_bytes are fungible across per-node objcgs of one memcg:
drain_obj_stock() and obj_cgroup_uncharge_pages() both account via
obj_cgroup_memcg(). Treat the cache as keyed by memcg in both
__consume_obj_stock() and __refill_obj_stock() so siblings share the
reserve -- eliminating the drain on free and keeping the alloc fast
path in consume.

Though kernel test robot reported the regression but it was not easy to
reproduce locally. Qi implemented [1] a specialized reproducer to show
the corner case which cause the regression and then Qi tested the patch
and reported that the corner case is eliminated after the patch.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Link: https://lore.kernel.org/19693be6-7132-446e-b3fc-b7e9f56e5949@linux.dev/ [1]
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Debugged-by: Qi Zheng <qi.zheng@linux.dev>
Tested-by: Qi Zheng <qi.zheng@linux.dev>
---
 mm/memcontrol.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d978e18b9b2d..66448f428531 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3210,7 +3210,11 @@ static bool __consume_obj_stock(struct obj_cgroup *objcg,
 				struct obj_stock_pcp *stock,
 				unsigned int nr_bytes)
 {
-	if (objcg == READ_ONCE(stock->cached_objcg) &&
+	struct obj_cgroup *cached = READ_ONCE(stock->cached_objcg);
+
+	/* Cache is keyed by memcg; sibling per-node objcgs share the reserve. */
+	if ((cached == objcg ||
+	     (cached && obj_cgroup_memcg(cached) == obj_cgroup_memcg(objcg))) &&
 	    stock->nr_bytes >= nr_bytes) {
 		stock->nr_bytes -= nr_bytes;
 		return true;
@@ -3318,6 +3322,7 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 			       unsigned int nr_bytes,
 			       bool allow_uncharge)
 {
+	struct obj_cgroup *cached;
 	unsigned int nr_pages = 0;
 
 	if (!stock) {
@@ -3327,7 +3332,10 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
 		goto out;
 	}
 
-	if (READ_ONCE(stock->cached_objcg) != objcg) { /* reset if necessary */
+	cached = READ_ONCE(stock->cached_objcg);
+	/* Same memcg: bytes are fungible, no drain needed. */
+	if (cached != objcg &&
+	    (!cached || obj_cgroup_memcg(cached) != obj_cgroup_memcg(objcg))) {
 		drain_obj_stock(stock);
 		obj_cgroup_get(objcg);
 		stock->nr_bytes = atomic_read(&objcg->nr_charged_bytes)
-- 
2.53.0-Meta


