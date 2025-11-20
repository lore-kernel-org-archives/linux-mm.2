Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28283CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823E36B00D4; Thu, 20 Nov 2025 10:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FBD16B00D7; Thu, 20 Nov 2025 10:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 711C76B00D8; Thu, 20 Nov 2025 10:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6117A6B00D4
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:55 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 248AC86D1B
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:55 +0000 (UTC)
X-FDA: 84131330430.18.B534E94
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id 77DA780021
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fXpeW69C;
	spf=pass (imf02.hostedemail.com: domain of 3LzAfaQUKCFw8FP8LAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--elver.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3LzAfaQUKCFw8FP8LAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6fdZE8GnxjevnV+ZPYXMwhSIUCp4xQbOOIBc42V/94A=;
	b=hIxdARN7vVix7DLzdutwbdUDXqaZcusROIb7gfkhU6GWugeGPfZUKYFrGfdZI3S3/tsaTg
	X3ci5h/C/UFCPxwg2El8L0SPYgxXbOyHXIvMc9cg9/IrlAUOzmle9KzSDQhRQF0rrZIRYi
	ECiDX9N0ZrYx0QT+O/FTiaPOeu05Rkw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651633; a=rsa-sha256;
	cv=none;
	b=59roMDQ9kJrGbsHeqwplzcmayNR3D6oyFVPvENIzr8LBeVAGuZ2e739vjzsL4Gx5CZaAyK
	WOOF32CQhfdIyq6uBETQEXt1QicvU9mMAoNM9+IPyqHVMV5T9WpgwgLh0Yi7ITwUKbG4X5
	3DAxh1dRfnshDzxCq8SiKH9UKTy136o=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fXpeW69C;
	spf=pass (imf02.hostedemail.com: domain of 3LzAfaQUKCFw8FP8LAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--elver.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3LzAfaQUKCFw8FP8LAIIAF8.6IGFCHOR-GGEP46E.ILA@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-6416b2de86bso1859377a12.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651632; x=1764256432; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=6fdZE8GnxjevnV+ZPYXMwhSIUCp4xQbOOIBc42V/94A=;
        b=fXpeW69CswgPrJ4Sc12RUMsTgLxJd8A7ccCg+7x9KV6QDOWbONxsIDmBSO/4bZpqLh
         JK1jY73S0pZPV9QlPLqeRI1VFugEiEp4rFrKFgzyjh1cq2hNSgs9JKXExX6j9aNijbwj
         we3pTvJC9jZ/AUikXKn0YrAoYyBOJ5t3+dt7x7SJEsIbPg/oh6uLUhN2W1Ocd3o+ZjPW
         OODBds2zrhLNY8urAvjuSR8HxCsogQzX9+FAsJ9ke5ldnj81Th/lZcildMzwQHsL+846
         vyS9W7KONCulfD4P0LhS+/S5e/FGY1uYgN06pl7oNZU1UaxhLVOdvRgs6n7Puvv6JgpV
         fkUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651632; x=1764256432;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6fdZE8GnxjevnV+ZPYXMwhSIUCp4xQbOOIBc42V/94A=;
        b=crJbR6ZZtOb4IuMYWYEPWGB8EdTB35P+9iDR2J7zoVdN8nXPNrTpqJPErcVLHLMBuB
         unU77UO7EsKpf+6AgK729GZRuksC4+SwkOmRHqPbCYbFHP8nx4Lv98iNwHFINvpkAyVa
         vBMJn6oBBR5jnRHymx3kahI4VlIKekk40JOsAZyZuRVPqrdbRVAlWoyZreHZBLYeDC5t
         i8j7sQ4AETEVjkTgNPD8j3Pti4tfDDFSSwLmQNBnvrLHY32Y+29ULu30Wv9CSyGTRtxl
         KCDp8q5yOa7Fz7FeU78sdwwCMczLGQUPfNp3xqGXQ1d7VpDnzPbuxPdSvEi6xwlHDsrS
         qCyw==
X-Forwarded-Encrypted: i=1; AJvYcCUZblZ/AkjRxWY1a2azNdBATorbCyPhgVOKW4MVv6eu4/Sj659lu0zadmOAndLEtHGpIfTTnJAzzA==@kvack.org
X-Gm-Message-State: AOJu0YynUgV21ERSF1EGjr8QNkVbdbtWG7ZRFrGY2xx66H8sogQC/q53
	sweIhUxLLsoyUNNGLGono2uC5JNCUTnYN6ns9qeSq91tD3dxMwt7dQuBU1smxsqyDJlK/0lmA2m
	FwA==
X-Google-Smtp-Source: AGHT+IG30dCuNBar8/1ZUCLz7Q8CeRd41MarYyChAvsUEwFL2biNgm+WJS8WZ3PYD5ZG2UR0ZpJ7H5ssIw==
X-Received: from edp1.prod.google.com ([2002:a05:6402:4381:b0:641:661a:2bff])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:3586:b0:640:a7a9:289f
 with SMTP id 4fb4d7f45d1cf-645363c6b54mr3185434a12.2.1763651631398; Thu, 20
 Nov 2025 07:13:51 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:56 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-32-elver@google.com>
Subject: [PATCH v4 31/35] rhashtable: Enable context analysis
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	Chris Li <sparse@chrisli.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, Bart Van Assche <bvanassche@acm.org>, 
	Christoph Hellwig <hch@lst.de>, Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Johannes Berg <johannes.berg@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Triplett <josh@joshtriplett.org>, Justin Stitt <justinstitt@google.com>, 
	Kees Cook <kees@kernel.org>, Kentaro Takeda <takedakn@nttdata.co.jp>, 
	Lukas Bulwahn <lukas.bulwahn@gmail.com>, Mark Rutland <mark.rutland@arm.com>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Nathan Chancellor <nathan@kernel.org>, Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	linux-wireless@vger.kernel.org, llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 77DA780021
X-Stat-Signature: 8nbfenetg6kw47ahes57r4d6ohsxa9b9
X-Rspam-User: 
X-HE-Tag: 1763651633-377363
X-HE-Meta: U2FsdGVkX19l91FW52qqcQDL9SHAkn5tCFk/QskLgem3uFkZvIDiyO7QruL3RRBeW0QaEEygwaR3ofzKoBP2RgRbz1vuVJ/SXJAx8ZJS0mXomKA03Ss6F3NKOQDZRah93EMtEJr36WnFOAIYxW2ex6YJJyVbjQSILGNYeeIA2/TvkcGfX6Nvz0RoJR1/w4jbefhldABsJvJA5EE6FzhTlQ2HZwPLb/riILrId6Tu3pDgX4PN9XZYzI3kS5KBBWKVXc6XrZgnUA4zoUnSpZrGeWvkNegCcMskHPhWMCYSur5IYDadRAFMZyC34adaqGatQhlWDjdGo7dgNC6oVvpd3lHyhSSM6657EZrFhYCnEDORlHmkbH6lAFu8h+5Upq9f3U6hokhBiRuW0Lb5UexfMTWFx3cJRqE6F85e+16gtwvw0gcqP2E2rO9e+nZzWlK0s9owGxCl9A1swQdXU6p5Bx6uQVc86/aRbhlwVBCqgsm2T4AXuqyFfZca7duBh72kxdGwzP1lwomYUokyqwDKwchr8P9DCpM047F+ZeYunIpKkypiqyKsuBgxrcUS9cP/+FrC3hgGYAu5OoP7ukvdd1NySWwiMmmNx9I70/TgihtIpLr7Xpvcq109kFWtmvTxX8ZUP9ZPAhh5j70N/zqCEfQFGgip6fu9GKHZRSlPFdgYwz9vVzJj4g3doL2SCvVh9sOOZeOY/kgn9MJYSJfYBsB4RH4YAL1ts0wBzBY0LcyWMDVl12sfOyfT6/enpkjy3PxBeVRKQ9XuplUCMojCJJ5nGP4NHSfKgcSonIbEnckWlK8vlQD7PG/4yHWH9iKar7a/7TFVHVDMImuplIdSkKoFp10FXh7BdWxXoRQKDyUBbLXxduyC85d572kkBiYiEq5/OQKt7PL+vjPCRQaizGQoiMB2NgBJVp0+MmOYS7NKGtEPSVy2lopVIHU2bxemvojtU7OlfwqjgPO4EBH
 Bekv3pBH
 N6AGhuBJJRwv9Ex1U2CkHiF3HVGJtB0jfeCywBkNqrsZTgllaqTG/Eh/2Ja19OOZXK+EBTK6eWCeFmE2Vl2Z+FuhlDR2R3IerUeGQgy+xelDYGrRQTTYk3GpitgL7qFLtZb0Ju3jMqAcH2MnY1vECkfylIbaMzc7vd5clJY2EI238YsZd0BK+KonV6yG6erivhpqCskDPkmuW5A67wrZq3jiLxjgwcpdNH7iEq17MRy2tNCXX43ETVGfCZEZDw1aHVSX1tnaNmfTKkbTeRMUGmI5zGZSlQc6wR604gz/Slydr7/tJHP8K0zUJ5iTl7c3Co3Va0nKqx9GqFNVBMicVnSn+5gePvMDj2I4DF7gV8d1lWXX1j0e/QgJREsW3cqRCBKfLgXU8GdIV4qARYDJLim43HphuJbgYEB4y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable context analysis for rhashtable, which was used as an initial
test as it contains a combination of RCU, mutex, and bit_spinlock usage.

Users of rhashtable now also benefit from annotations on the API, which
will now warn if the RCU read lock is not held where required.

Signed-off-by: Marco Elver <elver@google.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
---
v4:
* Rename capability -> context analysis.

v2:
* Remove disable/enable_context_analysis() around headers.
---
 include/linux/rhashtable.h | 14 +++++++++++---
 lib/Makefile               |  2 ++
 lib/rhashtable.c           |  5 +++--
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 05a221ce79a6..5ba7356d79f0 100644
--- a/include/linux/rhashtable.h
+++ b/include/linux/rhashtable.h
@@ -245,16 +245,17 @@ void *rhashtable_insert_slow(struct rhashtable *ht, const void *key,
 void rhashtable_walk_enter(struct rhashtable *ht,
 			   struct rhashtable_iter *iter);
 void rhashtable_walk_exit(struct rhashtable_iter *iter);
-int rhashtable_walk_start_check(struct rhashtable_iter *iter) __acquires(RCU);
+int rhashtable_walk_start_check(struct rhashtable_iter *iter) __acquires_shared(RCU);
 
 static inline void rhashtable_walk_start(struct rhashtable_iter *iter)
+	__acquires_shared(RCU)
 {
 	(void)rhashtable_walk_start_check(iter);
 }
 
 void *rhashtable_walk_next(struct rhashtable_iter *iter);
 void *rhashtable_walk_peek(struct rhashtable_iter *iter);
-void rhashtable_walk_stop(struct rhashtable_iter *iter) __releases(RCU);
+void rhashtable_walk_stop(struct rhashtable_iter *iter) __releases_shared(RCU);
 
 void rhashtable_free_and_destroy(struct rhashtable *ht,
 				 void (*free_fn)(void *ptr, void *arg),
@@ -325,6 +326,7 @@ static inline struct rhash_lock_head __rcu **rht_bucket_insert(
 
 static inline unsigned long rht_lock(struct bucket_table *tbl,
 				     struct rhash_lock_head __rcu **bkt)
+	__acquires(__bitlock(0, bkt))
 {
 	unsigned long flags;
 
@@ -337,6 +339,7 @@ static inline unsigned long rht_lock(struct bucket_table *tbl,
 static inline unsigned long rht_lock_nested(struct bucket_table *tbl,
 					struct rhash_lock_head __rcu **bucket,
 					unsigned int subclass)
+	__acquires(__bitlock(0, bucket))
 {
 	unsigned long flags;
 
@@ -349,6 +352,7 @@ static inline unsigned long rht_lock_nested(struct bucket_table *tbl,
 static inline void rht_unlock(struct bucket_table *tbl,
 			      struct rhash_lock_head __rcu **bkt,
 			      unsigned long flags)
+	__releases(__bitlock(0, bkt))
 {
 	lock_map_release(&tbl->dep_map);
 	bit_spin_unlock(0, (unsigned long *)bkt);
@@ -402,13 +406,14 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
 				     struct rhash_lock_head __rcu **bkt,
 				     struct rhash_head *obj,
 				     unsigned long flags)
+	__releases(__bitlock(0, bkt))
 {
 	if (rht_is_a_nulls(obj))
 		obj = NULL;
 	lock_map_release(&tbl->dep_map);
 	rcu_assign_pointer(*bkt, (void *)obj);
 	preempt_enable();
-	__release(bitlock);
+	__release(__bitlock(0, bkt));
 	local_irq_restore(flags);
 }
 
@@ -589,6 +594,7 @@ static inline int rhashtable_compare(struct rhashtable_compare_arg *arg,
 static __always_inline struct rhash_head *__rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhashtable_compare_arg arg = {
 		.ht = ht,
@@ -642,6 +648,7 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
 static __always_inline void *rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhash_head *he = __rhashtable_lookup(ht, key, params);
 
@@ -692,6 +699,7 @@ static __always_inline void *rhashtable_lookup_fast(
 static __always_inline struct rhlist_head *rhltable_lookup(
 	struct rhltable *hlt, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhash_head *he = __rhashtable_lookup(&hlt->ht, key, params);
 
diff --git a/lib/Makefile b/lib/Makefile
index 2e983f37d173..4ca9e8ce66bb 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -50,6 +50,8 @@ lib-$(CONFIG_MIN_HEAP) += min_heap.o
 lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
 
+CONTEXT_ANALYSIS_rhashtable.o := y
+
 obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
 	 bust_spinlocks.o kasprintf.o bitmap.o scatterlist.o \
 	 list_sort.o uuid.o iov_iter.o clz_ctz.o \
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index fde0f0e556f8..6074ed5f66f3 100644
--- a/lib/rhashtable.c
+++ b/lib/rhashtable.c
@@ -358,6 +358,7 @@ static int rhashtable_rehash_table(struct rhashtable *ht)
 static int rhashtable_rehash_alloc(struct rhashtable *ht,
 				   struct bucket_table *old_tbl,
 				   unsigned int size)
+	__must_hold(&ht->mutex)
 {
 	struct bucket_table *new_tbl;
 	int err;
@@ -392,6 +393,7 @@ static int rhashtable_rehash_alloc(struct rhashtable *ht,
  * bucket locks or concurrent RCU protected lookups and traversals.
  */
 static int rhashtable_shrink(struct rhashtable *ht)
+	__must_hold(&ht->mutex)
 {
 	struct bucket_table *old_tbl = rht_dereference(ht->tbl, ht);
 	unsigned int nelems = atomic_read(&ht->nelems);
@@ -724,7 +726,7 @@ EXPORT_SYMBOL_GPL(rhashtable_walk_exit);
  * resize events and always continue.
  */
 int rhashtable_walk_start_check(struct rhashtable_iter *iter)
-	__acquires(RCU)
+	__acquires_shared(RCU)
 {
 	struct rhashtable *ht = iter->ht;
 	bool rhlist = ht->rhlist;
@@ -940,7 +942,6 @@ EXPORT_SYMBOL_GPL(rhashtable_walk_peek);
  * hash table.
  */
 void rhashtable_walk_stop(struct rhashtable_iter *iter)
-	__releases(RCU)
 {
 	struct rhashtable *ht;
 	struct bucket_table *tbl = iter->walker.tbl;
-- 
2.52.0.rc1.455.g30608eb744-goog


