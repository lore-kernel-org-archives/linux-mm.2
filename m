Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EDA6606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 18:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=U53AWRyc
Received: by kanga.kvack.org (Postfix)
	id 4650D6B05BB; Tue, 10 Nov 2026 13:37:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C7D6B05BC; Tue, 10 Nov 2026 13:37:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28F236B05BD; Tue, 10 Nov 2026 13:37:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06B896B05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:37:51 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83DB48098D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:37:51 +0000 (UTC)
X-FDA: 85420068342.27.8EA4FEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E14D040006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 18:37:49 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U53AWRyc;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794335870;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iPOEOZkBdbrS4GijGVC3wrZ+zTwG++MKibBToU4htSs=;
	b=hpyI+uJOce1+Z3Pp55/SaUmxW8DdjKDlZ9cpxcpcM8gXBQfIlbdqRFuiLAD/mFOJFyhgti
	hhnB1jfXtdg+GPhTZ54zaYqMtcXKKRu19thz83xC1ZbbQGF39Wl7NpUff9Bb1DiyTjre/V
	gWPN4Zu3FkkEJ2cpSD+alE8BCM6iD9k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794335870;
	b=lYljZPVVDpCmoHwFgrdLZKhT9vzCdz3063nvVEHdn93/J+6KOLHvX5BDgcqfGqRaMNJ/W+
	d082r/PrHIe3JVTSIUltKnhqo2E70S9QOCE1G0kT6qnrshKQVyVe8PEJv6WBednkoNkWRs
	pW0Z92bTcZ7pBnyjD8xZTEvpKvEB9p0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U53AWRyc;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 20C8F63455;
	Tue, 10 Nov 2026 18:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57F591F0089F;
	Tue, 10 Nov 2026 18:37:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794335868;
	bh=iPOEOZkBdbrS4GijGVC3wrZ+zTwG++MKibBToU4htSs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=U53AWRycSNSI9cRkpPekST33+RCkR/l4jF3C3cgvNlsUmTYREEIyAF8eWvF9LQA8G
	 0UAIIywOHpQ1yFFV3wLUzMZmKEAcot0Sq9QoY6fZKH+k7YqIXGeNgWEtoqA6smjiyZ
	 G9oataiaAgYMODm7m4p7GmoOpxVpM0N5sQTQR4CWgFVQ8USNrVWN3GQ333410QBxQN
	 w7R3u+fYLtUXQCT5uQwIMGJa94b++Ez6c/nn0S5eXA10b8Lt4usMoY1GC81JOTu1+S
	 Gk8pRhDmSi+HbSc7ixyMw7SQhg+JPJ0rTJIdp6v5LO/9LXiwAuhI/rCfMg/3c5JoR6
	 7JSlDd2MiBc/w==
Message-ID: <sashiko-outbox-207590@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 08/11] zsmalloc: encode 1-based obj_idx so valid obj
 is never 0
Reply-To: sashiko-reviews@lists.linux.dev
To: "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Nhat Pham" <nphamcs@gmail.com>, "Yosry Ahmed" <yosry.ahmed@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Brian Geffon" <bgeffon@google.com>, "Minchan
 Kim" <minchan@kernel.org>, "Richard Chang" <richardycc@google.com>, linux-mm@kvack.org
In-Reply-To: <20261110054836.1515030-9-senozhatsky@chromium.org>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-9-senozhatsky@chromium.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 18:37:47 +0000
X-Stat-Signature: r4s46zr7oqrtqhti6h7smrxjgcdz1jnr
X-Rspamd-Queue-Id: E14D040006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794335869-168956
X-HE-Meta: U2FsdGVkX1+c1xwGAcrrzl9+XxBQK5WguWGCgUsyRg2FifgyJaUPsMnbU1vlrE5myX2IwU8ROzbq80IZhKHWuYL/eI4s0FUCA+NRBHWbGPX/mgbYPa30wuedm3lK3BbRDJhqUjgam0NHRzkN4LlBBAEX+2g7E2BlVpFZgfzppfJntbvyLQx5U0TMAeRwHgeqty3ngOF2bhDFvLyMSxRxLnp4Z1/ehIjWbUjhcXdg+Qd6SD+lnnv/SnfqvOMtArw8iUZ1IdRNYzB0JNhV/Il59LozL4e/SqyLYCJeHm3v8pNEFFl2egVKqbXSgbS9q7wALQonasRRT5z3bDVPyPxZT8TBRkzLSQZJ6bpAOJ4aPpEXicf/Yqis7T257tIaqRtkQZplBbR0a8W/QWR06wAP9UWBlWyaMBvCc7SskbUR7vULVROyMl6UYkxVPmyyPSB42m2jlMrPkdrgfq/0yxxUBYzdqaNslfQb0BFJt+y3CC9Y6iL/i0kkhP+PLWeKsgjXGrp/N2cLLibBu2mBoiaJTCDRswASELcxpOgFdxbi77DI0QuyplaiHzZeKD3VhCNFrP6XV8TpuJUHijfvzcLE/UEsgqHOKnkwe/yZ2EmYpkc9QeBvOagiK8JWwKm3WeiIuiWiVPPRMDh4ONJ0eJv0eTSIuBiVBwfBtL+/TVcdqG4a3bEDbMMv6oNthqNDs3iAfCoiaEX9em6QwJXM+ZVL+XAKsLb6j6MbytrU94RCiwGpHVhm4sWHwWYckwJujeOzeMVkdXF9BnKy2FKUIRf2e2OgcLukaYkJqqcevcRIlMSYpJiNuDrDpFVH1eiiqSAIP5O5BtIpdjAeaUvP3xyHvvb52HVPD6oNo6/syUx43g6lY6feCPbSe/VTRdZmGWjhPfwCsW7fn+Bsi9UFS59OFH1McL/kOr6QTimsaKLspDJVX8kfyvmY6eWygLf//Mk64V8H60Cm0QBV+NKA+wq
 RFrgwrBd
 wgty06FEf0me06kCIg3KO2C7bvSdvrqqvTjz+lfZRrP8GZIyTYdUmGTFfdr2EVRzNxALZi6o4kNCnYBICHANJodMK+EpVNTyhYyLDxLFxuQ1PQa5Wa1iaJ3KieuiIHzF+w3wRWrSnZCDf1PfDt1S12cVgEkl6BcfGbKCUVfuj2bD5c3SadXk8TF0+P1YQ2Bd2PB7ibsfi7hEpx8fMupPXQFJ92iQEpm1vq/PhX870JOd6yfIQXyPxVzoGMNfNqAgwLh8JVvq8xyXibONHsepVwt56AY6RWiJgdWOKtn2VDhNr2tvc0T04LZQZS2TVy9PE5s1aC4qrYQsoHg1SnZeNy7u0T6XYV/mgA3+wvnIM1SwoEQAaD9NcT2QJPqyB5IMR5eLQB0HNHVvAHgMdnkTWphsQ7kI4lgmcYke945wmtNEnVxM+aFHk8HLAnppvwseFXkrz+OA/pw0z+aLR4YwbQ4gcfwpLidvmjr4ific2IeVvbyRybsahl0s6O1qz4ZRaV1wSWbV5RYHYpEPvYRl1Ase7p/tTK5C+81wxaGxlLwlgrKHzX2HFfb+gtqXCGRdanLAr/zVECbUOEkqxptf1/Vu6+LYYFZqIHhkXz4Q7lu3wQ/GKjTKN2FtBzkHZlUf5hnD6
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
- [Medium] zsmalloc: ZS_MIN_ALLOC_SIZE aligns to ZS_SIZE_CLASS_DELTA
  instead of ZS_ALIGN
