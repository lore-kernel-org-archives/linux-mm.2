Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C9DFC982F0
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 00:32:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522BB6B00AC; Mon, 21 Sep 2026 20:32:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D34F6B00AD; Mon, 21 Sep 2026 20:32:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9BA6B00AE; Mon, 21 Sep 2026 20:32:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0216B00AC
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:32:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8E3DA80329
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:23 +0000 (UTC)
X-FDA: 85239521766.19.BD8F61A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	by imf15.hostedemail.com (Postfix) with ESMTP id 54D89A0005
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 00:32:21 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EGKm6Nal;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790037141;
	b=WhDxx1nPpoVPwY8VUPGNB4nI+hwJR++AZ6xtTae1JbZW+Bz0RoBBc6C6AYkt3IyoK7KADI
	+C/5ICIFHFoZgICPoocGFPWWTHUD4fowZ4HyHQ+Azvs7vp6AHUPF9IfIiIoIckSH6EMv/j
	UQLeh5b+b0Bi8m1VcfbPDrAnTUnHxwY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EGKm6Nal;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf15.hostedemail.com: domain of tim.c.chen@linux.intel.com designates 192.198.163.15 as permitted sender) smtp.mailfrom=tim.c.chen@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790037141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZTiQJDWW02u1O16C9YANI41LWoC5NCq89PPHTz/pRM=;
	b=wc3iRz/ShfXf2KUSlGbXSit4m9MCQapWmUM9vcrVeW4Lo9pv9km9NQQq+55i/5DjufCx6V
	VbsLAO3N+sJPKtXjSBbSH12VDhyopqi50bVIg4Lefk+vKP6vokWYLfqOY8gOJ/YKfY4Abq
	+CiO/QHY5PtEoZVQSDsR7smEC/27Ni8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790037142; x=1821573142;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eXYuTenHkmviiP89DV79U/M3G01VwUN3IcB9EPfEUW4=;
  b=EGKm6NalJCRHqBcPA98a6/qPbU43QjFR0BODpJGBjzevdleqiMu9PjjS
   VV/MlwE8KtcRhBhy3L37sOd8XIdBMDckJlpFY+VXjaXQgCRuQMgM5+Lqa
   SLvD6XXwxvxVLIXCB855tz2evZPmU70nHq/Z6lCyOzOmc00+IQp25wJrb
   fjAqQJFTuIqg0FC/dbbpwJZ5PVZpRTn7dS1dU7dOdNC501r1Qb5fg8h3Y
   gsxK5VxUCCJv1uzKrEfWvnYKFR3kIYDH9rwM68i9A+e5gNFv6KLJmBLQF
   hJ4jWqEcdogg4weWNbykXldeg0Yz2k8VXrV9LC2sX6UMla6s17BkDMwLX
   A==;
X-CSE-ConnectionGUID: SDlvSREjTpWJKB89qLaHcA==
X-CSE-MsgGUID: ItdknYkDSa6GhMRJN1ZAWw==
X-IronPort-AV: E=McAfee;i="6800,10657,11912"; a="90716745"
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="90716745"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2026 17:32:20 -0700
X-CSE-ConnectionGUID: gRU2xwr9RXGJBzfMN92iYw==
X-CSE-MsgGUID: NTHk847jRTG3cUQ0MrdRsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,115,1787036400"; 
   d="scan'208";a="277671922"
Received: from b04f130c83f2.jf.intel.com ([10.165.154.98])
  by fmviesa004.fm.intel.com with ESMTP; 21 Sep 2026 17:32:19 -0700
From: Tim Chen <tim.c.chen@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>
Cc: Davi Chaves Azevedo <davichazbh@gmail.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Jan Kara <jack@suse.cz>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Qais Yousef <qyousef@layalina.io>,
	Aaron Lu <ziqianlu@bytedance.com>,
	Srikar Dronamraju <srikar@linux.ibm.com>,
	Vineeth Remanan Pillai <vineethr@linux.ibm.com>,
	Ricardo Neri-Calderon <ricardo.neri-calderon@linux.intel.com>,
	Chen Yu <yu.c.chen@intel.com>,
	Lu Wang <wanglu.priv@gmail.com>,
	Hyunwoo Kim <imv4bel@gmail.com>,
	Zhan Xusheng <zhanxusheng@xiaomi.com>,
	Zhan Xusheng <zhanxusheng1024@gmail.com>,
	Yi Lai <yi1.lai@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	stable@kernel.org
