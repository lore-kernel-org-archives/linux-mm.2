Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E462AC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 12:37:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1C826B00A5; Mon, 24 Aug 2026 08:37:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF3AE6B00A6; Mon, 24 Aug 2026 08:37:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E31976B00A7; Mon, 24 Aug 2026 08:37:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C51286B00A5
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 08:37:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6D774140124
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:37:16 +0000 (UTC)
X-FDA: 85136113272.03.F888D46
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf22.hostedemail.com (Postfix) with ESMTP id 91726C000C
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 12:37:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=L2tBMjVc;
	spf=pass (imf22.hostedemail.com: domain of mkoutny@suse.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787575034;
	b=6r0An1KCYBrW5PaHdVh2RkqLSbKnAwr5ifWC+dN65WOBOC0ptbQLD5f1J6jWA1FyjMtL8N
	RVWQPOnwJ1fMG6S/S1jCybL3hbevTSjNgmFasbBRQWqPVem2GM0ryQAtkq4CVA21Zjw7li
	hJh5HqVYNEfdSMUXHMsC6/3feyFs//o=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=L2tBMjVc;
	spf=pass (imf22.hostedemail.com: domain of mkoutny@suse.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787575034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFe7CZrh/NKPQiBuCvoXHDZxKc/OI1NirTgmnI07Xf4=;
	b=7Yuv5uWdPCHMG15Y6I4ugLm24yt6TToQ1gc3D7t90O4yDk4kdINfNgl19bSvXi090g6D+a
	7HUfRQLo6EgKhEOGdQjkI0LqbGiszlMYM2Gl7HePUObYNC219/4SHjSB59zPp4LOsgmPnV
	eEJESlsd7ZthJ3BKONR2DdHZKNZekCg=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c1c26d7e951so506198666b.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 05:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787575033; x=1788179833; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xFe7CZrh/NKPQiBuCvoXHDZxKc/OI1NirTgmnI07Xf4=;
        b=L2tBMjVcyEkigoFynYzSbM28mmbWBsc9lEToLudZTe8ZK9gQKrIRvNSMfgfc9QnfyW
         MSFtF45Qf/PtQPwOI1tJTFoX1TDqhUcLm/gAO7mlv7A9VIkfKAyQ0XdFYQEaqtoHEOrI
         zZ7TXBdPX5cr8XshdrTwuTNtG0oL/O4Lmp4RU+MQfbiazDPhyYz7+92sH/Yw6AI3qTm2
         gZ3Pl/+VP+nHc5yP5BLvhVyzY1kj3Kj/tLXYkMnmAzwtr+3L6ASFfws9jXx17WkkBIje
         ZmFhkfZaTOD2w1ooh51YZl6+G8RhFuSlZMuXV4nHw5l6ViziWLftXdndXFJhpesREQG6
         Mtdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787575033; x=1788179833;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xFe7CZrh/NKPQiBuCvoXHDZxKc/OI1NirTgmnI07Xf4=;
        b=J/w1NlHTab8xxQcCU4GzBMkHB3dyos5h2wVejDkK5MboFW2ar6EDhI6mCuv+LqMOA9
         qDvINtvBanGIwbcJ0p0lrvbEtgFcgk8YEKf02vZOvN3B2Pm+scdkbZuqaRq3K757qUtR
         4PHbaH/kkI/Vl98lAfRcJrcac2GZcDu+MICFd14yJTRN9JeAr2huxMRWC3qomIGlfa2J
         mhds3Lxao/xcEsKvw7Fc8Do6ZvH3uiwD3CyUhxG2ZFbShTZwFD1FLPujBCgH27AtUg/8
         lyvkuZmSsp98ggXHQI6Ux3wJilm6n7uyDjoGfEtWnpzVY6lpweY5A5GM/vqJ8ITevNBF
         +EKg==
X-Forwarded-Encrypted: i=1; AHgh+RryxDAy1Von29TSBPB7AytdeZbsjQATCKKU1JsRXReZIW0Sy4HOk2QwV3NT5p9jt9PlXlhfzHu7QA==@kvack.org
X-Gm-Message-State: AFuF++mpm8lAox3YFDP8uDoSu9LkBlieJ20Mf53IbCb8kszOELeZ+BBT
	D94aNeofbHfWZINbhE88YxCgkNcHQKgau3mL+4HLCL9YmIF0Vd9Bw41rsyvfthjfuWg=
X-Gm-Gg: AR+sD10boCeepiZQ7ALDajhY76XTaT2GJPsDMYUrjO4tyzElxFvl7FDxlJ68YCcdchd
	FdlJw0pc4jSgWLMQYcxa3WJshMidnWmSCNXNS3AYzkUj4Eqwvp9T5/UhfUaob44mwNwVwibspeG
	pkveiZaD5o/s1n4Le8MD2Iqcvz6KjmZDuQZTlEaWij0yleKcgTIpKJPsvhz8AQvL5emBApE0AEy
	hfvDo5HuM9fbmCMXD9q9+cFKo08LOT84KGc66FicLYWOIGze/JDhQaupyE9wilKzpSXa8pgYpQi
	dEarFS4D9yTPBQ59g/UWu9ScmwyJym2BTdEBrlM+P92WjWkYrtqM4Hl66OcfUKGqA6Tk7PXDlca
	00J7NjsbzMvQLgyOsV5EfXaAm78111+0qeujO4bu72tIkwsVoLbwCs8hMazKROBJdQMVuO4oV6f
	y6MYHKwNt+8DYMhqikT4aXDQ35VEumWm7C5abJYOsntKQ2VFTQqj+2Jo/CMA7b/o4/PEgUkZUWo
	Q==
X-Received: by 2002:a17:907:7b93:b0:c20:5213:56f1 with SMTP id a640c23a62f3a-c246a60348emr2798113866b.13.1787575033111;
        Mon, 24 Aug 2026 05:37:13 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606b5aasm1253429866b.4.2026.08.24.05.37.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 05:37:12 -0700 (PDT)
Date: Mon, 24 Aug 2026 14:37:11 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
Message-ID: <aow4tSYssWJRjzm-@localhost.localdomain>
References: <20260824033533.2147900-1-wfelipe@google.com>
 <20260824033533.2147900-3-wfelipe@google.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="pfcylgei2cxs7jeq"
Content-Disposition: inline
In-Reply-To: <20260824033533.2147900-3-wfelipe@google.com>
X-Rspamd-Queue-Id: 91726C000C
X-Rspam-User: 
X-Stat-Signature: 4yupz7pasug9cjrb6p1pmtatbo5q8aex
X-Rspamd-Server: rspam06
X-HE-Tag: 1787575034-748429
X-HE-Meta: U2FsdGVkX192DyK09oVaTVSTFxuAWOcUo4xG72rUlYd9t/DTx+tKWbZ48PULL2azDW43ZvOSybiiGcCmNUEIOxKb8IIHxMgAP+GM8eFlBfCi8fHju9Rdd/3rvv8lMum76BJ2sSdxheEG1pkoQlSnzCTi3JfDunsfal1JvSWKVjWf5hnLjUJCZt/laY23hMJyTeV4n+7SmSU1rBwb2h803ssVuBCQKsDCWXFl0NoP/koXJfp0j5MM2Eoz8gRjt8lQnTS7Pw7OthUgmTvlMzTRTga+Pa48UIhPHj9ElQ9S4J5KQKA7L8PiwZSmjR2DcV/pocMOs23z8f2BWuQwzvY3EQvNmcHiu9UHn1Mqer8zT/rD25Mr1H97BRNhegdy/8hTVCz3FRrVJBWQo/dY2oz9Q3vj2CQ0MRvBDPH+ubA+tuJ/5aq5Sa1C1/X0o7ICHmtIZpW/VDZLAt+OuzhprWMQwVpzhyNxeyaBKdzN8Y6DdVszNNt3rFg7ZCg8pP1zD5iZZ8zJZmp888F91PblqtpeQqwYqeGnvTN6JDx14M0l1MCZ9mJUlv8qBtTVeD3hCyDzQJOicDbC5p6pXLM6N4dRwPTqS1arAZ4b68juNl6xePMjbnHeo6LazopEeNiJhzCZmHcL5QDPd6sLG6FBPN6k6NSogozAMaE4EOutQHpnmmLlXK4kazMD6sEnTR1KAvHLpNmkdnA1so+3IepqW1K6k7j1cDAqIlDxtF+TmFEGAc5a+h013yGGPOzGdMKeFJVDr+cpvz05tCDSkW+vpDLb0QNyfx/MX1WAWQyepD73uCT5UonV35atAxd7UVCBmdpff69/fdekmdPRc+b7aH/A9D5+EQzbvO2w92pozcEXq0CeY7rS2Y+U+ga+7OUC3qbAYlYy9DVQk+u+rtqbgqZ2VzsE02AiNxXqa+7iH1kEFOq8G/LFpzHODP9gArmUo2W/zXgqUcVyxklNxPVQZQo
 ENnzh6jv
 YlT+W/6P0LWXNolYEe1LWki6VxwBFq/FhCuDPjk29SFveUMxSDENqWc4y3+dIDk20HOT8FmQWBOtzChpGH4nq9SpQtZSpVZn74+rV0O3ST8ifKxJiG8gzR01xuHgDAsUS10n0v+i93KzJWMIPo2pSJfXhvU3ux/4eFE5jCJwNOMg0hglhNnWfcse4HLh1Gf5HlYnNMrjOiQsptx306iIHSFEvppcwVS8LDoRA6mYVkt4JgSkg037vgn5VP/nKXrWfA4aK9O4bzImANVTC4DLMkuCcyDCocPyNFXE09Mx26F3UVlU724bAYBxkwuntfLha2ZayAlQsJJyw2WM6Km+BY1GYR0zsJsktYW5H+XBCzri5zmhzm3ZDdyDDUKqNuKN5qJp/OO8ymrdU+Qu2R8b3UV2fMGGeVWySw4bApUwIuarDd/gaP3CUiVFQGz2lnnYeaL65cFexDTfPPx31kLNGe0iP00Jb+DsgvtIACTDVVkJTZ/VpAYQPGaN9CK/04tV19QsV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--pfcylgei2cxs7jeq
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
MIME-Version: 1.0

On Mon, Aug 24, 2026 at 03:33:58AM +0000, Wilson Felipe Pereira <wfelipe@go=
ogle.com> wrote:
> In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
> checked against stored_pages * page_size / 4 to verify that the pages
> pushed to zswap belong to the test memory cgroup.
>=20
> Due to slight stat update timing differences, delta can evaluate to a sma=
ll
> negative number (e.g. -5MB out of 1GB). Because delta is declared as a
> signed int and stored_pages is an unsigned size_t, C's usual arithmetic
> conversions implicitly promote a negative delta to a large unsigned 64-bit
> integer, causing `delta < stored_pages * page_size / 4` to falsely evalua=
te
> to 0 and fail the test.
>=20
> Fix this by declaring zswapped and delta as signed longs and comparing
> against a signed threshold, ensuring negative deltas correctly evaluate
> to true.
>=20
> Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem byp=
ass test")
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> ---
>  tools/testing/selftests/cgroup/test_zswap.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/=
selftests/cgroup/test_zswap.c
> index a7ff525c1267..15cc1dfdd1f4 100644
> --- a/tools/testing/selftests/cgroup/test_zswap.c
> +++ b/tools/testing/selftests/cgroup/test_zswap.c
> @@ -621,9 +621,11 @@ static int test_no_kmem_bypass(const char *root)
>  			break;
>  		/* If memory was pushed to zswap, verify it belongs to memcg */
>  		if (stored_pages > stored_pages_threshold) {
> -			int zswapped =3D cg_read_key_long(test_group, "memory.stat", "zswappe=
d ");
> -			int delta =3D stored_pages * page_size - zswapped;
> -			int result_ok =3D delta < stored_pages * page_size / 4;
> +			long zswapped =3D cg_read_key_long(
> +				test_group, "memory.stat", "zswapped ");
> +			long delta =3D stored_pages * page_size - zswapped;
> +			long max_delta =3D (long)(stored_pages * page_size / 4);
> +			int result_ok =3D delta < max_delta;

I'd rewrite it like below for higher type confidence (mainly, an explict
cast of stored_pages so that subtraction is signed; possibly, implicit
cast of expression assinged to max_delta):

			long delta =3D (long)stored_pages * page_size - zswapped;
			long max_delta =3D stored_pages * page_size / 4;


> =20
>  			ret =3D result_ok ? KSFT_PASS : KSFT_FAIL;
			ret =3D (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;

Thanks,
Michal

--pfcylgei2cxs7jeq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaow68xsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ah3wQEAkD4CY79HnHFL3zUOh2xO
fMcsSq7vsvnmYX7s4mYh8CsBAMi2iZwoDAROyEEUXSL3lUZmgimfzFx6ViqPPxyO
Z8UD
=UNwY
-----END PGP SIGNATURE-----

--pfcylgei2cxs7jeq--

