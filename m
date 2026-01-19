Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFEAFCA5FF5
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 07:05:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20D0A6B0122; Mon, 19 Jan 2026 02:05:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E1FB6B0123; Mon, 19 Jan 2026 02:05:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10F236B0124; Mon, 19 Jan 2026 02:05:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id F3C206B0122
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:05:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C97801A0695
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:05:23 +0000 (UTC)
X-FDA: 84347827326.11.C5541C6
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id F3CDAA0003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:05:21 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EvclKCuZ;
	spf=pass (imf25.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768806322; a=rsa-sha256;
	cv=none;
	b=EbSW75vCI8JSpYATXg7FiV97Xk8BtrpWAMwB4aTgIABuidrU40ujIbWf/HvcNiXXLpj98s
	FpF5WIgTwimi48iCStKbVQpdbIs99hP38rB0TWEG777HrregFmvFYIJUskbqPP4sbghN1N
	g+047+XI8xUMHClQjFXyD54a6n/Uihg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EvclKCuZ;
	spf=pass (imf25.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768806322;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bb3xkMpeNpnybd9Na8Isc5XENxO7ZKbU0IXQYY84igE=;
	b=lJlweFUd6FVU5tdMMIYre1D+pgewUlQVgBhAkzX/H11tQ92OZke9pE9eEAx7wpqI9XXi42
	uEcxTyN1IgsQFX31weGaswg/ztVxyaUC4H+9pT/53I/xR3kki+YGmypFwDNNka3j81bs7U
	+mv2fFrEzb8arGodJKsdfRYhaMiqrDE=
Message-ID: <4f7e180d-f7bb-4a21-ae2b-f42cc969401d@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768806319;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bb3xkMpeNpnybd9Na8Isc5XENxO7ZKbU0IXQYY84igE=;
	b=EvclKCuZlg7ifGbmHKL+RgT9befhs9UroGPdqC0TP0IrHcmdjq9+EpZElp1YHgXCPiJOqW
	7jzdt7ISwzQe3wrIIT70lxeL53lrGIAO9uNztt6xjt+fBF5mtZcojqTM+XY+8uVo3JYubs
	fUY1C5COy2sskFonjvKYshEUIVRZ1NA=
Date: Sun, 18 Jan 2026 23:04:58 -0800
MIME-Version: 1.0
Subject: Re: [PATCH v4] kho: validate preserved memory map during population
To: Pasha Tatashin <pasha.tatashin@soleen.com>, akpm@linux-foundation.org,
 rppt@kernel.org, graf@amazon.com, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-mm@kvack.org, pratyush@kernel.org,
 ricardo.neri-calderon@linux.intel.com
References: <20251223140140.2090337-1-pasha.tatashin@soleen.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zhu Yanjun <yanjun.zhu@linux.dev>
In-Reply-To: <20251223140140.2090337-1-pasha.tatashin@soleen.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F3CDAA0003
X-Stat-Signature: qcxrf4hhy5rhzbuexxutj8dhnyqu4mj3
X-Rspam-User: 
X-HE-Tag: 1768806321-452219
X-HE-Meta: U2FsdGVkX1/znbMGKpFKaXzF/3qfSzzXZ86A4jz6ZTGRqlQgQslLY3QFLR5oSR48rYEvqNoOhx8IA1onBNmJG2Cpw84qgOjdbgA1aOHZutdeXMv+ZyA3tXz/jyqOiahtNw4sKBj8uinJCWeh0Z7IiO12KNwWLUvKBk1C2UyNb79DW32tzj3mS/sVXSs46e8EY2s3y0fvNkocflLs6WCo4hagCExSrTmtFlcj/nMd2pGLR4aaYILGjWfXoP7/LGWsnAWQ4Q/5VhYfJX+270kWbnhDKcKuYMQ2MPqm6wcNk/R0qgdUDfgWEyLg3dyjq2lNjDJNrWSnqepcORhceaIuj5Fx9WHsaJ+CgHb1RrNSM+jnu3smiXooeq8dcP1DHn9Hx8jepfEvuTtZ5UORdqUPkcbmlDoKEFQcbddCi9VqGQhNsZkxflQk4uLkfOxFZCuc/xV5pMjz5tjfxrliCxehpsQKYfpUmYr/zq6DDUmDahbvMGYwRXMoOrAbmR1uyAi4u02CaFIVy32OyCzEaP23A0emIffgIYqVlwbZBYCFlwplrS/kUJdqXRsNtydA3aV8jKL+Vr1FwB31gaH69MUlrnZNKNRwE9wcXO7ScrJj1p9/M9ZpVWP3lK8SDzqg4toPHQeic0qYtYfQ5fK/2547eQKQlJD2l2y+voxJHniCgLe5PG5Gu3mD63kCkxlkPZf2+PgB9roBbEQpbydjd3zA3pDBYF18UebsitRK09+llrnseOzpEMw59EcugRoCR+r7N6v2rCoXIKj2aV8tOhc9pbOAneqw3TqjvmHF3ji6jeuQG3RtW3Os841S/Zxt5Js0EFWBjnHSqaMhWeppkzQxGcyNHSXoybuEz1kHJyt2qUP0yPDei4djHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

在 2025/12/23 6:01, Pasha Tatashin 写道:
> If the previous kernel enabled KHO but did not call kho_finalize()
> (e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
> the 'preserved-memory-map' property in the FDT remains empty/zero.
> 
> Previously, kho_populate() would succeed regardless of the memory map's
> state, reserving the incoming scratch regions in memblock. However,
> kho_memory_init() would later fail to deserialize the empty map. By that
> time, the scratch regions were already registered, leading to partial
> initialization and subsequent list corruption (freeing scratch area
> twice) during kho_init().
> 
> Move the validation of the preserved memory map earlier into
> kho_populate(). If the memory map is empty/NULL:
> 1. Abort kho_populate() immediately with -ENOENT.
> 2. Do not register or reserve the incoming scratch memory, allowing the new
>     kernel to reclaim those pages as standard free memory.
> 3. Leave the global 'kho_in' state uninitialized.
> 
> Consequently, kho_memory_init() sees no active KHO context
> (kho_in.mem_chunks_phys is 0) and falls back to kho_reserve_scratch(),
> allocating fresh scratch memory as if it were a standard cold boot.
> 
> Fixes: de51999e687c ("kho: allow memory preservation state updates after finalization")
> Reported-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
> Closes: https://lore.kernel.org/all/20251218215613.GA17304@ranerica-svr.sc.intel.com
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Tested-by: Ricardo Neri <ricardo.neri-calderon@linux.intel.com>
> ---
> Changes v4:
> - Addressed Tested-by
> - Addressed review comments from Pratyush.
> 
>   kernel/liveupdate/kexec_handover.c | 37 +++++++++++++++---------------
>   1 file changed, 19 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 9dc51fab604f..d4482b6e3cae 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -460,27 +460,23 @@ static void __init deserialize_bitmap(unsigned int order,
>   	}
>   }
>   
> -/* Return true if memory was deserizlied */
> -static bool __init kho_mem_deserialize(const void *fdt)
> +/* Returns physical address of the preserved memory map from FDT */
> +static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
>   {
> -	struct khoser_mem_chunk *chunk;
>   	const void *mem_ptr;
> -	u64 mem;
>   	int len;
>   
>   	mem_ptr = fdt_getprop(fdt, 0, PROP_PRESERVED_MEMORY_MAP, &len);
>   	if (!mem_ptr || len != sizeof(u64)) {
>   		pr_err("failed to get preserved memory bitmaps\n");
> -		return false;
> +		return 0;
>   	}
>   
> -	mem = get_unaligned((const u64 *)mem_ptr);
> -	chunk = mem ? phys_to_virt(mem) : NULL;
> -
> -	/* No preserved physical pages were passed, no deserialization */
> -	if (!chunk)
> -		return false;
> +	return get_unaligned((const u64 *)mem_ptr);
> +}
>   
> +static void __init kho_mem_deserialize(struct khoser_mem_chunk *chunk)
> +{
>   	while (chunk) {
>   		unsigned int i;
>   
> @@ -489,8 +485,6 @@ static bool __init kho_mem_deserialize(const void *fdt)
>   					   &chunk->bitmaps[i]);
>   		chunk = KHOSER_LOAD_PTR(chunk->hdr.next);
>   	}
> -
> -	return true;
>   }
>   
>   /*
> @@ -1253,6 +1247,7 @@ bool kho_finalized(void)
>   struct kho_in {
>   	phys_addr_t fdt_phys;
>   	phys_addr_t scratch_phys;
> +	phys_addr_t mem_map_phys;
>   	struct kho_debugfs dbg;
>   };
>   
> @@ -1434,12 +1429,10 @@ static void __init kho_release_scratch(void)
>   
>   void __init kho_memory_init(void)
>   {
> -	if (kho_in.scratch_phys) {
> +	if (kho_in.mem_map_phys) {
>   		kho_scratch = phys_to_virt(kho_in.scratch_phys);
>   		kho_release_scratch();
> -
> -		if (!kho_mem_deserialize(kho_get_fdt()))
> -			kho_in.fdt_phys = 0;
> +		kho_mem_deserialize(phys_to_virt(kho_in.mem_map_phys));
>   	} else {
>   		kho_reserve_scratch();
>   	}
> @@ -1448,8 +1441,9 @@ void __init kho_memory_init(void)
>   void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>   			 phys_addr_t scratch_phys, u64 scratch_len)
>   {
> -	void *fdt = NULL;
>   	struct kho_scratch *scratch = NULL;
> +	phys_addr_t mem_map_phys;
> +	void *fdt = NULL;
>   	int err = 0;
>   	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
>   
> @@ -1475,6 +1469,12 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>   		goto out;
>   	}
>   
> +	mem_map_phys = kho_get_mem_map_phys(fdt);
> +	if (!mem_map_phys) {
> +		err = -ENOENT;
> +		goto out;
> +	}
> +
>   	scratch = early_memremap(scratch_phys, scratch_len);
>   	if (!scratch) {
>   		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
> @@ -1515,6 +1515,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>   
>   	kho_in.fdt_phys = fdt_phys;
>   	kho_in.scratch_phys = scratch_phys;
> +	kho_in.mem_map_phys = mem_map_phys;
>   	kho_scratch_cnt = scratch_cnt;
>   	pr_info("found kexec handover data.\n");
>   
> 
> base-commit: cc3aa43b44bdb43dfbac0fcb51c56594a11338a8
The base-commit is

commit cc3aa43b44bdb43dfbac0fcb51c56594a11338a8 (HEAD -> 
upstream/master, tag: next-20251219)
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Fri Dec 19 14:12:19 2025 +1100

     Add linux-next specific files for 20251219

     Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

Now this commit can not be applied to the 6.19-rc5.

Zhu Yanjun

