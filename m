Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF7C0FF60FF
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:47:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 506C76B008C; Tue, 31 Mar 2026 06:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48FED6B0095; Tue, 31 Mar 2026 06:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37EA76B0096; Tue, 31 Mar 2026 06:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 238196B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:47:02 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C44FB8CEDF
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:47:01 +0000 (UTC)
X-FDA: 84606030642.07.EA3F0B2
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9318280011
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:46:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774954019; a=rsa-sha256;
	cv=none;
	b=5jf98caRWdAl7t9GnmTEPMxk8j6zH8ESZNdUHRchuUyeiSXv587OO7N/a0vgpt8MO+ejs3
	Q8zMeF72nIV9diRsyCAQcT3Q1zVvISN8jfmdBEOzOYBKWOIIci3Zet1CeQWv7dsWaQaSJq
	z4PseoOXJp/awpelJIJli99sHdWV0sU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf02.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774954019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kB8NGQG0OdcmmpKFrIs9TiKi29QFSEdwqZvHUQwwBmo=;
	b=Oqwy3+gLERnXh46l260KUX+/58klXWurILdX8n+u3d0fEq15W2FpvVhdniOGK4XwSUoYJG
	bgreGMoj0M4LmxLyAhcN5PF7lLlqvCScOqhIcufVFAxdj6bdLsDP+XALhNq4xvlHCFwnbJ
	28Rwq+HQs5W2147sHwYU5By+Td4C0Zo=
Received: from mail.maildlp.com (unknown [172.18.224.83])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4flPth37RszJ46Cy;
	Tue, 31 Mar 2026 18:46:36 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id B9F4E40575;
	Tue, 31 Mar 2026 18:46:54 +0800 (CST)
Received: from [10.123.123.226] (10.123.123.226) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 31 Mar 2026 13:46:54 +0300
Message-ID: <15f60a0e-a21b-472a-ae76-8437e9859e15@huawei.com>
Date: Tue, 31 Mar 2026 13:46:53 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE
 scheme action
To: SeongJae Park <sj@kernel.org>, <gutierrez.asier@huawei-partners.com>
CC: <artem.kuzin@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260331013109.66590-1-sj@kernel.org>
Content-Language: en-US
From: Stepanov Anatoly <stepanov.anatoly@huawei.com>
In-Reply-To: <20260331013109.66590-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.226]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: dwrnjpoouyxbdsxwwemdbrob9d5s7hya
X-Rspamd-Queue-Id: 9318280011
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774954018-272722
X-HE-Meta: U2FsdGVkX19noDYKxZgDqWwCBlc8G3oL0OF572+TMIQ8wtakf5otGMRIdBr3dod/lwq14URhRWOr623CAGgj1sbw2USwCm2HQw1a+WWCvVVLOYh70k/l1ptlJkabQ1M4yZpZho1dXOxDjT1mbOa6EVShTAHvqfYq0V9ms3HXUHs7OFtva+5aULXbXZryfjLmkMgwnESslhrpiWzjEsw0lzES4GxM9P3GU/b9A2HLZuta9tsyw0U5bIQ2nksaGc1hKJDNTjcnnQcoXXCMV8rU+BKtwp4Uy/X6lmzUbvXg/7whsIw9SCM8gWe0wnC43CVIa68dccm33a4Qp3LHm2BgCPBNWdaQAUjyDdD7GIkL9m1prQCll5rT6LdZYiOra6CnnEYh8dCGhZROCNAJDrDAMIa2eLVXNtFWmLVKu5kn8JK64ptzHviCJ4PryzUQOrnAIFTm6yWfKRJ/vTRiZSWExC1HwYLzGErN1dZMzp6Qd/ibBmt2HD/qKEtcUgKQdGDSJg6XbS6Q4E3N+DuQgyf+C7BMh6oM0itTKs+IW3z5nHCROlIS/d4drbK3xtgb36mlBZw2UZdrpVquLjqzjfytx8xRWB1bckHart+C22SBMPaiYd7BVLH8XrAeKlPrdWLtBTDcO+oomX7cbS/+TiN87lNT7MrWMsTgOkA4H9fQJkgwslEdH2OaELs24tpElZkMs1qPIB5ulTeTkQ9aJ/PG2kbbJToa2vJwH43/bOOQFrdV4pN2uivEfD4obFYF1/BSSR1T3R3iKNi9Xgy2VIyk9/KJISbVP+hAxyJDXFKSI5j9+fyBl4EQZ51CMg4j+HPoi8OvNc3AdTIP8pryX8rUtIw143dD8pF++qQEIjA/X5PrJydhTiMR9+YnulG9X8xAmGK/iinA1z2Hpw2lkOOwzOasacvJW/q8/98CvAlXHQ36jlbKcDDJ+2fHkMOi2x1yjC/uv8JsCFzwHw3YAQk
 V46XDmNM
 QfSPoDqWCi+a5VQUlZ3BhuOqzvyseW/yZsUpY8eEI5ZeU9AmVNh0UbOxILHvj8adXPTrELHSl6CkzqJH+Mc3lLwRMlNjSyXiTtrMzoyPx8GgkNbfVgYBzh2qaNTKoAqiUQsQGRa3k+Sjez0U7Uqke5/lWrrm7RgvwDYBTcWn82yYl3jMkEZKm8FneSlTbzXxX0vx813VmERLNLKrQXfQmIWrOI13oOwKOV9sdFIfYHlFplfAbJQsFBGU8bw+V74sq+NccgMGRUC3I5c+bCM/Qe/Ujrlfhb1eWTs85bp9DwOxbHlZMKcHJAk2Rcjco6C51MVdiAzTwMThDnYUWPoF8AvfA2KIMESi2yiEzAvYDOdPIoHM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
