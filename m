Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A65E606A6AB
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 04:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=l6myZ4Q0
Received: by kanga.kvack.org (Postfix)
	id 12EC96B05B2; Fri, 20 Nov 2026 23:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF846B05B3; Fri, 20 Nov 2026 23:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE8E86B05B4; Fri, 20 Nov 2026 23:20:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CF2006B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:20:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BE2738031C
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:20:07 +0000 (UTC)
X-FDA: 85457823654.15.4DE80EE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 125EF80008
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:20:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l6myZ4Q0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795234806;
	b=x7gUXC45aSdrjLMJbbq2o0YNnJcE7IoRdCXucx67QtmozWHzPw7NvtsM+K/gm3reSGnk/0
	CyeED0dirviTaGuSEhZGqczDx/PqXikIWYNZuxCgGNFCkQ0QqXQmlg8chjG0ggcBnWIDl/
	U05FMZtlwyUiYrFdqgAkAwBTUyNPC6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795234806;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1AnGr17n7QBlqJTgR0L/2DWD4IMKoGtf1+NZyW5LFIg=;
	b=yIomnZmHCQ1X7S38gMW15aCTfAr51NraAoytF6HbS3hYgEZFK9UTwL3OObpemGx6ztwQ3e
	g2oZUSBdS6YOWzUzi5oYxvZb/abSiBnWTERp/Fc95xy16K9gvriwUnvJXFqnnUAMv7MmFA
	ezpTqwL7S7Bbp2LoH3RuvuJ9nZzpXBA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l6myZ4Q0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 052EA441EC;
	Sat, 21 Nov 2026 04:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EA41F000C6;
	Sat, 21 Nov 2026 04:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795234804;
	bh=1AnGr17n7QBlqJTgR0L/2DWD4IMKoGtf1+NZyW5LFIg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=l6myZ4Q0DB+5S1slDpMuSwj+aBJpNMW6/Js8aMwBVS7+OrzbjxL9drtdk/O1+C20E
	 0rQoUwn5jXHlhJmKWvHPGOmzc5ZlvSvCzDJsK9SsR2q+f8ZDSZANxcFjDj0vv2oGCL
	 iHT9g9NP+s9UHbe9NvEirOr0CIQwEQPWrExpAF9Zf70YIZQ8fFkD0VXNdLo8ReUtxa
	 7TbBUNscblAGuQ7O1M2ax+vyq006PaMEGpPJ3IgSO7cRYLt9ZIud1K+sVEP2rB/xXQ
	 GNCiN91dT6i3/Hty/hh6+4rxhDopgFB9t1kkUhs5EgoXa//EORdR8ic9kMiAfV5Isy
	 qteQPQbAqAO4w==
Message-ID: <sashiko-outbox-226634@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 4/8] crypto: acomp - Add API to get a compression
 algorithm's batch-size.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261120041906.5785-5-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-5-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 04:20:03 +0000
