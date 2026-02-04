Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2BAEE8B39F
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 06:21:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A9E6B0005; Wed,  4 Feb 2026 01:21:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F16A16B0089; Wed,  4 Feb 2026 01:21:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E156F6B008A; Wed,  4 Feb 2026 01:21:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7D066B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 01:21:41 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 76AEABAAFF
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:21:41 +0000 (UTC)
X-FDA: 84405778002.30.8B2A4F3
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9B06A40002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:21:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DPLaiT5/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770186099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMrZT2j+/I2Uo0G3gxwUxwRURynYr4G6nxE71up9VIQ=;
	b=axJSc90P8GvZbKgckj3HWgVcgdc3PRNd1+wOhLPBb6q/aLsCH6K9JuzHlSrxqQ8r/JV9dQ
	19bzapWg6trahF8QBWKiY6tHVO3Oxd0sS7HHC82V5Dh0DpoCUFZ/lydO+b47i2xND3DPOj
	UyZx5FPGc1+Tw3i9Q4g3KuAN0jazHws=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770186099; a=rsa-sha256;
	cv=none;
	b=SfBkGYnSRI4lRUBXtDuMtXe04dtSbRQpQ/wVZDLNC8xChkWqjx+M/a1mP3jdJCVtXO+OWP
	PpUgPvAH9Jx+UI5/B8QT56tTuO/il3gaLr/cY3DJaPDq1drM6RpDYW0YrQ5tHsZENlNicU
	CUWkxv3GmE8Ke+t18+Qwwmdmo0StfsY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="DPLaiT5/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev
Date: Wed, 4 Feb 2026 14:21:24 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770186097;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RMrZT2j+/I2Uo0G3gxwUxwRURynYr4G6nxE71up9VIQ=;
	b=DPLaiT5/tcgUHOBFHpQx5WbgMCZXdhDx6OWQ0unFJczK7/a3GufOkUptQK8aD7L3VT2Xtw
	pMdJxvAzNMSz/UmL6qSsCBdgwXoJxz4Mxro+/gbV1B3BGD5NI7M51c0o4WR6BZKO33yCy7
	yW0NV8+B/EIUCegv9sGE/cS7kOWFyJ0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: Hao Ge <hao.ge@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] codetag: Avoid codetag race between same slab object
 alloc and free
Message-ID: <inzhzqeqqvjudozqz433462qy522deyl226jfvajdkw3eerodk@bjoiaorsesuq>
References: <20260203073006.151710-1-hao.ge@linux.dev>
 <aYHDMvMUfKj4_eDe@hyeyoo>
 <5b8e12d6-269c-4979-b99b-b3b4177aa00f@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5b8e12d6-269c-4979-b99b-b3b4177aa00f@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 9B06A40002
X-Stat-Signature: 54mbqpfsb5bw5xjg4f41uggptrxw8mbk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770186099-245956
X-HE-Meta: U2FsdGVkX1/T56S9doq1Y+KUeJBTb4FTqEagl4fUUZ8YlRlCl0nD6S6qW0WwsnDrZ7RY4RGPhCgBfZWMSBdgHyKjOaBRYC+6jvDghtHGCFMvrM8lEsegY50r4Wb27bSrv/1mj9VaPpQCEJOw5KsEVAoHKHJ5g6Pi4Hlom5w4BKTKnxzeCg+dKZN0cje+OEbsIuDCIyd7MrB+8sK0Z2HDAw/xJvmC9xjfrrrxJXix+LFpqHY9oEE1XcR2dSSY57vbBFnKm2kO65N7lSnBMzQSMKWe8jYlhOpkSY9xRLj6elDHKdZ2d868YHpdlbbpe+nEUtqJFYFrCEPJwmpNRR6a2jFABjcr/u56AVOem1iqB8oizg1KpU5uvU7JlJ75XvjYkL+xKavoRkkW22ap9kEcqxN7MVn8CCNRerXKo48BYUPg7PpaR1ONrwS9yjK7CJd/yj4PZWP4W5qlCbxRDoGVi8PulxfHVn/Ect8a5TqhokcTKueA+lCPfbmLlqJN1S4VJnqwUZ48gkes9W+HLpRhIoJ7zMceCooo4cUPVT1X4nx0G326gS+lTVWiuF4loSsNvLbm5mrQaX1vvV2tfkdcSS2aaCcrzhR2X6eBBG/kaWsHKNVPHGrms4Mnft0qCnfrztJV63/egqtkx1tagc60IfzbQeNVOLiNMMfAeZe23y6YKUQr++ESbWl+pqlmOtAniprT57d0c0XAAM2wIwFg+4vas3wQU1L1bsGSGaA98IqbBiJKzvyY9EYTRTNOEJXyJhwQEuE0V1q222ZzGGOJ0Fwj+3qo6FRbq0elFNHih2rEQP/kzzYlcBeUSiqDPYABUPVtykJlfHrGmLpN5LhgXMka4lgvay8PsTpdbYZHZxY15CfzruJtPnsB4uUvYz67lCrXXRZV+noBQa3gFcOfrsDfkSO3U/qJmluFoWCWIcqzsjfv8W0it++uPuC0ZysgnFtHtAg4devotFDBWDE
 xTgOThrl
 HxZDgbe2iYQva6FSzgH/MR/8f9HEZw3esCe/pc74RUUcNWgzhElYatyjoyqrXtCUJQGHamo+LmJtKiOLRFbQiUBjBMjVqgUEr2/ru5TbfIZmXcRRuqUOwJE0Adtn14jPc6MBODzNY0AtjgPOzKSnoiVkIh5/JZq9pUSpO2Eru8Buce773O3QpcMYIC6Cx4TKrDlsBOdczRhLMIoACQXwQy7jBouxy8M/uqlj5uPLvopQ2lKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 03, 2026 at 06:02:07PM +0800, Hao Ge wrote:
