Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB821FEA838
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36BE16B0093; Wed, 25 Mar 2026 05:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C946B0098; Wed, 25 Mar 2026 05:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E4886B0099; Wed, 25 Mar 2026 05:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0A7A56B0093
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:09:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0933BAFA4
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:09:52 +0000 (UTC)
X-FDA: 84584013024.20.E5AA8D1
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id B75D610000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:09:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y7rKCBV+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWZZ6ePUrfQHB8Z/JVxCsE1F+0gZz3S/duMH4Wpbiuk=;
	b=QrVKRCHYu4ZAh0faNYNbzsTMpbKKKaZOs4YXuCMEMR7FnSpmhdt9WCBW5z9On/0nBZwLcL
	k1YXaNMHq54IJd8YY76w7inrqpWWZMhAVtVINGp0hTmuFdEtmkR4FWFuy4yMMLIMLm7T7m
	rINolXaFtKVr2Pu46X5B0B6iDpnrjBw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429790; a=rsa-sha256;
	cv=none;
	b=8jp+oNMLT1lgp8aSsyytszGMkikmTu94KL04ATGbXVHpuDa2GTp660RnriEelK3KqhGcLk
	25zjPKqp5QoQKVKa8FqC4tm/LqNOEvrIj0ASdRU8u1fwxd3v5qa5+vNfg5ARvE1f12LNsQ
	uE1rfncuzb+kwJ7AeZ/se/2Tdf/2WL8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Y7rKCBV+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf05.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=realwujing@gmail.com
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2b4520f6b32so2547256eec.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429789; x=1775034589; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LWZZ6ePUrfQHB8Z/JVxCsE1F+0gZz3S/duMH4Wpbiuk=;
        b=Y7rKCBV+TlSYXl+YyCu5Hlmq2nvz80dfUlD7SHOMhhBabgbiH8A4EcWb/waR0/1pb6
         nj8EX3L0fs2rKOnIsm2iObdAH3IPZJQTAuxKutkMJbijZQ63x/ZkSCHCAzecoWUte5Kd
         mNWP7mXl/tuC2mcEigys9qS2R0ub2rySjMVVlyyra/sKX0mocSfzLO4JNnE9r0skp0n6
         oB8vLqn6eVfzIySgI9LiUgtQMroeiE1uOWwsl8odWbK5ITjvNF/FAoTn58l39N6AJ3lP
         ieJmEwI20V/aFd9zKu0LetXcA0shFU9hsS9VcA/2yQFJLbWFFkxM4hKUkkF8QSJKTpen
         pQcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429789; x=1775034589;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LWZZ6ePUrfQHB8Z/JVxCsE1F+0gZz3S/duMH4Wpbiuk=;
        b=HfuHT3W7O1DBm9YWkj29GHVEDoXVoB0HZ+FLn8OPPOhfMaDlE6a3fxnb/CWDbYIh0X
         VLbz1U+vcC5CsElSuV61rD7iPCqXwQbaWBR14vYl8SUxJjcl8dD3V95en2Ut041rlbWL
         //xurE5s4x3kPlHKHh6jr60sXwmP6uhALc3MjwLTB8A6CfWjhP+NHNNxv4IqoBcx+Ma8
         Ph3mRvHwBkG6BIbCyBXNO1LLW8OhelEhvJjPy7+1E4yGsleB7qcMU0zJoexu2g82uyX+
         pnkyJSfZjNgaXwHvLpucw8hUzQrGNzJzmc9put+xf9rl4Kasmhugj9HIAebzLO2Bx22f
         WhNw==
X-Forwarded-Encrypted: i=1; AJvYcCUIgSsbJglwyd2R+BBUmcaA9Kk2Qyijef8ry8tonsEgsFP09zXXEgdAB1lHgc/oNY++DzlJPQ0uMQ==@kvack.org
X-Gm-Message-State: AOJu0Yxlbmx/KB2v4Llkp8C0CUxccpyX5SLDnOZAEEOY6n4dbuyCBVfD
	GmPKx5TxLk2PkhQ2drQRAKxnQWyhr4eomMopncRYWhZfbgiWf8Z65e7A5Ks3Bl0e
X-Gm-Gg: ATEYQzyUgbO+OBk9e0iRW8mFfJEEIusnLj53RIkJUfVZdBUh8CPkqWXSYz4Q0bmxg11
	CAPj94lrwH5qZts9u0QdnbWBjoZO2l+IltkvrqSn5afQqVh8txasJCR7XJgi0+M0Rzve7ckndw8
	eEU6Ezdp7uG4nUQwCeWrEdBXOo2c+8woFUjKPhgSTtJthcOCa0Mcfg6/oxqq2Qzahil4GUbIkS5
	iKVn0TWGqxwZQ+wWSrFem5XXrPej5ZwwrIBFtQfGMJCDWnRKUKt/Z6gL8ghp6HHZDV756Q0Fi/y
	lj/QdNGtHmD/qRN2jF5pD6lyo8zWCZRfXznCblIWibQFq2sOBc7piUbe9mp7oKbSuElJe/bS1FQ
	Eorr8D6C3ATZFzd3r4Mdk2F4Y5XRh2++xLevW50/0d57Me3wsQTPRYg0uzgPLgVAIvUky2KHCef
	+ARfcLQ0bXPgMcbYKJ
