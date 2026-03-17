Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56733F33817
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A179D6B0088; Tue, 17 Mar 2026 04:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C8EF6B0089; Tue, 17 Mar 2026 04:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B71C6B008A; Tue, 17 Mar 2026 04:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73DFF6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:47:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 373501B8372
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:47:19 +0000 (UTC)
X-FDA: 84554925798.26.DD5A7D2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 14D26C000C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:47:16 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773737237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cd2F7Hk1OURvkqwK1ohsIIIgc/2WwPbAN3vBqpJw9uU=;
	b=3fc5Ty/TsEfem5rtc5AAiIFHrFyHxDUUhWeiiqp+MS2SeAcFuyBFtCwWh6RSf3LsNeNzc+
	0+gWSEZ9yjhX4swzmtxuU2sCEDyWwEpg114xlEU8dodey98pQGF1DQjcCn9gbkzhyeFnQV
	DzZwCBIwzOSqjPK2AqUnEE7j8SWWkDQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773737237; a=rsa-sha256;
	cv=none;
	b=X91wMqu/oT9mCBAbPhBHV7+ZNMyN1ZY884OYt4zakqtBj9S9lKYxbpUOhNEt/QkHS51ctv
	d4kj99FNDclYDfCxnsMZNZVcmoyX51jAwi2nVDjuHNdos/Q2z0Ed1Z9s9vA10Oj3xZYueL
	+ziyws2FX3VbqF4pE6Z2HSWMmHhoU7k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C143C1476;
	Tue, 17 Mar 2026 01:47:09 -0700 (PDT)
Received: from [10.57.60.143] (unknown [10.57.60.143])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 477013F7BD;
	Tue, 17 Mar 2026 01:47:12 -0700 (PDT)
Message-ID: <4ad2ea40-b23b-4231-a0de-585b205865c5@arm.com>
Date: Tue, 17 Mar 2026 09:47:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Yang Shi <yang@os.amperecomputing.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Jinjiang Tu <tujinjiang@huawei.com>,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <0b2a4ae5-fc51-4d77-b177-b2e9db74f11d@huawei.com>
 <de0b06cf-15a5-4109-b339-75c10d9b8a18@arm.com>
 <0a740020-4780-4156-a9c5-f8b4ada9c8c0@os.amperecomputing.com>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <0a740020-4780-4156-a9c5-f8b4ada9c8c0@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 14D26C000C
X-Stat-Signature: 6u599fmid38yzk9xrngrnqdtm6nzfh4b
X-HE-Tag: 1773737236-465243
X-HE-Meta: U2FsdGVkX1/DmESPqcXBOLnkMJI7lYCwuEifqQwjzMMOT5Ghqr09nPjVAKeIOBRdZFQw/VN7bRMBzZL6jJ676IqNH0O524tq3uljpBIBvxTQy6JU/ltwqNGOOOpRAhPMXn0c9JMwCfiqKy2qJDdkQmhK1QvXWHOZyBHjda9WaKOof7QBEDChu5WZNRGSUZeVST1Pal93KirfVWntoJO0UUpB5h25cQPg8JUwbOBj4rHGg+W+YtZdQRjbYHClOVlgreHrQlIySC+XXBGm3Td0PtEsqNuVoZIr6FRKjZbuCnjdHo/uBAcoyRCen3Pr2gjXw/MGJiIPLZMYCWanO081QXG/ajx7zJ7XvytzEXdVnHvyb9uA5840ZDGDq0q4RwiDNLOMOOgRAhzdXlrUFUqJ1ECmqJe5qsHmFIHL3biA1m3z9c4wKunyVLrJPnXmfK0ALzBYLSgkaIi/vsmxKc/spWAZ0vgh8f9RbxzA1NqE+OL0qCjV6Jt8CgvTyugkLXioEI5LzprfxmEoouT1/z24It1bpRrjDFMfdLsXEgXM9EaXJnmv4DxKpOZdaxmCbuBdHAWdXDeNC714csYRgH98PBkJ2l2gOQpuhrus46LGUGntP1z9KMoF3RxVNqY7T/0z+XBt8LutraDjTO2IIv4yevgHO3v3lH3Nq7MntDtJO7wgICv3tI1bpwyi9V1AInZgWp2Hk5r5MricC2DjUi2fQ8m3khE74Erts0tn9vsfNSPT1a5f9ql1P8q9iZFHLzzRGQoUZzauVgudWZXGNGolLeuaeP1UwEBpZFx7RQud18NhszYzYrfzta+ifowOWko4Hlvv4Fmkrk8HpLMdcmApxq8TdscXZQxayRgD3XzyBSMQz3YUGQyzVtVSdUMn+YcymlJ9OmqGE2b/CTxf4n5MI3tLuGM/0q5RyOK2M2mbfQDkzdvEjIa3n6ikqv7qhbQOrsbqMDnALW7JiMqI676
 zx++xVNC
 0UF4t5XNgThdVa1Lcu4/iECACzFoWd2iGBNbBbY2QZNfhnmSk6sPf6/1IFwWaTxroytsjUP6DCrCJXZ5ew+/M3nrg8ccZ/wYX/vqK1bHrR2KAjUrbXpSJpLHmA6qDBv5WQxNALKRTPDvWzhJ3Lg7l3oBaz8BBNblw3fP5wFNG6BlPZ+9U2klNsO4mN94Ad20+Xw42HWJljCylYDuyIfl2vNCgReh04mzdi0wiTvbco+lA8513m+pONwzbv/DhhXvtxsmILEtj5QacIPWtWIk+gt8MsK/gNRMXpKn7LSosb2sKkTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/03/2026 01:15, Yang Shi wrote:
>
>
> On 3/16/26 8:47 AM, Ryan Roberts wrote:
>> Thanks for the report!
>>
>> + Kevin, who was looking at some adjacent issues and may have some
>> ideas for how
>> to fix.

Indeed, specifically to protect page table pages (PTPs) by mapping them
with a privileged pkey. pagetable_alloc() is called on several occasions
before all secondaries are up (including from init_IRQ() in fact), but
we cannot call set_memory_pkey() at that point for the same reason that
Jinjiang pointed out.

The approach I went for is to allocate a whole block on boot and defer
the call to set_memory_pkey() until it's safe to do so [1]. It's not a
particularly nice solution as this restricts the number of PTPs we can
allocate in that window, especially if more of them get allocated when
set_memory_decrypted() splits the linear map.

[1]
https://lore.kernel.org/linux-hardening/20260227175518.3728055-17-kevin.brodsky@arm.com/

>>
>>
>> On 16/03/2026 07:35, Jinjiang Tu wrote:
>>> 在 2025/9/18 3:02, Yang Shi 写道:
>>>> On systems with BBML2_NOABORT support, it causes the linear map to
>>>> be mapped
>>>> with large blocks, even when rodata=full, and leads to some nice
>>>> performance
>>>> improvements.
>>> Hi,
>
> Hi Jinjiang,
>
> Thanks for reporting the problem.
>
>>>
>>> I find this feature is incompatible with realm. The calltrace is as
>>> follows:
>>>
>>> [    0.000000][    T0] ------------[ cut here ]------------
>>> [    0.000000][    T0] WARNING: CPU: 0 PID: 0 at
>>> arch/arm64/mm/pageattr.c:56
>>> pageattr_pmd_entry+0x60/0x78
>>> [    0.000000][    T0] Modules linked in:
>>> [    0.000000][    T0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted
>>> 6.6.0 #16
>>> [    0.000000][    T0] Hardware name: linux,dummy-virt (DT)
>>> [    0.000000][    T0] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO
>>> -DIT -SSBS
>>> BTYPE=--)
>>> [    0.000000][    T0] pc : pageattr_pmd_entry+0x60/0x78
>>> [    0.000000][    T0] lr : walk_pmd_range.isra.0+0x170/0x1f0
>>> [    0.000000][    T0] sp : ffffcb90a0f337d0
>>> [    0.000000][    T0] x29: ffffcb90a0f337d0 x28: 0000000000000000 x27:
>>> ffff0000035e0000
>>> [    0.000000][    T0] x26: ffffcb90a0f338f8 x25: ffff00001fff60d0 x24:
>>> ffff0000035d0000
>>> [    0.000000][    T0] x23: 0400000000000001 x22: 0c00000000000001 x21:
>>> ffff0000035dffff
>>> [    0.000000][    T0] x20: ffffcb909fe3b7f0 x19: ffff0000035e0000 x18:
>>> ffffffffffffffff
>>> [    0.000000][    T0] x17: 7220303030303178 x16: 307e303030306435 x15:
>>> ffffcb90a0f334c8
>>> [    0.000000][    T0] x14: 0000000000000000 x13: 205d305420202020 x12:
>>> 5b5d303030303030
>>> [    0.000000][    T0] x11: 00000000ffff7fff x10: 00000000ffff7fff x9 :
>>> ffffcb909f1e27d8
>>> [    0.000000][    T0] x8 : 00000000000bffe8 x7 : c0000000ffff7fff x6 :
>>> 0000000000000001
>>> [    0.000000][    T0] x5 : 0000000000000001 x4 : 0078000083400705 x3 :
>>> ffffcb90a0f338f8
>>> [    0.000000][    T0] x2 : 0000000000010000 x1 : ffff0000035d0000 x0 :
>>> ffff00001fff60d0
>>> [    0.000000][    T0] Call trace:
>>> [    0.000000][    T0]  pageattr_pmd_entry+0x60/0x78
>>> [    0.000000][    T0]  walk_pud_range+0x124/0x190
>>> [    0.000000][    T0]  walk_pgd_range+0x158/0x1b0
>>> [    0.000000][    T0]  walk_kernel_page_table_range_lockless+0x58/0x98
>>> [    0.000000][    T0]  update_range_prot+0xb8/0x108
>>> [    0.000000][    T0]  __change_memory_common+0x30/0x1a8
>>> [    0.000000][    T0]  __set_memory_enc_dec.part.0+0x170/0x260
>>> [    0.000000][    T0]  realm_set_memory_decrypted+0x6c/0xb0
>>> [    0.000000][    T0]  set_memory_decrypted+0x38/0x58
>>> [    0.000000][    T0]  its_alloc_pages_node+0xc4/0x140
>>> [    0.000000][    T0]  its_probe_one+0xbc/0x3c0
>>> [    0.000000][    T0]  its_of_probe.isra.0+0x130/0x220
>>> [    0.000000][    T0]  its_init+0x160/0x2f8
>>> [    0.000000][    T0]  gic_init_bases+0x1fc/0x318
>>> [    0.000000][    T0]  gic_of_init+0x2a0/0x300
>>> [    0.000000][    T0]  of_irq_init+0x238/0x4b8
>>> [    0.000000][    T0]  irqchip_init+0x20/0x50
>>> [    0.000000][    T0]  init_IRQ+0x1c/0x100
>>> [    0.000000][    T0]  start_kernel+0x1ec/0x4f0
>>> [    0.000000][    T0]  __primary_switched+0xbc/0xd0
>>> [    0.000000][    T0] ---[ end trace 0000000000000000 ]---
>>> [    0.000000][    T0] ------------[ cut here ]------------
>>> [    0.000000][    T0] Failed to decrypt memory, 16 pages will be
>>> leaked
>>>
>>> realm feature relies on rodata=full to dynamically update kernel
>>> page table prot.
>>>
>>> In init_IRQ(), realm_set_memory_decrypted() is called to update
>>> kernel page
>>> table prot.
>>> At this time, secondary cpus aren't booted, BBML2 noabort feature isn't
>>> initializated,
>>> and system_supports_bbml2_noabort() still returns false. As a result,
>>> split_kernel_leaf_mapping() is skipped, leading to
>>> WARN_ON_ONCE((next - addr) !=
>>> PMD_SIZE)
>>> in pageattr_pmd_entry().
>> If no secondary cpus are yet running, then it is technically safe to
>> split
>> because we know all online cpus (i.e. just the boot cpu) supports
>> BBML2_NOABORT.
>> So we could explicitly only disallow splitting during the window
>> between booting
>> secondary cpus and finalizing the system caps. Feels a bit hacky
>> though...
>
> I think we can check whether system feature has been finalized or not.
> If it has not been finalized yet, we just need to check whether the
> current cpu (should be just boot cpu) supports BBML2_NOABORT or not.
> It sounds ok to me.

