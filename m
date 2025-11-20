Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B019CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:13:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45F66B00C3; Thu, 20 Nov 2025 10:13:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D3E6B00C5; Thu, 20 Nov 2025 10:13:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90CAE6B00C6; Thu, 20 Nov 2025 10:13:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DDC46B00C3
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:13:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 596A71A0165
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:25 +0000 (UTC)
X-FDA: 84131329170.11.D2927F5
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 483FF100002
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:13:22 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zqrJAs48;
	spf=pass (imf05.hostedemail.com: domain of 3CzAfaQUKCDgYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3CzAfaQUKCDgYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FM+v7kmKwxv6mQJTQvhb3JUsaW+ES8Jzb95oMtr52Zo=;
	b=DKSjRp62kYEYX6U64aS+NFBVM1x7sdREWZdeLWb/yjfh3bPyf9dH1sdli8RwKuS6ZM/Luk
	nRSDK3V8DCsd3o4jM68r876LmiipnRS0IaZkCdZian8fKP7PtvRoDqYS7H9TNbvinSa+91
	stnWS/smbjJH478Qdu6GOmbp3c8HyAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651603; a=rsa-sha256;
	cv=none;
	b=vfnx9NSqFke8SYO/EUtuu6YXnoO2BeqmKAzWCIrxh0OfW0HVrAEG+I6nfNo11JGm2la5II
	slDUUeMNaOZoATXf9mmY7CgHj3cgyhUZ+wA5LGuj8wdt8e+PZetrweTXqJGZ6mo0Q0HlAp
	R2FN4Ooe2+wczCEDU/yHzDnXO6jt6e8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zqrJAs48;
	spf=pass (imf05.hostedemail.com: domain of 3CzAfaQUKCDgYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3CzAfaQUKCDgYfpYlaiiafY.Wigfchor-ggepUWe.ila@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so8954275e9.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:13:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651601; x=1764256401; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=FM+v7kmKwxv6mQJTQvhb3JUsaW+ES8Jzb95oMtr52Zo=;
        b=zqrJAs48Z1lW0spSCgzfwIzABAT1Mwc0j/Z45cYnGkBYE3F6FIYoq9OLe7RgKLS4Ux
         w/F+3CyQ0jrAQ3zAvgFXoF1dtXbbAqBa1QFi8nGCqcB8zU4uvAbw/O/GpKVvDKu+7esB
         4OariVqDowNXECbfuMR4x2YKSNhOASseHhomDv25kJDtydVMqBVSowySkuAQha5LpgtY
         T8/boVvJEuiBCwJLAn0cR+9+42z88utdvY91juO2ch2SC1zU1KwYXxoYUii0xFzQeLSd
         F7NqFcdYAq9J5VYo/1Kvy7iBrmDFpjv8q9qzIH4hghpggz8k+eYhld4Y4Paq6j/Y/tzj
         PUJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651602; x=1764256402;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FM+v7kmKwxv6mQJTQvhb3JUsaW+ES8Jzb95oMtr52Zo=;
        b=OrzbdAgkBGRUSmIhbkckzOdy5HYVm5fL0U3cx7L3AjY14Q+SnNHIWL3O8UR+NrwgyQ
         vJZcQh4ybKgn2ew9/kwGK56OE3xD9nof8mH9lfsxTKDCQKb+EncRbwNUXo4m1qO3Tj0C
         ZjkhbnI3NVwkmo8epvTu+wa69jIlIINKNlpYg3teBlUZdQYFmjCLECOZdcngGx3YDVMH
         JKcwFF8VCYSejNoZlKedjiRBxTrMTJI1GhTiroaEdPAgMv6vZxmATFDsdQW1fU1VO9aB
         cLj1MtLAW98YFFPuN7kI+AbWwWUDbtFD/TCMZ7Z9k1Lfxjr9ZtmXxkutbDiOacRylzDz
         BzKw==
X-Forwarded-Encrypted: i=1; AJvYcCUv6UbVGYmdjntyouFX+1BD4rM+rjLq+H2N9ZhTCI3L5S5o2zDp29k3WCsSwLazXdiVoRSF5LG23A==@kvack.org
X-Gm-Message-State: AOJu0Yyl62f14G6DFKSNpPm/9Qp0bXsh/FVkz9ofPhMmD52+I73MT5IN
	/JYOu3uc2kRhAvocs0Hz/Q7DQEXZ32X08o6aDLNJe7gl87aXvznh8rAOAEkmVAAVPOyyujGdmET
	EiQ==
X-Google-Smtp-Source: AGHT+IFa8gcAYDmSbcN98uTmCv7ow2f9WIs4txwLFz3cf4q2hwFdJRSgsIcTcuSjJZmiASAfOgD6nIwlVA==
X-Received: from wmgi8.prod.google.com ([2002:a05:600c:2d88:b0:475:d94e:4d5d])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:458e:b0:46e:396b:f5ae
 with SMTP id 5b1f17b1804b1-477bac0cfb5mr29573045e9.16.1763651595671; Thu, 20
 Nov 2025 07:13:15 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:47 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-23-elver@google.com>
Subject: [PATCH v4 22/35] compiler-context-analysis: Remove Sparse support
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
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 483FF100002
X-Stat-Signature: y6bagrtygh1a1sc73a9z9i1h77g18bhe
X-HE-Tag: 1763651602-245152
X-HE-Meta: U2FsdGVkX194Tv7PK86GiNpUMHRFnLDcz+V2NQ/N12Wk2Nx3nj0FOAjJcnPGRJM2jbc61oVF+VZhB+qlElBOT9iDVptrxDn24W0vKlcjBX0y77O6QNSrTh/6DrJ7epACooqRUPalKDDwIQI1y4P0Dl9WJAYG0hHoJocHhtz+dtGuaKec6kNu4nAblZxgmgght78Rit1mSjIu9biCxYgnISkSH0jbS/goomXqoAr3O/OzsVgCfUtexDwjTSsqq+kuGnGwJnXviMMKtD4tVISJ/oQDEaLF/DEGkw8Xk3r122wm3lA34vNOthhUKqNrBrIugutJPga0cqKZjQ/94bbcWfjLkdHHP0uHbrMP9/Lu8XOVlw6KznzkCJ0c3XpB7DTUBlVOPPpObElyia3spLiBBER1EKU5N8tHOOWiBLvnI3P9Z8raDOSmpdMgPRN2sDtGijmbuHwtg55hMGOzV8Nt44eACBPWzpfSB5Ki9Yx7UqzBvkW96Bz2DF3Ph9b21+q5f+xSRmxVXs9mLaQzkiQye4s0jAu+AbsUDQPWxl/+XfmjbcySNcncYCPKjLOiSPOxlRNrrOu2ke/FgagSfx22o4kWJB5hgopQlZH3Bl7eMmWOzQGIUxVQNLj1qP2E88XRyqfCis/bWUaOvAsRLdnEu/tTgrKyPolO0pmYPb1ML7PHFRZGSXPhZ+IvrVcE+o2xgXg+7DUT4IqnVB4eAlm8ZX5XJLBCATGYl1eIpElX9uBK7w18zIGirWfxSV8mSrS1LTT3OnVe51cBvGQqiryLBAx1Lv0PN3/HcE0QuuqP23DVtIgCOmbTKHR12xtFgX02lcG1kHo48FKuCEP6UI8A8vzfSFJ8rLhaT3b/cBviZzP4dFWkSG11ZbXQ89cs8vBEtPX35Ayj8fiq81HuKIgME66YuQdq777JbXYSLiUtBZBkCX0XhPl/8VjeCFIB2V7dpnPSLvGL6g/2SJy/j9V
 yuM09cNQ
 BoHViJMV4ZIhCtxMygXIDAoeRhjejVk8V7mOtY4nlZ+Qbffn79BbBrUHAZDMA7qVBqiblniSUn/XlLwhJbTkMp1S5ikioIInDj14+JdkZB6/nk1pUFu6hm2J2ogFZ8WnLY4CwZ9GPp1O1BamooMxWqFBJmWuIyC+lT8nthF8Tocm//3meOTrTGrs+UrB+CoAuRL6weeQSM+jYEmrUzBBIyPVmfhQlWAoEzCHs2rwjdOTq1437jRoXNdP1PRo8luS2Qf/yLoq7Up9ysy6v5Evwj9IsNp0oZo7tqaBPI6XtiIhVo5NtOpWKv7EqDYAHJb02fRy58K6MoMOU3fvTmc1smw6b4rglA8SR99bBSn2WyrxMVaKfTW9jWBgXYf/OP2qLwfIbe2/7QO0RXYjHZerzZNWx7Oktw259E2ntdo8ljqmONoprD6BOVU8BEZ1A2vxvbL3jLqncQL3YZH30E0BsBr3NYwKYirv9mj43q2DHuZ043GvzOcnsXm454PsCGl2xS0/QssSIdh2xOwg35g4bKRN+TKStrYXjnOfW65+hZVGxsQK9hGdWv3SS1EvfJW0nw70+XJZLjS+gdSNOuhPj9iNchP+qtwsN5eobnUu05IIgllJx0Ev691Vb03xa1U0TcTm2iT0mp9rpZ1LNYKGvEIVPJaf/DEc+g6mxBrfC8kkxxX4sPwQhHu/d0gBGjTeiyUfLvu0rXzKrgbdst+NXIRJcSJgErDmhxy7FA7wSWvujVFvc+Lqm5cBOFjnG6rxFUn8tBE9yQ7JQMpywv1t+i9BBvZAWJ5tNecyKv+gFEx9NL0UKeuuE9wS4+HrTpWaDhJoCptzguVZISkac2PqB+Hv8cZuP4EvxemXRmxo8r4bSYEk+Te1Wf91B/rUdulAv+UC7Zasxvx4FCRPRL7tejckb85V0Egv8xQk/ZEwfiK9l96g=
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
index 935e59089d75..6990cab7a4a9 100644
--- a/include/linux/compiler-context-analysis.h
+++ b/include/linux/compiler-context-analysis.h
@@ -250,57 +250,32 @@ static inline void _context_unsafe_alias(void **p) { }
 	extern const struct __ctx_guard_##ctx *name
 
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
  * __must_hold() - function attribute, caller must hold exclusive context guard
- * @x: context guard instance pointer
  *
  * Function attribute declaring that the caller must hold the given context
- * guard instance @x exclusively.
+ * guard instance(s) exclusively.
  */
-# define __must_hold(x)		__requires_ctx_guard(x)
+#define __must_hold(...)	__requires_ctx_guard(__VA_ARGS__)
 
 /**
  * __must_not_hold() - function attribute, caller must not hold context guard
- * @x: context guard instance pointer
  *
  * Function attribute declaring that the caller must not hold the given context
- * guard instance @x.
+ * guard instance(s).
  */
-# define __must_not_hold(x)	__excludes_ctx_guard(x)
+#define __must_not_hold(...)	__excludes_ctx_guard(__VA_ARGS__)
 
 /**
  * __acquires() - function attribute, function acquires context guard exclusively
- * @x: context guard instance pointer
  *
  * Function attribute declaring that the function acquires the given context
- * guard instance @x exclusively, but does not release it.
+ * guard instance(s) exclusively, but does not release them.
  */
-# define __acquires(x)		__acquires_ctx_guard(x)
+#define __acquires(...)		__acquires_ctx_guard(__VA_ARGS__)
 
 /*
  * Clang's analysis does not care precisely about the value, only that it is
@@ -327,17 +302,16 @@ static inline void _context_unsafe_alias(void **p) { }
  *
  * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
+#define __cond_acquires(ret, x) __cond_acquires_impl_##ret(x)
 
 /**
  * __releases() - function attribute, function releases a context guard exclusively
- * @x: context guard instance pointer
  *
  * Function attribute declaring that the function releases the given context
- * guard instance @x exclusively. The associated context must be active on
+ * guard instance(s) exclusively. The associated context(s) must be active on
  * entry.
  */
-# define __releases(x)		__releases_ctx_guard(x)
+#define __releases(...)		__releases_ctx_guard(__VA_ARGS__)
 
 /**
  * __acquire() - function to acquire context guard exclusively
@@ -345,7 +319,7 @@ static inline void _context_unsafe_alias(void **p) { }
  *
  * No-op function that acquires the given context guard instance @x exclusively.
  */
-# define __acquire(x)		__acquire_ctx_guard(x)
+#define __acquire(x)		__acquire_ctx_guard(x)
 
 /**
  * __release() - function to release context guard exclusively
@@ -353,7 +327,7 @@ static inline void _context_unsafe_alias(void **p) { }
  *
  * No-op function that releases the given context guard instance @x.
  */
-# define __release(x)		__release_ctx_guard(x)
+#define __release(x)		__release_ctx_guard(x)
 
 /**
  * __cond_lock() - function that conditionally acquires a context guard
@@ -371,25 +345,23 @@ static inline void _context_unsafe_alias(void **p) { }
  *
  *	#define spin_trylock(l) __cond_lock(&lock, _spin_trylock(&lock))
  */
-# define __cond_lock(x, c)	__try_acquire_ctx_guard(x, c)
+#define __cond_lock(x, c)	__try_acquire_ctx_guard(x, c)
 
 /**
  * __must_hold_shared() - function attribute, caller must hold shared context guard
- * @x: context guard instance pointer
  *
  * Function attribute declaring that the caller must hold the given context
- * guard instance @x with shared access.
+ * guard instance(s) with shared access.
  */
-# define __must_hold_shared(x)	__requires_shared_ctx_guard(x)
+#define __must_hold_shared(...)	__requires_shared_ctx_guard(__VA_ARGS__)
 
 /**
  * __acquires_shared() - function attribute, function acquires context guard shared
- * @x: context guard instance pointer
  *
  * Function attribute declaring that the function acquires the given
- * context guard instance @x with shared access, but does not release it.
+ * context guard instance(s) with shared access, but does not release them.
  */
-# define __acquires_shared(x)	__acquires_shared_ctx_guard(x)
+#define __acquires_shared(...)	__acquires_shared_ctx_guard(__VA_ARGS__)
 
 /**
  * __cond_acquires_shared() - function attribute, function conditionally
@@ -398,23 +370,22 @@ static inline void _context_unsafe_alias(void **p) { }
  * @x: context guard instance pointer
  *
  * Function attribute declaring that the function conditionally acquires the
- * given context guard instance @x with shared access, but does not release it. The
- * function return value @ret denotes when the context guard is acquired.
+ * given context guard instance @x with shared access, but does not release it.
+ * The function return value @ret denotes when the context guard is acquired.
  *
  * @ret may be one of: true, false, nonzero, 0, nonnull, NULL.
  */
-# define __cond_acquires_shared(ret, x) __cond_acquires_impl_##ret(x, _shared)
+#define __cond_acquires_shared(ret, x) __cond_acquires_impl_##ret(x, _shared)
 
 /**
  * __releases_shared() - function attribute, function releases a
  *                       context guard shared
- * @x: context guard instance pointer
  *
  * Function attribute declaring that the function releases the given context
- * guard instance @x with shared access. The associated context must be active
- * on entry.
+ * guard instance(s) with shared access. The associated context(s) must be
+ * active on entry.
  */
-# define __releases_shared(x)	__releases_shared_ctx_guard(x)
+#define __releases_shared(...)	__releases_shared_ctx_guard(__VA_ARGS__)
 
 /**
  * __acquire_shared() - function to acquire context guard shared
@@ -423,7 +394,7 @@ static inline void _context_unsafe_alias(void **p) { }
  * No-op function that acquires the given context guard instance @x with shared
  * access.
  */
-# define __acquire_shared(x)	__acquire_shared_ctx_guard(x)
+#define __acquire_shared(x)	__acquire_shared_ctx_guard(x)
 
 /**
  * __release_shared() - function to release context guard shared
@@ -432,7 +403,7 @@ static inline void _context_unsafe_alias(void **p) { }
  * No-op function that releases the given context guard instance @x with shared
  * access.
  */
-# define __release_shared(x)	__release_shared_ctx_guard(x)
+#define __release_shared(x)	__release_shared_ctx_guard(x)
 
 /**
  * __cond_lock_shared() - function that conditionally acquires a context guard shared
@@ -445,9 +416,7 @@ static inline void _context_unsafe_alias(void **p) { }
  * shared access, if the boolean expression @c is true. The result of @c is the
  * return value.
  */
-# define __cond_lock_shared(x, c) __try_acquire_shared_ctx_guard(x, c)
-
-#endif /* __CHECKER__ */
+#define __cond_lock_shared(x, c) __try_acquire_shared_ctx_guard(x, c)
 
 /**
  * __acquire_ret() - helper to acquire context guard of return value
diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 5cddb9019a99..dd12e738e073 100644
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
2.52.0.rc1.455.g30608eb744-goog


