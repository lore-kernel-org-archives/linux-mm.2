Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B19C7C9830C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 15:40:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2F606B0440; Tue, 20 Jan 2026 10:40:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF0466B0442; Tue, 20 Jan 2026 10:40:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFF0A6B0443; Tue, 20 Jan 2026 10:40:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDF8F6B0440
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:40:18 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30480BA5A6
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:40:18 +0000 (UTC)
X-FDA: 84352753716.21.FB341BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9D72A1C0006
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:40:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xakh/0A+";
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768923616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IW7QWn6JL0RwdL3zwoGz2swVZ83QFuVyY00wIq8n19Q=;
	b=5ccv7SrjH7a3QpbNsPw575ryZ4MgdSpo1biulihB6Fq3ziENwfpUaRRnYQeaTtEBx5qB2I
	B2Y/NlMHKSm8mi6rX4qdstDx2gIWew8RXxgzJFD+NYENkpDz7QqMbfHdlrfE3yONcGwpC/
	blO7mlrkWXFc040jUBkG5gt3II7TCF0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Xakh/0A+";
	spf=pass (imf20.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768923616; a=rsa-sha256;
	cv=none;
	b=8pnOavQ3QpX4b2A25kO+D81U2vOeq5ovF4tJIWf30tBuzCcE4O81XFWc7kxWK9A2T2wt1L
	eqnLt2D5uoy1/jyA+YkrMaRGGWs5oUGwGn6pPiQ4jJsiP+YlWXWljKcEXUsxzT5JAqLH1p
	Fs1quEnefFvTlK0A/HqgcuiwJAsPMu4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CC7560010;
	Tue, 20 Jan 2026 15:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA06C16AAE;
	Tue, 20 Jan 2026 15:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768923615;
	bh=XFFzzyZSUruiv8f4AcuaPh9t+1U5dJ6/iPk2wc0hEsA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Xakh/0A+63sAKspk3ekVV4qVSQqA4ZkFNTAe6ENLfgNFCrPITL6jO50SQ0pLdgr7F
	 iREgsqYGFnLylulaAbdlY1tMhiYhBVR/515TqsSkik7ZDxPuYbciM1xtY9iqS4A1NF
	 2YmaryZOlTR2HE9eZGtHhyrlp2nR4keSmLx58H8r25723+kvWZgXcObQFr7qGJwsP/
	 RxLxFdkSWANPFCf4199rujL609uHcH1+W4vut3R/FFvWSgBzIb8kAJB1PFMkmJyvHy
	 6dC0UYF2IqbvlmV4iC+YvoxpENKvOzX0nhDWx7Fc0KrhgeG+w7RQS8Vmkdepqu0kLp
	 WS4YJXYbUxMfw==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Mike Rapoport <rppt@kernel.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  rmikey@meta.com,  clm@fb.com,  riel@surriel.com,  kernel-team@meta.com
Subject: Re: [PATCH v3 1/2] kho: history: track previous kernel version
In-Reply-To: <v7g7nmd3jif6vftvnmucvpluevufcdxmefcgqq3yfpnzyb7mql@ojpotuu4hgxm>
	(Breno Leitao's message of "Fri, 16 Jan 2026 07:50:29 -0800")
References: <20260108-kho-v3-0-b1d6b7a89342@debian.org>
	<20260108-kho-v3-1-b1d6b7a89342@debian.org> <2vxzy0m0gfyo.fsf@kernel.org>
	<v7g7nmd3jif6vftvnmucvpluevufcdxmefcgqq3yfpnzyb7mql@ojpotuu4hgxm>
Date: Tue, 20 Jan 2026 15:40:12 +0000
Message-ID: <2vxzms28e1ib.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 6sqhzbnhi7rijz6gh1ztcr1eih69o5sp
X-Rspamd-Queue-Id: 9D72A1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768923616-841700
X-HE-Meta: U2FsdGVkX18Cyxhrj73q59zTSdL/caPBpuEgs4zCa3qZcO9P+tNoCEXsq3sQScc2r4Kwa+BV59Iezzv0gIPqB75LoGTJ/stRgQGz7TcVpKyxx9KvjeYcPZswxMaTJqm2pBcqXHG6xMDa+SG7LIi/VSNqEeS9oA1CuZS+eZO2aJIJo7vB7IeCbD3p5W4EgRd9LtZodfscbtAPDqX2AN7GIC6KBZ3RHayHp8KmxSagTtTzqW469FNFyPn+mZwgukHAzCAMyXf52kzSflZU/yEo8uu4cjTv799bYnox5JiiX+xnHYnipqK+uLunSFTu3/CWjuxBKI4irnm+pYfDXsP6r3z6IwwOxh+UCRGUjSM3ynSiDzGklQYqGVXgMrM454Dhf+aVVYFpnhkwOGoj52wb+3VgC6uOQgDC4QCytvtR7BtuW2PL7S9LvSiifQASzJUJrPEeZzUopQ04GmLQ96MX/8WjysCy/8wwbHuQt1JTv0RMg9iWMPIn9EzwU537M23ASmj3dW48Qw/rIvHQUm6uNuyxX/v27iQ2eY7dTPblvGDQad892RuOS5LxkDZHf3AEBGlTgzNb16Y3V05LeayJKWFo26mE0hcBp8Q80qR3YLukBvrEN0q5CuSFCStQ2Vcid/6KSzubG9AJGjke73yuMjGRf6j7CYuVXWNhNH4bRCLqWE41E4jJ07fdvy2Yvc4RX7a5a+J3CEpO90KSz26Rv9IWfxrJPWyaXRwlKCxqjR4DdzoF3YEVs22HXP9WYujkuxcwHdm7fiarkrjVda+2Zc3HpzzUzS0Moj+vsmXyL/jrT2hDbISAZDWibiTIViIlVvSv46Ub/iFb1WlUg6IDrdtVk7ZW0ktrMtckNX7RzKzJG3iG/fKSuoZ88i5/Fl8CSTy9M1FUCnuTGhSAWhqkF/tTvYYFeisWcCGOcFsUZ0QbTsym6fuz14I7nKYqjlImMDBqgbiBu2QA7xav5kS
 vC/kbJc0
 yvSXXs7/LUv2z81E3cT7U8jNwqQQBeH8c+uYJYzSeFlL+Jcl2atRxWfxS5jsccuQu4bqaEAGL9+TR6c+JO3JSh4y46wNMD7+V6Bi1qrFzNeIrtwPsPvqR1msNjyVfzbVERDCqO/DGfedCtQufqltl415m+0yoUzSv4Qg0Z+Ft1AEhn3c7EBT/7lC8xiUT1xlqCbtdKq8mXQDr9ZdW4MOBUzj2H/Pdh4zCM+O/g7b+rN4u81Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16 2026, Breno Leitao wrote:

> Hello Pratyush,
>
> On Wed, Jan 14, 2026 at 07:19:11PM +0000, Pratyush Yadav wrote:
>> On Thu, Jan 08 2026, Breno Leitao wrote:
>> 
>> > Store and display the kernel version from the previous kexec boot.
>> >
>> > The current kernel's release string is saved to the "previous-release"
>> > property in the KHO FDT before kexec. On the next boot, if this property
>> > exists, the previous kernel version is retrieved and printed during
>> > early boot.
>> >
>> > This helps diagnose bugs that only manifest when kexecing from specific
>> > kernel versions, making it easier to correlate crashes with the kernel
>> > that initiated the kexec.
>> 
>> The KHO FDT is ABI. So you should be bumping the version number when you
>> make changes to it.
>> 
>> But honestly, adding this "optional" stuff to the core KHO ABI makes me
>> uneasy. I say optional since it is not needed for the main functionality
>> of KHO. Making this a part of the ABI increases the surface area we
>> have. The more things we stuff in the ABI, the more inflexible it gets
>> over time.
>> 
>> Any changes to the KHO ABI means all consumers also need a version bump.
>> This includes LUO and all its users for example. So I would really like
>> to avoid adding optional things in core KHO FDT.
>> 
>> The easy fix is to add a separate subtree for the optional metadata. You
>> would still need to create an ABI for the data format, but being
>> independent of core KHO, it will make it more flexible and easier to
>> change in the future. You can keep the code in kexec_handover.c.
>
> Thanks for the feedback and guidance!
>
> I was able to hack this a bit and I came up with something like the
> follow. Is this what you have in mind?

Thanks! Yes, this looks much better. Some comments below.

>
> Author: Breno Leitao <leitao@debian.org>
> Date:   Fri Jan 16 06:42:56 2026 -0800
>
>     kho: history: track previous kernel version and kexec count
>     
>     Use Kexec Handover (KHO) to pass the previous kernel's version string
>     and the number of kexec reboots since the last cold boot to the next
>     kernel, and print it at boot time.
>     
>     Example output:
>         [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
>     
>     Motivation
>     ==========
>     
>     Bugs that only reproduce when kexecing from specific kernel versions
>     are difficult to diagnose. These issues occur when a buggy kernel
>     kexecs into a new kernel, with the bug manifesting only in the second
>     kernel.
>     
>     Recent examples include:
>     
>      * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
>      * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
>      * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")
>     
>     As kexec-based reboots become more common, these version-dependent bugs
>     are appearing more frequently. At scale, correlating crashes to the
>     previous kernel version is challenging, especially when issues only
>     occur in specific transition scenarios.
>     
>     Implementation
>     ==============
>     
>     The history metadata is stored in a separate FDT subtree registered via
>     kho_add_subtree(), rather than being embedded directly in the root KHO
>     FDT. This design choice:
>     
>      - Keeps the core KHO ABI minimal and stable
>      - Allows the history format to evolve independently
>      - Avoids requiring version bumps for all KHO consumers (LUO, etc.)
>        when the history format changes
>     
>     The history subtree uses its own compatible string "kho-history-v1" and
>     contains two properties:
>      - previous-release: The kernel version that initiated the kexec
>      - kexec-count: Number of kexec boots since last cold boot
>     
>     On cold boot, kexec-count starts at 0 and increments with each kexec.
>     The count helps identify issues that only manifest after multiple
>     consecutive kexec reboots.

Very well written changelog!

>     
>     Signed-off-by: Breno Leitao <leitao@debian.org>
>
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index 285eda8a36e4..da19d6029815 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -84,6 +84,29 @@
>  /* The FDT property for sub-FDTs. */
>  #define KHO_FDT_SUB_TREE_PROP_NAME "fdt"
>  
> +/*
> + * The "history" subtree stores optional metadata about the kexec chain.
> + * It is registered as a separate FDT via kho_add_subtree(), keeping it
> + * independent from the core KHO ABI. This allows the history format to
> + * evolve without affecting other KHO consumers.
> + *
> + * The history FDT structure:

I don't have a strong preference here, but you don't _have_ to use FDT.
For example, with memfd, we moved from FDT to plain C structs during the
evolution of the patchset. Main reason is that FDT programming is a bit
annoying. C structs make many things much easier. For example, you can
always assume a certain property always exists and is of a given size,
and you don't have to validate every single property you read.

Anyway, I don't mind either way.

> + *
> + *   / {
> + *       compatible = "kho-history-v1";
> + *       previous-release = "6.x.y-...";
> + *       kexec-count = <N>;
> + *   };
> + */
> +#define KHO_HISTORY_NODE_NAME "history"

Do we want to call it history? Perhaps "kexec-metadata" instead? So we
could use it for other misc information if needed later.

Mike/Pasha, any thoughts?

> +#define KHO_HISTORY_COMPATIBLE "kho-history-v1"
> +
> +/* The FDT property to track previous kernel (kexec caller) */
> +#define KHO_PROP_PREVIOUS_RELEASE "previous-release"
> +
> +/* The FDT property to track number of kexec counts so far */
> +#define KHO_PROP_KEXEC_COUNT "kexec-count"
> +
>  /**
>   * DOC: Kexec Handover ABI for vmalloc Preservation
>   *
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 3cf2dc6840c9..fd22b0947587 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -15,6 +15,7 @@
>  #include <linux/count_zeros.h>
>  #include <linux/kexec.h>
>  #include <linux/kexec_handover.h>
> +#include <linux/utsname.h>
>  #include <linux/kho/abi/kexec_handover.h>
>  #include <linux/libfdt.h>
>  #include <linux/list.h>
> @@ -1246,6 +1247,8 @@ struct kho_in {
>  	phys_addr_t fdt_phys;
>  	phys_addr_t scratch_phys;
>  	phys_addr_t mem_map_phys;
> +	char previous_release[__NEW_UTS_LEN + 1];
> +	u32 kexec_count;
>  	struct kho_debugfs dbg;
>  };
>  
> @@ -1331,6 +1334,48 @@ static __init int kho_out_fdt_setup(void)
>  	return err;
>  }
>  
> +/*
> + * Create a separate FDT subtree for optional history metadata.
> + * This keeps the core KHO ABI minimal and allows the history format
> + * to evolve independently.
> + */
> +static __init int kho_history_init(void)
> +{
> +	u32 kexec_count;
> +	void *fdt;
> +	int err;
> +
> +	fdt = kho_alloc_preserve(PAGE_SIZE);
> +	if (IS_ERR(fdt))
> +		return PTR_ERR(fdt);
> +
> +	err = fdt_create(fdt, PAGE_SIZE);
> +	err |= fdt_finish_reservemap(fdt);
> +	err |= fdt_begin_node(fdt, "");
> +	err |= fdt_property_string(fdt, "compatible", KHO_HISTORY_COMPATIBLE);
> +	err |= fdt_property_string(fdt, KHO_PROP_PREVIOUS_RELEASE,
> +				   init_uts_ns.name.release);
> +	/* kho_in.kexec_count is set to 0 on cold boot */
> +	kexec_count = kho_in.kexec_count + 1;
> +	err |= fdt_property(fdt, KHO_PROP_KEXEC_COUNT, &kexec_count,
> +			    sizeof(kexec_count));
> +	err |= fdt_end_node(fdt);
> +	err |= fdt_finish(fdt);
> +
> +	if (err) {
> +		kho_unpreserve_free(fdt);
> +		return err;
> +	}
> +
> +	err = kho_add_subtree(KHO_HISTORY_NODE_NAME, fdt);
> +	if (err) {
> +		kho_unpreserve_free(fdt);
> +		return err;
> +	}
> +
> +	return 0;
> +}
> +
>  static __init int kho_init(void)
>  {
>  	const void *fdt = kho_get_fdt();
> @@ -1357,6 +1402,10 @@ static __init int kho_init(void)
>  	if (err)
>  		goto err_free_fdt;
>  
> +	err = kho_history_init();
> +	if (err)
> +		pr_warn("failed to initialize history subtree: %d\n", err);
> +
>  	if (fdt) {
>  		kho_in_debugfs_init(&kho_in.dbg, fdt);
>  		return 0;
> @@ -1425,6 +1474,61 @@ static void __init kho_release_scratch(void)
>  	}
>  }
>  
> +static int __init kho_print_previous_kernel(const void *fdt)
> +{
> +	const char *prev_release;
> +	const u64 *history_phys;
> +	const u32 *count_ptr;
> +	void *history_fdt;
> +	int history_node;
> +	int len;
> +	int ret;
> +
> +	/* Find the history subtree reference in root FDT */
> +	history_node = fdt_subnode_offset(fdt, 0, KHO_HISTORY_NODE_NAME);
> +	if (history_node < 0)
> +		/* This is fine, previous kernel didn't export history */
> +		return -ENOENT;
> +
> +	/* Get the physical address of the history FDT */
> +	history_phys = fdt_getprop(fdt, history_node, KHO_FDT_SUB_TREE_PROP_NAME, &len);
> +	if (!history_phys || len != sizeof(*history_phys))
> +		return -ENOENT;
> +
> +	/* Map the history FDT */
> +	history_fdt = early_memremap(*history_phys, PAGE_SIZE);
> +	if (!history_fdt)
> +		return -ENOMEM;

There is no real reason to call this so early in boot. You can call it
from an initcall or from kho_init(). Then you won't need the
early_memremap(). And you should also not poke into the KHO FDT
directly. Use kho_retrieve_subtree() instead.

> +
> +	prev_release = fdt_getprop(history_fdt, 0, KHO_PROP_PREVIOUS_RELEASE, &len);
> +	if (!prev_release || len <= 0) {
> +		ret = -ENOENT;
> +		goto exit;
> +	}
> +
> +	/* Read the kexec count from the previous kernel */
> +	count_ptr = fdt_getprop(history_fdt, 0, KHO_PROP_KEXEC_COUNT, &len);
> +	if (WARN_ON(!count_ptr || len != sizeof(u32))) {
> +		ret = -ENOENT;
> +		goto exit;
> +	}
> +	/*
> +	 * This populate the kernel structure that will be persisted during
> +	 * kernel life time, and the fdt will be unmapped
> +	 */
> +	kho_in.kexec_count = *count_ptr;

This is another annoying thing about FDT. Alignment is only guaranteed
at 32 bits. So you should use get_unaligned() AFAIK.

> +
> +	strscpy(kho_in.previous_release, prev_release,
> +		sizeof(kho_in.previous_release));
> +	pr_info("exec from: %s (count %u)\n", kho_in.previous_release,
> +					      kho_in.kexec_count);
> +
> +	ret = 0;
> +exit:
> +	early_memunmap(history_fdt, PAGE_SIZE);
> +	return ret;
> +}
> +
>  void __init kho_memory_init(void)
>  {
>  	if (kho_in.mem_map_phys) {
> @@ -1513,7 +1617,10 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  	kho_in.scratch_phys = scratch_phys;
>  	kho_in.mem_map_phys = mem_map_phys;
>  	kho_scratch_cnt = scratch_cnt;
> -	pr_info("found kexec handover data.\n");
> +
> +	if (kho_print_previous_kernel(fdt))
> +		/* Fallback message when previous kernel info unavailable */
> +		pr_info("found kexec handover data.\n");
>  
>  out:
>  	if (fdt)

-- 
Regards,
Pratyush Yadav

