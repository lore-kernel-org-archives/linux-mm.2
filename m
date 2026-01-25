Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E40D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:48:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 459396B00B0; Sun, 25 Jan 2026 17:48:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41AB36B00B2; Sun, 25 Jan 2026 17:48:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30F486B00B3; Sun, 25 Jan 2026 17:48:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 204EA6B00B0
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:48:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E5D0E1B0584
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:12 +0000 (UTC)
X-FDA: 84371976024.17.EE615F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C1B140002
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G2APndNk;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=byxRkx5/iZEejb/w/oGw8xYDdHNVovzTXWzeJy9GHbo=;
	b=urcsPPip9Prah2jLgJ+/ExxArqn+l7wAjr/EfuPMQ3eJm2BHhUCNrGlfRtB0sOvm2DQfQY
	82Jhf2TeonzxR9GCJJBvT475RWHIisMR/Oikk8/v6+9P9Ein9tOR8cX6VohjwFZhUFVbbh
	l84FMzhAneQgCAdJaLwhRio+ErCKwFg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=G2APndNk;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381291; a=rsa-sha256;
	cv=none;
	b=Jrus7roOfly1zfH2XtdMRPpQ6DuZAkJZQsUhS+Jyxwfw47yUiBLZxL9NbX8FX3HUedXrbz
	pZZA7/stnnHneOBfhjQ8qIfoVUGdofarowT16RTf5X68yjtDNhfgCiClAw2zgdJU7KdJ1r
	nbJL1HYDimPBZNH1KFUlmeKIny5Okc4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 040A7600CB;
	Sun, 25 Jan 2026 22:48:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC19DC2BC86;
	Sun, 25 Jan 2026 22:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381290;
	bh=P/TRTFNVIMdojDSgDr/B6FcyiyDRu4/UxmoQr5eq/JI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G2APndNkhF+7Cbi4hNCaRKrcZZnpnnKRyD+P6Kd1xncgafa1Vqtq1e621bxRTvlpy
	 7bWpJQ+0lRQVUTNcoc0xHeEC3i62H1u/Di6tzvOcBknSeqM2AUsAAQIEVNSPIUEFab
	 DT7XQsOc06AMIVnv3IJsKfv7SFCoLvg2Ov2noxSGG0/xrnkynkPNWMNuCyUbjwUUl7
	 dsJQu3nzVC4G+jSW/IUYlhc+5kC/2nws8QnslUTGCXh1cT6qzIt4aNDRT4rDSyaJrz
	 A7xP+s6ITlSLNgSc+vz9lpYZUrJHjBfJb+MBkCwjaQcRHrSm6rf4mFTCvDDjSXUw+l
	 izK1+zL33Of4A==
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
Subject: [PATCH 17/33] PCI: Flush PCI probe workqueue on cpuset isolated partition change
Date: Sun, 25 Jan 2026 23:45:24 +0100
Message-ID: <20260125224541.50226-18-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6C1B140002
X-Stat-Signature: pqw4s979wghnpoickiruhom78fhs7mze
X-Rspam-User: 
X-HE-Tag: 1769381291-594691
X-HE-Meta: U2FsdGVkX19OwLWwJDQRnLCN78NCiEbrg0P7bJGldkDfFv5mkQhwV6N+roORID2ZsVqsEy0jngqIGsvs1gHUhSJwRKuryovPEv73fYXVqHORpqM7STkyWzfVk4F3lTx5uB7tFz09GLzieTBlTAZQkE2gsBMpnvVFsOP67YJuAWHCWYfKxlkGzp/ElrPLR+tpM1GFAAvEqjucRiKN8f7b92FOCZQuHrUsCvnOL/6pJf5Zjb2QRmjV8MRAQNP276qPSsRoq5fPaw32JCtOaTXL97dDebnHgwd60g7/oePcV29g3qqhNGJtW+CkUyp86m7TAKTSjN2ApDRWSWVBNPnuRjE4rQILl31aAKUIYzk8NGwaZ346MtIFGvIsI4gfIPaca/HwN2muKJm480nfdjwqWZWD6CbxJW2Hx1iugMPiO5qRManGHSIhLSJGMnGPAzLTeIotfPOIZvE3LXSz3e88aZc4VBR44XZOxuSDUL/9UJM0uvWpJlL0KokPDMkmxt95f0rKb9iOVGpc+Gcjo8egtMV8i6vYa24hFGVvsTbvVQD2z7G+OKWjuAFH8+rydruSjFXa6f8os8pum+ZX/CJ7OYT1UN0G9rsjZNp1ysLby/xq3zz8in04UJyw0eMWe8cS7M6/eY95zoUfy9AdXrFSwlsk/xJHoWQPVrPWf4F0bM0G/trsT5NPUkmwNO5lPzBWiriFGQN25PzHw8lO3YzxOFA1XcVGPHGOibb9KOiq1vVOA0WPMUMGMbC5nWWo8cE/yiMP0xXsQ+ligE1m9N2gqUZmqfG5jXZmdqw2TyJVgj2P2eO15o5k95oBFnpvBj2yAtJQ0nB71lA/WccNzwg9x6rVHb0EHAHALF6rHl5vLrOg50LcAulullLjJJFwzcC3MH005OsMDkuL5e31zp44+IrsApH+yTg87NFnE45sbRRd20261FuPNcwS5gCLcqV8Sy4s7Se8hGbH/3GH5UB
 OdCD5Qcg
 zad6E/kBhDLFraAHmFFVnupPlLfGy4OxPre+YL9ybl/Y62W+X87aGXeNK9mVd9hXAy4vwDrs/MRn6cRL4GzDToL0n45bYCqI9AK/uCed4osikAcaHE0Hu4x3Oe5OUOicyEtjHcLfIK/rsZ5WK4ygoDc0QkBEl58MtlISjbzWFff4uL8KEUsNU5BJbxeavPKmKpuvGj6jm0RXCtpfqc40GiHq09miZltw4cBAVeJ4bB1YFAB+PxaSkqBRy4c1VAUE37Yb3RRVv62YSqerWnw12b485oC0F97rS39oI
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
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci-driver.c | 17 ++++++++++++++++-
 include/linux/pci.h      |  3 +++
 kernel/sched/isolation.c |  2 ++
 3 files changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index a6111140755c..b902d8adf9a5 100644
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
@@ -1762,6 +1773,10 @@ static int __init pci_driver_init(void)
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
index 864775651c6f..f14f467e50de 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -1206,6 +1206,7 @@ struct pci_bus *pci_create_root_bus(struct device *parent, int bus,
 				    struct pci_ops *ops, void *sysdata,
 				    struct list_head *resources);
 int pci_host_probe(struct pci_host_bridge *bridge);
+void pci_probe_flush_workqueue(void);
 int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int busmax);
 int pci_bus_update_busn_res_end(struct pci_bus *b, int busmax);
 void pci_bus_release_busn_res(struct pci_bus *b);
@@ -2079,6 +2080,8 @@ static inline int pci_has_flag(int flag) { return 0; }
 _PCI_NOP_ALL(read, *)
 _PCI_NOP_ALL(write,)
 
+static inline void pci_probe_flush_workqueue(void) { }
+
 static inline struct pci_dev *pci_get_device(unsigned int vendor,
 					     unsigned int device,
 					     struct pci_dev *from)
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 160b3fcab209..1e4c3154b0a4 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -8,6 +8,7 @@
  *
  */
 #include <linux/sched/isolation.h>
+#include <linux/pci.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -144,6 +145,7 @@ int housekeeping_update(struct cpumask *isol_mask)
 
 	synchronize_rcu();
 
+	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
 
-- 
2.51.1


