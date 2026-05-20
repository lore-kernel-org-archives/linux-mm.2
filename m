Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F68DCD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 17:05:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEAD06B00DB; Wed, 20 May 2026 13:05:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC2316B00DC; Wed, 20 May 2026 13:05:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFFE56B00DE; Wed, 20 May 2026 13:05:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C116F6B00DB
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:05:14 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89A428C65A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:05:14 +0000 (UTC)
X-FDA: 84788423748.20.B03E77A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id A794A18000B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:05:12 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B+PSpPrf;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779296712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J9pjUPV93mLBVientZvNV17+XV8MxjPxpFBlhWwv3ek=;
	b=ad/KxJJa7t35+Vy+tIVsEVsVmQ85RDf9g7U/+K5WjWbntb2JDyHm/yQs/n+kJWRASpkhZ2
	JOqeguRCJMneyrSvVzghPQuqrEgimn9MRUUF+enb/C4f55lKCTbRB7AODhD4yZ1gAIzXIP
	8j3FvEYUEOqH97VjnBJXOPcQhKDJ4vA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B+PSpPrf;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779296712; a=rsa-sha256;
	cv=none;
	b=MA9DLPJaexwLlant251tOuYvdTvu5WfHMYILJljSp9RBUWkcDwMiwv46RU4gnQ/tfItCuJ
	UmhVjMgNpqY3Ef7fVu24cuvuTDMqebE37iyAuwzcNOUGkUIOD3mJ/mxl0civLMfpj1DqId
	sxkr1blKdseCutEVjleMc68CNzEM5ys=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0092160120;
	Wed, 20 May 2026 17:05:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED4D1F000E9;
	Wed, 20 May 2026 17:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779296711;
	bh=J9pjUPV93mLBVientZvNV17+XV8MxjPxpFBlhWwv3ek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=B+PSpPrf+OZdOuN3UYJ4/BDm7UWDnXic/X4+/6e1wCnpFUYCcWYnDmkOKm4Ubj06D
	 L4pj2bnKUaknJrlgLkNU/in/wEPBtD1E8uBM5+KiLwc6jrCo01PtJX7mwOB/Ju7Z2x
	 u/wXZ2DQpuKPPqlqjwiknFDBf3fXS6BwLT1Uxy05e85DlyAFsYLSHshKtjw7ixT7z9
	 VPn+PRQ/ZnDO0HaqDlruw6BDsAADBLoWoqaOIl9KcGpb88c5O8md0mgMcedwRiuqzi
	 Ew31ya9LhtA9AKp4jXFdClAReV0HTXObY13rUusqQ3CetSACfxm8ZspeSbxpmfgcjm
	 pnk4EwvfYnl4g==
Date: Wed, 20 May 2026 18:05:09 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Daniel Palmer <daniel@thingy.jp>
Cc: akpm@linux-foundation.org, liam@infradead.org, vbabka@kernel.org, 
	jannh@google.com, pfalcato@suse.de, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] mm/nommu: Implement just enough vmap that compressed
 erofs can be mounted
Message-ID: <ag3ozpy8ehNr8vUP@lucifer>
References: <20260520163442.1099667-1-daniel@thingy.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520163442.1099667-1-daniel@thingy.jp>
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A794A18000B
X-Stat-Signature: 5xjdsdz4krboms4qxaquj4es7a9dg7qu
X-HE-Tag: 1779296712-698107
X-HE-Meta: U2FsdGVkX184XBAWghA/GFx6HBX+cO3hesDkTG4N8oQJq6tVHVx3PwTyWaLj3nfZsPfcp5bGBujXoEbIamr7v3tOU0bYApt8xPieU9gwsnP/Ls8emnkjGzWG5i7IxFTngC7PfOF3RhMab0igwgHkP108cK5vppp/WAzr5QhZEgG2GB2lhJ42yP0FAkdbmdBaLWai6FeT5d3r79mdStB7uHGmUmXh7i2PwYFIyjzFFzAj1n3YduxJp6JWiqctQKdWL82r4OB3Y+Wkg2IDZS+PleA+WkDahEoa//9li0/NxAhCtXKA7AR4Z+yMb6nmQRXOErji145I5A0CZ/k3+nNY6+mFdnm4iuurw9i66hZ4g9nFsmjOlPTeIpktPytt8beBugiFSSlmzK2mYdYkTJQQsf2Y3Cyr7XqM9P9xwlCH5DM35Nz0kajLzMtlLYJUj7R6nPLYvLTKJorzEZZrr/Doc3RYt5bTcdO9PKh+MS++QxawERIPdkaGeazjhSV7ZUqdzsuwjkq45dOQu3YLLoePTr/GZ1G/81kcNS/0S57PUC7Y4DnQG3gVEBbU2cXalFwJwaaK3EGNa/P26A1Zb/v0p0J7GMLk0h7NqhWWpnwN0h1RDjHFWuUsVWq97MXlbjQ3Lpj8OK/XzULLISC8rt2lcI4e+EPtzCEhYFUfbSGmJAWPkc4oSbq0JgEeEJA5JNlQqZhTqD94eyAlOYmLB2eu7gGzmU4NyONnwojm60rP902KlQOnclUlCQB9xRJyhX/edCBCZ/Fj1MEfpibXu4lOekhYYOl+ZdwlT+np9xoSkvSxTjgJi93YDjGVD/cAl3LhnhPNuhn7qP0fd6McdSwajtbAVoSFCyqUmnQ+NXs3CYzKF8KjEF+g6HrpW/QaolgVte5paoQmuQ79YzwAEoxwJLfb1xnCShCwK84ousmp2Bfv7nlOsWTTwKobSlciQs9geTAjYoDYtGjzyDNSeIK
 Kv4Gtz4d
 aOZ7Mw8Tobo0WsXtqGwvQ8E6dwFeVgXv8VZ+BairX/DZN54JeJzKqfhFhr48moxoplRrkyV33OJsn/Bb9RiQuqbsdn60+VK23qFN6EZSenWTX5oyIekT8ZL6ifOClr604ttI0Yka7fmgZWEqNgl/QDhvWLJzXh0MapXibRZmtVVlBNpUkVExSxtLDlGbIc60lLRjB9WFQg3n2q30XxJalAjx+DqGQouf0O6yStb4HTUq/dksPVzWIEH8E/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For some reason this iddn't arrive in my inbox properly... strange? Maybe
