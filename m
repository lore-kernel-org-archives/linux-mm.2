Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEC1CCCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595F78E001F; Mon, 20 Oct 2025 10:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 56DB78E0002; Mon, 20 Oct 2025 10:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 483468E001F; Mon, 20 Oct 2025 10:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 320A98E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:44:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D412BC01C7
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:44:17 +0000 (UTC)
X-FDA: 84018762954.28.1FE2DBD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 04DF41C0015
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:44:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RgaseN56;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760971456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mjmrLiEnUw5RdTn5K9ZXIXU3c1rqI8QJb+G/CCgX0/Q=;
	b=TXYsHwJM/WHzhipnMaSdzZ0gAyk2iEjF7a232hAMvgt5vxo058Ves9k5nTKcfy7XDo/Y0F
	3W/ZCmuA8xpBwhxY7oIQFIWXIb8LYIqiAis92apSOqzRzKjXtrjSVz5goav68877FbZXZB
	sNpZ8NektWu457oSDI+QB9qhmLFaGVs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RgaseN56;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760971456; a=rsa-sha256;
	cv=none;
	b=Atcs4PWREfm2m6KCd3eS0KOVlL5MjFHOw8zcem96imSX32byMzhCN66embQevOUDgtyaNI
	JtwOSJk6Yi76PPlyOx0sxp7dIvRYytc4ZcK2yZKTo3xc6fYvw/vPs4nwQYrMg1XddB+qiO
	DIqqg4S3SmdIYJsT5IppxJSOv4RtfTM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ABBF944ED7;
	Mon, 20 Oct 2025 14:44:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C604C4CEF9;
	Mon, 20 Oct 2025 14:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760971454;
	bh=nfwcoBQDs5/xcFwFzkbrbCpDXKgvjiSzhLDxT89/Ce0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RgaseN561HDUFkIyahcgHt+E1tyuc9UKQnuIwwR0jA1931g/EW0QcmeaeGxhOZCu7
	 MXLi/EpX2bhpioI3LkcaFU4aPfqr5ZoJtK6rT6qcco+lwxNhwV/CJOi7k1Vka3bh8m
	 YphDFZ0BqrsxiFvrIu0nHg5Eo+bgdmdH2hyrTVF4ULTI22kB4otIEwnwf3/hztM4l9
	 Ez1k5HuHuGgrQy1oT7VB9UVlT13oHEkbAMLT4Yhu0S7iT44VnhNBIDZTRnmBPWIYxR
	 7GfTzhsMUu9GN1Vp9UO9fQzfVlTniWmIJXO5PDQVxALtLUrFVMsXkKotAsLlk2nhq1
	 jRcHtOOyChIwA==
Date: Mon, 20 Oct 2025 17:44:08 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org
Subject: Re: [PATCH V1 2/2] treewide: include linux/pgalloc.h instead of
 asm/pgalloc.h
Message-ID: <aPZKuOKlb87yX0du@kernel.org>
References: <20251019072509.9488-1-harry.yoo@oracle.com>
 <20251019072509.9488-3-harry.yoo@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251019072509.9488-3-harry.yoo@oracle.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 04DF41C0015
X-Stat-Signature: xcd6q3uz1xj47z1n8fsyos98o5worq68
X-Rspam-User: 
X-HE-Tag: 1760971455-955203
X-HE-Meta: U2FsdGVkX181tKdpMoJZfbINMvVZNNEkJlABhAqsUQxnzV8cP6e9eSvtnsQm4leuMzHZYnDlec9kVMkDczFFFllfsQzQD/r1KSVLr1jNAADd6fM1vDI2FE2+lU71LaNJU8zO2CoaNJnIuOSNV5g/vscU8yHqhZhdVijq6dTLZPcxdnG/NyZ/FMHrP3WAnIaa6B5g96Vz3hAjyhh3QfEpkgAXxVUPfiV4voA9UB+XPt+Kw3ihHnqXuvW9mmwmDFQ8wSydQdyzL63ZJvs47abC3AW3N9TchJZnbVOQEmHTpFXxYFCSJtGKNrpu3w8da7eOLztbE1o/JSi/DHTeX3P4jujNqCwV+kYeW4N6WLGk9J++CtJfF2R+N5wbPIZWEqyfhMRNCBdkCDU4Oop8NPTFEDIufR+a0Q9dBW+niHUyR6gzfGBFuvTu5/H5irvnRFNEWvY1xin0aZY4Nu1zKiwbwqYkw1K6re/yLT5v1h7pK7QnT/YeXwenm0opELz4/SeakkLSVc3dKnonm9nzJ4Yq0zgQIoJtA1VQNcTWTkJtrR6Q0l4UEbJmOeCI9CKQHEeArwtOWM9riASHAW5Ah6hPSnUAvRXmaK4rWr7ChzaIkRtOaNNR0xcMeH5SsDMHyvnQGGHmbmPvyySTnZUPHkJiBGfU29yJn3Rzja5b9AiV0JdMRT8eaeybe5FQF201Dvv6cr8f/8ojscCyjUj+m3+cM1fotVfdJmp2xol6rg1pJJTLCX5Fc4MunuLJCStsCwd8i9DhA9m7sKj+Z0QdfuNkZ/WazmtPe0iBOkunznBwtKYJfDdvdfo79TSV0JAQlVOOyiWaOBkcyMC+A4672KA6PtxqaPGHA4gs5fzEks9lf82UXX1aSKhE1LQR8FXuPSXx9Py13++sr+GCyHoRr3UfUjk7oWoZAUs14wv49eYXhExHl1TOD6JqYXp3ejyR5Wsa/YSf4yEZIgD1HRTiPoy
 mmpgScUC
 gQF29sNV+NZpRXcpWrLcY0Y5aGiwqMZnTa37hFbrwHG4nIAlsmcLRFJnQEv3bG7seMa2O4eo7yyE5ZKQFO4nmjWMY3MjUeHetBjTr18Jsrb/7HB0MhMwEX8HoFh1UtG+w6zSPQH26CXgBcbl6Jt4t4CfaVNI8GtTBskmAaFZrjZnpFqPAxliOdMQE/l9BlkiR4cYMa7ZsPnQiemxahYVLuULKiK/NZf7u/weblowJYONmNcOhG7PSXSdcu31GFHbQs5TrPpThS2pbgG1CKDqFvOcUgRH54HNBPUMXswYNWFY4bn+glAgt1C+z91DqhcofFQP9GA9gsNuOPtY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Oct 19, 2025 at 04:25:09PM +0900, Harry Yoo wrote:
