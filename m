Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60AA7E9538D
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 12:00:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4FA96B00AD; Wed,  4 Feb 2026 07:00:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C756B00AE; Wed,  4 Feb 2026 07:00:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50396B00AF; Wed,  4 Feb 2026 07:00:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A24796B00AD
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 07:00:24 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 43AFF140148
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:00:24 +0000 (UTC)
X-FDA: 84406631568.02.585E964
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0412C40005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:00:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fmE7uI6q;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770206422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L7b7/ObJFuGII2AQCCO0slNHZyckJAjLIqJeasqhJKw=;
	b=U2Ssf55QbfK8cp0o3vP1aVTihz3P0oB3Bd+1CBNYGyrZxxUOx8YpqWCexP3eaXr3DJBc92
	xj4Z6CUZDKn3W0GiczpojvgY4N/rbZ/jSO0ew7X14QNzloRRTAhm1AkXCcX2wJK2eLaZr6
	K+Mfpn5nzGMqGF5y84pYawr2YR4kuBY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fmE7uI6q;
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770206422; a=rsa-sha256;
	cv=none;
	b=Oeg+QZ+wbA4lToT83qnIpV1dGlWXzO+ng5FfDLzG8fseKlqAc4Pls/1VtyN4EyrhTOR90i
	XhfSgxMKrncmnSc9OPYAEz+RLsjsu5T4chZSuELu2QU51SKyKW17ZThc9crVFTuUHd5oxW
	OF/Jw/Hgm8z4s4Uw9hK8BMvxDSnBCpk=
Date: Wed, 4 Feb 2026 20:00:05 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770206419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=L7b7/ObJFuGII2AQCCO0slNHZyckJAjLIqJeasqhJKw=;
	b=fmE7uI6qXms647X2X2mafRw2ZoAjGy/82UxM/h4Bn24SKXKOF2TBTIsLTaVn4njlehBYyj
	oPQpOMIa5dzWcxDkfoZ/DeO0UfvOd+o2nd3iSj4yKrkmBsQ7JqhaLzAQqM3iCL0lgnV7OM
	65lek+iT/9hpFCr4lLMNcx3Bu4UGPPw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Hao Ge <hao.ge@linux.dev>
Cc: Vlastimil Babka <vbabka@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/slab: Add alloc_tagging_slab_free_hook for
 memcg_alloc_abort_single
Message-ID: <75a2obu7fk4t2h5wj54gkbtyie4pdenw4mzecmmsgzwbhvxfmy@7mrdfx5q5p3h>
References: <20260204101401.202762-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260204101401.202762-1-hao.ge@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0412C40005
X-Stat-Signature: kowiawuszc4tgn4ms87t18en3are6npg
X-Rspam-User: 
X-HE-Tag: 1770206421-251517
X-HE-Meta: U2FsdGVkX19DXs1LYU26gGz0RIBj4bjEntqDt0LzC3QaeNkPxt4UcbKizsYG8uwYxsY9sC5xWaPpBYIm6DBCaDTKwbsnt1/+iUYW48/zxCzjIrp0xhmciDx2s8hpaueQ8VE7soFTXyKSGP9Kx8Wq8MzzHAbF2sQoSTmKN1W8bWyEWmsTPZ2rOgL2oEzetnZJc1m7F2DmS3HXbsvJF40WWDwAJ8MFF7ZwDsTh9fmzoMBfgS5QmVg1y5U1lHm2udv20uPQc9P0WT0PsAjAl5FOfsd9jmP/oSod49wFRRwBbPUX37kP0HWh5aDCqPSDl0RA2yWjBf3/B+QbMtPM/3xuWRXJXNG1zlGba3WtB8qL1/DYMJ2iZbdJ0hKHphncl2RTLSybijBO8q+EKBxhd7qSn7MaIKOBfp6oiQFd3iuRgyN6RnFMUb0MZciF9bW5tB85oL85lrKALr2Aq64/P16egHekJeXh6yIeK26HCWxn7C+yhPxc7+y/lyQ/kgJCXOD3CzSHUe3GztqTNqeWyHOpwkicWOlAfxZ4cKrBo7qBmgUGlfy21d2dejCesvjh8B3EXsC7p8o/SFBRL6HL4w5c00IIR/2hdrBGSbq4cjo4xZn7kei0tNGyRFOAFCA9ISzrII2CdZev8Sn16zcjjltn9vuTLbAIZobNDYlnzdqT1fTi9TG7l00jQaPyGRYSFi+vWEl4zeB3jdfWNSDtN9dMIWbXxXUL+uLX/eupY8pubz06yZ8LQ/Fs79n+thbxJlHA2swJl1JFNBhGOSZ/z37zrz2yLOysMPNz01lUDrI3KfDQ30hM2Fv1MmFLnZ7yxGCL3uY+1+H7Sqcma9xqOB7WJtkB43KhjzQMuWw2v/2zJ0rWM7KEJGoB3HtT5/CO0f7NT5LxvJCaHFNSSLS/DC629XXnq7K76D9a
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 04, 2026 at 06:14:01PM +0800, Hao Ge wrote:
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
> When __memcg_slab_post_alloc_hook() fails, there are two different
> free paths depending on whether size == 1 or size != 1. In the
> kmem_cache_free_bulk() path, we do call alloc_tagging_slab_free_hook().
> However, in memcg_alloc_abort_single() we don't, the above warning will be
> triggered on the next allocation.
> 
> Therefore, add alloc_tagging_slab_free_hook() to the
> memcg_alloc_abort_single() path.
> 
> Fixes: 9f9796b413d3 ("mm, slab: move memcg charging to post-alloc hook")
> Suggested-by: Hao Li <hao.li@linux.dev>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
> v2: Hao Li correctly pointed out the root cause of this problem.
>     Per his suggestion, this patch adds the missing hook call.
>     Many thanks to him for the thorough analysis.
> ---
>  mm/slub.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index f77b7407c51b..452a92544c6a 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -6689,6 +6689,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
>  static noinline
>  void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
>  {
> +	alloc_tagging_slab_free_hook(s, virt_to_slab(object), &object, 1);

LGTM.

Minor nit: It would be cleaner to store the result of `virt_to_slab(object)` in a local
variable and reuse it in the code that follows.

If you end up sending a v3, feel free to add:
Reviewed-by: Hao Li <hao.li@linux.dev>

> +
>  	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
>  		do_slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
>  }
> -- 
> 2.25.1
> 

