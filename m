Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C25BD7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:46:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59AEF6B0095; Sun, 25 Jan 2026 17:46:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56F156B0098; Sun, 25 Jan 2026 17:46:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B476B0099; Sun, 25 Jan 2026 17:46:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 385FE6B0095
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:46:43 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08C3C1394F0
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:43 +0000 (UTC)
X-FDA: 84371972286.03.ADC65EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4EC28C0008
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aGGZML+w;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6kNyjpAty5pqhw6oDvuv7eYRraJpy7CkwduZRvO+Bw=;
	b=LxkK0v1rZeR9t5QbUF+JOWIeKqDF2donpZSsRHwaonWsBKZZ9vTHm+OLO0W1nokKiq6CSG
	9n9Yl1yT8pA5i5EBp9gdOMd6C7B/yVpS1VMJtgKMUk7JAcs0s+KrfXeijpM1AjJ7HRFAwg
	HWlQd+cbPZj93ZfFEBeqJ2CNBeEjWmA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aGGZML+w;
	spf=pass (imf28.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381201; a=rsa-sha256;
	cv=none;
	b=UBhchgDMUp1wXLJFw/wSlY2Ghp5OPtmp4XvPtecHIUK3pn66bCN3SkviUivQTwL/z0keCR
	4aTKhwV1YT0+aI+mZgD0gR2UgQOEzZ9rqvZKsAQtA5aQWqiFwKWBWIe18sJcd7nRA3s0Br
	XcdxxCVcxoXXcZ76bPp2e4NTUmvcYCA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 710764183E;
	Sun, 25 Jan 2026 22:46:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BBBC16AAE;
	Sun, 25 Jan 2026 22:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381200;
	bh=pTB9cNPcvPakmWV9jutt30tCCHfCDIAA9k4V/apVATM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGGZML+whxH4c/xSgMhk4FEyW2E/CWTmGwSjAzdR7qsacQp3b8hfFVgE447fO9/dX
	 IQEJn/vgUpEZUS6tbTqkaYXfkNrSvsbqHhzEPX7xBth/mnWW+3tJvuHvfKvQAC/vVG
	 vEGDolxnjONqPuiKrBNoysiyVqrAVXx0eEqiEVlIdaL6NLKgEAffKrWTi9riHYAikG
	 /hwF51Wz5CFt4Ib6YpUG2jmb6nKt1OcFQptXMkoStma9Z1bi3gqYhu3s/Tvf0YtVar
	 uzE+IeGNule8/0UK3WlNJWV0oZ+AhujXHcgsfp5fecQfYHKx32nJT/uyqQWy0UYujU
	 CYmtYFJauzfgA==
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
Subject: [PATCH 06/33] cpuset: Convert boot_hk_cpus to use HK_TYPE_DOMAIN_BOOT
Date: Sun, 25 Jan 2026 23:45:13 +0100
Message-ID: <20260125224541.50226-7-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4EC28C0008
X-Stat-Signature: zy474acf5qmbwaq6gwhnj5js4y9zt5er
X-Rspam-User: 
X-HE-Tag: 1769381201-736576
X-HE-Meta: U2FsdGVkX19y2TtN82mOsvBz4DOYEjvTlubRhn1A2xvRPk6nFMzV1Ji5ybxJxToVgihrXW9ekiu+PzFcZh3P3kFSTulrHLtcUWMP4mG4nDKQmEgXUa4lMqSeFbV+E3CgfzqOOHFwKO4UG7FuOlimZBOr7WFdlppkVMgGsknCVew4BwOIIAENRM+TiaAUBWd0+AQ0KfL58pawxr04B1Sj/ET+MzrXR8Gj/jccbm1s9KoGwaZxQDHh9Ilwi5lgHHF0ugxHpC6zY5XPfdnBl90SF3zddvwIi/mOmW08aFeocte4vwCRZY+U3Bv2FrrnJC0N1rIHKiqjwP44UWiibvIsSTBTS2nMWMd3t0/lvWYfkSJrFewHvB138F2ropPUlo1HAMtwREvoMBPDIJRoMuizAtaJAw2++N3/9NvA2OMyJykCYIHJ1AInrI4wbJpYJzF/Xmkosc4FKYNjMnNCQ6vXyADONpPXwKwtBO68FKhRUs2r6CboDX5zVdty9PpUwXD9ofbe2uIiXyFAcs+M+1RtTSjFoyksr3LW7fvNdWrBVbC1KgSEaVL/Hcs7l63na6XYrV8HfA3BkkUpLq3NxQmabx3czCgV3f0iYzjeeOrVsX4kfcYfBNSKE3/VS96C7rtYimlSl/G2imBM5dn6Igi/QgJDsW5XyNW+/O42YIMFYXAVJgKb3TxOiNFd8iUXoZUgAF1gQSSMuqEqg9VHNHT1Xp+SPS8vUQXR7zKt+UIfTdXLcyNiGCH3jFpjxz3OddOm1qg1LXhV3MBJTy+6XmahLTRA/dWtgsFFfpIfixUWjhcb1avdMyLOvLZsLyhiwwobhVyus0BSX3bO+BLnXyVWjyElWqCcCssQ2fUzfT4+X6fxYYd8uYpYmRKkdduy26Eq65428TEQ3764Dw8Q4FxaCo9gr9/RAsQr4jPM8nvoDBlGXHzsWazPoUSycYZISF7GsGCQiN2/ahn924+/TTV
 1QIQ18h2
 p3jYJhgwQMZ3GWTll+DRPyz1+rvTqU9CZnuCH7AIhRw9J+W+rvAAAIFzalTTtAqhD99NRNKywpZGSrVmyIRzxioG8bH9INwi7JSsmQIemoWXgRS0DlzXBoonr/T4nzjCOCzmYwl+95pS5xSl/56NlsNlQU8xShbo/osZbVm7ZWHS/qxzYOghhop4AKquid7bmuER6eqEJSCp0Im9nsrprFcB3iO7hG4c7AMjJTFtIlObzosHmz5UK2lXEM69BhtwbfloRiiLs56sk3aomyXM3DZjOsnxi1cW1P9XN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

boot_hk_cpus is an ad-hoc copy of HK_TYPE_DOMAIN_BOOT. Remove it and use
the official version.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Phil Auld <pauld@redhat.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Reviewed-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6e6eb09b8db6..3afa72f8d579 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -88,12 +88,6 @@ static cpumask_var_t	isolated_cpus;
  */
 static bool isolated_cpus_updating;
 
-/*
- * Housekeeping (HK_TYPE_DOMAIN) CPUs at boot
- */
-static cpumask_var_t	boot_hk_cpus;
-static bool		have_boot_isolcpus;
-
 /*
  * A flag to force sched domain rebuild at the end of an operation.
  * It can be set in
@@ -1453,15 +1447,16 @@ static bool isolated_cpus_can_update(struct cpumask *add_cpus,
  * @new_cpus: cpu mask
  * Return: true if there is conflict, false otherwise
  *
- * CPUs outside of boot_hk_cpus, if defined, can only be used in an
+ * CPUs outside of HK_TYPE_DOMAIN_BOOT, if defined, can only be used in an
  * isolated partition.
  */
 static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
 {
-	if (!have_boot_isolcpus)
+	if (!housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
 		return false;
 
-	if ((prstate != PRS_ISOLATED) && !cpumask_subset(new_cpus, boot_hk_cpus))
+	if ((prstate != PRS_ISOLATED) &&
+	    !cpumask_subset(new_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT)))
 		return true;
 
 	return false;
@@ -3892,12 +3887,9 @@ int __init cpuset_init(void)
 
 	BUG_ON(!alloc_cpumask_var(&cpus_attach, GFP_KERNEL));
 
-	have_boot_isolcpus = housekeeping_enabled(HK_TYPE_DOMAIN);
-	if (have_boot_isolcpus) {
-		BUG_ON(!alloc_cpumask_var(&boot_hk_cpus, GFP_KERNEL));
-		cpumask_copy(boot_hk_cpus, housekeeping_cpumask(HK_TYPE_DOMAIN));
-		cpumask_andnot(isolated_cpus, cpu_possible_mask, boot_hk_cpus);
-	}
+	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT))
+		cpumask_andnot(isolated_cpus, cpu_possible_mask,
+			       housekeeping_cpumask(HK_TYPE_DOMAIN_BOOT));
 
 	return 0;
 }
-- 
2.51.1


