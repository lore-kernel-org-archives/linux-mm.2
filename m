Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EA6BE63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E64A86B00AF; Sun, 25 Jan 2026 17:48:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E9A6B00B0; Sun, 25 Jan 2026 17:48:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D79076B00B1; Sun, 25 Jan 2026 17:48:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C116B6B00AF
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:48:04 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 99CC41A02C5
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:04 +0000 (UTC)
X-FDA: 84371975688.05.824CB54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1B395180005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AvvAZEyE;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSDhdQdHZiUEaR1V14KPz4ZuXl8eOsN+J/GicpMk1E0=;
	b=4ejXiJ5oWky7s4gQHa3zZ7Lvz4SdhmWy+Sh6STomNMzGsm2gHmvZWKvnFUBiLO7NPD161x
	SxDtwGKRIgFS5eK+5MC4KeYpriWoJBQH1SZwqCspEKmJhiflrQJJTMtVytKjzuNrg6nlY4
	IjN7y/b1o+uQdB7eb7hzT0NK+01rnlQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AvvAZEyE;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381283; a=rsa-sha256;
	cv=none;
	b=8Pz23P9uuUOdWAZwqagNU9SWJOUpRqZonUXJGz37c0tlWbk4/HbjkIQRBYFTgPIvdrXcfq
	olt7+AZMuf1NCNziKmhUoLe6c9mEBSd38TtqNO+mOfDLfLEQ8Gs2nuBs0BuCcKMvW7GLqH
	E1gQiazWv7o6OYk5NBmXSKlquqyG8hQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E827600CB;
	Sun, 25 Jan 2026 22:48:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0DEC16AAE;
	Sun, 25 Jan 2026 22:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381282;
	bh=FCpWtWiXviPK0JfRDl7l6gUIkKLhd7cslD/kQrH3RoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AvvAZEyEtKaCfqe5rzGN+Pe7C6GMyaY0JllgN4JVMYWGnLlNJNMdrE82nXGnwhGuM
	 ig2aZgk1vOhsGKD2pYrRPiiWKmtUfAKadlZRhaB1yrmh3eS7VR2seQ+xqGKuFuHfSR
	 Xe3L01V3/QzIUf8hJqhxfK9DybKbaI+P+ICudgL1O9w944OVckhr3wBFBAGPdKXFW+
	 53ZA6GDuvwES6ssJ+Rq8iWRon/KwIXxTepltZWSJLs9qqxHWwXCSZ8iJQdkGLBwt87
	 tcu6mPw9TRNqDDyUxf0NxLM88mYLKgvwTbBktZFTFcjcJU3VVNLG8MOcbxDic9KV7e
	 JLkSJiy8P+F6A==
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
Date: Sun, 25 Jan 2026 23:45:23 +0100
Message-ID: <20260125224541.50226-17-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 6cifmfyoc96gw37i7knj37cp4j3ehzti
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B395180005
X-HE-Tag: 1769381282-100652
X-HE-Meta: U2FsdGVkX18ONteVILUwQl1Kq3rbZ9l+S5XmGJu28/t9wMtZ9UqJXAWt9x/cL/AXU46MnaaGBOBT+GTQFrR+w0BNQT1uYVbGW1XJ9MoagBshWU/oqAS8Z2+YfcdcMVUyDnLS/b6TJ9eGF/Pi6SRiePLzxjm6bQGFSPOex4Yur7eI6XQJpPMMZIKMcpvMbdzbGso1Yw7ELUD+0JZ3Vl5SmKoA2pZcvhqBcjhBi3UHQWeHgQO5rudATFFuDv1VrH0zjp2xcJJATcWDo4648vCZz2Bb8gSTrqypIKOyFnnexRx/kASNgoxxwqn3C4fA1yW70En+un9SIw4z+rfG/GJjmU/c9kY3dJyq2G8dn8XFt5PMwsJh+g2u9KNX8d+M7iPEkyh+6w5uahEfD5Xzb2EghbiYBPwmTUoXTloMCGsNo5vbskaHV/TCwnJRsVHKZSozJ9TA25SrEeXm5mHeSYibO0bRmh+vG63NTQ1hTCXz8xf9A1lBwOnmw2r0HdEcjZykKAFaNdKFfQ2sNMfvwD/8Vc/R9a36cJxU+J8DR1qySJWFA+jAExAU240qhte2qEkyFn80oh00kR3pcFhmCTC+Kmla2JH2eLFVPDq097J9oxr+vHVbDhgeZmBXNRuydkId/B3vibmJR+qcu/1Ko4eO0uNS1EIU8zzvYUMJIYujjydleVDwzQh/PS7tRI4nYCZgDh8HFJjmEHCZ33jIrHShEOY9xOH737qmncnONJQQBdQTv0V9CWXI7cDnjxYIGXIOl1TxA0agruoCkRV/4Z0WLC5LntfxgaThQv8N9gvj2SPp7kT4wFtpyO8jgKNQz7mUiG0icDMBEojzeBa6LrFx4KoXDg8t3teTi7T9F7QikAOkY4b+Ho1Y2sowjxEiFXBuy0q9uByhCeSfoC6Ocegzkh7TYIzFFLm1xw1dOkIm9BSv9HeuxltzcS3F579xS0XSTXk8VYinV4NbuZZnHX1
 JCvUFnE6
 Czzu45XFv7KmR7N2AnyJQf94NtywbBQ0Vlgqch2G66TvT6+mxsHgpHOFEw/MdBU+R17M/Vx1rM43v9CpCEc37HQXH2KOHn1K78uYdHicV5mVNpdsx4XpcweKf3+oyMLv6FZa2/FOFLFYsbJ1jYG2cCCv8u0+q8Os3PscefzVjdUgz2O+FUdsIbd8u2pWzFrC2E3QqMTvM+aLf2Dr2r388mVyMzWNFSlN6OsyA9Qj21HlwAGnxQNBOCrvLu9kJUkzp6PTfVFKwkqRlsbK+jQmwQlo0oVgdEy8M1KykWKZLh0MpJHS2fwzvAToAvQ==
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
index f4053ebf4027..160b3fcab209 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -145,6 +145,7 @@ int housekeeping_update(struct cpumask *isol_mask)
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


