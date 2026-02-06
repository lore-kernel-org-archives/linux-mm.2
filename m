Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 618D2EB28D3
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:06:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8D86B009F; Fri,  6 Feb 2026 02:06:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C861E6B00A0; Fri,  6 Feb 2026 02:06:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7EEE6B00A1; Fri,  6 Feb 2026 02:06:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A4CE26B009F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:06:16 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62B221C712
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:16 +0000 (UTC)
X-FDA: 84413147952.02.926BF42
Received: from mail-dl1-f54.google.com (mail-dl1-f54.google.com [74.125.82.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 889E940006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:06:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TByGYBX+;
	spf=pass (imf11.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770361574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cvBmHx7kwJLfpYkQiDz3mWD0AMOGml1PQig1PAVjUmk=;
	b=145d3fCcAhhIzg2837svbPX74rIgWJAfIrujpjfMIBkqPCgNGBefPn6z3p9U+FdagXnAcr
	wP0a7DD5uTplK4QayR+ecwXgQmvP0QS7YFL5N6TcfmmSF9eCrMkw0CoYrfzz7CWUjLVPFZ
	GWiGfqLc4XQEZPLJDSGPDfpEFYQ/QZc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TByGYBX+;
	spf=pass (imf11.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.54 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770361574; a=rsa-sha256;
	cv=none;
	b=I4zCE7l+3nRw6cwoTN5GESwrks3PRuOzWKB+E+ssTeYXzuR38QFClwgkbfJA9v/kBY306L
	UDZ1ZF5yNDV3m6L5pF22D7a0QgmFaMniuw7Tk8DKOiBD3ZJXUEauWf92gDwM7Xm1WaEF0C
	Q8zEiYc5O3le25y/Enw0z2pk71aHG5g=
Received: by mail-dl1-f54.google.com with SMTP id a92af1059eb24-124afd03fd1so480788c88.0
        for <linux-mm@kvack.org>; Thu, 05 Feb 2026 23:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770361573; x=1770966373; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cvBmHx7kwJLfpYkQiDz3mWD0AMOGml1PQig1PAVjUmk=;
        b=TByGYBX+BqlZZOL95M6CEQ9loCT6+DMAK+UAlrUEqZJR7AxApJbr+WZAoJFPb6/4dr
         8s3zN+Q2fjK8prIuT9TNaC2Qx/ArYpSEuLKryL5GSlwuxURb8z8ne5HJt69BlYBR26/6
         Rwv939vtEAcUEE7TU1j6J0cMzPB6CZbDr8pl8VAIP/DKqSC5rddgQlCx0Wan4VVkGhLS
         f3iFL2oYAU34Vy/6oXU5JbuZU5OwqWyLkVf8mCOVOsBYsn0Z1cCndyoKCjVAoP/86DnX
         TEV+h74mPfrNEPxq+TVQS16Zb02qH82EDQz1dUdFiWPNWO/UxOuJVrWqje3ubJa+TKR1
         u5mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770361573; x=1770966373;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=cvBmHx7kwJLfpYkQiDz3mWD0AMOGml1PQig1PAVjUmk=;
        b=qpNPYiQLTZSSrhYqQsQyLcKpcPR9P1Hl21joV9rSLjSxnOoT8RokzGNKAblP5cIgAm
         NODjWd6xGIDadTDMLXc56XWlenJSTRU8qsF+wZqyllyupvuQ0bVyfR7HbLSWOYaYdZrM
         UYndIZKYJPYDqNUEzIrHMK7L0J81ktje3Z3aprN0oecpR3pFDNxVyw2Q3fhLVPSVACFU
         HwVC8JNWz4wFWvr5AgnnFdK5mWSHDR+q2Ne1iCGBDLoq+ZE+iuceF5IissEnfiYSq0vt
         4frVqbR9sdaxLlthu3eyX1QPNhTfFgxKcjSvmUsHoweRf1QqaDOoB+V1rjyDQmV7J5NK
         p+lw==
X-Forwarded-Encrypted: i=1; AJvYcCX0YQ38vihp0en8G3khhpY6/wl3Y8Ka9Soi9FbcVUJEFv46Na+9szRMfRYiseVUh+aSneeUDxbbPg==@kvack.org
X-Gm-Message-State: AOJu0YzflCKt9+q0i26GBN+49ttP/FoSI9zcFSMiXhcLJtjrq2ixGVzJ
	onsnl/o1EFF1Z5xiw+c09p11fTtqAkOCvWDaTLtxcOndn0Bos2eFNVrz
X-Gm-Gg: AZuq6aJrlMfHAl8UNU0xTs1AAHM8rrC9AAwQyoYeebG4dcGDi/otc3kf5y9vCwkh0OG
	cXVicAD6YyMMbkpwGg5IU404S0Muj41Qb6iqc7Y75RufPftuv2tPfFzMhyZFC/IBSHn4Xwxb62L
	LWnfT11qVLVRqeyqzlqWS4+8AUyNp7J7PUyjBw4qmAHU87aK8zTv9GIqM62hW8raUkKPD4KY9YT
	MzCQHv7bAs2GQ/ZGHHHTcxhPBHIhDxh0eOUAGK73v+OK19pCV/ts2LyNyMWtpRF+Wm9sVy9hAD9
	55qufVN6sl2jFw1Ewh2xIb4RlOIEBF9XOe/tVxMyqxChXypQpIU3+u95JRoVBntnBUtncvChO/Z
	b/C5xrsMOk63/sy7NsN9W323QWjYIvSwnobLJGgQdXGia9xppTvjbCnPeHspnNQeDIxWgv234rz
	MfsyPgHPX6mw==
X-Received: by 2002:a05:7022:b81:b0:11a:e610:ee32 with SMTP id a92af1059eb24-12703ff4ba5mr818049c88.25.1770361573224;
        Thu, 05 Feb 2026 23:06:13 -0800 (PST)
Received: from [127.0.1.1] ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-127041e61b9sm1592601c88.8.2026.02.05.23.06.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 23:06:12 -0800 (PST)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Fri, 06 Feb 2026 02:04:28 -0500
Subject: [PATCH RFC 07/12] workqueue: Dynamic housekeeping mask update
 support
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260206-feature-dynamic_isolcpus_dhei-v1-7-00a711eb0c74@gmail.com>
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
X-Rspamd-Server: rspam11
X-Stat-Signature: bqg4r517rbzth439trk7yoykjqo5op3m
X-Rspam-User: 
X-Rspamd-Queue-Id: 889E940006
X-HE-Tag: 1770361574-460151
X-HE-Meta: U2FsdGVkX18pcNxU5GX2CK/R7jEgJkJXw3LY9Gy4Ux3lWu0BxbBPFokNTFncxulHLCP8Ic3Rn3/vnc9KrFwVxhFUpZbCJv7si0fqNRlJQXt/tKsD6zR6ydB1G4UGZtAGAEDP2DAVovU389gRl76nHp/DvEP9Y7K1PZCeLHo41IyfrDw2vTTit5wi1Oc++3Nnhm7cYq/9uG3cykT4C5Ma0nB/PA/H8Uyl/dS/SnDN63WJEA6d172K5bIKD+vIAVE/fFJTkIjFcO3AETU4qFgPmnwRmuAHFzM1AlB8oukyIlzV/IdCCyL9NE9NKh9R2jP4xBeNl8nHLvOWJ7G1gSwxG0o+Q090ni2CzSzc1i0b4jxUeKcImFhwTt3MC052CL71F64bWlvW5bgEiRfPSE5lQIYJ6WZDnGZvqMqqfSnSXV3Ut8HMGQhmNvABh9kuqvYI5Vt+dUALAmMcw54bcwcTjRuVHnSxxYyoP3C3VtE2IbvKEmrH3j4JfxRlU2l/xgDjm3eePadeHRj/TjL+0fM0ll3PtwG2WMXNT+QNCPY3x5rvE+FnX1EuwkhI9yuP2NVuVjkYR6Ecka2DSekUnXLuVE7g9Y7VMQ8kmWxj+9sp3o0OYTy4Ydbwp86UIywPRoltF+L+gNQ0i/N7PI1zpVSvIYySvxYDcc4/3TUjCQ0x4uvUeZo82gLW4B7WpzUVWsIIjm22PvywAUFsnJ1BnXdYv7ptGIFz8ySkcfjIq4STC84+Oste1GjOq/wnyFLF0htYSJAzL8m1SPnqZx5MZZ6kbTFgONmBRH7fOG7RzphFNP5A1kJoBm+q4vK/pW8zVN4j/zfEEufuQed44dsVaW/nwT+mXB8sfiizmSe1AgQiYmelPK+dFTFwFp9pk8gyIEk6DE+dgGpqnGx/gZcqMC7825AwkRwW3pZVD3MKsccBdjgjeIkNSzv9vXCheKlvLwQRJh0BczrX0CAor8NEl6l
 iFwBMyjG
 01YtZ1fB4quXWYVskH9JuYwYcFAzNKctWa3mHRemxyK/nt2CQ4e9nrQ5S4rEJigWIKFy1co9fk0Ey3HqaCI1QX3NM19VXrGLGIv/QByxL0JMCmx2X+eb1lSORp/yJ1oFT+PT78Wqg3c62mr/YXttDBBz404/gzCiDMdN82uE/focrhLSBBtXoYCPvdNYIbkikucURBuaJ/K4DgA7Os09wQ1cAIrxhDLDva4RlTheGwuZb664ah/ag7PE4rPAJJY8FcEC6buRTW6IMzJ0T+qnPuuCq3ZDjGuM8PN7i5AqyV2TYFNvjqrqfAfwuQlpi62GCsy9Zxmcu7h3VZuHlVqZpuG0Nt3JnQN8PvJiVyMLmf6y/ey0A2YLrZhW/AgsPu2ss1sUkpaUrDN26hnqnzvIyuzPvy85nJuSMm+6gjSjvTodKTaPjmG1Th/QWjvL+7wzR3o/rew6LdAWxgOir/i8v2ElY6Abx0GmpKI3CTtEDw1WrJPs8Mc+FIG6NOQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Workqueues use housekeeping masks (HK_TYPE_WQ and HK_TYPE_DOMAIN) to
determine the default affinity for unbound workqueues. Currently,
these masks are only applied during early boot.

Register a housekeeping notifier to dynamically update the workqueue
unbound cpumask when these housekeeping masks are changed at runtime.
This ensures that unbound workqueues are re-affined to the new
housekeeping CPUs. Also update wq_isolated_cpumask to reflect the
changes in HK_TYPE_DOMAIN.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
Signed-off-by: Qiliang Yuan <yuanql9@chinatelecom.cn>
---
 kernel/workqueue.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 253311af47c6..b8913935d5e8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7913,6 +7913,44 @@ static void __init wq_cpu_intensive_thresh_init(void)
  * executing the work items yet. Populate the worker pools with the initial
  * workers and enable future kworker creations.
  */
+static int wq_housekeeping_reconfigure(struct notifier_block *nb,
+				      unsigned long action, void *data)
+{
+	if (action == HK_UPDATE_MASK) {
+		unsigned int type = (unsigned long)data;
+
+		if (type == HK_TYPE_WQ || type == HK_TYPE_DOMAIN) {
+			cpumask_var_t cpumask;
+
+			if (!alloc_cpumask_var(&cpumask, GFP_KERNEL))
+				return NOTIFY_BAD;
+
+			cpumask_copy(cpumask, cpu_possible_mask);
+			if (!cpumask_empty(housekeeping_cpumask(HK_TYPE_WQ)))
+				cpumask_and(cpumask, cpumask, housekeeping_cpumask(HK_TYPE_WQ));
+			if (!cpumask_empty(housekeeping_cpumask(HK_TYPE_DOMAIN)))
+				cpumask_and(cpumask, cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
+
+			workqueue_set_unbound_cpumask(cpumask);
+
+			if (type == HK_TYPE_DOMAIN) {
+				apply_wqattrs_lock();
+				cpumask_andnot(wq_isolated_cpumask, cpu_possible_mask,
+						housekeeping_cpumask(HK_TYPE_DOMAIN));
+				apply_wqattrs_unlock();
+			}
+
+			free_cpumask_var(cpumask);
+		}
+	}
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block wq_housekeeping_nb = {
+	.notifier_call = wq_housekeeping_reconfigure,
+};
+
 void __init workqueue_init(void)
 {
 	struct workqueue_struct *wq;
@@ -7964,6 +8002,7 @@ void __init workqueue_init(void)
 
 	wq_online = true;
 	wq_watchdog_init();
+	housekeeping_register_notifier(&wq_housekeeping_nb);
 }
 
 /*

-- 
2.51.0


