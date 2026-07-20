Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8720C4452D
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D73B6B0098; Mon, 20 Jul 2026 15:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF026B0099; Mon, 20 Jul 2026 15:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876AD6B009B; Mon, 20 Jul 2026 15:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 579516B0098
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:34:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3879402AA
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:56 +0000 (UTC)
X-FDA: 85010157792.17.D58F1A1
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2AA3AC0006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:34:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="A9Ldd//H";
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9m4X8mdOzY8Hd25SBKdvyEitcu3reaQ/sG147Spw2gM=;
	b=GJZtLNlINCOgGZn3knN/8SnEOtpNNLZb48qvhHsMuHsVAxfJt4Ajhh3SdxN9VppIwo7dDu
	/OOvb03eiAuqIULPukKy6EIHXfn6BBjSWzEjlHKyZaiMOeR3yA8sMFenezj7Kh553h7J15
	j22HXIe4JZ1ujnzKHolhlQt4D5tIkrk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="A9Ldd//H";
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576095;
	b=0hNQWvvcPR4ZNprV9UYDU5jckxVfToXwSfCpCxIgZslmL90CaGOclgcZWf+wuejPm+luEg
	vhGmXB1LvU2BlSGlDqg8yzl3GF2Ueqk2t0lmRIB9PyHX3/bbwiPUfCDbdvpeY0Hcz7590H
	d8EXHjQu36pAO8vE5chzvV8BXdTT08w=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8f18d92172aso93701166d6.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576094; x=1785180894; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9m4X8mdOzY8Hd25SBKdvyEitcu3reaQ/sG147Spw2gM=;
        b=A9Ldd//H2KtlElc9Kx4iLlqNSDTFO1lI/VTVDkYLuyUtHeEUmcGfz0ubAWQ8JuDtVG
         Vb7hkxw+CLXnGwMoE4rb2npX6SzHQs2x+o62PdFuXzl9CLZANwAYlsxJ2xCjzZKYoyfL
         BDLZrheB4Z3vkqWYZktT35P3xuls83rJExxa9pCSMT7ts6jEboRQTvYwgn8Oh7erhXT+
         L/lQl9ZTSyEKMQBj4JtiIvCkeFqYvcfC8HPvo+Z4fzyL5iZWP3sECM1qYgT0Gn05FoAR
         C8lw5rNEPVrnXKFXHHbyarXbFJPWlAryb+C9qAq0gnFgt9hxBtrFhxCUuYLG7TPHvBeZ
         dw9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576094; x=1785180894;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9m4X8mdOzY8Hd25SBKdvyEitcu3reaQ/sG147Spw2gM=;
        b=XG/iIbhir/j8q3lbJK7pc2cIlHOC12zPkWBp0PStJX7zS6JINLAPPwPO37SkVzT3So
         hKlcRy28+pLg367cR7YRnayUOrwuT9Mon7AzIfWABZWtJEYVi3zt1g9IclZBvKwR7EMq
         VGN/2RvTNtxMg6Dl58jatZk3lKYdOWAfAgeFwChBazz3rmk/rE69GVYrDgGLt5xxqQAC
         X7cwfmtLK7EqACwtFyR277YjnOYPRQN8i4Ey9E9RvyKMik2GzxsCzYjdWOzn/3ypGuPd
         dUGg3iP917TOdEYrnvcv6micDhwawGRfGOqN/m8wlIIPC9HxiVz3M/q1V6vhOMDedhLp
         fngg==
X-Gm-Message-State: AOJu0Yzkc6R7BH1DeXqqqIM48BEMZc6W1483OMRn45qlwTNmDpbeQfKq
	0wy/pLQeCUjqLWzIGpGw3z20Hy6ftmOAzUHUVpdovsh94mf2EOkrf3V/s11oPnaOGtNyO4bsfLn
	kutcy
X-Gm-Gg: AfdE7cm8SgSVxJuVU5qgAPil9oNBkj+ZCXwoyVeEhXok/KKki6f+l99sW8Z9fgXeKy7
	xWz9UAJmawbUwtjOyok2RdrtQqSeD168mUZjCEgPrU5LO3FuLlvEIqRw8dMYsci+CyjKh+Uw/j4
	naAl1MaS0drpi06zhzquiIa2DkPfUtJ7Z6cjI9TIa5ZgJlGxb296VwxCUKAzBygQzLUm4cSMUko
	/6k8MeXYqFu1BpuBZUN12+uTp2C//qb1ls/5SyhWzAzSslHWAvDmDqF66MBw9TZA9xtXJg7VYEx
	L3uEEyMvRm+eOsGUyTJadSVl/CEQ4AuBGHders0DI8Gl90XXP9W3yy1eU22TZMBCH9e0IgHzkQi
	7OAoNkTCLst94ezznMfRm0PgJRdyFNRJj6zH2RZXKVk06uE+Wr42KVgpGIgBh7Obw0d6KDYN5sa
	o6zHw35DsrEmlIE5Udzwyq8qk0Ec0ey4/yirp9eQ/BG8rohSEi54xzu1IfHXYzGfA=
