Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE6FBE95372
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 10:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 963216B008A; Wed,  4 Feb 2026 05:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910C86B0092; Wed,  4 Feb 2026 05:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F8C6B0093; Wed,  4 Feb 2026 05:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B94B6B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 05:25:38 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65DCE1B2622
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:25:37 +0000 (UTC)
X-FDA: 84406392714.14.50AF18C
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7CDC418000A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:25:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E16W7ooi;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770200735;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XCQDmUDMtcd4ck9ZOk2HOtiez7GWet2k7sTaBsnvrOk=;
	b=Q3LB5Oo0m6ancIyG6AimrRXuZn55kjKDO/CfV5vugxMQutj21FFp0p4976F4tKXpeHnfyJ
	LpTYY+xdAmgcXf92i++IGz2leF2auePS6K12bUd64ALbEwAo9eDMOK1b3W23D122E+dCjW
	qPeKY+UHNGe147P+RLVvcm19ou6jMgU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=E16W7ooi;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770200735; a=rsa-sha256;
	cv=none;
	b=gt+kFjQSmTbOiRoIo3Uk+JkxYpLw0oxhJo7XdCWIL+IZnkvO89X/XCioO7/6/cRack7JCv
	pEpzEJhjG3rOSJ3Iij85fmwpXJFlkkCTmy6eUoq/A9A/nYRNqOUBetHGqvwD2hxhSjj5co
	Oa9jVh5fpejBqbecfcTmJX2/vxkC6fE=
Message-ID: <3de9129a-82e1-430e-8df9-7063e7d2129c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770200733;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XCQDmUDMtcd4ck9ZOk2HOtiez7GWet2k7sTaBsnvrOk=;
	b=E16W7ooilhqzn1xiXnqpFm0UTN/9AKG1AO69W/+Zsruv8i6uKh0udpLX8TILu1ijr/eF6m
	SaXbAS3ck952Ab4kJXRttrrqsXzRCycyeAxtF9TkIWO1Zdpspautt0XiCgeksqqt71JFFh
	I3YPZsS+cFCU6UeNES7sr0DzWCrGagY=
Date: Wed, 4 Feb 2026 18:24:42 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] codetag: Avoid codetag race between same slab object
 alloc and free
To: Hao Li <hao.li@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>,
 Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260203073006.151710-1-hao.ge@linux.dev>
 <aYHDMvMUfKj4_eDe@hyeyoo> <5b8e12d6-269c-4979-b99b-b3b4177aa00f@linux.dev>
 <inzhzqeqqvjudozqz433462qy522deyl226jfvajdkw3eerodk@bjoiaorsesuq>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <inzhzqeqqvjudozqz433462qy522deyl226jfvajdkw3eerodk@bjoiaorsesuq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7CDC418000A
