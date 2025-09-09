Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF448CAC583
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 11:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BEAD8E000B; Tue,  9 Sep 2025 07:41:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 097428E0001; Tue,  9 Sep 2025 07:41:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F15D78E000B; Tue,  9 Sep 2025 07:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DB8698E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:41:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8CA481A04BE
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:41:43 +0000 (UTC)
X-FDA: 83869522086.25.D3BDD09
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf15.hostedemail.com (Postfix) with ESMTP id E427EA000E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 11:41:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757418101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DeK+VNQEGhg/tTba8TGua9HE38Ybepi3fhX46MfuLEM=;
	b=mew9VCAgikKEVRYSZ5uMVpkKe/qrPEDvKTQEv9ASkYopP+5wzGLH5i5cSU00YVjWkOvAZd
	rqlHyeiewAj1Z+e1c1PyvVO42uGwI1Wks3j0x1D0zJrP5a8EpmVNwZB36lWn763holCpMI
	Cg8KLCtmC4UjgPrR6ETbsy7Lip1gGSw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757418101; a=rsa-sha256;
	cv=none;
	b=6aMkKCqfYc8QzqCb8E9Vqp6Va8LsS7Q0yaAI/tjNgeQm3IrRF+auL31buADzn2rcxUXtQE
	29mpb/9d8B3FD0zqxB5DS7uG5H3khYqXP7WPmVVd5tDnyZIy7PxOKM3wo7pOQ72Fy0t6Zh
	z5HLr2Dlg0UzV7v1KI2i72iNxOhtVbg=
Received: from w012.hihonor.com (unknown [10.68.27.189])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4cLhjK61cwzYlVrN;
	Tue,  9 Sep 2025 19:41:09 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w012.hihonor.com
 (10.68.27.189) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 19:41:36 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 9 Sep
 2025 19:41:35 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <feng.han@honor.com>, <lenb@kernel.org>,
	<liam.howlett@oracle.com>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-pm@vger.kernel.org>, <liulu.liu@honor.com>,
	<lorenzo.stoakes@oracle.com>, <pavel@kernel.org>, <rafael@kernel.org>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <surenb@google.com>,
	<tglx@linutronix.de>, <zhongjinji@honor.com>
Subject: Re: [PATCH v8 1/3] mm/oom_kill: Introduce thaw_oom_process() for thawing OOM victims
Date: Tue, 9 Sep 2025 19:41:31 +0800
Message-ID: <20250909114131.13519-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aL_wQkwBZ7uLM2ND@tiehlicka>
References: <aL_wQkwBZ7uLM2ND@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: E427EA000E
X-Rspamd-Server: rspam05
X-Stat-Signature: it1qpb7euus7nun1fsuoqmc3dg4rjfzh
X-Rspam-User: 
X-HE-Tag: 1757418100-800795
X-HE-Meta: U2FsdGVkX18cgH2VOwA8QPAFJjFXEkfftNV8HpXQSP7zJqk+iRqrmEOkGVcCksHa7Dd2+uA3NfcUlmJmuLU+i5D/86t3FjsJW3sftEAi6tuUHl+kwZsBgmXJMkasqBuG6yu628lQtl5GoyxunGfLmh2ynuK8oB4ixI1Zsyum/3aHmqRoJG8C/N3MlMdm4oMpwuTP+2JhjFjhf/LK0yrbuSiZ3Wb/riASq6BG1y04ZLoc/Bb3EecmpeDzM/qTRUDobra3s/z2kkLOoh8wzqkLg4u/lZoOtIfTa0iwl2uauFsVANPKrsASac3PgR37J4wOXa++AIeLrg9OtZy9PDUKlJkqxpF3UrnFtafnbgNkZ6ZVDKcJ+2nMUO1zdM6IyYR/32tF7OiWLGphPpM1iFLG62H4fE2EG3jLSOWh1g/3A+mmsQMqM2L98MmKK5XbR4dFUAsthKqhtoZ9JWxCwTvi4J+6Wp4qAa4X19RuJvc8lzzhCJi9pFMzIPERezChc3wObawe3AhcdpXDU8MTQeJFYpQ/cQiKAFBf2+cpV8VVLEeDJQl8UoPO4Mp2yi6R3+Kmt7vJGm76FpenxFeA6rDS9MUyPzL+QfrSsK74/jFSfpLAYMu1VvZnEwkPnPqcpIJj2VpR4P0nYaKf17so3NTgdUqq/NSBgmgEYIrMTTW2IwRG1WEQF60f4xSSXAr+sSqiA5Hb82UBDDYNyTB8j9ScQNTvatdlcGEriUb5VQ0sBdigMpyKYpP43bXFR0ypn4CxY7U4mfIyPZuEzp990HNWrbQp2ohDVkT5yOppocelR3eXs6g1Tpo25EiviMbyxMeu77F5wJ1CpSAAuzaZqzX3G8e6afnih59kx4bPTBxB4ZGadE6zCfeizQv8xGh2WHgUHg234inGyRF6PCZdipy5L8I049BecK5r10ZCuk/yZ/J88S1efv1rTmbombFRHT0GFRqCs8FSzy/xGVkgxIL
 eib1V1Wm
 QgZ2KxvV6pq86h9PVvmAtbeAJeO7LB0sy7zIPXCEelGTvXIU5V9nsckE4pTkAq67UpWKl6dChxHt+KJE3jWEEZEZLdWt1aQSbmSDBdUsqOUm+HuY1/Cra5wgi23mrOJPRm3a6aWLBmY7oljHonAHGCoj8s3NfbFVSthlgqkoHFu4IJRAGlmeCa38MIYj780L8so+5QCnnWEAhdSXEb12Lksz0sGPpYlzCcZnRsi+Fwg77FkvX8dhFUDYcorHs18E5KNZsUiFna86LD2Y8AdJ9dNTd3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Tue 09-09-25 17:06:57, zhongjinji wrote:
