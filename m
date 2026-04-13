Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B897BEBFD10
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B2FB6B00A0; Mon, 13 Apr 2026 03:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AA26B00A1; Mon, 13 Apr 2026 03:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A0EB6B00A2; Mon, 13 Apr 2026 03:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 084B66B00A0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:44:50 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C497D5CE75
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:44:49 +0000 (UTC)
X-FDA: 84652745898.04.CD61E38
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf14.hostedemail.com (Postfix) with ESMTP id D0BF9100006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:44:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n9+UHMgp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066287; a=rsa-sha256;
	cv=none;
	b=vkcviFteH/7ICJ5lH9LLArSdUvnXs3XUigkzGtpUMx/pF0dJVP2P7fs+q3O6HUgor5aped
	gJ85k21W+S39hnrgf6BW/qjsgbnOOelNfrWrisiFLmncRMfNMpoSRPEJW6g83+Y7d0N/Lx
	FV3J4Ujh1y5dflqUs8ZVvpmHu14odrs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=n9+UHMgp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CyDvJikQxepnDoa9At7D55yqji9L3lHPWXvHJrxbFWg=;
	b=KuQpTP30sfgY+F6bwg9LqdtUWLD6aw21Fk4CE6wulOVI/eqVdoHuE4v/G6eyvMplmknn91
	V2812MPVYaXXqrQxwc2Tj3yZng6hYqzVuebwYG5RM+gP/hILm5kQbK+Y+kMgthQIJEDFAr
	kuRcQOeRmorUK5xzPCB+G1vVQMnw9XQ=
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-12c42a23c8eso1497807c88.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:44:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066286; x=1776671086; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CyDvJikQxepnDoa9At7D55yqji9L3lHPWXvHJrxbFWg=;
        b=n9+UHMgptjxM/wq8/TwUbJo+zWjbTMXaIbG4I/gWVdrxlMFTxeuURHsBVFPb0nCV7K
         XGfofFQGXERTsDYDVebyOPcaPXUBSEl6FTvztDRYlny0Nnn5M5ysAmVdsKjhQSje1ote
         8Mw+kJsvGtN315waWPIpGysZGdf8NscDb8j0SvNE82JwMYMhHxPHtb6Tlo54a4l+J8WW
         7gSbsbnGrnwYikgwzUR9AOIpSaO03kyHEV7eVc71uUE/pR/w0Z2fLbT4X8xqPKi634/d
         SwC/T8jcRtU5GkalDDGirZSGY2vYnVkiV96gCdkgKk9oGD73q2lqEukeLqnt49AKwWdF
         51NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066286; x=1776671086;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CyDvJikQxepnDoa9At7D55yqji9L3lHPWXvHJrxbFWg=;
        b=Tk66zU0PxJSImGez42BsicuAZ1OiS5w7dIZWZv1HvwgtOMKLSaheofdqyvEqzUMxMO
         YCH+sUYuBh/TpY1hcOL8nbFGWRXSUHbrUM/5BvZqcmtlqcZjz9zN1FQcZXM3z+ebRgPD
         0Xa+QXIuE7aF7RqhrDm2i10gW5hAw8JJ8YV2uFT6lgiQApGOedptWesgz3FNZlKKHlCI
         K+m44pD6nwfkfDS7RdY0UWz0X4XAi6zipkSyJy+N7sBRadUE/Ukg6K5tLysW9SbbBxFF
         ez2gFUnwonyDH0bXF3iYIRUJ0iQvdLAEbCKxg95ETBHFlI4zTPK6nZOc6KUGxQjqL+L/
         VVhA==
X-Forwarded-Encrypted: i=1; AFNElJ+D1JbuGD/t3BQt2+67yLp9Z2MzFCvXcPI/RsNRAjgW2T3RPfNcU2GurjVqVOA+2rdHKqY0RcFLaA==@kvack.org
X-Gm-Message-State: AOJu0YyCJ43g/jtD2/dlbN1iOw92Wdqr0s485T+6C/nICksnTt8nf7Xp
	UMaqacmkhA90QdtGXkvl28wwtB8Js0rsDoHl8DbKOA0n7cf9od4WZlC59BgUx7l6
X-Gm-Gg: AeBDieuxF/FeJ0iFnKh0zDb32kPDqGB/ECCrNWhlExPvpw/v/7lWGuQIRUJcx3Oo535
	8AEsaEnRnnjcIaydOojZrchuk99bMwdNgtYk+bkICd0MNTGkHOaLkznGRLKt9axfbAVHfBBKFqp
	jgNdw6UZGy1wr+ogOdp1FAZjA7spqSD5ThgM/kS5iwZORsh21lowOfsqeAD7AuPq9PKhcJyXKHK
	h9/Kcz7lCP7js1msw7dSHzT15ofBKnVwBqhYP0w4ht8dW3SJw4XUI4dGWC4whva4Sa6kJ5T9wB2
	0mWnXpCZGvzigOTLRHq8vYjtePD1lKVVRmJ5fj4LTpGg9uubcbtWGzG8yREuzItxkKCAikj4A9Y
	XMllysc+qCbeIqioqMqYDXVwRFZJSw2+AE7m7iHtRPhib2Wy0sp5iqnXN1Bqv+Briy5Lpy/+0mo
	FakY5OICFtQRNgjkZ7
