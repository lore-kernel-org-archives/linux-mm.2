Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 274FB606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 24 Oct 2026 19:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GOyAIB1r
Received: by kanga.kvack.org (Postfix)
	id 356A06B05B1; Sat, 24 Oct 2026 15:56:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307F86B05B2; Sat, 24 Oct 2026 15:56:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21DA46B05B3; Sat, 24 Oct 2026 15:56:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF57B6B05B1
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 15:56:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 67A6E803E4
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:56:58 +0000 (UTC)
X-FDA: 85358578116.30.5663EA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CD2D9180007
	for <linux-mm@kvack.org>; Sat, 24 Oct 2026 19:56:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GOyAIB1r;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792871816;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JmMlTKfpNHokvyjnWNUvxbdsY0ytuHDIziS4VZxItYY=;
	b=n2iV9YXM3LSUnqe/zWiU/evYV1+dfDFjifQ5MWTLzQ+Rhyu8fHVHlX/JXXBniaoeKlH+9Y
	cTJDFPG1sqwqBXzdvDJBuImK/ooy+gH7p19Deru9RTK9BxmuSXQjbLwpkz2QTamNEh5kuT
	yqDWOV/+StiKP77HNr6OrCbtg5mkHQk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GOyAIB1r;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792871816;
	b=xIVYMIiTzfnDDVzRJkgJbt3Uu67qGeSD/vDtvHqF54sScbkYsDDF5YC0N5tEcgCl3591Iq
	Dcg6MZD61ncY6YGzVT3L19xpksS8wGRHsYtoK7LkAU5w3+1yoe8BlEl6L5voROHgRp3Nmv
	Onqhi5MoyDPiF9ggGPMgx4p3C+/cRFA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 59A1E600D4;
	Sat, 24 Oct 2026 19:56:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB21F1F01825;
	Sat, 24 Oct 2026 19:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792871816;
	bh=JmMlTKfpNHokvyjnWNUvxbdsY0ytuHDIziS4VZxItYY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GOyAIB1rjvArSFE7gfIVCzK0ziJWNbf0ckbZya7wm88IJ580Xr7c0UdzNhlTC/tEL
	 fgJeh3zjG2vArPUvu6tRoP+sGd2dpbtQqaKhSZdsi8EQ+Bl4jYheu3T+thuPB5zy+a
	 L6gKOO4GwTzgZThgj60zYPTUpgOgknHVDX558oAkeTLRtZ4GmOGUl6g9O6uVNtA4x7
	 nt2Lf2EiQ2judPSRJtuLWBDPW6cGG9MPutZVrBDQLSdTu0msjUtpfOGteAu8OJqPrx
	 GV+eyWkVawrQCbyfndU+5kWpOqaVQIlHHNOVa0PChUma3xJjzcgVzn6U/UFiVfCNm+
	 ZKL2kHdfX/oxQ==
