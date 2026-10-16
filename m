Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47E5DCC6B2D
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 03:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 376166B0088; Thu, 15 Oct 2026 23:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300346B0095; Thu, 15 Oct 2026 23:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C92D6B0096; Thu, 15 Oct 2026 23:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CF3E86B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 23:21:10 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 472BC120290
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:21:08 +0000 (UTC)
X-FDA: 85327038216.03.9D32529
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6617CA0007
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:21:06 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E5JZb6Cu;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792120866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BLv1jdYPShZUl6WRXA2OAAq/MQ9I53lb2Im743pbZNE=;
	b=ywBma8dtYsqOm3QuaQLyTMdxqRvdgygDLzkTeHeMLq/odsFdKvd0u7OZDdl66ixKBBOV01
	3SgnfIqJy4PgX6OPpDaEw2yzO97wtd5yoBH75VfmYIITbBS0iO42JmEMICmWaZw4TbwK1s
	JSdIOwEVIW0zHpZw/tWrLL5BAj+t61U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E5JZb6Cu;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792120866;
	b=c0H02SGNP6y1avvNfle4gozuNjFJSS//tbDAQdGZpqk3Fh2CD2N7q0dMBvb7HvMq38ooXb
	MDySzCTPCLzEl8WhsIGYGJSJX0g0ttpU09GsREGKSOlwPDt2zwKi9k+5Z7NgxcJjffEbIw
	pypEX9iN9Vhu80/kGuv6yWo+C75X/60=
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-3abe4fb64d2so2660316a91.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 20:21:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792120865; x=1792725665; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BLv1jdYPShZUl6WRXA2OAAq/MQ9I53lb2Im743pbZNE=;
        b=E5JZb6CuQaNy1QTkd82OAiULjPXKSYNsRg9US/Wwav0dEM212X6EIjEqLJESoKUia4
         IaUHvcc/SMm2vfBc37vRxd/nOm1KSncIlAIeF1Sq1oYob0gIWyTmAhhZT0I5CIXWzmR5
         IUsi4RJFnvB4rWcTeH9+nRiClt0oL7ozDe6He4vNqJHpkFxGgUNeP9chwtV32FhfveBP
         HiFq0/uSw74W9dXaayNPT+YFY2iE8vGqD/7Y9al8sNdp/CtxybXuoj1ZKx7vy6vnW2ZL
         HHaw1VXITSvAPqObxzcfZsXjSlhD3c5eg5RLqyIX2jXvk0lMINUTBEmO6lKZL4mKly+1
         n9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792120865; x=1792725665;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BLv1jdYPShZUl6WRXA2OAAq/MQ9I53lb2Im743pbZNE=;
        b=RSlB3PuKWaVSub3Ov2lm9sJZ+87DReU8dC71jPFGZYh0hS5BSobfb/W4tatkzQ6GPL
         e3o/YvLQvrp3HqOnszcpjI3F5KGPcBKfDlVTiO+CZE5S6LG0gkw3XhQV98EX6vd/GNg2
         X1hvnGO2b2eRjN2eLH74LWrs0PgyeD2U/xAblKyVBsRC35OaZ/mb5RdKIK3ENs8LF8lK
         I4GEiIIcw3bpJHuwFtdH7XbrkuQ9ygi5riIQMUpQHHQBT5syRrvPFJbNuuej4f7vLc+Q
         xlxcKYE8RxParne6d6EDFks0GDoBh4qysgiFSNj1vRBE21LHzvTy9v9CUbfRs7M4kMej
         JHbA==
X-Forwarded-Encrypted: i=1; AKwUvBxEXl1HduVXSuaNco3fs6gUOLRR3qA7UADKPQpeXnJzylQBRZS5O6LvfQutlZqdO9tDZE6j2HtpXA==@kvack.org
X-Gm-Message-State: AFq9FYJswxI6aLm3XA2GYNXhzEeTZuT7f3YgNDfdFr70+C9eb8OIZJ96
	i5G0bj/+RMzcU1ozCM6DfxvwUsKrlNC9yTxG0EhCf6QUbKPtO+QOfbT8fMsQ2pSv
