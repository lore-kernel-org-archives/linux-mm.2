Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91F82D339BC
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 15:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3296B0006; Sat,  6 Dec 2025 10:15:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8AC36B0007; Sat,  6 Dec 2025 10:15:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9A096B0008; Sat,  6 Dec 2025 10:15:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B7CED6B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 10:15:26 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39C6E8A9D5
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 15:15:26 +0000 (UTC)
X-FDA: 84189395052.14.EE4AE93
Received: from tarta.nabijaczleweli.xyz (tarta.nabijaczleweli.xyz [139.28.40.42])
	by imf05.hostedemail.com (Postfix) with ESMTP id C88CA10001B
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 15:15:23 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=nabijaczleweli.xyz header.s=202505 header.b=Y08LxnbG;
	spf=pass (imf05.hostedemail.com: domain of nabijaczleweli@nabijaczleweli.xyz designates 139.28.40.42 as permitted sender) smtp.mailfrom=nabijaczleweli@nabijaczleweli.xyz;
	dmarc=pass (policy=none) header.from=nabijaczleweli.xyz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765034124; a=rsa-sha256;
	cv=none;
	b=40mm4Lj8AbOl4OKp13cgjTATZSlzGZ12Va1sJznYyeQiXgxKxJ7HuIdKRQ53xTRTAqYy5p
	GT3Widpz7CgI9q7pWuK2EDhUKU0BdZk/+9k4EWtMbvFY7A6ivI8N+P2rnrzIxKAkpQdByE
	j2NJetdObEqqlYwMPRQlw33HLHzEnp0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=nabijaczleweli.xyz header.s=202505 header.b=Y08LxnbG;
	spf=pass (imf05.hostedemail.com: domain of nabijaczleweli@nabijaczleweli.xyz designates 139.28.40.42 as permitted sender) smtp.mailfrom=nabijaczleweli@nabijaczleweli.xyz;
	dmarc=pass (policy=none) header.from=nabijaczleweli.xyz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765034124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaWnZ1VmKo6XRt2u7MWd4WFW7mk6d2I2802dOjaa1YE=;
	b=nxgrO2ql1ACStfVeA7PfkXeUw/R+8IBz0QKWnnsAT4fK9VfDVF3Xb42yCwZ9RbQrBqvGtF
	j4z+0OCxcPOlorgN6B9qbsilS18hdqS7SVLBouwkyZQWKJs1pulrqnDPQl/qYE65q6PLcw
	/uJ266aE86tI7Up1PYHctt8I2Ce4UG8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nabijaczleweli.xyz;
	s=202505; t=1765034121;
	bh=KZFZP3kx6PjyeS8vSsvChZpNDzoCxrRGkgYPfKdT3Oc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y08LxnbGyuvpFL8xnero7Z+OvguAtqj5WvOGU5sMkPnpuyFqL/Ow3YRyBXssR1eeZ
	 hcu3X3NZJbxsxXlESkG0BA3DqPCOj1jsCMwTRGUZBd3L5lisbKW5do0S1/d1Pe4x/J
	 3LnBpRVRRzGMK0U3HaRToYJiTijj3FRcuBPWFK/BM8vHCeaJKDZvJc2/m5EJoxEz8C
	 4l5jWhFX1Dt4O0NU+BtNyDoVbdpOQK+QZKi5Xl1+Hb0PI2Wfn9vwyTJrqARqAZsdcZ
	 pgGo7b+79Q5CNXgl385bKhFbJn5ryDD0gMETuhFe56PRRM216ejsFCAryQhBusfx2O
	 RH6jKXVSFhWYg==
Received: from tarta.nabijaczleweli.xyz (unknown [192.168.1.250])
	by tarta.nabijaczleweli.xyz (Postfix) with ESMTPSA id 5A25EE4E8;
	Sat,  6 Dec 2025 16:15:21 +0100 (CET)
Date: Sat, 6 Dec 2025 16:15:21 +0100
From: 
	Ahelenia =?utf-8?Q?Ziemia=C5=84ska?= <nabijaczleweli@nabijaczleweli.xyz>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: enforce the immutable flag on open files
