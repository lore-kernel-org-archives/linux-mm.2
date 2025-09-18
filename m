Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF3DCA1013
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFE8C8E0128; Thu, 18 Sep 2025 10:06:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB07B8E0112; Thu, 18 Sep 2025 10:06:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977708E0128; Thu, 18 Sep 2025 10:06:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7EC578E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:06:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4860C1DCAA3
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:06:00 +0000 (UTC)
X-FDA: 83902544880.11.CAE0EE1
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B165120004
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:05:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WunLrjQ8;
	spf=pass (imf29.hostedemail.com: domain of 3xBHMaAUKCGUHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3xBHMaAUKCGUHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O/41QdXex1hw7P5cbsCaPm8UfRqOpbfD5EoaOmOtrFc=;
	b=ZGWUQPSqvYNpgrY3injAcH5/WIVlWz6LisHfVCaW3ORlHta5bTeDR6YF+TMdjAKjhYsoBG
	Hy7wKRzgWF0/ANCH9n8rCRivnoQklNi7uaCWkTfgmKbBzoWtEK5GTlPO1hFzw3+nvop5gn
	M+6rV68pbQACiO0OBKVA88c8UFwHtx0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204358; a=rsa-sha256;
	cv=none;
	b=SmQeBrr9J0euZdxG9IyLSyvsbkGOAHaKvU+ZOCFM2g3faBnxVHjfBVDv2LrG+X3/MFwZVT
	XtInS25QeU4oDafqtwB5IIO/bK6BZ8kXiYcwhaGgEfjZU11EitTJgEWWAPK1m0jvsdyO5l
	8MAG+pPOSB4Yfmbtqxg1VXJgJDNLnRg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WunLrjQ8;
	spf=pass (imf29.hostedemail.com: domain of 3xBHMaAUKCGUHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3xBHMaAUKCGUHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-45cb612d362so5697345e9.3
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204357; x=1758809157; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=O/41QdXex1hw7P5cbsCaPm8UfRqOpbfD5EoaOmOtrFc=;
        b=WunLrjQ8hNRDMDS/ocA8mDi14ojC3462LFxrznwEL6RCjDYbPO/nS98wFQIby/4u05
         Ozq3/XbRyy18bqR/geE0WbrZqhjh8Arve0KwNfd8Cv7SlWsDClHF5nvJms+RwSVZ6wTb
         rk2xqFCNz9yxfSdTU4ghGpcmltNkMbquz6c98rqypCLO4/V+p2rHoJ/xRYUF0LtVWDjQ
         ig3LeoffPZ2QTubRFN233OE2/Ms3chDFFpjRTSANJBny1KnDE2QfBp0Mm1W+vjL/aHA6
         p1cJkO43O0avFS8QQ1b7lFyk1umkfsHqx4AlGdSw/qktk50WqkhoI3yoHzsit0Q+tY5o
         JEKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204357; x=1758809157;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O/41QdXex1hw7P5cbsCaPm8UfRqOpbfD5EoaOmOtrFc=;
        b=XR5ioG2uGOYugf68JuNPVQacp2NvFvfmqWpTtSy5gM/gvzJglAdKe8Nofhvs9q4C+e
         09IZp2lVGakisWSwVmzKLYvzngH7xJgBFZwUBIzIo0Oyd3TvqPT6yfP2RBGPMOcW29sN
         7RhbEtDJ3IsGHDLwDrEtttK5lh54Wfu2Y/Rc8kiuXh7OxSeN0wVI9DNq9QiabMtXtbsk
         g2siQq6rYhxiYSUcL6HKkRpgYxZVrP3KN1sEcD0IxgxuI/mUcN2KxLB4EgJDqOkYT+98
         wIow/x2foxjWkxv7iJP3Bvp06kLLmnHX2NDCG6d39vIXiCJbQoHVB0iPXRMKDrY4MoTl
         zs+A==
X-Forwarded-Encrypted: i=1; AJvYcCWUR80OEZwWAYZaq2WcqNO+0E9vWLe2z2dofE+VEg8l369zS19fMJq+lhd+8jj3nSM/5hSnfshr0w==@kvack.org
X-Gm-Message-State: AOJu0YyAnDju98hfDiNVzLSAMn0MeHXI13mWxEQ3QCJFY/xt9B/5BV0C
	T0UKG91QL4EAaMKZQ7R6y04pysqRb1bKi4fEitqIqH//R4EY1Htpjg0J1UCHpp/vQUe+qZ+91nV
	lLg==
X-Google-Smtp-Source: AGHT+IEB/eDmCZXQzzdzX+kSJkfizGem/KoO4BquEG9sVEC1EtYxAyOBGfQfmYUfn+x0uGsDT13+4AgY/Q==
X-Received: from wmlv10.prod.google.com ([2002:a05:600c:214a:b0:45b:9c60:76bb])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3227:b0:45d:f7e4:7a9e
 with SMTP id 5b1f17b1804b1-466ce515027mr10992405e9.5.1758204356910; Thu, 18
 Sep 2025 07:05:56 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:22 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-12-elver@google.com>
Subject: [PATCH v3 11/35] locking/seqlock: Support Clang's capability analysis
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
X-Stat-Signature: tbo4dqpetaqhnpa41xbu3u5kwjoefxsz
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B165120004
X-Rspamd-Server: rspam10
X-HE-Tag: 1758204358-492092
X-HE-Meta: U2FsdGVkX1861Ua67i7X9pIalirjs0kXc0RXtrwYOW0VhbxGd194j2ShfQUpKi1GeKlwaf7W5BNzdjsbPjcpyo2wmHvRjrYQve16bR4ll/rgCpU1lyQbYwK12fFNFSPHvY7fOSeTBJQWdRaXCoNWZLxHho/cYWkjORyFS7xD+ezKuTGnfvAZmB0RBUHbfBmJDmUgUab1Ah6TJIEc3rRaE7hw4eqm8tVcjAxEjmwuIC+gyMairVM3seVakg4hpf6K8plUsz0pFSu5wqt3oOdrQWm5H+Huf0nlzWhPP3gdqey5X4BvwE655SBVYiJaLIfBPmEgsQhEhX+vjsg/TkUIhkY4s9JLly+ygBQXjv359RUSj/Kfy9op4gpmtzKI3HgP2lzImduX24SdZeBpo5KeCvBZRN/nOZ0yoBXu0NC3vv/NXukYcYJnSlze51Rq3egc7lFPxY0xGJBEqsfRpL5fxHmB4LeQBKkq/0Gfw2r+fONMMFTfZO3XMlcvpvVvoXyx5O9NPG2qkrg68deIWJkNNTuxE3Vj49OD3KdTRpCWDopRPcyZULqaw3Hn7GDvZ5k55fCjOAkc/VGm1xsTxUJfPx2d+WyneJouryo2J7oz29i2Ppt2dbZia5R9gM2pM1mIUFBn8yuk/Jpkyd1n3OJZ7n+YlxMFZvGbbB9O4XISo6rdPXp+C/fqUl6l7zYSl4w5HEp33f22rs2ykiXp2zelH8GVMRfGlO1Cc0hgD86o7P8r6zXz8KrA18RVIGkuNU1S7VsKEuxaTNe6yM1GE1i4kaLsK+PIshgpKegMQFsOfHCjf+pzfZ3hZaeWnk17Eff+YUdrX3/iwQWY0Ig65VANNBMr0KrT5KRia97QBkWf0ZXGvDCl61KdRjJbOZMP84/n+T7FMmEZZl9W70U388SMT5Q8h1SC1TP9ElHW88aSb63c8o6JceSJe8tal2Heaf6roXIWl7e3Vxf5U+zwrwx
 L15a5Ujq
 vRwW2Pcb5FH9UCJedbtALUp+1YQV434g/cQm+UFms5o1eoLFoP7GpEHgjIbNeTu0EM7c2/4BSPweAp19KyCoWaHwNISoNZ96wc5jf2LHsHXjSUjlA+LxD//G5fm+vAmkG54wE2AduN6+usmz/RbckmGTHArz4NHIdVP2/bA9/ZXJRJEzo/ur6nOXriDUOK9LPg02jvNmdVi9Z4VSbhhFFCd+Rp2i7pKdDLC/iti71ie5fcj/qz90iRvJ83RW5vgFHUHNGw1HLZ5rPvjEZ3tagsjSTDhYEy8WUYPB+VHG8OwnjptKrf57fvAr/g3vMc6Ga84r04ckIJpEEBDqwmpxoHQV9ID13+6DZrBPUv48mgNxashOs/YzwFw6ToVYgb5guXaeAgYeeYc2yq03xO2fdpecmQTeXy2KesYA6gJsO8WrnCtt2D/JOkeuSSZ8XM6/YcEnEq+AQUo4UvlmR5wQgBONyIOwtQ5YLUdxjPP3BZ5L0LEsI/GtBvpJJs2uV44W9kjy47aWh6gID3appX2I5T818FouCOv9HJvnQNVOTZ7vtH7L7kTgbBzu2dv4Q7+UiwLETP+Vj5bifpHH0elbuNokF8uplipiSPpP9fj7OHtjqQbKJafFK3TWULNZ19tqt0JWPIbX6INgzYK3DeyjRLla4kQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Clang's capability analysis for seqlock_t.

Signed-off-by: Marco Elver <elver@google.com>
---
v3:
* __assert -> __assume rename
---
 .../dev-tools/capability-analysis.rst         |  2 +-
 include/linux/seqlock.h                       | 24 +++++++++++
 include/linux/seqlock_types.h                 |  5 ++-
 lib/test_capability-analysis.c                | 43 +++++++++++++++++++
 4 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/Documentation/dev-tools/capability-analysis.rst b/Documentation/dev-tools/capability-analysis.rst
index 89f9c991f7cf..4789de7b019a 100644
--- a/Documentation/dev-tools/capability-analysis.rst
+++ b/Documentation/dev-tools/capability-analysis.rst
@@ -81,7 +81,7 @@ Supported Kernel Primitives
 ~~~~~~~~~~~~~~~~~~~~~~~~~~~
 
 Currently the following synchronization primitives are supported:
-`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`.
+`raw_spinlock_t`, `spinlock_t`, `rwlock_t`, `mutex`, `seqlock_t`.
 
 For capabilities with an initialization function (e.g., `spin_lock_init()`),
 calling this function on the capability instance before initializing any
diff --git a/include/linux/seqlock.h b/include/linux/seqlock.h
index 5ce48eab7a2a..2c7a02b727de 100644
--- a/include/linux/seqlock.h
+++ b/include/linux/seqlock.h
@@ -816,6 +816,7 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
 	do {								\
 		spin_lock_init(&(sl)->lock);				\
 		seqcount_spinlock_init(&(sl)->seqcount, &(sl)->lock);	\
+		__assume_cap(sl);					\
 	} while (0)
 
 /**
@@ -832,6 +833,7 @@ static __always_inline void write_seqcount_latch_end(seqcount_latch_t *s)
  * Return: count, to be passed to read_seqretry()
  */
 static inline unsigned read_seqbegin(const seqlock_t *sl)
+	__acquires_shared(sl) __no_capability_analysis
 {
 	return read_seqcount_begin(&sl->seqcount);
 }
@@ -848,6 +850,7 @@ static inline unsigned read_seqbegin(const seqlock_t *sl)
  * Return: true if a read section retry is required, else false
  */
 static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
+	__releases_shared(sl) __no_capability_analysis
 {
 	return read_seqcount_retry(&sl->seqcount, start);
 }
@@ -872,6 +875,7 @@ static inline unsigned read_seqretry(const seqlock_t *sl, unsigned start)
  * _irqsave or _bh variants of this function instead.
  */
 static inline void write_seqlock(seqlock_t *sl)
+	__acquires(sl) __no_capability_analysis
 {
 	spin_lock(&sl->lock);
 	do_write_seqcount_begin(&sl->seqcount.seqcount);
@@ -885,6 +889,7 @@ static inline void write_seqlock(seqlock_t *sl)
  * critical section of given seqlock_t.
  */
 static inline void write_sequnlock(seqlock_t *sl)
+	__releases(sl) __no_capability_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock(&sl->lock);
@@ -898,6 +903,7 @@ static inline void write_sequnlock(seqlock_t *sl)
  * other write side sections, can be invoked from softirq contexts.
  */
 static inline void write_seqlock_bh(seqlock_t *sl)
+	__acquires(sl) __no_capability_analysis
 {
 	spin_lock_bh(&sl->lock);
 	do_write_seqcount_begin(&sl->seqcount.seqcount);
@@ -912,6 +918,7 @@ static inline void write_seqlock_bh(seqlock_t *sl)
  * write_seqlock_bh().
  */
 static inline void write_sequnlock_bh(seqlock_t *sl)
+	__releases(sl) __no_capability_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock_bh(&sl->lock);
@@ -925,6 +932,7 @@ static inline void write_sequnlock_bh(seqlock_t *sl)
  * other write sections, can be invoked from hardirq contexts.
  */
 static inline void write_seqlock_irq(seqlock_t *sl)
+	__acquires(sl) __no_capability_analysis
 {
 	spin_lock_irq(&sl->lock);
 	do_write_seqcount_begin(&sl->seqcount.seqcount);
@@ -938,12 +946,14 @@ static inline void write_seqlock_irq(seqlock_t *sl)
  * seqlock_t write side section opened with write_seqlock_irq().
  */
 static inline void write_sequnlock_irq(seqlock_t *sl)
+	__releases(sl) __no_capability_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock_irq(&sl->lock);
 }
 
 static inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
+	__acquires(sl) __no_capability_analysis
 {
 	unsigned long flags;
 
@@ -976,6 +986,7 @@ static inline unsigned long __write_seqlock_irqsave(seqlock_t *sl)
  */
 static inline void
 write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
+	__releases(sl) __no_capability_analysis
 {
 	do_write_seqcount_end(&sl->seqcount.seqcount);
 	spin_unlock_irqrestore(&sl->lock, flags);
@@ -998,6 +1009,7 @@ write_sequnlock_irqrestore(seqlock_t *sl, unsigned long flags)
  * The opened read section must be closed with read_sequnlock_excl().
  */
 static inline void read_seqlock_excl(seqlock_t *sl)
+	__acquires_shared(sl) __no_capability_analysis
 {
 	spin_lock(&sl->lock);
 }
@@ -1007,6 +1019,7 @@ static inline void read_seqlock_excl(seqlock_t *sl)
  * @sl: Pointer to seqlock_t
  */
 static inline void read_sequnlock_excl(seqlock_t *sl)
+	__releases_shared(sl) __no_capability_analysis
 {
 	spin_unlock(&sl->lock);
 }
@@ -1021,6 +1034,7 @@ static inline void read_sequnlock_excl(seqlock_t *sl)
  * from softirq contexts.
  */
 static inline void read_seqlock_excl_bh(seqlock_t *sl)
+	__acquires_shared(sl) __no_capability_analysis
 {
 	spin_lock_bh(&sl->lock);
 }
@@ -1031,6 +1045,7 @@ static inline void read_seqlock_excl_bh(seqlock_t *sl)
  * @sl: Pointer to seqlock_t
  */
 static inline void read_sequnlock_excl_bh(seqlock_t *sl)
+	__releases_shared(sl) __no_capability_analysis
 {
 	spin_unlock_bh(&sl->lock);
 }
@@ -1045,6 +1060,7 @@ static inline void read_sequnlock_excl_bh(seqlock_t *sl)
  * hardirq context.
  */
 static inline void read_seqlock_excl_irq(seqlock_t *sl)
+	__acquires_shared(sl) __no_capability_analysis
 {
 	spin_lock_irq(&sl->lock);
 }
@@ -1055,11 +1071,13 @@ static inline void read_seqlock_excl_irq(seqlock_t *sl)
  * @sl: Pointer to seqlock_t
  */
 static inline void read_sequnlock_excl_irq(seqlock_t *sl)
+	__releases_shared(sl) __no_capability_analysis
 {
 	spin_unlock_irq(&sl->lock);
 }
 
 static inline unsigned long __read_seqlock_excl_irqsave(seqlock_t *sl)
+	__acquires_shared(sl) __no_capability_analysis
 {
 	unsigned long flags;
 
@@ -1089,6 +1107,7 @@ static inline unsigned long __read_seqlock_excl_irqsave(seqlock_t *sl)
  */
 static inline void
 read_sequnlock_excl_irqrestore(seqlock_t *sl, unsigned long flags)
+	__releases_shared(sl) __no_capability_analysis
 {
 	spin_unlock_irqrestore(&sl->lock, flags);
 }
@@ -1125,6 +1144,7 @@ read_sequnlock_excl_irqrestore(seqlock_t *sl, unsigned long flags)
  * parameter of the next read_seqbegin_or_lock() iteration.
  */
 static inline void read_seqbegin_or_lock(seqlock_t *lock, int *seq)
+	__acquires_shared(lock) __no_capability_analysis
 {
 	if (!(*seq & 1))	/* Even */
 		*seq = read_seqbegin(lock);
@@ -1140,6 +1160,7 @@ static inline void read_seqbegin_or_lock(seqlock_t *lock, int *seq)
  * Return: true if a read section retry is required, false otherwise
  */
 static inline int need_seqretry(seqlock_t *lock, int seq)
+	__releases_shared(lock) __no_capability_analysis
 {
 	return !(seq & 1) && read_seqretry(lock, seq);
 }
@@ -1153,6 +1174,7 @@ static inline int need_seqretry(seqlock_t *lock, int seq)
  * with read_seqbegin_or_lock() and validated by need_seqretry().
  */
 static inline void done_seqretry(seqlock_t *lock, int seq)
+	__no_capability_analysis
 {
 	if (seq & 1)
 		read_sequnlock_excl(lock);
@@ -1180,6 +1202,7 @@ static inline void done_seqretry(seqlock_t *lock, int seq)
  */
 static inline unsigned long
 read_seqbegin_or_lock_irqsave(seqlock_t *lock, int *seq)
+	__acquires_shared(lock) __no_capability_analysis
 {
 	unsigned long flags = 0;
 
@@ -1205,6 +1228,7 @@ read_seqbegin_or_lock_irqsave(seqlock_t *lock, int *seq)
  */
 static inline void
 done_seqretry_irqrestore(seqlock_t *lock, int seq, unsigned long flags)
+	__no_capability_analysis
 {
 	if (seq & 1)
 		read_sequnlock_excl_irqrestore(lock, flags);
diff --git a/include/linux/seqlock_types.h b/include/linux/seqlock_types.h
index dfdf43e3fa3d..9775d6f1a234 100644
--- a/include/linux/seqlock_types.h
+++ b/include/linux/seqlock_types.h
@@ -81,13 +81,14 @@ SEQCOUNT_LOCKNAME(mutex,        struct mutex,    true,     mutex)
  *    - Comments on top of seqcount_t
  *    - Documentation/locking/seqlock.rst
  */
-typedef struct {
+struct_with_capability(seqlock) {
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
diff --git a/lib/test_capability-analysis.c b/lib/test_capability-analysis.c
index 286723b47328..74d287740bb8 100644
--- a/lib/test_capability-analysis.c
+++ b/lib/test_capability-analysis.c
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
2.51.0.384.g4c02a37b29-goog


