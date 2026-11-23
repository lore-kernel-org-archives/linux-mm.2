Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52763606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=vkAEmZUc
Received: by kanga.kvack.org (Postfix)
	id 548086B05B0; Mon, 23 Nov 2026 03:21:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51EF26B05B4; Mon, 23 Nov 2026 03:21:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45C286B05BA; Mon, 23 Nov 2026 03:21:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 230736B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:21:29 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 955C61A07DD
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:21:28 +0000 (UTC)
X-FDA: 85465689456.08.81B5160
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf06.hostedemail.com (Postfix) with ESMTP id 73900180003
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:21:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vkAEmZUc;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795422086;
	b=HcPr3QRcBAj8T1DsqSogyjJ3PzG8MuhaUR/brpg6YcOmRKcbK/7ixNkllwumnDxng+zR40
	JQbHLhxJM1q3x4FWx+M8wQ3LBYp9lI0Dpm4Of/8T1Mah1mntL+EeCsgEizKbotFp2MPi/g
	P1irMXPgsf9bXNBXVT4lG/WuoOuXAIs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795422086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NsGN37ONxhWiQHsuGTHmCPtePmFZQ90N8jgbH9R3tjs=;
	b=SZa/Qy6lPvRERHnE/NIx6XhQojLBe3HK9Z9+S1Sfpm7hcs8erlzN0fvGyEMxL/hef9MUfJ
	5T7RWj8yrqooEgMzGRjIJRsLgSPDdCNb2ZR9geRGXYmfyL0F0QrlhtLf+M1VxUGBrKhV2f
	n1tXsjMdD6GdBAK3VSIBMfr137/b1Cc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vkAEmZUc;
	spf=pass (imf06.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=jFAjxaLybVulQPxCbHrlgyE2DA1FJX+f642lA9A44iM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795422083; v=1; x=1796026883;
 b=vkAEmZUcXYkIQJ9hICBvhjRzH+Sb5JvwVL9/6oE4EhLf0nUusrSTAnWPC8XkzVAeSZ1XMSTk
 7hM+eGZn70MF4lVAhU4AlbdxGCZBuv5VJc3NacMS2PSnGJLvb7GP34UQPuNlmNd/QRcUo+vxGB9
 5vf22GmvaSkGPK8cLrq1OXTw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 09738cf93fe26e03;
	Mon, 23 Nov 2026 08:21:23 +0000
X-Mizu-Trace-ID: 09738cf93fe26e03
X-Migadu-Flow: FLOW_OUT
Message-ID: <4570f62a-b85b-442d-93a4-075cf7c59717@linux.dev>
Date: Mon, 23 Nov 2026 16:21:17 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 01/11] mm/mm_init: verify zones for
 template-initialized pages
To: Muchun Song <muchun.song@linux.dev>
Cc: "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
 Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 James Houghton <jthoughton@google.com>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-2-songmuchun@bytedance.com>
 <240018e0-02c1-401a-a979-3f867526191d@linux.dev>
 <10263c9e-2d58-4149-a3c4-df9cac11b041@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <10263c9e-2d58-4149-a3c4-df9cac11b041@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: 73900180003