missing To:?

On Thu, May 21, 2026 at 01:34:38AM +0900, Daniel Palmer wrote:
> This implements a very poor imitation of vmap that works just
> enough that compressed erofs filesystems can be mounted on nommu
> machines. Right now compressed erofs filesystems trigger a BUG()
> on nommu due to this missing.

Yeah I guess not many people are using the two in combination!

>
> This is awful, doesn't work like real vmap etc,.. but if you
> really cared about stuff working you'd have an MMU I guess?
>
> Signed-off-by: Daniel Palmer <daniel@thingy.jp>

I see you're doing something for fun so I don't want to dissuade but might take
time to get to something like this review wise given maintainership burden atm!

> ---
>
> Did I miss anything massive that is going to come back and bite me?
> Maybe it would have made more sense just to change the erofs
> code so on !CONFIG_MMU it doesn't use vmap?

I think that'd probably be better honestly. I think faking out vmalloc is more
trouble than it's worth, and it'd probably have to be everything-or-nothing.

Also you'd _probably_ want to implement it in mm/vmalloc.c not in nommu.c. We
have #ifdef CONFIG_MMU .. #else .. #endif blocks for this but... yeah I think
changing erofs would be a better bet honestly.

There are nommu-specific fs hooks you could possibly use that might make life
easier for this!

>
> Why:
>
> I'm attempting to get a kernel and userspace into ~3.5MB
> of memory without an MMU. The kernel is just a bit over
> 2MB so I don't have much left.
>
> I've constructed a userspace that is completely made
> up of nolibc binaries and with a bit of tweaking and all
> the debugging turned off it fits into a ~64KB erofs.

That's cool and I appreciate that you're doing things for fun :) the kernel is
about this also.

But yeah would gently point you towards doing something on the fs end I think
here :)

Cheers, Lorenzo

