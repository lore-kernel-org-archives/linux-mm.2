Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36D32C61DB9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 09:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E04A66B0088; Sun, 30 Aug 2026 05:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB61B6B008A; Sun, 30 Aug 2026 05:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA3FB6B008C; Sun, 30 Aug 2026 05:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92BE46B0088
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 05:23:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0AAFFA027C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:23:31 +0000 (UTC)
X-FDA: 85157397822.07.DA7D831
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	by imf29.hostedemail.com (Postfix) with ESMTP id D0CBB12000B
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 09:23:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QNo/+EdZ";
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788081809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0OuGjZ4EhmEEDgSixWMN+KmdLRHs/HK7jbtZWE2WGc=;
	b=57T0xDVI8t6+flrxKPPMTzfft63fak//1THKn3qYGsyjypxpJGHREw2MHF2d2VRflOfJ86
	7sOs1kN0lz/2rZHKWDaXVkERkIBnD9wlzCpe9NnbG9SFllqMopogUIUcsJgW670Y7+/eRO
	jUpOF2FGBOmd+Ev6ilquXnt3y0cJ738=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788081809;
	b=qH3hiuHh/U56eWPNsHe0m3jTgHNLIA9LGjbBc4oYh902jNxwkB0XVY3e7gZP/rRKcx49/k
	p0DluxWlQZZq9OGftryzO86kr/Ko1mnPEZl/+moW0eEbJZMa4/T3sG6n+1pSyg81gb/EtN
	uvpE0rkRRpXuLXNGas1b9a4xtyPCOf4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QNo/+EdZ";
	spf=pass (imf29.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.194 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jKjkjhNXcmDtFarhVB4q9KhIzqF2CfBDnbDyY+pXTh0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788081807; v=1; x=1788686607;
 b=QNo/+EdZOTwonvoX1/cnNIiK9DOWqmWgC5tYjHuYRlOwof5IKR+9r6DVGWaqTHRDqSOS1q3U
 yqWvqRbx55T3HEg9IAeRaIPZpQrXCr99H0ydmRjqDQ9t1bPF7geSU2tXnav1+1chQkpyfa17YUv
 DlMk8ZxFLuYlNyF2/3Rky+xE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 313c9a3f512e14d9;
	Sun, 30 Aug 2026 09:23:27 +0000
X-Mizu-Trace-ID: 313c9a3f512e14d9
X-Migadu-Flow: FLOW_OUT
Message-ID: <77a3aa03-a2ef-4c7f-a11b-6759b700c562@linux.dev>
Date: Sun, 30 Aug 2026 17:23:13 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm/migrate: copy all referenced state via
 folio_migrate_lru_refs
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>,
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>
References: <20260826-mglru-flags-cleanup-v3-0-d9f1c75549c8@tencent.com>
 <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260826-mglru-flags-cleanup-v3-3-d9f1c75549c8@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D0CBB12000B
X-Stat-Signature: nq7rraao7iownurzcj7eogygeem7sq4d
X-HE-Tag: 1788081808-845963
X-HE-Meta: U2FsdGVkX18O8TzZ9m9/uxfMfOreX9dM4wwRwnqwp8sysAYG5c7ROwnbX7NsLU+ufO53WQ6UTxMqZRwzAQNsMTzdVzaFMwsgT4WY+c9jOT/EnBUEBt9IcFXbrZ5Ix79u97uy8mjLlSXtlm3fhl2ArvYOX06nLwg7UudBtu4Jq2OSyLsLIRa1v5BZQkkAhBmdXvkCKQfNSa0p6zzhgfT9kxOLEtlS8i5ZQFvIaN3sQFZNDPw4wkowRbFhTYL5lOqz7lUQ3rKwboN95V5bN3W6GFoAN9JQK2RVXTbUqcJSjc5OBdpuhSIQVjL2jibI93kvuyDB/dqZL2mvLr3FNcnWR0WhZiq0BG2Nw8c+1LTUToPKJGKMx5sLPSqFLnaTF2dgfwu1GjGJQiv2FVyLUt086ZmW3is190ZkfBeuyRGA/PlTaDDPZHkJLHTsKm5dvbn4ERLfolP+BivRrbR+wBcqJkmsDpQYGOI2i1HPs2QkgSr9yilmdaz+9jHKbWH1HgprUziqca8ivpUqLakW5qtocseO7wxxZN2+SwnBqMc1gG+OBjeegE3WxYNpzB+SxdQUom6fK4BONfRZzQ+ecDYKsImdkknyH64o1WF8V805N6RdqKzidReHNaNjnGegq3g5z7vLWlQsnpUfoCnmD00ZW7nl2yvBnV3R1/ionfkAN01qjxXejvq8lQlfQKezOqLQV2x6SL1k1WbG3mov0W8DAAjoGSRb8iGaysWyd/rgN5PKCKltjpNhqCKWmTwkE2f4hFNezjZSUxJVv8D3q6RUc0lfjBCE16o28YyeHYQZ2n5XcKi5LXwHQw/UU3YD/cQQdXAwKRw4HiJeoRV2o4z/9n0h62TIhzbjZteXL6g/TDnAZqhcd9XT+iEGtRexCeDD/w4Ec+2z/3TaKHYGJZZZJkDrHom1wLNL8J7dQvb6lZRleH3uHQFczShegWnjSqk5knvsD/cVBMB3gLTQya9
 Ldb2JW9o
 sZySgQ0X3Wy5gXbDrwJ9NssH8bdg9XsuIrc6mtsy/aCtRgDHURFM2F5TakQl4yps/Dum71NMHSEHg+0rBB5LieWXqnH71CWBxHOHvU16qFOE6NPhd9VphKpNKNEyyZjHQz8C3E1GePs5TiYwWkPbonGF8Os6ZO8NDz9KCdQzwj5UPo6H0PBIJPDacUmnMb7LlCX4QUXxO7AHjMQAY12GEFtVEZq0xDPwfS3uSJM6md4JgI2tNa03hnTBytghVVCHoxYjU6JH4d4OL+4GK6xeIHitXIh75FGEDaPq6xJfmBZDKrnMrGfOM7oYoSx8/DQiZh5pqgZWsW6mjEbRvs9KXGM+icbn/+136UN32VgbYgoeYbNuYF+YEGCix1Dlh0X8iT7Wd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/26/2026 1:53 AM, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> folio_migrate_flags() copies PG_referenced separately from the MGLRU
> refs counter, which folio_migrate_refs() transfers. Yet under MGLRU,
> PG_referenced and the refs counter bits together describe the
> referenced status of a folio.
> 
> Consolidate the two: rename folio_migrate_refs() to
> folio_migrate_lru_refs() and let it copy the complete referenced
> status, i.e., the MGLRU refs count including PG_referenced, or just
> PG_referenced for the active/inactive LRU. Drop the open-coded
> PG_referenced copy so the referenced status is transferred in one
> place. No behavior change is intended: under the active/inactive LRU
> the extra bits are unused, so operating on them is a noop.
> 
> Transfer the reference state first, before the destination folio is
> marked uptodate, so a concurrent lockless reader cannot have its
> reference update overwritten by the copy.
> 
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 20 +++++++++++++++-----
>   mm/migrate.c              |  6 +++---
>   2 files changed, 18 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index edfaf2661812..7f91a89b5ba3 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -365,11 +365,19 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   	return true;
>   }
>   
> -static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
> +/**
> + * folio_migrate_lru_refs - copy the reference state to a new folio
> + * @new: the destination folio
> + * @old: the source folio
> + *
> + * Transfer the reference state to @new during migration: the MGLRU
> + * refs count, including PG_referenced, or just PG_referenced for the
> + * active/inactive LRU.
> + */
> +static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
>   {
> -	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
> -
> -	set_mask_bits(&new->flags.f, LRU_REFS_MASK, refs);
> +	BUILD_BUG_ON(LRU_REFS_MASK & BIT(PG_referenced));
> +	folio_set_lru_refs(new, folio_lru_refs(old));
>   }
>   #else /* !CONFIG_LRU_GEN */
>   
> @@ -398,8 +406,10 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
>   	return false;
>   }
>   
> -static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
> +static inline void folio_migrate_lru_refs(struct folio *new, const struct folio *old)
>   {
> +	if (folio_test_referenced(old))
> +		folio_set_referenced(new);
>   }
>   #endif /* CONFIG_LRU_GEN */
>   
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 15b45832bcfa..a369d0c95c38 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -776,8 +776,9 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>   {
>   	int cpupid;
>   
> -	if (folio_test_referenced(folio))
> -		folio_set_referenced(newfolio);
> +	/* Copy the reference state, including PG_referenced */
> +	folio_migrate_lru_refs(newfolio, folio);
> +
>   	if (folio_test_uptodate(folio))
>   		folio_mark_uptodate(newfolio);
>   	if (folio_test_clear_active(folio)) {
> @@ -807,7 +808,6 @@ void folio_migrate_flags(struct folio *newfolio, struct folio *folio)
>   	if (folio_test_idle(folio))
>   		folio_set_idle(newfolio);
>   
> -	folio_migrate_refs(newfolio, folio);
>   	/*
>   	 * Copy NUMA information to the new page, to prevent over-eager
>   	 * future migrations of this same page.
> 

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


