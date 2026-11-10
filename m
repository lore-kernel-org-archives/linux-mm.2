Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4C04606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:01:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZYKQtEej
Received: by kanga.kvack.org (Postfix)
	id CF7FC6B05B3; Tue, 10 Nov 2026 07:01:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA1126B05BE; Tue, 10 Nov 2026 07:01:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB63B6B05C9; Tue, 10 Nov 2026 07:01:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2596B05B3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:01:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D118120575
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:01:26 +0000 (UTC)
X-FDA: 85419069372.15.DD23FB6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 82DF22000D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:01:24 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYKQtEej;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312084;
	b=sU6bmeDre+3T7zHgBGqmDaT+S2UkAh3dNL9un8lwZ0bdmDEPk3JFjsvpU9+au9bbLXade/
	7skzs6NoLXIBXxH14qzfjU3nMnHlMAmc4uH7D9YJLFyAOjF95TBrWp1yGm4ChWL9eIMA5J
	PgxcjDpAB/PQDz+V59yT+70Za4xfepk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312084;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHcMhEIyJwyyaKRTtRNI13JBqAKFzLvuowBvhlEUf0I=;
	b=Wk7m2oLMJjBRw7bo5jPbmHgdVQM0cA8lls0fxV7WeIvfw6kWbDapOWKcARLZs5uVi34+/i
	Xwm2qxbfmx5+jZPhDS6qZW9XOZfDLk/j2ZN0p8/ABtdZpQAClp8D9wJ8pgAIe5w6+kPGjf
	1div3JeIsyixW9I2L4S3pYYIhCVhw54=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZYKQtEej;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F07BC633F2;
	Tue, 10 Nov 2026 12:01:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B811F008A7;
	Tue, 10 Nov 2026 12:01:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312083;
	bh=mHcMhEIyJwyyaKRTtRNI13JBqAKFzLvuowBvhlEUf0I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZYKQtEej9TJyw1H/wkdopDu5QPdWUgfA1ZQ3OEUmt/JjUIUITWc5ZCeS2fOVz+Zu1
	 ygFcfUvZxqXKP5qAVvUzEYsphS8M4tAJioR5oz7v+ZNvk8ztQK3WNCF0Fo+MuBTadi
	 0wgE7iMtKddIH9VcOUpDendEw5VDP7XG4CbMUC9Tbx+DdYrKQ2WUEhM6w9IC4m6g3T
	 oWHK1hUouwAdQnkZmJQMMnpvxebdTno4ZhU9+Y6GzU2gDC8Q9OsXvaGnWuZEyH3FX2
	 GNi/uXEorB4o8gwt1lcHO+JPtSCKjq/ox+4ozW+icGN1r6VUuFQ3gQ9NPLhaWefip2
	 mBDA5sTkiSKhg==
