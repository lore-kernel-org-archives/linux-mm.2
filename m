Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4208CF8864
	for <linux-mm@archiver.kernel.org>; Thu, 20 Nov 2025 15:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CEA6B00D9; Thu, 20 Nov 2025 10:14:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00E046B00DC; Thu, 20 Nov 2025 10:14:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E17666B00DD; Thu, 20 Nov 2025 10:14:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C95F16B00D9
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 10:14:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BBC7140190
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:14:18 +0000 (UTC)
X-FDA: 84131331396.01.EBC08B5
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf04.hostedemail.com (Postfix) with ESMTP id A2DEC4001E
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 15:14:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Kj/boAOk";
	spf=pass (imf04.hostedemail.com: domain of 3RzAfaQUKCHQWdnWjYggYdW.Ugedafmp-eecnSUc.gjY@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3RzAfaQUKCHQWdnWjYggYdW.Ugedafmp-eecnSUc.gjY@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763651656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j4pKPAxAMb/xt3eYfYDMHUG0PZ5TfjoAzjHvbIiVoEA=;
	b=s8Z4M7BxEmVviBBvrB0DCYsfJ2RDf+f7eOjlI+QqLFZ83j9OcdRCJSsHYgIRGa4dF1NFT/
	Eu3+f70Pc9Vuojw9EA4MCunBavWUqPWVoWFpD8OQAf/KhFVuRIC5gYMQVnDKT4ne0gWhod
	EN8q8ER4B3q4jcFM8EYhlZq+1G1bdXE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="Kj/boAOk";
	spf=pass (imf04.hostedemail.com: domain of 3RzAfaQUKCHQWdnWjYggYdW.Ugedafmp-eecnSUc.gjY@flex--elver.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3RzAfaQUKCHQWdnWjYggYdW.Ugedafmp-eecnSUc.gjY@flex--elver.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763651656; a=rsa-sha256;
	cv=none;
	b=lFED0HDc0uhRa/dQmGch8dGTmq8U6fmw/xLRwjsLXBzWZxDz21WXMfyUNVSZVSCWbjIJKG
	nULG0uyvPXY1XlqeiEUEB2ak5GTaQeVXejcPSy03TminYr4ltkcWiKAkkOed5oQTSfLaEY
	4x177S4ui/iEuKNXCAHirXOwdR+zops=
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b352355a1so988644f8f.1
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 07:14:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763651655; x=1764256455; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=j4pKPAxAMb/xt3eYfYDMHUG0PZ5TfjoAzjHvbIiVoEA=;
        b=Kj/boAOkSUlriqB8ElKWBRBZWHrxMkoeOYG/oW3wRI5afUEj5bASBDvrPTcuu5XPqf
         iF6nnp/39KdpfzWk0EMQrCIS4yC0Bfjf/ZIJ3IXI7xcfWiumSyof01amGchFHUafN9St
         p1BLhBZR0xY1HxX2jhOPUU8u4yL0oAuxAXabp+NVa/gxvXgTdHgavg5wfpgihFc1+c5i
         4AMw8mFdd6/pKr6LwpCRdeU89BDK0SqnzohympoO86KKr1U51J8WGd/5hnZOqwu5hWow
         et/xeN6vrn3pOafAM4ugcn3rpo/h7BhuWzwRD7whuJTrml2OmTAbbjjc+W12D8i2Eqd5
         YwiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763651655; x=1764256455;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j4pKPAxAMb/xt3eYfYDMHUG0PZ5TfjoAzjHvbIiVoEA=;
        b=CBUvFdnAZhi2DXtuKQRQqft4DqaCVGCuM75MpqKeTRYBtec2kZ0zUP7N/VpvuuHOj3
         T4GUErE2ihMyRsZoPRWW96aibDLb9pEOx5XZiiZyrSKUC8LqA0YPjxjS5kXIh1b3koWq
         kFoFCgu6/RUNtwxS1P0YnS3dHej8VPfKUkB+5XJsC89bTBHVvRLF9xtSeViUvh0PDBFw
         N9ZtFHFGvhb8guGObZo57r7FA2uYy896FEZALHQ+0rhGbwbRuo1rpS/tP1o7PnJRi5xq
         HGuSFKu3pGdALxP6nG00n1I6zl4PbCjYVuP3qwsygLbTCgiJ5jiPRJOxm6bfyQlVY+bB
         f+7g==
X-Forwarded-Encrypted: i=1; AJvYcCUvdktJMAD7KHoqrnOfUEiNu2jPrBNGSvOoi3KVUzdCbU8kmw+ChwNb1N9/Qabn3JzC601VzdXVAg==@kvack.org
X-Gm-Message-State: AOJu0YyGBO9Vi4OrGAi3/riksoDAchEBSbhr2ewa5wSGr8pa38k/Y+KI
	4shZYpklOg56afRrWcQduPn5I/YX4XNRQF39x34Wf8nuIOnZNpKYsmdSAtF6df+3vwYHLBk+i5l
	4vg==
X-Google-Smtp-Source: AGHT+IFqcHBKgR0gW0/Eo/3sCwe08l4FABFq65GtQBUvSXkcpOED/X6M6Z0vvwbHQZfiyYHdho6VSOJOWw==
X-Received: from wrdk8.prod.google.com ([2002:adf:b348:0:b0:42b:30da:e035])
 (user=elver job=prod-delivery.src-stubby-dispatcher) by 2002:adf:e987:0:b0:429:58f:26f
 with SMTP id ffacd0b85a97d-42cba7696b1mr2716676f8f.24.1763651655219; Thu, 20
 Nov 2025 07:14:15 -0800 (PST)
Date: Thu, 20 Nov 2025 16:09:59 +0100
In-Reply-To: <20251120151033.3840508-7-elver@google.com>
Mime-Version: 1.0
References: <20251120145835.3833031-2-elver@google.com> <20251120151033.3840508-7-elver@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251120151033.3840508-35-elver@google.com>
Subject: [PATCH v4 34/35] crypto: Enable context analysis
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A2DEC4001E
X-Stat-Signature: 1f3bfyy1nedq57smqtw9ksf49t57y1gu
X-Rspam-User: 
X-HE-Tag: 1763651656-77685
X-HE-Meta: U2FsdGVkX1+Pt4rSiVCfbSCrbuflQnHKNNUjIzGR6q+8Xu0MoIP9yB7USdINJOw8jom3pgECYhGmN8S8mXsY/czwzCnjWNF4Bzb84ktAu4OO7157ULERDS4zJRYXFTYqoWhqkAx/yELrxhBHanoCQ8uXp7feLgRFb9NUQpJMTNhZ+4EHN+dobbxIN6VJ6CwK4snOO5F8NiED3hBECqIeQfrCh6uhT5k1eGnieUnKJBUTpHbmQt7Fg1B+4GIuFOJVw/4UEbllTc192DvQPJO6FZTVHGJyXDpgGHqnExbI/vHmuQBsJ/KH/ZmmfYQyCg3Zti5utW54UWZmOLuXWaA5nmxXoeFy1t9M+cCRidGeoLTZsG5I6fogiMseM14ctgCHyIuLq4kgwVBzLwdNzFHzp64PTNcEqY1b4jmj7hTAXM/tVCn4BsQWGadvxKI2MtdGcdSJc3C1lZ8CCJD1q4YuzEUfbP4wVSdB02aXW9BwdSWsneX1YiC8n98dz57rDxzHkEj/vtFVYskHhvGRAsvN4xxPgr2u16UDUH5TkMG4mIDxV/Hh2xeNzdN/oIKgp3i3yoLXPUXRBQo/pL5OE+rTivBjNidGkGBlCXCS7CFBTRybisMON/FBGd1vog21ftWwddjmNrAHb1DllrWcQti/jk/QzlXo7qCOpKHmAlWHiZpM8z3gy+WLHAG3jg3PC7dlI0mTG/VwCCyC09w3ZF3OGH6oUB5kMHGu7wIcR/EQgL9/9H0pSptQNnaJxVnbLlLchrgH9LvTqZxLInjRW2Z/zD8dbwcMDm6eIKQJ6uqms1JIwWAGGhRxvhJluAUghEQvdheNMGB/e7niGN8EtQTAxFqsQOHViaqrIAUHONvffIyy1jzv6yngfhDmJTWsUdzYlUcLTzyGv/0v9JNLufrUfgoLMEuKRAXVQHxgV1LFC3ycEfB/xM0jZ7woQWwvveTfO0vkQymYXG+5xDbNlJF
 TMop7IwV
 6eYZ5j3GP8AP5GMnslBJAlTQsq3lFmlTYEhMX7aCUxGYrZnm4aFJt5A/Z31CK9F5Ha07NgyRAWZ37GnygBQGaGInfQo84wu2xMU1YbEdGYbGZZHXwb8GFVlxKbUmzegmY4hpj6iEEcNTs4mxu/GfaqJAEpDqE2GRlTqoPGavaZNfxvntsD2So6g5AVv1NTe7z3/EWrDFCSezR1oCux2buORagN4LHvdod8JIgx1MuOCZ6gIugs09BmL2JLS2MXyW/m0T4nN/RXvmAhITQ0eK3h3FTmd1uTaG9a9SEbVWIBT66qO3d08Cf9fydMYsJvzjHtD5g08kobPc7Gq1FhTLytIQYKzL5jsEYeoTyrIDpo23sJPDPT+MFhe/RM+86ZWWALXMQu/lAf1AWL1HoJB4Zg8Ve5K3N05neZikeSGV0WeEs76awVX6zyfygEdEyEWUkkWt0TxkXtCn79khyRFssHS71ZH43GfKaZzCDCQg0b6GbScHMyTDQJtIzLjVqViMMMT/VP6/+E3PzaixgUMhouIFMzZbATykUnIHZN6xua3DcVkzz392wlazwYWI1Qv8qL5+TouyUGPEGrxgnRd3ldG0TaIQEcs/i1BuOcL6QK16lKJDuzUrhr2yCPlsunEeCn2nsuW7tnwSoAh81a0fohGhhOMVN0GS+bXm6KKBjJ3IUGl20rbmt73Ha+eYaQQZwEUbaLHJUHbQzJzw=
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
index e430e6e99b6a..2e2560310e5a 100644
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
2.52.0.rc1.455.g30608eb744-goog


