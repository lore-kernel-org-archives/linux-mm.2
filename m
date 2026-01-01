Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92242EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:14:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF9A86B0089; Thu,  1 Jan 2026 17:14:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3AF6B008A; Thu,  1 Jan 2026 17:14:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0BD6B008C; Thu,  1 Jan 2026 17:14:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D1E256B0089
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:14:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 574B31A175D
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:23 +0000 (UTC)
X-FDA: 84284799606.14.50FD54D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9999F40008
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:14:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/h534ng";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305661; a=rsa-sha256;
	cv=none;
	b=vcGSKzmjBrvKKTDZTe2hMxMfOUtcYm36wUnnt/NKp7vsGKDodBPuz3iaaNM1X7y2GxFEqQ
	YP1BcTG6uV770SEG1xtFzGTdenB6504EqbzCkN5D514UISk3rQAn4tS3kHt8II4mK3st1n
	oneGwCEqFbhsTUPeDiQYaH5CuXD4PfY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="M/h534ng";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sd5Pe/j4YMbvcFt56WBhBMfvieVBJr5Tur9plHdPMOc=;
	b=PNPIGMD5UrqxUyDWxvrVQLjZ0MGPO/HUwdM0qeqHLtRemUS2v+vpYe5U5uPGWda1EwdyKP
	rJVbJFpZH4y7N+qqdbautpeM7UFV26LW2JOFPS+qgzd2oE7FiyApJ31F99xiRmjFRnivpD
	f1OFTjc5GxUJJ9A3wMh9qPCDWYL9zH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD4254443B;
	Thu,  1 Jan 2026 22:14:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA78FC116D0;
	Thu,  1 Jan 2026 22:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305660;
	bh=geZF3QKFtYPcfbMIoxTZal+ERqEQTyvZvD0QQardL9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M/h534ngFuoRJjvdoJJs2OZzukd06FtL2b5SAxHmZGEKCcB5XuVr8mfuQGjBLJsFV
	 Y/7VKrO44T9eNaMva+lwmWkTy479Lcrcv/2HGBDUj4lTItky5lI+2cgRYQ/VLzdBca
	 Cy68hBnhExv7MBlWAh93Lxqo1XjRIj64jory4FE81jhU38SrAXzzpnThpMIqZzhFLl
	 kvr/0tx7QmlEf0cYDudigYL2RH06h8zTlBiTPPP2SoA1qoLDHZH+zDUgUWXnLtJuLB
	 Y7Ov4x5UmpafKNXoKqSDA4oQtkfIIA1x++LXWUXeQ1k8TS+JP8ZLl4zLeLyXhVYRVW
	 4UJvD8KxVhjqA==
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
Subject: [PATCH 01/33] PCI: Prepare to protect against concurrent isolated cpuset change
Date: Thu,  1 Jan 2026 23:13:26 +0100
Message-ID: <20260101221359.22298-2-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9999F40008
X-Stat-Signature: xhm7es1igc7ct3dfh4woztjxss15yany
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1767305661-425304
X-HE-Meta: U2FsdGVkX1/2Jx9rBcT/8UF9X8fdjf/5k64aqi7XeiHEEoUCacOgKfIPbhli5qk2OhPl95xred6vl/i+HUuru/oM8GZV8rfZayjSA5GCloOx5WYcZ6l/ffd9TAYULhHKlHr2hc3YEPpE4FQi38rPZIhRuFpd/AZwaX2cDgvl8xR/l/0Ubv6YyPcVGTWEADEvBy6qcwJdbn1fO+U/e+sieDeTxiEaQs6viYnQEyUqX6ZRnrLGoSKnOrvG3j6glfOCHBCia19M/GeOOsHNjL3k5X0Ub1N2OnDeHdxJ6i4rQFKjcLsVGz1egNrqzNe1Cf9qNkh/wQSszUOvPc8cZ0tbUHv55cLZA+b/QCzq64Siey1PgNGQwIkHAon5YRyitWUVW2d4QnUZKojSCg5XaFW71klSYihMxQYDmS9qSxa8p/8CZAVZnB6c5mzR9swhF9vyyjc17hQWqmx+sHO3ANDSYfzDwdOBxFpRvjUQCdtBritSVUCZAN9Aez8PORKm/F44t7BpY02lOTMoXU4ysVB87hc9YIrOGsoARQa1fsIMl1VGYWMkLtbNSmol3m5GILsl1RUfnx4eB6GymSGs9bN9s+8tVnvNKBmR91QHX8EN/3xr139ISKl4GCIjWPeq2+qd3LZV61simSnJBNIj9adCijX4vdf65tbubxB+f2ZWWGgcC55KA1gKibpVQ7X5sC2fdYkLVWq7nS42gSkh6L1lnolrgCBNL/s8Z0gBHvPsw3ICb1AOF4AZDJW06JqyPllPmfCuViMHXTyZrquboMGgBkgs50barODL6ZABvPO5b15uw/DxUNgKHUOx+sQUkdOX+GMjNMEEN0kY7IjSrS1x+cGeDLzVmylkncK4v+MZ/9DEUbcSKuFNr/3utQSke2SS8fmC3K25ISILJkXF2/FL7flUgfJWQsDlRjKCx7MvYE+wm3Qkm0EdQBK5LfGGUuNyb4ElG0LvknC2OFP5f+P
 Gum3B2km
 eDAVq4pG2hfrzCfcU7LWc7VO1sVY48AsPAvhzutJ7KNbCRBwERXuwl3KRbw3mgb3QAFyz7PzXEAaNWQ4Mgu1IAlGXdGVfucHB5TBWs5PMfOK3+trqrphkJAynIm/crDEsXSc1QvXWn+XBkspSUnPw2shkYdax9XOOeoMIZhnLDS3eN3JyhSMUIful+x50OeUekPLP1Gt/NmyxXGE8ObqT06/FTcsa+C1uUd2nRR83hbGmGSc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