X-Gm-Gg: AYBFou3fCZFsFyGisw1Y04+JLEDHuoJS5UfqWU4VPMgra3F1MxdnDnM8FbwgNtFJcZG
	fpO9/iaqV3OBBO24hPU3mUzC/azSvRxpZ8it5QN5SoOi0n1qRdS5MpOzCwP5IayBloVcRYpyg7/
	YcfZy/NZEPzrtz63rtx72Ja/TDaQHZJ+sq4fYGWOMToEHlhS9n+o/+ZtXEuE1lYF+/PAAxR6sO1
	8tGwIZaMkC8OmGqB7rudAZk4U7+YwFnGNmEVCOrxCjstMvJpcFLXNtvQkipfWesF34XlJtgO7yw
	7K0zjmminEpuHJaoorYq7wnevHWkbZ7VIyvqlLPy+b545xz2/RqJCZtgTh+mjr7rch6WN3KRWxY
	Ypx7bR6FlKv2SlXjBL9Gx/8pXD1U3zKquuTAFLNFMP2HwQqxhz9lE0fd2Hd7QHUAOXGkivQ1C2M
	FmBZtVTcHtZLYizo4jDw0sPOtDChk45LjmAj9gecf7/e3TfO1EBvdjkbfQTeftQtYiMq4l+wQhw
	R+42A==
X-Received: by 2002:a17:90b:1801:b0:3ac:a11a:7c79 with SMTP id 98e67ed59e1d1-3aca11a7d89mr3638559a91.16.1792120865028;
        Thu, 15 Oct 2026 20:21:05 -0700 (PDT)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ac9474b52fsm7959974a91.9.2026.10.15.20.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Oct 2026 20:21:03 -0700 (PDT)
Message-ID: <643bbd4c-1041-43b9-9362-17c5330fc06a@gmail.com>
Date: Fri, 16 Oct 2026 11:20:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/8] kdump: reduce vmcore size and capture time
From: Wandun <chenwandun1@gmail.com>
To: robh@kernel.org, baoquan.he@linux.dev, rppt@kernel.org,
 m.szyprowski@samsung.com
Cc: catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 chenhuacai@kernel.org, kernel@xen0n.name, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, saravanak@kernel.org, akpm@linux-foundation.org,
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev,
 robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, iommu@lists.linux.dev
References: <20261016030855.4062882-1-chenwandun1@gmail.com>
Content-Language: en-US
In-Reply-To: <20261016030855.4062882-1-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6617CA0007
X-Stat-Signature: kjtuq8frotc4ormyu97dazpst8w587ky
X-HE-Tag: 1792120866-262131
X-HE-Meta: U2FsdGVkX18hYhHX5XSBlDKkitj1u7NXH0wO3FK9DODKxrsxBx/1LDLXah9bMgvjCxHzeFdZFBxrPOzGmcUQMRmnpKL658GQ0XBBELlwAzZPGui0usStP8P426VDbC/xZkmzKvbq8xhkXQ3UKbtxuoCWqtFniz95+w2YltSsnpYeUrl+yJNCLsG4ZMs1mKbTtZuzB9JLt5iCJSq98acds5uJ2QAV45DrOECClpJ6Ry+RMu8JI+WSmoD7dDLTKMnadgpE5dWg6g6DTUkwacdLO909zqVI6RHqpV4T+4hNVRqigl6X4+C98fJBmmHyZwcKVUauwhUr4tFpHgCEwFzH/yIC//+2O+5RR9xL9+6lVtz+t6WAt0QkrX4niU8LmnnCKow+aEL5CFe3fhuHKoIpjmZj+7RIssuCS1hWBRrXtsJfwVA0TPBiMPFFTb4sadLEXjWotHpl6n2bpxblzoEf/UsFeaxKHAgR6stEwFER1IHMMuW/xf05lSsGzp4vW2T0RWOicP89cr0hybymGYOSgc+QMGE+JHpoDQQ75UqifyS7C4CSx31yYTVB/PaHbug5Ii3BnbanI6yTtR9kX1UOQFv/xFo5WtP2FN8fC77glPYOGUiSlRLuQH5SYVhhMBdVOf1zrjNV1hkHwomztJ517+0FxBXNm/oCp1rMS1JHI9Gb41MH5XmdKnRBVSiZRjkiiwvDifbJLhu4uECJgXOxN8LLVpnGRVv0V+8pLNpEO+be470guPrc0MUkKiDElsHuMsYiGwUWZkzUCIpNXrYjIYddRozwuenK/Zx+y/b6tz8vTDPl10bhO9sPl6qq6MQGgDz9+STcV/AJMICuqdBRWby3AigEgbqba9uOeO8MnyI65YAbDpQXTFARqyek6ZoAq6MDbjJgGmlAeVrr3rohHi3K8qJceuhIau9RrpPOA9IDspSuPhPo8F53iB4pHHSXLptH9+rUJIFjcXimCi1
 3Q8Vv6p4
 8YlrZmWv0Km3tP9CIy5M8UZ+EzahJYSbQ1/zmNX40fX7tytEyBJhM+T9yV0CsOZG8F41tVSdsQzUE0mWrlx54EGE63fMPolqEsDaMAQUjnzfrCiqOzPT/dU6oKM5EuGkx8P1z0nFo+25qIjrCJakCuPnnRHKwuy15ctdgdIN0J75rn9eAvGRdAMsFKKBLMwm+XtC8aSssb+guC3Kq2T7H9PMb2Im/OTJnp497jjfQymKcuYzLwgkyzl3pzzdURAPnMXZvXKPJBuXn8w/q0mS/O905JYj4RuVWTgRbX/ybCzxiRqe5WpQpQw5QQVWcv+TxlbdjVPOIS0fSGe7KHyDR4MeWbDG1gFzn0IcDXpdKri473GISfqxgTgrB/YVfy6mqmh+IsS1xoBdjer6ei9VBL1wwMdHeUPhSena4W220CDFD4BSja6SdSltaX+m+pj8cWdhcnI6Qm7fiL9LZY9T77dv1GYEsHnRjdkkqiDKos8xJMJQoqsZCdJVP2OSNqw442Ssh+Q/Q17zsKgeKEuQh2gDUJTH22V4TehmdqdkZgVkjqrJrXYdA9mo2ug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Hi all,