X-Received: by 2002:a05:7300:b505:b0:2ba:a60a:15e6 with SMTP id 5a478bee46e88-2c15d3db165mr1328179eec.16.1774429789468;
        Wed, 25 Mar 2026 02:09:49 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.09.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:09:49 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:32 +0800
Subject: [PATCH 01/15] sched/isolation: Support dynamic allocation for
 housekeeping masks
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-1-919cca23cadf@gmail.com>
References: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
In-Reply-To: <20260325-dhei-v12-final-v1-0-919cca23cadf@gmail.com>
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
 Ingo Molnar <mingo@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: B75D610000B
X-Stat-Signature: np1a7so9ynb8y4qmeubctfmbxhxy6eeg
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774429790-390584
X-HE-Meta: U2FsdGVkX1+XJKoK+z1XerXdkFfJth9vGtNhuISaPe7dieaoaxPrFDM5RDoGTyMG/qPQjJfz53fR6+3qNtaorQKwuKynOe1G3qMSHzbfndAADD79/8fiZZW/PZWdvStVKPvsHP5LePqDnCp4kbvNK74PqnWKMxrb05RgUrBm4cmQbllfKXRAJmdEBtWEg58Du39/FfH4IDDZNBp8PIRU9YaEdI367KZ+EPA3b7azJ48uROH3CbDxdIEcb4AHTk2nTpBK3qqyVaQ324lllsTSSDU8YoewwKys9SqndKmDNomD0+ENKTMZPmXUpfQnH9STkX0CWycPtxOrYZZrncWxCYbtlGTixV7brvhhGhTcn3UhuN/J8CWoXIof2A59E6VbmC4m6u6KhJ3AQCnBqIhbrUtPzyX13M2q32Yf0ns6J07kq3mmWlx36Jy+bl4VT+AQo7/xqUCzIpA/2v0B8/n0n5waNnG3QYK1Fg36CIf7rFbUodkZfZVzM2Cninq332S4z5kJT8sUenENr/RCiI2K2OaieYVu2TGO5C9ar63Gd405Fivqf/3V+2Ranznk9csothIpJo8MXBXquoGT8z990B3iYGshXezpA6J6erNgSAsfAJe9ewiL3EV69Sd4Zvt9W+DfhoOdil/YPh2nyqsXVrSarTNaMisl20hgIZ1B5mshvcf5KryOQFeKKAXvYfYWvOzN1kmV/yUV8kp8LCgyr9mv4SwEhhZgkBFSZQeibfZgn1TD/52Q+yV67upsi0ebRrNGfV9FcIi+X4TrTwXf2TcePPd2lzX6kvZVO3Je/77eeNYi/yy6nZM4KRZAorCsUaswcL38tVoGNgIEY7OkJXfG1VJdMSkln5odNgkUUkVQK0UOsrOB3XGTPH9jUBgNYvAJsPB9HGGGN7Duo9p/exNXwpMwJqhMp7tiCfLXbkkOkZ8ifSit31jhjytLZoHyRnaJbMp3WRiHOBfxasF
 rbW9ViMQ
 EjMq7Momen39SRuZkr5a8iR7cXAC3zQZqaREsalnLjOESu12a9r7k8wAtBN8msCYrBcMoZVjcC3jLDsC6qU2JIoaA8oP45z7CxG4jScReRrSnuhjnIbINz2ByaJZ4ZZdf8GesM/lvL0mR3v8pumbpZB3U4AdcPxswC7c3D1qCSpurBihoehpzd2y4LBKzOyjXBh9Bnu+HYEZTvq7VvSdBrTxJt+YlVo/BF5lK/USn3J7k7Meqt+h/ZzWr15SLaMiDYpSfkJQcFRNm17LNRivx0b1vrMZkfmFbxqVr0Fjgl6PvaUQwiLHxN3mEn45k+rW4TkSquHe2K6vu6luzQO95cx22TqOhJrYOIQxtNkq/rc5kQ7EbEqDVhRdZVFvqLl/0BxLg8EvFRNFnO/XUaFSvwH3PfiZvVNdjCr0PvIdSzITb/0eY+r9m8TbYaGyurPmFuArB9jgOSosvJ2HPf0zcU1B8Hl13ceHhxtxHsDuJbpJZf0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The existing housekeeping infrastructure uses a single static cpumask
for all isolation types. This prevents independent runtime
reconfiguration of different services (like RCU vs. timers).

Introduce dynamic allocation for housekeeping masks to support DHEI.

This allows subsequent patches to manage service-specific masks
independently at runtime.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/sched/isolation.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 3ad0d6df6a0a2..67a5ff273ea08 100644
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
 
@@ -105,8 +107,14 @@ void __init housekeeping_init(void)
 static void __init housekeeping_setup_type(enum hk_type type,
 					   cpumask_var_t housekeeping_staging)
 {
+	unsigned int gfp = GFP_KERNEL;
+
+	if (!slab_is_available())
+		gfp = GFP_NOWAIT;
+
+	if (!housekeeping.cpumasks[type])
+		alloc_cpumask_var(&housekeeping.cpumasks[type], gfp);
 
-	alloc_bootmem_cpumask_var(&housekeeping.cpumasks[type]);
 	cpumask_copy(housekeeping.cpumasks[type],
 		     housekeeping_staging);
 }
@@ -116,6 +124,10 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 	cpumask_var_t non_housekeeping_mask, housekeeping_staging;
 	unsigned int first_cpu;
 	int err = 0;
+	unsigned int gfp = GFP_KERNEL;
+
+	if (!slab_is_available())
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
2.43.0


