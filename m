Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395D8CD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 23:37:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CADC6B0099; Thu, 21 May 2026 19:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8550B6B009B; Thu, 21 May 2026 19:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743BD6B009D; Thu, 21 May 2026 19:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F5576B0099
	for <linux-mm@kvack.org>; Thu, 21 May 2026 19:37:07 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0D63B1C0758
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:37:07 +0000 (UTC)
X-FDA: 84793040094.29.CE883BC
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3F5D21C0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 23:37:05 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=k2jLhXMB;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779406625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vARGoD5RNG/Ecz0OD6Sd5EbHpdRmJLMUv9Hfoq7eURQ=;
	b=qemNAkV6EODL3wsMmMwFlv7ZUsqAxAXC5wAlte7Q1A+XdTmzujM+uy5EXgIlKiHG8tp6S3
	Vhwbuvjp8dMSxUfOlwUYH+smdEp70HAfbJjpusTifD1RmjNqZsuIdbiUz9zH69TzPtf1LK
	Bd1VWuPMdJcIxnRDYhxwTof8zQzDCdE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=k2jLhXMB;
	spf=pass (imf18.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779406625; a=rsa-sha256;
	cv=none;
	b=CdkHWopNsHGBZOY8RNVMjAVnmlbcg4zNygLbh8nuaIkadrztXsEM/lGnNLycG456z75LFB
	WAxOxSDwfiSwsPFo2wJG4KURNEv/lVC4P7Emoy9998Rc9Sh9+ou4m6YDm/XgCOKYonmJzT
	K5kyihNe3i4P5MLdWLBxGuM8FDG9u18=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8b3fe2f19a4so70235256d6.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 16:37:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1779406624; x=1780011424; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vARGoD5RNG/Ecz0OD6Sd5EbHpdRmJLMUv9Hfoq7eURQ=;
        b=k2jLhXMBSFJsMdUa4LFUJfpZP16rjwje/7qf85HJvBwKwG39dmxgK0byn67J2bi+Of
         QZu5q7ob3gvKfMoYQXnkaVLHgNAIGS3B/Exp7k9WZhqrTPwVdfzBI33sTLstlyAIUI1P
         IYk1a6+Dt7z5N3Z1Glht+TcQQbd90GNjPtWbzj0cimlWua+HAYo2IIsUwHMU9k/JZ1G/
         4RcLcO/AYC1e+kPQGaI/CvLfRUFWIqciP3eh/xHh/BSzXtQmYME3mnG40XhOGR3Y8mXL
         H73Z6F2y4fw0tCzVC31jUxcnUExJVpx3IE1tbJTPHG042wPssw5TMVJ/Ms2HUzgb+VqQ
         SaNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779406624; x=1780011424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vARGoD5RNG/Ecz0OD6Sd5EbHpdRmJLMUv9Hfoq7eURQ=;
        b=RsBrE3VXCw6Xj3GzX2YIpqqIOev1gPGd7JQK3G2I8RlC4vFP0pNRZJx4D5nWomkzNg
         xh2j1Io91GyzM0Oy2slW2IvRPZm0eJk9vqPz3surnUuulQ2nnC4b4FouT4DwRKS/j+YH
         d08/Qv0KYv9asXFw0E8OL8oemeyn5IZJH3X6nn5fYJ+yqBtk8VO3rr2wAuKNsNJTakBL
         Fa7fNmgW8paFRPycctNsnosDkoPozmOAONp/3Y6swXeKah77X3Q6QlQ7IA8F0yzQY3Wr
         kZx6be8K/1u/JPo2oBH10vYWRmWHDXu+1qTZterHbjnK6rZzzYCZF8juVv5fzXaJvfYY
         iDBA==
X-Forwarded-Encrypted: i=1; AFNElJ92G+Iu12tdwEfdlna5GfkYgIWDOiaEeJYIZTRQBMX/CT9DTDfySWJX/fY5caf51h4csdINj5pkGw==@kvack.org
X-Gm-Message-State: AOJu0YxPOBvaGdvUsRR08cFs9xkQxBQDSzkn5w4cReIwckXuNYE4AGoP
	AIoGiDsIA4hSlfJ8SJQxgzyU6w+53uPUmERjhrv/Ssst1azXoZzxuE64cZ6SpI9epxA=
X-Gm-Gg: Acq92OGIs1wXqkpi5/f+FZ0OdAHbGoHNYLY0f2W20i3JPDCa5JXWXG/VZx0SR+H5MHb
	E9xjelg7BZVQ/oN7bekcrcjDEkzRTb9822FI1xstvwYFsXflBteGfcGFbOF+EZ0WjZKYM4KFHEE
	92gPu3Xrr2AOHsnmP+cwXiXU+S8Z+LRA9c7u9nbIs29Uhd19F+hCf6KprUFtSn0Blq2LIQIxQwW
	6G4gVxmc0OI8pITMlRhc/Dm9KRq1GNLloiT4t+jMZ22lMsyTiWjOht4XQh+Zl7n+nQesQ3A6y8r
	Wg8NY2tj9Z0TMeQGir/y0+3dHDmUCzCCqjUCnVJRGblZLQni3OJJYBfX9K6BpSIjQcvXDWpRWNl
	wU8StqBPzy9SYQCIlt9LGBI9IrsEx5Xu0gxr33LoiXwOi+yVdUtyk4qkWXGxV0hx4k411SEfETM
	AAOw/jljG2RY4Xf5h0ub+m2DII+XAp0ca5Zs0+JAYkgJe3w90ustr5aV9nzq/7ZQ==
X-Received: by 2002:ad4:5dc6:0:b0:8ca:1f6b:a27d with SMTP id 6a1803df08f44-8cc7b61a17fmr24930256d6.20.1779406624423;
        Thu, 21 May 2026 16:37:04 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cc812e657csm1873266d6.24.2026.05.21.16.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 16:37:04 -0700 (PDT)
Date: Thu, 21 May 2026 23:37:03 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Alexander Graf <graf@amazon.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Jason Miu <jasonmiu@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/12] kho: allow early-boot usage of the KHO radix tree
Message-ID: <ag-W3t7CSFHw4Wej@plex>
References: <20260429133928.850721-1-pratyush@kernel.org>
 <20260429133928.850721-7-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260429133928.850721-7-pratyush@kernel.org>
