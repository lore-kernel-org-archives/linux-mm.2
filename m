Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1D4CC87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 12:44:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83E536B00BA; Mon,  4 Aug 2025 08:44:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EE986B00BB; Mon,  4 Aug 2025 08:44:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DDBB6B00BC; Mon,  4 Aug 2025 08:44:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 574126B00BA
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 08:44:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0C2BE140296
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:26 +0000 (UTC)
X-FDA: 83739043332.17.4EDD33E
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7039440003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 12:44:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CEWxy3DQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754311464; a=rsa-sha256;
	cv=none;
	b=YJ1tfrZx9GWQzFDAycXDGJGxX+76zTUt+eKKDnva8ZNvKw/o7CSKr2574vUxLBP+NtDYfP
	8okiELxUhQzpK7d3vnzQamK4C3zuq8oC5I/TEdbxMuBB12Ae9DGMke5o3Ac+1jKAmkUf0S
	d4C4r6O3E4DDTTOZUTZybMIBnvS5h8g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CEWxy3DQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754311464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VKxnKLgBXd3JK+l9/qE4iGFIXvnOntNCGlyh9TtKTfs=;
	b=SkgPmidkIOCAMhV2Li38k8yRGIPVzD5kfUpmKoE6GN9OqODACLQyPULEAaNj21AXbBNmCC
	uSO/Gn9WQbHBHh19hbjohxeph6phSLT0BmIPAHh0ZgjbB1pPH/y6Xf8BU/SXw9z8AxZ6NZ
	zS7gtnixOVKaZYPO2SpLI1KgpSM6Nt4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 91E5C5C5F4C;
	Mon,  4 Aug 2025 12:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D115C4CEE7;
	Mon,  4 Aug 2025 12:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754311463;
	bh=vHoVz+WsFzZyOWz8hKi3gaHzcDQnMM6K5YlppZB3S5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEWxy3DQJEv8tmWrU60JGu2vy2JC6Vy5gQ7dkMLe3WhDD80GhgtaPSi2T4O+uh/qX
	 dzCLBAG639t4BdY7iOVuiz/s1KjNeAuSDkQxAswKoB8Dlog8b4SWYXyCwMpjyJfJs/
	 N598nGgARAwbbzCyY7NB50l2J7JGzBArXzyzEB0gXQ+Arna+DrOW+E2PsAsdgJv7Pa
	 Xqf4bgAaoc0j7DzDpKnhtwqRE6JormvtT5/kXa44BjUbPKvgizXbhqf9ZKiiePFStu
	 qAJ3Rs9QlPzNZq5SwsxLYx3N0dkWN+PMHiDWxME92RHKujqBYmsalcvoVTj85/jbJK
	 SRTlNuuOgXchw==
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
Subject: [PATCH v1 14/16] block-dma: migrate to dma_map_phys instead of map_page
Date: Mon,  4 Aug 2025 15:42:48 +0300
Message-ID: <9b8454a8a24ace186a22242e218e4f4fed103fdd.1754292567.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1754292567.git.leon@kernel.org>
References: <cover.1754292567.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8gbxfn7mtzwjti4k7pcutc61iyepfdmx
X-Rspam-User: 
X-Rspamd-Queue-Id: 7039440003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754311464-578460
X-HE-Meta: U2FsdGVkX1/NtuyimRZkv5GEmSLfWr32ijYBClvJG5G45fs5yEUdj4xj3YiDX5ujZ1pNfNZq7pNDjqN03X871UuDUsyt4IVR5ofz3FNEslm2R21tIdpm0V9NKRnaU58xsb5DCzXK0iHlqHQ3Pn0xr092BUH0Fr2pg7N+st+uDtId4eNZDuUlPg1OWrANhtyaYCB/FZOA5U1e6NUc+2gv5GzGRs1//D5tVczqBV6ZWX5vf206aFuF/g/mAMD8jK3cugdyb9CNEoG050Eq/6ajgLM3nCMU4ZefARZySjnBZn8Y58B/znAl5POCJk1FfCc0wR7fLpikAELdaaeVtOaf4UjYRlHu6H8lh6Sjdx9OGz+zyECTFQLuj+qfv7megJwkjHJ3TcOWwBgG3wNlJqvnCS1koyAT2v325QMARTRU5pNL2+AwBNE3dRVopIF3bu+UQloXev7iu++hg26NXtWVUmPuCbepHJj0mynMjY8so+rrMlDOqW+B5Al6N/M/ibElNsOFglN9KlIRupJhbPYl8GnOXtZymrzUg3yh3vbMq+zMJEvClt7MuLaQPy3UUqyJ1njfYQHJqbQ6wNq+yoTSJG3r2STuLbRRMLAg2XnIVyc2rSbkZDYBYZANBBLbuXp9oml8T/sBmwoK++rlzWcKqLjgQdamf09u581VEDFUVy88UVHk8tFDfNQ6D8CDYyPBxc7oetpGpa5G68+NWPoPzMU9OiUwkt9WkXPkTdnOuNm4ob7wB5JfTFAEc0JR8ooIA4haSzXBMe04eXW6++zjsdEv3WAlKWu/rRPMsE4x4q5e8j65pdH7oBLo9NjtUhSP2Pb7weYeYjZ6ijY04r2gwhMoDZQ/ECVhW600ZZN5duEHeOSyHSyG6re9ZtSryPqy7D9iWqWmmP0Gjb+OHVp7tWpQvH/BxCzwlYbxNHD7JsBAArp553BJwvG/NKN6arYy2K45XUQmI8jlzd2SwZm
 3tUeWkLP
 aSTnTb09w4rQZOwQLRSA6LrMeFYF/bJJ7J3hshn5kNRqYMwQysLLdxg1YTfcTtQDU/BUNMKRW6zLLCLQyODhM8HRSbCNI+ZAUmlDmw6hRxzBxfRatUn+s8asB4ZwkhntWW4MBQUiVfzpdrSXaY6eD05TX4EQ4oWpQEHJpvDMVh42pb7R1fyq9NCzk8/F3krKGB+idWO9vzsVhVYsuBNrW5AHflPUfyzWd6OGYpRNktzqqTu8fY3cvrBlLUoi11dvJYS9fsn4/MOygvIRz5HfFAWIg9jKF9QkAYa9s+6huDe608a3yEkbHThW23BjDE56rgfC0kjZybi7T9G1lN5ptzIRLkrn8yYap18FC
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
index ad283017caef2..37e2142be4f7d 100644
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