> > OOM killer is a mechanism that selects and kills processes when the system
> > runs out of memory to reclaim resources and keep the system stable.
> > However, the oom victim cannot terminate on its own when it is frozen,
> > because __thaw_task() only thaws one thread of the victim, while
> > the other threads remain in the frozen state.
> > 
> > Since __thaw_task did not fully thaw the OOM victim for self-termination,
> > introduce thaw_oom_process() to properly thaw OOM victims.
> 
> You will need s@thaw_oom_process@thaw_processes@

The reason for using thaw_oom_process is that the TIF_MEMDIE flag of the
thawed thread will be set, which means this function can only be used to
thaw processes terminated by the OOM killer.

thaw_processes has already been defined in kernel/power/process.c.
Would it be better to use thaw_process instead?

I am concerned that others might misunderstand the thaw_process function.
thaw_process sets all threads to the TIF_MEMDIE state, so it can only be
used to thaw processes killed by the OOM killer.

If the TIF_MEMDIE flag of a thread is not set, the thread cannot be thawed
regardless of the cgroup state. Should we add a function to set the TIF_MEMDIE
state for all threads, like the implementation below?

-/*
- * thaw_oom_process - thaw the OOM victim process
- * @p: process to be thawed
- *
- * Sets TIF_MEMDIE for all threads in the process group and thaws them.
- * Threads with TIF_MEMDIE are ignored by the freezer.
- */
-void thaw_oom_process(struct task_struct *p)
+void thaw_process(struct task_struct *p)
 {
        struct task_struct *t;

        rcu_read_lock();
        for_each_thread(p, t) {
-               set_tsk_thread_flag(t, TIF_MEMDIE);
                __thaw_task(t);
        }
        rcu_read_unlock();
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 52d285da5ba4..67b65b249757 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -753,6 +753,17 @@ static inline void queue_oom_reaper(struct task_struct *tsk)
 }
 #endif /* CONFIG_MMU */

+void mark_oom_victim_die(struct task_struct *p)
+{
+       struct task_struct *t;
+
+       rcu_read_lock();
+       for_each_thread(p, t) {
+               set_tsk_thread_flag(t, TIF_MEMDIE);
+       }
+       rcu_read_unlock();
+}
+
 /**
  * mark_oom_victim - mark the given task as OOM victim
  * @tsk: task to mark
@@ -782,7 +793,8 @@ static void mark_oom_victim(struct task_struct *tsk)
         * if it is frozen because OOM killer wouldn't be able to free
         * any memory and livelock.
         */
-       thaw_oom_process(tsk);
+       mark_oom_victim_die(tsk);
+       thaw_process(tsk);

> I would also add the caller in this patch.
>
> > Signed-off-by: zhongjinji <zhongjinji@honor.com>
> 
> Other than that looks good to me. With the above fixed feel free to add
> Acked-by: Michal Hocko <mhocko@suse.com>

