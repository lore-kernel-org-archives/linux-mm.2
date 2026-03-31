Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB1D109B47A
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 14:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B94AB6B0092; Tue, 31 Mar 2026 10:40:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6C2D6B0095; Tue, 31 Mar 2026 10:40:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A828D6B0098; Tue, 31 Mar 2026 10:40:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 98F4D6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:40:56 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4DE3B1A028E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:40:56 +0000 (UTC)
X-FDA: 84606620112.14.34402B3
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id 864AC80010
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:40:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ckx7lRYI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 39NzLaQgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=39NzLaQgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774968054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZfpcLfgq+5yt+rcx10V2YKKXlDGG+s50zObM35odx8=;
	b=rqiGnt1ixinito2CIjJvO963luyId1um/ieE63gDJzrdKBpphCzv9pflswDubUcK0mSdzN
	rsjchBPq0/MexZvwP8Bjf5vHtOr0ZyN6sNjxi9QUR4jGz5a+gG+3w6LmFBQOcnW6WSPBla
	BCGYXAgYPhc6vElvXEfVQmxeWDtTz/s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774968054; a=rsa-sha256;
	cv=none;
	b=vPb0JmbpO0qJygQsC8nKBQw5NFgbMT+VpCI+A4NxXKIvm9VsiezN+nDe6vk0dqFZT8X5oT
	6zWd9AyQ7uaKqI0lyRHMH8zBhCWHPWsmJBTmwoS37cUBLoO8hyBGRSur3JYm1pIb1KmYNN
	VUFB2mMpK7f22pKuU00sHpj9+LqpKhY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ckx7lRYI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 39NzLaQgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=39NzLaQgKCDMYPRZbPcQVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43d02fa5860so1824802f8f.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 07:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774968053; x=1775572853; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=uZfpcLfgq+5yt+rcx10V2YKKXlDGG+s50zObM35odx8=;
        b=Ckx7lRYI+AzFtgOnqCMaW7oQRK54w6KnSL5kXWjjb3TO5/2AXeRvI6ZXzAPJfUc83Z
         lj97Ir/0ZwYkrwPGywifCG0uf+fXIb1Ez/tYuaT5JCYMcH5USwVLMAzbk1yovsiva1pi
         +FAm5Ud74BcDcUDnKqpGUhnOz7QLusMK4AnTYumy37f8dqxxQGDbiNJhk6/MuuJOHmER
         vTip9IotNDNVymlVON1aDIVGzeaie/fjSdH88xTf2rMPZ6Ky9SHD5INq6xGX+fd4Z7Q5
         MzAolrWq2rdGh1XEZ4xIMb9ADA714VRS+8SJ8N0dABAcqVtl314DgAhH8Vuy1SP8MWrx
         pbQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774968053; x=1775572853;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uZfpcLfgq+5yt+rcx10V2YKKXlDGG+s50zObM35odx8=;
        b=l+EqXW0TN4KDR9bGwmcAg45UseiSHAwajWx5hqE4I0GPjHgtZtZraveqdxoiIxhhhr
         13M7k7Fhy/jwvBxaI2cH2AXmpxcH2kQqSVdY/wNZd0YJMKULJDVeUiif8oUweANBNQkV
         mSqRBObVTU5QzvZzJL7FbvSmweuF0G9p7MEZ29JsJ6heiJ6lcmPPH9FGL+NnhgmQZeJq
         HF9NQxe9oQDmcIiEBO2dqHunBinOIuNXbowqveuxTH8ffrdAHc/k6bS4vzbKY+C2wcm3
         G2Go/Mg+PEV/yJ947fDQs3pJ8z2JkNqoYx95a1AJgYozZG4/5g0JZvq2k2I98roM2YkL
         /jhg==
X-Gm-Message-State: AOJu0YzXMALXVpDxemAJBXk/mzL6KqkCMb6Fzq2Hk133DeCLMMtu887d
	DIUlzptkub/Mgaf+xZUR6yqCUJ9XduBVkcOr0CTgZXIxut0+LI12St8LD7sZJMADjod7cJE3gA2
	GoUuzEhFvyTF0QQ==
X-Received: from wrwj2.prod.google.com ([2002:a5d:5642:0:b0:43c:fde3:c2bf])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2f85:b0:43c:f66e:f2d with SMTP id ffacd0b85a97d-43cf66e113cmr20228191f8f.27.1774968052063;
 Tue, 31 Mar 2026 07:40:52 -0700 (PDT)
