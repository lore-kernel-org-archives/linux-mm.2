Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2510ACAC59A
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 03:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45D478E0006; Sun, 21 Sep 2025 23:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435288E0001; Sun, 21 Sep 2025 23:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34AAF8E0006; Sun, 21 Sep 2025 23:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DD8A8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 23:19:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A66CE1A043D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:19:12 +0000 (UTC)
X-FDA: 83915430144.20.8507574
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE6A41A0005
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 03:19:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JWXFAQpM;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758511151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z1xv7n2dNrf1sQprqQNalsEEZ9e1L86/2wWKLGMKTYE=;
	b=35IOQt1UMk5f2SAtGRM3n1wzqpA6lElfKOBwbMZ5bn+p1Mspq/w8QHbQcrxocLZUSsV87r
	2x8G+Oomot+BP3HLPiFkYU9SllyOSHgfe9lUhAfAesOQWgD6rBWX/dxKXqKzESwuiRX+L2
	WzkcbIJgFoIiUmiojSSsTjj1N15ObXk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758511151; a=rsa-sha256;
	cv=none;
	b=Qlb9f96lUTcpKPyB2bMWQSy9LIuR7sPuRcA2795YO8KSVLqNGezee2Etd8QQ9jiRuvSaWt
	2/GCtT2cooj3Fb7bj2e11ScZx67V7R3r/lt4OYHzUfFKTLd/rVOk5tAKXKcixMSqrWQ3Dy
	YujccKBLaO5zeOfxWML4KpPAdDnRMhg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=JWXFAQpM;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1758511147; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=z1xv7n2dNrf1sQprqQNalsEEZ9e1L86/2wWKLGMKTYE=;
	b=JWXFAQpMC2t9tmtlU7NDsydDhHNdpI9NN9o7YQRmU2EiyCzcNLnDMnm1gxKRkO75SSeOXfE3UV7cBdfD6o8Qvs4qAkqo4ulpKj3EC3661Zr6CW1cBB9DO6kJZcUv0I5hK4hkqZR8yrHT/wv+mLIZq4dTipoq5LZXFhHvPKk1IEg=
Received: from 30.74.144.144(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WoR4wP2_1758511144 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 22 Sep 2025 11:19:05 +0800
Message-ID: <ddb7a9f8-5516-4bf2-8bd7-3761f133bc6b@linux.alibaba.com>
Date: Mon, 22 Sep 2025 11:19:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2 4/5] mm/fault: Try to map the entire file folio in
 finish_fault()
To: Kiryl Shutsemau <kirill@shutemov.name>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, Hugh Dickins <hughd@google.com>,
 Matthew Wilcox <willy@infradead.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20250919124036.455709-1-kirill@shutemov.name>
 <20250919124036.455709-5-kirill@shutemov.name>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250919124036.455709-5-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DE6A41A0005
