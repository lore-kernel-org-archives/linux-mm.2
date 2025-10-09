Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23E82CCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:24:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776F78E001B; Wed,  8 Oct 2025 21:24:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7262C8E0002; Wed,  8 Oct 2025 21:24:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63BC18E001B; Wed,  8 Oct 2025 21:24:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4D6388E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:24:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D3D13884A7
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:24:04 +0000 (UTC)
X-FDA: 83976829608.25.9BA15B7
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf19.hostedemail.com (Postfix) with ESMTP id 630C81A0007
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:24:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZK8TzFc4;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759973043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CM9XWNzjNl1vDYpWGqCw8BO6JdPFCjgN5y9tNNkGLVc=;
	b=VnOSnHsxA6CsTzRVC+mYrvl/OXHDNrlq12qIBitFUTrPtO3tYXhF6IRmaytyvgsnrZKZqj
	Fkuou/kLH3IMnfAdhHG/Mv65yyOxtlNslwpnEuDUh2MalKIHzgtwctH/bM79i6ZtZHSn1d
	JNoOEenbe6DnVG0+jwUq9XROhaRPzkg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759973043; a=rsa-sha256;
	cv=none;
	b=vzX2Um5xlW9BduEe0vpmCGBIozQJkNoOYASYzSLt6YYx9okn2ZMyUikfoK7PPvBdml/sd8
	QQsqCFhJS0Tv2DyCp7OUG8F8szECC3d/i0ZGVbgHpA6QxlhdFf2M/NKITt8PZoZUrXMliP
	V3/149L0mInMkuSP69PJXPMbPzI81I4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=ZK8TzFc4;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf19.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759973038; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=CM9XWNzjNl1vDYpWGqCw8BO6JdPFCjgN5y9tNNkGLVc=;
	b=ZK8TzFc4ewmbiqbYaPc187tUBkf9t+8RKGqgrzcpXjyxYV0J+H4r6piXw7kLWzzp5e7pSixgmzDH+83FwdH2IQRLtIHaNPQDhhEvhPlhMt43wYZcvJ5Ku/2IHO2gzIm3f2x7tioIyRzj+umCNE/lyPwQzJ3tJgzzMnHJj/4OFEQ=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WpggU0k_1759973023 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 09:23:55 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Zhu Haoran <zhr1502@sjtu.edu.cn>
Cc: dev.jain@arm.com,  linux-mm@kvack.org
Subject: Re: [Question] About memory.c: process_huge_page
In-Reply-To: <20250928100744.16307-1-zhr1502@sjtu.edu.cn> (Zhu Haoran's
	message of "Sun, 28 Sep 2025 18:07:44 +0800")
References: <873487v1uj.fsf@DESKTOP-5N7EMDA>
	<20250928100744.16307-1-zhr1502@sjtu.edu.cn>
