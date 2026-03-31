Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51DCBFF60FB
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 10:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74876B0095; Tue, 31 Mar 2026 06:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4BA46B0096; Tue, 31 Mar 2026 06:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A89256B0098; Tue, 31 Mar 2026 06:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 979A16B0095
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 06:50:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3739B1A0C59
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:50:26 +0000 (UTC)
X-FDA: 84606039252.01.FA5D26C
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf27.hostedemail.com (Postfix) with ESMTP id 11CB340005
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 10:50:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774954224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=16MP2DJyto6FlQiRGNwjNAoHbIpQB/zxKFD2phhxHPY=;
	b=n7WBc5z5zGy2+rMDOv83QBiWzIS569XQGbLmEY6rdDisYKIDyEmeWTvF3SnNtpV+f4ND6h
	nMjryxEazdc45l+jjj6TOpPeU1sjuajBS2UGfrg2oKxY90Kmf/bVw7qzFha1k+eU/2b652
	F5vQ2z2vUYa16Ryz7skGkYp3yxhQaFA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774954224; a=rsa-sha256;
	cv=none;
	b=LVfJ8CfdXdJua/j40N0DJvGIBFh0hY5CwyP67NhnnOF56uypJMjRofTt16AdACjEzzU9kJ
	CTAGaX6mkCcIX2f0aiZez09p2m/Yece5JVw25F4dCvfGEhXIm3Oc4Jz/Ooltv5bp0PzlK1
	EaAHgb97du8K9vvH6myOrFfUzyVm54g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of stepanov.anatoly@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=stepanov.anatoly@huawei.com
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4flPyh02k3zJ46XN;
	Tue, 31 Mar 2026 18:50:04 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 50F714058B;
	Tue, 31 Mar 2026 18:50:22 +0800 (CST)
Received: from [10.123.123.226] (10.123.123.226) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 31 Mar 2026 13:50:21 +0300
Message-ID: <716989f5-78d3-4e78-98ae-2bf3caa447a9@huawei.com>
Date: Tue, 31 Mar 2026 13:50:21 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/1] mm/damon: support MADV_COLLAPSE via DAMOS_COLLAPSE
 scheme action
From: Stepanov Anatoly <stepanov.anatoly@huawei.com>
To: SeongJae Park <sj@kernel.org>, <gutierrez.asier@huawei-partners.com>
CC: <artem.kuzin@huawei.com>, <wangkefeng.wang@huawei.com>,
	<yanquanmin1@huawei.com>, <zuoze1@huawei.com>, <damon@lists.linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260331013109.66590-1-sj@kernel.org>
 <15f60a0e-a21b-472a-ae76-8437e9859e15@huawei.com>
Content-Language: en-US
In-Reply-To: <15f60a0e-a21b-472a-ae76-8437e9859e15@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.226]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: 11CB340005
X-Stat-Signature: bmosm5titdu897hh9an5c3ufbarjx45d
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774954223-31724
X-HE-Meta: U2FsdGVkX18slKF0m82/Hp+E45/Vfx/Ug6yFKIZ5PaXvfX9rPr7cAI5MOFLClPYrCU51riCOkvAkYvuIVbdCMyrNhNFr92i1p4BJl4EHrBkPuRmnEJ4LhjJOcAVgCgbQb0RY+W1Ke5APRq7HFOea9CNd14CaLaYD1WdKOYudpW9lUG+zEdOzoaj3ay+mVZqUuXmCVSn91f4hoH/1TGLy0NZ1ah9uHXYKww2JkYLrNDOuWU2XZqDkhlo7mHjGQFp6heBlXJKrl4/Ah4eb9EZR7rqZaqUMKmjaftmxql+9XFP4wX7vZ5q2AyKRRhwpEC02bVyrN5JAylHYEFqfGUDD4ndAVOk8lJlWx9qmJlswAjqqzMa8V6xc4E3rARSY+zn2ddPbpWsfN5ryjl3kf8ebNOujdMjDWQxotmKZVaheU3Ev+8UPv6+KMKfrADQ5G9pQCKFD+pCcU3szU68UFwUsr2HIGqiHB6G8tsDeCZ0FjcP+oYmxl1K454EWZJiYfV3xSFfN3WRKj505ig9wwH++0x16tMy7gOV2nS2Cu0p2DlDc4wFTgVb3Pc4gUTHKycdDkf4vqop6LE4fLe4cXJMRUjxa6fPBeAoOpn1CCDp9iuqDOLQY6kKGF9zROAu7Yaovs0560QdS6Hpg8RvKsCSaVOHKlE8Sdl6cfcIpSCGh1TDx8apAwt3HNSM1pUMGH7zDLMSK2QySXbzrEhvJ6Ffq0CpWQHsjiXzpgCZ5S7lAW/BmStZUK1Yypi7oxRPpOFKfINwiH2LDiFuaKcbHUwB1za7bVdPOiMF4z6ks3HG7Pfe1DxBXllM+gOUgzgU6KF0Jb+0gyt2K4+OQW4suqvqDCoBdEvFLlkLUoVC44HkEcigRMJ1rM203qv6oCJ1MlCH4YYP6F8+giq4VtvZEfO6cLzFmJA6Uo6ds2L4hmDa7zDwoIygTUTiuRNdyiQdU/fSvpcktumrXNYuT7Ki0FQp
 r8FL8kqO
 EjCUcEmW0rhW5QAcstlw9UHr6t9Tq3fRGSWlIGF2fPOQq9MfqhfviIPyEIEwSpJRqfDD7kZgRi3GqSo47Yp6Na3YF1n34hmxYtiOD0B9fIeJH3xO9GH0wejs5tymM/EnJnqr4IzuaOFPaWKHneTMTPSIavd1thEPrvZRHEcOe//4IFnCl60GPy3dtwTIbmrLmG23OO1uQ2VNV2EGmd9oqwfBpbEMNTpCselz79M+TWPlr6aspjoHVW0y/Z5fFmvebCsMWkabTYMleXLeW9/xql2g3CeCoS1jhp6oPeiwsdvVC6Zns7VKehGucmEryQBvUR78pSAUxyYj/YqsfEetPm0s1JNos+bBpRbCpBuyLa0xaRrM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/2026 1:46 PM, Stepanov Anatoly wrote:
