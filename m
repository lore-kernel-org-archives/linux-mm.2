Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5170D7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59F906B008C; Fri, 19 Dec 2025 10:45:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5693F6B0092; Fri, 19 Dec 2025 10:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44AF26B0093; Fri, 19 Dec 2025 10:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3143C6B008C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:45:27 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C039EB7EE2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:26 +0000 (UTC)
X-FDA: 84236645052.23.EBF28F8
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id C3F241C001F
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:45:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tTPqYoPe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3EnNFaQUKCF8BISBODLLDIB.9LJIFKRU-JJHS79H.LOD@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3EnNFaQUKCF8BISBODLLDIB.9LJIFKRU-JJHS79H.LOD@flex--elver.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159124; a=rsa-sha256;
	cv=none;
	b=rHVDwbDIz/rueiEqE/mlgO2EZhig/fgQaid/8kcoEwlpSAAuGAHioej7wlc8m3Bdu7AM14
	vWi2s18DQnT2I2LTPLkecvOX59+i39RG4xuPuhlwZrEa2hdp7Bj+RgPJRNMVvWQZ3NucdQ
	QiO4BH9GXSWLMzPC1GM0JRdR8K+z7j4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tTPqYoPe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3EnNFaQUKCF8BISBODLLDIB.9LJIFKRU-JJHS79H.LOD@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3EnNFaQUKCF8BISBODLLDIB.9LJIFKRU-JJHS79H.LOD@flex--elver.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31QsZmag33fLdjyCYpWTjN5tFNjf4WEVSli7AO9DFeU=;
	b=d+ZRcENRglGUtY5NWMk5wW6mYbGpPbT+cgh/V6bXmKW3fyE8sqgptwc+PSLId6ZVJAnAR8
	52029stbumjpZKj+x0d7g+hymA0jMR72ZL9NobRByhy85B5yVIRlslazqUEbA2RdqS8Akw
	1X6q0hEAPzjz5jjy0S9StvGq5XjBkaY=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779981523fso21271705e9.2
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159123; x=1766763923; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=31QsZmag33fLdjyCYpWTjN5tFNjf4WEVSli7AO9DFeU=;
        b=tTPqYoPel9wN2WaciGTfMDnXTlugGgTycHBYizBnOqNPOsAlV08XwyViexXxD/2HfH
         evcE+lSuQ/VngI068YRuQqRw+Z8+oZqiOIxGOAfc3O2to69KSzu4gixp4V7lHq7gBdn1
         1OxVG4znCYhdHgCjQK4mXRFnrwM+33g/rDwwIFfYt64aPgtXTmP6cw2Nh7Xi+wbdOa/b
         tv9dnQnfbbAFfa9QOJ0sWaHDIoe2UpV/YpghvMISGlYXCs81EHF6fyoBkPIK9Gp16+pC
         fFsFQQI9FbfJA3TVsNzTDYatF97UcHx18tNdoSOmFjSl6aKeWg6N6MvF+fbcyBgMw/6+
         Cgbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159123; x=1766763923;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=31QsZmag33fLdjyCYpWTjN5tFNjf4WEVSli7AO9DFeU=;
        b=J95BSF+XwIeKuJN4JPYFa4EAsaGkc2tQerS3MnzBQtGjsNLwdAarCc9jxywrEJnLUK
         TTtB9viB4MJckQBGGBfRikn3lFhec/jcQQByaTAt9EFRNfUvorqssQZdccG7/m3QSzMT
         K3uEi42BBipYT0/z/v9rFS0SbOdmoNYBdOargH889LJEp7g1NfXTu0dldeoOIUYSil5h
         JVI07QGmhwHnC1T5Sx2w7q1A9T2vmt7joYDIp8eh/NwcT8l50P1L1Zof1SkJsizMh4fN
         vwQGfs9cUubqMRE1DRqi/Tw5TpMSs74+jlR2ETowvKF+I4Fu9cwh6N+nB9sElSc+nU5Z
         689Q==
X-Forwarded-Encrypted: i=1; AJvYcCVYFa8bhHcfnmQJqxfmYugfbrCVgKIy+Fzd6qklNJDppx3fU/liH3rGG+x3aUmmEQMJXJoB7YgGVw==@kvack.org
X-Gm-Message-State: AOJu0Yw1TO+9kvQM99EeB5WgINNN1CGN5ALXVexYUj8bt3yNGms+v7Tx
	8j+SLJldTsrBbpcZIujnjLbc20mtdojvr6eDZvcTFMbX5DEl/mhJjM8Rfh9MbCMZozGdkZwq6Ld
	/SA==
