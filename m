Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29896CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 19:03:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AE6A8E000E; Wed, 24 Sep 2025 15:03:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484A28E0001; Wed, 24 Sep 2025 15:03:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C1018E000E; Wed, 24 Sep 2025 15:03:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2DE738E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:03:27 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C2878160168
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:03:26 +0000 (UTC)
X-FDA: 83925067212.18.9624906
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id DBDAE180006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 19:03:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gBIlxJ10;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of stefanha@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758740605; a=rsa-sha256;
	cv=none;
	b=lw1ECeWQoVEzFFh04nSFhhMlTDtg7YCsa2aS+x9L8v1s+y4j2AvAhOGV9K8WMv5yEvU17c
	HlOnRl7NmeMbs3qHyzpKCQyayC28dJ4iPzsVJpN/+4wm7HaLndrJsCV/WF32btGlQtDsjD
	vXZPexDm3QjQhVlb+ZdB5giGju82Iok=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gBIlxJ10;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of stefanha@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758740605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=svtYRVGVOWiQOwGeQLqrRvGYBYlTxeSGi1nAMXidbZw=;
	b=7Qi6//eXQKoGQ1y7zdEvhaH3ZfiquFXbz0eAMmvkRdiqSooevKPLYc72TMrlWJiBkrHDoD
	MJlZ8WhGEwXcahJGvoQc4w7MrhTglRqBhknBpeAx7ccP54/jkIXSHHfwGgwak1q0CZXux+
	6gXjklGO2iCotgtfxtBwdGDvowVt7Do=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758740604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=svtYRVGVOWiQOwGeQLqrRvGYBYlTxeSGi1nAMXidbZw=;
	b=gBIlxJ100chrgopChZ9bgpWzhZegHp5JIpAu7nArVCixWzKEfrtD8xs8TGF+qs8p9AV8lv
	OwnJOOz+txFHz8LRNH7qnDRAeIWJsR0M/p1zvU4zPGPNkUV+2tcLAFiWIy7BnLgkLTeAUK
	p9uuP+5hqlEsUh+CMkdo57mMiC3nsus=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-634-q4nOE_dQORmW9pfmQoS9GA-1; Wed,
 24 Sep 2025 15:03:20 -0400
X-MC-Unique: q4nOE_dQORmW9pfmQoS9GA-1
X-Mimecast-MFC-AGG-ID: q4nOE_dQORmW9pfmQoS9GA_1758740599
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 83EBC1800357;
	Wed, 24 Sep 2025 19:03:18 +0000 (UTC)
Received: from localhost (unknown [10.2.16.176])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 931C9300018D;
	Wed, 24 Sep 2025 19:03:17 +0000 (UTC)
Date: Wed, 24 Sep 2025 15:03:16 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com, Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, multikernel@lists.linux.dev
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <20250924190316.GA8709@fedora>
References: <20250918222607.186488-1-xiyou.wangcong@gmail.com>
 <20250919212650.GA275426@fedora>
 <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
 <20250922142831.GA351870@fedora>
 <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
 <20250923170545.GA509965@fedora>
 <3b1a1b17-9a93-47c6-99a1-43639cd05cbf@redhat.com>
 <20250924125101.GA562097@fedora>
 <CAM_iQpWRZ-vihMEa=k-j9EYN9itUeZLhZ14AoCvZ9mturFxAyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="io8Dp1r+z0FFF6O3"
Content-Disposition: inline
In-Reply-To: <CAM_iQpWRZ-vihMEa=k-j9EYN9itUeZLhZ14AoCvZ9mturFxAyw@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DBDAE180006
X-Stat-Signature: rbin55r84s99jh79omwcojm75n6ec5rw
X-Rspam-User: 
X-HE-Tag: 1758740604-143920
X-HE-Meta: U2FsdGVkX18dwGm2f3HuRnZD7RrR3LkwyHHtwxQxrJsAnWrShGzG6Cjcxpul2PHv8RnPrKHc+qD6/sBW4JBRt6LIKB38V7idzXtTZa1nQgeSge1JXifC+o43cy+BK8KNh3Hgg9yXfDPZaXN7ixndjtPIXIKbV7+UnROcJxc+oASno4lAFfNcZj4iBFHTcTo8Ox3lcjfSelQ71oJyC6/4zk2qVGAYToV/LJxuprEgOWPy60HqMxe8q860GVLeyKYaf5ZEIAB8OYRUxlzFBxDFGulVPY/EU720OfgVz2vWs3P7PyylYVzFxAbyktu/cpCQKrdAfHX7HHonynj85ElWQi7WEuKCQSebBA9OHVRK5jPK5JhENiCBWPF2zhU63O2KBtfKFkAiu7QFNA6B7DkwT8D6cdI547fX1A1N4QQKnLPKIenI6+qRxjeQL9VilcCXGuSlg8N7f2ErTF4IAKxglO5hwfeP+ARxh0sK1cGXRk9KxlKpRLzAPsN7xMgSmOTXYqIMw1ZyXd1SCir0mJurCrlRvTZ+7BMsB5tVM80zDb4PvLuimnU5kGlvBFzAfaea++wjYDvWAIK2L/yCjwgFFCQ3oTMggklKAceMGW7PWrGIisVtYAyYR0iYLDW/Rnt3lsfFATuf94xzrAJ/eC2vcX0dOpiUICUrDGtZjTNF8IWLyk+pdfeJVJn4x2PN44HsUhFe5An36Wbk3Y3XXbUOUphwdh3GsOtjtCDdDTbgqRG0Ke2hEKY+l8rufGiAKdiQBk6mlGMk1bst0D7VN5g/LZqHEgufiKj8IPtC9X73CagcxkJZQ6O2FWi6WFItO36mI7TvQ4Ps55QuoQPwm5pR2OwWEu8XZjZSzpf/DXYwhEv75xtMhS1TF86YcBCExdC5PUCA/atKwpN//v6mEW9YCXeEZtxe2iG7Nm0cwmEFR+jem90ZiaVCLkh7M3RW76fSpzOK5pdWTZh4rsidpww
 OoR0MQYF
 aVsnpirlZOz2oTQkmiB38UlbbYMQ0yCfnf5hsESYMFPlo0jt0ul2rHAKvtY2VXTdBEzVsTobhHBr0u7m5ixYXr96yaJRcxiiicLbwo2JDwljdkD3WC94Ng7WuZs9wRd2cU1al7bImXOuqOY3xUXogLhO2fhz/bGuwMqqF/ue4Bo1HlopbRaBzj5h1HMLGcrjC+RRakDCaeYfFmyqVXl96jaTF9NEDVwDqCliJRfIlIk3UQW+Vp3kWFM9nbxoZA5nxdkg8Q1A1At7uZh6h5I4QfU37ahWADAqSVwNbPBZjkSrK4ZkMBQkRTRtu0jazHJDg1dczfHsFW66UqLs1HKpgRI12AZum/h+0iEv9AoDbooM8ZOT3ddM5ZV7DFd0+OWeASah1vgZh2hLvh5fbh5482xDCoSPCPHaqOYTI8GMlkczHwyoTglkGvcFd7pdzH7jIWCE+lhMOJFpZw55rMPFwhnWSpm1O5imDyrzLRGamDY6iy02oZ4vT8u/BZ0w+Ar4j9aHsmFBERwW7vblEEQJkJFpGBXNMfkkCD82osez8gLw2J7Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--io8Dp1r+z0FFF6O3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2025 at 11:28:04AM -0700, Cong Wang wrote:
