Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D91CFFB5EA6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 02:07:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D92336B0005; Mon, 16 Mar 2026 22:07:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3C286B0088; Mon, 16 Mar 2026 22:07:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2A486B0089; Mon, 16 Mar 2026 22:07:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8B726B0005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 22:07:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42EBE58EE8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:07:09 +0000 (UTC)
X-FDA: 84553917378.11.29287B3
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3A8CC000C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 02:07:05 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Nc6u0pGa;
	spf=pass (imf28.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773713227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHOnYGGZegr7Ltx5MuxiOw7+0+379phmk7TCvTVSIE4=;
	b=tL21gFi+lUlIkQjeNtQgTjrQtEprNXp0Hfn6BxeFuMdOdJKCWh0GN6o/6ZNA9Tbkk/BIC6
	l49Azx8a50DmFZUE9aClpn9oW0QmwNLVrlXzSCn5K9L1m5HK1+JsRZ4eIrRlq2c08tZFQd
	0mO2nvxunSUN4M1u2QQRoXmRrH9LkSU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Nc6u0pGa;
	spf=pass (imf28.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773713227; a=rsa-sha256;
	cv=none;
	b=8dvHS9iPIOhVYG/aGqKaifzylAyU+5tfy0u8ppnd4zx4clXBUoCbTO9DNYXpYJHgwhP+eL
	mEiDAiEHT+OLn3x7bSoJ8000lMr+vJq6ZM8RR1buwiE5fJ92Mzb0agggjzMZuDxiia9oxj
	C8LCRuzc31xdD4Y35BmqC1cOhwMZhQ0=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=EHOnYGGZegr7Ltx5MuxiOw7+0+379phmk7TCvTVSIE4=;
	b=Nc6u0pGaOq0glX/UTeGP4XPiXklocPwJDW+NVE6Ss1ZrZu/l9iY70YPdgfQmE2SzQh2UKqGOI
	6oZ93TJ7cvQt3n1lLQNWMo2KRq9tGSau/oc7vsV5rhZE/XPWSMOWWrXN9jQLSf/gxt5B1nU97Ld
	xep9obGcB158WcOEdFtPRhc=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4fZZvq3Cyjz1prmF;
	Tue, 17 Mar 2026 10:01:59 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 6B9084056B;
	Tue, 17 Mar 2026 10:07:00 +0800 (CST)
Received: from [10.174.178.9] (10.174.178.9) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 17 Mar
 2026 10:06:59 +0800
Message-ID: <e35ee155-81aa-453a-8197-2c87d923f84c@huawei.com>
Date: Tue, 17 Mar 2026 10:06:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Yang Shi <yang@os.amperecomputing.com>, Ryan Roberts
	<ryan.roberts@arm.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<lorenzo.stoakes@oracle.com>, <ardb@kernel.org>, <dev.jain@arm.com>,
	<scott@os.amperecomputing.com>, <cl@gentwo.org>, Kevin Brodsky
	<kevin.brodsky@arm.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <0b2a4ae5-fc51-4d77-b177-b2e9db74f11d@huawei.com>
 <de0b06cf-15a5-4109-b339-75c10d9b8a18@arm.com>
 <0a740020-4780-4156-a9c5-f8b4ada9c8c0@os.amperecomputing.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <0a740020-4780-4156-a9c5-f8b4ada9c8c0@os.amperecomputing.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.178.9]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: B3A8CC000C
X-Rspamd-Server: rspam07
X-Stat-Signature: 9jjux1z1wzteb3q9putmu5pa5fhuaqty
X-Rspam-User: 
X-HE-Tag: 1773713225-861478
X-HE-Meta: U2FsdGVkX198keiJL7ybCYmxdszWwuhN0ibabFFu3XUHVoDhiNuY+uS+g/4ndl+wyZggLb7pS7Mz3p10+NK89vxZoZfM9QCHrkEevXiNsNmUVCfYCKt4u9h7TzzO+S5zxBgaHz1QbdmXhEvp/TiQgNfx5Oxl957FqagTfRv4FfqA5zQMHSlG4CCaqPrFmqQmRTf1jTtu+g3zefHW3EqP72VYA5p3SsUKWHsAe1+NmzfL1FCwomd1/SvpFleA5GUOmilYTs0ATfDH9YQDMLARKqSr7nwIroQ2Dgxv45qyWJTo5ui9V87HThRud+MShNpDlhWNmmSiIIDupMbhKMdYs/tbIcvDd0nIXUzkW2lrWaeFrBCRgXaIxDAr75c+oEvFn+hYNcJU0mkHLlFdd/SKLZvQZb3fbr3HR726w85jd+4EuxuKG6luhGNoWfQkyEQ5lUKFVr/cCphp7u1O+Z259DqTCnaub/rzgpMPVgcUJXZPavo9IlaEBcopXJi2BFe2mAZgXx06JXa9fVPstVTOSw6PQ4ve43TS3tcZwIwoLF59bGVzQTMBXNTVLJQJroagCsJoiEufVeYsShHUUIsiwiU7G+ioFtYYEdQg0EryDLA+A/2OM11ll6BGv7XKZQl1EK2vvdDVpK/AClxXSnABwkkxC/F36t4kvuyqtNfm1XRoUsJZlEO05M2ir5NlcIaeEimn0LufxVcThh6dwKriUfyfNL76rBkdaPYSF/Y3eD17frUv9vBAI8kLbexoPp0HjUsiWl3L2qQl6PMIyyTQ3yij6B/b82FbmR021pp8bE3jRoCThN8QHTZ0CPpnU/gm/HXIXj4R/M2ff10YqtI9F3xPZfuejrH6a71jS9M7Cu7p/DEqNrjZ6AOYZQzvNv3Ie7RstNeYixt3VJMv5GHyp8CcXQ/IK5T0GIckmqBmSCH4lIpqEMoDZKa7cfTTeb/jjF8A9JUorM9LvjN4+hB
 k3NRMNaV
 zBrq3+3MyXygh7l6ljNw27faMD0xJyyPXQ/3E61VoW5WIQfmZDmQC5Ja+hW8kmgspxu1TiCq1vbxjzXpOH/ukAyjpy6fb0ZdkaRip7MrfbMfVafw4gwJbiZ3S/Ue6lJxm12KrUF+GAutj2cYBlpPDKZDTi2e1ubACcTfi0RISURayV/L2P5lVGXjK3qNOjqxssyRrJyNfi2Ik+QORnA22UKKtnAy99UrUfZtnurD586BcupMP7EpMIisZk8nCWSrlX+aMtGvrRgz0WMVXlZ3PSEpjlSKfOS6eMtKYLxKt+eRO7f6V3KkJkZQmSzbt1ua2bevOrdGUxCd1xCjRP/1/kXyrrhR6IZWdK6ne95N/WaO8S5HMIWkz1DFpoMwjYQavY2K1itl33RKCm/PKjuddYYEY8Jx0Vg4Tl5O9+lf7lUnexk79MDyPT5x4ZP/oq/HnCyrWzY9Lh+3Z6DY//Y1JMyZSpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


在 2026/3/17 8:15, Yang Shi 写道:
>
>
> On 3/16/26 8:47 AM, Ryan Roberts wrote:
>> Thanks for the report!
>>
>> + Kevin, who was looking at some adjacent issues and may have some 
>> ideas for how
>> to fix.
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
>>> [    0.000000][    T0] walk_kernel_page_table_range_lockless+0x58/0x98
>>> [    0.000000][    T0]  update_range_prot+0xb8/0x108
>>> [    0.000000][    T0]  __change_memory_common+0x30/0x1a8
>>> [    0.000000][    T0] __set_memory_enc_dec.part.0+0x170/0x260
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

https://lore.kernel.org/all/5aeb6f47-12be-40d5-be6f-847bb8ddc605@arm.com/

This is the discussion why realm relies on rodata=full. The initization of realm
coudn't move to before map_mem(), so is_realm_world() is false. As a result, realm
need rodata=full to indicate we need to make pages shared/protected at page granularity.

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
>
> Checking current cpu BBML2_NOABORT capability before system feature is 
> finalized seems like a fast way to stop bleeding IMHO before we find 
> more elegant long-term solution.
>
> Thanks,
> Yang
>
>>
>> Thanks,
>> Ryan
>>
>>
>>> Thanks.
>>>
>>>> Ryan tested v7 on an AmpereOne system (a VM with 12G RAM) in all 3 
>>>> possible
>>>> modes by hacking the BBML2 feature detection code:
>>>>
>>>>     - mode 1: All CPUs support BBML2 so the linear map uses large 
>>>> mappings
>>>>     - mode 2: Boot CPU does not support BBML2 so linear map uses 
>>>> pte mappings
>>>>     - mode 3: Boot CPU supports BBML2 but secondaries do not so 
>>>> linear map
>>>>       initially uses large mappings but is then repainted to use 
>>>> pte mappings
>>>>
>>>> In all cases, mm selftests run and no regressions are observed. In 
>>>> all cases,
>>>> ptdump of linear map is as expected. Because there are just some 
>>>> cleanups
>>>> between v7 and v8, so I kept using Ryan's test result:
>>>>
>>>> Mode 1:
>>>> =======
>>>> ---[ Linear Mapping start ]---
>>>> 0xffff000000000000-0xffff000000200000           2M PMD RW NX SHD
>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000000200000-0xffff000000210000          64K PTE RW NX SHD AF
>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000000210000-0xffff000000400000        1984K PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL
>>>> 0xffff000000400000-0xffff000002400000          32M PMD ro NX SHD
>>>> AF        BLK UXN    MEM/NORMAL
>>>> 0xffff000002400000-0xffff000002550000        1344K PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL
>>>> 0xffff000002550000-0xffff000002600000         704K PTE RW NX SHD AF
>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000002600000-0xffff000004000000          26M PMD RW NX SHD
>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000004000000-0xffff000040000000         960M PMD RW NX SHD AF
>>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000040000000-0xffff000140000000           4G PUD RW NX SHD
>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000140000000-0xffff000142000000          32M PMD RW NX SHD AF
>>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142000000-0xffff000142120000        1152K PTE RW NX SHD AF
>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142120000-0xffff000142128000          32K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142128000-0xffff000142159000         196K PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142159000-0xffff000142160000          28K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142160000-0xffff000142240000         896K PTE RW NX SHD AF
>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142240000-0xffff00014224e000          56K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff00014224e000-0xffff000142250000           8K PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142250000-0xffff000142260000          64K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142260000-0xffff000142280000         128K PTE RW NX SHD AF
>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142280000-0xffff000142288000          32K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142288000-0xffff000142290000          32K PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142290000-0xffff0001422a0000          64K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff0001422a0000-0xffff000142465000        1812K PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142465000-0xffff000142470000          44K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142470000-0xffff000142600000        1600K PTE RW NX SHD AF
>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000142600000-0xffff000144000000          26M PMD RW NX SHD
>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000144000000-0xffff000180000000         960M PMD RW NX SHD AF
>>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000180000000-0xffff000181a00000          26M PMD RW NX SHD
>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181a00000-0xffff000181b90000        1600K PTE RW NX SHD AF
>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181b90000-0xffff000181b9d000          52K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181b9d000-0xffff000181c80000         908K PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181c80000-0xffff000181c90000          64K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181c90000-0xffff000181ca0000          64K PTE RW NX SHD AF
>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181ca0000-0xffff000181dbd000        1140K PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181dbd000-0xffff000181dc0000          12K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181dc0000-0xffff000181e00000         256K PTE RW NX SHD AF
>>>> CON     UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181e00000-0xffff000182000000           2M PMD RW NX SHD
>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000182000000-0xffff0001c0000000         992M PMD RW NX SHD AF
>>>> CON BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff0001c0000000-0xffff000300000000           5G PUD RW NX SHD
>>>> AF        BLK UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000300000000-0xffff008000000000         500G PUD
>>>> 0xffff008000000000-0xffff800000000000      130560G PGD
>>>> ---[ Linear Mapping end ]---
>>>>
>>>> Mode 3:
>>>> =======
>>>> ---[ Linear Mapping start ]---
>>>> 0xffff000000000000-0xffff000000210000        2112K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000000210000-0xffff000000400000        1984K PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL
>>>> 0xffff000000400000-0xffff000002400000          32M PMD ro NX SHD
>>>> AF        BLK UXN    MEM/NORMAL
>>>> 0xffff000002400000-0xffff000002550000        1344K PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL
>>>> 0xffff000002550000-0xffff000143a61000     5264452K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000143a61000-0xffff000143c61000           2M PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000143c61000-0xffff000181b9a000     1015012K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181b9a000-0xffff000181d9a000           2M PTE ro NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000181d9a000-0xffff000300000000     6261144K PTE RW NX SHD
>>>> AF            UXN    MEM/NORMAL-TAGGED
>>>> 0xffff000300000000-0xffff008000000000         500G PUD
>>>> 0xffff008000000000-0xffff800000000000      130560G PGD
>>>> ---[ Linear Mapping end ]---
>>>>
>>>>
>>>> Performance Testing
>>>> ===================
>>>> * Memory use after boot
>>>> Before:
>>>> MemTotal:       258988984 kB
>>>> MemFree:        254821700 kB
>>>>
>>>> After:
>>>> MemTotal:       259505132 kB
>>>> MemFree:        255410264 kB
>>>>
>>>> Around 500MB more memory are free to use.  The larger the machine, the
>>>> more memory saved.
>>>>
>>>> * Memcached
>>>> We saw performance degradation when running Memcached benchmark with
>>>> rodata=full vs rodata=on.  Our profiling pointed to kernel TLB 
>>>> pressure.
>>>> With this patchset we saw ops/sec is increased by around 3.5%, P99
>>>> latency is reduced by around 9.6%.
>>>> The gain mainly came from reduced kernel TLB misses.  The kernel TLB
>>>> MPKI is reduced by 28.5%.
>>>>
>>>> The benchmark data is now on par with rodata=on too.
>>>>
>>>> * Disk encryption (dm-crypt) benchmark
>>>> Ran fio benchmark with the below command on a 128G ramdisk (ext4) with
>>>> disk encryption (by dm-crypt).
>>>> fio --directory=/data --random_generator=lfsr 
>>>> --norandommap            \
>>>>       --randrepeat 1 --status-interval=999 --rw=write --bs=4k 
>>>> --loops=1  \
>>>>       --ioengine=sync --iodepth=1 --numjobs=1 
>>>> --fsync_on_close=1         \
>>>>       --group_reporting --thread --name=iops-test-job 
>>>> --eta-newline=1    \
>>>>       --size 100G
>>>>
>>>> The IOPS is increased by 90% - 150% (the variance is high, but the 
>>>> worst
>>>> number of good case is around 90% more than the best number of bad
>>>> case). The bandwidth is increased and the avg clat is reduced
>>>> proportionally.
>>>>
>>>> * Sequential file read
>>>> Read 100G file sequentially on XFS (xfs_io read with page cache
>>>> populated). The bandwidth is increased by 150%.
>>>>
>>>> Additionally Ryan also ran this through a random selection of 
>>>> benchmarks on
>>>> AmpereOne. None show any regressions, and various benchmarks show 
>>>> statistically
>>>> significant improvement. I'm just showing those improvements here:
>>>>
>>>> +----------------------
>>>> +----------------------------------------------------------
>>>> +-------------------------+
>>>> | Benchmark            | Result
>>>> Class                                             | Improvement vs 
>>>> 6.17-rc1 |
>>>> +======================+==========================================================+=========================+ 
>>>>
>>>> | micromm/vmalloc      | full_fit_alloc_test: p:1, h:0, l:500000
>>>> (usec)           |              (I) -9.00% |
>>>> |                      | kvfree_rcu_1_arg_vmalloc_test: p:1, h:0, 
>>>> l:500000
>>>> (usec) |              (I) -6.93% |
>>>> |                      | kvfree_rcu_2_arg_vmalloc_test: p:1, h:0, 
>>>> l:500000
>>>> (usec) |              (I) -6.77% |
>>>> |                      | pcpu_alloc_test: p:1, h:0, l:500000
>>>> (usec)               |              (I) -4.63% |
>>>> +----------------------
>>>> +----------------------------------------------------------
>>>> +-------------------------+
>>>> | mmtests/hackbench    | process-sockets-30
>>>> (seconds)                             |              (I) -2.96% |
>>>> +----------------------
>>>> +----------------------------------------------------------
>>>> +-------------------------+
>>>> | mmtests/kernbench    | syst-192
>>>> (seconds) |             (I) -12.77% |
>>>> +----------------------
>>>> +----------------------------------------------------------
>>>> +-------------------------+
>>>> | pts/perl-benchmark   | Test: Interpreter
>>>> (Seconds)                              |              (I) -4.86% |
>>>> +----------------------
>>>> +----------------------------------------------------------
>>>> +-------------------------+
>>>> | pts/pgbench          | Scale: 1 Clients: 1 Read Write
>>>> (TPS)                     |               (I) 5.07% |
>>>> |                      | Scale: 1 Clients: 1 Read Write - Latency
>>>> (ms)            |              (I) -4.72% |
>>>> |                      | Scale: 100 Clients: 1000 Read Write
>>>> (TPS)                |               (I) 2.58% |
>>>> |                      | Scale: 100 Clients: 1000 Read Write - Latency
>>>> (ms)       |              (I) -2.52% |
>>>> +----------------------
>>>> +----------------------------------------------------------
>>>> +-------------------------+
>>>> | pts/sqlite-speedtest | Timed Time - Size 1,000
>>>> (Seconds)                        |              (I) -2.68% |
>>>> +----------------------
>>>> +----------------------------------------------------------
>>>> +-------------------------+
>>>>
>>>> Changes since v7 [1]
>>>> ====================
>>>> - Rebased on v6.17-rc6 and Shijie's rodata series 
>>>> (https://git.kernel.org/pub/
>>>> scm/linux/kernel/git/arm64/linux.git/commit/?id=bfbbb0d3215f)
>>>>     which has been picked up by Will.
>>>> - Patch 1: Fixed pmd_leaf/pud_leaf issue since the code may need to 
>>>> change
>>>>     permission for invalid entries per Jinjiang Tu.
>>>> - Patch 1: Removed pageattr_pgd_entry and pageattr_p4d_entry per Ryan.
>>>> - Used (-1ULL) instead of -1 per Catalin.
>>>> - Added comment about arm64 lazy mmu allow sleeping per Ryan.
>>>> - Squashed patch #4 in v7 into patch #3.
>>>> - Squashed patch #6 in v7 into patch #4.
>>>> - Added patch #5 to fix a arm64 kprobes bug. It guarantees 
>>>> set_memory_rox()
>>>>     is called before vfree(). It can go into separately or with 
>>>> this series
>>>>     together.
>>>> - Collected all the R-bs and A-bs.
>>>>
>>>> Changes since v6 [2]
>>>> ====================
>>>> - Patch 1: Minor refactor to implement 
>>>> walk_kernel_page_table_range() in terms
>>>>     of walk_kernel_page_table_range_lockless(). Also lead to adding 
>>>> *pmd argument
>>>>     to the lockless variant for consistency (per Catalin).
>>>> - Misc function/variable renames to improve clarity and consistency.
>>>> - Share same syncrhonization flag between 
>>>> idmap_kpti_install_ng_mappings and
>>>>     wait_linear_map_split_to_ptes, which allows removal of 
>>>> bbml2_ptes[] to save
>>>>     ~20K from kernel image.
>>>> - Only take pgtable_split_lock and enter lazy mmu mode once for 
>>>> both splits.
>>>> - Only walk the pgtable once for the common "split single page" case.
>>>> - Bypass split to contpmd and contpte when spllitting linear map to 
>>>> ptes.
>>>>
>>>> [1] https://lore.kernel.org/linux-arm-kernel/20250829115250.2395585-1-
>>>> ryan.roberts@arm.com/
>>>> [2] https://lore.kernel.org/linux-arm-kernel/20250805081350.3854670-1-
>>>> ryan.roberts@arm.com/
>>>>
>>>>
>>>> Dev Jain (1):
>>>>         arm64: Enable permission change on arm64 kernel block mappings
>>>>
>>>> Ryan Roberts (1):
>>>>         arm64: mm: split linear mapping if BBML2 unsupported on 
>>>> secondary CPUs
>>>>
>>>> Yang Shi (3):
>>>>         arm64: cpufeature: add AmpereOne to BBML2 allow list
>>>>         arm64: mm: support large block mapping when rodata=full
>>>>         arm64: kprobes: call set_memory_rox() for kprobe page
>>>>
>>>>    arch/arm64/include/asm/cpufeature.h |   2 +
>>>>    arch/arm64/include/asm/mmu.h        |   3 +
>>>>    arch/arm64/include/asm/pgtable.h    |   5 ++
>>>>    arch/arm64/kernel/cpufeature.c      |  12 +++-
>>>>    arch/arm64/kernel/probes/kprobes.c  |  12 ++++
>>>>    arch/arm64/mm/mmu.c                 | 422 
>>>> ++++++++++++++++++++++++++++++++++
>>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++---- 
>>>>
>>>>    arch/arm64/mm/pageattr.c            | 123 
>>>> ++++++++++++++++++++++++---------
>>>>    arch/arm64/mm/proc.S                |  27 ++++++--
>>>>    include/linux/pagewalk.h            |   3 +
>>>>    mm/pagewalk.c                       |  36 ++++++----
>>>>    10 files changed, 581 insertions(+), 64 deletions(-)
>>>>
>>>>
>
>

