Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B823CA6017
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 03:05:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9F4A6B008A; Thu,  8 Oct 2026 23:05:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50C66B008C; Thu,  8 Oct 2026 23:05:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18196B0092; Thu,  8 Oct 2026 23:05:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 950496B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 23:05:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18CA3A7018
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:05:11 +0000 (UTC)
X-FDA: 85301596422.24.2609972
Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 32F2640007
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 03:05:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LKm1V4J2;
	spf=pass (imf04.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791515109;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qQfYvkNkqoOJCA+/6hCONW4bFzc6fazsqzcsWi6a4VE=;
	b=O5BfzZU4ICPHpVfZZrRQpfnb3wKarRPky4DOiAY2eHsmZOl4hJ5vi5J6DNKFYCAtGo7Nak
	oq1Se7slSXiQKS0oWCaw6U8uEUUXwPeJjfRL3Qgfz7E6QfwvVS0LcMyDT5NX7mS/8m4ojJ
	uf7Bu3I0pcK02pLSeOmhWhd6TgLf6mM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LKm1V4J2;
	spf=pass (imf04.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791515109;
	b=ZnsmH+fJ3iqKoXNIWDIkfF3DNSxigliRN9uNq+iJUO6JCFtOPAK1rfAtf1HJGdUrczm1Vh
	fiP79LdhrKCy1muY0Wuxmf0XTNQkLLgO6cWqhBZok7Zs5GP2Dmsc1PFrFYGdd/ZNDtK7+m
	DhdTNcRc0v3XI+gLM81sco81lXWggOI=
Received: by mail-pj2-f5.google.com with SMTP id d9443c01a7336-2e7c8213b09so6621025ad.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 20:05:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791515108; x=1792119908; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qQfYvkNkqoOJCA+/6hCONW4bFzc6fazsqzcsWi6a4VE=;
        b=LKm1V4J2ErS/s6PM54NaOChpTDb2CsL7BZmWCPu8nGdGwaxy5poZ6o2lmFR1bslzAL
         3FWjY2+MqGy86raAmKy8ZtqNR9T1oXDCdwjHyMyMPKn8y1Q4iR4lG7QDMp7f2q2ix5pD
         k8AgnW35w2L5MiRNUqFNOdRkPR8DbNQ2KfjwWnZXMkTKSbNOfUwWE08dRd2xrUWKsJry
         kCfgToueo4m/aKwIOUt5hL8S7XUw3QydzUh1LzKL85RUG64EyQCJwCwq1oU+jctk/Ta5
         RcMcG5pvhgqMsIyEah3RyNOH2SHaLnht9jbupmDtGjRaxWUFVHw37iVYkLZN1lg4a8RJ
         jb0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791515108; x=1792119908;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qQfYvkNkqoOJCA+/6hCONW4bFzc6fazsqzcsWi6a4VE=;
        b=rTFP0TeDh9d/ZoEAl6ex6EaO+PYYn56jUoJ/v8cBxvPFRDy0BLyjZqbECvmBr4vvMB
         T0DG3e3U+Vgmtv+FOQohGV3xvZ/zN/E2HZ6iL1vNvS9dyh9zot/YIWHZtP5IyJcDSwnl
         b3wALan/ZCKN9B3+E9Fu52+LmHGRf828oITkLj52H/DHzydKjhrZgJylgI1szRwRBEU7
         ijOCNajtsm865q3GozmjWNrxhyAXivoY90ZlSG88m7G7+UwhzfDKVZvxhzGShOh1SgUW
         tpkKHRKgMK5eILpOV/KLlkLH60igVqHXFUqWno0EwM3etMIx5eRrWsBolvZa3x8ekbd6
         oWnw==
X-Forwarded-Encrypted: i=1; AKwUvBwca9289BVbZtBb70XOLiuPjmVMLPxT9WKY9qXMjk4bE7LBdFujDdTJ8sPGC4v8+NkAd6aibPxjqA==@kvack.org
X-Gm-Message-State: AFuF++lTpkK48jAZzht8/zd/mRwDT2B/29erhvi4/JbeypGEeg42H4D4
	hISiKfElVTqNYoEnTCqS2Ia48PTlT6YGWKQskPqD4JqjogRt/M+nRzXs
X-Gm-Gg: AYBFou0VCVdWk91/3BMWM415bPxMcW1cnBVw4cp/seLu5oW5v6Z8sGdu+uS2OwDW4ty
	Zy7Cutp6atEMB05bRU8ievsd9jTz8tylUdSEyc7qrANePEUKwFagAyUf13VIY2VTS8l/qYhy7eU
	edLlodTdhS/qcO48IBTlUwTJ+IljL5RyKcaduDUtqTCcxzVklSbmmvD3XFnfgCbs6LgIBwLULZt
	DCFI6JeTnsNaHLJ2+35OMMgd1rj/e80hJLG8p0QFU718DQbyoVqHETJj2u9BSMxQ7imrmZycal4
	2hXQoFCNP1Wu09hNX1wAygZaQ70/09W/RQGYJq0YzciDf/BuOZafkK3mP5m/fsg0RLI9wUBpikD
	8CtkfCdkEhBb0Zs2/XlmF2J0FAcGekFh2DPPAg9Kio3eSnyPdQS0VqvcoL15icG8wsG3SL4xN7h
	Ym/jMviWoDLZtNIkFOJbTFuSySYqzErQkKhS1yheL1BCdS9HvxOZJvqD2U7KmzTU10SFQ5hdRar
	lvxYg==
X-Received: by 2002:a05:6a21:e08c:b0:3e0:da23:8746 with SMTP id adf61e73a8af0-3e16bdae93emr416704637.18.1791515107689;
        Thu, 08 Oct 2026 20:05:07 -0700 (PDT)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e08c89sm296018a12.8.2026.10.08.20.04.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Oct 2026 20:05:07 -0700 (PDT)
Message-ID: <80af60db-8c39-461c-a488-3dfee990bce8@gmail.com>
Date: Fri, 9 Oct 2026 11:04:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 0/9] kdump: reduce vmcore size and capture time
To: Mike Rapoport <rppt@kernel.org>
Cc: robh@kernel.org, baoquan.he@linux.dev, m.szyprowski@samsung.com,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 chenhuacai@kernel.org, kernel@xen0n.name, pjw@kernel.org,
 palmer@dabbelt.com, aou@eecs.berkeley.edu, alex@ghiti.fr, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, saravanak@kernel.org, akpm@linux-foundation.org,
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev,
 robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, iommu@lists.linux.dev
References: <20260922084256.1515554-1-chenwandun1@gmail.com>
 <ar9ogXc12cLjziHS@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <ar9ogXc12cLjziHS@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 32F2640007
X-Rspam-User: 
X-Stat-Signature: btcua1s3xb86mq83nsw6uejznkkkor4z
X-HE-Tag: 1791515109-334543
X-HE-Meta: U2FsdGVkX1+HPaW4pT+4pSRtZjw5T0OcKgP7+7ah34swWpgQnrH7uhmtqE0duym8ynU6IFO9Lz0XoVp+EMBTfEq+RSejMDy1QGvwUGSfso3FM+YcobYBCc6R4fkY0udFc8q5xZmqOCwAdM6PJlOYdAIPDBH7EMk7hsBqJNJaKsJFddQTLwkpwheuFhOuwM1bw0jo2JJqQix5uYViwD3xjv29Jhk9AtpBQ00m1iyCDUH/wmyYNs2MDyZUcwlFXp2/n4V7V4lBsuGWy8A/rR7sS4sPrpykubcgkoo4x73pwSS3aMQs5tNUevnHqo3In31ZordULZNUN4ZbrG7kySbireg7Hq+1YBY8WcGqA3GX2gKMqyu2i3v4Yn1+0L9Ww4k75gWCsXWpv6lT7iGpzrrpOOFwhM9BjtcWLAE5SGWg8Hc7ZtKLjdl/E6sNTXb56jQk+fp4rGAI0yk91z/bLx4RhicV8UWtUASdmRmKYhtO8Y3Tf8MENf5wLGwpywd2fzX1HIpHTH3O+WkjFAYOXDcLFGG55w7NGjKtFVqJysb/Q+ufNN4LOrd7QUXOLztDEbpb+gUBl40IhpWqW050aQ/YtEB101IPaM3yFCyUaYdyL7u6+3VMvn9mc4mYzwA+gSN2ME2vbp7M1+I58/0D7738y6/2BScXxCnE++HaZQJxG9RYP2VYiWNqBM3uOVamKUsicoV6SavKukA+kftq/3Yb9kFDwkERRGNUKyx3nP9QvtgZwAY8Un0mXz/WpQ7Ux+SdFvRxuX01xC6b0tsgIsEJ8AzZVMWzngGSlKavCKIl0kqx+W5Q0h1lFCw7xXDvn32v2k9PcFXQu8UIVw7+vuDNgSpCp5RXipJrV8Y+xb+BnDG47mD9wgrnAvz17SRdavsCXfJn6TYONaAI4qN4SCYqV8HXhGTwpTTeR65kDDZUMrQN2pxfXRs+zQg7NsBJ7vcKqtLht4vgt6qk8oyKsQf
 jEc1x6iK
 EO6bR4UOZXmlWhs++KdMKABVj2BEa+TVrb8sCdVheBS3ZZycKIP/vWJG+hrMrDcJQWsM+ByPPKbx4fG7/JY5H1WWgGGUzJd1KK32/SOjLah7QasKHQuFaKbzFeUx6t6KaLGXMYskJ/srpHvMGTxpp76DOWP/G2quDhOkjFj+sOyckaPgbMHRr+XX/ps4jSfMPAn5UhFf+vkBGDxf8cy2xfM6ntM3BrnkdJxGAnFIQCwpoG7HwoOyI0XmRykGeEEU+cJ8IxYHftswUsUX7TWfRRPmYFrJjYG8sSA1YnpnVZqiDp7xhMsVO8YYjyPloRwERbYAMCh4FB/qMbHHzfpFx5nTSVwVWf7pWDh4QBiEV/B1JoW6i7yWM5Zxdca6BVZ4UYeEsb9QK8um08gEnTJQa1WPVK32EzLiZP1x/WnRzEvd7lmEDbjkLz1MFlenQxGV1qqvnqYN6A/hlMCx2D5TS1I7KH16r7hw0M5miZAomR5SosnXcfW2R94ZgdsbN9P1R53TkBO4ezI7dTsIAFQdFILxowDoFzfg73RufykzFTICbVis=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/2/26 16:17, Mike Rapoport wrote:
> Hi Wandun,
> 
> On Tue, Sep 22, 2026 at 04:42:47PM +0800, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> On SoCs that carve out large firmware-owned reserved memory (GPU,
>> camera ISP, ...), kdump currently dumps those carveouts as part of
>> system RAM even though their contents are firmware state that is not
>> useful for kernel crash analysis.
>>
>> This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
>> reserved memory on DT-based architectures (arm64, riscv, loongarch).
>> Reserved regions are marked MEMBLOCK_NODUMP by default so kdump omits
>> them; reusable CMA regions are different because their pages are handed
>> back to the buddy allocator and may carry crash-relevant data.
>>
>> ACPI systems already filter reserved memory out of the vmcore through
>> their existing path; only DT-based systems currently fail to filter these
>> regions, which is what this series addresses. The flag lives in memblock
>> itself rather than in a DT-only structure, so both ACPI and DT systems
>> can benefit from it (suggested by Rob, thanks).
> 
Hi Mike,

Thanks for the review.

> Can you elaborate how ACPI systems filter their reserved memory?

In the EFI memory map, firmware carveouts are reported with the type
EFI_RESERVED_TYPE. This type of memory gets the nomap flag set in
memblock.memory (is_usable_memory() returns false in reserve_regions()
and mark these regions with nomap flag), during prepare_elf_headers(),
for_each_mem_range() filters out these nomap regions. Therefore, the
memory reserved on ACPI based systems will not be dumped into the vmcore.

I will add these description in next version.

> With your patches, the memblock flag becomes a part of DT-only
> infrastructure, so that claim that both ACPI and DT benefit from it does
> not hold, doesn't it?

You are right, the wording was misleading. Let me clarify what I meant.

In this series only DT marks regions as MEMBLOCK_NODUMP:
/reserved-memory and /memreserve/ entries are tagged in the OF
paths (of_reserved_mem.c, fdt.c). ACPI does not set the flag and
keeps filtering its reserved memory through the existing path, as
described above.


What I intended to convey is that the flag itself lives in memblock
rather than on the DT-only struct reserved_mem, so it is available
for reuse. If an ACPI system ever needed to exclude a firmware-owned
region from the vmcore, it could mark that region with MEMBLOCK_NODUMP
the same way DT does, instead of having to invent a parallel mechanism.
That is a future option, not something this series enables for ACPI
today.

Also will update these description in next verison.

Best regards,
Wandun

>  
>> Since the reserved memory regions are filtered out, the vmcore is
>> smaller in size and faster to produce.
>>
>> The series is based on linux-next and is organized as follows:
>>
>> Patches 1-3: Preparation and bugfixes: switch riscv crash_mem to memblock,
>> 	     fold the duplicated per-arch memblock walks into the weak
>>              defaults, and serialize crash header preparation against
>>              memory hotplug.
>> Patches 4-8: NODUMP infrastructure: switch crash_core to
>>              for_each_mem_region(), introduce the MEMBLOCK_NODUMP flag,
>> 	     add a dumpable flag to struct reserved_mem, and mark
>> 	     /reserved-memory and /memreserve/ entries with MEMBLOCK_NODUMP
>> 	     flag.
>> Patch 9:     Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
>>              header.
>>
>> v6 --> v7:
>> 1. Fix a stale MEMBLOCK_NODUMP flag issue [1]. Memory reserved and
>>    marked as NODUMP may later be freed (the initrd, for example),
>>    so the NODUMP flag must be cleared accordingly. Since the fix is
>>    part of the NODUMP infrastructure introduced by patch 5, it has
>>    been folded into that patch.
>>
>> 2. Drop the "generic" related description in the cover letter.
>>
>> 3. Collect the Acked-by and Reviewed-by tags received during the v6
>>    review (thanks to Baoquan, Mike, Rob and Marek). Patch 5 is the
>>    only one without a tag, as its Reviewed-by was dropped when the
>>    fix was folded in.
>>
>> 4. Drop patch 1 of v6, which has been merged separately.
>>
>>
>> v5 --> v6:
>> 1. Serialize crash header preparation against memory hotplug to avoid
>>    out-of-bounds or use-after-free issues.
>> 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
>>    avoiding a panic from too few regions before resize is permitted.
>> 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
>>
>>
>> v4 --> v5:
>> 1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
>>    (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
>>    DT-only struct reserved_mem [2].
>> 2. Switch the riscv vmcore elf header preparation to use memblock
>>    instead of the resource tree, aligning it with arm64 and loongarch,
>>    so riscv also can exclude reserved memory from vmcore.
>> 3. Deduplicate the vmcore elf header preparation: arm64, riscv and
>>    loongarch open-coded the same logic, so fold it into shared
>>     __weak defaults in crash_core.
>> 4.  Drop the v4 patch that saved /memreserve/ entries into the
>>     reserved_mem array; /memreserve/ is now marked MEMBLOCK_NODUMP
>>     directly.
>>
>> v3 --> v4:
>> 1. Rebase this series on v7.2-rc1.
>> 2. Add two cleanup patches (patch 02/03).
>> 3. Simplify patch 03 to avoid checking whether initial_boot_params is
>>    NULL multiple times, suggested by Rob.
>>
>> v2 --> v3:
>> 1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.
>> 2. Fix UAF issue when alloc_reserved_mem_array() fails.
>> 3. Add some prepare patches.
>>
>> v1 --> v2:
>> 1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
>>    feedback [3], v2 drop that property and exclude reserve memory
>>    by default.
>> 2. Split some prepared patches from the original patches.
>> 3. Address coding-style comments on patch 5 from Rob.
>>
>> [1] https://sashiko.dev/#/message/20260917220750.GA4013814-robh%40kernel.org
>> [2] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
>> [3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
>>
>>
>>
>> Wandun Chen (9):
>>   riscv: build crash_mem ranges from memblock instead of resource tree
>>   crash_core: fold duplicated memblock arch hooks into the weak default
>>   crash_core: serialize crash header preparation against hotplug
>>   crash_core: replace for_each_mem_range() with for_each_mem_region()
>>   memblock: introduce MEMBLOCK_NODUMP flag
>>   of: reserved_mem: add dumpable flag to opt-in vmcore
>>   of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
>>   of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
>>   crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
>>     header
>>
>>  arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
>>  arch/loongarch/kernel/machine_kexec_file.c | 27 ------------
>>  arch/riscv/Kconfig                         |  2 +-
>>  arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
>>  arch/x86/kernel/crash.c                    |  2 +-
>>  drivers/of/fdt.c                           |  2 +
>>  drivers/of/of_private.h                    |  2 +
>>  drivers/of/of_reserved_mem.c               | 48 ++++++++++++++++++++
>>  include/linux/crash_core.h                 |  2 +
>>  include/linux/memblock.h                   |  9 ++++
>>  include/linux/of_reserved_mem.h            |  1 +
>>  kernel/crash_core.c                        | 51 ++++++++++++++++++++--
>>  kernel/dma/contiguous.c                    |  1 +
>>  mm/memblock.c                              | 43 +++++++++++++++++-
>>  14 files changed, 155 insertions(+), 97 deletions(-)
>>
>> -- 
>> 2.43.0
>>
> 


