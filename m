Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5AB4C982C1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 04:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C3E7D6B0093; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2E886B0098; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A42946B0093; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75D846B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 00:05:49 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0D673401FF
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:49 +0000 (UTC)
X-FDA: 85221915618.25.434179B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6B5B640008
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 04:05:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iNZUqJgP;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789617947;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xuBve8B9TeEtlHU83DYclAih0SjxWd5x7DEHnP/pWkE=;
	b=4J9Ohd0Vp4n+ankJEm+35724QaMyOmoKD1zxDlLQHY5yI6FfekqfQ5/sl/9VkzyQquhzuq
	NoZSsb3LuQFMjiBvNR8x+YacFL0YMC3ga6HueI8kGw5qCcY3Q/qigUABMUmzQOdqu24zOS
	3A1brjlYcYx3IPjeY45/G5VVm85NYoc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iNZUqJgP;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789617947;
	b=bsPJ4efQ4YLMzOtW8yOWmji3anRZ271LO4gmLlv+G6n8XJEct2BPnIeCyfbThUlLgmvbUY
	/DrEt71R8xeyneoyTpRan9/nW3B7YUfzALMGiSGAcpnvAbZ2uYOlHp6a8fNiRoUEBdG3QB
	KXPeXoPD8qIcmfq0q6hTFp6ckgtjfmk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCF4A407C6;
	Thu, 17 Sep 2026 04:05:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B3831F0089B;
	Thu, 17 Sep 2026 04:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789617946;
	bh=xuBve8B9TeEtlHU83DYclAih0SjxWd5x7DEHnP/pWkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iNZUqJgPOYgDNx/fChezmCGs2a+uNvx1Ni6wOwUmuP5HWXUOzOo3pFR/zhl3me4A2
	 w8ifdGvr9eE7gjyPh9Hl3tCJ03IUQ8YG72a9xSDvcfYUzbdq2Nxe3/Ekn9JjWrPii7
	 HHC3XJXFzy+EZ30TA5EyQx31wPManYFvk8t/O0sjhVamfESL+/VOAAs+yeuFur5ROe
	 4G7M5v1Qq07QAUJXBnH1BlR054B1AqPC0xf6Jy6i7hlvH7zPE8LRcBIBjGWr/IG/aC
	 MenqKNxe7TuRrfJnln6h0Jx3u05NIZsfnnnLQ1/f4C9V8FNCwNLhqMdo5Xje6kEq1x
	 d7TzwqrwDsueQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 04/10] mm/damon/core: set damon_ctx->walk_control_obsolete in damon_new_ctx()
Date: Wed, 16 Sep 2026 21:05:30 -0700
Message-ID: <20260917040537.107341-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260917040537.107341-1-sj@kernel.org>
References: <20260917040537.107341-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: t1yqugdgucbhsrke7erxci7a17sayuos
X-Rspamd-Queue-Id: 6B5B640008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789617947-611104
X-HE-Meta: U2FsdGVkX19cbU6CtS1tlkGlJfxV5wih/fvR9r16zyu676R8Tm2Elp6FuLrjAXIRp6xabpVX/hODK3PHBlD4rLuh/XCkipAQOfnaFe4/jvAZWAPnksm9c6OSZzK/LkirsjmNKrs7mN/VTEP7VcY/KZbZqFYx+xWekMlM/wL3DrSqb+MgOFMVsSjm26GN6ftuwFTjXN+uWP3aOQt7gWnp71GUjqlLu68JCn7XGb2T4tfslY2wQQglLWCljqIw8//7Lq4D0fW1ZNreJSsoc/zFZEnqB6DyA2XBNBAoE5PIVbeGFexaxkxo1cDp03wGyCBrsE07KvmkTxU14bWi8/7hHJRvhydpgLJycWyg1waAjtPXaXsWVNLBo4+OzcUIPrt1h4Ti+zEWAeGpqn2+zeqDxkFWNPlkw0hjCcw7difeprSk2n7lu084EgYGi/MJfdYzZY6swvfjpaPpwhHgG+sa+vHCGI2bNlLdQ/cVTaVkiZS51ZzZfkkEBrBAAF2YtzFXwlg1z7zbeyhfgOqBqZz3pG0CfjZC16tpha6G5mlKqr8Wn1gZz6B7M6y07JfdElL3Ni4z3IRjZkyjlt0+lCEoOdLS3s3PrBrE7Mkeas1hdLZNA1uu82MRaPtrVC6vbV/XgPnopLnt1vDsauKHsT2S0iFvL6LHqCSVE2sglsGAID/HCE4gLihFecI6zNfFgzLeMCy81xEIPqSveHuOX+hJmLMrVeyIxmgdvSOWGy1qMyHkPhpN3PgDKL+U6ZRxLdzY3fVRk+Cw7vacYZ/3xIl4Gq6oYz2gH/3vIxZA/u5waN//HoOIjmQVTsjLHs9Az0cp+ynZ0S58oYtKnKBrkq5NV80Thsc+V2ri4t5cDDo1pnT7ucYtgpFCgHaTIEybU9yi4el4k7mOY2AQd38HoncnftqFbUDSGHvkdwFui3nTLElcAgs5naSh2xmTrCGhx5G2FyQbkEzy2x6oefXvbGh
 f5p9KqEm
 +PBBYIbIEm5v/eKMiuzIbMFoV8ElJcet9QPTu0TpBSZK5QUqf/uCCOo4H024+xrgcyyKihLWn+LIfpr8MgnxVcgDkMOxm5JxUfm0GpfZOO6DN4So90j8fZam6Dj6SVU5v7G81Z5aCjHZsurv1ZJFeGo24HB5rNzojluMv6yiHgixgHHr9YkNU07EoVBvpoZzcLaIAgjAi+iCdWdbxOPp1e4AWuv6db78QOBDAsVgLhELnjeCny6bTucOrYW/PXMoxnfr8vj3KsBET5Yj3E5KTSshfhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_walk() should be called for a damon_ctx context that has
successfully started at least once.  That's because
damon_ctx->walk_control_obsolete is initialized when kdamond starts.  If
the rule is violated, an indefinite wait can happen.  There is no
existing violation of the rule.

damon_call() had a similar rule, and it turned out keeping the rule is
not easy for damon_call()'s case.  Hence, commit 8023b5f47e09
("mm/damon/core: set ctx->call_controls_obsolete in damon_new_ctx()")
added the initialization in damon_new_ctx() and removed the rule.

Keeping the rule for damos_walk() is relatively easier.  But having
slightly different rules for similar functions could be confusing.
Sashiko, for example, repeatedly asked questions about this.  Do the
initialization of walk_control_obsolete in damon_new_ctx() for
consistency.

[1] https://lore.kernel.org/20260915011614.102342-1-sj@kernel.org

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7bbbd44379301..9120a1b707b24 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -939,6 +939,7 @@ struct damon_ctx *damon_new_ctx(void)
 	INIT_LIST_HEAD(&ctx->schemes);
 
 	ctx->call_controls_obsolete = true;
+	ctx->walk_control_obsolete = true;
 	prandom_seed_state(&ctx->rnd_state, get_random_u64());
 
 	return ctx;
@@ -2308,10 +2309,6 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control)
  * passed at least one &damos->apply_interval_us, kdamond marks the request as
  * completed so that damos_walk() can wakeup and return.
  *
- * Note that this function should be called only after damon_start() with the
- * @ctx has succeeded.  Otherwise, this function could fall into an indefinite
- * wait.
- *
  * Return: 0 on success, negative error code otherwise.
  */
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control)
-- 
2.47.3

