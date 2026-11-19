Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76C93606A33D
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 00:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=XDFqOaV8
Received: by kanga.kvack.org (Postfix)
	id 447CC6B0662; Wed, 18 Nov 2026 19:28:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41F646B0663; Wed, 18 Nov 2026 19:28:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3364F6B0664; Wed, 18 Nov 2026 19:28:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EF4C56B0662
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 19:28:10 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4CFDBA0933
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:28:10 +0000 (UTC)
X-FDA: 85449981540.26.C9E9C77
Received: from mta0.migadu.com (out-206.mta0.migadu.com [91.218.175.206])
	by imf21.hostedemail.com (Postfix) with ESMTP id F158D1C0002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 00:28:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XDFqOaV8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.206 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795048088;
	b=hX4EzRmm/e15dt//Yge0QCSqXWF1rdw6fbAsKYj4TUdkBWzC0Kaxkmkp/DG4qg3cOCszkN
	fbifkK0t3d/iwH5rvDZ5UtnJqfDes+v8pZUl7WWr16nTsS8OArJHCgeLFJB5F5f3IsLyTT
	qV2YioDkCeREHVzkq+pZZRLvhKG0eUI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795048088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qo523NBLwX8TKAi0GfmUCyFFt+JFHooaYZ5WinHIM7k=;
	b=QHk/2gmiwdcsUXlAVRuWoS5XLPofLi6BUzRdhRj1g4JLpcz2zTLkZGwI3SEa+Yeu7PP9XS
	/+anCsZkcfq8CLx9zSmPx57+ViQV6592PR9uXpr9lCopqSwq+MfBJyXf/LmuchY2HGHDXB
	9v9K3Efc5Qm4121eYGBazQ+IluTqFnM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XDFqOaV8;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.206 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lG/MGcmIGjodLXXmJpU9eLIP6wDLe2Yzh9mLwW1eU78=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795048086; v=1; x=1795652886;
 b=XDFqOaV8aEHSIXVlfKMnKN4sv//zRuvJTprQ2zaMwZFcbKOzWaHSbCWGnmoKm7f6Jh2wwMxs
 aKFKI94mfPhUFeNTCu429vGBOp0KvQNYMJHS/a/IWRfQsD0f7TqjpMYv2GnEW1dsxYcUbmdOauS
 3U8jqa6DDNYMau5W2Ig7yR7o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e3a7dfbf43199f02;
	Thu, 19 Nov 2026 00:28:05 +0000
X-Mizu-Trace-ID: e3a7dfbf43199f02
X-Migadu-Flow: FLOW_OUT
Message-ID: <1c13674a-6203-403e-91b6-7579e4d5c2d0@linux.dev>
Date: Thu, 19 Nov 2026 08:27:50 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/17] mm/mglru: rename the generation offset in
 lru_gen_folio_seq()
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>,
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>,
 Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh
 <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>,
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 damon@lists.linux.dev, linux-doc@vger.kernel.org
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
 <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: z8upe7nq9ti4gu84i8dem3tzqr1t4qan
