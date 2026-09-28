Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16E20CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 15:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05FCA6B0088; Mon, 28 Sep 2026 11:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2BE16B008A; Mon, 28 Sep 2026 11:52:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF2E46B008C; Mon, 28 Sep 2026 11:52:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B6AB16B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:52:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 31505C0244
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:52:13 +0000 (UTC)
X-FDA: 85263612546.22.5E15D58
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 88E09A0002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 15:52:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWW6e5TY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790610731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CA9+Khdny5X3PvtzSKfpyt/0TRJuMd+3QPdfNjaitb8=;
	b=UnoIeE9/l/vGN+wYW1hcAgLxbeUM9iJuzHg1pnv5WoLeY86T9SW4R71MFT/VFR+tiCcv2a
	E5uMPJiPwEttWnxTfBs5QqBl03Xy1qzg9SM7GTAU3UjihouILHmuLq9jXPX1T+fl+bHJZg
	MQ1YXn+iXcPGmpmz1KY7XEYzb0Oe8fc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FWW6e5TY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790610731;
	b=KZfF/coI6qEsCy4MCqNDUzYlADKVZPVIoGLBr/+G30HPvuTo9Mbl4jfv9TAAmFlVl2iJii
	WJ1O4EZF4IaznJIMibJTReB37x7szaHrFpDdyMJsU+nn9Rjn3qXRWTtZwXRNR3NaA9+8vn
	lAD5I2C7kcf/tqw07V2lrD2yVdX+HVI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B3D2141195;
	Mon, 28 Sep 2026 15:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 265041F000FF;
	Mon, 28 Sep 2026 15:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790610730;
	bh=CA9+Khdny5X3PvtzSKfpyt/0TRJuMd+3QPdfNjaitb8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=FWW6e5TYlYkD9F17qJd9niI1OEU1NX5IWz/mgl2P5fYxu1kSc1pYY8M6RmG2XOmvd
	 ETFLUYunCFlwk7anJ1lZ2lJSwvPWjMIMBv8Dh9Ybcw6rf1MaOv2aFOxr6RTzlwsbhl
	 b+7d/Xq/tAObx9d7TbdbzHp515pzww5pR+JvjSNPNhNfZ3/DQ0pCbULKm8Xg9/LNTW
	 9du8kxBTLg0qJ3t1tkZCYFd0r/WnOm3Lf/D8RYE5GDx1YNCmDY99gMRK26nbGRHs50
	 DitO1BDi1d2UGt/QB4vbtziHMCgiXP8MgbaOAZCb3VPRv9zXZuQ7Qi9PfyS/54oO5l
	 j+tv6Mg87tfaw==
Date: Mon, 28 Sep 2026 16:52:08 +0100
From: Harry Yoo <harry@kernel.org>
To: Seongjun Hong <hsj0512@snu.ac.kr>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] tools/mm/slabinfo: refactor slab attribute reading
Message-ID: <arqIzSPQVDky8jqc@thinkstation>
References: <20260927-tools-mm-update-slabinfo-v1-0-a4ea0d4dc136@snu.ac.kr>
 <20260927-tools-mm-update-slabinfo-v1-1-a4ea0d4dc136@snu.ac.kr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260927-tools-mm-update-slabinfo-v1-1-a4ea0d4dc136@snu.ac.kr>
