Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72494CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 09:20:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B47E6B0092; Wed,  7 Oct 2026 05:20:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565366B0093; Wed,  7 Oct 2026 05:20:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 459176B0095; Wed,  7 Oct 2026 05:20:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D0D76B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 05:20:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 129E24014F
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:20:53 +0000 (UTC)
X-FDA: 85295285586.30.32EDBF1
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0FD91140007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 09:20:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SQerjTB7;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791364851;
	b=hjI9PHy6DH+t1jxL4CNvqIzwEAPKthOSIH6/Yy3lMEdbQjiTChmImJA9DD5dpXcXkTzNYJ
	0m3a5a5FJd53yaEiqVhRo9cMDlbtqrKIla7Df8sqFfW9tZ2pECVCbVvY2JCePrESUf+0ok
	W7YO0ZNr1s2QgAIhwvCqMbZSIUdu2oQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SQerjTB7;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791364851;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UdaN2NeMzE/Rao2EARyiWDkHNBqdlWxbGIw0jAWrMrE=;
	b=Qpcs4X15kjiUdgVf4c9Bs+/1ANB5gE3oolmE0JQKoq7XzMSIk3/ofIxTebZlKPaUa5eopa
	5ekrqzUNUAUlSrnqayx/dawC0Kclp0rcof4Yr8GUl5cpFM0YU4h5Fq+j+YybvtXum0mbvJ
	QV1gyaDFokPWJkYnP3lPzT4mKsbCbQQ=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c2e6df2742cso212426966b.2
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 02:20:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791364849; cv=none;
        d=google.com; s=arc-20260327;
        b=mK+l+baFv45XvhB9F9By8JC7q9c7Buoqjyiv6rYlUv6zhpp2m3eWBvpgpegtIEL0Tw
         6fnxeK09Sph5023dng8ZBCaKbkl6dsw/S9rzLzUz9dLMVJVNQNB7oR4hxqRBqxppj8F5
         4WuozcHIWwGFdso16+beKt/R/HYTRPFDNKD1lrLATKTwNo1MMZHl6T0NLJGShLquPsEW
         0I+9ZJazkElFA0Fq5U0fRjCNyoxzj9XOIFZ9csfor/Em2MClAGrFu6EJlhlfjFpANfn8
         1rTxoh4UF4W4c3/aPUsXduHpTYKZBxFs+HZUoDz7ZmOipYJWUKlOFjoIAGlGBLSPuNR0
         V2SQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UdaN2NeMzE/Rao2EARyiWDkHNBqdlWxbGIw0jAWrMrE=;
        fh=wmFc6+doT+MQtx/R0zqpvDARaRSiUpzjUDnDXsGy8FA=;
        b=HkML0WsWRbkJvZipha/BofM+FOn4x4AaAqpOkEVy+AoNNvJwLUYX9a3g5YDDmlrZ60
         JSqZHFjgOGTtJ284UTRoFuGlKeFUignjioWR0ZyrrwCkIPSP9Laryb9pN9+zxT32KOfk
         rqL+6T8whv8b/2rFkQhHo6HRXTItrv4rnBE8zgLxuKHLlf97kyfWODjxOC0Ufw8TGzUw
         euHi1RwyFNK32HYyoAgkx6HntUVch4bJi+82tkRAH+cEkjKMzJ1fvpf5xvLENlLPb3ZI
         nt9SJNsNnh8yPkIqQv8gkwMFxlHArfQT7lD1qgQ1lEg6nJ8+3kizokCDOS5Bc3oxZZnN
         11cw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791364849; x=1791969649; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UdaN2NeMzE/Rao2EARyiWDkHNBqdlWxbGIw0jAWrMrE=;
        b=SQerjTB7oJa4hFpBq7LueyMj8/f/K++NFhIqE5+kd5rZFQFTaTGv2Pdbi0qE/jzkwC
         iSPEUVeE5IjhX+OXvoeMVRZMPX6bvmdY+Ewn12iSTc0SfKt72IHI8iOyQ1XtsivPW8CH
         x08d3UzUbnsUiwbmLlBvjDs0KDF0lTVQH2VDYFbFPj1bl546u3Cz0Uif5ozLb+XN1Zg2
         HERV+zcf0EZbdy4W3unvk/LHFxYMSuxdnlf7BVrDVmhsPWT6Z/L0jFW6ysqIlWQ1CEpB
         tocvI/SNkAsOY5+BlTx60eveLrHfIOYEJkocThtoNPYIPfJq7eLmaddMWVn2w1WhEXlv
         BRSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791364849; x=1791969649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UdaN2NeMzE/Rao2EARyiWDkHNBqdlWxbGIw0jAWrMrE=;
        b=TdbhJf3KX+gFShmXfcRNk5do0Q3OFsd9xsxfH1FZ1x6HsW/Gf0czHc+ML2uQhoJ/2k
         mOOs2So2RPD8vp8B+Aqm4b1F4Y1WnlUVaCp3xPy80nLd6xjUFouVKQVr8tI8evQdxIjg
         2wKN8nI9uuY91pdm3+72skvtruVXdLxeFPRRzMSihDNGyv3KN0r5sfOt4bK8/z5EDmSU
         n2AO7BqKAO+NUmkweiwSD2AZp/MO08q/WKEB80TgMdNp83I+kUe1kwviU5MLGsOXG/+X
         tpPuTqPcUz+6G8G19CcJ499omGcI46j2HBjDccTnUlnBla0zk1nh34MQkfO76NOi3InV
         g7Qg==
