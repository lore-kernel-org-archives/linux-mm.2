Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88D1EE75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:48:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A306B00BB; Wed, 24 Dec 2025 08:48:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC7E66B00BF; Wed, 24 Dec 2025 08:48:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1036B00C0; Wed, 24 Dec 2025 08:48:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C94E96B00BB
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:48:51 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4F8CB7141
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:51 +0000 (UTC)
X-FDA: 84254495262.23.0434C0A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id E0C144000B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:49 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KuY1u8Rz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584130; a=rsa-sha256;
	cv=none;
	b=zQzpk94775OoK+wRKfXJCsMmcALGpfYrCUwZjMbqni24wXr3ZGHHOW8H7AuTE9coszLxKR
	lfqmj8QALck22wZjqI2et8fZgFTeax8vm6P5czFokyk7GbZTpSpL42Vv1hwS4wbIeVdJGc
	UZJ4TyNomckgFIqH3VJZ8KF88Md14BM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KuY1u8Rz;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VlqOEIUZYj0eLijTdCIgJNLNuXexdin4tjYUP/KfQoA=;
	b=FFt/fyPVIq/ydtqoXcOGur8SBIF/TH9EJqnPbFvgHXMXlt+18v58L8z8Ed1+ste/Lvw6Xb
	9nJyGXgERpFdSLL27Z3gmL655O+KmN6G/kd64hQVFLcWOCUg1a+JaXTiId+svDwoFkxsPO
	4hsCGEdw+HxDL8t/esILQmkn0g41/is=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02DB7407EE;
	Wed, 24 Dec 2025 13:48:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DE6C4CEFB;
	Wed, 24 Dec 2025 13:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584128;
	bh=A8T9Nt5SRDhTjWCk2XTP9uMmIZ8k8WhHtELVSGlUK7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KuY1u8Rz/vaDMQjR2MduOKoqcP3JJ9dZEbloX6lhXdXVpmxWAzJIaQm3eFg/D27zU
	 lUafuPB2AoUO60eHIuJvuu/m6OXX7ZEEz1Oq8bxROsWzYSdKvSUuUK/5HO71jIMixa
	 4QGfLZwXMeDTLbl/ZR5f7UsqA0/+3ilmlN3S0gTkCDQusqv50zQ6QFshATbiWqw2Id
	 xMidRdd8Ofj9Le4qh6i/2QdArks8ocuNp1MNGmE26zBEUzp9CT8I0OkWU4qpszM38g
	 BYupaN2e+pTopKIZqnKPL7f+wpgqeZV1/GK2kbN2pGJTpTuA6NiJbtWnPELGFGbMF2
	 LnjLg5nkSaQug==
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
Subject: [PATCH 23/33] PCI: Remove superfluous HK_TYPE_WQ check
Date: Wed, 24 Dec 2025 14:45:10 +0100
Message-ID: <20251224134520.33231-24-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E0C144000B
X-Stat-Signature: 59fpgxqfghffbc71u9p8c4xeo716p1wm
X-Rspam-User: 
X-HE-Tag: 1766584129-229880
X-HE-Meta: U2FsdGVkX1+GCmZX2SKsp7Q4SL71vec1d8qGs2xh0Cx9izqy8OSsnTgh6uapfsodwASIhnrXPLfnJWJC2MSN+4KjUojf9jb18w5luOwI1XJ62w1p05lqew3PpLOapFdiBiZnm4DlvjiuKGlaP03oOsqu1yQebTdznCUxpOzmPVPG5d4+EN3C2mhFuDdwl7G5b8lAqbtA78fC9p6LuZTRSX3Acx/p+RKMCgRd+UGl8BUMpMP1zEepT7ph/Q5we3RzzMvdgu9p8TUkDFr751uFOYaqKDLHwYFnnOGlZmFo6uGHShx02I6OmdGs36u/U0c9arVCH8to7qtpmRoh6kurCjkX0dbfiaaR1pqUQmoKed6lZLA0rnTO1bFj+792UQoA81jcmldGhCP7beKkxcxssKD/CPYOhTw2YiEP5E5ZT8z3IEFJtfSWYU2vrT6BP7/0PnXcFo+h3TNOVfo/nYHDhipAUuLHVu2Xfn7eCpyi7kLnA1MH9LXOs1v2ivNLJK1Sh4vCv8Wcxc+X4GetYudhoLuiJm5KW4MMDj1Ragbpj/64sAe2sGZqJ8smIoxKVGlNxZuARVlV641OORoAxNKlQ3spZnDrZey445iaYy3Nzi/7u/bgjN3XQuQsIHQ0nQTqZaVlLv4cpmELfYb9QqgCjV9bRi8xTIOr+Vnrt3A4L4H+Q5aNvMpNioOJEPp0S7zF9G0FBZuoFkG+q5U/LHfEeNyu6fHMx4Fl9+plmm9Tgu5oTAeQrUXCDfWSGdWg7t5DOP3APfgPpT1krWJ+K61+TiHDaI06qf+JVn8EFoVaBNUDltA6rqo6tfGF7SumQ/r3evpQe7QTRZiV//sKroi1DPOFcXhjcAi3C8bCSNZowybBMquEI9GmRSusvarcwNmgCTb40yDShx34u/uL5TkBV54VAJAVcSEupeaYKPb4Uy/TCrvVlTe6zDZvp3SC+v/Ohu9Dh3re++K3bhor3OJ
 tkWyImM+
 o15Mf3qczDX5mx9EwHs5z57U/eI+On7HrtbhUa4DtN1s9JaAQguo338K97dyr+gE0lKJFaMrAcMC5sWEgDYY/kP5QlsdPnF9Fhqx6BWtK3Km4p8uaYWzi88vlR/tMsx9cBZy8Y1yc1xxy+zfLUvAcqlsy2YHajBgyHeL0O9ekwv+YzHtjasPSKGzEMKGir+m57S5kYYnxTzWASDkoVEm11iJWwxSsz0kGj9JJKpMjXvPcOI/iUqdUTyeWyd6yjn4DIdcGIqm5Tf7FP6TiMeEnQ/deVPANGWLUeMMe
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
index d87f781e5ce9..a9590601835a 100644
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
2.51.1


