Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99A68EEEC1C
	for <linux-mm@archiver.kernel.org>; Thu,  1 Jan 2026 22:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D9306B00B5; Thu,  1 Jan 2026 17:16:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A4B46B00B7; Thu,  1 Jan 2026 17:16:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDBBA6B00B8; Thu,  1 Jan 2026 17:16:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD8D96B00B5
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 17:16:52 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A7786CE6F0
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:52 +0000 (UTC)
X-FDA: 84284805864.01.BD86E48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0D1A18000B
	for <linux-mm@kvack.org>; Thu,  1 Jan 2026 22:16:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q2Ouwrvp;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767305810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4UJ1ramTmwq0TOU26wCD+4lkcdtP6hAE80Mx9/FS/w0=;
	b=TiPFbxIaNsHw4BToyhRw0TKK/aw+T1/3dIWwaN3+EtLaYqlyDZYtkGr6q3xsvPdgRsnvkE
	JZGHBOm/jnL2jgypL5DBo6P16m5urq2m8EbxaHXr0959obh1ngJ9m97QL9QJmuCn9dYn6d
	D0yU14CEG+3GWYMzGNPtvG3wdn3wgY8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q2Ouwrvp;
	spf=pass (imf06.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767305810; a=rsa-sha256;
	cv=none;
	b=Ylv79cakj6wm03sEUNF5d/VNUKQ2fpB9CCaH6s15P9E8xDJKWFN3xaLpU8Sj7lSpxyOvED
	RBqrFOFALvU5zSmqZ9PGrlRxTZ4s6NbzprD0hAcyfY4o9j8fTrsE455eHm2Hh9FXKyNwtS
	k3G6nZp/KJXFo3Wv+aUWwv/yjdWdG3k=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5143360054;
	Thu,  1 Jan 2026 22:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E77C4CEF7;
	Thu,  1 Jan 2026 22:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767305810;
	bh=gHNQqhw7VVZ8HDLj3PD4gbaFv3v5iPq7Y3Tkp7jU9lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q2Ouwrvp911JzA1XOUT9i1PXT2TImUcJ292gV1k9bzM8Z48Nu5G39zXRCd7XiMHvb
	 aNik9aNs647YqthJkcEskFhllX1LhrZDWfe+1ctM3768mJsf7gQq5EN55ryfdkRAhP
	 K4j/qAOHEidsOnpB982JjlxYPZF8/m+O2D2X17v4WKfESJLHnkJmRCUH1Ui6XE0WUe
	 0PI44xkxibtnf3j+PlSun3PxXSwrPwckMDuOvI/OzSnPUEFQjwd54MLgl8u38AtP22
	 VgL6pjrPdo2ZmLhJVr+5PxWUfWuG5ABgmW5ZG+AGxAIJ0drQDPLssux7e4m3Oo6Qyk
	 oMI3wMcafwcfQ==
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
Date: Thu,  1 Jan 2026 23:13:44 +0100
Message-ID: <20260101221359.22298-20-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260101221359.22298-1-frederic@kernel.org>
References: <20260101221359.22298-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C0D1A18000B
X-Stat-Signature: hyqpycj51frecj9kzpj6ojpt87fugtec
X-Rspam-User: 
X-HE-Tag: 1767305810-530243
X-HE-Meta: U2FsdGVkX1/RN4hzWCsh0ADrFghj4lWkp8RoHvsOwgqz6JawcH0r/M7GOPJ4fRS3H9/tEekrfCj3nmq8NCezsjZDYdGOQ5g5nuIQ7ebmFeE6oFpslE7aAFNLRzWELUISUKW2/jW6pjKWF3/BrDzY0xrZUVpAZAVE1Kw8RSLpYvGmESqar2ZjO9bAGsFp4Y9/tWBpamK+KbofotHNj4DHkKe5Um2gPuaFJPz0PjdHy/WowTGAbjHGaDs6o8M3Mc3f6Y3Bl9XSKW0DcN64U7YMBoJ0VDcs/P58Y124r1gvAG8Ptom8M31ngKA1IXNZgTmOAYOppvXnmz2LfK5aaRpgqa3aaOpsm5Zzl1jEc1ChU73yGJX6laOWKKJuXGWS7eHR3B3TI0iqYiRX3PrUHxq8UJYt7hJpvgw+AqOdw90zFX6dw0FR89ooxG+TtSmbXh7JA/E0RVTh7wI7Xy1MgTzCMm/hoJLSdGt16uoVErXoK49v/vEpFv1QGoKz+t4S348vk4TergHJHM6sKm786AS8lGDXgyWeEHiFqRJuRpE1Ei3hVQ//UhgsP4gXdJ1B2YSjEAiIp1UXFOxeIMkb3G15j/dqp5AdLM2tSVuBmDQx3i7qCCa4PvMNhWxyuf9DTP5xlWuytz5R364NSfUSXiaBNMGyFqS16mVqXFlBNwZIPj4OujK6PU1LtBC2Q7e2mVR3bvsOU7MQsmYHkEKZVYfiswPJbbRJ/MXVcHUh9/33fcw3XofL6uurdRwYLfROTjsRPkyjDX07V9XWPHetd84a14a68QW1lsD5zeglV05QLGtDIbuHBWb0erofH8hLaFL2pdKuK2rETrTqto8dwh9Woc/0nuejM1NgqJFJBxR5ky47BATbhgjUARWhcJrwGzXZSiIHqiNZXXCfO1cxDi4SZ+rzmI/jXGIaVk/8zoRKTzmcyHtrJ1c5gaXqwqWztJr5EFrANYNhEVn38QEfphq
 t3Hxf3nk
 116bbdGnQwsw/Lqlfn3FQS8R6MRVhMWbMiAssbvj38Gx49NzX+6dp7px8jq4FHgWNHn5fhRS79AeMBHImsDKoEBY8tXejdQ1v70y7Cgsrso0nApQLAbwKtRRjpILHJ4lZxh3ejzIFOzmZFFVLXOfNKog6IzrM/Hlkk7RelsCbiwzllgHdPBWtrB8K3kkZdjde35DhNIBtfPWO+NqyjgN7+p8NcvbnU2FCUJl3vmo5HQvgtyo=
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
index ea9925652d99..12a47922b7ce 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1487,9 +1487,6 @@ static void update_isolation_cpumasks(void)
 	ret = housekeeping_update(isolated_cpus);
 	WARN_ON_ONCE(ret < 0);
 
-	ret = tmigr_isolated_exclude_cpumask(isolated_cpus);
-	WARN_ON_ONCE(ret < 0);
-
 	isolated_cpus_updating = false;
 }
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 2f4f184cef2b..61580023cf9d 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -147,9 +147,13 @@ int housekeeping_update(struct cpumask *isol_mask)
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


