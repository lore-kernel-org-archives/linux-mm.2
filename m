Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C96A3C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 04:21:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A99326B0095; Tue,  8 Sep 2026 00:21:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4A7B6B0096; Tue,  8 Sep 2026 00:21:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938586B0098; Tue,  8 Sep 2026 00:21:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6996E6B0095
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 00:21:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF311A03A9
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:21:25 +0000 (UTC)
X-FDA: 85189295730.13.0121933
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf09.hostedemail.com (Postfix) with ESMTP id DB89E140003
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 04:21:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RqqsGDNb;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788841284;
	b=hj3CKWyHm0nqGq3NQOBual427Xi/68ky8o+l5IooVEdkQyDJ9ZJ6yGetAwgZq1uK1U6+L8
	/yU5ZaSgCTrt4mVfquODSDIaSX3lVB0MVwHfinwjPLHSE7fgqLlGR/78+VNNY8nY1fmYwk
	3r5wSA40jJ8SLqZsOtah1vyIeVDDHk0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=RqqsGDNb;
	spf=pass (imf09.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788841284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5l2GsWMCXIa1zqfwvNfoBsJB+Pcrj54mJBjCGSkGnMs=;
	b=o6ZULJOAHeczh1rFqKPZC3HrWAZOuqawpyfm+1heiFk2e3dfHsC0SNrvFXqAYc5t6pl1JV
	P9tNTJ80K1bnvSCI8oUP91xWiQEEO9a0Rj3rjQBX8aTYlaRNWu0E+CGhTkkB4/972XZ4kI
	pm8hk/+lQM8sCzURkR3u8A4ocMr/xyM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E71921476;
	Mon,  7 Sep 2026 21:21:18 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 520A93F528;
	Mon,  7 Sep 2026 21:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788841282; bh=K0Wlf9u1v8EnKIQ5AhyaZte4Iwg0VOgbEUCSHSr2OBY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RqqsGDNbNtoGF8UaRD/lb3640ii0GOwPaqfaV9OUSkpZ8Pv7s0Ig+sx0ZF2WElmJL
	 QGEE2st8jPLsPDEvCKixIHnvUwWRf3ky8NfQXwxbdzy1Pxg7G7hl8TrxYDz6qOTfHf
	 UCxTossPmCnXFlVPRAx55tMMlqTM3W75gCtjdI+c=
Message-ID: <943faa15-06b8-49ce-8b91-e4c1e2f22fa2@arm.com>
Date: Tue, 8 Sep 2026 09:51:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] kselftest: mm: remove HPAGE_SIZE and HPAGE_SHIFT macro
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 shuah@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev, kas@kernel.org
References: <20260907081509.924979-1-yeoreum.yun@arm.com>
 <9f8c6e91-c1c8-4ec5-96a9-9d6d4ab571cc@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <9f8c6e91-c1c8-4ec5-96a9-9d6d4ab571cc@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DB89E140003
X-Stat-Signature: p8tdgh6kaf15ugbidp8f5wxbha1xqubz
X-HE-Tag: 1788841283-93083
X-HE-Meta: U2FsdGVkX18/8K33bY+QxXztR9AcUdQA+Duy83oLU9J7zOxUVLEXw8zwEtEGvkoqAVECNEUu6KVO0iO5h7hMjFXbe3BlOtpyA28k3p6rJkiginBXhWr3n1yD2wz3ZWyzZiylUObf/smDALchQ8h7QJO8WFJI6/nixyWUtTG/gKMd3LTVQSW+voDSkw3XL5Atgsq6CY7w3TCBCBnb1Rk6RB8hpp1MNabygpgf61uRG1BuqB4KiyI3JSbH472LG0ucApr9y0M0HWV5KMvlahk8qgbw1iiUirshTKKegyz/RnHz1HTSk2VzuR3xgn0rngdR+hRqDr9md+ICFk+jiZXpji4/EZhLwMlEhssB4ue92kqk5srGYNlvfG24k1Jfc3xIFLOKaIfHvARDq3ZT1OhyAj+bCP3qk/MWLZPAd8GWroRecErbfqDWKacQVA7o9sGuGipNaAhhScxwszE4nKO0n8J1IqQRpJySCi4gwWiTi751KfJOafczGUcisIa41AXFmv/yrVSUYps7c+0QKgXA0PEeD5C/eEFMsMnGuGGjQQWDqrgae9svfl3b7en+bnd2tqJBiD2xl8sVqSA3+TupLHV98mhJwvRpT+rNMAHEkHffm8PXraTSxBLoumWT0DyermUBs0QVcHoGnhi5BIIONmmAx8PCE34h6BZSaXv8afI8aLxv6TBIzi4gVQuyRfF8PrKClh5MAE8k7m4STCDF5iQS1PcZVMyDFnumZsa821nZPqCyrS1g9ntks22lTovQw6DbhnOX2QdzNj28gfbi+y96Mbs/rBosDcm5vZeWcKghqXgVQCi2yUovTDw/8yNeRxAQAYz1Wt2MJns7+ggPZqLJ2CqizbPE5/yhFZh7+vQQz6jLvDXMEs1PA1knT/oLzP1NxYoVq1HEx4Bek/qaBAfSBEB2dDHxgGgmC656sdnr10yOkYQazMXzOAPLcZALSB5v3uDxYUp0F4NHtJw
 40txxThC
 RqjuEbVsIsc2lGZRWOGCrQyEq5LoB0NiEho3xt5zE9DSuAdegWIc6RQC6agVw/33lLEO0wDdFeRZorwzWBhLiwezQAi1nyJ+/FYjdsv3hYAkyXFeCikQDL67p54LnFIVc5p85wU5QzLhI4i15VJPUgxAfBZlV4PDG6YbMP2xJGI5Fxnj1exQF+jDEBLNt06sUNQVDqhcLqs4LlPsVE6lyBQw1+NCM7rQQAzqnEYphkX0tS6vTWAckRpMsjIQM+dUWZFRjnmvXrs1eIx4K4YD+laTCbs1NG22vPr+zIj05HcMLTUPxaKH0q+/T1D+3UuN4FeUtlhY/M1Q6P9r0o2V6xvC5ZqEC56Kxb9k2Xw/6hVKu/awytpkA4ygDmg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/7/26 8:06 PM, David Hildenbrand (Arm) wrote:
