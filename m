Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1EEAC982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:01:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D501B6B009D; Fri, 18 Sep 2026 10:01:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D27D26B009E; Fri, 18 Sep 2026 10:01:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C184C6B009F; Fri, 18 Sep 2026 10:01:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 96B8C6B009D
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:01:45 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1DA8160697
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:01:44 +0000 (UTC)
X-FDA: 85227046128.04.03DE0EE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 606FE180022
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 14:01:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G6jfSLEU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789740102;
	b=SjAPbTfRK1InwYPB63r9sXWKWgekQFXiEd14UZHF5qAkJfCApYOQLyLjvI73usHv73yyle
	BZyNtsU7tsVXWhLs6s++TKHpNHiOvpmzc71i6IMfngm4/UYdr3PS4TkfmR4fWdhGxts6c1
	Th9t5e0uO+QkE/BPX4HVpLHeYZYkS4M=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=G6jfSLEU;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf06.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789740102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oiLxcuf3moIzoAJiz7VjqGkuKZ3KLxcnu3OutAUBSw0=;
	b=OUGZlhpyWDHul7ITiHQhcEzcpRSUx/22s9nNeGA+uyqYe7GJqthm7RBXCHPMgi2TJzVEwH
	iucWSP5zORrJn/nHiuD89IZqUMJ8/HjFIGInzVCvQRFhlFAe9GI1hUL7Y1+1JCgw9hJY4H
	yXpWo0YNm/eGyir0NUQqHynfy0aZrIE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1789740101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oiLxcuf3moIzoAJiz7VjqGkuKZ3KLxcnu3OutAUBSw0=;
	b=G6jfSLEUZ3CODXNRORAeRdziukMONha/jw86AiNPKD4hUdOYMOdwY+dlWfdgCU0Hse7Q7k
	zk441Ehc/1tFCPMh2jqMjpVdPO1g1/gj0UrAYb1d0uWmhEq3J0rVGhnGXh4AWxf1yxVU/D
	fCdsmHWcwHSf992Cn2E0CFthqcLuU3o=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-q0BEbZoeOI2uQX2xAe5Zqg-1; Fri, 18 Sep 2026 10:01:40 -0400
X-MC-Unique: q0BEbZoeOI2uQX2xAe5Zqg-1
X-Mimecast-MFC-AGG-ID: q0BEbZoeOI2uQX2xAe5Zqg_1789740100
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-66ce3040ea9so721467d50.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 07:01:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789740100; x=1790344900;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oiLxcuf3moIzoAJiz7VjqGkuKZ3KLxcnu3OutAUBSw0=;
        b=hzgoxUpuHhvtd1lu/5xa2ApsHU//JgX7vjrN7sfDV77mLUbeNjtJcge7trshjRzXif
         T3sx/NW4ACXarBP+X4C65ind0erd1g/Lqpsl+SQ87rCoy6AIIWn3cCWVdxTZuXRAtUXp
         xyX8FbHqvTmBqEzAvhaEuhaDXJ7Br5t+aL2TZluSIxoUyvt85DMVfiaatwbImcEycXPe
         GHFJfMF/geTLltpMs98jbeY2nFqm5eexOcYhrg4CYH3kwVzr4T8B86UIXgXqbEJmHT7B
         c/smHCfloPW/71YAs0mE8AdLwxeslPHw17PXwhGJDKLn0S8pecbeslt8r7OPh+syTaqI
         amUA==
X-Forwarded-Encrypted: i=1; AKwUvBwL2oLDdoaS1jXTcbPaWdkCD5NMkEGf+3AI+VzYb2xbSdwAPiT1hIlMDdkiI6i3g3Kw4bJMf2cVng==@kvack.org
X-Gm-Message-State: AFuF++n+YcsQiCJdms7crkiDtchPJOtX4GYi6Rdrr487uZPvxnbEMWdd
	XD3qQrG3yreRWCWbNgKP5vy/gacnDWOBcsB5PyyQ4+UGrCA6qOA53GmBxRJxAiUaEkJ9RexG1XP
	508n+ueJ34ycnrpJVs9iBpuRiRpOnwVRFUc+hfdLJw4wP4k7kowN2
X-Gm-Gg: AYBFou3Gj5R5Y0V884TCbHmJt+4E7r70hjSZCbvhn9QD+F9Y12zJbB55smBNbwilyYM
	ZQdpXOTIREBXa+osr5iCu+ZAg8hTpprJ7bdZuLSlMgvpynxKbDGsIw6NozF0Vo/E3JskeOkVzwn
	h6UMUdoDOFfMEO7H7xq03X45OpxcScwwSwxloKDuJbcK7uffwZGA6RwnKZDcQFp39D3b1bsYtoS
	ZtGg2e/Bf8trGpKts/tqxRn8Ezxw2Y/6tpVIdyJ4LPg+qa0vSklCOhec3Gto/Yri65HPPlY5SA5
	XaeCmrV8gr2LTiIr7pTX7T/bf3jb4sgm3XC8TVcBGeR4Z3nDbLDrrG1JIbAA2s6p7sz5E5GZlAh
	mlLk=
