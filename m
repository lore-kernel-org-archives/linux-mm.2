Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41562D7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8CBA6B00AD; Fri, 19 Dec 2025 10:46:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A606B00AF; Fri, 19 Dec 2025 10:46:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F8326B00B0; Fri, 19 Dec 2025 10:46:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 736686B00AD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2EF535840F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:28 +0000 (UTC)
X-FDA: 84236647656.17.9DBFE48
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id 400211C0016
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TF9AIzIf;
	spf=pass (imf18.hostedemail.com: domain of 3UHNFaQUKCJ0BISBODLLDIB.9LJIFKRU-JJHS79H.LOD@flex--elver.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3UHNFaQUKCJ0BISBODLLDIB.9LJIFKRU-JJHS79H.LOD@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HOUwolzbiNJSOFKZRnPKrSxaUxMsy/Gxmzf+65/vXT8=;
	b=v2Rciu69ohS01Tq1XleldM2Y29UzntNIJh3/gHlWP3bt5H/HTUN3B+T7PnCqZgadU/k/YE
	Z94R6UbL2T5DB1LF41nkasLHqqSAjVwNjjLyA6nUnJ7IVd9QdvCUtGMNEEyqRkTOeLKFrF
	/t4Hcy8W3QjcZ/bgMwtPE6ow505a1x0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TF9AIzIf;
	spf=pass (imf18.hostedemail.com: domain of 3UHNFaQUKCJ0BISBODLLDIB.9LJIFKRU-JJHS79H.LOD@flex--elver.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3UHNFaQUKCJ0BISBODLLDIB.9LJIFKRU-JJHS79H.LOD@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159186; a=rsa-sha256;
	cv=none;
	b=Bo+6ww5r0mpGt49FHzHMuoSyjl629FxZ1lUz5eGd2ohH5T7RfiSobrN5yJW8JlOCe69tg5
	wvgQ7kgGLw0aLE/LhvEYR/D7kae3hrY3ZjSebaZddz9Z90NONQNmgst0YerZ5V0stas9ED
	569XPbK3eDrmpPFEG+7IByKOSmshNs8=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-64d01707c32so10340a12.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159185; x=1766763985; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HOUwolzbiNJSOFKZRnPKrSxaUxMsy/Gxmzf+65/vXT8=;
        b=TF9AIzIfFvUsILzA20WSZhCyNKVT/hyN6GsLqrpx+qjuC0SMGFyWjkKIUT+YAk9G+Y
         Fm05U3gDd8wjVXrw1tCLIcb2cEt9kpEbtyzV4hIDv/ZhEsM5IOwK4mUh4oJCe2nLzrtc
         jpkrA1q93JaBrpzrxSMSwOhV4HFlXAGHz6PXi285dXKSG2Jg9Wn4IyF3yQwMgPkyOGUF
         av2syVrNbVSmw9/GBVNeww2Hd2hqpwH5LVFxLVquEBkH0oFYFRb1dgWPn1FbYk57B6Ge
         GhshAUfPpMWqnRuQBEuWJbg767TKRdoBPJW+N9EMGyvew4gl6GC2WxJlSwNZHeJ44xm9
         mQ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159185; x=1766763985;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HOUwolzbiNJSOFKZRnPKrSxaUxMsy/Gxmzf+65/vXT8=;
        b=VEQhSuwGnqXGZAiP4Rc8rIkjFyaiMIk+B99UNYQGKAzv84DCrdHh7sHw2dcu8vF21V
         IRJshsmsFGcvEB3O7J5+J26EnjpzEdLdFbh9zXX+CjpgjgI9r9UrGdz9JGPOV58cKGEC
         ZdjaLjxnfLob5M2BrjYUVP8x9IsBXAYq7yxCjMrMnBr72vInwCfS4iL1tZutOti148g7
         EDoHAore9yLSsd4TYh3/hsIRMmsBRH6eIKbkZPtM0Mk0Tmv8szhjDuJDGOfwTE/HzW5f
         Z2EahrTPP5wYoctn3+bK4haLe7iyrB6lLA8n2RJf9yDhVtq0ZEDDeiCrhDF1EPnxSywL
         3hEA==
X-Forwarded-Encrypted: i=1; AJvYcCUjQuNe+FlinLxOhlhU/AAXeHt8lV5yC7C6sCRTBmRT/YjsirB6QMUCcnYuaOJwLN+CSn0Vo4Im+g==@kvack.org
X-Gm-Message-State: AOJu0YyzE5jQLo6FXDH3YsSlXGsZBCE9VztXKTznEwsbBN757rTXCNL5
	zehGfjAPRxpxdboSGOmXeQolOn94RclrPj8FHk2J/tBFIneq2GvqtfbpDBSmZRhxD+toWbIlN0H
	sJw==
X-Google-Smtp-Source: AGHT+IG8HOTfxr1WNzO/Dc+GOb4HsZbQh+hYfqKNDqegaOX6AdQDOkKoX2hK7UyCMxtgqNumtqifsWNf8A==
X-Received: from edzd6.prod.google.com ([2002:a05:6402:8c6:b0:64b:6d46:21e6])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6402:1d53:b0:64b:654f:8738
 with SMTP id 4fb4d7f45d1cf-64b8e94bf4emr2676096a12.14.1766159184533; Fri, 19
 Dec 2025 07:46:24 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:04 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-16-elver@google.com>
Subject: [PATCH v5 15/36] srcu: Support Clang's context analysis
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
X-Stat-Signature: w179nobukm5y9pjekrkaddaoojruz31p
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 400211C0016
X-HE-Tag: 1766159186-151118
X-HE-Meta: U2FsdGVkX1/HJTKM2boBNAePSFJpRIG2H9yKMeSNUM55GvA0p0KP5oGYSOvBAauq8MxwAAi2m2kSFCeBWlzoDrSB//E2yZcYr00uOo8EKdFW/F1STOPI1aaM9G6Jdd8rdk5AhOyKCJsT0W7Qee+XnRyYgadmo0H+fIwkXYqFgw0KO2QKlxJIiZ3HStJ1vnLzSqfr1DcFeUIId6B4TjHEYIYdeksqgO5Hf6Z3zGw2CGR7AXr+WPdSaaYZxPPG2mUEyhAEEYQxURwhtkjvV1Is9Jt+P+bk9N2S34Y4/xqn9a4xsyPLl8j79zcnC45wvYbtWY8b+PSPoSH2LHCTCfLV7K+/XEeDWAKIz2FVMihqxeomH4MJL7p3/krkRuF1hXHlKA2M2LlLiobzbU2yjAoKP9aARHlnzc1CLOUgooY5IJXvHHNf/rsynrPr5xNT825ownbOAFBUawilEf5Tks4nsBWqVfYDqKnLU+8MT47id5fpOoT+4Gdl9IMtaBA8/clEaDSvS3r3krt2BDfZGNzlyiAN56C2xDZv36bOTDwzVZgsB/DM1MKpAu3P2q7kt6IWpek+I7B8jL4VHn253HYbVVo/OK6Xr6pnlT5mEMBqzok95u3qQH4QY60hDeGekpY768UbwIoX/z+ret11XHAC0qrjUyoQFfSPDT5KfUVOfACp1fMmQqEjSbHHaQZy6s4ylwYIyd2a9TV3PCAPAtdjktmcO43yHfNVupjed55SPFLv4n156CMAfuP84boAWw2cKmMyrxQnaV+ByrHH0z+DLmIgcaVh18pMt1gSKvpgBkUoXgbNukDhtzS2s9xWg+9HUxXt3lyjbS130AKOOCCCWw2+A/1w2VOaW9WIwZUyMTXlDkCkhGQzIu5+eF2XsfJDJi8LV8fhlNh5Uvrl5vOBavTeEc6RdhIlDt0Xr6jnCzXeimlETCU/VeKcsavd3LIq1zlFeiRvuVEJ/KuvLpd
 X6jJ3Dms
 F1njhBUG2uitWltt3/kEVjVxi3CWiA+kooplq15FWWGFPqryT1jSrV3hJDXOBqwK2gHbe/23VPDriLi5Mbtm+0neeTOJMsh9IHie5UvVZRYHJdqjVicmG3fVD695TuRO22NCC/i2Eo2t0YI/bVWu0+p7jsu+ta+gHeMks0H3YuDcXEQeZ2DU4BQVOjY//Ug3hy1thF/7KIyDJatVGadTYMkSZ7qwcS+jxQyqgkApnoPFbOaMOW1aXPctCFFX1R1jPoeXKG7aGKIb5XlN1tN/Se3XE1rjVy+Ukk7PVRxDfwI4nC9CV54aaOibkmedG1V0kR1grBvJqlI97n1Ue1NZu1p7J0HCrxHuo7+KgtS4noIPB1QdahCWyFbN0xJdfQKiJZbE+AjrgYFFKD/zUbRyDGnzm+2pJp5TyGrGNBtPl8TIO1/fV8lvl6C3r+KGarqubf6h3YS+rmOhtk2S57nXN8efUJDqpCFy+Ygnqdu7ZHLRj6YVLYydvyLTSLg4SdQzZYukxgVHrH+v/SUEVLtTQAvjyFR8GPwcls3tazHXJqZJhcBHIfsDp20HdyidGEPL4N0GVHbN4c0lhtFuag4lrOzqbH8MVdzGxJ5TeqcuVQl3jMZLdacjtI2aXaPeks/B4BTjX1YyDi1tTXc9pnEGXqofkoLb0wspNcX5+jS2n9F3zby7KGdH2yxgCeonNrtaUxIM8fmPUuZyszXlcFOlMNkxTuQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's context analysis for SRCU.

Signed-off-by: Marco Elver <elver@google.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
---
v5:
* Fix up annotation for recently added SRCU interfaces.
* Rename "context guard" -> "context lock".
* Use new cleanup.h helpers to properly support scoped lock guards.

v4:
* Rename capability -> context analysis.

v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* Support SRCU being reentrant.
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/srcu.h                         | 73 ++++++++++++++------
 include/linux/srcutiny.h                     |  6 ++
 include/linux/srcutree.h                     | 10 ++-
 lib/test_context-analysis.c                  | 25 +++++++
 5 files changed, 91 insertions(+), 25 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index 3bc72f71fe25..f7736f1c0767 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -80,7 +80,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`).
 
 For context locks with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 344ad51c8f6c..bb44a0bd7696 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -21,7 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/rcu_segcblist.h>
 
-struct srcu_struct;
+context_lock_struct(srcu_struct, __reentrant_ctx_lock);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
@@ -77,7 +77,7 @@ int init_srcu_struct_fast_updown(struct srcu_struct *ssp);
 #define SRCU_READ_FLAVOR_SLOWGP		(SRCU_READ_FLAVOR_FAST | SRCU_READ_FLAVOR_FAST_UPDOWN)
 						// Flavors requiring synchronize_rcu()
 						// instead of smp_mb().
-void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases(ssp);
+void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases_shared(ssp);
 
 #ifdef CONFIG_TINY_SRCU
 #include <linux/srcutiny.h>
@@ -131,14 +131,16 @@ static inline bool same_state_synchronize_srcu(unsigned long oldstate1, unsigned
 }
 
 #ifdef CONFIG_NEED_SRCU_NMI_SAFE
-int __srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp);
-void __srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx) __releases(ssp);
+int __srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires_shared(ssp);
+void __srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx) __releases_shared(ssp);
 #else
 static inline int __srcu_read_lock_nmisafe(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	return __srcu_read_lock(ssp);
 }
 static inline void __srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx)
+	__releases_shared(ssp)
 {
 	__srcu_read_unlock(ssp, idx);
 }
@@ -210,6 +212,14 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
 
 #endif /* #else #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
+/*
+ * No-op helper to denote that ssp must be held. Because SRCU-protected pointers
+ * should still be marked with __rcu_guarded, and we do not want to mark them
+ * with __guarded_by(ssp) as it would complicate annotations for writers, we
+ * choose the following strategy: srcu_dereference_check() calls this helper
+ * that checks that the passed ssp is held, and then fake-acquires 'RCU'.
+ */
+static inline void __srcu_read_lock_must_hold(const struct srcu_struct *ssp) __must_hold_shared(ssp) { }
 
 /**
  * srcu_dereference_check - fetch SRCU-protected pointer for later dereferencing
@@ -223,9 +233,15 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
  * to 1.  The @c argument will normally be a logical expression containing
  * lockdep_is_held() calls.
  */
-#define srcu_dereference_check(p, ssp, c) \
-	__rcu_dereference_check((p), __UNIQUE_ID(rcu), \
-				(c) || srcu_read_lock_held(ssp), __rcu)
+#define srcu_dereference_check(p, ssp, c)					\
+({										\
+	__srcu_read_lock_must_hold(ssp);					\
+	__acquire_shared_ctx_lock(RCU);					\
+	__auto_type __v = __rcu_dereference_check((p), __UNIQUE_ID(rcu),	\
+				(c) || srcu_read_lock_held(ssp), __rcu);	\
+	__release_shared_ctx_lock(RCU);					\
+	__v;									\
+})
 
 /**
  * srcu_dereference - fetch SRCU-protected pointer for later dereferencing
@@ -268,7 +284,8 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
  * invoke srcu_read_unlock() from one task and the matching srcu_read_lock()
  * from another.
  */
-static inline int srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_read_lock(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -304,7 +321,8 @@ static inline int srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp)
  * contexts where RCU is watching, that is, from contexts where it would
  * be legal to invoke rcu_read_lock().  Otherwise, lockdep will complain.
  */
-static inline struct srcu_ctr __percpu *srcu_read_lock_fast(struct srcu_struct *ssp) __acquires(ssp)
+static inline struct srcu_ctr __percpu *srcu_read_lock_fast(struct srcu_struct *ssp) __acquires_shared(ssp)
+	__acquires_shared(ssp)
 {
 	struct srcu_ctr __percpu *retval;
 
@@ -344,7 +362,7 @@ static inline struct srcu_ctr __percpu *srcu_read_lock_fast(struct srcu_struct *
  * complain.
  */
 static inline struct srcu_ctr __percpu *srcu_read_lock_fast_updown(struct srcu_struct *ssp)
-__acquires(ssp)
+	__acquires_shared(ssp)
 {
 	struct srcu_ctr __percpu *retval;
 
@@ -360,7 +378,7 @@ __acquires(ssp)
  * See srcu_read_lock_fast() for more information.
  */
 static inline struct srcu_ctr __percpu *srcu_read_lock_fast_notrace(struct srcu_struct *ssp)
-	__acquires(ssp)
+	__acquires_shared(ssp)
 {
 	struct srcu_ctr __percpu *retval;
 
@@ -381,7 +399,7 @@ static inline struct srcu_ctr __percpu *srcu_read_lock_fast_notrace(struct srcu_
  * and srcu_read_lock_fast().  However, the same definition/initialization
  * requirements called out for srcu_read_lock_safe() apply.
  */
-static inline struct srcu_ctr __percpu *srcu_down_read_fast(struct srcu_struct *ssp) __acquires(ssp)
+static inline struct srcu_ctr __percpu *srcu_down_read_fast(struct srcu_struct *ssp) __acquires_shared(ssp)
 {
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_PROVE_RCU) && in_nmi());
 	RCU_LOCKDEP_WARN(!rcu_is_watching(), "RCU must be watching srcu_down_read_fast().");
@@ -400,7 +418,8 @@ static inline struct srcu_ctr __percpu *srcu_down_read_fast(struct srcu_struct *
  * then none of the other flavors may be used, whether before, during,
  * or after.
  */
-static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -412,7 +431,8 @@ static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp
 
 /* Used by tracing, cannot be traced and cannot invoke lockdep. */
 static inline notrace int
-srcu_read_lock_notrace(struct srcu_struct *ssp) __acquires(ssp)
+srcu_read_lock_notrace(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -443,7 +463,8 @@ srcu_read_lock_notrace(struct srcu_struct *ssp) __acquires(ssp)
  * which calls to down_read() may be nested.  The same srcu_struct may be
  * used concurrently by srcu_down_read() and srcu_read_lock().
  */
-static inline int srcu_down_read(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_down_read(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	WARN_ON_ONCE(in_nmi());
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
@@ -458,7 +479,7 @@ static inline int srcu_down_read(struct srcu_struct *ssp) __acquires(ssp)
  * Exit an SRCU read-side critical section.
  */
 static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
@@ -474,7 +495,7 @@ static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
  * Exit a light-weight SRCU read-side critical section.
  */
 static inline void srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_FAST);
 	srcu_lock_release(&ssp->dep_map);
@@ -490,7 +511,7 @@ static inline void srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ct
  * Exit an SRCU-fast-updown read-side critical section.
  */
 static inline void
-srcu_read_unlock_fast_updown(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp) __releases(ssp)
+srcu_read_unlock_fast_updown(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp) __releases_shared(ssp)
 {
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_FAST_UPDOWN);
 	srcu_lock_release(&ssp->dep_map);
@@ -504,7 +525,7 @@ srcu_read_unlock_fast_updown(struct srcu_struct *ssp, struct srcu_ctr __percpu *
  * See srcu_read_unlock_fast() for more information.
  */
 static inline void srcu_read_unlock_fast_notrace(struct srcu_struct *ssp,
-						 struct srcu_ctr __percpu *scp) __releases(ssp)
+						 struct srcu_ctr __percpu *scp) __releases_shared(ssp)
 {
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_FAST);
 	__srcu_read_unlock_fast(ssp, scp);
@@ -519,7 +540,7 @@ static inline void srcu_read_unlock_fast_notrace(struct srcu_struct *ssp,
  * the same context as the maching srcu_down_read_fast().
  */
 static inline void srcu_up_read_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_PROVE_RCU) && in_nmi());
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_FAST_UPDOWN);
@@ -535,7 +556,7 @@ static inline void srcu_up_read_fast(struct srcu_struct *ssp, struct srcu_ctr __
  * Exit an SRCU read-side critical section, but in an NMI-safe manner.
  */
 static inline void srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NMI);
@@ -545,7 +566,7 @@ static inline void srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx)
 
 /* Used by tracing, cannot be traced and cannot call lockdep. */
 static inline notrace void
-srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases(ssp)
+srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases_shared(ssp)
 {
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
 	__srcu_read_unlock(ssp, idx);
@@ -560,7 +581,7 @@ srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases(ssp)
  * the same context as the maching srcu_down_read().
  */
 static inline void srcu_up_read(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	WARN_ON_ONCE(in_nmi());
@@ -600,15 +621,21 @@ DEFINE_LOCK_GUARD_1(srcu, struct srcu_struct,
 		    _T->idx = srcu_read_lock(_T->lock),
 		    srcu_read_unlock(_T->lock, _T->idx),
 		    int idx)
+DECLARE_LOCK_GUARD_1_ATTRS(srcu, __acquires_shared(_T), __releases_shared(*(struct srcu_struct **)_T))
+#define class_srcu_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(srcu, _T)
 
 DEFINE_LOCK_GUARD_1(srcu_fast, struct srcu_struct,
 		    _T->scp = srcu_read_lock_fast(_T->lock),
 		    srcu_read_unlock_fast(_T->lock, _T->scp),
 		    struct srcu_ctr __percpu *scp)
+DECLARE_LOCK_GUARD_1_ATTRS(srcu_fast, __acquires_shared(_T), __releases_shared(*(struct srcu_struct **)_T))
+#define class_srcu_fast_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(srcu_fast, _T)
 
 DEFINE_LOCK_GUARD_1(srcu_fast_notrace, struct srcu_struct,
 		    _T->scp = srcu_read_lock_fast_notrace(_T->lock),
 		    srcu_read_unlock_fast_notrace(_T->lock, _T->scp),
 		    struct srcu_ctr __percpu *scp)
+DECLARE_LOCK_GUARD_1_ATTRS(srcu_fast_notrace, __acquires_shared(_T), __releases_shared(*(struct srcu_struct **)_T))
+#define class_srcu_fast_notrace_constructor(_T) WITH_LOCK_GUARD_1_ATTRS(srcu_fast_notrace, _T)
 
 #endif
diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
index e0698024667a..dec7cbe015aa 100644
--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -73,6 +73,7 @@ void synchronize_srcu(struct srcu_struct *ssp);
  * index that must be passed to the matching srcu_read_unlock().
  */
 static inline int __srcu_read_lock(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int idx;
 
@@ -80,6 +81,7 @@ static inline int __srcu_read_lock(struct srcu_struct *ssp)
 	idx = ((READ_ONCE(ssp->srcu_idx) + 1) & 0x2) >> 1;
 	WRITE_ONCE(ssp->srcu_lock_nesting[idx], READ_ONCE(ssp->srcu_lock_nesting[idx]) + 1);
 	preempt_enable();
+	__acquire_shared(ssp);
 	return idx;
 }
 
@@ -96,22 +98,26 @@ static inline struct srcu_ctr __percpu *__srcu_ctr_to_ptr(struct srcu_struct *ss
 }
 
 static inline struct srcu_ctr __percpu *__srcu_read_lock_fast(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	return __srcu_ctr_to_ptr(ssp, __srcu_read_lock(ssp));
 }
 
 static inline void __srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
+	__releases_shared(ssp)
 {
 	__srcu_read_unlock(ssp, __srcu_ptr_to_ctr(ssp, scp));
 }
 
 static inline struct srcu_ctr __percpu *__srcu_read_lock_fast_updown(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	return __srcu_ctr_to_ptr(ssp, __srcu_read_lock(ssp));
 }
 
 static inline
 void __srcu_read_unlock_fast_updown(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
+	__releases_shared(ssp)
 {
 	__srcu_read_unlock(ssp, __srcu_ptr_to_ctr(ssp, scp));
 }
diff --git a/include/linux/srcutree.h b/include/linux/srcutree.h
index d6f978b50472..958cb7ef41cb 100644
--- a/include/linux/srcutree.h
+++ b/include/linux/srcutree.h
@@ -233,7 +233,7 @@ struct srcu_struct {
 #define DEFINE_STATIC_SRCU_FAST_UPDOWN(name) \
 					__DEFINE_SRCU(name, SRCU_READ_FLAVOR_FAST_UPDOWN, static)
 
-int __srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp);
+int __srcu_read_lock(struct srcu_struct *ssp) __acquires_shared(ssp);
 void synchronize_srcu_expedited(struct srcu_struct *ssp);
 void srcu_barrier(struct srcu_struct *ssp);
 void srcu_expedite_current(struct srcu_struct *ssp);
@@ -286,6 +286,7 @@ static inline struct srcu_ctr __percpu *__srcu_ctr_to_ptr(struct srcu_struct *ss
  * implementations of this_cpu_inc().
  */
 static inline struct srcu_ctr __percpu notrace *__srcu_read_lock_fast(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	struct srcu_ctr __percpu *scp = READ_ONCE(ssp->srcu_ctrp);
 
@@ -294,6 +295,7 @@ static inline struct srcu_ctr __percpu notrace *__srcu_read_lock_fast(struct src
 	else
 		atomic_long_inc(raw_cpu_ptr(&scp->srcu_locks));  // Y, and implicit RCU reader.
 	barrier(); /* Avoid leaking the critical section. */
+	__acquire_shared(ssp);
 	return scp;
 }
 
@@ -308,7 +310,9 @@ static inline struct srcu_ctr __percpu notrace *__srcu_read_lock_fast(struct src
  */
 static inline void notrace
 __srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
+	__releases_shared(ssp)
 {
+	__release_shared(ssp);
 	barrier();  /* Avoid leaking the critical section. */
 	if (!IS_ENABLED(CONFIG_NEED_SRCU_NMI_SAFE))
 		this_cpu_inc(scp->srcu_unlocks.counter);  // Z, and implicit RCU reader.
@@ -326,6 +330,7 @@ __srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
  */
 static inline
 struct srcu_ctr __percpu notrace *__srcu_read_lock_fast_updown(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	struct srcu_ctr __percpu *scp = READ_ONCE(ssp->srcu_ctrp);
 
@@ -334,6 +339,7 @@ struct srcu_ctr __percpu notrace *__srcu_read_lock_fast_updown(struct srcu_struc
 	else
 		atomic_long_inc(raw_cpu_ptr(&scp->srcu_locks));  // Y, and implicit RCU reader.
 	barrier(); /* Avoid leaking the critical section. */
+	__acquire_shared(ssp);
 	return scp;
 }
 
@@ -348,7 +354,9 @@ struct srcu_ctr __percpu notrace *__srcu_read_lock_fast_updown(struct srcu_struc
  */
 static inline void notrace
 __srcu_read_unlock_fast_updown(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
+	__releases_shared(ssp)
 {
+	__release_shared(ssp);
 	barrier();  /* Avoid leaking the critical section. */
 	if (!IS_ENABLED(CONFIG_NEED_SRCU_NMI_SAFE))
 		this_cpu_inc(scp->srcu_unlocks.counter);  // Z, and implicit RCU reader.
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 559df32fb5f8..39e03790c0f6 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -10,6 +10,7 @@
 #include <linux/rcupdate.h>
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
+#include <linux/srcu.h>
 
 /*
  * Test that helper macros work as expected.
@@ -369,3 +370,27 @@ static void __used test_rcu_assert_variants(void)
 	lockdep_assert_in_rcu_read_lock_sched();
 	wants_rcu_held_sched();
 }
+
+struct test_srcu_data {
+	struct srcu_struct srcu;
+	long __rcu_guarded *data;
+};
+
+static void __used test_srcu(struct test_srcu_data *d)
+{
+	init_srcu_struct(&d->srcu);
+
+	int idx = srcu_read_lock(&d->srcu);
+	long *data = srcu_dereference(d->data, &d->srcu);
+	(void)data;
+	srcu_read_unlock(&d->srcu, idx);
+
+	rcu_assign_pointer(d->data, NULL);
+}
+
+static void __used test_srcu_guard(struct test_srcu_data *d)
+{
+	{ guard(srcu)(&d->srcu); (void)srcu_dereference(d->data, &d->srcu); }
+	{ guard(srcu_fast)(&d->srcu); (void)srcu_dereference(d->data, &d->srcu); }
+	{ guard(srcu_fast_notrace)(&d->srcu); (void)srcu_dereference(d->data, &d->srcu); }
+}
-- 
2.52.0.322.g1dd061c0dc-goog


