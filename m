Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7218BCCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:34:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C63628E007B; Mon, 13 Oct 2025 16:34:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C13A88E0036; Mon, 13 Oct 2025 16:34:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADBFA8E007B; Mon, 13 Oct 2025 16:34:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 992C78E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:34:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5DA7BC060F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:07 +0000 (UTC)
X-FDA: 83994242934.21.AB4CF32
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id A2B7880010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eoVNEAS3;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=10keMiS8qwnTJkswuq5i4SwbI1paFXAodwClvCrPA30=;
	b=CC4pFTEupyc3t8xUxPYZwuLeX1KQC6fgvQAqnoxFeCnuSSaMt61NtxBguTVP2xHI7NwDUD
	evSxRYRJuaxJTLio2D7sycifpCOa+tCrfxFPewF2jlduxLEQr+hfsoCgLYmcYN34JYnp7j
	LUoE1/sxjnilx3HXbWyDN0fdoSRbxqc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eoVNEAS3;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387645; a=rsa-sha256;
	cv=none;
	b=bVOYxwoInEbnpkO+Pk2Ws3ohVtgCJlvJdQ2WXIpCXRMJbSslZj++t+lEOViJ1ny+318oK6
	9nhqmbsuIL22MO17cHM1wTWp93X6eUKY2OzjrDSTP66iy6GBJyypuySsCPv8mwZ82CRL5B
	ECMmLNdESksf9L/QW5+cieNrH+5rv6E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1FC6447F8;
	Mon, 13 Oct 2025 20:34:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5955C4CEE7;
	Mon, 13 Oct 2025 20:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387644;
	bh=o4l8LMgsNHHUM0/Jh25qtae1vINpxJpXhs+PkYrtNTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eoVNEAS36xD6hmGovDKl25N4XYXfuPH2mDvvfnGysV1HjcwGw8klL7ELr4gHa81GU
	 5r3u1sWGdjELbWd/dSeEHPlmW4+wuJ2Xs4UNSPWB8nTwmCVQaUJtXrgDz/nB0freXe
	 3tpJriXdtKqbtfZxu7/80lv84G7u7HAI/nuyfaZkxi80aS8Jn8PJ+gVwnJ3m3HmF8C
	 a6caYiVSvhke0XynsLWLdBi13Ff5LnBt6d6uWQPq3Qm6SXeBj1zvodrY1RXWAsliv9
	 oji1ZvDSMzmdYgwWlFmdnniAxIBWP4O0FhcoWE7F5am7FqRTXpqti2+Oo6hCrtF592
	 x+z4QIWYfrLHQ==
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
Subject: [PATCH 16/33] PCI: Flush PCI probe workqueue on cpuset isolated partition change
Date: Mon, 13 Oct 2025 22:31:29 +0200
Message-ID: <20251013203146.10162-17-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rtrzufwz3nttj57zztmp1mjtydhr5gqz
X-Rspamd-Queue-Id: A2B7880010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760387645-727861
X-HE-Meta: U2FsdGVkX1/3BQxFpclM9QNeeaMvmuuHBx091yFl8yCtoES98QoZE4E+pO1GUrqjz+HXUqKfd1wTl5rH4E1JQ8JyrGSuEeFHTjZ6vbC0ELm4fGrYBMuO/PCG+RRKEzKDiH3x0IO5bWXPQqTmFWknfm4G+On46B4QEmNumTr8e2qXrQyepkUI0yYiyByullT9jGSq3uyfNdPiGoDWDdagipPy2SuRuPju0zC8YfFBeMUFUDb2YQW/7PpBgFG8E63junCnhhgY6PlEBWvc9oLGWfE0t0+1mxJVgWIoQ3RLbiTENRTKC1ds4IG4a0s+CW6MSthi4QhzxesrTYVx0T3c205WquCNLiNRnjTop3db+Ko5naTEy3RdyJ1BQeDMU3Rf6twjdEUkY+uRHrpkaFmLMrKFHGzk23pbZ2F4TDwT+N0uwhRRBiE2jAzu40avBpDJeR6NLNqwdcCJwJ0ATef2Pa4X2xaVssnpRcCIeSbBvV6qLbeftnkKJNjhB/u8th+BD2iULSkwA/odgR4z0MJmxxZvInZpMJA9PUlRdPun332CaVd+JvxBqA6nuT88UX8e6l0lcKDEGpTSYyjdWPWgt+kiZj0DoLm6Gw1vXSvDfYyJtbQR9ePQrO1/rodFyLB+0hOCuVqmlSnITtfmjHjdEUsuMfK8J68n5BfCv9JlpKnbww8XFTLdnDoWKO5LbQlfiOWnbdD0alEZYZXMCy895QTmwmiLqJuqn0FmfhCNRZlxBa+/C0K/eahXYBcIUcZHixZhefAtCBVuQRM6kgeml+91I0J0gQIryNAzyuo55rUwellTMyeJOaZSMm8pYNMGq9t0psdf3gN5Yc+JyNbtPkKHv45Mog8c/uzDX2uWDSX1KQBpt8cq45ksb7xE/8QY9iUWhgJIzTDvKNSmurDljCp3yRjC7oUNOU6DZRgSbOtk8wPkPja7Inn0t2W1x0eDb1r+TQiNCiHQQSt4Gad
 2Bs6X2kT
 U4vLh+T8BY6H61nNyk1BNunqEd6QpACpq6aIOPgOHcMoC4Pb2EMFqjBGt9edyL2zPvsZd+EuBjy0r4a4d7nPpUjmdCSFylbmrivhhpax6Kt626mzVVxLej+jxHDhHW8LUcO14BqDIaqMKk9KVdPLPVdhDJRuEywiBRqd6m6Hk8FCQdD/C23PMVOm4KXV1hy2EUtKbaFHBgvBRKpjB8UH91sx1e794nbhitZ6JafF3fq+SPsh/m8MtACMix49oxbeBFmn8nKeYt7Ospok=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask is now modifyable at runtime. In
order to synchronize against PCI probe works and make sure that no
asynchronous probing is still pending or executing on a newly made
isolated CPU, the housekeeping susbsystem must flush the PCI probe
works.

However the PCI probe works can't be flushed easily since they are
queued to the main per-CPU workqueue pool.

Solve this with creating a PCI probe specific pool and provide and use
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
index 5cd3d98a2663..b1eea5440484 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -8,6 +8,7 @@
  *
  */
 #include <linux/sched/isolation.h>
+#include <linux/pci.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -144,6 +145,7 @@ int housekeeping_update(struct cpumask *mask, enum hk_type type)
 
 	synchronize_rcu();
 
+	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
 
-- 
2.51.0


