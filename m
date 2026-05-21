Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 097B9CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 23:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56B666B009D; Thu, 21 May 2026 19:34:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 542EA6B009E; Thu, 21 May 2026 19:34:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 480E46B009F; Thu, 21 May 2026 19:34:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A91C6B009D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:34:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB8061408DC
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:34:29 +0000 (UTC)
X-FDA: 84793033458.14.0F7E5C4
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf04.hostedemail.com (Postfix) with ESMTP id 20BD04000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:34:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JVLXQ4TI;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779406468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2qvJumL5Uy9qaseIh6HBDqg5ydk4M44ynTEuc1EKrP8=;
	b=dtupTit2OwSlmvrOL/aduvzFPCtS24urf8Y9c2yBwZoGJRnhoHCPUQKi7CowC1ZXY21udg
	wEg/hdAZkw9tFS03PgnDWrwDvurfFYrRa6+jKOkmqlcouHDY7yTODjwBpFXF1/odC0Hoz7
	7kD7fu87u8qb7PBvMevyR845WVtQguU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=JVLXQ4TI;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779406468; a=rsa-sha256;
	cv=none;
	b=o3n919y9L4/mfxlSyPOvSTY50mUXT6hShHVtPK0epQeCNv8HGBsF++/XPcNrNX6Dc/QDSk
	40JqsRiC6rAmDMiHmFKqVHNEpsN+26hqO9SrzCl7k22gYTPymqO/kyylc4D7ZW9hYAyCBr
	rB/BHtFw3Bi7tgQtnMUXjIV2A2A6ZDw=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8b5cda2dab9so74495996d6.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 16:34:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779406467; x=1780011267; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2qvJumL5Uy9qaseIh6HBDqg5ydk4M44ynTEuc1EKrP8=;
        b=JVLXQ4TIE9hmRaGsZ7swrqOAh93FdNHA8a5kp/kPxfPSBbsbyLVT1xq7wCaMjfUVi6
         aGeMsUFmYIKnXg6sPq5MJmE2x1bwreEmBOA2Gw+Is+nt8x31piLOcUccXak/3MJRbBDM
         06gRwefYboP+bXLwpFfptJaV53O1EO6mtAy06k5ym6wiJXd29gBw3wMhvwNbwhzuY5aA
         BQbh0C+yNocNusyWZ7hUGwZn5xtxiuvzn+4lZeQRr2KesfmeV3QIJmzKGmuDlgI7c10v
         qPvZyulqBKNBR1psMHev3VK26eojUh8qUkutbXq/3dhopyhwdREUycnYNq/fz50Hyqvp
         C5eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779406467; x=1780011267;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2qvJumL5Uy9qaseIh6HBDqg5ydk4M44ynTEuc1EKrP8=;
        b=e8wkGshKu1zlA6Sq7uSUrkxsmgWFJjSrof5ltrQHRcX0VudD5ZgJf536XYG8yFM9HZ
         Ro2fv0I87Q+dlkGFyTOM+91GnZ+aZgncPdlBCu6SWL0FveZsdSHFqiglx3+ytfEp7jtY
         dQcX46niVfp8QTvZuu3KYTV5KQZh93wZZTZm9uj8Fod6fGUuk4hpSNDLVlHLyRB04IUa
         6kG4BaIdJ+1/cXrR8TiJWqhCFlyJKNJ9W/VMdR2s8oCKycxFnMl998N3MyM7d7otOYMN
         3tNV14nh1Eo2r2/OlBlvotz5J3SNW5oSblqI6kzGSlnG4sWxSw3SZj4S0c7BcY5M//mf
         Assw==
