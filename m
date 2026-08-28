Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43630C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:15:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4350E6B008A; Fri, 28 Aug 2026 09:15:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E54F6B0095; Fri, 28 Aug 2026 09:15:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB616B0096; Fri, 28 Aug 2026 09:15:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07F596B008A
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:15:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8F99E140394
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:15:38 +0000 (UTC)
X-FDA: 85150725156.11.DCACEEA
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id CA14140003
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:15:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5ot1gR7U;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787922936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aOKzH9R7+xHaU6WtcnY691Gb/8RWKAMf5Z48aJbOcPA=;
	b=5cacTiL4A04fAnnLczKBQOrE4nj0RQjPMwyiUeDtAz5Jhtg5eTBqrpiv/qPV5MajhCowSq
	BtPxrJYwiR9YZ+vKGhBgbJz4CUfg2Zvn648B1Q4nUJrLfPX0yeuuuIGZJ3MBjFSLHCeC8r
	C937G8yai+cPlZZtNe3tEfcY8Dlq6bc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=5ot1gR7U;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of panov.nikita@huawei.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=panov.nikita@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787922936;
	b=AzkeJ/mZ445E3rgQ0aDRwiT7pHlg7foYVirSytjvIRdt9H4T9XzIjgHSrdHPkT51LtWiJa
	f3AjrWoUij/JQHTP9wq/Yj86798Gga1qufVvX09vMJlzP3KY4+KL1o09k8VZOmtXLzz5bk
	S/yd7EJTvOqm4vO6KsTiAvdkB4cDTl8=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aOKzH9R7+xHaU6WtcnY691Gb/8RWKAMf5Z48aJbOcPA=;
	b=5ot1gR7UBRvytIrHIJTJwcwlyNH6oEGq1klmsi+NnNVLj5VVie7tg24vijgQhzGMG6zeuAd/J
	rr32aOw0eedgDFXQRFrozF/Ky+bCH/U/njmG8q3KTU3sMBIMaUqLvNiytcPLp4fXjWbDV3CSn/y
	yUfjcYf+wJBW4kOS0ghWqWs=
Received: from mail.maildlp.com (unknown [172.18.224.150])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hWf4t2fhyzJ46cl;
	Fri, 28 Aug 2026 21:15:10 +0800 (CST)
Received: from mscpeml500004.china.huawei.com (unknown [7.188.26.250])
	by mail.maildlp.com (Postfix) with ESMTPS id 5A80340570;
	Fri, 28 Aug 2026 21:15:33 +0800 (CST)
