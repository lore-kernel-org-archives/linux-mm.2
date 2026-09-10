Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90C08C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 07:35:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83AEA6B0092; Thu, 10 Sep 2026 03:34:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8122A6B0093; Thu, 10 Sep 2026 03:34:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72E4C6B0095; Thu, 10 Sep 2026 03:34:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3E6386B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 03:34:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5212BA4C30
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:34:58 +0000 (UTC)
X-FDA: 85197041076.04.3026157
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 9EB7480003
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:34:56 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1aYriuI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789025696;
	b=KP3u6t9T17O/XmL9rZIJiHZbtANfdxUE//DjgSDlnnIvWeSB4o3xKxO4Ss6pGmJfxjQsn2
	xES87a3MDLFn3MdlG3o2iS6Mx6bty/u/xOKMKtTFRMHry3E1D6BlnJnWjIc+ViK6hpte0o
	oJWYzB6ZM5cGA3z8gTid1Aco+1AMJXc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S1aYriuI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789025696;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4CWbYR+JLxhjEFkn3E8IqW/7LBzeZSK+qKtZqgiB7OM=;
	b=DauCLX+3hTyiW0zVYMHSGfdzvEcYxdgXNvCI9p4D9w4LlHJrpszlAFrYe6PhbasrBpQ7aM
	wyvBHqEcAbpQAwONFIi3y9qBDHVskSPGjEe6GpAmJtm0xcQwI8CqTWOxMNW0jpM8EY1wyV
	W9lgYQDSf5Lo2C5Ma2F69wL5v2KF7Pw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1BCDB600C8;
	Thu, 10 Sep 2026 07:34:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EC771F000FF;
	Thu, 10 Sep 2026 07:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789025695;
	bh=4CWbYR+JLxhjEFkn3E8IqW/7LBzeZSK+qKtZqgiB7OM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=S1aYriuIA6tz4mgwaEsKlFV/NuKhCbH9E4gw76QlVDki4uhAeXqLWRTP9gPhiZ55S
	 4uZd793YbTA63LDC5kAxbA8Z4jDJae5iEqCYeY38BNSj8bjOseVTLKUHqPkrf6E8sn
	 H77+2CIAtMWh4529SPPwSA5vW1LhGs+DfN22NujSwLjn8XMpyqfcFhL2ilS9kN66kM
	 sK2hhAEuuRCG/da4Dv0RQlVpcLXkTwdf/z7E1pbcTqy1oM3Z5ci8735qX8++JVmQV7
	 iWRKJLlFBdOEv1USiOYnctrqqLEQfI0agOWUEMTGKq6Im9Zf0L+ubXr1+XEuCGH4n9
	 AXgTGSVPweDNw==
Message-ID: <520b6aca-b515-4720-977f-1adb484f2e08@kernel.org>
Date: Thu, 10 Sep 2026 09:34:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/14] f2fs: stop using PG_private
To: Chao Yu <chao@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Gregory Price <gourry@gourry.net>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Jaegeuk Kim <jaegeuk@kernel.org>, linux-f2fs-devel@lists.sourceforge.net
References: <20260907-remove-pg_private-v3-0-6ae22f9d9272@nvidia.com>
 <20260907-remove-pg_private-v3-6-6ae22f9d9272@nvidia.com>
 <e5792e81-e8a5-42e1-aafe-58dc603f4968@kernel.org>
 <7e11c56d-05e6-48f0-b5b8-b4a0e18ddc1d@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <7e11c56d-05e6-48f0-b5b8-b4a0e18ddc1d@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9EB7480003
X-Stat-Signature: 3m66ccjrbip1mgw8wgg9tfyszfc38qew
X-HE-Tag: 1789025696-981282
X-HE-Meta: U2FsdGVkX1+i5qONQgR1wbLwtJAAKWbl7Kzl4QkcYqwx2f4vDSkPEo3r4+oVyx9iGwj13YcxlPdiC159pXRy++HLp9tknyI1M9lJQCt4cG2tOOPV9mgo5oHPTEWI1Eb2DoRUXLbCXrM63wyPbpyEdTATnYPtWaWrMtcPdXfvh7//zKnsi7NQKgBT+31uWD3SAzWOaYRRC2snPS06RsCAC+6wt0dvUA/C5oNuD9b3Pe29d9TAq9a4UGTz0fnS5LtWK1m4WswwkMYLDFBot9BPbc6DW9YIY5g0lX/uHENqCgb6Q9E8nX0aSN4sEd8U5/Ap38uSRCO+zQLGxs2RlHdah8FS8nQH7wY5C9C5VOPHc+ii2E2MYe+NmFLvOsGvM4yeOe5+ggEgDrCLxHP+XudarnF8ykitBpUXkzjorqsQk6RQcBXc9VXY9iQ+e4AprCGmE93Us759s6Wg4v7Dr0yn9fm+sBFcDKjrne0DBLJxNjx5AWnBkOF2N/um8aeAZRaVlNgdoMTsMCYdsP3+JYRTUA/NcWBQ/IBoanr2ZBbExa0HSXMbeIkrmXXzuSiOfXH9ahishgl/J8tYHE1+S7nXNigrgiC8oSsxWdijc5RllJLwTCYnZIUzK3it3I5WzM/FOa7Cy3TBlUTpHB0TUBclV0fO+nBZIjJS0wHYHjuhAMA2lcDui/GFRqC2pA2nQfM2M5dv38RCHVQgqXr+6vdDSzlP8H3wTnGV667tRtFo0TW0eZCICQ6wxt6PO6iJIiP3RKNMUXiKhJ5wVcS9qJmThZIrMczpsngnNkeTLfKeyRbR470lX7dRcvvRzDZwrAuQOHch1ajNkZUcR/g2u5i0bMCSGCNQNl5c/mkz3NxSILcYodAYIKOsUzVNTA4aydSm1Qlp9Dqv6Ea9rdOewzNem8SlSofc1u9MOPJWxbbnr2WeHaMcyn8r9TmPqrlmqbEg6nCc9n70ZtyO11MSlPD
 i5ADNKtO
 8Cjayq3vqJaOlPjNTyF45dwg2YP5Eh7RM6k5nW3GxVtWvbUSIxnMUoFi06Y8FP4/1s0wkf4jG2okCPUfxBucZtIm8xUxVsLrrhKA58sWo4xE19H12qTORPZAMMsscHwCPhStoepiov4DFm3YXaIg6/VIPSWyKZk+jUqHQr9MH92dn0JzgGdkeHgC3YwJkofcbzue6WJYPlWVZ8ekI0q+UL3L8K5liXk4hj6bEdOMHNIJt5ycCJtXHLyMIloGfjuc8jaik4V478a9EODRGQ2vbsGbAT/KBM1n290lWtcrQP0m7g0MujAJkpm0sUs5wL47uKwiRkMYHHOCD0cH5uXHlYZ23AIRZxH2dZJvSTDsNLI85AwShCUmSX4fWmVzW+dyED9Yf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 04:41, Chao Yu wrote:
