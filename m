Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA67CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410256B0005; Mon, 25 May 2026 10:00:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E6CD6B0088; Mon, 25 May 2026 10:00:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3236F6B008A; Mon, 25 May 2026 10:00:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 230F96B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:00:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BF15EC021D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:00:40 +0000 (UTC)
X-FDA: 84806102640.10.739030D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9AE9618000A
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:00:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cOYnsB2N;
	spf=pass (imf16.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779717638; a=rsa-sha256;
	cv=none;
	b=Spl6peG2lnIDSO/cUw0oeoSgDWu0Ur8l71uF4b2bnFrlsBV6oXDgu4uBkY0sbGjBdJoz1e
	Kl5TsLmxI6KecZrzZwAo2fEBUh7uFx92oMGmYaQ4oxgQvBny3tHjqS8RJ7jfnDssITwlqy
	9g5Ep8tOmRGH9USI7G+PTV1tPo8B+NI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cOYnsB2N;
	spf=pass (imf16.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779717638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y4tNzb+fLW4HUOsn5CL/+iaMht1iOF7Ts+XiT9xffng=;
	b=7DA0gl6+dueHsT63/AW7IzL1mHnZpkqIbCmdNdwEOUArcXHQmSKkSoAkIe/RmU4ZN3Lf6I
	ppCQXyx2wxaxDcwLpbd5X/CKbyLT9yKGLgUwnwhYIdSV6AjYcEN48n0A45BEXrqBgEVX7y
	UkMCOFwKG5IReh/IlbHDyfSH/eT05do=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 96E0141A85;
	Mon, 25 May 2026 14:00:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE811F000E9;
	Mon, 25 May 2026 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779717637;
	bh=Y4tNzb+fLW4HUOsn5CL/+iaMht1iOF7Ts+XiT9xffng=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=cOYnsB2NyJ2P4m+KDK7ynVc7doyIu+ppMdqgyBley+f5qW2Ax1KjA0bGqb65fUPsn
	 np04KtjiGjGbU71IqOWhrd12NJQhfHQ8dT5+St/1h3VQIC5cFBgv88YJMP+dqkuneo
	 lRSqEtN4Gq0Msh6yDefe6lLAu1o33tHI32vjsOnYVbPBQnGY2jIPlMjozdaiaACTMw
	 3HBoIIGDky0GtZ08Qbl1X8Vj7PjZ3JoV92PEKsBMtsVgWeAc7xqCq1+Ao/C2YzrSAx
	 jJR0MVZQ4YIKy8Sjfg3/KWo0WVEkYH2FQxwZTfH+Z1mjqLXp3LoD1Sgxp3l7qw+tF6
	 dh2k+4BgA2JDw==
Date: Mon, 25 May 2026 16:00:33 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH man-pages v1 4/6] UFFDIO_API.2const: Document
 UFFD_FEATURE_RWP{,_ASYNC} and 1 << _UFFDIO_SET_MODE
Message-ID: <ahRV5sZCUXVQ_fBs@devuan>
References: <20260525122816.1956804-1-kirill@shutemov.name>
 <20260525122816.1956804-5-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gxmzouvuofrgzmdc"
Content-Disposition: inline
In-Reply-To: <20260525122816.1956804-5-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AE9618000A
X-Rspamd-Server: rspam03
X-Stat-Signature: wj9bx4czthu6kgb3g5kfg69ibbr314cp
X-HE-Tag: 1779717638-46463
X-HE-Meta: U2FsdGVkX1/R7txnkJbyRa5Ps6T04HEQKCnVWfrqUhFMuBJW7rHBnT5NlHIw0Z9w9cT+DBJQ7DSQ2muBxSeUSdQRUfiQ4L07aBCF+tR7+jZguDd1BgxYnwlwiULfUXcuMZzGOiNVg3ml2upjYQBmuTjizPBMweG9BHAY7ZhXi2HbaNl3pcUrgxtAzY/oUSPWWhXAMmhjaYvh/XnGZSsVAPguuqlqafX0ciFwzQcmkhe6sPzdpp4ETKW/CKLuGbqhOK5YWkfZQ5eIWFOtg+VI4YMBQ7dcW94E15EWSbnOKMvKonJ7Ch65KPdlE28D/vwN9zX/k8vqemN0F6qbSwtCC8715DiPeD6webkO3icAEeBxIbRyM90c9hHmWtVVUdcx/DY+DsczD3OYtC/V+Yhc/mlGDZV8nz/qjrOkUCDVh0SqGVa6FvRd6YE/o0589PivxQpZFs7rOeG5HZVMPfLha+JrrnLLI6C34F236gEcHF+jNaCWSuZxZz4vxcZMkD8AGYvUqwh+HrysaKIk2w2zKpiTnisScDm7inuWlQwgkB0WCLnlS5u3Sjt8qdb+fXkJrpDSv3dtbcJOLuJ5n2AQfIpvl+KyuFkbqpJzWdnvU0Yt8pdMeakLX1xc+GPBoARoaRmOs1hVexztmyt+PdfPxoawtSxxtqSwAYqZoEo2Z/mBpx8yZMyzUnkah8vNVmteXvSB+7nCZQUZWc1l+6JnEjBNDkk30LNVRL1XMBiY2mArqPi8eT/o1uQoy6TbF0nuqjM0fWdQSot2WnIJnfhZRgIPYyfjIjyWFhHV6TacwEkFQ8EzchS2nkVL+a0ftUk+MXsEbDLHscoc/IskPPFXTexQqCp7oAVlb6DyAi1ZDbbeTU6izeK+q+/ssUII4MnQalcpNboxQW0Scq9ua1wLiemMIvVNo3aqCUeGk+UvJZbVo7TvkMtV1Gh7tZLGESNp0TvxMyzbdOME+3Q6+D/
 Kh4HnkaN
 dSZp36SRR5OeDdFehj29lQdgPpESOdT3Uc4uYrYop7OCxzB7+/2qhAWf7pzZ8f//m/CRNrQiAVPqbQ7qb0cwSQfvAOb8DhFr9GJo0ONRhgNsXEure+P/QtwKmAp3B0FJwijNTAj3GnWrLpYvnefFR3ueeS4foqHZoSliu/Z+zpC+hEUaJjHTpkMJDp8Jrast8EHBwtZF0hZLkZ56e0ddg4+Sg0ckYPx79y9Vxn4p0NtasM0Z3PwsasZaUX856YtE2D/h7Ns6EwBsaszCWmYe2iAOpVMzVkYXMzOHrEvLEdlkVusy+IPewcFc+vu5oqnwta4kLsRM3AlUqUV/tpuLTH2IFD/Fr8A9izjGIP0mpUl41yZDlJHdRAH6CbxNFgzN3Rk8nnUhZS5qD/itYErpoqWR1i0Tcz8ahavmohz5iJU7OLCp/1JrSDkgy5Mo3ygG6slqyF98tkz3ZeOeB4B73q4VyxLFOsr6+IZb9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--gxmzouvuofrgzmdc
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH man-pages v1 4/6] UFFDIO_API.2const: Document
 UFFD_FEATURE_RWP{,_ASYNC} and 1 << _UFFDIO_SET_MODE
