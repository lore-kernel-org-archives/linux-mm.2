Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E125D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 10:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718956B0088; Mon, 22 Dec 2025 05:40:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69C3D6B0089; Mon, 22 Dec 2025 05:40:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56FFE6B008A; Mon, 22 Dec 2025 05:40:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 411E76B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:40:10 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EE929BA403
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:40:09 +0000 (UTC)
X-FDA: 84246762138.28.705E493
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	by imf29.hostedemail.com (Postfix) with ESMTP id AC2ED120018
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:40:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Txp4xYwb;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf29.hostedemail.com: domain of alok.rathore@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=alok.rathore@samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766400008; a=rsa-sha256;
	cv=none;
	b=GtTCSqCNG2iMWzI3Krdwv3Q5j0QOw/lgXo0XuiReXtrmg50KFXNIC9qN3cCYLyqXLlJFhl
	oJBEi5cAwiz7UyVs/O5r2yANMHwm6SVBlvp77hvPQZAeAoiCOiaRQTsgzaoB2t+RPPAB+n
	Akilcg7GMoezZOTBjQ1zFQBcCVdtoKs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=Txp4xYwb;
	dmarc=pass (policy=none) header.from=samsung.com;
	spf=pass (imf29.hostedemail.com: domain of alok.rathore@samsung.com designates 203.254.224.24 as permitted sender) smtp.mailfrom=alok.rathore@samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766400008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjZaC5poIzLP6pXI7QJYinWYKVCDEUcHkctu4jxWg7g=;
	b=gPSrgqr8vmK101+OjPJM0EJa0X4fJTkzi1TjGts1k9LomhrK3cluAWCYNprloBlm4ghf9n
	mua9sco0hyF8OatAvtaKAvw0bvlgF8/kajqMi91YW66+z/ivvZW0htABxUWnNQyNYZcLUC
	7LpJA/Fpb42wVF23IPTQQYkBFKCA8P8=
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251222104003epoutp0163b2b51dd75d9914feb72cc01fa9959c~Dg3GsxJ-q1391913919epoutp01I;
	Mon, 22 Dec 2025 10:40:03 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251222104003epoutp0163b2b51dd75d9914feb72cc01fa9959c~Dg3GsxJ-q1391913919epoutp01I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1766400003;
	bh=pjZaC5poIzLP6pXI7QJYinWYKVCDEUcHkctu4jxWg7g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Txp4xYwb8+18HdpeTzwUuV9eEt5uFY44hv0fXz0g2nEPUM+doDVz7M2hrxSDSe+J4
	 4JiWz4uikxp9QsuVxeowe7A9Vys8BQjP4vB8P7jsH41tzi/FA90XBa5QsZ1TB3SuUD
	 uB4d5+tO0r/mcqCquFMCDSYb6SInBRr8wiJtNvvo=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251222104002epcas5p1bbc07e27ed1554d537283e4de5f30472~Dg3Gc2_gQ2013220132epcas5p1k;
	Mon, 22 Dec 2025 10:40:02 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4dZZQp5hMnz2SSKd; Mon, 22 Dec
	2025 10:40:02 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20251222102716epcas5p45d0893afb074ef3fa4be0c912cd0e237~Dgr8rSBKS0569305693epcas5p49;
	Mon, 22 Dec 2025 10:27:16 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20251222102709epsmtip2c96dcf0d2e575f707faf58c4bd51098a~Dgr19X0pz1792717927epsmtip2c;
	Mon, 22 Dec 2025 10:27:08 +0000 (GMT)
Date: Mon, 22 Dec 2025 15:56:55 +0530
From: Alok Rathore <alok.rathore@samsung.com>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, shivankg@amd.com, alokrathore20@gmail.com,
	gost.dev@samsung.com, cpgs@samsung.com
Subject: Re: [RFC PATCH v4 8/9] mm: sched: Move hot page promotion from
 NUMAB=2 to pghot tracking
