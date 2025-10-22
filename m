Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3238ECCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 01:25:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562858E0003; Tue, 21 Oct 2025 21:25:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5392E8E0002; Tue, 21 Oct 2025 21:25:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 476248E0003; Tue, 21 Oct 2025 21:25:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38C668E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 21:25:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB6EA5A5E9
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:25:18 +0000 (UTC)
X-FDA: 84024007116.26.86E52A0
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf07.hostedemail.com (Postfix) with ESMTP id 57EC44000B
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:25:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=w6L5g+CS;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761096317; a=rsa-sha256;
	cv=none;
	b=v3ESJ2sxorLimL1wEFPCq3+JrEJJYNiUfT+9scxaDk0cffjL6tfsOGexlBZI7QhtDJNjXc
	PiGRMJUsR7MaItVvF5Ohrsg+lRCCuHknCv+bVhOH9YBIVnT3aQlWIRhGKR9Y48kwo1j6Hi
	VJSticBNIhQvf38eGBeGKuhQwsd8/bA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=w6L5g+CS;
	spf=pass (imf07.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761096317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mMBGLFybuvXPMK2gINIMRD6FATE14CDq9nXmqTlEp6I=;
	b=7PWJCww5SkveXbH/jr5mN5sb1BYonH2MBsc8zWsPbpNJ7vA5NPgDyDw103U/ZyL49qABmT
	55hsAXzv17v9nnTYjcautssLjmCsCckN0t73nxO0fzM1zwi69MqNuCLXvq2Q7SmeZ6dur3
	USUJWKPQFvt8vj1HpavnmWyfLPjc/Kk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1761096312; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=mMBGLFybuvXPMK2gINIMRD6FATE14CDq9nXmqTlEp6I=;
	b=w6L5g+CSpDmTK0lGQZ8vQhX9tSx4IrSWgy/kHQT0Ps0qtuwwu9xjodx7533htnW0Kicq8G3d9vtvU4ZlanxrVS/SaRXUQEJn4/8peBzsqr8WQzLKKYQkkqlTCA1qn1jZmVXuvM8f7LBOQlHxy3IiHE2L2Et03Z6X3E7jhWsxWas=
Received: from 30.74.144.127(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WqkgTKQ_1761096310 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 22 Oct 2025 09:25:10 +0800
Message-ID: <65f4dd0b-2bc2-4345-86c2-630a91fcfa39@linux.alibaba.com>
Date: Wed, 22 Oct 2025 09:25:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shmem: fix THP allocation size check and fallback
To: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins
 <hughd@google.com>, Dev Jain <dev.jain@arm.com>,
 David Hildenbrand <david@redhat.com>, Barry Song <baohua@kernel.org>,
 Liam Howlett <liam.howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Mariano Pache <npache@redhat.com>, Matthew Wilcox <willy@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
 stable@vger.kernel.org
References: <20251021190436.81682-1-ryncsn@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20251021190436.81682-1-ryncsn@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: s1ax9oshz534tnr948uugumszeaainhs
X-Rspamd-Queue-Id: 57EC44000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1761096314-231224
X-HE-Meta: U2FsdGVkX18OtSuUjvS8NmobRbXCwQZBEX5VEO1XV1KzxfWv6VkAlqEKLpDb0ADsFdq2xuryO9FDTgwC28LrWBP/No8W1afOEZeSHZvhsZz78YYkgNH8xPLz1BW8h9mOcUAfD683kkjcXFSY/TUW89TeC/vUAVVnOAqawhPdnW8edfSb3ekf0u8NcNqeH3QPc61CEE6aRvKAo55aNV78efb2kdG2+jJa8UciPM3ofyUkk2kga3faqb/EWQ/umtzSuB21hBZwR5/h0Bem8+3O04fvYOyus9Te4jf5gh/IvQ/zG0R2u7xelSgk9COL9+S+HlPnBe5H/bqIKZWM2+Rg4HyEhP4oRoA09P7Um9Ok1hOB/4qWytz9SHSR7YmcGPSXx6vvtRI5DbO1PKc4IpZ2e4wuEBttNrUomufrrQTfKtxlPkeoNC27d7yWPJFvZnN+FUe+rRChfO48v/yJcynVKOFXz/Xke5hw7+BE+DDAtAawYLlwxJE/riqHyQa0k/nqNFk3wJxhhGgAn5Q6YIqHqr9pQrog14aPPzu9/OlHrysUt57OqnGD8jMAAO/0o78JpXulnvK6OG4YUApTlpL1L4DgdHQJoIS6e1lgO/DCWHQoB+n+hsu6b/S/j5FqSaoe4ArQ+ubwXD/EHb5AvQkl/o69x2jjQvBLrO7P6Xcdzti5Gvh3oEpC+d1W6WpBBEgD4d6/Iw8AvYmP/0mJBeUzSLqLAoOSyTpeAbD/TR4Yuj7LQqGSb+DEDLjr4mf/Bl7KG0adcxZqjZceo7Z9dHaNeQ16WVuLu1D2fzIb1l1feke2ekIjou+kI6VTrjJSozzdT6PBZ5PGAYQA605nRrV6lQcaBYqCK69sM+wqaysyGkS/RIS5ROAya3n4vRCb1Pyl3hmvr3FNPdMs0A4FL0D26tSi18UjTHaLm10JHihrUhmK28IyY9abDSj2alQGp8asqG0KfYgAGNZaQPQ/OxM
 0aJK6G0V
 z7ZTPClTYVz5PlbP7y/nqnk8jWMh/bBmUlSZ0mWe5xmA3EWakbqXqqryb+hSBWSykn47gXIUMZUFrERz837DbuQC7/Z1lnm9WsCAewVkxBAKYu+4q4pH5oOJSFu1buHb1a2G6BA8c3JA+SG9chDdZnIPKxc1EIygZg1G9OqgrfLj/c2HGMZ0FsVtUDU9VU1aeemApB3WtR/hq7cFy3j63kNdbjF/r5WlFrjtDyO4EkT8YtZbcq7u2zCEMxKs3ar4woliiF0jI1WoBKeOB2SEaxGFf8Yvast2Oa1UNcVraEha3ssCWuyvhvh7jI/kr6Gg8hXFARnkXM1UVU9tNQhfsrbPMruVB3GwSM4doLMXDKkcJWsDrFo6VgAyNuWPh5j2ke2BPDp4yW3B3DTMeM1zEOJIdx18mJmsALiZO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/22 03:04, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> There are some problems with the code implementations of THP fallback.
> suitable_orders could be zero, and calling highest_order on a zero value
> returns an overflowed size. And the order check loop is updating the
> index value on every loop which may cause the index to be aligned by a
> larger value while the loop shrinks the order. 

No, this is not true. Although ‘suitable_orders’ might be 0, it will not 
enter the ‘while (suitable_orders)’ loop, and ‘order’ will not be used 
(this is also how the highest_order() function is used in other places).

> And it forgot to try order
> 0 after the final loop.

This is also not true. We will fallback to order 0 allocation in 
shmem_get_folio_gfp() if large order allocation fails.

> This is usually fine because shmem_add_to_page_cache ensures the shmem
> mapping is still sane, but it might cause many potential issues like
> allocating random folios into the random position in the map or return
> -ENOMEM by accident. This triggered some strange userspace errors [1],
> and shouldn't have happened in the first place.

I tested tmpfs with swap on ZRAM in the mm-new branch, and no issues 
were encountered. However, it is worth mentioning that, after the commit 
69e0a3b49003 ("mm: shmem: fix the strategy for the tmpfs 'huge=' 
options"), tmpfs may consume more memory (because we no longer allocate 
large folios based on the write size), which might cause your test case 
to run out of memory (OOM) and trigger some errors. You may need to 
adjust your swap size or memcg limit.

> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
> Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   mm/shmem.c | 26 +++++++++++++++-----------
>   1 file changed, 15 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b50ce7dbc84a..25303711f123 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1824,6 +1824,9 @@ static unsigned long shmem_suitable_orders(struct inode *inode, struct vm_fault
>   	unsigned long pages;
>   	int order;
>   
> +	if (!orders)
> +		return 0;
> +
>   	if (vma) {
>   		orders = thp_vma_suitable_orders(vma, vmf->address, orders);
>   		if (!orders)
> @@ -1888,27 +1891,28 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
>   	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>   		orders = 0;
>   
> -	if (orders > 0) {
> -		suitable_orders = shmem_suitable_orders(inode, vmf,
> -							mapping, index, orders);
> +	suitable_orders = shmem_suitable_orders(inode, vmf,
> +						mapping, index, orders);
>   
> +	if (suitable_orders) {
>   		order = highest_order(suitable_orders);
> -		while (suitable_orders) {
> +		do {
>   			pages = 1UL << order;
> -			index = round_down(index, pages);
> -			folio = shmem_alloc_folio(gfp, order, info, index);
> -			if (folio)
> +			folio = shmem_alloc_folio(gfp, order, info, round_down(index, pages));
> +			if (folio) {
> +				index = round_down(index, pages);
>   				goto allocated;
> +			}
>   
>   			if (pages == HPAGE_PMD_NR)
>   				count_vm_event(THP_FILE_FALLBACK);
>   			count_mthp_stat(order, MTHP_STAT_SHMEM_FALLBACK);
>   			order = next_order(&suitable_orders, order);
> -		}
> -	} else {
> -		pages = 1;
> -		folio = shmem_alloc_folio(gfp, 0, info, index);
> +		} while (suitable_orders);
>   	}
> +
> +	pages = 1;
> +	folio = shmem_alloc_folio(gfp, 0, info, index);
>   	if (!folio)
>   		return ERR_PTR(-ENOMEM);
>   