That assumes that no secondary has booted yet, otherwise we cannot
safely split live mappings without knowing that all CPUs support
BBML2-noabort. It might work for this particular case, but it is
fragile. It wouldn't help for the page table protection case, as PTPs
get allocated while secondaries are booting up (e.g. stack allocation
when forking kthreadd).

>
>>
>>> Before setup_system_features(), we don't know if all cpus support
>>> BBML2 noabort,
>>> and we
>>> couldn't split kernel page table, in case another cpu that doesn't
>>> support BBML2
>>> noabort
>>> is running.
>>>
>>> How could we fix this issue?
>>>
>>> 1. force pte mapping if realm feature is enabled? Although
>>> force_pte_mapping()
>>> return true if is_realm_world() return true, arm64_rsi_init() is
>>> called after
>>> map_mem(). So is_realm_world() still return false during map_mem().
>>> Thus
>>> realm feature relies on rodata=full. If we fix by this solution, we
>>> need
>>> to add a new cmdline to force pte mapping.
>
> I don't quite get why is_realm_world() relies on rodata=full. I
> understand realm needs PTE mapping if BBML2_NOABORT is not supported.
> But it doesn't mean real relies on rodata=full.
>
>> I think we just need to make is_realm_world() work earlier in boot? I
>> think this
>> has been a known issue for a while. Not sure if there is any plan to
>> fix it
>> though.
>>
>>> 2. If we could try to split kernel page table before
>>> setup_system_features()?
>> Another option would be to initially map by pte then collapse to
>> block mappings
>> once we have determined that all cpus support BBML2_NOABORT. We
>> originally opted
>> not to do that because it's a tax on symetric systems. But we could
>> throw in the
>> towel if it's the least bad solution we can come up with for solving
>> this. I
>> think it might help some of Kevin's use cases too?
>
> May be an option too. When we discussed this there was no usecase for
> direct mapping collapse. But if we can have multiple usecases, it may
> be worth it. AFAICT, the ROX execmem cache may need this, which Will
> or someone else from Google is going to work on.

Not sure about the execmem cache (do we call execmem_alloc() before
secondaries are up?), but I think that would indeed solve the issue for
the page table protection use-case. Besides in terms of complexity it's
probably not much worse than what we currently have, i.e. basically the
reverse (splitting the linear map if some CPU doesn't have
BBML2-noabort). Penalising symmetric systems is not great, though.

- Kevin

>
> Checking current cpu BBML2_NOABORT capability before system feature is
> finalized seems like a fast way to stop bleeding IMHO before we find
> more elegant long-term solution.
>
> Thanks,
> Yang
>
>> [...]