Message-ID: <1983025922.01766400002783.JavaMail.epsvc@epcpadp1new>
MIME-Version: 1.0
In-Reply-To: <20251206101423.5004-9-bharata@amd.com>
X-CMS-MailID: 20251222102716epcas5p45d0893afb074ef3fa4be0c912cd0e237
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_a0106_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20251222102716epcas5p45d0893afb074ef3fa4be0c912cd0e237
References: <20251206101423.5004-1-bharata@amd.com>
	<20251206101423.5004-9-bharata@amd.com>
	<CGME20251222102716epcas5p45d0893afb074ef3fa4be0c912cd0e237@epcas5p4.samsung.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC2ED120018
X-Stat-Signature: q9yg6k375z1kret8siushx95wupuoura
X-Rspam-User: 
X-HE-Tag: 1766400006-558314
X-HE-Meta: U2FsdGVkX1/2FD8JM8IqOCEj/nif+p7qCyqdOWmV99E6hphTsIaACCyZ3jpBv+9cNeItkx7biNrI/hRG/bmPL51DYnkdgK0TSiBA6lubA0Gn7gVRWPFmdj0DXWBV/f4sTjuV2olWzpnZMtthmGaiYkoqjrE8ihLhq5r7nMWpT7hLOw/J4aXQTZbvAm0HLOrjB+wKnfZR7PffCt2YarIOU1YIfAYmiEkGyn5IB0vkjae1EszYoOpmZ8FOVQ/eZRCB82vpd3rxe3zKt6wxdLjTYBvWm4iAXPbxNmGk3X4dAfNhS5Lo5O2MKG07MDwiYBx7fAaaXczPk6lynqbb7/5QTBtcFd2BY/yK7QJoV1UoGSino2AAEGKCKpha+GzMFwG7HaJyGB7vwCCHekNpbY98sLG5k+U5dVc2wmCHtNRuduiGsdWe02biYkwnH4jTDDnG3zakB4dv0CCzBZtS1d83+yyAyK8rlv9aOi7HkhWK3t6uebjW40WqOmbPeaHw+xMM/uS9NziS7PEH6OVm/0B99pLafxOuU1TRxrvTJVBERv3UDCEl/U2wB+cJY6XDFCIswFiP8TWf4wWYu+S9uA21KKd5oTx8WqzYONeDP6yoVq55vbH2zTn4X5XmG5mxf8qbJVXMxp59s1zvPCGOGlupa0Rw3UJhZVzwy0hrocKuzSCIC1GkOhnQUph44vgYv0MXZ9H5BZ6SA9yKGhvISh3hD50Ee5NV2q56CmU6dk4BcjLgl3ax/zgSgCP53qAoBPJtOkaekUufPJDL7345DtZeZ/jWYFygjS+AsheXUzCdMdgRaKkp56i99lHQz2GocNZJ9HvN1dwCPy6f2myrGQLzqKqysO5Il3fS6qKatwSoqocveYCVmgI8prhUDlOGW4kcjlWUDStAfOdideJlqYMbwIlFOfpfIp9cmNBL63ujrEBdz3JgYfA5hyy9IC4HTNIChoXKhqvHzV4Zxkt/sES
 Hf+bXE36
 m3yasTHhHDyKEGBEYXt6quk4vnoEpL++obDJek1Vp1ifKtxlxvnxnkjG0skYpaAO70hwBVqI/UIN5vQJXq/r8MJfnZYXx6sOG4PdL2pyIfNRElHL0SfBj7KXrz2YxHc5AKoe1l70khynsNl8jx23WRbYf0Gvse8+mFONTfZBbV3Yn6nq/u3IQRSLWizs1h/vs0DMb9iW5Faxn0D4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_a0106_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Disposition: inline

On 06/12/25 03:44PM, Bharata B Rao wrote:
>Currently hot page promotion (NUMA_BALANCING_MEMORY_TIERING
>mode of NUMA Balancing) does hot page detection (via hint faults),
>hot page classification and eventual promotion, all by itself and
>sits within the scheduler.
>
>With the new hot page tracking and promotion mechanism being
>available, NUMA Balancing can limit itself to detection of
>hot pages (via hint faults) and off-load rest of the
>functionality to the common hot page tracking system.
>
>pghot_record_access(PGHOT_HINT_FAULT) API is used to feed the
>hot page info. In addition, the migration rate limiting and
>dynamic threshold logic are moved to kmigrated so that the same
>can be used for hot pages reported by other sources too.
>
>Signed-off-by: Bharata B Rao <bharata@amd.com>

