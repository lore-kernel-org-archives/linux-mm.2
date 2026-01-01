Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A236EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:16:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC9DE6B00B1; Thu,  1 Jan 2026 17:16:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A796B00B3; Thu,  1 Jan 2026 17:16:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CA86B00B4; Thu,  1 Jan 2026 17:16:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7BFC6B00B1
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:16:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B9D5C90FCE
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:35 +0000 (UTC)
X-FDA: 84284805150.07.5C82D78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2B66D140008
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u9tYFxpS;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305794; a=rsa-sha256;
	cv=none;
	b=XZk756doBRWh9rAni90DrAV5K1GleVpLrgSmZTrDhnssQt4fsgaPYKk/uc30FI1KZ/DPb5
	vwKnUYbJjslE+I/aJAvtPNkv7AFCEdgpcyRNTfx0iVBqf+ly7cwGlF5Yf2Axp1/OuKyLsB
	NRBjQxFcBhCBuskk0CyWW0O7hKPc578=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=u9tYFxpS;
	spf=pass (imf26.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=34qjHFuHyPtfXE5Ixbu5nLyOeRZu251qvy4DC8y6FNY=;
	b=7MC1rLR8eCNdehfMwsZCW9k140Bbj/SdhXRjdEZw6ZJzvadvTdRSwv+0NH7rrFtBPK6IIy
	5+lSxItnG7wTGqG3qHmxr5bvPxXi6IungSc3DFggutrlrv3v5jerUiKuHSY7ZG+Cg7lLxT
	uAhOIOSTVvNdXhWHY81DNJE0/vKXcNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ACF8B60017;
	Thu,  1 Jan 2026 22:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7D5FC4CEF7;
	Thu,  1 Jan 2026 22:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305793;
	bh=zo5aSfx0QMPboEF9rtQzkEKHHU4qfSe8IulGuelb3CM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9tYFxpSYf2EKg3LeJ/BtkTuCPU9/7dT78WisN7MsccYOL1QHOblp04XVLBMNEwNj
	 Mh8U2spUyrhiJe8m5+VHU3f7oIGLsOOKSSXslxXcFB4f/pba3lwajZoONzqVrh7gdf
	 YOspVtG+Metqa5k6ARTlWvkA6QJveUHG5hrI8G0JOKUikcHidi2E+ApPG0Qqnv8lpU
	 ZQ82Zy4ZdHegSVFS8OXE0/OnFJWOKXtOCm1E2dFG2HpUqlPP9hNAcl5tLwu7A3XWtS
	 boXzsWts9BMQaOG9OW8FSoOnj5eMdWd1TOkunLzcfZisfxU/6M8mavVCFQLbVzucKF
	 5aYSZvL5g4iJQ==
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
Date: Thu,  1 Jan 2026 23:13:42 +0100
Message-ID: <20260101221359.22298-18-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2B66D140008
X-Rspamd-Server: rspam04
X-Stat-Signature: dcnjneaxzq6i7k3sw6fxdni9xhe8f4jj
X-HE-Tag: 1767305794-11039
X-HE-Meta: U2FsdGVkX18VhIQEM7V0vnwnKgO84UnJcjzRlnksfkB7apSmKJ/JKABYjnvKNGR81WvtJTN4vQpezxCAXyk+5y/7DLlw7Zwif87hTXBINnNuLii3uVkn5fsfHfMZiWuROLezaVlLkVCT5G9dNQ74gh6/VefiFNXzxgv34fw2Xz0UaXfuiW7M3vwCmS9sqv1rFfXtwETNcf9b4125SHtJuHPw03PhGX7fGdlaQmCTxw5n30rvBpF+8JbbzzWeppiMDnZw5qcwoxyQAZWw48Ifhm4jljDCQhVEMR7gPlFiYlvOEnIMP96K9ZyDbRIeiQOxL+txiVazMO+VwOCwztr7CUkqkIrVefxPMABx4Nyc8oPVcOdqNKnMIACxfiK2XPzt7HwaovULzaY6GST4m1JMKnfI+T91qPlBfEts6c+/AHjLvjVT8c2+0ber3LfJl5DWsmmaf2z1aB3J0Gphkr0SUsV/WZccPE84r0ilw0O30FF7wFw9/vX1uzhtIOiLI3laNPxa3YH/wkScNjBluAXBjncAqxE+EFuCMA60t2o2izJVixP3mQOROrVa1F9SdqijNfyyMQjsk0tCdeKHgY028M29GHMbmYAMoaAzpxHkOv4tAzXCNnX3ReflaH0ummUrAQjlXggyKok5hMN4zAu5LO93ab9cU6nbUGyFTblo+iSnk7qUB78k2c0NwQS4Z5jlgDZXBTCuFOAU/ghd0QaKcfDL+7d0cEz1EoQgZPG1mKfWuavgjhWGa9J8GXPW4i9GWl2uqageNL+0yv8HttRnuhpMjgUtSlE8QfFd1pApQBxXVzNc1uipu0E06mRwCfbYDSh1br/tIhtPrjH5TAmk9FBCieMOfQrJ2pe3uFRbc+z07+z7x7sFrOp9radApGnyULVqbtHQ/gYj6lWSqr/FkeD/M8yFf9x/IVCMnDztOkn8Ox2rsQ1BzRrV5Gt28oIcXG+3fDDpeWtzHmC/aa6
 a2rGqvB4
 MwMpF/mqrljhEZBh+qbcW1BWPyahTMpys62R+15iN2hxt7vwabGC/pXK3E+xAnTBJhOfY+E0NL32hPPregtVEOGZRyjhVU8nCvuq0JcnVsZtQxnbXqgo/mdaqUcsLPDzVl5vApyrjf66EUkpJ7VS2q6igaaoNjYIPKArBjpqQi6PvaCSgvlMtPHuAkkRyMtL3LZz2mlFBZs9dokG2AJbkO4C+K3B5pbg2aoLsgvpqxISdZNXjzs5f3b0HhqHnGt6cwz24s7tp/ZfLDQ4=
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
index ec3f15164fd1..5239f556745d 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -8,6 +8,7 @@
  *
  */
 #include <linux/sched/isolation.h>
+#include <linux/pci.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -142,6 +143,7 @@ int housekeeping_update(struct cpumask *isol_mask)
 
 	synchronize_rcu();
 
+	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
 
-- 
2.51.1


