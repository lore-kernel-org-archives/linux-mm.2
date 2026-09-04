Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30CBFC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 11:09:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 40A4D6B0095; Fri,  4 Sep 2026 07:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BADE6B0096; Fri,  4 Sep 2026 07:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AAFE6B0098; Fri,  4 Sep 2026 07:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 013D86B0095
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 07:09:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B5171A0AF5
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:09:15 +0000 (UTC)
X-FDA: 85175808270.20.AE07932
Received: from mail-pj2-f7.google.com (mail-pj2-f7.google.com [74.125.227.135])
	by imf28.hostedemail.com (Postfix) with ESMTP id B904DC0007
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 11:09:13 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GplS+I9q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788520153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JgjLk2Wj4ezNGWQB3j7DpVIqIrI833hmatUkGCCEbj4=;
	b=FgRIZp+2qU7xQnUOFflOqnYfyYUU1xiAbdwr8Cy5A6qwRO+VQJV1laVQg6x6hN17cbSobO
	q0gr7K0PuruvPWL8DXGqBO61LInbSQcrH1g9I7NlNY/E1ftmh7MfRzQ8Lc+FDs4yB2MlUk
	MexoL3f+5LzdJG5352/IEZyCZOQO4mQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GplS+I9q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.227.135 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788520153;
	b=eTYtY76ls3nqNxZbV49stIKXsGd8YMO/qrAel/8vWMHB8n/onXKaDvOtp5CJ7idCpnxyQQ
	cMLyE3YsIXfuMcGrZbZYzwCgN2yF/hi5UIqrmhF50ZZPfUfrS9TalR4xPWWz45XLCzuAue
	yNK/CjG5QoV+LHMpf/3NGP6mNvfh9QY=
Received: by mail-pj2-f7.google.com with SMTP id d9443c01a7336-2d561173f9fso5047165ad.0
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 04:09:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788520152; x=1789124952; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=JgjLk2Wj4ezNGWQB3j7DpVIqIrI833hmatUkGCCEbj4=;
        b=GplS+I9ql25AknTXZf4XODd6P79O42wB1wSTw4vr2Tk6mEUMkCfn6QPAtzuIUNla5M
         1xk7AJvHqX+d63aUIAKfQA6zAmhjRZS3kcsYJdzCeaFw/35gcOLUrXzi2XMUenDs5lSI
         xVcPr1tSlQa5MjRgTKF65k0PNjcZY2dllWquAw8dsq8DaQb+i7yFCxhTfIQbs0JMS377
         Wb6TXx3VeH68uv3+LMjEWD003Wyjc/JCR7zsDtP4G3MQ3QnZZhVXRMKA27Pff5yfcTGA
         ti3L4sKlFrGAgsaOLP6/C70dND2YIPnAnQRIIUAdfukcjKQN1op/bp5HM8xgjMfu4tnF
         KDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788520152; x=1789124952;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JgjLk2Wj4ezNGWQB3j7DpVIqIrI833hmatUkGCCEbj4=;
        b=cciKYqaYjfPCdW1XpEmvcjTj7sTFQDVmVQLF1Vhd+xqwN4FhiNMPCAaW0F8o6HfO8S
         4EN+2g7ThMODiMpCdnkvJU+qyoDAW4DJnBKfOuW4bizaZf5sRVcHx9RiuCuLdWZfaRnz
         RmQbVvVBq7Hzw3JYLZT0y/HctMuD/uF3uxnFYr3EDCrFSc60G1vunIPtgZs+mPmeIqF9
         FjHllNSC6bxlDycQgj4tLbkYIO1h7A4mdKAkAUcRRScUA1JkCd5vfHJJUeeT1I11re8A
         VdUOW49Dmep0FSYtp4TKBOc0gVmrtGKAyi+OdluiOWglz7x/BCbkZaAIV4IJOeB/JxIS
         pVsg==
X-Forwarded-Encrypted: i=1; AKwUvBy6N9SMm3avIJMCZfhuS4jtto1+mbiO48Nao1O/i57gHtGyQNUl4J3OB0KIJwrqr15Awwpi9A0k/A==@kvack.org
X-Gm-Message-State: AFuF++kRI7gaRY/fohuIYkeYdKtBsIsbDKbZ3OXJ4oPWSB6S9/SgJ749
	zcIVdF/kNoKVrIzr9M7aYc+UgONDONyy1L9CBQE2nxTy1VbVMAcdbJaR
