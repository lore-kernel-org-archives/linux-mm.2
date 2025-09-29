Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08998CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 15:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36C368E0006; Mon, 29 Sep 2025 11:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3421C8E0002; Mon, 29 Sep 2025 11:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 231368E0006; Mon, 29 Sep 2025 11:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0C14B8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 11:12:01 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B532D58D05
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:12:00 +0000 (UTC)
X-FDA: 83942628000.25.B30A668
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id D68CE80009
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 15:11:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y00RwKTk;
	spf=pass (imf02.hostedemail.com: domain of stefanha@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759158719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wUxjCdJ+LBOQczVnd2iMYVQAKgwjCqV4hUPHBbCXanQ=;
	b=QpJRJRmj/UxZMTgl8NTsq5M9qmiJ9KemnrQ1bew6oj3eqhe9GYLV68HWju+4XJ7OEMKudZ
	yF0pHHCLEqq9lOc2+7WetGkesrV0uCgJqLn9oWhv6JSR7QNgXrDCqd5gXQSk+n3YOIUgqo
	Wz87Jd7h1z7zEAb7KIaOvqbwaU0rza0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759158719; a=rsa-sha256;
	cv=none;
	b=eDLf5KN2H4iUYvME7IrEWrl1AOnjh7OjOvdjvr4XcDKTrrjk4lv2LVJN/GAYSOcr0p8Ktu
	6q7E5Im1TzAfNq3ZzDTtjQAN8DB1Bzijzf7Is8kOuzVANQlOgJ4hrp+P+thT1+S/oCOiut
	fbdySBH2PkR0liQSzvuXxG4XuArCAXc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y00RwKTk;
	spf=pass (imf02.hostedemail.com: domain of stefanha@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=stefanha@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759158718;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wUxjCdJ+LBOQczVnd2iMYVQAKgwjCqV4hUPHBbCXanQ=;
	b=Y00RwKTkmPfXKLJ92VwM/IfU+xqwlH2V4eIB8wT9hwFaAwcqAvWJAmIMg6voxRCglPdvUQ
	8y7LSU2JCp6W0h2nFYE3aqxgbaLZnvma4manJ2MMd00Habhi/fCSMwLFr4/+IAHRnN2JwA
	C/OlkQfnEefJELD8ZEG7zUFwLNFbrUk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-2ba4FcJWPCCwlvOIPJH7zQ-1; Mon,
 29 Sep 2025 11:11:54 -0400
X-MC-Unique: 2ba4FcJWPCCwlvOIPJH7zQ-1
X-Mimecast-MFC-AGG-ID: 2ba4FcJWPCCwlvOIPJH7zQ_1759158713
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7AC28195609F;
	Mon, 29 Sep 2025 15:11:52 +0000 (UTC)
Received: from localhost (unknown [10.2.16.88])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 0B25B195608E;
	Mon, 29 Sep 2025 15:11:50 +0000 (UTC)
Date: Mon, 29 Sep 2025 11:11:49 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
	pasha.tatashin@soleen.com, Cong Wang <cwang@multikernel.io>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Alexander Graf <graf@amazon.com>,
	Mike Rapoport <rppt@kernel.org>,
	Changyuan Lyu <changyuanl@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, multikernel@lists.linux.dev,
	jasowang@redhat.com
Subject: Re: [RFC Patch 0/7] kernel: Introduce multikernel architecture
 support
Message-ID: <20250929151149.GB81824@fedora>
References: <20250919212650.GA275426@fedora>
 <CAM_iQpXnHr7WC6VN3WB-+=CZGF5pyfo9y9D4MCc_Wwgp29hBrw@mail.gmail.com>
 <20250922142831.GA351870@fedora>
 <CAM_iQpWO71vSV_0qXiUYeKYZMYF0xWNz8MrUVRkqKwDEtQvKqA@mail.gmail.com>
 <20250923170545.GA509965@fedora>
 <3b1a1b17-9a93-47c6-99a1-43639cd05cbf@redhat.com>
 <20250924125101.GA562097@fedora>
 <CAM_iQpWRZ-vihMEa=k-j9EYN9itUeZLhZ14AoCvZ9mturFxAyw@mail.gmail.com>
 <20250924190316.GA8709@fedora>
 <CAM_iQpXnvyZWrv4W45SBTDV-tCXU4Fz1=S8z_0s5en+U29vSZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="yMiB+Rg43ijt+EVK"
Content-Disposition: inline
In-Reply-To: <CAM_iQpXnvyZWrv4W45SBTDV-tCXU4Fz1=S8z_0s5en+U29vSZQ@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D68CE80009
X-Stat-Signature: ierc1hb97yyopc7zjr93wz4puninh1jp
X-Rspam-User: 
X-HE-Tag: 1759158718-112691
X-HE-Meta: U2FsdGVkX1+e2vTrcGxMKNt1Jgw29SZN/oHmqsN4MHgGv73DmZTqLxD/PHOxCEeYR8CXJxhQQi9glqoDl4QolueFu0jqfhlDBosVfd3yJ2U/Y0BY8ef72TELyh2DKB3ZLlRfXEUr5d3f+5BVQY/YBFalVwmq2mr94KbEDlyvLJjv47BIcf+AAzZn8coazDISgoMvosXs3DjH2/Km9qKUTHqEmTIHA7urMNdwJeNmqh0zb2gRfnbcXtupnYMCYQcWY5h4nYfWzxNZfDF/5vi2IkmGQ5XZ9Qct+qqk7uIBizG6I4A410Ovp9z2KKepaZkwxCNSlXotw2ZRz4XoRcs/ixqqTgzovqFW+PpNiGJZIrROdohEnww3hWu9fjJdacIpvTgCd/UkoZOya7ZA6HbBgyT9qVo/iT7hEixJA3yc8d3wDvMPuh1mmzzwr6jRqHyEuAWqxJYqpOq1BcqNQGFx05sYTmhKaLARmUXHsu0y/9oHArCIljie6Ff5wZ5eTvaonXR2aCFFZ6AbuUVQzl/IC1g4sLv8SzSwn6/XzyhbHofqlvICowAm8tQRfQy9BOzqNQNMMnt1oJzMGhfXwCJfSOp51656h1/SbfSA1BZmNtuTIDjnlYGj4BJVWIP0k8sQgeCMV3wYpZv1R317aICWd6FkYuoHRtlA2jI1naabS7yNcahB4Vj+CWyYh9N6RdEJShPqhM5DZ+ZWOhF+WmNI/dE/048iw/JjcluPrGCjdbhXDWS4s9Dhqn94tguei12a0dCiZBBtz4VudpyVVtsiSURC1GQNTXl/Um3zBdwBN6PKg1yzqm3+bcu/8x506OWhYc0MJMA8u+lMY50K2R18mcukWRq5IIH5pdszkAdbyJDxbdbElkNC52q3C2XB2Ks7d532LBaWnZjPJvp96YQPxY2ezS9zgIS8ruBMNeP6ARnocEN+8SeC6GllqGfyxm8u5mQRhgeSNhmy98HDvSS
 e8hCDREh
 zYzzm+6gcgPgJDSAqL5IckKpWqx3UbYsAm+J5+zKAm5+DxxE+G2HVldkH8U3tefsL7sE/lLCpr/cDYHGFr7dXvZwF+dQLzcP4ny4dlMUHQSdc9YbYAM6FqWnA1I9Qnpa5+oU8TxQOLeQrar+IUH6sIxG9wt9cSaXFm9IfXFShY+tkCI0JISuJMQGlGG4K8KRD0N5MHmEwmrCgArttQiGiKSpxb0vbzhJw5+6Z8Ou3/hmEdbDx9LWeCA5+1av/44xbRgHB78G1ua2kX83Q+GBYrtCAAffDz35XBrozk7anSTtrWZHavaDU0DM4KczVtbP9n91hyESy/LnHxjckPI9meVV7k24GkGN7U63cUh289Z6TcXbxDIICZMlvdK8K11DHk9Vlb+0CDLyCH93W4XZG0UyZbEobKYljF8oy/YCVTqzLrFz2OTDSW+G30wLwQkfKtDsq52N4XX7cf18vCC6akDYffsJ1xqTPTU7J/FCKLLXJXQPnkdrkCwvNDF/8FbomfYew2adKV2WxH+8DLQW8aGsvhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--yMiB+Rg43ijt+EVK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 27, 2025 at 12:42:23PM -0700, Cong Wang wrote:
> On Wed, Sep 24, 2025 at 12:03=E2=80=AFPM Stefan Hajnoczi <stefanha@redhat=
=2Ecom> wrote:
> >
> > Thanks, that gives a nice overview!
> >
> > I/O Resource Allocation part will be interesting. Restructuring existing
> > device drivers to allow spawned kernels to use specific hardware queues
> > could be a lot of work and very device-specific. I guess a small set of
> > devices can be supported initially and then it can grow over time.
>=20
> My idea is to leverage existing technologies like XDP, which
> offers huge benefits here:
>=20
> 1) It is based on shared memory (although it is virtual)
>=20
> 2) Its API's are user-space API's, which is even stronger for
> kernel-to-kernel sharing, this possibly avoids re-inventing
> another protocol.
>=20
> 3) It provides eBPF.
>=20
> 4) The spawned kernel does not require any hardware knowledge,
> just pure XDP-ringbuffer-based software logic.
>=20
> But it also has limitations:
>=20
> 1) xdp_md is too specific for networking, extending it to storage
> could be very challenging. But we could introduce a SDP for
> storage to just mimic XDP.
>=20
> 2) Regardless, we need a doorbell anyway. IPI is handy, but
> I hope we could have an even lighter one. Or more ideally,
> redirecting the hardware queue IRQ into each target CPU.

