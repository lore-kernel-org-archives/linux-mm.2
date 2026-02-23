Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3781FEC1136
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 20:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C75F6B0005; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58A786B008A; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44CCF6B008C; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2CD9F6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:44:24 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BC54A583E9
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:44:23 +0000 (UTC)
X-FDA: 84476899206.19.FBFA132
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id 17B214000E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:44:21 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=aoGj60zs;
	spf=pass (imf27.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771879462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyTEEaoXAAyCQz7ZsgcVYW88Dh1Bs2/KiZ/NYa4dnJE=;
	b=7jIIWyTKL35+x8NNYdmkBcVbta1+SaUsTPG2yrBGoz7r7W7LApH094aQpCPvbCBV57vtQm
	J/MrYFCEqDjVi0Un/VhY2DXUxCBiaWnonE4VBzga1QmaUerIf+GPhNr4vOGnFKkC98AJhi
	c5omlCZf12efT6jqqPh0Xs3jKrUW4XI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771879462; a=rsa-sha256;
	cv=none;
	b=2CdE2/X/mqNqxpiXtjBP5B8mfIXzSSJE73aZ/5Eto6KHnsjfWGOSEN8pIbUC9MpgFo0T/i
	tr91+3IOkfKo8XEaQebmK4DtpcFZomRF6elI2I8+PkAOcXdzunpmkniYGamqzss6gtoUPG
	UQQLfQWDq765d+gbLMm43Cp/tj7/Q4M=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=aoGj60zs;
	spf=pass (imf27.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1771879461;
	bh=KyTEEaoXAAyCQz7ZsgcVYW88Dh1Bs2/KiZ/NYa4dnJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aoGj60zs4KFIYxAUrRWU6lEvNVCe3z+VyrASWTHF+XgH58FbnH/OrB8z+3vOzmvP8
	 JMsxujoo9dt8RcFHa5fxdRwn80Lc9s9Y93bCTENVz/WqCwliCOiQDS0bXovc2us1FV
	 ncGIF3lsVuR2iLlwm2pya7s+JXnESfpkoeQo3DIoWcyQgHF+ZKJUM0DUae8Qz8Xxm1
	 XH2sQ0IA4rSLNY4uksDZ/2lh2aUOL4orhYx8pXWyy/rEfJBkZ5vequihw1xAFNy3WK
	 7RKqWoXx8Z4GXP6xaS36EzKG2f4eVdTVa3RmO8LNcOl69uV07hUyUEoEOTS6e05rDo
	 +XtYiSzPTdszw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4fKXs12rh7zHyx;
	Mon, 23 Feb 2026 15:44:21 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Joel Fernandes <joel@joelfernandes.org>,
	Josh Triplett <josh@joshtriplett.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	maged.michael@gmail.com,
	Mateusz Guzik <mjguzik@gmail.com>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	lkmm@lists.linux.dev
Subject: [RFC PATCH v5 2/2] hazptr: Add refscale test
Date: Mon, 23 Feb 2026 15:44:18 -0500
Message-Id: <20260223204418.1429025-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260223204418.1429025-1-mathieu.desnoyers@efficios.com>
References: <20260223204418.1429025-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Stat-Signature: owbexs9449whtz6yx6znx6pmyafq8txr
X-Rspamd-Queue-Id: 17B214000E
X-Rspam-User: 
X-HE-Tag: 1771879461-724098
X-HE-Meta: U2FsdGVkX19fLukkoHpPOofrrPSbIUOGG9REQwthSmIYqI2xc5C9bohGjrFpCn7YbcUjWAg6vc10vMAGI2eZb/MdiAu6i9gRMb13p9S9jycd9/JjA30mqjDXbG8z39cGoeAJS/toexZXDPTBn8ZICoJamFJWtWDTJ4FXxU3JmDDlDmU7uUuGW4BjITwSEMzPKt4wtA6CaPDpJ5VcueS8nsb1A3+cQL28Fi04qgMwo3YlZbwEbb9X444g2P1lqJpt2XUSo1vzGwaQd9IXdRYXH6q8RO5fqn+JiacK47E+EzVV9o5DzUInzlzdi2K/Rsj8EWZGAgPfur264kD3fxNv+c0gpPiDY9BgNTq7AskjSfZXb5Ytz03EKcGPM3Of+CQqF/5o9g630oSSy15+I39l/a/FHM4x+JgvPP8e8EQxTXqJK9o5PDelLJvvlzAvmbZ9kZ3ZO8ogSRf2B/vfBTog0GEgC0X8WQRB/Ga1heBQ9dOzYBpRsVY/ZTpyQkL5NNJn9ZXWS6HbKiBBN0gQp2z1r/VWXqADl4TNx1MMFv4Fwwi4YJF3T+3T3JguMRlsbIBzgYq2nmab9eWHm/mZ2VTZWxQWams48P7GrQQgHX6aTIh0Wv0kk8CdzC2fmoRnqtJIr7lxvHjlfSpZcaTgqV5OOAQf9ofROQIvL3wwc2VJ4pj9xnnPkPM01dVhDwgEs3snEA8bq6ouZrVx0xdkcZtbRypN6VMbi+/Cfw+BKp8wU0PcKvKK47S5hvL23Rj96cr1zWufcXKIE0q/3B/ciLvcLhz1IkzkZRbxv86soxFn60VF9Ln3u+EIgaFylvZJhkeGoQ9/4W+VInE3D5nEXHP9PncFwFCM0ebJ/bARrxs7DFylCf5aVvAymkflAlT8FKxvL/XuByb49z2UYeZdWfFlL3I9pqBiAqwrjYyARsExhfEXX/R1fW65yExUXYGixWcAYfbNdH9mlG3sV+QsYDh
 J6m66YsC
 4OypJ+fwddCD5Ph9pjOrVOsSepam1Nwm1TjhRg2R15rxFE7mFvxbVEJEaFruwqWyLB+fuSf5BINBobi1yUC3hz8WVE2PduK5ZWQ7v6AR1jbcO9tapi9l0DQZTOdzSxEaI8RSYLq0+zvj5EzbxC1fa9ZZ2wUGPsqvGxgy4vzePrE7zU6t2GBMmTPTNWxKwwY97VDuolBu5QuOrU//F7MQVkBYchZCMTmWdUvVtW/eb+gkKI1amQ7X4Vg0r/3xiQmUAkkYJri86OnuuQcsUThcXT4q6IRXhTsnn3lBahd9/NfB2LaAbtc15SSG4r2PCL82FhxgCUOx7UCLMm0xUnq0WtyLyJD+/xyhI83wD2PXeRRFfW6CKlAWfti/DnY8ooqWY2nLsOZpr+QNOUSJMB9GzO3pYacFX6NjYz3dDSWEJEFj3YIffflh9YI68Fw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the refscale test for hazptr to measure the reader side
performance.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Co-developed-by: Boqun Feng <boqun@kernel.org>
---
 kernel/rcu/refscale.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/kernel/rcu/refscale.c b/kernel/rcu/refscale.c
index c158b6a947cd..7d64dfe78327 100644
--- a/kernel/rcu/refscale.c
+++ b/kernel/rcu/refscale.c
@@ -29,6 +29,7 @@
 #include <linux/reboot.h>
 #include <linux/sched.h>
 #include <linux/seq_buf.h>
+#include <linux/hazptr.h>
 #include <linux/spinlock.h>
 #include <linux/smp.h>
 #include <linux/stat.h>
@@ -1210,6 +1211,47 @@ static const struct ref_scale_ops typesafe_seqlock_ops = {
 	.name		= "typesafe_seqlock"
 };
 
+static void ref_hazptr_read_section(const int nloops)
+{
+	static void *ref_hazptr_read_section_ptr = ref_hazptr_read_section;
+	int i;
+
+	for (i = nloops; i >= 0; i--) {
+		struct hazptr_ctx ctx;
+		void *addr;
+
+		addr = hazptr_acquire(&ctx, &ref_hazptr_read_section_ptr);
+		hazptr_release(&ctx, addr);
+	}
+}
+
+static void ref_hazptr_delay_section(const int nloops, const int udl, const int ndl)
+{
+	static void *ref_hazptr_delay_section_ptr = ref_hazptr_delay_section;
+	int i;
+
+	for (i = nloops; i >= 0; i--) {
+		struct hazptr_ctx ctx;
+		void *addr;
+
+		addr = hazptr_acquire(&ctx, &ref_hazptr_delay_section_ptr);
+		un_delay(udl, ndl);
+		hazptr_release(&ctx, addr);
+	}
+}
+
+static bool ref_hazptr_init(void)
+{
+	return true;
+}
+
+static const struct ref_scale_ops hazptr_ops = {
+	.init		= ref_hazptr_init,
+	.readsection	= ref_hazptr_read_section,
+	.delaysection	= ref_hazptr_delay_section,
+	.name		= "hazptr"
+};
+
 static void rcu_scale_one_reader(void)
 {
 	if (readdelay <= 0)
@@ -1524,6 +1566,7 @@ ref_scale_init(void)
 		&sched_clock_ops, &clock_ops, &jiffies_ops,
 		&preempt_ops, &bh_ops, &irq_ops, &irqsave_ops,
 		&typesafe_ref_ops, &typesafe_lock_ops, &typesafe_seqlock_ops,
+		&hazptr_ops,
 	};
 
 	if (!torture_init_begin(scale_type, verbose))
-- 
2.39.5


