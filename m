Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64A2CCCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:05:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC2AC8E002F; Wed, 15 Oct 2025 09:05:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B99F78E0020; Wed, 15 Oct 2025 09:05:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD7688E002F; Wed, 15 Oct 2025 09:05:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98F778E0020
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:05:13 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25A121DA6DE
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:05:13 +0000 (UTC)
X-FDA: 84000369306.09.CCB07A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4BC5B100013
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:05:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F12SqXdh;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760533511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mzeow8aVSDkC1qzULQkmK15/X6aC73xjvRgRFvsPFms=;
	b=NDSKfqlA4Lt3Xi0Y0LTnX6vCr2dxvQvQ1l6ER6zmge9yCDorPUhn6nwV45XDoySegmPAKM
	dMBs0YV8TuftHbHqw0X8I+OCpTL6+L/r0CMY71V331RQ/LaMSLmeiyw6PlhJ8AKPKDIKF5
	1beKDO0klwfgGswnV3+lU0SZfScN4u0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F12SqXdh;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760533511; a=rsa-sha256;
	cv=none;
	b=sf87GiAxGc6z2POS18o8ccXE7MC4zLr0VN3o7AQ7LS8l1d2wbc+XPvmUxO2sHo6W/rpKmj
	UAHUFA0hPF/s1Pn6xIeVgp8wIB3B9dylFmeriSELvWi/a6jk8oXF9UzTmt3S+/PSKQrNn/
	ZmDGtbC+cMwxv/nx1Jp8ZcLB/bTBpgU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C6C524523C;
	Wed, 15 Oct 2025 13:05:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4773C4CEF8;
	Wed, 15 Oct 2025 13:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760533509;
	bh=2ad4JdcB1dy+2CtYWky5FKUKrCrxFnEL7ZzpoxjFRAs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=F12SqXdhbLXz05zwQrekYKF8O2vnJ9nCDTpE5dudRvebGwlmWhKNdsmccdILjpq46
	 L8rSlTNMs5ad4QaNiIwBoPBzLwTsli8z/UmumMaDdjuvTLhP+U99FspQvl2vuSnT5y
	 Nx08AGpCO2HP1B/FEAx+E2Yo3A6G1zH2JNTQNW11R+yhvXZVygEveX3xFnqjoa9c7k
	 RZW0K1fbaNHN+utYQZ33x+V4pjidmSdp0/F0jKS1C5dH5hOv/SbvRqa3N8VCIPAkUH
	 D90O9K2/8Bccg6glBB4fgj3vrIVSAP5OAp7fSu1ywQmErqjxu1b2e72oyfa3p0f8yk
	 zfQvF0IBBrI+w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  brauner@kernel.org,  corbet@lwn.net,
  graf@amazon.com,  jgg@ziepe.ca,  linux-kernel@vger.kernel.org,
  linux-kselftest@vger.kernel.org,  linux-mm@kvack.org,
  masahiroy@kernel.org,  ojeda@kernel.org,  pratyush@kernel.org,
  rdunlap@infradead.org,  rppt@kernel.org,  tj@kernel.org,
  jasonmiu@google.com,  dmatlack@google.com,  skhawaja@google.com,
 glider@google.com, elver@google.com
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from
 the buddy allocator
In-Reply-To: <20251015053121.3978358-3-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Wed, 15 Oct 2025 01:31:21 -0400")
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
	<20251015053121.3978358-3-pasha.tatashin@soleen.com>