X-Forwarded-Encrypted: i=1; AFNElJ8lQWeOCN3O0ZvCgtzsSvG4V6x+AzN+Ii4U//dbqHyU/nqHVzbSTyym8xP0fU9xSphkQ6ZaqIKHHw==@kvack.org
X-Gm-Message-State: AOJu0YwlCPcXPCnv6KG3UBxdlBXTTo3umQ8O9glUFISL0CQ7/G6NRRc1
	htdBZYLHyDG58Ff1QPNJHVvK+Of9M6zFv1gYxPpsoT7xOGvKyyU3nYEYR0fD1hz92cU=
X-Gm-Gg: Acq92OH7sbFC6gpDAbYG1cG9kBwcH19PoMGQIGO2kp0v3YTu1ePlk3JxDFFVaV/6mws
	yfE0QEnihsPLnJ2yeyczAeazON0gKeKm/bvPNOhXrLc+PAFRieZ5TzViB14FbE+wDzA2el9jGUA
	aknVIs41wBW1Sq0hBLMFbuz4TiYV9k2hDuji6fk5O8w911Pp0UuQYiuxezNsytlQZi39EDspCPM
	Nw2ZIn77wrgQ+7aLe/jaZ9fVXtjCksSGmOTTUV35OQHIiQ3SwYJca1ykP2gSmKAY2tb7Z1xXrSF
	hZG8EN93XUTEp0T9BUnTf7KqSr5zun+2jVg77j+jjdS0MEBYCSh2Nl75fKEMrEKeY2YorN+HBWO
	MJm58VqSM+lkcwoE8gjGrbFPSzqP29VeXC+1Z2XiUoiE7qKzuEGxkpiaIMtKmVMpnxoEoPwxM8E
	FcDpcz1yPK52Z/+srHM0KUgPvfp+UVRYHPzbqsDcxsrGPTOVFf8/c=
X-Received: by 2002:a05:6214:5882:b0:8a7:164c:d5c8 with SMTP id 6a1803df08f44-8cc7bf194acmr13939606d6.24.1779406467102;
        Thu, 21 May 2026 16:34:27 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc8132429bsm1526136d6.47.2026.05.21.16.34.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 16:34:26 -0700 (PDT)
