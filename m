Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9B8ACD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF0E6B0088; Mon,  8 Jun 2026 08:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39F956B008A; Mon,  8 Jun 2026 08:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B6B76B008C; Mon,  8 Jun 2026 08:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1B5DF6B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:18:28 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B26AFC34EB
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:18:27 +0000 (UTC)
X-FDA: 84856648254.01.09C49AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 065A94000D
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:18:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fhx34/wY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780921106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4bq7322kWx6CdkqZCl5t40hKw6vHtvbzE6Il0jH62XQ=;
	b=GmEBb/tHDBtd0kQWoeULwqrd3JZMVRXfGnQCeFjmmJzCcjFd932SfvVeWTZ++gEaE0uyp3
	fFn4jFs6ef6csxgMjWWLFREHJ3e1WS9JAohJiEuZ244NOtykn3sRlGoTF/DOhGt0DXou5g
	z7Vd32flKdn26cYmJNDwA90bqrnFr0Y=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fhx34/wY";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780921106;
	b=G3/y8a8PqpHwp+ukxjBhYBFe0JRu4rosBkX2OGBKkQa1xdIA9WV0vLC+wfs74OtGoBvBKB
	hOSftcur1EZjLJfkQf9N2QIzgQu68fy8EJgMLhdZcICwNW8cnCJBojFbVfFVJuNprbtArf
	tTnB8d8fKNF6mUCCLwTTcwh361qHaSY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F2FD42ABC;
	Mon,  8 Jun 2026 12:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 544311F00893;
	Mon,  8 Jun 2026 12:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780921105;
	bh=4bq7322kWx6CdkqZCl5t40hKw6vHtvbzE6Il0jH62XQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fhx34/wYyi4qTtqk4QuiP7p33JtlGJpEvv3WVDq4OHpVAN/F67imxKA0NQ0PqHEOO
	 ShQSTE81rARoCwQ9cNRunKxJJ84J+2QO2PhgO/o+PyUyavv7Yst3B14CC7xOqqUZGZ
	 M63vkmttzEJG3+GVuoNTTyrYgclFhpFN3cFQhCxmosN3QKE78i6tIT++nSeHN5PKO/
	 1qzSKEBjkThQMvqNYdB7dYV/Ar8pPs/LlN7E3nYNn96yANKRBbtcyed3o2rbmtMT3v
	 NVdQXSbpCvQ5WhFx0fz4IKTeueDE8+W+Bi+L0den+inJc3U9pCC/5TBx2D0YYS/yFA
	 CMUS8qxjqs+aQ==
Date: Mon, 8 Jun 2026 13:18:12 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 23/37] mm: page_alloc: skip kernel_init_pages for
 FPI_ZEROED when safe