X-Stat-Signature: 7erwg5y16xujwfeofdcqkbnhh4hgf7gh
X-Rspamd-Queue-Id: 3F5D21C0007
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779406625-365732
X-HE-Meta: U2FsdGVkX1+OBrf5svhobUxsDmLeavN8EwnD9Ypu2du4FVeDzIlqVzR+zAe0gLH/BKnUFV3BOMBure54Qdmoa8xuAte/1s+VrCnynmeL9xNHNg2yxrgof/24lh/deFgNnupxT+NseRWVqK8ol2DKyWrmI89gwDt9X1Ls0OWvn+uh4q8rQ4ZeSM0BonK+u7WqdYL7s+c00L0NqJe+4btpdiE/+WCfo4s0bgRwo3BWZItjBuzoBEyzLRAkQc+q0Cp1ZvThly5lF1x+ZP4L6itDSnhp7oD6S89djjxaHmJvlCZVDRxPZZj8Tpdd43jSwivg3vSo53viPmeKmczuxK+sh+WAId1nvq3mEl+QC0Ci6Ce+nODhrz60+w23sdutgMa9txlB38HoEz6Wec/MYhTc9meWMq3FCBwco6NKDwsk+4J0ClxuowPPf5NyENqbhnJMJlBI4t4Vcg2yGtg61z3oZoVwTL7UoTkpmkzF6H9b66RUpDvhRw91wZr6JKA0D34DiJfsG5IdKFz7TsVDfl7YGQXdrArD54cYl7JXT/RDhgFLmYdzpthand1K9cY3mpxH6nE1rNCmAwwwJpvj95MHxAqtnnXMASvIKmGyC8HDQipZ7q3ht5y30wQ+nEfE37Q05Gegb50B3vtCQHaJ2DPwoe2MuIbDGOx9JwYu9KWTbv6nEAFVJez81gKj+et8TBI4Rm//pEv4w49cNxVAboM3NzreHoFqom6bm3dphbZMANqfpsKLntda8et/FIrfbJYDHJC0j3mu2mzOdYtsGOKG9P3uZtNfwQ0nmagOvxaUWXaM+zffkgrwoDuWZHZ3yJtvHZoTmN/G7ozNHTgPvtTsyuLbNn6PyxwgOqHekHFuyJEVnEBZlrpEEzuqebPL1zCokcNyxzCT/m/Ay5Ts72GUp2lOknRpxpamF09CE6Dav5GTAlqv/0K3TfQBOqFBNFpH7+KPDJb67Lqx9EWw469
 k5/vjJtq
 KRgSeD8nDSvv8LQzjSkEtmLmrIzwlnezxSPY5S8BrJbX6SOpH+BRwr1cq1Oafbz6oyr3i2eYIscVXLBtmY20gyj7xfpdfLCW36msHfLEf6FXEPuxMJG4CN03syorm3L5Uqn7D+7MXFh9Q/+tOPFVByi0gLhfAmDW9J1KnH+gGEVBKjBS/Ru/eV4VKBkmX80UzIjK24oZ0zy00CqIQw9YYO3tNlQhb77I5RuaIX5cyff8iAqPP95mX36RqEKcusat06+wAoFSSiYDagyNFeQC7NKxuJlGXKkVC6k6aj+AqZL0ke69qgABLFEDfSBPC2+HZC2Fz3sWvw98oqU8hEtQqpQL+jUDCxevIaoiKZLcr/F6iNX1T4IqCBUmXBYfi+tPZxgcjP+uHIISpw8wfyHMq5w+9DT9F3u42OMYMipfxL5K8cGkwUh1jsgNNq4D3P5vY3kdp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-29 15:39, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> The KHO radix tree allocates memory for table pages from the buddy
