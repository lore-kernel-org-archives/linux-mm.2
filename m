Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A8C21077603
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 18:46:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210FE6B02D7; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 170746B02DC; Wed, 18 Mar 2026 14:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 010516B02DD; Wed, 18 Mar 2026 14:45:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D1D966B02D9
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 14:45:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8F7CF1C04C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:45:57 +0000 (UTC)
X-FDA: 84560063154.14.4482A75
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf18.hostedemail.com (Postfix) with ESMTP id D68671C000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 18:45:55 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=RmMdsbNC;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773859556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jiq9HHreSKv9gJ1OxNDx05z/LXXiM1SwacfPI7vtSKY=;
	b=lmi9MGh6DUmbytIuQlM74pc6uzhQ2cHfeEMmDztK7L/13YqVzNxhm92/Y74+S8dLH/1+L1
	hxJSXIKGd6FCn4nOwwe5xpVLNy5mdkUenTxzfDMYfihl4cYdAck253oT8VD67wvA0v0tCR
	9UbXWw83y5v6lJMrtoqtDdJdrMyDPvc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=RmMdsbNC;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773859556; a=rsa-sha256;
	cv=none;
	b=Oz78KWwMHWKwmzwn979g8OaY9hb08L6xqOEupMUep9E6datg8RQtTwOEN4wsZ+9NUW9X9Q
	xbMtywdMuf5ZsCULbuaJbeFkSWBhispHfOK8WWwktf2KzkxnkMSb5tD6bd42zR27+b3WmP
	ibwwU5PWO3n3TuXRuBjQOxYnSNK7c0Y=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 290C3B3E42;
	Wed, 18 Mar 2026 18:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1773859554;
	bh=Jiq9HHreSKv9gJ1OxNDx05z/LXXiM1SwacfPI7vtSKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RmMdsbNCBcVoRRIbp1GkV7S3USAyX0oFxL2h3SgUcMkzYUo9Q8sJj0vj3QHE3je/Z
	 7QeuXQwi+JFDV8LFs5mGRRt7pXWJ+X1RJRsRx0vzXQgTFSHerrlotucPG6L3pO0Myd
	 68ifleEP+jjBTo5uVNrjB8nmY8DcxPsXKklrjuK8=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>
Cc: linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 2/4] locking/percpu-rwsem: Extract __percpu_up_read()
Date: Wed, 18 Mar 2026 18:45:19 +0000
Message-ID: <b980458ba51950916627cf10bf3ba69aa98832b4.1773858853.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773858853.git.d@ilvokhin.com>
References: <cover.1773858853.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D68671C000C
X-Stat-Signature: r5115y3e9aa68dftebpk8xe3765bbtsd
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773859555-619942
X-HE-Meta: U2FsdGVkX1/Yaql3qWCVwSFYYT8pwl4THY1bE0qDF1ppFWYsJQCcI5Au9fUb8Y3omD77cLBsSzsur16K06Jn8ybuNdXNkXCAJ39N6mM0mU+ywWDdpLYF1WRr3Wcgqa0cOA5hBRzQUVjHnNqAKUr8dzNNJv/Flic/MUvjyPWcwesaHLNAHbsXdMlWTDw9nmumquF7hzzch/HHxJ0hp9vMkyiKrXap7SsvMRm2/NS1IiZbPpJmebUktwMsdyclXssce4IEuH+YkyRGD8U0IKzSkH5/4Ops160DVdSZ6BXJrGmqFi+RlHyOpPvHnaHADzhqWNMZo3mZt6qdUaQ5nQgeabwGh4MPHPYix4nBHYEcsUzYis6+IMuJvi3nDiw4nl+xZwcy3DOY/uW9XE+Rvn8c600M5kZOXJ++CfIWmq2MieGcM2KhBcidJ3CIg5BNiDWepFuD5csHdhFxs8Okcc3DoSxCeDfLshjVhJcqzr2z0p7+nL4yZPbwibJPvTbwPWEoolDTr2vo6qB3+oKGwphQUfSsBANbcOYVZhGU4AaX3dVelj0P2rV4UTyTGNsXJRlAQsY+w56OtdrqZjo912uaxilQpSY40cp3O6OLAOwKMLVXqgXLNMhaDX2x/gO82woMbr4uOoY0lAipce3xLqbqfobr3TAWKRMq1E5bg7Cm4pUdJioWDyAalyfVFfhHHCCv8KHFQJUOGO3qWHW4JY4IRDPV2vkvBOkEYV83QJd74crOmXIcqKj5zXGrPxncBcH3SFDp9AWGxpCux2qtgQmXyJ2hpustld+QYhCgm0H67heVuForgzHHpEesPMnX3JoPm8rCxRsJ5ROD4JhumEicCLwsnkQk+m07muOFbbK+ptiOO21oVdUXuQy0pPghEq+Hc8sZQ+SMans3BX4yK1bl/WmjnbLKWGGh5GyBKauXJ8h1Gf3o+0ApAA0vN2PDiG9AWWamLG8xiBSEpdtEgc4
 OMSiGt5M
 GRro39z9VqpBn/+Nb7b+HmwBxwhDQYkVgRx37bXG+xATnq3jJa9M3DRRPknJ3zpcyOnMPdqoSOqy1eccGKiUhYBF+ZjUyBR4V0kiD4bvTb0qZvT5y2In1m1Q4CkUtMXfPM3dbZYM3YVxX0oA6/N4jwE5B89tr6fMfUtOC8EZ4J8a9CjX/LDbwjlMsM0JpruV7pYpwkallcVyPHXwS0zMWk2UR4G2a/uQOmWFFxD7gxwLPb5SQu850C/cQpLJoPJckhpzUDNnkMYfh+KRxOn/+obqMPHh+BVL0ECe/cgFbde/vpnWVX2ZzAE/UGT15hEj1it71v/RxQy0oUAg=
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
2.52.0


