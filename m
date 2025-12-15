Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 968F3D5B16F
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:22:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0964F6B0008; Mon, 15 Dec 2025 09:22:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06EA76B000A; Mon, 15 Dec 2025 09:22:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77EB6B000C; Mon, 15 Dec 2025 09:22:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D86E06B0008
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:22:02 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 96CC9160224
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:22:02 +0000 (UTC)
X-FDA: 84221919684.04.4C0497D
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf23.hostedemail.com (Postfix) with ESMTP id CC981140007
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:21:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765808520; a=rsa-sha256;
	cv=none;
	b=rU130C0KJ4T4HZjcYJB9YrtZIc19xrwOAZhSWjuwP2eXtAg72NmPK8dIzCpNU0viYie3TC
	S8Zo81t2mw9unxi7fnVozdDqo7lr37fwmNKW5vlKNlu8Vp8mn/NC4IMFVa1iN0tZ/y4VKt
	eoxjuEJVK9Fxn7PrF+RYCa223TWD2h4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of lienze@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=lienze@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765808520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nn03kPk065VPCbtLczbvY0//ODN82FFQXeqpcaztjtA=;
	b=EGxBwtmQk0l9OuSdLRvc3bZHFv0kzd2ARHk0WmEVO5O+RJHBw9hMqMgUZC8Mbv8XHK67iX
	Eg7ysYEbCajXHbUPHQGOU+zyIebN919oxN+jLEign8KqpQp4oGtXxcZ0N2+6wJuW0sPECB
	Qa92u9JYWzFfvUlxgo76gzI8U+oV9KM=
X-UUID: 67006cbcd9c111f0a38c85956e01ac42-20251215
X-CTIC-Tags:
	HR_CC_COUNT, HR_CC_DOMAIN_COUNT, HR_CC_NAME, HR_CC_NO_NAME, HR_CTE_8B
	HR_CTT_MISS, HR_DATE_H, HR_DATE_WKD, HR_DATE_ZONE, HR_FROM_NAME
	HR_SJ_DIGIT_LEN, HR_SJ_LANG, HR_SJ_LEN, HR_SJ_LETTER, HR_SJ_NOR_SYM
	HR_SJ_PHRASE, HR_SJ_PHRASE_LEN, HR_SJ_WS, HR_TO_COUNT, HR_TO_DOMAIN_COUNT
	HR_TO_NO_NAME, IP_UNTRUSTED, SRC_UNTRUSTED, IP_LOWREP, SRC_LOWREP
	DN_TRUSTED, SRC_TRUSTED, SA_TRUSTED, SA_EXISTED, SN_TRUSTED
	SN_EXISTED, SPF_NOPASS, DKIM_NOPASS, DMARC_NOPASS, CIE_GOOD
	CIE_GOOD_SPF, GTI_FG_BS, GTI_RG_INFO, GTI_C_BU, AMN_GOOD
	ABX_MISS_RDNS
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.6,REQID:a159553b-53a4-4e5b-bd6e-11bb762e76f6,IP:10,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:5
X-CID-INFO: VERSION:1.3.6,REQID:a159553b-53a4-4e5b-bd6e-11bb762e76f6,IP:10,URL
	:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
	elease,TS:5
