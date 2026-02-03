Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3832E8305B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 07:31:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 527836B0005; Tue,  3 Feb 2026 02:31:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D21E6B0088; Tue,  3 Feb 2026 02:31:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8816B0093; Tue,  3 Feb 2026 02:31:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 275A36B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 02:31:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF049C17AE
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:31:11 +0000 (UTC)
X-FDA: 84402324342.23.647AAE7
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf05.hostedemail.com (Postfix) with ESMTP id C6055100009
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 07:31:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ePlgGes+;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770103870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dlNLgFWBIF4EB9/p/k8at4vL0T3zQ15KzGeAj0aiQj8=;
	b=Qw912nf5roEhDidekUC1BktIZIhlp2zHCPEUphLbJnf+WqploeRKZ8Lo9bXKJlTyHV+N3s
	Z64vYUVx31G+LLv0Vz2JsHH2isRxA5Rv20fBlO4D1uW6SEVUVY0EOiw5/AqhqfK/juskUl
	Fcf6Yxq1cOMV35rqatDyvmDt1+KmHi4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ePlgGes+;
	spf=pass (imf05.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770103870; a=rsa-sha256;
	cv=none;
	b=V59vCgPxO58WPiLPFMXEs/Pdfpdd6ZNwsWDxvcSOO3qIEOEZk3TpdmDVhGg7yJN75BwpWy
	693lFk9rOq4jhPPoxaUht+pHv390ryDwuqpwuu6CWNl2bfRkKp31YICEN3EV/dW1ojtQn7
	PzK5u0Nm/NWlj6P52aU/12dWdxh/9JA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770103867;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dlNLgFWBIF4EB9/p/k8at4vL0T3zQ15KzGeAj0aiQj8=;
	b=ePlgGes+KgT1A6EzhO6gbVgdLyoTFjz4CIFLx1CC3lXfvsbMckC288SfC3t+hpa8zf0KBw
	gp3izTms3bmyJBHrbA0xTe3nZlHpvzexw9InlzA11qal7XdGrVpxWvbMMkcp1ZN36QM/Yo
	f2wy6Ku08oZso2ofP//CVsaCVSx4JWo=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH] codetag: Avoid codetag race between same slab object alloc and free
Date: Tue,  3 Feb 2026 15:30:06 +0800
Message-Id: <20260203073006.151710-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C6055100009
X-Stat-Signature: rynquqj5i1dnnwg4nrkqykadbxqrbg3a
X-Rspam-User: 
X-HE-Tag: 1770103869-56057
X-HE-Meta: U2FsdGVkX1/aYsnR7HoS73O6gZs8EWg0TwIq/jWw/eCUE1Txsm+2NvfsdO+9qxQJ/9mmWArRY/jzuYwL/lvcf0dt6TubF9mgedsRKbMa5v3iVahzOot9CuOEjXDPyF0Bs6n9iXEBD/DUzIIpq6rp9+VAxT+KXQ/slTxcnpGo1UegpMQr/ag54KVzMQJssNlQeEp3hYXTa3C1wylhitxvkJGOkq5UFS5SiDxh7pddfi7exDnjpnBeXwappaEEyw8eq2t+4eBZDILMsrGJfqAz6dPYk+LTFs6FvYQBVzpCgJZ6N75SCnMWZOvAqdDljPMnVBac34bzzLxMUf3ur7ApNuvJJlIJAPVBjLfcWy1keP7VQR86Ped29PI7VDhM0d37rHlfOALSxEFs1ge5uJZic/jP0/KovTRwEtcAJh6kghKn4LWzsO/FrN5uHZsQoELWSLAX2M9BslFLCubczWPDCEwE2U071X4xXqcPEXJGDGZT46Q+mtXKHRx0dclsI8hi7Ms/6+CWI5sWCh7X6JWBhImooU5ihjOg+6EUAKEXTifnu+28u56pHXkPYzrKMuf6+0J1zLNJkVuZb5DFzw0qoDYwfQFx/AFpx54tnJWy4XjC57v4cjWFYs9dpdvvQJfj/17MNE5KEeXY4rPjr3BEk9l5MjiaijAZbHDf8c7aAkGB0n/LL2QqMRlgeh+wh8TDg1nC19ILKLJ9gCWC71dahk36++m5Yr4OHQMzf+JHpUC3sNV0pnP0FR4W0/ahZK1hEyYhGQ5V1VMvtROachSjheHK6t4CzzF/eMJWfE572HQV3yuaWuZieBGzcWglDrsfJWGF6IAANVD+mrVrdNPI6lCgpoKQzWLwnEDIKhuhy57CNCH0R8CxBlkdI8XzgHFbGzocEH4qSH1EYknVz1tHQdm+Snzd3Cf5SdyGP5KEJ0IF0bcfVRFGC8dbZvbnV5+pe/al9BW3oBb+stBWARh
 Ct0AbJZG
 cMjkBE8Vrw3gAXp3h9tgmQ7GiB+dqM3V3e4+sqr5wqszcIU1pzw0l4+M01GT/pIj5hktLxO+vE/83vWDbf0kt6JF30vakt8Zrh6Kk76HXYCyqjY1Eho770Om2CW2f7JyqnnbVLe+0Wy90bXwe0pgRHxQqBcmxs8zqbofbKOVLIkfomiYEloqPmabszHSf1y7Ht3h/
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

This is due to a race condition that occurs when two threads concurrently
perform allocation and freeing operations on the same slab object.

When a process is preparing to allocate a slab object, another process
successfully preempts the CPU, and then proceeds to free a slab object.
However, before the freeing process can invoke `alloc_tag_sub()`, it is
preempted again by the original allocating process. At this point, the
allocating process acquires the same slab object, and subsequently triggers
a warning when it invokes `alloc_tag_add()`.

Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
Hi Suren

I'm not sure if my solution still has any issues, so I'd like to
get your suggestions on it. At the very least, my understanding is
that READ_ONCE and WRITE_ONCE should be used in pairs.

I look forward to your suggestions.

Thanks
---
 mm/slub.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/slub.c b/mm/slub.c
index f77b7407c51b..0d84fc917a89 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2261,8 +2261,13 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 	 * If other users appear then mem_alloc_profiling_enabled()
 	 * check should be added before alloc_tag_add().
 	 */
-	if (likely(obj_exts))
+	if (likely(obj_exts)) {
+
+		while (!READ_ONCE(obj_exts->ref.ct))
+			cpu_relax();
+
 		alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->size);
+	}
 	else
 		alloc_tag_set_inaccurate(current->alloc_tag);
 }
-- 
2.25.1


