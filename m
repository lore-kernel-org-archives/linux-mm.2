Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F0BAE87846
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 16:16:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 602996B00A2; Tue,  3 Feb 2026 11:16:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0616B00A4; Tue,  3 Feb 2026 11:16:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AF7F6B00A6; Tue,  3 Feb 2026 11:16:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 31C2A6B00A2
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 11:16:17 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0CA3138344
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:16:16 +0000 (UTC)
X-FDA: 84403647552.22.CF75900
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id EA2E9A0003
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 16:16:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hXLLC34H;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770135375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+6iEfAwVowudD9440Eytyn2K8CBL+yodt/SON0xQjqw=;
	b=jS6LuzYy8OZW5h9+e4yPPZDYJpIIUJpN3M7HFtm3UMlb0p5WsG769Bb1m229PK320/FbPZ
	jRkRloyyF2mlZ2WQyiDRCKd9F9N7sLIqoxPIhv8pId7le5WSKIKtoxNUG3f/Z//DGhvwTY
	Lzgn3cQppDd9FcU9CkPI6eOEYtO/t3M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hXLLC34H;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770135375; a=rsa-sha256;
	cv=none;
	b=uAFtWxv5pgRGw3QpZaPNbesNHUeAFQuk8Cpw9ApAvqlWdP8zyGvsF5QhVa+FfGjsD+8fLg
	ekEI70E0LLwC5hWhc0OOFzehov+UH5OofAZSCrWj0cvw6jujS+c+0GrwDmzaKUmJT+3/7+
	JVFxGyZ9jWJvfM6881hojnIVC6+ww7s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C72A14151B;
	Tue,  3 Feb 2026 16:16:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B490BC116D0;
	Tue,  3 Feb 2026 16:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770135373;
	bh=Lggy4kALKLaV7O6fLdE4+3yPKrZNAb1hhE+tXBQafR4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hXLLC34Hyic6hTVqbQvX+x8C9ERdyKtNKrY6+MNR9b06xzRBHCvSqNkCZ7xinvGIP
	 7Hd3ieYzcbZvn2/LrBLyPiqnUxRcPP2niRSceJ/CsiaFC+sBVRcJgy71mcNUfrJEWD
	 ybgZiWVweo9yd1pBfJaBZ3YTCNSAcqh6faYgv8maTRlfDqe+QH35iazzaOFGhxOxDY
	 uR2PZJ6ZMlTK5ICJd2Zu+dP+hlT1PXeym14O7DAZlWFUSDhWxCRazeE/YpgthdUkEr
	 iIW/x2hf4lsc9tNn5ZWyX8aZr7ZTTFzRRpyGBAmYJTy/7AMBs52RKuFtbp4DMymukR
	 6ml1F17rWEwRA==
Date: Tue, 3 Feb 2026 18:16:05 +0200
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
Subject: Re: [PATCH v8 1/2] kho: Adopt radix tree for preserved memory
 tracking
Message-ID: <aYIfRa5fDBaLVR5y@kernel.org>
References: <20260130005739.3163049-1-jasonmiu@google.com>
 <20260130005739.3163049-2-jasonmiu@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130005739.3163049-2-jasonmiu@google.com>
