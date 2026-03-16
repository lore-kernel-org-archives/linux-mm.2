Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C42FF53D6D
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 16:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EE26B030A; Mon, 16 Mar 2026 12:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F8E76B030C; Mon, 16 Mar 2026 12:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925A66B030D; Mon, 16 Mar 2026 12:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 84B4F6B030A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 12:22:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33A6457C61
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:22:10 +0000 (UTC)
X-FDA: 84552443220.25.BE15490
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8426314001B
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 16:22:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JUdUbMR9;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773678128;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OdYJAdAPNBxsBzBoCyzT4WVoKRyXllYzKs39cwqgD7o=;
	b=RTNbR4ZAB09T7H17oNUYbGs1OBH/rT+d16WawfOzUzu8jCUKNRwKsdxkp6Bh1ipa5iso9X
	nV60sCDv/knURoEP2w5FofqyPysnQPbgMPktL9mANa/DdQM+SwvHYxHEV4myQ0dnq38giM
	QHkq/rDfF6bu1zHY14zUMizNp+GXzvg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773678128; a=rsa-sha256;
	cv=none;
	b=s2nBfUUo41ZuhVXg7jOZxM9ND95PbvUF+250T5MkV0jofjpKUveBvtkhvEYXDw5QgPH1IL
	pIcINZttZt2CCN20lprruif6H7hraA4KIVVIplvU8NWHk5Z5SvOJS1iQZ9UfDod4FzM536
	8YM84l8LNS6lZzBK3z23x6ETHGxBieo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JUdUbMR9;
	spf=pass (imf23.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D67460123;
	Mon, 16 Mar 2026 16:22:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C6BC19425;
	Mon, 16 Mar 2026 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773678127;
	bh=5ALDfe6IoRbuZfXMM8bRpZyhpEkGKssanIAghhRg5zA=;
	h=Date:From:Subject:To:References:In-Reply-To:From;
	b=JUdUbMR94IE0Xujl6Qx5aVdh8iusl2gZ3QO7zR0ZDivWsEYMkTR6+0ZNd1VKuE2D6
	 5zZA06lsXSW8QJG+NgKw79p3zyCaCUNtwfATi0ahCpoRrsqvOwpGlW5qQ2qpe0esVx
	 8hyaxkvnPQ/liBzHbpcBcU/jRQw4+vyA0ypfXKtM8oYsY9ONAgdXGrYXJ5TFQifGsE
	 V4VEDehG6UNB2YH9Sp3fAtmYzcpJyelsbPkYoNb5ssoEEzmLBTl3SjK4jx3YCZS+bG
	 AjG1OD0BKyG5rCqaarLVqPGuBJrXgtgSprr7XJzBeFsqjqfb3xx9PtvmFwbjzcoIj3
	 Arfylj6+ZgvuQ==
Message-ID: <92811e6b-70d6-4669-8b62-c8544507ea19@kernel.org>
Date: Mon, 16 Mar 2026 17:22:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH v2 3/3] mm/page_alloc: Optimize
 __free_contig_frozen_range()
Content-Language: en-US
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Uladzislau Rezki <urezki@gmail.com>, Nick Terrell <terrelln@fb.com>,
 David Sterba <dsterba@suse.com>,
 "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Ryan.Roberts@arm.com,
 david.hildenbrand@arm.com
References: <20260316113209.945853-1-usama.anjum@arm.com>
 <20260316113209.945853-4-usama.anjum@arm.com>
