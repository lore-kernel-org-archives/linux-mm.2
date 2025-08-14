Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7832CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:56:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BADD8900175; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FE69900174; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B551900172; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6028F900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A146140661
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:56:10 +0000 (UTC)
X-FDA: 83775512100.11.1C50E75
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf24.hostedemail.com (Postfix) with ESMTP id 77457180003
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:56:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oyOemLnh/6Qgs/6NMWeZvKBnjxP7BrHs+jwPuFi8j8o=;
	b=HBgZCCRN56KIPKkvbeN0YINCjjegMr8c4UKykIVuB/cayY64/o6C/3oC9WX+GHV4wYuISN
	ajCCeAElWj5mYbzP4AwYc1JJe8pljKM5jLpprzJku27EchJVItGH/JaGtM85TDKDXBiysq
	GtvLqGj7OVMQTu2A9bPbxaiiv9r/ZXM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755179768; a=rsa-sha256;
	cv=none;
	b=yHBa7kDwG6cS21q9qVlmc1CFFrXdjX/PvaIxxzsio206Orae5WCIVpr1Pda0FrEoeZ8nRs
	ARIy7cm+xg9ycqaJ6wY8k8X3fM1GJwlqI1kgWvCc5Aquac/uh8ywisdD4lnAXYrI5fpDc5
	zyxf4sPEOZLYy07Yii+lU034PC8jWl4=
Received: from w003.hihonor.com (unknown [10.68.17.88])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4c2mwm1WGfzYl2mK;
	Thu, 14 Aug 2025 21:55:52 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w003.hihonor.com
 (10.68.17.88) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 14 Aug
 2025 21:56:00 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 14 Aug
 2025 21:55:59 +0800
From: <zhongjinji@honor.com>
To: <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <mhocko@suse.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <npache@redhat.com>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<peterz@infradead.org>, <dvhart@infradead.org>, <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, <liam.howlett@oracle.com>, <liulu.liu@honor.com>,
	<feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v4 1/3] futex: Introduce function process_has_robust_futex()
Date: Thu, 14 Aug 2025 21:55:53 +0800
Message-ID: <20250814135555.17493-2-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250814135555.17493-1-zhongjinji@honor.com>
References: <20250814135555.17493-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 77457180003
X-Rspam-User: 
X-Stat-Signature: jfxoienasg1arpij8tx1ofjep15rwhpk
X-Rspamd-Server: rspam09
X-HE-Tag: 1755179767-206789
X-HE-Meta: U2FsdGVkX1+wYU+xKpDf6/epSN+A16gGWiiD+QYUngIjaNyTSZ3sgCPXVsPsJyln9fJUtxw8nwyTtEhjeQotjBn68k3YbrOat+vOGI+YgwyioYwQY7tXtJHVck26S1JKsMFdsX7TjS+V0YyOHWdN9OtoA/djjSos3Wy+G+r8na2/2t85/l540dQgquS7FCuzl0HpvvSGUoIC4yOLQY2qQoSIuEaxI7JNQtpWuO6gbtE5ZBcKoK7TMebcI4ZMG2Ye3hYcq4n6Vdu2nn0iCiF3kkFHDVMag1tUF9FqZLswvzJGKqowi3rTch6QMoye2R2ibS1ZOR4JRzkZejN3mgMDo/za3CXAM/eW61T8D9AvJhaYbNSydiNQTuC8gE81GIngWLssVP7XT0kd4iAOnklNl/x3JGUPuW3jeLUY/irUkPzioC2wat4YSuRuRlcgEBY5oet9V3VlwCBNgio6+hCUlRB8oGkPJBc0uBqAH1VwBsqSe/J4Bw5GOstuHEQNGMRcUHPDLEsP0DHznCMjZ4lRXNMKiFcNAOxyZOC7ZzQ4z+PBnyrmlpkWwgAar27Yw9BElf0wu/8qxYwDQCk6Vlefwy+4K5pSW1Y50HVrfmWpfeMAP9ZIddGlxCuZeyvYIQ+Vgw2zvmezI2CTVgUQmRoEsGTYhFZca44cTc0O9rEIuzf4k1+BwYIIkM16ysrC758EC0Ygy1DqLiPgYMcJ1ffBXfnGytn8C8xmcJt8P/FKJNhj41cw5BuMtCAf0e+RO/EK2Il1vayCvj+vdLBok+ytbIodBcEmv7Iu5QOKREouYfWfCw51QJwyiY3f9rzWD4t0VfkUPoKeWOVcV63iEc/IN7eUEKerQcJiaDNvSp6g4ZSOAUlQfkhJEtYpSKSB2wpNS4EXZMLEKJPbT9jr69TXmXzeATTu66ND63823JWZQMCENCypgprIOKbs2rB2cpH/KttL2Pm8InAo8YGECa3
 nlSvKikT
 MtAGom74OS7CI/RxWspliqAqqc0frugbSYQ7KXkNS2OsF3eDJktYxLi6mRM01w8WCPA51iFzoUE50Gr0pm04exN/UrndjD4Rr0Q4An3eNc/h29qFgRjuHGBR+gTbzvWsRNQK2sGneSEzOzu2nVN/4W/ySCJXoFaZJb5A5k8vwHpKW1ekTgyLnmQ52RtUdwbyyxsreC4UvokdisryzUth6FSdSl6KrNY5bVaMWG17ntBUuj0PQfOcylStMOk9BHhkyjqKDc5ITCqO7akzo2wmZKHltl7a2UM5RSVpxl5ff/k33dE0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: zhongjinji <zhongjinji@honor.com>

