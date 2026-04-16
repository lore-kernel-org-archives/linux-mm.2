Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF9BFF8D758
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE54E6B0092; Thu, 16 Apr 2026 11:05:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C70166B0093; Thu, 16 Apr 2026 11:05:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B36DA6B0095; Thu, 16 Apr 2026 11:05:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9DAE06B0092
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:05:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6ACCA1A0957
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:39 +0000 (UTC)
X-FDA: 84664743198.30.476A885
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7CE6340008
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:05:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=C15xYElv;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jiq9HHreSKv9gJ1OxNDx05z/LXXiM1SwacfPI7vtSKY=;
	b=dzV+S8O/DtTC9aGfG4cneNdylWtL39HQMpwH0TQmRIYJrJ1pl/gybSzcU0qg8/1L4IMwMv
	z6Ua38EAheaAHSnlyjY9M6riVZbGJDoBv1eYQlcxhjBIh97J4O+nlR6K9d8U+08a3Z8/im
	5SHcX0DIeodskUylVv/S3/sWtzVosh8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776351937; a=rsa-sha256;
	cv=none;
	b=zZuZeWVskktoE5B9XgJ1UhSN3BxFKWNS4SOL2MbvOk13mVsAxGytpktlcecSa4W2ETPKB2
	g7T+MYONryIti+v0u5uQG6WyfcrlR7dXpq/53MnfvfgLEC6cK8BQFy/90EqfDme7YLewGg
	F5xy2pAZwdlJXvLzyVaYjdDEEGIQUQY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=C15xYElv;
	spf=pass (imf12.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 336ADC743B;
	Thu, 16 Apr 2026 15:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1776351935;
	bh=Jiq9HHreSKv9gJ1OxNDx05z/LXXiM1SwacfPI7vtSKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C15xYElvp+LqvswEbao4hVIFhLbGPaifVVgX+TK3myIRVWqDZFvJ7VDIDSKeM3C8l
	 LkXbFwG30KvpM8GK9Le30ZdI1gdhb1ow9kfbdmWLIgr5u6B2C1F/IA3JZrcQy6p/gG
	 a5oD5Hj4dbR39vb+u3cc+zxoKE783CcJvTuCx/oY=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Juergen Gross <jgross@suse.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 2/7] locking/percpu-rwsem: Extract __percpu_up_read()
Date: Thu, 16 Apr 2026 15:05:08 +0000
Message-ID: <a3a45d087f56b9c4454d35140dbcbc3c45f4dc09.1776350944.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1776350944.git.d@ilvokhin.com>
References: <cover.1776350944.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1uk4a6jtoq3yer5pr9jbwyee9eizkhzb
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7CE6340008
X-Rspam-User: 
X-HE-Tag: 1776351937-982608
X-HE-Meta: U2FsdGVkX1/o2ta9KbzfRvm/l5dOf39xDsWTcyx0/YUGboaqK9ILMk20xFwbqzSg3uMXuRaBJCvIXtm4jRX8qV53v2PvfFjy6wRuALXpeE3gJfieoUl1guCdmCDn055Kgn0w9TEN7SpRS6Ilg18s1W8mRJHNwexMCzc6VoxH9vUHujc2pSaakon66+WJQsei9TUNSQ4sf/UH/zoTPO/poqZjm5cVOqLpLtcYX1KvHBgNWt9ulDlHEZVnfMzRrO2fr7pYXSLiZAq+fCMosWd+SkvVD6GfiucpIgGmdgoaj8AUeExk1JFoJmNufoU9N0FnlUi6PENXsLloyPU3plCL9tGovdLHWx70eeumHjibeE6+xvUYvsY+FjxO9HHnoXcgPqF3iL0UsIbjkLrTmoNhUa80rln0iazsJaugRG+M+yjRz83J6nQApTrsVukpZxjQxlfQ0TwtoUQjTZfKRG8qY252LZYgYphGyCT6O5cd8QOOx/qee/JpYmF23vWIR6yRLXQXoV6JojCOu8KC2uDmt99I8HQUyGhCLKJyfieHXQLHFxUd9iiA9E4gUEYHFcUstwG4y6N3hbVZtFgI9pAWBtVUFyESiLYsdiSIrE5tzEB7ugPnxpqn+Kcng5fs8n71NUMCZpkqJKsV+nLaQx6h5WGy22pLU4A/b5W8xhCGojfZowlsvrnfbLSS73Zu9A0nc/zuV7bUXiMrTdE1eO4aGwmJnUqgVqww8gBd2SU0u7darrNJJVT4pimYAal5pVv+Of4/UVrAcMeCnbA86vulkXQxaQEqyc9FLdAFdxXTzJYKPwYWfKu0m8YbXmE3cLrA7VJk2WNhPO+tBSKaBmd1QjybtiWUcACsrhnXKbFPDMs2aEdEBMPKC97kbsVVyPdEpn3Nlj+BgEYn9Osm9DHD+ZCqyJxm8PYp7UtdfWjcYIKrjo9J7BuM0B/rAn94FYAPSISP1QS4V3DV4VTHter
 2zp3P/ol
 8FM9vHexu/umoYq6/3/FovHTlSRpik6jYBR41IMF//5URdfEISWW+DHfyCwvMzAM++naMBUKBD+7NTrZepKuA3JuQPWIoxfR/xt3X4IC3pA6ESMR2gRMqir84mHjY16aQCh4G8jbKPpOmjFd3VBsS2kMo6/egbjxuc3cvjFiJ4+EPTo0clFa2Nhbx0jHMf654h6xXgBBbx2rovpTAuhxG4F9X/f77u4gpSFGDHUD882pv63AYnPaD0ppC3qv8uq/NFbwZf1RbU8gwbj/mvDjJM+u3EafmIa9T+KmRyxSVKQCMiiup8wzN0EXGWC9S/mmvFTzZgfYIQgI+KpQ=
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


