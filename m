Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 224FC109B489
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 15:16:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BBDF6B008C; Tue, 31 Mar 2026 11:16:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893986B0095; Tue, 31 Mar 2026 11:16:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0E46B0096; Tue, 31 Mar 2026 11:16:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AF246B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 11:16:00 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DACA1A0108
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:16:00 +0000 (UTC)
X-FDA: 84606708480.05.8AFEEE0
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf14.hostedemail.com (Postfix) with ESMTP id 86764100017
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 15:15:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774970156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dJWls4HbrnRTFReMO03SzwKm2vbyAGHZ2Neo0OuCcSQ=;
	b=YwysHhF5I4GybD4Gzo/5+YTU+yIFBfH/W7X+gheQjypIM/SBe9HLNDM6IubBphToliIAsF
	1kNt6ojQ/JQqXwB4hL08ziI2NzlCtuvwuoLVTgoSL5Guop1attHGtjjGT7RCfNwIhHjuwr
	YyU3qzz1p9vpfWwsLO5QzhHFe8o7/mU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	spf=pass (imf14.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774970156; a=rsa-sha256;
	cv=none;
	b=nuFD7ppfUGHb53ntaHnz9vko7yTeANKO8Wn7UmaHrXGXVk4/9HScUQSyXN6d5CnmWiPusR
	kGjEV/+4ZZoHLTRa6v9GO2f8+svJD9VN/Jr051Vf+/2wnisqtQKZAIP70VnfuMt/imU3yK
	ySdHqwOmQGfYs1dB4/Rs4fX0zvwk2ZI=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4flWs03LK4zJ46CX;
	Tue, 31 Mar 2026 23:15:32 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 11DE140571;
	Tue, 31 Mar 2026 23:15:51 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 31 Mar 2026 18:15:50 +0300
Message-ID: <4fe88a6b-2d9a-455b-9ab0-5ff153e0e88d@huawei-partners.com>
Date: Tue, 31 Mar 2026 18:15:50 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE
 scheme action
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260331013109.66590-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260331013109.66590-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Stat-Signature: frmankdk19hdkg6cc8yaq446wxang3y5
X-Rspamd-Queue-Id: 86764100017
X-Rspamd-Server: rspam09
X-HE-Tag: 1774970155-619778
X-HE-Meta: U2FsdGVkX184gqeBi91T51QRVrI75CJNvxNc5m9octH0RzmTWMGhrtN+DIAirKAqeVVmbNduVDdXo+evBKGymrtP0K9j5oj/tXFHEa84jCrEsoBcCURjI3+Mt3sJ1uwLxF3nb59WCAscURHQ0e5So2mG3TwyiyQJxfJ77fHXa+4CaxrchETi2sz0KQB+EQSAVp+ePAWeMBVYj/houwhrJZXFy6idkNrk50q1kScyV5M5o1AD6bvmb42SVZIwKNyyKv3LlSm9R2s9sj4xtzhlxiEjxKS2SEc46S5TbFTK3FXnwv+Z+I1IbqmaR8JHNyetVE963U9o9k+7CERQh9WnjDE3C2kFr0Q5ik3/E+C1YFmB4xrMwlKX4nguDKqJsHB3f5GAKJgc1Rz9F8XHEdBH+L/d50XSVih2P01UViRiIPjgAfLjHISQZd1zCQmZU+MgivaU2CfpLmfB9sIMJ+udwd3qwTf2JdtRDDNOTbv2Oa/lFP58wqR5LtBcNQd8P2yc2hueSEEvH6RNmsX42fMw5kyE7ttb+dBjqFnaPihM2SyH/BRKVLzCtDhtz+wMfPQh4Sz1YRCMmyNHHCFY/TOXkvl+f+1Ftz99b12l357+Qc/8Z9DQWzhBVmhOohB3qOCMWFm4Xe48yZHdDN5sr64Ad+aMaJ5RU49U9umdgc9nWDdLdp20RCSK7liwpykBKM4qle2QY1H78HZ0hkxK0oXyJOOvIisXbZJug0yjKtvl5nth3IO09gu0ZZ8kojU6tiqvfkoruFkrmXn5L69rwhoPYxABfjnQsHvisfrVM2hMaqjLL+ELZDYWPxY996g6s/zRjdLWN/d+QuPI9vvxu5hVcngnBgR9lxWyqEXMjYwDjGr5jWCfxD65qliHnbtJ/4cu3essuDenb125DZN/QfakIRkvDvPqOKKKvPGdVauiflOtn/1JTjQSVZCt8b8oMRov2j6WI+nOj3GOSfGJtJu
 PhdGPwR6
 8v8y/Xhjeln4VufL0FS75B+mw9w/Kiwe9EQmETNzn4XUFuh7nN28KYzVpuOrWebiNORHTzjzIkg4UilyiEjLGcyjZUPMIXo6eMz6i6GnV/WGmhIgtQ9hUpOmAGt7TAVzBuOVevG0mCLvD/6MyIPxyudhGIDu3sndtzu6lWg9azW5Lv/qkRrT3JhuqcWS4/qmqETetXDkM0fNS5Lx0tCB/+p+MLuw214JsWCyShivUU52P9dr7cmlhRMfewziwdaE2kdX78SyFAFrhjfNgggs8kqcR/Etw6mSp9Z3gJG8SjQ+xpIzrNtZRSgsCEkpBUUgiwnmB0avw2dC+TP0uSiG43h6SkqQ0HQgel+YVp45tDxEZZnZf3YTecaCVYPCngwEySO1y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 3/31/2026 4:31 AM, SeongJae Park wrote:
> Hello Asier,
> 
> On Mon, 30 Mar 2026 14:57:58 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> This patch set introces a new action:  DAMOS_COLLAPSE.
>>
>> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
>> working, since it relies on hugepage_madvise to add a new slot. This
>> slot should be picked up by khugepaged and eventually collapse (or
>> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
>> enabled, khugepaged will not be working, and therefore no collapse
>> will happen.
> 
> I should raised this in a previous version, sorry.  But, that is only a half of
> the picture.  That is, khugepaged is not the single THP allocator for
> MADV_HUGEPAGE.  IIUC, MADV_HUGEPAGE-applied region also allocates huge pages in
> page fault time.  According to the man page,
> 
>     The kernel will regularly scan the areas marked as huge page  candidates
>     to replace  them with huge pages.  The kernel will also allocate huge pages
>     directly when the region is naturally aligned to the huge page size (see
>     posix_memalign(2)).
> 
> I think the description is better to be wordsmithed or clarified.  Maybe just
> pointing the MADV_COLLAPSE intro commit (7d8faaf15545 ("mm/madvise: introduce
> MADV_COLLAPSE sync hugepage collapse")) for the rationale could also be a good
> approach, as the aimed goal of DAMOS_COLLAPSE is not different from
> MADV_COLLAPSE.
> 
>>
>> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
>> the address range synchronously.
>>
>> This new action may be required to support autotuning with hugepage
>> as a goal[1].
>>
>> [1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
>>
>> ---------
>> Benchmarks:
> 
> I recently heard some tools could think above line as the commentary
> area [1] separation line.  Please use ==== like separator instead.  For
> example,
I will fix it for the next version.
> 
>     Benchmarks
>     ==========
> 
>>
>> Tests were performed in an ARM physical server with MariaDB 10.5 and 
>> sysbench. Read only benchmark was perform with uniform row hitting,
>> which means that all rows will be access with equal probability.
>>
>> T n, D h: THP set to never, DAMON action set to hugepage
>> T m, D h: THP set to madvise, DAMON action set to hugepage
>> T n, D c: THP set to never, DAMON action set to collapse
>>
>> Memory consumption. Lower is better.
>>
>> +------------------+----------+----------+----------+
>> |                  | T n, D h | T m, D h | T n, D c |
>> +------------------+----------+----------+----------+
>> | Total memory use | 2.07     | 2.09     | 2.07     |
>> | Huge pages       | 0        | 1.3      | 1.25     |
>> +------------------+----------+----------+----------+
>>
>> Performance in TPS (Transactions Per Second). Higher is better.
>>
>> T n, D h: 18324.57
>> T n, D h 18452.69
> 
> "T m, D h" ?
Right, my bad. I will fix it.
> 
>> T n, D c: 18432.17
>>
>> Performance counter
>>
>> I got the number of L1 D/I TLB accesses and the number a D/I TLB
>> accesses that triggered a page walk. I divided the second by the
>> first to get the percentage of page walkes per TLB access. The
>> lower the better.
>>
>> +---------------+--------------+--------------+--------------+
>> |               | T n, D h     | T m, D h     | T n, D c     |
>> +---------------+--------------+--------------+--------------+
>> | L1 DTLB       | 127248242753 | 125431020479 | 125327001821 |
>> | L1 ITLB       | 80332558619  | 79346759071  | 79298139590  |
>> | DTLB walk     | 75011087     | 52800418     | 55895794     |
>> | ITLB walk     | 71577076     | 71505137     | 67262140     |
>> | DTLB % misses | 0.058948623  | 0.042095183  | 0.044599961  |
>> | ITLB % misses | 0.089100954  | 0.090117275  | 0.084821839  |
>> +---------------+--------------+--------------+--------------+
>>
>> - We can see that DAMOS "hugepage" action works only when THP is set
>>   to madvise. "collapse" action works even when THP is set to never.
> 
> Make sense.
> 
>> - Performance for "collapse" action is slightly lower than "hugepage"
>>   action and THP madvise.
> 
> It would be good to add your theory about from where the difference comes.  I
> suspect that's mainly because "hugepage" setup was allocating more THP?
Correct. I will add a better description of the behaviour.
>> - Memory consumption is slighly lower for "collapse" than "hugepage"
>>   with THP madvise. This is due to the khugepage collapses all VMAs,
>>   while "collapse" action only collapses the VMAs in the hot region.
> 
> But you use thp=madvise, not thp=always?  So only hot regions, which
> DAMOS_HUGEPAGE applied, could use THP.  It is same to DAMOS_COLLAPSE use case,
> isn't it?
> I'd rather suspect the natural-aligned region huge page allocation of
> DAMOS_HUGEPAGE as a reason of this difference.  That is, DAMOS_HUGEPAGE applied
> regions can allocate hugepages in the fault time, on multiple user threads.
> Meanwhile, DAMOS_COLLAPSE should be executed by the single kdamond (if you
> utilize only single kdamond).  This might resulted in DAMOS_HUGEPAGE allocating
> more huge pages faster than DAMOS_COLLAPSE?
This well could be the case. The database used 32 threads, so we may have
simultaneously faults in all those threads, hence the behavior.
> 
>> - There is an improvement in THP utilization when collapse through
>>   "hugepage" or "collapse" actions are triggered.
> 
> Could you clarify which data point is showing this?  Maybe "Huge pages" /
> "Total memory use" ?  And why?  I again suspect the fault time huge pages
> allocation.
Looking at the performance counters and the percentage of TLB accesses
that triggered a page walk. I will clarify this point in the next version.
> 
>> - "collapse" action is performance synchronously, which means that
>>   page collapses happen earlier and more rapidly.
> 
> But these test results are not showing it clearly.  Rather, the results is
> saying "hugepage" was able to make more huge pages than "collapse".  Still the
> above sentence makes sense when we say about "collapsing" operations.  But,
> this test is not showing it clearly.  I think we should make it clear the
> limitation of this test.
I will add another table clarifying this. My point was that the allocation
in my tests happened earlier and faster using "collapse" than "hugepage".
>>   This can be
>>   useful or not, depending on the scenario.
>>
>> Collapse action just adds a new option to chose the correct system
>> balance.
> 
> That's a fair point.  I believe we also discussed pros and cons of
> MADV_COLLAPSE, and concluded MADV_COLLAPSE is worthy to be added.  For
> DAMOS_COLLAPSE, I don't think we have to do that again.
> 
>>
>> Changes
>> ---------
>> RFC v2 -> v1:
>> Fixed a missing comma in the selftest python stript
>> Added performance benchmarks
>>
>> RFC v1 -> RFC v2:
>> Added benchmarks
>> Added damos_filter_type documentation for new action to fix kernel-doc
> 
> Please put changelog in the commentary area, and consider adding links to the
> previous revisions [1].
Ack
> 
>>
>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>> ---
> 
> Code looks good to me.  Nonetheless I'd hope above commit message and benchmark
> results analysis be more polished and/or clarified.
> 
> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
> 
> 
> Thanks,
> SJ

Thanks for the review.

I will run some more tests today. The test try to hit every row in the database,
which may not be realistic. Usually only some parts of the table are really hot.
I will change the test to get something closer to a normal distribution on the
table hit.

-- 
Asier Gutierrez
Huawei


