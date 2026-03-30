Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0D231061B05
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:41:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45A3B6B00A8; Mon, 30 Mar 2026 10:41:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 431816B00A9; Mon, 30 Mar 2026 10:41:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 347B66B00AA; Mon, 30 Mar 2026 10:41:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 22C206B00A8
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:41:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF4298C15D
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:41:08 +0000 (UTC)
X-FDA: 84602991816.08.4A1EDEB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5081F14000C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:41:07 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ovkJLNeU;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ovkJLNeU;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774881667; a=rsa-sha256;
	cv=none;
	b=391LhyST9TbtMRn+eqXXJdNJkmTR+HDOBwlaL32h3ymumGEx3hZHz5j+qpzpk6FL4NR/AU
	awhOda0cPng46Y5A1JuoAhGUGlY5wGZH6qSVUbbZ6Znj5kDbuVLwkntxLfQqZu61DCusOv
	aqotZaCPNUwieqRcmOvySCN+GCJ9goU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774881667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=enynDUZrtMhGqKyV6X0I9lridgZlq7xPmjN8IrAI9oI=;
	b=dd6vFaevckI0L4YK8WUIjQAPkNwQEly+iPrfvBAFL8JE0ly5Te1xclLjrmwDcVQKwHAWke
	jn/txNdWGhCqTvNZpOg6E4SNlJBOJUoDyi2dSkCA3jjXiIoVMOsiqIKO06kzHnjxQ7C0JL
	mrq3DhHtHWv5CTrkIZJq9044UwWhVYM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B5256600CB;
	Mon, 30 Mar 2026 14:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7D04C19423;
	Mon, 30 Mar 2026 14:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774881666;
	bh=r8gBVMIG5Tt1MRP52sdyrMptt1JIP8UGDqO4QDt0jTE=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=ovkJLNeUr84JiMtcI+5WAr2G8F9gn2hqEyL/gCPmtpLtQ6gvn7uHEmPCINHpwdSq1
	 KHmm4LGAWVuLRn0b7szwZPb57qduv9hEYOqeFWt4CLxELU8w4Htq+jCRTm2Nr8spiM
	 1c15EVpJovbdySZ8d9sjru/hyJX/3TakNznuSl9W/VkqqkzkFz//amHfdNGpP0K0Yn
	 kb5OvZeE0vjs++B7E2w4qcWgwlfQmiwuKD/zm3yFho6Bl2m1lPU8XzBhK4OdMQVVu2
	 TQp1+E+ZOWdO0voZ2Sh9Q86tCe36AY0ehu8bdV8/rQS+Wx35deYr69l9mRTH8nFVbj
	 bKU6gxTjQibvA==
Message-ID: <ff7c26b2-0714-47da-b3e1-785e62391cb8@kernel.org>
Date: Mon, 30 Mar 2026 16:41:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm/page_alloc: Optimize
 __free_contig_frozen_range()
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Uladzislau Rezki <urezki@gmail.com>,
 Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>,
 Vishal Moola <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260327125720.2270651-1-usama.anjum@arm.com>
 <20260327125720.2270651-4-usama.anjum@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260327125720.2270651-4-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5081F14000C
