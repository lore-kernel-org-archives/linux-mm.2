Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFA24EB28D2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:07:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 607176B00A7; Fri,  6 Feb 2026 02:07:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA8C6B00AB; Fri,  6 Feb 2026 02:07:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D0C56B00AC; Fri,  6 Feb 2026 02:07:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 35A8C6B00A7
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:07:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DDC2913BB1D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:07:01 +0000 (UTC)
X-FDA: 84413149842.24.0BBB365
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id D901F80005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:59 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EY1Ml7X7;
	spf=pass (imf02.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=po+cGkyQwauqMh1hjbbX16QLLaNcnoHPzcdRT786Xgc=;
	b=xYXEiqUGwvG88wRBnkoR6PNxze4HHmFB9WbFKEdtZ1UvD2r3SQcDQTqtgb/SmNrI1GfKRU
	Gps6S2SZiGeHF8ZAFrdBS1VVEewg5esYkevS5yUJmRpYWD7tkuN+O2mjVj0m3dq9nMKXxz
	w3Udrv+HKLrIsOMuZs+UcCQwbJGVcK0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=EY1Ml7X7;
	spf=pass (imf02.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361619; a=rsa-sha256;
	cv=none;
	b=t5TNvAAe5gKbdsUQFiVKnRVhMWyf+a9Jpe6EzYFWnytdDNVO7MsY3HSmiswujlfjy5hw67
	pU3N+QnTm9fK7roHFmJ+ojbYBekKh5Y2WGr4C0rpCDJrWytUcvKUIlG9o8Bh03Inbp9OpR
	NjUjOFVQ1mjzVnc2KKgy6VwGJEfgvIw=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-11f36012fb2so354555c88.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:06:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361619; x=1770966419; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=po+cGkyQwauqMh1hjbbX16QLLaNcnoHPzcdRT786Xgc=;
        b=EY1Ml7X7MalIvGD7K6bLrzVo+NiwxDR3jYl8LFD08dN82cl3vYXnmQsJ8vXxCZKVFl
         1KA3MjhnI0xwL8nxHyWCQuXS5FjOvkIUJow2Rd70eyrfHd8k9uIRbWRho3w6FriwnBFZ
         jkBrQh4fVZukBgJXSPR9axtuzaW+ig5/de3JAbfdB0RLfi13qUh2L7w+mAbvIiAYqWLD
         PhgKE/dMWtivf9tDkIm857PepHdWUJOuG1YoiOS+PYWEFFfcs/w0OmR0dDvsolGXD0k2
         7OUcHn40uzSlYeANU2FptiDySnB8F/+JDPMfslZVNGsQ1hnQhYfaMV8hRpT+0T84zgd+
         ZMog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361619; x=1770966419;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=po+cGkyQwauqMh1hjbbX16QLLaNcnoHPzcdRT786Xgc=;
        b=N4+uUb73wS1qaM48N8piQMIZYv73IEosL9oFa27hSEWfN/T4YqA+hjOSI0os1DEPrX
         0wenVyvJSqHpEmiHqt+Yw8LPn4vPzUlpO3HMgQ6W7gUJg9FTgrLmVR3+686//TTK4APX
         YOJTRBZm3DavUwNw0aejRgRJYDSej+BgEFGX4uscmOV3a8GUbXBXm+simlZ/pq7yh2Ku
         Iqg1bztAXcQ9pnIdF83b/FPg6bPH/4A/e/QUvWFQIwiuO6vTjPWrcG3BLRGr6WvtQ44W
         wF66/9zmnj35oxKtkpSZVbZIuMneastIqGCXPV8iihg7XtW+xZR7EiO8AgbYSkA1GWby
         BVZw==
X-Forwarded-Encrypted: i=1; AJvYcCX0yL3khMULKFYTnFzDkqhXnWAgUuAp4tNmWF58jn+dXw4JVg2KRSeVGekD+4eAI33TERhSd1DeIg==@kvack.org
X-Gm-Message-State: AOJu0YzkHo9ddUwZl7NZhq1jN4fIHEnuQHP1+ff+RoXQn8GiWobanHyM
	52Z5ETqKyku1PwCHOlGtvKt8roCSCgYD/Nh82BqUb71PigF+BqGUx7No
X-Gm-Gg: AZuq6aIryBOImRsxDDZjASZR3j9og0lQHkXJlzTalncDqoYOTW6WrEpHL4FNuShrfbr
	JzJQaA+764SqDDmZPjqjey5huE3k/BiICWAGzCaiPBI6ozc8yQLPKBb6kpA5KyhWP124doxFmHt
	LohbEJcRbzwG5Kgxtq3R2yTlgaZFEr1gopFJ3wX23QpyUg7wAglzbJrQ3QcGyYOId/oE4/1YIvz
	Ix6493za+DIalCsdFUPjQhcM2sMobZzFfsx1I/8ONBUAXwtuvFFfmPnUXn2QJQyjbjK1rbhltAv
	OZw4P0fQlL/7NYDOdgzSSPvf0DLTvqxMMyZlMjm7chEVAgdXhwcJQXm2W49qqks52VZMtXLZ8bu
	8vYGFO0qr/kyEm1yS/EaRBlSDeqM9Goxfknx8duXnRjb312N+RLEQ0oFaAXK6OinCBINs5Hj3G7
	94wzou6nPS0g==
X-Received: by 2002:a05:7022:660f:b0:11b:baa5:f4d1 with SMTP id a92af1059eb24-12703f54339mr757958c88.6.1770361618556;
        Thu, 05 Feb 2026 23:06:58 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.06.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:06:58 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:33 -0500
Subject: [PATCH RFC 12/12] sched/isolation: Bridge isolcpus and support
 runtime tick offload init
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-12-00a711eb0c74@gmail.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D901F80005
X-Stat-Signature: n7fgswaghf4ewsyg975sxtwjc1yye59s
X-Rspam-User: 
X-HE-Tag: 1770361619-527944
X-HE-Meta: U2FsdGVkX19T6AB5D1D1iTaxy/3WyMoPdCNErLKbNKb082HwMsm17vR2gfkyIn8VjP2LWSow6sYeQ/8UJ/KF3zsHYQXE6YspDxAqRFMMywN9kXlKOay3HOOS+bdIuobSTWEknrW0lHYCAa8FhVOBD5J05HWSoYsQRvRXKfzld7mGDmkGAkFKIg3YXWpagXPnGR6rG8d7+9zfzJ8Goq4W1TvR7+zMe8mmAMTGPBlA6/08rp2Y8kYC+kDwMmY+NPh810xqoaxKgdCF76YFD0r7KfouZJ0g6ByozmbngL3zmIXsy3g7lyi9aHWf9pjXn1ZQWFPeaQ+2El/ajGcfafYEvm7J3VKcW9c2j0uZwlUN8EY23VaBvj3lKZOjNlx+pnPn397Xtbgjpj588dMMCHlkizBxgvaxU76n/NtTFYSYWzulO9C+bWnzG5Bkvv4nt46W/Uh/AzyOLa23Sn7wUx9RcIl7Q8mUUPOp5JNBXwIy6s9xMLl5YMH/EEdfbd1YFfMwmAMBX2ylhM96BWeXGq1ixJm7y+Ubg8MOEbMq3/nrUhcf9GTxuMp3M4A0yyr6IoWnqiLm69bfQkYTS/IKxOu/7TYWe6limqV2IwpYEobnU9Wih9X/1zc62CqcxgMaqN1x3zMyp+ed5Js+dY04aIVCBxOLk0aSkd+WxbOpHSoEx+Cz8S6Y7xmhDwnYajZ3ZtJvb2oF5fb0+eBT08UmtvihlXy5vrh02WZvBXC/viCK37qFPwZBlHhyK5ruj2UOua93HyQApjDdPsdLccd9ev4BqiRXhbkESCXL9xOWZ0iKqq5ShQ/i/6RNz34VlHMFiaqVns4aSo81zgptHphkDYsX80fy7doBn8QL5VjwneFRLjmwmM8i9PtHdTRYK4kzIsSL64n3ae4rQDaxEpDU1DOmf2LTdx52GQEwIZL0p/vleu5OX71suxhSUFLPyeV6d3AZ2CxwGrO0NAZuiM1NzQz
 IJxhqhpN
 Rvc9vacqnv4o+Yv2P2GCVpNA+sZ8rga7kqjXklDdmWJWhipsE3eOOJ3y8AgXLrW7vSVoDn2qQBCdtkSLfLJlNa1eBShejfDtbQU9FOv2tLIWBPt6nzrm5fkS3ZK5oTnaVMbA0ezm/O4AwgrUSdPGOjntUCA3K3TvhK+IcIuzeGmSu7ylTatySHZQx/8IGo9d0HFMceKQ8SxlkaT5koPL2gjYgPpAQEWZDwl5NycQn/1S+VrZurU0CLpLVhCEVjVEbbg+kax9Y8q3WE7yKWyxXga9zeeyTWMsVVf8cpWJFXcA+fxlO0C24GQMrN0mFTFUNmlyHa3NNlKCtj98rvuhsfDgNl+nQgT6+CrpSMx5PH+RGs6m90NSEBjZEfHLj7VFfkwie8v1gt1u/ZV9z7baSZ7WBlwvY+mSFlAJeOhMXMO9Y+uPJ6Fqmb3HUPWdl+hLFuLXCziO0/BYING3uhSclfdpMK6CmVd8TfPt/jb8+z+SDq+DTrIyCqphGVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Bridge the boot-time 'isolcpus' and 'nohz_full' parameters with the
DHEI sysfs interface. Ensure that housekeeping_init() correctly
initializes the isolation state and that subsequent sysfs updates
can take over management even if no isolation was configured at boot.

Remove __init from sched_tick_offload_init() and update it to be
safe for multiple calls. This allows DHEI to initialize tick offload
infrastructure at runtime when the first tick-isolated core is
configured.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 kernel/sched/core.c      | 5 ++++-
 kernel/sched/isolation.c | 3 +++
 kernel/sched/sched.h     | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 045f83ad261e..d155e1132d6b 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5685,8 +5685,11 @@ static void sched_tick_stop(int cpu)
 }
 #endif /* CONFIG_HOTPLUG_CPU */
 
-int __init sched_tick_offload_init(void)
+int sched_tick_offload_init(void)
 {
+	if (tick_work_cpu)
+		return 0;
+
 	tick_work_cpu = alloc_percpu(struct tick_work);
 	BUG_ON(!tick_work_cpu);
 	return 0;
diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 30798e790b9f..76c039a01fb0 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -241,6 +241,9 @@ static ssize_t housekeeping_store(struct kobject *kobject,
 	housekeeping.flags |= BIT(type);
 	static_branch_enable(&housekeeping_overridden);
 	
+	if (type == HK_TYPE_TICK || type == HK_TYPE_TIMER || type == HK_TYPE_RCU)
+		sched_tick_offload_init();
+
 	housekeeping_update_notify(type, new_mask);
 	
 	err = count;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 93fce4bbff5e..0079e7210c38 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2867,7 +2867,7 @@ extern void post_init_entity_util_avg(struct task_struct *p);
 
 #ifdef CONFIG_NO_HZ_FULL
 extern bool sched_can_stop_tick(struct rq *rq);
-extern int __init sched_tick_offload_init(void);
+extern int sched_tick_offload_init(void);
 
 /*
  * Tick may be needed by tasks in the runqueue depending on their policy and

-- 
2.51.0


