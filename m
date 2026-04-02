Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D26ED39420
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 13:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A16A6B0088; Thu,  2 Apr 2026 09:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952536B0089; Thu,  2 Apr 2026 09:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8682D6B008A; Thu,  2 Apr 2026 09:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75EBE6B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 09:12:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99948BA7FC
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:12:05 +0000 (UTC)
X-FDA: 84613653810.21.BB71A19
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id B128918000E
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 13:12:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WSszUspE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775135523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a7x/ysTtVW24aU35eMPirkt+sO+v8dpDAEKDhxuDe60=;
	b=BiPnozBFOyYNGMyV7M2mVQb/SzIEUBcm10gxhxtPk+XxfPJP4m9xR51aNGzsH49SK/Y/sO
	v6HsRMYhVmKnw0T3kDiceAMnEjZBsML/SkCoNTZ27zhyyQ7TdIiNJ7aX7mu5Fc+7EKzA/n
	BbGdXu1yuz3rbFcvqD02yWoU0LVNksU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775135523; a=rsa-sha256;
	cv=none;
	b=H6JVafb94iHBQ8vaLfeShrIuT3jqCglcSDS4h3qlIrr7Eb/sIYSZxwyV9FHHqKu+CKOnxV
	2YeoNk/g2mcPT+6XHSAYD4zEcC4Ob7U0QVce3MkJ+ggsEDKmJWlnt+FCqpxLRBd4je+42T
	UNmhoA4JFLkq73jkMsDBQEv/rWNtgt4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WSszUspE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of mripard@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mripard@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 970D843F07;
	Thu,  2 Apr 2026 13:12:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2097EC116C6;
	Thu,  2 Apr 2026 13:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775135522;
	bh=a7x/ysTtVW24aU35eMPirkt+sO+v8dpDAEKDhxuDe60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WSszUspE9dzXyP1vG2gMcdzvhWi9nAi5ipcnGtuyZonB7RZAGmX1hwDPduMtfEj0f
	 lW2LoRIl2ShIjcyVDeuG1hlvOO/zqpCeA0Z146DRKKA0duBquAvj+fJQT/uscVbkZe
	 2wg5nQmX87424MYUc//sb0M9cOh0Ho+XSCi8NXobJRbr+fliundDiCPi1S/NRwsAeC
	 kc4nITLm01qhH8H8Sxex1i7X4/hTzJrnBqisiAgNMciIgTmVqODXmYgxMjwhE4MTBg
	 w18ZXyGoeIRDg6/g/t6PcP82CKsFc0A1CC7A5a4HCiyOTIneD54u7brrQ1GJ5SK+vp
	 +XGiv48Yu5boA==
Date: Thu, 2 Apr 2026 15:11:59 +0200
From: Maxime Ripard <mripard@kernel.org>
To: Sumit Semwal <sumit.semwal@linaro.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Albert Esteve <aesteve@redhat.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, iommu@lists.linux.dev, 
	linux-mm@kvack.org
Subject: Re: [PATCH v4 0/8] dma-buf: heaps: Turn heaps into modules
Message-ID: <20260402-burrowing-fine-bloodhound-afcebc@houat>
References: <CGME20260331100026eucas1p19bdc2aaca4c9a48c6f6ac8fec71478d8@eucas1p1.samsung.com>
 <20260331-dma-buf-heaps-as-modules-v4-0-e18fda504419@kernel.org>
 <46397de2-eedf-4e09-a83a-3b683d154fe7@samsung.com>
 <CAO_48GEFQE_FJjuq1UqP=DC6LJE8jjE3C+4FdAyB4uEZDsnFJw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="me4gicdwmutl43x6"
