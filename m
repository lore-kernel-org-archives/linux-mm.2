Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BBACEB28D0
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:05:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E1F66B0096; Fri,  6 Feb 2026 02:05:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77EA86B0098; Fri,  6 Feb 2026 02:05:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6813F6B0099; Fri,  6 Feb 2026 02:05:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 586506B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:05:30 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E6248C2876
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:29 +0000 (UTC)
X-FDA: 84413145978.19.B7DCAF9
Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id 388A620003
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JkPD3Goh;
	spf=pass (imf13.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YEyu0s9ArePSjQ+ivxTOHvq670EsiUwyYwwidqduHM=;
	b=rf+TDHIKH+L66DMxWxT8apQqKopFOT2ixU5llfbIGtCtvzVaqekmN3D3EOn4ufevn8GvWD
	jMD7O+00kkeXnb2TkFN+e6ZPgAhxen4JTYmdQbdbcODADc7pvFteyS0iImSOnIfNl6Zjzv
	z5C4GPPX0GinD4eBzegSHYX9AoKtCgY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JkPD3Goh;
	spf=pass (imf13.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.41 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361528; a=rsa-sha256;
	cv=none;
	b=kaZkx8pdRe52x4YqJtiDH8j9I8m6+ITHkHoYPn7pz7yP+8P9+NSpXDoXG/RPCJ3dpmspOc
	SSKIyOI0KnZOiRitzUR5AeqUSKws/mwBwKuG1mw59sVsQ2joNrMz/1Ierjklk+jun2EoH/
	BEPtJFnZYbp0VMBM64GP8EHv/kJqu4w=
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-124a1b4dd40so2149398c88.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:05:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361527; x=1770966327; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5YEyu0s9ArePSjQ+ivxTOHvq670EsiUwyYwwidqduHM=;
        b=JkPD3GohmdpTfPSY6wtBpdnKGSdwcXk+7U7JOiihYQeuX9nXSkonlm5Xelj3GAwsGP
         dpDRhKvIM7aDl766/W9klsBrQAcqqTX0LGCdFd3bBzYEGE6PGpmJDWUFvknr1XRLugD3
         bYPZL7/YIn4xUQtZ1fczlvADA5yww/QlQEUkCa9A9hayi0ZMzViojhyMXvL/IKmvrf43
         J+yyayjBwaLx9+/bUqS1KfhEcuJyj22B7ZN7rnHodaDzK1uRPOqmT24b66sz1xMK76pq
         a4HTiUx07i6/i4c/FMOnCvbnTj4Qt3CTpvsjLeNQaHjCdElBUyIHX9//z8bp455nz4Iw
         dJtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361527; x=1770966327;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5YEyu0s9ArePSjQ+ivxTOHvq670EsiUwyYwwidqduHM=;
        b=jEkb//fb9RU6Vsnb1eSutbIEpTh1/hrVoCzrx2ZpLZH+9Qn7QL7xW4lCmCtg1rjade
         M/eW6Ac+ydlZNQKYZU3JVZpCpcXNaBum0EVGMPk5WYghpFqpGs+9TZUkO5MPTvYglGya
         KTLnOH47c9/gDJ0SR13LFUD+bDmlUf4JxE7hRQvKf/G03VlBneOIpoTpBVRmuaZ6wrhZ
         D5s/sZ1PTsfGY2mcWgDP33i5Jhd/pojo5uw/f/7S/Gu9ae4QgmVwD2ADP9e8SP56GLbi
         FCIRKFHXBLRL+7iSyF/ieGw5v2aX4hXjQzd5kD1RRZjI8TdWM3Od4zl7RucGuYpp8ESD
         pv7Q==
X-Forwarded-Encrypted: i=1; AJvYcCUaGy2bukajD2xwDYH3eZNXQ05AEeNj4poqMU+gbKulgucE60PZPEoC3fDQXb4FFG325V1BA2BJAg==@kvack.org
X-Gm-Message-State: AOJu0Yx6rqAsV8R4ExBodVI0MAAI09Pa8g8OKhgPeaqLgzXwYidWQywh
	ebL/x6yjBo8T/UlcORmxccRpnhiy+xjp036uUJNPhpuMCwJj5Xd67zTq
X-Gm-Gg: AZuq6aInAh9X7/Ttdn39cf2e4zfW72Wfu5LLMI88xDaGciKs9lHJYgBat862NcjEIZ2
	Fm1qr57w/nf9A8sDsE++GkIWr4kW4tZrW5VEY4Z6zUn4PFcR3i4jj/sI47fB8tRxu9lVDrq79f4
	SQwyz0FHrlOoEaFKt1l+pb4OdUUX5hh38UaNTbsTEAQU+NfnjUIUmmGM+UaunB94K5ITJIOsiv3
	Ln5CZfnlKYrZTCunIWlQJ7qFFTJnP4AvavaFQbxFUHtkDGcsxwlNaoGnWXhJmQDBWM1k+oEXIhd
	DGkusuWa0zMBe4k7Qliic3qsk2nhUpYl/Qeouf4JgGKrk/Up457pSxKOkEbk33I2qxPzE0Vzp52
	YRgbNBbBOD3egAo8tXCpiHSQqlS9WSGdA59kfVFvoy0qhnD6+nQZGDSxZ8oYzeF09FFTWIHw6Tw
	sz1UwtkvncnQ==
X-Received: by 2002:a05:7022:222a:b0:11b:9386:825c with SMTP id a92af1059eb24-1270402ea16mr1071439c88.41.1770361526887;
        Thu, 05 Feb 2026 23:05:26 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.05.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:05:26 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:24 -0500
Subject: [PATCH RFC 03/12] genirq: Implement dynamic migration for Managed
 IRQs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-3-00a711eb0c74@gmail.com>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 388A620003
X-Stat-Signature: rm8gk9gh6hb564ebycmg6ckzxai5ngk4
X-Rspam-User: 
X-HE-Tag: 1770361528-187901
X-HE-Meta: U2FsdGVkX1/m6YXjEhg1CTKQzvL0j6qLb3evjRxSv/xBePQXHQbpCViY7k5DajrqeQhgKDs1LCmOg/xlPaET6WoneCS7bfVGEFAaCGaWg19FPh061XN6qpdI9So00HIOpHNUQvDfwM7tuswuSrae8gi/4r1HTBVTiaasskPD0MuRF0UdtjUxRnUogtnkmZ+qMUuTcpFOkhlbwZeIKF1/WzrZgBf0S9JE5P3JyTvGfD+EN8we+vaTS1j5+pi8EOEi23PXGLwu/O/aUd97/Cddh7AhyyMQB+d4DNkjiEsa2VTXZ4y7lGjgDx4w2A0Ij3NsjHYHtTTzNcwv8OhQccCT7y3F0WD+x+b0Aye5MLLqYdJlx+OblPWhym3ObU4Ic13Q9HvXnx2VpBgTzWqCF+Q9k95rGbx+y92tX31Qzoj/IxJb4f/xqUl+2JsDvBmUsHjdkZ30EFlzJGxl24ReLBCTxb1UJOwN1xrmzCp7aGPCasVCDjyEpnKAzXIJFAqRpKxvEt/mrHH0GuOs+e2XZWqsfJPVoiEDz417hk5fTI5rsVRZMZgP2lD1jgUdVM37ktPa2BtoenGLT6Po1n4In8xoTGmsCT3VfKZlxODZ0AI9QCRz39d81ANZICaL0fVz+y+mYtprzmmdhPjzioPdwQsyAE5KXQ8DOQj6bxJsKpWziekIfKbkBl7Vs3V5QIrKvvz1SLDlGAGccDHqFMw8WDmr6TLEl4dhVSisLlDGHZJLttpGFDyn/tNaerVkv0mojB21RVOK8hdckdyBF2PP/c7f3B5JRDJlGEVSfqcqLAzxGj4cXIT6U9yFVovroGh+rk5F7eSwy4ictKb1PqhaOBUo3IwyaGF14dsX7gb9vNuyc9ep0/3wKCdMor0nVzP7j6mMwgciTKeG15KoqAnhqFAcTSkCLkIoTFoKzDA5WL6hkTVP3Ri9Pi73RHuH4RCb6d7XBZzsk/YwB35hOL5PCJH
 QiH+DdPd
 FK0u/Y/rsN4E7fa8B9taRA9DD/I3vrsMMS+HHBa2Fle1VDnwJKBfCA3mXF7kmHR+Z8ahwrR8H/mWmqV9Ek1zsYYZQDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Support dynamic reconfiguration of CPU isolation by making the managed
interrupts responsive to housekeeping mask changes at runtime.

1. Register a housekeeping notifier in the genirq subsystem to listen
   for HK_TYPE_MANAGED_IRQ updates.
2. Iterate through all active interrupts when a mask update occurs.
3. Re-apply affinity for managed interrupts to ensure they honor the
   newly configured housekeeping mask.
4. Use irq_set_affinity_locked() to trigger migration away from newly
   isolated CPUs or towards newly designated housekeeping CPUs.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 kernel/irq/manage.c | 52 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 349ae7979da0..9523f0655b12 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -21,6 +21,7 @@
 #include <linux/sched/isolation.h>
 #include <uapi/linux/sched/types.h>
 #include <linux/task_work.h>
+#include <linux/cpuhotplug.h>
 
 #include "internals.h"
 
@@ -2811,3 +2812,54 @@ bool irq_check_status_bit(unsigned int irq, unsigned int bitmask)
 	return res;
 }
 EXPORT_SYMBOL_GPL(irq_check_status_bit);
+
+#ifdef CONFIG_SMP
+static int irq_housekeeping_reconfigure(struct notifier_block *nb,
+					unsigned long action, void *data)
+{
+	struct housekeeping_update *upd = data;
+	struct irq_desc *desc;
+	unsigned int irq;
+
+	if (action != HK_UPDATE_MASK || upd->type != HK_TYPE_MANAGED_IRQ)
+		return NOTIFY_OK;
+
+	irq_lock_sparse();
+	for_each_active_irq(irq) {
+		struct irq_data *id;
+
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		scoped_guard(raw_spinlock_irqsave, &desc->lock) {
+			id = irq_desc_get_irq_data(desc);
+			if (!irqd_affinity_is_managed(id) || !desc->action ||
+			    !irq_data_get_irq_chip(id))
+				continue;
+
+			/*
+			 * Re-apply existing affinity to honor the new
+			 * housekeeping mask via __irq_set_affinity() logic.
+			 */
+			irq_set_affinity_locked(id, irq_data_get_affinity_mask(id), false);
+		}
+	}
+	irq_unlock_sparse();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block irq_housekeeping_nb = {
+	.notifier_call = irq_housekeeping_reconfigure,
+};
+
+static int __init irq_init_housekeeping_notifier(void)
+{
+	housekeeping_register_notifier(&irq_housekeeping_nb);
+	return 0;
+}
+core_initcall(irq_init_housekeeping_notifier);
+#endif
+
+

-- 
2.51.0


