Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A01C3C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 17:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AF326B008A; Sat, 19 Sep 2026 13:56:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85F356B008C; Sat, 19 Sep 2026 13:56:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 726F46B0092; Sat, 19 Sep 2026 13:56:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 474E26B008A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:56:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 06CA51A01B5
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:56:04 +0000 (UTC)
X-FDA: 85231265448.08.A628383
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2AF281C0002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:56:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WPL4DB0A;
	spf=pass (imf18.hostedemail.com: domain of "SRS0=+MjM=HL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=+MjM=HL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789840562;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D5A8rSV9jT6XJngBlUidyZhfJThdvPs75VMBuPMpEFI=;
	b=AImTkRx/gegx3SmDkjZtOM23govlMIQJ9EFfQjXr8iDpJCvId54SWUS4JbM+No7Eg3rVZE
	NgFD+JZIebtOUBwNIl+/+86BmVUcUyJi08rBK57uB/1CWEyld8q0LwGtQDuTv2umEWmRs6
	hqzz8+Wp2mtUn0sMX2VQJjVwlEfWAcc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789840562;
	b=Be5a74/y3nJHawTlagzhdiI7xCvBX4KvPbaaMh5JtiVGWq2eT2EfJQr5jOVy6QC/HCB0SC
	XlDo8Qck0JZooDgp+BqAfJn/ZFdhZDeiD1opEEZSE4zgbTVBn1qytc58OSOYz5VaNn/cMd
	erxKTtu/Q6HxA/PITOBM9xamI2paJ6w=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WPL4DB0A;
	spf=pass (imf18.hostedemail.com: domain of "SRS0=+MjM=HL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org" designates 172.234.252.31 as permitted sender) smtp.mailfrom="SRS0=+MjM=HL=paulmck-ThinkPad-P17-Gen-1.home=paulmck@kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0EACA43A9F;
	Sat, 19 Sep 2026 17:56:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B941F000FF;
	Sat, 19 Sep 2026 17:56:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789840560;
	bh=D5A8rSV9jT6XJngBlUidyZhfJThdvPs75VMBuPMpEFI=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To;
	b=WPL4DB0ArORKBc24ai/jlcP1HNn0SPAZXdU+ME8LQcq0FUAd3fciD1AHEEwQaYl2E
	 ugVEYWUEgpkx8ew9gxJdd7qF7PYOgRuhg1TmSysq//hW/QaRNJVEaoFbPQbifdzdUg
	 j3yExFzDpna4izZrZfDug7Yqrv2dTIZYz/TkO0778AeBcRRP3A4i7oNkfL1b5vs196
	 EZbseBJ6ZlKEYjyE6LOnASJTKPkPCQwxWaH0by8tl1P9a29qryZ+RS6T2YvQLoS+Yr
	 HJA52CTZI49Cz7I8HIYBEu6SRPIqqiMmelQxTNmUDuJvcYKQzcO9A+antJ+5kbWb6c
	 SNGB4ff5L1uTQ==
Received: by paulmck-ThinkPad-P17-Gen-1.home (Postfix, from userid 1000)
	id A27D6CE1579; Sat, 19 Sep 2026 10:56:00 -0700 (PDT)
Date: Sat, 19 Sep 2026 10:56:00 -0700
From: "Paul E. McKenney" <paulmck@kernel.org>
To: Bradley Morgan <brads@mainlining.org>
Cc: rcu@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Boqun Feng <boqun@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	lkmm@lists.linux.dev, Zqiang <qiang.zhang@linux.dev>,
	Wang Lian <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
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
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Zqiang <qiang.zhang1211@gmail.com>, Ingo Molnar <mingo@redhat.com>,
	Waiman Long <longman@redhat.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>, maged.michael@gmail.com,
	Mateusz Guzik <mjguzik@gmail.com>,
	Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>,
	linux-mm@kvack.org
Subject: Re: [PATCH 01/28] hazptr: Implement Hazard Pointers
Message-ID: <f8624513-1bc8-457b-8f8e-a47dc13a635b@paulmck-laptop>
Reply-To: paulmck@kernel.org
References: <e9669b34-12c2-4cf2-a887-315f581f0789@paulmck-laptop>
 <20260919000056.3132131-1-paulmck@kernel.org>
 <183D0BFB-F900-4AFD-B7CA-6D63591FA26B@mainlining.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <183D0BFB-F900-4AFD-B7CA-6D63591FA26B@mainlining.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: e9aer4oddgm6xnutce6ibbpcjtcm3apx
X-Rspamd-Queue-Id: 2AF281C0002
X-HE-Tag: 1789840562-799443
X-HE-Meta: U2FsdGVkX1/8cbLDJuSGaXG9G0Mn4K0sNLm8e4Gk63KAR6QmQf+iM559c3bz077CkP7s/iFxt6V3ug6u3g951g7Ptn0vUsH0UCSZuLX3bTKL4DObe6tISSHrq1x7LLdeSFGdEjUzPbdjbYvebfYcSq5dPPC9y/J7ZNtNMvumkQ6Gat+43WFY8N8sTCvENIVyU0BCFjzqPIEXSvEnNn58qILAMXwminDQ9t/M+ZWP4lJf8Ym1n1W6Eh76k+4xdHsjbGn0BEWC0zJjb1nieopZIAJWKtaKhnYcjIv7+/xo+SA+1SvM4Z+Z/ZPMmBhd72L/4EBH7SxJ8m/oEDw1zqMEKPKGaAA4MZ7FzXi5M6QBp04Ms6D8AQw031PRfVUTE2FybzYu7EDXoA+FXABRe0O8iypJb8imIqf9JYO4NABS969OAplkHir9Kni0dEuD9HaFQZ2CYX4eGwpRoze/GSdCyrRn4+Eaz8FQ0R1p2YgITEIeEOCZfFXH+d5bQuORSpv0BlO3WVtxMssGrKHftfgYc0nGeJV7mYiqtRMrrP1QcWDJAfOkP9DCwTItvoyASw6FBwFcBkadxJXHO8fUzfjzvGsWBxW11/YDaFxdQJNsGFmiA32D9BF/cCmR2Mz9MRmPRqVrsEPU2y/E2MLoEtHdOjkrRMVm+BbO7ExjfTER3Hot0HOmuBgHQ9iRY7FICpuv91E+WpdJHdnTTkUjr8kXVqP9VhvigIh2EmrTJoqEf+wLkgKGSTVdYFPZ/Sxtgws/mUiUdbtkc+Js8L/QOx2WaxPR+F98VwENgdH3e8RrqFf+05SFJNB47qSL9SIc6zjRPfDc93AsMRTIrM9eu77EjdkhASaPzJdGQ1jXRlpQKSXWzs4Bg3DV4kjU8V16VYxlUkGIRpsO7ShP9cCAAipRiCpJvTVCukVS+hFblT1WfVqbEFaXcNFhXoQjwEysaYWK9JWrvBGPy8OP6N1qQCQ
 j160A7LX
 7JF4Mn4ZjCvEJ3LHCIh2MCH3eAMj7XK1b3hC7uZjmLCVT8xKDoC13LTdptNvjynML54cI8f3htrLTioVLd9JVIQQT4MUXURmqZXRnY4WYxpSY1DLv57K7Se4jDYE/ne+0lsaacFcLRQrmAPXfbBv28f0ifHPag+i+fHwu9HLegDLnXLGUn/FKImvrDzuo4Z4n+YqYnotNKHyBNtXRgQnxXISZBOj8HVs3QX7cnuk6pR3ZbnGovuLVCZT23W3COk3eqAB/Q3UM+EN8LgJniEJgA9fsxIeVHEDQ7DO3rHh1H5gzIV+YVXmhOh/DzUhIa5VmuRaups/x/zngK3by/nbEkjMstw/BKz5ANiCJltF6oz1kIOwd9XPoPLeme6YYTKIxU/AXmJkH7A4cHMtLTwWih4PEHXGWcaDneJOsz+p4foO1WAGhIO6azq6qed6qiRPZkjgpXg6MH+BGJ4/2S0IecGEOGjCAkIPQb0rVaLor/hQdq0+k+3TMKFnYxXuM8qZNgSDl5zwETcqdlsEeMTieWG9asso1QxvDTtdHxz5IXh6E9AWzGpbZmXBVWWpkU6rVG7LEGPHU0FfQ21NuIslsaI/y0OGsq3qGO534HzfinqkzZ96ktWx4alhOH6ULrsQoSnAvbGcYAdyXY5fNpnmr2jM4gBagJQaQcaEnhIhIOLZ9TuoJK0Tz5pjuBPWJL4DuGChAiu0xGuW5hlfEFcgbHrbp+OllYzeIdhiePbVlr9PooNWftUkjGp2VTciyNJDaTZ1Zms92Z+N9zZCB8o5rf4qcfO2atef5krT4/miOm8wBtqfzGytiBKThx1QqwpYbPaCF/9GCilo0IKg5XsX7dii5bB93Mia8x3lcu/kbTddYi0lOkVJvqhBemWuAPugAo+Wppxr0FLF4QxVp2QRCLIEg6sHqRwtIqHpekbQGK9tsvzJn9McFLc8CMHtv92rRsV6MnqsLb0R8iI7zl5lEAenfzMQz
 ddVyKinY
 CZWtE+9UkB+CKBLB0N+MtISynu2AWwv6CYqhYcZ9joOmvHDu1n3AGWXFuk4bBRq83N1KftaeOWxrEfAqjgdxFLCGXrAQdXUcymGv0ukbEc0RNv84H8x1ONuzi2oxC67RcjQYbQq5sMhjKkj+L7x303Orl30o/ZwMhKFTCPjSt7uIletmEg5ncKaSAiSWGxYr4/sIwRPsLumI2icFTRCdUkd2Idyr/we9RE2rV7PB74UozFV6jKU2n5HAxYqlzPchN9dZx7L2UKgZa4ogJUEudO8kuyFW9NdPkkcXUdzN+Fl2OtigtzEA7eobdbwBJvdEL00I+V3vjEQrjijc7pVRl3eTmONXZvOSIJfpe18zt0k4s9n7zCRwQQQB7O/hNjNG7HB835+6s3mIkzF4YedXgpOZdJH1ASSaNPk7AeTnJeRYVdOR6AYv4Iufmr7bEkb7kGy4dUfDA4veo8mP1rLb5Nhxb5wKM2ghgnDfH/kiVtOvt4N8Q6ovc78khkN1rhOd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 05:41:06PM +0100, Bradley Morgan wrote:
> On 19 September 2026 01:00:29 BST, "Paul E. McKenney" <paulmck@kernel.org>
> wrote:
> >From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >
> >This API provides existence guarantees of objects through Hazard
> >Pointers [1] (hazptr).
> >
> >Its main benefit over RCU is that it allows fast reclaim of
> >HP-protected pointers without needing to wait for a grace period.
> >
> >This implementation has 4 statically allocated hazard pointer slots per
> >cpu for the fast path, and relies on a on-stack backup slot allocated by
> >the hazard pointer user as fallback in case no per-cpu slot is
> >available.
> >
> >It integrates with the scheduler to migrate per-CPU slots to the backup
> >slot on context switch. This ensures that the per-CPU slots won't be
> >used by blocked or preempted tasks holding on hazard pointers for a long
> >time.
> >
> >References:
> >
> >[1]: M. M. Michael, "Hazard pointers: safe memory reclamation for
> >     lock-free objects," in IEEE Transactions on Parallel and
> >     Distributed Systems, vol. 15, no. 6, pp. 491-504, June 2004
> 
> Sorry for the quick reply, could we add some sort of a maintainers entry
> here?
> 
> I feel as when in like 10 years, there's a huge bug in hazptr, and mat
> can't respond cuz he changes email, then that's not good.

Maged's hazard-pointers implementation works just fine, within its area
of applicability.  As I recall, Boqun and/or Mathieu departed from
it a bit to simplify the lockdep use case.  From the perspective of
this one use case, this simplification is more a restriction than bug.
But Maged would no doubt be quick to point out that from the perspective
of other use cases, this is a bug rather than a simplification.  So it
will likely need to be fixed sooner rather than later.

And Maged is aware of this effort, in fact, I had lunch with him earlier
this week [1].  Every time that I have asked, he has indicated that he
has absolutely no interest in becoming a Linux-kernel maintainer.  ;-)

