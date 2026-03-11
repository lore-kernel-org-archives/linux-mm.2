Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19DCC1125873
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 19:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B29D6B0005; Wed, 11 Mar 2026 15:09:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 772016B0095; Wed, 11 Mar 2026 15:09:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BC6E6B0096; Wed, 11 Mar 2026 15:09:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A83D6B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 15:09:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2D6B5585E1
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:23 +0000 (UTC)
X-FDA: 84534720606.09.F6F4B60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 43F761A0018
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 19:09:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WH+8WPiK;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773256161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YrPfXgYaohDR/5pw2g7kmmw03WkfOy/UYaogyOGAXcI=;
	b=GJ3gVIVzhUz+nAF+vX26H1vjxatwCz/4AkEtXKzedlBS0A6bnmOwmUeB8qFRU/Wx8gFk6w
	EXt0L/0w8RcJXpsN6IaU8/nbIyXOBBLHi95mexADodSDSWiH0PDgT2afEGCxJfNjqECfiA
	aTLgwyQNBBPtqjAINYa6MiFMXvqP8k0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773256161; a=rsa-sha256;
	cv=none;
	b=hVPvpA6bsCk9wVr2wHu1WRdQ7fR7nxhCRq3jUt/yJD0ZUBpic7P23ykQV1bb1jqwSeSrcX
	qOUDY1MPCEbgXyS+Gve8xGxKEwyWIQD8SYTQwQf1afawGFsG1zRrzPe7aO/Jp29fbbF+/u
	k+KPfYjx9zKaVRGGHhzydaZGUGOPeVM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WH+8WPiK;
	spf=pass (imf19.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6D91B43222;
	Wed, 11 Mar 2026 19:09:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 753B9C4CEF7;
	Wed, 11 Mar 2026 19:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773256160;
	bh=gbK+v7FulbHCf4xeffX6pcY7t9uYKpGBULCh9FUaZDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WH+8WPiKHF8Dt8v7aKQoWV/m4UNwNYjgwSonq778FSXuQHPHb/lEGPIG7EyWj2uMv
	 fZ1RkdjHx10MB5/q80znPzHQfuxWxreymIWQhCn1Ned3fMaBibrotQZVr03CCgdCSR
	 DdKDV3J3Rd5ObPVLvOnsb1o7er6N1LQGE7sqKbJYQKGE0WmPuGqR43BGPXkVok/6+L
	 TDvUNLoGp6DrhtujPksC89No8EXlSkkIXhG15iNEt/GKTR3AtvNBbpSrxc8LBHuuiw
	 mPCxIQbK2A7bytiGW/D33YzwAuEg957pOE10uIkuiQtOzbtTknj18zbKxWsqx4WKS+
	 O+RAatznjIzVA==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Petr Tesarik <ptesarik@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?utf-8?q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 7/8] RDMA/umem: Tell DMA mapping that UMEM requires coherency
