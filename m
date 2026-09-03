Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C831BC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:44:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5BA96B00C7; Thu,  3 Sep 2026 03:44:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D331E6B00C8; Thu,  3 Sep 2026 03:44:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C49D06B00C9; Thu,  3 Sep 2026 03:44:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A73206B00C7
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:44:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 327241A042E
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:44:15 +0000 (UTC)
X-FDA: 85171662870.28.E6B53FC
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3E34020005
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:44:13 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="O/Vo39Fv";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788421453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oUbrqLv47LI31OwZX/zERcJxLxOgrZ94RwwzK9bj0r8=;
	b=RGJ702ZF1kbvd+qkPxHPMvAKlORlGBeoq0ajGxq3XjaYFMPPE0L1FsUjBRdz800icBW54K
	tBh31X+X9E9eaXnZS6MjXa6NQ1c9iyuWPUGl7D3j9P6qphQQM/EYVX9Xw+gyxRaPBIqTWd
	exTPERd7HLS3LZZdGLQe2Ap53TLPQoc=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="O/Vo39Fv";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf31.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788421453;
	b=Ykhbu1SF1VfbnzqkuZqQERy49KfON/3hQArLbLQCiTqYy0QKhz/UDsnog9n01O9EWA7KeM
	4X1Qk5xds1kVdEF2u4c976C3mfms88XoYx903GXu0wqjBYwqN/xdGgxnqp4EFHnWmzSonS
	IjuC7NiXYUeMRmfx7A19/ugsd5+aGnY=
Received: by mail-pj2-f11.google.com with SMTP id d9443c01a7336-2ceb5a39c48so5438025ad.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 00:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788421452; x=1789026252; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oUbrqLv47LI31OwZX/zERcJxLxOgrZ94RwwzK9bj0r8=;
        b=O/Vo39FvRXkuaf3e19929BV88qjQAmwiajd5N6+0k3VDE9/N+2tAvgkZ05jDdL38p5
         0yxAsEv0nXpgTg9bwwSxa/4hwxhwTlqkmKAy3eEMAxOghzadjIF5o+s+Hr0tzrsEysMv
         dXRMbSrAnM3DXaK7ao2+AeKnnoUSLsWxD8aF4gjyV1gJ20aQ56vaAWk/3mmgIcG/fSp/
         GzOi+GbL2yZaQ9U/POOfZYeOGP+NVJ4ABG3LKqLDfOchcjY1h9bpICA0ysAD0wXJt6ha
         ZwQH/MWh3hmgbmpB/9rMiRhEW8gjyJVO49uOOetsgffFaYt0nC+1Sx+SslNhJ+WS7GMw
         E6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788421452; x=1789026252;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oUbrqLv47LI31OwZX/zERcJxLxOgrZ94RwwzK9bj0r8=;
        b=AxoFVWC39Ui+M1KMhhwlPY/f1Tc3wLiUHe2OTuMi43Tfj/ckhgUGZCDNjVbbsZwHJb
         D+j3HuRuP1kWwT8cMqYbx3bu3BUrEAPSmxtB3P6+Bn2EVoMR1MkMYIfqxm2jrLzFDR6V
         5t8s2nQZPf0+jK7vSvQT6VJqy2dX69jDZ1tPcSUJu6bE0XFRD5Omk7PQY1t5F61Ep361
         /MmgsOkNt1Rj8VKMGDl/N5lGIhAOfvEmhrv9rzicrxxYQDf7PWC3pyQAJ0o854zTuLuq
         c03WW5fV4RUgQcxeVcjSDW/M7sa1w38jxOqvpQE/qaow6gGqjt3f9kHXLVCKiQvPxk6O
         JQfw==
X-Forwarded-Encrypted: i=1; AKwUvBwjLXzEYtJ1TQdxIo0RfHbQmtwBkhg6zMotB+/M3jmcLUxTfmmRSn4XGTGluwiYUv9rFtJSVUC6uQ==@kvack.org
X-Gm-Message-State: AFuF++n14Si24nxEYTB+u7zXirxFnRj+FjfJaQA44TbnmW6mZLm81wmF
	Q0w0qdR0k7qwC7wcfctIgjB5sPTGDJhXXWus48EUT9Y/s7pz006MYV0f
