Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07D98D46606
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:41:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5867D6B0088; Thu, 15 Jan 2026 12:41:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 534676B0089; Thu, 15 Jan 2026 12:41:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4166A6B008A; Thu, 15 Jan 2026 12:41:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA996B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:41:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 203EE58CEC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:41:54 +0000 (UTC)
X-FDA: 84334916148.19.DB50B6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3BEDE1C0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:41:52 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dl1EW8Bk;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768498912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GpIvB3762HzVT81ftixQbCkuVLY3osLhpx5VpXYSfnw=;
	b=grShs/+ggovVmK2pD2xSLoLQUkZ3iv8Y0qgsKrHO9RKKErOFvGgtukELqdKq2X17HzlhYd
	MUb0XBmtXrdN0hQAODQ6LSeZMSsFFNnqYVLvJYDbnp/lQ7OOBBRvII3jh4dxPYg7m5F/QS
	E3GZNK6/gN2TnnURopJHyX8nKH9dwAY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768498912; a=rsa-sha256;
	cv=none;
	b=F/yeXU7rns4OcnY+rGtq2vq8kgY1k0CEpOpdAybCOEks1GdQa7rnd0p0q+U+a1xXeEfwYc
	vXHRA2OHnQQ7rAkNGboYw7sBaPLO1v71bVJ5PNoLv2nXTlURmq75h0b00aaNI3zUFG1LtP
	GqTuxuj0xyJdmFZIF5MO+P5ZC/U0aQE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dl1EW8Bk;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B5E143D2A;
	Thu, 15 Jan 2026 17:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 703E1C116D0;
	Thu, 15 Jan 2026 17:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768498911;
	bh=Og6i3thTN1lragtARMir4Fy1CEAvjRfPYpKglMK6jGA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dl1EW8Bk/wk7n+ked6d5dTqvGdNDbGhl8PLkyO2JwRqCbK85aViLYdw68xiFFERHu
	 YA2RE9D2nOCr1Mp+bpDoUvE7ZdJrHdTGzhVX5fZO+KivWZQwTWaecvAtWWkglQ75W2
	 kZWMNaiFgu7oOn0WetGjHSnQvEaxClLl30Ku/0aUVUK0XpoBfJmO3UmbZ+c8cUkd5X
	 eYZwNkOZrx6cP3m1cYFkY+8bNZPHXr+yQRnCYctDNvif1JySmQdEaSpxX4nDRp+yOT
	 HOvkRaiWNPUYYljW9aSgf8nHB/6/E/dzCRGl+D4kKv3Ul673G+YRA3K8/sUN+rb77H
	 FV/Gto8aur1OQ==
Message-ID: <b10e3b2a-b298-4d27-b8ce-63327864c220@kernel.org>
Date: Thu, 15 Jan 2026 18:41:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv3 10/15] mm/hugetlb: Remove fake head pages
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Matthew Wilcox <willy@infradead.org>,
 Usama Arif <usamaarif642@gmail.com>, Frank van der Linden <fvdl@google.com>,
 Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20260115144604.822702-1-kas@kernel.org>
 <20260115144604.822702-11-kas@kernel.org>
 <30ae1623-63f9-4729-9c19-9b0a9a0ae9f1@kernel.org>
 <aWkhbWR-3fWjeTaE@thinkstation>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aWkhbWR-3fWjeTaE@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3BEDE1C0005