X-Gm-Gg: AYBFou2+oPieQ82RxYvHfHGWmJmxORZs4rrg+60y6bHObi+V3DuKHhe5APnuiyvrKci
	fyaDcGwNT+zII65RlulJuAouMKA8afbiPnugJEcpplAYyv5pTT4GzDiug6GxTpghtydF+fjBmEW
	Fbs9gaJ2781l9uI7t+QDPFtK55SV2V4fEal07bpp1qF4a41IoTOiQLqSFwcrkWi5HXocFc2DZvt
	zElwNXaVV/Ou1Ali/mo2L6ghJfGj7DIasPvCad/OnHagQfCBdSk7rP68hwNhE0F95pKi1IEPGTh
	qL04HdIBLNozLNF9f4QKAGGHw6jA0iJNEsif1c5EQ6Ul837anbFQxTRRjFEz1amIB5Tf1v+d4Kg
	uiULvEZK2stld95CsEu0BGm0q7JD5cj6QiDPmnNl98j/6rhi6ogPGKIj0HMPR7aYo+xPiZ98o9S
	niINQLsqV51+CSmenDcswo/NGLdo0I5tiN0x4LblC70F6Ul9TblHjU+UP3y0ZYmnZIJwZpKU4Va
	cPe6/BBeBCw5jUxSw==
X-Received: by 2002:a17:902:fb48:b0:2d7:203b:9863 with SMTP id d9443c01a7336-2db1232c6a9mr51752645ad.1.1788520152439;
        Fri, 04 Sep 2026 04:09:12 -0700 (PDT)
Received: from [10.240.227.78] ([114.111.24.207])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2db148404d1sm8326655ad.6.2026.09.04.04.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Sep 2026 04:09:11 -0700 (PDT)
Message-ID: <a859f6dd-cc65-4bce-b4a0-0b757248f6d2@gmail.com>
Date: Fri, 4 Sep 2026 19:08:57 +0800
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
 <apkiW8gn9Z5XaVQh@fedora> <edd83cd6-663f-43f5-8058-99e59d941d5b@gmail.com>
 <aplAA9-NX3pw9Wmb@fedora>
