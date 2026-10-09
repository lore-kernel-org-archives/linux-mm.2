Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D625FCA601F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 18:21:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A1F16B0092; Fri,  9 Oct 2026 14:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92B916B009F; Fri,  9 Oct 2026 14:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8688D6B00A0; Fri,  9 Oct 2026 14:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4B1FB6B0092
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:21:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44940C049C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:21:52 +0000 (UTC)
X-FDA: 85303906464.10.9C175E1
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf07.hostedemail.com (Postfix) with ESMTP id 90DB740008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 18:21:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=wGDp88Ij;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf07.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791570110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RkhbRL4OIsL1Dxt9Yr/GvUlPu9lfUGNaz88z9suH4Ns=;
	b=6npM0X7W5E37LIKHxPtgoTmAibr9Av9o/AoYCnUyGD7j7MpFidu7BnHBV++IN3B1GY2Q1M
	Xohq2hvU3eu4lmro7qCOwoxuAPTcEprzVhQFNOQK/SxXoQLmtgJ2xrlg49LtKkAI4MYqhd
	u0yppdJSspm00lByRk0qWdR+EvxNQsc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=wGDp88Ij;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf07.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791570110;
	b=GzHUPMuj6k4zQCjoK7VYl3yttkTvQVKsCSSCOwxB9gEmKtQ3gGaYErj18gHU5MAEfRph3T
	5cozYLjL5d9WmQG0IXUQjUjj2PStEbBlmhtHb0ZGPjlcRbbMalizZ9B5gnpV5uMsBWnsfk
	e0k/L4tpsC6CkqkgJEGBVPZRNHmcbck=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1791570109;
	bh=RkhbRL4OIsL1Dxt9Yr/GvUlPu9lfUGNaz88z9suH4Ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wGDp88Ijydf2OOX5d6sOkDy8L+q/bKKrlG4MBY6dZ87c0/5x0o4ZyEdRQeSk4uQUo
	 0p1JeNVx9fXQFeMe6XBWHC3OLzSRav6YNhFL+N26Ve5vmXnmA9xA13H08fF9cz2pkV
	 Pf4osbCG9nTDWdCeWWR7p/TFnbII96jhHiSQ869r/M7owam2elhQ+GBVeNG7QWRajx
	 UW1//BCI+bgXEHigrIKgWGzuHd9H2BkfM0o7cGfG4r1MDa+uJ+1OJWXn+AjmbXkzk3
	 8oeAjTYgHuPKhYdsvM659UJbMqPxWphHkQy850ctq8ssXGirdm0TfmhOqTxuLBZfj3
	 of7vQdX69dpKg==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4j1ZvK5ZYNzlr3;
	Fri, 09 Oct 2026 14:21:49 -0400 (EDT)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E . McKenney" <paulmck@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Joel Fernandes <joel@joelfernandes.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Will Deacon <will@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	John Stultz <jstultz@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
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
	rcu@vger.kernel.org,
	linux-mm@kvack.org,
	lkmm@lists.linux.dev,
	Nikita Popov <github@npopov.com>,
	llvm@lists.linux.dev,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>
