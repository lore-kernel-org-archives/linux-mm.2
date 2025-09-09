Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43473CAC58D
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 09:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B95B88E0003; Tue,  9 Sep 2025 05:07:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6D458E0019; Tue,  9 Sep 2025 05:07:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84218E0003; Tue,  9 Sep 2025 05:07:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 960AC940007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 05:07:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4ABB511A03D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:07:10 +0000 (UTC)
X-FDA: 83869132620.23.4D46E03
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf27.hostedemail.com (Postfix) with ESMTP id AF1D84000D
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:07:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757408828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7euXBnxZpuvQOh7WSYP7jyQqINBKgzYXcIdOknS5kLU=;
	b=n51O0lNnBZgIB+IyCXntUK0TU5ZLoDp14KiFLUcRT5xjfk+KmcsSUQ25f4E2JXgZOMuo4b
	S1P9M1Mfo0cv5UrZDzwwvcMwNehAgFjKbP8nLo1Doy/ZzALhHG10r1xVgAotXR/ks335cA
	NEu8InjrZIrQuKznUNq8Olkd6ebqLRk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757408828; a=rsa-sha256;
	cv=none;
	b=Qxt22LkkQOqYJkJpyp6jadhJd3JitA1BZVufBiaKFx+Qg5HmU5A3iBui/sQpgC5HxpYXV9
	gkur+oHG9aOQ1m6pXNKqKie0qKNuGuklWSXIdit+KS00wBRnfO0o3TrgXexqsPgyaBP+w8
	dq1JDgnOFvkXyiSJvqtKq0P3l7HDtNA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from w001.hihonor.com (unknown [10.68.25.235])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4cLdH22Tf2zYl7DQ;
	Tue,  9 Sep 2025 17:06:38 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w001.hihonor.com
 (10.68.25.235) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 17:07:03 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 17:07:03 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <tglx@linutronix.de>, <liam.howlett@oracle.com>,
	<lorenzo.stoakes@oracle.com>, <surenb@google.com>, <lenb@kernel.org>,
	<rafael@kernel.org>, <pavel@kernel.org>, <linux-mm@kvack.org>,
	<linux-pm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v8 1/3] mm/oom_kill: Introduce thaw_oom_process() for thawing OOM victims
