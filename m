Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C8B606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:39:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZLxiR+T+
Received: by kanga.kvack.org (Postfix)
	id 7A4826B0ADB; Wed, 25 Nov 2026 16:39:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B4F6B0ADD; Wed, 25 Nov 2026 16:39:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 691986B0ADE; Wed, 25 Nov 2026 16:39:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3EA8F6B0ADB
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:39:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C59581A0106
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:22 +0000 (UTC)
X-FDA: 85474957764.26.A6D8D0D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1B785A000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZLxiR+T+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642761;
	b=w+ZYz/E5oxf40ISSkS0H6iw5frj6NGKIQLzh7On944QaBFxn/IYZBjALMWKL/2lDUtoy3z
	kKlCPcZXuNAHr/pTxEfwLtukBR8vbqe7xe613K1GQsl+mi+JdDI/1AtKPZyLk0mk+RocV/
	3wwkMYMJ6FlLGro5dkmaIm1wYoudwU4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dJBjtHj/U35Sno9olpkCbmU3J1nhzHn1TeUoFt7nUEY=;
	b=sfhyU59aPhb7wHiz+4injkuw++ts6w+X28Pyuis70dkApGluNQIsGp3Ue/HGmCqJhVG0FY
	NbBJte3W81jUa9TULtM1+QkJgq+ekEbc2wfkWilFKhuqNLlGSX8W+IAmI6zVcE6Y6FcxES
	ch7iD7jfWapBT+mHcX+m42atZq48+Sk=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZLxiR+T+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1071F430AC;
	Wed, 25 Nov 2026 21:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D9A51F000C6;
	Wed, 25 Nov 2026 21:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642759;
	bh=dJBjtHj/U35Sno9olpkCbmU3J1nhzHn1TeUoFt7nUEY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZLxiR+T+BsSHG3qnraIpxEnw1AKOgXqd27CskrcQcAzCnBPEROUGkHQ8M0dOTuEF2
	 v+HG/9GIvXXDfUR31xFyycfQ9BqVveug3KmxNw+/KUHejD9Dw8OxWGOT7AkAbAYqaT
	 Bs21TaIArqigX5/IgmXaw3xKR13el4OxMviNGy8OOXCDyLAW+ABLAZZbBJ7r0stztO
	 4ZEv3kwQgp8dwDKSvLjxBmW1Ewm+SI2tnMzo2CVHfUk7ACK07Kg7xPgzSFzRuheuRW
	 ngbOq2z34xaqRnUG5TtsT/BktFuqrdfK3SdlzvKrnRgA7O2Oxvd1C32/9p3Wcuxnu5
	 EZnqfS6cvgYpA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:10 +0000
