Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F52E7545D
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E09A6B00B3; Wed, 24 Dec 2025 08:48:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BDEB6B00B5; Wed, 24 Dec 2025 08:48:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695E16B00B6; Wed, 24 Dec 2025 08:48:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 572FE6B00B3
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:48:00 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 221B8160224
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:00 +0000 (UTC)
X-FDA: 84254493120.19.AA5EA3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6A00E2000F
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:47:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mgxbtN3s;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+wC5O17e6CT7mE53+r9sx8o4mZgrVDl4Qn4UXNXe6XM=;
	b=qUwTp5gO6VjPgcxoVFtXFkaGKFsub0R8jwUw8nHxSoNnvPDaRWse55UArlSa28hcikZfaN
	1r2BZKJ8EfLcjBO1XvqA8aZft83fAoqmRZYhYdp19EREXcZTCsoKQ8S5eodGNYOrAY9XZu
	FZJTNYxl2OXdSSBP+QOKYJM8lo2aEG4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mgxbtN3s;
	spf=pass (imf13.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584078; a=rsa-sha256;
	cv=none;
	b=GKFyiiTX44s9wiHxsKmt2fbd9H8jIWU3kv7QQ9Ujt9Usi1bF/WBFyoC/GHd/jfZQnNOPqg
	MZl+S9Vg3/IbRuwMUTB9BfMX0FZ6/7s2YeAx2ZwEULZfRDUklUj1jLgh4jNSxMs6Vp3cy/
	xy79rzwct/jr2pa5sGNV50kHBHRn99I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7C6F44445E;
	Wed, 24 Dec 2025 13:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74AEBC4CEFB;
	Wed, 24 Dec 2025 13:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584077;
	bh=7qYWxx++pmNusXv4R4xraAF3RRpFsEpkHULEuTSFVcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mgxbtN3soXaxGFkGtshSu3sETLrMlJFD82nO5TFfcJacIWGOhTQ+w/m2OIPUEg+UW
	 4vaHTNU/AHwz35/L1PwlH7RI0b8PfrOENgvkxhbQhmccOctFo2687Gxa50vDt3IYxs
	 TSc1vvtuYQJDTSgciv+ciBzZN0J+Knv4pd4wzToU7bEH0waPbjiGwWOAa+c/P7+hSP
	 86lHadjQNahgmqghysF5Pun9Py8RA7sa3q+EyENqKTxmf/U6WsMedSDmeG1QX8mOuf
	 sLC1gtYyWkDeMw0bZ/X9P/C//04luZOy4qKLKr16jz8Ub80z71p0n2XXxQlGnrzEzC
	 faPNoWuE0m1HQ==
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
Date: Wed, 24 Dec 2025 14:45:04 +0100
Message-ID: <20251224134520.33231-18-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b7jp15666xfah3q5dmwf7y4wwuzte4gg
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6A00E2000F
X-HE-Tag: 1766584078-768879
X-HE-Meta: U2FsdGVkX1873J+2rwvOXqr7+Ma+wANrqczja/Jl5pNdh5sbShRgzbdYSOUZXPJttAduw3Dv7lg95yG+goMNCRT/vw2EZbWBmUujz9zfVu6e7m1L7cpDFYSDXqeVad8cUcRD6HJPkdEUR60tBAt+FQSdib7bDMgJz5sho84FlAawSOrK45PQ65yfHLLjtQFpT3Wbak1clvDo3hquxE3tEG4YiAfBJlp7vkiz6MVKXk9dnJFcbyGXN+rwhDntQTquvOIQpNb2NfMuKwYNN0Hl5VGh6oWmF2XUFh5kGw34ag8Y8tL8X6JGcco/Ule7zdla8DpoehleLvCtO2ewRQv1f2MrteQiJsv3o5Mvk1aaUhGIWzQbH3DPJXHtmerLHohnz5t2cZS3iDPQoY3LQxtcI/2SF2E33QDcSgLkfXBj4YDTkUiE9C+uEtN6d+DJCRiXjlFtjACAb4foRW721XkmiS5fpw3eDsHQ8fDGgEetP5qTfTbadk6nqaovMSq51rk6xc0sE2qQf2NvoSxnrudt4oyJyuXUvgltEoJSqXOPLh0QvLK+FB2Ue/ngwnHDfMs6Db6qFh6K4duoUoibyYnBUBm1vFb8Zt0VzyL7EHuBX0OzxPfAKg1W7tzktKB71MQWRDejHJZ5Dl72O4ghE09z1YGMdnMoDSchRDGwgUw6/G90VatSugGM8RXEq23dQl9KSfwuto8vQaQkOPJMrdTTHe3fjmrF/ETmWUIpsZLTDbtSNvcEQaFFl55DBypwpSgbsMn+13GL43ezMcI7Z4jVV2+qaHCnO9ldx1ihOtQM3a2e5XB0+egzpvTzL4UbHwM0Qr2hlnuoFrog3FUvWn5L4ynl8tPbMHddfLUsJCKJjwFWaw/KXdSThIAyiw8wy3yuQYI02mSA8DJin9Nd6XjdSXIIzQ4VNg6Dm21sOBg07IX2+qwIEk+aZSsRGvEMZJwLkEeruC7N/eMQfsePtPs
 N5rBU/5/
 LE69m0luA8PtIN9m2a2qNih4xXUKl7VbshCr6HDv2vZUj5MKa9a4LlzvFuPcJiZipqbV9P6NBGmMbBHrA5iDy019iSKcGk42TIiSggShndv3dRC4ZbetXoFW5eRfBq3C6uhdCE6/mkQLBWhct8Ei/YTRok3kAXQNnZc27GUiYR3AFHtETdghiloeiQ1xB3IL6FTB4eaRklj5CuOv1vTjONxhgHyX+6iBBMF/cowIAiY+vy1pE3ABMk5UJANW8cWqaHbguJcQKpQCS/T4=
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
index 786d6ce40999..d87f781e5ce9 100644
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
index 8aac3c9f7c7f..7dbe037ea8df 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -8,6 +8,7 @@
  *
  */
 #include <linux/sched/isolation.h>
+#include <linux/pci.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -145,6 +146,7 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
 
 	synchronize_rcu();
 
+	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
 
-- 
2.51.1