My SMTP server hit a temporary error (4.3.0) partway through sending
this series, so some patches did not make it to the list. I will resend
the whole series later. Please ignore the current incomplete set.

Sorry for the noise.


Best regards,
Wandun



On 10/16/26 11:08, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> On SoCs that carve out large firmware-owned reserved memory (GPU,
> camera ISP, ...), kdump currently dumps those carveouts as part of
> system RAM even though their contents are firmware state that is not
> useful for kernel crash analysis.
> 
> ACPI systems already filter reserved memory out of the vmcore through
> their existing path: firmware reports those carveouts as unusable in
> the EFI memory map, they get MEMBLOCK_NOMAP set in memblock.memory
> (is_usable_memory(), efi-init.c), and the ELF header builder has
> always skipped nomap regions; only DT-based systems currently fail
> to filter these regions, which is what this series addresses.
> 
> This series introduces a MEMBLOCK_NODUMP flag (suggested by Rob) in
> memblock to filter reserved memory on DT-based architectures. A new
> flag is needed because MEMBLOCK_NOMAP can only express regions without
> a linear mapping, while MEMBLOCK_NODUMP can filter regions that are
> linearly mapped. Reserved regions are marked MEMBLOCK_NODUMP by default
> so kdump omits them; reusable CMA regions are different because their
> pages are handed back to the buddy allocator and may carry crash-relevant
> data.
> 
> Since the reserved memory regions are filtered out, the vmcore is
> smaller in size and faster to produce.
> 
> The series is based on linux-next and is organized as follows:
> 
> Patches 1-3: Preparation and bugfixes: switch riscv crash_mem to
>              memblock, fold the duplicated per-arch memblock walks
>              into the weak defaults, and serialize crash header
>              preparation against memory hotplug.
> Patches 4-7: NODUMP infrastructure: switch crash_core to
>              for_each_mem_region(), introduce the MEMBLOCK_NODUMP
>              flag, add a dumpable flag to struct reserved_mem, and
>              mark /reserved-memory entries with MEMBLOCK_NODUMP.
> Patch 8:     Skip MEMBLOCK_NODUMP regions when building the vmcore
>              ELF header.
> 
> v6 --> v8 (v7 mainly tried to fix the initrd issue on release in v6,
> that approach is superseded here):
> 
> 1. Stop marking /memreserve/ regions with NODUMP. v6 marked
>    /memreserve/ regions with NODUMP. But a bootloader may specify
>    a /memreserve/ entry for memory that the kernel later frees
>    (e.g. the initrd), and those pages would then be wrongly
>    filtered out of the vmcore after being reused as normal memory.
>    The v7 fix (clearing the flag in free_reserved_area()) caused
>    a lockless runtime mutation of memblock.memory [1]. Better solutions
>    exist but need extra preparation, so they are left out to keep
>    this series simple in v8.
> 
> 2. Fix a build failure in patch 2 with both ARCH_KEEP_MEMBLOCK and
>    MEMORY_HOTPLUG are unset. There the memblock arrays live in
>    .init.data, and the weak defaults referencing them create section
>    mismatches, which turn into build errors when SECTION_MISMATCH_WARN_ONLY
>    is also unset.
> 
> 3. RISCV recently gained crash hotplug support, so adapt its handler
>    like x86 in patch 3: use __crash_prepare_headers() instead of
>    crash_prepare_headers() to avoid self-deadlock.
> 
> 4. Update the cover letter per review feedback: describe how ACPI
>    systems filter reserved memory and why a new flag is needed
>    instead of reusing NOMAP.
> 
> Every patch in this series now carries an Acked-by or Reviewed-by tag.
> Patches 2 and 3 have changed since v6, but the changes (a build fix and
> a riscv hotplug adaptation) do not alter the logic the tags were given
> for, so their tags are kept. If any tag should not be carried, please
> let me know and I will drop it.
> 
> 
> v6 --> v7:
> 1. Fix a stale MEMBLOCK_NODUMP flag issue [2]. Memory reserved and
>    marked as NODUMP may later be freed (the initrd, for example),
>    so the NODUMP flag must be cleared accordingly. Since the fix is
>    part of the NODUMP infrastructure introduced by patch 5, it has
>    been folded into that patch.
> 2. Drop the "generic" related description in the cover letter.
> 3. Collect the Acked-by and Reviewed-by tags received during the v6
>    review (thanks to Baoquan, Mike, Rob and Marek). Patch 5 is the
>    only one without a tag, as its Reviewed-by was dropped when the
>    fix was folded in.
> 4. Drop patch 1 of v6, which has been merged separately.
> 
> 
> v5 --> v6:
> 1. Serialize crash header preparation against memory hotplug to avoid
>    out-of-bounds or use-after-free issues.
> 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
>    avoiding a panic from too few regions before resize is permitted.
> 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
> 
> [1] https://lore.kernel.org/lkml/20260922090252.B01541F000FF@smtp.kernel.org/
> [2] https://sashiko.dev/#/message/20260917220750.GA4013814-robh%40kernel.org
> 
> v5: https://lore.kernel.org/lkml/20260806093519.2907771-1-chenwandun1@gmail.com/
> v4: https://lore.kernel.org/lkml/20260630074715.4126796-1-chenwandun1@gmail.com/
> 
> 
> Wandun Chen (8):
>   riscv: build crash_mem ranges from memblock instead of resource tree
>   crash_core: fold duplicated memblock arch hooks into the weak default
>   crash_core: serialize crash header preparation against hotplug
>   crash_core: replace for_each_mem_range() with for_each_mem_region()
>   memblock: introduce MEMBLOCK_NODUMP flag
>   of: reserved_mem: add dumpable flag to opt-in vmcore
>   of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
>   crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
>     header
> 
>  arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
>  arch/loongarch/kernel/machine_kexec_file.c | 27 -----------
>  arch/riscv/Kconfig                         |  2 +-
>  arch/riscv/kernel/crash.c                  |  2 +-
>  arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
>  arch/x86/kernel/crash.c                    |  2 +-
>  drivers/of/fdt.c                           |  1 +
>  drivers/of/of_private.h                    |  1 +
>  drivers/of/of_reserved_mem.c               | 15 ++++++
>  include/linux/crash_core.h                 |  2 +
>  include/linux/memblock.h                   |  9 ++++
>  include/linux/of_reserved_mem.h            |  1 +
>  kernel/crash_core.c                        | 53 +++++++++++++++++++++-
>  kernel/dma/contiguous.c                    |  1 +
>  mm/memblock.c                              | 16 +++++++
>  15 files changed, 100 insertions(+), 94 deletions(-)
> 


