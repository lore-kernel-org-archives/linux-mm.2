Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E19CCD6E51
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 02:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AC366B0005; Fri, 29 May 2026 22:00:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95EAF6B0088; Fri, 29 May 2026 22:00:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8724A6B008A; Fri, 29 May 2026 22:00:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 75C0C6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 22:00:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0F6DE402A0
	for <linux-mm@kvack.org>; Sat, 30 May 2026 02:00:00 +0000 (UTC)
X-FDA: 84822430560.01.2984FD8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7D8BAC0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:59:57 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mLO7b6lr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780106398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gvQEeaYLW/wYQCXduLu+dmOxzqQTLbCPPqALp/1B/Us=;
	b=iUVBYes+FWhXwqY94XUTH64JJ/3qPcYw8BnaoeGgZdllyx2fd/kiXU0+JqJHrq9egZ5uRv
	nr3T2tPsMNzwnwO67kHj8nMS9DrPdQmLQfEyXib4CBSDdwgrV4mZSmI4wPTVc5Xisw/BUB
	tWGlLrZZkZBgCbpMtKueULW5rVulJzc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mLO7b6lr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of bot+bpf-ci@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=bot+bpf-ci@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780106398; a=rsa-sha256;
	cv=none;
	b=VCD28hi3Y8txzKOnBWyUJHOsBZqLdggTyMqm19FqrWqxyHR4TauoMRFGY0tejc8bJIEmAF
	nGrHQThc3g/uaMU7xTuTnFx+wA9hvgdnDwUgpyYEWMT6gLR/KjMi046W/8dGVycK3hoozR
	4m7mXz08sl6bLtQFIndffSTl62Y/vvk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0689F423D6;
	Sat, 30 May 2026 01:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E821F00893;
	Sat, 30 May 2026 01:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780106394;
	bh=gvQEeaYLW/wYQCXduLu+dmOxzqQTLbCPPqALp/1B/Us=;
	h=In-Reply-To:References:Subject:From:To:Cc:Date;
	b=mLO7b6lrgVqTATAo0H4I+EfeTnXCdbM6R9moHmNM6ps+5yguFdEQ7tyi5N4SJUXiF
	 D6k1oG/wR+bmvPdYl9/tY4Dm2hIF63xBrA4Xg0mmGmprxWx5MAeizaTsBm4qfMHASR
	 CLiNTcoHxFLOh4Jta/mqm7wEXGz5Pu2i6EWJmsvOsVl5igjQovsh7Z4I4jgjoW4oES
	 73YpBy64HhyIWmBo9abbKoolf53eM6R7XRYz7eGm4oDNyeJg1w1SRzaeSttcF2i2Nm
	 q+nGZNK6UodvwD8IrFHh3mi7HiERsh1oQLYWjqIOUKMjirUgymnz/B68K2LxCkoJWi
	 lNMtvieJdqmvg==
