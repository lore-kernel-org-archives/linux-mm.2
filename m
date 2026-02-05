Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D7E3EA7966
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 04:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E01D6B0089; Wed,  4 Feb 2026 23:14:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 762F66B0092; Wed,  4 Feb 2026 23:14:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66F036B0093; Wed,  4 Feb 2026 23:14:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4F8E26B0089
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 23:14:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 62E6C8B713
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:14:30 +0000 (UTC)
X-FDA: 84409086300.03.CA898B7
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf21.hostedemail.com (Postfix) with ESMTP id 579781C0007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:14:26 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=MYC5lhn3;
	spf=pass (imf21.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770264868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMx5++hqTDx6tKIwhTEaQVGCEoE7NSzZhFlhgtkzgJ8=;
	b=3qRl4qXZwxt7W/kvbuIy/qJLE8spE4nixVf3M9oBZyTSSXw+1llToe6hUWtzMbvmYNK9+3
	rgjdGe1GZeUA1mujFPCAXdrNuvFQ3Tm+SSdKMTWeKDjQxvdkWiDg4vec3Y7vsT9ET+ZDBd
	nry3RBX1UB29Hs5EpbITFg4PDN+0BOY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=MYC5lhn3;
	spf=pass (imf21.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770264868; a=rsa-sha256;
	cv=none;
	b=EzPDE6oGYdarcbM76JrbsOfcfE8xfGE8JmghGQ/qFS+j9aq/oeZXLz+TjH0z+QLh5bAlwk
	X8UPpJAkdGvl4lISO085NEwyFvH9LS07fdBVP12G2krY/EqMBiHXUOpajaCgf86FLhVxHg
	QeWw4smLIpyLiPVB145Ye/TVBZOVF/g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=DMx5++hqTDx6tKIwhTEaQVGCEoE7NSzZhFlhgtkzgJ8=; 
	b=MYC5lhn3Xb9VliRDwDDj+7mVQ5zc90uaoT96vzZ74Xj3RjBdPHqQDqwQJLzx3NLHA5xH2ZPVB4/
	1aMVBBHzcirjeqbe002SWDDEQGqXyeokqqLAVERFw3JixvBZC5UAU+pC+Z395lv4G77hGGh4ilqHo
	JSUdWrH2SpzoWJMhcurvVoefmU7Nms/5iWeWhrCLd4z8ObSmppUGBVfEoFpZ60qo0MkKunaaVuGzU
	tAExBWauvS3WjCB49Phe4G5EiSjtEpf/x2Q+5De4wV8o1HvXcVMG2bnc72YO7BFe0oodOMOx3DgIo
	QdzvHjn/7KXKyrh/yE60BAA4E0S9i328ea+w==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vnqkz-004dup-2F;
	Thu, 05 Feb 2026 12:14:18 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 05 Feb 2026 12:14:17 +0800
Date: Thu, 5 Feb 2026 12:14:17 +0800
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
Subject: Re: [PATCH v14 18/26] crypto: acomp, iaa - crypto_acomp integration
 of IAA Batching.
Message-ID: <aYQZGXue0F-S_Zqh@gondor.apana.org.au>
References: <20260125033537.334628-1-kanchana.p.sridhar@intel.com>
 <20260125033537.334628-19-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260125033537.334628-19-kanchana.p.sridhar@intel.com>
X-Rspamd-Server: rspam12
X-Stat-Signature: 4b97inhbkoc4xtzi57r5gp3p4d7utbqa
X-Rspamd-Queue-Id: 579781C0007
X-Rspam-User: 
X-HE-Tag: 1770264866-670012
X-HE-Meta: U2FsdGVkX18d4euozr55pGMwpN5dQkLPgNttJPVejpF3GJ49Uf8yPlh0tnnKfhNnxvLmn1Q9Qyrq3G1qQ2V7dUsg0t7AC89qKfZmfOApJJb9OxNOwrzG3LxU108X6sRDpLc/IkBcHvemwGi1o2uGq9GrNoQFhHQ9+1WsGAcVVnseVnKsPQ48eLjNYVuzARovUHea3N5eRv6kGsSvnOMEQiy6czBt2bg2KNgfD66NeQhm13O2vYUP+M8GW8ehgS9lRIJaNepRTLAEIqoZtTrE7c5/Q0kyWGwkFpi/sa/jRUU9ej2X+h5dbJ6JXeYhI7/rIrc1NESwyVf55/7m4dEDFXWh3YOS/7L2PgKKdDGQfsMOw8UdGrKxr/daYucHh5tCswtVdmr6aesKFGg9lJwp/maVJ/omGIJXw2csW96K0MWJ0efmnw26D15TGGv21Dx6sbnYk0m7w+zhLPHxzZ+PwYm8gbjgtDUi7izvzdgDF8svhstGSeKwxXoYjOTrReG0myVnH5iTfBLKAUj6UibKGQM1ZXjGei+Oo9qzN2f+3mgOn4zUPjnlDYB+cZVBergD70ykyP2N1cSUhpjvVlTIfZGWIc3fOiw6P2oDQeQ0uHA12GUUyMv6w7DXV2fc4T5lpc1L3dx3ekYNoXQPv+hiMBs8CqvOSQFwTHZzfUAJqv+4J1IiYGjg6oOhfsoYK8JQ+kFGnE6ZKgXBodc7nDWjO9/nHMCRtaOePyY08p0J5A5tLMLLPFXa73VpnzyKfnNjkXa57prBo/AMPLAatty8iVSs9i9EXcqSo7Pr93TwRKbe+fsu2566v0P0DCk+HF3vQ60wltBLtTP+np4VCriw/uakBHcZMFOc/fSWv9FvnDVD8b+9nYsrCo4574hBb4EXCfHvsHMW4YaDU8B/K2Gd8IKgY82hR+8K3WNodDZKZll/qIn59KN6Ykeq8ELzee6G9Jdhe0wsjpsuPANKpHa
 QwDphT4N
 JIFdAeK/bKqLOszAcas+elL22ZpqeNvjSOWGD5PbYCpLjVoqCy21u6th/8R9CFNzfEJ0SR8TNOOhVfAUCzGzmuMsegvk9kfPlm2slFyIIu2kkLp9PbmTRix4OXiKNH9ZesndgWrj+g1Do+5TGnDVfZtlK3oPQkuvHChd32GVU1pvgRRJssOlYtud4BMxtHw8f68dULB9baY9TrlWAXGtaCs5N8UW7UkNWH20WmRJCTQQWPoUGfBcf7PMWY8oM0qpPd/8Sw4KTEVvjVXWsp84LvA7Xqk4lJ4rNLN3sBS4ivkkhwmkwGY8G+BuqBuoRNzU9k2cgdb3WH5SPgjw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jan 24, 2026 at 07:35:29PM -0800, Kanchana P Sridhar wrote:
>
> @@ -291,6 +292,65 @@ static __always_inline int acomp_do_req_chain(struct acomp_req *req, bool comp)
>  	return acomp_reqchain_finish(req, err);
>  }
>  
> +static int acomp_do_req_batch_parallel(struct acomp_req *req, bool comp)
> +{
> +	struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> +	unsigned long *bpwq_addr = acomp_request_ctx(req);
> +	wait_queue_head_t batch_parallel_wq;
> +	int ret;
> +
> +	init_waitqueue_head(&batch_parallel_wq);
> +	*bpwq_addr = (unsigned long)&batch_parallel_wq;
> +
> +	ret = comp ? tfm->compress(req) : tfm->decompress(req);
> +
> +	wait_event(batch_parallel_wq, tfm->batch_completed(req, comp));
> +
> +	if (req->slen < 0)
> +		ret |= -EINVAL;
> +
> +	return ret;
> +}

I don't think we should have this in acomp.  Just return EINPROGRESS
and let the user check each unit for the success/error.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

