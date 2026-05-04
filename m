Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEF90CD3430
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 13:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1AF46B0005; Mon,  4 May 2026 09:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECBD56B008A; Mon,  4 May 2026 09:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE1736B008C; Mon,  4 May 2026 09:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD0DA6B0005
	for <linux-mm@kvack.org>; Mon,  4 May 2026 09:52:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 782941601BA
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:52:42 +0000 (UTC)
X-FDA: 84729877764.09.099C7A4
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4B5D520009
	for <linux-mm@kvack.org>; Mon,  4 May 2026 13:52:39 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777902760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KyCgYSg2/HvOSBbVVftXfhMBr7YVYXQ5HtBWv//mH/g=;
	b=vbvsy/+KFibSC7gzmyc1fLDlQqUOp8b6nGUVi/+gYURqfCI1OW1mp2BcyZMFYGoDN5fewZ
	EoRK7oiWSsy6Os+2+BkWi7KYrc4GA+mMemNCuTR1s6l2qGzU7OxBS9ljVmubYWar9y7Hf7
	uzXHZ1Q2PwxYgDAbWZecYdDPFGAOWgc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777902760; a=rsa-sha256;
	cv=none;
	b=oelQ3X+1taNl2XDH5btdaSCMYQ5oRIEbEUdoHEbarlJzKwHILbRJloc65LHYkzfKcb3GEE
	wNiefAzJpfN8vAGcfLcT31TPsScSJli182gnWoTwi2UGdXoY//1Yi0V0uPO3ZVQjHn6Zxo
	UyOtUZhbGw7vCVBH4Bwg5h1j3q9yaNE=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4g8NNZ2MJyzHnH2l;
	Mon,  4 May 2026 21:51:42 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 21B2640570;
	Mon,  4 May 2026 21:52:36 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 4 May 2026 16:52:02 +0300
Message-ID: <2446b1e8-2b9a-4621-bbb3-ccec0f1aa604@huawei-partners.com>
Date: Mon, 4 May 2026 16:52:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v1 0/4] mm/damon: Introduce a huge page collapsing
 mechanism using auto tuning
To: SeongJae Park <sj@kernel.org>
CC: <artem.kuzin@huawei.com>, <stepanov.anatoly@huawei.com>,
	<wangkefeng.wang@huawei.com>, <yanquanmin1@huawei.com>, <zuoze1@huawei.com>,
	<damon@lists.linux.dev>, <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
References: <20260501004148.78873-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260501004148.78873-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Stat-Signature: f3i7pyj1t7k6wtf8o7cxi5npxcs1f4tx
X-Rspamd-Queue-Id: 4B5D520009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1777902759-69233
X-HE-Meta: U2FsdGVkX1+B1xYIMbta2qhNbvdsOYQvA/N6Shx9k6AaDhXSxdSz6KGbNLVj1JB1z1ms002i5D24axWQc8lcxDzGgiQvEv+X/q+uhOGGl87Ea6XAjBuAAiw7lXPbsXc28cAiX7W3I8pzd1VIR1+yIK/MYV5qpQMNnRN5gcPARByM/AnuV3GQ2AbjEw8QS4g0H5JhO5pQUbI7KQWjhAxmZ6Hfg8Bew/4GbPt46b/SD8LqVlVR/4rqF56qFYSt8Kxqg+uwMRXGCJ0u74HqWpbHKU2AEV3VJ6K4Zg69ZT6dMOBMUJpvlUKWK6o6iXRD58wtBqGTg7goY/bpb21ln15WDD4U9ENTGJ12vhr7jX5Jh7yQR8FH+0MfI8Bk0ePaI5VGksR13wHPRJq0DMxOZJJgRc4DtMw9rk1AYxn5VHNIzsc72f2Dq8C+DA/ylc6WBzQjREllINuSCEQt57aZNtUu1qNP2WEB1p/dP7cnf3XQEGgJk3woUEX952ctpIM3lzpKWimsNudQMSAExu8M8XXr83mDZ84PPin0Zx36PdomqbZb9XRurPb3pQz6bUasNTTXdt1FZIEBe2npYooA4iEKKSjrAmc3onmVXTc0jQEYhAXxxbb8tSIXpKwCUThqe9NV9NrBUropZOrop2M1egGCGnZOkCeLQyczBOWvifbXk/Xf+2iYeUthrX955azZXDeEg/nzwA6kCzRn8/45J0pWG2QNqcmtzwsMrmOsMJKEbdYbpuDwXOQi7lV9MuNqcb4I7guJv5JDGTUMUwOILINF22/UtNvsrlJ8MFvMx9BL+0UAOv07bI69EN5dkNnNdTecUoWG0CTApVPAhPpOp8ST1cZ23IrSTmAzGHgcvfW/tZ59D9vqqy9KgrHRldcOvTrqYhPE0nlCRl6DLum4zY52v0G73vr8Vsmso9HQfHYiHDINWLR6lvS+cyJEaaY636aGVlmlhqWuK1o+GIv5FOo
 opCSM2RO
 xXAo411ggiDE8NeR6I4xqEEk+cQj9n9yYERQTopRC028VecHS+FzjiJ2ChG5JBSIf1kBoaIiP1NEHHCj3xZET6kRBH/KvnG/d5HvBym25Ls4f0BpGQZu0E0f9SNaBfXDDDKKxzbGcPWfXQsVv0C1xBaO8AIKTcGxddgxedXbu9p6AaPQLRFx/5O5KPrdAl4RvGLAJDTDgHIrpl0EEpuL5rBuUJUA2ZEIy8mX1YezEKM87RmDL+dXLDBASAEgcNoasRtulN4dzvqIYOWxDVuSdw919wTDPGrgt5N8jxRhI+dIrFFO3wf0SnHidsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/2026 3:41 AM, SeongJae Park wrote:
