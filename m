Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D364AC61DBD
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 09:18:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D5626B0088; Fri, 28 Aug 2026 05:18:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7860E6B008A; Fri, 28 Aug 2026 05:18:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69BC16B008C; Fri, 28 Aug 2026 05:18:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 493C46B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:18:07 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 90F1C402B1
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:18:06 +0000 (UTC)
X-FDA: 85150126572.16.56605F9
Received: from mta0.migadu.com (out-70.mta0.migadu.com [91.218.175.70])
	by imf15.hostedemail.com (Postfix) with ESMTP id 59EDCA0003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:18:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V2oxIeTd;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787908684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yYRftnj4Gn1+xHxHrhaMcmhmEY4xWqfdz9BRYjLTGCM=;
	b=46FRZ7lAnumjeO+F0794y9QCIChTNTeweD0HZHrv44e+vhyjX4VNXmjApVQ+pFvG1zEpm7
	od+BqLJhmuNoWG89u2h1fEKB507obez8wi5JP7WyqZpm55RglbPislFW6lyAdX4y5bUDMd
	ldrTBDUSuyM1/wHS3P8HVE791twCpyo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787908684;
	b=g8P9jUT9rYzC1dbhbI8WJAco2sDKtBBM/x+Onimcn+Dk0GMTYC2Ii4Lhvdb5DLiQea9p8F
	QBI89ZZEU6IYmwPYGFwq93YO8NqCmQF8F3pLgLxXQJPlKntUPctEWineXnwvvnTnJWoWGi
	K/OPJjxHBpwE3nItIuSYRMgWS0Ni+P4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=V2oxIeTd;
	spf=pass (imf15.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.70 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LzNLsUOw5eYBsVgYAUV0RPvY/OPvLva9xUTPUw3M3rA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787908682; v=1; x=1788513482;
 b=V2oxIeTdgWG7J7VsdjgRJGwVb27Rzgt5fagHIxpbhTTK3NIMGHWKrS/NeVBMNn8NvKkDfZy4
 OblkCobz6C+VGg+T/0YcIR3F41nWs/2tjnV5jbHc7okAMD9F4bdPzYMlq6EHNvDFSKIS1LDEUaz
 +aTiihN+3cyL7U73ddZTiFAU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3ee0ae8b69a5b7fd;
	Fri, 28 Aug 2026 09:18:02 +0000
X-Mizu-Trace-ID: 3ee0ae8b69a5b7fd
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm: vmalloc: fix vmap_purge_lock livelock under memory pressure
Date: Fri, 28 Aug 2026 17:17:53 +0800
Message-Id: <20260828091753.299295-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 59EDCA0003
X-Stat-Signature: m7p96gesq88jooemsobj5ugrozx3fswf
X-HE-Tag: 1787908684-941722
X-HE-Meta: U2FsdGVkX18Ul7OnkMV1TNg4ekPrhwzJ/IguBTEAIJq+2qk4xJ7lTEXaSWQTUxczaGNLN0GBLrYLwO14PKALh0l/kg1DrYQY2r2NNGhD6npLiASHdH1bAHuuyxviIcu26XpgYI3ahYhmvcgVsknpz9ECYFZgSrIOHI2ZbtB10Gf7Ry7Gzba/jkVYjCyFHePfhNgAGdmDJkixQ2vktbOP+CCWiCRTp2TCBZYCX9MaM+9ZWcvoqtA9Agv4cS7Xj/3wENYG/7KK0oduiIaCmz9HyWtERw07nfnHZAaarlsuRECguJmFsiO2/N1Z9GwJ2sfcwxuipSkGGJlQ9aPX1AIgKQIZHt9EgTDSreMdOVSYlzVgSV7t41g4cnoNJBw4tNdksK4YF4jVG6whoBAipQhusUlLnqRK0jhtJYzmC34OIXgpHFU0whr8ntcFeJOolvOoZ5RquCTHyMlC/D46FWMu1t3rMgt8PJXwlS8Fg7Xwue/c9zWPFl6bL+mdwf+nhUMf3jv5B05Bl+QofuyNhP2QRS+V7ZOp0BGsj+J/teTuVQsqX2e0YLlMYN7EZ68F9/FfwiodfTicJcsrovSRe04eOkQBjGGwfUPFhG6RsQQO4O7jG0b5FcGiXaBuIlNAhhlsGXRjgqdU2BWVMgWcfJPMovKxm3302zm36WJKn7MNkUmvlkLUWul2Scf3smv8hNabmL8lwHv9AE2SHvqGe/JE6rmQJwfD4kwwmTuG8HNocP8cKoSCMNDssuajoJB43SRIrOg949hWaiSUCmYqrlAWKHuojJfVM5oQwdAdVadqQVRqdL6srrnw+I998eqgL44GIJ9sC2B/oOTayORw4tavcgxP3O6cTFO1j3uFSqFSDIyhW54W1ze5XR6ZT0F785fMA/ga1teimnKkmwUOT7b3TVIP59CBt6bAJyHTdvRQWvw5Hy3iTJuIfMHcctLkf9K1/oh0QdqFHJS3b21VGLV
 7I2pwZLt
 zxvGvUo08HydISqC9icl/EKCUo/cTFWsiJW8Bs6OXKZP9qmRTvOanYqoAhct/F8CiEFkyCnHcQtXONdBm0sBu3aLgchzUKpTdOvJJmfMxnWJRkSuUplNx1UsJjvBoh3sMQx6FFOy60JIWjf5eVfbKP1PgAZqhWH3KT/uq1TAflj6UpFRLMVqAiqgkPGz9Makd8eGdydO2tjKmDn0dx5DDFRK5j0Q8ghtfu41bqZgXh6Psic4UPyTsBgErJhvRCYuW467nqWELvcrpFdSMRPHLAZVgXdLVOI+szunq6Pbb7wtWRhJLz/JQ94ncQtkMfhsffCfulakg5DZBZ46yn4SBGoitkgCZfMh6+la/p+bBe5Xv0AWgv+uf3xYsJeMtWxqZ+fdg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

The vmap_purge_lock mutex can be held for an extended period by
__purge_vmap_area_lazy() which calls flush_work() to wait for
purge_vmap_node workers while holding the lock.  Under memory
pressure, those workers may themselves be blocked in direct
reclaim trying to acquire the same lock via the
vmap_node_shrink_scan() shrinker callback, creating a circular
dependency that deadlocks the entire system.

Two places acquire vmap_purge_lock from paths that can be reached
during direct reclaim:

1. vmap_node_shrink_scan(): replace blocking guard(mutex) with
   mutex_trylock().  This is a shrinker that only decays the vmap
   pool and returns SHRINK_STOP without freeing memory; skipping a
   decay cycle when the lock is contended is harmless and prevents
   tasks from piling up on the mutex in the direct reclaim path.

2. reclaim_and_purge_vmap_areas(): replace mutex_lock() with
   mutex_trylock().  This is called from the vmalloc allocation
   overflow path; if trylock fails, another thread is already
   purging and the allocator's retry will find freed space.  The
   notifier chain provides a fallback if the retry still fails.

Both trylock failures break the circular dependency: the lock
holder's flush_work() can complete because workers are no longer
blocked on vmap_purge_lock in the direct reclaim path.

Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
Suggested-by: Uladzislau Rezki <urezki@gmail.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
v2:
 - Use mutex_trylock instead of mutex_lock to acquire vmap_purge_lock,
   as suggested by Uladzislau Rezki and Dev Jain.
 - Link: https://lore.kernel.org/all/20260824095020.1225189-1-ye.liu@linux.dev/
 mm/vmalloc.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e7..e5c68b795a3e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2440,7 +2440,8 @@ static bool __purge_vmap_area_lazy(unsigned long start, unsigned long end,
 static void reclaim_and_purge_vmap_areas(void)
 
 {
-	mutex_lock(&vmap_purge_lock);
+	if (!mutex_trylock(&vmap_purge_lock))
+		return;
 	purge_fragmented_blocks_allcpus();
 	__purge_vmap_area_lazy(ULONG_MAX, 0, true);
 	mutex_unlock(&vmap_purge_lock);
@@ -5519,10 +5520,20 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
 {
 	struct vmap_node *vn;
 
-	guard(mutex)(&vmap_purge_lock);
+	/*
+	 * This shrinker is invoked from direct reclaim where memory
+	 * pressure is already high.  Blocking on vmap_purge_lock here
+	 * can deadlock the system: the lock holder may be blocked in
+	 * flush_work() waiting for a worker that is stuck in this same
+	 * reclaim path trying to acquire the same lock.  Use trylock
+	 * to avoid this; skipping a pool decay cycle is harmless.
+	 */
+	if (!mutex_trylock(&vmap_purge_lock))
+		return SHRINK_STOP;
 	for_each_vmap_node(vn)
 		decay_va_pool_node(vn, true);
 
+	mutex_unlock(&vmap_purge_lock);
 	return SHRINK_STOP;
 }
 
-- 
2.25.1