When the holders of robust futexes are OOM killed but the waiters on robust
futexes are still alive, the robust futexes might be reaped before
futex_cleanup() runs. This can cause the waiters to block indefinitely [1].
To prevent this issue, the OOM reaper's work is delayed by 2 seconds [1].
However, the OOM reaper now rarely runs since many killed processes exit
within 2 seconds.

Because robust futex users are few, delay the reaper's execution only for
processes holding robust futexes to improve the performance of the OOM
reaper.

Introduce the function process_has_robust_futex() to detect whether a process
uses robust futexes. If each thread's robust_list in a process is NULL, it
means the process holds no robust futexes. Conversely, it means the process
holds robust futexes.

Link: https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u [1]

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 include/linux/futex.h |  5 +++++
 kernel/futex/core.c   | 30 ++++++++++++++++++++++++++++++
 2 files changed, 35 insertions(+)

diff --git a/include/linux/futex.h b/include/linux/futex.h
index 9e9750f04980..39540b7ae2a1 100644
--- a/include/linux/futex.h
+++ b/include/linux/futex.h
@@ -81,6 +81,7 @@ void futex_exec_release(struct task_struct *tsk);
 long do_futex(u32 __user *uaddr, int op, u32 val, ktime_t *timeout,
 	      u32 __user *uaddr2, u32 val2, u32 val3);
 int futex_hash_prctl(unsigned long arg2, unsigned long arg3, unsigned long arg4);
+bool process_has_robust_futex(struct task_struct *tsk);
 
 #ifdef CONFIG_FUTEX_PRIVATE_HASH
 int futex_hash_allocate_default(void);
@@ -108,6 +109,10 @@ static inline int futex_hash_prctl(unsigned long arg2, unsigned long arg3, unsig
 {
 	return -EINVAL;
 }
+static inline bool process_has_robust_futex(struct task_struct *tsk)
+{
+	return false;
+}
 static inline int futex_hash_allocate_default(void)
 {
 	return 0;
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index d9bb5567af0c..01b6561ab4f6 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1961,6 +1961,36 @@ int futex_hash_prctl(unsigned long arg2, unsigned long arg3, unsigned long arg4)
 	return ret;
 }
 
+/*
+ * process_has_robust_futex() - check whether the given task hold robust futexes.
+ * @p: task struct of which task to consider
+ *
+ * If any thread in the task has a non-NULL robust_list or compat_robust_list,
+ * it indicates that the task holds robust futexes.
+ */
+bool process_has_robust_futex(struct task_struct *tsk)
+{
+	struct task_struct *t;
+	bool ret = false;
+
+	rcu_read_lock();
+	for_each_thread(tsk, t) {
+		if (unlikely(t->robust_list)) {
+			ret = true;
+			break;
+		}
+#ifdef CONFIG_COMPAT
+		if (unlikely(t->compat_robust_list)) {
+			ret = true;
+			break;
+		}
+#endif
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 static int __init futex_init(void)
 {
 	unsigned long hashsize, i;
-- 
2.17.1