X-Stat-Signature: 3icprthaixcmjn9rethtgchzfcpgbc9y
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795422086-708052
X-HE-Meta: U2FsdGVkX18+HT0v/vCQLokVlp5jvNB5ZQmbIWCw9urOYABJKFR18Unj22xNcMHkLNm3Z5ZlujSoLLUSdNb0XGTb69BolH/faBkZ7aXKWBhmJQ4St3Awf0kiUTGiVga/xhNHsVtHNEvwwFYiNjjtNFTjDt1EN9XNQ5rXFZCg532wv1PllFpL2XiC4LHSKo4ygvzHpJrFSttt3BbNZ12M3eqLzW/7CiuyfIE2glVQaXluJDwaQTLk2TQZWAN9U1E5kbMuJfSNCUnr/91ZIL+v0Wd3ATftXvgZxFAErZW6M2mb7t5KtWq1lHW2KJj0pDAQo/P5DJUuz3F4VNUlmvs7UOqxtKSx3L6TPjaKLpNcIl6sYjNHTgKZrvVaqlAcw/VOv+tPySDhwmsHqSE00GQmGXxzwVwoLWaIYC9l6HxuVvnIqjYPIe9Zr3jUfXx0QVhN8BWWR17IkDXqNBcymaph9xdVf4tiuZuinIGbxXIh/O04b9qzb27RAdBZxONftU7qQNNEdXTvGmRWm9TDlOBbxRigAI6eG3/8eW1m6YJ0LdsdE3ZzCvhHlIFZavb3W3PkJWFOUVpu4n/NqsZvUIwdGSHgpj8J9TTJdFY1yPm4CdN9zskk7vNoFnG+5TEz5gI66VZNpwm/9uxM/m3u1ptUhfmarKyrw/PHqprneGA2x1CFq3hVV5PrsOU8RhoZ9z8z/x3AKT9FYJB+BaiiJbeX0uLSPmHHnMseFTkJ20o/zTjpNjjxkUXPQIGxHThkldJWL/kcnIrbXh9Hvv8b3LunWvZGOjyz7EZHiWttOAV2wwA7BvjXXDic/Bv0LNWD73UyhK5NGT0fuXVf6fk/b2PGHTc9aVAzkqp+Kdwxq57A5Q1YyMDXXENyqnr3d7a2nLJBM9YHr2IohAksxmb7BObUEpGxSue7fBMiJPexHDosczxoh6h+GJvrVwp6W5+Yj3+fOAHC4r2bn6Oqvb9huPR
 0GTqvknn
 2fnh90l9CfH2YDGUSlicGIiiq/UxiDF6g5JVt7qbQmayGTGWfhLIX0T0TVddUlJCHDNtYUDwx/Rx9PJElTXEHUopoFwC6ig6EiyRLaGn4a9o0NvzpSepdt3Xl6P0/M7e3EpnXTZq9MYRCbTsTC2aNnMu1BFaAVUrTYneNxz0r/WYU1KzzqnM1PSOGtisgiJlSDdsW5rmEiB5QWwKZQ/o1L1GDgv5/hTLbvck0LwTplkII5OKxxh52A0IMi71VOQLC1o/kAzjwQUrRJMUjeRrkVaahBbJ6pyus77I+y+XlB6Ft2fabqYq7q5IiP25/KUvDKePtO6PaZPqvmDIAGcz0vqTjikERIQtdGwgdC0g76CVng9CNdQXk87tPo6kQj/o8NN+Ob/KPlOa5eopq7mshOxEPECSKp4ZjZlZhVX1czuuClXH8644HHce0zh3FXb1PYP4rMtIHNaSk8EXX+gV40G6sHzUE604eZ7qIvGCVYDiCfvDNP2cuENTkp8NNUgeHCDA9Z3Fxg8FG+fLfvp1bjOOzgFcc21t9XBa5YkxhexMeGM+mnijQWILjgCs9vb3HHOFfABWJ1JvoC2ehVz7mFZMl1zUr3c8NP6SyBzxMTJKSQVc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/23/26 4:15 PM, Muchun Song wrote:
> 
> 
> On 2026/11/23 14:39, Qi Zheng wrote:
>> Hi Muchun,
>>
>> On 11/20/26 6:08 PM, Muchun Song wrote:
>>> Template-based ZONE_DEVICE initialization bypasses
>>> __init_single_page(), which means copied struct pages do not run the
>>> vmemmap zone consistency check.
>>>
>>> Verify each destination after copying the template so the fast path gets
>>> the same validation as regular page initialization.
>>>
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> Reviewed-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>> v3:
>>> - Retarget zone verification to
>>>    zone_device_page_init_from_template() after integrating the helper
>>>    series (suggested by Mike Rapoport)
>>> - Collect Reviewed-by from Lance Yang
>>>
>>> v2:
>>> - Apply the zone verification in memmap_init_page_from_template().
>>> - Collect Reviewed-by from Mike Rapoport.
>>> ---
>>>   mm/mm_init.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>> index a9d848c92678..0129152b74d8 100644
>>> --- a/mm/mm_init.c
>>> +++ b/mm/mm_init.c
>>> @@ -1082,6 +1082,7 @@ static void 
>>> zone_device_page_init_from_template(struct page *page,
>>>           set_page_address(template, __va(pfn << PAGE_SHIFT));
>>>   #endif
>>>       memcpy_nontemporal(page, template, sizeof(*page));
>>> +    vmemmap_optimization_verify_zone(page);
>>
>> For PAGE_SIZE-aligned devdax, dev_dax_probe() leaves
>> pgmap->vmemmap_shift at zero. When section_activate() populates a full
>> section for this pgmap, it records compound_page_order = 0.
>>
>>   memmap_init_zone_device() (pfns_per_compound == 1)
>>     -> zone_device_page_init_from_template() (each template copy)
>>       -> vmemmap_optimization_verify_zone()
>>         -> pfn_to_section_compound_order(page_to_pfn(page)) returns 0
>>         -> vmemmap_optimizable_order(0) returns false
>>
>> With CONFIG_DEBUG_VM and CONFIG_VMEMMAP_OPTIMIZATION enabled, the
>> section-order lookup runs for each copy. The zero order makes the
>> condition short-circuit before either page_zone_id() call.
> 
> You are right, but we really don't care about the performance of a
> debug kernel.

Yeah, it doesn't really matter much in practice.

> 
> memmap_init_page_from_template is used to init a single page, just
> like __init_single_page does. Therefore, in a sense, the template
> version should be handled the same way.
> 
> So, what do you think?

Acked-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi



