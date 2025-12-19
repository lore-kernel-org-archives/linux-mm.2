Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ABB2D78792
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 15:47:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E09146B00D5; Fri, 19 Dec 2025 10:47:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D98A96B00D7; Fri, 19 Dec 2025 10:47:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE2A6B00D8; Fri, 19 Dec 2025 10:47:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0E0B6B00D5
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 10:47:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7504589525
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:48 +0000 (UTC)
X-FDA: 84236651016.02.C73ABA3
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 96F171A0017
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 15:47:46 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tph0oEcn;
	spf=pass (imf19.hostedemail.com: domain of 3oXNFaQUKCO4UblUhWeeWbU.SecbYdkn-ccalQSa.ehW@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3oXNFaQUKCO4UblUhWeeWbU.SecbYdkn-ccalQSa.ehW@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766159266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZHn8aDcdtAKeJcCs/59KrgcXnzNTM7tjpMFEs44zRkY=;
	b=iRxpGWLWQLMCA7Hdv1n0h62wqWwPrZNaPbEXPYiv4/V4Q1OZSBxpsQibiU+eQbHsHHjwLA
	1rTqmyPdkI9ntmqPeISHRVH5PDBsxEv/pUxFxpgRyUskKuPVdfBfU61CMUangSsaelCM9h
	cjCEnhuhE75T2wdVimgSgC3iE6dpsgA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766159266; a=rsa-sha256;
	cv=none;
	b=3CbKA/4+zWmT8aGOLNRxVe3FMMbHnbBIhRbuWJZqTF2Yh102NNCfdzy71loQCNzX9SwOiG
	N7hVWERd+MmalSOe3CBoknpMTXId+8X5IAOTrL3Y0obNr8Z8uujlnIDG7Qo23ebV1KHTOV
	R/Ja6wU5szmXvFyJ8ZhcVxjmO5eMQnI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=tph0oEcn;
	spf=pass (imf19.hostedemail.com: domain of 3oXNFaQUKCO4UblUhWeeWbU.SecbYdkn-ccalQSa.ehW@flex--elver.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3oXNFaQUKCO4UblUhWeeWbU.SecbYdkn-ccalQSa.ehW@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477bf8c1413so11139225e9.1
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 07:47:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766159265; x=1766764065; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHn8aDcdtAKeJcCs/59KrgcXnzNTM7tjpMFEs44zRkY=;
        b=tph0oEcnzrRNYV7H4j3YhRvq1SX7LyniXXw6RO1Qn/PmI1QPXsYFDih0u98zxdnbOp
         dm/LhVc8shpraXuGEbAC2VFygVXHXzmGXgzTCzHqdeILAf4bDHM6LVpb+1A/ruZ+JQBK
         +j/mlP1A7hV+KP/RgPQRqqWQ4Ken3GkaCN0w5cdqeVZnLU6jPTKHu1fob63ZOFsd2Cya
         6pyA0rGPnoAlEF6bA/xw9yhJaQWSJleIom7rSVNqU6byMgDjBLyt6UnbaKvwWaXn37wB
         BARbFdQqmzyJslky5FEJoHSLFk/BnrPmIikdbVuZGZ67C7fzEMMr6dP3AtSTNr3Pb5dJ
         x1xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766159265; x=1766764065;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHn8aDcdtAKeJcCs/59KrgcXnzNTM7tjpMFEs44zRkY=;
        b=NaWQSqe8OluAKPx2GFawhtp1pOkw/XwSNLn4rdr0tG1YSkY0WvqKHdXNnELb1193l2
         x8nIf5m45x4NdMoj/zX5Rm+QyRvQJRNIPfu7wFJa1Y+h9ndIU+FVuz5zhi6i0dE1hkjA
         iouAVJfUz511Vp5Mdv7v5YoDGcYQ/4V+eJ2Dsc2VMkQvPIP7QVizKTnd52oBCvIbDMn+
         f8utmzrn1GZXdhGd7Mmd+oYUvGvSJqADIGIUeeLHQvrCfU5Yp+yrZWQXArYX44nKQjOS
         uK30xpb127HAm8cU9f/JUdp3Qresa57LGZCS1Dy7+DvpG+fp+rGINMRmOo0hbFfTbCEG
         bIdw==
X-Forwarded-Encrypted: i=1; AJvYcCXe3cXHs9sPunhYzW6YEiyhzyoYGFvx61JQfeUX/SidSt0eQiYbOvxWMKMTiFf/Pw+tp2akwtCXBg==@kvack.org
X-Gm-Message-State: AOJu0YzSmxg/V1I1Ply4rb28J0jV/UeWWtpzHU+eehgVodgNGkx92J48
	Kbk+ChaYkB4fSGEd1ClIafk7pvaCwupZalB9Tan3sQY4UCI4jdDlI5tQKtyxXKFspzgWh4vynt9
	EPA==
X-Google-Smtp-Source: AGHT+IGHpp21+mCBycweEqT8Ht6B+jtSAoz0ySY2DWy+4u2Qiurrqu+3+OezAzO/55ihn/7y3obtbqs2RA==
X-Received: from wmgp3.prod.google.com ([2002:a05:600c:2043:b0:477:98de:d8aa])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3b8d:b0:477:7725:c16a
 with SMTP id 5b1f17b1804b1-47d1953da58mr36604365e9.10.1766159265020; Fri, 19
 Dec 2025 07:47:45 -0800 (PST)
Date: Fri, 19 Dec 2025 16:40:24 +0100
In-Reply-To: <20251219154418.3592607-1-elver@google.com>
Mime-Version: 1.0
References: <20251219154418.3592607-1-elver@google.com>
X-Mailer: git-send-email 2.52.0.322.g1dd061c0dc-goog
Message-ID: <20251219154418.3592607-36-elver@google.com>
Subject: [PATCH v5 35/36] crypto: Enable context analysis
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
X-Stat-Signature: 9up3ha3f4tnjijzjf3achrudkkhg64q5
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96F171A0017
X-Rspam-User: 
X-HE-Tag: 1766159266-607393
X-HE-Meta: U2FsdGVkX1/DX0/oXRu+RUodBa42jadzBY1dqQzQdEfQcC4GwxSIaHMEpG4AABNGWZHaiTonyNHYqqvcAoz/jZrdp3r6XUQQ/LQDjtEAUkdJ/6s0Y+4kEIzAfTzzPOkaO8vL4Cy2JLrlddtTjc22fp955Fqa22kA6km5SHWhfRhlk7ENx9TLhv+nFo8IThBazYnhbnjKVRQ7Q/1mYjEGGg+LizyB5GIvC+MlWIXwed9v14Dblhh8X+04Bf2SVO+3xvD5pQ4dig6OZw7yU/LpxnsXV+ivw6CuJMQI61eAjsUCXgMHSwyizqOh5VUJBx87YGKgaFbYOxpxUKi46wtnfR3zsvAqemTaPDBJja0EqMaIYnHjgXG8JGSBu6KMPkpHwdb1eYZd+JmkoXCMPXcUP79qblPN7eOj4TLdi6FXlPmE1mup/qskpoOWPWEaT9Lge4rMW1PTGzZOQUzrtl/HmbunziPey8polmFRE2hwVup3krH2Xh5y7QZ376/1XV4hiko/41zD0LyQfGhLpCieB1mVFIzmO64LsGfOAMHh59T/IGofrLI2zi7JkcC7+EtEIdWj7jtlXtL7MtKvo+LM9oEG53VxxtOzCbVcV0Um9zb8x3HK/WUKVvqPbfuLO+jYXNzyiDMtK3wfWsL4BDCrsYq6Emng04f405xKj2ACKIgb8bGeDNzyPr0sDWW/clGItbI9Ry5bOcT3AKbldxIbnkas5disYQTXsBnUNFZ4mSRjfBnIHYDrUCXcdFwD47o0KTIJr/ptwJkiTgYDboJQ+RzpCiWBI1zcw5MeMjKmIiLxTU9uvjc/8cNjZIatl4hj86AR/MkuRvxZORS+pYaxX3adadxYTuA4010pLeXO8TBWwwW56V4Tb03IFU9ylyUUo4uPDsr/Rlnly5xZwoyE//VNGuP5mKo5jjtpO0AG/Ot9Eyh7pMkbNMiQoopNSHElLrCX0vqF3iAOi4rEE6H
 32oZJ1og
 1SL044GuLTEHWUw0AdPZfMtm6JrXS8Zd8nEyxLXb4CS6JUKmL1FAcq0w8XXDXDwSzKhzZl7y1JL76hsj95q++85ccKaX271RhhLabAnrwlwGt4mRaqXapMYzkCvVl3rF5JSGnxkDXWTKS8uf5KMX2SxNICHULmNVZ4Fg4QFk1TACX+YFRU2OWg1fWe85K2k1amguHwd3mzbBdXyvkVC9TCNpQHTbAW1FNmtgCe75w+KQIa4Z98FmCDbotSTyPI7mq0t3QEvM+XKv8XEWhBYbhxPZPS/rsP5Vq7JTNcTm2fAuWeF6M8xIIE8yia9AOREaQC/KXavfDdPk9B2uJETQjg949+N8VmOjZyG0nr/i7ec+f0S88wdX1+raS9GTLyPDWlDAIghGJxbubTQuVwUz5va/1ZnI29YXb3/8u7YRrjN0xwXaInfkyZ5/UEfuU4Qp6827NHXLubk2JHoh+CUH9UOS8eKlEa/+7Tj7aYmhGrZkEk/gXvlnOZeojsooMpXbwf0GNzoKuKHxCjTxLiJYDC3FyBzIhNTBqYZrpXOgdBnBKUAXFnczyPq4BwaHYeL7bisJe2r5oDndzWL7ndhsf4SpnnrFbn5PYlOkinz5d8CQVSgO00k1yIoFB/AXna3y+tpan4PA7RXIVtV7eBcIOsQe40jW94QEp1+pHPKfHpv+m+eMdQTBERQOqmYO8R0xmVK/OlHAIYs+tQ0hUQvjU7N/fhQEAb3wXzvdMwksVuOBs1ykrXGIBxWzUSrI3zriwprLtgrJA7/fz5bigwk1nFg2h9JEF9GN7DLr9kUaPWAsLb+QIkocIpClgAMANipXTiBs3lhj04OytWT8+BqfABaOAxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable context analysis for crypto subsystem.

This demonstrates a larger conversion to use Clang's context
analysis. The benefit is additional static checking of locking rules,
along with better documentation.

Note the use of the __acquire_ret macro how to define an API where a
function returns a pointer to an object (struct scomp_scratch) with a
lock held. Additionally, the analysis only resolves aliases where the
analysis unambiguously sees that a variable was not reassigned after
initialization, requiring minor code changes.

Signed-off-by: Marco Elver <elver@google.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: linux-crypto@vger.kernel.org
---
v4:
* Rename capability -> context analysis.

v3:
* Rebase - make use of __acquire_ret macro for new functions.
* Initialize variables once where we want the analysis to recognize aliases.

v2:
* New patch.
---
 crypto/Makefile                     |  2 ++
 crypto/acompress.c                  |  6 +++---
 crypto/algapi.c                     |  2 ++
 crypto/api.c                        |  1 +
 crypto/crypto_engine.c              |  2 +-
 crypto/drbg.c                       |  5 +++++
 crypto/internal.h                   |  2 +-
 crypto/proc.c                       |  3 +++
 crypto/scompress.c                  | 24 ++++++++++++------------
 include/crypto/internal/acompress.h |  7 ++++---
 include/crypto/internal/engine.h    |  2 +-
 11 files changed, 35 insertions(+), 21 deletions(-)

diff --git a/crypto/Makefile b/crypto/Makefile
index 16a35649dd91..db264feab7e7 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -3,6 +3,8 @@
 # Cryptographic API
 #
 
+CONTEXT_ANALYSIS := y
+
 obj-$(CONFIG_CRYPTO) += crypto.o
 crypto-y := api.o cipher.o
 
diff --git a/crypto/acompress.c b/crypto/acompress.c
index be28cbfd22e3..25df368df098 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -449,8 +449,8 @@ int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s)
 }
 EXPORT_SYMBOL_GPL(crypto_acomp_alloc_streams);
 