Message-ID: <ahRV5sZCUXVQ_fBs@devuan>
References: <20260525122816.1956804-1-kirill@shutemov.name>
 <20260525122816.1956804-5-kirill@shutemov.name>
MIME-Version: 1.0
In-Reply-To: <20260525122816.1956804-5-kirill@shutemov.name>

Hi Kiryl,

On 2026-05-25T13:28:14+0100, Kiryl Shutsemau wrote:
> Add the two RWP feature bits introduced in Linux 7.2:
>=20
>   UFFD_FEATURE_RWP        gates UFFDIO_REGISTER_MODE_RWP and the
>                           UFFDIO_RWPROTECT(2const) ioctl.
>   UFFD_FEATURE_RWP_ASYNC  in-kernel resolution of RWP faults without
>                           delivering a notification; requires
>                           UFFD_FEATURE_RWP to be set in the same
>                           UFFDIO_API call.
>=20
> Also document 1 << _UFFDIO_SET_MODE in argp->ioctls, the
> file-descriptor-level bit that advertises UFFDIO_SET_MODE(2const) for
> toggling UFFD_FEATURE_RWP_ASYNC at runtime; it is independent of any
> registered range.

Would you mind separating these into 3 patches?  Thanks!

>=20
> The existing page intro already describes UFFDIO_API returning EINVAL
> on unsupported feature bits and the temporary-uffd probe pattern, so
> the new TP entries do not re-state that.
>=20
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>


