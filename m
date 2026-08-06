Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C86EC561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F21E6B009F; Thu,  6 Aug 2026 04:28:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755A66B00A0; Thu,  6 Aug 2026 04:28:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 669F76B00A1; Thu,  6 Aug 2026 04:28:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F83C6B009F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:28:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1D0D80669
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:27:59 +0000 (UTC)
X-FDA: 85070166678.25.5AA0C0B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2C5BCC0006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:27:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7Edia6K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786004878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p0PcD3Rm8nR2pfq6gkDt2k7upDjgqE9u99d+TfjcPa0=;
	b=8hX2904lVZwcjsOehwjD74JRLZheexMf6djXY3Nzc+reVueCGkoGGSTiAfPTfnfHtH/qiZ
	JOKAye8E9mKyv95rHEj68bLAmHTTYdPMee80HXveHs3IseOGjmCwzynHglfJzXN8qvSHlH
	KQKNn02J4z67W/d4bcLqVGldcWSEXXY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i7Edia6K;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of joel.granados@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=joel.granados@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786004878;
	b=uDPqni45BXgq6PCr9b7TzLuG2gJLhxNZDrZ/H89aZNiDrBC1mk2woQE3/heamUGUTXuB0g
	WjuGVxaz009zg+MkfJ//8pJOZfjwiK9OQBd4KO1Qrnmb8Sc1Ymr11nN1vTIxDKx03+GYM1
	uQcFv7huqdy2gC0hUWCpV6iEU3YP2uE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A2DBD60A9F;
	Thu,  6 Aug 2026 08:27:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71101F00A3A;
	Thu,  6 Aug 2026 08:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786004877;
	bh=p0PcD3Rm8nR2pfq6gkDt2k7upDjgqE9u99d+TfjcPa0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=i7Edia6KWeI4Lppi6fgOnz69TjiMo+cxba5PnduZ3z6q4lN8wcldDKJSpEHV9hhmC
	 ezGShGmDhCbEXpgvk6frqEcP+70zmxLnxm73O2vfIgeMUmYke6kBXbhzijxVH/DH8U
	 XYVWL+ZEnglPxs+7jxPiPnB6UE0KpbU6OheNUez+Tts0Gbta4xJb2RYq+9qgSyeRMy
	 FubVAwsxKxoeA9Rer7h52DmyI2IvjqXScmbtMG2MnGFK6TgkO3sz8UIkxYr6oXkJoz
	 BI5g1Kjn0bAi0ud+9C337akJI0px/NlsT6TbSLLZJoAmkj8uzFrC2XCJnZxD3T5CT/
	 4Bw/CK3DwEcJg==
Date: Thu, 6 Aug 2026 10:27:50 +0200
From: Joel Granados <joel.granados@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Jianlin Shi <shijianlin11@foxmail.com>, Kees Cook <kees@kernel.org>, linux-mm@kvack.org, 
	hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com, 
	ziy@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
Message-ID: <zz5kb26cwem7spqanv6mqe6fwonzclyi3t2wjk5hb5tmj4pdl2@kjkut65bziui>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
 <tencent_1BB7A5C4D5EEA67346634417753190E92A09@qq.com>
 <20260801114434.232c97a74d9616c43aac2456@linux-foundation.org>
 <f983f6ca-7d45-4316-94bb-8b4d0fd58079@kernel.org>
 <k53aljpl7v7naqs5fj4i4po6tu4grkzu5nui4h37orwt6v7bqo@sw4frf2ystmi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="rjnzri4ema22zf33"
