Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3395CCAC5AC
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 17:05:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DAF18E0005; Tue, 23 Sep 2025 13:05:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B2A48E0001; Tue, 23 Sep 2025 13:05:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EF3B8E0005; Tue, 23 Sep 2025 13:05:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 68A378E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 13:05:58 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0F8ED1DFE04
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:05:58 +0000 (UTC)
X-FDA: 83921142396.28.C828475
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4C7BB180008
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:05:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DnXjNFVw;
	spf=pass (imf16.hostedemail.com: domain of stefanha@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758647156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Si+gRDqfMlxuN0KqN3KFYYBkczK7pbhlc1HLNzDjYGg=;
	b=BV/oqWY2oNNFFGq8WDKP6mZrwkzdbZIHZmHS2t8hW1Qevs91LABelOCs2I0/Xi/NEa1QQM
	vzEqEO9iUb9dLLrVPxz2Hb7ieVLMsBScgyayKeu7mDbW0lAk9Cre4NV1dR/gLjHTPxfKSd
	61i6dfMZpCraFXim0zq2Wl80czVnpEE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758647156; a=rsa-sha256;
	cv=none;
	b=cj8HUkOS3BsFWRdwcBgK+5Lyf4hCtXmz4ZW+0Z+XhEs4n2Z8mCh1K6RfNgM0dby58dFQ2m
	J5Q0qWljkjxo9G+QipKfyZ4JJqt7Fc3bJJCgcmeaUOCcQhHyTzqDUBaeCtQzWY40Z1TMnk
	F+vQGcUPCEswxeFTZsKtiSBYpDqlQOI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DnXjNFVw;
	spf=pass (imf16.hostedemail.com: domain of stefanha@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758647155;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Si+gRDqfMlxuN0KqN3KFYYBkczK7pbhlc1HLNzDjYGg=;
	b=DnXjNFVwpzCm6XH0AOVNqDfBPmiyHV3ljem5nk9UqOse3WyhhQdhx9inDJ/NYrvDIfHlkr
	iYTcVW5kuNVjJVSNfyCaenJfGqI3H0NZniIgMAjEEmfCgUm8JZOvD5woGdBK0Co2QGTzIf
	A7qzrbcqXLh5Vil121x+PaEaP0xDFD8=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-456-r0ZRWA2iMGiiOTICcbLMBg-1; Tue,
 23 Sep 2025 13:05:50 -0400
X-MC-Unique: r0ZRWA2iMGiiOTICcbLMBg-1
X-Mimecast-MFC-AGG-ID: r0ZRWA2iMGiiOTICcbLMBg_1758647148
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C7C0D1800372;
	Tue, 23 Sep 2025 17:05:47 +0000 (UTC)
Received: from localhost (unknown [10.2.17.69])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id B878D19560B1;
	Tue, 23 Sep 2025 17:05:46 +0000 (UTC)
Date: Tue, 23 Sep 2025 13:05:45 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, pasha.tatashin@soleen.com,
	Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, multikernel@lists.linux.dev
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <20250923170545.GA509965@fedora>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <20250919212650.GA275426@fedora>
 <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
 <20250922142831.GA351870@fedora>
 <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fOWoD/rtAfxeWV+w"
Content-Disposition: inline
In-Reply-To: <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4C7BB180008
X-Stat-Signature: aoefkuxjw5cmkegt38qfkpzg8qei9dh9
X-Rspam-User: 
X-HE-Tag: 1758647156-1968
X-HE-Meta: U2FsdGVkX19jsC6OPo6REJV7NUDqJC5utixdvJsZIHctxP+wqWCcUtVZbjvMNEYdsBllSrqiLa9yod+ba8puf3HsQzNjtFEOEY5imu9EZ6xXbIw3YHjXBEh60Z3VkWIBAvydePCrPx7z5p6nUbEnk1OOo+yt895DEwSII3k9g6MVuPGb8bhuWAROIcTux2JllyfL1hRRx4BSSP9r+qgY8fRq0RZ/nRPmDtIROA95wKq1vlqviwzD/VEbL6ltyxepwzXdSeMRLBovdBEqqUmRRNTuFWIrwyvsPy+A7Z+wGiiuLhO/7CarjjnxwEC1NSUd/cUC59aVjnh+QZqsc+vY1ZLUZ/kveRCzvbtvObMa6tpMU5FGbZ7ccb1YExO1lckuqlEiM6i7sKgDzuZLDBSEC084xmpXfS0EbOcl7Dk7y/EVcGx4kqnQuqbtH1oGbC97pIRzmNmj/xbdaeJF2tg61awMj6D4VH9QOj3H/IgfJdWUfINiUq1MizZSHsdI7dw7ex8W2uRUa3W6fvKRRg8BwywI15H3M7ck06r1U6Ka7CxSP5hi+WqlmyDA1xe92UxhrJAucd3iRZBgSRApoFgcxcyjvZdgelNF8pLUv5zy9eNCQhTxpxP6Q6uRcr1Y/RxJH5f8GN7Lck35FH+Xtmk+m2C2rrxK+wwh4plwxFpCFR/OraV1orXmEf4c+XCz6rarCj+e6BBVTzOb6SjttjGmvbQLoc5y95WmgHVJnEU7eOcEi9RKsFvChB59pxUXKbU0YXS1T0K0PYk5Rp6UDU/telJhXCQpFWqFD/9Rb/9j7N8XCwQ2PVoFimnZIJpYo1iPSq+XIni+37VhiSG8Pmz1k+dGgIn2jsvSNteXBh9AM9whuXuuOdQLGVr82Re7VIQw4blcrqhBtV34pGqHyi5Sjx0wsR/0+lHbR6wlJtwobl/IfK1M709cqsaUCjT9P4jQ1qD235Ry0mfK2PFWCC4
 3TGDZxh7
 6SwVm7ossQsxtvtTFKFpFExFMP37t3iDEPU2gAm6kJ3r5V5JEmUZNkFA6+UeRhJStaF6uBcx/rVvR9tZySXMSmeHPtQVDXztqKP8vmmz0oy7U6lqtDabQzcu3Dz9pNKLeQjIZj8D0JN8OwsMrPTihq1O9Tr5BCyiL/yvFKg3KYQOiAj2+f+C6V69f2Jaw/89eDIp4VLRarbohHuI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--fOWoD/rtAfxeWV+w
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2025 at 03:41:18PM -0700, Cong Wang wrote:
> On Mon, Sep 22, 2025 at 7:28=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.=
com> wrote:
> >
> > On Sat, Sep 20, 2025 at 02:40:18PM -0700, Cong Wang wrote:
> > > On Fri, Sep 19, 2025 at 2:27=E2=80=AFPM Stefan Hajnoczi <stefanha@red=
hat.com> wrote:
> > > >
> > > > On Thu, Sep 18, 2025 at 03:25:59PM -0700, Cong Wang wrote:
> > > > > This patch series introduces multikernel architecture support, en=
abling
> > > > > multiple independent kernel instances to coexist and communicate =
on a
> > > > > single physical machine. Each kernel instance can run on dedicate=
d CPU
> > > > > cores while sharing the underlying hardware resources.
> > > > >
> > > > > The multikernel architecture provides several key benefits:
> > > > > - Improved fault isolation between different workloads
> > > > > - Enhanced security through kernel-level separation
> > > >
> > > > What level of isolation does this patch series provide? What stops
> > > > kernel A from accessing kernel B's memory pages, sending interrupts=
 to
> > > > its CPUs, etc?
> > >
> > > It is kernel-enforced isolation, therefore, the trust model here is s=
till
> > > based on kernel. Hence, a malicious kernel would be able to disrupt,
> > > as you described. With memory encryption and IPI filtering, I think
> > > that is solvable.
> >
> > I think solving this is key to the architecture, at least if fault
> > isolation and security are goals. A cooperative architecture where
> > nothing prevents kernels from interfering with each other simply doesn't
> > offer fault isolation or security.
>=20
> Kernel and kernel modules can be signed today, kexec also supports
> kernel signing via kexec_file_load(). It migrates at least untrusted
> kernels, although kernels can be still exploited via 0-day.

Kernel signing also doesn't protect against bugs in one kernel
interfering with another kernel.

> >
> > On CPU architectures that offer additional privilege modes it may be
> > possible to run a supervisor on every CPU to restrict access to
> > resources in the spawned kernel. Kernels would need to be modified to
> > call into the supervisor instead of accessing certain resources
> > directly.
> >
> > IOMMU and interrupt remapping control would need to be performed by the
> > supervisor to prevent spawned kernels from affecting each other.
>=20
> That's right, security vs performance. A lot of times we have to balance
> between these two. This is why Kata Container today runs a container
> inside a VM.
>=20
> This largely depends on what users could compromise, there is no single
> right answer here.
>=20
> For example, in a fully-controlled private cloud, security exploits are
> probably not even a concern. Sacrificing performance for a non-concern
> is not reasonable.
>=20
> >
> > This seems to be the price of fault isolation and security. It ends up
> > looking similar to a hypervisor, but maybe it wouldn't need to use
> > virtualization extensions, depending on the capabilities of the CPU
> > architecture.
>=20
> Two more points:
>=20
> 1) Security lockdown. Security lockdown transforms multikernel from
> "0-day means total compromise" to "0-day means single workload
> compromise with rapid recovery." This is still a significant improvement
> over containers where a single kernel 0-day compromises everything
> simultaneously.

I don't follow. My understanding is that multikernel currently does not
prevent spawned kernels from affecting each other, so a kernel 0-day in
multikernel still compromises everything?

>=20
> 2) Rapid kernel updates: A more practical way to eliminate 0-day
> exploits is to update kernel more frequently, today the major blocker
> is the downtime required by kernel reboot, which is what multikernel
> aims to resolve.

