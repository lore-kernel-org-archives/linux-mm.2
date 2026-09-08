Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01FC1C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 10:21:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F183A6B008C; Tue,  8 Sep 2026 06:21:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF0336B009B; Tue,  8 Sep 2026 06:21:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB8C56B009D; Tue,  8 Sep 2026 06:21:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD8256B008C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 06:21:43 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 405BDA4B99
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:21:43 +0000 (UTC)
X-FDA: 85190203686.28.311FD06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 64B93A0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:21:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwuWX3nI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788862901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EdpJXbbMOseV/GzgjZcu5PmWeQ2rLXnmfc4HrvcGFIs=;
	b=5eKI5lE4VFqQ+OXeSAQsJjZm+Yz1T6E/ufVNQMVFpOajrIQnH791TOK35riLmXStdLXhXV
	SDOOB4IvxqqcX6avJ02m5rERB3FHWiKc4k8YcdGLrC8eXfMPmEt9YuIIJAr9eK1OSFztu4
	jsj6gG6aDedDavnmXKDLI9i4beI5eKE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MwuWX3nI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788862901;
	b=0L4EyGGs2UEyjDCEi7TYbma1K6EKmmQN/OLyy1CgxuK/ttz+YSHGbol1xcsBK7N7dzwUB+
	09nn7F263YTDtYzSy54xEmwCfrg9QyzH6QMU6P39n96miZgt6ad/Altk/np6Z0/NSnPkM6
	H17o3mJWexaQKE8mUdtKT2RP0iAPXeI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ADB1542D66;
	Tue,  8 Sep 2026 10:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E5B1F00A3A;
	Tue,  8 Sep 2026 10:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788862900;
	bh=EdpJXbbMOseV/GzgjZcu5PmWeQ2rLXnmfc4HrvcGFIs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=MwuWX3nI9kKlPLVmiAeITMKUOVyjcgiiv/9uUCx7t1YWMcpyiA+zkX6nav1+6YEh9
	 T3cDyFUZzx6XFHxXnmEJU57FJIAtpp43/YspXJAD5R0naz4JiriAXoWop84vZMOx1Q
	 iiatmVfHZtTj13NPzh/icKKWGQtfsFVSFnO64TtrPDQi09J4OhsWy2D89wxMr0MbFt
	 Gb35JegmIAgb/th/YOjLDO/Zy1mHo/0nbEsz51xQgJkPfImyHi4P40MBGjm9Pl6qQg
	 STx0gqiKUUpcjqTCr2gipy1NGrRRQTn8qDYnnWZKpRTWeN6NywV65N0RNgjmyTkfqO
	 HodiYzcxPMHOQ==
