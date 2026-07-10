Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D80C2C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 05:31:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BBF66B0092; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492F46B008A; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248F66B008A; Fri, 10 Jul 2026 01:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA8D66B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:31:19 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 724941A035E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:19 +0000 (UTC)
X-FDA: 84971743878.08.F9EFA12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 782A91C0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 05:31:17 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="erKo23p/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783661477;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wo6/1vzp8+zwtdNJkTwUNquZ7hqx1hgsMbS8Z6VviF0=;
	b=3SMmLjU2DjW+rd2E3vpc+gSdwtnJQsm/YcjdGYHMMCinX8nYRi3QwvWJYHNoLyBLDNnRwh
	gRrtvm6jSq07XLuSLEwUSG/QHPgwYHZsfNqkP3Bvo8Pjfgb1NOr+6udLQD928sQHK814TP
	TRyPaszI6Wb4/h8mtjJGEvLHcXoLfAY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="erKo23p/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+m.mavick.dev@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+m.mavick.dev@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783661477;
	b=yeI0CPJB0MXvlTygCZdIyU6V8CeSxMPWrBhc2+6Li5X7YCErF7/GsL6uA3PkImeabVjZTM
	BMyKaIkHJlKkGwy7v0KQnk0Wi0LSZQaEhnOWJo336zXfS0FA1e19lt7GXVQ85q3ZDqbiF/
	laIzJRt0h9LeFMfB9mV7aq0J+H5DXiI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 556EA4406C;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1F0CFC2BCC6;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1783661476;
	bh=BqhzH8win7IsFt3bVsGRfLZJqVQoC3H+EYEyrwbBQro=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=erKo23p/n5kFc0MNyrpiiMJlVgZNgKrb5Cqa0Xj3d4eC7KXuhU3/Kuh2tQ+f54nBT
	 yc/6LvcIXQDlOgq/iaatx+8GAG6oVcSzcNSuQh5U3PMtH7i8oUNvjl8furd1fyhIGp
	 JIUPxGbl4hr55lV+/pU7N3KNl0AGzQAVn6T7bsl+8AhPqQPpGT1NznD653qUcM0I1h
	 IRCSbAdmylu5BRyRNoX7XIXnu+tcMs5qxdI/HBI8mArYQjO12jrJn/tTR4EZ0niG7i
	 c7BMnHzo5VvIy412ijtdWSpq1ybrjDhgy3en1/ttAvo7DqWWXfHEzAR1QQIJjQyiPo
	 qOy+vnlH83AOQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0225EC44507;
	Fri, 10 Jul 2026 05:31:16 +0000 (UTC)
From: Eugene Mavick via B4 Relay <devnull+m.mavick.dev@kernel.org>
Date: Fri, 10 Jul 2026 13:30:40 +0800
Subject: [PATCH v2 2/5] refcount: add ref_trace_final_put tracepoint
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-refcount-final-put-trace-v2-2-557cfce860a2@mavick.dev>
References: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
In-Reply-To: <20260710-refcount-final-put-trace-v2-0-557cfce860a2@mavick.dev>
To: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Boqun Feng <boqun@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Gary Guo <gary@garyguo.net>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>
Cc: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
 linux-mm@kvack.org, Eugene Mavick <m@mavick.dev>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1880; i=m@mavick.dev;
 h=from:subject:message-id;
 bh=LlgAKLvSTzT+rMKMAXMt37/mjMTpw1NXPXF0CRuqRZw=;
 b=owGbwMvMwCU2V/5U3e1aE3/G02pJDFkBzT33jpy6k7R1+kNdW73wjXUfb26Iv7hoxdSVcvOmh
 rm/cvrs2VHKwiDGxSArpshSk5XgnrFyVqLx0Uk9MHNYmUCGMHBxCsBEnKMYGVab93IpL7he/jLA
 ddYj7ctyQnPDJzFeuLVL5dQpt+0l9UUM/4NabsonXO9+eaX0QMPN2z0a//MWS3reFtgW57Lj7cd
 mBTYA
X-Developer-Key: i=m@mavick.dev; a=openpgp;
 fpr=7C6A604768A99A6133C5928C9D1FCA7EDB7D344F