Content-Type: multipart/mixed; boundary="===============4695289581068011818=="
MIME-Version: 1.0
Message-Id: <b629b9f1f284359ed76a11cf1ead7b9061854c0bdd7f67b2b046886c254af005@mail.kernel.org>
In-Reply-To: <20260530011345.99342-4-alexei.starovoitov@gmail.com>
References: <20260530011345.99342-4-alexei.starovoitov@gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] bpf,slab: Add slub-backed allocator for bpf_arena
From: bot+bpf-ci@kernel.org
To: alexei.starovoitov@gmail.com,bpf@vger.kernel.org
Cc: daniel@iogearbox.net,andrii@kernel.org,memxor@gmail.com,eddyz87@gmail.com,vbabka@suse.cz,harry.yoo@oracle.com,david@kernel.org,tj@kernel.org,roman.gushchin@linux.dev,peterz@infradead.org,linux-mm@kvack.org,ast@kernel.org,andrii@kernel.org,daniel@iogearbox.net,martin.lau@kernel.org,eddyz87@gmail.com,yonghong.song@linux.dev,clm@meta.com,ihor.solodrai@linux.dev
Date: Sat, 30 May 2026 01:59:54 +0000 (UTC)
X-Stat-Signature: zxopfemsj38w3zy3i754pg7gn4kakwam
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7D8BAC0005
X-Rspam-User: 
X-HE-Tag: 1780106397-332997
X-HE-Meta: U2FsdGVkX1+EqHhgYBSGv/HNtd/J4I6vjbTqNfwzAJq11OazMO+ZRUiivOdYthSZo3mN4t6Pv40PO4uuGGHX2+VzpKj3FB0wSaJNofDgn3b8ZaFqkau4nA2RhYcasxFhEEvd2XFFjJTtqt/UfO1jS9FpK8E/Z6D4417x06P5QhigfFSmxr8Egm5hqYI/OdjL01oRPEiSR25nWscPMFFuxdW0QvzVJN41bSrK40I2+lWfCX9NXP2Gs9QT7VLdPUPIK8MNcs654z0E8jC5zPe9oaIRb14d0yrxcAkQyuF6WZZQZeYklxZBvic/sMDnsb/aLaa3BF7xnxmDhrKcy6G9ICtHl6kk5RC7J+0UfISNo44pFNQ3uDB0daVv2tTK7HJpimKGVIJvSaEV+WtuuMnLOzRq/TicCbV5VTL8HzlUSFvs6/t2RmlWN1jrQqcweaU2C7EZB9bYRBwByFn0lqdTa8b9Tw44upOxEvNrVzNSlEDwvLtOVu5EVkulJWoCuzQvJKCMmMgZo8dGTjfsEoW0S9LlcBMtJv2OBS+Y2lnQXKNVkoagDAnoS0FaDkjylQNTZSSr7wB8ZjWYc6OpSK4c8iA2JWhCMZFtpYgUwGEPEK6O9wsLUp9Gy85qYmyd1RAcgKjs9aFTpu9SeTdMcaoqhHJXauJS1vZ8CyD51PoJE48uSks6ObpV8rjK0nrZwBj/eHyPDHaF3Wz0+vuwi9S/pBvShz/p4YnhYrnNRef2g8NULGE1CNuhlnQUNDyMGxUNTXo7rOwljLsHs6ZyTuQwvbj0wCv0FsC3El8Jq6xMdSpa1aSvEvV1WGgy5BYyoQv8k7hbowdqdY/VpkffbCvivyeOa1VVDrpmqJQqA+hyhMcJJMc7UHpnUt/5R5tex2ZhaonGyK+3P7KDZj9u8OTT2fH4/1HtPKN/lEedw+3nhBaRoT96stFhfPoogXp+Jmn0ej5oCa4oj40vllwUhVB
 v58nZnEi
 Ezet0MKXdSrv3FJhfihU0o5UbwLTfMwWxmPrpUnRpACtZMc8uwTvLVgsZCYTyZi+Rnec8VTNI5gBsk4l22MDvgbmLOOEed7m6/BbY0D4ACfD2ejifC6FIw3LdqmbWgMCeToU/hxEldN1lU08iC6jxRcJc/M0dnNkAHWY1HPiSNE1zOp8i1rBsRjZ6Z/TxAlSPBR12wzYYSSO8Wsya9voEjIp8yty/MNaJZxayYyEm7C3mGjbgjDBPTw6Ev54gNFVoeg1+nvp/DOyT/A97sR3AlUQiGv5BMBkg+KYqDiMBA+NAK24P3/WuplxS12+c69kNGunNNWo7YiLMpYEdeSg68QTDhuCzVhQA1uzvNEX1p482M5oOX8iTE8UyZqJIjCb/Z6jcju5HIHUHkxHxKLSYylsqaFMtu8IsPWHVNrvN48IJ7euK3jQBMJ/wRcD2k9cHEBopHZMmBlR2XGqifuszHA4CwmOAGxEywKkdPA7c1dIZXASMLJ28Gdk3cq2kkZMgu3l54SmgWIfOGfvYaRLio4uM/sPviS5vIoOq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--===============4695289581068011818==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

> diff --git kernel/bpf/arena.c kernel/bpf/arena.c
> index 1727503b25d8..0f389ccf4c8f 100644
> --- kernel/bpf/arena.c
> +++ kernel/bpf/arena.c

[ ... ]

> @@ -63,10 +74,20 @@ struct bpf_arena {
>  	struct irq_work     free_irq;
>  	struct work_struct  free_work;
>  	struct llist_head   free_spans;
> +
> +	/*
> +	 * SLAB_BPF_ARENA: kva <-> arena offset translation at the kfunc
> +	 * boundary. Forward (kva -> uaddr32) via slab->stride; reverse
> +	 * (uaddr32 -> page) via @slab_pages[pgoff], sized to max_entries.
> +	 */
> +	struct page **slab_pages;
> +	struct kmem_cache *kmalloc_caches[ARENA_KMALLOC_NUM_BUCKETS];
>  };

[ ... ]

> @@ -290,12 +332,25 @@ static struct bpf_map *arena_map_alloc(union bpf_attr *attr)
>  		goto err_free_scratch;
>  	mutex_init(&arena->lock);
>  	raw_res_spin_lock_init(&arena->spinlock);
> +	arena->slab_pages = bpf_map_area_alloc(attr->max_entries *
> +					       sizeof(arena->slab_pages[0]),
> +					       numa_node);

The slab_pages[] array is allocated with exactly attr->max_entries entries.
The struct comment documents it as "sized to max_entries" and indexed by
the logical page offset within the arena's 4GB window.

[ ... ]