> On Wed, Sep 24, 2025 at 5:51=E2=80=AFAM Stefan Hajnoczi <stefanha@redhat.=
com> wrote:
> >
> > On Wed, Sep 24, 2025 at 01:38:31PM +0200, David Hildenbrand wrote:
> > > > >
> > > > > Two more points:
> > > > >
> > > > > 1) Security lockdown. Security lockdown transforms multikernel fr=
om
> > > > > "0-day means total compromise" to "0-day means single workload
> > > > > compromise with rapid recovery." This is still a significant impr=
ovement
> > > > > over containers where a single kernel 0-day compromises everything
> > > > > simultaneously.
> > > >
> > > > I don't follow. My understanding is that multikernel currently does=
 not
> > > > prevent spawned kernels from affecting each other, so a kernel 0-da=
y in
> > > > multikernel still compromises everything?
> > >
> > > I would assume that if there is no enforced isolation by the hardware=
 (e.g.,
> > > virtualization, including partitioning hypervisors like jailhouse, pk=
vm etc)
> > > nothing would stop a kernel A to access memory assigned to kernel B.
> > >
> > > And of course, memory is just one of the resources that would not be
> > > properly isolated.
> > >
> > > Not sure if encrypting memory per kernel would really allow to not le=
t other
> > > kernels still damage such kernels.
> > >
> > > Also, what stops a kernel to just reboot the whole machine? Happy to =
learn
> > > how that will be handled such that there is proper isolation.
> >
> > The reason I've been asking about the fault isolation and security
> > statements in the cover letter is because it's unclear:
> > 1. What is implemented today in multikernel.
> > 2. What is on the roadmap for multikernel.
> > 3. What is out of scope for multikernel.
> >
> > Cong: Can you clarify this? If the answer is that fault isolation and
> > security are out of scope, then this discussion can be skipped.
>=20
> It is my pleasure. The email is too narrow, therefore I wrote a
> complete document for you:
> https://docs.google.com/document/d/1yneO6O6C_z0Lh3A2QyT8XsH7ZrQ7-naGQT-rp=
djWa_g/edit?usp=3Dsharing
>=20
> I hope it answers all of the above questions and provides a clear
> big picture. If not, please let me know.
>=20
> (If you need edit permission for the above document, please just
> request, I will approve.)

Thanks, that gives a nice overview!

I/O Resource Allocation part will be interesting. Restructuring existing
device drivers to allow spawned kernels to use specific hardware queues
could be a lot of work and very device-specific. I guess a small set of
devices can be supported initially and then it can grow over time.

This also reminds me of VFIO/mdev devices, which would be another
solution to the same problem, but equally device-specific and also a lot
of work to implement the devices that spawned kernels see.

Anyway, I look forward to seeing how this develops.

Stefan

--io8Dp1r+z0FFF6O3
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmjUQHQACgkQnKSrs4Gr
c8g6GQf/dmqLH7btBgBhJhQSXIXjdWf+M92gUSUpXzizVaSB2xUrl68p4xZlWEzc
7ijpcKjxMVVGeUgLU7ziduh4sS/Pu/GclMmyTU17mrlVCZjbJsxwz4NmcbWJbvjl
sne3cnef4ov/U/AOPKpTLWHdNMLVvtCltuc+bZ7uS2Zeae7u0ZLWUgZUllddDu2y
OjZBAa4PxbDLrBvm5btURx7kzh4t3bP4TAcKC4GkEngI47jyl5E4XTEWYpFUSEEF
PrlgE+22skiH038nIpmPvHvQhfeM52npehlqBajdFjgmpTMOeNjDNTR0mM+b8+nr
UtE9Nt0gu32myYQUKVwt+vAfC7hNBw==
=9wqm
-----END PGP SIGNATURE-----

--io8Dp1r+z0FFF6O3--