X-Gm-Gg: AYBFou3A3YRQXv3Qlj1fY5xOYHXoJ3MpA6dy/NPpzq5WvhZW3ddT9EI8UtoTklYcubr
	fKyV3wc20FV9B7YV4sKg9kVeSfCkIegOihNQEw4VHPctoKgrVz93/qWpjTDnYusl6CNEt1C0PCm
	Lgl7MyIyEN0n3VfOMfgmdFhsowSchCXsKW+BmKZatlS/qG6qBzVorLAfH5eIFBmQCkbOc/hXQjr
	NNFqasFurwIRGwhaUt7+tvTtzhARgwSiosgnIolPJYG34GHH/2wfpXI5IBjrc2GWBCstw9VxY/G
	+VktOomKDcNBb1xznZwx+HrFfqPOXb27Vu+u+8hJDrumW70EJwLL0Vy5G/nes0YN6mkWi5+z1+o
	2818PU0VEYuY/YmJbk6paPKgHcnweK91QBhrSuPJvBX5PQo4O80jAAtQKgD5vHN+BPA0rcdfE1n
	cr2P4iIknzbwS+ZpJpaGtj5wUAAxuWylYZYO4S0IcJ6XIH2dW387UsmvYiORDaFc20p7lwv3NPG
	RkEsL4=
X-Received: by 2002:a17:902:e809:b0:2d7:4b42:9352 with SMTP id d9443c01a7336-2daec60af43mr131715375ad.3.1788421451864;
        Thu, 03 Sep 2026 00:44:11 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dafe62d7c2sm5931425ad.29.2026.09.03.00.44.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 00:44:11 -0700 (PDT)
Message-ID: <edd83cd6-663f-43f5-8058-99e59d941d5b@gmail.com>
Date: Thu, 3 Sep 2026 15:43:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 00/10] kdump: reduce vmcore size and capture time
To: Baoquan He <baoquan.he@linux.dev>
Cc: catalin.marinas@arm.com, will@kernel.org, chenhuacai@kernel.org,
 pjw@kernel.org, palmer@dabbelt.com, aou@eecs.berkeley.edu, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 robh@kernel.org, saravanak@kernel.org, akpm@linux-foundation.org,
 rppt@kernel.org, pasha.tatashin@soleen.com, pratyush@kernel.org,
 m.szyprowski@samsung.com, mark.rutland@arm.com, kernel@xen0n.name,
 alex@ghiti.fr, hpa@zytor.com, ruirui.yang@linux.dev, robin.murphy@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-riscv@lists.infradead.org,
 devicetree@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org,
 iommu@lists.linux.dev
References: <20260902073116.802752-1-chenwandun1@gmail.com>
 <apfkDlcMYrgiuGYA@fedora> <6aef2f48-1cc5-408d-a5a2-2b4b4d45ad7b@gmail.com>
 <apkiW8gn9Z5XaVQh@fedora>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <apkiW8gn9Z5XaVQh@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jzm9up95ukm6uwo4fu8m43bnwxkrkxi8
X-Rspamd-Queue-Id: 3E34020005
X-HE-Tag: 1788421453-69182
X-HE-Meta: U2FsdGVkX1/5TVGADtsshoCRysJgIMoIqTNXkQa+mNvlYKTV07RLCnDWO0FbuUhhlmkt33rur1hfrLioXuhuH67l6COd/t98tQtZ8r4CEdkZCWSyhfW6CQp2jx0PvYKPiydm+265x+0/UDwHaQnoEeBrY7Y+HAGVyUHHPFMoxSLXMy1nnwwI5x4bZLhP3iT1Ccd/AINVmrsd4SvVg+snCiBrqqy+777lMi+oAFnpmjtdFAmsP1uiLhxcDtfeDF55M5stiFECmZ7/yTnLE3VO6Byui3+WOiL+8bIPwC+52tdIFUgTwgBTV2C1n+/6jyZORJU7iuK3EPUGVNJ1XK+s5X0aJ5pjsniGh9twn7ztB2YN22fGiST4OZxb966OpjtU65ZUNH/d0c5lq/GnNBMAOVpzXU7tsdc6riX7YQJtPOo/dvkkF3P00mwab4pdxo2FmPUtwDFkm+dT2uv1u0A9fQC0S5MJNTut/sr8Gopc2BQ0JzMYY0TVLWdtddH4OtB/252KSrH+evgqscRE0Cr6ndu24RElB0pKybxcF9Gwd0NmNxCy6SnV4PMy0gvgmrSgbXdEY+SH1eKOPaH5aBUaHYhNPii3V6OpS+uIf6WXz8XG65AMa1ZWr4eIo21KnHHaZhFjlRlWMX5g/5dCNOoHprtCTiEyHm6g6nai1pvFK3LLd+pr7GXmqN6t9KFrtYK9PlKv6KrKy30bdpJVdSYFbb+HrjFmZtMUfxvOIt2x4WVt1J5rLFFcmOGDGSse+3oH/X6HLnNA/1NKw0uehCG/gS3mcfjoJu7t6cJFksASbF5yF1EGcEvI80el7EQTVR+sv+kHUCDTkwZgFubD9k7F5n7KgvLmQRIcd2ip9oA7h3DtTBJZnnUfhQvngNBrQfmJno1fPjg+9GzX49Pg+IGDJ4P+RdLx/7gOXJBh9s8UvC+ux/wC7aU90f6HXUQB2Q3AYeeeCz3yWKV89YMhZ6h
 UMpwNPce
 4NhhMW+C7evhtVA86IkJS+VAX3ESZM8lvckDrUX44rVVCNZCBrvGVFHxP+SRVwgdd/KGG0MwL+a2O3ujSPAIbRbRANtK5Yq/IqPdYdv+1OvaTyoqx+3cmL2LUB9dvPVGAu8cyM7p5nm5ZV13399+cuag8cKuHlIudfOj14aX8Mmrh6fci0wzeX/T+x3/AucP9lhZvd+TePrSCxKkciqeJxLbGsTsCc9LR02o/DGEFXZr4UcM588VbUQACbhbY8rmJ2oZx3SJ1PHA/G/Tt6tKJ3gWe2Z6kIUA1tuAdF0GYR03kCodqwvr9MHBjVdKLFoVO/u3hSiQ4w/bkI3tNODnJp2dz9JE+V+3ruEt8my3FoRJJm5aE46NHFOYsyUTV8BTmzU7zLrLSmPAqF3CVxqEEIHy2mqWiDzNf2NSNXGPRyFBdbZvtVhGi7dK6xi31COCh8ilk5CfDB1jL99cDxSv+6EMhNW6f59chz6eEXSNKFSC9x7YaJ4EmX3qq4Eq06Be29zWZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/3/26 15:31, Baoquan He wrote:
