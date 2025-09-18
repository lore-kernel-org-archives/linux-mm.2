Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83298CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D7A8E013C; Thu, 18 Sep 2025 10:06:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D05A8E013A; Thu, 18 Sep 2025 10:06:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BE7B8E013C; Thu, 18 Sep 2025 10:06:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35EBC8E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:54 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 01682C01D9
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:53 +0000 (UTC)
X-FDA: 83902547148.30.B6A59C8
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf27.hostedemail.com (Postfix) with ESMTP id E497C40020
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:51 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="K2W/WMQX";
	spf=pass (imf27.hostedemail.com: domain of 3-hHMaAUKCJs9GQ9MBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3-hHMaAUKCJs9GQ9MBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uu2U7ivUVuh8UFOqD9X78NwxcdL3Tv7H02aP9D4eaJs=;
	b=SwvxwE9pxOJERqOYxmFJslxmtHY2unYuBdmyt9NYIjx8lhUZZRUvgd2AW1mqvPzE9C+ct5
	yWnD9+YDr/tpBoTYNGsqSKbIGpbiDrlAjT62mHuvF2WHm1msQhpoMwV2KOzP1IVnNr6wgW
	MOssT0txFI3Ln/CBzULLCy14VhYi+9o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="K2W/WMQX";
	spf=pass (imf27.hostedemail.com: domain of 3-hHMaAUKCJs9GQ9MBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3-hHMaAUKCJs9GQ9MBJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204412; a=rsa-sha256;
	cv=none;
	b=bwUTy3sshtB4a1dRITz5dVdpJMb6Cy1OkS0JjvDiHc4sDBvLqTPXGHu04QzEDAFXL8/HCU
	6Il8URwt0d/On/bWkRBLaomylfKB4Hz4ZvhT75wm3ml9SGrekm1gQXBcEsr/mdYZiD7VTr
	S+KTzPvDPcPAGh8kCg+ot0k+IhwHs4Y=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45df609b181so11137605e9.2
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204410; x=1758809210; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uu2U7ivUVuh8UFOqD9X78NwxcdL3Tv7H02aP9D4eaJs=;
        b=K2W/WMQXTcBcfpUoXBZ5oIgXvVp1sOsw1X4hvzAiSAsx0/cwVZazeU2LuiW4s+K0IH
         7GGVjf6c5lZqmYPdsPyNY33c85YGvw+xdsvqbtu1BZajwt5y+81SKF/AMCZu1T0QlZjx
         zSiynt3w0T0t5ye640ZNnJZly5xqYe5SCWnVfZxnvoFy22T87rsXlVYQIXncb4+vmU0N
         ZsVhmsWj9NlNpXMrFLxb/p3Y2vM97S4TZBUGUKvd4M24cR1O9bsDdFb629+Ii0XuOouy
         3+kInODdJmO03YCX972SDuqzfm1cx5JwikKGTkul0n8EcOGW4AxKrJaBvqgpAJjfjYJl
         cE4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204410; x=1758809210;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uu2U7ivUVuh8UFOqD9X78NwxcdL3Tv7H02aP9D4eaJs=;
        b=gJ3jbn4pvbXB5OyRJMJDRe6jp2+gr5fuvGYO/k0Mqv7W+dNT81fIcJ9IxWtZa1v3P4
         oHdVG7prlkXlhiIpXa35gjJCTiwz50p0ppGm6RAZHqZWjS+9u4VJB4+jCubUac6NqOcg
         nq0/1WHA3IJlAvcIKDP8EJO57l/Z27KDLhegDQh6FmB4w2SA4ThcrCkz8FejUurcbk7s
         Pc7u1Ys6dxzIcJuMVm3Bq8nb/lWxVKiGUIqE3oet20Tw5Og2SimboolbhFxfaNTRgHWf
         W/8QStVxlxXZEnSZ6eVoD/crdKQMfaUr5MLCE90lMQidL0AXwHFAmjqBbfohi4bze83D
         VHJg==
X-Forwarded-Encrypted: i=1; AJvYcCWJOJVTFHxZZAwE89G0Ndr2nvmBA10vVWIYWTEIyajmskPWkbXZkQD04LWmI14bO+T3VYfVI2pVOw==@kvack.org
X-Gm-Message-State: AOJu0YxV5TamM74O+LVParU5DRqTFEzg4W7BkdHlryTDo+bUGRLmKRB9
	E/83NlqaI5UdmyoP8zmsju7lTO9Wp0ZJYliHuMw2/lR8tFvytiKPMxlaHEHq/p9OM6JnCvc1hWr
	KtA==
X-Google-Smtp-Source: AGHT+IHRfJ0sadoWjMsHalmLLwSIXcal7LoFUr3N/EwlXauwuYhWDu8KTQkhk5JA9sEvt9IyjDEeNyzsjA==
X-Received: from wmkz6.prod.google.com ([2002:a7b:c7c6:0:b0:45b:79d1:abcb])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1d1a:b0:45d:e326:96e7
 with SMTP id 5b1f17b1804b1-46206b20d8bmr53761355e9.29.1758204410398; Thu, 18
 Sep 2025 07:06:50 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:42 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-32-elver@google.com>
Subject: [PATCH v3 31/35] rhashtable: Enable capability analysis
From: Marco Elver <elver@google.com>
To: elver@google.com, Peter Zijlstra <peterz@infradead.org>, 
	Boqun Feng <boqun.feng@gmail.com>, Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Luc Van Oostenryck <luc.vanoostenryck@gmail.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Alexander Potapenko <glider@google.com>, Arnd Bergmann <arnd@arndb.de>, 
	Bart Van Assche <bvanassche@acm.org>, Bill Wendling <morbo@google.com>, Christoph Hellwig <hch@lst.de>, 
	Dmitry Vyukov <dvyukov@google.com>, Eric Dumazet <edumazet@google.com>, 
	Frederic Weisbecker <frederic@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Ian Rogers <irogers@google.com>, 
	Jann Horn <jannh@google.com>, Joel Fernandes <joelagnelf@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Triplett <josh@joshtriplett.org>, 
	Justin Stitt <justinstitt@google.com>, Kees Cook <kees@kernel.org>, 
	Kentaro Takeda <takedakn@nttdata.co.jp>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, 
	Mark Rutland <mark.rutland@arm.com>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Thomas Gleixner <tglx@linutronix.de>, 
	Thomas Graf <tgraf@suug.ch>, Uladzislau Rezki <urezki@gmail.com>, Waiman Long <longman@redhat.com>, 
	kasan-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-security-module@vger.kernel.org, linux-sparse@vger.kernel.org, 
	llvm@lists.linux.dev, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: E497C40020
X-Stat-Signature: s8nxtw7pnj81gizbhw3es1ucf576qtys
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758204411-22972
X-HE-Meta: U2FsdGVkX19rshqbKXcxMdkAOqXsoncNtvedJ6bRc2+KL2odice65RaTnPi7Q6nm/RU4Q+7zD5yKSk88q9q3dTf4+Kmhx9Mzx3qRpxn7UCwqp28H0z4xfM3np9amtSIvMQ6HfTkWHliRAYJGdUlieyMddAm3NJzFKJqDT5b5K4sJDAvWM1OoZnk6VjG4biUNcc7umgV9Znj/uv64WlQT0FYzjhoHdRjsGYZ6GzBG2vwhP3Bax3/e6rSby+30WJN+WRYWTNEwqXag23zsAtbrPth4cjaiO8IeY8nyQEyfytKbSCOVYdR4hcfyhWsTv1raAD6RELQwsFSAMHp2ZgMjuHtTqN4MEUYte2Nn2HQnMyGzFnb3jLWCdiLkPSCyjK9RJdcnkQmP+D7XEWD75RMgNUfCr8u0qWq1utHU3/Khnr//GKxTznZdhxEslcoWtcoSRslBgsRVYymOnrQttWr2XmCF3HgEPGnX9WNYKcIxYbH2Kt0B+fo3aYjLmR99z4F1e67H/nlxEqeDOV7ok9uN1Un45n5zB8cXWu/7rdg2F/ZV5D2/4RUXXRIoZIoIM/6gn21mw3mBDrXndOkn6SeCOguKcd4cj0QATB6H/YizEIdE3ezH89FVxmBExX+Or5p9QZdJUTWUjdbgyGQFWSIO3yF1ckG+00IU9C84RPyq2j93AP1NB+1sX2iOyECbwKwr3BDy7JjOypOHvlQZkeaGxoWhA63e0Kc8Q+RIBdfHealrEXpseyEao0cE2hptgYVX2PoEqV/YgKas/NQQ/ACwmgjvgdfGwbgKWyJiwhD6NUbdX6LWC9oEPtU+9sGOtCa3ViGAePIF3ntSktQ0maz4Jb3WEI+pfcTBnCqLKlzDGCF8z6fFU9w9VDesVslmv7CiJFeXFv14UjDf99odmNXUteyiorDFNi1RH4HDM96Ve1bZPeMaSFyAgCGFKBQtg/InhovxIdexEHW9honTBhb
 ZuroWBQ8
 OVf3HZ6Qo0j9igX1JpUP4CRGcXkMhvR2QyBhj3TNXYuz/phshAH8SgIkcR8O7dTPPn5J4B1YTZoeIz8wN0FnYJBv8odrHPHwWRcrjswu/AgQtbz0duKzo0i3AT+pMgVUsh9wcJqe1aLXHadzXGRZ3vNtGheVhGjqrtARSVv9e4x9nUtnbO+bSFXzKfzJQtcmhpL45j9xUfzWVmORSNPw/NobdsyBl/TAeKSHfbTdfyuKbuagGL5UTajYbh8xjvMeO6w/ucE+bUndmYW2e2f59bNo+Pe2abfHr+1A6KtHPv9ONbHLZaVL+e+scp/Dvyz3UEpb+NHHH8gjj/ei1kw5WhnzanJNLc2bsE7/pfy1oFnqHPoP9ggp2kyWl309s7f/FgMth9J5nOvCxarqykUNx19ZZ/ir3aiX1m/kKQQu+7FrnZUlJSMgHgNu0r7ETraycUcMIftyxOehHy28ZvgTinXv/YGJ6lSNupZB0TSojgcWEbs7LSGvmyaZbjlbCh2duglU5kR4B2PooQdZLwrfC0AR3y9aRipCIL69PG47CzQmU/S2C27jvrKxbqB3fvXMHP7oaMfrqAE4cKaaxRhrcQRcQtZAkZ0hdXPbi0J+xhsSXw0qlzeh+0t5uva83uDfsfXW8Ya1QhlOxjREC+tW+SKA9BNyNmOijggt64gsSELH35C1rPVP5CPew03YLU4FOehq1LxR2/O6rw89SIGYvpP03Xgxqz4WXik5B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable capability analysis for rhashtable, which was used as an initial
test as it contains a combination of RCU, mutex, and bit_spinlock usage.

Users of rhashtable now also benefit from annotations on the API, which
will now warn if the RCU read lock is not held where required.

Signed-off-by: Marco Elver <elver@google.com>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: linux-crypto@vger.kernel.org
---
v2:
* Remove disable/enable_capability_analysis() around headers.
---
 include/linux/rhashtable.h | 14 +++++++++++---
 lib/Makefile               |  2 ++
 lib/rhashtable.c           |  5 +++--
 3 files changed, 16 insertions(+), 5 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 6c85b28ea30b..347716b1ca37 100644
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
 static inline struct rhash_head *__rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhashtable_compare_arg arg = {
 		.ht = ht,
@@ -642,6 +648,7 @@ static inline struct rhash_head *__rhashtable_lookup(
 static inline void *rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhash_head *he = __rhashtable_lookup(ht, key, params);
 
@@ -692,6 +699,7 @@ static inline void *rhashtable_lookup_fast(
 static inline struct rhlist_head *rhltable_lookup(
 	struct rhltable *hlt, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhash_head *he = __rhashtable_lookup(&hlt->ht, key, params);
 
diff --git a/lib/Makefile b/lib/Makefile
index 43b965046c2c..85a9144b008a 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -50,6 +50,8 @@ lib-$(CONFIG_MIN_HEAP) += min_heap.o
 lib-y	+= kobject.o klist.o
 obj-y	+= lockref.o
 
+CAPABILITY_ANALYSIS_rhashtable.o := y
+
 obj-y += bcd.o sort.o parser.o debug_locks.o random32.o \
 	 bust_spinlocks.o kasprintf.o bitmap.o scatterlist.o \
 	 list_sort.o uuid.o iov_iter.o clz_ctz.o \
diff --git a/lib/rhashtable.c b/lib/rhashtable.c
index 3e555d012ed6..fe8dd776837c 100644
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
2.51.0.384.g4c02a37b29-goog