> On 9/7/26 10:15, Yeoreum Yun wrote:
>> HPAGE_SIZE and HPAGE_SHIFT macro is written based on the 4KB PAGE_SIZE.
>> When this macro is used in some test, test result would be strange in
>> the system where PAGE_SIZE is more then 4KB.
>>
>> Here is the example with transhuge-stress test with 16KB PAGE_SIZE:
>>
>>   transhuge-stress: allocate 61073 transhuge pages, using 122146 MiB virtual memory and 1908 MiB of ram
>>     3.292 s/loop, 0.054 ms/page,  37106.002 MiB/s	2566 succeed, 58507 failed, 2566 different pages
>>     0.591 s/loop, 0.010 ms/page, 206850.792 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>     0.527 s/loop, 0.009 ms/page, 231895.107 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>     0.527 s/loop, 0.009 ms/page, 231839.704 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>     0.528 s/loop, 0.009 ms/page, 231544.782 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>     0.528 s/loop, 0.009 ms/page, 231462.074 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>     0.527 s/loop, 0.009 ms/page, 231770.300 MiB/s	   0 succeed, 61073 failed,    0 different pages
>>     ...
>>   ok 1 Completed
>>
>> Remove the HPAGE_SIZE and HPAGE_SHIFT macros and introduce pmd_page_shift()
>> helper to get the HPAGE_SHIFT properly. For HPAGE_SIZE, use pre-existing
>> helper, read_pmd_pagesize().
>>
>> Also, run the KSM_MERGE_TIME_HUGE_PAGES test with a size of 512 MiB,
>> which is the least common multiple of the PMD sizes for 4 KiB, 16 KiB,
>> and 64 KiB base pages. Since allocate_transhuge() allocates mappings in
>> PMD-sized units, the test may fail with the previous size of 100 MiB,
>> which is not a multiple of the PMD size when the base page size is
>> 16 KiB or 64 KiB.
>>
>> After this patch, output of transhuge-stress:
>>
>>   transhuge-stress: allocate 3817 transhuge pages, using 122146 MiB virtual memory and 119 MiB of ram
>>     2.558 s/loop, 0.670 ms/page,  47755.759 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>>     2.640 s/loop, 0.692 ms/page,  46268.432 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>>     2.635 s/loop, 0.690 ms/page,  46360.298 MiB/s	2585 succeed, 1232 failed, 2585 different pages
>>     2.782 s/loop, 0.729 ms/page,  43899.795 MiB/s	2616 succeed, 1201 failed, 2616 different pages
>>     2.692 s/loop, 0.705 ms/page,  45380.876 MiB/s	2627 succeed, 1190 failed, 2627 different pages
>>     2.612 s/loop, 0.684 ms/page,  46765.812 MiB/s	2628 succeed, 1189 failed, 2628 different pages
>>     2.683 s/loop, 0.703 ms/page,  45520.990 MiB/s	2630 succeed, 1187 failed, 2630 different pages
>>     2.727 s/loop, 0.714 ms/page,  44789.321 MiB/s	2631 succeed, 1186 failed, 2631 different pages
>>     ...
>>   ok 1 Completed
>>
>> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
>> ---
> 
> 
> [...]
> 
>> diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
>> index d09f9f6a384e..24aa1de27c25 100755
>> --- a/tools/testing/selftests/mm/run_vmtests.sh
>> +++ b/tools/testing/selftests/mm/run_vmtests.sh
>> @@ -360,8 +360,8 @@ fi
>>  CATEGORY="memfd_secret" run_test ./memfd_secret
>>  fi
>>  
>> -# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 100
>> -CATEGORY="ksm" run_test ./ksm_tests -H -s 100
>> +# KSM KSM_MERGE_TIME_HUGE_PAGES test with size of 512
>> +CATEGORY="ksm" run_test ./ksm_tests -H -s 512
> 
> 
> Why the magic value 512? (desrves a comment)
> 
> A clear sign that the ksm tests must be rewritten to be standalone and just
> handle this internally. @Sarthak

Sure David, I'll work on this.


