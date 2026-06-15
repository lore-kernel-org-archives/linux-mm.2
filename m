Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59A87CD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B25506B008C; Mon, 15 Jun 2026 07:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD4F66B0092; Mon, 15 Jun 2026 07:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4BB6B0093; Mon, 15 Jun 2026 07:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8B4F36B008C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:06:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5598B1A09E6
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:06:31 +0000 (UTC)
X-FDA: 84881868582.30.2110EAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 97E4580010
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:06:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D5H9yP13;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2F1Wu57D1KXCqh6uiw1Q3ldSnxREhsNBlfWv4bIRtA=;
	b=EAnKXzRLOXaPZj7jSGV6XlNBn5wD0TFzT/fEWQ3LfHs/rml1sTw59lHQH11huJDRCwwJ+p
	d5byJ//2Mv6NwC25dcHSy8F42yD9VN/Rrc7DMEXn02CySqM5zEilvDOyzLvEfwzTeGpN6/
	JYXOdawpquu++DjwomfGG33T62HB+d8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=D5H9yP13;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521589;
	b=HM2X5BdH/MqMXhP9WpiFxnWX4dMu9/PH3gueQd5+/sSRciwWoSNnH+CCPANRJZ8nh8PfvA
	jOsF93Q7/vCENC9sQsfieO7A+y7SQon2sSG7LsJQmkyfWbmgU9PTsqk0WRtx6yxL4suf8R
	O3FdmlzsDsP2ZCBlMuxx68132VwleTE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0B03442FF;
	Mon, 15 Jun 2026 11:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74711F00A3A;
	Mon, 15 Jun 2026 11:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781521588;
	bh=E2F1Wu57D1KXCqh6uiw1Q3ldSnxREhsNBlfWv4bIRtA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=D5H9yP13aY80Y2xhF3JVFFWrN4W6dVhuuI98KQ1YDvo9Oe+drurxdalTUrkaNxWan
	 MJ8PK7fLtFxF17cr1WLl59X4KWuqN30d8C3NIwxXzUoGelQI5yRBYCq7QJI2RQG2FK
	 7rI14rO8PhCEjL4SSIeMBmXZJaMYLz5kkUIssGlrNvJKDK7HxklEcDiz8eOHb9b87Y
	 oe8uN7kAHB5l1RMZi7UjMLExpg5IfJGOoYGvMuOR+aL6LfJY3b50n3W82P9mCBq4kS
	 /UKC0Jv0lfHdBb1M5fruzj5V0ORmMIYUltVzp2eYdYK9p8iJVsimFM6RP3TJjFo1zd
	 +ze5sN3apHUsQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 15 Jun 2026 20:05:55 +0900
Subject: [PATCH for-next v3 1/9] slub_kunit: fall back to SW perf events
 when HW PMU is not available
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-kfree_rcu_nolock-v3-1-70a54f3775bb@kernel.org>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
In-Reply-To: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 97E4580010
X-Stat-Signature: m5yaufjxmwyfz1mgshhz89w5uyt898t8
X-Rspam-User: 
X-HE-Tag: 1781521589-693190
X-HE-Meta: U2FsdGVkX18/AczI92YzEK//4WkiKGhrTmcuNXT2pShB95Fx4Wq88GlRzbUvN065lXuNBLott9ghcA/YTFCu4riVgflrFEWVSSHtdA/k0NxtRMa5xmfrYbYE577BTbVlpLfQ9wq9mLeQnp3tDl2HnVJ0Vs/jQ4mq9YP4n7SKHm9UI7Vp0ndfYF+miaam5P9zDGmoNpOo3pR7T09pi1EegdRUoC38a54FoksyL3E+2Y2ci06qRTzXyiYB0LniA+ZrY/dQi/+G6vShiGuC8zkPQOHIPBClMeASfijCDK0+dyWII5X8EumgaFX9FBUGF7SJP6wqfZEIMB1TnqWt7sNxbLlg1/GPXI0JO+1Bri1wW3kzJ2TPqZFdqN3T4uc71YGmaTGzlZ9yO6238FoM3WoAD8Oo5LzdtMjIfhCb8FQ2XpevLd5rxQDe42fqvtiwCDWvVJwotW51EAIQDYtcoY+FSDviVUQZ7Vx03nQulw3hAPowHMXXFBwYUl6Yvc3IAbSdGaIpLH/hXepNayGtIPVlWS2dcL6Mo+uXNsz0skoehISdYKXlQvcFeMK2nKN/v3w3NQSOsS1kNScMhF7JMEWGNqAYmcuyrZWpStLlFpxq/TvH5iOCme4oDf6QHPHRKrbgiSULqzEfx6IPCrtnV3NCtntCumImbYRngS4JyL4yVJ+NG8yig7omKr+/QBk+01wZTOG8R4BDi2MSGVCdFDDUrXQSOjZj0kWpzRunIjPhgZEp4wLvAYSVWZybBalCm+gVUyeracRTiinNpMPTgrjc8yXn8/tIEy5DfjoidT0YaEx5FzEKrr6+hbYjS4uLdlPt7FVEmA0dLrOH3nX42w22F+g7uks/Hfc5R2W1H+Ag6cmbCNoep/pXLXpDdysAxc+FnVnC9Y/ryoGcG7eFRdFphdJr4VVPjOQlWALI2nKYVuYOssBPpXehV1y71eWh2YFRUHpzc9DkTigaBpEaTvJ
 rFVsfWt/
 yyCjJ14yzcQYgwiMuDZi386x2RqVFrZhdR3O+uwguttf8011x8b8077qlSPefPVuiEwCfoRXYjvfySwSjk+ktUuH1J4TPf3iwrbbmibzN4oir6p/2DZqmgCa6aVSNRQOBuBL/W/ohs9qA9n2yihUFqQr3p73O2FcLsxFastxLyHpYlaJaQmc8rgANMAJdD+o3me/BFRIa9kJ0CGJ7P8musuBpnYeytZSZgA2DhQ67gWzA8oZNbQM89uCDmtqH69ofujrZw93bdQRaCetJeSEK5N9P45NwdG+YMnCz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

