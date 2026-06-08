Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 763BFCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88EF76B0005; Mon,  8 Jun 2026 08:25:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 817AE6B0088; Mon,  8 Jun 2026 08:25:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E47E6B008A; Mon,  8 Jun 2026 08:25:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59A3E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:25:51 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DD04A93A53
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:25:50 +0000 (UTC)
X-FDA: 84856666860.22.F164030
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 386591A0007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:25:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEqMGr9y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780921549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7v9sMwWREmFeEIpVeq4eIiipq1ZEwTPV1JoPE5Cwhi8=;
	b=Ijn7ljLl33TQBPI+rS/jooTNswA4dMzXxWxjW9ViZdpkmqqi0yzQAgPmNvEcQWWXWzRwdm
	aVLU3wARklWGl0+SZs25SVmtPZMln0ibNoY8uXbZB+eg1BfYLhVg2HVgfHSkeCf4nwbEfR
	FsrZNj++Sm5dInzzfUJyqZlFdRGNx6U=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZEqMGr9y;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780921549;
	b=JNqaE+AzauxBpcz6gKFEnrPguv64ij6kmP78P1Uv1wzzG9R+4vXi5dFPxfH7FqAMz3vBo4
	pycKc6ouv07ha8AILlk0/HFWm3lfjb7SLOs4yq1C8jxrhtMZwZJ6XGuLS+Y9KfR1O4w6oZ
	Y8gKAfE1Ybm2hO5FcXORMQ9UtMdTBDY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 58267434FB;
	Mon,  8 Jun 2026 12:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FF411F00893;
	Mon,  8 Jun 2026 12:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780921548;
	bh=7v9sMwWREmFeEIpVeq4eIiipq1ZEwTPV1JoPE5Cwhi8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZEqMGr9yJAnP5zlkZnITsxa56PNYj1eaUlPo6+9nS0CZ344Qb7m6eFU8Fooc9252F
	 7oOj2aDj1+5q1ajsauTIZRwEDNzD+J3WcA0jTXjPd/uW9JeItGF0xiOUjb6jiRp//K
	 EuZnSeJ538+w8V3sAVBSd0+5cd0VKB2IhqIZA1lKOPMiZUq3UeRt6nELZ85SnQHocV
	 c8vFmP5qrbtaoDnlVeflv3BX1877qBnMOSUDJXM7vvMKUA1Ls5oWsPm2sPlI6tv9DL
	 95bgOafG7ubwMUj7JDinXyuS+JNWHkv+m/5/XHVtgcO8sCX7Ps3qDdWqNIby7CxqYz
	 eBKsC6vafrdhw==
Date: Mon, 8 Jun 2026 13:25:35 +0100
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
Subject: Re: [PATCH v10 24/37] mm: add put_page_zeroed and folio_put_zeroed
Message-ID: <aiazXE8pUDeCmP7c@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <fef7ca7bbf591865defef658b0792b58494aaed5.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fef7ca7bbf591865defef658b0792b58494aaed5.1780906288.git.mst@redhat.com>
X-Rspamd-Queue-Id: 386591A0007
X-Rspam-User: 
X-Stat-Signature: 8nx37s6fmxkga8x8sn5uq8acoyqeod47
X-Rspamd-Server: rspam09
X-HE-Tag: 1780921549-689893
X-HE-Meta: U2FsdGVkX18buxoA+RcYg62e052qTrNAu2XnaKNDVTl0fG275rPShnetuC267vq5cFmoXJDHrQdtkHqBYYKF1/jMkKYASBdFENhZW0qmGYWyaMqXcgbNObGT6W8EJ9Q0hBnRGXXzihyTJiB4P6wKEH88j90DGiXE+QG3+A5zfD6ba8TIUqKR0WEk53aS+1DsHg/1CeBnkagUm11Xyq2vccvE2e8jshYEbKQsRpFWUXi5qmQtXz9joOg7cY2546FGsvO+451UaY20SbOEeJGK1y6ahED33147eLfVJWvNnbmMDw9LXhez4KCd30xl+6VGDvZdKzW7Vf4fsKhVitpSaPFMQIAx/S9gMA94R3JopRamxthDTYvzD3NNnU5X6zPsG0s9drClckCLS4TKEptJ15o3QU3QdrnTK5EJ7HdsWzGDE7Glt7PF3lczmaGPrOkDwFn8rlMEwKLMuHl90sbhcK9YZtdkjabcpcWBV3kglvkopQmyQ36hNiExr5tV8Vg9D8z9PPvaupq4trNC37v/UplwIucDStMIbUcM/Nz6XGraTReaobYoQ6fDl8aOL+IvPC+tNYjyliJPfITmYlXUWCsi2YE82hKOQxJ73+eULCZ1iv10M3QbI1pD5wlMJpPhDQpLNNb7SUH8sSfka0IhibK0uuyxYrOMy/iO91Fp5sbdKguc2XtqwJuhA4m320jpf/CAtZT4wYimiqpVjtoWxtCeeCe4uOIv5Ay/3eD8FmHDXjBdnnNHLFixRnBHIZlm0h9qbp3ffl1i1RgkV5Kdz66jZGX6P/6JLCbi9bFEfHZR4AyZYEQyA0Lm91i50bjeQYrZmavBwFZ2tAYRUIA1fKe4LNeEaraFzOxALAcq8E4AaF0mNciUeB028f3+ruZLFQBvbFZP1aWeEw5mBE1LKcBYFomFQkmi2MH6Vtdv8mDI7lohsjFXvW85+zbclMBqsBpc+EXmhrCALRkLSf2
 Vv1goCyS
 z6wRjGaXecFxJUnKo8xjrXq0pyvWQI0g4k2sKrtn428AFnqx43JAI1FledALWzXZRgbQLrMvmDA54uOLGfZ73YQdYNmjelMcgzACfnjUB2jMhT5v1BAULn0+0ROlI9V/qzhaycv+EjN6lZGg0XLqRn8xHxiDKl5p/VVBxKO7l4PDpMQzH9Mx7YhqLyQ08Cfq6wNgb3p+Xy9sIa1KzAtmLDn1MnWIc4SiwfOaCOaTkHVtxP4Khq5PtsUaPQnKOIC0yz7Sa8GoUaazUVxvu5YSf9WiC4mALMOqMbIKAotuoWclCvSTdEJFebObNbZYS5R3xfJozECnpkSAEZG3Yn8Ly3v1Xo1V+BJ4EsnPSv2kHUUkZnXNnTic3VtFTZmzraKiyGrUoX0Clb05EwaJ4TL5q1u3qcg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:38:54AM -0400, Michael S. Tsirkin wrote:
