Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25F3FF30930
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 10:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B9856B0088; Thu,  5 Mar 2026 05:47:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 467256B0089; Thu,  5 Mar 2026 05:47:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 365DE6B008A; Thu,  5 Mar 2026 05:47:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2372D6B0088
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 05:47:04 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 919DE1408BF
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:47:03 +0000 (UTC)
X-FDA: 84511681926.08.C673413
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D766A40006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 10:47:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P8iMxX5n;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772707622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UCNvpJPuKhkfwFaWUTjT2a/SG+DVoLJuUCQYU1avfEY=;
	b=Jf/uR9WoNE4PIMYfQb4hP45Tutg2evjy8KbOVTT979GbkU/JvdJ3UZ9HTaGoCC1nQiGzEi
	SOw8PCcJIeG4or9Ou1K3XG7U9STksIc/kBoKjrhCdjqR7xmzcq8B71Yv4HYN4VNYV++USy
	7N7lvLzLGX9iyCxnmoCNRkmQuowLlI0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=P8iMxX5n;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772707622; a=rsa-sha256;
	cv=none;
	b=D8CeVQBqVF+bcPD+A1Exh3Id6YwEE/AUNKS6vXg7aurx0v1UBvowvi71hMtHU7nixlSELK
	pS2NQv0dxmNdrw62JSWFkqKzuRf7DnwOyYwGCkQ9dO1obEcFHkmgkuOZhKH+y/7j4ULFUi
	t0It7BRH1iirzW7g2M82KTwVfZY7Ois=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0A8240A73;
	Thu,  5 Mar 2026 10:47:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38A19C116C6;
	Thu,  5 Mar 2026 10:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772707620;
	bh=fKOrLuMwio1ZP0YPBsS9inqCOMrl5JjAkwjIp9f4jAI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=P8iMxX5nSzneOSi9DkWzhHtCk3Bken5y71jhO21gleP/c48oYbeayMLPMHsuL12JA
	 wF94j45h8dI+3TNWOoFhQspiV32f2HKTRjYN1NFX7eWGSjyJ66KA+WrrZstwjrHCP6
	 p3f0Wfu8IX7Sy1s+jLr4AGoI5oJfRQFN9DMLGyyRjW4AQoHnMhNBSFdh71iEdfsT7n
	 2lmqiBbKrnynCaD1Y6GsxPJq0EO8HTAwOnWoXOOMhBTJpPJJe/FBnCCocCfxn73LRI
	 nV2+QniAS3KN6RQEeKnoVoaRlR4X2EpYY6ZW+ogBDifX1F25fQ8U5dUgxnJKQ5kWVJ
	 m1etZQ4+03aBQ==
Date: Thu, 5 Mar 2026 10:46:57 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Usama Arif <usamaarif642@gmail.com>, 
	Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v1] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
Message-ID: <b24be8c2-32d3-4e3e-9fbf-8a0068c360d6@lucifer.local>
References: <20260304155636.77433-1-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304155636.77433-1-david@kernel.org>
X-Rspamd-Queue-Id: D766A40006
X-Stat-Signature: jsn5qjeh3ibuecomwg7j61tyzusoyi7n
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772707621-923819
X-HE-Meta: U2FsdGVkX18NJXeE3iNfNmLYXkf9VNk21/rlOoGrO6P9KC98KKxdFVeTQ+cCTdLfHoF189rlBHivYwK+WzKKfqmNWG8RVy9YLedF3CrB7sbBBLWSjk0b4w7vIW+xHpL4KCeIXZGAJQkBCWvoP9jICgDzGmzh1fiZiBbjOgfJga51GUsvsb+XeDHrl6558f1otzFfyFWYoQ+vuSXNxNmbfXiREWPmKDSXMhMWWYQ0SVPe/XGfNMqoKz2p+HYvnocujwEzQQAMu9bohcW6RUxzQc0mysK/kdAopNAcBsOpZ+cb4D3+hyh72B4MNxE3e7G3DySY3L9v0O9ZC5Kvxv57deiiaoCTPV2+WeuCRoS/nabuaRSPnj/XnfXyYOvno57KjGKEvtWEBYK74wTYoY8Hs7OOdCwoLTGB06PXuFy1yZ/4APOH/VGaVg7EXA32ONpCLOOUfqUL0eoxVn4KBkQZhJUzDE0Yx5MqROkm2ytf1eTxfEQCWLuQt/6xIkeivHqrISbngOek/yiiY4kXGF8VtXpdejSJKe41+RJ0eCSPs4Q9R3X6peMSmfNtTnyYfqhBTveS6+i8LNhkVVotYzogDRfj3x0orjgyF6E5UDXq5PZKPGjs2EM3J12eOiz+h6UKLZrB0mwB3quaUnzP2AO6VJ3CxxsxLMphaRGzM8nBdUmGfOTtX3rfgEKn4Py7KF81XPCyAzGo+tKoHUS5UrhOfchEhuwU2Bd0CfG8t8Z9tqGAptJ5tM+m/Wjc9Bc6z90OwvGSQP0+vTYueSgICGHEbk7x8yEXFsfzLzqbonV+X8s/29sfoe3O2jjV5cIoaVCyski2FADLbyzsvdkAdgs5RexjG2Jt1mFuqEmRzTVFSitwZh8Zx75hF7Y0Xro0mnsjnYft3edB5kzD+sE76d1iDZNLkpMNHKhIzq83RomMtie5o9yphEe+/qt7PKPqSb8zCiy8DLOaH9U/P2NFzSl
 7xuPrOog
 WC8iCM9Cvah8uZRhYdLMMQfoSIbaaRb9wEINgsnbNmZeTqnCmxGnelyqjyX50gFJVol01J69+yshYi7LKMquxYBDQJugDzBMbGb9K6zl373J7hjC5rWlyo860zsTFuK39x9vbULBLbdZCVh2sjwEBzizcWf+NZMuVbymfJBfwAgh6hKgyevlfrvp6atQwUO+YFCmQrLcN5V0Lwz58O8FLa/jERiA+QjW6e8NO5TLTHdENa/RGh8bS9YaI3007zUewRcSdf7NGnuBdFHw20KZM6e9Ne2HWYgofux9g65ymPdsDA+o3vTNvS4XOOUgg3dSMjqecqPXUvJ11b0SPdy9gDih/AuYAJSAw42yeDOk3ZTJG9kQg/ZRRSMtvxLKD81HjvGPUZrf08yihUCiQ/sk7PK8ijaIhXnnFz62VfN+mT+EpeKZT5XqBrXK++x6beha1u/XKISDpqrTBEn6pPGzY3BBRX6b4EEC0B1eBXK/eYZHRTTo2oE6844FGPIduwhG1a2DlPJZ02152dNuwSnK6tLEGn+1bbD8w1p6LBZPS/CytT5fVWhmo7nJ4t8G3kX7GZj4VRR3KxMxyWbg4sVrWPrABApoju7OhH/eurQsQ7u9MLP0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 04:56:36PM +0100, David Hildenbrand (Arm) wrote:
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
> Link: https://lore.kernel.org/all/20260225232708.87833-1-ak@linux.intel.com/
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

