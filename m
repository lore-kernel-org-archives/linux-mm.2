Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0441CD37AC
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 11:43:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD066B00B8; Mon, 11 May 2026 07:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E096B00B9; Mon, 11 May 2026 07:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4006B00BA; Mon, 11 May 2026 07:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ECAB86B00B8
	for <linux-mm@kvack.org>; Mon, 11 May 2026 07:43:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B3C5F406FB
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:43:32 +0000 (UTC)
X-FDA: 84754953864.12.B06D667
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id EF0A214000A
	for <linux-mm@kvack.org>; Mon, 11 May 2026 11:43:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rz1oczau;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778499811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fWwhqwqwkhYE1DoIAL0vWP7wepmddy4bNmBTLV1OqkU=;
	b=rVb3CLmreMWsmLarxBhObABItQZqpPd5pReGCxd19p2mMmze+JY+CtPJw0hjIe7IQwp0xt
	YIoWqBdMTgcTnuDseqoDL/3iaJu690nmLlDzLSBCTyv5PLd/7CUbkQaNtN6jphEIFKHZdI
	B7NK/8VT0wiqvxjws2CG0h0Wr+AQ4CA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778499811; a=rsa-sha256;
	cv=none;
	b=DEYF/dN6dwcSgMWPe8hDED9I6//u7zc9F14EaX4eqrkWgMUZCE+/L+i63jwvPOA4QDPLQI
	iCJHK8clmGG74dv7c3NJqNnEJGZ8Bb/Lo18v+V5CFcn+BLuJ/SUl/2nlNprNUAZVazkYNB
	TBQGAkXMm+dFDYl5Sfwx/tWylowTeI8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rz1oczau;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 40F5E600CB;
	Mon, 11 May 2026 11:43:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501E1C2BCB0;
	Mon, 11 May 2026 11:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778499810;
	bh=doUeaYtjF8Msr6sQPt831O8Es6nJwVfBhQPgujc4M6U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rz1oczau0TWzOR6yKi0rz/4KoKq3Gokj2w1+yvckuim/bxkw4X73ZEWdBqhEuQBA9
	 9Be6fb0giJ5L4UvdP5xO+8n5ULRJS7UDoPn4Zw1uM+GXqPR6Qq9kM6jwMGk4N0JlMv
	 rOBOa6k0pfbnWKyxzckGTfBdXQmlqZZKFPX4Eh5avxr4kARTb2wzUaHCIyFARsfy89
	 X2Yeyh56EFFfIIft/cgkssH6FaDLBplxfOpLQkmrQhtI7TZNs7gZaeIpX4ZxotF5a4
	 DkQdFXMP6e0WUFJmnS6IIhkEPq5Rq+Sf902iAf7QYCxcEBNJXGvKOebA/xKu0F5t7n
	 eAl1nyGljxKpg==
