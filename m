Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D004E75458
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEB3A6B0095; Wed, 24 Dec 2025 08:46:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C820D6B0096; Wed, 24 Dec 2025 08:46:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B98266B0098; Wed, 24 Dec 2025 08:46:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7FB66B0095
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:46:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3C0781309A
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:46:00 +0000 (UTC)
X-FDA: 84254488080.03.262DBD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8988140002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:45:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F/Tyv4Yz";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766583958; a=rsa-sha256;
	cv=none;
	b=OypbgO9ZGJv6rWo+62NL6knEg0hy8xM+ch2JUKQaD49Z4TUhafIDPuRyrsjTKbUB0OT0cl
	TPny+kwyrrVW5SXOj+6kxgZaj570tKChOOKopSFGe9SlJMqoZUsC9zVlm1CmvZZIEnXMjM
	4SVM4JhRgsiQqVzhLG16jl7TwqiTlNM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="F/Tyv4Yz";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766583958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kpFz+qSaydRc3TsGmh+/+d+h4P4lLnsTpDEcEmwKbsg=;
	b=brFbUcPDq0L4U7TC6i+ClRpPCc38Z7Pje+ExhLaVLDbnWFdjrNlgc4uuH/paNWQgfQ6jdw
	nnSbI31qgckN8VxqDo0xMFp+rlvW5MXont2/rEsViUExaKGnOx6WzDwp4/fOPHCGhhHwC/
	W+tayFepJFW917XNvpOtgeEPGP2kXA0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AB45E41675;
	Wed, 24 Dec 2025 13:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7455FC116D0;
	Wed, 24 Dec 2025 13:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766583957;
	bh=7CktjiyIthVdYHa9fRih51rkJO049RvxC4k3gxcrSfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/Tyv4YzP+plPQJKaSLuPEMdFxw3ZtENKHh2pjVToOk5227AiH+ZQI5yPwMVVD29C
	 kLkFDorQyePgLdHfXM0f/iz+TV4NjaoHCn4ZxTLpmFguw+wHVycblRu+B3MS9Ot8SR
	 RxgrwTFoKKCTIq/uKNz0JzweWZ1NzoPKFTzSEQvP/JFoQ9mMXKYri+Luvtu9TzJoNz
	 QbVoDOVhzOZcUdNZVVJTsplPVblFi4XhnJmLIOi8fx3nmRj0w47J+4wn6IY+1U+qOX
	 Ce3yTydWrvfVzC3nbZRvbYjyZnPWPe7QQKRyBio79sst5IhAMh4/7ipJNG75xSpb+d
	 cl5g99p2tk0Ug==
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
Subject: [PATCH 03/33] memcg: Prepare to protect against concurrent isolated cpuset change
Date: Wed, 24 Dec 2025 14:44:50 +0100
Message-ID: <20251224134520.33231-4-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8988140002
X-Stat-Signature: ufqcg9idbu45z4xwbyyoshten6c9nui7
X-HE-Tag: 1766583958-718126
X-HE-Meta: U2FsdGVkX19NyXBjVBJfkBplzS+7kmZwQizyOQqctilQIhGk5aFrjV0vlA49zwFbOGUyhjnQ+C7L3DSAU+hy9tOzNJpvlum03XCX2/RrO/ff2ywyHaF0Sr8KmSreODKQyJSbKo9sZahJZdFFMys1s5RXOisc1eehsc1NYxg7HZtIvrN0lyPm743+28EF4UqwBncCf1t5YXAFRlORGhsN39vQKjLwOXu5D6AGOaQCDvgrlNRq8l1USzyIMlsz2hoLz1e+UC2V00iJyUONloVbGFUkEkrtHojLIEDZA7Kj48WhuEGA9Mms6IADL59o5xjDqUyVghS2TXOABqFwyTEHjFbUPeuauavYgIw8TjS+Vz8/bRt55Cg6M3LVyu6tLrIGq3l+7H08BP7fHa3WVnBYidQN/rc5YSOAwkRw3mJcDml4yZvUD5wTUqLsIslyRDR55hwpa9Dv9ZbqjzKTQeAzTy5aP5+1XD7il/cQpdjut5xcoMwkV75z5RF4DP1SmXBNLmoqN+933np3QAXVT89kk3BW1Nez2TAixOgfwakvDMs1QqWFhpBwYm0kiXQaWfRjtltbzB2ESUtonmhGrETNy7aa/dB3uwOjldD8Rdfr8bgABfrjouHt/54eXRDHb70Voh24Kx2NQqqsYBGLszG9bIxWjSlCfQWj6TBAYWgYwhemEDlqlGnMPHf8s7QW/C6eH31UUO0h/pGUPacwPpkNn1dNA02hZyx6JIroobeKLtOOczvzp5luuO2j/vAMOxVpQ+DGxu5DyOw7kUInHlsFDUt6C7uab8edHX5BzkZ4COVEzHBK3jcF3LeP5ELeCDi34BdKnWGkB4z0Zs8dzzxokAxoafOB9UG2PB7GsdOuWyHpW3ZCNHOsXqRSYlZq0ZdcFjSI42VNBDZHsreSGjwHy4pIV06svxwTzm1vQRwzNardhcnTJS654s6l5WeMKeoPDlweWTL5JrrAcR+oXZZ
 GAbWGRWk
 rtczcLTN2AlPxNs8pj4ztEjS18OjMuwQNI9wd/hp7T/qFsWeqdH/cLlHMwdGOFCi6YfTgRg8qxT2lNQjkTRzHHqKyYia7oMBTZfow27sYpRwiTz6iRPIy2U8nrKQPF/+Yt7s2k5QEBK7AUxPsRv8HwXAbWLPB+BeKS/AsPjIFJEF/P/9hNwaFMqBATEFuVhlyXMyazD7MQtqiII7IM7K852q7jDA6joSmrQ8LDPXCxubMs+PedHpJ9xfDMOBqc1WGzfbomSkV/JGmcZk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HK_TYPE_DOMAIN housekeeping cpumask will soon be made modifiable at
runtime. In order to synchronize against memcg workqueue to make sure
that no asynchronous draining is pending or executing on a newly made
isolated CPU, target and queue a drain work under the same RCU critical
section.

Whenever housekeeping will update the HK_TYPE_DOMAIN cpumask, a memcg
workqueue flush will also be issued in a further change to make sure
that no work remains pending after a CPU has been made isolated.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 mm/memcontrol.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index be810c1fbfc3..c3c473c3dfca 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2003,6 +2003,13 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
+static void schedule_drain_work(int cpu, struct work_struct *work)
+{
+	guard(rcu)();
+	if (!cpu_is_isolated(cpu))
+		schedule_work_on(cpu, work);
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -2032,8 +2039,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &memcg_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
-			else if (!cpu_is_isolated(cpu))
-				schedule_work_on(cpu, &memcg_st->work);
+			else
+				schedule_drain_work(cpu, &memcg_st->work);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2042,8 +2049,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &obj_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_obj_stock(&obj_st->work);
-			else if (!cpu_is_isolated(cpu))
-				schedule_work_on(cpu, &obj_st->work);
+			else
+				schedule_drain_work(cpu, &obj_st->work);
 		}
 	}
 	migrate_enable();
-- 
2.51.1