Overall this is great, some various nits and comments below so we can tweak it.

Cheers, Lorenzo

> ---
>  Documentation/filesystems/proc.rst | 37 ++++++++++++++++++++++--------
>  1 file changed, 27 insertions(+), 10 deletions(-)
>
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index b0c0d1b45b99..0f67e47528fc 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -464,6 +464,7 @@ Memory Area, or VMA) there is a series of lines such as the following::
>      KSM:                   0 kB
>      LazyFree:              0 kB
>      AnonHugePages:         0 kB
> +    FilePmdMapped:         0 kB
>      ShmemPmdMapped:        0 kB
>      Shared_Hugetlb:        0 kB
>      Private_Hugetlb:       0 kB
> @@ -477,13 +478,25 @@ Memory Area, or VMA) there is a series of lines such as the following::
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
> +mapping (size); the smallest possible page size allocated when
> +backing a VMA (KernelPageSize), which is the granularity in which VMA
> +modifications can be performed; the smallest possible page size that could
> +be used by the MMU (MMUPageSize) when backing a VMA; the amount of the

Is it worth retaining 'in most cases the same as KernelPageSize' here?

Ah wait you dedicate a whole paragraph after this to tha :)

> +mapping that is currently resident in RAM (RSS); the process's proportional
> +share of this mapping (PSS); and the number of clean and dirty shared and
> +private pages in the mapping.
> +
> +Historically, the "KernelPageSize" always corresponds to the "MMUPageSize",
> +except when a larger kernel page size is emulated on a system with a smaller

NIT: is -> was, as historically implies past tense.

But it's maybe better to say:

+Historically, the "KernelPageSize" has always corresponded to the "MMUPageSize",

And:

+except when a larger kernel page size is being emulated on a system with a smaller

> +page size used by the MMU, which was the case for PPC64 in the past.
> +Further, "KernelPageSize" and "MMUPageSize" always correspond to the

NIT: Further -> Furthermore

> +smallest possible granularity (fallback) that could be encountered in a

could be -> can be

Since we are really talking about the current situation, even if this, is
effect, a legacy thing.

> +VMA throughout its lifetime.  These values are not affected by any current
> +transparent grouping of pages by Linux (Transparent Huge Pages) or any

'transparent grouping of pages' reads a bit weirdly.

Maybe simplify to:

+These values are not affected by Transparent Huge Pages being in effect, or any...

> +current usage of larger MMU page sizes (either through architectural

NIT: current usage -> usage

> +huge-page mappings or other transparent groupings done by the MMU).

Again I think 'transparent groupings' is a bit unclear. Perhaps instead:

+huge-page mappings or other explicit or implicit coalescing of virtual ranges
+performed by the MMU).

?

> +"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" provide insight into
> +the usage of some architectural huge-page mappings.

Is 'some' necessary here? Seems to make it a bit vague.

>
>  The "proportional set size" (PSS) of a process is the count of pages it has
>  in memory, where each page is divided by the number of processes sharing it.
> @@ -528,10 +541,14 @@ pressure if the memory is clean. Please note that the printed value might
>  be lower than the real value due to optimizations used in the current
>  implementation. If this is not desirable please file a bug report.
>
> -"AnonHugePages" shows the amount of memory backed by transparent hugepage.
> +"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" show the amount of
> +memory backed by transparent hugepages that are currently mapped through
> +architectural huge-page mappings (PMD). "AnonHugePages" corresponds to memory

'mapped through architectural huge-page mappings (PMD)' reads a bit strangely to
me,

Perhaps 'mapped by transparent huge pages at a PMD page table level' instead?

> +that does not belong to a file, "ShmemPmdMapped" to shared memory (shmem/tmpfs)
> +and "FilePmdMapped" to file-backed memory (excluding shmem/tmpfs).
>
> -"ShmemPmdMapped" shows the amount of shared (shmem/tmpfs) memory backed by
> -huge pages.
> +There are no dedicated entries for transparent huge pages (or similar concepts)
> +that are not mapped through architectural huge-page mappings (PMD).

similarly, perhaps better as 'are not mapped by transparent huge pages at a PMD
page table level'?

>
>  "Shared_Hugetlb" and "Private_Hugetlb" show the amounts of memory backed by
>  hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
> --
> 2.43.0
>

