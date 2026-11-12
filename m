Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 674F6606A884
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 08:12:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=j78MidLF
Received: by kanga.kvack.org (Postfix)
	id 7EE726B05B0; Thu, 12 Nov 2026 03:12:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79F6B6B05B7; Thu, 12 Nov 2026 03:12:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 68E046B05B8; Thu, 12 Nov 2026 03:12:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 42E616B05B0
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 03:12:39 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AF5E80416
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:12:38 +0000 (UTC)
X-FDA: 85425750396.17.AED1EC9
Received: from mail-pi2-f6.google.com (mail-pi2-f6.google.com [74.125.227.198])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2B08F8000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 08:12:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=j78MidLF;
	spf=pass (imf30.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.198 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794471156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4Usv198qCvT1xdnr9OKW5ZLVCsGku8RkLVQlQ2znC0=;
	b=HNmr3Q3UAED45ACSy4q6F0wSeB2cDjsRREmjT/gEgn6WVEPx/Cz7FtSoqqdq16Xqpmx1PO
	8YucP9YSoC3QQ5PylXzsH9ViTDpiZ5uLuUP9xbVW+NBUgqUDCqCpzxE7z/nZP+4ZcAeAPZ
	qSqnCm9bK1Tgbl/a716TSCkcFxBx9Gw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794471156;
	b=Ky74bSAITXEl7RRhqwnNMZ31LAsUdUCDgYa/lzsWk0NgbzmIxbtc7mSmshq26stNqWp3YK
	iHEzytf3rr2Qv/uNGJ/KkhM28kSeULOzyAJUaK2ZtmUkabeU2mXr4tMK9QbfHARLyP3cLW
	sNkYSGVT3AM7uW++bqny6z9S+OvzrX4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=j78MidLF;
	spf=pass (imf30.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.198 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pi2-f6.google.com with SMTP id 41be03b00d2f7-cdb536daf59so2064001a12.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:12:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794471155; x=1795075955; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=i4Usv198qCvT1xdnr9OKW5ZLVCsGku8RkLVQlQ2znC0=;
        b=j78MidLFnns/7M2DyG5gyHldsvVM6nsGuFjP70xhfDbxdARRvEMLAW88woz/io6uV9
         /zRizCNhWcksVbJJ1UtQHAriEwMmRCpd27gJA7xlF3dFFyR8s70Gc1b50BryQL6f71bW
         1RCZ5Nq602uvrN46LWVDokcVsqnqzTYlUYGFcBXfJ0FWRYemWfa9+ZzxVqVk1lWnSU3v
         WCy15Qqwy3ZJ6U9nZwuBCUu09EoDgjcKOjvFyRHJX/m8faqciRGyeIvBy8YF905WrF3r
         aI1vEBA3qBTXRXBl72jGpGTZNUlKq1hX71znMXS7ejqBwzp5HUeARQJVXLAdubQ4f3kg
         dH7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794471155; x=1795075955;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=i4Usv198qCvT1xdnr9OKW5ZLVCsGku8RkLVQlQ2znC0=;
        b=xc8irT/7HWkwUeZali7QWu/rmMlx169/Mx0ZOQdAakqtujiC/jyRZRrn5CCfg5+/Ta
         osBcxwaqYdjNpCe7EiYnXfv3eCuT4wrhgxfnQX7/uYOpBY+H0Pk2qA9eMB66+yxFsMLC
         gxv0s5dMzwlmRlkM4iWNze6Dxcp2n+9GCzV6CI6vFE/eFdeB+WKwZC+c0MITDo3AmT2d
         +k53G/U1GWrL7Bz+KQAZs84VYad5/mAd8TPkhcer6ErY9PA4pNY/3JIPDEAlP3bUflG8
         gHS2cCj6Frq2rS2s0+AdJtb2GpuOvFcLt0STFsIXwo7RluE/jfO0EvtAHRCifHFHfgZr
         DY1g==
X-Forwarded-Encrypted: i=1; AL+hErFwcQG3Dfn6i3hgOPxXssEJ3scDoxRKq7/fWdJLpytfLUCFmCHf7zdA0eZJE/PwGS+NTTU4L/GlfQ==@kvack.org
X-Gm-Message-State: APuU4Z/hpB8xDL7KYx9kHrJBv2lL6thqdSW8TiSKpVSpu8atNqRKDVjs
	idHFIVTfa+UUT0Fhq+966z01SNqaub3fJYDd78PS8PGPqNrv2U43YUTS
X-Gm-Gg: AYBFou0FrK/lB6B/AKCssfvvgWzrGEGPKbvmQjvTt44CoSD4HL8R3zz1qXKEUnLqOjd
	sYMoYgnYbUY6WPAkIqShfem0fGC+LXmDWeMusPhY13+xi28wij6XifTh7phuXP6+V52tti+9Whd
	LcQAS7YVscF8Q6LoJjW1lxgXyIfvO+U7SH6bo4pXehWm5LsC0IICQbcpBZhn4LaR3Wb+q/lQtwf
	QhhTWWvtURa+RlmnrZ2WvHxESgPTKsDzKYaB8A3o8cYKXNd/OFwK+HrxaYPUDcJb8A4tpHBOyvR
	hiWu7l3Rh/7vg6eecuQWp5Kr6Ex/hNkgH2JvgsghCAinyPSPtlrdYGaVC+CuNwOGu+etHrAuQBo
	Jsw7QRCaEvID5RdGKBKYWb1bWKtAnGso/8/V1JTz846fV7mPbIYr04XGn2OKC9XpVPaEC+Or96T
	kL0SIhlkdCgvV871PD3gWCnoMssYnoWDl+sdjo7VV0gGPEx80793MBCdOlit/Oc4pO5soWAnMY3
	ieQKiHyQ5RkvLw6UneZUYRbN1EW22FmlrxLKPJF9mepyziU/8ymP8D9N3eiVKvLrqf9rI/fse2H
	e3+beH4E4r9B8ZKqvZvltPxGUS48FTwXnf6whg==
X-Received: by 2002:a05:6a00:1893:b0:89e:37b0:d1bc with SMTP id d2e1a72fcca58-8bc1cd62e03mr5111050b3a.28.1794471154695;
        Thu, 12 Nov 2026 00:12:34 -0800 (PST)
Received: from [10.125.112.22] ([122.11.210.25])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8baa7de3eecsm3105447b3a.1.2026.11.12.00.12.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Nov 2026 00:12:33 -0800 (PST)
Message-ID: <210ff30c-17a1-4bd1-b943-34a1d0688e43@gmail.com>
Date: Thu, 12 Nov 2026 16:12:18 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 0/8] kdump: reduce vmcore size and capture time
To: Mike Rapoport <rppt@kernel.org>, pjw@kernel.org, palmer@dabbelt.com,
 aou@eecs.berkeley.edu
Cc: robh@kernel.org, baoquan.he@linux.dev, m.szyprowski@samsung.com,
 catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com,
 chenhuacai@kernel.org, kernel@xen0n.name, alex@ghiti.fr, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
 hpa@zytor.com, saravanak@kernel.org, akpm@linux-foundation.org,
 pasha.tatashin@soleen.com, pratyush@kernel.org, ruirui.yang@linux.dev,
 robin.murphy@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, loongarch@lists.linux.dev,
 linux-riscv@lists.infradead.org, devicetree@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, iommu@lists.linux.dev
References: <20261021083011.2170525-1-chenwandun1@gmail.com>
 <7773d026-4aef-4169-866a-71ec9a91da21@gmail.com>
 <avLaJxIrrnMQngO9@kernel.org>
Content-Language: en-US
From: Wandun <chenwandun1@gmail.com>
In-Reply-To: <avLaJxIrrnMQngO9@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: nyfxi1tfdaqedfy8gcta7mjzsfrtw4kj
X-Rspamd-Queue-Id: 2B08F8000A
X-Rspam-User: 
X-HE-Tag: 1794471156-888994
X-HE-Meta: U2FsdGVkX1+1RS+Y0/2bLfGjiYvBGRhvJq8g5hB4wVLVDg57YVcF7eOOEbBibS1ikWHMuwC2k7Fff+P5o0J/f3rtmbWp6Cmerco9NraIxTVjcuRmNmmSkr9WvzPSAR6QneZK00xhNfxBlxgVTAc3T2SXOy4QHH9MYRlvwy49OMBSvFrZxj6Rq3U08vXSPkLyiNjCWoCEKOkWCBbIO18ea0MKS6QJ7bae2OzyUn6WzvVmnm1+zrDAoYfx4V4wMyLBnwq8Sk2Qj2lB7v9Elr8FpiHYRB25lMgK4AckJEqdAAogr4cfCGlxjOgKfvCl75KT+9jf/j04LchWu7xubWBzEdXIgu+hJQH8XKC4qtKabyYN36nScR6eGWUf8C+mjUJNY0fy0+Xl68pjRKPPNlPWUcWl0QugcncjhARC80ZMEgn9/+ja+nbPW3MqmniEg7MfYVG1Y0mCEKxUE/AdxZGIyVE28E7v/eMYICBtRucuvYkZlcV7DD+sYTIb0aPGK480Jc6mMC0SBrbfd04LUby02NiNusN32ITbmAtsfowzZg2jiN0TFuTQYO3kC11LgRaKngkUdtLr5wM36UdaZGDcI91LTIaCEKLWOBfHAGYaXK8hxNCNszLO88w0zotfRfpzmNuFnpqlp9Bd5QHbPfl0fFhrv6d6qA7ozOtlv3y0mjCEAzzMGJUvE+uNQYVXZtimr9ZO4RSBksLEkjWSaZUXJJwLNVYqYVDrV3dZbQfHPE9GjlhP0FoCARKZuU7LZbWM3Ibi2I+Nky33v3mWcBONENG/3rclYgRjZUNDxiJXT2+l2nC3h1iQP3AsrSPwC7qLbdw8H9hkUGWMArn5OayVCUq0SF5io/mW53jncYuckOrMGdSR+L7KTLWrq63sPR7UqM3vdteCW2Fzr3MZ1wXco5QamD+0+dZ8/gE4NgtuyeENGXOsZLaXHmhSmPyrR4+/N60rla3bZ4Vg0c+VPLD
 SU3U8dhB
 B3uDjWrEJnq5d48iqZC8s3mC32bELLHTLKiKN4WKaty5PH/G26Ykcu2oYQsWp5MIHE/MWyN/Lap5A5Nla221pswGSj2plfcrseTMgQgHMMdvsOg4899E9qHeOfkC/vIFyje8R0N95MAqVjSYdukkzKzIvB3gd/yfcPyoD/ZGr9n5BHuv/FKyf4f0SVqXHEyg0mTXWS6n2Ng4N3IX9sXzQ+PCsMIKcSKPL3akwBgttw2GZPcHgdRi1guMPEqJl53XPsTLge+vONJ/QASG3xe5UG5sjlGv8V0rlNh0UXrruHUhJaObgI+06G+IoHMNdUh95UQAdJtSkIyp1FwoxEAMv5MgEj4YtqX1jFd9ctb7HSuzrjRYKbVAjOlYgYp53X3Md2Qm0UVlgSfeVzOLWwJF4FdUHB58KeEMAVnd5dsai1nTBhdtIgVKXMswFUTF7Tvb2S7PNOxaW1njNgecFnnLWA2a7fV6En8VF9GesISONaoXHPH3fPgtCGcZstoTjcVStgjLBst1xofjLBqDFiHwAoVSdfDji9N1+LXDHFBjaukwLNi52Pns91hlJreda9UARFaQW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On 11/10/26 16:47, Mike Rapoport wrote:
> Hi Wandun,
> 
> On Mon, Nov 09, 2026 at 08:23:16PM +0800, Wandun wrote:
>>
>> On 10/21/26 16:30, Wandun Chen wrote:
>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>
>>> On SoCs that carve out large firmware-owned reserved memory (GPU,
>>> camera ISP, ...), kdump currently dumps those carveouts as part of
>>> system RAM even though their contents are firmware state that is not
>>> useful for kernel crash analysis.
>>>
>>> ACPI systems already filter reserved memory out of the vmcore through
>>> their existing path: firmware reports those carveouts as unusable in
>>> the EFI memory map, they get MEMBLOCK_NOMAP set in memblock.memory
>>> (is_usable_memory(), efi-init.c), and the ELF header builder has
>>> always skipped nomap regions; only DT-based systems currently fail
>>> to filter these regions, which is what this series addresses.
>>>
>>> This series introduces a MEMBLOCK_NODUMP flag (suggested by Rob) in
>>> memblock to filter reserved memory on DT-based architectures. A new
>>> flag is needed because MEMBLOCK_NOMAP can only express regions without
>>> a linear mapping, while MEMBLOCK_NODUMP can filter regions that are
>>> linearly mapped. Reserved regions are marked MEMBLOCK_NODUMP by default
>>> so kdump omits them; reusable CMA regions are different because their
>>> pages are handed back to the buddy allocator and may carry crash-relevant
>>> data.
>>>
>>> Since the reserved memory regions are filtered out, the vmcore is
>>> smaller in size and faster to produce.
>>>
>>> The series is based on linux-next and is organized as follows:
>>>
>>> Patches 1-3: Preparation and bugfixes: switch riscv crash_mem to
>>>              memblock, fold the duplicated per-arch memblock walks
>>>              into the weak defaults, and serialize crash header
>>>              preparation against memory hotplug.
>>> Patches 4-7: NODUMP infrastructure: switch crash_core to
>>>              for_each_mem_region(), introduce the MEMBLOCK_NODUMP
>>>              flag, add a dumpable flag to struct reserved_mem, and
>>>              mark /reserved-memory entries with MEMBLOCK_NODUMP.
>>> Patch 8:     Skip MEMBLOCK_NODUMP regions when building the vmcore
>>>              ELF header.
>>
>> Hi all,
>>
>> A gentle ping on this series.
>>
>> I'd appreciate any further feedback, particularly on the
>> MEMBLOCK_NODUMP discussion and the issues raised in the Sashiko
>> review.
> 
> I'm fine with MEMBLOCK_NODUMP.
> The issue Sashiko raised about bound check against cmem->max_nr_ranges
> seems valid. 

Hi Mike,

Thanks a lot for the review.

Some analysis and plan about "bound check against cmem->max_nr_ranges":

After patch 3, the remaining race is x86-specific. The weak defaults are
safe: every runtime modification of memblock.memory, hot-add and hot-remove
alike, happens under device_hotplug_lock, so with the lock held the count
and populate passes walk a stable snapshot.

x86 instead walks iomem_resource, and Xen balloon inserts its new System RAM
resource before taking device_hotplug_lock() (reserve_additional_memory),
which is the one remaining hole.

The issue is also pre-existing: before patch 3 there was no locking at all,
every hotplug path could race the two passes.

The proper fix is to switch x86 over to the memblock-based weak defaults,
as patch 2 already did for arm64/loongarch/riscv. Would you prefer to have
it in this series, or as a separate follow-up? Both work fine for me.

> 
> I didn't check the reserved mem one.

The two Sashiko findings on the reserved-mem (patch 7) will also be addressed
in next version.

>  
>> Please let me know if there are any other concerns or suggestions
>> before I prepare the next revision.
> 
> I believe that should be rebased to account for reserved memory changes.

Sure, the next verison will be rebased on latest linux-next.

> The riscv change from resources to memblock needs an Ack from riscv
> maintainers.

Hi Paul, Palmer, Albert,

Patch 1 builds the crash_mem ranges for the vmcore ELF header from
memblock instead of the resource tree, so the later MEMBLOCK_NODUMP
patches can filter reserved memory from the vmcore on the memblock
side. With this, the vmcore size reduction the series brings also
applies to riscv.

Could you take a look when you have a chance?


Best regards,
Wandun

> 
> And with all that I can take the next version via kexec tree.
>  
>> Thanks,
>> Wandun
>>
>>>
>>> v8 --> v9:
>>> 1. Patch 7: Avoid a potential boot panic on SH when NODUMP marking requires
>>>    memblock resizing before it is allowed, found by Sashiko in [1]. SH supports
>>>    neither CONFIG_KEXEC_FILE nor CONFIG_CRASH_HOTPLUG, so skip marking when
>>>    both are disabled.
>>>
>>> v6 --> v8 (v7 mainly tried to fix the initrd issue on release in v6,
>>> that approach is superseded here):
>>> 1. Stop marking /memreserve/ regions with NODUMP. v6 marked
>>>    /memreserve/ regions with NODUMP. But a bootloader may specify
>>>    a /memreserve/ entry for memory that the kernel later frees
>>>    (e.g. the initrd), and those pages would then be wrongly
>>>    filtered out of the vmcore after being reused as normal memory.
>>>    The v7 fix (clearing the flag in free_reserved_area()) caused
>>>    a lockless runtime mutation of memblock.memory [2]. Better solutions
>>>    exist but need extra preparation, so temporarily dropped the patch
>>>    that introduced the problem to keep this series simple in v8.
>>> 2. Fix a build failure in patch 2 with both ARCH_KEEP_MEMBLOCK and
>>>    MEMORY_HOTPLUG are unset. There the memblock arrays live in
>>>    .init.data, and the weak defaults referencing them create section
>>>    mismatches, which turn into build errors when SECTION_MISMATCH_WARN_ONLY
>>>    is also unset.
>>> 3. RISCV recently gained crash hotplug support, so adapt its handler
>>>    like x86 in patch 3: use __crash_prepare_headers() instead of
>>>    crash_prepare_headers() to avoid self-deadlock.
>>> 4. Update the cover letter per review feedback: describe how ACPI
>>>    systems filter reserved memory and why a new flag is needed
>>>    instead of reusing NOMAP.
>>>
>>> v6 --> v7:
>>> 1. Fix a stale MEMBLOCK_NODUMP flag issue [3]. Memory reserved and
>>>    marked as NODUMP may later be freed (the initrd, for example),
>>>    so the NODUMP flag must be cleared accordingly. Since the fix is
>>>    part of the NODUMP infrastructure introduced by patch 5, it has
>>>    been folded into that patch.
>>> 2. Drop the "generic" related description in the cover letter.
>>> 3. Collect the Acked-by and Reviewed-by tags received during the v6
>>>    review (thanks to Baoquan, Mike, Rob and Marek). Patch 5 is the
>>>    only one without a tag, as its Reviewed-by was dropped when the
>>>    fix was folded in.
>>> 4. Drop patch 1 of v6, which has been merged separately.
>>>
>>>
>>> v5 --> v6:
>>> 1. Serialize crash header preparation against memory hotplug to avoid
>>>    out-of-bounds or use-after-free issues.
>>> 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
>>>    avoiding a panic from too few regions before resize is permitted.
>>> 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
>>>
>>> [1] https://sashiko.dev/#/patchset/20261016061549.4181390-1-chenwandun1@gmail.com?part=7
>>> [2] https://lore.kernel.org/lkml/20260922090252.B01541F000FF@smtp.kernel.org/
>>> [3] https://sashiko.dev/#/message/20260917220750.GA4013814-robh%40kernel.org
>>>
>>> v5: https://lore.kernel.org/lkml/20260806093519.2907771-1-chenwandun1@gmail.com/
>>> v4: https://lore.kernel.org/lkml/20260630074715.4126796-1-chenwandun1@gmail.com/
>>>
>>> Wandun Chen (8):
>>>   riscv: build crash_mem ranges from memblock instead of resource tree
>>>   crash_core: fold duplicated memblock arch hooks into the weak default
>>>   crash_core: serialize crash header preparation against hotplug
>>>   crash_core: replace for_each_mem_range() with for_each_mem_region()
>>>   memblock: introduce MEMBLOCK_NODUMP flag
>>>   of: reserved_mem: add dumpable flag to opt-in vmcore
>>>   of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
>>>   crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
>>>     header
>>>
>>>  arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
>>>  arch/loongarch/kernel/machine_kexec_file.c | 27 -----------
>>>  arch/riscv/Kconfig                         |  2 +-
>>>  arch/riscv/kernel/crash.c                  |  2 +-
>>>  arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
>>>  arch/x86/kernel/crash.c                    |  2 +-
>>>  drivers/of/fdt.c                           |  1 +
>>>  drivers/of/of_private.h                    |  1 +
>>>  drivers/of/of_reserved_mem.c               | 18 ++++++++
>>>  include/linux/crash_core.h                 |  2 +
>>>  include/linux/memblock.h                   |  9 ++++
>>>  include/linux/of_reserved_mem.h            |  1 +
>>>  kernel/crash_core.c                        | 53 +++++++++++++++++++++-
>>>  kernel/dma/contiguous.c                    |  1 +
>>>  mm/memblock.c                              | 16 +++++++
>>>  15 files changed, 103 insertions(+), 94 deletions(-)
>>>
>>
> 


