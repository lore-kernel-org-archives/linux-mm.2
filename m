Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98BA0CD5BA6
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 111296B009B; Wed, 20 May 2026 23:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 074616B009D; Wed, 20 May 2026 23:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECBA76B009E; Wed, 20 May 2026 23:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D66636B009B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:05 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A8C71404FF
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:05 +0000 (UTC)
X-FDA: 84790058850.14.2357EA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0846840006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MljEHJLP;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rlDrTS/qDNMBtSrkkbpm6odK2sEC/p6nHvamOoXHSXU=;
	b=J8ARBPCgPDwXBtxkGkHNGjJZ4wKLYu2/2ekNk2w/w6pCioa9gBmiNWhRX1T09O9DIDD0yG
	/fNKZ/IZI0L5r8lRY72zTCxbzSCToqYI/v8FR86RYDGLRKrXU1+Sjl8bqUMS5kcb03oAuV
	qLeWAiwePG4BG+3IRgFnugFiDG+JOQo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MljEHJLP;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335644; a=rsa-sha256;
	cv=none;
	b=YRleMuzIU2jH2QURaqg596NB5a5TdYIuOBsGkCxLm1QcfVlK5583g67bHNcex4cHp2ZBtX
	Xb4J2XJvq/LSye911+qbA4IhiOHa2l76okQFjOCNi2XQbhq7C7h7wmmtPUlyHgaOwnhY2+
	zmdoESkmpA/CoD6mEki0Sgd2j5zvUn4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 424E840DE1;
	Thu, 21 May 2026 03:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAD591F00A3E;
	Thu, 21 May 2026 03:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335643;
	bh=rlDrTS/qDNMBtSrkkbpm6odK2sEC/p6nHvamOoXHSXU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MljEHJLPdHlsbffSNnQPQqAl/ys71TtEecpF6sfGRJrYEPiXomGdTfS3q42D4sRTn
	 VlaX6Sawr9YNeS/6jnCc1lDbUCj1dm8rt+NEr2W7/zQN0WoUX/D31yjMiIrrnVcGIz
	 TNm1YW+rquPrFqUktF5qEoTca7UZjWIalqKArT1Usfca1FBP1wUQ8qDcnPNpkB4aKP
	 wigTtk1u0z2M5bp3s935yV/68gr+GwcB07H2NbxCBRARW+xU9pg9p/Sl0PYMu0c6mw
	 oLthl4minkCOPyQosegn/93FXSfId2/M08NvGpGmU1FFWE79BrfXpnTx4xVsO56Kzl
	 U4IbFMbQsoJoQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 09/14] mm/damon/core: remove damon_verify_nr_regions()
Date: Wed, 20 May 2026 20:53:43 -0700
Message-ID: <20260521035349.87565-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0846840006
X-Stat-Signature: 7g8cozsuq6jaq4u4r1aijtkmamr97d1m
X-HE-Tag: 1779335643-385427
X-HE-Meta: U2FsdGVkX1/1wHkPLPpwBruJjnZySfz79Jte/u35dbYxCp6NMsDKkbIAU38lBv945x26m+yzBPf51G8DUKK9evQTpqE9bZuRG20H6xXkEk31ZOKA/7jkntM0Qk6jxkNjZZiNToxxrgsLUPRh4tYvGIHtYV6qeOHWHSXgo9nbD98m7Y9MD15K7rfXYXDmLi+tgQOkQqoofl6caYFWXxqr/ie/I0MQHA0by18//74fR70SzEnv7Ykw8KkSl/nnJ6KLtCpN4IGm2MzMwH8W3oJzqxT/din/AbWWKuuYFabsEzW9tUs14GRLclM16UZ08crguzOpGcBdPOqUnvnWauDH+5d1771b1yc6hoTaROcACXTPWM34IsExstOuz4jrMiD0yt1DzU7ZNJlOrsi35vIf1egoBW7dzpLhLctZXNnh+UXaK2ju+FQFXeibrU5uhTHm6jcTnAD+83OJDR0Q5ecYcTzYZKTebvDkt6U5XChePeDVpNFBM+4s7Aq0nGLA1jqHPZBKy+J9u6BRkvAyQ0IL1uko6OZK6ilaQSsbhKgElj2fxoOsLrBdTl6CEKPiOk7MO74eeDcu3kSMvz/ZGRVyl6YTPGIS+loiTb0DxW5+s9uMVLho1FJFLWFSmhC8ClPyUmzbgtRIKIzpeD3D2jT9djyR4CS5D9MlQmyMpha1N0IoOJKtx+c7Chujhr8altGISXK8c1bIWCYhMaH2YLjiUPOVi53EIrH5GZBtF5gSJ6vnI9rfrbYyloasEh/M55gHu7Kcoxw1WD41I1HEjsF8Rj5Jhm1QMyG/oZz49QwcWtsiUIvLIOJfN1sS8t3CM4GBBsmyyCHLpD+vSU5EuVTjdADOhVRqo5So0e+wadaaLcHR6PXrdV5qB2EMdYUnFBoROzXGzjtos5tMJ8rSYAevgykz0QiyXTsEHq1f37YCIhOWpt8hhQvNjZSvzotY+2yNVrvwr+g0s0XTLrxBJjZ
 r5EjFp+2
 s+KEN7WUuYcCJhYguEQPHsZ48qlW3eWWA0idpDKTrLdXGwiIW7TzcwFy5F5xAbJsUUTbqgQlDuzf3VMTd6dg2myea2w+83RTFbYbOZ+Q3Z8Bg+d3rN/GbXEk1Md7dDqI0PHaTcR6kLwzQ+3d3TOgiOHPGZEbOhDqm7Y/9/Gc4X8UBa2ieR07/6+SRv07SizLSx8lZqBb/fSTSMdpMAHnv8iel/N5sCO6kVCQLm+PE4vjtMp92ZDj6KLVfU8GetyGPwWjieGdugh6WG5Wc8OuNJqKRAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DAMON_DEBUG_SANITY is enabled, damon_verify_nr_regions() is
called for each damon_nr_regions() invocation.  damon_veify_nr_regions()
iterates all regions.  damon_nr_regions() is called for each region in
kdamond_reset_aggregated() and damos_apply_scheme().  Hence it imposes
O(n**2) overhead where n is the number of regions.

Though the verification is enabled only under DAMON_DEBUG_SANITY, which
is not for production use cases, it could be too high overhead.
Meanwhile, damon_verify_ctx() is doing the damon_nr_regions() test.
Because damon_verify_ctx() is called for each kdamond_call(), the test
coverage from damon_verify_ctx() could be sufficient.  Remove
damon_nr_regions() verification.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 19 -------------------
 1 file changed, 19 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9cde5b47b9585..265d51ade25bf 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -686,27 +686,8 @@ void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx)
 	damon_free_target(t);
 }
 
-#ifdef CONFIG_DAMON_DEBUG_SANITY
-static void damon_verify_nr_regions(struct damon_target *t)
-{
-	struct damon_region *r;
-	unsigned int count = 0;
-
-	damon_for_each_region(r, t)
-		count++;
-	WARN_ONCE(count != t->nr_regions, "t->nr_regions (%u) != count (%u)\n",
-			t->nr_regions, count);
-}
-#else
-static void damon_verify_nr_regions(struct damon_target *t)
-{
-}
-#endif
-
 unsigned int damon_nr_regions(struct damon_target *t)
 {
-	damon_verify_nr_regions(t);
-
 	return t->nr_regions;
 }
 
-- 
2.47.3

