Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50E54C61DBD
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 02:49:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438516B0095; Wed, 26 Aug 2026 22:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DDB6B0096; Wed, 26 Aug 2026 22:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34BF66B0098; Wed, 26 Aug 2026 22:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 121146B0095
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 22:49:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E7C9120303
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:49:22 +0000 (UTC)
X-FDA: 85145518164.28.2C3B501
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf30.hostedemail.com (Postfix) with ESMTP id 50E2280003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 02:49:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hzilSf0A;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787798961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mtxyjDR/AkeJ1U6spdGadiXVy/JeYOrATb8gpHS2GT0=;
	b=dgnI0Bw0rq3dTtOfvs5tO68L1Wo8DpkoUx6nT60JbKkATF/EkQlE8KtVlaiOEw1PH3WNNn
	F7hZc10XVdsiCi6/zWZkE6ElTHeZSU98e+k5THM+9HS1fMQ4BpkLQHRH0Taem/k/wR8G7K
	qFa3IDtaGpHcpS22cHe/4fA8qATsTvc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hzilSf0A;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf30.hostedemail.com: domain of liam@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=liam@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787798961;
	b=qPUhqif74hkTfP1aN4ZGxleDhbmHu1rjBUGwLmR43/vXyjkESw6KGn6xfz1Op+pQiMKPOB
	M4+Jl97HkVvYoN9iKxY9jp+IQqYfBIf86Z8a03GkLvxLFyefURP+6YBaU4Cmbcwv5pVEPt
	l4/HDMaNkIltUqBVDp2tx7a6y31CY9Q=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=mtxyjDR/AkeJ1U6spdGadiXVy/JeYOrATb8gpHS2GT0=; b=hzilSf0AFvb2ZflmV2+sTecXFZ
	c+ZiHEEu9zIe5Hl7/d3U4hFO0C2IUv96B+a0S8z0KpSHG1dEluzFwpJzxUXd0IkP4Cqg1MOsrsksE
	ZCRIJJzwZ+ocO2aS1OOg9+m/t1TvcmIY5xGgYQ0lvGLlnGMs18TxvYWj5p6nhZdne59VSDSjCma8A
	/F8Svk2oFlkIboL8M6JbZCyDHzIezjb/Rq9PO/81mpeDwn3X1SQ+NcyPozPj0WcUlsOSyj8T0/W0x
	0mK2QmVZxJ3z2SkU8c85t1fE3jIzKOI8CI5YZ18ZdpAwqzSeWVyhM1dw5MmJXM0xV/wSL+o76iAOl
	eqmCTZbQ==;
Received: from [38.23.173.23] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wzQB1-00000003KHf-19Y2;
	Thu, 27 Aug 2026 02:49:15 +0000
Date: Wed, 26 Aug 2026 22:49:12 -0400
From: "Liam R. Howlett" <liam@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>, 
	Catalin Marinas <catalin.marinas@arm.com>, Danilo Krummrich <dakr@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>, 
	"Rafael J. Wysocki" <rafael@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, driver-core@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-riscv@lists.infradead.org
Subject: Re: [PATCH] drivers/base, mm: move arch_numa.c to mm/
Message-ID: <xzndraf66344jbze5gfst2ugz5plr4cqsgv7hiw4w2vefqekn6@fkaqeczif5cb>
References: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806-arch-numa-v1-1-968ec128121e@kernel.org>
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: uusk13a41h65d36bharyjexxek7ywfyt
X-Rspamd-Queue-Id: 50E2280003
X-HE-Tag: 1787798960-63458
X-HE-Meta: U2FsdGVkX187OWUq7HBDYUg4ZfohgjTEpl5YozTSrdujvRhDp7mCmgHfti2UyhuX75a6tJiEqM6qMXN/DOKWd3/CWbhzhg17/8F13WLE/Q06CPMCC48KMLLVh53EAcrlAkllJm4bwBR9Ph3hSu1mcVJI58An+NwyxD28MUC79bo1geRolaYdEqRvnN+o5EhKDXHh7bAteApa6SdbYw8+KJhj7LexJsNSqcTRn3ZL0uPyLmYFM5i4RszMWqvi/9LsIW3y6WrXrvpzH1kbNdEuZnD8V0pQl4U4jc1pfJN95oLWaKEzic+xx+19cBidJvCrsV+1YCAYTHiHeokPbMvnHMT6iQl0Wv9JNDIV07CZOQUWUHBLsp6mpSfcKxo/m6QbzngjpxxTlUN4kCY+W0Fo7v95A+/YkUZ7uB9kjtfn8RWNTZDuVJsn33kFZdIZmPN925C12Ds5Gf8n648NlNQH/Wj9rt9z0NVih//iL3JPQlw+yGU3EBiH72YlJ61iSh7yMB6USaT7zNwJFYMzfqWfsIyYi5S3w6rwkHvkLKLI/PNVrkC4sk//RMnPIZ4ItOZQ9Vt7ibUAeWj83fWRTSQ/BfQutpkWG42fjmPkhGVCbXVyXU1CN3yKrqCJkl0nPEjU16OUuDllK7LPL7MzQu055p+PGcJd9cpSd4nGyVNHi5b2sDx9rXpZFlucUNFX+444ZjaFbu7PzO9jFASmVbrhgHySoe1MN0jgNhiIBpSavjb2PXFiLA+/g9ctsr/X+oAr81I7DMB4D3YZUWtciOKHAYrHdhAf34T8OIxLolTgLb8I57scvHI9a6uuWCUXjEqbu6H+o5KoAAqYmIz3fMgqHVjeRC3V3xGJcCNDhTcBplyGl1tm5BhdcBNvtlhBcWnx/G1ysmtb+k787swc9lz/yDEuwNkmOflSA4n0+OAyVMztufiEF4SkYQyxZpNMQvtRRibB07IidRLTAMDBnyu
 H6GZNNOM
 E3fp4ZM61O8WRfPdQ8NeexHxa7VKe6W/NQUs9u2YnSvWv69m8UbIv136zfeM5Jy7NjjlmPlWF9gn5/QEzismbkg6xwdVMgtuxwJfw7MKV91yj+DjEe8gZV0yyPFgauvZnK5a6m98APpcQBd7oEUkCXZTgzzK4YjaVRhg1dDnXa82yruBWjpfTXlZMVB0tcWHT0oGihK2wFjFzIn11iAEg++eSmf3BCAetsEGf+K7y04aqByDP27uOCtnqUo56DDxCB8/8I04BOzoceKJIRbpQiZLIeVGLiMjeknaEMig+agaWQ91JZjBHrx5VvkVvsIeZWpMVMRq1oG4ep3JpB7gb4wWUlW1DrR3aOKXEjDnuuokM22G4A1kiv/tOhiIx4WMmJusKEg7PPUxDfyAyeG1oxYNrJkhSqH+x5gQy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26/08/06 09:58AM, Mike Rapoport (Microsoft) wrote:
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

Acked-by: Liam R. Howlett (Oracle) <liam@infradead.org>

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

