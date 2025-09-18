Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F709CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8E98E012C; Thu, 18 Sep 2025 10:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99328E0112; Thu, 18 Sep 2025 10:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BE18E012C; Thu, 18 Sep 2025 10:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 884F18E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 506A11A01F2
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:11 +0000 (UTC)
X-FDA: 83902545342.24.C5AFC34
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D8E51C000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oaZwOfpi;
	spf=pass (imf20.hostedemail.com: domain of 3zxHMaAUKCHASZjSfUccUZS.QcaZWbil-aaYjOQY.cfU@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3zxHMaAUKCHASZjSfUccUZS.QcaZWbil-aaYjOQY.cfU@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZC4ZOE8JE+M8LbYw3r+YcY7P7dk+Wk5ZJQlr/Vrksc=;
	b=CIjk3dJkl7wuniFMoQp+zO3SLivd7Hu/oK5CnO8ll6GgFULDdLqy3GHfIHduYHgVJONehw
	Tr+izeMSUThJLtCq0/Ah2Zskk31mmXm9e7Oab8kKN/UVAmGBgX/4h3BcqUB6aHEoRTEtP0
	XWR777kxEdM+Jf91EkC1YMmlBpRuIGE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204369; a=rsa-sha256;
	cv=none;
	b=00KKiNVJwNadpjK41Jkha3t9IvXL9jOev6k2JoAd2GDjWGy1gcu3W5/XGQaEOZxKS0dvsQ
	H2En3NG0fJ25MYYoxiE9ZvdP39QQ48QPreUf3t07izA+9DcrdmkuzARVaF0/wdTU6sLvoY
	fxF4KcEUh0BQFXfwFVbJoliucZjmvI8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=oaZwOfpi;
	spf=pass (imf20.hostedemail.com: domain of 3zxHMaAUKCHASZjSfUccUZS.QcaZWbil-aaYjOQY.cfU@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3zxHMaAUKCHASZjSfUccUZS.QcaZWbil-aaYjOQY.cfU@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-3ec7be07a24so363739f8f.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204368; x=1758809168; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uZC4ZOE8JE+M8LbYw3r+YcY7P7dk+Wk5ZJQlr/Vrksc=;
        b=oaZwOfpiCWQ9V0opueMvc32lDFUd2aJnGkZUNMIdZNz+3yRAB64xmmmZN6uCvWyoVs
         OZRbJ1T4nKAJ/kMrLUUDJDQFRQfzksDz3I2BIfJAfelGAp77meWStm+R+dlckKu7hSBt
         n9fUU9wvJnZogXwfwE+Dw0R3qJUysrpKzZLX5R6WcehZ3PNRXxImUPRd0ZMCj4wvyMcB
         +Wi2mu37khs3aaC774Sd2IVyZeXcTUxMkhVz06FFPL+hjc2mHYQM8ztoZR8CXGhWtflM
         RhSJ9UUmC8ctjxEaRfprs6YojT8UDvq7JkjJFUVMIepqhm2TAHK2AFa7kFGvc574lNM+
         uFOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204368; x=1758809168;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uZC4ZOE8JE+M8LbYw3r+YcY7P7dk+Wk5ZJQlr/Vrksc=;
        b=v8fZDDvXPlbOY9IZ5PaQUTdJTf0ZtCIcgyzf2S9YQrKYcXLZTj3RvqTFqPRrxWRB6F
         UmXrakPCTyPxuThP9MuaEOWoxuzGC31DVMi5vffUMKKaBC0CPTLY5Wun+KCZxBLHx+Zz
         FI98vF3JFZz03xjty8jgP64W/E2MrnKEAbGqA+AS6p+XrOdESxZWYz6WX8A04kOGglJJ
         S0ItUsOTenkgYj5WJVP/VAlsqVPQTuO1YD/lAvFKVs2epj8fARojSIDv8wiHDQn+Zyrq
         AgK5EC3HTjIN+32w8tiWD/0QbaPHiX8oFw8v1mFwWdCL2JDyrSAy8AlRmf/bpL/rlbgQ
         WdjA==
X-Forwarded-Encrypted: i=1; AJvYcCXCayJQp2YAqHTZB0obL25rDX59bmWt/76TjwAnK6Bvp2t/Hfh235jhVq3GZoszA32Ikkzl7y27Iw==@kvack.org
X-Gm-Message-State: AOJu0Yyc0yTuxZecd28aKpa7Y1axYmJBoxJt6/mIt7UFL9ZgT0FHEBw5
	CkEVxjSTVe6rBpXW4Sva4xJiA9uQxXIyi3cLQ0JFKqg7wEfbnWpjnrXIzM8oaAWEEf0CuPHzy1t
	/mA==
X-Google-Smtp-Source: AGHT+IErGnNUtVWtw5wt6ngF4KBlc2sTC7xdm7qy0xDdBV9Ewux4kyrKYgwxcj7jBTO4Xps49TpxyhLVvA==
X-Received: from wrva2.prod.google.com ([2002:a5d:5702:0:b0:3ed:e1d6:f198])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2601:b0:3e2:da00:44af
 with SMTP id ffacd0b85a97d-3ecdfa1ebbfmr5132620f8f.36.1758204367579; Thu, 18
 Sep 2025 07:06:07 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:26 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-16-elver@google.com>
Subject: [PATCH v3 15/35] srcu: Support Clang's capability analysis
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
X-Stat-Signature: kz7b9ry9a5w494h9obwggrgiegackajp
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D8E51C000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1758204369-575138
X-HE-Meta: U2FsdGVkX18a1qqsstmzx3wgCoVev2GjLK61f3tmD3laktsn+LbAVNhD8xPxfS224SOLY8TgVAC8qs2XgJhTIh+nWCgRnQPo5X68vjgqc5X8NHgj08VFnknt8+Hmk2CaOvhBVgpGMJXRbbO8CGeQsaDZ3EqM7E1Cj4tsbgf8QWKGg9VXH/E0CF3NFNurqWKvAVmbwtu4ounbOBKXur0zSUL49TyvG3BxFtglA7UPtL2dWd/Yu/uxAR8NsKW3gM+mKOQepKRsnH50tu8+qsLJ2ThmOVDTvGq7ctIUN4kQrUzPP+mTU90HQYQQ2VYTysi/xbiivDLe0+CZIP5riUswBIxAJSEv1FD7IYrZha59AFLz+bkY8kLX+dJSWTR4GzQ2eFk/54WjDe+4gfVjdilo1bhpp2xhnCqoPwQUtFYJcKHJTP96opQ4+Bq0bqjfgj6AzMMNfZR/tuHNt8zO2BrCkz9NtagRTaGSHQF3d0oT0JOQaewlraxPDf7Y54UuMjJja2e00vopr7754lIVtVZAx0lqD80cC8Rgryf845STLf7nKv72WUFchvv3pqYQDOOny0ddbAiVO4WwVGyyUVXPlcxtQuAoxvxg4C4T/0jbcYXmDIp95aqFg/Cf5VY6n4n/f8UwwujhRXHQukbsxO5eOZQ6a1dK6RjZHHcKZjqK04aqFf6hp7yWiKxoGvqLX9T1xs2Y41EA76YRxa+gIA9ssmEUx9wnbHxR19FWVvCj3o6HXk+It/wXBJsZzLJ2sq3+lmWcC2OC/TydK5BE+c0H8brWzx7PhgS/TLQzRYVOWiMCLjPrw3zteX+vaBoVvatRz2ZQVVPuR9FCBfrB/jnFKqJMHq89z8daVXxKiW0JGRhOqw0IEXZ8JJmoPXtgltYmT7VkGBCy1WYNoEq89rGXEQXr9RISCsOY4CswwZNxXXnKkx0fW4TqsanYfXDgUrafd55FXCduDZCIA40BPE6
 HJbtVVnk
 Smr2T0SzXzrfl6kpqPj4I2BJNqxq+AR88f+DaJ4cd71glAVpkOTRsi6WXbgyC8uczO2ybuflKnhYgFiQkH9XabWIHssJwV2IsJp0GvsRTq/LscwV+ZsbwkMtGOg6zVLMXhs5WFUtWHkvkb2ni1x/sFebglcaMi+Xf/REDoDoaIbiuCO/hVPckWGfBlpAHR8myHuXov8nde2yjyvIXxm9+iOwGEuiqS6kbXsKRowqk/VwvBnWFpgtO3a37O7z1vi14bCIZNT0K0+m9lAI75AYzYfE6kVI8/ZQlTJmTlTm7oWTuidLbGGqaKUz4zcVXcW/+tMciiEbV35cI2+aNZ/mQyCBVHmrovV842GUuIEHuJ3Rqzr20s4PXd7nv1rLSZ8orZ2RcSS6dnabZ02UfWL6KWBUXn2vGodBlJnVUtVebm/6BZv+82qedzSp2MiCvz90nQz9nogBPztH0CjZaY8WOS7WWdADOParJ2OTG+gn7VONsfeEzR8J5Cx3DKVnFNlujk1vPHPVDOXcN38gh8lYBnu3zekQBEjYSdvxShwzJj1OZWi3MxSj+vlD6jWVyQXiYzHBFNzRLg5YUGFei2oIHMpozoE0vHCXG3G+KbY2VvGP6jkM/T3OQ0qMG5tVw1hSGO5nCY+H1lqwhiPk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's capability analysis for SRCU.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* Support SRCU being reentrant.
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/srcu.h                          | 60 +++++++++++++------
 include/linux/srcutiny.h                      |  4 ++
 include/linux/srcutree.h                      |  6 +-
 lib/test_capability-analysis.c                | 24 ++++++++
 5 files changed, 75 insertions(+), 21 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index fdacc7f73da8..779ecb5ec17a 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -82,7 +82,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`).
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index f179700fecaf..6cafaf6dde71 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -21,7 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/rcu_segcblist.h>
 
-struct srcu_struct;
+struct_with_capability(srcu_struct, __reentrant_cap);
 
 #ifdef CONFIG_DEBUG_LOCK_ALLOC
 
@@ -53,7 +53,7 @@ int init_srcu_struct(struct srcu_struct *ssp);
 #define SRCU_READ_FLAVOR_SLOWGP	SRCU_READ_FLAVOR_FAST
 						// Flavors requiring synchronize_rcu()
 						// instead of smp_mb().
-void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases(ssp);
+void __srcu_read_unlock(struct srcu_struct *ssp, int idx) __releases_shared(ssp);
 
 #ifdef CONFIG_TINY_SRCU
 #include <linux/srcutiny.h>
@@ -107,14 +107,16 @@ static inline bool same_state_synchronize_srcu(unsigned long oldstate1, unsigned
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
@@ -186,6 +188,14 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
 
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
@@ -199,9 +209,15 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
  * to 1.  The @c argument will normally be a logical expression containing
  * lockdep_is_held() calls.
  */
-#define srcu_dereference_check(p, ssp, c) \
-	__rcu_dereference_check((p), __UNIQUE_ID(rcu), \
-				(c) || srcu_read_lock_held(ssp), __rcu)
+#define srcu_dereference_check(p, ssp, c)					\
+({										\
+	__srcu_read_lock_must_hold(ssp);					\
+	__acquire_shared_cap(RCU);						\
+	__auto_type __v = __rcu_dereference_check((p), __UNIQUE_ID(rcu),	\
+				(c) || srcu_read_lock_held(ssp), __rcu);	\
+	__release_shared_cap(RCU);						\
+	__v;									\
+})
 
 /**
  * srcu_dereference - fetch SRCU-protected pointer for later dereferencing
@@ -244,7 +260,8 @@ static inline int srcu_read_lock_held(const struct srcu_struct *ssp)
  * invoke srcu_read_unlock() from one task and the matching srcu_read_lock()
  * from another.
  */
-static inline int srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_read_lock(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -271,7 +288,8 @@ static inline int srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp)
  * where RCU is watching, that is, from contexts where it would be legal
  * to invoke rcu_read_lock().  Otherwise, lockdep will complain.
  */
-static inline struct srcu_ctr __percpu *srcu_read_lock_fast(struct srcu_struct *ssp) __acquires(ssp)
+static inline struct srcu_ctr __percpu *srcu_read_lock_fast(struct srcu_struct *ssp) __acquires_shared(ssp)
+	__acquires_shared(ssp)
 {
 	struct srcu_ctr __percpu *retval;
 
@@ -292,7 +310,7 @@ static inline struct srcu_ctr __percpu *srcu_read_lock_fast(struct srcu_struct *
  * The same srcu_struct may be used concurrently by srcu_down_read_fast()
  * and srcu_read_lock_fast().
  */
-static inline struct srcu_ctr __percpu *srcu_down_read_fast(struct srcu_struct *ssp) __acquires(ssp)
+static inline struct srcu_ctr __percpu *srcu_down_read_fast(struct srcu_struct *ssp) __acquires_shared(ssp)
 {
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_PROVE_RCU) && in_nmi());
 	srcu_check_read_flavor_force(ssp, SRCU_READ_FLAVOR_FAST);
@@ -310,7 +328,8 @@ static inline struct srcu_ctr __percpu *srcu_down_read_fast(struct srcu_struct *
  * then none of the other flavors may be used, whether before, during,
  * or after.
  */
-static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -322,7 +341,8 @@ static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp
 
 /* Used by tracing, cannot be traced and cannot invoke lockdep. */
 static inline notrace int
-srcu_read_lock_notrace(struct srcu_struct *ssp) __acquires(ssp)
+srcu_read_lock_notrace(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -353,7 +373,8 @@ srcu_read_lock_notrace(struct srcu_struct *ssp) __acquires(ssp)
  * which calls to down_read() may be nested.  The same srcu_struct may be
  * used concurrently by srcu_down_read() and srcu_read_lock().
  */
-static inline int srcu_down_read(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_down_read(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	WARN_ON_ONCE(in_nmi());
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
@@ -368,7 +389,7 @@ static inline int srcu_down_read(struct srcu_struct *ssp) __acquires(ssp)
  * Exit an SRCU read-side critical section.
  */
 static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
@@ -384,7 +405,7 @@ static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
  * Exit a light-weight SRCU read-side critical section.
  */
 static inline void srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_FAST);
 	srcu_lock_release(&ssp->dep_map);
@@ -400,7 +421,7 @@ static inline void srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ct
  * the same context as the maching srcu_down_read_fast().
  */
 static inline void srcu_up_read_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_PROVE_RCU) && in_nmi());
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_FAST);
@@ -415,7 +436,7 @@ static inline void srcu_up_read_fast(struct srcu_struct *ssp, struct srcu_ctr __
  * Exit an SRCU read-side critical section, but in an NMI-safe manner.
  */
 static inline void srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NMI);
@@ -425,7 +446,7 @@ static inline void srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx)
 
 /* Used by tracing, cannot be traced and cannot call lockdep. */
 static inline notrace void
-srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases(ssp)
+srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases_shared(ssp)
 {
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
 	__srcu_read_unlock(ssp, idx);
@@ -440,7 +461,7 @@ srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases(ssp)
  * the same context as the maching srcu_down_read().
  */
 static inline void srcu_up_read(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	WARN_ON_ONCE(in_nmi());
@@ -480,6 +501,7 @@ DEFINE_LOCK_GUARD_1(srcu, struct srcu_struct,
 		    _T->idx = srcu_read_lock(_T->lock),
 		    srcu_read_unlock(_T->lock, _T->idx),
 		    int idx)
+DECLARE_LOCK_GUARD_1_ATTRS(srcu, __assumes_cap(_T), /* */)
 
 DEFINE_LOCK_GUARD_1(srcu_fast, struct srcu_struct,
 		    _T->scp = srcu_read_lock_fast(_T->lock),
diff --git a/include/linux/srcutiny.h b/include/linux/srcutiny.h
index 51ce25f07930..c194b3c7c43b 100644
--- a/include/linux/srcutiny.h
+++ b/include/linux/srcutiny.h
@@ -61,6 +61,7 @@ void synchronize_srcu(struct srcu_struct *ssp);
  * index that must be passed to the matching srcu_read_unlock().
  */
 static inline int __srcu_read_lock(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int idx;
 
@@ -68,6 +69,7 @@ static inline int __srcu_read_lock(struct srcu_struct *ssp)
 	idx = ((READ_ONCE(ssp->srcu_idx) + 1) & 0x2) >> 1;
 	WRITE_ONCE(ssp->srcu_lock_nesting[idx], READ_ONCE(ssp->srcu_lock_nesting[idx]) + 1);
 	preempt_enable();
+	__acquire_shared(ssp);
 	return idx;
 }
 
@@ -84,11 +86,13 @@ static inline struct srcu_ctr __percpu *__srcu_ctr_to_ptr(struct srcu_struct *ss
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
diff --git a/include/linux/srcutree.h b/include/linux/srcutree.h
index bf44d8d1e69e..43754472e07a 100644
--- a/include/linux/srcutree.h
+++ b/include/linux/srcutree.h
@@ -207,7 +207,7 @@ struct srcu_struct {
 #define DEFINE_SRCU(name)		__DEFINE_SRCU(name, /* not static */)
 #define DEFINE_STATIC_SRCU(name)	__DEFINE_SRCU(name, static)
 
-int __srcu_read_lock(struct srcu_struct *ssp) __acquires(ssp);
+int __srcu_read_lock(struct srcu_struct *ssp) __acquires_shared(ssp);
 void synchronize_srcu_expedited(struct srcu_struct *ssp);
 void srcu_barrier(struct srcu_struct *ssp);
 void srcu_torture_stats_print(struct srcu_struct *ssp, char *tt, char *tf);
@@ -241,6 +241,7 @@ static inline struct srcu_ctr __percpu *__srcu_ctr_to_ptr(struct srcu_struct *ss
  * implementations of this_cpu_inc().
  */
 static inline struct srcu_ctr __percpu *__srcu_read_lock_fast(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	struct srcu_ctr __percpu *scp = READ_ONCE(ssp->srcu_ctrp);
 
@@ -250,6 +251,7 @@ static inline struct srcu_ctr __percpu *__srcu_read_lock_fast(struct srcu_struct
 	else
 		atomic_long_inc(raw_cpu_ptr(&scp->srcu_locks));  /* Z */
 	barrier(); /* Avoid leaking the critical section. */
+	__acquire_shared(ssp);
 	return scp;
 }
 
@@ -269,7 +271,9 @@ static inline struct srcu_ctr __percpu *__srcu_read_lock_fast(struct srcu_struct
  * implementations of this_cpu_inc().
  */
 static inline void __srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
+	__releases_shared(ssp)
 {
+	__release_shared(ssp);
 	barrier();  /* Avoid leaking the critical section. */
 	if (!IS_ENABLED(CONFIG_NEED_SRCU_NMI_SAFE))
 		this_cpu_inc(scp->srcu_unlocks.counter);  /* Z */
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 31c9bc1e2405..5b17fd94f31e 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
@@ -10,6 +10,7 @@
 #include <linux/rcupdate.h>
 #include <linux/seqlock.h>
 #include <linux/spinlock.h>
+#include <linux/srcu.h>
 
 /*
  * Test that helper macros work as expected.
@@ -362,3 +363,26 @@ static void __used test_rcu_assert_variants(void)
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
+	guard(srcu)(&d->srcu);
+	(void)srcu_dereference(d->data, &d->srcu);
+}
-- 
2.51.0.384.g4c02a37b29-goog


