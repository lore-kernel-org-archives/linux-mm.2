Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C77CC61DBE
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 12:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 375906B0088; Sat, 29 Aug 2026 08:08:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3267B6B008A; Sat, 29 Aug 2026 08:08:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23CF86B008C; Sat, 29 Aug 2026 08:08:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC8C46B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 08:08:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 683971A06A6
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:08:11 +0000 (UTC)
X-FDA: 85154183982.22.2565ADF
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3E2E740003
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 12:08:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zz4Wq7u7;
	spf=pass (imf12.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788005288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvKWXz/j5Jupz5fjOK8A5bo1yI+OZxHVuzUDDQ85lQU=;
	b=EwR5U4Z9s32wjH27iZTuaCBbzaHsjgc/AxHyRLcH4nw9bikq/kdJ9Xvsok8AFF5nhsd3ls
	mIGU2iuKdFRFkTSZDLgFvU3TRXtbnbHGBq0Fn1CXbNFS+vtHD8XZUfIsVTkliMQOVZFj/T
	2t1iPHjklMp1z/CF1xVPagom9r/SoMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788005288;
	b=TPaU1PD8ditZiXkVtIU8/jd4Eb8iMg5yfKA/KqX+ifJlkxF+9g+W8BsdJaOEEmYXZWJ2xS
	XqNIS4msT6eMnm9JWIqDz6dXgpk93tNidQoiSvu06WTbKO/umzEOV30t2s66kKVB4y31ck
	B3BvHajgvfofeV2FfQexyYttjEp5k7U=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=zz4Wq7u7;
	spf=pass (imf12.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=QvKWXz/j5Jupz5fjOK8A5bo1yI+OZxHVuzUDDQ85lQU=;
	b=zz4Wq7u7NY2JN7Z0bik45bViBrqFRHLhWKFVhW5unt83sFyu+7wtcYfNoxeJQ05Qbwogwipqz
	cKFj81EiwdYlf+WA6yO0VWqb4wKFLCTbCeM/vHxwPArXGwvR8RK+jUyTu3o6gfbqGveXvBWagAd
	MMQ9npSRrj2M0mVYzOoTrPQ=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hXDXP2zGmzJ468J;
	Sat, 29 Aug 2026 20:07:33 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id F342040570;
	Sat, 29 Aug 2026 20:07:57 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Sat, 29 Aug 2026 15:07:57 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <yang@os.amperecomputing.com>
CC: <akpm@linux-foundation.org>, <artem.kuzin@huawei.com>,
	<catalin.marinas@arm.com>, <cl@gentwo.org>, <david@kernel.org>,
	<liam@infradead.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux@armlinux.org.uk>, <ljs@kernel.org>, <mark.rutland@arm.com>,
	<mhocko@suse.com>, <panov.nikita@huawei.com>, <rppt@kernel.org>,
	<surenb@google.com>, <vbabka@kernel.org>, <wangkefeng.wang@huawei.com>,
	<will@kernel.org>
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
Date: Sat, 29 Aug 2026 19:55:25 +0800
Message-ID: <20260829115525.915867-1-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <6c8d880a-0517-4669-80be-8a134f4bf7cb@os.amperecomputing.com>
References: <6c8d880a-0517-4669-80be-8a134f4bf7cb@os.amperecomputing.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml500004.china.huawei.com (7.188.26.250) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Stat-Signature: f3byrh14abuce9g9agzdrs87p91m9ywx
X-Rspamd-Queue-Id: 3E2E740003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788005286-652354
X-HE-Meta: U2FsdGVkX18qpPOKKB2ETzTqjum3deEfql+yjnqs9G3rkfanicteB1TyraOmFdmT0DlaWigyRZmnDbDKzNKWGdKLRlKya9UgV+gj8O7JTtlJds4VxNnUSkvo/FeQndSrNEvsLmtPmpKdBzgjL9m9TN9NvJ6Aa8l7RmlHg4CobhqMdNyeOv5LyNB1/qVkaYsCdpxakje0dP3aqcnzRichmLh5C8AjKOVSf0CtuyhsObLqv+RJ/q7zn9CRiqiYCkTdPFNnutAYKPMX4eel9FntsZOa+HdpBUFJCnlexSyTBdFkRZDhVrzIjqU8T82jLuGfADodGvOxxBlFWCxqeh+oQAiDRVTuunqpT8n2irzd0o7wPjYTA+/asPgO6fuVQQwHR6WHi2XmW7kSe4pcCW+unB5Q/p27vw7WWX7sEo5s8snphUx1myyfcdHJW4eo8vk0PicpGo5rz4jZ0zrT6gYM8VNiC3l46R/L9e4XPfbZvpTNlllZq/26OiJuDg07D60GzAlp0qwOXnJamHrsFbtlmjxjusYOokBWxXvKhxDEo7yEYDj6Eye0QO1lHVj4rgIT8jKnjoWnwjX8cvULE9yKv2c9IDWiEfGDBqBWNR2gYWyY8aXRzVRbnbk+vF7gcZ6XcSJ2t9Si65ZL+mopq6vlvHEZNJZect52BvQYQSxj2AANFFjWpsdwxGdzt4l+nRc53ZoqZNMnLUOTfNxIJORC9uQ1ycmXArDO+z9i3AIvzo1iXhRvadfne7M9wH3GiU2bxr9uWNBtlR1IyM+1+Q7t+yzJWb2tNoW/JP3tcfpo/quIBG7knvoMNQP4rdQCGQtnD+yIMcVPcSJwSJtwXVpxMKwGKtZzE81PnVrZT+nMGdHyB7Zp9lU+7VQ22eprC2QnDVx5z5CeRg/vhyLFKHvHZelr+xfk+CMPYjks6QT1of1EIal1QOYM8MRHagOEr12PfPCCJ0sjik4PC+Ex19V
 aJ0mzhFX
 lYgLrA9JCTbYXudSD9lUb9RPf5J6nI3uxhMzr4eA5bD4gHhWtLyQsrYRg1hyUT7EhftRpQxVK0g8+hjlaJBMh10SrxaM3V/t1fFEPqd7xy8VJKyF5gWwIl/HaX34lz9jZHYq0PHTyiRRz5HT7aPag0GGCfA0ZmbTIh+4n31XRB2fNHhtI06J98srRuQXMeMGogpDF9rn3oHUPTgvZey2a+/5POPuFhjseLWNQDevJR6NCSSR5JhoODl58KOVsks4q8aVkFZpgThBkliE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, thanks for your comments

On 8/28/2026 11:58 PM, Yang Shi wrote:
>>
>> [1]  - arm64 kernel text replication
>> [2]  - x86 NUMA-aware kernel replication
>> [3]  - x86 kernel text replication
>> [4]  - NUMA replication of user data
>> [5]  - Mitosis: Transparently Self-Replicating Page-Tables for
>> Large-Memory Machines
>> [6]  - WASP: Workload-Aware Self-Replicating Page-Tables for NUMA Servers
>> [7]  - PaCaR: Improved Buffered I/O Locality on NUMA Systems with Page
>> Cache Replication
>> [8]  - Memory page replication for Linux on X86 processors
>> [12] - Optimize this_cpu_*() ops for non-x86 (ARM64 for this series)
>>
>> As of today, none of it was merged into mainline.
>>
>> Patch set description:
>>
>> This patchset implements initial support of the kernel
>> text and ro-data replication for arm64 platform.
>> Linux-next was used as a baseline.
>> (903c1cf6dff9 Add linux-next specific files for 20260821).
>> This patch set heavily relies on our previous submission [2],
>> their generic part is the same, these solutions might be merged into a
>> single one.
>> However, after thorough re-evaluation, we were not able to observe
>> performance improvement for the x86 platform, so we have decided to
>> stop this
>> direction and switch on arm64.
>>
>> Current implementation supports the next functionality:
>>
>> 1. Replicated kernel text and rodata per NUMA node
>> 2. Vmalloc is able to work with replicated areas, so
>>     kernel modules text and rodata are also replicated during
>>     modules loading stage.
>> 3. KPROBES, KGDB and all functionality that depends on
>>     kernel text patching work without any limitation.
>> 4. KPTI, KASLR, and KASAN are supported.
>> 5. Only part of a translation table related to
>>     replicated text and rodata is replicated
>>     (up to 2 pgd entries if kaslr is enabled)
>> 6. 4K + 48bit and 64K + 48/52bit are supported and tested.
>
> I think 16K + 47 VA bits should work too. I guess it is because there
> are just 2 top level entries with 16K + 48 VA bits. That requires some
> extra effort to sync up kernel page tables.
>

You are right, it should work with 16K + 47VA.
I did not test it on real hardware, so decided not to mention it here.

>> Known problems:
>>
>> 1. Other combinations of base page size and va size (especially with
>> 16K pages)
>>     should be adapted and verified.
>> 2. Replicated translation tables for the vmalloc region are not local
>> right now.
>>     Allocation performed with default memory policy, so translation
>> tables
>>     for kernel modules will not be local. However,
>>     replicated text and rodata of the modules are local.
>>     In general, vmalloc patch should be cleaned up.
>> 3. Any modifications of kernel PGD level. These modifications
>>     should be synchronized across all replicated tables.
>>     Right now, for example, memory hotplug/hotunplug
>>     lacks this support, vmemmap and kasan regions for
>>     added memory might not be observed correctly. This could be fixed
>>     by patching all places in the kernel where swapper_pg_dir
>>     is modified, or by "lazy" propagation on kernel faults in the
>> pgd-level.
>>     Propagation approach will not help in the case of pgd_clear()
>>     on swapper_pg_dir though.
>
> My percpu patchset (I saw you mentioned it above) already had these
> problems solved. I have not looked into too much detail yet, but it
> seems like you have replicate kernel page tables per node. My patchset
> added percpu kernel page tables. It should be able to support kernel
> text replication as well without too much extra effort. And it can
> support multiple usecases, for example, this_cpu optimization
> implemented in my series, kernel text replication and some potential
> security features. Multiple usecases should be able to make it more
> attractive and convincing. So as Christopher suggested it may be better
> to combine the effort.
>

I am going to check details of your patch set in the following week.
Preliminary - it can be reused for text replication, so yes,
I think it is better to combine our efforts.
The core problems of having replicated pgd are the same
for both per-cpu and per-node table cases.
Management of translation tables might become more complicated,
if both types are used (per-cpu and per-node).
But I do not think it will be a problem for kernel text and rodata replication.

>>
>> Overall, this patch set in an early PoC stage and require some
>> improvements.
>>
>> Overhead:
>>
>> Memory overhead for the kernel itself is about 30MB per NUMA node
>>    on our deployment. For kernel modules - depends on their sizes, but
>> text
>>    and ro-data are not that big.
>> CPU overhead - replication performed on the boot stage. After boot
>>    only "rare" operations are slowed down -
>>    module loading, text patching, kernel table pgd-level modifications.
>>
>> Performance evaluation:
>>
>> Our local testing was performed on
>> Kunpeng 920, 128 CPU, 4 nodes, 100Gb for each node.
>>
>> Microbenchmark:
>> Kernel module with a huge text section (~50MB) filled with CPU-bound
>> instructions. For each NUMA node thread is spawned, each thread in a loop
>> executes isntructions. Total execution time of each thread is measured.
>> The insmod call bound to node 0 through numactl (less time is better).
>>
>> node                 0        1        2        3
>> Before time, s     5.567    7.598   13.294   18.905
>> After  time, s     5.469    6.960    6.777    5.531
>>
>> Diff               ~0%      -8.5%    -49%     -70%
>> In this benchmark, interconnect was not used by any other actors,
>> so microbenchmark numbers might be significantly improved.
>>
>> Customer's evaluation:
>> We were provided with the following feedback on this patch set
>> directly from our customers. Unfortunately, we do not have details
>> regarding how these measurements were done other than it was
>> a production setup.
>> Evaulation was performed on Kunpeng 920 and 920B platforms:
>> CEPH distributed storage +5%
>> StarRocksDB              +5%
>>
>> Couple more words about patch set and technology:
>>
>> This patchset was merged into the innovative branch of
>> the openEuler distributive 1.5 year ago (openEuler-25.03)
>> and was actively tested in production environment [9], [10].
>> In addition, besides the kernel part, we have published
>> user space replication (for translation tables and rodata) as well,
>> but it is very complex and experimental
>> even compared to this patch set [11]. With replication in user
>> space, we were able to achieve the following numbers in
>> performance improvement:
>> MySQL + sysbench      1-6%
>> Spark TPC-H           4-20%
>> Phoronix test-suite   0-25%
>
> Thank you for sharing the performance data. Does the SUT with 4 nodes
> have 4 real sockets? Nowadays the CPU design is moving to multiple
> chiplets. Subnuma configuration may be more and more popular in the
> future, so we thought kernel text replication can help performance for
> more usecases other than multi sockets machines.
>
> Thanks,
> Yang
>

Our test machine has two physical sockets.
Each socket consists of two dies, 4 NUMA nodes in total.

We will start developing v2 on top of your patch set,
and share it when it is done. If you think we should do it differently,
please let us know.

Thanks again for taking the time to reply.

BR
Nikita Panov