In-Reply-To: <20260316113209.945853-4-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: p4xxhr1hkdsfgyy37583jbtkdk4uwioh
X-Rspam-User: 
X-Rspamd-Queue-Id: 8426314001B
X-Rspamd-Server: rspam12
X-HE-Tag: 1773678128-917917
X-HE-Meta: U2FsdGVkX1/+dWLUYt8b7sxcrbmMONataLNNxZ49pvb8ZUVI2nJwDHKEtz2CydrgThPN5G0w1h8S09CzSaDbCAfAO3SGn/oEygsCJe9pFr4WfvPjHbOY3tzW+GqzsTayJhZEXP2rgHJIc/wrhjS9GZ7I+crafo5cR/xytFoMKH/dxDaBE9OQ06ZTc3RTVaiBDToEwHKvwrkcDYEBrqwE8Gs86z/3nknyBS6VzMOmmx+YbLCzVQKUb/9XMkvSpAc4uHpcEMgwLUbHSuJ8m83dUB9kGYQZ/usfMXzfl2HvrEDOeSm0oToRfcyRPxa12cB6ErN6L3OGy1yydQZBojs9GJ/dUpe6Vxok4rSRCOySr/B8OLWJ9WvwRGO1ny6KTdeEr10jw+6khK1rJlskBxo6wqGLAPr8iy2tmpo/Imq6tZK6R5dIgPU6YgwBg4RcEYoh3UUTkqd7o9+338aFF3HYWkYGYHmHpHCEm29fLNuZBhKlrP4gcNiKZV9q3qjOE6JyZBbK/cC1ov5jKiWLq/wFoZ0qJ1CgdxquVmVQFcvCcvD/hZaW/esJXhcQ1dricLlXpLWx79HpB8kD3k1zzSNTzxQHotMz18YCKLY1paMjII2YdI01WuxlkQuNl5RQwpEoewLOjqtj6HrCZ66xmZRqzrr55E9c2cGzsrWxJYIKqXR5fHAj3Lt4Uqk/KJMKRuJK21MTN3kb6Gg/UUNHV15WdSjhYfcezBX6N39E991pz3GBvlglh32/qUwhf24xgPERmDBJsO2idZGg7980jPYhE0/92+ji4KDApnhY2BtTQvboCJxb+ww9XD5XXSsq2vaKjvSGSgJb4ZTFja4HMWXf1wzI3kXTGkQzhkH79uPFT6qqvmBExh0BPpxDzR05obljtb9UKfMD1x+va97ut3aJ30t+rb5rFb0uYfpAOtfNTpFDv0ZBNNIovjOfasCUay9EtNM2FtR56Ga9xQY/ERa
 xXXnv2Oj
 Ll0/AfyCJIs11/bubuDIiJeYKLqoRywSg2tVgaL1eY71VfzC6reDpxw1kTcEIDcirn4oJpeR0NUzHEsS3RZIbE6nVWuhMNVC0QFiPL1lBxKPBdwrGzGS/X4q7etwtHpsKa4WMEenQnMlAtoJ4KUKCBxfOZkncaDW4LYY2/Z2qPNkZjkeX45SHEuTup+ivN2BLhZLr/sOCeUP2UGUsm4XSmT+mhUFdHiHN3yl8QPin9mTTbb2jF++yOr0d2IkKhy1pEwuI1AE+NTJmNa6UbAscXklimBhBgpPWx4aSMQBkRCI37qy66xYk7IVrXKTEzyJneRDPD95G5IYfgJDfFTQZfoZKTepBxZsN3LPro++/CKiWA+Eekdc1yIimrTfvE7bd3igJnQ3Em7Ws7Vh9N+ZqeLdEnNBHnUUCpX9MD0n2x1+fNoX99sUP0aFOR+3XOMKStn8Mnu+rbpoc37fsVckF11ZSxxneloJA4rgJzsml1iV3qT0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/16/26 12:31, Muhammad Usama Anjum wrote:
> Apply the same batch-freeing optimization from free_contig_range() to the
> frozen page path. The previous __free_contig_frozen_range() freed each
> order-0 page individually via free_frozen_pages(), which is slow for the
> same reason the old free_contig_range() was: each page goes to the
> order-0 pcp list rather than being coalesced into higher-order blocks.
> 
> Rewrite __free_contig_frozen_range() to call free_pages_prepare() for
> each order-0 page, then batch the prepared pages into the largest
> possible power-of-2 aligned chunks via free_prepared_contig_range().
> If free_pages_prepare() fails (e.g. HWPoison, bad page) the page is
> deliberately not freed; it should not be returned to the allocator.
> 
> I've tested CMA through debugfs. The test allocates 16384 pages per
> allocation for several iterations. There is 3.5x improvement.
> 
> Before: 1406 usec per iteration
> After:   402 usec per iteration
> 
> Before:
> 
>     70.89%     0.69%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
>             |
>             |--70.20%--free_contig_frozen_range
>             |          |
>             |          |--46.41%--__free_frozen_pages
>             |          |          |
>             |          |           --36.18%--free_frozen_page_commit
>             |          |                     |
>             |          |                      --29.63%--_raw_spin_unlock_irqrestore
>             |          |
>             |          |--8.76%--_raw_spin_trylock
>             |          |
>             |          |--7.03%--__preempt_count_dec_and_test
>             |          |
>             |          |--4.57%--_raw_spin_unlock
>             |          |
>             |          |--1.96%--__get_pfnblock_flags_mask.isra.0
>             |          |
>             |           --1.15%--free_frozen_page_commit
>             |
>              --0.69%--el0t_64_sync
> 
> After:
> 
>     23.57%     0.00%  cma              [kernel.kallsyms]      [.] free_contig_frozen_range
>             |
>             ---free_contig_frozen_range
>                |
>                |--20.45%--__free_contig_frozen_range
>                |          |
>                |          |--17.77%--free_pages_prepare
>                |          |
>                |           --0.72%--free_prepared_contig_range
>                |                     |
>                |                      --0.55%--__free_frozen_pages
>                |
>                 --3.12%--free_pages_prepare
> 
> Suggested-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>

LGTM.
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/page_alloc.c | 18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 6a9430f720579..2e99fa85cdc8e 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7020,8 +7020,22 @@ static int __alloc_contig_verify_gfp_mask(gfp_t gfp_mask, gfp_t *gfp_cc_mask)
>  
>  static void __free_contig_frozen_range(unsigned long pfn, unsigned long nr_pages)
>  {
> -	for (; nr_pages--; pfn++)
> -		free_frozen_pages(pfn_to_page(pfn), 0);
> +	struct page *page = pfn_to_page(pfn);
> +	struct page *start = NULL;
> +	unsigned long i;
> +
> +	for (i = 0; i < nr_pages; i++, page++) {
> +		if (free_pages_prepare(page, 0)) {
> +			if (!start)
> +				start = page;
> +		} else if (start) {
> +			free_prepared_contig_range(start, page - start);
> +			start = NULL;
> +		}
> +	}
> +
> +	if (start)
> +		free_prepared_contig_range(start, page - start);
>  }
>  
>  /**


