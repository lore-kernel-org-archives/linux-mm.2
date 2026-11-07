Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA9A2606A32E
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 07:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mxRiTpft
Received: by kanga.kvack.org (Postfix)
	id D96A86B05B0; Sat,  7 Nov 2026 02:25:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D47E96B05B1; Sat,  7 Nov 2026 02:25:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5D926B05B2; Sat,  7 Nov 2026 02:25:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CB106B05B0
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 02:25:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2EEFAC02A6
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:25:09 +0000 (UTC)
X-FDA: 85407486738.04.C16AF56
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7C923180003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 07:25:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mxRiTpft;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794036307;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sRnoEnJS6lgMf2aidbtQUnxmoBvYWDnbbxpzbj70vYw=;
	b=Z2Vf/Cyk1C+YdB32Af65x5vFSgA8B33Y0IoNzCJsLBxt6IVDiBW2d7CckbBorRTQWtMfA8
	0g3iqnu7DTt/DMn6v4B2oj5ZM3evJpSXU5iP/8JxJzocq/RdxYZZ3g+P3oE/ZbNz/X6pgG
	LmYyEjKnoyh+dS8LGOPYOMRr9H/wOK8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794036307;
	b=5EAZX4C1UlXxMjsnXxh6xlaTof35aOSZUVfX7knISAeEO9eHwjWcag2aItX7GswiMVIreL
	T+rZOPkkqVehI8rVa+EiWhj0foC1L8qPO9nIymdnQNgpyykjK/kjdcGYT1unAciwtJikmp
	FvSR9YMJV05kZaSfnRDapPR//yLfmks=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mxRiTpft;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 97B804041C;
	Sat,  7 Nov 2026 07:25:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF881F0089F;
	Sat,  7 Nov 2026 07:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794036306;
	bh=sRnoEnJS6lgMf2aidbtQUnxmoBvYWDnbbxpzbj70vYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mxRiTpftuY+2Qfqw5gmB982A/13H8/92gVHVpuRdPbZNh1vA/nlUN3fNzgZN6XmWZ
	 /kpCA7kVewi0ASrYzwiWFwwHGmlheLm8bDXrK9ImIip83L8mcoORUuGQ5vAnndvLhU
	 hYm1tQPLA0frelU6Tj2kAfssd10C0Cvq/8Dp+ESsyvoVbip2HbPRbVXS9GQ+n0bhEK
	 vK6SgGQPRGlbUEB0mpEjuxmaURkDHnI+jvUBruVHyaobL66/sjFjC7X20GboKKwyTA
	 soZdpeHDL2LnCa7PwMQo+a8eUKC4ISiJ1TBmU1Ug91aoQ1RG6uHtC8yURNbEgTZO8U
	 cYgydu+i0W6QA==
Message-ID: <sashiko-outbox-202709@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/8] crypto: acomp - Add trivial segmentation
 wrapper.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-4-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 07:25:05 +0000
X-Stat-Signature: y6dyq3ikfmisznha77u3z6jcxae5m3gc
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C923180003
X-HE-Tag: 1794036307-823440
X-HE-Meta: U2FsdGVkX1+Fdyou60QZLPjSjhWUK2EIs3n3aR/u+9oNEYGRfZB2CvHhMSiPHblnRZSDxJ0u78wumCGa++a7ziKqi7+SGz004E2zncAGQGnwxpkIF4ZJ38Ot/0e68F+GKMyV0HEYAvsgVOJo79GnPqJaqzXEwSkFpO5+ieodpDTGYCdsGBvS2aiwuC05VjkSBq394jSaeLi9NEzAuboyaNFlzwQBVuDRw89JgBPGgp6g2AZ1vqmVscvgzs4lnjp19GHoUHx5LnOGCQJO/bMLR4ZklzTqYCrUuT+D2XwDBbJHQhg/OQR58SUFzZDXMQ3cVE1fiTAKoTGAlhBhqeZARtqPiUdlSn1pdcjRwpKPz4zmghWW2Jay4SDYFXqUgsfovlPAjf1+d0YXc2hl635ESqR3I2LptMBkp52LglsWJPZQjR2cWHzGFyNr3VlVfy/i1IRnbXm9C+jF5i27vXnBiINwrn3ys3466MzagOSVOMRlWpQLDfz9p5HjCqHHuaC8CKnu31Tghd6vMLtfjKPjn8l81VbSxh+cmwO23vm25mLeskXBRL0oXUEpfZKiZqrzTV9uMmjeRL8/cOU8lo84ohP5ez9o5Bi8wy80s+m+ixMYrWmvV55+hyXEoNhibI/yxZLs9fz1qBtlJcsnF9u5aFvgX69Jg8HoEyEogCzuMUv2eiK7zUjVrEJWlHLk2kEjH0sbnHk0ORuxwgnozSGcMKBLZHQJ7oQB3ft+/eGEq7+YO++iZBqdqgSz/JDYfgJQMi+kOThKNL4w/NhuZSg4nzq+8c2om3QCm9gxFyhKzZ5bBmtANWfHKybSS5kcuOw7w3kAmU4OJ/+g8f4Bi5H+EINIHZ3//RbgceNvISK0svh4BAvCgKuG+nTWdZk2QNHfDGfE0Pv8+izjn9p2tj27aJPJFLBjWZkThU/jWJcKDFdEo306dg/ifKQFUmuTrWup27B6mWgQDf21EwI19Wq
 vOeRvyVT
 FPu9o+Ng9ugtMBF4asEOyvYBAVZJMI2HtZDJLRpFP0EigILOrhD0Q+GBZhLaPOUMknsLuBbLjBeBCXpwRs4DQ1kbZ9UwQytpVZlZ4HTaenHT+VVyl7HsdyUAPTXMl5qVKIShjRuCeBBtbpJJGTKJ2bHOtCuTgqJ1oCJuuo3h4j9bPFa9QOWRcX0y4NE2MELV9Xyt1M6qvHVSrvS+HiMctfR4R4r0VK81GTg1frVFBGNRPAPm8bqGlHRjtPa3bWw0NUs3GRLivD2ZwnuYhZ4qPWn8rTyi4kUGba3Ojo2DdXm5y3RpvVhcSjCIW9JAwNS4FaMeCMLygn5ysr3PKvPSyqKPXpCE5YqvidBsH5Z2pL4A2FMyStKUZbE7uxEt8aDz6utwdFqOzLCzOM5XSG7VRmp85avWIYyTUSv6SuOZmOFfhlzoXz/oqdjYSblz+QKIzFq3Bww/CoZ0Ym46Dfm3X3t7Nsu8eWP76905rh3VbXHOYStyp9OJ4w83d5+az0WVupKVHgjepCBZlakpKOr2gHdZHQERBPodxOCI0amk9NQPTyr8Zctts6XJTzkMsQPXzaxXqI6cKQv5NzUj9XrkWdvsh+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] crypto: acomp - missing non-zero unit_size check in
  crypto_acomp_compress()