--

commit 0c61b7dd8c43af4f863baff5b649ef0e8a7b35b0
Author: Sergey Senozhatsky <senozhatsky@chromium.org>

zsmalloc: encode 1-based obj_idx so valid obj is never 0

This commit encodes obj_idx + 1 in the object handle so that a valid encoded
object is never 0, and updates ZS_MIN_ALLOC_SIZE so the maximum object index
fits in ZS_OBJ_IDX_MASK.

> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> index 3a6a7253fd01c..aa436df0cc4da 100644
> --- a/mm/zsmalloc.c
> +++ b/mm/zsmalloc.c

[ ... ]

> @@ -169,9 +170,6 @@
>  static_assert(ZS_OBJ_IDX_BITS >=3D ZS_PAGES_PER_ZSPAGE_BITS,
>  	      "zsmalloc: ZS_MIN_ALLOC_SIZE would exceed ZS_MAX_ALLOC_SIZE");
> =20
> -/* ZS_MIN_ALLOC_SIZE must be multiple of ZS_ALIGN */
> -#define ZS_MIN_ALLOC_SIZE \
> -	MAX(32, (ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT >> ZS_OBJ_IDX_BITS))
>  /* each chunk includes extra space to keep handle */
>  #define ZS_MAX_ALLOC_SIZE	PAGE_SIZE
> =20
> @@ -189,6 +187,11 @@ static_assert(ZS_OBJ_IDX_BITS >=3D ZS_PAGES_PER_ZSPA=
GE_BITS,
>   *  (reason above)
>   */
>  #define ZS_SIZE_CLASS_DELTA	(PAGE_SIZE >> CLASS_BITS)
> +#define _ZS_MIN_ALLOC_RAW \
> +	DIV_ROUND_UP(ZS_MAX_PAGES_PER_ZSPAGE << PAGE_SHIFT, ZS_OBJ_IDX_MASK)
> +#define ZS_MIN_ALLOC_SIZE \
> +	MIN(ZS_MAX_ALLOC_SIZE, \
> +	    MAX(32UL, ALIGN(_ZS_MIN_ALLOC_RAW, ZS_SIZE_CLASS_DELTA)))
>  #define ZS_SIZE_CLASSES	(DIV_ROUND_UP(ZS_MAX_ALLOC_SIZE - ZS_MIN_ALLOC_S=
IZE, \
>  				      ZS_SIZE_CLASS_DELTA) + 1)

[Severity: Medium]
Should ZS_MIN_ALLOC_SIZE align _ZS_MIN_ALLOC_RAW to ZS_ALIGN instead of
ZS_SIZE_CLASS_DELTA?

Because _ZS_MIN_ALLOC_RAW uses DIV_ROUND_UP() with a non-zero numerator, it
is always at least 1.  On 16KB and 64KB page kernels, ZS_SIZE_CLASS_DELTA is
64 and 256 respectively, so ALIGN(_ZS_MIN_ALLOC_RAW, ZS_SIZE_CLASS_DELTA)
rounds _ZS_MIN_ALLOC_RAW up to 64 or 256 and overrides the 32-byte floor in
MAX(32UL, ...), eliminating small size classes even when ZS_OBJ_IDX_MASK can
index 32-byte objects.  As noted in the comment above ZS_SIZE_CLASS_DELTA,
ZS_MIN_ALLOC_SIZE only needs to be a multiple of ZS_ALIGN.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110054836.1515=
030-1-senozhatsky@chromium.org?part=3D8

