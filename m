Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67142FEA838
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08FA6B0098; Wed, 25 Mar 2026 05:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C92716B0099; Wed, 25 Mar 2026 05:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81606B009B; Wed, 25 Mar 2026 05:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A7C6A6B0098
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:10:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4E84CE0A4B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:00 +0000 (UTC)
X-FDA: 84584013360.07.562EC85
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf21.hostedemail.com (Postfix) with ESMTP id 83A171C0003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:09:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=og3kjz9y;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UVkhe/sbAiDJEUQYidI2AeK8GB4BwtQurPArQfvZeuc=;
	b=Nx2P6GBqDcoWdKpsSxpmUxlgrheR+gfnJVZAaJ5tn1tbUXNWX9GM1gTSHyaqqqQ05KklLz
	cw4tQxzVnnTBynBrfS+wRC5jVrcu3EY3wzco9MWQgavFVqm2foRsx2lfi5HKbFZFFzXVg8
	Ya5OEtVw6k+YxSwsFQ2h2CwSg1o2uyM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=og3kjz9y;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429798; a=rsa-sha256;
	cv=none;
	b=kTG0t5xPOSylnXncBDNaORwy/e05Jqd9fg+zDramLZnw9rHJ5UwcI9AwKcBmpDL5dKJNsX
	KqbzXqn3YIpBvahHZn/l22yJGpjicJa3Ml8YVPNdEkc334E+PyaEOHTx3yJe3EeNC06v2h
	d+Fa2itbNkEG0AAUHdiNq8nSGHXCPj8=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2bd9a485bd6so4096855eec.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429797; x=1775034597; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UVkhe/sbAiDJEUQYidI2AeK8GB4BwtQurPArQfvZeuc=;
        b=og3kjz9yoAnJgHf8ZnY+JiZeS7UUUYY3l2trpluSbgYzG/ALhU9sj/b4DJLZXV1uXZ
         xoIAQ/E4SdAWPK3jKVtTR5dh/Nd1kKJTIzhVk1RwBCfiR4N7+0K/V6R/GCE5GMZrUfPJ
         p0lJWaR6SZZhFqy4DgPWe1HghuSUdDow5jneKIQwhuAt59OmNP0rqOVD3a7Gu/MUei4e
         ynHEEAYyh4QnnhwoODCyYKHSxlD8Qh7VAWZI/sGutaaHawLvdyShT9klV/DMfwWs4T5h
         jeWy+M1//bQs/PFQUxAM+z0emctE0+01dOlEwE4lyOMZb6db+lq3YqwEDOpBh2wQDV/i
         SYlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429797; x=1775034597;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UVkhe/sbAiDJEUQYidI2AeK8GB4BwtQurPArQfvZeuc=;
        b=X/w/4rFSAXYhQLAvrYi1T95KxFIBVws12hlXMxG4lWTcjC+SSb5yBuaBwkOhDg0JfQ
         gEg37MwchppdiRgZx2vsSDYe9ayd51nl6YAFbEnVTGOGiVmR6OR1ufdWdGPoFhzL4guQ
         5wayRjzTla9p7B5+5ABJGr3ASiI6aplGcsyfHNvvQ5Gnw9UY66XpvusCdxFIqFwP66wn
         HVdd3NxX4Zc8yQEh6EOOjePJ8nI0WRSUp1UlhGC1XkXneXwpv+DiGur52Uoa2aKLwWPS
         xqHtNHNt2qhEnyZyvkkvoEWnOPISznpn33/sF3aYe4pPHCvJKDB0nCYMmCA2b/h9d1Sd
         7sQw==
X-Forwarded-Encrypted: i=1; AJvYcCXJwMAg2oLMgIDOK8Zh+B1fu9LrS3EXC185HGRl0G1MMjTtcoK6q2u0nP8oBqvDM9ltHRKmUXaq8A==@kvack.org
X-Gm-Message-State: AOJu0YyOZzMf8HSwTBLXg4LXgfuNxFTKo//JQU8nZs8WnaC2aQPkgY7d
	3PoE2l2uqOBxqJshYDPS8kvKoF0n+5qo18mMQaKeIQPLIO2mU0do1x15
