Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C647BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 22:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8228D6B00A5; Tue, 30 Jun 2026 18:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D2DE6B00A8; Tue, 30 Jun 2026 18:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69B286B00A9; Tue, 30 Jun 2026 18:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B42C6B00A5
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 18:35:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83DFF14015E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:35:26 +0000 (UTC)
X-FDA: 84938036652.04.9512156
Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8448718000B
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 22:35:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=llZTSzsT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782858924;
	b=2m45KCw39Dj9cKXmjhrSS5WfdYJ2ytLBIBU0CY3WIgRD9iL6EgKsUG3Sy5ITt1/Bk5LQXF
	/rDnVoFALPSWrqRF3x8g4QGzXQBY18f89o7aIMyS37/Opct6fgK/7VEA+81YttCykFuCtM
	6doqR36jt0D+Ubi6Fz0FzvEXwT5aheQ=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782858924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OLXeb8c7iyYBBm1u3dFIHz9SDW0xbbNuKTG6qGPD7go=;
	b=X1/T/SuJ4Xef4qbVcWCNjJCaAJp+XbWtx1NnB7EhFNwlCPHaHihQ5DVDTFQLkPkNMqzVt3
	JtdcKuAGJxwbs0WuJ+iN/jldN36AzynFFAluPZ4G11NPoNwfC2TOUZ9D1cUtbcx+ur4555
	LmeLDx0pW8Vuh/4kS4FviFojnWspXE0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=llZTSzsT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.48 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-137335bc3caso10776492c88.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:35:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782858923; cv=none;
        d=google.com; s=arc-20260327;
        b=hCtyswCKYh7sUP3ct84hj6JNDMDfSgkI7IEpRzWavwKZHhg0hyBM2RLbyVzAxwoQfb
         AqtlPKVv53AAjqJTCczeAB0zAVFREeXQsg7lJHZUk4xYo+mnW44erdisIEXx6N7tvqs0
         B8pPf/TPnuKmddHWSgbvTeT+b0BBxk7aKMhPrrg9i6Xp/uHwgcBXEV4CqXUtPHZ8bM6a
         +uC/D6fHqLNfCvPMk3FEgdksFU+2n7nCQ5iz2W8Pv7X2l4yqwzfLlEPAwDNten2e7akY
         xGJt1HGNeoa9pGL7yh52lbobK4un83R2fwHnWlVQEf072gnTjSXhj5vUcyyLNRtZIsjF
         9DAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=OLXeb8c7iyYBBm1u3dFIHz9SDW0xbbNuKTG6qGPD7go=;
        fh=GmNO9fjx+tlmSckHbKbU1XpZQbhBH14H6WYLGlXzCyM=;
        b=Wn2Cb5QGjijfeSzL8M2Se0mmpacLtQnjA8T1dVZD/K0WFZWCo4g1VQsnVp8E9TitxW
         pEXm28qyicsaAkS7mFpg5bUcMCSeays3Gbqh2+m8lIrvHg1ECRo+lQot8pVe2cwke3NE
         +kL8yAyUL5zQvL4KQppUJNs3PKqKmmjxLVDQ1IaYUhCF/g+8kgP4UhcXXCxYgBF7CaNR
         43Ou+XfvVK+jbqJt7hFQWME/US/+SVlwk9XXN5EG2bEzsEmRYiyh+Bq7r9092LKhx0CU
         OBrAL7ZIb2o0RCmw90joAd63a7Ie29QNWcSAVYL3b54VV5Z/pYJyfQbytI84NArbgoJq
         dd4w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782858923; x=1783463723; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OLXeb8c7iyYBBm1u3dFIHz9SDW0xbbNuKTG6qGPD7go=;
        b=llZTSzsTle1FLkooOlnyrxFCAvfuSjpNwXWqIbmg0z4aX1524AD6F+wYKCPc/0jB94
         rPPVJJBNwPeN1WxnXw8A+A25rdVFgXmV/o6j2hvX9tbT0cSQ/sDZ+QZ0n76L+N1IkCZ1
         BvPmDsRaC8jzA477Sgtuub6C45ENXqoMFIP/C5IjFbAUgWHwYK4ezoKxsAq3PEHUaQvU
         1KJEoJpRklfXEzo7Uic7XJa3yn5fw8sIr9eFH+oeJht5vWVltssBJm22tPQyweobWorb
         A+nJyVKS1G9rhCuDZnZiu1O9Z2qVoW8A53gRenWmGlL5rX+LYLsCxSxJvQ9eSi1snE3S
         B6WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782858923; x=1783463723;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OLXeb8c7iyYBBm1u3dFIHz9SDW0xbbNuKTG6qGPD7go=;
        b=qU6Bzx6Gl90Wbzs6a0vB4zC7hUPWbgYfOsN4xrSWWXlcNaVrsT7y84Nj//+0gkI3yW
         wQEgbOxbrMaIu6V9uT5E821NiHyQdkAkaKzC+WlaORKIHDBwMzx7KbHANENsdAjbolGD
         O54fyKmKDn1ke8swQIWgnpwPwsC8peXocgY73Ag7PgfdYy/xuP8I5rt1xOawhYU/QcgO
         S214/X2bIP2iG238eyCjbmRIr5vvZuwu9TAynX/biDkm4gaWW4zrFx7E+EkI7s02KqmM
         EiucupwArLv/TClHJrUDm6DnegaKGM4b4Cp7lsxcHzkLQMpJV2Gox7A9teMi6gWIQLTD
         Lkig==
