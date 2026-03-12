Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE86103E2F4
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 02:51:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7B046B0088; Wed, 11 Mar 2026 22:51:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B28BE6B0089; Wed, 11 Mar 2026 22:51:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A416B008A; Wed, 11 Mar 2026 22:51:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB396B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:51:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47788C25CC
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:51:47 +0000 (UTC)
X-FDA: 84535885854.29.D1DE73F
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4EB741C0002
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:51:45 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gpr0Bfkn;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773283905;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4dT/iAwBrfERuCP8iX2naiSjaj3fk/39yeqZSkIJKM=;
	b=u7MdyK3Ej18NmxjfaRgwLDBQXZ7ZFtbL/OFV0X+ayN+yBN1wtu7eulXvWKr874CiG6vBs9
	ESQuiMjegmzYjHgRLuvydRnoBQLX+NM6KedsjeiJqWFDNdtcbLuL3WpXujju+537VR53zG
	STdV3erBNLvjexMWkElJSetW96xUYCU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773283905; a=rsa-sha256;
	cv=none;
	b=xGxkh7G04OZk3p8j5EYMXvjdx4fa5gfuwImdtCDrDwI5JloL5PAVAQWTEY3sqXY+R/1clS
	oRKCrHdBZ6sbQhZJW/MBcqbpGLmfm6JFLoScJAKfSsy2X54WjXfS3mc9q+cncHbJQN+SPk
	2fXg6tXtkQ91Xsf+e9kF4RPPX1/4rVw=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gpr0Bfkn;
	spf=pass (imf20.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-485392de558so2597875e9.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:51:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773283904; x=1773888704; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m4dT/iAwBrfERuCP8iX2naiSjaj3fk/39yeqZSkIJKM=;
        b=gpr0BfknM8rTCQxBhTFfq9Oof1quUh5hfqbxeJbU44XxuR0BzgvfUFX7FDZZYQmKgN
         zvR7O9jG/xO98letQoIsXtka/NEGxeM8bdf4q1hf5OGmj4Ro2h2M3RzWjLkgVsC/pfmb
         8Z/aOdSpqYiFwjjRZ1RMAnyzvEcwUpsmROsHzBpwCBH4DtC+BNW7pxF1CG6rLo1CG+Zz
         SeU+fNbqkv5i3CVBSd8iNXCySqS+aPy9bZdck2oam4R9u/mLgwAOFYqMDCNlf7BBbWm0
         Sqm4d3dnvhCMtQ9vKzKFV8pKlJP1pgiC+bljEokZc+HJiK3tkcmODB9WzXE/bA2q8wIu
         3qgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773283904; x=1773888704;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m4dT/iAwBrfERuCP8iX2naiSjaj3fk/39yeqZSkIJKM=;
        b=aAVGEIDejejt9RFkdlnCHmuSmWh7lYwdG+wGZO94jp17aLOnqjNrDI/ry/RvBiQVoW
         PnrUQVL0tCrBfYZaP1Y4W4gffM4yychwdvt0wu7IAY3WLbP/imawJgQKySWiMKNumYNQ
         OL2h2HLi0MqrxhwLqwx4fzAMGHRNzsydcYGdP8vuifR7zIIM1MkzybkhOA3ZugiPbXmU
         FgvcSHOtFgylb3EOa7KQvjAu8YojhGTz+PdT3nF7Yaltc0Tk5PNrJWi6s5Jb7BoRmdR0
         9iYksYgnZCJ7D0cU3w8KY9zkxnXOUklaUoJyDLsM6+OSuAHNfkmWRYzcgyKTE9IKnHDt
         feqA==
X-Forwarded-Encrypted: i=1; AJvYcCUAfhzQcWI6hA2uhTT6G9lpJh2Ai+MN4HcJDzM5xwTddwMWGXUIbP9PyrqR5+Q61FmA1B+Txh589Q==@kvack.org
X-Gm-Message-State: AOJu0Yw6jGE+Ud7l+PZxPZ1VTbz+z4p0AtO9lMxDPpvPoSeCDeqFUtZf
	sCVmtG0iFFphxWkRS/Grp849CWsgiZ0xe0HrMAEVhWh2+qeEbGnMdctz
X-Gm-Gg: ATEYQzyeFkj4M1ZnsAGhOd798mcrZCxE6movypC4auyvJisRoz1s11iDuUgy+qUhspQ
	jVn/VLmJFsedU2HqSxdbLF1KZLsO4hXbrXLr/hRUeAOA9pEvlKP53Tj5SSFNONQJyzKDTflAFq0
	yz8PfeCrLgH88a1b2vTEShTXDlT8tM9y/wN2LkJKn11fI8XtrUxomad1IuWkeTLSrYdgCGvm2sq
	GHLGmU1Sz2/uS78IVmOvgeOF2jvZUQfWQHs1Xg/KiiUYohXWvehKqGQznW2yEcMf53UhncZ+eFx
	+NXO691cPR7ruQT8NOBt7ttnteYJWsTaZ6qfS7PNdQ0T0evPLokWqSDqrBP6PJGcmTCLK94BCpo
	7fXnaZG4+WDOCt+27SevXpHHw+f1HBgLBddNIi9Biw8LKgyK0XZVCObYNsb1LdR9VA+MvFdR5zw
	eLnzZ/P27abOqYTWWAquegHQ==
X-Received: by 2002:a05:600c:37c6:b0:485:3fc6:c0f3 with SMTP id 5b1f17b1804b1-4854ad723c2mr79625495e9.0.1773283903640;
        Wed, 11 Mar 2026 19:51:43 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4854b0c3878sm32997245e9.16.2026.03.11.19.51.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 11 Mar 2026 19:51:43 -0700 (PDT)
Date: Thu, 12 Mar 2026 02:51:42 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH v2] docs: filesystems: clarify KernelPageSize vs.
 MMUPageSize in smaps
