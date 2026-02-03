Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A53CE83070
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 10:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F31B6B0089; Tue,  3 Feb 2026 05:03:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D4B36B008A; Tue,  3 Feb 2026 05:03:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F367C6B0093; Tue,  3 Feb 2026 05:03:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E27556B0089
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 05:03:01 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 96D8D1B1C68
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:03:01 +0000 (UTC)
X-FDA: 84402706962.20.5FA3203
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id A71E280002
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 10:02:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KJJ/HFdx";
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770112980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2g6Z0yGmC4MIHJGze/C1qp5+vJvLw073QARgKXQMGY=;
	b=HVIUr/ku3zI1wavHyLQcEgY/ogI/wX+yvaQYdKBj4HcG2uHktbgUvcHfs1Z+rkXhp3MO48
	gSJbAKnGckAIkP/DKxZkLLPtHNlj7xXOhWM57Ce9hw1tDxPimo0Ani9HOvsU5gl68d9Dgm
	ADbkiOHFkaETGwnPKKOpyD7YiBHcFHA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="KJJ/HFdx";
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770112980; a=rsa-sha256;
	cv=none;
	b=iTUZ2vdY8nhMF5pf348NlDXwZcA1LnDjVQVD2k3mT94OQYQgQhfqsJTH7IFtnpYaSniXqH
	QnPr39HWq6sDQoD359JnpGuwEqIlaibBBOzeP85CGlgLYy9unAf3aPn/iTl3uQQFcdPxOw
	3KvN9ky3oyKabIRKLmGX+OhPUrQzFJQ=
Message-ID: <5b8e12d6-269c-4979-b99b-b3b4177aa00f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770112977;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+2g6Z0yGmC4MIHJGze/C1qp5+vJvLw073QARgKXQMGY=;
	b=KJJ/HFdxLHsNVhsKhMQn7wWf0GQEalVKIKBtWtZReK8naV9BJRB/XjQNpvU75pnl2ZVhth
	Ws0EUEFHIYy3uG6iD8AIkMwhug+TZ/FixZoLqhgRLM8zrjTIa1NfPZ/0a/BAoxWsOHjH9M
	udTrW8d2dFWLsSkoVNX+pxo6aUi+0EQ=
Date: Tue, 3 Feb 2026 18:02:07 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] codetag: Avoid codetag race between same slab object
 alloc and free
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260203073006.151710-1-hao.ge@linux.dev>
 <aYHDMvMUfKj4_eDe@hyeyoo>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <aYHDMvMUfKj4_eDe@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4rhor8b8ko66m5isopdxshbcz93f37gj
