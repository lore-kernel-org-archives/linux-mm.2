Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 712A7606A329
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L53Kvpg/
Received: by kanga.kvack.org (Postfix)
	id 8C8776B05B6; Mon, 16 Nov 2026 05:43:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 89FEA6B05B7; Mon, 16 Nov 2026 05:43:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B5986B05B8; Mon, 16 Nov 2026 05:43:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 519066B05B6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:43:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CFA621404AD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:43:02 +0000 (UTC)
X-FDA: 85440644604.03.4DE5234
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3663440003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:43:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L53Kvpg/";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794825781;
	b=zqqYx72w5K0IX2QkPp9W1uP+hKDAuKLrFApeQ/5nKeSY0x4p7gma1i6AbznkJ+yP57CPeU
	kVNZDBugovQLezKRJWcqDXuoDVXEzcbxYBbXZe8+W8eHiXKfKuf+1Hzhf9AwRW6FoSiB1B
	VbjL6s63WhZBjmUXTaWrANT7Lqp7hDc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L53Kvpg/";
	spf=pass (imf12.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794825781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cx/84dIEgCToGVbSCcqCImRJVM/D/eNbp/YNfnFpfQE=;
	b=jv+hYLE6UU0YL3SkU3GKV/x3zALz4CJZYaHduglW7Z0mgmgt6sTpYRVNS4dh4FL1qpXiwX
	Tq3hVR8sArGmfFlQFkpp6SYE1WKQTtaDmbyXwhKIwtIsQVvBuspmHDHjW0G+JPQsUuJJ/w
	oaLsKL95U3pQB9R4da0uH16XSoZfNX0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC560628E2;
	Mon, 16 Nov 2026 10:43:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E171F000C6;
	Mon, 16 Nov 2026 10:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794825780;
	bh=cx/84dIEgCToGVbSCcqCImRJVM/D/eNbp/YNfnFpfQE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=L53Kvpg/F1eR9dPgVhOXriObkAjop9B9ioQwhI2UPyGHVxcZANDFkOKiohK+anad0
	 H+wTCo1aRZcsrVFJtre153ASAH7f2xaNtBGyRXCu/ktsMvS1aF4FM3f6PExMl89eMt
	 GH5z1Y87L2dKpBYkBCHFBwYvcfyWaaCf6cl3JcawO5Y3tEBmW9PZrO9/V2A8sKHMSL
	 v9kXdZAgtevbm5LGMGqc8FhWiZqqtwLvH8AMEQzX2CnpHMMWV35yDDtrPLckX7F1KL
	 rkJET0alEEADoHw170MFKCCA4UmuC9BlxBIPf2vxAfkjCdb80HolkTMwkwzoqMb5HE
	 l9+M9ceWTKo1w==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2 02/14] mm/hugetlb: optimize bootmem hugepage tail
 vmemmap init
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 Mike Rapoport <rppt@kernel.org>, Li Zhe <lizhe.67@bytedance.com>, 
 Andrew Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>, 
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20261113033442.62970-3-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
 <20261113033442.62970-3-songmuchun@bytedance.com>
Date: Mon, 16 Nov 2026 12:42:48 +0200
Message-Id: <179482576829.2379196.14337146328165617703.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: ui1ourzk86ydof8mkzce6pheid61b1j5
X-Rspamd-Queue-Id: 3663440003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794825781-87590
X-HE-Meta: U2FsdGVkX18G2xsTM1zqOB7xAHQAOtW33PpKTYZHHBks+sw1NYQaoLlot/dhIav7vjjp8j2fieWxXFqJwqkEvggcRd4uytosaowwv6njKiQqxJQk/tTOXJLvemfKc9gJJs0K0hJPQ0xID0W+49/iCmfQZpqvliwZ5PxMA97axwdiFdY6viHzFy2dZB7Aj/Th1UJTDxOUOISNmFh9Cb+PgxnNI3DaPb83NQ7NpMM1Gu0F7nTZBrxYNmVkO3MgHbUzkA90xdlhWrPcHDyjRreJjMvI1gvSM6ZPQQMGD959o0Y0lQuh15E09n9K7X6iVCzit4PoF/BllQ/vzgVxOgdLxq64l0mBAvJWfAVsNFS98lFuc24EGt7WdwLm2YBHVMKoOqD9hZthbda0DgkLqwVVu4eJJys/hrM8z1e4b3bRIGZOgTEadtyjDX0rsz8KsdoH9ay26UrA9OLgUE+Xz9UAcf53xBodrx5skrUWl7iYiPDlgyrOGhJQVvOWhO+iEGJSxcNhhrYcKyBMhMBmBoHUkiiXc1gVkTY2IjDHppmMHijVKzqIwgKNep81TBvvACufhh7U0RARw65hFYoJMkDAH3U1oTmgSQ0iHcMN7vZZmuYi4Ayf2dlGsJVsnyEgeTffniLkJ07QDLDT2vMy5S3wBymerw9aJn5QeCsqq6smh+siSriktjZkUYSGjVuYRpHBc2Sll2xAY3asAS4GIH3pgDXBeke/vVdmPoOyZyEdnjW3OTaitw/n/soZPMCcff0/cWc6neSkUUhMC1f4uvL8TGaHt/6oeZ6USsuxlXEFD0aQh8LgK963MRPM6lWA2irm8LfsfmfTkuS2u4sB8VW0oARHy24DiLlSBEf+BI1vfK0NID1GPUqQl28t9wi+AuGzcUdvuBUCFuotRU7wUWkePmuSz4TLVN2h2XG/X1ZHPNDPv+RL6A7AzCKg7tr3nIf7/DRjyHvv5cMnLmXKHOI
 Bg0+Vsg8
 DfZuoTbalYmK5A15FA1zCUe21pwn4uL+wxMwIMbkLs97cpkmXpBbgu7kazQJm/x8KupgJoXA9EmnZuxsCOVF0qHrRXwaknb1JUMyeE+rKugwp+pDCYOEgKTwsQ1/w1ObQ53KVkXkLHMgZ6JvI8lBY/zFKQu/w61hJXLKAplOfX900sqkMpq2HJ1sgz6y9dBRGsOvvCEmtNIiJ49KXXgOxiKzqmg6A9dhU9/BVG9Xs46T3nfn/L4tTEFzK4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

