Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86213606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 10:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=t1XoflFL
Received: by kanga.kvack.org (Postfix)
	id 858F86B00EF; Wed, 11 Nov 2026 05:13:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 809066B05B0; Wed, 11 Nov 2026 05:13:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71EC56B05B1; Wed, 11 Nov 2026 05:13:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BAA26B00EF
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 05:13:58 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DE531C0E23
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:13:56 +0000 (UTC)
X-FDA: 85422427272.03.51BAC11
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4113420007
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:13:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t1XoflFL;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794392034;
	b=4cID3A/00eorFGDIJdu1v2BDWfYLvjCI4wTEcWdtZ+58o8Edv73q5KGXm86wZbJzrfg5i7
	fKQGLtHnG8TNAXZbM1E1GdtnkIMmDXq9rTA2iEE4F0n3RLlel58W3xk1TKa3+EvdmA1qPL
	4KKcRWJI3mL2nlQJESfOPJ6fg51hdTs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=t1XoflFL;
	spf=pass (imf03.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794392034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFsUrJ0dxOWP7r3frqNT5Bu7ce7smoD0qQQqG1/Rh6Q=;
	b=RlK/l4X49UqyknL1qmM82wO3DjfxaxgXAd/VywQKti2eDCIS3qW10UVjzKR0Us1iWOGWg9
	PnqaJRX8ITkFKgzswCjPbU5ZASg/g3/eoVRT/etbhFNjHxQFc3yhlJh9T84PbWzLtMwmak
	vPmQdFIVlSlBpUY+Ehc0d26f5Fee3GM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 19D6F1576;
	Wed, 11 Nov 2026 02:13:50 -0800 (PST)
Received: from [192.168.29.156] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DF9843F632;
	Wed, 11 Nov 2026 02:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794392033; bh=1UEncBFzc6ar7AzXQMp/oadOU3GZsGaET5zqzd1pFeE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t1XoflFL8fdXTGRA8TKAuiSWlNqE8dajStSZclPxJPQhhPfQ4rp6WJdfL3xNKT35o
	 5skjqINIMXPS133CRRqRgZMCqxpLzq/FXQw6Wwde839uQ4Yh5hRfQfyIvBwJeC2N5s
	 mQs95NZEbgNSiP6CcMm6Fqqa1W3LWZEDLdaXhaNk=
Message-ID: <f2df3351-ccc8-44c6-bcfc-d380264fb8fd@arm.com>
Date: Wed, 11 Nov 2026 15:43:44 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND v2 00/12] improve mremap_test
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20261102100211.141831-1-sarthak.sharma@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20261102100211.141831-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4113420007
X-Stat-Signature: ukniobiyqmem67tm3m9grhjs4gu6cxpq
X-Rspam-User: 
X-HE-Tag: 1794392034-150065
X-HE-Meta: U2FsdGVkX18e3cceXT9J3HpL4O+ZdGk11zJ2FMREVqWEHXbZs1j2s6zeiJPeRyh6a+bDvON4siaIOxl6o1O6ZRwDZXqgIk09WtmdHA6GapkQUoVVsFu+zhLN0+2Q/aciovpmf38zqKjGFb8zpQ3ZEzJ2Kt02GbTBN9e5e1GEiXpQViSfF80zJezUUCKmUfoJwuU2ruAJYRTzxOebxplqXq4iQ+WvM7MvckgDzFl5V0B8UjRHrvUUbdZfwPukdFc+96wIXvIS4PG5mFrtF0H9MBvC8o0KZFHkPqKAFp/7Tu/U0F44jRKb7NLbM/OTDbaaHyWb9QG4MzCe30r9jAR2R38hNZAnBoUwEhBynMqTd/mRlLXjjzfbR+muk4m2qKrTUtG1XU9E+CBSS/X0yK7cgdkdN2B0bBSfdVk1VAtStGecjJ+AUBGQiCPUK54vBHzQVy8BVF14/1nMRWRQXi88tDBW3GxMNCl0VJOtEGArWkmwzAEDT20c81zrEdYH9Jg8km38PgWfqJoxccRAK48gvCdsoyNgTK66wNVzFNjH1Dlshm9tHovl8O+nLk6Ntq6ryJjC/zSL1W5LCmX+EI4Pv9Lj5zkXDLKWOT1YIe7vbQKly7eeCteTWIyAQYSzLvImubfC8pC60mWd0qu0BJCyA2O/8fzOIfgXjahpeZZzgtw1aA/q818clBU31/iPpMjK8N8yf9mNxmbolHnLPh84sEKFSoGR7xTtnszDIrw1dd7FaL+5SmrwrWeEzcgUhnKp15knSOUFJJg1CLSCwO100QmAK+TpV28ZYXbESNILQKXThrRa5OXUjctmFBey8zcSILLIHCdHlEk46n5Ii5PM+epsk5hbiuB/YYClAmGKbjX+f5drFiAVXYrTMuK8qOknDcWLi6ANYCXnroGNufUVg3D0y73r9jKSSQA6Zgx5m4AtiMNhAi9sKbg8T3jXfsVQAvi/ErjqlvPMGZzgA25
 03HeqhM1
 cWmbFgjPHKqCVWhsPG/Ti2ffI8nMpEpKl8y0n8Xf66Gakeqer4OodFIJBaB5BJyUsvuSNkEzk6CdtcyUsI9tfPuS0X8szkJwh7LUhc1Td2brUwcsIKTiHfADlF0gnlz8hQtQ378krxbzrrLLr5eB6Lbf+LeUDiihb488Tv3Daimj62qcjUqnPmJgqF/By/ZE4O1get72X7chklBYPyQpRkOVZLPPs0m3I997/stvJ4vF1UrhCvxen5C9qSliuipmbSMKEV4W1aLzwWZzFyyqdDZx42GazkHQN/6BXKpt9Kg7d+BI1rkW5ImINFlI++T2mSGSmogyNYxCTqsF+oZBiu+1kW+TpKf7r0Fy0UQyA3g2v0fRftI7GY4rCDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/2/26 3:31 PM, Sarthak Sharma wrote:
