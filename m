Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47CC6CD5BD1
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 11:35:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 726246B0005; Thu, 28 May 2026 07:35:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D7376B0088; Thu, 28 May 2026 07:35:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EC876B008A; Thu, 28 May 2026 07:35:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4D7756B0005
	for <linux-mm@kvack.org>; Thu, 28 May 2026 07:35:14 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E5BD9161ED6
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:35:13 +0000 (UTC)
X-FDA: 84816622506.17.0EF41CC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5FD4940016
	for <linux-mm@kvack.org>; Thu, 28 May 2026 11:35:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgiImtAX;
	spf=pass (imf01.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779968112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ruFpPhXsGQIJ/UMg9Z/s1s8Xp6FcTk0KT+S0MJ952Es=;
	b=Z29SUYBmOhB+N3LdBDK0Ti96+eN35Qj9ipLIwt0PZLJVJ1KExoCqf/SzzfzD6L3XzstrF/
	sab8qfEl620Hd5XwdCrtf5C0QOgHbQVDp2Qu5hJyF7a+WUQkyAyu6VbD+4KW4DsaHgmFbe
	UorgD69ILF/lvaLmQjJoiLM5fOJs4D4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CgiImtAX;
	spf=pass (imf01.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779968112; a=rsa-sha256;
	cv=none;
	b=n4gLdMR5/84Dlz/LUFYLy/Wc7FyrYev344gjkG8VZKlAUqngEtpjO6q7rxRwZbp1MPfpkg
	0aoGDn8ZD/I+SbZqkodS9SxwUQVbtQHSc3V9Y0eNzcrF9tvcNkj6dGGTMjPgxYyYMZ7F0x
	An8kyHwLytt10hmmRzES2iiQTGGShzE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E906660123;
	Thu, 28 May 2026 11:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7E0A1F000E9;
	Thu, 28 May 2026 11:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779968111;
	bh=ruFpPhXsGQIJ/UMg9Z/s1s8Xp6FcTk0KT+S0MJ952Es=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CgiImtAXkdhz2HvATBTeMMypfjO7poAFeP3qCLX7fxpYqV9+F98ee2HkX+i0EEFO/
	 pr7CiVUim3+xa3htEU4eM/SIPYC6w+8S1aHxcdUhFFcgkV0Vp1q/xPQPIyrSd66qVY
	 Ygv6a+RKB/uYxT5nr51RLoqlBvtkGPOhAkW85yGZUca5YWY6msvhbxv3Kb26IiuB7J
	 pIwKycCK4TKx7nMEMIhRXvvp4dTUVKx0VZ36vQMNm2kxJVKg+gnnPAW8sqVW1JFP7o
	 7hm3iefDTsQoHEgolsXy6g6dQrCN3PLsxSdGFOJoeiygjjCTaAhYs27l07IrbLDxsb
	 VUaWpBXl2ajZA==
Date: Thu, 28 May 2026 13:35:06 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 2/6] UFFDIO_RWPROTECT.2const: New page
Message-ID: <ahgoSq87Hbk5e0J8@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-3-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="azoyzbjhbeoj3i73"
Content-Disposition: inline
In-Reply-To: <20260526134149.2831720-3-kirill@shutemov.name>
X-Rspamd-Server: rspam12
X-Stat-Signature: fzcjns56xw1xc635oh15abin3bo8ik63
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FD4940016
X-HE-Tag: 1779968112-192805
X-HE-Meta: U2FsdGVkX1/J7Kq/RCUNMPSChh/pWqP8EgC8z5zJAPjaMPtCwvyV/zGmPW4uFZHuTw7/3MI5uKBC8+jcUwYurs8O4RwuEUj/4vrQwCxLU87c1nmLP340rFWZFekR6tWNqluhU4xRXoQi871yEFCjurT/VhSlP+qBh1eeelsQY6/xMvlUp6Gqbtql+OyHyG4gZuhlLKA9WJHPKVltPrPfqhnWehN5e4NyvWFsvtbZcSXYJ1ltB6TzubFzUyE+sSaRPXR+TmqrY84dQQVVHT5mI3mp3fyEg5gpEZFkMhyTQRHYVS+IlPhPR7NaQe8+REKHWBYtUR3HVcEQTajEANJNlUt6hIzMJbxjAkjcEqmpvuOY7CGCmXgKsGBSJok68qbqoUufDrMmLZ7bduBt7eSCPTgqvfh6Jq5EFtFqUy79xO6b6KqDlouu4LDAneQXcHiqi2ssobSbfg4fM+q2+7jJF3M5p9HZ1U8GR1c4Klo+v3lCC1S4tK7eFBw01wSZXjIhTrwOvQo9m+6bSGGnpi/Xc/Velva8nN7Ul4YLPwJLGh1NSIs0EBVBVUthYT1VfWsFxBPZs2i4FVY1KeIgo+srdM0uQGmqaBUv3sSBlktd4JXERljAAUUf6UwfWZJ8/fv32jk8DA+uQoyqGC5mk1Gu6fFEuwiOsfHTiXKxtuNttMBjYPr6vonkNFI/hRYvF0IRHFR2dU7Qh9HlViimCMi96/SSyLdD5Sy5uAxR/u26/zQIEFzXLpAbrOzGkoNRpTpvBY9oWzbr9cAk9iySwCBQH4UWRS3l7P0OxnFUf7696wIgygPnVU0t89zuRCiAanHUqbhrsBFouI8XCkulWdxUxS/UzPdO76EugFAC1vUME+eJNdUdELLBDmQBURRX6CbkoFcrVcmFLZX1uf+f5bh4VIkwCxIES1ay2UkcFv5WAiyQXjXNzoIOQNd0robDUR9ZWmpoWTrD5RPUbEyCLN2
 NLUsfyrO
 6dS/AP49WWPkD+bE8Ym+1jv6KdJqHtD4XqYBsv4w5elM49QulfUnMHtpb9ulaNks/6RjPZKSAuYLar18jMsOPTHD6mNiw5YE+AKzlkt9k1dRBHv53M/0kp6RQSJkP41cjzHkrdN0tP0EdKhztigjNWwIZw1mqp/pgHDL0fPbjqNEbu0hkkXLRhpm2DB6hN1NKANqPdc2uVPTl7LZFUW5B70GodqhFWihO2bKfz2NEOwVlaO/SECQb5ZldsXdFxs2ugNiAmsMR3ms7fPQrkBDOIO93I6WY+C8edi2LfNjw1Qglxt38vljxNhmML+kpitAGV3sCsIheF0kNTczTvpvVMqQ8uyvXU3M1QEVSU09Kdbem//ofmm8jRcXmM+TV/9Pz6s+VVcSQltMGyQFC/ziWrTQSfmC3+lLPMHOGjmVWrk5UbwhQ8wQw0KhwXcW8X6upUNV1V0OJDs2JusCRmaiRyF/HwIAf8sV9jTwGA1o6RSXjzlYukRueZJZfChvUOQjWquStRbitWMooyhI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--azoyzbjhbeoj3i73
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH v2 2/6] UFFDIO_RWPROTECT.2const: New page
Message-ID: <ahgoSq87Hbk5e0J8@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-3-kirill@shutemov.name>
MIME-Version: 1.0
In-Reply-To: <20260526134149.2831720-3-kirill@shutemov.name>

