Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E34FEA838
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AE836B00A7; Wed, 25 Mar 2026 05:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95FE16B00A9; Wed, 25 Mar 2026 05:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E966B00AA; Wed, 25 Mar 2026 05:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5A16B00A7
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:10:53 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3CA4E13BB0B
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:53 +0000 (UTC)
X-FDA: 84584015586.05.07A0A3C
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5D6EAA0008
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YGV1tPfj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0ZgSquaLuKBFQZpkdx/1H4ca5cGKSrUW15huIE1GEBI=;
	b=us2uYf7dTnf6v7WXZA1rB3fUOWESw2dZU63Wzuo8KKYTSWoOlmm+X34cvgVXV4hdXexJ5F
	cpqkH//BWMlCHZmYqQNVOPiAprGsL2rqOEKs5+K/eln7jdgFwhnTVdR5au3tPQnCtonUqg
	iJayizjjBet46gwuOZ77zGt5MR+W/1Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429851; a=rsa-sha256;
	cv=none;
	b=18in3Zx7qiMebqkoDngfSgaKGn7WYoGaL8Nqx9vVRCs9i7eYBl2csQDqqznShIO0kZBaOK
	TMHX+33T3rq7Ce17JdhR4g+goq2n7uS2gSQnWfdqnQTe6WxlTJYR/ouXOPphLcZDLfG/10
	/GukRyoCHcSsBlovPElpV5C5+AvO0DE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YGV1tPfj;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.179 as permitted sender) smtp.mailfrom=realwujing@gmail.com
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2c0fa90d47bso381453eec.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429850; x=1775034650; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ZgSquaLuKBFQZpkdx/1H4ca5cGKSrUW15huIE1GEBI=;
        b=YGV1tPfjIbxHCLZmwcJWG7nnbQdhr6K6JtZrqY0lUZ92frmn4w9T1P6BHIbj4IDVm1
         Phj9YEWWCcAu0PV2/UlyYLkl9h+XGgWwFj4z2SVEDCqK9nzlxVnj1ukGkaGRhuvy7m18
         qsydpKNe7nd0pKNlCPeTwqZVbpzkZDOasDFtRQ/lUFYGsmkpXdLVJ7oPAzZyBp0fCXDC
         Eg6cIYfRGZW4Ixl7ywINHk1i2APXtWbBY3TVPBDmcTOSvw5189YbvsvtgiByoYQToBoS
         t210lynderAZ4hzkbiBAZxOqT1bFKH9FvMV+B/s/AXTObS6xRGzr/B7rMvBXtVn4f4ZN
         ocWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429850; x=1775034650;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0ZgSquaLuKBFQZpkdx/1H4ca5cGKSrUW15huIE1GEBI=;
        b=fCeL9BeIqg+6M1rup5YzQN3RoBWJTcDUKE0kfI56mpgqTlm+sw4MUhw/EQ9KVKJUTR
         z8J5y0dOJ8sp8/2nXBKqtAusJ/ssuV6rmj0cENFEAPhaplSz9LB9FAMZ3BohnCJe2O7n
         R9OwzeMzWiE1yI2yDkfWIilMpfP47TIU5naqH9K6a/y3f6NIOGNCm/RGz8Rak8x+VCxo
         OWdMQoygiBo+ymGWjeaI53Xx2deOf3aBBvAbNfwmAZGWDf7uj0ty91jmVklaZOU3z+2g
         ZctPPjx/ycedKbYJp8GUzIAWpLXjN4TofZ5G9+/k+di916nQEwjLGoTR+LNvTn6Kay1C
         qIWw==
X-Forwarded-Encrypted: i=1; AJvYcCUjEHBo30xWEHMvdeLJi8RRNFlX8391eGLRQNmKsZyJqj2TUT1bQxSaSjT44nMUV5Vr5UR+rFVH6w==@kvack.org
X-Gm-Message-State: AOJu0YyKUaiWd+6LTXUIquDmXF9th8yJrM8IS4zxqJYcDjUUK6HTU/T5
	8zeLC/xFSlke7VAFdPSEBy2+cOxL43c+e13lfaEidFgezWSfdXeU/HBH
X-Gm-Gg: ATEYQzy46Hs+5n8SMc3c65U8Dvtqvik4EaiicFtuwocSEEvYCYYXrkckEWAHDFKcxCm
	VqGC/RCRd0WMcYGqZ0kpcvgKn91DCeLvsO3tb8/swv0CXTN+SQON+LtiJb92nynp+95+v29pIDm
	wU3Ij11ZlEMDRbvE7kJ1u+1Wuz2etlolx3WLCzNOpevceU+tyvTTSs8vo6z/geg1WeY2GXyevb3
	O7n+a3bDoNq9yDp8SEak9KZFGutjxDPalYznPkAy6Wgo7NJgLkpTUE5RNlaBtMxYtShYWiQlXyR
	ilzm4J++H+HtdN7O5+pKjEyAMf3DWAJPYgCkfjd4GURUe884lRPAR8InDBq8SIlItS0VKFK/YeS
	F9+iskpg56Ru5KiWHd+/gGSt7pcoXpfgdwe+hf4t5ZajIWytBC8zr3hSgHhDLu4uskyE1RlqKSU
	vKaAQOpIpEe3bNVrKc
