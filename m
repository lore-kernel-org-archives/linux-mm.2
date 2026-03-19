Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90A161091916
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 21:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98E6A6B008A; Thu, 19 Mar 2026 17:18:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93AC96B0095; Thu, 19 Mar 2026 17:18:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8507D6B009F; Thu, 19 Mar 2026 17:18:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6EC2E6B008A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:18:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1733E8C346
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:18:51 +0000 (UTC)
X-FDA: 84564077262.27.5A32B0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5AA534000B
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 21:18:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KJ8ZnTkX;
	spf=pass (imf12.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773955129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VZQ17f0xaH5Zv5+9eKf48HmR0fItDs6lP91NPTK3GmI=;
	b=8J02s164KpnIRShou//0qR3vGfnNIyFVFD3O8GZG/sZZ/WZxxXYsdFNjuLnz3Y4rzpmG0n
	/6ApXqQeGPkzy/ULpLuIiFxvkYX8njh8gcerxAwf+9kQlbwQV/XLpNIZjfpFXEzAsPSteD
	DxdHWukXb/YMuOt4yt9N7+pN7GPLwjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773955129; a=rsa-sha256;
	cv=none;
	b=x5XGrIfVbe6WJvFiawE+ixQ66klbm2RingedbD+SoHPC2HvrQ70uQQpc/8Ri1b0Cj8fBk1
	uN+xuG+5lhV2c5IkiTQKE5oFK+NyLNxTdXG3itd2cxGiG5puToulvN4CztBJAG2lOmDb6Q
	5lHcm6piVNk+mMdxIzIKXyPVsZj53GM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KJ8ZnTkX;
	spf=pass (imf12.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0BDD843706;
	Thu, 19 Mar 2026 21:18:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89141C19424;
	Thu, 19 Mar 2026 21:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773955127;
	bh=iyGg7B3966cWSQIyN/bVLygV9d0Fu88wOZumZJmaoFs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KJ8ZnTkXzOfNvyMlO9orCkiawG4WdTBiPX6O1pGIfGS5nihGO/0S+S06AO1l/1upt
	 7XUU/0hylinxYQ9MdWqpACBUjwV2ysAJA+mm05Kjczy44jV/MK0fg4v7Yp8mbFv9UD
	 0ubFGXdW4umRu8ycAJEz9tH5NVuA4iC8/h1lplWRL4yVcy39ncKhT7s0LjMC1mj34E
	 OOIc9JVTsuyl7f/60uCtG9eHyPMVs66WnQIRvHuHvF8mmDK8nxrHN02y0KCuBk5cgj
	 INDej6+V7FzzhVJLlBJ6jX0TnZEM5Y+M8CwGI4ZYP40galHKhnCjrduIxL95SQaTkC
	 B0Gqc+IZgSvTQ==
Date: Thu, 19 Mar 2026 22:18:44 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, corbet@lwn.net, serge@hallyn.com, 
	Martin Uecker <uecker@tugraz.at>, linux-mm@kvack.org
Subject: Re: kalloc_objs() may not be as safe as it seems
Message-ID: <abxmpctCj-E690An@devuan>
References: <abhGS0n_RsUG97Ni@devuan>
 <202603171402.B2BD1B1@keescook>
 <abnGea5Qwp3VYDda@devuan>
 <abrRMnxzCKEuhnrS@devuan>
 <202603191308.ED08BC65B2@keescook>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vxxczh6pcbvzosks"
Content-Disposition: inline
In-Reply-To: <202603191308.ED08BC65B2@keescook>
X-Stat-Signature: 441bmyzkonpej878icryk5yjpw5fgn4b
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AA534000B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773955129-440121
X-HE-Meta: U2FsdGVkX18PWn+gj9ITPjAvXcVNgaZ+s8cg6Z4+YVDPa33Th0OhlsOATcrS7mAgUq0VwWchP/qmybbkKzDXtoyaok5S3ObQO6ckVsYLQKYqw/xtrUseNFZRuccSGKD4d2jOubZ4z8+53Dn1wc626QP7ZVl3pb79Z/Qobq4Mh6+CCeXO4Ypr9un8kfZ/C6wW+odIihIHb+zAZWgyNe0xtGlU/LW5GUOgweGqGbET2ZRg5Ev5174LiyQyNJdh3WO0CW+xqFH2QM/9y4PSTUXRoCIXCyV4MljeB/QK1j3vWUxOmWPlGlXVv6CpxB0zmSh6ety7nFhTBAxmq80I5jtjtrzyYUPqFl2BZTrllxEKlSmY1GwIYCJWwiYRCzX4MKgb2UAAFtjp2mQLBDi6w1ShIHwwsH7MSLBVUvWn5D2lqP1kPamzdNFrcyJ3icrd/s9EXsaFvQUgED6GsPuCb4by+mTlrVDFFDhj9vJgsA+qqtSM53LNacbFNmxAJ0lBfCqAFwOmx0OQdcaX/+lYZUy53qgeBjBIeJh9xUPv/S/2mhnpNNGSNnshGXnGE/KXHDWOtARH3j1w8e4K2QP8Jzauw9UYRzFnsgwfOblIzUARgHopWZ/KQ4wv91ahrRv8rfWUIW9zcg/L9SLGjOcnd/6/zOpTLDETvJpvWDsxHQqf7JqqfipL5weYc/ythKRo/nlCcxu47gqEFzL2VLP5syp+ix8OD6fW/FMVaDJ4hI3JTubpRNK7K2IZl9QJUzfv+XMFJ8XI7exR6KPDluYeBiz041iPp+Dho7Gtq5aNsktJ/2j6I5W2gwh5jTGw69ZzV+ZSEetH8iY3vCZQnbCM91rWTwtHxHxALWYd8oAx5lv+WKcWTtGQ0v15okC5PjxKMJNIDm1ru/eH16Wn02vRRBAv5xbHh11yDHKdEwhFblhS358XVKEYAB+/c/9qypVR9mQG/4JHJv6hLEpa8Qx6P3D
 fJCW7Cwg
 yCo1ehLkdkt1NudztSU2y70I2PvZw5JcM8dcThECWHiAMrxco+C1ZH7//aeKGwzwmgbfJDmStaHiMtNkfnWR5FLUQekaKCCu0iT+BIZVHrIcrWCTAbbKxBddt53bW08JeHZrpM5tOSGalK7gShMqDMxdLe7vTkZLaidYgLzk0QKw/CvqkPRYn/DS+3hfVc1ni96jA8vFjXsQ0CdFhSHN8G8JJ+lOOBltUVO8Co4g+wjERlEcZp/pSYL7mL9fe4PlPCO/7fYTdAUIBi2OJbJqdAFbEl2XM9Zqjwkuj2ImRY5rfEUMnDlrnd33cLuZOtiLMPxhA+u+et6NK73g8TdJcYRJhiLr4hZhO8tbm/yiy/UnYXpu5+Ms3VpmNvvE/7nw8mxim9Hrfuj1ae4H/xkCuUaEZlwag9b+e3AXboYixPVfMXAGGBSUpZdBeIDxiUjEYAw6aVm359xaxblo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--vxxczh6pcbvzosks
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, corbet@lwn.net, serge@hallyn.com, 
	Martin Uecker <uecker@tugraz.at>, linux-mm@kvack.org
Subject: Re: kalloc_objs() may not be as safe as it seems
Message-ID: <abxmpctCj-E690An@devuan>
References: <abhGS0n_RsUG97Ni@devuan>
 <202603171402.B2BD1B1@keescook>
 <abnGea5Qwp3VYDda@devuan>
 <abrRMnxzCKEuhnrS@devuan>
 <202603191308.ED08BC65B2@keescook>
MIME-Version: 1.0
In-Reply-To: <202603191308.ED08BC65B2@keescook>

Hi Kees,

On 2026-03-19T13:12:41-0700, Kees Cook wrote:
> On Wed, Mar 18, 2026 at 05:33:35PM +0100, Alejandro Colomar wrote:
> > [...]
> > After sleeping, I had some idea.
> >=20
> > We could have coccinelle add typeof() around the first parameter when
> > it's an expression (not a type).  Then, we could enforce that the first
> > parameter is a type name.
> >=20
> > That is:
> >=20
> > 	 p =3D kmalloc_objs(int, 42);  // ok
> > 	-q =3D kmalloc_objs(*p, 7);
> > 	+q =3D kmalloc_objs(typeof(*p), 7);
> >=20
> > I expect this would be doable with coccinelle.
> >=20
> > Then, new code would be required to pass a type name.  And people could
> > slowly replace the existing typeof() calls at their own pace.
> >=20
> > What do you think?
>=20
> Well, it'd serve as a visual indicator, but it's redundant (typeof() is
> already used internally).

It is redundant now.  But my idea would be two steps:

1)  Add the redundant typeof() in the first parameter, when it's not a
    type already.

2)  Change the kmalloc_objs() implementation so that it doesn't do
    typeof() internally.  This would make step 1 non-redundant.

