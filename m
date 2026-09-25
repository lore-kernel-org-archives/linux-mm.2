Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D0ACC9830E
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 23:14:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 411186B0088; Fri, 25 Sep 2026 19:14:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C2E46B008A; Fri, 25 Sep 2026 19:14:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28AB46B008C; Fri, 25 Sep 2026 19:14:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 073F76B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:14:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7B9128077D
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:14:02 +0000 (UTC)
X-FDA: 85253839524.18.74211C3
Received: from mta1.migadu.com (out-73.mta1.migadu.com [95.215.58.73])
	by imf05.hostedemail.com (Postfix) with ESMTP id 45FC010000A
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 23:14:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bti3UOqA;
	spf=pass (imf05.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790378040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=By0gVXNoU1v4k2Fh5ILwnkmTG7p+KtlZP8PyA6fvPCE=;
	b=4ugG+fo/wkiJOgwwatl9qfX/JipmnD8pUz/eqKR2H39oqAnAlFTJSEAdjqAT9cKyou2hfO
	TyLSJBy5X0oJxVWiu+CHGpJxUfxZTheme/NkUve/PnqgIt9lLDOQyetmU2JqCGrpyABIkO
	qGAZOuoAa4fKYam33iVDipVQBeJ3ztM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790378040;
	b=AO0RkUWm6tuhkcSQcmpUUF4J3PegQ22ZqK6Ewd1cR265yNrDxJptDGDgRC0pJUgsoWWXif
	G7NiXyVo6UfysHdvK0H5TKWW7TlPuZcMBztpiv/Ihp9q82e32aTHxg9rzZiCOUt3Jovadq
	q0da9c4WExnnm5GFxg/tenbelnf0X9I=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bti3UOqA;
	spf=pass (imf05.hostedemail.com: domain of ilya.gladyshev@linux.dev designates 95.215.58.73 as permitted sender) smtp.mailfrom=ilya.gladyshev@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=tOxz9HoU6pRLO9zJ7CotYpqDOpegZThflwPxXAEwQro=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790378038; v=1; x=1790982838;
 b=bti3UOqAx7sMW4PbRR/lDqekpsihY2SzCblhxyTktcDJG2UqllSNK2b9TqAKUSuxKhC1bfBL
 8rX0+VxQTqNsO7zVK5kYRVKwBluRNYeQWFKO+nv+Xlol8FSWSmzjB1/fyhI1nQklQrzsYLPO3Yn
 JG7SYfDXgCMmtVx0t658ZlXM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id faa0fec37a4f7450;
	Fri, 25 Sep 2026 23:13:57 +0000
X-Mizu-Trace-ID: faa0fec37a4f7450
X-Migadu-Flow: FLOW_OUT
Message-ID: <293f4c3d-c6b4-4ccd-a116-71ce02341c39@linux.dev>
Date: Sat, 26 Sep 2026 02:13:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 3/3] mm: implement page refcount locking via dedicated
 bit
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, andrew+netdev@lunn.ch, apopple@nvidia.com,
 artem.kuzin@huawei.com, baolin.wang@linux.alibaba.com, david@kernel.org,
 Liam.Howlett@oracle.com, edumazet@google.com, harry.yoo@oracle.com,
 hramamurthy@google.com, ivgorbunov@me.com, joshwash@google.com,
 kirill@shutemov.name, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, muchun.song@linux.dev,
 pfalcato@suse.de, rppt@kernel.org, surenb@google.com,
 torvalds@linuxfoundation.org, vbabka@suse.cz, yuzhao@google.com,
 ziy@nvidia.com
References: <cover.1789239015.git.ilya.gladyshev@linux.dev>
 <ebd6540ad89a4bb80e2a62d00901b5c827315b66.1789239015.git.ilya.gladyshev@linux.dev>
 <arbNrVX20f2WDJjO@casper.infradead.org>
