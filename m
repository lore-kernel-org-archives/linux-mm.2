Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0AC6CCF2C1
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 16:09:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D227F6B0099; Sat, 17 Oct 2026 12:09:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9B66B009B; Sat, 17 Oct 2026 12:09:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C377D6B009D; Sat, 17 Oct 2026 12:09:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9C45A6B0099
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:09:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A5661202C7
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:09:40 +0000 (UTC)
X-FDA: 85332603720.13.6741AC9
Received: from mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA74440009
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 16:09:38 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UucuTBcN;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792253378;
	b=7sFvoGR07V+Ao4/LFkX+Vklw35IsPaCirQGBOStDg63wg5xSmQqyd2eIw/iQg5RHA4y6gz
	zxu79fgvQfF6GMnNInVCClW28M9zJee798nSCzDgpLwxH2o98dxCirHXkDd0qwbHpFz8tg
	B1p27ph8UbBswd+Vg8VwWfkeYGOd39c=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UucuTBcN;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792253378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdGdde7JQeNnKZ2Dgu60JQOMEeTymBC2bQ+stIsNSz8=;
	b=nSeWVz4rWoexcY1ri/bdgbiRVkpEoz+gDaTQEyvu5qEyC5H8HVGP/sgwK17Y9+Kz4BVqjQ
	rLpuMQHCTzmHWBTET8nwolWV22s5IsfKY4XwdhdkSiyVsvOk09zwH9ogpGQupYkORJIPNM
	VVnRqDu7yrcfx/4GZv/6em1ELK2RsNI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FFUgdh8idoo7uPYiHxk4YzUlj0DtXIIOClOikNHRtTI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792253377; v=1; x=1792858177;
 b=UucuTBcNzZSdaIfb3BB9L1+6C1gVPmTlN45NWJp65BRtQd2w80Zj8VvFvRrNXsIoYQfTZx4b
 wZ4Q6tfEk4ti9HdqzXhVz+B7RF8tiG2Mk5Z8s0MvwDKCsQIZr2xd2XWWxly9hN4P8CWX7KReQdo
 BSQHetLP94UtyjUm8qNwo1BY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 4bf64299f0d71374;
	Sat, 17 Oct 2026 16:09:37 +0000
X-Mizu-Trace-ID: 4bf64299f0d71374
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	chengming.zhou@linux.dev,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	nphamcs@gmail.com,
	terrelln@fb.com,
	yosry@kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	senozhatsky@chromium.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	linux-crypto@vger.kernel.org,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v4 2/3] crypto: acomp - enforce MAX_SYNC_COMP_REQSIZE
