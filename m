Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BEB28CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 20:57:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F1E26B0005; Mon,  8 Jun 2026 16:57:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C92E6B008C; Mon,  8 Jun 2026 16:57:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DF4A6B0092; Mon,  8 Jun 2026 16:57:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFB176B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 16:57:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 844001C162B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:57:53 +0000 (UTC)
X-FDA: 84857957226.28.2947009
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf05.hostedemail.com (Postfix) with ESMTP id A0546100010
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 20:57:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UaS6ytsR;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780952271;
	b=0LumWe7eXmokoYH9hCN8aso5DQMfAXsOq43/WGT6/SaUfkyenqS6x0yZntGXKlw1mWHA0M
	yK/Dp6iHoiu8oE7z+0cijkT8Nb2vSEuOF+E+7fhlHY5vFUvCwXIRXCLckJAGKDmqaQnb3H
	9EPwKRfUy0qrH5CupVnn3iOk+00E7JU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UaS6ytsR;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780952271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwWXYyLBedswXBpDr6XhVLr7hKW6gX2W2Wf9GCvWRA8=;
	b=0OyTNlgs8mQTfi+X5To7aVS+JaXd/2q619L/qF4F0gappZQQQAbY2a6dkkTF4XkY0id16q
	xuK0Fa3dipMFFSjEGAuh1DH8Fy4VjkrHVwGM0k19XQPHMEFgCI+XfTMNpyo9iEFy6FazCV
	FLL9Azyd8uWjkkfFTBmH7ykvp5Kvczs=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c168baac83so22138965ad.2
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 13:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780952270; x=1781557070; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KwWXYyLBedswXBpDr6XhVLr7hKW6gX2W2Wf9GCvWRA8=;
        b=UaS6ytsRDwDmqC/7YKgpAelyU9QxIDL+18a5hqgWwLifZiqITdBoBpMCatqHH+pIpb
         4Cr2Jmg5c1BYCnGw5jlJgPD4nxmZfBYXPBtVXIBEjqUQp2NvqsjqOxLuKR4N5dw8cRjC
         tLjTKfcmCUhBmZuvuYgnQR2uf8UyQEfLFP50GEVYeG8/+hTpVMfIYRGX7UvO1s55UHal
         uPN+xmzNAHOt+RvVZOGVXHRZnGTdSvO+We2BLvOLskNfgDjJ3vu8DE0w0nO0Fm+PZwEp
         hVlUbX31xZfy+w9s+o3fqrTuApvqOVmfKRGMzzmiqCY/rw070p1vit8x9zvnR1YYW0Ot
         zqYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780952270; x=1781557070;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KwWXYyLBedswXBpDr6XhVLr7hKW6gX2W2Wf9GCvWRA8=;
        b=HwLk6CYEGqr1w8oE8esmnfrdPHXX/OZZyZ3Iu4zuDztltOUoKiP0gJutdq7POfbesX
         Kky7O+sqyQR404pPStgENQPTFM945lo0YOi5u9xnJi2+u73qopqWihjKmQT2y/3vm9z0
         BywFOV4NJs1x9QUdS8n3SfX7pjwrTo7bpobhAZynNXtxqP+4IvNzA+MOF98hKjRKe1zK
         YFdoeqcVbraWmQBJxKYN4Ni5t9EUkwgMLmWSnRdoJ1NDHygUU5eo23mCxdQQ4xPHMSDu
         /tpu7TpVOh/tMzvnnUEHam/Glff8zu+Ea91m3qVYSfgkXxYTXznhvUsCgIDj1yxcBbM2
         NKhg==
X-Forwarded-Encrypted: i=1; AFNElJ/lsruzymO3ZfuyLKDVIn3p43/uPNQ2YaCILK01fa9UJkj8TMSK+Mj37nCwCp3KufvDh9Y5nZV4mw==@kvack.org
X-Gm-Message-State: AOJu0YxBZ2zg9+nuhrobAmdkwphGL1TT5okew3+9XZl0CthAJVjAgCYA
	RnCwAsfp1VAz8cHCn40vzJq1vasrwsZHnkof6aWBqCxM5cPyLjbaDOYkEEIJSs8pkw==
