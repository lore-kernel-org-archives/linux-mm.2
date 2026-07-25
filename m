Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAEE2C531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 09:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76FE26B007B; Sat, 25 Jul 2026 05:25:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7208C6B0088; Sat, 25 Jul 2026 05:25:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60FF46B008A; Sat, 25 Jul 2026 05:25:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 35BA06B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 05:25:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 92A13402B7
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 09:25:36 +0000 (UTC)
X-FDA: 85026766272.20.6F6AE2B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6F4251A0002
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 09:25:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S5W6HYsY;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784971535;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bY7ACQNZOPnfvVv0HTnGyZ64tUmCFjOuea01jwpNmYI=;
	b=FSIHKlKTbsQtWSLfv0eOKNIyt19kJ339KqK27NYB4WYqv82+GBdwLtu1wqIUAeOZVPWdB2
	/uUo938pyl/3FWAmsYWoD8rkvbLYG0WdKtMO573sECWNrJejYyiXAENocv+GGgPD76fQJ3
	l4LUhAB+VJqTI+JVydgFYOO+KonuY5Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784971535;
	b=46JWnjfb2GxqOiCidZ4JJPyFN9zZTh90rksg6+VmVxs/tem9DyDN5D1mRWydUwqLrcqsbp
	6JPpr+EkeA+JZ130wpjCYLE0KgFPqN2hgvArmAVUWvLA5/ZYxkl3otUAVA5Yz3S5AoaQtW
	pbOWmyTUie/iBCsR67VYQ1UpXt/ggcI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=S5W6HYsY;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 72EBB1476;
	Sat, 25 Jul 2026 02:25:28 -0700 (PDT)
