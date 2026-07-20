Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 959DCC4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A29F6B008C; Sun, 19 Jul 2026 23:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B096B0092; Sun, 19 Jul 2026 23:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690846B0093; Sun, 19 Jul 2026 23:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 34A8D6B008C
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:20:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9F5C8120504
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:20:08 +0000 (UTC)
X-FDA: 85007701296.18.3E84D78
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf22.hostedemail.com (Postfix) with ESMTP id 59B7DC0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:20:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ndq7pceU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784517606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/gboBdKcLyKUtNlSvQWR22d9f7N6OeMEtzAkb28zmiU=;
	b=AD1YiuULgNWjxinlDeS6f7+0LhRtigdqFCyi5u0qaACp5kLx48LitM5JO/4Z6pO8hV68ZK
	rZUYxWX+rar3ZJ8ci1F6zgt4ePI5hhVNqy9p9PZkhRhWb7dDbFmrhf6gEx+/FT/XdHiDv/
	F6VU2GFEEXqGy+H+R95ulzsABHDMgFU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ndq7pceU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784517606;
	b=4c324fCHN2Xc2B7gTUlU575cp8BQN3GKJc3jbRXcLXWf1sXEpA814Z0FIFh1wOJgfR8UA8
	bGQLOGoQUoPJ3C1d5SmcPLOWe+6sOdweS12TYeiZJMFYfshVtmrsqf+RqK5exGm62mwuvs
	bp5A9g5xo65177poiEBZv4kMFp5oBWc=
Message-ID: <2e4e8c63-9d5f-4e5f-afbd-6cc91b5562d3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784517604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/gboBdKcLyKUtNlSvQWR22d9f7N6OeMEtzAkb28zmiU=;
	b=ndq7pceU0wscjhjg/FZIExu9er6SIixnjDl75z39pQsF3jNyAwzkUqML/1M8ibrOIm5r5d
	JgfDIZwKRqnKxZIr/oo5pn9xYFN1WV/b5tZCtFBvDeePrUnmUNXBXXNPYHoVlU2vzHwUw1
	LsVkb3Miruq4POHgGbFuMZB1EZjulnU=
Date: Mon, 20 Jul 2026 11:19:41 +0800
MIME-Version: 1.0
Subject: Re: [PATCH slab/for-next-fixes v3 0/4] mm/slab: fix unbounded
 recursion in free path with memalloc profiling
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Kees Cook <kees@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>, Danielle Constantino
 <dcostantino@meta.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 "Harry Yoo (Oracle)" <harry@kernel.org>
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <alkypcRUZa_r6uGV@linux.dev> <c993627d-9071-4fb4-b5fe-e0a49ed26abb@linux.dev>
 <alpHadRGUeaaMUKJ@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <alpHadRGUeaaMUKJ@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ypgpkmayh4eyaio1j86w4n1cqmt6x3wm
