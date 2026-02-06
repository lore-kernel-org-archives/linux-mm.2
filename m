Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02506EB28D2
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8B66B009D; Fri,  6 Feb 2026 02:06:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67C166B009E; Fri,  6 Feb 2026 02:06:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592146B009F; Fri,  6 Feb 2026 02:06:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4A23F6B009D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:06:08 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E1EDD13BAF8
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:07 +0000 (UTC)
X-FDA: 84413147574.09.6269A32
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id EC0FE14000F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="SLc/Ts8T";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361566; a=rsa-sha256;
	cv=none;
	b=AO5pAJxqOE6p8s8m3gsOAu9xEbp7Hd+T7OOcWV21USMdCcRuwXQ9KWJzsnd7aFAyvpEuZp
	Xcs4vrcnE7+ff7RUy4AKqcAUiuC1+hi46VKfrGa2fHbee7h1WIvyl3yfuSz0LoDl9VgE8t
	FP4CJMiVRj3IXUzazb7Q9arNFqc5Yy8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="SLc/Ts8T";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=realwujing@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BX9sMLwwZBpxhdeadTLxD2L+ATZYvXDyrtJH+GXz33A=;
	b=5boxLhOzyh7kkxi/vEtL/6vUN3VKulfMRSpsuebYKAwfduBUB6cBaCiCBPEO6Ae06RR0Pa
	4dI+GkgWiOs8SJb/3ZGG3OrTm4Hb98cMWomOSOWVD5iU+lOb+s2LlN/hCJeGZtEr4/ZS0l
	YFJvpTwM/78Ub9jmyQ4EzQPvh+ts4rs=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-11f1fb91996so722194c88.1
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361565; x=1770966365; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BX9sMLwwZBpxhdeadTLxD2L+ATZYvXDyrtJH+GXz33A=;
        b=SLc/Ts8T8Rn0rG7x+DlW6GTy3qs3vrw+mXDMynJ3PTB1c1c6U+2ZHq1kzyfSy89Wit
         1MaGvdoMEoiH+ZmlmgyLDZU64UV+qTK2Yp5W7Srl17CRfa/vIM5/ECc7uFN5NbGLrW9K
         u4oiARwi+VnOeCvWCyFfholBpa/bG2vIa33W6FbCr02IR7wi5HTxyQUHrKl4lSOHX+mD
         jaTRp7588s/lznfj/rSCrpK4S9C1t5KaRJAF8mnLrnlGvHWvgKau2iK2OB5+HVVwo1ou
         ph7unyFJzCMnXrO0G0i2hJ9SndPxIqYv9Be6R0S+CaVGk7B17zmKYCQ034cTewdrRnPT
         48LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361565; x=1770966365;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=BX9sMLwwZBpxhdeadTLxD2L+ATZYvXDyrtJH+GXz33A=;
        b=U8KzeJ2u8ycEKTHIgMDmYWbJmUyzJ6NNDxocfLt9bWnyGyfX4TmmMxiy3ofeyUPI/3
         +uZo6dCqdkWrvvomrjrKg+uB+KjA2XQKDH8GZ24HjVtFfQcuTtc7Q9MsX0rgj7Rw004D
         iNxQJL+iV/MtbgVoB5T6Qckw7hnNPWTgQM/cKr+pTCbGY0STu1Gin7Iru9XqoJhR2c1i
         /M4JlUEXYiRtcG19jXALunWW+x11jnwVSCdnb/4ylP0GicbQeUaRNuYGhcHfgHJhIrP4
         2WXdZHHI16JyMnxiP5CrbQnskFX6+ao6D9Tpa4siNOmpVoTRdxtuqnCmkT54D2RlBooN
         Om+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWE9AtLHRWJJc+bD42E1gOaJQnQ4Hnf3ZDCevonylUbQ7Md2Cd6UwPCu3NWUeslJ9tHOjiy2EWAVQ==@kvack.org
X-Gm-Message-State: AOJu0YyDdFXkp2TW90xduUMBVIM25zxl106rg7lOwuy9OgbYvKbBIa2p
	Cl3dAwfcK4l6appuqr2zAD90JC2CoCu5bxUY/piDhoUspksykSiuYux2
X-Gm-Gg: AZuq6aJ9hjdeQUYlIfBgAH502VcQCpwWZy3knloOTyH9W0mE3GeCCweBwQso2T6mVZg
	yiFa8Qpgsm33ltGT1x8PTUpckz/C16C5PN5dW9x/5pxmd7YImsgeIMCqISRKdH9+yN9tWpt7Ug/
	T6lPXvDTIyix7gqma3jek2r807IDjl5rkaojHY7ETUoxsMYr+PqCo8jZsgeeksUxVpf8BN604T7
	DQP76sjOAnyPtlruN6C4pKzFZpSQDqtgNV5JaHbyiTJqiqLwK74QPT118NHAeZPbnx8sURJUgwg
	10H46P0NPVkDro9MpOb9ltIxFGHMUomjiXQ7wPn9HLvNyEO2MX2MvjHT/Bu8/mWQ0kvaBlgrbo6
	guKDyW+6NN25eVNtdNljPLzfxPuftc9C5h99/OMDQC+EljuS5SdilTgfEHBPIbNXMWgHnTWeI33
	cx8RRTpcTAmw==
X-Received: by 2002:a05:7022:619e:b0:11d:f890:6751 with SMTP id a92af1059eb24-12703fd8b47mr1055311c88.10.1770361564656;
        Thu, 05 Feb 2026 23:06:04 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:06:04 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:27 -0500