> Hello Asier,
Hi, sorry for the delayed answer.
> 
> On Thu, 30 Apr 2026 13:41:35 +0000 <gutierrez.asier@huawei-partners.com> wrote:
> 
>> From: Asier Gutierrez <gutierrez.asier@huawei-partners.com>
>>
>> Overview
>> ================
> 
> Let's align the length of underline with the text.
> 
>>
>> This patch set introduces a new autotuning which allows to collapse
>> hot regions into hugepages.
>>
>> Motivation
>> ================
>>
>> Since TLB is a bottleneck for many systems, a way to optimize TLB
>> misses (or hits) is to use huge pages. Unfortunately, using "always"
>> in THP leads to memory fragmentation and memory waste. For this reason,
>> most application guides and system administrators suggest to disable THP.
> 
> I think the motivation should further explain why existing DAMOS features
> (access pattern-based targetting and quota auto-tuning with existing quota
> goals) are insufficient.  If that makes the text too long, I think the
> explanation for well-known THP benefit and problems can be reduced or skipped.
OK, I will elaborate it in further series.
> 
>>
>> Solution
>> ================
>>
>> A new autotuning quota goal[1], damos_get_used_hugepage_mem_bp, is
>> introduced, which checks the huge page consumption to total anonymous
>> memory consumption. This new quota mechanism reuses current autotuning
>> architecture.
> 
> The idea makes sense to me.
> 
> The name sounds bit redundant, though.  How about DAMOS_QUOTA_HUGEPAGE_BP for
> the enum, and hugeapge_bp for sysfs input?
Agree. In fact, DAMOS_QUOTA_HUGEPAGE_BP would make sense to keep it
consistent with the quota naming.
> 
>>
>> A new module is introduced to demonstrate the use of huge pages
>> collapse autotuning. The module launches a kdamond thread for a 
>> certain task provided by the user through monitored_pid module argument.
> 
> If it is only for demonstration, I think it is more fit to be a sample module
> (placed under samples/damon/).
We are testing this in a bare metal MySQL server. Maybe the description
was not the most accurate.
>>
>> This module also has a user autotuning knob which allows the user to
>> adjust the aggressiveness of page collapsing.
>>
>> Benchmarks
>> ================
>> In progress, will add them in the next RFC series.
> 
> Looking forward to!
> 
> I may request not that much test results for the quota goal.  If the module is
> not just a sample but for a real world use case, I may hope somewhat reasonable
> test resulsts.
OK, will do it.
>>
>> TODO
>> ================
>>
>> - Since DAMOS_COLLAPSE is not in upstream and this is just a
>>   RFC, I have used DAMOS_HUGEPAGE instead. This will change
>>   to DAMOS_COLLAPSE in future series.
> 
> It is now in mm-new and it is recommended to use it as a baseline for DAMON
> patches.  So please feel free to use DAMOS_COLLAPSE from the next version,
> unless there is a reason to worry if DAMOS_COLLAPSE will be dropped from
> mm-new.
Thanks.
>>
>> Patches Sequence
>> ================
>> Patch 1 -> damon_modules_new_vaddr_ctx_target
>> Patch 2 -> Introduce DAMOS_QUOTA_HUGEPAGE and autotuning
>> Patch 3 -> Module that demonstrates how to use DAMOS_QUOTA_HUGEPAGE
>>            and the new VADDR ctx creation
>> Patch 4 -> Documentation
>>
>> [1] https://lore.kernel.org/e67f05ad-dbb9-45e6-ba30-b167a99ac67d@huawei-partners.com
> 
> Adding more context about what this link is would be nice.  I can find the link
> marker from the above text, but I was unable to expect what this is without
> opening the link.
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


