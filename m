Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43367CD8C8E
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 10:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 516946B0005; Sat,  6 Jun 2026 06:08:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A0026B008A; Sat,  6 Jun 2026 06:08:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 367A76B008C; Sat,  6 Jun 2026 06:08:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 223326B0005
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 06:08:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB9071C1B6E
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 10:08:43 +0000 (UTC)
X-FDA: 84849063726.04.7679E95
Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	by imf01.hostedemail.com (Postfix) with ESMTP id CB89E4000A
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 10:08:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XfajHxJY;
	spf=pass (imf01.hostedemail.com: domain of praan@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780740521;
	b=gzsq5r0vXF+vDkx8zHMKpsPpOnXjrd+uR0GuoJzhv43iUpVfDg18M5RdvvHQ1NuE6Md1lH
	I2JydO/vo2nbBcRBSsJHLaxnjbnwu8wlrvDzia91LyO1p4oH47pRBfdjjCecgRvgMqbvKr
	xm1S9xP0W06BEv+LIxw2SBpPWgRfREU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XfajHxJY;
	spf=pass (imf01.hostedemail.com: domain of praan@google.com designates 74.125.82.51 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780740521;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0IAXiSA/ZV+jth47JKvQthC0sv+FXjXrt59JcT36/1Y=;
	b=5EyvvgLHO5MZ2tw3xX9IIcqUJamPK07pdakAilqUDPW4g6lQdOHr9bAGVka+TKDU6i3QBW
	f5ArdTPdou3gYLzyND9azpOoMHu2JUzZ3NdYQ1PDmv9C7SaFYOa2/16N1d6RArcYDyfL00
	aNDrGt3np9q1PfX/L1nYHAqT4mn9t1A=
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-1336742714fso19664c88.1
        for <linux-mm@kvack.org>; Sat, 06 Jun 2026 03:08:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780740520; x=1781345320; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0IAXiSA/ZV+jth47JKvQthC0sv+FXjXrt59JcT36/1Y=;
        b=XfajHxJYNsxjgmkWy07tyVIKuQIMdoZBmHTGjnftuUH3vUB/7AAsDHqsqP9Z3yhccn
         /5EufSDaLZKGgw1pDQZiWPkyXjfWWb6EskwoqKsbKw7ToO1721zmRbp5okgHgqXmA1Y7
         6hu8iJ4p/spc+CrDHQLwdfj1N0oYus6Ksv3vPXXkCsGXlMT2szamp0XSH6eLOtjdXn8I
         SgjoZmg/29ZJ0WDxZogrN0B9jdpEdNWLljcOvX8Aj+0B7TqSkPjrTR031z4/1PbcvemX
         vU44/jgy3cSFGQJNF3pUOfxTOyqH6ZJe4gXTXFFsbotSpVQBVJDxxgbeHGW4q9HsAd1r
         WPNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780740520; x=1781345320;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0IAXiSA/ZV+jth47JKvQthC0sv+FXjXrt59JcT36/1Y=;
        b=gj34X8zgsAjh2PHeicWKt59/rjWbftL8QV4lRD7lzuFug9ilhrNeRUFqWIJ3mBBUUu
         ongWgn//jiF6NWvf81tigycdWKvldZjGbPiL8nuibweDgNxEMHAkX9Xtvr8QUlFXi9b8
         djgS2dkzvOeO3TGo51hvFXbva3qCJ0BScIVhywBPiI1BoTTkcCmnDAAQu/cv1vCy1k56
         +VBE3upMNU1VVSDbqJ+dcA6RQSMAFVVnzrx6NRrJFitIjw45zdQeivKpVet2E54Iwmwe
         gV/uQHLPyZrcZjIU5wPMGWwuaspWBHmkYGpdhaDxsPb0JPe1J/MQ4Lur/NYhSyf4P4Gk
         s0hw==
X-Forwarded-Encrypted: i=1; AFNElJ9HtfThzXE2s6yB/AceAFSn2Bsmyxffb5ZXEI3ZnW2N1e81E+HKGQy8GtT2tE0J/OgfSENEEnvTCw==@kvack.org
X-Gm-Message-State: AOJu0Yx/5wfDA6Iq2tVzGsZ86qtHa0rvHZbv6z8T6CTRfroQXIeqNdBF
	a4ZN2HVgSt9gtEpl4KOFQEBGotf7VIPCJ/mvnIlBWsbkdBWilAlgPpGg58fuabIBtg==
X-Gm-Gg: Acq92OFBjoG1ZGnZ6OG9z+TRmOvCxxCCk0qxiA83RqEmCpETATME3vHqPBAQ5jd0LMC
	dipdGBgmVLd5cO2jp2FOT4D03M0rN8MO0D+wmzuiFw7uIrrgNc5zzlcjRh6grt7HNb7fk3CM4wu
	39A+ucFwSYOPvgRLXC/5yzj9dbecmKXWkUDe14lcVfNmhFo3HpawygOB/46d/iryo4oF3qfQMEj
	YxrN7DjRy9/Uc4AJLuz47WZId6ZWUEBDSAYOOGN4xzd7X9VivVVrmIplIKGIfNGm5P0yVtR7k7V
	9BUuQyGdERPeNulAzCLnJXVe3ME9Zm975fcLAjPD8AZPqgS15w/7B1uDaHmf/yL2JHjd3myFk2U
	HMGUhr7VCon6Hxhjf5je1MrOdNHUTHIFP3W7M34XBDGdRjmMt3Tb1C7Fbn6y4P+g/PqPhMUcTOu
	8ANLHsWU1VYigL7cZsr9QMbntxlbnwaR77DUH5JC/scobYvnvrsRkOvm4Ah5nzAC+B4BUquTQ=
X-Received: by 2002:a05:7022:672a:b0:136:799c:bd1 with SMTP id a92af1059eb24-13807c512edmr207588c88.10.1780740519572;
        Sat, 06 Jun 2026 03:08:39 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3074db528dcsm12388863eec.3.2026.06.06.03.08.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Jun 2026 03:08:38 -0700 (PDT)
Date: Sat, 6 Jun 2026 10:08:28 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
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
Message-ID: <aiPxVxu2sUVQfG9D@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-4-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522202410.3104264-4-dmatlack@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB89E4000A
X-Rspam-User: 
X-Stat-Signature: t4ansti44mrfui4uybdourhb4fdixwap
X-HE-Tag: 1780740521-72022
X-HE-Meta: U2FsdGVkX18U3vXCIeBKqKuNtIN0WDOLNO0oSaV7vHdbHJdwySeui6xkoQYCvZvX7KObB28tXv00KGGrI8nG8LNixclOX8cewwv5fY0Ni2awg5e2kOagC4WQdQmXtlBi57Q06+eXfInnzYEAwNU8eXeN8DGwrTJfulTeTqYRC40HLGkaxjlWGPPReSZ7l/HaL2cIDCUf32J+/H3FwBamnT8sB3Jz54hjF3aHfA3aRNnEWGs8SjDkw/dr2/5kKvYPnBC6n8gOlO0nFxFMbkS9qLvuH0zhwL9UUaGpHK7gJ+vjLH6ZFGH/RWNq9KFkWzdEF15LSwS8I866ryUNXv6BQjMVFy2G84popC21q+QlMzT2Dtt3bkaaTWgJ/krbS4qMysMd7nnUaVG9LEVzzDXu2BZUvkKS/uRwviT0lWn26w5fPWcaxZSPw17+TYj9ap7d2V4TyU463qfWiJkZtnplA5P6HpehskBFG87lPaW/rx9oa4NZowfjXmV+3RPlAGdOrsWQ05z+GU71omilKVQOEdfV03a6rOeO6+CAnjpn+w0UdZ1ypszw+MOn9yhzZAU8iDeqSRRxKga+AbsRwAC0Z3k7ywa0bXTWtE7F13+FXu8rLWodAXEX7qpqOUHLlkVhGhn5D5isX+JjXj/4/XbmouJf5dEeGhaI6Bruh2Xu7om226Uwn7uynU7tjhfDzh4K0lSAtKcUCvFdkS4SSDVPoBhY69IhFV2hZAqIZRVnEd8DlWkTpvwfHTXXLiUHPw6N+692QMCVz8eHWHomdnrMS3es/i0BYuA+1BBOuE26ai8ddErsNjoBjpzSMlfdKAnaIvrWcFtynVdiNs4QqB0TljQJq1apEDVQtpZka6/GZnMx/h2EoOPPD3qfxvuIfP60jcmloN9HO2hHW+b8V4gmSNFeLr5zy6QxjwvtYWi0rpjQn+D5+s8CWJaHh5yBAImBNMdGwFY34uzF8HvRr/u
 ayuj7Hy7
 rCqJ7pv0zxIubO6K9JwkScGtn9+yAblO1/rzr1ar5dcDpCJM9Q+hvQEgVUul9aIOqWBSOLbkMCnCExzYU+PdejfVEL39OzkkA5OxDrhVdnWfywCzXxEJyjbMzDyzNHKWdwnCT6+uVYLlbeO60pHXL8XB8JmKxoth3tJLaNxQwgNmBexQFt22thprShxa6ilPRhmkQVeJBBIQSW9t6dYsR8nsFV7uhPD2O8nkYCcS6U3LLNaXPdHiqOufEO8K3wMAtgv8lrYTAYxcTvnCwF73RmjYUj6+EvgcFkziCOF6FmyRBRokwiUmMeizNSBRPvk2d/0NpffEDUfQvtLEaHJFkSduMNYFzB+6fgcwgwVzVHYayWvW4XxRUNGjdZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 08:24:01PM +0000, David Matlack wrote:
> During PCI enumeration, the previous kernel might have passed state about
> devices that were preserved across kexec. The PCI core needs to fetch
> this state to identify which devices are "incoming" and require special
> handling.
> 
> Add pci_liveupdate_setup_device() which is called during device setup
> to fetch the serialized state (struct pci_ser) from the Live Update
> Orchestrator. The first time this happens, pci_flb_retrieve() will run
> and convert the array of pci_dev_ser structs into an xarray so that it
> can be looked up efficiently.
> 
> If a device is found in the xarray, the PCI core stores a pointer to its
> state in dev->liveupdate_incoming and holds a reference to the incoming
> FLB until pci_liveupdate_finish() is called by the driver.
> 
> This ensures proper lifecycle management for incoming preserved devices
> and allows the PCI core and drivers to apply specific Live Update
> logic to them in subsequent commits.
> 
> Drivers can check if a device is an incoming preserved device (e.g.
> during probe) by calling pci_liveupdate_is_incoming().
> 
> CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
> domain and bdf can be guaranteed to fit in an unsigned long and be used
> as the xarray key.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  MAINTAINERS                    |   1 +
>  drivers/pci/Kconfig            |   2 +-
>  drivers/pci/liveupdate.c       | 230 ++++++++++++++++++++++++++++++++-
>  drivers/pci/liveupdate.h       |   5 +
>  drivers/pci/probe.c            |   3 +
>  include/linux/pci_liveupdate.h |  13 ++
>  6 files changed, 251 insertions(+), 3 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6c618830cf61..0e262c0ceb43 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20537,6 +20537,7 @@ L:	linux-pci@vger.kernel.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
>  F:	drivers/pci/liveupdate.c
> +F:	drivers/pci/liveupdate.h
>  F:	include/linux/kho/abi/pci.h
>  F:	include/linux/pci_liveupdate.h
>  
> diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> index 10c9b65aa242..e68ae5c172d4 100644
> --- a/drivers/pci/Kconfig
> +++ b/drivers/pci/Kconfig
> @@ -330,7 +330,7 @@ config VGA_ARB_MAX_GPUS
>  
>  config PCI_LIVEUPDATE
>  	bool "PCI Live Update Support"
> -	depends on PCI && LIVEUPDATE
> +	depends on PCI && LIVEUPDATE && 64BIT

I see that the static assertions in Patch 1 work because of the 64BIT
enforcement here. In that case, should we have the assertions check u64?

>  	help
>  	  Enable PCI core support for preserving PCI devices across Live
>  	  Update. This, in combination with support in a device's driver,
>

[...]

>  static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
>  {
> -	args->obj = phys_to_virt(args->data);
> +	struct pci_ser *ser = phys_to_virt(args->data);
> +	struct pci_flb_incoming *incoming;
> +	int ret = -ENOMEM;
> +	u32 i;
> +
> +	incoming = kmalloc_obj(*incoming);
> +	if (!incoming)
> +		goto err_restore_free;
> +
> +	incoming->ser = ser;
> +	xa_init(&incoming->xa);
> +
> +	for (i = 0; i < incoming->ser->max_nr_devices; i++) {
> +		struct pci_dev_ser *dev_ser = &incoming->ser->devices[i];
> +		unsigned long key;
> +
> +		if (!dev_ser->refcount)
> +			continue;
> +
> +		key = pci_ser_xa_key(dev_ser->domain, dev_ser->bdf);
> +		ret = xa_insert(&incoming->xa, key, dev_ser, GFP_KERNEL);
> +		if (ret)
> +			goto err_xa_destroy;
> +	}
> +
> +	args->obj = incoming;
>  	return 0;
> +
> +err_xa_destroy:
> +	xa_destroy(&incoming->xa);
> +	kfree(incoming);
> +err_restore_free:
> +	kho_restore_free(ser);

I tend to partly agree with Sashiko[1] here.. it raises a policy-hole.
We may need a policy here, the options I have in mind are:

1. Retrieve shall ONLY be tried once, if it fails (like -ENOMEM in the
   xArray alloc), it's a liveupdate failure. We can't retry liveupdate.

2. Retrying retrieve is allowed.

The only downside with option 1 is, the user may want flexibility due to
certain subsystems OR may choose NOT to use the proposed LUOd and instead
have its own user-space component which might try funny things or have a
different use-case.

In such a situation, the system may have transiently run out of memory
during the kexec transition (for e.g. a subsystem uses GFP_ATOMIC to
allocate memory and temporarily runs out of the atomic pool). [Note we
removed it in IOMMU v1 [2] but subsystems may have a use-case for it]

If the kernel frees the KHO page on the first failure, it removes any
chance of recovery. :/

Thus, it might make sense to let the user decide if it wants to fail the
liveupdate or retry again based on the failure type / source?

[...]

The changes LGTM, except for policy-based, kho_restore_free discussion.

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan

[1] https://lore.kernel.org/all/20260522211333.D56A21F000E9@smtp.kernel.org/
[2] https://lore.kernel.org/all/20260203220948.2176157-2-skhawaja@google.com/

