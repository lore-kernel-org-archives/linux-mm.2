Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67EA3EA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 20:39:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E4836B0089; Wed,  4 Feb 2026 15:39:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 792536B0092; Wed,  4 Feb 2026 15:39:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69DEF6B0093; Wed,  4 Feb 2026 15:39:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 563AA6B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 15:39:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 051E9140254
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:39:01 +0000 (UTC)
X-FDA: 84407938524.08.DA8A747
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D5CCC000E
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 20:38:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ub/vnzHu";
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770237540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+FYMhfr46SivfaufI+yrynTinQPNIgR87QHwVwyjO1Q=;
	b=hc7EtNTk3z+mthHNOpPdvL9gw2COt+ijEBsckX9wbV3sCyEd3ZVIiqtqil4hpPImXeMmA8
	iCllf4BkxgcOffTT/7+/DdVI32EdywM3WQRt05Ns6ndLYvoFTBIno8i+hkR27tTMVkXKPb
	zaZgUT9gpNWplPf3Mdmk/nsMAytIbt4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="ub/vnzHu";
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770237540; a=rsa-sha256;
	cv=none;
	b=G3yvC8sZjdto9l0IizLvY/qIlbRSiI7Hfgo5YX6E+NU2Loz75IrobEcr+7eTJBOl88+0lD
	OaYvP8rCGHmpgQX4xVKSQTOrgUm0mmG0JVHeftuw+U/RgVXuhLspkLZjjjdbvyoaHR+SgU
	VsAN2y3xtrQJrMx1R+REmGdIIOeCIEw=
Date: Wed, 4 Feb 2026 12:38:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770237537;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+FYMhfr46SivfaufI+yrynTinQPNIgR87QHwVwyjO1Q=;
	b=ub/vnzHu3xWXTYfSKu8a2uExkd0Is5QCM8UwF88Ag1v0KbSCN1kOP6fINttLxWwFP8Or7c
	ewnv2CL/SSXXNPGoo7QBtxQuNPApxUPwqigfqQohWr7Elh1AImzObJR9iN+3HE7T3AAmg8
	LOZKuLLuUPTa03Yr4OlbJ0xSLsqNhK8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Qi Zheng <qi.zheng@linux.dev>, Vlastimil Babka <vbabka@suse.cz>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
Message-ID: <aYOuCmjQ5lGm8Mup@linux.dev>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-2-shakeel.butt@linux.dev>
 <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com>
 <aYAmGc6lu973jRwu@linux.dev>
 <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
 <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
 <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05aec69b-8e73-49ac-aa89-47b371fb6269@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Stat-Signature: ckyri1gnmzw59bdbbrj4dq5mxzch94t6
