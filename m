Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4299EC98332
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 15:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DF046B008A; Sun, 27 Sep 2026 11:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D496B008C; Sun, 27 Sep 2026 11:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94446B0092; Sun, 27 Sep 2026 11:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B67F26B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 11:51:52 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 365BB40A35
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:51:52 +0000 (UTC)
X-FDA: 85259982864.17.CB5B1E7
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8419B160009
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 15:51:50 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="Kqoo/x0g";
	spf=pass (imf08.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790524310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJZtRM91aHOzDwlGhUn7K80dltrSbiTp//FJp6Ow9Ys=;
	b=k3RjSoEipb56Z365YPmuNX1XpieyQrd1M6A88O9rSOv1WcdRzCoSMaBAzpy/nate7lwm2o
	uM7/eNaI9EUJcxDeomHX6oZWhtA1jJ6LlqNGaYxF9dOUeB1J61qVGd8PocmOvzfNSnIg90
	K4/VwJ+tIntKPMKEQo02X75ZOSC4dn4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790524310;
	b=GeGtQNbW9aD/jxlQ8t/HGdhEiBnRRTYzr14JKISXyw9vUxZKmeRktriV5yElH22Af1GOaG
	yat8887q9WeFdVA0ZFBhEf7mkIDyOmyO0C2Z4qk6ftRMhfeAfk7SuXMK/8axAHzOzvR3Mi
	4tdD3lFIpuocsThRn/HNIrUa5cm3Hr8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="Kqoo/x0g";
	spf=pass (imf08.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1790524309;
	bh=XJZtRM91aHOzDwlGhUn7K80dltrSbiTp//FJp6Ow9Ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kqoo/x0gU6cfO/dozoCRndXnjMUQnvEWJJqFnRL1KdacbB59t9bFJQG+UrLMt9tht
	 JQanVvci7golgHlE/4H1F11J8dkXRmYG4XDEpC1otXSWcNaErQEtJwaeBd6mhKlUYd
	 U/cut1gZY/CaDNZMmfIj/C7f35+t0E3/qeiRiCfMAjr0BI3Tx2YDfBIcxJbgyXCXka
	 U44m3Z5cb2VK15CWDdBSrLC2egudDHuOJlGE3cGylihTjJkXeWL9eQA0PIT2kaYuoa
	 9A/Nr9p9y0kIJk+Lb3Xo4zcgkUaj854GniG3SpgzjdfY+H/E31k0oQfKD+WEU7QrFE
	 UB7zoVT5J5Yzw==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4ht87n48FjzhGy;
	Sun, 27 Sep 2026 11:51:49 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E . McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	John Stultz <jstultz@google.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Frederic Weisbecker <frederic@kernel.org>,
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
	Gary Guo <gary@garyguo.net>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	lkmm@lists.linux.dev,
	Nikita Popov <github@npopov.com>,
	llvm@lists.linux.dev
Subject: [PATCH hazptr 2/4] compiler.h: Introduce ptr_eq() to preserve address dependency
Date: Sun, 27 Sep 2026 11:51:29 -0400
Message-ID: <20260927155134.4740-3-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260927155134.4740-1-mathieu.desnoyers@efficios.com>
References: <20260927155134.4740-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8419B160009
X-Stat-Signature: pf4tzff9wwzbfz9hfw9534m9jz8o3szh
X-Rspam-User: 
X-HE-Tag: 1790524310-293855
X-HE-Meta: U2FsdGVkX18vudPx89jSJNphji4YcHwTKEALx9OShqNBue8NgZ7UGLs9+OIpmHdog54AGMUY5uhHCyL8A/FZbgR2gJRtqXAjjFIcyUgvkpCXDiWqfJ0vDiVJjIOesv/Guax3iaS4lXG73qTczbpgp8MAcD9mmLZ1PbCiY+dP8aaWDcoTeLfIeGIgcLMZPYwfHkA0jaAECw2rbbXAo9xSERGUS4BwHIUP1tnzGhWASAKZy2+9G+GY2z6sQelp97S0ol+HLEBRSbJ3V38Np7E8p7YDz84s93/sjURFe7QLwWegj8M5imCKgNoFBHoxr8dXqCsOeJ30uhlm47SOJ0MyA76SOjJfdOOwP+ylN5y4g6CE2/MqrBQ3dfTtprT0JgPBVz+5Zisn1/s5b0Vg6nfPAy196RxB6ErxW1GOncR0nOfwI2Pl+z1vxngKFa+anQty2VHsof7SJiFzni15rMnhMuhVsg1bRLx95iMiyfVZr6r2MMCTro/uzrhyrYLe2DtTO48FHO1PJ5Ay5CCXwZFDKZ4BsGzjp3eL6WkNLV3Oe0zISbUdpsACLCQGZeSZdx5I5u5qC/UyLmE6Ux70oQ1XIIJLhoQBi1S0uvJxsc/3Y7F9+LP9QU5KeZMoDw7tB2/9cAEbeBFNwmGGFRZhDZFWihHEumiNU7FMUwntQNcaJGzWDUBJJaJJnMV99ym4lV2StXr9a8OxPEzEb41x2wJ+IDZ7P/xh9Dsb3+OR4lTJ2uyo/jAdmEOc0Z4nfoMib6AupWUMW0NhLMSX40+iCOIW5DI6zKGk8ttqIh5aPDwi7zm1I2cgvKm19RtblT2VTPcwYrkqKKcDI+J0W4xAp4M87bCWuqr4+N6dKzLll8EvVR3ysHzxvnlZ2RGSLVea5XMHNeP5WJcWv/q9Q4Kz5J44/5WHa5SbtdMewFgbPmoCHJMR9BwMceS4hI6rEM+FH1AqD7CdWT1hwcnKIvXDrTo
 XKH9oxvZ
 lgmK6ndUGi1ueH1zVJndLFPdHQAMluoqd7KacDBvv3cS/0VP1mnyW0iPLyjI3LXBp0/qt98T63zDIRE7KC5NnamGxGRbV7qK2w+yosDvSYOPqoVExTceY0b8nfFoc7/dzqN70iVwoxN2VYU+KTGSDQYNYWQdEnY3Wbx8JtCufsHhmxk/g0KJ/B/Je1TEugiN8mjmgAbVq56+fxbZ17a4olT1hfG+a56n0bQhwF55e+FqXBXJ2c3GDOwjn40eE2qZlRKzeOl/ku5oDa8xfLVtMEVUFWYPBYxe790JLxjaFJBGU14/jaqvWL96E1V0HWCIs6yhPfoTv4FZW+gx0GC30/qrBmnwUkd6VTwoQNrd/kxsr1iC5Ecw4K1i08aAXxO0Kh3kTvLWRZsJSjpx9VuKeprra7hxz4RvhecEhrCESn6Gymzf3LpIwdn58imRYvGt0jKxLRofOOaO5AZPMv8lHqBSvB97EF/ZKDgMeEB1ZTUtIREZZX5Lh1al10vwQHhP9rhZB9vXt4orNa9jhmUAPv7c9jDxs1CT/O7tgS1SCVFmH/XGtXDaPGi6R0PgyYoY8X7/dC+OyabI07aA8ofiH3lSWreZc4QZRnxDOKkBKeUlCjot+BfVliEl4ld3dveuwQtw8OXSxjU8NGa1Qbu9P6N3rTWAi3K0rCMeSfTDOSMJRiysWSeCEG36PzigwscwCbuHGp7h7ZWkAb4hbi7N5gG8jGxv8Lnr3hTiVrBxRzgk779b7022hLMVwXj//OgLRUGGt7O7Fp6QNBNBqpBVP0l5Md8TpqdhIq6s5aJeK+sLOUoE6r5pBWxfa2N/4CMfHzGd2MOj9eGB9CKbSQ/CdlfbTSiltwbkxOyF4lVgYA+NA2CcLPs5G+vsCcBYwG8fEPOocKeGUviwhy9n3CZPbl52KYRG1T8xj1M/a31FGms1hfc2rwVrSIozHrhrJK8US0D07bnkfvkPG/kGhElPnZioYttnK
 gA0ku0XC
 k0mOKR165n9KwEHfnIRbDeXc0gZOFQ3kf/k89sDGSGw6L7IMIHLQcC4TEC2FtCfsP9J2myB2iXEU+U57VQsFScuKmFphWNrOAQEwhjXewAoZTvQTgdE3+j3N9lpLUN7jqjqyA5A1mkzicstGOdtZ1Hh0oZdqOOjHMP8XbnqbmxCDSyfZl3Vsrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Compiler CSE and SSA GVN optimizations can cause the address dependency
of addresses returned by rcu_dereference to be lost when comparing those
pointers with either constants or previously loaded pointers.

Introduce ptr_eq() to compare two addresses while preserving the address
dependencies for later use of the address. It should be used when
comparing an address returned by rcu_dereference().

This is needed to prevent the compiler CSE and SSA GVN optimizations
from using @a (or @b) in places where the source refers to @b (or @a)
based on the fact that after the comparison, the two are known to be
equal, which does not preserve address dependencies and allows the
following misordering speculations:

- If @b is a constant, the compiler can issue the loads which depend
  on @a before loading @a.
- If @b is a register populated by a prior load, weakly-ordered
  CPUs can speculate loads which depend on @a before loading @a.

The same logic applies with @a and @b swapped.

Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Suggested-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Tested-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Acked-by: "Paul E. McKenney" <paulmck@kernel.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <jstultz@google.com>
Cc: Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Frederic Weisbecker <frederic@kernel.org>
Cc: Joel Fernandes <joel@joelfernandes.org>
Cc: Josh Triplett <josh@joshtriplett.org>
Cc: Uladzislau Rezki <urezki@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Lai Jiangshan <jiangshanlai@gmail.com>
Cc: Zqiang <qiang.zhang1211@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: maged.michael@gmail.com
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
Cc: rcu@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: lkmm@lists.linux.dev
Cc: Nikita Popov <github@npopov.com>
Cc: llvm@lists.linux.dev
---
Changes since v0:
- Include feedback from Alan Stern.
---
 include/linux/compiler.h | 63 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 70cb31d60538..0a8c8e53cdad 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -166,6 +166,69 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 	__PASTE(name,						\
 	__PASTE(_, __COUNTER__)))
 
+/*
+ * Compare two addresses while preserving the address dependencies for
+ * later use of the address. It should be used when comparing an address
+ * returned by rcu_dereference().
+ *
+ * This is needed to prevent the compiler CSE and SSA GVN optimizations
+ * from using @a (or @b) in places where the source refers to @b (or @a)
+ * based on the fact that after the comparison, the two are known to be
+ * equal, which does not preserve address dependencies and allows the
+ * following misordering speculations:
+ *
+ * - If @b is a constant, the compiler can issue the loads which depend
+ *   on @a before loading @a.
+ * - If @b is a register populated by a prior load, weakly-ordered
+ *   CPUs can speculate loads which depend on @a before loading @a.
+ *
+ * The same logic applies with @a and @b swapped.
+ *
+ * Return value: true if pointers are equal, false otherwise.
+ *
+ * The compiler barrier() is ineffective at fixing this issue. It does
+ * not prevent the compiler CSE from losing the address dependency:
+ *
+ * int fct_2_volatile_barriers(void)
+ * {
+ *     int *a, *b;
+ *
+ *     do {
+ *         a = READ_ONCE(p);
+ *         asm volatile ("" : : : "memory");
+ *         b = READ_ONCE(p);
+ *     } while (a != b);
+ *     asm volatile ("" : : : "memory");  <-- barrier()
+ *     return *b;
+ * }
+ *
+ * With gcc 14.2 (arm64):
+ *
+ * fct_2_volatile_barriers:
+ *         adrp    x0, .LANCHOR0
+ *         add     x0, x0, :lo12:.LANCHOR0
+ * .L2:
+ *         ldr     x1, [x0]  <-- x1 populated by first load.
+ *         ldr     x2, [x0]
+ *         cmp     x1, x2
+ *         bne     .L2
+ *         ldr     w0, [x1]  <-- x1 is used for access which should depend on b.
+ *         ret
+ *
+ * On weakly-ordered architectures, this lets CPU speculation use the
+ * result from the first load to speculate "ldr w0, [x1]" before
+ * "ldr x2, [x0]".
+ * Based on the RCU documentation, the control dependency does not
+ * prevent the CPU from speculating loads.
+ */
+static __always_inline
+int ptr_eq(const volatile void *a, const volatile void *b)
+{
+	OPTIMIZER_HIDE_VAR(a);
+	OPTIMIZER_HIDE_VAR(b);
+	return a == b;
+}
+
 /**
  * data_race - mark an expression as containing intentional data races
  *
-- 
2.43.0