> Hi Harry
> 
> 
> On 2026/2/3 17:44, Harry Yoo wrote:
> > On Tue, Feb 03, 2026 at 03:30:06PM +0800, Hao Ge wrote:
> > > When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warning
> > > may be noticed:
> > > 
> > > [ 3959.023862] ------------[ cut here ]------------
> > > [ 3959.023891] alloc_tag was not cleared (got tag for lib/xarray.c:378)
> > > [ 3959.023947] WARNING: ./include/linux/alloc_tag.h:155 at alloc_tag_add+0x128/0x178, CPU#6: mkfs.ntfs/113998
> > > [ 3959.023978] Modules linked in: dns_resolver tun brd overlay exfat btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse nfnetlink sr_mod virtio_gpu cdrom drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms_helper ghash_ce drm sm4 backlight virtio_net net_failover virtio_scsi failover virtio_console virtio_blk virtio_mmio dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
> > > [ 3959.024170] CPU: 6 UID: 0 PID: 113998 Comm: mkfs.ntfs Kdump: loaded Tainted: G        W           6.19.0-rc7+ #7 PREEMPT(voluntary)
> > > [ 3959.024182] Tainted: [W]=WARN
> > > [ 3959.024186] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
> > > [ 3959.024192] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> > > [ 3959.024199] pc : alloc_tag_add+0x128/0x178
> > > [ 3959.024207] lr : alloc_tag_add+0x128/0x178
> > > [ 3959.024214] sp : ffff80008b696d60
> > > [ 3959.024219] x29: ffff80008b696d60 x28: 0000000000000000 x27: 0000000000000240
> > > [ 3959.024232] x26: 0000000000000000 x25: 0000000000000240 x24: ffff800085d17860
> > > [ 3959.024245] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 00000000000002d0
> > > [ 3959.024257] x20: ffff0000e6ef3318 x19: ffff800085ae0410 x18: 0000000000000000
> > > [ 3959.024269] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
> > > [ 3959.024281] x14: 0000000000000000 x13: 0000000000000001 x12: ffff600064101293
> > > [ 3959.024292] x11: 1fffe00064101292 x10: ffff600064101292 x9 : dfff800000000000
> > > [ 3959.024305] x8 : 00009fff9befed6e x7 : ffff000320809493 x6 : 0000000000000001
> > > [ 3959.024316] x5 : ffff000320809490 x4 : ffff600064101293 x3 : ffff800080691838
> > > [ 3959.024328] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000d5bcd640
> > > [ 3959.024340] Call trace:
> > > [ 3959.024346]  alloc_tag_add+0x128/0x178 (P)
> > > [ 3959.024355]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
> > > [ 3959.024362]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
> > > [ 3959.024369]  xas_alloc+0x304/0x4f0
> > > [ 3959.024381]  xas_create+0x1e0/0x4a0
> > > [ 3959.024388]  xas_store+0x68/0xda8
> > > [ 3959.024395]  __filemap_add_folio+0x5b0/0xbd8
> > > [ 3959.024409]  filemap_add_folio+0x16c/0x7e0
> > > [ 3959.024416]  __filemap_get_folio_mpol+0x2dc/0x9e8
> > > [ 3959.024424]  iomap_get_folio+0xfc/0x180
> > > [ 3959.024435]  __iomap_get_folio+0x2f8/0x4b8
> > > [ 3959.024441]  iomap_write_begin+0x198/0xc18
> > > [ 3959.024448]  iomap_write_iter+0x2ec/0x8f8
> > > [ 3959.024454]  iomap_file_buffered_write+0x19c/0x290
> > > [ 3959.024461]  blkdev_write_iter+0x38c/0x978
> > > [ 3959.024470]  vfs_write+0x4d4/0x928
> > > [ 3959.024482]  ksys_write+0xfc/0x1f8
> > > [ 3959.024489]  __arm64_sys_write+0x74/0xb0
> > > [ 3959.024496]  invoke_syscall+0xd4/0x258
> > > [ 3959.024507]  el0_svc_common.constprop.0+0xb4/0x240
> > > [ 3959.024514]  do_el0_svc+0x48/0x68
> > > [ 3959.024520]  el0_svc+0x40/0xf8
> > > [ 3959.024526]  el0t_64_sync_handler+0xa0/0xe8
> > > [ 3959.024533]  el0t_64_sync+0x1ac/0x1b0
> > > [ 3959.024540] ---[ end trace 0000000000000000 ]---
> > Hi Hao, on which commit did you observe this warning?
> 
> 
> I've actually encountered this a few times already – it's been present in
> previous versions,
> 
> in fact – but the occurrence probability is extremely low.
> 
> As such, it's not possible to bisect the exact commit that introduced the
> issue.
> 
> It is worth noting, however, that all the call traces I have observed are
> related to xas.
> 
> 
> > > This is due to a race condition that occurs when two threads concurrently
> > > perform allocation and freeing operations on the same slab object.
> > > 
> > > When a process is preparing to allocate a slab object, another process
> > > successfully preempts the CPU, and then proceeds to free a slab object.
> > > However, before the freeing process can invoke `alloc_tag_sub()`, it is
> > > preempted again by the original allocating process. At this point, the
> > > allocating process acquires the same slab object, and subsequently triggers
> > > a warning when it invokes `alloc_tag_add()`.
> > The explanation doesn't make sense to me, because alloc_tag_sub()
> > should have been called before it's added back to freelist or sheaf
> > before other threads can allocate it, or am I missing something?
> 
> You are correct. Likely mental fatigue on my part – I cleared my head
> afterward and found this scenario does not exist.
> 
>  As you noted, alloc_tag_sub is invoked first, then the object is added back
> to the freelist, so the race condition I described is probably non-existent.
> 
> Therefore, we may need to revisit our assumptions and take a closer look at
> the code corresponding to XAS.

