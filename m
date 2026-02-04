Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2408BE95374
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 10:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688A86B0092; Wed,  4 Feb 2026 05:15:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E526B0093; Wed,  4 Feb 2026 05:15:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D406B0096; Wed,  4 Feb 2026 05:15:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 44B046B0092
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 05:15:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E23B51A0780
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:14:59 +0000 (UTC)
X-FDA: 84406365918.22.6A111BC
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id C603080005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 10:14:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZrQql6eU;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770200098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=tNDuvLBbkzIbWJoE0G1ZqgGCpNPmYnXQHNWvh9P0CtQ=;
	b=nTPPBw9ZdmG2uGmiwoIincYHW4ZNvgZRpgTGPE/oMPtuikt5cMFMIwOSBKX9rDXhlVNxwY
	v4g+O1aisgJKm1SDXDgPZ1VOZTrFM/OskJ91eWo6sVmaB2csudrNTQDjpptuUlE6hp4LVL
	vqO0nr9ttVzdzAUy9orxmnmXl12XQyQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZrQql6eU;
	spf=pass (imf30.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770200098; a=rsa-sha256;
	cv=none;
	b=3ClSHEOe81y/c1u6Z+5x1EFE6pGbekPO/352Lp9HYQy8apC1FV1MgXbd8Ep+rMZYkFcXQV
	dRS7OMc8zSdfGsi3rZZdurll+3+Zjk0rDcaqYQlVDmc8I+xLcNBmYD/ZRZJaWr3vM2pBvL
	JhJAamQeNUiy5EIur/VcUrUBxcgtDR4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770200095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=tNDuvLBbkzIbWJoE0G1ZqgGCpNPmYnXQHNWvh9P0CtQ=;
	b=ZrQql6eUufu63rSDKCzdzVXNSBwjStFKM8ncoqOtyiPXdNbP5cLDWEaZw0krnKvofwQGfp
	UX3JUHhW49zGQVLBlYZvXvre1OMbPTlOSPtFDbEURtluUFs8UMuTqo/A1xtNSZaeqPEdFo
	mxQJAxdNemxSSzCF08SWCW2fBkaExjo=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH v2] mm/slab: Add alloc_tagging_slab_free_hook for memcg_alloc_abort_single
Date: Wed,  4 Feb 2026 18:14:01 +0800
Message-Id: <20260204101401.202762-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C603080005
X-Stat-Signature: 3wftowzgaxe3jh3pyweu461kc6qrjj6h
X-Rspam-User: 
X-HE-Tag: 1770200097-302831
X-HE-Meta: U2FsdGVkX1/+AeO2phGkB+7is+Q2B1GIiK67X8yV3xBE4xjrgHkEHFeKVBO0vir9qU54yrcncsMYj4ehynFICyt/5fmS/qJmJlp48+SpMwAu+w7ZxYUvihQBz3cjKU/Z7ItBSGebGBcJ3gU0NPHZXO7mkU/wn2s6p/4nY86M8G6d7PDuEklxIYlKFbFeV4ouMyc9BzbX5152x1zTJ/FFXWtPiTsXemQYNhqRTMG57qP1SlCr/9+sJBrW9vJJ+k45ReLx1e/ncXdbzGiS21qCMRSYBAJnRWj+XisKDy6/qGhDcW8fxzuK5hno3T6B+5UbDovDxmewiGlYq7sbtHej0nWWcMlohWLYUApzaltLHR74c022BkTMBdvf7sbVBrEzx5yhgRHGC1lyBkK9UYlrUjKpOJ2IwRjbQlwT3wnHcE9CyubEZPIJOWnJ99bepV6P3P5661OnajEnDQ1aM6RK8x3Bgd8u7Ad0mNjFX9036rC7iqwdSXaGFF3lw1f1W0nD/KEttsCp2RAxx4/Hy6XWaaHIJnVtKwe1w0r9UCMeYA+29gKvkQrUf/bb/pIFq4/RPEFciasBDzFkuu2YbRUiIW5kYogwnUbl2rW/cWjcft9wCiIvXXbMT1SWE8sMUtrYC9mrqPT5RZrzzfzBkDJEide7j459OLfNnTl4em/REU1R+Yo3AFSACo13UWCszzJGKEA5t53UtrPFXLmQSbmQmt6N91yq//ZAcd8JxCKhQBRwclLJRHGdiL0FlnAigB+BI+6g8R9dkrK4T8y0qkHte+6O5Y0dk21cgHmOz002gmiBiUVqSo2GUSnTJeoLICB4HG9CjjgW9fLEd2FK2V7Fqvnfi/HdaQOh9b8yMo3UIF5WbclT9yc4UsesvDgE7fsHzlwsbbJiJMv4ygZqR+MQxg6P55qE6XKgaOJU8CE3hoX4kV+AQb+Fj1c+3WVGh3hKxYAiWN30jqa50NXSErk
 8PLCCwqT
 oYHhUs8YKXZwYgJzPYkgwBvtbHNfSoY4FkHQBQT1KoyE7HS46sWGew1f7sG7QjtbKd+tnoqKal4j51chrXA/zHtQjgqKryTgUC8BmQssRamczN6fhsnSpDnDxqFk+p0a4WqQpO9NGpuW+90Mn3RfKo4cCgxbHx9MkMUbnoNgGOTo2d3FNgD+bF4ome4da031uABROEiv+KFoZrTj4YJOELHYquKKAznL/e/MoyS6f3R3xMltdlJ2fyoulNg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled, the following warning
may be noticed:

