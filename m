Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99663606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 17:15:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QZCHHnk2
Received: by kanga.kvack.org (Postfix)
	id A4F7E6B00EF; Sun, 15 Nov 2026 12:15:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A013C6B05B0; Sun, 15 Nov 2026 12:15:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 917046B05B1; Sun, 15 Nov 2026 12:15:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E7026B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:15:31 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EB8D51A0801
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:15:30 +0000 (UTC)
X-FDA: 85438004820.08.6B041C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2A55820002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 17:15:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZCHHnk2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794762929;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdHdYTbU5GHYUpDPAR2YijIZ0gyzi/W6c4eQNjXFzJY=;
	b=3h5LSm+GUzhyX+fdRgHMp5Nv6RPuwKcGOPlua/xYO62/eUb8RrcEhafqABZCwFMBDTOvpk
	sGJRAYCCaiRrONpXInULsdM/76YtVxXZpQnQSavv2KKrA/hKu3O0dp5tdrfFb/gaBGwHIs
	LE+SOTbWJEgYDJ4y7g8bjA9OlsVEJJ4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QZCHHnk2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794762929;
	b=0WUgNjKnIqo0He0qzeCAeZ6z4QEitK6INvFqEX4Oz9kw9RzEjfYHqWQOlKaujJmsuBhzle
	/6L9QjvJ/CP6aj3qx74oOKbLln+EBl8G+zKYgGvxd/sGS42pVNdXUKlVSsS105NBAZRS40
	es3seCJM7N3WnH+VgH80gEa0Qy/6AtI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E31240D6E;
	Sun, 15 Nov 2026 17:15:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29DB1F000C4;
	Sun, 15 Nov 2026 17:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794762928;
	bh=JdHdYTbU5GHYUpDPAR2YijIZ0gyzi/W6c4eQNjXFzJY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QZCHHnk20DxjC0tpRmSkCz9xxWVB6TMgRA4dKA1TD/KHw1vENmNnf0jcpaz8MFRIG
	 Pc3TnwI7/a7nBLKqYP1DSiw3ezD/okYjTcsiDf4U+IvXhQcYQbm9pVp+RllPPYPN/+
	 0PdBNg6KV4ognQ/qjGovxuxDLAvH1QTSPa+bG3/PPsfWA2j3klhCB93eLSxcW/fKLy
	 zQIhYV5JgRpgJ2ugow11Iij1gRKOM9xeRTKAvDHLiGlwo3HTOlo51+YZZPhWVLC2Zn
	 Lq/xl2VrlcdaHOMawFM753biYhCj8+r6Bnw7jodIQTm2NQVhIuuiSEAAF8e0AsMKgB
	 o5ZjXMejSFC2w==
