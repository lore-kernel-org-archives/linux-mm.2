Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B389C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 15:16:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 291BC6B0099; Tue,  8 Sep 2026 11:16:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242B36B009B; Tue,  8 Sep 2026 11:16:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 131066B009D; Tue,  8 Sep 2026 11:16:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DBE966B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:16:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 669EBA074D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:36 +0000 (UTC)
X-FDA: 85190946792.18.AE16EEB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90315180017
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 15:16:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788880594;
	b=PvOhx/nGP+LqJ7MhD+B4HNQdqbGZO6ahkFJJepils22rDbrlqRtYkcvA9PCcEZ+Ds4wKd9
	CKa8nWpwPNofvfbDczCnMY+AV2AlKhaUZTJ92s9enK4FlZvAFaUYq+mFRN86pGa1d1kIuY
	uFrK5iZ/MyPa/bSUTDSr+e5X1G/0KeM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=none;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788880594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8yHLq3RvqtdNHUaXQ1bxGbj1cSsC+//PVXrbKsrfw1I=;
	b=KvV6gCQ/smTfb5IgtQAxHB283hl+CXr1rG63Qm2+f9x6PVq3CkHZixLNUzQCdToWXkI4n/
	PCNJ27Eh66rWNZjayXbGKEYMdDTZBWuL149dMOSdlJE1mo2g/evfDFuna5ZznDAccWSWcO
	/GgWpmlvXcuM3Cy2ctUjFh8VS8UHOXs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 67B3542E3B;
	Tue,  8 Sep 2026 15:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2F2B1F00A3A;
	Tue,  8 Sep 2026 15:16:24 +0000 (UTC)
Message-ID: <fb8ab0ac-87b8-44ea-87d2-006a7a7569f1@kernel.org>
Date: Tue, 8 Sep 2026 17:16:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 03/14] xen/grant-table: stop setting PG_private on
 pages for grant mapping
To: Zi Yan <ziy@nvidia.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Juergen Gross <jgross@suse.com>, Stefano Stabellini
 <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 xen-devel@lists.xenproject.org
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-3-6ae22f9d9272@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907-remove-pg_private-v3-3-6ae22f9d9272@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90315180017
X-Stat-Signature: ws41xtcwa7ndpgq9tmnnykrpr63g6xdb
X-HE-Tag: 1788880594-347017
X-HE-Meta: U2FsdGVkX18MLJdDd0LMtGNEDVHlfCHDRuV4K1cizQVv8fdgyo2+oWz/r3RFhaP/MadNdQK9ZV34WkSdHTtQL+nw3m10aqQ4RtGFHXt3/2MImb+8EG6ERYRjXtEriWFxm0woPvMwgu1Ud/EMeZm+8ABC8LuOvEXQ37LNyvgtim5nCsOH3F+N6m3euVK/53moM6Rouu7RFHAnwXE7nKCgCqubIyb45dH6UBM+gAF6tIylXYKC27ScR68WXh+hzirmTawM8TXR7fMyl+eCmMcROX+OOczely0xWETC1u6fHEiQ5MQ4L9TKrdTXJvTzWQTzU+ZgGgP9Kil+wfZghqyhCeaSqLDEOIrJOStPXhs/434sDYh/dhSgsXVYHRdzemTLW2uzseAqRs0Epad2Bb/TQDXSW+AHtcQ5zYjsKWlo4lTLvpcLqKifkgpvuB3Hr5l00t/hcbdSGp9lloNsCd4DaL3uhU5uuGaEhpNyLUD5rM5CATkhMAJKN1Wb6/OD0ZDMJLYPhafL+jJwPoQI9RZjLiB3AWkVm2/nk+ipEPALUiyktwBlEc4RuoXgmspd/LVzZtri07X1yeeAy0dECbmYgDJr4B0XWtp4GO3l1A6ZuFiUgXbqB7HYZm/zGQxFNQBCbaRWhzi9RFb3DhBH3YjVkziK8F4P/JL4U9ZkOl1Mf0w01cbLQD24YhphSya0Q+HlzDDXvk0IkfjgBt1hQbqkTqMhqHKdCnotpKxVpxYlnkpJeJ2fIgG0PGCAPFMHoiKQUIadioZ7ACTKRoldTKMWdG3n4GRy38+baROr/HNQb0xVieRWR5Lu8cmpXHPQ+v7fhH77Y9L7PbbrVo1whvKdYQ/XDIccBXS3OhVjBCB2NQCoJ00OtBLhucq3FTyDKVKUrSyXqYukym97EaQZxUKBq5uT+q6qMAhEATYK09Abub9jB+Or7blyaeMUanmveNXjXfzgUS5puQX6E6E5rjX
 mSOK5UqL
 cHA5r3QGSJ3D/0FMhot4whp1eVqFB/QidmzWVA1xvBShiXTFQZJopCaF/VwC/DhCFNkkNY08d1Pnb2eKP1WAOXW3eX7tMD0JtCZnh/xSriFJn2Cmu5GeHbfAueyKQusUpcuTQsepz/LyVwSOHeIGkhlq23OSaHvU/dmELPpoaj0WNUAfNG7bYUUuUV1axjplU4pqn/WBkGmyPLEMeWlLgKUVcB2ZwfOV4VvIr6EIkH0rbWB5OnYgNljAyIkl6YTyTkdFkdnucLQ2AxvwbUf2AyR/T5di4dEQ4oVf0RXnt6JmRaC/U3wxqolemr6SO8ne8MEq9PTeDxVqs7dONy73G6GQNp3s6H8esQCu4We6OI5lpXqpezQDEMX6BIDEnQfvCtstg8rCLY8MPg3k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 04:56, Zi Yan wrote:
> gnttab_alloc_pages() stores xen_page_foreign in page->private. On 32-bit, a
> pointer to an allocated xen_page_foreign is stored; on 64-bit,
> xen_page_foreign is stored inline. Checking page->private != NULL is enough
> to tell whether a xen_page_foreign needs to be freed on 32-bit and
> page->private is zeroed unconditionally on 64-bit.
> 
> It prepares for a future commit that remove PG_private.
> 
> No functional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Juergen Gross <jgross@suse.com>
> To: Stefano Stabellini <sstabellini@kernel.org>
> Cc: Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
> Cc: xen-devel@lists.xenproject.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/xen/balloon.c     |  5 +++++
>  drivers/xen/grant-table.c | 11 +++++------
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
> index e7f74ea7cd5eb..fdb18348cfdfe 100644
> --- a/drivers/xen/balloon.c
> +++ b/drivers/xen/balloon.c
> @@ -182,6 +182,11 @@ static struct page *balloon_retrieve(bool require_lowmem)
>  
>  	__ClearPageOffline(page);
>  	dec_node_page_state(page, NR_BALLOON_PAGES);
> +	/*
> +	 * clear page->private before giving it out, since it might be used to
> +	 * store xen_page_foreign info.
> +	 */
> +	set_page_private(page, 0);

Who would have set it to != 0 in the first place?

e.g., gnttab_free_pages() resets it to 0 now before calling
xen_free_unpopulated_pages().

-- 
Cheers,

David

