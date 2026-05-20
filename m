Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F37F6CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 09:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B4526B0005; Wed, 20 May 2026 05:02:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0651B6B0088; Wed, 20 May 2026 05:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95E86B008A; Wed, 20 May 2026 05:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D84266B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:02:39 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7559A1201FF
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:02:39 +0000 (UTC)
X-FDA: 84787207638.22.C4F40D5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 87B681C0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 09:02:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fcqBMRSm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779267757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o8M5VyJJ+zcCCMCw8jz6DL9aYESUEDxy9CDmrHR6D4Y=;
	b=oOhjyd6cNm6L13krD9QuWUnH2gIT4ub25GiW89w1VCixPmNTvQJbZiqpRkpYWzGmDSzbQY
	rLJfoB5ewOWiLtYYHb/g2MSgq4irDGnPvPwZ2g0c9TUZiD6cq3DR4pHod3T86YXcHO278d
	OHr4sGQLJY8x04QsqYmhABkZuG6emlw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779267757; a=rsa-sha256;
	cv=none;
	b=x/w1bSqTzs6+Bn94FKgbGTwxSSsCK+Ng99c7gBZ0dN7ZvNoC+DO4rcN17Ba3ATW1oM6cC4
	m00Eu9POx7xsLstAbuJf2KNYaVi21z2zfQgHtSuf/rFFZIknjO2EgEaSB0A4KxMm3L6Ryw
	3t/J3n+LA0jYKObTVaTe1ou4zGeflGo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=fcqBMRSm;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf18.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02228488F;
	Wed, 20 May 2026 02:02:31 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DDA843F85F;
	Wed, 20 May 2026 02:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779267756; bh=Zx6Y0CSKfWg4W6fzoAK4sppujlOP/zqJnUnthLFeOBo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fcqBMRSm1Bs2PU9kCu9oZdM8JOImdHhC3IGKxecMdKBW+50CJ9bYpCpvuakaBI9tV
	 mF0HwUrzD5iSrX2OoZFkTKWuGU7RXRVDJzbSWGl/+r8iiLgTSNz5B94p7hVEfSYCV3
	 oVDfBkElQp3jhAbbumHqf9ptpsd34QAsU/J9PPaE=
Message-ID: <8eb07028-d6b2-411c-81ea-e009c8b3a4c8@arm.com>
Date: Wed, 20 May 2026 14:32:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] tools/mm: add a standalone GUP microbenchmark
To: Mike Rapoport <rppt@kernel.org>, Sarthak Sharma <sarthak.sharma@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Mark Brown <broonie@kernel.org>
References: <20260519120506.184512-1-sarthak.sharma@arm.com>
 <20260519120506.184512-2-sarthak.sharma@arm.com>
 <ag13GbKcLMIoHOHj@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <ag13GbKcLMIoHOHj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 87B681C0009
X-Stat-Signature: 34ziqehiey5cwbshe97p8fk8pkc68isz
X-Rspam-User: 
X-HE-Tag: 1779267757-358378
X-HE-Meta: U2FsdGVkX1+FtU8T23h4i33WLsRD4PPbKrGDepY4M4NzqgnLcBBJOfNoH52bp833LskShdPQ9oe5o8/oWAIra0O5j4YhDsmHJrRf9e6FrrB3uW6bBJT4bLZKUt4FUEhODNpPmGNOVbOiPM+gzMfCwDVPfvrZUphTXpklk2xqakUfECFkIDIwqsRLKS0wcnkHDFXGfrqMCwrikYKr75/saPVyCzdgA3xQD1rFimqyL/5osZrMr7Tl8d+rK9Gon99Fob4apjnI/0bwVIYeMRqaTPqxHtX2fIg6fuTXsg+YgEGiQXcB2tu3PF0CesN2d0YOWq8qKYXJPEpuBEO42R06lyXuSQFpOi2tBRNlt9/4l2qxEIyx6dvC69lJQlLdQhJi3eX5oO53KY0aAi2ohJFNsre35p8qSsTyelJt3bI/sNBSScm3PYlmxMwOfjflVcclK1RbR+hU60BfobndiayFqATy5628ls3TmUnSJTbP3Oo9vJOMHO2P72kBH8GJzdk4Uygv3v5Pi70scGGHlzWIRbJBWKKw+qhuimSfr8f/lgFLMzfO0Esv4/8eW+VfDvzrUG1DESqY3VMbghlfbCcDFfBCu9lbw62/Ddls6fGO4sOvZHAegSGHNB4Qa7Twj8xpE14BrTOsS4rgVWRGtKtvfATPiAdsdPZbRW0R5RK9T/JMWOKQuOSRjHwaKZnPhbJ+Z9CAn49CA4K28pes0soSp63Z/GyIw1y62pJ/Bs3Ep9v5TAWpDDSk2jQ0ig96o6IufchpoutfJ8//nXTFr4pgBbURxZY3boPJ5d1PAtdm8l486lcanOlRdws3wOBkdNgM57TWlaL47WBHM6dAGapTTXdaQE9PIaJMW+jenwXY9F+U0DnTguwgRwbBAhjuLLzAybh1r5t2ZCBTIr2vRe6ep9y7Iz1nSAUgI03gg6v7tShM8mS/tZyIWfkb7qTW/Z2IojA34OwA9xZmYqIsaYe
 L61WAkqr
 AIQv8vgWJg7ojvFDEvWoCa2ExXce5JDTzOT0AFI9dUMbRoR9MXkEZYo74TJehcxLi+zZuugOpq1Eubj7kvuRQcRm0ymk9FECrRwXlguEain8Ma2ysjrT30B6dKCzeauSAAON2snbqsJjRS9Aut8u3PliFFq5hmVQUPV2yv1qLUoMSOwaplIQ6VW4yNn7WA9D4GO8AFXynXvOr5wNabko92H4tL0D5uHEkp4h2rOYIUiXrH5Bxr2ll0H9NQJ+xYBZ3xt9BE5iihh4d7O9qHsic0U57EdFtdsF276QBw1FN2MRDutFru0H3z+dPNNjgZbjfIP4z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20/05/26 2:25 pm, Mike Rapoport wrote:
> (added broonie)
> 
> Hi,
> 
> On Tue, May 19, 2026 at 05:35:05PM +0530, Sarthak Sharma wrote:
>> Add a command-line tool for benchmarking get_user_pages fast-path
>> (GUP_FAST), pin_user_pages fast-path (PIN_FAST), and pin_user_pages
>> longterm (PIN_LONGTERM) via the CONFIG_GUP_TEST debugfs interface.
>>
>> When invoked without arguments, gup_bench runs the same matrix of
>> configurations as run_gup_matrix() in run_vmtests.sh: all three GUP
>> commands across read/write, private/shared mappings, and a range of
>> page counts, with THP on/off for regular mappings and hugetlb for huge
>> page mappings.
>>
>> This tool is a mix of reused and new logic. The mapping/setup path comes
>> from selftests/mm/gup_test.c, while the default benchmark matrix matches
>> run_gup_matrix() in run_vmtests.sh. The standalone CLI and tools/mm
>> integration are added here so tools/mm does not depend on kselftest.
>>
>> Add gup_bench to BUILD_TARGETS and INSTALL_TARGETS in tools/mm/Makefile,
>> and ignore the resulting binary in tools/mm/.gitignore. While here, also
>> add the missing thp_swap_allocator_test entry to .gitignore.
>>
>> Add tools/mm/gup_bench.c to the GUP entry in MAINTAINERS.
>>
>> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
>> ---
>>  MAINTAINERS          |   1 +
>>  tools/mm/.gitignore  |   2 +
>>  tools/mm/Makefile    |   6 +-
>>  tools/mm/gup_bench.c | 491 +++++++++++++++++++++++++++++++++++++++++++
>>  4 files changed, 497 insertions(+), 3 deletions(-)
>>  create mode 100644 tools/mm/gup_bench.c
> 
> ...
>  
>> +/*
>> + * Local HugeTLB setup helpers for gup_bench.
>> + *
>> + * These helpers were copied from tools/testing/selftests/mm/ and adjusted to
>> + * remove the ksft formatting. Keep this copy local so tools/mm does not
>> + * depend on ksft output behavior.
>> + */
> 
> It looks like self tests of at least 5 subsystems beside mm use hugetlb:
> 
> $ git grep -l "Hugepagesize:" tools/testing/selftests/ | grep -v "selftests/mm"
> tools/testing/selftests/arm64/mte/check_hugetlb_options.c
> tools/testing/selftests/cgroup/test_hugetlb_memcg.c
> tools/testing/selftests/kvm/lib/test_util.c
> tools/testing/selftests/memfd/common.c
> tools/testing/selftests/net/tcp_mmap.c
> 
> It seems that we need to better share the common code in
> tools/testing/selftest.
> 
> And adding another copy of the hugetlb detection and setup code does not
> seem like a great idea.


Does it sound too insane to just do some sort of #include "../testing/selftests/mm/..."
to use the common helpers?

> 
>> +
>> +static unsigned int psize(void)
>> +{
>> +	static unsigned int __page_size;
>> +
>> +	if (!__page_size)
>> +		__page_size = sysconf(_SC_PAGESIZE);
>> +	return __page_size;
>> +}
>> +
>> +static unsigned long default_huge_page_size(void)
>> +{
>> +	FILE *f = fopen("/proc/meminfo", "r");
>> +	unsigned long hpage_size = 0;
>> +	char buf[256];
>> +
>> +	if (!f)
>> +		return 0;
>> +	while (fgets(buf, sizeof(buf), f)) {
>> +		if (sscanf(buf, "Hugepagesize:       %lu kB", &hpage_size) == 1)
>> +			break;
>> +	}
>> +	fclose(f);
>> +	hpage_size <<= 10;
>> +	return hpage_size;
>> +}
> 


