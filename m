Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF3DC55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E7E06B0092; Thu,  6 Aug 2026 03:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5992C6B0093; Thu,  6 Aug 2026 03:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF696B0095; Thu,  6 Aug 2026 03:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2537B6B0092
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:06:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC31440686
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:06:35 +0000 (UTC)
X-FDA: 85069961550.27.0922134
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2B70F140004
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:06:34 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TwW+Ap/6";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785999994;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XcPioRNMll3r5OmjiUG/O8aq5a3hSQJFiegnJyFSvIo=;
	b=JFu+Ww80xId4DcP9lMsJtOe93GUfwKQnuQYcFgOGeWrKhqJzLl1wY7pZhCDZ6oqYs91H6Y
	NKGIz4Yh3jiXcbPXan4gmZm+gYU/SuWpVomL0MciRobjwGY5U9Wcg16J1PXgBaXT3PB78g
	Y2b9ysjx5729Xx5zwLbh1U57BHqsqwQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785999994;
	b=5tENt5hs1ts/Qn9ndudIGc7xkntK8wVFdgV9W9rkw3t7P08lT/hqWwuWNf4lf0V9TgTmoS
	i/82EBRbXIYxiijWp214eCtgsT4nGn26zZK5iAI0Yrm9nxClf92MBVoncAPAsviCMZxrWT
	MC6B2aXvngdaqEIZxffrHcnxiiAC0Jg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="TwW+Ap/6";
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F4F060A64;
	Thu,  6 Aug 2026 07:06:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE731F000E9;
	Thu,  6 Aug 2026 07:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785999993;
	bh=XcPioRNMll3r5OmjiUG/O8aq5a3hSQJFiegnJyFSvIo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TwW+Ap/66ZcREdQqckrwX9vkc4Z93jN+7IIPxPYOiPbMC7JQJLgHtNmGACiqreIOl
	 6VtKD+H1WXaB8vi7L7DUqflVCLVDxKlXaQOa27Y1xlE94I5MQBOCxaLpGxu8w95yxa
	 nLR7i2qRWqCJjI04VZ4iK2rOwaTxETtqALN8uBB0LDAJipUR20/MLuflvSH4jZOaTt
	 FA29yzKuOloFl8WVrOPL8Sah+FiTPLMEt4IBdUmubGhXtw99looSINmmGHL01wl69L
	 MBjZU/REIsuooI/qb4X3q+UnhFlXJ4tn0gO4xtQOKfODXHmcQcBGGM/SzMw2jWtOmc
	 oc1hySP12bYdg==
Date: Thu, 6 Aug 2026 08:06:12 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich <dakr@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Michal Hocko <mhocko@suse.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] drivers/base, mm: move arch_numa.c to mm/
Message-ID: <anQyFuRVekkN8Z5a@lucifer>
References: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2B70F140004
X-Stat-Signature: 1f8rrjzig3zt4631nankr7fnjeypfs5h
X-HE-Tag: 1785999994-549945
X-HE-Meta: U2FsdGVkX19UX2NWC7Ry9hayzuc6J455y0r0n4C10G40aA4qlIwHHATLNoFqbt6LxEKM+fRSVYLTcOh7SrCNzI1emB24/SaRckhTTgnNbVtYuhHPYy6G8vjgwrK1TBpbBgsg3nYo6kMVrA7fKl3v+LRVI/PNW3MUyB0PgShXqHhH89LIn1HHvA01eERO+SLCj7F8rOMPu8Vf5a4daeoKi+yvL9pK7LNpGx6KHjrLp1WpetbUKFSHSPSK2+xvDDOb4UAvx9v0dUwnPBgAw6b1noJpd+vNLyFOVDW5741jevbjzIHzrfsXemK20MqyOXDW8VWSQBcb3hGH3UAhlRwKE+P5ctgf3OIrFQ3x7tYK4iteJ+enOdPfvMI1j8acioFYqXlxjFzMGjjy1R2weLlHDBQyXNHjCLneVWEgLSsBJTcrotJ8RyR9mZTwl3QXvtNge1olPr8CtpQB53BCRAxEqv7pdt3d3aC0N0VFefy+P5Le978OMDUrPmA2qBFfBJqFcISj7efZsXgfhshJINria9GyjbWv950mXA0bC+0YG6WY4IQJrhLBXJwsXHfVeyr1dVJD2hJU9HXrdAyr9q6XqvNjB/Ie0xxoc6HDcRxBz/G9RDo0NCSFkxaYiULu+0AmmpPGKojUp0HENOGiNAoKId8kAbFAwspI24hlA0FxV46CdOUlj8+Ab2MLAJ5A3DkyMnbE2Iuo9wroz+BqoQG7M0jw/Z5fA7P07kfALbcWwTVgCNbtXV2XN7l99k1Um/98UlDvG87SmRmp/yE8P9+aa2s5AnyxHUpjDmmKP2EHBnMoeHp+d01OGcaGHXSKobRBbq3sD7LmNoC7tBfnwuv0kgvA/gpdGqvGPtIIYVrlUjKoN5C7DxmPQquulkPJ1qOIHDjX8R4G0vTUYGVkcDoEJ2hg1foyO0nDGaQM1Y4E55iIW/e40zjdYc0RdgJF2+R+042kyIJgC3XRNI4bA+u
 HAPI/TFm
 7NpjJ6I+ElItCK6SVxW5n+5dODNMU64Y/kAOP2JBXi77pKNBvXsSKQB4YgRD9q/IRgrQwquA3XuBJMB2EFGpGycMZm+u4Rh5HhdfeOXCt+BHjOLQhNOaB+S1rC1ORq5EJ1ku5v0KiJvBQ3kobo00RxM+kV3XHPe5Luptn7+eJYSnGkMMjT/OGUeQhl68J2Sj5YSsVDN2A4elQ0CutOgoduh1qZkM+ekV4jVn0PuPcnHCNgNmeGfqxRgWINFD0+5clly6OBXL3BNZLE4EigO3hTiU7bnLCidXZoD6N0tqAti3IvR0jRd+/OEhnJKZmh1Vm1LagrSSZEXveLhuuigAdE6YjnL/ZPuWfU8UTfpQhe1faj1k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 09:58:38AM +0300, Mike Rapoport (Microsoft) wrote:
