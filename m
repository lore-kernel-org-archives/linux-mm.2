Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F744CA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 02:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07968E0006; Wed,  3 Sep 2025 22:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB7B58E0001; Wed,  3 Sep 2025 22:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7728E0006; Wed,  3 Sep 2025 22:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 885648E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 22:05:03 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E002286986
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:05:02 +0000 (UTC)
X-FDA: 83849924844.18.D045FF6
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id EBE5B120006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:05:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PBoO7+D9;
	spf=pass (imf29.hostedemail.com: domain of youling.tang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=youling.tang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756951501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9/dDcohtOSgVy/WDEh4unk/zCXlMwusIhig033JTFsg=;
	b=7ulLFZR8LpYOTQ0jTzYyFtjCiGioah48MLCJpu+YZIj1CE1pFq1Ex01ajoxzksARbWjpXp
	4s5nTU+4zbwPG5JblLUvTUkJQ7I+vtNoNDThaoeSX4IxCM/uVykGLd7P8GtNmD7BfXhjZZ
	1KYsgWBPy7mlZjSjwC/tZ3eQYEhp8Oc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PBoO7+D9;
	spf=pass (imf29.hostedemail.com: domain of youling.tang@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=youling.tang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756951501; a=rsa-sha256;
	cv=none;
	b=Yc8ig2OWmtR9mV001THOenpk+hWe/XotZ9u1mlO27zldoC5iNQwFVnAdLFmP1rsfx5wA+D
	a6/f2E2vZpulOr/fCUG9S6m2Q131f8UDC3ieLRkFvpmgpAo51IP7zi2lb6d0+HrDvK392n
	sY3u3qTg/ZzWoCBkqiZvt3WJKIwQW7c=
Message-ID: <1bc6d342-37f3-41c8-a001-36f2784db1bc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1756951498;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9/dDcohtOSgVy/WDEh4unk/zCXlMwusIhig033JTFsg=;
	b=PBoO7+D9kyMr5jl78k+ypGDjwJJvjYFmS6gbmS67xly5UbTYlyse0Pb4Lwp1u2e1hH3L9i
	qEaP9jvhOh/IBt8kcCExCKmoVxbXlwqOlyKnJccXH/EE+ocNX/ktCyzAASU5bpGzSD8bay
	O2vwHG8gQJ0ObG49ZZJu4quvza2yu1Q=
Date: Thu, 4 Sep 2025 10:04:17 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm/filemap: Align last_index to folio size
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <willy@infradead.org>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, chizhiling@163.com,
 Youling Tang <tangyouling@kylinos.cn>, Chi Zhiling <chizhiling@kylinos.cn>
References: <20250711055509.91587-1-youling.tang@linux.dev>
 <jk3sbqrkfmtvrzgant74jfm2n3yn6hzd7tefjhjys42yt2trnp@avx5stdnkfsc>
 <afff8170-eed3-4c5c-8cc7-1595ccd32052@linux.dev>
 <20250903155046.bd82ae87ab9d30fe32ace2a6@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Youling Tang <youling.tang@linux.dev>
In-Reply-To: <20250903155046.bd82ae87ab9d30fe32ace2a6@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EBE5B120006
X-Stat-Signature: pwayne5dcdbp81xewzs7x6n1h3w6ogq6
X-Rspam-User: 
X-HE-Tag: 1756951500-796489
X-HE-Meta: U2FsdGVkX1+uqg4bIfWpEoLBk2kpL4yz8wBjsGZwRHq/xjgY5/MGEf8DbEdRkmIG89dYRLxkrFF+iBlwlh6Wf48U5v3BklUEi8VAHeEEK5k7ikTl4Lmj8Xv7efC+Qe3mQjdecD+PsyBCEpEp+LNW0xdlE2kD3RLjkwh/NhmdIy2JQwoh73/r16fqCbu3Zf5kqBwUnkyuOc0J2zSFJ0u0zX8s3UdwY1hzkEWfdwAi5Rz78xS6+i2tXmfIc8oIDPqdvN5OX9vvpwMZcSHTQeZIph/bRujp06FbPeEspdStMCrQUvH57T9Ba0wj6Tbgfcc4YaBWoiF9BUjcSJO6hBsP+oqO5oZfG3BGi0SlRw7jxNSO+hfVzhO8178wKWJgoAUoI+ZH/+v48WlBTH+EJHNHtgnKUznJaYF7TmHLRXM2CFqC1Nwn9v5HgvHLsFF/5PJqh6S+72n9QwFn10GSeLIqvv8TvZmbsthrJ0sBbmHDdMCUlq9z8es07M8ePGI1Dahu9hBjCE5jb581/PgHzPnqVMAgDtw4ch1VmYx7dfx5e6AWYKPMXO5zTb54TZHexS4K1CTQMFP/7CNp4QF42RuWEhSgLvzp6uLRjBdRLngGrQjPYTOcIKYAYI0GagaYiFPj/1K4dXgtwnR8Vi4WVEIEsGbkC6Jrkmu+h5YXyBgIGD0TlHvuqO+6gL1F7AchCpOiGnJxrzzASKgGlsr7x6JDaoF/E6kXu4/qcVp4gIVQh8sSd1OCPI8BC5pA4STp+o+wcm4k2/N3PVlPAQGjzROn+mdBkdh/ql2MPsUzQDVVTY7qBkSEcK5sBmGgXhWUs/Gaxunz8fXqVJT//Yoq9bC36vOx4GsHVk+RmpVVOa306WPtVA8mZlpRcTotLa7UxTbyes1VFC/OEPrffMTQT5TSOkd4i93u5/8/cG2oDejSN9NwDSLK365WkAVcfQ8PK7oewclZuZL4VRhNdsvhvOQ
 YM+KDoTC
 s2wyICq7C/3f1+vXIS828pgXgcsIATTgVbSetmrSSYM2FRHgJsIP5oCyfuYdKbHmd+POkJs39bYXY48nFGhqA0G7BZXk1z8A/nxfJpglig/2tNk5pdJ5trF2mzm09Q3JYOVo6H9wutz3oGc1P17CvUCHNzlPxnnOBcoE3QJaNPqXIuywR8ARmnBxjhM6B/Wc4y5sh/PMoADTPecJdMA0BGeT/2c+aoHObhwhhki8oSovCyl3EUAKyZcx4979FGx26X97b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/9/4 06:50, Andrew Morton wrote:

> On Tue, 12 Aug 2025 17:08:53 +0800 Youling Tang <youling.tang@linux.dev> wrote:
>
>> Hi, Jan
>> On 2025/7/14 17:33, Jan Kara wrote:
>>> On Fri 11-07-25 13:55:09, Youling Tang wrote:
>>>> From: Youling Tang <tangyouling@kylinos.cn>
>> ...
>>
>>>> --- a/mm/filemap.c
>>>> +++ b/mm/filemap.c
>>>> @@ -2584,8 +2584,9 @@ static int filemap_get_pages(struct kiocb *iocb, size_t count,
>>>>    	unsigned int flags;
>>>>    	int err = 0;
>>>>    
>>>> -	/* "last_index" is the index of the page beyond the end of the read */
>>>> -	last_index = DIV_ROUND_UP(iocb->ki_pos + count, PAGE_SIZE);
>>>> +	/* "last_index" is the index of the folio beyond the end of the read */
>>>> +	last_index = round_up(iocb->ki_pos + count, mapping_min_folio_nrbytes(mapping));
>>>> +	last_index >>= PAGE_SHIFT;
>>> I think that filemap_get_pages() shouldn't be really trying to guess what
>>> readahead code needs and round last_index based on min folio order. After
>>> all the situation isn't special for LBS filesystems. It can also happen
>>> that the readahead mark ends up in the middle of large folio for other
>>> reasons. In fact, we already do have code in page_cache_ra_order() ->
>>> ra_alloc_folio() that handles rounding of index where mark should be placed
>>> so your changes essentially try to outsmart that code which is not good. I
>>> think the solution should really be placed in page_cache_ra_order() +
>>> ra_alloc_folio() instead.
>>>
>>> In fact the problem you are trying to solve was kind of introduced (or at
>>> least made more visible) by my commit ab4443fe3ca62 ("readahead: avoid
>>> multiple marked readahead pages"). There I've changed the code to round the
>>> index down because I've convinced myself it doesn't matter and rounding
>>> down is easier to handle in that place. But your example shows there are
>>> cases where rounding down has weird consequences and rounding up would have
>>> been better. So I think we need to come up with a method how to round up
>>> the index of marked folio to fix your case without reintroducing problems
>>> mentioned in commit ab4443fe3ca62.
>> Yes, I simply replaced round_up() in ra_alloc_folio() with round_down()
>> to avoid this phenomenon before submitting this patch.
>>
>> But at present, I haven't found a suitable way to solve both of these
>> problems
>> simultaneously. Do you have a better solution on your side?
>>
> fyi, this patch remains stuck in mm.git awaiting resolution.
>
> Do we have any information regarding its importance?  Which means do we
> have any measurement of its effect upon any real-world workload?
No measurements were taken regarding the impact on real-world
workloads, this was merely a line of thinking triggered by unusual
readahead behavior.

Thanks,
Youling.
>
> Thanks.
>