Message-ID: <0d93cd99-e1b2-46cb-ae31-a2dc4ca63d2a@kernel.org>
Date: Tue, 8 Sep 2026 12:21:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, sarthak.sharma@arm.com
References: <20260907081509.924979-1-yeoreum.yun@arm.com>
 <9f8c6e91-c1c8-4ec5-96a9-9d6d4ab571cc@kernel.org>
 <ap_GBdbMIkasmVO4@e129823.arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ap_GBdbMIkasmVO4@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5oezkei7h637d1zqywrjcsxddjohm41w
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 64B93A0004
X-Rspam-User: 
X-HE-Tag: 1788862901-310524
X-HE-Meta: U2FsdGVkX19PdlM0odiL+P/lKHDevRAcPpqHmDlCZm/elOIEd6fxuA42IkdA6j8Fw2Fkzl7NOPZpjWhxkr3DRmEqg38Owes1Y99HcbrTh1S27v3Kn2dSl/SjkESeBgPfZQ5x8wKtPGCzGuj2yv5UuoZfUhuYQj0og7liE59VACMTgZoksAuiCvsk4wQ7IepDEiIg4mVvVmuU92/LIr+385JmbScPmANWP2rSUEvUt6cTYYKEHYMpMqGya1kZr9afUwuBI/+3FQLKKz4JwvV9mDQNiPlEse0dj3+sGCE6OhJs2UqiGZBub19/TjC5M8goSK7XlrRHyaV7ASEQwbhSFWZC15eEccxO6GB4A8/yqxkQdYaKKlLTrcbVaPNN1GQ3Qkbuko5PRejA6xTp6sXu2rAvnL7aqkN6JBEFNxfogppq2nuFLscFWIjv0ofTdE9LgZlolzi3AM78Jrm/CN53++37nikMt/jKCncymHzIFKbU02VBKzEKHI6BpIaXmTg6QHu8r0z6Z8nXuN8+zdf8jTkVaAfibDpP8JtMu3Ie2vYbU+Cv5B8+GR31nT1huTqCICkTrHu9+ep1Z5+EYqyzuh75JIp5eZFNPW7pZC5Tdz0pUrRCeLZ0QH4V6OdeAHRA5nTGbunrLwaMRh1sb5QoPz2r7gJWPFEJkFU/dnCwjTgBnfIPcMw3vK5E/IjE+j8RaFNovzSbMOqGli+Qg1cXz6jxBO/r15xMOedeCj6larrI3FBJ8QzGmAgF+FPFqzPnYx9woX0WJk5kLLfSzFPb137LgCP/wkEPVeFUqR812lBu11eFQdARz+OExxjY5e9UbTPSialxDHuJ/Qxl22RBKMfGxnWkD+37Qr2PPSLRm1fDQ2juyJ8MWZldP9hQpDIRxFqeWZniDWm3NXEsq6aZTq/y/sOnMH/k0s5orA1l99itCa57tS2gqYc1hZunC7xEPt6QQdGB9CUekB4hadY
 Ia3PvSy0
 HVWwV2SBDYLcDfVVFoBAUxV5xoS3GxFu1qRAW8dvDr/XC19WaAU9BltROhNYodHs1s/wS6VXXo2ihl01APl5qtiKOxxZm/T6s7BEMgWMMT3cvxnXEUhkXn/UzxlUWct3+EycYz0OvF+hEBieFkXoIMRJYW9N8Ttxwr75Cbpva20bNKiwBnqN4PULVz9YRxAGNvBswAOCPSJXWp/7hT4BErJ9INU1IRAGMEgrKegBngZQ9X74DJXQrVfFV/1QAFjKLZ4mPNPCaCq284Sd0Hv6N8xrrv1XsU0wkyPAqTF9+Kn0Eoyh7ODXNGVrv6iewZE1jpY+MMNA428WzQEv+8omiZY+EhUtCpPCodqo5Fpl6UukGAI3yzD0mN9/Q7jekE4il7h7EJjSViiU9AvI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 10:23, Yeoreum Yun wrote:
> On Mon, Sep 07, 2026 at 04:36:56PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/7/26 10:15, Yeoreum Yun wrote:
>>> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
>>> When this macro is used in some test, test result would be strange in
>>> the system where PAGE_SIZE is more then 4KB.
>>>
>>> Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
>>>
>>>   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
>>>     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
>>>     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>>     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>>     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>>     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>>     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>>     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>>     ...
>>>   ok 1 Completed
>>>
>>> Remove the HPAGE_SIZE and HPAGE_SHIFT macros and introduce pmd_page_shift()
>>> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
>>> helper, read_pmd_pagesize().
>>>
>>> Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
>>> which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
>>> and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
>>> PMD-sized units, the test may fail with the previous size of 100 MiB,
>>> which is not a multiple of the PMD size when the base page size is
>>> 16 KiB or 64 KiB.
>>>
>>> After this patch, output of transhuge-stress:
>>>
>>>   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
>>>     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>>>     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>>>     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>>>     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
>>>     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
>>>     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
>>>     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
>>>     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
>>>     ...
>>>   ok 1 Completed
>>>
>>> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>>> ---
>>
>>
>> [...]
>>
>>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>>> index d09f9f6a384e..24aa1de27c25 100755
>>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>>> @@ -360,8 +360,8 @@ fi
>>>  CATEGORY="memfd_secret" run_test ./memfd_secret
>>>  fi
>>>  
>>> -# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
>>> -CATEGORY="ksm" run_test ./ksm_tests -H -s 100
>>> +# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 512
>>> +CATEGORY="ksm" run_test ./ksm_tests -H -s 512
>>
>>
>> Why the magic value 512? (desrves a comment)
>>
>> A clear sign that the ksm tests must be rewritten to be standalone and just
>> handle this internally. @Sarthak
> 
> Acked. I thought it's enough to spell out in commit message but
> I'll spell out into comment too in this round not refactorying by me
> for ksm test.
> 
>>
>>>  # KSM KSM_MERGE_TIME test with size of 100
>>>  CATEGORY="ksm" run_test ./ksm_tests -P -s 100
>>>  # KSM MADV_MERGEABLE test with 10 identical pages
>>
>> [...]
>>
>>> index 4821a3563036..f75bf0bacd18 100644
>>> --- a/tools/testing/selftests/mm/vm_util.c
>>> +++ b/tools/testing/selftests/mm/vm_util.c
>>> @@ -21,6 +21,8 @@
>>>  
>>>  unsigned int __page_size;
>>>  unsigned int __page_shift;
>>> +uint64_t __pmd_page_size;
>>> +uint64_t __pmd_page_shift;
>>>  
>>>  uint64_t pagemap_get_entry(int fd, char *start)
>>>  {
>>> @@ -161,6 +163,9 @@ uint64_t read_pmd_pagesize(void)
>>>  	char buf[20];
>>>  	ssize_t num_read;
>>>  
>>> +	if (__pmd_page_size)
>>> +		return __pmd_page_size;
>>> +
>>>  	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
>>>  	if (fd == -1)
>>>  		return 0;
>>> @@ -173,7 +178,25 @@ uint64_t read_pmd_pagesize(void)
>>>  	buf[num_read] = '\0';
>>>  	close(fd);
>>>  
>>> -	return strtoul(buf, NULL, 10);
>>> +	__pmd_page_size = strtoul(buf, NULL, 10);
>>> +
>>> +	return __pmd_page_size;
>>> +}
>>> +
>>> +uint64_t pmd_page_shift(void)
>>> +{
>>> +	if (__pmd_page_shift)
>>> +		return __pmd_page_shift;
>>> +
>>> +	if (!__pmd_page_size)
>>> +		__pmd_page_size = read_pmd_pagesize();
>>> +
>>> +	if (!__pmd_page_size)
>>> +		return 0;
>>> +
>>> +	__pmd_page_shift = (ffsl(__pmd_page_size) - 1);
>>> +
>>> +	return __pmd_page_shift;
>>>  }
>> The interface is a bit inconsistent.
>>
>> read_pmd_pagesize() vs. pmd_page_shift().
>>
>> Consider renaming read_pmd_pagesize() to pmd_pagesize() in a cleanup patch.
> 
> Okay.
> 
>> ... or (better?) adding a size_to_shift() helper instead?
>>
>> I think most places that want the shift also want the size.
>>
>> So this can just be
>>
>> const uint64_t hpage_size = read_pmd_pagesize();
>> const uint64_t hpage_shift = size_to_shift(hpage_size);
>>
>>
>> In size_to_shift(), you can just handle
>>
>> if (size == 0)
>> 	return 0;
> 
> Hmm, most of tests care mainly two sizes and shiftes --
> psize()/pshift() and pmd_pagesize() and pmd_pageshift().
> 
> Would it be better to keep both kinda of helpers and
> add size_to_shift() helper for nother hpage size then?

Works for me as well. As long as it's consistent.

Maybe even pmd_psize() and pmd_pshift() to match our custom psize() and pshift()?

-- 
Cheers,

David

