Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CFEDCD4F2C
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 07:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C125A6B0096; Fri, 12 Jun 2026 03:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA386B0098; Fri, 12 Jun 2026 03:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD9706B0099; Fri, 12 Jun 2026 03:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DDA36B0096
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:35:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B679165A15
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:35:31 +0000 (UTC)
X-FDA: 84870450462.14.819D4D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 81C6140011
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 07:35:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dw41I0KG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781249729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S8tXmCVe6Dq2p9EIVnNxhFn9TuFpBDLwCbLsDYh9a/4=;
	b=odeiC+pQMiVS2dB64ae0vy+BtdSxBsozKWsqHi0K18OudS/C01VLINPe+y+3dkd3z/ncee
	GClvTAM3JBu9WD+t13nc3AyFpSxEbl5UzDFOCsbjwDpzxbciykki+3v8d+JE0e2eHVS5jR
	uGTURygmGtsq/MF4rNE9kVOV8Nk373Y=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dw41I0KG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781249729;
	b=QHkAxzgS+rrNqG/jKp/FGCA7/0gncU7vjirbbU8R+c/bzCqSPzDeKnoptnxQS+Q3kde6hV
	PfCpdCnFBj0RAtWnugAlGzof1bIQBBfONFoqTGQ54y1xMGfmibUsMfdWEt/+CNiI6v8r4Y
	dnaN6SOYC6PVPYhqo1ghrF58xZTbPOk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AA7B6438AF;
	Fri, 12 Jun 2026 07:35:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1EAE1F000E9;
	Fri, 12 Jun 2026 07:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781249728;
	bh=S8tXmCVe6Dq2p9EIVnNxhFn9TuFpBDLwCbLsDYh9a/4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dw41I0KGmcYOKqDkRFzNeMeBtkob/gBxFAWH1wEeldyPh3p+C4YgF7hRiawytWCjm
	 l+tQKR0a9KqVSlZZ044nX9x4gAnA1lr01x+H44DQcoHyRbXVrf6o2p6kB06jmrZJw/
	 5sF+D2BW4WvwHvx5174uapQzgoqZK/z2YwdRl/f5IfI5hBJFwVf4/HaiL6QQXX7VTc
	 EZxlVxxaZIRNSjX4EXLzgR2RA/grfrCDN86buvzST9ZRwyZ+FOvehDiv6WTMxEaiqa
	 j4wCgrl70ReuumqCWCywmwW+6jI9TGP3+kL7FcWzXZYMJ5eBB5YHi7tAMIwlSLjMh/
	 uUr9Aousv83GA==
Message-ID: <63ed20dd-e572-4ac5-8cb4-7eed2f42f2fc@kernel.org>
Date: Fri, 12 Jun 2026 09:35:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests: mm: fix and speedup "droppable" test
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
 Anthony Yznaga <anthony.yznaga@oracle.com>, Mark Brown <broonie@kernel.org>,
 Sarthak Sharma <sarthak.sharma@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 Aishwarya TCV <Aishwarya.TCV@arm.com>
References: <20260612012910.84424-1-sj@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260612012910.84424-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 81C6140011
X-Stat-Signature: feugew94rxmc6k9jx4k1u18oiuauz5zh
X-HE-Tag: 1781249729-102854
X-HE-Meta: U2FsdGVkX19Hb7raIeEal4Jn0HKla/7Bobx++a0T4hepCTGDaSsRyJ9+mOT3BzuyEr3afYocXJkBYUmkVhEkqjRi0pT8VsLbbVv1tauZs6O23t6PoxXxBXyr/uU52QioNjKHEyN6ZexRUmNV8YMPBowqfXejQa6ocU2AZBjHGClGsYj81GZ0LrSxOixUMcn9E7rSzOSn6Novq+V6mpcGmLIHcnJwbOck+OjWv0BfyExtPwsMKABii2+B7jLBhquDgYDemd3WClKZd/XYcpELIlXChpGoUNONEf3eNPqC9j3AuZdAHWqIQYxgULtoQyzyJ6wZQSsJ5+YuAb+IERmbTb7H24LDJF56fAYuy8m4obi3Os6tzlp8D4r7ym26MOvLbgRVrvymWj23GVG9WEd9jzgBql/iEmbc1poSOX0MzTwfjE7yHwFoTVcWbeR42XiNfcZAMDAQPTxddaw9xKhQkPBROMXXJ7zHPGnwL52xBmAks565/1u7/LGiRno5FH+jcmqW/bKEePtLkRmw7xxGuQzs1zz0GNA+/8mukibcJkwIKBe3J2OFWaT7J69ecGW3fb0vug8AhpitnGs1rVUB0GMHOzNTtV7D5RkghC2yi911S7AdtBEN1ITPLEueKhvPZngi/OM2WjdsjU533eU7xNx81klQhsyPKOOYoRF5x6nvrQZ6ohl+Lhc+gUYjjPHOn4CKUKNNkfcbOMcGFwAQJWINC9CkFayGOixjI8buhZ1CW7KZewutB7gAw1YqA98fzZNBF7A/LOsJXpsi88QSS2LNRniXqDrGuiz8whhaUtl5y+nTsgU8gY3HUnsbrgDgpjraeRaU8cQnbJ4xH0s1h8CbzKzfvE1GhoNmyVpQTo3SBd4LZtY7m+BRYWTusnMx0tL8tPtAyLwukFyzVpyYIImYwApZahnolSmMfzJ04UX+0eAcEiUSt4bHfs4oN2uDlGbmB41auCL/sptTQCm
 eh/a4Rzx
 s2HwrE9lq/TmXQjEnKrwA13lTG4c3/3whV1kKDJ9a1C4NWF8wTyvlFOobV5SElxDKgMn8I+RP4UauXGDypzr09YlXcB+dE7eQivgglE4weHtAD9Iocc/ISUUHm2BaKoxwEzi85HotWvbxBDyPjZvnSluB7s5c1H309AuOv7C9axLA5CVSakv3HrndhGNsyWKe4jjT+ASQEU1/iAX6msPdXfNQ+/8rEogKQp9LkKxGW0P0SJ3zOD06S3T2Z/QXB0ZqZOb5luSciNPZ/MVfT8eGl6Z6Cwo0r62hnmAeFGLRUTlQs7tjUS0+cs8oSOEu5JFrQYZ7+pEc0a2oL4D+f3zWsegsWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 03:29, SeongJae Park wrote:
> On Thu, 11 Jun 2026 12:01:55 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:
> 
>> The droppable test currently relies on creating memory pressure in a
>> child process to trigger dropping the droppable pages.
>>
>> That not only takes a long time on some machines (allocating and filling
>> all that memory), on large machines this will not work as we hardcode the
>> area size to 134217728 bytes.
>>
>> ... further, we rely on timeouts to detect that memory was not dropped,
>> which is really suboptimal.
>>
>> Instead, let's just use MADV_PAGEOUT on a 2 MiB region. MADV_PAGEOUT works
>> with droppable memory even without swap.
>>
>> There is the low chance of MADV_PAGEOUT failing to drop a page because
>> of speculative references. We'll wait 1s and retry 10 times to
>> rule that unlikely case out as best as we can.
>>
>> On a machine without swap:
>>
>> 	$ ./droppable
>> 	TAP version 13
>> 	1..1
>> 	ok 1 madvise(MADV_PAGEOUT) behavior
>> 	# Totals: pass:1 fail:0 xfail:0 xpass:0 skip:0 error:0
>>
>> Reported-by: Aishwarya TCV <Aishwarya.TCV@arm.com>
>> Fixes: 9651fcedf7b9 ("mm: add MAP_DROPPABLE for designating always lazily freeable mappings")
> 
> Because this is a fix for a test, I think not Cc-ing stable@ is ok.  Further,
> arguably this is not a fix but an improvement?  No strong opinion, just
> thinking loud.

The test will hang forever on very large machines and timeout on large machines,
so it's a fix not just an improvement.

I think Andrew just automatically CCs stable on any test fixes, so yeah, CC;
stable makes sense for this one as well.

> 
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Reviewed-by: SeongJae Park <sj@kernel.org>
> 
>> ---
>>  tools/testing/selftests/mm/droppable.c | 46 +++++++++++++++++++---------------
>>  1 file changed, 26 insertions(+), 20 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/droppable.c b/tools/testing/selftests/mm/droppable.c
>> index 30c8be37fcb9..57e1b6fc5569 100644
>> --- a/tools/testing/selftests/mm/droppable.c
>> +++ b/tools/testing/selftests/mm/droppable.c
>> @@ -17,10 +17,10 @@
>>  
>>  int main(int argc, char *argv[])
>>  {
>> -	size_t alloc_size = 134217728;
>> -	size_t page_size = getpagesize();
>> +	const size_t alloc_size = 2 * 1024 * 1024;
>> +	int retry_count = 10;
>> +	bool dropped;
>>  	void *alloc;
>> -	pid_t child;
>>  
>>  	ksft_print_header();
>>  	ksft_set_plan(1);
>> @@ -35,26 +35,32 @@ int main(int argc, char *argv[])
>>  		exit(KSFT_FAIL);
>>  	}
>>  	memset(alloc, 'A', alloc_size);
>> -	for (size_t i = 0; i < alloc_size; i += page_size)
>> -		assert(*(uint8_t *)(alloc + i));
>> -
>> -	child = fork();
>> -	assert(child >= 0);
>> -	if (!child) {
>> -		for (;;)
>> -			*(char *)malloc(page_size) = 'B';
>> -	}
>>  
>> -	for (bool done = false; !done;) {
>> -		for (size_t i = 0; i < alloc_size; i += page_size) {
>> -			if (!*(uint8_t *)(alloc + i)) {
>> -				done = true;
>> -				break;
>> +	while (retry_count--) {
>> +		if (madvise(alloc, alloc_size, MADV_PAGEOUT)) {
>> +			if (errno == EINVAL) {
>> +				ksft_test_result_skip("madvise(MADV_PAGEOUT) not supported\n");
>> +				exit(KSFT_SKIP);
> 
> This check is for a case that this test is running against an old kernel that
> doesn't have MADV_PAGEOUT?

Yes!

> 
> Assuming so, I was first thinking this check might not really needed, assuming
> the test runner would pick the kselftest code from the running kernel's source
> code.  But I recalled some people do get kselftest code from random place.  So
> this check seems nice to me.

Yeah, we try to handle older kernels on a best-effort basis. This one is rather
simple :)

Thanks!

-- 
Cheers,

David

