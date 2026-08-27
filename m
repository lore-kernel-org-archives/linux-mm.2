Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81431C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:26:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CEF46B0088; Thu, 27 Aug 2026 05:26:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7266B008A; Thu, 27 Aug 2026 05:26:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 798846B008C; Thu, 27 Aug 2026 05:26:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B0C26B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:26:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 55CCAC0135
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:26:51 +0000 (UTC)
X-FDA: 85146519822.22.F5370FD
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3155720009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:26:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VWCr3PXC;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787822809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CSb//Yyfi6yM9PjxFa7J5F68VS2QYfjeIUlC13z5vwM=;
	b=DMP8WT04oI/HW2SBj1Qkk1ghY566cK6SOJB7GPC3VifuoiYscG1r9JdO4C9Xfo1UyUyju2
	7fCF9TP2M4wo9b8HKsNliJAi4X7KQ+vmCcZITycv23hZLInYs9J70S6G2NbDR2qD7L5PMa
	FSnLHN6CvNKdTzdcDhgk5zfcowIUBTo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787822809;
	b=tdIp+nWcZJfEZ8yjYR+kVMh5w6DqbMZoYcQiEFMwmBqf9QkBNsN0Yu6jFb1HVOv3hO6mWh
	BDD/Kgai/pfRCcHn8QY4B+Go9Qh0AYh/jKW0qjgP6JxxDONGsiNKm631k6rrN/8FhyHinr
	0IihNOqd9btzwKl6oRwQOL0YADAo4G4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=VWCr3PXC;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf13.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=mkoutny@suse.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-49557167508so5106645e9.1
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:26:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787822808; x=1788427608; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CSb//Yyfi6yM9PjxFa7J5F68VS2QYfjeIUlC13z5vwM=;
        b=VWCr3PXCJD4We5lHelb+H3mkcMXNZ/zIbDyilHaCm+rv4tzux+yo7+37mooueHlmmH
         VcUfGLH/b/Ka3R9gCAu77hVIS7znP52bpubVvgv9lMveZe9sGtbBChoXV29lrzrYeC/C
         lnKN4mf/As2pFdBBdS82c7H/tdQPHWkI1haVS4rNKdcnXmpoRZqV7ZOOdyik73SlUb4W
         F6WhlIHAgeG/kDfrEBFcqQIBj0hqddNFTDvNi7bakOel1KoOiKpA8D1BuCYASZyRtqnW
         aLua+1FIqT1NkFBF5QKkA3JUDPI8ZXpp2HKz9GpWy5qm7UgVOJJEluWDpqXQpiPOL7or
         Aa5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787822808; x=1788427608;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CSb//Yyfi6yM9PjxFa7J5F68VS2QYfjeIUlC13z5vwM=;
        b=r0Da6MpqF2tNSZ4A8m1YvUFAfe7JQSJxq19QD+Oi8t2wMFHbvWI/QLzA1oAuhKl7jS
         Oj/9zaJYgYM/KGpsOvs9EMJ/+YkUNBI5WeY5VQHThq/gWvBsO6MtiNsQkIE+IJ12F4dw
         mK3WayQAXnRLcwnxCbFm65hX6Aoam+EcmIaAfcEfVDHSiApPPDRCcFl64F1n5+K7POHi
         YcNou/h4aB0BAuQywbvZPMceEQ13CrlS3r+pTRptgMpfbLU8GBpYMLg9FFPRaHsECOfM
         nuSevdrg7P4E87f+qmFQ2gtEbgnYQ3wprpwkxnQfrRxtVgKYrbJBnei7msPEmXa+TwL2
         4AJQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq9HYbVTeDehWLQrnKx3Ql8NNK17y2jLxg+JL0kMgJEZAU6TowHu7jzYaSdc2afxK3Sm4pLlLotlQ==@kvack.org
X-Gm-Message-State: AFuF++n/4ysGZaal9duGtsNHAlQcEq/Y3zJ0GNP2SBsTTyMjGOL4KS+2
	FmRekU4Xqjmzfg3cBzoMV5IuTCkp43qa5v4vf85g0wGYdXK0q+fMONYbvPZY8PSmvhU=