> allocator using get_zeroed_page(). This is not available in early boot
> when memblock is still active.
> 
> Using the radix tree in early boot is useful for KHO to track metadata
> about its memory. One such example is for tracking free blocks for
> memory allocation when scratch runs out of space. This feature will be
> added in the following commits.
> 
> Add kho_radix_{alloc,free}_node() which allocate and free the table
> pages. They use slab_is_available() to decide which allocator to use.
> While slab_is_available() indicates availability of the slab allocator,
> it gets initialized right before buddy so it serves the same practical
> purpose.
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com> 

> ---
>  kernel/liveupdate/kexec_handover.c | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index d0a4f78eccfe..47f7c4a2865e 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -143,6 +143,26 @@ static unsigned long kho_radix_get_table_index(unsigned long key,
>  	return (key >> s) % (1 << KHO_TABLE_SIZE_LOG2);
>  }
>  
> +static void __ref *kho_radix_alloc_node(void)
> +{
> +	struct kho_radix_node *node;
> +
> +	if (slab_is_available())
> +		node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
> +	else
> +		node = memblock_alloc(PAGE_SIZE, PAGE_SIZE);
> +
> +	return node;
> +}
> +
> +static void __ref kho_radix_free_node(struct kho_radix_node *node)
> +{
> +	if (slab_is_available())
> +		free_page((unsigned long)node);
> +	else
> +		memblock_free(node, PAGE_SIZE);
> +}
> +
>  /**
>   * kho_radix_add_key - Add a key to the radix tree.
>   * @tree: The KHO radix tree.
> @@ -183,7 +203,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
>  		}
>  
>  		/* Next node is empty, create a new node for it */
> -		new_node = (struct kho_radix_node *)get_zeroed_page(GFP_KERNEL);
> +		new_node = kho_radix_alloc_node();
>  		if (!new_node) {
>  			err = -ENOMEM;
>  			goto err_free_nodes;
> @@ -214,7 +234,7 @@ int kho_radix_add_key(struct kho_radix_tree *tree, unsigned long key)
>  err_free_nodes:
>  	for (i = KHO_TREE_MAX_DEPTH - 1; i > 0; i--) {
>  		if (intermediate_nodes[i])
> -			free_page((unsigned long)intermediate_nodes[i]);
> +			kho_radix_free_node(intermediate_nodes[i]);
>  	}
>  	if (anchor_node)
>  		anchor_node->table[anchor_idx] = 0;
> -- 
> 2.54.0.545.g6539524ca2-goog
> 