- [Medium] crypto: acomp - union type confusion in
  acomp_reqchain_finish() on virt dst
--

commit c2a605231cabd5e0e15d6d778b3943a2c118d756
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

crypto: acomp - Add trivial segmentation wrapper.

This commit adds a single-segment compression wrapper for algorithms that do
not natively support segmentation, returning the compressed length or error
in req->dst->length when req->unit_size is set.

> diff --git a/crypto/acompress.c b/crypto/acompress.c
> index c8b4b8589769e..ac4dc52668b89 100644
> --- a/crypto/acompress.c
> +++ b/crypto/acompress.c
[ ... ]
> @@ -242,6 +246,10 @@ static int acomp_reqchain_finish(struct acomp_req *r=
eq, int err)
>  {
>  	acomp_reqchain_virt(req);
>  	acomp_restore_req(req);
> +
> +	if (req->unit_size)
> +		req->dst->length =3D unlikely(err) ? err : req->dlen;
> +
>  	return err;
>  }
> =20
> @@ -266,10 +274,13 @@ static int acomp_do_req_chain(struct acomp_req *req=
, bool comp)
>  {
>  	int err;
> =20
> +	if (unlikely(req->unit_size && req->slen > req->unit_size))
> +		return -ENOSYS;

[Severity: Medium]
Can acomp_reqchain_finish() corrupt the destination buffer when a request
with a non-zero req->unit_size uses virtual addresses?

In struct acomp_req, dst and dvirt share an anonymous union.  When
acomp_do_req_chain() handles a virtual-address request
(CRYPTO_ACOMP_REQ_DST_VIRT), acomp_reqchain_virt() restores the raw u8 *
buffer pointer into req->dvirt before acomp_restore_req() restores
req->unit_size.  Writing to req->dst->length then treats req->dvirt as a
struct scatterlist * and overwrites 4 bytes inside the caller's output
buffer.

In addition, acomp_do_req_chain() is called for decompression (comp =3D=3D =
false),
so a decompression request with req->unit_size set will also hit the
compression-only req->slen > req->unit_size check and write to
req->dst->length.

>  	acomp_save_req(req, acomp_reqchain_done);
> =20
>  	err =3D acomp_do_one_req(req, comp);
> -	if (err =3D=3D -EBUSY || err =3D=3D -EINPROGRESS)
> +	if (unlikely(err =3D=3D -EBUSY || err =3D=3D -EINPROGRESS))
>  		return err;
> =20
>  	return acomp_reqchain_finish(req, err);
> @@ -279,10 +290,27 @@ int crypto_acomp_compress(struct acomp_req *req)
>  {
>  	struct crypto_acomp *tfm =3D crypto_acomp_reqtfm(req);
> =20
> +	if (likely((req->unit_size =3D=3D req->slen) && acomp_request_issg(req)=
 &&
> +		    !crypto_acomp_req_seg(tfm) && !acomp_is_async(tfm))) {
> +		int err =3D tfm->compress(req);
> +
> +		req->dst->length =3D unlikely(err) ? err : req->dlen;
> +		return err;
> +	}

[Severity: Medium]
Should this fast-path check also verify that req->unit_size is non-zero?

Callers that do not use segmentation leave req->unit_size at 0.  If such a
caller submits a scatterlist request with req->slen =3D=3D 0 on a synchrono=
us
non-segmented transform, req->unit_size =3D=3D req->slen is true, so
crypto_acomp_compress() enters the segmentation path and writes the negative
error from tfm->compress(req) into req->dst->length, corrupting the caller's
scatterlist or causing a NULL pointer dereference if req->dst is NULL (which
can also happen when req->unit_size is non-zero and req->dst is NULL here or
in acomp_reqchain_finish()).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.7909=
-1-kanchanapsridhar2026@gmail.com?part=3D3

