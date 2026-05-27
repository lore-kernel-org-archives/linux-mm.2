Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 384E0CD6E44
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 11:45:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E6646B0092; Wed, 27 May 2026 07:45:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9706E6B0095; Wed, 27 May 2026 07:45:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85F256B0096; Wed, 27 May 2026 07:45:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73AFE6B0092
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:45:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 379F01619CD
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:45:04 +0000 (UTC)
X-FDA: 84813018528.12.A9B1AB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6E0B540009
	for <linux-mm@kvack.org>; Wed, 27 May 2026 11:45:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jmE0ACf3;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779882302; a=rsa-sha256;
	cv=none;
	b=X98an+ZLsEMx3s+cFdGjOapmFdS1dMVi5GKe7S6V0FYdjdsAVJwOVhf3R6PU7vrr4BGROs
	sWsY3Q1N/Ns6lQkZZdpikW7faA2WalMmWgy5wSMSQM1PgBXx3OTRc4+HPH+XG5DnKCcrqJ
	KmPpm17lDmUhM1d5Nnwx4pcDcMu/aWM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jmE0ACf3;
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779882302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6InA4tQAxLsS7j94L5G1yEXJPfdZ+4wJTUuxhR16ysc=;
	b=HvyYLy3GhDWSeONEjPMqGymhOAq8Ozcy5ctU9aiBUkCHiXI7ie538Y2wRWkli3xk2fOnfW
	l5q+cN7a8C0rvKDn3KEqZOAD4u6wOcUVKmTSpitEmxkivAdLBgCcEQvoFGnPiq4r9rWR4e
	HI0mcY6QE8PJhso0muiadqDnSBuSQOo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 78F2943FF2;
	Wed, 27 May 2026 11:45:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C5441F00A3A;
	Wed, 27 May 2026 11:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779882301;
	bh=6InA4tQAxLsS7j94L5G1yEXJPfdZ+4wJTUuxhR16ysc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jmE0ACf3VqYlPLAURNrUVBUpTirFjm6AOmbp7FRKMCQPS4O7hxubZyIL+l56vhbfB
	 fs3RoVnvEGGcmt243CTajQnTYqO0SYgyRaF84t6ATP47FV1pJYn5iTjqCLmhPAWqwY
	 Mw/snjX5RbRG0fXRfEdYygqgRCxy9F2/4aTsTowLGQF8cfiVDsHLTblBVYcCt7TxDr
	 0m6eCV5JroXQKxiO6hO2mvynMgQFldZ8cQEBOCQQHN4vwpmdUYfV9eVzJ6qJeiSMqe
	 vRlif/RwtY3kl2WyXvbbMIcEdqnmPeHPZWxlS9yjduXHt86hZ4zldvrHh9+SFgJ9E1
	 0Xk1G0csyxJrQ==
Date: Wed, 27 May 2026 12:44:57 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: tao <tao.wangtao@honor.com>
Cc: catalin.marinas@arm.com, will@kernel.org, tglx@kernel.org, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, willy@infradead.org, sj@kernel.org, 
	kees@kernel.org, luizcap@redhat.com, zhangjiao2@cmss.chinamobile.com, 
	kas@kernel.org, hpa@zytor.com, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz, 
	riel@surriel.com, harry@kernel.org, jannh@google.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, 
	nao.horiguchi@gmail.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, pfalcato@suse.de, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev, ryncsn@gmail.com, 
	21cnbao@gmail.com, jparsana@google.com, dvander@google.com, zhangji1@honor.com, 
	wangzicheng@honor.com
Subject: Re: [PATCH 01/15] mm/rmap: introduce anon_rmap APIs for anonymous
 folios
