Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B775AE63CA4
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:46:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CCE96B008C; Sun, 25 Jan 2026 17:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 260506B0092; Sun, 25 Jan 2026 17:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19A566B0093; Sun, 25 Jan 2026 17:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0C2166B008C
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:46:20 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A77735976D
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:19 +0000 (UTC)
X-FDA: 84371971278.27.DF2A31A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 565A180002
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:46:18 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bd15xw5x;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bLzPvP10lPZmnoDZlVjZaj2C4mTuFn9mkofErYVOVAU=;
	b=MLRzHkWfavGW8HcdZDwyA2smNGjPlPXMbTH03qT2DDsxi3KsGXtr1vSAMNLG5IGWPAGkdo
	B4VvX//mOoSYhBtkC3prl8Lt6GxI8YySRyd6INpbON+S9jKQqRtFzmKhLVuD3zXZlHNhh8
	kmfmCRM2UHOTypDdtc1FHEJI1eCIE4A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bd15xw5x;
	spf=pass (imf02.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381178; a=rsa-sha256;
	cv=none;
	b=HpTpcHJckn6iKI6LHpcRFxuvuPRx9SVLfwmkSSyXVwC8g0FByvP4W0VRT417Db4vGmxOZs
	xfX2S/vrzew+OX+BoxtjB0afCiHfSeHIpri1Fs3YWNTfN7qxynwt4F0VoX5IuSt7XN7a6B
	OCQjqLN8i/+3w1FY+kRZnmwPkCxhtSs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE7F860128;
	Sun, 25 Jan 2026 22:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6ACC16AAE;
	Sun, 25 Jan 2026 22:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381177;
	bh=xkhk7ZGxynk2RcaH6iYDB0TKNwEPyWR7khi8Efbu4u0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bd15xw5xwORVoabUcDJ1q5vVXlUYP45MmfLpf1Wj7eumbe1G1offqX/LsP2i05p8/
	 HJs/Ycv5vPdLg/ki6rSHV563InBaJlvvNpL0K92O622nmbd042+g9S/1wd4T6PYK2D
	 9aiGuiOJSIPrOirt4z5JnC4GNDrneBm2dNyp/TSMPtL+M/AkK0EU8o6AL54sojyU6/
	 6MOAnKTImcHfao+B+LDXo/+Z63S6rC0oSeuJTmLh4N6F1x8dDaL2uM2Wa/ReCCKUzp
	 mY/kmoEtTP6ML9TH1hzaspFsZoenAkurH84HQ+FPm7nCHw49b+ruwIfNkN/xPSnIhb
	 Q51QFBv+lYVgQ==
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
Date: Sun, 25 Jan 2026 23:45:10 +0100
Message-ID: <20260125224541.50226-4-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 565A180002
X-Rspamd-Server: rspam07
X-Stat-Signature: 3g5c8x1ex1879t3k77i7y4zh4pj9mdmz
X-HE-Tag: 1769381178-881231
X-HE-Meta: U2FsdGVkX1/ahxpVlcgFglWlI7jzwVaI4EHLb1Nuv9DiUzYa3n/wT2mkULHQKbXo367VL8g2BG4ks7S+YXyizVpyLGZ0xPOTB42bKnLylfFWBMwxtAIhOYJN+wsS4oD9BY1cSe601JjuIufU3Fz1b0Dy4IjozdKQc3PuqeKcE21wRKT9m3le6S1X0xExy7kd3LFNPh9wMMUSBdypRgYicEoFQKg4QfvPS7ZwL5IlcjieUpcdPYTVx9su6fMQ7PhMZVe+JKPl3OgEig6RkdxUh0AWi3w8i+sX2IwQTqHdQ97Aq1fqbr/KlO24dIZL5h4sl1e42yGmPlVdcCTS1jNC5tQsUZ/Nmkws+DBwY+J4sy29zKFynqu63I14fhwqUfOGS6Hz4UoBNuVvazRNJhPfXfAc9GLcHLpRwkEJraWgkX50hTZzxo41ZM76o8VkR2TqmhCSbG99IvE3UrkQsMebHT6sDX5Q20fUvyStE6jWbX45vUXG3JZLhQWQrqyyK0x+vH2NizqmeIJjS6BXq4uL4dDV/s4J1CK2dm7OKq7iCgk40MQk2VkfNX7n/PdIJOCbeAxgpDhFts1Bw4yEylP/mFfWGE0aAvw8r5At+aLHQbE4qjXE/lJD1nSUP+YokuHszXDd7qHKqSIPZihfMdPgYSjnJeVUTFgs8jC3NpaFMUXjIA9OdkSKepRYsghZ8euBaPzHJ7uvUPLVUzfOzB0G3/8jqZl/l2s7sf/Qzp5AnvQt33J+BugAeBW+jEdEfN89QXvGytL3AXJ+YnVP8RRYMHUALmKJd9XU7JbcL1luYKDfIbTeyEF/xvAlqGI/53ebiY1X7VosdOPhqrVr1HkVEmbXaTv3CcvdEyoF0QCSlSMsk2JpY/NYZAmu11jQDJjoUFRu0xphVZmrj5IutZ466qBHh3nx6+iPUTxT7AcGj0BFYiEDtED2TD5tO0lmFqD/0Sr4kZeDA/gIkEYdhBJ
 gUA==
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
 mm/memcontrol.c | 21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index be810c1fbfc3..2289a0299331 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2003,6 +2003,19 @@ static bool is_memcg_drain_needed(struct memcg_stock_pcp *stock,
 	return flush;
 }
 
+static void schedule_drain_work(int cpu, struct work_struct *work)
+{
+	/*
+	 * Protect housekeeping cpumask read and work enqueue together
+	 * in the same RCU critical section so that later cpuset isolated
+	 * partition update only need to wait for an RCU GP and flush the
+	 * pending work on newly isolated CPUs.
+	 */
+	guard(rcu)();
+	if (!cpu_is_isolated(cpu))
+		schedule_work_on(cpu, work);
+}
+
 /*
  * Drains all per-CPU charge caches for given root_memcg resp. subtree
  * of the hierarchy under it.
@@ -2032,8 +2045,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
 				      &memcg_st->flags)) {
 			if (cpu == curcpu)
 				drain_local_memcg_stock(&memcg_st->work);
-			else if (!cpu_is_isolated(cpu))
-				schedule_work_on(cpu, &memcg_st->work);
+			else
+				schedule_drain_work(cpu, &memcg_st->work);
 		}
 
 		if (!test_bit(FLUSHING_CACHED_CHARGE, &obj_st->flags) &&
@@ -2042,8 +2055,8 @@ void drain_all_stock(struct mem_cgroup *root_memcg)
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


