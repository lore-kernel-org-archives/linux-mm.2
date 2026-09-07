Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C6D7C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 803716B008A; Mon,  7 Sep 2026 12:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DBE66B0095; Mon,  7 Sep 2026 12:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CAF36B0098; Mon,  7 Sep 2026 12:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6926B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:57:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4DFBA01EB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:57:01 +0000 (UTC)
X-FDA: 85187571042.16.010DB5F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0FA0D40003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:56:59 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U2eMkJBn;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788800220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7sMiZud/gecw2GU2/OU3WSFMgRwBwDYM1b6ol/3L2AQ=;
	b=PHoNropceIZFRtgg6Pl4Zxes6hEGJlglFrrjbspw7uvij84YP2Mbc4IVhaKJPDDWAAywmw
	tvi5KDbEqogDUfxzqnzJfFH327pHMP235hiY1T0IgJXIeGPfYhobJwbvuD6UiCQgMRfROv
	vNtJFDyPplwOhDPZUadYYeBSrrMnLYE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788800220;
	b=LR3Y9SO+7oymEHcu1fsqsQv+0T/3LZErRJB4vqv6V1YKTa4mnUwXn7fGV7vpWpQcYgDy5U
	uc6dPhwopUJGijYZyIFj5y6wc+k8Tc181ZMX42pIh2r7TNQ4TNDVKrWbkUXjtpr27/Qwn7
	MQwai2DRVtRbWuNRzk8tDAln9KaaUJw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U2eMkJBn;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3086D434EE;
	Mon,  7 Sep 2026 16:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A1461F00A3A;
	Mon,  7 Sep 2026 16:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788800219;
	bh=7sMiZud/gecw2GU2/OU3WSFMgRwBwDYM1b6ol/3L2AQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=U2eMkJBnxejCrjOQYxNf49B/y7ghwS63xl8kEFfSHPWHnEslOhZPUH9PrfOaFb/oO
	 vhBO4qgPGcA4rgq/5XcEfm7JlWYqx1IgFGQwjh1wWy1/O6JVpIHy2U4n8+BXHPsDNx
	 1VLmZw2b6mikVBQRxjIYCzdsH5OuRk7gr2NrmNJMcOj+DSky/Ir00/zP+/t1IlvVKT
	 b2ju0GSQNWjg7+im/JUVMHfkNJdv0WspOrigCfBEvB4oyND2m/Ye03Ju/EQ9/Hr6j1
	 HFdX4QrTcpf91Aj+wxuQwfBphRIEyrP22dI461P1S/nE4ua3v7dNt1qETwDaMYrngQ
	 Wxon93uiVUv/A==
Message-ID: <d6dc52e3-b27d-4663-848c-a2f270fb4c5d@kernel.org>
Date: Mon, 7 Sep 2026 18:56:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] mm/vma: only permit MAP_PRIVATE /dev/zero to be
 mapped anonymous
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
 <20260902-map-private-dev-zero-v1-3-a578c730cec7@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260902-map-private-dev-zero-v1-3-a578c730cec7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0FA0D40003
X-Stat-Signature: ayqqwdzuc6b17sms8rxp46m54yfyudqu
X-HE-Tag: 1788800219-181254
X-HE-Meta: U2FsdGVkX1+NMuVxXJfHsvXRAiZ1SLnJGgnYaRdQ3s8NB2q9QkJgnnUTaeU3l57x+WG5Htr54UEpRSDan0eIDPV9qGuQAGBOsj2qSqAfcO3uEr/5PeWHXyTq6lkU4ZE1i/IpgiUGjO1R3Ocv8zxNfMqNscn3YusyHEBtk3LEXbFkhgIxGDpNB+yWgBQanEfh51en6YOP6OwbTm4/W/I59tO6GTnvLtSsijozPocvq1bGOELpLaUNR+XdfjA6a5A5YIw1LcRDHXFHm27TDuMkl9VNilYCdgHdZI/3RLQWbf5gvcABmDYBMoEsEldrEI+F9Rvpr8uic1zg+kl9DzdkjbmyCUCOoWm2J5mKfhrTScC/ug1jW78MCb5kRzOTgwFuCsRW2NmxvMmmxaz/AQN5uRuPlTKHxKcby/Dm1qtX4j3nV0QEKzRUv8ZVtd09vGgXxK4jAxC0ieywkBpSpNvJM787xdD89ZRTBfwQOo6A8QhxAEBRkzATPivmDPXn1wHWwgWjnEeB5zspsjEEQ975hB7TulI8lt6BTLSpibW3YiTc1P0p0JZFJPZr+tZH4IYd9ta4vx6v2qNw+u1z2e8rDzjwz+DOS+OgovJtypHnv976UFKrv/g0VDEh1++duk7W0qURgGnowprqwgz11ifUM453rfmxKrq6q+4fHGj7+mtYzrXG0MwoH/YPO6uRL2lGaLYnS2RtA27KL/2VkRXxPIsAuAIenMoeTncacIMnTWDVuCLxWay8NZRo88kcwu9ZIAb/wiZGpHJxYYBlcGnqXPChLBOaLSO9mhKHu7S8yS3bkKYxc33ZJdjmkg/KN5SJzhmcbCeiueXjiKmB9gIXC0wvLsr0VjnK1WPj0JLCIupWR04IAhdSljHFusD8h+adHQ0oBvSwApaFWrOy8ze5F1CNJ1eO8IjrdLr86Y1Pe6VKLnkvI6OlJdAlxrYHhtEcKeqMN4eYUR9JNoFUN8z
 siyDuia2
 y3xLCdQke9duvZqeep2/cWO2Un7kVNMl88ZP/JN8TrN4oQTRy/wfHAH45kzsvM1OTrppjWAa+jRmtNcsNUzSb4PcdwL1bcsymWS2gBN6q9M7tKkQInDz8NsMXZBe/rc8cbGAK6w5jjDgKn7rG5DlHzKY87sVZUDWvhk5inhRRy36yFy0u9cRMOEKNH33Z+rjxPsIFxy2d7Q4SS7hORVRQZL2CvZHzsvR2y4NOpiLXGOhLKvlYYStP0IKlMf4NozlNHfKXZt3WvPb+QGAHyxVxOWFwUNRqlSezPW2bxMrQsGm29r4zGkUtqXUWtS7EbJW8u5Rzkd9OosAn0j8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/26 20:00, Lorenzo Stoakes (ARM) wrote:
> In order to use mmap_prepare() with MAP_PRIVATE mappings of /dev/zero
> without the success_hook hack we explicitly permitted mmap_prepare handlers
> to set NULL vm_ops.
> 
> However this is dangerous and we really only want to allow this for
> MAP_PRIVATE-mapped /dev/zero.
> 
> Therefore use the newly introduced file_is_dev_zero() to uniquely identify
> MAP_PRIVATE-/dev/zero mappings and only permit this behaviour for them.
> 
> Then, remove all ability for mmap_prepare or mmap hooks to set a VMA
> anonymous and update mmap_zero_prepare() to leave it to the core mmap code
> to do so.
> 
> Note that this disallows nested MAP_PRIVATE-mappings of /dev/zero
> regions. Doing this would be broken in any case.
> 
> We therefore do not need to update the mmap_prepare() compatibility layer
> to reflect these changes, as the mmap hook check suffices to disallow this
> behaviour.
> 
> Now we're setting vma->vm_ops to NULL for an mmap_prepare-initialised
> MAP_PRIVATE-/dev/zero mapping, we have to avoid a subtle issue when
> updating user-defined fields via set_vma_user_defined_fields().
> 
> The default for vma->vm_ops for all mmap_prepare-initialised mappings is
> vma_dummy_vm_ops, so map->vm_ops will be set to this and setting
> vma->vm_ops to this will render the VMA mistakenly non-anon.
> 
> In general, we should never be setting user-defined fields for an anonymous
> VMA, so explicitly check for this to avoid doing so for the one case where
> a mapping can be both mmap_prepare and anonymous.
> 
> In the case of legacy ->mmap hooks some drivers may set vma->vm_ops NULL
> believing this is the equivalent of setting no VMA operations. Therefore
> update mmap_file() to correct this by setting dummy VMA operations if this
> occurs.
> 
> An example of this is drm_gem_shmem_mmap() which deliberately clears
> vma->vm_ops before handing the VMA to dma-buf. Cases such as this will be
> updated when they are converted to mmap_prepare.
> 
> Also, in order to avoid a single commit bisection hazard, add a temporary
> workaround to set the VMA anonymous only after vma->vm_file is assigned in
> __mmap_new_file_vma().
> 
> This is because vma_set_range() calls vma_set_pgoff() and
> assert_sane_pgoff() in turn, prior to the vma->vm_file being assigned. If
> we set the VMA anonymous early then this assert will fail.
> 
> This is removed in the subsequent commit.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/char-mem.c |  6 +-----
>  mm/internal.h | 17 ++++++++++-------
>  mm/vma.c      | 33 +++++++++++++++++++++++++--------
>  3 files changed, 36 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/char-mem.c b/mm/char-mem.c
> index e53e89e6ddd8..c0b5fb019223 100644
> --- a/mm/char-mem.c
> +++ b/mm/char-mem.c
> @@ -508,11 +508,7 @@ static int mmap_zero_prepare(struct vm_area_desc *desc)
>  	if (vma_desc_test(desc, VMA_SHARED_BIT))
>  		return shmem_zero_setup_desc(desc);
>  
> -	/*
> -	 * This is a highly unique situation where we mark a MAP_PRIVATE mapping
> -	 * of /dev/zero anonymous, despite it not being.
> -	 */
> -	vma_desc_set_anonymous(desc);
> +	/* MAP_PRIVATE semantics are taken care of for us by core mm. */
>  	return 0;
>  }
>  
> diff --git a/mm/internal.h b/mm/internal.h
> index 5d474e5f7709..da14c56fb24e 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -226,15 +226,18 @@ static inline int mmap_file(struct file *file, struct vm_area_struct *vma)
>  {
>  	int err = vfs_mmap(file, vma);
>  
> -	if (likely(!err))
> -		return 0;
> -
>  	/*
> -	 * OK, we tried to call the file hook for mmap(), but an error
> -	 * arose. The mapping is in an inconsistent state and we must not invoke
> -	 * any further hooks on it.
> +	 * Either we tried to call the file hook for mmap() and an error arose
> +	 * or a driver set vma->vm_ops = NULL intending there to be no VMA
> +	 * operations.
> +	 *
> +	 * In the former case the VMA is in an inconsistent state and we mustn't
> +	 * invoke any further hooks on it, in the latter case the hook actually
> +	 * wanted no further hooks to be invoked, so fix both by setting dummy
> +	 * VMA ops.
>  	 */
> -	vma->vm_ops = &vma_dummy_vm_ops;
> +	if (unlikely(err || !vma->vm_ops))
> +		vma->vm_ops = &vma_dummy_vm_ops;
>  
>  	return err;
>  }
> diff --git a/mm/vma.c b/mm/vma.c
> index 35e7a64855fa..4b8d430d9619 100644
> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2621,6 +2621,19 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  	return 0;
>  }
>  
> +static bool map_is_private(const struct mmap_state *map)
> +{
> +	return !vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
> +}
> +
> +static bool map_is_anon(const struct mmap_state *map)

