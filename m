Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36876D66B87
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 01:45:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F29556B0092; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA8E96B0089; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C82B96B008C; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 991E16B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 20:45:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1A6E960E01
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:45:38 +0000 (UTC)
X-FDA: 84230899956.22.CB231EB
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf10.hostedemail.com (Postfix) with ESMTP id 65E48C0008
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:45:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=fpefWz2O;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf10.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766022336; a=rsa-sha256;
	cv=none;
	b=cy5C+ODtAh0YgMuXbt2N3YizJNH0CUz4OcLkCbxbZTSyN8/IO/pBL41QCFenHxhdALyJX6
	bSByRvtbt9Uzw0ZIZLllXtgN6U5GexzVlvpQyij2YS1XfC1LHWGIbGuseIfil9X7dmZr6i
	ZcKNMuzqgibOPbZuwBJcg8ATQgNFKTs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=fpefWz2O;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf10.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766022336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSepe1r3J5AkA/ggHcrTZYYdvp9Ci1dmASMa/AW6Syo=;
	b=bK4q1FPLu3ujXC7WbVsxIk0B+SXFHx2yz7KQgl53FgsHlecm11ulm0SoPuLg/MXttf8IgO
	U3Hgkga3cFHmGRnKddZCoENwMVK52d19BH7zKcSEpGdCgR/tyi/RbO/Jn9bf3LvAV5lfIJ
	GD2xYbiIj/9j3zP9WantbzmnOwYMI9Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766022335;
	bh=eSepe1r3J5AkA/ggHcrTZYYdvp9Ci1dmASMa/AW6Syo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpefWz2OOWYhr17qhvXdJUHCSZlnkKeCwwFJI/K2lhYX9vBN17F0aiYUo7GSpMVxO
	 ppO5B8VBOtTk7DNbQJ5QyFNUCsRHRxKbglk2Xy6mbDY77Xtby95tMV7tlnGqc4K+Oi
	 qdJ6j9RZmslbWmQBmcu17X5PYsn/YKzDY6P4wXKgOLuZOiSqqx/sryvCAJLYsQPh+T
	 hPJua80/8rB8rElwDvyNPo67qMQ6mhbVVJ/OlUcPjhclzwdporTHPm8jgMW1AaMU6l
	 YS5rUv9aN/dSNW+MUNZixj6eYpamFotey5l0QVhzmJRafWDa99MNPsC7gnZ3xgmxeG
	 Vn2WW1vgksAMA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:a253:d09e:90e7:323f])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dWtlz3Z4MzbxM;
	Wed, 17 Dec 2025 20:45:35 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Boqun Feng <boqun.feng@gmail.com>,
	Joel Fernandes <joel@joelfernandes.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	John Stultz <jstultz@google.com>,
	Neeraj Upadhyay <Neeraj.Upadhyay@amd.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
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
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	lkmm@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Nikita Popov <github@npopov.com>,
	llvm@lists.linux.dev