X-Received: by 2002:a05:7022:61a2:b0:128:d51a:5157 with SMTP id a92af1059eb24-12c34f1449emr6389794c88.33.1776066286323;
        Mon, 13 Apr 2026 00:44:46 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.44.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:44:46 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:14 +0800
Subject: [PATCH v2 08/12] workqueue, mm: Support dynamic housekeeping mask
 updates
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-8-06df21caba5d@gmail.com>
References: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
In-Reply-To: <20260413-wujing-dhm-v2-0-06df21caba5d@gmail.com>
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Anna-Maria Behnsen <anna-maria@linutronix.de>, 
 Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Waiman Long <longman@redhat.com>, Chen Ridong <chenridong@huaweicloud.com>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, rcu@vger.kernel.org, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Qiliang Yuan <realwujing@gmail.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: sbbchg9bce4jci635o5d4knt954majwq
X-Rspamd-Queue-Id: D0BF9100006
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776066287-925376
X-HE-Meta: U2FsdGVkX19y++qtp939t/rpWxUQ1ZppeALsJD35iYxlxbLkcZECqTb33HaFXeW/eSYshBZaUe8ludO6wycx5nuvnEZI2e9bs/GB9hLyV8uzLQ4qOWuSQ/LKhaAWjbGURnniWn0z1Z0zvf5VWh+HdUDaHK1uIN6XneyXFdLoq+9Vrf3QpHdqT80jThxLS/7b3GgEq0cQWI0qcYs0p3AtOcQ+nZc2Z0Wk2+BlsjAtdHDs4HNDXQJ8DkD3RAjKdT0NY9vZdcIAV0x4c6OFb2tjw2xdO9e22Aw8O9Uj5DGRxg8graqmLE7AsDkCWglsi3Dpo5DTltjVTbEUTOYJHrmahERrdjGFceJBZ4anxOqFvFQjW5KZR2Pgt39r/0aOb5Puq/RlDTJj24j3JDdU7lnd8J5r7JSQIdb8h6+SMaHvD/32I0OIM31LleLcFrizD7ftcxZi0KtaY06U/zJt+E20mcgIXBSB1tfDg/hWOifbQBcHJZK5Q2UEz5+PQd5UyEX+XY9wLweZOGs+lkjr3c8TDjGu2YfTWPdR155N+gSsBwqhSvw+QFI1/Do0g8QAlOAtxcdPu8LHFkE1W1PbCa6Ruj3+k6AAdDk5uNKcm/B5N1+El5qmfuJ789rElQ44m9Vgy7UodZAoLs6t2CyWRZSVn0RCIkFTLPG65qOPVYuACwIicYFkfb5MMoQ8Nm5sAkJFbpxKUg1adyDrLTvZq0XHtySaq6H8xvgB1chFvsbz3PNTPVS/NCMUgFJVoQ4vYYTSEwLiOfkxltmBqzzf8j6PvYeJyDl4Nv2hEVpLuMnHrcIeKtpdtc6IcygyI0dc5tqQDoWPxSrCoLI4p7ZI2afHpJ5wwC1XlkSbrpHIWYbZhW9TLJtQmCv7mizVOcul6ggsC3N7NFGuYaCi+ZxGVOe615VX+/EUBIMYPVxqdRuNcOofDdwkrJ/20TsaKNUUr49yOZWjcpgUJa2Ftwv4W10
 Ynveqbof
 EDdTu6MJfzFYvNFKhOl5gWh2mHphHQdGcmEwses9s6MvgAY2aGowu8BmYuW7GV1VsZ5xfNPz6Ay9hWycmQmEYPbD0f8fILBpaR6ybmntJhhCV1Z2zULKZ6HIGzxUTeAwSpdtAjsiIuL7YpnTZHbzK1mhPISl5OIkK+tveKpSezWH6/l6DuOAqUl5YgZwPKwQ18GB18dJ1x02JgHA2TzFfxmVfb6vYdJfXLKzZVJKq+4UDLKYhAtfH2QbiELOCv+3qYGMaoYAShOH60c4avCCM3w1EV8/kGSJ0PbqAP1uI0H/MsLgza3gbPweElrbyILhNF2vA39zD+GNXd3Rv49ZtsYtEVOaT2HjXYDSH87xOnqHUQh+O3dYzVmP1kOzNTEk5qnJ6AAy9Rh8dmhvDBwY2K37JL0Y3V8att9NaXylxK2NbWjH1PrFFubqx7B8LSjw71XsUkwMWuOPhxpi3h7hg8UIG4YxwaoYFZKP74i8yBt1J5yb5TQ4glQHM5esXw2Zwh/1ToeavZcv5Clk+70agiIA9wJWg6KccZRGh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unbound workqueues and kcompactd threads determine their default CPU