> arch_numa.c implements boot time discovery and initialization of NUMA
> topology on architectures that select GENERIC_ARCH_NUMA (currently arm64
> and riscv).
>
> Since this is step in the initialization of the memory management
> subsystem, it's logical to have arch_numa.c in mm/ alongside numa.c,
> numa_memblks.c and numa_emulation.c.
>
> Move arch_numa.c to mm/ and add its F: entry to "MEMBLOCK AND MEMORY
> MANAGEMENT INITIALIZATION" in MAINTAINERS.
>
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Everything is proceeding as I have foreseen... soon we shall have control
of all of the kernel! ;)

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS                      | 1 +
>  drivers/base/Kconfig             | 7 -------
>  drivers/base/Makefile            | 1 -
>  mm/Kconfig                       | 7 +++++++
>  mm/Makefile                      | 1 +
>  {drivers/base => mm}/arch_numa.c | 0
>  6 files changed, 9 insertions(+), 8 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 5114e6db7307..465b64f8e93c 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -16880,6 +16880,7 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git fixes
>  F:	Documentation/core-api/boot-time-mm.rst
>  F:	include/linux/kho/abi/memblock.h
>  F:	include/linux/memblock.h
> +F:	mm/arch_numa.c
>  F:	mm/bootmem_info.c
>  F:	mm/memblock.c
>  F:	mm/memtest.c
> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index f7d385cbd3ba..1d93bfc34490 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -239,13 +239,6 @@ config GENERIC_ARCH_TOPOLOGY
>  	  appropriate scaling, sysfs interface for reading capacity values at
>  	  runtime.
>
> -config GENERIC_ARCH_NUMA
> -	bool
> -	select NUMA_MEMBLKS
> -	help
> -	  Enable support for generic NUMA implementation. Currently, RISC-V
> -	  and ARM64 use it.
> -
>  config FW_DEVLINK_SYNC_STATE_TIMEOUT
>  	bool "sync_state() behavior defaults to timeout instead of strict"
>  	help
> diff --git a/drivers/base/Makefile b/drivers/base/Makefile
> index 8074a10183dc..435710f643a5 100644
> --- a/drivers/base/Makefile
> +++ b/drivers/base/Makefile
> @@ -25,7 +25,6 @@ obj-$(CONFIG_PINCTRL) += pinctrl.o
>  obj-$(CONFIG_DEV_COREDUMP) += devcoredump.o
>  obj-$(CONFIG_GENERIC_MSI_IRQ) += platform-msi.o
>  obj-$(CONFIG_GENERIC_ARCH_TOPOLOGY) += arch_topology.o
> -obj-$(CONFIG_GENERIC_ARCH_NUMA) += arch_numa.o
>  obj-$(CONFIG_ACPI) += physical_location.o
>
>  obj-y			+= test/
> diff --git a/mm/Kconfig b/mm/Kconfig
> index 9e0ca4824905..410b8a0a92b9 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1469,6 +1469,13 @@ config NUMA_EMU
>  	  into virtual nodes when booted with "numa=fake=N", where N is the
>  	  number of nodes. This is only useful for debugging.
>
> +config GENERIC_ARCH_NUMA
> +	bool
> +	select NUMA_MEMBLKS
> +	help
> +	  Enable support for generic NUMA implementation. Currently, RISC-V
> +	  and ARM64 use it.
> +
>  config ARCH_HAS_USER_SHADOW_STACK
>  	bool
>  	help
> diff --git a/mm/Makefile b/mm/Makefile
> index eff9f9e7e061..fd29be716fa8 100644
> --- a/mm/Makefile
> +++ b/mm/Makefile
> @@ -122,6 +122,7 @@ obj-$(CONFIG_CMA)	+= cma.o
>  obj-$(CONFIG_NUMA) += numa.o
>  obj-$(CONFIG_NUMA_MEMBLKS) += numa_memblks.o
>  obj-$(CONFIG_NUMA_EMU) += numa_emulation.o
> +obj-$(CONFIG_GENERIC_ARCH_NUMA) += arch_numa.o
>  obj-$(CONFIG_BALLOON) += balloon.o
>  obj-$(CONFIG_PAGE_EXTENSION) += page_ext.o
>  obj-$(CONFIG_PAGE_TABLE_CHECK) += page_table_check.o
> diff --git a/drivers/base/arch_numa.c b/mm/arch_numa.c
> similarity index 100%
> rename from drivers/base/arch_numa.c
> rename to mm/arch_numa.c
>
> ---
> base-commit: 075b74841bd0065a3bda3440873c747938e69b68
> change-id: 20260806-arch-numa-444bb4806114
>
> --
> Sincerely yours,
> Mike.
>

--
Cheers, Lorenzo

