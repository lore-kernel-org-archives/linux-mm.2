Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 458D0CA0EE6
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 17:55:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13009001C6; Thu, 14 Aug 2025 13:55:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEA1F900172; Thu, 14 Aug 2025 13:55:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B00BC9001C6; Thu, 14 Aug 2025 13:55:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9ACBB900172
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:55:09 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6D90A835BD
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:09 +0000 (UTC)
X-FDA: 83776114338.13.C071C03
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf08.hostedemail.com (Postfix) with ESMTP id C24B2160013
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 17:55:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MsbLK5kT;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755194107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPxNQF8Cx+yhCu6yL4faxmro9U88DCzv8Ndb1qLzzQ0=;
	b=fmpdeiMK50Q+rQhFsDWSm+/yaEl7hUKghrTDSR4D/QaWjQmhVHG6eT1u+uDNTSyvNtUcXG
	nIT4wk0w2xlSPBVhMxKBf0kQVEfC61p5hxd61JAnI1YynuZO0ikQxnydtBuODRyAstVA3w
	QP/U4hQcBFJOgK+Eu78w8v4lzGDMbrM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MsbLK5kT;
	spf=pass (imf08.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755194107; a=rsa-sha256;
	cv=none;
	b=gAmoBa++j9CbHZh5Ek498LAXp0Flo9zY62t6a+53KXazRnvoPZEefauhunoi3a9wCiLhp/
	lyYHzqugPOcqG6MAOHd+7QU0klcCGJTmZkK7qNuvS2quYsiRJYaMNJsvlziI8dpmQfiHjL
	jqJb6vmrxwwOUxzKmXCLqe8xkuAurz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id CB8B25C720C;
	Thu, 14 Aug 2025 17:55:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3833C4CEED;
	Thu, 14 Aug 2025 17:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755194106;
	bh=stLVV7BdINySQbyeqCDmRbXyWeQEecbuIkQ/rhX45FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MsbLK5kT7aVmvA8nYsB7sMG5ChwILEdiBjYxFpaN32F94VWo3aNRqEpCWyi0ZcA9p
	 gzrDDZo2miJ4WqgfgWiIO+xYs26NKRu0sCKEs/zjyoblbT43qDpduEb0902V5dsZLe
	 LoqDmkZ4tJUci0ASJStCM0akDlv9hkIs16pFwCUDhbDeO9/8jSYgcXuHYjX5JddxcS
	 RXuhev7mQMkvVDqD2zAL8EZxehXvCtT7xSvrfSbfXftLTMASDzbFLrji9Uwj/1hHdJ
	 +mpU742EZEFVDRxgLoKCb3gccSJQtbzkhw5GrIX4UPYImmbiz1iMotRsRFcm4hk2C3
	 KDHPuzC3NM7Mg==
From: Leon Romanovsky <leon@kernel.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>,
	Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com,
	Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: [PATCH v3 14/16] block-dma: migrate to dma_map_phys instead of map_page
Date: Thu, 14 Aug 2025 20:54:05 +0300
Message-ID: <d05ac5a700b008577a5740c99fc1ccd24c8e1359.1755193625.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755193625.git.leon@kernel.org>
References: <cover.1755193625.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: crqcgawir46jcty5bfhfc8mrjsrc64r6
X-Rspam-User: 
X-Rspamd-Queue-Id: C24B2160013
X-Rspamd-Server: rspam01
X-HE-Tag: 1755194107-53417
X-HE-Meta: U2FsdGVkX19/MCNDA7egeGA81W7ptNQGrWJilIxqxBE+0y4KjbfK3KJ1AEAPx699/0Rz4zvU1fuccu9q+fPDjlkUGboBu7chdo4OH2Y3WHuQsGMZ6Uz/+wViXYctAGnDhXFzmKK/IEUOzEcLolHdza3QithrczArCxrhwDnY3PNuhaHWNtjMjoGiMR/x8Y7RwCeIXPK3svytTgYdiry37HYItT58ytUyMfiuFkYrjVZXncgYRczS8TpmIt1PZTcRxI0nmTc+uVegUOv1KJQtClJwpYBQC6/eWcf89UFQksVtFMX3asTKr01idU9bmUS6IP67edlbjA8pmYkiByDnvniJ3w35Fc3QxaH2eP1QY0vhgNlLEtADzi6y+z1sQlYIytH7rL8N2mRgm+NmoYxSHL3enJlHA2KJmFhb27dXlIuyucvEErIryj3gc7z/bFApSKfQobudNcVCftNfSXcpOLaUFLRuE7zBc7bkXbH8nnCz8e+JWKCxljYXCQHtotnvlrHd5BWjj0UI26EmZzNAU+hnbkYRH0ohvYTFbX+IxGIiIFTtS/bkAD/tmPn9ZkLKMpcdV8Sql+f6havSXaYdSDqJ4dOrmAIBkuszjrlIIA49SiCj4p7qQeWtRKq8OzZ3RdtdnnRQ8GeOEtN5jal+47A3FAQGuEhLNEHWL1mQBPC/PW1DYi+mwaMwd+jq7/MZLHTq1HK6iQ7Jl6QFbNo8xNqL6e55KhqxYL+LjGVCLQrPBrziXZCC+agsR0TyPacNX671lkAcaaiU8pAuv3OvXCVlTy3tKEFvGp13nj98aKrfhuSJ7QMVzTkZexLglYeKHpWBYA8rUe6KshOyFWLlriMKCQcWY8ILdAGiAhRFdhl+DWPhW4Jgc75Xo6B/pH3bdR8Xry6ZYqaDJvo2KACeeh08+/O4XlJFyaLQJxjP3qbHwRCGxTwagUbKCQ0QtUNZ/Sj//7CwS6djqRy1oA0
 LMzA1THC
 cdcdda1E9BwyzZ4i6SweoB2FitIcDK6SL+C+4AZTwM/TQ0nFP8XwZEshm4c2jv/VKGG8iGKhi6rw7sYGd9vXIorYMnJxmC0S8px6ClM8cMkPOXSSO3tYBYWtCw3QpY9fIIupIP5s7zGt53zZJ3UTQ92aW73f1RVVqHb176SNBdvSBUXAWoc7VkH9wsMkjD5xA7FFkWv9q9Vhjuk9WLDQEkRx7ETIfi2a9cE0x9NtrnT7JNjTmuHlODyVbW+PgzcuEWq59b5t9qQn/6CACWlwluIAKXS5amzltfxL0c+DqdLXzDODwv0Bn9SbgIJrufMc4ZEYY4RUBrvJpJFNlQtLzHP+mDnRtrlAAITeI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Leon Romanovsky <leonro@nvidia.com>

After introduction of dma_map_phys(), there is no need to convert
from physical address to struct page in order to map page. So let's
use it directly.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 block/blk-mq-dma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq-dma.c b/block/blk-mq-dma.c
index ad283017caef..37e2142be4f7 100644
--- a/block/blk-mq-dma.c
+++ b/block/blk-mq-dma.c
@@ -87,8 +87,8 @@ static bool blk_dma_map_bus(struct blk_dma_iter *iter, struct phys_vec *vec)
 static bool blk_dma_map_direct(struct request *req, struct device *dma_dev,
 		struct blk_dma_iter *iter, struct phys_vec *vec)
 {
-	iter->addr = dma_map_page(dma_dev, phys_to_page(vec->paddr),
-			offset_in_page(vec->paddr), vec->len, rq_dma_dir(req));
+	iter->addr = dma_map_phys(dma_dev, vec->paddr, vec->len,
+			rq_dma_dir(req), 0);
 	if (dma_mapping_error(dma_dev, iter->addr)) {
 		iter->status = BLK_STS_RESOURCE;
 		return false;
-- 
2.50.1