Date: Wed, 15 Oct 2025 15:05:05 +0200
Message-ID: <mafs0v7kgjoxq.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: t94gxfr5nym115irnxw77y71ae33mm3m
X-Rspamd-Queue-Id: 4BC5B100013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760533511-25390
X-HE-Meta: U2FsdGVkX1+zS3c0vJ3jMPTBqMlsg9SrqkRv92bYv7OF0krkTe5TMeANhCPsi87+rBNpWK+m0nPRI8nZ0kbCOOke38vT5zo8LUUvugsbOyJJJb4MaDM5Q0Q1fUlITO1f0GWHT0mOzaucjYNCBN5aLc6FpNqc70AoexLztlXR8yuz2Qn1sGwt8qS4yS+Loa1nlRUGVt1YuIqOp/mVjW5/SrARZR6EpQoOTzhQIuc0y/Kl+qvrNcMpNZu5Fcl3MdtWzGbSLuFNhgieF7O33UpJU2AOdoIQMm8VNJAfvBExXVKcCLlfEw8AvWuH9ws4wBssGdrGX41zIYAs75Hg6w292ZS9MZL9UtPq6W85QsxxJ6EvJ5jvODnl7U2pxZkRcyak7GHIphRaLdbqS6WiIrf1Y/IGb3PHKQwSVumhIUqXHSJ7gRuuLvCh1jFgmXNphX4p+6xBrqZJ9Ga4kcn8S+k+3PvL+8xLiQ2BUDqlOxIVbad/U1LPnVgLP6wuc3GFt/sVFcshCxF/cG6CrLJ8cAhcnWHbVtIKnZxa+J1AsHk5ubU3ooMSIeIHquP9OgUoMaVaTZgbV6xX7oARCZ0J0CugwEoN1JkJ2HvwXBvm/D42MM3zdTwNxC2lP4zV1hCxaLXNet09yyOhft6ieRndCodfWtc4lGNi7q18YkRXio4i00oZx/0Y5Nnj2hQn1W4M6aR4vXUMQ34joHbRmKlGPkm5P3wA3rnecR9GXJdiijfgSDdg+GbU1n5HFTfPbIaplXrARfx5hhm8pvuHMTe3+e4sGWUnkXIbI68+5BY0J/m9TT1EWhJBbpwCv6j+1er3+gzc2OV6o2dK+E74KiQU2nUKQCs/YJAu6wZz27zBcd+MN/aL67cxYnJ0GAiExD9GsbuShVoswUyyLD4XUxf4SJ6hkqZbnyMFh4GcUPe2sOdyfq6WyWLhc6MESi6cNQDS89qZAVmAOkQnatvd4ak4Tbs
 7V77Pwh3
 DBfcTBHZNd1dKMlO05g+st84SELb4EXxwG9CCcuMe6e/C6rsk8ZGtTBgLvM1FbOmI88FIhwEpt6qX48qErDdvOgUm4WpsvM41gUF9RgSPaGGJZ8Zuan+bdNnGlbwlTcQz2YMBtqHp0pIJL36Nw5yCSFPL3J6g6UYQL8lR6ZcCqe8K3AI3nRUoQO8aPSpshkwFtSi1YS49CQcvdOXzxrtDk+wkdg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Cc Marco, Alexander

On Wed, Oct 15 2025, Pasha Tatashin wrote:

> KHO allocates metadata for its preserved memory map using the SLUB
> allocator via kzalloc(). This metadata is temporary and is used by the
> next kernel during early boot to find preserved memory.
>
> A problem arises when KFENCE is enabled. kzalloc() calls can be
> randomly intercepted by kfence_alloc(), which services the allocation
> from a dedicated KFENCE memory pool. This pool is allocated early in
> boot via memblock.

At some point, we'd probably want to add support for preserving slab
objects using KHO. That wouldn't work if the objects can land in scratch
memory. Right now, the kfence pools are allocated right before KHO goes
out of scratch-only and memblock frees pages to buddy.

	kfence_alloc_pool_and_metadata();
	report_meminit();
	kmsan_init_shadow();
	stack_depot_early_init();
        [...]
	kho_memory_init();

	memblock_free_all();

Can't kfence allocate its pool right after memblock_free_all()? IIUC at
that point, there shouldn't be much fragmentation and allocations should
still be possible.

Another idea could be to disable scratch-only a bit earlier and add an
option in memblock_alloc() to avoid scratch areas?