If kernel upgrades are the main use case for multikernel, then I guess
isolation is not necessary. Two kernels would only run side-by-side for
a limited period of time and they would have access to the same
workloads.

Stefan

>=20
> I hope this helps.
>=20
> Regards,
> Cong Wang
>=20

--fOWoD/rtAfxeWV+w
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmjS02kACgkQnKSrs4Gr
c8gaLgf+LttcrIImZ/l3um6RUl/4dYace1hoDwxQJPCPksRImb0wzZW4C3r/6W8V
dssJAEtVxaLcMnKlkA+usUipzCoHQqjOD6IVOe3gxnD28sSaIuE8v+RhftRbEMNI
ytTI1l4AHyPwWr2nQG+FQZm2hf7LQUd2uItfnOjIS/sSelm7eOHr1m8zXvYDy1zT
JXKNxZCk0PGTkYHCDZkmnZotwC/OEUD4htrk2s1V+xaGhXx8VS59XNacaileaplO
rRPGU2lU6vXA/TRhs+FvZqPGFj0gffZrc+5H/pHCPVeod8Drolcf0YO+9WQ+b+n5
SLcZ7lhWe6O/QynTmIpd89aXu+L0tA==
=KKCS
-----END PGP SIGNATURE-----

--fOWoD/rtAfxeWV+w--


