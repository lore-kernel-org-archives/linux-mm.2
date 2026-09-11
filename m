Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15963C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:01:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D22B6B00A3; Fri, 11 Sep 2026 04:01:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27BA86B00A4; Fri, 11 Sep 2026 04:01:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 193256B00A5; Fri, 11 Sep 2026 04:01:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ED6BF6B00A3
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:01:23 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8C39C40136
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:23 +0000 (UTC)
X-FDA: 85200736446.19.A3AB3F3
Received: from mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf16.hostedemail.com (Postfix) with ESMTP id 90008180006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K0T4axFF;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113681;
	b=bjDjdLirxcTJ0mkJ1QP1tFue0QlnPkaISjjn2RcOLv6gfh+p64pTgdhCftsSlHf/HXZXoH
	DonfrDFkJwyl6I72ZWUG35A+0VBj2Z6jqaCHkgm/rvS79ZNLZyw7099hfi7qt7v6DCVQ+o
	nYjeKwXr59pNWt4PABjVeQMGC5qpr/k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K0T4axFF;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fth414YxpxWrcZfe2pFuzraTwN1uvWLhTohNRha4iZU=;
	b=JYsQkNMBeYQ8LXtshWSareSCyKQKqH98HddWETwD+xvC2JSbfE+fmQOQhd0ey+pOOCCmJ3
	jdI7mrb79rj26ls8h4DFfMsVJX4fxAOXLVHAeq9+QOAl9H991hRAZnfqJFiRf6Jikqy6uu
	kX3CPFLIJo6iW1Qbx0sqPRP1RX79PW0=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0hlRYPmyXV54QvYh0kyMJR49RsE/MghM4TVAvWeaXWw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113678; v=1; x=1789718478;
 b=K0T4axFFAV3j7dfLX72ytjaA4PfYKcc7fDPwlpRoDhS5ZtKFLL72iTWfjc5JT7ObaS5kfWfY
 SF2ow5NZ3X/1EZmte6oABZ5GCFHu6htIjR1bkG25/nEvSny+T9P/ph9hxk3E+OM8taNI1ShcJdp
 A/0fvg7g+ehqYaK9EjeNApMw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e4dd3759505df11b;
	Fri, 11 Sep 2026 08:01:17 +0000
X-Mizu-Trace-ID: e4dd3759505df11b
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	paulmck@kernel.org,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	gourry@gourry.net,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	boqun@kernel.org,
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v3 10/15] sched: convert process/thread iterators to for_each_*_rculock
Date: Fri, 11 Sep 2026 15:57:55 +0800
Message-Id: <20260911075800.491472-11-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 90008180006
X-Stat-Signature: rykqqspwnphz5g135ijprodu8rwf3o9d
X-Rspam-User: 
X-HE-Tag: 1789113681-805199
X-HE-Meta: U2FsdGVkX18qOV6oVsoL3cmQm4JFpdiqAlUuzZE4nqzEJQWRGXaXZIDlt/H4V7tuGPSI/fL9LWd1DBn96cGwsDCFqSNsxgQJGdmHSG55QC6HZ07fWgPCCF/gUDii7odPOlL2nA3iPANugqbgLHyqoqn4UvVBkoYodDoFv9Coi3Db1txjrEDMoBgbjvEToKMYwMFHA4g1dbbBg9i5Vu3I47dIcPeycO1rNfJrTx03q/rOpmH5pSdah4h4ks/bGq7xqug5eJYYuW9AltlTugb8PAWHwZg+oKT1kJlkFfrReIVVuwdZtI9gSsmwLwt1x0mdtErJBsuJoiOLuhZZAWVv1JUpUMVxlE7vGM8HX+VcDj0nGOduAW88ajOkSZBx5QUTXG6//1DtyZoYQSkfsqOukaKPP6aR4UEFyQPgbIGSuxX0TgGlppMytPgHUg1DZBI0+sQ5icSpg3yZpTX0/n/F7TZ+eKwjVCH35XFXC6yOf08lu5NbwdiZnwbeGsvu1RVuPqlRXshRCgi2/2/g8kNksnm51WMwiaAh2tNu/FlT52aPZgT1UMtVyOMabuVzwThh2t7bwTDIhoYBMDreNzaXDfgyr9XwgzzEVnYYX4d1BmaWh+xKUhjFPGFU6KpzTauc5yUdouAXlOkVANG38OxPEkIJfjk9aZExtjnQY9glYUenA8l39CYcxxa2LF2MBiIuANZ/tKdiyaRjI6kspGrp/LiBFwpi8uClznoJuPcQgMKEytC9Us2gFtz6l9rpWrprJQoPOj5FIp86HkcdYQaK7BxhwcqOUmEDUoKs785c8zipoWsdRdeMUh9525LWl05SRC6GcHI8WQMit4+X4fMQVuEKTMSNWTeoXg0OmmAvWsVc/L53AZkPKIfExlluYhBIAb0Uuvp+A/87Rkqh2HwP5lM2DZwQYx1w5j0UDH6imNPUfkW8nFM/6dx6FgYBpdH/cc/EaBzhjsvzF8HGZeZ
 Zrf6RENG
 5bV8ZA4ylRGSgksikxMUvkAvVUSRUQWSH0eXqkhAiAtE6WlWsC7m9EqTdya7d2YlwkUXb8umlTEpEurGMcFcS2G9Lwy7a4antg+Mw0CFF8EGpX0F8yrOoDayVBljSmzsASQ7ezfPfQ6QLWNUD9wXea7qmo5pW37j2j61SngIfMi9ioHqf49kzrEDokdFaKrBKZ24F5OYB7QrPq4GCc5P6jVncv3nvHYken59pKRyYEcHptkxBTsWzJrnvmsqPltWa4HFMNapEWEEQzufSeLS1GkdpBrTUR2Ura23PAR6VOTRqIHTPG71IV5qvBEZxBz3dAsxjtNVuOBokH9BTtZBRkyVtjnmg8c75BFxBg5SCuIs+bdi+GEjxk5k6zs0HAz10bHA+KYAK0Iz6kRt+VJCUGgGkW3RbvgZF6CbK/VJE7nqJFuDC7aae/jlBLihVjfiX94rPNB+mM78ozDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() and guard(rcu)
pairs combined with for_each_process_thread() loops in kernel/sched/
with for_each_process_thread_rculock(), which scopes the RCU read
lock to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
Changes in v3:
  - Split from kernel/ patch in v2 (Peter Zijlstra, Steven Rostedt)

Changes in v2:
  - Rename *_rcu to *_rculock
 kernel/sched/core.c  | 3 +--
 kernel/sched/debug.c | 4 +---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0697ed0f1c3d..fd5bdd2cb798 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2005,8 +2005,7 @@ static void uclamp_sync_util_min_rt_default(void)
 	smp_mb__after_spinlock();
 	read_unlock(&tasklist_lock);
 
-	guard(rcu)();
-	for_each_process_thread(g, p)
+	for_each_process_thread_rculock(g, p)
 		uclamp_update_util_min_rt_default(p);
 }
 
diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 72236db67983..cdae165b98f7 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -1029,14 +1029,12 @@ static void print_rq(struct seq_file *m, struct rq *rq, int rq_cpu)
 #endif
 		   "\n");
 
-	rcu_read_lock();
-	for_each_process_thread(g, p) {
+	for_each_process_thread_rculock(g, p) {
 		if (task_cpu(p) != rq_cpu)
 			continue;
 
 		print_task(m, rq, p);
 	}
-	rcu_read_unlock();
 }
 
 void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
-- 
2.25.1