Date: Mon, 11 May 2026 14:43:22 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] kho: store incoming radix tree in kho_in
Message-ID: <agHA2imH5hdMSlId@kernel.org>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-3-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-3-pratyush@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EF0A214000A
X-Stat-Signature: twsfezo8sszhwwfer9i98kqe46djt8im
X-Rspam-User: 
X-HE-Tag: 1778499810-65802
X-HE-Meta: U2FsdGVkX196oEfY9hncMp0/exNmCy5OB1R19LlbxB+4/tmhqjwFFvO6hxNAYWXiGgZwPbqziYaBRfnTOD4B3w5T52k5U3lKgPD9YeXnIY4jFAcNIvhOlUnHUyQSX5umbbQN1qU2cWkBF3wyUqtQQctRPcjz/d3L2txQgxIsJDX+gXrvV+PhDTT011QodRDZU8RuUhwqBVYO6difqJfA6VEYxawOwL8KEZnCxGNLqne4Z7UA22WZCykTVAqUvp81R83alCfp/W4LorzhpHvr/YbcKQ9tBCmsLiAT5CmGZPXkC1FIe/PWBoUBx6qa/gsXnzidJsBLtRw3Z8+feQDw7yvbv2yuea9816vPyTwP9/9Gd2E/pVWjNGeMhNF4+12R74rskost5zwtSGzsMsOfvQ9AHdZk/bg65ckytn6jh9/MkPcdpms1tJPDAetB0CW8MVhjyMJJNRM12YDl8ecXTygK4Vvso3IH8Amov8/P8rf81sflVVQAnxJIZWEtSdO8g1HY0AdjnkEbgLt95YbL8W5aDkkn+OG2Bf4L8FRvO7GgeVKYz/JHSPZO0Kj1aZkjs+ug8vwfQ8pPhPoiW9fTHju494zRwSp9hogaEVUGD1v0ndNNv3PkSDBmts83FmMtTlk8T2rRxzhlXm9BL9khEuZ8y1U9o+BfH9XRc+LFUkFw8oyM4qx4Pf6psoP1o5WlPBj0don2e+I9wti5qJmw9T2z66HpVat9e0WvUrtKJ+wo7kXqJbDWfhCxjkyVpqVQcy/jfyEj1WYlzo4eR6czlBxeOGjaLeGjKJbLSxagVr3ALaAzTs8O8dQcOfDgsRB+oreqhOfgh/dvw9EVcxcjoRQyOZ25jLUb8MQWil/AOpTB8TA9GQB2iHfPFphOE/MQzFIRztFOHQkPFFXS2qnlus8W9MOR/ofzVo350Ik/qL9bFSaMKYTfQta8FrHhh338F1txFEQEFAoEX0ki8n/
 1hYamTG4
 4g1NqrD8ihph4K6+MZcDu40CXkW1z8TQkM/0Dgj50uL7Xpbs+BkFO0XR2+NgVhrbfvulJx3rv9LUUIoKfPP+am6HJW9rK34HjECRv8zWrT7bod01zUVEMBqHdFAP6QH7Lt9964HJmttITPsbHG5gfpYxHRlLOYEWkzqWBUEtz4y6z8b5x3w5pP+Zid9Y6T/z2L8UYKJVKUA+N0iEQMHyC2DOf1dYcD0URyko8F+Fbqm2Gxoeh5ZHpn2r/c/StPsl3brZxAgDqbWyiBi1e4A/PSkM3ori5rFQCGOhN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 29, 2026 at 03:39:04PM +0200, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> This allows other functions to also use the radix tree. While at it,
> also use kho_get_mem_map_phys() instead of duplicating the code to get
> the radix tree root from the FDT.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  kernel/liveupdate/kexec_handover.c | 27 ++++++++-------------------
>  1 file changed, 8 insertions(+), 19 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index ba568d34c5b4..5758dc6fab5d 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -1294,6 +1294,7 @@ struct kho_in {
>  	char previous_release[__NEW_UTS_LEN + 1];
>  	u32 kexec_count;
>  	struct kho_debugfs dbg;
> +	struct kho_radix_tree radix_tree;
>  };
>  
>  static struct kho_in kho_in = {
> @@ -1373,24 +1374,10 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
>  
>  static int __init kho_mem_retrieve(const void *fdt)
>  {
> -	struct kho_radix_tree tree;
> -	const phys_addr_t *mem;
> -	int len;
> -
> -	/* Retrieve the KHO radix tree from passed-in FDT. */
> -	mem = fdt_getprop(fdt, 0, KHO_FDT_MEMORY_MAP_PROP_NAME, &len);
> -
> -	if (!mem || len != sizeof(*mem)) {
> -		pr_err("failed to get preserved KHO memory tree\n");
> -		return -ENOENT;
> -	}
> -
> -	if (!*mem)
> -		return -EINVAL;
> -
> -	tree.root = phys_to_virt(*mem);
> -	mutex_init(&tree.lock);
> -	return kho_radix_walk_tree(&tree, kho_preserved_memory_reserve);
> +	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));

Do we really want to remove an explicit check for 0 and get a WARN() in
kho_radix_walk_tree()?

> +	mutex_init(&kho_in.radix_tree.lock);
> +	return kho_radix_walk_tree(&kho_in.radix_tree,
> +				   kho_preserved_memory_reserve);
>  }
>  
>  static __init int kho_out_fdt_setup(void)
> @@ -1597,8 +1584,10 @@ void __init kho_memory_init(void)
>  	if (kho_in.scratch_phys) {
>  		kho_scratch = phys_to_virt(kho_in.scratch_phys);
>  
> -		if (kho_mem_retrieve(kho_get_fdt()))
> +		if (kho_mem_retrieve(kho_get_fdt())) {
>  			kho_in.fdt_phys = 0;
> +			kho_in.radix_tree.root = NULL;

I'd make kho_mem_retrieve() void and put these there.

> +		}
>  	} else {
>  		kho_reserve_scratch();
>  	}
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

-- 
Sincerely yours,
Mike.

