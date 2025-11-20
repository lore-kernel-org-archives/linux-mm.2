Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C628CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:12:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 674086B00A0; Thu, 20 Nov 2025 10:12:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6231A6B00AB; Thu, 20 Nov 2025 10:12:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 512686B00AC; Thu, 20 Nov 2025 10:12:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CD8A6B00A0
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:12:21 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 12B4E1DF753
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:21 +0000 (UTC)
X-FDA: 84131326482.16.56DC475
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2776420007
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:12:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uEvgKylF;
	spf=pass (imf03.hostedemail.com: domain of 30S8faQUKCPwipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30S8faQUKCPwipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651539;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hosCU2YAM4wmLhG6gCEf4XqbMRgXsIjIUxIgZVPv95A=;
	b=owXJEREXkkAIj9eFASPR+9bJfy2KNiom6VRWHzD50p84BmG/KYyAlvRItdmaCdnAF9bZyI
	nCeEHNyEWZHEq20qB8k0v95wwYdUHzixA8mE0iamPCDbdFsVFEBrLPct4drbQuyf5c7iyc
	JRBYYEflBooCpHCaPartdOEc5PWiT7w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uEvgKylF;
	spf=pass (imf03.hostedemail.com: domain of 30S8faQUKCPwipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30S8faQUKCPwipzivksskpi.gsqpmry1-qqozego.svk@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651539; a=rsa-sha256;
	cv=none;
	b=iXqqhDNJsdjWp9hoaM/F6MDKJ7FPP7wyqZxuGiMPr1BvZythTQH8GsZhRKghsXFps6bSw3
	g5BjkjcbqLnb4ERMBf6ZbVk1+NUFpRfVM6vPeuHXDvd2X0dsBklLXkO+gHE9T83GMtHj6d
	Oeo26yFgE92TIkQfQCcp7iF3dpGC1SM=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4779b3749a8so8942775e9.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651538; x=1764256338; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hosCU2YAM4wmLhG6gCEf4XqbMRgXsIjIUxIgZVPv95A=;
        b=uEvgKylFDcqHYG83IcjHTahbevT50qSUVzgEm6HvFyBvY1urpYGiKrNH7g7u5AxIP4
         P95Kal1Oy5Hi35w+Tcko6GDn3J37k556+TSIrRDKDo0Er2r8uULGH1+DHNxvyFAuq3Za
         CxjcpRquaOOFtcIncdqE4D//a1QQfSBJ+5juqI6NlpcsH8Ueu04SeYoiqXSMZGLsMLK7
         AbjIhtC+2m2QOeSupfUWjuhDeo7uw0HYQdQJpCv4UvC5M4exnOAHX3nXrPUR5Zljjy5H
         34yOPcpGYmO0uexUoMvdl/3l2MqjajIUVbjKE2dRUW1CnAC4OSSf5R0B7/5LqJdW1p5s
         eOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651538; x=1764256338;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hosCU2YAM4wmLhG6gCEf4XqbMRgXsIjIUxIgZVPv95A=;
        b=UtMkMcsxYtSDiGTH5ssfImAqqLgjSXoG4OIoRvU48Iq11/lbJFD8UgixOayz64L0Hl
         ksU73M/zIghb1NIMDzyiyeTgrfwrA82yTSkr9JnIB+PxzLX9XgUORCnuCW0OKDC8Ycsj
         u9KSxJodbCcZT48ZmXBdZP0hRDAbmr8k7iVFOC4jUKi4GI+Z7h3d31i9ZjngDOYwJ2WF
         JLAk0f4nA9Da4aKvkmL4VX0Aw2RORGa5GmXuzd0P2SXS5Jebo157NNkK7QhnXfZx2j1x
         JS6ZIR+ujums/T0BKwdTeIyAIgtsd7CUuriMyXM25OvYtbRshDAl7RNlKPiR1YSVISu3
         atwA==
X-Forwarded-Encrypted: i=1; AJvYcCWpqvjhIufTh5KLw5a74Au/300q/kiZj3HFs8r+amQjwVW5d6hEkGCLuzhaYMXZpQ+jpXpLxAeyvw==@kvack.org
X-Gm-Message-State: AOJu0YwRtDvxhcAueHKoCTvk8tkoxWiCbNHXgr0bZCnIqRW14b7E7tYd
	cj4+YWTuNrM+E1QGwQ5tMvUzt+GSMyInfp6k3Aqa9IlBeCXvumTI2RQCr8XtMxWzqS8JWjjEgl2
	JSA==
X-Google-Smtp-Source: AGHT+IGqdP+1ULXZ13/bvPdwqw8yuJ8l0jo0RTsoVAwzy0DYBXw9hGmu0iT83h/ma3EfKmKjOC5LfRBvFQ==
X-Received: from wraj7.prod.google.com ([2002:a5d:4527:0:b0:42b:2aa2:e459])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6000:2505:b0:42b:3ed2:c08b
 with SMTP id ffacd0b85a97d-42cbb2b1a6emr2638286f8f.51.1763651537400; Thu, 20
 Nov 2025 07:12:17 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:36 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-12-elver@google.com>
Subject: [PATCH v4 11/35] locking/seqlock: Support Clang's context analysis
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2776420007
X-Stat-Signature: ypk9ceag8jsgrb4kzr6jjza3rj6iu9be
X-Rspam-User: 
X-HE-Tag: 1763651538-377945
X-HE-Meta: U2FsdGVkX18VVuaQ9OrX7Z8ecy07Dd/7MNqUQcD/eIGVlmG48GW6ixG2Pl0sPNRDVlr17ENKbCWB4Qfwz0/z+V/EwlMOF9XYpu04+sJvCHqImrULvWhyuA4dIF5ACWUQX7p+W/vKHWuxK0WgylwujHcj4kcAyW1mlfaSWTibN0ryLIVmlFuMY8zqqI6axfI0DAsLMxpEgCyY9/IeDXOkB1lWaXxplg4G/9p+xJZ7pv/nBuv6pZr5s/8Wvo5jqTSsAb5HBhQlYiA7KnK/Sl1EhiW3pfZnSKVpPfQOuHDNN952ADiO009wahc7Qgpg5qtBPY50j0STUXP6rljYUCkAaacYR7JfwzsobIqwz7lROgpBde7lw3lralBBOPGxiN2nATkpQw9tN9RN56skAwFCDKDsDTeQeweNp1yo1JmcJYrFjVbvsRhQw2lnnKeb+UcmL8yZ9knSYq3PzDfTEgfe4mlBF3iglwJ1/xE444ML/REWOTgMaQMrXW7PVb3wJFrFYp+pbSS3d09GqmfPb6GXVbaYp5Yg7hy2MFu5w+kp2ekfm6szXP08y5i8dCytgArgNeMy39tLCQL55wAmOj6FOZDgggWyan/mYUcCnDHrcFgJXgQp1wz7V9qJJ8jkcdR+xZ0TjqmIYr1xX01PgsbSxkRzRFcPelZ2tKd2exiWJyg0trenYKBkMYWgPEecoo0n9jMlGJkdYUtL01KLRP94dM0jOcaGZQxGMlwKbdDrbwTRDuOjhS6DZCZLClTXkazTCRHvle6lmze62LslOlwLJsgTgORT1aYZfQXYm5mB935vnktOZefmv02HD3szuI0V+xZNa7Sf3SN0lUYlXpaalV+DWfEDNfC/Op75Ad5AMe9YC6xPfvE62vuibnAiq4wLGjuzIj149KA3cOZSKa1Rv2Q/dh9w9ImI3EDedMTNSZoon9LiVU1X1/hnUHNsbk8csLxIisWz5sZcvBP0LJE
 68ASi4az
 t5AUfQ0v89aAA0U5GPazdY58hjJlPGsOhyyrh9v0op74FAYkfBTYOReNmPIqTzHGFtU9onCE3hWLmXHmFbdS/tTuMMFG4RbrSEzCNbFH7MGaPtr2qaS4oo+w1vO1eNkOiZPLVA58IMGA7POLlCebGSNdjisDZbkyO/tiY3r/HKTZZWSjZUOMvnE2JGx3U95KdkMN85p/Q2uA3Aokx97pRnsH5i72TH2f9rRVI5VSIgvJBbAx8x4q6FuT0Nurz1sutKQ2Mr3Yo1AVplpjHd+d2YqCAyEV/Xp6i8dAWW0o0nu86iZwhL/yFCckRrB/3voQ2BW1XBx8vNPLrur3wmnzHsvCcYZ//S2LK6R4+7fvko9r9btqpREnU+nPVxdTI3G+MSAM1Q2XXxmcFn15fR04r/Rl/NoZyHDNGGPoJ3SyMHoQkpxiW1Ew9jB30n7rTJSbZLG3xBsIIByzlG9SE3QeGDot/OEr/sJRfvf1OFPltGO5m6jbte2qpYvxrVkDOkTyx36CdNqpoCDjksS3nWqx1qAGIferddrhcbeJx5mOo6xihQHHggdF4TxkVvKUkBtaqCDPf2zxyYhCPzkX8YKlUJnonT6xj9XBPwDo1MLa2rGgtwEA3SW5Dqe1Jpmc3HyvVuSUIR+H+WR7tL7AlcPfVhL7y887o86avb/RbCKuamp81Zxo0d8kORd28ofU2P2oHCCng
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
v3:
* __assert -> __assume rename
---
 Documentation/dev-tools/context-analysis.rst |  2 +-
 include/linux/seqlock.h                      | 24 +++++++++++
 include/linux/seqlock_types.h                |  5 ++-
 lib/test_context-analysis.c                  | 43 ++++++++++++++++++++
 4 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/Documentation/dev-tools/context-analysis.rst b/Documentation/dev-tools/context-analysis.rst
index 1f5d7c758219..598962f6cb40 100644
--- a/Documentation/dev-tools/context-analysis.rst
+++ b/Documentation/dev-tools/context-analysis.rst
@@ -80,7 +80,7 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`.
 
 For context guards with an initialization function (e.g., `spin_lock_init()`),
 calling this function before initializing any guarded members or globals
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 5ce48eab7a2a..c79210d369ef 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -816,6 +816,7 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
 	do {								\
 		spin_lock_init(&(sl)->lock);				\
 		seqcount_spinlock_init(&(sl)->seqcount, &(sl)->lock);	\
+		__assume_ctx_guard(sl);					\
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
diff --git a/include/linux/seqlock_types.h b/include/linux/seqlock_types.h
index dfdf43e3fa3d..7b195368e654 100644
--- a/include/linux/seqlock_types.h
+++ b/include/linux/seqlock_types.h
@@ -81,13 +81,14 @@ SEQCOUNT_LOCKNAME(mutex,        struct mutex,    true,     mutex)
  *    - Comments on top of seqcount_t
  *    - Documentation/locking/seqlock.rst
  */
-typedef struct {
+context_guard_struct(seqlock) {
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
index 2b28d20c5f51..59c6642c582e 100644
--- a/lib/test_context-analysis.c
+++ b/lib/test_context-analysis.c
@@ -6,6 +6,7 @@
 
 #include <linux/build_bug.h>
 #include <linux/mutex.h>
+#include <linux/seqlock.h>
 #include <linux/spinlock.h>
 
 /*
@@ -208,3 +209,45 @@ static void __used test_mutex_cond_guard(struct test_mutex_data *d)
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
-- 
2.52.0.rc1.455.g30608eb744-goog


