Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 316E3CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 14:07:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B6D18E013F; Thu, 18 Sep 2025 10:07:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8909E8E013A; Thu, 18 Sep 2025 10:07:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77DE78E013F; Thu, 18 Sep 2025 10:07:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5BB398E013A
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 10:07:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2C579139C2F
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:07:02 +0000 (UTC)
X-FDA: 83902547484.16.10E72D0
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4AC312000B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 14:07:00 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nxyOvgAk;
	spf=pass (imf13.hostedemail.com: domain of 3AhLMaAUKCKMHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3AhLMaAUKCKMHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758204420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z5tu8oxzXQKTnOUiHAzfcXoFAwF2lpCAIFKrvKZ236c=;
	b=kZ76rec1O1p2KfV0ZTV31dYhQmotaF7sHjGTcj+YIRm9WiFnUHjoLcxbk4ctPi+5vGdGa0
	cstv0rucNLmdMgNogINoSpP4ciPSm882KiWv8sS/Yq5Rw+VommIV0jDBORIZP3WqLq88wv
	GDFXQ9+Kxf+fEWtCZC/iZ+vgfGAc4Ds=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758204420; a=rsa-sha256;
	cv=none;
	b=qtZ+A2VI5WmYZVyT0arBPeKOAhwa8jEKuhvhJ1HmMKnN7HGsPjAPVSF1T9xeIV+aD8nZkU
	BEE2gBMBq5nS6Td4cEvIkO6y1e+KY53r36wGP8Ogy79aEmDVElM1pKHu0K3AvylWiRb7tV
	4c386BU08PYYlOFQpQ3mgGPa4jnVJB4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nxyOvgAk;
	spf=pass (imf13.hostedemail.com: domain of 3AhLMaAUKCKMHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3AhLMaAUKCKMHOYHUJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45dd9a66c3fso3739895e9.1
        for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758204419; x=1758809219; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5tu8oxzXQKTnOUiHAzfcXoFAwF2lpCAIFKrvKZ236c=;
        b=nxyOvgAkIlWnRUSxlH3V6cr/LGPQ3cXR2uEU0u2SrRJlgJWbUorlkJhTPPKpgeuuK1
         Ks/DH7YQL4jzoaRaHtOno2dD49jHDY1GlskNkTxwM64k34PsE3g8oljAzgsI2A0j5H6D
         Pf9eXcIt4BS8Zx1bABNR7ecuyi5Y6CycUiYWHdNU9CdKFG8lDRPg3WLlfVM4p68QkUkj
         Uns/99Vh2Zn/bDYyAcm4st++yKQJqEcvtkdlYwY0gaYfTSZ2XG+B9wG2hhbiWfoj8Cs9
         grhoGVOnbs9X0Ik5ab1+9UeC0ah15y8KxMhtWWV5Gw/uLr702StUwPauETfPP2HP1Yzu
         XNxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758204419; x=1758809219;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z5tu8oxzXQKTnOUiHAzfcXoFAwF2lpCAIFKrvKZ236c=;
        b=p0cGbv808qZm0HY0HGW+jfgLseiPYwoKKjlGIafdsTPpJkAF4/e67JgYtGJFa6Zzxt
         lsDRqPQHvGESZhvxu6+lLaf9HhXMuaUbgsVpDH4nq/kOQ2t4flqVFjHoyrdJEsSwJ92a
         zEDwlQQtudl8appRAFzYlskCseCJRXfVNy7dNVqb4WX2TPXBeJCXh5yZYQdxUo9YowHa
         iHYkrTqM2mQPtgQss+Z0uvZQtMiKL366kqZ6MC8RwokqIYOd3gv/CfQ6sGpDSs2kzp37
         YuGZNq4SspXqWgYg1nSTffRoUeKG5xxFwOVuZiwklZdNPQxEX/XxXYxG63v8GUr/CqER
         R7Hw==
X-Forwarded-Encrypted: i=1; AJvYcCXCxM5oQCfA7meublo3kg2IhrQVm4d6dYhjtJxRXwU8myjYJk+bUc9OVi7tMsGPIzdH4DcfXAcSHA==@kvack.org
X-Gm-Message-State: AOJu0YyY+PZTq+F51a2XHFC5jVAYrMavto5KCv25+EpGc87K86Is8FKR
	Er3SLIICk6NXa5mNMSy9CSm2fPcKyTMbcSL+yGhN5Wm9G7GK2v1C6FdaP0iPlZOpAjzyw5IULMN
	fYA==
X-Google-Smtp-Source: AGHT+IH+umzdQR8EWriNaP0azXypNz5QaBQ31wAEGywI54fdXNfmDlDf3O1KLKu8hdrdKwLm79wsq3wW1g==
X-Received: from wmby18.prod.google.com ([2002:a05:600c:c052:b0:45b:883d:4704])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:c4b8:b0:45b:8477:de1a
 with SMTP id 5b1f17b1804b1-46201f8a98fmr48626095e9.7.1758204418672; Thu, 18
 Sep 2025 07:06:58 -0700 (PDT)
Date: Thu, 18 Sep 2025 15:59:45 +0200
In-Reply-To: <20250918140451.1289454-1-elver@google.com>
Mime-Version: 1.0
References: <20250918140451.1289454-1-elver@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250918140451.1289454-35-elver@google.com>
Subject: [PATCH v3 34/35] crypto: Enable capability analysis
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
X-Stat-Signature: w7dueph3sco75fxattnminftk7ateufn
X-Rspam-User: 
X-Rspamd-Queue-Id: 4AC312000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1758204420-693439
X-HE-Meta: U2FsdGVkX1+yWFNeeQ09AGFCTujquxogX/dCGfoGvWpAXYzAAx5lsODCfhdxar2lXIdETpcNV8qjnEAufgQkcw+ob3LBkvqiPav6VabFKKPb77Pvw1hQ7d6OOWu51thyCRP+hs5okShN9Fxp8Er9w5JpuyX4LogwEw6x7L9zqWsq+E5lV+l6sZH516SBnAnQ6+xs3Ayl/AGalIXEzbn9ZiTtAdkEBM89RDgpeR0dqNPjM3QtgpawrBnVWiAmpXBm0nz2BHjJFV1xJT9OiFkjPYkl73vs3RB1mJnTSA4rXHnLPj/bw9tlvv62lUTW+v+SDnAEeySJcJSdVCRa9KfWhKPHOtvnx/Lh2/DMIaJj/yo8bi6SLhZprh5100pbtXtX7ModusdtW5lSUtxCPIolcbzQopgDfR1znGqeKkprUFxjDBY+V+01RptrrlSg9K97ILpHrXOwBvqf0WpbbMIQhqoYz3zqyMVJlqrkxFYMyGpS7a+fA672AsnQ2Dpvrm+/mM9G5zR3ESUyHRWu7tzaun9GXEeg/OgrkxivqsNB7AVicjU10hZTlJeEV53Yc0EvGolK64bpfRZXA3wo/S/luowX5dC8STFOb3yLpYMoi1bDVl1U+TSaPhIYP/O7dqbg3pS0yf8Jo1h5tg9CPe33X5QAYTLlnFXZbche6YtopvNTndjdOtUx9cGiiV0bn+Bac/6zEJVlZGeAek/yOJGQq6M/MsFdYhrA6tbjxuT5J9FNgsQ7ephVsfZeEvGQGVhE+8d0DK6DKufS//HqUaXh4oapvXjNUeVX/D6Si1gQglJN8A9SJXC0GLosbbLHLHDZQG9aSP8MVC5Y5ffO+jqGi7rNp5uHFyPkC/oT1lqPGmlSi+0tPZil2kXXfdGHWFkDE9kIMnst1VWbHY2tvLyE8W+pmFKonhERHys18++10gifcVFRxsTVaFuhypdIXUz9Fpatm4rd3Wo9a87V/f5
 ymbSz0D6
 +UHFJweEvC8J9C4pGa6siRvTX1R+vA0gp26Jtjk8yfO94RpqDbhl8ae/BkLzEm1rw5calI+spq5DvEa5j54UPdR4i0dLaE9WgcEpIhFupZNEtBJZss0mMsqrFoaKSRbPGAOFvkvrwxA5mgLed3F2qTD8RVpAtX6ZRsZUAykutGratkndGV91C0e1pTRy95PVNvA7d/+mHadTiWQa295bK3jWbVMq84WvcQYY2BhtBm2gkvbZmcYS0I8nCPutXP5/tjys+xYZDs3av6wXh9KeFt2oO6Apk8oo8skdGlxwMHemhjVnyHTsqGJaUYlN8hp1X/DZqbCtqUFHViBZqh/Y0bEnzSjWgOv5077UIXFrVXrgq9bjoDBCGDpEssu5MjpD5Yy1BDLG3CIITMxCSJpBgp+kx1+RkZ5DpwXGqgq4O9aa/UIFxFJ+U2aPCeScg/0ft/Klijzwu8SwBHSow47k8Gg5YrbNkyLVzEuHq69XeWlNj4UMYVbdzjgra3rPjm9qqy+JMm5SAieI5o8o7PLS9w3fQ67C6Ci+oexQOv0+r7oS0NBdUtBAbxn5PnfR1J3/rGyo7SwIz4oV0+soM7kITH3fQa0wRBZQnj4FSw6apraIic1550Hbbc+xeMdc/nh7bJdkuldwlno9/7RkE/qYs1l5ZYiZXMuqhZ61yowv2Hw7kYbZL0Ii0GpKlbItFwYOhDUyrRepnwe75pMbXcUeLwvzFMw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enable capability analysis for crypto subsystem.

This demonstrates a larger conversion to use Clang's capability
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
index 6c5d59369dac..e73c50a54119 100644
--- a/crypto/Makefile
+++ b/crypto/Makefile
@@ -3,6 +3,8 @@
 # Cryptographic API
 #
 
+CAPABILITY_ANALYSIS := y
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
index dbe4c8bb5ceb..9684d952fdfd 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -231,6 +231,7 @@ static inline unsigned short drbg_sec_strength(drbg_flag_t flags)
  */
 static int drbg_fips_continuous_test(struct drbg_state *drbg,
 				     const unsigned char *entropy)
+	__must_hold(&drbg->drbg_mutex)
 {
 	unsigned short entropylen = drbg_sec_strength(drbg->core->flags);
 	int ret = 0;
@@ -1061,6 +1062,7 @@ static inline int __drbg_seed(struct drbg_state *drbg, struct list_head *seed,
 static inline int drbg_get_random_bytes(struct drbg_state *drbg,
 					unsigned char *entropy,
 					unsigned int entropylen)
+	__must_hold(&drbg->drbg_mutex)
 {
 	int ret;
 
@@ -1075,6 +1077,7 @@ static inline int drbg_get_random_bytes(struct drbg_state *drbg,
 }
 
 static int drbg_seed_from_random(struct drbg_state *drbg)
+	__must_hold(&drbg->drbg_mutex)
 {
 	struct drbg_string data;
 	LIST_HEAD(seedlist);
@@ -1132,6 +1135,7 @@ static bool drbg_nopr_reseed_interval_elapsed(struct drbg_state *drbg)
  */
 static int drbg_seed(struct drbg_state *drbg, struct drbg_string *pers,
 		     bool reseed)
+	__must_hold(&drbg->drbg_mutex)
 {
 	int ret;
 	unsigned char entropy[((32 + 16) * 2)];
@@ -1368,6 +1372,7 @@ static inline int drbg_alloc_state(struct drbg_state *drbg)
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
index c651e7f2197a..fb87f3716426 100644
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
+	__capability_unsafe(/* frees @scratch */)
 {
 	struct scomp_scratch *scratch;
 	int i;
@@ -101,7 +102,7 @@ static void scomp_scratch_workfn(struct work_struct *work)
 		struct scomp_scratch *scratch;
 
 		scratch = per_cpu_ptr(&scomp_scratch, cpu);
-		if (scratch->src)
+		if (capability_unsafe(scratch->src))
 			continue;
 		if (scomp_alloc_scratch(scratch, cpu))
 			break;
@@ -111,6 +112,7 @@ static void scomp_scratch_workfn(struct work_struct *work)
 }
 
 static int crypto_scomp_alloc_scratches(void)
+	__capability_unsafe(/* allocates @scratch */)
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
2.51.0.384.g4c02a37b29-goog