X-Rspam-User: 
X-Stat-Signature: kdwfsjjyfcizwdmw3gzwsigjqmfugo97
X-HE-Tag: 1768498912-136948
X-HE-Meta: U2FsdGVkX18AMiNkO3Luw6OxpqsolCl4SnCBHyKEnqpJX2AFLSRlj4NYF8ih4OYIdkIhrpQw9PnKUm0DaxX/E1uU8SyO8O9VhuBzTrK+2eUMmcb7kt+i/ed05u5IvEmIhixYtbsYFuvLddMHIwwwtH54s5m5myUr+6Jo9QwuNPMoYRs1I4mKkkO8k3hh0shCYYcvq8SH0t2pwoHD/CFmXF6wVgcNwOur3OWBlLx8AjnesMIvqh9hCLNOY4WPp4xjFINqXKFHTI2Ml56gphiZSITPRC16ZNaw1JAo12AbgkfQnrPYX9AQj5qHdI6Ep0ONVF3OMbFJsqfLMMmTFIM57O8yAIspGfe53c9hYnqlRGo5eRRF4t9h0OOE1Pmg0y7z3ot7w3IGKb5pPpo/co8Nj7yw6BBhotSCLFFcV+CXGUhT8JjYRSW4DOUpw75gaWTqcCQCyLlHacWKQH6fsUdw7cWtIspE/gtFWjuSfaock6s7b/butczXxInAo8QrnSUlk6+Gw8nXyYvhKYSWvsttzi2JgrsIBSa0wFa/wB/71kWwJGC9oiTVvuVHG0dGibZc0D4tYL1/xeytrsjSPoqoXTzpMPMGkaYQuBq2v+1pxWIGkMjRk7GCzx3uP30t9noVrMK2YlpnkEWl4OvIDij2+Y1v4u+SKVUFeBLM1UwMZ5TCTVpKmw0Ne645W1B28UxtwGrFAqeJ5wudHxZexuA5CoKCrqhkrFPiLT9cNt8toJAHr+0WrLaOlE8lPbUvWpqxtHNVOa/sT1EVMqBI8c9LyTN6d4p81B60nqDYmMODB5JFQpG6zO4/+tTfMFuDobXgskFCkvlDb4l9eRUNAYfo8kk7Ht2TvDUZOUY6Y9Y3ck4VabwefyvUN77FqCenbGISwp9pXVa+WET2q9e9Xp1yeYCivlENyVcC7ByaPeNrjcWlYuJ58324Mzbieni+2TsfpJCJuBBtCMVuhekQbDK
 6RVJD/SW
 edyxLwUNrtFS4gzaavoM27P+k1fsdjAqPqQmXra9Ohw2Ngz919o9WpRjlnrrfFoRsol2M53UvW1T+r5Qx/0tYb/40/L5Z4bluCLjie1upcFp9FEH7fy7z0rEl0IYuqSLYW/rKVB37CsA8NhYEUhvjCk9968z4vC951NqilMQxqXWqkhisu7JlzMR/Run7V3gtFGJqq+8Bk6AJCUvDPS5PgF2BV4uQmI8o7Hlo1UzroZoKmw6KNj5QzcSm9Nc++4GDNZs3pA/pEPS/m+7nBH9Zycnix68tbYFvkn3D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 18:23, Kiryl Shutsemau wrote:
> On Thu, Jan 15, 2026 at 05:49:43PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/15/26 15:45, Kiryl Shutsemau wrote:
>>> HugeTLB Vmemmap Optimization (HVO) reduces memory usage by freeing most
>>> vmemmap pages for huge pages and remapping the freed range to a single
>>> page containing the struct page metadata.
>>>
>>> With the new mask-based compound_info encoding (for power-of-2 struct
>>> page sizes), all tail pages of the same order are now identical
>>> regardless of which compound page they belong to. This means the tail
>>> pages can be truly shared without fake heads.
>>>
>>> Allocate a single page of initialized tail struct pages per NUMA node
>>> per order in the vmemmap_tails[] array in pglist_data. All huge pages
>>> of that order on the node share this tail page, mapped read-only into
>>> their vmemmap. The head page remains unique per huge page.
>>>
>>> This eliminates fake heads while maintaining the same memory savings,
>>> and simplifies compound_head() by removing fake head detection.
>>>
>>> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
>>> ---
>>>    include/linux/mmzone.h | 16 ++++++++++++++-
>>>    mm/hugetlb_vmemmap.c   | 44 ++++++++++++++++++++++++++++++++++++++++--
>>>    mm/sparse-vmemmap.c    | 44 ++++++++++++++++++++++++++++++++++--------
>>>    3 files changed, 93 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>>> index 322ed4c42cfc..2ee3eb610291 100644
>>> --- a/include/linux/mmzone.h
>>> +++ b/include/linux/mmzone.h
>>> @@ -82,7 +82,11 @@
>>>     * currently expect (see CONFIG_HAVE_GIGANTIC_FOLIOS): with hugetlb, we expect
>>>     * no folios larger than 16 GiB on 64bit and 1 GiB on 32bit.
>>>     */
>>> -#define MAX_FOLIO_ORDER		get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G)
>>> +#ifdef CONFIG_64BIT
>>> +#define MAX_FOLIO_ORDER		(34 - PAGE_SHIFT)
>>> +#else
>>> +#define MAX_FOLIO_ORDER		(30 - PAGE_SHIFT)
>>> +#endif
>>
>> Where do these magic values stem from, and how do they related to the
>> comment above that clearly spells out 16G vs. 1G ?
> 
> This doesn't change the resulting value: 1UL << 34 is 16GiB, 1UL << 30
> is 1G. Subtract PAGE_SHIFT to get the order.
> 
> The change allows the value to be used to define NR_VMEMMAP_TAILS which
> is used specify size of vmemmap_tails array.

get_order(IS_ENABLED(CONFIG_64BIT) ? SZ_16G : SZ_1G) should evaluate to 
a constant by the compiler.

See __builtin_constant_p handling in get_order().

If that is not working then we have to figure out why.

Was this only a specific config in where you ran into compile-time problems?

-- 
Cheers

David

