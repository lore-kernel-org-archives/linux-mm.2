Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A8EECCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 10:33:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B08768E0129; Tue,  4 Nov 2025 05:33:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A92FF8E0124; Tue,  4 Nov 2025 05:33:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A868E0129; Tue,  4 Nov 2025 05:33:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8025C8E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 05:33:52 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 27A084A789
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:33:52 +0000 (UTC)
X-FDA: 84072563904.26.733BA10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C43CC0009
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:33:50 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GBz2QfyI;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762252430;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r4BpmpsifWGmEf60k652ypdrzkQz0SpNCdoZl89z4mE=;
	b=NQqX2969QzhUFBK/4WDIju5i8zx1ZBaXBCeMfIMgaPcHAXrdxY4kMr9tojdWZXuievuLvp
	0Dg8qIcLr/8Uf/tSm2QB8PQ5wvO06z3UqvGzRTDjSnRK8U4mCPtLcQxYRfh1h+O+bZYd4K
	69xD/myMLvme/09Yy/2cs+pHhsvlzCQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762252430; a=rsa-sha256;
	cv=none;
	b=69tLOwvuw4281TOCWHpZvF8zVrJehS9fEvzz6KehbhW4/7Ms5aQ81otjRW6/uoy2WtQsxe
	ie4QFAu2C8oc8KXSgMToJ8fbqfcpoEDb7axLPZ+992+kHDC8I8rtWxnFN69fLd+xRE1KpH
	mkjBdWH4hkiv22JiwCVBKOOFHXCQpQs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GBz2QfyI;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 02E6240B40;
	Tue,  4 Nov 2025 10:33:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B16E9C116B1;
	Tue,  4 Nov 2025 10:33:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762252428;
	bh=KuLhso+GBkpmIE1sGuLSBeKjvPFIReoPVoBC2F3vsXQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GBz2QfyIIxl9EoNtSyLMHzQkEk+YH8krTMh7fwlFrsHfDeJIsoiamxqcmlV/zytj1
	 TQAbwcKQCTC9x2LdsR6yZesy9tlkBL1kA1XsTvrM7KRSJ0zG9tqAfK5r28kEkLRQnZ
	 bhNkEC2dxH0JRQVQ0TzLggVb2rZSM0wl92wO6whPG5kO8jivm6JYP+cMWyAcuhZlob
	 WWTi0Xto+gfwF1isQ/Xtaf7tMsRpNKaZdST79/mxQYESEiMrbTVJOmc3FUlJgT282T
	 UQciHrF6qVz4ya5ugu1KcpqwwWVunRT5jaRof7tMkdQsUYUMNZNvWxFC+dxcTs59JB
	 xX6X9Xvdv+KBw==
Message-ID: <de9943ab-1fd1-4a1e-940a-a3ea86f544db@kernel.org>
Date: Tue, 4 Nov 2025 11:33:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: introduce
 __split_folio_and_update_stats() to consolidate split task
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
 <20251101002927.2610-2-richard.weiyang@gmail.com>
 <b2a1ef9a-9822-49c8-85e6-43b19bc8bdd7@kernel.org>
 <20251103233728.b5kmsit3vcqpmr6w@master>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251103233728.b5kmsit3vcqpmr6w@master>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 4C43CC0009