Date: Wed, 11 Mar 2026 21:08:50 +0200
Message-ID: <20260311-dma-debug-overlap-v2-7-e00bc2ca346d@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
References: <20260311-dma-debug-overlap-v2-0-e00bc2ca346d@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 43F761A0018
X-Stat-Signature: ipxi9wg5imnba96t4wk7j8bf3jtjwz4e
X-HE-Tag: 1773256161-564773
X-HE-Meta: U2FsdGVkX19+Y4rsPqjhqzA+sEbrgrYIGn/Dr/SFvl/1HZh3yaEMJG0NOKEonxyi90SPt8WeO4dzt6rcr2CMrz6HWTxMVhrIlDWOczmtO20tbFthhJTmrlOTCFWNZXphdqQmvbBGC9zsfdmTDTfgSp83IwSa8TN70pSpPJHrfDCxPTMKRW0Qj756OgsGNtGdvQ6B9ro0fEhToRYf3VlZV52Vn8XMxwEf6ZrYxJhwIeGBkojXfG1NtQx3W0Ge4SkEPz0wYvsxKE+uXDNBWK9kC3PjX5QIDcdhe9hDBOGpglXT0yD9yCd4xpkYDZUo6P13bkLBU8oofDnP4f5txx/8DHXlnRlku/tgiynG0YQlVvwSOuqtZDhgxppS7vyb7z5K39q1gM0H4J2KV4d98ZVRUq58w7tZrOGPCtlo4MouGFFMXPvDiSabXs269iJCOeByzIgyPreznlQVto804EZ5TmuK149j/SPX6sJE8BIcBNF1j9MErFXFwXKINaPCye4Cp0Wd4MQHBr5PJG5BetHNGXPpT+8bS9QepROCDVNRtIrmFA7vMqDcvt2HfE5wmVgSd1TNgUszAmnR6QkvM21NlumpYCOnxxtWJq8a4Io7HgX9qCtKqjdmBkWcY9XLEDKUIj1C07inZAj0pF2Lk5ddxJpsLcY1fA6slH5iWv9GW72bABNCsz4rvaW+JBs1/5LikBlKkGPzykXEIi+56P30lVclqv8Ps4+UQdWPrlJkedwzVjyjmlujA5wlqR/4dFtEFNYtJ/r56VrjAyYkYIs7814sdUFP+BeYE9NRX55T2zaZ3N/DKHve2si0jFRR6QxbaLv4UijPOOqbiNFzwC1eDcKO5FhMU3Lqsh8fMT82n8rDiB37PL7hNd+qhe+hpaOcWzBEBy6vhCX/dq94QgYyw57bofkywr3P139OmWGAjup7AF6U2XRQDegfMF20W2FIPqUSPFwBouHVf/2nrh5
 EEr5bdGR
 HhTspLEeBeV9GxwPirdoUileShknFpImaejPd2Q88LeNIzP6ScyA2pLZL+bAfg6nsVqg2BGREowtoHPgzui1w36GuApjUtdy+lAj6B1UslNHar9SUPA81Ch2grEr/+e/fo8tG2QeI+wltNK1rwYkjVflGVZqNCsk7vact7xiMB3rsIqELPxT1cRH6oPOWIOkH9HXj61i64ln6tNivPyI1TRyI2CXwvn1Cy7oy/CSPFDuw+DQHmB7h1XHQqKUrc/6xDGDKUeg644Kq1oM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

The RDMA subsystem exposes DMA regions through the verbs interface, which
assumes a coherent system. Use the DMA_ATTR_REQUIRE_COHERENCE attribute to
ensure coherency and avoid taking the SWIOTLB path.

In addition, a given region may be exported multiple times, which will trigger
warnings about cacheline overlaps. These warnings are suppressed when using
the new attribute.

