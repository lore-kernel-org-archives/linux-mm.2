Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FE22CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 10:08:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D68298E0003; Sun, 28 Sep 2025 06:08:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18FF8E0001; Sun, 28 Sep 2025 06:08:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E918E0003; Sun, 28 Sep 2025 06:08:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB2ED8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 06:08:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 44E60160952
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:08:08 +0000 (UTC)
X-FDA: 83938233456.29.5C09B85
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6AFC11C000A
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:08:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	spf=pass (imf21.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.232 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759054086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=idADV7fzvxthMB1CG8R7EiIcBYdljtWuNqoLdsSm+Vk=;
	b=QlA+eUUK0fKK380Jps+5CbnR2qr/bWwtzwY3ESlEwo4sgh4yH4VY4euZ8eppSxdfIk510c
	wWgk6hgxJA8n9Xf+5Mgl4Rk0J34bdQGq+7Z4m1/Hlr3Wj3HqjTKb9zzL5Qi3F69EGW42ZD
	MT27R+sXZ54Fl4taXGRSMkrUPvmT9E8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.232 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759054086; a=rsa-sha256;
	cv=none;
	b=oU/IcdYijw0WNBbGhvT0C5w2WNZ6oKbcd/7pSgOBvi0FNmAhLctFfjk4QHiR2Ej3NGmi3Q
	pWsZXMbsCqni9i0nxgQ61/H659GSPyqdmpazI9s5Wkfztz9GiOPd1YXR8DynAhGx+Q+SSv
	sf+cEkPMiiS/tPge69LWfxihy/dobec=
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id 251D0123BCAC3;
	Sun, 28 Sep 2025 18:08:00 +0800 (CST)
Received: from localhost.localdomain (unknown [10.181.220.127])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id C4F9B37CAB1;
	Sun, 28 Sep 2025 18:07:58 +0800 (CST)
From: Zhu Haoran <zhr1502@sjtu.edu.cn>
To: ying.huang@linux.alibaba.com
Cc: dev.jain@arm.com,
	linux-mm@kvack.org,
	zhr1502@sjtu.edu.cn
Subject: Re: [Question] About memory.c: process_huge_page
Date: Sun, 28 Sep 2025 18:07:44 +0800
Message-ID: <20250928100744.16307-1-zhr1502@sjtu.edu.cn>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <873487v1uj.fsf@DESKTOP-5N7EMDA>
References: <873487v1uj.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6AFC11C000A
X-Stat-Signature: 1ywqi3498e47mtkb45rk379mm5gjkpzh
X-HE-Tag: 1759054085-790481
X-HE-Meta: U2FsdGVkX1+x74F3lhX9OWTd/AsI8r8xrbrYHTD9YMfRmmJsBQyekFNdt2IDcUgW2biunICc1fCD/ECMHJv/7q2iGzZLPZfOacUNF0uaerz1eSpAmXVP/L79al6ipUCFYn9bLaJyUCGpwzyBqCxcaqASXXOovkldWCMD+YYJa+l/S63XeoIDZEX61qNwkoDlcMap0EN+q+/aTtoX4YLoxPup0nDap7cuZlXCDWzNe33P9GmM99JRrnUHzg9uo2j0UROigDjGofjblkQ0sYzJCoJpAUBDJftw5kwDvQYU4MolO3iQjnNivMcRPwST7btL31krN+6FT116r3MEys+t2c2qRuuLziYc3oPJKoAxEFv0eKtzy3pfS3UveKJF/RSH0CtedIiiZVJKIeCdFpaOmcLT+aR3VaRm7bKUT+Yr7rmx2+0dDdV9gQZBjsOVSnlAEsFttcYYP3I/n5nAbnma0PamDAd3FSZWYD5/YAZdE6DyBONq9w4ILq0ohx4LrPqja+hht2UXCzAQC/XTCgHWPGGwFWJmNd881OblCI2uY1HuuzOey5Anzt2JrSyTSMwcpcWJWd9vw0z4yAVZCSPs9b63w0zFaSdBKJFcIqjt9aYz1bdVPyK5o8jrli2gcHe6V+imEExOalb1lp2V5+VZ39nztgsV/HZLID0JNKEnlKIaatf5YSnO6x5afLXp03bLyjzd57AJWAPUC+/HYj232adyFSJOPrG4tzQtDPw6RBOfZQ0tzD3iNMmWUZOqEznmIztWvczDp3Px4GcpX6tUUFsSN6+lwP1eyY7L34ZR2tG7405I4pGBn39dncnkyOnQa1jkqU8DvLj+wOTWF0uTUx6+KupWhOOP1GzEoGjUQOBBl83dm9cZ+FVqkTeH7TaKr3CTngLuNcKExDjgn/ZGlf98yt2QruSlPbZbfPZBtEQQRYrgcm5hP/EeClJpaHB4ngOPIDFEI4nIjme1Kp5
 NEpLfR4m
 TxjedE9LFofe6v2vCoNjPTLDtbKmxeyCbDGAsWnLjvzs7+w2Jh2CstrCMX41fopbmYBcAUXtmwxC6Pmy/w87aRCbhL2bBNvdt6mkTFDpMX1Yom7ureIg2USSiRKipMviJM/epRnZncNqzTZbRBH2V2Y52B1Y4+2zgXLnUDSOorF5MGEi5fIMqVQuaeb6ffWZJzm++
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Huang, Ying" <ying.huang@linux.alibaba.com> writes:
>Zhu Haoran <zhr1502@sjtu.edu.cn> writes:
>
>> "Huang, Ying" <ying.huang@linux.alibaba.com> writes:
>>>Hi, Haoran,
>>>
>>>Zhu Haoran <zhr1502@sjtu.edu.cn> writes:
>>>
>>>> Hi!
>>>>
>>>> I recently noticed the process_huge_page function in memory.c, which was
>>>> intended to keep the cache hotness of target page after processing. I compared
>>>> the vm-scalability anon-cow-seq-hugetlb microbench using the default
>>>> process_huge_page and sequential processing (code posted below).
>>>>
>>>> I ran test on epyc-7T83 with 36vCPUs and 64GB memory. Using default
>>>> process_huge_page, the avg bandwidth is 1148 mb/s. However sequential
>>>> processing yielded a better bandwidth of about 1255 mb/s and only
>>>> one-third cache-miss rate compared with default one.
>>>>
>>>> The same test was run on epyc-9654 with 36vCPU and 64GB mem. The
>>>> bandwidth result was similar but the difference was smaller: 1170mb/s
>>>> for default and 1230 mb/s for sequential. Although we did find the cache
>>>> miss rate here did the reverse, since the sequential processing seen 3
>>>> times miss more than the default.
>>>>
>>>> These result seem really inconsitent with the what described in your
>>>> patchset [1]. What factors might explain these behaviors?
>>>
>>>One possible difference is cache topology.  Can you try to bind the test
>>>process to the CPUs in one CCX (that is, share one LLC).  This make it
>>>possible to hit the local cache.
>>
>> Thank you for the suggestion.
>>
>> I reduced the test to 16 vCPUs and bound them to one CCX on the epyc-9654. The
>> rerun results are:
>>
>>                      sequential    process_huge_page
>> BW (MB/s)                523.88               531.60   ( + 1.47%)
>> user cachemiss           0.318%               0.446%   ( +40.25%)
>> kernel cachemiss         1.405%              18.406%   ( + 1310%)
>> usertime                  26.72                18.76   ( -29.79%)
>> systime                   35.97                42.64   ( +18.54%)
>>
>> I was able to reproduce the much lower user time, but the bw gap is still not
>> that significant as in your patch. It was bottlenecked by kernel cache-misses
>> and execution time. One possible explanation is that AMD has less aggressive
>> cache prefetcher, which fails to predict the access pattern of current
>> process_huge_page in kernel. To verify that I ran a microbench that iterates
>> through 4K pages in sequential/reverse order and access each page in seq/rev
>> order (4 combinations in total).
>>
>> cachemiss rate
>>                   seq-seq  seq-rev  rev-seq  rev-rev
>> epyc-9654           0.08%    1.71%    1.98%    0.09%
>> epyc-7T83           1.07%   13.64%    6.23%    1.12%
>> i5-13500H          27.08%   28.87%   29.57%   25.35%
>>
>> I also ran the anon-cow-seq on my laptop i5-13500H and all metrics aligned well
>> with your patch. So I guess this could be the root cause why AMD won't benefit
>> from the patch?
>
>The cache size per process needs to be checked too.  The smaller the
>cache size per process, the more the benefit.

Right. I tuned down the task number to run anon-cow-seq on Intel Core so that
per-task cache size could be larger. The benefit has indeed dropped.

1.125MB cache per task
              sequential     process_huge_page
Amean              664.7                 740.1 (+11.34%)

2MB cache per task
              sequential     process_huge_page
Amean             1287.9                1350.5 ( +4.86%)

4.5MB cache per task
              sequential     process_huge_page
Amean             1373.2                1406.3 ( +2.41%)

9MB cache per task
              sequential     process_huge_page
Amean             2149.0                2070.4 ( -3.66%)

On epyc platform, 7T83 has 4MB per-process cache size and 9654 has only 2MB. On
9654 there was only slightly improvement but on 7T83 we even observe ~10%
regression with process_huge_page.

Do you think this performance issue is worth addressing, especially for AMD? or
acceptable as an architecture difference.

>>>> Thanks for your time.
>>>>
>>>> [1] https://lkml.org/lkml/2018/5/23/1072
>>>>
>>>> ---
>>>> Sincere,
>>>> Zhu Haoran
>>>>
>>>> ---
>>>>
>>>> static int process_huge_page(
>>>>         unsigned long addr_hint, unsigned int nr_pages,
>>>>         int (*process_subpage)(unsigned long addr, int idx, void *arg),
>>>>         void *arg)
>>>> {
>>>>     int i, ret;
>>>>     unsigned long addr = addr_hint &
>>>>         ~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);
>>>>
>>>>     might_sleep();
>>>>     for (i = 0; i < nr_pages; i++) {
>>>>             cond_resched();
>>>>             ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
>>>>             if (ret)
>>>>                     return ret;
>>>>     }
>>>>
>>>>     return 0;
>>>> }

---
Sincere,
Zhu Haoran