Thanks for the reporting.

My suspicion is that this issue is not related to XAS. I suspect it may be
caused by a missing call to alloc_tagging_slab_free_hook() on some free path,
leaving an uncleared tag behind.

And then I reviewed all call sites of alloc_tagging_slab_free_hook() and my
understanding is that it should be invoked on every path that frees slab
objects.

Then after reading some code, I noticed that in memcg_slab_post_alloc_hook(),
when __memcg_slab_post_alloc_hook() fails, there are two different free paths
depending on whether size == 1 or size != 1. In the kmem_cache_free_bulk() path
we do call alloc_tagging_slab_free_hook(). However, in
memcg_alloc_abort_single() we don't, and I think that omission of
alloc_tagging_slab_free_hook() could explain the problem(unless I'm missing some
other details...)

-- 
Thanks,
Hao Li

> 
> Thank you for taking the time to review this with me.
> 
> Thanks
> 
> Best  Regards
> 
> Hao
> 
> > 
> > > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > > ---
> > >   mm/slub.c | 7 ++++++-
> > >   1 file changed, 6 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/mm/slub.c b/mm/slub.c
> > > index f77b7407c51b..0d84fc917a89 100644
> > > --- a/mm/slub.c
> > > +++ b/mm/slub.c
> > > @@ -2261,8 +2261,13 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
> > >   	 * If other users appear then mem_alloc_profiling_enabled()
> > >   	 * check should be added before alloc_tag_add().
> > >   	 */
> > > -	if (likely(obj_exts))
> > > +	if (likely(obj_exts)) {
> > > +
> > > +		while (!READ_ONCE(obj_exts->ref.ct))
> > > +			cpu_relax();
> > I don't think this is acceptable - it shouldn't wait forever even when
> > there is a real bug that doesn't clear the tag.
> > 
> > > +
> > >   		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
> > > +	}
> > >   	else
> > >   		alloc_tag_set_inaccurate(current->alloc_tag);
> > >   }
> > > -- 
> > > 2.25.1
> > > 
> 

