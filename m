Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DE66CA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97AFD8E013B; Thu, 18 Sep 2025 10:06:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B6AC8E013A; Thu, 18 Sep 2025 10:06:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77BC98E013B; Thu, 18 Sep 2025 10:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 634158E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 354AD118A4E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:51 +0000 (UTC)
X-FDA: 83902547022.15.9800D28
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5492D4001C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lXtHuEor;
	spf=pass (imf07.hostedemail.com: domain of 39xHMaAUKCJg6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=39xHMaAUKCJg6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhhK0C9j76pn7jOOIS0RXV1c5LB6TEMUuvpPm0VX42A=;
	b=5qScU5DOItM2p3XUIdV8QEJSwpgmQosOaMnBF0SZ+vJyUMHZw4tlv0eHO27allxyoWHG9P
	56Pemmdyv/vxvkJGG+7uiR/9kQIdbWNJOMBQhMzz3o6zWFpWiCnHRTKOXY5UFARR1zdI5s
	5irSvGhZg4frGjHTdqKi4ipkZjEkXYs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=lXtHuEor;
	spf=pass (imf07.hostedemail.com: domain of 39xHMaAUKCJg6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=39xHMaAUKCJg6DN6J8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204409; a=rsa-sha256;
	cv=none;
	b=f9PS1gpj18LbSgEefz+7KLec4J3b9IZcxSQvzcXc3gBEbA/B4o7FAW+weMmdKeALwvHrz6
	URLCkv+gqaWNpdoey/SYDP5xorBGVinjPIGC05GUd9g0CdZzNo0MrSUpgqNlPp9dOCs8iH
	NW6U3Apb3Cm6HKv7nWipSX9xBCnr3jg=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45f2b9b958aso9461005e9.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204408; x=1758809208; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=YhhK0C9j76pn7jOOIS0RXV1c5LB6TEMUuvpPm0VX42A=;
        b=lXtHuEorRZis1fq2nnjU+bHZafFdEXa+Xg1+muZFPZ/P7S/2DxX4FwpzT+FbwB/Abo
         CK9BzhsWRfyH49EQW+hJXaIwVeEIkMoi1Lq0XNa5cDe+vx/yi8K2PAEgAS/I9NFxiIpX
         KPtzDPPhPjSHgvtm+E2ZdDjjjhGqaEJqS3KW9sTt+RFKwEGSTasasTvNLwWr6daIZ2QC
         LDRNJ0lqBM2IkdFw7UZaU1N6U18O3w3UVrRa1fV6B916OEeZIv8E4lVgrm2NanYtOzL2
         gxHIkQbTQibjJIEo1oIXT9TuMogWYifMTy+aSCQH/ZN6h17SDxwfstIiy6su32iFB3zm
         J2wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204408; x=1758809208;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YhhK0C9j76pn7jOOIS0RXV1c5LB6TEMUuvpPm0VX42A=;
        b=sCL9nl4RP157hxyZvyVd5rITrcbJ6iNoy/Ti5gEq5QH/jNWO4CKys2YMXiPggl8iYG
         4lHzHgUjXt2ZP9I1RaB1klLTZkW4tf08z2lMS+PZa0HdSZvO0aMx9XjmnIU1tPon77Qt
         tIT6+GhqDScH+48mYMyxWKXs90Mk2/ZNKDp+kep9YJUFmVr49CSb8tgZSabWoymypQwG
         eEpsjlN7TWk/92+bidc8l/yeCOzxx6tC+yiP3eWjnMPP6fGe1wJ7bn8lQTRTUgmUl6M4
         8PXVUGWPlf6HQpgS/vaTAiRbbgX1xv0cIDLSp+EwCimP7T0UUsDWaQ1eqCqSoyfqpeQW
         bL7w==
X-Forwarded-Encrypted: i=1; AJvYcCXAnuLX0M9w4WKP5qUiiM8LTuvTh2mCY9EjXwCloUana6rYQ7ERbhRnG1FbXmBZjoZjYWA2SdkQJg==@kvack.org
X-Gm-Message-State: AOJu0YzRSDnJG1ph6o3felMwPVmrkHMgzPGVXOKiv3Oqb3V7bo8JJO6D
	AFsdCN7kjGEhw4rCROZqkCN7ZLhpKM2QU0GAf6pKhOSuWIZyuIEzfmc6HDmdATaA4fn42dl6xVN
	cQw==
X-Google-Smtp-Source: AGHT+IEIwJTlXzbBUbOWKrbjZe2OdxsG9tIePE0FaQDeIxlZs/NdL1maDEOLYHWLdPC4yoU0CtFjf9PRAw==
X-Received: from wmpl42.prod.google.com ([2002:a05:600c:8aa:b0:45d:e45e:96aa])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:444c:b0:45b:47e1:ef69
 with SMTP id 5b1f17b1804b1-46207897e75mr58816305e9.36.1758204407846; Thu, 18
 Sep 2025 07:06:47 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:41 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-31-elver@google.com>
Subject: [PATCH v3 30/35] stackdepot: Enable capability analysis
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
X-Rspamd-Queue-Id: 5492D4001C
X-Rspamd-Server: rspam05
X-Stat-Signature: 9iszc94qdrd9o5pwni75czkcpe7nbqs6
X-Rspam-User: 
X-HE-Tag: 1758204409-937337
X-HE-Meta: U2FsdGVkX195V9sgfdpvjrq1gkTp2+dYHKo5q6vQIE0FyGWrHS2PkqQ3opDWZZQJBnuu42/jFSsTkcnzenUV2ovpvB5Nqkbn5FhwVyOnnX2YxAMFhVJ0P1zYu9XHG2a/O/6YryJfTgC67MFCYxHkj9x21HwhFscWTeug2ZdKTmWjtIgt/qFRmts1drEUKkvJbF4gYSxhJ6haD4TvncOm+Tt1bFcb1uTlnUKOy7EPm2ud1p5tsS/9LPf3r7SIFOi3OffDph1Vf7QlOh8mNjyXDgvswUfw0mOV21thLrQZJSA5Rq1bYVpYExqP/0RKzhE4sQu79UkGziAllv1R8kiVqoMJm907dG8AqzeJfChYzLyf1X1NQFWHijascGmjzbiao0xooJX2aN+wMdaIHZj/3Mo4sh88KrD21R1uXdZbYrQW91WOdoU9Jqd3uoul7IXNe36UFIrumewQQ6ULkLH9b5Um2dg5Glhf17FGlw7zosEJ2L271P6ywQAgwUESV9QQ2UPW/s3zJI+8kZtNlFIbjIb9ogz7rrrDlhHH/WO7J/XM8f03eB1HfZSssDnXB9AV7YR6yQb9e5ARsKQ9iWXOU/Yo8u+9ktDmW57Bn1MNOaE6/5ZzU7vwrCAXVFbcV06HnKalJUDRW5pSvOXwEVGNjB1DDvy2m2fAG2KZNogT26355vqo6IqIJEzZc2+U4cahRjkTIWxVxQlzfu55uF0/Mndx/ICp5zsaJmDE1OvuSVZiomUa/tz5bHbj0iXfyZXNjpr/WmdQfBTNpVkrpl26YctnCw8xtK6/BwwtthvN0t3RUYFZ4IIt08AC4aHBam3MVWlK8pMd00zY+WhTTH4Fk7oSAYMMqeNu0xhqBZbXQrojx27/WueNBDL1jYf3WLWsh/a5GugRicUDDgczL4xgBiMK+WK97nW0sJ6znaIiibBUnUIYILzWqvET5ctlR8e6VkiVjj5IHVb4g3Tp/XU
 t/trQ4Vh
 NdcvqTgYOkHFa/wFFWVoV3CP0F58v73wbWOqwETngLNigZuSxCmaI2of1lUnyOnouW0dKXnxnolljwxAowBryxs6b5rk+rdMV16ZEqcSYQbqcop6TGfNfaEWfkDWOuLF/2AD2ixwIQixTix5+z5UNXHFgs3o1BVQxfduzhuE2Bmjg5sIW2WIxET16iHbKOxQ3z/6pHAhKL/4OB60jKKXVJOG/KTwOqFfw24TZLpwz+QGrAlyx9Nd9cDBSCDLZfYAfQM2UR7ShH0FAVqehD9yKTkuMj55KS0b+rTaQm39S05/Ez6R62k2OSvdXDhKMSFX1sxJT/rQHsJYRQRPKbH28FH12tQiN28zeIjO9RlY72FX7/pmR4rPwQTkBsVn/RXtzULZMZr+CbKwajUBWWs1F/RPc/BppT0vmo5/xn5X7H7l4ltp1oZU/b+GlAvS7tp2B6c9z/vthd5MIRnvpEAZhA0GvUjoHzpowsjbthwYgGUt+mtEhx4E5tl0DM+xU9p05XJl0zO956MVBjNPPsLyvvcm8DVnZXAaoFVoabwF/9EziwRsE/vIY9o6a00SdYMZPeCgIFkrO/PSZp6qsdPWyzTthqRahfS4/l1uCd2YseNqbks0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable capability analysis for stackdepot.

Signed-off-by: Marco Elver <elver@google.com>
---
v2:
* Remove disable/enable_capability_analysis() around headers.
---
 lib/Makefile     |  1 +
 lib/stackdepot.c | 20 ++++++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index e677cb5cc777..43b965046c2c 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -251,6 +251,7 @@ obj-$(CONFIG_POLYNOMIAL) += polynomial.o
 # Prevent the compiler from calling builtins like memcmp() or bcmp() from this
 # file.
 CFLAGS_stackdepot.o += -fno-builtin
+CAPABILITY_ANALYSIS_stackdepot.o := y
 obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
 # In particular, instrumenting stackdepot.c with KMSAN will result in infinite
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index de0b0025af2b..43122294f128 100644
--- a/lib/stackdepot.c
+++ b/lib/stackdepot.c
@@ -61,18 +61,18 @@ static unsigned int stack_bucket_number_order;
 /* Hash mask for indexing the table. */
 static unsigned int stack_hash_mask;
 
+/* The lock must be held when performing pool or freelist modifications. */
+static DEFINE_RAW_SPINLOCK(pool_lock);
 /* Array of memory regions that store stack records. */
-static void **stack_pools;
+static void **stack_pools __pt_guarded_by(&pool_lock);
 /* Newly allocated pool that is not yet added to stack_pools. */
 static void *new_pool;
 /* Number of pools in stack_pools. */
 static int pools_num;
 /* Offset to the unused space in the currently used pool. */
-static size_t pool_offset = DEPOT_POOL_SIZE;
+static size_t pool_offset __guarded_by(&pool_lock) = DEPOT_POOL_SIZE;
 /* Freelist of stack records within stack_pools. */
-static LIST_HEAD(free_stacks);
-/* The lock must be held when performing pool or freelist modifications. */
-static DEFINE_RAW_SPINLOCK(pool_lock);
+static __guarded_by(&pool_lock) LIST_HEAD(free_stacks);
 
 /* Statistics counters for debugfs. */
 enum depot_counter_id {
@@ -291,6 +291,7 @@ EXPORT_SYMBOL_GPL(stack_depot_init);
  * Initializes new stack pool, and updates the list of pools.
  */
 static bool depot_init_pool(void **prealloc)
+	__must_hold(&pool_lock)
 {
 	lockdep_assert_held(&pool_lock);
 
@@ -338,6 +339,7 @@ static bool depot_init_pool(void **prealloc)
 
 /* Keeps the preallocated memory to be used for a new stack depot pool. */
 static void depot_keep_new_pool(void **prealloc)
+	__must_hold(&pool_lock)
 {
 	lockdep_assert_held(&pool_lock);
 
@@ -357,6 +359,7 @@ static void depot_keep_new_pool(void **prealloc)
  * the current pre-allocation.
  */
 static struct stack_record *depot_pop_free_pool(void **prealloc, size_t size)
+	__must_hold(&pool_lock)
 {
 	struct stack_record *stack;
 	void *current_pool;
@@ -391,6 +394,7 @@ static struct stack_record *depot_pop_free_pool(void **prealloc, size_t size)
 
 /* Try to find next free usable entry from the freelist. */
 static struct stack_record *depot_pop_free(void)
+	__must_hold(&pool_lock)
 {
 	struct stack_record *stack;
 
@@ -428,6 +432,7 @@ static inline size_t depot_stack_record_size(struct stack_record *s, unsigned in
 /* Allocates a new stack in a stack depot pool. */
 static struct stack_record *
 depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, depot_flags_t flags, void **prealloc)
+	__must_hold(&pool_lock)
 {
 	struct stack_record *stack = NULL;
 	size_t record_size;
@@ -486,6 +491,7 @@ depot_alloc_stack(unsigned long *entries, unsigned int nr_entries, u32 hash, dep
 }
 
 static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
+	__must_not_hold(&pool_lock)
 {
 	const int pools_num_cached = READ_ONCE(pools_num);
 	union handle_parts parts = { .handle = handle };
@@ -502,7 +508,8 @@ static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
 		return NULL;
 	}
 
-	pool = stack_pools[pool_index];
+	/* @pool_index either valid, or user passed in corrupted value. */
+	pool = capability_unsafe(stack_pools[pool_index]);
 	if (WARN_ON(!pool))
 		return NULL;
 
@@ -515,6 +522,7 @@ static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
 
 /* Links stack into the freelist. */
 static void depot_free_stack(struct stack_record *stack)
+	__must_not_hold(&pool_lock)
 {
 	unsigned long flags;
 
-- 
2.51.0.384.g4c02a37b29-goog


