Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D139E8305F
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 07:59:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B856A6B0005; Tue,  3 Feb 2026 02:59:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B33856B0088; Tue,  3 Feb 2026 02:59:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A69A36B0089; Tue,  3 Feb 2026 02:59:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 950106B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:59:43 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E7F1C1A8D
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:59:42 +0000 (UTC)
X-FDA: 84402396204.05.5970595
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf24.hostedemail.com (Postfix) with ESMTP id 370BE180004
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:59:39 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hvEDj+0r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770105580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RPwfNBBHlYJbOgr7k75lbMbddBPH7V51tCqCs1C01RU=;
	b=sUVwjTBvreIc+vsT/xs58/Flm+DpIl6I5TOpiSBUvKUiVtgr882vqf9z3sU1Vvw5Y/4lD9
	3++WY9791So3XJH3xSfwuyIzAPnsD0aqNHMxOyeeb0cjC3RzLVEgtbumylI/rubbCaAr+h
	Sd8YD/CujDsoSIeq1vpNxIcCllwvDiw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770105580; a=rsa-sha256;
	cv=none;
	b=j6ETooOtgcWVdY+dj8QQgLlLIjIG48jWe7JRf/qfMzFsbQX2Mg8waUInATUpfgnSlzW648
	WHrntOuuLFBeu8sSDOtbyUcWc5mmjOuh/5bzl/cn+l9JQBM2+G0VPjgWOL1UpYgX2y1u5f
	r+j3/cWvo7HNjqP6eIQ+adjcncHnSmo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hvEDj+0r;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
Message-ID: <3b6ffbe3-61ef-42d5-b7e9-5ad54188949b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770105578;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RPwfNBBHlYJbOgr7k75lbMbddBPH7V51tCqCs1C01RU=;
	b=hvEDj+0rr79NrWLV3MPrSPMFtQ3kstfqPrKtSSCxcbrEifDvU0RtbCSe7B6JjA6sbAj+Hw
	iJLVCMYREh0bkw6put6C6aBT1WKGhzO4EAlmN4h+ZJgHsfcnIuniPqesFEoHuZRye7HlRA
	3NjoeQOFbxjgiXH0EMmhAXrGDZVYMKI=
Date: Tue, 3 Feb 2026 15:58:44 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] codetag: Avoid codetag race between same slab object
 alloc and free
To: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260203073006.151710-1-hao.ge@linux.dev>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260203073006.151710-1-hao.ge@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 370BE180004
X-Stat-Signature: qkyz69ea5fkb78ystbuihgugkxkfyjfn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770105579-758304
X-HE-Meta: U2FsdGVkX18gVsAj/Vtb1bG896BWTjMj28zxRllLZN/RNHnKSWEE6nt5o9TIeYRPiBQcyeSQWm6JVFkXtDjJh7GQU1FlJRA3TfzoLt/004OM759AcQkF7LmJJC1w9rB/QQwe0FGG5RMaQXf0Ig6PtQ46OLaKTtiYZto4Rn4OfRubgTSMFaL/sdmnssGREpVnxefY3pxZnDRFVa49PT7rqdAz7HalJBp8GIHvS4jOD4GHjjsG4A3RLLsvDib0tbRaF63car2eajEz3ZZSzxjn9VnbzsnrsBDadJJ5qFNePz3FnbCasGhW+kXN3n+5e+lPdX6vi6xs2/hfZYW/NPVEDi1d3A6V2tTrUS6YfmwD7Jsy5XJiGooo7Z4FyCr/L3GytVQksv07xY0T/khr1ls7trcp8hwI88fV9TsloDMNKqbTHjkZPUyHtovPyBBQw8QCLh5g/+WsZVH0Lan5DygUlfWDE71m1aquyov0aAR5+GNSoEZnGfM5yc7G4U+eiUfDxHQl3cET/dn9UujuGSwzRSUcKbVyT2sf1SmqNpdo5KXQz1b93WmMHyjtK5oNRz28XgqihPpu8lNdexb/2cZ/KPxJvtvTd9lQ4bALMuQ7H3NVibWuTHRK2eLrJWN9yEPWJ/9twdY/o15ZPVxm5jFsGNYw0bTIzMaTI6kIRUXn/errYRuE08uk93XCXtEg4yFSv4GC0IUYwlaxA3hryTtpntUgDxnlcQYLA8Jp7jLfk+7oqi+wcDVBcS3Z3JI1ovowC1Gto1E4JbUtmekFd1HCDrVpTvm7SYhGGtQm/he4juF6RVcH3iY1C7UiT7eo+NEUWcEii+Gvj901Yce8r2xtOxqEDf/KRPR0qVLb1z372RkYa2E1C0xy044hB6XMO8sewtgZmqw1borzRSlUzizPa+hVZQAU1ILtLJAMZqqtepE8w76NoaJilqJeD+wHrfGASlD+VIW9MRMtVTN6AJx
 ZS7NLHsO
 VhXIj1+dw9zCgmXsTJzp9brblP+wBvPC8eDNSl8rf1Aj3qI8sl29GsiZpurBJJ5+QJtl8+dSEKWszfXIRMSEge8WdkJWFgsP9M6c3e6om7+JX2WSNOzDmnM9IiqJkeH3B98BPD2O5gpd3Dor/JKLr8Gq92EiQE6Jp0q/bPkuXdFRq8rke9d744fmRfWIB3ojNKBDSNEHX4zWRa1oJ8riZIY3EeLkDR1py4qiD7QXwDo0ACCY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 2026/2/3 15:30, Hao Ge wrote:
