Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81EA6CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 11:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D800F8E0002; Wed, 17 Sep 2025 07:05:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30EB8E0001; Wed, 17 Sep 2025 07:05:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46578E0002; Wed, 17 Sep 2025 07:05:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AEF418E0001
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 07:05:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 590CB868DE
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:05:59 +0000 (UTC)
X-FDA: 83898462438.24.3B7831E
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf10.hostedemail.com (Postfix) with ESMTP id 325F0C0005
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:05:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lvRnFj3K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758107157; a=rsa-sha256;
	cv=none;
	b=x0gqTE9gummDu8DNSYMgFgQgwlsePMxuzQ89KfloIKwno2t4T1UzRAmXHQzFxtCfJrSTs1
	nE4LDpj1aWAS6M1K8+t28ji/jUyihtgOOWf2bPzBbhDzBUnxhswWrAHe7oqFwl6KmQO8GN
	n2Dv4pG07IL8x3hs1k3mBz7L8nv1nXM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lvRnFj3K;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758107157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TuuVoVWXNYbl+ds4b8F2xNM0nTUIAdxFSHG+zKy+0Ho=;
	b=dPjOOYe25H8/511h2n6XEYv+Nfl05j3rZ9XfMA7uKUH7BgJL2Li/WO0/LDrgI/O08GMbgW
	HgE5pFliU7cKUI38BYtiNRmk5vooVSeoAhPIN9LiApzJS2TdgUUD0ZOORJmrvRAxEA2WUH
	kPU4IRSAKKfftFwoM6QyNujHI7J140s=
Message-ID: <1e75f092-b3ac-48d9-a304-c980e1d61472@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1758107154;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TuuVoVWXNYbl+ds4b8F2xNM0nTUIAdxFSHG+zKy+0Ho=;
	b=lvRnFj3KdzdsDt8rnP8I8JemxUlfemkDZK1FMj4IeOLHK++G2cTWs6v75mkO745sIBJf6g
	diqCfbSHzhn9dc/JmzXuR5/6qcNySJy+behVS5O9VkOh150PtAMA/kfzNDSpYRHqY+P0d9
	JsKzG0wdMdDmkN5Hxfa/vhBZ6p8QcPs=
Date: Wed, 17 Sep 2025 19:05:47 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RESEND 1/1] selftests/mm: skip soft-dirty tests when
 CONFIG_MEM_SOFT_DIRTY is disabled
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: shuah@kernel.org, ioworker0@gmail.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <20250917055913.49759-1-lance.yang@linux.dev>
 <353bf8f0-d9ad-4800-80d7-4177ae64eb95@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <353bf8f0-d9ad-4800-80d7-4177ae64eb95@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 325F0C0005
