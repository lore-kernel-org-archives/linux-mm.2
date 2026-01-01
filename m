Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3DCEEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:16:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D756B00AF; Thu,  1 Jan 2026 17:16:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25F046B00B1; Thu,  1 Jan 2026 17:16:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1812E6B00B2; Thu,  1 Jan 2026 17:16:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07EAA6B00AF
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:16:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 926255FA7F
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:27 +0000 (UTC)
X-FDA: 84284804814.10.4B6ADDA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 13A3140003
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:25 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vDQ2VZez;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PW1NFJUBY/Izw3m2/6PSeOsVmRn1vvjKH/v6fJVELPM=;
	b=ph7vVPMSzfChs9MB69401Oq2sWDfw/fNX3kac6POBeiekqdvkwNe4Ll6ORkRuoTXTsPWc8
	WbKgY95aM/VFvtjj3sV4luTcrLpGx3bzw71RfRsQtAzOGaF+UnKgwRf/vfZ+Ec+edZyG34
	rnEnpumBqY5kqrqB301mV6o/+2TLc+c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305786; a=rsa-sha256;
	cv=none;
	b=h9fbd1DB9XRYBWV+6j92LMR+0PpCW5uVKeBlyJ/Dxh72EWkWU1xQbz1lCFtr5F7ncvk2/w
	J3mBt46/XW30KUM0KW+si+VhV8eknuR44TDKixdVXVm4sYbfjNDTNo2TP+jbrnocuZfHi6
	LVsrpzDBWOYEGKkBWQ6mRao3K9YZb0U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=vDQ2VZez;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9782960017;
	Thu,  1 Jan 2026 22:16:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E39C4CEF7;
	Thu,  1 Jan 2026 22:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305785;
	bh=Ma4KHLlhGG+Y/BxDbCqZKmzyoCP7GgnhhguTZEp+mhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vDQ2VZezadsNVrv+yy5BwTYGs134lyzcTXGJaAR/0lCPMAKylClmPO9iy5OmPLCPC
	 QkM90JtfvR1yW9W6KOSAtGT+EFjTxk/GJFj98bTOy2zYD/xXTiqXUJeEkt+tk7jAvt
	 p/J6BIdd4CadQv6Z41u2gAPQALvHUERjY9JVmgZiJO/Smg1XCERmubpyST07qshx86
	 BM6hE176wATZGpOVO8twZjYsGfelV0voPrZlhfYDNWsuXO2jJ/fDN0lGTrrL4jRE2x
	 4IgriVAzgpcgDnkDKxjeJMQXwToxuKuirS/ogYI4xPehn0EHh+L/RT01vcaIied5Cv
	 mCIF4K7Bad2fg==
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
Date: Thu,  1 Jan 2026 23:13:41 +0100
Message-ID: <20260101221359.22298-17-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d6crb7ejsyoju7bxhqxd1t4dqq97y1wr
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 13A3140003
X-Rspam-User: 
X-HE-Tag: 1767305785-928238
X-HE-Meta: U2FsdGVkX1+o3BJbhGCogPWW+EE/8RizTyOf5xvh99Cs2bpc2V2pfnFsKfIRM0AW6sDshsBgGx6dyFb4nn9J94XnMqWW2v21jOG4sDgvfPVq4F8D5mogDq4+ZYTjNbNySpQiSkIZlLFZqG0V56S0SwTm2MyBZZS1tbQmaL7v07NzCmJ28KmBdcAK1PRE0JeAt1aDu+km20aYqnZtSCDZGA8h8AvH7Aj4n2N0pv1Bo5Z/zsClxE+U+Q0j/aLGWddn/bmDQwo6bAiP9OLan/H1Uga0PXzA4komlAzVg0yfC1nz1fEKwyg+q3ZIN9tzxfXfLnXQNBSJFVUhoI7XaFc3CobakdsbqQJFlXmLJ/LiiUBYFI6xbfbrNFEiQQsNW4DIcqLOraHCld9s0aPVpP1rhm2h8fnANNQ/U8Z0r3+fUfVR17BTeW1cl0yu2J4zIYcUwowinPEIlNF3IHIsGSn6k2B+3yqCB4Ufs0hKy5vJk6gc98l5CUQLecNKLjsmGNvNCGdxgWy8AMkmb8KCiBAKwW1Cor3I2BYFtsTi1oI+u+NkmM3Bcq96hFiCxM1tD5Hjw2wTPdQBALyXW5TWGxdYx28Ar0Sw/XPvnNCXZvt3vdTqOKzugTtL9PpVSYjGEnm6/8/oKYRTBLaSe2e5WHjNKIL4pEaOP6cCgZtb1IGs/c/OBBTJlow7mIm23gkpOZXzhsZmuwEoqHeSfnmuHEDu8ppV0OSDAVovwWDp6/48hNtdP0OktSHBoSM6cBFfOYtrlxrx5uT+IWZky8MXNeMQ4lx/DpGpKS9Fv+0godfTkYmK5bqXYTUJJQat1LGT4WrogbihF/XiGbIZQBPMF0CICrIEo8+TGyis6EYLuMqJxkKWSVT3TBsRgCR9EFm+Ncq0PivZOzRiuND/y5wa56I8vSLMcL+lBlD9G13++3hPjSxvG6ulep7bxUk30rSY15yLUXBOCXCQoy+j9EC+rJR
 3gpOKGzI
 Gap2Ok48UWdnEoMEyDUAOSGsof3zbT0e6R+hrOLM1QwceunoykWwREbCYax7Ret5cJfCd/Qa5rVhqFkZwHxZ0CrwV4SK12VI2gXjrvoDWtxEYnouzQSVm9s9vztYaTuItahHx/Ss4zRmfGPfYBtakIL+5U8f5eQPam587Cn2xqgrMNVdVekAlxBzsECBvEkIACPlPjTlw60/kn9ytgX2wyYYcBjY47n4KEjZ5nGSsXNXzlHubmJVPZOUiltUNRPKpx0d7AYeP7QDL8AnmA9HdRIEThTn+FjtkykQexhNRrh8Bhqk=
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
index b5f9f974eac9..ec3f15164fd1 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -143,6 +143,7 @@ int housekeeping_update(struct cpumask *isol_mask)
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


