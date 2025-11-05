Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8639FCCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E23DF8E0020; Wed,  5 Nov 2025 16:06:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD4558E0002; Wed,  5 Nov 2025 16:06:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB0F8E0020; Wed,  5 Nov 2025 16:06:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE89D8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:06:11 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8EBB5B9B19
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:11 +0000 (UTC)
X-FDA: 84077786142.17.ACE5CC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id DB7E5140012
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SGso82lX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376770; a=rsa-sha256;
	cv=none;
	b=rF8bUjJX0bJ4kZIzxtmG/OuoaZPh38BB2p2sRFNGLRDd3KfaRdvxqxIv/ob3X4wMUI5u6d
	KJr2PwvLkTXb0fv0wm4IhqfwirM1dWxa3gv0qRyJ26Uwq1Yr9m3x5tcrtXl5IGh0dEoZa3
	2zrxr0KuFaff9a5pnkdi+cMPTnSNgr4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SGso82lX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhLqpHatyJ6fDaYoQzh9fBWkagpTPCWByoHOr1ArFn8=;
	b=s72ZyepSo6D8enDewPAZRv9QtiyDn+oO9ewRMzNaYIVUMC0X8dzrf1LSspcQgMfrMljgRs
	4WN5YhuKhCyF9hMh6MVH1K98H+zFlN6QEaIGbFlGx9wPAbyzZSLMGDu9GV8tLW3ek46G4w
	VfF1k9yyFSh29tbN23cn0HBwTpAUjEI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BDF541906;
	Wed,  5 Nov 2025 21:06:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE3FEC4CEF5;
	Wed,  5 Nov 2025 21:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376768;
	bh=JiUppWP1p8g4DP4Hr+L5LcwYlcsK9hZTBPLusxTFDcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SGso82lXWej3gwCMVjG+In6OAuz+oWZIKHcl5zSkrOo3iOJGj80tY/uefIBDRdkJ9
	 zrvpNvHhAFFpeF34HITfKb6fyYMIuBhrTbWFnLXEVscW2zkZidtqpGCdGuvgz1JgjY
	 dCkPvfRBFOQi0T7YMFHxRMbRqMctTBLmDoh2rTETHdurAo9vyHfYVedSr5ZTErqIb3
	 G9wx0vk1arjCU5QIM6uwrwG8I1+mTTvOWMMauQjTmn9uCcP8xpqKqsMwOZdmr0Y4wb
	 84As7/sgKqt1XxVy0Y4Ch2VRL3o/Nsk+cJgGkS7By3pLZ5nSFzJWRuqKlFG9Y92CbU
	 syTh45q8Ls+Cg==
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
Subject: [PATCH 16/31] PCI: Flush PCI probe workqueue on cpuset isolated partition change
Date: Wed,  5 Nov 2025 22:03:32 +0100
Message-ID: <20251105210348.35256-17-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DB7E5140012
X-Stat-Signature: khypitdkywugjo6rkrhz9rwax8pdcbhy
X-HE-Tag: 1762376769-739635
X-HE-Meta: U2FsdGVkX18VGYFHEkb9r/pewSvNEVODYWXWR90hF8bH4o+TWer9AbVk1DsoXBjFjKyFx8Joqzmp03tjv6oafzV4vDNKkYh+b0drjlgkDDSwEIXaeVSFz5gJweqJ/5Cp7NaY0Rw4lXjPlb2UBdJUR1Pffhrme4ElMhma3vA8velWbrafEZ32GdYz9Q9VwL7FU7GHuIZi5C843hrwKz1BYUEcT6bzQyo+W41XbwlDYXt3x32PfBPBu6HsB+oAfq23va126qgcmM4FdfPLDIQP8p+PQ6o0eiw5d2onAtjX5ZSixoCi/N+YKkjG+oUaviFCX2/wjBDSUh+Rf5t4aHgDiSeNyO/IQfdVYIJn534If4SYVgTLp4rK35jL/LRRkF2II/07tBspXBqR+piGPkg1mIqmiaQSclEsZsvwufFD/h95s5fGtHujRSp59oXDM5sZMeJf9BMBdxWJ6q4eg0HpiQA13hgOA7sxqj+UMIDQpr1jkFEi+/TsOwdQHR0LEYc5f1GGxzj7VJUt35SsFhQdmBnemwMuALwNK8cvOZ8hw2W+WuOxav9va6AzwEzN8mOoFHKtfe0Y5QlpDDBDSCuoqa95eY70NBjyTu7S5+1OI8ZYEqoR5kIqc6CnsYRAY4J/sgP8NYav2G0C+n1YxG1XMNHjP1QcNffpMlxka4LQmQt72Fzty2eTyswrVJ89f0NVT4LgSizPBG6XCR4VJprb046AjJjX7GWHTind+ZzPmgyNA/NIFr0j9kCNAfyMX5ZhiVE23Hk3BigVddTPVgH8Q+fW+TsDRwBZPrHCO9HG7BHiKCqpcliCaTqTsk+KvJb8BRnCWikJ98jY6oCAg7eim6b7INfOeZ3XUgb2s6rckMraEV9QmHHa7RjHoeQfoWC55+XDCpB3p8gOpDMhsBNa9epSAz6BTsRV+4TS2m02zmyQWOJO0Yhu7sy/ZViRw1q1TPfgE48lnrPJEY86WWV
 KT4Y857m
 H+563A9JTGz5brh//AYS2/1cgrd/bBeuJ0kqmpYUG+l8iQIMWxExBYXgpazgt7ummrb4T+G2udlJVx/qJZXJc2KSk9745Hr7yZyFbF2AgXdhJQw5/sA521tIAt8kJ/QGrZVUXgf/DBAeFQgLHHG4ztCv4MjcQjus9sLp+/uh4xLH3jioDBFEmBH2eSOXfIHtlbAcC9wY4dEEPr01OjbvO5D5kRfpELSgKq8XNVtLxvbtGZpqyq8/yRN2xa4DseHVH6rD9klGDJoEBcZg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask is now modifiable at runtime. In