Date: Sat, 17 Oct 2026 09:08:54 -0700
Message-ID: <20261017160918.2738626-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261017160918.2738626-1-usama.arif@linux.dev>
References: <20261017160918.2738626-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AA74440009
X-Stat-Signature: hph8a8okhcho697g34rnqg6pe3jrmz69
X-Rspam-User: 
X-HE-Tag: 1792253378-137734
X-HE-Meta: U2FsdGVkX1+aq/SB3zz/lucwqdlACMb77/lbPX3NY3LXxs8/uCyXUu5TunEnbJKaXSAcbtvHBY3QKyQMOTzZvd3e/kbaNCwPQlQvCecJ0rdPWP7YTNMiR9woGgbeSFD7G1waw3xmwucZaWFdFM4TPrtlE7JpaAYi3Sl/jNlD8dI36LAGmfJ8asbAM85YqDNBrzZGQgruJyTA2O5lKCLFB1Ge6v177kO5YDDSTE4K17eGt/S2u0+EG/GkXSiO9C8W3RXzK7xl7p8pIjNzO/NMod+EVduXNT8Bvt64kwl8gzGOhqslpxh1BSQE3urVxDb11gqVf9e9/Aq5fkGmTQqbhQmrX5dOLgRpvQcT7P6b7c+AqaWZ6z6NHvOEwJGRlucA62mcyYS/f8uhM/6UQLg7LcxOGJVZm4KQaU/OT9+royHmJVdvxXkPKJQ8VrzGQrroE2abn058U3yDbaGHC8DpKUxNjBUYhQC3Htao7VEREBd/aUz1XoVTe1XwAiaLDv/SvYKK41sAPwOZeoaFz96bQmFHPbgceHBLVxZ2/2Uyz3iI8zLJB2yTPpQf0eLgctVKM6PBT9FTF34jqyuPAj3MdQe7iX9Z3jk9iOGawl/bYRZWdeIljTjCMbp/ft6i+908Wk0xTTMQscgWLeh0Gj2PSsz3YOj92D4NcYEUYIcrKvqPil+uRN4RdgFFmQEMkkfuKLFmvsoYQw6uwQ6pyuWJ5w+Q2Js0SPLOapsnxg+xxMNMBkdiNvjOk2oOj68/kfaxrT/7h+8DJe8aqOnrKJtutbFftkK7xUE2X+ab4JfVGKnp5kuKrC7kECa95FcryQWkE2N4/uTa9qzXBPOIWaijqoLz7uu1RAJqsXiUL3BBFmFj3ORrxJJ5eWyATmKKH6b0gzUXm1fpWBKwYMDfIub7FLBY7ybc1uMcKpzyCjXbRYGaN1M00mtSsbknlnxDddRkqV+lMncZzPRUwilu6K/
 1A562hmk
 wk/grFe3UwO6393PF2XiqPGBXbf5eeDDnnZMtvsiPJraYjO2Po/I74MQP8xH+LGH3yxLcteCGpGo5jP6xQ3axp7TTs4dfIQrvOLgsTjGg1d7KHf22seKazzpESwYOo+fN388y9uOecIgNlkxyeNkUAvW1QfNAQ8mupTon82a8qS06FCRC49F6tHZ9c8VMLuS01XjZYzfOltWIlD17U8CR/QpoZnbobG6xIcvWv21eWjg6EXYtVyCBzzXJXaqzbpW7qW+A2lNzzhUFIdptoBnW2AON0C4GB9tlV/cwWJvFedcQUqTPZ+Doc9F+Yi2p4aUhqEsny49SgCptc5Rj/gO+Nq2plA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Herbert Xu <herbert@gondor.apana.org.au>

Enforce the limit MAX_SYNC_COMP_REQSIZE when an acomp tfm is
initialised.  All existing algorithms obey this limit.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 crypto/acompress.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 4de1a2ad577f2..c8b4b8589769e 100644
--- a/crypto/acompress.c
+++ b/crypto/acompress.c
@@ -92,10 +92,6 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 		if (IS_ERR(fb))
 			return PTR_ERR(fb);
 
-		err = -EINVAL;
-		if (crypto_acomp_reqsize(fb) > MAX_SYNC_COMP_REQSIZE)
-			goto out_free_fb;
-
 		tfm->fb = crypto_acomp_tfm(fb);
 	}
 
@@ -105,15 +101,19 @@ static int crypto_acomp_init_tfm(struct crypto_tfm *tfm)
 
 	acomp->base.exit = crypto_acomp_exit_tfm;
 
-	if (!alg->init)
-		return 0;
-
-	err = alg->init(acomp);
-	if (err)
+	if (alg->init && ((err = alg->init(acomp))))
 		goto out_free_fb;
 
+	err = -EINVAL;
+	if (!acomp_is_async(acomp) &&
+	    crypto_acomp_reqsize(acomp) > MAX_SYNC_COMP_REQSIZE)
+		goto out_exit_tfm;
+
 	return 0;
 
+out_exit_tfm:
+	if (alg->exit)
+		alg->exit(acomp);
 out_free_fb:
 	crypto_free_acomp(fb);
 	return err;
-- 
2.53.0-Meta