X-Rspam-User:
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 125EF80008
X-Stat-Signature: rm3s7eso5fj75ebfg4cmim8sc3f73knf
X-HE-Tag: 1795234805-823235
X-HE-Meta: U2FsdGVkX19WFr+p4kpQecvExz4xdIQWsk1BHg1yj523YRt3iyu0iIozR8wqwxg9sKGv5U4cLUQPGPJxrLxlTbi57qFToMeW0MIslpnV8EN32GqnOWhBKkUp4pPGclDatVQRP1SgjR1K9/eJnBr29KzdtTn+VXoyVjfU4jYVsW4E6FGXHTwhx8wXIKKwwhLuQm75z98qcKDE/kxB3V2t23XsZISJp6ftm0UCgcHoZTuZQYqOeL6XA9E7v9O+E4a+2Ta9jU9angCP0SPfm2vEvqOl9Bb4UylLwUfq/XZC9Dh5NsqSkVeo45Yh98HiJXcm/5cDpeFvH9EDsOcvEbO1PLM/RtSUIUUO/1GksKGwe1fwxRzGpFrAuV20m3Nmv0vODXjJlM+b2zhukKLHCyGeBzEjyZKrSd8GgeLj2XWz1hj9M6xdT7aFVOJMVIcRIBOthvCdaFu6rITRmaiBQhJsTgU9MltXaJkAGVIQY2zZ47Pw64VE1LTviyApTYWas5L/NZUElHHei6IILC/ggJ4XEoFVYn3LUfAVw0eUHrnhkUMvZC9nT0UJ5GGpTfoQ+B2asCBDDx4PL5AFEq6BGgjndRDM+tUuKjS3hzh7Scc91fnocrCsPheR0qsjNIuwFjVBBY6n7PiFVHdHFsMY7ej8ASEPJA2S7VG2jU0dBJq0fkvxsW/DImwHG362qlycNqe7eOXjWiYHDOP27S6/1O5GVuSENZQqERUna1/NKd4gjPBsaZ3DWCJiPF4FXUbes8wqK8J7zz1YspGkgZ2xfLXOeLpGgtoSrwMnjLoxB4lhTTaqjmYnLTrajAHx0yP4oHsUowDDympzOMherlRGiAJ/JYY2b40uxpY49+p8+2p6Hdj316ehz+Mgp97e4lMNjmBx6NFqnKmcV3fNpqMdfzrlW8ynB7GfuTe9IdKJKhbdtItWBI2R+VdeC5vjhWOUPxF0Jg6/mhfzIZqAJbCuflE
 u9UXOMfQ
 Tdj9efFa0FcYmhFvyn7nCFUMVrjYoS3fMb+/UabYZoT3eyEmsB60Llwu/Sd/J/Ot6UX45A7apq8+Fz55SXTr32ArXiz3nIzhfjnE85C3LLF1yXC7v1t/I0BGEHK1KQynXF5IDfaLyhaEcFi36TYXpMU7QnA8CRHh2B3Vw9a++Al1XixbFDQ66sHgMh/+1jqMm7GMQX9CWrvmDKKQzdGlO6BFfXM2qoXhGQ4lO2i5j7oKOsLpb9sU9/xoErRznlSYO9YZT6v3FncjRE6JKfSJT5K+OFen6W0nQbLuDv7chEAqfjBu5xHuZePty5/hgrs37vks06SvezOYc87ssEh5+BvMpjDqtyQ1NCIkoJ4zZ03sPqWT6MR8M2KgkAqmA3PmyPp0RK4rqgB7DT4ZXuD0CUCkDBIR8+yiLbPVl/dgrmhzPgg1qr7T0HuH4C+MvGNYNO3Zd4aohp0BsYR9RMf8QygaU5O9aupNHou3oLUm2JCNzhM6ymY/PTkyq+IWxbRfFzohQ3K6/udUOsWpmZhrRsXwfVnCoD09+u2Z4LVrO3q4tgWbPm5bEiuZJS5HcAjyaflXQQQdzjm78F/5y9GOIlXBqTgsdIwRmrbp9ImxhsZBhYRBvAwkF7prRS/XycMNH6ZtZO58/O6bcyPLAaZeoh3e0dN5Njq/SrFGFinZ56aCR6LwYmCxWBxHsR/MD/lujMzTLON4mj0ItLVApgUACCW/SAn7pcQdZ4ESBOuNgBPlnJIWGZGVmOvRwr0f328XeuhOyKzGRSngTn6qjZLA/Wa8RmjTxTKaZGhfty1B9hw36XsR8vTXrLDQOajhWTirrGxsX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] crypto: acomp: crypto_acomp_batch_size() checks async instead
  of req_seg
--

commit 4f8164105102abaa98a8641d32dd35c9cb223ee0
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

crypto: acomp - Add API to get a compression algorithm's batch-size.

This commit adds a batch_size field to struct acomp_alg and introduces
crypto_acomp_batch_size() so callers can query the maximum batch size suppo=
rted
by an acomp algorithm.

> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index ac4dc52668b89..df9e42f519c35 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
> @@ -327,6 +327,20 @@ int crypto_acomp_decompress(struct acomp_req *req)
>  }
>  EXPORT_SYMBOL_GPL(crypto_acomp_decompress);
> =20
> +unsigned int crypto_acomp_batch_size(struct crypto_acomp *tfm)
> +{
> +	if (acomp_is_async(tfm) &&
> +	    (crypto_comp_alg_common(tfm)->base.cra_type =3D=3D &crypto_acomp_ty=
pe)) {
> +		struct acomp_alg *alg =3D crypto_acomp_alg(tfm);
> +
> +		if (alg && alg->batch_size > 1)
> +			return alg->batch_size;
> +	}
> +
> +	return 1;
> +}
> +EXPORT_SYMBOL_GPL(crypto_acomp_batch_size);

[Severity: Medium]
Should crypto_acomp_batch_size() check crypto_acomp_req_seg(tfm) instead of
acomp_is_async(tfm)?

crypto_acomp_compress() only dispatches segmented requests (where
req->unit_size is set) to tfm->compress(req) when crypto_acomp_req_seg(tfm)=
 is
true, and otherwise sends them to acomp_do_req_chain(), which rejects
multi-segment requests (req->slen > req->unit_size) with -ENOSYS:

crypto/acompress.c:crypto_acomp_compress() {
    ...
	if (req->unit_size && acomp_request_issg(req)) {
		if (!crypto_acomp_req_seg(tfm))
			return acomp_do_req_chain(req, true);

		return tfm->compress(req);
	}
    ...
}

If an asynchronous acomp_alg sets batch_size > 1 without CRYPTO_ALG_REQ_SEG,
crypto_acomp_batch_size() returns alg->batch_size and callers such as zswap
will submit multi-unit requests that fail with -ENOSYS.  Conversely, because
base.cra_type =3D=3D &crypto_acomp_type already distinguishes struct acomp_=
alg from
struct scomp_alg, requiring acomp_is_async(tfm) forces
crypto_acomp_batch_size() to return 1 for a synchronous acomp_alg even when=
 it
sets CRYPTO_ALG_REQ_SEG and batch_size > 1.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.5785=
-1-kanchanapsridhar2026@gmail.com?part=3D4

