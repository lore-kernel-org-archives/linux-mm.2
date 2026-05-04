Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24EA4CD3430
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 14:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CC666B0005; Mon,  4 May 2026 10:44:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57CE46B008A; Mon,  4 May 2026 10:44:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D6D6B008C; Mon,  4 May 2026 10:44:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30C2D6B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 10:44:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D002C1401F8
	for <linux-mm@kvack.org>; Mon,  4 May 2026 14:44:52 +0000 (UTC)
X-FDA: 84730009224.01.1D3518D
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id F2D40A000B
	for <linux-mm@kvack.org>; Mon,  4 May 2026 14:44:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=He8fR+nV;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777905891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jMK9CbMmL+n4tiRm5m3IaX0DcVz+Sz54nDXJZPFiknU=;
	b=N651sW/+C7MHbS27fBNn31xL8UKyKt4YRYoVosfTXecJgKIningIqeKx3wkOt8cbVnXCVH
	bxB7Sn8Gxm2C7mGDDWpJLeFG+vLlkIFx3OLEmyYm6mzwuSEAPcdoY+uHP9XYSqQCmi/wDo
	rHmmLnlYWOrEyupDa5HSpqlrBXv00FQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=He8fR+nV;
	spf=pass (imf25.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777905891; a=rsa-sha256;
	cv=none;
	b=QQ9ZMIAOWbUTmHIzKBF6cBdg6wdmuR/82FCMYvCD3dB5TSBNq99mIZAUNt6qhclD8MPjhb
	rH+LccNuuYi1MHwLUDQ9CMjBLJSE6xvOO6hyE1NdBFlqeCJ08ynBMtd49KZi0x165T7dDn
	9Oi57nng7yYr+6YILFmBMDxTepH+AGc=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-50fb8e9a4edso51363131cf.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 07:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777905890; x=1778510690; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jMK9CbMmL+n4tiRm5m3IaX0DcVz+Sz54nDXJZPFiknU=;
        b=He8fR+nVR7kxcM3vumRw55hX18mSukyKB7LOgBx7cfZ01vbXpB71K+bOh/T/uKI43P
         G5bugZopUMf5zxBw9ZIeN+iQlRojsYVDDzZDC+evG03zYHtpOdsicigPjquTiE+fPnpK
         KTZmtgbaH7eYM3SpulzWrw03CBIfY4JtEjUbEykkzhQme90Kt97hRXOD4KKxvXMyu5GL
         +WWlNU00ek/CKyCfdPGMB+9VZVjK2hEgnTOIRAAWpq6uJBjfqEkDtv8ci4npnMw1ZO1R
         t18wSBT2cvQkBIQp/Vu884LdwTzgUS7z+H5S2FdrFPyrwjjsfSpIMkq5wsVlYHrvScgr
         HOcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777905890; x=1778510690;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jMK9CbMmL+n4tiRm5m3IaX0DcVz+Sz54nDXJZPFiknU=;
        b=V/SZu54lFskAszFW8DoA/1E2LLMCeI18lVY5WND1FyTx9n4TOo7Vj5Ut8h75C2Pcca
         XKvf1vyPcJA6uBIya40n1csXWIs9ev/t20UjhALDAeJ75DL14xBAYWUOjuWwVZz4spl5
         veQkVfBnsL79UrZelu3qkCuBNUhJtWruPfDGZOWz4Yz+J0YGOax01RICSVNSRG+Wc7Ao
         +YX1NnPS8oPqNULL8ZXO/tYbyTBsVS9yO/sbXHIDTubaBqfaUho3KW6RJCtYv8/Mm5iw
         b+jLVHzWCp+qkMk3vJQFTy0zgi/AuqCNUlW8LQgNFMhfC/VVUwxjbIBX7hdeqKG7ntsd
         nqfw==
X-Forwarded-Encrypted: i=1; AFNElJ9ePln7I+xox9Ror7JHcDQ73HNrSJMckNNkTceHPIGAbzDaSlxa8ARj8BZxyImrMfA9wXFsE2+Sqw==@kvack.org
X-Gm-Message-State: AOJu0YyEwlxSCLm/uMa5AUGYV3HX5VPSMSjUAjO8GvM0HZ15oIZSADTd
	mCu1vas2xOaRM/URphXausf3B39I4aDUvYYJTdQp22o1hXu8eliHJYT3zCAzZ8893baAEqaJnCB
	pnfEP
X-Gm-Gg: AeBDievPxhZa8XY6SWH16ArSOmbWG0ZfXcIYQOI+06ZJIa2TnQieSZQu/rdL7rw5B2I
	AaHKIFeP45770gOGcihWcMdkAPIqcTZ20AnYQhHEyVQJMbt3k8qb4SqQmx5LTOjIjEBUM3Bsk7V
	s8iH60yNvgz6nNFoCFO2MTyLtiCpdNpFWcqJEd0C/WMUhocaKteXwHncozyGyAEHNCzBOXT1NZy
	S9PlDaQw1G3ICeQPxIACWFcqrI/+HTGVqlvrdl9vVcl/Ly4ji7fd9KpV3AJ90QsQ/3oQGQrrF6R
	zwF0USKYdrv85g6AQiskl/pqp70X5s4aDpomykmGparX91mhYGPWtEM13P3Dz1bWUgHXKcirvHW
	SLWGm82I+Nh2Q/p66u6/KlG6jKLzfJhoKwYOsmHlL6w/DmGWSKZts9Kokv9QSsFSCCLN25RWFZu
	wOj1O1nc+/1pia7XP0dbAoMnf3pbIqdZRSmuLEIZGlQ3Loz4dz2UbP+QeHvEEHIA==
X-Received: by 2002:a05:622a:4206:b0:50d:6a40:692a with SMTP id d75a77b69052e-5104be7625cmr148834121cf.18.1777905889904;
        Mon, 04 May 2026 07:44:49 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040ba8acdsm100582571cf.31.2026.05.04.07.44.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 07:44:49 -0700 (PDT)
Date: Mon, 4 May 2026 14:44:48 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/12] kho: generalize radix tree APIs
Message-ID: <afiwy31X4WANSk1q@plex>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-2-pratyush@kernel.org>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F2D40A000B
X-Rspam-User: 
X-Stat-Signature: jm5aetj6btp7pcjwgr96367erbcyapik
X-HE-Tag: 1777905890-129591
X-HE-Meta: U2FsdGVkX18dMwAvXQG9zspewdnCPmrX4Ejfc3lUvEAZUqPsG2rM2G+X1N/dnnyoVFDhPvoMMIn3jMT8UK60eH5ZkElYQ/svb+h3TvVxmbhud6kp7bvgIkGFMfjp2Mp8K5Dp5G978XA345HYyiLxzBJbHNN4/D1wOYAcHoW0no81uip+EK7c6fO6Z/jkLCSNn60/Y88goWM14tkG2NmnM8pHA6fFymIojuLrydIYkwB5cCyIj+AAJpA1Gn93S4FV3jnNEtvLtmTZ4CalTcsjbXoZkZgu4uXcwN58aJ4MLjndzsoM0iR0vkY8CWKAiNfFdycWRxAY2hvz9dgvGMQHrY2/HQ2t8eCkwJ5bQIZ+bNN/gbaa9LAnhPGSKCfv+5X9gb4or5NsrQqv3iFezrPOqo2u8Pq3SQ6oKMYfi/N3oEeS18sCvbg7F3k11CNCSWhSYx8PcHDy1FQbljn2CO8NS3keeOEn8dRqhW32mLgyy5PchIdF9VVtKF7o7n6NpjaEgRKZGvo7Ke63dVlQgJzwiiaUMNNNBfc5G3tnbS6+VuRJY6GVxhEMXjmwiTV4gRG3qgW8QxfzWisycnzORREJwviGx9N2ypurXa9DPzbI8pKcn5e0Uuo/IqE1tyqZgVvPL2yNi/n9Db5RnQkfUwtXhCng3n2R3/8IYa7tISHhiFNI8oZL2LM6Sw2XFrAGfoFOA8DQXWR/LdHlJlGVQ4B5h+rXBQdYa0P+IxGLC+oahg3WW44vxESCDQM6L4YJJMfiMrkuUN7lpBzm/xfLWlUUR7wVKrzLEJ9P4+gSr68QsduWTbczf1E+vnAzcW7Bq0xDp6Rfav1MYcMpBkUMV9YX+MN9TiNqeYGPcE4OPzNrOrHvf9k3HPogt4lzIDJWbaP026+vj4ctwF4Ppa0MnNdTvkGjOk6kfhzEYwurvmufokM8IiOLFsRuqDBN3KjYK26a+QNrKwTWaHn0xMCugDY
 U7PhjqIe
 ssNqYdxx8sBGRDMJGbzxvoTOLHiZhn7YXJRA1IgAi6QX+PShkIxQhgBSgxHBqev0aEEu7BRxroh4CaOLBmE2rYnh3xKWUrsU7CYrIXMZ9fzQA6ZNpB9dqAo88pmmHtwpsRPt2CgygrgLKL3Lntd4cBFLhieh68uQ9ndhIgUOMXDsb7bHvf/VJ7IHZu0xO5dRIgLwxLZC60OoashLBmjt//OeWHpOQIMTf8n1Dp1qqKtQdWjlyvvOe4Y/T/4vMqOmJQ89eKRehMeI6Qcr084knvUp9d0+4iaqg3gYzMuCD2arrmt9CyjjJ6Uu7hpJ/bgtBK487VLUL6WR/F5kD5G/o8XDjlq6JpCi47nxt191fBxVgXCo1yxBR/ACyY6afsmJmbaxey8WivGaspE6puXpq7FzJDvC6D29H4Ztw4QMVDuX2On8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-29 15:39, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The KHO radix tree is a data structure that can track the presence or