X-Stat-Signature: o4p4ohp5k3jwp6urxuks3h5b9g7r1xzn
X-Rspam-User: 
X-HE-Tag: 1758511149-882101
X-HE-Meta: U2FsdGVkX199WbENRTUabl6AP0kdnB8UP6K6+McpaH1pPw63v4QvMzr3scx2lBrBMG0Xo8yd2KsHpqKe4iU+GUs7rDHywON2dFbi+v2Q8sNtdsGPN1bFFtIXDqAteo69rahPr0mjXQBWyVB/+dBh7radiOsOvgNoXCG56JMgQFYPzyDUceXTH34UX5WWY/83vonsyhBom4vBFCmkD4BJyCQKY/xLFjIURqZrWnHgAvKHZri1FgS8Dsyl7HGlc3Jaqz59DHCihwApTxePL/usUiobXFrivj2Y67Fx2yq8IULDROr8YXkbkTYiB/Sgi5uq3FEMMGQrC/f334K7xNY/q+csZO/Ts0/njDGAJE+TvHxH8tTx545BYwFXHd77EU9xZuZ6gPJoRbJivpMVBll/9YL6TZ030dz+ax9oDjWMNYb4fgmgTvRaooAGyO2J031vQctyTyx8QhaLVwnVUPjaOqbz18M1RO/AtSIjcIEvEoRpSx5RpeCLROmILdsfIDFqFlu+vmOGzf/fkBkZLwWcq2KU00puJsnvH1l2VhD1Rm2sTXfssrwzf53bY4LY/Vnw6bTHOShPVvyZYFFAmvJkntuQZb9v5tmx92+QEZhWs6OO5u/KXR8B5K8n5uab7VTfUStFd9GIKDsQV9joOA/qBVb27oQC331A9P53M7qgSTeirle2yqN6o27gxLbwg7FGMqRGaVXiEwfFcn2AA+YtiPpkchn5g3yqSapdJ+KEkMEYxcBmL6MaIqtY9KWQOYBNnXU6203OiNQmHKjwZXO0UflKjKzpgfEkym9rjFJPKp3t7fG/JucGHDHU/Se0pe7S7IBtNczuCXqABJPopd7euDbaVNsp7oX1tFG7l3KW8Y53xLux5rqvlgUccrc96DE0tV7d7xYg3sNZwjOLhFvnr+HJxblA1j/tx7NJoQeYQzjr1P8njMAZvyhfM2sTtQQOUg04pnfnxUo+AhKA0fx
 gkBU3LLF
 l/4OUFnyH0Lo1cARFGvrkbO8radKQ6LvD7GJtuGbp7d1cID/gPBeqR+mPNzsELiP3FGWUpXI1N9wrG8wo+m323i+Ut2zFsbdZawZUecm/6srJONGICFgm3hvsI98w+PwG5m42ev+xFz/zqqt64eDyIwd9rh75M/Yz1spcmmrgQSzCEiD8ORfFM3FQoLjFQEvRjMzn9OhSIW5GisXy3G/hkV6XHBywj345vqMmdE1/UdDANMTycBuVhgmvhLd0wqq/cF0836BxvSnDfNwgjfvXn2xuJKQP4p3ZspkC7n5NpszvmN+IuoZelqzxbw5buuUYF2ic6EL1Ak+2orOYd3cBQfeJFH8rVzI/EJscJWq/V4aA2YZEnMn+mgyorg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/19 20:40, Kiryl Shutsemau wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> The finish_fault() function uses per-page fault for file folios. This
> only occurs for file folios smaller than PMD_SIZE.
> 
> The comment suggests that this approach prevents RSS inflation.
> However, it only prevents RSS accounting. The folio is still mapped to
> the process, and the fact that it is mapped by a single PTE does not
> affect memory pressure. Additionally, the kernel's ability to map
> large folios as PMD if they are large enough does not support this
> argument.
> 
> When possible, map large folios in one shot. This reduces the number of
> minor page faults and allows for TLB coalescing.
> 
> Mapping large folios at once will allow the rmap code to mlock it on
> add, as it will recognize that it is fully mapped and mlocking is safe.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

LGTM. Thanks.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

>   mm/memory.c | 9 ++-------
>   1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0ba4f6b71847..812a7d9f6531 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5386,13 +5386,8 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
>   
>   	nr_pages = folio_nr_pages(folio);
>   
> -	/*
> -	 * Using per-page fault to maintain the uffd semantics, and same
> -	 * approach also applies to non shmem/tmpfs faults to avoid
> -	 * inflating the RSS of the process.
> -	 */
> -	if (!vma_is_shmem(vma) || unlikely(userfaultfd_armed(vma)) ||
> -	    unlikely(needs_fallback)) {
> +	/* Using per-page fault to maintain the uffd semantics */
> +	if (unlikely(userfaultfd_armed(vma)) || unlikely(needs_fallback)) {
>   		nr_pages = 1;
>   	} else if (nr_pages > 1) {
>   		pgoff_t idx = folio_page_idx(folio, page);


