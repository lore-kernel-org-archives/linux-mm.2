Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C585CD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 12:41:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1DA46B00B9; Tue, 26 May 2026 08:41:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA72F6B00BB; Tue, 26 May 2026 08:41:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F866B00BC; Tue, 26 May 2026 08:41:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8240D6B00B9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 08:41:46 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2179E140327
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:41:46 +0000 (UTC)
X-FDA: 84809532612.21.D817FB7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8A97614000E
	for <linux-mm@kvack.org>; Tue, 26 May 2026 12:41:44 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=azEVCv7U;
	spf=pass (imf09.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779799304; a=rsa-sha256;
	cv=none;
	b=jLGWsDUPSrFHOqn+SUUOP2/8FJRqX8PkbrNZgCpWDXU75Y1sn3AwrL9VpoVD42oUX1GyLk
	M0qoGRocCB59DrI2YWbH1qAEH5KqCCzSBdrBBP1r5negkHjWlVUC3ivv9axupWENMTPJd/
	yatLviU1ZljLJ4FFOJSqMww9Auzu05Q=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=azEVCv7U;
	spf=pass (imf09.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779799304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fb5xnIrUsWGgNSra9khNkL+cNHSV0yPgaXG4TLgiIag=;
	b=yW/f4BcZ/D5omRpYtyeCuPAencCHb2PXrEhxKkVkPDbF9QSZCAMbHXeZFurXptwwKG1NPl
	51NLnymiftt6UafzXv0ZohW2OEWFpwg7ZO3BT7bR/xUuVHKEQyhBdzaqVinb21culs8+tl
	VpH1O5s7Wx8f6EYC58j8zfBXKeK2qks=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0403600CB;
	Tue, 26 May 2026 12:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 042771F000E9;
	Tue, 26 May 2026 12:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779799303;
	bh=fb5xnIrUsWGgNSra9khNkL+cNHSV0yPgaXG4TLgiIag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=azEVCv7UdADVAF9Sk6rCLyYdqvbyFkFoGfUVG7R+Y/2IXU1bUVjiN09hAeTuUimU7
	 9Pjj1M7o7UwFYIu0aFEGJise2IXnalbpjYUQcjLWioueego5gIlTeEM6G9bvdOB0u3
	 cN6xw+VCZ+NRvLBNTl9ss8ZGq1VjDPoIIxuIvAsfZk721homUmCwV3l1xRrc+JpvE+
	 p5LYKa/rGy6E3LWjkBHst4CQL/8ZlpRW1hFyL7lUpdI74eIkCb71yVQcw6FdxOkV1p
	 mp1YebGDlefoVBNxgCRL6lmiQUM82PzG9QvLOCh8dBYvNEer406/8bF4D+ZUTO/9u8
	 pf54vJ9txL5tA==
Date: Tue, 26 May 2026 14:41:39 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, linux-man@vger.kernel.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH man-pages v1 0/6] userfaultfd: document read-write
 protect mode
Message-ID: <ahWU62U2Hp2dPX3R@devuan>
References: <20260525122816.1956804-1-kirill@shutemov.name>
 <ahVoUsqYBY642VLS@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="s7aflm6cuvuyxj2q"
Content-Disposition: inline
In-Reply-To: <ahVoUsqYBY642VLS@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8A97614000E
X-Stat-Signature: ah6zudf849bmaitx4gmyei4kaopw8n9i
X-HE-Tag: 1779799304-943424
X-HE-Meta: U2FsdGVkX1+tyJIGAMdlW98BsOzrP6ctIqrRsONwwD8+OF0TwvCusrHQC5UaBRwfKMuw8dXzCd1eZ1k4MtyaWZ1mdGDePT5WU1iOKpKtY6impnkiA02EqMvNHI4C+JlknMh2oP2/dUWBhOYNHQxn/QbmzOGzI+25k665b8dclpgOgAN67FHD5c0RP7GtvW+Mi/yr6e2QBsD8zcsGohU3OGQh+2ohxwRaIcPWMOVHAV4gGJfa2Sn/sSNfAq/uIaBo4ZPn7hV3sm3rnbWtSxhnH3czL9KsjuxijPSamoQRsS1mat2lYxgLF0XnU6eFQz7sO+jVmFigwzdgeDVTV4Ix8fXBHMdTRzNmNrvnUnsD3LIbz65+hJuY12KEilRx7MY9hp22aSYa7LDl0SofJBNc2G9TFIwgprUtN6Ttxhdr8NVC9MzD2Lk7Wzm8revoV0CC22Nk7CmS8yBGaOMr1Icve+JbRKxI2/MjEsIM4WZljfc93ybDpI6E2xX27lST2IlRDUR41cw2zmrszYXDb9npFd6EfJcMzN7b+5jFsYV42dahCo8HaJWro+HzozMrT3FfkLbL9ha4y+02CWZla83T0RuMslUf+UpLO/nogep4vQ0swntu+9IRsXPWFKY4XKnd+/0/x/hkoanWNRQZ1hojnESgReWfbzlUEMoM9ckArm+ldxGKVLI4jT+gEGYYjDr2Z2WnQ5s9QU3MhG3VOKUrcCVNiJN+avfHPp5w20Z2ESdbU6OZbsLX4AUG823xvU1+Zl915zMjJsnFtCPvbZWpzgvn6WCDwtvp2CT42XD6fyEML8XrTUOo3AF0wltNqrcwr/3tImSOn+b8Xqt4q7GmvnugukGqhbK7ZREdyDffuQtKj+8vp2TtRlgKeHpHsJf0+H7HDoohy4q71kQeK6YZEQbEDL3/QtrZONQ8UNWZKSihVJ5lojOhiwsGc/jJ2G+xGNfP08brKRCV3RpY48j
 tBmANKEa
 qKK043xMBTWY4WeGfb386ZkReEBJv1wdnA4MmJH+1MlQ06PgqU8iWOOOhrc0+T3kEdY7aUaJRZTPc5rr1gx3A3pE7cDMoBjaxa6ju+AxvBdDbE8CP0sjECL5Oi2lRP1mGuokWuK6VBut8qT42MyWNSlZks3gx7xW4gaBpkEeRa1eOCm1dt3iCWybuNx+xmqOJGV4Q4IhphzL3+Hk5nzffwTdmkO5PNc6IUkO7GPUNjWsbDm+c2EsgonG728j2YZwmqCb1/dTItH/hDs80VD1k3nsSk2ZSgtZcF15x00uykoqv+q0K3BqsXw1HMRUDEGfJcJpWsOU+Xzgb1ODPjJcdatvoSQd6IxPMNJxsLUhJ3GUzi0+oyM+rRld/4UxE83l2D43keHsZYit0MnopCZTZMibNBopcTlM24gMrLVZilKJk82k2Kx/UOV2pLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--s7aflm6cuvuyxj2q
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>, linux-man@vger.kernel.org, 
	linux-mm@kvack.org, akpm@linux-foundation.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH man-pages v1 0/6] userfaultfd: document read-write
 protect mode