X-Rspamd-Queue-Id: A71E280002
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770112979-406222
X-HE-Meta: U2FsdGVkX1+osCZYptPwyWqhNh+t4JVzPA+Z+gYb9XASdgiDyfbrtgl5R0y6oKDEwVNtzb6H/nojblNOqFBvbsmbE4uwhQeXFyd8OzJFEMQuq7Wg2lb00GEb6xnlJvjp6Ch4BPykFn06QkfjfixzAhDIFUMl6rEuV9pNLOywBNxf8cRMtRgft1gOwNjK5+GxlK5yqWTxUDB2t/0JnnL53dUfaStc+FRRmXnih1IKMHwdFMWqSYkBQBCXPF0rdbnaXpRjjAjw9VLkOxu/+oliXa3G5KVFIVEEQK0C/iO+80cgfSvh5CQcdpsQ0a6DrRfdcuGsQlxfIRqHQ+l0QoslEiBFE4+brRnW0rXW9l/s+lI4hDy9Fsaw/d+dYLBk6nIi+VPM9hIl4y/Q9hntkLA5+wvhJyTHB4oohZ19L1LZX5jAfR4Xxtu2996SadlHFLoVEl7QihVvKH7oMh/W8laKQf1ofFK8o8LOAm59ShpdROZwePUQGXghe+pK7Oux4LJePHGSV/vL/p0O2t+1nrSCRiorh90/8Me3JrKVe9AKwx8v5kz1OkidiXSwY4eboDAxCwh7fn8S1rBnX417daQSiEz8rPcDPtwp0XNuYM9MkZMmIPklURVWO8NaoRLY31NSSy02KW7hLC8I8dFPM5JWL4ansvWkbLgbimmzDws+mgAFU87z0AxqOnQicS35GtPN//9VmmHHfa09oJ4RBQwbMGkH31Rzc727PAMsyxChu06HGmm8c4EaqjvL/+xQI7iZ0Seic5h5rgbHc9mYbULbbNJ0DvZfmEoa7DyL+JsXzHmrra4/MYBsKegWCb0Iyh6lqyqqlyJXMxhdn4TV7UdgWxNTmXqOfV/F2z9doosdiFHkdCtueyD0M++Q/OeU0BWGyGxjtPBjQzGUymrI+tiiGVr2+6ivlxulMZTMor+PM9IJ6stOsOUB6GpG2dQmd+Tj3eXnSGuq2E2qzxbFVJR
 dQ04pWts
 SaMPYaK+OyUkAXI5cSinT0yBBr0bW4OhUhGL0syx//0DJ5EM4xwcJTsV/CH6Wy42/y66D/8mi6BIAe6xyOCHQK6Ai5c+2m8baqAyAwJek/oLJTniNCYdmLshHqcmllAchoddD54jnXD9o9csu+t9OtD2ReDRZPEGGkAw8tdrQ9cIPM5M64qW9QzlaawqzZFN/xpDQ2sQ8lBliDqY6eVlBGUr17byh6f6QMs6ZZbOVF9jZbxQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Harry


On 2026/2/3 17:44, Harry Yoo wrote:
> On Tue, Feb 03, 2026 at 03:30:06PM +0800, Hao Ge wrote:
>> When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warning
>> may be noticed:
>>
>> [ 3959.023862] ------------[ cut here ]------------
>> [ 3959.023891] alloc_tag was not cleared (got tag for lib/xarray.c:378)
>> [ 3959.023947] WARNING: ./include/linux/alloc_tag.h:155 at alloc_tag_add+0x128/0x178, CPU#6: mkfs.ntfs/113998
>> [ 3959.023978] Modules linked in: dns_resolver tun brd overlay exfat btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse nfnetlink sr_mod virtio_gpu cdrom drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms_helper ghash_ce drm sm4 backlight virtio_net net_failover virtio_scsi failover virtio_console virtio_blk virtio_mmio dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
>> [ 3959.024170] CPU: 6 UID: 0 PID: 113998 Comm: mkfs.ntfs Kdump: loaded Tainted: G        W           6.19.0-rc7+ #7 PREEMPT(voluntary)
>> [ 3959.024182] Tainted: [W]=WARN
>> [ 3959.024186] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
>> [ 3959.024192] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
>> [ 3959.024199] pc : alloc_tag_add+0x128/0x178
>> [ 3959.024207] lr : alloc_tag_add+0x128/0x178
>> [ 3959.024214] sp : ffff80008b696d60
>> [ 3959.024219] x29: ffff80008b696d60 x28: 0000000000000000 x27: 0000000000000240
>> [ 3959.024232] x26: 0000000000000000 x25: 0000000000000240 x24: ffff800085d17860
>> [ 3959.024245] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 00000000000002d0
>> [ 3959.024257] x20: ffff0000e6ef3318 x19: ffff800085ae0410 x18: 0000000000000000
>> [ 3959.024269] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
>> [ 3959.024281] x14: 0000000000000000 x13: 0000000000000001 x12: ffff600064101293
>> [ 3959.024292] x11: 1fffe00064101292 x10: ffff600064101292 x9 : dfff800000000000
>> [ 3959.024305] x8 : 00009fff9befed6e x7 : ffff000320809493 x6 : 0000000000000001
>> [ 3959.024316] x5 : ffff000320809490 x4 : ffff600064101293 x3 : ffff800080691838
>> [ 3959.024328] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000d5bcd640
>> [ 3959.024340] Call trace:
>> [ 3959.024346]  alloc_tag_add+0x128/0x178 (P)
>> [ 3959.024355]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
>> [ 3959.024362]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
>> [ 3959.024369]  xas_alloc+0x304/0x4f0
>> [ 3959.024381]  xas_create+0x1e0/0x4a0
>> [ 3959.024388]  xas_store+0x68/0xda8
>> [ 3959.024395]  __filemap_add_folio+0x5b0/0xbd8
>> [ 3959.024409]  filemap_add_folio+0x16c/0x7e0
>> [ 3959.024416]  __filemap_get_folio_mpol+0x2dc/0x9e8
>> [ 3959.024424]  iomap_get_folio+0xfc/0x180
>> [ 3959.024435]  __iomap_get_folio+0x2f8/0x4b8
>> [ 3959.024441]  iomap_write_begin+0x198/0xc18
>> [ 3959.024448]  iomap_write_iter+0x2ec/0x8f8
>> [ 3959.024454]  iomap_file_buffered_write+0x19c/0x290
>> [ 3959.024461]  blkdev_write_iter+0x38c/0x978
>> [ 3959.024470]  vfs_write+0x4d4/0x928
>> [ 3959.024482]  ksys_write+0xfc/0x1f8
>> [ 3959.024489]  __arm64_sys_write+0x74/0xb0
>> [ 3959.024496]  invoke_syscall+0xd4/0x258
>> [ 3959.024507]  el0_svc_common.constprop.0+0xb4/0x240
>> [ 3959.024514]  do_el0_svc+0x48/0x68
>> [ 3959.024520]  el0_svc+0x40/0xf8
>> [ 3959.024526]  el0t_64_sync_handler+0xa0/0xe8
>> [ 3959.024533]  el0t_64_sync+0x1ac/0x1b0
>> [ 3959.024540] ---[ end trace 0000000000000000 ]---
> Hi Hao, on which commit did you observe this warning?


