Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC223E75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DDA96B00B7; Wed, 24 Dec 2025 08:48:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4911D6B00B9; Wed, 24 Dec 2025 08:48:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDF56B00BA; Wed, 24 Dec 2025 08:48:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 298B36B00B7
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:48:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED9F8C088C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:16 +0000 (UTC)
X-FDA: 84254493792.01.597CF74
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7700BC0002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:48:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DzQOLmNe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584095; a=rsa-sha256;
	cv=none;
	b=PA2smVbCQ5/kcmlOkNaYie3YQAyALv54s2gTfLHyC/LaoQ8/+cQ44Hs/1wV9hFmrI+UTl0
	LZGp1LhVFgQBPGYjvZn6783s8njiP1r8Ez6mn5x5/hTFAtABLAPNucI9zYV+3MR8wP3fcB
	VayLTfTepimRTOEnE7io4n04PYuoAHs=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DzQOLmNe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bkAzbA5ueoGEJ4U/Zdzxqtdvla3TLonTUIGegnDQ6Ro=;
	b=SBi7OqFvPf0nUQRKdvlvdozIkeX4L0QTzcY16+FjD1XISGZWjpQK8sMWfPwV5f32XMVIYd
	mJ/1Ac26509fcKNz532Grs8WqPNmNQs8KEiGopZkUQr/PExgqTaMw8I7V/0eQG0rng8JWU
	p02WmGLb0fH3ino0R07PyyF5jWPn958=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0298060133;
	Wed, 24 Dec 2025 13:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F4CC4CEFB;
	Wed, 24 Dec 2025 13:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584094;
	bh=g07phPGG/Oy0m05V60X9C22vXitOxGspdZ/J2kDb5tw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzQOLmNe2ElVs26zpy4ezuaRwXGVH+R3stciRsBWJLK3UC5w34inc2T1/EwdC9lFE
	 fyFiuQahU2FvodRmFXZ9ijmEeJTHKF0Yrj/Q6DGeG2newSS1uUJ4GvRqcz4p9Uy79A
	 KRJjyRKu7Sah7jkELphRWphjVnGuhoJZqN6v/aJID406Re2uCtndE0NAvaionA7PgN
	 ySgdtzsXpdLvA8Pn72STWr5Ug6rp7Tvxn1Wpf/7S1CYDrfJGoNZ0TJdyYvRfZx8ZLu
	 lXqXo59WpBnc9ZBjGMDalkqCjnlSnb/30eoplFozEe8MJ3ixwjIIk2oD7Xyth3S1Uu
	 5PsQG1Bnax0Sg==
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
Date: Wed, 24 Dec 2025 14:45:06 +0100
Message-ID: <20251224134520.33231-20-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7700BC0002
X-Stat-Signature: aiihg91jgkspb55tpk3k1h3bby98osui
X-HE-Tag: 1766584095-923979
X-HE-Meta: U2FsdGVkX18HRzRBOCtWZsg7Ns2lNxPLGV5P/Bj+92nfEr1df/ehKPClnr9ODqjyPQ275AcZUysMTeUS7mYNTx5kFRftry6V8gzZ/FxeWrM6upeO+wF+pjktrR92cK9085ncwB4B4f+PjiLLg81nT9KTNOpKGHfxVC+s5xgpzkMYyN8RbUVyp7eSloiBIXYpX3xILcWt5eZGcoV1lbqm9z8gJXpbt5oZkumFswEY3obSceNtVRFx22pgPLJ/c0zbOUj5068U94dulQYJtEC0oj6GxwlafAoGhBEfxmWU8o0043USNlGibdR0KFqH8TxIwV2xv4cStXQsdK7kcfHTlpRkW/FE8ub3bbqFMBw6/h5yL+ZyvG27E/nYS9IK3mI5L11VGuAQdjmo22UH55kQ0O5TBIoFVUkjQmIh9spwEpb1hXSG5J5T1DlwsY86+qLxQ1mIfefU8NjVHZutmq4yMtRK18Ul6vnqEb5gTQ5xaMmq1ljV1yIyuivUc5yIITw/qp/mCu2hYlEeprg1v+uEHP3yeuRrFXMORFC29eA6OxcjJQDzWrNBeKgD7E9Jp6JPZdmOILBbSWptgv00/IEF8mTUutCmZ2p+V3eZA3oXuM5fBkxW5/5s2eYVYLmLY4U44rzZmR/aFZB92lYPoa1AAilDxsC0rGamOJ6UUU7Evw4L1xHRQwB0tFviHpubgGWaZBfO8KdeC0fdx5LfI37klUztzjcOaRAhooefMEqooxPv/FnH+T1Hn/wVSpbyW0OggsSajn6/s8LL5ZVOkMujnWbC7+Sev0BeJGiLxtBq3iJj+exN2w6pk2UZgHSmrdXfMHZo519g+QssSrrUs2/2go0OA5GxrkBNS+ODjHHcGeHNkkHdaZlBgj1+Xdjtz1BwwiThaGXyP0lW8aSs+nQbZRwPdJDqhUdkJelRzBTmANfNDHuS0lqDUfZViDBMrMDcQ4H0gJar8DMsfj/GVwj
 Q+X2YSSS
 EV3apX3O/SEj16vgPv/4bo5MCqGBwcrC62EmhFjlN2hMXExV2V9zmqpA4K/WN6uA/uQ1lsst9hVkw1zvdbUVek81QiQbs0wWe8KJj5GmvdUFXH9Mxnz857gB24OFLXap2BfXdA9PRFM2tDzLIV3lTEVgteL7B2/B1AmqtVzBK748GgKIX2ZaP/ZsyWGmVmt41fuWy7QYszTmJL9epipXM3ZB934ZyqagDBvdiRNIl38L6jac=
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
 kernel/sched/isolation.c | 5 +++++
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index a492d23dd622..25ac6c98113c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1487,9 +1487,6 @@ static void update_isolation_cpumasks(void)
 	ret = housekeeping_update(isolated_cpus, HK_TYPE_DOMAIN);
 	WARN_ON_ONCE(ret < 0);
 
-	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
-	WARN_ON_ONCE(ret < 0);
-
 	isolated_cpus_updating = false;
 }
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index d224bca299ed..84a257d05918 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -150,7 +150,12 @@ int housekeeping_update(struct cpumask *isol_mask, enum hk_type type)
 	pci_probe_flush_workqueue();
 	mem_cgroup_flush_workqueue();
 	vmstat_flush_workqueue();
+
 	err = workqueue_unbound_housekeeping_update(housekeeping_cpumask(type));
+	WARN_ON_ONCE(err < 0);
+
+	err = tmigr_isolated_exclude_cpumask(isol_mask);
+	WARN_ON_ONCE(err < 0);
 
 	kfree(old);
 
-- 
2.51.1