Message-ID: <ahWU62U2Hp2dPX3R@devuan>
References: <20260525122816.1956804-1-kirill@shutemov.name>
 <ahVoUsqYBY642VLS@kernel.org>
MIME-Version: 1.0
In-Reply-To: <ahVoUsqYBY642VLS@kernel.org>

Hi Mike,

On 2026-05-26T12:30:58+0300, Mike Rapoport wrote:
> On Mon, May 25, 2026 at 01:28:10PM +0100, Kiryl Shutsemau wrote:
> > This series documents userfaultfd read-write protection tracking
> > (UFFDIO_REGISTER_MODE_RWP), a working-set tracking mechanism for VM
> > guest memory landing in Linux 7.2.
> >=20
> > The matching kernel series ("userfaultfd: working set tracking for VM
> > guest memory") was sent against the mm tree:
> > https://lore.kernel.org/all/20260525113737.1942478-1-kas@kernel.org/
>=20
> The content of the docs looks fine to me.
>=20
> Leaving groff and organization to Alex :)
>=20
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!  :)


Have a lovely day!
Alex

>=20
> > =3D=3D New UAPI documented =3D=3D
> >=20
> >   UFFDIO_REGISTER_MODE_RWP    registration-mode bit (UFFDIO_REGISTER.2c=
onst)
> >   UFFD_FEATURE_RWP            capability bit          (UFFDIO_API.2cons=
t)
> >   UFFD_FEATURE_RWP_ASYNC      async resolution        (UFFDIO_API.2cons=
t)
> >   UFFDIO_RWPROTECT            install/remove RWP      (new page)
> >   UFFDIO_SET_MODE             runtime mode toggle     (new page)
> >   UFFD_PAGEFAULT_FLAG_RWP     new pagefault.flags bit (userfaultfd.2)
> >   PAGE_IS_ACCESSED            PAGEMAP_SCAN bit        (kernel docs only)
> >=20
> > =3D=3D Series layout =3D=3D
> >=20
> >   1. userfaultfd.2: overview, registration mode entry, new pagefault
> >      flag, VERSIONS line, and an "Userfaultfd read-write protect mode"
> >      section.
> >   2-3. New UFFDIO_RWPROTECT.2const and UFFDIO_SET_MODE.2const pages.
> >   4. UFFDIO_API.2const: UFFD_FEATURE_RWP, UFFD_FEATURE_RWP_ASYNC,
> >      and 1 << _UFFDIO_SET_MODE.
> >   5. UFFDIO_REGISTER.2const: UFFDIO_REGISTER_MODE_RWP and
> >      1 << _UFFDIO_RWPROTECT.
> >   6. ioctl_userfaultfd.2: reference the two new ioctls.
> >=20
> > Order: new pages first so the cross-references in patches 4-6 link
> > to pages that already exist.
> >=20
> > Kiryl Shutsemau (5):
> >   UFFDIO_RWPROTECT.2const: New page
> >   UFFDIO_SET_MODE.2const: New page
> >   UFFDIO_API.2const: Document UFFD_FEATURE_RWP{,_ASYNC} and 1 <<
> >     _UFFDIO_SET_MODE
> >   UFFDIO_REGISTER.2const: Document UFFDIO_REGISTER_MODE_RWP and 1 <<
> >     _UFFDIO_RWPROTECT
> >   ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT and UFFDIO_SET_MODE
> >=20
> > Kiryl Shutsemau (Meta) (1):
> >   userfaultfd.2: Add read-write protect mode
> >=20
> >  man/man2/ioctl_userfaultfd.2          |   4 +
> >  man/man2/userfaultfd.2                | 152 +++++++++++++++++++++++++-
> >  man/man2const/UFFDIO_API.2const       |  29 +++++
> >  man/man2const/UFFDIO_REGISTER.2const  |  21 ++++
> >  man/man2const/UFFDIO_RWPROTECT.2const | 117 ++++++++++++++++++++
> >  man/man2const/UFFDIO_SET_MODE.2const  |  95 ++++++++++++++++
> >  6 files changed, 414 insertions(+), 4 deletions(-)
> >  create mode 100644 man/man2const/UFFDIO_RWPROTECT.2const
> >  create mode 100644 man/man2const/UFFDIO_SET_MODE.2const
> >=20
> >=20
> > base-commit: 9a4bfd0e50745c2649b6291db40b58e37c9c1c6b
> > --=20
> > 2.54.0
> >=20
>=20
> --=20
> Sincerely yours,
> Mike.

