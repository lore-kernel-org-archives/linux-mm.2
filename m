Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21887C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 00:17:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9846C6B0088; Tue, 28 Jul 2026 20:17:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934AF6B008A; Tue, 28 Jul 2026 20:17:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851336B008C; Tue, 28 Jul 2026 20:17:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6790F6B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:17:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CAF7B803D5
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:17:14 +0000 (UTC)
X-FDA: 85039899588.16.D1E4A93
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1CFF6A0011
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 00:17:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NorZHzN9;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785284233;
	b=BTtbS7s+TaG2/jiGHclhgu2YwBZfM5UeQ3X1GJlLvQ8+x97KzMr/raMol3qS2IyBaZ9E/D
	a10MasEFlIc8w4x4s19PB6w/b9ibVF4qcxXug/1JLbifTkvEEsrjcZ40x0Xdxe1KuYZpqH
	9ClUl204hGKJWh8DmNgmu12Nl5Y9VyA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NorZHzN9;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785284233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WrRa98Mp/atYIONxnPxZqx0DdLUbpJpuwe1g02aeyAQ=;
	b=Ep5/d+/o44W4bccz8FrGltDUb6Q1ToJ4I/dekyPFN7NRjN4h2Q9peRgecZU7hsPCwQoYw5
	IcKz3cpyqj+Fh2dIo6rESj/4ZXhvLsukmpvK2HcwyHMZCZ0bKrrLVIdgi3AEyoHRrcN2sw
	dmBhgAV7axixQwcOWs5e9yoC0mPe2Jg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C639260A6C;
	Wed, 29 Jul 2026 00:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 000081F000E9;
	Wed, 29 Jul 2026 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785284231;
	bh=WrRa98Mp/atYIONxnPxZqx0DdLUbpJpuwe1g02aeyAQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NorZHzN9psCu1CZnNbJfKVXqkf1EQWsigxlnlqTi0HMHs8B5E1hg7Pq9f+7+kxGhP
	 hJpry06tkKI9ByiZs9Y6UkpaurRy+q3UxpG8D6eqADcZXWBYrMtftUDsJAe2vHC4dy
	 4UX6Tfi/l7dalCJh3jwae8Ii21MLI1xCj59nSjTo=
Date: Tue, 28 Jul 2026 17:17:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry
 Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, Usama Arif
 <usama.arif@linux.dev>, <linux-mm@kvack.org>,
 <linux-kernel@vger.kernel.org>, Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH] mm/khugepaged: cap min_free_kbytes recommendation at 1
 GiB