Hi Kiryl,

On 2026-05-26T14:41:45+0100, Kiryl Shutsemau wrote:
> Document the UFFDIO_RWPROTECT ioctl (since Linux 7.2). It installs or
> removes read-write protection on a range that was registered with
> UFFDIO_REGISTER_MODE_RWP, and is also how a handler resolves an
> UFFD_PAGEFAULT_FLAG_RWP notification.
>=20
> Cover the two mode bits (UFFDIO_RWPROTECT_MODE_RWP and
> UFFDIO_RWPROTECT_MODE_DONTWAKE, mutually exclusive), the populated-
> pages-only semantics, the anon vs file-backed reclaim behaviour, the
> explicit-drop list (MADV_DONTNEED, hole-punch, truncation), and the
> EINVAL/EAGAIN/ENOENT/EFAULT errors returned by the kernel.
>=20
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!  I've applied the patch (with a few minor tweaks).


Have a lovely day!
Alex

> ---
>  man/man2const/UFFDIO_RWPROTECT.2const | 122 ++++++++++++++++++++++++++
>  1 file changed, 122 insertions(+)
>  create mode 100644 man/man2const/UFFDIO_RWPROTECT.2const
>=20
> diff --git a/man/man2const/UFFDIO_RWPROTECT.2const b/man/man2const/UFFDIO=
_RWPROTECT.2const
> new file mode 100644
> index 000000000000..42654a834cd5
> --- /dev/null
> +++ b/man/man2const/UFFDIO_RWPROTECT.2const
> @@ -0,0 +1,122 @@
> +.\" Copyright, the authors of the Linux man-pages project
> +.\"
> +.\" SPDX-License-Identifier: Linux-man-pages-copyleft
> +.\"
> +.TH UFFDIO_RWPROTECT 2const (date) "Linux man-pages (unreleased)"
> +.SH NAME
> +UFFDIO_RWPROTECT
> +\-
> +read-write-protect or un-protect a userfaultfd-registered memory range
> +.SH LIBRARY
> +Standard C library
> +.RI ( libc ,\~ \-lc )
> +.SH SYNOPSIS
> +.nf
> +.BR "#include <linux/userfaultfd.h>" "  /* Definition of " UFFD* " const=
ants */"
> +.B #include <sys/ioctl.h>
> +.P
> +.BI "int ioctl(int " fd ", UFFDIO_RWPROTECT, struct uffdio_rwprotect *" =
argp );
> +.P
> +.B #include <linux/userfaultfd.h>
> +.P
> +.fi
> +.EX
> +.B struct uffdio_rwprotect {
> +.BR "    struct uffdio_range  range;" "  /* Range to change RWP on */"
> +.BR "    __u64                mode;" "   /* Mode flags */"
> +.B };
> +.EE
> +.SH DESCRIPTION
> +Read-write-protect or un-protect a userfaultfd-registered memory range
> +registered with mode
> +.BR UFFDIO_REGISTER_MODE_RWP .
> +.P
> +The following mode bits are supported:
> +.TP
> +.B UFFDIO_RWPROTECT_MODE_RWP
> +When this mode bit is set,
> +the ioctl installs read-write protection
> +on every page present in the range specified by
> +.IR range .
> +Otherwise the ioctl removes read-write protection from the range,
> +which is also how a fault handler resolves an
> +.B UFFD_PAGEFAULT_FLAG_RWP
> +notification.
> +.TP
> +.B UFFDIO_RWPROTECT_MODE_DONTWAKE
> +When this mode bit is set,
> +do not wake up any thread
> +that waits for page-fault resolution after the operation.
> +This can be specified only if
> +.B UFFDIO_RWPROTECT_MODE_RWP
> +is not specified.
> +.P
> +Read-write protection only affects pages
> +that are currently populated in the range;
> +unmapped addresses are left untouched.
> +For anonymous mappings,
> +protection is preserved across page reclaim
> +(the marker rides on the swap entry)
> +and migration.
> +For shmem and file-backed mappings,
> +protection is dropped when the backing page is reclaimed.
> +Callers must also re-arm a range with
> +.B UFFDIO_RWPROTECT
> +after any operation that explicitly drops the underlying page:
> +.B MADV_DONTNEED
> +on anonymous memory,
> +hole-punch on shmem,
> +truncation of a file mapping.
> +.SH RETURN VALUE
> +On success,
> +0 is returned.
> +On error, \-1 is returned and
> +.I errno
> +is set to indicate the error.
> +.SH ERRORS
> +.TP
> +.B EINVAL
> +The
> +.I start
> +or the
> +.I len
> +field of the
> +.I uffdio_range
> +structure was not a multiple of the system page size;
> +or
> +.I len
> +was zero;
> +or the specified range was otherwise invalid;
> +or an invalid mode bit was specified;
> +or
> +.B UFFDIO_RWPROTECT_MODE_DONTWAKE
> +was specified together with
> +.BR UFFDIO_RWPROTECT_MODE_RWP .
> +.TP
> +.B EAGAIN
> +The process was interrupted;
> +retry this call.
> +.TP
> +.B ENOENT
> +The range specified in
> +.I range
> +is not valid.
> +For example, the virtual address does not exist,
> +or part of the range is not registered with
> +.BR UFFDIO_REGISTER_MODE_RWP .
> +.TP
> +.B EFAULT
> +Encountered a generic fault during processing.
> +.SH STANDARDS
> +Linux.
> +.SH HISTORY
> +Linux 7.2.
> +.SH EXAMPLES
> +See
> +.BR userfaultfd (2).
> +.SH SEE ALSO
> +.BR ioctl (2),
> +.BR ioctl_userfaultfd (2),
> +.BR userfaultfd (2)
> +.P
> +.I linux.git/\:Documentation/\:admin\-guide/\:mm/\:userfaultfd.rst
> --=20
> 2.54.0
>=20