Message-ID: <ahbWKJL8TtGsFV4r@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <20260527110147.17815-2-tao.wangtao@honor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527110147.17815-2-tao.wangtao@honor.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 6E0B540009
X-Rspamd-Server: rspam03
X-Stat-Signature: in3mag6szbhw6zts9pu3rzjbf34s598j
X-HE-Tag: 1779882302-831188
X-HE-Meta: U2FsdGVkX18cC7Bp+QbFDhOnzfy0WPXjg3fGKtsgUDYNFkKkIVT0HmgmK+X/KWq29wprRPba7Jpv42y6xsgAPffoJOBCpmM96g1EidjUR1r8yv7oh75REA2ivAJe1EDY/6O1b5MTixSmpsz9rSZE8Y9MCe7LAbPVGg8aD1fI4nmWc4+D1m134Hmncz9DJmZpbN4WMgDrbrqxqMuCdEtkErChpF7IfSBfAtbgJXBZJY4wG9GboHOaGryIBN/Ds8qEzcMdQsNVl64sbpITDdtYGADqXh3lVF1gZBLHq5ViwZS16lhnbVLCar2t/yDTNKjXEZK1FbwkJJWjzr5Cg9xQhJbSymXi78XtJQhsVMqCWZw04ZnpQoPPOehv4jlEO5qeMKYVR6GjSp6UHg0OPpG1SLdcy3Kfnth5M/pgKrsY8PRI8zfJUHBrveYQnPQ58GqG6L+o8pGvgFZjalkpHyZOZRMph2nVsyftbyRnK2sO4kAOypV+FnFD0bqAga0m9xaucI6mQC50p3yVueLt5WRlKDuQZGxJnOuBgXylrzlD6xh6TXPAsWdfVQAZYGjr9+/39wGGIHCNcKsmDQf4DDeG5AP4c1ryfHqR1vQSVC3CaMkvJQ5G4uwTcBN84shG6q9XnFYsneTaAL5BZl1immuy1iaGieuMqS96SDzayVutfayrhWe7HNzcA7yAzU1X8yU+A2iAaywSa/E+f0dQxNIdHtbeIUufG/DApWRig2kL307t515kWZLpKj+FiXMOnQaEn8gHxnyWU25fMQgrYC6aup7DOiUwNVyozb77Gv3sxlMABqRFZ1nv+oNYuD6EGdrL7c1k5wqGmm6RTkhvlTMnAknHNe9JVTU5a28SZuhOMmwfWrjzTvkNFoxJYX6w09imf+wCl2LihrUg/TgU0vbrqja6L3VuUwKGz3chNqUewDER0R/U2mKAMg+5RD5fFF0WgaCI51N/g74cCJI5uTo
 rTHpH8Go
 41o8CixA739FmOHDEV0X2+oZVHVu+vctwtYO1w8DGr5xOsTVztu0uOLrDGFo3gxgcpqmEjfGnJIw0qw199V5JCO6ckPj0LGGWQk6R1kNeNYZ91G0NWxJHl0r+qMV7cNWOLOKOFVEpu0uzbsn8ExpuDmMMpGEJs6zeypRGdpUb/xyZZ7sHxdDA++ofb5ObNS9aXSjdtF+BkKB7mVDGC0cqFHkG1zTipv6Z7VrLkiod5ymjBVeqxDJQbjnYaSvcXntESSYBuTB4GlIk2nzzE18AP48c83EHtND+rXnV5AGRW++dZzzkAiIaoiaFvZpFwLIsqE5MmmZVzxBSF7kiJCcblbIXmhOo6BgsxW5RSYa32geDNcQ0bezbJrHku9VMUzFHoaKfIJv2DdlpVfeVMk6nb0wRTWE3TBL1lX1S8da6gkbwsNw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 07:01:33PM +0800, tao wrote:
> Add a set of anon_rmap APIs to operate on the reverse mappings of
> anonymous folios.
>
> Introduce anon_rmap_for_each_vma() as a wrapper around
> vma_interval_tree_foreach(), so callers no longer access the
> interval tree directly.
>
> This prepares the rmap code for upcoming ANON_VMA_LAZY support and
> RCU-based lockless rmap traversal.
>
> No functional change intended.

This commit message is total garbage. You're not explaining WHY you're
using words to describe what the code does. I can read the code?

>
> Signed-off-by: tao <tao.wangtao@honor.com>

This is all horrible, horribly invasive, and adding a pile of crap on machinery
we want to get rid of.

You've added zero explanation or comments. This is just not upstreamable,
and even if you did explain yourself we don't want to extend a broken
abstraction with more broken complexity?

You're also seemingly introducing a typesafe wrapper to wrap an arbitrary value?

