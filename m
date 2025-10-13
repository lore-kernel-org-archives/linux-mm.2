Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33BD6CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 20:34:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E2428E007F; Mon, 13 Oct 2025 16:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892E58E0036; Mon, 13 Oct 2025 16:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A8BB8E007F; Mon, 13 Oct 2025 16:34:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 68B2F8E0036
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:34:36 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3144BC060F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:36 +0000 (UTC)
X-FDA: 83994244152.19.16F7130
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6C87F40014
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 20:34:34 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kGUZBgXn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760387674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdYXpjjWsK1USuQxWpC3xY3I0EurRsdv37SZ4mQBI7c=;
	b=htsgIU8NyqNn4l5LR9GvtBGbdMWhjfh7sFn8I97mXTUUXsKbOKdWd85OOLaiq7gUN7ZwSu
	O59I+V9z72+PYdkLfwVQtLOHBmzS6H85yc7MXd8MGhB2hb8jet2Ba8DjNlpixv+a6Uod9G
	9ZImUXaLE1zbBVFAhYBwcoF2mF7UgK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760387674; a=rsa-sha256;
	cv=none;
	b=mMYBaRMfueIlZpq2dJrGRIU3v6ceuA5PuWFxIEGQV9qfyjHrnyBfuzC36XxdVBFtzokq/p
	bPyuvp3F9PBXbFCCzIHEuQfkszsnXQPjaLnsppLa4/2w6dZFGACs62bkw1sSLpjhxWYRzJ
	Nm14TRTtmJ1LzJIUPbzOl3mdQZQFobE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kGUZBgXn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F91A40B6D;
	Mon, 13 Oct 2025 20:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A000C4CEF8;
	Mon, 13 Oct 2025 20:34:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760387673;
	bh=fIAIlX7FO5mGPQBGWuCynXC0SPKY4AIZnRPcce8YI4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kGUZBgXn6LspaTVNsHUXw6H1LvpfUUIOdlwabKmoqwvFi1hAu72gRTPgcNwG3PJvx
	 SXN8oGKpcy5LpKpnzB46vLqkzMStFh3+r/Gku0O1TluECywGQh8xNlm28C9CNKblng
	 pt7vZFsZqqdtHOSNVjf5b1zacTH2l7bfVEMieVnh3BCpGc9uAea4sSSZ95W5W6f5Zk
	 qSFg4+f+qsGknCEh0Flvnq4KT1MID1lNrNVfPklqQRZJdUdipgjeKpGfcVq+0+pt4Q
	 qL9pMj7rVY6j8Jq4PSehkAz2p/TUOHIOA3xyMl71zWjPHR86cTD5V72ACzprKTLtfK
	 nK8Y/RSyh919Q==
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
Subject: [PATCH 20/33] PCI: Remove superfluous HK_TYPE_WQ check
Date: Mon, 13 Oct 2025 22:31:33 +0200
Message-ID: <20251013203146.10162-21-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013203146.10162-1-frederic@kernel.org>
References: <20251013203146.10162-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C87F40014
X-Rspamd-Server: rspam02
X-Stat-Signature: m5d84h9b6m74iint91hjyu6qmggu5p3i
X-HE-Tag: 1760387674-644470
X-HE-Meta: U2FsdGVkX18imSqTjVknbyGp8sodxP84RVproSr8Pb83pohlJDykqIj1nmi24wZgTMmgGXrAKHBp4T7Fk4D5o4HslSEBv77zQjuyChZ9UDSajBy+ZcJhV3shru+2/TuAkZCwlXm9dPejNzITHT3fjD+IzK0m6YvlRZ2mnnFplmKrDq7B+RqODyqLowvPdCLZapBlSzUgQ4QMDnSMO3SxTpzurwc0UpwSaa9+Y5oVI/mHbt4XbLUNZmcXctyYQK+6YYjdjOvvzODE5YASqwloKoE84+XN1Pugsg13JnNDH8iTi5E+VtQFl7t5jEQAInxIz2lrj5ktuilnTGzFUuvn5v6K86pn1KsXRuMuzLeFaRq87eTT+fS4YNQPQaNKSYkU/wsEMG2ILkEUcF8hl2zPcicAXKceA0pYFF67tC5l0Km7nCwVDSVxll6hBvbepCQPjwkSKKygTCYwLpfwBXVS3y7b+wpK+p6fiYY6khoWlwMQb9GriWozvTK5WR1CU2zoBGjMjwyxxuqZg49fPbaL5KXmKpDnkY3Cvu7XMDLtDQEspbXzgm5O4wRd1V/QO7kaPqTsTfErJfa/17ES98h5RP+nRHQC38d4Dz7PTbtDhwiyUYcoFPjAFsDI67pLdpnx71GMDwmlNhw7KTa1bFBELvhsCNTkOKVUylm1TOHW7HC2TEVToh2Dmim5l88MjK9qb1LxZrgkq2RFdwrpaPUzO70XPloojwxw8lxCWMr1xndZGJ58adb4JZpA4D6MAUpe1yUnnggr17c33t4WmlxgZ4le1dnpaoQzgv7oB46h1A6F0wvBKZ+zFzUMi4CHFBP8aeo5/6phnd9qGOvL2OQfo2k3RIcow70m73vDlya9enfKd7eFGwgbO8YXeTHdg5GBWfOt2ZKGDwCfyB/xlQXWYCTqYNxbsPEqQvVGD+bsoIlYQV2T8U9ZzRYMdEdhd20pHiLhvCzAiKBmHTyUGm/
 BCypzDPm
 y2rheeVccq7INzdM3F8HXAZqGHoCLnM0KsAQECb4273T37sWthRyAti4IxovSYtgMgCqCAzEHDvkt9y0v5ikkjGSOtidkQ+eZvDXXKRC6YrAhZvND4pMvsPAqY3fFO0JOJ/n+VcOHMK41TiPiRwGKynTno8yhk0TBKw4nsdu4rLb9F/ifrZAAKew+28CUlm0x170fjcIbN/v3EIFVuH3j+WsVw0/dIgd6gDyLXfQEsInLeOYPpQ5FUbA5YjUExPFbn2AYcwDurj+PEgZjihyFh1QhFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It doesn't make sense to use nohz_full without also isolating the
