Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52F40EB28D3
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:06:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B81696B0005; Fri,  6 Feb 2026 02:06:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34FF6B00A7; Fri,  6 Feb 2026 02:06:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41346B00A9; Fri,  6 Feb 2026 02:06:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91AEF6B0005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:06:42 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 582D11606C1
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:42 +0000 (UTC)
X-FDA: 84413149044.26.B487211
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf24.hostedemail.com (Postfix) with ESMTP id 73D3618000C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NpYgOjaP;
	spf=pass (imf24.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WdBkyzLJQCBMuraYhS3VTvGUYkyPg06X/JmuXKPVjWg=;
	b=yzRBHWtXWL6TXn69j6y6BJWQMNbtedgCdb5dkJ5Se8vaSZ/3VZc+9q6PA63YzhjAjFiyX8
	wMQ2TECDcLEH0bjFsyElgeRpj6BJj987oLcywngZYEFdpOlBZAmG6saO7W26ZGrOLJqqxe
	3V9QwNTdaNCCPfKcDTkCQKin9pFMLSs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NpYgOjaP;
	spf=pass (imf24.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361600; a=rsa-sha256;
	cv=none;
	b=7d/9JAuCc1pQ4q53pfp8jJv++RbyvzvrHv6TwVI83zkVF4z7l70A0EymmYpfzomvsKnq4F
	nDFBBqYLeo1NOAVwUWFZTaAb/C3bFVBMYg4nyJLpMtFdZUa53cuTEKeJ9AfBncfr1TZoag
	55eLJdKYmfMbBMPI6Ccm4MqV6VoEJYo=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-124b117776fso1070898c88.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361599; x=1770966399; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WdBkyzLJQCBMuraYhS3VTvGUYkyPg06X/JmuXKPVjWg=;
        b=NpYgOjaPNwNdV+AyvRJEgTyYX1qG2nd1teM9JsaW6WD+hK0PL/CXak7MP/vUgtTBKa
         ka0FTri1WCVafjBRuSjwlL9FvYYWgpOaEOQhKc8g5fz7ulBtUKQn9FLOdCK7PoUNkdIR
         /obk66yCa/vJlZEI0jE8zpqEBi/C7l8taTCL+ye0rDXy0n+sisxPSCXkYaFLRvYh5RB0
         mCwaMvZE0ViBXtK4n4lWXINKkEt6liFWcvfoO9OyrSXUrUq3ERpOsaS4+/2/w3ds+fky
         L5hYmya8KlovKKplS1wHIyHoMAfDcIE270wjsH9YPjR0BlGWxtbuHI1KFIfrSnAip0fM
         2vrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361599; x=1770966399;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WdBkyzLJQCBMuraYhS3VTvGUYkyPg06X/JmuXKPVjWg=;
        b=S5Y8UTz0WhQ9E2FUGU2lLozrZ+p4Jv/wbstTBL2uxDogO0lvwqmy6GnyM6NvwR5lj3
         Y8Trc1SHK2mWGEGkKOb4HIOh4Lfve0zrzqaKgpVx9Uz/9hV5VCJAai3/zHOJ8WyBDgnd
         AcN78vKhbHtSgLpYUbKor/Whxi98kKd2H62URnzrTF3g1mOy33ecYE8hZUmCK/zx2SIr
         MYUMt9nNNgT+0s09KqCrlsaDtPiIiDRg14b3PoqVJ+MkoLQj9mQ0XsNYTeXfYBfeQx6Q
         QJL6ZO7UDQNDQjsdx1RPtNl1kmv5W9CGA0MAzfa8OljwbDUQ+Q4kA+CQOBGV+Qe6Xbmx
         UUUw==
X-Forwarded-Encrypted: i=1; AJvYcCXL7SOwfuIsbd/uHtxISgaCjamHzC3B2UnSAcJNn7TxMTqnbU6DNBQeg6U6xpFhZEx0QUp6bHJ+4A==@kvack.org
X-Gm-Message-State: AOJu0YydzOHPDMIWl/Q4LEPRS7KHjaAO0MhhtLeu97g7EsnWsbj271yn
	4DRY60IcAtvsB0P89wWXoQ6j2nt1HSBegNMn3C+gi627N/nxqlZL8IQC
X-Gm-Gg: AZuq6aIi08aIUZWNaOpNJLhdYg+BpV3UBNN8/JokQTzFan9QE9R5kfr59h79P8I+LcA
	+wlQyZ/U46XW5a1MRq+xfhwsp5u2Mj9F/naJt6yUPnSCi8rDUGuUm1Vb9b3rMsRGgh3tqXSVkUh
	hpH+pXyN2XPca3Vw6aq++Ar4Eink82aRIvinjwIPS1ZKhIxg1h9OsecopupCJldXB+r7fHkVZJA
	lTPxQRwCtncLbaofYGEWIq0zlRDlmSb9hZOjxP78hAMyz/rkejTors+qmgkcpWX4VHSVgDLg3RI
	X8o+Iyw0Zw7HemeAhvU2L2iIjqhbZwRJXrNrdrZS+x5sawFbNMhJiHNXzLH1Q91GoVMDbZ/8d2s
	d9nf2fIVosFYOi+ySv1uGmy+NDqKayxn48JFfGO16uajQ4Ni19OpX/VrbedgjDP70OjdKYNB1gh
	rWG08Ayp7Pqw==
X-Received: by 2002:a05:7022:4597:b0:119:e56b:98a4 with SMTP id a92af1059eb24-12703fe5655mr919986c88.11.1770361599017;
        Thu, 05 Feb 2026 23:06:39 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:06:38 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:31 -0500
Subject: [PATCH RFC 10/12] tick/nohz: Implement dynamic nohz_full state
 update
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-10-00a711eb0c74@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 73D3618000C
X-Rspamd-Server: rspam07
X-Stat-Signature: amhhfny5p8xxitnm3r7fxp636coc7an3
X-HE-Tag: 1770361600-735613
X-HE-Meta: U2FsdGVkX184UvFII325p/kC+vhaCNloVnl7E9HitQr1uZPA69FnKKas10q1FdAKZLYdkdoMpd/nv+BNLQwHaK88ZPMpZMlBVcDhbhvaikmZ4rVyiSYLVKVcZHSNHIaSFE+sdgECBwIn9kBCpk6qWroMKfURuCA+BNqiL4ALX117C0MFw+qsDEPn8rTBGNk3cVFL4Gsa0uPeNUyhKqRN2ZDvCLgG3Ts0dTjuBST/lj0NcMttOxR26iGMLf1RYSaerAhvvVzboPq4NDj+3A2nHrFXXo7WiHrvRoquqg+TKulJVRdIVlmbTeSwmVGwd+Htv/oe8LIJVJ5d3LgA1kXYj50MlNZgIkNTlRG3CVcqnCTTVBBExTV16SlZ8PRziejkEoC75x3K3/O2rrxDj0KUME6iXlnRSRKb4hfrkLR6XoFP+gOzDJcWEvlHLPy071h9f1Ir0ZOJKh3pze5/PcZMWEelFGmRhbQSLHsL7gKU08NebDp9wR9XLMxfoR4nIO5bZ6UIrDVpMlaHoRkXrNzfEsRPDgmNE5urNe7R0ZaGCvdQMYqGgGb6rgTRTp5hvJBZRj/S9qPifvJ4UQWDj6aVDPIhm0cOOC1yHCPX9ftPK0Sd2jpbnS2oleAPFi+sHxTQVn/uDWRl3YkMEiKOefg5yb++LOiHqy3WVCeilQTdENxLcYOitmfNdK3PKUIsXquGzI/bt2RPu7NxpPxUZjDWxaDJZF6At5/hS4hxIN0npCTvhPvCd5PNIjexVw2thyd+MH2mZ2OQiBEw7mQqQ/0+abGH/KSNaNWNZd+uwyPh8+l2gQ1DsVXn8x4XmBZjaK/UOKd0JPUR6KMpBSTiZTzlEXcJqmcJhbDVr/KSoVoXtjnqBg5+frhC0TTowBgDw2RZoTVPBNtpiZBBhZbVO3e4Dpzgvdb1KT6aZi93opSZIDxURUpctVB+n6UH1dVIDvKSJb/PxMxP6kNn8LFlLvv
 UdyEeKmW
 fAq3VMi1mVs5WUPtqs270YgiyfPSK686Pok+Qo6IcgsyQDEjHACGSUKMfnDv7lZtc8wq8RwWABVWmCAfRCBtUCCy1XOcEl12S0KvivGgdjvKlpPn8XSF9EtUGG2YU3atKkZQSNY+U/UaHqMZI1yPQy39AlX6av++oa+h9/LbjLXb+Hf03whotWQEX5Tcr+DOjTkwAkTZgCn2fpPgp4kZw/pEjQMRI+U7hC99fF60ZaR2MFlu4nT8QsDxoeCa+R3YRkbGMJiFMrzxaciJ8IRCCRlH6gNBfi94t8tmULZFjOjBaqArh/onVCA/mbsCnac1yUjb3EjU6VMntt0KTENpT2BAy8FR/TN8fv/wF8WG2HbT6OSed4/Obg6uuWsSUv2Kmq7xtzlpQhiegbOpR6HeeJbpuPgN0YdtT3hds3LVoZoKVANogUPDvlv5Az6JVb1qP28Rb8MyhhUZl1lZNFBH8Zv1FIgpbNTuHJ+m9URTKgacEw+R8+q6KTJxoq4pfm21np8lC/wexlBSgiH27VQuNbRFyMh81XgQ+NOAcE/4dUUAoq1My/fC9r7HgdlzsugJdHNotYAg8tOt8Kyg+7DLE38U9SyfPJ+PWXMniBudi2dT0Fev1FIcBC6ig1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The nohz_full state (tick_nohz_full_mask) is currently a boot-time
configuration that cannot be changed at runtime. This prevents
dynamic CPU isolation from being fully effective, as the scheduler tick
continues to run on newly isolated CPUs.

Remove the __init restriction from tick_nohz_full_setup() and
tick_nohz_init(). Implement a housekeeping notifier in the tick-sched
subsystem to handle HK_TYPE_TICK updates. When the mask is updated,
the new isolation mask is calculated and applied, and all online CPUs
are kicked to re-evaluate their tick dependency.

This allows the kernel to dynamically enter or exit full dynticks mode
on any CPU at runtime.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 include/linux/tick.h     |  2 +-
 kernel/time/tick-sched.c | 63 +++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 61 insertions(+), 4 deletions(-)

diff --git a/include/linux/tick.h b/include/linux/tick.h
index ac76ae9fa36d..40047523ec8c 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -271,7 +271,7 @@ static inline void tick_dep_clear_signal(struct signal_struct *signal,
 
 extern void tick_nohz_full_kick_cpu(int cpu);
 extern void __tick_nohz_task_switch(void);
-extern void __init tick_nohz_full_setup(cpumask_var_t cpumask);
+extern void tick_nohz_full_setup(cpumask_var_t cpumask);
 #else
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 2f8a7923fa27..01d62dfc153f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -27,6 +27,7 @@
 #include <linux/posix-timers.h>
 #include <linux/context_tracking.h>
 #include <linux/mm.h>
+#include <linux/sched/isolation.h>
 
 #include <asm/irq_regs.h>
 
@@ -619,9 +620,14 @@ void __tick_nohz_task_switch(void)
 }
 
 /* Get the boot-time nohz CPU list from the kernel parameters. */
-void __init tick_nohz_full_setup(cpumask_var_t cpumask)
+void tick_nohz_full_setup(cpumask_var_t cpumask)
 {
-	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
+	if (!tick_nohz_full_mask) {
+		if (system_state < SYSTEM_RUNNING)
+			alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
+		else
+			zalloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL);
+	}
 	cpumask_copy(tick_nohz_full_mask, cpumask);
 	tick_nohz_full_running = true;
 }
@@ -643,10 +649,61 @@ static int tick_nohz_cpu_down(unsigned int cpu)
 	return tick_nohz_cpu_hotpluggable(cpu) ? 0 : -EBUSY;
 }
 
