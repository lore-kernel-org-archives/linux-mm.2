Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CCF51090255
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:39:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7006F6B0555; Thu, 19 Mar 2026 12:39:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8726B0556; Thu, 19 Mar 2026 12:39:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EE596B0557; Thu, 19 Mar 2026 12:39:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4971D6B0555
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:39:38 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED55F1401D5
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:39:37 +0000 (UTC)
X-FDA: 84563373594.23.6AD9E15
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id 061EE1C0004
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:39:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bmMuGENd;
	spf=pass (imf20.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773938376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8r3Rrhjz62mzvDnQKQk9Pz54iwWA+pJBFG61+YWArBw=;
	b=ataJ01C0xDzH0SKQ6EsHNzb9IoA65zgoXGYiXht7890t8DO84yfWmR4MR0AtC84ImB0BtI
	6QJh7UIBBAY8ntUebQhmnvAZBV51j+MYFye9JVbi9juKxnY0g0G04lnFpBE53scwgnTz3x
	xAMm7P9I+TnmZbRNOwxgjZjb1hvAsrQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.microsoft.com header.s=default header.b=bmMuGENd;
	spf=pass (imf20.hostedemail.com: domain of jacob.pan@linux.microsoft.com designates 13.77.154.182 as permitted sender) smtp.mailfrom=jacob.pan@linux.microsoft.com;
	dmarc=pass (policy=none) header.from=linux.microsoft.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773938376; a=rsa-sha256;
	cv=none;
	b=pVv2IjcLC08EL5zgQjUBQjY94Bq4NaiKZTFmSEYDRYsTphksV13+fIYmpGnXqr1HkUIJTK
	JOMwKK88iq8r1XnSW3TQfZ2TNMv4b/++saqL8sZsabxdFkqZRR2EDz6b2iYjJylnbJOyCm
	ex6/m4TYL4ypbMna6L/LyfPKTluwZvA=
Received: from localhost (unknown [52.148.171.5])
	by linux.microsoft.com (Postfix) with ESMTPSA id 744CF20B710C;
	Thu, 19 Mar 2026 09:39:33 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 744CF20B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1773938375;
	bh=8r3Rrhjz62mzvDnQKQk9Pz54iwWA+pJBFG61+YWArBw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bmMuGENdC7hPcV8u5wKM+LeF+mgtVIFSJy2h9p6W0i9+tl+Hp7PwExVnUfQO1xHwB
	 Ouf5VcCqaSQUs5qKCHuxTDWMmMZ137/dgQcmFiu/HC6R4d58LdmNNYeQegg7/tAA4c
	 QVfQmqGCCPaKOdhfIjpxs7czL0tSUxWhHGO5GW4k=
Date: Thu, 19 Mar 2026 09:39:32 -0700
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
 linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, =?UTF-8?Q?Mich?=
 =?UTF-8?Q?a=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport
 <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>,
 Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta
 <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed
 <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, Shuah Khan
 <skhan@linuxfoundation.org>, Thomas =?UTF-8?Q?Hellstr=C3=B6m?=
 <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>,
 Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy
 <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu
 <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <20260319093932.000078c2@linux.microsoft.com>
In-Reply-To: <CALzav=eGLpo5nrsHq5L8bUTC=FWZ-SgrTE1FoScrWB4p+NDgnA@mail.gmail.com>
References: <20260129212510.967611-1-dmatlack@google.com>
	<20260129212510.967611-11-dmatlack@google.com>
	<20260226170030.5a938c74@shazbot.org>
	<aaDqhjdLyf1qSTSh@google.com>
	<20260227084658.3767d801@shazbot.org>
	<CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
	<20260227105720.522ca97f@shazbot.org>
	<CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
	<abNOwcOTXqxCxNzt@google.com>
	<20260313083918.00005731@linux.microsoft.com>
	<CALzav=eGLpo5nrsHq5L8bUTC=FWZ-SgrTE1FoScrWB4p+NDgnA@mail.gmail.com>
Organization: LSG
X-Mailer: Claws Mail 3.21.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 061EE1C0004
X-Rspamd-Server: rspam07
X-Stat-Signature: qxob81izkrg8yi1dsoagns76zbtwx51g
X-Rspam-User: 
X-HE-Tag: 1773938375-570769
X-HE-Meta: U2FsdGVkX19GmCK+KeQjAaYAAqhw62dqdHLFD7jvRN16W49gG+DG6qYkWgwHy61voLY5P3QvpljWm0FaL3MiLspllaPv9UyirROedDb9maV9U+BfaJACr3GN1axSDkTYvJG4jDHAcE4nbb4bdBcz1M+w4xtkP+HTBags8RB9o4wUXTsx+DLJtF6atlDSgqUuzWniu67UhDs1gLcUIfElkc0fl6mvww/+bU/dj/aUa9FbbN5IMdm0GsP7PACJNj99VGbe4k0KgzmNyfX1BjboV9vjuQ3ARDruI17iyc1/ZCSEVWlQH9/JF2ju/QD+zYIMixXwGYnRrq2lTuPQeGU6D3jWsUQ0ngdYXySZu2ybnYtGZCl+0lpJ7ZVHBIdcu6FVg1cZomsMCNQtAcgxA6+BRZr5MvjCaIKarUnYvz99mp4t2/xlYk4Oq6q8pmwibqD43sy7Rt5XKVD+vMrDurUWSF8BenQBQD8q5X3KZD1vD7LybFDkvyFpR/D5JNGirwKS9/UmI+YhXgWVFuY8u8ueWGxCM+78RGTX2O6pHiTXfEMlU4+xKVJQJaMNUf5PC0ViB0ArOAM2bxFAR9zN2mX6duxa4GV5p2cRehFrfv/si0xno3qR3gjve574/THACf/dmz4omXfw3v3sQLjG7c6Jd8FaoJWiz3lDA8ZSCxMosIEg5JlyUJRidu65WINx9nWf1O4H82ga6SEepxVSzCb5yxmAVbHVss0t/oHihwgUxJpU4oyX3kSBzMhqFlYgCBXN8P5yOl/KEbpNxrFo3QbkuurNtdgflFVNqD96CtDsiCuuhlWrWYlGUzbEL0EvierIiOFunw/btO8v6T87p8MLZegoxKTFDhY298whJiApYbSDAXa5ZlzB54IJl2reNc+TN9Y9XfVrVQ4SvrXxRqzU1sRqoYFGvOPPbShnwbdenLScI90+T/LtLqZeeqcEQNNuxrJCLOgUdaQWJvrZEDU
 65CtzQe1
 5BrDLcgjY6qXn5LK8tAuUwb0xZ38a/VQGppEs8kDn+aPzlvCEks08fb9CMN/olP3HMdf/VaFPZ9kKwwdqsvSEdued5xAwxbrVmRWpwIDd6J7AAbaEhyqbZmaGs88Rsh0NhzWtYQ6N5n/zTmdSDpa2ctnYhsWXGeZmBQ7sVTMWAk+u5Hr1c2rfo6CkZPCoW9tlXBxLECQv5p0Mn9PBL3Kqz86T4dinLoIT40ItJxck6kYkVPFHa+kvwp85Um2S9beGdxXwHzEunTcMlPv8UiKsGSYnuHc03tnouzb/CWTQlSywlpdJMSLgBEcX/C66doehYrCMroKB6eBP5GEwzV1GYRDk6qi7eYwc/50kW8jYK/NvTQKK+5x4DJZF8DsWd3TUOdyh3cvINGG+GAdNzTsJNPB1l8HQY4fHgKhgpGFnxHEKraUFg2myjtx1XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Mon, 16 Mar 2026 11:11:20 -0700
David Matlack <dmatlack@google.com> wrote:

> On Fri, Mar 13, 2026 at 8:39=E2=80=AFAM Jacob Pan
> <jacob.pan@linux.microsoft.com> wrote:
> > On Thu, 12 Mar 2026 23:39:45 +0000
> > David Matlack <dmatlack@google.com> wrote: =20
>=20
> > > +config VFIO_PCI_LIVEUPDATE
> > > +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> > > +       depends on LIVEUPDATE && VFIO_PCI
> > > +       help
> > > +         Support for preserving devices bound to vfio-pci across
> > > a Live
> > > +         Update. The eventual goal is that preserved devices can
> > > run
> > > +         uninterrupted during a Live Update, including DMA to
> > > preserved
> > > +         memory buffers and P2P. However there are many steps
> > > still needed to
> > > +         achieve this, including:
> > > +
> > > +          - Preservation of iommufd files
> > > +          - Preservation of IOMMU driver state =20
> > In the interim, what do you think about moving forward with noiommu
> > mode without preserving IOMMU driver state? =20
>=20
> I haven't gotten a chance to look at your noiommu patches yet, but I
> do think noiommu will probably be a good way to develop the VFIO and
> PCI support for Live Update without blocking on IOMMU driver support.
>=20
> > I=E2=80=99ve tested your
> > vfio_pci_liveupdate_kexec_test with the noiommu cdev, and it works
> > as expected. =20
>=20
> Would you be able to send patches to add noiommu support to VFIO
> selftests? That would be very helpful toward allowing us to develop
> and test Live Update support with noiommu.

It is included in the noiommu patchset; the only difference is that the
VFIO cdev name is prefixed with noiommu, which is not strictly required
and is done out of caution.

/dev/vfio/
|-- devices
|   `-- noiommu-vfio0

https://lore.kernel.org/linux-iommu/20260312155637.376854-10-jacob.pan@linu=
x.microsoft.com/