X-Rspamd-Queue-Id: 59B7DC0004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784517606-536819
X-HE-Meta: U2FsdGVkX19ybS8UI3gLMI52UfKYAg2PiwFwwHZBLNEF1k4/Lg6Wt3EEhlg9bVNwdzeLuFwMbXuiYvDhr38J5T/PUwBeiU4crMvvbKHG5wUYhCpc/u1D+kpmjbBe9ozdZPNbPnA8iLt47Z/MK/gaIAUdPMm3mPdpSVRtLyo7Iwv2/okSzh7x0rjCfFGoC/p6VaSVeKCrSfDJV10GCd8NQUA3e3ZNIwAV6+tx2ToRpC8PJC4oNg//E2zENL87G4BJx3zjT4Ny8zDB1wYyYVJwrs39erRzr6zcPHeGWyV+X008PpAIk4T1yWWPl5bEXJNa+ta513p6VnfZ1sHtK2Cm9tRF2CdyAgkMBOgJ6m0RMRVf0HC98wnkUv33FyTsxR6v8YZyzmM1uwQBMYDPLh7y1+qUHVNC713QZQWVkipBDY9+lvgEf0+Jp2zhP8wcMc1Ar4KvHb12GNBgnbyDZp1dQ42YmOB7NRG5+yZOhZWs5uKoLroml1i+WmFaawMi1OkNoY7+wxvjZZ3UlOsXUmHihPqaLNyYnVokM6aFpos4LcfM8vpeiILQJObbYVVKwhgSTG5hQVw49JK0I3uCvhE9886KO4X8tPt3Jc6GPh/3HmO+pev1BbZ9DAXTSmefuPto85TxXvPU1UU4wfPfsuwjkyiB3pbAJbYMgVE/MSmrwchZTONpt/XELrFzt4PZ+iL7hmilgQtt+D7OKOxX/JD+5IHJ4yIAkoH+76Mh8kqr9AbhdHGEsLsY2VgP+nwcYUL+kkqP9gKmz7dQKUI5rMRKvkLaMK62M4wzwv7l3P/WRuR91qgI2vCfXuUrrQMrlprzT42cf/1NlASpmqzo+EeXRx2vXuZcmmj4Oph9fwiugpNd0UjBjxoFHoiDgfH2JhGENFTA69OQTiF/t0sUHexfDD8a5kgDlvizAk3YPf2lEhU2Es1D1lKVDPrFknnJvg0iMEszwkNZ3IrjFNnB/I5
 nbLFYTST
 v0lCPUgIG7woTlVfZlHL6GAtHcMT4muQyxSzUWtP6zj+l8NE2dW7weebxoiTktZYmeiSA87vzAWJvc/J1ecwcCOfX6QaUaAw9/tlvN+/g1O/tMtYfgnGG89z7iLBZ3lgwOX/yb7eciXiL4hdJ52C0550QCuy6XAbbg4V1/FPsUoLjCkKy2RvlsJOue7+8YiOpOlM3/1DlwjnmHYPxoV40/OBsAJzlF8emc3u+PHGG8arodwXi332tQcuCIY/IoHyzT7ZvTBe2g7UHZdBr2eggByl/9N3DtddBfa9pr0LBZiOrUDO3uZyrgvve+M+XjUcqG1NvYY9wYk+N5frOOuNpFfNGQsPL+0p3m4T1aO4bq6dWJz9E652LBHlGh5JZMlxlFDlHvWlcSehHAkYHSKFpQGZj3HyERUOqZqdiWi4Tq6j19L+5R+2/R+SoI1L4PMXxRJuhleFGtgdF8chg8ZDHvDH3cxDdjRvVKcqCHLmkFtygxmKdfvjKErRgeMMPLE6ifZj8rMB7lD4waiymhAQCsQjhIJFj1OkleTAOOqaXAjdlLKwPzvaAqi85pRPlS4++mECYV+kwlFeRY31QITwKBaZVqjc6XI0/CDNZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel


On 2026/7/17 23:18, Shakeel Butt wrote:
> On Fri, Jul 17, 2026 at 09:16:19AM +0800, Hao Ge wrote:
>> On 2026/7/17 03:37, Shakeel Butt wrote:
>>> On Mon, Jul 13, 2026 at 11:28:48PM +0900, Harry Yoo (Oracle) wrote:
>>>> This is a follow-up fix after the recent discussion [1].
>>>> See patch 4 for the detailed description on the bug.
>>>>
>>>> Based on slab/for-next-fixes (af9ea231c0b45) and is available at
>>>> git.kernel.org [2].
>>>>
>>>> Instead preventing cycles by bumping up the allocation size of obj_exts
>>>> arrays, it introduces a new kmalloc type called KMALLOC_NO_OBJ_EXT and
>>>> disallow formation of cycles between kmalloc types when allocating
>>>> obj_exts arrays. obj_exts arrays of normal kmalloc caches are served
>>>> from KMALLOC_NO_OBJ_EXT caches (that don't have obj_exts), and all other
>>>> obj_exts arrays are served from normal kmalloc caches.
>>>>
>>>> I tried to reuse SLAB_ALLOC_NO_RECURSE to make kmalloc_slab() select
>>>> KMALLOC_NO_OBJ_EXT, but it was not great because it does not allow
>>>> sheaves for those caches. So I introduced a new slab alloc flag
>>>> SLAB_ALLOC_NO_OBJ_EXT.
>>>>
>>>> To avoid huge confusion, I had to decouple "disallowing sheaves"
>>>> semantics from SLAB_NO_OBJ_EXT and introduced SLAB_NO_SHEAVES.
>>>>
>>>> While this cannot be directly backported to v6.18 and v6.12 due to lack
>>>> of SLAB_ALLOC_* flags and kmalloc_flags(), I don't this will be
>>>> particularily challenging to backport it. Instead of a new slab alloc
>>>> flag, we can use __GFP_NO_OBJ_EXT to select KMALLOC_NO_OBJ_EXT as
>>>> kmalloc caches don't have sheaves in v6.18 anyway.
>>>>
>>>> [1] https://lore.kernel.org/linux-mm/9a139365-28e6-4f1e-b35b-7f6091e9aa14@kernel.org
>>>>
>>>> [2] https://git.kernel.org/pub/scm/linux/kernel/git/harry/linux.git/log/?h=kmalloc-no-objext-v3r1
>>>>
>>>> To: Vlastimil Babka <vbabka@kernel.org>
>>>> To: Andrew Morton <akpm@linux-foundation.org>
>>>> To: Hao Li <hao.li@linux.dev>
>>>> To: Christoph Lameter <cl@gentwo.org>
>>>> To: David Rientjes <rientjes@google.com>
>>>> To: Roman Gushchin <roman.gushchin@linux.dev>
>>>> To: Suren Baghdasaryan <surenb@google.com>
>>>> To: Hao Ge <hao.ge@linux.dev>
>>>> To: Kees Cook <kees@kernel.org>
>>>> To: Pedro Falcato <pfalcato@suse.de>
>>>> To: Shakeel Butt <shakeel.butt@linux.dev>
>>>> To: Danielle Constantino <dcostantino@meta.com>
>>>> To: Liam R. Howlett <liam@infradead.org>
>>>> Cc: linux-mm@kvack.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
>>> I tested next-20260716 which has this series against next-20260707 which does
>>> not have the fix. The reproducer were able to trigger the leak/recursion on
>>> next-20260707 but not on next-20260716. So, you can add:
>>
>> Hi Shakeel
>>
>>
>> It seems you have a consistent stable reproduction method or test script.
>>
>> Would you mind sharing it if possible?  I'm sorry if this was provided
>> earlier and I overlooked it.
>>
>> I'd like to thoroughly investigate and learn about this problem.
>>
>> Thank you very much.
>>
>>
>
>  From dcb6ca5c051738d64f7a901402f5f257babbc385 Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeel.butt@linux.dev>
> Date: Fri, 17 Jul 2026 08:12:11 -0700
> Subject: [PATCH] slub: repro unbounded recursion in slub objext array
>   allocation
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>   repro_public/Makefile       |   1 +
>   repro_public/README.md      | 128 +++++++++++++++++++++++++
>   repro_public/repro_objext.c | 180 ++++++++++++++++++++++++++++++++++++
>   repro_public/run_repro.sh   |  26 ++++++
>   4 files changed, 335 insertions(+)
>   create mode 100644 repro_public/Makefile
>   create mode 100644 repro_public/README.md
>   create mode 100644 repro_public/repro_objext.c
>   create mode 100755 repro_public/run_repro.sh
>
> diff --git a/repro_public/Makefile b/repro_public/Makefile
> new file mode 100644
> index 000000000000..0629fc5b6fb7
> --- /dev/null
> +++ b/repro_public/Makefile
> @@ -0,0 +1 @@
> +obj-m := repro_objext.o
> diff --git a/repro_public/README.md b/repro_public/README.md
> new file mode 100644
> index 000000000000..21ec3f5c01e6
> --- /dev/null
> +++ b/repro_public/README.md
> @@ -0,0 +1,128 @@
> +# Reproducer: SLUB obj_exts free-recursion / cross-cycle leak
> +
> +With `CONFIG_MEM_ALLOC_PROFILING=y` and profiling enabled, every
> +`KMALLOC_NORMAL` slab gets a `slabobj_ext` (obj_exts) array that is itself
> +`kmalloc()`'d from a `KMALLOC_NORMAL` cache. `sizeof(struct slabobj_ext) == 16`,
> +so with the right slab geometry the arrays reference each other:
> +
> +- `kmalloc-512` with 64 objs/slab -> array is `64*16 = 1024` bytes -> `kmalloc-1k`
> +- `kmalloc-1k`  with 32 objs/slab -> array is `32*16 =  512` bytes -> `kmalloc-512`
> +
> +A `kmalloc-512` slab and a `kmalloc-1k` slab then hold each other's obj_exts
> +array (a 2-cycle). Discarding one frees the other's array, which empties and
> +discards that slab, and so on:
> +
> +```
> +__free_slab() -> unaccount_slab() -> free_slab_obj_exts() -> kfree()
> +             -> discard_slab() -> __free_slab() ...
> +```
> +
> +At production scale this recurses until the 16 KiB kernel stack overflows
> +(stack guard page). In a small VM it deterministically manifests as a *leak*:
> +the mutually-pinned slabs can never be reclaimed, so `kmalloc-512`/`kmalloc-1k`
> +retain thousands of unreclaimable objects after a shrink storm. Same root cause.
> +
> +Related upstream commits:
> +- `4b8736964640` ("mm/slab: add allocation accounting into slab allocation and
> +  free paths") — introduced the obj_exts arrays (Fixes:).
> +- `280ea9c3154b` ("mm/slab: avoid allocating slabobj_ext array from its own
> +  slab") — bumps the size only when the array would come from the *same* cache
> +  (`object_size ==`); does NOT break the `kmalloc-512 <-> kmalloc-1k` cross
> +  cycle, so it is insufficient.
> +
> +## Files
> +
> +- `repro_objext.c` — the reproducer kernel module.
> +- `Makefile`       — out-of-tree module makefile (`obj-m := repro_objext.o`).
> +- `run_repro.sh`   — in-guest driver: enables profiling, prints the slab
> +  geometry, insmods the module, hammers `shrink`, and reports the leftover
> +  object counts (all via `/dev/kmsg` so it survives in `dmesg`).
> +
> +## Requirements
> +
> +Kernel `.config`:
> +
> +```
> +CONFIG_MEM_ALLOC_PROFILING=y      # trigger: obj_exts on KMALLOC_NORMAL slabs
> +CONFIG_MEMCG=y                    # selects CONFIG_SLAB_OBJ_EXT=y
> +CONFIG_MODULES=y
> +CONFIG_MODULE_UNLOAD=y
> +# CONFIG_SLUB is the default allocator
> +```
> +
> +Tools: a kernel build toolchain (`make`, `gcc`/clang, `binutils`, `bison`,
> +`flex`, `libelf-dev`, `libssl-dev`, `bc`, `pahole`) and either
> +[virtme-ng](https://github.com/arighi/virtme-ng) or `qemu-system-x86_64`.
> +
> +## Build
> +
> +```sh
> +# 1. Build the kernel under test (with the config options above).
> +make -C /path/to/kernel -j"$(nproc)" bzImage modules
> +# ('modules' is needed so Module.symvers includes mem_alloc_profiling_key,
> +#  which kmalloc() references when profiling is compiled in.)
> +
> +# 2. Build the reproducer module against that kernel.
> +make -C /path/to/kernel M="$PWD" modules   # produces repro_objext.ko
> +```
> +
> +## Run
> +
> +Boot the kernel with two boot-cmdline parameters:
> +
> +```
> +slub_min_objects=64            # forces kmalloc-512=64 objs/slab and
> +                               # kmalloc-1k=32 objs/slab -> the cross-cycle geometry
> +sysctl.vm.mem_profiling=1      # enables profiling at boot; a runtime
> +                               # `echo 1 > /proc/sys/vm/mem_profiling` is REJECTED
> +                               # unless CONFIG_MEM_ALLOC_PROFILING_ENABLED_BY_DEFAULT=y
> +                               # or this boot param is set.
> +```
> +
> +With virtme-ng:
> +
> +```sh
> +cd /path/to/kernel
> +vng --cpus 8 -m 12G -a "slub_min_objects=64 sysctl.vm.mem_profiling=1" \
> +    -- bash /path/to/run_repro.sh /path/to/repro_objext.ko
> +```
> +
> +Or, by hand inside any guest booted with the params above:
> +
> +```sh
> +insmod repro_objext.ko n=2000000 rounds=4 shrink=1 keep=0 shrink_iters=8
> +for i in $(seq 1 80); do
> +  for c in kmalloc-128 kmalloc-256 kmalloc-512 kmalloc-1k kmalloc-2k kmalloc-4k; do
> +    echo 1 > /sys/kernel/slab/$c/shrink 2>/dev/null
> +  done
> +done
> +cat /sys/kernel/slab/kmalloc-512/objects
> +cat /sys/kernel/slab/kmalloc-1k/objects
> +```
> +
> +The module returns `-ECANCELED` on purpose (it does all its work in init and
> +then unloads itself); the `insmod: Operation canceled` message is expected.
> +
> +## Expected results
> +
> +Verify the geometry printed by the driver is `k512 objs=64` and `k1k objs=32`
> +and `profiling_runtime=1`; otherwise the cross-cycle is not exercised.
> +
> +- **Buggy kernel** (cross-cycle not fixed): after the shrink storm,
> +  `kmalloc-512`/`kmalloc-1k` stay pinned at thousands of objects (e.g. ~8000),
> +  far above the pre-insmod baseline. At production scale/geometry the same
> +  condition overflows the kernel stack instead.
> +- **Fixed kernel**: object counts return to the pre-insmod baseline (a few
> +  hundred); no leak, no recursion.
> +
> +## Module parameters
> +
> +| param          | default   | meaning                                                   |
> +|----------------|-----------|-----------------------------------------------------------|
> +| `n`            | 2000000   | objects per size class per round                          |
> +| `rounds`       | 4         | warm-up rounds to build obj_exts density                  |
> +| `keep`         | 0         | keep 1-in-`keep` objects live per round (0 = free all)    |
> +| `shrink`       | 1         | hammer `kmem_cache_shrink` via sysfs after the churn      |
> +| `shrink_iters` | 8         | shrink passes per round                                   |
> +| `size_lo`      | 384       | small request size (-> kmalloc-512)                       |
> +| `size_hi`      | 768       | large request size (-> kmalloc-1k)                        |
> diff --git a/repro_public/repro_objext.c b/repro_public/repro_objext.c
> new file mode 100644
> index 000000000000..01a53693dbef
> --- /dev/null
> +++ b/repro_public/repro_objext.c
> @@ -0,0 +1,180 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * repro_objext.c — reproduce the SLUB obj_exts free-recursion stack overflow.
> + *
> + * Bug: with CONFIG_MEM_ALLOC_PROFILING=y and vm.mem_profiling on,
> + * every KMALLOC_NORMAL slab gets a slabobj_ext (obj_exts) vector allocated from
> + * another KMALLOC_NORMAL slab. sizeof(slabobj_ext)==16, so kmalloc-1k's vector
> + * (objs*16) lands in kmalloc-512 and kmalloc-512's vector lands in kmalloc-1k ->
> + * cross-referencing chains and a kmalloc-1k<->kmalloc-512 2-cycle. When many such
> + * slabs are discarded (per-cpu partial flush __put_partials, or kmem_cache_shrink),
> + * __free_slab()->unaccount_slab()->free_slab_obj_exts()->kfree(vector) empties the
> + * slab that holds the vector, which discards THAT slab, recursing without bound and
> + * overflowing the 16 KiB task stack (VMAP guard page).
> + *
> + * Boot: append `sysctl.vm.mem_profiling=1` (or =1,compressed) to the kernel cmdline,
> + * OR echo 1 > /proc/sys/vm/mem_profiling before insmod.
> + *
> + * WITHOUT fix: "BUG: TASK stack guard page was hit" recursion -> panic/hang/reboot;
> + *              "REPRODUCER DONE" is NEVER printed (note: the overflow may also
> + *              corrupt the console TX path, so the box may just die silently —
> + *              treat a VM that never prints DONE / dies / reboots as a CRASH).
> + * WITH fix:    no obj_exts on KMALLOC_NORMAL slabs -> no recursion ->
> + *              "REPRODUCER DONE no-crash" printed, insmod returns (module unloads).
> + *
> + * Tunables (module params):
> + *   n         objects per size class per round (default 2,000,000)
> + *   rounds    warm-up rounds to build obj_exts density (default 4)
> + *   keep      keep 1-in-`keep` objects live after each round to leave slabs at low
> + *             occupancy (denser cross-referenced partial slabs). 0 = free all.
> + *   shrink    after the churn, hammer kmem_cache_shrink via
> + *             /sys/kernel/slab/<cache>/shrink to force the discard cascade.
> + *   sizes_lo/sizes_hi  the two kmalloc request sizes (default 768 -> kmalloc-1k,
> + *             384 -> kmalloc-512).
> + */
> +#include <linux/module.h>
> +#include <linux/slab.h>
> +#include <linux/vmalloc.h>
> +#include <linux/kernel.h>
> +#include <linux/fs.h>
> +#include <linux/uaccess.h>
> +#include <linux/delay.h>
> +
> +static unsigned long n = 2000000;
> +module_param(n, ulong, 0444);
> +MODULE_PARM_DESC(n, "objects per size class per round");
> +
> +static unsigned int rounds = 4;
> +module_param(rounds, uint, 0444);
> +MODULE_PARM_DESC(rounds, "warm-up rounds");
> +
> +static unsigned int keep;
> +module_param(keep, uint, 0444);
> +MODULE_PARM_DESC(keep, "keep 1-in-keep objects live after each round (0=free all)");
> +
> +static unsigned int shrink = 1;
> +module_param(shrink, uint, 0444);
> +MODULE_PARM_DESC(shrink, "hammer kmem_cache_shrink via sysfs after churn");
> +
> +static unsigned int shrink_iters = 8;
> +module_param(shrink_iters, uint, 0444);
> +MODULE_PARM_DESC(shrink_iters, "how many shrink passes");
> +
> +static unsigned int size_lo = 384;	/* -> kmalloc-512 */
> +module_param(size_lo, uint, 0444);
> +static unsigned int size_hi = 768;	/* -> kmalloc-1k  */
> +module_param(size_hi, uint, 0444);
> +
> +static void **a;	/* kmalloc-1k (size_hi) */
> +static void **b;	/* kmalloc-512 (size_lo) */
> +
> +static void echo_to(const char *path, const char *val)
> +{
> +	struct file *f;
> +	loff_t pos = 0;
> +
> +	f = filp_open(path, O_WRONLY, 0);
> +	if (IS_ERR(f))
> +		return;
> +	kernel_write(f, val, strlen(val), &pos);
> +	filp_close(f, NULL);
> +}
> +
> +/* Force kmem_cache_shrink on the two caches: walks partial lists and discards
> + * empty slabs -> discard_slab -> __free_slab -> free_slab_obj_exts -> kfree.
> + * If the freed obj_exts vectors cross-reference, the recursion fires here. */
> +static void do_shrink(void)
> +{
> +	unsigned int i;
> +	char p1[64], p2[64];
> +
> +	snprintf(p1, sizeof(p1), "/sys/kernel/slab/kmalloc-1k/shrink");
> +	snprintf(p2, sizeof(p2), "/sys/kernel/slab/kmalloc-512/shrink");
> +	for (i = 0; i < shrink_iters; i++) {
> +		echo_to(p1, "1\n");
> +		echo_to(p2, "1\n");
> +	}
> +	/* also the cg variants if present (harmless if absent) */
> +	echo_to("/sys/kernel/slab/kmalloc-rnd-08-1k/shrink", "1\n");
> +	echo_to("/sys/kernel/slab/kmalloc-rnd-07-512/shrink", "1\n");
> +}
> +
> +static void do_round(unsigned long cnt, bool last)
> +{
> +	unsigned long i;
> +
> +	for (i = 0; i < cnt; i++) {
> +		a[i] = kmalloc(size_hi, GFP_KERNEL);
> +		b[i] = kmalloc(size_lo, GFP_KERNEL);
> +		if (a[i])
> +			*(volatile char *)a[i] = 1;
> +		if (b[i])
> +			*(volatile char *)b[i] = 1;
> +	}
> +	if (last)
> +		pr_emerg("REPRODUCER: allocated %lu+%lu objs, starting free-storm (keep=%u)\n",
> +			 cnt, cnt, keep);
> +
> +	/* Free-storm. If keep>0, leave 1-in-keep live to keep slabs partial &
> +	 * densely cross-referenced; those are freed only on the final round. */
> +	for (i = 0; i < cnt; i++) {
> +		if (keep && (i % keep) == 0)
> +			continue;	/* leave this one live for now */
> +		kfree(a[i]);
> +		kfree(b[i]);
> +	}
> +}
> +
> +static int __init repro_init(void)
> +{
> +	unsigned int r;
> +	unsigned long i;
> +
> +	pr_emerg("REPRODUCER START n=%lu rounds=%u keep=%u shrink=%u sizes=%u/%u mem_profiling=%d\n",
> +		 n, rounds, keep, shrink, size_lo, size_hi,
> +		 IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING));
> +
> +	a = vmalloc(n * sizeof(void *));
> +	b = vmalloc(n * sizeof(void *));
> +	if (!a || !b) {
> +		pr_emerg("REPRODUCER: vmalloc failed, reduce n=\n");
> +		goto out;
> +	}
> +
> +	for (r = 0; r < rounds; r++) {
> +		do_round(n, r == rounds - 1);
> +		if (shrink)
> +			do_shrink();
> +	}
> +
> +	/* Free everything that was kept live, then shrink hard: this is the
> +	 * discard-cascade moment most likely to hit the recursion. */
> +	if (keep) {
> +		pr_emerg("REPRODUCER: freeing kept-live objects then shrinking\n");
> +		for (i = 0; i < n; i++) {
> +			if ((i % keep) == 0) {
> +				kfree(a[i]);
> +				kfree(b[i]);
> +			}
> +		}
> +	}
> +	if (shrink) {
> +		pr_emerg("REPRODUCER: final shrink storm\n");
> +		do_shrink();
> +	}
> +
> +	pr_emerg("REPRODUCER DONE no-crash (fix present)\n");
> +out:
> +	vfree(a);
> +	vfree(b);
> +	/* Return error so the module unloads itself; the test only needs init. */
> +	return -ECANCELED;
> +}
> +
> +static void __exit repro_exit(void) { }
> +
> +module_init(repro_init);
> +module_exit(repro_exit);
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Reproducer for SLUB obj_exts free-recursion stack overflow");
> +
> diff --git a/repro_public/run_repro.sh b/repro_public/run_repro.sh
> new file mode 100755
> index 000000000000..08c7e57014bc
> --- /dev/null
> +++ b/repro_public/run_repro.sh
> @@ -0,0 +1,26 @@
> +#!/bin/bash
> +# Branch reproducer driver. Arg1 = path to repro_objext.ko built against this kernel.
> +# All diagnostics go to /dev/kmsg so they survive in the dmesg dump (vng stdout is lossy).
> +set +e
> +KO="$1"
> +L(){ echo "BT| $*" > /dev/kmsg 2>/dev/null; }
> +k(){ awk '{print $1}' /sys/kernel/slab/$1/objects 2>/dev/null; }
> +g(){ cat /sys/kernel/slab/$1/$2 2>/dev/null; }
> +L "===== BRANCHTEST START ====="
> +L "uname=$(uname -r)"
> +L "cmdline=$(cat /proc/cmdline)"
> +echo 1 > /proc/sys/vm/mem_profiling 2>/dev/null
> +L "profiling_runtime=$(cat /proc/sys/vm/mem_profiling 2>/dev/null)"
> +L "GEOM k512 objs=$(g kmalloc-512 objs_per_slab) ord=$(g kmalloc-512 order) | k1k objs=$(g kmalloc-1k objs_per_slab) ord=$(g kmalloc-1k order) | k2k objs=$(g kmalloc-2k objs_per_slab) | k256 objs=$(g kmalloc-256 objs_per_slab)"
> +L "noobjext_caches=$(ls -d /sys/kernel/slab/*no-objext* 2>/dev/null | wc -l)"
> +L "BEFORE k512=$(k kmalloc-512) k1k=$(k kmalloc-1k)"
> +insmod "$KO" n=2000000 rounds=4 shrink=1 keep=0 shrink_iters=8
> +L "insmod_rc=$?"
> +# extra external shrink storm to force the discard cascade
> +for i in $(seq 1 80); do for c in kmalloc-128 kmalloc-256 kmalloc-512 kmalloc-1k kmalloc-2k kmalloc-4k; do echo 1 > /sys/kernel/slab/$c/shrink 2>/dev/null; done; done
> +sleep 1
> +L "AFTER k512=$(k kmalloc-512) k1k=$(k kmalloc-1k)"
> +L "===== BRANCHTEST END ====="
> +echo "=====DMESG DUMP====="
> +dmesg | grep -E "BT\||REPRODUCER|stack guard|BUG:|Oops|Call Trace|Kernel panic|guard page"
> +echo "=====BRANCHTEST_DONE====="


Thanks for sharing the full reproducer. I'll study it and reproduce the 
issue,

which helps me understand the problem greatly.


Thanks

Best Regards

Hao




