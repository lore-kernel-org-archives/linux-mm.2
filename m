Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7745C606A89E
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 10:55:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FVc++JR0
Received: by kanga.kvack.org (Postfix)
	id 9A34A6B05B4; Mon, 16 Nov 2026 05:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97A766B05B5; Mon, 16 Nov 2026 05:55:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892326B05B6; Mon, 16 Nov 2026 05:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6556B05B4
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 05:55:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DEC751A0904
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:55:50 +0000 (UTC)
X-FDA: 85440676860.06.8F41895
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2578A20002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 10:55:49 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FVc++JR0;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794826549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kmQvt1UCbjuMhtpN4OiUXlJWOrQfIZG1i7NH6rxNLIQ=;
	b=VnNwWAfSaAGULGU1lF9i+74NA2fBGbTG1jxFIND5+0V0Tc/ehtRqG+G9TBzrSsJ5LiL9yL
	WvsjCmbYPo7qvo4T6q+mwDib8UHogtviaRanUgX3pvkTe8zbs99YFQAU03GinO5Wmujdqv
	/t9Y2Yw9Rlw2gkERRGQEMyp4OWAt5yw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794826549;
	b=YqVbpzpMXOorHA2FlyC2r15FxMa3hYPXXj2XOKS/v36KB5LlSJwthn0aeeVJkqZofQNgh8
	Bfx7M8BAQRl+xwmgXlf9573Gd4Y+A3e8PQDxL1rY3kwf8qJGaZHxVVitkBT6mQaOpwTAuP
	IXtIs4pAGXYeAzMbkxhjBFsAyedDA4M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FVc++JR0;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CF10461B2;
	Mon, 16 Nov 2026 10:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8052B1F000C6;
	Mon, 16 Nov 2026 10:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794826548;
	bh=kmQvt1UCbjuMhtpN4OiUXlJWOrQfIZG1i7NH6rxNLIQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=FVc++JR0UFlf7jLyOMMTzAI48mqJyJjV3G4SJDcE0txQcYOrgpGg1+mb3iNMcdkgN
	 WMSLi1KndEhtQ1NjgPR31/+w+ZgFWNtuQZY8pCW7mNUSD3HxuaOM76GDqtTGay/EIA
	 Gr1ptuVEWgJjLEhfKWmlhV266LrWJkUaljCDV3ewocUUSfgd2WDi+vK1H2CbyLPmJB
	 UZ/1BhXkzhdU9uOYKTFYhyFxHScm/R7e6Pq1WxnroZruyDfFZMh+62apb3O+Ji2UVj
	 nsPbQ8NIwFm4OuvWMgVv0wmYNnDAAtGrxf5rrwt2/UXl48mSuAJkIB0E+XaeMk4wxM
	 61N3tN81JRyLQ==
Message-ID: <505e53ac-6720-431a-b272-bc5bd593b0d6@kernel.org>
Date: Mon, 16 Nov 2026 11:55:41 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] mm: page_alloc: add a watermark check that knows
 the migratetype
Content-Language: en-US
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Dev Jain <dev.jain@arm.com>,
 Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
References: <20261102093939.3340540-1-kas@kernel.org>
 <20261102093939.3340540-2-kas@kernel.org>
 <7e82bf2d-3a36-46d4-b63e-6b6720620380@kernel.org>
 <avrVAUGFUJdoVRG7@shutemov.name>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <avrVAUGFUJdoVRG7@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5c8c8gynq9gnj6eganm5uxu4cah7yrfd
