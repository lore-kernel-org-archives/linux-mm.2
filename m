Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F10D1CD6E6B
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 12:14:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D0FD6B0005; Thu,  4 Jun 2026 08:14:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 281C66B0088; Thu,  4 Jun 2026 08:14:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1978D6B008A; Thu,  4 Jun 2026 08:14:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 056C56B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 08:14:21 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9D69FC2315
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:14:20 +0000 (UTC)
X-FDA: 84842122680.23.1E81DA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E13C2160002
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 12:14:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6t1W4lm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780575259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aBxa+lcyqcVhyWBKSzNc+JB9+27q4DQnFnUbO+WVQMw=;
	b=XnwxHcN5Ey679GoKWzMVaCR/abeKpBma64ud7SdJpeto+I0qz/oRU8C/6p3SzQWPqTnrIO
	0cHUPMLtLVnBdXYdcXzEb1kUvNT2dHusj8YALCjPTvo2iN05ST56YhCQWDI+PmnYZr6CtC
	RBHsLLPE2+h5SK2r7ALHzZ1AppLs3eA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d6t1W4lm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780575259;
	b=WlJy7sK2rhQMXwKkPyiQ60zE0NSZ2FPnkjKMeyjm4/rmkRd5n90qDarnFpZemYZ2vdSxXI
	KXdIhdPSf5XWduhwupf1lC2eZ76tGsHXNhTidNllj25O8y20Sjp3qKDADElEdcme1s9dN/
	27k7LK2gpTTvpnSlzr9MMIhM9L+q76A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7F1C40AAB;
	Thu,  4 Jun 2026 12:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127E61F00893;
	Thu,  4 Jun 2026 12:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780575257;
	bh=aBxa+lcyqcVhyWBKSzNc+JB9+27q4DQnFnUbO+WVQMw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=d6t1W4lmKkuUG0RM+L32skbHjR+cwOS3ldqkpLqzHbbLVtuSMgSNHM883chwwCIfy
	 ERT2P94AcuYsOW+6oA7tqkEZeDaerccYNjypA6Bkmi3AmYxoH2ZDuGFcU3L2OZFVm0
	 qlsXEKHbdc7QXIArwNaZXdWRMGXJzliHQUmA1HTTHPHbCPit3+HazBAMJMXqgrDTwh
	 WwI5ujK3CjCJ4RlgC8EInaeiFDfRKmWHdVpe6xR570dkWB9XjpjGhztpS8brD+17yY
	 RPGeSVcm2DtOYOrZGQI9BOUHyg9DClj9XDHpYMttZm6WYy0UkO03rHBgAUWQL0RVe4
	 /n5ghoNRE2nig==
Date: Thu, 4 Jun 2026 14:14:12 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT
 and UFFDIO_SET_MODE
Message-ID: <aiFrwjkQ5SVcUYrL@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-7-kirill@shutemov.name>
 <aiC9Be5oxT8u1Z6E@devuan>
 <aiFplwrPTalpnQqn@thinkstation>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="moqcyjfqpi6k6vnz"
Content-Disposition: inline
In-Reply-To: <aiFplwrPTalpnQqn@thinkstation>
X-Rspamd-Queue-Id: E13C2160002
X-Rspam-User: 
X-Stat-Signature: xmzpqzd8n9gn4qx7jonmicbdni63moue
X-Rspamd-Server: rspam09
X-HE-Tag: 1780575258-829512
X-HE-Meta: U2FsdGVkX1/X+mBTPWgVqn52ye0dHgDyuQ3PsV/lMl7Z9i8dOUoMZ4aGTMoK1KhzX847w29+u6anlh6+vN4ItyVmbt6ISL1P62pf5nxVqw/BEcAFXlPtwdUVgwai67Z5I+UtYlUz9CL4J7eh95hvaufokR2z6bjqI2CSO/mGnX7s9jilmkPCxhrMS4/VtWIVR2mAg98vRV30HGN9dlNML9P8JoKkzZQwyrzxRNXAYNW5sHvqashbtuamrjClPA2XgQfsv4J6ZYegxWNofSLWChrc6qIcC5ARrxGxjboQPYvMYXGV0hAZUhw9t7P6TwXN8P9JjplfbYi+IeqiSbH9bEuBWCuyx6hgogLBAPczzEOPK5YtWAeD6qfcYNmAY0knNbNcLPUyJrgCCl8AoyHc3FTupYy/W5dxkYjek6/hXEzNL7N/cKcM18gkE4NVSwNkLOqkrTmqAE2LQgqEr3joSM73GAScyvzSYtnZBhBbrLLvoA/dl3D3n3s6jop0dbw5kw8m4KmO8FhRhvkzCjOOow9myWbvb4f0puS2BMsbbT0E52ZwTSccvP5oQFUzbYNGa+z+jPmgvvaPvHspcd+koAaXsNEpO2S64V64I0KXsVtMeyBfZnz+SG9LJx/EcJupDgWgJT17omT9dsa8RyBbBM3Geazbe7m0Ok0WbENqPCQ+Ixh01zLvoUhtl31/95ab31t7q6Ev3ZFX+YmA+dpSCTjU8AFubhv0dU0dHmXik8uj5TxuDB+0F4XNfkTqCdM6V/MiZ0tXAc5Sd7oB6CxB7RgiB2XZdUIr65mYzwQKfm3lmGvX8FRtlM0Cd3d9xduZYViCqWQb3Xc+Xe1d/iZ6ZimAVCtV2niVK+7YSikWDZ8+QeSGkymPzQy+willTSjjKvVQanrPZyMdx2D7dxqe8uy2APHdXpSJpnd2IDLercvGyb7DmA7Nnef6PtIzclZVTgIhz3zQeX/I8yIkgnA
 jj4yzBw1
 1El6R2ZkHmCkVxfL7VyZFIdeSwZ0FHEVIp1pNellM4ytodvKX536QeGZkvc8I0r8zpkz0N9bTWySlb+rNriA42YXMVJb6vPWVJkVM1LVyYRjEHjNhsYlCh2ZQaLwSNchZ6L1ElJskhG/7Wb6mi8KLpABJyzQGNeq3+L2D3g7URsBl8NoVleJafZunWjaQySyU1QtRVCtJzTRpNkgDg/gzoocVVKcPezTvqEWaJYyNFSvAiTlTcQRp5vS6EPO9+PziFZEn3Vr5DD1xzOKLgKqQGJq5ArO666VNaMbycLmfS0JDfTnINnKlxJ8iQ2KwyyQLNHi8HMxypQvRRsiu9hG9R5n0hnXA0fbmcxG81CzKVdSUpOEAEKSydPauLTuo0r6HFNhxXCsnJWc0aGh7DNcGsVDQbM7p+dVQ58egxvLyXgKizNy758KC3/tAB2HHJ0oLrMV4rstUjKtwIc+JmhKNSoIWbLxQvk9yW0Af
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--moqcyjfqpi6k6vnz
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v2 6/6] ioctl_userfaultfd.2: Reference UFFDIO_RWPROTECT
 and UFFDIO_SET_MODE
