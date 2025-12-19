Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE72CD7878F
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:46:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 532A46B00A2; Fri, 19 Dec 2025 10:46:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 514186B00A3; Fri, 19 Dec 2025 10:46:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C7E56B00A4; Fri, 19 Dec 2025 10:46:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 24A2F6B00A2
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:46:13 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E41341A0299
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:12 +0000 (UTC)
X-FDA: 84236646984.08.31C67FE
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf20.hostedemail.com (Postfix) with ESMTP id 09D701C0020
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:46:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="TMwB/eqV";
	spf=pass (imf20.hostedemail.com: domain of 3QXNFaQUKCI4w3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3QXNFaQUKCI4w3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=amWxerODEEoCfIoX62derQiE7p5loIvVLHROm1A4vmY=;
	b=LS7eq3QHLX39qG4MDi9C/x/nexjdhBRGktZMA1NycOM/2yj32MT+LyLIgvKqHiRt/lBa9F
	OvJLHd52CG2jUQhRqrjATccpz4Cr3b3iFutWkuaav46wyAiKkwkv9yMub3uNsOTmfYLnIP
	xRwoYqbg95lTO5zYlPYK1xhDMaxXBh4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="TMwB/eqV";
	spf=pass (imf20.hostedemail.com: domain of 3QXNFaQUKCI4w3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3QXNFaQUKCI4w3Dw9y66y3w.u64305CF-442Dsu2.69y@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159171; a=rsa-sha256;
	cv=none;
	b=Xs+iBB/zVVeB1dM8MNw9vHnQp+CUimCAezZMsikurwGbtX2V3syEzh+p2XIAZxGece4dKv
	2ViEcXmeGvaeH8djLQ2VNzcNZ9/CKXyFW9D9kgE+Nqjx3bKQk3J4uimeA+faD5M/PFUEVx
	rX60ZtMj21XFr0O4sDWyfQY9xOXmvcA=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4788112ec09so18333635e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159169; x=1766763969; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=amWxerODEEoCfIoX62derQiE7p5loIvVLHROm1A4vmY=;
        b=TMwB/eqVqsvsJHs+Rv94tF7b9fVRpfmVqRFjhsj8ES6CANkWVACmQXs3KC1uGgYvoi
         j0qErslWfftp5ylxnuZlL7j261AkcpiKfCfiesBYSSRrZ4lolkIGbzwrZpYCEsRiW/Q5
         Z4/l2AHscSKqQO3qQEP8oOBh/8C6O9y5UPC4ZiLwSeoFLgI3/Mh+xhvVjIy8UeIpGIfE
         Vlu4Kj6z5jCTqmL9hYGLMwO3V0rbbtqaWg7mBTPS5v/GPImQWp+a/RhQZ+hAi6E5LcDL
         gdc1DKDqlEW1GH+py2wAPgeBhRuDGUjvKL3zoVw1Oh9QAJo42IiN+6j1mcXewaWOh3Oq
         mfkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159169; x=1766763969;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=amWxerODEEoCfIoX62derQiE7p5loIvVLHROm1A4vmY=;
        b=Ho1MhEL/g7VFW6Uyhwp2/t9aSeSZVDbOyjn9qZXCCr/ZX7D8rc+AVKfrw3J9QaW/wB
         YbktdLDOcbugsJ0ah9GLHLF3dpUhwrnPc+gYO6JzJphPaAMbdmny6BdBSVK6NFMuxuJ6
         MrKOYqUL3NOjSTK4FFCgVWTvASiXMeMseTI8C2MZayKGy+5PxzMGvboHOcuksCKG9LsR
         LnWwpewihF76zivgLXdRYRkOLX3+vbHVEHzzVZsM5CGkfnEJF94dYS1L5VC0BSSyZ0tY
         CdqjC/t5NkZXgiJC2QpoYXs5xfMAQ0KTNZaOvhDKGvQD56RV+lq5ouSRBfywhb1c46gt
         FnOw==
X-Forwarded-Encrypted: i=1; AJvYcCVViSmvOyaiuPOTBk9WbYzEo/dfI9YWl6UcACGQpqVa61v+C0bn7Cyl4G7HqhoherHKGxwvyJPnxw==@kvack.org
X-Gm-Message-State: AOJu0YzqFxU7ZMykRhH8w3SxlzEVX6jlJOC4Zm0iD5/mtG1lUYwORiPX
	t797yyOGqvmNxnvYmiYuyPqPeelsFP1RVwWEILOg7LJ3vEy54f/MlV7RbgmKrG7c/V+bZz+q6sv
	nYw==
X-Google-Smtp-Source: AGHT+IGYa74Y5SSaoBaAP3H9tDi+ZVIm7cF2G8HvVxQcU2hfofUC6ryo9mvwVtRKE9bg0y9aXAy14nnKZQ==
X-Received: from wmot12.prod.google.com ([2002:a05:600c:450c:b0:46f:b153:bfb7])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b2a:b0:477:7ab8:aba
 with SMTP id 5b1f17b1804b1-47d1953bd8bmr31823715e9.1.1766159169275; Fri, 19
 Dec 2025 07:46:09 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:00 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-12-elver@google.com>
Subject: [PATCH v5 11/36] locking/seqlock: Support Clang's context analysis
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 09D701C0020
X-Stat-Signature: 3bhh5anxpae8bw3z61xmezyf9phsqxsa
X-HE-Tag: 1766159170-372761
X-HE-Meta: U2FsdGVkX19SYfSkuAICQilzAgMwmaCSYMqq2iZnN7sFlq/PE/sO0WYZyY4e2DcEjwnFGsLPVh+GgWWQcEwU/D77wR2C6FdikzEh8g+mqyPiX5uJhyeIrNvK1cUEaiEaSIkYovFz/bhbXUvZpLvK+t23JvYl6bRhqJ7Y4RR73aX70GSPIo2YhnneAEuG56wE6sht5tV6ujR8fA5067IRMDbY8OSocbVm0gRzgfZEpiQZ/wGa9Ik1TZKKfcgTd2KsD0xNrUO3uEdro5FDfMss5ivrebyKry4mR0jrSexIpub0B0rqdN2NUcppIltYy0N67AaTAjrjC8DOGUppnaFXQWnT9puDegslOFc3DWourQFiGF2x1RuJzMR4Ocb/pK2Lp2HCMnmgyM+wqvUu9ZkA2p2OIcJoxyU7HfpvEN3bQfMnNldBToBAbWdEHwHsbCbVhaEIFSD/UxIXG7GJL5FnwY4Jhej30/BEA+XGO5NNYUkfur+yXCYXTMU+y2VjshY8x1+VmEOmc7RSVe0gUTMIW9be4QDJV4KpP13m2hLM1UqjbGADsbtHVIOfnfCj3aErvNCFF9h0FZQoU2U/c6pymKZHx1AwHkMY4byO8rsAL9r3tcCZnxA95uksr/mLeho6EXdKPiZaJyezBbKy8QaM6to2Gj7SvZ5lfEsFSyAVw9qfeofVDJwOXJBcjpT1xf3CXzoQ0e+a8qGy6ZLMLMADpiMZ9ohpzpdPAnfJg2i3IR5aoASI+zmm14kqK0cIoMFQMx3EJoynm5fLHkPwuR2mHT+Xk3WapA6gwDygpDvvvPhAegXJEQw6JvbX6R/X9mMydKSRyKjZwmZlS4Oo3Ks5Oq3YktjP/jdOizOqmBIYDo2fwt0hafusxcfnw6LacquF6vnnbS0OT0763cUgOI+MKcnoxktJ7rgMu0KaDCq2duVloRzidPLcxREb+/4xz0mD07mtvGWxtIpQUShS6Jt
 nVnPQ0Di
 8ctk/Ybc/3SP4/pz85g/uuGyZpDmTfs58AWd+CMu9IaE7xWVgLVpT0LVJrExvyib37x8vqM4t2x3wQFYt2vXwenFlYShTy5lk/Xop9qYDbSPFeHJOiOFBCi7Q6N/faRzKy3XPnV4b3rn/Yx0DUzch2drCDb3n17uoED19Nt5d/GLvdEKESYunPcLVTVAmM/WrS3DKEYAx74SFEub4lq+xXHcSuLHQ/z18lUdBZI4EP9tsz6qNd0u0ARy1kdQAAXbvAmAlHQ1EqEztOxRS8Sl1qS68+ZyP+AnWuqBmlhcAVCW0JqRkpjQOZa8nWDy0VV3zm/akWEEVZxyjc+Y6S/jI8Dd+q0zkaHob5+qvBaO9QiqZpUySRczmuNghcKnghrZsbVmwnxBNuchzWm+BjfdEBp2vPospt0bvQI3DHRE3ExpUcqhnIxfMYq1+lnqzuLmjxAVUhA/kQrDr8dBOQ7sb9s/MggpOl6/KINdcyRA4otqDLMciGhy6fvILSnjSILvFSniCMY/gRl6runTxOsMSuFiNweapNDGa7qt2HEOt7ElCcYRzycP2bfZdSrkUKnS8hL7w9291+dq5D+AOFYDGgtCGJ+BLnjzq42YNrjDy9A25mfYqoSAQAOfFG6SOC4gbCQ+u4YE1CA8pxigoPz0pPecg46iyteZH0D/QJoNwL8m7pkAOX857UXGBE6JvWYiTFjK5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's context analysis for seqlock_t.

Signed-off-by: Marco Elver <elver@google.com>
---
v5:
* Support scoped_seqlock_read().
* Rename "context guard" -> "context lock".

v3:
* __assert -> __assume rename
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/seqlock.h                      | 38 ++++++++++++++-
 include/linux/seqlock_types.h                |  5 +-
 lib/test_context-analysis.c                  | 50 ++++++++++++++++++++
 4 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index 1864b6cba4d1..690565910084 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -79,7 +79,7 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`.
 
 For context locks with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 221123660e71..113320911a09 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -816,6 +816,7 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
 	do {								\
 		spin_lock_init(&(sl)->lock);				\
 		seqcount_spinlock_init(&(sl)->seqcount, &(sl)->lock);	\
+		__assume_ctx_lock(sl);					\
 	} while (0)
 
 /**
@@ -832,6 +833,7 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
  * Return: count, to be passed to read_seqretry()
  */
 static inline unsigned read_seqbegin(const seqlock_t *sl)
+	__acquires_shared(sl) __no_context_analysis
 {
 	return read_seqcount_begin(&sl->seqcount);
 }
@@ -848,6 +850,7 @@ static inline unsigned read_seqbegin(const seqlock_t *sl)
  * Return: true if a read section retry is required, else false
  */
 static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
+	__releases_shared(sl) __no_context_analysis
 {
 	return read_seqcount_retry(&sl->seqcount, start);
 }
@@ -872,6 +875,7 @@ static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
  * _irqsave or _bh variants of this function instead.
  */
 static inline void write_seqlock(seqlock_t *sl)
+	__acquires(sl) __no_context_analysis
 {
 	spin_lock(&sl->lock);
 	do_write_seqcount_begin(&sl->seqcount.seqcount);
@@ -885,6 +889,7 @@ static inline void write_seqlock(seqlock_t *sl)
  * critical section of given seqlock_t.
  */
 static inline void write_sequnlock(seqlock_t *sl)
+	__releases(sl) __no_context_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock(&sl->lock);
@@ -898,6 +903,7 @@ static inline void write_sequnlock(seqlock_t *sl)
  * other write side sections, can be invoked from softirq contexts.
  */
 static inline void write_seqlock_bh(seqlock_t *sl)
+	__acquires(sl) __no_context_analysis
 {
 	spin_lock_bh(&sl->lock);
 	do_write_seqcount_begin(&sl->seqcount.seqcount);
@@ -912,6 +918,7 @@ static inline void write_seqlock_bh(seqlock_t *sl)
  * write_seqlock_bh().
  */
 static inline void write_sequnlock_bh(seqlock_t *sl)
+	__releases(sl) __no_context_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock_bh(&sl->lock);
@@ -925,6 +932,7 @@ static inline void write_sequnlock_bh(seqlock_t *sl)
  * other write sections, can be invoked from hardirq contexts.
  */
 static inline void write_seqlock_irq(seqlock_t *sl)
+	__acquires(sl) __no_context_analysis
 {
 	spin_lock_irq(&sl->lock);
 	do_write_seqcount_begin(&sl->seqcount.seqcount);
@@ -938,12 +946,14 @@ static inline void write_seqlock_irq(seqlock_t *sl)
  * seqlock_t write side section opened with write_seqlock_irq().
  */
 static inline void write_sequnlock_irq(seqlock_t *sl)
+	__releases(sl) __no_context_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock_irq(&sl->lock);
 }
 
 static inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
+	__acquires(sl) __no_context_analysis
 {
 	unsigned long flags;
 
@@ -976,6 +986,7 @@ static inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
  */
 static inline void
 write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
+	__releases(sl) __no_context_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock_irqrestore(&sl->lock, flags);
@@ -998,6 +1009,7 @@ write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
  * The opened read section must be closed with read_sequnlock_excl().
  */
 static inline void read_seqlock_excl(seqlock_t *sl)
+	__acquires_shared(sl) __no_context_analysis
 {
 	spin_lock(&sl->lock);
 }
@@ -1007,6 +1019,7 @@ static inline void read_seqlock_excl(seqlock_t *sl)
  * @sl: Pointer to seqlock_t
  */
 static inline void read_sequnlock_excl(seqlock_t *sl)
+	__releases_shared(sl) __no_context_analysis
 {
 	spin_unlock(&sl->lock);
 }
@@ -1021,6 +1034,7 @@ static inline void read_sequnlock_excl(seqlock_t *sl)
  * from softirq contexts.
  */
 static inline void read_seqlock_excl_bh(seqlock_t *sl)
+	__acquires_shared(sl) __no_context_analysis
 {
 	spin_lock_bh(&sl->lock);
 }
@@ -1031,6 +1045,7 @@ static inline void read_seqlock_excl_bh(seqlock_t *sl)
  * @sl: Pointer to seqlock_t
  */
 static inline void read_sequnlock_excl_bh(seqlock_t *sl)
+	__releases_shared(sl) __no_context_analysis
 {
 	spin_unlock_bh(&sl->lock);
 }
@@ -1045,6 +1060,7 @@ static inline void read_sequnlock_excl_bh(seqlock_t *sl)
  * hardirq context.
  */
 static inline void read_seqlock_excl_irq(seqlock_t *sl)
+	__acquires_shared(sl) __no_context_analysis
 {
 	spin_lock_irq(&sl->lock);
 }
@@ -1055,11 +1071,13 @@ static inline void read_seqlock_excl_irq(seqlock_t *sl)
  * @sl: Pointer to seqlock_t
  */
 static inline void read_sequnlock_excl_irq(seqlock_t *sl)
+	__releases_shared(sl) __no_context_analysis
 {
 	spin_unlock_irq(&sl->lock);
 }
 
 static inline unsigned long __read_seqlock_excl_irqsave(seqlock_t *sl)
+	__acquires_shared(sl) __no_context_analysis
 {
 	unsigned long flags;
 
@@ -1089,6 +1107,7 @@ static inline unsigned long __read_seqlock_excl_irqsave(seqlock_t *sl)
  */
 static inline void
 read_sequnlock_excl_irqrestore(seqlock_t *sl, unsigned long flags)
+	__releases_shared(sl) __no_context_analysis
 {
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
@@ -1125,6 +1144,7 @@ read_sequnlock_excl_irqrestore(seqlock_t *sl, unsigned long flags)
  * parameter of the next read_seqbegin_or_lock() iteration.
  */
 static inline void read_seqbegin_or_lock(seqlock_t *lock, int *seq)
+	__acquires_shared(lock) __no_context_analysis
 {
 	if (!(*seq & 1))	/* Even */
 		*seq = read_seqbegin(lock);
@@ -1140,6 +1160,7 @@ static inline void read_seqbegin_or_lock(seqlock_t *lock, int *seq)
  * Return: true if a read section retry is required, false otherwise
  */
 static inline int need_seqretry(seqlock_t *lock, int seq)
+	__releases_shared(lock) __no_context_analysis
 {
 	return !(seq & 1) && read_seqretry(lock, seq);
 }
@@ -1153,6 +1174,7 @@ static inline int need_seqretry(seqlock_t *lock, int seq)
  * with read_seqbegin_or_lock() and validated by need_seqretry().
  */
 static inline void done_seqretry(seqlock_t *lock, int seq)
+	__no_context_analysis
 {
 	if (seq & 1)
 		read_sequnlock_excl(lock);
@@ -1180,6 +1202,7 @@ static inline void done_seqretry(seqlock_t *lock, int seq)
  */
 static inline unsigned long
 read_seqbegin_or_lock_irqsave(seqlock_t *lock, int *seq)
+	__acquires_shared(lock) __no_context_analysis
 {
 	unsigned long flags = 0;
 
@@ -1205,6 +1228,7 @@ read_seqbegin_or_lock_irqsave(seqlock_t *lock, int *seq)
  */
 static inline void
 done_seqretry_irqrestore(seqlock_t *lock, int seq, unsigned long flags)
+	__no_context_analysis
 {
 	if (seq & 1)
 		read_sequnlock_excl_irqrestore(lock, flags);
@@ -1225,6 +1249,7 @@ struct ss_tmp {
 };
 
 static __always_inline void __scoped_seqlock_cleanup(struct ss_tmp *sst)
+	__no_context_analysis
 {
 	if (sst->lock)
 		spin_unlock(sst->lock);
@@ -1254,6 +1279,7 @@ extern void __scoped_seqlock_bug(void);
 
 static __always_inline void
 __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
+	__no_context_analysis
 {
 	switch (sst->state) {
 	case ss_done:
@@ -1296,9 +1322,19 @@ __scoped_seqlock_next(struct ss_tmp *sst, seqlock_t *lock, enum ss_state target)
 	}
 }
 
+/*
+ * Context analysis no-op helper to release seqlock at the end of the for-scope;
+ * the alias analysis of the compiler will recognize that the pointer @s is an
+ * alias to @_seqlock passed to read_seqbegin(_seqlock) below.
+ */
+static __always_inline void __scoped_seqlock_cleanup_ctx(struct ss_tmp **s)
+	__releases_shared(*((seqlock_t **)s)) __no_context_analysis {}
+
 #define __scoped_seqlock_read(_seqlock, _target, _s)			\
 	for (struct ss_tmp _s __cleanup(__scoped_seqlock_cleanup) =	\
-	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) };	\
+	     { .state = ss_lockless, .data = read_seqbegin(_seqlock) }, \
+	     *__UNIQUE_ID(ctx) __cleanup(__scoped_seqlock_cleanup_ctx) =\
+		(struct ss_tmp *)_seqlock;				\
 	     _s.state != ss_done;					\
 	     __scoped_seqlock_next(&_s, _seqlock, _target))
 
diff --git a/include/linux/seqlock_types.h b/include/linux/seqlock_types.h
index dfdf43e3fa3d..2d5d793ef660 100644
--- a/include/linux/seqlock_types.h
+++ b/include/linux/seqlock_types.h
@@ -81,13 +81,14 @@ SEQCOUNT_LOCKNAME(mutex,        struct mutex,    true,     mutex)
  *    - Comments on top of seqcount_t
  *    - Documentation/locking/seqlock.rst
  */
-typedef struct {
+context_lock_struct(seqlock) {
 	/*
 	 * Make sure that readers don't starve writers on PREEMPT_RT: use
 	 * seqcount_spinlock_t instead of seqcount_t. Check __SEQ_LOCK().
 	 */
 	seqcount_spinlock_t seqcount;
 	spinlock_t lock;
-} seqlock_t;
+};
+typedef struct seqlock seqlock_t;
 
 #endif /* __LINUX_SEQLOCK_TYPES_H */
diff --git a/lib/test_context-analysis.c b/lib/test_context-analysis.c
index 2b28d20c5f51..53abea0008f2 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -6,6 +6,7 @@
 
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
+#include <linux/seqlock.h>
 #include <linux/spinlock.h>
 
 /*
@@ -208,3 +209,52 @@ static void __used test_mutex_cond_guard(struct test_mutex_data *d)
 		d->counter++;
 	}
 }
+
+struct test_seqlock_data {
+	seqlock_t sl;
+	int counter __guarded_by(&sl);
+};
+
+static void __used test_seqlock_init(struct test_seqlock_data *d)
+{
+	seqlock_init(&d->sl);
+	d->counter = 0;
+}
+
+static void __used test_seqlock_reader(struct test_seqlock_data *d)
+{
+	unsigned int seq;
+
+	do {
+		seq = read_seqbegin(&d->sl);
+		(void)d->counter;
+	} while (read_seqretry(&d->sl, seq));
+}
+
+static void __used test_seqlock_writer(struct test_seqlock_data *d)
+{
+	unsigned long flags;
+
+	write_seqlock(&d->sl);
+	d->counter++;
+	write_sequnlock(&d->sl);
+
+	write_seqlock_irq(&d->sl);
+	d->counter++;
+	write_sequnlock_irq(&d->sl);
+
+	write_seqlock_bh(&d->sl);
+	d->counter++;
+	write_sequnlock_bh(&d->sl);
+
+	write_seqlock_irqsave(&d->sl, flags);
+	d->counter++;
+	write_sequnlock_irqrestore(&d->sl, flags);
+}
+
+static void __used test_seqlock_scoped(struct test_seqlock_data *d)
+{
+	scoped_seqlock_read (&d->sl, ss_lockless) {
+		(void)d->counter;
+	}
+}
-- 
2.52.0.322.g1dd061c0dc-goog


