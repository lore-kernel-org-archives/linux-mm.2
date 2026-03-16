Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 550DAF53D8B
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 19:07:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDBFD6B0358; Mon, 16 Mar 2026 15:07:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB9F66B035A; Mon, 16 Mar 2026 15:07:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7B646B035B; Mon, 16 Mar 2026 15:07:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95A896B0358
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 15:07:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64E0A140475
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:37 +0000 (UTC)
X-FDA: 84552860154.24.2AF886B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id AD555100011
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 19:07:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NNO3FIgk;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773688055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ypDePNy6mGpQJRuwxLyroPlqWE9vedjHwD9Zg/H8B/A=;
	b=jvy3GhNFJ+Ht1U448oPDuE8eJTqigD1OHXvP+vZ7xYJ/4TyYjuA/jXqqBxuHoCPIVAi/4i
	0rK+9C+v2nvrOQuUE55LG1yBVaTFMJhHRe8lmloi2d1sBSNmCWC07Z2rJBdkw/tPb02g+8
	jlTbsX2WDI7qZeXnbfXU3Yd2MuDmnu0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NNO3FIgk;
	spf=pass (imf05.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773688055; a=rsa-sha256;
	cv=none;
	b=MXEsrvvxRRmWl2xgKa5HIfP6YfbP45JsYNSJRtokMu/aikEmo/WWBs0h9Wklsc41hQKnmC
	UOEDStKnYt7ukDhzbKTL4rE9HSwrRYaeJUYfSS4AeF5nI9KALuxOdd7Jcf2WgD80MJPJDL
	5RJODw1/hsvsXBNfx33ikOCed/A3qNc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EC1560097;
	Mon, 16 Mar 2026 19:07:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD275C19421;
	Mon, 16 Mar 2026 19:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773688054;
	bh=ZkJ7sb914J7dZHEWxzQioljT/jpfozBIBOswC8fIMs0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NNO3FIgkhb+y967ZSuAWqgsqOZQE2Kc/rsldvSc0SwyJwpwu2bCx1PvpILU/J86hp
	 NfBzEZXDmV98wlv/ffIQgdwhHztXFTt+g3U0RLvjGkhN+f4BsYd28fLZex1CrA1XlB
	 CCTDuy2I1iL8QNuQJ90dXq2xy6yrOshrVwaRD0vTwRSHSH5OqDAZ1qxFYSxllkvzmr
	 f3bnxtz9wcGL6ZCf43uZYzcV9g6RGy1QlTvNxYXF5UxbgQFvO561djTIiriMsUvpzy
	 6crqilxWMX46V0c6IBlZp8AO0wfKa3LPom6Cejyi73BlCsEY1APtnWtUcxhj7jhv4O
	 qbxlfvx/E2HbQ==
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
	linux-mm@kvack.org,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 7/8] RDMA/umem: Tell DMA mapping that UMEM requires coherency
Date: Mon, 16 Mar 2026 21:06:51 +0200
Message-ID: <20260316-dma-debug-overlap-v3-7-1dde90a7f08b@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
References: <20260316-dma-debug-overlap-v3-0-1dde90a7f08b@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.15-dev-18f8f
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AD555100011
X-Stat-Signature: cj631bqt7axfedofbhxd13gp8ykwi91p
X-Rspam-User: 
X-HE-Tag: 1773688055-242699
X-HE-Meta: U2FsdGVkX18ul5FIweTehTVIy23rNISfmMLsWRtFjafZT0I7a8CMts4YG4MEOVUcWzp8FfmQAcYP3+5TtKGJ7+330ioq9OG4UYeMp2F2gy4px00keazXgKrw7sYW0RvcKSdlmLvWQPzcFYle30HYI205iEpZTKLaEna1Hdh+T22dYuML9eR2yiiS7HaoDKZaSbpCQCk96BsKL9abNNxfmWggEjW6JcmH97CmqnDckzY0NqZ2MC7SCHbZhqq01l7+mN+0PovntuIy4O4xgTtCs/z8Yn0IYNQHvysMpNBdURRAnc2jBXKfnD96qfuxCpfHbfFenFbs10tlBbjNu+edflUuXUxH9BW2l/klo+gQdnVAxHo4oXi2MJaG2fMzGNQO23Occt/bUUdATU58eKUW1w6hQcsDVsw97BgP8/I+aHAfiEddFa+Zamk53iyjbFL9bMg0lobymtC3rapgvF0ioYUg77sSdeRRpSEZUIdmPntiq5b3dWbk3jmeyFuYWpWejgqwTyXM1flG1uRdMyRXCxO5bpRyzxVb3HhjL/2ulge+RdK+quDpIUxaZeTvoKgummrnh41pdme0ytnUZ/LI0P8KgP3aIrtlx90iXFooMYAb3Q8xkO9aIlvorKBuWmD41Ey+TBkKFBSvgBYi3OimnNpbWv4H7qDeuhtY+nJ/NflcTDDthgyyu4l5xM9OEvbKHv8Swfn7N6T5/DjlPWuTd20uotA+d+7iiVfJIIGJhiC1U0dK0hkww0VtTkDITRYW7zGDWi6R39GeaeG9LqWIkhTlMRGZA5IMybYNwKoi7MS1THRWqJ7Nam83bFkTA0wLwBwODsIncCX7Kl/7d8BL+Kskdq9Gv8ry2u/nE82bnhvlzzGnhXiumITCWx+CmvUzky03RLmjtYCq/MuDWMPQwCo0MDBusSt6zA5lWrdehc3LfoN37Ntc7T4G+Iw/8xZAgUpYiJXOdul2FiachHU
 kSxjbWVj
 5mK8frsWQqPPcxCqpqiMINUbOvNGYCYmVYgLcZ6WtiopUiIGdA5+qr+2m1oVuVjYmyPP6DZ1RpYEBPKCbQrFLlKN6jG2s9PV89Veh0tf5kDqspzqYHtDhYWppPh/49J/ZetsjBhHRu42MOYXCQCcaSYwGRp/FCVg096rIibieL85hh1KCarm8Xz9YvVJUl47hCnAYUQGSQdg1m19xWfqelJrlhWVIjm/GMTcSoC7oMcOb7Z4ut3xqs02H0y9811tHVzb9F6PwYC6FD/+X8IpRTjX5MxTTXhL8fZdn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

The RDMA subsystem exposes DMA regions through the verbs interface, which
assumes a coherent system. Use the DMA_ATTR_REQUIRE_COHERENCE attribute
to ensure coherency and avoid taking the SWIOTLB path.

The RDMA verbs programming model resembles HMM and assumes concurrent DMA
and CPU access to userspace memory. The hardware and programming model
support "one-sided" operations initiated remotely without any local CPU
involvement or notification. These include ATOMIC compare/swap, READ, and
WRITE. A remote CPU can use these operations to traverse data structures,
manipulate locks, and perform similar tasks without the host CPU’s
awareness. If SWIOTLB substitutes memory or DMA is not cache coherent,
these use cases break entirely.

In-kernel RDMA is fine with incoherent mappings because kernel users do
not rely on one-sided operations in ways that would expose these issues.

A given region may also be exported multiple times, which can trigger
warnings about cacheline overlaps. These warnings are suppressed when the
new attribute is used.

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

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
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