X-Stat-Signature: q735nyjru15asgqxio4jm4ff157rebca
X-Rspam-User: 
X-HE-Tag: 1774881667-345762
X-HE-Meta: U2FsdGVkX19wAojdKFXLUh1uT7lI5NbamQIwiWZ42aL+eXFLlQzpk6zDdYB+taTFmbjeTvO/5gh7O2FLz3219/ydw8BVcP3ngu0De4gfv/j4U3iCK0Ev2C0J7cXDwfM9FDtiZTVpxDaN3Bm6ksBnlTMHDfm2IH02UtY6Vo3Mgwv8J0Cbn7muwMGowFbkKC3R+OLw8L8jmzKqiWwEGPVLi4u/M8e9KkeWENXek1xZOk/xzYwg7jySijL+yLuA1w8j6syXvU9Vf8HglP939g0D2oZ8S8vSZ354RacOGhsdMaHNuCYn4wgmrrRiH292jKvvtQKmvZxpY7njuTyhsTGiB4ySiU/EZjc4UC+GMDyDmT4P47WWTzcXxNgxPk0wRbFaonVSDitJw1RS8h4Dp+t8H0z6YMtLZ02DTva0E45isOCKohaswFzuqg+/1yfzSfKUXkH4Q8rp7lctYUMcjjeHgpqi6kZqv7OK27AAg8tXPvI9p/uFrsFbU7SkOD/VHxkr3vDhw9djK1GGOkdgkpqYtcWA5RvqT5Hq7Jv3Z+VEFm0O48MRw9RvHaP146LPjWTr+uXxUZuXZCH7U5USH0OTzR1OYD5A3wtjgKIvekTM+2jgxKlXpfmcJzXq60T8QrgXkOftfg34yq81I994S9BJyYUeBGuP/CfoUKgiU71u/DWoBVPsGuKQPc1OmrXzLFbokT0LIWIo0kjFTq/aKOxMUSj/wttroVZjekKdP4BlCW9ds719+BOVlmuIPZinY5Kwb/T6AWgG5OvtNh49ba8h+fxH4G19KWE2pXwIx4s1tDWpqO/q7MMFzs8uxyTjnuOqfiOv8Vgv3HjXqBrwcKmEJGQGSH8QzHMTXRTN/VQmqmGUVJUVdVHwmO09r4AvCr9fow71qKF9mo92K6KHKyMq+GBdYH0NJDQBZoH3H1W5m1Q5mU5TRBKts6TsxH2fxaInen0TyO+NTBc0scEIInc
 fQpPk4Z6
 ix9RivHIYv7zEM5kuwcG+t503vtsGjivH23zjEAGup/0DxMu5ApBVk2o6T5dK2yafAeG6WzOf7EPF60M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 13:57, Muhammad Usama Anjum wrote:
> Apply the same batch-freeing optimization from free_contig_range() to the
> frozen page path. The previous __free_contig_frozen_range() freed each
> order-0 page individually via free_frozen_pages(), which is slow for the
> same reason the old free_contig_range() was: each page goes to the
> order-0 pcp list rather than being coalesced into higher-order blocks.
> 
> Rewrite __free_contig_frozen_range() to call free_pages_prepare() for
> each order-0 page, then batch the prepared pages into the largest
> possible power-of-2 aligned chunks via free_prepared_contig_range().
> If free_pages_prepare() fails (e.g. HWPoison, bad page) the page is
> deliberately not freed; it should not be returned to the allocator.
> 
> I've tested CMA through debugfs. The test allocates 16384 pages per
> allocation for several iterations. There is 3.5x improvement.
> 
> Before: 1406 usec per iteration
> After:   402 usec per iteration
> 
> Before:
> 
>     70.89%     0.69%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
>             |
>             |--70.20%--free_contig_frozen_range
>             |          |
>             |          |--46.41%--__free_frozen_pages
>             |          |          |
>             |          |           --36.18%--free_frozen_page_commit
>             |          |                     |
>             |          |                      --29.63%--_raw_spin_unlock_irqrestore
>             |          |
>             |          |--8.76%--_raw_spin_trylock
>             |          |
>             |          |--7.03%--__preempt_count_dec_and_test
>             |          |
>             |          |--4.57%--_raw_spin_unlock
>             |          |
>             |          |--1.96%--__get_pfnblock_flags_mask.isra.0
>             |          |
>             |           --1.15%--free_frozen_page_commit
>             |
>              --0.69%--el0t_64_sync
> 
> After:
> 
>     23.57%     0.00%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
>             |
>             ---free_contig_frozen_range
>                |
>                |--20.45%--__free_contig_frozen_range
>                |          |
>                |          |--17.77%--free_pages_prepare
>                |          |
>                |           --0.72%--free_prepared_contig_range
>                |                     |
>                |                      --0.55%--__free_frozen_pages
>                |
>                 --3.12%--free_pages_prepare
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v3:
> - Use newly introduced __free_contig_range_common() as the pattern was
>   very similar to __free_contig_range()
> 
> Changes since v2:
> - Rework the loop to check for memory sections just like __free_contig_range()
> - Didn't add reviewed-by tags because of rework
> ---
>  mm/page_alloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 64be8a9019dca..110e912fa785e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7059,8 +7059,7 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>  
>  static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
>  {
> -	for (; nr_pages--; pfn++)
> -		free_frozen_pages(pfn_to_page(pfn), 0);
> +	__free_contig_range_common(pfn, nr_pages, true);

Ah, might want to add a comment here as well

	/* is_frozen= */ true

-- 
Cheers,

David

