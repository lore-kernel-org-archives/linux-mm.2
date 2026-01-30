Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 760A7D73EA9
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 00:31:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6BFC26B0005; Thu, 29 Jan 2026 19:31:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 643046B008A; Thu, 29 Jan 2026 19:31:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F206B008C; Thu, 29 Jan 2026 19:31:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 429426B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 19:31:58 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C618F160429
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:31:57 +0000 (UTC)
X-FDA: 84386752674.06.6782793
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0BE0E40007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:31:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=eEaDTQq+;
	spf=pass (imf01.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769733116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5QTLnbHZvfOsZm6P1XTvKuZKL+X4Zqmm8W+hY1sTkg8=;
	b=yORi5zKoWcLMm+CJy9EX3MFvaxnD4idz91EmW4H/eN/qIFDBnOCps1X7a38KHEnRc8J0aN
	R6sL/u5Hot/l5JlJz0OjL8ynobO6hoIHhyqDIdeWnKIzPU6CWRBSodk0AT+GquLQyWwUXW
	77m39G9UA/hmkMiH+NKfmBLykJhaxLA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=eEaDTQq+;
	spf=pass (imf01.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769733116; a=rsa-sha256;
	cv=none;
	b=Heyclm6Yz+LFMpZr1MDJt8vqrNq4dTGobjKKzAhuwh/JJRT2PbvHRnjhnRuX5JtURJxANv
	vigOMJChDPR14/F49lglBe9bjh6m5mFOcs3t1rz8gdF5DXhUmRS/Trq6OmTg79dci1QwLp
	BFB2+/o7Wt0Bt4keukFuhOZiVEDg9pk=
Received: from localhost (unknown [52.148.140.42])
	by linux.microsoft.com (Postfix) with ESMTPSA id 02ED820B7167;
	Thu, 29 Jan 2026 16:31:52 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 02ED820B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1769733114;
	bh=5QTLnbHZvfOsZm6P1XTvKuZKL+X4Zqmm8W+hY1sTkg8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=eEaDTQq+Esr/RUhilvTOCceWy537iSweTVrOCQF87LN7ewfzzEyzyd4RUlTpzT2bW
	 kg7uIcbs9tYpacoilvpa5mW4vUKyQ+xSa6CjgGAzcB47rSlnza3XRXVmL0xeyblupb
	 26ODqz1MAroYBEfMeqzG7EalDwPpbFYk2tLsdDZs=
Date: Thu, 29 Jan 2026 16:31:50 -0800
From: Jacob Pan <jacob.pan@linux.microsoft.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran
 <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro
 <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, Bjorn
 Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, David Rientjes
 <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe
 <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke
 <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>,
 kexec@lists.infradead.org, kvm@vger.kernel.org, Leon Romanovsky
 <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, =?utf-8?Q?Mich?=
 =?utf-8?Q?a=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport
 <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta
 <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Thomas =?utf-8?Q?Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>,
 Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu
 <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260129163150.000059a2@linux.microsoft.com>
In-Reply-To: <aXvgKRrbfymW5NKb@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
	<20260129142158.00004cdc@linux.microsoft.com>
	<aXvgKRrbfymW5NKb@google.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9fhfaaurdkuobcat6qizfd9hrxmmkaqc
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0BE0E40007
X-HE-Tag: 1769733115-52442
X-HE-Meta: U2FsdGVkX18L/fkDRdJXfqU9YVw2jXlH1K6F1UBzE1vILWvP6qwN0g3CScH6R3/kaYD9rWn9IKoe7f7NT6yp0Tp4s11GXkLb9fFazoawWS51isJPLRCsWNA2thH6H/L1nWzxd3eTACiNmWvrBGNWYYh6370qxA2AZIWrgKqlkTYdKWjPRRpSsH1+kvmIPxQp81CndjzMXlUEDmMEdUiN1b9JC0MHHrTdIcrFvhk5VbQhQHuvmPM0D4/HTCXZh0B1BSqxJwl3udLM1B+YM9hbh/ujlywPRXCZCNQCNWxhdI8YBOkdktMtHEW24DlW4akWXxtTCEOgsG+eHqCWkFGh8Z5/s37UDfR3RtovSnQFNdHYS8gFbXxyPPl2DrYUlkBem3fVtUGDzaLRLeR8jzrdSsE5l5a+/8GBSlz89boIoVo1nr7UEDtoCY+hbkHfnRo0gVst67hOcLYwkLvQb+IOx7+ws/7u4iE7W6IvoBAOp9tY8WM+3f3k41NEyIPpmJY34ELG9ISv2ZKItO56UBVtJ5fDM3qhkcZMdAEvzwCILzLhZ7P7gA653fMb1OFzwj0ho6dAJMBbWmLO41r0UTbnaHJZKkw/dlDm2oXwzU5DrJDO163UxI9Y6JfRAz3HAMV7OmGRdYBUcQ5w1tQjCS40BdV5MMGc694GY0Vyow0h2CMC1UYLl2yewq8GSgexKnIMLhHWknbkuiF0VvlMjvAgfCtvUvQvWCS99mFLE1GIJVmJjVqhz9sugr5FBJnaiW3aYrBK8RiSFCA3mo8YW6zYWlBkXsfEJow9ty+RvWhpUYoVjtBl91l1OU90ArlayJ04v4iqKJG4pWEOvFTg9fOPg3aaniKAxje4791b3xYz7kwK7l5KeatgKxIDi+qbNA8NQ7ok9osu5qOqUeMsRuFw64M2SZx+rGkKS6UQsFeydVUz3zcSQl2SWfLWnjqf7Y9guRp5z7rPSTOE9hvGMrp
 pXwYSIuG
 But/wh0xAsIN2VvhM++o9+tmTo8B/dF1FQLiCOm1Q7Dttz2RxtL+Yxu7E8iDELD/nG12M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Thu, 29 Jan 2026 22:33:13 +0000
David Matlack <dmatlack@google.com> wrote:

> On 2026-01-29 02:21 PM, Jacob Pan wrote:
> > On Thu, 29 Jan 2026 21:24:57 +0000 David Matlack
> > <dmatlack@google.com> wrote: =20
>=20
> > > diff --git a/drivers/vfio/pci/vfio_pci_core.c
> > > b/drivers/vfio/pci/vfio_pci_core.c index
> > > b01b94d81e28..c9f73f597797 100644 ---
> > > a/drivers/vfio/pci/vfio_pci_core.c +++
> > > b/drivers/vfio/pci/vfio_pci_core.c @@ -515,12 +515,24 @@ int
> > > vfio_pci_core_enable(struct vfio_pci_core_device *vdev) if (ret)
> > >  		goto out_power;
> > > =20
> > > -	/* If reset fails because of the device lock, fail this
> > > path entirely */
> > > -	ret =3D pci_try_reset_function(pdev);
> > > -	if (ret =3D=3D -EAGAIN)
> > > -		goto out_disable_device;
> > > +	if (vdev->liveupdate_incoming_state) {
> > > +		/*
> > > +		 * This device was preserved by the previous
> > > kernel across a
> > > +		 * Live Update, so it does not need to be reset.
> > > +		 */
> > > +		vdev->reset_works =3D
> > > vdev->liveupdate_incoming_state->reset_works; =20
> >
> > Just wondering what happened to skipping the bus master clearing. I
> > understand this version does not preserve the device itself yet; I=E2=
=80=99m
> > just curious whether there were specific difficulties that led to
> > dropping the earlier patch which skipped clearing bus master. =20
>=20
> Hi Jacob,
>=20
> There's several places where bus master gets cleared that we need to
> eventually eliminate to fully preserve the device.
>=20
>  1. vfio_pci_liveupdate_freeze() clears it during shutdown when it
>     restores vdev->pci_saved_state.
>  2. pci_device_shutdown() clears it during shutdown.
>  3. vfio_pci_core_enable() clears it when the preserved device file
>     is bound to an iommufd after the Live Update (in
>     vfio_pci_core_enable()).
>=20
> I think it would be safe to skip (3) in this series, since that's very
> similar to how this series skips resets during vfio_pci_core_enable()
> for preserved devices.
>=20
> But I don't think it would be safe to skip (1) or (2) until the
> attached iommufd is fully preserved.
>=20
> If you are just asking about (3) then I agree it could be skipped and
> I can include that in the next version.

I was just asking about (3) and trying to understand the asymmetric
handling compared to reset. I don=E2=80=99t have a strong preference since =
this
is temporary=E2=80=94thanks for the explanation.

I=E2=80=99ve been testing my noiommu cdev patches on top of yours, and so f=
ar
they behave the same as with a real IOMMU. As you noted, however, final
device preservation still depends on iommufd.


