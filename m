Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F3DFD7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:49:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E510E6B00BC; Sun, 25 Jan 2026 17:49:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF9C56B00BE; Sun, 25 Jan 2026 17:49:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC8A6B00BF; Sun, 25 Jan 2026 17:49:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C003F6B00BC
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:49:01 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DEB359604
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:49:01 +0000 (UTC)
X-FDA: 84371978082.02.6B49E30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id EDE20120009
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dy+BYVqw;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIlOylRFtrz6Y8aHaeFollDw8gct1ZUfoZOv83NSigE=;
	b=KO5Q+HdPI1juyRbjaCdndrxfoM5fvCjVSnET2fopXnK212CfdxOnNGU+D0EL1KXp8IoP5H
	NBKN9HhEQ4mR95FmNdeNuuEvn6Jd9ELuk7YyL0ce5NBbqLCn8fCUII4pfq3fVr1UvNEBeE
	Zbsc8FTijzUCCHw3xbF48xbChAGSiUM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dy+BYVqw;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381339; a=rsa-sha256;
	cv=none;
	b=ihJ3Bn1Tnbw4QIrgZ/RDtLkO5PMqY7ALzws4jdKk7jW9poCV1sjrYynUkMaSwkHpIaxDMI
	zOZr2h8rfUOO/6pBLc2qF4MSn5xf5icPisxmHM5PlLqDVS5AHi2PSNXA5UMabCOwERMJQr
	MuMxtPcCRtqN2p9FAq6IEPV0tdNU8IA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 81678600CB;
	Sun, 25 Jan 2026 22:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCC0C2BC87;
	Sun, 25 Jan 2026 22:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381339;
	bh=WfH/BEHCO4tRBNYS6k1Vgh28uP7HnVhy+PmfS91LOJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dy+BYVqw0O1s3QzEYM4MR0fWTzp73RlR0LyB9A3qFhaAGl2AjZYyLqdayLPZ6+ZpB
	 +OCmoXmLP8MVpzqAZut5Agy8D+dQV7n3FDSaTLgi41yvwbAuihWDqvu9bRdBTYPodi
	 wiPuYBJa/anYV7B+xDhqeA4MNx8kYCoLeeHbIc2DwSDEXKhk9Z+7h9K6Fx3iviWf9r
	 cD0SQWzB0cMMDrQkjo/GFn6+VWjy6wDJzQDrdIqBOKGXoeLHTcGqCIl6B1Jyir8IKN
	 XfwCqNrf2mTF7oMnVsNUtcv1OIFle98VrKLDs6/Jv+T4vuauRvPtbeqHamJTLYtmZG
	 7dk23P8wx9dWQ==
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
Date: Sun, 25 Jan 2026 23:45:30 +0100
Message-ID: <20260125224541.50226-24-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EDE20120009
X-Rspamd-Server: rspam07
X-Stat-Signature: 4w9s85b4ka9kmttb8eu5anxcriaxdkbt
X-HE-Tag: 1769381339-59206
X-HE-Meta: U2FsdGVkX18ObNfcaIB6q2KrmtfipG5DA//6TVWOGevVwtWlN4LVKgPdSj3S7yml5SWAj4vcKfgRO6C4MQ/sH0bnyUOCmuSzJtPcIGHrT0XX1lVhDOkMmxvTgVyNdVfqdOKZ+4eKhoDpudlyF/kXhtQIhBoZ0fD4NhAPw8sU5OkalD6K5W8irwFzM4kpjDd+EM8385UawBTH6AaTcDu4px8P8sS0hJrCRcbBxUmg4T6Et5FYDdpMVbOSGthlJOncWQU4LhTZFG+PVonQcMOvdNkddPWuvQQjIHIU7mJUPP1lrBHXSwsapt1PdXUBvKZxEc7gJFiY2y9jb/9vEoj9BLZKzTGXfyKtzqbfmJHj7UmbdlKtqNymKWt31a+nW68I1Kzj9AqJ862Mh1fcO88klX6saYU1Io4m/poRDtW1I62TiiD/ESCAXkTHJgFt/0HahaF52h1hpxCeYOYuUnigqD1LprL/Vz8ZjVn57MIZApOOxtBCJWw2sV904qHaJMSmCi8yiC7tWNfIFuaBpiiie87zrbHGnIFqN0n68vEoPKcqo0ggMCtWoORXXUo1wPkVVESB6Q5NcXcFw0G+sm5Ls3rqAyZdc6xMM+UKxcUumReP/3L9d8ypPa7WplMiG0uyIVkebjADe4/lkpjDxm4MpMpDAvPWZtXlRkpIrsYr/n2y/S8pAC79GRsFbSV1WVJp9cJ9lF/G/M1kJaVcGOLplOTluvjydERpeKC2YXL3TnvH+ZMpDfswyuL4Rkk5MS7/s0RpAtSdZV4Axhv3EvDGDV2P7B7zSd3hf7cJu87k9ahs1RvCPftFS+SCLjnU3y3434XVX+Nr/FP8tU+vRxCYZAb+ptzw5AuxOH1uIVj62BDO/UqeuVEq6Hcs4ggmWoIeWLL4in6W/s1B1AsXoV/vSQVWPWhFttY0OB1bAhUGLQO6fB9E7V9e4nAw4+bSkAxh+fCeKzRbo00FPc6jtlA
 +ZidzUyS
 +VcFQqZXXXfKJtOG3L6bIlY9gkwSU1W6Vkmc/7OxU+GrfvBajdEc2LZZn+Zy9SEjr257pfeQEDFCzhqrO896Zo7iO8VP1COe67vgak4zQf8tfKhDe2LGFEf9axAr9ZPwHAnUz8e9n+E434v74r3UI6pUYVYmkWvvu9+ebC8FNUoP3/W8z7b9QrqajoLoFg0zK3ZdPInqUFGOeljiIgt8knlcVByN4LIeNIPyh27KbiBX1xi/2ENFEIiN1shkTfpLxvNjdOGtBVXMEFBcGPUJQYsQDBaZcq4qO75Rn6jDXgPf3qcDjplXYJGmqBg==
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

This means that HK_TYPE_DOMAIN should always be a subset of
HK_TYPE_KERNEL_NOISE (of which HK_TYPE_WQ is only an alias).

Therefore sane configurations verify:

	HK_TYPE_KERNEL_NOISE & HK_TYPE_DOMAIN == HK_TYPE_DOMAIN

Simplify the PCI probe target election accordingly.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/pci-driver.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index b902d8adf9a5..a9590601835a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -384,16 +384,9 @@ static int pci_call_probe(struct pci_driver *drv, struct pci_dev *dev,
 	    pci_physfn_is_probed(dev)) {
 		error = local_pci_probe(&ddi);
 	} else {
-		cpumask_var_t wq_domain_mask;
 		struct pci_probe_arg arg = { .ddi = &ddi };
 
-		if (!zalloc_cpumask_var(&wq_domain_mask, GFP_KERNEL)) {
-			error = -ENOMEM;
-			goto out;
-		}
-
 		INIT_WORK_ONSTACK(&arg.work, local_pci_probe_callback);
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


