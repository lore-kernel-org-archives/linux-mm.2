Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89674EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFB836B00BD; Thu,  1 Jan 2026 17:17:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDCFA6B00BF; Thu,  1 Jan 2026 17:17:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E09BC6B00C0; Thu,  1 Jan 2026 17:17:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D063C6B00BD
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:17:24 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8DCDC141587
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:24 +0000 (UTC)
X-FDA: 84284807208.24.565947B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id D884D140008
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:17:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nc0F+mQs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305843; a=rsa-sha256;
	cv=none;
	b=Q0Uh4oVvFsP0IjCYSKkT514sTBJHH9DZeaXqJ93x6F0M8lN3ULLda5BqBeRGgnJPlejey2
	1P7hLq5gQ/ncS8bmIGy4bPhrEzZJ3kB4YNz/o7jhwVzmmNrvTqPY/lDtQ/s/x4DsdFW8KT
	fa3BINCmSgIzdDHOuqvVk1DhnMdrhvk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nc0F+mQs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9I0CNzOKtIIHiRH8+FaXviFQpi5fZ0u5MyBP4xJHH74=;
	b=mvYZkRw3mIL4cP5k6X6cQMbn5wonoLXCLuaP5DZ+kT8gZabRBn81uPT50OSzFrr4XuSMUa
	ael4gbTMKPXxG+c07tmUD1+lFdT4bEd1jw0GOY0HN43CZV21dSTdTZGD/1YTj5cIN1PSc6
	4RKVZDb2DfFKip8SnLcAKK+b1ZKLRTI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1485343A0D;
	Thu,  1 Jan 2026 22:17:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694CDC4CEF7;
	Thu,  1 Jan 2026 22:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305841;
	bh=BrnLJAuZFcClCQM0uX4BfjC7tqOUNhvTqWQot+DI0W8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nc0F+mQsr+cgVMYnh5k6lAsn2xDmg+rX1K4udSpWNHPUAsjLU+AN4EETfnsPESYPZ
	 xXDcffmnrKhDT/yVw0aQVVpwsfwuQu4uB/6170eI8FK8Avs9N2xCcfrezsGC3yyBBj
	 HhQrRG4tH0jPrOPbSHUJpaKzAWGJQ2q4iR0dPMKcNRn1vNMk0LhdlT0RZJOWbofHEi
	 8g4NUiG/Z/j9QuKQCwRydQseX7NAJNIiqExcLqQ+e0/cu0VxKZIee5SD//+2BZ6s6j
	 qmOvrcIxbRavzymbWowbvrMis0Rew4MXv1vnJOmpW5s9b63Vsk7eW7lX50Eh5pmQIX
	 97TPVFj1WXptQ==
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
Date: Thu,  1 Jan 2026 23:13:48 +0100
Message-ID: <20260101221359.22298-24-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D884D140008
X-Rspamd-Server: rspam10
X-Stat-Signature: rjh7xpfe3e1iqdmosawi9u8u16b8eir6
X-HE-Tag: 1767305842-988352
X-HE-Meta: U2FsdGVkX18QkFtcTgVaJRKkatiKg7j4bV8cy/6KSgoNezEXKS2zY5BckbW0Klhdn00xu+RjQVw3Rpm073r1QyZ3kbqvFApU6KnGwMijxL8+KoFGBWJxRH8eqelHaEILQ+Sn/hckxTt5cwq/h+NdlKLPE4L2Dfqwq+Apy0BTN0sQJKA1h508wT6wG6c86jC5Er5mOmTWtehYtSOaZ7sIP2nh7xvkiLVN0U0Hh5eWTHIyXRwgQ0ri8yA8ajIws6tgYiU9X/WLIxg0g/mrvM+H9kfZ+NV+i/nBcA33WDk3XqDr5I7ENqKnl9h3yJZ/iZXoJScaNqPjug1feSRV68kBkNtPeR6BB0QKa8JYJdgNH9nynxuf06d48FoyLw2XYZozjO7wL3A1VGS9jwX8dpz6jjfdkSS9cZ7aYPFQWplYOwnUE0lkmxWM2xSMR7ZPQZykrglkjEbeejIbzHNPkH3z/4Zp61Ryg/yyTdA0G8qeYIDKNRJXNS8NMCggxaP78xU8y8/us4KsEASzhfqpRWXF95pDWcSSaSE05K2rvyFpmbF58CWYsO1RDGPTgXOzU/XozxJOA3StlB0fHx6VpgxwqI0/iPzl0kNNFhamsWkF/Z8ZbKEu292wZj+TfBYAcHhxQ6wzMB0Mt035Lz5D2Mb06qzgw8JsiMPSBtOfBtyw3Eb9CYnvuMonLTUWppwwUqWX0rdZoEeIE2w8H70HGianJgPGXQflJVVv7iFPMpqUEGgS7S5QVkoKkdLFzemckmYfM2DHJtB6lZ9MGLmdbQ0FR5JT5aGn6KY+Ioempd7PExXVc3BoWGqzlL01e1asBoLX/7FW0kH6VmXORlqitHq7Py5IXYgF/EvuJMCfNvevDOM220KJ/6m5L9JYDKYmDwY90nET62B7lxgWjuX29+OC4XQJa68NB6vlynbRhh6odKmiSShXbg+owLXk3dBhijxQriQDV3uGTonqIhb/8xc
 xgNYMO50
 Bt6CefWU09YyFqKFlK9wDCnwMVJI9Ftw3vmOJiSqwMWtTT8K9vGbgMTVG0X80XOg4srufSl9xnamS38MRD/MjXsKUrQNJ5wqOLBaf12zegqRQDR5ET7OLKdT5MHStTKg0heAoGB2nGu568JRu0gv3aUBnV0XIqqz0J2B76yM5D8E46EaJ5CNg2KRe3ZiIrBX86ZRunuzqceYRXWbFJHd88Ql/qwlpZ/OvK7oHNe5CRGsiu74sNcc1yhvVm3qoIVpY5yxMsd8Gy1stKF5WnJHU6bvaJ1cOzAXF2a1g
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


