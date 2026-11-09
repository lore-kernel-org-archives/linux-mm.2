Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5442606EEB9
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 12:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=A8AxYfty
Received: by kanga.kvack.org (Postfix)
	id EC3C66B05B7; Mon,  9 Nov 2026 07:23:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9AF16B05B9; Mon,  9 Nov 2026 07:23:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0276B05C5; Mon,  9 Nov 2026 07:23:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B116E6B05B7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 07:23:36 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4107F8067A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:23:36 +0000 (UTC)
X-FDA: 85415496432.26.DB30462
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf14.hostedemail.com (Postfix) with ESMTP id 40ACA100004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 12:23:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A8AxYfty;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794227014;
	b=k0mYYCerwq2jXaclWiVj3qGouLgOj0AZyD2IBECnx5jDaUhoJKNXomIs/cumBq3gkzCKGO
	HgvXsu+0LfZheNPYn+yA3mlGBq2iJAFQ68VlI0AgGBvu2xwsqhhkhGWTqY1oVuXWTYGI9u
	V/6+qa+7r96MYwJ6F86R+RXrd5N6CS8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794227014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tF8l8wiFwVnoygmXpYnREIWubWMOLu/o49/XwgRJmA=;
	b=XMRa6wsEYiz6DOqWaV9+vvHl+V+CKLIZvvK1mJazx7n6lHyHqXcmW4Vy0/g/GfO3IQC2rI
	Ae1lM6k0g+StudhDu3SBgCX/o8d8j3UEQ2yXMdfmMknrPEAID9Vi6og2aR26QajSlC0cZJ
	4V5VKh2zZBxg3DfZp26r7+NO8KM2CBQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=A8AxYfty;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
Received: by mail-pj2-f7.google.com with SMTP id d9443c01a7336-2ed14ad20b8so4294595ad.0
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 04:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794227013; x=1794831813; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+tF8l8wiFwVnoygmXpYnREIWubWMOLu/o49/XwgRJmA=;
        b=A8AxYfty5Yu7fVJVPk6QpbOuQTf2l3lbidABAWRpHNiHPMUI9j1vZ0fM5lsteBAhfW
         gqxN0fExgVw2nnzHhQhEZDwpMDQFP/DCdOYaI4Tfc6QKN1yVp24lrSYaBb+sVOxWjLHn
         TWLa7yje0XJn+OQJ0WMeoHYyiPNTfaN7S4vRR403m5nc2s+7E4CoVK4DBu5oaFxneYbL
         2a6kxH2Cd4PEc+ulpYvaQMkro1jlDlrDTJOzsUJVPhm07LbL4Hs82r1G0UGRYeV45+fD
         B9QmBYsK/PEl499MWsZ7SjoQ9wezJGm2JwWpVYpGC4hESNbQRynjfPGNgxpd1nh5TG2T
         i8AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794227013; x=1794831813;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+tF8l8wiFwVnoygmXpYnREIWubWMOLu/o49/XwgRJmA=;
        b=iubjvIR+5Em+jj3FNn0T2ckwvWxzTnOoB4IknhnIkFZ/QV9KXAq84ypFh+Z0ry0UzK
         LECJe1ZdZnvxZcRtM5BhFyGzPqsKd9BVPPxzsiX+4kvsOoVKRA923mQY7PBCbNvtqKbR
         +C2ROHA5+LnWrfQnmYqNq9N1HNCYwt40LXwj/5Po9AiMxthAu/cDBai1RXqd+DyTPoH1
         t2YhQf03NbMPLMROyL8XmogaGEDugL4v3xyDzbt1TBc5/RLskMSd4RpO2u5r4sZDrN6X
         c2y5Cwr239B9fBGonqxuamv91f7SwGaOnznTYsu/OLCs1RCTtZHj/xVWXyJO6Ow7s0dy
         5P1Q==
X-Forwarded-Encrypted: i=1; AL+hErFOGD8kMKfTJmZFRzG+OapHBTWPTP1dYr8UeSjTtyn5oJbXvQsnXlnMPmgWklZC7xVE1PdEdfjMJg==@kvack.org
X-Gm-Message-State: APuU4Z8hgLfSxCbubG8MwlWo84rtr50RJCNk83vNJiw7R40b/tkqaida
	mpsUwgNCcxFxwBo8xsnAskler9PNZ8s4r5TyQzedTk5BF70Qy0sQ5E1M
