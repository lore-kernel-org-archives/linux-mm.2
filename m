Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3C22CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 14:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22208E0005; Mon, 22 Sep 2025 10:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF90F8E0001; Mon, 22 Sep 2025 10:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E9F8E0005; Mon, 22 Sep 2025 10:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F2288E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:28:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 411FB160111
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:28:44 +0000 (UTC)
X-FDA: 83917117368.17.C12108C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 61BD440012
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 14:28:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HVm/pR4c";
	spf=pass (imf12.hostedemail.com: domain of stefanha@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758551322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZHzOWV+oYS7NM+O/EnxL1NZMPrx+NYmi9n1hVl/0UI=;
	b=xCtX5X1ApjAJiLpTSZcptwe34NKrnyaL3D3p+/1C8/r6IjZHPlyNkqha4EOBzz2SryRry0
	yp+ZoQaI2KkXmjYd5DHFfYirL2DRPt4tsYEX9zXuelcGb62Ld9uPCjUORcie0MRpEj0bWH
	gWpxcDXmMGas/uoFdbesGe5qBp7qJ8M=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="HVm/pR4c";
	spf=pass (imf12.hostedemail.com: domain of stefanha@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758551322; a=rsa-sha256;
	cv=none;
	b=7ki9wsMhAk5O48mZaM7wCH7OZu4oaON9pZlLFUT+/4s78H46v/63b1gnj0ofY662yiij1q
	+ij88l7uhIZ841gF+HYPO2ATs/Di4QS1JHsqyyPA+gl6T+2a3bCHkBTjM3Nmu+wVGpy/qA
	vo50vj5F8SIE1HRO03BiSg/o5Y//Msw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758551321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mZHzOWV+oYS7NM+O/EnxL1NZMPrx+NYmi9n1hVl/0UI=;
	b=HVm/pR4c2B573amK/2EFz80VYHYOzVgKn88p4dt9namuswYJ/ca0COmPXPjci54go973Kg
	Fg4tclbSLtdCZnlgT9ycag2tbd3nTLANl0cefJlHZUZ1U1C1FgY+Gv87Wsgp1RErpfkAr8
	BdluSzmWXtuEamwp32HWN9vOCy8O7TU=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-0ss1WCFdPea5agxgnXoSyA-1; Mon,
 22 Sep 2025 10:28:35 -0400
X-MC-Unique: 0ss1WCFdPea5agxgnXoSyA-1
X-Mimecast-MFC-AGG-ID: 0ss1WCFdPea5agxgnXoSyA_1758551314
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE8121956055;
	Mon, 22 Sep 2025 14:28:33 +0000 (UTC)
Received: from localhost (unknown [10.2.16.34])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A7F791800446;
	Mon, 22 Sep 2025 14:28:32 +0000 (UTC)
Date: Mon, 22 Sep 2025 10:28:31 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <20250922142831.GA351870@fedora>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <20250919212650.GA275426@fedora>
 <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Bw/30tv/Tia50C1o"
Content-Disposition: inline
In-Reply-To: <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Queue-Id: 61BD440012
X-Stat-Signature: jiaxfs4xcbb5scuseukxugwbwkc4jbry
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758551322-74484
X-HE-Meta: U2FsdGVkX18Hq+JVI2SCrGFbJA3Wh+2gJWUM2/5EcufjA0L8JwI3Rk0wJTHSdvULKeiOK52HlpuHrAlxxFJpRdl/uOHByTwpawlcNTXNdUWVXoFk0NlZRMTmeO6IpoWnucEWtMK+ZT4ev6ZnF+Jzg0vp4nL7W7n/ggxmJOVLH8NTTt9EEDiXqSEyogBxhCZGZKdr8Fs9B9V4prFcfllWmzFRtcZUg+uVjN6gBM4uhe/YxtZtlJW6gpm+h6C5a2gFV1lCo+1yKfN6SIqHfe6ehVKwP+7OKrNR98g5mdz0pxrf3U7zRxRqD3e7Sxmh3uQYSzvCZuYlecQ5pdj+/ssKKajhyVAQ1MAphtLphulFJ7bhZ4yh4mte24sPiMbodKakrLxdj0Guit4/ttrLxtlvMOEmhr4WIj0njwHV65RFIC5yUPQsvthUTX9HyvKvpCPxtFwwAZJWq/fPnjAuw3eF/2yfT5rH+6AqwdMNrPWj3e13FbnvnVdBn8eF0tArOI7a3bfx44St3Dbw4qMGCp66XY4ZtRTycVp2uq9oh7L5lY83rdI3W/pbKsRRPk+KYufhdDOnTtra/fE4VRDWBxoK8ejXjfgH7kdrsx3K4EroucxuxnsJ0I/lEI64jHhiTwkjrXQrxcaNZ7iEuFNOkV5zWMINlqUgdPfUsRd9PFDFbaU0ATnl0ByV/914ixTFNprtWinOPwOPcLj3IS7pCs2gZv7gB6q4bh/nNCzfpbhHx9jkTPDQ6BuN/hjsia0qbPAg9pGsqZBm/toazoVoiK1ZcfW5JgiG8mjQGZhyCi+767cN0S9o7/LuEvjMXDyFm4ZgydAw6ixL/ktRPpdzfXIUJ5W6fg0Bkf/lnn/wG8XWiJlX/fU8ZZY1VtyYwPRCH84ShrihIbXbVcT+O+H2tpJPWnQ78kV82Wbjg6U8fmFScOUZcBmMce/jUo0QQRPYgxmiwuYdBUDT8s6fiCEIKQ6
 KyfUdC/p
 jiAxWBUnqHXyOXGDFaw9Uy+fFeF3jS1Y92eyM2I3iB9FJZbOWRRD7CqlmkyXBRx2waAQE0oIKleSekxsuTiqttzvp+HLH2Ty2Iz6I2f5bZ6z7ijQvwUBTEne2ROD3PmquhsFVpu9YM248oluZRt2cREtaKhizfucYx1kH9eVmnJoMh1U0bevWHQ5PycVjBNDBGaTo9n8PhAwierncn2LYGpjRuD/pwlFnYiwLCFCeqPiHMFHpkJFfpkQgRXYZh+6I4gCT52A5ltvGY7OnZrnlOEzm7yzbBe/LjYuss3fk4C5PR2h/oUIzkR+D6Cln+RUYSbLrJp8/YphvMGk2SKf4QP5jAGcYSl8ZC5mnyK7mtvzR59Sh4ZxnsoSFmwjBaUlvwZSJ7YGdIm+d8dtEnlvj62vbsTIYHlPa19a96wTaX+f9oC5aUtMNKXsIA07GXAkL1VuMgpiiZY26Z/Cwk4hmIBTfd1pLvy7dRQkO0suv70EjoXVv7OZwtqhvkIYrVlY5TzWHLsJui56QbVtJA9TnR/3KMA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--Bw/30tv/Tia50C1o
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 20, 2025 at 02:40:18PM -0700, Cong Wang wrote:
> On Fri, Sep 19, 2025 at 2:27=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat.=
com> wrote:
> >
> > On Thu, Sep 18, 2025 at 03:25:59PM -0700, Cong Wang wrote:
> > > This patch series introduces multikernel architecture support, enabli=
ng
> > > multiple independent kernel instances to coexist and communicate on a
> > > single physical machine. Each kernel instance can run on dedicated CPU
> > > cores while sharing the underlying hardware resources.
> > >
> > > The multikernel architecture provides several key benefits:
> > > - Improved fault isolation between different workloads
> > > - Enhanced security through kernel-level separation
> >
> > What level of isolation does this patch series provide? What stops
> > kernel A from accessing kernel B's memory pages, sending interrupts to
> > its CPUs, etc?
>=20
> It is kernel-enforced isolation, therefore, the trust model here is still
> based on kernel. Hence, a malicious kernel would be able to disrupt,
> as you described. With memory encryption and IPI filtering, I think
> that is solvable.

I think solving this is key to the architecture, at least if fault
isolation and security are goals. A cooperative architecture where
nothing prevents kernels from interfering with each other simply doesn't
offer fault isolation or security.

On CPU architectures that offer additional privilege modes it may be
possible to run a supervisor on every CPU to restrict access to
resources in the spawned kernel. Kernels would need to be modified to
call into the supervisor instead of accessing certain resources
directly.

IOMMU and interrupt remapping control would need to be performed by the
supervisor to prevent spawned kernels from affecting each other.

This seems to be the price of fault isolation and security. It ends up
looking similar to a hypervisor, but maybe it wouldn't need to use
virtualization extensions, depending on the capabilities of the CPU
architecture.

Stefan

--Bw/30tv/Tia50C1o
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmjRXQ8ACgkQnKSrs4Gr
c8iFTggAnVrECy2HUHacKiUoa/0O6N7WnJASVkoIOOM6+CKjlG2uzF8tSvls85dZ
ybO6yoTpnuEGFQXEAyA7aB3vc3RK5xxhtowcXnQpV6tzpGRKgEdLyCqvwq0DnOiu
aQZwB7XPmWVeROXSZgHpfEF6CYIthQBDpbTMBjQyGxCzD2VQf+GL9Je/3Dd7HQe6
LdVemRZrJqRh3HxHH0JwDAIBDeP4VKZWOme7qPE0si/8DUPx+2DPECH/HesiPm2t
/J5O8u71QN+D1X3M0V90uWC3udRQcTXSqgQUHSLPvV5V3bfRxFHi/nvRNGLElRzj
kKmT/NrKeONOTt+0Q0iKH5mcW6XvAQ==
=On8H
-----END PGP SIGNATURE-----

--Bw/30tv/Tia50C1o--


