Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2750CFD318
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 05:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3DDA6B000D; Mon, 24 Nov 2025 00:08:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A157C6B0010; Mon, 24 Nov 2025 00:08:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B0D6B0011; Mon, 24 Nov 2025 00:08:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F41F6B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 00:08:20 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04F25C021A
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:08:14 +0000 (UTC)
X-FDA: 84144319350.24.7490873
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4089740013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:08:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PGWFz4wk;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763960893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kv5lKNyggtv57Xj6HWNXD5q3wcps9XYvZ+5HDRbjZNg=;
	b=EAEE82Xgoy/Rkf4ll+xHVPd7MfKq6uBWYMzyXTh8Qpl8yaGN9Lp3NSe5fenyOP6MyFAEuc
	XZHozETfTFpIKV1GVbV4nsAlsEZsni+8oOJCA/oispuWyeYbJI2gdItXE1UCb/zIhu0FMT
	IhAUwnrpPhRtayYP2+fu47pWb4eHeNI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763960893; a=rsa-sha256;
	cv=none;
	b=lGqDjr0j1BZlNzh5in4T+5HAS61aSu7CU4+7P2qrwkLhVo5B3hAi/jTWF0RZrH9U5N8xO/
	dIvaQkZwMOlZGoSe/0wIMEMv+znt3fvo7U2QCn6lyvzCPPQihqmFhHJuERjSrVMPufW6IQ
	l4duGqyPGyzK6hEZaziZ033MG6H+/4A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PGWFz4wk;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9904406F6;
	Mon, 24 Nov 2025 05:08:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 463A1C4CEF1;
	Mon, 24 Nov 2025 05:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763960891;
	bh=hieoIPxIhRSooVrU3/2wVozJyRs1qMXLmzpW8xV1wzY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PGWFz4wkyghWCM5P7ckMfeF1ztZvSWtS2QEwkzMCzyzCVgtFKGEkLgJqy/viT440v
	 yaLEfYvDaQKnLSy6uR+9I+i+ZINn7SDTB+/qX8KrflY1cjgOHRmknnXDOV/u0/FvGu
	 NNUNwqZ/xrD2U3CUlUTED32zlbalE8ApcvCTVV7fCZM+JTWXoXtS4lzsdcfGlmNLAZ
	 /qzpXLU7vNgOw/YDtFTUPhAuvbAOle9zzBCqJRbhAWlNE1Pbz9cKm2a0gIDY1NPbmC
	 0aQfUTilZ7Bh0ou+L5xM7SHml4e2W0OPll/Ctzpic/zP4fsRsIy5pDrE+VWMcYh228
	 +PoEtTeYVePdw==
Date: Mon, 24 Nov 2025 07:07:47 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v7 01/22] liveupdate: luo_core: Live Update Orchestrator
Message-ID: <aSPoIw2keoueM2q8@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-2-pasha.tatashin@soleen.com>
 <aSLsCxLhrnyUlcy4@kernel.org>
 <CA+CK2bCN7x=eMwfTXF-2+vR=Gn3=41z6Xxx6wM1m7i-rxzug9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+CK2bCN7x=eMwfTXF-2+vR=Gn3=41z6Xxx6wM1m7i-rxzug9w@mail.gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4089740013
X-Stat-Signature: 7ucastgo31hxocy96zqmd4hq3gattjo7
X-HE-Tag: 1763960893-465882
X-HE-Meta: U2FsdGVkX1/D3h+CWaVoMAoem5gglZdEL2QfxuiaNFhcU/EkXh0g1VQ4HU6l/skiJznmydFTWY8m5Mm/LtY+oYUzvQ+v6wdZYccDUHw8gSvKjIpuAr9XUjHMtT+e/WRArbv/6L0e00p4ljEBqv7uK9zWuXGt54lYuwTfVZSXW4kS9K5HVJWDq7v10AHTy2J1fZYTJs+ycvdm1ObWsTzxQMFHRupKrjYQ16kfNlyEYnUKdYZ+DCntS3TE8M4OKAFaP3LG1YQm7oLMRBGSg+lm2lt8OeN+veCTtBDWlCcfX0LKbg2zdvmWUUlIcx+pFbuFLDKAZV+M9Lr5bbuWlqpb258AKgqwANt/frXR0r8Z7bcWmr0+crQaDuW0SHcQNI+FB3BLh1DlY+VqdejykghDUtyB63aF48eB8mlf32dGXQOwEaCYFJlxWsqv4lcKx12YnFzWAS6dZ3USh4Z+/J89CsSYglhncUqRcYW+YOBY5F8c1EXLOH72/rgW98Zm298NTX7nH1JoGnMs59Xb40nBRFEaIJt3Q7qkPEH/1T7m57tnQb9xpa6jYmFNsbDuB2nIZLVw8jUUHpoCfcF+S4+jwh4LIEx0qEhgEtJlvr8ZSPZiSXcvD87sIgSK0QNE2/9ahTSnMuuFlx1yreFgXRB55YThakygyKZb6s2cjnUr8vVVjthxUZy2q14KkTy5jOaOxyk0pdFx/Az7jv7NLQmgrxwJU6W7Knzbhu5Dgr/S52CWmQHxljOVfmQJXOfg5FRgGJePbeGgLwXizrZduuh2SW6sCUABYgBXuZH6KgTmvtiB9RAHNFkfivQioacTqCY4vtqf08o2mi8Mf/B76KM4Y24MGOD2Zp8KIwskib+xRJmm4HTMxuuTzbFGWzNrU75APtzCdMK80H4MflJNIBBjx4BAs+5mp1YKAUbvis2zKn5pwu8BRBGrUpvBQZx824yM3mhnJCq3i/RlK6WC2Tt
 Ckex8HNw
 nXIXMD0TK7aXXcWMoJq2Ydf080uZvwRYh5ex+2kZK+gxoPAG96jLMB7i0Y1K0PA4/uEGSjypJWl/+hxNQzwtn0BH11ry3FAk4FwpumIdCFZEZP4ybSBnU9zIVJabqQP8RTukapnK1ighklSd5rLIYLbvJToNCrs+pLTtzOYNHhejVWuFluSjZ9UqMCwG9TkYV4ynKxshVuBNXM5RD9VuBxuA+URb9Axo3x1aXOMT52svR6RRdx448c+W88y8q4PBcMJAuSLRKU8s7/liZjfTTfBWd2t/PgNeXottsu1UFAqlEc0782nMFggOCjg+FOSKpfiHGQyBGuldn9C4h7YAlmXKVIlXylIOk2F+qNEWptOFsFg5UXlJ0z0LzlqZzKcbKeGW3/SRbEgfon1BiZgAKDBipCOMRS7cZpqo1u7EytXBeCQKcuQ7xQB4KjG971eFoye6NJuA8Dh3hKmCTwQEV9ia59+yspx1BEDMa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 23, 2025 at 07:15:44AM -0500, Pasha Tatashin wrote:
