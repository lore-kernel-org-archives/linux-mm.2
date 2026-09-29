Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AD27CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 845E86B0093; Tue, 29 Sep 2026 03:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81CD66B0095; Tue, 29 Sep 2026 03:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70CE16B0096; Tue, 29 Sep 2026 03:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7BB6B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:36:49 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CFF7680423
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:36:47 +0000 (UTC)
X-FDA: 85265992854.05.5A8083A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 20049180008
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:36:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IimBV9tX;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790667406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4ktdpi1f+/KDUD6L3UXr89sslU38XOXuJkv+riiaEg=;
	b=Xo6EcA4CF29jv+qr/BiT9X+lhf6gNh5aLlCqgOxPSBSK0N0KDTexE/RMccGXMl1+IGK7qt
	9rzkTH0RsD6DbLeHKtsgCqyWlxqWNgPWna2hcfti1obQcon6ou/0+5kyDysLeN2Im4UMgK
	7krHSdkaJeNAARyO+ImbWE/UKTc+hLs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IimBV9tX;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790667406;
	b=QjNHIyfJ37i/dqbrjVMAr+RJTImXecWH02jS9WhG4NHOng0xsBh+eVvZPMndtgJMXDNIcP
	H4kbpcAjRHSh0uuKDL3t8h7SY9qwBKSNGiEn+dx431VQHsCAlc84MJO9iMJNS8jSnorbzV
	UyQ6HgJpmUlFPkqIXz9I45hH9KPb23Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D73860210;
	Tue, 29 Sep 2026 07:36:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F27901F000FF;
	Tue, 29 Sep 2026 07:36:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790667405;
	bh=N4ktdpi1f+/KDUD6L3UXr89sslU38XOXuJkv+riiaEg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IimBV9tXab1BYBvx21vk5zYso+7dCfqv09ZfPCCNxIZBCG0qD2CSZiCF92zrEcDAh
	 TZg4vfypokm6PuGRQZHu1ZzssiOGuX0/iFqcx9FOkfesKhn3Lp2cKO9itGJ/PUIuAA
	 Gvh3WIqS2aoJaEgiCtSn1KvbcMaM252im82unuIUQ2IhlZTmJBd3WBfBuQadjWxKY9
	 c6G/sp2lpauOWFZrtfhL/6RLZBIsRzZ2x8JV6Wo9bPNjkwNh/wzxFrcUHIdAi6RAGW
	 Cet9Rh+AYl+P53tJDy0E7ZdskiaxsvWxU2X2ECcv/49QACR19eLfXC26MZhuDzVC2T
	 Lw0OFJeLZGfpw==
