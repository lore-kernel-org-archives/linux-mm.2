Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA05C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 08:49:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B6DB6B0005; Mon, 13 Jul 2026 04:49:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168A36B0088; Mon, 13 Jul 2026 04:49:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A64C6B008A; Mon, 13 Jul 2026 04:49:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC8DE6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 04:49:49 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D8BE16A0F3
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:49:49 +0000 (UTC)
X-FDA: 84983130498.08.5DCE94E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C12BB1C0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:49:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PBH5jl25;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783932587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PLDbO2ux1cY+txVE9sdrFeOPn/1RnZEg4d0TU1FyKEA=;
	b=ojak8FQO4FTaW9F251bZ3pVlSRc0JXLrwqelg6CXfN36Qqsoi66ELb+P05+Rxfkm1NMEQO
	P0hChXf0I52KblUNZRhA1Qqv4mmMfGZRWdBp9N4yD0K1eDQxveZ2zm6ANVFKzu6r3nHmRs
	JdmXL5gWK5hafHr7QHrWn+zzlSNbp5k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PBH5jl25;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783932587;
	b=sAPhi0MpcrnR37nTLTbS6Vi3HIko1LU+74ORk7+j2v4syTbHn4oa2Ppe8FgAGSDoGfZzU2
	ViPiJ+9QYzOlyX5S9u1ROrlUewZjMGPM3D1PNBwyNlnapW8NeMcpn14C3JtR12Q82Bvc9J
	edIx1pS6w7Mlf+DIshH4YX1JvQwjmDg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DEFFF40491;
	Mon, 13 Jul 2026 08:49:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B19CC1F00A3A;
	Mon, 13 Jul 2026 08:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783932586;
	bh=PLDbO2ux1cY+txVE9sdrFeOPn/1RnZEg4d0TU1FyKEA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PBH5jl25LXJEls7/oarnaC+4/Nf7AQbLZkOleoVwnrhtg0NlFDG2ZMGErzRHwk+VF
	 uAjlKgiw74t2KkpMB8KphdeDfoFV00Jv3B5+1rqhn2Y7xUjd7K7F9AVLdyzITGzaN6
	 68w02zxCvfig0Dhlygno3lLVvAAbYNEAzX8Rt71oemrVbYh0/UIdE3QQWgDY//FUFE
	 t5QsXKUfz2zTXg+iyWDkevNPQRWc0NI5seDggqqk011D+zDKqUL0LE0t9jFOfgXMRn
	 Qn7qjwrwJwKU1b3vH350lJfGqKo0BFkhMsGk22LooGSKtas2sj0MHK8/ajIsSmxQoN
	 WYQ4asBUuz3Vg==
Message-ID: <516b7984-f4c0-4cf0-bd40-104579950b0a@kernel.org>
Date: Mon, 13 Jul 2026 17:49:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/slub: add comment explaining intentional kobject
 handling in sysfs_slab_add
To: Hongling Zeng <zhongling0719@126.com>,
 Hongling Zeng <zenghongling@kylinos.cn>, vbabka@kernel.org,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com,
 davej@fedoraproject.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260713070024.153552-1-zenghongling@kylinos.cn>
 <b42f2b3a-68c9-4e3c-b3b7-d940677b4609@kernel.org> <6A549790.3000203@126.com>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <6A549790.3000203@126.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------4fA11zKehzKXGsuWEFtyDd9J"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C12BB1C0005