Content-Disposition: inline
In-Reply-To: <k53aljpl7v7naqs5fj4i4po6tu4grkzu5nui4h37orwt6v7bqo@sw4frf2ystmi>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2C5BCC0006
X-Stat-Signature: 61hxs91xzhs5ccfp78sot1i9ppjredu8
X-Rspam-User: 
X-HE-Tag: 1786004878-140393
X-HE-Meta: U2FsdGVkX1+X3mq/RzMuB27SppnJDspcH9lGs1a75ia2hncrT4w0PJuRYvAt+zCwEIa+SYluc3ckiklKOTPB5VOGtudWw7vRC5+wTCn5TMmpCYCUCrlYQLB1XKyRb7qkeNJZR7kiigrDQIwLHz6rbPSnT7Cs3CuVS0P1iNaMjXl68NMroh4Z02chSSzu5VzDLRdet/Qe0KArZc0u1A89b05k5GaH+BNFxY20FOLSHewRfFR5tJ9REG8pZjY8K2TbECQONaJpceKuxQODvH7uFJZF9GQBgRAosoq2SDFN8Sq3IOBbbzYtBPX5a8gpMoh5lktWgpienaM7PeZMqoLXJEX1ufDQMsdrYwc9zzJIyO5LCQQxZ3AbLlb4aJcirdll9fFskIlihnNuDYhDtjPCT8XJiMxskuXfgaekFU9EocfjWoy60RzkR3ixvhAvUNZEnf0AFL3mBL7mthAkQFbmgBp/IyaMMhrpaaXWvqWIqCvfzBCsoISPHfXeXcUmIALKVCHDQgCXM7qmv/wNMwI9lbaF6/hEbvcvFM9PcIAFv7c5eTYt0Ga/pi7qDhZ/0xIzqGwyNu6fDVQJQzbT5wQvZymAHZvpZsAl3jW+99MYzhfFq4V1EIGvR0UiwooHMxmGst+vgwisBaJx9zdCfraqU0s+PSQiau/P2nvbuk745OpU+bnUwoNrms5/dArGpG+8jwr3K+nN0jNRz/Cud2Y9X52yzkitX1mIcVjUtaIwHw1jQqj2436GVWaWNXsHP9PsJyTrHpGouaEbpdifA2lWJx6OKl50zbnvTq9WP1RU98XheB2AJwppNlWq89U2mxuAnxTW/hsiDCyiAYoepx6Emt01EEJ0Jl0w2gmFNp3PtaglQCnafKUOaWjjLpqXe8fHiWe1f2B2l//yEENYGZb8Ig/RwcWgU4M1+4zVeSP2fr5WLq3wBbpVb4N2AQENiyLUDOz0OG71lac8PR3uwzj
 G4iihof1
 n/jcjeNYmJNX6ai2KjiJoTj1D8U1psOhN7o/vz7xVMbgUzUdQNxdecFr+Zk1cvR1CG5p6Gc4tVV+RaT7Hd1QULuGkbNK3Ju4T4fA3wc6luKgKXxM2aJngWxeu4ixzibG7//6KVv1MaTkacR60DU6dmEzHRN1N1MVRb0y4RvulnYvJA9DKvIj0FPxXZ5pbYsbL/KPYBcCA0Ru6HPpwjbbI4khVMuEALfWxV6Nec+N4OYxfCacZsozpwlH1/RBg8CfqCwet9fQCZ7KcHW7IDaVhA1klxHrdTI25/RKvoxXFgygD488vyrtfEPv/dkGgQxDWD47ZDCFLZ/IUfskFjwMXbJSbs/a9s78DdBfD1z3L+IZHpsit5klLFKLk6VyVMATxqWo7t77TtQAkKyeoBJSEYs0e7x/FaJpcR+W6O2Y/r/63Fj69qTleVpqPEene1NimLWoUNsR+xlmYYPRVy7UhdnMzkOKx4EAPHu7wJQaZuRk6NVGdd0asQHLheZaXBvIb4fwRONWK0J//KZB1A5Egc9UUb3H6W+Q55b76
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--rjnzri4ema22zf33
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 04, 2026 at 02:20:22PM +0200, Joel Granados wrote:
> On Mon, Aug 03, 2026 at 10:27:46AM +0200, Vlastimil Babka (SUSE) wrote:
> > +Cc: sysctl maintainers
> >=20
> > On 8/1/26 20:44, Andrew Morton wrote:
> > > On Sat,  1 Aug 2026 23:11:25 +0800 Jianlin Shi <shijianlin11@foxmail.=
com> wrote:
> > >=20
> > >> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
> > >> proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserv=
e(),
> > >> even for read operations.
> > >>=20
> > >> Fix two issues:
> > >>=20
> > >> 1. Propagate errors from proc_dointvec_minmax() instead of always
> > >>    returning success.  For example, writing non-integer garbage to t=
he
> > >>    sysctl now returns an error instead of silently succeeding with
> > >>    unchanged values.
> > >=20
> > > AI review suggest that this caused a new problem:
> > >=20
> > > 	https://sashiko.dev/#/patchset/tencent_1BB7A5C4D5EEA6734663441775319=
0E92A09@qq.com
> > >=20
> > > Not sure what to do here.  Perhaps pass proc_dointvec_minmax() a
> > > temporary then copy that into sysctl_lowmem_reserve_ratio if all
> > > proc_dointvec_minmax() returns "OK".
> >=20
> > Seeing the v4 [1] it seems easier to keep the current fixup code until
> > proc_dointvec_minmax() is fixed.
>=20
> 1. V3 -vs- V4:
>   I would prefer V4 as it actually prevents the partial write of the
>   vector in case of an error & returns that error back to user space.
>   Whereas V3 returns the error back to user space but keeps the partial
>   write.
>=20
> That patterns of using a temp ctltable entry is seldom used but not
> unheard of.
>=20
> >=20
> > > But really this is a flaw in proc_dointvec_minmax() isn't it?  It
> > > shouldn't update the table data until all the data has been validated.

