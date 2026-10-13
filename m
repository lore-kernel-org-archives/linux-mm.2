Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEDB1CA9ED0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 04:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24F166B00A5; Tue, 13 Oct 2026 00:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D8946B00A6; Tue, 13 Oct 2026 00:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1456B00A7; Tue, 13 Oct 2026 00:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C41426B00A5
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 00:00:40 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 53C7B407D0
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:00:40 +0000 (UTC)
X-FDA: 85316251440.19.079B588
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by imf09.hostedemail.com (Postfix) with ESMTP id ADFFB140003
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:00:38 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zf0riAaR;
	spf=pass (imf09.hostedemail.com: domain of 35azNaggKCNIFC56HB2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--rohitner.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=35azNaggKCNIFC56HB2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--rohitner.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791864038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=jVY4B9rehNRPw7ZQqZE00yhPApXSrH1ROghvzVoFxEc=;
	b=SszAnbQUZ6rGzIqzuedfTW29u55zwci5vx0DmJ9gcindqlF2a5RxbMZXnAz/rQgW6XdZsS
	1JRBD8VkvUuWctNyLJ9N5QCmRC95wlEKt0ySIWpa3nIzNiFpeAIkrH4emh6yRTZFXoQgWP
	ZE2iQz/ZDuWgGE/vNNulMrwrWBqWtXw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791864038;
	b=c5cKwcjVF1MZbF96MDzntFjVQdf8pPXlJyqYyQhhOduyxO3HuDCPycmrzK6nzbnySJtRxd
	SuGCYv0Kv8M5Q8Axdlc/ALHE1lghUoTDKckAxCIQI03CfSR61xYbxItgqcBFV6tPrwwYni
	/YAC4GjZ64Tw+NTgi3JrU2rV8b52dKg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Zf0riAaR;
	spf=pass (imf09.hostedemail.com: domain of 35azNaggKCNIFC56HB2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--rohitner.bounces.google.com designates 209.85.216.72 as permitted sender) smtp.mailfrom=35azNaggKCNIFC56HB2F4CC492.0CA96BIL-AA8Jy08.CF4@flex--rohitner.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-38e54b6556aso1931831a91.2
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 21:00:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791864037; x=1792468837; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jVY4B9rehNRPw7ZQqZE00yhPApXSrH1ROghvzVoFxEc=;
        b=Zf0riAaRsnASOQicrm8AvapD/jwk8WMbQvCeijo6v08Fj2Q9vK/csMnCQ7bbepBEag
         6lTUndgqoxiWQ2LsXFHZtVC+MFdoM33dMGQHtKH9gPM3UyDs6POQDwBsIcAUlbykVwW1
         uaetjs8NzMFk9ER9z1+7PdYL4I/44ygLYvMn5gd8qqMA4eL7aQ7366rSl6zSKDjGpMGT
         BtovGfME6rY0sbWO6UjQJDoEwF7RwDkbsDVo5RX7j6/kT6O4K5XJnN6X8x4Bc1CxfpBO
         ycNjY4q3GhGQSXswNHvJkYKEDeVXfp7eIdvf8ZxRwrZMTpEZXwymbDIdUX6N2OqMpD6q
         i2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791864037; x=1792468837;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jVY4B9rehNRPw7ZQqZE00yhPApXSrH1ROghvzVoFxEc=;
        b=ZW+ESLWJ/NwirAH/Ug/uTP8lUOOLjY9KXRM5O3JJGrVvqE1mkMRD2cfYPmhqd+O/ie
         K8jNGN2c6Ibk6PF++izoLpjmlqk1cyXYQAqFKf0X1BYpshnY5hBC7ViYyo1BT3aA2Wc0
         41UuC0peSaU5kRx71GRByER03oaB7/HAQSiSew80NpTLqqEij5jD0det/5fPGe8yArMj
         Q4bfm4OfN77qfQH1NRUWQhhJBsdg5EUsPSlrSJNHO03O/yX0g5J5Z+USWMO1hhVdOqSH
         Wu1O0E26DIlX2tI1zvL/R1ICrgD8OkkRq7a4Wv2NlmCHBc1MFhy7wPLKU3Q1N8jJUlzd
         B/aQ==
X-Forwarded-Encrypted: i=1; AKwUvBwtolgw9syp/YwK05RwDQC56mqgBH4yMLjRpkHHG5HiIkHLF+PvO8YGS0wtHh06XYM0nHteFhhCPg==@kvack.org
X-Gm-Message-State: AFq9FYLoYT/8TRCqLj86RYC45y7wrUderHzwOFqT5OUtwo3T19mHshHE
	PA/HyH+vV3kO4DmX4miTZcLgpBp+QFb83KhBmQekuZpLpRoKc+reOO9Fk1F+ySXJYzwob9DInsA
	MnqlQiHQoOBvevA==
X-Received: from plbjy7.prod.google.com ([2002:a17:903:42c7:b0:2e8:1305:c8e1])
 (user=rohitner job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d44b:b0:3a8:e1e:3390 with SMTP id 98e67ed59e1d1-3ab3afd49c9mr9663138a91.56.1791864037283;
 Mon, 12 Oct 2026 21:00:37 -0700 (PDT)
Date: Tue, 13 Oct 2026 04:00:34 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013040034.3919469-1-rohitner@google.com>
Subject: [PATCH] mm/memcontrol: log userspace OOM wait entry and completion
From: Rohit Ner <rohitner@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Rohit Ner <rohitner@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: ADFFB140003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4k6y4jz7oaux88cse6xby9oydrzgg846
X-HE-Tag: 1791864038-77172
X-HE-Meta: U2FsdGVkX1/4WM6OQSxwJkyvKOMkXbCqln8ganzK3dlWbbthZSk+WE4QliJS0S8CHZWY8lcTpDXqDJYOBBlckAnpbt4MGldEsLstR6r4Lt8IpG+r3n6K1CfcIKCW+HjrYi593QNWgVUzcfxkEkJKNA7EVDewzyFgjVwC5SytsIKjnRQDHKztdpVXKUsAUEiOkafHqbqrjgqP7WtY7Z8CHF2NgRtH+mJC6SjZekVdefJUTQb6Ll9CO3uLdkz1qtXnmXyK9705OcJPBs4zdcZZo407S+5i14YlKqjBxCvBHRd1pvCTC7LmdgDRBKowCEH4l86A47teRwF2I+23icFro4+rcyNti1vjdWMlkOu1bNN2VmloX+fx18oDVjL+nMKF//YnEpS55Tq5HEr/5n/ss3Fy/tMEhXN+LWf5D4jtOsRdA+jDRUTJCRTfOR/M1Hmtkx3ItV016A0xxe3ELsFSRZKS4dy7teTeYBV1NbZLQx8rGmCJ80xRWsU0K2S5+VKBG28OCSnM7VZuugXr8P0QcGwQkPYamluD4Ze87Fc0/+jvC9Tnjk4QtfY4GGacHzY4J2OKcMQVDrIasE+vk6UkkAysFbPq8foWONOV7YxZCql2GtaIgViXXN1UnxZ4AP0INctTiU7bs8QcAGi7/rnyp+82oEYa6uegfjPKEQAdW1MHn/UQa9Kq38JEuE5+3/cEj2WbVlSttmPJ2TY1GfNOJOCpOlavScQH1CROVZIblD7Ku73xbYdHemit3DwERSKnPztWxnpsBE7W43cIjWSJrJjVx/m0/sN9jXSXqGIR+7sB2KZt08W1Ed3ID3sManQi2wi5b1Wzc85DI9xJ7w0uQWWW8KtEW9le7QB5B+R6wdgtpmaF8eDQfOFQTkqPIonrz7q6qLaiZ1GAj0c2GuCKqDu+uyHdr8AujlCCSIW8z37gtzkwXQIZskqPPIXxBfGYf1l8AALVknUlp6U8us9
 iKbpKTP5
 eGeyI0B4nqjNLSDRC0b6racH2Jqr4+Tz4307KDdAYpOKJBuFxhzeYzCqG6bG8TTQp/lad9ZhDnzZUeeG566nXHmT4o54+qGHJl88oCxZKJMAPbgI6p2eTQnWSodpWcUVP6jmUIYrMhemjQnefgZo+BvPT8DZruP8lnVvMhhsgalc2wDQxyo61BOWaDzuav2o0mOfaFejyLzzcgM7m2hWqFn+HnN7ywGtHu0eaKpajjW4zcFdd4I5HHNdHKqPptQcoLvvVj/E+vkIJ8zL+WtYwonUvumRR4qPD1xwuXuq3XeTBvI3ViafU//XrGULnffETzrREPSClaiq+k5bct0sSpLZs7tCBdCjkZ6mFXiwiNUOofBv4E7Bds4R9196aAU/gqKuVxEO5u5ZrlRHXB/U/tP3S68obM3y6lGX7xT92z2pKx1tqAcBnsX0GM8JViFAXD0TvIUuJFTjjEks3focug5nZoKfczo1qn+RULa5L/fB2NKL3JNw3zWxk6onu3wA3S2vXR5Lm3/scLAnL0rquuhgke6an2h5RMoi/IGqWkY7WZXxfcw29PKwmzwu4wlEDcRd5SJ2/0tWlBKI0rb/eM83SFw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a memory cgroup hits its limit with memory.oom_control
oom_kill_disable configured, mem_cgroup_oom_synchronize() puts the
faulting task to sleep on memcg_oom_waitq and notifies userspace OOM
handlers to reclaim memory, enlarge limits, or terminate tasks. On
platforms where userspace is severely stalled under memory pressure
before a hardware or software watchdog reset, no kernel breadcrumb is
currently emitted when a memcg enters or exits this userspace OOM wait.

Log rate-limited KERN_ERR messages (pr_err_ratelimited) upon entering
and completing the userspace OOM wait in mem_cgroup_oom_synchronize(),
including the memcg path, memory usage/limit/unevictable stats, elapsed
waited_ms, and whether the task exited due to a fatal signal.

Signed-off-by: Rohit Ner <rohitner@google.com>
---
 mm/memcontrol-v1.c | 49 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 48 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 05ef55cae..7832ce11f 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -91,6 +91,12 @@ struct mem_cgroup_event {
 #define MEMFILE_TYPE(val)	((val) >> 16 & 0xffff)
 #define MEMFILE_ATTR(val)	((val) & 0xffff)
 
+#define MEMCG_OOM_WAIT_PATH_LEN		128
+#define MEMCG_OOM_STAGE_ENTER		"enter"
+#define MEMCG_OOM_STAGE_RECOVERED	"recovered"
+#define MEMCG_OOM_STAGE_KILLED		"killed"
+#define MEMCG_OOM_UNKNOWN_PATH		"<unknown>"
+
 enum {
 	RES_USAGE,
 	RES_LIMIT,
@@ -1372,6 +1378,34 @@ void memcg1_oom_recover(struct mem_cgroup *memcg)
 		__wake_up(&memcg_oom_waitq, TASK_NORMAL, 0, memcg);
 }
 
+/**
+ * memcg1_log_oom_wait - Log memcg userspace OOM wait entry and completion
+ * @memcg: The memory cgroup experiencing the userspace OOM wait
+ * @stage: Lifecycle stage string ("enter", "recovered", or "killed")
+ * @waited_ms: Elapsed time spent waiting on memcg_oom_waitq in milliseconds
+ * @killed: Whether the waiting task woke with a fatal signal pending
+ *
+ * Emits a rate-limited KERN_ERR message so that memcg userspace OOM handler
+ * stalls are captured on serial consoles even when booted with quiet
+ * (console_loglevel=4) and preserved in dmesg.
+ */
+static void memcg1_log_oom_wait(struct mem_cgroup *memcg, const char *stage,
+				unsigned int waited_ms, bool killed)
+{
+	char cgrp_path[MEMCG_OOM_WAIT_PATH_LEN];
+	u64 usage_kb = K((u64)page_counter_read(&memcg->memory));
+	u64 limit_kb = K((u64)READ_ONCE(memcg->memory.max));
+	u64 unevictable_kb = K((u64)memcg_page_state(memcg, NR_UNEVICTABLE));
+
+	if (cgroup_path(memcg->css.cgroup, cgrp_path, sizeof(cgrp_path)) < 0)
+		strscpy(cgrp_path, MEMCG_OOM_UNKNOWN_PATH, sizeof(cgrp_path));
+
+	pr_err_ratelimited("memcg_oom_wait: stage=%s cgroup=%s comm=%s pid=%d usage_kb=%llu limit_kb=%llu unevictable_kb=%llu waited_ms=%u killed=%d\n",
+			   stage, cgrp_path, current->comm, current->pid,
+			   usage_kb, limit_kb, unevictable_kb,
+			   waited_ms, killed);
+}
+
 /**
  * mem_cgroup_oom_synchronize - complete memcg OOM handling
  * @handle: actually kill/wait or just clean up the OOM state
@@ -1393,6 +1427,7 @@ bool mem_cgroup_oom_synchronize(bool handle)
 {
 	struct mem_cgroup *memcg = current->memcg_in_oom;
 	struct oom_wait_info owait;
+	unsigned long start_jiffies = 0;
 	bool locked;
 
 	/* OOM is global, do not handle */
@@ -1413,10 +1448,22 @@ bool mem_cgroup_oom_synchronize(bool handle)
 
 	locked = mem_cgroup_oom_trylock(memcg);
 
-	if (locked)
+	if (locked) {
+		start_jiffies = jiffies;
+		memcg1_log_oom_wait(memcg, MEMCG_OOM_STAGE_ENTER, 0, false);
 		mem_cgroup_oom_notify(memcg);
+	}
 
 	schedule();
+	if (locked) {
+		bool killed = fatal_signal_pending(current);
+
+		memcg1_log_oom_wait(memcg,
+				    killed ? MEMCG_OOM_STAGE_KILLED :
+					     MEMCG_OOM_STAGE_RECOVERED,
+				    jiffies_to_msecs(jiffies - start_jiffies),
+				    killed);
+	}
 	mem_cgroup_unmark_under_oom(memcg);
 	finish_wait(&memcg_oom_waitq, &owait.wait);
 
-- 
2.56.0.385.gd3acb90ef8-goog


