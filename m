Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA899CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 13:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09B348E0024; Mon, 25 Aug 2025 09:39:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04C048E0001; Mon, 25 Aug 2025 09:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4188E0024; Mon, 25 Aug 2025 09:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D7DAC8E0001
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 09:39:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 89D5FC040E
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:39:07 +0000 (UTC)
X-FDA: 83815385934.20.A7E51B4
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf20.hostedemail.com (Postfix) with ESMTP id 16EE11C0006
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 13:39:04 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756129146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=auP8PQawW7l5g10Gw5LAB5D5AdyiabZQM+St0UDz01g=;
	b=awA/4cotV+4+l3/7dyQBaBCGZ32rFaEr15jBKcgyi1wb6NE+7CLvK+qPamPggFqeAgo701
	JMJztYWydIYXqrpyIerAOxW7wO9viArQeUbhWAp9HZN0ELUpUylG5bsAwgG8gp/ouJo//K
	u+olBeELBWdA1/CgYcuKoKBKa7DJ98Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf20.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756129146; a=rsa-sha256;
	cv=none;
	b=XHA3UcyKeBMIxvFoLkAqoEpvDWs7UJ8/YgbgMjkLs3CkVTiY1maCopHfhuD/FER7h8kseT
	PDzWxcerzEHDQd03HRTQS3YgOT2i7c5x9k2d0pmxMNvT+DhjQfoUd0U5VK2aL6bxMEX0Sa
	qV8GAFb4ltmMcmo8UPYFn1SEYECfK9c=
Received: from w002.hihonor.com (unknown [10.68.28.120])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4c9X1w3NcXzYkyN7;
	Mon, 25 Aug 2025 21:38:44 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w002.hihonor.com
 (10.68.28.120) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 21:39:00 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Mon, 25 Aug
 2025 21:38:59 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
	<liam.howlett@oracle.com>, <lorenzo.stoakes@oracle.com>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v5 1/2] mm/oom_kill: Do not delay oom reaper when the victim is frozen
Date: Mon, 25 Aug 2025 21:38:54 +0800
Message-ID: <20250825133855.30229-2-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250825133855.30229-1-zhongjinji@honor.com>
References: <20250825133855.30229-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 16EE11C0006
X-Stat-Signature: f3r8wky79zbboyeuw6a8yay95unwm6pz
X-Rspam-User: 
X-HE-Tag: 1756129144-345403
X-HE-Meta: U2FsdGVkX1/0p0nkn81S3B7JhPPgXYbbUgo76TYfKusvfT27+XxLoER3UvV7d7W/widQbuv783Omdyjl3CZYAfjoCLWYPqiJe2jvy4v3n1z2xZsUYzjVw/iMiwGSUqYGnBEh3pJfp7LYaTrXEaen5LmXxrsATOj9keLpjgw2c+zFb4/UJD2zwxfLR5ymXTRVbzDmssKRV3CUHGV7/J6KN/qz2awIebhiD4+dNftn8HFrH8KjyQ3QJylS3yde4Q3ienH/8i0iFsrU6GA4cnJleqa3t9pA7eQTYWFyRfaeaz7fFQwWwD0VYvi0I8wODcVUOnBPFh/NrwsT79h26NHlzgmoEqUr5YWQF0mdsR7/mXxEoKyKMi2DzyUeDQZKZ8w9se28320As6G4G0Nc+uRpefQ/XgvhlRaY4BfqbY3tHmu2LMPluvZbDoqjOx6SxqbWw/qtFhhP5HyYdZhtcLdf7hv+a/cG7D2VncmgwTIDlJ3an6cvp4XIN8sDbHnFt3GK8zAOEeVJGiRlyT1KAatOFQa/vOu+9tH068Olh1wkiLQttzBWtuDuz3eAxECDJD7Ra68f4EUkQMdFbNfH2imMLJ6MiuYHSpaBzwsTt0U57Sea62Z0HkFywW/WPBzCveA2Ftwzo4rOXLSJf/khtQYzTXtxF8mwdd28rP3//p8L2tIsEYI3iY9gzOF+44keF77MivZhslEOSAz8T0paoaPNC3dMBI/PPnAwn2YazicBcqC+8Z3okK3HyoqwPhx+iGJgGMp6fXST9446gj3ADg9HhtCF+hSLBvBdrv1opb40QX8f5FgHPKgxGLUVuYbx6m0xGzd4HOze+IBg0bVmBRvWO3pAK44QyZkXUuDlHbP4H2h8r8Una2wrrm2XHICoXXSomgCWZrAnm6bT4j3VfLNTPEUcFGx0eIrvz2woHq0cUcy3UyEYwG0pn6XeqB61qAJRRUYQqBoc+zfvTyxnVMq
 CbNLhipB
 syafku5AOUddFc9l5Ay0AaxaFaowu40+CmwNqGUWVC4NoYvAgHbj7C4bBJ0helj5DFMhiFp3/Wst/YMwatS5bXn5+7bPRHh56JLXTwA3BRUweNqGXwPzLB60s82BRanBgG+Psi32prKn7OqWHeYh/EF5lY5L09xEkXWiYIIKLeLC6BlJ9ZEoHaYMAMUus5HIchoi9wz9YqAbgLaCzSnG5+TYnm3R3G8AwYiTtYuNeulzWEP7H7l3Z10SWXHVlku2spxfuPcONdxB1DjMjMT5kT8qzj7EkK5yZcSD3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The OOM reaper can quickly reap a process's memory when the system
