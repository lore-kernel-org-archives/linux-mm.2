Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29C90EB28D2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F26E6B0093; Fri,  6 Feb 2026 02:05:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88FDC6B0096; Fri,  6 Feb 2026 02:05:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 791E66B0098; Fri,  6 Feb 2026 02:05:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 667C96B0093
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:05:22 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EDD75140780
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:21 +0000 (UTC)
X-FDA: 84413145642.23.32238DF
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0D5A1140002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y63vosr5;
	spf=pass (imf09.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pOd/UWGDzn8jr9iF17p1rTKmc8F1m4wqgpJ+mmp6cko=;
	b=n93b3QwmV5R5eun2v5bV2NgIwEuR9a2Scdw5/WUO+oUmWKHTudcNPVvUdWq5Vw5m9SYyRK
	WiF+jY6/6lxQAI78h0qmGXYUCVcOclemcGMY4rcjJFRr7ScMXl3TMbuubVOzNHrIAAQ6rf
	pdoljINmxCwkCHzvGxWwGUHgPM2Js2k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y63vosr5;
	spf=pass (imf09.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.47 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361520; a=rsa-sha256;
	cv=none;
	b=wjQurlAvlLNJm1xghxIHmk8BMYqMktrH7AK06x8FPiMOHi22NJCZkZitCLaJT+jwbLQEAt
	xhDmCB5xziRp4/cSw142LqkVqIbJ2Tcffi74GpCDmXUrIlN7FsV54nXe4+S7KnGvEfl1Lm
	QYKuxcYeJvAXLq+lM41yY0T8V/OjWCI=
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-11f1fb91996so721073c88.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361519; x=1770966319; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pOd/UWGDzn8jr9iF17p1rTKmc8F1m4wqgpJ+mmp6cko=;
        b=Y63vosr5afRatrIdEmAkjlDOFxUzE52vkuvu1+v8ota8pdxbyqxWVcLQy6Vp1ai1P0
         m/103OPAIzbdIs8e1QMCKGKoXxe0pNpAlRYFw0WFdTGPChYt9Z4YUzT7xOVXIVB2Jrnk
         gOi5B2IsB1mP5NufXHyf+6vYo5TGauBGm5HMY5+glgL0phXgvhTTxkuiM9EHshAjOvmx
         jnanm0OZFO9NmVxNvejN3zbZbQqee653JeI/V+edm0pyGmDNF/oKiz9o3CBktKe+wAQK
         K+6KeZG45m7Fbqx+4MqmEgBxS4V7zlz6jTVc6/qmsndfxVS5worNMTk67h1ThXvK0/ph
         NMUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361519; x=1770966319;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pOd/UWGDzn8jr9iF17p1rTKmc8F1m4wqgpJ+mmp6cko=;
        b=ZjT+/9YlybbGnJ+3y3QAk7GJZ6p4VbpqveBXyZ562wE2gmV5YOF8xSFqVvMejbz0Ce
         c82AtyVhxEp52ynQco9Z/ieICbbYj09lSBk4/XODPItGPLFPOR8ZeUWmK/BxC3qLcP91
         t5PoXbiC8jbD05Nt5awhkhw4yOopQcqueuRZT4Y6sorCuSa4NeqYTr9q/7u4kS8IyDur
         RbD9ODlgpHqdYNXXFlH0PPr417h4J4QKnyK1XQ20O6pUN39BjIla0Bf0X9pCKnrzkqg5
         TYgZxSKwy85tpWGN2XxPXnCYwTnTryEYF+q6xky7hltjd8pkgEKcLdTlAd9TYp0wOAwo
         /Mjg==
X-Forwarded-Encrypted: i=1; AJvYcCUscG7r+gH9NpeTcqm1g8eJAuMSvZjbLnBZ4hYH7wHbwfnmsqo/h4Ve/TZLG0R8+tGoCucIrFDrwQ==@kvack.org
X-Gm-Message-State: AOJu0Yz70dW1nSUD6Rf9GZ2rGsPaFCRgbj50sUTQy5bnhk/wKUdn4REY
	SfrvG19vzcL7Ir8ZwNBb/o8XAFFJi6auIhLp0jFoo23yj0AQ1PcmalqM
X-Gm-Gg: AZuq6aIaSnZyp0KYZGhXk7caFuyQaNQAQkmqnmBalW8EvzlKXEOHNTBZ17YnY6JYcPH
	OM98xiJ9Cu113R3A4rUU3T4AbRgcJNwRD4oozBfehzYuaGub1yMJsS+/qocfaPbcM0XQ35x+P97
	OcK8XKkIKJgF9SofF8jAEf/XXAgMj069IssSHqvNalvOaOs+qL2OMs6E1b8xNDaF3/iA/Qp4gsq
	iQypZSHWRZAV3V2n268ea7qF7H/zXDS4qPCXw+W86PJH5icgbKqL2qKnRlaTBnkp12eTInal9Lj
	qos2Gv1dCiUprUzvcr5J7Dhhd9bqL884EMSMnPRTjoGH7HzeFMSzdq7atjicFFAXTYJB5UjvD/t
	GlIg44jI5hEd9J2esPCkFT1PioD6ga2VddAJ7WEyMF+1D5vQ2w+7kFVKnpnvqgD5gU4yu+wjnp9
	VOgevq9olfXjjSJ3IWLB9U
X-Received: by 2002:a05:7022:492:b0:119:e569:f262 with SMTP id a92af1059eb24-12703ff13cemr1009542c88.11.1770361518689;
        Thu, 05 Feb 2026 23:05:18 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.05.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:05:18 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:23 -0500
Subject: [PATCH RFC 02/12] sched/isolation: Introduce reconfiguration
 notifier chain
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-2-00a711eb0c74@gmail.com>
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
X-Stat-Signature: bdw34it5j4ewqtwp5yq1xhmj67o5tywj
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0D5A1140002
X-HE-Tag: 1770361519-507314
X-HE-Meta: U2FsdGVkX18C9v6Ipp3hz/ab6/4Mb3sSF/6j1XNkSwuV44bbAQzRS5l8F8cZAKphjR01E9zlmHGOVcyl/zJyhn4C+l3j6twqtU3cTbe9ZFksTHFm+NCJm2le7Qyw/UF/OSJEUnGqY81o+ZkaCOsjuFCbxSixktaTq+gzcMjIgEruZseQts6+7fzHAD1qCtNFZzZb15G75anzp+GuVNjHiqSWWz2nhQLBnWpckZpa4fIb7eoiAL4bIhCB0wF9f14g07DV6R9XFW7UuCfUnEi/TH7jaOctAkuImeL+QN5U3ifC3prBDv6lhoK/Wgze45AQy36E6bIAtL0slYr2a/SDD4Yg+De5NZFQ771YpzIOzI5jH4H7fGtpbP8jt5b1pudA29oZ7248yGOvuEdRpEtsfbjNzcQjA9rwidVL2y3BSuNGlH0EXTrDQtZQ3+qOzINfgSLSvJZ/sR4iY3q+cKVGC+ZztFW3alkoRn1s3KYlDNFTygjccg19eN/Pihir1MCmbtPBdD/Y956v0CiDb56ZOnVJBj58Ln1y8+31GKZ3U/oe4+e/JwlAGl1UDpjMLF3ciR4xpaGyrUe7DdzGpYLBDa4L+VGgXSFYqx1DPj6efz4oB51+AdTcTSb8HE3dHzlONcga03O0GuDMOEtqt+T0VyNRMkawCGUEU32H9NsECpJeI+gNlwfHbyy3da/j6cSvoEYMPyBabw/6fBEA36s30W6KY8nXTWZfhLw7J2H4rpbJmhRowcS3eiRNoBB02hYiREg6hBkpra5yltv+uC7kMdBYelYS6sHWrmJHk0VFV28KaqWpOax4rqzaOXQgTk0cGbrrFC2LfPkVWZKJ+CtouhMmdjgG+hfKbzd7hBq0cYOGDoRqh+KPjfVf+A3dAxBjgLtCW9N4+xLOoNUysIIxFHVoDeHIeqipDpTfjoqOZzQkR6TCy5S4hSkUaR28jyo4m4cEGg5Ey/bhxO9j4Ne
 v0bfyJI1
 74JlvRO/SApHQqVAt5loGcWw+Akd9wxkC8vzUsaKH/twrkjvHjIGtvYBuX4lMWkEuOJunzuHo5iX1+ygcxqPaS6+GVzDjcDnnv1lDjNffIx/0eO025YkOLCc0vKLJDGZ+KQFe4yjCBj5mvutygEPQWpGNk457NDKVZmxHZTPp2wF3dNGVbydQJfyvHWz5D515qq06+LjyFdr/WhwzLYhU0t4n2melWEQ8TcOjBslzfCurtiDBVAmFLFI6Mn1nFOll1K1Gdkx0+iMgiWCldByUeq+bkA814OCQA7XwJ7DynSofjiW/WDffv4P6iJmSrEoroAub1sEI5pS10hhmqe+1jfDiCoTDtPOdsT7PQUvZpICV63mlYFpzuXs3lud3vwXgbCxd0nXY54dJFj7Nc3xeCGz6RxQpc+bfIBSK+/ZQQBbpoRZNdtGLUBJqtUi5iMB4hFZhX8f8mZHNVp0/OE1uw/KAQueF9NYeAjll05m63cLqq8pmkp/e7ncRWZHjYDtmPEd0aLOrrmQEsrnql3brrtmmuvthUlu/CH60EjgGrwIgWbeV3BqAwnvzXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a blocking notifier chain for housekeeping to support dynamic
reconfiguration of masks. Subsystems like RCU, Timers, and IRQ
management need to be notified when the isolation state of a CPU
changes at runtime.

1. Define 'struct housekeeping_update' and 'HK_UPDATE_MASK' in
   isolation.h to pass update event details (type of housekeeping and
   the new mask).
2. Implement housekeeping_register_notifier() and
   housekeeping_unregister_notifier() to allow subsystems to subscribe
   to updates.
3. Provide an internal housekeeping_update_notify() helper to trigger
   the chain.

This signaling mechanism enables other kernel subsystems to adapt their
internal state (e.g., migrating kthreads or timers) dynamically when
housekeeping masks are modified via upcoming sysfs interfaces.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 include/linux/sched/isolation.h | 20 ++++++++++++++++++++
 kernel/sched/isolation.c        | 23 +++++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index cecb80b09120..5c07e3e9b8d1 100644
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
@@ -32,6 +40,8 @@ extern bool housekeeping_enabled(enum hk_type type);
 extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
 extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
 extern void housekeeping_init(void);
+extern int housekeeping_register_notifier(struct notifier_block *nb);
+extern int housekeeping_unregister_notifier(struct notifier_block *nb);
 
 #else
 
@@ -59,6 +69,16 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
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
index 811bf6cbe68d..97cc41626a33 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -18,6 +18,7 @@ enum hk_flags {
 };
 
 static DEFINE_MUTEX(housekeeping_mutex);
+static BLOCKING_NOTIFIER_HEAD(housekeeping_notifier_list);
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
 EXPORT_SYMBOL_GPL(housekeeping_overridden);
 
@@ -86,6 +87,28 @@ bool housekeeping_test_cpu(int cpu, enum hk_type type)
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
+static int __maybe_unused housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask)
+{
+	struct housekeeping_update update = {
+		.type = type,
+		.new_mask = new_mask,
+	};
+
+	return blocking_notifier_call_chain(&housekeeping_notifier_list, HK_UPDATE_MASK, &update);
+}
+
 void housekeeping_init(void)
 {
 	enum hk_type type;

-- 
2.51.0