X-Google-Smtp-Source: AGHT+IG62NwBZ7/G20o3wsCQBsfZR2Y7hb+y0d4KcogHXMVdQXMZrqrYD7HGKsHMaCOMVVWF1569WOWotQ==
X-Received: from wrd22.prod.google.com ([2002:a05:6000:4a16:b0:431:92e:1d36])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1c1b:b0:477:9976:9e1a
 with SMTP id 5b1f17b1804b1-47d1956e545mr34346535e9.6.1766159122833; Fri, 19
 Dec 2025 07:45:22 -0800 (PST)
Date: Fri, 19 Dec 2025 16:39:51 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-3-elver@google.com>
Subject: [PATCH v5 02/36] compiler-context-analysis: Add infrastructure for
 Context Analysis with Clang
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C3F241C001F
X-Stat-Signature: r4i3gry7qhd51pcjtwkyqwismj3y6wth
X-HE-Tag: 1766159124-178063
X-HE-Meta: U2FsdGVkX19zcIBJ7GMBY58m1kagadwJXZdFN1aaih38Jz4mAyxTwZNscn6J1aNolV3ae+FktDWxGAh/U7bN9/z7GKzUZ/TWocROnIb25W+UH09p3j0xmKutdVd1lQq5pfbpw5RbCpOH1xri+xqRrbMtUlykHn+RUvUgb5FWGKmqXTGCLQO8CP89Pp+55c0xFeD24bi0KBnfW44tM1FL6TMuT7nFuKOMH/KbycPSde/qdA8f9bPQ2UkbDZlu+MGneChvN1bVX+ZWeUoTR0T04/MxMX4REcJem7b/gYuYPKrDQj1uRyOCH+ShOyows5DXyRmQxE/uhsYl/F8FHoGjuINgHoH/xd0/PNKUs7HHvhJ0H2RzTFQPUkZZC5rohh5O+8kYMJvcQI5iNsBTyHeG6sLJuL6+3IIokxRhbOBcI5jmR49uy9l8+9ywPVd+VNT3cJMH6orEcpJqsd6pjan/zy3JCFm9tVIsPL2S5f03z/F/t1qWTxSi72BDZEPhbttV/QlDvHXaXcZiWD6HByLoAxk0XL9Kit6Sny/mY4IBrHS6b6o8YQN6egz1ofrP/cMlBiQVdBVBn+5Ry0cWw+z/hIFqw82oESF1fmbsYBiMuDHyB5aN36X5ZVyu0f4QrfLrBV5Xio0d9CRuYUvlHI/GUznO52gAYSKCC48yXI2PnwZGWd3Revy0Igb7oQCveDbQPhui68taW7xZWDJO60jxx6ZrfHJAVautCnGiuz7Jh0X2lEcH4l5lt/jcPGeu+/vlh6E6+PY2OR5KohQTPq6c+aoyGKoiPwSk1CRgo48PWTwKaL9Nu53bEmBl9ovaqkdVK6duw1f8nDFtvTBE+Tj0zL/mqYDB9yDi11n3ddnTPrT5s88WRGPN+uJHG1nC0twJITAyZaqDO6/vSf/mBbtGfAlYqr+hH8mgHVdQLvwIYIPAuAeKIEo4I/j8eZYVfONh9Bi5ulS8f7phQhN3GuQ
 WDLjr7yR
 M2xF3K9LeR3CQ0Pq4r1CDqK3pEoOyk639it7zUXqprsVzS229ZXcSIdGwOzvegb6ojxSlWlJzRa2vSyQx81rqiWImWwydQvOh6drhRBM/ncBdnfpmWvxWHfoxkhD9MVQExQTBRKQX53jUXDNnrKBpv+0ZGMkeNM1tsBfW+yr1yM8FONEIbYoCrRLoM7qApSaJb8PXSVxpohFQ4Qshb5b3HFakBP1I46ubdhDQWi4oqqGhAYJ7fQEOQ9Gz07HsaahTzHTEcdYOFd+eHcANMPSyeLjwUVj5dIjui+VSiwmageE94OoqWUVx7yRcEX22LLe08q/upP83y0ICJ3LKFW1qstr+eZtzmq1nFxCGgKLfKZSDD2HLIrVAk/9Pg+IRsvTztBB+x2P+CDcwGDV5DsGzvbq879Ghhb4HjDg2c0R/VtTb8QAQwNLKjtoXGSJRxkDvcjXQ/rqtdDVov18ZH+qR4ZPzqS/jfptkRXvi7TOD/wqwhHjC/pE+8rnZhU4V4qv8TtzVvWQracXbFibVmCz5XGIzMMt5J8sB9HQgdsEo0g5sxCmK73tIKK35JWlIwGpHfhElykDGQhV/kp7BkxnysZpM2pC11xQ70XO2IeTvr+y9i0z34+R4CVXyL/ryh8r3CxMsClB0MJRh8nqDzvLuPMkMsQR5YvYo7BqPVq6TKPf3k0PBrfx2P/FAP0+s0W8s3CRIpFcpLbrlrcQnIFseYGD15SE/lA3L40h464FxHy/PyttOVUiL2P586bDUOeg/fz94aCWaBuD14fwuIwUPs95aycFrwcGxLPs8QW0bbfbIecc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Context Analysis is a language extension, which enables statically
