Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7097B10F92E9
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 18:34:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2E976B0095; Tue, 31 Mar 2026 14:34:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF566B0096; Tue, 31 Mar 2026 14:34:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 995F36B0098; Tue, 31 Mar 2026 14:34:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85E756B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:34:09 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4121A160340
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:34:09 +0000 (UTC)
X-FDA: 84607207818.03.C48F57E
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5E62514000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 18:34:07 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OWu+Gak5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774982047; a=rsa-sha256;
	cv=none;
	b=tvlCEp8mLxE3r37oovoCZt1t4UmOZpt36B9F9E6jpVkVe2OxRQ677xbsljDynk9SUU9/H/
	Tto/vpixYW+d/Vd3w168wWHbqOkl/KJWjVSHV/ACV9YCEantufvjnh9pvfINYap8u0eWHW
	4deQ6vzx4nkVBgUq3z9r9toE3QoF9nw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=OWu+Gak5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774982047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8Z9k6IBVmnZKroX7/272gWXi20ZJmLT8jW6F8/KWzUQ=;
	b=M8EpTCkBct7+zhwPSVruGJc3MhSxCzmjmz2AGznp3o1QJBjBW4zztVE2pnXkmJvGSVzWcH
	Du0AvxNKTU2xfQyaNNNxwGYrrye081MGhZFcxE3UafHFYIXWj0WmxMGjR1iFksYnkHFNfE
	ot06WG06cwvse+tFnATZjPSKhYB+VaM=
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-127380532eeso1299630c88.1
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774982046; x=1775586846; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8Z9k6IBVmnZKroX7/272gWXi20ZJmLT8jW6F8/KWzUQ=;
        b=OWu+Gak57Ps0qhSPCByeH/aPwlo+kb0SSFevWfoAMZ/89F3tMEoQgToiYlNHGq4Ps7
         ChJD2zK+a9nW5UVkfty54bIS2z+7/0D9fMrwRG67SamvajkPpAPIPXq2XBfS+lGugsau
         RcWC7ju/Sb0vRfPvsKRPdwT6+/GLcdYA689kbsqZyYqXFtTPz6CodEexEnYDloi6To0K
         DDJV/ZYu0zgrBTEEh4Yt5KRo/CznQRGyEb8rFy3v/ynUmkTc/ul7kX63Yx3aUcop4mUt
         XeNCWwVopKX9ZWkrutTo+9do4uAlyPTM79wLl7w7OvpI3e7y9QPPskviDPLi3+zQ8qm6
         HbHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774982046; x=1775586846;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8Z9k6IBVmnZKroX7/272gWXi20ZJmLT8jW6F8/KWzUQ=;
        b=fuD5vCjU/W2iirnqs7aoGfATTxKi3u/8skf7+Plk5+5COAbzv5hUj71vPiiz2IvVVY
         D5znx0fFeMI+GDzDLbCsHxHHCgFPJdmfQozoORlLK0hjCCrGZvtYiw/ZSdZzTA9PW5jv
         +YEqd62rcqMIOz/NcM6wKHysTPvqsRknK6YqB2l7wTeYAp6Ry4ByipGJz8u1J7aCg34v
         PB1+a9qiOYLTmE1sSx2HfnVzRjInM1x3KUpfaMuNdvyyPTqAK8djlXPQgtna7dcbiLh5
         LCsNp8sGO5XxaOqEx0Nk61OzmvAIPleJDj70U5SfcjbLWAyF41dxpnV45o22Xt3t7cDy
         1sIg==
X-Forwarded-Encrypted: i=1; AJvYcCXSuKYQgFsxLIMx/qqeU0FnbtAHy2C83vksE1HMyvT0lwa0jrj9LeUyaNt3Vwfp9V/O/Ix/R940Og==@kvack.org
X-Gm-Message-State: AOJu0Yxe7SQ2A3GzEeV0SXk5+kr7zZHMgVtxhIlj1eC/YQW9EbRhvoJO
	20jqgDsq/N/KdFM8hGbJIAXlKb3wqvBZUYvX07dGgne8/hxXA3xV1rch
