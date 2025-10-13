Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79549CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D27388E007D; Mon, 13 Oct 2025 16:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFEB68E0036; Mon, 13 Oct 2025 16:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14878E007D; Mon, 13 Oct 2025 16:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD2E18E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:34:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 79C841405C2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:21 +0000 (UTC)
X-FDA: 83994243522.26.41CA2F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DBFB54000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:19 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y98xRz6h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFw99Lp0VvTcwyAaXr13DK8KKyTZdWnB2XxL0tJ46lc=;
	b=gEm5if8HX3HtN25+u3lohaFOHvBeJMFZZ1rGH7gaVzSSgBlwtmhPfL3SO4WlryWdPv3A93
	2W2kL+6GjpMw63dJ58CrUt9rCJi1YOtvapYruMlN+0+C7HSV+/6ft/Tr163ZCZpOAcKpav
	99/eojpoaMaQqXppMeR+tltdGcl96iI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387660; a=rsa-sha256;
	cv=none;
	b=FResrGdHpBTl596Ns2f/UoFs98TAv/ILXMGtz82Lum46S0b0EebSX3kzL7dii8gWoIimnt
	YtSawvQzkSoTbMpZb9geZTxoIMlaCnXaT8G1Q/W2BzapufnDCjRLdXDvQnhsT5rmbnl3Gq
	oU7eEglGUw4wEJlYawmUk+UeINh2giM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Y98xRz6h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05A3F44E83;
	Mon, 13 Oct 2025 20:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D6CC4CEFE;
	Mon, 13 Oct 2025 20:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387658;
	bh=FzweRnNZ3rpHmeDAR8nh52t/LTbWmLRPuC53BTe2K5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y98xRz6h268U7IXnYXzrzxvIyBXE9M4gvO1uYQ6zbCfgYvyI80M/P8QWh6KpXuZxX
	 dZbiZacrGK46gnAEvGqrVzaLZlxepcsYgdkIx7cY2Pu4MBgeZwLSq9x+83EuxwC2/S
	 WJLOqNPuUssMQwhkmAMZXyRoi9cKCyXdWuWW1rn1T3oONvX2Q8FKtyUaO35aJbeFWu
	 lN+cyfaTya9Kp6gC5ACu2fbOhJgP7PRASkBJp42jx81uo9wc1Uf9c41y2orTHSOWRO
	 SdkYXhyfRCXaIIOQOTkMg9CJGX7N0nz9xD3V1OoA68tqrAMKR9AdVO63kyriR9hDB7
	 cMHS0pLaC7LxA==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 18/33] cpuset: Remove cpuset_cpu_is_isolated()