> On Sun, Nov 23, 2025 at 6:12 AM Mike Rapoport <rppt@kernel.org> wrote:
> >
> > On Sat, Nov 22, 2025 at 05:23:28PM -0500, Pasha Tatashin wrote:
> > > Introduce LUO, a mechanism intended to facilitate kernel updates while
> > > keeping designated devices operational across the transition (e.g., via
> > > kexec). The primary use case is updating hypervisors with minimal
> > > disruption to running virtual machines. For userspace side of hypervisor
> > > update we have copyless migration. LUO is for updating the kernel.
> > >
> > > This initial patch lays the groundwork for the LUO subsystem.
> > >
> > > Further functionality, including the implementation of state transition
> > > logic, integration with KHO, and hooks for subsystems and file
> > > descriptors, will be added in subsequent patches.
> > >
> > > Create a character device at /dev/liveupdate.
> > >
> > > A new uAPI header, <uapi/linux/liveupdate.h>, will define the necessary
> > > structures. The magic number for IOCTL is registered in
> > > Documentation/userspace-api/ioctl/ioctl-number.rst.
> > >
> > > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > > Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
> >
> > Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> 
> Thank you
> 
> >
> > with a few nits below
> >
> > > ---
> >
> > > diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
> > > index a973a54447de..90857dccb359 100644
> > > --- a/kernel/liveupdate/Kconfig
> > > +++ b/kernel/liveupdate/Kconfig
> > > @@ -1,4 +1,10 @@
> > >  # SPDX-License-Identifier: GPL-2.0-only
> > > +#
> > > +# Copyright (c) 2025, Google LLC.
> > > +# Pasha Tatashin <pasha.tatashin@soleen.com>
> > > +#
> > > +# Live Update Orchestrator
> > > +#
> >
> > If you are adding copyrights it should have Amazon and Microsoft as well.
> > I believe those from kexec_handover.c would work.
> >
> > @Alex?
> 
> Sure, or I can remove all of them from Kconfig, whatever you prefer :-)

Quick grepping shows that the vast majority of Kconfigs does not have
copyright, let's just drop it.

> > >  menu "Live Update and Kexec HandOver"
> > >       depends on !DEFERRED_STRUCT_PAGE_INIT
> > > @@ -51,4 +57,25 @@ config KEXEC_HANDOVER_ENABLE_DEFAULT
> > >         The default behavior can still be overridden at boot time by
> > >         passing 'kho=off'.
> > >
> > > +config LIVEUPDATE
> > > +     bool "Live Update Orchestrator"
> > > +     depends on KEXEC_HANDOVER
> > > +     help
> > > +       Enable the Live Update Orchestrator. Live Update is a mechanism,
> > > +       typically based on kexec, that allows the kernel to be updated
> > > +       while keeping selected devices operational across the transition.
> > > +       These devices are intended to be reclaimed by the new kernel and
> > > +       re-attached to their original workload without requiring a device
> > > +       reset.
> > > +
> > > +       Ability to handover a device from current to the next kernel depends
> > > +       on specific support within device drivers and related kernel
> > > +       subsystems.
> >
> > Sorry, somehow this slipped during v6 review.
> > These days LUO is less about devices and more about file descriptors :)
> 
> Device preservation through file descriptors: memfd, iommufd, vfiofd
> are all dependencies for preserving devices.
> 
> That Kconfig description is correct and essential because the core
> complexity of the LUO is the preservation of device state and I/O
> across a kernel transition, which is a harder problem than just
> preserving memory or files, for that we could have used a file system
> instead of inventing something new with logic of can_preserve() etc.
> 
> Device preservation requires exactly what is stated in the description
> for this config:
> "Ability to handover a device from current to the next kernel depends
> on specific support within device drivers and related kernel
> subsystems." The only subsystem that is getting upstreamed with this
> series is MEMFD, it is a hard pre-requirement for iommufd
> preservation; the other subsystems: VFIO, PCI, IOMMU are WIP.
 
Ok.

-- 
Sincerely yours,
Mike.