From: Chen Wandun <chenwandun1@gmail.com>
In-Reply-To: <aplAA9-NX3pw9Wmb@fedora>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B904DC0007
X-Stat-Signature: dcju3cdgysqcggojgqszdbthqeryg3j8
X-Rspam-User: 
X-HE-Tag: 1788520153-446744
X-HE-Meta: U2FsdGVkX1+mRFMXlCbgI2Qc52Es7HnWdVYXtLi/2ZRgiv7V398YQqFmDHfWN5/r1MXObJcR4W6rAvjwDDljnHqkOKiAEEYp3GGlDP3SRYrejXf4bmYgS/rCzA4HYLg62uou7hqd391bOIEHQiPzRZ0lpP8hkEHBBtCx7dYU3Wpxo7G3jVEuHzhvuRcaUbS9UeGR7W9ha/VCaSiY9SXppAK8lAcwAUym+eyXpRTj1S5UpBVKXWLseWVAqRn9YxYyKOIss3riGQ2C9wqppvZw5AToS0yKN4pqgQ5q8lT7EjeyukPZ6sin+lVywFrbN6Qo19kNJ3rZtoI1DFNaaiF8g1sS/dGOvgHC7frA70vNdfBbnpiUsOf9uKNFKy8uaJgBaiqWCPCcnCribAeT3LK52e5wLHEGbFJGeRs53OT+kVWWtDzT5ry4kqQOvxldi7U8ca85/3ZSTOsj2AGlP7hFVxQKOxht/lxJoVQRhIYyExYpyunVrLa2DVzMlAabXI7C20+vZ27NWh0zGQ63PwoWG9yWXBrGXjIRPs4C9F1jVZCZubr1JWw5CYVIijlj/pF4sS4OFzBRXnBXuW9I3bb+wpDbWbjgEOCOjmuKwfHsfiWiBYmHDOsD2HR9bP/IZ8PHWSMBa3wN4lsr5okmMrfb0Hjvsrp74yCUcCvcfiVkSiQynMYeglHhuhQUdOXlFZvADY9Hour2G1YbariVV+LFwiullXmw8LDV7DSu8j4Q1NHiatylsdGtBGccK3ddesGQHdMG8uBKSAWlHPq3aQqvm4qKqoQakloYBGYz53AQcVFQzr1h6b2b4lGubgmdybxnY8F7YQV5HIPZWyw52SOrCeMDQgsZH1hPmCHs+17+3T+19z8588nau1UgNhv7BSIBXFjt+6BCO3GmP8/su+3Djf0+ebNqK7zsLbMZdwW1JqTJcbPbP+rXeNps38RuHL5HxQSJ/WLQJZdV3yRU7B9
 hgQcVF50
 VwqXrMf/UbVsCeZlLlMFwDHLnDVQKy8P6oPma5ZT+3n5PNyFFyEFrXXTtUf6x7HeixOBfFXHkML7bUpYnNYT2CJ68q6S4OysX4kW0AUb2bVIMTKNqx4Keb9BcnAdJvfT+S+VChve+q2V8/Uf0W3gHen2/4FSldpZ/Ujvzvqu1HgGnONpi3RgE0gMcpRMMLoQ48HSM95z6BxrSdnR/LZ2MerRvc2T0ILdo8WvgPSwbg6nS6H3zFf5p4Ep2tBym8xqJVrWaX1bCZL95yGIm9nXix6gjJwRZA80lisaVipO4BgyC/XXWRR4TkVXsI9VJUUQGvqE260HOY5xZTsPpyCP5NxPZ0ecmfwA/AAlfeLJvEg6b9dcZnKIVI5cKLJQDLrnC3KoCO622abQUdD37+iW2la+k4xaStRoMEyabsbkWvY7nym8lyyl0ghmKcKkZG/rrFRTPdF7E32JPUG+dBOtxGNjynm0fVQLjsIsBbJK/h2nRinPoVw59XQl1H6hlLElmi8kL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/3/26 5:38 PM, Baoquan He wrote:
> On 09/03/26 at 03:43pm, Wandun wrote:
>>
>>
>> On 9/3/26 15:31, Baoquan He wrote:
>>> On 09/03/26 at 03:05pm, Wandun wrote:
>>>>
>>>>
>>>> On 9/2/26 16:53, Baoquan He wrote:
>>>>> Hi Wandun,
>>>>>
>>>>> On 09/02/26 at 03:31pm, Wandun Chen wrote:
>>>>>> From: Wandun Chen <chenwandun@lixiang.com>
>>>>>>
>>>>>> On SoCs that carve out large firmware-owned reserved memory (GPU,
>>>>>> camera ISP, ...), kdump currently dumps those carveouts as part of
>>>>>> system RAM even though their contents are firmware state that is not
>>>>>> useful for kernel crash analysis.
>>>>>>
>>>>>> This series introduces a MEMBLOCK_NODUMP flag in memblock to filter
>>>>>> reserved memory on DT-based architectures (arm64, riscv, loongarch).
>>>>>> Reserved regions default are marked MEMBLOCK_NODUMP so kdump omits them;
>>>>>> reusable CMA regions are different because their pages are handed back
>>>>>> to the buddy allocator and may carry crash-relevant data.
>>>>>>
>>>>>> ACPI systems already filter reserved memory out of the vmcore through
>>>>>> their existing path; only DT-based systems currently fail to filter these
>>>>>> regions, which is what this series addresses. The flag lives in memblock
>>>>>> itself rather than in a DT-only structure, so the mechanism is generic and
>>>>>> both ACPI and DT systems can benefit from it (suggested by Rob, thanks) [1].
>>>>>
>>>>> Thanks for the effort. I am not against this patchset, and I haven't
>>>>> went through it carefully. Just from the cover letter, you mentioned
>>>>> generic, I am wondering if this can be generic for excluding other
>>>>> memory regions. Asking this because I try to find a way to exclude
>>>>> unwanted memory regions too, please check below link where there's
>>>>> the relevant discussion. We definitely don't like inventing wheels
>>>>> time after time. Do you think this memblock region excluding can
>>>>> be used in other places of kernel?
>>>>>
>>>>> https://lore.kernel.org/all/aoLFai0gzzH2bGgy@MiWiFi-R3L-srv/T/#u
>>>>
>>>>
>>>> Thanks for taking a look, and for the pointer to the crash-wipe thread.
>>>>
>>>> To answer your question directly: the exclusion mechanism in this series
>>>> is already generic, memblock_mark_nodump() is the entry point. Any code
>>>> that wants a region out of the vmcore just marks it MEMBLOCK_NODUMP, when
>>>> preparing vmcore elf header by walking memblock, these regionss are skipped;
>>>> This series is simply one caller, marking the DTS /reserved-memory and
>>>> /memreserve/ regions with MEMBLOCK_NODUMP.
>>>
>>> Thanks, for memory not allocated from memblock, e.g buddy, is it still
>>> good?
>>
>> Yes, still good, only need to pass the physical range to memblock_mark_nodump().
> 
> That's interesting. If drivers or any component allocate memory from
> buddy, then you will call memblock_mark_nodump() to mark the region
> specifically (memblock_setclr_flag will split regions if it's a sub
> region of existing memblock region), it won't impact anything?

