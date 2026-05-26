Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9ABACD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03CD66B0005; Tue, 26 May 2026 02:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F307B6B0088; Tue, 26 May 2026 02:33:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1EF56B008A; Tue, 26 May 2026 02:33:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB8B26B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:33:57 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B3231202C8
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:33:57 +0000 (UTC)
X-FDA: 84808605714.09.FEE76F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id A6F2F140010
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:33:55 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EzQ9eDH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u2IrXYs7DczBXOabIUF34kYQAn6UG03Kfsz/edIgftU=;
	b=6LZvCx/j94DMRUVHaesJVDeUOgOktKKWvhA6Hc8SG7ncFo0hCE7+SoOQ/TFIwHL6Z83keG
	Gxo42uzLjcIBboIk2VlPa9l3qV0rePx5MTQxtkt+yxyOQoh6wCAGEc5qEbrB3U1lNDwuO7
	mN45SjhH8bumYi7zgdGDLNgvR0n3H6s=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EzQ9eDH2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of dennis@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dennis@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777235; a=rsa-sha256;
	cv=none;
	b=0ZGkH66YpZVq+lB15OYiY+ez09ZMM0iWD0Ouc0MRw/okPDF5DLLB/3+3bTeEtD6vxtA8dA
	41tj7FjoROpURaA3n34r+6F0uUp5dI2+J8Guak1ufGjOd3RHxmByoY5nVpqRHFxOyWzWiT
	CrqDaOLAHo0lxAaCmFQH3QO38AhgR7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DF4D444036;
	Tue, 26 May 2026 06:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE61E1F000E9;
	Tue, 26 May 2026 06:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779777234;
	bh=u2IrXYs7DczBXOabIUF34kYQAn6UG03Kfsz/edIgftU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EzQ9eDH2mXsWEtQfTYNMBbUfsy7DCcP29xZqhdB/2WspVLPe7Dg3FuMPVR0RHIDtc
	 aa2eeiQijsEPhnENTCYFUCZpnlaMXd4tL0N2oztNZYAsYXd9bt55Oztzeb9So59YhS
	 oTCTLQC9k/CoIW0p6v/BDKDJPNftFS6ZACdZg3pfSwcCKlFqDSS8CGdhH0iyfsbBEf
	 GXXGGp9oJ7avCcSDq4x1brk05YmkmeBG1FQHK8zmyafy36sWlitp/t+ARYhHPoayGs
	 +O+QUMncvBvEBTIsEHm1zm/Bxu+nUnRtmYhnrFaUO8Yhb4fYF694Udx12qmxl0n3gI
	 yZu76VhbiSd5A==
Date: Tue, 26 May 2026 08:33:49 +0200
From: Dennis Zhou <dennis@kernel.org>
To: Joonwon Kang <joonwonkang@google.com>
Cc: dennis@kernel.org, tj@kernel.org, cl@gentwo.org,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, dodam@google.com
Subject: Re: [PATCH v6 2/4] percpu: Do not trust hint starts when they are
 not set
Message-ID: <ahU-zWnLIJ4XP0c9@palisades.local>
References: <20260513085117.1024175-1-joonwonkang@google.com>
 <20260513085117.1024175-2-joonwonkang@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260513085117.1024175-2-joonwonkang@google.com>
