Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26DA9CD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 22:21:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 126506B00D4; Tue, 16 Jun 2026 18:21:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D80F6B00D5; Tue, 16 Jun 2026 18:21:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2856B00D6; Tue, 16 Jun 2026 18:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAC266B00D4
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 18:21:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D52F1C3C98
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:21:04 +0000 (UTC)
X-FDA: 84887197248.04.9B18DF0
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9279E40006
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:21:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aacY7H5a;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781648462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5hm1HVaCy9nZT8d+x5IZzYgyaULXvQNG2Dw2s8INhX4=;
	b=n6bGmZ386+Wi/4y71HDoHIc/GbocROwnU1hx3Kmz/K+5fbojQ/Rpse0oakp4bn3Sq/15MA
	0XuduRDGFGHfJ7U+KX3MtPUf7442NN+nXIJ4NP9wG/LkXYzn8xGJuJnuerpmG4lo3JVNGg
	i9IvoyMtgrdZM7zHNbEwuwdz2yxkiBM=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aacY7H5a;
	spf=pass (imf01.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781648462;
	b=8Z7FANvldiqkTNiKH9xPvRu7ZcJ/LOOTWec7c1trUws2CrbThiQGYZ84E1giYDrjaeZYF5
	RTV1mUhQ6lZBnHrF4xYhU2mUhEjy8JhQXHs46VhGbrf1hs4AgtTKGE/iYgmffI/DQ+Zonn
	kRAtzuzq7Midn0EWf58qvhUAthIT4Q8=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1390f75d8bbso225085c88.0
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:21:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781648461; cv=none;
        d=google.com; s=arc-20240605;
        b=B/9uG+ntg87jUksMzOvQc2z2WNrT6AllHZP3ETSDK84iwyp72YAzmTyi06VtrsZa+U
         8rF01hHV+xFZ8kIxEMs22VGiWZRIeoE+G3UNnNSgKYlWtzh7xDVEqZrD+KN/z3wxJPpT
         btufwLeUr311K1oqpBXwAqfM5Z64gbalmEH6ZtgDDzX75zdS6KhXyAW4fSnFVl1GwEXN
         oo5ZQS0eo+IXv0aPveYDTmQ9zKp7qzUsMAnMerS9MtVnPdP4nvHrdIbvCl2e3T6WsBIK
         vz4SVAn80jXxANIk18SGFK41WPN/Lx22M1ZBIkHvzXff9A7uciw23fetfX1jELcD+h+t
         lsRw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5hm1HVaCy9nZT8d+x5IZzYgyaULXvQNG2Dw2s8INhX4=;
        fh=Ln9hwcI4onzStn3XCEsK+g9iZ7gosgSRZEl1f1G0Hvk=;
        b=ehbSns0ZUkMe9JJwGErtMfA0dgsrrFCZUai05dYYeHqUvl1X9HylD/YflLId6nuWoC
         IH28oHxfiL4RzkVtJ//Ta/+k1OcSHOHapV5McigDCNtcysNosf+w9iWH+JrEtuZd4Kts
         eWp7UG7MSsDSPC/ZADYXa3R4KLWIf9fmIgB+FWeVw3sZEhvfa8csnywHhA5eV4DtOQY6
         oGWxHVknrHJPvT0+FO2q3kIJxIrCfNIiEHJGCaExI2ptS2BHFbZaDunU+UPppTI3sxW7
         UZfJi4GRioFoaRyPgXC5mHNU/W5QHqXAkGGANZlw0CfBidPcBYuFbp/l5HG428oZZ8j3
         wu4A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781648461; x=1782253261; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5hm1HVaCy9nZT8d+x5IZzYgyaULXvQNG2Dw2s8INhX4=;
        b=aacY7H5aF0Wuh71Sqor4eG/R3DKmGMcKtd7j5JxEqMa/jKC19zn7T2ZXyVxjaXfl74
         ex8ShquZfd8hkYmB+/PXGTcALdHr6vZscvdvYNaMiuXP9p3syJxZFtCRPI5cszMExFNo
         OrhyESdaYodMTEdTyTK0rTFrZwdTfO+HWHxw+q8rslhCCmsO3gIF7DzhP2yAzconAWAp
         uzHg7QFz3oszMkYbO5XpEc0+O60Dxzlch9PsEwuc9E3wmi1MH+oQIBeIm8UBDUxKAQnd
         UoXc2gwVylbegCdaKKoWqLFSy/nXPjM/kDrfjJR1IMJzKCpgG79VVagn8/IOVVhnTCVB
         MceA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781648461; x=1782253261;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5hm1HVaCy9nZT8d+x5IZzYgyaULXvQNG2Dw2s8INhX4=;
        b=iy92XeTAltHaUXiYPlpHK+agZ1xfODMNpLWpDW5R/hhUa4OErATPs2dgqYzrIlNEwU
         26wNOEwih5txXjCAlz9dZibiVGthB13f6WZ2+VyLjFJthxko6re+ssl0sHlGmlZEEHIH
         rptjjKMZjiofMtqOtN1s5iH//2xZpLKrnlzKkdDFhkuMT5sfFLyDirXwlh3HqdTCdU9P
         lnHE3zwwkn8wTdt8kkVMTxT4WSGcKBSgpL6RIwAuMpcrNvSQD/8ttxb39Yj3EuuqjONc
         dr3boJilFTbb5p/+2/FOFdH4M8Qs9fI8+WK/0Wb4eOeEP8G1WLIMjhqx1/XMp+4pBlD+
         1JfQ==
X-Forwarded-Encrypted: i=1; AFNElJ+n9XJAWOkb1ytLTaiih/lRvW/ARy6kpZi/F2WgLJxsK4jTtZgdjC5Cbc1vE8202Ztcd2FuQ/+O2Q==@kvack.org
X-Gm-Message-State: AOJu0YxRBCBNMtWx6qTpT2cXxvSSl2Q2Y4GepHdtZ9E1jdomCH9A0foJ
	tV+jsTLV2EhcSEWNnPDnH/VUMsQ0tPMq6Opr1ppAVb1YrXICdrK9UGZcWJrHsytRlFxbKMCy4rV
	E+O9uJHNnXV1UFoHoQ4hV8oXYu8Ey+vx75q6HC28r
X-Gm-Gg: Acq92OE5dJAVBeBoLhGeRN3qTcgU27c2SFwDIgOQQsPYK0mNQZM4BoGXKeG8kjkmAFK
	cllb1TVKOiAp78Xsb/dFtBjd+BJ/TgA6JvR7OQU+r+BrP5m0YcTwP8iQWJOjm3i6lZTzvfHgY+F
	NceVNpDKK9CrReXpp+GoSYeIQAjb6SW2KIP956xjPsNGMGQfloMZ29ade9bi5foNLvQtSXMOpzJ
	tH+qK1kHjzY5NuUO0EOG1LTuHWZuqh1PtrRCQXl2NSE6zlqZ1RnrzuwARcwlBjTIw5+VsXVSbWZ
	PkwMyyI=
X-Received: by 2002:a05:7022:6ba8:b0:136:ac69:b0f7 with SMTP id
 a92af1059eb24-1398f680985mr453889c88.16.1781648460211; Tue, 16 Jun 2026
 15:21:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com> <20260522202410.3104264-4-dmatlack@google.com>
 <ajGpxMXk9iyXLzC4@google.com>
In-Reply-To: <ajGpxMXk9iyXLzC4@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 16 Jun 2026 15:20:33 -0700
X-Gm-Features: AVVi8CfxK4mMKiv0sputj5dz4geA42BjbfG1FN5Obs96hOQRjIUk8-dblh_dgDE
Message-ID: <CALzav=eo=UwoTNTYM8Z7uKoihxfB7NtVP701qidVgoqyBKhUig@mail.gmail.com>
Subject: Re: [PATCH v6 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Samiullah Khawaja <skhawaja@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9279E40006
X-Stat-Signature: 4mm8868bng4uw4utsd16ky9yty1zyb35
X-Rspam-User: 
X-HE-Tag: 1781648462-802875
X-HE-Meta: U2FsdGVkX19wTIMR3D5z0kDaoT1XwrSG3AGID7cGEdL2VxyjscYyQzgKSFd9NZDoLOqzS/QxEILv32iJr3JA1k7FYXkwhxwIkBOtQz2FW6m4s61DFrKYV+fktFkLusijsX+sWa6zfJxYMSbWnz97Qg28GXmSU8f0DDZAcHNEDULo4ufvo7d8AsiVAHDBRAVvCFMRuw3OvWtsTP8bOXdMkP4pr775C5oIXGB6ecacfpKIPZrz56U40DVPUlnf09l9GaOFrDoE8RZH4vaDlTFUPQ4LmoteK64gosIqOFdvNe1hfNqnAQ8mcWs7Sz+2WItzFIzib1ZqIo8Uf1Olqn6DBCMiXfJiXG5EPCr9FRIF0cY9i8OqmeTO4nO2L324g2yyDyLclYf1nX3KiC5WqkFonl9s1zbOImBNFwn4pYGmlNrqynwDmvvKMjcRFjO4LrpJrxhng5JK5Dksspylz5nHL5G/5pE9nDLTJ0TPRrHkoDqE6F7tFLMHdUEpzAlJ2qfdyXMZY/FfYM/1XvGg2DUwqPjP50yr0DZBvnvHVrTanIQwa7VzPG9T0+Ogb4ganSsfQB7oDtf6rI0HW9VVCB/oESOTvA8Sdgk8IUY7SXOSGGowhIeoeI4mHyDHhAntWm+Pp5m9WTKHdcgaT0X+ABah8LsL+qwdmVMu9CNAn9UNk7fwbOMTgmeXnFgQrE7Yo5+S3TiyplXm1gHSN2pyszrEqDJygDuVvq/5mdVsIyEPydCFKKiN/eIkKaZIxOLIVZ9/gfrKeHVzLFVg+rucsnX+XplALaM5iOQYb4EoIl7DSQQNoDGdt6/BMINGdSXvTgDG81G8FmhreLn4zgW3wYo+rS/a108L7WFLSfskb7/O+QhyCCYvo/UcmMUKRghbds/igPIf8f6deBfWahx78lhwUp0Oa2jVjO4JdCBYls2trRx2JKeY6ct/8uBJ0xUhtEcXpkP/UmHPEBiC4hqLM1A
 jOb+DDfc
 XycYet0nZUDAfTvZnhraSaryiW6sQD3Wl3pcKiBH+AcYJgDfRMCvpq1FUqU0sgPGAfd2BABapuSYSIOEoXQIeCfCzMk34VSVinW78rnnA/sQM3ve4+oTYLErd7piVBmB3PuLwuNl1awFMVNIidYtQLR504aiPirGzru83paDN/tCB+dPG/IHPMMCNDn1lcIg5uY0xzwX2YX+eAu4XIv/9/HGdKWdKviEYqwN2F6cm9TOix5zPh4DVHl6sSIZWxDYrhf0JHpMtdN9EXdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 1:09=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
>
> On Fri, May 22, 2026 at 08:24:01PM +0000, David Matlack wrote:
> >During PCI enumeration, the previous kernel might have passed state abou=
t
> >devices that were preserved across kexec. The PCI core needs to fetch
> >this state to identify which devices are "incoming" and require special
> >handling.
> >
> >Add pci_liveupdate_setup_device() which is called during device setup
> >to fetch the serialized state (struct pci_ser) from the Live Update
> >Orchestrator. The first time this happens, pci_flb_retrieve() will run
> >and convert the array of pci_dev_ser structs into an xarray so that it
> >can be looked up efficiently.
> >
> >If a device is found in the xarray, the PCI core stores a pointer to its
> >state in dev->liveupdate_incoming and holds a reference to the incoming
> >FLB until pci_liveupdate_finish() is called by the driver.
> >
> >This ensures proper lifecycle management for incoming preserved devices
> >and allows the PCI core and drivers to apply specific Live Update
> >logic to them in subsequent commits.
> >
> >Drivers can check if a device is an incoming preserved device (e.g.
> >during probe) by calling pci_liveupdate_is_incoming().
> >
> >CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
> >domain and bdf can be guaranteed to fit in an unsigned long and be used
> >as the xarray key.
> >
> >Signed-off-by: David Matlack <dmatlack@google.com>
> >---
> > MAINTAINERS                    |   1 +
> > drivers/pci/Kconfig            |   2 +-
> > drivers/pci/liveupdate.c       | 230 ++++++++++++++++++++++++++++++++-
> > drivers/pci/liveupdate.h       |   5 +
> > drivers/pci/probe.c            |   3 +
> > include/linux/pci_liveupdate.h |  13 ++
> > 6 files changed, 251 insertions(+), 3 deletions(-)
> >
>
> [snip]
> >
> > static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
> > {
> >-      args->obj =3D phys_to_virt(args->data);
> >+      struct pci_ser *ser =3D phys_to_virt(args->data);
> >+      struct pci_flb_incoming *incoming;
> >+      int ret =3D -ENOMEM;
> >+      u32 i;
> >+
> >+      incoming =3D kmalloc_obj(*incoming);
> >+      if (!incoming)
> >+              goto err_restore_free;
> >+
> >+      incoming->ser =3D ser;
> >+      xa_init(&incoming->xa);
> >+
> >+      for (i =3D 0; i < incoming->ser->max_nr_devices; i++) {
> >+              struct pci_dev_ser *dev_ser =3D &incoming->ser->devices[i=
];
> >+              unsigned long key;
> >+
> >+              if (!dev_ser->refcount)
> >+                      continue;
> >+
> >+              key =3D pci_ser_xa_key(dev_ser->domain, dev_ser->bdf);
> >+              ret =3D xa_insert(&incoming->xa, key, dev_ser, GFP_KERNEL=
);
> >+              if (ret)
> >+                      goto err_xa_destroy;
> >+      }
> >+
> >+      args->obj =3D incoming;
> >       return 0;
> >+
> >+err_xa_destroy:
> >+      xa_destroy(&incoming->xa);
> >+      kfree(incoming);
> >+err_restore_free:
> >+      kho_restore_free(ser);
> >+      return ret;
>
> Hmm.. This is interesting, so the KHO state is freed and it cannot be
> reused. I see you already pointed out that we are putting an LUO policy
> to say that the retry is not allowed.
>
> But what should be the behaviour of liveupdate in this regard? Let the
> system boot in a normal way? This might break other subsystems as they
> might depend on PCIe restoring state properly. Also I think some of the
> PCIe state, like device-id, BAR addresses, ACLs etc, might be used as
> source of truth by other components.
>
> For example, lets say FLB retrieve() of PCIe fails, but succeeds for
> VFIO/IOMMU, now VFIO/IOMMU are restoring state of a device that is not
> restored/preserved?
>
> Should this be considered fatal?

If PCI FLB retrieve fails then there are certain things that cannot be
guaranteed, such as BDF (B specifically) remaining constant. This
could lead to memory corruption as the IOMMU may have live
translations in place for those specific RequesterIDs. And, in the
future, preserved devices may be doing P2P which depends on BARs not
moving. If the PCI core cannot retrieve the FLB saved by the previous
kernel, it cannot make these guarantees.

So yeah I think you're right that PCI core should treat FLB retrieve
as fatal and just panic.

> > }
> >
> > static void pci_flb_finish(struct liveupdate_flb_op_args *args)
> > {
> >-      kho_restore_free(args->obj);
> >+      struct pci_flb_incoming *incoming =3D args->obj;
> >+
> >+      xa_destroy(&incoming->xa);
> >+      kho_restore_free(incoming->ser);
> >+      kfree(incoming);
> > }
> >
> > static struct liveupdate_flb_ops pci_liveupdate_flb_ops =3D {
> >@@ -270,6 +335,91 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
> > }
> > EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
> >
> >+static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
> >+{
> >+      struct pci_flb_incoming *incoming =3D NULL;
> >+      int ret;
> >+
> >+      ret =3D liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **=
)&incoming);
> >+
> >+      /* Live Update is not enabled. */
> >+      if (ret =3D=3D -EOPNOTSUPP)
> >+              return NULL;
> >+
> >+      /* Live Update is enabled, but there is no incoming FLB data. */
> >+      if (ret =3D=3D -ENODATA)
> >+              return NULL;
> >+
> >+      /*
> >+       * Live Update is enabled and there is incoming FLB data, but non=
e of it
> >+       * matches pci_liveupdate_flb.compatible.
> >+       *
> >+       * This could mean that no PCI FLB data was passed by the previou=
s
> >+       * kernel, but it could also mean the previous kernel used a diff=
erent
> >+       * compatibility string (i.e. a different ABI).
> >+       */
> >+      if (ret =3D=3D -ENOENT) {
> >+              pr_info_once("No incoming FLB matched %s\n", pci_liveupda=
te_flb.compatible);
> >+              return NULL;
> >+      }
> >+
> >+      /*
> >+       * There is incoming FLB data that matches pci_liveupdate_flb.com=
patible
> >+       * but it cannot be retrieved.
> >+       */
> >+      if (ret) {
> >+              WARN_ONCE(ret, "Failed to retrieve incoming FLB data\n");
>
> I think this should probably be considered fatal as mentioned above or
> the caller of this function should get an error so it can fail. I think
> retrievel of preserved state should generally not fail unless there is
> memory corruption or ABI is incompatible.

Yeah. I think I will just call panic() here to cover all cases.

> >+              return NULL;
> >+      }
> >+
> >+      return incoming;
> >+}
> >+
>
> [snip]
> >+
> >+static inline bool pci_liveupdate_is_incoming(struct pci_dev *dev)
> >+{
> >+      return false;
> >+}
> > #endif
> >
> > #endif /* LINUX_PCI_LIVEUPDATE_H */
> >--
> >2.54.0.746.g67dd491aae-goog
> >
>
> Sami

