Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B261CD78792
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24AF86B00CD; Fri, 19 Dec 2025 10:47:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CBA66B00CF; Fri, 19 Dec 2025 10:47:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08C1B6B00D0; Fri, 19 Dec 2025 10:47:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E40A26B00CD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:32 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A95171402EC
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:32 +0000 (UTC)
X-FDA: 84236650344.04.023E14E
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id C5EC41C0020
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cfJdb0d9;
	spf=pass (imf20.hostedemail.com: domain of 3kXNFaQUKCN4ELVERGOOGLE.COMLINUX-MMKVACK.ORG@flex--elver.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3kXNFaQUKCN4ELVERGOOGLE.COMLINUX-MMKVACK.ORG@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4XK3qzntTZnJieCCKu4A/HzWNSoArWneMhDpC7gb9Kg=;
	b=ulCabf8J7Z1DkgyTkeHRl5YWy+6NnvwWwMzqr9V7MAXAlBmTlj6wLpjjStwtOvI+4Hio2L
	JsCJAb2f2YlPrM2fIjELeNg8LLt+TVSO1KF/IfifpHOh9SOSPZOFHFBC9BLtpbrE1tLEPH
	k4dNbscIICzNQU0u7mhm/4ptI++ySnc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cfJdb0d9;
	spf=pass (imf20.hostedemail.com: domain of 3kXNFaQUKCN4ELVERGOOGLE.COMLINUX-MMKVACK.ORG@flex--elver.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3kXNFaQUKCN4ELVERGOOGLE.COMLINUX-MMKVACK.ORG@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159250; a=rsa-sha256;
	cv=none;
	b=cIfa9qHByqZy+f3MUTBPxLSJb2o1UgHNcPWIqPp0d4dBwi7ArorsRZwjINIQX7D3LzYpoh
	ieM2QPXWwFTobfSg+6MZlWWG7EShOK6aJxJUHSXihM8FIWq3DZ7wDRBsoj9XbG3EmCxOK2
	4WWJt+oeja2oB0RhLQggK/TZmgWM/z0=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-64b9ee8a07eso731525a12.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159249; x=1766764049; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4XK3qzntTZnJieCCKu4A/HzWNSoArWneMhDpC7gb9Kg=;
        b=cfJdb0d9TPA/2zwNSWvx+1njcqPHBcepNMuSxyrfSlHApFmshq+L2bW3RxjndvDL4P
         5y25w1gwcZ1ii0JtWXGaGQ1BR1BKjYQLcHjckOwDLxJSFfNLUzWSVhD6EcGo6AMtUME0
         w2l8tSWFup/+SzV2YAqenEF6//2HWOLh3yzIlk0n/upcyOPct9p0vrN2HFtY1kpJHdfe
         DR5SFYBCV7ZlvvACU2WTwq0DPaSiCvS3P8U/ntku/U0NInTdmLHVANxH6Q+TtgQoHpkJ
         aOJSBNYWss8nK8M+Mv1ERaOwyRDuEuaEULaKEOcBHdd4Kew2LeXVTQQBhaEUjwHHCXIt
         h4gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159249; x=1766764049;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4XK3qzntTZnJieCCKu4A/HzWNSoArWneMhDpC7gb9Kg=;
        b=NaaFsg3yTeEf2E34U5KQy1msu2dbLLHV6V4cdCJ30j3CGLm6SCb5pQMD7SgSVDcLVs
         cjm3ezIG8+0Rg1u/qclDpkkz0H5WDRaaCL5Sn9M39rspmpA9eTPUXnvbZT1C1VbIo72l
         A6OqbDG6pRMuMxih0MggBvqgO8q6rnAihR6ffKJzvbwu+wNAJDN54xl9Bqd3esSctYhf
         2GC/WZZ7QJ6+CxhF8WIi1JFvnGCcCQIs5cHm7SFlCpo25x593bZG5/I+E2w/ElepnRqU
         EzICTup5PCXL9O4vW76OFPNfbQNx/6coSu3w+iBiJg4AezbLiirABF6vLlZV2GmQ/F1m
         K8pw==
X-Forwarded-Encrypted: i=1; AJvYcCWUJE+ip2JZzpa3Pr930cZijcZvT3SkEx24kxWSQMbwnwaW0ywGWMF/y2jzJKqWVcMTPrczOCGBpg==@kvack.org
X-Gm-Message-State: AOJu0Yzkyyrc8xaWEm+83NNy6kr6rxSX0AWJ+K9kbV7uzHEa3EifJ/Lm
	Q+vD5NHMPtkvlNKq46AuXxEugzA3Egjf4vX26Hv810Kx5nMu2O+1BzQ5rXIE8QaEzE65FxB0rDU
	iQA==
X-Google-Smtp-Source: AGHT+IHX5UXwk2F+9TvQVKLp2kAzUS4yz1dfz5S20YIyCpvaeeaogsyAn1dyrJKuFHxwFv13c6Ax3+QEyg==
X-Received: from edpr3.prod.google.com ([2002:aa7:c143:0:b0:64b:9f62:a079])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:d62:b0:64b:993f:ce06
 with SMTP id 4fb4d7f45d1cf-64b993fd097mr1762424a12.32.1766159249192; Fri, 19
 Dec 2025 07:47:29 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:20 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-32-elver@google.com>
Subject: [PATCH v5 31/36] stackdepot: Enable context analysis
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
X-Rspamd-Server: rspam02
X-Stat-Signature: g5ip9g3utkg916g7sjnuc5rbu866tegn
X-Rspam-User: 
X-Rspamd-Queue-Id: C5EC41C0020
X-HE-Tag: 1766159250-920443
X-HE-Meta: U2FsdGVkX1+GLujVwBdbbjOQ/6lQ63WodD2csxutsaZXIa5TEna+GHhVqPcWHyfWDAGW1LPoblGwMce286M5ic3NMwdxQEKfp5UmpdREjVJe6Q0tPktRRtlASp26m69f5jeXSiZRK+G1BTIdGn2oJe3UZaTn1HFF23b4YTWKBjx4Uw2Vk85PsuOsNeqX2mzDyE6Zw4YmtOT+EMc85cOaNJhDEM1i54lEkFVTKWoMpc0VuZB6LrUmCv+EjiPEImVV+z/22GgUurg7GP7eJwMyFJ6j7EBQP3lN25Q32YBuO2H4YlLi+f2jdFWH0uAjsw87met0EYf+WtxO1e0ggDebOvuPIb9Hy3qWVcl8MViNp8EjZyiT5o+8WxVM+y6e844eMjrNXjuLpSv0irlTuoKUM/PY77/xnkD1JBwCHKxKf+daBiBk4v4cwXBGFq9Mc4Q3Z2YGwmFURN4e+PfPd8VTqPXSnTVSeh1X68iW5QixfWbbG907rjDuZ4eRzg44IEdi6Xhn3A40w6TG9kbvR4XvStcu1/JvBq1CD15pQpuCpwOQkkS9z226jQYu1StSXG3huoMJH4P6jlcIHAy8aL7Pha5rfa+2vuZU8CXW6CgZYpFkOJfkX5vOvothcO9XH/yqKLb3W9QTaU2sXXCs1iIyIQ+a+ySCsGTVgtC1F72wyo5lm3ym1Vp7zMwUOMUb0WV8/1tWiOkVDTYnSLP/4BN8GdwYtUY5pgHMU0N9z9AF2oneN6/FDHfNn/Qzied6w8M6hc6LX/aFIpBedaDFeanJSCTyZvCyI3jG65g/9nWhCyQ6yy6Ch7SbMpbzJC4Si4chz2n7XUHADrbbz0LDTD3Pi5GSrYq34PkYW9UvQsKJRlV4FniH1O/Lh0kcNMiCcbh/c5mmui7GVtYAg8rl4gZ10TGauA2HzR09ipH0R5PVEbXt2nHzzGmAauetLKHqSIgQF8jjhkr8IZVqNEd9mv3
 osav3ecz
 SdVAOPXxuafISQUF4RFO2W/Il4/x7a2uB8dKwRW89LHqBtckqeE+EKcgMf/7Bx9JKee9eGKWO0zDXCv5BzurNmDGN6e4Ti6brmIOaGrdJ2zJfpuo4qGku4NTc4ApDO0IpEhMwCFfW/Ch+jYmQRT43qraANwTsxB0wtZEfvYlJM+efJRVgCiMeLsK2/JAunPYR7OhgFDiEleaLMewbckJfGLHVf/QSV1jToFMAo1unbi7GZNKx/gBTlq0C8HPF+t/JVXzFCcelQKBeKsy2kzeISq7WVGR6aYnmjXJC3iIdiB7elO0jkUquNRMWpKaWn5Glo86Ra1c+X2pnB96YH1Z3GSNEqE7vAl63eXwHPNkzhMPZVReQK5VISKif+KR5cYz34fC3plquPogZ2As5Fy90Mrze32l5T+QCOEsId6yzKl7nyhmX42grNh3kHWKQ3d/VHJM/DI+jr3iTJwsDDoL+iFUvghr6A+iUHAGuPhOYe/wGd8vr+cDwQN+kElm5zY1xWozjiiFDy4mt/BYMAdHmR6+SzRHRkmeM47kHlw5KWoW3yWqwiGL7i4wLv2E7eEkphz7Czso51Xcm5u29JmmDFgRWlK8GQYXX1VeNfNZLqTokKuBS3RSNYvU/2dB3PE7L6OmaM/TDb3rIaY5iB9KwYIQbGiGM9XJJgHm+9rSQdjNxFnykytEQOrBhSkFhTzTDK+bf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable context analysis for stackdepot.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v2:
* Remove disable/enable_context_analysis() around headers.
---
 lib/Makefile     |  1 +
 lib/stackdepot.c | 20 ++++++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/lib/Makefile b/lib/Makefile
index 89defefbf6c0..e755eee4e76f 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -250,6 +250,7 @@ obj-$(CONFIG_POLYNOMIAL) += polynomial.o
 # Prevent the compiler from calling builtins like memcmp() or bcmp() from this
 # file.
 CFLAGS_stackdepot.o += -fno-builtin
+CONTEXT_ANALYSIS_stackdepot.o := y
 obj-$(CONFIG_STACKDEPOT) += stackdepot.o
 KASAN_SANITIZE_stackdepot.o := n
 # In particular, instrumenting stackdepot.c with KMSAN will result in infinite
diff --git a/lib/stackdepot.c b/lib/stackdepot.c
index de0b0025af2b..166f50ad8391 100644
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
+	pool = context_unsafe(stack_pools[pool_index]);
 	if (WARN_ON(!pool))
 		return NULL;
 
@@ -515,6 +522,7 @@ static struct stack_record *depot_fetch_stack(depot_stack_handle_t handle)
 
 /* Links stack into the freelist. */
 static void depot_free_stack(struct stack_record *stack)
+	__must_not_hold(&pool_lock)
 {
 	unsigned long flags;
 
-- 
2.52.0.322.g1dd061c0dc-goog