--=20
<https://www.alejandro-colomar.es>

--s7aflm6cuvuyxj2q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmoVlP0ACgkQ64mZXMKQ
wqlIxQ/+Ik3Y8zXspj0OoDAJ16EC/DlAdAhwjb470LalLeCvqKodBi3kdXlVm8o1
bCnpCmjpwPIvPDzNWt7QgqAV98jtwicpGHkQwfcFxjk4ma4MBxq8U8flCb6OfUyL
y5FPgo2dYOwMiN2GlM3ftNzOPHun4v3KfOapinVytkd/fg5ExhqFzT/RVJC9Z7h5
8R/VY6ifDpn4mUs+tp67aXO4zyihU4kkA9RiII90k2j+K52ddl6HcllH8vkOQGF8
t3pPG+P45s/7BZPLprasQokts103CrMbLpHI+VcI7ALuGR/IsTg4KOBKY6EVovkw
mUeGQBBZm8msRWp3IRjNyPxjEKzAacIJYbFRnVi8MVFF3bMPNhFLzObY/whL4Ap9
iJfi+tfxb9VDiGygHr4rWmfbfJ04CIrv5TTbNscZISDGbZpb6xE7koayRzyaA0L7
LF4T7G2ciF/G7GVznpjbH+lTgWSuqCxnyhTeAjiTZSIJ/SMG+oAqQqFDUtji3cIR
aQ4Pk/UmN8SFk9yDUZH2xjds2o6HrKpPVNWvLQzQ8c6mBVMQgM81U+gVovzBVAA/
cP4psa8TZZdi99M4ChZ+aZ7abmmoziHY1Bz+wFeM0HPYxvnPQdADCCLfk0lVTkx5
G2pZadXCYt647qrM+g3/uCyIOV+gk+EfwhTzN+Vf9kNi8m4ONxs=
=DebK
-----END PGP SIGNATURE-----

--s7aflm6cuvuyxj2q--