X-Stat-Signature: c9xz64bpi3zdx14yj5cmtqi15sh37kf3
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EA2E9A0003
X-HE-Tag: 1770135374-96308
X-HE-Meta: U2FsdGVkX1/Eg84UQ2Qz1eTtH8gTFPcrFUWcRMusy20/vWNwvdmSPdc0h7786zvBibnaUZMKIh7sCekktzyIEffQjaQsRg8824V+5oFIlJbzf0NQx/l+nWcTZcEtps/N73HPJvlOUbiyWi0aMifOjXRHJ3/KmLBXSn+XFvuIGTx7D3JAA9YcVMGoezw8CDVfDX/f9CZlupY7qqw0izbgyBCJCZCk0+2a1p7mZLVuF5o2s95ONKIYKDzcUpjwUS33HC12jByMUMU1mMt8yX4OrlJNcVIQM2lchS/tV2b1VaFFvP5G1/zP9a/DGv+3pQH6CQZMF7zFGJeXOt7h9HN0n3x+DbfwRIKxT62UL99U+SlRxiEhh099113XUbTToyOZfTpNj8epxOFo5e+8n6rk1F6zD2MXWR+kMc3dFGdJ85BdXl/RSZtF+m5KPmH8zh1yuIs8hbG5J0POqk/W46o7KoTIOxJY1KXeN3efi5RVifYuUSsrTku5zcgb+ol8rVXIOJRLW9lvp8GP9Q4FLLjEvDLPTIqvAUPhcmw8A/kQGX1mmH7oxejofhHIYnN2nT3a1BlloKkpLy8GffBjk0vktMM1kVFQZEWqIxfE9f6kC6AEOVh7jsmKDC1aWaPyc7DgFMGJl1cieETvpzijNV4I3q31kJIRNyAk8EHq0lwyrbfCIbBpJUIJ8gAEPHu51LxTzpBbs5xS0QOVmV3m49cyypsSjxw28obEMvx+GHmokNtPzBLazqZvRSvo0gYYwTkZsRFuFmJFpN3im7baAvUSttpyuksDreocUxQr6K2kwwomBcVAPVTMyqRHuyYLOKM5a+T9nsO9NXzx/6ukHYEcFW2Af2TBgKDVfhaoII3THhgl4FLpBidR4V8kBWH+tvZvdnPTBhIBubDiMps8BoO9HQXzNklwOBYUPYcm84IlNmLOs5aelOrqIj0pxZrzZAlNg6hm37N/ruoZ+DXxxzn
 f9y7xHkM
 dctRAmC5ehxGxdhqEYEjXp95gEBlzm57DUWiBI6008XYGds9AG/WPl5zGhmn1VIzJiLrbnq7K+rcIsBmNKzb3elio5Fk0usZklCTf3dy45baZ4DwIIu/C39tMT5M7rwDtzdJBT+wdXIXw6lYp+gRu82UWs38RDFQcUc7HY2Cz7bFqwaF/IFhAEvVz+Wt/X8p0cH1PnVa/OlXDuhNsupxtPoueWpBBwZENQ2c4SxTvHu2mMfUqyXc92wfhKF5O0LvKA8rQZE7ZoLcYgm4lVF/Gi+y+U9qf2N7pJNWhjeXNGS4fVwI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 04:57:38PM -0800, Jason Miu wrote:
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

With minor comments below

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
...

> +static int __kho_radix_walk_tree(struct kho_radix_node *root,
> +				 unsigned int level, unsigned long start,
> +				 kho_radix_tree_walk_callback_t cb)
> +{
> +	struct kho_radix_node *node;
> +	struct kho_radix_leaf *leaf;
> +	unsigned long key, i;
> +	unsigned int shift;
> +	int err;
> +
> +	for (i = 0; i < PAGE_SIZE / sizeof(phys_addr_t); i++) {
> +		if (!root->table[i])
> +			continue;
> +
> +		shift = ((level - 1) * KHO_TABLE_SIZE_LOG2) +
> +			KHO_BITMAP_SIZE_LOG2;
> +		key = start | (i << shift);
> +
> +		node = phys_to_virt(root->table[i]);
> +
> +		if (level == 1) {
> +			/*
> +			 * we are at level 1,
> +			 * node is pointing to the level 0 bitmap.
> +			 */
> +			leaf = (struct kho_radix_leaf *)node;
> +			err = kho_radix_walk_leaf(leaf, key, cb);
> +			if (err)
> +				return err;
> +		} else {
> +			err  = __kho_radix_walk_tree(node, level - 1,
> +						     key, cb);
> +			if (err)
> +				return err;

Nit: if (err) can be moved outside if (level == 1)

> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each preserved page.
> + * @tree: A pointer to the KHO radix tree to walk.
> + * @cb: A callback function of type kho_radix_tree_walk_callback_t that will be
> + *      invoked for each preserved page found in the tree. The callback receives
> + *      the physical address and order of the preserved page.
> + *
> + * This function walks the radix tree, searching from the specified top level
> + * (@level) down to the lowest level (level 0). For each preserved page found,

Hmm, why do we need @level here? 
Or it rather remained from the older versions?

> + * it invokes the provided callback, passing the page's physical address and
> + * order.
> + *
> + * Return: 0 if the walk completed the specified tree, or the non-zero return
> + *         value from the callback that stopped the walk.
> + */
> +int kho_radix_walk_tree(struct kho_radix_tree *tree,
> +			kho_radix_tree_walk_callback_t cb)
> +{
> +	if (WARN_ON_ONCE(!tree->root))
> +		return -EINVAL;
> +
> +	guard(mutex)(&tree->lock);
> +
> +	return __kho_radix_walk_tree(tree->root, KHO_TREE_MAX_DEPTH - 1, 0, cb);
> +}
> +EXPORT_SYMBOL_GPL(kho_radix_walk_tree);

-- 
Sincerely yours,
Mike.