X-Gm-Gg: ATEYQzy7cBPmdITmrqx3eZ7weLEsVq1cNv/wwmFRYmPaXMMCQvypmUnbux3oNQCRPHv
	88Cay+04cBN84rxNes6e1zLvHnJtQHBmowXKpj77ht2P+K9QGd2XM+1cItUow4oZ+/lx9OMG1CO
	nD0hcIHYFRd1KpDz6US/BcUADKoJkd1Ez16NZ7IgB2xnam11jPu4j+s8G36PqUT50Vcz7zkxePB
	gCOCbjpVYpUZ5hVUwafIDJ9ruHSbEj5vfYYVLu2KUmJvSC5Hpmk1lMCtOkD7kibPKGFNiUNZgj2
	03e0JFIleU4dt7BorkcQpmYY8qha71Mt+/NOQQrjVMsT0CdxEibjTu1IvHLKit1oKFeSDFvi/w1
	9hcqc7zZjoYUXWbolUNY/TpkMID11aiE31PsfWO9bcBLfHJ80GnR1v0L1AIbqBQCJqWC/zbqhpY
	vzjgNJRK35z2F2AEvUM5FqFyFAwig=
X-Received: by 2002:a05:7300:a584:b0:2b7:1e86:3604 with SMTP id 5a478bee46e88-2c15d2b7001mr1621331eec.6.1774429797296;
        Wed, 25 Mar 2026 02:09:57 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.09.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:09:57 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:33 +0800
Subject: [PATCH 02/15] sched/isolation: Introduce housekeeping notifier
 infrastructure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-2-919cca23cadf@gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 83A171C0003
X-Stat-Signature: a1jm8pqa6e9we9pcxmenutunny7a9493
X-Rspam-User: 
X-HE-Tag: 1774429798-749710
X-HE-Meta: U2FsdGVkX1/xrrQyFJfzx6fwFQ4ATfL5s3ozlMjAKB30AWMqOd082fLkCYg7xnYINJeWpWXJVA7E5oAeQO0epGWWI56oQU4uUJx+EXdxlSx+KsT2jcZCL/nklea3+DQ2bww0hKTFYecMyTOeT2H4kBO2ii+u9OvNIGUAJtVQVkGm0lLrTa29ocLJXeWEYmEA+MJfvCbR8zsOMwDbsSdV3U5CKN6jbJae8XutbyYlRYUe7f9AKKdjcUv0agxQuCi0SmeR0ddSaO26spmAlmv46N8VQGmkPhFngSzAUsVSNJ7Btnmh4YpOu7wlgs/8pUrqHXv6/orbHHHeD1FRlnPYciACE/sd346Hd+3aPND4poTzT5NfiVqHghtoy1XK+zT9MYViwWyeL9/53wAhq5s32x34lZzVtSDIcoIdV4WyTHIPMWqC+eZ33J3oEM/rRToQKHB2QWB1KwAK+yl65VMJTORu/JRbOxinj1mcUuEub3Bw15inbXeTCWVTLDlQ/XYTEO6BNk+gwEZhn2chE9UeC/B0B586ORdWTITNwkxWBfb1/C5AFHfya/JTfICnhzqPNRHtxycdHBG45WWyXfin3OWp3HU+/bcvhxj3FxynyWneUe9iYN9bLbX2ANXNOaAPCBQxnzueu7JuoyZjej9O/GzR+WTG5yXf31LxrzUNb8DmXJACFUDTBpNs6EuwIhL5tm+ulQbv1x+IX4H8SQ2rlz7gdpmjWWQdAlBW1TyVjstX7dt2zb/vyb47VxiGCmuqpMbksSmh+6Up540vB+GCG5q4480nXHYgQ8q73dcvfEWzTZ4Z1vpWkm9W06YxR5E5Fa41PLSodqOcAtQHUjS767dOi3gCVGANWRbvunr6nyKeuwHMaV141/MLyUms9+LszCw/NND317hfdHOziI5zPyPXDTv24zTIUQcS0u3I3nu1Y2IXONMrejVVoWEl7YuaZn4v2rYNzVeyiQmrqdE
 si1oz0O3
 G+YaW0HkO1bPxeBPUgeK/onO4d0PimiZmpKAK+o0n0iidn2z1fRLiWdHu72pKc7yUWoJaKaqspQatsawNcpRBJWrcGnVeUNKxuzgcyY+WJSV1EEX9eLjd2PhO+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subsystems currently rely on static housekeeping masks determined at