Subject: [PATCH hazptr v2 3/4] Documentation: RCU: Refer to ptr_eq()
Date: Fri,  9 Oct 2026 14:21:34 -0400
Message-ID: <20261009182142.6311-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261009182142.6311-1-mathieu.desnoyers@efficios.com>
References: <20261009182142.6311-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5seeath8jzuf3x8okr15zuf7xged4983
X-Rspam-User: 
X-Rspamd-Queue-Id: 90DB740008
X-Rspamd-Server: rspam08
X-HE-Tag: 1791570110-348950
X-HE-Meta: U2FsdGVkX19M1aJDX95SJsccPSTP4BDSifXQZaJRAdOISehu8bVNAcr99q+a6iuEcpByD+SWOl9XeGG0M6C6gyTQLJVLkXvFOsddiu+xHaRGF80DmxdWNsP2aH2K2JRKC8WuuIvplqTu39emt+bmrpXuKJhs+z/5WTCPpwkIIy+CbvPkQmm2yMWUnsj5GyXsESupq1ufKmCT6LVJI61URdMHbHlWHiylgXEXMTaXGTuzwDp1Cg+zW0ZHXkGAPiUtcIC5MsFbQ+6IOcvs4f2Bkeerqiv8lDS3nNjcmPl+myBUJyDzpfF1bhHV+UQp18l4RW8kv0eMyNderIRD4zUgwbtQUVjdzXzmQrKTZLd8LCl+86xPkY6V4cFzSlbJ7YwrOYLNOrrldYeuNtwVMjHeZz5xWVzUcYajuCb2ZMGuQL/Bv4aMLD1NURvGwVYGEq8aFtmdJB+xI6mVK3Rf2GILLzNvTkU+FfoBmtHYjk1Yf2YOXZewfo2nWGQXvVHIu7dwirogXJhHVLPoTu+2hezmM82b6wlE7O8XYBuzf4Dluy5912bNEtBihq1cKHv/GB4gPYNbsl2nRFx5cLB1oup0Aiydll/sJNxRXLyyngReGBM49QZOSO23pqiMsOHTP424oP6DJ4u6SJAkwMfY+hzauhgk09WEcxp2FqouKmPG+xX942XX/bpBhjauNnaAtsNBSqPbccVmEUmHrvLNzRfb7LS4rPySRZtRPpvjdw1rffe9/HvamNYpMCYQfrr638bazs4CzvCttzY+zST0Gg+/nWxiIqOGOdrStGlv/GTDhUqS2xxz/rVQDfjCjnFR98ismwj9oEk3rjr25dCm/BnwlEO7D1l3eIi09OfLxI0VJP4ZrA6bO4bLsONtEdjiFGOtgbCaXOcvhR46x75GQdoTDkMzm9AFFLIV3eibWr/vaFbr0QGBx0AapYpmYThK2q2cUTS4ryCdT06B7FH5KKe
 UJj3xKBY
 sfhQBIYID2uVMwfoqDPQPFg7dU4UjT2zTerjyiD/kMQItdIbxywlyJmMlXF/Eth7Pu+5SVWcOUvE8ZwIS5/gjgUDVTtCdYRs/WqyXslEzfZxnu7vZdg3980Lhce50MB6SS4OillANeDvnMhZQE9E8sk9ZWX8lfF83V1pt8PSX4tMj0qnbjxnDJBlpVxhgR7NPLPX5UGNOwfGdc6QvmUNDUkb0EMISciKpB22DAH4h9eNxMsir4IBl+iqSeygHlVx5ycf8kD6bZB9EuuhlxgbN5QQjHQis0IePZuV+KhSnJ9f0zpcHi+ziWS2v5NKPyfG+HslWrijDum50amnRFkEUaQA/DjELwLvX10Ndv33F6G3idISzDrpyP5SSB9DxNtbmAcDz0MHKnGNt75P7k6m5OPN4M7PFQbJiH+lTTyKJdvf3lWqQg9IpxUo/DzoZoiH5JChU9+cQ/UR6SDZwhfaC25rAEggM7BJXEzXx42/GAfJqKOiuhbgiOEvbgCMSjdrNaTfK5DJOtyiAOFuIOi47rHAZ1dFVDFgFCJtT0zHu9TiZliRPF+TOS3BTh+JLpwsu6Fih2LgJS3NDW354vxY+2psAZ3tNZIseoEUamTZ2KQbIIkplC7nNGDHWQw+e+tkXn030vbRnr1ECPDcjOIXkDmZpxDvkR9xuN4UmsiG+JkuSoLw89ejZ7jrGjyTwZmTnQal9HGzGREh9OX2RK8OYjWvJ/+cuiH8dgafm3DlAuWBiXdIWeWZmpqk0A6JWinVfGT9JRpJ948VGOZtbfGYjDhExfy0IXT9Sk5b73EYxmmR2kN+JQPWY6pqJ5ngDRsDwbjt2eEjAZhiU9NhZNskNwb0Nox3K/S1Sjs3BxsC9mTAMynh833Al9E8YVMhahesVH2C9Xky3JVU6cMPv98mAX4QNiZ3TmOg99B9ZQ7K+6NrSvz/k3E0PEGf3i1u2RGEisoI2JszSiQWfvegcKe9pSMw+Jt0r
 FT40ydtC
 u2tjfwGfqZSZ/N7pWlDRaxJ3YTcOhW27HbJzosZozXW/S3Fs/Qp0i6uT3SLEuchmJwIKU8YSHOuVfAwF39D7vd6n1iGpJ+5ak7M30qWkyxpA/YupJSi9Kqyfk725/W3yN/nZPy7wvno=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refer to ptr_eq() in the rcu_dereference() documentation.

