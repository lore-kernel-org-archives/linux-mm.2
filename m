Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C40D5D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:48:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389C06B00B4; Sun, 25 Jan 2026 17:48:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3545A6B00B6; Sun, 25 Jan 2026 17:48:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29E2E6B00B7; Sun, 25 Jan 2026 17:48:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A12A6B00B4
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:48:29 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EC9751A05C9
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:28 +0000 (UTC)
X-FDA: 84371976696.04.0FFBF7E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 46F56C0003
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:48:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WiokbWY+;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=un6mxQlOe8q3MHj28E/nUqpgAYI0PnqFAvHf+xc6wxE=;
	b=Fi9QDgFreEOAnYO3GlBfDZSagxUXQnY+ZgBm8/1O7e0+HyJhb/T/IsfVi85JyieGJunfGg
	+KThCCyVJWzTXyoLrCv688WyGKINQ5yWIM8Ex31Ni4E3AJh+aLWMjpBuVAgksZiArkjx5w
	Jw86SDTA0FF8GXbNX6y0RU3Vj3ifoUA=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WiokbWY+;
	spf=pass (imf10.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381307; a=rsa-sha256;
	cv=none;
	b=qsSTpXT0X9okQw0OhYciv8ND9YPeIg0WIMtttn226tXcgDrJqNuEQZAHgvYAwsqUYHkW14
	OFIHere1oqUeVx/X7VLkvbYAoQp42f4ZT5Tvi64pnC50S9IJnqlduWbhNlsRW1dhT5adHT
	EHToxMTFdNiAtaHIdilNgFexbbrNqe0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 77C9840534;
	Sun, 25 Jan 2026 22:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D7DC19425;
	Sun, 25 Jan 2026 22:48:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381306;
	bh=1KNWx87QTGRb7i2dGJVg+gYyletvaK/k+GQ/bIy3PfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WiokbWY+u72D6ZGtYKo/OejDhCbcUqCRW/Ivk54y8e59YMvltE6LmCSSlZrvA8P3I
	 6533dVvqWDSARpKKhgZXSIH72E2CbBiqihh/IqGhW6IPa4I/961XuV77GnI9QSY3Tf
	 wNow3A9qvtm2p7ZVWY4n8JyrVrgbRLGQklV+793Dg1WHR6Pc8W6pddLNM4lAOAeZ9m
	 fLORz+IDKeCldynaM9+BMlVges/4tcKZn7jJxWhO501pASCEFErJHshoUU6sjNsv4i
	 S2abbTLmRK73kWuAb2arxixwfUPO4O7J2fCOjEHn+OAleh3vPMqvugS5gwfJIcyM7y
	 RP4+wnYr93doA==
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
Subject: [PATCH 19/33] cpuset: Propagate cpuset isolation update to timers through housekeeping
Date: Sun, 25 Jan 2026 23:45:26 +0100
Message-ID: <20260125224541.50226-20-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 46F56C0003
X-Stat-Signature: xth9zhbo7f3rt9rqewbdfjkf53tcwtac
X-Rspam-User: 
X-HE-Tag: 1769381307-17692
X-HE-Meta: U2FsdGVkX1/RakPXSuFANOHRsLgxCO+ZGhFjp0sGso43wgOINUnzIE06nEsYm2EJcrVMvo1btmGmZ/vI3AFHxS/yfCEydU9fsnW0XkoKavS1HjUoIj9B51aNwb6asLdECC3hFJzBaydffoB8/bklnDaEDWTM6QnZKNLcMie1paKyxBMCH52ygjVbZ3cGq2k3HANpNzTcucCnitA7TikmrNm08hVddFrBnG9hzRXXuq+xRNczwGlI0tqz4h8FjK3KzGpcexag4xjVZ8hqglRdtfR02BWsZUG3gwwN7ef8P7rjHoS3XsiPql/hwrykBlX0+opNKF0ZohVowV9Qt5BMmIUr+H3cVK5lVhAHqEZIwt+VnKaFpkW+xk7R49osvJjXCd9o1guv+Ky7EmuK8wKVzXtnrYrN8ksEdg325VXyKcOJ/8viGs25H39BfbAog38rNDdrObwV/ImRV3JlqXTGWsrrB0yL+oUTgc12nkONAbSwa00elKp+YKnKnk5ojHDZqCjzuoCodVcBcrWiWVa2IBqMHLywJWOnRlfr7LyXLVxNh0MRCzDNFyJNCjV3KRXE8cjYfPiROa/VM9kWTTGMxI3mLmnDYK3fg/Cvdp1HSlPW/HoYOlm08qSh3RgqIFcgRQeF17yX2dFsAMEbg3q6s5Et/F8wS/vf80K7/URY9HMhzXNTocMCX5a4La8tesCHHRnP4slQ4wRLaFcoUpzFalHWzZw2ymppUV/HP4YDb/HnJgO3k3Rm6/PInNnPL0N+SZbAR3Y/RP/0ULshfHV9Arq9fUmgnhAmCSPTR7u2HRgtAbn9n88ekuEGzS+a1Tf3qyYU4Jh2/02LMG8iHE1ftquHiYoCsr1Nf3LYhTvy4xy4VEIcBTLSx6ZjJEF5RB/QLnA1e/0Mn6IHUMKDiaskwtkkyKKjc/JfhPN1wSnwWt0OezXs4RJkpSnBWd6d/hRrRGcTDbM6jKZMj4+0UPx
 heEbeYnC
 tiVxlFunAigsxFw6aLnWDKnAFrGUyeuwRsiJmDLnc5StLrwA+Qv7GqgDMHhsmRGKwyQLa/XCsMi6y760ltTBIE9h3NgBCau9O8r8O2mNPJTb5rL62lOGvECrXfBuvk0kQS7Hu0Vpx6q94seIPL4LtaVQw6HwusBJcNQSsEHnbewEAvMInCopqGKCgx1SfLMnTHKPOiYh0dHKPwwujmbmSpVft/6EwDKwUyEvLhlhQXvHdFB8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Until now, cpuset would propagate isolated partition changes to
timer migration so that unbound timers don't get migrated to isolated
CPUs.

Since housekeeping now centralizes, synchronize and propagates isolation
cpumask changes, perform the work from that subsystem for consolidation
and consistency purposes.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/cgroup/cpuset.c   | 3 ---
 kernel/sched/isolation.c | 4 ++++
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 6309ec5d7b2a..080fa2fb10c7 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1485,9 +1485,6 @@ static void update_isolation_cpumasks(void)
 	ret = housekeeping_update(isolated_cpus);
 	WARN_ON_ONCE(ret < 0);
 
-	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
-	WARN_ON_ONCE(ret < 0);
-
 	isolated_cpus_updating = false;
 }
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 5bcb6d760f20..a30d19b641f7 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -149,9 +149,13 @@ int housekeeping_update(struct cpumask *isol_mask)
 	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
+
 	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(HK_TYPE_DOMAIN));
 	WARN_ON_ONCE(err < 0);
 
+	err = tmigr_isolated_exclude_cpumask(isol_mask);
+	WARN_ON_ONCE(err < 0);
+
 	kfree(old);
 
 	return 0;
-- 
2.51.1