Content-Disposition: inline
In-Reply-To: <CAO_48GEFQE_FJjuq1UqP=DC6LJE8jjE3C+4FdAyB4uEZDsnFJw@mail.gmail.com>
X-Rspamd-Queue-Id: B128918000E
X-Stat-Signature: 7hpjkmfo9apubkb1mtpa6ykrgagp3qzo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775135523-998939
X-HE-Meta: U2FsdGVkX18TfEOPEw+41FwMDIG4vn/JCPkgiHF6/PaR50tBxEa6myVGW70uOPZE+8bJXQNeF5PxERb3oQ1Su2IGlm0sXzObmo2YJrbieEU0Eapt3T62Pz6tptygJ4Cda9zYRUw/HyhW7dbpInxtQtWMAE62fY7FPD8Hvhrf5hyfjD77uBZktTYFnfPFtLkOCy3ao5OO2RbBcoonh7j2HAJ+nB1ahIISvttvg1k9LnnxmhekMSw/1+3RJDq6tgDjLT6xbqvVO6YdjsniTFXPfhqdzhETVDHsySfsoAV4vjbWmaa8NCkUzoHvsLg75jHERMM2W13LHOHp/v5WgVrnyaMMMDjuViHSwweG7SMLJmIaqys+pAQrMvqKJKndL5mrSGuo69YkU1h9ui4ACIm10+Es7LQY2yC+zkRPbuVMmD0qblEDkAcD1qbR9ASxF1MAiq4A3J4dA2CejP9CBsj4GmO2OFnFbcLLYClg96tYVkQW9tRHb/aKXeE2OsmRMPGOHwkIoLYPCeyQqjoPW0MvbxoQ9dpA0kgevtjRIEherhf/Z/H70Qs21Vpvp02PMT9Lfg50RXWKFKS9c5Fb8neTSA4hBz+VWpkI9ePRx+VqFiykazemDCSwHDg1ey95/GeY8pcE++sNr5QvHWyc991RpA6BhFu3IOFADhkOk0Ih/WpF3f04hOBXfVq62ZlSFNCLKotgvNXE+c9zKPA/guzjtJX4fDRpSa7xg9SWbRMkRQ9OsozarNEagL5iHd+ZM7JHK6PhyydNswakKnDgfYvYLDzfpLsMja7crYyLOh5powZtDtjDzSJ63sUvjuqm5ML0/FS6gwYDoDMaBM0ZdCbyBBodpseb81k4sHnctna/C9Dv9ugMlYcjKzwoVfTo1aD8b3oI8Px63vJ73ONdRuTYFCb3KAbLdPjtRTZvA7uMcTJWmgQVw2e0oN5csiSy5Lrh5joI6wqAF9Zm5/Yr5ng
 wRgGSMiz
 LTHBPZ7dBKLrWpOJbwCcpLdxTYCjBobSL2hOoQvmc66Eo8+R68qnP46Ax7IK4+VNhjQOEGa/3yjoe0C3gYR+F9ae7UVufoeKtrB1JiIguV7O9bKK3W6MXkFY9AubQc0P25gbejWykI9mXuTfX1W+rlYSxdHnoJBdLXo9hMU/uIg4wnG8zQZBN3tok0Rcs9AHLwYWGS9cJSXiUjIhwGtVD11lN+E10g6IyKSK1dLT82/oZGPTEN3RNUirWZj7MSWjbJFQWXwxXTUkz7bjMe8mR6p6j0OvOUC3YHHnK7fBXjIMK6t2yor4XTOUhYMGWLmC9MXuWZ4ybxf5V2C45R6BWCxqd7tR+fBLKpiilJjt5JqNQLrBKHcmafkLZyjbGAdefwJXv9JKdkCnzx9dxHZoOwIVhdjaM0SHLTcqWF76rAvisjSfOjSsL8xN18oioL7f6gEp9IyZKPeoe5gA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--me4gicdwmutl43x6
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v4 0/8] dma-buf: heaps: Turn heaps into modules
MIME-Version: 1.0

On Thu, Apr 02, 2026 at 10:36:48AM +0530, Sumit Semwal wrote:
> Hello Maxime,
>=20
> On Tue, 31 Mar 2026 at 18:24, Marek Szyprowski <m.szyprowski@samsung.com>=
 wrote:
> >
> > On 31.03.2026 12:00, Maxime Ripard wrote:
> > > The recent introduction of heaps in the optee driver [1] made possible
> > > the creation of heaps as modules.
> > >
> > > It's generally a good idea if possible, including for the already
> > > existing system and CMA heaps.
> > >
> > > The system one is pretty trivial, the CMA one is a bit more involved,
> > > especially since we have a call from kernel/dma/contiguous.c to the C=
MA
> > > heap code. This was solved by turning the logic around and making the
> > > CMA heap call into the contiguous DMA code.
> > >
> > > Let me know what you think,
> > > Maxime
> > >
> > > 1: https://lore.kernel.org/dri-devel/20250911135007.1275833-4-jens.wi=
klander@linaro.org/
> > >
> > > Signed-off-by: Maxime Ripard <mripard@kernel.org>
>=20
> Thank you for this patch series; now that it is needed by more folks,
> I think we can merge this.
>=20
> Marek, I'll coordinate with you on this - thank you!

If Marek plans on sending it during the next merge window, maybe the
best thing to do for us is just to wait for -rc1 and apply the rest of
the patches. Otherwise, we can merge the branch in drm-misc.

Maxime

--me4gicdwmutl43x6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCac5rGAAKCRAnX84Zoj2+
drvAAX9Gv+TrbX5Ru5iTuTfrjby3dUGZF6Vd9/L4HY+x15swwQBj44P2X43WwAnM
cMhPq+8Bf00cagtlOIBhV4Hse29yKk8z2Is7iRaewRIPe/yQho7wdJK8x1cnDkbD
NQuA+jE9OQ==
=+ZbZ
-----END PGP SIGNATURE-----

--me4gicdwmutl43x6--

