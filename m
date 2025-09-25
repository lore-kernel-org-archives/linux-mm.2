Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EB95CAC5A5
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 03:38:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 551A58E0008; Wed, 24 Sep 2025 23:38:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501B78E0001; Wed, 24 Sep 2025 23:38:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 418398E0008; Wed, 24 Sep 2025 23:38:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2CAD88E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 23:38:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 271191402BD
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:38:18 +0000 (UTC)
X-FDA: 83926364676.02.0C8F1D1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf27.hostedemail.com (Postfix) with ESMTP id 14B424000A
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 03:38:15 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758771496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JvXvF7VVQY71/3uS6rM0osRXJnPvYQxh2yXralyNst4=;
	b=Ch3tku8tNmAGOrnSHH569bpiAad+pUmi/seDV0a5cWCtXvJhRKfSf4p8XKGfOAaNT2HzTr
	CLKD7WQAByul6P/NcqsxOTKcWuQfFo4iDovxQKHO0s7ChZH65qh2yiMgndgn9aUR/3XS2M
	rCLaUvYNpzKHcCAglW8TMAOYlvFgrzw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758771496; a=rsa-sha256;
	cv=none;
	b=x+1OMLRV7fbZawxqTlDWxpkv11ImkUo4FOLcPkBBTLu97kj87KxPmLITkHUQHt1DDPeGym
	QRoCQndRnSOUq+OYmRw1xn2XmgDRk9pZdqCL8OLWoYSV5a2N3BoPaJ4D9dEiXg7ju1OPMJ
	/eAimeQiUTuQgNAUzcHN6+vu9QLHChM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DE2CF1692;
	Wed, 24 Sep 2025 20:38:06 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B8973F66E;
	Wed, 24 Sep 2025 20:38:13 -0700 (PDT)
Message-ID: <731ea778-3a75-48ae-8281-4c280a379796@arm.com>
Date: Thu, 25 Sep 2025 09:08:11 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Question] About memory.c: process_huge_page
To: "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Zhu Haoran <zhr1502@sjtu.edu.cn>
Cc: linux-mm@kvack.org
References: <20250924114619.2532-1-zhr1502@sjtu.edu.cn>
 <87y0q3e2ph.fsf@DESKTOP-5N7EMDA>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <87y0q3e2ph.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 14B424000A
X-Stat-Signature: 31dfn3ro8htr7syrq3n3ryd7xjjbkpjm
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758771495-894908
X-HE-Meta: U2FsdGVkX1/Hw/vLInC8SUR9xMbssjvkZG8hjsNobeDPBT3Hu/BFIhS7FSWGQNbvuEg9UYUWiVpDBzECaT8WEzTdLQ0a4SttRc+D8rLT53/9BmGx/SpggFaA1sAoYvNWHJCZSNxKmniQ+7qeDUrH1fvaOLGWV1qW6tPRitq1gDJAe11JFHrbGN5il9cI6qeUtzHqggo3b7GOcG7gLFSXdUZJ0unJ/RlRoTXA9O2ssD9+0rcSC4YsExSaYx7cbZgyKbOCOzyek+xe22PgzQ9cw+K5OCX46Ub5rHDqAKDTsDAR7+8CK3tu4BNWBPLc5b0cdvXn6t+DXVMdRHOb2DeTHfY5PCmsGIhU6bmVTYLFXaeJ1jrQjXPH/vVNOTtQGaePQarO56EZwHtMh8BoEkdVDZuaiDHhOxBmoguHkvdQLoZ33xZriZ+KsWVYTNOMXm20xUu9Wwb4P+K5OWumMG/WpaP5XJpskdxIzQuln6143z4Bkk1FVVxYnyZSmQ04Ko3oULVEmFDE6JYB2u0cuhj3YXuxW+vlP0An6v8kn8lPfDUhdXmrrDtsMkjoR3x/2grQ4a0zMxt2c64Z4vTKj52YgejgLMpmeZFw/1E++KeoRBn/Aq4bTTNTXlFq8S1aoEhNk/1vF6+iYg3Wm1ZEUhT4B1MjxXS5EVkfD9Pzbm+jx3kMmc9mWmGxnXkUaHTC4GZDwy0tuFu+o6Dc/qh6Ybc6G7jxlcxY41NvJs6o5A0FeBAM3/rXumTa28cshiz6dF0E2MddgZxOyWp4y3gehPy2mzMl56YdNejWZ2iPznWqLO2g2bVLW2FZEm+3yGt13LnJe06NrQzsqzocecEOPPGlg6PJoozOjg1lP+JdIWfTmQpYrgZ3TMi/xNTVLdjiStRKTjNI0OjrMB/0buOlbn/EzXTwdNi5gV1FM0Nmi8Evcpu3LaBJvW0ey5n8bFt/qjZ0/YURrW2Ume6pL8WxHwo
 5+eA0JI6
 69O+19w9obpUXiYlCTMZQehQy6WL/fcHXYJTV8KgztwKwc0B4JYnY1cmlHQ7IsCWsJiSD2hSal0VxcUrrT68CiO47lcSqqIbqIw6voT5a2g/Z7LffLGLqZINLH5dsO4fcl9fhVgL6U5cSF8jHoR7PE3ngNfkZxgkzO3F7BKE2Aq3p0Sx7JgWTef3uC+6N1aq5uXXDGAVUTYBFp7tso/HfBZFBQsML8yeQ20axeiJOBwBU6qdnavHTOEdY/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 25/09/25 7:02 am, Huang, Ying wrote:
> Hi, Haoran,
>
> Zhu Haoran <zhr1502@sjtu.edu.cn> writes:
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
> One possible difference is cache topology.  Can you try to bind the test
> process to the CPUs in one CCX (that is, share one LLC).  This make it
> possible to hit the local cache.

Hi, I just had a different question, why is the function sprinkled with
cond_resched() in each loop, especially the last one in which we are calling
it every iteration? I suppose one reason for slowdown may be this too.

>
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
>>          unsigned long addr_hint, unsigned int nr_pages,
>>          int (*process_subpage)(unsigned long addr, int idx, void *arg),
>>          void *arg)
>> {
>>      int i, ret;
>>      unsigned long addr = addr_hint &
>>          ~(((unsigned long)nr_pages << PAGE_SHIFT) - 1);
>>
>>      might_sleep();
>>      for (i = 0; i < nr_pages; i++) {
>>              cond_resched();
>>              ret = process_subpage(addr + i * PAGE_SIZE, i, arg);
>>              if (ret)
>>                      return ret;
>>      }
>>
>>      return 0;
>> }
> ---
> Best Regards,
> Huang, Ying
>