Received: from mscphis00949.huawei.com (10.123.66.11) by
 mscpeml500004.china.huawei.com (7.188.26.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 28 Aug 2026 16:15:32 +0300
From: Nikita Panov <panov.nikita@huawei.com>
To: <ljs@kernel.org>
CC: <akpm@linux-foundation.org>, <artem.kuzin@huawei.com>,
	<catalin.marinas@arm.com>, <cl@gentwo.org>, <david@kernel.org>,
	<liam@infradead.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux@armlinux.org.uk>, <mark.rutland@arm.com>, <mhocko@suse.com>,
	<panov.nikita@huawei.com>, <rppt@kernel.org>, <surenb@google.com>,
	<vbabka@kernel.org>, <wangkefeng.wang@huawei.com>, <will@kernel.org>
Subject: Re: [RFC PATCH 00/18] mm: arm64: Add kernel replication feature
Date: Fri, 28 Aug 2026 21:03:01 +0800
Message-ID: <20260828130301.135023-1-panov.nikita@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <apBqjq24aG_s2ZTM@gremlin>
References: <apBqjq24aG_s2ZTM@gremlin>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.123.66.11]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500004.china.huawei.com (7.188.26.250)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: CA14140003
X-Stat-Signature: fksu6zptdtptner4zc1yajen1hj4bfbk
X-Rspam-User: 
X-HE-Tag: 1787922935-527551
X-HE-Meta: U2FsdGVkX18rMrPW8XxkOvlsvoWRnaHdYXIn7cx9N7qvMBivF2jRCjSVmQ+sAByJTCJSk8hhIbyG35upDH4dIwV2cXotYi/uo7f6NAPw28D8p4j16x4ctkoANUYi3xkoELWsKyQijXDUj7Eid6r9IEU97EHhqrr3/uwz6Z5Vleu8sseaEnsHblGgr44NiPOSpJIRwRsAsBtK2+BMx89HfG8KuiPu52EGmbiyENNBm03/zYh9RASdJ86msCnIkIbQs+yMt/MyYnmaqLTyfHL8jGxph1ZeNF30YE0xQswUnpO9vaTWgnvgunuUlJg/0m+40OlwKMS34VIQ+Cp+2+6inHqChwcFZoI0mIglmyk7o7gy8PA3ov+LbhD9gzi+O7JKZgBUDHipfy8yimIwqBgipoaml7hydMenDXbLe6zULes1/zfcV1kavqq44h2q/OcyXuDfZQbDz0tWjsK7yeTO6xaSamivwq6MWzX8/1SHNE3gqsfZ4gyVF/0/Qp1YufMVmVZVopChWznJpODAx7lh9eiS6JIw+A3B+GLJKyFJxoJA3y3EZBMzhCfKlpVUT+mdkKquLE5uxEoqXy9HPqaf2hD31h1JmGORAvHFV8UBFZu2LKCHsprzDhsl2emH/E4v99YBv8ry/fSjXdKA9ViF4mXUFnVS93xFk6pERm4T2ZQQu6FqCVQ9UrwyfeR0Gy3fyvoSbsOGpdrMxp8SQSYSiLH5rmTCrosxFjvrOG9K0nAU750fyKxWlaXwZaESgyRca1ScA7Sf2C6Ng+5MXwthMypcHG2/4kljd1gdCfIXlyNP81VqfBik4RO3HWvSl7fp0b6SwGAbrovA+ovdfsnHrshVV30DNE8cnvBXVnYJx+YHMpzcDu0h/zd/I1PhuFX8oaPSicKMbZTaR0xmMABUDubsmAyPA5BxMSJEICvRp15EF4l1JTTwJSo/NAY2DtN974Ynb3Icp4Q0C153LEc
 B6h41aVT
 vvhmv5t22zw7CuSVndZ2+IcQNcrNgqZl2rFuiwubRxr+/GaotysMQHjFmMo8RcXdvBSBoK4BzvYmy6g/eq0k3HEK4xDMbuq+I1m0va3ny5sfGOBUrXdMwNnmSXveWC+Qm2lJuUFmjAXCSGCDk0/Robo49Q4fCj57qCbHlMPj5cHQ85r4+vD15qflQ3i03GpFUxU/DgSedXRbp4HuHfzQym0bUobs4Pr3MggO7HKJbhF0EM8VsmsadixIY+EHM6pJHEL6vQXqS98aIF7E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello, thanks a lot for your comments.

On 8/27/2026 8:25 PM, Lorenzo Stoakes (ARM) wrote:
> Hi,
>
> On Fri, Aug 28, 2026 at 12:11:40AM +0800, Nikita Panov wrote:
>>
>> As of today, none of it was merged into mainline.
>
> I mean :) maybe take that as a hint? If a number of series trying to do X get
> rejected by upstream, that is maybe suggestive of barking up the wrong tree?
>

Patch sets related to NUMA text replication were not explicitly rejected before
(I might be missing something here). The main goal of this resubmissions - gather
feedback, whether *something* related to replicated kernel text, rodata
and translation tables should be even added to core mm. And should be more time
invested into this concept, or better leave it.

>> However, after thorough re-evaluation, we were not able to observe
>> performance improvement for the x86 platform, so we have decided to stop this
>> direction and switch on arm64.
>
> I mean, why? You should provide details here, this is quite hand-wavey.