X-Stat-Signature: 6q73seo5ynaikcomn1ihizq49esyo4zm
X-Rspam-User: 
X-HE-Tag: 1783932587-628864
X-HE-Meta: U2FsdGVkX19PgByiyKu8IQ2P727hzW/uO19zO0zqcvIZaHjknyJzCxugQ+LQJIj6Px4Q3ShIYmEJbJq996x6H4jt0OF0Pi3GdfmM9Y9+w36c9r6mHvtZgpCcYKGe1AB1Nqp+Vd99YSw095XSo51oxKClIHaxYm01wywSHkqqGRSh6jwPvNwj3QBB7Nu8X0mtmw4YL8M1NP9NBC1Z7lG/qXxVVy3SpKk4+IOYuNkZbDzS1x2p8xEG2i7Yd8XqO6Tu5ERSkKTDYzKqzmGiA4ibpoyb0W3ayjMUQvzqqWTlXWv5BcM77sTWMrAyvSN9qnyh/MUGkeMNAjIDxsV0Y2JmSckXgr9i0SeOo7cy/6O4P75/dM6kTm1XTHf7Zm+4SIQ538efk4Yvtt4hSpAA8OOPEk4tSHdskI+i360p9tNk6t2ulwgq/nm2ItPe97NCpzkzteMU97whJLKQdPJ+8vd8dwhyYidiNcjQi/17Ci1AM5AYbfONZdVOiR1abAmW3S+DfDnrh0NdF6mllL1+ULlyZU0iWnqxRm2TyM2tLkVlxdXpwubSa1BLcTHm5N4HqTK6aBM2oCCdQbBVywJfJjvCMpxGT5TLZiQ2v5zBZ3MUJ1qO8pxc8GS20hQbzyHc7Xs4LueQlAx3vvsJjyIqtuhM9srpXaEAUhP+ZF0ySQ7YApPaeQl82yG1bB6SxrYE6X355OvnZmahAK/YGgZBMqbh8tnpLRDokJ2N8CFLxxpiq9XsUF/2/ZJrbnqaksEA9bpoEB/2q21NbKicYKcx79eYaIJYMqrU/ilHRR9b3OGY1b3rpew/YccDPe3Zy68QzDk+ZhhpoA/vettLVDXctBNKCXDRBCmBYdUFTyownvstOMJpnyZrPgcagEy2J7yZJ1HCCgcytYUjbxNTEhSLyDo6SZQmses0SOYR/1scfeSno2wwP7oZ0uQ8kHMIb+/X2wcmSmAFqFr2pLvaKoJ+PtK
 wFoT/PKZ
 v6g34IyyDvt4i3Ln7Jn/u2S0rln8vAiWeGMh1DGWvharSmpRMo18j1+7SAICAG7rwVw6p6S0h69z9x55JQaBl+UdFxS2x8caqS5wrnEUjvGzWvob7FNE6DVGHi0+NUsmB+nALPd+2rrYdVGBs5ICKa9m+bqfqsruPcH5lnZ68F9z3dkogFLlAEuqwpuhBJqQfOX/pfQtJ3QiA2LXOHSQDgXfxowocxchRDDS1mOX05MGdndB65tmUeHzrgPRHAIr7cDCT1Qw2ExKyR8/RSGsIp54a1VP1wyHZ2k6VMHcNHASF/u6IzfGlKmZ2Rcc+6ZyESUdhGN4gi86IHwpJtw6hKFchcefTepf+5zwMoRm+UXqd2NjlFbkpBtkBdCd6hjEMGZwzX3ny+qu3+lU1zOuPfkBPj7Y9f7vVvoDvsFvKO3vBDzYtdvE5DCQFj5R7kvFcKCe2v5iu2QwZ6oSwovnnZyUk2w9estpDtksmXuDpbWxUC2xinhOgI06fLysIwUazmAqoui0ZwfIBsAtn9ccic45J6kST79JkhKQOzy+oYEbBbCCXruFPN7zDj291miie399ibRcG7grlCjez3Yml5in1v1mS2wKwSL8uQRQpDgRuX74zXXzq9Tg+5A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------4fA11zKehzKXGsuWEFtyDd9J
Content-Type: multipart/mixed; boundary="------------ryp4bYEw4U5j0686JzItSYb1";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: Hongling Zeng <zhongling0719@126.com>,
 Hongling Zeng <zenghongling@kylinos.cn>, vbabka@kernel.org,
 akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, vdavydov.dev@gmail.com,
 davej@fedoraproject.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Message-ID: <516b7984-f4c0-4cf0-bd40-104579950b0a@kernel.org>
Subject: Re: [PATCH v1] mm/slub: add comment explaining intentional kobject
 handling in sysfs_slab_add
References: <20260713070024.153552-1-zenghongling@kylinos.cn>
 <b42f2b3a-68c9-4e3c-b3b7-d940677b4609@kernel.org> <6A549790.3000203@126.com>
In-Reply-To: <6A549790.3000203@126.com>

--------------ryp4bYEw4U5j0686JzItSYb1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 7/13/26 4:45 PM, Hongling Zeng wrote:
> =E5=9C=A8 2026=E5=B9=B407=E6=9C=8813=E6=97=A5 15:26, Harry Yoo =E5=86=99=
=E9=81=93:
>> On 7/13/26 4:00 PM, Hongling Zeng wrote:
>>> Add a comment to clarify why we don't call kobject_put() when
>>> kobject_init_and_add() fails in sysfs_slab_add().
>>>
>>> Per commit 2420baa8e046 ("mm/slab: Allow cache creation to proceed
>>> even if sysfs registration fails"), sysfs failures are treated as
>>> non-fatal and the cache continues to be used. Calling kobject_put()
>>> would trigger slab_kmem_cache_release() which frees the entire
>>> cache structure, so we intentionally skip it.
>>>
>>> Suggested-by: Harry Yoo <harry@kernel.org>
>>> Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
>>> ---

FWIW, the patch looks fine to me, so:
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

>>>   Change in v1:
>>>   -Correct the email
>>
>> Hmm, the email "Hyeonggon Kim <pictureone@kakao.com>" came out of
>> nowhere. Could you please explain why this happened?
>   My apologies for the confusion.
>=20
>   I incorrectly retrieved your email from a signature search =EF=BC=9A=EF=
=BC=89

You mean retrieved from your local address book?

--=20
Cheers,
Harry / Hyeonggon

--------------ryp4bYEw4U5j0686JzItSYb1--

--------------4fA11zKehzKXGsuWEFtyDd9J
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCalSmmQAKCRCGXBN6rc5S
1u0GAP41vO5nCpfps7FFbzIRUsDo5ifNrkITLq4kQ1zGVBogqwD5AfGV009Enkzu
3F7bADT4jGuJitJodPUWDW4f46euCQ0=
=pPc0
-----END PGP SIGNATURE-----

--------------4fA11zKehzKXGsuWEFtyDd9J--