X-Gm-Gg: Acq92OFx1YYFhO4JTymSql0VKowxyOJWXdKn0OjDa7PAHRFfEyCw8fDtoqluI2/Xyva
	/EhdKLh1d8o5nh0khuoFEv9VEL1yIzgi2nj19Q255M39GH5nqeMIKjFLVS4j5aQNHv9XvvPrCQC
	g0jHvp2NDLL9t7hFTkSBQSGS2RQFyxK3fYXpUKm8e3+iZtsHdpI0TLjV3XMb+afj0N7ELOvOc7s
	v65ABGxqjCth7LoRqywkKF9AdKAk98DYYVZFhmR8MdtoD1PLXKLUvo9ulHk52kxLEy4dmKzwoLi
	ne6dFRGUzzXSEois2RiOCKzyjuV7mCI1pCTdzjA/cbdFnL+iID02KscMZIKmvbqlwD6eq+xqTWs
	VLAXQ+VmOJcGQ8nnaAQl1FEv6GQyGVvK34hkYBdySW4Bh9ZHf1OF59sdrJz6POAZrhuLG6hFcEn
	B0ku8XwMafE7mUKK0euYQVblvA2BiSaoKtuNm5mCU3aRK131aWi08HmA5bqFg/+j2nWSnQ5LWt
X-Received: by 2002:a17:902:6ac7:b0:2bf:bd17:90d4 with SMTP id d9443c01a7336-2c1e820b41fmr143853655ad.28.1780952269772;
        Mon, 08 Jun 2026 13:57:49 -0700 (PDT)