> Boot-time HugeTLB allocation has to initialize tail struct pages itself
> when HugeTLB vmemmap optimization (HVO) is unavailable or fails.  For
> gigantic pages, this can cover a large number of tail pages.  Most state
> installed by __init_single_page() and prep_compound_tail() is identical
> for every tail page in the same huge page; only PFN-dependent fields need
> refreshing.
> 
> Initialize the first tail page normally, then initialize the remaining
> tails with hugetlb_init_tail_page().  This copies the already
> initialized first tail page with memcpy() and refreshes only the
> PFN-dependent fields in the destination page, while avoiding the full
> __init_single_page() and prep_compound_tail() sequence for state that is
> identical across tail pages in the same huge page.
> 
> The fallback path was measured on a v7.4-rc2 base with a temporary
> jiffies-based printk modeled after the existing timing in
> memmap_init_zone_device(), using 4K base pages and 64 boot-time 1G
> hugepages.  HVO is unavailable on arm64; on x86-64,
> hugetlb_free_vmemmap=off was used to exercise the fallback path.
> 
>   arch    base      with this patch  reduction
>   arm64   360.8 ms  256.0 ms         29.05%
>   x86-64  171.0 ms  165.0 ms          3.51%
> 
> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---
>  mm/hugetlb.c | 23 ++++++++++++++++++-----
>  mm/mm_init.c |  5 ++++-
>  2 files changed, 22 insertions(+), 6 deletions(-)
>
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index cb2de24affdc4..d70ed37d2553b 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3239,6 +3239,7 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  	enum zone_type zone = folio_zonenum(folio);
>  	int nid = folio_nid(folio);
>  	struct page *page = folio_page(folio, start_page_number);
> +	struct page template;
>  	unsigned long head_pfn = folio_pfn(folio);
>  	unsigned long pfn, end_pfn = head_pfn + end_page_number;
>  	unsigned int order = huge_page_order(h);
> @@ -3247,11 +3248,23 @@ static void __init hugetlb_folio_init_tail_vmemmap(struct folio *folio,
>  	 * As we marked all tail pages with memblock_reserved_mark_noinit(),
>  	 * we must initialize them ourselves here.
>  	 */
> -	for (pfn = head_pfn + start_page_number; pfn < end_pfn; page++, pfn++) {
> -		__init_single_page(page, pfn, zone, nid);
> -		prep_compound_tail(page, &folio->page, order);
> -		set_page_count(page, 0);
> -	}
> +	if (start_page_number >= end_page_number)
> +		return;
> +
> +	pfn = head_pfn + start_page_number;
> +
> +	/*
> +	 * Seed a template from the first real tail page and refresh only
> +	 * PFN-dependent fields before copying it.
> +	 */
> +	__init_single_page(page, pfn, zone, nid);
> +	prep_compound_tail(page, &folio->page, order);
> +	set_page_count(page, 0);
> +	memcpy(&template, page, sizeof(template));
> +
> +	for (pfn++; pfn < end_pfn; pfn++)
> +		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
> +					       folio_zone(folio), &template);
>  }
>  
>  static void __init hugetlb_folio_init_vmemmap(struct folio *folio,
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f16a047796c88..934512bceda39 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -719,7 +719,10 @@ void __meminit memmap_init_page_from_template(struct page *page,
>  	if (!is_highmem_idx(zone_idx(zone)))
>  		set_page_address(template, __va(pfn << PAGE_SHIFT));
>  #endif
> -	memcpy_nontemporal(page, template, sizeof(*page));
> +	if(zone_is_zone_device(zone))

Nit: missing space after "if".

The comment at the beginning of memmap_init_page_from_template() still
talks about "the non-temporal copy", which is now true only for
ZONE_DEVICE.

-- 
Sincerely yours,
Mike.