X-Stat-Signature: a6w75ezzex8qu16wdwo1qgfuysjb9afu
X-Rspam-User: 
X-HE-Tag: 1758107156-884535
X-HE-Meta: U2FsdGVkX19g+wWnmYNmiMP5vwf9n7+MjTVesZ3nVYEK4ipEVT3+tWmacafBNQFAenLgmA8l1tv9gh/Kt8Tm41GjrvSJDRj2leY5C1NWw6n6ShOr1WtG5unT8+jFHBwuES85TM6A9qVHIAnQk9aKLwNx5WPcQumbzAovWA571hxwSWE/xvx3DenQ+dWQQH+ZfjW8eG8WCNkmi6S/rWetfNov3H2+XCDfr7HP/aXPQz8kIZZDJX+mJUH+9iTFI31asE+YVW6Ocs8Y//iH4wPH1re+5a2/tG6SMjwgDcSbeCwsS7NctXEihOmZDKagFqN7YRJexovsRTxhG4ztXd9Uauofxwi3gU0POYpWrWW0XW1q8M++maZyzEXI+gmFcU/PrpN+17POJR3L1G6+F91goLeeWjMvgDWeMRubsRf/YrA9x81X6ZZNZiGKgn3gAEpY5Zs4uCgRNvW5BH//8nZQLleBIR/wENjn39TSXQfaEnuzpmIdiYLcdMXmc5BJnTpr8PLe/VxbsN39mftwO0WwM5YikZtTh2k+7Dw7FgMKASLziZLYg+wxOmUFgRZpq9CRS7mEujt5vLFJ1HdxBd6GHPFURVV2pEs0MoJr2Ic2/tSkXUNizNH9Go6NZ5mBYOhdTBKddAGq0WquoFYA5fBLYkUZWoPmDzEHjkXoVDnj7KUqrjfnpiO+ixzy9oK05xXTG1KaxURbqUdIyc3jv6B9ea1hhhpLC37p4c+jCQlRjm059sNtOHY6AD5whMomeZB6wJ/v0nO+u0vuFO1yemnTcY56+Ogw8JvuvX6eLmw+/dhuqAPeI+mrMkLP4WHZCu74vzG1iM9kKpD8t6b2gEUO9VSHKRrDHQF9H9bDSjL2LwZ5Gp65os/T8IR8gLqtIlNtzpJpnCDWtcJK6h6Q+CQSG6Ka44Nk45HdJ6YIrJHSvy2mvS9OMUN0bmwv/h4ZchVCD5WzOB+G5YYJ0K4wov1
 wjG7ozqA
 k7gm00TxhIww8KMhD+rJUAS+/yJJDw3KNQm9S8unN0uAFJeZN4l700IE1x+97alkmUtpgp4iqcqr7a5lA/VGOVVFRw1k0EXMLUaie8F8VGpKtcBz99i/b75BbkG3TjL6QnLrmjhV0gMmV9qKFciKGl499X+BLY3Y3hhdSRYq3ovfc7QcPoJsNoNXe0Zgn/jwO2tnnIC6S5KCyyIjP1Yw29Jn7uA10HHlxojB5pOgLe19xEcr+ic0ZxvZuytBM2b6IW9i676YLZ/8Xcsk/7bkHw2yYK2lDSiRrRuqjW5J8aissYcS3yyAaInYpgg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/17 18:51, David Hildenbrand wrote:
> On 17.09.25 07:59, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> The madv_populate and soft-dirty kselftests currently fail on systems 
>> where
>> CONFIG_MEM_SOFT_DIRTY is disabled.
>>
>> Introduce a new helper softdirty_is_supported() into vm_util.c/h to 
>> ensure
>> tests are properly skipped when the feature is not enabled.
> 
> I'll note that tools/testing/selftests/mm/config contains
> 
>      CONFIG_MEM_SOFT_DIRTY=y
> 
> But yes, the current arm64 handling is nasty, because some other archs 
> (e.g., riscv) also don't support it yet.

Yep.

> 
> LGTM, some nits below:

Thanks for taking time to review!

