Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F060FC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 20:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 655E16B008A; Thu,  9 Jul 2026 16:44:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 606B96B008C; Thu,  9 Jul 2026 16:44:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8926B0092; Thu,  9 Jul 2026 16:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 219506B008A
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 16:44:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B67681C2488
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:44:10 +0000 (UTC)
X-FDA: 84970415460.04.66E7438
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 070EA80004
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:44:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B1A05jVt;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783629849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Et1g9fkjQA21VEy/dQj18Ponx7GtRjq32b06cYFAtns=;
	b=ntkqJtmYYWEdS/38xGdsNtfwDT1paSOn3HrejG/vDGH9w8bLs34tuo9eAoN+ryOahbWskw
	bL59IVEV4uOoCAJqJyouoL0iCLuaNWwbnfBFIGbkaTcSkbjLPwMAZ7YEs/sBm0V+TPu78q
	yjyoAPJmCGDmUaup8SrsF66XwS/xWlY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B1A05jVt;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783629849;
	b=gDiKna/Tan7MD+0WqMTiZbfhJxAjx/acM98PmhcfuxaehWLEW5R1OScoXar334a6kZ+eSz
	PU0FyEfaOS2oAc7+tSNP5UHFHGQZdx7q6hPRadOqo7gnL203OTCTTYnnsBs9L0fHq04V6l
	s2RQSZ5uWkF3K49sctfM4YAjnxbIF/s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 933A8600C3;
	Thu,  9 Jul 2026 20:44:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F343E1F000E9;
	Thu,  9 Jul 2026 20:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783629848;
	bh=Et1g9fkjQA21VEy/dQj18Ponx7GtRjq32b06cYFAtns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=B1A05jVtaixynbNYumfT8ggsXTfGWBvtrRhGqjEBdchzMQFibVoHTncQ4DCEyKToL
	 POKEXbCiDiQ+7OyC7ej5Wgq3m/EEyB5e8YzUxDxZL35MfCjkTSuSVrQbZhJTil8pSs
	 jYM2QVBfcEI0X6pYNKQL269dkujt4P3Cpms5Xmy5jWjp013xaUF2K8x1KdR8DloFWF
	 hcj7cFtkl3HIFp+9puBA42cOLTRo9PQ1XOIddN5w3EdR7IfMUa9jLsCUVno3RRVfrV
	 CDbkjAHC9sxKRkeO0/SKrYGLtA4F7TmqoYbeiRVCwsqX27cACJblXxXX6B5XY1VuNH
	 lsvlx/fEpgW7A==
Message-ID: <a58b7bc0-be41-4689-96a2-4d6a779470a7@kernel.org>
Date: Thu, 9 Jul 2026 22:44:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: page_alloc: move capture_control to the page
 allocator
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260626182215.1107966-1-hannes@cmpxchg.org>
 <20260626182215.1107966-4-hannes@cmpxchg.org>
 <c11c73ba-4422-4ef1-834d-6cc230146dea@kernel.org>
 <akV_VwtcvUN7Mq16@cmpxchg.org>
 <e63acfb5-c9d6-4e2a-b44c-417ad3a15b8b@kernel.org>
 <ak_eVpT_SpYytSSw@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <ak_eVpT_SpYytSSw@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zswx9tkxfeesimkwyoufweiei8itwpx8
X-Rspamd-Queue-Id: 070EA80004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783629848-215431
X-HE-Meta: U2FsdGVkX19ISDX5xThykeRQ3XVvAU1hwU71ZoA5UldFrrzcVLe7bBtD030HtC9Q4LSniB9E+wr2xVH1yyW6sdon+2uHkexUJGOjrNHFhLEN6ktfBkdnqhyv9YdFJ05YACe0atLX7xyWy09rNgRe55gVKzg1DjYtV1ppcFRcncyanAqPptMnbU6AkKMsZd67pEWUIfELuddoBRCTikkHI2oHjLC+ykIB0oKCIDdQrrevKIe4onn4Bl6scNyLErZ6lD3lSKrg2+X016LL0Z2eWPvbkVMKYezUqgjtXww4fEGY6adWtO5qoEyIZaYlGpYYKY/kHm7LNp9LOYcyg3gSvqijIK5K+MNMvFEhLu9nmM/HG4/2Ak5cmG20SRwkonaNrHh+UfI4JchbrQ254eVocrtO+bOif1tYA0dg8LDO2YbLZstyXoBMXdGmLkyrOf8cFK3r436zFiN/Q1N9+EQQLG+ee7WYoIZrywyNTGIKMSoRn3pv4Ryqzpj3i6fWGsdcpuYYe0bbjDSRDhUoc4zgCo4M6K2nN5waBqoP1MfP8xN8DIiIitnKsMIdWy2DKbLRUZw+x8mSsgCJ9VR641+Vqpbh+hLpVLIAm5s83KnlbRE528WiCi66tGyE2xWnS4nih540VopOP0+Q7k1FqohDck75jHiGZv87X+igeKGeuZIVBbJdtMofMJ37AcEskumo9oAgkaySJ/S3484XYSB4goICqD6ZMZchrYz+WU5SZjtGwQ2dTDpHHOWaYKOoGrnRA07mUJkP1SaqVInjct4DRBqrXAwx/BEUWQHwhzBfUiUocWf0qmQTU3YZStq70YMVB4XV3qV3EYBOlzNeNJau26xzzkBcP7NmY8Hf+B0u1j07LyuB4ytksf6+njcvSTc9pR0lqOut8WUZrb7UUA5iISTiHgH3MFfMUFvPJVFnYezs34B3+LwvnayWr9J52oCk+8+StTD/2NBsMnwEg+A
 oj+cocsX
 9RYTe43fXYuydEQLu0L7ZioQ+1mcJXU4npRyDKtJrTR2R4fmAapimWThjP7EsUSPJRQjr1786x1QEk9C8oe1ETJLzNknOYVNWYk+a/32mxV1sBFidEVzmiyaQLQELrgeagciJRe0W2a4IGCd2mAQu4W2WQT2FKUQ+kSk7VIXTKSsLwRRcOnRsIU7qXKyGJc/7y23uV7Ck2GxhDSRs35pW68Fw5Vlql/8VQGmsFb4xrbCkn0nlTdyk6uwvwUCD1W9/T6KLkmusftIH/AedlaHqtz9EFCTmlZb1mlAA7VecJrFxwnEPmZ/TsNuTfVv1b9oi8M8vnzsL8ylEO08=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/9/26 19:45, Johannes Weiner wrote:
> On Thu, Jul 02, 2026 at 12:20:48PM +0200, Vlastimil Babka (SUSE) wrote:
>> Now my version (only compile tested):
> 
> Ah, now I get it. Thanks.
> 
>> diff --git a/include/linux/compaction.h b/include/linux/compaction.h
>> index f29ef0653546..66a2f70e9e01 100644
>> --- a/include/linux/compaction.h
>> +++ b/include/linux/compaction.h
>> @@ -58,6 +58,7 @@ enum compact_result {
>>  };
>>  
>>  struct alloc_context; /* in mm/internal.h */
>> +struct capture_control; /* in mm/internal.h */
>>  
>>  /*
>>   * Number of free order-0 pages that should be available above given watermark
>> @@ -92,7 +93,7 @@ extern int fragmentation_index(struct zone *zone, unsigned int order);
>>  extern enum compact_result try_to_compact_pages(gfp_t gfp_mask,
>>  		unsigned int order, unsigned int alloc_flags,
>>  		const struct alloc_context *ac, enum compact_priority prio,
>> -		struct page **page);
>> +		struct capture_control *capc);
>>  extern void reset_isolation_suitable(pg_data_t *pgdat);
>>  extern bool compaction_suitable(struct zone *zone, int order,
>>  				unsigned long watermark, int highest_zoneidx);
>> diff --git a/mm/compaction.c b/mm/compaction.c
>> index b7878e4a2c4b..902573797f99 100644
>> --- a/mm/compaction.c
>> +++ b/mm/compaction.c
>> @@ -2792,7 +2792,7 @@ compact_zone(struct compact_control *cc, struct capture_control *capc)
>>  static enum compact_result compact_zone_order(struct zone *zone, int order,
>>  		gfp_t gfp_mask, enum compact_priority prio,
>>  		unsigned int alloc_flags, int highest_zoneidx,
>> -		struct page **capture)
>> +		struct capture_control *capc)
>>  {
>>  	enum compact_result ret;
>>  	struct compact_control cc = {
>> @@ -2809,36 +2809,8 @@ static enum compact_result compact_zone_order(struct zone *zone, int order,
>>  		.ignore_skip_hint = (prio == MIN_COMPACT_PRIORITY),
>>  		.ignore_block_suitable = (prio == MIN_COMPACT_PRIORITY)
>>  	};
>> -	struct capture_control capc = {
>> -		.cc = &cc,
>> -		.page = NULL,
>> -	};
>> -
>> -	/*
>> -	 * Make sure the structs are really initialized before we expose the
>> -	 * capture control, in case we are interrupted and the interrupt handler
>> -	 * frees a page.
>> -	 */
>> -	barrier();
>> -	WRITE_ONCE(current->capture_control, &capc);
>>  
>> -	ret = compact_zone(&cc, &capc);
>> -
>> -	/*
>> -	 * Make sure we hide capture control first before we read the captured
>> -	 * page pointer, otherwise an interrupt could free and capture a page
>> -	 * and we would leak it.
>> -	 */
>> -	WRITE_ONCE(current->capture_control, NULL);
>> -	*capture = READ_ONCE(capc.page);
>> -	/*
>> -	 * Technically, it is also possible that compaction is skipped but
>> -	 * the page is still captured out of luck(IRQ came and freed the page).
>> -	 * Returning COMPACT_SUCCESS in such cases helps in properly accounting
>> -	 * the COMPACT[STALL|FAIL] when compaction is skipped.
>> -	 */
>> -	if (*capture)
>> -		ret = COMPACT_SUCCESS;
>> +	ret = compact_zone(&cc, capc);
> 
> &capc, and I switched it to just return compact_zone(&cc, &capc);
> 
> But otherwise it looks clean to me. I'd just take this as-is with your
> From: if you don't mind. Can I add your S-O-B?

Sure, but I don't remember if I started from scratch or your version. At
least add a co-developed-by yourself or something :)

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

