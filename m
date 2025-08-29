Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96355CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 15:49:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74A98E001B; Fri, 29 Aug 2025 11:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7A38E0017; Fri, 29 Aug 2025 11:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE68B8E001B; Fri, 29 Aug 2025 11:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ACAB68E0017
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 11:49:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71CEF1DE827
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:49:09 +0000 (UTC)
X-FDA: 83830228818.07.793AA1F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id A3A71180007
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 15:49:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Txvuw8E5;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756482547; a=rsa-sha256;
	cv=none;
	b=Dg0NgmyBOHWfYMx1jq4a+JPHBkcBNlKvQvfRSh5JKclT/Mnq9eIZhKVJTb+GQroFGG6TbM
	Osipc5cfM5bH53GzPlAILF/QkClCdJH/9O5d+ZIsxAU6H4KQsy+zxYLL7DSrvW8rt9rANi
	i1/XFEDSJ1OF5BpXFiBzdW3ATz/WU7A=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Txvuw8E5;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756482547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hGT6Q9f0jxN/W6CaPVBuhaYRPI660IOM6K3SEZrXcRw=;
	b=Xt/8sfXshyUig24ARFRPiHMimMaKPqoU+oOtV8sJjRd3bbe3VvgVTyMn7kdtUDAAYsjGYd
	jJCx2PsgxTHx87a7mZREWUWMRqvvP5k3Ac/3fJs9dkksN4jYqpS8F0P5V1rW4faSMo++NG
	2xeeoOyzGZtVURYHTt2jXz/7bEd8yLE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 99B0D4494E;
	Fri, 29 Aug 2025 15:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF56EC4CEF5;
	Fri, 29 Aug 2025 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756482546;
	bh=2AKrGqjcDEQNktrx0AjvGJUm44a7opBORKSmeOdVWP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Txvuw8E5yTPsG09Tjpv6OmMLkfH+kmFBRxaLHs+eyP+UoV4kakVxkflji9xw907jH
	 sQp8aBkSqwIXZZRf9IdQ/UZT9lannJILBTTPoyVlTDB1KS7AHAGhl0g0HVqHhHTnxk
	 ZZDB3UtJ8VWcifGeJjmlJ42eHT9rLJHLF1GQ6F2RC+FF+yfYvZsDLt0EOLW2lkZucL
	 xWOgvL+ENrJobKRaKvx1bVMc+dWycLyO/F7g7kk3RIZdm17FK3FrWGhGt3vDq1Mn8r
	 wsDWhF4ZBpyflA3e+OCuLBS72S5hhtvj9evyI4zNoLHczcOE2GAzORnyqejY1wbhdY
	 ReuZz+MKUTF+g==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	linux-mm@kvack.org
