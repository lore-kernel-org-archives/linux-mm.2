Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4038FCA5FCC
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 17:57:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EF916B047A; Tue, 20 Jan 2026 12:57:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D516B047C; Tue, 20 Jan 2026 12:57:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9C86B047D; Tue, 20 Jan 2026 12:57:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 788916B047A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 12:57:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1306813B90E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:57:48 +0000 (UTC)
X-FDA: 84353100216.22.3FD36F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 57B1C80004
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 17:57:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DTUy1n4w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768931866; a=rsa-sha256;
	cv=none;
	b=zRHZM5kDJ6N6fefGOQcyZTqTrn6RJ+BFTNLf3q1jgyMXIGAyStiQoQdaCz46PpJDBQCtpW
	+wEhVxSFSAAGF4OQyZtFYe9dTuDuixCS9C2m27ChLGl9XMv4brPUvxososXMlUVXaaobI1
	Owr11xxU5XYm6JqlBn+NoFy1ucMM314=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DTUy1n4w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768931866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MfhT75hO3NZBcebmZbN8NiQlhZEwXQzjYMHe6XNmZFw=;
	b=iNRZ0BA1NAodsnf+GhyyaUYlFUjk7ADrxQAFsWJVZYUosaM5c9o7zFeUGzn23okOjN72dM
	2YdRskKwLu+EyLLgGvn4K1/NkRPU21lPRwX8Ol8MeunSdlqn4cz1J7J4sojVBO78fkYwai
	oXoBnxAnX4mheLGAT0Pn6N9M8QpmonI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25B5A40485;
	Tue, 20 Jan 2026 17:57:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2854AC16AAE;
	Tue, 20 Jan 2026 17:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768931865;
	bh=YpDjEfkNyumQSj2vKApRnaV2QIrJCawbl/fbFRLhjvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DTUy1n4wndhSupFBOffwXqXmKNwnFwm/n+eeE46Wo+yZ8Kbn2dJr3RrCfkJuRWYi/
	 pEHCFCX6KfjgiR7YTg55Y0w26XvYnbzdmQ94nheoUD3Kp+DA5I427bvu4Dk3tGOsUn
	 ymc/ptSYMFWjtFx5aIi7DLYfY3fuz83zrASsBzH9QHnR1znbtpSM8rSIeFQoa+U8c0
	 Xt1gRRlJnxqNG7BwFNHUSTbSa5xRLwgIiIkmucPHpBhQj5ruBcA8VnCSzRk9Pyhdyz
	 rNEAOf8tvwk9N5fkvY0MFf2b/hK2DSkRxLX0vEazp4um7ulfj2fG40UWaMrSnbdPhy
	 P0jdxOzuBkSSg==
Date: Tue, 20 Jan 2026 19:57:37 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Jason Miu <jasonmiu@google.com>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>,
	David Matlack <dmatlack@google.com>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v7 1/2] kho: Adopt radix tree for preserved memory
 tracking
Message-ID: <aW_CEV-Qqrj2dvEb@kernel.org>
References: <20260116034432.1520731-1-jasonmiu@google.com>
 <20260116034432.1520731-2-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116034432.1520731-2-jasonmiu@google.com>