X-Stat-Signature: re5y46ze9mmnejeoxmfritteq3f3c77w
X-Rspam-User: 
X-HE-Tag: 1770200735-524002
X-HE-Meta: U2FsdGVkX18GqiKF2vuJZeqE8o3uC/8kwk+hqVhBujFBQ0oEM5/Jr2ZIMvQydFkTAhA37UJahABLDkzjMzmL4i0M2ZAq3eIlqjxc2zS5wR6fvNNJuGo+iNjM5N4kBZJ03g6N/mUr5P7kaTNCCNvQfHB436RRM/NCD2qgyhBDG1VdIO3ggzc8M5PkN/RNv+/l5pXw+BNppIc0SBAykqT2HRR3A+SY3Cvm8gDzva1cOrenfzDWlFjgln9t79zunEEvV2DQtprMt4FHpl9YSjrb8Rmo/vXjX9qOy+rJRo+HwxV9aqUHbFqt+UniIu1mObcoSIz21badR9Tohm5rtKU4MHSNp6KtK8PUMdSwvNFcx82eylF9hhxZhr9gwnc9zvpBAT3sVC0N2pEXgeOIcyYyB4vzjWKSb9ZkAA/q6dcdp7q+JOv7lWjr3pXlsDT36ND3le8fW3130niirHZwA8xzB0fmhHSS4xq/ZcgtdMb3dzvqhRUIF36fl7pDVfIuWdKtIo7Oe30iaVvoGY4w6kQSJE8zJpP470+vhGJ56P7leVSmYIPj6waJiRNGKxCW95hiPjjKECf9WzxGqOJI69YtqoD/9vu9g5RyRUAa9n+oFt/O+wNAXfgcwG42JreRbAtf3kCCKRlirvkHnL7mZH3pXNKyZiTtQ5FXJDkPB/fY2JsUqIZK/mY+EYUXvHkos/ZJ6lIvUOoCP/gZSOe2Pce1jyBJnijDm4dKbfRbN/mZxu8/M/+on4ub9B5y26exyjVpg7uIhkOWk5HEunXWXArWTFNFmI8UnG5LSUgHc/LkJCgSw3z9MtVMzaq0jNEfHpsOY/p+zHscOMYe/eezQfNSv6vKttcVLxlVZ3U5tESkkRh/az6/7+DzbIUU7gT66OjZX1GakvpdzMMBrtxiKsULvBaEdZesydjHB4BFXtwuurm1sS05d6xsMbQc3ZZ0z2BhoOACbcKZeX6nakS2qJA
 DsCUGaUi
 GGEMTf3fYh7s6Tocy3KBVmoaFUi7DEoG9VLBC3clzkiZJI5QhY7JDb+2r+hf5K86E5apYJAL1MQvNG2ullTeut8MmM/9v1WoFyMCpPSKh42kvfalqgLZYhziI6zncToNC50Rq0v1EVt0id2WfWilYT5tZ7mS4DivJiKDOzp60cUsXXFtuHQ3s5EZFrHkGl9PILHDJ7/RgU40i2OqJ2pEtlEk56jiWZ9BBO7hS1V12cjKfmaZC5VFsEkEnEt4COVxcSoTyRwS6d4PYOtHqRAhR/rhEXa9wNP0gPHFZwx2qITzG9DPqzzlmy/AF2Np0GQSDvg3h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Hao Li


