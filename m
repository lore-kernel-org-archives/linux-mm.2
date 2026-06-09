Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC8C6CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:48:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FDCB6B0005; Tue,  9 Jun 2026 06:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AEF36B0088; Tue,  9 Jun 2026 06:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DDB6B008A; Tue,  9 Jun 2026 06:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 082676B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:48:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 91AB24052E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:48:25 +0000 (UTC)
X-FDA: 84860050170.13.D6F9151
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id A91FE18000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:48:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YzUs4MD0;
	spf=pass (imf16.hostedemail.com: domain of praan@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781002103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLGghC6UIfVrvCdIhumzQTyhB1QR5R7Bsqly45dLP7M=;
	b=Svs8i+0iITVPhjhCctSL6EUm+BtMg4UKJyE4Icbt0l0yGeX6iAZ233rrZ1pMRa639ar8Oa
	oFkfHuUr7rEef4pdAJ/TiO5kUBCSXr2hBJR+tA1eITFANDdqU3i94DNttxuhhuHzUK+xnL
	z6Zhb18l4tQ1BhqA8HDrOu9jjGW1yd8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YzUs4MD0;
	spf=pass (imf16.hostedemail.com: domain of praan@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781002103;
	b=TC1kjD9lwAwo1tLaDn+ld/jfdAwsnC86HPhQHHciXbyUhUXXYMwzt3SEESxOFq14mOy/Mu
	rFxOofFSSkT37Q8Fmz5xS87YD3/2i1BmjekY5jDDSdppiinevUxEF5rQauWEPPkI9ulq3c
	pvQkp3zuPb3vYI5z/hik0n9lZGPTO5M=
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2c0b1a48855so495845ad.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 03:48:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781002102; x=1781606902; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jLGghC6UIfVrvCdIhumzQTyhB1QR5R7Bsqly45dLP7M=;
        b=YzUs4MD0jMAun436WXyd5KHQ5hH+/jg/yyWzgpNvS+6ZR5nsmZEXbSbqSNoiZ5ztAg
         heqqjX3gRmIdBL+/9JlKAmcd/LzvpdDJA/6+A99Ay4X+nsX54EYMqcmjnAig5JVz9y28
         PbrR1u0EFlQ6FnX5e9cn9HNyHbKv84lPDMu6an/134P0V5IC3ihUaaj1nIrtYH37+k/3
         YV0zIKgvVjMjGMUzRk+iEj+AUjqgoE4fYI+0NFS7kCQYSkvvAg7/8Qqarq4J/siTNFzv
         avRv4modUvh36+LLDsnso2NUgfWOPAw2yYIm80wy9C7Funw7EPkOZTR65gPa/A9q0PIP
         T6vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781002102; x=1781606902;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jLGghC6UIfVrvCdIhumzQTyhB1QR5R7Bsqly45dLP7M=;
        b=aQDZnGQfKnydFzVG5YuS2N4DCVFr5Gzd9v5c82T4uv0M5V82Ps83EEdyyMP7/Gbh4B
         JlkEKmqKuj19fSnzGd3MyhTBSPSlmILsfd42rN4D6ihfKx4tG7FdYOQcF914T/oF3diS
         DBPXgAe37lJZyA+twebNQdWbGNOtfOpApDhiOihJHn+qQE0mUpUh29hlj+NHHU9GYPRf
         udmglU85Kgj2VkdXpCN1q5aox6kJiEXrX2X8aWj8r+RlotfoTm0eU3S0cOYjTjqKHJXt
         xqhP6XTN2wuydAQOpEwtMu+2edXXLVrZqLD5BhvMxsXXgGfcoNYQxIdY5gV5DiZKSh83
         d0SA==
X-Forwarded-Encrypted: i=1; AFNElJ8TP2YuUxPEAImV39zJsWboDrB1p05Qu59p3aEYX9zWyYZLgmmoaLN+2QjKzCbRK935VvJusDg2qw==@kvack.org
X-Gm-Message-State: AOJu0YxiWKR/0JkYiCyimmChCQUbGKgrLAtoK6o/vT35Xfjp2kJzfxBu
	2//8g1OKr6iiypxjt7nH5YVxoF8iTnDh4m4Tob2FuK8CQCzRiTwJaZUpLFReapHkPQ==
X-Gm-Gg: Acq92OGzMLfTkU6nutnQ2mPU85qB3RwzF4TclkC/U6mA+MMK7Mb8HZ5Ma8fGRzjBqWc
	bWmkfzpxZT+BTEhSQeJIei7lgGZUJghIsM0xJoGCyn5SV1gvGRysqgUrs8oKX12nVWWIlg5s3yC
	78JcvIEuej/CAtSi/wQkbDweHCeRQfSnluIkTChISRzReYH1wds0RrO380cYp7P3LsL76lij/cU
	wA5GAKcgCCNttWCHaJkosTo70QU4YZ41XEIww0rN9r+6fYcU8sLx8ypEnufFPXNSYgFOHThLB2P
	4RqW9fhsIhMirqYRdU0nroVyt7xU9sVq4r6fCLmpDPgNr67wnQoBz/REwnEIWGW69N5yDx2S8Qb
	KUjunLp1lXQYhZr5GV4iXwd8orIhlC9CeaYl4Bq5DCa5EBtVGiDAcOS11Z7dzXUrJRcsCUdYxCU
	YWGNCDoOJWNghvui3ukSjDYaQ6FwGM0n5/wLQCbNqOaMvcuMcdESDI5VEz9kvPTCshVzZwSR8=
X-Received: by 2002:a17:903:1a6f:b0:2b0:b0c9:96e2 with SMTP id d9443c01a7336-2c1ec0deac6mr7312765ad.21.1781002102069;
        Tue, 09 Jun 2026 03:48:22 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84282372502sm22347071b3a.16.2026.06.09.03.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 03:48:21 -0700 (PDT)
Date: Tue, 9 Jun 2026 10:48:12 +0000
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
Message-ID: <aifvbD9ZoVOsgCrD@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-4-dmatlack@google.com>
 <aiPxVxu2sUVQfG9D@google.com>
 <aicsyesGrqcWj7vu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aicsyesGrqcWj7vu@google.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A91FE18000B
X-Stat-Signature: 1yqox8xhdm5cx5faemsr5txkewteikhi
X-Rspam-User: 
X-HE-Tag: 1781002103-998243
X-HE-Meta: U2FsdGVkX1+U/UhNJpzdW/DbTqYeVjOiuDlQbIEeN8756aHgda8aP2EX6L81SmZv9r/GYS02DTRgCD5DPE+urYBuHbi+dh0PoAIqNdd2HGIxNtmZXnalScFMdUWzbdpbXi2aPDBwkhbWqxBpkxHlcWhuBl4COgTXkJeNWf55HSw9CIj+OM0+vCa3YZMxu8p6pXJJs2aQCI/foQH+6QBs1ARhYyRsrUtyDngcRs3I+bRUxYwhazFPdKjqJecE1LgXYQoPaoxTcd/QuL4FJLEQzs1ys71qCyqyBVzAZJI1SM2cdtFH9kgbHDlb0pgxc//9cX6cH3l4xuulBu0IDmevKRT8qAMpDSNi7Of8qNQl/93nEUc7dLJydCPysG7y8BWA2Ns7v766Pc3qsoXy1C9urafOcT48kRs8kG+Jhoo57rDtPhtSsjrvFoQNWH5W0chlzaDE7vvZYBWUFyu57WlUKDRdnu72jW6qZfHblSdhhYNIcr/wryKS7TRJMG4rZ/plD3goczOTvzlMVz5V+1JKRhHoGSmkVTaCe7vmBSIuZmH0rmeRjeDhEaR1H+Gdemwdb+JBLuaHpvipSBYc/+IcpFxO4iq2Af0b0qSugy2mG7Qx2XcLsrxZ5v1ll+3wrnWIqiHC0+kmLswZhGAwvR0ikmkGwDi3OW3zXDDnLpzuMJUwkk01c9pXhE/idtmG7SG4VCm8lHLV0VosSi10fna1PYAUf8193jeaOn5QSKvO5Wj6AUaPIiQFqcw9REWG/PBIXomj2WYtvcHlBnmfLXzl+pXBw+7773XVYTuU5ReJ0U8t4loXl4ESw3lVc8fnyoo9qETJAVhqTUBDh8WbiVmcZMVwTQfzoe70iLsivo6DResO5XXsxt2LpKQlLmI+yRTJpz1eCEfv20WAqFxXTi0kh4rXXtG3XTkrTcvZSBzNmg46wy2dAd8A5njW1Ocs9CdioY8YFimRxPAC0PVRoQk
 3HHoQbKU
 7VdBd/jZCztS4m8pfD6qljmA6SntMQyQ0zA589TMFHXIOSFJhU/FMlIw/Y0Equ3LuKQ7Rq0XcIZcn62J1bZCGSFeLjZ7IPRev+Ot/KLtc3HArJXdSWKtiu+F8ELErGxLid7XEf90T8f8GLdtrPS2cwqrKLAhO6iuAaalmvXi9nz4+vAXohPjSwotHM3hIjWUWj8zp6eoC905fidfW38v0//HE4uMPfKReg4VnZcXIpx2Vkd7gwiQoYVagRwl/REqR8no7FonSvwd4fUkYZrqBVrEsrxlld7k6JysRlQrEtJcJdE6pXryDvTaBtkisE5iBqRWAe9dB8r7RgTk/W1t5pRDAMO1+cPPEUAaC7UlpUDNjvvTmvVqq4FNQlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 08:57:45PM +0000, David Matlack wrote:
> On 2026-06-06 10:08 AM, Pranjal Shrivastava wrote:
> > On Fri, May 22, 2026 at 08:24:01PM +0000, David Matlack wrote:
> > > During PCI enumeration, the previous kernel might have passed state about
> > > devices that were preserved across kexec. The PCI core needs to fetch
> > > this state to identify which devices are "incoming" and require special
> > > handling.
> > > 
> > > Add pci_liveupdate_setup_device() which is called during device setup
> > > to fetch the serialized state (struct pci_ser) from the Live Update
> > > Orchestrator. The first time this happens, pci_flb_retrieve() will run
> > > and convert the array of pci_dev_ser structs into an xarray so that it
> > > can be looked up efficiently.
> > > 
> > > If a device is found in the xarray, the PCI core stores a pointer to its
> > > state in dev->liveupdate_incoming and holds a reference to the incoming
> > > FLB until pci_liveupdate_finish() is called by the driver.
> > > 
> > > This ensures proper lifecycle management for incoming preserved devices
> > > and allows the PCI core and drivers to apply specific Live Update
> > > logic to them in subsequent commits.
> > > 
> > > Drivers can check if a device is an incoming preserved device (e.g.
> > > during probe) by calling pci_liveupdate_is_incoming().
> > > 
> > > CONFIG_64BIT is now required to enable CONFIG_PCI_LIVEUPDATE so that the
> > > domain and bdf can be guaranteed to fit in an unsigned long and be used
> > > as the xarray key.
> > > 
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  MAINTAINERS                    |   1 +
> > >  drivers/pci/Kconfig            |   2 +-
> > >  drivers/pci/liveupdate.c       | 230 ++++++++++++++++++++++++++++++++-
> > >  drivers/pci/liveupdate.h       |   5 +
> > >  drivers/pci/probe.c            |   3 +
> > >  include/linux/pci_liveupdate.h |  13 ++
> > >  6 files changed, 251 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 6c618830cf61..0e262c0ceb43 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -20537,6 +20537,7 @@ L:	linux-pci@vger.kernel.org
> > >  S:	Maintained
> > >  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
> > >  F:	drivers/pci/liveupdate.c
> > > +F:	drivers/pci/liveupdate.h
> > >  F:	include/linux/kho/abi/pci.h
> > >  F:	include/linux/pci_liveupdate.h
> > >  
> > > diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
> > > index 10c9b65aa242..e68ae5c172d4 100644
> > > --- a/drivers/pci/Kconfig
> > > +++ b/drivers/pci/Kconfig
> > > @@ -330,7 +330,7 @@ config VGA_ARB_MAX_GPUS
> > >  
> > >  config PCI_LIVEUPDATE
> > >  	bool "PCI Live Update Support"
> > > -	depends on PCI && LIVEUPDATE
> > > +	depends on PCI && LIVEUPDATE && 64BIT
> > 
> > I see that the static assertions in Patch 1 work because of the 64BIT
> > enforcement here. In that case, should we have the assertions check u64?
> 
> The static asserts have nothing to do with the 64BIT enforcement here.
> The static asserts just verify that the array elements in struct pci_ser
> are naturally aligned (unsigned long) so they can be accessed
> efficiently. The requirement here for CONFIG_64BIT is for the xarray
> key.
> 
> Theoretically if we got the xarray to work with 32-bit architectures
> then we could drop the CONFIG_64BIT requirement here.
> 

Ack. I see.

[...]
> > > +	kho_restore_free(ser);
> > 
> > I tend to partly agree with Sashiko[1] here.. it raises a policy-hole.
> > We may need a policy here, the options I have in mind are:
> > 
> > 1. Retrieve shall ONLY be tried once, if it fails (like -ENOMEM in the
> >    xArray alloc), it's a liveupdate failure. We can't retry liveupdate.
> > 
> > 2. Retrying retrieve is allowed.
> > 
> > The only downside with option 1 is, the user may want flexibility due to
> > certain subsystems OR may choose NOT to use the proposed LUOd and instead
> > have its own user-space component which might try funny things or have a
> > different use-case.
> > 
> > In such a situation, the system may have transiently run out of memory
> > during the kexec transition (for e.g. a subsystem uses GFP_ATOMIC to
> > allocate memory and temporarily runs out of the atomic pool). [Note we
> > removed it in IOMMU v1 [2] but subsystems may have a use-case for it]
> > 
> > If the kernel frees the KHO page on the first failure, it removes any
> > chance of recovery. :/
> > 
> > Thus, it might make sense to let the user decide if it wants to fail the
> > liveupdate or retry again based on the failure type / source?
> 
> The plan is to have LUO enforce that retrieve() is only called once:
> 
>   https://lore.kernel.org/kexec/20260528174140.1921129-3-dmatlack@google.com/
> 
> Supporting retry gets complicated since there's many different places
> where retrieve() could have failed.

Ack. Thanks for pointing me to the thread.
In that case, no problem.

Thanks,
Praan