> On 3/31/2026 4:31 AM, SeongJae Park wrote:
>> Hello Asier,
>>
>> On Mon, 30 Mar 2026 14:57:58 +0000 <gutierrez.asier@huawei-partners.com> wrote:
>>
>>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>>
>>> This patch set introces a new action:  DAMOS_COLLAPSE.
>>>
>>> For DAMOS_HUGEPAGE and DAMOS_NOHUGEPAGE to work, khugepaged should be
>>> working, since it relies on hugepage_madvise to add a new slot. This
>>> slot should be picked up by khugepaged and eventually collapse (or
>>> not, if we are using DAMOS_NOHUGEPAGE) the pages. If THP is not
>>> enabled, khugepaged will not be working, and therefore no collapse
>>> will happen.
>>
>> I should raised this in a previous version, sorry.  But, that is only a half of
>> the picture.  That is, khugepaged is not the single THP allocator for
>> MADV_HUGEPAGE.  IIUC, MADV_HUGEPAGE-applied region also allocates huge pages in
>> page fault time.  According to the man page,
>>
>>     The kernel will regularly scan the areas marked as huge page  candidates
>>     to replace  them with huge pages.  The kernel will also allocate huge pages
>>     directly when the region is naturally aligned to the huge page size (see
>>     posix_memalign(2)).
>>
> I think key difference between DAMOS_HUGEPAGE and DAMOS_COLLAPSE is the granularity.
> 
> In DAMOS_HUGEPAGE case, the granularity is always VMA, even if the hot region is narrow.
> It's true for both page-fault based collapse and khugepaged collapse.
*page-fault THP allocation, not collapse of course.

