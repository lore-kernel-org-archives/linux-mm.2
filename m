Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62933FEA838
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 09:10:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C47196B00A5; Wed, 25 Mar 2026 05:10:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF75E6B00A7; Wed, 25 Mar 2026 05:10:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE6126B00A8; Wed, 25 Mar 2026 05:10:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AA716B00A5
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 05:10:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 42109C2A9A
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:46 +0000 (UTC)
X-FDA: 84584015292.12.D5E57FE
Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	by imf02.hostedemail.com (Postfix) with ESMTP id 525E280003
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 09:10:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eWGKB6b9;
	spf=pass (imf02.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774429844;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AVaXBsXyrGbsFUqtfIJ4CxUQ0g0L6QfqD42wgzMQLJ4=;
	b=pTogNJBLxspU30A8Q0pQFlQ+EdDkjz19dvH5rEBSyPsWuRk8nvtb2+cUCTIuivAbLHbr3S
	WnVpXFxSK9YZysMNqWiciY2zZD2i3rg7iHs2gd/RS1eylO11HaNVKv/uAwNqXbaGdsNJKr
	CSpMQ9FMCVJTuSnFKI+vCxPwbtxhm8c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eWGKB6b9;
	spf=pass (imf02.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.170 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774429844; a=rsa-sha256;
	cv=none;
	b=brUvDr6zI0CVHWX1bHCoGNT6hMtnEOc9KS+6OIcjzUPyY+gAFD5tvWpBKlrUuDyX2EbAs3
	R173TEHCWp6wxOKebqD826HZ4HlRobt85CjwR1R7+iwzh7LWbJHDsH2ZHFKAPJv7OxjXsm
	Q4kTAyrVqCZm9kuTlGXAfYvjqE8aP5A=
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-2c1632faeb9so621094eec.0
        for <linux-mm@kvack.org>; Wed, 25 Mar 2026 02:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774429843; x=1775034643; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AVaXBsXyrGbsFUqtfIJ4CxUQ0g0L6QfqD42wgzMQLJ4=;
        b=eWGKB6b9Wc6/N+4htQCoelLnGIaMWmI8IiK5mduii5OJvqnS3ShJLPnsTbO76bhMo2
         w7cwdJNQZpm9ujK77iReB2PPya1fkJIF9iYgh8gSNWceIY8EktWUnchlG8Jw7nby8OEP
         5qHlSOr+P+etOFCeZNzdQNmecK0dRZVnWspolacqZWHyGtglp7l9jd/EatO0OlEpVJWZ
         mltgEG6KEgSOWzkE1aBWaLczDzHAcKNf8v0ShJpyg1VOoJ705fILZ1B4OYs7gz6wlVNc
         U2SItLNn52cGEE7OQ2ix/3Vks47MxSIdaZYvmRIDqhZv2Vlfk9A5dGhafzedBZjXg/i0
         mY5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774429843; x=1775034643;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=AVaXBsXyrGbsFUqtfIJ4CxUQ0g0L6QfqD42wgzMQLJ4=;
        b=ZDERiF3ZW63P1uhWmKEY45YbNjC04YzZ6jXprzJG/Je5RKzFNcb63WvhhX7+fXdr9f
         ZL+hzWu5HdPaOOjBsaarhx+ynDgUacZ5VLKnM7TZlVFmzPVJvf/3VlaUHW9SXaZB9c++
         533BURhcuGi+O7FLjSg7M7c+oDr/ynA0INUbJH35w7tx1seRRT/on4h6oclDt/DY/DJ6
         02ZzzK9VZSsWe67y7DuwQWIcU4seoPM32iZU4MQ3uSkKr6n4JCz92imPJF9QXoReS+4l
         J6fKNqchKLXwbodgDPur+CNj3SgR0P1mR2x3zfPnGFxJK2zBQNceQmBD7523xOSaq8ZQ
         z3RA==
X-Forwarded-Encrypted: i=1; AJvYcCWWGL8tRevvdr74VElsFn5a8fC5d9zU+C3TxCNuA+vh9tcz1fNmO/x8SIs5h5s+Aazk9OjYzsJ4Hw==@kvack.org
X-Gm-Message-State: AOJu0YzUislm5bp0zea/VBQbSvHk1uwJdeXl0S4igBXNsuXgX4hnjgJn
	qJRAGfFp3RMa0ILMT3dCv8KaYUpppdyjsJ+gEsuO4jiPtoxO5bu3WCYw
X-Gm-Gg: ATEYQzz2JP8QVqQxgu7MQORYjIFjYH/6K4m1OodKG1ZdvcgrmrFJ3lV+kDlMrcDROm0
	qVwhyH6ZTWZfAmngMd1mjzBaCJhgmOG4VGQYgIgzNxiDLCWZKK8f69LlCGT1K8A2TIJVudSKJAv
	2xaWVUyxGnXegeLWCagLVavit0G4YCDLo0A/nspDLwF7qAbDvUYoPZgqB5kqahQ8U4NHxx81n0m
	NvF0FfVy9Hd6Z9+hx9OaZMjeH/vyXj1SAzgKg3T15mSdvA3PlVdTLnOYFWlPTPnyA7huZ9Q52kF
	GIqN3Wf//tX0nRLmOM+y3TMoTw9kT+PGxSLeWqC4clGo/MtKqh6ib4IdTTXoTjaBwJdsNN5SdvY
	P21ru3byzFRuVchmjsftl7oAUXFyusr6WwRGAuYloSHFC9bN04wPQEb4ejCFgtV2PmbsyPJlJ58
	fLsjmkgYXlENM8QP2h
X-Received: by 2002:a05:7301:e0a:b0:2be:9886:d4cc with SMTP id 5a478bee46e88-2c15d31dab0mr1366051eec.3.1774429843054;
        Wed, 25 Mar 2026 02:10:43 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c159e25dc7sm2786389eec.27.2026.03.25.02.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2026 02:10:42 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Wed, 25 Mar 2026 17:09:39 +0800
Subject: [PATCH 08/15] workqueue: Support dynamic housekeeping mask updates
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260325-dhei-v12-final-v1-8-919cca23cadf@gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 525E280003
X-Stat-Signature: 6q58rhknrpwkdn1nminxt8zb5yt3k7fw
X-Rspam-User: 
X-HE-Tag: 1774429844-12360
X-HE-Meta: U2FsdGVkX1+8Dh92bE3fQ76a3Jeho/yjFO4Dr/iOuccxitYqijr3eGe1AQqSkOYUmoi4cv2VcKaOK/70Huvvyg8bv9redANAoz3bX8YoNLnrznhN8VQot4854gQUPE2b5TADLqMDLuD/7odcBAjkcswYrqG+cD1oZknG5D2jyuHq70RTy60iKp9MTrQcseFhZ4y2YmCIptJdYIRHJGxB1A2nusllujBcLISA+Vo7JPmtYk+F4nig+MEiLkCAGes+p64S2uxTZJpeSrimwP03ebTcWcBYXNSZNYYEgZkyGa7uqsJzTDcGFUQON5HXAKCvIHpvId4RPpASqk5DoUHEMZGMkgxY42WSyIgfrlHV/aC7WaQfVgwNrtV9+QAc8AkUbZ7nAkqL6zTYBsi8BMiEkOlAFv3+mm3qJ9otyznHwJOP5QczNjjrFsHEJUs55aE1U0TC+lsEW2NKWsxEoRpQgV7p/UrfdQApmB4D8YsMHxSLaNHmPobQTDJxEDia5PgyAB8O9N6s+hnVUPgAQzm31qPqda/F7irImDhHcsWzoRe0HhWXqX2vWvNlzb2hb4zL6SXk6vBxZfLxinzuKlBrxY0ZFwCZZwpi+WoNOeJewioYUtkfPrTReoVKmZdZLZVSkxrSK10uUMK8jgpq5k+feHz5Ha0Z6ABtWUMqXCyEnXj71N96oov5xbm/5a38UAeaJjqWezMFDpw1ODN+AbuUmZCHbk3ybhCaO1iBU+EHGf8FbA+AKiy4ZDVMSnW8bWL6s+CKtF2mrs17hIaEkKe6tSuCZU6H1YlyK4S0uMXfnNM7uQjt/6xaE23nEUAhVb344dpldHhD8d0BaT+D4KkFsXz0EXdEYYB0TtLA5SV0QZcZhR3SZP0I530Oo4bmr3MK/EvHe3uH03Lo1bePibLGU3MnDSwE0VqOrOS1gLiZrwg3oDuqGvK1JPiHq4/c5HnZzYdplDoDdAEnm8QY1PQ
 cY3qoTuJ
 bE0r1DnpnUOTIbBI5A3hIAfm7UUOyanc8vwkztFqtQ7nzRV0t0960VBK6ApNenlq2Yz7FwcT8HbwQ4/FYBiTj7c0ChWQq0qGU2s619mKiZ6DHkaL+Q8pmP4OBNhXN4xe9/JpXavsvM1/ddecGmR59+MdK0YocdlNrAey61dQhMlNDctAcF/Ka3+EEknDl+k0c32fEMMrsbbSknry4puI+I0eTzyu5lheFjMBkEVX9ay+W2kDN7mLuljIrxUPCuF62M06/nWRYG6EMWVoQGKgp38eMInQ819Ivd+GK3O0r2CdXxJiruG+lVMRA/C8TXt4M9Xxc8bJBvQeIVOZG6DgFTFjkDNS7MpIL37l9sX8EpZT6oB1YxbbmWQzpwvjeB8hzCJOjXmZk3HTKIrZo5VkcAC9xA3H11NXHEiSWo6BDE+THyUtVYPS2sh0cL5ETsTuXg26gXr/UY5+wSPRdNrOJSKUe2w758hZqYLd0PCJ0I7GfGCnbLWpLwngDRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Unbound workqueues use HK_TYPE_WQ and HK_TYPE_DOMAIN to determine
their default CPU affinity. These boundaries are currently static and
only enforced during early boot.

Implement a housekeeping notifier to update unbound workqueue affinity.

This enables unbound workqueue tasks to respect dynamic isolation
boundaries at runtime.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/workqueue.c | 42 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 42 insertions(+)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 253311af47c6d..ef3ef7e3fe81f 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7904,6 +7904,47 @@ static void __init wq_cpu_intensive_thresh_init(void)
 	wq_cpu_intensive_thresh_us = thresh;
 }
 
+static int wq_housekeeping_reconfigure(struct notifier_block *nb,
+				     unsigned long action, void *data)
+{
+	if (action == HK_UPDATE_MASK) {
+		struct housekeeping_update *upd = data;
+		unsigned int type = upd->type;
+
+		if (type == HK_TYPE_WQ || type == HK_TYPE_DOMAIN) {
+			cpumask_var_t cpumask;
+
+			if (!alloc_cpumask_var(&cpumask, GFP_KERNEL)) {
+				pr_warn("workqueue: failed to allocate cpumask for housekeeping update\n");
+				return NOTIFY_BAD;
+			}
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
 /**
  * workqueue_init - bring workqueue subsystem fully online
  *
@@ -7964,6 +8005,7 @@ void __init workqueue_init(void)
 
 	wq_online = true;
 	wq_watchdog_init();
+	housekeeping_register_notifier(&wq_housekeeping_nb);
 }
 
 /*

-- 
2.43.0


