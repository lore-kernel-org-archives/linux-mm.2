Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EEE4FDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 23:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 625866B0088; Thu, 23 Apr 2026 19:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6A46B008A; Thu, 23 Apr 2026 19:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4C66B008C; Thu, 23 Apr 2026 19:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 391FF6B0088
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 19:09:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA6EA120612
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:09:33 +0000 (UTC)
X-FDA: 84691364226.05.E85F8F3
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9859820006
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 23:09:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=INdw66eL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776985771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=du3muYvsQpTSBNV17AfC1+OtrIQr2PLFz51edOhTt/Q=;
	b=sEh38r9wS5OBP2y5qxSYqKcohBwI4AIHQI8os26quUTytGlQLPGyO2hS0wdI+oCnKcB74b
	Lv9VfDysVXlkiJIsjG56v4bdQSwIdvbLQL+ABt6cbSas9t3OSbXbo7yIdw9e3QlZorCd/U
	Gu9/UkHKGfzqwS8urZcVrzrf8vCqROo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=INdw66eL;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.176 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776985771; a=rsa-sha256;
	cv=pass;
	b=GJI04tLiqhUFfQqODa/L2ZgIOZnwfErJrhtPotHnPzicoDWdYpYc5LF4JenPW/KME2WER6
	4zN9Ge3WgwCmECqrriQBl9pmgFGjodVbPQGZwNOdnUMUkfKUs1X6JAXsTlWiYcsTybhCuL
	/mO9wvNezOxChwNn7hZxUwc64vrkshE=
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-38eab6cf7d8so69423141fa.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 16:09:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776985770; cv=none;
        d=google.com; s=arc-20240605;
        b=WivUrVllNyOpclkTkv9FIOhPBzFujHgJSnGT/Kdve8ZjBoHE5osT8qcqfsBVotCNkb
         +awFf/j5VKxs+p1cCfgg2PZ0WLtZ1ERYvfLO1Olo91dVCa/bxhOtXb2nr21GWsD0b4xj
         5W9ZYrOHV831ygLSOPmx1Xf7J9Z1v4Q01IQAZKF4uHkNqWO+wC0zC+IxGr0QUnI/1hNO
         hsomyyb8axjlBJKMf42Vy4Esg9vbtCV7RZJfb3gPEKQITfJUxFIDTalXjOPMaLN8Jeqg
         OqoC0fo4MFNXdrWydQJ8ebF9yYbhi0xuVYdxEC0pznCFhSvx3FYGMvcwPONipMvBms9A
         1eIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=du3muYvsQpTSBNV17AfC1+OtrIQr2PLFz51edOhTt/Q=;
        fh=ggDqAB4MfnxEEfJEftW2N1W1r/R1R9cIW0suVv/mcjc=;
        b=DsDWe+uWJ4er3VTN763f7+Lnaqg4KgLJuHvH7n2eyuKXd3y/Et97e32jgY6bDTkGy4
         hoN44OO0yis4bVezuM+Igjp4vkOrQHz+uVLIHZ9BSCQdHcojpBEmYGsFqFCpa/eCO2Md
         F9Cir9ocQHd86Jhq8eqI1HI5ICR2cG+Ja+LTKQIzYudJ/Zo7rwNTTorc2cXMx7PL9guD
         iz8++jypK/KJuOQ9TL3nMoEqDNjrNunzMpD9+asjJ0s6XpARWpi3PpKOwDAQzoepLosa
         RI3L1Pljo97QN0zjBwOBFX3PlwmPuMIUNNr6Q2c7Iabs4V4h4E61TvOmrV6pO0eElZX1
         sUqA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776985770; x=1777590570; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=du3muYvsQpTSBNV17AfC1+OtrIQr2PLFz51edOhTt/Q=;
        b=INdw66eLBdr1cLU9C5LUxXmMxppzKDJ6byqidvnbBI+mhfAH54t2qUUe8IAwUZjhta
         cp4+hAHSvrC5Bou0JGgei3WZ2RSIgq3R6EG5qegHSlsuoarJyAP75Y647f8APqgsd5pX
         sxHfRS9jzv1+kEPqsy54zLSkPJMEMFQVcupIEo7kpUqs4AYGYrS5xPzbPutTtDNUsTmv
         IIhCssd/bwbL1caRAU7h7Mai5Hyx+kffP3rkrFGsWBfEjUY5BxxDn4IwMXPwUdjGC6Ds
         30WEYJxShXCpXbRjIc6O5qjWXRUziiMfVGI1vtRjibBz4xiSWEiomD7Qo5u9OBHSxtB5
         X5zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776985770; x=1777590570;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=du3muYvsQpTSBNV17AfC1+OtrIQr2PLFz51edOhTt/Q=;
        b=G90shPXVKzFiuvbFekWpZNqJnCSVIsJDM1oMF6luzrsyVCMNdXUqKrnVNswyq71mYz
         7z2hiVRBFj/sLzRMGS9fVwWRS6wVWRuGtoiRVuS/wMzrVwTzDmnSDvzn9mMZxcTpiPRk
         UEy8/Wz20DcMYlcWM/JRHdM1gaxh1gSZp6vNiYeOBkXacMly1Pf421zOULbsujk8EDVC
         LAH2s6j+QSzv9U0FIn4e2bdRf4PAdAjEAfAPgG06sjVJ4SPdB/4YZks0+PXs8sC9Xzbc
         NwjiglYfjOZrBTMM6jbfd/IBWYIKG2Zb87x7VV96yhZD79wucDrF55NujaIb4d2mdfV0
         dj5w==