therefore be made modifiable at runtime. Synchronize against the cpumask
update using RCU.

The RCU locked section includes both the housekeeping CPU target
election for the PCI probe work and the work enqueue.

This way the housekeeping update side will simply need to flush the
pending related works after updating the housekeeping mask in order to
make sure that no PCI work ever executes on an isolated CPU. This part
will be handled in a subsequent patch.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/pci/pci-driver.c | 47 ++++++++++++++++++++++++++++++++--------
 1 file changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 7c2d9d596258..a6111140755c 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -302,9 +302,8 @@ struct drv_dev_and_id {
 	const struct pci_device_id *id;
 };
 
-static long local_pci_probe(void *_ddi)
+static int local_pci_probe(struct drv_dev_and_id *ddi)
 {
-	struct drv_dev_and_id *ddi = _ddi;
 	struct pci_dev *pci_dev = ddi->dev;
 	struct pci_driver *pci_drv = ddi->drv;
 	struct device *dev = &pci_dev->dev;
@@ -338,6 +337,19 @@ static long local_pci_probe(void *_ddi)
 	return 0;
 }
 
+struct pci_probe_arg {
+	struct drv_dev_and_id *ddi;
+	struct work_struct work;
+	int ret;
+};
+
+static void local_pci_probe_callback(struct work_struct *work)
+{
+	struct pci_probe_arg *arg = container_of(work, struct pci_probe_arg, work);
+
+	arg->ret = local_pci_probe(arg->ddi);
+}
+
 static bool pci_physfn_is_probed(struct pci_dev *dev)
 {
 #ifdef CONFIG_PCI_IOV
@@ -362,34 +374,51 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 	dev->is_probed = 1;
 
 	cpu_hotplug_disable();
-
 	/*
 	 * Prevent nesting work_on_cpu() for the case where a Virtual Function
 	 * device is probed from work_on_cpu() of the Physical device.
 	 */
 	if (node < 0 || node >= MAX_NUMNODES || !node_online(node) ||
 	    pci_physfn_is_probed(dev)) {
-		cpu = nr_cpu_ids;
+		error = local_pci_probe(&ddi);
 	} else {
 		cpumask_var_t wq_domain_mask;
+		struct pci_probe_arg arg = { .ddi = &ddi };
 
 		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
 			error = -ENOMEM;
 			goto out;
 		}
+
+		INIT_WORK_ONSTACK(&arg.work, local_pci_probe_callback);
+
+		/*
+		 * The target election and the enqueue of the work must be within
+		 * the same RCU read side section so that when the workqueue pool
+		 * is flushed after a housekeeping cpumask update, further readers
+		 * are guaranteed to queue the probing work to the appropriate
+		 * targets.
+		 */
+		rcu_read_lock();
 		cpumask_and(wq_domain_mask,
 			    housekeeping_cpumask(HK_TYPE_WQ),
 			    housekeeping_cpumask(HK_TYPE_DOMAIN));
 
 		cpu = cpumask_any_and(cpumask_of_node(node),
 				      wq_domain_mask);
+		if (cpu < nr_cpu_ids) {
+			schedule_work_on(cpu, &arg.work);
+			rcu_read_unlock();
+			flush_work(&arg.work);
+			error = arg.ret;
+		} else {
+			rcu_read_unlock();
+			error = local_pci_probe(&ddi);
+		}
+
 		free_cpumask_var(wq_domain_mask);
+		destroy_work_on_stack(&arg.work);
 	}
-
-	if (cpu < nr_cpu_ids)
-		error = work_on_cpu(cpu, local_pci_probe, &ddi);
-	else
-		error = local_pci_probe(&ddi);
 out:
 	dev->is_probed = 0;
 	cpu_hotplug_enable();
-- 
2.51.1


