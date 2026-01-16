Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 825ADC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 16:21:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BC36B009E; Fri, 16 Jan 2026 11:21:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E09816B009F; Fri, 16 Jan 2026 11:21:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CEB746B00A0; Fri, 16 Jan 2026 11:21:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BD9DC6B009E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 11:21:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A5881AD9B9
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:21:34 +0000 (UTC)
X-FDA: 84338342508.20.7687517
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id CF7104000E
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 16:21:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WEy73lKF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768580492; a=rsa-sha256;
	cv=none;
	b=2LOFdmnLbJt9jlZDKMmSa7VbUwkXk/CMfyCH81WNfJ8S6s4r68ne9hs8SHrle5tSWGikFe
	cznqtA9jNMWKfN3w1yqlo+HQ1yvYObudLJkeVQqrBx0ycR8akt8fkO/EV3XeeAQc+ovtbL
	Kc6qtrlpAihHdaiDA3OAUMuHNKdgkaU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WEy73lKF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768580492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wU02D3AuSYoipfiyxtuKzwahfFEJ5U5cyLoFJwWUhds=;
	b=tOgHOk+CHSCBfPWvna5AGfDLqJbkUz03FjM8scaWGXUr1eltDIde320X44auSh8ZK5lnAT
	+dGIP9UWdYscmvK084gIDqqXzyPKdBC6BQ8ixA3CUTowYIiom4ctxg8LNaGYHlQIKeCniA
	JG7cZoQHToN58ZyYEwPrCECdd2TU3tU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D1D90601B9;
	Fri, 16 Jan 2026 16:21:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4FFC16AAE;
	Fri, 16 Jan 2026 16:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768580491;
	bh=NOCir8rPfAIQt6v7dI5do8gQE0TlAVf0w/j9ivkNyoA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=WEy73lKFMrRCN73iQS4oWwJwJsqakNAtuXhvrkpcc8ARMH1h5I+ATLsEyQEzdCTan
	 tTEVqI+x3UE8bHCwufI71/rkNYwqFHV0ZZlVlioySeReu0++Q7Ti1TZkm6hTTHqPVp
	 B4N1RUuhoANDlLiyAep700/vHLW5I+bJoJIjpH8KxNNgOBhrDJ18LFBqTm+Kb0c7SN
	 JXt8Pf3b4ngvIzVue+gl2659ZXMNCx1R1JDOHfJnsv9reyDWQoUPrKx2a5rZlUCJau
	 dpLJMQ4fsbmiK9FiMUyxraobrEQsJFWGE+z9AebnL4PEBkcyn/vTuplbxi52IWAu19
	 mAnBNn93aukvw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  akpm@linux-foundation.org,
  rppt@kernel.org,  graf@amazon.com,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  pratyush@kernel.org,
  ricardo.neri-calderon@linux.intel.com,  kernel-team@meta.com
