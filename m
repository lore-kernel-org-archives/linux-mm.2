Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3785CCCF9F8
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 21:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96AB28E0024; Wed,  5 Nov 2025 16:06:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91AAC8E0002; Wed,  5 Nov 2025 16:06:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E3448E0024; Wed,  5 Nov 2025 16:06:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69F218E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 16:06:43 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CEB1F1602A2
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:42 +0000 (UTC)
X-FDA: 84077787444.20.80E737F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 336BCC0009
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 21:06:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uTniV3S/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762376801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kdYXpjjWsK1USuQxWpC3xY3I0EurRsdv37SZ4mQBI7c=;
	b=L886S5eXcjUrncIvzX1WVwyhPgdF1tIkKyR3ybVC2MD+HcVt2oxGWF1h8MhKCV0Q0Q3DdA
	ddg+zBB7wlfJ3uq29hlvyRrE4Qy7IwsiAgvJh4/ZrHPl6zw4VBxjPsbTTLa/naOL2asqtt
	IlNTI0ilIp+sx4yjJMZpTITljMGYU6E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762376801; a=rsa-sha256;
	cv=none;
	b=jN6bftZBNf+j4rPxO5c4+jOfiqaXuVyEB/YQSnwVU1w4IzOUPLCgJR5c0AzKV+TYkJytH1
	urlb/ox4TnjKccjBFDuWxqQFDY6Q/MBu8R3EHx8JrQ3wNrxMTd3JTXlTh3Yi9UnB9hwm0x
	iuGF6VtFRXVySOX2yFGavUONdMhmo44=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="uTniV3S/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 84A8060222;
	Wed,  5 Nov 2025 21:06:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FA7FC4CEF5;
	Wed,  5 Nov 2025 21:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762376800;
	bh=fIAIlX7FO5mGPQBGWuCynXC0SPKY4AIZnRPcce8YI4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uTniV3S/EeJ80AND7KBDsXu8Xpe6JM7FMSiWlVLuYUSx1fZ5Es85QML/UqcAKlExj
	 TBu3d6jiTcVnPTUg6trXffi1yL6+pk2kHaXc967OfABBppOpNR5YB2toKuWySjNocr
	 1Ukzr9rUGpHh4p8j/EIRfYT7VJZihm/gISAZHj3geJ0Xs5YxKq6o19WtZqjCQ0TkpX
	 c51eNX+XGOtADtu9WKoX3bLS7Mi06TUMXagWf5Ke6icI1nHCDIn0D3kNee0ZMbEPHH
	 HWTE5hGnM2szJSqgHeTuViOa94S94x6lb8KEOyvrSQxjXsBjNj1jUHxi04XQhFi5Bm
	 DVfpNf5l6u1aw==
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
Subject: [PATCH 20/31] PCI: Remove superfluous HK_TYPE_WQ check
Date: Wed,  5 Nov 2025 22:03:36 +0100
Message-ID: <20251105210348.35256-21-frederic@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251105210348.35256-1-frederic@kernel.org>
References: <20251105210348.35256-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sdhzszxd3if453ob5346x7aqx75jhw57
X-Rspam-User: 
X-Rspamd-Queue-Id: 336BCC0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1762376801-671154
X-HE-Meta: U2FsdGVkX19TkEMEChG1FjQuvLHIz+oDcLP3tg25bpjlketZx3TLbzoO3XJMqcFCg5NKyrqJ7eSkVnkefhcSZqO46A+krssmdRDiCC6nlZCtl34+2gSVDHrEpPkDCfTEW2Gkz2c2rF38Wib/1bAb1l5olgb0XTFJQfHcOo4Ga4hzulp/jUtmv6EUF69MiTB35abMsap0t9wiAZeVkKyBZqUJ8EJg4xXBMsvmjsGF6xHPGXKjv5/3s0tQgcfbCxR3vbEeTR23+u/3j90pTn5uS4f4GtGKJIn7LMx8+KX8C9cK8wZ5H499uOI/a0iDyrAiWVllITZQ1XY9vYWdNxk0z6Y64lwnY6N0gbpTUpKcijjvKaq5SBVvdwAwkuwlYQecloc2JMesk651z5Tep+a/jU5eveU8KTv32QMXhSPj4+L2V8QfnA0af59SQBfUqZj081GBiahiOQ6bPZjEVDYoQM7seTX3Rjb5F+v1sVEL86V8DZMz8nGjwaZuC25Zn1R+Wr+Uv+trEm7JRZNFPym7D68YBGTPF8LYZYApFthL6CGGzKQjOT4itx9nJy9Ryx58+CjdpHe/EWH2AvR372VpVB1n9TmxsZbPM3bJvPNryGLleggPreiAxOL94q4NxRiEEfYcHYLIdpXaA0pbGkUifI0a70sSZkQq/JSNUkYyr1luarMDZ+BINyc1Th+8+BqANsvw6q1aby4/m210Y+VKIpEbvgiA26LN2HDoC1K4Y8QJrKVZIqLyGaajA3hS/T4lkkM0fya8d/u69mO2AozRXASUeiXvghyNncEiml2ifXCPdTiCa+8E/TmCLSQoA85WSHf/ftjm9LmaO8rx/4U7AFlapr3KUJ0w1QFDqFQF70x0eJcxtQIF0rrhTF7UOsBfB0FK4QG1K/CxV+FPNdFQn9uSDx19MWdP+x/YiJV3UPYDsybehw0HsRrlq6RINbGeUIRRvTOgFyfSuldWGIv
 Mp7KEejm
 ontl8JuO0StbvScy9ZJNam6Zq/J92w5Bag13acO1ugzuja4zomgBdsmfJtMG4wrDHQftm0gQJRcpc8RThhFLjKM6ddI/HL0kB9WR49uaohiyuQvueuDPS8ji0pbgJ2h+ZsTP0NQOj00QAc1d35Bo+yV9mCuBkMknkk/wQZ22eqyO7sj3dbPjukf6xTsBlXkt1T/3qEdB0KbQ3l8aZyhNrMFlDpzm/i5E/1xnS8fDx3jXYdZ1CBLt9HkMGCtrinOSr0+OtQtYtpk7MTj9aHNwQZV7ahQ==
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