X-Rspamd-Queue-Id: 1D5CCC000E
X-Rspam-User: 
X-HE-Tag: 1770237539-115367
X-HE-Meta: U2FsdGVkX1/K6FIsDp6EIG0V0A+27c2iYa4OBN95FlxrBdJc6apKA8YvxPvGUlkr8Ald/9zTSbInxgdaefizJBHPNvZ41NvdDr6d0XCZ4/SSYlgL3jV1qDPbx3Jiv53MxgNk0vliQSO8VEzYvKtrFDQ/UAv3Nc4Q8lTitLXzGWZtgWmXPOTmwDGPOx9jNxnq3stQ/7+cinqZzMnBszeTCRVUp79f3Q8q21s2doFeC4zAV1holHMlEIzYn6n1SOMT1nsytxHfI3qb7iyHA389y9lrj/Nimi+7Jx4NWWNk9AiF/lUwH17C4ZAaULG6M1nESvFJH9TTuR7fj/mLW+CQRbUtw3oFIe0PxDt+YqY6x8d4OWS6Mn7Mwx8m8BMgNpUfYND5eHpC4NBU4h0vSpBFodTc8xcqEiqdzu0HAefSRKWCrVZI2myLsCsIGrGpAL0hDRKF2RBEPxPe/9mdVeJx5oPpEfisKCqs4YISebmCk+lU6AY/31tpQx3wWPu9mFnBzbhG2nZlCIjiKEHwc9TzRvhIPTnQpkfQMB90z6ThlE7SvIA8eZqUMfXrXIBSJ2xmAfwgSOIPpRhhbjQrt1MjTdLU0CAJyjE6ST2gANcBp3d0xlORPpRLOPgyHq6XDyySDCeiMGSxv3bFzgc08fhqKXgForwnIgBph03ueMwOdi9HASsFWq2KsrLlZzChWUgV80liNngGhACxB4eRN+BeXPX19Ixn1FUgOUWkbIvghVFDKZJxVLHuGFCE5zQOBqjDRhfltStJJsxNeXipNhcrPZCARBo4Fwaffqw4HR8/qX3ldMtFy+aNQkN3cv2pU3ULJOxfovsj6th/RgEiPruHE48RW2VTVqcinb1gWKOekclRU2kcSmMBOC9hVBCKmKWl9XzpRqaQ9qfSMkTfbHcvoERSXAYA9NWkjahDl32mQMLrj43fx6CxHtPY2rytlqLIZ8GPw0WNQyfWC3IHMkx
 WPsZb7kU
 /zBWdd7LC+vZL0em+Q2Ns6A+e3yzEsittUWJ9aY0JpnhNpKJbiMOXJiJG0h4NUY4xF7VMbHAHgvq03i796i3i0ZlQ5SCXQDMqwzzalTUgQ0/FYc30xX2dsRk/HyFzHCafVie6n5RqVIV6b2BAcSKhLG1deL30vL/4ULhW+DojUsDpq25QkQUbQGrBVbjSesNyZEfIZMk2buNY8+wcVDhBr9DUcFQhxW53ZTgxvIKBhA/C+IjlaEQcBPqn7beD8+IkfBrJHGN0pD0zMTWUM+n3TYYj/ggtMzBTR9QsHvJ/6VEDu0OSkOQWw73wszaz5Zown+EqcI/3QlJspdkwi4gPVzW+Ce0lAVmKqpAX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 02:23:54PM +0530, Dev Jain wrote:
> 
> On 02/02/26 10:24 am, Shakeel Butt wrote:
> >>>> Hello Shakeel,
> >>>>
> >>>>  We are seeing a regression in micromm/munmap benchmark with this patch, on arm64 -
> >>>>  the benchmark mmmaps a lot of memory, memsets it, and measures the time taken
> >>>>  to munmap. Please see below if my understanding of this patch is correct.
> >>>>
> >>>  Thanks for the report. Are you seeing regression in just the benchmark
> >>>  or some real workload as well? Also how much regression are you seeing?
> >>>  I have a kernel rebot regression report [1] for this patch as well which
> >>>  says 2.6% regression and thus it was on the back-burner for now. I will
> >>>  take look at this again soon.
> >>>
> >> The munmap regression is ~24%. Haven't observed a regression in any other
> >> benchmark yet.
> > Please share the code/benchmark which shows such regression, also if you can
> > share the perf profile, that would be awesome.
> 
> https://gitlab.arm.com/tooling/fastpath/-/blob/main/containers/microbench/micromm.c
> You can run this with
> ./micromm 0 munmap 10
> 
> Don't have a perf profile, I measured the time taken by above command, with and
> without the patch.
> 

Hi Dev, can you please try the following patch?


