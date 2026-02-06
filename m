Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 638AAEB28D2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95486B00A4; Fri,  6 Feb 2026 02:06:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C49486B00A5; Fri,  6 Feb 2026 02:06:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B34946B00A6; Fri,  6 Feb 2026 02:06:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A33456B00A4
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:06:24 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6F6828C537
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:24 +0000 (UTC)
X-FDA: 84413148288.30.2AABD3F
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7D7231A000A
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WwexudBi;
	spf=pass (imf19.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BERFuyeKcGtNuzKkAmOfXnG5ws1V9eOTpauK4BW51xs=;
	b=YMT82ozcaYFv7wOkcvmlX/8eF2Qz90nsFPDCVCp6c4PPb+bpK5vvZNw20X8eHYSW+8bLeY
	WNEh55/UAcqgKpuH9oC00pdwT7LEGlikMBCRqd+oz/0mM0v2gl7ns2FrfXwterV42DJyoE
	lza4U+eqMUgw64NpPR9Mz7NpLZ1HKr0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WwexudBi;
	spf=pass (imf19.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361582; a=rsa-sha256;
	cv=none;
	b=NY3FP/PFg4r+jD3YEt+K2P96JVjPUYfqRMmGBNElzp/q4c7H5Ytqjabk2ebcFBl8npgo9B
	mWPYt4vA9/dfMZRoCw5Eusqcn2uEry2WnZ778R4by+it3EHS6HDq334cWsDEoh1w1j+Z20
	XL4lE7uLczxKm5qpMfksNEvGI56fHx0=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-1248d27f2b9so2080388c88.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361581; x=1770966381; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BERFuyeKcGtNuzKkAmOfXnG5ws1V9eOTpauK4BW51xs=;
        b=WwexudBiPsrmLzuzQ18DJJonDpKCTJnevyIVXuxHFs6AYdV2S27duC3kr9P0QBGvKF
         7/MAwjFoR/ePSWdkhgqwic1IhJVe5CoaFLbED4yU4dlE9Jvju+UMZ1b+9Ik0Y3dzzuSE
         Y8hpmyfX8o8dvkJqJHV1U5fe5epUqFAMirfvrPejcsooO9DIL/EEEM1xDtdy0TmcXhBr
         50tHsb0o4odSfjy+Ig1FYTld14EFu3DwVomea/yhy/cT5bnhMNAjsE/XGRsAVT3GOOTP
         V64MxGlKxXwt5VqpNPbmSNn9MTgnLJ//1aeVZBsUQUPVaXF4OoKYmQpgf6BBIDXZ95EQ
         K5MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361581; x=1770966381;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BERFuyeKcGtNuzKkAmOfXnG5ws1V9eOTpauK4BW51xs=;
        b=iEHBE3toPs0vieyej6Ifk5vwiH1CSvIuXKtECdSUNwwWlt41y0sxWZk2JmyoZ4ObB5
         MeQvJ96ZD5epxOMzvPKsig1y1JPsZAVW1cVezIULXGr+vDMuWRa6918JDKTXCiJ7rWYI
         9DnOCU+KaAOGh6xzOOlEer8K+SFM2U2Txyd1oFov5kfko/D/TOe1bbVYNNrmkN+gczWW
         fHagbxJOqiqWUZVJIeSpjALO9W+//bYTNv1WsYpQJo2y1HCWM5lQjONZRAFwP0LcGYca
         Pe8IZdiRd7bpvIPZyGLv2SU3dkUb1Z7/9RLjSz6twRw7lE/KjtV1qLb+H0IexSB+xRQo
         pDsg==
X-Forwarded-Encrypted: i=1; AJvYcCWlDkolxJapwduyTlf9uW6BO9TRybgl0b3GY2P6p74eyuaNplwCRIxLhHfdHwgSdx9uBRyRI5iMZA==@kvack.org
X-Gm-Message-State: AOJu0YxvFplqvS7pn6jIaGUDs5kj6nfFPzj43rGcDN5rbXqO6XX6CiW0
	e/CHrFCvdxeVU08mSYUgu7StJtVlzS4N285N5ieyljBfZxnbPGV9RqFT
X-Gm-Gg: AZuq6aKiiEoCnv4rf2Nnx+msxHrxkgZNHz2GO7oMtx7CCbzgnQDWNYObIPCC2/sQJk0
	uQU2ipEANL4dElJxkqGCcm2QgZa3m+h8u0Q6P0OOgfML21QI+x6eLAGFerT+gVOJSjio3gfWBqG
	ObkgExTuRQ6tBG4jUDT4Sqf7XG2yH2tifGb8x/Eg+egYKCF4mQ7NuWAUR1nqta8ONqO7BDYuLOS
	802vGcCWlUEeA+hRseTbwPVEagB5o0/LQ1skGBU0ps6bRcswYKeT4hzxgh0bGRMGTkqdD9RfjV/
	ZA6b0AqOTrJ9v/y5moQ+yLBWZxIYN4EyDfegvwvK4KwZKxSOTXRJ+pZf8N+qodb2nb5mU4leVDM
	ePR/uGGActvrqHo/ZtJ9wuLwzASbA11qj3vQwiS16u66ucc2eArot7nQwqEgOUW6a3ISWoYcMGI
	PXkZg0Cx48ROXyRh7qzSnR
X-Received: by 2002:a05:7022:226:b0:11a:6424:f40f with SMTP id a92af1059eb24-1270401630bmr793866c88.36.1770361581202;
        Thu, 05 Feb 2026 23:06:21 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.06.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:06:20 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:29 -0500
Subject: [PATCH RFC 08/12] kcompactd: Add housekeeping notifier for dynamic
 mask update
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-8-00a711eb0c74@gmail.com>
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
X-Rspamd-Queue-Id: 7D7231A000A
X-Stat-Signature: paqbrmy7yhrauw1d834g9a9broscjsna
X-Rspam-User: 
X-HE-Tag: 1770361582-460629
X-HE-Meta: U2FsdGVkX19pxPgbJWiCDsK0g6WYJoGGrmxKH0sT2glyiOWPSR3wPYUXQQ6rViH6Ehx2qBgFOOIAzjQ1/+ifJj8XBJC3sIer8SBL86GdylLc5xVIqlSI02On8Wcp1Bqc5zH97M/4T1y7mO2pWAnEz/WAd9b4OxZJwStzfkHGVG/AM5TAZ0keCSfd0DBSu3bml4HZ1MqX5gvJ6qAXH8F0Kc00UYFoe/aAvQT+Qk5uoLJtCbkiBIOJyHL5GUgt9E3plr/ppQGp8mygfH82pvUOqBYh/d31K8bxnbuEG2zoEQFbzEU9TbODz0rSTUdJSUm+MBlxu/Xk39bRI2nNo0OnkG9gglYc+SI/6bOLmloVQmiDJSmdN7u8ri2HAus2JhgqghBk4R8zhhCWJztaJpwHUdKx5LrpiuDGrvc551qZ0myp02kHOxSZVyfDJhOEB67M9+z3zsnSI0M8aH9x3I3Rm1xXo3BVBUcZd2TMov3Aw1kf5pf9UJ6MF4YLJrXnfZg64MksGcMHxYzqfUdciUIGLZL97RBAe/kQGMg3DCWFx6O7SMp4wSPxwt23PZricWsY1smCkE+DfFj18xtY/CwfCgAbBqSs/jXoVm0Mz5CtkYGIEw0HeNHv/sD3S2cvCJ/obWGhkcldEO+Wp5ZMC3dOiEQXGGA05D5TQTjVIySYQR0VI5p2JqUcmOJBfH8kwSVhqNrKZealb9TUk1OqthBsm5t9nBs3AM8WNZa0h1jjTTQhQ62IF4rBtdpsllJYfMBs7Pc1kAj1gj+5C5o+E1yPOj+Ma7QF3/NBw5EVvmMdYUc3cS4FFoFEjHslrA7rkLunXNTTISRVjOyAwNYFfxCeAfawQd+auOpawu+7tk9c6Jze2Gl8vLRUYiDfxbk9Fp11ZNcTH15B1s1sWLssOaUvyWBVvP651x/gxP45Sb6/VXhUCjvOSk80jvcIrnqL57r6KHreDH2NBFaUuMqz1v4
 EljtYA/+
 N+kTYMhEENzcvMUf/wr70vJvYV+0KZiB+yaVdlnGkHbSnbMx6wei352vbKM5Rajfw9K6J6fBO4pT/VCmr2pfEhnjWuHzbVf6pAornQLxyAXQwg7a3I7iKe6vj4lRxoIZWgbOI7R7ABg2pgWyY4bZ/NzoTass9IQzhDzlikkvg383nn9gw9umDE4+RTn4thbj3DAwqQlcPd5apoq0akwYorTyQamS5l9XLCp68kGqLrMhVBFwRaRJWS1WC0iS8Kh+ll/keG1T/kGKoYDWcxg02V2mnYmzmbuFOWXun4gYx95EGD1RRspAG9nY6ILSEDk4Xnat6taMAAuOcZs4cU29gcv6UJMLMlkzAVxkBJnAvfjhjeNvIqsBUFBXjy716PepAbdbNcmu6Yw468QEqgzoRwurzVSRXjS31OWFX3FA0CjjHHwi3xi50/4eSsy7ghd/nhot9/sjPhO0bgWuz7ZipCQpY/F5h8cweFNqu3+Q1Vor+OBKZUUc00R1r1ufY/9gXj1+zFJ9Ui97wVJ0NXOrXrl5DTn+/KdZkn4f2AsHpOLA5x4maJjA70bVmqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kcompactd threads should respect the housekeeping mask for kthreads
(HK_TYPE_KTHREAD) to avoid running on isolated CPUs. Currently, they
are created without explicit affinity constraints beyond the node
preference.

Add housekeeping_affine() to kcompactd_run() to set initial affinity,
and register a housekeeping notifier to update kcompactd affinity
when the HK_TYPE_KTHREAD mask is changed at runtime.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 mm/compaction.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..495106d970f1 100644
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
@@ -3320,6 +3322,29 @@ static const struct ctl_table vm_compaction[] = {
 	},
 };
 
+static int kcompactd_housekeeping_reconfigure(struct notifier_block *nb,
+					     unsigned long action, void *data)
+{
+	unsigned int type = (unsigned long)data;
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
@@ -3327,6 +3352,7 @@ static int __init kcompactd_init(void)
 	for_each_node_state(nid, N_MEMORY)
 		kcompactd_run(nid);
 	register_sysctl_init("vm", vm_compaction);
+	housekeeping_register_notifier(&kcompactd_housekeeping_nb);
 	return 0;
 }
 subsys_initcall(kcompactd_init)

-- 
2.51.0


