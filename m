Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76020CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 10:50:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1993E8E0058; Wed, 20 Aug 2025 06:50:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 149F58E0003; Wed, 20 Aug 2025 06:50:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0382D8E0058; Wed, 20 Aug 2025 06:50:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E0F178E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 06:50:37 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8881E160434
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:50:37 +0000 (UTC)
X-FDA: 83796817314.10.C05903B
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf17.hostedemail.com (Postfix) with ESMTP id A066F40002
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 10:50:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eHAR25jQ;
	spf=pass (imf17.hostedemail.com: domain of alx@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755687035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMZIMGd12E9wUTbpvSdFvpdpH3G/PISEB8xFxSOQZjU=;
	b=710rjU6qKJNdL8IG+gptSiwWbr0c4RjjpS3WrZ3KgTnism03y9MyidY1puPyp1fRQvWODn
	cu1GCRSstLcUk8cllMNp2hPD56mBKfVhlKaEouY22uG0Jp3L6COR8pHy58gzv+1gGsbVHG
	V3V5NXkIQ9atDfUNcvkIE2Ek4zbUiNc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eHAR25jQ;
	spf=pass (imf17.hostedemail.com: domain of alx@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755687035; a=rsa-sha256;
	cv=none;
	b=PfXZUub4Y5UMOS+OpnBw3t/X8QOB8hGqoB+hciItH5FLPbpZ4JTTWYgy0wyD0YsJHLyevU
	jP1kO+CHhoBEjE9dpzooRh3VIs4mLmP31sZT7b9huWOJyK9Q2hiEaRtJN5SYCDtVnUIp/c
	djPGjTBjAVos+33npU4Tks5zBXZjTYw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 805725C661E;
	Wed, 20 Aug 2025 10:50:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AADC4CEEB;
	Wed, 20 Aug 2025 10:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755687034;
	bh=gWY1s90mqkGWkH9wCn8pr68I+Bv91HSEex4Dh6PPwB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eHAR25jQJMzXI1NRMRA8WanTfcgs6tBSk10Oa4FMzTNqvad8AUQrmqVUtCgbjg88p
	 z+au1YAXodfjmtOO2V98+YtgrcLCqvYEe6Z8eRmGFTQ6hlTX2bJOjhYdjaEupFfnl2
	 J7Wm46UOW5imlOHmZJJOcyE0UVybthEsIXrNKm3DqTPTxfZM0w4XN3NY8USKXooZ41
	 uI9QB+7SQcO9LSBuJInlHh74X5euEge3wzoz4iNsqijRZ5RLtjDXLNVAHBuqZ3mM52
	 XhD8OW2+tpqzUbMqDlLc8EyKF7NH1xe/aNIxRl6Ovj4zC9okADcxzAfndaKzOAN1lX
	 vvYUX+uim7X3A==
Date: Wed, 20 Aug 2025 12:50:25 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/3] man/man2/mremap.2: describe previously
 undocumented shrink behaviour
Message-ID: <jmjlamoqau6rs32ldggra4ojiwim7b7h7xtgzh63m64xejsid4@cdnae7mjdeh3>
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
 <ab2264d8c29d103d400c028f0417cada002ffc11.1754924278.git.lorenzo.stoakes@oracle.com>
 <uvh2e2jjdk44tdwrhmnd46atwgdzwwmny4kczxqv2vm33gjqpp@63lsupn6y2u6>
 <fb880acd-25df-4386-a13c-9b68640477ef@lucifer.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nokfytcmk76thnjv"
Content-Disposition: inline
In-Reply-To: <fb880acd-25df-4386-a13c-9b68640477ef@lucifer.local>
X-Rspamd-Queue-Id: A066F40002
X-Rspam-User: 
X-Stat-Signature: jpxd8gxudshr9p5qacm9s3j65cg86xm1
X-Rspamd-Server: rspam09
X-HE-Tag: 1755687035-875254
X-HE-Meta: U2FsdGVkX18jqbbChjx+6O1AZH0a/d1aNx+IRvGpMg/wdlcCFZ8K1JXMf+haQLEAUGVDjs7q75flBmu42Hc3nzZU7wMdO2hKnKGbiWlQV7uBb1YNzBwXO7cuE+PEk9ScCqdQ0IhaupWDaTEymPlIM+rWXDa9W0M5KHngkO/Oau1gpFn/uU3ePcxL9v9QrnYNNr6TkIdO246GnSeuJDyX1OBxHdE0OWnrDRJcWC2JMyapB+Hxamyahx+sMe3IdsthMayiE+0e+Iy9Kd1f+mHItJ84n5lknCK9HCO4iun2qi5384v3nKLUqwetkraHaIrKvMN4kNrD9i1/qyxPV58gA55PVTmOnhpah3UTsDKz4YkPTGWaGS4v634gTdQcO6xsP0AQpoEyYyGzRW5CUuUgZmjvjuU3xhPTteyX5CTeBNchVoNNbSVtTVmRScFAGtrPsILanodVPkNsM9AcZxrp562+0pIfG7UK+MlEDwQivltsrB2zcXs5+6GLrfM3YIKRFUYoCzecZUWtJ2jD+7DElvrAgZnKg4MYIaRXHRDFlkoVHeD6X8BI5XHzHnmldiFeHHKkrLTvg6tGGG41kIuJc1LUoK0zhhBRbDqPdiCs23MDWyyhQSDBMZfVYBjtS4Us47ESZRFmY/hTTwCSVOBl3/4YWIUJB8nBoY/E0lc6TjrCM1zHe+j4auDFDBXh5hHDfGbetFKiUlYMqoAiVbGsFCcFLocHoIqwCuvbN42pmSf9XCDLEx/46rQIHsvznRhKmXn/vUSgkcNblVyqF86qyZy83pHFFi329xzYoajVte1vzCygD8pVajCPw9IoAfvMT6kSSZot5b5Ym2rbOALRB7H9zwjm/iT3ovciAnue0brInJF4UP7O+HjwgSVbm1S74sD0K4/wwCJ15Rmh/boDKjJkJF35Lx+st9fnuXeED+t6+n6ID4F+y1+vy0VA2TtSPpkXtP5gV0APJyDJDXs
 0nZpxr5E
 wD6VOFdiGnfgFy27PQCk5PLMtTUuMXV6kZrgt6lBBaFtdurKCX26xLd6eKkeoW9B+XRdpO1cyWC0catCr/cP+/kTk6kDKj405dBOvjJGiX0UOm5yuBgL8orHaQT4FvZiP/UTKb5+P4uUZsAFpQe7FWMheWxha+Mbtmb2QG5CLZcPziVj9Q2LurwhlSpyrWJuMoAY0be3SaSmmx4jzk5DhEqcYBVEyK/5y64Obqq5m1aQKGxRgZLE1loYiQ3VyK/LXycs3S/EMKJLsmN/WZpK0Kci7Qj4afyrwFzD+tkKVoCgV6vKj+IYaPwbKbK1oIPiw0R0AOdyZjgbromMss36FjfkiWrZFYbeNExPzGVLxUNmG5X+eIZJ8yfq/icuyfO8Nost2s/XsGPB6pzL2IBacolQrJtwPaAnpWnLt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--nokfytcmk76thnjv
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-man@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Peter Xu <peterx@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH v5 3/3] man/man2/mremap.2: describe previously
 undocumented shrink behaviour
