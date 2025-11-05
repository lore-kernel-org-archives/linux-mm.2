Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31AEECCFA0D
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A58A8E000A; Wed,  5 Nov 2025 16:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 656288E0002; Wed,  5 Nov 2025 16:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56BBC8E000A; Wed,  5 Nov 2025 16:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 444648E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:04:13 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DB395C044D
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:12 +0000 (UTC)
X-FDA: 84077781144.30.CB432D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4F2A740018
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:04:11 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AJURCUSi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376651; a=rsa-sha256;
	cv=none;
	b=1AFNs/UtEeFUauCUNRfyplTOyNeFYUgMA5Yfb78BG6HKkomDoKevnmhSmm6gz+1ZnFrA0y
	7HRNvv1lXbrFR6ENYcxV8ugw1X04z4c7dKhpPGcU/RwH2kXaiGHFAbQsT6kfdrf3Q/0RbU
	J2yFNqUn2he1iClLeAW+AGGuppOMB3k=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AJURCUSi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gV/ChDBGc9PLzOMwlQ88pXk6Lp6exJnDze4qQYv61iQ=;
	b=qzgzI4WXfSbbLSoYpWORi7Rs9cOrk4Gg5AkhFHDUbDe+lzCJ7uO5yX4Jo3gzBNhtjC2QZF
	ijkXCs+XHkMTtjhk8nmHCYLKiAcpDVt2USAnEo7H4rgkzodaySJmFEreizjhBLu6zi2rQ8
	vX5lf6z9Cny1uKbEUamhSgoESjNNAVg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C85560220;
	Wed,  5 Nov 2025 21:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13AB5C116D0;
	Wed,  5 Nov 2025 21:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376650;
	bh=8Q71EO557AK60zUjy5zJPPkN07FPtYd1UuHTAzHqsFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AJURCUSilbHUliUZRLrgr+YTl80lHSkFVtDFlHcKKO/sO5PBq/MhEJUXJz916fP81
	 wAbJ8Yy5s6zsZm9lBVZoeQXrmyCrVMNai4ryobrKlPGWI6PI6p6Jep72D7ahE5dvcd
	 k4C/l6tC0UJksuZsxtngb12Gs/wAUhM8HZr8RudMlyYPQQHJ6z+N1Fiqf5+++lztgm
	 sINWjeiVCtGxC9uvySEPj5+spW1J3KjyQn3Fa6fEASxYDs+prWyAMn68bY/cKaaxjd
	 txBp5Oc4fioT76vUk0O5Kgl+uyh1HTeyhNjK41/nevk/wEXq14ugto76jhLUchVfJp
	 9jeOdMslbHixg==
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
Subject: [PATCH 01/31] PCI: Prepare to protect against concurrent isolated cpuset change
Date: Wed,  5 Nov 2025 22:03:17 +0100
Message-ID: <20251105210348.35256-2-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4F2A740018
X-Stat-Signature: 76f4f7fqizj7nc8unb3am4h497os9jrc
X-Rspam-User: 
X-HE-Tag: 1762376651-982002
X-HE-Meta: U2FsdGVkX18sfbCgBjkURVx/Kbbq4+EtTT3F2Ncr7d5/d+KlpOixAueDGZc468u1UoA8oRD7SZ8Iw5h2EsmBc3r01bOzVSF0hsIUMaLhiyb88we/8IXnGg17sZVB5ZHnSZSIpq+YglYKDu12NPDQ0TtV7+Bm58k6WRZ6MAwwRF5KBIMxRpe9IcHTwXzpCKa4y/GvYXq4aeP5+8qsD921eTiTABD1pv71+qBrwOulamfbsz8PsyS1YXqAp2uFN2rU7HIYEqLLapa2tXNjF2eU3WQfvC23+DKrRCEc7AkamtbAHQ6Oka7nSWEr9ohfz8x1PfHTIwpgf2wIxpIIkZiJsdV7pFSKwhl6qMRXBnlRyQ27htjALMoEwkx0yeHSmxMM7I84slgXVHXLSX3NsRNrbe2+4dUVGQn1GWORJQYO/EPP+gIG/g9twFyAg0mZj4V8cQTTYzPIca7OhIvPqLTfjIa8TuAA/9UhzUT4z6lLROp2C5hIMf5lQJ2n95llxgK79zkTn2Xav57ljzFqdPR7uw+UcOqBHouBTKo92qd5FD/P8icxFh2y5sVkNq24JWDaErrMPjSx/f5APtoXD3+fVgmlLp7qM6YcsX62BKiVFvNUSSHjD4PXkoskkoc94m25lg0a4ID+NZANUY4BwDNfna40FrWHV994LN0MGVNaLaq10w6ouXHgfvMlOvL5S+YpG8AXkcdAqU25ZqKJDDOiTvfaUq5M8GGXpL//mcB824WPumRX0VPLtTynHpwjNnlOZwUM57yzlS6cTDGs0hZhKmElLVRGxpiViaxeqaGo66nYa9mTkHpzkB84nwl95sxalXWjzkpe3mCX6KqGzu6JFp4wwqi/TLLsK8WkRbYrZ5NPuxh/C+ibirJ0FRphwo26kT/5MqpSn9aJuDfGFOm2aS+6vey7mPK3s14Jpux/aWQYZr2I2DgeBsfBlKQ4oNvDpFDNnY9KTp6TJqkNAXL
 wwPPtw2e
 BBlYTydc+qTZFuozGaAeesnuhLVKLdPv1U5WEJKUslXvOd6YKbUpjjCGAnweHKcmj5nTEzcCjtxnx3MQ8WxPTV995z46tSUq7KkYBd+Dah+Tc0wslMUOqyOgUr59VzOy4eBajdfRw3Bi4T7CFspfrop7lninO3bGi0s1MX9DsedSkITIZJPD8J4+yOp5FVgey+nNT03pdVaioAbqISA7UwgjU4tTck3gd1KWMyIevx1j5ns0=
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


