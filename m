Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B48CEBFD0F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E6D36B0098; Mon, 13 Apr 2026 03:44:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BE326B0099; Mon, 13 Apr 2026 03:44:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3DE6B009B; Mon, 13 Apr 2026 03:44:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B52D6B0098
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:44:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F09AE140CE1
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:44:28 +0000 (UTC)
X-FDA: 84652745016.21.511A765
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf21.hostedemail.com (Postfix) with ESMTP id F019B1C0004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:44:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FWl44/XK";
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066267; a=rsa-sha256;
	cv=none;
	b=FShtKtwPV9qhE/x9fhmR3lmObbI1K0wLH3J/QLSKcgrDZElLcRKlC8/qhZoehgB8kOg72v
	hx7GSQUkMqczT7F6Z9AHVVytW0/CLtF71lE/qLt2sR921kfm9cBlRNOrzUzruZtFxEh2LY
	VYUlQr3y+M3y/IAbInT8cPMpE2T0yV0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0z+BpAj/vLJ0rBDjEb9ZBDVSgQZI0DaLWhxEyOZ7nyg=;
	b=SCUt+JKNwRwzeVOZVbVXQKU9RjI4wCXw9MLgkBZgyi8V8Hfnfx8Q12evMeYpqlvq1z7xEn
	4UnsAAiYPUGlIfyYlzinVaXCgI+Ex9m/rlzf29uq6+qRe9ei0vrvJcO2/933rl6P85Uz+e
	3uqmy+8qFvK6wz+WSx4BUPS83YGhdmQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="FWl44/XK";
	spf=pass (imf21.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-1274204434bso2277984c88.1
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066266; x=1776671066; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0z+BpAj/vLJ0rBDjEb9ZBDVSgQZI0DaLWhxEyOZ7nyg=;
        b=FWl44/XKuwfIurev/vaz163Xverdzx0aH9rROC21X87ksSOK6TJCGsDUMDJe4CPZlK
         wcLoWfVCM5lNQQc7fcOsWpxX4GwX049kyZBoxyvEWm+xh9zOkkHQhl2Xci6WPX3tXorg
         w8dOmmB3f1TOACFmsIlvtRre56KJ9sqTlb+YVF+Kkh27Z4d+2KRkWkW62bLxlYSibyr4
         arb4rdFx72EORi/VeUkncExiC93qRMbbm0aQd6Mvuuyg7zK348X7YDx5Bl/o6fRtN2vb
         CJpr6XqaE23bM95f81w6jaP/HM5oF73BzsCpZ6HwFKXJgpGxEcD/x5lw26mo42YrYO3b
         DpSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066266; x=1776671066;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0z+BpAj/vLJ0rBDjEb9ZBDVSgQZI0DaLWhxEyOZ7nyg=;
        b=eY1zfd/k5R3EhWwiYVjdL5plyGTxnSqmUDcJdtOm4vkPufefLicPlLWUOnjYGNbrvx
         DUUL9ipoayUVdQPMyPXDkCID1xM2UQ3/bw0tlb1K1M3wUDgPN+Yg8S7v10eymyU8RfIS
         So9yyXDIvwZhcOhMAEXOjaCuD8vbBshGwbk2qjrd6thm6VcUn/o3Cn3Of9Trxh0nJGyC
         T212KcyLVopBNCSa5uh/u08nQcREsTjm4muk1jPH9x9X7gfDLNaQeKVzymRwN5aLRi5F
         lI3gTNj4vwHICLuXOTeVnQf6pG5cQCqZawdtrgtDR+OqAAeE4d7lcAQzWM/nod9MHrEf
         dFOg==
X-Forwarded-Encrypted: i=1; AFNElJ9INiiQhZM+ZT8Mp2e3slL5TD6kOnCaV6V2QrObNXKDKuz3eKFif5EVYhUOxIFpyNqzACAcWvUXUg==@kvack.org
X-Gm-Message-State: AOJu0Yy8BACoSffZ2R6McqG4JdemAI6NAkrBxNTztHUB4w8zAPLX2IgQ
	PF6kK+w3JYqrb4E82JPh4/E0ZFQRS4WlAdPTaqDu36sMsdyHZWfJCombVYe8M8uI
X-Gm-Gg: AeBDieuqSf8FXTjsBH6gu9YvDxlRLP4AtTsuZ7PIDGGj+4V2vSpVvXJtdcRdCsQNbI7
	swdc2stvvYHTUBY/a2x6XY42y7eU5Ks/mBEMtw91jRAFeCefC4Y6kuiwaKf5yvoRViB2glpKaPe
	Qxj/iiJSM/W14/I3jifEjoC3W6oDW5WAym6JzqQZXNRqMzHGPjtXrEPmZIZUtHauBDJ5l48eSui
	4ViL52witKvVg6VsaWQyUYVJy/Nvctxi0UcWlauKzq8BU9MDhQLeRKxjbw6Iednb+xYNPnp+JGq
	y3vXU+WZFh6jqew4Grm0sMVHWl7vrQY2lGysIZ6WyjccbLplCSUgBRGvvt/wx3ZzJvM4HZTIV3C
	rBCN61hJrMahtHJds72P4a2Csq4xrB5AhJewAI/fNFNNflG9psILHdJlCFlzonXYG+wn2Kd5zaS
	IGdukWHFE/ZskHWKuT
X-Received: by 2002:a05:7022:4a2:b0:123:3c24:b15 with SMTP id a92af1059eb24-12c28c31ef4mr6458629c88.19.1776066265460;
        Mon, 13 Apr 2026 00:44:25 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:44:25 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:12 +0800
Subject: [PATCH v2 06/12] watchdog: Allow runtime toggle of lockup detector
 affinity
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-6-06df21caba5d@gmail.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F019B1C0004
X-Stat-Signature: pne7yofa4nh4qh3gi1eh6zfyijswkq6m
X-HE-Tag: 1776066266-595458
X-HE-Meta: U2FsdGVkX19WZPSPEhfGuaAFuLndzNlGa9AP0T7/CsJFhaf2UbQVXUT7gQKZFrdmN2r9XBIbd8aDuSEky6fxIPqsy0WhKnC+4Qo4KR3bhK3p5UZ8PE3ajKP0R7xhDkbnpnK5eCfEmyWKqlfwfT64BNzN8OFizJpPBiZm8eGAwqNoXoXRRLlabmut+c/+2f0x4wbaSZVom6jOzp3Vl198+pl+j3ewi6Nrmm5XQRDKUsSz7Lv8C15LfubB/RzYqN/o7VlICZJl6R91OrE3Lq36DHeJvdKVEs0KYU04zPEJV61obQnom48A0A/bJjwPoveR1PoN+KZ1f621a8ng+zOuvIc+t0wY2V+VuNbEEPp9tX5tkGoGtWbkMst+T0XMVi6UGFh6OnAtdEwnorLKMRk21kXGPF8S/v0aa227pYLbcrLOnhisbBOTdfraxIvpO1zWK6NRay2O3zhnGQD+DA3iQhDeN32069oTx/U7ii6mCsulTu/xOYNFWJc85znSL1RJXamspOWGrwWbOjdJIqZmATnBwFuqd78yV5YW7qSQ1gARR7pBP5ZbxaNIAiX1Z2g0Qn4mImaI2YAaVMpk5fBHYvjbezBxn1/8LUvIdOmYz2m007PNSyO6kAq/kPdifMfphdvkeDyWF/0ADdpRTjtF5u0FGZ2KG3tuJu70MiBqUWs/BGz1thBjWoiEPFaDZsTPYfxGQKVhf8J5i4IPPs1yBoT+LH6nfmkOKK3zC+GHzz/pudve+oYivkH37vJxkOvG9QVWaSqxa6jW3EMH/rZMnEtLcZof1zjhcjfWtPvSauX2OxAARATDx2SYJDNxB6TioKXbQFy7vdcLNGmrKsYAgO9b8qPJQcqZVUp45l3jXNiYo+yytxAbP5BmmfNsGXvR/TLoFxH+6In3UwrEa39PsueWfUCLsM3b0pxyvFCav0kSUCsfpPDbF57Wop9CCXACfRMTtgGpG+zZJOk8Eo3
 CpusyAQ8
 98slqEH/1wmoyDqKjgJ338z3Cr4jQhMIyCCxglBsdqRKpgOY+v6mpN7NWz6fvgypTOuKHB30SmrqxyHUGxp4F5c8S2wl85lztp6BTkxt4PFKiwUoI9rQSA25otrvET/ndwc8Vd6i6L8qTINuuXaJFvBiBK8UI0PQ0buOqOM1fnvB74jOSCuAodmjTGy1lOYCg+4IDGfRmVnMCXlAFe753GN+MZ2qRBZmRrkaoWcMSKg3bE2Ysz5YFZVSGXTe/vwuhRt16/v1AJ5aMP3tBRIQFVICGmn1Pp+VGRfAlTsF/+6SuZ4FFUHPNpc5vX/KAPCRieFuIoCpCM02T1Rr4cYep+diYfrjglG0nrJs0jTE8oz1kgaIorUc0WgLiL/zdaaFEpuKkpKi35FAFKWRRlHNtLXBRuOzga8lVeoWD560Qem+lK0Cj7dDAUHQhGgt7/g41ytsUfsqIIV1EPHzug922rZzudbcb7dpmw0kLAeNBfLnKkEDg58UOMhnjxAjWiALtmh7t9aMM5991LuT8JeKw5mXe4kpST7re8y/G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hardlockup detector threads are affined to CPUs based on the
HK_TYPE_TIMER housekeeping mask at boot. If this mask is updated at
runtime, these threads remain on their original CPUs, potentially
running on isolated cores.

Synchronize watchdog thread affinity with HK_TYPE_TIMER updates.

This ensures that hardlockup detector threads correctly follow the
dynamic housekeeping boundaries for timers.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/watchdog.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 7d675781bc917..bcd8373038126 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -26,6 +26,7 @@
 #include <linux/sysctl.h>
 #include <linux/tick.h>
 #include <linux/sys_info.h>
+#include <linux/sched/isolation.h>
 
 #include <linux/sched/clock.h>
 #include <linux/sched/debug.h>
@@ -1361,6 +1362,30 @@ static int __init lockup_detector_check(void)
 }
 late_initcall_sync(lockup_detector_check);
 
+static int watchdog_housekeeping_reconfigure(struct notifier_block *nb,
+					    unsigned long action, void *data)
+{
+	if (action == HK_UPDATE_MASK) {
+		struct housekeeping_update *upd = data;
+		unsigned int type = upd->type;
+
+		if (type == HK_TYPE_TIMER) {
+			mutex_lock(&watchdog_mutex);
+			cpumask_copy(&watchdog_cpumask,
+				     housekeeping_cpumask(HK_TYPE_TIMER));
+			cpumask_and(&watchdog_cpumask, &watchdog_cpumask, cpu_possible_mask);
+			__lockup_detector_reconfigure(false);
+			mutex_unlock(&watchdog_mutex);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block watchdog_housekeeping_nb = {
+	.notifier_call = watchdog_housekeeping_reconfigure,
+};
+
 void __init lockup_detector_init(void)
 {
 	if (tick_nohz_full_enabled())
@@ -1375,4 +1400,5 @@ void __init lockup_detector_init(void)
 		allow_lockup_detector_init_retry = true;
 
 	lockup_detector_setup();
+	housekeeping_register_notifier(&watchdog_housekeeping_nb);
 }

-- 
2.43.0


