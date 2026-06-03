Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE46CCD6E60
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 23:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28C696B0005; Wed,  3 Jun 2026 19:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23D046B0088; Wed,  3 Jun 2026 19:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1538F6B008A; Wed,  3 Jun 2026 19:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04A1F6B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 19:47:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F6268BB53
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:47:01 +0000 (UTC)
X-FDA: 84840239442.08.FAF26D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id A2BC120005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 23:46:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klwlLm9w;
	spf=pass (imf13.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780530419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=biHQYnyEZQhg3FpbjGhfUfb/+g/6NBV2WaYfLNDVvmc=;
	b=leSjr+sweSfotaLmi+v435On+sGsYiyG1CIys+/Oq6NyfimaDNt5V9y2dRWk/OILiSi/eX
	2NfEQUgLqPsnZKDoQ4IBUZ6e1JQDyDSsHW9kbul0xiJIp4qyE49RXmaaZ62T3bDVleD56I
	obRxpSczFD7SOGyDYe1zBCbxbrQYZu8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=klwlLm9w;
	spf=pass (imf13.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780530419;
	b=3SrMYa1WziyxIXsHUA2ixGw3L9RerBcmDWLSriJSk0Jwy4t4qnBvR18z36iQ32lxYmP1IJ
	AGnkQ4aq0/RU9Cc1xpQXvyajao0TEjooD/oo9JA/ejuroH/cqmhrTlB5QN1pvLAgYGeq8t
	EmRojXVHNHDGmgzt0EOnSzb7C/8GEAY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AB2B64183B;
	Wed,  3 Jun 2026 23:46:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B41401F00893;
	Wed,  3 Jun 2026 23:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780530418;
	bh=biHQYnyEZQhg3FpbjGhfUfb/+g/6NBV2WaYfLNDVvmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=klwlLm9w3//AifVdsbijoCscgD3b/PaVlc7DHmeF7EuG0gaeCQueroP1kMZ9/UMHk
	 sM54CLfalDMEtxBqNxDO465y4n/SE2rzgHn2WccllZ7PauOZwCP7sLSF5LNtgRWWQ7
	 7FB46D7S5Ren+vDHNmeziIN/Cy5dW8TQJMAR6HICtkWAGTqOhbUpfKz+ciJfmbEGch
	 wIV74UCs7JeUwus8QC1it88+AYDQjqwzspKUl809EO03KCPHJSySWKG4o09WIIBEJw
	 GRcX4KzrceJTNGwr5M9XAHYc1QNMLBWirrMjG0rdR2ek4x7rNqfM1SaCVa8uvcROu2
	 xp+UbepQ800Iw==
Date: Thu, 4 Jun 2026 01:46:54 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 5/6] UFFDIO_REGISTER.2const: Document
 UFFDIO_REGISTER_MODE_RWP and 1 << _UFFDIO_RWPROTECT
Message-ID: <aiC84ZUEr3MwWuq5@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-6-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="g6v4rcrposptnopv"
Content-Disposition: inline
In-Reply-To: <20260526134149.2831720-6-kirill@shutemov.name>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A2BC120005
X-Stat-Signature: d3w8j88o48pmk9aaqxnbao6o9riadjsf
X-Rspam-User: 
X-HE-Tag: 1780530419-97054
X-HE-Meta: U2FsdGVkX18w2SblsIpDK+e4hj+s5gnvOlg7iqMAQ/yzPohVWxEBGcxX5C7oa8Vbcok/PmQVrw216+gNDQbgffc7DAyaP1M/QBPfqsbRWusb5yT+skgxDqvEPvaVaXSqgWC8VVCYFtA2mr2EhSVRAR7GgS6BH+2pNwGX/OLUS2aCpU/mJ34FCp8OmwiXRc2vmh1jUZAKwYbplM4s8qHObFrFNmeD/z7z7fCTTRVrAQuGzarIDFgn55Jz7mZI9FkEVEr56nfAe/dBB8+RiA3uI4yebViqI9nMNF3GFCApMrI2Uv5NetST2x0fcSu3ojMsiWxpwY1ZUSfCGeaVrracAGbZMqW64qLs34uvMrLfHroEddY8oUMjz0jC6bPFXCbe6/5nGJ2QsnhHglZ+x41KSFBJGuDUkVp40ueEGXHXaJY47iy8qZmDDclJj/TNPckdt9bRmJBoHyn+4BRyJ7eKgsXB6COsvmKWNBcn150mTCubOzA639USSa8xPOpbUjBzdonm2EZr886L1L7yiLSwvCA2eVa8TE1v35f7XeVQFK7YtUCrYZJ4oFtF0DURw++HqAVqn8Oi9nHEU1EBhMnrJ7vmj7tnF1GdgCDJ2Y9G8W4y+1/mOtWthAwvnFe9TDJiNShyAXtxGbf5ho4Ai67zSYzTGfKMlo/aWCV4xJp3+1VDYVNA3TKT+lh948bg74xgO+XfTUKFL5FoLo8M6MFX1ukx1k++Q1nuqVZcOLl103D9e0Sre+z7fqb/Qx/mHK0cuAJNLC2UUPib40v2JsRrK9lH2kaAlcvLjXSc42hjmbzwO0okvUyTo0qGOztCvEzhZjW+sS8alrCRZ+pNz1k6UOgEyVGe5oiSbIgLXY6jM64q25uOuEYRO8WT0V0xB1rzliU/5iAgx9f/i82D223zFbyri3H/z4yi1MmvfYCz+Dsq0XiMj0R9TR1p+7+hmH3Vc+VE05JZaoZuW1tqS53
 oBxQBfmV
 CTivhqxP7q6HIFhW7EMFGijb7qayjygoRi4Nuf2ilcYHmeJU4bkUMPdlr0qRiQIBEvhILGNC++8Lv8HzpU/PFtk5feU7m2Y3nLv+mLgLo2OsuzE6YVq6HOLZ591PHfz3m3MbuPzqy8+4ccwhyYlUOta4GlulIO4w5zvDI82ELD51PdsDf1kuSQNdT1MU+Us/ldhHRvPgWIgIg/WZUQItWjhI3uUgYZKoEDl7OIL4SCcl3NDng4nMj/+5H2+v3WZzFtHWl5A3wMX6v/Q0ycyPEfSs2jVPH5BvQCRIq8T7SIuTe/ms5pl4YDwC+W7HX9a/kmD4RXdZDCMhGvOifP0iU60i3GYrc4LxqvM6D0q5MnK27wV9XUiQSw1sTtJnJpRe50UKorGi6VlIwykr6J9iCpazHOh43jRNRF0DuDq5e8yjboKZhe5y1XIMy1i4VoU41Qs/4t0mzIpMWxOJKu+tjDxYfZ4awMZ7xgRe7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--g6v4rcrposptnopv
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 5/6] UFFDIO_REGISTER.2const: Document
 UFFDIO_REGISTER_MODE_RWP and 1 << _UFFDIO_RWPROTECT