X-Rspamd-Queue-Id: 57B1C80004
X-Rspamd-Server: rspam06
X-Stat-Signature: s1bkp95c4phn7wndgnsq853zy6wpi68z
X-Rspam-User: 
X-HE-Tag: 1768931866-221501
X-HE-Meta: U2FsdGVkX1/cYwJlGApjzjjb999CW4M61rAUy3MhWp/BNeD2SvHigHupWHP4gDMCDMIwEBdue1wuHA4EflCfOLMxht+w9a203MOwb674UUlL/PFbUb5tF2padxizsDKyualmPSUt+FPj2BVOOStz6FcmXdk4JaPtqaf7gR+rvwVFz+OlRnIhX+3zzONKXTwVc6426N8VLPxS1fiJa/fuV+1Ln+n6PAI4zqg3zGrtCnSyNQdsKQlY2WZ595vjYa2OEGouULu7uG49qqo2WevVR1HO1gMIhjxLclU7VDmyKU2TfPx9/XiNijaPOm8gNd60p4Sv9JAMY4KCPi2Sfz/NUwCDGPwL0knAHwNhaNRFytlSoEkcxb7qJxzcj4DeBeH9RDYcHfLDPk27t06yIm1q3YgUa1giu0uf3IJThgyDGGNsshCaAD5e7zLeckyUAYT4M94W8JNjH432W4WbLanvQ5sJyD+mRTUlYITvMtRMUn3DGBeo5gxef5Daj7TwGM0C5P4ulK+Bkd8+SA6i9/+CrKL+6a80CF8wNruKuiQsx9WHXz35liJPO8mDFEHJs8Ch77p6LLdh0nt2Ukq2FfNdvTYSff5a28qdqVtbJkDNfqzY6lXZOrVvyQ+zvt/t7B2nsqq6EcsrcP6toToKkAT0woDlLHFWo81jpNgyzChlSqfNAEpcX4St+ys23FwbBQCkKcWuyiXWwBqSigvy61RTQmTP6HN70ramGb3W2Y7D/EjFv+VFzKI1ks8XmGklTFGRAK/O0OGxIJ4jL8TDaPy7AYYNusQnodC8ntiSghTvLoCEzLeudWWByj39+o2rXkP2whLvQTs52RiQea2upgAied8w7fg6TGvUtoPdC6MV6N/W1o42ualSUQy2lNb6aipqJA3aIaMmtd52PrU2MwRDydvs7xNrDlTposwqm2LNW/FcYZH5Y+L0DcBSpoJHR8hRMnJoNJCUMttlGvwD/Fh
 0xJjhAfk
 DkYqhGK7KT6RGx0NnDW5uIwh5eUHBAyPg0KyYLCkW7qYyw+RYnnxIYlsUR71da9ZxW3XAenW5b2goQRsQLXr1UIw8Ej8OvBErHs8Dehx7gkpxiGUDCoqJiIh76LjXstS4dRCJIMM6wAqZw3wI9fvHiLs9vY9dWJ8HKSSfqmpyvDxsPre1sBge2CJz+NOe+ak1B/s/3aeoKGB3CuvWfsXfag2M+nQ46iYNPFyYHgwpwLLpsGsBYZU9+hDfZoLgUZUrMFMsgRv6zvVU5JR/QO1OIxKpY/xibW+OkW0jrq0d5DYxoq0wejn6GnJSJzv8OUTORU3TvylExgqndYI9elTGJv/nc3lajR+cL6I//DvKzpusPFY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Jason,

On Thu, Jan 15, 2026 at 07:44:31PM -0800, Jason Miu wrote:
> Introduce a radix tree implementation for tracking preserved memory
> pages and switch the KHO memory tracking mechanism to use it. This
> lays the groundwork for a stateless KHO implementation that eliminates
> the need for serialization and the associated "finalize" state.
> 
> This patch introduces the core radix tree data structures and
> constants to the KHO ABI. It adds the radix tree node and leaf
> structures, along with documentation for the radix tree key encoding
> scheme that combines a page's physical address and order.
> 
> To support broader use by other kernel subsystems, such as hugetlb
> preservation, the core radix tree manipulation functions are exported
> as a public API.
> 
> The xarray-based memory tracking is replaced with this new radix tree
> implementation. The core KHO preservation and unpreservation functions
> are wired up to use the radix tree helpers. On boot, the second kernel
> restores the preserved memory map by walking the radix tree whose root
> physical address is passed via the FDT.
> 
> The ABI `compatible` version is bumped to "kho-v2" to reflect the
> structural changes in the preserved memory map and sub-FDT property
> names. This includes renaming "fdt" to "preserved-data" to better
> reflect that preserved state may use formats other than FDT.
> 
> Signed-off-by: Jason Miu <jasonmiu@google.com>

...

> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 49bf2cecab12..06adaf56cd69 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -5,6 +5,7 @@
>   * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
>   * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
>   * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
> + * Copyright (C) 2025 Google LLC, Jason Miu <jasonmiu@google.com>

