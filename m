Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECA52CFD2F6
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 23:37:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5311E6B002E; Thu, 27 Nov 2025 18:37:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E1726B002F; Thu, 27 Nov 2025 18:37:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A97F6B0030; Thu, 27 Nov 2025 18:37:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 25F066B002E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 18:37:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE5351A02D8
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:37:01 +0000 (UTC)
X-FDA: 84157999842.17.6E492C7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id B13D840006
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 23:36:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P9CT6E+i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CRJ91W7M;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qoSWE1Mi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sDGmcqZ8;
	spf=pass (imf01.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764286620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IW1WhoGnmYiCAA03AzqLgWTc11O/MV76t6IKrXLxrnY=;
	b=MjzT1PxNkWQgu18lVHRmsk45XANsCXl6F4lVLNtBy/3XHzz3oU+s5y8mzuvNBQT7QzDLpA
	LEY0xe5HRAWY85u0bsRb94ZjsEddFAy9XNwftDYLNJB51JiVkx+je4suObi0iSG68ucPgU
	nECKrrXehbonQ3iErAe68quTF85oveI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=P9CT6E+i;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CRJ91W7M;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qoSWE1Mi;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sDGmcqZ8;
	spf=pass (imf01.hostedemail.com: domain of krisman@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=krisman@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764286620; a=rsa-sha256;
	cv=none;
	b=P/5IV6kJkI7+a9ciIEANn/Ci8IzznV+8Y7l9Wzdn6PEXHcK+UddOtmsE1Ldq5KBgarmRsN
	e6x+Zpeudf99tPd2zspjswUpXzySMxBYZKk4AyAtWiSgDndVqJhGADCh3TkqlrywfCuCY2
	sU/F336Gd4NYZCjBz40cXJYrH+G1ULg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A97AF336B9;
	Thu, 27 Nov 2025 23:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764286617; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IW1WhoGnmYiCAA03AzqLgWTc11O/MV76t6IKrXLxrnY=;
	b=P9CT6E+i32aDEc/ncUmMRhqXPF6FxJkuuHXYEjVrTEn+G35uNxWhFZ4/F3jVn265iPBPxB
	1UdM02xQcuEmVxgJ4ks+8rFdZi8y4LAJAS70ybtwixgI0Zx1+s5zpuRxC+xlZUPGd8DQ2z
	6+Dn3RQMHGG8MVQv0DIG0ZZZEe6N2X8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764286617;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IW1WhoGnmYiCAA03AzqLgWTc11O/MV76t6IKrXLxrnY=;
	b=CRJ91W7M2UjNES1uJaMK4sLSPIVbDgqXiHj2SUNcK7Ky078cwduw5O8jo6Rs8bj+GHSrrP
	bYPdCJiG6NgjodCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1764286615; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IW1WhoGnmYiCAA03AzqLgWTc11O/MV76t6IKrXLxrnY=;
	b=qoSWE1MiMWJJ1pBHpF7FzIy0dI/3iXoO1ujH7WQwF5yiS7TFaWpnFf0lB1qwggMNseboav
	moByj5mf7CLObY2Ypq0epVMXWAWSTlieFh6ygXmMH9HczI26G+QjUgGDisT8Af7XLl/dwG
	JpwBxwQdPmu24EmFb9uhpZ0QFbKmf5M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1764286615;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IW1WhoGnmYiCAA03AzqLgWTc11O/MV76t6IKrXLxrnY=;
	b=sDGmcqZ8xtxuw22EbnqoCrQAdfd/P7HqySYVQcOJ32lcfLxiM2nqkUmMvjgVhzLKJzxXKp
	9iuURRDaNh/1cnDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6962E3EA63;
	Thu, 27 Nov 2025 23:36:55 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id cBAeE5fgKGlEGQAAD6G6ig
	(envelope-from <krisman@suse.de>); Thu, 27 Nov 2025 23:36:55 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: linux-mm@kvack.org
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	linux-kernel@vger.kernel.org,
	jack@suse.cz,
	Mateusz Guzik <mjguzik@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>
Subject: [RFC PATCH 2/4] lib: Support lazy initialization of per-cpu counters
Date: Thu, 27 Nov 2025 18:36:29 -0500
Message-ID: <20251127233635.4170047-3-krisman@suse.de>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251127233635.4170047-1-krisman@suse.de>
References: <20251127233635.4170047-1-krisman@suse.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: B13D840006
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rq3cw79eus4sf6ko57a5hgwxfxhi1ge3
X-HE-Tag: 1764286619-180286
X-HE-Meta: U2FsdGVkX18wjH3hw6lsNDJRFrwCTPtBA2ZLSNbDRtwjaXyPD9cTw//aD05k1ei1j4Uuy6W8HUtXu+7rZ4omg6N9ET4iP9H6C0wvIq90Dyg/soaSeYbHzPGpFZiuPq3zRsHyYBkjnfwMe86MQ1T1TSjx1YqEP6yW7bA2gbbp+Di+2wem68TgN7A/O6FDRID2aMJ/WLLfm3w5PrBwlJpSaPDSZubvibNhEAYe6Nz67J3d21LP1qdgt4rzIc/zIIF65HGOafMXKBhUkXEq/SxncQ1GcGd4XDJrQ9Goq2GuK3JFMr0k67J4XX3NHE+/57aN7S0mKJNSc7D8K3GSKPYW9kkkXVNX9bzoDwASXMMRf0a58KZyL7Yo8ZoJiE8CJQ10fy200+KmqiasGPPBTvWMIsDx/BmyRjf2BozQbTpEqcCfBmJIXFShW9ROdP9dl+vTVAxNFyiZQcbLXuiD82i3pxmsEVfqZZzlFPb+i1+IUNEt7hu6ihHIie3iFGBrgbeHx1s3SRgf3wagg0nao1lfa7YS57UOcuUJG1UOexOUkf6enAt2HSK218daYnFFTackznsnEpBoJ2KvuJpcUB6XC1K5yhdr7ui5Ly8xLM+kzFPRyENZDn3+Y7+QrGpIRx9soh9sC1qEmH/NLaq/DolfvJ9pkG4vK9Rg6ESnFBUFNlhPmlESpBKYGLzDruod+miw+BgU8itRtiDs6vk3pHnyls1d8iBe5tiC8nU22AxpAvFU6nsFhu/53Q5HTR042xglglOIbSUkdCiu2Z8AopVnejn5ot6aMXrPVAHComqXO7lBbpwAkngreHC7qSjrryaIZxqVrVnr7IUaCFYGJkwpc4s95FDJ5MFqM0MBNyquNbWFDwV0GnEf6x14Sa93EC+EAhRZ9uQUdKxlJKGyMaQxVidBHKBmLqUBn8yPpkNHGR3NwyaZ5NNQEC2bKAWWoxC4q+gNx2EcrXnGMKVpD1Z
 Nw8rzGls
 93Ll2OtRTOJYZ0l12nP47Yf6W8EClAxQVTrHE7NNPpfZduk2aABz5qpj0cp7R177I+cntS4iabRifEy7h2t4dqtOYD93Fz/Ex/obieKivFBIPe5MNLNq1UiFSjQFT0y5HwNMXDrrSilZrp9FetyQA3+Qp1jd2JBSbHucUyWU5cGV6hSS335cXq2tvWnsogLUQZiJSYEMUrNQ4UAJl2qtn7fXrW8uvmhcpM8Ag8DuC0zMkpGzWvL5OOMmrjnzFH3iEaxHlPWJ0IMm2xPHDtCQGYn5cmCR1aknWD63p9KdEvVYREbk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While per-cpu counters are efficient when there is a need for frequent
updates from different cpus, they have a non-trivial upfront
initialization cost, mainly due to the percpu variable allocation.  This
cost becomes relevant both for short-lived counters and for cases
where we don't know beforehand if there will be frequent updates from
remote cpus. On both cases, it could have been better to just use a
simple counter.

The prime example is rss_stats of single-threaded tasks, where the vast
majority of counter updates happen from a single-cpu context at a time,
except for slowpath cases, such as OOM, khugepage.  For those workloads,
a simple counter would have sufficed and likely yielded better overall
performance if the tasks were sufficiently short.  There is no end of
examples of short-lived single-thread workloads, in particular coreutils
tools.

This patch introduces a new counter flavor that delays the percpu
initialization until needed.  It is a dual-mode counter.  It starts with
a two-part counter that can be updated either from a local context
through simple arithmetic or from a remote context through an atomic
operation.  Once remote accesses become more frequent, and the user
considers the overhead of atomic updates surpasses the cost of
initializing a fully-fledged per-cpu counter, the user can seamlessly
upgrade the counter to the per-cpu counter.

The first user of this are the rss_stat counters.  Benchmarks results
are provided on that patch.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 include/linux/lazy_percpu_counter.h | 145 ++++++++++++++++++++++++++++
 include/linux/percpu_counter.h      |   5 +-
 lib/percpu_counter.c                |  40 ++++++++
 3 files changed, 189 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/lazy_percpu_counter.h

diff --git a/include/linux/lazy_percpu_counter.h b/include/linux/lazy_percpu_counter.h
new file mode 100644
index 000000000000..7300b8c33507
--- /dev/null
+++ b/include/linux/lazy_percpu_counter.h
@@ -0,0 +1,145 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#include <linux/percpu_counter.h>
+#ifndef _LAZY_PERCPU_COUNTER
+#define _LAZY_PERCPU_COUNTER
+
+/* Lazy percpu counter is a bi-modal distributed counter structure that
+ * starts off as a simple counter and can be upgraded to a full per-cpu
+ * counter when the user considers more non-local updates are likely to
+ * happen more frequently in the future.  It is useful when non-local
+ * updates are rare, but might become more frequent after other
+ * operations.
+ *
+ * - Lazy-mode:
+ *
+ * Local updates are handled with a simple variable write, while
+ * non-local updates are handled through an atomic operation.  Once
+ * non-local updates become more likely to happen in the future, the
+ * user can upgrade the counter, turning it into a normal
+ * per-cpu counter.
+ *
+ * Concurrency safety of 'local' accesses must be guaranteed by the
+ * caller API, either through task-local accesses or by external locks.
+ *
+ * In the initial lazy-mode, read is guaranteed to be exact only when
+ * reading from the local context with lazy_percpu_counter_sum_local.
+ *
+ * - Non-lazy-mode:
+ *   Behaves as a per-cpu counter.
+ */
+
+struct lazy_percpu_counter {
+	struct percpu_counter c;
+};
+
+#define LAZY_INIT_BIAS (1<<0)
+
+static inline s64 add_bias(long val)
+{
+	return (val << 1) | LAZY_INIT_BIAS;
+}
+static inline s64 remove_bias(long val)
+{
+	return val >> 1;
+}
+
+static inline bool lazy_percpu_counter_initialized(struct lazy_percpu_counter *lpc)
+{
+	return !(atomic_long_read(&lpc->c.remote) & LAZY_INIT_BIAS);
+}
+
+static inline void lazy_percpu_counter_init_many(struct lazy_percpu_counter *lpc, int amount,
+					       int nr_counters)
+{
+	for (int i = 0; i < nr_counters; i++) {
+		lpc[i].c.count = amount;
+		atomic_long_set(&lpc[i].c.remote, LAZY_INIT_BIAS);
+		raw_spin_lock_init(&lpc[i].c.lock);
+	}
+}
+
+static inline void lazy_percpu_counter_add_atomic(struct lazy_percpu_counter *lpc, s64 amount)
+{
+	long x = amount << 1;
+	long counter;
+
+	do {
+		counter = atomic_long_read(&lpc->c.remote);
+		if (!(counter & LAZY_INIT_BIAS)) {
+			percpu_counter_add(&lpc->c, amount);
+			return;
+		}
+	} while (atomic_long_cmpxchg_relaxed(&lpc->c.remote, counter, (counter+x)) != counter);
+}
+
+static inline void lazy_percpu_counter_add_fast(struct lazy_percpu_counter *lpc, s64 amount)
+{
+	if (lazy_percpu_counter_initialized(lpc))
+		percpu_counter_add(&lpc->c, amount);
+	else
+		lpc->c.count += amount;
+}
+
+/*
+ * lazy_percpu_counter_sync needs to be protected against concurrent
+ * local updates.
+ */
+static inline s64 lazy_percpu_counter_sum_local(struct lazy_percpu_counter *lpc)
+{
+	if (lazy_percpu_counter_initialized(lpc))
+		return percpu_counter_sum(&lpc->c);
+
+	lazy_percpu_counter_add_atomic(lpc, lpc->c.count);
+	lpc->c.count = 0;
+	return remove_bias(atomic_long_read(&lpc->c.remote));
+}
+
+static inline s64 lazy_percpu_counter_sum(struct lazy_percpu_counter *lpc)
+{
+	if (lazy_percpu_counter_initialized(lpc))
+		return percpu_counter_sum(&lpc->c);
+	return remove_bias(atomic_long_read(&lpc->c.remote)) + lpc->c.count;
+}
+
+static inline s64 lazy_percpu_counter_sum_positive(struct lazy_percpu_counter *lpc)
+{
+	s64 val = lazy_percpu_counter_sum(lpc);
+
+	return (val > 0) ? val : 0;
+}
+
+static inline s64 lazy_percpu_counter_read(struct lazy_percpu_counter *lpc)
+{
+	if (lazy_percpu_counter_initialized(lpc))
+		return percpu_counter_read(&lpc->c);
+	return remove_bias(atomic_long_read(&lpc->c.remote)) + lpc->c.count;
+}
+
+static inline s64 lazy_percpu_counter_read_positive(struct lazy_percpu_counter *lpc)
+{
+	s64 val = lazy_percpu_counter_read(lpc);
+
+	return (val > 0) ? val : 0;
+}
+
+int __lazy_percpu_counter_upgrade_many(struct lazy_percpu_counter *c,
+				       int nr_counters, gfp_t gfp);
+static inline int lazy_percpu_counter_upgrade_many(struct lazy_percpu_counter *c,
+						   int nr_counters, gfp_t gfp)
+{
+	/* Only check the first element, as batches are expected to be
+	 * upgraded together.
+	 */
+	if (!lazy_percpu_counter_initialized(c))
+		return __lazy_percpu_counter_upgrade_many(c, nr_counters, gfp);
+	return 0;
+}
+
+static inline void lazy_percpu_counter_destroy_many(struct lazy_percpu_counter *lpc,
+						    u32 nr_counters)
+{
+	/* Only check the first element, as they must have been initialized together. */
+	if (lazy_percpu_counter_initialized(lpc))
+		percpu_counter_destroy_many((struct percpu_counter *)lpc, nr_counters);
+}
+#endif
diff --git a/include/linux/percpu_counter.h b/include/linux/percpu_counter.h
index 3a44dd1e33d2..e6fada9cba44 100644
--- a/include/linux/percpu_counter.h
+++ b/include/linux/percpu_counter.h
@@ -25,7 +25,10 @@ struct percpu_counter {
 #ifdef CONFIG_HOTPLUG_CPU
 	struct list_head list;	/* All percpu_counters are on a list */
 #endif
-	s32 __percpu *counters;
+	union {
+		s32 __percpu *counters;
+		atomic_long_t remote;
+	};
 };
 
 extern int percpu_counter_batch;
diff --git a/lib/percpu_counter.c b/lib/percpu_counter.c
index c2322d53f3b1..0a210496f219 100644
--- a/lib/percpu_counter.c
+++ b/lib/percpu_counter.c
@@ -4,6 +4,7 @@
  */
 
 #include <linux/percpu_counter.h>
+#include <linux/lazy_percpu_counter.h>
 #include <linux/mutex.h>
 #include <linux/init.h>
 #include <linux/cpu.h>
@@ -397,6 +398,45 @@ bool __percpu_counter_limited_add(struct percpu_counter *fbc,
 	return good;
 }
 
+int __lazy_percpu_counter_upgrade_many(struct lazy_percpu_counter *counters,
+				       int nr_counters, gfp_t gfp)
+{
+	s32 __percpu *pcpu_mem;
+	size_t counter_size;
+
+	counter_size = ALIGN(sizeof(*pcpu_mem), __alignof__(*pcpu_mem));
+	pcpu_mem = __alloc_percpu_gfp(nr_counters * counter_size,
+				      __alignof__(*pcpu_mem), gfp);
+	if (!pcpu_mem)
+		return -ENOMEM;
+
+	for (int i = 0; i < nr_counters; i++) {
+		struct lazy_percpu_counter *lpc = &(counters[i]);
+		s32 __percpu *n_counter;
+		s64 remote = 0;
+
+		WARN_ON(lazy_percpu_counter_initialized(lpc));
+
+		/*
+		 * After the xchg, lazy_percpu_counter behaves as a
+		 * regular percpu counter.
+		 */
+		n_counter = (void __percpu *)pcpu_mem + i * counter_size;
+		remote = (s64) atomic_long_xchg(&lpc->c.remote, (s64)(uintptr_t) n_counter);
+
+		BUG_ON(!(remote & LAZY_INIT_BIAS));
+
+		percpu_counter_add_local(&lpc->c, remove_bias(remote));
+	}
+
+	for (int i = 0; i < nr_counters; i++)
+		debug_percpu_counter_activate(&counters[i].c);
+
+	cpu_hotplug_add_watchlist((struct percpu_counter *) counters, nr_counters);
+
+	return 0;
+}
+
 static int __init percpu_counter_startup(void)
 {
 	int ret;
-- 
2.51.0


