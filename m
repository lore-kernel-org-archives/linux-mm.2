Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80007EBFD0F
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 07:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E985F6B0095; Mon, 13 Apr 2026 03:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E70FB6B0096; Mon, 13 Apr 2026 03:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5F926B0098; Mon, 13 Apr 2026 03:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6B186B0095
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 03:44:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91AB68CE15
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:44:18 +0000 (UTC)
X-FDA: 84652744596.17.684F850
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9F8C940013
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:44:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HmWifGk7;
	spf=pass (imf07.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776066256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EF3HsX1PiWlQS1SWUgySjoqh/zlAKHa5r5Dv0SN822Y=;
	b=6VJ15HLimzrVL75LRHm1wq8l8eYlGXs6+tCQdr48XO/5Ed98wuK6EvqaXaLjf0zG08nLhu
	VAGII6a9h/yg+r7EFkLDPx6ObEvJfbY7Zq/RnLbWyDSMjlJEy5WMTdeJ+6Y/u5T1YJeP27
	fQC0OQML+kgJboYVOT/Ct+h0+67Tudo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HmWifGk7;
	spf=pass (imf07.hostedemail.com: domain of realwujing@gmail.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=realwujing@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776066256; a=rsa-sha256;
	cv=none;
	b=VGRsIBs9iGq9Z46ixk3hb1cEh/Sne4sWwJ8dOxFjNHkSBZNcfZu4gtI+SCK8tht4a52Myc
	ywTWy8LaP6ISm+dKnbtH3Ca2+RIjHBnYm+G89IZiKJrJ7h78+cVIm66ftkOdeenGVnJ7mq
	U5v6exll3ynmaxN2seah9oRjtCOqRxg=
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12c20010f10so10474438c88.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 00:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776066255; x=1776671055; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EF3HsX1PiWlQS1SWUgySjoqh/zlAKHa5r5Dv0SN822Y=;
        b=HmWifGk7SJhjMwLSNbRQzjvAWrTyKq32H1dR5sxjIaP9ORAtYStEJQC2FJNiajUzwS
         yOwQA7kI5Dn7HZXrZuIdEPoVZFhQYBe23tzc8dzJKhLU914wBT6ny4yIwkrMg+cYe5F1
         oJEXXrNhelmCBtWeb1mPSMl9pzk691seKUg2Bj3ST+T0ePwe688LogRulO/p9l34vjr2
         zn0c05Mvd6OxLM7A9kWa0i7y+41eZqdGU1cW9lnNy29zyv8uYCUqid487S2jp+kKc9qi
         u1tQo4NH7X407QiMsPtNqJYFV4gRVGsgkVHJelLYFUmCRjNA/Q1Gyzyz4OAogpuh19Bs
         FKxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776066255; x=1776671055;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=EF3HsX1PiWlQS1SWUgySjoqh/zlAKHa5r5Dv0SN822Y=;
        b=X5IwrwYxSHL6t3BcCSl4DibSa4pBloFDkA5ghxJzfXQe/dg3+KwAgOzXhmIjWFrGAc
         g6M2gW/EMBlZYewqsov2SlRQ/Gt0IODFSTqdGuIeTQ1oaoyauznLcjOxAMJGSiQ+HfHs
         ojplHnTdp/jNowsxKy6aU51NTKis1OmDPdDdN7etOJXW08IpwW/LYCRIHzTQeMWp3k/g
         FhbejypdOuSW/u4B3cpM49T0Tw4l8X/Bb3vN6Y7OgnmD0tV8iMgwVQlA0gnwZVvL+0ku
         7EwGf9wUD5ZyjLXD+RhdHjgCcrHkm17QRw9dvZeEP4Wh/iBDBRDEKemDY8Q/YqsiR0Ek
         30tw==
X-Forwarded-Encrypted: i=1; AFNElJ9CrX8qDYBmczPg0wjkWVrL/N7jx1ENepLhkrYV0WV+/xsrMCnN+SBcR0x2ZzI9U3P15MaqbSfVyg==@kvack.org
X-Gm-Message-State: AOJu0YxoWcd0UayFC6arIp70DiD3sdJ0lno3OxWLrChg//IzUnqU0hjG
	WN8sKdCC3ie6XP4eUmWDeGKoskRfHtUvpeR+pW+Hqo1joN9UXPnsY8q8g5LbByau
X-Gm-Gg: AeBDieu89V4rzH5fb0oluZmDhPQoOUfEx2fEK/7ezHseqXrjcttQNOVT53Rl4fU/HE+
	1CahEuqJqyvdloLF8mqFZSQ+F0Kj5htD8OW42R2buevdkihQ3KF6bJzIogy+QRNqd9FBaSu2urh
	zQoZ0VpwvqAzqVQudLfq3a0Z90/QgqDQ8OzMbytzxWDj89uoNGE1yQh4ZV5jetkMR7XNP7IQ/uo
	WgDNQ9An7T20UZyj3MuQlEkNJPhdb2I5mEYcEWjZy4vAmihnY5v3cLu7lpySqGUyb/TeJk4tpQX
	OLnYgLPCT6QK2c/jKGgt6kdLLiAO+7xdaROUBGsuhOhrOinE+Acq3Ujp58YrNqc7qlyLiqtzBAC
	Dt1JaVm++8OpfnWdMMbX6Ed+nsqIpOCEeIQNClozj386pDERo93UNvJv11txoN2zTiqlGwSqOKH
	iWVaRoOySHsHztdkcaHcYwxiSnhl8=
X-Received: by 2002:a05:7022:47:b0:128:d4be:7428 with SMTP id a92af1059eb24-12c34edee4bmr7057521c88.19.1776066255198;
        Mon, 13 Apr 2026 00:44:15 -0700 (PDT)
Received: from wujing. ([74.48.213.230])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12c347fa2c9sm12884610c88.15.2026.04.13.00.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2026 00:44:14 -0700 (PDT)
From: Qiliang Yuan <realwujing@gmail.com>
Date: Mon, 13 Apr 2026 15:43:11 +0800
Subject: [PATCH v2 05/12] genirq: Support dynamic migration for managed
 interrupts
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-wujing-dhm-v2-5-06df21caba5d@gmail.com>
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
X-Stat-Signature: qdqko5wuzaf7jhdb63d1ak961uyzqpen
X-Rspamd-Queue-Id: 9F8C940013
X-Rspamd-Server: rspam09
X-HE-Tag: 1776066256-480022
X-HE-Meta: U2FsdGVkX191fZ46Y0Wo+uX5gWV1vJNujgcrADJF93waUb7ByrRUWTiD0ut99YwNUGd4Wv0CSVAhoF92YOm7OGApcOb96JB7XPbMVlMlc0yzexOUYTGcE0Wy0PnoRO7wIFHGpN08FgTktjaUkaYwj98iOSzZ+hMmfnwomvFdS+dDzarz89aUqesnxkOFtbc55OFkMGhaImLG12pSW1dydY5B8qybx+kGNh/G+5ar8CHNqSu4Uz8ynSImTh9E45DXhRsvJ2IqU9Va+ydvwm7pTL4jTU4IHFiT4mLbq9KWNRDi/I87p++unHR4ZANmpET3FW1HKt0EucvEAeMp6baDCGwqPbITBgugHwGpzrIuYN2yR6btmnaDyZvjIa7G4RCAYqBbZpO9hGVOtj/hqXx/HhFbFOotALwDnzfUQsMowlv0UGL43IW7TLz3bVENrVU1dJuOcw5vX57Vg/gRpR5UR+DkNjHPY/j/Lbgnx+Dq1Uq3GqCJyaccVTRwxnvSHyr/hcPxF+M5GCC7p1hM6EzNNZ1wZpYGqezRvc9F/UjWoDUg2L79KjrnJUvZA8c7iJ9j9B6ho0wjDFl0c/ZR6x68CMEmoS3Vru8PIs3cyyvJ35egUmoWYl3GyEsHy6uF0wPQDqHHPcaxNwGcf+3j5uuxskhk6wDsOtZZ0stor8QDq11x74AxkzDazJv01r8stybCVthIuVVvBWBuyEJJi3rg7+1vbjERytiXuBxHLfFFSA7nFZjWcB8z4NAaDT//ks3NeGUO6/YGuZ0pg9dQT1b6Z14ltPQmNE7otcvte0QLRwkjldFCzZ5gQmR2DSqnfs63Cnaxmi1gdmHlBVbDcvodKglNpxd3mv83CDoVXADxJe/iOJ53nd0PcathWvfEu/6caAyDqCGxXClY+B4bMXfzorB+ezwMyu5T5CGTUOlAk90DNYjS9GKeKd2Jg/VNBLoyylyqQa1pfDj3V79mS/7
 xKdwoVbX
 FzwWXgC3QXX1GBrBkDcLkyNgddgVeaGCtH6voH7KpYaXUHQxqVeeZ/fJdo2s63ip/xU7k0gEbgvyM+5G0IKrXT9o2T53CFQrukx9qePtAusQDuEu2SuQTt7G6K71W1OuLlnAkIXuPG7FC7rPQDoUYCLMZ4Z44CRRW0yFN/oxz5FBEOHGsnQikSNZK/zWZijqUDMY/C/6kK9vFaK5Jp2pGeAcMQ1/BE5PAxWwAGcVr+wgyP0ihuvchxDHFxK8zKXAqRkue9p/aWYYq5Tuu17vqTrFvyOo05GSAg7Bbx/jkDlhhVNBXqd34ktNbXfD3wMu8x1kc83rNrh9DWrCMjhAS9lqserfHDPmRUjDNqc+wSrzLe1Wp1vhStxiMInG7Thy7xH14dCjjhm0WHHaW72KBxlzNKUyFrJNCt0SVyL9mHx5ucXWTA9Abo6F0f4+i+AncAAh+Y+tY2KmZuXnqF0fV9ulctLl3fOBG8MyyO0WSIxkgr+HwzC4zSRGaSL4ytt7sa4gS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Managed interrupts currently have their affinity determined once,
honoring boot-time isolation settings. There is no mechanism to migrate
them when housekeeping boundaries change at runtime.

Enable managed interrupts to respond dynamically to housekeeping updates.

This ensures that managed interrupts are migrated away from newly
isolated CPUs or redistributed when housekeeping CPUs are added.

Signed-off-by: Qiliang Yuan <realwujing@gmail.com>
---
 kernel/irq/manage.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2e80724378267..31e263d9f40d0 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -2801,3 +2801,52 @@ bool irq_check_status_bit(unsigned int irq, unsigned int bitmask)
 	return res;
 }
 EXPORT_SYMBOL_GPL(irq_check_status_bit);
+
+#ifdef CONFIG_SMP
+static int irq_housekeeping_reconfigure(struct notifier_block *nb,
+				       unsigned long action, void *data)
+{
+	struct housekeeping_update *upd = data;
+	unsigned int irq;
+
+	if (action != HK_UPDATE_MASK || upd->type != HK_TYPE_MANAGED_IRQ)
+		return NOTIFY_OK;
+
+	irq_lock_sparse();
+	for_each_active_irq(irq) {
+		struct irq_data *irqd;
+		struct irq_desc *desc;
+
+		desc = irq_to_desc(irq);
+		if (!desc)
+			continue;
+
+		scoped_guard(raw_spinlock_irqsave, &desc->lock) {
+			irqd = irq_desc_get_irq_data(desc);
+			if (!irqd_affinity_is_managed(irqd) || !desc->action ||
+			    !irq_data_get_irq_chip(irqd))
+				continue;
+
+			/*
+			 * Re-apply existing affinity to honor the new
+			 * housekeeping mask via __irq_set_affinity() logic.
+			 */
+			irq_set_affinity_locked(irqd, irq_data_get_affinity_mask(irqd), false);
+		}
+	}
+	irq_unlock_sparse();
+
+	return NOTIFY_OK;
+}
+
+static struct notifier_block irq_housekeeping_nb = {
+	.notifier_call = irq_housekeeping_reconfigure,
+};
+
+static int __init irq_init_housekeeping_notifier(void)
+{
+	housekeeping_register_notifier(&irq_housekeeping_nb);
+	return 0;
+}
+core_initcall(irq_init_housekeeping_notifier);
+#endif

-- 
2.43.0


