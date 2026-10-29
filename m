Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A69606A320
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 03:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y7lp57MK
Received: by kanga.kvack.org (Postfix)
	id B10486B05B4; Wed, 28 Oct 2026 23:06:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8B66B05B5; Wed, 28 Oct 2026 23:06:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AFE66B05B6; Wed, 28 Oct 2026 23:06:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E8296B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 23:06:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBD45A749C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:06:04 +0000 (UTC)
X-FDA: 85374174648.12.16FC448
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C45420002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 03:06:03 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7lp57MK;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793243163;
	b=uJDQea0CXcCBn9rwk2lbsFMHMVDwQbyPdULoRq9myI/kTS2P27nTKcwuLXKcob7hwlB5OJ
	jkazrEU3L859Sf9niyDPnENQjv+MWofPNAY9zUrSrdB4dV8OBwnWgDkIz/N6KZWBQKcDlv
	nOqloTJEtd9XpgDPPAoDRSfGdmJIIrU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y7lp57MK;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793243163;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ggG4r95jRpXsMfothCtjRrBypmbpmfyn2VhHQxaSWzg=;
	b=MsPHrs9ZKm8VYb9ZRho1lfq1Z/3OteTeLILUzZSX5zuOu7gSsNsNXwr0SIaQbPLy1d5FKf
	esJ94qJGBpC7F02Dtdp9UHJoNi5l74xgpmsbXh0IBs+4NSUOyb4VemzAlEaH3vjp40Hr5c
	l1Rx63GlY/8cKSsS1IuEKz/DyR6v76I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B10A4010D;
	Thu, 29 Oct 2026 03:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736571F01828;
	Thu, 29 Oct 2026 03:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793243162;
	bh=ggG4r95jRpXsMfothCtjRrBypmbpmfyn2VhHQxaSWzg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y7lp57MKZLMxO3H+K4fbVfkqtVUqRlQTdj/Of3/59DVjyHO0+juWpvLT7mymEUhQ7
	 L4bnB00pgB6xGFa2J0jjNEzfRxlky7YY49UfJdOIkzOmYrYMmxHdvOl5YiFszCGM8l
	 HzURJ4lvae41Ov5iaPE9CZOQDTe5dD/s6F3NrNVZ1PCkxeG2cwjf/uU7DS+Fiu8K5G
	 og21V/CXNibuCXCwMPJtNBlMRTeWJAkreDRofu39yMF6JBxp2ybTuG0bc7Ag/GrCWE
	 548nNOptaYOo3O/kfOQ1M1fzok4ImkU+oO3rSpTcf90ohUEI/VGgxwV/2e2aTY3h13
	 Ru9Z0zFP0t51w==
Message-ID: <sashiko-outbox-188656@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 4/8] crypto: acomp - Add API to get a compression
 algorithm's batch-size.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261028030503.17923-5-kanchanapsridhar2026@gmail.com>
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-5-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 29 Oct 2026 03:06:01 +0000
X-Stat-Signature: guim9cb7t4yjjwebb59ygyargjh14d8a
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C45420002
X-Rspam-User: 
X-HE-Tag: 1793243163-13314
X-HE-Meta: U2FsdGVkX19AigwQe0zBG2TeBoOawdr6t1lKxKBNcJjn9oEWNAMuEOtsS1MU3N0w/Sz/ZVpr7RItjJSzPKSdzzgbtKry3B4RMQiRGB7O1djs2cviC+wvTiwE0hserlU/e9o2dGWCLDjXWYVVxBx0y3mPn8t2G+kya6u+IGjZTaMuUOHJrK3Npfllq83hPyTVfH4kBNC4MvTSjwjIg053apnrlTd51irNTLQb0lStOGehDstV18vlVenKXh0S6R5/wEasfd/+hU6H9+6U2wp0S2lv+nDYVAbWnEviS2qR7un6ZilPlM/ssduK1YqYZDcV2kIwBFjQXZXSM2VJP+FunCAgSWBiF98wsTlKyodljBnjTtO4rs33+xf2BGl94DBCsoLhRHwqm15YTyjHE4zIIGHwOz7JQdl7lgUkQE5HNXs6Yqo55SgjFiQwCOYemx36N7iWx22jevujDY8U9aqnYJdn5bjKj8uLkb22AWq1W5tGvcTUB9EwMB/y2iwYiNTuBa9sQ69iFHujANqc1WT2uhEoWffumV0pCiSPhu/pZlzxYlHGIkElk7+eLT11jhPTucU/9790lxsmgN28wu9XcA65rDH31PRzxf5rFDVpiW2OdOEcI+mPq5kCv4+FBortu+4nJhDphIeKj0v+HS4xd1cwyT8pA4C+a683HnZxPRlJE77zwmiIDV3iOUsM1sn2VjrxWv8nYjZ23zDi8b+4ObY6EymfvDwRzVkQkbssYhAMFGiNRnvh9JbZTWiUz05ebttIqdBmJ1RwGLyKJeSYFILWS7Ov0vGolt43NjWbUPiTYv2fKUPogHuNoiwK2xuEp3NLhhRS5VuFxh6Xc0rVsTy8wzUBnhFINwZuIlzg7N/3VekprP5xYsShFsAil3S8QlGQEVC/xxoBcOGQp7zBmn/cin92e92rrCXX9EEaVltqvS8/996aOnLGtUEEMjsIT/zTLSTVP9Uj2LqQgZ+
 m2qNYF6w
 tP4qyYcXEnXY1xV8S4bfZGPoj2QZR0y3XK6DFVEPXHXXFZRl5M5Ji5owfIrOJLbGVRCPRHzKWWaH03O0N5y4Yyxmq6DkxGEPmwjvNgcyqznMldfbGuPZXR/NSci8NkIJUEMOA/fvhppYM2swEQ7mDU9hoOc3Usugk8rUu4vJAKeajZ2agrGJSXNRAquOSd2r4GqHgvje8BZ0az2aWgjfoRxpA3dfVLFT1InTrj7t8Q9oBxCqE1gr7ZWCa9++PQOZxuejdi7fWy1plvGyUX2ON0ytZhTillG5v+QRNJwB5DeZSTW25VAjjzznSCB+UNCUbBt6wml5IG6yDIkuKh+fsKXjaW1O5zD057u4OTAi+ToTBZfozj2CtqL1w+VAY2j7pAS6Cw5JGbyPO32QhGpqyJab/7f+G3jHVM1SAA71xT+t/pi147WqGUAaW+xEXB/ptd1zNJT7zFoBxBrGgM9JHdNH4Uj8GXJCcVK4kaYBw7rXreRQSEMwctClr8lYyYxKWaxlNGTIXS4QuC3XEDKTTE+P83cWl6G6w/zuQSr3tgclhx4fi/hUegBC5TzOH6Zrj/06YIS2UpXyNmRGF/RSolDBArg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] crypto: acomp: broken type check and async gate in crypto_acomp_=
