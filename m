Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C4F3CAC5BC
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 14:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD4A28E0003; Sun, 28 Sep 2025 10:51:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C85CF8E0001; Sun, 28 Sep 2025 10:51:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC28A8E0003; Sun, 28 Sep 2025 10:51:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACF9E8E0001
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 10:51:21 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 88C211D9DD4
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:21 +0000 (UTC)
X-FDA: 83938947162.15.B71A0CF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 084041C0008
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 14:51:19 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YqIHoQ4N;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759071080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6PHNkTon6loIiVG2CMz1974W1lahAasIrzDiMTv+uY=;
	b=xXGIIdP7Awa1JCQUteTxQ0HcU/AI1XmG7lZ1VhMGhlDEDA1sWtkRY9aMLYJlFsEHsn+gNd
	Dm1IPg8VMS4nGQyMpp7YRgfTqs+AmEWDfq4IUUrVSG09KeseYF5YcyebcNFv7mBbu+DJhN
	TGIFjZ+Nud97PgLEirGdK5kBOFAWhMM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759071080; a=rsa-sha256;
	cv=none;
	b=pfCoZg4bVKkKV51deQAlulevtIGG+gUs+rzVKpbye82hjmjkCb/W0FsP1s9BEIQ6v9EuXo
	qKWa/BucpgIZNsM2NIEdI7PM9ipeXmwEFB+uO5YEBCFla0KS3Oh4rTbIw/rnm07XWuFLUB
	IIFf9YaV7IpkO36hhy/xMyq2IO2IyII=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YqIHoQ4N;
	spf=pass (imf21.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BEA36217F;
	Sun, 28 Sep 2025 14:51:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D736C4CEF0;
	Sun, 28 Sep 2025 14:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759071079;
	bh=UDEaYl0OhzDARj37bjQqJ+X83+RxQVeSHSKiek/uf5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YqIHoQ4NCwYA2j/0dqZsjnS4YacHkAFLqvC2BzXTxNk1PU+2Pnb+U56ixrR26XkD7
	 e21A0rF+V0VcbfCfRX9x7hRZuU6eVZKx0+aUmIdfb40mIdT7C5HXSN7kHXMzwVpj3S
	 GpmCFFJuosFftkxWvKxw+NX8sTPYemceGo1wlNKb2VljArjONFW4yFPdcgRi+IxjPv
	 aXn0G4jaupYmeSAZQQDVTpmh9rqhvKX3t0Jpu9HjAsqwB4p97xuS+sOsYh/LSTCtx9
	 7ODkalKY3wtAonETDOQ5dDcO90TlZa7mKLv/z3ZUNU9GXFEgwwwdThIqMmBt8VeiSv
	 fIDfZDfu4c50A==
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
Subject: [PATCH v4 05/10] types: move phys_vec definition to common header
Date: Sun, 28 Sep 2025 17:50:15 +0300
Message-ID: <755063745aa413d7382dabba9bae91392cc9f1ef.1759070796.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1759070796.git.leon@kernel.org>
References: <cover.1759070796.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 084041C0008
X-Stat-Signature: ppmcg84ficfnjsg4p7b58bggybe5paom
X-Rspam-User: 
X-HE-Tag: 1759071079-225988
X-HE-Meta: U2FsdGVkX1+2TayfCs5PDxzTVXd/r4U3nTQKAZBezZkhd//DxgVbN0xyafktcLABqLtKuRgXZWMXWbvlk8GpdUrBvbQushmX4IntHKO8aeiiah9GjeS3SzFb5J4sgIpkrBEgo8fg7LbjTKaO7xynlhMhVV8NLagkaXV5d92QFEWxiQ1DrmgpHCuNUVsfY+YSLsfgemQpNdOEKa2UV/KSUtFLwM0vC5gq0Ed9ZqdCglsytIzNbKnxQXZrtBGh3jFJhof8WH7LyydUhMy+fTeF0U6YDgGiRWvJ3M/82hT6G/5kjbX9Pb53JK7CTjq8XalM5W2o7+SwbQS6sg7jjM2bxjk1m/Pmk65PXmSsXNoIaX3DVkg487fNoP3q/AL+RoLUfZQmhcYNGGw8MdgLTDHUPvLKBclEKWNJmcHetA12N7eHdsLV0KE6eUWE9j3X6bUkKGY428uisCvZCp1BF2l414k4yey19fcx6pQftiUDnDOu2Tn+J9iC4oA25gG0CUHugCoEhXWyothugo4u0pLrJBfSN78hBnBsBMSvh1JBN2cNa5Sh004uHK2dapiCLKW+y+5gv13m46WgRu6VhFGtwfLnIQLTglFdXX4RhHeX1J5w3GV9RzMbb4W1K7RpVDprjD/9bjyOz10sZcKNULQNDDCGYDi/ah49FhCR9gbIR2tcMhjvlEm17bOroMXeDvXQ20hf3h++CUd7rTTLUyXPJ0H5y4h8Odu5LYIM2rjU6/T+Zhp3BTjGJCueSrfvv8NtPUgTfQtnfLDI3yoLot8eVKiMzXATXlqKUjS+X+jYfwqixu7N7oEWRpFEf1IIRF2ghhj3T0a2ThcGLbWKVoW+3ifwyOrao2dNTRxi3RJZ/4KwP1Yc08zVzPJrHPUX0gZM5Y01NQrfBqf+cqogRNTQdZarJC/f2lS2q/dzzj2wOuP178g8V8FHpJ3+8VPJjHgbx71xRnTrbgJsWtaFDF/
 qM1D9a/N
 JIiiWwb0QBWQB1zel5r1Bm/h/EyhjM6ITgxCLu6mEJHUJOFpimMme1rcBhLRXSPaEoxk+XIBAfNzK8KCZfpwltRcQq7LkcvwgvwmlhEFmJbJbwQi4lScd94lAI+b6EdouIowPKMKyPTdYRj12eDKtgAtFNjN0gs2PfaThcPgZitUWQ9NX3QzZ1IrPsq6ekcY+vH6+jzViJ5O0kcX5hKmwjJq3gktiQWih8igAF/0W2ZJ4PYv2cye6ux8P+KNB9ZVzABhWau/bdJ9ZUS+uEC/zrOn1LA==
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
index 430e51ec494a..8d2646ab2795 100644
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
index 6dfdb8e8e4c3..2bc56681b2e6 100644
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


