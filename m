Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 668D1C44512
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 02:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A2246B0088; Sun, 19 Jul 2026 22:46:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47A216B008A; Sun, 19 Jul 2026 22:46:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390D46B008C; Sun, 19 Jul 2026 22:46:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 013B06B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 22:46:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 749068073C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:46:20 +0000 (UTC)
X-FDA: 85007616120.22.3B3B61D
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf03.hostedemail.com (Postfix) with ESMTP id 044DA20007
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:46:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VthVF208;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784515578;
	b=b6DK88jFm2g2+HY057TL7K1B/ygCjOdMV9ZM8G73A8RJbh52OHS7jqZzA84ZJXBx4xV7EC
	UqpslBitzx51wZVZzdmXSVAvrqaVuIVTN2uEkJlTJY+826H8qYaqmIJzUqouzK+7dQNV3G
	YakPfEv0B7agvMDpKybgTt5lGHGSoRE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VthVF208;
	spf=pass (imf03.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784515578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QXQ5xmSSPrBQjMJEqhXYcrMLUG5j6Qkd/yAMgAIwkNw=;
	b=fVFKdx7xwHIZVMO3PuImmUC686JFgh3SRmQeiuiDbwGRml6DhSOGVlW+27tUH/wDauTzaI
	l37dwaMGtoZlCNRU9RDAi7ce5SVzglIeddsrWoGFO5CXleOeQXVv3f6LrKDKSW3Ap02ST+
	pBndovS4BoIdAOwuFn5M2F5j2Fifhy8=
Message-ID: <e3f17e17-495e-423c-9c21-48aace4367d1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784515575;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QXQ5xmSSPrBQjMJEqhXYcrMLUG5j6Qkd/yAMgAIwkNw=;
	b=VthVF208Rz9Zsj4OxKww1Mh1aAqYZh8ODArvhqsNu/s9Ske8sgST5cTVQhcrBJSwI3uBXA
	8JB3rppGUV3NYJ1/DPE/YZSx27jeYEnZxvFC9vJU/oQaZecnU0TYfcouoK5EtVUvnMZeDp
	20xvsq1APwou9w69K59p8VOMpwoy8r4=
Date: Mon, 20 Jul 2026 10:45:56 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v6 9/9] mm/page_owner: use memcg_data snapshot to avoid
 TOCTOU in print_page_owner_memcg()
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-10-ye.liu@linux.dev>
 <21007313-40dc-46fb-bbf2-453c8eedf3e8@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ye Liu <ye.liu@linux.dev>
In-Reply-To: <21007313-40dc-46fb-bbf2-453c8eedf3e8@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 044DA20007
X-Stat-Signature: ozd4rpr8sbzccnsw8e6mmrp3jcksedn8
X-HE-Tag: 1784515576-877281
X-HE-Meta: U2FsdGVkX1/UxwyiAaCfag+6Yijab6/Dgg5RsrbKhjBLDJcBd3GRW5oQzo28TBeijkgNRj5CchxP/RCE+bQHQsghckY/U20oYMtiEKya4Pk4nRcYbYJIRxF8kr6YkRiK1BywFxcpjTS0Z7CfFXndwLS3c2pt9b/3sFVuPFCY4AxzzlSNDs6uKphAE8Dztu/THb8FSXCrKg5lP1Q/71e4uncrATMx2JgBNXQUqz44w7uJQhBx5y13oSzwwPIEBN00ZLqxXzvwXr+54iJ1m7V1yiba37jiAdV/YEuIVoVplqEOtWd0cgHlwK6oDfXBgWeHWAfWHitwbquVBssoUF37kmMPxldwm3BXZ0pO70Y3Zu7OoNg92/bR4xt6qAWdkv/eKnvJGCM+HB8L9CrNKHf5ysM0QDpcokWlcP2QwYuHOEmBgchi/5zRIxRo5wOQzqZslBPVH5MVOlFzLHBNE55tM0OXxd2nVt+srmLXBLTgkXTmcia3oS++WTvE67Ebbeq5EH5lEoi3dftOFO8FJxALqz/eRVjv/BvSB0Of/33LedZ2T2CnKKfEUz4XEVeJ0hwVhH3qvXeL4V2qQq9PXyZ/l2f44UVb1FeXiqKldTcahc9p9UFsezDMwpIC4lFcwY55IndBwxd1sIsec5PUE8REPU9bFls85KoLvMzC1+iCXOEmIRk2DREQLt2fDs1vaeUpXHybK5MZauE8UXAQCGPj6urJgkK7Gx5w5ArzMALcNXP7iaJzKbOAnIBA57fZxT1b3uuCd2IOV+K98FJ/a0Q98b28Xqzca9gvGrFLQweuA94Ptzr12LZYDCtE24lFyyc3ipX3Msho9mIxfNPLmGKBbRGyQCFTiaIprAeP2XKS96XCBTs/UdfUGjtHD8CtSSGeTMcTUGQwrfQ1LdWz4zCf6YUS9DTkp2Er8MzDlvfhNLqUQ3GPCPttvkMoDqZorQk+lgHslbNrvNT56SEJlFy
 WgVQTRwo
 cxmKTiLi/7yalACg9x6Ua9ucvnnDS73rehW1c/B0q0u/C85Va7mH+e3CmRcru8qhKgrNe6BsORDTMwXqwUp9yWtA4f2G1hdNPP15NwwokGp4HNoPYpvVsvFycFvoYP53p4tkpp73pb5Ve2ttJ1xRhoUuAlizD9QwSFfjQH3IQ5EGAp2sZaZ8pkb0XdYTTqFfTWp+zYVcUEFPNKTwYfmwqQqd4GWw7Gp36MhfeErvK59F7rTBOewiFruG3jgdL/rVSS477Ug+bJPjCyGY5CjoeLDr40n6hRPHhBg6BB1LwAYIWGkS2BX5lF9I9UQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/7/14 16:24, Vlastimil Babka (SUSE) 写道:
> On 7/14/26 03:51, Ye Liu wrote:
>> print_page_owner_memcg() takes a snapshot of page->memcg_data via
>> READ_ONCE at the top of the function and guards against tail pages and
>> NULL memcg_data.  However, it later calls two functions that re-read
>> page->memcg_data locklessly:
>>
>>   1) page_memcg_check(page) — re-reads page->memcg_data;
>>   2) PageMemcgKmem(page) — calls folio_memcg_kmem(), which re-reads
>>      folio->memcg_data and folio->page->compound_head, wrapping both
>>      in VM_BUG_ON assertions:
>>
>>         VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
>>         VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
>>
>> If the page is concurrently freed and reallocated as a THP tail page
>> or a slab page between the initial guards and these later calls, the
>> VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=y),
>> causing a kernel panic.
>>
>> Fix both TOCTOU issues by using the memcg_data snapshot throughout:
>>   - Extract objcg from the snapshot via objcg = (void *)(memcg_data &
>>     ~OBJEXTS_FLAGS_MASK) instead of calling page_memcg_check(page);
>>   - Test (memcg_data & MEMCG_DATA_KMEM) instead of calling
>>     PageMemcgKmem(page), which is semantically equivalent:
>>     PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data &
>>     MEMCG_DATA_KMEM.
>>   - When memcg_data has MEMCG_DATA_OBJEXTS set, early-return after
>>     printing "Slab cache page\n" since objcg != memcg for slab pages
>>     and there is no meaningful cgroup to look up.
> 
> These points have too much detail that's already in the code. Would just
> mention that we opencode applicable parts of page_memcg_check() and
> PageMemcgKmem() using the snapshot?
Yes,It's a bit wordy.
> 
>> This avoids both TOCTOU windows and the assertions entirely.
>>
>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
> 
> Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Was all of this reported by sashiko? At least the new-in-v6 was?
> Then:
> 
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> 
> But it's no longer a cleanup but a fix, so probably this?
> 
> Fixes: fcf8935832b8 ("mm/page_owner: print memcg information")
> Cc: stable@vger.kernel.org
> 
> It's not fixing a new regression so I think it's fine to keep it part of
> this series for next release and not need to split out for mm-hotfixes.
> 
Hi Andrew,

Could you please help me revise the above? Should I send you V7?


>> ---
>> Changes in v6:
>> - Rename patch to cover both TOCTOU fixes rather than only
>>   PageMemcgKmem().
>> - Also replace page_memcg_check(page) with extracting objcg from the
>>   memcg_data snapshot to fix a second TOCTOU issue.
>> - Add early return for the MEMCG_DATA_OBJEXTS (slab) case since
>>   objcg != memcg for slab pages and there is no cgroup to look up.
>> - Update commit message to cover all changes.
>> - Link: https://lore.kernel.org/all/20260701061101.344679-10-ye.liu@linux.dev/
>>  mm/page_owner.c | 10 +++++++---
>>  1 file changed, 7 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/page_owner.c b/mm/page_owner.c
>> index 2e3880053a34..e18512a49e38 100644
>> --- a/mm/page_owner.c
>> +++ b/mm/page_owner.c
>> @@ -540,6 +540,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>>  					 struct page *page)
>>  {
>>  	unsigned long memcg_data;
>> +	struct obj_cgroup *objcg;
>>  	struct mem_cgroup *memcg;
>>  	bool online;
>>  	char name[80];
>> @@ -549,11 +550,14 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>>  	if (!memcg_data || PageTail(page))
>>  		goto out_unlock;
>>  
>> -	if (memcg_data & MEMCG_DATA_OBJEXTS)
>> +	if (memcg_data & MEMCG_DATA_OBJEXTS) {
>>  		ret += scnprintf(kbuf + ret, count - ret,
>>  				"Slab cache page\n");
>> +		goto out_unlock;
>> +	}
>>  
>> -	memcg = page_memcg_check(page);
>> +	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
>> +	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
>>  	if (!memcg)
>>  		goto out_unlock;
>>  
>> @@ -561,7 +565,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>>  	cgroup_name(memcg->css.cgroup, name, sizeof(name));
>>  	ret += scnprintf(kbuf + ret, count - ret,
>>  			"Charged %sto %smemcg %s\n",
>> -			PageMemcgKmem(page) ? "(via objcg) " : "",
>> +			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
>>  			online ? "" : "offline ",
>>  			name);
>>  out_unlock:
> 

-- 
Thanks,
Ye Liu