> Add put_page_zeroed() / folio_put_zeroed() for callers that hold
> a reference to a page known to be zeroed.
>
> If this drops the last reference, the zeroed hint is
> propagated to the buddy allocator.  If someone else still holds a
> reference, the hint is simply lost - this is best-effort.
>
> This is useful for balloon drivers during deflation: the host
> has already zeroed the pages, and the balloon is typically the
> sole owner.  But if the page happens to be shared, silently
> dropping the hint is safe and avoids the need for callers to
> check the refcount.
>
> Note: put_page_zeroed uses folio_put_testzero() which only
> detects sole ownership at the instant of the atomic decrement.
> A concurrent reference holder (e.g. migration) means the hint
> is silently lost. This is by design: the zeroed hint is a
> performance optimization, not a correctness requirement.
> Losing it just means the next allocation re-zeroes the page.

Do not put comments about specific expected races like this in the commit
message but not in the code. Subtleties need to be called out.

The commit message also doesn't at all explain why PG_zeroed doesn't
suffice here.

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Assisted-by: Claude:claude-opus-4-6

I really don't understand why you have a 'zeroed' folio flag but need to
also have new API calls to detect that?

They're also HORRIBLY named. Zeroed as in what? Zero page? Huge zero page?
Memory zeroed by kernel? Pages that userland happen to have zeroed? Or host
VM zeroed?

Each are cases we address individually and relate to folios.

You absolutely fail to clarify _which one_ you mean, and provide absolutely
no documentation and add an exported mm API with no description.

This is just I think not something we want to add? Especially on something
so fundamental?

> ---
>  include/linux/mm.h | 13 +++++++++++++
>  mm/swap.c          | 20 ++++++++++++++++++--
>  2 files changed, 31 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 06bbe9eba636..79b3a8cb9a3b 100644
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
> @@ -2090,6 +2091,18 @@ static inline void folio_put(struct folio *folio)
>  		__folio_put(folio);
>  }
>
> +/* Caller must be sole owner to guarantee page is still zero */
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

Please stop adding more APIs to mm without kdocs. This just isn't
acceptable.

>  /**
>   * folio_put_refs - Reduce the reference count on a folio.
>   * @folio: The folio.
> diff --git a/mm/swap.c b/mm/swap.c
> index 5cc44f0de987..ecec780172ad 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -94,13 +94,15 @@ static void page_cache_release(struct folio *folio)
>  		lruvec_unlock_irqrestore(lruvec, flags);
>  }
>
> -void __folio_put(struct folio *folio)
> +static void ___folio_put(struct folio *folio, bool zeroed)
>  {
> +	/* zeroed hint ignored for now, no current user */

Please don't add comments about why you didn't do something that nobody
here knows about with no context.

If you want to say something about this, make it clear. This is so succinct
it's utterly meaningless.

>  	if (unlikely(folio_is_zone_device(folio))) {
>  		free_zone_device_folio(folio);
>  		return;
>  	}
>
> +	/* zeroed hint ignored for now, no current user */
>  	if (folio_test_hugetlb(folio)) {
>  		free_huge_folio(folio);
>  		return;
> @@ -109,10 +111,24 @@ void __folio_put(struct folio *folio)
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

No documentation again...

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

Thanks, Lorenzo