X-Rspamd-Queue-Id: 88E09A0002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: xzo86roen3hint8ggcbxrnht34onz8r5
X-HE-Tag: 1790610731-433149
X-HE-Meta: U2FsdGVkX1/VZfGwuTRVRty0mjEr5/jVK4O55U+Wd5Q9koUn2Kaws4BTWipvFcojTgkVR/RALcoYKvbYzrL5bk1qSzlb0e5taP1ubbeloGulUgtHQMZfiPEhPJ0xVHAj+3HHh0LAKVtgvJYFkLJaQx1O1k7IyU/4wdg4KKtZnwAaLYPULt8Tyxua6b0AZ7cT5LSWb+glZuwsAyvjz1dlIdXjTlhxvAWwrCIrCIKkGxBj5Cu0MddQ7wfavBXxZsplW6Q1aZaNByCasWsV2xTcOcod9KbJjty/nl7NLeZJk/dtCPi6emzijUmLIyEyvEEYIstV1tOjdkSEmVLNGtf01TzLJk96Z6HKYAp08+/2Xd/4qhvHsHSW+qoJNylqaigaeSFuoUsQdgoOkyqdOLBjjQTJTbeYmOc+GidTBfLpAyOMcv1yFS49DiPlbMmqVDdA9pkqpkbwzq3AqR31joqRgO3PRgoZLbeTG4CyDhuaTKHPPMG6znbzRjNkLFYUoLZFAMUx7izp84a8xlNMLBTRTbYtxzGONxOh+5+pF+KDv3BomlIaxPeVwMLxahsM7BWoDC0C0aE3LXN9Z7HN96O4E1VPtNxEQMnfHWBYkhfm7SC8n8QuLC8WP/qnMfKFGq923fdK+JPoiDkASH7JtBtVZbCvI21pfv8jXn8nBaQphW4vZXs5ZJze/5SzqQC3bLGwaXWiZr5pe8+uvg4i5rh3pR1aDcoQF3dDAcS6XfYMKuOHlVtBJMwsq7siIwcJ+pG77bXvtM/lvVeWkQt4A3r/0tROmGds3V5cY8MbvLVJP9KVlGn2HT+K9g+YY2hEIRaVY3BNqt8LBH4T8t9kG0o6eKyOHg9c3l3CUUxtWClIU905Vq4SXwX9rBkJZhlTY48q3lku4wEMGvY7mFrOUYV2q3eGNbTxPWPgwFZEW758mb3gMl4IlKxzinCHI8F7UaZsA48Y1BPEq4tP4OI02+s
 NyAaH8me
 2YlHpUWtU9WEeA25uXnlBpyQHTni/FP6l/0luMbXRWexPgyFH/DMc66F35+KQQ2MM+hh7Mpm89HMm4nourd24LYt/ZRWpJJ7lkbwPTS5KATf4K6s4PFeUXrcpMkdhfKWLABkGse1jbu0PE5mmcUCQT9+XL8obM1Ek8Ni6UUPFFSq0BunKob4MJo7Sq4x5UIcVUcZfLtKxubJOVExgGL31NCvd1ENSDINfT0AcgXxOFM8DiB6cMDHc5085upZwC+BZBLUo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Seongjun, thanks for working on tools/mm/slabinfo improvements!
My comments inlined below.

On Sun, Sep 27, 2026 at 05:57:27AM +0000, Seongjun Hong wrote:
> The fields of struct slabinfo were mixed with deprecated sysfs files,
> which looks complicated. Organize every field of struct slabinfo by
> config option and the attribute order in mm/slub.c's slab_attrs[]. Because
> slabinfo should be able to run on previous kernel releases, leave the
> deprecated members for this time.
>
> read_slab_dir() had ~50 lines of attribute reads inlined. Move them to a
> new fill_slabinfo() helper so that directory walk and per-cache
> attribute reading are separated.
> 
> Fold get_obj_and_str() and decode_numa_list() into get_obj_and_decode()
> to avoid unnecessary strdup() and leave only one member assignment in
> fill_slabinfo() for each sysfs file.
> 
> Make broken statements into a single line for better readibility.
> 
> Remove alias field from struct slabinfo because it is initialized to 0
> and never updated. The only usage of this field "if (slab->alias)" is dead.

Would you please separate this patch into multiple patches?
It's hard to review when multiple refactorings are done in a single
patch.