X-Stat-Signature: 9k969ut1hgp45neqwx36jsucx1bq94xr
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A6F2F140010
X-Rspam-User: 
X-HE-Tag: 1779777235-78345
X-HE-Meta: U2FsdGVkX1+gNcqo/5F9wx/vWCfdZrnZPwQ7YG/DKfuehWUUCo0dIuKo0V0jAfFateW75JNBrjxJG3ZJfB8UjfVi89gIVewWsfFD84TFtOEsBZalBtkAoDBZRJLsaIP29lb0rL6pAjKpBWyw6x+r084uWnO9RibNcpSsFgAgxpsINRo8DyZ1xLy6eur3E1R1ipOwc5TuUS49U3bQrFqi7p/2wjjDWn7bwQNKUpT0/xvw1EgLlNLIK4QhT9uAlgQU2WSpb5dEdOUId+SsoMc0Q540BTAKqYQLF8cdQOsak2UCUa1waA+P7zU/5o4ss/hF2UbTjhNU4eeXrjPI85inaDzoIoLCVKSiCbZdHz+WNwpFFDarXuCajepjfl6tbHLu1CF95yPPkddeSoVQdHny5EuJED2N2l+G8rTVfCYvAeWcsX1BfK2TRN5l1AU1/mmPSHk3BasaixaBmLAQHPf8kP5OT+5n4TuHc++6OCb6j+3Ba64j43G3ewFTckMbIMyQa7zu7wYnb/J3pNDXY5ROot43LpRicSXt0+THxqcUFpr2jJ6iffj1bkVIXjJLejPoCmm6sFOMMn2v53zQGlcc43tmmqf6+3MdLYfo5UgAsuEbyhbr2AIAJuLCChArgEF8Hs+Jx1XGPkFm3BoWrh9EPMWMqNV9brgLIKuAJ0XrehqZTjA6JGl7nYdE1Q30O2lTbPJ/EDCcGmyBH+wRpq55CVnUElhLiDNul8yhybsmytvJa0ALHb77fuvehlLpkMbP5ee51sp3DfBF0QhGyJ2kd8RX1oAM8TI1q4AJPegpm3m03nKPeeFXtu18hAI/Z2kTx9J6eDCAvH0I+Xrr2RrOBRXZwM3PAbARl8F/ywo1c8BDwmTgHHY6hqufujsFYQvDb6wo0oQPzglC2ImUQe6k+v8gSXNSkRcexuTWREYJ8gqKb+Bj8b8KovyYoeDmmzd51PtRzU+25vc9nkfPyJB
 HalFN3w/
 V9ujQ9Ba+TN2/UCazabRo+vVD+onMxNn9dPuX8Tvyi8EOfOXUk2tAyhWTiYiZeLsLO/cK+3QMbi+VChvthokrvBCc3azj1na5zb0lpa3H66Xfv+qEKRVIowI0rfNDPuE1PfGxM1iWsqEkH1vBwIc3DMs4V2UTmCYhUQNCfLDq07HYcyPPvhWZ+eU4Qk7wjXvYAG6mHKr+u8J+Ibuam2KZv5C4ZYhK7ggnFyADxZcHPpNJpXRdThZj4f+BhaJpE1vMBQSMfo0EqLVOSHOwpwUf3d8kP+Dngsa0uc14
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 08:51:14AM +0000, Joonwon Kang wrote:
> contig_hint_start can be trusted outside the hint update function since
> it will be updated everytime contig_hint is broken. On the other hand,
> scan_hint_start might still be invalid anywhere in the code due to the
> broken scan_hint not being updated promptly. If those starts are trusted
> when they are not set, it could lead to false invalidation or update of
> the hints.
> 
> Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> ---
> v5-v6: No change.
> v4: Remove the separate contig_hint == 0 case and handle the case in the
>     following code. Add more checks for scan_hint.
> v3: Initial version.
> 
>  mm/percpu.c | 20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/percpu.c b/mm/percpu.c
> index 3ecd86096641..0f6dd5260f56 100644
> --- a/mm/percpu.c
> +++ b/mm/percpu.c
> @@ -640,12 +640,13 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  
>  	if (contig > block->contig_hint) {
>  		/* promote the old contig_hint to be the new scan_hint */
> -		if (start > block->contig_hint_start) {
> +		if (block->contig_hint && start > block->contig_hint_start) {
>  			if (block->contig_hint > block->scan_hint) {
>  				block->scan_hint_start =
>  					block->contig_hint_start;
>  				block->scan_hint = block->contig_hint;
> -			} else if (start < block->scan_hint_start) {
> +			} else if (block->scan_hint &&
> +				   start < block->scan_hint_start) {
>  				/*
>  				 * The old contig_hint == scan_hint.  But, the
>  				 * new contig is larger so hold the invariant
> @@ -664,10 +665,12 @@ static void pcpu_block_update(struct pcpu_block_md *block, int start, int end)
>  		     __ffs(start) > __ffs(block->contig_hint_start))) {
>  			/* start has a better alignment so use it */
>  			block->contig_hint_start = start;
> -			if (start < block->scan_hint_start &&
> +			if (block->scan_hint &&
> +			    start < block->scan_hint_start &&
>  			    block->contig_hint > block->scan_hint)
>  				block->scan_hint = 0;
> -		} else if (start > block->scan_hint_start ||
> +		} else if ((block->scan_hint &&
> +			    start > block->scan_hint_start) ||
>  			   block->contig_hint > block->scan_hint) {
>  			/*
>  			 * Knowing contig == contig_hint, update the scan_hint
> @@ -845,7 +848,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  					PCPU_BITMAP_BLOCK_BITS,
>  					s_off + bits);
>  
> -	if (pcpu_region_overlap(s_block->scan_hint_start,
> +	if (s_block->scan_hint &&
> +	    pcpu_region_overlap(s_block->scan_hint_start,
>  				s_block->scan_hint_start + s_block->scan_hint,
>  				s_off,
>  				s_off + bits))
> @@ -889,7 +893,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  			/* reset the block */
>  			e_block++;
>  		} else {
> -			if (e_off > e_block->scan_hint_start)
> +			if (e_block->scan_hint &&
> +			    e_off > e_block->scan_hint_start)
>  				e_block->scan_hint = 0;
>  
>  			e_block->left_free = 0;
> @@ -922,7 +927,8 @@ static void pcpu_block_update_hint_alloc(struct pcpu_chunk *chunk, int bit_off,
>  	if (nr_empty_pages)
>  		pcpu_update_empty_pages(chunk, -nr_empty_pages);
>  
> -	if (pcpu_region_overlap(chunk_md->scan_hint_start,
> +	if (chunk_md->scan_hint &&
> +	    pcpu_region_overlap(chunk_md->scan_hint_start,
>  				chunk_md->scan_hint_start +
>  				chunk_md->scan_hint,
>  				bit_off,
> -- 
> 2.54.0.563.g4f69b47b94-goog
> 

Reviewed-by: Dennis Zhou <dennis@kernel.org>

Thanks,
Dennis