Date: Tue, 31 Mar 2026 14:40:51 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-22-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com> <20260320-page_alloc-unmapped-v2-22-28bf1bd54f41@google.com>
X-Mailer: aerc 0.21.0
Message-ID: <DHH1NTVNTA8W.2313NYMA29J42@google.com>
Subject: Re: [PATCH v2 22/22] mm/secretmem: Use __GFP_UNMAPPED when available
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Jackman <jackmanb@google.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 864AC80010
X-Stat-Signature: dso4uqqkc4ck7fgtsj7htaiou1miirjd
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774968054-454021
X-HE-Meta: U2FsdGVkX1+AR2xC1QaPGcuWLQY+J5A9vvk6iHbkFI6fTrh3F1jTus8spLru0Ggi2LRUqhUSk0mvU9RTNpWDDORzEJrHn6FBPtUfYZj4T6sLA/PT1CORIgRDai2eHTUzAq5FkP2utPN8ajTgSxRZG9q1tf1xmZrmTquI0uidFU8E9u5piJJNxSZWPyOMEZBHf1WtSRMyqocQxtlPeqvkzq8OSDqrxnETedMlGmPAJl1CuFyajvwxOi+CDi6++u4i9f6fi2UG3CDuXWGlFYhD9KcFkzMv4gcar/CTLeieSK+D4JDVKVcMcYB2COp1ZmT1DShqcJIJvYJxmA7okjhrXhZnnkVQtRfCjsu0SAiesguFvH+9BcVOQSTV72sBG+ptJl4/CG2eNmlD7T6rGDQyrCdIGn9p907+Z268EwmEG+l8JalSZUQJXADHJQPuWvlTYElVk7JtMWFDEHJh6TulFU8f4KXHzDu6ezPOj85tQJ92Hd18g5DbfvRS7V9PFAQEoH6xjCPgGh/awE4s2VFwCs/B4cIc/TZv55qymBJwAlNv1NafSP6OD6wOmhVrYWiYfwUrWaf0xHvamVZqD1EuDfTnXk/GXD4IW7hmhJjK6rJusrI6Q4374UTcDSc8sTdmkatLIugU7TqEJRhNzjRkT7HwbPYRvwQo3h/OZPOo+tm0T+ZYglTFgjDHaNn9jP2aYgJr5/g6CkDCx0zinJVZWNGXRZbpUFnPEsUa+Edepx8gTBLY76CBmZp84G0AzNGLCxd4zvLXkh//WnruGgmdG+89TgkQrZv/fLUKUoW02Qki9wwJhkV6e1Ij6FkS/vWJLglnLmEngfnY+qupYQPLs0CB/t91u3T3VKYUpaGVZcKyQryjc8wz6OExM9Nv4u5t3XDhJhEhe+Tl9uUS3M2PcMrooEA8IEy97phfN/f4F6nu7zq4p41K3XkXd1I7R15F2mDse2U3tz7y/1TborZ
 TcEZrJcv
 bYx9GDmdFLUEX9M69MQr3FnoWrJ96apTNX/nZWICRB2S+wpCYj9feNIIS21BxP81U9K2cipQnEWDwBXgumnsrXA8CJgHrLdn9x+QLXbfmyBmXg/P91NXXWXgTGC8qV2qj8rxVae+tguT9bUAi31x8ypnE2ddWjEwk1GWpw9hrOmhmMZWMv6jIoGDOQ5vVutH+by8zKvi6mZTLEZj/xeh4AWATdWD0OpARXHtZ0gV/pFYhsbVrYDHChoJpNV5WnS03JTRsKE/KAbCfbouFQaP8OYQ3os40xRkeq0vbYn+cNXMa10ZtUVGqc8PX5BWA+64z/1Y+TYcerpkVHxf/cPn113Gudlcc4J8uvBvWnPWXhQsLuzyzq7ZCOnA1tSQ4a4Rqh2ov/KhEH5D89+9HbxwmBES5L3Zhn8OTrpxkxge1iIaKUZ7cYVxLJ0x62pm2EWfkwXUjhBiPvg/pKycMsYGIwl1islvc8MmkQRoEuc2ZZRnB6JY2bsBa0JlKCWs8TeWAHaJL78dq5ZA0PTa7l+Keg8XJhZV/yrLnQddFv3R9rr9Mi1qNSLjmk7UoZ2bIgSeXLTj3Q99qwQUB8fPgrza/O0PiIYJ3Y8Wnm/k+ygZ+gSIzFaYUSaxpBGuAbN1ywfVNXOSEKpxXiD5uXSwvcNeI13Bj7LizzRqgafAsHM7i9bT0x+GVUA2rCqTnvRvhRE16ApRoiuJ1R8v/kUB0Evvt/KxHORmQnRU83pZQtcsvdVaIEFngOhNvLC0LVbAP+ggzqkj2UPyFqVTwCMX8e188bR9rH0/2FmM6S7kI5OLyEhTMERNYIvjsitysEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I skipped on posting most of the intervening AI reviews coz there's just
so much stuff and most of it is pretty boring, but this one is
interesting.

https://sashiko.dev/#/patchset/20260320-page_alloc-unmapped-v2-0-28bf1bd54f41%40google.com

