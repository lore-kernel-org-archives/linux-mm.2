Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5865A606A33F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 06:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=JzuWZzGI
Received: by kanga.kvack.org (Postfix)
	id 5D6966B05B3; Thu, 12 Nov 2026 01:13:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 587696B05B4; Thu, 12 Nov 2026 01:13:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4777B6B05B5; Thu, 12 Nov 2026 01:13:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F55F6B05B3
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 01:13:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 18196A8023
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:13:23 +0000 (UTC)
X-FDA: 85425449886.07.8FC339B
Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 29E961C0009
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:13:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JzuWZzGI;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.74 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794464001;
	b=wcCc0fgCCcJS7Ss4c3jf2rnaeF/0N0rHO5SiRlzhY/YHU+6dEAavy2XzQ3UADiNCEZW4s6
	lXv0zzwk5e3i8LH10mKmzT+njf9OrVwiKOOUlSTuUWBqnawwN6B8XifITjpcOCOtpPOKqB
	EskE18x0UYgDCaq2EALMyDL+InRXmGk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JzuWZzGI;
	spf=pass (imf20.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.74 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794464001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IuShiHyRyDZxBf6e8YOm6MFfw5BWDF9yKQbfeeu8nmE=;
	b=Rzf4e0LKBPqq9dJMdWr2Eo/zf0KVwQPw22r0b0BwJ1vQbu7tRmkFXwWGtjvm0gakhLB9np
	h2k4QB2foCJmIkHtx55zWP3TgUxUrGUgXucgxvfXLhUZx9/a0urIGA7BhC6V4iywnBCDgN
	oaB7u0S/DE1sc3R9ORFidCy1u7K7llE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vN3Xm+gcrUO1WDmKGVle2xItUFZzcDTDyabC98afJ8s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794463999; v=1; x=1795068799;
 b=JzuWZzGIGjhlExhBiHKdumURCs82ANwESjEmR6fuXdFUxD/HMo8GyG7nln5rPeCUPYdOjCjv
 6Hjcrvi/Kgw8oe2NW5YrQQTszhMNkOjS9GbMAk3/lwMCB89FKKfazRWP5ycxS49rnQHdC42EF91
 A0qw+/EpE/kVNIorHcAQlF4g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a59a91c215b2ecd2;
	Thu, 12 Nov 2026 06:13:19 +0000
X-Mizu-Trace-ID: a59a91c215b2ecd2
X-Migadu-Flow: FLOW_OUT
Message-ID: <1116fd15-a927-4f6e-a0ab-084bc36a90aa@linux.dev>
Date: Thu, 12 Nov 2026 14:13:10 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 2/3] mm: gup: allow long-term pins of CMA-allocated
 HugeTLB folios
To: Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>
Cc: osalvador@suse.de, akpm@linux-foundation.org, azpijr@gmail.com,
 Lance Yang <lance.yang@linux.dev>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <503c9f6d869e3206c6fd591de962c3d619b73825.1794379433.git.zhengqi.arch@bytedance.com>
 <80FED512-77D2-4D49-BAE5-745CE1F711CA@linux.dev>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <80FED512-77D2-4D49-BAE5-745CE1F711CA@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gezfrwhjc3omxihrqqmn3imjq4ni7jxk
