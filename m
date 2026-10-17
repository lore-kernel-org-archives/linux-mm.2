Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C53DECCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 05:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B31526B0088; Sat, 17 Oct 2026 01:07:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07196B008A; Sat, 17 Oct 2026 01:07:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D116B008C; Sat, 17 Oct 2026 01:07:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CC396B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 01:07:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B59E380218
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:07:22 +0000 (UTC)
X-FDA: 85330934724.18.98E36FA
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3DAF840002
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:07:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=KorvX6et;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf04.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792213641;
	b=jxe8hG64SdixN9zGMVbBOHMabNV9CtSQ/EgfgC9jkzURJA1+lHd59nsxjnYIca2DbiXD7c
	UdC1cH2NF+2wJRv1jz3c+Mlhm/YxxEqjpTpk6DNCI/sqHOunYFnwZCwqplAH2QRlEbbNQl
	PN5UMKxzIjP5G4IpFjArlN+UiOIQifs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=KorvX6et;
	dmarc=pass (policy=quarantine) header.from=apana.org.au;
	spf=pass (imf04.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792213641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GS+AsPIGu7yHRqy2jnr1W3dVbHJLUv2AWFzFOh/wFDY=;
	b=ggZbd0LoB+CyOMvh9VpUK4ygK1pyJ5UTxlmCsVO1jd/6vgzBGvX+7+msPWgrCtjtMuwOpb
	tE48bDwkgpSQpuIjze4Vx7IE8fSisANAjyrLGibf9IUnaDkddd1LEdgi3OdQwZmJFNRaiO
	EONnzy6kNZkF31ir+FXuYkq4U+335jA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=GS+AsPIGu7yHRqy2jnr1W3dVbHJLUv2AWFzFOh/wFDY=; 
	b=KorvX6etA1H1LwYIHbjwREizKszwt/mxjdfcD2DUylxpmdQYv2zpOgDwRmP3YPR0RmUpdWJzQGo
	oPQjy4KW8cqA89aYUI5lEIpnepflISPJVyh43PIXf01uhiXJsHVmc8KG6lvkfNzWa3o+4ccLxYzDF
	xcExs5PGftzWLR1dcge0eepyH/FsiBSyR+QnUgSPGvbev7iTd2NPPiL94Uj0KrmY9TM4/3LsBMP1S
	YfbqM04tYbW/ZSI7dmX3kDOqVLbPxO4WHZbxEIFxkv1zLB7XrSEXc/JnWqU1FsoAgs8olJHf2MHJq
	pp/6MNEQiBIGs3aTInov8ui1iePsiz84tT+A==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.98.2 #2 (Debian))
	id 1xHwdS-00000004n42-0Bu1;
	Sat, 17 Oct 2026 13:07:11 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 17 Oct 2026 13:07:10 +0800
Date: Sat, 17 Oct 2026 13:07:10 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, hannes@cmpxchg.org, nphamcs@gmail.com,
	chengming.zhou@linux.dev, akpm@linux-foundation.org,
	linux-mm@kvack.org, davem@davemloft.net,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
Message-ID: <atMCfhB63koot230@gondor.apana.org.au>
References: <CAO9r8zN5n=9v4K+OtEEODg=e0kcFW99PreUcZm09q9CUMQc+ew@mail.gmail.com>
 <CACpmpofdoeVbbw7izCDeJ7eS+XpWj+3sp3teKEQWywyRB75jYQ@mail.gmail.com>
 <CAO9r8zMaaUsBaS0TJumochRKt2ShV7nRaLnYPWv3=S-wUFgitw@mail.gmail.com>
 <CACpmpoecz4tjr-qvFRy22CGuF+4NBWbE7HVjdTGFqQOheK3CLg@mail.gmail.com>
 <CAO9r8zOAcf4=TscCXjMYvowUx-_u9qLGqY2-p7cK-z5CUU_x8w@mail.gmail.com>
 <CACpmpofYXDMviE6FS-BZdVntmQFvS+_xvfmOnJ2caZFerz6vyg@mail.gmail.com>
 <atGqPIpUfX0LDokV@gondor.apana.org.au>
 <CACpmpofyLW5z1DYEY2YAty0VOAhRR+Leic8O-B0N9hrzdW_=Ew@mail.gmail.com>
 <atL1ok1YkHbA4AaI@gondor.apana.org.au>
 <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACpmpoe_RXcJM42sTVwk_Qvt3zjAOZhzYZNsRD4xz_1HxDmadg@mail.gmail.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DAF840002
X-Stat-Signature: ndyzurbjf44a6oj1ni4mbidtm78y6mqp
X-HE-Tag: 1792213640-747165
X-HE-Meta: U2FsdGVkX18IF7sKWUI/UslBIbBCLdYkgaSYL72B/OTrHR5khw5EztXWyWFpZGXuTduFd8vdSXAattW6wt7rfj55FbI7M2c9AbrUDie5qcmRIVw7PnluBxwmfU7ox3NLdSYT7bLRFXdFGSOYIGAkBmcxDeqIz8xqYFQSrZezs9xUreyGIr+SUmC6Q5mRvJJmz6ivTOEMHdzZVBq66R9Fj/udw11IiuOu/Aye5SIQ3CTDvcVsts0UfLuPD7+kfc2OHZ09KSfhu7z3vZbRwVvQfI2UmPObffXX1ycBs/Ui9qGiKdtF7WKuB+4x+FG2LSsdZepUXNdtriStIxH/S76KwSPAD1n+GQ2aT7+98J+pidRx9Oer1bRg1TBhBNPxaySMwPZQJWI0JgIl6JoZxkksbxzA1ObIwYLL58/oIy6wlbu6EcwVLLTaj5URVaAR1ah4JM3QcVW+JwPQ72nMVzpmBcjhThyUoydZHA24Wc6iHNSLvxLGqV9b4deXLbxyh0bei9Sfk1p3LV74V6ZjWJkUcHIvH1bJjUfWEftdclMYyRnljJ4J9OqCuQBXad+mRSKmzRv/L5C6xaE2JngHtGu9eVRZEDNX1oMGm96jfQ//MJd5s4eA4B517yGm/DThfJ81zCQAVg4AIwasNlvPbDf+Z5kTnMoFZnGA4bGx/PvzHm05gb+fMpfGiuM0wmezmuWY5mb5O31ofyo3GWa3e3472KALplVl1niAE6tJbSTYm+DLzFheCtFOT/1tZrpZBKmdNNQOSPYlNZ1zLtJiYUkHFsd3ihBkO6EIBzvW0iZBfxRt9jAcW3n2PGnOsTUnjBinOGpHM7IP4vnkP+g4s8M09+MjmtE3O6g9wnoTUfPVKA/s2Iut8qkmEHw9REBuyVQpt6i55V4bh+n4kIuy1zeu3rvKaCZdodlwpOtrncOA9L2s4Hp6dHB/D9tSAx3M9uxtm9hFwTJIdv7UUr5hUZs
 no99AfaP
 c9qfht+E2Z80CiTbd1vbAxLy+XLq2zIDbVFCP0UV5xrnS/+TsxTaUbC/SOwMZx8yy4ryZYa0I7ROLTISvTufQxBjd263RM8UiQuZO/IABK7IjHCrQn2LaC/OOahK0mbrhdnntYEQ71u7IRF6YmSbhbEswrv1jojnR1bKYA2bPU/b5o+R9eWySyE2TmVTgtLwtRzbfqQDCuAZQ1CHpWcYma4rkPNK0+fBhDXXxexj60/sRa0e2d1XFkpuqEUJTUlW1t7gSncSZ2V2x8par+l9yfJdkapJY4ZpcLmtDwFjaJuver0tO6JXi/pwCd0dbMQ5ytWUGgMzEl+T5V7Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 10:02:13PM -0700, Kanchana P. Sridhar wrote:
>
> > What if you just do the conditional and short-circuit in
> > crypto_acomp_compress?
> 
> Yes, this is the first option I tried (20,946 KB/s).
> 
> [1]:
> 
> int crypto_acomp_compress(struct acomp_req *req)
> {
> struct crypto_acomp *tfm = crypto_acomp_reqtfm(req);
> 
> if (unlikely(acomp_req_on_stack(req) && acomp_is_async(tfm)))
> return -EAGAIN;
> 
> if (likely(req->unit_size && acomp_request_issg(req))) {
> if (likely(!crypto_acomp_req_seg(tfm))) {
> int err = tfm->compress(req);
> 
> req->dst->length = unlikely(err) ? err : req->dlen;
> return err;
> }
> 
> return tfm->compress(req);
> }
> 
> if (crypto_acomp_req_virt(tfm) || acomp_request_issg(req))
> return tfm->compress(req);
> 
> return acomp_do_req_chain(req, true);
> }

That isn't quite right though.  We need to ensure that it really
is a singleton before taking the short-cut.  So you need at
least one conditional:

	if (likely(req->unit_size == req->slen))
		take short-cut

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

