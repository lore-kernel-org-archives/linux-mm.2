Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D67E4FEA837
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:11:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47FD16B00AB; Wed, 25 Mar 2026 05:11:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42FF96B00AD; Wed, 25 Mar 2026 05:11:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31F5C6B00AE; Wed, 25 Mar 2026 05:11:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1AA056B00AB
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:11:11 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D5626E0B76
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:10 +0000 (UTC)
X-FDA: 84584016300.13.6B81B70
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id DCB04180011
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:11:08 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IBsQNBRm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yZ5gRq9U07SXKnZs/b+mpems8hvXSmfr+O/2j6j26po=;
	b=zrxbkrJnup4fcDW4QblZeEqKEKGvlDZJCDU4rIAYNmhUJjxa6XEAEhVQ5G+dG3jIP4yY91
	/31Xh6O2NBnuBK+8sGy8xgRlcRFjTPFXpdIox7L86Xva7KGBfnd9tkTTg2gSvss7Okf/Aw
	OHYxKq5bw++eJHndNt2P4X8ipXTTTWw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429868; a=rsa-sha256;
	cv=none;
	b=WiPQriRUUUjXUxiFA08+aYLEMN4tzPvl7dE9bk+D3Og/nK+FMLFWaAxPmNUknAlarabL6m
	GDJ8Wh3G/2Y0fJSEdHhLJWjQfUzK6mGwTKTivzAhWlZRvz8GR2Nkq75osXJqboVeGDcnfz
	0EaJA+ezdyvMDRpMK7AH4rPEdoGXIbY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IBsQNBRm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=realwujing@gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2c160308a54so45639eec.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:11:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429868; x=1775034668; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yZ5gRq9U07SXKnZs/b+mpems8hvXSmfr+O/2j6j26po=;
        b=IBsQNBRmpMSknb8gHwWR0w+/2i9zw8ZZ25GyvhvQGyrZGLgW9Ieyi9BvHq/+iiXPv5
         Kqr7NNzHHNoKXdefY8y19qzRyozvip10/XzBoVUQuhkS3fRYrypWOSIE45T6ztWHeUVi
         9jHGpg1o6XvWx+L78bJdhmrn792Vata/6sQ2jZJRNp485lFvcJL83GyZBiLvjIT/B6ay
         UzZZxJeU1XS5KrPnGvlqM5sXJkvYdyeXLMYuJqeYU45MfAJxXuVdpbe2DaD/EuEb+x1k
         KH/0Bh64Wzlvl5OgIEpIejTNi9Sz/S25kGTrcCOma15c62ytUXSzSqGMfBKLL/mceeME
         3HpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429868; x=1775034668;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yZ5gRq9U07SXKnZs/b+mpems8hvXSmfr+O/2j6j26po=;
        b=H+Dn9nt8fwT6Xmuu2ta0iOTN2GJo7j9AZzlFJHGQvxTKVpAyHUbx6BxIKc1sCV9L5R
         lG8DIL3aUT577ns77sVQ7GCuMtasKUqwxEOIU+TkmTjiPnGEoV0ruxafTU1GWM6ALyQm
         UONS0HMs4wUaMvtbpq5DWci+ntn1wZ424Lm9eaASsgEs0W51RKm/RQRrbyWvYyeTJ9u2
         kNna4PMjxLmk8NwwoDHVrdDwTAz/gZDV40gR1Cjf7XBx1e21GNnh58fgI/MolRk730fI
         nQHuknOn5nFxO/4rbAoNK8mwcTbdbIl4qzMxJDOYgVCEuU7eKIeiawnYsithSYep8bRL
         9F2w==
X-Forwarded-Encrypted: i=1; AJvYcCVPHD2UwTDxFp91M5vEoDqmwUn63qN4RTjVWL9lXWXaKy2/J9Zori/0+IfndBoTq0v7XnulEi7Vyg==@kvack.org
X-Gm-Message-State: AOJu0YwxqLu8TJ6G38qLL6/0+PKdb/Ns/kiHxJ875BZAMZWRtY9jRJPM
	GfzHHDOFPlNi5VNTbN5kPAJKto1r7hqt++FMNtL1KxdCHn8a2xk8HUnt