> This series fixes correctness issues in mremap_test, simplifies its
> test infrastructure and strengthens validation of remapped mappings.
> 
> Patches 1-3 remove unused command line handling, unnecessary cleanup
> checks and redundant errno handling. Patch 4 converts the test to use
> kselftest helpers and removes manual failure tracking.
> 
> Patches 5-8 fix handling of unavailable userfaultfd support, unexpected
> mremap() successes, data-corruption failures and cleanup after mmap()
> failures. Patch 9 removes perf tests and timing infrastructure.
> 
> Patches 10 and 11 replace threshold-based random-data validation with
> sampled validation and a deterministic data pattern. Patch 12
> strengthens multi VMA validation by also checking the mapping state
> of holes after remapping.
> 
> This is a resend of v2 without any changes.

Hi,

It has been some time since I've posted this series (v1 posted around 2 
months back :)) but it hasn't been reviewed enough. Requesting for some 
review on this series, if someone has some time to look at it.

> 
> Changes in v2:
> - Add a first patch to remove command-line options (David)
> - Add a second patch to remove munmap() checks from cleanup paths (David)
> - Add a third patch to simplify errno handling
> - Drop the "correct multiple VMA range size" patch
> - Add an eighth patch to fix cleanup after target mmap() failures
> - Replace fully populating and validating large mappings with
>    populating and validating 10 pages each from the start, middle
>    and end (David)
> - Extend multi VMA strengthening to userfaultfd multi VMA test
> - Fix minor formatting issues
> 
> Previous versions:
> v2: https://lore.kernel.org/all/20261006092511.145776-1-sarthak.sharma@arm.com/
> v1: https://lore.kernel.org/all/20260924050009.19974-1-sarthak.sharma@arm.com/
> 
> ---
> Sarthak Sharma (12):
>    selftests/mm: mremap_test: remove command line options
>    selftests/mm: mremap_test: drop munmap() checks from cleanup paths
>    selftests/mm: mremap_test: simplify errno handling
>    selftests/mm: mremap_test: use kselftest helpers
>    selftests/mm: mremap_test: skip test when userfaultfd is unavailable
>    selftests/mm: mremap_test: fail unexpected mremap successes
>    selftests/mm: mremap_test: fail on data corruption
>    selftests/mm: mremap_test: handle cleanup after mmap failures
>    selftests/mm: mremap_test: remove perf tests and timing
>    selftests/mm: mremap_test: replace validation threshold with sampled
>      checks
>    selftests/mm: mremap_test: replace random data with deterministic
>      pattern
>    selftests/mm: mremap_test: strengthen multi VMA validation
> 
>   tools/testing/selftests/mm/mremap_test.c | 701 ++++++++++-------------
>   1 file changed, 291 insertions(+), 410 deletions(-)
> 


