Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFDF5CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:32:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5815E8E0063; Mon, 13 Oct 2025 16:32:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 558578E0036; Mon, 13 Oct 2025 16:32:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46E738E0063; Mon, 13 Oct 2025 16:32:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 339988E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:32:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CC3F51605EE
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:08 +0000 (UTC)
X-FDA: 83994237936.03.277E7D6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 694DA80014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:32:07 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcHqvX7R;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/t2AG3xG0QVui5ui1EwN8zCpXl8fZ1kSfy4ToXG8/o=;
	b=1yVdasoji/q2R5XzzkouRuYUuK1wPAmA6uvT9MnND2pYfc/QgiSq+H1pIx/DsB/77n0bgB
	GYrjFRAo3jyXxfhh85u1nvlaqPt/Vq/4R13k4S1XzVedlMrYe/hlmd5mB3xGa8aifBe5RP
	C9aPxXo4jXAZBIMPpI5qZA7aasnF/Wg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hcHqvX7R;
	spf=pass (imf30.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387527; a=rsa-sha256;
	cv=none;
	b=MwtjLBaGifjt5VSsps7mslc1IQ+wZ/U0wGP2ncMznVSw+hSnoDiywNalXEmxT90wnAfD0l
	5LGMoDwi7RUllwr4lRzhtDETzpa2p0b91vCXmYIAimeLrxU85qr1FnDRoVU/vw5t8MK3TM
	tnml5BC+tfI31ksyKlqLUphoNGbb2sQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CEEB3604A3;
	Mon, 13 Oct 2025 20:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11323C116D0;
	Mon, 13 Oct 2025 20:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387526;
	bh=zlG/yixTMUrq/Me+zY5s7AwbStMjq2n8GY4MrtLKvUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcHqvX7RhhCKOAaYLpIuftFbUJV/a3dNOvnAi/tkoDar/BahbUCmucimX5UI0fxTC
	 VgSSfOKqr2yd02Yz1JYY2977DD/zstadpa+3DhSIRMrm1l+12HN1J5IxJHYBESdo/l
	 veQRkowFpPH56YNrE/7CHKTSbIbxtOkceqAtRUA5tPja8bwftjEvBAvcvTduJZO1dj
	 DMorYmBMwWVoWCwfMtQb6wee3WRgC5gJ4zHnTrUARWJbLbCU1erpheaBhPInUskwLw
	 q5bCeE2hZ1NbavDZyHY99mP2rH4AVVo/xLqzHlDz85GKyJ65mWA5AizA2ddpsQIvoI
	 RA31HBv9njIVA==
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
Subject: [PATCH 01/33] PCI: Prepare to protect against concurrent isolated cpuset change
Date: Mon, 13 Oct 2025 22:31:14 +0200
Message-ID: <20251013203146.10162-2-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 694DA80014
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: kigjygj57segbc91pwdk3r76s33two1k
X-HE-Tag: 1760387527-892889
X-HE-Meta: U2FsdGVkX19gieOqX767jLY4A6ZI5ehAk3id5XyADvD+FvEqpAswibOCJRB5SspzU1Ukv2mxltEV3DtC9+b0P8mhEAtVnYa7/1QKYEYIhi2YHoy/QY8MRVfRVQUiyIrpsN3ji8E6+ftbQuVdIvmVqnBVEvU6/S/bsXX3ZzSNpNjJTN2C/7QGLau1Mfl+mMVQLM2NKu68XGVr+VwRBOR/kGtLZDtuBngQpJvFdXHbNn6W3CiM39DUqeVAhW4cwcNAlFj4cszpgVhrVJLy3v3vfFvb/hq/d5LZKjHUZvEfrTFb4kDYIzwgQEneL+wALg+Izfvw5/6oVn0+Um2/oZYgtbShqhbCkQY26fRobTGmwv30ZkjzV9BY5eTFB8FXUkNh96EXyhPCFFpKqHJGJL/bmYIqOouuD2fmLMkjoRQHmbOdpqvm3VFljeSaLqQpWH9vcH+kKvJckHvEL8xh+6Ue9NY90qDE8cb5KF+vbVpp5Z4+3V8rmi69CV5L4tJqpL6XbGui+Ec+zK7OPVvKzUXAH1lecEfQz64LxUe7uHNMOhLbiI2i3rF4IUkmphrpCWH37nfAzqHEnbCheCPdovIs+L6g/itRPyJNIqKWQ0Twdfw2pOtfljbd7rHLr3vNX6Z7OcOZvatuVJwFbfK6tGHYcBTnWestW5VZUU3YuuJ8Az4gkrINCQHncfaJQXfCUS3xVItGNghZTooofBDGSA34nS9MWFkPoWu3uickcv3/zTHkyX3oTCXbsUakpji0GT4u7j+hr9A9nZzfv/UQM6BRqzyh3bO7AO+GGTnIOm5sN1xElUHLcToJvEkzg/bbINpdrnoFkjRN7JA9E9dCqYUqe5EwuUgHx2TV9QXAKioGuV+LxTXkthEQtmayiF3KxJqC/SFl7H8haNaqfGqRrA34szWostUojsLVAU4vSZ+zM4VRxtvc1haziA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HK_TYPE_DOMAIN will soon integrate cpuset isolated partitions and
therefore be made modifyable at runtime. Synchronize against the cpumask
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
index 302d61783f6c..7b74d22b20f7 100644
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
+
+		INIT_WORK_ONSTACK(&arg.work, local_pci_probe_callback);
 
 		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
 			error = -ENOMEM;
 			goto out;
 		}
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
2.51.0


