Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5286ACCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 21:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70D2F6B00C0; Thu, 30 Apr 2026 17:23:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDF66B00C1; Thu, 30 Apr 2026 17:23:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AC9C6B00C2; Thu, 30 Apr 2026 17:23:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48A706B00C0
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 17:23:02 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5641C0F16
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:23:01 +0000 (UTC)
X-FDA: 84716497362.23.BE58756
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id BB055A000B
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:22:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v9265yOp;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777584179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VDdDBeOth/GyO4S6LG5C4tIpCfmXMPVkXYvoyOVLmpc=;
	b=qdNnK29EBvdxk0CT5ebNcNIoj0RAeGMN/8JqurN4C/j+jYo8WtXJrVFGsZgqQ6mG3pAn9R
	hIbU01PVb7PL9B71B/Ru6OFyY80LTRfl/cOfhTDV3FjZMnpkU5JUqqo9tShn8Bs6hZzZ3+
	tw2ln7WGnG2KPueTPxWM2xgM1M2l/ws=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v9265yOp;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777584179; a=rsa-sha256;
	cv=pass;
	b=gWaJnMrRhILnzazcVefIqNv6hWwCL4txmYDTA6QPYjCcNsCrtMfhJowBFDMTQ2iqDe0jdW
	MeEpGDVtcs8Eq/1C7nuCT2xDI5TgyHdNMdsdMV7ucqDkDI2XUbU1kbLC9CSG6hYdJwmFD/
	OUTpDqkIgAuaAEq3FlxT8YCNnFrJbeo=
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-610aadb2d9fso460264137.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:22:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777584179; cv=none;
        d=google.com; s=arc-20240605;
        b=VA0eTXH6N1eZSZh7kTLAkUS9xRWRup4pxsn8IwNXhcYtMzr1XZu+VsvsRfArTSYZBH
         zuRcPojCNrBBbqnklFuv6Zr52Pt48uAe6VJyQG8swC/8Q8u2FdG93aMVuqmteYgdDNq5
         OE2AhGyKB/YK40rDJXSRVszhCzvfcP6Q1FfnntQVdeEqqlqz88xHuq7jFvi+QAo9T+ja
         Trs5TneEnzjSREUeVhi4fMHOEk5KPuG4js55X0Cfy+q4ck3LcGiKDpIcB0ev6i4HotSH
         CdGda6uRMD3x/fuU32T3oPHgyPZFmVHhdP+veeb+OGVImlJ7V8kVKfHfLtuYGHK4CO9m
         f+lQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=VDdDBeOth/GyO4S6LG5C4tIpCfmXMPVkXYvoyOVLmpc=;
        fh=x2yns1yBNI5dZuUrymhTiAVjiYVjR2f1VOEUMtjPo7s=;
        b=fJ86Nt220Yej7m3xy9ieNVBsJDMQgQaTpwPcUc7y+xh8s5Uu5KCMLOdBtXDJjX+IN1
         id/mrww2X04PUCRWCk6l3BuB3Swbp8S5xMzWo16O5OTFLrARjySmMM8saCa0R3aUYrOP
         FAPpP6pJS7eh4hibH2m6lMWjIkJdISymOCq2OzblYHvrQR1nR5508uRBjKDFAY2BnzZD
         DFnW2+hMRY39gMJDhHnmxvMNqb+nITzA7qcoswUY1TdqCyNZEURdHWwKq/EQIkgjygvq
         8d1qhARIJPd5iBUuggIQQ7HM7B6QnE0E5qiDzLDFF2+TzHNmZ0/iCrpwfRgvigOcyNfI
         ET+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777584179; x=1778188979; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VDdDBeOth/GyO4S6LG5C4tIpCfmXMPVkXYvoyOVLmpc=;
        b=v9265yOpqAJxzdFxTPM0KiP6FJPX5u/IwDWvikHbWdXhFE4plgEb0PP0mPkB30zAWW
         j/szGFkP/Kdr7WZVdsdXgKp1+vvNJJSlbWtRn6TIGppxKP8dMaNnx6J3LDepc1ruwPKy
         qoHc6mJqQDM7av6cebidJIoQ7UcvXYLZrinDPQwh1vxrb4y98GCezJ1CJJv1qtBy/h3i
         6T0pL+grsah/gA8mGkUm07uDNcSNk2J4UfwxqBqT7NaKtClFOeiLRNYjZSokFQFX/xtK
         dyZ6POcKzUe+sbLiqUbbtVqOCwMsAhpZNfF9na7d8bYvKn4aEnroB7Hb8vYuUftlGNdY
         uOzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777584179; x=1778188979;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VDdDBeOth/GyO4S6LG5C4tIpCfmXMPVkXYvoyOVLmpc=;
        b=ePvtZdIbf6zUFY+PsSxKT+oK+51OTvmBE8imDsIouUx6+OJeOs8XA0SA39sdT7VhqA
         +OSEuTwiC2H8FGEA06pnFDSTECaiHJ3KwXzfZcBmIm5aGcFRsETvrKZ217L6HHqQUA9J
         VwlyyEOuQMSWcFzcoQEJJexTmPuqvRFNiuKvAcjA77TZlFoL0u/wW5a6IO6mIFQKCo9C
         4Pomg9mvOoXebjRcGZTzTywdsTbRctdgBI/JoeiLMJw+ONGH4iL6JoT0RBVEgDvaoo7p
         UhXYjHO23bSC9U/MmYrI57RviSjhQJS5cIgCXzzXmZxV1+TJj10qiESFIPwnDRFhrORn
         MeIQ==