X-Forwarded-Encrypted: i=1; AFNElJ+z/POp+5Qh9WYNM2o3LxtqvbNrE0MclsaLIMhfuboYeN6A/pfEJ35F90Mxko6ilPJwQRhpf+1VmA==@kvack.org
X-Gm-Message-State: AOJu0Yy2ueutoQJPrx41qMklB3DdATS5bbAjhJDf7DHqCOINakdxX/ck
	Z6TbDgtijHBCNHVLMSMZoS2JH7Uis9NsCiRKfWI95MMk9pbmFH+kJTEreaSgVDfRXB4Ma0CHBbB
	k5BMCs3HSIfuS7m8cKl5gNL5rzR2WPYhRIKluVkbp
X-Gm-Gg: AeBDievtCcHaI1FEmhBZgvACsWVTxIML+dJ4twOEfU/HxgH215I7guWD9WGQNjozKSe
	FZ99CN5hlgqX11NEHhH7BWW9t1PxE+Q1wn2sozusC7qcxTN35GKdKo84SUUzat+tvOBuAXF10eT
	wm+j7HYcxYL0WoXhVKD/v4iPR5yCy3Co07X4L/qfaQ6oePuQ5myDIOi4G082t0IcouUnsddAU7g
	aDZYuaZhnRvKCM7NFP8cbmp5dYwVjuc08vBDhoXDgtYAIwpXshlQ2bJIvZ0IiyeOzOt9SdyG9HY
	LA/7ofUQPETRgKcQ4NdFVg9GK9zgvQ==
X-Received: by 2002:a05:651c:418e:b0:38a:965d:79ac with SMTP id
 38308e7fff4ca-38ec7845ffdmr82161421fa.12.1776985769266; Thu, 23 Apr 2026
 16:09:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com> <20260423212316.3431746-9-dmatlack@google.com>
 <CALzav=dGpHEnEjyp8qc50iZrGeKJ47vjLvwtvkLCyNzOMJhozw@mail.gmail.com> <20260423225253.GA3444440@nvidia.com>
