Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B1FBCAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 13:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FE378E000B; Thu, 25 Sep 2025 09:18:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 880158E0001; Thu, 25 Sep 2025 09:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E428E000B; Thu, 25 Sep 2025 09:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 654FD8E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 09:18:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36DFFB700E
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:48 +0000 (UTC)
X-FDA: 83927827536.27.DF74797
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 88BC4180003
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 13:18:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bzKG8rz/";
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758806326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zd1DHGtlXx2xZew3POQGC53F9AdCL5PolyCWESgyYu0=;
	b=TcES0f3P0HFKoklwY8HyogCj0UCpFhKUuOJX0AuO81aPghVlJ3guDtcasSANeUDabfBbIM
	EVHrkE3af+XebynnrgsDj+dWaycXHEUCJgilsGxRsOONtmzq2kUxafxvXubUSpxSIsqp+3
	j6Ym4W8KlpzIefXkQX6Wvd8DLi6xo3w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758806326; a=rsa-sha256;
	cv=none;
	b=wd6FLCGJyyruUrIcED91n9SAC3DJ6TgybPjF5qu6k3DVEF5vyGRlcmCGGbF6YtcPJx7yDC
	zhkrcyN+WMetBz13RcWqjifgrqMJMGtI7x0t2DrbMu/sHAeAp2fEtrkl2W31TPBZT9t6w1
	yQJuulQOKOwZ2OOn6n6P8zWJ7Q3RLiA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="bzKG8rz/";
	spf=pass (imf16.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F74843C66;
	Thu, 25 Sep 2025 13:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938F6C4CEF5;
	Thu, 25 Sep 2025 13:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758806325;
	bh=4Zq6h9bZhtbBadNPN71BbedaIVCHib6EpkAfWXyEd4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzKG8rz/enFK/kA4HnAGYMksgeq61FavbJCJcIx5n3L9m8euwOV7Eo/WkBc9Kc21/
	 EFoUq9FbsgK1yYJswKmN8/9l0vK+3Cjd/U8ww8dKSs1guV0ZUjZePE/+XumsZtA2Dk
	 Rw5Cgsn3j+mzndkuY3fms2ZnFStMKn0PNNmWYuZXecSbmFpcE4aWb2q3RqWm2gB2yg
	 vMmg7IaKXLNslgkNeYTHTpCOYb7KCBWq+x0dZ2uTxR01tW1q4zPHBY1FrtTc8It3s4
	 qoF5VTYtcIFgmzTvu2fN4nxp9hIxgvJ27TG9zFguHAUHswsjrU8HJc+P2FNuz7+4WF
	 6GprLm0nARPcg==
From: Leon Romanovsky <leon@kernel.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 05/10] types: move phys_vec definition to common header
Date: Thu, 25 Sep 2025 16:14:33 +0300
Message-ID: <ec07dcf39182019be4e2c0be46e977c073ee3763.1758804980.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1758804980.git.leon@kernel.org>
References: <cover.1758804980.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 88BC4180003
X-Stat-Signature: cpz4y3dcisqmm6dcdtotwhbfs9okrw5h
X-Rspam-User: 
X-HE-Tag: 1758806326-621361
X-HE-Meta: U2FsdGVkX1/h0ViYPaPQm6EtTmzGmwm7gyjUw4I/O0vBq5g+L33WvH91vzdEgjVFpl/GEkKIYNd875W+3Ig5BhZeHjqVDBCZwyFWxWs2ryxq7eh32duGlb5NrGnhfngMlLnoBcHpUm9yNzhkeVrkgXCS1S+IYbHa3OcmRdf2UfHM9uZ4YeCWzpr4M996keta1BwRX6dt34ZyiB080w4CsvmWeInj8vUggf34PD5iEJQGh9yvHoSEMdDo+uCvcKiV9wYmhgrQYKwmw1AQZj9hK8m3+ZdXqEt/QihFHZyin8zOgPG41a0EYknV02sJJakuhsexhzlUPOkj8O7TGevrRscT4tOnV26MjHRTmY0loXxrg4Nh1xD9ytSj8t1tN90r0Da+HahFGWCakn0S7tNZ7dt//BJiBURL7UHXX2Rz+MFIOn4ak0QHNHD6Y/BLt6sLZ6f7KDSVa2iTa5I4fBsrIQQc2XDht0lV4xhidA2eFq+t2FD201pHtWv4ubZRw8Mt+KXL6KmtXsB+yp7OnKi0bxviIOA20Jw+tAhyscDYGhvOQWyAP3FqbWdw6k/+HesGjyw48YUY1r7hPZeQRDt2HmlmSDvSbEbPqAEe00IfEnYgMekat5h8nrmNHXlgOR2V/4nkmfrXd0Tr0k7V7ZEOxUR4NeLe6cTSxgD36KUXxJcN1TWGe9b/I3BWjpLviQE/OgXlllrzmqqh8z6qWBXc/a8X4/2/FGYchyuzrqDa2a4P8DPu1/A336xmLbFJ/zDAucvgsEipwDLSZwRhsv3KE30ZYY1abICEgAdq89NsUEmUPSaIWccv/eWMDBFyhuhIcqMFGr5HuzDvuPokrrjV8YumCE6Ed5sgLcm5FZf7ikFDRWZncIOE8BAXBoczWImP5WcKe5CTcpwEG+lLozfPnbeigxhTgW7SPh/2fQDjc3d4A9eniYZ1yclHTLWnRAf83bNL4lm5iV4+BXUL6iL
 0hNBBfV6
 BdbnywP5M2kxYbYykBcAOX8/RCtazHC33EW5LE4FyogNqaN20+KQiN+d6klf17khkQ81FhSeYPmKxivRX75aWYjbTu5TGJY4YGQGmXuuHo4xwY15uK1oecVkOp54rTQ/hNE1Yd6qCRnSmgfFRMaIPIlsbjq+lNsxf2Yjck4lyYxj657z08bD+VU4fjisNKp7L9cvf9IzpC3oP0gkMuvfY5GahVYEC7bZuRqRdXWDamvDCTMeD85SoHrbmP4zcE4UChVyC0l7+EON6zh0yQoblETN0GA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

Move the struct phys_vec definition from block/blk-mq-dma.c to
include/linux/types.h to make it available for use across the kernel.

The phys_vec structure represents a physical address range with a
length, which is used by the new physical address-based DMA mapping
API. This structure is already used by the block layer and will be
needed by upcoming VFIO patches for dma-buf operations.

Moving this definition to types.h provides a centralized location
for this common data structure and eliminates code duplication
across subsystems that need to work with physical address ranges.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-mq-dma.c    | 5 -----
 include/linux/types.h | 5 +++++
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index 430e51ec494a6..8d2646ab27953 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -5,11 +5,6 @@
 #include <linux/blk-mq-dma.h>
 #include "blk.h"
 
-struct phys_vec {
-	phys_addr_t	paddr;
-	u32		len;
-};
-
 static bool blk_map_iter_next(struct request *req, struct req_iterator *iter,
 			      struct phys_vec *vec)
 {
diff --git a/include/linux/types.h b/include/linux/types.h
index 6dfdb8e8e4c35..2bc56681b2e62 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -170,6 +170,11 @@ typedef u64 phys_addr_t;
 typedef u32 phys_addr_t;
 #endif
 
+struct phys_vec {
+	phys_addr_t	paddr;
+	u32		len;
+};
+
 typedef phys_addr_t resource_size_t;
 
 /*
-- 
2.51.0