Date: Thu, 21 May 2026 23:34:25 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/12] kho: add data argument to radix walk callback
Message-ID: <ag-WdmAZXjb905-X@plex>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-6-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-6-pratyush@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 20BD04000A
X-Stat-Signature: 9dfkpixpjnpay4rss4ofwmdmfyx3m6ju
X-Rspam-User: 
X-HE-Tag: 1779406467-363020
X-HE-Meta: U2FsdGVkX1+K2Eu3guOn8/evBRjBqfkw1atpr2LcAF5RvAkHeF7deuUDtb/gb6mFFkkMijJPBXzcCCBCRHHZgZuiyV0lr32fPnadkevAQotmS7Q7xqrapO+gGYwS4O/txLx/ZCLpguFqTFNEmyrsP+Rg4dqLuYdTuCAAH+g5ALEfQc27Eos0txjmRzYInqdXRTdIzgBNlo0+r2uvFpS8yrPKd8CCKKG3knpqvhY06ufBpA8+y/2vW47zw3GhRQp5kiWTQf6LrYRqvpVEGU+LK22ecaYXd9GUD262czp3xyIsjFpjtt+9qtp76Mk0T3nGxNQW0Y0uBJyigfCGzzVIpptBQVxGL65pA/skGnU9FIKrk+TUiFrmLNMTe8oRz2GqbBb7kYFbzU006axsJR0nn8u9eij1eoVVHkripbyx+rbDWD2rXJ95fAzpVYbT9YQkXWkNRL3UVgkYzN+5486GyjxDf9WP+RlxLIXwSQxpttKsXOtasaj4JzUz4gKW+n0sAINKSfG0E8dKpdCZ+UHwKoi8v5ZaggWp+Tx+7eAOOaROws54OzCuhPxanA6a7/Q2TPcVT79tSf0uVlPeE/BlAy1/LjaLUF/Jyh9xQw0dhyA2eKUGn9o+h6SfZzvCV2DSSdQXZB6SS6LuV81Lc5R+ZG2vJYR3ty9IBiaYAimDxHB7e2mR/9Y/EfsuXH33ezteqgkzREJOvQFyQ41m7IYogk1P53tUAwdDUARaysEeIGD9J6H4jZMRU36xTaVVrOmtiyfnmZ6I7nPU8t8prKmjEaUwbmbbb4XiJEnKpFOhZVrEYwYgWyzSuULMDo17e4QNSWLKtcn7G+SIwB3ZK9MGnzjOUfYdatAbTvczFzsVv2RTBv7c1ysccOIzd8YH7xU0qFL6H56D84vHQofIuEO5MF4l9wpZ91wfSNXnArSEhmm7Jri3aucYMYgpwJWS/26mCNK21pjNtmYcFOm2UYG
 oOkcxCfD
 GddTPB8ujSsbB0di7xoEvQlrwUK9OAd/31toD62ELtxa831QGUJCTaDEDoooEvKaOsaqBAimAnOYNhuv9aFBqYhSv+5xz560rOiqFQSrIOcPBqIFgxg0neg0bGZD/CbSfq30OQKlEnOAAssKHts9o24LJBHu+HTG5LYxDUh4tiGr9aDrEiGa7DnPGaz7XrBI4YMhtWMqrVKEfJKSKDTJOlUcEV4r+HsNvtKJLa8THsMVz+Mu5QJmaJNXW9sp3U08ADZnbPWKCg6PAG9UZwEwKLBpf4Kg+JZvql9rXJzpoU6Kez6gdQvahPMFvPUjPHpHdDwrTPNF7BvspvG3Vm+AEu2I4hZsool5h4E3bU360hJ87Nhe9PV710vsZGku/izl/IV+6OMG6rjHPwjj1paHbtOjwYzCsd4sZjguCpQdd1NCOXeXYRedmauZamvmcUp0xUqZRHCGjx4WBTM/mvk3Fz3QVYlTHlnQKksOF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-29 15:39, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> Add an opaque data pointer argument to kho_radix_walk_cb_t. This can be
> used for callers to pass extra information to the callback.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/kho_radix_tree.h     |  8 ++++----
>  kernel/liveupdate/kexec_handover.c | 24 +++++++++++++-----------
>  2 files changed, 17 insertions(+), 15 deletions(-)

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

