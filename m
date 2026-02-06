Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F630EB28D2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:05:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75CF86B0099; Fri,  6 Feb 2026 02:05:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7110E6B009B; Fri,  6 Feb 2026 02:05:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FD316B009D; Fri,  6 Feb 2026 02:05:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E23F6B0099
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:05:50 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1A6AC1A073D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:50 +0000 (UTC)
X-FDA: 84413146860.11.5FEF92B
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf26.hostedemail.com (Postfix) with ESMTP id 369A514000B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YkfheQgR;
	spf=pass (imf26.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3PaHf4BGcLmB1AiF1WHcrlMYrEJBUdJoTjVBNhvu80E=;
	b=1EMl6sSvyrTJdPxG0o5QsxshTdYEBAsGwkIkPwdbM63dLUSLkPl8wboJs4k6OQ562uVRCN
	Y4fUrdToQ14uUx8ig938NmCXwNSEiMINv/FX05Co4IflkhprqG1Gecr3uAcIPDTp0erFMv
	ZptFP8o2AtnGlNxyTxTIKRi+hakgwAQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YkfheQgR;
	spf=pass (imf26.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361548; a=rsa-sha256;
	cv=none;
	b=IQv2ksbHvsmvxPTwOcx5hKkdEM/wFQguMYl/vD8dOmfNDYY1YKS8dOs1iNOpBcJezs8Gfo
	CyFPQekWa2oh60zlL2ScNvCXj1rkK1kCK6mG9ln0flaRYw4OuYeLtcAsqgMr1afQCbOAI5
	PyOq0iWjw+GIl+W3E55K1iELKhVKPXk=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1248d27f2b9so2079806c88.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:05:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361547; x=1770966347; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3PaHf4BGcLmB1AiF1WHcrlMYrEJBUdJoTjVBNhvu80E=;
        b=YkfheQgRF8AwoBUUDqK3H85VZVtKqv79twiXWlxN4OO2kkwIi4BK5g0VB4B0dQtBlk
         2grJyGbLrjYI2erq0555PaLmVeO2OCmiYI+UguJtr0QLIqWnlf9EGBZsdWkpT0XF//+C
         kF+5G2arGjWfbVOD6MQ4IG7ZH760NfxuyeHOEr5J4AlzyOKepU6oXhFsOKQDPspM2wTK
         tlDFYN1SUneArWF/aqcxHwhEhXxArxGF0DBqqxgZH/fv9R2ITMYDt/+BbZxeO07oLyEo
         Fe1Ox/Tg326BRXg5gxnH5WvnV19CVypddr73ooFslA5TblaxtEw7MPyXtB6ItEusfebw
         oI7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361547; x=1770966347;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3PaHf4BGcLmB1AiF1WHcrlMYrEJBUdJoTjVBNhvu80E=;
        b=T2mtdemtZ0Cu5tL4d/7WTALZUaj8FdEwoQ+FyZoTKuQd/RWBL1UPue4Qiq0+OfpxoB
         29m0W6NK14x79t8b1zzJkZ33/W1hUEzIOlSqh8dPJxbO5B9paXlsNbvbOdIXy6+29sd4
         91BF5ogpY1ipTGi7ReM/s9ELrP4oJcyksZuPfXHNCa3o6r8EsoF62/OooR36Wr1Q5+am
         5dxJ/0X5WUg6VeQVGqwPjJsBCFSkzqCEFLyJMFoqBwPs/aiX23RfBV02SPlHm7ciUB+7
         Y6OG5xHXI90R1qmlpPBb7GUtgOWW1CHxHesNC73wO0DT2twnRymY21C2uPojKPqyT7sj
         lHKw==
X-Forwarded-Encrypted: i=1; AJvYcCXvmaUMDfWzqCrSF/CgwlGUf7WnOdZV8y8Y8/gbtj152NaGFk3VAuYpd5D1NvLtNg6sDiBJYYa0jw==@kvack.org
X-Gm-Message-State: AOJu0Yw3s8npXfvocC8dtNT76J5PZzF5pd9+A4PoL+1I8wzU+8R1pN7F
	1L+OaqkNOa0Ei+/bNgXrvSssG9lYoROedY7IaWoV9Ri063p3lGfRkK2E
X-Gm-Gg: AZuq6aKQdp/fBJ/6RSzDYS8F1tPmdLn8Ps5GmnNzjd5PtFUgMJBoymPKrh2TCooUOcM
	fLjmkOD9mlpQHZhOeO5qY1slsq/rnRavVMe4i0bR4II3t/7jkwHBHa7bAymTzCcArwAHjcd77PT
	+o7FP/wc87NAWz2NrScWdEpwnlWK4A11QIqWbqsYdNRuhw7iUn5mV7CokL47DywRz4D3zfyjm7O
	puDyfZBI6eFewNSSqbYiNMGWn91c1nZgNe8CSmJR0Ht0SZlhQJmPVB4zT0KOLWlhU6GomCVqEAG
	oDfJ0Ed8kCLO5FVG5KJ0OuaQ9CKQ3YlkPWAIu1T0de/pxkJaKj/SLwYYXz48cOpeqWokiqO2e5k
	WTaciQpcj/58lLJDnEMvmW9Mb0iBS1qIV8WKz6se6amQeuQuMCXKy13zcvDvzMzfK5NkyVkKbbI
	DNjzsr5smQ2A==
X-Received: by 2002:a05:7022:222a:b0:11b:9386:a380 with SMTP id a92af1059eb24-12704030436mr735238c88.47.1770361546880;
        Thu, 05 Feb 2026 23:05:46 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:05:46 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:25 -0500
Subject: [PATCH RFC 04/12] rcu: Sync RCU housekeeping mask on notification
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-4-00a711eb0c74@gmail.com>
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
X-Rspamd-Server: rspam11
X-Stat-Signature: 5pg85jpux3td6wuaroi3s3s8kj5kkgoa
X-Rspam-User: 
X-Rspamd-Queue-Id: 369A514000B
X-HE-Tag: 1770361547-341878
X-HE-Meta: U2FsdGVkX1+qjb5LRPdz+VHsPZadO/vwQoO9ShGHbgFfOJgzedrafVHdCJDYK3rzSeUzb50bOpjH9SMIBh9QZxz7rUei54HSVZqLZaDMaP4/qoJ0VojoC8WCb6iGHasgKS9r6hGASqyOm0JziZhJGx+SlAqnrvuD8R0aOzOforBzGEYdrt7rfuzF3eHtE5PunVkK6FgR/ZcFm9SiMBbPThGYAr5KngAdUuSYE044VXWQkusz1Qn1g4pJ1rp/hFWxrdxibsTFZ+CNANeYVhUJjfAKpOWPZsZMWqtcMTev1lzhOjPTdqDzIf9SsoeiOWWPcfphVvXPiih3AY8KFJkYWHbKHv1umyddF7auqlmn1PpmjvcKi6GlqkKTmUE21CfryzHAgZExSoo3F/opJg+qmQc4H+j7ikATlZsUQp/PKzlvoskwvAxGKItjBUcpqi1xnfo2DkTqdewRZpTOsX75JZ8cWD2HobKzCwLnFZrxrIxP47BVIOV40MMNydBFuW9QEs7msitBjWwuObQlmEGSJOgLcdYWsc/hnhLB9q0EkWBWeJL9LZzKs7cuOpKkAlpfyziI4YdFljxY9Vhi0CxHVIe6i7c6N/aEd2i4Eb/uOIhaCa8Lw5GU5G/byBrnr01fN7mJJmpc9YIwYQYKwIBrhf7TdmS63Lmay9gID3OIY7Ov5j/CXj8P+X9+FnkLqo1BaneWmVupsVps8wswu0NsOF/1ZTg/pdj5EWLasFxfeLfwCiGCeptnGi18jKntH+K0yClsZm4IgjdgyXZiqgEBtJxCJ79lUOOyFF9+VLVz2gY8xqqc6SPtq5Z9pTqIFYZlPQjezLnvx12iLcPMhi+dqTUsLS30GCTFHlsdselqWoDEUVO4m3CQc89HuHjAyUWGijlXrxt0OCSz2UaHTbndsQqYt3Gutv7Jx6Q6rqazAjgK5XePE53lu0ndhdf3d2r8WiE3QSSE6uPwyFShFh0
 JezRcsLl
 9qAigIlHIzpW60wcvkSQ51E83LlQR0rqyBdNpRWp7T9R4gFTlw1KXjol1N9qORFM06O0j2YZ9eYAXAPm8QLfpOuOqiSrLif+wPtLLfVXJbjQCfY7MkSJ5+LbPuHyEWKGubBmKmFD4k+Nz5vr88P0jIAKCAtAXRB+590RaxW+3mbvsoUh/3Rzn7TxJVgrlbllSTspTDGNB7MggxPdYqU3+10E20kNu47JmtMbIjSmtODDuf0+Kg47NyJMXGeabNFMLueVnJqneANB9erTa+Ztq53/ciEeZSld8pRgEle1hOxttE4Cfq70OOm2gZ90w1OMigNbr0SEm5YyhxgCeImrHHe6MaeKLnCDLzxHyMrCH+e6wvYoF3B1eFu8cCDCCa9aVOpQlIV51kEParEt8FaESPwWZYKx3Eiy5RDri0Q8QE+/AxxB5n57xQ/E6gjfbT+3khFxDvJ1pLtkPU5mE7pjpfQILSEQ3LGn3bbYDJdsf4JkVJZwxmAOBYFahksk1RNPAHRuXAELpx+KlKuxw9VOVBDh8oPtbEJ0uj+iquyogNcbrnJLyMjfMo6/w7Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the housekeeping CPU mask for RCU is updated at runtime, RCU
grace-period kthreads and tasks-RCU kthreads should be migrated to the
newly designated housekeeping CPUs.

1. Implement rcu_housekeeping_reconfigure() to handle HK_UPDATE_MASK
   events for HK_TYPE_RCU.
2. Update the affinity of rcu_state.gp_kthread when the mask changes.
3. Register the RCU housekeeping notifier during late initialization.

This ensures RCU kthreads honor dynamic isolation settings without
requiring a system reboot.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 kernel/rcu/tree.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index 293bbd9ac3f4..ec496e4bd24f 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -48,6 +48,7 @@
 #include <linux/delay.h>
 #include <linux/random.h>
 #include <linux/trace_events.h>
+#include <linux/sched/isolation.h>
 #include <linux/suspend.h>
 #include <linux/ftrace.h>
 #include <linux/tick.h>
@@ -4913,7 +4914,49 @@ void __init rcu_init(void)
 	tasks_cblist_init_generic();
 }
 
+#ifdef CONFIG_SMP
+static int rcu_housekeeping_reconfigure(struct notifier_block *nb,
+					unsigned long action, void *data)
+{
+	struct housekeeping_update *upd = data;
+	struct task_struct *t;
+
+	if (action != HK_UPDATE_MASK || upd->type != HK_TYPE_RCU)
+		return NOTIFY_OK;
+
+	t = READ_ONCE(rcu_state.gp_kthread);
+	if (t)
+		housekeeping_affine(t, HK_TYPE_RCU);
+
+#ifdef CONFIG_TASKS_RCU
+	t = get_rcu_tasks_gp_kthread();
+	if (t)
+		housekeeping_affine(t, HK_TYPE_RCU);
+#endif
+
+#ifdef CONFIG_TASKS_RUDE_RCU
+	t = get_rcu_tasks_rude_gp_kthread();
+	if (t)
+		housekeeping_affine(t, HK_TYPE_RCU);
+#endif
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block rcu_housekeeping_nb = {
+	.notifier_call = rcu_housekeeping_reconfigure,
+};
+
+static int __init rcu_init_housekeeping_notifier(void)
+{
+	housekeeping_register_notifier(&rcu_housekeeping_nb);
+	return 0;
+}
+late_initcall(rcu_init_housekeeping_notifier);
+#endif
+
 #include "tree_stall.h"
 #include "tree_exp.h"
 #include "tree_nocb.h"
 #include "tree_plugin.h"
+

-- 
2.51.0


