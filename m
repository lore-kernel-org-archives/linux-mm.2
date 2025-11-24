Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD525CFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 16:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A1056B0026; Mon, 24 Nov 2025 11:09:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0792D6B002A; Mon, 24 Nov 2025 11:09:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0086B002B; Mon, 24 Nov 2025 11:08:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D23F96B0026
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:08:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E1F258CA9
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:08:59 +0000 (UTC)
X-FDA: 84145984398.18.AC7C154
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id C8D1910000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 16:08:57 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VALS34IF;
	spf=pass (imf05.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764000537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f5lQkhkz6OWoOGD4pV4m1keUAERPOd0HtXnoXM4yTyY=;
	b=rq6Aq9Cn3oNSLRN1rbZcInbspFtlxW19IbCo+TPS//pg0Q+6dJ0A2f0xG1/i2K2NSbt3yW
	d2mzjTkmU8YuNqAdzBR4Sj/wvDYJde3np7S4j7sSP0l9OwelMPEzOWhAodXOxWG5+nqgdS
	5Iokcm0rsaotYaXapXzyqUI/C7FK7Gk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VALS34IF;
	spf=pass (imf05.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764000537; a=rsa-sha256;
	cv=none;
	b=rBH/3/ZWLyTkHMIpQW7FwziSsHhJmIYjFyVGT8cQWWnYM/eEe4SkqqAxKYZK2/k3nGCLpB
	bsm5GmhPX6FDwjfevkQJiEjiUeD/EAZjiHyDIZiiRmacD+hC9IhKBsxOhiR9gy12k25yFK
	i4hb85rDZhQO9k89MbCn8HHwq/UXfxQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 113F96016C;
	Mon, 24 Nov 2025 16:08:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3BEDC4CEF1;
	Mon, 24 Nov 2025 16:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764000536;
	bh=2BS6q8sZUqbRQw+PypR81r2K3Iad19CiwoNjOq57AjI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VALS34IFSLGOWzKE86Cz+sq9UEoIbMnxZQq4h9tfr4CJIeWiHQ64hsMoVXWxbvc8U
	 00Xc44eBXLhsL6x7EFH8vOa14frtzrX7vHlruquxOIDCIgL+2VqkKK+qRjQFeh5CGy
	 O7D8mXQugoT+sSfQ8SgGYWGo3dZfeeb3QYOlmC4rUd2dTQHKG5fLpEiakhxeUeXNOM
	 ISlxlNvbvQGmb7/RUfmXXHVHnVOdwuisdsBKpn0PNaVang3tEmj7z5UpgBZXgrVPi/
	 EX5ZCy0Kh2NKo8GqmhrfdOAkrJLvVJzDdgTbd8yTUtgqHTP24hJXiBN6iRhnH8AK9Z
	 N5KwNyZnIKqjA==
Date: Mon, 24 Nov 2025 17:08:52 +0100
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] man/man2/mremap.2: fix incorrect reference to VM_MIXEDMAP
Message-ID: <qxqyvoxrtv57wo6honuz765fe2ffjny3k2zpbo3w32wqgm3eeh@shgzoq6dy7ei>
References: <20251121081609.52462-1-lorenzo.stoakes@oracle.com>
 <0a072ec0-6d9d-4cd3-82e2-9df55ecb9aa7@lucifer.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="suhmvda3b27n3t6q"
Content-Disposition: inline
In-Reply-To: <0a072ec0-6d9d-4cd3-82e2-9df55ecb9aa7@lucifer.local>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C8D1910000D
X-Stat-Signature: k8tcsqpghyypbx43twwfmbiap76c9ggj
X-Rspam-User: 
X-HE-Tag: 1764000537-976363
X-HE-Meta: U2FsdGVkX1+5PqS4Do4Eiv4ObhxQBpXF63760luwy1SqEWGj5jnSGYistOwcI4qVkI6u46ZvODhBe4y4MLHEd8+a4fKJLS9rThgio5+i/ClXgZrbEZh9AoUQt2gFKdbuQjxM87T514MeGGv4Anh7Jhu+8dQFTYUXZYWjSVNhjNJUxgh9V7hxbfV1IqQgHZRDoL7GN7kTWvf0zM4qyPCIWDKGXnMZA7A25+l+kgzz2/xUuqX8rjeE9vspf0Gws8j0gsR5yvema4yQCnP+Dwa0fd/tWadc3LVa5eYsXWuzUafqo5tqMIBJ+cs3bjhKMh5DeIflkxmi9ERD4FgBuOw1pblhuSKVLmOTjFIr8TaQ9PB0QbOh0fYfBCh6nKwvM6kLpSnmw3kjO/U+4bwd7CVewCfNkgnRGfMAlHTFkndioBp2TeMcjFfKj1U+8q/XsSqhslv5CobJCPiAT3ZfhG6d2uKuzLOzfKvwZcKu/92A2I3AjQiHZFY77hvpMQ9yc2iNYr+ssdhi5W2jWZvo30hLVwxkj0nly3ZD+G3Kj9KKntiwfU6NUcGV8x5ctXh8zjgNXEVnMNYyJ8Jtb5SqBHbog8ZssiCkJTpUUKGitAND74RXun5fnqfZs6TDco0qLfjIUCKbPyvlVcgR0Zv2XNq/ekhJeFIUHJRDqP8FS15ZPw+YL/fKzdZGCRU5P2HXOq0JKUT2CXP2Hv+DgpdIUlQXtiOpG10lM96ZRRh0/tjKEPLNnkBCtyQvKDyp99ahSbvDMGo0y6tBlbktuinvTsxht1c7svYvazbW3mt2TjJ69NvESU6oqp+LRjG/nlHB39/Wh8A3ovkuS+3D0jvJDugpLz4B705XMGuzFnPbg2//nk6W1FZZRP6ItMtyzVGgUZ5czjHhL7FZ1lm1x/E1hwve3CNY8YSCB17eDAcyDo84lFh0xQqgeuHzL94/K18Jg9s7wwlPnK9+oXCUT5Uqg4W
 7fxHRh78
 EkK2brL3S51BC0UUKmKzRhg4Ud1Z5kxLJpTKiL/wxe8A/v8+0vOhzpR5U+s5+XGoPSLmmBCn7hnfdlw9QDtmcedtes8d5o22M4+lEdH0oqCw2S7Re8QZKXyaeHgN5ELYYlelBQYYTPHNYILv3WwV3aD6vSeuf2xUMContrMmvk5ZxgApkb5W2/XHwFQPvAXmk7JGMxNqjeAa6llk0y490LILe7RJR/u4zXq4lviHb0CyuWiC8hug8lminy+205yaCQ/gSrPQSt6BKYQvCMS5vHD/np/OXfAdlVtJrmIjMh+Uuyhp73funkALwlrvLKZQTrSHtQeG2WYfDtWqFqeU9YRxItuLE3CbMz7g3kzidqSUKNgZLpTpVA1XanDaMy2yK1rgmgohhOPhjKSwUWdNLtAJIDcPMun78HXcZtOABNDSdkC0veOlYEGYMcXbJ7mxFKhMoDKhPsz52d9Y41g/id8maW/MDhmCBFkqU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--suhmvda3b27n3t6q
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] man/man2/mremap.2: fix incorrect reference to VM_MIXEDMAP
Message-ID: <qxqyvoxrtv57wo6honuz765fe2ffjny3k2zpbo3w32wqgm3eeh@shgzoq6dy7ei>
References: <20251121081609.52462-1-lorenzo.stoakes@oracle.com>
 <0a072ec0-6d9d-4cd3-82e2-9df55ecb9aa7@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <0a072ec0-6d9d-4cd3-82e2-9df55ecb9aa7@lucifer.local>