order to synchronize against PCI probe works and make sure that no
asynchronous probing is still pending or executing on a newly isolated
CPU, the housekeeping subsystem must flush the PCI probe works.

However the PCI probe works can't be flushed easily since they are
queued to the main per-CPU workqueue pool.

Solve this with creating a PCI probe-specific pool and provide and use
the appropriate flushing API.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/pci/pci-driver.c | 17 ++++++++++++++++-
 include/linux/pci.h      |  3 +++
 kernel/sched/isolation.c |  2 ++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 7b74d22b20f7..ac86aaec8bcf 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -337,6 +337,8 @@ static int local_pci_probe(struct drv_dev_and_id *ddi)
 	return 0;
 }
 
+static struct workqueue_struct *pci_probe_wq;
+
 struct pci_probe_arg {
 	struct drv_dev_and_id *ddi;
 	struct work_struct work;
@@ -407,7 +409,11 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 		cpu = cpumask_any_and(cpumask_of_node(node),
 				      wq_domain_mask);
 		if (cpu < nr_cpu_ids) {
-			schedule_work_on(cpu, &arg.work);
+			struct workqueue_struct *wq = pci_probe_wq;
+
+			if (WARN_ON_ONCE(!wq))
+				wq = system_percpu_wq;
+			queue_work_on(cpu, wq, &arg.work);
 			rcu_read_unlock();
 			flush_work(&arg.work);
 			error = arg.ret;
@@ -425,6 +431,11 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 	return error;
 }
 
+void pci_probe_flush_workqueue(void)
+{
+	flush_workqueue(pci_probe_wq);
+}
+
 /**
  * __pci_device_probe - check if a driver wants to claim a specific PCI device
  * @drv: driver to call to check if it wants the PCI device
@@ -1760,6 +1771,10 @@ static int __init pci_driver_init(void)
 {
 	int ret;
 
+	pci_probe_wq = alloc_workqueue("sync_wq", WQ_PERCPU, 0);
+	if (!pci_probe_wq)
+		return -ENOMEM;
+
 	ret = bus_register(&pci_bus_type);
 	if (ret)
 		return ret;
diff --git a/include/linux/pci.h b/include/linux/pci.h
index d1fdf81fbe1e..3281c235b895 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1175,6 +1175,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 				    struct pci_ops *ops, void *sysdata,
 				    struct list_head *resources);
 int pci_host_probe(struct pci_host_bridge *bridge);
+void pci_probe_flush_workqueue(void);
 int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
 int pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
 void pci_bus_release_busn_res(struct pci_bus *b);
@@ -2037,6 +2038,8 @@ static inline int pci_has_flag(int flag) { return 0; }
 _PCI_NOP_ALL(read, *)
 _PCI_NOP_ALL(write,)
 
+static inline void pci_probe_flush_workqueue(void) { }
+
 static inline struct pci_dev *pci_get_device(unsigned int vendor,
 					     unsigned int device,
 					     struct pci_dev *from)
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 8338c9259f4f..303cc3419ecb 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -8,6 +8,7 @@
  *
  */
 #include <linux/sched/isolation.h>
+#include <linux/pci.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -145,6 +146,7 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 
 	synchronize_rcu();
 
+	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
 
-- 
2.51.0


