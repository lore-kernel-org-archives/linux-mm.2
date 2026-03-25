Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781ECFEA838
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:10:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF4836B009F; Wed, 25 Mar 2026 05:10:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA4A96B00A0; Wed, 25 Mar 2026 05:10:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6CAD6B00A1; Wed, 25 Mar 2026 05:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF3446B009F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:10:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6E60E8C420
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:30 +0000 (UTC)
X-FDA: 84584014620.18.EF4CA04
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf09.hostedemail.com (Postfix) with ESMTP id 65ED8140002
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZvWVNwKO;
	spf=pass (imf09.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cw+tpbsqbbsakcxSKodY3EwFB9EQzmLwAIJ3DaHGMD0=;
	b=Gh3za7bf4U/y9Xvwx3fFm196Hlvg9klb6+rh7+5hEfgx1NuswiXyPEElS5KlY28ARLF5rg
	eobSWNS0CN0jUssmdEpSTNsoAvFye3GTjnLJe458A/WbchzFeYhRoVm4Wz7RoZhOvjSZ8X
	2XwWiM1DAgcF+ejh8xHsrWByizwzWRQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZvWVNwKO;
	spf=pass (imf09.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429828; a=rsa-sha256;
	cv=none;
	b=0oT3dIG2tQckP/tNHzOqY6FNu5w+U4Hx2Qgmz36c2tiA6i1Z/BxpNg0Y7zLNVXRa6O/P9L
	tLzMaCzkGuKRVth231Blx8iCEJ29kOcXKmSGdBimQhL5KBofWq7aA6X1aR9Da7NKQlKQWu
	IBZckhIrfqJ62c6ejb6DygUrZb9fvqA=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-2b6b0500e06so7603031eec.1
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429827; x=1775034627; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cw+tpbsqbbsakcxSKodY3EwFB9EQzmLwAIJ3DaHGMD0=;
        b=ZvWVNwKOSC3Gp9QI43HluTB5vLrfQVVfsbgn56/PAW6nTtGvrNfz6g85v7lKg/xKSr
         UdF3QL7bYrInJ6iLuV7A7hCjtpxe0Malk4KAdt2mbXIGGzZwgLkjq3JTXAdj8uJLt5u+
         dYpkkrpKY03PgqIEJY2YUiiDqs01mEcEg2/hEmrK9PxwzDXHbX8M2iNkTQcxhYVJpEZI
         0zG1/CYMybadcale+FDmp4lzmtIQgLdR6rG9pt/Asnb/lf5ISe2bpwvzGhZV8P5XNTXu
         3cBc5Z+QukC/rbxjQ0+i6KDxCDDJ8iki9DcDV3apQF5kjgDLf9kUCZKAsj+Eu99pm69P
         AaGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429827; x=1775034627;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cw+tpbsqbbsakcxSKodY3EwFB9EQzmLwAIJ3DaHGMD0=;
        b=i3qM653zE1Q831pW1Q89NNm5+s+6BUlvJC05mrjrUNzdaOd03sjBV6kPvVzYsTX+eX
         k4mioDYc21n/skbYrrUs9Si2UUebZFRifKtg61x7/5pdisPmYnKL6vhDHTAAP2lmcqgD
         K/jELBw9IbLdv4SHfPyiZqsQnhutoYwo2WZIuDyRt4vNXgZQzrjmnqEGh9RV69RO4Zm2
         tIokRgFfCwNk104FR6chawYkwG2Jh6JPyu7K97qcKK5uTD2L1lPjzVSWzwPE59ekMPF0
         jg5Zh0HLxqCUTil+lYjoaa5AtUTm79GZs0+6qiiY+0SyGuDQ9qCgEkEtmNBPqHVfz4kh
         Ob4A==
X-Forwarded-Encrypted: i=1; AJvYcCU2+ryHFx5B/jcpOwIZBXvSV64AOY7J7jAFUXJ0n9nT10B38n292jv9DaaHmdYuACfEV2ifC9phCg==@kvack.org
X-Gm-Message-State: AOJu0YwRvZEh3oMeQlpo5Mqize6w+fjd653xdabXL/cJmsyoZ9nGD8Qe
	5NYxO90qIHR124BzUMYxcPnC8JwJRT+UmUPvbjqu68Qq+elxImR9Unip
X-Gm-Gg: ATEYQzzgcOYnglMrGi7uBmg5ayGM00NoMde+1elo2je9lSkxqm1/OgoW7VBZ7CoRRQq
	gh2a4WQC4jcDV5D8FCehpLOP4UDsIXXp693sGMee9Vr5Mmu8PbbOm8Fbohywb+3a4J7h2iIPvGm
	L2h2rez3I90HFsOJRyosxSZ/MMqfZ4QGql1+p4Hv4I8a0jZc31jx0GmArlA0qjKjRn0JBtQMN1k
	1cknrHXXpcC7ECAZN9ZW+6WRrszZHdUkFuQfNXLhFgPqM1pt+Ak/oVqTgl59oZEKc+6RTWNtmrT
	xJUrLlun2DGWFzISEV+4baGWnoC4NKTYN2bfofvRjZ+NioGIPTSuHPM/tjCgsgc6Jn1vS/+85sE
	h8Hl+6+j/eWA69GT8TOsgTaKYxptX2eAOrNiJvnuXADfjMGgIKzBeINdt77MeNVQv0/DAneZJWv
	WD0MIKNBszDo5tg0nU
X-Received: by 2002:a05:7300:cb0e:b0:2be:e4b:60c2 with SMTP id 5a478bee46e88-2c15d291b93mr1336228eec.5.1774429827089;
        Wed, 25 Mar 2026 02:10:27 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:10:26 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:37 +0800
Subject: [PATCH 06/15] sched/core: Dynamically update scheduler domain
 housekeeping mask
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-6-919cca23cadf@gmail.com>
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
X-Rspamd-Queue-Id: 65ED8140002
X-Stat-Signature: m34hiha5q699y64wknrxzoo6d75ddhfh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774429828-659131
X-HE-Meta: U2FsdGVkX19OizO7bfLunDkOljKftEgLbGxMb6QgHJw0f8zEO777CecYKgOuNMj95WyxcugcKVVInVlOjF0dj515W5ebTwPzvIytn4FZFziOUlf254FXgb00i3y0JsXlJnUnFv3CBJmp+rBz17blYMacdgoFWPNHAyijeE4pvrmjZ3yEPgAyT++qajnM+afOLypCRiqAKzSc4wF/XjY/ln72DMLg5o8+fr4RuU7qODarwTuhHl8tzDILZEB5ZuPmzZfRUwZxJH9RcHex7kUKW/aP+oXDRA5ZxfKD2Wh45WU7AhWX1ky/kQeA5FD+dePA0wSP+nFXZrgUUWuYJeOW0lSSArp+u5O9qYKhhbyJ3s26E1nOl+howumBETaesdeuiJh98B3am/zbXg7wJBZ5bmfjLoU23CQEq7o9zccJLlw+Y2TogJxEt4Svyy/4y5phOH50jpqQZ/KGjNRonMI7C/gueC9QoqThRqm90v3blhgj5A41WBdlijt+GKQTf+RtsbLnpwoOI11mE6WAIl366he7eAJ8I9DXzRpFY13IoyHdL7USgcUz7erYo+8YVewjgp9OQUZFpIdkwBo2PLXUQuRDq5O9bwJZ9pncYYm1fKx/89HcZ30BYYNlEiCUzS68HFLEtw6Z/yY1Qwjk46HdUzGvb4YmavZ0SBARxoEDinWarfRL/DANpBS7zpOZouT2ccD2afq1cXA4lCI/43wpK0SgixK8M10ceuFMLFGBQ+dFpm//LDwfngKUaaHjXEfhtI1A37YLnx0wnRApA6INxo3H8G5UDnYq6fSwH6w554iiemKrF2ch7k1mGhRz78rky0g3S4fnherszvlTcVfDc7yEdjFiIV5GSX35psu2WUdRioFQCwzE9ul88l5BJasCH9Ra+i2CwmEEqWXlYZG1IIO6++0S+XCEIipLAOBlozYNB3RSiu7umHMvgsO2LKyQ1RTA7gMRnDJZUcvoooC
 wkAkbBNT
 BqEVXBw7+hBZyGOEkXcsFFf/0HotEivToh+9uN1Gv1jAEoffs5xq6CEWERrVREX+miHSwLPvK7JorHR0SP2OVcPIFsu9m5bxij3JEH99t1vTJp5k2PJ0TY5UCxv1qQai9YwP2YASDy3bkY0yniRV1dDBQ30E0Won7uSqAZMrerzfxjI48tOit5WrpG2G1kE7luTrp89jDldmqpVugmzCPo6O7UCKvmqwRFeuayU4zCuxuiwtZDtQpkPA7TATGxzGnKOcwX/MLtftwb+lU6kgp/bopcLulB33+TY/W0U+Cqd1YjNxst9p0EdL0bErvhUG+L0MUXl3HT4PChaIwWmQvE2IsQ6fJBre0H1jwO34v/nKK3hom6PIkJttgnyiwke8HtxJTrxUpVgmvnsPa1ugjre1riv0MduJPd/QaA4UG9FRC82kyaBUvMyI9oIM3uOTQjqwiLQ7x7EAhkjaHnTUivBfG0EjDfQ9PaRCFJuG7zVD/nLO45M+lIsxnGNKxJx+k0HH6BM2cLZ6vwYq+X1/EXgRp0yLzV1GDmLaofDCqbpl5eJfncdJJXbdFeA==
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
at runtime via the DHEI sysfs interface.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/sched/core.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 045f83ad261e2..ddf9951f1438c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -39,6 +39,7 @@
 #include <linux/sched/nohz.h>
 #include <linux/sched/rseq_api.h>
 #include <linux/sched/rt.h>
+#include <linux/sched/topology.h>
 
 #include <linux/blkdev.h>
 #include <linux/context_tracking.h>
@@ -10832,3 +10833,25 @@ void sched_change_end(struct sched_change_ctx *ctx)
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