Message-ID: <sashiko-outbox-215671@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] lib/lz4: backport upstream fast decode loop
Reply-To: sashiko-reviews@lists.linux.dev
To: "S. Biplab Raut" <Biplab.Raut@amd.com>, linux-mm@kvack.org
Cc: "Andrew Morton" <akpm@linux-foundation.org>, hsiangkao@linux.alibaba.com, terrelln@fb.com, yann.collet.73@gmail.com, guoxuenan@huawei.com
In-Reply-To: <20261114171452.1484344-1-Biplab.Raut@amd.com>
References: <20261114171452.1484344-1-Biplab.Raut@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 15 Nov 2026 17:15:27 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A55820002
X-Stat-Signature: 91j8dcw7n9jzdc5c69irb1gjm1imd1fd
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794762929-607163
X-HE-Meta: U2FsdGVkX19s/JEkVic9eaaPaTQCzL7Yd6/h50r3O45IgBk4bzmiwt8YJR1BWzk+4SHJyb+oum3dpwUORoVNKrVDNzgOfliy1l7QhHCJ0mqr2cmokANo3/TSWa/gF/qfK1Ysgv/ZiqXAPoyzPyYABngd2VCpyuU7SxElmt3QVQH/5zUVNqgwz6DX977lYHz67nQAW0Dgy4lGBlCl24ahNgBFnJBY5k7TGOENwqIoqD3DFhlCHqrIVjW69EEjc8vfkStr1zzfknBWcyEtBw8RRaf7U7AiknWd2T2crmTiDmn7KsWfhHQaUG7M8Ahw2sMF1GWy4Eo1/TSmqQpEUuuEqg8RHUYhLGHEKa3QJNDee+ZCaic3NUP9AuR254hfUpOMIPQahw70haBpYOfgfUMJHt4t3vrO39M7V2GhQDqEkwf8w7a1sC4UlLPOcHkPVLxYjIMXly43Ai6vWYbobcrMHr5Ia55+I6H5mj8uc/6ipAvcICJRiKOBJZrNaS4aczzQeqdlh5cAHFNWZePtn15PbTvrjICnQSKj9lkqjOY7IraCcau47Y/vIflOwhtaN3oxBNMgJ61885LcgeQszpHemTdkRSBtYJYko384tNGd3B4SW4A+Au6PE6Igj8KhEFFsGs2jMO5VVZf5cB3QbFutVPmzdPXA9y2KEmtFZNANVvx4sxGYPpSDAGwDaeLYxG8Uik2umbc2v4Ohry118SQ4TcOvmiR/Nu7V/2XB5zq5X/FryPKR3Vt78VS1bIYjv+EKN5hE3uoac3rtlVLuZBF4gSMBwSCUmlV6ZNRxAq6cBnA+UXGrpS1oUNIEFhOE/Vf7fY9u3cG1xAyQYplKoou+TiFYoN0KXNCNYa93TnCidVZBsd6j2Be638oOVBiYlQWbRzxduXDF8zUczCe5PLyO1h+Zdf46ATf0bEmcflLBl5Wuw0v+kRaZffl6sCpqlRBCfobKmzA1opM10T1lTSV
 IvT9vPV0
 ouRkn9pRSlC+zM0aexOu9QRsvawr2pXsjZ5o20zLLd8mU2kyxT7hG/Abmc5kh6G2Zn7KkcWX/zkC15dGiqESYXvfO3RcrZ5EL6e912krnsh5cy5UY37pE9MZTtbL0zwgEsWm0dgQYbs1kLumEKqli416a0R+AjSr72IcbuQUN/HdqrrGiLRd8tTvqC/aZgLZ+otiMeCDYiYYHc0b8wZRtFgWcgJ3EVNCc5i+a8QCg+IDAR1usSgcKZsKNTgWp2nyMOIsAI6lL0SqKPx5yypcvxlfmdXDY5Q89/JX2RABnWo/S9XO+Gd0xqLn1ngt2br358rFTu3WNFN/ZHRmhjLbkr21gvdYIUKOIlyBieYelylzUDj9Em4lsU370gO3Aj2Xthu2Puup00iu1EYdWTwgoo1g2GorAYsUMdP785BmZ6PFqAMGS7sw4JhuqfYT/WnPKAXBB4PhPs3udFmUZjSo+w1fSbM+1FQao0jZ58unWXW5a4fEu7B5YieV8RPtfwJxTCUykjwCAHlaHUj25pN7VZSJozv8uLsiWRQ3apTLtjBXBis+lp6pswzXGJq493du999K1qK+ypEO8AXmF+IiHSTsZXEmulK5LngYXSA5gIQn/0xOeLTuPcLPx1JsevQzj2PeVai9u+bT55R6WDKbAymLuCfs28eLPHP1YZpKIhAaYkLWRrERhDvjUyQ==
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
- [High] lib/lz4: 32-bit size_t overflow in LZ4_decompress_generic()
  length addition
--

commit 007dc43642875bedabb77ae7e51314787e661069
Author: S. Biplab Raut <Biplab.Raut@amd.com>

lib/lz4: backport upstream fast decode loop

This commit backports the upstream LZ4 v1.9.2 fast decode loop and shared
variable-length reader into LZ4_decompress_generic(), along with size_t
overflow and match-length bounds checks.

Link: https://github.com/lz4/lz4/commit/28356e02ad6f6dac529302cedf707712c5b=
628fe
Link: https://github.com/lz4/lz4/pull/645

> diff --git a/lib/lz4/lz4_decompress.c b/lib/lz4/lz4_decompress.c
> index 3a2cd9acada4a..1155d5a369f43 100644
> --- a/lib/lz4/lz4_decompress.c
> +++ b/lib/lz4/lz4_decompress.c
> @@ -49,12 +49,176 @@

[ ... ]

