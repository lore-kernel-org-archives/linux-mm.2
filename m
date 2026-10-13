Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F128CC6B16
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 15:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F01C6B00B4; Tue, 13 Oct 2026 11:11:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279A66B00B5; Tue, 13 Oct 2026 11:11:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1689E6B00B7; Tue, 13 Oct 2026 11:11:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E779B6B00B5
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:11:00 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B8E11C4775
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:11:00 +0000 (UTC)
X-FDA: 85317940680.27.F52F93C
Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7CDB940009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:10:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uDdPwzp1;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791904258;
	b=gN/5EERACt2i5kVvsNEEsC/k0DKt2dzy3qOPvfUcY2BAy+O0AWhd/hXssbR0iLdYNGqsUC
	TKB5gQONbAh8cdMa3M+Q1J/1f16ZYjsUq65hPmfq+YifO2thqcWfyWCchGeHpzGTLSAD/n
	jgj9XNRFN6v7wJ90l0OVnkIMzcUgWCA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uDdPwzp1;
	spf=pass (imf17.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791904258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LdGdde7JQeNnKZ2Dgu60JQOMEeTymBC2bQ+stIsNSz8=;
	b=OD1SLRvqPdQ4dnHt+VSfB/MrMt/kKgyW+jItVbd/B79al7TSkWV9Ofy4dS+rCCjLbDO+o1
	ouKVrvZGBCU3C3RS5SAXRjpErf9C1LXiwHLQFHe9lq+cdhCxkSmxD9BAAkf6u4+Tn11E4m
	KjiI5BtFJCeyPUg/FqWPGTrh6YXVKaQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=FFUgdh8idoo7uPYiHxk4YzUlj0DtXIIOClOikNHRtTI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791904257; v=1; x=1792509057;
 b=uDdPwzp1nZ2H0MxTE4jLkJq1QzZbVrM9V8AQ4PiH38KsRVrZ/REP/9cgY/TB+JBWCYTD4UbL
 DY6JD6tIoArrMBFiAVpSTFmK0G+APxsYf7dKijpyPl4WPoxKGBG5LYbcOxCojceEla/Ses5jSPD
 Paj3VDozNRvFMme1/7hoxzp4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a950323d0bec7872;
	Tue, 13 Oct 2026 15:10:57 +0000
X-Mizu-Trace-ID: a950323d0bec7872
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
Subject: [PATCH v3 2/3] crypto: acomp - enforce MAX_SYNC_COMP_REQSIZE
Date: Tue, 13 Oct 2026 08:09:36 -0700
Message-ID: <20261013151007.2093943-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261013151007.2093943-1-usama.arif@linux.dev>
References: <20261013151007.2093943-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ujwpqhm9o54fki3ykrn9tm3uyth5ek33
X-Rspamd-Queue-Id: 7CDB940009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1791904258-204653
X-HE-Meta: U2FsdGVkX1/hT0RBWr14LtYtpv9dZOSPSomraR/9+J21U5UYB/zi8ilsyDzrYO+xgMoxFaffdzfM9cdQyms+nt739ldFr5pTFtxmC4kLccryMNveEi5Ey2P5SKXiQ66HrB6F4s6Oa32sYpFMFaJkkcRD953hmuMe4xYoivfM0LMQGgtrWJ3ZTapNWxZYzrT6fCobTuRh3aNJqX0KS8ugTo5N+ZBzF/dSuK1rDcKljSZxDsJJRvLSzIFBb27FpcLLBH8t9xO+L8qeuRlLmINOl5RwNxdUtJBnu1lWXaGElqA+CvQkEJ2zgPbn7x5j1Qi52s/fUqXOX3Y6rFrjB95go3aOR4HdN/VZTxibi/y6VyDfVoZvOG31vbBFSbljPazPqUpXwextj1AKgQnl69koB5UFv8eX3FYfsKZKdR6FOMFeJhUoj/rdrhVh9YKysjUkA5ra7vz418MMs6u/dkfR/BjUcpZsBfHGQeH8UhQq0qF1SuZmVTS/QafkITtNU4F12IiHz8s4cN8F0i1IdylUj6NtsFfF9FsvG2Gq7rmnIIgWdbCuiuykUKTEzU5uywTcyKBL3TRmtuBfJEUKqsxkYtjGGX40Qe25b/OLvYwcM6l7VqUmsjPr0E20dQQgqhAicldRN6SFbBzvYuj+p6+qGxGize9uYJUR5ONH5/rgS/kOMLFQutkX0N4Be+u89N+vzbfMa76oX7j/thFFwpJzhLgMXJP+OUGbxjnwPEvsEFSDTf/ylpJ74HugqiQKhWbdVhh7C+PmVMwCfLKuaFB00N0JvQmfnlK3NBXG6NYMsFsUZ9tV2zaizrBkkgWYYk4U2j0u5Ggj0bdQwbfYbfiXyOa1Qw9BMCSYDq8JfGm/Xq7jAcIsLesC7+I0Tn1QI6zI6/kQ+2GsxJNRUB8XEPjb8BihLe+59iMkk5IBeLFnCHuJ7iwot5vpn55HRv0Xngy5vJrbWGPUlhvcMJ5qYEA
 ohDyP5NT
 e5xTsQ5bL66ub4vh8NLtJVhdm6Gi4YyK6631rwwFuxSJJbmM6s6uvLSP1ZRQ8enRp0XBO6lqX3lkxm+kh+JjcEWiFh3yaGvTXz8GxTyGNmSnQSUdcykcV8f0TCyPOYM7cSkmaFM5cx0iPET+nlwRi/z1G93ee1s+Q6KUCQHWp00u1EvKOWF9WbBm0E/reE+ZUecEon5SvNPmbMGi/lWU55RPpoXAjbvh7RiiNnp5QxzXtWvI+TD4iCD88OSzzfJH6moIDqR5WB4p/mW96/4VYCqxbFSJ55ap3VMz86jIJqitd+z+nFlitnnXMyWq5TiwGZsMY/SoL57iiPJVRoqK11J2Vjg==
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


