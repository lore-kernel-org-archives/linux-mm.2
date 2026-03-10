Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E78FD4F13
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 18:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B845F6B008A; Tue, 10 Mar 2026 14:00:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2B486B0093; Tue, 10 Mar 2026 14:00:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38286B009B; Tue, 10 Mar 2026 14:00:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 822F76B008A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 14:00:56 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0CDF18B149
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:00:56 +0000 (UTC)
X-FDA: 84530919312.05.3BAFFC9
Received: from redcrew.org (redcrew.org [37.157.195.192])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9B7AA4001C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:00:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of dan@danny.cz designates 37.157.195.192 as permitted sender) smtp.mailfrom=dan@danny.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773165654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R1/mlvtAuEpLwt0CAiez//WsTw+/EMUNNqryDcYUQIA=;
	b=3WEUY9ktyHmyQY/93r8hF92T7ZcpODGLXBqy3m6r9ijxS+4RgDqd8n7C8WX32QXM0U+/vI
	lljRG0sGzWR1bICmcDkXhj4N0ew1WpN2TMJStEANEMFh18wrt7DbWSH6+rqzl1wn9xurUi
	+zCoUnrryol3wO/RjRqTv7j4bi7HP5U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dan@danny.cz designates 37.157.195.192 as permitted sender) smtp.mailfrom=dan@danny.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773165654; a=rsa-sha256;
	cv=none;
	b=Ghd0MfeQ17IyetrRDxMpelYoMXi+MTq/Gyv2wzoeE8ehRdO+1YVpakVmWi/LQAPOzUV0EU
	tWAQscyuKvTlP2+kkx+OMrSBVXskPVmwgrAev9aK5Q4baaXJZqBP+77yMBFW2W208xmSrs
	7IUrZh6LTLmy7weuoZl/Lr2+JnfjRls=
Received: from server.danny.cz (85-71-161-19.rce.o2.cz [85.71.161.19])
	by redcrew.org (Postfix) with ESMTP id 6441ED4;
	Tue, 10 Mar 2026 19:00:51 +0100 (CET)
DKIM-Filter: OpenDKIM Filter v2.11.0 redcrew.org 6441ED4
Received: from t14g4 (dan-vpn.danny.cz [10.8.0.6])
	by server.danny.cz (Postfix) with ESMTP id 1033316A001;
	Tue, 10 Mar 2026 19:00:51 +0100 (CET)
Date: Tue, 10 Mar 2026 19:00:50 +0100
From: Dan =?UTF-8?B?SG9yw6Fr?= <dan@danny.cz>
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, Madhavan Srinivasan
 <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, Sourabh Jain
 <sourabhjain@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Donet
 Tom <donettom@linux.ibm.com>, Hari Bathini <hbathini@linux.ibm.com>, Mahesh
 J Salgaonkar <mahesh@linux.ibm.com>