Subject: [PATCH v2 6/6] sched/cache: Refresh LLC capacity across CPU hotplug
Date: Mon, 21 Sep 2026 17:37:27 -0700
Message-Id: <6751d93e15889e624796c74db0bfe66603d60b1b.1790035273.git.tim.c.chen@linux.intel.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1790035273.git.tim.c.chen@linux.intel.com>
References: <cover.1790035273.git.tim.c.chen@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 54D89A0005
X-Stat-Signature: x54k99hzduo98a6h5t3rqnot9eprumeb
X-HE-Tag: 1790037141-396406
X-HE-Meta: U2FsdGVkX19Isik+SPj5VH/g12HykwxGpCuibiM41AqFEjnQbMbpil770YZ8M5dwmxHNkeg6pyu0eE5HICpHe9NXZEYyDggiODoKzoF4HBMwmI+sDrtA/DbOuelZCgAIixhvrwZpHi7k/8SLBk/tv9LX9COg5pyGLbXx3WNba3IwZd7l0a/jPrKm6JIAJqElxDZofyx4XpMugp7ru1K2hA+d3fKFQJF1hlSeJPAAlqjHhXOEES5xf0eaO65FVCODyv1Dd/wmvr06+3kuRJCdvmqPD2a2HuuF32FtL2w3uFApk31K3rFhXjbJlYVOot2FxGvIMMOMB/iC6noJrLfWN1GcfBEHDFhpLJLpfauhIrNJRT6mvLhjHXib1yyCDqI6FIYso/2pRS/cYVwgI4IHTwrBqQsaE4Fmq8RlC6R587d940zKyzFsJJq7tfzwh0Rsq22X05K/yBh3mx9tUZSj//Z7xKZUknvlxye4AordTWa3vYmUGiMuDAQcq71vmLOKPnnlhbQ7OCdEy0UDkM5yb7bA3LUo2vT+Hl/30xDialg97d4JKYuEeKnGyZcfpT/dC8iL2XhCm0gpBmbMNRzHNC72ZXPQaNwMv3yfdzGYDDtFJiORPFdW0Sim0pH9DHBp3f4CBChbYArwKL2uz6qXChHBzoKr5xl+k1obTdm3a0fuSYpm4rLi5lk31YNkV8qGdC8I2gzYZAEfqCXLj6HqyM9W1giybZYTIltJH2o5p+btJptuT3ll+AE3iUbm/PR9F4/V+m5+DXELaDV+gCTa+aei9mfOBbuwDsN38ORnETl6IXvE8C2uAN6ArFtgtENnl4bfE6ncYh5z4IZ7YrbeWhEUecvCggFcD2AiEn5gyiQJkAeOXCPCkgyBd2tsrBlGLWps/nReETHCSDbJe2TUaiY3knsHd5B3DTP1x0HkCOnrQYDCXvM8pibJiq0dAXphQSslRnDbG1dr4B0EF7D
 8cyvZMxF
 uLvEGAnAE650hc2uEyG4YbGQ9QwJF8A0JbnxgF0/k/23fcXUxx6/jI9l9kIEo2PI4LixuX9PsrijWEikEdiB43hvcc0oOfmiMafVa3KewYvpExIbOoaXtptzDWavIYBJaYBbBMJEmagvXC6FwivpD9bP4G9V11aZhBPqerQLBn1DLeYGKHx3hBbi1VblUnnxzIIcka880QJg5Vngw1adMGfyJ8kaW2/wHi0DHAWMyEc7psHPI8L5PVdZV8ApqDrJkrvgXGiqLCmNNVLJN4ynEP15sgvzz62q8XKnsWBDk91Jc71/5HBmPc1BjtKpBFWBguEoRGVU60QSdp+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Davi Chaves Azevedo <davichazbh@gmail.com>

The scheduler scales LLC capacity by the fraction of cache-sharing CPUs
covered by a domain:

  llc_bytes = cache_size * span_weight / shared_weight

During CPU teardown, sched_cpu_deactivate() rebuilds scheduler domains
before cacheinfo_cpu_pre_down() removes the CPU from shared_cpu_map. The
new domains therefore use the old sharing weight. The later call to
sched_update_llc_bytes() looks up the departing CPU's sd_llc, which has
already been detached, and returns without correcting the surviving CPUs.

On a Ryzen 5 7535U with twelve logical CPUs sharing a 16 MiB LLC,
offlining one SMT sibling left the remaining CPUs with:

  llc_bytes = floor(16777216 * 11 / 12) = 15379114 bytes

The correct capacity is still 16777216 bytes. On systems with active
cache-aware scheduling, an underestimated capacity can cause
exceed_llc_capacity() to reject aggregation for a process whose footprint
would fit. Unchanged cpuset partitions sharing the physical cache can
also retain stale capacity when a CPU comes online in another partition.

Pass the cache-sharing mask already retained by cacheinfo to the
scheduler update. Refresh every surviving CPU using its own LLC domain
so that each partition receives the correct share. This also preserves
the correction needed as cache-sharing maps grow during boot.

Keep the existing CPU-hotplug and scheduler-domain synchronization. The
update remains on the hotplug path; no steady-state scheduling operation
or persistent allocation is added.

