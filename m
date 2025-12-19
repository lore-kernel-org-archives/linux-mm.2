Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFA50D7878A
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C2BE6B00BD; Fri, 19 Dec 2025 10:47:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2806B6B00BF; Fri, 19 Dec 2025 10:47:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183376B00C0; Fri, 19 Dec 2025 10:47:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 068946B00BD
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:01 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B8B2187EFB
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:00 +0000 (UTC)
X-FDA: 84236649000.29.67F365A
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id D9EC340008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EunFpv1r;
	spf=pass (imf17.hostedemail.com: domain of 3cXNFaQUKCL4ipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3cXNFaQUKCL4ipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BXcHXIDfWoSkrk6mEFbnYEvAXHgRRlXY75uZgyD6jWc=;
	b=vsBiJNMhLr6Uaw96EXgHjLFteUi/L2G0yGpaGKnui/WR4yliEN/x0A0qetmAZMpri4LwnG
	AXnsWQfBqpyakKYhlUlBexdPIsMOst1CSFoZE/AsvUWxLTM7naGKXoAdJQtBAeEF29mkHg
	FTyt8HFr2YiB6QnG/ANtAXgPghiBvYw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159219; a=rsa-sha256;
	cv=none;
	b=c3c/TqyXnkncE3axacnm2hEmAsk6fGXreqeJXvkUR2DiW4Na1/FLhQqRTN0L2XFH3Nm+Fs
	96Sa4BadE9fqOGoQpx7DEAuu0UZxnsScwQGROPb4AHUZUZs/9ZUKAHTnE8oXtZdfqufliW
	/kFVwd1n977DMsQ8syatriGUq+CoUf0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=EunFpv1r;
	spf=pass (imf17.hostedemail.com: domain of 3cXNFaQUKCL4ipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3cXNFaQUKCL4ipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4788112ec09so18339595e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159217; x=1766764017; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BXcHXIDfWoSkrk6mEFbnYEvAXHgRRlXY75uZgyD6jWc=;
        b=EunFpv1rPFqZ1HeCXwok+OsHlacs/6s7NJkxXa+lK35gNaZ5ZoMxVAiUE7GhFcPnP6
         TAZ6qIkbyGAfR5xAzzQIvI2YPm2mt20mq40wKtsSIYg5Imvxs/HJRfI+mHHHM7DbcKiP
         2FPjWl0kCqtCT8G+wrR6mVLMtUzDZkW6YnFH5+Q+GeqQ2mSDzyO6hJ2MhAD5ZPfRczoT
         8xxFb+ynaP8tP9AaBcq+URpVt2paB9bHk8naC3/wXUt9JSRLkYbXV64pWKoBw18nT3vm
         /1w3xmIsY43M6pxOaxsTMv+U71oterNThOTRI/wQrp/O/po0S4j1FdVbVdQ8UTRSqSu0
         cFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159217; x=1766764017;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BXcHXIDfWoSkrk6mEFbnYEvAXHgRRlXY75uZgyD6jWc=;
        b=Z6ptLJz18rzumIodXpnO0WgEcjRxIvPTpKxiQu1azeI8oZLBRfsW+dIQasZtGAI0hX
         ymluq0KbWjhotkHaSCzblEhmfA+6/vZObl4iiFxai5wm0xsuR3yxQRf6hCNoAgXxnsB3
         MCB9zG0fgz62vbLVOGdG8mnC2wK1o35UFicu9Hr8uHyBrSzpvChLm2x0lq/2sKns9TP8
         0Rxc+/K4c4FAxM/02fSNTvfTGvyIzm+4PCRnak7z+I89AIYUnKoLIxIDs/27hVtKp6BH
         YLOepqlavm+FLmkWIjRGbzQdx6zzSmC0EP6Y1IqFZet12S/aPqPEVYoKbMf9uiCJN0Pe
         DLQA==
X-Forwarded-Encrypted: i=1; AJvYcCUV0jRP9QPQchGHk2slCyBv1jk6oxXmLlqMJdCpA7mHONUPwoV5himkny2K7qTORUdi/qh9O2x0Xw==@kvack.org
X-Gm-Message-State: AOJu0YwZ1iuR52nzRuWdYcYPqV/dGE5lySccHH95qKEjxh/8LFirDcgg
	Z8gEly/TDbnzGtTjhHb/XEFkHP3HMt38CSaEYvEX1y6bt4BN8Fwc4zmUYVDKH9SZQ2OngWo1Z6P
	2uw==
X-Google-Smtp-Source: AGHT+IHyKiIB7A3/4NS3dgdSOn3IONvOE4PwqBUh1HTTKAWUaRZZqyIHVFzTOOWTZuodACVR6hwE9Va7/g==
X-Received: from wmco28.prod.google.com ([2002:a05:600c:a31c:b0:477:afa:d217])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:45cf:b0:47a:7fdd:2906
 with SMTP id 5b1f17b1804b1-47d1954a550mr28322755e9.12.1766159217354; Fri, 19
 Dec 2025 07:46:57 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:12 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-24-elver@google.com>
Subject: [PATCH v5 23/36] compiler-context-analysis: Remove Sparse support
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
X-Stat-Signature: jghp8hndj5ftoz637xui44kpy83jif4h
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9EC340008
X-Rspam-User: 
X-HE-Tag: 1766159218-66270
X-HE-Meta: U2FsdGVkX1/d0JrmIfGggLpDoLhCmgYoJFdCBJt9EP+3A9M6jwqcm8xssxy1G+ruVuUn0vWd2LiAJUXWmfAN3GESVpp3QYPqPfFWFSXmYzPYjJpd469xPhYq20E42rcBLUsmVxhWAEZnqKxumGOXJopHGW+p3SBHmeggfnfQFOZg3XWAtkG5oUxCHoXSsYKiy0cNsoPypc4R2vgzbXW2/8p7cRAnGQ+eWT+EKNQfGBTKDr30fAgOfSuawi2ueCrL13ybGBqgbX8d94NE9xRfS+Ra2uRj+wAiHTNmV7wI1P36SQVHDFJG88K20TN8AUFbTdJHSrE+cF3Vel56z6qrQSbGcQR7rm6FoGgT54JUfuS15K678Z4gPnZQj7YFAz29qj/Zd7kgECn9q+TWERD8XOaY20YF30E/ft/3/zpgbXa5siDvh3MICjw1T4gBs6ZKaZxgNBc29MQPYzjp/nRNrsXMSzzJIlTCHiNuAAqIZVI06up9QsSP6fK+ZPIouIWOuikXL+G6RuMpCEDQxAjcfVEX9qfOXnuqO7ReNxsIal01ZaVEyvJwKhRCZe3kkDG5S6tsIqAG2onJYNaFKLb2lAEoBVaJ7/vOCUunsRtX1T1eFjXGGdt+Zto4myrLcW9mq17AL68ePZKdzVcyUyPagk+MW1y4sAWY4mUoP21S58KM5+7FUOFnAW2lDaRMpSmkpVjpeUUL1Y/hYj923E0hbEYMb8x/MLUPbcmQdBI24H+21W6BUednczWi+9vTTkCjQAr9+30uiTwtuP30cOsp9xBHJI2gHk07+pW+T03uOnKD9w9zJdVO/akRnraUdJPu1S851oWzC2giRgG8YrXw7kDJ7lI8PExjCRBQ74VS16+W0h1d1tt5HMzy41rMprrD72qBYLCw3w5S1F4XlwKhAu0TE+18879H4z0t75Li56hZLKiVIeDgoHRlJIuyBa4YD4qXtW0HJoG3bPkBVVk
 WVp2o3Oh
 5KWF2E8/iEhepaPicodySTVl99Slc9MaQOmxEaMqqBdRs2kPXDAA+CbTYHdxbjEvBVCm2GXslBkQTpn7q6DZjRcC7gIQ+J3lUSGO6UoudalEJpbnfWaaRCmtetQS1BLJzkAZ6nEe0qJY2+J8PCk5TFnpW1nF1saNFmRteRaF3y9jDJ6fOKOutOMErAWEJh6X3P8GGW+Jb6eRlJpOFRO3LIJLbF49Fa6TBZPi23lmW8OarmCVCVwo8lBL78kWR2/JAd0sNj7W+4RUTvU1JtDQgm1BI073YflV/9NF1/8JT9FCatYz3nNNsg4RAS8tvLzu7kEApV7dGPH0Khjst3r0/n14iWbLNCrRn+XTkpp3lqhHj1C3/v/eRA2Y2Z9aSSIV7RPk0ro8d4s6FqxNjSjQHpuX+Js5TqmD49rZ1PrktOQdUbAVW3j9ul7wxov7tg2/bLciY7/hy4GXEUf8kpe+hptZZEWtf7yALBk7F1R+jXK8TDcBPWSUIk+jEncLswaBqlwvZzxiS0UHxcszFt0t2ghW2+9WQf6B4iGgFEZJ7GSE+O5YXz9dMvlPCcwxVQGfmhHPdns+bHtlRkrW4xbk3TY3PtnF95ovZ6gssGajFNq0V8Ip5FT6vvAWUbKhie1TpMPcnmbLloaE+Yj2SvUjehZKODUClUgMTVUGGMQ4Dd8ipXHRRHUN/k75pPU6ehWUmQ+0ucgde+KXc6iQia7OxHaCRgHQRma9xBcWT0uWZfp7NCYEm3oe59uJJcl1YueuETabHa2vM7EFzVMGpV0PRxizuXLVYryU7NOPOYIi6aZMYh/KrvLOuJWkiBCv8u3majbB6IcLCmaE/ct2qGFkOKjYZ0htVDB5hwtiiQy7/+yea8M736pyJ8hFVUQQlkaDI8DjVFqfcNnS3CoZCixpp6uTIbJ65s0VtqK9Y
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove Sparse support as discussed at [1].

The kernel codebase is still scattered with numerous places that try to
appease Sparse's context tracking ("annotation for sparse", "fake out
sparse", "work around sparse", etc.). Eventually, as more subsystems
enable Clang's context analysis, these places will show up and need
adjustment or removal of the workarounds altogether.

Link: https://lore.kernel.org/all/20250207083335.GW7145@noisy.programming.kicks-ass.net/ [1]
Link: https://lore.kernel.org/all/Z6XTKTo_LMj9KmbY@elver.google.com/ [2]
Cc: Chris Li <sparse@chrisli.org>
Cc: "Luc Van Oostenryck" <luc.vanoostenryck@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".

v4:
* Rename capability -> context analysis.

v2:
* New patch.
---
 Documentation/dev-tools/sparse.rst        | 19 -----
 include/linux/compiler-context-analysis.h | 85 +++++++----------------
 include/linux/rcupdate.h                  | 15 +---
 3 files changed, 28 insertions(+), 91 deletions(-)

diff --git a/Documentation/dev-tools/sparse.rst b/Documentation/dev-tools/sparse.rst
index dc791c8d84d1..37b20170835d 100644
--- a/Documentation/dev-tools/sparse.rst
+++ b/Documentation/dev-tools/sparse.rst
@@ -53,25 +53,6 @@ sure that bitwise types don't get mixed up (little-endian vs big-endian
 vs cpu-endian vs whatever), and there the constant "0" really _is_
 special.
 
-Using sparse for lock checking
-------------------------------
-
-The following macros are undefined for gcc and defined during a sparse
-run to use the "context" tracking feature of sparse, applied to
-locking.  These annotations tell sparse when a lock is held, with
-regard to the annotated function's entry and exit.
-
-__must_hold - The specified lock is held on function entry and exit.
-
-__acquires - The specified lock is held on function exit, but not entry.
-
-__releases - The specified lock is held on function entry, but not exit.
-
-If the function enters and exits without the lock held, acquiring and
-releasing the lock inside the function in a balanced way, no
-annotation is needed.  The three annotations above are for cases where
-sparse would otherwise report a context imbalance.
-
 Getting sparse
 --------------
 
diff --git a/include/linux/compiler-context-analysis.h b/include/linux/compiler-context-analysis.h
index 9ad800e27692..fccd6d68158e 100644
--- a/include/linux/compiler-context-analysis.h
+++ b/include/linux/compiler-context-analysis.h
@@ -262,57 +262,32 @@ static inline void _context_unsafe_alias(void **p) { }
 	extern const struct __ctx_lock_##ctx *name
 
 /*
- * Common keywords for static context analysis. Both Clang's "capability
- * analysis" and Sparse's "context tracking" are currently supported.
- */
-#ifdef __CHECKER__
-
-/* Sparse context/lock checking support. */
-# define __must_hold(x)		__attribute__((context(x,1,1)))
-# define __must_not_hold(x)
-# define __acquires(x)		__attribute__((context(x,0,1)))
-# define __cond_acquires(ret, x) __attribute__((context(x,0,-1)))
-# define __releases(x)		__attribute__((context(x,1,0)))
-# define __acquire(x)		__context__(x,1)
-# define __release(x)		__context__(x,-1)
-# define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
-/* For Sparse, there's no distinction between exclusive and shared locks. */
-# define __must_hold_shared	__must_hold
-# define __acquires_shared	__acquires
-# define __cond_acquires_shared __cond_acquires
-# define __releases_shared	__releases
-# define __acquire_shared	__acquire
-# define __release_shared	__release
-# define __cond_lock_shared	__cond_acquire
-
-#else /* !__CHECKER__ */
+ * Common keywords for static context analysis.
+ */
 
 /**
  * __must_hold() - function attribute, caller must hold exclusive context lock
- * @x: context lock instance pointer
  *
  * Function attribute declaring that the caller must hold the given context
- * lock instance @x exclusively.
+ * lock instance(s) exclusively.
  */
-# define __must_hold(x)		__requires_ctx_lock(x)
+#define __must_hold(...)	__requires_ctx_lock(__VA_ARGS__)
 
 /**
  * __must_not_hold() - function attribute, caller must not hold context lock
- * @x: context lock instance pointer
  *
  * Function attribute declaring that the caller must not hold the given context
- * lock instance @x.
+ * lock instance(s).
  */
-# define __must_not_hold(x)	__excludes_ctx_lock(x)
+#define __must_not_hold(...)	__excludes_ctx_lock(__VA_ARGS__)
 
 /**
  * __acquires() - function attribute, function acquires context lock exclusively
- * @x: context lock instance pointer
  *
  * Function attribute declaring that the function acquires the given context
- * lock instance @x exclusively, but does not release it.
+ * lock instance(s) exclusively, but does not release them.
  */
-# define __acquires(x)		__acquires_ctx_lock(x)
+#define __acquires(...)		__acquires_ctx_lock(__VA_ARGS__)
 
 /*
  * Clang's analysis does not care precisely about the value, only that it is
@@ -339,17 +314,16 @@ static inline void _context_unsafe_alias(void **p) { }
  *
  * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
+#define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
 
 /**
  * __releases() - function attribute, function releases a context lock exclusively
- * @x: context lock instance pointer
  *
  * Function attribute declaring that the function releases the given context
- * lock instance @x exclusively. The associated context must be active on
+ * lock instance(s) exclusively. The associated context(s) must be active on
  * entry.
  */
-# define __releases(x)		__releases_ctx_lock(x)
+#define __releases(...)		__releases_ctx_lock(__VA_ARGS__)
 
 /**
  * __acquire() - function to acquire context lock exclusively
@@ -357,7 +331,7 @@ static inline void _context_unsafe_alias(void **p) { }
  *
  * No-op function that acquires the given context lock instance @x exclusively.
  */
-# define __acquire(x)		__acquire_ctx_lock(x)
+#define __acquire(x)		__acquire_ctx_lock(x)
 
 /**
  * __release() - function to release context lock exclusively
@@ -365,7 +339,7 @@ static inline void _context_unsafe_alias(void **p) { }
  *
  * No-op function that releases the given context lock instance @x.
  */
-# define __release(x)		__release_ctx_lock(x)
+#define __release(x)		__release_ctx_lock(x)
 
 /**
  * __cond_lock() - function that conditionally acquires a context lock
@@ -383,25 +357,23 @@ static inline void _context_unsafe_alias(void **p) { }
  *
  *	#define spin_trylock(l) __cond_lock(&lock, _spin_trylock(&lock))
  */
-# define __cond_lock(x, c)	__try_acquire_ctx_lock(x, c)
+#define __cond_lock(x, c)	__try_acquire_ctx_lock(x, c)
 
 /**
  * __must_hold_shared() - function attribute, caller must hold shared context lock
- * @x: context lock instance pointer
  *
  * Function attribute declaring that the caller must hold the given context
- * lock instance @x with shared access.
+ * lock instance(s) with shared access.
  */
-# define __must_hold_shared(x)	__requires_shared_ctx_lock(x)
+#define __must_hold_shared(...)	__requires_shared_ctx_lock(__VA_ARGS__)
 
 /**
  * __acquires_shared() - function attribute, function acquires context lock shared
- * @x: context lock instance pointer
  *
  * Function attribute declaring that the function acquires the given
- * context lock instance @x with shared access, but does not release it.
+ * context lock instance(s) with shared access, but does not release them.
  */
-# define __acquires_shared(x)	__acquires_shared_ctx_lock(x)
+#define __acquires_shared(...)	__acquires_shared_ctx_lock(__VA_ARGS__)
 
 /**
  * __cond_acquires_shared() - function attribute, function conditionally
@@ -410,23 +382,22 @@ static inline void _context_unsafe_alias(void **p) { }
  * @x: context lock instance pointer
  *
  * Function attribute declaring that the function conditionally acquires the
- * given context lock instance @x with shared access, but does not release it. The
- * function return value @ret denotes when the context lock is acquired.
+ * given context lock instance @x with shared access, but does not release it.
+ * The function return value @ret denotes when the context lock is acquired.
  *
  * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires_shared(ret, x) __cond_acquires_impl_##ret(x, _shared)
+#define __cond_acquires_shared(ret, x) __cond_acquires_impl_##ret(x, _shared)
 
 /**
  * __releases_shared() - function attribute, function releases a
  *                       context lock shared
- * @x: context lock instance pointer
  *
  * Function attribute declaring that the function releases the given context
- * lock instance @x with shared access. The associated context must be active
- * on entry.
+ * lock instance(s) with shared access. The associated context(s) must be
+ * active on entry.
  */
-# define __releases_shared(x)	__releases_shared_ctx_lock(x)
+#define __releases_shared(...)	__releases_shared_ctx_lock(__VA_ARGS__)
 
 /**
  * __acquire_shared() - function to acquire context lock shared
@@ -435,7 +406,7 @@ static inline void _context_unsafe_alias(void **p) { }
  * No-op function that acquires the given context lock instance @x with shared
  * access.
  */
-# define __acquire_shared(x)	__acquire_shared_ctx_lock(x)
+#define __acquire_shared(x)	__acquire_shared_ctx_lock(x)
 
 /**
  * __release_shared() - function to release context lock shared
@@ -444,7 +415,7 @@ static inline void _context_unsafe_alias(void **p) { }
  * No-op function that releases the given context lock instance @x with shared
  * access.
  */
-# define __release_shared(x)	__release_shared_ctx_lock(x)
+#define __release_shared(x)	__release_shared_ctx_lock(x)
 
 /**
  * __cond_lock_shared() - function that conditionally acquires a context lock shared
@@ -457,9 +428,7 @@ static inline void _context_unsafe_alias(void **p) { }
  * shared access, if the boolean expression @c is true. The result of @c is the
  * return value.
  */
-# define __cond_lock_shared(x, c) __try_acquire_shared_ctx_lock(x, c)
-
-#endif /* __CHECKER__ */
+#define __cond_lock_shared(x, c) __try_acquire_shared_ctx_lock(x, c)
 
 /**
  * __acquire_ret() - helper to acquire context lock of return value
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 50e63eade019..d828a4673441 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -1219,20 +1219,7 @@ rcu_head_after_call_rcu(struct rcu_head *rhp, rcu_callback_t f)
 extern int rcu_expedited;
 extern int rcu_normal;
 
-DEFINE_LOCK_GUARD_0(rcu,
-	do {
-		rcu_read_lock();
-		/*
-		 * sparse doesn't call the cleanup function,
-		 * so just release immediately and don't track
-		 * the context. We don't need to anyway, since
-		 * the whole point of the guard is to not need
-		 * the explicit unlock.
-		 */
-		__release(RCU);
-	} while (0),
-	rcu_read_unlock())
-
+DEFINE_LOCK_GUARD_0(rcu, rcu_read_lock(), rcu_read_unlock())
 DECLARE_LOCK_GUARD_0_ATTRS(rcu, __acquires_shared(RCU), __releases_shared(RCU))
 
 #endif /* __LINUX_RCUPDATE_H */
-- 
2.52.0.322.g1dd061c0dc-goog


