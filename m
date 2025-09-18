Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BBADCA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8B918E0123; Thu, 18 Sep 2025 10:05:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98DD8E0112; Thu, 18 Sep 2025 10:05:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE658E0123; Thu, 18 Sep 2025 10:05:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99FEC8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:05:46 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A45A1401CC
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:46 +0000 (UTC)
X-FDA: 83902544292.24.9F9AABD
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id 82CFE140029
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V8hcOi2i;
	spf=pass (imf09.hostedemail.com: domain of 3thHMaAUKCFc3AK3G5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--elver.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3thHMaAUKCFc3AK3G5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UhQ+U9se/SSPfFCtaRf+8xWbg1y5S3svPblZWk1KYzo=;
	b=wg9Xxx30kOIpTik8k7beLuOJndm+WMuUJ18OFf9ULemjm5LVuOndd+63PTjUvZYGdDRo5Y
	kSvs2HvwoqOnbkPvkh4z9EK1TQjzebQ61DsLsU9CWopOc+4Yhnn2JcvZLu65iz0nAxdVbK
	a0DdI5IXCsGb687dHgGPyqwXbBrzcdc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204344; a=rsa-sha256;
	cv=none;
	b=y3emjqP93ChmAGi1OGrwLGR94bwWmzycIiTp1nVtcWqGojlErTd41qKMFDN30viiSOggRJ
	iDgHLxKj04uMuo81GFlMqu9z54Z6sOUOvaBexObw1f4FM8p7SAZW49pYWjc5hIx62bWARV
	OmIiL7/kJ+wHWbsIhqKntv0bVbwUrSM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V8hcOi2i;
	spf=pass (imf09.hostedemail.com: domain of 3thHMaAUKCFc3AK3G5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--elver.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3thHMaAUKCFc3AK3G5DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-aff0df4c4abso83804366b.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:05:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204343; x=1758809143; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=UhQ+U9se/SSPfFCtaRf+8xWbg1y5S3svPblZWk1KYzo=;
        b=V8hcOi2iSVsHezYL7NJnZiggrkLXv9O6mXf4p9INNDPX0edq3GW7ojytHaOjk8QfHW
         trY9P5XJKDgkM/OJVDanKq2J2alV6/qO5eLLNtB/ey1896nmPC+FNCBjJETdjz24vvN2
         goMBHds0YtX4BPx+JeywXGoXLSuxmSmgQ1J9C9f83dYkEcuPHeYAh04JRiaDLnEu3YnP
         TaTxX0yzM3QbjpPbZdYHCvhlc+pEMwNiAhMR8pdWc1anflLRuRVC5I0MoKN0KnRkgTYO
         HfQnO+ePIgqMFwATKgxCtT1s6enASOuIdezFSZKH1swEhvlSsDxnEMJ6uutr4y7r4XEw
         zdKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204343; x=1758809143;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UhQ+U9se/SSPfFCtaRf+8xWbg1y5S3svPblZWk1KYzo=;
        b=lV3R7/M8pfqEc+/03Aw4MzJoJ9DffLXUvCxVzRI5CPyO93xnOSF4RX/+Lg8xBAdcOi
         LT0Kx8TMxz0xX2mJlDe8gSR6l4/W28371B55yEGxcTveeGPSRm9omETfpqJLLgBPTOan
         bXRINME+bBDMWMhJ29ZyWseMVcbGP2/dg4EclOh/JEjmhJpodUTiOAmeIki5w/Z2VxJw
         5Xij7ygRnePWOL1Nh89d6Z4eRwdB8stmfeYf/5R/R5zqX01JrO7Ft9kxWFXlx1MF/oAO
         Jwo76eGCxcM+dSM3TeN7iuZ4DDmuUGDPP7o+G0IH4CC4mZn4UlGRFEEDvN3ZIX/TKjR+
         Ugww==
X-Forwarded-Encrypted: i=1; AJvYcCXeCCid35jo+kEz1yiFqMYF3iXk2Py5hibDX0CZJOrF98pInEUWbtRQ/jm96MpK0Z306uyaw5cYxQ==@kvack.org
X-Gm-Message-State: AOJu0Yyw//YbNaAxZlJ8Z20YD1xSeviBqZ6G2mRok7Equ0CkkJeG3xm4
	/lV96bqR+gGvoopCBJ9ezaKMZS6XUUrgmpv1wI0bHXBSd7oDmoI73uGHEUvCLTKFwZkoF/2WZTf
	+kQ==
X-Google-Smtp-Source: AGHT+IHx20k8wpv+0CdEL8tKSP3AAmnqjSsLU77F74q4U9IVeOOTYh+6Sm2wrNtaQlemdoGnkvfY1U7RLg==
X-Received: from ejcth16.prod.google.com ([2002:a17:907:8e10:b0:b07:e1ab:ac42])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a17:907:86a0:b0:b07:dbf9:a002
 with SMTP id a640c23a62f3a-b1bba0036fcmr627925566b.47.1758204342817; Thu, 18
 Sep 2025 07:05:42 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:17 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-7-elver@google.com>
Subject: [PATCH v3 06/35] cleanup: Basic compatibility with capability analysis
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 82CFE140029
X-Stat-Signature: 7tk9gsutta1t3ecgdx8pija8twxqsc64
X-Rspam-User: 
X-HE-Tag: 1758204344-722259
X-HE-Meta: U2FsdGVkX19b753GG/aP/fZbmnR2d4klWTA7cbKYrBwAfxCzsZ1RDUjsHDiOze/wUF2B+AtbUymrsK1mAn77Wr6aH2vw5hS0CT5jsGqjhxp4UaK3PREdNPsNgg/wYZOvlq4XBW+BhpcbvEx/8To5rtKzobwOZq4MCtYrb85/XSMtj0peV62MaJ6FD18xo4+B4r3aWliixCmxqGjEcUSadPGGrGIj1e4ekPSWxl7G33H5xZyjVSozIZB/+UI7j15IdjemEpyfuJe7ErvaGM8LLGYuq70pBq+H5TyjbnnLsK1IzS324h/GfU/70/7qcEZWzF6Se/C6Kox7LfvzHEzJE667oi3CmU4SwJ7IfoRGD0ENpOwojCusb17HBmlwiqtqDtVPOclaxdm7oSZiA6suGDpYdYGvb2xi5+8eLHTCkpWFJh6k9fvzCX5x596z5r0ZNvHQyGnBLkYZrHCaEr11X7dh/2TVNBrQ5NPFssq333IfI5PneGIRzCW6aB+lLEy4FTs2+9zpDPDLyeINt1YjiBl1lHg+mnVirbSOdLLlY01H2U6ujj54joNniLE0r7+5NsVf+T5vmJsIxQRTbqeUgVNFSxHjPXEp7ciUCM0yDR9MjGBXbNzhf6huZRzWamU2RN14LltUrPqUYr8RKbQqhzv5305zbzPvi9b1W9Gddzj8oYU3bZO8XoFyJyv2SIGbDOvF3pOjZgjgCuJZX5Vkn0C0Vr/N6ooBTKqOdsptq1wcbC7fNbTM7i6jj+vHbb4aOvu/shZSwuZ5Qw4e7uDKnE6ba83Uk1Ldqg1dEh262Vn2Q1WqufaHv7djxZPss/0RRiF4751ORE7jLLSauHPqYELIUuWLiW99+GBNsi3o3SYHoCNdEBBD8SdXdyV1U+cSVS3IdfZBhBUAmskFoe4klaWHDYLX9xZccayNUodS8dtQ8BNbcy2tlrzL6rocezPpk9P9V6ca02WJlYNE97Z
 3iaeT13+
 4JdiOIbN4jOdMZmbEdOLZ4aLggrUVfrQf5ExY0295elXwPeNEGNudxXNdWw5zDWjjDdJvSr/I7h7wNjdDh5dPVXBwYfjnAc2qnB7mdrDL5wfgjR2EDIWUkgppyYpKQsaDb4t74bCyqM7J/CQaKKXTlHf3fKziimnfuCdA//CwV6Qy8RF6j4M2f8kBKS9qU4F55Gqkk5+f1KK2TkrGkM503qnYIqmUBPyw50JcQvcY79FSnzoIKlLwlx+4CgwFogQxb6uT4HQSonzF8M4v+JmdP6vTPoZtzvqJ07AgdXmiJizHkYz1z1EsKRUKAbzhjkK/Xb95Xwf84oAcx6CLtzvZcNbU2tuwpp+/MjMshhRi7aC3DaQ7zxCeyamHGyXoRWIOgwqMWO+CSbfcnYlTpX/InYR5JKAn1ma/QDNA1nW4e3Iw/JPD4l73figZ5wxhXLsBd4B64gbfHkOKMx3QFcRHjViVZj+eFca59fFKSBblBeT6Y2pxNs24xPH18Udz/+LorzrU1NEILFD/RlgGqsBnE+XZbbe0km8zj9IuP0YB/gCr65S4J7yEQedp7GaqQdPop8w2Y0BdTuMcZQDoW+cuOrZ9NNBK2SrketQwcv4X60/ZX4c9guPyQ2V0hMdpb82n3n9fpm4WjXA/bW9jGnIeKhFnfLZgkyr/HEjpMjbjy7I01F/vrunp/dzOsQJ7PUL9/9mWe2fQcSTy9h+/8mLSo18MeW8ccHmTz798
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce basic compatibility with cleanup.h infrastructure: introduce
DECLARE_LOCK_GUARD_*_ATTRS() helpers to add attributes to constructors
and destructors respectively.

Note: Due to the scoped cleanup helpers used for lock guards wrapping
acquire and release around their own constructors/destructors that store
pointers to the passed locks in a separate struct, we currently cannot
accurately annotate *destructors* which lock was released. While it's
possible to annotate the constructor to say which lock was acquired,
that alone would result in false positives claiming the lock was not
released on function return.

Instead, to avoid false positives, we can claim that the constructor
"assumes" that the taken lock is held via __assumes_cap().

This will ensure we can still benefit from the analysis where scoped
guards are used to protect access to guarded variables, while avoiding
false positives. The only downside are false negatives where we might
accidentally lock the same lock again:

	raw_spin_lock(&my_lock);
	...
	guard(raw_spinlock)(&my_lock);  // no warning

Arguably, lockdep will immediately catch issues like this.

While Clang's analysis supports scoped guards in C++ [1], there's no way
to apply this to C right now. Better support for Linux's scoped guard
design could be added in future if deemed critical.

[1] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html#scoped-capability

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* Add *_ATTRS helpers instead of implicit __assumes_cap (suggested by Peter)
* __assert -> __assume rename
---
 include/linux/cleanup.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
index 2573585b7f06..54fc70d8da27 100644
--- a/include/linux/cleanup.h
+++ b/include/linux/cleanup.h
@@ -274,16 +274,21 @@ const volatile void * __must_check_fn(const volatile void *val)
 
 #define DEFINE_CLASS(_name, _type, _exit, _init, _init_args...)		\
 typedef _type class_##_name##_t;					\
+typedef _type lock_##_name##_t;						\
 static inline void class_##_name##_destructor(_type *p)			\
+	__no_capability_analysis					\
 { _type _T = *p; _exit; }						\
 static inline _type class_##_name##_constructor(_init_args)		\
+	__no_capability_analysis					\
 { _type t = _init; return t; }
 
 #define EXTEND_CLASS(_name, ext, _init, _init_args...)			\
+typedef lock_##_name##_t lock_##_name##ext##_t;				\
 typedef class_##_name##_t class_##_name##ext##_t;			\
 static inline void class_##_name##ext##_destructor(class_##_name##_t *p)\
 { class_##_name##_destructor(p); }					\
 static inline class_##_name##_t class_##_name##ext##_constructor(_init_args) \
+	__no_capability_analysis \
 { class_##_name##_t t = _init; return t; }
 
 #define CLASS(_name, var)						\
@@ -461,12 +466,14 @@ _label:									\
  */
 
 #define __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, ...)		\
+typedef _type lock_##_name##_t;						\
 typedef struct {							\
 	_type *lock;							\
 	__VA_ARGS__;							\
 } class_##_name##_t;							\
 									\
 static inline void class_##_name##_destructor(class_##_name##_t *_T)	\
+	__no_capability_analysis					\
 {									\
 	if (!__GUARD_IS_ERR(_T->lock)) { _unlock; }			\
 }									\
@@ -475,6 +482,7 @@ __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
 
 #define __DEFINE_LOCK_GUARD_1(_name, _type, _lock)			\
 static inline class_##_name##_t class_##_name##_constructor(_type *l)	\
+	__no_capability_analysis 					\
 {									\
 	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
 	_lock;								\
@@ -483,6 +491,7 @@ static inline class_##_name##_t class_##_name##_constructor(_type *l)	\
 
 #define __DEFINE_LOCK_GUARD_0(_name, _lock)				\
 static inline class_##_name##_t class_##_name##_constructor(void)	\
+	__no_capability_analysis					\
 {									\
 	class_##_name##_t _t = { .lock = (void*)1 },			\
 			 *_T __maybe_unused = &_t;			\
@@ -490,6 +499,14 @@ static inline class_##_name##_t class_##_name##_constructor(void)	\
 	return _t;							\
 }
 
+#define DECLARE_LOCK_GUARD_0_ATTRS(_name, _lock, _unlock)		\
+static inline class_##_name##_t class_##_name##_constructor(void) _lock;\
+static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock;
+
+#define DECLARE_LOCK_GUARD_1_ATTRS(_name, _lock, _unlock)		\
+static inline class_##_name##_t class_##_name##_constructor(lock_##_name##_t *_T) _lock;\
+static inline void class_##_name##_destructor(class_##_name##_t *_T) _unlock;
+
 #define DEFINE_LOCK_GUARD_1(_name, _type, _lock, _unlock, ...)		\
 __DEFINE_CLASS_IS_CONDITIONAL(_name, false);				\
 __DEFINE_UNLOCK_GUARD(_name, _type, _unlock, __VA_ARGS__)		\
-- 
2.51.0.384.g4c02a37b29-goog