> 
> With DAMOS_COLLAPSE we can cover cases, when there's large VMA, for example,
> which contains some hot VA region inside, so we can collapse just that region, not the whole VMA.
>  
> 
>> I think the description is better to be wordsmithed or clarified.  Maybe just
>> pointing the MADV_COLLAPSE intro commit (7d8faaf15545 ("mm/madvise: introduce
>> MADV_COLLAPSE sync hugepage collapse")) for the rationale could also be a good
>> approach, as the aimed goal of DAMOS_COLLAPSE is not different from
>> MADV_COLLAPSE.
>>
>>>
>>> DAMOS_COLLAPSE eventually calls madvise_collapse, which will collapse
>>> the address range synchronously.
>>>
>>> This new action may be required to support autotuning with hugepage
>>> as a goal[1].
>>>
>>> [1]: https://lore.kernel.org/damon/20260313000816.79933-1-sj@kernel.org/
>>>
>>> ---------
>>> Benchmarks:
>>
>> I recently heard some tools could think above line as the commentary
>> area [1] separation line.  Please use ==== like separator instead.  For
>> example,
>>
>>     Benchmarks
>>     ==========
>>
>>>
>>> Tests were performed in an ARM physical server with MariaDB 10.5 and 
>>> sysbench. Read only benchmark was perform with uniform row hitting,
>>> which means that all rows will be access with equal probability.
>>>
>>> T n, D h: THP set to never, DAMON action set to hugepage
>>> T m, D h: THP set to madvise, DAMON action set to hugepage
>>> T n, D c: THP set to never, DAMON action set to collapse
>>>
>>> Memory consumption. Lower is better.
>>>
>>> +------------------+----------+----------+----------+
>>> |                  | T n, D h | T m, D h | T n, D c |
>>> +------------------+----------+----------+----------+
>>> | Total memory use | 2.07     | 2.09     | 2.07     |
>>> | Huge pages       | 0        | 1.3      | 1.25     |
>>> +------------------+----------+----------+----------+
>>>
>>> Performance in TPS (Transactions Per Second). Higher is better.
>>>
>>> T n, D h: 18324.57
>>> T n, D h 18452.69
>>
>> "T m, D h" ?
>>
>>> T n, D c: 18432.17
>>>
>>> Performance counter
>>>
>>> I got the number of L1 D/I TLB accesses and the number a D/I TLB
>>> accesses that triggered a page walk. I divided the second by the
>>> first to get the percentage of page walkes per TLB access. The
>>> lower the better.
>>>
>>> +---------------+--------------+--------------+--------------+
>>> |               | T n, D h     | T m, D h     | T n, D c     |
>>> +---------------+--------------+--------------+--------------+
>>> | L1 DTLB       | 127248242753 | 125431020479 | 125327001821 |
>>> | L1 ITLB       | 80332558619  | 79346759071  | 79298139590  |
>>> | DTLB walk     | 75011087     | 52800418     | 55895794     |
>>> | ITLB walk     | 71577076     | 71505137     | 67262140     |
>>> | DTLB % misses | 0.058948623  | 0.042095183  | 0.044599961  |
>>> | ITLB % misses | 0.089100954  | 0.090117275  | 0.084821839  |
>>> +---------------+--------------+--------------+--------------+
>>>
>>> - We can see that DAMOS "hugepage" action works only when THP is set
>>>   to madvise. "collapse" action works even when THP is set to never.
>>
>> Make sense.
>>
>>> - Performance for "collapse" action is slightly lower than "hugepage"
>>>   action and THP madvise.
>>
>> It would be good to add your theory about from where the difference comes.  I
>> suspect that's mainly because "hugepage" setup was allocating more THP?
>>
>>> - Memory consumption is slighly lower for "collapse" than "hugepage"
>>>   with THP madvise. This is due to the khugepage collapses all VMAs,
>>>   while "collapse" action only collapses the VMAs in the hot region.
>>
>> But you use thp=madvise, not thp=always?  So only hot regions, which
>> DAMOS_HUGEPAGE applied, could use THP.  It is same to DAMOS_COLLAPSE use case,
>> isn't it?
>>
>> I'd rather suspect the natural-aligned region huge page allocation of
>> DAMOS_HUGEPAGE as a reason of this difference.  That is, DAMOS_HUGEPAGE applied
>> regions can allocate hugepages in the fault time, on multiple user threads.
>> Meanwhile, DAMOS_COLLAPSE should be executed by the single kdamond (if you
>> utilize only single kdamond).  This might resulted in DAMOS_HUGEPAGE allocating
>> more huge pages faster than DAMOS_COLLAPSE?
>>
>>> - There is an improvement in THP utilization when collapse through
>>>   "hugepage" or "collapse" actions are triggered.
>>
>> Could you clarify which data point is showing this?  Maybe "Huge pages" /
>> "Total memory use" ?  And why?  I again suspect the fault time huge pages
>> allocation.
>>
>>> - "collapse" action is performance synchronously, which means that
>>>   page collapses happen earlier and more rapidly.
>>
>> But these test results are not showing it clearly.  Rather, the results is
>> saying "hugepage" was able to make more huge pages than "collapse".  Still the
>> above sentence makes sense when we say about "collapsing" operations.  But,
>> this test is not showing it clearly.  I think we should make it clear the
>> limitation of this test.
>>
>>>   This can be
>>>   useful or not, depending on the scenario.
>>>
>>> Collapse action just adds a new option to chose the correct system
>>> balance.
>>
>> That's a fair point.  I believe we also discussed pros and cons of
>> MADV_COLLAPSE, and concluded MADV_COLLAPSE is worthy to be added.  For
>> DAMOS_COLLAPSE, I don't think we have to do that again.
>>
>>>
>>> Changes
>>> ---------
>>> RFC v2 -> v1:
>>> Fixed a missing comma in the selftest python stript
>>> Added performance benchmarks
>>>
>>> RFC v1 -> RFC v2:
>>> Added benchmarks
>>> Added damos_filter_type documentation for new action to fix kernel-doc
>>
>> Please put changelog in the commentary area, and consider adding links to the
>> previous revisions [1].
>>
>>>
>>> Signed-off-by: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>> ---
>>
>> Code looks good to me.  Nonetheless I'd hope above commit message and benchmark
>> results analysis be more polished and/or clarified.
>>
>> [1] https://docs.kernel.org/process/submitting-patches.html#commentary
>>
>>
>> Thanks,
>> SJ
> 
> 


-- 
Anatoly Stepanov, Huawei

