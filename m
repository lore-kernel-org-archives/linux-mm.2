Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57920CD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 07:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8E16B0005; Tue, 26 May 2026 03:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659EF6B0088; Tue, 26 May 2026 03:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 549B46B008A; Tue, 26 May 2026 03:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D57D6B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 03:29:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3F8F402E0
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:29:21 +0000 (UTC)
X-FDA: 84808745322.21.A995438
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1072040014
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:29:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmRf3rq+;
	spf=pass (imf01.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779780560;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CZzaP2DfSCyj3BlBs75A5hfUg/8ZlRWz2vMUNSBTauw=;
	b=KjumONd9j3U8ZwFt69kYEs1lUQN9h6IBZqfpuhB4V1txIHBTX+p8oGuj7tgoa0/2d+5XzS
	VELnJX8b7hsGPGYBGgXm0lEJ337uHpTfRQcVmaURpM7MSq4/nEoS29C6a22PLTSTJRaq+0
	9XTdnFHnvk8W6nBGyyLSWeRLfSEjZhI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779780560; a=rsa-sha256;
	cv=none;
	b=J7LeEBieV9aeX1tnLyMaJhSB4+T+ZAVf3RWIYrkX/UtKfgnVaUHsMDpyJS4zu0QWjVEfho
	gDcmvDsyJazMg8QN81/KIvje8ZpW2684fOpMcb6iWBfFcqpXYFwWJqr4NMZ/Vo2NTWoGuf
	xHroxw55NlGIt7VQuY1QkrsHY4PkJKE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dmRf3rq+;
	spf=pass (imf01.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 235C243C34;
	Tue, 26 May 2026 07:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355701F000E9;
	Tue, 26 May 2026 07:29:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779780559;
	bh=CZzaP2DfSCyj3BlBs75A5hfUg/8ZlRWz2vMUNSBTauw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dmRf3rq+rw4Hzir1focqHyqBaYge4CYQKRJMX2bo/WSZJ67bfv1ZDHJ3RSSWV8nSp
	 JcFmKqwvhtEylkNYfPk//hsdRJjfqotwsoBiRhGzlnGRY4taxz7AMtPTAqL8/RzMEm
	 GttEE9lZzYR8l+oCcYl4Bf5vKu/5DIEe0F6/xHYAQitWRpV+npChynbzHhdaa0OB/q
	 z6E5hSZvKZaBP0c9ahWkKdzrYhCAOTdpUmvziogyuXWmkkAdu6xv2G4P0dlOnqG1Hq
	 b5/WzZLm2JVbZoa0Ohofi1QyW251wh3wiANzRKAHTLr3hjM0t9Dx4VNEZMA9ZHm8+p
	 fL/wIoJpQRpcQ==
Date: Tue, 26 May 2026 09:29:14 +0200
From: Dennis Zhou <dennis@kernel.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dodam@google.com
Subject: Re: [PATCH v6 3/4] percpu: Introduce struct pcpu_region
Message-ID: <ahVLysq0gKQp4x1r@palisades.local>
References: <20260513085117.1024175-1-joonwonkang@google.com>
 <20260513085117.1024175-3-joonwonkang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085117.1024175-3-joonwonkang@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 1072040014
X-Stat-Signature: 8p4ybnd513phkm1xramfa33m5wibefye
X-Rspamd-Server: rspam06
X-HE-Tag: 1779780559-795922
X-HE-Meta: U2FsdGVkX1/8TOBjUTVgPGaigLuoV7g0DhwVZFxiURQFpi8tQlZC4j5GNAl7j0g3D46hYFEIRDuQ46vmKpDOYc8Io2dGfa3IQrbMqrj/qBsrwQM4n4dTt0d+BzzVMs0UDV9vBlf0TQqzCsYSfkM509Z4mNj0wpT9N+xPM7NMvFzez9aHuPZZJL2F8TaGYTnlMrLw+84tZT2kDINkpktNN+urCZGiX6Oz3SkwLL6CAmYmRyqOLPXkyDGw2dzyGk3hiMb+94oQ/bAA0MRsmufn7dIBZWuxpVEyle1J4P2oT0x1zR3b1yQEiHl23QOhkAOTY/menHhyRmjNfFWTs7M6iis650F6R0v0C7OQN6kKNOi2Z/ajxOn8AwHjIRJrSkv0CnOgwYV16BTWmQhBGXK4kJ+xkaXqaRdyikmZbD7saB820DooQ5MC5ip8fIAyZNDOTYiaicHnZegw2ZY8aHf9fIVX/G0T1bZe2+3+qwT+ntr+9REAdNsZuibqXAGoPDACaGVWIBWBcAH60uReTcX34FcQJVzOhJ2mb9xJPLXzHZvPMz2B9UU3bDN0xreGB23pFUngk2tW0rXB1D0Pi9YgdmVGdI+uGRNJgpd6BTIDzsICg82Nh3sM6mi2zZcHtVKds6MEEoDhGo2+zTa50Lhsh5f/hmM1tyFYRKps3nvGpbwEBVGue2hCU6NRedWgAQYmeZCQvx0VqTG/CxvgzW+9FgfrDKkBK7VwqMzatrwRM/3DI+4QcM8BAduW1IexJI6/p8r/8mNXAYOg71KOyjtVWtHRSxCx0jbfjeR0spOk8CXFISgP4yz6o4MV2Jz6+wNUE9MwCk4k0qv42l8mPLLlWVZCJp5j0jBbujkWEENivUxQunjgwCA4PtD9Og7m3R45zb57D7JXY76vhrg8on7LEEdRi+0UBuGnT6DiLZh2rGnI3reptKPN2P2hdvieNsBm6fcNeKhhn1m36eJtFjD
 E6mc+yeM
 a/TyL6X3p5SHg0in5SdgZe850lYVddtmhzIBIsawQuTgD5G65Y31EdTYHSLH8TMenXG9qDf3UQog4hZD7Fa8USRa4+e3YaMUf/WSJ82rZkw8m3fakk4D/IfVQhJL6K5jSSPx16sOP6wo+Z1qdc01huU7mWFpdBNFY8zMWJ2eSnXEDQ3NeMi6xa4/U6IboDSFub4n4GcEAY5YxKklrn40aUZLDgUPaFQOPZ8XzoNVe+SsGJv0qLgRz4mO0KnWeSPSpD8a8xxfy9lNedII2EpRgysMcZrhtVPgkyd/Y4RuxSrQpJI6QHQu9HF8zDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Wed, May 13, 2026 at 08:51:15AM +0000, Joonwon Kang wrote:
> The new struct is introduced to prevent mis-use of hint start and size
> and improve readability.
> 
> Link: https://lore.kernel.org/all/aegQgyf3KuIZMK9x@palisades.local/
> Suggested-by: Dennis Zhou <dennis@kernel.org>
> Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> ---
> v6: No change.
> v5: Add missing change for mm/percpu-stats.c.
> v4: Initial version.
> 
>  mm/percpu-internal.h |  24 +++--
>  mm/percpu-stats.c    |   2 +-
>  mm/percpu.c          | 244 ++++++++++++++++++++-----------------------
>  3 files changed, 131 insertions(+), 139 deletions(-)
> 
> diff --git a/mm/percpu-internal.h b/mm/percpu-internal.h
> index 4b3d6ec43703..dd95ec2c243a 100644
> --- a/mm/percpu-internal.h
> +++ b/mm/percpu-internal.h
> @@ -6,6 +6,15 @@
>  #include <linux/percpu.h>
>  #include <linux/memcontrol.h>
>  
> +/*
> + * pcpu region represents a hint region.
> + * A region is only valid when @size is greater than 0.
> + */
> +struct pcpu_region {
> +	int start;
> +	int size;
> +};
> +
>  /*
>   * pcpu_block_md is the metadata block struct.
>   * Each chunk's bitmap is split into a number of full blocks.
> @@ -13,17 +22,14 @@
>   *
>   * The scan hint is the largest known contiguous area before the contig hint.
>   * It is not necessarily the actual largest contig hint though.  There is an
> - * invariant that the scan_hint_start > contig_hint_start iff
> - * scan_hint == contig_hint.  This is necessary because when scanning forward,
> - * we don't know if a new contig hint would be better than the current one.
> + * invariant that the scan_hint.start > contig_hint.start iff
> + * scan_hint.size == contig_hint.size.  This is necessary because when scanning
> + * forward, we don't know if a new contig hint would be better than the current
> + * one.
>   */
>  struct pcpu_block_md {
> -	int			scan_hint;	/* scan hint for block */
> -	int			scan_hint_start; /* block relative starting
> -						    position of the scan hint */
> -	int                     contig_hint;    /* contig hint for block */
> -	int                     contig_hint_start; /* block relative starting
> -						      position of the contig hint */
> +	struct pcpu_region	scan_hint;	/* scan hint for block */
> +	struct pcpu_region	contig_hint;	/* contig hint for block */
>  	int                     left_free;      /* size of free space along
>  						   the left side of the block */
>  	int                     right_free;     /* size of free space along
> diff --git a/mm/percpu-stats.c b/mm/percpu-stats.c
> index 9b9d5d6accae..4a735d09adef 100644
> --- a/mm/percpu-stats.c
> +++ b/mm/percpu-stats.c
> @@ -122,7 +122,7 @@ static void chunk_map_stats(struct seq_file *m, struct pcpu_chunk *chunk,
>  	P("empty_pop_pages", chunk->nr_empty_pop_pages);
>  	P("first_bit", chunk_md->first_free);
>  	P("free_bytes", chunk->free_bytes);
> -	P("contig_bytes", chunk_md->contig_hint * PCPU_MIN_ALLOC_SIZE);
> +	P("contig_bytes", chunk_md->contig_hint.size * PCPU_MIN_ALLOC_SIZE);
>  	P("sum_frag", sum_frag);
>  	P("max_frag", max_frag);
>  	P("cur_min_alloc", cur_min_alloc);
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 0f6dd5260f56..89b7f33500cf 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -244,10 +244,11 @@ static int pcpu_chunk_slot(const struct pcpu_chunk *chunk)
>  	const struct pcpu_block_md *chunk_md = &chunk->chunk_md;
>  
>  	if (chunk->free_bytes < PCPU_MIN_ALLOC_SIZE ||
> -	    chunk_md->contig_hint == 0)
> +	    chunk_md->contig_hint.size == 0)
>  		return 0;
>  
> -	return pcpu_size_to_slot(chunk_md->contig_hint * PCPU_MIN_ALLOC_SIZE);
> +	return pcpu_size_to_slot(chunk_md->contig_hint.size *
> +				 PCPU_MIN_ALLOC_SIZE);
>  }
>  
>  /* set the pointer to a chunk in a page struct */
> @@ -317,10 +318,10 @@ static unsigned long pcpu_block_off_to_off(int index, int off)
>  static bool pcpu_check_block_hint(struct pcpu_block_md *block, int bits,
>  				  size_t align)
>  {
> -	int bit_off = ALIGN(block->contig_hint_start, align) -
> -		block->contig_hint_start;
> +	int bit_off = ALIGN(block->contig_hint.start, align) -
> +		block->contig_hint.start;
>  
> -	return bit_off + bits <= block->contig_hint;
> +	return bit_off + bits <= block->contig_hint.size;
>  }
>  
>  /*
> @@ -330,7 +331,7 @@ static bool pcpu_check_block_hint(struct pcpu_block_md *block, int bits,
>   *
>   * This determines if we should scan based on the scan_hint or first_free.
>   * In general, we want to scan from first_free to fulfill allocations by
> - * first fit.  However, if we know a scan_hint at position scan_hint_start
> + * first fit.  However, if we know a scan_hint at position scan_hint.start
>   * cannot fulfill an allocation, we can begin scanning from there knowing
>   * the contig_hint will be our fallback.
>   */
> @@ -340,13 +341,13 @@ static int pcpu_next_hint(struct pcpu_block_md *block, int alloc_bits)
>  	 * The three conditions below determine if we can skip past the
>  	 * scan_hint.  First, does the scan hint exist.  Second, is the
>  	 * contig_hint after the scan_hint (possibly not true iff
> -	 * contig_hint == scan_hint).  Third, is the allocation request
> -	 * larger than the scan_hint.
> +	 * contig_hint.size == scan_hint.size).  Third, is the allocation
> +	 * request larger than the scan_hint.
>  	 */
> -	if (block->scan_hint &&
> -	    block->contig_hint_start > block->scan_hint_start &&
> -	    alloc_bits > block->scan_hint)
> -		return block->scan_hint_start + block->scan_hint;
> +	if (block->scan_hint.size &&
> +	    block->contig_hint.start > block->scan_hint.start &&
> +	    alloc_bits > block->scan_hint.size)
> +		return block->scan_hint.start + block->scan_hint.size;
>  
>  	return block->first_free;
>  }
> @@ -388,11 +389,11 @@ static void pcpu_next_md_free_region(struct pcpu_chunk *chunk, int *bit_off,

I feel like these iterators would naturally line up with struct
pcpu_region. I do understand though a this would be a big change for
more of the code. It's probably worth just leaving this for now and
cleaning it up in a future patch / series.

>  		 * the next block and should be handled by the contig area
>  		 * across blocks code.
>  		 */
> -		*bits = block->contig_hint;
> -		if (*bits && block->contig_hint_start >= block_off &&
> -		    *bits + block->contig_hint_start < PCPU_BITMAP_BLOCK_BITS) {
> +		*bits = block->contig_hint.size;
> +		if (*bits && block->contig_hint.start >= block_off &&
> +		    *bits + block->contig_hint.start < PCPU_BITMAP_BLOCK_BITS) {
>  			*bit_off = pcpu_block_off_to_off(i,
> -					block->contig_hint_start);
> +					block->contig_hint.start);
>  			return;
>  		}
>  		/* reset to satisfy the second predicate above */
> @@ -437,19 +438,18 @@ static void pcpu_next_fit_region(struct pcpu_chunk *chunk, int alloc_bits,
>  		}
>  
>  		/* check block->contig_hint */
> -		*bits = ALIGN(block->contig_hint_start, align) -
> -			block->contig_hint_start;
> +		*bits = ALIGN(block->contig_hint.start, align) -
> +			block->contig_hint.start;
>  		/*
>  		 * This uses the block offset to determine if this has been
>  		 * checked in the prior iteration.
>  		 */
> -		if (block->contig_hint &&
> -		    block->contig_hint_start >= block_off &&
> -		    block->contig_hint >= *bits + alloc_bits) {
> +		if (block->contig_hint.size &&
> +		    block->contig_hint.start >= block_off &&
> +		    block->contig_hint.size >= *bits + alloc_bits) {
>  			int start = pcpu_next_hint(block, alloc_bits);
>  
> -			*bits += alloc_bits + block->contig_hint_start -
> -				 start;
> +			*bits += alloc_bits + block->contig_hint.start - start;
>  			*bit_off = pcpu_block_off_to_off(i, start);
>  			return;
>  		}
> @@ -604,17 +604,16 @@ static inline void pcpu_update_empty_pages(struct pcpu_chunk *chunk, int nr)
>  
>  /*
>   * pcpu_region_overlap - determines if two regions overlap
> - * @a: start of first region, inclusive
> - * @b: end of first region, exclusive
> - * @x: start of second region, inclusive
> - * @y: end of second region, exclusive
> + * @a: first region
> + * @b: second region
>   *
> - * This is used to determine if the hint region [a, b) overlaps with the
> - * allocated region [x, y).
> + * This is used to determine if the hint region [a.start, a.start + a.size)
> + * overlaps with the allocated region [b.start, b.start + b.size).
>   */
> -static inline bool pcpu_region_overlap(int a, int b, int x, int y)
> +static inline bool pcpu_region_overlap(struct pcpu_region a,
> +				       struct pcpu_region b)
>  {
> -	return (a < y) && (x < b);
> +	return (a.start < b.start + b.size) && (b.start < a.start + a.size);
>  }
>  
>  /**
> @@ -629,56 +628,54 @@ static inline bool pcpu_region_overlap(int a, int b, int x, int y)
>   */
>  static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  {
> -	int contig = end - start;
> +	struct pcpu_region free = { .start = start, .size = end - start };
>  
> -	block->first_free = min(block->first_free, start);
> -	if (start == 0)
> -		block->left_free = contig;
> +	block->first_free = min(block->first_free, free.start);
> +	if (free.start == 0)
> +		block->left_free = free.size;
>  
> -	if (end == block->nr_bits)
> -		block->right_free = contig;
> +	if (free.start + free.size == block->nr_bits)
> +		block->right_free = free.size;
>  
> -	if (contig > block->contig_hint) {
> +	if (free.size > block->contig_hint.size) {
>  		/* promote the old contig_hint to be the new scan_hint */
> -		if (block->contig_hint && start > block->contig_hint_start) {
> -			if (block->contig_hint > block->scan_hint) {
> -				block->scan_hint_start =
> -					block->contig_hint_start;
> +		if (block->contig_hint.size &&
> +		    free.start > block->contig_hint.start) {
> +			if (block->contig_hint.size > block->scan_hint.size) {
>  				block->scan_hint = block->contig_hint;
> -			} else if (block->scan_hint &&
> -				   start < block->scan_hint_start) {
> +			} else if (block->scan_hint.size &&
> +				   free.start < block->scan_hint.start) {
>  				/*
> -				 * The old contig_hint == scan_hint.  But, the
> -				 * new contig is larger so hold the invariant
> -				 * scan_hint_start < contig_hint_start.
> +				 * The old contig_hint.size == scan_hint.size.
> +				 * But, the new contig is larger so hold the
> +				 * invariant scan_hint.start <
> +				 * contig_hint.start.
>  				 */
> -				block->scan_hint = 0;
> +				block->scan_hint.size = 0;
>  			}
>  		} else {
> -			block->scan_hint = 0;
> +			block->scan_hint.size = 0;
>  		}
> -		block->contig_hint_start = start;
> -		block->contig_hint = contig;
> -	} else if (contig == block->contig_hint) {
> -		if (block->contig_hint_start &&
> -		    (!start ||
> -		     __ffs(start) > __ffs(block->contig_hint_start))) {
> -			/* start has a better alignment so use it */
> -			block->contig_hint_start = start;
> -			if (block->scan_hint &&
> -			    start < block->scan_hint_start &&
> -			    block->contig_hint > block->scan_hint)
> -				block->scan_hint = 0;
> -		} else if ((block->scan_hint &&
> -			    start > block->scan_hint_start) ||
> -			   block->contig_hint > block->scan_hint) {
> +		block->contig_hint = free;
> +	} else if (free.size == block->contig_hint.size) {
> +		if (block->contig_hint.start &&
> +		    (!free.start ||
> +		     __ffs(free.start) > __ffs(block->contig_hint.start))) {
> +			/* new start has a better alignment so use it */
> +			block->contig_hint.start = free.start;
> +			if (block->scan_hint.size &&
> +			    free.start < block->scan_hint.start &&
> +			    block->contig_hint.size > block->scan_hint.size)
> +				block->scan_hint.size = 0;
> +		} else if ((block->scan_hint.size &&
> +			    free.start > block->scan_hint.start) ||
> +			   block->contig_hint.size > block->scan_hint.size) {
>  			/*
> -			 * Knowing contig == contig_hint, update the scan_hint
> -			 * if it is farther than or larger than the current
> -			 * scan_hint.
> +			 * Knowing new contig size == contig_hint.size, update
> +			 * the scan_hint if it is farther than or larger than
> +			 * the current scan_hint.
>  			 */
> -			block->scan_hint_start = start;
> -			block->scan_hint = contig;
> +			block->scan_hint = free;
>  		}
>  	} else {
>  		/*
> @@ -686,12 +683,11 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  		 * the scan_hint if it is larger than or equal and farther than
>  		 * the current scan_hint.
>  		 */
> -		if ((start < block->contig_hint_start &&
> -		     (contig > block->scan_hint ||
> -		      (contig == block->scan_hint &&
> -		       start > block->scan_hint_start)))) {
> -			block->scan_hint_start = start;
> -			block->scan_hint = contig;
> +		if ((free.start < block->contig_hint.start &&
> +		     (free.size > block->scan_hint.size ||
> +		      (free.size == block->scan_hint.size &&
> +		       free.start > block->scan_hint.start)))) {
> +			block->scan_hint = free;
>  		}
>  	}
>  }
> @@ -741,8 +737,8 @@ static void pcpu_block_update_scan(struct pcpu_chunk *chunk, int bit_off,
>   * Iterates over the metadata blocks to find the largest contig area.
>   * A full scan can be avoided on the allocation path as this is triggered
>   * if we broke the contig_hint.  In doing so, the scan_hint will be before
> - * the contig_hint or after if the scan_hint == contig_hint.  This cannot
> - * be prevented on freeing as we want to find the largest area possibly
> + * the contig_hint or after if the scan_hint.size == contig_hint.size.  This
> + * cannot be prevented on freeing as we want to find the largest area possibly
>   * spanning blocks.
>   */
>  static void pcpu_chunk_refresh_hint(struct pcpu_chunk *chunk, bool full_scan)
> @@ -751,14 +747,13 @@ static void pcpu_chunk_refresh_hint(struct pcpu_chunk *chunk, bool full_scan)
>  	int bit_off, bits;
>  
>  	/* promote scan_hint to contig_hint */
> -	if (!full_scan && chunk_md->scan_hint) {
> -		bit_off = chunk_md->scan_hint_start + chunk_md->scan_hint;
> -		chunk_md->contig_hint_start = chunk_md->scan_hint_start;
> +	if (!full_scan && chunk_md->scan_hint.size) {
> +		bit_off = chunk_md->scan_hint.start + chunk_md->scan_hint.size;
>  		chunk_md->contig_hint = chunk_md->scan_hint;
> -		chunk_md->scan_hint = 0;
> +		chunk_md->scan_hint.size = 0;
>  	} else {
>  		bit_off = chunk_md->first_free;
> -		chunk_md->contig_hint = 0;
> +		chunk_md->contig_hint.size = 0;
>  	}
>  
>  	bits = 0;
> @@ -781,14 +776,13 @@ static void pcpu_block_refresh_hint(struct pcpu_chunk *chunk, int index)
>  	unsigned int start, end;	/* region start, region end */
>  
>  	/* promote scan_hint to contig_hint */
> -	if (block->scan_hint) {
> -		start = block->scan_hint_start + block->scan_hint;
> -		block->contig_hint_start = block->scan_hint_start;
> +	if (block->scan_hint.size) {
> +		start = block->scan_hint.start + block->scan_hint.size;
>  		block->contig_hint = block->scan_hint;
> -		block->scan_hint = 0;
> +		block->scan_hint.size = 0;
>  	} else {
>  		start = block->first_free;
> -		block->contig_hint = 0;
> +		block->contig_hint.size = 0;
>  	}
>  
>  	block->right_free = 0;
> @@ -834,7 +828,7 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  	/*
>  	 * Update s_block.
>  	 */
> -	if (s_block->contig_hint == PCPU_BITMAP_BLOCK_BITS)
> +	if (s_block->contig_hint.size == PCPU_BITMAP_BLOCK_BITS)
>  		nr_empty_pages++;
>  
>  	/*
> @@ -848,18 +842,13 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  					PCPU_BITMAP_BLOCK_BITS,
>  					s_off + bits);
>  
> -	if (s_block->scan_hint &&
> -	    pcpu_region_overlap(s_block->scan_hint_start,
> -				s_block->scan_hint_start + s_block->scan_hint,
> -				s_off,
> -				s_off + bits))
> -		s_block->scan_hint = 0;
> -
> -	if (pcpu_region_overlap(s_block->contig_hint_start,
> -				s_block->contig_hint_start +
> -				s_block->contig_hint,
> -				s_off,
> -				s_off + bits)) {
> +	struct pcpu_region s_region = { .start = s_off, .size = bits };
> +

I'd prefer to create the struct when we're creating s_off above.
bits here is also a bit overloaded. We aren't setting hints so it's not
wrong, but I wonder if we should clamp bits to be within the block.

> +	if (s_block->scan_hint.size &&
> +	    pcpu_region_overlap(s_block->scan_hint, s_region))
> +		s_block->scan_hint.size = 0;
> +
> +	if (pcpu_region_overlap(s_block->contig_hint, s_region)) {
>  		/* block contig hint is broken - scan to fix it */
>  		if (!s_off)
>  			s_block->left_free = 0;
> @@ -878,7 +867,7 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  	 * Update e_block.
>  	 */
>  	if (s_index != e_index) {
> -		if (e_block->contig_hint == PCPU_BITMAP_BLOCK_BITS)
> +		if (e_block->contig_hint.size == PCPU_BITMAP_BLOCK_BITS)
>  			nr_empty_pages++;
>  
>  		/*
> @@ -893,12 +882,12 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  			/* reset the block */
>  			e_block++;
>  		} else {
> -			if (e_block->scan_hint &&
> -			    e_off > e_block->scan_hint_start)
> -				e_block->scan_hint = 0;
> +			if (e_block->scan_hint.size &&
> +			    e_off > e_block->scan_hint.start)
> +				e_block->scan_hint.size = 0;
>  
>  			e_block->left_free = 0;
> -			if (e_off > e_block->contig_hint_start) {
> +			if (e_off > e_block->contig_hint.start) {
>  				/* contig hint is broken - scan to fix it */
>  				pcpu_block_refresh_hint(chunk, e_index);
>  			} else {
> @@ -911,8 +900,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  		/* update in-between md_blocks */
>  		nr_empty_pages += (e_index - s_index - 1);
>  		for (block = s_block + 1; block < e_block; block++) {
> -			block->scan_hint = 0;
> -			block->contig_hint = 0;
> +			block->scan_hint.size = 0;
> +			block->contig_hint.size = 0;
>  			block->left_free = 0;
>  			block->right_free = 0;
>  		}
> @@ -927,24 +916,18 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  	if (nr_empty_pages)
>  		pcpu_update_empty_pages(chunk, -nr_empty_pages);
>  
> -	if (chunk_md->scan_hint &&
> -	    pcpu_region_overlap(chunk_md->scan_hint_start,
> -				chunk_md->scan_hint_start +
> -				chunk_md->scan_hint,
> -				bit_off,
> -				bit_off + bits))
> -		chunk_md->scan_hint = 0;
> +	struct pcpu_region req_region = { .start = bit_off, .size = bits };

Similarly, I think I have a preference for this to be created up top.
Maybe call the first one s_block_region and then this one chunk_region.

> +
> +	if (chunk_md->scan_hint.size &&
> +	    pcpu_region_overlap(chunk_md->scan_hint, req_region))
> +		chunk_md->scan_hint.size = 0;
>  
>  	/*
>  	 * The only time a full chunk scan is required is if the chunk
>  	 * contig hint is broken.  Otherwise, it means a smaller space
>  	 * was used and therefore the chunk contig hint is still correct.
>  	 */
> -	if (pcpu_region_overlap(chunk_md->contig_hint_start,
> -				chunk_md->contig_hint_start +
> -				chunk_md->contig_hint,
> -				bit_off,
> -				bit_off + bits))
> +	if (pcpu_region_overlap(chunk_md->contig_hint, req_region))
>  		pcpu_chunk_refresh_hint(chunk, false);
>  }
>  
> @@ -1000,8 +983,8 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
>  	 * or end of the block.
>  	 */
>  	start = s_off;
> -	if (s_off == s_block->contig_hint + s_block->contig_hint_start) {
> -		start = s_block->contig_hint_start;
> +	if (s_off == s_block->contig_hint.size + s_block->contig_hint.start) {
> +		start = s_block->contig_hint.start;
>  	} else {
>  		/*
>  		 * Scan backwards to find the extent of the free area.
> @@ -1015,8 +998,8 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
>  	}
>  
>  	end = e_off;
> -	if (e_off == e_block->contig_hint_start)
> -		end = e_block->contig_hint_start + e_block->contig_hint;
> +	if (e_off == e_block->contig_hint.start)
> +		end = e_block->contig_hint.start + e_block->contig_hint.size;
>  	else
>  		end = find_next_bit(pcpu_index_alloc_map(chunk, e_index),
>  				    PCPU_BITMAP_BLOCK_BITS, end);
> @@ -1038,9 +1021,11 @@ static void pcpu_block_update_hint_free(struct pcpu_chunk *chunk, int bit_off,
>  		nr_empty_pages += (e_index - s_index - 1);
>  		for (block = s_block + 1; block < e_block; block++) {
>  			block->first_free = 0;
> -			block->scan_hint = 0;
> -			block->contig_hint_start = 0;
> -			block->contig_hint = PCPU_BITMAP_BLOCK_BITS;
> +			block->scan_hint.size = 0;
> +			block->contig_hint = (struct pcpu_region){
> +				.start = 0,
> +				.size = PCPU_BITMAP_BLOCK_BITS,
> +			};
>  			block->left_free = PCPU_BITMAP_BLOCK_BITS;
>  			block->right_free = PCPU_BITMAP_BLOCK_BITS;
>  		}
> @@ -1314,8 +1299,9 @@ static int pcpu_free_area(struct pcpu_chunk *chunk, int off)
>  
>  static void pcpu_init_md_block(struct pcpu_block_md *block, int nr_bits)
>  {
> -	block->scan_hint = 0;
> -	block->contig_hint = nr_bits;
> +	block->scan_hint = (struct pcpu_region){ .start = 0, .size = 0 };
> +	block->contig_hint =
> +		(struct pcpu_region){ .start = 0, .size = nr_bits };
>  	block->left_free = nr_bits;
>  	block->right_free = nr_bits;
>  	block->first_free = 0;
> @@ -2141,7 +2127,7 @@ static void pcpu_reclaim_populated(void)
>  			 * (first) page in the chunk.
>  			 */
>  			block = chunk->md_blocks + i;
> -			if (block->contig_hint == PCPU_BITMAP_BLOCK_BITS &&
> +			if (block->contig_hint.size == PCPU_BITMAP_BLOCK_BITS &&
>  			    test_bit(i, chunk->populated)) {
>  				if (end == -1)
>  					end = i;
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 

Thanks for taking on this work!

I'm a little torn on this though. This patch leaves the pcpu_region in
kind of a mixed state. I think largely it's fine because it definitely
cleans up pcpu_block_update() to better set hints based on regions
rather than on start, size pairs.

I do have a few nits that I would like fixed though. Maybe skip the
iterators for a different patch or future update though.

Thanks,
Dennis

