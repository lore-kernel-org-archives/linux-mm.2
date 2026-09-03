Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61CC7C61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 07:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 772036B008C; Thu,  3 Sep 2026 03:06:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722306B0092; Thu,  3 Sep 2026 03:06:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 638F86B0095; Thu,  3 Sep 2026 03:06:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 413136B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 03:06:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1794120450
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:06:00 +0000 (UTC)
X-FDA: 85171566480.09.6C73588
Received: from mail-pj2-f11.google.com (mail-pj2-f11.google.com [74.125.227.139])
	by imf15.hostedemail.com (Postfix) with ESMTP id B92E8A000C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 07:05:58 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZukU/4gI";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788419158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bPr0Tiyi9ufsaoMkecG9LBvmdZ8IsvdK2aRx8FqQP84=;
	b=Sm7WHB2cD9h82b+XT90Jsk0nqvHcCtBqVcJSlNETQ9YsDSWYCigL5GuYu1qPKFFojul6qB
	lW/4xxjKjBARdg5FwBWgvVXRL61vGgLnRJhe7ZTMHggJDQmUIOsDOunYKeyIbKnTWPER1E
	6rZ6x4x6EUhByxVK1diT3+IGLgGm3vs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="ZukU/4gI";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.139 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788419158;
	b=fNSR9h1WvTv0J2wJ3mplcUSdjfM6DCm2VvdOeMuT9sacGLHIIIICHV+pj8aj/8pBkvngL8
	MWFGHbTpwepOyylJgoRl1aQ5HHQ70UTCZ+ImMBot9K6oHn3acxetYiUhcTlTlhetXoEmEa
	Pe2xZ+x/oNLpcJ3ObWDW/rUGGXUinJc=
Received: by mail-pj2-f11.google.com with SMTP id 98e67ed59e1d1-38de693676dso1208045a91.0
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 00:05:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788419157; x=1789023957; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bPr0Tiyi9ufsaoMkecG9LBvmdZ8IsvdK2aRx8FqQP84=;
        b=ZukU/4gIwlyMMVLgmgWwCtKhJx3M4tSi3vj0AFvvhkkKRxTTt/eV83QA888NyLfjRI
         ENlulY8UPFol+1d23j6aW5r68jhL+AwbxrRhak8KxbXAQZMsAekudsJ2eoZhjj/sdD+O
         bgAn056zEdzcN/OdfX8ME64cWho4mTuuEz9s+DjXdErDfnYrFHFskTxg9mcmMf2x0vNw
         +ihhkTSEDdFd3FHOXZv9g25ZqIPIWmxi1yxrZuCzvr/xhMs6fR9+2BfZCyJIHOg7G1Ov
         G/ymC0nH6kvlDLdLEMqAZRV5kJikS553WH0n7F3xGwmpJTO4SqNspF63eIQfpkMhg9xo
         u0bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788419157; x=1789023957;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bPr0Tiyi9ufsaoMkecG9LBvmdZ8IsvdK2aRx8FqQP84=;
        b=DfjZ293seP8W1kwhEMzcH8KS/e8G9goxAASYiTfnlOxY3Sn+GSuEkEt6Xgp51AkgrE
         PCm8TUiX3S7mZjWW6mP9+qaM1aJ8Tt2AJ6n7niPWOCvqviw4OOXQjHtXbp2oR9xUGj5Y
         LsVEZXg/GZ7WcVbafC+HwTnVDx5x5n/k3sz5RJAL08nRNFDZxFr9EvIDHfGXYz4PvNct
         Ei//60koc3ihNecJsXqK4KFepDB7RiNjkT9ZCFUB9pcRzzIxNwEABb7NBlMI7JpgegbI
         aXf6htVw0EE6+kB3t7M7FfwUVxIASYXUbBMzsyb2zReddpy8Gew33WWyIyy+qi3AiP8M
         bdKQ==
X-Forwarded-Encrypted: i=1; AKwUvBwvf6vOg+/1MoD8QzzF4U2hjNJ8IShneWk3QQsdPWr3Bq4K0re3l7Y/x/UWvoDyom4qQq/KgZEg8A==@kvack.org
X-Gm-Message-State: AFuF++mSWEWXvIcaRkIzl4xmtsQ2N/hgymiv5sFMAGdmXNbw9Rlg2mfB
	8Qtbcnu3aE2jzfDU9G+bhi9UC5jaXFSU7bv5BUrJ3uyj75DQQblZu29z
