Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 545DDEBFD10
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:44:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDA626B0099; Mon, 13 Apr 2026 03:44:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB2A16B00A0; Mon, 13 Apr 2026 03:44:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A79BF6B009E; Mon, 13 Apr 2026 03:44:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 98DAE6B0099
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:44:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5F6C4E3D80
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:44:39 +0000 (UTC)
X-FDA: 84652745478.29.207D2A8
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id 83CD81C0002
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:44:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=buUScY3Y;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWLi6Bh6Nz5J4yZhvIk8yyG7xG2dO9eEtzSyvnHXfpA=;
	b=PDMa4vlbszTxKYgJ3Q3YSuakHj+ulYoW6z6yEKQpX+de4FzdnbcydjIoskDWTWbI1mvM0P
	iH7OZI75m0EO0LjN8ixrEdA9VTbj/h28GavN6kkjLNpiZQHrBHUiKNNiZQnJ/niW7htcrO
	+dEpYjgUCjPUX8AU4G3txjVJa5NhhtA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=buUScY3Y;
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066277; a=rsa-sha256;
	cv=none;
	b=M0P6A//HE8vSCbsaWBFofMUAzjFvkB+VGlVBO3XY4xZsq3mmp7+FFk1CO7qSsVGOEqgfxs
	3isVHJvL0LByo/dmAxsIuPU2G4bPgg9v8lWA04+0GHA3VCMGJfh8gAkGKJM02u1mlhmJvR
	R9T6udsmK0I7H7Pf2hJDnUCl2AB326w=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-1271257ae53so11458168c88.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066276; x=1776671076; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gWLi6Bh6Nz5J4yZhvIk8yyG7xG2dO9eEtzSyvnHXfpA=;
        b=buUScY3YnvnI0zw83XItlKYdX7hhbEI2tP6x9ZNm/iX9zvsRpfT5vrD4lbMvqysfne
         Y27iEpKwf4u3VpXQbaQTDEHx4P3LxdF3utAYDPf6PLJJpFGKrtI4wiyZqnYYjQUV8O7l
         Dfba4AMsK3jntJKf7c+u3eQbakNszMu4u+Gup9AmG9hA5NYcyBXJmFO+xpi+DFn5DqqZ
         R4QGmq8IsIAHTYTu2lGunqXNS+gCiz5VjfnRQIc9GoKrLA/c4JlJFSs6GwyzRIMgDWwT
         j5/TftCp5zlHXwUhL1n8Jw/hhHAPx+cHB3mOf4mxTxK0rUt034QXEb8zZ1j/tNv4Emgb
         9e3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066276; x=1776671076;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=gWLi6Bh6Nz5J4yZhvIk8yyG7xG2dO9eEtzSyvnHXfpA=;
        b=ZjtPXNB5H+PimLsTaD98a2WfDOcYw0GxY7zYieD50ULg6iIrW3GTL6NVsvkBzGSSgu
         aM2hUC2tAJ7Un/sJFzbrvH71VFNzNH0YrbOm3F8yjGZiQw8kbynRoMWO4t78CqTr8dBA
         0MKKIoJt0FtqTBNAu3Epo5dlcWlfZsl8k4/Ul9H+JRdzGUmkSJNlMiWaTv8DcbOubm+v
         ssLeQsbC+x7iRQJhsSWV6yAnp6vmL3bA3km3e48R+DhU1sY9YJSUszPtVa1EjgYlt9kq
         w1RotcGhVztWRFUBGcX3Q8QuEBU5vShQTuAheymTi40jyAhc4lV0wKi6rATGu2gLoMqY
         wEzQ==
X-Forwarded-Encrypted: i=1; AFNElJ+Q+XnOTErRuGTI0tZ3hpuYpqrAVRvK3O0W0zhvmRx5vVy/f+RV95O+/z4tCn4nYqMtnww9rFGBLQ==@kvack.org
X-Gm-Message-State: AOJu0YyNLyWRNrjZz0zsbdTcPrJuoyinXbDAB9jPba563uPYw1ondIZ+
	B0r7TnsmAANlnqgrDVQgarVbVI5zR04M+TyKkfJYOWroSxh28EtnBdmZvZxcgICC
X-Gm-Gg: AeBDietokfmTzZrgb0cfUqSsdh3tAGXv8LNBLeItRFmUoGi/eJM3E1XYBHzoo7IIQ9G
	rfTrY7A+SmOI2mvMFVE9E6GASupJ0diP+B1U9w+R/hG+RoGbhkEIH+zGoUgGKdcMSJKJ+FlDbaR
	R6GmSEQo5zWv6mMqPmZrARBeG4WDNUJ0iSVKz2dKtzATnomwQgfRT1p3ff6nzgNUrAOH4gOodaX
	8zOK8HqaONh1plmeZYHilSYbq6TjPwrn46zRvCSNNwgS2T1GYtQJEU9/pR3zmSOp8N4dRMPozic
	LSkCrXFxjKt+TXVazR2I5wMK1tx/r6OmwYdGJDEJ36qiZQ9JGD+DXC0duhHOaIarwF1eBTItTI1
	wbDfqBz/5u1Q/mz2Smh8Y2b7bzeaBixtHFbueqhsSZ0gXxfAlXn+ykUA2O+9PBXB30saDhR1Py0
	plVlpf9444ABOz+avj