For testing on x86 architecture, we had only an old machine,
with 2 NUMA nodes, Intel(R) Xeon(R) CPU E5-2690, 192G per node,
24 physical cores total. Interconnect on this machine is better,
than on Arm servers that are available to us, in both latency and bandwidth.
In addition, the x86 patch set introduces overhead to the user space,
since the pgd table is shared between user and kernel space, any
modification of user pgd entry should be immediately propagated
(handle_mm_fault() or free_pgd_range()).
That is the main reasoning why we focused on arm64.

> You are
> also proposing core mm changes for something that seems specific to unique
> hardware as far as I can tell, which is a big ask.

This technique is applicable for all NUMA platforms on aarch64 architecture.

>> 3. Any modifications of kernel PGD level. These modifications
>>     should be synchronized across all replicated tables.
>>     Right now, for example, memory hotplug/hotunplug
>>     lacks this support, vmemmap and kasan regions for
>>     added memory might not be observed correctly. This could be fixed
>>     by patching all places in the kernel where swapper_pg_dir
>>     is modified, or by "lazy" propagation on kernel faults in the pgd-level.
>>     Propagation approach will not help in the case of pgd_clear()
>>     on swapper_pg_dir though.
>
> Yeah OK this suggests to me you've got the locking and synchronisation all wrong
> and it's worrying :)
>
> In general I really oppose anything that adds additional kernel page tables or
> complicates kernel page table handling.
>
> We already have singificant complexity and bugs/races emerging from people doing
> odd things with kernel page tables on assumption that it's 'safe'.
>
> You'll need very compelling evidence to justify anything that touches such
> sensitive stuff.
>
> The code is also fiddling with PGD assignment in a way that could interact badly
> with how these PGDs are synchronised. These things are very subtle, and even if
> it's limited to one arch the core mm code is not.
>

Agree, interactions with PGD should be fixed.

>>
>> Overall, this patch set in an early PoC stage and require some improvements.
>>
>> Overhead:
>>
>> Memory overhead for the kernel itself is about 30MB per NUMA node
>>    on our deployment. For kernel modules - depends on their sizes, but text
>>    and ro-data are not that big.
>> CPU overhead - replication performed on the boot stage. After boot
>>    only "rare" operations are slowed down -
>>    module loading, text patching, kernel table pgd-level modifications.
>
> Hmm. I wonder if they're as rare as you think though? It all depends also on how
> slowed down they are, how that manifests, etc.
>

The rarity of these operations heavily depends on the workload. If someone
is loading/unloading some kernel module or actively tracing something
through kprobes (inserts new and removes old), or enables/disables
ftrace events, these operations are quite often. I am not sure that this is
a valid scenario for an enterprise server. Tracing itself might be running,
but I am not sure about constant reconfiguration.
Exact overhead should be measured, I agree.

>>
>> Microbenchmark:
>> Kernel module with a huge text section (~50MB) filled with CPU-bound
>> instructions. For each NUMA node thread is spawned, each thread in a loop
>> executes isntructions. Total execution time of each thread is measured.
>> The insmod call bound to node 0 through numactl (less time is better).
>
> So wait, you bound it to node 0, then rely on kernel text replication to improve
> performance due to a bad hint?
>
> That seems like you could fix the issue by binding correctly? :)
>
>>
>> node                 0        1        2        3
>> Before time, s     5.567    7.598   13.294   18.905
>> After  time, s     5.469    6.960    6.777    5.531
>>
>> Diff               ~0%      -8.5%    -49%     -70%
>> In this benchmark, interconnect was not used by any other actors,
>> so microbenchmark numbers might be significantly improved.
>
> This benchmark seems entirely synthetic and it seems odd to me, prima facie, to
> implement a feature to correct for incorrect NUMA binding?
>
> Maybe I'm missing something though.
>