> On 09/03/26 at 03:05pm, Wandun wrote:
>>
>>
>> On 9/2/26 16:53, Baoquan He wrote:
>>> Hi Wandun,
>>>
>>> On 09/02/26 at 03:31pm, Wandun Chen wrote:
>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>
>>>> On SoCs that carve out large firmware-owned reserved memory (GPU,
>>>> camera ISP, ...), kdump currently dumps those carveouts as part of
>>>> system RAM even though their contents are firmware state that is not
>>>> useful for kernel crash analysis.
>>>>
>>>> This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
>>>> reserved memory on DT-based architectures (arm64, riscv, loongarch).
>>>> Reserved regions default are marked MEMBLOCK_NODUMP so kdump omits them;
>>>> reusable CMA regions are different because their pages are handed back
>>>> to the buddy allocator and may carry crash-relevant data.
>>>>
>>>> ACPI systems already filter reserved memory out of the vmcore through
>>>> their existing path; only DT-based systems currently fail to filter these
>>>> regions, which is what this series addresses. The flag lives in memblock
>>>> itself rather than in a DT-only structure, so the mechanism is generic and
>>>> both ACPI and DT systems can benefit from it (suggested by Rob, thanks) [1].
>>>
>>> Thanks for the effort. I am not against this patchset, and I haven't
>>> went through it carefully. Just from the cover letter, you mentioned
>>> generic, I am wondering if this can be generic for excluding other
>>> memory regions. Asking this because I try to find a way to exclude
>>> unwanted memory regions too, please check below link where there's
>>> the relevant discussion. We definitely don't like inventing wheels
>>> time after time. Do you think this memblock region excluding can
>>> be used in other places of kernel?
>>>
>>> https://lore.kernel.org/all/aoLFai0gzzH2bGgy@MiWiFi-R3L-srv/T/#u
>>
>>
>> Thanks for taking a look, and for the pointer to the crash-wipe thread.
>>
>> To answer your question directly: the exclusion mechanism in this series
>> is already generic, memblock_mark_nodump() is the entry point. Any code
>> that wants a region out of the vmcore just marks it MEMBLOCK_NODUMP, when
>> preparing vmcore elf header by walking memblock, these regionss are skipped;
>> This series is simply one caller, marking the DTS /reserved-memory and
>> /memreserve/ regions with MEMBLOCK_NODUMP.
> 
> Thanks, for memory not allocated from memblock, e.g buddy, is it still
> good?

Yes, still good, only need to pass the physical range to memblock_mark_nodump().