Message-ID: <aiFrwjkQ5SVcUYrL@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-7-kirill@shutemov.name>
 <aiC9Be5oxT8u1Z6E@devuan>
 <aiFplwrPTalpnQqn@thinkstation>
MIME-Version: 1.0
In-Reply-To: <aiFplwrPTalpnQqn@thinkstation>

Hi Kiryl,

On 2026-06-04T13:08:49+0100, Kiryl Shutsemau wrote:
> On Thu, Jun 04, 2026 at 01:47:42AM +0200, Alejandro Colomar wrote:
> > Hi Kiryl,
> >=20
> > On 2026-05-26T14:41:49+0100, Kiryl Shutsemau wrote:
> > > Add the two new ioctls introduced in Linux 7.2 to the list of
> > > operations supported on a userfaultfd file descriptor.
> > >=20
> > > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> > > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >=20
> > Patch applied; thanks!  With this one, the full set is applied.
>=20
> Thank you!
>=20
> But it looks like I was too optimistic about Linux 7.2. Looks like it
> slips to 7.3.

No problem.

> I don't expect any API changes in between.

Ok.

> How do you want to approach it? Do you want me to resend it with
> s/7\.2/7.3/g once it actually hits upstream?
>=20

I've already pushed the patches.  You could send patches changing the
version numbers, once it actually hits upstream.


Have a lovely day!
Alex

--=20
<https://www.alejandro-colomar.es>

--moqcyjfqpi6k6vnz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmohbA0ACgkQ64mZXMKQ
wql5nhAArlR9HFaQpqk7onN2HAfasQ5Sc8x+ZMMX5gWOTiqotg1oA5e+xU8fQTfH
OG/uqINZCXEE9/wPc+aUs8iHNWg0/33Irx0R5OWAkZLoqnqtf0rTdpz1EdlXqcWK
4S9I7VmNr8mvtrxVZmsTsZmPMVWgVoehMaiJ8H1tQsa2F7/355068jatngB4hGf0
V++kI0RNz0m84aTrU9078a/iAFobHJtn/3VC4Po7tqqIciz1gq7/T1AT3yqm4a7D
ufvZTiS/frZ+aDfXkG4lqXh9rlMmtkXh4Un5vCcuxxeol8/vRitebgjkSrXDLs7N
h0dEOcvRvQAN+u2YcIT6BuyDTRysRUOggn/YVlFVmtXdNq2t+ngGDEcA2IScweOy
yXN+XUkOdGs9SMlnHqQzcygGm3mOvVL+dOIUryD7+BNKzFsH3zdEo5TftfV9tcQN
7eKIm/AFp7db8X7c7z+Vrx9Gao1SRonpFRw0O3EMXbmpDxal19WUKonZ5qe/GdlK
58OOd8gPXd8U1FzFBF6shexLA8J0lLMrfznOJ45QIO1564O3SOPAdieLrEGAgQiK
ujxpNljM/4GdFfb8P65jOz7T1ahK1YQWLFxRGG41HZJe5thvm19tqMuw+2g30lYr
uf2T0liZj/ugXk0XFPJQ89Gjes8iT2vuf8CwOKySPejqfdK5e9o=
=+1I3
-----END PGP SIGNATURE-----

--moqcyjfqpi6k6vnz--

