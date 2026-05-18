Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A2A6CD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 11:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97A2E6B0005; Mon, 18 May 2026 07:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903F06B0088; Mon, 18 May 2026 07:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F2A06B008C; Mon, 18 May 2026 07:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6BE946B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 07:43:36 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 323B71C0892
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:43:36 +0000 (UTC)
X-FDA: 84780355632.08.C137899
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 769A240011
	for <linux-mm@kvack.org>; Mon, 18 May 2026 11:43:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FPJTLxZg;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779104614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=92niO+O/mrk/7iTlLJ9ktHE+rGcNmO8cfGUdOuxXtQQ=;
	b=rMEFlV0ZgJy406qzXfk50O7FyqRbPYiOfaeXZ38fZ5zGyQIAWUsOWaZb2wSa4rjWaXRGWV
	HB4WMw65J1JjiwLT+1mqg0d4sJ8aoaovaHpFhgQnwRHTRl9jtPtmPzgifQA1YrnPKF70QQ
	nPb5FKT0vcikCWlL2FpXQcynOSDtAJM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FPJTLxZg;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779104614; a=rsa-sha256;
	cv=none;
	b=YnuVj9hNNdQBtp0Cac4nGc6f7pTbpN25tiCJFUXl5SmS9IdPHpg1s21kU/mjZmtU/EMwwy
	Gro6H6qmTJM0fpKMs/rrtxGOKn7BgVpmNDa8nXpNyQ7EGOKHcIWExxtRwqcBPhmX/uF37+
	oc6DiUogvTPoh27ISIpsV/+vQGB3t+c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57DBA400D8;
	Mon, 18 May 2026 11:43:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64987C2BCB7;
	Mon, 18 May 2026 11:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779104613;
	bh=NwRHLAJsOaN4Dj+muAR6EQyF5lPlAIab8xZkaoNQArs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FPJTLxZg5YCe0QNfd49BMjmAxKT9sopqbynLQlobYFv5iz0hapCYXxrE3+nOeMvbf
	 THbg/Uu529siYkaBgQMfeEiAjMFRQzHvyQbZXX647k0NXtL8W5i1K94MH8d8G5DzhD
	 b+yyyQoZvQePkAVg6riNbFOherT0VXl8SuuzgViWkzkAwQdF9jSpymnJ2u1FRi16rx
	 mp2GBvD9pUOWyfXePS6dFLhnCFir5AXOu83JQand5+rLVGEcOTAA+u4CfGlBugKvDw
	 F6ot2fPHvk7giHcUz+0iky3F3DTv2KJ01QzDcu116hKPO7ftPek5nLOGHdVhTbfN11
	 94i3E8GCW5UTA==
Date: Mon, 18 May 2026 14:43:26 +0300
From: Mike Rapoport <rppt@kernel.org>
To: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Rich Felker <dalias@libc.org>,
	Yoshinori Sato <ysato@users.sourceforge.jp>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 00/10] sh: remove NUMA and SPARSEMEM support
Message-ID: <agr7XvoWn_-axX1-@kernel.org>
References: <20260510135546.13554-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260510135546.13554-1-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 769A240011
X-Stat-Signature: i3y16oxecn1xtynf53o3nkuq1qnwbkst
X-HE-Tag: 1779104614-949754
X-HE-Meta: U2FsdGVkX199uAlJtt9/EQiU9n/yMJd33qg2gnE3QAklviRsfqr1YUsAs22LJFuIvL7n6w2iGF8X5gHW/V7V9u+fa0wG4F2OR3ZHSfntOh3BzE7zQ31J/+fcqpCYxSp/ao9TTenoA6YfLE293MZs2O9nC5OGNmX9nZ0J8kcQ9F//whOMtd05EVEO0ZWooIHy9JgSAACJODLJrwkMQCSmcDsg2sANArMPIKiJ3HbPHs2MPjOwD1Pf0Vfi6gScpOpsWFmsJGrbN3bImOIlIW+jKFsJ7JA+FySvMFupid+ki2zWbYXm31/Oy+NOx12WoGl7ZtHSG867ztlY2ylFs23ZJZ6ThybLdgort85A6+vLP7Lbt3l9LNsUYnRpEZlQ2gUEjW5C54A94MNcjNLj+bw1GPKdxtwf4P/sFJgxwCxVqOlZ93br+hRyOn/ibiHWLQiIE0GDcELj7Y/hgGo2e92IwAi8uKndhGROqtmaapoB+5Nl6eQC3j5pkr0nF7iuUlizDEI8L7+fsyrC1GBqH8O+8xbfbj2NK3JN27giG6hjXqOMs9U4KSa9TBRz15azpaskuOSbsiDfQZtSL/B+aXCaO9NpIPI9Kj+KYQsQQPBqUof0ypk87CjvS7Gv28hx40jU1Vjxllib25wjtafk2P7XT/YHHLH0Ua1O9a9bbmkh5/YW9+QBK4hoL1v6Pl86E46e4ABrHtySPtqHxCRnqERlM7pLBxWaFlpTcOspIM5NG+PfWfUeRil0PmuzfXlGO3tbxUJk53auEKelvbgDLmBLSnk/5aS21qs/03FP/kFTwYCWkqEWmWNvisk1Z9CYZSr7Bd4oWSq6j/zG4ueYccV8IosCoYfgZvHPaymTPDoxpLfknJjiKqVPKuoIBEYgUy2DTLDBmS0AbuLe1KQAJNPUlYWfqw6yUpQMcLc0VWqLAc5lc0IW0wdzoajtMjff2dP1FfofWHvhP2bhMbM/sBB
 qjy2HSDr
 MzyvOaW6USzlZrORMYZ1zbB1tDdXKRgTl8PVwEZhZxViDuEkwpgMW2xVIMxYVTCGmOHWEcxilRRvHaiAA5vx8dgdsZizIAxbE3TcQH/Xww51ehf0N+1rMjo0vxJDIxNqxKR9Qjf4cXFrtHSTgvISpJjAz2qGcEQtYGwF9Fpakdh0g9O05VZSyVrmNlNrXVJ1lrfGKlauud8SjzjrinQJlyOusMI/c+wLe0ZFj0J59FCML8ECVYIlVJ/iZKO0XTi6XnHc/18TV7GwONf14YfW6gFYrMw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gentle ping?

