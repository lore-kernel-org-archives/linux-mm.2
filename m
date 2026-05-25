Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 695CACD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 13:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53BDC6B008C; Mon, 25 May 2026 09:53:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C6596B0093; Mon, 25 May 2026 09:53:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33FF56B0095; Mon, 25 May 2026 09:53:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15BA06B008C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 09:53:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C3D4B40142
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:53:27 +0000 (UTC)
X-FDA: 84806084454.28.899197E
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id CB27920015
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:53:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779717206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p2ClKr6X0Zo8AT61XGurLX0vRCmzIc7+Y/vyCv5mfV4=;
	b=gQGT5KR7y+X3DZc2isj72RAYTtMtTMCbQksUDk/Y7d48o989gNyo1+4V0Hz5w5/FRED17u
	Co7+Uj6WiFPBtGjPJygsa6LxwBE02aaPNzBj8IzL46N8QLaOUXHR8cgmzxPSmq2sjKa97E
	U9o8t0VJxc1xK6UsRzOXPZl0vpjn67g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779717206; a=rsa-sha256;
	cv=none;
	b=eiSqRnhi0Jy569RS40uiHmi5cmTLjqHGZNVYjiBEM61rixHpP/g/IlxCFaSeQq0D36p61l
	vQolCTU+Ahk5NuKaw2duOL4VRzgSiT72Ly7cPCObVAgvkowb1dDx+wba/+m/O+WqhbFrcH
	AhFv+Th+y2y2vES88rsczILis5jBXxA=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4gPHPp4rvVzJ46DH;
	Mon, 25 May 2026 21:52:30 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 28FA540570;
	Mon, 25 May 2026 21:53:19 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 25 May 2026 16:53:18 +0300
Message-ID: <a746583d-af0e-401a-b1f8-d4a0e60d5cc3@huawei-partners.com>
Date: Mon, 25 May 2026 16:53:17 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/4] mm/damon: Introduce a huge page collapsing
 mechanism using auto tuning
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260523171710.88918-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260523171710.88918-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspamd-Queue-Id: CB27920015
X-Stat-Signature: 94h7bw9eg8sp9akmgbkk1bd5b8ezed34
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779717204-553140
X-HE-Meta: U2FsdGVkX19B8AgFnkEx8QEx1yzPzaHv/z6xpjiDqa/FdNv3iw4bclLouaIoU8eu4p8+DGntfqp3H56dVA19PfToUwfxNKRHKQ7nkgB8XbR2iqGOGdnYjA2YfiG4s1B22MZYbus2UE4vw01JOtsGXjz798c2TgaZuLOFQfY5c0yFpdiN1r4BSGv0EESR+T+wMk1RHu5VJEklEYI6RSrSf7Pvj203991u2HaquMR8yBo+0pUv5P58tYV9tbEUtnd7X7tm3BeMfHnBy4w1M7X9KYigU4kmYURnVMmiMNcMckUI58XkuAJ1UP/8AuSkFZBvr8hAphixkJKcoIZ7CfmjtcpDAnfHhnbnLupWl7H6ahAocIEBS+i0puW616Gudo3Gd1u48adpKCu3n5mx03EEgXkqpz1FdXB6DkBglTtxpltvpvZ7ivetCssw819Nc5I3Mi7kujyzta+d/hvLlFLUIn0egGai0Yo8GOERd+TBU2x+IeFBgEKOulk95/adeEY8UxQGTTGjCZULQrTNb0h/AmK1eBdoHYacTfrMD/ospxdn65EUl116skZNIxsWtXVkhk8jQFbtWhedYQUXskNeEeaeEiWxPVMpQPrWMSWJb/AhXaEEmOnaE08quzUOjSbnNPCeTh2/pC45Sqdd/yD5VUTC4ElmqR1Cpy7ZI0tz1Ui1vYeggiXoruWMe0fJdaHmlO48yScPR/59/KjWljM+qDlzByOTU+kCoj3UU/DwDJapQdqjUvOqoRRa6SxLnyHUA4eRTfExDbC/huFWVDvEKuaR2jxo68rzx5XlNQ7D/3RRjDxOQ9fL2Q1ECpb+DDaq5WhrzNaZrVbyG9qcNMvzTzGLolgm6rTpKk1JaQKGzlQ6Mby9suNhjtLVdoVCDJ/wfVxYD/NLfaODeuZcHsHVH/0E/ueqtZ7rN474N5NmSxEKx4YHaU7s40OXQwypgVq9K+nDrb69AKXrKa6b4l6
 c9aGfnpS
 NyQqintY1nfRkKLohRuyBI6rmq4hFjllwrCJm3bARgW6etq4HJp37pRy+rQ4sQiDhfdJXq+XV83EH0V+H1PMpyOmu1pHugB2fbKbQxKp7JV9syxsyj1NBoJ+ZQQzWrKyltmOD7Brzx/FPoA0WYzknOD1dNT4ZZqbm571SMaXLR8OxsHZOu2z0PFOQ923Zcy7Nd2E9WropzyrotZcxe7pVZ3N84GC/Vqoc0GnRkomnbqBxDy5tAEK2z818w/ovJ5VFlXqa8eoZbHPc4ZBOnzvBgERigTBOs0ER1EJc9ryxwkV8ITTaWdexiuQpkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 5/23/2026 8:17 PM, SeongJae Park wrote:
> On Fri, 22 May 2026 14:55:14 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Overview
>> ========
>>
>> This patch set introduces a new autotuning which allows to collapse
>> hot regions into hugepages.
> [...]
>> Solution
>> ========
>>
>> DAMON has now a way to autotune some of the variables and adjust quotas
>> automatically, so that DAMON is fired only under the right circumstances.
>> It would be nice to have something similar, but for huge pages.
> 
> Agree.
> 
>>
>> A new autotuning quota goal[2], damos_get_used_hugepage_mem_bp,
> 
> Is the name correct?  I think 'get_used_' may better to be dropped.
Let me change it for the next RFC version.
> 
>> is
>> introduced, which checks the huge page consumption to total anonymous
>> memory consumption. This new quota mechanism reuses current autotuning
>> architecture.
>>
>> A new module is introduced to demonstrate the use of huge pages
>> collapse autotuning. The goal is to collapse hot regions of a given
>> process into huge pages. The module launches a kdamond thread for a 
>> certain task provided by the user through monitored_pid module argument.
>> Hugepage goal autotuning will automatically adjust the aggressiveness
>> of hot region collapses.
> 
> Having a module for the demonstration purpose sounds good.  But, for the
> demonstration purpose, as I previousoly commented, making it as a sample module
> (put under /samples/damon/) or just drop when you drop RFC tag would be better.
> 
> Let me know if this module is aimed to be as is even after you drop RFC tag.
I'll move it to samples. I'll keep the RFC in the next version still,
so I make sure that the major details are polished before I drop RFC tag.
> 
>>
>> This module also has a user autotuning knob which allows the user to
>> adjust the aggressiveness of page collapsing.
>>
>> Benchmarks
>> ==========
>>
>> Huge page collapse autotuning was tested in a physicial machine with
>> MariaDB 10.5.29 and sysbench as the benchmark framework.
>>
>> The hugepage module was set up in the following way:
>>
>> # echo 1000 > min_age
>> # echo 1000 > quota_percentage_hugepage
>> # echo $(pidof mariadbd) > monitored_pid
>> # echo on > enabled
>>
>> The goal was to achieve 10% of the total memory used as hugepage.
>>
>> The table below shows the memory consumption over time. Gaps in the
>> timestamp means that no changes in the hugepage consumption happened
>> over that period of time.
>>
>> +-----------+----------------+---------------+----------------------+
>> | timestamp | anon_memory_mb | huge_pages_mb | percentage hugepage  |
>> +-----------+----------------+---------------+----------------------+
>> | 0         | 2159.761719    | 0             | 0%                   |
>> | 28        | 2177.574219    | 4             | 0%                   |
> [...]
>> | 283       | 2224.601563    | 434           | 20%                  |
>> | 284       | 2224.632813    | 450           | 20%                  |
>> +-----------+----------------+---------------+----------------------+
> 
> Thank you for sharing the test.  What about the performance?  Could you also do
> comparison of the numbers against the module disabled case, and THP disabled
> case?
Will do it.
>>
>> Eventually, the amount of huge pages reached 20%. This is consistent
>> with how quota goals autotuning work. We are more aggresive when the
>> quota is less than 10%, and less aggresive when the quota is higher.
>> At some point, the aggressiveness just fades and no more collapses
>> occur.
> 
> You are correct.  If the behavior disturbs your test, please note that we
> introduced 'temporal' quota tuner [1] to make it easier.  It is merged into
> 7.1-rc1.
> 
>>
>> TODO
>> ====
>> - Support page splitting for cold hugepages.
> 
> Sounds good!  By using two DAMOS schemes that doing collapsing and splitting, I
> think we can make more complete access-aware THP system.
My thought was to add cold page splitting as a separate RFC in the future.
>>
>> Patches Sequence
>> ================
>> Patch 1 -> damon_modules_new_vaddr_ctx_target
>> Patch 2 -> Introduce DAMOS_QUOTA_HUGEPAGE and autotuning
>> Patch 3 -> Module that demonstrates how to use DAMOS_QUOTA_HUGEPAGE
>>            and the new VADDR ctx creation
>> Patch 4 -> Documentation
> 
> Patch 1 is only for Patch 3, right?  Let's put it just before patch 3.
> 
> [1] https://lkml.kernel.org/r/20260310010529.91162-2-sj@kernel.org
> 
> 
> Thanks,
> SJ
> 
> [...]
> 

-- 
Asier Gutierrez
Huawei