Date: Mon, 13 Oct 2025 22:31:31 +0200
Message-ID: <20251013203146.10162-19-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: yyekfoqaqhgho8sj8if44ym5srgr4c3z
X-Rspam-User: 
X-Rspamd-Queue-Id: DBFB54000F
X-HE-Tag: 1760387659-753769
X-HE-Meta: U2FsdGVkX1+Qe17G2+R5QViTSAUv4y4d5h74wf8MQPxFbQPOGkFB44ZlUNd8sN5XXMidW9InXN6WKroYGBnZ52cyfVJ3WYU6cjIs+yD7Fwd/YmtLMU/xze6GprwzlG+PqrWa4sg0w0CYtpXX7U6POAwHgQqZwkk7dxx/W/dgkP8s9wy2efDimuKkad64ew3F8mlgXmxOFucPB60QlsLUTi4aGl46O3+RK7ggeJr1VMfp/mi9PSY2CtElENHkkGYcMUlCekcRTmTnAhju47Gq6EWde3w+2814nlsaZXT6779O/C8683pqM0c83CE8whSNk4vRNYVcCeBI3+9mOYfdFF0YEJND35J+Gce6Z8vy9410QzyyuPbxAi5kG0XxtEnsGQWh8e5cQ4gPqtNgFucx/pjL+zveRpC5DXI2NdhzH7dz/B1046lzCINjqjRCq+c7m9MO8xmyfiJq4mTwHSJze+HYuVue4O7dQF82cyB2om68uHSgJKkdnHFgEH7wxDV5zTJdiQuMcAjDDPPPZvjjBa9YaW+7w9Cm0Vw8EvZjIkdMRZBaEGCNHQ3rLCWq6wrlrZyNdU4FQhztfwHGpz8INozDJt1yW9pX/ZDoiEOq8ZEiPdseiXw/bpjB9otK4+zuZd/uhaGOgWrcIOdYm9uP+axYQhGUtxhyIxGJyFl8G11QhbwKNjBmuB/7ZDNzWcu3Oety3R4cAItQbH6B/JESKGu6e9Juvu0RIzFShiNYRoBUyEG6ko1awUT2HFf5M9+JKaIDZ8QLErttIV40tFbslSqASII9tcJs5lCWZlH2kaYhWA2wPNJDPMCdOjoFXC/iJ8hLEwfTuDcdH+hB7Q71lDT36ppdeYMhEKlMZcvZHkh/IlJAf2+nb+lDk+BQKhKk5fguVSJLpWjNrXso0c2NmyejNHPsjiRBPooX+TfVJtGDnMrNLnONUDU1uLcGlUgochwh7tyTzbVjbYdnUaF
 X/t3k62r
 nUtJs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The set of cpuset isolated CPUs is now included in HK_TYPE_DOMAIN
housekeeping cpumask. There is no usecase left interested in just
checking what is isolated by cpuset and not by the isolcpus= kernel
boot parameter.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/cpuset.h          |  6 ------
 include/linux/sched/isolation.h |  3 +--
 kernel/cgroup/cpuset.c          | 12 ------------
 3 files changed, 1 insertion(+), 20 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 051d36fec578..a10775a4f702 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -78,7 +78,6 @@ extern void cpuset_lock(void);
 extern void cpuset_unlock(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
 extern bool cpuset_cpus_allowed_fallback(struct task_struct *p);
-extern bool cpuset_cpu_is_isolated(int cpu);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -208,11 +207,6 @@ static inline bool cpuset_cpus_allowed_fallback(struct task_struct *p)
 	return false;
 }
 
-static inline bool cpuset_cpu_is_isolated(int cpu)
-{
-	return false;
-}
-
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
 {
 	return node_possible_map;
diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 94d5c835121b..0f50c152cf68 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -76,8 +76,7 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 static inline bool cpu_is_isolated(int cpu)
 {
 	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
-	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK) ||
-	       cpuset_cpu_is_isolated(cpu);
+	       !housekeeping_test_cpu(cpu, HK_TYPE_TICK);
 }
 
 #endif /* _LINUX_SCHED_ISOLATION_H */
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ea102e4695a5..e19d3375a4ec 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -29,7 +29,6 @@
 #include <linux/mempolicy.h>
 #include <linux/mm.h>
 #include <linux/memory.h>
-#include <linux/export.h>
 #include <linux/rcupdate.h>
 #include <linux/sched.h>
 #include <linux/sched/deadline.h>
@@ -1405,17 +1404,6 @@ static void update_housekeeping_cpumask(bool isolcpus_updated)
 	WARN_ON_ONCE(ret < 0);
 }
 
-/**
- * cpuset_cpu_is_isolated - Check if the given CPU is isolated
- * @cpu: the CPU number to be checked
- * Return: true if CPU is used in an isolated partition, false otherwise
- */
-bool cpuset_cpu_is_isolated(int cpu)
-{
-	return cpumask_test_cpu(cpu, isolated_cpus);
-}
-EXPORT_SYMBOL_GPL(cpuset_cpu_is_isolated);
-
 /**
  * rm_siblings_excl_cpus - Remove exclusive CPUs that are used by sibling cpusets
  * @parent: Parent cpuset containing all siblings
-- 
2.51.0