related CPUs from the domain topology, either through the use of
isolcpus= or cpuset isolated partitions.

And now HK_TYPE_DOMAIN includes all kinds of domain isolated CPUs.

This means that HK_TYPE_KERNEL_NOISE (of which HK_TYPE_WQ is only an
alias) should always be a subset of HK_TYPE_DOMAIN.

Therefore sane configurations verify:

	HK_TYPE_KERNEL_NOISE | HK_TYPE_DOMAIN == HK_TYPE_DOMAIN

Simplify the PCI probe target election accordingly.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 drivers/pci/pci-driver.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index ac86aaec8bcf..e731aaf28c76 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -384,16 +384,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 	    pci_physfn_is_probed(dev)) {
 		error = local_pci_probe(&ddi);
 	} else {
-		cpumask_var_t wq_domain_mask;
 		struct pci_probe_arg arg = { .ddi = &ddi };
 
 		INIT_WORK_ONSTACK(&arg.work, local_pci_probe_callback);
-
-		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
-			error = -ENOMEM;
-			goto out;
-		}
-
 		/*
 		 * The target election and the enqueue of the work must be within
 		 * the same RCU read side section so that when the workqueue pool
@@ -402,12 +395,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 		 * targets.
 		 */
 		rcu_read_lock();
-		cpumask_and(wq_domain_mask,
-			    housekeeping_cpumask(HK_TYPE_WQ),
-			    housekeeping_cpumask(HK_TYPE_DOMAIN));
-
 		cpu = cpumask_any_and(cpumask_of_node(node),
-				      wq_domain_mask);
+				      housekeeping_cpumask(HK_TYPE_DOMAIN));
+
 		if (cpu < nr_cpu_ids) {
 			struct workqueue_struct *wq = pci_probe_wq;
 
@@ -422,10 +412,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 			error = local_pci_probe(&ddi);
 		}
 
-		free_cpumask_var(wq_domain_mask);
 		destroy_work_on_stack(&arg.work);
 	}
-out:
+
 	dev->is_probed = 0;
 	cpu_hotplug_enable();
 	return error;
-- 
2.51.0


