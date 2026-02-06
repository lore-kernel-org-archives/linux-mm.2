Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 646A1EB28D2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB3A46B0088; Fri,  6 Feb 2026 02:06:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C67866B00A7; Fri,  6 Feb 2026 02:06:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B739B6B00AA; Fri,  6 Feb 2026 02:06:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A65C76B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:06:51 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E072C2891
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:51 +0000 (UTC)
X-FDA: 84413149422.27.EC2949C
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 58B5B100017
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VMgo1hGW;
	spf=pass (imf14.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e1sUxC0YZUR64lsfhayk4QokW4yT43rWvxMvoedrPqg=;
	b=XiyeK0wLBlfPLmCfb+Pe5TdmBI0/vVhXSWKITl+hzATNz3dG+/7ZHAPkT5yLvUzc9g2ADO
	nXbukflpefcHFAmal0oP24vbv8VDRLm5pH7vozGhEjVKjlodWMPZz946MZt1Y1YSRGUOQD
	AVE+CII/bcvH3u+7ArIdHhTiWRiB7Yk=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VMgo1hGW;
	spf=pass (imf14.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361609; a=rsa-sha256;
	cv=none;
	b=xh6VLq+/ZKTwKppQqo7+CGgw8PkP2c2jDNboPId7mTSVtEQholJdNzR2CQevnJSLKK5ls2
	gZ+A7c8tsJ42ApB9L7ORRpxyJ5WtRdvgKBD1+S4QTHDMgxRlnCIct8i4Qd6e/lU/rq1yDK
	c/dqnHqSUbcZH1c5uI8rT3VTYsVfXdo=
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2b82c605dbdso3645817eec.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:06:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361608; x=1770966408; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1sUxC0YZUR64lsfhayk4QokW4yT43rWvxMvoedrPqg=;
        b=VMgo1hGWgothwsT/MAeV+0tiAj8Of6Wt+smjBFqP5t0orhNwrK+lkRdP9jkNT0LQuv
         Fh4on8dqDftDoWykWN8cL/6zP7Gj/KdabDBJmWbvVPaXV+mirlUsCx+6XzKSmt38e3+z
         7GxikUafKaC8dw9c0wcT0LlHrvimCTGMBU5XsAS8dZgrqygP6upPGO3RVHE+1GDJ6jmj
         e3GLrGSNjiwGNykAUf5qEA3ngdfnu//C7+/vglB6sBTR6ycwKijxlxqrVrDfyyGx+eoU
         IOfIf2sI9hCJn1AYbFgwe35XeS+dB+jaW5ZbTZ2VXbTkQtYo9T8hdPIf/onx71MQJljX
         DEag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361608; x=1770966408;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=e1sUxC0YZUR64lsfhayk4QokW4yT43rWvxMvoedrPqg=;
        b=VP4feWePCcl7GJtoeASBsALioO/rsUJ3njoVyV3/8451+3ZazlwwMcO5qnYsnCGt4D
         6kSJYGrnH3gfu+dcR8HahFhb2o5plGKSAssWNrEYPe8bJJNxPzUvfbpG44TkEv1W5K7J
         NuVhCky6946rmya6/VxhdHUniIBsS0WptmS8X6W9NXBp2m4JZfRU/M2RU/++DodUuywC
         8kAuRY34jw4GPiEJM6J/W3x4Qtc7dN58UCcTzaPta2jCJTivfzK2HHbK1/VJ+uZSeXEH
         UNiOBfvkyGUtz+5fwgQhU74bVwzz8ilsMOZwNyrTCzv0viOKQNJs/+hnDgtGgzQ+ON+w
         LRLw==
X-Forwarded-Encrypted: i=1; AJvYcCWd6tnzRaBsY5Hb+er3zpvBReD7qjVWB7itjk2KNGfi99YLzN0FokZuSJfFF1rqH2x5tg4w7HSf4A==@kvack.org
X-Gm-Message-State: AOJu0YyET2j8GBjCtkUifEZ7QzMAxFD5UcFfzkhe+KDXmuxywwKzGSi7
	N2MI5cK1SeO+gkZtB9CCzDumqvH3KlVb/aVZyihFFJ2By+idbSK0xOje
X-Gm-Gg: AZuq6aIbucy/6XTvenX2OBRzUlKyfaxzHqNh7E0T5ZZUy0Dn+J8kBqUy4SayoNGnp9m
	/XXM5HVX7MtnjLA0HN4ii4ZE002K223PdB2yQN2DFedEDWlXxqd9o5eSS4KCjFSLf51V9SxJQ25
	rhN0Zr/iYA61D/ssQAqx3zlBo9+/Jo1bxlEvjCVB4oOjVls6bpq+W6h4ubJrf8k98ENXdBiHXUh
	YqZr9myBTlwHbKywc5cnkdHi+ykBqAgTdYJRAkB8U9LwNb5qhRqdLPPbcUg7vqMAgXcFIBxNSOw
	0iAMvc0US1LjDymkYQqFB/eQnQRGh5GQP/YCwSN10tM7f5JRybVEn32ym4hk2FwCZNM4q9twe8s
	+NXCilpH7GOVTYzW0MmscLCJNovq/WZ/ZtWqFEM6NIijNjoi4q1UN/00J4iuhDR1kFvzk4HHQfx
	dvlnDcPh/AXw==
X-Received: by 2002:a05:7300:4352:b0:2ae:59dd:cfd1 with SMTP id 5a478bee46e88-2b856722ff3mr747970eec.22.1770361608102;
        Thu, 05 Feb 2026 23:06:48 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:06:47 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:32 -0500
Subject: [PATCH RFC 11/12] sched/isolation: Implement SMT sibling
 auto-isolation and safety check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-11-00a711eb0c74@gmail.com>
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
X-Rspamd-Queue-Id: 58B5B100017
X-Stat-Signature: 6xms8d45hdhxru48aeoapq3unif39zsh
X-Rspam-User: 
X-HE-Tag: 1770361609-737228
X-HE-Meta: U2FsdGVkX1+O8r00J7caE+y5enZgxOE13sSFT6cj01OkAfIJwR8821y7ju5G5fl8S0DwBSNELo9zd6Vb4HgKr7bM5yc8QM/E89VTdvhJAbBUqqyXc0GAZ0bopD2JCK0+qHvEDldcgEDrYVF/Lxjnwy5aUEY32XZq1Xzc8yeLkadv1IMkpJm+Z/do6HFJWsU9IZpPiKlgm5T20+W4oLDFM8cEFGnfvgYwTBO6u+eSfGXlsdFHKkUH++5DSXRTv5whG+qTl6ur5k46TsrxtK6jGccX7GndljNlMwrk8xB0iLJ1v/KvFkACVhLKlssaTYQVK0oOCVd1Obh8Yur0Q/7w8DypO+YGxAqxuFMvA0pSA7uDJpUQa3dH3Qpp34ZMDNmH29h8NLNTCy7jz5m5dakj8cgL8ruGVTORTX6r63vodSNZXlqAv8prFkfVCXxlz7M0Mjet7IH+DPCUdgpLvtgMguEHdxbIYQGo3oPnWR3+svJmKhOVmvxn5n8LLAa8b1U7RbzyCKXe98rPzoXply32mGsvJ4LfPKJ4jyjWlAVC3vCvmsQmwJrFQHtbhFn+ocSaT6BuKG2mfrIPdME83K5L0wh1nrJ3WH7lmgDZPk92NjHVxBb0TXTBpzR10j3v4mQQEjcUO2KbrOaTzugKMo1IO/apWopZjsG59fAgJZfKZr9rwcA4vhjXDmBFtG1lch6D+2dHIlfI6y2TfQYr+OND/2w9lX3ITGh0o9auJeaGvLS4jYf1gGA+NrcWgcOz3Reh3i5Ep06Fi7zAXYkQfO0tm02wsdzYmxhclQAklX+FOkVTyaVSpepGucQDs9e0fuqycwAHLUoCX6gqyTzmVRP5h3RkY6BkaNdzX4Ak2z17EH69x4+z7LOjb/Cssa7XRkEJpIWgDysWHPflVr2i4oF3cNsldpazVZms02mcGnldnd+9KjvfLyBUH6+6lgYgBEuEiIFGuUGk+V3ZCrRXvMb
 sn1gRTtQ
 MYCu3Ak/WFZ+WcMk9JTK9QjAKNzy+fY9lthFicY2vk47Yo0Ib9VOagOKnnsfjuDoyOhJ8mtKrBJPMxj5CTc5LHYbckNuem3z3AAXV6L1iKeHt26gw5U9m5ONN+hHyVd42tEVR9Owvym/j1ptB0IFBM5CDktyQjp0k7+NfW5OhyIEFC06cBYEylDkFrmdlKRMaIJiRxOFxpRZFevvEAngqmKVhyULIJ7D8M3NntvEMFJanm0xbKHX4nEIbUHZMWXNBtwzp4fJcOak65RdAIbYs7fcATpjL0LmIuydu9CS13CoGtHwYzGuj9W9fLA1iYYaJjY4jsulaf6U6inYNeK+SA6Uz84kcwGWJoGNvRjbZLPQQ33y/XEhwT8O/z1C9/nzqbInmBuEPALhGN6l6x7C0TFeXRToC1KWv+xwcsI2wz7TzQChJJmqgZo0HppV8559DYtY5ash4JKEHxXIHq0qPkTLFNkENboTVZjmxhg2hycd+d1NmKssPM1aig08EdV4FBS4PNyljazUdMJ0LWevIqxlw9NNw5Bjo6zbRoIGC7ZS33sZWj6BDgz4DCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement SMT sibling auto-isolation logic via 'smt_aware_mode' sysfs
node. When enabled, writing to housekeeping masks will automatically
ensure that all siblings of a physical core stay together in the same
isolation state.

Also implement a safety check in housekeeping_store() to ensure that
at least one online CPU remains as housekeeping, preventing the user
from accidentally isolating all CPUs and locking up the system.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 kernel/sched/isolation.c | 72 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 67 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index d9ce26cf31fe..30798e790b9f 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -13,6 +13,7 @@
 #include <linux/sysfs.h>
 #include <linux/slab.h>
 #include <linux/ctype.h>
+#include <linux/topology.h>
 #include "sched.h"
 
 enum hk_flags {
@@ -40,6 +41,30 @@ struct housekeeping {
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
@@ -164,11 +189,40 @@ static ssize_t housekeeping_store(struct kobject *kobject,
 	if (err)
 		goto out_free;
 
-	if (cpumask_empty(new_mask)) {
+	/* Safety check: must have at least one online CPU for housekeeping */
+	if (!cpumask_intersects(new_mask, cpu_online_mask)) {
 		err = -EINVAL;
 		goto out_free;
 	}
 
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
 	mutex_lock(&housekeeping_mutex);
 	
 	if (!housekeeping.cpumasks[type]) {
@@ -230,12 +284,20 @@ static int __init housekeeping_sysfs_init(void)
 	housekeeping_attr_ptr[j] = NULL;
 
 	ret = sysfs_create_group(housekeeping_kobj, &housekeeping_attr_group);
-	if (ret) {
-		kobject_put(housekeeping_kobj);
-		return ret;
-	}
+	if (ret)
+		goto err_group;
+
+	ret = sysfs_create_file(housekeeping_kobj, &smt_aware_attr.attr);
+	if (ret)
+		goto err_file;
 
 	return 0;
+
+err_file:
+	sysfs_remove_group(housekeeping_kobj, &housekeeping_attr_group);
+err_group:
+	kobject_put(housekeeping_kobj);
+	return ret;
 }
 late_initcall(housekeeping_sysfs_init);
 

-- 
2.51.0