> ---
>  include/linux/rmap.h | 68 +++++++++++++++++++++++++++++++++++++++++
>  mm/rmap.c            | 73 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 141 insertions(+)
>
> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> index 8dc0871e5f00..c42314ea4362 100644
> --- a/include/linux/rmap.h
> +++ b/include/linux/rmap.h
> @@ -937,6 +937,44 @@ int pfn_mkclean_range(unsigned long pfn, unsigned long nr_pages, pgoff_t pgoff,
>  void remove_migration_ptes(struct folio *src, struct folio *dst,
>  		enum ttu_flags flags);
>
> +/* Reverse mapping handle for anonymous folio rmap helpers. */
> +typedef struct anon_rmap {
> +	unsigned long rmap;
> +} anon_rmap_t;

I do not know why you're using a typedef when you just treat it as an
arbitrary value?

> +
> +#define ANON_RMAP_NULL make_anon_rmap(0)

This is just equivalent to a NULL value?...

> +
> +static inline anon_rmap_t make_anon_rmap(const void *anon_mapping)
> +{
> +	return (anon_rmap_t){ .rmap = (unsigned long)anon_mapping, };
> +}

You're intentionally defeating type safety to store arbitrary values?...

> +
> +static inline unsigned long anon_rmap_value(anon_rmap_t anon_rmap)
> +{
> +	return anon_rmap.rmap;
> +}

'Untype safe my arbitrarily type safe wrapped type'...?

> +
> +static inline anon_rmap_t anon_vma_to_anon_rmap(const struct anon_vma *anon_vma)
> +{
> +	return make_anon_rmap(anon_vma);
> +}
> +
> +static inline struct anon_vma *anon_rmap_to_anon_vma(anon_rmap_t anon_rmap)
> +{
> +	unsigned long rmap = anon_rmap_value(anon_rmap);
> +
> +	return (struct anon_vma *)rmap;
> +}

A ton of noise for seemingly no value?

> +
> +anon_rmap_t vma_get_anon_rmap(struct vm_area_struct *vma);
> +void put_anon_rmap(anon_rmap_t anon_rmap);
> +void anon_rmap_lock_write(anon_rmap_t anon_rmap);
> +int anon_rmap_trylock_write(anon_rmap_t anon_rmap);
> +void anon_rmap_unlock_write(anon_rmap_t anon_rmap);
> +void anon_rmap_lock_read(anon_rmap_t anon_rmap);
> +int anon_rmap_trylock_read(anon_rmap_t anon_rmap);
> +void anon_rmap_unlock_read(anon_rmap_t anon_rmap);

Yes let's add a bunch of extra broken abstractions on the broken abstraction.

And let's not comment anything!

> +
>  /*
>   * rmap_walk_control: To control rmap traversing for specific needs
>   *
> @@ -969,6 +1007,36 @@ void rmap_walk_locked(struct folio *folio, struct rmap_walk_control *rwc);
>  struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  					  struct rmap_walk_control *rwc);
>
> +bool folio_maybe_same_anon_vma(const struct folio *folio,
> +	const struct vm_area_struct *vma);

What the hell is this?


> +anon_rmap_t folio_get_anon_rmap(const struct folio *folio);
> +anon_rmap_t folio_lock_anon_rmap_read(const struct folio *folio,
> +	struct rmap_walk_control *rwc);
> +
> +static inline struct vm_area_struct *anon_rmap_iter_first_vma(
> +	anon_rmap_t anon_rmap, unsigned long start, unsigned long last,
> +	struct anon_vma_chain **avc)
> +{
> +	struct anon_vma *anon_vma = anon_rmap_to_anon_vma(anon_rmap);
> +
> +	*avc = anon_vma_interval_tree_iter_first(&anon_vma->rb_root, start, last);
> +	return *avc ? (*avc)->vma : NULL;
> +}

So we're allowing for folios to have NULL entries (really the commit
message should have that, rather than me scanning through uncommented
code), but in what world are we ok with an anon folio NOT BEING LINKED BACK
TO ITS VMA?

That's broken no?

> +
> +static inline struct vm_area_struct *anon_rmap_iter_next_vma(
> +	anon_rmap_t anon_rmap, unsigned long start, unsigned long last,
> +	struct anon_vma_chain **avc)
> +{
> +	if (!*avc)
> +		return NULL;
> +	*avc = anon_vma_interval_tree_iter_next(*avc, start, last);
> +	return *avc ? (*avc)->vma : NULL;
> +}
> +
> +#define anon_rmap_foreach_vma(vma, avc, anon_rmap, start, last) 	   \
> +	for (vma = anon_rmap_iter_first_vma(anon_rmap, start, last, &avc); \
> +	     vma; vma = anon_rmap_iter_next_vma(anon_rmap, start, last, &avc))
> +
>  #else	/* !CONFIG_MMU */
>
>  #define anon_vma_init()		do {} while (0)
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 78b7fb5f367c..1b2dada71778 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -701,6 +701,79 @@ struct anon_vma *folio_lock_anon_vma_read(const struct folio *folio,
>  	return anon_vma;
>  }
>
> +anon_rmap_t vma_get_anon_rmap(struct vm_area_struct *vma)
> +{
> +	mmap_assert_locked(vma->vm_mm);
> +	VM_BUG_ON(!vma->anon_vma);

We don't use BUG_ON() especially VM_BUG_ON().

> +	get_anon_vma(vma->anon_vma);
> +	return anon_vma_to_anon_rmap(vma->anon_vma);
> +}
> +
> +void put_anon_rmap(anon_rmap_t anon_rmap)
> +{
> +	put_anon_vma(anon_rmap_to_anon_vma(anon_rmap));
> +}
> +
> +void anon_rmap_lock_write(anon_rmap_t anon_rmap)
> +{
> +	anon_vma_lock_write(anon_rmap_to_anon_vma(anon_rmap));
> +}
> +
> +int anon_rmap_trylock_write(anon_rmap_t anon_rmap)
> +{
> +	return anon_vma_trylock_write(anon_rmap_to_anon_vma(anon_rmap));
> +}
> +
> +void anon_rmap_unlock_write(anon_rmap_t anon_rmap)
> +{
> +	anon_vma_unlock_write(anon_rmap_to_anon_vma(anon_rmap));
> +}
> +
> +void anon_rmap_lock_read(anon_rmap_t anon_rmap)
> +{
> +	anon_vma_lock_read(anon_rmap_to_anon_vma(anon_rmap));
> +}
> +
> +int anon_rmap_trylock_read(anon_rmap_t anon_rmap)
> +{
> +	return anon_vma_trylock_read(anon_rmap_to_anon_vma(anon_rmap));
> +}
> +
> +void anon_rmap_unlock_read(anon_rmap_t anon_rmap)
> +{
> +	anon_vma_unlock_read(anon_rmap_to_anon_vma(anon_rmap));
> +}

All of these assume that you're getting an anon_vma even though you have
established above that you can put arbitrary other values?

This is terrible?

> +
> +bool folio_maybe_same_anon_vma(const struct folio *folio,
> +	const struct vm_area_struct *vma)
> +{
> +	struct anon_vma *anon_vma;
> +	struct anon_vma *tgt_anon_vma = vma->anon_vma;
> +	bool same = false;
> +
> +	rcu_read_lock();
> +	anon_vma = folio_anon_vma(folio);
> +	if (anon_vma && tgt_anon_vma)
> +		same = anon_vma->root == tgt_anon_vma->root;
> +	rcu_read_unlock();
> +	return same;

What VMA locks are being held at this point? You assert none.

Why is it maybe?

Why are you taking the RCU lock?

> +}
> +
> +anon_rmap_t folio_get_anon_rmap(const struct folio *folio)
> +{
> +	struct anon_vma *anon_vma = folio_get_anon_vma(folio);
> +
> +	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
> +}
> +
> +anon_rmap_t folio_lock_anon_rmap_read(const struct folio *folio,
> +				      struct rmap_walk_control *rwc)
> +{
> +	struct anon_vma *anon_vma = folio_lock_anon_vma_read(folio, rwc);
> +
> +	return anon_vma ? anon_vma_to_anon_rmap(anon_vma) : ANON_RMAP_NULL;
> +}
> +
>  #ifdef CONFIG_ARCH_WANT_BATCHED_UNMAP_TLB_FLUSH
>  /*
>   * Flush TLB entries for recently unmapped pages from remote CPUs. It is
> --
> 2.17.1
>