Fixes: 7030513a0877 ("sched/cache: Calculate the LLC size and store it in sched_domain")
Signed-off-by: Davi Chaves Azevedo <davichazbh@gmail.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Tested-by: Chen Yu <yu.c.chen@intel.com>
Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
Reviewed-by: K Prateek Nayak <kprateek.nayak@amd.com>
Tested-by: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: stable@kernel.org #7.2.x
Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
---
 drivers/base/cacheinfo.c       | 11 ++++++-----
 include/linux/sched/topology.h |  4 ++--
 kernel/sched/topology.c        | 22 +++++++++++++---------
 3 files changed, 21 insertions(+), 16 deletions(-)

diff --git a/drivers/base/cacheinfo.c b/drivers/base/cacheinfo.c
index 9f9c72727a05..7a47a392568a 100644
--- a/drivers/base/cacheinfo.c
+++ b/drivers/base/cacheinfo.c
@@ -1040,9 +1040,10 @@ static int cacheinfo_cpu_online(unsigned int cpu)
 	rc = cache_add_dev(cpu);
 	if (rc)
 		goto err;
-	if (cpu_map_shared_cache(true, cpu, &cpu_map))
+	if (cpu_map_shared_cache(true, cpu, &cpu_map)) {
 		update_per_cpu_data_slice_size(true, cpu, cpu_map);
-	sched_update_llc_bytes(cpu);
+		sched_update_llc_bytes(cpu_map);
+	}
 	return 0;
 err:
 	free_cache_attributes(cpu);
@@ -1059,10 +1060,10 @@ static int cacheinfo_cpu_pre_down(unsigned int cpu)
 		cpu_cache_sysfs_exit(cpu);
 
 	free_cache_attributes(cpu);
-	if (nr_shared > 1)
+	if (nr_shared > 1) {
 		update_per_cpu_data_slice_size(false, cpu, cpu_map);
-
-	sched_update_llc_bytes(cpu);
+		sched_update_llc_bytes(cpu_map);
+	}
 
 	return 0;
 }
diff --git a/include/linux/sched/topology.h b/include/linux/sched/topology.h
index b5d9d7c2b8ad..f96812d71c51 100644
--- a/include/linux/sched/topology.h
+++ b/include/linux/sched/topology.h
@@ -281,9 +281,9 @@ static inline int task_node(const struct task_struct *p)
 }
 
 #ifdef CONFIG_SCHED_CACHE
-extern void sched_update_llc_bytes(unsigned int cpu);
+extern void sched_update_llc_bytes(const struct cpumask *cpus);
 #else
-static inline void sched_update_llc_bytes(unsigned int cpu) { }
+static inline void sched_update_llc_bytes(const struct cpumask *cpus) { }
 #endif
 
 #endif /* _LINUX_SCHED_TOPOLOGY_H */
diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 0248227d983a..3dab0253976f 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -985,8 +985,8 @@ void sched_cache_active_set(void)
 }
 
 /*
- * Update the bottom sched_domain's llc_bytes for @cpu and all its
- * LLC siblings. Called from cacheinfo_cpu_online() or
+ * Update the bottom sched_domain's llc_bytes for @cpus sharing a physical
+ * LLC. Called from cacheinfo_cpu_online() or
  * cacheinfo_cpu_pre_down() with cpu hotplug lock held.
  *
  * Note: get_effective_llc_bytes() returns 0 on PowerPC.
@@ -996,17 +996,13 @@ void sched_cache_active_set(void)
  * and does not populates the per-CPU struct cpu_cacheinfo array
  * that get_cpu_cacheinfo_llc() reads.
  */
-void sched_update_llc_bytes(unsigned int cpu)
+void sched_update_llc_bytes(const struct cpumask *cpus)
 {
 	struct sched_domain *sd, *sdp;
 	unsigned int i;
 
 	sched_domains_mutex_lock();
 
-	sdp = rcu_dereference_sched_domain(per_cpu(sd_llc, cpu));
-	if (!sdp)
-		goto unlock;
-
 	/*
 	 * ci->shared_cpu_map is built incrementally as CPUs come
 	 * online, so the first CPU in an LLC initially sees
@@ -1014,14 +1010,22 @@ void sched_update_llc_bytes(unsigned int cpu)
 	 * get_effective_llc_bytes().  Re-evaluating every LLC
 	 * sibling on each online event corrects this once the full
 	 * shared_cpu_map is known.
+	 *
+	 * The departing CPU's domains have already been detached when
+	 * cacheinfo removes it. Use the surviving cache siblings instead.
+	 * They may belong to different cpuset partitions, so use each CPU's
+	 * own LLC domain to scale its share of the physical cache.
 	 */
-	for_each_cpu(i, sched_domain_span(sdp)) {
+	for_each_cpu(i, cpus) {
+		sdp = rcu_dereference_sched_domain(per_cpu(sd_llc, i));
+		if (!sdp)
+			continue;
+
 		sd = rcu_dereference_sched_domain(cpu_rq(i)->sd);
 		if (sd)
 			sd->llc_bytes = get_effective_llc_bytes(i, sdp);
 	}
 
-unlock:
 	sched_domains_mutex_unlock();
 }
 
-- 
2.32.0


