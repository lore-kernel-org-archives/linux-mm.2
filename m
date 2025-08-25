Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27753CA0EFA
	for <linux-mm@archiver.kernel.org>; Mon, 25 Aug 2025 16:54:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61D8C8E0055; Mon, 25 Aug 2025 12:54:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE218E0038; Mon, 25 Aug 2025 12:54:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BD1F8E0055; Mon, 25 Aug 2025 12:54:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3A2E48E0038
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 12:54:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D341284293
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:54:38 +0000 (UTC)
X-FDA: 83815878636.19.CF125F5
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf25.hostedemail.com (Postfix) with ESMTP id 070D0A0008
	for <linux-mm@kvack.org>; Mon, 25 Aug 2025 16:54:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mqpvkaV+;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756140877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2dZmzyywwnY7lchKOLgGY8doykdyDHwJJ4akbIOpMOs=;
	b=HTorXZMQmqe6csqCyrxzPpHEUCp1d4u0nboVykS2zAJznEmhg4lQ2eEjmwNFz7KyBvVsE0
	yDUWstussl3PI/CLT4VmMQIe3GY2+yTRNipaD6Fjrf1BIdEuo4dQJaPmHMDTzMesVh+gWc
	JhoK+GfO7+MtaiCD0nYnOw3YI2TzIhY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756140877; a=rsa-sha256;
	cv=none;
	b=ZgJZS9DVWy9n0IplfzPrDHNOvpgTFM2KOXSBZcKaJZ3RV/AyIMsJkk4sLgoKZvR/olNZxr
	iCaW42Y4oJCqFOFPfpb6QwK9HLiBBuitGNo0+N9XwRjn59zT7DsRDD2KQlfVb4q7ETJ14f
	SQZuRoia3mkszT99uUZVzN69oYKnPys=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mqpvkaV+;
	spf=pass (imf25.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756140875;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2dZmzyywwnY7lchKOLgGY8doykdyDHwJJ4akbIOpMOs=;
	b=mqpvkaV+gR6VKDvX93iA5JZH4kv7rLy11Zbppcwm9x5N37j+I+IAD1ZEfrWxnee6mjf5pW
	fLJw2lyngoXCxU/07dF1HNmsODE42v0IGMe61UUL+hXzMJjUhUJQgyz7c5Hz6+3ktTRBld
	uealQshO024kKDTe1zIJigJAgbeNZHg=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  "Matthew Wilcox (Oracle)"
 <willy@infradead.org>,  Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] mm: readahead: improve mmap_miss heuristic for
 concurrent faults