X-Forwarded-Encrypted: i=1; AFNElJ/9yM2Q0oBOoJwn2YrcHQNqp060gx43tWmNYL+wtE9oJvmhGZfL9meU8GJjua27gR/LKeE5tRgzKg==@kvack.org
X-Gm-Message-State: AOJu0Yx5iBrqKXF0vNCi+dmLNJ0KaWh4j0nKfnR5gHXVA2YD7yuVC84u
	R/j2HQ2DpHlmdCuBlNYwGwRUvodw5lvlPT0RwTJ3H1gIeGnwK2bhSIlv2iEsDRab4i+W0NsAAGk
	P+NLwVW9JvBrv2ocaYS9xhvcE3CwjAApapMynitdv
X-Gm-Gg: AeBDieuaKrIHEdW1oTnaD+i7+8pOH3LpIKKx4j0eXh4M5bV0eOsbjIe9TYiMTUl935V
	rX1mWvCslbTUD9h0Rs2xR48BH5pRLJbb9V+WGsdDY161senEy3luOI3Y+2iY4aSQGPwr8yFSCid
	61gpG/ZuQoFLuu/OPpPvflND/TBTfS4oLtfHetxHyXkI+sdOz0HkLO7+q3xLvOB9FUvZeExc8tA
	wrMbHcWb/FsEr5w5nMYxsV2HZJRgvSudyGpBRDpMILhiwfOwHeH7wPPzHH18UjtZkoxlo4hGVrr
	1E3h9p3SilQ3d7QROVqy4ql5SX1AOA==
X-Received: by 2002:a05:6102:808f:b0:60f:7499:9b6b with SMTP id
 ada2fe7eead31-62ad51bb6d4mr2567155137.29.1777584178374; Thu, 30 Apr 2026
 14:22:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com> <20260423212316.3431746-3-dmatlack@google.com>
 <20260428201231.GA3885809.vipinsh@google.com> <CALzav=dfLtdrPhkBkGwHpDAWUBMHnbGPccwhy1__doziNVZQJQ@mail.gmail.com>
 <20260430175916.GA13902.vipinsh@google.com> <afO9VOckgyiiokw8@google.com> <20260430204009.GB22297.vipinsh@google.com>