X-Gm-Gg: ATEYQzxlyLcYEJs5SWARsGDVW1hpHg+lUfyx+c4Qz60ZSqBcjpH4wtiLZh9uvH1vR5g
	2ROyTnsUvF1PJP1WZ8feCsqR5+OHoGB7/5/KK/IfHMsJmD6cUefo82N+K4qva53FPxHoSe6epV1
	KKTVvrro/Vkdq2lZ3gNaFsst0vaw0lT+n+uzX25AC3nwxp+UNiNPRel9asOt1kHpOo7Z97/Bt4c
	Va6ie4Qus6cTXvBxQffXClA6/WydunQVWYG79smo/qkC8cxisgIfjc3Q/FxMRnBAixviSsH2ey0
	ENvgaMmiI3Z8dzTa8dlbdfC2T5HHAVsyrcr78ftQCtDaJ/Fluo/En5zvT7Feirmna5s8e02E4SL
	oNNxdw9NNHciucGp++vwLyc2GAemrbyshsnmiRKg2pd3LuMs6rchp9ZUQo6khOeVj0P5x5oDSiJ
	zbIo2OfJ7DByC03b2PdlK0KsLq3A++MxryBAEcEnclvbCCsrgl
X-Received: by 2002:a05:7022:f697:b0:128:cedb:33ba with SMTP id a92af1059eb24-12be645523dmr398491c88.10.1774982046018;
        Tue, 31 Mar 2026 11:34:06 -0700 (PDT)
Received: from penguin.lxd ([2601:647:6400:3ec0:216:3eff:fecd:e4ef])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12ac4a0fa8dsm7961271c88.15.2026.03.31.11.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2026 11:34:05 -0700 (PDT)
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
To: hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	akpm@linux-foundation.org,
	kanchanapsridhar2026@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: herbert@gondor.apana.org.au,
	senozhatsky@chromium.org
Subject: [PATCH v3 1/2] mm: zswap: Remove redundant checks in zswap_cpu_comp_dead().
Date: Tue, 31 Mar 2026 11:33:50 -0700
Message-Id: <20260331183351.29844-2-kanchanapsridhar2026@gmail.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com>
References: <20260331183351.29844-1-kanchanapsridhar2026@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 91mcct9uifutkhy733m69or43hp6etfp
X-Rspamd-Queue-Id: 5E62514000E
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774982047-750035
X-HE-Meta: U2FsdGVkX19HRNNyhdxuyXODeSnRFoQZUpIAIASsiPQc5WDD7F6hvg0HtInxAlVaDzFs+ci68zVJWhxcWjFkBWL6GGPxpqmy+Xh7Oa1hWIBOSjAsdbWYwj8fprC5DTj5xPPY8xthRfYBj8dNHvtbVwDrJu2aSNITSpjAacaWhV+AImLiihWAuDTUCjEy8DgQi1vLW0zwxVP8eR0yA+Hz8Ip7ZW5658vS4+OqWo0XBg7eBTpkDLG6Weq2QZnYgWvstrUqneH9E2iGMhXkASNkuv5AOX1HsYny78maJwa1K+jZEDoUkb3radGkPJFbRi3Uwb8lJT+dBydu0DoqPZrDE8iM6AqbGjcYpe6MGU7kPjqe758Caf5sstwksYhuDHN9958F2tOB8BdLRIKJpMSIAaAnm8JgDUR1ibGQLkVQT1oSOv45gAeEma4PYnoyeP324dadMyhO+5YQD9n9y4yd6JVCCWGh7RJfAOMVcMLkHt0NPKKp16q/yGyqdoHxiEhea9I6ym4PcDdWwpOcval2V4xbgK5OMNIpy3prtnzBRpXCxGZhLqw6tzrVRBmG6jnp1lkCKCZRjrK7kyq/B4fEkdyg3KVyoqNR/GbBFxIuRMdBNLoSks3BcDne1ia1HOCdEnQb7DZ6lmiQ3mS0OT51OIv74pgTQ2+Qq8+Fcc4PXEU0qm2Nw1pe9fgMUgcdyrnZDGqq6G5Msac+vQr91++AlBKL8hbyhU9frCTGMfoimoRni+LCdLwSQeFtid23/tx80cw22ijjzq0mn/LusJQbhnLHYHBxAfpMIY+xjcrHID3r9uf+J+zb+sAFRxLiOajjf9iCLlJNTC36SLb/5Ha1T/otVN7/fmLEAIbVY7ok3vuHkk168MD6SQoRnzhg6i5ZtsyPN8MVjKxMh8NJ+srNNirMVAz5SUb81FKiHmiUQ9vz50d+ZR8wHg8hDAc8+Xsf0A3z6O70raU0aVRlYMm
 38XEOlRZ
 DKs2PC4oWL2CDhk5tzbxQ7TeuHe5YKVNRQr/Upy34MrIiVoKPk54WcOJ1dqLT5WvxrDuP4Qj/AnU4+6mm5ZmOMV4X9/RpyZCUfTPCM7RPJWLpaKuGTeECoKn2XU7onA2q1UiHTNIV7LE8KhsgS8TSHjIQAj++K8nnuoX7vE/XdL4h1ovpmOM/ImiWj9b+vAOW6jAsPL0V5wH0OiAITw37xq67sCCfxatMcgl6CBF27+NGLFRkJr1Kho61qDuoNyftbE13a1UFvnRkv6iVVg4xouSZ9+Sr7qBRU48aS/trNClqNvPeqXAvS51qeLZlUaM7LfI8Ves2nC+RvuAtkbyO98mW+vgJNUcI64VOfWvYjEERvV/J5nNocWJfNvoXMj54gRhb0PL4K4JswRNhHdpdbOUHBh7zkWoTra2UYJncoHAq0SdRCTwICzjGQLE4zqYSaxj/k2ZlfSXSfCAkZvrKgZ9sn3ydEpfSweYmfUjgzWVIZfc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There are presently redundant checks on the per-CPU acomp_ctx and it's
