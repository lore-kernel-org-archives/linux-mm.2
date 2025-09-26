Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1AF57CAC5B9
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 12:39:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77D968E0005; Fri, 26 Sep 2025 08:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72E4E8E0001; Fri, 26 Sep 2025 08:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6446E8E0005; Fri, 26 Sep 2025 08:39:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4D8848E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:39:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D6CC0140301
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:39:11 +0000 (UTC)
X-FDA: 83931356502.14.7CD12E2
Received: from smtp232.sjtu.edu.cn (smtp232.sjtu.edu.cn [202.120.2.232])
	by imf20.hostedemail.com (Postfix) with ESMTP id 126D61C0013
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 12:39:08 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	spf=pass (imf20.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.232 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758890350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sbyhiI0JrW4vjFyQ/wlshJhratpquAgd2j/gXw9N3Kc=;
	b=3ROuaKw3Mai84+aDxSX3rZIhZbQk6W3LLwT7LToiMDodI0pVaiFlvpZ8YMhViHZDj/U0oP
	K+QiXLAT+GmGj/jJ9g2w0UZ/rWy4m1PzxVfGKMznLBmA7/9WhYD7GjUzVKYjeGAhHuS1BZ
	O53feHSz0WdENHiwLpUcsgYcaaL3VTM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of zhr1502@sjtu.edu.cn designates 202.120.2.232 as permitted sender) smtp.mailfrom=zhr1502@sjtu.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758890350; a=rsa-sha256;
	cv=none;
	b=PPg/rp9jyKVc3RufFaF6/G+FL2f2pJpd84Vw8XW/U/n4ji2A3G5rLe9AUwkYA8vAIwV1cx
	M1ZUhQZR53q/4vFD50P9BHvJ5O7tTvFBrCPJXiIBY9bbONtQ4B8gPQODBP4RhyLnVQaukk
	nEnpwxiPEIJPHkGsuAMyW6HxqWbKXn0=
Received: from proxy188.sjtu.edu.cn (smtp188.sjtu.edu.cn [202.120.2.188])
	by smtp232.sjtu.edu.cn (Postfix) with ESMTPS id E96E0124B5B46;
	Fri, 26 Sep 2025 20:39:03 +0800 (CST)
Received: from localhost.localdomain (unknown [10.181.220.127])
	by proxy188.sjtu.edu.cn (Postfix) with ESMTPSA id D2ADE37C999;
	Fri, 26 Sep 2025 20:39:03 +0800 (CST)
From: Zhu Haoran <zhr1502@sjtu.edu.cn>
To: ying.huang@linux.alibaba.com
Cc: linux-mm@kvack.org,
	zhr1502@sjtu.edu.cn,
	dev.jain@arm.com
Subject: Re: [Question] About memory.c: process_huge_page
Date: Fri, 26 Sep 2025 20:38:54 +0800
Message-ID: <20250926123854.26224-1-zhr1502@sjtu.edu.cn>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <87y0q3e2ph.fsf@DESKTOP-5N7EMDA>
References: <87y0q3e2ph.fsf@DESKTOP-5N7EMDA>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 126D61C0013
X-Stat-Signature: rfkztkmqb8otmgjfws1frkfon4ijdif9
X-HE-Tag: 1758890348-748030
X-HE-Meta: U2FsdGVkX1+0FW+qBsk/fuCYT86WWumsEhcdh6NUqpwrCD532vhQfHCJfcNRFBCkeyuFeEsA1UT9G/MBofqc8S3PRLe/L0u4HVDwm5hIZtcxaHzlcgrPEobcjy3RQLlltIesxpj0LLeZt0f9c9shgMFOqG37mopBfkuvy+VUz9YzxAS0VQFscs79C1tvbrbUCmMjJ4chXfWnDSwo2bANySb4Std6sgNDcBwZVyFBJiR6cQSXjxNwpVmu/DvVsvWJrBG0jyLwCnYSVWMl8iYp401CQko0XP/Q1xX4D8OAf9y9/s03fHuMYOpAXqLt27E+SsfmPyjrufhw5zLhTr9kdO/Pluo6awDfH7vYOz++d115ORPcoApZGKbHbocsNRd21v2eoSljNIYRF5fQ3NBNw/GdZJktbQcK6eflMMcJMugpupWD/BvpYeGSuIRbkUEZm+wSJmgrjzH7oVgmm3+y76Me/dmOsKC6ckaKoZAcc2JTnm9SrntffH5H84wMnX4/bO2jX5lRwVwjoSskZygNm7tox/S1RkU85V3bfP47Zaj3cY6J3JFLugiL8NuZD49//xSvHqkXYpeiOoL4uLh5WfQ64Z6W7IksoKM3g+NIh/WHqU4HAZrPy7JmjzZMt7gzKcb6vYgfZAp+eIofYGsLFNkO4UcZVAKggqQ8Dsdy/sxMzdH0jEwWD9zqGTHREX+POfvKgtur41FW7nybxAiN/AzhWcnXJDc7vDaWeGjDpqsO1HNf/HUzMdBrssWPB6yp+Fjq62NKvRXhRd0aM3eS9lUT0IwTIH1k2v2pWVQEPFIL8LJsKW2FlJPUsxr0GpThS0ACe5kn9yvP8M5JX8dBRVkRD18TGN1Zh/pMVSvBDR6I8JONfvMZeKP9XNI6Ek0+a5s6P9Mu2padKosNbyAEtJlPJZ+eRFMxGZ1/nd9efSxLkLhUnzA1C5FpuFwnx97G6DCPfnLdO9bB0A9ykOf
 QkVm78VJ
 Dnh7KLcHMvOPOhaPKEK0ix2xLajyCk0Twztwm3InqytMAbM/4jf9M5H8sBbZB2+tFQ2jUjdiQHBap1Ptfj++lPd7cinP3t1FH/2rkU2/W0tPinyNF76y2yWYy21M5kml8lXdi9ICVVmQG5SL+6+lLlB063MgWL0G+3DPvnqyEsSRfWzpL3mXI6ksTuvO8oAx+4xZe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Huang, Ying" <ying.huang@linux.alibaba.com> writes:
>Hi, Haoran,
>
>Zhu Haoran <zhr1502@sjtu.edu.cn> writes:
>
>> Hi!
>>
>> I recently noticed the process_huge_page function in memory.c, which was
>> intended to keep the cache hotness of target page after processing. I compared
>> the vm-scalability anon-cow-seq-hugetlb microbench using the default
>> process_huge_page and sequential processing (code posted below).
>>
>> I ran test on epyc-7T83 with 36vCPUs and 64GB memory. Using default
>> process_huge_page, the avg bandwidth is 1148 mb/s. However sequential
>> processing yielded a better bandwidth of about 1255 mb/s and only
>> one-third cache-miss rate compared with default one.
>>
>> The same test was run on epyc-9654 with 36vCPU and 64GB mem. The
>> bandwidth result was similar but the difference was smaller: 1170mb/s
>> for default and 1230 mb/s for sequential. Although we did find the cache
>> miss rate here did the reverse, since the sequential processing seen 3
>> times miss more than the default.
>>
>> These result seem really inconsitent with the what described in your
>> patchset [1]. What factors might explain these behaviors?
>
>One possible difference is cache topology.  Can you try to bind the test
>process to the CPUs in one CCX (that is, share one LLC).  This make it
>possible to hit the local cache.

Thank you for the suggestion.

I reduced the test to 16 vCPUs and bound them to one CCX on the epyc-9654. The
rerun results are:

                     sequential    process_huge_page
BW (MB/s)                523.88               531.60   ( + 1.47%)
user cachemiss           0.318%               0.446%   ( +40.25%)
kernel cachemiss         1.405%              18.406%   ( + 1310%)
usertime                  26.72                18.76   ( -29.79%)
systime                   35.97                42.64   ( +18.54%)

I was able to reproduce the much lower user time, but the bw gap is still not
that significant as in your patch. It was bottlenecked by kernel cache-misses
and execution time. One possible explanation is that AMD has less aggressive
cache prefetcher, which fails to predict the access pattern of current
process_huge_page in kernel. To verify that I ran a microbench that iterates
through 4K pages in sequential/reverse order and access each page in seq/rev
order (4 combinations in total).

cachemiss rate
                  seq-seq  seq-rev  rev-seq  rev-rev
epyc-9654           0.08%    1.71%    1.98%    0.09%
epyc-7T83           1.07%   13.64%    6.23%    1.12%
i5-13500H          27.08%   28.87%   29.57%   25.35%

I also ran the anon-cow-seq on my laptop i5-13500H and all metrics aligned well
with your patch. So I guess this could be the root cause why AMD won't benefit
from the patch?

>> Thanks for your time.
>>
>> [1] https://lkml.org/lkml/2018/5/23/1072
>>
>> ---
>> Sincere,
>> Zhu Haoran
>>
>> ---
>>
>> static int process_huge_page(
>>         unsigned long addr_hint, unsigned int nr_pages,
>>         int (*process_subpage)(unsigned long addr, int idx, void *arg),
>>         void *arg)
>> {
>>     int i, ret;
>>     unsigned long addr = addr_hint &
>>         ~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);
>>
>>     might_sleep();
>>     for (i = 0; i < nr_pages; i++) {
>>             cond_resched();
>>             ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
>>             if (ret)
>>                     return ret;
>>     }
>>
>>     return 0;
>> }
>
>---
>Best Regards,
>Huang, Ying

---
Sincere,
Zhu Haoran

