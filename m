Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 181E8F01825
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 10:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590066B0005; Fri,  6 Mar 2026 05:39:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53E046B0089; Fri,  6 Mar 2026 05:39:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 440816B008A; Fri,  6 Mar 2026 05:39:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3216C6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 05:39:40 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDDE41604C1
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:39:39 +0000 (UTC)
X-FDA: 84515292078.04.6A0ECFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4A8571C0007
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:39:38 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NJbvRGyn;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772793578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/SalwfpGQCltipIT4MiCUQUPdDyG+gQO0XadFgUZQ/Y=;
	b=OTW2vEq9c0ezgXc8o14+v8YHRloeNCtrKbzzBL+DnA+Xth10ZpyoM777q55ucNo8BBBVri
	+MCc0VR7Arl92rUZUMDwU4L3poHObzn1EjJs3oBLorwDSCkgFrpYKqeGNUvT1Hf3Q2ZxrS
	MMLEVEtXNNwGoZcUf97HAVSmrvUf7fQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NJbvRGyn;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772793578; a=rsa-sha256;
	cv=none;
	b=kNUI/kb+PDJbLDuT/VSi3C3IqDtXnnBEHkWjIUKK88IPR2iGGrJresWWctUvmcmHRxjg8R
	K9i/NuyvSDRGxJ2VeADL7MiuPIzVeEiOhQvAFgxfbMJ96sSCrVfn8pLMtT4/fZgieh+r0f
	ALsSBhX45KNQRr7GUAWPPfz//JQJgJU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B152B6012B;
	Fri,  6 Mar 2026 10:39:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A179C4CEF7;
	Fri,  6 Mar 2026 10:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772793577;
	bh=HWwbH/t+EtL/YKU6xmIeyjMDydOLWAaX0fFteuDV06s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NJbvRGynfZrP5aroIZ/D3g6XrllqG61UIy10x+vwEaV39i30AtfmvOcyfoi7v2mmW
	 y1Xnm+jB8AVRruQHrKncfbXDv3cZCHtTsMg0V+5BJ7RcZkzKKtj1BtMp2DY9j/jgbE
	 NK17i2s8TexnEXLGLKX9dIJP4F3t5Zr12krew+KlKhFjw3nuWhg4J5egqTMyU7ahis
	 tmHibWMx54gZVJiQ2oP3a/DO2978orcPz/qhBfev0C1IqolbZFGTuObSQHf+NXqNq3
	 ioidRrZCulU4LmNtsTf6SPvIbGaVav9Of0y+QC2a7CDCiiWDHZi6N7VuExHwhqa928
	 6z9cpEMXTEWPQ==