> +static FORCE_INLINE size_t
> +read_variable_length(const BYTE **ip, const BYTE *lencheck,
> +		     int loop_check, int initial_check,
> +		     enum variable_length_error *error)
> +{
> +	size_t length =3D 0;
> +	size_t s;
> +
> +	if (initial_check && unlikely((*ip) >=3D lencheck)) {
> +		/* overflow detection */
> +		*error =3D initial_error;
> +		return length;
> +	}
> +
> +	do {
> +		s =3D **ip;
> +		(*ip)++;
> +		if (unlikely(length > SIZE_MAX - s)) {
> +			*error =3D overflow_error;
> +			return length;
> +		}
> +		length +=3D s;
> +		if (loop_check && unlikely((*ip) >=3D lencheck)) {
> +			/* overflow detection */
> +			*error =3D loop_error;
> +			return length;
> +		}
> +	} while (s =3D=3D 255);
> +
> +	return length;
> +}

[ ... ]

> @@ -293,44 +655,30 @@ static FORCE_INLINE int LZ4_decompress_generic(
>  		length =3D token & ML_MASK;
> =20
>  _copy_match:
> -		if ((checkOffset) && (unlikely(match + dictSize < lowPrefix))) {
> -			/* Error : offset outside buffers */
> -			goto _output_error;
> -		}
> -
> -		/* costs ~1%; silence an msan warning when offset =3D=3D 0 */
> -		/*
> -		 * note : when partialDecoding, there is no guarantee that
> -		 * at least 4 bytes remain available in output buffer
> -		 */
> -		if (!partialDecoding) {
> -			assert(oend > op);
> -			assert(oend - op >=3D 4);
> -
> -			LZ4_write32(op, (U32)offset);
> -		}
> -
>  		if (length =3D=3D ML_MASK) {
> -			unsigned int s;
> -
> -			do {
> -				s =3D *ip++;
> -
> -				if ((endOnInput) && (ip > iend - LASTLITERALS))
> -					goto _output_error;
> -
> -				length +=3D s;
> -			} while (s =3D=3D 255);
> +			enum variable_length_error error =3D ok;
> =20
> -			if ((safeDecode)
> -				&& unlikely(
> -					(uptrval)(op) + length < (uptrval)op)) {
> -				/* overflow detection */
> +			length +=3D read_variable_length(&ip,
> +					iend - LASTLITERALS + 1,
> +					(int)endOnInput, 0, &error);
> +			if (error !=3D ok)
>  				goto _output_error;
> -			}
>  		}
> =20
>  		length +=3D MINMATCH;
> +		if ((safeDecode) && unlikely((uptrval)(op) +
> +					length < (uptrval)op)) {
> +			/* overflow detection */
> +			goto _output_error;
> +		}

[Severity: High]
Can adding the result of read_variable_length() to length still wrap a
32-bit size_t in LZ4_decompress_generic()?

read_variable_length() starts its local accumulator at 0 and checks
length > SIZE_MAX - s, without accounting for the caller's initial
RUN_MASK (15) on literal lengths or ML_MASK + MINMATCH (19) on match
lengths in both the fast and safe loops.  On 32-bit architectures, a
crafted ~16 MiB extension chain can return a value in [SIZE_MAX - 18,
SIZE_MAX] with error =3D=3D ok, wrapping length to 0..14 for literals or
0..18 for matches before the op + length and ip + length wrap checks.

When a match length wraps to 0..3 (below MINMATCH), cpy =3D op + length can
stay at or below oend - MATCH_SAFEGUARD_DISTANCE (12) when op is in
[oend - 15, oend - 12], bypassing the safeguard check and writing up to 4
bytes past oend in the second LZ4_copy8(op, match):

lib/lz4/lz4_decompress.c:LZ4_decompress_generic() {
    ...
		op +=3D 8;

		if (unlikely(cpy > oend - MATCH_SAFEGUARD_DISTANCE)) {
    ...
		} else {
			LZ4_copy8(op, match);
			if (length > 16)
				LZ4_wildCopy(op + 8, match + 8, cpy);
		}
		op =3D cpy; /* wildcopy correction */
}

Checking for overflow when adding the base length and MINMATCH (or passing
the initial length into read_variable_length()) would prevent the wrap.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261114171452.1484=
344-1-Biplab.Raut@amd.com?part=3D1

