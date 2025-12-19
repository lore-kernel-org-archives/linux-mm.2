Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736F3D7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7966B00CF; Fri, 19 Dec 2025 10:47:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8BB66B00D1; Fri, 19 Dec 2025 10:47:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA32B6B00D2; Fri, 19 Dec 2025 10:47:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB4106B00CF
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:36 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F3281402E9
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:36 +0000 (UTC)
X-FDA: 84236650512.30.312600C
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9230E180012
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QDI+CYDF;
	spf=pass (imf24.hostedemail.com: domain of 3lHNFaQUKCOEHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3lHNFaQUKCOEHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159254; a=rsa-sha256;
	cv=none;
	b=Ys8HfbpEy1qu3lRb4ydLfaDZa7+1Knos886OBBk+ewaRauD0Kot7CAZ+zTHhTU0JbIVd8q
	yaLGP048zCMdU+8defI3mrQduFFt266kuEDoOEueIlp7S+/mpMMvGksI3+hppOuA/EnvYV
	xefK1ueirjn8bM/DPuwERq+olACwVyA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=QDI+CYDF;
	spf=pass (imf24.hostedemail.com: domain of 3lHNFaQUKCOEHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3lHNFaQUKCOEHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gVYXgtdCpLCQNFVroiaCMxergOmHfVtsDs2aOEVw4MA=;
	b=aXj3kjHWUByWDw7mozcmEu+edwUF+nSndFtPpFpCUCrXkI6wvJeAhuZtvQSbusKkiuG8ic
	4ddsditgSyCVhFR0ozvGMFtj7qGrK33H1zeV3BaqoA7Bb2PQ3U0xifo80Ywjw1wwKJohba
	EeV5N6LiNRcBK2GWXQfkvS7cNgxX8yk=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so13976605e9.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159253; x=1766764053; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=gVYXgtdCpLCQNFVroiaCMxergOmHfVtsDs2aOEVw4MA=;
        b=QDI+CYDFhrPC9eQL65dgbdsPR9TAo52NRMI7HbC/7T8y8GtMbFIh0Ce7xlUWp8lmCm
         BVsyv83vAySvePKWz0WlNy+/1+TUVVZzmMQxTwCcfp0R74roD33uyNgNPBvJEVlb1Lig
         Q3Bd0QHC5865E+ihi7RFaHObk8V75LJrTZNwNdQuPu/DgNRZFSk0o2jNvNqlUTSLmQ0B
         fGfs3pdwNjBfdau7QSefN4w1QWItmCftrZdnrP25OqqZV7ove2zDvyNY9F9iJB/xOsSm
         OfOzIOY3uFhK7ocNPiRmU8QA9nSYY5xELHT6k3+VzIAIQT36Bvma0WwSevUZXbb2hphj
         rcfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159253; x=1766764053;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gVYXgtdCpLCQNFVroiaCMxergOmHfVtsDs2aOEVw4MA=;
        b=gsymxraHpRvCDhR3IkBhZx5d+bJmVFK9nadR3tqDgqwaBAp73KC6tmEI4xRMGBivVK
         dVgsILOAMBDKZ18wj8z3RzdrQeOBv4v2lDsjMadNbET/rzRW2StknB6KzqtjFIB5YgDH
         XGIQccXM2Ph07qPUD+OAQ8CaOXjETUOh/PVs8PTy7VDjWUQM/i8Y35GGlqKnWprMcy0a
         TIdIFx2UxzZUiPexmAe63pIGQTwJVy1XUS0RVZYk3hkNNliSnPMH/oxsAHowuFeInRIs
         26ZBoMNHuL3zP78U+rIaR1bvKZwy1vVsUCE78xE23t83QZZSZnyuvlszrRdReoLHwSne
         xChw==
X-Forwarded-Encrypted: i=1; AJvYcCUh2xKX9kEmSlnpjogmLF3QcF/N0iMicRlQhnQzSYzVexJq7A4AiC+/9sauWokHwTjtEb/i424ObQ==@kvack.org
X-Gm-Message-State: AOJu0Yx1W1u8hTVV6NdPaLkOUlQl1d4rIGMi1fIzSRx9uP0VnxthImwN
	UiJZr14fBk0vdi8EXO7+fq2D/2ggfC2X6Cw/kZmZYb9YiSX92BGHlO9/iCZOWwiJm9Us1AsBZ/n
	HiQ==
X-Google-Smtp-Source: AGHT+IF7X7xFaJ62BwS9IugsWlp3fxNRiUfga93aJgM/MRyd67RIn/H0v7I9tRaoGzfNYwMLbV+sgtE0Nw==
X-Received: from wmco23.prod.google.com ([2002:a05:600c:a317:b0:475:dca0:4de3])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4e8f:b0:479:3a89:121d
 with SMTP id 5b1f17b1804b1-47d1959c74fmr31405385e9.36.1766159252991; Fri, 19
 Dec 2025 07:47:32 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:21 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-33-elver@google.com>
Subject: [PATCH v5 32/36] rhashtable: Enable context analysis
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 9230E180012
X-Rspamd-Server: rspam04
X-Stat-Signature: 6cyi74mkecaj4ohssa5zckryo4b477wq
X-HE-Tag: 1766159254-935033
X-HE-Meta: U2FsdGVkX190uSrWgHQcWx7JyXuW5oeev+vCi68KDkKFCCGTNWHY7W9QM5HEYdXZfYCaeUJ5CYc5ZlahlGYRTxcEvJ5+D0Z2rMlVNYsDwxmC6KR0tRLoQ2urZSZTWykwUyk64HwjESTz2X0imQE7ZZX3LGNWNoRzmiahzKkOW6e3OWDtFj15oax8l/hweHOS1xgAm/WTkvIYhPoFG+mGvaezd9PKlOzo0aCg72y9s1bx4G7r7Yv0HunG3tX+mA+/Jbz02awrOAcBRp7dkrIzmy7A8cPqPg0UBQRqSDgkwfzr87lfjapsjxvbHifN9pcyd3lYAc9i6owJZTzqZ/4T4rWDBOau73sgcyjJCSt8i/xzYiTEr3xrzYaE7p2hPtx52t9ID5aZeGraSnESP2YN21YMEWRBag8sH+yFGlF6MaOwaW4TBttlAP+jQyNrapNJOkJ6Yiq9m18yamcN+EVw938sO2c9g1gEsodhln3u25Ew1Sfn8jl60F+edndZN/vWt7xo8VFIR3attroVi9sxnkxHMoPcNsxv21L3u2ERaj1w2mTVJVhGjldr/PlFdIaTKDmFfPjMTVYRNMlHx8SQuNTQc4lRqe7ELdpaiAMA5pc/HwtzDLkyKoo01P1PglzRBTsNRtNjh2OwFJ5TnmAXvA8sbaEEBw41JUY1T1YufytIiKzUiQauHohUb3qdZaBaImMGRKHX4j44WsCAFaJHtPyYyxmohq4EakywIVZrfnSYYOfEkQFuSHJNnTSOFz1ey2mgmO+62Xv7XECgQRY8irjzYQkMwVzkyk9uM+srOPX5JmmrNdw9DSepSttuo/8DzBMYUiaPbxxATzcviXc5X/1ZT6ZaFfhPHGvhOv5Mxqq2acGdNFCtCsxo8R+Byl57C+Rt4lyc+GRijqpkhe1cByj2AjKqbYU0miNDVMFmyGa54Mi6bojvbNZA0G/83oWkgB9U3jViEgRG6h9Bt+v
 W3PXdjeF
 a1UjfVlKCzvf7v0Z7FrfL3649yxwNbe18Kn8fZvro1l6M6t8XHsx2X8qvSxVi4O0x0nuAglO36ZPHQtYerK+LJlZG4SD+Ywz2HB7ggqVmlFdDfNM7twKk9bXFiyoOuXm+UoyFRnDmetu9lMFw2ciJIkmvhZ7w0CdUAV/G7NxQnM1v6TucI1D7zotLNrgZEaCNagjAC+6yuAaUFn4ZM53BRgKnmJie9ywpLrDblMMEoxg9qruiyZ1Wic2qJQtnI+ITKdqWHtym95yDK3oudm67K7dupiunuiftzNjYFrsF0cPuNruikpDbdv/aaAyZvRUYkn20AcNM2c5BLWBm2Wrhh7skqAWyG8Pgu3n25tc4vcu8hDmSE20Ix0NQlWmbvcfBEsWtjlSSCbhgFO3k0ek/BI9H7/VzhJ7UfLImEeuKvS5K1pq0MuJEMuUGE6BOzbEjUs3jYZZZGHDa5arSpp5SnLH92y3CeIZK+EoxTlU2qB6hGpKCfvCKNYib/gT2gFTyiEauwP2gASL3XwYFEPQPcjvvWslYmvM9pCnI0JGlg7VPJqP6MwhMLtDATWO/dgZcUArERFLcM/pBF4qTp98wjKRKDFbH07zpQQZUa/oZj7rXnMxrIdebQfMzw7yipeg0eawVSbyBNApqj9CUHO2S+2oxiN+goqt+XMtH0xDR88PpQAokNO43Q+pMhc1f7e4ISuLr9Yifv48zYTgr7poRjh3HR5SuWZjZGYI8C3NcsUSfgF8=
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
v5:
* Fix annotations for recently modified/added functions.

v4:
* Rename capability -> context analysis.

v2:
* Remove disable/enable_context_analysis() around headers.
---
 include/linux/rhashtable.h | 16 +++++++++++++---
 lib/Makefile               |  2 ++
 lib/rhashtable.c           |  5 +++--
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
index 08e664b21f5a..133ccb39137a 100644
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
@@ -424,13 +428,14 @@ static inline void rht_assign_unlock(struct bucket_table *tbl,
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
 
@@ -612,6 +617,7 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params,
 	const enum rht_lookup_freq freq)
+	__must_hold_shared(RCU)
 {
 	struct rhashtable_compare_arg arg = {
 		.ht = ht,
@@ -666,6 +672,7 @@ static __always_inline struct rhash_head *__rhashtable_lookup(
 static __always_inline void *rhashtable_lookup(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhash_head *he = __rhashtable_lookup(ht, key, params,
 						    RHT_LOOKUP_NORMAL);
@@ -676,6 +683,7 @@ static __always_inline void *rhashtable_lookup(
 static __always_inline void *rhashtable_lookup_likely(
 	struct rhashtable *ht, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhash_head *he = __rhashtable_lookup(ht, key, params,
 						    RHT_LOOKUP_LIKELY);
@@ -727,6 +735,7 @@ static __always_inline void *rhashtable_lookup_fast(
 static __always_inline struct rhlist_head *rhltable_lookup(
 	struct rhltable *hlt, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhash_head *he = __rhashtable_lookup(&hlt->ht, key, params,
 						    RHT_LOOKUP_NORMAL);
@@ -737,6 +746,7 @@ static __always_inline struct rhlist_head *rhltable_lookup(
 static __always_inline struct rhlist_head *rhltable_lookup_likely(
 	struct rhltable *hlt, const void *key,
 	const struct rhashtable_params params)
+	__must_hold_shared(RCU)
 {
 	struct rhash_head *he = __rhashtable_lookup(&hlt->ht, key, params,
 						    RHT_LOOKUP_LIKELY);
diff --git a/lib/Makefile b/lib/Makefile
index e755eee4e76f..22d8742bba57 100644
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
2.52.0.322.g1dd061c0dc-goog