> No functional change intended.
> 
> Signed-off-by: Seongjun Hong <hsj0512@snu.ac.kr>
> ---
>
>  tools/mm/slabinfo.c | 245 ++++++++++++++++++++++++++++------------------------
>  1 file changed, 131 insertions(+), 114 deletions(-)
> 
> diff --git a/tools/mm/slabinfo.c b/tools/mm/slabinfo.c
> index 48d1ee8b0e81..84359d628f2e 100644
> --- a/tools/mm/slabinfo.c
> +++ b/tools/mm/slabinfo.c
> @@ -27,25 +27,49 @@
>  
>  struct slabinfo {
>  	char *name;
> -	int alias;
>  	int refs;
> -	int aliases, align, cache_dma, cpu_slabs, destroy_by_rcu;
> -	unsigned int hwcache_align, object_size, objs_per_slab;
> -	unsigned int sanity_checks, slab_size, store_user, trace;
> -	int order, poison, reclaim_account, red_zone;
> -	unsigned long partial, objects, slabs, objects_partial, total_objects;
> +	int numa_slabs[MAX_NODES];
> +	int numa_partial[MAX_NODES];
> +
> +	unsigned int slab_size, object_size;
> +	unsigned int objs_per_slab, order;
> +	unsigned long objects_partial, partial;
> +	int aliases;
> +	unsigned int align;
> +	int hwcache_align;
> +	int reclaim_account;
> +	int destroy_by_rcu;
> +
> +	/* CONFIG_SLUB_DEBUG */
> +	unsigned long total_objects, objects, slabs;
> +	int sanity_checks, trace, red_zone, poison, store_user;
> +
> +	/* CONFIG_ZONE_DMA */
> +	int cache_dma;
> +
> +	/* CONFIG_SLUB_STATS */
>  	unsigned long alloc_fastpath, alloc_slowpath;
>  	unsigned long free_fastpath, free_slowpath;
> -	unsigned long free_frozen, free_add_partial, free_remove_partial;
> -	unsigned long alloc_from_partial, alloc_slab, free_slab, alloc_refill;
> -	unsigned long cpuslab_flush, deactivate_full, deactivate_empty;
> +	unsigned long free_add_partial, free_remove_partial;
> +	unsigned long alloc_slab, alloc_node_mismatch, free_slab;
> +	unsigned long order_fallback;
> +	unsigned long cmpxchg_double_fail;
> +
> +	/*
> +	 * Deprecated files:
> +	 * No STAT_ATTR()/SLAB_ATTR() for these exists in mm/slub.c's
> +	 * slab_attrs[] anymore.

This part of the comment looks fine, but

> Although cpu_slabs remains as a file,
> +	 * it is also outdated and always prints 0. Keep these for backward
> +	 * compatibility, but they should be removed later.

This doesn't seem useful information to put in the comment.

We were able to remove some files when
Documentation/ABI/testing/sysfs-kernel-slab says
"Available when CONFIG_SLUB_STATS is enabled", because that implies that
those files may not exist. 

But it's not the case for files like cpu_slabs,
and I don't think we're going to remove them in the future.

Probably simply say something like

"Deprecated files: the kernel does not create those files anymore or
 always prints hardecoded "0" since they are deprecated" ?

> +	 */
> +	int cpu_slabs;
> +	unsigned long free_frozen;
>  	unsigned long deactivate_to_head, deactivate_to_tail;
> -	unsigned long deactivate_remote_frees, order_fallback;
> -	unsigned long cmpxchg_double_cpu_fail, cmpxchg_double_fail;
> -	unsigned long alloc_node_mismatch, deactivate_bypass;
> +	unsigned long alloc_from_partial, alloc_refill;
> +	unsigned long cpuslab_flush, deactivate_full, deactivate_empty;
> +	unsigned long deactivate_remote_frees, deactivate_bypass;
> +	unsigned long cmpxchg_double_cpu_fail;
>  	unsigned long cpu_partial_alloc, cpu_partial_free;
> -	int numa[MAX_NODES];
> -	int numa_partial[MAX_NODES];
>  } slabinfo[MAX_SLABS];

-- 
Cheers,
Harry / Hyeonggon

