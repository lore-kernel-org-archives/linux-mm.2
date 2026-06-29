Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A46FC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E53C26B0116; Mon, 29 Jun 2026 11:46:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E04D16B0118; Mon, 29 Jun 2026 11:46:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3C16B011A; Mon, 29 Jun 2026 11:46:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A44446B0116
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:46:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 30E151C1223
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:46:05 +0000 (UTC)
X-FDA: 84933376290.17.8651870
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5AB12140012
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:46:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOcfRTWH;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782747963;
	b=KDy190sa7cnTZl+bgaFl2Hn1UpN2G2IueZVwCunoKY8t1h1fsCMhRDpjwX3ro+xFCNjQxR
	0jss9jj97txpx0SvUmdybwFUSmslIisK8RT0bMU78SzM8XBs66aXOUNgTCjQp0QonHgJjS
	iDaG/RwxUofi8i4qcc2CPy96HCXc+/Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782747963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rcv2RxtWUWTiigOPYDDb1ssV6G9BRJJaq8Db0fWs3gM=;
	b=r3km72Vv74QbrsIYzDt/y6x3Q2Lkozt+oniJMcmfUdVcuTGIysUmA+3kUoA5f5GfB/K4qm
	Ro3yfm9HdNY7Ze1hi7Zr0MsK1MudPxHQNiLIyvSmDdY2YncvlSWBAof/z3nnKFyw/aQMqM
	V2ePHL0hbsJMmzB0UNTCYn49oO0MRno=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JOcfRTWH;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD9E5600AB;
	Mon, 29 Jun 2026 15:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6441F000E9;
	Mon, 29 Jun 2026 15:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782747962;
	bh=rcv2RxtWUWTiigOPYDDb1ssV6G9BRJJaq8Db0fWs3gM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=JOcfRTWHJm/3jF/b3uPIQzimWZj113YlyYt7Hh61eWZnoUke4a84tktogPSgZVnfT
	 kpsjHlRM2SNah4uCquVI8Khe7FCsvk2duo18qICtoA/dBT0IfwEmlWFFO9oZn7BrYc
	 I0yysOMScB5WnqDlbB3g7EYzZhGHkh8dQtYs5un6cOi5oDxBYxPOC674vSVV2ZDyCB
	 3TYi9VrLWB/Fj9tr4UOU/9mhhZ/8yMWGygkwuXQLVNi2jm+YseHyqmrBnb/DU0CO4Y
	 6FTDM9Y6ox4F7CCK9p5e3TaceD+EJ1QoyQc+nEfv0DSC53iegTYFLB+LLVo9an7oja
	 n5xPXoBoVTb4Q==
Message-ID: <8b74962d-8dcd-42c9-bf97-7d6b83b52c84@kernel.org>
Date: Mon, 29 Jun 2026 17:45:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/page_alloc: remove set_page_private() in
 prep_compound_tail()
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260628-keep-subpage-private-zero-at-free-v1-0-f4ce3930d10f@nvidia.com>
 <20260628-keep-subpage-private-zero-at-free-v1-4-f4ce3930d10f@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260628-keep-subpage-private-zero-at-free-v1-4-f4ce3930d10f@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 3k4r73qypgtxbayqxsx9ffqi6agopr44
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5AB12140012
X-HE-Tag: 1782747963-292954
X-HE-Meta: U2FsdGVkX1/SciC8YR2AFSsFvtITzGWE8bZJ7mtHjXhLzHFj+YrZi/wGPcBxrCu0rctCUW0+Vj8JsYettW+K9BH7GhW4omEiNr8LoV0qbsJeBFcSHb/QyODskPSLfKB+pnmC54P3OT/m68sU8wtNPoYMZKW/scA2ALrolfIgZ3wko9tZ1eGSW+RPC9JS9qo2ey6ftSEqKOgGNSZnLWWkdPq4b99uBhLUxYxr3LZ5vrhSJGZ297Tn/tnYJosvYGjqLXgzLyJT0Gsi/XAS1KnwULRM3nP88y4mN2zxK/kZ2JoCE3OIIj7DLkHR78+DgEa2idRunbqbaajX9Qc6ElYH6JVGbRkvacPkymNV/8OiQmM3eB0pca39rgcU5ZCds0eZ9aA+4LcqRorqEHiIP8yOXzenmaF6tYChA4kxbuvU+Ahi8gZUepIsTH++NCsCHoQ46y2hyLW3Q99YZhEqXhn5+9O5Q1686jeNw4ZxcXR4UBOo+xDPg/BNwI6YRBHNKTzdLQAMGPD2V4HwintTfa5O+pFMuOZPOjYfvUgGogUTVQrx8peufP+Oltu9/rs4dIEb8/Sk6rtj4XFSIwg3t/dourk4981QpmL00NNyl6QHRPBNuGnskqP3FcZwyyjMczKpqXaXD9FhClMO7nAcZvoCXZd+AMdTppGlmxn76U9gOK2HJSWWY2eN7BaClqxrWc7Bi6a+8tRc1xjEJvcaTQzLx74G3KXxeFDe/D4ZcSdLUJi7xIrTbpv7jCRN9vQ3rS6p7Lx5b7/uaDRB2cdgx5Q5NHDQebbVFhwq9fR4Kb399WSotnpZREFFtFsRXZJfu7cOVUal6JSVMh8jO0DbvqQ9G3J+c6P6tcrnEptuICkVEkkZP4XFlKvJjVyr1xO+/cNM6I31aFQudOJSiYcdXrZIo1hAvIwzukdzdkAQQ3jXYvWAOCWSIf5sOq8PGvdm5amiDt3cz/evlBu9Yery9dh
 OdqC7huq
 Ro4E4NtFKY+6gsLGlmYmcmTSyuZWobeV7OmwLtm0dr9PbdnmjBGCNT4VXdhhf2vWCaKrhoH0Rrs1NdnCDnfN/xgeSh2D5cc+7J45mBo+j8Uk09rUbx/r5GeQ4PJbcuFo6jJa2HrmTkAxksx5+xhDAHLktqbBJ6ZJv/FKZbi8FMhysW9pS7wqZmw2t3WCOCUljHGTUoQ3yuJt6pRHRLGduSCB7OA4T3M1rg4GH7k+gv+hmYNq+AIMaBdQERmCDkgEQYUhkpaJUE7bw1Pv9nyXOROTyiLcMZAV1QMwxg6R+cPeYYP4TqEV530Ne7VYjqz0eetEL4o4G0naRxP7eJ1IdiySxLHRbwKfXQPXQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 04:56, Zi Yan wrote:
> With the subpage->private == 0 check added in a prior commit, any allocated
> compound page should not have nonzero subpage->private. Remove the

(not "subpage")

I think the sentence would be more precise if it said that we now expect
(and optionally check) tail pages to have zero ->private when they are
freed, so we can rely on that still being true during subsequent reallocation.

(and if the buddy allocator itself sets it to non-zero due to split/merge of
buddy pages, it will reset it to zero as well as appropriate, but maybe that
doesn't need spelling out)

> unnecessary subpage->private initialization code in compound page
> preparation.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/internal.h | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 181e79f1d6a2..c96421ce9350 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -895,7 +895,6 @@ static inline void prep_compound_tail(struct page *tail,
>  {
>  	tail->mapping = TAIL_MAPPING;
>  	set_compound_head(tail, head, order);
> -	set_page_private(tail, 0);
>  }
>  
>  static inline void init_compound_tail(struct page *tail,
> 


