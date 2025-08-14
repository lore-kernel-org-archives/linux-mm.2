Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C40ECA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 10:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B8A2900138; Thu, 14 Aug 2025 06:14:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0429E900121; Thu, 14 Aug 2025 06:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4C66900138; Thu, 14 Aug 2025 06:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CEAD4900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 06:14:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98FBA160586
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:51 +0000 (UTC)
X-FDA: 83774954382.27.9F3BC7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0E1B740008
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 10:14:49 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yjr61GWr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755166490; a=rsa-sha256;
	cv=none;
	b=5WJn04sMWdHaBDvpVWSPCi4ucpB06nlm8MyaRb1S0V7slUEDopXs/O9twy0rAPTB6oZAUo
	XtWLfMJh61TRMWeZL8//Z5m6mZTiPsHtwtkDMCwgUwhEEGbem2IOdAQHSpWm1r4SNWBNjE
	94khBivMlpWR46YZGfql86bxn66yqJw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Yjr61GWr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755166490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPxNQF8Cx+yhCu6yL4faxmro9U88DCzv8Ndb1qLzzQ0=;
	b=gHHpoNjCVjcg5VejsrsUqFTOlk/d2AYeQcg4rgf2vOJE10kyAOvWBuBEZsBTHs8iDqPwT+
	Zt4VP5Q9GujjSzeWJ9GbXMdAcahqMLEbXoda0z2nNaaC8xA+YdkcujZ6506lcHFHMvOfy4
	FWyU4JmLOfOWO5yy7zTS++BAhgeqdP0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8F9236020A;
	Thu, 14 Aug 2025 10:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB3EC4CEED;
	Thu, 14 Aug 2025 10:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755166489;
	bh=stLVV7BdINySQbyeqCDmRbXyWeQEecbuIkQ/rhX45FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yjr61GWrMpZlZVsXr5trn6jduj7CwGSyfxXeA06jORzsuA8yWJLjGdU0E33cfjQh3
	 Hmx937j1Z95EXTMOUcTvwDAO3vhf7bMaKYV/TFQIyfc9mvSdYnQef9iZHXZNqE0oto
	 jcvZA8NK73HDjVgX/hAwi/xQMDOAaVmOkY66NF2PR1cDhVoVMkjKM0ZK4TRAmvUgWx
	 xqpsC9wxH1QmETO7S0kHdNpKw2xEF/nOFmPE3YzJHCVYhyuyfoPUg+dVNC7Gx475X0
	 rMcX3zG9znpLtrX/5YzuL4HwLR540SE+s9lhJRS4wAN2T/i4QuJ6U2hv8YLNA/kK+q
	 abKechpUNU6VA==
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
Subject: [PATCH v2 14/16] block-dma: migrate to dma_map_phys instead of map_page
Date: Thu, 14 Aug 2025 13:13:32 +0300
Message-ID: <a48cbbc074bf11c92b29b547e44f495a4504ae9f.1755153054.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755153054.git.leon@kernel.org>
References: <cover.1755153054.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E1B740008
X-Stat-Signature: 4gbffrjxpqwgi4exrz9n3txgr6bmpg6g
X-HE-Tag: 1755166489-84008
X-HE-Meta: U2FsdGVkX18+5o1N3hBSwYdjQl8D9inyM12uGHDYgtcmkDM8KPYaCegJ9g8eVZ9rQaAi9wCOBW5WJqXtGXijOT+t6tJeZ28o2eTAiYciZXWaIVm2QlLy0z3ZVD9uzQ0DgxXlEXynhFktg8SwB1B0KNQZrshRmTPJnwmJngVWNzvZC5Tf1cg5bf0qdZpbBlJGvurYjHbj99BpqfVN+WPzwMwmuElDkXo+siMReW9gJc1G+EKR4eDnpJJnlxmlrKFqvgV2hvU3l4B65TztuuxzAwvVt75PkFkg8conZ7gZ64CmKK/IBia9geVOJDRkyIIEnYm7NifaqaPfu2+iNIzzthvOEt+exjJ60V2DGzeF5ssYEfk995SqJ/YynJPvfVTzxvVk7AJWRHxql1TXMxZC06xpJo9RXZTDkhSX6Vxj2WfF9++nwrZrwvcHHNidxbuq1/l5VMJQ/wFQYrEQnGBQFBl9qQpT2rmESUUz/aJhohj7Fp3fk9ISxQJBJGqAl3pb8dCWgsGOyJjeCCtJnBY7OOTVkD/JFNduRtCaIxvPLzj4/AMWNsA6i0Smz1j1jVvCtXkuBMGsh215U9ff1dPjGFktA2e8il1h0w+NBXqbN1Y9JISh2pfw2P4jrHy7xGaH4R4iCbW+/KKbACeZpvnVzdm24HkiJkQEZIRJK0Sydo96gckyLcl+rQHelVQ726F+1JIvIhTAkQUZ0sMxsEihkHPnw2nQechJOW2iM/p2q/7tFtSFNyH5WIR8pmxFqo2Ta37RjyJtiMNV1A+7AgtdNPL4hadG0Ho30tFNXsemXONjNhlrcCozgACdOnWG23U03PfhfHInz5o5Ear1Q2V7UxvoKRj9OAXekLigJuqYsGbkJ5YVlOWqdngmZJ2TEOz0VZzntNuP7egKmCSufNR8l9NCI747aUE2re0o+RUfEd9qeOSx6RDSut+MIraWJobHGuyiUNop8rNA++8rJ4a
 46MUG69z
 BbVGq9Qx86aRJ4GVPswFSSuzm6Jvu776qT2tfbUA9PFFRzcBWcO4MmVBfDgjHpJnDucqd1YUc+qruZFiy2raBTZ1dNd6svvLcYH2mPBxoehLErSPYNniJgNI5KK8KdQH4zUPFAjH3KYHDW7wMyJX/yMQChN+xc70P9CD7ovGP/gJq/BDAfoUzoi0M24sY6u6ZmXyOz673JSluI95V5lPPux3z3/e59hBFqBIKYDmjTigPZYY5PkOMhLG1JhAky8tev9SU1sjunZVnmA+SQQDTNH+QTQPltVDCGTZ4wn625LmO6HAEZ64695KcXAWvT+l2NBHX7XCdB5tDfQt/mk1cpVnsbt7n67IzFrn7
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