>
>  mm/nommu.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 127 insertions(+), 6 deletions(-)
>
> diff --git a/mm/nommu.c b/mm/nommu.c
> index ed3934bc2de4..a7dbb67b3b69 100644
> --- a/mm/nommu.c
> +++ b/mm/nommu.c
> @@ -19,6 +19,7 @@
>  #include <linux/export.h>
>  #include <linux/mm.h>
>  #include <linux/sched/mm.h>
> +#include <linux/hash.h>
>  #include <linux/mman.h>
>  #include <linux/swap.h>
>  #include <linux/file.h>
> @@ -53,6 +54,18 @@ static struct kmem_cache *vm_region_jar;
>  struct rb_root nommu_region_tree = RB_ROOT;
>  DECLARE_RWSEM(nommu_region_sem);
>
> +/* Tracking for our "poor man's" vmap */
> +#define VMAP_HASH_BITS  6
> +static struct hlist_head vmap_hash[1 << VMAP_HASH_BITS];
> +static DEFINE_SPINLOCK(vmap_lock);
> +
> +struct nommu_vmap_area {
> +	struct hlist_node node;
> +	struct page **pages;
> +	unsigned int count;
> +	void *addr;
> +};
> +
>  const struct vm_operations_struct generic_file_vm_ops = {
>  };
>
> @@ -305,29 +318,137 @@ void *vmalloc_32_user_noprof(unsigned long size)
>  }
>  EXPORT_SYMBOL(vmalloc_32_user_noprof);
>
> -void *vmap(struct page **pages, unsigned int count, unsigned long flags, pgprot_t prot)
> +static bool vmap_needs_bounce(struct page **pages, unsigned int count)
>  {
> -	BUG();
> +	unsigned long pfn = page_to_pfn(pages[0]);
> +	unsigned int i;
> +
> +	for (i = 1; i < count; i++)
> +		if (page_to_pfn(pages[i]) != pfn + i)
> +			return true;
> +
> +	return false;
> +}
> +
> +static inline unsigned int vmap_key(const void *addr)
> +{
> +	return hash_ptr(addr, VMAP_HASH_BITS);
> +}
> +
> +static struct nommu_vmap_area *vmap_area_find(const void *addr)
> +{
> +	struct nommu_vmap_area *va;
> +
> +	hlist_for_each_entry(va, &vmap_hash[vmap_key(addr)], node)
> +		if (va->addr == addr)
> +			return va;
> +
>  	return NULL;
>  }
> +
> +static void *nommu_vmap_map(struct page **pages, unsigned int count)
> +{
> +	struct nommu_vmap_area *va __free(kfree) = NULL;
> +	struct page **_pages __free(kfree) = NULL;
> +	void *copy __free(kvfree) = NULL;
> +	unsigned int i;
> +
> +	va = kmalloc_obj(struct nommu_vmap_area);
> +	if (!va)
> +		return NULL;
> +
> +	if (vmap_needs_bounce(pages, count)) {
> +		copy = kvmalloc_array(count, PAGE_SIZE, GFP_KERNEL);
> +		if (!copy)
> +			return NULL;
> +
> +		_pages = kmemdup(pages, count * sizeof(*pages), GFP_KERNEL);
> +		if (!_pages)
> +			return NULL;
> +
> +		/*
> +		 * Copy the original contents of the pages into the new
> +		 * pages to pretend we virtually mapped them.
> +		 */
> +		for (i = 0; i < count; i++) {
> +			void *p = copy + (i * PAGE_SIZE);
> +
> +			memcpy(p, page_address(pages[i]), PAGE_SIZE);
> +		}
> +
> +		va->addr = no_free_ptr(copy);
> +		va->pages = no_free_ptr(_pages);
> +	} else {
> +		va->addr = page_address(pages[0]);
> +		va->pages = NULL;
> +	}
> +
> +	va->count = count;
> +
> +	scoped_guard(spinlock, &vmap_lock) {
> +		hlist_add_head(&va->node,
> +			       &vmap_hash[vmap_key(va->addr)]);
> +	}
> +
> +	return no_free_ptr(va)->addr;
> +}
> +
> +static void nommu_vmap_unmap(const void *addr)
> +{
> +	struct nommu_vmap_area *va;
> +	unsigned int i;
> +
> +	scoped_guard(spinlock, &vmap_lock) {
> +		va = vmap_area_find(addr);
> +		if (va)
> +			hlist_del(&va->node);
> +	}
> +
> +	if (WARN_ON_ONCE(!va))
> +		return;
> +
> +	if (va->pages) {
> +		/*
> +		 * Write back the new contents of the pages to
> +		 * the original ones, this is a waste of time if
> +		 * the pages weren't written to but we can't tell.
> +		 */
> +		for (i = 0; i < va->count; i++) {
> +			const void *src = addr + (i * PAGE_SIZE);
> +			void *dst = page_address(va->pages[i]);
> +
> +			memcpy(dst, src, PAGE_SIZE);
> +		}
> +
> +		kvfree(va->addr);
> +		kfree(va->pages);
> +	}
> +
> +	kfree(va);
> +}
> +
> +void *vmap(struct page **pages, unsigned int count,
> +	   unsigned long flags, pgprot_t prot)
> +{
> +	return nommu_vmap_map(pages, count);
> +}
>  EXPORT_SYMBOL(vmap);
>
>  void vunmap(const void *addr)
>  {
> -	BUG();
> +	nommu_vmap_unmap(addr);
>  }
>  EXPORT_SYMBOL(vunmap);
>
>  void *vm_map_ram(struct page **pages, unsigned int count, int node)
>  {
> -	BUG();
> -	return NULL;
> +	return nommu_vmap_map(pages, count);
>  }
>  EXPORT_SYMBOL(vm_map_ram);
>
>  void vm_unmap_ram(const void *mem, unsigned int count)
>  {
> -	BUG();
> +	nommu_vmap_unmap(mem);
>  }
>  EXPORT_SYMBOL(vm_unmap_ram);
>
> --
> 2.53.0
>
>
>
>

