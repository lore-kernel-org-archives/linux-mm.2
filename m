Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FB6FCCD199
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 01:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9898A8E002C; Thu, 16 Oct 2025 21:04:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961298E0002; Thu, 16 Oct 2025 21:04:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89E6E8E002C; Thu, 16 Oct 2025 21:04:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 797818E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 21:04:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 081ADC0480
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:04:41 +0000 (UTC)
X-FDA: 84005811162.17.D49CF93
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf13.hostedemail.com (Postfix) with ESMTP id 416F420007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 01:04:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=k2trUUsj;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf13.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760663079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+otO8+xQP5h/AbkUw+yS5HniWJg0TnvYn6GLh2V4iXs=;
	b=LzP6BI68nCllGZwINPxEYwXgbL0LKkF6ubppvEq5mYk7ix//jZePQSSd0zgWoOrSjguATs
	tDowgsKjj05EB/mYq65VtjeyfWnxXBOJwJtEkAHf3MRr2n2e4bc5Eyj/M4IzQ8BwsKmi+b
	twUaddVf2J7zVTFMShbJWjCXNpIp77A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760663079; a=rsa-sha256;
	cv=none;
	b=JDGJuX8anp2IMImCtGAASHfTzC/XdtncyZgyuAlCyRo0ZC46W5FEM5wjbNvEYCuZWIw2U1
	+vj2zuhclUJQ+sRzj4WvsQoe6rvoGX6/T0FTYgHgv18EY+y0hC7gdBUs1N0GZnrkPuO6cz
	N+YDz12czWDLKveA+Wza6l42FGFeAWk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=k2trUUsj;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf13.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=+otO8+xQP5h/AbkUw+yS5HniWJg0TnvYn6GLh2V4iXs=; 
	b=k2trUUsjFYPeZZ1Xmz4s0eIEA7Wkz09DXOODOvy29JYHw0wua64eqVXrymqancOj1qDSGwNsLCz
	nWiRLxby0RcF9kcWZMK/zi3UNslIJBbeCc/neDsgHNCzjcqFIygIIPaEKDtTfBt5E/ucZlsiQkdbU
	FELqK/scO5UYL1CsYNhgMDc5iFhnHeuRSGxGugse+I2TWNk16O2+qmawToB63R63DM4g0I+Ka6NC+
	/YRKNtHlau4tb02hYx1A3m32lwKML0J3g5VQxxkVs+wWzznokomG6j4El2SWpnTejFj2ITPpX66z7
	GkFbiYBErjIFeCG1l/W2B1Ueb8BLHzQUOggA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1v9YtR-00DI3b-2k;
	Fri, 17 Oct 2025 09:04:30 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Fri, 17 Oct 2025 09:04:29 +0800
Date: Fri, 17 Oct 2025 09:04:29 +0800
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
	vinicius.gomes@intel.com, wajdi.k.feghali@intel.com,
	vinodh.gopal@intel.com
Subject: Re: [PATCH v12 19/23] crypto: acomp - Add crypto_acomp_batch_size()
 to get an algorithm's batch-size.
Message-ID: <aPGWHWlsStefuvKL@gondor.apana.org.au>
References: <20250926033502.7486-1-kanchana.p.sridhar@intel.com>
 <20250926033502.7486-20-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250926033502.7486-20-kanchana.p.sridhar@intel.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 416F420007