X-Received: by 2002:a05:7301:9f14:b0:2c0:ac4e:1516 with SMTP id 5a478bee46e88-2c15bd3cb1cmr1301131eec.11.1774429850168;
        Wed, 25 Mar 2026 02:10:50 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:10:49 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:40 +0800
Subject: [PATCH 09/15] mm/compaction: Support dynamic housekeeping mask
 updates for kcompactd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-9-919cca23cadf@gmail.com>
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
X-Rspamd-Queue-Id: 5D6EAA0008
X-Stat-Signature: 5sqii7jugz8yct8hh1uphummnauehicr
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774429851-574462
X-HE-Meta: U2FsdGVkX1/MeakbccTKS/xQ0SFYUNw7/9SM8x8wcNznBaPhcjYejUhmdDC2Nu/oQX/6S7UWhFr49btytYRQ7APwBhskRx2Q6kW0itSPr9RQ5EQ84GFOvFunSdZ4FkfOtxsdGs5z2Wv/WazGdWj9AXocppK6aYlPw1MxVhcXjM80jl0DJOBkwHQcAatTS4YClboAAVTI0h4nU7mYGaijPc9Lb82QmTzH6C8uoVVJWUIbb0P+ZinhoyFj5nUk0P0Ih7M399Bw6Eho0xGtibnv9DXG34srno1DJD3rQhuLVdsWwp3wmxNakr8hXXZ8WtQ/yPHidt/EeZPQ4z8fTbtvh7Q+CBhIVsQ+WZp5p0T6n8U2y/eCAsF3FBc7fq7LaX238frae1X+MvaLuHiXkGCPqeP+8Mbn04GbWrEghuWaUQM4Vv7zi61QHcLPeMNOXsLUubrRzivRIKchbfQjAzdDXbyO7+F3+80UXnuDxNdO1CQi3HZS9yIGw4G76BXl9MgDAFrpaQ19p8u5K7Xh/6c9nP0vMH8ndGwjLb7WtPMQNVyiJCrq0UdEIPGPTDRPKNc7DPk3ppgY8XRsRZtY3bl6rj4VwOOa+sRJg9G1yeChz2tHdwbBXq407PH9dEHxH9B2NjY/v6t2tB5YS9NQuvj0KDIp0JNEr62djqdue33D6mGrw0u9uxQL/Im/8IRg2EzXmlSvffmrvkrHRQgEoBM7aOCtQwm4PfK4/UAhzqU7vngNCGn5gsET3F4vqphq7OzGt5RkgwUL3Sn+buGwdzlZz7Ou5E29Y8poBLQ2Y5X6L+mmghPOflMgBUT/qPxNuwN1K/VY4QaG9mpbh+cDMtkPm7ZcnNzahTm+T3ABjn34qEDbIrDkKn/vWishR5jvZhdZy7dxJ3e/5X0D+xuUuIRi9Nq6i46gMi43zVFmmY/+/gX9alIVMzNx9v0jFUi+bEH3KoFJecN42irprbJGTf4
 VaOWzhEl
 splwtazMVg63Y2qx/G2PIZ5dFhgvAAV0cEsKKDnm+g7oBCCGZKEQjwz6U3O/pDqTX6hpiu4kxJXxetG4TFg+V8NDbO87FWWLNz7D7g7ZprcU/7htra1O8rUvaS6zRjvAOzYMSF2U0xf0JJ6Lzdy4G0Vi64IfQrteihi0XmFrSM1kRnQ5WHvkXSE6tPdo5V+xSTsDdLT+wapM+RmCnyJsEHtCMKeKfunUWVtHgoqnnEhnYFvFJBBDJcWnP5qGnkWOv/2/0vWxsGRMnPoh1r2brWXUe5LYCNzgveLMy04V1kswGRPaFdmarp1jjc2gkQCP8l5dfHpVNE9cETkldKnIwtMaBNeqWYaiBAUMgZSf5i5UdoHkWApNbD0UWSIw83aASnFW0YHN5edIswOmGcTL2eK3MMzeluDLIzuFz5o1Oz/cNgrUy/nSo8fmr3TX9OvOwusEQKK951IASp4DLlbG1K8X2WDMgHNlSS3L+U9PMInre7TRpnO/iduOtdPdA0MiHVtjs7ZsLsTJn3l2pxmo+zjfSQ6CFt9NXg3bmvPec3R1l9nReRi6WO7xPeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kcompactd threads are affined to housekeeping CPUs (HK_TYPE_DOMAIN)
at boot to avoid interference with isolated workloads. Currently,
these threads do not migrate when the housekeeping boundaries are
reconfigured at runtime.

Implement a housekeeping notifier to synchronize kcompactd affinity.

This ensures that background compaction threads honor the dynamic
isolation boundaries configured via the DHEI sysfs interface.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 mm/compaction.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

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


