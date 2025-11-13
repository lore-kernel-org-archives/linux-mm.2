Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9A52CD98DC
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 20:26:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5658E0007; Thu, 13 Nov 2025 15:26:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1CD508E0003; Thu, 13 Nov 2025 15:26:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 109E28E0007; Thu, 13 Nov 2025 15:26:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 005DB8E0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 15:26:02 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3D87855ED
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:26:02 +0000 (UTC)
X-FDA: 84106715364.08.2AA1392
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id DE1ACA0003
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 20:26:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKyNhrNw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763065561; a=rsa-sha256;
	cv=none;
	b=OsjuqJjCvVjjvnA4MOZv3Z1O1VKu4MqFKQKQ+gEkSJmBUCj/jMxTL91mWmR+4E9PmHf4Gt
	zpL19zs+2JmCKSD0GeqUgYK1UQczo6GeVanNHhiM69ZMVRwx8L1Kq3WDdsVFMfnFhHqIJX
	0ElMMLp8tJISVJW+Wzn6itof+jiLlfA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BKyNhrNw;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763065561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JxfMEHb09Ixm8iqYkNkNYHc7f7AyW9umoGrG0t4Mmi8=;
	b=RGeb/U+JVaHqNNfq6DAaYcYApDxkV0RrJU+guKCIKH2kq3EPPZrwbA6Hm4HE1g6A7F9jYH
	EorUoKEH7d8Ih9eRYJ7zCGFvQCrRDzcl1ZXLfX9Ppub15MpNoVOYuNLBGsM5/5SL1xoqLu
	qU6AFC/ETb0i8+uXnoXcEYu1YQO+SKY=
Date: Thu, 13 Nov 2025 20:25:45 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763065557;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JxfMEHb09Ixm8iqYkNkNYHc7f7AyW9umoGrG0t4Mmi8=;
	b=BKyNhrNwF8t6KIJPv3u8VI6tLHV+cMp5wGdxr4fiOceyNCOsAao2WPZKibM6R2rrnw7Z2G
	G3fF5UobVl/uTM0M30jLnJhsDJtLHfUQzdoCocHSPF0N0jKc0C4HUYNBUYNTksaKMZS43X
	J83FHL00x1D7Qd54mfmrZ30yv99IShI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, usamaarif642@gmail.com, 
	ryan.roberts@arm.com, 21cnbao@gmail.com, ying.huang@linux.alibaba.com, 
	akpm@linux-foundation.org, senozhatsky@chromium.org, sj@kernel.org, kasong@tencent.com, 
	linux-crypto@vger.kernel.org, herbert@gondor.apana.org.au, davem@davemloft.net, 
	clabbe@baylibre.com, ardb@kernel.org, ebiggers@google.com, surenb@google.com, 
	kristen.c.accardi@intel.com, vinicius.gomes@intel.com, wajdi.k.feghali@intel.com, 
	vinodh.gopal@intel.com
Subject: Re: [PATCH v13 20/22] mm: zswap: Consistently use IS_ERR_OR_NULL()
 to check acomp_ctx resources.
Message-ID: <dcpuzzl4bqnuhf7tshead6fatbjre2uo5kybdzllsjwkpvbv5a@kqbja24fetlb>
References: <20251104091235.8793-1-kanchana.p.sridhar@intel.com>
 <20251104091235.8793-21-kanchana.p.sridhar@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104091235.8793-21-kanchana.p.sridhar@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DE1ACA0003
