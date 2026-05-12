Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E4D0CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 16:06:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A77076B00A3; Tue, 12 May 2026 12:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4EA46B00A4; Tue, 12 May 2026 12:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 964D06B00A5; Tue, 12 May 2026 12:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 867D46B00A3
	for <linux-mm@kvack.org>; Tue, 12 May 2026 12:06:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 524031A0547
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:06:02 +0000 (UTC)
X-FDA: 84759244164.14.78F6BF6
Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7C7ED1C000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 16:06:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Gpm+XYGz;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778601960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vN4J9MHI2MOI8oQ+XLl0/GT7idJevwCHKcj7tn/iahY=;
	b=QqGcmvNjlDKvibhTxFiAjQNgqJWpJJ63m9jdwsqmVU3wyDskZ2R1C+Y3UlhwrkINFibq/d
	Hi7WwY1yZEDIXDy7dlFWmRWSCeixkXlMhZlmC6CbpHVh6/ah5uF/kjBbHwrhFz4k3qFhcu
	zhDGUcCk/XKnjLy85kXDsDCrV/tF0iw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778601960; a=rsa-sha256;
	cv=none;
	b=XGybkXdz+ojiXpvfmJtL2qA5Io736aelmcCGFSbo6teoWzTabp29uf6XcoqFFFmlnFrESR
	3LqVXhNUf7uSKk66G2ECBU/I5WKfti6AabRagmAfwUb/IQ6wzwO1YjQi4KN6KLjBtz+sG3
	4d6O2l1BCh4BbmfGqf1fNV+Z+yEBDbw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Gpm+XYGz;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.176 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-8f0a87e23daso603253285a.1
        for <linux-mm@kvack.org>; Tue, 12 May 2026 09:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778601959; x=1779206759; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vN4J9MHI2MOI8oQ+XLl0/GT7idJevwCHKcj7tn/iahY=;
        b=Gpm+XYGzxGC1jOP6qhxQsFJRUvBO1AUJmRIihJ4fgX40l3Lxe4xv7PEZKanqiI+ec2
         i2obB4FfTkmR9Kjym73ffGUS9f0puFK8YhFGMkMzsXCZnD9lWDaQF+aqWdCtX/wFZFH+
         rharPYhtpE6oWaVD7cTC0RHHkyxH9KViwC5YAYLhU5k889TS0HQRjW3NYp9aM1XZvTGQ
         gYb7bv+c5Wi2dkPN9nY9TOTqra+DFvPObnLuaqt0Et+cREW+r5xyA6sJD6xKsFsw9K6E
         XnlRlue8UF+NnH0XK6J8ddt/HnT7n21zi9wXoZ0JMCEtb0mU2vBycbSHBkj9LZOkuut7
         OWJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778601959; x=1779206759;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vN4J9MHI2MOI8oQ+XLl0/GT7idJevwCHKcj7tn/iahY=;
        b=Wo4tIeoYN76nExR32jPY6N9rpMlz91H+5pRS1+74LJsrS48rW3Ub1H/ysH977t/n+r
         ErvdzsMoD9/8oWKdWc8qUfKMLAAGIiGNqiLhToOMfztgZj3It0dZrDx80Ueqjh/Qpf3u
         e2yaoOtH45YOV9YNGDaXPe1zj9BxMpc8XBrvxYIsBxmRHedzZfm7mwCXSRNrKgqgYEWC
         kC1cZ9b4fhuSJUW0+TY0X1Bv1HY2y9MkKOGHHsK7dtrFqiD77pbt7fgjo5KQ1dW6/H9o
         oG+QRP4QkIYL54mOkNJeKiTnLLlhLfclsAmjvVBY6Nnhta9jqnEqzVkvIMZc5ElRadDp
         h7gA==
X-Forwarded-Encrypted: i=1; AFNElJ8ffbewG9M06NM6eDG2Rvx0lnxVy/EnKuiJAO+3SD80NBEEqukhNnXFZZawY5ICOU4TxDTBiJHWAw==@kvack.org
X-Gm-Message-State: AOJu0YxpfNqc1wIm0gspBBZ1uuEDAjPVMjylrPcIEpsh5aXq8Sd4tdzA
	cKWUCX7aGoLBhEn2mYWHkxVzJqfIbtVuDAbgyECrtk3SHR7eS7VKif6Dhal5L5GK5yo=