X-Gm-Gg: ATEYQzyb7SMUnXZAJ6pE2kHBn2B6vwcB9kKLQwSlASEU1QGTN3ZwntTyHaDpMOvBbf6
	CwBndb4vGtD0ZqqrZAOBHC6HvCX2OsD17v1LoMQxWg4UKKlrT/rJpLNVSvc0p3L6KmrR8grXwUs
	O600SHtqlOhVxqz1SODVta7sEwDTAyIlol7fioyuV++k8X/EfdFQWnkwVHPzfkR6sMypcfBZZh7
	O5qnq+NLtg7QN9gxDORBBuA8XhoN1nyz+bbxWClkABZzOkKQo4BENpAboKu5HEb3nRv8Hk/9YSq
	ZfMM3DxI8C65UJ3xCu1gqw9VRtwbo2LVebSdkcd7klOsUSYkL9/lXRbKxhNN3Q4UOT91J3XAkmK
	WO6YA5DOPtaX9sSGnjOaY9mwWJZI0uyZ9SR1sTa6rXpbljyvEDSn7OGFt1dOxaXZTg6aju7pYp+
	pBFWZX9FuAt6JeNsJ6
X-Received: by 2002:a05:693c:3746:b0:2be:37d:3d6d with SMTP id 5a478bee46e88-2c15d41a548mr1430796eec.32.1774429867454;
        Wed, 25 Mar 2026 02:11:07 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.10.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:11:07 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:42 +0800
Subject: [PATCH 11/15] sched/isolation: Implement SMT-aware isolation and
 safety guards
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-11-919cca23cadf@gmail.com>
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
X-Rspamd-Queue-Id: DCB04180011
X-Stat-Signature: ye4h6citxuazizqth5ksr3wzzsn9geys
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774429868-278239
X-HE-Meta: U2FsdGVkX19fVkewRV4zmUXZjPk9DMcVhTdQNqsBQqOcLTRZsTMfq8N6btCkPB9xHJIDFEhor4RAP1FNCiYgzCJVxR43oToPUkUKNPVPu2NvfOc8tO/t9x5fB9wWXN2C///coho0inSu6Yco1KBkEHhfxDXUyUEPfGz+5xYQP1Oevs5ozBK0WDJ0K0BfKlSK2htgBh1ckq8bDHNRh70dm0NVm+alICefZAbGsXmRPf1YGJiz+TZFFNCcefOr8KfYzQjqYM2VQfJs1CdWFjhgpTFbC6DD7WOxGVD+gjDQL7MYW908yVFkQmQF5CYghZXJzoO+TypwgLCikYMxkgcRMFGcWUTry2v4oMPyOhmslQ5YCXc2Bbbw9hXioqtUuoDCW1lArJ5+uyr/eyxvBhO28XAw7pi+NmgOFqwoC5u8XrmCva2kBYIyI6tmLfF2OxI5ma4LBLcIxCSyLq99rx/FM0Xhz2u4XLe6Du+FEHW1DBZAV4HpgU8XVfqZlg3bP+YBTbXxcP2tKKUlO23lSMUggFJsu5up83AbO8D41lUqllyGoIfYTkq+Pvt1CDDOvC/8aiXENblJztWPh/TWYvNFiKyIzvmBlYsOOreEBYugEzABCzW3X8NHq/RQzBtHPXIxWSbb6VvAk6dINTq8OlElRWe6JVj818ggn2lqtIBc1JF/TaqQ2zaDpulxCKi3874LLanmnejrFR45YJMKZxgJpT1KU/N77ZBdip7ej/HbAMjFS2LGRhx3UfNYaE1GJ/7J5EPyooYdEbpr8YVkS2ggbk/A8wivhHC8tfTjXQA5kBM0PoDI5yektNVY4aZq0Bth/lJ5gTk858jCCkKhuxWeXWUXmeBrvSADQoa+k/JarPoH79WD3fd9sZN07Bn4VIkR1GEhnxSNz909PS4YozSu/Ay9uRNNFeg2uMbsFpiQgzgYgB1LjL+W4aw/IGaJg0XhuwY2OOLb5lZV95wHW2n
 +pAftEli
 ZcxY2EVWbbjUwmqG6Ja5f2UoOe4yoJSxuIr7i7npw9S8i8h1bSpe+HDx7JnZBP8utV4jS6zUxlb1X15l07pE51Eg0PuGMMjxyP2A/QgkgGIVIruWUsNKrrkK8AHI1ojRF53hPP9e4QzBW5efntHdAEX9vZc8Nv0+khgJeK9M5VMbEPbHJgwPuUR7IgMnSK9gQhrdS8FQixPM1oAbz38RsLZ+SE3XhPiTjDCs65Z3bi8drVcuiR0i4BvSYdIQ4gBYjepOQlSKe3M2bqLcDvi5P4v7x3UDL1b8EUyBnMG570ZfBhUN37Ow/dy4b1iZeKuvBmnxSA5TWeZNoDQgPcnJpF7a5xAH6gV4VBEEjV6nWiMQnAMGdageEleGDzknxK+7qEgqWmgq7Nh9wg4BUUJRXb1Dkq29RFaqUlowiNTf8jDtB0j7aGofR08YPOKoL036jiZC6EnzvB6GrUvZsI0iNo/MdfCGBGUWVWWcDrp71TM5o689gswWkyw6j0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Manual isolation of single SMT siblings can lead to resource