Subject: [PATCH slab/for-next v2 09/14] iommu: specify SLAB_MAY_ACCOUNT for
 slab-backed page table caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-9-7c680f02a734@kernel.org>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Eric Dumazet <edumazet@kernel.org>, 
 Niklas Schnelle <schnelle@linux.ibm.com>, 
 Matthew Rosato <mjrosato@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Chen-Yu Tsai <wens@kernel.org>, Jernej Skrabec <jernej.skrabec@gmail.com>, 
 Samuel Holland <samuel@sholland.org>, linux-arm-kernel@lists.infradead.org, 
 iommu@lists.linux.dev, linux-s390@vger.kernel.org, 
 linux-sunxi@lists.linux.dev
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1B785A000B
X-Rspam-User:
X-Stat-Signature: 966apmxmoefrmt4bqskxf4jqaxt1ttc1
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795642760-16456
X-HE-Meta: U2FsdGVkX18cNoL16dmYRlo3y/yDLbWKXxArl8yptmsF1SwgopZ5UWU9AZAL9FhLU0msDKHPSZau3TZvzpyC6rU6RI2pxwPZMQYeYgHLN//dV4RqPn3QKNBQLkPSwKM/3dvwaa1eZ+zFrTN9TttUapC/+n/diztUAjlkEdTQ4ZMWriiXwqIEeFctUDEw2k1LRal1jfEEND13TY3yFSO97XALQvM4TqUsnMrpA38zS8M/WvLdMwS9Al4TyAQ19AsoUfrmM6ijAetbdgN8Sg/3tL2srEIYXe2qNQFZFSxxYSUOh5XhBO/n7A9rQSx78wy2ZTjlo+wrBHQ/Ph2TS65yE9zONu2EgggPZX4xkHts03MCIJIYxV0Fid9GfY4gAM6H2SceTbnExWjooNWfoae9hRKfB6Fukod5PWmib0cnqNByZqsLW2BhrisjqEF7nct7BLN7yfTjn40mgZ9PeqIUEtAV7hR/DmH5NFu3I580otq8W3B9+YxfWcXFGIbeo0xBul1Wz6zn23V5/KKbV3ZO0xJ/rzGy2WsM0h14tVi5vPXDRPdUBJwiQ6cZZRxqER4Xe5YcG4AFWpuzjs2MoOKbGz3+bEVLagIbwSrqXE0294TEVOStXHLEzzxEMn0UoY9/AYMu0T2VKqMaLQPB4ZhMIbfhaDyB1E/9rC4wB48WjeNBcmPuKPNhWnbG82xaprymBmx/zcVzhrzhFaFJyqFudALiXnoYib9sN8SPCiS6n5v3X0RCOV+KZoEzim7GoB8SiucgfsHw6bwYq4xzWCbTtD2FBgCuQdLTK3LJI0NkiAa0MSa6g6BsStBtEtMH8u2YFIEcJtW79WH70fDlOb2p1KhvDm6NuUioJI3sp+VyHAdTspr0LIuZpPNYdJHLsrWGcghiVCfEq58TRy0fBTgfyVquZ8oougysaaUsI3XWJkdZHcYPHiTVe5uLd8xWgKO1o3wr3WSMtUClkILLdLt
 TsU5CRS0
 foE4Q6vPxyvghOLZkJNLHierAVa7p5cbL50qxLvB6UXIrM860DNUrY3UmcDJR+dno+bfY1kXOMUNkc0kg2CMSSFOhLeyblQEbF3W7owUCdwPYr3XjQtrbVJ9KiOlxCXPIvXyWxWZe4Vyn7+NqaZgWMjC4x+L5gKV72vtlvhj9/9q7Bm7GMVcdjpcimtShAYszBgTX69AF5+8GVwb1M3Zq3h39ErCawByqou7oJr0ajRjA42TwvduKaZ3flPswpax4f2KoNxLzcZyscE99O3mC/S8QawurVx8H7LEE5TgFO8I4jp17IchRXlNYtrfh+y+qmubKTo4csk9JnRYnMuhCAVvXZsQGYawg7prkumxCIugHaHP1WERf9sdoOSIo/68R+lJuaKgzcyDEIFHatWdKqEJ7rRi3Acj/CE3KQ5WPCfNb6e1msdkKGWy6PRclpxsky3U71F+29+LDq16admpWP+e/X8SVOpOTQN3Nhq193FKJ4fGCVVmBlSZMWC+/ECZQAevePqmoGwhTiSq9t6CZ54hnMFqxURKweuUPcCMi+ttj3e/QjI4vZCXz+V/eV+XuNhvSmvq7JLv1RDNdyVXHgXQKPKqontU/tBEr3DoFezfjnfbcvO8umj8vm7s1uu59uQi5WaqZL4gc4m6+9zLe3QMiz+jfEG0fO2w/mJ+a1WWK7bZ4cttQJruB8F4v1FE5GzYK/J1OBNEBY/forGew+vEnNfbhPD/RHpn+o54YHl8eUvN0pic7QBEjW/C6AzJcrcisA2ieuhXsMNTIks6NleJJZmBa6fu1Wkq33an5We0+zx23+OfLsHcOme2B4IgXH4y52lOrZsXGuKIQd3mHmpb9yQYNBkq2PaNl/+wjUaCSnprtCqZvvTaMBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vfio, iommufd and vhost-vdpa call iommu_map() with GFP_KERNEL_ACCOUNT