On Fri Mar 20, 2026 at 6:23 PM UTC, Brendan Jackman wrote:
> This is the simplest possible way to adopt __GFP_UNMAPPED. Use it to
> allocate pages when it's available, meaning the
> set_direct_map_invalid_noflush() call is no longer needed.
>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
>  mm/secretmem.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++---------
>  1 file changed, 74 insertions(+), 13 deletions(-)
>
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 5f57ac4720d32..9fef91237358a 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -6,6 +6,7 @@
>   */
>  
>  #include <linux/mm.h>
> +#include <linux/mermap.h>
>  #include <linux/fs.h>
>  #include <linux/swap.h>
>  #include <linux/mount.h>
> @@ -47,13 +48,78 @@ bool secretmem_active(void)
>  	return !!atomic_read(&secretmem_users);
>  }
>  
> +/*
> + * If it's supported, allocate using __GFP_UNMAPPED. This lets the page
> + * allocator amortize TLB flushes and avoids direct map fragmentation.
> + */
> +#ifdef CONFIG_PAGE_ALLOC_UNMAPPED
> +static inline struct folio *secretmem_folio_alloc(gfp_t gfp, unsigned int order)
> +{
> +	int err;
> +
> +	/* Required for __GFP_UNMAPPED|__GFP_ZERO. */
> +	err = mermap_mm_prepare(current->mm);
> +	if (err)
> +		return ERR_PTR(err);

Sashiko:
> In remote access paths such as process_vm_readv or io_uring worker threads,
> current->mm might be NULL or point to a different address space than the
> faulted VMA. Should this use vmf->vma->vm_mm instead?

This can't happen, right? I think the assumption is good; doing a
secretmem fault in a kthread or any process that doesn't have the file
mmap()'d would be a bug? But this definitely feels like something I
could be wrong about.

AI slop to empirically check the two examples mentioned by the AI fail
early (slop for slop, it's slop all the way down...):

- process_vm_readv(): https://paste.debian.net/hidden/5625ef2e
- io_uring:           https://paste.debian.net/hidden/e7763ad2

[...]

> +static inline void secretmem_folio_restore(struct folio *folio)
> +{
> +	set_direct_map_default_noflush(folio_page(folio, 0));
> +}

I defined a lovely helper here but neglected to actually call it.
Sashiko says "this isn't a bug" but that's wrong, calling
set_direct_map_default_noflush() before freeing a __GFP_UNMAPPED page is
not OK.

(Should it be? I think no. We _could_ define "default" so that it checks
the pageblock flags and does the right thing for you. But then we'd be
baking in the assumption that the page allocator can efficiently look
that up. This would be rather tricky if we decided we need to mix mapped
an unmapped pages in the same block).

And this was hiding the more important bug which was that I forgot to do
the mermap dance for zeroing the page. 

> +static inline void secretmem_folio_flush(struct folio *folio)
> +{
> +	unsigned long addr = (unsigned long)folio_address(folio);
> +
> +	flush_tlb_kernel_range(addr, addr + PAGE_SIZE);
> +}
> +#endif
> +
>  static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  {
>  	struct address_space *mapping = vmf->vma->vm_file->f_mapping;
>  	struct inode *inode = file_inode(vmf->vma->vm_file);
>  	pgoff_t offset = vmf->pgoff;
>  	gfp_t gfp = vmf->gfp_mask;
> -	unsigned long addr;
>  	struct folio *folio;
>  	vm_fault_t ret;
>  	int err;
> @@ -66,16 +132,9 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)
>  retry:
>  	folio = filemap_lock_folio(mapping, offset);
>  	if (IS_ERR(folio)) {
> -		folio = folio_alloc(gfp | __GFP_ZERO, 0);
> -		if (!folio) {
> -			ret = VM_FAULT_OOM;
> -			goto out;
> -		}
> -
> -		err = set_direct_map_invalid_noflush(folio_page(folio, 0));
> -		if (err) {
> -			folio_put(folio);
> -			ret = vmf_error(err);
> +		folio = secretmem_folio_alloc(gfp | __GFP_ZERO, 0);
> +		if (IS_ERR_OR_NULL(folio)) {
> +			ret = folio ? vmf_error(PTR_ERR(folio)) : VM_FAULT_OOM;
>  			goto out;
>  		}
>  

>		err = filemap_add_folio(mapping, folio, offset, gfp);
>		if (unlikely(err)) {
>			/*
>			 * If a split of large page was required, it
>			 * already happened when we marked the page invalid
>			 * which guarantees that this call won't fail
>			 */
>			set_direct_map_default_noflush(folio_page(folio, 0));
>			folio_put(folio);
>			if (err == -EEXIST)
>				goto retry;

This failure path leaks mermap TLB entries on ther CPUs. So if an
attacker can trigger this path, and cause another CPU to populate its
TLB for the mermap region, and then cause a victim to allocate the page
they just freed, they can use those entries for a sidechannel attack. 

I did call out in the cover letter that there's some jank with the "if you use
__GFP_UNMAPPED|__GFP_ZERO then you need to think about the TLB" thing.
But, this shows it's worse than I thought. I need to think about how to
mitigate this.

