Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 914B2EB28D0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00BFB6B0092; Fri,  6 Feb 2026 02:05:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F23036B0093; Fri,  6 Feb 2026 02:05:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E249B6B0096; Fri,  6 Feb 2026 02:05:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D3FE16B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:05:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76E8C1607E9
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:13 +0000 (UTC)
X-FDA: 84413145306.17.9C55622
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf19.hostedemail.com (Postfix) with ESMTP id A27691A000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ajJUYsvw;
	spf=pass (imf19.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q3v4q+lvsBn1hE6xrawKSqo/X3eavnWHmOAy67YUdOo=;
	b=J6LiHec/xW7E3xUcWrEeyxKPxA2ypAR+BqujQZ0FI37gLIhzjc4/lf4mZzlMeEy1BhkFFS
	hoaMdVxp/zTo6AJlLRoKDAzMoAOggZpmT/NHAWrzP9fpjwk2Z3VHGQkUBHokrn9IiMakI6
	Y7h/VEU4g1V0l2ri5b5V6OaYuA2mx2s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361511; a=rsa-sha256;
	cv=none;
	b=r8T9BhB88WNcjJ6bSkl6NsUHKWo1iLdfJCT9zRQh8p9ERbs9aKrEe3BSnls6O3ZCerRT+a
	rzRWrsnPkzeeEvELupZ4sj7PW18ra/MM0V6j0FcFHmxRNcjCCfni85OzVqfhJr9pv9KUbI
	rTGUlq3EijET+qOYZAllh3C+SS5qcig=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ajJUYsvw;
	spf=pass (imf19.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-124a635476fso2705771c88.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:05:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361510; x=1770966310; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=q3v4q+lvsBn1hE6xrawKSqo/X3eavnWHmOAy67YUdOo=;
        b=ajJUYsvwRgRMBl4S17Znz2b21oGuzKHZjnoARFBmQAu/aO9yNcg0ISSv/OAqv45hQo
         hQgyQFD2wibUwt9r73iwAmExHFJgfYkKQepWgb3acCWuS3Uqz8wv/RtZfD/KhSCquAWG
         Xnlhc7QuX2NWaSeq83OM4zH7XOYRH05MQfWztmHp7hQwxSKmSA55HP9SKh8w9t17HowO
         xDh1fouQ1/bwhfTB8jMgw/jn/USyaMLgcbuOa2nCbL/9/eevGtcq5ad3AH0saU1lzoxJ
         MwwYaxdO51Js39j3H5lgEqDS4EameS7EnXKko9sDtvN7sAH2YJpLkFI7/Ar+Dip1IM06
         eSuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361510; x=1770966310;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=q3v4q+lvsBn1hE6xrawKSqo/X3eavnWHmOAy67YUdOo=;
        b=txGTvQhZXT9DVYj195UoBehTCAhqjwAp4VIo3psG53gOoaQKWCbSVN/7vVMOYyGlTq
         69OTi0oFLlrwvmxDiLULXdH6blEoVp+mxecdIgVtYBX1uTgeey6veJyPizEpl/nv80rS
         Ou41wZ7/oWz5Q4kA+vO0fXIUVr261SL/ki8kG5iLmrVs8/XbO+ccZVLik+zjYh8JVmmI
         QEW6kBInbgf0CUQrVxaWM5001YSPWZj8TU2yFQKMeL5c2qhJ4MuibFtSSUdlmS1kAurL
         5sA2nP1wypUA0bxHFfne2hYTrcp+YAHJs0GHy+KEQQ/3tjqbJ1UE3w3kUJ0vO1IZvdYR
         AiQw==
X-Forwarded-Encrypted: i=1; AJvYcCUBJ+/UT0jY0abqpzNMDl9YMkQDkH7EPwVjPN3IosghNghPWZ+g5DUY1atJNJATMA/n/svLA9nqag==@kvack.org
X-Gm-Message-State: AOJu0Yz9a8i2l1rxncNan2V73AZ0A79Pnr/A+jF4n/RX8nf3wfU/9Hpr
	vLo2nIhxpxl6FtImPnuH4X/EcvJGEatu5ZVsGGmZjVnMfef8lAOtEqoo
X-Gm-Gg: AZuq6aIQa05mU/VWyi7srnSay32sGGtfX1ZscMNPoVNHe1KwPM+elKslLAVbTYz7T3l
	A66An1B/GzC46cXfISB4xDaLHD14jovCnhygpMMBGGwtSPO9kiG3fRCnqqeTKdEQZUcycBMzWBz
	ECSv+X3dC4k1KfDcccE/q1qBx1JhZSFQGyy8+CDfLk2+IPZYoNFk1P/XceGVz7q7E1PoS2EXBho
	1shfYAILUPNKMaTbaosLGBBFPShRiTxcWImk5ly6/NUYxFjRtW3PPMiNxmkPGvPy2EKkXxPtFvq
	eWF18RHCUg7TZ7clLYeYgByrg/Jg/bfxX8JH8zt1dEDtiu9gbHEOPC64XsUTLH63S83q4dB5nV/
	g5ziKnh1vC/8YFmujT2xtYSo5kfwdaroXQQE381ZK3p7uIsG2/2SPnni7xcC4w3Z0TUSeE72lhy
	gJmn8r/baPBx8vhCJbYuE2
X-Received: by 2002:a05:7022:4a4:b0:11b:9386:a38b with SMTP id a92af1059eb24-127040981efmr964389c88.46.1770361510084;
        Thu, 05 Feb 2026 23:05:10 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:05:09 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:22 -0500
Subject: [PATCH RFC 01/12] sched/isolation: Remove __init restriction from
 housekeeping cores
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-1-00a711eb0c74@gmail.com>
References: <20260206-feature-dynamic_isolcpus_dhei-v1-0-00a711eb0c74@gmail.com>
In-Reply-To: <20260206-feature-dynamic_isolcpus_dhei-v1-0-00a711eb0c74@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 Thomas Gleixner <tglx@kernel.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 Qiliang Yuan <realwujing@gmail.com>, Qiliang Yuan <yuanql9@chinatelecom.cn>
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: A27691A000F
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xerwhjb4qkw9d1w4skhph6ckxjj6y4yp
X-HE-Tag: 1770361511-535635
X-HE-Meta: U2FsdGVkX18l+t/LPhr9ecJ9azqqTjKPr+OKa1yKe3OQIeyzr78vpdwTacGdHVYpZmue+g9G6KxIUQEYIm9mhKFiUdppnNt1ePp9XmvkwW9Fk6/du5g/WwfL8XFS18AqpZ+ash8QGGPTpzKy+zHFExTtrjhWcAm/Fs6K+Wujc0pA0YGq//XoZe/ZtiFlXGSlp5kcUeHuwRYlMUtfxztvg75fjrYhiv7FvTtfhAbBiZJnMtzANFVtN4X4bcst+sg4gO2REKKmWqV/coMktBpL/Qa7h0cKaw1AmGkXN1K7ROpMRjvurAHDzAnJbJ7JZGiAP46/6pZy5v8SOnOn4lt2nfkBQEW8ZQ5ONSEQnoWCLNAtRpyPKQHXQIT+PuMNZvErVNU3hVNG6vmGT1nRXU/dT3J+0HmONhgIgDbQVFpSYxgTKwQLs5WB76QkD4MLf87QsEl5PGcPBwZsYr6o+pw4Hs/SvnC2eJ0YVybit+L7/qSRa+w0HVufGupyF09j1ipQgW8qhS+XH9pGDq6VUSspzH0yrRAUC1MFh4otMdatFavklS9rkb4E9cG+bTf0gNmGN/vx3G+FdOlAcXmZKVuiLjEXsnoPXETOjdiel2jylJiqDTr0pDaBiwXBIyP5JhwNQQDIQttPhQdL7jXG+nMnHeop1T8e3irSKSjbJrF2utlhXpWF2ebZW3L/RY1qU5Tqv+Xl5AXHRpsSgGxidGZC7XNJ+8VQtlN5WHQ/I2ZlZbIp26eF0mwQck1KNZZjjvFIBWT85pyDMLYlva5CqJVft1KWv00SzF9tjkvW5jTLg+hMlDjthnK3kxJAlnu8rxxQMykYobZAVJYbUXPtGxuhhj/5XsMkcQ7oEkt6g2u3IQ2bleTe40p4d79nDEwBaKlV+hGW7oLPMSk6W3k8/nNywjvg7O+TULzGQ00bQ46bJWlBbQ7/L3MxUuRftlur6hYAHaRU/H36WacYNcLpQTj
 nV0M3nUl
 cHjGEcZc9XzOnwl97AdbWgozjWoo9tps6vkEdfllzXhqtNQchyg44x/rL6A+Ii0P4PBUqui66iK3TtbW1NRjjfBjN75AZQ04olZIojFkyVtwJkoKWLozQ8lO5urTvOwvAx7cwti9G3Wii2uuwiud7l+CeFa+MW70/qjayCoQIslOT3lGbWVEHfzAGejYjiwdhRgGJPs1T+ge88oRPSb7uwgoLq5OdUwtvrkpCgZvD4xTNusNH3Yc1TE5naPz+Xp4oDZQHzwOL4SX5Czf62AsrYwfkfn43W3tNv0/TE8B2QBVu/S/4ho980xuuwfZECYNB08jqgU3cTJ5Cq6cwijBiPOqoMHxfghQ5qYysh7vh3FI4QJQMeBTyMB6+U4tYS/QSVHI0SW9/A4FJIOctRJ6L9bI5i2Wia95T/8HakVeMIACASQ+6iylveV+4rKVCjxYgAEqJUv2YTt3XkTQr5tpqNO2syingiHDIu+X0ZlDbNiD7VsUmdK0BeuJ9zEWQrfLK2lolyRPO4vjAt6Zf7ET3UjS18ztvLH2Il+ivF+qzD3eVQTXFJiwg8bx5APvZdXX6TZvK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current housekeeping management logic in kernel/sched/isolation.c is
heavily tied to the boot process. Functions like housekeeping_setup()
and housekeeping_init() are marked with __init, and they use
alloc_bootmem_cpumask_var() for memory allocation. This prevents any
runtime reconfiguration of housekeeping masks.

Refactor the infrastructure to support dynamic updates:
1. Remove __init markers from core functions to keep them available
   after boot.
2. Replace bootmem allocation with runtime-safe alloc_cpumask_var()
   using appropriate GFP flags (GFP_NOWAIT during early boot,
   GFP_KERNEL at runtime).
3. Introduce housekeeping_mutex to protect the global state during
   concurrent updates.
4. Update include/linux/sched/isolation.h to reflect function
   signature changes.

This lays the foundation for runtime isolation reconfiguration without
requiring a system reboot.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 include/linux/sched/isolation.h |  2 +-
 kernel/sched/isolation.c        | 32 ++++++++++++++++++++++++--------
 2 files changed, 25 insertions(+), 9 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d8501f4709b5..cecb80b09120 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -31,7 +31,7 @@ extern const struct cpumask *housekeeping_cpumask(enum hk_type type);
 extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
-extern void __init housekeeping_init(void);
+extern void housekeeping_init(void);
 
 #else
 
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 3ad0d6df6a0a..811bf6cbe68d 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -8,6 +8,7 @@
  *
  */
 #include <linux/sched/isolation.h>
+#include <linux/mutex.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -16,6 +17,7 @@ enum hk_flags {
 	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
 };
 
+static DEFINE_MUTEX(housekeeping_mutex);
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
 EXPORT_SYMBOL_GPL(housekeeping_overridden);
 
@@ -84,7 +86,7 @@ bool housekeeping_test_cpu(int cpu, enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 
-void __init housekeeping_init(void)
+void housekeeping_init(void)
 {
 	enum hk_type type;
 
@@ -102,20 +104,30 @@ void __init housekeeping_init(void)
 	}
 }
 
-static void __init housekeeping_setup_type(enum hk_type type,
+static void housekeeping_setup_type(enum hk_type type,
 					   cpumask_var_t housekeeping_staging)
 {
+	unsigned int gfp = GFP_KERNEL;
+
+	if (system_state < SYSTEM_RUNNING)
+		gfp = GFP_NOWAIT;
+
+	if (!housekeeping.cpumasks[type])
+		alloc_cpumask_var(&housekeeping.cpumasks[type], gfp);
 
-	alloc_bootmem_cpumask_var(&housekeeping.cpumasks[type]);
 	cpumask_copy(housekeeping.cpumasks[type],
 		     housekeeping_staging);
 }
 
-static int __init housekeeping_setup(char *str, unsigned long flags)
+static int housekeeping_setup(char *str, unsigned long flags)
 {
 	cpumask_var_t non_housekeeping_mask, housekeeping_staging;
 	unsigned int first_cpu;
 	int err = 0;
+	unsigned int gfp = GFP_KERNEL;
+
+	if (system_state < SYSTEM_RUNNING)
+		gfp = GFP_NOWAIT;
 
 	if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & HK_FLAG_KERNEL_NOISE)) {
 		if (!IS_ENABLED(CONFIG_NO_HZ_FULL)) {
@@ -125,13 +137,17 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 		}
 	}
 
-	alloc_bootmem_cpumask_var(&non_housekeeping_mask);
+	if (!alloc_cpumask_var(&non_housekeeping_mask, gfp))
+		return 0;
+
 	if (cpulist_parse(str, non_housekeeping_mask) < 0) {
 		pr_warn("Housekeeping: nohz_full= or isolcpus= incorrect CPU range\n");
 		goto free_non_housekeeping_mask;
 	}
 
-	alloc_bootmem_cpumask_var(&housekeeping_staging);
+	if (!alloc_cpumask_var(&housekeeping_staging, gfp))
+		goto free_non_housekeeping_mask;
+
 	cpumask_andnot(housekeeping_staging,
 		       cpu_possible_mask, non_housekeeping_mask);
 
@@ -203,9 +219,9 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 	err = 1;
 
 free_housekeeping_staging:
-	free_bootmem_cpumask_var(housekeeping_staging);
+	free_cpumask_var(housekeeping_staging);
 free_non_housekeeping_mask:
-	free_bootmem_cpumask_var(non_housekeeping_mask);
+	free_cpumask_var(non_housekeeping_mask);
 
 	return err;
 }

-- 
2.51.0