> @@ -625,7 +687,8 @@ static u64 clear_lo32(u64 val)
>   * Later the pages will be mmaped into user space vma.
>   */
>  static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt, int node_id,
> -			      bool sleepable)
> +			      bool sleepable, bool set_page_slab,
> +			      struct page **out_page)
>  {

[ ... ]

> @@ -720,6 +795,8 @@ static long arena_alloc_pages(struct bpf_arena *arena, long uaddr, long page_cnt
>  	}
>  	flush_vmap_cache(kern_vm_start + uaddr32, mapped << PAGE_SHIFT);
>  	raw_res_spin_unlock_irqrestore(&arena->spinlock, flags);
> +	if (out_page)
> +		*out_page = first_page;
>  	kfree_nolock(pages);
>  	bpf_map_memcg_exit(old_memcg, new_memcg);
>  	return clear_lo32(arena->user_vm_start) + uaddr32;

arena_alloc_pages() returns a 64-bit value where the low 32 bits are the
absolute arena offset: clear_lo32(user_vm_start) + uaddr32. This uaddr32
value is (u32)(user_vm_start + logical_pgoff * PAGE_SIZE), so it includes
the low 32 bits of user_vm_start.

[ ... ]

> @@ -770,14 +871,29 @@ static void arena_free_pages(struct bpf_arena *arena, long uaddr, long page_cnt,
>  	/* only aligned lower 32-bit are relevant */
>  	uaddr = (u32)uaddr;
>  	uaddr &= PAGE_MASK;
> +	pgoff = compute_pgoff(arena, uaddr);
> +	if (pgoff >= page_cnt_max)
> +		return;
> +	page_cnt = min_t(long, page_cnt, page_cnt_max - pgoff);
> +	if (!page_cnt)
> +		return;
>  	kaddr = bpf_arena_get_kern_vm_start(arena) + uaddr;
>  	full_uaddr = clear_lo32(arena->user_vm_start) + uaddr;
> -	uaddr_end = min(arena->user_vm_end, full_uaddr + (page_cnt << PAGE_SHIFT));
> -	if (full_uaddr >= uaddr_end)
> -		return;
>
> -	page_cnt = (uaddr_end - full_uaddr) >> PAGE_SHIFT;
> -	pgoff = compute_pgoff(arena, uaddr);
> +	/*
> +	 * Drop bookkeeping for any bpf_arena_alloc() fallback pages within the
> +	 * freed range. PageSlab entries are owned by slub and must not be
> +	 * cleared here; slub clears them via bpf_arena_free_slab_page() when
> +	 * the slab page is released.
> +	 */
> +	for (i = 0; i < page_cnt; i++) {
> +		fb_page = READ_ONCE(arena->slab_pages[pgoff + i]);
> +		if (fb_page && !PageSlab(fb_page)) {
> +			WRITE_ONCE(arena->slab_pages[pgoff + i], NULL);
> +			set_page_private(fb_page, 0);
> +		}
> +	}

arena_free_pages() correctly uses compute_pgoff() to convert the 32-bit
arena offset to a logical page index before indexing slab_pages[]. The
compute_pgoff() function subtracts (u32)user_vm_start:

    static long compute_pgoff(struct bpf_arena *arena, long uaddr)
    {
        u32 start = (u32)arena->user_vm_start;
        return ((u32)uaddr - start) >> PAGE_SHIFT;
    }

This gives the correct logical offset in [0, max_entries).

[ ... ]

> +/*
> + * SLAB_BPF_ARENA: per-arena kmem_cache buckets backing bpf_arena_alloc/free.
> + * Slab pages come from the arena pool; slub uses direct-map VAs internally,
> + * BPF sees the arena vmalloc view, translation happens at the kfunc boundary.
> + */
> +struct slab *bpf_arena_alloc_slab_page(void *arena_p, gfp_t flags, int node,
> +				       bool allow_spin)
> +{
> +	struct bpf_arena *arena = arena_p;
> +	long ret_user_va;
> +	struct page *page;
> +	struct slab *slab;
> +	u32 uaddr32;
> +
> +	/*
> +	 * set_page_slab=true makes apply_range_set_cb() tag PageSlab under
> +	 * arena->spinlock so a racing bpf_arena_free_pages() can't free it.
> +	 */
> +	ret_user_va = arena_alloc_pages(arena, 0, 1, node, allow_spin, true, &page);
> +	if (!ret_user_va)
> +		return NULL;
> +
> +	uaddr32 = (u32)ret_user_va;
> +	slab = page_slab(page);
> +	/*
> +	 * Stash uaddr32 in slab->stride; allocate_slab() skips
> +	 * alloc_slab_obj_exts_early() for SLAB_BPF_ARENA so it survives.
> +	 */
> +	slab_set_stride(slab, uaddr32);
> +	WRITE_ONCE(arena->slab_pages[uaddr32 >> PAGE_SHIFT], page);
> +
> +	return slab;
> +}

Does this array indexing work correctly when user_vm_start has non-zero
low 32 bits?

The slab_pages[] array was sized to max_entries, which equals the number
of pages in the arena's 4GB window. It should be indexed by the logical
page offset within that window, computed via compute_pgoff().

Here bpf_arena_alloc_slab_page() indexes it with uaddr32 >> PAGE_SHIFT,
where uaddr32 is the absolute 32-bit arena offset returned by
arena_alloc_pages(). This includes the low 32 bits of user_vm_start.

For example, if user_vm_start = 0x7f7d26200000 (as shown in the file's
comment at line 35), then (u32)user_vm_start = 0x26200000. Right-shifting
by PAGE_SHIFT (12) gives 156160. If the arena's max_entries is 262144
(1GB arena), this index is in bounds. But if max_entries is 131072
(512MB), the index 156160 exceeds the array size.

The same indexing pattern appears in:
  - bpf_arena_free_slab_page() at line 523
  - bpf_arena_alloc() fallback path at line 683
  - bpf_arena_free() at line 736

Should all four use compute_pgoff() instead, matching the corrected
indexing in arena_free_pages()?


> +static u32 arena_slab_uaddr32(const struct slab *slab)
> +{
> +	return slab_get_stride((struct slab *)slab);
> +}
> +
> +void bpf_arena_free_slab_page(void *arena_p, struct slab *slab)
> +{
> +	struct bpf_arena *arena = arena_p;
> +	u32 uaddr32 = arena_slab_uaddr32(slab);
> +
> +	WRITE_ONCE(arena->slab_pages[uaddr32 >> PAGE_SHIFT], NULL);
> +	arena_free_pages(arena, uaddr32, 1, false);
> +}

[ ... ]

> +__bpf_kfunc void *bpf_arena_alloc(void *p__map, u32 size)
> +{
> +	struct bpf_map *map = p__map;
> +	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
> +	struct kmem_cache *c;
> +	struct slab *slab;
> +	unsigned int idx;
> +	void *kva;
> +	u32 uaddr32;
> +
> +	if (map->map_type != BPF_MAP_TYPE_ARENA || !size)
> +		return NULL;
> +	if (size > (1U << ARENA_KMALLOC_MAX_SHIFT)) {
> +		struct page *first_page;
> +		long ret_user_va;
> +		u32 page_cnt, pgoff;
> +
> +		page_cnt = round_up(size, PAGE_SIZE) >> PAGE_SHIFT;
> +		if (!page_cnt)
> +			return NULL;
> +		/* sleepable=false mirrors kmem_cache_alloc_nolock() */
> +		ret_user_va = arena_alloc_pages(arena, 0, page_cnt, NUMA_NO_NODE,
> +						false, false, &first_page);
> +		if (!ret_user_va)
> +			return NULL;
> +		pgoff = (u32)ret_user_va >> PAGE_SHIFT;
> +		set_page_private(first_page, page_cnt);
> +		WRITE_ONCE(arena->slab_pages[pgoff], first_page);
> +		return (void *)ret_user_va;
> +	}

[ ... ]

> +__bpf_kfunc void bpf_arena_free(void *p__map, void *ptr__ign)
> +{
> +	struct bpf_map *map = p__map;
> +	struct bpf_arena *arena = container_of(map, struct bpf_arena, map);
> +	struct page *page;
> +	struct slab *slab;
> +	u32 arena_off, pgoff;
> +	void *kva;
> +
> +	if (map->map_type != BPF_MAP_TYPE_ARENA || !ptr__ign)
> +		return;
> +
> +	arena_off = (u32)(unsigned long)ptr__ign;
> +	pgoff = arena_off >> PAGE_SHIFT;
> +	if (pgoff >= arena->map.max_entries)
> +		goto violation;
> +	page = READ_ONCE(arena->slab_pages[pgoff]);
> +	if (!page)
> +		goto violation;

The bounds check pgoff >= arena->map.max_entries cannot protect against
the out-of-bounds access if pgoff is computed as (u32)ptr >> PAGE_SHIFT
instead of compute_pgoff(). When user_vm_start has non-zero low 32 bits,
the raw shift produces an offset that includes those bits, which can be
far larger than max_entries. A 1GB arena starting at user_vm_start =
0x7f7d26200000 would have max_entries = 262144, but the first allocated
page offset would be computed as 0x26200000 >> 12 = 156160, which passes
this bounds check even though the array only has 262144 slots and the
correct logical index should be 0.


---
AI reviewed your patch. Please fix the bug or email reply why it's not a bug.
See: https://github.com/kernel-patches/vmtest/blob/master/ci/claude/README.md

CI run summary: https://github.com/kernel-patches/bpf/actions/runs/26670515779
--===============4695289581068011818==--