X-Forwarded-Encrypted: i=1; AFNElJ+BaMbQzIqfVJ6PEQq3xJBEaOAV6bRN8cGzUOw2FCY2w24RoAlOly24hN3pEaFSVqoJzGqrZX/Xqw==@kvack.org
X-Gm-Message-State: AOJu0YwNCi8waK4xTQ7LbP6DbmKncLm4JCKSycGxwtG75cUNf4xKeT45
	mjA521fYsm9PmhUF372GLfclHUduTLtRr8NaBO4n+2EtzpP8PH9rv/OksEUyNyPD5/dWu8GBuRo
	D7Aq6yHgcQ7jMelCcAsC9/15TjAtwAUB4X6FyMHen
X-Gm-Gg: AfdE7ck+/wjKfx8dVQuMpgN01+qU4epp5BFbYB7IcNIJKwF37nCzpD/qVCPzNl9GTG5
	ZojEnZSuV1cCwLKYjWuRMX9XhbC4P3T1tDRRmArkVYRdkI0RMdnZBl5WqC7ME+tuXF6jq4LUKsx
	Q5VwWtB/tJTymnb62MYAghjWsEC6nl1GK0DKwITAW+agVDziAm/AN9bwLJfG3g+IVSeOTyUmG5H
	Ict/BNnwxn26NCa8Uoj77O+ZJEsjwxnaaqlcs9eEtPzNC+14u377Q8LY1bUgRxuimUbViRP
X-Received: by 2002:a05:7022:f690:b0:139:ed59:4b8e with SMTP id
 a92af1059eb24-13b2a1c7f1dmr3156303c88.50.1782858922721; Tue, 30 Jun 2026
 15:35:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com> <20260522202410.3104264-10-dmatlack@google.com>
 <aiaoc6Y6qeF_5Wn9@google.com> <20260608181906.GP1962447@nvidia.com>
In-Reply-To: <20260608181906.GP1962447@nvidia.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 30 Jun 2026 15:34:56 -0700
X-Gm-Features: AVVi8Cd-vdSCkwSqwAz2qbX9b8clCFCtpt-XfTl_1BZFKIa6zUmlOyUobbTWOp8
Message-ID: <CALzav=eGkCom7rM0Mj_AEhcvfryLctRWghPaGkD2V5_bMiXTEg@mail.gmail.com>
Subject: Re: [PATCH v6 09/12] PCI: liveupdate: Inherit ARI Forwarding Enable
 on preserved bridges
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pranjal Shrivastava <praan@google.com>, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8448718000B
X-Rspam-User: 
X-Stat-Signature: bcja5gyedj6m3ezfbqtbdi9cs9m84ugn
X-HE-Tag: 1782858924-524520
X-HE-Meta: U2FsdGVkX1+nJ/Mb/BsUb/pz9yahcl7aIttURxkPDDnZ4+yrN5Zcwgg9H7iZbiCDmDHvDndHwutacmtRCU5X4D6V9LwDWifq1CWUF3oTxtftJL26BuVmJFfGLlr9U0ry62IotI+mXNNfWg9zPw1Xm+bSDynyRJWKg6a0t355ZBVTj11pvFWTi4aChBBHeoI7oZHq+UzR5Su4i/Qpf7a7yOGHgp1GQTNQvRKpLyYSkHqlZZVBskZoOfjZQHyscUm9syV/ZHb6VZNfJkFs2zEMc1+hS2Jn8oLF2Z+ynmtClBt4baWeHdqZw85nxZcKTZVv/x3ctiJH/IowwJMogbMYmfBslZ4q24zb5ENTNpE9ekQ2zuVJiCvYZtZpiQpARurGo+2UlvD+FeXqyqpYkyIdsvkUepNyB1AC0nonGH5fw3UaKZXj/yrdOitJBG96W1IyO4eHpv8Fam3q9CjooF03R6KvQKIiw2jEVL1wMeuqUAW58KcSHxvqk83PybJf6g1MbMfQ2sJvPZkBgTRPz+c3ChY2KoDpTcmDh9KW3475dBZkVO/G56284r0MmYv+LrdUayXKG4GujOd9XF2zXT0N1JXAKn3d7PvezqISUQ1KjCWvPdNRcIfKGWe71AFQhnfFwsEYbdaqOEWQG6QdCoppOJAUAoZU2KspHljwjBk9g8U/61hEcgybKz+U+yCnB6V1uDRZLHhdXZW3bjoRl+SCnDxZ4OpsjkP6RClGppxN11Yfxub7A2FgcRLoQb2IhCQnlQRTJDm/69sdhAX8FxQ7J2wWwMSLg5/xft+3I+od2OmkPyvqqtct89h/HmiqbWaaOEO6lgg5GjF/YuGVHYJtZ3zkDw9048xOltuBoxJjpYLCiz6rMcFqsnqPgNpB3c2nUhm5hDxDwHrjkMM7EKE8HUurUm8ZhFOWsMnlY+/++QDiYflGqnmweq8s299ELvDsMoohyLaXCRo8tygzL+R
 fsmwTRXE
 OV8xwkEQIsawy80H3HotUttdZO7PO2fyYfp4Kh+Ujsdp4n19tBfFnAd4aPvwZSRztleHZCXbmB5+Ysh+Ey7Zfg2hcCTMPM0MJfi09lvq/QXYmA/QacqtJmF6xvkDOiGKyalVp27tRQl5B4ZYJKhdGPcLBVeDrWjNQggRk85wXgQrEXFZfICvTX69KTn7lStk4Av0g6+Cwd3fpWWs+o4bMQ3gOJzdEnGsOOrhg2gVWmXCwR0MJfsHdigJkqLt1BL+3PExvvKwq+2dw4/Lmt/9EuuzjXtu0mPeHk9qJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 8, 2026 at 11:19=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Mon, Jun 08, 2026 at 11:33:07AM +0000, Pranjal Shrivastava wrote:
> > On Fri, May 22, 2026 at 08:24:07PM +0000, David Matlack wrote:
> > > Inherit the ARI Forwarding Enable on preserved bridges and update
> > > pci_dev->ari_enabled accordingly during a Live Update. This ensures t=
hat
> > > the preserved devices on the bridge's secondary bus can be identified
> > > with the same expanded 8-bit function number after a Live Update.
> > >
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  drivers/pci/liveupdate.c | 18 ++++++++++++++++++
> > >  drivers/pci/liveupdate.h |  6 ++++++
> > >  drivers/pci/pci.c        |  8 +++++++-
> > >  3 files changed, 31 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > > index a93b7ef065f2..701276ef6cfb 100644
> > > --- a/drivers/pci/liveupdate.c
> > > +++ b/drivers/pci/liveupdate.c
> > > @@ -128,6 +128,10 @@
> > >   *    way after Live Update and ensures that IOMMU groups do not cha=
nge. Note
> > >   *    that a device will use its inherited ACS flags for the lifetim=
e of its
> > >   *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
> > > + *
> > > + *  * The PCI core inherits ARI Forwarding Enable on all bridges wit=
h downstream
> > > + *    preserved devices to ensure that all preserved devices on the =
bridge's
> > > + *    secondary bus are addressable after the Live Update.
> > >   */
> > >
> > >  #define pr_fmt(fmt) "PCI: liveupdate: " fmt
> > > @@ -756,6 +760,20 @@ int pci_liveupdate_enable_acs(struct pci_dev *de=
v)
> > >     return 0;
> > >  }
> > >
> > > +int pci_liveupdate_configure_ari(struct pci_dev *dev)
> > > +{
> > > +   u16 val;
> > > +
> > > +   guard(rwsem_read)(&pci_liveupdate.rwsem);
> > > +
> > > +   if (!dev->liveupdate.incoming)
> > > +           return -EINVAL;
> > > +
> > > +   pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
> >
> > Again, I might be thinking out loud here, but since these are
> > hot-pluggable devices, with some FW / SW running on them, I'm a little
> > worried while assuming the HW registers can be trusted across a kexec.

This is, in-part [*], why I explicitly read the capability rather than
caching what the previous kernel thinks it was in struct pci_dev_ser.

In other words, the kerenl does not assume that hardware registers
remain unchanged across kexec. It reads them after kexec to determine
what state the device is in and inherits that.

[*] The other reason is just to keep the ABI as minimal as possible.

> > Say, if the bridge experiences a reset (e.g. link drop etc) during the
> > kexec blackout, the PCI_EXP_DEVCTL2 register could revert to its defaul=
t
> > state, meaning the ARI bit will be 0.
>
> This does seem like something to be concerned about, but realistically
> I think if you get a PCIe error I'm not sure the incoming kernel is
> equipped to handle it at all :\
>
> Just resuming the driver is going to fail too, I don't know how VFIO
> can learn and forward the event, and so on..
>
> But maybe it is worth being a little more defensive here

If this were to happen, the kernel would see that ARI is disabled on
the bridge after kexec and proceed with that state (ARI disabled).
Devices (devfn) 8+ on the bus would not be available to use or restore
(the kernel would not discover them during scanning). It should be
fairly obvious to the user that something went wrong (devices they are
trying to restore do not even exist) and they can reboot at that point
to recover.

This should be extremely rare though as it requires a PCIe error that
affects the bridge to race with kexec.

This seems like a reasonable way to handle this scenario, at least in
the initial version. We can always look at more gracefully handling
PCIe errors during kexec for Live Update if-and-when there is value.