X-Forwarded-Encrypted: i=1; AKwUvBzVEMqUyTr013syicvwTiSQgLvrIDSOI/5if/R29Pvp6+NsruivoUOS714f9WHIPqwEzegOjgwLIQ==@kvack.org
X-Gm-Message-State: AFq9FYJAB8bpexleLHUDD6XOlO6+yVmyrSOe1Jem5MVJGzscWOnWHloa
	wB/92u+SamolU5kUBhTqVblkIOCfX9yYz3E6rxrzv4Qlb8fRcloU5uMMOy4MkxXLOE3y12F8T9T
	FjxQvELbNSQPe3He1+PwBgwVvyHe1k2E/r/sIveE8
X-Gm-Gg: AYBFou3gIff74puTiKmCOXiBmHlgxBark4PFngaHjyYZA0pf/bvRODJEY7y5Jfi3F6q
	Hm7eXE5JDqcpIgPlcgdCe0ty6lLuBngO/F8SeIbLyGWO52BZTz/sY2fB+FQx6VTmCawzi7l9MXC
	NomWNqUW8uPJm5NNG9lyWrUjyUY77Pfe27rywiY7+EU9o6Pre+hOMqzHQxQOY8Czb7dhOuEBMM6
	/1WdVqfaPG5K0bVJMtwb3LrPH4JzNkiQUI2d9kcjXN3VtCxEdiLqKirWA/zdPjyQtE7DGijNASP
	oUUM55F+RHbmKQ9v14gpAME6cDnrpli2TcaqQCOxG5AYtmOpz1E6syI=
X-Received: by 2002:a17:907:1c84:b0:c2e:4705:467c with SMTP id
 a640c23a62f3a-c317bd450f0mr150496666b.10.1791364848404; Wed, 07 Oct 2026
 02:20:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com> <20260918200640.887030-9-dmatlack@google.com>
 <20260918191846.2f68b23b@shazbot.org> <arGVMaxfwEw_PkXy@google.com>
