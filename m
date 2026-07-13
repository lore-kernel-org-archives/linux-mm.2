Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E56BCC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 03:19:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6CBF6B0005; Sun, 12 Jul 2026 23:19:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D706B0088; Sun, 12 Jul 2026 23:19:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 934AF6B008A; Sun, 12 Jul 2026 23:19:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 66FCE6B0005
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 23:19:22 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C83B8C6CFD
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:19:21 +0000 (UTC)
X-FDA: 84982297722.27.94B9C9B
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf14.hostedemail.com (Postfix) with ESMTP id 43E6A100005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:19:19 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=TS9MWgij;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783912760;
	b=6GvpYwVHc/4vz1t8hqWmmrHFU7gTRJdKTNSuomBiMDb0jDwNwv05eVrcA6wBUqabYhseU3
	NLdTwIfcuzybOqzYVunQMYWA7mbLym2v9fqPs/hu+uQURHZ+r1sQFW2n16l8eAk/YCWNVI
	SwjllJw+3kTeDHJTi+xqpcKxXKtv0d4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=TS9MWgij;
	spf=pass (imf14.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783912760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j7FS//a2Zq+aYPLaWvaHRIpjDEzF5l5dQPYgw4A861Y=;
	b=YAhHGhAtL5L9Ba3p04JLpsOfTss3QypR4StqwzXnXKFwlMR0/4A1p0CBg3cS0Uu5v2ZTPx
	lXAzmOwdhHig/uHr/97CphQ7cvQ4PsDxJuKvh8Qr9zAQgQ6jsHvWVPYwuSRJnOawdMQeqh
	KMgCUVZQR2yc4+mcrl48TKHOppLYa2c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1783912753; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=j7FS//a2Zq+aYPLaWvaHRIpjDEzF5l5dQPYgw4A861Y=;
 b=TS9MWgijFOd6mXjI2Rd6x3HrIzPpCImoK48v1PvG9QVp9/6Jjt5VzPecIXOjzoWbZHH3CA
 zB/MWTU2msmQtKSUZ+iwpEyRt13tOSlgMS4t4ykB8N7iQqPGEsaF1utzIB+A0dI8CEL0n5
 g3DdHZTXD1TZkeO9w8zTj223xPczT3fNqxBDxDYbRbQw/aIXFO1uUD3jKCNOMshK4Ep1+P
 wQyJXmlL0ycMyGP0E+cUFcJ7CYDowY4ioBcwYuKCfaalYYNsz76kfLSji93IRQpNPdYSbK
 fwBWuYCSZMdyzRlWCuXTURinEySj9W3+SnIgxmJDrjDBZTD4mRWdUuTeYUSUkA==
X-Original-From: ByteDance <lizhe.67@bytedance.com>
Cc: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<bp@alien8.de>, <dave.hansen@linux.intel.com>, <david@kernel.org>, 
	<kees@kernel.org>, <mingo@redhat.com>, <rppt@kernel.org>, 
	<tglx@kernel.org>, <linux-arch@vger.kernel.org>, 
	<linux-hardening@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, <x86@kernel.org>
User-Agent: Mozilla Thunderbird
References: <20260709112520.24857-1-lizhe.67@bytedance.com> <alRCNbTlRFyD8f-1@parvat>
Content-Type: text/plain; charset=UTF-8
Message-Id: <68087ca2-1a88-46b5-b9b0-60f3358d83b2@bytedance.com>
In-Reply-To: <alRCNbTlRFyD8f-1@parvat>
Content-Transfer-Encoding: 7bit
X-Lms-Return-Path: <lba+26a54592f+915c0c+kvack.org+lizhe.67@bytedance.com>
To: "Balbir Singh" <balbirs@nvidia.com>
From: "ByteDance" <lizhe.67@bytedance.com>
Subject: Re: [PATCH v6 0/8] mm: optimize zone-device memmap initialization
Date: Mon, 13 Jul 2026 11:18:50 +0800
Mime-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 43E6A100005
X-Stat-Signature: x4z1nzt3hmtodd7su4756awzmg16yjrr
X-HE-Tag: 1783912759-784375
X-HE-Meta: U2FsdGVkX18UrYA7+ttqm9aoScvx5obZ7+FZSVjhB7nAKKpSbRmcBagyBYNUYfni2My7OvA5FS/26q18UXwAIrIuhpW385I9snl8PMcznTEz8aOS4nm2wbNARw3u6tqlWGWpHX0eK/uZ+PT/Nx0heQlNNQTs2kOtDVGOeW6B5g36doh/bWAvPG/MdqVqwC6lext0SjiIGpFQ5+lIjHfySeq5rl0vPUWyVmT/+Vhbwu3naTl55u7ExyrniMriWfgfSgdW52Oa+LxOmOVns8IKFwyZrUNB4sUEiBDn8M17D+4lNAKRt1oURkE3UwNvgOlVzDolWuNTFBiUVoLxfeovR8slGQxJsKtl/y8gx/h1DHfRKUmIosxmc/VZu6pKF5qOlIRJw1PVMXqx5960zqbGdivHNh0i032L/XnKWBAVa2W6M5yhcin4TI5XEzhLaUo2YYgQq3S7NZqmzBmo0UXUdti8uEV289Ao3fV6EMLdVQ1z3sB8Rq24NN/AIfdxv04mYxodtsPtBTWwQEqBlX849H+Lhch3W70pJPxK0A8q2S7wSB7gS8i4W8fFqN4+FQxrnaWfVJXxZ5k+xDDvfDE39BsoTjn5fsIgyjYLGe20GuztTQ6hNAEo+kDg4A7HAgJqXBlaI8wCkuFpUBg/oTmWyPimKurn9w9B0eiHRQjMiBEzjEboGZEdFtLqPxQSSRhY7eqFDDpQDanloKjlvNSHtI8SdTcppHOvqBSWDGhONObG111NcpQgM/TAiGd3V/xo/jwGpclFiYOP4eutxNEB7ppSQKTG+a2IMRLkOHr08Ews+z+WlXCvDsCXrKWTK14XLe4qjEqTKSdH1k4k5psk954RGObyGgadej5l50so1KhG/y7iqWRrtZHLOrbY0YbRDrs2iQUpgiea2Ue0bafhN9jr74hJq3VC5p1mGWawVkjIr7paVOWJ5iMbCqUIvsbGNYtAMyT2zOPn6I4qxpf
 VTZIGMJV
 zvlFuorlbBZSjx9oWatunARugFG/GVneBFQ+1MCuWrQGZeuVmDu0zGVM3rQ7JoHfd6COIndPE1IYlU+AMKGEH07dDNt1v3Szw8Qz89c2Uwa2rPT2TT4dtW6AzDYlLTqk6By1SW/5n5FEh5FAGdsg6gy1V70ejiS44y0TZQq2b9+LGLkZLL2Wed62duRq+JqK2wVI3lz223P29GWvfQETxJUuhSelKWmlYDxPM5MervhIijXCWzMX4ZO8vbRJC599lubY+as+NcUmSpouTWExaCacIthG1J3HhGw9fJ+LQ69QiBkeU1lo/hcsEZMkxqSTOw9HO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 9:44 AM, Balbir Singh wrote:
> On Thu, Jul 09, 2026 at 07:25:12PM +0800, Li Zhe wrote:
>> memmap_init_zone_device() can take a noticeable amount of time when large
>> pmem namespaces are bound or rebound, because it initializes nearly
>> identical struct page descriptors one PFN at a time. This series reduces
>> that ZONE_DEVICE memmap initialization overhead by reusing prepared
>> struct page templates and, on x86, using memcpy_nt() for the template
>> copy path.
>>
> Is the slowness specific to an architecture? Do you have any test
> results from any other arch?


The slowness I am targeting is not specific to x86.

The generic part is that memmap_init_zone_device() initializes nearly
identical struct page state one PFN at a time. Patches 4-5 address that
part by reusing prepared head/tail templates. Patches 6-8 then add an
x86-specific optimization for the copy step via memcpy_nt().

I only have x86_64 measurements at the moment, so I do not want to
claim results for another architecture without data. On the x86_64
setup, patches 4-5 already reduced the average rebind time by about
11.0% for the fsdax case and 10.6% for the devdax case before the
memcpy_nt() changes were added.

Thanks,
Zhe

>> The main target is large fsdax/devdax pmem configurations, where the
>> cost of initializing the memmap shows up directly in nd_pmem/dax_pmem
>> bind and rebind latency.
>>
>> Patches 1-3 are preparatory cleanups and helper extraction. Patches 4-5
>> add the template-copy fast path for head pages and compound tails.
>> Patches 6-8 introduce memcpy_nt()/memcpy_nt_drain(), extend the x86
>> fixed-size memcpy_flushcache() inline cases used by that helper, and
>> switch the template-copy path over to memcpy_nt().
>>
>> The fast path remains disabled when the page_ref_set tracepoint is
>> active, and sanitized builds stay on the slow path so their instrumented
>> stores are preserved. Architectures without a specialized memcpy_nt()
>> backend continue to fall back to memcpy().
>>
>> Tested in a VM with a 100 GB fsdax namespace device configured with
>> map=dev and a 100 GB devdax namespace (align=2097152) on Intel Ice Lake
>> server.
>>
>> Test procedure:
>> Rebind the nd_pmem and dax_pmem driver 30 times and collect the memmap
>> initialization time from the pr_debug() output of
>> memmap_init_zone_device().
>>
>> Base(v7.2-rc1):
>>    First binding for nd_pmem driver: 1456 ms
>>    Average of subsequent rebinds: 244.28 ms
>>
>>    First binding for dax_pmem driver: 1462 ms
>>    Average of subsequent rebinds: 273.31 ms
>>
>> With this series applied:
>>    First binding for nd_pmem driver: 1272 ms
>>    Average of subsequent rebinds: 96.79 ms
>>
>>    First binding for dax_pmem driver: 1354 ms
>>    Average of subsequent rebinds: 119.04 ms
>>
>> This reduces the average rebind time by about 60.4% for nd_pmem and
>> 56.4% for dax_pmem.
>>
>> As an additional data point, I also ran a smaller set of measurements on
>> the same physical x86_64 host with a 100 GB PMEM region created via the
>> memmap= kernel command line, configured as fsdax and devdax namespaces
>> with map=dev and 2 MiB alignment.
>>
>> For brevity, the individual patches keep only the VM results rather than
>> including a second set of physical-host measurements throughout the
>> series. The physical-host numbers below are included only as
>> supplemental evidence that the same optimization also provides a similar
>> benefit on a non-virtualized system.
>>
>> Test procedure:
>> Reconfigure the namespace mode, rebind the nd_pmem or dax_pmem driver
>> once, and collect the memmap initialization time from the pr_debug()
>> output of memmap_init_zone_device().
>>
>> Base (v7.2-rc1):
>>    nd_pmem / fsdax: 179 ms
>>    dax_pmem / devdax: 264 ms
>>
>> With this series applied:
>>    nd_pmem / fsdax: 82 ms
>>    dax_pmem / devdax: 113 ms
>>
>> This reduces the measured rebind time by about 54.2% for nd_pmem and
>> 57.2% for dax_pmem on that setup, which is broadly consistent with the
>> VM results above.
>>
>> As another supplemental data point, I also measured the test_hmm.ko
>> module on the same physical x86_64 host, using the test_hmm.ko setup
>> from the previous discussion that times ten 64 GB
>> memremap_pages()/memunmap_pages() iterations during module insertion[1].
>> By default, module insertion initializes two DEVICE_PRIVATE dmirror
>> devices, so two avg memremap values are reported; each value is the
>> average for one 64 GB chunk.
>>
>> This is not the primary target workload of the series, but it exercises
>> the same large ZONE_DEVICE memmap initialization path and shows the same
>> direction of improvement.
>>
>> Base (v7.2-rc1):
>>    avg memremap reported during module insertion: 116689362 ns, 116539263 ns
>>
>> With this series applied:
>>    avg memremap reported during module insertion: 54607108 ns, 54458236 ns
>>
>> This corresponds to about a 53.2% reduction based on the mean of the
>> reported values, which is again consistent with the pmem bind/rebind
>> results above.
>>
> That is a good result, thanks for sharing
>
>> [1] https://lore.kernel.org/all/aiEoByaQdRR3xtM5@nvdebian.thelocal/
>>
>> Li Zhe (8):
>>    mm: fix stale ZONE_DEVICE refcount comment
>>    mm: factor zone-device page init helpers out of
>>      __init_zone_device_page
>>    mm: add a set_page_section_from_pfn() helper
>>    mm: add a template-based fast path for zone-device page init
>>    mm: extend the template fast path to zone-device compound tails
>>    string: introduce memcpy_nt() helpers
>>    x86/string: extend memcpy_flushcache() fixed-size fastpaths
>>    mm: use memcpy_nt() in zone-device template copies
>>
>>   arch/x86/include/asm/string_64.h |  78 ++++++++++++-
>>   include/linux/mm.h               |  15 ++-
>>   include/linux/string.h           |  23 ++++
>>   mm/mm_init.c                     | 186 ++++++++++++++++++++++++++-----
>>   4 files changed, 273 insertions(+), 29 deletions(-)
>>
>> ---
>> v5: https://lore.kernel.org/all/20260701090553.62691-1-lizhe.67@bytedance.com/
>> v4: https://lore.kernel.org/all/20260603080152.64728-1-lizhe.67@bytedance.com/
>> v3: https://lore.kernel.org/all/20260527033636.28231-1-lizhe.67@bytedance.com/
>> v2: https://lore.kernel.org/all/20260521040124.10608-1-lizhe.67@bytedance.com/
>> v1: https://lore.kernel.org/all/20260515082045.63029-1-lizhe.67@bytedance.com/
>>
>> Changelogs:
>>
>> v5->v6:
>> - Rework patch 6 so the x86 memcpy_nt_drain() helper uses wmb()
>>    instead of an open-coded sfence, while architectures that do not
>>    override memcpy_nt() keep the generic no-op drain fallback.
>>    Suggested by Borislav Petkov.
>> - Rework patch 6 to use the usual self-macro override pattern for
>>    memcpy_nt() and memcpy_nt_drain() instead of a dedicated
>>    __HAVE_ARCH_MEMCPY_NT feature macro. Suggested by David
>>    Hildenbrand.
>> - Drop the default: case from pagemap_resets_refcount() and drop the
>>    WARN_ONCE() after the switch so newly added enum memory_type values
>>    remain visible to compiler switch checking. Suggested by David
>>    Hildenbrand.
>> - Drop the unnecessary empty set_page_section() stub from patch 3, keep
>>    set_page_section_from_pfn() as the only !SECTION_IN_PAGE_FLAGS no-op
>>    helper and fix its indentation. Suggested by David Hildenbrand.
>> - Rework patch 4 so the reusable head-page template is seeded from the
>>    first loop iteration, keeping the main loop intact while ensuring the
>>    first page is initialized only once; also drop the extra template
>>    memcpy helper, as suggested by Alistair Popple.
>> - Rework patch 5 similarly for compound tails: seed the reusable tail
>>    template from the first tail-page iteration so the first tail page is
>>    initialized only once, while keeping the main tail loop intact, as
>>    suggested by Alistair Popple.
>> - Rework patch 7 to rename the internal fixed-size MOVNTI helpers to
>>    movnti_*(), keep memcpy_flushcache() as the externally visible
>>    wrapper, fold the new 32/48/64/80/96-byte copies into the main
>>    fixed-size switch, clarify in the code and changelog that the
>>    ZONE_DEVICE template-copy path relies on the 64/80/96-byte struct
>>    page copies while 32/48-byte copies stay inline as well, and drop the
>>    separate alignment check based on the physical-host microbenchmark
>>    results. Suggested by Borislav Petkov.
>> - Run v6 VM spot checks for the fsdax/devdax map=dev paths. The
>>    results stayed in the same ballpark as v5, so keep the previously
>>    posted v5 full-run numbers in this version instead of replacing them
>>    with another partial data set.
>>
>> For changelogs of earlier revisions, please refer to the v5 cover letter.
>>
>> -- 
>> 2.20.1
> Balbir