Subject: [PATCH RFC 06/12] watchdog: Allow runtime toggle of hardlockup
 detector on CPUs
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-6-00a711eb0c74@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EC0FE14000F
X-Stat-Signature: siuui8n4n5n8nbn3xons5t3iiszcxj9r
X-HE-Tag: 1770361565-773842
X-HE-Meta: U2FsdGVkX18i/jhs/QClfZyk7aO/9ktMarcif+VxHP85qpzqgU6bAavDa9HCWRzRjqu9CdYyFwXbhV4E2c4lOzUO5rr9EZjFXRY2VAQTogswU+qpTnKOBDLzK23NmZnPJJiaDt/snHQvM128kgiiHkh/mex4E3stdCsUr3WPYO/poOVrUKg+gPEyPyM9oacs2lkDugdVagCmSEBiP5k/r3UHe0flGk/2DGGOfafbM/G5he4PXj4a4NQUgZUN5uYfenAUDZIpastdluSTKqEHSpHP5xb/9wqT4BNJmLsqqeghNcoHUIlQYD74b1z32OMwLTTCLFm0LGjs7sTNiF56ooay9IDVaoV886/mpQuX32bN+qd08Tu2n7e2zHqdGq0pfP/LEeCTvDmVGOt+FDX2Mg/N4sGnLt/u7lDFv+elbneimNQnk/oRgu+pK6QiUtTcPqw/yaonmX+CVXIpKftC49YLd/AJ5PFQBk8zLRSI7nTJZnRItOoUDp3yBxEgzCTOBvaEBC5DnRlTzeXg6X9kZ3UDr28plxH08atXQFQrrjc6igF0Iqa2ZihPiwUPLDdjmRtykqENK839Ca+Fxnbyu3PM2HZRBAfKzw1Nf9fRkSVyP7N3h3bRy9WZTVncyU2gAP1f3GQJY4IV4sRHmQvnlyHJ4NF5VSGHwJPsNYvjkbayGPS84+SilJLLgmTwnZKdTgspbb+2DsYs8kupJ+MjIljEOtd3TtifUXEWhJLJwJ/0BL+1KT27kTnMQw6rrIOYzNWjQVSxuMCjSAZof4UGRMyWysJZ0ilmtDDw9leHKuIXB97iPqzrIZ0Pryd36yUKVQt7OvHl/iH9mcRivuY6NFiDo5Tw4aAaSQGepA9sIjoeUUiuA0I69qJJ7/2VqkBC3RCpoA7f6nd/xMQ5bU/+PvKYBrdBlkSgsaSfueQrsIp0q/8y2Elqi1t/G+h1Hi9XWorVWGcc0kijyDgacLs
 Gu8VPPZp
 dcsLGnezp6fRlfPbEN0YEjHZzDDS+A4EBv7lhf7RU7bKpDBDtpCf9toqljUp3bhxIpVtW5zXvez3wzWIKo4vfEfbbM+lOQ7lh6gYypkFpHOls0iu4Lfe+NmfQT7V3rbAkXvmyD/yqFW9hLkMnK9fn3y8ml3OGFHFzXlD8q1GDrSWMEiizwv1aCQ2/Ohp8hhEDic+Dpr8mXeBqBPlxqnTEOC2nfgdp63c5zRJhT7ayc7//wjelNFFtbjV/q7ZOda9rxPBEl6oQ1dg4/dNyBdsEEbIaB6mcJCE3a2F6z5Wt0KpWXCgVl0nAMMCc98y8ptxKT+z5b6WUyQN5eWQix1H+5Z9w7FIbT6rTauXZfAZJr5caSkwiRWxsi+kctcZ0vt5TM7aU+wn7C7tmNpmGAzUtKWrjNNAPeWeU2/1sMev5Zw5dv7B1SzEAZYX6rqXV6sDjBImL90ugbfmLWIHP6AAXd02k1xaaVUpecwymnQ8GwmXxuP95s4XGNo4q7KnV6QeAU5NIw/w/yS5kvmHZLlVIhNtzeISNf0LPVGnVYgBORefzDzU9EhbhAUV+1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The lockup detector (watchdog) affinity is initially set based on the
HK_TYPE_TIMER housekeeping mask. However, if this mask is updated at
runtime, the watchdog threads remain on their original CPUs.

Register a housekeeping notifier to update watchdog_cpumask and trigger
a reconfiguration via proc_watchdog_update() when the HK_TYPE_TIMER
housekeeping mask changes. This ensures that watchdog threads are
synchronized with the new isolation boundaries.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 kernel/watchdog.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index 366122f4a0f8..2922d7f93d61 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -26,6 +26,7 @@
 #include <linux/sysctl.h>
 #include <linux/tick.h>
 #include <linux/sys_info.h>
+#include <linux/sched/isolation.h>
 
 #include <linux/sched/clock.h>
 #include <linux/sched/debug.h>
@@ -1359,6 +1360,28 @@ static int __init lockup_detector_check(void)
 }
 late_initcall_sync(lockup_detector_check);
 
+static int watchdog_housekeeping_reconfigure(struct notifier_block *nb,
+					    unsigned long action, void *data)
+{
+	if (action == HK_UPDATE_MASK) {
+		unsigned int type = (unsigned long)data;
+
+		if (type == HK_TYPE_TIMER) {
+			mutex_lock(&watchdog_mutex);
+			cpumask_copy(&watchdog_cpumask,
+				     housekeeping_cpumask(HK_TYPE_TIMER));
+			proc_watchdog_update(false);
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
@@ -1373,4 +1396,5 @@ void __init lockup_detector_init(void)
 		allow_lockup_detector_init_retry = true;
 
 	lockup_detector_setup();
+	housekeeping_register_notifier(&watchdog_housekeeping_nb);
 }

-- 
2.51.0


