Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7C34CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 09:44:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838A56B0088; Tue, 13 Oct 2026 05:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EA0B6B008A; Tue, 13 Oct 2026 05:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FEBE6B0092; Tue, 13 Oct 2026 05:44:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D3356B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 05:44:50 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BADF41603E8
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:44:49 +0000 (UTC)
X-FDA: 85317118698.11.6419AA1
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3C5D0100005
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:44:47 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=cIkWQNLD;
	spf=pass (imf14.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791884688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/e6lP0zIfYuncX6FoWA0t18UOCeFYO98vjWiK3ReD/0=;
	b=h6PgHZoZc02pg4WFtpVcvUnHNiXrw0QkTiqTOrOwA7wNwk5O9Nsi3x1z+TGXmMGd+XLIgE
	Cy+aGLLfVvGpGnAacuK6uiRTZU23S8VL68pN32to8ga/KTI/7/G29OSozdjNiuSGX9bwSV
	eQyiUgGLCGuHRcOMxlsimt+nbZeR/0E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791884688;
	b=sUech2Iy7RHE+lch6rNF+OD+1wTze7iHYfOE+3soDEJz4W/WFgSCfJn7PI2JqT+gCBLPvK
	g+MNuHC3bpmTbbvq6arDjZ7+YB1JCf+650OfrVonMZKa29Hix9ZTc+d+fY5Os6cSjWkK8P
	dZa4KzWTeUoImB0aAN0zWkrN7JbRiQQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=cIkWQNLD;
	spf=pass (imf14.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=/e6lP0zIfYuncX6FoWA0t18UOCeFYO98vjWiK3ReD/0=; 
	b=cIkWQNLD1S1pqISCFa/uvYrI2tDelPCvusuvXE1Wc+Eyfdpg0HLwXvd42R8g+tQ8DQ94se9hwXa
	XvNWEo7K9qRvhDIQEh2gm2A5fkVsoWjJUXgI8igrg7zyPdnjKOirnl5lSn+J/X/uixXfFSYaHmX6b
	Gvrcdv4kldAxOgLGiqmUrSXKpqaK4hCjirWY6fvM8n7gu1qFSiifqvrefXqbHy6fv05fOqboFm6yD
	an2M6KNtpP7NQEikFvPq8dsWSNB3KzGQc30ZRF6uMVG0G5drxOwxqnQ+ZyFqfeNB89yu7ZfxqKUEC
	zjayKt/tYiX2mO1STYenL3RCDKIal50a0LHA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xGZ3n-00000003KGf-3HDy;
	Tue, 13 Oct 2026 17:44:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Tue, 13 Oct 2026 20:44:39 +1100
Date: Tue, 13 Oct 2026 20:44:39 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, chengming.zhou@linux.dev,
	dsterba@suse.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, nphamcs@gmail.com, terrelln@fb.com,
	yosry@kernel.org, riel@surriel.com, shakeel.butt@linux.dev,
	alex@ghiti.fr, senozhatsky@chromium.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH] crypto: acomp - Enforce MAX_SYNC_COMP_REQSIZE in init_tfm
Message-ID: <as39h_dFzL-Al1-r@gondor.apana.org.au>
References: <20261009163146.83112-1-usama.arif@linux.dev>
 <20261009163146.83112-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261009163146.83112-3-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3C5D0100005
X-Stat-Signature: 559kt4cghhpibx4zosbw7xa6mbzjfc8d
X-HE-Tag: 1791884687-793673
X-HE-Meta: U2FsdGVkX1/bisaoOlapKsb6icPzI95VW98R8NGB/3tXpTSrhzpfCLy5yXiW4oc1G0jrnN1fqH6caomWE+WebnPOUJNUHFKpsnfLYa7kN2u9qNh/wM/SVgkTNDIynqS4b9uCwDgKGBzuBzsI5SYx1m+tYZoxxn57uphspxHsvY0ty00C84jZkZGxFzHZmc8M5NCdAiW8BR2b9WeHkmhv1pi+SUZtcp0pK+jNlVAN65E9cp4mEL8WpXsUBTsbe/DkYHEK88fiawk65jYlhXCC7Cmr6VkEifVsLS04zS/cuA+kuBNoe1USnLkXe6udwB7DRPe/xHAL7pLpcJobDr3+EnXYxxvFgtYnfKHrMxX+niy8TqJrUNr9aDsucEaVuDYWD6bmOIIuNIRMR/yA/VWUceSF6ZYVv+oOIHqvYIH6ko4phTBCGSd8YYxzELfPgOEgalF/+SCvhmVGGo+48jpkd70JlMFvg5xpXkE3SwrSHmT6jEOOXXc0S3/5BhFoU1O4axgpT+D8CTG4co5Ij4pPOOQA68pJllNQCRI/MSb/VCRfZ6mSzdebdq6kd/wWIyrfgVqGXuFWEx/WRFfzbq3MaSMNJQfJ/NmsDufl6S0QXLnA7CjkaksaFLtvEjPb8BvEEZ79UU2H7k/d0fGKd9omurW2jW7OmyZGzBgbzaH3a1bu+62yAAgBCxtlL1AXX4jGguDheC4AHTSX+tiJGDgRbOZHJbksqHeemycS5T9LL133ktS66oO1h7ya+Kpnd/zxEICQpp3SikvH9sFfyQauqwHMHmHeszPyonk8CQx0t9+eyczlbeuYdu0BqC0+UXhQDCpruOZBH9hEOcu8o67jYMRzutvUi/UZ9BjKGfR0zPUeKnZr8cJlK+aBNqsflZMf5VTgK9EN1hiSKyFZCjGwQbx7ZefIXORlQemIWX/bLM5ZH04p47LE7DcKH7rIbGwou9AOzKuncSp6tO7ZgT6
 Kp5GCNCo
 BZE4ZzGeSqThOkOKSJuDHIyFtKjWpm6TZQ0wea06ACl0j0Ns4hIgjmaBuF/dRm0aJTkpshij26VXFpxlk/En0ver0XexuN5gl6inJRNuLga6K9s4VZq/62qDlr5Yl+Ji4LbjMcohngFYL4lWpxefuu5rJyrznbAI7x8d8OTIWVItxqET8rtmd6gWcMGm9TFZKJZi/C41qw2tejKj1nfuQMN/P1+7B+z2amh0Ywr6baaEtVXei+UTL3hPzPCAxfgym9n34QBV2FIXVZf2++Uci/XtJrpzrUH6N3PUF6n3EWUEnr06bEUH21PtA6lqmM6VsuYgMP5p0yYdTzsI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 09, 2026 at 09:30:31AM -0700, Usama Arif wrote:
>
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index 5d5358dfab734..12c1ce1f6243b 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -203,6 +203,19 @@ static inline bool acomp_is_async(struct crypto_acomp *tfm)
>  	       CRYPTO_ALG_ASYNC;
>  }
>  
> +/**
> + * acomp_can_use_stack_req() - check whether a transform can use stack requests
> + * @tfm: ACOMPRESS transform
> + *
> + * Return: true if @tfm completes synchronously and its request context fits
> + * in the storage reserved by ACOMP_REQUEST_ON_STACK(), false otherwise.
> + */
> +static inline bool acomp_can_use_stack_req(struct crypto_acomp *tfm)
> +{
> +	return !acomp_is_async(tfm) &&
> +	       crypto_acomp_reqsize(tfm) <= MAX_SYNC_COMP_REQSIZE;

I think we should enforce MAX_SYNC_COMP_REQSIZE in the Crypto API
and then you can simply test against acomp_is_async(tfm).

Feel free to include this patch in your series:

---8<---
Enforce the limit MAX_SYNC_COMP_REQSIZE when an acomp tfm is
initialised.  All existing algorithms obey this limit.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/crypto/acompress.c b/crypto/acompress.c
index 4de1a2ad577f..c8b4b8589769 100644
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
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