> 
> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
> index fe7151d89361..6c0f7d82716b 100644
> --- a/include/linux/kho_radix_tree.h
> +++ b/include/linux/kho_radix_tree.h
> @@ -44,8 +44,8 @@ struct kho_radix_tree {
>   * return value is directly returned to the caller.
>   */
>  struct kho_radix_walk_cb {
> -	int (*key)(unsigned long key);
> -	int (*table)(phys_addr_t phys);
> +	int (*key)(unsigned long key, void *data);
> +	int (*table)(phys_addr_t phys, void *data);
>  };
>  
>  #ifdef CONFIG_KEXEC_HANDOVER
> @@ -53,7 +53,7 @@ struct kho_radix_walk_cb {
>  int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
>  void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
>  int kho_radix_walk_tree(struct kho_radix_tree *tree,
> -			const struct kho_radix_walk_cb *cb);
> +			const struct kho_radix_walk_cb *cb, void *data);
>  
>  #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
>  
> @@ -66,7 +66,7 @@ static inline void kho_radix_del_key(struct kho_radix_tree *tree,
>  				     unsigned long key) { }
>  
>  static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
> -				      const struct kho_radix_walk_cb *cb)
> +				      const struct kho_radix_walk_cb *cb, void *data)
>  {
>  	return -EOPNOTSUPP;
>  }
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 94ca831b41c9..d0a4f78eccfe 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -267,14 +267,14 @@ void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
>  EXPORT_SYMBOL_GPL(kho_radix_del_key);
>  
>  static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
> -			       const struct kho_radix_walk_cb *cb)
> +			       const struct kho_radix_walk_cb *cb, void *data)
>  {
>  	unsigned long *bitmap = (unsigned long *)leaf;
>  	unsigned int i;
>  	int err;
>  
>  	if (cb->table) {
> -		err = cb->table(virt_to_phys(leaf));
> +		err = cb->table(virt_to_phys(leaf), data);
>  		if (err)
>  			return err;
>  	}
> @@ -283,7 +283,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
>  		return 0;
>  
>  	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
> -		err = cb->key(key | i);
> +		err = cb->key(key | i, data);
>  		if (err)
>  			return err;
>  	}
> @@ -293,7 +293,7 @@ static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf, unsigned long key,
>  
>  static int __kho_radix_walk_tree(struct kho_radix_node *root,
>  				 unsigned int level, unsigned long start,
> -				 const struct kho_radix_walk_cb *cb)
> +				 const struct kho_radix_walk_cb *cb, void *data)
>  {
>  	struct kho_radix_node *node;
>  	struct kho_radix_leaf *leaf;
> @@ -302,7 +302,7 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
>  	int err;
>  
>  	if (cb->table) {
> -		err = cb->table(virt_to_phys(root));
> +		err = cb->table(virt_to_phys(root), data);
>  		if (err)
>  			return err;
>  	}
> @@ -323,10 +323,10 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
>  			 * node is pointing to the level 0 bitmap.
>  			 */
>  			leaf = (struct kho_radix_leaf *)node;
> -			err = kho_radix_walk_leaf(leaf, key, cb);
> +			err = kho_radix_walk_leaf(leaf, key, cb, data);
>  		} else {
>  			err  = __kho_radix_walk_tree(node, level - 1,
> -						     key, cb);
> +						     key, cb, data);
>  		}
>  
>  		if (err)
> @@ -340,6 +340,7 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
>   * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each key.
>   * @tree: A pointer to the KHO radix tree to walk.
>   * @cb:   Set of callbacks to be invoked during the tree walk.
> + * @data: Opaque data pointer passed to each callback in @cb.
>   *
>   * This function walks the radix tree, searching from the top level down to the
>   * lowest level (level 0), invoking the appropriate callbacks.
> @@ -348,14 +349,15 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
>   *         value from the callback that stopped the walk.
>   */
>  int kho_radix_walk_tree(struct kho_radix_tree *tree,
> -			const struct kho_radix_walk_cb *cb)
> +			const struct kho_radix_walk_cb *cb, void *data)
>  {
>  	if (WARN_ON_ONCE(!tree->root))
>  		return -EINVAL;
>  
>  	guard(mutex)(&tree->lock);
>  
> -	return __kho_radix_walk_tree(tree->root, KHO_TREE_MAX_DEPTH - 1, 0, cb);
> +	return __kho_radix_walk_tree(tree->root, KHO_TREE_MAX_DEPTH - 1, 0, cb,
> +				     data);
>  }
>  EXPORT_SYMBOL_GPL(kho_radix_walk_tree);
>  
> @@ -501,7 +503,7 @@ static struct page *__init kho_get_preserved_page(phys_addr_t phys,
>  	return pfn_to_page(pfn);
>  }
>  
> -static int __init kho_preserved_memory_reserve(unsigned long key)
> +static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
>  {
>  	union kho_page_info info;
>  	struct page *page;
> @@ -1392,7 +1394,7 @@ static int __init kho_mem_retrieve(const void *fdt)
>  
>  	kho_in.radix_tree.root = phys_to_virt(kho_get_mem_map_phys(fdt));
>  	mutex_init(&kho_in.radix_tree.lock);
> -	return kho_radix_walk_tree(&kho_in.radix_tree, &cb);
> +	return kho_radix_walk_tree(&kho_in.radix_tree, &cb, NULL);
>  }
>  
>  static __init int kho_out_fdt_setup(void)
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