boot. Supporting runtime reconfiguration (DHEI) requires a mechanism
to broadcast mask changes to affected kernel components.

Implement a blocking notifier chain for housekeeping mask updates.

This infrastructure enables subsystems like genirq, workqueues, and RCU
to react dynamically to isolation changes.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 include/linux/sched/isolation.h | 21 +++++++++++++++++++++
 kernel/sched/isolation.c        | 24 ++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index d8501f4709b58..9df55237d3901 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -5,6 +5,7 @@
 #include <linux/cpuset.h>
 #include <linux/init.h>
 #include <linux/tick.h>
+#include <linux/notifier.h>
 
 enum hk_type {
 	HK_TYPE_DOMAIN,
@@ -24,6 +25,13 @@ enum hk_type {
 	HK_TYPE_KTHREAD = HK_TYPE_KERNEL_NOISE
 };
 
+struct housekeeping_update {
+	enum hk_type type;
+	const struct cpumask *new_mask;
+};
+
+#define HK_UPDATE_MASK	0x01
+
 #ifdef CONFIG_CPU_ISOLATION
 DECLARE_STATIC_KEY_FALSE(housekeeping_overridden);
 extern int housekeeping_any_cpu(enum hk_type type);
@@ -33,6 +41,9 @@ extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
 extern void __init housekeeping_init(void);
 
+extern int housekeeping_register_notifier(struct notifier_block *nb);
+extern int housekeeping_unregister_notifier(struct notifier_block *nb);
+
 #else
 
 static inline int housekeeping_any_cpu(enum hk_type type)
@@ -59,6 +70,16 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
 }
 
 static inline void housekeeping_init(void) { }
+
+static inline int housekeeping_register_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
+
+static inline int housekeeping_unregister_notifier(struct notifier_block *nb)
+{
+	return 0;
+}
 #endif /* CONFIG_CPU_ISOLATION */
 
 static inline bool housekeeping_cpu(int cpu, enum hk_type type)
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 67a5ff273ea08..e7a21023726df 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -9,6 +9,7 @@
  */
 #include <linux/sched/isolation.h>
 #include <linux/mutex.h>
+#include <linux/notifier.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -18,6 +19,7 @@ enum hk_flags {
 };
 
 static DEFINE_MUTEX(housekeeping_mutex);
+static BLOCKING_NOTIFIER_HEAD(housekeeping_notifier_list);
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
 EXPORT_SYMBOL_GPL(housekeeping_overridden);
 
@@ -86,6 +88,28 @@ bool housekeeping_test_cpu(int cpu, enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
 
+int housekeeping_register_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&housekeeping_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(housekeeping_register_notifier);
+
+int housekeeping_unregister_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&housekeeping_notifier_list, nb);
+}
+EXPORT_SYMBOL_GPL(housekeeping_unregister_notifier);
+
+static int housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask)
+{
+	struct housekeeping_update update = {
+		.type = type,
+		.new_mask = new_mask,
+	};
+
+	return blocking_notifier_call_chain(&housekeeping_notifier_list, HK_UPDATE_MASK, &update);
+}
+
 void __init housekeeping_init(void)
 {
 	enum hk_type type;

-- 
2.43.0