X-Rspam-User:
X-Rspamd-Queue-Id: F158D1C0002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795048087-179575
X-HE-Meta: U2FsdGVkX1813GISo1ppB/QWaqx6ptooHu1rosQeaH5LOiYC5An0AMYersbj9CA6+o1ueKu/4juo+GiTRsnVXR5tXch383uqWgOEb6v5jI/P9ScqV7gWMN+y/kIUGYlEKTFd3tCF0QHoE4Poupf1RqzT6l+RMPlUU+Z5kXs/6R4RCkc9Tvhrown8HNhwKjRkLbhBkxduWlgUXgdZ3/q75RA1wSuKiuaDJ3MzlR99OIZ9UEBL0SFSrl5oSlmEO+H5h7teXPxX8ExHzcalnBubJdCr7gB6vxn7+0zS97WJv83VZqTKso2VYQAAZC3UyxaVpmuwA4vfxbR1v+ngucXoNekgyw4vjfh5lYAbJflNMMK/dDD+bx1fuPLUi3RGDW+/UXst8WLJISsdJord97XOiqmIiA0hL+W0MWl+9E9wSv5cf60oLza6RGF2rLXM/HuBLYSGrOkcafp9r/44zt3w9cuOyaDYCdcrH2+t0RUMl0OvND9OVfdk4UWnLMfXTgMa3HutT50qJ2JKdiiU1iQ406bhEkTZk3PPVfOafyWZA+J2X5B90ccDzx3blHGYUqZslQe+pqZxDsvYSRmkZWFMg+DGTzfVRzW1LzrWmgVSXMfMKSwrXxPDJZHN0vodQry5W9RcxTx+1WywgLEaXgMOoe8qZMUdnzWpn7N9knNTtwlkz4V+Wa+zvc/JCHsCeeduZv6YGXWRuidygRu/Ao+HcY+dfjvzgfm8fGMZmzhhdVtx6X+Y1GmqExFAiPemuMgNNpmbGV/cQLqRq7/BKEC6a9B+IF/O/nFL0r2Su4OadhLwoJ9NPGnEDx+WKAwxpCPr+P6ZLoVXJYjBM45NoFW+vS4Cdocc5wWv7SrA6kryK9WjR9vK5D4yo+1aIfjKGkZFxI2ESNxKLXraOuasUfC6SOvoZ5Q3b0HYQYYcyhUaMHF4oczx6UGTz5eKOjNDpDHYzOU6+qzntqfrMQjIR04
 L4D8GQ+l
 jGpsRyx2S6MJ0tpaQY5o3SWAzaEbv1/Yi/NPyFUsw0qwEUXOxZpXAdWDPge1hNoXh6Rm8oz9LxMHqIwdpE+JadWewPJkzP6ukAjt6X5tgzOSWNuPdcTw0aWRdafyutYvV8Ji8KTV9iYghdzmFV25ZYd1+jz3+oA3QKYv/ihPpBH3Ku/IYSkJeRlsW1O/tGRxmBn2e+NdRDJ8Ne7LZaXVX8+D3TwzDamA8YTQEZXc5XfpbM7O7GffW3TabzKdYGUx3MURtM53SZIxxYUArb2kqIF578t5Z28gH6nttnWX+p1zo3VF567wLytonKpevDkOXwpfYCFA2fyuaRIJjMNDNuLJJslm4Xld6IH0AFWTyu8IZjL4X5OBpYSPpKtWZdNU2YQjjWjh8aotOihBPLWShkCLEFX/uIiu4O12hlRLjNnQQXa8RMRxBKI7rNBC/4Sk72gMLDc7LXf382nrhPNgDovE6QBxfviatGTUTvMZztXS79Gl0i5rWcFC2jB2cEFql45NSohuGc+z9xmSw17DA4e4jfN5XYt0K6L9nWJ7mk3AQ5rYj7+LqiyBE1UgNmsTlmlWP29TGMJL9XMewufK2QihfDxjKsH/HDC5JKnzZiu8Bhj2DbHNNF/cRqgy3XExrXNa25lb9h9ja2hmJ+D3tcT8NLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/19/2026 5:03 AM, Kairui Song via B4 Relay wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> lru_gen_folio_seq() computes how many generations below max_seq a folio
> should be added to, but stores it in a variable named "gen". Elsewhere in
> MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
> so reusing the name for a relative offset is confusing.
> 
> Rename it to "age", which matches what the value means: the newest
> generation is age 1, and a larger age is an older generation.
> 
> No functional change.
> 
> [kasong: dropped the comment table part, the series rewrites it]
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>   include/linux/mm_inline.h | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index f6f4bc9a704f..2395ca8ee305 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -302,7 +302,7 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
>   					      const struct folio *folio,
>   					      bool reclaiming)
>   {
> -	int gen;
> +	int age;
>   	int type = folio_is_file_lru(folio);
>   	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   
> @@ -319,17 +319,17 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
>   	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
>   	 */
>   	if (folio_test_active(folio))
> -		gen = MIN_NR_GENS - folio_test_workingset(folio);
> +		age = MIN_NR_GENS - folio_test_workingset(folio);
>   	else if (reclaiming)
> -		gen = MAX_NR_GENS;
> +		age = MAX_NR_GENS;
>   	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
>   		 (folio_test_reclaim(folio) &&
>   		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
> -		gen = MIN_NR_GENS;
> +		age = MIN_NR_GENS;
>   	else
> -		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
> +		age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
>   
> -	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
> +	return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
>   }
>   
>   static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,
> 

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.
-- 
Best regards
Ridong


