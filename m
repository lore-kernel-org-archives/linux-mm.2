Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1754CCD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 07:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B98386B0093; Thu,  4 Jun 2026 03:15:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A37736B0095; Thu,  4 Jun 2026 03:15:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7756B0096; Thu,  4 Jun 2026 03:15:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D0B66B0093
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 03:15:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C034162310
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:15:33 +0000 (UTC)
X-FDA: 84841369746.05.30DFE8B
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf13.hostedemail.com (Postfix) with ESMTP id 972E120005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 07:15:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=jP2mugPB;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780557331;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TazcCDzkghDRTtrKfI6NgZkes3ArR37FI2mZrUwjVOE=;
	b=00xAJoKj9ohZD3EbLD/oxb091UYfaIVBZIvsNnDCzHYnh0DOTn7uB+jOcfJ+WSQZ1Vogar
	zE+OyEXjnDaoODQx8VrUncoOgsDPtNcPgHQ4Woi6M2GXDg6Z8iUwCu7N8E9mCNDWCDGaMg
	n6HyBpyGRmtzNBB8BxOwoUWO5ewj2/4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=jP2mugPB;
	dmarc=pass (policy=reject) header.from=ilvokhin.com;
	spf=pass (imf13.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780557331;
	b=gDDLhWWYnpuHy/uuOntXMHbXZt/MxNpWR7RiBEBQD8uCNq16xmtBJtS7XqpifwObJpS5c0
	3Z81hvPmvdaZxIFZwqMXk04PrNhtA9fxFfQBcpFbvB54cizK/808/VHO8ZON7P2mxNow/S
	c7nWNBVHjSrLi/jqzVIF8Q70z92C6QQ=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 1455DD115A;
	Thu, 04 Jun 2026 07:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1780557330;
	bh=TazcCDzkghDRTtrKfI6NgZkes3ArR37FI2mZrUwjVOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jP2mugPBCSHsuwOG3Y7GpU6arWuCxNDIJCfouz/xAIn+49SWJU9ieoh7nweA8vQXD
	 TpTecdd2GosvaKCUtpdjQGyPOGM4J2OO4Dal/nZck9cLqE5vnrg6jBYhD6ntv7UB02
	 W+Ld6ZX+0CIzgKXPqpBapW0CZG89WIRzkURnL0jo=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v7 2/3] locking/percpu-rwsem: Extract __percpu_up_read()
Date: Thu,  4 Jun 2026 07:15:06 +0000
Message-ID: <3dd2a1b9ab4f469e1892766cb63f41d6b0f53d29.1780506267.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1780506267.git.d@ilvokhin.com>
References: <cover.1780506267.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 972E120005
X-Stat-Signature: g3ibn8k11iw5obwywe43kox49r8ge56m
X-Rspam-User: 
X-HE-Tag: 1780557331-349504
X-HE-Meta: U2FsdGVkX1+r71nfKgc2yExcbL1VjllfZ6fR+AQ8BES+UGH4pdUTfwcFZhkbnBgf/TFgc95ON4pRSPHlZTjrrwR/q4ymE4XGtC8cPLnOG3qfEM04VWE9ZjBr59O6E1AjdFLvNKRdy8bvOPHgraC7AKrM45HH5uqpul5t7kOXwRvI6/VKiPkuBiDlZA488vuE536pdixqwXUTSQLwWEBq/vF0bAvMN76bahour8cEOWpm1nmYZsyifSefQzYjGl/K9o6o3qs8EyB08SlucnkwroUX1aPalDOuiOFaqdCONamRYILxU6s7yTSXEqpBxh5VaPYENouztJUNsiXqOkR+SD1DAjyTww/JzCu6U23oish4KujOLwpPoRpE+odYnECRefXxH4KqobP7gRT15IZ5W5IEgJMYVO375Few+9bG97unxA0QoBocFbocZhW8k1d01dm/aTSRI5jAULFRvZ1CUOImRvgdZk729QkMU4fZRUnX0HdrssCcJjy+LNZjmgbEPxDty8D54rXrn6POXsy6BAPhZPdphytev4t9jDFbZRdUSVn8vM96HJHp3sJBq+2cdO7ziHUDPNgsj5QYLV3bHqNFlOL0TRvOyYbzic0hVoLOXrRwT4cCBBmz6PsMxLNsuAnQBtOLYSRcx0oGcJ9lxJ9gjUKY7A8uEnY7J2+E46FUhQSX906PW8bYEAe45zsk+9lH6GEpsAXTptppoj1IJ9s1ZoYHepKVoUzhMWU8ylRT5TNGUXgT0hoDrtYq9NVIPhBGrjmHzGh+qHG7bSxFUWVCjK6iUz1d3ibDNeUFOaAe+2RL0raK21oDD0KMXLvI8BaHLa/NO9d0YIJHuRqyYhM0iocPQ6qpiKVS9XETzTrweqG4m+822dFmj22zYumOzLM5+dfXlohFkZbXXOzqA+Ru8l4FiduDMv4YCMLwcVb9QTUySYWwZnyrBcTUn3N9DnS4U+vyYTpuCN00+fn
 2Ylo+U0Z
 n/3E8j1LrPHZ46bVuBwukL0uLncsafZ3ZT1sqpfvX9HBn2iSaj5iVg84Qy7NiXAr0WtswjJHMRKPfikeJRG3EuLIZZwssZQXUFZDuGpbqh6I1ZQ6+zTgFARkuEpft/5rtKkSuwnuR7AIaxUI8zvCG2KBYFw48APQpP35/LKEPeLeJv8GYx929jd96kYLGenEkeG9xHyp/E3QPeR/G5Db7/8YUXcLYK2EehYE04JwjNqYsbxyECqleaG0B28Xl7alycHGWx9R+19vpbiLPccOBWF82Fbpj3DWhB4bLUh/ljscoiRLMda8X6f/6QmW+DvUVIF9xFKXToL02eXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Move the percpu_up_read() slowpath out of the inline function into a new
__percpu_up_read() to avoid binary size increase from adding a
tracepoint to an inlined function.

Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
Acked-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/percpu-rwsem.h  | 15 +++------------
 kernel/locking/percpu-rwsem.c | 18 ++++++++++++++++++
 2 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/include/linux/percpu-rwsem.h b/include/linux/percpu-rwsem.h
index c8cb010d655e..39d5bf8e6562 100644
--- a/include/linux/percpu-rwsem.h
+++ b/include/linux/percpu-rwsem.h
@@ -107,6 +107,8 @@ static inline bool percpu_down_read_trylock(struct percpu_rw_semaphore *sem)
 	return ret;
 }
 
+extern void __percpu_up_read(struct percpu_rw_semaphore *sem);
+
 static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
 {
 	rwsem_release(&sem->dep_map, _RET_IP_);
@@ -118,18 +120,7 @@ static inline void percpu_up_read(struct percpu_rw_semaphore *sem)
 	if (likely(rcu_sync_is_idle(&sem->rss))) {
 		this_cpu_dec(*sem->read_count);
 	} else {
-		/*
-		 * slowpath; reader will only ever wake a single blocked
-		 * writer.
-		 */
-		smp_mb(); /* B matches C */
-		/*
-		 * In other words, if they see our decrement (presumably to
-		 * aggregate zero, as that is the only time it matters) they
-		 * will also see our critical section.
-		 */
-		this_cpu_dec(*sem->read_count);
-		rcuwait_wake_up(&sem->writer);
+		__percpu_up_read(sem);
 	}
 	preempt_enable();
 }
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index ef234469baac..f3ee7a0d6047 100644
--- a/kernel/locking/percpu-rwsem.c
+++ b/kernel/locking/percpu-rwsem.c
@@ -288,3 +288,21 @@ void percpu_up_write(struct percpu_rw_semaphore *sem)
 	rcu_sync_exit(&sem->rss);
 }
 EXPORT_SYMBOL_GPL(percpu_up_write);
+
+void __percpu_up_read(struct percpu_rw_semaphore *sem)
+{
+	lockdep_assert_preemption_disabled();
+	/*
+	 * slowpath; reader will only ever wake a single blocked
+	 * writer.
+	 */
+	smp_mb(); /* B matches C */
+	/*
+	 * In other words, if they see our decrement (presumably to
+	 * aggregate zero, as that is the only time it matters) they
+	 * will also see our critical section.
+	 */
+	this_cpu_dec(*sem->read_count);
+	rcuwait_wake_up(&sem->writer);
+}
+EXPORT_SYMBOL_GPL(__percpu_up_read);
-- 
2.53.0-Meta