> For now, including <asm/pgalloc.h> instead of <linux/pgalloc.h>
> is technically fine unless the .c file calls p*d_populate_kernel()
> helper functions.
> 
> But it is a better practice to always include <linux/pgalloc.h>.
> Include <linux/pgalloc.h> instead of <asm/pgalloc.h> outside arch/.
> 
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  drivers/firmware/efi/arm-runtime.c   | 2 +-
>  drivers/firmware/efi/riscv-runtime.c | 2 +-
>  drivers/s390/char/sclp_sd.c          | 3 +--
>  fs/dax.c                             | 2 +-
>  kernel/fork.c                        | 2 +-
>  mm/debug_vm_pgtable.c                | 2 +-
>  mm/filemap.c                         | 2 +-
>  mm/huge_memory.c                     | 2 +-
>  mm/hugetlb.c                         | 2 +-
>  mm/hugetlb_vmemmap.c                 | 2 +-
>  mm/khugepaged.c                      | 2 +-
>  mm/memory.c                          | 2 +-
>  mm/mmu_gather.c                      | 2 +-
>  mm/mremap.c                          | 2 +-
>  mm/pgtable-generic.c                 | 2 +-
>  mm/pt_reclaim.c                      | 2 +-
>  16 files changed, 16 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/firmware/efi/arm-runtime.c b/drivers/firmware/efi/arm-runtime.c
> index 83092d93f36a..2e3b5131df32 100644
> --- a/drivers/firmware/efi/arm-runtime.c
> +++ b/drivers/firmware/efi/arm-runtime.c
> @@ -19,11 +19,11 @@
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/pgtable.h>
> +#include <linux/pgalloc.h>

Looks like here the includes are sorted alphabetically, please keep it.
  
>  #include <asm/cacheflush.h>
>  #include <asm/efi.h>
>  #include <asm/mmu.h>
> -#include <asm/pgalloc.h>
>  
>  #if defined(CONFIG_PTDUMP_DEBUGFS) || defined(CONFIG_ARM_PTDUMP_DEBUGFS)
>  #include <asm/ptdump.h>
> diff --git a/drivers/firmware/efi/riscv-runtime.c b/drivers/firmware/efi/riscv-runtime.c
> index fa71cd898120..5b8d72885fee 100644
> --- a/drivers/firmware/efi/riscv-runtime.c
> +++ b/drivers/firmware/efi/riscv-runtime.c
> @@ -21,11 +21,11 @@
>  #include <linux/slab.h>
>  #include <linux/spinlock.h>
>  #include <linux/pgtable.h>
> +#include <linux/pgalloc.h>

And here as well.
  
>  #include <asm/cacheflush.h>
>  #include <asm/efi.h>
>  #include <asm/mmu.h>
> -#include <asm/pgalloc.h>

...

> diff --git a/kernel/fork.c b/kernel/fork.c
> index 3da0f08615a9..9d48646e659f 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -107,7 +107,7 @@
>  #include <linux/tick.h>
>  #include <linux/unwind_deferred.h>
>  
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>
>  #include <linux/uaccess.h>

I'd kill an empty line before include <linux/pgalloc.h> and add one here to
separate include <asm/.

>  #include <asm/mmu_context.h>
>  #include <asm/cacheflush.h>

...

> diff --git a/mm/pt_reclaim.c b/mm/pt_reclaim.c
> index 7e9455a18aae..ec6fe4eb2644 100644
> --- a/mm/pt_reclaim.c
> +++ b/mm/pt_reclaim.c
> @@ -1,7 +1,7 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/hugetlb.h>
>  #include <asm-generic/tlb.h>
> -#include <asm/pgalloc.h>
> +#include <linux/pgalloc.h>

Please move it before include <asm-generic/tlb.h>
  
>  #include "internal.h"

With those fixed

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