-struct crypto_acomp_stream *crypto_acomp_lock_stream_bh(
-	struct crypto_acomp_streams *s) __acquires(stream)
+struct crypto_acomp_stream *_crypto_acomp_lock_stream_bh(
+	struct crypto_acomp_streams *s)
 {
 	struct crypto_acomp_stream __percpu *streams = s->streams;
 	int cpu = raw_smp_processor_id();
@@ -469,7 +469,7 @@ struct crypto_acomp_stream *crypto_acomp_lock_stream_bh(
 	spin_lock(&ps->lock);
 	return ps;
 }
-EXPORT_SYMBOL_GPL(crypto_acomp_lock_stream_bh);
+EXPORT_SYMBOL_GPL(_crypto_acomp_lock_stream_bh);
 
 void acomp_walk_done_src(struct acomp_walk *walk, int used)
 {
diff --git a/crypto/algapi.c b/crypto/algapi.c
index e604d0d8b7b4..abc9333327d4 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -244,6 +244,7 @@ EXPORT_SYMBOL_GPL(crypto_remove_spawns);
 
 static void crypto_alg_finish_registration(struct crypto_alg *alg,
 					   struct list_head *algs_to_put)
+	__must_hold(&crypto_alg_sem)
 {
 	struct crypto_alg *q;
 
@@ -299,6 +300,7 @@ static struct crypto_larval *crypto_alloc_test_larval(struct crypto_alg *alg)
 
 static struct crypto_larval *
 __crypto_register_alg(struct crypto_alg *alg, struct list_head *algs_to_put)
+	__must_hold(&crypto_alg_sem)
 {
 	struct crypto_alg *q;
 	struct crypto_larval *larval;
diff --git a/crypto/api.c b/crypto/api.c
index 5724d62e9d07..05629644a688 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -57,6 +57,7 @@ EXPORT_SYMBOL_GPL(crypto_mod_put);
 
 static struct crypto_alg *__crypto_alg_lookup(const char *name, u32 type,
 					      u32 mask)
+	__must_hold_shared(&crypto_alg_sem)
 {
 	struct crypto_alg *q, *alg = NULL;
 	int best = -2;
diff --git a/crypto/crypto_engine.c b/crypto/crypto_engine.c
index 18e1689efe12..1653a4bf5b31 100644
--- a/crypto/crypto_engine.c
+++ b/crypto/crypto_engine.c
@@ -453,8 +453,8 @@ struct crypto_engine *crypto_engine_alloc_init_and_set(struct device *dev,
 	snprintf(engine->name, sizeof(engine->name),
 		 "%s-engine", dev_name(dev));
 
-	crypto_init_queue(&engine->queue, qlen);
 	spin_lock_init(&engine->queue_lock);
+	crypto_init_queue(&engine->queue, qlen);
 
 	engine->kworker = kthread_run_worker(0, "%s", engine->name);
 	if (IS_ERR(engine->kworker)) {
diff --git a/crypto/drbg.c b/crypto/drbg.c
index 1d433dae9955..0a6f6c05a78f 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -232,6 +232,7 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
  */
 static int drbg_fips_continuous_test(struct drbg_state *drbg,
 				     const unsigned char *entropy)
+	__must_hold(&drbg->drbg_mutex)
 {
 	unsigned short entropylen = drbg_sec_strength(drbg->core->flags);
 	int ret = 0;
@@ -848,6 +849,7 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 static inline int drbg_get_random_bytes(struct drbg_state *drbg,
 					unsigned char *entropy,
 					unsigned int entropylen)
+	__must_hold(&drbg->drbg_mutex)
 {
 	int ret;
 
@@ -862,6 +864,7 @@ static inline int drbg_get_random_bytes(struct drbg_state *drbg,
 }
 
 static int drbg_seed_from_random(struct drbg_state *drbg)
+	__must_hold(&drbg->drbg_mutex)
 {
 	struct drbg_string data;
 	LIST_HEAD(seedlist);
@@ -919,6 +922,7 @@ static bool drbg_nopr_reseed_interval_elapsed(struct drbg_state *drbg)
  */
 static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		     bool reseed)
+	__must_hold(&drbg->drbg_mutex)
 {
 	int ret;
 	unsigned char entropy[((32 + 16) * 2)];
@@ -1153,6 +1157,7 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
 static int drbg_generate(struct drbg_state *drbg,
 			 unsigned char *buf, unsigned int buflen,
 			 struct drbg_string *addtl)
+	__must_hold(&drbg->drbg_mutex)
 {
 	int len = 0;
 	LIST_HEAD(addtllist);
diff --git a/crypto/internal.h b/crypto/internal.h
index b9afd68767c1..8fbe0226d48e 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -61,8 +61,8 @@ enum {
 /* Maximum number of (rtattr) parameters for each template. */
 #define CRYPTO_MAX_ATTRS 32
 
-extern struct list_head crypto_alg_list;
 extern struct rw_semaphore crypto_alg_sem;
+extern struct list_head crypto_alg_list __guarded_by(&crypto_alg_sem);
 extern struct blocking_notifier_head crypto_chain;
 
 int alg_test(const char *driver, const char *alg, u32 type, u32 mask);
diff --git a/crypto/proc.c b/crypto/proc.c
index 82f15b967e85..5fb9fe86d023 100644
--- a/crypto/proc.c
+++ b/crypto/proc.c
@@ -19,17 +19,20 @@
 #include "internal.h"
 
 static void *c_start(struct seq_file *m, loff_t *pos)
+	__acquires_shared(&crypto_alg_sem)
 {
 	down_read(&crypto_alg_sem);
 	return seq_list_start(&crypto_alg_list, *pos);
 }
 
 static void *c_next(struct seq_file *m, void *p, loff_t *pos)
+	__must_hold_shared(&crypto_alg_sem)
 {
 	return seq_list_next(p, &crypto_alg_list, pos);
 }
 
 static void c_stop(struct seq_file *m, void *p)
+	__releases_shared(&crypto_alg_sem)
 {
 	up_read(&crypto_alg_sem);
 }
diff --git a/crypto/scompress.c b/crypto/scompress.c
index 1a7ed8ae65b0..7aee1d50e148 100644
--- a/crypto/scompress.c
+++ b/crypto/scompress.c
@@ -28,8 +28,8 @@
 struct scomp_scratch {
 	spinlock_t	lock;
 	union {
-		void	*src;
-		unsigned long saddr;
+		void	*src __guarded_by(&lock);
+		unsigned long saddr __guarded_by(&lock);
 	};
 };
 
@@ -38,8 +38,8 @@ static DEFINE_PER_CPU(struct scomp_scratch, scomp_scratch) = {
 };
 
 static const struct crypto_type crypto_scomp_type;
-static int scomp_scratch_users;
 static DEFINE_MUTEX(scomp_lock);
+static int scomp_scratch_users __guarded_by(&scomp_lock);
 
 static cpumask_t scomp_scratch_want;
 static void scomp_scratch_workfn(struct work_struct *work);
@@ -67,6 +67,7 @@ static void crypto_scomp_show(struct seq_file *m, struct crypto_alg *alg)
 }
 
 static void crypto_scomp_free_scratches(void)
+	__context_unsafe(/* frees @scratch */)
 {
 	struct scomp_scratch *scratch;
 	int i;
@@ -101,7 +102,7 @@ static void scomp_scratch_workfn(struct work_struct *work)
 		struct scomp_scratch *scratch;
 
 		scratch = per_cpu_ptr(&scomp_scratch, cpu);
-		if (scratch->src)
+		if (context_unsafe(scratch->src))
 			continue;
 		if (scomp_alloc_scratch(scratch, cpu))
 			break;
@@ -111,6 +112,7 @@ static void scomp_scratch_workfn(struct work_struct *work)
 }
 
 static int crypto_scomp_alloc_scratches(void)
+	__context_unsafe(/* allocates @scratch */)
 {
 	unsigned int i = cpumask_first(cpu_possible_mask);
 	struct scomp_scratch *scratch;
@@ -139,7 +141,8 @@ static int crypto_scomp_init_tfm(struct crypto_tfm *tfm)
 	return ret;
 }
 
-static struct scomp_scratch *scomp_lock_scratch(void) __acquires(scratch)
+#define scomp_lock_scratch(...) __acquire_ret(_scomp_lock_scratch(__VA_ARGS__), &__ret->lock)
+static struct scomp_scratch *_scomp_lock_scratch(void) __acquires_ret
 {
 	int cpu = raw_smp_processor_id();
 	struct scomp_scratch *scratch;
@@ -159,7 +162,7 @@ static struct scomp_scratch *scomp_lock_scratch(void) __acquires(scratch)
 }
 
 static inline void scomp_unlock_scratch(struct scomp_scratch *scratch)
-	__releases(scratch)
+	__releases(&scratch->lock)
 {
 	spin_unlock(&scratch->lock);
 }
@@ -171,8 +174,6 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 	bool src_isvirt = acomp_request_src_isvirt(req);
 	bool dst_isvirt = acomp_request_dst_isvirt(req);
 	struct crypto_scomp *scomp = *tfm_ctx;
-	struct crypto_acomp_stream *stream;
-	struct scomp_scratch *scratch;
 	unsigned int slen = req->slen;
 	unsigned int dlen = req->dlen;
 	struct page *spage, *dpage;
@@ -232,13 +233,12 @@ static int scomp_acomp_comp_decomp(struct acomp_req *req, int dir)
 		} while (0);
 	}
 
-	stream = crypto_acomp_lock_stream_bh(&crypto_scomp_alg(scomp)->streams);
+	struct crypto_acomp_stream *stream = crypto_acomp_lock_stream_bh(&crypto_scomp_alg(scomp)->streams);
 
 	if (!src_isvirt && !src) {
-		const u8 *src;
+		struct scomp_scratch *scratch = scomp_lock_scratch();
+		const u8 *src = scratch->src;
 
-		scratch = scomp_lock_scratch();
-		src = scratch->src;
 		memcpy_from_sglist(scratch->src, req->src, 0, slen);
 
 		if (dir)
diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
index 2d97440028ff..9a3f28baa804 100644
--- a/include/crypto/internal/acompress.h
+++ b/include/crypto/internal/acompress.h
@@ -191,11 +191,12 @@ static inline bool crypto_acomp_req_virt(struct crypto_acomp *tfm)
 void crypto_acomp_free_streams(struct crypto_acomp_streams *s);
 int crypto_acomp_alloc_streams(struct crypto_acomp_streams *s);
 
-struct crypto_acomp_stream *crypto_acomp_lock_stream_bh(
-	struct crypto_acomp_streams *s) __acquires(stream);
+#define crypto_acomp_lock_stream_bh(...) __acquire_ret(_crypto_acomp_lock_stream_bh(__VA_ARGS__), &__ret->lock);
+struct crypto_acomp_stream *_crypto_acomp_lock_stream_bh(
+		struct crypto_acomp_streams *s) __acquires_ret;
 
 static inline void crypto_acomp_unlock_stream_bh(
-	struct crypto_acomp_stream *stream) __releases(stream)
+	struct crypto_acomp_stream *stream) __releases(&stream->lock)
 {
 	spin_unlock_bh(&stream->lock);
 }
diff --git a/include/crypto/internal/engine.h b/include/crypto/internal/engine.h
index f19ef376833f..6a1d27880615 100644
--- a/include/crypto/internal/engine.h
+++ b/include/crypto/internal/engine.h
@@ -45,7 +45,7 @@ struct crypto_engine {
 
 	struct list_head	list;
 	spinlock_t		queue_lock;
-	struct crypto_queue	queue;
+	struct crypto_queue	queue __guarded_by(&queue_lock);
 	struct device		*dev;
 
 	struct kthread_worker           *kworker;
-- 
2.52.0.322.g1dd061c0dc-goog


