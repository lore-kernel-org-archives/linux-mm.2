Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A30C6CAC5BD
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 00:48:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 633828E0002; Sat, 27 Sep 2025 20:48:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C33C8E0001; Sat, 27 Sep 2025 20:48:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ABC18E0002; Sat, 27 Sep 2025 20:48:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2EAE78E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 20:48:46 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6EA787D49
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 00:48:45 +0000 (UTC)
X-FDA: 83936823810.06.3D64D22
Received: from out30-119.freemail.mail.aliyun.com (out30-119.freemail.mail.aliyun.com [115.124.30.119])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9F9E2180007
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 00:48:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=K54xC4pN;
	spf=pass (imf06.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759020524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=upns7Ns8u6T0BIQB/mEinck47CH4eR87XBgIuH7v8IE=;
	b=HFsO5rQKd5d99G1pfoCkWBNJr5Y+/1yK5zfWTedj9VxvKs1iLBUlrwrR2PDZQQBz7AQY1/
	qk+8AVBbd5YCIiXxgXUSSl7blfDjGq7IpWds4ZWWSmh6+xFOHbMZcrG60P+ucgS/dw6fpK
	PB6XZrXeSrB7PKWWmUWrNjt+G7u2N5s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=K54xC4pN;
	spf=pass (imf06.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.119 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759020524; a=rsa-sha256;
	cv=none;
	b=j2FWrPqpXDYwypzXuEKjzHKM3EG5xIrf0bJhOFifN8ioSxZzCF77ZrCgsYQ1NPQshgJTma
	AXovsYTGG/1FxQ711A17zR9aDAi7m47O3rLG+6ZccXxaVRlzoIr7pYz4pIa6bS3veNx72G
	btetbcvgmCexdbOB98Wum9KBrY+KKak=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759020519; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=upns7Ns8u6T0BIQB/mEinck47CH4eR87XBgIuH7v8IE=;
	b=K54xC4pNWUgtZw+plOnSKlia56KYlVV3w3nJY+m0nNMZxdFUsvBZfB7sN3U5Y4DQmMCycgTOn8/0x0E+MfFuhxKX+ShBwkmcTrrSqx5UzCvhBXrjanBOHIH+KNs/zqAgGTIc4jsUtIutoQFpJtTrdiuFq9rYgA1xZWKpzyhUmtI=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WowZE6d_1759020517 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 28 Sep 2025 08:48:38 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Zhu Haoran <zhr1502@sjtu.edu.cn>
Cc: linux-mm@kvack.org,  dev.jain@arm.com
Subject: Re: [Question] About memory.c: process_huge_page
In-Reply-To: <20250926122735.25478-1-zhr1502@sjtu.edu.cn> (Zhu Haoran's
	message of "Fri, 26 Sep 2025 20:27:35 +0800")
References: <87y0q3e2ph.fsf@DESKTOP-5N7EMDA>
	<20250926122735.25478-1-zhr1502@sjtu.edu.cn>
Date: Sun, 28 Sep 2025 08:48:36 +0800
Message-ID: <873487v1uj.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9F9E2180007
X-Stat-Signature: 7ufdoxkjw77ohngozz65179fb3p3wddg
X-HE-Tag: 1759020522-642552
X-HE-Meta: U2FsdGVkX1/1dDD4nsBPnZ834samBAr8zKheXz1yGZTibhrXItKuoMCjQo5+HV8enSTFTLBJB8Fhh+MfXqhp4NIM3d+thyDtjMoTq7xCDacq/ucXbd80PV4vCZf4rjUHMuB7P42FnTdhUCfdlEBBGZR8MAgefQ+6I2mHW74vFUnQvIL0a8Atr1OvdHAivmemEFP1rVTxPjMZAcRJ4jYGArGM5MWcvNa4Szk7RN3M9MT4f55Fp9SUR+42Is68pbMBcGr3dsEBktFN5pR0ge6Ffb4eehNZjDpbnPfZuY4pgZWJ9hatmQx3h95hP4nQuuN2hfKcNzM0M36RfaoF6yaFjtGiuYWsZs/rewKmR9wxFxstRThdf0wSTTtQfV/LbmiPc8X/aoaf8QhexoG0W8Y/6pwiAMZwF4+J7UBqho/UOK1ROPH6cnlhPj9B1WkcpsA3qIAEgh0obNY1FGyuWPQPrFgASnJZ/jnLiwM0pCW5xHHQ2JePCvwbL/c7RI3bytLGwtSmXZMfpmP86O+yutrx+RFLuvDiyFboZSUaovk1u3DdyQ1TudLUijRc6qUM7Dst596HCMqX+FhryYA1XMIpJTgIeTcV6UhGbx4zZB21sXfvLB1g3OECyOiArmOHRh19EdN7LST/zymVjB1j0AxU4SH/19pmJYSRjHogWGRiD8y333VDfHFwTzAexiGkzz9XBhh8hT1eUM5ti6/GV1I+D67yy1c9frXKxuEikDzfdoYnTfvTnI5OZE3Qk1Wd8ISJSmMwukEav+Zuc6jh387dwEhC1lRcCMcT1StZEGyiLbC1q5q3U56Hlkslhyxm2Z7sTbFv44UrcfJUKErH5dupJTlONcTiembxdc7a0diuIZ/IuGCuaxFcb0Q9xXMcXs3DQHOTICMtye6WPcsW9um1IBK/qPXd6sK1ZCSkX8ciDFtps08hjy0VpQ9GAVhjrBOJ3xfEGrNa0mSQ77GdWPb
 EhJtST66
 LFCsh4x64dbz96PfnwZtjD8IPXfohWaG1GKXlUs+sgSDnjp+zuLRsYcbyY/fy6Ivg6MzpMuT2ZqDtIa+IOm3kw3iP260qCV62PjjcoRXozt9nWC4Qvh9f9bdhcFRuVE27UxnIdoSd8JU3uJZXzUxKuncvnBCcVwiZcpfu4JLkvYshB5fgqNLezRMhURazQaVcAPWfbOJIsKnkuvOZhfatTjlf4HZclu8GWUQCxL+LL1joS7W/LxnSkhMKwjJj6EBAxCFIOsmPfMscbvaPXrJ1xykns5v1ikF8djrVSiWdMZvk1VhZH/9qRW/8VffGK07F8SRYZ2pq1s4gdzp2Bkie627sEtCJCjPsLSGaC+jiliOegfk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zhu Haoran <zhr1502@sjtu.edu.cn> writes:

> "Huang, Ying" <ying.huang@linux.alibaba.com> writes:
>>Hi, Haoran,
>>
>>Zhu Haoran <zhr1502@sjtu.edu.cn> writes:
>>
>>> Hi!
>>>
>>> I recently noticed the process_huge_page function in memory.c, which was
>>> intended to keep the cache hotness of target page after processing. I compared
>>> the vm-scalability anon-cow-seq-hugetlb microbench using the default
>>> process_huge_page and sequential processing (code posted below).
>>>
>>> I ran test on epyc-7T83 with 36vCPUs and 64GB memory. Using default
>>> process_huge_page, the avg bandwidth is 1148 mb/s. However sequential
>>> processing yielded a better bandwidth of about 1255 mb/s and only
>>> one-third cache-miss rate compared with default one.
>>>
>>> The same test was run on epyc-9654 with 36vCPU and 64GB mem. The
>>> bandwidth result was similar but the difference was smaller: 1170mb/s
>>> for default and 1230 mb/s for sequential. Although we did find the cache
>>> miss rate here did the reverse, since the sequential processing seen 3
>>> times miss more than the default.
>>>
>>> These result seem really inconsitent with the what described in your
>>> patchset [1]. What factors might explain these behaviors?
>>
>>One possible difference is cache topology.  Can you try to bind the test
>>process to the CPUs in one CCX (that is, share one LLC).  This make it
>>possible to hit the local cache.
>
> Thank you for the suggestion.
>
> I reduced the test to 16 vCPUs and bound them to one CCX on the epyc-9654. The
> rerun results are:
>
>                      sequential    process_huge_page
> BW (MB/s)                523.88               531.60   ( + 1.47%)
> user cachemiss           0.318%               0.446%   ( +40.25%)
> kernel cachemiss         1.405%              18.406%   ( + 1310%)
> usertime                  26.72                18.76   ( -29.79%)
> systime                   35.97                42.64   ( +18.54%)
>
> I was able to reproduce the much lower user time, but the bw gap is still not
> that significant as in your patch. It was bottlenecked by kernel cache-misses
> and execution time. One possible explanation is that AMD has less aggressive
> cache prefetcher, which fails to predict the access pattern of current
> process_huge_page in kernel. To verify that I ran a microbench that iterates
> through 4K pages in sequential/reverse order and access each page in seq/rev
> order (4 combinations in total).
>
> cachemiss rate
>                   seq-seq  seq-rev  rev-seq  rev-rev
> epyc-9654           0.08%    1.71%    1.98%    0.09%
> epyc-7T83           1.07%   13.64%    6.23%    1.12%
> i5-13500H          27.08%   28.87%   29.57%   25.35%
>
> I also ran the anon-cow-seq on my laptop i5-13500H and all metrics aligned well
> with your patch. So I guess this could be the root cause why AMD won't benefit
> from the patch?

The cache size per process needs to be checked too.  The smaller the
cache size per process, the more the benefit.

>>> Thanks for your time.
>>>
>>> [1] https://lkml.org/lkml/2018/5/23/1072
>>>
>>> ---
>>> Sincere,
>>> Zhu Haoran
>>>
>>> ---
>>>
>>> static int process_huge_page(
>>>         unsigned long addr_hint, unsigned int nr_pages,
>>>         int (*process_subpage)(unsigned long addr, int idx, void *arg),
>>>         void *arg)
>>> {
>>>     int i, ret;
>>>     unsigned long addr = addr_hint &
>>>         ~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);
>>>
>>>     might_sleep();
>>>     for (i = 0; i < nr_pages; i++) {
>>>             cond_resched();
>>>             ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
>>>             if (ret)
>>>                     return ret;
>>>     }
>>>
>>>     return 0;
>>> }

---
Best Regards,
Huang, Ying