Message-ID: <aiawax1SS7x4_DEi@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <7de6959a0fb1b255dc9bee2de494f51a6c21e468.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7de6959a0fb1b255dc9bee2de494f51a6c21e468.1780906288.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 065A94000D
X-Stat-Signature: z1pxx5xpj3s6bar5f5kj7urcyf8jxccj
X-HE-Tag: 1780921105-209846
X-HE-Meta: U2FsdGVkX19s5eGusHxAJVp08z4vDCLpEa4kN7vp8PAGoRVqrQDZ/lBFiV+e4GRcF5kRBgPDVb4Oa9jS+nbYUJEx1gFEQeZF0VzcnvGdEV83ilodOzB1Y+CjXcUHx+LVLVacfNjrOorPJlJYEhER68ozD/+EahasQdoRrm2mBTFnYym8ftFKAz47Q6EULw5zaCW2CDfzONF0csOiwT6C/G5k7Pa1eEtYvw5v0QGCNwRyQ0YUEtQchAT9gQBTbkwbSBgbNNZprsgiRu4VpwxeyWGTHu6svRyxk43JfgzDtEzIrtogdL1Jf6MkgHiGMLDZiSSE//6p8UEZANfyP9rE8i3YORCCuxZNgjiQUq1VG42+8XjlLdZeMl4DNxtalD09G2kEguUvLdm9rlD65SDDLFLuKwGrFU9UK2zDvPuMUbIYORz2ZM9YiG5sILljSNecl+XzUN35ptz58xK5HLVdA0MU2sBDqqz+sfWPn1gj+Ygm6M49f7JGX813bq41C/fHrhtrCQLFejbpO7z/TcrgOoQPUOQzBUnwFYPLIKoCh6rYzCGcQospzvmhqchbJYmm5O5wpeXfCDHM/Z+NtgCRd7UcSEXagaIOXPhxSsDBHHRGdBylb5VIXp3m5z6LZmWp5HgmYO88Vc9WRJHSvF0GslMOOpnZhYLnfl30yFdvF0VZGeAgczH7q4Xmii74ydx5KJ0gTtPrl4toxv02dxF3PilLVECeQXre6ISBlv2yhTxE6AhSnRgnSlpsXLzHt0Fvjhdbz6pZ4unMZmZ91opLjuMYfE9ZFGgagpkzlYF4hkPlYp6Oeouy4Wle3O+XRkRENCHRR4a3D4HCukTIqG1ULIMMM61SDZLP+/dxWn7axHG55dPrXIbmRJZ4Rr8Y0PKBBf5BC1LrqeZISl4xnHzfUiIZZJHOSm1e7jglsVrsmSwM7KV9svL9EnKgOQELWoht1fDvDoCXJC/YQ4HFTLE
 r8ob50Ko
 knv25e2kxN38AKENzGu7A8MWBKsiWBaHhktXxCVgyccPiTDa08KajEGRwL3SbJ2JVc5PY30T7swOhXdRfVvtW2pnqbkkJZFqwn1vDSXPZ0cMfel3HMNOV4wjfzUy3qu30bbsohWvLJR6nULDEObfVQNm1qcnAlbi23vFeo7owrgmXDj1KqSaJ8RYveDJxu4oOT+JHTNo5OAGhLkDwCQ5SgDLpX1RcP8nSJWNKZiZK0jCIxumQGk4yLN6gs12jGKZt7Ntu3kPi3rzHEKXwkwporCS0nQJQlBGnIR77lzAmedbWtbRIKKqfOIvnQOnvpdZFqEn6ykMEfgsvkquSF8p8N5fMzCoYJJsRu31fSpx7vx8b5OSde3RP/H+QfntDFMP9LSFJCDTNAHLynDfeRU+Gr9/5fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:38:46AM -0400, Michael S. Tsirkin wrote:
> In __free_pages_prepare(), when FPI_ZEROED is set the page is already
> known to be zero. We can skip kernel_init_pages() if page poisoning is
> not enabled (because poison would overwrite the zeroes).
>
> This avoids redundant zeroing work when freeing pages that are already
> known to contain all zeros.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  mm/page_alloc.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 008f1a311c40..e3a7c40c769c 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1443,7 +1443,14 @@ __always_inline bool __free_pages_prepare(struct page *page,
>  		if (kasan_has_integrated_init())
>  			init = false;
>  	}
> -	if (init)
> +	/*
> +	 * Skip redundant zeroing when the page is already known-zero
> +	 * (FPI_ZEROED) and page poisoning did not overwrite it.
> +	 * When page_poisoning is enabled, kernel_poison_pages above
> +	 * wrote PAGE_POISON (0xAA), so we must re-zero.
> +	 */

Again, please stop specifying arbitrary hex values in comments, this seems
mostly 'describing what we do here'.

Maybe drop to just e.g.:

/* if poisoned or not zeroed by a virtualised host, zero now. */

or suchlike?

> +	if (init && !((fpi_flags & FPI_ZEROED) &&
> +		      !page_poisoning_enabled_static()))

This condition is absolutely horrible, !(X && !Y), you're making life difficult
for the readers.

'if not both zeroed and not poisoned' is how that reads logically. Which is hard
to understand.

De Morgan's law gives us -> !zeroed || posioned

How about:

	if (init && (!(fpi_flags & FPI_ZEROED) || page_poisoning_enabled_static())

Or preferably something like:

	const bool poisoned = page_poisoning_enabled_static();
	const bool vm_host_zeroed = fpi_flags & FPI_ZEROED;

	...

	if (init && (poisoned || !vm_host_zeroed))
		...

?


>  		kernel_init_pages(page, 1 << order);
>
>  	/*
> --
> MST
>

Thanks, Lorenzo