I see. I was thinking that spawned kernels would talk directly to the
hardware. Your idea of using a software interface is less invasive but
has an overhead similar to paravirtualized devices.

A software approach that supports a wider range of devices is
virtio_vdpa (drivers/vdpa/). The current virtio_vdpa implementation
assumes that the device is located in the same kernel. A
kernel-to-kernel bridge would be needed so that the spawned kernel
forwards the vDPA operations to the other kernel. The other kernel
provides the virtio-net, virtio-blk, etc device functionality by passing
requests to a netdev, blkdev, etc.

There are in-kernel simulator devices for virtio-net and virtio-blk in
drivers/vdpa/vdpa_sim/ which can be used as a starting point. These
devices are just for testing and would need to be fleshed out to become
useful for real workloads.

I have CCed Jason Wang, who maintains vDPA, in case you want to discuss
it more.

>=20
> >
> > This also reminds me of VFIO/mdev devices, which would be another
> > solution to the same problem, but equally device-specific and also a lot
> > of work to implement the devices that spawned kernels see.
>=20
> Right.
>=20
> I prototyped VFIO on my side with AI, but failed with its complex PCI
> interface. And the spawn kernel still requires hardware knowledge
> to interpret PCI BAR etc..

Yeah, it's complex and invasive. :/

Stefan

--yMiB+Rg43ijt+EVK
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmjaobUACgkQnKSrs4Gr
c8ipuwf+KotYqejI+vt5pti8fHvl4phnkHcS2tYcg/IHT1cO0y5ha7uvltnia9/N
uSJ88YcQ/Fo2pkLyiIZYVAH7jqJIWJ5GI61pAwiTDiXi+EDoao4EpqD3MC+GHBQ9
ZD444E59MYSKts6yCIHC6gpcXSU12Z9uPvQgQLRDQ3cStlAJC33HRmBFptZNt2rD
8/2/c35N16qbMo3a7O/Owe3/2fJkQFEHp+3znyf8U3obn0b8Cutec++rA4e4UAQR
PuaVm3iBeSDJRjXZvJMXlDBrBYma0mOhsUkJBdcs/8D1ncAs1v+0kBK1UbA2JgQv
vjv+rLhgtSOCuUALtpAqfw53quM2OQ==
=y4ib
-----END PGP SIGNATURE-----

--yMiB+Rg43ijt+EVK--