X-Rspamd-Queue-Id: 2578A20002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794826549-72963
X-HE-Meta: U2FsdGVkX18e2E1XjT0/Pa78kb836vfbQy1tBQcHMkyGgssoooQIAV+IuFtje6x4uvlhP6CWcvYfHh8fhKjOkrsQvWFKq2b1UVfgtVqKvrbvxPmokl1FmnvGhnZVCj8lxlitvViNqOpJjb/pbFPYIFPvwbD6tLtWCejBEpcz5/RMrmFDME1mMxd2r2X07xB0gPl0RwZw84Az/4s8V+fePlBot/I9GrTDX1Gt8wJO0BAE+LZc5IBkcnZYNe9qJm5uY6JaTpcDQEIITCQVm2pWqOFINdiW2SNvQnGWeRwaAnT9L2qbcEhxdlD1pXkUA067emOBHLFCP3FiNsMK1kaoXaUjT+alQPIVBXwdD4sEK05Tw0WBaXYggJ8lNmWddlBA+oTkH8+o0aIVy+fHahRl6BxuWmV2QT+D5zTRNkW6wisFVNy4OLkS+yXfefgLqgX1z1YRn0VAmcdAN1PwfKXaP/7D9f4EJnq9CfgC9uze4C9Lz66DPN3x3MVVlWIw6FmFiSt1RwxpZN4pYezC0aXz7kBmR68jZyAyrJf1EhLYmvjG2yQVoNFkuQ/9DLB/an1xB2hSeQ+QRTlwuALLi6Y+mcPHjndiwRRM62ydHRwDnaPijNEdBpHG/OYfdXJEf152g0tVBjwlT8eFmylujA/u3xMroZ52Iip+0aPZmhOs21ZHUMe18mdp6uBvLwYGeqLhtE7576/gme2/GBKN2ik480+NCKQnIs8jKr91fueamWjpocgDqpmDnj3zgvVx/tS3sCOMr00shOLbErJIyrceVtSAv5p1MIQx9EX3q0T+KudSGgjTEg3j933fWhsb5iDB+cE2um9t9pKjTYS5kraF15bFZTTJEq1/5kFNAVa7RienFbhRDzondYbf0EgUZHGjxThbGIk2a1m8Az1ApGaXEbgmZertStULDxgThDYLQCPD1mqFP1Ixi8HGfWnwgR1U+52Ih7y9caEZ2jf0Th8
 zmCGg/UJ
 JAiu3t9FN4YP4alpLYk/6uzK1HlQnVwI73YEKBPjl/XWkwepaKHQuJ+zmYHYlV36+WZyYTQZ+6Rjxr2c7dwcbtoHfS1k8lTreLDWSR3FgTNYODnQiv4OgCH5VYKMasHFyihyHE3WBvUXqRzMmhnd54AblLRHI10pNQ8k5JQn0UM+RT2YEplXb0+/3vY7Y4qD2bcF+PpYkxq/kye+EfS+12ERk/SkdOW8MmO1y8vwy9RVCcbHgeBzMYxCr6yntbnjNmNWbAkKMypMBEQ+cLv7hUR+PFre2Lrv+rRxtg8Y85WfWipopXzwa5+/TLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 11:41, Kiryl Shutsemau (Meta) wrote:
> On Fri, Nov 13, 2026 at 05:51:52PM +0100, Vlastimil Babka (SUSE) wrote:
>> On 11/2/26 10:39, Kiryl Shutsemau (Meta) wrote:
>> > The high-order check in __zone_watermark_ok() accepts a free page of any
>> > migratetype.  Under ALLOC_NOFRAGMENT, a request below pageblock_order can
>> > only take a page of its own migratetype or claim a whole free block, so
>> > the check can pass when the allocation cannot succeed.
>> > 
>> > Telling those apart needs the request's migratetype, but not every check
>> > wants them told apart.  A check whether an allocation can be served now
>> > has to count only the pages it can take.
>> > 
>> > A check whether there is enough free memory counts every migratetype:
>> > kswapd and kcompactd balancing a zone, order-0 thresholds, the
>> > slowpath's forecast whether reclaim and compaction can still make
>> > progress.  Reclaim and compaction work across migratetypes to free whole
>> > pageblocks.
>> > 
>> > Move the body of __zone_watermark_ok() into __zone_watermark_ok_mt(),
>> > which takes the migratetype as well, and make __zone_watermark_ok() a
>> > wrapper around it for the second kind of check.  These use the new
>> > function:
>> > 
>> >   - the allocator fast path, zone_watermark_fast();
>> >   - its recheck after node reclaim in get_page_from_freelist();
>> >   - compaction's up-front check, compaction_suit_allocation_order().
>> > 
>> > Declare both in mm/internal.h: nothing outside mm uses them.
>> 
>> Why not mm/page_alloc.h instead, now that it exists.
> 
> Ack. Will change.
> 
>> > @@ -3665,6 +3666,21 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
>> >  	return false;
>> >  }
>> >  
>> > +/*
>> > + * For checks that are not about serving one allocation now: kswapd and
>> > + * kcompactd balancing a zone, order-0 thresholds, forecasts whether
>> > + * reclaim and compaction can still make progress.  They count free pages
>> > + * of every migratetype: reclaim and compaction work across migratetypes
>> > + * to free whole pageblocks.
>> > + */
>> 
>> What a slop comment, sigh. Can you rewrite it normally?
> 
> /*
>  * Return true if free base pages in the zone are above 'mark' regardless
>  * of migratetype. Use it to check whether the zone as a whole has enough
>  * free memory. Use __zone_watermark_ok_mt() instead to check whether a
>  * particular allocation can be served.
>  */
> 
> Okay?

Yes, thanks!