Received: from [10.164.11.99] (unknown [10.164.11.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D0703F86F;
	Sat, 25 Jul 2026 02:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784971532; bh=JI2q/jrov0bUlRrc1A9ykQM6Jx3rFwik0ZalTA/bQbY=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=S5W6HYsYef4wFmguN05enQML7D1YvuffSKrYSEGK/A7OM/kkOZopZyrsXPGhaV+7j
	 FBUIcOARCXfM6tvDX8VKtqn2kLOdS6gjYqHFskrAweR96JQG6+7NypyOssCqy4vPGa
	 OX494Kw7oemwgONK3QcFhubF+sK7FMsLG8PVojMk=
Message-ID: <58b824e7-dafa-4a8b-a8ca-d38151c97df6@arm.com>
Date: Sat, 25 Jul 2026 14:55:23 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 5/5] selftests/mm: retry migration failures for the
 full runtime
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 sarthak.sharma@arm.com
References: <20260724102431.1199519-1-usama.anjum@arm.com>
 <20260724102431.1199519-6-usama.anjum@arm.com>
 <15111e85-4143-476a-830e-9f7d47cc236e@arm.com>
 <a3ed6793-8285-4043-a0bb-10bd3890be19@arm.com>
 <6e2236ab-2cfd-4e61-98cc-4e4de9f76bd9@arm.com>
 <1c5b5101-1bf5-436e-a0dd-10b6cf81ff59@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <1c5b5101-1bf5-436e-a0dd-10b6cf81ff59@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6F4251A0002
X-Stat-Signature: wfig5iazn6355538quissrz98jpe8bch
X-Rspam-User: 
X-HE-Tag: 1784971534-986279
X-HE-Meta: U2FsdGVkX19rdEPZG5QmTI3U6MowuByVaYLoLzSnA/gBjCN4KAdZQqsrUQwlCu+ZNIzV5luX1ProaROy1InreOB+MiLXk4rXrV9oP60jjJfr/Hm+z+7MWq05xSu3AuzdMTxAxuqzAqDj9LXSWU3B88sKSy9PBv9C0T8/+eDN/jsEp6ZeuvTf9suY3LGPEAjIK3amZW+LVQL8qP7VymaNssRVjH00iWnFhs80KTConK1VzcH4vBlxp5l+9eeE/uSynMku4gv3VPqTQXYE4Zt4OC/4NG8QUN+cA1hkmCKjE8Wz2V76Q4ouHcQdB48O0aNR68CXbiQMaKStnPYdlo18n0UDALYCZqLBeGBX3hEkhv75FsFrlXjmVz2VbxZPI+pxP362WRzezjX2MTIBKwMgKUNSwteMzvrImUsRHc6/Td48tcHYI3fO58Dq3dUtO7qhErzDk7j5OtGFiTPkqmREAzBdPOs1KMVYhwCM+87VQXvTN48aw+RUxm8ye//Glk6BVZVGubQGjWeEXN8Auigl08PTzDkv7EgJ29/0PFeccHxm8fWf8231hWWTR0vZyXFj8k3ZgqAQtnpCbaHCLsjmy1AEfGtKlIf6mS3V1fDoi/ial5+cXVnYp4P5IofBN0F5taaJnsZGZEL0FryDWrdEyOHwHnIy34mGYauYVWDKJfLbj8LOUiWixzXwscU5DL114+z7SwILxVRWOjzr/NIuRYGNzDFOtzV8ZfUDYbxie0qq7JWXLbuM1gqYvt0RvrJfwEqV5QlrrSxt8PN1mpJBs1Nj95JnvM/UULAMwVo7wXe2fZLjtVdZYeaF8pq+DtX0s50qsyE1F2jN1WMXviKsBIzb2Ckd2HiG0DBaCqpbW46Lyd+ODjumCp7C6QSWqEoJz1F+/mu47PJZ77Et3IHlBGZRKLsEQ6fHXBX16KhFaj+wGgnrPtMZt7XWnkIw9AteevfhuRaEFGVf40aa3K1
 lp2yOP8c
 vHiThimmjJ54NTeFwmAHAYHY7SGUWznW4UxpB3GRtH0IBpjKkwaG/k6sjZPGNx5rJ+jRA2V6nLnyNHA4K2z3D+9XHTlYTdOajAFGQ4lblUVICKiBuLqFm5wXsgljBWTelOrqFKtFdBhSkimlTFHyLByKxZzKI4lS4N6dFqEE2miNs7FKAUp50WmXHN4qCStUf0oNuQfr5OHD4iQRt0gsgoiEcmV3gfMJr9zBKLGGFgg7Ni1hdRuXItBGrZlQXEZ128VJflysoMzbWh+YXeFW8uInr3Dumfw7qOeBvzYLyJV0UAljHIs6vnA9PPJJGboDwP4Yrf3P1oQlMUS6yZitP9kN/4GLPX63rWwDtqpFRlx1CsLzYdSci72MCaw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/26 9:27 pm, Muhammad Usama Anjum wrote:
> On 24/07/2026 4:23 pm, Dev Jain wrote:
>>
>>
>> On 24/07/26 5:23 pm, Muhammad Usama Anjum wrote:
>>> On 24/07/2026 12:46 pm, Dev Jain wrote:
>>>>
>>>>
>>>> On 24/07/26 3:54 pm, Muhammad Usama Anjum wrote:
>>>>> move_pages() is best effort and can temporarily fail when concurrent
>>>>> faults race with page unmapping. A busy shared-anon workload can exhaust
>>>>> the current 100 retries long before the intended 20-second runtime and
>>>>> produce a false failure.
>>>>>
>>>>> Use the full runtime as the retry window. Since the initial page location
>>>>> is unknown, require it to reach both alternating NUMA targets to confirm
>>>>> that cross-node migration made progress despite transient contention.
>>>>>
>>>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>>>> ---
>>>>
>>>> Makes sense, but see below.
>>>>
>>>>
>>>>> Changes since v1:
>>>>> - Retry per-page failures for the full runtime
>>>>> - Verify that both alternating NUMA targets are reached
>>>>> ---
>>>>>  tools/testing/selftests/mm/migration.c | 39 ++++++++++++++------------
>>>>>  1 file changed, 21 insertions(+), 18 deletions(-)
>>>>>
>>>>> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
>>>>> index 29f7492453d43..4d55a424058a9 100644
>>>>> --- a/tools/testing/selftests/mm/migration.c
>>>>> +++ b/tools/testing/selftests/mm/migration.c
>>>>> @@ -7,7 +7,7 @@
>>>>>  #include "kselftest_harness.h"
>>>>>  #include "hugepage_settings.h"
>>>>>  
>>>>> -#include <strings.h>
>>>>> +#include <string.h>
>>>>>  #include <pthread.h>
>>>>>  #include <numa.h>
>>>>>  #include <numaif.h>
>>>>> @@ -20,7 +20,6 @@
>>>>>  
>>>>>  #define TWOMEG		(2<<20)
>>>>>  #define RUNTIME		(20)
>>>>> -#define MAX_RETRIES	100
>>>>>  #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
>>>>>  
>>>>>  HUGETLB_SETUP_DEFAULT_PAGES(1)
>>>>> @@ -110,7 +109,7 @@ int migrate(uint64_t *ptr, int n1, int n2)
>>>>>  	int ret, tmp;
>>>>>  	int status = 0;
>>>>>  	struct timespec ts1, ts2;
>>>>> -	int failures = 0;
>>>>> +	int success = 0;
>>>>>  
>>>>>  	if (clock_gettime(CLOCK_MONOTONIC, &ts1))
>>>>>  		return -1;
>>>>> @@ -119,29 +118,33 @@ int migrate(uint64_t *ptr, int n1, int n2)
>>>>>  		if (clock_gettime(CLOCK_MONOTONIC, &ts2))
>>>>>  			return -1;
>>>>>  
>>>>> -		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME)
>>>>> -			return 0;
>>>>> +		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME) {
>>>>> +			/* Reaching both targets verifies a cross-node move. */
>>>>> +			if (success >= 2)
>>>>> +				return 0;
>>>>> +			else
>>>>> +				return -2;
>>>>> +		}
>>>>>  
>>>>>  		ret = move_pages(0, 1, (void **) &ptr, &n2, &status,
>>>>>  				MPOL_MF_MOVE_ALL);
>>>>> -		if (ret) {
>>>>> -			if (ret > 0) {
>>>>> -				/* Migration is best effort; try again */
>>>>> -				if (++failures < MAX_RETRIES)
>>>>> -					continue;
>>>>> -				printf("Didn't migrate %d pages\n", ret);
>>>>> -			}
>>>>> -			else
>>>>> -				perror("Couldn't migrate pages");
>>>>> -			return -2;
>>>>> +		if (ret < 0) {
>>>>> +			perror("Couldn't migrate pages");
>>>>> +			return ret;
>>>>>  		}
>>>>> -		failures = 0;
>>>>> +		/* Migration is best effort. Try again */
>>>>> +		if (ret > 0 || status < 0)
>>
>> Also what if you migrated accidentally to node 0? In which case you
>> will return a false success below.
> What do you mean by "migrated accidentally to node 0"? Can you give an
> example?

I meant it can happen that ret is 0, status is 0. Then you will pass
"status != n2" and the function will return 0.

So probably just return -2 instead of status?

> 
>>
>>
>>>>
>>>> old code wasn't using status, so why now?
>>> The old code not using it does not mean we cannot use it now. ret gives the
>>
>> I never implied that :) The observation was because I didn't see it mentioned
>> in the commit message, this change is orthogonal to the description.
>>
>>
>>> aggregate result, while status gives the per-page result: the destination
>>> node on success or a negative errno explaining the failure. In particular,
>>> move_pages() can return 0 with a negative status, so checking it prevents a
>>> failed move from being counted as successful.
>>
>> Crazy stuff. So move_pages() can return zero but that return value is not
>> really the return value and you have to check status.
>>
>> The man page reads:
>>
>> "status is an array of integers that return the status of each page.
>> The array contains valid values only if move_pages() did not return
>> an error."
>>
>> But then says
>>
>> "On success move_pages() returns zero.  On error, it returns -1, and sets
>> errno to indicate the  error. If positive value is returned, it is the
>> number of nonmigrated pages."
>>
>> I don't know which one to fix, the manpage or the ABI, I suspect the latter,
>> storing error codes in a variable and then returning zero sounds wrong.
>>
>>>
>>>>
>>>>> +			continue;
>>>>> +		if (status != n2) {
>>>>> +			printf("Page is on node %d instead of target node %d\n",
>>>>> +			       status, n2);
>>>>> +			return status;
>>>>> +		}
>>>>> +		success++;
>>>>>  		tmp = n2;
>>>>>  		n2 = n1;
>>>>>  		n1 = tmp;
>>>>>  	}
>>>>> -
>>>>> -	return 0;
>>
>> There is no return statement after the while loop. I suspect on some compiler
>> config it is gonna complain about this, or someone inevitably will run the
>> selftests with an old compiler and complain about this :)
> The loop cannot fall through, and the minimum supported GCC and Clang versions
> recognize that. No trailing return is needed.

Okay.


> 
>>
>>>>>  }
>>>>>  
>>>>>  void *access_mem(void *ptr)
>>>>
>>>
>>
> 