References: <cover.1754924278.git.lorenzo.stoakes@oracle.com>
 <ab2264d8c29d103d400c028f0417cada002ffc11.1754924278.git.lorenzo.stoakes@oracle.com>
 <uvh2e2jjdk44tdwrhmnd46atwgdzwwmny4kczxqv2vm33gjqpp@63lsupn6y2u6>
 <fb880acd-25df-4386-a13c-9b68640477ef@lucifer.local>
MIME-Version: 1.0
In-Reply-To: <fb880acd-25df-4386-a13c-9b68640477ef@lucifer.local>

Hi Lorenzo,

On Tue, Aug 19, 2025 at 09:37:39PM +0100, Lorenzo Stoakes wrote:
> > > diff --git a/man/man2/mremap.2 b/man/man2/mremap.2
> > > index 6d14bf627..53d4eda29 100644
> > > --- a/man/man2/mremap.2
> > > +++ b/man/man2/mremap.2
> > > @@ -47,8 +47,35 @@ The
> > >  .B MREMAP_DONTUNMAP
> > >  flag may also be specified.
> > >  .P
> > > -If the operation is not
> > > -simply moving mappings,
> > > +Equally, if the operation performs a shrink,

I've changed s/Equally/Similarly/

> > > +that is if
> >
> > Missing comma.
>=20
> Could you fix that up? Thnks!
>=20
> >
> > > +.I old_size
> > > +is greater than
> > > +.IR new_size ,
> > > +then
> > > +.I old_size
> > > +may also span multiple mappings
> > > +which do not have to be
> > > +adjacent to one another.
> >
> > I'm wondering if there's a missing comma or not before 'which'.
> > The meaning of the sentence would be different.
> >
> > So, I should ask:
> >
> > Does old_size > new_size mean that old_size may span multiple mappings
> > and you're commenting that multiple mappings need not be adjacent?
>=20
> Yes.
>=20
> >
> > Or are multiple mappings always allowed and old_size > new_size allows
> > non-adjacent ones?
>=20
> No.
>=20
> >
> > I suspect it's the former, right?  Then, it's missing a comma, right?
>=20
> Yes could you fix that up?