infiniband rocep8s0f0: mlx5_ib_reg_user_mr:1592:(pid 5812): start 0x2b28c000, iova 0x2b28c000, length 0x1000, access_flags 0x1
infiniband rocep8s0f0: mlx5_ib_reg_user_mr:1592:(pid 5812): start 0x2b28c001, iova 0x2b28c001, length 0xfff, access_flags 0x1
 ------------[ cut here ]------------
 DMA-API: mlx5_core 0000:08:00.0: cacheline tracking EEXIST, overlapping mappings aren't supported
 WARNING: kernel/dma/debug.c:620 at add_dma_entry+0x1bb/0x280, CPU#6: ibv_rc_pingpong/5812
 Modules linked in: veth xt_conntrack xt_MASQUERADE nf_conntrack_netlink nfnetlink iptable_nat nf_nat xt_addrtype br_netfilter rpcsec_gss_krb5 auth_rpcgss oid_registry overlay mlx5_fwctl zram zsmalloc mlx5_ib fuse rpcrdma rdma_ucm ib_uverbs ib_iser libiscsi scsi_transport_iscsi ib_umad rdma_cm ib_ipoib iw_cm ib_cm mlx5_core ib_core
 CPU: 6 UID: 2733 PID: 5812 Comm: ibv_rc_pingpong Tainted: G        W           6.19.0+ #129 PREEMPT
 Tainted: [W]=WARN
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
 RIP: 0010:add_dma_entry+0x1be/0x280
 Code: 8b 7b 10 48 85 ff 0f 84 c3 00 00 00 48 8b 6f 50 48 85 ed 75 03 48 8b 2f e8 ff 8e 6a 00 48 89 c6 48 8d 3d 55 ef 2d 01 48 89 ea <67> 48 0f b9 3a 48 85 db 74 1a 48 c7 c7 b0 00 2b 82 e8 9c 25 fd ff
 RSP: 0018:ff11000138717978 EFLAGS: 00010286
 RAX: ffffffffa02d7831 RBX: ff1100010246de00 RCX: 0000000000000000
 RDX: ff110001036fac30 RSI: ffffffffa02d7831 RDI: ffffffff82678650
 RBP: ff110001036fac30 R08: ff11000110dcb4a0 R09: ff11000110dcb478
 R10: 0000000000000000 R11: ffffffff824b30a8 R12: 0000000000000000
 R13: 00000000ffffffef R14: 0000000000000202 R15: ff1100010246de00
 FS:  00007f59b411c740(0000) GS:ff110008dcc99000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 00007ffe538f7000 CR3: 000000010e066005 CR4: 0000000000373eb0
 Call Trace:
  <TASK>
  debug_dma_map_sg+0x1b4/0x390
  __dma_map_sg_attrs+0x6d/0x1a0
  dma_map_sgtable+0x19/0x30
  ib_umem_get+0x254/0x380 [ib_uverbs]
  mlx5_ib_reg_user_mr+0x68/0x2a0 [mlx5_ib]
  ib_uverbs_reg_mr+0x17f/0x2a0 [ib_uverbs]
  ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0xc2/0x130 [ib_uverbs]
  ib_uverbs_cmd_verbs+0xa0b/0xae0 [ib_uverbs]
  ? ib_uverbs_handler_UVERBS_METHOD_QUERY_PORT_SPEED+0xe0/0xe0 [ib_uverbs]
  ? mmap_region+0x7a/0xb0
  ? do_mmap+0x3b8/0x5c0
  ib_uverbs_ioctl+0xa7/0x110 [ib_uverbs]
  __x64_sys_ioctl+0x14f/0x8b0
  ? ksys_mmap_pgoff+0xc5/0x190
  do_syscall_64+0x8c/0xbf0
  entry_SYSCALL_64_after_hwframe+0x4b/0x53
 RIP: 0033:0x7f59b430aeed
 Code: 04 25 28 00 00 00 48 89 45 c8 31 c0 48 8d 45 10 c7 45 b0 10 00 00 00 48 89 45 b8 48 8d 45 d0 48 89 45 c0 b8 10 00 00 00 0f 05 <89> c2 3d 00 f0 ff ff 77 1a 48 8b 45 c8 64 48 2b 04 25 28 00 00 00
 RSP: 002b:00007ffe538f9430 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
 RAX: ffffffffffffffda RBX: 00007ffe538f94c0 RCX: 00007f59b430aeed
 RDX: 00007ffe538f94e0 RSI: 00000000c0181b01 RDI: 0000000000000003
 RBP: 00007ffe538f9480 R08: 0000000000000028 R09: 00007ffe538f9684
 R10: 0000000000000001 R11: 0000000000000246 R12: 00007ffe538f9684
 R13: 000000000000000c R14: 000000002b28d170 R15: 000000000000000c
  </TASK>
 ---[ end trace 0000000000000000 ]---

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/core/umem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index cff4fcca2c345..edc34c69f0f23 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -55,7 +55,8 @@ static void __ib_umem_release(struct ib_device *dev, struct ib_umem *umem, int d
 
 	if (dirty)
 		ib_dma_unmap_sgtable_attrs(dev, &umem->sgt_append.sgt,
-					   DMA_BIDIRECTIONAL, 0);
+					   DMA_BIDIRECTIONAL,
+					   DMA_ATTR_REQUIRE_COHERENT);
 
 	for_each_sgtable_sg(&umem->sgt_append.sgt, sg, i) {
 		unpin_user_page_range_dirty_lock(sg_page(sg),
@@ -169,7 +170,7 @@ struct ib_umem *ib_umem_get(struct ib_device *device, unsigned long addr,
 	unsigned long lock_limit;
 	unsigned long new_pinned;
 	unsigned long cur_base;
-	unsigned long dma_attr = 0;
+	unsigned long dma_attr = DMA_ATTR_REQUIRE_COHERENT;
 	struct mm_struct *mm;
 	unsigned long npages;
 	int pinned, ret;

-- 
2.53.0