Message-ID: <7xukn5ime27nvcxxvmddmh7bqc5uoyd7ytrph2ubyhoushhp7x@tarta.nabijaczleweli.xyz>
References: <znhu3eyffewvvhleewehuvod2wrf4tz6vxrouoakiarjtxt5uy@tarta.nabijaczleweli.xyz>
 <aTQnFQIc3ylSci1u@casper.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cgfp6ofqlwp5ih5i"
Content-Disposition: inline
In-Reply-To: <aTQnFQIc3ylSci1u@casper.infradead.org>
User-Agent: NeoMutt/20231221-2-4202cf-dirty
X-Rspamd-Queue-Id: C88CA10001B
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: t8a4577wr4s1sjrtbupjma45m5k394nb
X-HE-Tag: 1765034123-610906
X-HE-Meta: U2FsdGVkX1+va3pFPh8v5zKtjNF+tRub0Bgqoma061oVNBaZRyfkNbL9zwlQfCpEJNDddp0VSeSr4NHwsJmxwWPzHa1Yoba6yZpn61+EG4gTkvw6SzgMHks9Ll+wv5OfF3v1wZs6HRFektwot8xpC7npWqHe7PyZpDEe5zOEZINtBvLx7i8066Lgd83J+ap6aYfb03XWtZXTaXeVwaKPcV24913oD1rEox4Abq0ll2uT53f1NQgSKtJKWj3LAFlkMeWuxTdy4OINJ1dgzNAGqCce9l6q3aWG4jYDMiokvd1GSzRViGEX4i1d/puia4VhTpjoDrWnjg45dITT4ZkbIsCiT+hSpcY1D+z4Q6a5g2ALk9ddcjXSqRLZfEkn/2sD/yvdN9xo0JELqDzJFdXTTetSd9TwdBAqOk7QIblchqvHk9qmz9oEu+aez868v9GpLcWUgzOwgzpJW8hLFz4/TIrGb/XLMuF422N58EBQGHVrtvYgyGqwRVCTPsxBTcqKWU/PpRKmBu7IspC8/XuQB6N+w22ZKysjMA3AXQ9+Z1bUCdYZBfS1Vls+/0sistAfPPzwaEZpLfog0i1FngnrGXbVma+rXb4koHWFQfeSCi+j52pozC2br2sTYLEkP1tSXaSaDwCUkt9Zn8FD9K6xf079Pq51AFZ2ybFfxJQPBUdhUSwOHXVxuD6EI6nhEONfSRB9IoIJSCnZquxHlRUHypH8meVWDL00zsM+XhoQU9OT5zq94q7tQZZlUeQcNokomhKIxZdZTdlrGBOHXBUmx6UaYZIHZ5JKnULFXOpmNBUt72ku5l0hEXN1skmSPY4CKBwUVPWoTvm484RGNDzyVVRQCUnu74a2JteCIxXpFVJ8ZS0KfUslAoQKC2IFXDmuPujHWCAYb3A/aOFsztWqR35EsEl5HHGak7Ngkw8BhPbJo7V283aTlPjzJBssck7Rg7ozEtON1sXgji1pBjk
 rpfDxsat
 tKujvFtm7ASJX7fpe/L0fHIdt7ockEIiibIxxRbZnB+uXWtSJ99fgpuiOj9N9cx++yikilNcS42uVMFywOXeHsDfSVpCKuTfmXUwun2RrLI6OIH06V51or6ds+QjLlYduXm4Kxk+XkI3A93M35V6DGj51QQfEDi/yCDL+JK+CJhQewHHCcZrXRwC34XokiuyimHiFL+6E4jcOqPe5UtZ5ZI0o4I9QASVUDocPXne1vcFzk8CZaiHqEwDyohUV+FsppCFQMx4ZbKFTq4ZdCukBFhthwjb7SlxStK/Ky1uDqHR1BpbZ1bKKCBfZ78K/no1IJULWbxXUgaVSzDMKQ6LPqfHcqIaC/j+8lPGrdgo5sA1g/lp6oexn6WLp2zU0+rER3uxPi1N1GoWWHjR5BLDu3cqVWJpWxtR3WkSs2RaHydRrNQ8yXgvYx8R56BLRXoCa3fFDi0/cumKy4o5lmVPGci/zOFnz22WlcgKNX42MAh7Ad3r0hSl+iepBLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--cgfp6ofqlwp5ih5i
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 06, 2025 at 12:52:37PM +0000, Matthew Wilcox wrote:
> On Sat, Dec 06, 2025 at 01:03:35PM +0100, Ahelenia Ziemia=C5=84ska wrote:
> > diff --git a/mm/filemap.c b/mm/filemap.c
> > index ebd75684cb0a..0b0d5cfbcd44 100644
> > --- a/mm/filemap.c
> > +++ b/mm/filemap.c
> > @@ -3945,12 +3945,18 @@ EXPORT_SYMBOL(filemap_map_pages);
> > =20
> >  vm_fault_t filemap_page_mkwrite(struct vm_fault *vmf)
> >  {
> > -	struct address_space *mapping =3D vmf->vma->vm_file->f_mapping;
> > +	struct file *file =3D vmf->vma->vm_file;
> > +	struct address_space *mapping =3D file->f_mapping;
> >  	struct folio *folio =3D page_folio(vmf->page);
> >  	vm_fault_t ret =3D VM_FAULT_LOCKED;
> > =20
> > +	if (unlikely(IS_IMMUTABLE(file_inode(file)))) {
> > +		ret =3D VM_FAULT_SIGBUS;
> > +		goto out;
> I don't believe you tested this code path.  It contains a rather obvious
> bug.
You're right, I tested this on ext4 twice and didn't realise;
this ought just be return VM_FAULT_SIGBUS;.

But even this doesn't work, because shmem{,_anon}_vm_ops
don't have a page_mkwrite callback at all,
much less it being filemap_page_mkwrite().

I'm not sure how I concluded that they do.

Adding a shmem_page_mkwrite() works for the mmap case.

--cgfp6ofqlwp5ih5i
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEfWlHToQCjFzAxEFjvP0LAY0mWPEFAmk0SIgACgkQvP0LAY0m
WPEJuw/9Erzsnr20+rOiCsWz5rYiM3TNgbwGsRk18gmS2o+p/08ml/hJlTB/rrAX
2w0kL7ZuFmvicgXhv8XMr+va91MpBfkstKKZfI5ZIT6dQwX46iro+UDdIWW9L4hk
9kpUESrdbiAMtBi1LKSNYhG5WhNPXSPSnnz/rxYGJiZGvOW//G6aS5lvwc4mROmr
j/eJcZQPPItA40Nsuu0WATp4QINtDre5uhOxQx7CR4rupvCcD8Kh6DU817TfI6iF
XrxvqN8udiZkza/x1tHVVgsNq9DHYSxa2Jq9CncnX7v59EdP8EfW+O8el4jPFp0q
G9TamELg4MIvRHYY99tGEwUCbDy/xq3EaPLwgdtEvrcan/9xvMuglPwtzGnCYWrF
5y8+3DpiYo5+f/tsOIEgVwvNt3CQ1VQZLy5USeHUaBht2RpeWmTfTBPHzq9F3D5A
281yLY+khYuHymTbzPm6qAQgo7ZKTg3EWqWkFpaQ6XI8IIF9puoNS38bP2X1DC+I
fBxuIpqmft+o9AgiK5dzGK/fSTqcsyQJQc3Qlu1MCjLSwBtYQaV29MnV1KQEPuvu
ljkh1/gLsngTmFjBQNWOhD5knQXskC2BxslmnYftxYbnrX4YJwVmmX2PnxQHKDW8
cg9pdfgGJ+/KFTxnNrMElCXWC0Y8pTzzNzQ5dvENTBG96fT1r6E=
=3sVJ
-----END PGP SIGNATURE-----

--cgfp6ofqlwp5ih5i--

