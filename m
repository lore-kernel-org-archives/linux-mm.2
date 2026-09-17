Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02F37C982D2
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 21:39:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77A0E6B008A; Thu, 17 Sep 2026 17:39:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 723456B008C; Thu, 17 Sep 2026 17:39:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639536B0092; Thu, 17 Sep 2026 17:39:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3FC6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 17:39:18 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B75A0A050B
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:39:15 +0000 (UTC)
X-FDA: 85224570270.11.7D285D3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 38C6B1C0003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 21:39:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NbP9X+YW;
	spf=pass (imf21.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789681154;
	b=zk1l+3fO3FPdNTuBwqbmoemBWTSFVOzvulJwTO5ZC5Dugx6a/Md7FwVWW8IP1ieyFUAYCn
	jKjv6W1iuFLO0CDJyt4mCU4hKmFgbdavbdyDvLD0YM57ql+AvaE9tufkJd2YVX4GSQ9Gzz
	oSGtPT06EZmx1XGXiYHWSLsLY3sQOgc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NbP9X+YW;
	spf=pass (imf21.hostedemail.com: domain of helgaas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=helgaas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789681154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=k/6t/GikBHxugOsJ+dBD227K5m8z7pCCXMsSTk25Xz0=;
	b=uZvlKiLvgq0eokapTi5nBav1eqVsCVNp/Qsu+N4fT6lDXAGMa1u56qwOseupqlI3kpxbpg
	8Ux52AHlP6wwH+wdQ/MQsNtoLGh9uej9+Jt4Xi4pHzBfyLY8nKGu3X55n3mI3rwFdC6OCH
	TQExZPi4nMuUtSrYSP5NkKwB5Zm8ks8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7C0E600AA;
	Thu, 17 Sep 2026 21:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380321F000FF;
	Thu, 17 Sep 2026 21:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789681153;
	bh=k/6t/GikBHxugOsJ+dBD227K5m8z7pCCXMsSTk25Xz0=;
	h=Date:From:To:Cc:Subject:In-Reply-To;
	b=NbP9X+YWncmvMuxndz4qUfEghuzl86DRrMSTCxqgT/YNwqK/HEnvZtwSFt79RSKAK
	 xoErzHMOyrD3sCRiN/7HDD4gzJ7HDZJ6Kimrxvr0BjM8PyIHBctpgeH9KHhKEt34JG
	 GlTH6h9ByjAKjWlV/DFUNBx4Wzg2gvuig+LpFnErUDT8KdHEYxgLlcZs9DVO3T4SAN
	 0uraRJMyAV+5iSTuKw1NVEtMYB+KsND+3M7ehE1re7WmFPKb7HRgVHBt2aTu1qI6pE
	 EQDusijHmss/+c8YE7OMIOtuNIDYMqiVSyDNNoRa5DRMO4pMBHuNaFpoYWUORcPohc
	 KcBh2J4m4WNSw==
Date: Thu, 17 Sep 2026 16:39:12 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
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
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 12/12] Documentation: PCI: Add documentation for Live
 Update
Message-ID: <20260917213912.GA1049556@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-13-dmatlack@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 38C6B1C0003
X-Stat-Signature: 7p36c9pceypchp41hwef13dfuz6n3hhw
X-HE-Tag: 1789681154-976824
X-HE-Meta: U2FsdGVkX1+yPSygeWE5R6WPoA6Vm501MWyioXmXKwAUhOSAbeTGMnPT5hZeZNUXvtp1NPZdQb7FDtQQjgWD1BUd0wld4D6+Ek+jRQDaysR2StXwkhYjcwIKPOz0dLQMl20rzNUKOs6rz99MMBEx12c8fN9ZGFaagIMKMJpKXzwRKokP+v1nV5NpLeeC5b0q965DEC8z51Uqbtauix0F8KZiKZWM+4KmZ+MQuZPvc+UfND8K4zOA3mqsTt9M+wU822x1d2F4m80FXBOPcMkPQcEzUwgpfzTurYZ8znbMvqKP8gCz1VfMdEDn72ncnOV5TwBQoujntVG1Z5noP3IQIxLJTqjcULx7IUJWV2QOV4Wdmia2snBYjQ0lZhKg9LN4/AfwCBte1gVW0zuGUSGWqRPDlZQioq3N6g6/b4sRcHCsRW0dmUI+cYrBBXzKGU+cCSAcP40I0oaXdsNXGAPjkjDr0xTilQyHc5FBeQnzU4aw5OHHPz8OJ+tvdUoHXiLvYdeUS7LXnHxaGXJdZhoa3CSgPvNC2SuEI4Dd1VYnQjCGfvPW80KE8lckJef3B8mEyteHLldLcuXwGBDET96Aw3Ow/dWfM/abwfHUypCeRuPsk7olt3CvKeOcABroDuKZ9PMqxxsQFYlrhqqoPh19HlHyEPJclxu9o1yKP7oqxJOomt7WehX/tqLLVh0MR0UrwWOy6uf+jqZjf2TCQekiQ/fPhj+MYhe/iRZP7t95YUivAxYfGRgdxs/x/ZPQ8lbwQx+HZTv6wntt4MxstGbIY/hTWi37ErpnvJaZskdal1b/n+5WryKN9AkwBlTmYwo++SLn5+TZMh1G3rmpI6YT1uC9ZQn5lq6uJ5err/5ot91iA9QXAHkGW4s1wg8tBctTxankPySWa+CdiV1jBBVK9ymSjQVMz33wucPtWXq7xFBGJ3sU3AXo1MR+ZRsUVU1d+MhPlg84UbjcWAzFlmC
 jFRKgPPv
 7DkGujyPsfjAPd6t1iozqn5O3epnMilUOu9dzr3CxxAICg0Zde+ch+WLY8iW9LbWiCA9iObvXbDe510vYoc4dYLSOzaDsIVvoTrW0xb2fmig+JmHFjpxxtEVEvmHPdbxTZJqFZw3glzyWDd6Au4st1+U8/JT3oVhh8QhVtitufKeAaV4NnUx6XYnuOcimudyQwJXLpiLhgkGF4yowzVaIR5k7f/fbTTzqLFo2KkH/iTk5lNz0wf56jMYXgNh34IyR9p7x7ht43O2ozI9Z5JD5rLDswTM8zmfjfUqYg4AQDg1yImiWPxDz8U9N4E65Ak/LFM++cYs8hSSGm0w+NHBLkZLIVdmir3oU5rACUD09NxHyXjQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:06PM +0000, David Matlack wrote:
> Add documentation files for the PCI subsystem's participation in Live
> Update.
> 
> These documentation files are generated from the kernel-doc comments
> in the PCI Live Update source code. They describe the File-Lifecycle
> Bound (FLB) API, the device tracking API, and the specific policies

Most uses fully hyphenate this: "File-Lifecycle-Bound" data, object,
etc.

> applied to preserved devices (such as bus number inheritance and bus
> mastering preservation).
> 
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> Signed-off-by: David Matlack <dmatlack@google.com>

Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>

> ---
>  Documentation/PCI/index.rst           |  1 +
>  Documentation/PCI/liveupdate.rst      | 35 +++++++++++++++++++++++++++
>  Documentation/core-api/liveupdate.rst |  1 +
>  MAINTAINERS                           |  1 +
>  4 files changed, 38 insertions(+)
>  create mode 100644 Documentation/PCI/liveupdate.rst
> 
> diff --git a/Documentation/PCI/index.rst b/Documentation/PCI/index.rst
> index 5d720d2a415e..23fb737ac969 100644
> --- a/Documentation/PCI/index.rst
> +++ b/Documentation/PCI/index.rst
> @@ -20,3 +20,4 @@ PCI Bus Subsystem
>     controller/index
>     boot-interrupts
>     tph
> +   liveupdate
> diff --git a/Documentation/PCI/liveupdate.rst b/Documentation/PCI/liveupdate.rst
> new file mode 100644
> index 000000000000..96b1d7f5df3a
> --- /dev/null
> +++ b/Documentation/PCI/liveupdate.rst
> @@ -0,0 +1,35 @@
> +.. SPDX-License-Identifier: GPL-2.0-or-later
> +
> +===========================
> +PCI Support for Live Update
> +===========================
> +
> +.. kernel-doc:: drivers/pci/liveupdate.c
> +   :doc: PCI Live Update
> +
> +Driver API
> +==========
> +
> +.. kernel-doc:: drivers/pci/liveupdate.c
> +   :export:
> +
> +Internal API
> +============
> +
> +.. kernel-doc:: drivers/pci/liveupdate.c
> +   :internal:
> +
> +Live Update ABI
> +===============
> +
> +.. kernel-doc:: include/linux/kho/abi/pci.h
> +   :doc: PCI File-Lifecycle Bound (FLB) Live Update ABI

Ditto (and in include/linux/kho/abi/pci.h itself).

Trying to understand the FLB concept, I found
kernel/liveupdate/luo_flb.c.  I know that's already merged so this
isn't really the place to ask about it.  But FWIW here are some
questions from this naive reader:

   File-Lifecycle-Bound (FLB) objects provide a mechanism for managing
   global state that is shared across multiple live-updatable files.
   The lifecycle of this shared state is tied to the preservation of
   the files that depend on it.

I understand "global state", but I don't know whether "global" is
relevant here.

I don't know what "shared across live-updatable files" means.  Is the
sharing a fundamental aspect or just a typical use case reflecting the
level the data is for (e.g., bus vs device)?

I'm imagining a *kernel* being "live-updated", i.e., a kernel being
updated while things around it (devices, some user-space things) stay
alive, so I guess "live-updatable files" would be preserved across a
kexec?  I don't think of devices as being "live-updated" since they
themselves aren't being updated; in fact, the whole point is that they
*aren't* updated.

Do these FLB objects appear in a filesystem?  Or are they merely blobs
of data that are preserved across kexec?  I suppose there must be a
mechanism for the new kernel to identify and request one of the
several FLB objects saved by the pre-kexec kernel?

What does "lifecycle is tied to preservation of files" mean?  I
expected to learn about the beginning and end of the object lifetime.

   An FLB represents a global resource, such as the IOMMU core state,
   that is required by multiple file descriptors (e.g., all VFIO fds).

I have the impression that the important thing about FLB is the
lifetime of some data, e.g., something that lasts longer than the
kernel that produced it.

   The preservation of the FLB's state is triggered when the *first*
   file depending on it is preserved. The cleanup of this state
   (unpreserve or finish) is triggered when the *last* file depending
   on it is unpreserved or finished.

Maybe this means .unpreserve() (in pre-kexec kernel) or .finish() (in
new post-kexec kernel) is the end of an FLB object lifetime?

> +.. kernel-doc:: include/linux/kho/abi/pci.h
> +   :internal:
> +
> +See Also
> +========
> +
> + * :doc:`/core-api/liveupdate`
> + * :doc:`/core-api/kho/index`
> diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
> index b3c689e633c1..2bce2644eba2 100644
> --- a/Documentation/core-api/liveupdate.rst
> +++ b/Documentation/core-api/liveupdate.rst
> @@ -74,3 +74,4 @@ See Also
>  
>  - :doc:`Live Update uAPI </userspace-api/liveupdate>`
>  - :doc:`/core-api/kho/index`
> +- :doc:`PCI </PCI/liveupdate>`
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 08a724b860dc..347c435ca404 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -20833,6 +20833,7 @@ L:	kexec@lists.infradead.org
>  L:	linux-pci@vger.kernel.org
>  S:	Maintained
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
> +F:	Documentation/PCI/liveupdate.rst
>  F:	drivers/pci/liveupdate.c
>  F:	drivers/pci/liveupdate.h
>  F:	include/linux/kho/abi/pci.h
> -- 
> 2.55.0.487.gaf234c4eb3-goog
> 