Which is fair, given that Maged has other fish to fry.

							Thanx, Paul

[1] https://cppcon2026.sched.com/event/2RT65/interesting-upcoming-low-latency-networking-concurrency-and-parallelism-features-from-kona-2025-croydon-2026-and-brno-2026

> >Link: https://lpc.events/event/19/contributions/2082/
> >Link: https://lore.kernel.org/lkml/j3scdl5iymjlxavomgc6u5ndg3svhab6ga23dr36o4f5mt333w@7xslvq6b6hmv/
> >Link: https://lpc.events/event/18/contributions/1731/
> >Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >Cc: Nicholas Piggin <npiggin@gmail.com>
> >Cc: Michael Ellerman <mpe@ellerman.id.au>
> >Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> >Cc: "Paul E. McKenney" <paulmck@kernel.org>
> >Cc: Will Deacon <will@kernel.org>
> >Cc: Peter Zijlstra <peterz@infradead.org>
> >Cc: Boqun Feng <boqun@kernel.org>
> >Cc: Alan Stern <stern@rowland.harvard.edu>
> >Cc: John Stultz <jstultz@google.com>
> >Cc: Linus Torvalds <torvalds@linux-foundation.org>
> >Cc: Andrew Morton <akpm@linux-foundation.org>
> >Cc: Frederic Weisbecker <frederic@kernel.org>
> >Cc: Joel Fernandes <joel@joelfernandes.org>
> >Cc: Josh Triplett <josh@joshtriplett.org>
> >Cc: Uladzislau Rezki <urezki@gmail.com>
> >Cc: Steven Rostedt <rostedt@goodmis.org>
> >Cc: Lai Jiangshan <jiangshanlai@gmail.com>
> >Cc: Zqiang <qiang.zhang1211@gmail.com>
> >Cc: Ingo Molnar <mingo@redhat.com>
> >Cc: Waiman Long <longman@redhat.com>
> >Cc: Mark Rutland <mark.rutland@arm.com>
> >Cc: Thomas Gleixner <tglx@linutronix.de>
> >Cc: Vlastimil Babka <vbabka@suse.cz>
> >Cc: maged.michael@gmail.com
> >Cc: Mateusz Guzik <mjguzik@gmail.com>
> >Cc: Jonas Oberhauser <jonas.oberhauser@huaweicloud.com>
> >Cc: <rcu@vger.kernel.org>
> >Cc: <linux-mm@kvack.org>
> >Cc: <lkmm@lists.linux.dev>
> >Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
> >---
> > include/linux/hazptr.h | 197 +++++++++++++++++++++++++++++++++
> > init/main.c            |   2 +
> > kernel/Makefile        |   2 +-
> > kernel/hazptr.c        | 242 +++++++++++++++++++++++++++++++++++++++++
> > kernel/sched/core.c    |   2 +
> > 5 files changed, 444 insertions(+), 1 deletion(-)
> > create mode 100644 include/linux/hazptr.h
> > create mode 100644 kernel/hazptr.c
> >
> >diff --git a/include/linux/hazptr.h b/include/linux/hazptr.h
> >new file mode 100644
> >index 000000000000..b121f7779cda
> >--- /dev/null
> >+++ b/include/linux/hazptr.h
> >@@ -0,0 +1,197 @@
> >+// SPDX-License-Identifier: LGPL-2.1-or-later
> >+//
> >+// SPDX-FileCopyrightText: 2024 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >+
> >+#ifndef _LINUX_HAZPTR_H
> >+#define _LINUX_HAZPTR_H
> >+
> >+/*
> >+ * hazptr: Hazard Pointers
> >+ *
> >+ * This API provides existence guarantees of objects through hazard
> >+ * pointers.
> >+ *
> >+ * Its main benefit over RCU is that it allows fast reclaim of
> >+ * HP-protected pointers without needing to wait for a grace period.
> >+ *
> >+ * References:
> >+ *
> >+ * [1]: M. M. Michael, "Hazard pointers: safe memory reclamation for
> >+ *      lock-free objects," in IEEE Transactions on Parallel and
> >+ *      Distributed Systems, vol. 15, no. 6, pp. 491-504, June 2004
> >+ */
> >+
> >+#include <linux/percpu.h>
> >+#include <linux/types.h>
> >+#include <linux/cleanup.h>
> >+#include <linux/sched.h>
> >+
> >+/* 4 slots (each sizeof(hazptr_slot_item)) fit in a single 64-byte cache line. */
> >+#define NR_HAZPTR_PERCPU_SLOTS	4
> >+#define HAZPTR_WILDCARD		((void *) 0x1UL)
> >+
> >+/*
> >+ * Hazard pointer slot.
> >+ */
> >+struct hazptr_slot {
> >+	void *addr;
> >+};
> >+
> >+struct hazptr_overflow_list;
> >+
> >+struct hazptr_backup_slot {
> >+	struct hlist_node overflow_node;
> >+	struct hazptr_slot slot;
> >+	/* Overflow list where the backup slot is added. */
> >+	struct hazptr_overflow_list *overflow_list;
> >+};
> >+
> >+struct hazptr_ctx {
> >+	struct hazptr_slot *slot;
> >+	/* Backup slot in case all per-CPU slots are used. */
> >+	struct hazptr_backup_slot backup_slot;
> >+	struct hlist_node preempt_node;
> >+};
> >+
> >+struct hazptr_slot_ctx {
> >+	struct hazptr_ctx *ctx;
> >+};
> >+
> >+struct hazptr_slot_item {
> >+	struct hazptr_slot slot;
> >+	struct hazptr_slot_ctx ctx;
> >+};
> >+
> >+struct hazptr_percpu_slots {
> >+	struct hazptr_slot_item items[NR_HAZPTR_PERCPU_SLOTS];
> >+} ____cacheline_aligned;
> >+
> >+DECLARE_PER_CPU(struct hazptr_percpu_slots, hazptr_percpu_slots);
> >+
> >+void *__hazptr_acquire(struct hazptr_ctx *ctx, void * const *addr_p);
> >+
> >+/*
> >+ * hazptr_synchronize: Wait until @addr is released from all slots.
> >+ *
> >+ * Wait to observe that each slot contains a value that differs from
> >+ * @addr before returning.
> >+ * Should be called from preemptible context.
> >+ */
> >+void hazptr_synchronize(void *addr);
> >+
> >+/*
> >+ * hazptr_chain_backup_slot: Chain backup slot into overflow list.
> >+ *
> >+ * Set backup slot address to @addr, and chain it into the overflow
> >+ * list.
> >+ */
> >+struct hazptr_slot *hazptr_chain_backup_slot(struct hazptr_ctx *ctx);
> >+
> >+/*
> >+ * hazptr_unchain_backup_slot: Unchain backup slot from overflow list.
> >+ */
> >+void hazptr_unchain_backup_slot(struct hazptr_ctx *ctx);
> >+
> >+static inline
> >+bool hazptr_slot_is_backup(struct hazptr_ctx *ctx, struct hazptr_slot *slot)
> >+{
> >+	return slot == &ctx->backup_slot.slot;
> >+}
> >+
> >+static inline
> >+void hazptr_note_context_switch(void)
> >+{
> >+	struct hazptr_percpu_slots *percpu_slots = this_cpu_ptr(&hazptr_percpu_slots);
> >+	unsigned int idx;
> >+
> >+	for (idx = 0; idx < NR_HAZPTR_PERCPU_SLOTS; idx++) {
> >+		struct hazptr_slot_item *item = &percpu_slots->items[idx];
> >+		struct hazptr_slot *slot = &item->slot, *backup_slot;
> >+		struct hazptr_ctx *ctx;
> >+
> >+		if (!slot->addr)
> >+			continue;
> >+		ctx = item->ctx.ctx;
> >+		backup_slot = hazptr_chain_backup_slot(ctx);
> >+		/*
> >+		 * Move hazard pointer from the per-CPU slot to the
> >+		 * backup slot. This requires hazard pointer
> >+		 * synchronize to iterate on per-CPU slots with
> >+		 * load-acquire before iterating on the overflow list.
> >+		 */
> >+		WRITE_ONCE(backup_slot->addr, slot->addr);
> >+		/*
> >+		 * store-release orders store to backup slot addr before
> >+		 * store to per-CPU slot addr.
> >+		 */
> >+		smp_store_release(&slot->addr, NULL);
> >+		/* Use the backup slot for context. */
> >+		ctx->slot = backup_slot;
> >+	}
> >+}
> >+
> >+/*
> >+ * hazptr_acquire: Load pointer at address and protect with hazard pointer.
> >+ *
> >+ * Load @addr_p, and protect the loaded pointer with hazard pointer.
> >+ * When using hazptr_acquire from interrupt handlers, the acquired slots
> >+ * need to be released before returning from the interrupt handler.
> >+ *
> >+ * Returns a non-NULL protected address if the loaded pointer is non-NULL.
> >+ * Returns NULL if the loaded pointer is NULL.
> >+ *
> >+ * On success the protected hazptr slot is stored in @ctx->slot.
> >+ */
> >+static inline
> >+void *hazptr_acquire(struct hazptr_ctx *ctx, void * const *addr_p)
> >+{
> >+	struct hazptr_percpu_slots *percpu_slots;
> >+	struct hazptr_slot_item *slot_item;
> >+	struct hazptr_slot *slot;
> >+	void *addr;
> >+
> >+	guard(preempt)();
> >+	percpu_slots = this_cpu_ptr(&hazptr_percpu_slots);
> >+	slot_item = &percpu_slots->items[0];
> >+	slot = &slot_item->slot;
> >+	if (unlikely(slot->addr))
> >+		return __hazptr_acquire(ctx, addr_p);
> >+	WRITE_ONCE(slot->addr, HAZPTR_WILDCARD);	/* Store B */
> >+
> >+	/* Memory ordering: Store B before Load A. */
> >+	smp_mb();
> >+
> >+	/*
> >+	 * Load @addr_p after storing wildcard to the hazard pointer slot.
> >+	 */
> >+	addr = READ_ONCE(*addr_p);	/* Load A */
> >+
> >+	/*
> >+	 * We don't care about ordering of Store C. It will simply
> >+	 * replace the wildcard by a more specific address. If addr is
> >+	 * NULL, we simply store NULL into the slot.
> >+	 */
> >+	WRITE_ONCE(slot->addr, addr);	/* Store C */
> >+	slot_item->ctx.ctx = ctx;
> >+	ctx->slot = slot;
> >+	return addr;
> >+}
> >+
> >+/* Release the protected hazard pointer from @slot. */
> >+static inline
> >+void hazptr_release(struct hazptr_ctx *ctx, void *addr)
> >+{
> >+	struct hazptr_slot *slot;
> >+
> >+	if (!addr)
> >+		return;
> >+	guard(preempt)();
> >+	slot = ctx->slot;
> >+	smp_store_release(&slot->addr, NULL);
> >+	if (unlikely(hazptr_slot_is_backup(ctx, slot)))
> >+		hazptr_unchain_backup_slot(ctx);
> >+}
> >+
> >+void hazptr_init(void);
> >+
> >+#endif /* _LINUX_HAZPTR_H */
> >diff --git a/init/main.c b/init/main.c
> >index 2613d3f9b3ce..d9d936707c19 100644
> >--- a/init/main.c
> >+++ b/init/main.c
> >@@ -108,6 +108,7 @@
> > #include <linux/time_namespace.h>
> > #include <linux/unaligned.h>
> > #include <linux/vdso_datastore.h>
> >+#include <linux/hazptr.h>
> > #include <net/net_namespace.h>
> > 
> > #include <asm/io.h>
> >@@ -1075,6 +1076,7 @@ void start_kernel(void)
> > 	workqueue_init_early();
> > 
> > 	rcu_init();
> >+	hazptr_init();
> > 	kvfree_rcu_init();
> > 
> > 	/* Trace events are available after this */
> >diff --git a/kernel/Makefile b/kernel/Makefile
> >index 1e1a31673577..8961c8660d0d 100644
> >--- a/kernel/Makefile
> >+++ b/kernel/Makefile
> >@@ -7,7 +7,7 @@ obj-y     = fork.o exec_domain.o exec_state.o panic.o \
> > 	    cpu.o exit.o softirq.o resource.o \
> > 	    sysctl.o capability.o ptrace.o user.o \
> > 	    signal.o sys.o umh.o workqueue.o pid.o task_work.o \
> >-	    extable.o params.o \
> >+	    extable.o params.o hazptr.o \
> > 	    kthread.o sys_ni.o nsproxy.o nstree.o nscommon.o \
> > 	    notifier.o ksysfs.o cred.o reboot.o \
> > 	    async.o range.o smpboot.o ucount.o regset.o ksyms_common.o
> >diff --git a/kernel/hazptr.c b/kernel/hazptr.c
> >new file mode 100644
> >index 000000000000..a9d3d68a1525
> >--- /dev/null
> >+++ b/kernel/hazptr.c
> >@@ -0,0 +1,242 @@
> >+// SPDX-License-Identifier: LGPL-2.1-or-later
> >+//
> >+// SPDX-FileCopyrightText: 2024 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> >+
> >+/*
> >+ * hazptr: Hazard Pointers
> >+ */
> >+
> >+#include <linux/hazptr.h>
> >+#include <linux/percpu.h>
> >+#include <linux/spinlock.h>
> >+#include <linux/mutex.h>
> >+#include <linux/list.h>
> >+#include <linux/export.h>
> >+
> >+struct hazptr_overflow_list {
> >+	raw_spinlock_t lock;		/* Lock protecting overflow list and list generation. */
> >+	struct hlist_head head;		/* Overflow list head. */
> >+	uint64_t gen;			/* Overflow list generation. */
> >+};
> >+
> >+/*
> >+ * Flip between two lists to guarantee list scan forward progress even
> >+ * with frequent generation counter increments. The list additions are
> >+ * always done on a different list than the one used for scan. The scan
> >+ * successively iterates on both lists. Therefore, only list removals
> >+ * can cause the iteration to retry, and the number of removals is
> >+ * limited to the number of list elements.
> >+ */
> >+struct hazptr_overflow_list_flip {
> >+	struct mutex lock;		/* Mutex protecting add_idx from concurrent updates. */
> >+	unsigned int add_idx;		/* Index of current flip-list to add to. */
> >+	struct hazptr_overflow_list array[2];
> >+};
> >+
> >+static DEFINE_PER_CPU(struct hazptr_overflow_list_flip, percpu_overflow_list_flip);
> >+
> >+DEFINE_PER_CPU(struct hazptr_percpu_slots, hazptr_percpu_slots);
> >+EXPORT_PER_CPU_SYMBOL_GPL(hazptr_percpu_slots);
> >+
> >+static
> >+struct hazptr_slot *hazptr_get_free_percpu_slot(struct hazptr_ctx *ctx)
> >+{
> >+	struct hazptr_percpu_slots *percpu_slots = this_cpu_ptr(&hazptr_percpu_slots);
> >+	unsigned int idx;
> >+
> >+	for (idx = 0; idx < NR_HAZPTR_PERCPU_SLOTS; idx++) {
> >+		struct hazptr_slot_item *item = &percpu_slots->items[idx];
> >+		struct hazptr_slot *slot = &item->slot;
> >+
> >+		if (!slot->addr) {
> >+			item->ctx.ctx = ctx;
> >+			return slot;
> >+		}
> >+	}
> >+	/* All slots are in use. */
> >+	return NULL;
> >+}
> >+
> >+/*
> >+ * Hazard pointer acquire slow path.
> >+ * Called with preemption disabled.
> >+ */
> >+void *__hazptr_acquire(struct hazptr_ctx *ctx, void * const *addr_p)
> >+{
> >+	struct hazptr_slot *slot = hazptr_get_free_percpu_slot(ctx);
> >+	void *addr;
> >+
> >+	/*
> >+	 * If all the per-CPU slots are already in use, fallback
> >+	 * to the backup slot.
> >+	 */
> >+	if (unlikely(!slot))
> >+		slot = hazptr_chain_backup_slot(ctx);
> >+	WRITE_ONCE(slot->addr, HAZPTR_WILDCARD);	/* Store B */
> >+
> >+	/* Memory ordering: Store B before Load A. */
> >+	smp_mb();
> >+
> >+	/*
> >+	 * Load @addr_p after storing wildcard to the hazard pointer slot.
> >+	 */
> >+	addr = READ_ONCE(*addr_p);	/* Load A */
> >+
> >+	/*
> >+	 * We don't care about ordering of Store C. It will simply
> >+	 * replace the wildcard by a more specific address. If addr is
> >+	 * NULL, we simply store NULL into the slot.
> >+	 */
> >+	WRITE_ONCE(slot->addr, addr);	/* Store C */
> >+	ctx->slot = slot;
> >+	if (!addr && hazptr_slot_is_backup(ctx, slot))
> >+		hazptr_unchain_backup_slot(ctx);
> >+	return addr;
> >+}
> >+EXPORT_SYMBOL_GPL(__hazptr_acquire);
> >+
> >+/*
> >+ * Perform piecewise iteration on overflow list waiting until "addr" is
> >+ * not present. Raw spinlock is released and taken between each list
> >+ * item and busy loop iteration. The overflow list generation is checked
> >+ * each time the lock is taken to validate that the list has not changed
> >+ * before resuming iteration or busy wait. If the generation has
> >+ * changed, retry the entire list traversal.
> >+ */
> >+static
> >+void hazptr_synchronize_overflow_list(struct hazptr_overflow_list *overflow_list, void *addr)
> >+{
> >+	struct hazptr_backup_slot *backup_slot;
> >+	uint64_t snapshot_gen;
> >+	unsigned long flags;
> >+
> >+	raw_spin_lock_irqsave(&overflow_list->lock, flags);
> >+retry:
> >+	snapshot_gen = overflow_list->gen;
> >+	hlist_for_each_entry(backup_slot, &overflow_list->head, overflow_node) {
> >+		/* Busy-wait if node is found. */
> >+		for (;;) {
> >+			void *load_addr = smp_load_acquire(&backup_slot->slot.addr);	/* Load B */
> >+
> >+			if (load_addr != addr && load_addr != HAZPTR_WILDCARD)
> >+				break;
> >+			raw_spin_unlock_irqrestore(&overflow_list->lock, flags);
> >+			cpu_relax();
> >+			raw_spin_lock_irqsave(&overflow_list->lock, flags);
> >+			if (overflow_list->gen != snapshot_gen)
> >+				goto retry;
> >+		}
> >+		raw_spin_unlock_irqrestore(&overflow_list->lock, flags);
> >+		/*
> >+		 * Release raw spinlock, validate generation after
> >+		 * re-acquiring the lock.
> >+		 */
> >+		raw_spin_lock_irqsave(&overflow_list->lock, flags);
> >+		if (overflow_list->gen != snapshot_gen)
> >+			goto retry;
> >+	}
> >+	raw_spin_unlock_irqrestore(&overflow_list->lock, flags);
> >+}
> >+
> >+static
> >+void hazptr_synchronize_cpu_slots(int cpu, void *addr)
> >+{
> >+	struct hazptr_percpu_slots *percpu_slots = per_cpu_ptr(&hazptr_percpu_slots, cpu);
> >+	unsigned int idx;
> >+
> >+	for (idx = 0; idx < NR_HAZPTR_PERCPU_SLOTS; idx++) {
> >+		struct hazptr_slot_item *item = &percpu_slots->items[idx];
> >+
> >+		/* Busy-wait if node is found. */
> >+		smp_cond_load_acquire(&item->slot.addr, VAL != addr && VAL != HAZPTR_WILDCARD); /* Load B */
> >+	}
> >+}
> >+
> >+/*
> >+ * hazptr_synchronize: Wait until @addr is released from all slots.
> >+ *
> >+ * Wait to observe that each slot contains a value that differs from
> >+ * @addr before returning.
> >+ * Should be called from preemptible context.
> >+ */
> >+void hazptr_synchronize(void *addr)
> >+{
> >+	int cpu;
> >+
> >+	/*
> >+	 * Busy-wait should only be done from preemptible context.
> >+	 */
> >+	lockdep_assert_preemption_enabled();
> >+
> >+	/*
> >+	 * Store A precedes hazptr_scan(): it unpublishes addr (sets it to
> >+	 * NULL or to a different value), and thus hides it from hazard
> >+	 * pointer readers.
> >+	 */
> >+	if (!addr)
> >+		return;
> >+	/* Memory ordering: Store A before Load B. */
> >+	smp_mb();
> >+	/* Scan all CPUs slots. */
> >+	for_each_possible_cpu(cpu) {
> >+		struct hazptr_overflow_list_flip *overflow_list_flip = per_cpu_ptr(&percpu_overflow_list_flip, cpu);
> >+		unsigned int scan_idx;
> >+
> >+		/* Scan CPU slots. */
> >+		hazptr_synchronize_cpu_slots(cpu, addr);
> >+
> >+		/*
> >+		 * Scan backup slots in percpu overflow lists.
> >+		 * Forward progress is guaranteed by scanning one list
> >+		 * while new elements are added into the other list.
> >+		 */
> >+		guard(mutex)(&overflow_list_flip->lock);
> >+		scan_idx = overflow_list_flip->add_idx ^ 1;
> >+		hazptr_synchronize_overflow_list(&overflow_list_flip->array[scan_idx], addr);
> >+		/* Flip current list. */
> >+		WRITE_ONCE(overflow_list_flip->add_idx, scan_idx);
> >+		hazptr_synchronize_overflow_list(&overflow_list_flip->array[scan_idx ^ 1], addr);
> >+	}
> >+}
> >+EXPORT_SYMBOL_GPL(hazptr_synchronize);
> >+
> >+struct hazptr_slot *hazptr_chain_backup_slot(struct hazptr_ctx *ctx)
> >+{
> >+	struct hazptr_overflow_list_flip *overflow_list_flip = this_cpu_ptr(&percpu_overflow_list_flip);
> >+	unsigned int list_idx = READ_ONCE(overflow_list_flip->add_idx);
> >+	struct hazptr_overflow_list *overflow_list = &overflow_list_flip->array[list_idx];
> >+	struct hazptr_slot *slot = &ctx->backup_slot.slot;
> >+
> >+	slot->addr = NULL;
> >+	guard(raw_spinlock_irqsave)(&overflow_list->lock);
> >+	overflow_list->gen++;
> >+	hlist_add_head(&ctx->backup_slot.overflow_node, &overflow_list->head);
> >+	ctx->backup_slot.overflow_list = overflow_list;
> >+	return slot;
> >+}
> >+EXPORT_SYMBOL_GPL(hazptr_chain_backup_slot);
> >+
> >+void hazptr_unchain_backup_slot(struct hazptr_ctx *ctx)
> >+{
> >+	struct hazptr_overflow_list *overflow_list = ctx->backup_slot.overflow_list;
> >+
> >+	guard(raw_spinlock_irqsave)(&overflow_list->lock);
> >+	overflow_list->gen++;
> >+	hlist_del(&ctx->backup_slot.overflow_node);
> >+}
> >+EXPORT_SYMBOL_GPL(hazptr_unchain_backup_slot);
> >+
> >+void __init hazptr_init(void)
> >+{
> >+	int cpu;
> >+
> >+	for_each_possible_cpu(cpu) {
> >+		struct hazptr_overflow_list_flip *overflow_list_flip = per_cpu_ptr(&percpu_overflow_list_flip, cpu);
> >+
> >+		mutex_init(&overflow_list_flip->lock);
> >+		for (int i = 0; i < 2; i++) {
> >+			raw_spin_lock_init(&overflow_list_flip->array[i].lock);
> >+			INIT_HLIST_HEAD(&overflow_list_flip->array[i].head);
> >+		}
> >+	}
> >+}
> >diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> >index f78275192036..b77152edafd9 100644
> >--- a/kernel/sched/core.c
> >+++ b/kernel/sched/core.c
> >@@ -59,6 +59,7 @@
> > #include <linux/profile.h>
> > #include <linux/psi.h>
> > #include <linux/rcuwait_api.h>
> >+#include <linux/hazptr.h>
> > #include <linux/rseq.h>
> > #include <linux/sched/wake_q.h>
> > #include <linux/scs.h>
> >@@ -7123,6 +7124,7 @@ static void __sched notrace __schedule(int sched_mode)
> > 	local_irq_disable();
> > 	rcu_note_context_switch(preempt);
> > 	migrate_disable_switch(rq, prev);
> >+	hazptr_note_context_switch();
> > 
> > 	/*
> > 	 * Make sure that signal_pending_state()->signal_pending() below
> >
> 
> --- Thanks!
> "I'm not a very positive person" - Linus torvalds