checking that required contexts are active (or inactive), by acquiring
and releasing user-definable "context locks". An obvious application is
lock-safety checking for the kernel's various synchronization primitives
(each of which represents a "context lock"), and checking that locking
rules are not violated.

Clang originally called the feature "Thread Safety Analysis" [1]. This
was later changed and the feature became more flexible, gaining the
ability to define custom "capabilities". Its foundations can be found in
"Capability Systems" [2], used to specify the permissibility of
operations to depend on some "capability" being held (or not held).

Because the feature is not just able to express "capabilities" related
to synchronization primitives, and "capability" is already overloaded in
the kernel, the naming chosen for the kernel departs from Clang's
"Thread Safety" and "capability" nomenclature; we refer to the feature
as "Context Analysis" to avoid confusion. The internal implementation
still makes references to Clang's terminology in a few places, such as
`-Wthread-safety` being the warning option that also still appears in
diagnostic messages.

 [1] https://clang.llvm.org/docs/ThreadSafetyAnalysis.html
 [2] https://www.cs.cornell.edu/talc/papers/capabilities.pdf

See more details in the kernel-doc documentation added in this and
subsequent changes.

Clang version 22+ is required.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Rename "context guard" -> "context lock".
* Better document Clang's `assert_capability` attribute.

v4:
* Rename capability -> context analysis.

v3:
* Require Clang 22 or later (reentrant capabilities, basic alias analysis).
* Rename __assert_cap/__asserts_cap -> __assume_cap/__assumes_cap (suggested by Peter).
* Add __acquire_ret and __acquire_shared_ret helper macros - can be used
  to define function-like macros that return objects which contains a
  held capabilities. Works now because of capability alias analysis.
* Add capability_unsafe_alias() helper, where the analysis rightfully
  points out we're doing strange things with aliases but we don't care.
* Support multi-argument attributes.

v2:
* New -Wthread-safety feature rename to -Wthread-safety-pointer (was
  -Wthread-safety-addressof).
* Introduce __capability_unsafe() function attribute.
* Rename __var_guarded_by to simply __guarded_by. The initial idea was
  to be explicit if the variable or pointed-to data is guarded by, but
  having a shorter attribute name is likely better long-term.
* Rename __ref_guarded_by to __pt_guarded_by (pointed-to guarded by).
---
 Makefile                                  |   1 +
 include/linux/compiler-context-analysis.h | 464 +++++++++++++++++++++-
 lib/Kconfig.debug                         |  30 ++
 scripts/Makefile.context-analysis         |   7 +
 scripts/Makefile.lib                      |  10 +
 5 files changed, 505 insertions(+), 7 deletions(-)
 create mode 100644 scripts/Makefile.context-analysis

diff --git a/Makefile b/Makefile
index e404e4767944..d4c2aa2df79c 100644
--- a/Makefile
+++ b/Makefile
@@ -1118,6 +1118,7 @@ include-$(CONFIG_RANDSTRUCT)	+= scripts/Makefile.randstruct
 include-$(CONFIG_KSTACK_ERASE)	+= scripts/Makefile.kstack_erase
 include-$(CONFIG_AUTOFDO_CLANG)	+= scripts/Makefile.autofdo
 include-$(CONFIG_PROPELLER_CLANG)	+= scripts/Makefile.propeller
+include-$(CONFIG_WARN_CONTEXT_ANALYSIS) += scripts/Makefile.context-analysis
 include-$(CONFIG_GCC_PLUGINS)	+= scripts/Makefile.gcc-plugins
 
 include $(addprefix $(srctree)/, $(include-y))