> absence of an arbitrary key, with nothing inherently tied to KHO memory
> preservation tracking. This was one of the design goals of the radix
> tree. This was done to enable it to be re-used by other users of KHO.
> 
> Despite that, the radix tree APIs are very closely tied to KHO memory
> preservation tracking. Adding a key is done by kho_radix_add_page(),
> which encodes it as a page tracking operation and takes in PFN and
> order. kho_radix_del_page() does the same. These functions encode the
> key internally that goes into the radix tree. kho_radix_walk_tree() does
> the same by baking the PFN and order into the callback arguments.
> 
> Generalize the APIs by taking the key directly and doing the encoding at
> the callers. Rename the functions to kho_radix_add_key() and
> kho_radix_del_key(). In practice, this removes a line each from the
> functions and moves the encoding function call to the callers.
> Similarly, update kho_radix_tree_walk_callback_t to take the key
> directly.
> 
> To keep the naming convention clearer, rename
> kho_radix_{encode,decode}_key() to kho_{encode,decode}_radix_key().
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

> ---
>  include/linux/kho_radix_tree.h     | 18 +++----
>  kernel/liveupdate/kexec_handover.c | 76 ++++++++++++++----------------
>  2 files changed, 42 insertions(+), 52 deletions(-)
> 
> diff --git a/include/linux/kho_radix_tree.h b/include/linux/kho_radix_tree.h
> index 84e918b96e53..f368f3b9f923 100644
> --- a/include/linux/kho_radix_tree.h
> +++ b/include/linux/kho_radix_tree.h
> @@ -34,30 +34,24 @@ struct kho_radix_tree {
>  	struct mutex lock; /* protects the tree's structure and root pointer */
>  };
>  
> -typedef int (*kho_radix_tree_walk_callback_t)(phys_addr_t phys,
> -					      unsigned int order);
> +typedef int (*kho_radix_tree_walk_callback_t)(unsigned long key);
>  
>  #ifdef CONFIG_KEXEC_HANDOVER
>  
> -int kho_radix_add_page(struct kho_radix_tree *tree, unsigned long pfn,
> -		       unsigned int order);
> -
> -void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
> -			unsigned int order);
> -
> +int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key);
> +void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key);
>  int kho_radix_walk_tree(struct kho_radix_tree *tree,
>  			kho_radix_tree_walk_callback_t cb);
>  
>  #else  /* #ifdef CONFIG_KEXEC_HANDOVER */
>  
> -static inline int kho_radix_add_page(struct kho_radix_tree *tree, long pfn,
> -				     unsigned int order)
> +static inline int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
>  {
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline void kho_radix_del_page(struct kho_radix_tree *tree,
> -				      unsigned long pfn, unsigned int order) { }
> +static inline void kho_radix_del_key(struct kho_radix_tree *tree,
> +				     unsigned long key) { }
>  
>  static inline int kho_radix_walk_tree(struct kho_radix_tree *tree,
>  				      kho_radix_tree_walk_callback_t cb)
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 33fcf848ef95..ba568d34c5b4 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -85,7 +85,7 @@ static struct kho_out kho_out = {
>  };
>  
>  /**
> - * kho_radix_encode_key - Encodes a physical address and order into a radix key.
> + * kho_encode_radix_key - Encodes a physical address and order into a radix key.
>   * @phys: The physical address of the page.
>   * @order: The order of the page.
>   *
> @@ -95,7 +95,7 @@ static struct kho_out kho_out = {
>   *
>   * Return: The encoded unsigned long radix key.
>   */
> -static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order)
> +static unsigned long kho_encode_radix_key(phys_addr_t phys, unsigned int order)
>  {
>  	/* Order bits part */
>  	unsigned long h = 1UL << (KHO_ORDER_0_LOG2 - order);
> @@ -106,17 +106,17 @@ static unsigned long kho_radix_encode_key(phys_addr_t phys, unsigned int order)
>  }
>  
>  /**
> - * kho_radix_decode_key - Decodes a radix key back into a physical address and order.
> + * kho_decode_radix_key - Decodes a radix key back into a physical address and order.
>   * @key: The unsigned long key to decode.
>   * @order: An output parameter, a pointer to an unsigned int where the decoded
>   *         page order will be stored.
>   *
> - * This function reverses the encoding performed by kho_radix_encode_key(),
> + * This function reverses the encoding performed by kho_encode_radix_key(),
>   * extracting the original physical address and page order from a given key.
>   *
>   * Return: The decoded physical address.
>   */
> -static phys_addr_t kho_radix_decode_key(unsigned long key, unsigned int *order)
> +static phys_addr_t kho_decode_radix_key(unsigned long key, unsigned int *order)
>  {
>  	unsigned int order_bit = fls64(key);
>  	phys_addr_t phys;
> @@ -144,24 +144,21 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
>  }
>  
>  /**
> - * kho_radix_add_page - Marks a page as preserved in the radix tree.
> + * kho_radix_add_key - Add a key to the radix tree.
>   * @tree: The KHO radix tree.
> - * @pfn: The page frame number of the page to preserve.
> - * @order: The order of the page.
> + * @key: The key to add.
>   *
> - * This function traverses the radix tree based on the key derived from @pfn
> - * and @order. It sets the corresponding bit in the leaf bitmap to mark the
> - * page for preservation. If intermediate nodes do not exist along the path,
> - * they are allocated and added to the tree.
> + * This function traverses the radix tree based on the key provided. It sets the
> + * corresponding bit in the leaf bitmap to mark the key as present. If
> + * intermediate nodes do not exist along the path, they are allocated and added
> + * to the tree.
>   *
>   * Return: 0 on success, or a negative error code on failure.
>   */
> -int kho_radix_add_page(struct kho_radix_tree *tree,
> -		       unsigned long pfn, unsigned int order)
> +int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
>  {
>  	/* Newly allocated nodes for error cleanup */
>  	struct kho_radix_node *intermediate_nodes[KHO_TREE_MAX_DEPTH] = { 0 };
> -	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
>  	struct kho_radix_node *anchor_node = NULL;
>  	struct kho_radix_node *node = tree->root;
>  	struct kho_radix_node *new_node;
> @@ -224,22 +221,19 @@ int kho_radix_add_page(struct kho_radix_tree *tree,
>  
>  	return err;
>  }
> -EXPORT_SYMBOL_GPL(kho_radix_add_page);
> +EXPORT_SYMBOL_GPL(kho_radix_add_key);
>  
>  /**
> - * kho_radix_del_page - Removes a page's preservation status from the radix tree.
> + * kho_radix_del_key - Removes the key from the radix tree.
>   * @tree: The KHO radix tree.
> - * @pfn: The page frame number of the page to unpreserve.
> - * @order: The order of the page.
> + * @key: The key to remove.
>   *
>   * This function traverses the radix tree and clears the bit corresponding to
> - * the page, effectively removing its "preserved" status. It does not free
> - * the tree's intermediate nodes, even if they become empty.
> + * the key, effectively removing it from the tree. It does not free the tree's
> + * intermediate nodes, even if they become empty.
>   */
> -void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
> -			unsigned int order)
> +void kho_radix_del_key(struct kho_radix_tree *tree, unsigned long key)
>  {
> -	unsigned long key = kho_radix_encode_key(PFN_PHYS(pfn), order);
>  	struct kho_radix_node *node = tree->root;
>  	struct kho_radix_leaf *leaf;
>  	unsigned int i, idx;
> @@ -270,21 +264,18 @@ void kho_radix_del_page(struct kho_radix_tree *tree, unsigned long pfn,
>  	idx = kho_radix_get_bitmap_index(key);
>  	__clear_bit(idx, leaf->bitmap);
>  }
> -EXPORT_SYMBOL_GPL(kho_radix_del_page);
> +EXPORT_SYMBOL_GPL(kho_radix_del_key);
>  
>  static int kho_radix_walk_leaf(struct kho_radix_leaf *leaf,
>  			       unsigned long key,
>  			       kho_radix_tree_walk_callback_t cb)
>  {
>  	unsigned long *bitmap = (unsigned long *)leaf;
> -	unsigned int order;
> -	phys_addr_t phys;
>  	unsigned int i;
>  	int err;
>  
>  	for_each_set_bit(i, bitmap, PAGE_SIZE * BITS_PER_BYTE) {
> -		phys = kho_radix_decode_key(key | i, &order);
> -		err = cb(phys, order);
> +		err = cb(key | i);
>  		if (err)
>  			return err;
>  	}
> @@ -332,15 +323,14 @@ static int __kho_radix_walk_tree(struct kho_radix_node *root,
>  }
>  
>  /**
> - * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each preserved page.
> + * kho_radix_walk_tree - Traverses the radix tree and calls a callback for each key.
>   * @tree: A pointer to the KHO radix tree to walk.
>   * @cb: A callback function of type kho_radix_tree_walk_callback_t that will be
> - *      invoked for each preserved page found in the tree. The callback receives
> - *      the physical address and order of the preserved page.
> + *      invoked for each key in the tree.
>   *
>   * This function walks the radix tree, searching from the specified top level
> - * down to the lowest level (level 0). For each preserved page found, it invokes
> - * the provided callback, passing the page's physical address and order.
> + * down to the lowest level (level 0). For each key found, it invokes the
> + * provided callback.
>   *
>   * Return: 0 if the walk completed the specified tree, or the non-zero return
>   *         value from the callback that stopped the walk.
> @@ -365,7 +355,8 @@ static void __kho_unpreserve(struct kho_radix_tree *tree,
>  	while (pfn < end_pfn) {
>  		order = min(count_trailing_zeros(pfn), ilog2(end_pfn - pfn));
>  
> -		kho_radix_del_page(tree, pfn, order);
> +		kho_radix_del_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
> +							     order));
>  
>  		pfn += 1 << order;
>  	}
> @@ -498,13 +489,16 @@ static struct page *__init kho_get_preserved_page(phys_addr_t phys,
>  	return pfn_to_page(pfn);
>  }
>  
> -static int __init kho_preserved_memory_reserve(phys_addr_t phys,
> -					       unsigned int order)
> +static int __init kho_preserved_memory_reserve(unsigned long key)
>  {
>  	union kho_page_info info;
>  	struct page *page;
> +	unsigned int order;
> +	phys_addr_t phys;
>  	u64 sz;
>  
> +	phys = kho_decode_radix_key(key, &order);
> +
>  	sz = 1 << (order + PAGE_SHIFT);
>  	page = kho_get_preserved_page(phys, order);
>  
> @@ -858,7 +852,8 @@ int kho_preserve_folio(struct folio *folio)
>  	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
>  		return -EINVAL;
>  
> -	return kho_radix_add_page(tree, pfn, order);
> +	return kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
> +							    order));
>  }
>  EXPORT_SYMBOL_GPL(kho_preserve_folio);
>  
> @@ -876,7 +871,7 @@ void kho_unpreserve_folio(struct folio *folio)
>  	const unsigned long pfn = folio_pfn(folio);
>  	const unsigned int order = folio_order(folio);
>  
> -	kho_radix_del_page(tree, pfn, order);
> +	kho_radix_del_key(tree, kho_encode_radix_key(PFN_PHYS(pfn), order));
>  }
>  EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
>  
> @@ -916,7 +911,8 @@ int kho_preserve_pages(struct page *page, unsigned long nr_pages)
>  		while (pfn_to_nid(pfn) != pfn_to_nid(pfn + (1UL << order) - 1))
>  			order--;
>  
> -		err = kho_radix_add_page(tree, pfn, order);
> +		err = kho_radix_add_key(tree, kho_encode_radix_key(PFN_PHYS(pfn),
> +								   order));
>  		if (err) {
>  			failed_pfn = pfn;
>  			break;
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