Message-ID: <1b542015-8e5a-41af-9e98-9810333e6725@kernel.org>
Date: Tue, 29 Sep 2026 09:36:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/12] mm/sparse-vmemmap: switch device DAX to shared
 tail vmemmap pages
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-8-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-8-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20049180008
X-Stat-Signature: qyszxzgzwpphj98sf6tbj86qgg56ewdt
X-Rspam-User: 
X-HE-Tag: 1790667406-699575
X-HE-Meta: U2FsdGVkX1+3km/WDM3WpFpUwSa11oGfzdjpEVsHW2Yoxb0BdNsf3XbWZgaG0qdxNkGOTksg0kjlxWih4Fu+4cos0eV0KqHkWlt4w7tpOzj5gEriwftMyQkQjKMxNY5rZvagJIUDb7yKoonjNqKITSBQPRV0wkRyakfHG/cxFHbPNrfA4JjMwnldONlliy0i8TQSJtisZDgYUb5q6c9ksxjhKFZlIkG/Da9iTzUDvnfTp9VOHtNdWREqi+QwYO/O8E0bZIU2F9erN9s73mWPOelSe5V9bTM7q8kCMiOXgm2L6UIntPWp1C8LRaO5bKFxAXgDffteXMZlBrrCyG7Y6EeUM7LvGaOh8CY3PZjyj6fliV1mNVykHWWDNvTRZsBl0Aj3FXmU2tBZQrhNLxhHJnR08IE7QKmOgSMXNzDh9QU715JxB0EpQZooWS26b82Y6FdXvpm2ErraxG4eaNX8JiuJtDDtpGYRFlaPWRDsK53bmWgfT/O6xfP9i8QtUcDrsfq0+8WPFLpxnVu/gaHWI6/DN9lraZrYDMP7l+cNDPcmHYI4syZmrhwB4DeVcc3N6AngqKrzl/mV014dqE5oxenyptuQpDzgT9k67Usf1CMnRFA2FSqZhWT3B411tyoIjztGUbOkwUkmSkJsnD+NIw9q28la3FjmOWexlLRa0hPKHAsJq08D2N8Ws0NnwmP/ylxbaUvLkiUBrCBb+sx/1AeL8ftov3uv5TA4lHkstZ73AJVahRcnAHQiwKoDQ1ZXA6nDLGjAdOpQJDZeSAKMC1h0RMFE5srKoDDuhG0hHpGCNO1SavAWAzX9+jY0OZWG+pdThR/WDJR4DXG8NI0t9PSGr8DrFd/no/EUEhoMotucl2ehrs+yNw1Sl5bRKY58L5njTo2X46v2bp24Ebz2m+wHx3IIlHVXGHg94EWdlQ9cIaeqLxk7xr+EVOO+YeEIZmEJXPF6fx7xcidrXJV
 A5h9PcqH
 n22IfHAJ4Xi1XNb1vOx96LwG5Kg2ENvfRfNmmsH2XzfTMrmWyPiqQan+4LrposFdCIlYI5lJa2M0WKII5AeSM4i2AYbIlfZJ8mODyH52v7F1Eo4RX1kVKRD8tcsfogMC+NwANXyurQvq2ufyklnDq0z90EEqNGBUQXpGtFvY5G4Nh93O5vYXZ5kvZslpM9/Zo4beZf/g9m+sJ6EuxIY1SRdg7sVjT1Q6IYFkcizLtFAhj5WeBe9Q7YjawHJGnYe6WDbDsU4Zg0eQ1E/VIVVCjgzatmA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> HugeTLB vmemmap optimization now uses per-zone shared tail vmemmap pages.
> Device DAX has not been switched to that mechanism yet.
> 
> Switch device DAX to vmemmap_shared_tail_page() as well. This aligns DAX
> with HugeTLB by using the common per-zone shared tail vmemmap page.
> 
> The optimization is enabled only for DEV-DAX through pgmap->vmemmap_shift,
> which supplies the compound page order recorded in section metadata before
> vmemmap population. Unlike FS-DAX, DEV-DAX does not modify tail struct
> pages, so sharing them is safe.
> 
> Since the shared tail page can now back ZONE_DEVICE vmemmap mappings,
> initialize its entries with PG_reserved for device zones. Also skip
> poisoning vmemmap-optimizable sections while their struct pages may be
> shared.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> ---
> v3:
> - Move device_zone() after the definition of NODE_DATA() to fix
>   non-NUMA builds.
> - Update the commit message to describe the compound page order stored
>   in section metadata
> - Collect Acked-by from Qi Zheng
> 
> v2:
> - Explain why sharing tail vmemmap pages is safe for DEV-DAX
>   (suggested by Qi Zheng)
> ---

[...]

> -
>  static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>  						     unsigned long start,
>  						     unsigned long end, int node,
> @@ -551,21 +536,18 @@ static int __meminit vmemmap_populate_compound_pages(unsigned long start_pfn,
>  	pte_t *pte;
>  	int rc;
>  	unsigned long flags = VMEMMAP_POPULATE_DAX;
> +	struct page *page;
> +	unsigned int order = pfn_to_section_compound_order(start_pfn);

const and all the way to the top.


I did wonder about the poisoning change ... because the memmap usually gets
initialized once the memory section gets moved to a zone.

SO now I'm a bit confused about the ordering of events :)

-- 
Cheers,

David

