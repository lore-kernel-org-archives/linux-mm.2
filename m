Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DA45CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CF958E007A; Mon, 13 Oct 2025 16:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780178E0036; Mon, 13 Oct 2025 16:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 696068E007A; Mon, 13 Oct 2025 16:34:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56C1F8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:34:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E6C58828D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:00 +0000 (UTC)
X-FDA: 83994242640.10.4129B3B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 66B5A1C000B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:33:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fmNLj/57";
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387638; a=rsa-sha256;
	cv=none;
	b=oD6Dc8i+YH+PEp+U+sz9rNHaNxOuQuhtSdIloqFNRFoikYeTP/cFCvBvCLUXn2G/+FDry0
	jKXQ+yQj/Ewhe7QYhH2olvHIZ/7jhE6nT5DNXEIR+iKbg+JJis7DpFgUfSTu2objfm0MQ1
	8Z7FUEAu2rAk1HQ9chMf9dQFVgRo/sA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fmNLj/57";
	spf=pass (imf18.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bdEjg9wPrgLqJSxLqjGLDyhx+Aa6qpcGMk6j7KzI2wo=;
	b=64uX8cK5tNI3C7xWGYE5HZ/T619Fsj5P+zohRDRFgZTb0r3afeoslZJ2uXdQjiPk3RFtq8
	cajtTBrcly4sI9b3QcWiXRXxz6zNbZ2zW9VpsIEdVgvEUARv2+XKCPOP2WkjZSwjej9bnJ
	OQMe+ByUVU3PJCYoFJ2elbgcTn2HGF4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E73048BBD;
	Mon, 13 Oct 2025 20:33:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A27C4CEF8;
	Mon, 13 Oct 2025 20:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387637;
	bh=9w9KiM/XU5k7xFjzwkTNeoZAiAzOP0fQ9W37e2QyvME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmNLj/575P8R9C/Tos8QKO8qINbfYPqKweF8y9NhDYbJaZ+5jadfKFAc+rLxgfUup
	 dUukeeCFad56TOrldk6Pyv5FB7Yib5oAFO6Oh+GpsoH5YTMif3zLX9QI3nrys+9Qxu
	 YI6y7FSDOQhvhl/BwxSZQGkjCvTwSoxUK9shUsKldgjOfh/6u/XmAYh/vLJa/pm+ad
	 +M/kiyWLN2KLfgpcqgBOzNf6g2Jz30nfxJo6oZKx2ju0jpStVAdF+RHNcTBckgDvg/
	 NJOw2T6qEqqICHSulF65mxm17kqfi/WfNxN+jo8ytmR8ZcpKkI/8i0v1+N8PdJ3EVO
	 Z/RzqZx4g8l7Q==
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
Subject: [PATCH 15/33] sched/isolation: Flush vmstat workqueues on cpuset isolated partition change
Date: Mon, 13 Oct 2025 22:31:28 +0200
Message-ID: <20251013203146.10162-16-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nod4yt5kgpq4k7kfz7z69jb5nscbc4zf
X-Rspamd-Queue-Id: 66B5A1C000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1760387638-603821
X-HE-Meta: U2FsdGVkX1/1w95C3iSks01ptqUqvIMArHDi0tpmj4iO8lvCEgBPUprKunponKUy7EwPO/64z3YQYa1PpkewOJkLLPwXQ7f3t/KXqbRPOkrEK5HCDIeaEDCzMimZmmMKoOvllTysaeYBvXMAgU7wRtfucEO6lAR6n8HUiLerZkD9twNz8xFNWcJWD7qbs1mfYGntDr8NZd3a64shUMZ+9gWCa513PFfDjBqwpSwuM8hwnNQXSGi/MW1kWItoNXMY4Bea5HT5sXptQls02MobBGbG/NRK2WYAcYaApzOfsaSqASB05PYKujIT0TjbggJoL8NgIY6qQCjsjZdIRKjxYOULioqPuNDY+R/qFYcXhuEX8jWeRTmlE6y+S/MylGV+tlrCkFZJZvUA86JBWSRPw7viU1HzbzYtnA/D/ELtp6yQJyHbruWmJ1P3hA90vVrjFWXpNvKwPQ0QhzWfIIrvC1BZrmpmf0mfWBLeYQHxOe317QAULW6bBH8HRRWH/fOfNA91fLgbVJ9c+QYJ6Rhs6vS/8W5IZ8+CR80PRNAvvD9emxfwcrsm+QagN2C/lLaxzhnsshKOqm5pAKrgA37S+C4bVojXBMHTn+2/NSv6ZYodNy7XrE16KupTHJLOBSnwFC+vW1V6/BEuLUkl6+dqOv9UlaT/o3/JXtJkFI7tbExYar881p26rKc65TYkuUMzzD+gEKVFCAgkTA2KaO7+P3+5teKR9aqDzXUrTWWSfD1CqzWRjhx6VxbH47uUNbYLRCD4Eby6F7vMElPRdj/H9Eud2pTayOk0hfxFY3endjWzm4J+r5H5hhMSU9q2YDtphj7tKtN31rww7BIfW7Iz3dAviOI+5iLQesIWIIx0Pdfjble3n6oLKfa9uJ8ucWkoOpetsBlyAGbJ8X8N7f5Q//wbYTpV124FKCsZYwTyBog8QHRjpg6+B8fWfd1TpxvvuplrK2mVbIk2maL5HkW
 W5SDRpHF
 sbcsuKsABkqDFiaLJrSpQRMVv0wL5Bqs36otmKLAKNBgetECg8GZ+iAEnv4hFWDXXcnriDRXWOf6P5A8vR5G44J8B6kXG2BFOuZQy9lHzdbnB8RQSNspwKo4gMaBIusSdyzEQunb6O+9enSujy1CqcFX0fyQCdSGqxWTuD5VVerOwqfDLYNjldmyLg30WcQU2CNc1Q1221TZMyhcbPr630PIySxhPfufvkdjI9YMhihh4E8XddIYunuytxU8X7v1IfG5jpxxo7+/vRve7mcSHPQZ5b/zAZKICtIYRhblmaaKzoh4=
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
index 9ec365dea921..5cd3d98a2663 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -145,6 +145,7 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 	synchronize_rcu();
 
 	mem_cgroup_flush_workqueue();
+	vmstat_flush_workqueue();
 
 	kfree(old);
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 8bfc0b4b133f..84525885a3de 100644
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
index 7afb2981501f..506d3ca2e47f 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2115,6 +2115,11 @@ static void vmstat_shepherd(struct work_struct *w);
 
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


