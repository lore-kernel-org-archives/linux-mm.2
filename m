Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 360C0E63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:46:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0CC6B0089; Sun, 25 Jan 2026 17:46:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 653F26B008A; Sun, 25 Jan 2026 17:46:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 577626B008C; Sun, 25 Jan 2026 17:46:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48EFE6B0089
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:46:04 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E0F0113B246
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:03 +0000 (UTC)
X-FDA: 84371970606.14.63D4CD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 333A140003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIWgU7+p;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YcdTkE927g+/FfCgvHIRPU5ZO1R359X5YDI7SQf4OO4=;
	b=A6dPWA6LPNjo//0zyQF4MJkn7kCm8saPy8QO8DrgUqd2yBc1+BpPbsZXYa1KXvI0AwfbAK
	qpK6LNrtutEpDIoZuX34hkwVDWOgreJZtKXTGG718Ke3cCBJRBIPwU9rDF3A25RO7ZRVGE
	ILYF0N/gVYv/ZDOSui1pfBJbG4fUDV4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FIWgU7+p;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381162; a=rsa-sha256;
	cv=none;
	b=nRJl5fSpSpxEWMjFjyU49u+2ANfsdurzMz/xQaN8tnPLYOEasr2GCBmOsDrDRDPmiOKoIP
	Zd4fx2YKcwRbK1MROmCpbXLTX5gL9U9WogMUQazJbmG9qLNk6Pz3/TaSP1AwkGY3XMxauI
	kb78gYfrS2E52UJHPNKTRdCWEF5zvWs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 04A00408D2;
	Sun, 25 Jan 2026 22:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A88EC16AAE;
	Sun, 25 Jan 2026 22:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381160;
	bh=vPL8EzXKWq9iiIp5kuYoia41/85wMoYaNYnO6c8sEhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FIWgU7+pr7+ckwb83DyKxDiWT8xbe7CLrxGuGRjBUui3ebqjTplaAEWc1SnTKrjOG
	 tUx+pdCeJFih0IMyujpdXJcHTYc5m6E+TsbZUkcYq0FjizUFEUOr5uKfn1ANgV8x3c
	 iVZKrZlS1Txl44jkj+YbP5PDaSiE866VyLyaP3azWSwzmGZ8ZkjD5zVumV8c6k8I2E
	 br5lPpen+XXuYE5ErnUP87vKq0rH5MzUQOK/Wzr6hGKGNE5Rz+Nyoss94n5SFzlEft
	 rkDsNXhbh/uSNRerB1QWLMq7i4T11QBlyJZ2emnty4QgtX4wjKvHxpfQ7H7fWu5r3J
	 +QCJLEqLO6GZw==
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
Date: Sun, 25 Jan 2026 23:45:08 +0100
Message-ID: <20260125224541.50226-2-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 333A140003
X-Rspamd-Server: rspam07
X-Stat-Signature: 1qhdonc3c4s7mh6aakuuiirsnfgf14sf
X-HE-Tag: 1769381162-869413
X-HE-Meta: U2FsdGVkX1+NR6VZ8s21u6ZMkLlEcmUNXGYhtpnRSUHVbupRWEd0mKK5b8eeWFKjmhoWZFZk1URIvSMAJYDOLWTOvZcFMD9/DgkD61ZoW///ivb8Al/7X6JcSB9eTsWEk4rV8kIlbUK7cjl5GiVg+N4VmCN5aJ3euFgt8rFilQ6pGwRXoZsJSTkVlgXL0pMZgod8V8+yqvMK7ift399spylif2vcAsTe+ldKMALVg68DoKnGGAJ7Xk0xmkUaQs2KBjh5ZUOZEbkDXZwD/Wp5EeQIxmqDOlA0TC7NAc9jYB++oCHC2iF2MGfIRMZ7rg+xzThVEwKpjX3ozAtI806+E2f/25K5K0eZJVzhox+P//x3WPq30GtrkyU619vxX3r2cV7UAOi4YGsXWOBZkxU5gTnQuF0iyzFUCRWz9ZldGKf6F1FheRKmKUpUCcOCNWzTnZ8rhYmxlB71I8ntxq41rfHKeiSXILgFHlh+Xoi88O0T+3mZTGXarKwiCmrRYkE3v4RatgaexlapP3/ZOOeiHf8S+BV8ni5JaKZGwE0c6eYgAKWjY/L8aVMbyST8CTrcZzn8y2Y+tkDC2o6OB0BQPIoydCEEuNLCNE3FgPZDj1rtXgmRvT7H4NOWLcLghIA61zG3wp3YpBtzSphQpXQDkcvtJWaaf2hdtUXaks2DSaQFqcSL5NlwEwXAqYkKw+bbqTxhDQ4jitRsdtHCUfM7OC1Y3AJ2VNzESgjU4J0wq9O320uk8HGPM3GZ5yvINiU2SBIS2Um1VGRPPfaW8uECfAKdYMP0gH3FB3SoR3geZ70KViD5sEiTc63XaGiZNQBY8mn2w0Dy5ZAtRWjpKM/YDXVdaSdp+Ql/X01Ywtkmso4DpOLDtoV1RmLD7lGqEulu1WXj97jbWRoP+gvG0y9PmliDb9SkX6SYAGFMVafLUW6b5OuA1zJZ4KFreFET20kYAu4j+APhq1Tui+MSPQ+
 jT8on16i
 Wf8nyMVgrM2Ac1xNNqR5lB5j7iRHd9NjAHeumTzROmFhmlEcobF0K3a7KKnlSTBrBCtdv65aTB6zrC/cVgioSsST/vTPEViz99+Af+1c7HNHsnlsKjurEOkcZ1k1qYzoiiK8k7h+KP6PQBq4DrzCx3VouFYfpWjDKvryeHM2J8LWWFXBHZIx109zRRyUdQUqUTNqHvLUasbgYmLXu3lfqRsSHEdMvxPRdGrQCO54rz1Kx3L+38vPbVj0KcNOM9QxYpsjD
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
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
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