Date: Fri, 6 Mar 2026 10:39:34 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Usama Arif <usamaarif642@gmail.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v2] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
Message-ID: <5d01642d-1b39-48fe-870f-a261930aa3f7@lucifer.local>
References: <20260306081916.38872-1-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306081916.38872-1-david@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 4A8571C0007
X-Rspamd-Server: rspam08
X-Stat-Signature: ixjuxr4i66h5bpix6zjhzmxdiw8jhzh6
X-HE-Tag: 1772793578-857224
X-HE-Meta: U2FsdGVkX1+q6CDTmJtvquHc0eU+HXrufJBY2dql2bB70M7gBNefm3LKjCywnMFgFqswX1BwytoR+Feye9aoLzqaixBr/FrgRWxaxBIVNx4VJb2CHsnpk7a5xskEoxTEJAvj7fjWUlDgib2V3ChAJmxzkedhl8W79oS5IjvNAqbgyPJVkcuwJvu+KpWhlmhAf6I0dB8F6EwBCiXGLrcYxw3LVa2ILWcibfCcwiVBQUYuFsi/G+anfdJtFR1zLLXg3vwXQWNdznQbnxWb9dQQp/6UEJaOQY5lhh1PoX1vedD0s2qea2GiYj8lx64JD5BIbg2iXyKtMz0G+HM2lBhD9Dl+0fpamiWI6S8FLnb42bL/mznz8tbaHaFZpno/kjz31wiR3FGF0K3ovxTK0we+n9JMK8D2vt32joYSUEIaSJgA3Y1eNfQ7DjFNwIFrGJkSHwcBzeWgfoD9pl4QoJxo22P5pOgItQT5bOnmFSTvRg0PW3qSumvxmTVBbPScbtptJYzJSxD4EYEjDwhj1sKKhDo4gKvLagVnzWmAmRZqIskNSpfvxEzsQCYqy9p5W+8vgY06s9ZgANUR8II16aQx2XBa+EVbj0QUQTKGmSHnCLZGWekT2H7rCulu/ugPuZTn+U7QYkaZ3PBi7AZD3RQ9HSWyuqxqp7ba1//tZCb/lOA7lx/adBdqq2Qn8pUs/2lcawIYq2Ud3CWNqgy5c90dUC975nzohf+kTCBdag56+zPL+KNTyRuakMyhMr2FFI2vacj/geta7Gzx24su00Y3aJzngxPh5fs+7Z74p7YJTuw7x16mt1t+ncW6+786im/xHXfaZW+dDVPxN/r9OGehiDB9OCr24spwzgPNl1165Z5SjuNXTR6cFEYJBJAFoho+z1q7hv1preWR4SJ21xeC+wFvkRTfp5+NlsXtdKK0UT4mcRB2AtOcTVXfKQI5cNsO07+iYUC7XsHcFIsJeul
 rDCKU+BG
 tvNsY1A2gTEJKBNwc6dMP4FCS4Nxfxe+ngWThTCmPo4Jo8jxZklq+rMUj03Keh2kQrznBsXIgMUfvVxpaDD3eKf81346zxtMh379Kv6MHVlr+lMYfU9zfwsf9l/0qkNdfwFJf8YNCOTIbxVSPx2ytnzMGmsTYc3YS0RNxvkVw5LdnfmHudu5lVxIAyILnJxoPQf27RPjjkJgKLn2gz150pSZbP+Cx5hNmvMJHUln1kwJzpM00x0XdfYCCsKZluNzrQdnw/ne9ua8tDWQS3bSG/rSU9fLccMvbT4Y38GEVuoL582c+Ik7Wd/zxT6rQVgmVAAaXrfwgidxhwipYfDTmeqRm87jJSjMMBrS6kKw/xNlEFEpvGQH+bbh94EgPyN4Z67Go0YnBl9N/WiZpAExQOyoNo29JjVHPlwkKS3N5YZeMsfaupLmFSeReLGv4yTLpSLOFHJ8tCqWSZbU+l3aL9Mht56dcrmAXuHkcm+WihJ/DbNEojBfX8972Z0fTpsJ7zAHOSm1ENr49ska6wJ0s6nkkoWAjhvSQUbT+2j7Lk/poQ/5iSDWfA/e09hd+AjOjEUkD+jUWQH4r1bKVqsXKUzxY7r4dj4ieE1BgmBHWECgg+Bw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 09:19:16AM +0100, David Hildenbrand (Arm) wrote:
> There was recently some confusion around THPs and the interaction with
> KernelPageSize / MMUPageSize. Historically, these entries always
> correspond to the smallest size we could encounter, not any current
> usage of transparent huge pages or larger sizes used by the MMU.
>
> Ever since we added THP support many, many years ago, these entries
> would keep reporting the smallest (fallback) granularity in a VMA.
>
> For this reason, they default to PAGE_SIZE for all VMAs except for
> VMAs where we have the guarantee that the system and the MMU will
> always use larger page sizes. hugetlb, for example, exposes a custom
> vm_ops->pagesize callback to handle that. Similarly, dax/device
> exposes a custom vm_ops->pagesize callback and provides similar
> guarantees.
>
> Let's clarify the historical meaning of KernelPageSize / MMUPageSize,
> and point at "AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped"
> regarding PMD entries.
>
> While at it, document "FilePmdMapped", clarify what the "AnonHugePages"
> and "ShmemPmdMapped" entries really mean, and make it clear that there
> are no other entries for other THP/folio sizes or mappings.
>
> Also drop the duplicate "KernelPageSize" and "MMUPageSize" entries in
> the example.
>
> Link: https://lore.kernel.org/all/20260225232708.87833-1-ak@linux.intel.com/
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
> Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
> Cc: Nico Pache <npache@redhat.com>
> Cc: Ryan Roberts <ryan.roberts@arm.com
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Barry Song <baohua@kernel.org>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Cc: Shuah Khan <skhan@linuxfoundation.org>
> Cc: Usama Arif <usamaarif642@gmail.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reads great now, thanks very much! So:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>
> v1 -> v2:
> * Some rewording and clarifications
> * Drop duplicate entries in the example
>
> ---
>  Documentation/filesystems/proc.rst | 40 +++++++++++++++++++++---------
>  1 file changed, 28 insertions(+), 12 deletions(-)
>
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index b0c0d1b45b99..e2d22a424dcd 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -464,26 +464,37 @@ Memory Area, or VMA) there is a series of lines such as the following::
>      KSM:                   0 kB
>      LazyFree:              0 kB
>      AnonHugePages:         0 kB
> +    FilePmdMapped:         0 kB
>      ShmemPmdMapped:        0 kB
>      Shared_Hugetlb:        0 kB
>      Private_Hugetlb:       0 kB
>      Swap:                  0 kB
>      SwapPss:               0 kB
> -    KernelPageSize:        4 kB
> -    MMUPageSize:           4 kB
>      Locked:                0 kB
>      THPeligible:           0
>      VmFlags: rd ex mr mw me dw
>
>  The first of these lines shows the same information as is displayed for
>  the mapping in /proc/PID/maps.  Following lines show the size of the
> -mapping (size); the size of each page allocated when backing a VMA
> -(KernelPageSize), which is usually the same as the size in the page table
> -entries; the page size used by the MMU when backing a VMA (in most cases,
> -the same as KernelPageSize); the amount of the mapping that is currently
> -resident in RAM (RSS); the process's proportional share of this mapping
> -(PSS); and the number of clean and dirty shared and private pages in the
> -mapping.
> +mapping (size); the smallest possible page size allocated when backing a
> +VMA (KernelPageSize), which is the granularity in which VMA modifications
> +can be performed; the smallest possible page size that could be used by the
> +MMU (MMUPageSize) when backing a VMA; the amount of the mapping that is
> +currently resident in RAM (RSS); the process's proportional share of this
> +mapping (PSS); and the number of clean and dirty shared and private pages
> +in the mapping.
> +
> +"KernelPageSize" always corresponds to "MMUPageSize", except when a larger
> +kernel page size is emulated on a system with a smaller page size used by the
> +MMU, which is the case for some PPC64 setups with hugetlb.  Furthermore,
> +"KernelPageSize" and "MMUPageSize" always correspond to the smallest
> +possible granularity (fallback) that can be encountered in a VMA throughout
> +its lifetime.  These values are not affected by Transparent Huge Pages
> +being in effect, or any usage of larger MMU page sizes (either through
> +architectural huge-page mappings or other explicit/implicit coalescing of
> +virtual ranges performed by the MMU).  "AnonHugePages", "ShmemPmdMapped" and
> +"FilePmdMapped" provide insight into the usage of PMD-level architectural
> +huge-page mappings.
>
>  The "proportional set size" (PSS) of a process is the count of pages it has
>  in memory, where each page is divided by the number of processes sharing it.
> @@ -528,10 +539,15 @@ pressure if the memory is clean. Please note that the printed value might
>  be lower than the real value due to optimizations used in the current
>  implementation. If this is not desirable please file a bug report.
>
> -"AnonHugePages" shows the amount of memory backed by transparent hugepage.
> +"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" show the amount of
> +memory backed by Transparent Huge Pages that are currently mapped by
> +architectural huge-page mappings at the PMD level. "AnonHugePages"
> +corresponds to memory that does not belong to a file, "ShmemPmdMapped" to
> +shared memory (shmem/tmpfs) and "FilePmdMapped" to file-backed memory
> +(excluding shmem/tmpfs).
>
> -"ShmemPmdMapped" shows the amount of shared (shmem/tmpfs) memory backed by
> -huge pages.
> +There are no dedicated entries for Transparent Huge Pages (or similar concepts)
> +that are not mapped by architectural huge-page mappings at the PMD level.
>
>  "Shared_Hugetlb" and "Private_Hugetlb" show the amounts of memory backed by
>  hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
> --
> 2.43.0
>