Have a lovely day!
Alex

> ---
>  man/man2const/UFFDIO_API.2const | 29 +++++++++++++++++++++++++++++
>  1 file changed, 29 insertions(+)
>=20
> diff --git a/man/man2const/UFFDIO_API.2const b/man/man2const/UFFDIO_API.2=
const
> index e894114bb8e2..d2819f009f97 100644
> --- a/man/man2const/UFFDIO_API.2const
> +++ b/man/man2const/UFFDIO_API.2const
> @@ -213,6 +213,28 @@ If this feature bit is set,
>  the kernel supports resolving faults with the
>  .B UFFDIO_MOVE
>  ioctl.
> +.TP
> +.BR UFFD_FEATURE_RWP " (since Linux 7.2)"
> +If this feature bit is set,
> +the kernel supports read-write protection tracking, and the
> +.B UFFDIO_REGISTER_MODE_RWP
> +registration mode and the
> +.B UFFDIO_RWPROTECT
> +ioctl become available.
> +.TP
> +.BR UFFD_FEATURE_RWP_ASYNC " (since Linux 7.2)"
> +If this feature bit is set,
> +the kernel will resolve read-write protect faults in place without
> +delivering a notification, automatically restoring page permissions and
> +letting the faulted thread continue.
> +This bit requires
> +.B UFFD_FEATURE_RWP
> +to be set in the same
> +.B UFFDIO_API
> +call.
> +The async mode can also be toggled at runtime using the
> +.BR UFFDIO_SET_MODE (2const)
> +ioctl.
>  .P
>  The returned
>  .I argp->ioctls
> @@ -234,6 +256,13 @@ operation is supported.
>  The
>  .B UFFDIO_UNREGISTER
>  operation is supported.
> +.TP
> +.BR "1 << _UFFDIO_SET_MODE" " (since Linux 7.2)"
> +The
> +.B UFFDIO_SET_MODE
> +operation is supported.
> +This is a file-descriptor-level ioctl and is reported once per
> +userfaultfd, independent of any registered range.
>  .SH RETURN VALUE
>  On success,
>  0 is returned.
> --=20
> 2.54.0
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--gxmzouvuofrgzmdc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmoUVgEACgkQ64mZXMKQ
wqk1Jg/9Fz8ASGTokbYOX1XSVWGS1dHbPMc3pwu3Xy8EFHoB6LL2jvWzy6Uoo/0M
e2L3AXQ2jzfHmaS4kUR6R3X3QUl49IL0pvWXDjeJu3orddNbHjN/bjEyeCdBlsTc
McIj+OufpXN+pLiRzDr0KPVvt6VqIM0ThXMA5LcJuvnhAnkuLFl91w7h9L3JjPi2
4vT2qvdXY0jw7HVfyuovxMGIC8FdQyTfbehKnDEA5woXTu7UfvtWY5xtjUB7+DxC
iQ20JDm7tvAX5r5Xa7URrsph4+GC1mIeHWr1nkyjokKLeb5qnQT5h6tsxl4DiDvD
nsFqITLT3dtYyLBKN2OcvSe5OC0yzAEYaGBNd3hjTlrHHbVSqIsO7qotrokyoziG
AgIEkLZnDSg/plpc1AQS/f/wzm643t87BewAdUsEKldz7FKj/JVwP6S6l1/W4/at
8OO+yFAOub1NbV2fcZSrFr9K4I/MdXmPvXNhSO1Al9Uamq3H/SlKZ92N8Ahn/sdu
BEVvAsQspTsW288M+h87mYEgTxMCAmz6nwGjLg/n/Tsp8Vg21rDhSOkrBYFrO9TE
jDweNLIQ8YGon7eHjZVnoc3R7PGnsiPC8qFF/WyWfXvXRuNs0VcKx8JbfpWfyNmp
4V0VMle3s8rap+juLrN3I6mvbA2UXd3+KD0lkgjTQuwKc0rKQFU=
=zhYn
-----END PGP SIGNATURE-----

--gxmzouvuofrgzmdc--