In-Reply-To: <ynl23xmeglxarrkrmh4r3sj3idvqbofwatrnhgx6tsl4zfrsxp@juc5kmjelwjn>
	(Mateusz Guzik's message of "Mon, 25 Aug 2025 14:27:58 +0200")
References: <20250815183224.62007-1-roman.gushchin@linux.dev>
	<ynl23xmeglxarrkrmh4r3sj3idvqbofwatrnhgx6tsl4zfrsxp@juc5kmjelwjn>
Date: Mon, 25 Aug 2025 09:54:29 -0700
Message-ID: <87plcjxry2.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 070D0A0008
X-Stat-Signature: wfhsa4mh18s99ntcmch3cd39811dmh75
X-HE-Tag: 1756140876-228901
X-HE-Meta: U2FsdGVkX1+g1yo9eLBHUgUGDyAxabiLU4/aUtGnMj7hwFZevOyIE2cEPHnT0jRYEFCWhTWh40IKVB0YwqqIi/rNsBj4lKl53vP73OSVj963KSCtoIHP6e5cBC/9qXDqKkUyDhnVfsJdbcrkZ2VJv0O1rxwxSce2KW5JgiL5SzxNKu1Zwcfy5EbRbj0SI+016yTU9U+NzF9IYXzgNq0v4p273m67NWcecx6ao2LnI1wifRawZl4MxykoV/ZpP3nSU2nf1L1rsX8n3etR5rwEcTBRrAYQwl9HTB8OkwCluPtI6R2CuehVoHm40uh7IRs6bjvI9xOscy18JKDOCQzzD2IfOTu3qJmQBEdddA+MMvwYiG8aSvYcS2JdQgRUaT5Gr4qKAUltzKyvvzET9jnNvzECg7LqEepY7q4VSCXH1a+XUW5meDdlH+x/56K9ftL89r44GvOj6TjLoxUG3oX8LTc7cpywAd0RKOuS/GKHzLsvJXB4s6dTTVLlYMaBtC3xzM8JsVIjIRompb3mP8Zqi/Fy5cVEo3E6f5Zl4YY7zX/GzpQLTp9I4yM6RtbeP85sjfUodmxkZEuzZ5qVKxPR8jU00/wJkfQm2G0nDrGHmrNrh6E9OLLy+bgBdcik4ldSb/1qkSloHyu+YszZ62sWlcouc77l/UvnXveT107gSbBU0ovWn+9z0FiMnYdHeavff7pRuHO/FqZaQ0S5Rsj/LCGOUcP0yvDRcyI7NIOwsNVLiZ6MqJ6dOLiB3HGW9rgn/j9O2JA77HwECarNipVVGJgYrvL2viXvUuXkO1fma4po0Y+kN1C/xZv0FKOdJPfvma7UPQ0+UU6SCh+fu3RRETbOU31iscJTSxh6JXNcc+k+DR0hk91QZN0q/zmEq7WMXYx/RVjz4mNGinogud3lAQoOkKWSGTEcVApUNV+CTeeiNqq8OV0/iFjXnhIr0dEabtOtC2PfTxin2HV2fGS
 P0gZti9+
 F5VhKGJDT287/VeWMgQaz+/DnHfI7NfjLGJThPpIhC/qxFy5Y+GMFHF5fwWOJVRnY2dXTPx5j1Or7BLvmtllq7zbBIHylXxmtvwUVA1wajHqY7isF7Im/Thk8xlAhCKGBpWPP2Qr7PC/yF2sbyFu6ybWhwltskEEKKlxcswsgq2Qni/dm/XhUaueh3Ht3L3/by7cinKRUABJcJHmKx0Oi0mxibdR6DpYne3iaD8Ea4pMFAnIMuuOehCg1PFdVM/BimTvuqAaQ1RPm0h1vmXH1+U2FFc4QyhsGhhf2kmVrsNgMLoe0PT9UFtLsYLH6UZ+SbB+YBDavTAiLaSRB5FgQ8Y5PPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Mateusz Guzik <mjguzik@gmail.com> writes:

> On Fri, Aug 15, 2025 at 11:32:24AM -0700, Roman Gushchin wrote:
>> If two or more threads of an application faulting on the same folio,
>> the mmap_miss counter can be decreased multiple times. It breaks the
>> mmap_miss heuristic and keeps the readahead enabled even under extreme
>> levels of memory pressure.
>> 
>> It happens often if file folios backing a multi-threaded application
>> are getting evicted and re-faulted.
>> 
>> Fix it by skipping decreasing mmap_miss if the folio is locked.
>> 
>> This change was evaluated on several hundred thousands hosts in Google's
>> production over a couple of weeks. The number of containers being
>> stuck in a vicious reclaim cycle for a long time was reduced several
>> fold (~10-20x), as well as the overall fleet-wide cpu time spent in
>> direct memory reclaim was meaningfully reduced. No regressions were
>> observed.
>> 
>> Signed-off-by: Roman Gushchin <roman.gushchin@linux.dev>
>> Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
>> Cc: Jan Kara <jack@suse.cz>
>> Cc: linux-mm@kvack.org
>> ---
>>  mm/filemap.c | 14 +++++++++++---
>>  1 file changed, 11 insertions(+), 3 deletions(-)
>> 
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index c21e98657e0b..983ba1019674 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -3324,9 +3324,17 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>>  	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
>>  		return fpin;
>>  
>> -	mmap_miss = READ_ONCE(ra->mmap_miss);
>> -	if (mmap_miss)
>> -		WRITE_ONCE(ra->mmap_miss, --mmap_miss);
>> +	/*
>> +	 * If the folio is locked, we're likely racing against another fault.
>> +	 * Don't touch the mmap_miss counter to avoid decreasing it multiple
>> +	 * times for a single folio and break the balance with mmap_miss
>> +	 * increase in do_sync_mmap_readahead().
>> +	 */
>> +	if (likely(!folio_test_locked(folio))) {
>> +		mmap_miss = READ_ONCE(ra->mmap_miss);
>> +		if (mmap_miss)
>> +			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
>> +	}
>
> I'm not an mm person.
>
> The comment implies the change fixes the race, but it is not at all
> clear to me how.
>
> Does it merely make it significantly less likely?

It's not fixing any race, it's fixing the imbalance in the upward and
downward pressure on the mmap_miss variable. This improves the readahead
behavior under very special circumstances: a multi-threaded application
under very heavy memory pressure. There should be no visible difference
in behavior in other cases.

Thanks!