Additionally, this will address the case where there is a partial write
to a vector where the input is erroneous. There is still a possibility
of having a "valid" partial write if you pass a set of valid values that
is less than the size of the vector.

> >=20
> > I agree. What do the maintainers think?
>=20
> I agree. The arrays being changed are not too big so we can easily have
> a staging variable that that gets written when all validations are done.
> The only "con" that I see for this solution is for when these
> proc_handlers get used with temp variables; in these cases we will be
> staging an already staging variable.
>=20
> I have added this to my Todos
>=20
> Best
>=20
> --=20
>=20
> Joel



--rjnzri4ema22zf33
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEErkcJVyXmMSXOyyeQupfNUreWQU8FAmp0RYAACgkQupfNUreW
QU+3xAv/Yx0a9im95SNkHMroF5dhMJPx3iGulMyTEt26QecBwhmOpFk7A/w8EIjr
jPE3ChuriSjNxzp4Fw3IYvZMLbqjrw+dbt3ILuP7UD35wA7VIh7rVql2kelQ2Rpy
BwP+1EyXMSK3xN5EwRdpdAL6oOSOVGiq96sYkO++neBp2zSvO0GTneCsd8KazRh4
i+h9+PuGZXEtzsjzkGYAbUAYPlzqrZPLctnnxKaOXx0Uc+t8+mRwoJN1SyGxwWSj
yTx7rmaU8X/dhooNeEl+eGZs3k5I+9xdjqZQThx47nTBq06dmqN7kTNkqJ78oFXH
y86RXSKjgaXYgEtm0vkQW7t5uwnAhB/vXnFPrtXhVGDyc9hr5l348ESzpk4F8mIg
q7cphPU+NGLnqIf4396cTUmbxz4xHcXtV9f6LUKVSGjn1t3QZmwDHn4IIMYdRdQk
wd2DEL560T5zJPmtpYm9X0nkg9s9YIptLeEBq1Dc0SAj2oJ4F8yeIGtS1SSB3OSc
9f8sH6Tb
=5S3C
-----END PGP SIGNATURE-----

--rjnzri4ema22zf33--