X-Gm-Gg: Acq92OFRx9ezXVgrsbGyKPRQ0+SRm5UMg3fREMat4bloBA7Cxr3dZuC13vwXvZF/YK5
	/DPTQpCgUypqKNG1QygF5LG/clDjTvN4AyzOB5jquG5T5auqkESQMA/4BkATIMrpcv5HU9jZ+39
	PVaU0fwAgBdppeB3rf02IjHFfpHiIaX+iftrDBSf1vD/EF7kM3ODEBonrFXGJpmPtyd/YiieLOF
	d+Y1BZjkyNr9idCnIbF6t9PHukSH4gYSzHEzYoPIrscc97GUqRYnhn+45QQXbxuNdZ1VpMMuzjb
	ILYQFI/GjWNSiDLqCSgVM5oSrJFOTv/7C3KAgjq7vbcSwGZY3vF8pdpCXfIcy4Rzj0wfGbCyN55
	RzK5iLR6fnsDxn4bLjnSf0iec2Hbl4psn1USA6NypAaq9XLm/HHdy6A75KqAMsL+nFLhPXBQN16
	hnnLJyFwWNXaDJfrl+Gly4EPYmDcfU1SxeggiFNaEz5WnDrWiZem5J1x6l/7Kb27esIvHy1v25Y
	lrNponOx+iY
X-Received: by 2002:a05:620a:2584:b0:8f8:d217:f46a with SMTP id af79cd13be357-904d3fa500bmr4114490285a.8.1778601959278;
        Tue, 12 May 2026 09:05:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2c91c807sm3755667685a.32.2026.05.12.09.05.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 09:05:58 -0700 (PDT)
Date: Tue, 12 May 2026 12:05:55 -0400
From: Gregory Price <gourry@gourry.net>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	virtualization@lists.linux.dev, linux-mm@kvack.org,
	Andrea Arcangeli <aarcange@redhat.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH resend v6 28/30] mm: add put_page_zeroed and
 folio_put_zeroed
Message-ID: <agNP4x4oobMra1PH@gourry-fedora-PF4VCD3F>
References: <cover.1778489843.git.mst@redhat.com>
 <450465e4a03e63381a4bb8a1799a25859d7fdd83.1778489843.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <450465e4a03e63381a4bb8a1799a25859d7fdd83.1778489843.git.mst@redhat.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C7ED1C000E
X-Rspamd-Server: rspam04
X-Stat-Signature: z77jf3dyxqw8zrabcdzciwe8q3hms7os
X-HE-Tag: 1778601960-561014
X-HE-Meta: U2FsdGVkX1/BqoMigBm8VbXhdePg1HRoQVYp88WvdbY9LLAcFMnI2lVwkwt88K4czheYmT/EbC+a8uIoxf/3/LS3MmrSKh++4uYiJKTVA6Iro2p5/AfjEeTJJjCeRiq8vDpFl+ACQrB23q5rIceIw/Y8XNKY3nwXinHviTdwP1bxH+jw4VnOEg2gUs9M1AUBXjVS9S7c3HFNvQDW583pDkJHo1UgoHtq1BWjJmrCanmMuqP9NKIIVa11EYC3bguIt+zx3yAl+xZdQia23ky7Gj1ge3npghDMTkN+1d3SAhuH4VOMYNbZdrkvLG9Bb7NK/THr6cT7Higj/3SdyZWBj8BXgSR9gmK+TVcI5opg54gDdGkUWcO0oZoiwiyxcgForLrDMp5Afn6lJ9RML0e+oBAk1rPV6OVYbxVUUsrR21intSAGUvth2DdPNNTTQQlXIiuWEFaIbQFRNq5bZs6HB+QVuPLyLDg7YVWWK8VK9SAviWc9QY56A9MqOZavmTaNgCNnkn8Ngxd6pzeei5h7a5IjGDf69diniVELcwoeig4nUxhYxy2k+BDWCSey8zWQFh1QJjw3BnNSljvfHY7ZQy5wNwzkx+/yKfYeF0z1dxI0Di9l566xBuvpJQS5riIz6c3a7Kt34TfBThdh/xECgCCoScGdW4HxyygsDfbX7JImM5Tjuwd4do2GN5fy2ajHJw9nEbj8I5oZJhCFMfxqxqBN33QUrBewae/o0HSMiTiSnm8bp2n1mQHUlaXacYj4vAZw4lDcb4cAK79IBvmBEoFfq40VELE+KQErTUIBQV7MaMPhahFtsxW4WqLPt7tm5EmGCdd+c9Q/EtHD1hNft/iMaPA90RXFhoxz0EUr2X/yvOog9L4ZyiKI70y5G0uQVwpIcCpXSooBJgCGcRzOxngV3yElFnB7NyjqgFsBEgojCQpYrXol6XAfd5LwpmLzK2ORGo2a9/GqwM2Dv4C
 S6ktkSeI
 8mDaDM55ep+StQ71hCiu+oXxUhbkwp8avT7xwJ8OHg5nYTSwKSmNoHFwla0Z/8ypJdVjmuQX5Y+LdY7qN3/unKfhvVEtzzdwP+wN6eUQ8ozokdLeo/3ap1/9lvJ3gtC4kMFI6Drw96vICjiE+sJL82ynWTa6bwHZhETBy6gGwUiJjdV3ipAXkYNXR8DSwZHfET4UcaDwA2KMfAQHrreWhH3sIymJ/NEfYYq6eQY/lI77W6RGeEDS+Wi98jkfX8Fvln2+Q0jGBPYe3i+foWbXESyjEMs5L3rd8tGHYs6jvjMMOKpeZt7Qkab5mRzd0FXbFXXetEtVIrsrvOBRpk8dXRsODZN+9+bpTzAbsZLfwvo1ebjuxReVkWdwA/cw59KkcIvJ/nTJV2w6MGksD62piYROnCXPhv0PAcQJzUu4cDbUQJBxYU0r4luftrKBVMx3y1gwnZCaqG4chcj1wmWIqz7ncGXwBB4LnHiBGBxLc72aTFIaKK19jZoZFE9512HDP7Lqq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 05:04:19AM -0400, Michael S. Tsirkin wrote:
> Add put_page_zeroed() / folio_put_zeroed() for callers that hold
> a reference to a page known to be zeroed.
> 
> If this drops the last reference, the page goes through
> __folio_put_zeroed() which calls free_frozen_pages_zeroed() so
> the zeroed hint is preserved.  If someone else still holds a
> reference, the hint is simply lost - this is best-effort.
> 
> This is useful for balloon drivers during deflation: the host
> has already zeroed the pages, and the balloon is typically the
> sole owner.  But if the page happens to be shared, silently
> dropping the hint is safe and avoids the need for callers to
> check the refcount.
> 

I see this gets used in mm/balloon.c not the driver itself,
should these be in include/linux/mm.h or mm/internal.h ?

Just wondering the utility of this being exported for drivers.

> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  include/linux/mm.h | 12 ++++++++++++
>  mm/swap.c          | 18 ++++++++++++++++--
>  2 files changed, 28 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 3b1ca90fd435..4c51b7bd7576 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1913,6 +1913,7 @@ static inline struct folio *virt_to_folio(const void *x)
>  }
>  
>  void __folio_put(struct folio *folio);
> +void __folio_put_zeroed(struct folio *folio);
>  
>  void split_page(struct page *page, unsigned int order);
>  void folio_copy(struct folio *dst, struct folio *src);
> @@ -2090,6 +2091,17 @@ static inline void folio_put(struct folio *folio)
>  		__folio_put(folio);
>  }
>  
> +static inline void folio_put_zeroed(struct folio *folio)
> +{
> +	if (folio_put_testzero(folio))
> +		__folio_put_zeroed(folio);
> +}
> +
> +static inline void put_page_zeroed(struct page *page)
> +{
> +	folio_put_zeroed(page_folio(page));
> +}
> +
>  /**
>   * folio_put_refs - Reduce the reference count on a folio.
>   * @folio: The folio.
> diff --git a/mm/swap.c b/mm/swap.c
> index 5cc44f0de987..8d57223dfe34 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -94,7 +94,7 @@ static void page_cache_release(struct folio *folio)
>  		lruvec_unlock_irqrestore(lruvec, flags);
>  }
>  
> -void __folio_put(struct folio *folio)
> +static void ___folio_put(struct folio *folio, bool zeroed)
>  {
>  	if (unlikely(folio_is_zone_device(folio))) {
>  		free_zone_device_folio(folio);
> @@ -109,10 +109,24 @@ void __folio_put(struct folio *folio)
>  	page_cache_release(folio);
>  	folio_unqueue_deferred_split(folio);
>  	mem_cgroup_uncharge(folio);
> -	free_frozen_pages(&folio->page, folio_order(folio));
> +	if (zeroed)
> +		free_frozen_pages_zeroed(&folio->page, folio_order(folio));
> +	else
> +		free_frozen_pages(&folio->page, folio_order(folio));
> +}
> +
> +void __folio_put(struct folio *folio)
> +{
> +	___folio_put(folio, false);
>  }
>  EXPORT_SYMBOL(__folio_put);
>  
> +void __folio_put_zeroed(struct folio *folio)
> +{
> +	___folio_put(folio, true);
> +}
> +EXPORT_SYMBOL(__folio_put_zeroed);
> +
>  typedef void (*move_fn_t)(struct lruvec *lruvec, struct folio *folio);
>  
>  static void lru_add(struct lruvec *lruvec, struct folio *folio)
> -- 
> MST
> 