X-Gm-Gg: AR+sD11w/OOkNMoU7Xqd1DJfh+YtwQcMHcnp9TnKg22eKlj7LGBoCy8l1Uu60EESRKZ
	EWEbiLUAslzXvTF53taoZnTuQfAkEBjnC234kNzfPWGRMJaR4/sHpcPSfbrfOlSoQvFTwrg9bJw
	ylmpVLmB6Ohfq1mcqXr+QmpD3wcjVztiAXgGPkRnKZ604KGSRfB5BfncsQ1xZAiz4F64e7G1FQF
	hrxLbPwfn3fhWIRZ3muELCjJ46HTlZatnz5oCzyoNkgr06nV47oU4YwyyPdjRLjG5SMF2tVntPj
	OBzxG/y2Ud2IU3ca0hFZbK8Rl33X3aMbNW1BK3HcjLRVHAFnENIWRz0cNAdJXOXc2dEOcg9NfkK
	m2ULXZACHifmfDpFD05iWpDMsud3ryvA7RDwd04t3Apjk6T6aCzGEKwu1KsZ9JI9UH6BVQkLApy
	31ChDENYgaDpuPGJbwmKduzGqIzA4JIaNcTHtGcaHLpEXrmDKTk8gtZ5DeL0V+q9o=
X-Received: by 2002:a05:600c:c87:b0:499:d22a:8973 with SMTP id 5b1f17b1804b1-499dc6f47ccmr119410575e9.1.1787822807532;
        Thu, 27 Aug 2026 02:26:47 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b49cc6446sm32113475e9.7.2026.08.27.02.26.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 02:26:46 -0700 (PDT)
Date: Thu, 27 Aug 2026 11:26:45 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: sashiko-reviews@lists.linux.dev, tj@kernel.org, hannes@cmpxchg.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>
Subject: Re: [RFC PATCH] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
Message-ID: <apABJglqDFcB02VO@localhost.localdomain>
References: <20260826133054.88529-1-ridong.chen@linux.dev>
 <20260826134733.051941F000E9@smtp.kernel.org>
 <0c606cf9-2b5a-4549-8ab1-0be619487412@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xzefaujiz7w5j4fo"