X-Gm-Gg: AYBFou1flhgRci18YboQwO5lZFda2PpXDo5/EDnXjTGsTLPxOe7HO3w6TScmGn0xi+B
	ejpxBfN+pedqhuz5Mu1t96hQADebQZUmcxJDUATox39XHtk76AZPv4tSI5lXQW/alk0OJEMfkMq
	dhjuuOcYyhQZxXVTV2C1iAGUm13+FKeL9ajI0nqybBiAwK8efnG5ktZUkisPFZZ/kbAaAyOHp01
	c5tUvL9MGooYAZAs8Nlo6ZmORVtprQIhGdiSjYoaeGjFdMxOEaZ8ozAESx4YGYZw0mWfuYp2ed1
	40E6ZlQ2kAat2vM0wX0fWi/gHKO11qF2LRxoRwN6VDZHvqQnezJEd20bEFK09afSc1uFZwGs3RA
	olfU48wA0EeRa/bZNjx6Xeo1xiNCN+HS3RVJxfauNpo5Oxsk/nttgUqSv8ZMUgXVXkM8KkNaPjG
	PgLdZTiaDkKyluS321Lol7Tx7jFKy5ENC4h9N4Y7KelK53l3e8nan1QOmAcDR9r3aWxfLLiQH56
	1ffA7nX4r6G+YENDyj/DqAGMe3JSNigrU/UlmNZzA5JLWgHyNxMYn+XNmKHpDEYJgoMqbPK4GhT
	+B1JINx95Cmui1Lr2RP+5Z4nMeECEEFkldI=
X-Received: by 2002:a05:6a20:7f89:b0:3eb:afe0:20aa with SMTP id adf61e73a8af0-3eed2e06bb1mr3837559637.20.1794227012895;
        Mon, 09 Nov 2026 04:23:32 -0800 (PST)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cdb96816fc6sm1622392a12.5.2026.11.09.04.23.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 04:23:31 -0800 (PST)
Message-ID: <7773d026-4aef-4169-866a-71ec9a91da21@gmail.com>
Date: Mon, 9 Nov 2026 20:23:16 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/8] kdump: reduce vmcore size and capture time
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
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
Content-Language: en-US
In-Reply-To: <20261021083011.2170525-1-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 40ACA100004
X-Rspamd-Server: rspam12
X-Stat-Signature: fwccmcjsm9rfqfuk7as1sqhrt8syz77t
X-Rspam-User:
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794227014-137547
X-HE-Meta: U2FsdGVkX1+KdVSxedRtcv1fUIiuktmjUtYhMy6/1fD+DrNuXwycmjqdMrIiAgFE5L5yDHVRUAUN1Nvz0I8tAI/Uf3dHjSBhg5Zwxqp1keOjsFFAP7moKdhwvPPsnX0mKqJQHWCTAnwkl8ZzSr5E+LtltS/gpL447kP9Z3K4K7e7+j4awq3bgpR4N1VwlHyFdagzLQNtgF5I7aK8hJsUn+/o3l/qSOuNGsPWWwxP0Yh5dJB0RX4HAM2xUNYA56AOeg/rlGxPQMHF73iNsbXamu7DxPJ/452aOUhGAR1R1z5Fn1XL7vrojDfC4Hf5gP4LqLOrDMjvMMJksZ/I1mHkwUNAcck5yhjLipa0QeiQ/w926OH34oab2bH2dRpVgLuDWNa9JwM25jzSS59tctisLdd9eUTY32WrE41MJKu/Ch/QFk5CAwkbhccNcj484X6KHn8y4mhdCQzryQU28CqE4GL2cQnOIEhDSdOxFGF9w7UmU6tVCWaXdm3Y5E0xxJSnZ0i4+Y4bfdlUXl1XxD0zvt65ucnVRb7YcNOYsJ68eOmvlKqL+Ve/Ug9mEpbrf+2C3dww8vNlh7SlTb8L66XjWInwx24h7BRPGgooPmQ8G38KkdO0J1p4qLvIh57qs1qzVRXVtT0NbhJyZq6ioHFURvNSrc/XhidajYCY85G+595jcrMDYsmPiScJCwvt71OO869i9MsopOsIVKqJ3mOBbYbEFc2PHwARPPLjpUNAECa9OvJ9aj+J2hs2Q/UxBDfJl4lZN2ZjB5fEHe36kQCqd/1YkEhYuBW+JkUh1THnu9wfU1HvZGuByP5BwI2xn8nQ1oJ17VNWSIaHlk3i8MtAkT3sJEEQlBQfXHHmEXTbFpV9Q0kV0vaocalMP+0b91QTxsJbjJLpPIYkONMBQP63NmOgarB6V9fVECMzdc0LLQdR2R7V6xr5+I01xAjSt3emjlR74YfQfL4khObnRbb
 BltUW88c
 s48+iBUWgfn7if0YLc3FI+/9D7pKEWKmgwB/5hi3Bz25E8XO3RI1FqySSh7z5J/VjXNUVqMTgTQ8NRcesETR0HpKKxsr9d0ZLs+OB+ZCcmrGkge1AutsBjk70gOS1j+csMJpNnkv8kjmqM3h1M2g+8lPVOb0+68afj0dAfodeB0t4b8wdJePJNtviZFDpRUcz3lylJpVkSqzYltFzw68C3pxaKscxL9ZxSxyxpbJebxxrBddsKiYVLlLwGdQOe7tYTu5RbbFfjDR/nWveFUhFnlwugOnxOgD1VFi/J8VlgwzN0KFJ8BS8RdRRwV+Q1JtzwQ8vNqYh8GgfaMKCzF4BRvZ1jrNDZrktqvC6wycU84j8qVIDe0VVZDo7RjPDl+wn43ePWLYk9byohs6LllpOUztb2rF50iJQQrxGvsYtDqPkCyRk5+B8OXEjZN694Ada2iU1OzoPv6U3y5Er5vQV4zJEaqOM6nMusnRD2/L9mg5LoalnKs7ulD0WajhVzEin1gBK1ce5bB2QodXFvNM34sJWdz3ysQgScU+zgscc3WG6Pkowe3TowuhowRAIz+EBjSX+r4YrKmHa4y90oW4/XuhH5MqtoHQgd1fRE1O+ZmvVS01LE4mlR551imrX/HFwdP7icuznZqYw1g4WMncilwOmdLRwktpSaai0omKmaJpk33Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/21/26 16:30, Wandun Chen wrote:
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

