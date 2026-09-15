Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9F47C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 13:01:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C88616B00AC; Tue, 15 Sep 2026 09:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3D2B6B00AD; Tue, 15 Sep 2026 09:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B27DC6B00AE; Tue, 15 Sep 2026 09:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DE116B00AC
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 09:01:25 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1081D1A03E2
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:01:25 +0000 (UTC)
X-FDA: 85216007730.20.1599C8C
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0468940014
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 13:01:22 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b+Inf1LB;
	spf=pass (imf17.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789477283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+F7E7Bq/M1FITHwdNffpUS733lAk0A+k2uxZSk0JCQc=;
	b=DhQF1AUh7QupuP/ApiCrfu/EMvKA+GtIpF5swWnBpzGbv26Eev6StkRMJpWYQaHXnTk24s
	yHmJl6aU4//lNHPOdCmDETxhfEkj3Q0/IL1VEVBMMf93RrR9D6JEizyNSNimlyii/AQXx9
	kcCHB1hvsVYBqFh+g/TiIhxC1vk0NI4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789477283;
	b=YzdrmQVNtbOmDjBgiOhidOBQcP4KU2/b8e/7fj8t7yYfHDJ4BM5AeChd/5t86kOsLU7gsm
	PsbwVw6Y7BhXxpJKqISDUP1FPDnYWCN+/1JAtPo9jBszMmm3Ql8S0f8K1ySIuY+5POFqzE
	1dddOxvpgvhOvFFJ3lPM78fh7DNhq80=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=b+Inf1LB;
	spf=pass (imf17.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f8.google.com with SMTP id d9443c01a7336-2d8fcda61c8so20306265ad.1
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789477282; x=1790082082; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+F7E7Bq/M1FITHwdNffpUS733lAk0A+k2uxZSk0JCQc=;
        b=b+Inf1LBb3LCPJAKzF7noyYLB17i8+9H38h5QJo4WDPuceZSmiHCD/XRCNvZZIeo6I
         gciI1oo4W6AEaAP4jRcwCiDnK31BjiznSc0MgI/OwtNsD2yEDWSkeyurDIw05DNguRqq
         QC40zU/RxK93jY0cRCBAbHXWE7gyf9pxDXwLdUksIca3odgpDDIYmeka3oLZUFi1ammj
         ot6WD0Ro0o2xOfKUcTP0yOufEUkUFrie75vPc7DqlDVELH/bVH7J5vF/gon0HJRkxEZg
         WdUWKSxv54C8elwmzwzs6v1OOpFV/bZ9wr8WVKHGHZk9rr96ohLCiiqSoWBZ+TRHKKyv
         ttFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789477282; x=1790082082;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+F7E7Bq/M1FITHwdNffpUS733lAk0A+k2uxZSk0JCQc=;
        b=Y0j91SeGlGWkhL36D3tY5xPaLpwDSIJZ3RuykPjpUrcpeh2GKbaDnZ0G/Q+Ledv30/
         /ut0Xe9Ln+RRHq8OyBkRjdKAciKceU5ylNSLp37qfSTm2Irliqxeti4+uU8YHkeZ/3JC
         XvbGz1fhAq+u9SKAxUJu8hvtrWsdeI3MWbblNu8R5kHaC7x+QMI6Gq/QHifSq/qqL6iT
         jSR6ojMc2gCxu0UHkUYf8XSpWkw/g/2HeoEFaS8UTjcqG3lbt/NceSkTyz40O8/O0OKS
         lwJ31m2H2AzbkYmDU6xT2jvpGIYhKZQ/gL3eME2wiE0LygWBy1SulK1GhNoKLezXbsqw
         K0uw==
X-Forwarded-Encrypted: i=1; AKwUvBwVeuYuQjZz4e0sITa3EtkXQQIs4/dAogVWOacYH9R1+dv72v0FkTQCJNyzb5DCF9TIK8ExA8MxQQ==@kvack.org
X-Gm-Message-State: AFuF++l1BYg1dPdz44tljHKa1okRBdkfXw20ytpndh0p1rOxJHvDqAWu
	M37NKFZWryEwv6J10zHsZjY5HalL8dVy+9w8h5PGZeskgcZKJdE0z9JC
X-Gm-Gg: AYBFou3XOvlzsU/MaEAp5bxmlT3iNzqxmNMsHfl7boSGQCnOIQm1WRmS1Tt9ds8c09P
	KdCrG0Wg4J/5uCI9wm8NEGaTy1mDKY9gJyhG3T61v0sx5O6OBJn5yYcsNGWXshtcRjWghXitZd6
	+CcmYfoHZEWtA1IL65WFbFlOdS0Y9mnjdca9z+ctm2t5tt4PFGjwADXvbnudNEL32zDS8QrhxwA
	ZwC4Q2iNL7EmpOioY1iPNoptzQdmf9TH/uFyLsbFCVz2gfR17Q3uj8gFJ+FEieOQw88TQRBnbn/
	2pBZSYMNbS7cfLzS94L9c8XzZh0V2eFvM41sQzgs+k0LQgtnkdL0SHcsnQrHAGs3hsc04EiY5m6
	aWSZ+b5nJpzUQJoFVBmnkQPKFuJ6GfSReDQ77jhaY70hAEvTUmHt6TGvhyFceGvM2dKdoVfF9lu
	koU6svQOA55odPviTPtf4IiKhpKGnF6Hv6Iq7zZ+8mu2q9BDzAiWzYjwq5gWtIwQlKTNAD5odId
	GkD+Q==
X-Received: by 2002:a17:903:3d0d:b0:2d6:3c2f:6a4 with SMTP id d9443c01a7336-2dd6c6eb7a4mr138425825ad.13.1789477281468;
        Tue, 15 Sep 2026 06:01:21 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd2cfd87e5sm67187695ad.58.2026.09.15.06.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 06:01:20 -0700 (PDT)
Message-ID: <13cfcd99-e420-478b-8ce8-06674727977d@gmail.com>
Date: Tue, 15 Sep 2026 21:01:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] kdump: reduce vmcore size and capture time
From: Wandun <chenwandun1@gmail.com>
To: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 robh@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org,
 baoquan.he@linux.dev, rppt@kernel.org, pasha.tatashin@soleen.com,
 pratyush@kernel.org, m.szyprowski@samsung.com
Cc: mark.rutland@arm.com, kernel@xen0n.name, alex@ghiti.fr, hpa@zytor.com,
 ruirui.yang@linux.dev, robin.murphy@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org,
 iommu@lists.linux.dev
References: <20260902073116.802752-1-chenwandun1@gmail.com>
Content-Language: en-US
In-Reply-To: <20260902073116.802752-1-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0468940014
X-Stat-Signature: jxjjggiq3cdeqcsr81b3ka1dr1qp5oyj
X-Rspam-User: 
X-HE-Tag: 1789477282-776169
X-HE-Meta: U2FsdGVkX1+g9tTD2e34uBsH0XBh85Qo+5IGEZw9Z+L3WIT+p0c1BDzsdexq2vGKHrb2kNA1nAUwpG17mOQXULKkLXQ2Y8nqSzutEabJX9Iz4ZbsGRRJD8R6imQg992k9OcfdQfyMsivrgSHu3VArT4VCjB0VVPpJ6UeRoJc3892ozDnjk9giCM0sozQv1kaJN16CE9vX0Us9cTJt48DnKtGrRKARrHa2jI6vpsty1XFmWTTGG2fIsJnvPKBvjmqFufVquVo7d23hnO+FAUXq599Mmdx0scEIjgPOYHlGsGrkvkzQmZrfhJ9apXOxLWPkfVbe3c1b0l+LWbTAy//sMh2gWwQUEMuZKuGPAZCGG0wFy7htcSQRfBkaXTOpc2STL+9ioNN3sNVaRihzuy3sMf2REAyUXLG7NBWX5m610DXT4/J7r6UnxrtOhuf5/5MhdH8TbqJLq7kFJev1gJN8Gh1+A35zAEsDvpPio7+gvve88REDCIuP3YdS6FG+iikgnyljYNYmnczyEPJp20thkbawkrkZekeefdN36KFQmAp04LDclJFzM7cOjctwUpx0VbBwPJS6l1Xq+eiFjbft2/9cqJmPv8M50gJUWL+fFMKK+iDTgonNY6yQlYW4n2j2YFokO2kRbKoIn5pugWZUfDWPG7kjv4TkppxckAQ7VcDsx0y/OWG8mii/5JXLU1iQjTnIqWhKyLmidHoZZwp6dKAXksBqEvUv+Iis3LsCuUX3EKdckTsSS9QxmNCXiw8pOdbpQzxdzFqNm7/WKcxpAc7HGrRVSg5p31FqsbGzqAFJ1M3D1g9qgdOyISpArCldrsCDfypplgWpxVLEEJiux2jDEgdey/kCB+0hUnHdeXAWbcUwWfQCELejeyEvTBppPsZ02+wr7bm9FNNKyzl/623tMbCAaU1wFYcmVpm9GO0JgOgC5TP8Zt9kyQnNS4KSmI3h1Z4nMAS62eJOZp
 FjjyUbej
 xTfjZpELy3xTkQQWERMeCcC52t/HOfUZ+U7WlkXY5jY6aA+ya64bF10USmulSFIs4UueWpPfvR+6T4dxDCclyqoD3p3U2KJh3PbAIGpMBxmsOHp4TgM10ieJ6LzrXhqb+nq5c1blRyPJa0kWb1gMV0ZUqHYOm+hXPlbT4FrbyKfsn5vrXqyZ+vmG24xjwACi0diHNNUHp5elTDs2EWLfeoiGd3fJSD8MZBAcA4J79wwrMHqPdDclSdqBvCk5gKBIesoF19xyj+sFc2RM6LoEtwbuU7lflXPTWGYxaSdAedvEhTd2XTMuDRp/wVjsceWFhGbI1mIympEXVd/izqFTX0KB+DHmsKDrkJSE3o3tRPQDKwsFzSJtQggw5ZMdfDdqAoKT+IJsWpKdxNLFZi8bvNiZO54sHok1zkvr6KKRnZu93dFK8UNenyaidszlaYMihSkbSAVfepjJa24vVolKE7NbGDYnBxSS7PO66yAX0XIcnr+cKrLrhiF4hdVvK3jJKIUXBf93jPXHMI1f7YwIi3aemI240FogJgk1BVaZ45PSkDCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 15:31, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> On SoCs that carve out large firmware-owned reserved memory (GPU,
> camera ISP, ...), kdump currently dumps those carveouts as part of
> system RAM even though their contents are firmware state that is not
> useful for kernel crash analysis.
> 
> This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
> reserved memory on DT-based architectures (arm64, riscv, loongarch).
> Reserved regions default are marked MEMBLOCK_NODUMP so kdump omits them;
> reusable CMA regions are different because their pages are handed back
> to the buddy allocator and may carry crash-relevant data.
> 
> ACPI systems already filter reserved memory out of the vmcore through
> their existing path; only DT-based systems currently fail to filter these
> regions, which is what this series addresses. The flag lives in memblock
> itself rather than in a DT-only structure, so the mechanism is generic and
> both ACPI and DT systems can benefit from it (suggested by Rob, thanks) [1].
> 
> Since the reserved memory regions are filtered out, the vmcore is
> smaller in size and faster to produce. 
> 
> The series is based on linux-next and is organized as follows:
> 
> Patches 1-4: Preparation and bugfixes: fix the missing HugeTLB
>              flagname, switch riscv crash_mem to memblock, fold the
>              duplicated per-arch memblock walks into the weak
>              defaults, and serialize crash header preparation against
>              memory hotplug.
> Patches 5-9: NODUMP infrastructure: switch crash_core to
>              for_each_mem_region(), introduce the MEMBLOCK_NODUMP
>              flag, add a dumpable flag to struct reserved_mem, and
>              mark /reserved-memory and /memreserve/ entries with
> 	     MEMBLOCK_NODUMP flag.
> Patch 10:    Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
>              header.

Hi,

Gentle ping on the remaining patches of this series.
Patches 1, 7, 8 and 9 have been reviewed (thanks Mike and Marek);
Still looking for review on patches 2-6 and 10.

Would appreciate a look when you have a moment, happy to rework
anything based on feedback.

Best regards,
Wanun

> 
> In v5, Sashiko found some pre-existing issues related to reserved-memory,
> and has no dependency on this series, so these issues have been addressed
> in a separate series [2].
> 
> v5 --> v6:
> 1. Serialize crash header preparation against memory hotplug to avoid
>    out-of-bounds or use-after-free issues.
> 
> 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
>    avoiding a panic from too few regions before resize is permitted.
> 
> 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
> 
> 
> v4 --> v5:
> 1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
>    (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
>    DT-only struct reserved_mem.
> 2. Switch the riscv vmcore elf header preparation to use memblock
>    instead of the resource tree, aligning it with arm64 and loongarch,
>    so riscv also can exclude reserved memory from vmcore.
> 3. Deduplicate the vmcore elf header preparation: arm64, riscv and
>    loongarch open-coded the same logic, so fold it into shared
>     __weak defaults in crash_core.
> 4.  Drop the v4 patch that saved /memreserve/ entries into the
>     reserved_mem array; /memreserve/ is now marked MEMBLOCK_NODUMP
>     directly.
> 
> v3 --> v4:
> 1. Rebase this series on v7.2-rc1.
> 2. Add two cleanup patches (patch 02/03).
> 3. Simplify patch 03 to avoid checking whether initial_boot_params is
>    NULL multiple times, suggested by Rob.
> 
> v2 --> v3:
> 1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.
> 2. Fix UAF issue when alloc_reserved_mem_array() fails.
> 3. Add some prepare patches.
> 
> v1 --> v2:
> 1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
>    feedback [3], v2 drop that property and exclude reserve memory
>    by default.
> 2. Split some prepared patches from the original patches.
> 3. Address coding-style comments on patch 5 from Rob.
> 
> [1] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
> [2] https://lore.kernel.org/lkml/20260818092420.2859026-1-chenwandun1@gmail.com/
> [3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
> 
> Meijing Zhao (1):
>   mm: memblock: add missing HugeTLB flag name
> 
> Wandun Chen (9):
>   riscv: build crash_mem ranges from memblock instead of resource tree
>   crash_core: fold duplicated memblock arch hooks into the weak default
>   crash_core: serialize crash header preparation against hotplug
>   crash_core: replace for_each_mem_range() with for_each_mem_region()
>   memblock: introduce MEMBLOCK_NODUMP flag
>   of: reserved_mem: add dumpable flag to opt-in vmcore
>   of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
>   of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
>   crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
>     header
> 
>  arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
>  arch/loongarch/kernel/machine_kexec_file.c | 27 ------------
>  arch/riscv/Kconfig                         |  2 +-
>  arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
>  arch/x86/kernel/crash.c                    |  2 +-
>  drivers/of/fdt.c                           |  2 +
>  drivers/of/of_private.h                    |  2 +
>  drivers/of/of_reserved_mem.c               | 48 ++++++++++++++++++++
>  include/linux/crash_core.h                 |  2 +
>  include/linux/memblock.h                   |  9 ++++
>  include/linux/of_reserved_mem.h            |  1 +
>  kernel/crash_core.c                        | 51 ++++++++++++++++++++--
>  kernel/dma/contiguous.c                    |  1 +
>  mm/memblock.c                              | 17 ++++++++
>  14 files changed, 131 insertions(+), 95 deletions(-)
> 