X-Stat-Signature: ag99hkwxphj1etmqpetzytghxy63no1k
X-HE-Tag: 1762252430-22595
X-HE-Meta: U2FsdGVkX1/YI8l2yNv9ZbfI8m9jbgPSfWecX+0BAcD6DqPr1UPOsKqhKmyMdeoG4+NmPDORyU4npBUatjM9MZCJZGKJMeL7JGQm6eAGJkc61NtRFEEuBGWE76voi8jpc41nOR9Wn+3CnVD71OD9MpyZ6F2r4rh1xnlUGFZ5++fL6WgOkPWLyE/EiyAZbw5FZRteNyjfBPUvJXTrKYwxxn4q1ypJ4SS4IOdRF5wSojBJJcgjgK2Atkk+LNSDovkBZ+XXOS1C0/WBJ6qxaZN6GXuysiphaXOlf73HAAI6hgl/1wErzWWFYWaSc+SrcC06gFp7CkzCfy85CKUvTjgSm2oEXVj+KYi/BoYjN1UiVzYrwOLzM2hUh0r8FBqwLGJ/Q5OmeHWk8S8AeAfiVGGJOjZA4b8GP/QMmF/a/TqyMg4HnnLorTxnelz3ENFK8guOgk/V5DHCZbqC9S80xEaQwk6CTwj/tbSREnAlXqGSouglRkPWTH2EFe8/ZDZxL/gIBo1ZzFt46Q93i23N73oof8se6FIP4ZrAJegFXNhA2XNa83gBvUaohZFAPaCOVm9DnKEa9rkxDHobP8vsyFHomQ+WHsKs8+Yo0WgXIoGNcBnQS9QMAa/IQ5yNSIWpRGGCK4cBPLJGYwMQCrcKSvwttTs1jEj9ANB80gPgyqVST+WIv0pzPWNWNNTYA09uKagnZAZ8Doq5PruDALV9vqgkE9U5txKK8TU9dres6CqUOs59plIHMLJlvqNdcsUCPwVZkY8psZRCwSSmDF4I+FTAIxa2/NAjM+XpQqMzNh7PZn8oJD+4k5/gKnczRyu4gpsl16MuUk46j5nL+noh6j6BZROX8sFIyqbD2rird/5Z+G3ycQo/l0QcD4izRjgbJfTLvtvSP0USLI0kFUG8AXRRJyweqVEVq54oynkge5odf7AfTaa64vJUbng+a9XS7R52MIzCeO4687E5/0rE+D0
 4WGT0RNh
 ErhIwQComlZvGAOCw9Fn/kZW0halWqmDLXKisncgZN3F7WrGUpqD6v8xa/hfC2gZT2etDQ3caPF0wH6webVx5a8aDHwysTtbV0ShEadjUi6HD2oYH5iLN16vGkXbEOR/G72vk7UTnNnQinEqdkv3u1MLkiDxf7iIfeAV0RpSjik52E5bAh6AFFr70zyKKkld8rzVhQaPqmJVdhahJ3If05v3GtY+xknqTNaulHbIPHMF9Atxgvf3jdni/i7VYvpNxDszjo0CeORnprC66qXff0V8w7hJR2viQZkcJlAC61RE0XUQCuvrxRhUowQ+jKeBhptDjzCPrZR7ZMIwh/VbAPPuGh5/Kay64XekDGeDzGH41Zw7wK771UQTyN1EMj0/FwidqQKur4E6mUqg5PXUPbFBg1/HjPVI3QeHodvrMjAjBdiqcy9NyalmBn9bqHzCE36Z8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04.11.25 00:37, Wei Yang wrote:
> On Mon, Nov 03, 2025 at 05:20:02PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 01.11.25 01:29, Wei Yang wrote:
>>> The folio splitting process involves several related tasks that are
>>> executed together:
>>>
>>>       Adjusting memcg (memory control group) accounting.
>>>       Updating page owner tracking.
>>>       Splitting the folio to the target size (new_order).
>>>       Updating necessary folio statistics.
>>>
>>> This commit introduces the new helper function,
>>> __split_folio_and_update_stats(), to gather all these tasks. This
>>> consolidation improves modularity and is a necessary preparation step
>>> for further cleanup and simplification of the surrounding folio
>>> splitting logic.
>>>
>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>>> Cc: Zi Yan <ziy@nvidia.com>
>>> ---
>>>    mm/huge_memory.c | 28 +++++++++++++++++-----------
>>>    1 file changed, 17 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index c37fe6ad0c96..abde0f1aa8ff 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -3567,6 +3567,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>>>    		ClearPageCompound(&folio->page);
>>>    }
>>> +static void __split_folio_and_update_stats(struct folio *folio, int old_order,
>>> +		int new_order, bool is_anon)
>>
>> Is there any good reason we want to pass things like "is_anon" instead of
>> just querying it in that helper?
>>
> 
> The reason is during split, folio's attribute will not change. In
> __split_unmapped_folio() it is queried and set as const.
> 
> Otherwise we need to query it on each split.

These checks are extremely cheap. Do we really care?

-- 
Cheers

David