I was wondering whether we should call this "map_is_private_anon", due to
MAP_ANON|MAP_SHARED. But looking at __mmap_new_vma(), the existing "is_anon" is
also limited to MAP_ANON|MAP_PRIVATE.

> +{
> +	if (!map_is_private(map))
> +		return false;
> +
> +	return !map->file || file_is_dev_zero(map->file);
> +}
> +
>  /*
>   * __mmap_new_vma() - Allocate a new VMA for the region, as merging was not
>   * possible.
> @@ -2634,8 +2647,7 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>  	struct mmap_action *action)
>  {
> -	const bool is_anon = !map->file &&
> -		!vma_flags_test(&map->vma_flags, VMA_SHARED_BIT);
> +	const bool is_anon = map_is_anon(map);
>  	struct vma_iterator *vmi = map->vmi;
>  	int error = 0;
>  	struct vm_area_struct *vma;
> @@ -2651,7 +2663,7 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>  
>  	vma_iter_config(vmi, map->addr, map->end);
>  
> -	if (is_anon)
> +	if (is_anon && !map->file)
>  		vma_set_anonymous(vma);
>  
>  	vma_set_range(vma, map->addr, map->end, map->pgoff, map->anon_pgoff);
> @@ -2669,6 +2681,10 @@ static int __mmap_new_vma(struct mmap_state *map, struct vm_area_struct **vmap,
>  	else if (!is_anon)
>  		error = shmem_zero_setup(vma);
>  
> +	/* Temporary MAP_PRIVATE-/dev/zero workaround. */
> +	if (is_anon && map->file)
> +		vma_set_anonymous(vma);
> +
>  	if (error)
>  		goto free_iter_vma;
>  
> @@ -2777,6 +2793,10 @@ static int call_mmap_prepare(struct mmap_state *map,
>  	if (err)
>  		return err;
>  
> +	/* Hooks cannot mark themselves anonymous. */

I guess this comment will be stale soon (after #4 where you drop the
set_anonymous part).

Should it be

"vm_ops are strictly required with mmap_prepare"

or sth like that?

> +	if (!desc->vm_ops)
> +		return -EINVAL;
> +
>  	err = call_action_prepare(map, desc);
>  	if (err)
>  		return err;
> @@ -2799,10 +2819,7 @@ static int call_mmap_prepare(struct mmap_state *map,
>  static void set_vma_user_defined_fields(struct vm_area_struct *vma,
>  		struct mmap_state *map)
>  {
> -	if (map->vm_ops)
> -		vma->vm_ops = map->vm_ops;
> -	else	/* Only /dev/zero should do this. */
> -		vma_set_anonymous(vma);
> +	vma->vm_ops = map->vm_ops;
>  	vma->vm_private_data = map->vm_private_data;
>  }
>  
> @@ -2882,7 +2899,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
>  		allocated_new = true;
>  	}
>  
> -	if (have_mmap_prepare)
> +	if (have_mmap_prepare && !map_is_anon(&map))
>  		set_vma_user_defined_fields(vma, &map);

Ah, we have mmap_zero_prepare() for handling the shmem_zero_setup_desc(). I was
just about to ask whether we can just get rid of this here.


But, hold on, do we now even need that? Could core-mm now take care of that as
well, and we could just remove mmap_zero_prepare() entirely?

That is, we'd make shmem_zero_setup() in __mmap_new_vma() take care of this?
Then we might not even need shmem_zero_setup_desc() anymore.

Maybe harder than it sounds at first.

-- 
Cheers,

David

