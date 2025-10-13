Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5700ACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 15:27:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F9718E005B; Mon, 13 Oct 2025 11:27:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AA448E004E; Mon, 13 Oct 2025 11:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7948E005B; Mon, 13 Oct 2025 11:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D61C8E004E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 11:27:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4AFA31A0439
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:27:01 +0000 (UTC)
X-FDA: 83993469042.04.8F53B52
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D36B6120002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 15:26:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VBFGKDqN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760369219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ldZuz/4N+wsldl2BKi+pecmRv5c3pRjmppa5VjHLQso=;
	b=p7LGZFdgls28syE/Muu9bLZR5Ku7zA1IDP7+G31DzH1BR+dyOjP4y7WAmM/gZYSaK977QB
	vN7dmQy8lf+e0/dLrcLx8p8WrjSqwxou96DMApxzrHcX4BeIXr9caCAc7xaG6BQBXrOcNi
	qkiJNOrGR2eL/zHsguBJcNpEbrqxWP8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760369219; a=rsa-sha256;
	cv=none;
	b=03Kn0bnzkjKNUGNKFqaq08NU+/14OChB4rc2LjQJ9HxsmWNexxsZetfJAHFuh/REkrp/TR
	SLD0Snu576FtOwlAdsP2qFIyodpqZ8xNeGMlF89YswDmnmos0V/UBTJKagftdxXeMMak8T
	9tdljCqQZcPffNsKuZyK1vjB3xKA+y4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VBFGKDqN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 622B161E0C;
	Mon, 13 Oct 2025 15:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7D4C116B1;
	Mon, 13 Oct 2025 15:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760369219;
	bh=gP55VKbohdKUFjUIbdAFjXKOGHoX+x5EdhnEOLcQ7QQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBFGKDqNBy0xJePjSPwIh5MtWNEQFwHsevMHmHcBV5qcPGuvqZid9em7RPLMiGq4F
	 qMKY9SyKL0NciEAq/rYuF6EbgGRndYQPjYeO1iksCcDIkldZu3fY3/LHnrcZfqiUoI
	 NdYO1nup+k9vZEqA6weRmQgJwydWGadQODFVV3DfW67xHpUiNJBRwdhnymVPvrcTSR
	 tH5XSM9HsbPSrJ6uJQ3dBSx6Ibw2Ntpo6Zp+cD3Tq6UbfdvZYV2gC2qOeqaw+Y0Z1A
	 aQxgK4+gGQdcDvgKLXN5LdMAbgH60H5UulKgzaY0+9s2yaAome6GXMye0HSqbEAOEj
	 ulYUgjpNsmsMw==
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
Subject: [PATCH v5 5/9] types: move phys_vec definition to common header
Date: Mon, 13 Oct 2025 18:26:07 +0300
Message-ID: <b520e4a2b7b6e0c873d4787aca400ca03821f8aa.1760368250.git.leon@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1760368250.git.leon@kernel.org>
References: <cover.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: kh3cwhwbzj6aj55o7mjp77tdc9r4eypx
X-Rspam-User: 
X-Rspamd-Queue-Id: D36B6120002
X-HE-Tag: 1760369219-142522
X-HE-Meta: U2FsdGVkX19OAiB597udWzZ+8+cXOoPOjAyM1hTZ8wVSD3foeXQE9rBTh+Fu9DrXG0SYRZnoMhrwms8jmjECCdA8VNhrkh1kp73TmYz9JNMI8psbfjGJr1Vxz2u2ds/e9yXKprHsCZTIcVRI4FypacO9V/EhXqg55OhtfaBNiCt/CcOHkQZzd1I1GRyB+3dpSN6brhJaSXA5Z4G/cABbk9gb36KsbT8nsSvsHl8BlRcgudesHlVBYo30ccVIxlv8Sk18zm/AXTjZiVrErFdSu79ZzmdRzHi5uh9mosHTpLycrU2ertg2VEJGoddr8XA2x1brZK5lC5m7y9lOs9sv/4Kbu/zXeF3rKjhP+0KJBEU3JNeRHDfvq0ObmbjAARc8rRavFCH/xoDA/CYxSYohnVqQJ81axSk4kGO41kQgV2Hu0yDPSqDPj3/mi2m/GDdcbhF3GK1xSfFL03TPKyp/hNsAelF9fU0YatjAVUklpi436OhLu2rvY9f8zB1ybTLdSEoXg2jxJXOddAmKr+L5c12DrMyWqPAOLhwEEfjA094WrO9pGyI+Pdx6wn22a9Rdkw+H+sFTv5XrJ1mh/gaMjY7n1LpPn+PRUrFFY4nEHShmOlizYDlBCDcuk3wzshJ6omvg8aJB5X09saGnLx70oN0rasrg+P/wHkB3Y7vKitzilwnZcn6hP/ERqCgufPIaJwYJPoEppQJoUPo9M27urhMOjvazW/zfflsStFH3TGl8axdMni1Qc2Md/gIojeEodyO4AHGZZEjXrli+whQvM6fJJdVP/2O+t/oCKiSV6xV9u6rS6i801Ke8p5gmRFOrtr4HZJAf1FU0UkPoa4PA9BCsQPzrEb74Ip5T4IEoSCYCWqY1eQgvFf7iXepjzxzi0NPcjBWQM1ezQtKAccNdAG8iyr4DrS+BrCNCFrhOuFcWV4TOJzc4KtzASj+EFXQqclFIrtof2rCepBwmSEB
 kE1+hkXP
 fajiEBbczfGPGLTg=
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
index badef1d925b2..38f5c34ca223 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -6,11 +6,6 @@
 #include <linux/blk-mq-dma.h>
 #include "blk.h"
 
-struct phys_vec {
-	phys_addr_t	paddr;
-	u32		len;
-};
-
 static bool __blk_map_iter_next(struct blk_map_iter *iter)
 {
 	if (iter->iter.bi_size)
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