<snip>

>--- a/mm/pghot.c
>+++ b/mm/pghot.c
>@@ -12,6 +12,9 @@
>  * the hot pages. kmigrated runs for each lower tier node. It iterates
>  * over the node's PFNs and  migrates pages marked for migration into
>  * their targeted nodes.
>+ *
>+ * Migration rate-limiting and dynamic threshold logic implementations
>+ * were moved from NUMA Balancing mode 2.
>  */
> #include <linux/mm.h>
> #include <linux/migrate.h>
>@@ -25,6 +28,8 @@ static unsigned int pghot_freq_threshold = PGHOT_DEFAULT_FREQ_THRESHOLD;
> static unsigned int kmigrated_sleep_ms = KMIGRATED_DEFAULT_SLEEP_MS;
> static unsigned int kmigrated_batch_nr = KMIGRATED_DEFAULT_BATCH_NR;
>
>+/* Restrict the NUMA promotion throughput (MB/s) for each target node. */
>+static unsigned int sysctl_pghot_promote_rate_limit = 65536;
> static unsigned int sysctl_pghot_freq_window = PGHOT_DEFAULT_FREQ_WINDOW;
>
> static DEFINE_STATIC_KEY_FALSE(pghot_src_hwhints);
>@@ -43,6 +48,14 @@ static const struct ctl_table pghot_sysctls[] = {
> 		.proc_handler   = proc_dointvec_minmax,
> 		.extra1         = SYSCTL_ZERO,
> 	},
>+	{
>+		.procname	= "pghot_promote_rate_limit_MBps",
>+		.data		= &sysctl_pghot_promote_rate_limit,
>+		.maxlen		= sizeof(unsigned int),
>+		.mode		= 0644,
>+		.proc_handler	= proc_dointvec_minmax,
>+		.extra1		= SYSCTL_ZERO,
>+	},
> };
> #endif
>
>@@ -137,8 +150,13 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
> 		old_freq = (hotness >> PGHOT_FREQ_SHIFT) & PGHOT_FREQ_MASK;
> 		old_time = (hotness >> PGHOT_TIME_SHIFT) & PGHOT_TIME_MASK;
>
>-		if (((time - old_time) > msecs_to_jiffies(sysctl_pghot_freq_window))
>-		    || (nid != NUMA_NO_NODE && old_nid != nid))
>+		/*
>+		 * Bypass the new window logic for NUMA hint fault source
>+		 * as it is too slow in reporting accesses.
>+		 * TODO: Fix this.
>+		 */
>+		if ((((time - old_time) > msecs_to_jiffies(sysctl_pghot_freq_window))
>+		    && (src != PGHOT_HINT_FAULT)) || (nid != NUMA_NO_NODE && old_nid != nid))
> 			new_window = true;
>
> 		if (new_window)
>@@ -166,6 +184,110 @@ int pghot_record_access(unsigned long pfn, int nid, int src, unsigned long now)
> 	return 0;
> }
>
>+/*
>+ * For memory tiering mode, if there are enough free pages (more than
>+ * enough watermark defined here) in fast memory node, to take full
>+ * advantage of fast memory capacity, all recently accessed slow
>+ * memory pages will be migrated to fast memory node without
>+ * considering hot threshold.
>+ */
>+static bool pgdat_free_space_enough(struct pglist_data *pgdat)
>+{
>+	int z;
>+	unsigned long enough_wmark;
>+
>+	enough_wmark = max(1UL * 1024 * 1024 * 1024 >> PAGE_SHIFT,
>+			   pgdat->node_present_pages >> 4);
>+	for (z = pgdat->nr_zones - 1; z >= 0; z--) {
>+		struct zone *zone = pgdat->node_zones + z;
>+
>+		if (!populated_zone(zone))
>+			continue;
>+
>+		if (zone_watermark_ok(zone, 0,
>+				      promo_wmark_pages(zone) + enough_wmark,
>+				      ZONE_MOVABLE, 0))
>+			return true;
>+	}
>+	return false;
>+}
>+
>+/*
>+ * For memory tiering mode, too high promotion/demotion throughput may
>+ * hurt application latency.  So we provide a mechanism to rate limit
>+ * the number of pages that are tried to be promoted.
>+ */
>+static bool kmigrated_promotion_rate_limit(struct pglist_data *pgdat, unsigned long rate_limit,
>+					   int nr, unsigned long now_ms)
>+{
>+	unsigned long nr_cand;
>+	unsigned int start;
>+
>+	mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE, nr);
>+	nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
>+	start = pgdat->nbp_rl_start;
>+	if (now_ms - start > MSEC_PER_SEC &&
>+	    cmpxchg(&pgdat->nbp_rl_start, start, now_ms) == start)
>+		pgdat->nbp_rl_nr_cand = nr_cand;
>+	if (nr_cand - pgdat->nbp_rl_nr_cand >= rate_limit)
>+		return true;
>+	return false;
>+}
>+
>+static void kmigrated_promotion_adjust_threshold(struct pglist_data *pgdat,
>+						 unsigned long rate_limit, unsigned int ref_th,
>+						 unsigned long now_ms)
>+{
>+	unsigned int start, th_period, unit_th, th;
>+	unsigned long nr_cand, ref_cand, diff_cand;
>+
>+	th_period = KMIGRATED_PROMOTION_THRESHOLD_WINDOW;
>+	start = pgdat->nbp_th_start;
>+	if (now_ms - start > th_period &&
>+	    cmpxchg(&pgdat->nbp_th_start, start, now_ms) == start) {
>+		ref_cand = rate_limit *
>+			KMIGRATED_PROMOTION_THRESHOLD_WINDOW / MSEC_PER_SEC;
>+		nr_cand = node_page_state(pgdat, PGPROMOTE_CANDIDATE);
>+		diff_cand = nr_cand - pgdat->nbp_th_nr_cand;
>+		unit_th = ref_th * 2 / KMIGRATED_MIGRATION_ADJUST_STEPS;
>+		th = pgdat->nbp_threshold ? : ref_th;
>+		if (diff_cand > ref_cand * 11 / 10)
>+			th = max(th - unit_th, unit_th);
>+		else if (diff_cand < ref_cand * 9 / 10)
>+			th = min(th + unit_th, ref_th * 2);
>+		pgdat->nbp_th_nr_cand = nr_cand;
>+		pgdat->nbp_threshold = th;
>+	}
>+}
>+
>+static bool kmigrated_should_migrate_memory(unsigned long nr_pages, unsigned long nid,
>+					    unsigned long time)
>+{
>+	struct pglist_data *pgdat;
>+	unsigned long rate_limit;
>+	unsigned int th, def_th;
>+	unsigned long now = jiffies;

now = jiffies & PGHOT_TIME_MASK; 

>+	unsigned long now_ms = jiffies_to_msecs(now);
>+
>+	pgdat = NODE_DATA(nid);
>+	if (pgdat_free_space_enough(pgdat)) {
>+		/* workload changed, reset hot threshold */
>+		pgdat->nbp_threshold = 0;
>+		mod_node_page_state(pgdat, PGPROMOTE_CANDIDATE_NRL, nr_pages);
>+		return true;
>+	}
>+
>+	def_th = sysctl_pghot_freq_window;
>+	rate_limit = MB_TO_PAGES(sysctl_pghot_promote_rate_limit);
>+	kmigrated_promotion_adjust_threshold(pgdat, rate_limit, def_th, now_ms);
>+
>+	th = pgdat->nbp_threshold ? : def_th;
>+	if (jiffies_to_msecs(now - time) >= th)

Setting time in pfn hotness using PGHOT_TIME_MASK in pghot_record_access(). Therefore
here also it should be calculated using PGHOT_TIME_MASK. Then it'll be right comparision.

Regards,
Alok Rathore


------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_a0106_
Content-Type: text/plain; charset="utf-8"


------IrfruICR4kMULzJWPGPqiSt5VhS9eUGYkVmPB-DHhmy0YhYM=_a0106_--