Message-Id: <20260728171710.a968591ceea5782270dffcee@linux-foundation.org>
In-Reply-To: <20260728202014.2517142-1-noren@nvidia.com>
References: <20260728202014.2517142-1-noren@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1CFF6A0011
X-Stat-Signature: fp3px94eqx4n4ocfqyqqn54bgq1acn9p
X-Rspam-User: 
X-HE-Tag: 1785284232-436526
X-HE-Meta: U2FsdGVkX194iGkskuvNDMWz+LIhOPIg9qxNC6BIMqo3dF4O7XRRMZA0EEnzyuirgTqL/c7rtib+Yu3IhZOvfRzoWbXQk1OOXJ6BelYXxTEnWGQ8mjGtk6djDW+Jc2iFUC+u07CEU+OLV1NHe7lVwXvbfZiD7sIcTrF8UGKjditJnmK/tYYvseRjsMrABgCSkIabOE/oW29iopimsPCfTcjjfGU2d5/WhvQcim+jOj/KnPM8CDk/KHyhg8K6/nz5vlKLnBsQi5rcDtZ9+WCx9yiz0nr0lTRZ4XY6fi3aVsHh/vl5t3baUTgA5XDav2Nk+wwuy59bCjwgsTZGFL7+ZsRhBe8XEhVP1s2NEvhrMWG3yjOxGje7P40YcrBc+n7eDl82AGK+zMlOxoUYhgiEWGD3VFQdeJzv2WGi4uZrmltgfSOgPenNvETKeIJupOD+eZxyx8B/j+NpSYg3EJnGY5JeZvwc/L7CGJLkTJVyIxwVT9aI881x9jQTK5YtXZ4+5YT2aIuWdW7LXGpGLXnzN/10LqLoApgF+PRzyTpfHqQxW9ymZ8fuDUREzQ6c4H74L5AkeYPDkxx0skQWKMUOsdTQmfx4FyghDKcmDTUac995wFjZHfbXkUG6hFvbmJIWc9jg+0bv63CqVCL+zrlvWiK+hIeqIUZHMRySHzFpADcrJvT2+dhaSLUvOOquEUS/hKCPGv3p1MHuardhX9IrHSEpp4ThFb5Wdyy86dvXzrFcLn/j7cdk2M1LtwVqLppctPUDCSNA0Sp3D+PcOEcj8e2Z0el67PHyukm46+SxMRgnOmYksebvrvCAFfEB11gEuOoRkFuEGQBN9+jBXuiOcOY89e8IM54amb3/bkVrhHuQ5QeNm639SdcfBf5cmgG8vZanGTpc1um2d7qi7rhTuL+N8fgWvFz7O2QNdrjs9R5kSFStJc7gd+4zRVAWgEtSwwta/IgDPYDnHzsGKP9
 cY7mA3mT
 8c2dkIfHKr2eaSg0Nlb8HFoIx9Y0rtE38L5Whkx9xi1yc8lnKxdvQz3H/xx0THaXw9ei5eZl+BNifAtoDjsumdvIBs3Yo7Dj/xIy9V/zB++XrFet/Xb0oPiKqbvut0YuOjCSR/2ZtqGiFw61Zw+7OtRp3pQgVg1dr8PUU8XmSOWEtmB+fZH8XQGVa3TbGxh0sr8l2FfGa0AXHNet9D+DVsK8iPTz67yQH5RHKOYJWc+uRNii/F3fTMZRQD4E7up8/OaI7IrXH+IhygFDNEoP9pqus1MYucUqxeldLC7MWm/XQAgKTDu6IYtVPmyPexgH+qN4h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Jul 2026 23:20:14 +0300 Nimrod Oren <noren@nvidia.com> wrote:

> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
> pageblocks for every eligible populated zone before capping the result
> at 5% of low memory.
> 
> This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
> configurations, but scales poorly with larger base page sizes. With
> the default arm64 pageblock sizes, the contribution per eligible zone
> before the 5% cap is:
> 
>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> 
> Consequently, min_free_kbytes can reach excessive and unwanted levels.
> 
> Add an absolute 1 GiB cap to the recommendation, in addition to the
> existing percentage cap. This bounds the automatic recommendation to a
> sane value on systems with large pageblocks while preserving existing
> behavior for typical systems with 2 MiB pageblocks.

Another hard-coded number isn't pretty :(

>  mm/khugepaged.c | 7 ++++++-

Now, why is a page-allocator function sitting in khugepaged.c?

Perhaps to avoid a #ifdef CONFIG_TRANSPARENT_HUGEPAGE.

Or perhaps so that page-allocator maintainers don't get cc'ed on
page-allocator patches ;)

> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 27e8f3077e80..d9caf10e05b5 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -23,6 +23,7 @@
>  #include <linux/ksm.h>
>  #include <linux/pgalloc.h>
>  #include <linux/backing-dev.h>
> +#include <linux/sizes.h>

Why this?

>  #include <asm/tlb.h>
>  #include "internal.h"
> @@ -3096,9 +3097,13 @@ void set_recommended_min_free_kbytes(void)
>  	recommended_min += pageblock_nr_pages * nr_zones *
>  			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
>  
> -	/* don't ever allow to reserve more than 5% of the lowmem */
> +	/*
> +	 * Don't ever allow to reserve more than 5% of lowmem or 1 GiB,
> +	 * whichever is smaller.
> +	 */
>  	recommended_min = min(recommended_min,
>  			      (unsigned long) nr_free_buffer_pages() / 20);
> +	recommended_min = min(recommended_min, SZ_1G / PAGE_SIZE);
>  	recommended_min <<= (PAGE_SHIFT-10);
>  
>  	if (recommended_min > min_free_kbytes) {

Is a min_free_kbytes documentation update needed? 
Documentation/admin-guide/sysctl/vm.rst.