-void __init tick_nohz_init(void)
+static int tick_nohz_housekeeping_reconfigure(struct notifier_block *nb,
+					     unsigned long action, void *data)
+{
+	struct housekeeping_update *upd = data;
+	int cpu;
+
+	if (action == HK_UPDATE_MASK && upd->type == HK_TYPE_TICK) {
+		cpumask_var_t non_housekeeping_mask;
+
+		if (!alloc_cpumask_var(&non_housekeeping_mask, GFP_KERNEL))
+			return NOTIFY_BAD;
+
+		cpumask_andnot(non_housekeeping_mask, cpu_possible_mask, upd->new_mask);
+
+		if (!tick_nohz_full_mask) {
+			if (!zalloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL)) {
+				free_cpumask_var(non_housekeeping_mask);
+				return NOTIFY_BAD;
+			}
+		}
+
+		/* Kick all CPUs to re-evaluate tick dependency before change */
+		for_each_online_cpu(cpu)
+			tick_nohz_full_kick_cpu(cpu);
+
+		cpumask_copy(tick_nohz_full_mask, non_housekeeping_mask);
+		tick_nohz_full_running = !cpumask_empty(tick_nohz_full_mask);
+
+		/* Kick all CPUs again to apply new nohz full state */
+		for_each_online_cpu(cpu)
+			tick_nohz_full_kick_cpu(cpu);
+
+		free_cpumask_var(non_housekeeping_mask);
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block tick_nohz_housekeeping_nb = {
+	.notifier_call = tick_nohz_housekeeping_reconfigure,
+};
+
+void tick_nohz_init(void)
 {
 	int cpu, ret;
 
+	if (!tick_nohz_full_mask) {
+		if (system_state < SYSTEM_RUNNING)
+			alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
+		else
+			zalloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL);
+	}
+
+	housekeeping_register_notifier(&tick_nohz_housekeeping_nb);
+
 	if (!tick_nohz_full_running)
 		return;
 

-- 
2.51.0