From 40155feca7e7bc846800ab8449735bdb03164d6d Mon Sep 17 00:00:00 2001
From: Shakeel Butt <shakeel.butt@linux.dev>
Date: Wed, 4 Feb 2026 08:46:08 -0800
Subject: [PATCH] vmstat: use preempt disable instead of try_cmpxchg

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 include/linux/mmzone.h |  2 +-
 mm/vmstat.c            | 58 ++++++++++++++++++------------------------
 2 files changed, 26 insertions(+), 34 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4..499cd53efdd6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -776,7 +776,7 @@ struct per_cpu_zonestat {
 
 struct per_cpu_nodestat {
 	s8 stat_threshold;
-	s8 vm_node_stat_diff[NR_VM_NODE_STAT_ITEMS];
+	long vm_node_stat_diff[NR_VM_NODE_STAT_ITEMS];
 };
 
 #endif /* !__GENERATING_BOUNDS.H */
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 86b14b0f77b5..0930695597bb 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -377,7 +377,7 @@ void __mod_node_page_state(struct pglist_data *pgdat, enum node_stat_item item,
 				long delta)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
+	long __percpu *p = pcp->vm_node_stat_diff + item;
 	long x;
 	long t;
 
@@ -456,8 +456,8 @@ void __inc_zone_state(struct zone *zone, enum zone_stat_item item)
 void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
-	s8 v, t;
+	long __percpu *p = pcp->vm_node_stat_diff + item;
+	long v, t;
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
@@ -467,7 +467,7 @@ void __inc_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 	v = __this_cpu_inc_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v > t)) {
-		s8 overstep = t >> 1;
+		long overstep = t >> 1;
 
 		node_page_state_add(v + overstep, pgdat, item);
 		__this_cpu_write(*p, -overstep);
@@ -512,8 +512,8 @@ void __dec_zone_state(struct zone *zone, enum zone_stat_item item)
 void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
-	s8 v, t;
+	long __percpu *p = pcp->vm_node_stat_diff + item;
+	long v, t;
 
 	VM_WARN_ON_ONCE(vmstat_item_in_bytes(item));
 
@@ -523,7 +523,7 @@ void __dec_node_state(struct pglist_data *pgdat, enum node_stat_item item)
 	v = __this_cpu_dec_return(*p);
 	t = __this_cpu_read(pcp->stat_threshold);
 	if (unlikely(v < - t)) {
-		s8 overstep = t >> 1;
+		long overstep = t >> 1;
 
 		node_page_state_add(v - overstep, pgdat, item);
 		__this_cpu_write(*p, overstep);
@@ -619,9 +619,8 @@ static inline void mod_node_state(struct pglist_data *pgdat,
        enum node_stat_item item, int delta, int overstep_mode)
 {
 	struct per_cpu_nodestat __percpu *pcp = pgdat->per_cpu_nodestats;
-	s8 __percpu *p = pcp->vm_node_stat_diff + item;
-	long n, t, z;
-	s8 o;
+	long __percpu *p = pcp->vm_node_stat_diff + item;
+	long o, n, t, z;
 
 	if (vmstat_item_in_bytes(item)) {
 		/*
@@ -634,32 +633,25 @@ static inline void mod_node_state(struct pglist_data *pgdat,
 		delta >>= PAGE_SHIFT;
 	}
 
+	preempt_disable();
+
 	o = this_cpu_read(*p);
-	do {
-		z = 0;  /* overflow to node counters */
+	n = o + delta;
 
-		/*
-		 * The fetching of the stat_threshold is racy. We may apply
-		 * a counter threshold to the wrong the cpu if we get
-		 * rescheduled while executing here. However, the next
-		 * counter update will apply the threshold again and
-		 * therefore bring the counter under the threshold again.
-		 *
-		 * Most of the time the thresholds are the same anyways
-		 * for all cpus in a node.
-		 */
-		t = this_cpu_read(pcp->stat_threshold);
+	t = this_cpu_read(pcp->stat_threshold);
+	z = 0;
 
-		n = delta + (long)o;
+	if (abs(n) > t) {
+		int os = overstep_mode * (t >> 1);
 
-		if (abs(n) > t) {
-			int os = overstep_mode * (t >> 1) ;
+		/* Overflow must be added to node counters */
+		z = n + os;
+		n = -os;
+	}
 
-			/* Overflow must be added to node counters */
-			z = n + os;
-			n = -os;
-		}
-	} while (!this_cpu_try_cmpxchg(*p, &o, n));
+	this_cpu_add(*p, n - o);
+
+	preempt_enable();
 
 	if (z)
 		node_page_state_add(z, pgdat, item);
@@ -866,7 +858,7 @@ static bool refresh_cpu_vm_stats(bool do_pagesets)
 		struct per_cpu_nodestat __percpu *p = pgdat->per_cpu_nodestats;
 
 		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++) {
-			int v;
+			long v;
 
 			v = this_cpu_xchg(p->vm_node_stat_diff[i], 0);
 			if (v) {
@@ -929,7 +921,7 @@ void cpu_vm_stats_fold(int cpu)
 
 		for (i = 0; i < NR_VM_NODE_STAT_ITEMS; i++)
 			if (p->vm_node_stat_diff[i]) {
-				int v;
+				long v;
 
 				v = p->vm_node_stat_diff[i];
 				p->vm_node_stat_diff[i] = 0;
-- 
2.47.3


