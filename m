Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E33C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 10:50:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A3036B009E; Thu,  6 Aug 2026 06:50:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 353C76B009F; Thu,  6 Aug 2026 06:50:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 243266B00A0; Thu,  6 Aug 2026 06:50:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EFCCB6B009E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 06:50:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 60900160711
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:50:31 +0000 (UTC)
X-FDA: 85070525862.20.DE4DCFC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9175320006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 10:50:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VPZtuL5j;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786013429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N6aH3IWhBuvYtU3jyYyQ38Aa7k9zKxtJGVyR123XyKk=;
	b=inQY1NshzKwSxEz+iu1YcxvDnjQbaWAhzxolqTMoswf1Wvj9nKqK6EjYOMMTwbSMq3mz2q
	zi7hlnBFhbczM/HlmV1uEAOR/9J+6NIvj5QhlD4UN72SgcSwUV/xeFQg9gpYMCcJdPvAxX
	+HvoQeYDIN9lUzrRlbqg+Eq6dhmXIMA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VPZtuL5j;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786013429;
	b=egB7RxcysPy/m6KlbKSicnoCdAC1KvStrRZdz5Gp8Zs/cmzRYsgGH7hOalrroXO3vSS6wY
	DEsNjwodYYM4sxkzVpD7S4etWx1dVO7AYvTJs5lyOV94VW3WCuhKlVT6BhD3KaLoB2G5tv
	B98AcJEUvhFY5Q65AyYG771Q8t0HokI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 88D0740491;
	Thu,  6 Aug 2026 10:50:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29C61F000E9;
	Thu,  6 Aug 2026 10:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786013428;
	bh=N6aH3IWhBuvYtU3jyYyQ38Aa7k9zKxtJGVyR123XyKk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VPZtuL5j3tQOtekLQ7kOVDseIfHGH5e5b4IjDJWQWyfGuDyEHmFasxyAg4Znie6lF
	 Cs5dkDB0jrbs5MFYwQbm3F0UpK684wLeGJ7s5CBFVSq1wSeXFnA6k+Gl+G7xtVmHun
	 2nxsLiVNyOsVv6jTwOohQOSd93cii87KioJLnuYwBjdKmHrHNj2AxORBcj0LwPbJsm
	 cVmcA+2urdOJJjPIRDLgo5mMvdKgnkUy9gsWSXaNXDRIzBytPEeDhllvcYEjBy611V
	 4q+gzfRRr48ZCgjM3YHpKL8eEX43RKoz0P7AIhh5YOvIiXN531OhTGkvlkcG2aABiv
	 QVLJhIVXZdzow==
Message-ID: <0726ba54-a500-46a4-b42f-3e581da0f070@kernel.org>
Date: Thu, 6 Aug 2026 12:50:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory-failure: fix folio refcount leak and locking
 in soft/hard offline
To: Andrew Morton <akpm@linux-foundation.org>, dayou5941@163.com
Cc: linmiaohe@huawei.com, ljs@kernel.org, nao.horiguchi@gmail.com,
 linux-mm@kvack.org, ziy@nvidia.com, Li Youhong <liyouhong@kylinos.cn>,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260806031958.677935-1-dayou5941@163.com>
 <20260805213415.002dc67766271d21c232910b@linux-foundation.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260805213415.002dc67766271d21c232910b@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y7q3u85yx5oatwaxwtga6xo3xs9fpgfk