On Sun, May 10, 2026 at 04:55:36PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> Hi,
> 
> NUMA support for SuperH was introduced a long time ago by commit
> b241cb0c885e ("sh: Support for multiple nodes.")
> 
> 	"... for boards with many different memory blocks that are
> 	 otherwise unused (SH7722/SH7785 URAM and so forth)"
> 
> In reality, this added 128K of memory on sh7722 and sh7785 and 256K on
> shx3 at the expense of all the NUMA related code in the kernel.
> 
> For build of v7.0-rc7 with defconfig and the same configuration with
> CONFIG_NUMA disabled, bloat-o-meter reports difference of ~76k. Disabling
> CONFIG_SPARSMEM on top increases the difference to ~94k. And that's only
> overhead in code and static data that does not take into the account data
> structures allocated at run time.
> 
> And all this overhead has been there for nothing for almost 8 years
> because since commit ac21fc2dcb40 ("sh: switch to NO_BOOTMEM")
> those additional "nodes" could not be used by the core MM because the
> maximal pfn for ZONE_NORMAL was cut out at the end of the normal memory.
> 
> v2 changes:
> * remove stale SYS_SUPPORTS_NUMA
> * add Arnd's Reviewed-by
> 
> v1: https://lore.kernel.org/all/20260413104649.852228-1-rppt@kernel.org
> 
> Mike Rapoport (Microsoft) (10):
>   sh: remove CONFIG_NUMA and realted configuration options
>   sh: mm: remove numa.c
>   sh: mm: drop allocate_pgdat()
>   sh: remove setup_bootmem_node() and plat_mem_setup()
>   sh: drop dead code guarded by #ifdef CONFIG_NUMA
>   sh: drop include/asm/mmzone.h
>   init/Kconfig: drop ARCH_WANT_NUMA_VARIABLE_LOCALITY
>   sh: init: remove call the memblock_set_node()
>   sh: remove SPARSEMEM related entries from Kconfig
>   sh: drop include/asm/sparsemem.h
> 
>  arch/sh/Kconfig                        | 12 ------
>  arch/sh/configs/migor_defconfig        |  1 -
>  arch/sh/configs/sdk7786_defconfig      |  1 -
>  arch/sh/configs/se7722_defconfig       |  1 -
>  arch/sh/configs/shx3_defconfig         |  1 -
>  arch/sh/configs/ul2_defconfig          |  1 -
>  arch/sh/include/asm/mmu.h              |  2 +
>  arch/sh/include/asm/mmzone.h           | 42 --------------------
>  arch/sh/include/asm/setup.h            |  3 ++
>  arch/sh/include/asm/sparsemem.h        | 12 ------
>  arch/sh/include/asm/topology.h         | 13 -------
>  arch/sh/kernel/cpu/sh4a/setup-sh7366.c |  5 ---
>  arch/sh/kernel/cpu/sh4a/setup-sh7722.c |  7 ----
>  arch/sh/kernel/cpu/sh4a/setup-sh7723.c |  1 -
>  arch/sh/kernel/cpu/sh4a/setup-sh7724.c |  1 -
>  arch/sh/kernel/cpu/sh4a/setup-sh7757.c |  5 ---
>  arch/sh/kernel/cpu/sh4a/setup-sh7785.c |  7 ----
>  arch/sh/kernel/cpu/sh4a/setup-sh7786.c |  5 ---
>  arch/sh/kernel/cpu/sh4a/setup-shx3.c   | 18 ---------
>  arch/sh/kernel/setup.c                 |  7 ----
>  arch/sh/kernel/topology.c              | 12 ------
>  arch/sh/kernel/vmcore_info.c           |  4 --
>  arch/sh/mm/Kconfig                     | 29 --------------
>  arch/sh/mm/Makefile                    |  1 -
>  arch/sh/mm/init.c                      | 24 ------------
>  arch/sh/mm/numa.c                      | 53 --------------------------
>  arch/sh/mm/sram.c                      |  3 +-
>  init/Kconfig                           |  7 ----
>  28 files changed, 6 insertions(+), 272 deletions(-)
>  delete mode 100644 arch/sh/include/asm/mmzone.h
>  delete mode 100644 arch/sh/include/asm/sparsemem.h
>  delete mode 100644 arch/sh/mm/numa.c
> 
> 
> base-commit: 254f49634ee16a731174d2ae34bc50bd5f45e731
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