I've actually encountered this a few times already – it's been present 
in previous versions,

in fact – but the occurrence probability is extremely low.

As such, it's not possible to bisect the exact commit that introduced 
the issue.

It is worth noting, however, that all the call traces I have observed 
are related to xas.


>> This is due to a race condition that occurs when two threads concurrently
>> perform allocation and freeing operations on the same slab object.
>>
>> When a process is preparing to allocate a slab object, another process
>> successfully preempts the CPU, and then proceeds to free a slab object.
>> However, before the freeing process can invoke `alloc_tag_sub()`, it is
>> preempted again by the original allocating process. At this point, the
>> allocating process acquires the same slab object, and subsequently triggers
>> a warning when it invokes `alloc_tag_add()`.
> The explanation doesn't make sense to me, because alloc_tag_sub()
> should have been called before it's added back to freelist or sheaf
> before other threads can allocate it, or am I missing something?

You are correct. Likely mental fatigue on my part – I cleared my head 
afterward and found this scenario does not exist.

  As you noted, alloc_tag_sub is invoked first, then the object is added 
back to the freelist, so the race condition I described is probably 
non-existent.

Therefore, we may need to revisit our assumptions and take a closer look 
at the code corresponding to XAS.

Thank you for taking the time to review this with me.

Thanks

Best  Regards

Hao

>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>   mm/slub.c | 7 ++++++-
>>   1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/mm/slub.c b/mm/slub.c
>> index f77b7407c51b..0d84fc917a89 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2261,8 +2261,13 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
>>   	 * If other users appear then mem_alloc_profiling_enabled()
>>   	 * check should be added before alloc_tag_add().
>>   	 */
>> -	if (likely(obj_exts))
>> +	if (likely(obj_exts)) {
>> +
>> +		while (!READ_ONCE(obj_exts->ref.ct))
>> +			cpu_relax();
> I don't think this is acceptable - it shouldn't wait forever even when
> there is a real bug that doesn't clear the tag.
>
>> +
>>   		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
>> +	}
>>   	else
>>   		alloc_tag_set_inaccurate(current->alloc_tag);
>>   }
>> -- 
>> 2.25.1
>>

