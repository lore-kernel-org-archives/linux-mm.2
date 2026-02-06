Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44BBFEB28D3
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:06:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A42006B00A5; Fri,  6 Feb 2026 02:06:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F68C6B00A7; Fri,  6 Feb 2026 02:06:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E17A6B00A8; Fri,  6 Feb 2026 02:06:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A50E6B00A5
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:06:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2D60C1A0746
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:34 +0000 (UTC)
X-FDA: 84413148708.07.81DCBB0
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 501311C0004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:32 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Sg5DWF/V";
	spf=pass (imf20.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l9mXbrAaMtQHRTGDa3ewvpAsXiHuJtYFWMHk8lDDECc=;
	b=CrzTdWQywol3ZdPjn/vlsxQbB63N3D/XmiqLSBOt7ui+WgaW6ef/vKcJ3LquTnyzh3Ya60
	c8jl+4S4ypGmtCu+CX0aFJtlBPlVRNMokdV5RRrNxIQCgiQHNMItaNUsOuXKKXiU44pbEe
	zj3YipC7+R614mrxKTUQvVGcvBjcwJw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Sg5DWF/V";
	spf=pass (imf20.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361592; a=rsa-sha256;
	cv=none;
	b=jmG2WnH+953iTWHwiRzPkdiVe9aXwgLh55XF6IUhpYjc9dJK9MF9QUnf7MW/4xdOYn+a/V
	dESBdT7Ai7vnks1tfTkmNJDipLn15+M5jFn6pN8U8NzDu3I0CsNMTIvwDgxvCoSccpCDox
	4difMVaARyCL/40j9+TtFLKSwnCZmd0=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2b8397e3e09so2309682eec.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:06:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361591; x=1770966391; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l9mXbrAaMtQHRTGDa3ewvpAsXiHuJtYFWMHk8lDDECc=;
        b=Sg5DWF/V1ukzxJSL2RP/1IRHFiJaXw2rwCeqfor3/DwdlrJXevZctapKudwHxou39U
         XqmbX0te1x31WZpEKgu+8AMoWIKosTzCrz6+ESZrsrDKHdF71pK+Mn8Bnq3BEv1kyECV
         nKerrnZEDYv4ftxOX1BxfXKQFToZZIGDNHpncMjid94YCcVuBjZmRAzJKzq/L/hon4A0
         Y09dJjwqyFtD7WItgYC6Nmtiyund5rno8ZdC1FMktUc4lihNXEUgcKbNnNZp+ccLQIFS
         H9ehWQm/e5jWPTy/9KGoqHEW6KmVxY+BVh6TU2BCfJgbHsTZ0kN5MVU7lxwpItuR6Nsh
         m6Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361591; x=1770966391;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l9mXbrAaMtQHRTGDa3ewvpAsXiHuJtYFWMHk8lDDECc=;
        b=kb4sPJxkQrq5AAeNqd4e4ITva2tIrL79WvKBrreQMX43H4NAESo9zx53sgU7YMsLUP
         eLB04WHGAG3uX1v1U7gKvrewh3HvPHZEELLzyIJHSVy7XYJTX2M+ZkfEZd2Spkiginf6
         oi9tFnVWLtSa4tzNOpBguyFWn70purHMtAXGAyJH/0v/6e1jgryhOqgmdTb5zytPCJkt
         bQy5AC3IMXg1R4Vmwhj+kAbAkNAJ87U3giateRun668Ticife9GjJSQBug5LvpTCmR9D
         2BgBYdnM/fRGcxvNfq4zSG3bg4LMg717o8RkULx4XjFxUOMHaNxNOSaUFN7jchjSACIg
         A4bw==
X-Forwarded-Encrypted: i=1; AJvYcCVXEXbHuZsevCqD5VYFxvzWjijz65xsS3K4rcBJHaKhYB30I8UPqEnFInzCYmIAK3lIrXIVoNH7+w==@kvack.org
X-Gm-Message-State: AOJu0YzDoZhDNncZGTHiTCrzmBq7rSq2Z8/WfO2YsuPNSlsdlBxfyXJx
	8OtCz3oOXA5wdtKqc2WoYpaRsoRTRJLQnmvgHdV5xFhyDcqQXL/1MwrZ
X-Gm-Gg: AZuq6aLJhfYmGaAi5/ccZldqQdm2lPoDI1uO+Gx+Z5cuOdEr7wlTh1N3JElC1agwM7v
	+4UWLNxk2ehXC9V8ZQW7wKwLEdmSBOGZ2dGJU8CkfbWCJEFYnhRyk1LZgc8egVLKoaIsZcctGa1
	3WOmaPPrtwEiclKtXBWFH3hi8Ldjk0v0cFi2morB5A6Suf7yhTIdFKQAFs77R1hTvHH8nGpX0J5
	jhgRIApQIGgzWpZcKSQlAKdLcWnLBp+Ix7FckYh2nj6w40F2FEuNYCn29Hsi6txgQGlNEcD0v8T
	vCu27e50RrebcJUX1REpq4R/Sqf5VrqTyuqM0uEXSHcI8w9H7Z291uT39Jrz5vNU3o+oZJ4HTBN
	WGfFO7Yk6rGPteXFhcGImUSlq69v6PNIC9W0w1Y9X39lU0sD9KWcNm8RJJf8h2mlhgwXAWe5gIu
	ppQ1cihE1AR8bmNyuWWvT91w==
X-Received: by 2002:a05:7022:6612:b0:11b:9386:826c with SMTP id a92af1059eb24-1270405f72cmr986038c88.41.1770361591067;
        Thu, 05 Feb 2026 23:06:31 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:06:30 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:30 -0500
Subject: [PATCH RFC 09/12] sched/isolation: Separate housekeeping types and
 add sysfs interface
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-9-00a711eb0c74@gmail.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 501311C0004
X-Stat-Signature: bbjfmezfkzw77kbt558i9qhih4xgkwqf
X-Rspam-User: 
X-HE-Tag: 1770361592-657341
X-HE-Meta: U2FsdGVkX1/oXbIreD6i6HeHP9OUGTjymZosXT27fiP85IBYCxd3vtXS6k1b1PzSk2Upc62k7YMduw8+1n4hL7e506AN9cRFsxJnRmpTAbum56U7hIoCJkap7I1Vz+Ny56Qxtut2uEI8gxkVU5G7sQvKfyF+G4zDM57L54SCTIc9IwmmdHj7/BpgZhsAi7OX+cmpiNWzPhYAenYDXzxMc1b9WDmMR5QeX9K2mfbll3aSRMi3hZaoH1/vLOR9nlyOV8bvkBRx4jUKVuBnpd1cqNakGnd1KMP5qOTYIILCRoWSVbygoPxAsruoWQ3eEVmj+exXGy2BMEja3/sjEkCNjuYkWlOjs0kFu3iPLmFVvjq/EWN5OderpR2526Zcq7btCkZJhPS3v9daFhxCxriiprLCU9ecMe2uSHR0xYNK+zfmgB3owaa1R4Ajf2OgyaNon41bWZrN3M3yoZNsibMUOSSOkVqvQlCLSRdxu3f0+FQ4y3hYcD+2/CbnuR0vwFqOzoiGf5ZMA6uMFULWKR1KbvxDw8l7xw8tcX8AdLYG/6fHJWG6wfmuuZPRJB2+GQvPMnzmkpXfC+rBtuuiPDE8Sf5wCRZWCe3wM2uGm/SJPqTGLEBrFzALN3hiZa38dYQugNT5kCKwYrur5X60V/kl3WppRrLj6r7f85D8Y4EmaS9rX6DeLFGE1Tli8bmFAH+Lxp8TiHddbxrx6JHtGroIw9OxsSKp+7nMUluIGxLJAZPjvJjiP1rNVigRNRK8JguMVJ6HPjWazPzP1ccIhhcT2b5USryVcgq160jaJeTonK1+yafpOkb8DvBM8tYmm3r/rdX3dpuzEMb+/E+heRNdwNfqt6+DNDBSNDLBTCvXyD5J2O6KBz9W+zpBjuEVmB6eQxvn9n6STxmoOtnr79wya6eIuuM2BScqGXWQMOJwYblxxEHhbXpSTTVdDkKNDA70A3jzN15a4/clVyeijLm
 kgpO9/Qe
 JZ561Q1dPjeG9d80Tkhcy2S4fiHwlUeQISOq3ewRr/SYRXeB8baGjQhsSYhj6OJeNu14JjzCTAm++u2sIpRJ+eNDRoe189FVKCreuM99JfrxokT1Sha6WclN6ujvw3pZsUTHW+SM6SS5SF7+Qx/Zs+YiVQ6KW654AHzjRpaidDGcMMfdjqwfFZI+dei+2WkDCimi3nxTGX4fK1oSpUbmwIibL2DLS6/M3gCdR5TAsCMHg6jmT5gL0PVQ+DRul5gGrD70OfjYLP5prm4Xrc7CBHQAHJ1STjTiCBDEiRvBjSGwsQ0zLTRoiUg4xTiloZbG0gJGOaCF7J1bca3IJ/dGPyqvlIAXknMIKOaqe5pw2jxvMTG8XLpVyKT+2QbFzupsb3pBQMVcqayGpSWGrQ2shFUGdC14tRxNlUcIF72Fh8I6cBqYixWKcW2GOIB+bMt1KIv2oWqZ+QZZEyW/S6s/oUxVPYQih7UZ5oKDO3/S5PwlDZZI9X4dg1rof/lOsOV0igfc8OlV6lIg5gBneUltJAnzC5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, most housekeeping types (timer, rcu, misc, etc.) share the
same mask (HK_TYPE_KERNEL_NOISE), preventing fine-grained control over
CPU isolation. Additionally, there is no way to update these masks at
runtime.

Separate the housekeeping types into individual enum entries and expand
the cpumasks array to accommodate them. Introduce a sysfs interface at
/sys/kernel/housekeeping/ that allows users to view and update the
housekeeping masks for each type at runtime. When a mask is updated via
sysfs, a notifier is triggered to re-affine the relevant kernel
subsystems and services.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 include/linux/sched/isolation.h |  20 +++---
 kernel/sched/isolation.c        | 134 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 140 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index 5c07e3e9b8d1..e8fe1cfa5022 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -10,21 +10,17 @@
 enum hk_type {
 	HK_TYPE_DOMAIN,
 	HK_TYPE_MANAGED_IRQ,
-	HK_TYPE_KERNEL_NOISE,
+	HK_TYPE_TICK,
+	HK_TYPE_TIMER,
+	HK_TYPE_RCU,
+	HK_TYPE_MISC,
+	HK_TYPE_WQ,
+	HK_TYPE_KTHREAD,
 	HK_TYPE_MAX,
-
-	/*
-	 * The following housekeeping types are only set by the nohz_full
-	 * boot commandline option. So they can share the same value.
-	 */
-	HK_TYPE_TICK    = HK_TYPE_KERNEL_NOISE,
-	HK_TYPE_TIMER   = HK_TYPE_KERNEL_NOISE,
-	HK_TYPE_RCU     = HK_TYPE_KERNEL_NOISE,
-	HK_TYPE_MISC    = HK_TYPE_KERNEL_NOISE,
-	HK_TYPE_WQ      = HK_TYPE_KERNEL_NOISE,
-	HK_TYPE_KTHREAD = HK_TYPE_KERNEL_NOISE
 };
 
+#define HK_TYPE_KERNEL_NOISE HK_TYPE_TICK
+
 struct housekeeping_update {
 	enum hk_type type;
 	const struct cpumask *new_mask;
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 97cc41626a33..d9ce26cf31fe 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -9,14 +9,26 @@
  */
 #include <linux/sched/isolation.h>
 #include <linux/mutex.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/slab.h>
+#include <linux/ctype.h>
 #include "sched.h"
 
 enum hk_flags {
 	HK_FLAG_DOMAIN		= BIT(HK_TYPE_DOMAIN),
 	HK_FLAG_MANAGED_IRQ	= BIT(HK_TYPE_MANAGED_IRQ),
-	HK_FLAG_KERNEL_NOISE	= BIT(HK_TYPE_KERNEL_NOISE),
+	HK_FLAG_TICK		= BIT(HK_TYPE_TICK),
+	HK_FLAG_TIMER		= BIT(HK_TYPE_TIMER),
+	HK_FLAG_RCU		= BIT(HK_TYPE_RCU),
+	HK_FLAG_MISC		= BIT(HK_TYPE_MISC),
+	HK_FLAG_WQ		= BIT(HK_TYPE_WQ),
+	HK_FLAG_KTHREAD		= BIT(HK_TYPE_KTHREAD),
 };
 
+#define HK_FLAG_KERNEL_NOISE (HK_FLAG_TICK | HK_FLAG_TIMER | HK_FLAG_RCU | \
+			      HK_FLAG_MISC | HK_FLAG_WQ | HK_FLAG_KTHREAD)
+
 static DEFINE_MUTEX(housekeeping_mutex);
 static BLOCKING_NOTIFIER_HEAD(housekeeping_notifier_list);
 DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
@@ -99,7 +111,7 @@ int housekeeping_unregister_notifier(struct notifier_block *nb)
 }
 EXPORT_SYMBOL_GPL(housekeeping_unregister_notifier);
 
-static int __maybe_unused housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask)
+static int housekeeping_update_notify(enum hk_type type, const struct cpumask *new_mask)
 {
 	struct housekeeping_update update = {
 		.type = type,
@@ -109,6 +121,124 @@ static int __maybe_unused housekeeping_update_notify(enum hk_type type, const st
 	return blocking_notifier_call_chain(&housekeeping_notifier_list, HK_UPDATE_MASK, &update);
 }
 
+static const char * const hk_type_names[] = {
+	[HK_TYPE_TIMER]		= "timer",
+	[HK_TYPE_RCU]		= "rcu",
+	[HK_TYPE_MISC]		= "misc",
+	[HK_TYPE_TICK]		= "tick",
+	[HK_TYPE_DOMAIN]	= "domain",
+	[HK_TYPE_WQ]		= "workqueue",
+	[HK_TYPE_MANAGED_IRQ]	= "managed_irq",
+	[HK_TYPE_KTHREAD]	= "kthread",
+};
+
+struct hk_attribute {
+	struct kobj_attribute kattr;
+	enum hk_type type;
+};
+
+#define to_hk_attr(_kattr) container_of(_kattr, struct hk_attribute, kattr)
+
+static ssize_t housekeeping_show(struct kobject *kobj,
+				struct kobj_attribute *attr, char *buf)
+{
+	struct hk_attribute *hk_attr = to_hk_attr(attr);
+	const struct cpumask *mask = housekeeping_cpumask(hk_attr->type);
+
+	return cpumap_print_to_pagebuf(false, buf, mask);
+}
+
+static ssize_t housekeeping_store(struct kobject *kobject,
+				 struct kobj_attribute *attr,
+				 const char *buf, size_t count)
+{
+	struct hk_attribute *hk_attr = to_hk_attr(attr);
+	enum hk_type type = hk_attr->type;
+	cpumask_var_t new_mask;
+	int err;
+
+	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
+		return -ENOMEM;
+
+	err = cpulist_parse(buf, new_mask);
+	if (err)
+		goto out_free;
+
+	if (cpumask_empty(new_mask)) {
+		err = -EINVAL;
+		goto out_free;
+	}
+
+	mutex_lock(&housekeeping_mutex);
+	
+	if (!housekeeping.cpumasks[type]) {
+		if (!alloc_cpumask_var(&housekeeping.cpumasks[type], GFP_KERNEL)) {
+			err = -ENOMEM;
+			goto out_unlock;
+		}
+	}
+
+	if (cpumask_equal(housekeeping.cpumasks[type], new_mask)) {
+		err = 0;
+		goto out_unlock;
+	}
+
+	cpumask_copy(housekeeping.cpumasks[type], new_mask);
+	housekeeping.flags |= BIT(type);
+	static_branch_enable(&housekeeping_overridden);
+	
+	housekeeping_update_notify(type, new_mask);
+	
+	err = count;
+
+out_unlock:
+	mutex_unlock(&housekeeping_mutex);
+out_free:
+	free_cpumask_var(new_mask);
+	return err < 0 ? err : count;
+}
+
+static struct hk_attribute housekeeping_attrs[HK_TYPE_MAX];
+static struct attribute *housekeeping_attr_ptr[HK_TYPE_MAX + 1];
+
+static const struct attribute_group housekeeping_attr_group = {
+	.attrs = housekeeping_attr_ptr,
+};
+
+static int __init housekeeping_sysfs_init(void)
+{
+	struct kobject *housekeeping_kobj;
+	int i, j = 0;
+	int ret;
+
+	housekeeping_kobj = kobject_create_and_add("housekeeping", kernel_kobj);
+	if (!housekeeping_kobj)
+		return -ENOMEM;
+
+	for (i = 0; i < HK_TYPE_MAX; i++) {
+		if (!hk_type_names[i])
+			continue;
+
+		housekeeping_attrs[i].type = i;
+		sysfs_attr_init(&housekeeping_attrs[i].kattr.attr);
+		housekeeping_attrs[i].kattr.attr.name = hk_type_names[i];
+		housekeeping_attrs[i].kattr.attr.mode = 0644;
+		housekeeping_attrs[i].kattr.show = housekeeping_show;
+		housekeeping_attrs[i].kattr.store = housekeeping_store;
+		housekeeping_attr_ptr[j++] = &housekeeping_attrs[i].kattr.attr;
+	}
+	housekeeping_attr_ptr[j] = NULL;
+
+	ret = sysfs_create_group(housekeeping_kobj, &housekeeping_attr_group);
+	if (ret) {
+		kobject_put(housekeeping_kobj);
+		return ret;
+	}
+
+	return 0;
+}
+late_initcall(housekeeping_sysfs_init);
+
 void housekeeping_init(void)
 {
 	enum hk_type type;

-- 
2.51.0