In-Reply-To: <arGVMaxfwEw_PkXy@google.com>
From: David Matlack <dmatlack@google.com>
Date: Wed, 7 Oct 2026 02:20:16 -0700
X-Gm-Features: AclHuK_PI8zGCsZyvrqP1bU2CJDBBfSkmQGW03sa119GkyMLIb-ErHKkHiE7tWM
Message-ID: <CALzav=eTrH4WNPYNWAwmYSEw_imOXwRqf9y7zPDmC27dVE0zBw@mail.gmail.com>
Subject: Re: [PATCH v9 08/13] PCI: Save and restore the ACS Control register
To: Alex Williamson <alex@shazbot.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wmgmf7eisnkf1tpr4igswkqujdyqamif
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0FD91140007
X-HE-Tag: 1791364850-471896
X-HE-Meta: U2FsdGVkX19pEDrrHeI+TLHYyqqRbTADVZ5LYT8MRDVMOzUZC8N+C6b3IGC8umyMtHYxHB4LbarmntmfbTb70z1KrlPde+du64lNM2fkM9XCV0E3C88D8/bb0hDrBQJ6NJddH4JBWFSpm1nbq9ywNLo/JuRXruT5MrcKym8WdIBUlWRF36slQj5P8KGqocQgO+mWyJY/dhuNxg/Rmuhi+jQu8YiEmvY09hOG9m8CjVTcIT3R030qAgpRllXhQy1iVT7w69ytsZsbY0Aw4jP5VsmRX5AGOvDzgWAEKSdYYZ0KkUOsZkDFOzVAjhjpbYi8vrlZDFqRCX2axQWpeakErd0Ul9MVoISrDU0nWftNno+L1l6ivPcHtSCYP4D3/gmtFyKgDwj3BwXhcS3l2bv9t4WQZmA2QW7oQQpIzZfFtLe3CXxC3pLyaaiG1nESYQTeXPLRZ3wgnAuSdQYDX1pMK5nltToMIOG266i3vsxjR+Ft81+VjoQX5jE3mHgN31y3I66VrWaLUPm/vWTb5KvRafRfLKz4Y4WWGWLgpdN1iahDJHPbc6K9jpULFdRdXxpxbJnZip/0Y3b4OPxdruDOd5GST1wL9Ise3SkinHfrOwzAxDQ4/+cUm0NL3HYZv1IXjAyPnF5tTZf6aOqsBrFibUzIZjXlytJCHHnqI5cFjCxYtthHZ5EcCr7PebR+IIlF14QddwIx6gDmgJ4X6U/F1HcxyJoOG7rjP16aotEDiwsBcM7AZwBT3mGuCJQz/8BKuZV4cDnWKuaZ9yiSzlcQbuCRGPq3N79vw2DzR3z+e0pMeIigZpgo/fUbiVsePLbkTb7DZZL+9c5GFu8HCwiJL9BwB8jVqdczQgYxZWP2AOazfHKqc91AqLZ9YxvKSZ2PGVvMkBWG6+oBJIn1rYxT6MoWP9AKemR2ZOwpP2U3T/QPPA8Tx6/Fy2sDeyBc+woHtdQNAAe1lBAXj63zd1I
 mi/Zio1H
 xzglfbaE5eUqbM2uCNSukPffpqQ0CLMvlz0CjFdSJ5ileLECgnuf1YNxOeBNzdim39m9u8xv04CtNBXa6JvK/uI15iayMxY6WogQgva0pzU/PElx8XWt37miznkrQvrvHQwRkmerRrvBmIA0i7vrMQAEiEx2C8IlB6QCuxPFF7UQIh/vOY5DrtjvCyUm65KNpYsiXbXq2fXhzXMSaECOOITJz7ul2egaWi6mxLokDqOJqrzhGfF7y6jSzgD9pQAqIXy18gkgicl8TK7M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 1:36=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On 2026-09-18 07:18 PM, Alex Williamson wrote:
> > On Fri, 18 Sep 2026 20:06:34 +0000
> > David Matlack <dmatlack@google.com> wrote:
> >
> > > Save the ACS Control register in pci_save_state() and write it back
> > > in pci_restore_state(), instead of recomputing the ACS controls from
> > > scratch with pci_enable_acs().
> > >
> > > This makes ACS symmetric with the rest of a device's saved state. Tod=
ay
> > > pci_save_state() ignores ACS entirely and pci_restore_state() re-enab=
les
> > > the ACS controls from the kernel's current ACS policy. As a result, a
> > > device can come out of a reset with different ACS controls than it we=
nt
> > > in with, e.g. any controls programmed outside of pci_enable_acs() are
> > > silently dropped.
> >
> > Controls, yes, but if we're restoring controls that might have EC set
> > now, should the Egress Control Vector also be part of the save state?
> >
> > Currently EC always gets cleared on reset and won't be restored by
> > pci_enable_acs(), so we can lose both EC and the EC vector.  With this,
> > I think we restore EC but still lose the EC vector.  Thanks,
>
> The kernel does not enable Egress Control today or program the vector.
> Would this be to cover the case where firmware or userspace enabled it?
>
> Here is an updated patch to save/restore the vector, but I don't have
> any devices that support Egress Control on my normal testing system so I
> haven't been able to really test it yet.

