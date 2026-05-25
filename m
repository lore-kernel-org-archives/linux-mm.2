Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 063B3CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 14:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685686B0005; Mon, 25 May 2026 10:03:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635EA6B0088; Mon, 25 May 2026 10:03:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 573156B008A; Mon, 25 May 2026 10:03:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 465986B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 10:03:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E710C120131
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:03:57 +0000 (UTC)
X-FDA: 84806110914.21.A08E49A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4B08440006
	for <linux-mm@kvack.org>; Mon, 25 May 2026 14:03:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hET13lkM;
	spf=pass (imf27.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779717836; a=rsa-sha256;
	cv=none;
	b=4teabPRK6Wul3ramrEtJRFJ4MtRdmSUZufB0C230gm7sm0uC3/PkqaZf0XOc9BQkYyBmWE
	Mnplvv0JNDIepASuNyBSShAPC9BOCqyfAJQqUpnL3xT2EKpbKWKxi4Wn+B2/7LbxmKyunq
	LIr+mTUs1abIn48dGHzXtf85GC6tn4k=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hET13lkM;
	spf=pass (imf27.hostedemail.com: domain of alx@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=alx@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779717836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q7DoLpWkhQsDtfoy7st1735ka24lO3u8V+ZEkbAqMpY=;
	b=dUGXyqEEMsjGaXpH4cXjnt2vamz+uYycWNvRDwToFf7JwoZr2BcnyAcOYuBWwneQkjf8+S
	6aX+aR9zyU1WW1AWJbnTjyyV22iB5LsZCsFlsRV+ZLQwl19NhmHCCVqTn5MyKruHd/fx/D
	+g13OBvAs6j54XeYV83SqKlDduxM6Cg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7310343660;
	Mon, 25 May 2026 14:03:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749841F00A3A;
	Mon, 25 May 2026 14:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779717835;
	bh=Q7DoLpWkhQsDtfoy7st1735ka24lO3u8V+ZEkbAqMpY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hET13lkMDbx21nMAENnGcTDwAe0QE+nPR8JaE6Y+MjYYGjbiSfQW7cNOxXJ38BySK
	 GJwg6h0fVgZCb5G9lHChl1dCHLOBnYAWFFGJu2Q/k8R7tklG03TMKEBrkC0hWQZt6M
	 uZNC29TIOkvJ886EBV/HzMvpHsiHobPTs1TdZS1qYp240KsCAnsx1ERJu/+G2pZMQ4
	 cICzEYQ/JjubzwrlidMpwoTMIUCGLfQJVH9skXiOCAfIt7ma8baU47O5CLKnmlXMbr
	 Nx8lE7WBsaxSIILHHDf+38h/6rGXYctZ/BzZPKdlwc21Pn0qr5wV2K2hJiqqEOo4w6
	 a+I6TMbys2Z1Q==
Date: Mon, 25 May 2026 16:03:51 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-man@vger.kernel.org, linux-mm@kvack.org, 
	akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, david@kernel.org, 
	kernel-team@meta.com, Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH man-pages v1 4/6] UFFDIO_API.2const: Document
 UFFD_FEATURE_RWP{,_ASYNC} and 1 << _UFFDIO_SET_MODE
Message-ID: <ahRWqj2BbBGL6wYD@devuan>
References: <20260525122816.1956804-1-kirill@shutemov.name>
 <20260525122816.1956804-5-kirill@shutemov.name>
 <ahRV5sZCUXVQ_fBs@devuan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="wizqev5eqduf57wx"
Content-Disposition: inline
In-Reply-To: <ahRV5sZCUXVQ_fBs@devuan>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4B08440006
X-Stat-Signature: 4otii6icxb7douxi4eimach6ogs19nci
X-HE-Tag: 1779717836-955342
X-HE-Meta: U2FsdGVkX18kzow9AhqvxnYqJmaLWAvneeRAt8YnLwgzzSr6ltNpO3+TZZCqN6xePyjYACjhLpcWjSsNN2WllbgVlaMwtNkfRa21XEJWTfzA+VUWz1yTr+YJGjevUOq2fpa0E9KEp8Tyjlshs8Xvgh/UD0g6iHdYSLAmB6Y3cpKVrktlPAqy6r64vM8YU42vXtXMGkQLtOBTqICfo8fxo5ngSH5o4JZuNG7h3ouN0YJ5FjGP0hdL6ObrytqkNewNtwVsyL1IeyII1e6oFoHImJpjbN+6coi1sffpqYcDezGy9FYnpp2lVxl7Q1ruD49ctoRBXPVDSlfrfD0aNevVYKoAJON4RwWZpaLjxStRMW/Q0kNmijgnVMfu4U7xVtUccxQVSguiDsNkJCYWPEvpYf6jbhfArTHCKyIyT03Ul4w3VWl1uK8ghoWgdORr+NsM854CRrVE3kVbP6YwC7uwZPN7dV1LjOYMfSD0/P8OyZpD9nuqZsFS+eINUJ1dtWnYJYqvwqEUG6Cq6BWFYyqW8fim/I5u39HWELpeWxugAUlfqAX/crB+eRaiDAJKniLaBsALAOD73nfas0Faxdu8fqNQAtkJGeSyu6qfkr+FWWrqJdrFGG3yIrae4lF7RoU0DtdH1Gn6m4ry+8vrprJFVIErgkkxNepW9GIoUEETI/LqCaeZsgRZSqklkbOdjHsjXZmyKqU7q3i3ETcFYPU+2ikVoZYnCdAELMo0hKR1UC5MsHrPsX+u9gvEDSg+EOYu7MSmP7Q0qi+Ccd9X9Qs2AUpH8+At/wcDORBZ/NDmiRQ1fzlhlnaINrSRRkJX1tvc5utPiVmyCTOMe4sFy9Dmos7TiQ1twV1hp5BhBDhj+eACM6wlO2OSRkPwsN5Ha/zd1SEhUeHr+s7xHBb6XJJRtUaWM96DjHY7KMjgXSFMJ4xBGDPee+ax/hHz2HFwKaFqFWGFME4ySgYC412Bftd
 q1qpLS8W
 7DxhlEuWJmnGk2szZTalYcD7siP96j9derYe97ZkUe4zR+dVBHRB80jHRG2dlXrGVD4TzFnwHKb3+LyaadZ+DEkeBaZR4H0STuU/wo5MpPaklQjuDWqx2C+B9LmQ32UjdBFlYc5y8KAuPrhEPWbXYhjtsPycMm2YGxKmw8/Z2m+fCo8e9C4HX7JHcUlSHzyUzs/hSKjDlfeW0hJnImUmKLC7E/BD0wg6mu35nxChm1f7Ffqeoh9ydYlQ9PuumfKHUY1eII0gd446JMoK+d7DMXdO2N4UsZTKicf7ciC08oPCtb13DIWjyp9+jLOFzZCIPlgzO0n60uf3wifSjkQg8DXmHx6PihS0pgHVpAR3vanWaW7Y94jxa/EoCtJW4puv/vYJNUqYquqB640Sgc5WwItMCwDZ5ZeglpwO9zX11aRWhT5x6AfCg959cyy10aOu/PO8EJ8lfTQQ1pckQ8zLkNiCSC/ekkM3s/Bsf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--wizqev5eqduf57wx
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
Message-ID: <ahRWqj2BbBGL6wYD@devuan>
References: <20260525122816.1956804-1-kirill@shutemov.name>
 <20260525122816.1956804-5-kirill@shutemov.name>
 <ahRV5sZCUXVQ_fBs@devuan>
MIME-Version: 1.0
In-Reply-To: <ahRV5sZCUXVQ_fBs@devuan>

On 2026-05-25T16:00:37+0200, Alejandro Colomar wrote:
> Hi Kiryl,
>=20
> On 2026-05-25T13:28:14+0100, Kiryl Shutsemau wrote:
> > Add the two RWP feature bits introduced in Linux 7.2:
> >=20
> >   UFFD_FEATURE_RWP        gates UFFDIO_REGISTER_MODE_RWP and the
> >                           UFFDIO_RWPROTECT(2const) ioctl.
> >   UFFD_FEATURE_RWP_ASYNC  in-kernel resolution of RWP faults without
> >                           delivering a notification; requires
> >                           UFFD_FEATURE_RWP to be set in the same
> >                           UFFDIO_API call.
> >=20
> > Also document 1 << _UFFDIO_SET_MODE in argp->ioctls, the
> > file-descriptor-level bit that advertises UFFDIO_SET_MODE(2const) for
> > toggling UFFD_FEATURE_RWP_ASYNC at runtime; it is independent of any
> > registered range.
>=20
> Would you mind separating these into 3 patches?  Thanks!

Actually, I retire this.  I think it makes sense as a single patch.

Cheers,
Alex

>=20
> >=20
> > The existing page intro already describes UFFDIO_API returning EINVAL
> > on unsupported feature bits and the temporary-uffd probe pattern, so
> > the new TP entries do not re-state that.
> >=20
> > Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>=20
>=20
> Have a lovely day!
> Alex
>=20
> > ---
> >  man/man2const/UFFDIO_API.2const | 29 +++++++++++++++++++++++++++++
> >  1 file changed, 29 insertions(+)
> >=20
> > diff --git a/man/man2const/UFFDIO_API.2const b/man/man2const/UFFDIO_API=
=2E2const
> > index e894114bb8e2..d2819f009f97 100644
> > --- a/man/man2const/UFFDIO_API.2const
> > +++ b/man/man2const/UFFDIO_API.2const
> > @@ -213,6 +213,28 @@ If this feature bit is set,
> >  the kernel supports resolving faults with the
> >  .B UFFDIO_MOVE
> >  ioctl.
> > +.TP
> > +.BR UFFD_FEATURE_RWP " (since Linux 7.2)"
> > +If this feature bit is set,
> > +the kernel supports read-write protection tracking, and the
> > +.B UFFDIO_REGISTER_MODE_RWP
> > +registration mode and the
> > +.B UFFDIO_RWPROTECT
> > +ioctl become available.
> > +.TP
> > +.BR UFFD_FEATURE_RWP_ASYNC " (since Linux 7.2)"
> > +If this feature bit is set,
> > +the kernel will resolve read-write protect faults in place without
> > +delivering a notification, automatically restoring page permissions and
> > +letting the faulted thread continue.
> > +This bit requires
> > +.B UFFD_FEATURE_RWP
> > +to be set in the same
> > +.B UFFDIO_API
> > +call.
> > +The async mode can also be toggled at runtime using the
> > +.BR UFFDIO_SET_MODE (2const)
> > +ioctl.
> >  .P
> >  The returned
> >  .I argp->ioctls
> > @@ -234,6 +256,13 @@ operation is supported.
> >  The
> >  .B UFFDIO_UNREGISTER
> >  operation is supported.
> > +.TP
> > +.BR "1 << _UFFDIO_SET_MODE" " (since Linux 7.2)"
> > +The
> > +.B UFFDIO_SET_MODE
> > +operation is supported.
> > +This is a file-descriptor-level ioctl and is reported once per
> > +userfaultfd, independent of any registered range.
> >  .SH RETURN VALUE
> >  On success,
> >  0 is returned.
> > --=20
> > 2.54.0
> >=20
> >=20
>=20
> --=20
> <https://www.alejandro-colomar.es>



--=20
<https://www.alejandro-colomar.es>

--wizqev5eqduf57wx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmoUVscACgkQ64mZXMKQ
wqlYNA/9EUn3OCwR6YmzZ3ps6W0TW+xsLs4Rbb9gk+093unhjHyuVe3b/DxYvrm+
s2TT+4Y3UckxORNPcUE01i72H2+CA3L34Q6QRhRlPJZxb3cvqjcUwpfsngYaoJqE
hhx/X6XgaOq6wYJWX3ZUUkm35fdC2VKO4gfNIMQvr9DbiI1iqqspAsPYM+5A5WKn
bfJ9vH3uNMqmLbvGpRbE37PhNsTMDmC/dra+NzusvNRJgy8voO24pe4YiAJ6wZ8i
GlQGKt/Larw3W7VHBU7jiCrj8iZI/XMbrtEIGgixH0EWJ1+Z5mEvobcQ8C8/0HNq
dZgug3g5aq24FoUViItQJGj8x0VuIacmKyDkZdZ5z6sxK+ecMU4somzER9dczoHV
BazpNaa59qUUEnIuY5yZNQLz2rJCYjhKuYnrk5U4dIaO4G67YG3LFSBGKzecx3rH
XSxHutsSWuQKvDcd2L+Cpj8msvUkeAbmJDaK5RA6R3DRj4UnTga0XidFQN/WU9gW
OaP4RzDb78mnJMa8y2XWAaQlEkDqEwjbN1DEprDnCtYqG5L7vk1o0fPfXu7kANfE
BbsG/WeeZLSAasGI9y1fSaXMEgTW77fZg12cOKwPUgmtLW6MQFcHp5MDv7YMAqFi
lDCrmuNPiU9cOI0P7gPd8P6sQhvA36nIfc5i7a1oVn8hMrX9r50=
=oeED
-----END PGP SIGNATURE-----

--wizqev5eqduf57wx--