Hi all,

A gentle ping on this series.

I'd appreciate any further feedback, particularly on the
MEMBLOCK_NODUMP discussion and the issues raised in the Sashiko
review.

Please let me know if there are any other concerns or suggestions
before I prepare the next revision.

Thanks,
Wandun

> 
> v8 --> v9:
> 1. Patch 7: Avoid a potential boot panic on SH when NODUMP marking requires
>    memblock resizing before it is allowed, found by Sashiko in [1]. SH supports
>    neither CONFIG_KEXEC_FILE nor CONFIG_CRASH_HOTPLUG, so skip marking when
>    both are disabled.
> 
> v6 --> v8 (v7 mainly tried to fix the initrd issue on release in v6,
> that approach is superseded here):
> 1. Stop marking /memreserve/ regions with NODUMP. v6 marked
>    /memreserve/ regions with NODUMP. But a bootloader may specify
>    a /memreserve/ entry for memory that the kernel later frees
>    (e.g. the initrd), and those pages would then be wrongly
>    filtered out of the vmcore after being reused as normal memory.
>    The v7 fix (clearing the flag in free_reserved_area()) caused
>    a lockless runtime mutation of memblock.memory [2]. Better solutions
>    exist but need extra preparation, so temporarily dropped the patch
>    that introduced the problem to keep this series simple in v8.
> 2. Fix a build failure in patch 2 with both ARCH_KEEP_MEMBLOCK and
>    MEMORY_HOTPLUG are unset. There the memblock arrays live in
>    .init.data, and the weak defaults referencing them create section
>    mismatches, which turn into build errors when SECTION_MISMATCH_WARN_ONLY
>    is also unset.
> 3. RISCV recently gained crash hotplug support, so adapt its handler
>    like x86 in patch 3: use __crash_prepare_headers() instead of
>    crash_prepare_headers() to avoid self-deadlock.
> 4. Update the cover letter per review feedback: describe how ACPI
>    systems filter reserved memory and why a new flag is needed
>    instead of reusing NOMAP.
> 
> v6 --> v7:
> 1. Fix a stale MEMBLOCK_NODUMP flag issue [3]. Memory reserved and
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
> [1] https://sashiko.dev/#/patchset/20261016061549.4181390-1-chenwandun1@gmail.com?part=7
> [2] https://lore.kernel.org/lkml/20260922090252.B01541F000FF@smtp.kernel.org/
> [3] https://sashiko.dev/#/message/20260917220750.GA4013814-robh%40kernel.org
> 
> v5: https://lore.kernel.org/lkml/20260806093519.2907771-1-chenwandun1@gmail.com/
> v4: https://lore.kernel.org/lkml/20260630074715.4126796-1-chenwandun1@gmail.com/
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
>  drivers/of/of_reserved_mem.c               | 18 ++++++++
>  include/linux/crash_core.h                 |  2 +
>  include/linux/memblock.h                   |  9 ++++
>  include/linux/of_reserved_mem.h            |  1 +
>  kernel/crash_core.c                        | 53 +++++++++++++++++++++-
>  kernel/dma/contiguous.c                    |  1 +
>  mm/memblock.c                              | 16 +++++++
>  15 files changed, 103 insertions(+), 94 deletions(-)
> 


