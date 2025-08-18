Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0FAACA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 02:33:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CE066B008C; Sun, 17 Aug 2025 22:33:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A5676B0092; Sun, 17 Aug 2025 22:33:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2966B0093; Sun, 17 Aug 2025 22:33:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37FD16B008C
	for <linux-mm@kvack.org>; Sun, 17 Aug 2025 22:33:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DADF21DE021
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:33:57 +0000 (UTC)
X-FDA: 83788308114.02.4E9668D
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4232C12000A
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:33:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755484436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=akbS1/003+fL2YVk+wgOrjJv66AfdeSo9pqw0QG+b1E=;
	b=q5aUlTQXK5pCQswpQhLMJ+oSsEl9WjY3kVF01AqOKDoLJZ59vxYytRu7bLLsSj/QK03vFA
	5ND1FWX5zoYpF77E5zQVoyCW5fkmMpAESri6+1kv07+M35j6i5c09FmdqtH/WG0+dEJIWQ
	T7f2Y8KIsdE+enHn8pqvEM784uXuEMg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf29.hostedemail.com: domain of yintirui@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=yintirui@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755484436; a=rsa-sha256;
	cv=none;
	b=XTi6aeTIejBExQVhiOHH9TuYi6ftphAKkHPq6TLKoOQRCv2rFRALwqAADI+pFo0jHY/FoL
	puaVZtLayFushqHf80TrBdXKz4f2uni+VjkEPRpVgbDf998iOKPSom6gFNyjl/Uk6FDiMs
	C6iYrFRrHJF5rkGX1EWk1yflnwRGh74=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4c4xbt58mBzvWy5;
	Mon, 18 Aug 2025 10:33:46 +0800 (CST)
Received: from kwepemo100001.china.huawei.com (unknown [7.202.195.173])
	by mail.maildlp.com (Postfix) with ESMTPS id 76EE8180B5A;
	Mon, 18 Aug 2025 10:33:49 +0800 (CST)
Received: from [10.174.179.35] (10.174.179.35) by
 kwepemo100001.china.huawei.com (7.202.195.173) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 18 Aug 2025 10:33:48 +0800
Message-ID: <3098ccce-4ddc-4d64-977f-b901278d1f13@huawei.com>
Date: Mon, 18 Aug 2025 10:33:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] of_numa: fix uninitialized memory nodes causing kernel
 panic
To: Mike Rapoport <rppt@kernel.org>
CC: <robh@kernel.org>, <saravanak@google.com>, <dan.j.williams@intel.com>,
	<akpm@linux-foundation.org>, <david@redhat.com>,
	<Jonathan.Cameron@huawei.com>, <devicetree@vger.kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<wangkefeng.wang@huawei.com>, <chenjun102@huawei.com>
References: <20250816073131.2674809-1-yintirui@huawei.com>
 <aKF2VZ1y8OuEChmw@kernel.org>
From: =?UTF-8?B?5Y2w5L2T6ZSQ?= <yintirui@huawei.com>
In-Reply-To: <aKF2VZ1y8OuEChmw@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.35]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemo100001.china.huawei.com (7.202.195.173)
X-Stat-Signature: twfc71wgx8q53zcmfj7c5ibc5iimadqb
X-Rspam-User: 
X-Rspamd-Queue-Id: 4232C12000A
X-Rspamd-Server: rspam05
X-HE-Tag: 1755484434-104181
X-HE-Meta: U2FsdGVkX1+9wMr2Rx4b1gOq4NmlRw46YAT+6e/3fQhpxxkcnMRGdCtE2Us2CnhZzXxd1r5sod3K0Mo/ORhgZzcaOsC/4YiMZ4p6vf/V7Lt/CK03eOeP2dr4IDD4K2gX48OEQKNUpHkhaZNDh4AosqoeByTplC3AOkzDBMZ1YU7eUuKxNyN1/I/3FEGPlyo5CbiuwZT2wJRy0+A93Hd9n4YJHat06fkiZt6KlBCY9Hd6sOsGaXyhBUTpI6CZoJCfgcxKZF3YYaddwt5XWOkD4msjBpQKxIe0o5wkQACN5UvL5vuA/1ODJNF3hqYfNXGa2LksUxzeRpxgG+piifUZFl+SAD0K9Ppq8O7czpt0Adq7c4tIcRqesbtr4TJ9XwK0JKIImIcmv0MZvOjcUMkn7TY5KS64EL+i4n2x/6uWv4vToFGSnquYc+5eB6vDN1R43cxqVE/7UXP+P8vCM8ehmGLZJ5SPwo5WN2EjZNMn6Rs8MDlEhdnKbnBX2+qROU/PUdWq2kAYXWql+Jao3L/amPUHDTkW6aXLHwlJ+iy6PBtI4H2aQEUQLTb8+3kjM+PebIXBHw8oGmWqMsjLAj7I7UfIyRJESlLO1xxhNrcPoSS3G1sagXiM5cot3YEq+IQgIb0OF/rE5FTYXZtJb7SVYBsLZnDO5q95A1s7KpBnz/aetQK1+4JgXRC9b6hwFOiRiZp3edghjjtTqu0mkUUFcV2QDVJx9gZmwVAgQwTLec7xlpDzA2a49pYMPIVKWJwgSFMdaFypCJvy8/RE3iwQ44O2DT7VvwOGglLAyQRxnUo0LtIxEnMXvtAYa84NdlCh89iPOGn30M6i79ZiyGnVk5UEmrxyEAXsx8w9hlSHNTyuxDnz2uFF1EPcF/KlhlWBLultMdNOis/Gdnq8NIvYk7G4a0O+CHtwhpp0Y9OyXJTB5irOPkhrRnCba8wHgV33QLB/Ix9j+xN0kHAaHAO
 s/Tqktn0
 KTbyE5kLX9Ov/jiloJ5NLLN5wymo0l7THTr3uSbz5TOjlufiqdDTEjyVZgX4jbiipKoAKDxCGf5J0WSgSVT9CEcE9G+DRZnnLi/AgW8zB0pZY8D/Nu4ySRMsuEeORypYoKOsWvzWuhUvmb0CznXmCIMn5zAj7r9RTrbwrtffPpUStLGuRofSHWuTQBKwVCHJOQCCflViVsqxD6qhCbyatEehNVy7Ehvkj982LhQ4a+zYhq3GHDYZ9qdMEwwvRieLTpisdK4p5kxWvKs0BPY91bciLyqLpHkVFMutKmiSps2hJ3lXGMymIT6kezKgKKwybpD+0oOXu2DyBUG/HsuYTzTVafz4AZt9pPgMmyxtL0V1k+/w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