IIUC, it won't impact anyting; memblock_mark_nodump() only set
the MEMBLOCK_NODUMP bit on the matching memblock.memory regions,
and from the buddy allocator's view, there is nothing changed.

The only effect is the region split you already pointed out: marking
a sub-range costs up to two extra entries in the memblock.memory
region array.


Best regards,
Wandun


> 
>>
>>>
>>>>
>>>> x86 currently builds the vmcore elf header from iomem_resource, not
>>>> memblock; it could be switched to memblock, but that would bring no
>>>> benefit for the problem this series solves, so this series makes no
>>>> x86 change. I'd personally be in favor of switching to memblock for
>>>> a unified implementation across architectures.
>>>>
>>>> Best regards
>>>> Wandun
>>>>
>>>>
>>>>>
>>>>>>
>>>>>> Since the reserved memory regions are filtered out, the vmcore is
>>>>>> smaller in size and faster to produce.
>>>>>>
>>>>>> The series is based on linux-next and is organized as follows:
>>>>>>
>>>>>> Patches 1-4: Preparation and bugfixes: fix the missing HugeTLB
>>>>>>               flagname, switch riscv crash_mem to memblock, fold the
>>>>>>               duplicated per-arch memblock walks into the weak
>>>>>>               defaults, and serialize crash header preparation against
>>>>>>               memory hotplug.
>>>>>> Patches 5-9: NODUMP infrastructure: switch crash_core to
>>>>>>               for_each_mem_region(), introduce the MEMBLOCK_NODUMP
>>>>>>               flag, add a dumpable flag to struct reserved_mem, and
>>>>>>               mark /reserved-memory and /memreserve/ entries with
>>>>>> 	     MEMBLOCK_NODUMP flag.
>>>>>> Patch 10:    Exclude MEMBLOCK_NODUMP regions from the vmcore ELF
>>>>>>               header.
>>>>>>
>>>>>> In v5, Sashiko found some pre-existing issues related to reserved-memory,
>>>>>> and has no dependency on this series, so these issues have been addressed
>>>>>> in a separate series [2].
>>>>>>
>>>>>> v5 --> v6:
>>>>>> 1. Serialize crash header preparation against memory hotplug to avoid
>>>>>>     out-of-bounds or use-after-free issues.
>>>>>>
>>>>>> 2. MEMBLOCK_NODUMP marking is now done after memblock allows resizing,
>>>>>>     avoiding a panic from too few regions before resize is permitted.
>>>>>>
>>>>>> 3. Reordered the patches, put pre-existing bugfixes earlier in the series.
>>>>>>
>>>>>>
>>>>>> v4 --> v5:
>>>>>> 1. Rework the mechanism around a memblock-level MEMBLOCK_NODUMP flag
>>>>>>     (suggested by Rob) instead of the v4 opt-in 'dumpable' flag on
>>>>>>     DT-only struct reserved_mem.
>>>>>> 2. Switch the riscv vmcore elf header preparation to use memblock
>>>>>>     instead of the resource tree, aligning it with arm64 and loongarch,
>>>>>>     so riscv also can exclude reserved memory from vmcore.
>>>>>> 3. Deduplicate the vmcore elf header preparation: arm64, riscv and
>>>>>>     loongarch open-coded the same logic, so fold it into shared
>>>>>>      __weak defaults in crash_core.
>>>>>> 4.  Drop the v4 patch that saved /memreserve/ entries into the
>>>>>>      reserved_mem array; /memreserve/ is now marked MEMBLOCK_NODUMP
>>>>>>      directly.
>>>>>>
>>>>>> v3 --> v4:
>>>>>> 1. Rebase this series on v7.2-rc1.
>>>>>> 2. Add two cleanup patches (patch 02/03).
>>>>>> 3. Simplify patch 03 to avoid checking whether initial_boot_params is
>>>>>>     NULL multiple times, suggested by Rob.
>>>>>>
>>>>>> v2 --> v3:
>>>>>> 1. Fix out-of-bounds issue if device tree lacks /reserved-memory node.
>>>>>> 2. Fix UAF issue when alloc_reserved_mem_array() fails.
>>>>>> 3. Add some prepare patches.
>>>>>>
>>>>>> v1 --> v2:
>>>>>> 1. v1 added an opt-out DT property ('linux,no-dump'). Per Rob's
>>>>>>     feedback [3], v2 drop that property and exclude reserve memory
>>>>>>     by default.
>>>>>> 2. Split some prepared patches from the original patches.
>>>>>> 3. Address coding-style comments on patch 5 from Rob.
>>>>>>
>>>>>> [1] https://lore.kernel.org/lkml/20260723234126.GA3253409-robh@kernel.org/
>>>>>> [2] https://lore.kernel.org/lkml/20260818092420.2859026-1-chenwandun1@gmail.com/
>>>>>> [3] https://lore.kernel.org/lkml/20260506144542.GA2072596-robh@kernel.org/
>>>>>>
>>>>>> Meijing Zhao (1):
>>>>>>    mm: memblock: add missing HugeTLB flag name
>>>>>>
>>>>>> Wandun Chen (9):
>>>>>>    riscv: build crash_mem ranges from memblock instead of resource tree
>>>>>>    crash_core: fold duplicated memblock arch hooks into the weak default
>>>>>>    crash_core: serialize crash header preparation against hotplug
>>>>>>    crash_core: replace for_each_mem_range() with for_each_mem_region()
>>>>>>    memblock: introduce MEMBLOCK_NODUMP flag
>>>>>>    of: reserved_mem: add dumpable flag to opt-in vmcore
>>>>>>    of: reserved_mem: mark /reserved-memory entries with MEMBLOCK_NODUMP
>>>>>>    of: reserved_mem: mark /memreserve/ entries as MEMBLOCK_NODUMP
>>>>>>    crash_core: skip MEMBLOCK_NODUMP regions when building vmcore ELF
>>>>>>      header
>>>>>>
>>>>>>   arch/arm64/kernel/machine_kexec_file.c     | 29 ------------
>>>>>>   arch/loongarch/kernel/machine_kexec_file.c | 27 ------------
>>>>>>   arch/riscv/Kconfig                         |  2 +-
>>>>>>   arch/riscv/kernel/machine_kexec_file.c     | 33 --------------
>>>>>>   arch/x86/kernel/crash.c                    |  2 +-
>>>>>>   drivers/of/fdt.c                           |  2 +
>>>>>>   drivers/of/of_private.h                    |  2 +
>>>>>>   drivers/of/of_reserved_mem.c               | 48 ++++++++++++++++++++
>>>>>>   include/linux/crash_core.h                 |  2 +
>>>>>>   include/linux/memblock.h                   |  9 ++++
>>>>>>   include/linux/of_reserved_mem.h            |  1 +
>>>>>>   kernel/crash_core.c                        | 51 ++++++++++++++++++++--
>>>>>>   kernel/dma/contiguous.c                    |  1 +
>>>>>>   mm/memblock.c                              | 17 ++++++++
>>>>>>   14 files changed, 131 insertions(+), 95 deletions(-)
>>>>>>
>>>>>> -- 
>>>>>> 2.43.0
>>>>>>
>>>>
>>