Message-ID: <sashiko-outbox-206969@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/hugetlb_vmemmap: fix PMD split TLB flush race
Reply-To: sashiko-reviews@lists.linux.dev
To: "Muchun Song" <songmuchun@bytedance.com>, "Oscar Salvador" <osalvador@suse.de>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Muchun Song" <muchun.song@linux.dev>, "David Hildenbrand" <david@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Joao Martins" <joao.m.martins@oracle.com>, linux-mm@kvack.org
In-Reply-To: <20261110112456.62827-1-songmuchun@bytedance.com>
References: <20261110112456.62827-1-songmuchun@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 12:01:22 +0000
X-Rspamd-Queue-Id: 82DF22000D
X-Rspamd-Server: rspam12
X-Stat-Signature: osziyxraroodefsmmceogkmhy3g6nirf
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794312084-828773
X-HE-Meta: U2FsdGVkX1/gnrd777+UCsjhLq7tYYD1tdKXwvwu9XuTJ8T0a+/oXxY3f19KM+lEQGT4LKhnxuoOdY+0ggqZGZW1hXDAII23e9N3q9voTaxuJKtivdV28NLMW5lXvzbTR9p3O7HjXfhAZ1XDB4M/0NDmzzdeAcWDK1OSe51vl5sKszZslp+Vye3NqnxhkDvIrlDVOXmLZ5/YveYKh8OqEqyRkUK8f5peUw3nxSdorNA7b47NIalOypjxv9N9HhfW2zOCITA4mLi6o3Yd7vbp2GzRdfEyBJGzj+0KNfbcPiVyZxwrYziedyPyJkKn/h73FHV+/72ZIjS1gPTuw1FvPuo62cf4A/yYIkw8laSqkZpVIzvMgjj7jcZSVy5OAtvy82PM7pG/B7xaYdrBIynLx6oDY2QbQ7x+NFLnc3sOvA0OGSs7uu8CZnnQx9tEloOveUEm/k7vcGQpHMbsX8puT0AEe59HNzd9JkPOCHCeDVYmqC6hkV4YJQUsn1fPKZHvD6x21veqKwxymu7uuGQd2dXWQNudtIc00VNKAemlbM3tGzcJgbjS/zop3yircV6VO0lJ8udPiyNxmSYoSRZizyqxDjEqR1GxKz9S3cQeY5HJPj97zR/Yi55oUJPdf5XTqBoXGaCDZLN8C/HBr2RrD9botomSWT4JYTsjsDD7rvW+2fnxkoURkUgmDinlArBGbXr0pDjCxucTiZi5eq3EI9G/iOOYNkI9H2jV6RPCjcXCyBSo5XvlVxs6Vt2nrz9yJ4jJXo/vXlPX2z6PPUHIhFEpKjkP6bd8tulnwW6fSYAgVzvAX0+GZu9q6uNC3+d+XvCbWpirf60cudQAhAzm1tK6soh+tibjv6EIIoPtxvHOHFZoAnHwSOCzfW2LUqT9zXhnT5JeHGCBuqFlUaJY/mtsvVpoTQOq8WhtsGsAE2a8KGA0InkeJgOfbR6O7+I/BvueFFN0kVImJuPrW3d
 UwqiB5MF
 SbRbngDU10bMvh4j4R0zVN1howBXs1h/N+isauzg4lJhF2X5J6UNop82OEY/7YkEqvWyAKKawkku3y5R+gjAvpLblSEvD+o1He/G5ev+Da3XlFEr6IiBpt8/R7pmx/kL1c7e45bmml4S/22oJo+pLDhKFwAtEl8fm1OuOHQ8Q250mkUVZenR41fhDIrAIertkJGLhtfpOX5SiGnEvoCOwzwe0q3keIVIvqo/2Ue402KQm4UMhH8TvlESKrs+2ribYvONbPQrLYIEzM4SU/SkDP2DP87yehg66aeVf5MrCgSDH2eCzwC1fGTPUhHD7ZgxEfm8nCxY168kAMCgyxltxbqo0gA6YqXCqVtaA14OX1rYjsvgjqBOGelFdJTZqIBtOHB0BcK1of0Q3AFtvNibuzfAaELWnDHAiz6+R9dTI5mTu3dYkVltPFg0tjoXk0vUnGqJUSSs59Qb3x2NdQNShDWvzYHGFlBXLXVV2Mq1NEaajvbqHdkePLKm7eHUc05HzSrzCza165y1OSoz5bNbXCTHrkKHUCSHuJMLThhXyMLdoSJdlJlCjyPHYpCd2iTUnEBodwbTDxCZnvgv6zhhcmnNonwW++o+PKPqToAeJtPQItNKcSJGfR8puIrF9yD2q3hNhAaIykMdWZBRvJwm2FsGX8BaPpvb+flM0WowI9/aRiPZb8GkHceLJ+PkSrMMAkhnaLPsuAMWFlVbZyw56uOM4yA9JeZHhNXArZKCYGu68O8VVdnVULpKNKOIASe0QZdZrKVAY7JH13vv2qdf+gG74NJv9+vwG7hJH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/hugetlb_vmemmap: deadlock from GFP_KERNEL alloc under
  init_mm.mmap_lock
--

commit c4de2ad9c999ebd1524c99a20d1c19a13ab7ec8f
Author: Muchun Song <muchun.song@linux.dev>

mm/hugetlb_vmemmap: fix PMD split TLB flush race

This commit serializes batched vmemmap PMD splitting and its final TLB flush
against concurrent PTE remapping using init_mm.mmap_lock.

> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index ba8e11e399b24..ba6559bef742a 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
[ ... ]
> @@ -559,6 +565,7 @@ void hugetlb_vmemmap_optimize_folios(struct hstate *h=
, struct list_head *folio_l
>  	if (list_empty(folio_list))
>  		return;
> =20
> +	mmap_write_lock(&init_mm);
>  	list_for_each_entry(folio, folio_list, lru) {
>  		int ret;
> =20

[Severity: High]
Can holding init_mm.mmap_lock for write across hugetlb_vmemmap_pteify_folio=
()
deadlock in memory reclaim?

hugetlb_vmemmap_pteify_folio() walks the kernel page tables and calls
vmemmap_split_pmd() -> pte_alloc_one_kernel(&init_mm), which allocates a pa=
ge
table with GFP_PGTABLE_KERNEL (GFP_KERNEL).  Reclaim shrinkers such as
ttm_pool_shrinker_scan() take mmap_read_lock(&init_mm) when restoring direct
map attributes via set_pages_wb() -> change_page_attr_set_clr():

hugetlb_vmemmap_optimize_folios()
  mmap_write_lock(&init_mm)
  hugetlb_vmemmap_pteify_folio()
    ...
      vmemmap_split_pmd()
        pte_alloc_one_kernel(&init_mm)  /* GFP_KERNEL */
          <direct reclaim>
            ttm_pool_shrinker_scan()
              ...
                change_page_attr_set_clr()
                  mmap_read_lock(&init_mm)  <-- self-deadlock

Because fs_reclaim nests outside init_mm.mmap_lock, this also triggers a
lockdep splat on the first vmemmap PMD split (including under
mmap_read_lock(&init_mm) in vmemmap_optimize_folio()) and can ABBA deadlock
against kswapd.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110112456.6282=
7-1-songmuchun@bytedance.com?part=3D1