Message-ID: <sashiko-outbox-183867@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] lib/lz4: backport upstream fast decode loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "Biplab Raut" <Biplab.Raut@amd.com>, linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>, hsiangkao@linux.alibaba.com, terrelln@fb.com, yann.collet.73@gmail.com, guoxuenan@huawei.com
In-Reply-To: <20261023195617.3468543-1-Biplab.Raut@amd.com>
References: <20261023195617.3468543-1-Biplab.Raut@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 24 Oct 2026 19:56:55 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CD2D9180007
X-Stat-Signature: 71ig5u4zhxze5ratqnidq1nex73x716b
X-Rspam-User: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792871816-10407
X-HE-Meta: U2FsdGVkX1/B6HP/wGKZqqA/QVlTX69MPOifUfWu4cAerIyEY9BIvyvP4DzKa90ev9MaY+VgbQOyc4r3EjUNXfU+00NkSYUwFXb7EsVb2aSZMftJM4aa+ahLsTimsKZswEHUrx8Jqhs4BCsAFStWxKo2ds+unmxWEtLEeELPssxN+4hY8v9E5RLxIz+PjlPPqqTTQY+xcHg2QHrhgJnNFbvbqz+j0BOSRWoGeyIIdUTg1Q/ELsXFHz71qA4QDZ8BwE4MWECMG7Ei1bhiJ3X5Ff4H/2SKwDixMhF3nYeBikK/pYqIhUCcc8eRpNwh7RJ5Gu1HDVUB2+92JoslK9YzcYCsCpgrKTJ6DGghrsb1ttFrSJNqJGM4xWnUhQ9hxr4JkazOdldDIl65SC0l2yKmeFkGZxx3U5GOu7yu6dkWyyADD04/HywuByzQ2BFFKoiWHX7kU0r5wjgJcLOeGJKaSYuCobrGH4aWZcyczc8Azm6Yv8Cn666kTXvWSsMSSwA1Vb5Jsi3GJxscgK458OEKHITGrdE7H8fZwGstwd9VXhxbzF1qkCsjiSd800U2T8nDam5A2qjjqqnCRxZJEk3oc9amHohOV4ohilXjUWVN4iIPhOMXM2J5jaJcxIqSpvdlDmpfd1r+UZFQ5Y2yfsLvas+Pf6oYvAlA4Utn2wFVycRWT+YKq23nTwaKBEKRGTecbY2/JlkmiCaBYaX7k1lFr/RYOsohCWJE0ntgiWXpEuJiu7oFVZkvojWW0uCtZOpKqmlU0PkIIIzMS34zNJWFmWNb24uVu5kteV/BiodpynbQud5KKhHdlKC0qpLkltgP+e9xccsv78vraaKvGhNMWsQiA1Vm8NUVh9Qyy72uEjwP2KMWlJEoQZrg2bxelXOxRe1i/uuTWR1orRI8CAbfFf9ttptpfZYYFpP6/l8rawLBjo2PVK//MnD0bUAOVHm13cXBud+c9YW8nW+gHwm
 cgWLLV2y
 Sa3rHAM6YszZutkepeDlT+49N6SlMCULzno8d82/KnhjREYMoF4LyYPzNKn5d6YJVv06sXob/cOk1ttURDgi9A4YW4TsaWIRjmwnTpfnh8gxuBlyxd7//f26/oXyBQYD0yisyv5N8Rorca5Oj+CY9p0p05gGVIX8/EQQcHR5V6fidobGR36OR/HeVKC2gn+aaE4WQaq2gcLgOXIiZXMhRDyMxPmSPEkftcDVaJouTtCkmkoH7scfgI+gxSS+Q9K23bLQx2J/3rW8BeIpqrTVabgMGMfANt0TjcbcenaW6L7unfPM+JvCGDagb3C2bGCpaf+wVgK/gqy/rRFFmqwLP1cWvcF5DwYutOesu8RNuLdJDz1ahZ0BqBKL+C2QjMPdvrGmlt1HjfXlOblBkuKVQuld8wvcfZyC3rKZWKqJCTNN1w+U8J2nEK+wwGqe7GJkFUF8Iyiv6UjXEjv1PtiGt5zbMm1gKMceOw7dgBq39VSsjlePiUNpyFFOL5+MejjHR/scO7O4iDmlP4Vv+PQrHv3fbnmXj0HeYWrzdT+hV3zsptoapj7EIaTvRsHez2Qv/J0VxaP90gER8ogHThMLTxyVUpC96Gm/8w2omTgIQzRo+hd0DqsBDtRCphe14IM08UnkfH+3fgekxEW0SQEY0dIKxcvRw8yuA4+hSrGS2uCPRauL4tcRCM1SviQ==
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
- [Medium] lib/lz4: pointer overflow check before adding MINMATCH in LZ4_de=
compress_generic()
--

commit 470e38e27e55da2aeb57c59ceef99c817952636e
Author: S. Biplab Raut <Biplab.Raut@amd.com>

lib/lz4: backport upstream fast decode loop

This commit backports the upstream LZ4 v1.9.2 fast decode loop into
LZ4_decompress_generic() for x86 and non-clang arm64 targets, along with
the shared variable-length reader and updated safe-loop control flow.

Link: https://github.com/lz4/lz4/commit/28356e02ad6f6dac529302cedf707712c5b=
628fe
Link: https://github.com/lz4/lz4/pull/645

> diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
> index 3a2cd9acada4a..bb201c9484dda 100644
> --- a/lib/lz4/lz4_decompress.c
> +++ b/lib/lz4/lz4_decompress.c

[ ... ]

> @@ -116,15 +273,200 @@ static FORCE_INLINE int LZ4_decompress_generic(

[ ... ]

> +		/* get matchlength */
> +		length =3D token & ML_MASK;
> +
> +		if (length =3D=3D ML_MASK) {
> +			enum variable_length_error error =3D ok;
> +
> +			if ((checkOffset) &&
> +			    (unlikely(match + dictSize < lowPrefix))) {
> +				/* Error : offset outside buffers */
> +				goto _output_error;
> +			}
> +			length +=3D read_variable_length(&ip,
> +					iend - LASTLITERALS + 1,
> +					(int)endOnInput, 0, &error);
> +			if (error !=3D ok)
> +				goto _output_error;
> +			if ((safeDecode) && unlikely((uptrval)(op) +
> +						length < (uptrval)op)) {
> +				/* overflow detection */
> +				goto _output_error;
> +			}
> +			length +=3D MINMATCH;
> +			if (op + length >=3D oend - FASTLOOP_SAFE_DISTANCE)
> +				goto safe_match_copy;

[Severity: Medium]
In LZ4_decompress_generic() in lib/lz4/lz4_decompress.c, can checking for
(uptrval)(op) + length < (uptrval)op before adding MINMATCH (4) allow
op + length to wrap around the address space?

When safeDecode is enabled and a match token has length =3D=3D ML_MASK, if a
crafted input stream supplies enough 0xff extension bytes so that
(uptrval)op + length lands within 4 bytes of the top of the address space
prior to length +=3D MINMATCH, the overflow check passes because op <=3D
oend - FASTLOOP_SAFE_DISTANCE.

Adding MINMATCH then wraps op + length around to 0x0..0x3, which bypasses
the op + length >=3D oend - FASTLOOP_SAFE_DISTANCE check, sets cpy =3D op +
length to 0x0..0x3, copies 32 bytes in LZ4_wildCopy32(op, match, cpy)
before terminating because d < cpy is false, and leaves op pointing to
0x0..0x3 for the next iteration.

Additionally, read_variable_length() accumulates into an unsigned int
length, which can wrap modulo 2^32 if srcSize exceeds roughly 16.8 MB of
0xff bytes.

[ ... ]

> @@ -293,38 +645,16 @@ static FORCE_INLINE int LZ4_decompress_generic(
>  		length =3D token & ML_MASK;
> =20
>  _copy_match:

[ ... ]

>  		if (length =3D=3D ML_MASK) {
> -			unsigned int s;
> +			enum variable_length_error error =3D ok;
> =20
> -			do {
> -				s =3D *ip++;
> -
> -				if ((endOnInput) && (ip > iend - LASTLITERALS))
> -					goto _output_error;
> -
> -				length +=3D s;
> -			} while (s =3D=3D 255);
> -
> -			if ((safeDecode)
> -				&& unlikely(
> -					(uptrval)(op) + length < (uptrval)op)) {
> +			length +=3D read_variable_length(&ip,
> +					iend - LASTLITERALS + 1,
> +					(int)endOnInput, 0, &error);
> +			if (error !=3D ok)
> +				goto _output_error;
> +			if ((safeDecode) && unlikely((uptrval)(op) +
> +						length < (uptrval)op)) {
>  				/* overflow detection */
>  				goto _output_error;
>  			}
>  		}
> =20
>  		length +=3D MINMATCH;

[Severity: Medium]
Similarly in the safe loop of LZ4_decompress_generic() in
lib/lz4/lz4_decompress.c, should length +=3D MINMATCH happen before checking
(uptrval)(op) + length < (uptrval)op (or should the check include
MINMATCH) so that cpy =3D op + length cannot wrap around by up to 4 bytes
and bypass the subsequent cpy > oend - MATCH_SAFEGUARD_DISTANCE bounds
check?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023195617.3468=
543-1-Biplab.Raut@amd.com?part=3D1