X-Endpoint-Received: by B4 Relay for m@mavick.dev/default with auth_id=850
X-Original-From: Eugene Mavick <m@mavick.dev>
Reply-To: m@mavick.dev
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 782A91C0003
X-Stat-Signature: mtjuyws5hfcusmh6ahj5cbkhh58e9895
X-Rspam-User: 
X-HE-Tag: 1783661477-341589
X-HE-Meta: U2FsdGVkX1/Law9rMSK/ztUEpZUnL6U6aLu9KOhbyepUheAQ6bEfYTqwimLf4p4QhUTNbejbqeYIyoYJDuHDObcOln93l4lY34jWScR/x6Tr9LMGXhRi2R9aJUztxGQU65jVGK6+guym3b4R7VUE8+N/FcI4TnRrQVO+0LSEa7IBO/gQqlKJJhDfqWvM7ycs3NwRFt+Kz4tV7NRaApnUSj5doye2zW9/lT/SvsYW0hk1bad454uQz4zG5tNMEiR4OvGpiCXT+uyzMWh/+iZ0CnmxmdQYR58SianY5OF9OtBKNEOeiYJdhXP2BnNEmbI1AaeN2PoCyqOqeeMwExez7AVHUI1s7LFa0VG4uwO/iQ4yr2WOMy2MUMeQ9gZQmgp60On1Xj1V+wL8zXIvUoVpVE8iWczHEh/32/KPe0mqpHDSC9xIVy1ECwWUwmKm48ItwSvYwUOstM2bpZew2J0lYJE59KLEdYna/9a24IsFwQFL/NO8E06t+HJ4x6UbUmdJVbbt7cF6hbs2U/AqcKL4evXshLbOWjqgpSL8ZCT3TXegj33gSdNZDuJhe5wF6vrg75HOh6nIqyUwDz4KEE7QRxJLSjMzA9JtNug8/R8F9kWD9WaW4gu4s1dr84k/38ISk3X2KApcbz1JvrZga6wg4fxzceVE3epTCsu4T+kB5jVSgBuFiitcnv1tvbOjpS0BPd2AtiEcGgCgCG+Xav+6h4hi79Z8qQedwgQTUndgeIWZdNBMrKN8sitzKoM7DQeKXCTjSCqftniaLWnluBrDIcxHMgtvFrRD4JbVDHYAwCe0r2ScQcomDa92QOqM538zwFmP8NDjyM3Jwzd4Jr4L0NP0CSS0956Mc14jZTdeAtcK+5fup50x4UjN/3xtz/kgni0M02NYjDteozidKVpnNxqUjxuNGQU3wTs1xccRKmWZo0jiFlMFqXyIhQNJNhw7ySWxMU2l1YLbExELZRX
 knqsGJ03
 6ENWUNAu1ol2L0N2MF1+SIKtNLui/S9mM8VSvOjEkHn76BQ/Mn8B83AbCo8hsIFk26bkNksodbd/4iu2Sb2IFIzl6G25o2O1DHt+j9s7Og+8bdWtLtFPoWHlQSTcIzeYaJ8NWX3PEbFXxDILJnDHg3mCfYMgtyjZGV32BHGgGJn087IdHSbjpwaIGg7Sc8IXczXEvrRCkv+Mi/fIOnBywFnICQt/je0EIpbXJBltFpMboa446s4ggJHFk6NuLHrU0LZ5eBKe39360pk2l4RxUeq/NnkN+MZd0ITzmeHlpmb5V0Mq0V+gUBGfLIGah8DcikM6N8JrPPPUFDTAG/CvNuwBS7okZWlelJ/ClA/Lqlw1vHbyZtcecswILYUourkO2g0+qEpBWUmhDjzjtRUVXcf2PF4780fU38R/p5yB2IMyI6yHgOPbO1RJL79z5UXhbOJm7OSzag25LcJ1Bn2Lt8Qxih2UJT27MW2AS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Eugene Mavick <m@mavick.dev>

Add the ref_trace_final_put tracepoint to __refcount_sub_and_test() and
refcount_dec_if_one()

This tracepoint fires when a refcount_t reaches zero, capturing the caller
address, the function name, and the refcount_t address.

Signed-off-by: Eugene Mavick <m@mavick.dev>
---
v2:
-update commit message
-add tracepoint to refcount_dec_if_one(), suggested by Usuma Arif
-move MAINTAINERS file entries to new MAINTAINERS commit
-v1:https://lore.kernel.org/all/20260705-refcount-final-put-trace-v1-2-cdd0014626a9@mavick.dev/
---
 include/linux/refcount.h | 2 ++
 lib/refcount.c           | 8 +++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/refcount.h b/include/linux/refcount.h
index ba7657ced281..70d07a462da1 100644
--- a/include/linux/refcount.h
+++ b/include/linux/refcount.h
@@ -107,6 +107,7 @@
 #include <linux/limits.h>
 #include <linux/refcount_types.h>
 #include <linux/spinlock_types.h>
+#include <linux/ref_trace.h>
 
 struct mutex;
 
@@ -393,6 +394,7 @@ bool __refcount_sub_and_test(int i, refcount_t *r, int *oldp)
 
 	if (old > 0 && old == i) {
 		smp_acquire__after_ctrl_dep();
+		do_trace_ref_final_put(r);
 		return true;
 	}
 
diff --git a/lib/refcount.c b/lib/refcount.c
index a207a8f22b3c..cd7e32df3919 100644
--- a/lib/refcount.c
+++ b/lib/refcount.c
@@ -7,6 +7,7 @@
 #include <linux/refcount.h>
 #include <linux/spinlock.h>
 #include <linux/bug.h>
+#include <linux/ref_trace.h>
 
 #define REFCOUNT_WARN(str)	WARN_ONCE(1, "refcount_t: " str ".\n")
 
@@ -56,7 +57,12 @@ bool refcount_dec_if_one(refcount_t *r)
 {
 	int val = 1;
 
-	return atomic_try_cmpxchg_release(&r->refs, &val, 0);
+	bool ret = atomic_try_cmpxchg_release(&r->refs, &val, 0);
+
+	if (ret)
+		do_trace_ref_final_put(r);
+
+	return ret;
 }
 EXPORT_SYMBOL(refcount_dec_if_one);
 

-- 
2.51.2



