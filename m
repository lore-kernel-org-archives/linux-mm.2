Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A170AEB28D2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B76076B0089; Fri,  6 Feb 2026 02:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23CA6B0092; Fri,  6 Feb 2026 02:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F7D96B0093; Fri,  6 Feb 2026 02:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8BA346B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:05:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 343C01C6C1
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:04 +0000 (UTC)
X-FDA: 84413144928.04.BBA0903
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4A1F840006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:05:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WEfLSdg5;
	spf=pass (imf27.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361502;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vRf3cjvlRbAntghErCuqDOleUjIWBU7CCGgFHUeg8Rg=;
	b=5o9TyBgJiWmJhCodw8rlslJrsjxkintBo4fhvQxS2dhH8oTjy6v5Wgi7LiCbLrTMx3F55q
	FI6nIEuPARN/GJH43SNllctCvPB7qDFYWccFjMcCiIXtKjiWeLWsPSWH90Lshjx3zuHjYn
	rVDg/+pdNZRdtBvdt6gyQ450SL6XwsY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WEfLSdg5;
	spf=pass (imf27.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361502; a=rsa-sha256;
	cv=none;
	b=UWhKjSPSnrxRZvVhKk7HoGTIxyC+dYQqQglP30Mr2F33scime/qrkL8Dqnk/YXml4RqXkQ
	cRGwV5L/xy+K6/ID0AdOpSem/gpJzf0JcOkqVx9BiScancLEAa49UEHyWulbYF8mNNfnNo
	VIxHfjuJQS74jTDl7R0WpXskcpBbDzs=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-1248d27f2b9so2078850c88.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361501; x=1770966301; darn=kvack.org;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vRf3cjvlRbAntghErCuqDOleUjIWBU7CCGgFHUeg8Rg=;
        b=WEfLSdg5IO8/00oH8+AB9wypxVrysaR+co6ldsm+yfpxZbWuCwU2hKwxo0oGPbHJse
         HCcU5ZBrgOlEUPqqUxsIh3BIuETDxSMS46l/+FrnQ6jq7EFAO7ESdEuQ1iTE2WkCFpyu
         edPe9mNBcIlO0F6PQLRbQ4rju5H022ERq9bStjNE+tm11yt7i1bbtzKNqtNUBSv1U95e
         XNYZrqJEEogS68bstyJpV0ZCslAt2VWkQAqsN9h+YI8qegxsqiYYTvjuMkH9WedNqfp5
         LijFh+tzeIAPC1qwEijMVH0SedcwJC/ZXwn6FV6DL+i2DeOH8VFomCZojE1Z0COdvhF3
         n9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361501; x=1770966301;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vRf3cjvlRbAntghErCuqDOleUjIWBU7CCGgFHUeg8Rg=;
        b=xKbEwphxl4wq6lbH/lZeNTq3Zo/8BKQige8cFpZ7bSxzSLq75sUKnLIFWj/gU07P0D
         sJyVVhMQIlRLt+r7+u836Uqr0jg4WO/ix/tVrVKnSzE4WmjcD43PBcC2HF49toVjyCE0
         95zQNoJQFoI9fPHB9w7245WotT8t00+hH0a0M5D5zrr9+E1wVrJ3yOCR7GtWX3Eqz4uy
         DYLMrtJB/tfdMPzG++fFBOzY/D1Zyrjq5CNcfFELfuc4q8CC/BH8OrZYNnwiVI+kguVZ
         uClS8pYR2AAs7Ata+hIIp32piy57BzfxlDjEPLk3cTUJcTAT21nsu3YajdoP5icY+aMR
         VfyQ==
X-Forwarded-Encrypted: i=1; AJvYcCX5GINFeQ47vpyruJr+6Wk1vntcRDoYeUHWj47JDmYylZ8yZCYWCfEQsuQ0bIiKrWWZINLQ0tYbnw==@kvack.org
X-Gm-Message-State: AOJu0YylP6QqU00KuQ7cwhqp40LPE0sIf42fgJvqhlJicjT1mUPmqKen
	8mHp/rt8+85ThW886IAk4nzGYYB6Vqov0gDLGAyILaOwvlIZlyxVd/x/
X-Gm-Gg: AZuq6aJdXKl/F0FSRKcxJQZrTe9H+Yx3IdJ47FU6RFr1Ls0m8vTz1+H0pOH0OY+C31v
	e+Bi1mmVi+otX3DhXHpTXuIXDKyaSZd2mI00g8Bo843n6pqYs6NJRHnTGt681Xss4pBIPfP1JaY
	+vj53+RiNA1w3lyP/6/Iumkv26GUtGyYD155WPWAG2DfRGK9xMBQrWMHJXXu4NynE0wd9qAFT0o
	ehM4ygUNbdgbA9mFOhyob2bBTzgug1a6qBijjOnJvPbL0CFobyRZc4w3kYRZ+dpiaNHdoAaQlNo
	zBzfUhgFRTpHf8Qy8X4wN9ocjM0NO3NrB1MoOjSQbEAhvH2PpqiiR7KlzldOv+AgflTqqsZbgws
	wX0CxDa6CucYMXkPiwOi6RcFUSQBHjlxQr84i/c2d+zqHGHT2Zqkp2rwTRjmuYST0mSKNdxUcyV
	0M91euZ1GzCQ==
X-Received: by 2002:a05:7022:6b90:b0:11a:126f:ee78 with SMTP id a92af1059eb24-12704010cbemr892190c88.34.1770361500545;
        Thu, 05 Feb 2026 23:05:00 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.04.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:04:59 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Subject: [PATCH RFC 00/12] Implementation of Dynamic Housekeeping &
 Enhanced Isolation (DHEI)
Date: Fri, 06 Feb 2026 02:04:21 -0500
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-0-00a711eb0c74@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAHeShWkC/x3MQQqDMBAF0KvIrBtIo0TottADdCsiafLVgTZKR
 qVFvHuDy7d5OwkSQ+hW7JSwsfAUM66Xgvzo4gDFIZuMNlYbbVUPt6wJKvyi+7DvWKa3n1fpwgh
 WQGVfFqWr6pryMSf0/D3/hp6PO7XH8QdgPdvjdAAAAA==
X-Change-ID: 20260206-feature-dynamic_isolcpus_dhei-ee46b6e3a477
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
X-Stat-Signature: zgtzq91qt3gtho98n5fsknhj1814km7h
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A1F840006
X-HE-Tag: 1770361502-521665
X-HE-Meta: U2FsdGVkX1+azUCR5SFCY83vzUb20qVrzSdLcgIPzNlXYaC5LOJpLLXSEpmnnyS8CEt3Hvfsn80XO+kkzvstKk5OyAlCRxrGah/Mn1JIIxrzYRTQYWv6+r0E0TmNxtwjFsg4i6x8MUzBKnf04kXnhjzzJ1uaIL+3a7yQ4D9MxlyqkACHTkhAYB6ZW4uE1FlEQPlci1GQEufKh69JKywbEXzRGNzanbh/34RhkGnGjSapHoa0aPA+gJoGcShLSnvId7sGcA5IP5uW5YvBteRnhnfat7BVHrRyXwE+91Ja/fBdxEv/XqTedKhb1ZEhZMptxm9f8jei+7Xi8f+hvxuxs+IOfPckGO7/UQ0RM0UiRLPqOjvDLLdQzzYY8mboicuUOe4xsMAWV/iISfx8/Kkxeb8FQGxPFhNQ4xnF1Lj0cnOaSSG1nVoORokHkyGrBtAIUtOnKp9pPZdv6CJZ0GeGph/YpzNy9C48aM8FK09FsuV9tMLhRhQwJnrujCuxbrQvC/hYVS6VXZ3iHXUl69QizPgQ4TLQYMaZA80KLz6B362Ox3H+277VXXUrI4u1hYj7HNiu3JpmuTIKK3tlkpMwB99i8hP3JLiBG5/DqTCtDaWdpwGjTP1xNYAjgbmEzc6deXLMVTJqFD3UueLxZHi4SjE8HqJJyPPfL4JgQU1khKPj6CTkQoZ+2RO6gTxP1uGJKsZk4YhEnmGptI6mgw+gZUpSmT+qTcfkDEUjJH3iFeW6JpMe7ny49HFdmMWwHXUqZces+IAS6zMS7LaHm0YB3XXsTIgccORSXQSPKFH/5kFyu+CKz2woPasuZJwQEK54v+pl9RLgB57b94goe/sgZMO/Vr5Wa1HqJIkc+t70tHDo26SXwRArpM69LHRjceUIzjviXujjQgzAq6f7J3kO8bAWfd2D/Ay1f+el/3L5lSUuzZ/ZAk7DOEOVmst5aj3f6FaO6E0VDC+vwmnA2zc
 ALsVELoX
 Y5gQIy2tKb1ao+yowhaDHn9bccP73xo2RZJLv8RcODaEN5nSEhzA0ZOwNu93v5cfAK0eOdFQrKfCKhLaeIFPulTpMWnGIIXkH/rACjVVBlShIgXGj5Fl1j0QUh+BvpcK1usseU8o7L4wY0IBTjlmm0gj8FRETyYOYC54C+mRTuTxccoP7Xz08UysCCxrlPi7bv0wzloZ2qWvID7ub6PXkQlNJMe++Z/tCHB/i8+y7M61V3+rIqxy3qmUkKs5FmVkSbJvLBKTjOmVSb+nfEO+4FnsrPXN3+c56vH4TMUAW4aPpLZAs8RlZQxvpGpyeCXFnZbizeKihKANI77U50ArXLp13isoorvOdQb1CMw3vOIsiUfNMdmA9pHH9vBlfVnm8GiDJlEzSJ4lXRpH80ityskvD8NKfKIHebAfdL4o9/PxaJ3gvkfkVgEjPUDAZ7Rmg6leFj6oagiAk9OGjwawC0DZCh+yd6GlMphu1jKw6hBjvxszEykgB/oKHZg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Linux kernel provides mechanisms like 'isolcpus' and 'nohz_full' to
reduce interference for latency-sensitive workloads. However, these are
locked behind the "Reboot Wall" - they can only be configured via boot
parameters and require a system restart to change.

*** THIS IS AN RFC ***
This series is being submitted as an Request For Comments to discuss the
architectural changes required to support dynamic reconfiguration of
housekeeping boundaries. Key points for discussion:
- The use of a blocking notifier chain for cross-subsystem synchronization.
- Compatibility with existing boot-time isolcpus and nohz_full parameters.
- User-space sysfs interface design for granular isolation control.

While cgroup2 (cpuset) provides task-centric resource partitioning (including
unbound kthreads), it lacks the infrastructure to reconfigure core kernel
subsystems or manage per-CPU kernel activities. Specifically, cgroups cannot:
- Managed interrupt (IRQ) migration.
- RCU callback offloading and grace-period kthread placement.
- Per-CPU kernel threads (e.g., watchdog/n) and global subsystem logic (e.g., kcompactd).
- Subsystem-level masks for unbound workqueues.
- Dynamic toggling of full dynticks (NOHZ_FULL) mode.

This patch series introduces Dynamic Housekeeping & Enhanced Isolation
(DHEI). DHEI allows administrators to reconfigure the kernel's
housekeeping boundaries at runtime via a new sysfs interface at
/sys/kernel/housekeeping/.

Core Architecture:
1. Notifier-Driven Synchronization: A new blocking notifier chain
   (HK_UPDATE_MASK) allows isolation.c to signal all participating
   subsystems (IRQ, RCU, Sched, Watchdog, Workqueue, kcompactd, Tick)
   whenever a housekeeping mask is modified.
2. Decoupled Memory Management: Replaced boot-time memory allocators
   with runtime-safe variants, allowing masks to be allocated or resized
   after the system is running.
3. Subsystem Handlers: Each critical subsystem implements a reconfiguration
   handler to migrate pending work, re-affine kthreads, or re-route
   interrupts dynamically.

Key Features:
- Fine-grained control: Separate sysfs nodes for timer, rcu, tick,
  workqueue, kthread, etc.
- Dynamic NOHZ_FULL: Supports enabling/disabling full dynticks mode
  on-the-fly by re-kicking CPUs to evaluate tick dependencies.
- SMT Awareness: An optional 'smt_aware_mode' ensures that all SMT
  siblings of a physical core stay in the same isolation state.
- Safety Guard: Prevents the isolation of all CPUs, ensuring at least
  one online CPU is always available for housekeeping tasks.

This series provides the necessary infrastructure for cloud-native
orchestrators and high-frequency trading platforms to dynamically
re-partition CPU resources without incurring the downtime of a reboot.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
Qiliang Yuan (12):
      sched/isolation: Remove __init restriction from housekeeping cores
      sched/isolation: Introduce reconfiguration notifier chain
      genirq: Implement dynamic migration for Managed IRQs
      rcu: Sync RCU housekeeping mask on notification
      sched/core: Dynamic update housekeeping_cpumask(HK_TYPE_DOMAIN)
      watchdog: Allow runtime toggle of hardlockup detector on CPUs
      workqueue: Dynamic housekeeping mask update support
      kcompactd: Add housekeeping notifier for dynamic mask update
      sched/isolation: Separate housekeeping types and add sysfs interface
      tick/nohz: Implement dynamic nohz_full state update
      sched/isolation: Implement SMT sibling auto-isolation and safety check
      sched/isolation: Bridge isolcpus and support runtime tick offload init

 include/linux/sched/isolation.h |  40 +++++--
 include/linux/tick.h            |   2 +-
 kernel/irq/manage.c             |  52 +++++++++
 kernel/rcu/tree.c               |  43 +++++++
 kernel/sched/core.c             |   5 +-
 kernel/sched/isolation.c        | 252 ++++++++++++++++++++++++++++++++++++++--
 kernel/sched/sched.h            |   2 +-
 kernel/sched/topology.c         |  26 +++++
 kernel/time/tick-sched.c        |  63 +++++++++-
 kernel/watchdog.c               |  24 ++++
 kernel/workqueue.c              |  39 +++++++
 mm/compaction.c                 |  26 +++++
 12 files changed, 547 insertions(+), 27 deletions(-)
---
base-commit: 1f97d9dcf53649c41c33227b345a36902cbb08ad
change-id: 20260206-feature-dynamic_isolcpus_dhei-ee46b6e3a477

Best regards,
-- 
Qiliang Yuan <realwujing@gmail.com>