X-Rspamd-Queue-Id: 29E961C0009
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794464000-49588
X-HE-Meta: U2FsdGVkX1+WOTiH1yfnFbq1jQmm3W3sCgw7A9it94+rzsYDagd0IwjinjhWT7vrNpa8VWuH0XO7YhOnbri3R/M+gHwAxC9+WznydfuC7y+VVcLgz91sbBSLIkfz/itKx18F+UgyE0zxUJYgH2nJNFUC+Ia+LBEGy6O4uyJ3D5w9e+SvhZReqrQf1jon3hGk1mkKSjH4vg34Dk4zxT2cR2vH10wyIWss5q/Cyx/vwyDO78tuuUuPn1WKz/HXpZ12+RIjgFEfgi6NewvLEHs5Asc/ECeHwoZoejdkqngCaPGcuFcgaIPPjNgEExs6Gp/2yI1L9O+WlaPmDFbUPiUS0jiS12s4jI+ajlHhY7ub8PUeNUPOxBP1BLm4UyslaX4IaxfA+slgCWzMa+puX7fDagH996xDJc3QXKqE/xzO75wa8I4ikv5B01gSOkEJZQ1QpNgb6i8HroYe0eT1uQmWVCLfdbfICazjYveIFkZEgiG2cxqXnRoKeiJeaQhjvCJAyLQ45D7au4hWjRAtuogrXZ+drChLMj4J8Cx5UIRu3VFgzSX8ptUW6pnMs2BWWnnU1Frn+lDIvsY+WMgkEQvX+inMUOk84wlc3uMeBYu+TwbY1H1DTDCawpBS9NgU4tZnEmJEFbnxIe7L8V1DLWP5qmc0XAOIuRc1HxZLUYCCU9bBzZH+oKdixwIBe8haCu5LiDbjuFbqGKGkTHoszl9JfqJzgvrOH8w8yZC+X8PU5gLNw0l32IpCqWYS8BMuyPZU8tUq3zmi9Rqlo9Uk+J7JDXJk96JsGgs5TKSelcbfq5LaMVd0qQB7cIXyustCrmkfF6S1yltPpkUOcKtUeP49AWfJVkwmSTYpgQqG+jDg/dvCN/xgIyOPWCvVXNUNedLZdOqLcPR80d8iu3iYzwxHKICYhi5xuM/w+xFJiJ/SkKZjRTW7Gfam6aDgBInaH10f3+pUvnWvM12b1hNGeWo
 JWetcsFH
 59Q5UBTyyZoccVWlxeuDjXRUVlnfON0Yi6rzlzvEYWD041uJAxV5qMhYF83Idw9VelFN0iyXuDskYBBXG8/pg1mr6ASN5/HTe5SULd8ujRVO09pyvc5izlCXWAKZEdNHYEVvCH+AkrMWoy6OMIanNGpp70ssJoKcSlBpgc04rGUCuMpINTRid5r4NtCYQOPgpngsXHvLnixZBqGMOVWSAfwDEM1709/Wmsmw6cV706t//fVLGWrHib2fEONdGvf95Z1tM4C9hWFLT5hDXcEH7oZJoxBghSgkBd6LNBPX4mrBgjcc2OIcVPqaRd/Zjoz5fW6Dt5wTW4BHQE/yajjuL+87YOA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/26 3:42 PM, Muchun Song wrote:
> 
> 
>> On Nov 11, 2026, at 14:46, Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Long-term pinning treats explicitly CMA-allocated HugeTLB folios as
>> unpinnable, causing unnecessary migration or pinning failures.
>>
>> These folios already own their CMA bitmap ranges, and memory blocks
> 
> Commit message needs updating to bitmap as well.

Will do.

> 
>> overlapping CMA areas cannot be offlined. Allow HugeTLB folios with
>> HPG_cma to be pinned directly, including in ZONE_MOVABLE.
>>
>> Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
>> Cc: stable@vger.kernel.org
>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Acked-by: Muchun Song <muchun.song@linux.dev>
>> Reviewed-by: Oscar Salvador <osalvador@suse.de>
>> Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> ---
>> include/linux/mm.h | 29 +----------------------------
>> mm/gup.c           | 31 +++++++++++++++++++++++++++++++
>> 2 files changed, 32 insertions(+), 28 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index b0da9be413098..47d1d96bfc7fd 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -2954,35 +2954,8 @@ static inline bool is_zero_folio(const struct folio *folio)
>> 	return is_zero_page(&folio->page);
>> }
>>
>> -/* MIGRATE_CMA and ZONE_MOVABLE do not allow pin folios */
>> #ifdef CONFIG_MIGRATION
>> -static inline bool folio_is_longterm_pinnable(struct folio *folio)
> 
> I think David prefer to move this function first, then fix it in a separate patch,
> right?

Hi David, is this what you mean? If so, I will split it into two patches
for the v5.

Thanks,
Qi