X-Rspamd-Queue-Id: 9175320006
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786013429-822468
X-HE-Meta: U2FsdGVkX19exK4GVvGaNA5FwmEu0UMX6VBGPt5IA6Z+Jk6glIMYHmdB5sFh+ldE5HOWFMHYwiY8KHEnI1dOzoacho+TZVMAMC+74D+FI5drBX7OlOH2ScE4z5r/CS6dx+zM32hHu3H0lR2sk/sdoDTBpD0BOXmNJ6F6NfSXxlxhf6oJhCUZUPX7SD7QOJVmwID2v50rvorOgtMI2UTiU2nQRV0IX6uW8+4kfeoAYsFAJWDpZY+4o4qU22wqfiDVVLqTap1Qk7vzM+REHOVWt+f0xm8g7dVn76Eyn447rlZ5pBtPlLm34H2CM9+nojpC5kX4iBq/K+rnhiZtV/VGUphMWQOeCwllQJ5NzQZYR760M+VliiUVDooXB/I5FuUR6KWJSh1bWzRyEjC32d4IhktCqhBulGfvk3yaaTUHvEvPoL7AxpbbQQBjnADtfh9Uva+zCU74h06byKQXa/gv8FSjDBpOmIxaFiL/zbah9dgXs89c99//BInW4lDkgE4pEGemlL/oi5LhS6gouKIVw93pOeinlbfCLwUB76SbUPD6sFVahgWBAXgNyhFYU9+IrVFaXIzaLTqyS9Jw49bSm6p7q1n2srpphPQT84B6Gl/7Dsh991bSRM7bHGx8TSc0fy3Ay8fNngSzK9ZLD/pQAFivDAmc8+GrgSsCWU1i2+ysyrK5vvTAqy21JQjSXNw9m9SBCj4MabDSCRsjG9ba29avHUgYWPkpxyT07MR71E2Roxv6ZaLFz8JsiYFeCfYrZOJII/n9YYqmoJJeY4E0TWzeibkbD1f0eZf9OMAZ1tiS3fs5rpArmD7Vqiw9b64862QiyvNlIVIbw0bl4GK/T2dQVev8xy2XGSaefnykw5omoehBB8b0Aq714nnMw1uMueZJIl5uRaJ6tiXzbl8zwqwelmjW2VfuCS5AiNfV6bei78OO4GWrsFFDOBVxD6aKobWcitkFy0EZ9Bk7agK
 aJsm/QHW
 JLDnADNhX0ymr51jAfljeqNo3pgvcm9g6thWzkQHCaISIU4TVoPcriHFM30OQ2mpXd5MCnCPFK9LQ5MRFih6c0Y8Jp/peRRt7q4CKaUSQD9AhGfbaE38TveDi0sASnE4Q2PnjfEbDWcUyQx/+ck+3KAW7+KRcYMhPATNpztfiU5Z0UcI0xRtWzn0eal7nMDiM401tBpjWy+MPCF4UpWRWacGre7GCQu1C27pHiq6Df/7IOHODicePcxZXhpWhK++Zkf6Xz+IplztYi+Z/QoV497VEQrrz/n5m87aan7xEFgViTPje6LKMAv0kE1Ekvq+u2ScGy2c4DNBeKdhIbq8z8IrXhwcgksEeLmxfWyrYKGLRbLUSK5uLNV406+emN0mAzJJrytU6lCDjECamTbrAo7lwbRFH0kybHD1DednN6yWI/5po1jCHiRilqaCo3+Q92T8A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/6/26 06:34, Andrew Morton wrote:
> On Thu,  6 Aug 2026 11:19:58 +0800 dayou5941@163.com wrote:
> 
>> From: Li Youhong <liyouhong@kylinos.cn>
>>
>> The min_order_for_split() function accesses folio->mapping without proper
>> synchronization. In memory_failure(), the folio lock is dropped before the
>> call, and in soft_offline_in_use_page(), the lock is not held at all. This
>> means that while min_order_for_split() is executing, the value of
>> folio->mapping may be modified by a truncate or invalidate operation,
>> leading to a torn read or use of a stale mapping value.
>>
>> Additionally, the soft_offline_in_use_page() path fails to release the
>> folio reference taken by get_hwpoison_page() when new_order != 0, causing a
>> reference leak.
>>
>> Fix these issues by:
>> - Moving the split operation logic into the callers and holding the folio
>>   lock around min_order_for_split() and split_huge_page_to_order().
>> - Removing the try_to_split_thp_page() helper to simplify refcount
>>   handling.
>> - Ensuring the folio reference is always dropped before returning on the
>>   soft-offline error path.
>>
>> This refactors the code to be more maintainable, fixes the locking issue
>> reported by Sashiko, and also addresses the folio reference leak on the
>> soft-offline error path.
>>
>> ...
>>
>> --- a/mm/memory-failure.c
>> +++ b/mm/memory-failure.c
>>  static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
>>  		struct address_space *mapping, pgoff_t index, int flags)
>>  {
>> @@ -2440,7 +2420,6 @@ int memory_failure(unsigned long pfn, int flags)
>>  	folio_unlock(folio);
>>  
>>  	if (folio_test_large(folio)) {
>> -		const int new_order = min_order_for_split(folio);
>>  		int err;
>>  
>>  		/*
>> @@ -2457,24 +2436,24 @@ int memory_failure(unsigned long pfn, int flags)
>>  		 * page is a valid handlable page.
>>  		 */
>>  		folio_set_has_hwpoisoned(folio);
>> -		err = try_to_split_thp_page(p, new_order, /* release= */ false);
> 
> AI review asks (effectively) why the try_to_split_thp_page() return value
> never gets used
> 
> 	https://sashiko.dev/#/patchset/20260806031958.677935-1-dayou5941@163.com
> 

No need for AI. Just from compiling:

  └ mm/memory-failure.c: In function ‘memory_failure’:
    mm/memory-failure.c:2492:21: warning: variable ‘err’ set but not used
[-Wunused-but-set-variable]
     2492 |                 int err;


I'll send out a patch myself that already addresses everything raised in here
without even me reading any of it.

-- 
Cheers,

David