On 2026/2/4 14:21, Hao Li wrote:
> On Tue, Feb 03, 2026 at 06:02:07PM +0800, Hao Ge wrote:
>> Hi Harry
>>
>>
>> On 2026/2/3 17:44, Harry Yoo wrote:
>>> On Tue, Feb 03, 2026 at 03:30:06PM +0800, Hao Ge wrote:
>>>> When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warning
>>>> may be noticed:
>>>>
>>>> [ 3959.023862] ------------[ cut here ]------------
>>>> [ 3959.023891] alloc_tag was not cleared (got tag for lib/xarray.c:378)
>>>> [ 3959.023947] WARNING: ./include/linux/alloc_tag.h:155 at alloc_tag_add+0x128/0x178, CPU#6: mkfs.ntfs/113998
>>>> [ 3959.023978] Modules linked in: dns_resolver tun brd overlay exfat btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse nfnetlink sr_mod virtio_gpu cdrom drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms_helper ghash_ce drm sm4 backlight virtio_net net_failover virtio_scsi failover virtio_console virtio_blk virtio_mmio dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
>>>> [ 3959.024170] CPU: 6 UID: 0 PID: 113998 Comm: mkfs.ntfs Kdump: loaded Tainted: G        W           6.19.0-rc7+ #7 PREEMPT(voluntary)
>>>> [ 3959.024182] Tainted: [W]=WARN
>>>> [ 3959.024186] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
>>>> [ 3959.024192] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>>>> [ 3959.024199] pc : alloc_tag_add+0x128/0x178
>>>> [ 3959.024207] lr : alloc_tag_add+0x128/0x178
>>>> [ 3959.024214] sp : ffff80008b696d60
>>>> [ 3959.024219] x29: ffff80008b696d60 x28: 0000000000000000 x27: 0000000000000240
>>>> [ 3959.024232] x26: 0000000000000000 x25: 0000000000000240 x24: ffff800085d17860
>>>> [ 3959.024245] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 00000000000002d0
>>>> [ 3959.024257] x20: ffff0000e6ef3318 x19: ffff800085ae0410 x18: 0000000000000000
>>>> [ 3959.024269] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>>>> [ 3959.024281] x14: 0000000000000000 x13: 0000000000000001 x12: ffff600064101293
>>>> [ 3959.024292] x11: 1fffe00064101292 x10: ffff600064101292 x9 : dfff800000000000
>>>> [ 3959.024305] x8 : 00009fff9befed6e x7 : ffff000320809493 x6 : 0000000000000001
>>>> [ 3959.024316] x5 : ffff000320809490 x4 : ffff600064101293 x3 : ffff800080691838
>>>> [ 3959.024328] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000d5bcd640
>>>> [ 3959.024340] Call trace:
>>>> [ 3959.024346]  alloc_tag_add+0x128/0x178 (P)
>>>> [ 3959.024355]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
>>>> [ 3959.024362]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
>>>> [ 3959.024369]  xas_alloc+0x304/0x4f0
>>>> [ 3959.024381]  xas_create+0x1e0/0x4a0
>>>> [ 3959.024388]  xas_store+0x68/0xda8
>>>> [ 3959.024395]  __filemap_add_folio+0x5b0/0xbd8
>>>> [ 3959.024409]  filemap_add_folio+0x16c/0x7e0
>>>> [ 3959.024416]  __filemap_get_folio_mpol+0x2dc/0x9e8
>>>> [ 3959.024424]  iomap_get_folio+0xfc/0x180
>>>> [ 3959.024435]  __iomap_get_folio+0x2f8/0x4b8
>>>> [ 3959.024441]  iomap_write_begin+0x198/0xc18
>>>> [ 3959.024448]  iomap_write_iter+0x2ec/0x8f8
>>>> [ 3959.024454]  iomap_file_buffered_write+0x19c/0x290
>>>> [ 3959.024461]  blkdev_write_iter+0x38c/0x978
>>>> [ 3959.024470]  vfs_write+0x4d4/0x928
>>>> [ 3959.024482]  ksys_write+0xfc/0x1f8
>>>> [ 3959.024489]  __arm64_sys_write+0x74/0xb0
>>>> [ 3959.024496]  invoke_syscall+0xd4/0x258
>>>> [ 3959.024507]  el0_svc_common.constprop.0+0xb4/0x240
>>>> [ 3959.024514]  do_el0_svc+0x48/0x68
>>>> [ 3959.024520]  el0_svc+0x40/0xf8
>>>> [ 3959.024526]  el0t_64_sync_handler+0xa0/0xe8
>>>> [ 3959.024533]  el0t_64_sync+0x1ac/0x1b0
>>>> [ 3959.024540] ---[ end trace 0000000000000000 ]---
>>> Hi Hao, on which commit did you observe this warning?
>>
>> I've actually encountered this a few times already – it's been present in
>> previous versions,
>>
>> in fact – but the occurrence probability is extremely low.
>>
>> As such, it's not possible to bisect the exact commit that introduced the
>> issue.
>>
>> It is worth noting, however, that all the call traces I have observed are
>> related to xas.
>>
>>
>>>> This is due to a race condition that occurs when two threads concurrently
>>>> perform allocation and freeing operations on the same slab object.
>>>>
>>>> When a process is preparing to allocate a slab object, another process
>>>> successfully preempts the CPU, and then proceeds to free a slab object.
>>>> However, before the freeing process can invoke `alloc_tag_sub()`, it is
>>>> preempted again by the original allocating process. At this point, the
>>>> allocating process acquires the same slab object, and subsequently triggers
>>>> a warning when it invokes `alloc_tag_add()`.
>>> The explanation doesn't make sense to me, because alloc_tag_sub()
>>> should have been called before it's added back to freelist or sheaf
>>> before other threads can allocate it, or am I missing something?
>> You are correct. Likely mental fatigue on my part – I cleared my head
>> afterward and found this scenario does not exist.
>>
>>   As you noted, alloc_tag_sub is invoked first, then the object is added back
>> to the freelist, so the race condition I described is probably non-existent.
>>
>> Therefore, we may need to revisit our assumptions and take a closer look at
>> the code corresponding to XAS.
> Thanks for the reporting.
>
> My suspicion is that this issue is not related to XAS. I suspect it may be
> caused by a missing call to alloc_tagging_slab_free_hook() on some free path,
> leaving an uncleared tag behind.
>
> And then I reviewed all call sites of alloc_tagging_slab_free_hook() and my
> understanding is that it should be invoked on every path that frees slab
> objects.
>
> Then after reading some code, I noticed that in memcg_slab_post_alloc_hook(),
> when __memcg_slab_post_alloc_hook() fails, there are two different free paths
> depending on whether size == 1 or size != 1. In the kmem_cache_free_bulk() path
> we do call alloc_tagging_slab_free_hook(). However, in
> memcg_alloc_abort_single() we don't, and I think that omission of
> alloc_tagging_slab_free_hook() could explain the problem(unless I'm missing some
> other details...)