diff --git a/include/linux/compiler-context-analysis.h b/include/linux/compiler-context-analysis.h
index f8af63045281..afff910d8930 100644
--- a/include/linux/compiler-context-analysis.h
+++ b/include/linux/compiler-context-analysis.h
@@ -6,27 +6,477 @@
 #ifndef _LINUX_COMPILER_CONTEXT_ANALYSIS_H
 #define _LINUX_COMPILER_CONTEXT_ANALYSIS_H
 
+#if defined(WARN_CONTEXT_ANALYSIS)
+
+/*
+ * These attributes define new context lock (Clang: capability) types.
+ * Internal only.
+ */
+# define __ctx_lock_type(name)			__attribute__((capability(#name)))
+# define __reentrant_ctx_lock			__attribute__((reentrant_capability))
+# define __acquires_ctx_lock(...)		__attribute__((acquire_capability(__VA_ARGS__)))
+# define __acquires_shared_ctx_lock(...)	__attribute__((acquire_shared_capability(__VA_ARGS__)))
+# define __try_acquires_ctx_lock(ret, var)	__attribute__((try_acquire_capability(ret, var)))
+# define __try_acquires_shared_ctx_lock(ret, var) __attribute__((try_acquire_shared_capability(ret, var)))
+# define __releases_ctx_lock(...)		__attribute__((release_capability(__VA_ARGS__)))
+# define __releases_shared_ctx_lock(...)	__attribute__((release_shared_capability(__VA_ARGS__)))
+# define __returns_ctx_lock(var)		__attribute__((lock_returned(var)))
+
+/*
+ * The below are used to annotate code being checked. Internal only.
+ */
+# define __excludes_ctx_lock(...)		__attribute__((locks_excluded(__VA_ARGS__)))
+# define __requires_ctx_lock(...)		__attribute__((requires_capability(__VA_ARGS__)))
+# define __requires_shared_ctx_lock(...)	__attribute__((requires_shared_capability(__VA_ARGS__)))
+
+/*
+ * The "assert_capability" attribute is a bit confusingly named. It does not
+ * generate a check. Instead, it tells the analysis to *assume* the capability
+ * is held. This is used for:
+ *
+ * 1. Augmenting runtime assertions, that can then help with patterns beyond the
+ *    compiler's static reasoning abilities.
+ *
+ * 2. Initialization of context locks, so we can access guarded variables right
+ *    after initialization (nothing else should access the same object yet).
+ */
+# define __assumes_ctx_lock(...)		__attribute__((assert_capability(__VA_ARGS__)))
+# define __assumes_shared_ctx_lock(...)	__attribute__((assert_shared_capability(__VA_ARGS__)))
+
+/**
+ * __guarded_by - struct member and globals attribute, declares variable
+ *                only accessible within active context
+ *
+ * Declares that the struct member or global variable is only accessible within
+ * the context entered by the given context lock. Read operations on the data
+ * require shared access, while write operations require exclusive access.
+ *
+ * .. code-block:: c
+ *
+ *	struct some_state {
+ *		spinlock_t lock;
+ *		long counter __guarded_by(&lock);
+ *	};
+ */
+# define __guarded_by(...)		__attribute__((guarded_by(__VA_ARGS__)))
+
+/**
+ * __pt_guarded_by - struct member and globals attribute, declares pointed-to
+ *                   data only accessible within active context
+ *
+ * Declares that the data pointed to by the struct member pointer or global
+ * pointer is only accessible within the context entered by the given context
+ * lock. Read operations on the data require shared access, while write
+ * operations require exclusive access.
+ *
+ * .. code-block:: c
+ *
+ *	struct some_state {
+ *		spinlock_t lock;
+ *		long *counter __pt_guarded_by(&lock);
+ *	};
+ */
+# define __pt_guarded_by(...)		__attribute__((pt_guarded_by(__VA_ARGS__)))
+
+/**
+ * context_lock_struct() - declare or define a context lock struct
+ * @name: struct name
+ *
+ * Helper to declare or define a struct type that is also a context lock.
+ *
+ * .. code-block:: c
+ *
+ *	context_lock_struct(my_handle) {
+ *		int foo;
+ *		long bar;
+ *	};
+ *
+ *	struct some_state {
+ *		...
+ *	};
+ *	// ... declared elsewhere ...
+ *	context_lock_struct(some_state);
+ *
+ * Note: The implementation defines several helper functions that can acquire
+ * and release the context lock.
+ */
+# define context_lock_struct(name, ...)									\
+	struct __ctx_lock_type(name) __VA_ARGS__ name;							\
+	static __always_inline void __acquire_ctx_lock(const struct name *var)				\
+		__attribute__((overloadable)) __no_context_analysis __acquires_ctx_lock(var) { }	\
+	static __always_inline void __acquire_shared_ctx_lock(const struct name *var)			\
+		__attribute__((overloadable)) __no_context_analysis __acquires_shared_ctx_lock(var) { } \
+	static __always_inline bool __try_acquire_ctx_lock(const struct name *var, bool ret)		\
+		__attribute__((overloadable)) __no_context_analysis __try_acquires_ctx_lock(1, var)	\
+	{ return ret; }											\
+	static __always_inline bool __try_acquire_shared_ctx_lock(const struct name *var, bool ret)	\
+		__attribute__((overloadable)) __no_context_analysis __try_acquires_shared_ctx_lock(1, var) \
+	{ return ret; }											\
+	static __always_inline void __release_ctx_lock(const struct name *var)				\
+		__attribute__((overloadable)) __no_context_analysis __releases_ctx_lock(var) { }	\
+	static __always_inline void __release_shared_ctx_lock(const struct name *var)			\
+		__attribute__((overloadable)) __no_context_analysis __releases_shared_ctx_lock(var) { } \
+	static __always_inline void __assume_ctx_lock(const struct name *var)				\
+		__attribute__((overloadable)) __assumes_ctx_lock(var) { }				\
+	static __always_inline void __assume_shared_ctx_lock(const struct name *var)			\
+		__attribute__((overloadable)) __assumes_shared_ctx_lock(var) { }			\
+	struct name
+
+/**
+ * disable_context_analysis() - disables context analysis
+ *
+ * Disables context analysis. Must be paired with a later
+ * enable_context_analysis().
+ */
+# define disable_context_analysis()				\
+	__diag_push();						\
+	__diag_ignore_all("-Wunknown-warning-option", "")	\
+	__diag_ignore_all("-Wthread-safety", "")		\
+	__diag_ignore_all("-Wthread-safety-pointer", "")
+
+/**
+ * enable_context_analysis() - re-enables context analysis
+ *
+ * Re-enables context analysis. Must be paired with a prior
+ * disable_context_analysis().
+ */
+# define enable_context_analysis() __diag_pop()
+
+/**
+ * __no_context_analysis - function attribute, disables context analysis
+ *
+ * Function attribute denoting that context analysis is disabled for the
+ * whole function. Prefer use of `context_unsafe()` where possible.
+ */
+# define __no_context_analysis	__attribute__((no_thread_safety_analysis))
+
+#else /* !WARN_CONTEXT_ANALYSIS */
+
+# define __ctx_lock_type(name)
+# define __reentrant_ctx_lock
+# define __acquires_ctx_lock(...)
+# define __acquires_shared_ctx_lock(...)
+# define __try_acquires_ctx_lock(ret, var)
+# define __try_acquires_shared_ctx_lock(ret, var)
+# define __releases_ctx_lock(...)
+# define __releases_shared_ctx_lock(...)
+# define __assumes_ctx_lock(...)
+# define __assumes_shared_ctx_lock(...)
+# define __returns_ctx_lock(var)
+# define __guarded_by(...)
+# define __pt_guarded_by(...)
+# define __excludes_ctx_lock(...)
+# define __requires_ctx_lock(...)
+# define __requires_shared_ctx_lock(...)
+# define __acquire_ctx_lock(var)			do { } while (0)
+# define __acquire_shared_ctx_lock(var)		do { } while (0)
+# define __try_acquire_ctx_lock(var, ret)		(ret)
+# define __try_acquire_shared_ctx_lock(var, ret)	(ret)
+# define __release_ctx_lock(var)			do { } while (0)
+# define __release_shared_ctx_lock(var)		do { } while (0)
+# define __assume_ctx_lock(var)			do { (void)(var); } while (0)
+# define __assume_shared_ctx_lock(var)			do { (void)(var); } while (0)
+# define context_lock_struct(name, ...)		struct __VA_ARGS__ name
+# define disable_context_analysis()
+# define enable_context_analysis()
+# define __no_context_analysis
+
+#endif /* WARN_CONTEXT_ANALYSIS */
+
+/**
+ * context_unsafe() - disable context checking for contained code
+ *
+ * Disables context checking for contained statements or expression.
+ *
+ * .. code-block:: c
+ *
+ *	struct some_data {
+ *		spinlock_t lock;
+ *		int counter __guarded_by(&lock);
+ *	};
+ *
+ *	int foo(struct some_data *d)
+ *	{
+ *		// ...
+ *		// other code that is still checked ...
+ *		// ...
+ *		return context_unsafe(d->counter);
+ *	}
+ */
+#define context_unsafe(...)		\
+({					\
+	disable_context_analysis();	\
+	__VA_ARGS__;			\
+	enable_context_analysis()	\
+})
+
+/**
+ * __context_unsafe() - function attribute, disable context checking
+ * @comment: comment explaining why opt-out is safe
+ *
+ * Function attribute denoting that context analysis is disabled for the
+ * whole function. Forces adding an inline comment as argument.
+ */
+#define __context_unsafe(comment) __no_context_analysis
+
+/**
+ * context_unsafe_alias() - helper to insert a context lock "alias barrier"
+ * @p: pointer aliasing a context lock or object containing context locks
+ *
+ * No-op function that acts as a "context lock alias barrier", where the
+ * analysis rightfully detects that we're switching aliases, but the switch is
+ * considered safe but beyond the analysis reasoning abilities.
+ *
+ * This should be inserted before the first use of such an alias.
+ *
+ * Implementation Note: The compiler ignores aliases that may be reassigned but
+ * their value cannot be determined (e.g. when passing a non-const pointer to an
+ * alias as a function argument).
+ */
+#define context_unsafe_alias(p) _context_unsafe_alias((void **)&(p))
+static inline void _context_unsafe_alias(void **p) { }
+
+/**
+ * token_context_lock() - declare an abstract global context lock instance
+ * @name: token context lock name
+ *
+ * Helper that declares an abstract global context lock instance @name, but not
+ * backed by a real data structure (linker error if accidentally referenced).
+ * The type name is `__ctx_lock_@name`.
+ */
+#define token_context_lock(name, ...)					\
+	context_lock_struct(__ctx_lock_##name, ##__VA_ARGS__) {};	\
+	extern const struct __ctx_lock_##name *name
+
+/**
+ * token_context_lock_instance() - declare another instance of a global context lock
+ * @ctx: token context lock previously declared with token_context_lock()
+ * @name: name of additional global context lock instance
+ *
+ * Helper that declares an additional instance @name of the same token context
+ * lock class @ctx. This is helpful where multiple related token contexts are
+ * declared, to allow using the same underlying type (`__ctx_lock_@ctx`) as
+ * function arguments.
+ */
+#define token_context_lock_instance(ctx, name)		\
+	extern const struct __ctx_lock_##ctx *name
+
+/*
+ * Common keywords for static context analysis. Both Clang's "capability
+ * analysis" and Sparse's "context tracking" are currently supported.
+ */
 #ifdef __CHECKER__
 
 /* Sparse context/lock checking support. */
 # define __must_hold(x)		__attribute__((context(x,1,1)))
+# define __must_not_hold(x)
 # define __acquires(x)		__attribute__((context(x,0,1)))
 # define __cond_acquires(x)	__attribute__((context(x,0,-1)))
 # define __releases(x)		__attribute__((context(x,1,0)))
 # define __acquire(x)		__context__(x,1)
 # define __release(x)		__context__(x,-1)
 # define __cond_lock(x, c)	((c) ? ({ __acquire(x); 1; }) : 0)
+/* For Sparse, there's no distinction between exclusive and shared locks. */
+# define __must_hold_shared	__must_hold
+# define __acquires_shared	__acquires
+# define __cond_acquires_shared __cond_acquires
+# define __releases_shared	__releases
+# define __acquire_shared	__acquire
+# define __release_shared	__release
+# define __cond_lock_shared	__cond_acquire
 
 #else /* !__CHECKER__ */
 
-# define __must_hold(x)
-# define __acquires(x)
-# define __cond_acquires(x)
-# define __releases(x)
-# define __acquire(x)		(void)0
-# define __release(x)		(void)0
-# define __cond_lock(x, c)	(c)
+/**
+ * __must_hold() - function attribute, caller must hold exclusive context lock
+ * @x: context lock instance pointer
+ *
+ * Function attribute declaring that the caller must hold the given context
+ * lock instance @x exclusively.
+ */
+# define __must_hold(x)		__requires_ctx_lock(x)
+
+/**
+ * __must_not_hold() - function attribute, caller must not hold context lock
+ * @x: context lock instance pointer
+ *
+ * Function attribute declaring that the caller must not hold the given context
+ * lock instance @x.
+ */
+# define __must_not_hold(x)	__excludes_ctx_lock(x)
+
+/**
+ * __acquires() - function attribute, function acquires context lock exclusively
+ * @x: context lock instance pointer
+ *
+ * Function attribute declaring that the function acquires the given context
+ * lock instance @x exclusively, but does not release it.
+ */
+# define __acquires(x)		__acquires_ctx_lock(x)
+
+/**
+ * __cond_acquires() - function attribute, function conditionally
+ *                     acquires a context lock exclusively
+ * @x: context lock instance pointer
+ *
+ * Function attribute declaring that the function conditionally acquires the
+ * given context lock instance @x exclusively, but does not release it.
+ */
+# define __cond_acquires(x)	__try_acquires_ctx_lock(1, x)
+
+/**
+ * __releases() - function attribute, function releases a context lock exclusively
+ * @x: context lock instance pointer
+ *
+ * Function attribute declaring that the function releases the given context
+ * lock instance @x exclusively. The associated context must be active on
+ * entry.
+ */
+# define __releases(x)		__releases_ctx_lock(x)
+
+/**
+ * __acquire() - function to acquire context lock exclusively
+ * @x: context lock instance pointer
+ *
+ * No-op function that acquires the given context lock instance @x exclusively.
+ */
+# define __acquire(x)		__acquire_ctx_lock(x)
+
+/**
+ * __release() - function to release context lock exclusively
+ * @x: context lock instance pointer
+ *
+ * No-op function that releases the given context lock instance @x.
+ */
+# define __release(x)		__release_ctx_lock(x)
+
+/**
+ * __cond_lock() - function that conditionally acquires a context lock
+ *                 exclusively
+ * @x: context lock instance pinter
+ * @c: boolean expression
+ *
+ * Return: result of @c
+ *
+ * No-op function that conditionally acquires context lock instance @x
+ * exclusively, if the boolean expression @c is true. The result of @c is the
+ * return value; for example:
+ *
+ * .. code-block:: c
+ *
+ *	#define spin_trylock(l) __cond_lock(&lock, _spin_trylock(&lock))
+ */
+# define __cond_lock(x, c)	__try_acquire_ctx_lock(x, c)
+
+/**
+ * __must_hold_shared() - function attribute, caller must hold shared context lock
+ * @x: context lock instance pointer
+ *
+ * Function attribute declaring that the caller must hold the given context
+ * lock instance @x with shared access.
+ */
+# define __must_hold_shared(x)	__requires_shared_ctx_lock(x)
+
+/**
+ * __acquires_shared() - function attribute, function acquires context lock shared
+ * @x: context lock instance pointer
+ *
+ * Function attribute declaring that the function acquires the given
+ * context lock instance @x with shared access, but does not release it.
+ */
+# define __acquires_shared(x)	__acquires_shared_ctx_lock(x)
+
+/**
+ * __cond_acquires_shared() - function attribute, function conditionally
+ *                            acquires a context lock shared
+ * @x: context lock instance pointer
+ *
+ * Function attribute declaring that the function conditionally acquires the
+ * given context lock instance @x with shared access, but does not release it.
+ */
+# define __cond_acquires_shared(x) __try_acquires_shared_ctx_lock(1, x)
+
+/**
+ * __releases_shared() - function attribute, function releases a
+ *                       context lock shared
+ * @x: context lock instance pointer
+ *
+ * Function attribute declaring that the function releases the given context
+ * lock instance @x with shared access. The associated context must be active
+ * on entry.
+ */
+# define __releases_shared(x)	__releases_shared_ctx_lock(x)
+
+/**
+ * __acquire_shared() - function to acquire context lock shared
+ * @x: context lock instance pointer
+ *
+ * No-op function that acquires the given context lock instance @x with shared
+ * access.
+ */
+# define __acquire_shared(x)	__acquire_shared_ctx_lock(x)
+
+/**
+ * __release_shared() - function to release context lock shared
+ * @x: context lock instance pointer
+ *
+ * No-op function that releases the given context lock instance @x with shared
+ * access.
+ */
+# define __release_shared(x)	__release_shared_ctx_lock(x)
+
+/**
+ * __cond_lock_shared() - function that conditionally acquires a context lock shared
+ * @x: context lock instance pinter
+ * @c: boolean expression
+ *
+ * Return: result of @c
+ *
+ * No-op function that conditionally acquires context lock instance @x with
+ * shared access, if the boolean expression @c is true. The result of @c is the
+ * return value.
+ */
+# define __cond_lock_shared(x, c) __try_acquire_shared_ctx_lock(x, c)
 
 #endif /* __CHECKER__ */
 
+/**
+ * __acquire_ret() - helper to acquire context lock of return value
+ * @call: call expression
+ * @ret_expr: acquire expression that uses __ret
+ */
+#define __acquire_ret(call, ret_expr)		\
+	({					\
+		__auto_type __ret = call;	\
+		__acquire(ret_expr);		\
+		__ret;				\
+	})
+
+/**
+ * __acquire_shared_ret() - helper to acquire context lock shared of return value
+ * @call: call expression
+ * @ret_expr: acquire shared expression that uses __ret
+ */
+#define __acquire_shared_ret(call, ret_expr)	\
+	({					\
+		__auto_type __ret = call;	\
+		__acquire_shared(ret_expr);	\
+		__ret;				\
+	})
+
+/*
+ * Attributes to mark functions returning acquired context locks.
+ *
+ * This is purely cosmetic to help readability, and should be used with the
+ * above macros as follows:
+ *
+ *   struct foo { spinlock_t lock; ... };
+ *   ...
+ *   #define myfunc(...) __acquire_ret(_myfunc(__VA_ARGS__), &__ret->lock)
+ *   struct foo *_myfunc(int bar) __acquires_ret;
+ *   ...
+ */
+#define __acquires_ret		__no_context_analysis
+#define __acquires_shared_ret	__no_context_analysis
+
 #endif /* _LINUX_COMPILER_CONTEXT_ANALYSIS_H */
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index ba36939fda79..cd557e7653a4 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -621,6 +621,36 @@ config DEBUG_FORCE_WEAK_PER_CPU
 	  To ensure that generic code follows the above rules, this
 	  option forces all percpu variables to be defined as weak.
 
+config WARN_CONTEXT_ANALYSIS
+	bool "Compiler context-analysis warnings"
+	depends on CC_IS_CLANG && CLANG_VERSION >= 220000
+	# Branch profiling re-defines "if", which messes with the compiler's
+	# ability to analyze __cond_acquires(..), resulting in false positives.
+	depends on !TRACE_BRANCH_PROFILING
+	default y
+	help
+	  Context Analysis is a language extension, which enables statically
+	  checking that required contexts are active (or inactive) by acquiring
+	  and releasing user-definable "context locks".
+
+	  Clang's name of the feature is "Thread Safety Analysis". Requires
+	  Clang 22 or later.
+
+	  Produces warnings by default. Select CONFIG_WERROR if you wish to
+	  turn these warnings into errors.
+
+	  For more details, see Documentation/dev-tools/context-analysis.rst.
+
+config WARN_CONTEXT_ANALYSIS_ALL
+	bool "Enable context analysis for all source files"
+	depends on WARN_CONTEXT_ANALYSIS
+	depends on EXPERT && !COMPILE_TEST
+	help
+	  Enable tree-wide context analysis. This is likely to produce a
+	  large number of false positives - enable at your own risk.
+
+	  If unsure, say N.
+
 endmenu # "Compiler options"
 
 menu "Generic Kernel Debugging Instruments"
diff --git a/scripts/Makefile.context-analysis b/scripts/Makefile.context-analysis
new file mode 100644
index 000000000000..70549f7fae1a
--- /dev/null
+++ b/scripts/Makefile.context-analysis
@@ -0,0 +1,7 @@
+# SPDX-License-Identifier: GPL-2.0
+
+context-analysis-cflags := -DWARN_CONTEXT_ANALYSIS		\
+	-fexperimental-late-parse-attributes -Wthread-safety	\
+	-Wthread-safety-pointer -Wthread-safety-beta
+
+export CFLAGS_CONTEXT_ANALYSIS := $(context-analysis-cflags)
diff --git a/scripts/Makefile.lib b/scripts/Makefile.lib
index 28a1c08e3b22..e429d68b8594 100644
--- a/scripts/Makefile.lib
+++ b/scripts/Makefile.lib
@@ -105,6 +105,16 @@ _c_flags += $(if $(patsubst n%,, \
 	-D__KCSAN_INSTRUMENT_BARRIERS__)
 endif
 
+#
+# Enable context analysis flags only where explicitly opted in.
+# (depends on variables CONTEXT_ANALYSIS_obj.o, CONTEXT_ANALYSIS)
+#
+ifeq ($(CONFIG_WARN_CONTEXT_ANALYSIS),y)
+_c_flags += $(if $(patsubst n%,, \
+		$(CONTEXT_ANALYSIS_$(target-stem).o)$(CONTEXT_ANALYSIS)$(if $(is-kernel-object),$(CONFIG_WARN_CONTEXT_ANALYSIS_ALL))), \
+		$(CFLAGS_CONTEXT_ANALYSIS))
+endif
+
 #
 # Enable AutoFDO build flags except some files or directories we don't want to
 # enable (depends on variables AUTOFDO_PROFILE_obj.o and AUTOFDO_PROFILE).
-- 
2.52.0.322.g1dd061c0dc-goog