Hey Alex, gentle ping on this.

This series is merged into the liveupdate tree to get linux-next
exposure ahead of 7.4 merge window. If this patch needs a respin or a
fixup I'd like to get the ball rolling on that.

I think the 3 options are:

1. Keep the patch as is based on the understanding that the kernel
does not enable EC today or program the vector.
2. Save/restore the EC vector (the below patch).
3. Clear EC on restore to preserve the current behavior.

And if we decide to do (2) or (3) then that could be done with a
respin of the patch ahead of the merge window, or a fixup patch on top
to send in a later rc.

Thanks!


>
> From: David Matlack <dmatlack@google.com>
> Date: Fri, 11 Sep 2026 20:05:04 +0000
> Subject: [PATCH] PCI: Save and restore the ACS Control register and Egres=
s
>  Control Vector
>
> Save the ACS Control register and the ACS Egress Control Vector in
> pci_save_state() and write them back in pci_restore_state(), instead of
> recomputing the ACS controls from scratch with pci_enable_acs().
>
> This makes ACS symmetric with the rest of a device's saved state. Today
> pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
> the ACS controls from the kernel's current ACS policy. As a result, a
> device can come out of a reset with different ACS controls than it went
> in with, e.g. any controls programmed outside of pci_enable_acs() are
> silently dropped.
>
> Notably, this prepares the kernel to be able to adopt the ACS controls
> established by a previous kernel across a Live Update rather than
> assigning new ones through pci_enable_acs().
>
> Save and restore the Egress Control Vector as well to keep it in sync
> with the now-properly-restored Egress Control Enable bit in the ACS
> control register. The kernel never enables Egress Controls or programs
> the vector, but the firmware could have and they need to be kept in sync
> to avoid changing how P2P traffic is rounted.
>
> The size of the Egress Control Vector is not known when
> pci_allocate_cap_save_buffers() runs, as the ACS Capability register is
> only read later, in pci_acs_init(). Rather than move the allocation,
> size the save buffer for the largest vector a device can implement,
> which costs at most 32 bytes per ACS-capable device.
>
> pci_enable_acs() runs when a driver binds to a device
> (pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
> the device's state. Refresh the saved ACS state there as well, otherwise
> a subsequent reset would revert ACS back to the configuration left
> behind by firmware.
>
> Devices that rely on device-specific quirks to enable an ACS equivalent
> keep that configuration outside of the ACS Control register, so keep
> configuring ACS from scratch for them. Do the same for devices that have
> no saved ACS state at all.
>
> Assisted-by: Claude:claude-opus-5
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  drivers/pci/pci.c             | 117 +++++++++++++++++++++++++++++++++-
>  drivers/pci/pci.h             |   5 ++
>  drivers/pci/quirks.c          |   7 ++
>  include/uapi/linux/pci_regs.h |   1 +
>  4 files changed, 129 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
> index b2879a6be5f8..e1c05866e2ee 100644
> --- a/drivers/pci/pci.c
> +++ b/drivers/pci/pci.c
> @@ -1021,6 +1021,106 @@ static void pci_std_enable_acs(struct pci_dev *de=
v, struct pci_acs *caps)
>                 caps->ctrl |=3D (dev->acs_capabilities & PCI_ACS_TB);
>  }
>
> +/*
> + * Layout of the ACS save buffer. @ecv holds the ACS Egress Control Vect=
or and
> + * is sized for the largest vector a device can implement.
> + */
> +struct pci_acs_saved_state {
> +       u16 ctrl;
> +       u32 ecv[8];
> +};
> +
> +/*
> + * Return the size in bytes of the ACS Egress Control Vector, or 0 if th=
e
> + * device does not implement P2P Egress Control.
> + */
> +static unsigned int pci_acs_ecv_size(struct pci_dev *dev)
> +{
> +       unsigned int bits;
> +
> +       if (!dev->acs_cap || !(dev->acs_capabilities & PCI_ACS_EC))
> +               return 0;
> +
> +       /* An Egress Control Vector Size of 0 means 256 bits */
> +       bits =3D FIELD_GET(PCI_ACS_EGRESS_BITS_MASK, dev->acs_capabilitie=
s);
> +       if (!bits)
> +               bits =3D 256;
> +
> +       /* The vector is implemented as a series of DWORD registers */
> +       return round_up(bits, 32) / 8;
> +}
> +
> +/**
> + * pci_save_acs_state - save the ACS Control register and Egress Control=
 Vector
> + * @dev: the PCI device
> + *
> + * Record the ACS configuration currently programmed in hardware so that
> + * pci_restore_acs_state() can reapply it after a reset.
> + */
> +static void pci_save_acs_state(struct pci_dev *dev)
> +{
> +       struct pci_cap_saved_state *save_state;
> +       struct pci_acs_saved_state *acs;
> +       unsigned int i, dwords;
> +
> +       if (!dev->acs_cap)
> +               return;
> +
> +       save_state =3D pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
> +       if (!save_state)
> +               return;
> +
> +       acs =3D (struct pci_acs_saved_state *)save_state->cap.data;
> +
> +       pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &acs->ctrl=
);
> +
> +       dwords =3D pci_acs_ecv_size(dev) / sizeof(u32);
> +       for (i =3D 0; i < dwords; i++)
> +               pci_read_config_dword(dev, dev->acs_cap + PCI_ACS_EGRESS_=
CTL_V +
> +                                     i * sizeof(u32), &acs->ecv[i]);
> +}
> +
> +/**
> + * pci_restore_acs_state - restore the ACS Control register and Egress C=
ontrol
> + *                        Vector
> + * @dev: the PCI device
> + */
> +static void pci_restore_acs_state(struct pci_dev *dev)
> +{
> +       struct pci_cap_saved_state *save_state =3D NULL;
> +       struct pci_acs_saved_state *acs;
> +       unsigned int i, dwords;
> +
> +       if (dev->acs_cap && !pci_need_dev_specific_enable_acs(dev))
> +               save_state =3D pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID=
_ACS);
> +
> +       /*
> +        * Devices that rely on device-specific quirks to enable an ACS
> +        * equivalent keep that configuration outside of the ACS Control
> +        * register, so there is nothing useful to restore for them. Conf=
igure
> +        * ACS from scratch instead, which also covers devices that have =
no
> +        * saved ACS state at all.
> +        */
> +       if (!save_state) {
> +               pci_enable_acs(dev);
> +               return;
> +       }
> +
> +       acs =3D (struct pci_acs_saved_state *)save_state->cap.data;
> +
> +       /*
> +        * Restore the Egress Control Vector before the ACS Control regis=
ter.
> +        * The vector resets to zero, so enabling P2P Egress Control firs=
t
> +        * would briefly apply the reset vector instead of the saved one.
> +        */
> +       dwords =3D pci_acs_ecv_size(dev) / sizeof(u32);
> +       for (i =3D 0; i < dwords; i++)
> +               pci_write_config_dword(dev, dev->acs_cap + PCI_ACS_EGRESS=
_CTL_V +
> +                                      i * sizeof(u32), acs->ecv[i]);
> +
> +       pci_write_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, acs->ctrl=
);
> +}
> +
>  /**
>   * pci_enable_acs - enable ACS if hardware support it
>   * @dev: the PCI device
> @@ -1057,6 +1157,15 @@ void pci_enable_acs(struct pci_dev *dev)
>         __pci_config_acs(dev, &caps, config_acs_param, 0, 0);
>
>         pci_write_config_word(dev, pos + PCI_ACS_CTRL, caps.ctrl);
> +
> +       /*
> +        * pci_enable_acs() runs when a driver binds to the device, i.e. =
after
> +        * pci_bus_add_device() has already saved the device's state. Ref=
resh
> +        * the saved ACS state so that a subsequent reset restores the
> +        * configuration programmed here rather than the one left behind =
by
> +        * firmware.
> +        */
> +       pci_save_acs_state(dev);
>  }
>
>  /**
> @@ -1800,6 +1909,7 @@ int pci_save_state(struct pci_dev *dev)
>         pci_save_aer_state(dev);
>         pci_save_ptm_state(dev);
>         pci_save_tph_state(dev);
> +       pci_save_acs_state(dev);
>         return pci_save_vc_state(dev);
>  }
>  EXPORT_SYMBOL(pci_save_state);
> @@ -1877,7 +1987,7 @@ void pci_restore_state(struct pci_dev *dev)
>         pci_restore_msi_state(dev);
>
>         /* Restore ACS and IOV configuration state */
> -       pci_enable_acs(dev);
> +       pci_restore_acs_state(dev);
>         pci_restore_iov_state(dev);
>
>         dev->state_saved =3D false;
> @@ -3532,6 +3642,11 @@ void pci_allocate_cap_save_buffers(struct pci_dev =
*dev)
>         if (error)
>                 pci_err(dev, "unable to allocate suspend buffer for LTR\n=
");
>
> +       error =3D pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_ACS,
> +                                           sizeof(struct pci_acs_saved_s=
tate));
> +       if (error)
> +               pci_err(dev, "unable to allocate suspend buffer for ACS\n=
");
> +
>         pci_allocate_vc_save_buffers(dev);
>  }
>
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index ba3c3fddddc2..037c1674f164 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -1095,6 +1095,7 @@ void pci_acs_init(struct pci_dev *dev);
>  void pci_enable_acs(struct pci_dev *dev);
>  #ifdef CONFIG_PCI_QUIRKS
>  int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
> +bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
>  int pci_dev_specific_enable_acs(struct pci_dev *dev);
>  int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
>  void pci_disable_broken_acs_cap(struct pci_dev *pdev);
> @@ -1105,6 +1106,10 @@ static inline int pci_dev_specific_acs_enabled(str=
uct pci_dev *dev,
>  {
>         return -ENOTTY;
>  }
> +static inline bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
> +{
> +       return false;
> +}
>  static inline int pci_dev_specific_enable_acs(struct pci_dev *dev)
>  {
>         return -ENOTTY;
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 7aee30734303..e500c202d2ec 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -5476,6 +5476,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs_o=
ps_get(struct pci_dev *dev)
>         return NULL;
>  }
>
> +bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
> +{
> +       const struct pci_dev_acs_ops *p =3D pci_dev_acs_ops_get(dev);
> +
> +       return p && p->enable_acs;
> +}
> +
>  int pci_dev_specific_enable_acs(struct pci_dev *dev)
>  {
>         const struct pci_dev_acs_ops *p =3D pci_dev_acs_ops_get(dev);
> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.=
h
> index facaa324bd86..66359cb94f0d 100644
> --- a/include/uapi/linux/pci_regs.h
> +++ b/include/uapi/linux/pci_regs.h
> @@ -1023,6 +1023,7 @@
>  #define  PCI_ACS_UF            0x0010  /* Upstream Forwarding */
>  #define  PCI_ACS_EC            0x0020  /* P2P Egress Control */
>  #define  PCI_ACS_DT            0x0040  /* Direct Translated P2P */
> +#define  PCI_ACS_EGRESS_BITS_MASK 0xff00 /* Egress Control Vector Size *=
/
>  #define PCI_ACS_EGRESS_BITS    0x05    /* ACS Egress Control Vector Size=
 */
>  #define PCI_ACS_CTRL           0x06    /* ACS Control Register */
>  #define PCI_ACS_EGRESS_CTL_V   0x08    /* ACS Egress Control Vector */

