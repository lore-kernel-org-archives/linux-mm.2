Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7403C531C9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 23:22:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74E7D6B007B; Mon, 27 Jul 2026 19:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D8C26B008A; Mon, 27 Jul 2026 19:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5799A6B008C; Mon, 27 Jul 2026 19:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 197376B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 19:22:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8BB5A80119
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:22:43 +0000 (UTC)
X-FDA: 85036133406.05.C363A2B
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9C51180008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 23:22:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BonKkQqP;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785194561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aH9fxD7OeNQpvbALLCFcfoa0nXkldfT8Qxn7YBj/IBU=;
	b=kDxLC+PbC/xJV0fPHh7fx+AuXW9+/Dyvu2LoI9VRT8DAoA7n5LW/rUllq3sySsX98SwsvE
	mCC/rJx9e5SKwd/RFFpAoCqpTK10wMoa90/TWeSzEo1NFdpRO9Q33gTesL3r2t+VKtR+QP
	3ZNygJusTltPnwPwcbxVBJcLbAdX+lI=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785194561;
	b=G7zFanU1eOeRcDSCnFfqsjnqLAKfTSztoVB9hOVBzqE6O7MpnhUvOyzwQpupX5JDN+nDyr
	9G5p1I1sxqMzbDz+aw6lRDvGzCgfjU2iWgnAhhSJqjhESlMFr587PqNs8VbWwGiCl8/8uw
	DLpuhRYP6wNs4NcQ6ZPGdXnzh9hKpkc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BonKkQqP;
	spf=pass (imf02.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38de840f2f0so2518225a91.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:22:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785194560; cv=none;
        d=google.com; s=arc-20260327;
        b=HUKQHE0IcG+98cf2vKAWrr1gq6NMxsB7Rkf1ba7+iFUBC89sCMwKNInt4sRp+83ae4
         sP9hykvLWC9FkP7bzLQ22vu9yvtznAZM85v1nFNvccvgut5rT+83LMv3vKp83yBWea9z
         RCDkBfqEBrSZgv44uXXvE1f2yq7CuHa0NJSE0U8Di3SW+RFQLDkOjaKgVWMcR0vKZ8h1
         H3Oa0f1FLbhuGC8r9BLmaptGXALebEq7Npum1ijo6KcaCd2dGmQGgYIghLjPe5dThdmj
         S/IsSBmML9ipXa7ll4EiffUpoecCKdXkw/S3lB7d8SnOcfdbXyuhbl6EhaMMXoMjZfPX
         5nGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=aH9fxD7OeNQpvbALLCFcfoa0nXkldfT8Qxn7YBj/IBU=;
        fh=VxqEWTYmkJ1wLobN+RFDoz/ZBJ6jonX62L19FoTQwzk=;
        b=M00mra0oS+2PTnD2j3yqwbflNEUZOJWwzSXHpMxIEihJ40V3EQUBMGYXjntALg5K4y
         vHWmB829LnCNV2mt29RlDXg6d2f7CjHmoG8JETUybPCkg09KcnUY6KiI4Sz6gBoB0JY5
         ufy40yd0VTMH9ur5OKOe0kFAKnxfHW7v1UWwyx0Mfns3cOKjY5tk4miFr0lRg+IthX1R
         2cMXMVabKrT7/Q7CjT69EV2Sd5goilPRhgohrkBVP/aN1+cIN7gpvsffAJoFnxasqlDg
         ls9Xc9Xr5tHVXWwhULFbt/TPBGgC6LJsuE+NVzpGTG5hMBRYuHZp1+LtPvw1/c0mdk5r
         3N4Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785194560; x=1785799360; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=aH9fxD7OeNQpvbALLCFcfoa0nXkldfT8Qxn7YBj/IBU=;
        b=BonKkQqPWyu9QKZiqPdGmoy0yusa0Mshsop3e4peO9AKIaOjKqeEgwdqPTH5i5sUot
         ulb3CVZUQVDdypaPNTBIcKcw/Y7C8TPd84c6s5sQjiAYp376g8HPHggghZ2o3DbmWtWr
         VFwymmPUJmvjoASWn6Azk+QBuOwqc29jzdKusF6fCofJUPah3+tfBH5ojHzAFRGwMt1q
         BLh7rpSU5mcc3OKooR43zDksNw+tAx/A7wMpt5xu7uPODrLGWmde507cEIOtdcdcWXYw
         G9+ERFQCaSFsQhxSHZE+1k9z7kY7M+KU00PCdvQSeQv1BeLbqDuCMFSv3PYvoplmH4AZ
         lDbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785194560; x=1785799360;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=aH9fxD7OeNQpvbALLCFcfoa0nXkldfT8Qxn7YBj/IBU=;
        b=KvtzRiZFhGcwV3DD5UfLmbLlXevxfPnXj9ZaUBu75T/CxiabIEBJ1cidKbpWWfNxud
         g8RycCdpsL/gzigvSd1XRyKCscNbx8FVqODQT81CF1uLR5K93gqZUllPTZWpj66Rqb0P
         p8UDW0zvDhR0Jb1iTjp7lb/wNZLz+cEc1YD2BA9r5ex490U5Yx+vBIl9r9osaw1tE8a4
         8Yx8a5DbmlZtpMER3mOQ2JmfR4EAUKmKKUiFtcdjiRAhCtWSOZDzE2F01n9Nu7qxbvyp
         FiOn25POaKTNudDselUM54vjv3HM/mm9Ych9ucaDDRY01enV5lyPE9ysV1z491IR6m7t
         XgKA==
X-Forwarded-Encrypted: i=1; AHgh+Ro1Zz+qlCL6BW6HmNELafW+xOeB1qxarqxmcNtZL0J+PdeACDMGGD+0oU1+u87FP2NhcuauNDAVEw==@kvack.org
X-Gm-Message-State: AOJu0YxQQHTszRiK0bAN3gHHHbeSq/okC7oS3eiTqs3uYbZ9EmQFxkGV
	OYt+1DtqeAnqgg+PqOzScxLAHi16LIaZ79FtXxi7+Bf/kroYAMscxDQWR0AH3arI8xqhtXUYiSz
	pEbbiGM/+Mb5mdqkPZbiouyw5cZHdxKf3uga4Y+5J
X-Gm-Gg: AR+sD13tas1x0FtkCwknITtXFchOrW1x2cPjGlBx9AUV3xDsgqDO4bG+FHRA28mE44H
	0i/d8F64eLUqGqM+C6mbzt4PFXv2AXwuReD2Mquiz/T626PGI3j1sT1qPGWqGjy/UeeZBWe9Bbc
	YGAFK6mmhrX9Xp0Z2fZQChaN1wIzCToQidp7XqptnGpDR4vhgBiiwbTBYvspwtVAxXNN6lAufpT
	ukDMty0iH30o2x7gCwRO5B3j5pwmL2DTlLiLLlUMYT87k7QAvlNeEgcZaaj5A==
X-Received: by 2002:a17:90b:2487:b0:38e:5c6:4db9 with SMTP id
 98e67ed59e1d1-38f6a030477mr10389a91.11.1785194559678; Mon, 27 Jul 2026
 16:22:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-10-dmatlack@google.com> <20260727230740.GA1273350@bhelgaas>
In-Reply-To: <20260727230740.GA1273350@bhelgaas>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Jul 2026 16:22:12 -0700
X-Gm-Features: AUfX_myIRjJ65ll44x1imgmZse5x82nFT62Po-YqpjuwILzl8FbHo5wgsdHMnzc
Message-ID: <CALzav=dHdtHPKJVbtnc1BwzccKuGSPxKH9Gvpv1ZVw4z2-0txg@mail.gmail.com>
Subject: Re: [PATCH v7 09/12] PCI: liveupdate: Inherit ARI Forwarding Enable
 on preserved bridges
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9C51180008
X-Stat-Signature: cni1okfujbwirf8ia1q5gfkhc5pueqcc
X-Rspam-User: 
X-HE-Tag: 1785194561-245263
X-HE-Meta: U2FsdGVkX1+IAq7ody/rKaPCiOqg8rVyO/nUADbKNUiusabBfbIv9GBeUgouCYlb6wg9OvnmY4zoZ2F8purwM22AANfQj9yTklbVEqvRgCHGwgBVzbLq5iOius0AwXYwtVFNKmuBa5MpfE7MIO5DrtZlOLxvfG+vvhIjA7Orfd3167P0mszTsjjIGsxps/Ozq4DbIj1hmMQX/zxMrfjiBVwCMgcyE7AovJFJxN72VkMUIUz2+iv2Y02e5XLkqF2p+7d+6FX0CVHGRiOSBJFaNPkgvYEfyXZfuBcNM/WX6rexQf3dvc0ANExEm7MynNflJgpsVI9nOIkxuZ7p3Do5adaXZt4WUOILiimiW8RRCCQO+3mOS7/2mNfm1XQzzdhzBiYcDitJRfpqToikSIyB8b+2PLDKE0nYZvJq4SdihhhBldHVfwfO0ibiGoFY9bpu34k1Mk7GBoEyWhfvWVyx4e1e3mwJOJg0iblUPntGHibCQsHxJphLuQrE+wmQZRoUu/c4B3+PNq5/0ntegp+2iL9UYrvgug8W5o0PXXGAJphYJYwVKACr5W5PdIiUXHpwtEnaRfJzpY/zdjexHRl3xtC13IGEepndw4o/FBxZKyLTo/IqJUKhEdypUQ4i2HVoxh1p1C/e/8ffmtjoIzZNAnZVa4KUtILO02ZAj5GEYERcqMcTbWjXJl3ej1sWZdWOABL+FMSeE3VLH4ji6Hy/cvBPveR9eS+7yty7MyeXZUaPylp2UoI/qU2kj85GwjFb7LYt9wTLHjEWZ9d06AB6iZ0Sqmfg3OqU59MdwqDM+S5fVWIRdsybuoORFGhdwtT4HwUo0O2eZ9IO7Sus7ab1PQ6dp6wUMrg22daCOpcYQiafk1E49BuWtdrdm6Kdzz8KuZuB6b5z+0CtTQisAmxhnEKPfTZYtOSkvjsVe0Jp1KrCGUHE5Ko4iVpeyEbLdp15UknKujlDkQ4rbrzIvSj
 Wv0HEXTr
 0AVbu00IH7ie4qFCsEtDIl/Xqa6vrmXX47Ai6mYNkjXdsMjwYJgRPe78oXINz0pI/GgFrrQYJUssWDqsX2IjZCVx7NN7CcBPC+ONZgBQ900/Y1xlDw0WsxZjaRsyEJs0uU0fc9i5tRsJRK06I3gcfzqtQmyxzs5wiSJ0IEb/+4vj9Q/0BuOgpIqPGfFa+Le3FA5v9W6+GRiHygIMqGqsgDR5jlHcsk0MVxbtqGM/CVBqAuJ/YWl6TeVW+tBQU2ea5X3hrktaAKvY3mdKLAkupAVPug3so/fXPeI6z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 4:07=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org> =
wrote:
>
> On Fri, Jul 10, 2026 at 09:26:12PM +0000, David Matlack wrote:
> > Inherit the ARI Forwarding Enable on preserved bridges and update
> > pci_dev->ari_enabled accordingly during a Live Update. This ensures tha=
t
> > the preserved devices on the bridge's secondary bus can be identified
> > with the same expanded 8-bit function number after a Live Update.
> >
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  drivers/pci/liveupdate.c | 18 ++++++++++++++++++
> >  drivers/pci/liveupdate.h |  6 ++++++
> >  drivers/pci/pci.c        |  8 +++++++-
> >  3 files changed, 31 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > index a95bfe5eff77..74a11e520f0d 100644
> > --- a/drivers/pci/liveupdate.c
> > +++ b/drivers/pci/liveupdate.c
> > @@ -128,6 +128,10 @@
> >   *    way after Live Update and ensures that IOMMU groups do not chang=
e. Note
> >   *    that a device will use its inherited ACS flags for the lifetime =
of its
> >   *    struct pci_dev (i.e. even after pci_liveupdate_finish()).
> > + *
> > + *  * The PCI core inherits ARI Forwarding Enable on all bridges with =
downstream
> > + *    preserved devices to ensure that all preserved devices on the br=
idge's
> > + *    secondary bus are addressable after the Live Update.
> >   */
> >
> >  #define pr_fmt(fmt) "PCI: " KBUILD_BASENAME ": " fmt
> > @@ -816,6 +820,20 @@ int pci_liveupdate_enable_acs(struct pci_dev *dev)
> >       return 0;
> >  }
> >
> > +int pci_liveupdate_configure_ari(struct pci_dev *dev)
> > +{
> > +     u16 val;
> > +
> > +     guard(rwsem_read)(&pci_liveupdate.rwsem);
> > +
> > +     if (!dev->liveupdate.incoming)
> > +             return -EINVAL;
> > +
> > +     pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
> > +     dev->ari_enabled =3D !!(val & PCI_EXP_DEVCTL2_ARI);
> > +     return 0;
> > +}
>
> I'm guessing we're going to see a lot of this pattern, so it will
> eventually become familiar, but it's not familiar yet ;)  This doesn't
> "configure" anything (I do understand that avoiding configuration in
> the new kernel is really the main point of liveupdate).
>
> Maybe a comment is the solution.  Or maybe a rename to
> "pci_liveupdate_ari_preserved" or something?  That would have to
> reverse the sense of return values, but I think something like this in
> the callers would read better:
>
>   if (pci_liveupdate_ari_preserved(dev))
>     return;
>
> or maybe:
>
>   if (pci_liveupdate_preserve_ari(dev))
>     return;