In-Reply-To: <20260430204009.GB22297.vipinsh@google.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 30 Apr 2026 14:22:25 -0700
X-Gm-Features: AVHnY4Ikcvel7QdyZYGumdrGxwhKO_qS6LiUUIjUSJt8Np0PybdhnEVt0dyw8U8
Message-ID: <CALzav=dsQ7fj3MJ8Fbv9LZMjeayOgM31c-PZZd5JVL2gov+3=Q@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI devices
To: Vipin Sharma <vipinsh@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BB055A000B
X-Stat-Signature: p7x9j3tgig6wrktz5fwppo3xr3y1um1t
X-HE-Tag: 1777584179-855918
X-HE-Meta: U2FsdGVkX1+A/EJ4BAC7Pm2+PGodJLx7scivDWp7MX4znQ5OUmuhNMV+60cw2VjBBUP0KyFcXnoUs4VYBTHqS1FWJE+W4v8H1M00hAb0oj7cs236bi3WtnFzGKwC5KObucTNFa/x+qV2PWKEeAbFfyG9PaqPJcpuQOsRZ+ZqqT2HESmA11FYq1L6YQ4bNSWMJnwvk/oLyVkZwIbLo//CoooyDzZMXBnLOx3ovpg0bY9TGS4NM+CBNxY58al+9DmEMqUk8Ret8AGX5u1KcdDpVY4Yg9W9vaPcvke+w1uY286xwJfu9oo6dkHT1oKenfbhq+rYmefbmJcCMBP3u08C0uMHZfUkIGjeseuSRJYX6tIhujP3KfFaef4FIUYkghVtBqOPZda8XhMzSxUuo7NrHpRLzQ9w96QUC0Znv3jDWS/VhdvxrKG7RginjRdcyYyJLYyez8j8oKEBGb7YrY5nOcnjvmfLlRxzohUSdOyC5qUaG5XMDy9tpVZ3/Gw5TGsz6hZqdmSB1CUaKon2gthHHIxbO+kXInsv8+fql6AGLDPTRFRPGbjH4QvmL+1rxuXcfIPt9icpahGfVaatZJ1cTN793li/vgcuP+3S0xXCHMiVm2g5qzvXstW+NGHWFBLTYdlLU517xhIw180/eARjLjbYaILb1RluKsOjsiGqB6j4gm7OvGwXGXACYiWkNud2pxrybStC2R8opYRDFj0jBCpIAFvzY/FdS6AU4u7Lm5+FfXfXf/J4c/CMB0Yi4BILs2jXtHEd2XPPQblBSyDmuevwJ0Vbexok/qlZH0prkeQLnkUGsxQJzdkiN22RlzIsIlw+45flHDp2AShWDchlws+qKsAHbKTUaiVLUqy2EDDXpCT3lxCFfogM0qRIXkcBF64d9v/a7mgJcxnybVOVkQngyINxN5NIsXepSmfGpflm7xgRgq4EsPYJIhQ+Sf+ql1ky24wWJ3BISUa/FSE
 CmhlOI05
 pU/CtBbQJ+mrWQpgJxYs/sOi+OBfqHomNzKhSZGPQCQg6YT2i+8mhL3uy7MDGoDmF5CcqJ1/eRc0ESO0QntvM8g2ECyosQ5AqVj553Zo8pL1/+dfU3E77TqTGPdmJAe+rTkZcrf8QeP9UZ7oRVg9fa9KDzIljS34pdmidm8P61FVHGkfNYRbl4dpvKRmMedceSdSeMvhzml9vWgPRnIJ+TXXd3EMdAXBnxvf81Y+L5c1KplN7IxurHsSiiGaVH2rdz9KXGkSOqMYfMh4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 1:42=E2=80=AFPM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> On Thu, Apr 30, 2026 at 08:36:36PM +0000, David Matlack wrote:
> > On 2026-04-30 11:25 AM, Vipin Sharma wrote:
> > > On Tue, Apr 28, 2026 at 02:12:13PM -0700, David Matlack wrote:
> > > > On Tue, Apr 28, 2026 at 1:20=E2=80=AFPM Vipin Sharma <vipinsh@googl=
e.com> wrote:
> > > > >
> > > > > On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
> > > > > > +int pci_liveupdate_preserve(struct pci_dev *dev)
> > > > > > +{
> >
> > > > > > +     if (ser->nr_devices =3D=3D ser->max_nr_devices)
> > > > > > +             return -ENOSPC;
> > > > > > +
> > > > > > +     for (i =3D 0; i < ser->max_nr_devices; i++) {
> > > > > > +             /*
> > > > > > +              * Start searching at index ser->nr_devices. This=
 should result
> > > > > > +              * in a constant time search under expected condi=
tions (devices
> > > > > > +              * are not getting unpreserved).
> > > > > > +              */
> > > > > > +             int index =3D (ser->nr_devices + i) % ser->max_nr=
_devices;
> > > > > > +             struct pci_dev_ser *dev_ser =3D &ser->devices[ind=
ex];
> > > > > > +
> > > > > > +             if (dev_ser->refcount)
> > > > > > +                     continue;
> > > > > > +
> > > > > > +             pci_info(dev, "Device will be preserved across ne=
xt Live Update\n");
> > > > > > +             ser->nr_devices++;
> > > > > > +
> > > > > > +             dev_ser->domain =3D pci_domain_nr(dev->bus);
> > > > > > +             dev_ser->bdf =3D pci_dev_id(dev);
> > > > > > +             dev_ser->refcount =3D 1;
> > > > > > +
> > > > > > +             dev->liveupdate_outgoing =3D dev_ser;
> > > > > > +             return 0;
> > > > > > +     }
> > > > > > +
> > > > > > +     return -ENOSPC;
> > > > >
> > > > > Since it is executing under a mutex, and we already failed
> > > > > 'if (ser->nr_devices =3D=3D ser->max_nr_devices) check above, wil=
l we ever reach
> > > > > here and return -ENOSPC?
> > > >
> > > > Yeah I wouldn't expect to ever reach here.
> > >
> > > Will you be removing it or want to keep it just in case scenario?
> >
> > I'm not sure how I would remove it. The code doesn't not compile withou=
t
> > a return.
>
> Oh, I meant, inside loop a break and outside just return 0, that way it
> won't be a dead code.

That would hide bugs if the refcounts in the array got messed up. How about=
:

  /* This should never be reached. */
  return WARN_ON_ONCE(-ENOSPC);