Message-ID: <20260312025142.wued4ueww4bgcoeg@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260306081916.38872-1-david@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260306081916.38872-1-david@kernel.org>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4EB741C0002
X-Stat-Signature: 9cd59ekmn3ek3kjz3rpriya83ufw9kzd
X-Rspam-User: 
X-HE-Tag: 1773283905-642817
X-HE-Meta: U2FsdGVkX19MgiHvdHxSEo4SO5b5dX7rpBcuV4JijR5Ygei/q3ACLMSpJF+txJ2LPF8lkb3sGrBmDRQL0gAS4VK4CRme9yIboaIDaNC9XMD0/+h0RQAmVATTe8IAHzQZZ5SUeLByaacfjrhRHXqjtyTGfXpEmToliD7Y5vjlDHJLD6PDwDh0wKuTcujSiX4lO+CpswYKGaB/sb+M+e2YvMCME5VMZm7QkQI2eVh+JgDkFA37QIa4YD2rW5K3Xs2UrGfd1IwfSpX851k0m76pHfetAI3Kn+2dM6VbiDJ9xYJL8a04PC7UkYWn5pT9SBfVnK1VfTsEcOAix19LJ5fJWb8/dFolGScE1+tRvoQStWmuGl90g9NzXz2qGcDGJYGs98MOCLYxsCrUnsE1VVVyhy9PJvmyZLSPkAfUszkm2ST+/peL/Vo4CaEUS9AjP8XcRfFk8xu076kq3JTrcUYsGKTfo30Ldl7TjgwB47OusegFlXZktVSKBe9fJgHEE1UFqTfrWc6rtctRwFb/DC+QoiyLgW2QPvpxYdWs94/yh/2AjrhdRejqANfcENrE6MsietJaig95jszzxlnPptVAKT5HzaoLW37SpAzZwbo2aysJP3XbZZ02J5PQDLb10/17G8y7PhQ4c7WbkeFI/dB1CoDsZIM8oZO2TZgjXeN1EwSW6yaLXkrSBWBxONYeoaTMhsYKA+UrA5kbm0rfH2SHLnzv/n+IZKOz5ElNBNija8e+RuBEmXoAmQeiFr7ia0d7ZZcr/5ljXHvca7kB8RbR26Z+ckYgdOGTO3gszFrR4uXxriQT2yggPUGqkS4PPcGDZLbpoNiHLHKShWyR7LOVBd0VHCzeJf/J++7oT8eQPXSkO7QyrfP5LRY4kKq8OmXkbUMGWMNkOVavz+bNDrxUg2jtL0gK4YZqPwgFkjTe32CdPafXsKM3QS3P/hm1YKrJWgYn8gGNB/CmjH0Es1J
 dU2GNV0c
 sO+ieLNjck7Ipvru2ivhc5YATtpsQiB7fhO2ZGWof3hkykJa/wB2dlx1nvYPfzyJpf4+eLJdfSYJUd6UuKtXCltkrQpjHMG6n0vKmR9bHGNVKvywCGWospZIMZr86QqtWOXR+O2SEsIfHivckHmKqrhcsH99lEDARiPmO2NyyN0GkGCXFq1xoB/nRmKuS+4RG1HaEfFrB60/AaHWPA1C0QBsc+vuoluPrGC7DV4ZVIQ8kxADtSm5WkBArMdegfPKwxG8NxD+YWKCSyHc0jwecI6Ybr0/9jfc8L41Is2tALOvwCuEVAN9ldvgKE2hRzKs33bKJjzzF1hjL3VNfyKufDOI61XYGb8FigmjemC5PmzamFxOXtTWPTUvPDEDR2ZhuOUb8vsn0kC8z88rkWKWXAJQKA3ZydKUVT8GN+4dAbQcsyRC/ym2nS9eH4dQYT3no5ML8j4koJsCjg4XjLuTHI65Cwijxx/b11Lf+IIHJoypn2gfSEoumciBfWrTI37XLkiWjdolHnkrVYOXZmtxHXTdr2cMDBa9Tsh2h/ckRkRmCXdMSerX/X4Jc8HWZsogfjncVzGYVVpn8x4d4zZzOMdWx8/pMan1nE23ulwj6nVbkioxTElfHGwomDL7DaL4mnBIvE7+pfMYXb0ENtU6eG0F4A82Fl0dg8RyKJ02evoN4wSnn8EZSQr5u0Hw7uacwQP4rQ8aHYGAxQYI+VAgKxdoUWBLsbMqhCsFLBKiSuB1bTntjB5z2fFmPORdrvx+MIgb+yd0g1xi6SMUCC7z8RcW4D6EegfQC4c5BOaSkau27wo9ePwNb+wn5uY1Ym0QzAcVp3gtSY+qDChVpla8lzGCI7YOUWG0tVKhbZo4R8B8IUxXpWRxd+o7ow1nshxNguFyEvdOuwpVJUaLuivuDSrZplqnLdP6yK3vFM6hcDr1Y9PCP7x0ZAkLaKZ55bazilBTyMzg8vMkMj9qggwinLxMOEXJt
 1FmWJs2E
 ycFE5c3rZm9K6BoQ0I4st5/t/wSD5Vu+85d+wk+cVYdCHCH/N2uHxeAVEAKRcdZJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 09:19:16AM +0100, David Hildenbrand (Arm) wrote:
>There was recently some confusion around THPs and the interaction with
>KernelPageSize / MMUPageSize. Historically, these entries always
>correspond to the smallest size we could encounter, not any current
>usage of transparent huge pages or larger sizes used by the MMU.
>
>Ever since we added THP support many, many years ago, these entries
>would keep reporting the smallest (fallback) granularity in a VMA.
>
>For this reason, they default to PAGE_SIZE for all VMAs except for
>VMAs where we have the guarantee that the system and the MMU will
>always use larger page sizes. hugetlb, for example, exposes a custom
>vm_ops->pagesize callback to handle that. Similarly, dax/device
>exposes a custom vm_ops->pagesize callback and provides similar
>guarantees.
>
>Let's clarify the historical meaning of KernelPageSize / MMUPageSize,
>and point at "AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped"
>regarding PMD entries.
>
>While at it, document "FilePmdMapped", clarify what the "AnonHugePages"
>and "ShmemPmdMapped" entries really mean, and make it clear that there
>are no other entries for other THP/folio sizes or mappings.
>
>Also drop the duplicate "KernelPageSize" and "MMUPageSize" entries in
>the example.
>
>Link: https://lore.kernel.org/all/20260225232708.87833-1-ak@linux.intel.com/
>Reviewed-by: Zi Yan <ziy@nvidia.com>
>Reviewed-by: Lance Yang <lance.yang@linux.dev>
>Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>Cc: Zi Yan <ziy@nvidia.com>
>Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
>Cc: Nico Pache <npache@redhat.com>
>Cc: Ryan Roberts <ryan.roberts@arm.com
>Cc: Dev Jain <dev.jain@arm.com>
>Cc: Barry Song <baohua@kernel.org>
>Cc: Lance Yang <lance.yang@linux.dev>
>Cc: Jonathan Corbet <corbet@lwn.net>
>Cc: Shuah Khan <skhan@linuxfoundation.org>
>Cc: Usama Arif <usamaarif642@gmail.com>
>Cc: Andi Kleen <ak@linux.intel.com>
>Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
>---
>
>v1 -> v2:
>* Some rewording and clarifications
>* Drop duplicate entries in the example
>
>---
> Documentation/filesystems/proc.rst | 40 +++++++++++++++++++++---------
> 1 file changed, 28 insertions(+), 12 deletions(-)
>
>diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
>index b0c0d1b45b99..e2d22a424dcd 100644
>--- a/Documentation/filesystems/proc.rst
>+++ b/Documentation/filesystems/proc.rst
>@@ -464,26 +464,37 @@ Memory Area, or VMA) there is a series of lines such as the following::
>     KSM:                   0 kB
>     LazyFree:              0 kB
>     AnonHugePages:         0 kB
>+    FilePmdMapped:         0 kB
>     ShmemPmdMapped:        0 kB
>     Shared_Hugetlb:        0 kB
>     Private_Hugetlb:       0 kB
>     Swap:                  0 kB
>     SwapPss:               0 kB
>-    KernelPageSize:        4 kB
>-    MMUPageSize:           4 kB
>     Locked:                0 kB
>     THPeligible:           0
>     VmFlags: rd ex mr mw me dw
> 
> The first of these lines shows the same information as is displayed for
> the mapping in /proc/PID/maps.  Following lines show the size of the
>-mapping (size); the size of each page allocated when backing a VMA
>-(KernelPageSize), which is usually the same as the size in the page table
>-entries; the page size used by the MMU when backing a VMA (in most cases,
>-the same as KernelPageSize); the amount of the mapping that is currently
>-resident in RAM (RSS); the process's proportional share of this mapping
>-(PSS); and the number of clean and dirty shared and private pages in the
>-mapping.
>+mapping (size); the smallest possible page size allocated when backing a
>+VMA (KernelPageSize), which is the granularity in which VMA modifications
>+can be performed; the smallest possible page size that could be used by the
>+MMU (MMUPageSize) when backing a VMA; the amount of the mapping that is
>+currently resident in RAM (RSS); the process's proportional share of this
>+mapping (PSS); and the number of clean and dirty shared and private pages
>+in the mapping.
>+
>+"KernelPageSize" always corresponds to "MMUPageSize", except when a larger
>+kernel page size is emulated on a system with a smaller page size used by the
>+MMU, which is the case for some PPC64 setups with hugetlb.  Furthermore,
>+"KernelPageSize" and "MMUPageSize" always correspond to the smallest
>+possible granularity (fallback) that can be encountered in a VMA throughout
>+its lifetime.  These values are not affected by Transparent Huge Pages
>+being in effect, or any usage of larger MMU page sizes (either through
>+architectural huge-page mappings or other explicit/implicit coalescing of
>+virtual ranges performed by the MMU).  "AnonHugePages", "ShmemPmdMapped" and
>+"FilePmdMapped" provide insight into the usage of PMD-level architectural
>+huge-page mappings.
> 
> The "proportional set size" (PSS) of a process is the count of pages it has
> in memory, where each page is divided by the number of processes sharing it.
>@@ -528,10 +539,15 @@ pressure if the memory is clean. Please note that the printed value might
> be lower than the real value due to optimizations used in the current
> implementation. If this is not desirable please file a bug report.
> 
>-"AnonHugePages" shows the amount of memory backed by transparent hugepage.

This confused me sometimes. And finally I found it just shows PMD-mapped THP.

The name is misleading. But it seems not easy to rename it, since there are
user space application use this, like selftests.

>+"AnonHugePages", "ShmemPmdMapped" and "FilePmdMapped" show the amount of
>+memory backed by Transparent Huge Pages that are currently mapped by
>+architectural huge-page mappings at the PMD level. "AnonHugePages"
>+corresponds to memory that does not belong to a file, "ShmemPmdMapped" to
>+shared memory (shmem/tmpfs) and "FilePmdMapped" to file-backed memory
>+(excluding shmem/tmpfs).
> 
>-"ShmemPmdMapped" shows the amount of shared (shmem/tmpfs) memory backed by
>-huge pages.
>+There are no dedicated entries for Transparent Huge Pages (or similar concepts)
>+that are not mapped by architectural huge-page mappings at the PMD level.
> 
> "Shared_Hugetlb" and "Private_Hugetlb" show the amounts of memory backed by
> hugetlbfs page which is *not* counted in "RSS" or "PSS" field for historical
>-- 
>2.43.0
>

-- 
Wei Yang
Help you, Help me