X-Gm-Gg: AYBFou2pSRL8Yl15lLzJ0r1+SZo5hAqM/Xt/vk17mlfuDfDytNo6uctNzpjyg1gl+x5
	YLL4qHNLdQGRFLz6iLWMdBmcQ8BO2ZCZfPxdFhzNm8j07YgRv0gokG1bimljhXBjwmE5GO9ZsLG
	bBPNSgUFtHckRbBlG/sPRDKm0Ib8K7XG8vl57FCbIKoDrNCYC+n196KO7AaKLBJQ6/X+1GxKzXm
	5mikKFlWdke4mvq67pIX1i1tYxOjuabpnF/KzL8vt1VQhco4qD1AJvGOsIOmjE30OoGtCc7bewS
	FPtaqeLmyo/+9fxyX9A6lie0qjPcc0wG0znZFGAgSTC3NN2oKMNa3ZnKmNpNiNl440HSlqxkeEE
	o+G6u5yYfZ+mCek2EJk5TWy2hJ31zmZTN/Wmj96TVPB/rU/sp8FvLhp+a4/VCsQZGDIZtjHK6lB
	+pfTF2LyFVUwMBxKNPOCoCMQumBysmxm6Md8TjnnWLxRoN4aCe2ZkIWmeRt7tz/Pk06DMtzOHCw
	YjItPs=
X-Received: by 2002:a17:90b:2b46:b0:39a:e002:f192 with SMTP id 98e67ed59e1d1-39aee26d6c3mr16239819a91.22.1788419157335;
        Thu, 03 Sep 2026 00:05:57 -0700 (PDT)
Received: from [10.125.112.20] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b07b197a9sm3382844a91.0.2026.09.03.00.05.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Sep 2026 00:05:56 -0700 (PDT)
Message-ID: <6aef2f48-1cc5-408d-a5a2-2b4b4d45ad7b@gmail.com>
Date: Thu, 3 Sep 2026 15:05:44 +0800
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
 <apfkDlcMYrgiuGYA@fedora>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <apfkDlcMYrgiuGYA@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: nmopeumbzkcq9zud4mwhqbqro4xw559s
X-Rspamd-Queue-Id: B92E8A000C
X-HE-Tag: 1788419158-287296
X-HE-Meta: U2FsdGVkX1+G7C79ZcJDOTds632Gl/H6obdmW7YulqK9YmqF5OABxMyZGZDbDxwAEPHi9o5TO6jtEanYfo+c0ttKCcaksb6askQJr/V6T25uAM4TihHkWbB1nIZW/U2NFNg0gV+iTqDvTRll78x44K5b5sb1R+5VEqPEBvmTioqG3jyZC04CG9wgWvMaQxzSKfg2NbP++ByZKgtkxWgOxjX/HYgLKKrMwJJO5v2fk5KfxmETAL6nd1/J/dEF47/ckuSPNjnvspeLUKqmHOe8Zrl1+VkaROHUjfOmgurxkT8OFSMUlsYbE2JzcPFOhwezdbn+0ZiCgx/YmfAg0vpJ1ortvhGtEu6lMCLYWB0lKygV+2B3D/ywvwBYbMAYIZDqdeZktdAx8RVsBHFzuAv2I890p/hKJIIAb6zJ4PgcxCgjChaGLU2K5LZsGS/KdBsDUMcfA93Q1/+jcsu1c2T14WY0RpoxTc9AEgM/5/uAneQJVP1gKw29EGTdTWGIV+yWELwkTOyRVlotYTrUDpCQvy7yIcuoC91OOoZfAYvJir1z8Mkhe0yKS9dcpjkYZoCtt2rq5OinuRhJDdQguHgWNDkcuADLh8ZYRIENj1/zKU//BBOxkHfXVe8eKnybXT/FLcBjjzSE8lCz8IEdGAm98V6/vzvW/aqszcITx1aMxL1067WiBowSaBXyVWiUNeVscxfzsGz/1qev3Gs/PYX10Emw0Wx9TMeOwI/yH7F1tsL2fUkhPwG5PQ+JR+nvzjxMIO1gXxLBj1wC2Z8HjEBJvKmGyQm422FNwVbb/+glGrMEsgP5HwOlMGKlzsg4eHO5bIz+svLQMjXG5GLJneLpvBNoU9jhjlyfjQ558cbdEHdXEk4N0JeLvd1xVhqWGTg3OsCW5fzdliynzv/5OGlH3DWiOvQJ/Q9iw06X9LBFHqVyo1ut9YYt/MhwNdp6URo3/6IcnyWZJY4GPe9FmXS
 lHhPJzRz
 A7ePoa/jJEB6BYGlMy4L3X+ZTtJPt2YnonOOFBAx+mAQrEA8CC3S8fCJzSYKgAqE9dQl2WvWYXjGm8lEIpmsz/03fLay1k7vWiuPvIrRU7RmbV3pvUPSGenwOKmrS39aWmuAEZfdWGi5z4ADKiMCft0ZcuFGXHNxcQywS5W9oMs51yBoKB6xF8L9r5bcMlumovgPCA0OjH0SE11DhWqL7lSMTT5ws8BAvl63EAVT7qUlPQ/KVj6slmMBytW1UdVZpUePwjCKsAnbSgNvIGMgAzm3fBCK6Wuy+mBY6OsEnxHE2pQ1cc9mk8FOrjAGMWTaXqfbU1TkyU2YhVYZGwBZJkzTlRrHC1lG+PrF4xn1yMrcd9l+1rgz4LeM1Mk3mqafpicfsnQAsZSao0Wj41h4xkqlD/a0oaNgzYArGODJT46vObkhYgRnRqKNVDlNm1HBxhtR+Y8LDWWgo0yQxhI9YVusd8xvZLhWCaL6siOcdXUVgh3ulTG+NxazIsQttfweqa8yK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/2/26 16:53, Baoquan He wrote:
> Hi Wandun,
> 
> On 09/02/26 at 03:31pm, Wandun Chen wrote:
>> From: Wandun Chen <chenwandun@lixiang.com>
>>
>> On SoCs that carve out large firmware-owned reserved memory (GPU,
>> camera ISP, ...), kdump currently dumps those carveouts as part of
>> system RAM even though their contents are firmware state that is not
>> useful for kernel crash analysis.
>>
>> This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
>> reserved memory on DT-based architectures (arm64, riscv, loongarch).
>> Reserved regions default are marked MEMBLOCK_NODUMP so kdump omits them;
>> reusable CMA regions are different because their pages are handed back
>> to the buddy allocator and may carry crash-relevant data.
>>
>> ACPI systems already filter reserved memory out of the vmcore through
>> their existing path; only DT-based systems currently fail to filter these
>> regions, which is what this series addresses. The flag lives in memblock
>> itself rather than in a DT-only structure, so the mechanism is generic and
>> both ACPI and DT systems can benefit from it (suggested by Rob, thanks) [1].
> 
> Thanks for the effort. I am not against this patchset, and I haven't
> went through it carefully. Just from the cover letter, you mentioned
> generic, I am wondering if this can be generic for excluding other
> memory regions. Asking this because I try to find a way to exclude
> unwanted memory regions too, please check below link where there's
> the relevant discussion. We definitely don't like inventing wheels
> time after time. Do you think this memblock region excluding can
> be used in other places of kernel?
> 
> https://lore.kernel.org/all/aoLFai0gzzH2bGgy@MiWiFi-R3L-srv/T/#u


Thanks for taking a look, and for the pointer to the crash-wipe thread.

To answer your question directly: the exclusion mechanism in this series
is already generic, memblock_mark_nodump() is the entry point. Any code
that wants a region out of the vmcore just marks it MEMBLOCK_NODUMP, when
preparing vmcore elf header by walking memblock, these regionss are skipped;
This series is simply one caller, marking the DTS /reserved-memory and
/memreserve/ regions with MEMBLOCK_NODUMP.

x86 currently builds the vmcore elf header from iomem_resource, not
memblock; it could be switched to memblock, but that would bring no
benefit for the problem this series solves, so this series makes no
x86 change. I'd personally be in favor of switching to memblock for
a unified implementation across architectures.

Best regards
Wandun


> 
>>
>> Since the reserved memory regions are filtered out, the vmcore is
>> smaller in size and faster to produce. 
>>
>> The series is based on linux-next and is organized as follows:
>>
>> Patches 1-4: Preparation and bugfixes: fix the missing HugeTLB
>>              flagname, switch riscv crash_mem to memblock, fold the
>>              duplicated per-arch memblock walks into the weak
>>              defaults, and serialize crash header preparation against
>>              memory hotplug.
>> Patches 5-9: NODUMP infrastructure: switch crash_core to
>>              for_each_mem_region(), introduce the MEMBLOCK_NODUMP
>>              flag, add a dumpable flag to struct reserved_mem, and
>>              mark /reserved-memory and /memreserve/ entries with
>> 	     MEMBLOCK_NODUMP flag.
>> Patch 10:    Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
>>              header.
>>
>> In v5, Sashiko found some pre-existing issues related to reserved-memory,
>> and has no dependency on this series, so these issues have been addressed
>> in a separate series [2].
>>
>> v5 --> v6:
>> 1. Serialize crash header preparation against memory hotplug to avoid
>>    out-of-bounds or use-after-free issues.
>>
>> 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
>>    avoiding a panic from too few regions before resize is permitted.
>>
>> 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
>>
>>
>> v4 --> v5:
>> 1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
>>    (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
>>    DT-only struct reserved_mem.
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
>> [1] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
>> [2] https://lore.kernel.org/lkml/20260818092420.2859026-1-chenwandun1@gmail.com/
>> [3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
>>
>> Meijing Zhao (1):
>>   mm: memblock: add missing HugeTLB flag name
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
>>  mm/memblock.c                              | 17 ++++++++
>>  14 files changed, 131 insertions(+), 95 deletions(-)
>>
>> -- 
>> 2.43.0
>>