Anyway, not something we need to solve right now with this series.
Something to figure out eventually.

>
> When booting via KHO, the memblock allocator is restricted to a "scratch
> area", forcing the KFENCE pool to be allocated within it. This creates a
> conflict, as the scratch area is expected to be ephemeral and
> overwriteable by a subsequent kexec. If KHO metadata is placed in this
> KFENCE pool, it leads to memory corruption when the next kernel is
> loaded.
>
> To fix this, modify KHO to allocate its metadata directly from the buddy
> allocator instead of SLUB.
>
> As part of this change, the metadata bitmap size is increased from 512
> bytes to PAGE_SIZE to align with the page-based allocations from the
> buddy system.

The implication of this change is that preservation metadata becomes
less memory-efficient when preserved pages are sparse. Mainly because if
only one bit is set in the bitmap, now 4k bytes of memory is used
instead of 512 bytes.

It is hard to say what difference this makes in practice without
sampling real workloads, but perhaps still worth mentioning in the
commit message?

Other than this,

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index ef1e6f7a234b..519de6d68b27 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -66,10 +66,10 @@ early_param("kho", kho_parse_enable);
>   * Keep track of memory that is to be preserved across KHO.
>   *
>   * The serializing side uses two levels of xarrays to manage chunks of per-order
> - * 512 byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order of a
> - * 1TB system would fit inside a single 512 byte bitmap. For order 0 allocations
> - * each bitmap will cover 16M of address space. Thus, for 16G of memory at most
> - * 512K of bitmap memory will be needed for order 0.
> + * PAGE_SIZE byte bitmaps. For instance if PAGE_SIZE = 4096, the entire 1G order
> + * of a 8TB system would fit inside a single 4096 byte bitmap. For order 0
> + * allocations each bitmap will cover 128M of address space. Thus, for 16G of
> + * memory at most 512K of bitmap memory will be needed for order 0.
>   *
>   * This approach is fully incremental, as the serialization progresses folios
>   * can continue be aggregated to the tracker. The final step, immediately prior
> @@ -77,7 +77,7 @@ early_param("kho", kho_parse_enable);
>   * successor kernel to parse.
>   */
>  
> -#define PRESERVE_BITS (512 * 8)
> +#define PRESERVE_BITS (PAGE_SIZE * 8)
>  
>  struct kho_mem_phys_bits {
>  	DECLARE_BITMAP(preserve, PRESERVE_BITS);
> @@ -131,18 +131,21 @@ static struct kho_out kho_out = {
>  
>  static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
>  {
> +	unsigned int order;
>  	void *elm, *res;
>  
>  	elm = xa_load(xa, index);
>  	if (elm)
>  		return elm;
>  
> -	elm = kzalloc(sz, GFP_KERNEL);
> +	order = get_order(sz);
> +	elm = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, order);
>  	if (!elm)
>  		return ERR_PTR(-ENOMEM);
>  
> -	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm), sz))) {
> -		kfree(elm);
> +	if (WARN_ON(kho_scratch_overlap(virt_to_phys(elm),
> +					PAGE_SIZE << order))) {
> +		free_pages((unsigned long)elm, order);
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> @@ -151,7 +154,7 @@ static void *xa_load_or_alloc(struct xarray *xa, unsigned long index, size_t sz)
>  		res = ERR_PTR(xa_err(res));
>  
>  	if (res) {
> -		kfree(elm);
> +		free_pages((unsigned long)elm, order);
>  		return res;
>  	}
>  
> @@ -357,7 +360,7 @@ static struct khoser_mem_chunk *new_chunk(struct khoser_mem_chunk *cur_chunk,
>  {
>  	struct khoser_mem_chunk *chunk;
>  
> -	chunk = kzalloc(PAGE_SIZE, GFP_KERNEL);
> +	chunk = (void *)get_zeroed_page(GFP_KERNEL);
>  	if (!chunk)
>  		return ERR_PTR(-ENOMEM);

-- 
Regards,
Pratyush Yadav