> Given it would only be a potential for
> confusion on integral types, I'm less convinced this needs solving.

It's directly adding safety for integral types only, yes.

But it's also improving readability.  There's no precedent of macros
that take a variable just for its type, and it feels a bit awkward to
read the current one.  By doing typeof(), people can relate better why
it takes that parameter.

If I read "q =3D kmalloc_objs(*q, 7)", the first thing I wonder is: why is
this macro reading *q??  If I read "q =3D kmalloc_objs(typeof(*p), 7)",
then all's fine in my brain.

> For completeness, though, this Coccinelle script:
>=20
> // Options: --include-headers-for-types --all-includes --include-headers =
--keep-comments
> virtual patch
>=20
> @type_not_var depends on patch@
> type TYPE;
> TYPE *VAR;
> identifier ALLOC =3D
> {kmalloc_obj,kzalloc_obj,kmalloc_objs,kzalloc_objs,kmalloc_flex,kzalloc_f=
lex};
> @@
>=20
>         VAR =3D ALLOC(
> -                   *VAR
> +                   TYPE
>                         , ...)
>=20
> Produces:
>=20
>  6007 files changed, 12430 insertions(+), 11767 deletions(-)
>=20
> Which is a lot of churn...

Yeah, it would be a lot of churn if we were at rest.  But since the dust
has not yet settled, it might be doable.


