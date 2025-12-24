Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF6F9E7545D
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A79F6B008A; Wed, 24 Dec 2025 08:45:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23E6D6B008C; Wed, 24 Dec 2025 08:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FFC76B0092; Wed, 24 Dec 2025 08:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC7A26B008A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:45:43 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7478D1A01F7
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:45:43 +0000 (UTC)
X-FDA: 84254487366.11.C154F29
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id BBA7F20011
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:45:41 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EY/rxLVc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766583941; a=rsa-sha256;
	cv=none;
	b=YZumG7QDM9DAHammiZxoJV+Q/k/qIkTddD0iUaVqEekonWXXlaePeC5vTNYcAM5XQ/xiTp
	NgXPx5xiTRLqeLJfSo52GdAJyrWeTgai2HG4p580bA2kdbMHK0OcL9PcbEWEuitvvP1E1K
	tVROPk0g8L1wqlNWKPYM0u+RQC5j6+I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="EY/rxLVc";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766583941;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mfr3Q+nYd5p+xvys9qoVKamvPwe3ggDuT8010b3TjmQ=;
	b=I+FSsgb37bxy+o7CzT/AQue2oNgx4EjqzlviOrlae+/PaatIyUH+JEnB4rdUIy09RnTWie
	QwzQ5vMZaAIlTjuGQtKEUBn0D6fF5v7D4bwxtQz6g75Ov3Zn6savhYYi7r6YamTAULN9+h
	QLvEAmr8zZTHz/sh0/5z0wqjuLqbEIA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D1DB6435F8;
	Wed, 24 Dec 2025 13:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AF5C19424;
	Wed, 24 Dec 2025 13:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766583940;
	bh=gRRNdybTJoPf4zghu+FAESdALpfSWbcpUTc3hVg/iP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EY/rxLVcj3XVGLfQuhfdznrcbQGy/9FTi8WQJ12o6Y5hVKy8WvRZ0Agl952OnUz6k
	 6TNPt9uSgZozs75LFMvC52n3ieQK9fVy2u22y57DdM94PbvQQ1IFpwvO0bDlp+xFmC
	 aSmxwYc+FbNjaiOHyrQPpz8lQBamXwUAHhJRFwQzz/2I7/+oS1Zmj+GW50lW58ODpl
	 AS5Jtn30lL8p1JTfpgp0uc69XhfvWvVKMz0fxLizZEV7dGZOvfmTdxGr0QyqDmmbPH
	 JVCvPO6v+S95bZ8qrY1TqoMKdINOLKCOtKOpyxXw7v/tm/9+ZsQsDpDGVxMVcpOb/g
	 tHraobqMSYmbA==
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
Date: Wed, 24 Dec 2025 14:44:48 +0100
Message-ID: <20251224134520.33231-2-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BBA7F20011
X-Stat-Signature: gh9gud9yto5z8tzajkfdgq71xfz3b7n8
X-HE-Tag: 1766583941-802944
X-HE-Meta: U2FsdGVkX18zSTCBWTYBHvwKFc3Q0NiFhd5eNPb3YfblHEcgmfNuW1frB+1i+2Z4WIEgcbGiDUFqp5NGbBg8ax0XGE6071PSS020scv2YJZ9kI9jG7q3fi/TmDNypp+/tidKprkQ6fuEifjN05cInEesqQWi1HHcqwqV9PmC5BX3pCphF+ItEAjgvE2nBOLJaRaEVGFZ4JshCxvdK1/zJn0/5S8VlBctDCRYQGQ3bzJN3N07cmWw4zVcIiaPeStUu7P8hAQsZ5qypvG+H4zSU6YclwN86rMvvrnlmkgf7u4J/8u3HiyAf+8Dn8AfZjfrB+KanQ4OrGncs0s5BvsJQB25ZH/DUMyxZVi50HFbRScsVpaPj9zvwCp3wzXPKwxYJpFmNfT462mCXPy5ipaGDqbNUiDMPmY8btwXk9+Q/MMdSd1k3TZXFBAtXv8cIZfGtmqRwZXGm3OFI9Mr+owbYVntvK4hT1U1PBuzYsp/U7eNCCF3Y6NOc7FnuFMe+gb94eSzq9D069RmFmMQDIAG0y/R3TFHYsRuFla9wusEPaOlL/TNbKRh1mYk5G5mbJa6GQBqW7CpMTbYvCzxGQZwdBa6vNYnF3T1aZ1zRVBGxtjJmjkrZa9xqMJcnc62yaQC4DhurSXvZWq4lKhyplk5VVb24HPdhWVkWZUYzZExFZHbs3KwBvA2ZncAMkrAgwGlSqDlU6PP3fzXICbv3qNjbQLRC1qbR23HlFDRewjkGNlVGDhCVInSphPnYxKbjMl7DqHgGWvY1IVUqCGwCTQGiph9yp2NELq5NNnCEFCHlILE6+2yc55X//X6TrChycRBLGQ5Rq1y9ALWExqecj6rCgHJ4AhOkgVQuG57nJlyKBC7th/nBT7iYtEnkTqKppAtgB+QCqU4LHrTRrzGEUKzmsznPL1O1i+nR2AN/5Y59pKK/RsmDH+VgWclu85RK9HgtVuF8d+OrLN48suJEYb
 7zbXrkv/
 HWfBqsdSYS+NKewHU4tnpGeMGHhkxUjCrN9PYsW9iC0MAcEfTnqCwk2Xzf3nBs8QgVpia5jEtKvbkv6PduP14EJqgFST4pgKkOKDIwQ7ioGyAoV5IYOypdJ31UjqCKiWu8AyHS1lLIpP1ouA+3J0rQg4m2AxarpX4GbP1pnnS5hKLUZoJdg1ZPsH8MYGc+wRbaRRyyUAmDlegWH2Heg/1B0WVfELeZ1ihW7nQb//dhNAgVW0=
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
index 7c2d9d596258..786d6ce40999 100644
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
2.51.1