Yup.

>=20
> >
> >
> > Other than this, the patch looks good.
>=20
> Thanks!

Thanks for the patch!  I've applied it with those amendments.
<https://www.alejandro-colomar.es/src/alx/linux/man-pages/man-pages.git/com=
mit/?h=3Dcontrib&id=3D21b1c7188ce1d66ef294eb1681361315a35e8070>


Have a lovely day!
Alex

--=20
<https://www.alejandro-colomar.es/>

--nokfytcmk76thnjv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmilqHAACgkQ64mZXMKQ
wqkzYw/+NJLLAXvOxXNL5cW7CwdtKrzPktot1mon3rehA1zrsieDoTJNXTxcL8O5
TbDMKNgfCW6FpCKHZBQOg/l+B4VjQfxBEYVxY7pDuIEqwyWHc98KdolFDkwCMfW5
rRlCAF8jaYegdjGmkvGITH4HEaoC8YFgZ/4Nw6qDYO380PBDFwBq5xUSgT0Ztxpj
XOHMgzKAyaQDuBdbT+rU+xGkxZr3zWJEUDq+bM7HcpN55xroaIwtgHTeecHameTG
otOG6pGKSD3/0DrIUPWXZ19KJOzeh5QlPyYxqDAtLF1qUx3fpKdmjSFzmSc7eInd
nTAYf3V0b/W3X/MV1ADJhiJnnDybznVvm0vGQ1SbAmEXgl0IAv/kruP3CDVEekLb
sVbkiLnDtB3ub9AWS/n/vn4SQK9m59lVDpkJoMZh3flZtAnAUNQ8CudzWKZe0IZw
lwKFVH3k+NQ9705FCbS0a7YXIcL6UcupADHVSlkZr8xMtTCbqzFxYzMBHXbF8+hS
suEtrHZ0GN7TRGVVJvsJkdl3ebRsiKmg6UlMwg0Fcj/owx6Pdh/nwKn6qiQAAqsk
DLuXkr4+Sl4np6v2ayEuI5Y10O9HakgkfMCDh8o58j+2siCnmCBwmhvKFjJYO/eN
T4XARwzsGM48Lxxt1VTAW+F3jN+TKUCM6ZuT5d9Z3vhrhyL7SOU=
=5B1m
-----END PGP SIGNATURE-----

--nokfytcmk76thnjv--