> On 9/8/26 23:47, David Hildenbrand (Arm) wrote:
>> On 9/8/26 04:56, Zi Yan wrote:
>>> f2fs sets its PAGE_PRIVATE_* flags in page->private and checking
>>> page->private != NULL is equivalent to checking PG_private. Change
>>> PagePrivate() to page_private(). Meanwhile, in set_page_private_##name(),
>>> page->private is first set to 0/NULL before an PAGE_PRIVATE_* flag is set,
>>> but it can cause confusion when PG_private is removed and
>>> page->private != NULL is used instead. Change it to initialize
>>> page->private to PAGE_PRIVATE_NOT_POINTER instead and retain the original
>>> semantics.
>>>
>>> It prepares for a future commit that removes PG_private.
>>>
>>> No functional change intended.
>>>
>>> Assisted-by: Claude:claude-opus-4-8
>>> Assisted-by: Codex:gpt-5
>>> To: Jaegeuk Kim <jaegeuk@kernel.org>
>>> To: Chao Yu <chao@kernel.org>
>>> Cc: linux-f2fs-devel@lists.sourceforge.net
>>> Cc: linux-kernel@vger.kernel.org
>>> Acked-by: Usama Arif <usama.arif@linux.dev>
>>> Acked-by: Chao Yu <chao@kernel.org>
>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>> ---
>>>  fs/f2fs/f2fs.h | 8 ++++----
>>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>>
>>> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
>>> index 9940a6cecf1a2..2f7ab5888b078 100644
>>> --- a/fs/f2fs/f2fs.h
>>> +++ b/fs/f2fs/f2fs.h
>>> @@ -2691,7 +2691,7 @@ static inline bool folio_test_f2fs_##name(const struct folio *folio)	\
>>>  }									\
>>>  static inline bool page_private_##name(struct page *page) \
>>>  { \
>>> -	return PagePrivate(page) && \
>>> +	return page_private(page) && \
>>>  		test_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)) && \
>>>  		test_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>>  }
>>> @@ -2710,9 +2710,9 @@ static inline void folio_set_f2fs_##name(struct folio *folio)		\
>>>  }									\
>>>  static inline void set_page_private_##name(struct page *page) \
>>>  { \
>>> -	if (!PagePrivate(page)) \
>>> -		attach_page_private(page, (void *)0); \
>>> -	set_bit(PAGE_PRIVATE_NOT_POINTER, &page_private(page)); \
>>> +	if (!page_private(page)) \
>>> +		attach_page_private(page, \
>>> +				(void *)BIT(PAGE_PRIVATE_NOT_POINTER)); \
>>>  	set_bit(PAGE_PRIVATE_##flagname, &page_private(page)); \
>>>  }
>>
>> Very weird interface. Why do we even need the page-based interface still?
>>
>> $ git grep -E "(set|clear)_page_private"
>> compress.c:             clear_page_private_gcing(cc->rpages[i]);
>> compress.c:                     set_page_private_gcing(cc->rpages[i]);
>> compress.c:             clear_page_private_gcing(cic->rpages[i]);
>> f2fs.h:static inline void set_page_private_##name(struct page *page) \
>> f2fs.h:static inline void clear_page_private_##name(struct page *page) \
>>
>> Seeing code like:
>>
>> clear_page_private_gcing(cc->rpages[i]);
>> if (folio_test_writeback(page_folio(cc->rpages[i])))
>> 	end_page_writeback(cc->rpages[i]);
>>
>> Makes me wonder whether we can just use the folio helper instead?
>>
>> In f2fs_iget(), we enable large folios only when !f2fs_compressed_file(inode).
>>
>> So naive me would assume that we can just get rid of the
>> set_page_private_/clear_page_private_ stuff entirely.
> 
> David,
> 
> Thanks for the patch, at a glance, it seems fine, can you please send
> a formal patch? then we can apply to dev-test for test.

I'm hoping Zi will drag that along as part of this patch set. Is this fine or do
you want it sent as a complete standalone patch (will make merging Zi's series
slightly more complicated :) ).

-- 
Cheers,

David