encounters OOM, helping the system recover. If the victim process is
frozen and cannot be unfrozen in time, the reaper delayed by two seconds
will cause the system to fail to recover quickly from the OOM state.

When an OOM occurs, if the victim is not unfrozen, delaying the OOM reaper
will keep the system in a bad state for two seconds. Before scheduling the
oom_reaper task, check whether the victim is in a frozen state. If the
victim is frozen, do not delay the OOM reaper.

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/oom_kill.c | 40 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 39 insertions(+), 1 deletion(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25923cfec9c6..4b4d73b1e00d 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -683,6 +683,41 @@ static void wake_oom_reaper(struct timer_list *timer)
 	wake_up(&oom_reaper_wait);
 }
 
+/*
+ * When the victim is frozen, the OOM reaper should not be delayed, because
+ * if the victim cannot be unfrozen promptly, it may block the system from
+ * quickly recovering from the OOM state.
+ */
+static bool should_delay_oom_reap(struct task_struct *tsk)
+{
+	struct mm_struct *mm = tsk->mm;
+	struct task_struct *p;
+	bool ret;
+
+	if (!mm)
+		return true;
+
+	if (!frozen(tsk))
+		return true;
+
+	if (atomic_read(&mm->mm_users) <= 1)
+		return false;
+
+	rcu_read_lock();
+	for_each_process(p) {
+		if (!process_shares_mm(p, mm))
+			continue;
+		if (same_thread_group(tsk, p))
+			continue;
+		ret = !frozen(p);
+		if (ret)
+			break;
+	}
+	rcu_read_unlock();
+
+	return ret;
+}
+
 /*
  * Give the OOM victim time to exit naturally before invoking the oom_reaping.
  * The timers timeout is arbitrary... the longer it is, the longer the worst
@@ -694,13 +729,16 @@ static void wake_oom_reaper(struct timer_list *timer)
 #define OOM_REAPER_DELAY (2*HZ)
 static void queue_oom_reaper(struct task_struct *tsk)
 {
+	bool delay;
+
 	/* mm is already queued? */
 	if (test_and_set_bit(MMF_OOM_REAP_QUEUED, &tsk->signal->oom_mm->flags))
 		return;
 
 	get_task_struct(tsk);
+	delay = should_delay_oom_reap(tsk);
 	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
-	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
+	tsk->oom_reaper_timer.expires = jiffies + (delay ? OOM_REAPER_DELAY : 0);
 	add_timer(&tsk->oom_reaper_timer);
 }
 
-- 
2.17.1