> When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warning
> may be noticed:
>
> [ 3959.023862] ------------[ cut here ]------------
> [ 3959.023891] alloc_tag was not cleared (got tag for lib/xarray.c:378)
> [ 3959.023947] WARNING: ./include/linux/alloc_tag.h:155 at alloc_tag_add+0x128/0x178, CPU#6: mkfs.ntfs/113998
> [ 3959.023978] Modules linked in: dns_resolver tun brd overlay exfat btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse nfnetlink sr_mod virtio_gpu cdrom drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms_helper ghash_ce drm sm4 backlight virtio_net net_failover virtio_scsi failover virtio_console virtio_blk virtio_mmio dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
> [ 3959.024170] CPU: 6 UID: 0 PID: 113998 Comm: mkfs.ntfs Kdump: loaded Tainted: G        W           6.19.0-rc7+ #7 PREEMPT(voluntary)
> [ 3959.024182] Tainted: [W]=WARN
> [ 3959.024186] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
> [ 3959.024192] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> [ 3959.024199] pc : alloc_tag_add+0x128/0x178
> [ 3959.024207] lr : alloc_tag_add+0x128/0x178
> [ 3959.024214] sp : ffff80008b696d60
> [ 3959.024219] x29: ffff80008b696d60 x28: 0000000000000000 x27: 0000000000000240
> [ 3959.024232] x26: 0000000000000000 x25: 0000000000000240 x24: ffff800085d17860
> [ 3959.024245] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 00000000000002d0
> [ 3959.024257] x20: ffff0000e6ef3318 x19: ffff800085ae0410 x18: 0000000000000000
> [ 3959.024269] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> [ 3959.024281] x14: 0000000000000000 x13: 0000000000000001 x12: ffff600064101293
> [ 3959.024292] x11: 1fffe00064101292 x10: ffff600064101292 x9 : dfff800000000000
> [ 3959.024305] x8 : 00009fff9befed6e x7 : ffff000320809493 x6 : 0000000000000001
> [ 3959.024316] x5 : ffff000320809490 x4 : ffff600064101293 x3 : ffff800080691838
> [ 3959.024328] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000d5bcd640
> [ 3959.024340] Call trace:
> [ 3959.024346]  alloc_tag_add+0x128/0x178 (P)
> [ 3959.024355]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
> [ 3959.024362]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
> [ 3959.024369]  xas_alloc+0x304/0x4f0
> [ 3959.024381]  xas_create+0x1e0/0x4a0
> [ 3959.024388]  xas_store+0x68/0xda8
> [ 3959.024395]  __filemap_add_folio+0x5b0/0xbd8
> [ 3959.024409]  filemap_add_folio+0x16c/0x7e0
> [ 3959.024416]  __filemap_get_folio_mpol+0x2dc/0x9e8
> [ 3959.024424]  iomap_get_folio+0xfc/0x180
> [ 3959.024435]  __iomap_get_folio+0x2f8/0x4b8
> [ 3959.024441]  iomap_write_begin+0x198/0xc18
> [ 3959.024448]  iomap_write_iter+0x2ec/0x8f8
> [ 3959.024454]  iomap_file_buffered_write+0x19c/0x290
> [ 3959.024461]  blkdev_write_iter+0x38c/0x978
> [ 3959.024470]  vfs_write+0x4d4/0x928
> [ 3959.024482]  ksys_write+0xfc/0x1f8
> [ 3959.024489]  __arm64_sys_write+0x74/0xb0
> [ 3959.024496]  invoke_syscall+0xd4/0x258
> [ 3959.024507]  el0_svc_common.constprop.0+0xb4/0x240
> [ 3959.024514]  do_el0_svc+0x48/0x68
> [ 3959.024520]  el0_svc+0x40/0xf8
> [ 3959.024526]  el0t_64_sync_handler+0xa0/0xe8
> [ 3959.024533]  el0t_64_sync+0x1ac/0x1b0
> [ 3959.024540] ---[ end trace 0000000000000000 ]---
>
> This is due to a race condition that occurs when two threads concurrently
> perform allocation and freeing operations on the same slab object.
>
> When a process is preparing to allocate a slab object, another process
> successfully preempts the CPU, and then proceeds to free a slab object.
> However, before the freeing process can invoke `alloc_tag_sub()`, it is
> preempted again by the original allocating process. At this point, the
> allocating process acquires the same slab object, and subsequently triggers
> a warning when it invokes `alloc_tag_add()`.
>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
> Hi Suren
>
> I'm not sure if my solution still has any issues, so I'd like to
> get your suggestions on it. At the very least, my understanding is
> that READ_ONCE and WRITE_ONCE should be used in pairs.
>
> I look forward to your suggestions.
>
> Thanks
> ---
>   mm/slub.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/mm/slub.c b/mm/slub.c
> index f77b7407c51b..0d84fc917a89 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -2261,8 +2261,13 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
>   	 * If other users appear then mem_alloc_profiling_enabled()
>   	 * check should be added before alloc_tag_add().
>   	 */
> -	if (likely(obj_exts))
> +	if (likely(obj_exts)) {
> +
> +		while (!READ_ONCE(obj_exts->ref.ct))
> +			cpu_relax();
> +

My apologies for forgetting to update this part when submitting the

patch — I've already made the change in my local environment:

while (READ_ONCE(obj_exts->ref.ct))

cpu_relax();

I'd also welcome any thoughts or feedback from others in the community.


>   		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
> +	}
>   	else
>   		alloc_tag_set_inaccurate(current->alloc_tag);
>   }