slub_kunit uses hardware perf events to invoke _nolock() APIs from NMI
context. However, creating a HW perf event fails when there is no
hardware PMU, or when running in a virtualized environment without a
virtual PMU configured.

Since tests are often performed in virtualized environments, fall back
to a SW perf event so that the test can still run, even if it cannot
cover IRQ-disabled sections.

For the sheaves path, IRQs are not disabled until the barn is accessed.
So some coverage is still expected.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 lib/tests/slub_kunit.c | 70 +++++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 55 insertions(+), 15 deletions(-)

diff --git a/lib/tests/slub_kunit.c b/lib/tests/slub_kunit.c
index fa6d31dbca16..11255fc8eb78 100644
--- a/lib/tests/slub_kunit.c
+++ b/lib/tests/slub_kunit.c
@@ -303,6 +303,7 @@ struct test_nolock_context {
 	int alloc_ok;
 	int alloc_fail;
 	struct perf_event *event;
+	bool is_perf_type_hw;
 };
 
 static struct perf_event_attr hw_attr = {
@@ -315,9 +316,19 @@ static struct perf_event_attr hw_attr = {
 	.sample_freq = 100000,
 };
 
-static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
-						       struct perf_sample_data *data,
-						       struct pt_regs *regs)
+/* Fallback when hardware perf event is not available */
+static struct perf_event_attr sw_attr = {
+	.type = PERF_TYPE_SOFTWARE,
+	.config = PERF_COUNT_SW_CPU_CLOCK,
+	.size = sizeof(struct perf_event_attr),
+	.disabled = 1,
+	.freq = 1,
+	.sample_freq = 100000,
+};
+
+static void overflow_handler_test_nolock(struct perf_event *event,
+					 struct perf_sample_data *data,
+					 struct pt_regs *regs)
 {
 	void *objp;
 	gfp_t gfp;
@@ -336,20 +347,53 @@ static void overflow_handler_test_kmalloc_kfree_nolock(struct perf_event *event,
 	ctx->callback_count++;
 }
 
+static bool enable_perf_events(struct test_nolock_context *ctx)
+{
+	struct perf_event *event;
+
+	ctx->is_perf_type_hw = true;
+	event = perf_event_create_kernel_counter(&hw_attr, -1, current,
+						 overflow_handler_test_nolock,
+						 ctx);
+
+	if (!IS_ERR(event))
+		goto out;
+
+	ctx->is_perf_type_hw = false;
+	event = perf_event_create_kernel_counter(&sw_attr, -1, current,
+						 overflow_handler_test_nolock,
+						 ctx);
+	if (!IS_ERR(event))
+		goto out;
+
+	return false;
+out:
+	ctx->event = event;
+	perf_event_enable(ctx->event);
+	return true;
+}
+
+static void disable_perf_events(struct test_nolock_context *ctx)
+{
+	kunit_info(ctx->test, "%s perf events: callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
+		   ctx->is_perf_type_hw ? "HW" : "SW",
+		   ctx->callback_count, ctx->alloc_ok, ctx->alloc_fail);
+
+	perf_event_disable(ctx->event);
+	perf_event_release_kernel(ctx->event);
+}
+
 static void test_kmalloc_kfree_nolock(struct kunit *test)
 {
 	int i, j;
 	struct test_nolock_context ctx = { .test = test };
-	struct perf_event *event;
 	bool alloc_fail = false;
+	bool perf_events_enabled;
 
-	event = perf_event_create_kernel_counter(&hw_attr, -1, current,
-						 overflow_handler_test_kmalloc_kfree_nolock,
-						 &ctx);
-	if (IS_ERR(event))
+	perf_events_enabled = enable_perf_events(&ctx);
+	if (!perf_events_enabled)
 		kunit_skip(test, "Failed to create perf event");
-	ctx.event = event;
-	perf_event_enable(ctx.event);
+
 	for (i = 0; i < NR_ITERATIONS; i++) {
 		for (j = 0; j < NR_OBJECTS; j++) {
 			gfp_t gfp = (i % 2) ? GFP_KERNEL : GFP_KERNEL_ACCOUNT;
@@ -368,11 +412,7 @@ static void test_kmalloc_kfree_nolock(struct kunit *test)
 	}
 
 cleanup:
-	perf_event_disable(ctx.event);
-	perf_event_release_kernel(ctx.event);
-
-	kunit_info(test, "callback_count: %d, alloc_ok: %d, alloc_fail: %d\n",
-		   ctx.callback_count, ctx.alloc_ok, ctx.alloc_fail);
+	disable_perf_events(&ctx);
 
 	if (alloc_fail)
 		kunit_skip(test, "Allocation failed");

-- 
2.53.0