在 2025/8/17 14:27, Mike Rapoport 写道:
> Hi,
> 
> On Sat, Aug 16, 2025 at 03:31:31PM +0800, Yin Tirui wrote:
>> When the number of CPUs is fewer than the number of memory nodes,
>> some memory nodes may not be properly initialized because they are
>> not added to numa_nodes_parsed during memory parsing.
> 
> Why the issue happens when there are less CPUs than nodes?
> Does anything updates numa_nodes_parsed when there are more CPUs than
> nodes?
>   
>> In of_numa_parse_memory_nodes(), after successfully adding a memory
>> block via numa_add_memblk(), the corresponding node ID should be
>> marked as parsed. However, the current implementation in numa_add_memblk()
> 
> ... current implementation of of_numa_parse_memory_nodes()?
> 
>> only adds the memory block to numa_meminfo but fails to update
> 
> maybe "... but skips updating"
> 

Let me describe this in more detail:

of_numa_init
     of_numa_parse_cpu_nodes
         node_set(nid, numa_nodes_parsed);
     of_numa_parse_memory_nodes

In of_numa_parse_cpu_nodes, numa_nodes_parsed gets updated only for
nodes that contain CPUs.

A more accurate description is: When there are some nodes that contain
only memory (no CPUs), these nodes should have been updated in
of_numa_parse_memory_nodes, but they weren't. This is what caused the
problem.

>> numa_nodes_parsed, leaving some nodes uninitialized.
>>
>> During boot in a QEMU-emulated ARM64 NUMA environment, the kernel
>> panics when free_area_init() attempts to access NODE_DATA() for
>> memory nodes that were uninitialized.
>>
>> [    0.000000] Call trace:
>> [    0.000000]  free_area_init+0x620/0x106c (P)
>> [    0.000000]  bootmem_init+0x110/0x1dc
>> [    0.000000]  setup_arch+0x278/0x60c
>> [    0.000000]  start_kernel+0x70/0x748
>> [    0.000000]  __primary_switched+0x88/0x90
> 
> Would have be nice to have the full crash trace here and more details how
> qemu was run.
> 

QEMU with 1 CPU and 2 memory nodes:

qemu-system-aarch64 \
-cpu host -nographic \
-m 4G -smp 1 \
-machine virt,accel=kvm,gic-version=3,iommu=smmuv3 \
-object memory-backend-ram,size=2G,id=mem0 \
-object memory-backend-ram,size=2G,id=mem1 \
-numa node,nodeid=0,memdev=mem0 \
-numa node,nodeid=1,memdev=mem1 \
-kernel $IMAGE \
-hda $DISK \
-append "console=ttyAMA0 root=/dev/vda rw earlycon"