In-Reply-To: <20260423225253.GA3444440@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 23 Apr 2026 16:09:01 -0700
X-Gm-Features: AQROBzCagtk2g3nQiz1XNHTS_Y7Vpcsrr0LE0644u_NVwvd3XuR0UjLC-oW_vCY
Message-ID: <CALzav=fraXLgGs-XMc-=whMPhMbS99twFskGtV5Eo=UQ9mU5Fg@mail.gmail.com>
Subject: Re: [PATCH v4 08/11] PCI: liveupdate: Require preserved devices are
 in immutable singleton IOMMU groups
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Joerg Roedel <joro@8bytes.org>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9859820006
X-Stat-Signature: ymydbtyhq3rzcedr6e9sgdzigk84g9ja
X-HE-Tag: 1776985771-811451
X-HE-Meta: U2FsdGVkX19O0FTpyRp9up/NzBKlmYgcm6DJ1YmSjLhFL53Ad+E1t8cZLErpUnAWEgXpeDqbWVo2PB1cGV4tYA1dsEg0QEEImOZ1LqXvv8wk0EtQY/gwg/ovWkeL3B68Alns6cXvuQ0hphVAjqH9nBzm9hDgUYQjmDOB9z7z1KquDHpa5A+clGO16UC1Q5sVvAfXUygz0KwdySrb6t6N1os2viPhZtsMaH1bd7xcMEoiadppBZmJkLp/mN974m/heP36aiZU+gsUOpbnZHJ2/Oy+MWpfMv6yDoyn6FkOD/jRuwZHjUCPyezHEdihiGW4ohk7baf4p5mYzXCFjkum7FtDH1YkRH2pW/3RURt2PvHT5D4gUBA0t22yF3Kdc7yMUPeU5MwWjVIlj+g0e65pkf9InDOWs3KnkoxNejr+03QN2U5fytHf42LrzZBvPxF0iRRfrbQIpGuAAFdEvWbyaLadaf8JjGpGIYFjXdIpxl5kvQrjtaa06TqylBLmvxQK5YMVJsD0CWt/GAs2vCvc7B3Tqs8zzhNKuw7bWexoV9frIVA8wcwBOFVgO4vZBSGZF9MaOM6X7LVwOzyru1K+PEJnszMEdJz5MuI1Ah3ho6rGtk5wuYA8STlcJKmQ9mCnomwuMGkqQ+jPE2zESrkMvArW9i3SKvpJaAGuN4oYpQA13nQHt5iSo6vXdPgLiZ0TXkGvz4fySpO/GG2i8/Jkc0rRE3ZG6bFo43rLA2ZjzHKJgC0K+4mx0O4ze1ayqfB0VAD3QtyklB5B/O7n9zzyUwDWn3PEggB5cFQXJiiAnAQ8URQjTCSmbbxfgigxcYxVaAcDJgA3C1W7h3g37PzzXmW5Ftf8Mq6z3IRua3hAmC8Zef40+zGoutujP1cFVgi3KNANTcHaqgi7pDW5Ho4SmvWrB6RbAQc+Eb+lh/cGYGvlkWLN4avWuDfvSBdNmWh5U2xXQ2fMaJSNyCbwc5s
 XWC/4o/x
 PRS72gOzDc44OjvFiSqZO/pmjNhU6BGHWvdqABsUWaFjmGo0F2g1fFmy15vDVMNg0aDWMpH4OBnTGyHkGtMPiYJlYeznfrmnzUhrcmEWjUredWpQUGucCPZ3+A9cDFiCafbPpGgKrmhav302lChSMQIYP7IvaMnhezX6ZbtQ5zKORuTyzllWfeVGI187ozzgo2nDvgUQEbHHIhdb4I7Z//fH5U5a4YYlzqLH9gqmoQFCVaTwhPwXZbqFn30azNRHkiv7Cmz2KDn8StkgMlsX3eBxdaKrFEFJ/h4by2aQRxP9Zjpm04eVcRnX+KQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 23, 2026 at 3:53=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Thu, Apr 23, 2026 at 03:10:55PM -0700, David Matlack wrote:
> > On Thu, Apr 23, 2026 at 2:23=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > >
> > > Restrict support for preserving PCI devices across Live Update to
> > > devices in immutable singleton IOMMU groups. A device's group is
> > > considered immutable if all bridges upstream from the device up to th=
e
> > > root port have the required ACS features enabled.
> > >
> > > Since ACS flags are inherited across a Live Update for preserved devi=
ces
> > > and all the way up to the root port, the preserved device should be i=
n a
> > > singleton IOMMU group after kexec in the new kernel.
> > >
> > > This change should still permit all the current use-cases for PCI dev=
ice
> > > preservation across Live Update, since it is intended to be used in
> > > Cloud enviroments which should have the required ACS features enabled
> > > for virtualization purposes.
> > >
> > > If a device is part of a multi-device IOMMU group, preserving it will
> > > now fail with an error. This restriction may be lifted in the future =
if
> > > support for preserving multi-device groups is desired.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> >
> > Jason, do you think requiring singleton iommu groups is still
> > necessary/useful now that this series preserves ACS flags on preserved
> > devices and upstream bridges?
>
> I have forgotten why we introduced that? There are alot of funky
> things about iommu groups that might be important upon restoration..

You had originally suggested it in this thread:

  https://lore.kernel.org/kvm/20260301192236.GQ5933@nvidia.com/

> Like if you preserve one group member but not the other what do you ?

Yeah I imagine there could be some tricky cases there...

I wonder if PCI core is the right layer to enforce this. Maybe this
fits better into Sami's IOMMU core series since that is where all
those tricky cases will be (I imagine?).

> Even if you have ACS flags there are cases where groups are still
> aliasing DMA..

Hm, if a DMA alias can be created after boot time enumeration even
with the REQ_ACS_FLAGS check, then
pci_device_group_immutable_singleton() is not really immutable.



> Frankly, multi-device iommu groups don't even work fully last time we
> tried to use them in a VMM. So I think I would not expect them to ever
> intersect with live update. Blocking something tricky you can't test
> does seem like a reasonable thing.