X-Rspamd-Server: rspam07
X-Stat-Signature: f91z3t3puncnihjj8dxwjg7dszn3aegm
X-Rspam-User: 
X-HE-Tag: 1763065560-638929
X-HE-Meta: U2FsdGVkX1/3UZADbQC34pvmtAzmb330W6lWNId2UYoBjJ27Mj2PWJ09YVsXfKZJurOWkolJ5J8ZZTR0X+qJlQkOq38V+2CjjvCaPfzr/uHyx4jR8tdlaJV+T2AYJJC48Z/eT7OmFPf/EeHw5whUb05RXsKI6EUp5byuGD5h0aoSAzg3aD5DoAJ7BHYmyLybn8nWCI6xhF044CohuWe5xazl1hXE6Yr0SBXZzKIDGL/PkV51prgbEmUqf2x2z/SoSBx8+W3mE4XxOPJQcXisOkQrckvDJ5jVxViPVYSYpTYgyf/nZdUW5oyBiwI0kkqlcl6pcKyDPBzYuNjWzOB26ZCR17nm+oY/3W40fN6w4VdF9elehSZAy6WvGuOmaKegSH7GEP6tFC48pzfmZtJ286fShSvDjAgLjQNKGf7R5ZPg15FMQVNzaa4+C/uhFtsd+jjVhlC6IPqeSz+KwbQq3fxQfPgdkPb7cnTY5uhM4Zscek9nQFDbYqO21q0PAKrJhdiY1JCel77wMvbv+g621Xs4aW5VBOmVItY9AVVTx3UWgdI9I70IlCRZEpRNSrRZbHJdDbF5BX3mtYkjJRoI6cdLlUp7KiOVIpB5/zQs1oe5AdCHcP76rO0nyTEnBqljiyZaqqoD40ODf3yMihhkkzpWo5yTvSbPUqrPmyZl7+kiVzMT9Frp5u/p4kH99VB93l5hTX+j1nxBJwPSl9/PL44C2rd3jMs4LGPiMVwMogo3NM3oJIqCJU+fX8exYrjvrOE6ZSk/zw1M2XQMpfPXpildrKr34m8mhcftpZqd5FBDgP3BBPZH+ERMbHaiv/yx4FFeMzhRnmWPBKG2dGHtmWfCqJc2Bdvc5ecx3E2ECsDTYGTW0621ZYrwIkgWca0ruTm7DRmgPwndOIqBIWOaUsQTLy0paEloNRuPyLhgoTlJfrl6r+WmBULFzo9TfH+glgs1tVvFTEmx0rgAD/S
 dWqQHyou
 12T9tguGodu/vuTDNsgk4c2uRlwecrXLi5qz+ozBt1uCRsjcGQ/l/gIztUrtUPhDG+YoUrNZ+Gb76XSbdkRUaDVQn55ed2o0ltAgSeIatRjBYaptNZ1uKx3SqE4Xii4YYj3HqqEkfmaWP/cfziOj02UW+0I2bope4JWhlBktOv5iAyS23P2i4NiTUuAuk7HadOdUXYBED12+xz10vfUoEjOs+I8L32CfbzgTdcb+WggxbpyfhEINezPtTfXCNwzcnmjjHATd97es6LOGB5BBf0/KhkZFXlskcguNO0ER0+rdgek4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 04, 2025 at 01:12:33AM -0800, Kanchana P Sridhar wrote:
> This patch uses IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check
> for valid acomp/req, thereby making it consistent with
> acomp_ctx_dealloc().

Instead of "This patch..":

Use IS_ERR_OR_NULL() in zswap_cpu_comp_prepare() to check for valid
acomp/req, making it consistent with acomp_ctx_dealloc().

> 
> This is based on this earlier comment [1] from Yosry, when reviewing v8.

Drop this statement, it loses its meaning after the code is merged.

With those changes:
Acked-by: Yosry Ahmed <yosry.ahmed@linux.dev>

> 
> [1] https://patchwork.kernel.org/comment/26282128/
> 
> Signed-off-by: Kanchana P Sridhar <kanchana.p.sridhar@intel.com>
> ---
>  mm/zswap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 87d50786f61f..cb384eb7c815 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -780,7 +780,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  		return ret;
>  
>  	acomp_ctx->acomp = crypto_alloc_acomp_node(pool->tfm_name, 0, 0, cpu_to_node(cpu));
> -	if (IS_ERR(acomp_ctx->acomp)) {
> +	if (IS_ERR_OR_NULL(acomp_ctx->acomp)) {
>  		pr_err("could not alloc crypto acomp %s : %ld\n",
>  				pool->tfm_name, PTR_ERR(acomp_ctx->acomp));
>  		ret = PTR_ERR(acomp_ctx->acomp);
> @@ -789,7 +789,7 @@ static int zswap_cpu_comp_prepare(unsigned int cpu, struct hlist_node *node)
>  	acomp_ctx->is_sleepable = acomp_is_async(acomp_ctx->acomp);
>  
>  	acomp_ctx->req = acomp_request_alloc(acomp_ctx->acomp);
> -	if (!acomp_ctx->req) {
> +	if (IS_ERR_OR_NULL(acomp_ctx->req)) {
>  		pr_err("could not alloc crypto acomp_request %s\n",
>  		       pool->tfm_name);
>  		goto fail;
> -- 
> 2.27.0
> 