Date: Tue, 9 Sep 2025 17:06:57 +0800
Message-ID: <20250909090659.26400-2-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250909090659.26400-1-zhongjinji@honor.com>
References: <20250909090659.26400-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: fcyqyesnhbgzfn5zu1b55k9qcapzy6i8
X-Rspamd-Queue-Id: AF1D84000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757408827-743408
X-HE-Meta: U2FsdGVkX1+txiezNJKhBvq0r+s+ubWL4R4LzpPQA54isABF4kzOYPP1X44Ws2aY0im+gJOBV0qdFHV9HqhGa3pJvfuPf4kNgdG7xl9irCkjueU9FqdpCWvEzDF5wLi/IFoyauF6Qw+tEgTRkYsOLcX2h1TdIVPALaA3TqUW8WsWE8ghXqB3ryRZEMNOvYTrwDbiLJ9rxIvESY6UKseQQNZ4lnRDG/yIbhXpkhPGg0iPhik2RuOo2L+iJBzG1b+BQqHsaczQF8EdQ61lJ8jy8ZasZ/QAeGKp2OebQRBBW5nF8eZcLxrQChsoUNrFlhS/MdqKpn6U5jldf31Hdy+44ucGMcAi95P2yQYph2l27BSL6u/8/aCbTb4DrXJfuyxe1PKj62Dc+z6EMSQrX9bQf/OicLOUo4HGdCuFZF3ZCyVgYMsWgoKlhp+Q/KXDqMWuXRylJcoUHgS4FGleCwK1cP3bwtlMV7vMnDejBdc7mATK8vPdS2viXoYU+Mww8p136oOvQDz6GNRDbLDSs/1j6qze7jVx2OiTkmKh1puxqFCWHj5ggBZaEUVDd2uyPXezWCPMncvgYB2KGzPvy/fArrHaUYv/hjeZBySUcCTCbzjEJsex0+ZJgiu9ERU7i4/wwkF3DO01/yb+CZ5sjMPoa8bIEMXJjoqpiWzENY9pjUji0vuKKXvWYlwhpqqNRXATEWDL7T7L0mHbcwObxLM1Glf5zYcGRthq3dkMGpr+9C3Q/kPDpj6wQw/W0WWGSxRr0xIx5ZjaNZ8G1hzvLaaTdaJNZK7VjuAJVhnViQyYJgLSs/Ey4/TcYymvwexlIzvl9fIM6rF3wHPNIkRZDt1TgWTatOLfiRK5P2X2RwO3YUFHRvtW3bBuWvpCsCJ0c8wqs3XzdorjKeNRjzheOLJ2FJSOnNu77ghIyAAOcLSW8lhVLCVegyLUdkEeIFTA2+DwzbhQv7R/j89We7na/Mf
 ntXw1uhv
 iAT+gZ2Aq/55mevXJuw3x3r9o9yU9PH8oT18T0CWBJmIBgDTtT0j9Xu5WNR/3SYsb7z6+/TODTiB96hzJ07JaYL+pDWVQnvPcXc1AYnKgb/Yg8HA1cSh/AufRu+uMAEjl6erMZpldd63eGd+F/w8S1OChK7D/FAaKRNr40NN+s04GKcWktCjmdy4gq7D7yiBh+OIMyOCrlmuKH2SatLSSkiLo6RoyvlNOW8lBDJ7b59sLFUVJAnroMADJxvdbg6MTuaJ3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

OOM killer is a mechanism that selects and kills processes when the system
runs out of memory to reclaim resources and keep the system stable.
However, the oom victim cannot terminate on its own when it is frozen,
because __thaw_task() only thaws one thread of the victim, while
the other threads remain in the frozen state.

Since __thaw_task did not fully thaw the OOM victim for self-termination,
introduce thaw_oom_process() to properly thaw OOM victims.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 include/linux/freezer.h |  2 ++
 kernel/freezer.c        | 19 +++++++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index b303472255be..19a4b57950cd 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -47,6 +47,7 @@ extern int freeze_processes(void);
 extern int freeze_kernel_threads(void);
 extern void thaw_processes(void);
 extern void thaw_kernel_threads(void);
+extern void thaw_oom_process(struct task_struct *p);
 
 static inline bool try_to_freeze(void)
 {
@@ -80,6 +81,7 @@ static inline int freeze_processes(void) { return -ENOSYS; }
 static inline int freeze_kernel_threads(void) { return -ENOSYS; }
 static inline void thaw_processes(void) {}
 static inline void thaw_kernel_threads(void) {}
+static inline void thaw_oom_process(struct task_struct *p) {}
 
 static inline bool try_to_freeze(void) { return false; }
 
diff --git a/kernel/freezer.c b/kernel/freezer.c
index 6a96149aede9..17970e0be8a7 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -206,6 +206,25 @@ void __thaw_task(struct task_struct *p)
 		wake_up_state(p, TASK_FROZEN);
 }
 
+/*
+ * thaw_oom_process - thaw the OOM victim process
+ * @p: process to be thawed
+ *
+ * Sets TIF_MEMDIE for all threads in the process group and thaws them.
+ * Threads with TIF_MEMDIE are ignored by the freezer.
+ */
+void thaw_oom_process(struct task_struct *p)
+{
+	struct task_struct *t;
+
+	rcu_read_lock();
+	for_each_thread(p, t) {
+		set_tsk_thread_flag(t, TIF_MEMDIE);
+		__thaw_task(t);
+	}
+	rcu_read_unlock();
+}
+
 /**
  * set_freezable - make %current freezable
  *
-- 
2.17.1


