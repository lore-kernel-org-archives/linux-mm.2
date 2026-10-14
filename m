Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E04ACC6B1D
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7531D6B0099; Wed, 14 Oct 2026 11:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 705746B009B; Wed, 14 Oct 2026 11:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6415B6B009D; Wed, 14 Oct 2026 11:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45A016B0099
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:19:48 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D14AF1205D7
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:19:47 +0000 (UTC)
X-FDA: 85321591614.30.BE9973C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id AF8111C000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:19:45 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ekmv/T98";
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791991186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yXZyrbOzuLOjV4K9OXFnFI9ZAhWsGSTIgoCMpL2e/VA=;
	b=4HobGDGlUsJFLpJReZLAvqVCU5Z8ME5l8/sB0fCec8lMQEcfaPttWf6enyeB009xSi4Jf+
	5JIFfWa9YW9lPi9pJczn56K1++xw127vnI9eduDoQMa1v5ONRnif4d9AhiZZnfM9N1ooUO
	NmFJ1MhWZ7VueXJntSfm0yre3op1hZY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="ekmv/T98";
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791991186;
	b=Ffyo94W0/D8+AWhle4Vh2olzyHstowy1CNtFGhnCty814lVHwEU3tgWyHGA1pdojCxn/o1
	X0bdhPCGlXSyEAQxYICzwDaDru9BBwBaelyPx8/2IYbwX5YUCeJnBhiGlGGvS3Zp0W85YH
	z1VD8bLpbBo4PE7SOqTGVDZK91qeekM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3A90A1570;
	Wed, 14 Oct 2026 08:19:41 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B3D203F7B4;
	Wed, 14 Oct 2026 08:19:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791991184; bh=G2zxJe7GkogARtt1gntYhVDlCaUhHR/DtdzwRUUPBoU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ekmv/T98bpIvaHBhsd3Np8JFa4AXGh0U8naVNgmgRHhXbADZG08EVfjO+LBvGzXaW
	 5HWbLznXThc2VrsN8RGBFCjQCcWCSFXQysQtIzsh84Fn6B6l7KGfLOUAQwQdnOBfeM
	 PkWzuET0KheocgrkI7o5YrHPLaG0q34frAxnaCJw=
Message-ID: <7b547b9b-3b30-4486-87ba-c9ff0e2dab56@arm.com>
Date: Wed, 14 Oct 2026 20:49:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/5] mm/page_alloc: count a merged buddy's pages under
 the merged type
To: Rik van Riel <riel@surriel.com>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org
References: <20261007021250.1665929-1-riel@surriel.com>
 <20261007021250.1665929-3-riel@surriel.com>
 <55f51fb8-9777-424a-b45f-a6a5bd9a4693@arm.com>
 <038db2e68469e74077264a490e104391bdffe35e.camel@surriel.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <038db2e68469e74077264a490e104391bdffe35e.camel@surriel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AF8111C000A
X-Stat-Signature: 1w3fb7sunwze19jubf9wjhkj9qnoxseq
X-HE-Tag: 1791991185-999503
X-HE-Meta: U2FsdGVkX1/3/uyWyVB5IVRZwWqMjCimtyrjGChzIpQxgCtYVZPmasPZP6/yXvMwPPX+jaTMXKr5ITGPeUBgBzcgwLk85rE0c7sUC1p9uY359ZnMFjr8illvbYvmvB5DTs3SeVESB2ZMBniK0sgCxi114RtWnHy3ZrM4YnUV/PsHnvUeTZK1Sb4E7eeokBeeWoiDZVVUKYaZAtzR/Jirk9M6iiko7oz7Q7ugBYVPdOXTcgYak4AZevli+1iQGI9LbGu99kQIPvmC2usMWj51WSAjO+FA5vBRG3UGMs5u92H3jEFJNpYLjtquDlEWjBnSWpS2rksH1Lpl8ZPQxCKKu463/cKcs5UUzubO1Qbp8nqDthPncnWm3L4uIqDty4Poha4tOxAN4Ftmmv5Tq9gk/mMnGVHQZ7QzRbs84Kv3HSQBpziZ/JcbVHVf8L44956IaHrS2MjMi/19/0G1+7SKIARSnJdY+xZ7W9wbYmrjCyC/6M9xKCd4sRU+5TM1VQGG/hvFRtTFwDTAyIgcJ/wI/YPupZCSvcUiMf3mUoio+VuHWQKoKZNWYV9PyRUMpq16oMwMpR0U1NlMiTYh7Sd2RRbTe/1vpylRcC5uOc6JmwFcTJtauiaexuV4vuaftvM/NWA0hmG0NiARS5oGKAXdFDAMNT4SvCncgI9xAh7efUr7HfynbZ9zXlhYEMmEwYfqUUW6yrp4tLjHU3kncxT7E+XyETOs4e0JCVt86NXoRgfujPLGwCdCvxp9F9DhvNFzjASuH+2og6emD76HkqudibwZ8ozvrmxKFGDKBhUJ7PYJHm1lnSLuf66uVlyJAdn+eb6PwiazpvLCc9Sm0SRF2bnI6keXnl62/0L9/3em951cED61mm5MTnyGezWxdSrvtsLoz9rCiBwbyg7t2k7zoRp4NtqaJF7hSFUT75Y2/tgc0TaEAMZ3ZcsK64fmY0SoDfCV6eylw7AdmhRVWeA
 yB4m8Nci
 gL4a4Hm/Ntjj9HQgOylRukPvuf4MGOwPCBQ24VJYhNbcDSNI+OBbkNfgA2M/QEoD75VoBVqr/95TAgJ6ugJg6UyUcXOfq/UuUbazn+Oy1M1B9uStKoBYnO26KLJEuNb+FBOpBLPgLDMX+eDcGN1w1o+77sH9HvuSR0IHt5FpSho5oGyY64gi+yiR5hzoNmCoUxgvfj16hMSSaOK7pa/SMOevMQD2CH/2mD9727Jdgc5KuT8MCru/xUn5T6uEhPEw7i1hzkXPG+Dv0nLKYdEcaCtEfayTj71JEm4Im1mmXvbNusA1MAcVPVqqbuUxWJz4TfvTkPW/643bj7CcnLgKob/P/bfqGb3b8NIqcpo0i2FNdey9GIdGrMVINIXMlMEHt3XI6EaZvZ8Q/Lpu0dylJAseAOKGlsCV2gid4h8aEcoy2K8A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 14/10/26 7:57 pm, Rik van Riel wrote:
