Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABFBCA0ED1
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 05:28:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD9528E01D4; Fri, 15 Aug 2025 01:28:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB02A8E0002; Fri, 15 Aug 2025 01:28:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEDAE8E01D4; Fri, 15 Aug 2025 01:28:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B0E3F8E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 01:28:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3686C138AA5
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:28:58 +0000 (UTC)
X-FDA: 83777862756.30.C7944F3
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf14.hostedemail.com (Postfix) with ESMTP id 48049100003
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 05:28:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=g4qYgRzm;
	spf=pass (imf14.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755235736;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KolVN+Kf+xjXZURWyuqMGoPAKUXu62zPPtuevoWeXKo=;
	b=2dv1skaU8UdaBEGxfafp/FeoueUWGIv0IFIP28m9SHApG0vTxP0xsGSLg/fVCmtsy4CnOy
	H1kxTIk3KSBLk07e4Iw1FfU7IunKHhGn2EK84iSBiySpfiqdW2BilAzWyLO+0Pu694YYef
	6/8mGj8wlfdLpNVrhnjtopdEw9Yl/BY=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=hmeau.com header.s=formenos header.b=g4qYgRzm;
	spf=pass (imf14.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755235736; a=rsa-sha256;
	cv=none;
	b=EMODQ+MTBkdvhCru1GfPIjryeQ0jMmrGs4EoSM5AxlDhQAKAzFP0vZhB9HA98cnmiQhOnR
	B8MueUbHqK7T4akXpPLDEdwcRhXwtE3QEKKM5v5w741EphemAvx1scQvEtRFDOPceUg+Qi
	ziqYHkCj7s+bZDMG4dnBPjAvf68emVI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=hmeau.com;
	s=formenos; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=KolVN+Kf+xjXZURWyuqMGoPAKUXu62zPPtuevoWeXKo=; b=g4qYgRzmEMeOBNMTs2dTafhchU
	zcaAwE8qDO3V7gNpW9AV1hB34p2tr8XGtw9HhFuD4R0eYHKnVIAqKNwx5oGARv300JgHLDogSkrFh
	vEJ09EJm8Hd6SmpMk6NLUr+YCaEtPpDxgo8w/jODnDgUQGjPdNcmf2geGRXHaTPSjZGM9MPZo6oXg
	FVzs8tbagZh/JFxeENUzlhKqAvXnNwNFIfPCQuq4nXXAfzPPJPXOiSMnOXjzkjNJi8VsGeiAqHapl
	k9nU2Jh5+0lrMCLcjixa0HKMEWg1h0eXK+a3Fkn0f8LquW9bG17qqsWYylQX/IIvNHAkc2TG9XoZE
	u3GQBFSA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1ummkJ-00ETYr-1X;
	Fri, 15 Aug 2025 13:28:52 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 15 Aug 2025 13:28:51 +0800
Date: Fri, 15 Aug 2025 13:28:51 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
	yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
	usamaarif642@gmail.com, ryan.roberts@arm.com, 21cnbao@gmail.com,
	ying.huang@linux.alibaba.com, akpm@linux-foundation.org,
	senozhatsky@chromium.org, linux-crypto@vger.kernel.org,
	davem@davemloft.net, clabbe@baylibre.com, ardb@kernel.org,
	ebiggers@google.com, surenb@google.com, kristen.c.accardi@intel.com,
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v11 18/24] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Message-ID: <aJ7Fk6RpNc815Ivd@gondor.apana.org.au>
References: <20250801043642.8103-1-kanchana.p.sridhar@intel.com>
 <20250801043642.8103-19-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250801043642.8103-19-kanchana.p.sridhar@intel.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 48049100003
X-Stat-Signature: aaf1cacpsz3waqzd3xxmc6hytehjqbyh
X-Rspam-User: 
X-HE-Tag: 1755235735-85538
X-HE-Meta: U2FsdGVkX19/+zQJhurOY7rt2WsSIA6dph6FTT4+/jzinJZ4S/Xci+2ZY68qWZnVhXSwkLJ64f9a6BM97W//cbrsVpZxV+E7KCj2m1Uj8iOOKMx+kcZr+Xu54iJxxoCnheDWmu0/iT8a3S44yGa4Pi12bGfHkqHcMK4LF5QYaafbPTzy/8l9yle4Ml2Qn9BqdbkHtA3FxAhngCAZWSg3tYY4GWD0LrqVkAqtxQxuex2t8CkG2WXWzdTibnyp4E8H0SkMi+Nyrfxl3gS47cGmz4ExXHVp7BoDOM9wRNetHOs9FGw/DOpo6T+9iYpyTK1ioVfzUPFMVStxPREJAbeczkvTse7k8hIthO6JleMQf/0RPOUeN4WLYI0MWe9UXbqmyJ/jbAmXcAtBM3KDgoXyZ5vzghh/z3T6QKxxUaxe9yCxdWXFKuLN2ytXvQ3iJpWc5OZ48ZHOJOaMCdZsxBXDbc+Je4EAvy0GSDkROgVnSNcOFBQXhnHUcTDUGKpRKH9An+5sBv0+ogrXPND4MdNGrqfg36ZIRXV0xkHRolqqtp3uHGFt5+5WYcMP68yrZiNd2KDnerXhXSQHWdJxslTb/bLKX+9XWxlXjHA/+PAdO9RVGcqCv3To7W41+hiqptu8cyAFuJBl8NfHGjYbjX/rwVoLRqQ5wtgTa+BvQ4hm7fUpEdlTDaYn0mHbPE/fOxET3c0S/kR/kJYenROs3Qo2Z+51YJ44HMZnUOOxGhSDn+XoaWDbheypm3sVgDj1pAvXanFJ5t32uaJM3wf32bhQmg75SjODFCCBMMDpKn2+w0XOoYNDqnURwruoHGsFiS49x2mD1n1T1gHINLTGedT5dMDpmTKRf63R9tqEHJLl7FaVQWrV5zlAyP/OetQVi9iPKhzXzCGFcN8pbztyxNNhFee+AGSOM9YEnTfT5eEPkIDitm8xc/EzDVI4+WdtKNGwXWlk9ov5HyRgdl/Zk5t
 mi6gMi2H
 +h0K0hd+wx3dI84oAU4s/ET2EZh0VD8g25OBQnGU+gOuUkl4QAzjygYBtEbScQepq9F5mV3SSNFpjb75d7OFfEn5gSncFaGHjJngwyp0CdT0P6zr0PzfncLEvklQ3vHfx/e1veNPE5Jo2/n/7H8WRyepcwTsvNAeSEziNGON/tpOt9mC9sSK+SXMlOyreWj4CiW4OZyPndj62xDWgZnEb9fx0RkATrNy7QE9yjB5KynP65C9dXJn8vqkuEUKn+MPFU1bauULKGfz9u/neeOpg1BUkDXq6CnOkBwRnY3/JD0M64/5qylwA4rljCqVgdlLk5Eqr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 09:36:36PM -0700, Kanchana P Sridhar wrote:
>
> diff --git a/include/crypto/internal/acompress.h b/include/crypto/internal/acompress.h
> index ffffd88bbbad3..2325ee18e7a10 100644
> --- a/include/crypto/internal/acompress.h
> +++ b/include/crypto/internal/acompress.h
> @@ -28,6 +28,8 @@
>   *
>   * @compress:	Function performs a compress operation
>   * @decompress:	Function performs a de-compress operation
> + * @get_batch_size:	Maximum batch-size for batching compress/decompress
> + *			operations.
>   * @init:	Initialize the cryptographic transformation object.
>   *		This function is used to initialize the cryptographic
>   *		transformation object. This function is called only once at
> @@ -46,6 +48,7 @@
>  struct acomp_alg {
>  	int (*compress)(struct acomp_req *req);
>  	int (*decompress)(struct acomp_req *req);
> +	unsigned int (*get_batch_size)(void);

I can't imagine a situation where this needs to be dynamic.
Please just make it a static value rather than a callback function.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