X-Received: by 2002:a05:690e:4594:10b0:671:214:30a6 with SMTP id 956f58d0204a3-6717fe4a92dmr589926d50.94.1789740099662;
        Fri, 18 Sep 2026 07:01:39 -0700 (PDT)
X-Received: by 2002:a05:690e:4594:10b0:671:214:30a6 with SMTP id 956f58d0204a3-6717fe4a92dmr589856d50.94.1789740098908;
        Fri, 18 Sep 2026 07:01:38 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9125809a249sm13111076d6.46.2026.09.18.07.01.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Sep 2026 07:01:36 -0700 (PDT)
Message-ID: <970c8f34-3cf4-4c6c-931c-b132e3bc6838@redhat.com>
Date: Fri, 18 Sep 2026 10:01:35 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 00/14] mm: thp: always enable mTHP support
To: Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, david@kernel.org, baolin.wang@linux.alibaba.com,
 ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com
References: <cover.1789695931.git.luizcap@redhat.com>
 <ad25b99c-d9f6-4e52-819b-81e08eb2a131@linux.dev>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <ad25b99c-d9f6-4e52-819b-81e08eb2a131@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: zEpv2nwQkvK_kzRW1z454T0FTjlhZVt_csnsfx8b7nI_1789740100
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 606FE180022
X-Stat-Signature: na4e75dy1gik37hrhbmaqhdatwhsbzq4
X-HE-Tag: 1789740102-347949
X-HE-Meta: U2FsdGVkX18zDBnsActVPBrCb0UIC0eIQ/lACSt2pyr+2Ifroy+6s/gw+BRZ2dQgKtH+cIXKLihrwsLAEv7SApVBLDceRucoJh50qG9W662M3oKctpIhCq34FePJCt1UMMyxFNVgMP+i9KUuoQxoFxbZRuW/kGdo55G56y1RQqo0I2+R5nJ5wmTvKOwb48CFe3HKqURAGcCXS1aWiQuQQd3yzzVwJKW0VSmc7Z5BLr6M/gpcHQwKR5NWZQlDpWLa8hI9q2jljgLOVWPXjlPrhyWTbRDvk2uWu4J6YozBygDiCJOgpSjfWh8nACej/l2QVOD15C5Rn7veTFZpGt7v2feOFyDqQw3yf8JvgRSMwCsLnsMNVVoleydkx9EjhGj/JzJ9ckSU/cadMTulqBbDBl55sCg7ciKFvTzu2hlHhBxSSId+MCJgEqB+QfWnMyDH9olO9Xl/uCbQbsrt2061BpHXMd4BGiU83P6YRFHhFW5VVVeoDufup9Z69busEbqx9znecoJC/N+lqh41b4W3EawbjKzwrpLN0PZm7Z+3YeZQZpOuz4kkzgISRn2xiOmMRuGRp3UFvpAC449bzwhGfegXAEvPDdB5VZKlbZCvEB19Q8drUPx6vjXORMHcnEnQ9XRGG3TTp+qKT4wQ3LAyPP06cU0mj0rr/PwSunqbPOIsdDw4AwV0gw6MTsKZCbzDpSSC/7gMsoCs4IRqgOfjBk3+MylJRegAmAgwvrTI1S99hmZLO/lpv8sn0Bmz1c2313OUpsd0SbCqvnp6TzkJHtqot6rM3EHf1tNnrPy0yAlHffoRDjeV2winR2M/+b7kjI1aRWgAGwEPWdDARcyCxpz4x2Tu/6VSG3oJxEfTNmQBcoUq1wwzcHG0V1PGObNhlJiVJohairB5mMzOlooYA4rjhG5tU1iY5y4EyPSyDsPooLbwg8nTUP/H4UannGJyE8zv3jsKrrueGGAbFJu
 vYL1kITI
 CWvjAW3RefA6x7H/GYS9ltaWm1F/DTXAqutvKsoRRYKfM1OzhNf1Be1aGMhmHQDx8D9SO5B5w30woQASm3n83+DqFRdWP7HopP84K96/QKwqz5g5abXOlfHAqMhTlgASYNgEEA54xTri5n0dx6+hVDfqQMHj7OACU/F8Axx9VbYTx5+NWKBg9TIgsAjM73ST/wV9JojA3yTwVuQxdLxcMfjpxxIk20Ewg4B3Ug7QDpl85eLrLXzBGrfEvPIV2178yZPuSFfeJ6fe54/6QnxJG386cmQ09VfFGn81zVlVt/LB/ScYW2/DO9MUxMI4aiRoDF44iKZsURXmnGi6R4J2bHSRa559GCmbbC0jGnd5pf4+270o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/26 6:37 AM, Usama Arif wrote:
> 
> 
> On 18/09/2026 02:45, Luiz Capitulino wrote:
>> Introduction
>> ============
>>
>> Today, if an architecture implements has_transparent_hugepage() and the CPU
>> lacks support for PMD-sized pages, the THP code disables all THP, including
>> mTHP.
> 
> 
> Hi Luiz,
> 
> Sorry for asking this so late in the series, but which CPUs lack support for
> PMD sized pages?
> 
> Is this series mainly for PowerPC?

No :)

The architectures that have conditional PMD page support (ie. discovered
at run-time via has_transparent_hugepage()) are x86, s390, powerpc and
mips.

For x86 for example, even on 64-bit there are cases where the PSE bit
may not be present (eg. some errata and by hypervisor CPUID masking).

That being said, the main goal of the series is that
has_transparent_hugepage() is overloaded: it has different semantics on
those architectures and is used to gate all THP support (which is not
the right thing to do for mTHP).

> 
> Thanks,
> Usama
> 
>>
>> This happens because the has_transparent_hugepage() helper is overloaded:
>> its name implies it checks whether THP is enabled, but on some architectures
>> it actually checks whether the CPU supports PMD-sized pages. In addition,
>> the THP and shmem code have a big switch on has_transparent_hugepage().
>>
>> This series solves this by decoupling THP availability checking from
>> querying CPU support for PMD-sized pages. THP availability can be checked
>> with IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE). For querying PMD-sized page
>> support, this series introduces a new helper called pgtable_has_pmd_leaves(),
>> which is independent of THP, has well defined semantics and can be used
>> in fast paths.
>>
>> Core THP code and shmem can use pgtable_has_pmd_leaves() to determine
>> PMD-sized THP support at page fault time (or folio allocation time for
>> shmem), leaving THP and shmem always enabled for other THP sizes. For
>> architectures and CPUs that do support PMD-sized pages there's no
>> intended change in behavior.
>>
>> We also convert each user of has_transparent_hugepage(), and the related
>> helper thp_disabled_by_hw(), to IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)
>> and/or pgtable_has_pmd_leaves() according to the call site's check semantics.
>> On s390, powerpc, mips and x86 the arch has_transparent_hugepage()
>> implementation is moved out of the CONFIG_TRANSPARENT_HUGEPAGE guard and
>> renamed to arch_has_pmd_leaves().
>>
>> Thanks to David Hildenbrand for suggesting this improvement and for
>> providing initial guidance (all bugs and misconceptions are mine).
>>
>> This applies to mm-new 93f615a22169 ("mm/swap, PM: hibernate: atomically
>> replace hibernation pin").
>>
>> Reporting availability of PMD-sized pages to user-space
>> =======================================================
>>
>> Before this series, not having PMD pages available would shut down THP support
>> meaning that /sys/kernel/mm/transparent_hugepage would not be available.
>> After this series, /sys/kernel/mm/transparent_hugepage and hpage_pmd_size are
>> always available but hugepages-<PMD-size>kB is only available if PMD-sized
>> pages are supported.
>>
>> To me this seems logical, as hugepages-<size>kB is only available if <size>
>> is supported. If this is correct, then MM kselftests that depend on PMD-sized
>> pages will need to be updated to check for it as they fail with this series
>> applied when PMD-sized pages are not available.
>>
>> The alternative is changing hpage_pmd_size: either don't create the file
>> when PMD-sized pages are not available or set hpage_pmd_size=0. My concern
>> is that this could be considered an ABI breakage as this file was never
>> reported to be optional or report a zero value.
>>
>> Testing
>> =======
>>
>> - Ran MM kselftests on x86_64 and s390
>> - Tested all mTHP sizes allocation on x86_64 (with and without PMD-sized
>>    pages available)
>> - Tested shmem with within_size w/ mTHP on x86_64 (with and without
>>    PMD-sized pages available)
>> - Performed defconfig build on x86_64, s390, arm64, powerpc, and mips
>>
>> NOTES:
>>    * I'm forcing arch_has_pmd_leaves() off on x86 to simulate not having
>>      PMD-sized pages available
>>
>>    * Running the MM kselftests when PMD pages are not available causes some
>>      tests that depend on PMD-sized THP pages to fail as noted earlier
>>
>> Changelog
>> =========
>>
>> v8
>> --
>> - Fixed build breakage on MIPS (Lance)
>> - Rebased on top of mm-new (fixed conflicts in include/linux/pgtable.h and
>>    mm/shmem.c - dropped a Reviewed-by as a result)
>>
>> v7
>> --
>> - Applied on top of latest mm-new
>> - Improved various changelogs including cover-letter
>> - Changed arch_has_pmd_leaves() default implementation to use IS_ENABLED()
>>    instead of IS_BUILTIN()
>>
>> v6
>> --
>> - Rebased on top of mm-unstable (required a minor conflict resolution)
>> - Added more Reviewed-by and Acked-by tags
>>
>> v5
>> --
>> - Moved init_arch_has_pmd_leaves() to mm_core_init() (David)
>> - Renamed init_arch_has_pmd_leaves() to pgtable_leaf_support_init() (Lance)
>> - Added new patch changing shmem_getattr() to set blksize according to
>>    highest supported THP order (Baolin)
>> - Added new patches to move has_transparent_hugepage() out of
>>    CONFIG_TRANSPARENT_HUGEPAGE guards
>> - shmem_allowable_huge_orders(): rename variable and only disable
>>    PMD_ORDER (David)
>> - Added <linux/jmp_label.h> to include/linux/pgtable.h
>> - Added new tags and removed Reviewed-by from changed patches
>>
>> v4
>> --
>> - Used static key for pgtable_has_pmd_leaves() API (Lance)
>> - Moved shmem pgtable_has_pmd_leaves() check to
>>    shmem_allowable_huge_orders() (Baolin)
>> - Default pgtable_has_pmd_leaves() implementation to
>>    IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) (Zi)
>> - Dropped patch “mm: thp: x86: cleanup PSE feature bit usage” (Dave)
>>
>> v3
>> --
>> - Rebased on top of latest Linus tree
>> - Removed i915 patch as driver dropped has_transparent_hugepage() usage
>> - Moved init_arch_has_pmd_leaves() call in start_kernel() to avoid conflict
>>    with early_param handlers clearing CPU feature flags
>> - Fixed build error with CONFIG_MMU=n (kernel test robot)
>> - Fixed huge_anon_orders_inherit default setting when !pgtable_has_pmd_leaves() (Baolin)
>> - Small commit changelog improvements
>>
>> v2
>> --
>> - Added support for always enabling mTHPs for shmem (Baolin)
>> - Improved commits changelog & added reviewed-by
>>
>> v1
>> --
>> - Call init_arch_has_pmd_leaves() from start_kernel()
>> - Keep pgtable_has_pmd_leaves() calls tied to CONFIG_TRANSPARENT_HUGEPAGE (David)
>> - Clear PUD_ORDER when clearing PMD_ORDER (David)
>> - Small changelog improvements (David)
>> - Rebased on top of latest mm-new
>>
>> Luiz Capitulino (14):
>>    docs: tmpfs: remove implementation detail reference
>>    mm: shmem: shmem_getattr(): set blksize to highest supported THP order
>>    mm: introduce pgtable_has_pmd_leaves()
>>    drivers: dax: use pgtable_has_pmd_leaves()
>>    drivers: nvdimm: use pgtable_has_pmd_leaves()
>>    mm: debug_vm_pgtable: use pgtable_has_pmd_leaves()
>>    mm: shmem: allow THP support determination at folio allocation time
>>    s390: move has_transparent_hugepage() out of THP guard
>>    powerpc: move has_transparent_hugepage() out of THP guard
>>    mips: move has_transparent_hugepage() out of THP guard
>>    x86: move has_transparent_hugepage() out of THP guard
>>    treewide: introduce arch_has_pmd_leaves()
>>    mm: replace thp_disabled_by_hw() with pgtable_has_pmd_leaves()
>>    mm: thp: always enable mTHP support
>>
>>   Documentation/filesystems/tmpfs.rst           |  5 ++--
>>   arch/mips/include/asm/pgtable.h               |  6 ++--
>>   arch/mips/mm/pgtable.c                        | 25 ++++++++++++++++
>>   arch/mips/mm/tlb-r4k.c                        | 22 --------------
>>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 ++++++------
>>   arch/powerpc/include/asm/book3s/64/radix.h    | 14 ++++-----
>>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  8 ++---
>>   arch/s390/include/asm/pgtable.h               |  6 ++--
>>   arch/x86/include/asm/pgtable.h                | 12 ++++----
>>   drivers/dax/dax-private.h                     |  2 +-
>>   drivers/nvdimm/pfn_devs.c                     |  6 ++--
>>   include/linux/huge_mm.h                       |  7 -----
>>   include/linux/pgtable.h                       | 21 ++++++++++++--
>>   mm/debug_vm_pgtable.c                         | 20 ++++++-------
>>   mm/huge_memory.c                              | 27 ++++++++++++-----
>>   mm/memory.c                                   | 11 ++++++-
>>   mm/mm_init.c                                  |  1 +
>>   mm/shmem.c                                    | 29 ++++++++++++-------
>>   20 files changed, 144 insertions(+), 100 deletions(-)
>>
> 