[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x481fd010]
[    0.000000] Linux version 6.17.0-rc1-00001-gabb4b3daf18c-dirty 
(yintirui@local) (gcc (GCC) 12.3.1, GNU ld (GNU Binutils) 2.41) #52 SMP 
PREEMPT Mon Aug 18 09:49:40 CST 2025
[    0.000000] KASLR enabled
[    0.000000] random: crng init done
[    0.000000] Machine model: linux,dummy-virt
[    0.000000] efi: UEFI not found.
[    0.000000] earlycon: pl11 at MMIO 0x0000000009000000 (options '')
[    0.000000] printk: legacy bootconsole [pl11] enabled
[    0.000000] OF: reserved mem: Reserved memory: No reserved-memory 
node in the DT
[    0.000000] NODE_DATA(0) allocated [mem 0xbfffd9c0-0xbfffffff]
[    0.000000] node 1 must be removed before remove section 23
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000040000000-0x00000000ffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000013fffffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000040000000-0x00000000bfffffff]
[    0.000000]   node   1: [mem 0x00000000c0000000-0x000000013fffffff]
[    0.000000] Initmem setup node 0 [mem 
0x0000000040000000-0x00000000bfffffff]
[    0.000000] Unable to handle kernel NULL pointer dereference at 
virtual address 00000000000000a0
[    0.000000] Mem abort info:
[    0.000000]   ESR = 0x0000000096000004
[    0.000000]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.000000]   SET = 0, FnV = 0
[    0.000000]   EA = 0, S1PTW = 0
[    0.000000]   FSC = 0x04: level 0 translation fault
[    0.000000] Data abort info:
[    0.000000]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    0.000000]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    0.000000]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    0.000000] [00000000000000a0] user address but active_mm is swapper
[    0.000000] Internal error: Oops: 0000000096000004 [#1]  SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 UID: 0 PID: 0 Comm: swapper Not tainted 
6.17.0-rc1-00001-gabb4b3daf18c-dirty #52 PREEMPT
[    0.000000] Hardware name: linux,dummy-virt (DT)
[    0.000000] pstate: 800000c5 (Nzcv daIF -PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[    0.000000] pc : free_area_init+0x50c/0xf9c
[    0.000000] lr : free_area_init+0x5c0/0xf9c
[    0.000000] sp : ffffcfb466733c00
[    0.000000] x29: ffffcfb466733cb0 x28: 0000000000000000 x27: 
0000000000000000
[    0.000000] x26: 4ec4ec4ec4ec4ec5 x25: 00000000000c0000 x24: 
00000000000c0000
[    0.000000] x23: 0000000000040000 x22: 0000000000000000 x21: 
ffffcfb46673b368
[    0.000000] x20: ffffcfb466cc7b98 x19: 0000000000000000 x18: 
0000000000000002
[    0.000000] x17: 000000000000cacc x16: 0000000000000001 x15: 
0000000000000001
[    0.000000] x14: 0000000080000000 x13: 0000000000000018 x12: 
0000000000000002
[    0.000000] x11: ffffcfb4667d4f00 x10: ffffcfb466cbab20 x9 : 
ffffcfb466cbab38
[    0.000000] x8 : 00000000000c0000 x7 : 0000000000000001 x6 : 
0000000000000002
[    0.000000] x5 : 0000000140000000 x4 : ffffcfb466733c90 x3 : 
ffffcfb466733ca0
[    0.000000] x2 : ffffcfb466733c98 x1 : 0000000080000000 x0 : 
0000000000000001
[    0.000000] Call trace:
[    0.000000]  free_area_init+0x50c/0xf9c (P)
[    0.000000]  bootmem_init+0x110/0x1dc
[    0.000000]  setup_arch+0x278/0x60c
[    0.000000]  start_kernel+0x70/0x748
[    0.000000]  __primary_switched+0x88/0x90
[    0.000000] Code: d503201f b98093e0 52800016 f8607a93 (f9405260)
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill 
the idle task! ]---

>> Cc: stable@vger.kernel.org
>> Fixes: 767507654c22 ("arch_numa: switch over to numa_memblks")
>> Signed-off-by: Yin Tirui <yintirui@huawei.com>
>>
>> ---
>>
>> v2: Move the changes to the of_numa related. Correct the fixes tag.
>> ---
>>   drivers/of/of_numa.c | 5 ++++-
>>   1 file changed, 4 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/of/of_numa.c b/drivers/of/of_numa.c
>> index 230d5f628c1b..cd2dc8e825c9 100644
>> --- a/drivers/of/of_numa.c
>> +++ b/drivers/of/of_numa.c
>> @@ -59,8 +59,11 @@ static int __init of_numa_parse_memory_nodes(void)
>>   			r = -EINVAL;
>>   		}
>>   
>> -		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++)
>> +		for (i = 0; !r && !of_address_to_resource(np, i, &rsrc); i++) {
>>   			r = numa_add_memblk(nid, rsrc.start, rsrc.end + 1);
>> +			if (!r)
>> +				node_set(nid, numa_nodes_parsed);
>> +		}
>>   
>>   		if (!i || r) {
>>   			of_node_put(np);
>> -- 
>> 2.43.0
>>
> 