X-Rspamd-Server: rspam02
X-Stat-Signature: qjy4ayb5kus9nne9dxcbgqkc4fede94m
X-HE-Tag: 1760663077-486318
X-HE-Meta: U2FsdGVkX194h3E7oHSEnn0myNDfExt53uWBlx5y4Vjh7wBkHHXoSYDlVeOKwO3mWueJmaakk1/xil8IUHCZ5SKxc4ZPfbzuMO3F5NkYLu03KgKNQWudbTupwkzg8klmENxk9bpTvlUHReDuN7T8cCvTrfVlel8iK2ayIGdltyVreRKTr4hmhjQg+ohG5rpnz1CyNaGHw/K3RbFWy5DTE3+B2WeZ1wB1OWKv8u125B7la8tjzh7k0BhrMsj6R5j7E1irNvWKnHuh1tKbdyup/wfGf73tmguK+9OHMroStbL+/hKQzepORo6HoYLomFCSpr5vTzHkInRK2YfR758tBaVlwajstlJ1A4DCyaFv8Jlxssrkw8wGkXy+DoXwqIoilm8XlmJ5rf2cXLL7o/6K3Jtxpe5Zp7/oUa5yHayFo7UHl7O3ffJZBDMMzr8kCygn7ykFuo2699o1QJcwMoJTQahSBE9AP/ae/lA1u9woVo5LzGbW5zG/spUafe6Y65HHMDN53h/N8m+0aymIXY+SJKm1QJjuwaEtoe8JgTGAsqHm2f5HvCTf34/2kfN2Jlgko+h2kG8WMYi7MPx5N40ZFeyoUFO+X57wnYv4OL3k60Qz6h8IfJPBQyREnn6l1+cT79OSSlBptNtH/E45a+1o9Tn6ahNBEOGOAvySU0yLjo15rvIaoeQ83FHVPUOOQyJb5T2HSo0Zr3dsdVy/LmTnawlg6b+41OOhuvGW7c1cnZUhcE62+BPfHLIxJLCU3TpuXc5D5/cJmvNBkSI0qCOQbQE7ay0hYezvnY2TRjX2kN3qOZpJE7vDdBRCjhhvR/LywbEmGUn2ZolB6KqpROSWuxDi/0gGP3DKRrqiMlfi39HirpPrmXLqEmu19Gn+s5dL6c1bhR/ZRYaSrtMJ5ZulaLVW4ulxe/HLfEoyxJCe+xkFngDPkd2BVNVK+oCQPXw/kwRDBzz35MVBSwSCZQk
 grVecxX+
 j+rhbrNszaEszwf9pTTYputhkLa6rOdI1kJO/Ca2WoAvJCSmvk21NQ/Ix0ngqDrpZig8JJlDGviOruElFSxDQ5kC3uwHKDLzp6nT53VfMS9yZTF2mOlSWdeWchIJq//Kp3lbthavhdKcJ1xbvOTRjBEpN+fss64qan6JtTYuhbpwIYXtxOdeJPbnX9CIAfP4upQ36jKbz1attRnnXO8ZGZa/Yd5s+3xvNYuxQIppMcC/yn+3v/RgNya23MyJH8iO1JUbRURpzoiszXFBHlvsT5h46cStd59PsVHfXogo+4WR70t2/umz0Y/wLzFILts6a6toX8R9IsPn+S0Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 08:34:58PM -0700, Kanchana P Sridhar wrote:
>
> diff --git a/include/crypto/acompress.h b/include/crypto/acompress.h
> index 0f1334168f1b..e94046529e46 100644
> --- a/include/crypto/acompress.h
> +++ b/include/crypto/acompress.h
> @@ -108,6 +108,8 @@ struct acomp_req {
>   *
>   * @compress:		Function performs a compress operation
>   * @decompress:		Function performs a de-compress operation
> + * @batch_size:		Maximum batch-size for batching compress/decompress
> + *			operations.
>   * @reqsize:		Context size for (de)compression requests
>   * @fb:			Synchronous fallback tfm
>   * @base:		Common crypto API algorithm data structure
> @@ -115,6 +117,7 @@ struct acomp_req {
>  struct crypto_acomp {
>  	int (*compress)(struct acomp_req *req);
>  	int (*decompress)(struct acomp_req *req);
> +	unsigned int batch_size;

There is no need to store the batch_size in the tfm.  Just return
the value from acomp_alg directly.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