Received: from google.com (56.149.168.34.bc.googleusercontent.com. [34.168.149.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f890b2sm191929635ad.26.2026.06.08.13.57.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 13:57:49 -0700 (PDT)
Date: Mon, 8 Jun 2026 20:57:45 +0000
From: David Matlack <dmatlack@google.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <aicsyesGrqcWj7vu@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-4-dmatlack@google.com>
 <aiPxVxu2sUVQfG9D@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiPxVxu2sUVQfG9D@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A0546100010
X-Rspam-User: 
X-Stat-Signature: 48pxndfx4aykm7ix9zqz6cc9pzsn78ga
X-HE-Tag: 1780952271-111225
X-HE-Meta: U2FsdGVkX1/WoGgmlNFGBWlZL5M9pAKIjAblUgayIUZU7KW+O4+4JttieS3iCYoYQv+2OTCYQ6KeDXk5QAzQqouyiBYbTN4D4h2rQk1Eg77bML27au8JYHh9x8rWkk2B9zpiEX1Xs7JAX/EoCsQ341u3FVbDMVV1MOc+Lf0J0yF8Bx3W3q8L4HbgMANfhYIvdjGOnAByeyMxLduSc9wFfYAXDPuRAY3Hoyt4U56FQM7mZe5FSRAoKSfGhIsQMpeKAJcZ0mZsrHjwSnyw4xaAXTaiz+WYWvEH3MoY1E18YG3PfNXFZEfURwENLinQM66z7VTXAbfnEsoQbLyw7pPoUqMbjwH15Y71JeQLZXtFAUrcC+rPza9mPmidfCqIqZm+cjmE/tjHHrRsrQM6O0fZpsaUQHowj2e+lVMvJClomOHwWHTsPq7T5Y1VZG1dT7B3ta9Dy9juP775tXML1Jvi4dW7xow7QmncCY/sPrW4zVu4WDBlnf5qJDTfC2i4dO7+ZxGbxcl8pH3QnFUiwmDWOXgquqkOb1/N8f0kP3rlYw/Sr5PU1iPzOFDCkGjE1Z3h+D3cp0GiWDP4iwUJsPywBXrcKr/T/O4nR8YJstFrLcufqLEGDKz6GNZIGfasecYwfyRFYCDEXhZ5Ehegh+VAj2isWz/7lFaoQ56xxgCXh4UQnBU0KrQEExlMHFDDjzhgrMsoR4iXjU4BlS9VfOfNYDAcBKN1fB20bZS98qrCVlNR4LYRWClzyJVE6y+6UtIfi6rUS7ddGB6hXb1JuIEbWIIsDxvxVd2HImf3H8VodYMuSImJqdhKmBiI3jWs08JS8ADdq7OBqC64zb7n27SgwLBy1zxyZJTX2X2PG9nlF2wCLJHDXXtdo4CZrCvGWsW3fsnp7OZoIY8bck6nZojqtCF5mmHM/96HUsqiSPK+jiG+VGTAciN3t2k5cIln9JvisVGFpavnbhubJQbNns3
 +31akffN
 IoFU+IVu8SqqFdB/llkQbnvO9cG3OrLCCI4oRMG8JOs4dh5HKfm8gF4L8hnFMV37Ey4J0I00smfD5LqXKnJEbMcJ7ZXBjed5TdgCktk4+W3Vl278WWYOjtpLMC8z+wypw/OJ6p7/EV+W6/xDDjZh2Sp3CqmdmNqrsd1RRdBU4E187VuW3mukffde6dHaj1HaMZYvRO4MvFYgwgRtefOGWEODCM6V5DafoLDRmJBRSM4Ck9yAQlPlho50cO3qxpplcAXKquOx6PFuFaVfckoJhCl/152Y/iQLCxlNyXsw9rMHbSkU3Nd6FDqhoEHQqa/WxUAwxS7rucDpTTQyfe4pFwc91Wx74COu3a2ZIzmMXjqaMTqx5fXGYfwzKvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-06 10:08 AM, Pranjal Shrivastava wrote:
> On Fri, May 22, 2026 at 08:24:01PM +0000, David Matlack wrote:
> > During PCI enumeration, the previous kernel might have passed state about
> > devices that were preserved across kexec. The PCI core needs to fetch
> > this state to identify which devices are "incoming" and require special
> > handling.
> > 
> > Add pci_liveupdate_setup_device() which is called during device setup
> > to fetch the serialized state (struct pci_ser) from the Live Update
> > Orchestrator. The first time this happens, pci_flb_retrieve() will run
> > and convert the array of pci_dev_ser structs into an xarray so that it
> > can be looked up efficiently.
> > 
> > If a device is found in the xarray, the PCI core stores a pointer to its
> > state in dev->liveupdate_incoming and holds a reference to the incoming
> > FLB until pci_liveupdate_finish() is called by the driver.
> > 
> > This ensures proper lifecycle management for incoming preserved devices
> > and allows the PCI core and drivers to apply specific Live Update
> > logic to them in subsequent commits.
> > 
> > Drivers can check if a device is an incoming preserved device (e.g.
> > during probe) by calling pci_liveupdate_is_incoming().
> > 
> > CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
> > domain and bdf can be guaranteed to fit in an unsigned long and be used
> > as the xarray key.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  MAINTAINERS                    |   1 +
> >  drivers/pci/Kconfig            |   2 +-
> >  drivers/pci/liveupdate.c       | 230 ++++++++++++++++++++++++++++++++-
> >  drivers/pci/liveupdate.h       |   5 +
> >  drivers/pci/probe.c            |   3 +
> >  include/linux/pci_liveupdate.h |  13 ++
> >  6 files changed, 251 insertions(+), 3 deletions(-)
> > 
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 6c618830cf61..0e262c0ceb43 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -20537,6 +20537,7 @@ L:	linux-pci@vger.kernel.org
> >  S:	Maintained
> >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
> >  F:	drivers/pci/liveupdate.c
> > +F:	drivers/pci/liveupdate.h
> >  F:	include/linux/kho/abi/pci.h
> >  F:	include/linux/pci_liveupdate.h
> >  
> > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> > index 10c9b65aa242..e68ae5c172d4 100644
> > --- a/drivers/pci/Kconfig
> > +++ b/drivers/pci/Kconfig
> > @@ -330,7 +330,7 @@ config VGA_ARB_MAX_GPUS
> >  
> >  config PCI_LIVEUPDATE
> >  	bool "PCI Live Update Support"
> > -	depends on PCI && LIVEUPDATE
> > +	depends on PCI && LIVEUPDATE && 64BIT
> 
> I see that the static assertions in Patch 1 work because of the 64BIT
> enforcement here. In that case, should we have the assertions check u64?

The static asserts have nothing to do with the 64BIT enforcement here.
The static asserts just verify that the array elements in struct pci_ser
are naturally aligned (unsigned long) so they can be accessed
efficiently. The requirement here for CONFIG_64BIT is for the xarray
key.

Theoretically if we got the xarray to work with 32-bit architectures
then we could drop the CONFIG_64BIT requirement here.

> 
> >  	help
> >  	  Enable PCI core support for preserving PCI devices across Live
> >  	  Update. This, in combination with support in a device's driver,
> >
> 
> [...]
> 
> >  static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
> >  {
> > -	args->obj = phys_to_virt(args->data);
> > +	struct pci_ser *ser = phys_to_virt(args->data);
> > +	struct pci_flb_incoming *incoming;
> > +	int ret = -ENOMEM;
> > +	u32 i;
> > +
> > +	incoming = kmalloc_obj(*incoming);
> > +	if (!incoming)
> > +		goto err_restore_free;
> > +
> > +	incoming->ser = ser;
> > +	xa_init(&incoming->xa);
> > +
> > +	for (i = 0; i < incoming->ser->max_nr_devices; i++) {
> > +		struct pci_dev_ser *dev_ser = &incoming->ser->devices[i];
> > +		unsigned long key;
> > +
> > +		if (!dev_ser->refcount)
> > +			continue;
> > +
> > +		key = pci_ser_xa_key(dev_ser->domain, dev_ser->bdf);
> > +		ret = xa_insert(&incoming->xa, key, dev_ser, GFP_KERNEL);
> > +		if (ret)
> > +			goto err_xa_destroy;
> > +	}
> > +
> > +	args->obj = incoming;
> >  	return 0;
> > +
> > +err_xa_destroy:
> > +	xa_destroy(&incoming->xa);
> > +	kfree(incoming);
> > +err_restore_free:
> > +	kho_restore_free(ser);
> 
> I tend to partly agree with Sashiko[1] here.. it raises a policy-hole.
> We may need a policy here, the options I have in mind are:
> 
> 1. Retrieve shall ONLY be tried once, if it fails (like -ENOMEM in the
>    xArray alloc), it's a liveupdate failure. We can't retry liveupdate.
> 
> 2. Retrying retrieve is allowed.
> 
> The only downside with option 1 is, the user may want flexibility due to
> certain subsystems OR may choose NOT to use the proposed LUOd and instead
> have its own user-space component which might try funny things or have a
> different use-case.
> 
> In such a situation, the system may have transiently run out of memory
> during the kexec transition (for e.g. a subsystem uses GFP_ATOMIC to
> allocate memory and temporarily runs out of the atomic pool). [Note we
> removed it in IOMMU v1 [2] but subsystems may have a use-case for it]
> 
> If the kernel frees the KHO page on the first failure, it removes any
> chance of recovery. :/
> 
> Thus, it might make sense to let the user decide if it wants to fail the
> liveupdate or retry again based on the failure type / source?

The plan is to have LUO enforce that retrieve() is only called once:

  https://lore.kernel.org/kexec/20260528174140.1921129-3-dmatlack@google.com/

Supporting retry gets complicated since there's many different places
where retrieve() could have failed.

> 
> [...]
> 
> The changes LGTM, except for policy-based, kho_restore_free discussion.
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> 
> Thanks,
> Praan
> 
> [1] https://lore.kernel.org/all/20260522211333.D56A21F000E9@smtp.kernel.org/
> [2] https://lore.kernel.org/all/20260203220948.2176157-2-skhawaja@google.com/