affinity from housekeeping masks (HK_TYPE_WQ, HK_TYPE_DOMAIN, and
HK_TYPE_KTHREAD) at boot. Currently, these boundaries are static and
are not updated if housekeeping is reconfigured at runtime.

Implement housekeeping notifiers for both workqueue and mm compaction.

This ensures that unbound workqueue tasks and background compaction
threads honor dynamic isolation boundaries configured via sysfs or
cpuset at runtime.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/workqueue.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 mm/compaction.c    | 27 +++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index eda756556341a..354e788004b48 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -8008,6 +8008,47 @@ static void __init wq_cpu_intensive_thresh_init(void)
 	wq_cpu_intensive_thresh_us = thresh;
 }
 
+static int wq_housekeeping_reconfigure(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	if (action == HK_UPDATE_MASK) {
+		struct housekeeping_update *upd = data;
+		unsigned int type = upd->type;
+
+		if (type == HK_TYPE_WQ || type == HK_TYPE_DOMAIN) {
+			cpumask_var_t cpumask;
+
+			if (!alloc_cpumask_var(&cpumask, GFP_KERNEL)) {
+				pr_warn("workqueue: failed to allocate cpumask for housekeeping update\n");
+				return NOTIFY_BAD;
+			}
+
+			cpumask_copy(cpumask, cpu_possible_mask);
+			if (!cpumask_empty(housekeeping_cpumask(HK_TYPE_WQ)))
+				cpumask_and(cpumask, cpumask, housekeeping_cpumask(HK_TYPE_WQ));
+			if (!cpumask_empty(housekeeping_cpumask(HK_TYPE_DOMAIN)))
+				cpumask_and(cpumask, cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
+
+			workqueue_set_unbound_cpumask(cpumask);
+
+			if (type == HK_TYPE_DOMAIN) {
+				apply_wqattrs_lock();
+				cpumask_andnot(wq_isolated_cpumask, cpu_possible_mask,
+						housekeeping_cpumask(HK_TYPE_DOMAIN));
+				apply_wqattrs_unlock();
+			}
+
+			free_cpumask_var(cpumask);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block wq_housekeeping_nb = {
+	.notifier_call = wq_housekeeping_reconfigure,
+};
+
 /**
  * workqueue_init - bring workqueue subsystem fully online
  *
@@ -8068,6 +8109,7 @@ void __init workqueue_init(void)
 
 	wq_online = true;
 	wq_watchdog_init();
+	housekeeping_register_notifier(&wq_housekeeping_nb);
 }
 
 /*
diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c6..574ee3c6dc942 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -24,6 +24,7 @@
 #include <linux/page_owner.h>
 #include <linux/psi.h>
 #include <linux/cpuset.h>
+#include <linux/sched/isolation.h>
 #include "internal.h"
 
 #ifdef CONFIG_COMPACTION
@@ -3246,6 +3247,7 @@ void __meminit kcompactd_run(int nid)
 		pr_err("Failed to start kcompactd on node %d\n", nid);
 		pgdat->kcompactd = NULL;
 	} else {
+		housekeeping_affine(pgdat->kcompactd, HK_TYPE_KTHREAD);
 		wake_up_process(pgdat->kcompactd);
 	}
 }
@@ -3320,6 +3322,30 @@ static const struct ctl_table vm_compaction[] = {
 	},
 };
 
+static int kcompactd_housekeeping_reconfigure(struct notifier_block *nb,
+					      unsigned long action, void *data)
+{
+	struct housekeeping_update *upd = data;
+	unsigned int type = upd->type;
+
+	if (action == HK_UPDATE_MASK && type == HK_TYPE_KTHREAD) {
+		int nid;
+
+		for_each_node_state(nid, N_MEMORY) {
+			pg_data_t *pgdat = NODE_DATA(nid);
+
+			if (pgdat->kcompactd)
+				housekeeping_affine(pgdat->kcompactd, HK_TYPE_KTHREAD);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block kcompactd_housekeeping_nb = {
+	.notifier_call = kcompactd_housekeeping_reconfigure,
+};
+
 static int __init kcompactd_init(void)
 {
 	int nid;
@@ -3327,6 +3353,7 @@ static int __init kcompactd_init(void)
 	for_each_node_state(nid, N_MEMORY)
 		kcompactd_run(nid);
 	register_sysctl_init("vm", vm_compaction);
+	housekeeping_register_notifier(&kcompactd_housekeeping_nb);
 	return 0;
 }
 subsys_initcall(kcompactd_init)

-- 
2.43.0