ptr_eq() is a mechanism that preserves address dependencies when
comparing pointers, and should be favored when comparing a pointer
obtained from rcu_dereference() against another pointer.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
Reviewed-by: Joel Fernandes (Google) <joel@joelfernandes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Will Deacon <will@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: John Stultz <jstultz@google.com>
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
Cc: rcu@vger.kernel.org
Cc: linux-mm@kvack.org
Cc: lkmm@lists.linux.dev
Cc: Nikita Popov <github@npopov.com>
Cc: llvm@lists.linux.dev
Cc: Lian Wang <lianux.mm@gmail.com>
Cc: Kunwu Chan <kunwu.chan@gmail.com>
---
Changes since v1:
- Include feedback from Paul E. McKenney.

Changes since v0:
- Include feedback from Alan Stern.
---
 Documentation/RCU/rcu_dereference.rst | 38 +++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 5 deletions(-)

diff --git a/Documentation/RCU/rcu_dereference.rst b/Documentation/RCU/rcu_dereference.rst
index 5bc3785ebfc2..85b5f79ebf14 100644
--- a/Documentation/RCU/rcu_dereference.rst
+++ b/Documentation/RCU/rcu_dereference.rst
@@ -104,11 +104,12 @@ readers working properly:
 	after such branches, but can speculate loads, which can again
 	result in misordering bugs.
 
--	Be very careful about comparing pointers obtained from
-	rcu_dereference() against non-NULL values.  As Linus Torvalds
-	explained, if the two pointers are equal, the compiler could
-	substitute the pointer you are comparing against for the pointer
-	obtained from rcu_dereference().  For example::
+-	Use operations that preserve address dependencies (such as
+	"ptr_eq()") to compare pointers obtained from rcu_dereference()
+	against non-NULL pointers. As Linus Torvalds explained, if the
+	two pointers are equal, the compiler could substitute the
+	pointer you are comparing against for the pointer obtained from
+	rcu_dereference().  For example::
 
 		p = rcu_dereference(gp);
 		if (p == &default_struct)
@@ -125,6 +126,29 @@ readers working properly:
 	On ARM and Power hardware, the load from "default_struct.a"
 	can now be speculated, such that it might happen before the
 	rcu_dereference().  This could result in bugs due to misordering.
+	Performing the comparison with "ptr_eq()" ensures the compiler
+	does not perform such transformation.
+
+	If the comparison is against another pointer, the compiler is
+	allowed to use either pointer for the following accesses, which
+	loses the address dependency and allows weakly-ordered
+	architectures such as ARM and PowerPC to speculate the
+	address-dependent load before rcu_dereference().  For example::
+
+		p1 = READ_ONCE(gp);
+		p2 = rcu_dereference(gp);
+		if (p1 == p2)  /* BUGGY!!! */
+			do_default(p2->a);
+
+	The compiler can use p1->a rather than p2->a, destroying the
+	address dependency.  Performing the comparison with "ptr_eq()"
+	ensures the compiler preserves the address dependencies.
+	Corrected code::
+
+		p1 = READ_ONCE(gp);
+		p2 = rcu_dereference(gp);
+		if (ptr_eq(p1, p2))
+			do_default(p2->a);
 
 	However, comparisons are OK in the following cases:
 
@@ -204,6 +228,10 @@ readers working properly:
 		comparison will provide exactly the information that the
 		compiler needs to deduce the value of the pointer.
 
+	When in doubt, use operations that preserve address dependencies
+	(such as "ptr_eq()") to compare pointers obtained from
+	rcu_dereference() against non-NULL pointers.
+
 -	Disable any value-speculation optimizations that your compiler
 	might provide, especially if you are making use of feedback-based
 	optimizations that take data collected from prior runs.  Such
-- 
2.43.0