Subject: Re: [PATCH] powerpc/mem: Move CMA reservations to arch_mm_preinit
Message-ID: <20260310190050.533044e6@t14g4>
In-Reply-To: <6e532cf0db5be99afbe20eed699163d5e86cd71f.1772303986.git.ritesh.list@gmail.com>
References: <6e532cf0db5be99afbe20eed699163d5e86cd71f.1772303986.git.ritesh.list@gmail.com>
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9B7AA4001C
X-Stat-Signature: 81fgg1ss9xn8bd6fqry36mh6fatb6umf
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773165653-384321
X-HE-Meta: U2FsdGVkX19+poO/6ljEg0ZqSHmcb3SpmLaf+QLHhXa2THdAZ67+BZZIyZX0MiGL/9mv7ClAC9RaaYDHdSG9hYr1rxryS5XEhkdhhTCXaqnnnU4HnFozP4u+9OOZma/Q15igH1z7nGw8G9sbMGrlzbPdzvSjtDg3EpXY9vR7LXsMFpY8CNGDjU4VpMlV50qeRlm1THs6pIuJGKLfl7LGfwB/gxrqSsc9NSMzNE7HK+UAvK9sJ6kciy13qO9vn3ivCU/bcdGwghbh30TyztVXLCPN8XmwzfuVy5YBSTVbWVNkdHEbZ1kpF4OneSOKRAu2JhZ44N8Ocu1hDwxtGKHT3c5cGAsYGxinnJxApqpRhYM9lhauSsG320Yt9dsAHutGH76YOntFdxLcm7vMCf4wLbmzhP4NZZ5aq+gpIXKOsP/6kIijgNNTs5w7D30+Ins5Ev40Bin5FrP//O9yF4tuZQQZgys3HnKaMe2rrhIuA9cDFFfVbrE96VduWhn7+MUl2O6sfHybOl+SUxe0+RxkS0JYt1Lcfu+QN+h4PEYPlCFJD+Qiai+TFI0aCWUCAK+WvKpITZbM4B517v/5RO4p2sNaeptVsvo6mlWiF2ls2uv700sjOjAOuHVbIGoWRYcDB48YIo9eo64q83PZskD6GIFRdh/6mEFPI2Hls1UH2P/PBr/tJjrWzPFtgAgCNh59IaLKSr5DigU67kIbHpb4eSMWttBuQyB6IZofjBOBOFtyp2AWfWZ8g0vFjH9AyCt3Q0d9J2VT2VQ/q3qLOjoLcOkRicf5lP8t+EmVb95f9IdavTUgHc7jjt/Ig0OcZx5/+lF9YEGBaY4SXde3mcEGrsD+QSuI7eUsqD97qT6whaFZvL/nZ+HBCZA/dCcO7XWBytzJbrwLkUhwlqUpnA+gAOl3tjSNpZ87phxpiwUHLOqJWhYSFTMmern1uqBNU22tp3xSba2M9rOgsKEmspV
 BHGDrEDa
 0yoby4fnwj7Z08kWNUTDl5N3miybfnnhU1ZOoHQpDWThmg+49n0g3NyWv3CSedc8hO9qK0gdiJ1YjmyiIuHhpXxoZgMmCZ/zk3JEMIVJyNbT6IihW1Mm+8HoNM4oxCiclpEg0mis1B4v+JHpYVI8QQSmKZhS23t+WdeHiDHj0zW+j5kPgKyEDI0ChaWqfawzcIkkFFVMzyQ5Rvgw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ritesh,

On Sun,  1 Mar 2026 00:17:59 +0530
"Ritesh Harjani (IBM)" <ritesh.list@gmail.com> wrote:

> commit 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE memo=
ry model"),
> changed the initialization order of "pageblock_order" from...
> start_kernel()
>     - setup_arch()
>        - initmem_init()
>          - sparse_init()
>            - set_pageblock_order();  // this sets the pageblock_order
>        - xxx_cma_reserve();
>=20
> to...
> start_kernel()
>     - setup_arch()
>        - xxx_cma_reserve();
>     - mm_core_init_early()
>        - free_area_init()
>           - sparse_init()
>              - set_pageblock_order() // this sets the pageblock_order.
>=20
> So this means, pageblock_order is not initialized before these cma
> reservation function calls, hence we are seeing CMA failures like...
>=20
> [    0.000000] kvm_cma_reserve: reserving 3276 MiB for global area
> [    0.000000] cma: pageblock_order not yet initialized. Called during ea=
rly boot?
> [    0.000000] cma: Failed to reserve 3276 MiB
> ....
> [    0.000000][    T0] cma: pageblock_order not yet initialized. Called d=
uring early boot?
> [    0.000000][    T0] cma: Failed to reserve 1024 MiB
>=20
> This patch moves these CMA reservations to arch_mm_preinit() which
> happens in mm_core_init() (which happens after pageblock_order is
> initialized), but before the memblock moves the free memory to buddy.
>=20
> Fixes: 4267739cabb8 ("arch, mm: consolidate initialization of SPARSE memo=
ry model")
> Suggested-by: Mike Rapoport <rppt@kernel.org>
> Reported-and-tested-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Closes: https://lore.kernel.org/linuxppc-dev/4c338a29-d190-44f3-8874-6cfa=
0a031f0b@linux.ibm.com/
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

awesome, this fixes KVM initialization issues in 7.0-rc. Successfully
started a KVM guest on a Power8 based host system.

...
Mar 10 16:48:11 fedora kernel: NODE_DATA(0) allocated [mem 0x3ff4f9c00-0x3f=
f50197f]
Mar 10 16:48:11 fedora kernel: kvm_cma_reserve: reserving 819 MiB for globa=
l area
Mar 10 16:48:11 fedora kernel: cma: pageblock_order not yet initialized. Ca=
lled during early boot?
Mar 10 16:48:11 fedora kernel: cma: Failed to reserve 819 MiB
Mar 10 16:48:11 fedora kernel: rfi-flush: ori type flush available
Mar 10 16:48:11 fedora kernel: rfi-flush: patched 12 locations (ori type fl=
ush)
...
was the error message in 7.0-rc3


Tested-by: Dan Hor=C3=A1k <dan@danny.cz>


		Dan

> ---
>  arch/powerpc/kernel/setup-common.c | 10 ----------
>  arch/powerpc/mm/mem.c              | 14 ++++++++++++++
>  2 files changed, 14 insertions(+), 10 deletions(-)
>=20
> --
> 2.53.0
>=20
> diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/set=
up-common.c
> index cb5b73adc250..b1761909c23f 100644
> --- a/arch/powerpc/kernel/setup-common.c
> +++ b/arch/powerpc/kernel/setup-common.c
> @@ -35,7 +35,6 @@
>  #include <linux/of_irq.h>
>  #include <linux/hugetlb.h>
>  #include <linux/pgtable.h>
> -#include <asm/kexec.h>
>  #include <asm/io.h>
>  #include <asm/paca.h>
>  #include <asm/processor.h>
> @@ -995,15 +994,6 @@ void __init setup_arch(char **cmdline_p)
>=20
>  	initmem_init();
>=20
> -	/*
> -	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM=
 and
> -	 * hugetlb. These must be called after initmem_init(), so that
> -	 * pageblock_order is initialised.
> -	 */
> -	fadump_cma_init();
> -	kdump_cma_reserve();
> -	kvm_cma_reserve();
> -
>  	early_memtest(min_low_pfn << PAGE_SHIFT, max_low_pfn << PAGE_SHIFT);
>=20
>  	if (ppc_md.setup_arch)
> diff --git a/arch/powerpc/mm/mem.c b/arch/powerpc/mm/mem.c
> index a985fc96b953..b7982d0243d4 100644
> --- a/arch/powerpc/mm/mem.c
> +++ b/arch/powerpc/mm/mem.c
> @@ -30,6 +30,10 @@
>  #include <asm/setup.h>
>  #include <asm/fixmap.h>
>=20
> +#include <asm/fadump.h>
> +#include <asm/kexec.h>
> +#include <asm/kvm_ppc.h>
> +
>  #include <mm/mmu_decl.h>
>=20
>  unsigned long long memory_limit __initdata;
> @@ -268,6 +272,16 @@ void __init paging_init(void)
>=20
>  void __init arch_mm_preinit(void)
>  {
> +
> +	/*
> +	 * Reserve large chunks of memory for use by CMA for kdump, fadump, KVM
> +	 * and hugetlb. These must be called after pageblock_order is
> +	 * initialised.
> +	 */
> +	fadump_cma_init();
> +	kdump_cma_reserve();
> +	kvm_cma_reserve();
> +
>  	/*
>  	 * book3s is limited to 16 page sizes due to encoding this in
>  	 * a 4-bit field for slices.