X-Received: by 2002:a05:7022:6725:b0:128:d23d:81a7 with SMTP id a92af1059eb24-12c34e68fe3mr6219069c88.6.1776066276106;
        Mon, 13 Apr 2026 00:44:36 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.44.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:44:35 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:13 +0800
Subject: [PATCH v2 07/12] sched/core: Dynamically update scheduler domain
 housekeeping mask
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-7-06df21caba5d@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 83CD81C0002
X-Stat-Signature: 17p7j5fexemn9upceook4sdy5urrupc9
X-Rspamd-Server: rspam06
X-HE-Tag: 1776066277-371691
X-HE-Meta: U2FsdGVkX1+BP38uj3ntCEHhtfPezWh75zEGIyFAFp1nsFYuWMJGz62PQA6bZ8/L50zCeglZF8i/82I2qwMEoSaUwrM93b9XF/KbEoc5Z3f/9e2im85Jjku07zKdBCzKcYWCsBiSZtdkV4fxa+MW1Ay0KwG+DBjZhfJZKfVBSBbh8RhL3YISTY1Gttmn3EQDizOuvOOrE317JtQMwXbgPyfixHFy/C85QqBc+gu1+GHzemzXCc9zPOHeW4l0gTxi70MDOFOkWvzzZfqlP3sBy19HYFSuxpMmgx4xb31jSKZGNg3WvmrG5zMaYWE+QzD/hGG+IqwZ8SY/byn/qJxDHifYkm2ER7OT1lOjrPP1kNdMhX3LwQsO3taCbT1kF8WDwVSJ6XqR1WZdksFWnP1UwK4QRS3DEnU2FxH/qi7FE1usOyPADJzQKtgGSobE3r/xZW/rp2w/LBd7bkmxgXsMM/JeUtUY778ucuQpKprpYfWirAsG/+FWS4fhlXgOoKI7VZEF2Qb5jt7T8BEJ9CUDjwtCF+HTSTT+ScHgq7vfaK7qvhP7lNgUqDiqttgrq85ZIOvFiXl1erVEo6UXcJrhxHt5KWYZpmMj0cx/Xok/PvU7ZTyeh/pnpaimbTi+HR16UFq2QEYqLClv6u22R+Mkov0zmX11KFtZuQ00XdkntEsGq3OdJpV5frEauX3hnI5pS/iwRAQv2mmCg5Swld4mVH9LAaXDRg9g8A1hMG+fruWH0i4D7rvsFJAjn18Z/l45sNSGrclVy6idrVDWDMsvBLro1rvEB1ditAkSk4c69E8NzfAbdw8hyxasMeZxvOT22OaIcVFSwsMme2U+9is8q6M3Visv+J+tR8Ps71wo5/ui9m4F76bIFCiV41nykuJSFYCCboQCXJqa/SdukmmmtP76br6Ym0lBT4tJW0wv0+yo67qIBg6GpVVBeDCSph1NwE1bMGbqr06poh1u/jG
 1dCXA/Vj
 k5RREzqgEb/J+2Nz6VaAEgczKGO8gs6XDmcUEDiF4J6HJ0tBEFK6ZFmmacFMDmS9YvvZI6a6XdLQrtJvKAFJ8FhxZSlPbzSnxRFu6q12b0Zte2M4f7EihQAmkI2ASYX/o4t47w9UiCtrChQ429z1HUFFpDGMgQ+LaFcw6PSyYOB4kojXE47jUySHwqp5II4dYM/jX9jPomDq3X/iu9PDLjMFxTHu4Yopt/cJ0tXXUiETW0JDyL82M4rzvBM4zCvg1oBN9P7scE0NMTN1+XCl3/zVSRu6FswM+7SDJ299LNMKBPLHn+QPixoPBxvRdjCO76In/IIlrZfewTcGWnJSi1AH35FE+PWM6HNI1MbFw4ifbPnwSoJK+oyYM3iFD3FyA9kcjK+X1Ji1U0B/pnCM1Kw8nM/ry+T8DfxLvUJG+FJUPhSYcF2PtTSP6pQoEN5wCxMXLySups0Oi2tgIA1sP0ssdG8oS7eK9Tk8IuhptLzdrSf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Scheduler domains rely on HK_TYPE_DOMAIN to identify which CPUs are
isolated from general load balancing. Currently, these boundaries are
static and determined only during boot-time domain initialization.

Trigger a scheduler domain rebuild when the HK_TYPE_DOMAIN mask changes.

This ensures that scheduler isolation boundaries can be reconfigured
at runtime via the DHEI sysfs or cpuset interface.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/sched/core.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 496dff740dcaf..b71c433bbc420 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -39,6 +39,7 @@
 #include <linux/sched/nohz.h>
 #include <linux/sched/rseq_api.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/topology.h>
 
 #include <linux/blkdev.h>
 #include <linux/context_tracking.h>
@@ -10959,3 +10960,25 @@ void sched_change_end(struct sched_change_ctx *ctx)
 		p->sched_class->prio_changed(rq, p, ctx->prio);
 	}
 }
+
+static int sched_housekeeping_update(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	struct housekeeping_update *update = data;
+
+	if (action == HK_UPDATE_MASK && update->type == HK_TYPE_DOMAIN)
+		rebuild_sched_domains();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block sched_housekeeping_nb = {
+	.notifier_call = sched_housekeeping_update,
+};
+
+static int __init sched_housekeeping_init(void)
+{
+	housekeeping_register_notifier(&sched_housekeeping_nb);
+	return 0;
+}
+late_initcall(sched_housekeeping_init);

-- 
2.43.0


