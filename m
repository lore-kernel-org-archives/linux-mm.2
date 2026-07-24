Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1926BC531FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:23:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C58D66B0092; Fri, 24 Jul 2026 11:23:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C09D76B0095; Fri, 24 Jul 2026 11:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B23076B0096; Fri, 24 Jul 2026 11:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 845F86B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:23:34 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4FD4E80425
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:23:31 +0000 (UTC)
X-FDA: 85024039422.12.C301A18
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id D9FB54000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:23:28 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GmurpQz1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784906609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HC4O8Mq/xMZccKyBTvPo+yHKsTjiNuJuJKFJjrj4BKA=;
	b=C4pv0xTWpwWcnCI38/P68qXByroYv83z73Odb1XSUIkh73U8eo7zbo4ktobqVU4vqNVKKm
	YDtd3Im2Zs8AsqRZjm8f8K5nSk/FbE/IR/RjHB1B94is3nKXicm7u4KSP0LsmjMzpz6tsC
	MT59v+TNgzqtnn83Xw8CKxbKRJYURrU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GmurpQz1;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf01.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784906609;
	b=7/P6ZhTSzedaQeNUzHasdBC3EZ6r8QvEy6DpI+na1AfZmkBVHHG1w/NmHh2aeIZvmnEm71
	XKbVB07QRWHCOf/0XLOFMXhRaRaCU7CKSKEXCBq5plAvA98sK7nwXH9Zp57aeHq9zYJU+t
	E/HF1M4wcUAb5yuawA35mjuiFWLYxKo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CFB051477;
	Fri, 24 Jul 2026 08:23:22 -0700 (PDT)
Received: from [10.163.130.214] (unknown [10.163.130.214])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 46FB73F59E;
	Fri, 24 Jul 2026 08:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784906606; bh=ACYBtNCYaJjl7XR898KkCW2Cma75xOG2iqJwYgbhlfo=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=GmurpQz1s9JEDmefvS2dugNTbsf094EOYBEWQZMeKfOi1xhtAwiiXzndmjmIiEI+F
	 /LxDHmlmUL5Of1sL3wq500DyNx7LlytUYoEiiEZrvsorY/GD02osmqMNpGse46kD/x
	 8g13THH5O5UbHBXdsdGlnrzLAYFoOQfrhcrJpYEI=
Message-ID: <6e2236ab-2cfd-4e61-98cc-4e4de9f76bd9@arm.com>
Date: Fri, 24 Jul 2026 20:53:17 +0530
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
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <a3ed6793-8285-4043-a0bb-10bd3890be19@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D9FB54000C
X-Rspam-User: 
X-Stat-Signature: 9jx983q5y3kbkhyhwstn7jf5kpnfp3sf
X-HE-Tag: 1784906608-828964
X-HE-Meta: U2FsdGVkX18WreGY9tMUc/ykrGky7QNROxnvtomLQFg6E5sSwRWzea6EwBrQ/XYvFj3Fd5hM/5T4y322au8PnU7l6TlHq2j9DVhQcgpAvMeuzVTrNSkcpp2R2X9b9pqezTCI0MwHbvpIl+kjKPtGdLp82PNW2avIM49qWnESm6DjfR3iUeWLNdY7OQfwHgtEJ4bHT4ff5zTUzjaZaXA7LtsoYDpN8/Suz51XWWTCWfQxZHwAAqdC7Rdj786lXiAJf25hYDc/Av36Y+JbDDCB1gB2s71gHWEnR5AXAXDrhbWX5UBXW+6rjeCWpAeQcdGNPZRdFB3NBJLQCgxDWvbvQuOxbBSN5r+WLznWG5r6Ols0xJOBeF+2IPi2IExO2shq8xqbMmtgykWmZuUEBJYlAiwv/9SP+n7wgC960qbBxTIouTbxqA8TJRArux+unuL56q5I1s7P2HV9t0qlDxQS/B+mhOk9u8+BaTVeVp+XFp03loGqYJmMvE2U+V9Fxja2nuJ78/59Q+fQLtc28xpgDJ6+WAMW+UrcKx3ndth8f3R1XoqXn/6cysr8gEGomdYMMniota8HRq63uk7xeaf9u2V6aIFN4o1kOqUVwr36yXUq66Xq4nifpf4fM0mb/K1gGx94yWd8D/Q3TYon3ton3pXeWW+Ng2L0ApPtzHV1DkkTLTJcdURdXzh7rzMfLfoWFBhXa6YzM+qNsgomQax5wYpsRAJmBWG2BANT7j4FoWNFqIgh/H4vZYlNQnlwXGAJ3fpvOAy/LdUA0lxy8Cvo/rBBnl8jmJ3Yt3KVuSWusyjDvFToKE4fd0XH6BiuS/fa33bMqGCYKwCocelsPqBCd3NCGr3Tt2wnoolXMaH65Z4m+/8riQuAgPU0InICmEOf5MHpYwSK53fvpk+115IQm1YRSwStseGyRDkY8zrNqEavH99iVN/O3xvd5LBlpglsi02tJAMYpFMyF5+7gCN
 N4uWGfN3
 uvo3MhoyaR5dOIh5X8dDw+FBYfevHxiiDgKoRRGlBPiEvhJtpum+aOvivEfOFoaULBj30pWQG8yz6tjfv9TfqbAlheHNI/ltkg7YbvJN9CUJ2/kee00mFM5N6JPCK3HNsyozNVS8Qrzc9DBZVxM38ATQ40lvmGfRIA5TzhA0uiCzGI86E1nb+DD3duj/z5IK3wz3pGuAK7q/I8nzbQBTWCGu2n3j+4mdptn3ZTObo0FRAhzTsGN3K5O+oRW9rEjLp1ToSwsEDoAtvB5k/SSdwdlARyj9MjBw7JZnAfrr2JgAqOmL1J806uyO5FnI/woeWJSugUwzgfs5+wrHQy0LycwkYIPYiBwKRntjaAqXpv7BIZzctyM/UuvFk/w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 24/07/26 5:23 pm, Muhammad Usama Anjum wrote:
> On 24/07/2026 12:46 pm, Dev Jain wrote:
>>
>>
>> On 24/07/26 3:54 pm, Muhammad Usama Anjum wrote:
>>> move_pages() is best effort and can temporarily fail when concurrent
>>> faults race with page unmapping. A busy shared-anon workload can exhaust
>>> the current 100 retries long before the intended 20-second runtime and
>>> produce a false failure.
>>>
>>> Use the full runtime as the retry window. Since the initial page location
>>> is unknown, require it to reach both alternating NUMA targets to confirm
>>> that cross-node migration made progress despite transient contention.
>>>
>>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>>> ---
>>
>> Makes sense, but see below.
>>
>>
>>> Changes since v1:
>>> - Retry per-page failures for the full runtime
>>> - Verify that both alternating NUMA targets are reached
>>> ---
>>>  tools/testing/selftests/mm/migration.c | 39 ++++++++++++++------------
>>>  1 file changed, 21 insertions(+), 18 deletions(-)
>>>
>>> diff --git a/tools/testing/selftests/mm/migration.c b/tools/testing/selftests/mm/migration.c
>>> index 29f7492453d43..4d55a424058a9 100644
>>> --- a/tools/testing/selftests/mm/migration.c
>>> +++ b/tools/testing/selftests/mm/migration.c
>>> @@ -7,7 +7,7 @@
>>>  #include "kselftest_harness.h"
>>>  #include "hugepage_settings.h"
>>>  
>>> -#include <strings.h>
>>> +#include <string.h>
>>>  #include <pthread.h>
>>>  #include <numa.h>
>>>  #include <numaif.h>
>>> @@ -20,7 +20,6 @@
>>>  
>>>  #define TWOMEG		(2<<20)
>>>  #define RUNTIME		(20)
>>> -#define MAX_RETRIES	100
>>>  #define ALIGN(x, a)	(((x) + (a - 1)) & (~((a) - 1)))
>>>  
>>>  HUGETLB_SETUP_DEFAULT_PAGES(1)
>>> @@ -110,7 +109,7 @@ int migrate(uint64_t *ptr, int n1, int n2)
>>>  	int ret, tmp;
>>>  	int status = 0;
>>>  	struct timespec ts1, ts2;
>>> -	int failures = 0;
>>> +	int success = 0;
>>>  
>>>  	if (clock_gettime(CLOCK_MONOTONIC, &ts1))
>>>  		return -1;
>>> @@ -119,29 +118,33 @@ int migrate(uint64_t *ptr, int n1, int n2)
>>>  		if (clock_gettime(CLOCK_MONOTONIC, &ts2))
>>>  			return -1;
>>>  
>>> -		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME)
>>> -			return 0;
>>> +		if (ts2.tv_sec - ts1.tv_sec >= RUNTIME) {
>>> +			/* Reaching both targets verifies a cross-node move. */
>>> +			if (success >= 2)
>>> +				return 0;
>>> +			else
>>> +				return -2;
>>> +		}
>>>  
>>>  		ret = move_pages(0, 1, (void **) &ptr, &n2, &status,
>>>  				MPOL_MF_MOVE_ALL);
>>> -		if (ret) {
>>> -			if (ret > 0) {
>>> -				/* Migration is best effort; try again */
>>> -				if (++failures < MAX_RETRIES)
>>> -					continue;
>>> -				printf("Didn't migrate %d pages\n", ret);
>>> -			}
>>> -			else
>>> -				perror("Couldn't migrate pages");
>>> -			return -2;
>>> +		if (ret < 0) {
>>> +			perror("Couldn't migrate pages");
>>> +			return ret;
>>>  		}
>>> -		failures = 0;
>>> +		/* Migration is best effort. Try again */
>>> +		if (ret > 0 || status < 0)

Also what if you migrated accidentally to node 0? In which case you
will return a false success below.


>>
>> old code wasn't using status, so why now?
> The old code not using it does not mean we cannot use it now. ret gives the

I never implied that :) The observation was because I didn't see it mentioned
in the commit message, this change is orthogonal to the description.


> aggregate result, while status gives the per-page result: the destination
> node on success or a negative errno explaining the failure. In particular,
> move_pages() can return 0 with a negative status, so checking it prevents a
> failed move from being counted as successful.

Crazy stuff. So move_pages() can return zero but that return value is not
really the return value and you have to check status.

The man page reads:

"status is an array of integers that return the status of each page.
The array contains valid values only if move_pages() did not return
an error."

But then says

"On success move_pages() returns zero.  On error, it returns -1, and sets
errno to indicate the  error. If positive value is returned, it is the
number of nonmigrated pages."

I don't know which one to fix, the manpage or the ABI, I suspect the latter,
storing error codes in a variable and then returning zero sounds wrong.

> 
>>
>>> +			continue;
>>> +		if (status != n2) {
>>> +			printf("Page is on node %d instead of target node %d\n",
>>> +			       status, n2);
>>> +			return status;
>>> +		}
>>> +		success++;
>>>  		tmp = n2;
>>>  		n2 = n1;
>>>  		n1 = tmp;
>>>  	}
>>> -
>>> -	return 0;

There is no return statement after the while loop. I suspect on some compiler
config it is gonna complain about this, or someone inevitably will run the
selftests with an old compiler and complain about this :)

>>>  }
>>>  
>>>  void *access_mem(void *ptr)
>>
> 