Hi Lorenzo,

On Fri, Nov 21, 2025 at 08:20:12AM +0000, Lorenzo Stoakes wrote:
> On Fri, Nov 21, 2025 at 08:16:09AM +0000, Lorenzo Stoakes wrote:
> > We actually disallow VM_DONTEXPAND and VM_PFNMAP for VM_DONTUNMAP, the
> > manpage incorrectly references VM_MIXEDMAP. Correct this.
>=20
> Of course I ironically typo'd here :)
>=20
> VM_DONTUNMAP -> MREMAP_DONTUNMAP
>=20
> :P

:P

> >
> > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks!  I've applied the patch, with the amendment.  I've also added CC
tags for all the people in CC.
<https://www.alejandro-colomar.es/src/alx/linux/man-pages/man-pages.git/com=
mit/?h=3Dcontrib&id=3D466c43360f3874a890e910610d4d01ea135d020c>
(use port 80)


Have a lovely day!
Alex

> > ---
> >  man/man2/mremap.2 | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> > index 6a6df8601..cbe960f77 100644
> > --- a/man/man2/mremap.2
> > +++ b/man/man2/mremap.2
> > @@ -206,7 +206,7 @@ The
> >  flag can be used only with mappings that are not
> >  .B VM_DONTEXPAND
> >  or
> > -.BR VM_MIXEDMAP .
> > +.BR VM_PFNMAP .
> >  Before Linux 5.13, the
> >  .B MREMAP_DONTUNMAP
> >  flag could be used only with private anonymous mappings
> > --
> > 2.51.2
> >
>=20
> Cheers, Lorenzo

--=20
<https://www.alejandro-colomar.es>
Use port 80 (that is, <...:80/>).

--suhmvda3b27n3t6q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmkkgxQACgkQ64mZXMKQ
wqlUZQ/9G8bz0/Tk9TsQUt2t30n9mdcLfS4up17YIY9gkiX5QOpFzYwQhDnb/2/l
NFDJhdYmZRFMWXZTlTGjWm+QuFgJob20bC0nlaxmc5jutrJ88iaLsG8ROfOUG2z2
zptzKOSQHCzpQLfOQbfcnTuo1dUCOflhML3ddH+Qyxq1+fGx2/BA//kePrz3FuKv
bDOCVMI+Jgaf57aX7+UvgfHa9y7NL7O3EK5YLdHYetbQQiCb2+tkK8ZMKWRfjgAX
QmKaxJg4zxaoOn2FsSVv1oc9f+mYwrrd55IQJFKJdR0UKz43KCtk5vX7WI2jMCpq
oXZugSKohCAvPTHZ91E3EkmckRBpB4ushPvc0DulWslWfSMyEBMmFZpWEI1E0uss
Shu+HRi9Vr1DJLOyGu1TTSYKlsc5FrjfLW5oUGfEkJlmjkxpnbO58vNLHTKs03C3
JsedzI4LioADh3d/rAl/QVJjzh0IPz9SS+ptfrd6Ivs0/DcdaOPakqUs0hVKeAta
VinIgeDKzOMBClqW6uqiegp7lPf9xxHkJWcWKHoehde8qLvR7QyEwmTcDgRatIEk
LPGl/gHCZ/rBiBqB2Dp40y8lpk0xZWN/MKlqogMJi/InqBasHcdCLSmwbp1ZYRFF
vqfebiU6TO54ToQT2EJ8DGfuQU/1htsj6FyIFuSGZ11hyXU24Kc=
=AiEG
-----END PGP SIGNATURE-----

--suhmvda3b27n3t6q--