Subject: Re: [PATCH v4] kho: validate preserved memory map during population
In-Reply-To: <jixxiqeajngwox3nh2u3pwf2rivhmqxxmpyttqxu32pixshyde@4jdn5jvg5hvk>
	(Breno Leitao's message of "Thu, 8 Jan 2026 10:03:14 -0800")
References: <20251223140140.2090337-1-pasha.tatashin@soleen.com>
	<jixxiqeajngwox3nh2u3pwf2rivhmqxxmpyttqxu32pixshyde@4jdn5jvg5hvk>
Date: Fri, 16 Jan 2026 16:21:28 +0000
Message-ID: <2vxzo6mt7cl3.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF7104000E
X-Stat-Signature: 4wqrcu4cy59wcgabgncbxt8s9ft5ju91
X-Rspam-User: 
X-HE-Tag: 1768580492-249710
X-HE-Meta: U2FsdGVkX1/D5pBYFIdw8hvylbP8qcsia5HIaJKxBQP43sgkTh0nvY2UqQksI+/RIR/Z7RT9Gwk8eU11IIjDRCv4o4p5ewphKp/BGAShddaMdprh2oKmBlab4PsMnxqZ35gkIacj+U/LV+G6NXU/rjjQOvS5NVapyNLwKd+TO/lVgLiMQby9oZ49Ji2UrnoARbaiBCMK5JPO4ZB4OGrh0SwVZ3Ch/FJJ5sFBWjVuWn/FmXPyQ2vWlF4PtacAGXMOmTJ803ElI6czK/wnIuiOSJYrY7/BTP8oCeD0pODSM2zLFddZEVsF6g/UgzV6NblhpbJJA5vxZKT0IGHrOrjSwvGXOjNkvwWOHm9dq5pEQCEegA+/HEUYUMoSEkfmxo/lL7RbJ+YADn2TsG2c7gnPM2ulriBFnpnCnblUSw/n/Pxrhstt3osCLfo2ZsVX9cxVs+a/T+DzftAsBm22feI/U5jV/NxEHdBDjKbKtvaCduR6XWps+hr/WQlZ2llmjOMmVuZaj8jTtfyN4J2eGqcre/z4KV7IdzdAd0QU7KkJjbQI0g5e2jAyiKSXS/Hs2WZ5RI7WUay9BoczBxJZT7p0gAcXQ2kFeuu0p3qHdVS39PTBD/MN8aOvaYBbuBs8jRUfqozAknrcA3+uKScvw57gP0q0bUvIqFbdP/Rb3vYFHThjVfLS3l94MWuC5i+2VZMCogTMZ3VcLfVmBbQjDtSkExwHE/RrXhiYNLkoLp3KmotHnJ33MPrcfJ7W0BcGV2bX3SQ4PPVr36oSNRWJOWZWEoE+IJ/j7/WQ7Z1JhNSZ5EYxM2Le/J/1eurHy93uEk+peXVJM7J/+CFZGsRKFWcjIU6SAUXqWB60rhGmKclxLiW9qXoT+s2U46BJoS+tU9fUvz0g64UkcJYEufM7X6x4yj9o3Wqlvf6vLsd2FT94pEmiW4O3EkEHiJUFEDEyAyn8VM+ALfIeYdrNXWvqfSG
 0LmAddxy
 adJSXlNSVFFRNbybGoFpL7aeAy+ZHa5SQxq1zocUrFe7fbwhTT/46TRw8gLHOmr8eaEs74Q3M2sgjw9bCVJPuwjRGnZG9UGXbPr3X4kjChkHkP7FxJWDvDfNAVsngaK/aAIFTHzWTpIa+cIODrtxFevsnxN91paTmxib5SZOsZ0pzvB4U9BGE8X1WyuqSs6paeGz1mSFv/xJ4eMtfkOrjdufnUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Breno,

On Thu, Jan 08 2026, Breno Leitao wrote:

> Hello Pasha,
>
> On Tue, Dec 23, 2025 at 09:01:40AM -0500, Pasha Tatashin wrote:
>> If the previous kernel enabled KHO but did not call kho_finalize()
>> (e.g., CONFIG_LIVEUPDATE=n or userspace skipped the finalization step),
>> the 'preserved-memory-map' property in the FDT remains empty/zero.
>> 
>> Previously, kho_populate() would succeed regardless of the memory map's
>> state, reserving the incoming scratch regions in memblock. However,
>> kho_memory_init() would later fail to deserialize the empty map. By that
>> time, the scratch regions were already registered, leading to partial
>> initialization and subsequent list corruption (freeing scratch area
>> twice) during kho_init().
>
> While trying my new patchset [0] on top of this patch, I got the
> following issue:
>
> 	[    0.000000] KHO: disabling KHO revival: -2
>
> Trying to solve it, I come up with a change in kho_get_mem_map_phys() to
> distinguish no memory and error, see the patch attached later.
>
> This is what I used to test [0] on top of linux-next. Is this useful?
>
> Link: https://lore.kernel.org/all/20260108-kho-v3-1-b1d6b7a89342@debian.org/ [0]
>
> thanks
> --breno
>
> commit 5d7855fede8110d74942e1b67056ba589a1cb54a
> Author: Breno Leitao <leitao@debian.org>
> Date:   Thu Jan 8 07:44:08 2026 -0800
>
>     kho: allow KHO to work when no memory is preserved
>     
>     Fix KHO initialization failing when no memory pages were preserved by
>     the previous kernel.
>     
>     Commit eda79a683a0a ("kho: validate preserved memory map during
>     population") introduced kho_get_mem_map_phys() which returns the physical
>     address of the preserved memory map directly as its return value. The
>     caller then validates it with:
>     
>         mem_map_phys = kho_get_mem_map_phys(fdt);
>         if (!mem_map_phys) {
>             err = -ENOENT;
>             goto out;
>         }
>     
>     This creates an ambiguity: physical address 0 is used both as an error
>     indicator (property missing/malformed) and as a valid value (property
>     exists with value 0, meaning no memory was preserved).
>     
>     "No memory preserved" is a legitimate state. KHO provides features beyond
>     memory page preservation, such as previous kernel version tracking and
>     kexec count tracking. When the previous kernel enables KHO but doesn't
>     preserve any memory pages, it sets 'preserved-memory-map' to 0. This is
>     semantically different from "KHO not initialized" - it means "KHO is
>     active, there's just nothing in the memory map."

This isn't true. If you hand over _any_ state, you will at least need
the KHO FDT. And the KHO FDT is preserved memory (see the
kho_alloc_preserve() call in kho_init()). So I don't see how you can
ever have valid KHO with no memory.

mem_map_phys _can_ be 0, but only when KHO was enabled but not used. And
that is of course also a valid use case.

We want to treat mem_map_phys == 0 the same as the error path, just
without the error print. This lets us discard all previous scratch areas
since they don't have anything useful anyway, and have a fresh start.

So while you are seeing this error message, I don't think it should
break anything and KHO should still be working fine. You can
double-check this by inspecting /sys/kernel/debug/kho/out.

So I think the patch is certainly a useful fix, it just needs some
re-wording and fixups.

Some comments on the code below.

>     
>     Before eda79a683a0a, the code handled this gracefully in
>     kho_mem_deserialize():
>     
>         chunk = mem ? phys_to_virt(mem) : NULL;
>         if (!chunk)
>             return false;  // No pages, but KHO could still work
>     
>     After eda79a683a0a, the early validation conflated "no property" with
>     "property value is 0", causing KHO to be completely disabled in both
>     cases.
>     
>     Fix this by changing kho_get_mem_map_phys() to return an error code and
>     pass the physical address via pointer. This allows distinguishing between:
>      - Property missing/malformed: return -ENOENT (KHO fails)
>      - Property exists with value 0: return 0 (KHO succeeds, no memory to
>        restore)
>     
>     Fixes: eda79a683a0a ("kho: validate preserved memory map during population")
>     Signed-off-by: Breno Leitao <leitao@debian.org>
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 271d90198a08..3cf2dc6840c9 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -471,8 +471,8 @@ static void __init deserialize_bitmap(unsigned int order,
>  	}
>  }
>  
> -/* Returns physical address of the preserved memory map from FDT */
> -static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
> +/* Returns 0 on success and stores physical address in *phys_out */
> +static int __init kho_get_mem_map_phys(const void *fdt, phys_addr_t *phys_out)
>  {
>  	const void *mem_ptr;
>  	int len;
> @@ -480,10 +480,11 @@ static phys_addr_t __init kho_get_mem_map_phys(const void *fdt)
>  	mem_ptr = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
>  	if (!mem_ptr || len != sizeof(u64)) {
>  		pr_err("failed to get preserved memory bitmaps\n");
> -		return 0;
> +		return -ENOENT;
>  	}
>  
> -	return get_unaligned((const u64 *)mem_ptr);
> +	*phys_out = get_unaligned((const u64 *)mem_ptr);
> +	return 0;
>  }
>  
>  static void __init kho_mem_deserialize(struct khoser_mem_chunk *chunk)
> @@ -1439,7 +1440,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  			 phys_addr_t scratch_phys, u64 scratch_len)
>  {
>  	struct kho_scratch *scratch = NULL;
> -	phys_addr_t mem_map_phys;
> +	phys_addr_t mem_map_phys = 0;
>  	void *fdt = NULL;
>  	int err = 0;
>  	unsigned int scratch_cnt = scratch_len / sizeof(*kho_scratch);
> @@ -1466,11 +1467,9 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  		goto out;
>  	}
>  
> -	mem_map_phys = kho_get_mem_map_phys(fdt);
> -	if (!mem_map_phys) {
> -		err = -ENOENT;
> +	err = kho_get_mem_map_phys(fdt, &mem_map_phys);
> +	if (err)

This will break when mem_map_phys == 0. As I explained earlier, when
that happens we want to discard all previous scratch info and start with
a clean slate.

Making this if (err || !mem_map_phys) should do the trick. The if (err)
check before the print should make sure the error message is not printed
when we have a valid property but its value is 0.

>  		goto out;
> -	}
>  
>  	scratch = early_memremap(scratch_phys, scratch_len);
>  	if (!scratch) {

-- 
Regards,
Pratyush Yadav

