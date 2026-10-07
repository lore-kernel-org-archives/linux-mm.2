Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A509CA5FF1
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 12:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6195B6B0093; Wed,  7 Oct 2026 08:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F0A06B0095; Wed,  7 Oct 2026 08:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52D656B0096; Wed,  7 Oct 2026 08:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 332B86B0093
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 08:01:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 32AF01C1D51
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 12:01:50 +0000 (UTC)
X-FDA: 85295691180.24.D09575B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id DAD001C000E
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 12:01:47 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cgwT5fiD;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791374508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+/eMcHZiWBFGYqh11cuMdRzIQULNeUBVuf13Ekv44Lc=;
	b=YzhLN1ZMTmAToLlKnH2EUxD0hqujczyrnNyAd5mYLRQ6Cz6HPByrep/rT4Ntd3NCA+ztls
	ooG99qPP2HtcTlAGA/aA0QNeWFLbHjDuVbxCfSUoZBA/2qaPumGYzwKazxR2tZqkmYMn+2
	4qfA7o4EkuIH1NqfVaCmRNKzxFk+MJw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=cgwT5fiD;
	spf=pass (imf18.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791374508;
	b=tDq4wXlXAEOE2ShwhJ3nBBxRijWt2NA5DsOjWuxbDRnPxKmk9wqA9796psdVlZbJeitR85
	5HO3rVbGaqF6eLvaNAJbXi+U3A/ICT7fQc1eFFuegDmpsh1FTY2YfADKPHwYIV95ceN89+
	i3IKkfo4/U6dUPMAW+IhQHHYek/jGEw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 14B101595;
	Wed,  7 Oct 2026 05:01:43 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 952693F66F;
	Wed,  7 Oct 2026 05:01:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791374506; bh=fVxFt1CGQ1LaSt6H7lvlcV39UU1RhYn2V+45OkcADVE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cgwT5fiDtyBCDxHzWCj4UX9zGaiMM1gi91eR1mllNLBjhmR2s/oVWsdfy7y6PGhlm
	 +WIqKf29N21gX6bsO7zAVDkHvXIK5eV1oNBTmQym+jNyEegbUsJGLcQQmWpMxbeVVX
	 3lWMblvRXoIBqaMUpp2zJYC0D7Zdi+FNWMgon3pU=
Message-ID: <ce49e816-ae77-4c64-bd28-168d8ca52d8d@arm.com>
Date: Wed, 7 Oct 2026 17:31:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: hugetlb_madv_vs_map: fix TAP plan
 mismatches
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Guillaume Morin <guillaume@morinfr.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <shuah@kernel.org>, Breno Leitao <leitao@debian.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261007092801.35649-1-jaeyeon.lee.dev@gmail.com>
 <022ec915-62ab-40d9-8705-90692e75acfb@kernel.org>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <022ec915-62ab-40d9-8705-90692e75acfb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DAD001C000E
X-Stat-Signature: k5jazsqcwjhad79gja89hray6oxoexob
X-HE-Tag: 1791374507-432902
X-HE-Meta: U2FsdGVkX1/zi4B9eqizFTBATYZGAYANRw98ABm6Zk2GCTkkhBz4/WQuuHuvKrS+PGzO0+I4sH/q6CbK7hw0mJIxFg+PIjH4sOMZX7Sxz6521eozNNxvdbNHn14CnQTMxwVe5ihz98vpWSgmXooJYkxUsxPSVz4kUzkKJeaaugngPTkS9lvfI94YbSpUF/rJkNGlLch7AVwZe4qIc9uhreKs+PlAQSuBQzSfaYfhekgAWWmpGi+BJI2FCQl1AayGOuRGxdG46pyPaS8yJBhqJqPb+0Wq3tAcVG5DF+xqZYgrJtPAwp0sO8GStXqemahXfZlTjlP7Ftkreq3kgo1KVsvJawjw44NjPLb8t0B/OpEWh4AkaWhrEAXDpg7u9Gas0jntrLLJhwGSs9tO6IVhLfuvCFK1p2Gcn9uxAYSBfWyPDG8QGp01b9ztpnwoAAfUHfKl0CldXIheaAWs/RaoNm6MOxoNvVReAfwI2kn6S+4koTLtdg2m9zhMphBWUq6lsnI7hBa1JidgwiKm3OTsq8GyUChyXBPsLDPV4dCaAtxEv3FOE3tfUHk8L1vHezByDWsvj6P3o7EAiLG6unGqZ21HzNtg1L1/9dMtsUTh8klPXjcKHNRJRlTZyx9y5on3Kt2J9wOLt3psWYHVS3E/2wmfiiUNaXMJjWdg8pQXO/AF1TeTuudtolQfAZlN4qx20ZPvzOWPnK2q8cc0yLreR4SYED8v3dCk5T6vphMP25cFEQ8gdRkwq/+RMKKJTpDZEVXzKrMKkxfkEUO+2iHJm0qllAvy9QbSliWzJrWUm0b3rl6vWHdnYk/NADeZuWg8eLCX8O876dPrY39n52jEQwGrSSENUrAjHhQhYG+J5k2noMKdcfiJFY+Vcy0qJ7KMrEoqN8uiqLTb91cQImdEyQkXf/CyzQp2ZE55O2IjirQDJIokiQ0efdrpzezuqGNa4GCvgxubPpy8vCSgajY
 48HRgSNW
 c/VRShYwaxVK9N76nT62KNbwkpDWoQeUgwNRN5yIxqVIn3urTmVCJY8XKylVkgWH3nwV90+r7nq4ly60rbvcbfkr3mWJpRYjBfg55WzIWwDjFgs6E9fvo2CajEUOfNgf1WbtgY9ZIbmIIsDz6LAUpIFf2YQMsejeG8Y2VCDm4dvoKVq7Cd35VDfYIINU1dUaVHjXL92srioA9ZkTvTuL/JIZFU4QES6W96pwnzp5c2aLH+ih+JjmXjnlAN+ybARL+J+6vWMIAbALfEaQzkfFw8B+q/0d5yOLrcPn+rK4eiEIr6gvxZr80auLucyXmlsXkq6SkPgaPxVs6FajaEKcx0D5KdU1EQtJTV1086pj2/Z4IhcedB1/MC01LuVMrpFVE4W8n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/7/26 3:46 PM, David Hildenbrand (Arm) wrote:
> On 10/7/26 11:28, Jaeyeon Lee wrote:
>> The plan was raised from 1 to 3, but the HugeTLB setup check that may
>> call ksft_exit_skip() still runs after ksft_set_plan(), so a setup
>> failure reports one result against a plan of 3. Move ksft_set_plan()
>> below the setup check.
>>
>> Also, when the underflow check fails, or munmap() fails,
>> test_underflow() jumps to err_cleanup and exits without reporting the
>> remaining results. Report the munmap() failure as a test result and
>> skip the final HugePages_Rsvd check in err_cleanup, so these failure
>> paths report all 3 planned results.
>>
>> Fixes: 827149aad495 ("selftests/mm: hugetlb_madv_vs_map: add underflow test")
>> Assisted-by: LLM
>> Signed-off-by: Jaeyeon Lee <jaeyeon.lee.dev@gmail.com>
>> ---
>> Changes in v2:
>> - Drop the duplicate ksft_perror() and report errno in
>>   ksft_test_result_fail() (Sarthak Sharma).
>>
>>  tools/testing/selftests/mm/hugetlb_madv_vs_map.c | 6 ++++--
>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>
>> diff --git a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
>> index 1d111f42dd59..0f6afb834dbf 100644
>> --- a/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
>> +++ b/tools/testing/selftests/mm/hugetlb_madv_vs_map.c
>> @@ -168,7 +168,7 @@ void test_underflow(void)
>>  
>>  	/* First unmap, this will close the vma */
>>  	if (munmap(huge_ptr, mmap_size) != 0) {
>> -		ksft_perror("munmap failed");
>> +		ksft_test_result_fail("munmap failed: %s (%d)\n", strerror(errno), errno);
>>  		goto err_cleanup;
>>  	}
>>  
>> @@ -203,18 +203,20 @@ void test_underflow(void)
>>  	if (waitpid(pid, NULL, 0) <= 0)
>>  		ksft_exit_fail_perror("waitpid failed");
>>  
>> +	ksft_test_result_skip("HugePages_Rsvd check after child exit\n");
>>  	ksft_exit_fail();
> 
> That looks odd. SKIP + fail on the same path?

Seemed odd to me too when I read it. But it seems like one function
contains 2 tests:

i) Check resv_hugepages when parent unmaps the VMA and child is holding
the hugetlb page

ii) Check resv_hugepages when child exits

So we're skipping the third test if the munmap fails or the second test
fails. Skipping incase of munmap failure makes sense but I'm not sure
about the case when the second test fails, ig this could still run in
that case.

Anyways, the original code also calls a ksft_exit_fail() in err_cleanup,
so this skip is just preserving the TAP test count, else we'll get that
planned tests != run tests message.