X-Received: by 2002:a05:620a:2b9c:b0:915:83f3:780d with SMTP id af79cd13be357-930b3ec55e3mr1402108585a.32.1784576094094;
        Mon, 20 Jul 2026 12:34:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:34:53 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 06/36] cpuset: exclude private nodes from cpuset.mems (default-open)
Date: Mon, 20 Jul 2026 15:34:00 -0400
Message-ID: <20260720193431.3841992-7-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2AA3AC0006
X-Rspamd-Server: rspam01
X-Stat-Signature: bed81x4rm1tu1mazy3sszammhox8dhxi
X-HE-Tag: 1784576095-69936
X-HE-Meta: U2FsdGVkX1+UXlqN2SAMblJEsAbnIGMxy7Isi1zkDP4ZstLKEYRjejm7rjRYOEzJTjoxvQyyTmOHX09T7fZTOnSkUVzpkQb0Hooo3wBp01pCaGDNbsX1mIZU4RwCaSLq3Et2iPihc/pYNToeUOz87cVgNTh/gsoDVxFmsfDhP3HlHWtjNNYxHxpNlvOFg3CQvwdaTxGcuhmzZG8bVUcnxYuqdK9d1iluI4RLd4fLoMss6+TgNZzdMPnByNNGphAHBEe4vsM/gC+SdeCIUIDjwuY8pZXd45XouYWyqCH/t8sj+MLY/ANSDNcxxz9xr7fcviR5MXeIzhXmXDjP4B0AEWMfnH5Q2Y7V2JZlubJ7/fTTzbvWtGG75UnQ3gqUWKZA/VwCm9kgF4zQsbsPOCHxavtfmLPLQL1GprO5lS6uu4Ikz2dSApZz4FfGulqdqN2LCWXpUHkscHp6my0+JaUH22sEzwoapS8qDln1e3qy3NvUKkUiWJNibaJ+PSpqIq7tfyeAf1H6/miAH+m2fsuCfhAkjZmayFUcpIQGEt/WrTDOhtDWlAQ1O9J0SoilXHrCj9PYVqZ3AEexlOAU0mUMe8VFFC8zNJt2J56Q2PlkEhZZpin5TIVZvnRSj1d9gf7i+QYLx9cS8JQh+PqrI65QG6Cq4+eRPQZI5tikEGq9CVDYF/Qa/jImzTOIT256/b6Nd+uzZEMm8+9dgD9pk74I+VjUIri+65gjA0SUE2rdFlkx8JSi/Wtu/fkuEPanuBkVCVP14uLeV/fX5dEs54qmhfsagr0ADFKQxrH6dj6wCcSQAHFGc35AnFMAqorbW6M716H0sGlde1/w1QXSealIO11X9xkN/86CQXByubYX1SJu1qCKTPRgKedYSM6UEPH7qFykQ96yKeAa3oBd4Sw05OV2SIufUC8e2eaMW1JZ9cPMB2rM3FN/bkB650zoCwbFE1z5vyJwQ4QXfl5nARF
 QPzTbOWP
 vUsfsO+lwCKhr5q+5iNiZx1cT6hgco4FHZ1HxSVM+lps3V79OTd4iO8/uHOukd2qU/cHFojfaJJeD8JkRnRehoB7PsEPGOMZOlBetka4CLs5szotjPcML5eBf2011hCbznGDz2cp1TvtyKB4w4a4gxyurfTC76QhaX61aGAEmldhcvwFlvMdiIWiPPpmPKRnpCiTxFgORFYVQUZYsL09SbiaPg9IYs4kOe0l6texj6IneUmhxKnx9HsPysPOoJ1LRTMqO6oyDPjrKderQnWkjEi9r1/M1fWDfUfD55m//BWuQqe3owvLUz9eXrq5UygtUle0KrbgzJdVRQPQAaaEtsn+7yyODY8T7zdgF+V3WRKDhY57CQ7aP6YpkFD0xZaWbH3Sn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

N_MEMORY_PRIVATE node access is gated by per-node capabilities and
the zonelist.  Isolating by cpuset offers no functionality and
creates issues on rebind when a cpuset loses access to that node
(in particular: it generates migrations that may not be supported).