Content-Language: en-US
From: Ilya Gladyshev <ilya.gladyshev@linux.dev>
In-Reply-To: <arbNrVX20f2WDJjO@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: o45qadhkit154jsi8nsxbn1kwzf5um6o
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 45FC010000A
X-HE-Tag: 1790378040-302733
X-HE-Meta: U2FsdGVkX1/PAG25W6mZkQBMeGU7CIqZOqfFJDccIsg25TCduxedxYThsHk1IlVof2QsUQ3kwizKY17XlQpSnolUcLuwMbzRmKGFpKdnzYOGWi7q47En3JkgYgpky+SGWeBHK2oMiHz2og7ftaskExBFsuZxJKz66/NxAW8uUmGdCwrOwG9KhfguS4/nB6us7GfKNaYMgiZTkFUWuJkVRZ3dIrgm0jH8e9ZpSw27qeLZa3Iv2UK/DjVMGtVmIIgnctLtbsRAbWTspNw350q92teJ2nqWsrW+gtiKVvf2ZGOPHBsEyj70HEqcccRTxjDjaXtDp5o5rFFsciuPp0qrqDVxEdyk8arUm7HlWbt7Pj6uKArrskTdL1ya9rGMhzZwTxQwHUnShBc+M7hszPVTVuh+YJYdgOFE+D1ixOu85KwQVdxnJrR3Xa/sgWjwboDffCwi2cpA9FYSemVZq7lUhLxKivK4qzR43/6zpGUe+rXyMctcj8Kha5EQgv/2JTViJLo50h7EgOfh9qxZ3MMGumn/a6S/T/pW6oVEPuFLEvp0GJlk/J+S4eRAjKL7yNmlwr/yQkw+NTeHXkj4YTjI1LgxjRz5ce5/1Vqx+6dPb0O/UfX7e0XN+vJxu7EnByPgR7YxrEjdz22hWleCFjiJtMenIyIVHPj6cRscloudbbb/IM5jJsWnZNKSheYoU08G1bKlCYD7Vr2T40knoO7o9NUaD19U6rRpXcGw9jBewc5QLPqUtS+ZgQdcE3KI57u7vCipdv2D0tmchQudrWPChRGguRrlUwhCZ7fmdnYz2fCu0V3ArAkg59hLCV+JJkzXp8gzeVmXUzOIkIRsscDPQS7XotZ0wcz4fGUjKVjnHYqRvUGvSy6WHeamF9jvNy5fbhCrexhPVu+JO5lXJRsQ8XPsX70qhrqIgv2H4vnjjoSjKA/ZxodmVh7Ufr6tpB4bSv6413V/8Q++WGKnqgf
 5rexQNj+
 X1exP49Jiu0hVFCV69bXpFyXP2yOizbn48UebFh6KgZc3ACQHwNF6pbbXMf9zABzE42mwcQWVnaUDHBiC45uE90TQ0g/RhC5VFbBySSUqt211LXqRKCYgqY8B2YJ16NyBnaLNtoES8L88UcgmP3UdfJBoo0wUCJoXk7sjoJmDT5OoIXqXo97/tFgJDFiwsQ1J8hCODbckNx1rSQkNFR6+cD41KO6UEu+fIFV/765plaUREKSLx4gjgCOJAXzO4PcJpR6+7RI3U5YUmktjCwn0MCEP3igqDPbg33DmeQNe6JtSqFz7Lgtq77A8AY5SpULXkh+7tZG2MWbWrOPJE050j+fzEnRdaK7TZRHIPY/S1r4LQC73BhetCv3sO7iRIEBRtth/BtxR6XTM0oQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/25/26 22:38, Matthew Wilcox wrote:
> On Sat, Sep 12, 2026 at 10:50:10PM +0300, Ilya Gladyshev wrote:
>> This patch reallocates the refcount value range:
>>
>> (1) refcount < 0 means dead refcount (uninit / frozen)
>> (2) refcount = 0 allowed only as a temporary state (see below)
>> (3) refcount > 0 is a regular reference count
>>
>> In other words, refcount is now split into "dead bit" and a 31-bit
>> counter.
> 
> It seems to me that refcount overflow is now a problem.
> 
> We can deliberately increase the refcount on a page by stuffing it into
> a pipe.  Over and over again.  See merge commit 6b3a70773630 and the four
> commits on that branch: f958d7b528b1 88b1a17dfc3e 8fde12ca79af 15fab63e1e57

Thanks for pointing that out!

> Unfortunately, I think the discussion that led to those commits was
> conducted off-list because security.  I wish we had a way to declassify
> thse emails after the fact.
> 
>> +/* Most significant bit in page refcount */
>> +#define PAGEREF_FROZEN_BIT BIT(31)
>> +
>> +/* Page reference counter can be in 3 logical states,
>> + * which are described below with their value representation
>> + *        state              |         value
>> + * (1)  safe with  owners    |   1...INT_MAX
>> + * (2)  safe with no owners  |         0
>> + * (3)  frozen               |  INT_MIN....-1
> 
> I think we need four states.  The first two are the same.
> 
> (3) frozen: 			0xc000'0000 - 0xffff'ffff
> (4) temporarily overflown:	0x8000'0000 - 0xbfff'ffff

Agree.

> (we don't really need that much space for temporary overflow; we could
> have something like 0x8100'0000 as the boundary if that works out better)

Frozen state doesn't really need that much space either, so I guess the 
boundary with the simplest check in page_ref_count wins.
>>   static inline bool __page_count_is_frozen(int count)
>>   {
>> -	return count == 0;
>> +	return count & PAGEREF_FROZEN_BIT;
> 
> This probably becomes '(unsigned)count >> 30 == 3'.  If we choose a
> different boundary then something like (unsigned)count >> 24 >= 0x81.
> 
>>   static inline int page_ref_count(const struct page *page)
>>   {
>> -	return atomic_read(&page->_refcount);
>> +	int val = atomic_read(&page->_refcount);
>> +
>> +	if (unlikely(val & PAGEREF_FROZEN_BIT))
>> +		return 0;
> 
> ... use __page_count_is_frozen() here?

Missed that, thanks!

> and you need to adjust folio_ref_zero_or_close_to_overflow().
> try_get_page() can stay as it is.

Agree.

> (Thanks to Pedro for asking me annoying questions about mapcount
> overflow which prompted me to look at this again)