Have a lovely night!
Alex

--=20
<https://www.alejandro-colomar.es>

--vxxczh6pcbvzosks
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmm8aC0ACgkQ64mZXMKQ
wqkKsxAAvm3vo9ihoFfURqGmOQo97zkx+trQcB2AZggsZ1YnQd0+ZM8fQUXxBIwo
g53D/k9qfEGqdcaf/h/rdeJ1bjFvmDbw2SK5mNzTVb/4tB0g3bAVUJW0XTAG+Bu6
iWKtC1hHLoXUbt+oU8hrEUcpLjenFc+dtw8IoeyYZvNruCCuOsyzm/mx3PwsWhve
Y25DDt+Rb6bSTi5i76O+sUc12/sFUA8D8+iAudZfjbLzieE7VY2igAeZwzOfbD/6
3DF0rZInmQEGEiKiKKkkaNfiYxMm4ZzYubuFMrg498YSTWjR7WD5FgBSD+L1H6vg
CqWgK8eOiA99scpHM95XzZmVVApW2h/uqtVPG9PumvQCalUlJ13OvuY3KwCktO2o
6yF3pG8kGbMqhQehJDY6hjjvwYtK5P6vUi4GlrS72GEJmCeDzZOiKuG8KclcuVFh
b0WSNE8uOSo0m7wP412eSTAemc8bd7SY7fOJkG5kqwhJnfqLdwItu2n2qhEAf6R3
wj8psmq6ywPTOJWD/itgzo9oRgBjAW1gJEbx220Wj6IeTdlUMvbYquLfoRdMxaGk
W4vuzWG1fOzUdvX0+kgcIQS8CjIF/yZZuF7cahPFHcMgdsgt2TC4Lx945gpzucot
ikJ7Radjd3chbAPWP/kSGNoAUPfVIvIRFxH1dkSdUABd9g005cg=
=fEio
-----END PGP SIGNATURE-----

--vxxczh6pcbvzosks--