Content-Disposition: inline
In-Reply-To: <0c606cf9-2b5a-4549-8ab1-0be619487412@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3155720009
X-Stat-Signature: j4c31rxb6dxio7euryenw9t4ziyoh71m
X-Rspam-User: 
X-HE-Tag: 1787822809-907269
X-HE-Meta: U2FsdGVkX188pOxjsAP3KJi2xsJbfNl0CtKXaCtTSUIuJl7v40DHjt/FXpvYZ4kLMu7zCremgOGVRPozr2u9jSnz5vtlh9RX3ox+yn0rxQjevxBW7LVbQ9wgrfaxjWGfqYAE2N97eo0AaCPlmRxfhsmvw++Es15iqAh6c0/yDDvoGn7NMkhey0rV5JQNmyvGrYU/mSbjO1zQv3lrhrSVg3uNv4Y9E24SakbzOsruabFK+saDDUNkvma30+TDEnhtdymYAta4Dnx3n4xwCd+92HdLijP0KmFIEshgVhUQ6VVF7W5qkhIs8eZgWSk4Dm05qAW+yWicrJUkaVqTKxpWwYlSEHTEcvfpTsSBQlIbJhFovi3oY6pvg9lQBTdfS9Qo88aEZXewB5f1h1gpSZLk1071fl3096yoIpr/FWQgOZNC6JbXCOMmjRKw9M7tje5zEWDFk2VnXJuUahzmZNgFlnbUoe4Sfv4UvU6DhFIgh9sG/lKqr5cSY8qu1+Bg3uNLN6sQoiH/IiC+hFu4r3uNTiGpD0wauCnE0M285qsWrzVAswN0+C0scNu2wfC3oIx6//g1yS80pFnKjVdRO/L/LR98I4mfmoxfOILbpkZ9+iI6OTcZY6R8U3ShKYvPZPWwecS5R/1nRD1bGMOIr0aybA9LHu8zWVrcoA7Z/UbLwvN70od1BGeXfvVggW5+iX5oD/L2cD+DeADYWEf1GmZGBAtdmsJt29afWDzds5q8qrZq3I2UTTWoO1nNRfG7RyZlc5G3cBtAF/jGVnAnpZSYnSbAZLS5wv3BNztMha/CLweeWfyhdrwAV4dWiIF8VFeepSuTeTAl3eZpPJ1MILHkv57wEH2W3vBjLxHUFPxXrs/IZrbLI+jTDBL+41Pjch8wVAO1MMD32ezLWucVk+4aRxdx0kJrM1Mo38v9Rja1MQ1Q+S7vnJDbNhw7LawAEtiQKEkavyHQvKhym9hDsya
 Vp4ihUtb
 O2gO61/+loOZqCQkuDSrGkHdPZHizwNs14yxLJjpUM3YvUL4zwxmK0NH696LFNY8Xr7UIEyHsI/65/99mU6/4L1a0UksjdTTN8OzOvKFLS9E7xMKHjPl5PzkOm4JDgQaElIwj/MgWwK9Gw4gR0Mg/bgpIT6Uq4/YpZHLEgEfu7IrWn9sO3r7Mk8xu3zuQhicjzKk3kc3lR2EXlXNDyhQw5h3RlHK0b0x2Ba4h+WVPmwcV6jY2qkmiMXiO0FyJcoEohD5/g3m8z2akHUEtwDkcBAzQz+VbVluKw8zZCXlv9GgJPFgR3i7l3JCmX9/mljPuF7aGWOud2DfHVrQhYOz0+gikHeKMPzMcu5ajhE54kebLXJhaYMNg+L5JX3pqvqohXdfkhET7v8OcwvXn5+Btd0FS+YuYzY30rfEh5IF95VQqZ1bPfpL/rznc1izNZCWAuVK7m1HeTEXGFqKCwlA6gtoCRmfRijW5dRdO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--xzefaujiz7w5j4fo
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH] mm/mglru: fix ineffective memory protection for
 non-kswapd reclaim
MIME-Version: 1.0

Hi Ridong.

On Thu, Aug 27, 2026 at 09:29:13AM +0800, Ridong Chen <ridong.chen@linux.de=
v> wrote:
> On 8/26/2026 9:47 PM, sashiko-bot@kernel.org wrote:
> > Thank you for your contribution! Sashiko AI review found 1 potential is=
sue(s) to consider:
> >=20
> > Pre-existing issues:
> > - [High] Integer overflow in `effective_protection()` calculations on s=
ystems with >=3D 16TB RAM.
> > --
> >=20
>=20
> Thanks for the careful analysis. You're right that this is pre-existing in
> effective_protection() and not introduced by this patch.
>=20
> I'm not sure it's worth fixing in practice, though =E2=80=94 the overflow=
 requires
> systems with >=3D 16TB of RAM, which I've never encountered
> myself. So I'd rather not fold a fix for it into this patch.
>=20
> I'd like to hear the maintainers' thoughts on whether this is worth
> addressing separately.

Machines with >=3D16 TiB aren't completely out of reach [1]. Then
configuring such protections to attain the overflow is another
condition, so I'd consider this a nice to have but not a
pressing fixup (separately, with thorough review of occurences where
total page counts/bytes might get multiplied).

HTH,
Michal

[1] E.g. https://aws.amazon.com/ec2/instance-types/u7i/

--xzefaujiz7w5j4fo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCapACwBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjofAD+NsuFu0PDFJHyrulcXKzI
igkF85NY5/lYAU523FvrLmwBAKSa/iEpzYpKL0GrbsrBCZng/5QlqrJuwRFlL0SD
bvIF
=UNaW
-----END PGP SIGNATURE-----

--xzefaujiz7w5j4fo--