Date: Thu, 09 Oct 2025 09:23:42 +0800
Message-ID: <87jz1427hd.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Server: rspam01
X-Stat-Signature: e413onfew8seco3xbudpuuhcge69qtbz
X-Rspam-User: 
X-Rspamd-Queue-Id: 630C81A0007
X-HE-Tag: 1759973040-414886
X-HE-Meta: U2FsdGVkX1/22G581Hv+etacvvVBdhsbyS+U6ujxAdqTA7nQshH+md6UPc6gDJDEh0OQDn3cNkSBw+ArqLeBXbJSs4TfuGlgQEL9DDu0ZLQpc653gF00zrz5ADSVrKR0L5h60nT8Mo6RW2mBEPW9UdTPd0C0jZZkgYnNRdQ5bMlU3zB/0ef1n4/gEor6oOn4UaLfY+rV3aNvV7i18lS5fFVPneckGftjVrzNUq305Edj1Y2OvQpzwjMU39iKePKRtW7k6skOG0npZ2MAPD5yvlHga/2Mqtc5rLJeRYv+YR/HCLIdNvQ/sgythpywsr1Hq4pN/hvYvPFZ6CoTIf/5QBWBhRg02Dx7MDKqhnm7Ji7cRGsmxjGov6bR3J2TCtUGm/g5f4waJomprsxelYefTKY4g5DyW0Hmh6xws42TdCYxb2NmxIkJfmaMqH0IEevmwr+oe+ZErZ4K0x2RNwhd7pc1vcjK7nSlO/NQuhd4/lbYgZwlou5r5Kj1C2zC/5K1aZ7Z0lr2MNNYYjjGWONByZ1bT1LjOaTyoyUlI6SDSHKOCTUheRtooPVPsD304MoZ5AgGNJ7BHfrzb9hsSNx0oteTUi/LbYd/bvkgBgEfPq6YZSNA0vwbxlogWdUxsqyjGoHwJI3BkCgOZ4UTX8tGzrJYEjdexvDPPC2qUOBpIlV757xl5Tg/61humlCPTNrKBoA7Kcvt5tTrlrF50eANeQtIzxNnH5dtUzRURGXHgn/V3Q5ZSs5TcJcv384B2pbM1FKtGM71flQAtQxnCPnpSB9dOTi2rkULiPBakmbfCL2MMMGSpLOTQj+khQM6wBH4snZjRP2lALj2f4oLHzJBBzB/BOM9972PYxPAXJqZiHr/SS0cOTsZaeLiXfLUPVQvjcJe0hbE2w4QBa/PujDRkpLOD77cPHm4mw7ml50LpXQ3PKemcINE2oNHTyi8eIvPIqpnO9y0cXxQO2SESiC
 H2LZy4Tl
 T0UrAEMsSw/dXOtK4sAMtbcuwz3IJ+RvfMmIz17C/VnqWPfeveymT1V3iYcAUst4drvOGIIzfTnVgt3nW42+wJ5HbPYT4AQs+2m6WiPjLMTm5mNdmOCPmv+U87AseFnSgkDRnoAMocN/Z0Ws3TCMhxcrwnmwsVKzHL/VLuyN2xC02UJstPqQ+GPo3O/4oYGgZKi0QzmwesV5YmWMTbicTq2iOoS2O9uYXRHGzpy2TGfkDlv3+6lg5iq/0qQRv8ZqXr2PO3/jH+kfBhL6mPmwypU+Njuw0wzdQwc5uGBVERkSqKhwWVgx52G3YavlrS5fuconZ9K4AS1S74j0Nszz6pn9VGoDWjMkwNNC8ZhaY3jgVcbA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zhu Haoran <zhr1502@sjtu.edu.cn> writes:

> "Huang, Ying" <ying.huang@linux.alibaba.com> writes:
>>Zhu Haoran <zhr1502@sjtu.edu.cn> writes:
>>
>>> "Huang, Ying" <ying.huang@linux.alibaba.com> writes:
>>>>Hi, Haoran,
>>>>
>>>>Zhu Haoran <zhr1502@sjtu.edu.cn> writes:
>>>>
>>>>> Hi!
>>>>>
>>>>> I recently noticed the process_huge_page function in memory.c, which was
>>>>> intended to keep the cache hotness of target page after processing. I compared
>>>>> the vm-scalability anon-cow-seq-hugetlb microbench using the default
>>>>> process_huge_page and sequential processing (code posted below).
>>>>>
>>>>> I ran test on epyc-7T83 with 36vCPUs and 64GB memory. Using default
>>>>> process_huge_page, the avg bandwidth is 1148 mb/s. However sequential
>>>>> processing yielded a better bandwidth of about 1255 mb/s and only
>>>>> one-third cache-miss rate compared with default one.
>>>>>
>>>>> The same test was run on epyc-9654 with 36vCPU and 64GB mem. The
>>>>> bandwidth result was similar but the difference was smaller: 1170mb/s
>>>>> for default and 1230 mb/s for sequential. Although we did find the cache
>>>>> miss rate here did the reverse, since the sequential processing seen 3
>>>>> times miss more than the default.
>>>>>
>>>>> These result seem really inconsitent with the what described in your
>>>>> patchset [1]. What factors might explain these behaviors?
>>>>
>>>>One possible difference is cache topology.  Can you try to bind the test
>>>>process to the CPUs in one CCX (that is, share one LLC).  This make it
>>>>possible to hit the local cache.
>>>
>>> Thank you for the suggestion.
>>>
>>> I reduced the test to 16 vCPUs and bound them to one CCX on the epyc-9654. The
>>> rerun results are:
>>>
>>>                      sequential    process_huge_page
>>> BW (MB/s)                523.88               531.60   ( + 1.47%)
>>> user cachemiss           0.318%               0.446%   ( +40.25%)
>>> kernel cachemiss         1.405%              18.406%   ( + 1310%)
>>> usertime                  26.72                18.76   ( -29.79%)
>>> systime                   35.97                42.64   ( +18.54%)
>>>
>>> I was able to reproduce the much lower user time, but the bw gap is still not
>>> that significant as in your patch. It was bottlenecked by kernel cache-misses
>>> and execution time. One possible explanation is that AMD has less aggressive
>>> cache prefetcher, which fails to predict the access pattern of current
>>> process_huge_page in kernel. To verify that I ran a microbench that iterates
>>> through 4K pages in sequential/reverse order and access each page in seq/rev
>>> order (4 combinations in total).
>>>
>>> cachemiss rate
>>>                   seq-seq  seq-rev  rev-seq  rev-rev
>>> epyc-9654           0.08%    1.71%    1.98%    0.09%
>>> epyc-7T83           1.07%   13.64%    6.23%    1.12%
>>> i5-13500H          27.08%   28.87%   29.57%   25.35%
>>>
>>> I also ran the anon-cow-seq on my laptop i5-13500H and all metrics aligned well
>>> with your patch. So I guess this could be the root cause why AMD won't benefit
>>> from the patch?
>>
>>The cache size per process needs to be checked too.  The smaller the
>>cache size per process, the more the benefit.
>
> Right. I tuned down the task number to run anon-cow-seq on Intel Core so that
> per-task cache size could be larger. The benefit has indeed dropped.
>
> 1.125MB cache per task
>               sequential     process_huge_page
> Amean              664.7                 740.1 (+11.34%)
>
> 2MB cache per task
>               sequential     process_huge_page
> Amean             1287.9                1350.5 ( +4.86%)
>
> 4.5MB cache per task
>               sequential     process_huge_page
> Amean             1373.2                1406.3 ( +2.41%)
>
> 9MB cache per task
>               sequential     process_huge_page
> Amean             2149.0                2070.4 ( -3.66%)
>
> On epyc platform, 7T83 has 4MB per-process cache size and 9654 has only 2MB. On
> 9654 there was only slightly improvement but on 7T83 we even observe ~10%
> regression with process_huge_page.
>
> Do you think this performance issue is worth addressing, especially for AMD? or
> acceptable as an architecture difference.

I think that we can do some experiment at least.  For example, process
pages sequentially more.  That is, process tail subpages sequentially
instead of reversely.  You may try more if that doesn't help much.

>>>>> Thanks for your time.
>>>>>
>>>>> [1] https://lkml.org/lkml/2018/5/23/1072
>>>>>
>>>>> ---
>>>>> Sincere,
>>>>> Zhu Haoran
>>>>>
>>>>> ---
>>>>>
>>>>> static int process_huge_page(
>>>>>         unsigned long addr_hint, unsigned int nr_pages,
>>>>>         int (*process_subpage)(unsigned long addr, int idx, void *arg),
>>>>>         void *arg)
>>>>> {
>>>>>     int i, ret;
>>>>>     unsigned long addr = addr_hint &
>>>>>         ~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);
>>>>>
>>>>>     might_sleep();
>>>>>     for (i = 0; i < nr_pages; i++) {
>>>>>             cond_resched();
>>>>>             ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
>>>>>             if (ret)
>>>>>                     return ret;
>>>>>     }
>>>>>
>>>>>     return 0;
>>>>> }

---
Best Regards,
Huang, Ying