batch_size()
--

commit a38b95e87019ff2c11b51ebf159a082ec340456f
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

crypto: acomp - Add API to get a compression algorithm's batch-size.

This commit adds a batch_size member to struct acomp_alg and introduces
crypto_acomp_batch_size() so callers such as zswap can query the maximum
number of requests an acomp algorithm can process in a batch.

> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index c55b0e8eff3d8..8e285cb7477e9 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -326,6 +326,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
>  }
>  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> =20
> +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> +{
> +	if (acomp_is_async(tfm) &&
> +		(crypto_comp_alg_common(tfm)->base.cra_flags & CRYPTO_ALG_TYPE_ACOMPRE=
SS)) {
> +		struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> +
> +		if (alg && alg->batch_size > 1)
> +			return alg->batch_size;
> +	}

[Severity: Medium]
Does the cra_flags check in crypto_acomp_batch_size() distinguish
struct acomp_alg from struct scomp_alg as intended?

In include/linux/crypto.h, algorithm types are 4-bit values under
CRYPTO_ALG_TYPE_MASK rather than single-bit flags:

    #define CRYPTO_ALG_TYPE_MASK		0x0000000f
    ...
    #define CRYPTO_ALG_TYPE_ACOMPRESS	0x0000000a
    #define CRYPTO_ALG_TYPE_SCOMPRESS	0x0000000b

Because (0x0b & 0x0a) =3D=3D 0x0a, testing cra_flags & CRYPTO_ALG_TYPE_ACOM=
PRESS
without masking by CRYPTO_ALG_TYPE_MASK evaluates to true for both
CRYPTO_ALG_TYPE_ACOMPRESS and CRYPTO_ALG_TYPE_SCOMPRESS.

A struct crypto_acomp *tfm allocated via crypto_alloc_acomp() can wrap eith=
er
a struct acomp_alg or a struct scomp_alg. If an scomp_alg has CRYPTO_ALG_AS=
YNC
set in cra_flags (or if the acomp_is_async(tfm) check is removed), calling
crypto_acomp_alg(tfm) performs container_of() to struct acomp_alg on a
struct scomp_alg and reads alg->batch_size from unrelated memory inside
struct scomp_alg::streams.

Elsewhere in crypto/acompress.c, such as in crypto_acomp_init_tfm():

    if (tfm->__crt_alg->cra_type !=3D &crypto_acomp_type)
        return crypto_init_scomp_ops_async(tfm);

the code checks cra_type =3D=3D &crypto_acomp_type (or masks cra_flags with
CRYPTO_ALG_TYPE_MASK before comparing against CRYPTO_ALG_TYPE_ACOMPRESS) to
verify that the tfm is backed by a struct acomp_alg.

Also, should crypto_acomp_batch_size() gate on acomp_is_async(tfm)? A
synchronous struct acomp_alg registered via crypto_register_acomp() does not
set CRYPTO_ALG_ASYNC, which causes crypto_acomp_batch_size() to always retu=
rn 1
even when batch_size > 1, whereas segmented request handling in
crypto_acomp_compress() and acomp_do_req_chain() checks
crypto_acomp_req_seg(tfm) (CRYPTO_ALG_REQ_SEG) instead.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.1792=
3-1-kanchanapsridhar2026@gmail.com?part=3D4

