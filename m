Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B20DCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 02:53:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60F086B0088; Wed, 20 May 2026 22:53:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C0306B008A; Wed, 20 May 2026 22:53:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AE586B008C; Wed, 20 May 2026 22:53:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 32C316B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 22:53:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF91C1C0DF8
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:53:12 +0000 (UTC)
X-FDA: 84789905424.29.9BE9A8F
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 113D640003
	for <linux-mm@kvack.org>; Thu, 21 May 2026 02:53:10 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N68r4+iO;
	spf=pass (imf27.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779331991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Y5m3E9nEzq5GBQxTaJ7nJii8dfxHM+tKAT8MqhcTYmE=;
	b=baMf74Sq0OfiaprsryJRGtIdBMpj0aDEFNSgLWVrVl2spSQIfnypEF0RG+D3BqvlSf3btc
	YY/mgAPxAbKEBzfdKv4Wj5K96o7UhQWtTKIiom7yCFJuCsZlCV0chsCSqmB0K0HsGe2+cW
	Vt2/dzWaYBWJh+HUJlHUxt/+7k8V5Qw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=N68r4+iO;
	spf=pass (imf27.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779331991; a=rsa-sha256;
	cv=none;
	b=sWcsgxDxJ8rgB1FgDuqC80VTgke7PoeJaSbGZ9mkijCFfiNTL9aXF/zgbsV+eEG4kIlNSQ
	HgppdbBE7FM3Kni1OZiI+BfTqOSHEFAdFbs094TRRJYuWy3QE4QooBC/cXnIT34ZeZBVqA
	xPU44QHxmD+xUkof3AnIGRd+ENlgd8A=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2b45cb89f7eso37540735ad.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 19:53:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779331990; x=1779936790; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Y5m3E9nEzq5GBQxTaJ7nJii8dfxHM+tKAT8MqhcTYmE=;
        b=N68r4+iO6nKdVjjLyYB+Eh+U6cmd61TzAoIovpnsodw3qseLU66J+Wr1PxqNcIBn29
         5iNdsWYxn+h6KE2b0l0Nw1CvNCch6+5Zy7EvvivNf9fg5dfivg3uoWxWLZtsOoSfiYpR
         6JnI3s8qrg8hmoI3gXBUsDnKlsA1qdjB/Vtq3ZSpkeQQUeZ9R3P/IR8r6XpMSPoMatr3
         7S9DqCOdjIT+3jFTAJNs/GRbxjgBOuTdiMI9+XQhKmk2iBiQGcz+dYcwLegvsNUhWvkV
         vmCfdsdFq/+eM5yHIWIJRxSN2yOGVARgUvSollnoGBoIFoqpncEgBOdaQl8laifZJCL3
         It7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779331990; x=1779936790;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y5m3E9nEzq5GBQxTaJ7nJii8dfxHM+tKAT8MqhcTYmE=;
        b=U9TLEzoB0IBO8t3qBUGMMllbAYunUXriZsUe+TN2ZzbSa6IZULqUPr4OnrRMK2ieD+
         Xw1uKdG2whbpR4WTZ5qJETF4BjBc1FdrL7+gtMlpIUpssx9/faQBvE9iYfsadNl+b6xA
         /yOdJSlFf27NMFRQLguu7MytFiikFXWlT1UDmn2JAl9sK5nouK84Xy8Bp+7eIwWDBrsY
         9HcVuHXTBQC5A3dfIEfGjfJQPDeJ7Ps1EQP9QNly7ZdS2+BxKooelZTwJ+NvziAhitAY
         P6UzKQQf6TFy2ex0XvPIznVJEpy0VM4lm0ezxI9CsxJyzwGFziTyv8GSjXh8/3+gplK+
         QWCw==
X-Forwarded-Encrypted: i=1; AFNElJ9K8leY/88eWsayANFeUAB2D6NC1oh2STIGzD2N2ztP6FWnOiiBKhMbIO/Iole4Vmyz9G+cijNn2w==@kvack.org
X-Gm-Message-State: AOJu0YzEzlNwChJktDvkj/axHOG7EynFyhzTKLrRK1adMVmFXjia3xpG
	gEiXs3HXP5/vnOQRr3oyvYPgMhLQIt1lusfIaT/4jP2L2Ckh2SIQS3Aq
X-Gm-Gg: Acq92OHD45aBWueMRcF5JUqHhEKZ1Qo91RzReDtnZQ8xU5jcHvyFjoUtyOlCHMKFJN+
	red4p3NnzIX0Q4lnzpLy8hYC/57iObSHhjkNsuUa4wpvdPrqML8IUhBgRLBap5FNCQ9/+ReO/mX
	0oJrGkXFIb6a9NHgoMLYFy3UiyRz75ETUyMwMm0KO3gkIAD+ePhQ51mv2Dyo7I5iOWY1uLIDZXD
	4F3XLFtPmZb3EDXeWT7Z3Ttq8qUAewnfdXinc+4rF/cj5uhmaOSIisn2fgQCv3kDRdwL9qMjuzg
	krxLm1M+s9meYn0liGY/ZRg7v9QQouThP6wCQEvPSmpe/CHzsxQmGH97v4dKRIL1f9pBkgoLuc0
	Zn+wPYva+WW7gfEGabuF+BPLlToo9otZvSgvtSbo5sFJRRQDGNPYf64tIwSvfBrLc6/W7j3a+fv
	mXjkInU6KrY9omPr+EEfpOW9roSy8t/Qhf6ena3YN+dsIKs0PAmFXFcblEOmZdSuI=
X-Received: by 2002:a17:903:1ae7:b0:2bd:936c:8155 with SMTP id d9443c01a7336-2bea2ffc757mr8752095ad.13.1779331989779;
        Wed, 20 May 2026 19:53:09 -0700 (PDT)
Received: from mi-HP-ProDesk-600-G5-PCI-MT.mioffice.cn ([43.224.245.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bd5bd5fb0csm218684375ad.17.2026.05.20.19.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 19:53:09 -0700 (PDT)
From: "Guanyou.Chen" <chenguanyou9338@gmail.com>
X-Google-Original-From: "Guanyou.Chen" <chenguanyou@xiaomi.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Kees Cook <kees@kernel.org>,
	chenguanyou@xiaomi.com,
	linqiaoting@xiaomi.com,
	chunhui.li@mediatek.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] sched: restore timer_slack_ns when resetting RT policy on fork
Date: Thu, 21 May 2026 10:52:50 +0800
Message-Id: <20260521025250.1469390-1-chenguanyou@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: osgmnebu1kjw68m4ba3br6i1mx3eknuj
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 113D640003
X-HE-Tag: 1779331990-12768
X-HE-Meta: U2FsdGVkX18zTE+VtfYhXySmlWbywlBmA69eCCQtU6vis3RTgBJYiJvvfZVCGDlCrIRdf73FrqMrm+JMPt1heDAM6Xru1R6QgQWi5dmIttfzlc9iBO67oSBXPdp4stuCVTO8FutI7Djym+Wome7Mm3lRW07ThjkfOvwjX9e6nKbUnk8TSVffRfD/0U3bPRoIOaa4rCan1pJ5aI7gzJvLDMmpyjEdLJaA2wsAalA/6iKM5xPtdtJAb8NGlPytlyHhk3/M4aR0BxXNjL82fwDQcwVq3s7r9g/VY4nxXyKk5rZ03rJjVLcW29MLddb1rZfQ0ypMtBSufvwQsUSn0Xb2mQqL4k7+UfP12hu43GWGgSkbyMDjSHaHQcFR5fJXFGiPkVUNePvNNME189qx7POl67ut5yf4VwdbnylDNbnudtgabIkT1s3lUsGmrxyHDxnGTNl7m8MUGjwT6d5+B1vPgrFxlOrwNY4upr55sb2U23/QyRqR87j/9jiA1fiU2lZnBvQP9CLQIwN7GJ34GXlHpdXqv8/XiWkiJeF5YF2gPrr4AmH5vqIFa+dSHyjTUnu9ngDPDXP0XZkTYZ0wUjx2USp+s8ASJttdAvIxLHGxVdpWxeShztSj/Jbrw5jj4Bqg5m9zSBxGyr9QBdoq/GYY/bfgJm/rJkZfFkcKfrKkJd0qTeLPrCf93VHYG7qVf80hbRNan6hnxJ1LjHOnE08j8oLPqNFVRRydIM4lKQiCM7F4hJjki884uv5svtZnVveVKQLnZCFChUilMc9l2nvJfUtC4IwQKOrqYe9598A5a48te8vW26PfArDQU0ODxwmuhwEHvNYryMlOEBB6P6puRvq4drAYWEsnHJ4mDLAkTW3IYQDi/v/nnlDGN3Y/519cHmLINfmfBD8AtYdtfLhL2BMjN5k7x+JQf2oCKXEp+l3JtqPoh2VpHeqFsRCaPXx0X8nA7qS1KRZa5G+lefA
 HW4Hv0eT
 39cSIyo8gD/nFc0VYPSbiaCJoexwi5Mzz2QxbhsDM5J9CSZnNEE90FZzAPkfeWoeDVpTCwa71b09hPE0EpkZphe98OQz7eilkh47ZFiddIvTdXYu8ko74Tj2u+9TgcCJKo1cyDpiBy7Mu+8S6PEabBtcRE9sianPxrCqHMpfg647KWViFYh6f1fodvbEdZY8GHAoiv6b9g0nxlRc1TegAd/bePHgEEOkEqZxXTxh1vBTTwdpNPu8cOHmSbfmD5ODoURN2ScP74sNvQl/wFXK/XNIxsj76FEnfHyfaao6sngJh6aHqPXgAuUCoxIP8o2WyKzuYsFNw8ref3QVFI/Hs/RyaJijMZgZz+duvIaH1vzpRVSHn58j/ehzgRtwMnjYhKW6de1vteCCzoKHJG4h9CVSsi/EiJjgTn2xNSG9YgWvfTbM/F/ibT5LYQ+vOPdAmwXRTbpESMgNwrmUqHDeJa0Mevz+b7nSU2a3C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values
for realtime tasks") sets timer_slack_ns to 0 for RT tasks in
__setscheduler_params(). However, when an RT task with SCHED_RESET_ON_FORK
creates child threads, the children inherit timer_slack_ns=0 from the
parent. sched_fork() resets the child's policy to SCHED_NORMAL but does
not restore timer_slack_ns, leaving the child permanently running with
zero slack.

Additionally, init_task never initialized default_timer_slack_ns, so all
processes in the system have default_timer_slack_ns=0 inherited from init.
The original fork code masked this by using timer_slack_ns (50000) as the
source for default_timer_slack_ns. After ed4fb6d7ef68, RT tasks have
timer_slack_ns=0, exposing this latent bug.

This causes unnecessary timer interrupts and increased power consumption,
as NORMAL threads with slack=0 prevent timer coalescing.

Fix this by:
1. Initializing default_timer_slack_ns=50000 in init_task.
2. In copy_process(), removing the incorrect default_timer_slack_ns
   override (dup_task_struct already copies both timer_slack_ns and
   default_timer_slack_ns correctly from the parent).
3. In sched_fork(), restoring timer_slack_ns from default_timer_slack_ns
   when resetting from RT/DL to NORMAL policy.

Before this fix (RT parent, RESET_ON_FORK, 32 child threads usleep(1)):
  child slack=0, avg_sleep=38us, ~832K interrupts/s

After this fix:
  child slack=50000, avg_sleep=88us, ~363K interrupts/s

Fixes: 6976675d9404 ("hrtimer: create a "timer_slack" field in the task struct")
Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values for realtime tasks")
Reported-by: Qiaoting.Lin <linqiaoting@xiaomi.com>
Signed-off-by: Guanyou.Chen <chenguanyou@xiaomi.com>
Signed-off-by: Chunhui.Li <chunhui.li@mediatek.com>
---
 init/init_task.c    | 1 +
 kernel/fork.c       | 2 --
 kernel/sched/core.c | 1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/init/init_task.c b/init/init_task.c
index 5c838757fc10..57ff8dae9bfb 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -170,6 +170,7 @@ struct task_struct init_task __aligned(L1_CACHE_BYTES) = {
 	INIT_CPU_TIMERS(init_task)
 	.pi_lock	= __RAW_SPIN_LOCK_UNLOCKED(init_task.pi_lock),
 	.timer_slack_ns = 50000, /* 50 usec default slack */
+	.default_timer_slack_ns = 50000, /* 50 usec default slack */
 	.thread_pid	= &init_struct_pid,
 	.thread_node	= LIST_HEAD_INIT(init_signals.thread_head),
 #ifdef CONFIG_AUDIT
diff --git a/kernel/fork.c b/kernel/fork.c
index 65113a304518..8358df80e11d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2133,8 +2133,6 @@ __latent_entropy struct task_struct *copy_process(
 	retval = -EAGAIN;
 #endif
 
-	p->default_timer_slack_ns = current->timer_slack_ns;
-
 #ifdef CONFIG_PSI
 	p->psi_flags = 0;
 #endif
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7f77c165a6e..b1a241810ce0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4649,6 +4649,7 @@ int sched_fork(u64 clone_flags, struct task_struct *p)
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
 			p->rt_priority = 0;
+			p->timer_slack_ns = p->default_timer_slack_ns;
 		} else if (PRIO_TO_NICE(p->static_prio) < 0)
 			p->static_prio = NICE_TO_PRIO(0);
 
-- 
2.34.1


