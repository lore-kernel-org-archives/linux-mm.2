Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B2A6E75453
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:47:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71FA86B00B1; Wed, 24 Dec 2025 08:47:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D2DB6B00B3; Wed, 24 Dec 2025 08:47:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5ED1D6B00B4; Wed, 24 Dec 2025 08:47:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 48F3C6B00B1
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:47:52 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B3AD137F5D
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:52 +0000 (UTC)
X-FDA: 84254492784.09.9E94ABC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 51B2C14000C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tGDOURCo;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuGPUARzFtv6rCMZtRiKBx+99393ISZnJwgaUxtzjRU=;
	b=trKJO2x/OiW4I/yMxXUGF8imemzbjISKPiN51d3Ze8eECWfD+hm39t+kGuHgHozvjICuCK
	Rvc880lAaRzPHsjf6oqSpX7Ml3GSLCb1Ax4nhQPmFQxsqvn0VgzR2/v4lfr0M62KgUvIFy
	epF90jbyHfLGNXQifIBy3SxCsslwHC8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tGDOURCo;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584070; a=rsa-sha256;
	cv=none;
	b=rv0OyPvbubAUS/CdbP5v92gQPvkjD8CNUgIWesKB2d87g58urvyeai9MSLJieGGlU3wbo7
	yWQNoV6gIaDtQEG7JmqlJ4F2FOQS1a65AcXsqORxDsHext35H/9HH5Q96DU0rdAe9YYebp
	Ts+6lkvEO1h0+0WdEy+pqYkk8Uv0lZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 28A8B4076B;
	Wed, 24 Dec 2025 13:47:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EC30C116D0;
	Wed, 24 Dec 2025 13:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584069;
	bh=j75MjcSTKE+gPiri9G2CY0WT96U7ncUHjUjFXhcby8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tGDOURCoS9wnchNh8bBRmK5Xp9uCpti/BljOPgRdlojfso+jWz2IkM2AjGVEoifLt
	 sPPMjV5IWQ44apJwBvlMUkKexdGZV3qmo3xS0ttdiNNaNibrlivjtELSGGZjWFMvAO
	 ntYZ+8/4wRZoO29ETd1M1VSnIfZ+Dd3zhRSLRNeZZG1qb6hmarxvHZkX0+PZEtun/2
	 x4dI/iUUSdIxNI0rmjuNbOMgRhZraLJIwZBdFTnxDGCWJHK3q58YcdD4qfX/sSQtmJ
	 Gtgg3zhr72RTW/I2togXantG3oTBwS09XEgPHISc0Y5aLHOwe41UPrqJwuHSOJPSPU
	 sj/rTUuBVQ3PA==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
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
Subject: [PATCH 16/33] sched/isolation: Flush vmstat workqueues on cpuset isolated partition change
Date: Wed, 24 Dec 2025 14:45:03 +0100
Message-ID: <20251224134520.33231-17-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 51B2C14000C
X-Stat-Signature: wo53x8oh8mtrj86s8g1k16d63hwqebaj
X-HE-Tag: 1766584070-756753
X-HE-Meta: U2FsdGVkX19uzasbSnJGtU+a28Ufz/RtsZ3AetXIrZF4gzx2ivuXqNLgYioPzumhHXPM5fAQ5dEcLxhPVjdIV1Qnau0X9YZGekLQt+h0ptl4byH6N/NL6iZOA8GpXpFGEfEFVVhUrkFRlKWomdH3d9T9nARLpXS8qEqZYUzZRVyx/FCZt6xVS48tHTvam1AUg54WiigzEqii318NUCXNKLLySLj0FlVeB3mjyrSkOolfnYjEUN2INpwPzcRITKdResDU1A6Hy3S+eKV0Px56nl2jnld+Ac73hKmNVaoSq2HXmBW2YoDd/C8lGKSiYpY/xySzaWMjGxbLm/dA9szsMOaJI/6hXxPAVTP+vfb5z9DVuOQDAwJvnnlPveHgNyvr4X/1WhO++OhzbsTPw16mXPqvh/VUT5vTWFVXI/nLn4okxa/VGknwBRMhGG8707dxtTLPqaH/hepVjVv3cIduyNbx3Y3ch0YYCs8+mTXR/sNEw8w4q7RJdEQYocI8fS3RHX6ocl/njPUwujW0LWZ7A/5NqeokYtNCOOiA+jUWVHkJmdYbgemaaV6BnRsFtM9pHD02nY69NrL1/tQICJc1DXT9sPKgDCEVYlS/v1NJ647OIWg5GrlveTE+AxXa3oPPLGBM2aPvZpWrjiQynEBktMTZArr+h7Pv9KS3aSCr9ayashv3i03aNEqd4ICBzrVbD1d0tbVl4UZXUjDQP9i1ZjI0TpYkl1txS5zbTPkU7gRM5im1Ex4LGuzjMgUbOoc5T/4b/EoH/xsg/GX01mubaaOMTMGNXNduDn5Yoow3nSN7dIBuhsuFEHfzN5CWN49wAeVToUF3Ah+KtR0yposDNGceDhqp2mv+XIgBPwXip+pySvr0tHysY/N4xulbPZ9GRiOVwljfS9EyBNzrRagrVpM60up659QIpvRcyJ4y34Y7+R0xDdskZVWETE+ccafJ29VTE7ArgGXnnjGCgdv
 KtEBlc65
 3yEO1GR7XAcMkOQON53/ro/ws8a0hO1Wr9tAPIgHeRWETJtvbb7aTB/EM561d9aZCxEaQ9KJVMXKbQPtZNA0KDvCsHoXSjb7T1u3KRMkQ7PAjNUGox3WN5Mv864QkaseuFiTlUctiom1gg3RK7Wk9GL3wc+DdKjNDJBltpdRODCSUbB0kTEygyUmvzRCkjrazqB0AonOeXR19Iz4g+plTJJ81quDALx302e2FmQWqNYqf1jOPIYH8Vz0dCYQvfYvyr7mabpx7yBuLb3YTWkqbuRt/NU7lgEgTNBw4W6pEv3Fv8aM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask is now modifiable at runtime.
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
index 3398a345bda8..1909b945b3ea 100644
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
index bb6c36d2b97b..8aac3c9f7c7f 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -146,6 +146,7 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
 	synchronize_rcu();
 
 	mem_cgroup_flush_workqueue();
+	vmstat_flush_workqueue();
 
 	kfree(old);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 65dfa48e54b7..2d0c408fca0b 100644
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
index ed19c0d42de6..d6e814c82952 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2124,6 +2124,11 @@ static void vmstat_shepherd(struct work_struct *w);
 
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
2.51.1