You are right, this microbenchmark is absolutely synthetic and was implemented
to verify that replication is working and to test its *maximum*
potential for the kernel text.
Kernel image with its text and rodata loaded
entirely on a single NUMA node, its memory physically continuous,
there is no way to control this.
For kernel modules, mempolicy could be used, but still, text and rodata
will be either bound to a specific NUMA node, or interleaved between them.

>>
>> Customer's evaluation:
>> We were provided with the following feedback on this patch set
>> directly from our customers. Unfortunately, we do not have details
>> regarding how these measurements were done other than it was
>> a production setup.
>> Evaulation was performed on Kunpeng 920 and 920B platforms:
>> CEPH distributed storage +5%
>> StarRocksDB              +5%
>
> This isn't hugely encouraging.
>

I agree, numbers are not great, but it does not *affect* execution of
applications. MM for user space was not modified at all, I think, that
database application will not set kprobes or load kernel modules (at least
perform this other than on its startup). Any introduced overhead should not
affect normal enterprise applications. Memory overhead is also insignificant,
for servers with hundreds of GB.

>
> Annnd :) this:
>
> 	if (rwsem_is_locked(&mm->mmap_lock))
> 		locked = true;
> 	else
> 		mmap_read_lock(mm);
>
> is just utterly, utterly broken.
>
> rwsem_is_locked() can be raced at any time, you don't own the lock so it can
> just be unlocked underneath you.
>

Completely agree, this should be fixed. In general, tables dump mechanism should be
removed, it was added for debug and verification

> Then there's stuff like this:
>
> 		/* TODO: remove last condition and do something better
> 		 * In the case of a folded P4D level, pgd_none and pgd_huge
> 		 * always return 0, so we might start to replicate empty entries.
> 		 * We obviously want to avoid this, so the last check is performed here.
> 		 */
> 		if (pgd_none(*orig_pgd) || pgd_val(*orig_pgd) == 0)
> 			goto skip;
>
> This whole block seems confused, and it's nitty but you're using completely
> incorrect comment style for the linux kernel which again doesn't fill me with
> confidence that you've really thought things through or understand mm code
> correctly.
>
> Your replicate_memory() function seems to not synchronise _at all_, but you do
> for some reason synchronise on dumping memory, bizarely.

Comment style should be fixed.
For the kernel text, this function is called
prior to secondary CPU startup in start_kernel().
For the kernel rodata, this function is called in kernel_init(),
right after mark_readonly().
From my understanding, in both these cases additional synchronization
is not required.
Please point if I am missing something.

>
> You write a ton of duplicative page table code that doesn't seem to handle huge
> pages at all, again doesn't seem to be performing any locking correctly at all,
> and yeah the list goes on.
>

Code that replicates translation tables supports huge pages for the PMD level.
PUD-level hugepages are not supported yet, but for the kernel text and rodata
PUD hugepages are not used for the mapping (at least on Aarch64 and x86).
4K page size - kernel is mapped using PMD hugepages, 2MB each.
64K page size - normal pages with CONT_PTE_BIT.
This code is also executed prior to the secondary CPU boot.
I agree that implementation is very far from ideal, and there are a lot ways
to improve it, for example, the table's replication mechanism
should be implemented through walk_kernel_page_table_range().

> In general the code looks like an alpha experimental thing and a million miles
> away from anything even vaguely upstreamable.

Agree.

> So overall it seems to me that perhaps better NUMA policy decisions could
> solve your problems.
>

As I mentioned, policies might help only for the kernel modules, but not for
kernel text and rodata itself.
Perhaps some mechinsm similiar to NUMA balancer can be implemented
for the kernel text and rodata mappings, but I think it will be even more
complex and intrusive. Plus, in that case, memory will not be physically
continuous anymore which will definitely affect TLB performance,
in case of huge_pmd split.

> But yeah, what's presented in this series doesn't seem like a worthwhile
> road to travel down to me.
>
> --
> Cheers, Lorenzo

Ok, thanks for clarifying your position.


Thanks again for taking time to review.

BR
Nikita Panov

