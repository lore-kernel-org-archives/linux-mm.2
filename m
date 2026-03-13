Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BFD2105F784
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 09:33:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A606B0088; Fri, 13 Mar 2026 05:33:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 708286B0089; Fri, 13 Mar 2026 05:33:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60A226B008A; Fri, 13 Mar 2026 05:33:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4DB5A6B0088
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 05:33:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DE8F75B7C9
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:33:21 +0000 (UTC)
X-FDA: 84540526602.02.553AD34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2B95E1A0015
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 09:33:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YpMae/MK";
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773394400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6/pkRkl23fjQY+qMNoaMSLlSZdDHQPz1zBNUh/l5QA=;
	b=bbw+ocD3HRfggKLzUCzhOlgSLGwJyY1CuKeQizG4jfiS6HYNOuu5vM0usZs2sbveGEJZDd
	nBFnR0nfTrzScN9ml+USeW9a00//ffdRhXeZ3Svmqov45oWGyNY7lpaJzpKVBFwd5EtRbe
	ugNfkNWWFE/nEyeWcQvGThj0lM8XHkQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="YpMae/MK";
	spf=pass (imf19.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773394400; a=rsa-sha256;
	cv=none;
	b=JVicY1pu7CO6eIdAxZLEJbqYMxPRfPKtgMFAysWTQ6wI4jueSiT22KidfkOKckBt29gUy8
	JhOaPiBN98R/4iy+wnx6gu9ydpoRb/ZtnV2oIzhRL5FEUaUsv6IVH+EG2mGsbGAtwUKQ+u
	bNzxg1rKLniTrTuTt3+Ius/8HINTWXo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3BADA42A30;
	Fri, 13 Mar 2026 09:33:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD42FC19421;
	Fri, 13 Mar 2026 09:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773394399;
	bh=02CGLe3Iuw7tQ2MF0lGQAkby+oCpClPybOzJjiCjfSg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=YpMae/MK0rYwx0zZwabFC4echKf0Z9M5PMBQ4avwLOVVmNKhTDUVh9FX1mnhz33oK
	 OlY7yEfsMqG7odRfEGphFjwQOHWe+fLOaZyY8SZeHafvImrJA+l8ZZF7kGGqUK8pM+
	 wBL6GPYaonjvYqKIeqT0+24T3UyOLyuMKCqEzoINyvn7uDK67sDdvDyRhaA2ebz+uK
	 gtKa3o2ngKx41pL2F6qLdTcSX0kO2p0LWNOhtfYGveZKaSn1fWmzi6bZAUn72/J2Re
	 v1rRqdS5v3eC263HVobnt5GcIRtEXaEBuNjrWhnEdIcklwVatAOH0Fn+z8vHfkOojm
	 kWfREm20kXxeg==
From: Pratyush Yadav <pratyush@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Alexander Graf <graf@amazon.com>,  Mike Rapoport <rppt@kernel.org>,
  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org,  usamaarif642@gmail.com,
  SeongJae Park <sj@kernel.org>,  kernel-team@meta.com
Subject: Re: [PATCH v8 5/6] kho: kexec-metadata: track previous kernel chain
In-Reply-To: <20260309-kho-v8-5-c3abcf4ac750@debian.org> (Breno Leitao's
	message of "Mon, 09 Mar 2026 06:41:48 -0700")
References: <20260309-kho-v8-0-c3abcf4ac750@debian.org>
	<20260309-kho-v8-5-c3abcf4ac750@debian.org>
Date: Fri, 13 Mar 2026 09:33:14 +0000
Message-ID: <2vxz3424gjl1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2B95E1A0015
X-Stat-Signature: ekr5489enbgbooecacb91y7hfkeng6wq
X-Rspam-User: 
X-HE-Tag: 1773394399-845931
X-HE-Meta: U2FsdGVkX1/yMfOexmu3TFPEQxrUH0RD6s+2BNfoEV8fK+P55HtTe/Z3vnNxG2JyUSW2bhAJO3jNMfOaxrkbSajH6wlxtJ3cnWRb8mKjTU8Lh0vMBET6ZgzUMWlWIqd7MnVDkx52tzvASmZk/IyC5Ujk6g/9b2KX8HiWcuTgjvn2JbFhZa/DdEItiOyH4dHG8JR2+fY/aMqOaydJUpjxGMbhJrx80O0MxkIhIGoqpJb6fLVvG0f1CfngGau8FGbjHKEaOcxCHDDo4GwrncQj6gnblJascK36Wl/D4Ap97XFF0CeCC6PIll+fMU5TrH0zTSSh3GBJLLzc1HS/J4TiPle7PRyY/o21wX3x8DDLjnrxV1B0ZybJtWKazSPok9zz0dvbCE4cW3Ht18kyDXviQXqB0CyN571/calPMAEGCDLzKjZC5JeVV+m534+uNkKaDb+XvehjVPe77jvQHIRJBLjV23oM/Yg4g+1RjA9w2TeHQdg5SC8RK9w8MKT97QfejtBtPrML34JUP8gzpSP66/9u2WgpS3mfNN2OcUvgqe2K1GlCirNoI+PCFCVpyfifPuro4xlblnyv1xCtsbrBEB+RSWeBcm5p5jgEJSmuLR+TGoKpnTNsQz4bFrDSUE8tk8JUdhz8FQo7m0fUHtuNCV0aEsJrny7/y5AzvjIRModQOX7px7XTQT+P1NyvrH9Y4EXbsDsZQ/d2xPhF7Zh995uu7En9bNYToq84o9mTgBsgnez+IT8IJY3StLTd4/HfWUzzkegV1w8o7rGjRtii78y/WvcNhghAr0/CP4gPvj2Me1rILAYfN5Ol/b6bod8ERIKxqooItkA0Se9mO0MEGY4GSyZLQQFErPHzcn+a1xDcgZrZuhq4T/rf754cnXp657OW9l/fqlcdtPwUXXMy3jnyPotuuqpFALcFO0g7BaIvPcknRdFE1d23OfAPaDL0R3fTGslZ2z76lbBdQ/4
 qQ1VyHzr
 cp23UVKzRTfYb5Pv8G7p3IRliURMFRqY7yl8ETzGCIaCTeQ1YQiNKT2dGTt21t+aEcU8qQWfs+vbOSmAwq/NS0SN/L6yPPcEKX7ZVKxRmAUc9nzKXuss2P9RlkkEIKJ7S1qWxSqLmXX6eroi/QdSe2zkGcTKAH5kx4Kdc/acRQ0W4VVtorCef9/VXbQ3fGCugtJgNkjj4uPhc/4IAWVn+bFJujQpt8wW27W7pm5YQsFjbB1nXezKEz+ncgrQHTbyTB4/O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09 2026, Breno Leitao wrote:

> Use Kexec Handover (KHO) to pass the previous kernel's version string
> and the number of kexec reboots since the last cold boot to the next
> kernel, and print it at boot time.
>
> Example output:
>     [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
>
> Motivation
> ==========
>
> Bugs that only reproduce when kexecing from specific kernel versions
> are difficult to diagnose. These issues occur when a buggy kernel
> kexecs into a new kernel, with the bug manifesting only in the second
> kernel.
>
> Recent examples include the following commits:
>
>  * eb2266312507 ("x86/boot: Fix page table access in 5-level to 4-level paging transition")
>  * 77d48d39e991 ("efistub/tpm: Use ACPI reclaim memory for event log to avoid corruption")
>  * 64b45dd46e15 ("x86/efi: skip memattr table on kexec boot")
>
> As kexec-based reboots become more common, these version-dependent bugs
> are appearing more frequently. At scale, correlating crashes to the
> previous kernel version is challenging, especially when issues only
> occur in specific transition scenarios.
>
> Implementation
> ==============
>
> The kexec metadata is stored as a plain C struct (struct kho_kexec_metadata)
> rather than FDT format, for simplicity and direct field access. It is
> registered via kho_add_subtree() as a separate subtree, keeping it
> independent from the core KHO ABI. This design choice:
>
>  - Keeps the core KHO ABI minimal and stable
>  - Allows the metadata format to evolve independently
>  - Avoids requiring version bumps for all KHO consumers (LUO, etc.)
>    when the metadata format changes
>
> The struct kho_kexec_metadata contains two fields:
>  - previous_release: The kernel version that initiated the kexec
>  - kexec_count: Number of kexec boots since last cold boot
>
> On cold boot, kexec_count starts at 0 and increments with each kexec.
> The count helps identify issues that only manifest after multiple
> consecutive kexec reboots.
>
> Acked-by: SeongJae Park <sj@kernel.org>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  include/linux/kho/abi/kexec_handover.h | 31 ++++++++++++++
>  kernel/liveupdate/kexec_handover.c     | 75 ++++++++++++++++++++++++++++++++++
>  2 files changed, 106 insertions(+)
>
> diff --git a/include/linux/kho/abi/kexec_handover.h b/include/linux/kho/abi/kexec_handover.h
> index 7e847a2339b09..832390f96f49c 100644
> --- a/include/linux/kho/abi/kexec_handover.h
> +++ b/include/linux/kho/abi/kexec_handover.h
> @@ -14,6 +14,7 @@
>  #include <linux/log2.h>
>  #include <linux/math.h>
>  #include <linux/types.h>
> +#include <linux/utsname.h>
>  
>  #include <asm/page.h>
>  
> @@ -101,6 +102,36 @@
>  /* The FDT property for the size of preserved data blobs. */
>  #define KHO_SUB_TREE_SIZE_PROP_NAME "blob-size"
>  
> +/**
> + * DOC: Kexec Metadata ABI
> + *
> + * The "kexec-metadata" subtree stores optional metadata about the kexec chain.
> + * It is registered via kho_add_subtree(), keeping it independent from the core
> + * KHO ABI. This allows the metadata format to evolve without affecting other
> + * KHO consumers.
> + *
> + * The metadata is stored as a plain C struct rather than FDT format for
> + * simplicity and direct field access.
> + */
> +
> +/**
> + * struct kho_kexec_metadata - Kexec metadata passed between kernels
> + * @previous_release: Kernel version string that initiated the kexec
> + * @kexec_count: Number of kexec boots since last cold boot
> + *
> + * This structure is preserved across kexec and allows the new kernel to
> + * identify which kernel it was booted from and how many kexec reboots
> + * have occurred.
> + *
> + * __NEW_UTS_LEN is part of uABI, so it safe to use it in here.
> + */
> +struct kho_kexec_metadata {

You need to have a version field here, as the first 4 or 8 bytes. And
you need to check it before parsing anything else in the struct.
Otherwise there will be no way to extend this struct since there won't
be a way to find out if the kernel can read the new format. You probably
should also check the size of the blob on retrieve to make sure it is
large enough to at least contain the version.

Also, since this follows ABI version independent of KHO, please move it
to a separate header, perhaps kexec_metadata.h. Right now we assume that
everything in this file is tied to the base KHO version.

Other than this, LGTM.

> +	char previous_release[__NEW_UTS_LEN + 1];
> +	u32 kexec_count;
> +} __packed;
> +
> +#define KHO_METADATA_NODE_NAME "kexec-metadata"
> +
>  /**
>   * DOC: Kexec Handover ABI for vmalloc Preservation
>   *
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 1f22705d5d246..7bac80e9a29a4 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -18,6 +18,7 @@
>  #include <linux/kexec.h>
>  #include <linux/kexec_handover.h>
>  #include <linux/kho_radix_tree.h>
> +#include <linux/utsname.h>
>  #include <linux/kho/abi/kexec_handover.h>
>  #include <linux/libfdt.h>
>  #include <linux/list.h>
> @@ -1285,6 +1286,8 @@ EXPORT_SYMBOL_GPL(kho_restore_free);
>  struct kho_in {
>  	phys_addr_t fdt_phys;
>  	phys_addr_t scratch_phys;
> +	char previous_release[__NEW_UTS_LEN + 1];
> +	u32 kexec_count;
>  	struct kho_debugfs dbg;
>  };
>  
> @@ -1408,6 +1411,74 @@ static __init int kho_out_fdt_setup(void)
>  	return err;
>  }
>  
> +static void __init kho_in_kexec_metadata(void)
> +{
> +	struct kho_kexec_metadata *metadata;
> +	phys_addr_t metadata_phys;
> +	int err;
> +
> +	err = kho_retrieve_subtree(KHO_METADATA_NODE_NAME, &metadata_phys,
> +				   NULL);
> +	if (err)
> +		/* This is fine, previous kernel didn't export metadata */
> +		return;
> +	metadata = phys_to_virt(metadata_phys);
> +
> +	/*
> +	 * Copy data to the kernel structure that will persist during
> +	 * kernel lifetime.
> +	 */
> +	kho_in.kexec_count = metadata->kexec_count;
> +	strscpy(kho_in.previous_release, metadata->previous_release,
> +		sizeof(kho_in.previous_release));
> +
> +	pr_info("exec from: %s (count %u)\n", kho_in.previous_release,
> +					      kho_in.kexec_count);
> +}
> +
> +/*
> + * Create kexec metadata to pass kernel version and boot count to the
> + * next kernel. This keeps the core KHO ABI minimal and allows the
> + * metadata format to evolve independently.
> + */
> +static __init int kho_out_kexec_metadata(void)
> +{
> +	struct kho_kexec_metadata *metadata;
> +	int err;
> +
> +	metadata = kho_alloc_preserve(sizeof(*metadata));
> +	if (IS_ERR(metadata))
> +		return PTR_ERR(metadata);
> +
> +	strscpy(metadata->previous_release, init_uts_ns.name.release,
> +		sizeof(metadata->previous_release));
> +	/* kho_in.kexec_count is set to 0 on cold boot */
> +	metadata->kexec_count = kho_in.kexec_count + 1;
> +
> +	err = kho_add_subtree(KHO_METADATA_NODE_NAME, metadata,
> +			      sizeof(*metadata));
> +	if (err)
> +		kho_unpreserve_free(metadata);
> +
> +	return err;
> +}
> +
> +static int __init kho_kexec_metadata_init(const void *fdt)
> +{
> +	int err;
> +
> +	if (fdt)
> +		kho_in_kexec_metadata();
> +
> +	/* Populate kexec metadata for the possible next kexec */
> +	err = kho_out_kexec_metadata();
> +	if (err)
> +		pr_warn("failed to initialize kexec-metadata subtree: %d\n",
> +			err);
> +
> +	return err;
> +}
> +
>  static __init int kho_init(void)
>  {
>  	struct kho_radix_tree *tree = &kho_out.radix_tree;
> @@ -1441,6 +1512,10 @@ static __init int kho_init(void)
>  	if (err)
>  		goto err_free_fdt;
>  
> +	err = kho_kexec_metadata_init(fdt);
> +	if (err)
> +		goto err_free_fdt;
> +
>  	for (int i = 0; i < kho_scratch_cnt; i++) {
>  		unsigned long base_pfn = PHYS_PFN(kho_scratch[i].addr);
>  		unsigned long count = kho_scratch[i].size >> PAGE_SHIFT;

-- 
Regards,
Pratyush Yadav