> 
>>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>> ---
>>   tools/testing/selftests/mm/madv_populate.c | 21 ++--------------
>>   tools/testing/selftests/mm/soft-dirty.c    |  5 +++-
>>   tools/testing/selftests/mm/vm_util.c       | 28 ++++++++++++++++++++++
>>   tools/testing/selftests/mm/vm_util.h       |  1 +
>>   4 files changed, 35 insertions(+), 20 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/madv_populate.c b/tools/ 
>> testing/selftests/mm/madv_populate.c
>> index b6fabd5c27ed..43dac7783004 100644
>> --- a/tools/testing/selftests/mm/madv_populate.c
>> +++ b/tools/testing/selftests/mm/madv_populate.c
>> @@ -264,23 +264,6 @@ static void test_softdirty(void)
>>       munmap(addr, SIZE);
>>   }
>> -static int system_has_softdirty(void)
>> -{
>> -    /*
>> -     * There is no way to check if the kernel supports soft-dirty, other
>> -     * than by writing to a page and seeing if the bit was set. But the
>> -     * tests are intended to check that the bit gets set when it 
>> should, so
>> -     * doing that check would turn a potentially legitimate fail into a
>> -     * skip. Fortunately, we know for sure that arm64 does not support
>> -     * soft-dirty. So for now, let's just use the arch as a corse guide.
>> -     */
>> -#if defined(__aarch64__)
>> -    return 0;
>> -#else
>> -    return 1;
>> -#endif
>> -}
>> -
>>   int main(int argc, char **argv)
>>   {
>>       int nr_tests = 16;
>> @@ -288,7 +271,7 @@ int main(int argc, char **argv)
>>       pagesize = getpagesize();
>> -    if (system_has_softdirty())
>> +    if (softdirty_is_supported())
>>           nr_tests += 5;
>>       ksft_print_header();
>> @@ -300,7 +283,7 @@ int main(int argc, char **argv)
>>       test_holes();
>>       test_populate_read();
>>       test_populate_write();
>> -    if (system_has_softdirty())
>> +    if (softdirty_is_supported())
>>           test_softdirty();
>>       err = ksft_get_fail_cnt();
>> diff --git a/tools/testing/selftests/mm/soft-dirty.c b/tools/testing/ 
>> selftests/mm/soft-dirty.c
>> index 8a3f2b4b2186..98e42d2ac32a 100644
>> --- a/tools/testing/selftests/mm/soft-dirty.c
>> +++ b/tools/testing/selftests/mm/soft-dirty.c
>> @@ -200,8 +200,11 @@ int main(int argc, char **argv)
>>       int pagesize;
>>       ksft_print_header();
>> -    ksft_set_plan(15);
>> +    if (!softdirty_is_supported())
>> +        ksft_exit_skip("soft-dirty is not support\n");
>> +
>> +    ksft_set_plan(15);
>>       pagemap_fd = open(PAGEMAP_FILE_PATH, O_RDONLY);
>>       if (pagemap_fd < 0)
>>           ksft_exit_fail_msg("Failed to open %s\n", PAGEMAP_FILE_PATH);
>> diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/ 
>> selftests/mm/vm_util.c
>> index 56e9bd541edd..3173335df775 100644
>> --- a/tools/testing/selftests/mm/vm_util.c
>> +++ b/tools/testing/selftests/mm/vm_util.c
>> @@ -449,6 +449,34 @@ bool check_vmflag_pfnmap(void *addr)
>>       return check_vmflag(addr, "pf");
>>   }
>> +bool softdirty_is_supported(void)
> 
> I'd just call it "softdirty_supported" similar to 
> "pagemap_scan_supported()".

Got it.

> 
>> +{
>> +    char *addr;
>> +    int ret = 0;
> 
> bool supported = false;
> 
>> +    size_t pagesize;
>> +
>> +    /* We know for sure that arm64 does not support soft-dirty. */
>> +#if defined(__aarch64__)
>> +    return ret;
>> +#endif
> 
> Just drop this arm special case now.

OK

> 
>> +    pagesize = getpagesize();
> 
> const size_t pagesize = getpagesize();
> 
>> +    /*
>> +     * __mmap_complete() always sets VM_SOFTDIRTY for new VMAs, so we
>> +     * just mmap a small region and check its VmFlags in /proc/self/ 
>> smaps
>> +     * for the "sd" flag.
>> +     */
> 
> /* New mappings are expected to be marked with VM_SOFTDIRTY (sd). */

Cool. Much better!

> 
>> +    addr = mmap(0, pagesize, PROT_READ | PROT_WRITE,
>> +            MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
>> +    if (!addr)
>> +        ksft_exit_fail_msg("mmap failed\n");
>> +
>> +    if (check_vmflag(addr, "sd"))
>> +        ret = 1;
> 
> supported = true;

I'll adjust as you suggested ;)

> 
>> +
>> +    munmap(addr, pagesize);
>> +    return ret;
>> +}
>> +
> 

Cheers,
Lance