Subject: [RFC PATCH v4 1/4] compiler.h: Introduce ptr_eq() to preserve address dependency
Date: Wed, 17 Dec 2025 20:45:28 -0500
Message-Id: <20251218014531.3793471-2-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
References: <20251218014531.3793471-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 65E48C0008
X-Stat-Signature: 5bx48ux6tqa7s8qdo1rs6d4cfqxg3b4d
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766022336-915386
X-HE-Meta: U2FsdGVkX19D+y5XlKpnpjaj2tUeBtBqJXp6y4Vcwb4/c2VdVb9asXj+NjeAVQo3jyFbbfmpT3zsS/LIUUcw9zf9dfYyWIR4nJqCvl+fidDJ4qvPMIspGzQ3jx2HPJzsGL2Ke9F3+J9focdyU+tONybyWyH0xmDefqtOmE8SWwneNSbFbUAFw8Zxx3au8/89CKild3h09pPUdMks1TGzPgWpyUBuWQhDMaOn+NYwI1d+0wAF45bJwVEzgnB7Smu5u0aUifrOrvTtYZIG1AQ4fWF+z5UMmFB6bWhNnxg74xWLmaXeN7o5kyE97JfzFTiBz6ThYz5A81yWgCA4oKP3+jNqrbr9v8ocYnZNJYNjwzIDOQH/a+wSzprx2bBmnuRcXpcdIwM6i7QSiodORAomKvO27g3GrnIzhoF5y/jz0kdy8Cml0hexFOijhgpmKoE0d+AFq4dz+ZxCs5OgsE4Tp3LcLvR3yB0PpfusLMSnnVowVgg8FXqBC8dvlag69KJBEiWCoPHW/XOpAA0tXHYaGfEPgCoIrz732xE9oLG1FtNhQc7y9omq4fsmrDHmWAj7TQto5XkkLj5pPRd/oZNih6xWtyEzssU0Kzuo4eYoOCNUlAkOBCXhjWzO7AcGBn21lgudax4rwudjpR+gXOpZprZ3CXrN5S8Ode8uzQ4DOeOh3cMFZR1VWOaCGnX2R6nFLrw4tTnQHcy0yHtyWzh7dPdfLPZhmxBota5zzw7XtFzma3SP4rEObr0rMshjgu4CsFur/2hFhcL4l4C2gWFOH50zM7SDOf7CDiPjHluIRO+/iJEQSnpakxvTwO5VUkRX0B9WeoTDWgmxHnkLqNqnN0Wy6pxb0emd6UhyFNnIrz8NtchQdHgent0j7SHXxRCUrV+JYxlf+FUEaeg1iAqQbVrm7qMIzBlL3B/t8LCjty1tMgrvRO8P9dsnKCuwD1SOQalo3T1L134KC8gO3db
 GQh4WcLu
 9Yfa0rUTQUN8r7uu4VNmaQe9/p4kcVPKYh/LsEk/khVAi2KRMPhf+8e3VnXdohTz/SdU0hyDPBLnHf8lpQJomoypCc7smnNvd3zDLjk6PI3V4ei81k0wcEWuPzqZkX1Dc5ZhQ4YjDsN7LH+ccoFAJRfvwhr+mqDMrgr8yfD4TL8SYPRczTLW1XH515H+fbPPp1foW+LETZPkUvnIFC3dXAw+CPrQL3vTCzy4roGhKaG43ULkuikB3e9+p5RUWQ76qH2BGuQ4DBTZmrkeVFzd0jY0o7iVD37Im+vOwDfni4xA2lSu7Xy337gxd1+FgywSfJ/8L5ScmKvjS5PSTC/aRY9GHdIQHpCUnEYO3ZJ8Xvg4KxtgIrPbH3VBNulQVfm8+2oaapIbOb6XwxHqsaxYYqpiCQ3G14QJTYNhCa3oqIvT/xG9r2KSv4uKUMbXmlWKtXRbV8GvBNOWWHgPYoSEkd7nv1lwaT6kDn/MPMC9WKOU57tChngv9XEb4AiR0I85IdEf5ygpAEOvVON9YX+ofWie67z3JX49M5ipLrTZNlE7hfkaadaFiSrWR9xAzvjT8DM4Osn/6c/13vrAYgmQ2j4SfQPUA8vLtBC2gwDWeE21p3i0Y+5LHBDINMYcipOQjx0FltSfAxqsrbB189mlb7KK3b59oKFNOyifOLuAWKbpMg1wSZ/GAMgXjxC4QfsIiRWRIAJwIgKrh17K6yGFY96nzwCtxmcI1tVgTY/OfRGKlseM7noTinqQrT4qs/5OyA9wI76K9Q04gSB2RF+91qzQfO1B5Vprh6Wpf6aAZqgoa4XhjBTw+eFEliZn4axfvB633XhmwKcTww5YQEX28K3vujN3hq3n6MfmPpqOHYyShtguGx/xvGZNBCEe1gIMNSJjvFi/FMwXXNC+WghEf8CoZBcGX8KkyXL9UyiKmnpjeJPTUkvB+JETP05cDmP0J0ZlgVebobrWpoN8fwHIUeaiCIWne
 9MO59o+J
 Z4vxGddBg1BKsTcotzvRIjtid+YinLgvzFr13t36EQ6/sL+tLZ6eTV0aroiXo1HrmIym6pH3vMCdSowk7FxhcMi/14gqjsPBEvQrHn3iMmV1gLaU7vaykp1tqWDRWZRJ/8MQY+NOi5Sqk5CT4iCT8VxzijbtRX6vWTns+yD198Pk8GqqRsXTvYmR7kcPvqPKeEyuBBcgnaM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 5b45ea7dff3e..c5ca3b54c112 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -163,6 +163,69 @@ void ftrace_likely_update(struct ftrace_likely_data *f, int val,
 	__asm__ ("" : "=r" (var) : "0" (var))
 #endif
 
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
 #define __UNIQUE_ID(prefix) __PASTE(__PASTE(__UNIQUE_ID_, prefix), __COUNTER__)
 
 /**
-- 
2.39.5