Message-ID: <aiC84ZUEr3MwWuq5@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-6-kirill@shutemov.name>
MIME-Version: 1.0
In-Reply-To: <20260526134149.2831720-6-kirill@shutemov.name>

On 2026-05-26T14:41:48+0100, Kiryl Shutsemau wrote:
> Add the new registration mode bit introduced in Linux 7.2:
>=20
>   UFFDIO_REGISTER_MODE_RWP   Track every access (read or write) to a
>                              present page in the registered range.
>                              Cannot be combined with
>                              UFFDIO_REGISTER_MODE_WP; both modes share
>                              the same per-PTE marker bit. Anonymous,
>                              shmem, and hugetlbfs ranges are
>                              compatible.
>=20
> Also document the matching argp->ioctls bit, 1 << _UFFDIO_RWPROTECT,
> which the kernel reports only when the range was registered with
> UFFDIO_REGISTER_MODE_RWP (which itself requires UFFD_FEATURE_RWP to
> have been negotiated).
>=20
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Patch applied; thanks!


Cheers,
Alex

> ---
>  man/man2const/UFFDIO_REGISTER.2const | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
>=20
> diff --git a/man/man2const/UFFDIO_REGISTER.2const b/man/man2const/UFFDIO_=
REGISTER.2const
> index 50064c954b81..ded57cf301ad 100644
> --- a/man/man2const/UFFDIO_REGISTER.2const
> +++ b/man/man2const/UFFDIO_REGISTER.2const
> @@ -72,6 +72,20 @@ .SH DESCRIPTION
>  only hugetlbfs ranges are compatible.
>  Since Linux 5.14,
>  compatibility with shmem ranges was added.
> +.TP
> +.BR UFFDIO_REGISTER_MODE_RWP " (since Linux 7.2)"
> +Track page faults on read-write-protected pages.
> +Every access
> +(read or write)
> +to a page present within the registered range
> +generates a notification
> +once the range has been protected with
> +.BR UFFDIO_RWPROTECT (2const).
> +This mode cannot be combined with
> +.BR UFFDIO_REGISTER_MODE_WP ;
> +attempting to do so fails with
> +.BR EINVAL .
> +Anonymous, shmem, and hugetlbfs ranges are compatible.
>  .P
>  If the operation is successful, the kernel modifies the
>  .I argp->ioctls
> @@ -109,6 +123,16 @@ .SH DESCRIPTION
>  The
>  .B UFFDIO_POISON
>  operation is supported.
> +.TP
> +.BR "1 << _UFFDIO_RWPROTECT" " (since Linux 7.2)"
> +The
> +.B UFFDIO_RWPROTECT
> +operation is supported.
> +This bit is reported only when the range was registered with
> +.B UFFDIO_REGISTER_MODE_RWP
> +(which itself requires
> +.B UFFD_FEATURE_RWP
> +to have been negotiated).
>  .SH RETURN VALUE
>  On success,
>  0 is returned.
> --=20
> 2.54.0
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--g6v4rcrposptnopv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmogvO4ACgkQ64mZXMKQ
wqmFCg//e90MJJIMOM7KqCbh3P7UvHFm4V9NLbTad4/wsqI1efMunVb9efKO87sZ
L7ZWaGrBPYy59a6AMKI9BfsIqVbS0ZHD8Udu1JGWcjn3UJFJ7StqHU/wlQyYZGvk
GMrKPG+4FH7rfTnYXy5Yts3q6HKLPeNLjpGGx3KaYog5EIswT165RUjsMceFRVVw
zKqb5+/nd351RRFk+OJfD8SxSUvywY1m2sJ61pPqo6P++gy9gvBgVZx0gnNZdJn9
bc4lhZhbtr0Do/cTaw3b0A2ugN58H1vC77rKXs/HbY0F7BAG+xkB6SDb2fqkbfHw
SaQS6Q94powYXb6pDEcl64VkoSOkFx8OOQDKCYfB49KMChKA8lYX9ujwnvG+PVSU
ChYAngrzcFGTRWe0Ntwk3XzouPzRvK63lJXwNH1GLSwxdHBBycIYaaLoIeAxeepc
Wq/rB041UIsz7+LHSlS3ctwgdEUVqhX9JI1brhSaWGflYMGPj2oqA/skW7B4msoR
bETTURfVzL8yl2Go1w8HFWnFQIeiOzwKRlH2X82WfjSrZ/n3HDO7CQGUTK7SSNU+
2v+6BMPrhYAfJz/w10D+0+AG0m6sEWOfx67/5guF5NJ2rHCHDbbxCandv9SxgkcT
JTdTDmkCT9yRQpt1c15rVYp23DmXDQ6wkT1hk8bederokhHsaRY=
=VZwq
-----END PGP SIGNATURE-----

--g6v4rcrposptnopv--