Your analysis is correct. Nice catch.

After adding a WARN_ON(1) at this location, the following log was observed:

https://elixir.bootlin.com/linux/v6.19-rc5/source/mm/slub.c#L2342

[ 3966.117006] ------------[ cut here ]------------
[ 3966.117031] WARNING: mm/slub.c:2342 at 
kmem_cache_alloc_lru_noprof+0x4cc/0x5e8, CPU#1: madvise06/114564
[ 3966.117053] Modules linked in: dns_resolver tun brd overlay exfat 
btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel 
udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse 
nfnetlink virtio_gpu drm_client_lib virtio_dma_buf drm_shmem_helper 
drm_kms_helper sr_mod cdrom ghash_ce drm virtio_net backlight virtio_blk 
net_failover failover sm4 virtio_console virtio_scsi virtio_mmio 
dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs 
aes_ce_blk
[ 3966.117218] CPU: 1 UID: 0 PID: 114564 Comm: madvise06 Kdump: loaded 
Not tainted 6.19.0-rc7+ #10 PREEMPT(voluntary)
[ 3966.117226] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 
2/2/2022
[ 3966.117231] pstate: 104000c5 (nzcV daIF +PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[ 3966.117238] pc : kmem_cache_alloc_lru_noprof+0x4cc/0x5e8
[ 3966.117244] lr : kmem_cache_alloc_lru_noprof+0x4c8/0x5e8
[ 3966.117250] sp : ffff8000a99772d0
[ 3966.117254] x29: ffff8000a99772e0 x28: 0000000000000000 x27: 
0000000000000240
[ 3966.117267] x26: 0000000000000000 x25: 0000000000000240 x24: 
0000000000000000
[ 3966.117279] x23: 0000000000402800 x22: ffff800082caf864 x21: 
ffff000100c8bb18
[ 3966.117291] x20: 0000000000402800 x19: ffff0000c0012dc0 x18: 
ffff8000a9977cdd
[ 3966.117303] x17: 0000000000000000 x16: 0000000000000000 x15: 
ffff8000a9977cb0
[ 3966.117315] x14: ffff8000a9977ca8 x13: 0000000041b58ab3 x12: 
ffff6000185d78c9
[ 3966.117326] x11: 1fffe000185d78c8 x10: ffff6000185d78c8 x9 : 
ffff800080b6908c
[ 3966.117338] x8 : 00009fffe7a28738 x7 : ffff0000c2ebc647 x6 : 
0000000000000001
[ 3966.117350] x5 : ffff0000c2ebc640 x4 : 1fffe000185d78d8 x3 : 
1fffe00025b598f0
[ 3966.117362] x2 : 0000000000000000 x1 : 0000000000000003 x0 : 
0000000000000000
[ 3966.117373] Call trace:
[ 3966.117378]  kmem_cache_alloc_lru_noprof+0x4cc/0x5e8 (P)
[ 3966.117386]  xas_alloc+0x304/0x4f0
[ 3966.117395]  xas_create+0x1e0/0x4a0
[ 3966.117402]  xas_store+0x68/0xda8
[ 3966.117410]  shmem_add_to_page_cache+0x4f4/0x6a8
[ 3966.117418]  shmem_alloc_and_add_folio+0x360/0xd40
[ 3966.117425]  shmem_get_folio_gfp+0x424/0x10d0
[ 3966.117432]  shmem_fault+0x1a4/0x6c8
[ 3966.117438]  __do_fault+0xd0/0x6c0
[ 3966.117447]  do_fault+0x2e8/0xbc0
[ 3966.117453]  handle_pte_fault+0x43c/0x7b8
[ 3966.117460]  __handle_mm_fault+0x308/0xb88
[ 3966.117467]  handle_mm_fault+0x238/0x7b8
[ 3966.117473]  do_page_fault+0x1cc/0x1138
[ 3966.117481]  do_translation_fault+0x80/0x130
[ 3966.117488]  do_mem_abort+0x74/0x1b8
[ 3966.117496]  el0_da+0x4c/0xf8
[ 3966.117503]  el0t_64_sync_handler+0xd0/0xe8
[ 3966.117509]  el0t_64_sync+0x1ac/0x1b0
[ 3966.117516] ---[ end trace 0000000000000000 ]---

The bug was subsequently reproduced, with the following log:

[ 4015.055460] ------------[ cut here ]------------
[ 4015.055480] alloc_tag was not cleared (got tag for lib/xarray.c:378)
[ 4015.055512] WARNING: ./include/linux/alloc_tag.h:155 at 
alloc_tag_add+0x128/0x178, CPU#3: kworker/u37:0/110627
[ 4015.055534] Modules linked in: dns_resolver tun brd overlay exfat 
btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel 
udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse 
nfnetlink virtio_gpu drm_client_lib virtio_dma_buf drm_shmem_helper 
drm_kms_helper sr_mod cdrom ghash_ce drm virtio_net backlight virtio_blk 
net_failover failover sm4 virtio_console virtio_scsi virtio_mmio 
dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs 
aes_ce_blk [last unloaded: hwpoison_inject]
[ 4015.055707] CPU: 3 UID: 0 PID: 110627 Comm: kworker/u37:0 Kdump: 
loaded Tainted: G        W           6.19.0-rc7+ #10 PREEMPT(voluntary)
[ 4015.055716] Tainted: [W]=WARN
[ 4015.055727] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 
2/2/2022
[ 4015.055734] Workqueue: loop0 loop_rootcg_workfn [loop]
[ 4015.055749] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS 
BTYPE=--)
[ 4015.055756] pc : alloc_tag_add+0x128/0x178
[ 4015.055764] lr : alloc_tag_add+0x128/0x178
[ 4015.055771] sp : ffff80008d7a71c0
[ 4015.055775] x29: ffff80008d7a71c0 x28: 0000000000000000 x27: 
0000000000000240
[ 4015.055788] x26: 0000000000000000 x25: 0000000000000240 x24: 
0000000000000000
[ 4015.055800] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 
00000000000002d0
[ 4015.055812] x20: ffff0000e4743358 x19: ffff800085ae0410 x18: 
0000000000000000
[ 4015.055824] x17: 0000000000000000 x16: 0000000000000000 x15: 
0000000000000000
[ 4015.055836] x14: 0000000000000000 x13: 0000000000000001 x12: 
ffff6000640eda93
[ 4015.055848] x11: 1fffe000640eda92 x10: ffff6000640eda92 x9 : 
dfff800000000000
[ 4015.055860] x8 : 00009fff9bf1256e x7 : ffff00032076d493 x6 : 
0000000000000001
[ 4015.055872] x5 : ffff00032076d490 x4 : ffff6000640eda93 x3 : 
ffff800080691838
[ 4015.055883] x2 : 0000000000000000 x1 : 0000000000000000 x0 : 
ffff0000d46795c0
[ 4015.055896] Call trace:
[ 4015.055900]  alloc_tag_add+0x128/0x178 (P)
[ 4015.055909]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
[ 4015.055916]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
[ 4015.055922]  xas_alloc+0x304/0x4f0
[ 4015.055931]  xas_create+0x1e0/0x4a0
[ 4015.055938]  xas_store+0x68/0xda8
[ 4015.055945]  shmem_add_to_page_cache+0x4f4/0x6a8
[ 4015.055953]  shmem_alloc_and_add_folio+0x360/0xd40
[ 4015.055960]  shmem_get_folio_gfp+0x424/0x10d0
[ 4015.055966]  shmem_write_begin+0x14c/0x458
[ 4015.055973]  generic_perform_write+0x2d8/0x5d8
[ 4015.055981]  shmem_file_write_iter+0xe8/0x118
[ 4015.055987]  lo_rw_aio.isra.0+0x91c/0xe20 [loop]
[ 4015.055995]  loop_process_work+0x328/0xeb0 [loop]
[ 4015.056003]  loop_rootcg_workfn+0x28/0x40 [loop]
[ 4015.056011]  process_one_work+0x5ac/0x1110
[ 4015.056019]  worker_thread+0x724/0xb30
[ 4015.056027]  kthread+0x2fc/0x3a8
[ 4015.056034]  ret_from_fork+0x10/0x20
[ 4015.056042] ---[ end trace 0000000000000000 ]---

This v2 patch incorporates your  suggested fix.

https://lore.kernel.org/all/20260204101401.202762-1-hao.ge@linux.dev/

I really appreciate your help.


Best  Regards

Hao

>