It's already 2026 ;-)

>   */
>  
>  #define pr_fmt(fmt) "KHO: " fmt

...

> +int kho_radix_add_page(struct kho_radix_tree *tree,
> +		       unsigned long pfn, unsigned int order)
> +{
> +	/* Newly allocated nodes for error cleanup */
> +	struct kho_radix_node *intermediate_nodes[KHO_TREE_MAX_DEPTH] = { 0 };
> +	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
> +	struct kho_radix_node *new_node, *anchor_node;
> +	struct kho_radix_node *node = tree->root;
> +	unsigned int i, idx, anchor_idx;
> +	struct kho_radix_leaf *leaf;
> +	int err = 0;
> +
> +	if (WARN_ON_ONCE(!tree->root))
> +		return -EINVAL;
> +
> +	might_sleep();
> +
> +	guard(mutex)(&tree->lock);
> +
> +	/* Go from high levels to low levels */
> +	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
> +		idx = kho_radix_get_table_index(key, i);
> +
> +		if (node->table[idx]) {
> +			node = phys_to_virt(node->table[idx]);
> +			continue;
> +		}
> +
> +		/* Next node is empty, create a new node for it */
> +		new_node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
> +		if (!new_node) {
> +			err = -ENOMEM;
> +			goto err_free_nodes;
> +		}
> +
> +		node->table[idx] = virt_to_phys(new_node);
> +
> +		/*
> +		 * Capture the node where the new branch starts for cleanup
> +		 * if allocation fails.
> +		 */
> +		if (!anchor_node) {

I think anchor_node should be initialized to NULL for this to work.

> +			anchor_node = node;
> +			anchor_idx = idx;
> +		}
> +		intermediate_nodes[i] = new_node;
> +
> +		node = new_node;
> +	}
> +
> +	/* Handle the leaf level bitmap (level 0) */
> +	idx = kho_radix_get_bitmap_index(key);
> +	leaf = (struct kho_radix_leaf *)node;
> +	__set_bit(idx, leaf->bitmap);
> +
> +	return 0;
> +
> +err_free_nodes:
> +	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
> +		if (intermediate_nodes[i])
> +			free_page((unsigned long)intermediate_nodes[i]);
> +	}
> +	if (anchor_node)
> +		anchor_node->table[anchor_idx] = 0;
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(kho_radix_add_page);

...

> +		if (WARN_ON(!node->table[idx]))
> +			return;
> +
> +		node = phys_to_virt((phys_addr_t)node->table[idx]);

No need for casting.

> +		shift = ((level - 1) * KHO_TABLE_SIZE_LOG2) +
> +			KHO_BITMAP_SIZE_LOG2;
> +		key = start | (i << shift);
> +
> +		node = phys_to_virt((phys_addr_t)root->table[i]);

Ditto.

> @@ -1466,12 +1489,6 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  		goto out;
>  	}
>  
> -	mem_map_phys = kho_get_mem_map_phys(fdt);
> -	if (!mem_map_phys) {
> -		err = -ENOENT;
> -		goto out;
> -	}

I think we should keep the logic that skips scratch initialization if there
were no memory preservations, like Pasha implemented here:
https://lkml.kernel.org/r/20251223140140.2090337-1-pasha.tatashin@soleen.com
(commit e1c3bfd091f3 ("kho: validate preserved memory map during
population") in today's mm tree)

We just should update the validation to work with the radix tree.

>  	scratch = early_memremap(scratch_phys, scratch_len);
>  	if (!scratch) {
>  		pr_warn("setup: failed to memremap scratch (phys=0x%llx, len=%lld)\n",
> @@ -1512,7 +1529,6 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  
>  	kho_in.fdt_phys = fdt_phys;
>  	kho_in.scratch_phys = scratch_phys;
> -	kho_in.mem_map_phys = mem_map_phys;
>  	kho_scratch_cnt = scratch_cnt;
>  	pr_info("found kexec handover data.\n");
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

-- 
Sincerely yours,
Mike.

