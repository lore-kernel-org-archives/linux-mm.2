Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A25BBCD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 11:47:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E20636B0093; Mon,  8 Jun 2026 07:47:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1166B0096; Mon,  8 Jun 2026 07:47:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE6836B0098; Mon,  8 Jun 2026 07:47:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C18F86B0093
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 07:47:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7283B1C2A25
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:47:17 +0000 (UTC)
X-FDA: 84856569714.18.A4E506F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D9FF6120002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 11:47:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSdkhYB+;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780919235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XYBSlu0D8nqZHl8IsBFYqN57OEwm5p6GA9bMuLV8h3E=;
	b=Gpm3fuixTE3uhRXIK2yRV9/xGHxYscRJmYuu/mW0xu3mDdWAppaOkDKjs+7ofQADN7sKq5
	nTR8Jb+nrUpR36IbKLYaD0GyAdUbw11p2Z3hxmfwuRRfhP6JmClNAGMOViXp2Ov6PyguNl
	PQr8A4+IxARtwtsE0kKKHUrYA2H4JD0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZSdkhYB+;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780919235;
	b=W+0DE+wDJFuq5YnrRJ8UI5l5o/hJZss07/s3wXyRSVZJLay+Xi3PqHz5jEaaAQN/yEHslD
	ytT5LYfuoI3NV/0xJ5/XtD/pdMpeUqst+GqEYPnmfhb5gttx5lzqGlIN2x6K0fqBICZ6Hq
	/lrR8cEmSZt9PgYOX87ZSu/a5ZS3T5E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5B0346001D;
	Mon,  8 Jun 2026 11:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A0B1F00893;
	Mon,  8 Jun 2026 11:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780919235;
	bh=XYBSlu0D8nqZHl8IsBFYqN57OEwm5p6GA9bMuLV8h3E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZSdkhYB+h5nSqBOocM55VeVktciFWgwSVnAwGDNXjJ6v9AOxi/mcvgqVl0O23Zt9D
	 rI49yCjv1zm3CN4Gt8yWDwuJkyziTaNExRTEew34/k2iNz0/Dv8+3f1+j6f5SSRBbk
	 L8azeh8QnmhqEKzHKSrC86RBNlDkbpegBfN4+Dr+zJJMfk3SsOM+2wdlfgRbHskyTp
	 88waY2q0XSyxY6uuYjeF3H0vqzXhiw0F2Ebklodbyyu2o2FgT91sRDMGKdcnZMK2us
	 wj8lwU1YosFD65co8DZa7+499Gd9OggnXIN8ObP/f/g37R0tuo2HQRDMwH4wYYGyvd
	 KekWOT4YI8tKQ==
Date: Mon, 8 Jun 2026 12:47:01 +0100
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
Subject: Re: [PATCH v10 19/37] mm: page_alloc: clear PG_zeroed on buddy merge
 if not both zero
Message-ID: <aiaqGiwF_BR9TyCx@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <918897302a4cab9f476625adc238ec65a688d1d7.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <918897302a4cab9f476625adc238ec65a688d1d7.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D9FF6120002
X-Stat-Signature: j1hazcgdw6teshohw7y99od7qtp3ypie
X-Rspam-User: 
X-HE-Tag: 1780919235-933557
X-HE-Meta: U2FsdGVkX1+AtH2a9fJBRMkwIAVUO1aZe/vkheEAyWaKuWoCaLCWkgjCs1LnwI60+97O9KqFkZY2604bnMGegKysa1IR2bLmpcrFIBtCHl1vd9rmjurrXT/rkQx+HxiR/tZZRXlrkZDzIyO3S7qcE5UvyZB5POROTr14jnbHeaZe7jdCyfcBi+c3vqdtpcIhnwn7LciXRfanJtHKo55UOu6PrhiGrhHEzsMhYW4i5uay9NXcPdVD1JoyjQ6eCOf7Tz+D29E7yHwY2ow3nR5QMzY3O2nTq2pUNGIQ1EvMepbM+2B0QEaX8L3MW2e4qZZU4wAvNS43dz+4Qw4J/cqaHFTBeMb+38QGrgXq7vfY9C4KpLBWDXJwSKy+6QNrgomE/V8w+fpiMTZWUq5JVKCiqtpslUi71JIgK07S+INAnHVkYZDgvfMNFL2bRvZhdlzufJ4emyPLW5Jbp/YH4xnNFmx0UWnbACgxsLcxoYp2vFzbQ2E4pS3OPL+GI439JNU/obU5RfJos9gl/WqsKS39O5cxm4VXvYg1fDYTiH+aMYFXZ0U1Jul2dIne7sVSF+ox8kCl8onZn/mqJbS8g6aIgOUEsdLBYUXryyziQpzK/wecl6LiM8BSYADVUIZNvNG040Tdf3MV/5IAbYh8NxvZp/UrxGUDtR+TpLZfH28bN+4UVvqkSVRhrH3GAN9PnYxK8XOgSWP7zZP/m1eER7rXGx9b6Y5+A/0Pn6XAHBWAsYHjk3SRIrA+rlDgCbLsLxUKzJNHRFM4lex7uWC6IX3NwzJtnvXXTqn01fGf0yeTkmYGFlT29oxVnR854F7IJ0pZ5YXeThTPEL9Nwhf3q1GJ4JL/Z/zoxK/2bQVShjubEXAhG8xfFa10AEFjHXA6R+uYYYkoj+cFWyTHsMQYZyRehwdxr1sZtzJC10NirkxHH/P3JkqKP45hYXI3Oxjzf1XacDfCsp6ejwwQ4pOqi2f
 slzOgrqh
 OpGgT5gVLM/Hvh2f76geSkgk/SPJEsm8pNxduA1h6HpZkA5tvrar7P7tX8QQYGrMezE6jrs1UdkrGow/HtR+szG4o7SENchUEH1GT1gBrNwjTUdaaSL/zYD0KVvZU/bhkuA25GltgRF64HmjvSqXEpDTxrA3Ka9CJ9IW+w3sLVVEps0HBLXMc1vh2Upl95SZxH8crFI6rJBziscwzSEf7TGYLHJaIDIFiykChtjTfunEpUp8rA2J6L44ugld1b/DyvoAtASO7mJWYSuHk8ciakq6L89rqnSZIuujOjWnUqAk0F4l1w4ERGiiCYjBzhJbodt9ZIpWTqwUtYPpAGAJoc6W1PKVZ9c9tZ7krIoESildUEXIvxjgm1jwZa6cJy2xN8ceHZ9Z6ElSCKcJeiezoQFIGdrczF+2mnq7NyuG1/cuwKjqIs2+toZqD8f6DN8Cr4Hp9b6CBj8s5kuI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:38:08AM -0400, Michael S. Tsirkin wrote:
