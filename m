Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 104C9CD5BD0
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 23:36:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364196B0005; Wed, 27 May 2026 19:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31F096B0088; Wed, 27 May 2026 19:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B6F6B008A; Wed, 27 May 2026 19:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1001D6B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 19:36:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9AFAE1C1D33
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:36:10 +0000 (UTC)
X-FDA: 84814810500.30.6C51AF6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0F4294000D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 23:36:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Epdc4Nt1;
	spf=pass (imf11.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779924969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0HNc//f34RGpf1xRoUDqB2Pe9sWQRQuDT1VMPSc2QAk=;
	b=jq1MbZJkb1T1J7NI3kTCKXBV+lc2HhkyMOJ7CHETG90uo0E+rmmjsGSEllpxMoQA8VSXGM
	XAPVUnhNcgr50bF0o1Dtbn5Csb9aRutJg0JBijvA1vqXsurLiomfycH8fWJdAQYH/e2LsP
	BEMbMTI5AaODSz3nCNel+6VEbz2+nnw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Epdc4Nt1;
	spf=pass (imf11.hostedemail.com: domain of alx@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779924969; a=rsa-sha256;
	cv=none;
	b=SGJSoq45o6ofcKMAURd4LIRib8MLAu78Bmozv85nN7aZt24mltJEJMzHnaZy/hMfOyLxQl
	FSE6tfoZ8vn+V+1Jbj7AGWbcT7cEKGWdisWozDOHDDFBzfQe3FMTpKBpbhS6yixqMyqa+9
	83r3SRhyenugiVywKcRE/qtYyLIotr8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 71A8760572;
	Wed, 27 May 2026 23:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410701F000E9;
	Wed, 27 May 2026 23:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779924968;
	bh=0HNc//f34RGpf1xRoUDqB2Pe9sWQRQuDT1VMPSc2QAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Epdc4Nt1cEEp6ormzb3dkYzCJZGnzJ+1WQvzVkrM8u/8QSCmR/lzbkqfXy1OTTtdY
	 lu17jCm3GgvQ9uXscUszVXWnsFOfb9xctu3Brr/yKbzMlYCUZflmzAfnpd1F4awmAz
	 2KWYNq0R8nbcj/2fbfQQEiuTIUfa5eqa518EYsrRYgBErsGWXaiQ0xR750BIB/l/k8
	 k+QZSdzeA+BN5ZwbUyWFRM44bZUb3zjY1Nc9zm5F3zefJg7YDGo9fQRpkVxDtDkCTG
	 fpILxd5l5CjSi41hIPjRmnEaq94w076qaayNNaunQ0lnFumxRj0TTRntEy0AUCl7Xs
	 0G2GiYH4/pfRw==
Date: Thu, 28 May 2026 01:36:04 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v2 1/6] userfaultfd.2: Add read-write-protect mode
Message-ID: <ahd_zRgOsMwpalcR@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-2-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qbucw4jjnpokprpx"
Content-Disposition: inline
In-Reply-To: <20260526134149.2831720-2-kirill@shutemov.name>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0F4294000D
X-Stat-Signature: 9rqtof3pjpqqtnsqp9b37a8g99mu3p3p
X-HE-Tag: 1779924968-419107
X-HE-Meta: U2FsdGVkX1/nUhScZka+b4s9zfamPbhDxjVbhk6IKQd4GKIusn0Q2QN1lyOtpURr7U/uSg86Ph3Frf3g+AnfnMu9acey+0zjD+8sO0dIEWLjnbIQktP4DBaYXpD4WDTQQb/3gDYfzycBTPfUFYORZAslgUwVAE4Y5ZW8GarY+jsFcBDAmg9DFE/P7QYxk94waboWDtIQluMfu0vQCA02To8DnaF4Z8z/bl9XhGSclswBWGgFF0HGJkBTgC04mxqUZ/AkJX7Oa6F1AgSZ2ixBigK7XHDNs7BZHO46ObjDdvqRgWPOCiig+gxRgoMw8GWSAsad1CfOxnQtMhNNhVOMnZnWYBmfCweeAVm8mF8kYIgXXNFD5o+/l1S6eaW/+84kdfuYh9fgpmN5SAJGcnTLjFCZl1lwxwp74/fSXMv639q/ROrybadAa6Z8Fs3dFA2aUq36Mofg4DX3aY0PpaHnlKXD9GDgrIew7zFcZ4pH5McIeO8jLmwr+YNHVmBI4INfkGq5U6PoPQZD3g4ti+HNLwGv4q74hsYsvVjTLnCtG0JO3ymhdHIVuwbde1qSo8bGCzlBg8GOmIGhLKEyhxajkJZ6lruxqW1UGh5lgB3C+v24QjPEb/VNTemi7gawVjeQ/YxGkA36YoElwLvvwwX+3bJXFf4Sr88AgxbVH9mcmOS7z60dsjUtyA+v6VlONwABBmcDDHvtBQRNGouzc93PzycINfysWLhKSBr0bSWd5iO8I9nb70ZOuD3v+sLrBvZdpEkfvwXm5gUtwp+vK97taJJVbadeLyYt71z/rOJtD4KEe6rACg3eUulz0vvsMWnRxpGp0I52v+1AgPyTCDKDz8pAA3UhpxYg4yaSTe7bP8Mn0Qp+IJcAvOXRAF1UAzk6H3sVYXaz8lAP5IzPc9RMzvr7OdLRXeSVIuu3b1uD+JQhcY3AY5w6IZE4e5Dh6Ft0AJDVaoQoH4qaOPTTukz
 cFnWknrt
 EEb8CUNDotM0tN+clwdAEcV4iirEqFCroe4VTYcNqVmLCO8/I4zZQMECJIXqPXgyQoahAVxPgb2Dm4/rC+6qPh+bRJjk4CrHfLB+hWYi6++xxx3q1Wt8vs5thHwaA0jRVdSglRD1wDjtvLgWQQ6brHy6P6KFncMEAwmx4/JlAjQwT41Twcyo5TNjy+tUfvFrplUuU3Hnqg8+wV5YVwuCHR3dGP2AuDmrekzD+oQHqBjoqs93SoqRMtbLm47EzwSqVLJThl+0OTQvcpL3czAlkxDqFnoZKwCF/R7xsngI7xChqymjc+M/JsZlm94jvlVFO5Pi6v5rpbhjPE+f9reiCjdV+ZI8Ie2j3G7dAQmeauiSh10/YWRo9PTsO2vECXvR3JWXbknDfPP+8LXECbbs2MT4pA6fOpjs2bN49PFtXSayBMKDn7WajiKKelw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--qbucw4jjnpokprpx
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: Re: [PATCH v2 1/6] userfaultfd.2: Add read-write-protect mode
Message-ID: <ahd_zRgOsMwpalcR@devuan>
References: <20260526134149.2831720-1-kirill@shutemov.name>
 <20260526134149.2831720-2-kirill@shutemov.name>
MIME-Version: 1.0
In-Reply-To: <20260526134149.2831720-2-kirill@shutemov.name>

Hi Kiryl,

On 2026-05-26T14:41:44+0100, Kiryl Shutsemau wrote:
> From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
>=20
> Read-write protect mode (UFFDIO_REGISTER_MODE_RWP) is supported starting
> from Linux 7.2. It traps every access -- read or write -- to a present
> page within a registered range. The matching UAPI consists of:
>=20
>   - UFFDIO_REGISTER_MODE_RWP   registration-mode bit
>   - UFFD_FEATURE_RWP           capability bit
>   - UFFD_FEATURE_RWP_ASYNC     async (in-kernel) fault resolution
>   - UFFDIO_RWPROTECT           install / remove RWP on a range
>   - UFFDIO_SET_MODE            runtime sync/async toggle
>   - UFFD_PAGEFAULT_FLAG_RWP    new pagefault.flags bit
>=20
> Document the new registration-mode entry, the "Userfaultfd read-write
> protect mode" section, the new pagefault flag, and a VERSIONS line.
>=20
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Thanks!  I've applied the patch.


Have a lovely night!
Alex

> ---
>  man/man2/userfaultfd.2 | 174 ++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 170 insertions(+), 4 deletions(-)
>=20
> diff --git a/man/man2/userfaultfd.2 b/man/man2/userfaultfd.2
> index 6d56085f1534..c395bf9bb332 100644
> --- a/man/man2/userfaultfd.2
> +++ b/man/man2/userfaultfd.2
> @@ -111,6 +111,32 @@ .SH DESCRIPTION
>  until user-space write-unprotects the page using an
>  .B UFFDIO_WRITEPROTECT
>  ioctl.
> +.TP
> +.BR UFFDIO_REGISTER_MODE_RWP " (since Linux 7.2)"
> +When registered with
> +.B UFFDIO_REGISTER_MODE_RWP
> +mode,
> +user space will receive a page-fault notification on any access
> +\[em]read or write\[em]
> +to a page present within the range.
> +By default,
> +the faulted thread will be stopped from execution
> +until user space removes the protection using a
> +.B UFFDIO_RWPROTECT
> +ioctl;
> +if
> +.B UFFD_FEATURE_RWP_ASYNC
> +was negotiated,
> +the kernel restores access in place
> +and the faulted thread continues without blocking.
> +.IP
> +.B UFFDIO_REGISTER_MODE_RWP
> +and
> +.B UFFDIO_REGISTER_MODE_WP
> +cannot be combined on the same range;
> +attempting to register with both bits set fails with
> +.BR EINVAL .
> +See the "Userfaultfd read-write-protect mode" section below.
>  .P
>  Multiple modes can be enabled at the same time for the same memory range.
>  .P
> @@ -192,6 +218,24 @@ .SS Usage
>  kicking the faulted thread to continue.
>  For more information,
>  please refer to the "Userfaultfd write-protect mode" section.
> +.P
> +Since Linux 7.2,
> +userfaultfd can do read-write-protection tracking,
> +which traps every access
> +(read or write)
> +to a page present within a registered range.
> +One should check against the feature bit
> +.B UFFD_FEATURE_RWP
> +before using this feature,
> +and optionally negotiate
> +.B UFFD_FEATURE_RWP_ASYNC
> +to have the kernel auto-restore page permissions on fault
> +without delivering a notification.
> +This mode is intended for working-set tracking
> +by VM memory managers and similar callers;
> +cold pages can then be evicted using independent kernel interfaces.
> +For more information,
> +please refer to the "Userfaultfd read-write-protect mode" section.
>  .\"
>  .SS Userfaultfd operation
>  After the userfaultfd object is created with
> @@ -387,6 +431,113 @@ .SS Userfaultfd minor fault mode (since Linux 5.13)
>  Minor fault mode supports only hugetlbfs-backed (since Linux 5.13)
>  and shmem-backed (since Linux 5.14) memory.
>  .\"
> +.SS Userfaultfd read-write-protect mode (since Linux 7.2)
> +Since Linux 7.2,
> +userfaultfd supports read-write-protect mode.
> +Unlike write-protect mode,
> +every access
> +\[em]read or write\[em]
> +to a protected page generates a userfaultfd notification.
> +It works on anonymous, shmem, and hugetlbfs mappings.
> +.P
> +The user needs to first check availability of this feature using the
> +.B UFFDIO_API
> +ioctl against the feature bit
> +.B UFFD_FEATURE_RWP
> +before using this mode.
> +See
> +.BR UFFDIO_API (2const)
> +for the recommended discovery sequence.
> +.P
> +To register with userfaultfd read-write-protect mode,
> +the user needs to initiate the
> +.B UFFDIO_REGISTER
> +ioctl with mode
> +.B UFFDIO_REGISTER_MODE_RWP
> +set.
> +.B UFFDIO_REGISTER_MODE_RWP
> +cannot be combined with
> +.BR UFFDIO_REGISTER_MODE_WP ;
> +however it can be combined with
> +.B UFFDIO_REGISTER_MODE_MISSING
> +when the caller also wants notifications for fresh page populations.
> +.P
> +After registration,
> +the user can read-write-protect any existing memory within the range usi=
ng the
> +.B UFFDIO_RWPROTECT
> +ioctl where
> +.I uffdio_rwprotect.mode
> +is set to
> +.BR UFFDIO_RWPROTECT_MODE_RWP .
> +Read-write protection only affects pages
> +that are currently populated in the range;
> +unpopulated addresses remain unpopulated
> +and fall through to the normal missing-page path on first access.
> +.P
> +For anonymous mappings,
> +protection is preserved across page reclaim
> +(the marker rides on the swap entry)
> +and migration.
> +For shmem and file-backed mappings,
> +protection is dropped when the backing page is reclaimed
> +and must be re-armed by the caller.
> +Protection is also
> +.I not
> +preserved across operations that explicitly drop the underlying page:
> +.B MADV_DONTNEED
> +on anonymous memory,
> +hole-punch on shmem,
> +truncation of a file mapping.
> +Callers must re-arm the range with
> +.B UFFDIO_RWPROTECT
> +after any such operation.
> +.P
> +When an access fault happens against a protected page,
> +user space will receive a page-fault notification whose
> +.I uffd_msg.pagefault.flags
> +field has the
> +.B UFFD_PAGEFAULT_FLAG_RWP
> +bit set.
> +.P
> +To resolve a read-write-protect page fault,
> +the user initiates another
> +.B UFFDIO_RWPROTECT
> +ioctl whose
> +.I uffdio_rwprotect.mode
> +has the
> +.B UFFDIO_RWPROTECT_MODE_RWP
> +flag cleared.
> +This restores the original VMA permissions on the affected pages
> +and wakes any blocked threads
> +(unless
> +.B UFFDIO_RWPROTECT_MODE_DONTWAKE
> +is also set).
> +.P
> +If
> +.B UFFD_FEATURE_RWP_ASYNC
> +was negotiated alongside
> +.BR UFFD_FEATURE_RWP ,
> +the kernel resolves access faults in place
> +without delivering a notification:
> +page permissions are restored automatically
> +and the faulting thread continues.
> +Callers can later reconstruct which pages were touched
> +by inspecting the
> +.B PAGE_IS_ACCESSED
> +bit returned by the
> +.B PAGEMAP_SCAN
> +ioctl described in
> +.BR ioctl_userfaultfd (2)
> +and
> +.IR Documentation/admin\-guide/mm/pagemap.rst
> +in the Linux kernel source.
> +.P
> +The async mode can be toggled at runtime using the
> +.B UFFDIO_SET_MODE
> +ioctl,
> +which lets a single userfaultfd switch between async detection
> +and synchronous eviction without re-registering the range.
> +.\"
>  .SS Reading from the userfaultfd structure
>  Each
>  .BR read (2)
> @@ -531,13 +682,17 @@ .SS Reading from the userfaultfd structure
>  .B UFFD_PAGEFAULT_FLAG_MINOR
>  If this flag is set, then the fault was a minor fault.
>  .TP
> +.BR UFFD_PAGEFAULT_FLAG_RWP " (since Linux 7.2)"
> +If this flag is set, then the fault was a read-write-protect fault.
> +.TP
>  .B UFFD_PAGEFAULT_FLAG_WRITE
>  If this flag is set, then the fault was a write fault.
>  .P
> -If neither
> -.B UFFD_PAGEFAULT_FLAG_WP
> -nor
> -.B UFFD_PAGEFAULT_FLAG_MINOR
> +If none of
> +.BR UFFD_PAGEFAULT_FLAG_WP ,
> +.BR UFFD_PAGEFAULT_FLAG_MINOR ,
> +or
> +.B UFFD_PAGEFAULT_FLAG_RWP
>  are set, then the fault was a missing fault.
>  .RE
>  .TP
> @@ -640,6 +795,17 @@ .SH HISTORY
>  .P
>  Support for hugetlbfs and shared memory areas and
>  non-page-fault events was added in Linux 4.11
> +.P
> +Read-write-protect mode
> +.RB ( UFFDIO_REGISTER_MODE_RWP ,
> +.BR UFFD_FEATURE_RWP ,
> +.BR UFFDIO_RWPROTECT )
> +was added in Linux 7.2,
> +together with
> +.B UFFD_FEATURE_RWP_ASYNC
> +and the
> +.B UFFDIO_SET_MODE
> +runtime mode toggle.
>  .SH NOTES
>  The userfaultfd mechanism can be used as an alternative to
>  traditional user-space paging techniques based on the use of the
> --=20
> 2.54.0
>=20
>=20

--=20
<https://www.alejandro-colomar.es>

--qbucw4jjnpokprpx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmoXf+MACgkQ64mZXMKQ
wqn99Q//aRTYKv3/sGG0tLUJrP26/WR/9/GY/yJgmDbt32sC6Jj8IFACrtmPS4Ub
qQP/Sp2E0PaATkWbh5XN33UQpVdZ5CmB2dOBn4SmJo+veXPJMHYtbUY9mZaSbWk8
Ei/i0NvWtQaGa9q7A/B2jpfuJDj24CWe+nSxLux6AyEnR2xsh+EwZuz79sGqZB2A
DsvKBeAwJTYNRTXzE2+JfBSzHxRIlNtgvV7Z4BpidQFxcgwDY2sdKcWZVx6IxKYN
FZG1I9ChQoyoinPg3ruC/MiHLNTX3vaD0PFXGbItAxuQLp37phPFkKx5+TwSTWFB
mvcXsMhkJ6WrESwptypKAqljeGayxEJZC3p9HlXp/KfRaTEOM97CbYHmkS+PYP7E
sB6Fh9qPs9O7BiFImvBpTnadxGnzrbstTuSAaC/O/Cr/9p/IvZmvNFs/rJMEYrtx
4kIRAm5Lg5R4xlp0knw3n7zonxNyyg5SuryYVwMa9HoJ6xhb6odj09/8MJhOPZcY
b0uCo5lWeDePpaodROisAgnKBT4Y69hXPwMLOBzmrl7Ql+DM500Nj7Y/xcpuXu0o
t4IvfXiDQxuY5yMrsx5/WBBUTsIPyKBYIbNvFpedF0hhI4bYts9/ZL9NbTX4fS5Z
11SOF+v9ix5U7CrOf8PCZbOT7Lf79m1G20pKpMEGLec1DzaATm4=
=WYBA
-----END PGP SIGNATURE-----

--qbucw4jjnpokprpx--