Do not partition private nodes via cpuset.mem, instead treat them
as globally accessible resources.  Do not engage in silent background
operations on these nodes due to cpuset.mem membership changing.

The result: cpuset operations checking for node validity always
allow N_MEMORY_PRIVATE nodes.

On hot-unplug, we still need to rebind memory policies if the
private node has left N_MEMORY_PRIVATE (i.e. no more memory).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 kernel/cgroup/cpuset.c | 26 ++++++++++++++++++++++----
 mm/memcontrol.c        |  2 ++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index dfd0f827e3b92..05468f95c10bd 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -26,6 +26,7 @@
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
 #include <linux/memory.h>
+#include <linux/node_private.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/deadline.h>
@@ -3867,7 +3868,8 @@ static void cpuset_handle_hotplug(void)
 	static DECLARE_WORK(hk_sd_work, hk_sd_workfn);
 	static cpumask_t new_cpus;
 	static nodemask_t new_mems;
-	bool cpus_updated, mems_updated;
+	static nodemask_t prev_priv_mems;
+	bool cpus_updated, mems_updated, priv_shrank;
 	bool on_dfl = is_in_v2_mode();
 	struct tmpmasks tmp, *ptmp = NULL;
 
@@ -3890,6 +3892,14 @@ static void cpuset_handle_hotplug(void)
 		       !cpumask_empty(subpartitions_cpus);
 	mems_updated = !nodes_equal(top_cpuset.effective_mems, new_mems);
 
+	/*
+	 * Private nodes are not partitioned by cpuset, but if one leaves
+	 * N_MEMORY_PRIVATE we still need to run mpol_rebind_* to clean up
+	 * mempolicies that are binding them.
+	 */
+	priv_shrank = !nodes_subset(prev_priv_mems, node_states[N_MEMORY_PRIVATE]);
+	prev_priv_mems = node_states[N_MEMORY_PRIVATE];
+
 	/* For v1, synchronize cpus_allowed to cpu_active_mask */
 	if (cpus_updated) {
 		cpuset_force_rebuild();
@@ -3922,9 +3932,12 @@ static void cpuset_handle_hotplug(void)
 			top_cpuset.mems_allowed = new_mems;
 		top_cpuset.effective_mems = new_mems;
 		spin_unlock_irq(&callback_lock);
-		cpuset_update_tasks_nodemask(&top_cpuset);
 	}
 
+	/* Rebind task mempolicies if any memory node changed state */
+	if (mems_updated || priv_shrank)
+		cpuset_update_tasks_nodemask(&top_cpuset);
+
 	mutex_unlock(&cpuset_mutex);
 
 	/* if cpus or mems changed, we need to propagate to descendants */
@@ -4155,11 +4168,13 @@ nodemask_t cpuset_mems_allowed(struct task_struct *tsk)
  * cpuset_nodemask_valid_mems_allowed - check nodemask vs. current mems_allowed
  * @nodemask: the nodemask to be checked
  *
- * Are any of the nodes in the nodemask allowed in current->mems_allowed?
+ * Are any of the nodes in the nodemask usable?  N_MEMORY nodes must be in
+ * current->mems_allowed, while N_MEMORY_PRIVATE nodes are always valid.
  */
 int cpuset_nodemask_valid_mems_allowed(const nodemask_t *nodemask)
 {
-	return nodes_intersects(*nodemask, current->mems_allowed);
+	return nodes_intersects(*nodemask, current->mems_allowed) ||
+	       nodes_intersects(*nodemask, node_states[N_MEMORY_PRIVATE]);
 }
 
 /*
@@ -4223,6 +4238,9 @@ bool cpuset_current_node_allowed(int node, gfp_t gfp_mask)
 
 	if (in_interrupt())
 		return true;
+	/* N_MEMORY_PRIVATE nodes are not partitioned by cpusets.mems */
+	if (node_is_private(node))
+		return true;
 	if (node_isset(node, current->mems_allowed))
 		return true;
 	/*
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23a..f0dde52dc9e0e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6069,6 +6069,8 @@ void mem_cgroup_node_filter_allowed(struct mem_cgroup *memcg, nodemask_t *mask)
 	 * mask is acceptable.
 	 */
 	cpuset_nodes_allowed(memcg->css.cgroup, &allowed);
+	/* N_MEMORY_PRIVATE nodes are not partitioned by cpuset, include them */
+	nodes_or(allowed, allowed, node_states[N_MEMORY_PRIVATE]);
 	nodes_and(*mask, *mask, allowed);
 }
 
-- 
2.53.0-Meta


