Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6472FEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51C3D6B00AF; Wed, 25 Mar 2026 05:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F3CD6B00B1; Wed, 25 Mar 2026 05:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E2886B00B2; Wed, 25 Mar 2026 05:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BE346B00AF
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:11:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CED7D13BAE8
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:26 +0000 (UTC)
X-FDA: 84584016972.26.5CFB7F2
Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	by imf26.hostedemail.com (Postfix) with ESMTP id D4BF814000B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HO+fB1Kx;
	spf=pass (imf26.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=scmgWcS5GsqDyCs8R5zf+G8RGx6zlEEWGauepG1UF1o=;
	b=bCYZrwL+EgtOF7TSr/HiQkX/L911Ur9xRH9XOqTzvUK9wTw8kWthTazpvNpb62riXEy1Ps
	tEFgXJ0wei6eHHTK+ekKgzmyGI0STgg6pRHMQtJJtFLZY0us6ZYR1Ra21ZGb3OcbiP1brM
	CJTd433hqq+QCRi975/EVAVyYGqm8m8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429884; a=rsa-sha256;
	cv=none;
	b=osQzzTl5TEpIrVjsyJwOlhXnlCG209JjR4OI5R2ZDqDNiFfbC8bNcMgvRgZuD2oJnJgJ1A
	JjyCDAc0DRJzS5qit8L+H5ffL30tEPN8VxUEY5n+XjxNuq9rgbQmus0Q/iQoOhGmfib0J6
	W+a7PxzZ5Q4Nop7Un0MiYvIVsbox/Lc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HO+fB1Kx;
	spf=pass (imf26.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.169 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2c1092cc08cso2897792eec.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429884; x=1775034684; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=scmgWcS5GsqDyCs8R5zf+G8RGx6zlEEWGauepG1UF1o=;
        b=HO+fB1KxbSLCEQ4UCD4FfCQ/CPoV60SVRITke9hSWsXJYqtAMuPbLuLge5G7lQYUuV
         wD9yheFw8f8qElljhxK+Hm0V7I2HQL7VcAFcsXy+dXOGRYSatCbarnoKuGwkcnsEXYXS
         uEQ8Wi8uwfpxvi1ATptKtLjDsPaAjEhWlUfzEeoF1B3y0Pu80rgmVP+PacPMb6a+GR7H
         +qzqEHus/N0IT4smJMAdgsEgzrzGeRaAKmSQ1YFe7S/Pul6ZpTh5NlQ+AxOsOqchlKQP
         z4ZYLFLzlQOYbrs4c8mg0wi6AXQX6mFtREs0nunw3S5YQjYySunsoUcaVAK0gt8i6dMf
         j36A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429884; x=1775034684;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=scmgWcS5GsqDyCs8R5zf+G8RGx6zlEEWGauepG1UF1o=;
        b=RFwCJOO32JZUbMiaQ37qa4NfcVTfSrzoebJCafUeH7u3p3AIHBI1LBk0V/Of58V+iE
         oyg77PpwXwNqdyPXZ3aw92x95Z9VgOO110B3jJlWuUrvKaBFGCYmD9x/XqZb75TagHAF
         N26uVu64hI30l2NwR9n4D9N5FeUu3uYUhBBL4x6pGmC8XhruzrfbfxJ0Vv2K5jp3f+22
         kKd1BkMyoR4bFqFvcbdMdcNImyQsBuKhvmED+1UxEE2OCETLgeq+v8hRdYr0ghq2VB3d
         T6WsVKF412b/A4Z6cnqFUZuVaMofjXACaVP08ckLc1wKosNw2TG//qjRstw7ruj7/kP0
         D0aA==
X-Forwarded-Encrypted: i=1; AJvYcCX93DwJoZaPAOC8nbNdVS989xj7lIewGUYUDITHlAMV6HvN5SeijU2rgSlpQbmzUGAEGErvzFnT5w==@kvack.org
X-Gm-Message-State: AOJu0Yxmvjm39FVSgtN6EiuxsKbQHfXDo9Qsd8CxzOK+0MB/Fioq7xhk
	VTpke5YPMR9+uudWJlb/u1XHdHd3XFLY/v1U7md4Gd3M5WsOGWKgV+Yo
X-Gm-Gg: ATEYQzyGqqt43hKneD4+T0yG/AMUpDZ37fQu6DG5eiDI0K1v79PW8F4Nn3rf+VU2sjx
	k/wneBIRVduoZlPYCUcgelk2Ol19CeU9JvMaPTcC5bRTeNjQbHLeuboH9yLu3IcS0TT3hlgO6jF
	yPo3GspLLp3/1pElA682ZIqGh8b2vRNi0Hatd6dDpF+vO8c8mxbuZ30eHVtvE9Th4MXfrt4K36O
	41tJJBEbRpUjzsuBvqAZbEP+EcQwI3j8fwGThFyrTC0jUz1AvSZL8apZ409s0WApB8shn14GdS8
	YrUxKGzkZcyswM0wDroOMHGxdAuJCIyGtLAo78ND7LZgudf5G63x3zIhyduwDz7DlhUTo9Fx70e
	L6eqWomt2/OSnrVA7w2eFytVrpykogYQ9LzzCJi0nmNczRpYfSyiLXX9HTAGlo331OWeWg+SQBl
	boHLzSPx/gZWH4486k
X-Received: by 2002:a05:7301:19a8:b0:2b8:64ad:ad4d with SMTP id 5a478bee46e88-2c15d479457mr1165933eec.26.1774429883454;
        Wed, 25 Mar 2026 02:11:23 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.11.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:11:23 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:44 +0800
Subject: [PATCH 13/15] sched/isolation: Implement sysfs interface for
 dynamic housekeeping
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-13-919cca23cadf@gmail.com>
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
X-Rspamd-Server: rspam12
X-Stat-Signature: n9ki57tswnpx3e4764s6ww6taqij61n6
X-Rspamd-Queue-Id: D4BF814000B
X-Rspam-User: 
X-HE-Tag: 1774429884-99576
X-HE-Meta: U2FsdGVkX1+ZTmswSNy8QcXMNGVY7X1TdK5TiD3uJr+Atas30PSUVO0gMRpuxX/RrgVjlrjjDyf+/vXIfSyTodvkNz4eXx5bQIxVlx4XMGnignscBw4zQnptjTatkoIU73klV4aBAoBhxmu++75vOK9dkLgd+BvMHM6pHD8N84siHFxpF6ngYBHIOasyErdLiH2f6fgvrC4BX8O52cLDVoy396JM2Yx11aQZIsQ6xxMBkjw6VacCd7DoxlYTdnePKJ28iKzQDIFXBmDYXIs+spWLoAjOOJKlpWmrQFNV2HnN1Fzw4uphZXHebGqW+NbkGKnq2PwD7qq2R8NVJEHEjC9C8es6KFL92xl+s+c1fFEZHo4hwr+UfzDCS3wzPfSDWF9BmVq56rX2PaTbdi4WBtdI8RxjR9+AGoGGWYWxofyHZX8VpytPpq8JVUCNWz2iMn2wfxP9nO/3kHODLj8wVU2D/by/AKjX3UVjIAJPah1bVwWpyDG7m9TNHSDH3yavL9G/wanv5ySZZulygLt1EhnQWSAHgYyMwi6/0STy6mzXrQjvzDnPaP7KnP2i18dJDQJW/u+HIuH0xr+oFg+yGk25FxhftAnu7+A9lZD/KKW7aahHDU57Gk9NRqKzKO1acibmT3os/s3+RFt7trOR37urEyJg3ro/1kBsdD9CGq9CGlS9GWbYunVGF3nyR9IGtPAkgXbnE0PdJyUyo9ssMOSulkSAcasAyaWv/TnYoOTi0RP76js/JNDQy01le04AHSkZh34GdcOp9IpXbTTmiEG+o0pCzoasDpCvsNTZGWx2oh2hu0zvHekhPGXGaeuXWkdK6EgdygnVDVvAUvqxgFLwqZoCU+rkz1rELkvfY4h35/g/gymKt2HxRwdrvWbSajCJRvSTsl4N9NJJ2aQTliDfmeYfCAVzERQjLhvZ64/G56nY5seVhncJj5lYJVAHFFOdMUBMlh9fefois9t
 rBSJT3dj
 rgUeRSq+985epCVWtOGHWRkmi8E0zOSTF4P++eb3prgjguD2TRPM5f7eFy1fvaF8/eK42c1nfKAfPSsINCeBu2Fu640CKQQdc2klTgGiDPBKbgCn+MZ4C6bcjp1nRzQdnnhTM1JAPf0LlbT1JGlZhoJy/u1SLZj9jL9MKzTj94hAlBPaxhRY5Z8GgHhBt8K6N8pEAIkPdwjCt4UnVTeA5rNAVHxS+Ede3v/Cq0xs1RUrNtE7+1/5rzrIbtvrrleJJDXfkkjLweJWCsxWbT6v9u4zrDswzwXsT2b0n5+ssJPjtjVG/4gTPfK9HOTbAL0AkHONsy8Uc7d3qWvJwwAZcIWvYxGBu4M7GT9bv6Qogj9T59qI4ShV/Rn8CKBgqFCS0S5Efqln+K67WG3/Z2HTQwjGmBbO/SsH+6RWWbi+45gj051nk9JkPPoyx01OoOHxEuV/Fzg1ZF3SZnSq6Kum9bHvNiKtfbJWe4eLE+0wwqyuRERYJ59g3du/URglYchAggZuq+6LwySenMM4YQPBudTXdRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Subsystem housekeeping masks are currently static and can only be set
via boot-time parameters (isolcpus, nohz_full, etc.). There is no
userspace interface to reconfigure these boundaries at runtime.

Implement the DHEI sysfs interface under /sys/kernel/housekeeping.

This enables userspace to independently reconfigure different kernel
services' affinities without a reboot.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/sched/isolation.c | 89 ++++++++++++++++++++++++------------------------
 1 file changed, 45 insertions(+), 44 deletions(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 685cc0df1bd9f..1c867784d155b 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -8,7 +8,12 @@
  *
  */
 #include <linux/sched/isolation.h>
+#include <linux/capability.h>
 #include <linux/mutex.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/slab.h>
+#include <linux/ctype.h>
 #include <linux/notifier.h>
 #include <linux/topology.h>
 #include "sched.h"
@@ -16,9 +21,17 @@
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
@@ -44,6 +57,9 @@ static ssize_t smt_aware_store(struct kobject *kobj,
 {
 	bool val;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (kstrtobool(buf, &val))
 		return -EINVAL;
 
@@ -53,7 +69,7 @@ static ssize_t smt_aware_store(struct kobject *kobj,
 }
 
 static struct kobj_attribute smt_aware_attr =
-	__ATTR(smt_aware_mode, 0644, smt_aware_show, smt_aware_store);
+	__ATTR(smt_aware_mode, 0600, smt_aware_show, smt_aware_store);
 
 bool housekeeping_enabled(enum hk_type type)
 {
@@ -171,6 +187,9 @@ static ssize_t housekeeping_store(struct kobject *kobject,
 	cpumask_var_t new_mask;
 	int err;
 
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
 	if (!alloc_cpumask_var(&new_mask, GFP_KERNEL))
 		return -ENOMEM;
 
@@ -178,42 +197,26 @@ static ssize_t housekeeping_store(struct kobject *kobject,
 	if (err)
 		goto out_free;
 
-	/* Safety check: must have at least one online CPU for housekeeping */
-	if (!cpumask_intersects(new_mask, cpu_online_mask)) {
+	if (cpumask_empty(new_mask) ||
+	    !cpumask_intersects(new_mask, cpu_online_mask)) {
 		err = -EINVAL;
 		goto out_free;
 	}
 
-	if (housekeeping_smt_aware) {
-		int cpu, sibling;
-		cpumask_var_t tmp_mask;
+	mutex_lock(&housekeeping_mutex);
 
-		if (!alloc_cpumask_var(&tmp_mask, GFP_KERNEL)) {
-			err = -ENOMEM;
-			goto out_free;
-		}
+	if (housekeeping_smt_aware) {
+		int cpu;
 
-		cpumask_copy(tmp_mask, new_mask);
-		for_each_cpu(cpu, tmp_mask) {
-			for_each_cpu(sibling, topology_sibling_cpumask(cpu)) {
-				if (!cpumask_test_cpu(sibling, tmp_mask)) {
-					/* SMT sibling should stay grouped */
-					cpumask_clear_cpu(cpu, new_mask);
-					break;
-				}
+		for_each_cpu(cpu, new_mask) {
+			if (!cpumask_subset(topology_sibling_cpumask(cpu),
+					    new_mask)) {
+				err = -EINVAL;
+				goto out_unlock;
 			}
 		}
-		free_cpumask_var(tmp_mask);
-
-		/* Re-check after SMT sync */
-		if (!cpumask_intersects(new_mask, cpu_online_mask)) {
-			err = -EINVAL;
-			goto out_free;
-		}
 	}
 
-	mutex_lock(&housekeeping_mutex);
-
 	if (!housekeeping.cpumasks[type]) {
 		if (!alloc_cpumask_var(&housekeeping.cpumasks[type], GFP_KERNEL)) {
 			err = -ENOMEM;
@@ -242,7 +245,7 @@ static ssize_t housekeeping_store(struct kobject *kobject,
 }
 
 static struct hk_attribute housekeeping_attrs[HK_TYPE_MAX];
-static struct attribute *housekeeping_attr_ptr[HK_TYPE_MAX + 1];
+static struct attribute *housekeeping_attr_ptr[HK_TYPE_MAX + 2];
 
 static const struct attribute_group housekeeping_attr_group = {
 	.attrs = housekeeping_attr_ptr,
@@ -265,28 +268,22 @@ static int __init housekeeping_sysfs_init(void)
 		housekeeping_attrs[i].type = i;
 		sysfs_attr_init(&housekeeping_attrs[i].kattr.attr);
 		housekeeping_attrs[i].kattr.attr.name = hk_type_names[i];
-		housekeeping_attrs[i].kattr.attr.mode = 0644;
+		housekeeping_attrs[i].kattr.attr.mode = 0600;
 		housekeeping_attrs[i].kattr.show = housekeeping_show;
 		housekeeping_attrs[i].kattr.store = housekeeping_store;
 		housekeeping_attr_ptr[j++] = &housekeeping_attrs[i].kattr.attr;
 	}
+
+	housekeeping_attr_ptr[j++] = &smt_aware_attr.attr;
 	housekeeping_attr_ptr[j] = NULL;
 
 	ret = sysfs_create_group(housekeeping_kobj, &housekeeping_attr_group);
-	if (ret)
-		goto err_group;
-
-	ret = sysfs_create_file(housekeeping_kobj, &smt_aware_attr.attr);
-	if (ret)
-		goto err_file;
+	if (ret) {
+		kobject_put(housekeeping_kobj);
+		return ret;
+	}
 
 	return 0;
-
-err_file:
-	sysfs_remove_group(housekeeping_kobj, &housekeeping_attr_group);
-err_group:
-	kobject_put(housekeeping_kobj);
-	return ret;
 }
 late_initcall(housekeeping_sysfs_init);
 
@@ -313,8 +310,12 @@ static void __init housekeeping_setup_type(enum hk_type type,
 	if (!slab_is_available())
 		gfp = GFP_NOWAIT;
 
-	if (!housekeeping.cpumasks[type])
-		alloc_cpumask_var(&housekeeping.cpumasks[type], gfp);
+	if (!housekeeping.cpumasks[type]) {
+		if (!alloc_cpumask_var(&housekeeping.cpumasks[type], gfp)) {
+			pr_err("housekeeping: failed to allocate cpumask for type %d\n", type);
+			return;
+		}
+	}
 
 	cpumask_copy(housekeeping.cpumasks[type],
 		     housekeeping_staging);

-- 
2.43.0


