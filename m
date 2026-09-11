Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2EC7C88E50
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 12:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BABC96B008A; Fri, 11 Sep 2026 08:13:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B842B6B008C; Fri, 11 Sep 2026 08:13:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A99356B0092; Fri, 11 Sep 2026 08:13:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B93A6B008A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:13:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6AC2401DB
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:13:36 +0000 (UTC)
X-FDA: 85201372032.08.DBFAA31
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf31.hostedemail.com (Postfix) with ESMTP id 90B0820004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:13:34 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PsNgFiPQ;
	spf=pass (imf31.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789128815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nxd9u4qc2n7UgUFMfUPPVHH+g0LyhtZrwQVuCkvobh8=;
	b=6XGkaVsO9TinHo5KBfXwkG2Mf2wsSeXaAlyVFAERH5nN3kMNPkSqscX7TGl+E5pWNTxKcB
	sAjP1s5V4kkGxGU84rlxX+OkpNumYLm8CXwLGuKHV0RFNPeG/2d4m5Ow/uJ71If4XySCvN
	dEXeS8CbXeOQkmR6/CCcDqahQNc5zLA=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=PsNgFiPQ;
	spf=pass (imf31.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789128815;
	b=JSNjrLz6LkgKVB+p5rBqK6XClTHb0q5BYnp7HHaDupG1yG9bzCJwmhq/VIUziSr4Q2lpwb
	oZDa1yp4ohhel7rPHFL8tgmChlOYCzeZdq9jr9r1fh/q4UGqskZ5jZrg6W2tXKSpi+dWr9
	9o2Jp2eC/d6PB2oChgCP6AlYVA2wyQs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ACA321655;
	Fri, 11 Sep 2026 05:13:29 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 284523F7B4;
	Fri, 11 Sep 2026 05:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789128813; bh=3ARyWm61iw1BqfDxGo8STCXa6M+CkI37zSWsMf0o0i0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PsNgFiPQBGgwRXK02n6NJ7SYnaSACCEAqJMUZOaMjEQ7NxxWh0vUkhNe11nt308zK
	 t/paB3YZ670AbJesUOL+EQBECepSVJa2m9yJmVLwDWkYkEMsmGTE4/1YZxY63iMwb9
	 Ovif+YtbpyPjpWWlHmjibaD8TlupaRYNvK2IaWxk=
Message-ID: <366c39ee-d452-4a1c-af0d-2badd4d8210f@arm.com>
Date: Fri, 11 Sep 2026 17:43:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/gup_test: safely calculate GUP batch size
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260903115033.162218-1-sarthak.sharma@arm.com>
 <cc0fdb0e-ab6a-4095-b559-10e1d8a616d9@kernel.org_quarantine>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <cc0fdb0e-ab6a-4095-b559-10e1d8a616d9@kernel.org_quarantine>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 90B0820004
X-Stat-Signature: jshckju6p4w93cy9pju8w3h97m85xx9w
X-Rspam-User: 
X-HE-Tag: 1789128814-337483
X-HE-Meta: U2FsdGVkX18sg9vIGHJX7ofDuHWLQ44y6BfR+i+d2JOmHliPGwO+rqJB4BzJukCLKvelx9QophzyliOmXqOmR8jhw75Afb1f195uRwIKaa+IuD9A24OKt08T4I/30sQ3UNSx8f/c5qmn9p3CjL4KMKs7KuSyF0VorwU5kngB597V764tMuRMjUtTdo+WaffvIsF9ygz//mXoQRvEKQyZP4VBKDYfZF0EO6OvsCL/iE/JrWSKuFuIlqRJD25ByjPVG7WpigTlcKUHyGO+Taz+Lr4x6Ei7/5gHVwGPpRRlQ110kHM8Q5UBDTEb7uujZ55PD4hn4tZSwrCvTEA3o92Enqqw2CiZwSVCC4dj2sNw5cncfjgF97XfmgrUTxR0HIyBJg6It0lMyj8qNC493IsP2ZR3j4vG5B9vs2JR4YmHHVEHLIDK5QFUinsfgZxMsF4h7iY92Z1gbBtXv2xEmnoc+uxm3e8JkL0QpODsz0VZizeZltMgiPo0HPr9cFoPUMR2QvNQXl0ATRzpcv+u93MN3I2QXtCkLfzr6HuefR/IrSundUw/fVjYabJRgKBT+f0Lbt6KMg+wwUN+rLuMzCghObSQ1k34qPxMGK7kIo49hIqoZaamI/lyZvfGGu4P7nkwv40adI3N4x8FfNqjj8PH5BIlU9aRbq3kOvudsMEoUMpx+dQRyPBOdq5ullujw4z60naYfT7lfzg7zxXM3cRUgvt7dBiQUxZOiBpaY6DXS9ufMYBLZy/xXZ1ddAA5WaNCo5LNKKF/Up0BiHiCOE1cM6/Jzyr448ux9jKN4TvH5OJwOsnOawMaSZ7cGVjpRSSzYYeIhDhgzEDfgZHEqgAPSfd4L/L3TW1dOFaR7eewqBwW2VzFJ7gaB4MCnZo3ap2vbhqMNzi1HiR85VI5Lf7wLxGqKIicW7M+SEpmixQJZDjwyZ/fSuJ2nFYyfCND/5pa39pDcyXm23y043LB32Q
 /Xf1hX2A
 J4efnlob/Xqj/zOan/d4nN/c9yE974Bj9dSm2RKBHlbRfrYTt7+IYJsU6fiDTVJ9SDT81kJ5vf7gK9YFW6aeE19YMaNNQxKBl3jorzOYzWSkgStczAi4VW8sAPoZkdjyx68WMt13Zar6zIX7pw47o2zhFPClPaRAMlgMGewqONM4NF7wUAD47poGiuXbcufO06Q+QRrUJ7vSsZKyW8TBXiHhkQDFREQ+QBbpCqN04WtjMinj7ZNBGHhyX9g8FfQUQItwEKTj/9FdUXDfRjJ0gbvyJ6O5ejO+vNVzxws+Jwey0T1+G7Jy2a5qwbp8JpFq210wJ4oc5z7Vrp/M1bfFdZwZ5uZwmiw2PaMz2H6zyoY89Seg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David!

On 9/7/26 8:20 PM, David Hildenbrand (Arm) wrote:
> On 9/3/26 13:50, Sarthak Sharma wrote:
>> __gup_test_ioctl() calculates the end of a GUP batch using:
>>
>> next = addr + nr * PAGE_SIZE;
>>
>> If nr is too large, it can cause next to overflow and wrap around.
>> If it wraps, the next > end check is bypassed and a large value
>> of nr is passed to the GUP call, even though the pages array was
>> allocated according to gup->size. This can lead to out of bounds writes.
>>
>> Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
>> contains zero pages. The code still calls GUP functions with pages + i,
>> which can point past the allocated array.
>>
>> Calculate nr by taking the minimum of the number of pages per call and
>> the pages remaining in the address range. Stop processing when no
>> pages remain and calculate the end of the batch using this bounded
>> value of nr.
>>
>> Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>> Sashiko reported the issue fixed by this patch while reviewing the patch
>> "mm/gup_test: report actual pinned bytes". That patch has been applied to
>> mm-new. Since the two fixes are independent, this revision contains
>> only the GUP batch size fix.
>>
>> Changes in v4:
>> - Simplify batch clamping logic as suggested by Kiryl
>> - Don't call GUP functions for an empty batch
>> - Drop the pinned byte reporting patch since it has been applied to mm-new
>>
>> v3: https://lore.kernel.org/all/20260901083452.115365-1-sarthak.sharma@arm.com/
>>
>>  mm/gup_test.c | 9 +++++----
>>  1 file changed, 5 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/gup_test.c b/mm/gup_test.c
>> index 185ba3bb8ed1..1b64e932c4c5 100644
>> --- a/mm/gup_test.c
>> +++ b/mm/gup_test.c
>> @@ -139,11 +139,12 @@ static int __gup_test_ioctl(unsigned int cmd,
>>  		if (nr != gup->nr_pages_per_call)
>>  			break;
>>  
>> +		nr = min_t(unsigned long, gup->nr_pages_per_call,
>> +			   (end - addr) / PAGE_SIZE);
>> +		if (!nr)
>> +			break;
> 
> Can !nr actually happen?

Yes, it is possible in 2 cases:

1. We calculate end as gup->addr + gup->size. So, if gup->size is not
page aligned, then at some point, we can have (end - addr) < PAGE_SIZE
and (end != addr). Then (end - addr) / PAGESIZE will be 0. Right now all
callers seem to provide a page aligned gup->size, but any userspace
program which can open /sys/kernel/debug/gup_test can provide a non page
aligned gup->size.

2. If the userspace supplies nr_pages_per_call = 0 (we never validate
nr_pages_per_call so it is possible).

Sorry for the delay, your email didn't reach my inbox due to some reason :)