"req" member in zswap_cpu_comp_dead(): redundant because they are
inconsistent with zswap_pool_create() handling of failure in allocating
the acomp_ctx, and with the expected NULL return value from the
acomp_request_alloc() API when it fails to allocate an acomp_req.

Fix these by converting to them to be NULL checks.

Add comments in zswap_cpu_comp_prepare() clarifying the expected return
values of the crypto_alloc_acomp_node() and acomp_request_alloc() API.

Suggested-by: Yosry Ahmed <yosry@kernel.org>
Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
Acked-by: Yosry Ahmed <yosry@kernel.org>
---
 mm/zswap.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 4f2e652e8ad3..c59045b59ffe 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -749,6 +749,10 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
+	/*
+	 * In case of an error, crypto_alloc_acomp_node() returns an
+	 * error pointer, never NULL.
+	 */
 	acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
 	if (IS_ERR(acomp)) {
 		pr_err("could not alloc crypto acomp %s : %pe\n",
@@ -757,6 +761,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
 		goto fail;
 	}
 
+	/* acomp_request_alloc() returns NULL in case of an error. */
 	req = acomp_request_alloc(acomp);
 	if (!req) {
 		pr_err("could not alloc crypto acomp_request %s\n",
@@ -802,7 +807,7 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 	struct crypto_acomp *acomp;
 	u8 *buffer;
 
-	if (IS_ERR_OR_NULL(acomp_ctx))
+	if (!acomp_ctx)
 		return 0;
 
 	mutex_lock(&acomp_ctx->mutex);
@@ -817,8 +822,11 @@ static int zswap_cpu_comp_dead(unsigned int cpu, struct hlist_node *node)
 	/*
 	 * Do the actual freeing after releasing the mutex to avoid subtle
 	 * locking dependencies causing deadlocks.
+	 *
+	 * If there was an error in allocating @acomp_ctx->req, it
+	 * would be set to NULL.
 	 */
-	if (!IS_ERR_OR_NULL(req))
+	if (req)
 		acomp_request_free(req);
 	if (!IS_ERR_OR_NULL(acomp))
 		crypto_free_acomp(acomp);
-- 
2.39.5