Subject: [PATCH 16/33] sched/isolation: Flush vmstat workqueues on cpuset isolated partition change
Date: Fri, 29 Aug 2025 17:47:57 +0200
Message-ID: <20250829154814.47015-17-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250829154814.47015-1-frederic@kernel.org>
References: <20250829154814.47015-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A3A71180007
X-Stat-Signature: 3tcnn19o74i1fd3fnbsg5w9r9tu4ajoo
X-Rspam-User: 
X-HE-Tag: 1756482547-603762
X-HE-Meta: U2FsdGVkX1+Luq/JRNjcHaaLG91MEhDuC8L1JxaFJX9X5/1pYhO1w5sAYwaYx4Sh1fN4hp6oV9QGVhuKjtYhCqtoeBF9eQ6rbCnrdg5r9VyPSCCw3EgfmEvpAdVAj+y1CilX3owxEBtxSOBKR/eaGBuFfYLohoBmKKCvdDPkGaP0MzFfG9emwpi2T1TFNBPYW9Dk7cOFDjsx82HvFAbKvKudwiQjVPI045N0O4nxSGlUsfAzsV38HNwTZobchrZUrjtVVUW5HQ+fopU4PhRqNEaS+DLitbJgBrNFFCCtBnVU2/EQmVy7OaJS5E3ZYSOr+7415msAk/cbTZg8XhjHzqpEYEXMXd/ma2pRCxVr7w+nb8ECsDIagbbQjOjiFRPstRYdJlrfpJ3rniB4/BDM07kONZ5fQwnSwEppc3eJZl7hBiMHypdFglRmS2hcWe6cRUe6Rw7HG89BIzFYeqS+ON9OE6n5j3fquJbFhknINSGjB63UoFFLJION72LPo6PmgkdK/hagGpHNJ16rxGQXnyLW2eaOzSRYJxsaGGsruyofC8L4Efra11K6VD///udUkn15CozU6dAcgffbB6yjV2ihjtj+/uI8imeDIDEru+kbr03OXTjRfs4FOtdzX2xRBTaqlSbU3yvP3KUhDLzKaspdWO8mX0fnhqYyPDh/rhwH+YVJ62qz/kS8KAqQjPX8G2wo/WnClJqpaci2b11LO3Y/5hHo1monNQDnBxDL5NezIjxIOtG9/XniUZK3dKNlqELbGe6r5P+dnd6mz+oS5pf66ggFlhz1L0HPKbnKAw9Ov9E1fyNU7t/Ulm/68SvmCBsRtwr159JGYsPYgWdpHZ4uzzPdLrzESoBKspNKPbkjRotfHTqYoPcBKtFLbRDgC2/M1GMRxSzQTyi+wbRP+TsbL3CuIS+AFa9/vqQioVTRmifbJDn5mewxTTdrKIpMvx1TJIkeBI8y5kw9S5f
 /ivhzYCD
 FuBgUHKfhk8mhXi9aiY8udY6Giu6CpkB6GUoqGbdubUQMZ7LKeypasHdYzu2hr/qV0ykrpEDX2e9oEcI8kXR+6vKpwb25GdogrqyG6CdBU+IhnPo+tP021pbDQ+Z1ehfxbEdIJP3O0eawrSjLmlPF64fxK/I6hdPNUTtjXriYv7TUKRJx9ziJcqmJuL7RSHFHK+W9C9P7Zxh7WmpukvWQBJ42G7npz32G+vjCTj8L4SxLm+2HDwW34mKMozJWECEWd5TItERWHhKCe+hGZIcM1pqaetIwx+bxF0fmyWyp3G73QT4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask is now modifyable at runtime.
In order to synchronize against vmstat workqueue to make sure
that no asynchronous vmstat work is still pending or executing on a
newly made isolated CPU, the housekeeping susbsystem must flush the
vmstat workqueues.

This involves flushing the whole mm_percpu_wq workqueue, shared with
LRU drain, introducing here a welcome side effect.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 include/linux/vmstat.h   | 2 ++
 kernel/sched/isolation.c | 1 +
 kernel/sched/sched.h     | 1 +
 mm/vmstat.c              | 5 +++++
 4 files changed, 9 insertions(+)

diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
index c287998908bf..a81aa5635b47 100644
--- a/include/linux/vmstat.h
+++ b/include/linux/vmstat.h
@@ -303,6 +303,7 @@ int calculate_pressure_threshold(struct zone *zone);
 int calculate_normal_threshold(struct zone *zone);
 void set_pgdat_percpu_threshold(pg_data_t *pgdat,
 				int (*calculate_pressure)(struct zone *));
+void vmstat_flush_workqueue(void);
 #else /* CONFIG_SMP */
 
 /*
@@ -403,6 +404,7 @@ static inline void __dec_node_page_state(struct page *page,
 static inline void refresh_zone_stat_thresholds(void) { }
 static inline void cpu_vm_stats_fold(int cpu) { }
 static inline void quiet_vmstat(void) { }
+static inline void vmstat_flush_workqueue(void) { }
 
 static inline void drain_zonestat(struct zone *zone,
 			struct per_cpu_zonestat *pzstats) { }
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index e85f402b103a..86ce39aa1e9f 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -125,6 +125,7 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 	synchronize_rcu();
 
 	mem_cgroup_flush_workqueue();
+	vmstat_flush_workqueue();
 
 	kfree(old);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 1dad1ac7fc61..2d4de083200a 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -68,6 +68,7 @@
 #include <linux/types.h>
 #include <linux/u64_stats_sync_api.h>
 #include <linux/uaccess.h>
+#include <linux/vmstat.h>
 #include <linux/wait_api.h>
 #include <linux/wait_bit.h>
 #include <linux/workqueue_api.h>
diff --git a/mm/vmstat.c b/mm/vmstat.c
index b90325ee49d3..69412b61fe1b 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2113,6 +2113,11 @@ static void vmstat_shepherd(struct work_struct *w);
 
 static DECLARE_DEFERRABLE_WORK(shepherd, vmstat_shepherd);
 
+void vmstat_flush_workqueue(void)
+{
+	flush_workqueue(mm_percpu_wq);
+}
+
 static void vmstat_shepherd(struct work_struct *w)
 {
 	int cpu;
-- 
2.51.0


