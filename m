Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D759CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69B326B0062; Thu, 20 Nov 2025 10:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672416B00B4; Thu, 20 Nov 2025 10:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5886F6B00B5; Thu, 20 Nov 2025 10:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43CAB6B0062
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:12:48 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 17F3D1401B6
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:48 +0000 (UTC)
X-FDA: 84131327616.29.8BE6DF5
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id F103B80027
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:45 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pSZKeCwa;
	spf=pass (imf02.hostedemail.com: domain of 37C8faQUKCBk3AK3G5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=37C8faQUKCBk3AK3G5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yHFmEO19z4F9SK7KsUWIWORciiNuVWc+Iq1/rw+dtQM=;
	b=wMGPgJnufjjqOQOnSQPILogMDkvEiDK82nUNScIjvqicfpdduEw0kJf3q/0vEHeSuQf8b/
	ZHkbxzi6AdojhAgJ/dNDRwxp9ZIvOblD5QLk/Cy7AF8Qd1X1BTSiCJIyc0fZKuJNb3Ou0X
	KsJsHPtE3Rw/vBnSdqER+k/8lUH3Nuc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651566; a=rsa-sha256;
	cv=none;
	b=pA473UbUzAmUb1aMqvRiOfhUxq812iSa2tkm4fJapb6fLM9Qi3mttO0Ht6Dp+YHo23Zqu6
	lMH3Qs1jBBYa13SXti+V3VeCLsYmmfmW4wcjAl9zWlVQsJzyksvhnTerNJA50dMKyNULBB
	OEYxi0NEyDUWkpc6sF6oeF3DyzXha08=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=pSZKeCwa;
	spf=pass (imf02.hostedemail.com: domain of 37C8faQUKCBk3AK3G5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=37C8faQUKCBk3AK3G5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso1026669f8f.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651564; x=1764256364; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=yHFmEO19z4F9SK7KsUWIWORciiNuVWc+Iq1/rw+dtQM=;
        b=pSZKeCwal2/P46xk4oe/c8udvhQALn9gtJpBx+TeMd1JP11mBePoTOy2/YOli1Yuxf
         yeULLcTNmlZYSkiCilBu5VSqEUqqZ3Rl9OaEXB8uOsjm960Ccdr0oPuyRdaGT0j7uJFe
         +kHhyUluH8OC/h8fSM/3GLVPN4sATq6DFdhsummK/Y+U1YGcveU/4Kr1i8kgWoRnXzXb
         MCk83UzzxZfM2UmM/BwpkRHD8ITxVGdPenSjumNwYZOLurQo7/di8IlcuNBtyA8zWbfm
         NtjysqyadndRoIEyqNg85VjEpmg3wQarQ1/XcZI60wTkibTlCpD7tTJt2c789AWu5240
         WOgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651564; x=1764256364;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yHFmEO19z4F9SK7KsUWIWORciiNuVWc+Iq1/rw+dtQM=;
        b=Qj/LozRTXlMYc17wVCILZ8e/V5GdVxbbRQl/Yma2CY96rmFsUz+wDTRDnxpM6ErlP3
         Z0NRqiydG+9j9DNKMfm+I+xAvt+Hdwe3QXzuHWr+O1XfEykn1SYEgnlNitP/2ddmMf0C
         PSNNXRMUiQQeSc6iiac5eii7nP4MCRRzJmM6eScycUCHrL4a1mp1E3KHVTA+0Q90zGLU
         0VWT7RBhp4q5OZRUCU98ByQzWRFSLCIyzldESjyBzRjo3LrbQT8XKN2D9d54/XNFGw6N
         UbxKHUtwY7EROvbdxH8uM3W12O7vm7tweMGIzg32KkPPBCEONBXzSoqO6o01mQaO6Fu8
         NUMw==
X-Forwarded-Encrypted: i=1; AJvYcCUXA2q9Ilxa6N+VN1bOrbdHTWnKU1Qy2kZSIUu3or4/UnatuoqjE8Eugr4JQieWJkSfO2opoRogWg==@kvack.org
X-Gm-Message-State: AOJu0YzgvMY6t40xOCpWxZWc8bFJpWzKdtRfLbbT9oOTg3cqidCye2WK
	sPcv2C8JGEPaAoe7uH8zSlHpED9WucTAP1yEh92IiSNYC+WS1CvmdAL/HKp5XHO6uNhjtpwBsTN
	Lcw==
X-Google-Smtp-Source: AGHT+IEuTifEbUhdvE5i/Y5rsgIqB9EBfMLOeSF1GbDDxdQ2epjvOMdY+jN5N2aF7xQEE8cxTJX0dndqmg==
X-Received: from wroy10.prod.google.com ([2002:adf:f14a:0:b0:42b:39b8:85b7])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:200c:b0:429:b963:cdd5
 with SMTP id ffacd0b85a97d-42cba63e2c0mr3368120f8f.5.1763651564018; Thu, 20
 Nov 2025 07:12:44 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:40 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-16-elver@google.com>
Subject: [PATCH v4 15/35] srcu: Support Clang's context analysis
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
X-Rspamd-Queue-Id: F103B80027
X-Stat-Signature: wjsekc8dmwfnssyqpkmbwomh5qj5xoyt
X-Rspam-User: 
X-HE-Tag: 1763651565-730749
X-HE-Meta: U2FsdGVkX1/uvfbdYHHfeewWU4NR7p6tBYsbhUYIxehesV3tNSqElDY49v3zTlLDaDdaGfakR2NYP9aPFWV/V3UAaSZNCZe6ciZ6PNwS5qG0MQRd//eK8GSyOpQPrOLlePlDm7aeKuc0kTYxW7l4wlnrr2U6MzJDkxUv+MR5fRlQKCJJq2HbAKthDJnfKENxI5/hx92ys6riW9v6W8kehk/qQLLDae11SWRdhpXFd3zIOmy8RBAoSIlmQUwqTattO9NZ4WFtRy+FQgWqZEQ3nLA0NwIIZxYBfuInCYqCcdz2OQaX/N+3K6rZJoMrpUtZD5bZWmX/LI4acqY9NenKtsc2psBMFOzTr0xEqiAhErJ5+iAmVWtijyX1vlqZhBodQ3bSKImel0Tt7nu3E9/npFCAK6BQEiwCLAfTcEr+rrsyHJUecoJsMRhmF7Ic4MuCo0mO212lPexqNUUkBFfm6eLmAUUEKKpojyyzezwcHG3INyUFQoVmsdJ/fJ7pWt+zV3Z9YHOm3dUdFo/vzFAGPpyBMNsMFnV4EIxAhhMJ9o8+v8+mUJiVz+t0nUH0DE9T094lG65WCltVk3l/+Pg/J0Fv3UahAZBmeO0JjkklHm8u1Vpa82GzEc5MKti7cynaOo0PdUAO58o7ONO44BuLpwNV2gX1esuJq8cN/WzQFluutdXt3o+iSQDz28YqKf+F15dds+Rw0TkAcIBp394sV9lydFxhMX3ouaQlYpiqUuXqIlOhDi148dfoT1cGD6odbGgn0anw+uuEsoBQgXi09ELBzlfi6mG/LNIj9GzT/JvxKgVx0H9DD6fr+23161j9SQwkm1nEpmGKQVcfxAWLviW5Bislh9d/NQvYw5qYk5whqui0yKM3iZyNuHBAzYgZ76hqNafEy39CaMVpZ9Eb1o+IHgYBmWW6nU9u7ibWszgBvhkRPzAXbRLlIOnhGElvwdGDoNMe7zyGUkZiQ+J
 yE8PR6f6
 2uHdUDo8JXdnsTTXV1859qWB7FDh9PMVQB67tJUygQyHhk8rJNTp/5eUO206tiOTzhlr1IdN8flDSOFbc+MEVU0MY4ks+rSxLwfmHu0iX2Vq0mwhD5wj9nf6Au7obILQyVqed7FwMbW2GKQ4+2SbQoK+CzzAe7E8I31aXNzdW4gt69bfzJUCEsZPT6WlnxPdu7adqwWbnVm1Rat6hXO9vebgTHopgJzHqNUvzvRxgR2dZ5cmbf2Il9d4yA1aaKAzFz+u0sS2wnkhWSMoT/WY/lBrVYvw+Oz1JnKFTWAQZ0yD8537OTnvR/EBir99KgU76uEwLV3LxqVRLBB4YtnxqzCCNraysjoV1sHAH+LxXkdzBoWfPpYmrsBaUntWZI6l8kYkOcSpyngvBky2R+XXwAgeNJidG/s5HfUJTA7NQGcrKXz+ESS8QuPCOXdIGRqGITbDHMZ8f+dC32ge56C29/PolvI6Eld0tFbMJjAeLGabjlu32Tj/dzYxLkZLES1fYXwC6kCO8a9qRK1k1imi38jRgSelA8E2z4Wmif3GhmLvuGFflKcxNzaDWhP17u0O3+togL5Q+TXjrSKWTF6aIOHDXKfK9XOZIikcsGZHCA8CP6tJuuE85AIMCSQ64Ux+fMfbQeun1oD0excw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's context analysis for SRCU.

Signed-off-by: Marco Elver <elver@google.com>
---
v4:
* Rename capability -> context analysis.

v3:
* Switch to DECLARE_LOCK_GUARD_1_ATTRS() (suggested by Peter)
* Support SRCU being reentrant.
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/srcu.h                         | 64 +++++++++++++-------
 include/linux/srcutiny.h                     |  4 ++
 include/linux/srcutree.h                     |  6 +-
 lib/test_context-analysis.c                  | 24 ++++++++
 5 files changed, 77 insertions(+), 23 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index 05164804a92a..59fc8e4cc203 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -81,7 +81,7 @@ Supported Kernel Primitives
 
 Currently the following synchronization primitives are supported:
 `raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`,
-`bit_spinlock`, RCU.
+`bit_spinlock`, RCU, SRCU (`srcu_struct`).
 
 For context guards with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index ada65b58bc4c..a0e2b8187100 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -21,7 +21,7 @@
 #include <linux/workqueue.h>
 #include <linux/rcu_segcblist.h>
 
-struct srcu_struct;
+context_guard_struct(srcu_struct, __reentrant_ctx_guard);
 
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
+	__acquire_shared_ctx_guard(RCU);					\
+	__auto_type __v = __rcu_dereference_check((p), __UNIQUE_ID(rcu),	\
+				(c) || srcu_read_lock_held(ssp), __rcu);	\
+	__release_shared_ctx_guard(RCU);					\
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
 
@@ -287,7 +305,7 @@ static inline struct srcu_ctr __percpu *srcu_read_lock_fast(struct srcu_struct *
  * See srcu_read_lock_fast() for more information.
  */
 static inline struct srcu_ctr __percpu *srcu_read_lock_fast_notrace(struct srcu_struct *ssp)
-	__acquires(ssp)
+	__acquires_shared(ssp)
 {
 	struct srcu_ctr __percpu *retval;
 
@@ -307,7 +325,7 @@ static inline struct srcu_ctr __percpu *srcu_read_lock_fast_notrace(struct srcu_
  * The same srcu_struct may be used concurrently by srcu_down_read_fast()
  * and srcu_read_lock_fast().
  */
-static inline struct srcu_ctr __percpu *srcu_down_read_fast(struct srcu_struct *ssp) __acquires(ssp)
+static inline struct srcu_ctr __percpu *srcu_down_read_fast(struct srcu_struct *ssp) __acquires_shared(ssp)
 {
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_PROVE_RCU) && in_nmi());
 	RCU_LOCKDEP_WARN(!rcu_is_watching(), "RCU must be watching srcu_down_read_fast().");
@@ -326,7 +344,8 @@ static inline struct srcu_ctr __percpu *srcu_down_read_fast(struct srcu_struct *
  * then none of the other flavors may be used, whether before, during,
  * or after.
  */
-static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -338,7 +357,8 @@ static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp
 
 /* Used by tracing, cannot be traced and cannot invoke lockdep. */
 static inline notrace int
-srcu_read_lock_notrace(struct srcu_struct *ssp) __acquires(ssp)
+srcu_read_lock_notrace(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	int retval;
 
@@ -369,7 +389,8 @@ srcu_read_lock_notrace(struct srcu_struct *ssp) __acquires(ssp)
  * which calls to down_read() may be nested.  The same srcu_struct may be
  * used concurrently by srcu_down_read() and srcu_read_lock().
  */
-static inline int srcu_down_read(struct srcu_struct *ssp) __acquires(ssp)
+static inline int srcu_down_read(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	WARN_ON_ONCE(in_nmi());
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
@@ -384,7 +405,7 @@ static inline int srcu_down_read(struct srcu_struct *ssp) __acquires(ssp)
  * Exit an SRCU read-side critical section.
  */
 static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
@@ -400,7 +421,7 @@ static inline void srcu_read_unlock(struct srcu_struct *ssp, int idx)
  * Exit a light-weight SRCU read-side critical section.
  */
 static inline void srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_FAST);
 	srcu_lock_release(&ssp->dep_map);
@@ -413,7 +434,7 @@ static inline void srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ct
  * See srcu_read_unlock_fast() for more information.
  */
 static inline void srcu_read_unlock_fast_notrace(struct srcu_struct *ssp,
-						 struct srcu_ctr __percpu *scp) __releases(ssp)
+						 struct srcu_ctr __percpu *scp) __releases_shared(ssp)
 {
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_FAST);
 	__srcu_read_unlock_fast(ssp, scp);
@@ -428,7 +449,7 @@ static inline void srcu_read_unlock_fast_notrace(struct srcu_struct *ssp,
  * the same context as the maching srcu_down_read_fast().
  */
 static inline void srcu_up_read_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(IS_ENABLED(CONFIG_PROVE_RCU) && in_nmi());
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_FAST);
@@ -444,7 +465,7 @@ static inline void srcu_up_read_fast(struct srcu_struct *ssp, struct srcu_ctr __
  * Exit an SRCU read-side critical section, but in an NMI-safe manner.
  */
 static inline void srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NMI);
@@ -454,7 +475,7 @@ static inline void srcu_read_unlock_nmisafe(struct srcu_struct *ssp, int idx)
 
 /* Used by tracing, cannot be traced and cannot call lockdep. */
 static inline notrace void
-srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases(ssp)
+srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases_shared(ssp)
 {
 	srcu_check_read_flavor(ssp, SRCU_READ_FLAVOR_NORMAL);
 	__srcu_read_unlock(ssp, idx);
@@ -469,7 +490,7 @@ srcu_read_unlock_notrace(struct srcu_struct *ssp, int idx) __releases(ssp)
  * the same context as the maching srcu_down_read().
  */
 static inline void srcu_up_read(struct srcu_struct *ssp, int idx)
-	__releases(ssp)
+	__releases_shared(ssp)
 {
 	WARN_ON_ONCE(idx & ~0x1);
 	WARN_ON_ONCE(in_nmi());
@@ -509,6 +530,7 @@ DEFINE_LOCK_GUARD_1(srcu, struct srcu_struct,
 		    _T->idx = srcu_read_lock(_T->lock),
 		    srcu_read_unlock(_T->lock, _T->idx),
 		    int idx)
+DECLARE_LOCK_GUARD_1_ATTRS(srcu, __assumes_ctx_guard(_T), /* */)
 
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
index 42098e0fa0b7..4bfd80f55043 100644
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
@@ -259,6 +259,7 @@ static inline struct srcu_ctr __percpu *__srcu_ctr_to_ptr(struct srcu_struct *ss
  * implementations of this_cpu_inc().
  */
 static inline struct srcu_ctr __percpu notrace *__srcu_read_lock_fast(struct srcu_struct *ssp)
+	__acquires_shared(ssp)
 {
 	struct srcu_ctr __percpu *scp = READ_ONCE(ssp->srcu_ctrp);
 
@@ -267,6 +268,7 @@ static inline struct srcu_ctr __percpu notrace *__srcu_read_lock_fast(struct src
 	else
 		atomic_long_inc(raw_cpu_ptr(&scp->srcu_locks));  // Y, and implicit RCU reader.
 	barrier(); /* Avoid leaking the critical section. */
+	__acquire_shared(ssp);
 	return scp;
 }
 
@@ -281,7 +283,9 @@ static inline struct srcu_ctr __percpu notrace *__srcu_read_lock_fast(struct src
  */
 static inline void notrace
 __srcu_read_unlock_fast(struct srcu_struct *ssp, struct srcu_ctr __percpu *scp)
+	__releases_shared(ssp)
 {
+	__release_shared(ssp);
 	barrier();  /* Avoid leaking the critical section. */
 	if (!IS_ENABLED(CONFIG_NEED_SRCU_NMI_SAFE))
 		this_cpu_inc(scp->srcu_unlocks.counter);  // Z, and implicit RCU reader.
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index f18b7252646d..bd75b5ade8ff 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
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
2.52.0.rc1.455.g30608eb744-goog