X-CID-META: VersionHash:a9d874c,CLOUDID:3f795d0f366ff774f0650dac6b0e463c,BulkI
	D:251215222154C0FZ39VJ,BulkQuantity:0,Recheck:0,SF:17|19|38|66|78|81|82|10
	2|127|898,TC:nil,Content:0|15|50,EDM:-3,IP:-2,URL:0,File:nil,RT:nil,Bulk:n
	il,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BR
	E:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_FAS,TF_CID_SPAM_FSD
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 67006cbcd9c111f0a38c85956e01ac42-20251215
X-User: lienze@kylinos.cn
Received: from ubuntu.. [(61.48.214.33)] by mailgw.kylinos.cn
	(envelope-from <lienze@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 1269189267; Mon, 15 Dec 2025 22:21:52 +0800
From: Enze Li <lienze@kylinos.cn>
To: sj@kernel.org,
	akpm@linux-foundation.org
Cc: damon@lists.linux.dev,
	linux-mm@kvack.org,
	enze.li@gmx.com,
	Enze Li <lienze@kylinos.cn>
Subject: [PATCH 1/2] mm/damon/core: export necessary symbols
Date: Mon, 15 Dec 2025 22:20:56 +0800
Message-ID: <20251215142057.588500-2-lienze@kylinos.cn>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251215142057.588500-1-lienze@kylinos.cn>
References: <20251215142057.588500-1-lienze@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CC981140007
X-Rspamd-Server: rspam10
X-Stat-Signature: ri174ncoo3fm6zkoxzjobtoohns7et3u
X-HE-Tag: 1765808519-128555
X-HE-Meta: U2FsdGVkX19Ch/0yTMRA5DQcD3x1tIT3s5Ql/A9OR+uQ/CNqTKwT9sisr6XjbK4i4Fh/YF+CR+/g0xDPWESIKZKYtnOrZMpq81FzbqI3+46iL8P9y30Gq67+h+a+H+Y9sBivA4+rdvziG08MtPnTJgftAaza10a+LNh7ApwK05hIqrUATv8lURkjbfL7rAngoyqfbFNhM4jkOcgltyAdEU/KyPnJyW8CRJEwVg1y6QrbvcqPp04Qn3VICXmbKrEBpbZu98hfq63KL46PkSdb1sLUJQdC4fnp9qtIP/UgDcsGpOKh3rcWYn4G+2SGqCzy0IVAivYWOY5gyS0JET8aIIep4nnv4ep7QWurK7cbp4QtrfH+NeRjCq5ogTq7F8NcBNN60x94wVHJo0mSfyaOU5UTGCCLWlf2J1Kj7TS62OkP7STOlO+GuzsvGb8DSEab1hwM016Lus+TaWjgBe86XeSkEVtZJ6hGkbvWhqQ+CoFYDyRvJgmcFDBYOvUI+L1XcIu2SB6ztn4tBbkZ7a0iGAOj2f4djRIu21fcYpIXiES9soU8y8SBtGoLg22SzkSBJeQuuBRunbai3SslB5BU43RfM/T526QR4DohMRYhs8w+4uGwJ3ncZdyzu1pvHAprFAnOPxAVaRTaF0sgLQDDRcXE0PCPaH/OdiHSRuXukPkLcjmaMKEWnNRFVnJFK/1N8UFGzUXZpAbrwjAb20gye6BY1oGULmmpjfMW4bfFuTmnrgoVsWHjrOW0PSsx2TuRyyNBuI3zg+tnyci1B7iO5JXP86h5j7eQSeadltD8lakKh4ltFzl5Rh7O25naidRy4Mal4UeQesv7CXQ4/7Li5rG644xOWoPPg5nCjD1xD9Ew9OE1KRHwWXQ0Bc8MU8eMRo6ikLw2NdSmhBOmZGH75jhc7aAJszkkpNMj5gw/c4VY5pauytaTgR+jptYA10IMMKnAoTLe88Sf2o6RLpw
 Yu4CebQ9
 iUua6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch exports necessary DAMON core symbols to allow building
loadable kernel modules that leverage DAMON's monitoring capabilities
for advanced memory management techniques, such as proactive
reclamation.

The exported functions include those for context creation/destruction,
target and scheme management, and monitoring control.  This enables
external modules to create dedicated DAMON contexts and targets,
operation schemes, and control the monitoring lifecycle without
requiring direct modifications to the core DAMON subsystem.

Signed-off-by: Enze Li <lienze@kylinos.cn>
---
 mm/damon/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f9fc0375890a..b3f6b36a034d 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -108,6 +108,7 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
 	mutex_unlock(&damon_ops_lock);
 	return err;
 }
+EXPORT_SYMBOL_GPL(damon_select_ops);
 
 /*
  * Construct a damon_region struct
@@ -409,6 +410,7 @@ struct damos *damon_new_scheme(struct damos_access_pattern *pattern,
 
 	return scheme;
 }
+EXPORT_SYMBOL_GPL(damon_new_scheme);
 
 static void damos_set_next_apply_sis(struct damos *s, struct damon_ctx *ctx)
 {
@@ -478,11 +480,13 @@ struct damon_target *damon_new_target(void)
 
 	return t;
 }
+EXPORT_SYMBOL_GPL(damon_new_target);
 
 void damon_add_target(struct damon_ctx *ctx, struct damon_target *t)
 {
 	list_add_tail(&t->list, &ctx->adaptive_targets);
 }
+EXPORT_SYMBOL_GPL(damon_add_target);
 
 bool damon_targets_empty(struct damon_ctx *ctx)
 {
@@ -553,6 +557,7 @@ struct damon_ctx *damon_new_ctx(void)
 
 	return ctx;
 }
+EXPORT_SYMBOL_GPL(damon_new_ctx);
 
 static void damon_destroy_targets(struct damon_ctx *ctx)
 {
@@ -573,6 +578,7 @@ void damon_destroy_ctx(struct damon_ctx *ctx)
 
 	kfree(ctx);
 }
+EXPORT_SYMBOL_GPL(damon_destroy_ctx);
 
 static bool damon_attrs_equals(const struct damon_attrs *attrs1,
 		const struct damon_attrs *attrs2)
@@ -763,6 +769,7 @@ void damon_set_schemes(struct damon_ctx *ctx, struct damos **schemes,
 	for (i = 0; i < nr_schemes; i++)
 		damon_add_scheme(ctx, schemes[i]);
 }
+EXPORT_SYMBOL_GPL(damon_set_schemes);
 
 static struct damos_quota_goal *damos_nth_quota_goal(
 		int n, struct damos_quota *q)
@@ -1371,6 +1378,7 @@ int damon_start(struct damon_ctx **ctxs, int nr_ctxs, bool exclusive)
 
 	return err;
 }
+EXPORT_SYMBOL_GPL(damon_start);
 
 /*
  * __damon_stop() - Stops monitoring of a given context.
@@ -1414,6 +1422,7 @@ int damon_stop(struct damon_ctx **ctxs, int nr_ctxs)
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(damon_stop);
 
 /**
  * damon_is_running() - Returns if a given DAMON context is running.
@@ -2924,6 +2933,7 @@ bool damon_initialized(void)
 {
 	return damon_region_cache != NULL;
 }
+EXPORT_SYMBOL_GPL(damon_initialized);
 
 static int __init damon_init(void)
 {
-- 
2.43.0