I do think a better naming and return value convention is needed.

Perhaps "adopt" or "inherit" as the verb? i.e. "adopt/inherit the
state of the device established by the previous kernel"

if (pci_liveupdate_adopt_ari(dev))
  return;

or

if (pci_liveupdate_inherit_ari(dev))
  return?

>
> >  /**
> >   * pci_liveupdate_is_incoming() - Check if a device is incoming-preser=
ved
> >   * @dev: The PCI device to check
> > diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
> > index 4e8a01bcb4bb..6f21ec50927b 100644
> > --- a/drivers/pci/liveupdate.h
> > +++ b/drivers/pci/liveupdate.h
> > @@ -18,6 +18,7 @@ bool pci_liveupdate_scan_bridge_begin(struct pci_bus =
*bus, struct pci_dev *dev,
> >  void pci_liveupdate_scan_bridge_end(struct pci_dev *dev, int pass);
> >  void pci_liveupdate_init_acs(struct pci_dev *dev);
> >  int pci_liveupdate_enable_acs(struct pci_dev *dev);
> > +int pci_liveupdate_configure_ari(struct pci_dev *dev);
> >  #else
> >  static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
> >  {
> > @@ -46,6 +47,11 @@ static inline int pci_liveupdate_enable_acs(struct p=
ci_dev *dev)
> >  {
> >       return -EINVAL;
> >  }
> > +
> > +static inline int pci_liveupdate_configure_ari(struct pci_dev *dev)
> > +{
> > +     return -EINVAL;
> > +}
> >  #endif
> >
> >  #endif /* DRIVERS_PCI_LIVEUPDATE_H */
> > diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> > index 739ecaab2e76..e0c133b66a35 100644
> > --- a/drivers/pci/pci.c
> > +++ b/drivers/pci/pci.c
> > @@ -3528,7 +3528,7 @@ void pci_configure_ari(struct pci_dev *dev)
> >       u32 cap;
> >       struct pci_dev *bridge;
> >
> > -     if (pcie_ari_disabled || !pci_is_pcie(dev) || dev->devfn)
> > +     if (!pci_is_pcie(dev) || dev->devfn)
> >               return;
> >
> >       bridge =3D dev->bus->self;
> > @@ -3539,6 +3539,12 @@ void pci_configure_ari(struct pci_dev *dev)
> >       if (!(cap & PCI_EXP_DEVCAP2_ARI))
> >               return;
> >
> > +     if (!pci_liveupdate_configure_ari(bridge))
> > +             return;
> > +
> > +     if (pcie_ari_disabled)
> > +             return;
> > +
> >       if (pci_find_ext_capability(dev, PCI_EXT_CAP_ID_ARI)) {
> >               pcie_capability_set_word(bridge, PCI_EXP_DEVCTL2,
> >                                        PCI_EXP_DEVCTL2_ARI);
> > --
> > 2.55.0.795.g602f6c329a-goog
> >