I think key difference between DAMOS_HUGEPAGE and DAMOS_COLLAPSE is the granularity.

In DAMOS_HUGEPAGE case, the granularity is always VMA, even if the hot region is narrow.
It's true for both page-fault based collapse and khugepaged collapse.

With DAMOS_COLLAPSE we can cover cases, when there's large VMA, for example,
which contains some hot VA region inside, so we can collapse just that region, not the whole VMA.
 

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
> 
>> - Memory consumption is slighly lower for "collapse" than "hugepage"
>>   with THP madvise. This is due to the khugepage collapses all VMAs,
>>   while "collapse" action only collapses the VMAs in the hot region.
> 
> But you use thp=madvise, not thp=always?  So only hot regions, which
> DAMOS_HUGEPAGE applied, could use THP.  It is same to DAMOS_COLLAPSE use case,
> isn't it?
> 
> I'd rather suspect the natural-aligned region huge page allocation of
> DAMOS_HUGEPAGE as a reason of this difference.  That is, DAMOS_HUGEPAGE applied
> regions can allocate hugepages in the fault time, on multiple user threads.
> Meanwhile, DAMOS_COLLAPSE should be executed by the single kdamond (if you
> utilize only single kdamond).  This might resulted in DAMOS_HUGEPAGE allocating
> more huge pages faster than DAMOS_COLLAPSE?
> 
>> - There is an improvement in THP utilization when collapse through
>>   "hugepage" or "collapse" actions are triggered.
> 
> Could you clarify which data point is showing this?  Maybe "Huge pages" /
> "Total memory use" ?  And why?  I again suspect the fault time huge pages
> allocation.
> 
>> - "collapse" action is performance synchronously, which means that
>>   page collapses happen earlier and more rapidly.
> 
> But these test results are not showing it clearly.  Rather, the results is
> saying "hugepage" was able to make more huge pages than "collapse".  Still the
> above sentence makes sense when we say about "collapsing" operations.  But,
> this test is not showing it clearly.  I think we should make it clear the
> limitation of this test.
> 
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


-- 
Anatoly Stepanov, Huawei