> 
>>
>> x86 currently builds the vmcore elf header from iomem_resource, not
>> memblock; it could be switched to memblock, but that would bring no
>> benefit for the problem this series solves, so this series makes no
>> x86 change. I'd personally be in favor of switching to memblock for
>> a unified implementation across architectures.
>>
>> Best regards
>> Wandun
>>
>>
>>>
>>>>
>>>> Since the reserved memory regions are filtered out, the vmcore is
>>>> smaller in size and faster to produce. 
>>>>
>>>> The series is based on linux-next and is organized as follows:
>>>>
>>>> Patches 1-4: Preparation and bugfixes: fix the missing HugeTLB
>>>>              flagname, switch riscv crash_mem to memblock, fold the
>>>>              duplicated per-arch memblock walks into the weak
>>>>              defaults, and serialize crash header preparation against
>>>>              memory hotplug.
>>>> Patches 5-9: NODUMP infrastructure: switch crash_core to
>>>>              for_each_mem_region(), introduce the MEMBLOCK_NODUMP
>>>>              flag, add a dumpable flag to struct reserved_mem, and
>>>>              mark /reserved-memory and /memreserve/ entries with
>>>> 	     MEMBLOCK_NODUMP flag.
>>>> Patch 10:    Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
>>>>              header.
>>>>
>>>> In v5, Sashiko found some pre-existing issues related to reserved-memory,
>>>> and has no dependency on this series, so these issues have been addressed
>>>> in a separate series [2].
>>>>
>>>> v5 --> v6:
>>>> 1. Serialize crash header preparation against memory hotplug to avoid
>>>>    out-of-bounds or use-after-free issues.
>>>>
>>>> 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
>>>>    avoiding a panic from too few regions before resize is permitted.
>>>>
>>>> 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
>>>>
>>>>
>>>> v4 --> v5:
>>>> 1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
>>>>    (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
>>>>    DT-only struct reserved_mem.
>>>> 2. Switch the riscv vmcore elf header preparation to use memblock
>>>>    instead of the resource tree, aligning it with arm64 and loongarch,
>>>>    so riscv also can exclude reserved memory from vmcore.
>>>> 3. Deduplicate the vmcore elf header preparation: arm64, riscv and
>>>>    loongarch open-coded the same logic, so fold it into shared
>>>>     __weak defaults in crash_core.
>>>> 4.  Drop the v4 patch that saved /memreserve/ entries into the
>>>>     reserved_mem array; /memreserve/ is now marked MEMBLOCK_NODUMP
>>>>     directly.
>>>>
>>>> v3 --> v4:
>>>> 1. Rebase this series on v7.2-rc1.
>>>> 2. Add two cleanup patches (patch 02/03).
>>>> 3. Simplify patch 03 to avoid checking whether initial_boot_params is
>>>>    NULL multiple times, suggested by Rob.
>>>>
>>>> v2 --> v3:
>>>> 1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.
>>>> 2. Fix UAF issue when alloc_reserved_mem_array() fails.
>>>> 3. Add some prepare patches.
>>>>
>>>> v1 --> v2:
>>>> 1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
>>>>    feedback [3], v2 drop that property and exclude reserve memory
>>>>    by default.
>>>> 2. Split some prepared patches from the original patches.
>>>> 3. Address coding-style comments on patch 5 from Rob.
>>>>
>>>> [1] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
>>>> [2] https://lore.kernel.org/lkml/20260818092420.2859026-1-chenwandun1@gmail.com/
>>>> [3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
>>>>
>>>> Meijing Zhao (1):
>>>>   mm: memblock: add missing HugeTLB flag name
>>>>
>>>> Wandun Chen (9):
>>>>   riscv: build crash_mem ranges from memblock instead of resource tree
>>>>   crash_core: fold duplicated memblock arch hooks into the weak default
>>>>   crash_core: serialize crash header preparation against hotplug
>>>>   crash_core: replace for_each_mem_range() with for_each_mem_region()
>>>>   memblock: introduce MEMBLOCK_NODUMP flag
>>>>   of: reserved_mem: add dumpable flag to opt-in vmcore
>>>>   of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
>>>>   of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
>>>>   crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
>>>>     header
>>>>
>>>>  arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
>>>>  arch/loongarch/kernel/machine_kexec_file.c | 27 ------------
>>>>  arch/riscv/Kconfig                         |  2 +-
>>>>  arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
>>>>  arch/x86/kernel/crash.c                    |  2 +-
>>>>  drivers/of/fdt.c                           |  2 +
>>>>  drivers/of/of_private.h                    |  2 +
>>>>  drivers/of/of_reserved_mem.c               | 48 ++++++++++++++++++++
>>>>  include/linux/crash_core.h                 |  2 +
>>>>  include/linux/memblock.h                   |  9 ++++
>>>>  include/linux/of_reserved_mem.h            |  1 +
>>>>  kernel/crash_core.c                        | 51 ++++++++++++++++++++--
>>>>  kernel/dma/contiguous.c                    |  1 +
>>>>  mm/memblock.c                              | 17 ++++++++
>>>>  14 files changed, 131 insertions(+), 95 deletions(-)
>>>>
>>>> -- 
>>>> 2.43.0
>>>>
>>