> On Wed, 2026-10-14 at 19:46 +0530, Dev Jain wrote:
>>
>>
>>> +++ b/mm/page_alloc.c
>>> @@ -993,6 +993,11 @@ static inline void __free_one_page(struct page
>>> *page,
>>>  			account_freepages(zone, 1 << order,
>>> migratetype);
>>>  		} else {
>>>  			__del_page_from_free_list(buddy, zone,
>>> order, buddy_mt);
>>> +			/* The buddy's free pages join the merged
>>> block's type. */
>>> +			if (unlikely(buddy_mt != migratetype)) {
>>> +				account_freepages(zone, -(1 <<
>>> order), buddy_mt);
>>> +				account_freepages(zone, 1 <<
>>> order, migratetype);
>>> +			}
>>>  		}
>>>  
>>
>> MAX_PAGE_ORDER > pageblock_order confuses things so much : (
> 
> I'm not a fan, either. It trips me up every time.
> 
>>
>> Sashiko raises something:
>> https://sashiko.dev/#/patchset/20261007021250.1665929-1-riel%40surriel.com
>>
>> Although feels like it is exaggerating.
> 
> I suppose if we switch the two lines around, doing
> the increment on migratetype before decrementing
> buddy_mt we could avoid that transient underflow?

That would become a transient overflow. See below.


> 
>>
>> My concern is for systems with a high diff between MAX_PAGE_ORDER and
>> pageblock_order. So on arm64 systems with 64K pagesize but pageblock
>> size as 2M (and PMD size 512M), the pageblock order is 5. We use this
>> configuration to reliably get TLB optimization from contpte size
>> mappings.
>>
>> Will we then repeatedly overflow the pcpu counter into the zone
>> counter,
>> regressing stuff?
> 
> The per_cpu_pages struct does not seem to keep
> counts on a per migratetype basis at all. It
> has per migratetype lists, but only one
> pcp->count.
> 
> Also doesn't the pcp only carry order zero
> pages currently?
> 
> I don't really understand your worry.

Sorry I was not talking about the pcp list (also, pcp carries
order 0 till 3?)

In __mod_zone_page_state, we use the per-cpu variable pcp->vm_stat_diff,
and when it overflows or underflows past a pcp->stat_threshold, we
push the diff to the global (zone) state.

The reason we do so is to optimize by batching zone operations into
per-cpu local operations.

My concern is that for large delta, we will always overflow
or underflow, defeating the purpose of the per-cpu caching.

So on said arm64 systems, we may frequently enter your

if (unlikely(buddy_mt != migratetype)

branch, and if pcp->stat_threshold is not enough, we may repeatedly
overflow and underflow, defeating this per-cpu optimization.

> 
>>
>> Perhaps I am overthinking. Your approach is clean, but perhaps we
>> could
>> also do:
>>
>> void account_freepages_move(zone, order, buddy_mt, mt)
>>
>> 	/* PCP-types do not have per-migratetype free counts. */
>> 	if (likely (buddy_mt < MIGRATE_PCPTYPES && mt <
>> MIGRATE_PCPTYPES))
>> 		return;
> 
> Wouldn't that throw off the counts when we merge
> e.g. a MIGRATE_UNMOVABLE page with a MIGRATE_MOVABLE
> buddy?
> 

As you said, in account_freepages(), there is currently
no conditional based on MOVABLE and UNMOVABLE. So we
are essentially doing -x and +x, netting to zero.

So we could write my function, make it clear that currently
this is not needed for the MIGRATE_PCPTYPES, as opposed
to MIGRATE_CMA and MIGRATE_HIGHATOMIC which have separate
accounting.

> With your test we would only ever do the free count
> adjustment for mismatched types if one of the pages
> was HIGHATOMIC or CMA. That leaves the common case
> without coverage.
> 


