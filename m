Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED2F8E63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6080C6B0092; Sun, 25 Jan 2026 17:46:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F04C6B0093; Sun, 25 Jan 2026 17:46:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F2AB6B0095; Sun, 25 Jan 2026 17:46:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA286B0092
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:46:28 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F0FB08B610
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:27 +0000 (UTC)
X-FDA: 84371971614.14.3421220
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4E32440002
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vya0JZRe;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+NxPIB+sKOAQabBh8M/jSikEflAZ+lcyW9sJi6TniPc=;
	b=SbMOr9t7sMSb6iqHRtBADBQwdd0BjYHdr6+xner5NsM8ytNtAXQv6qxcM9nqIP6KIkMnsj
	PuI7GUsX2MTM0Uo6hBvQLv3ug8vAh+K/soUthi4hre6AD0GV3YcN8IuAzXqkJxvP8oJqVL
	ZesFHnC0JpebnHO7tKe1VcH2RfoNp6o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Vya0JZRe;
	spf=pass (imf11.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381186; a=rsa-sha256;
	cv=none;
	b=6m0g6bFxV90aMtrQMEUy/F5/o3cONqrgDiCyF+YeYVT8XEZ0A3dvi5Y0keg1Ila8Id/MeP
	pGVWRv78u0bFFu24LP6OiFjhN/KPnmJ13DaoFJv8AnZXBfcC7lj7fKeD18gYyhk88NhgYn
	ESlyeHsL+Aje8LiNa2+jstkaU7WYPco=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A4CB40255;
	Sun, 25 Jan 2026 22:46:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB51CC2BC9E;
	Sun, 25 Jan 2026 22:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381185;
	bh=gBHkj0y4jQxeMV2qzbEciSScfrXq1yZennkNx/2Itiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vya0JZRerX6XRdRcf+3ZmdU/VAEs0kDelL44rPDaZbuk+MvP/g/c9RDBz3cwK8BoY
	 RJpqDdp3lBNV9gvBtq9dlULnElIRSCM8Z+CopO4Ea9g6llbuGy+G63Wj0iiJxtbkIJ
	 V/QGhA02i88H47QMfQ8qzNvuiNvyd0ROzYl5Vnjc/2bAW5o2ZkH+2zGUY4dk7766yu
	 L9cRZiPRF+c/XXRBcW3h7By3oYGAZjVTS4iymb87J/ESjS71Q6dPiSD2CcWX4s05ii
	 H6etrU7Qh8TJQVkTFdSCJCTwcVkl1DsOcbVuDcGZwbYaQiS0nykmw2se/R0Q65O1Rk
	 RkKVvaqqzrzUw==
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
Subject: [PATCH 04/33] mm: vmstat: Prepare to protect against concurrent isolated cpuset change
Date: Sun, 25 Jan 2026 23:45:11 +0100
Message-ID: <20260125224541.50226-5-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: j44qwmgs1i4kikxkhyar69cz68b39c1f
X-Rspam-User: 
X-Rspamd-Queue-Id: 4E32440002
X-HE-Tag: 1769381186-135872
X-HE-Meta: U2FsdGVkX1+Wkx6oyTDglr/pJBHHamd8gWmyqqslrK1mZvS0BesraYDdnERsOpU8ViVf9/BAduZjfSaFN5qTyxE22y7NaEvASLECCaoXa/XzKJoEp7ZwBPqZqsQSJ7Ozbmhv9/B2X/lZ/+fSVL5BWVGotFVs5OmA1y25BSCdCAURMF8qqC+kWlClQ/2jJdKucHduV3wAtuPbdfK3H6gdMqwUCVwqinFms73ep0R0UL4F23adr/z8LHeaEAn5Td23yK/vd965+DsH8j7zVfev6bI7aoz3M5L+LeDctsnpO8i8kUi2zsvGxdWZjDP2gFSRn+A48MPUJsKa/VfZdnITmG3m+a5b5tJCylL6j8NELGBzGii9Y9p/bDYl2u3xBeItp5iYCCBOlpLKs4r3zhYrk0cs/+pIQmcikA0PbKomEBEcvk2bNs4mUF3UF3oXFKh6AE9xvC/7okYW9JWEVuHxleTTPR1fl+ZT9H6zntxQW+O4uTyUd2tTrakzssGN2b5OGKWOrgvh5FVEKssKVgt3j3pYa1LzglSHA2g6C5qMT5cSTRWCeUvrX+P96l5ymqfgFmHrasXA8gCsqrmeQlvoa2xVmotDy0CDSk4s1BT0lCku+twVwKiXo63VwI7leXpCgM3p9WRS3DvxZpeXZvpwOMxapMUWdObhrAkNY7UTuR1Fbx+YtwRi2LWjTp/wC0VP0gwFW54QjQ1lRqZLXvHNU/RoQFyAvBPJ/sic3hgA+FMyc+pQ5Y2aLK5rLzqSZZiEGIEtFU7rxD/7RsCvPL14fBrVuOrr4I8BPRzOlZX9b1iANjC6zjUGwHCUdJ4yAnAEHXI5QVTvI6cvcF4FBI7yGbmgC4kDnmaMJsvLeXH+8k2LVnQh9CpqiYCwHkbWHyhqHGFOmBwTK9GW0YOVJGZdsDZGalLZVvgPITfjs0KTClAd0X/LU4F7sRDxg82Fngef4kJIhgVUlUXO5KHP2jI
 tWpvanQY
 60ZPICWyPa1cefptJMg4lqkxXBIkHbF/W8e2uqf0HQvzYrqUesmihsfERftAG+HuIqfGLu282FjywMf3y6qBF2rjNly+BPIWLSSgCeOUorhdzUfuEpEespNspxpDs1GYYcwKxyF4BjUtklyxsVjlSGEJEbqBeFoyQW+2cGbAkkhacAUzctXZvC3AAkdNHCC6JbxzKObgxDuKDzVMsDWH4BvPXRFU5YvrusI1a7OQ08HuYg8a9uxnpE4K4RsdQTEd4Yq/VsKF9ZPNz2rY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
runtime. In order to synchronize against vmstat workqueue to make sure
that no asynchronous vmstat work is pending or executing on a newly made
isolated CPU, target and queue a vmstat work under the same RCU read
side critical section.

Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a vmstat
workqueue flush will also be issued in a further change to make sure
that no work remains pending after a CPU has been made isolated.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 mm/vmstat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index 65de88cdf40e..ed19c0d42de6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -2144,11 +2144,13 @@ static void vmstat_shepherd(struct work_struct *w)
 		 * infrastructure ever noticing. Skip regular flushing from vmstat_shepherd
 		 * for all isolated CPUs to avoid interference with the isolated workload.
 		 */
-		if (cpu_is_isolated(cpu))
-			continue;
+		scoped_guard(rcu) {
+			if (cpu_is_isolated(cpu))
+				continue;
 
-		if (!delayed_work_pending(dw) && need_update(cpu))
-			queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+			if (!delayed_work_pending(dw) && need_update(cpu))
+				queue_delayed_work_on(cpu, mm_percpu_wq, dw, 0);
+		}
 
 		cond_resched();
 	}
-- 
2.51.1