[ 3959.023862] ------------[ cut here ]------------
[ 3959.023891] alloc_tag was not cleared (got tag for lib/xarray.c:378)
[ 3959.023947] WARNING: ./include/linux/alloc_tag.h:155 at alloc_tag_add+0x128/0x178, CPU#6: mkfs.ntfs/113998
[ 3959.023978] Modules linked in: dns_resolver tun brd overlay exfat btrfs blake2b libblake2b xor xor_neon raid6_pq loop sctp ip6_udp_tunnel udp_tunnel ext4 crc16 mbcache jbd2 rfkill sunrpc vfat fat sg fuse nfnetlink sr_mod virtio_gpu cdrom drm_client_lib virtio_dma_buf drm_shmem_helper drm_kms_helper ghash_ce drm sm4 backlight virtio_net net_failover virtio_scsi failover virtio_console virtio_blk virtio_mmio dm_mirror dm_region_hash dm_log dm_multipath dm_mod i2c_dev aes_neon_bs aes_ce_blk [last unloaded: hwpoison_inject]
[ 3959.024170] CPU: 6 UID: 0 PID: 113998 Comm: mkfs.ntfs Kdump: loaded Tainted: G        W           6.19.0-rc7+ #7 PREEMPT(voluntary)
[ 3959.024182] Tainted: [W]=WARN
[ 3959.024186] Hardware name: QEMU KVM Virtual Machine, BIOS unknown 2/2/2022
[ 3959.024192] pstate: 604000c5 (nZCv daIF +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[ 3959.024199] pc : alloc_tag_add+0x128/0x178
[ 3959.024207] lr : alloc_tag_add+0x128/0x178
[ 3959.024214] sp : ffff80008b696d60
[ 3959.024219] x29: ffff80008b696d60 x28: 0000000000000000 x27: 0000000000000240
[ 3959.024232] x26: 0000000000000000 x25: 0000000000000240 x24: ffff800085d17860
[ 3959.024245] x23: 0000000000402800 x22: ffff0000c0012dc0 x21: 00000000000002d0
[ 3959.024257] x20: ffff0000e6ef3318 x19: ffff800085ae0410 x18: 0000000000000000
[ 3959.024269] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[ 3959.024281] x14: 0000000000000000 x13: 0000000000000001 x12: ffff600064101293
[ 3959.024292] x11: 1fffe00064101292 x10: ffff600064101292 x9 : dfff800000000000
[ 3959.024305] x8 : 00009fff9befed6e x7 : ffff000320809493 x6 : 0000000000000001
[ 3959.024316] x5 : ffff000320809490 x4 : ffff600064101293 x3 : ffff800080691838
[ 3959.024328] x2 : 0000000000000000 x1 : 0000000000000000 x0 : ffff0000d5bcd640
[ 3959.024340] Call trace:
[ 3959.024346]  alloc_tag_add+0x128/0x178 (P)
[ 3959.024355]  __alloc_tagging_slab_alloc_hook+0x11c/0x1a8
[ 3959.024362]  kmem_cache_alloc_lru_noprof+0x1b8/0x5e8
[ 3959.024369]  xas_alloc+0x304/0x4f0
[ 3959.024381]  xas_create+0x1e0/0x4a0
[ 3959.024388]  xas_store+0x68/0xda8
[ 3959.024395]  __filemap_add_folio+0x5b0/0xbd8
[ 3959.024409]  filemap_add_folio+0x16c/0x7e0
[ 3959.024416]  __filemap_get_folio_mpol+0x2dc/0x9e8
[ 3959.024424]  iomap_get_folio+0xfc/0x180
[ 3959.024435]  __iomap_get_folio+0x2f8/0x4b8
[ 3959.024441]  iomap_write_begin+0x198/0xc18
[ 3959.024448]  iomap_write_iter+0x2ec/0x8f8
[ 3959.024454]  iomap_file_buffered_write+0x19c/0x290
[ 3959.024461]  blkdev_write_iter+0x38c/0x978
[ 3959.024470]  vfs_write+0x4d4/0x928
[ 3959.024482]  ksys_write+0xfc/0x1f8
[ 3959.024489]  __arm64_sys_write+0x74/0xb0
[ 3959.024496]  invoke_syscall+0xd4/0x258
[ 3959.024507]  el0_svc_common.constprop.0+0xb4/0x240
[ 3959.024514]  do_el0_svc+0x48/0x68
[ 3959.024520]  el0_svc+0x40/0xf8
[ 3959.024526]  el0t_64_sync_handler+0xa0/0xe8
[ 3959.024533]  el0t_64_sync+0x1ac/0x1b0
[ 3959.024540] ---[ end trace 0000000000000000 ]---

When __memcg_slab_post_alloc_hook() fails, there are two different
free paths depending on whether size == 1 or size != 1. In the
kmem_cache_free_bulk() path, we do call alloc_tagging_slab_free_hook().
However, in memcg_alloc_abort_single() we don't, the above warning will be
triggered on the next allocation.

Therefore, add alloc_tagging_slab_free_hook() to the
memcg_alloc_abort_single() path.

Fixes: 9f9796b413d3 ("mm, slab: move memcg charging to post-alloc hook")
Suggested-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
v2: Hao Li correctly pointed out the root cause of this problem.
    Per his suggestion, this patch adds the missing hook call.
    Many thanks to him for the thorough analysis.
---
 mm/slub.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index f77b7407c51b..452a92544c6a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6689,6 +6689,8 @@ void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
 static noinline
 void memcg_alloc_abort_single(struct kmem_cache *s, void *object)
 {
+	alloc_tagging_slab_free_hook(s, virt_to_slab(object), &object, 1);
+
 	if (likely(slab_free_hook(s, object, slab_want_init_on_free(s), false)))
 		do_slab_free(s, virt_to_slab(object), object, object, 1, _RET_IP_);
 }
-- 
2.25.1