--=20
<https://www.alejandro-colomar.es>

--azoyzbjhbeoj3i73
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmoYKGkACgkQ64mZXMKQ
wqk+2BAAl3LZrDJYQbpJXu9NCgWxCQB1upmmlNwbVz1ZRo63QMxR26snfRM98hUH
elXYppn3Oe7wmLuwzPu6EAhJCc/DBXRictit79NTRfOgIiXwPy7dfndI2Sfoqk4o
zDwJ6WjQCz8pqIIjKodcHK04x0chYnnz24+tu6bmTTKMWEVnDPgb57QuB/o5yoaV
p2UhGpBddPKWrDcbhqZTzx0v6KjcjT30kdv2y5W/O2U3ruNh/90M2z5xHS9L/y92
ahcR4DBtEEKDW1VNSGO3oSELJmFRL7uX9b/jLCFxroG5DDHhdUASbHQfmBlxpw4+
Ywn0t/lm7ArQF7yWFJ7hBzkpWMBfTFr+/u5G9WW4gexd6gySl7YKefyzIsdT3H6x
QZsaiETkxlC3qYz8wM2+YjnquKef4DRaM3m0KCLqnSjbCPJaazMLnZjK24wTZj4K
oh6s578mPayPFMYsWNlUSjh9NQvGxHJQPUNqMLALgm1B+E5y4OjaMgGeImrZtfaf
qRf1VGDW5TRFOxiiZJ18w3ND5hn5bY11Rog8SFF5UbKasqPvg72fUm9N7AsYhO1L
YQ+pqHO0c68QInJZC+m6yBRPS4L6e7lxAkJJ+rwfCkf4KnRHRp3l/gduyMHGN2ym
FGRzMUXIDud753oPo2STb3qyPXit4dv3KuqLB+OGM58iEB1MVyY=
=DZ0D
-----END PGP SIGNATURE-----

--azoyzbjhbeoj3i73--

