Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 484B1EE2085
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 10:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9632E6B0088; Fri,  6 Feb 2026 05:49:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90FF46B0092; Fri,  6 Feb 2026 05:49:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 839BF6B0093; Fri,  6 Feb 2026 05:49:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 719CA6B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 05:49:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 132CF1405CD
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:49:31 +0000 (UTC)
X-FDA: 84413710542.18.7270721
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2A1BCC0012
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 10:49:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=rp+5wXTU;
	spf=pass (imf22.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770374969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ptcmndYEG1F6l9iVKWQB0jX78266KfWSXC+PhYUkJiY=;
	b=cAm7i9Zug9nqTBVGVwIbnNkJalycopkfDZbbcNyaCI9qTqzFehq3Ks2ETqGU20u2LkIAxc
	LBif5tjfnPt7778X6jLIoaME0wi1QNRJyYVjzosFxCPSeuP5cBxahJy16LL+OoRejBLlqf
	YS0wIk/9p05BncyW0mwoILPy2Hytl3E=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=rp+5wXTU;
	spf=pass (imf22.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770374969; a=rsa-sha256;
	cv=none;
	b=hemSlci/0EweSjoDhc4J9kfvq6cyG85KoH0z6a2Ia9OrWAm6yp5CqATL6Pk4WKun1/bFMm
	5xIC9T1+fD8giw3p9dwB+l0FR+c5ZNLDx7EZM9VJ3L6frpUdv6+S678jDsytbi7ytyccoK
	HkYCK8ePMceAUZVGv1RIknDNNcyBaMM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=ptcmndYEG1F6l9iVKWQB0jX78266KfWSXC+PhYUkJiY=; 
	b=rp+5wXTUE69Xxrg+403LV08mJKMDJk6CMXofHVSo2AKrRWwNVx5A4LOs/8hpR9ciT6FSHKZNYnF
	A4QqpZeBNqO3etWuChHwkLHFEmtY6NdGfxvZMdOYawZLx0PSEX6yKh2ahySDa3liWzGIpWzJLc4AG
	Sgb/64W9FD5bUuHP/aH0At/zU6ApBpPqZkoEGv3xl7oYFafgPVuXsvdr47lNBFNtOJyuXtBQAzBiT
	PNFJ+g7Z0eD8oRpNaX2EjhhDv1ec1OO9Vo5CLxRF1s3bvcoIkf3ZixzyRxAXQyKuOFc+SR/wqIyTN
	Xqekxb9BTYixAbLAcn6u/Yjl72JSumBdnifg==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1voJOt-004zKU-0W;
	Fri, 06 Feb 2026 18:49:24 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 06 Feb 2026 18:49:23 +0800
Date: Fri, 6 Feb 2026 18:49:23 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com,
	linux-crypto@vger.kernel.org, davem@davemloft.net,
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com,
	surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, giovanni.cabiddu@intel.com,
	wajdi.k.feghali@intel.com
Subject: Re: [PATCH v14 12/26] crypto: iaa - Rearchitect iaa_crypto to have
 clean interfaces with crypto_acomp.
Message-ID: <aYXHM4mGlj9y2XXM@gondor.apana.org.au>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-13-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-13-kanchana.p.sridhar@intel.com>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A1BCC0012
X-Stat-Signature: i1ycq58u6bf6w1dt4ztaxrxss5xqft6u
X-Rspam-User: 
X-HE-Tag: 1770374968-725342
X-HE-Meta: U2FsdGVkX1+tH54Im6ayzFumdc6uTBn0mmujWwPfcIiukwUn4HzIava2SmsAE4eVCR5maCqF8rVNADIZhkJQ45RTdgejKmRUA23taQ19Jybtp4C2vcOR74OYpGjgu5Wz+4EKv4M1nfPspnw5yDYGgdPsz7VJeOFecWq6YiCAsw6eidetJHgOajwUefVk8hhLQlK53kg4Y9NpqEyXsZ9TfAcL22kZ0eWbhCS2hLVvKsX++EiJOZmGymfg1Gdgm5GuX5ozaxDIYe3pDZZS9ZVd2ErHmhToFf79sPAEnAqvOyu/5WlhHyTFF8rPRmYCtm/jcPkIocfJvWE2Znwp3+RPdxYv7uPyJosgww9POSqORj6xplGhUKolTLGpKzRW+t44MddLmkUTIax/daLQRSzdayRC46TkNIKy1DesOkIOX8pIh/3qSHByXy/PggAyvmxQgXLBfm1AUwtCcaIqLtUaymLlRBBIuN8CXe6IDF3aBgtKCqkjsJtQRNATvFNKngB2hLnK2C5Z6+9ruvaDIjPTeAdevytQAp01vaEuYZJ4/HdCusyGPjXjzZZ4nI0dYATxA1nW7UB4cdJK3TUOX2qcCYFH0cxSKlUHUeA1LMde2GUH/QC3evUp7hb5BUpvqmMAdHLUIT7ELlCV0nwQ7OAqztpB6moG4Rn1JfN6zABbUc5QbUfmPQ00mpUgD0U2E8OBAw2rxHj5nrrQFMPr5x0X/FYLU2zelFoxwIZKIEIDYz7mMl5ex1LlKJxLimRPtFl9eqy/4LCwwC4mJ34UYnQO1wdzxQNEbj8uopZb+tZSLY7acNqkJp04gCRtoYdlPRyBQvX0ShklReVzPTYNpz8NruKeC5dysHCtDHtgt+ea/H7MGUNDRkQFR7IPATuEHs6U0Tp+Np5m20N2gLYZXJu5W/F9lfO8TGz32rmDvfDURV04AOnUlH70r8ewO5WEPvi0PWmjqpBMxrxKwQb28p/
 dMxSkSM8
 AELew8TiDCQVaP0cywL2oLqbF1sm9sHkGfFTpSveWRGd1ZTU80Weu9TsBZ9UfL4oFPSiZ7ob9H4e2kxNlfaGFor6kL/eBY6LQC3+nTmbzUAEI8iyxUcjI2iUacLESR0UbkECV4iQMkJ10Qq2VdGJdIacxHAR9/T1tUv+KayC1Tog/N2pqk/tviQYblhockJnogOonrVZ4MZEQxOgPfNu055ahP+lTRQlH1IarxVQfmq8j3ViWkPupHR7HqEcGehF8OzLxw5o1QJHV3lw4uP0Y6IX5fcUFUkr4DzWnkY9BB2SzgnO+1jzFT4l31mR1b44EleDh6RQmjB+Yr3Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 07:35:23PM -0800, Kanchana P Sridhar wrote:
>
> +static int iaa_crypto_acomp_init_fixed(struct crypto_acomp *acomp_tfm)
>  {
>  	struct crypto_tfm *tfm = crypto_acomp_tfm(acomp_tfm);
>  	struct iaa_compression_ctx *ctx = crypto_tfm_ctx(tfm);
>  
> -	ctx->mode = IAA_MODE_FIXED;
> -
> -	compression_ctx_init(ctx);
> +	ctx = iaa_ctx[IAA_MODE_FIXED];

Gcc warns about ctx as this line does nothing.  What is meant to
initialize?

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