contention and inconsistent performance. Furthermore, userspace might
accidentally isolate all available CPUs, leading to a system lockup.

Enhance DHEI with SMT-aware grouping and safety checks.

These enhancements ensure that hardware resource boundaries are
respected and prevent catastrophic misconfiguration of the system.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/sched/isolation.c | 180 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 180 insertions(+)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index e7a21023726df..4a5967837e8de 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -10,6 +10,7 @@
 #include <linux/sched/isolation.h>
 #include <linux/mutex.h>
 #include <linux/notifier.h>
+#include <linux/topology.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -29,6 +30,30 @@ struct housekeeping {
 };
 
 static struct housekeeping housekeeping;
+static bool housekeeping_smt_aware;
+
+static ssize_t smt_aware_show(struct kobject *kobj,
+			     struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "%d\n", housekeeping_smt_aware);
+}
+
+static ssize_t smt_aware_store(struct kobject *kobj,
+			      struct kobj_attribute *attr,
+			      const char *buf, size_t count)
+{
+	bool val;
+
+	if (kstrtobool(buf, &val))
+		return -EINVAL;
+
+	housekeeping_smt_aware = val;
+
+	return count;
+}
+
+static struct kobj_attribute smt_aware_attr =
+	__ATTR(smt_aware_mode, 0644, smt_aware_show, smt_aware_store);
 
 bool housekeeping_enabled(enum hk_type type)
 {
@@ -110,6 +135,161 @@ static int housekeeping_update_notify(enum hk_type type, const struct cpumask *n
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
+	return cpumap_print_to_pagebuf(true, buf, mask);
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
+	/* Safety check: must have at least one online CPU for housekeeping */
+	if (!cpumask_intersects(new_mask, cpu_online_mask)) {
+		err = -EINVAL;
+		goto out_free;
+	}
+
+	if (housekeeping_smt_aware) {
+		int cpu, sibling;
+		cpumask_var_t tmp_mask;
+
+		if (!alloc_cpumask_var(&tmp_mask, GFP_KERNEL)) {
+			err = -ENOMEM;
+			goto out_free;
+		}
+
+		cpumask_copy(tmp_mask, new_mask);
+		for_each_cpu(cpu, tmp_mask) {
+			for_each_cpu(sibling, topology_sibling_cpumask(cpu)) {
+				if (!cpumask_test_cpu(sibling, tmp_mask)) {
+					/* SMT sibling should stay grouped */
+					cpumask_clear_cpu(cpu, new_mask);
+					break;
+				}
+			}
+		}
+		free_cpumask_var(tmp_mask);
+
+		/* Re-check after SMT sync */
+		if (!cpumask_intersects(new_mask, cpu_online_mask)) {
+			err = -EINVAL;
+			goto out_free;
+		}
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
+	if (ret)
+		goto err_group;
+
+	ret = sysfs_create_file(housekeeping_kobj, &smt_aware_attr.attr);
+	if (ret)
+		goto err_file;
+
+	return 0;
+
+err_file:
+	sysfs_remove_group(housekeeping_kobj, &housekeeping_attr_group);
+err_group:
+	kobject_put(housekeeping_kobj);
+	return ret;
+}
+late_initcall(housekeeping_sysfs_init);
+
 void __init housekeeping_init(void)
 {
 	enum hk_type type;

-- 
2.43.0