and the gfp is passed down to the drivers' page table allocations.
Specify SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Paths:
  VFIO_IOMMU_MAP_DMA -> iommu_map(GFP_KERNEL_ACCOUNT)
    -> s390_iommu_map_pages() -> dma_walk_cpu_trans()
    -> kmem_cache_alloc(dma_{region,page}_table_cache)
  iommu_map(GFP_KERNEL_ACCOUNT) -> arm_v7s_map_pages()
    -> __arm_v7s_alloc_table() -> kmem_cache_zalloc(data->l2_tables)
  iommu_map(GFP_KERNEL_ACCOUNT) -> sun50i_iommu_map()
    -> sun50i_dte_get_page_table() -> kmem_cache_zalloc(iommu->pt_pool)

Cc: Will Deacon <will@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: "Joerg Roedel (AMD)" <joro@8bytes.org>
Cc: Niklas Schnelle <schnelle@linux.ibm.com>
Cc: Matthew Rosato <mjrosato@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Chen-Yu Tsai <wens@kernel.org>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: Samuel Holland <samuel@sholland.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: iommu@lists.linux.dev
Cc: linux-s390@vger.kernel.org
Cc: linux-sunxi@lists.linux.dev
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 drivers/iommu/io-pgtable-arm-v7s.c | 2 +-
 drivers/iommu/s390-iommu.c         | 4 ++--
 drivers/iommu/sun50i-iommu.c       | 3 ++-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/io-pgtable-arm-v7s.c b/drivers/iommu/io-pgtable-arm-v7s.c
index 1dbef8c55007..b544e5da237a 100644
--- a/drivers/iommu/io-pgtable-arm-v7s.c
+++ b/drivers/iommu/io-pgtable-arm-v7s.c
@@ -706,7 +706,7 @@ static struct io_pgtable *arm_v7s_alloc_pgtable(struct io_pgtable_cfg *cfg,
 	data->l2_tables = kmem_cache_create("io-pgtable_armv7s_l2",
 					    ARM_V7S_TABLE_SIZE(2, cfg),
 					    ARM_V7S_TABLE_SIZE(2, cfg),
-					    slab_flag, NULL);
+					    slab_flag | SLAB_MAY_ACCOUNT, NULL);
 	if (!data->l2_tables)
 		goto out_free_data;
 
diff --git a/drivers/iommu/s390-iommu.c b/drivers/iommu/s390-iommu.c
index a280ad4f63b7..467b97ec18dc 100644
--- a/drivers/iommu/s390-iommu.c
+++ b/drivers/iommu/s390-iommu.c
@@ -198,14 +198,14 @@ static int __init dma_alloc_cpu_table_caches(void)
 	dma_region_table_cache = kmem_cache_create("PCI_DMA_region_tables",
 						   ZPCI_TABLE_SIZE,
 						   ZPCI_TABLE_ALIGN,
-						   0, NULL);
+						   SLAB_MAY_ACCOUNT, NULL);
 	if (!dma_region_table_cache)
 		return -ENOMEM;
 
 	dma_page_table_cache = kmem_cache_create("PCI_DMA_page_tables",
 						 ZPCI_PT_SIZE,
 						 ZPCI_PT_ALIGN,
-						 0, NULL);
+						 SLAB_MAY_ACCOUNT, NULL);
 	if (!dma_page_table_cache) {
 		kmem_cache_destroy(dma_region_table_cache);
 		return -ENOMEM;
diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index acdccb7c9eef..604a357cc1fb 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -1011,7 +1011,8 @@ static int sun50i_iommu_probe(struct platform_device *pdev)
 
 	iommu->pt_pool = kmem_cache_create(dev_name(&pdev->dev),
 					   PT_SIZE, PT_SIZE,
-					   SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA32,
+					   SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA32 |
+					   SLAB_MAY_ACCOUNT,
 					   NULL);
 	if (!iommu->pt_pool)
 		return -ENOMEM;

-- 
2.54.0