> When two buddy pages merge in __free_one_page(), preserve
> PG_zeroed on the merged page only if both buddies have the
> flag set.  Otherwise clear it.
>
> The merged page would inherit PG_zeroed, and a later __GFP_ZERO
> allocation would skip zeroing stale data in the non-zero half.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Assisted-by: Claude:claude-opus-4-6
> Assisted-by: cursor-agent:GPT-5.4-xhigh
> ---
>  include/linux/page-flags.h |  1 +
>  mm/page_alloc.c            | 15 ++++++++++++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index 91f8ddb1d512..9365d59ac1d6 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -680,6 +680,7 @@ FOLIO_FLAG_FALSE(idle)
>   * uses this to skip redundant zeroing in post_alloc_hook().
>   */
>  __PAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
> +CLEARPAGEFLAG(Zeroed, zeroed, PF_NO_COMPOUND)
>  #define __PG_ZEROED (1UL << PG_zeroed)
>
>  /*
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index edfc83571985..a90bca5317c1 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -941,10 +941,14 @@ static inline void __free_one_page(struct page *page,
>  	unsigned long buddy_pfn = 0;
>  	unsigned long combined_pfn;
>  	struct page *buddy;
> +	bool buddy_zeroed;
> +	bool page_zeroed;
>  	bool to_tail;
>
>  	VM_BUG_ON(!zone_is_initialized(zone));
> -	VM_BUG_ON_PAGE(page->flags.f & PAGE_FLAGS_CHECK_AT_PREP, page);
> +	/* PG_zeroed (aliased to PG_private) is valid on free-list pages */
> +	VM_BUG_ON_PAGE(page->flags.f &

NIT: We don't add new VM_BUG_ON()'s, please use VM_WARN_ON().

> +		       (PAGE_FLAGS_CHECK_AT_PREP & ~__PG_ZEROED), page);
>
>  	VM_BUG_ON(migratetype == -1);
>  	VM_BUG_ON_PAGE(pfn & ((1 << order) - 1), page);
> @@ -979,6 +983,8 @@ static inline void __free_one_page(struct page *page,
>  				goto done_merging;
>  		}
>
> +		buddy_zeroed = PageZeroed(buddy);
> +
>  		/*
>  		 * Our buddy is free or it is CONFIG_DEBUG_PAGEALLOC guard page,
>  		 * merge with it and move up one order.
> @@ -997,10 +1003,17 @@ static inline void __free_one_page(struct page *page,
>  			change_pageblock_range(buddy, order, migratetype);
>  		}
>
> +		page_zeroed = PageZeroed(page);
> +		__ClearPageZeroed(page);
> +		__ClearPageZeroed(buddy);
> +
>  		combined_pfn = buddy_pfn & pfn;
>  		page = page + (combined_pfn - pfn);
>  		pfn = combined_pfn;
>  		order++;
> +
> +		if (page_zeroed && buddy_zeroed)
> +			__SetPageZeroed(page);
>  	}
>
>  done_merging:
> --
> MST
>

