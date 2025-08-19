Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91B0BCA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 17:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30F148E0044; Tue, 19 Aug 2025 13:38:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24FEA8E0005; Tue, 19 Aug 2025 13:38:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EBC48E0044; Tue, 19 Aug 2025 13:38:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EBFA58E0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 13:38:44 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B5EE8C0162
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:44 +0000 (UTC)
X-FDA: 83794216968.28.360DC77
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 16D4520007
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 17:38:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QF95AAuh;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755625123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XPxNQF8Cx+yhCu6yL4faxmro9U88DCzv8Ndb1qLzzQ0=;
	b=taKwMWXxHTbQPOP/11wLFKWi6sUN254OVNuHufnMimnjQ5Qk55dMeLBOw3ZByVLtXV1i7g
	fhgMd8+TWLYwUbgkQwZ0Ir2TObJEQTKaPBKRBQwF0VXmpWcAKhjmos3uHYFxfi+7Lh1nhh
	RTjQdSJ2Pj1Vbv5Dw6FEgjNd/fVkfcA=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QF95AAuh;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755625123; a=rsa-sha256;
	cv=none;
	b=l6ygt7fKTH9JGC38ZRvlQ49FWBawIcvZQVCFrFwujVdbmAeVnRLlC2XnAYvlI8IRJxwMLZ
	CCZRjSrNim/7wqTWwTXZ/GJ4wEvixUjyu5ZLFUq87/lPDWsDeMrn2hu4q1W9qM+zPwhTjn
	wJWKeokWgG4JyhuVaCTMmpSak5lafXg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7DFD3613EF;
	Tue, 19 Aug 2025 17:38:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7E8DC113D0;
	Tue, 19 Aug 2025 17:38:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755625122;
	bh=stLVV7BdINySQbyeqCDmRbXyWeQEecbuIkQ/rhX45FU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QF95AAuhc8feQn+SEx82Pkl7/uTlNhnB5cHYHMn4haBNk3mIGB32W95xHVkQetyzQ
	 l5pjdHoqmA32dwMVHHl2ireizeQrHrNOOpU6veVyXb4NV0jh1tYHCTnC8dcn2zvtTY
	 J4nrUx7NhDiTec8s4jDArKOAkTIjbwvKXPPen+Vd16+uFXzd7usqZLmgr9JbeXZ1Jn
	 WjodL0NO0sJNloB+WXRZ6xIN7Ll+mPyFWx7P66aJjQZw9otjgjVcZKNrK0y+CcuICc
	 ddwwW0q2gx9LzWpv+xxfN0uj6Ze8uJX3Jlyv58Oh1O5dwZ9g8LdLLurbrm7l0u9gfU
	 vhh2Z4HWzRNIw==
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
Subject: [PATCH v4 14/16] block-dma: migrate to dma_map_phys instead of map_page
Date: Tue, 19 Aug 2025 20:36:58 +0300
Message-ID: <22b824931bc8ba090979ab902e4c1c2ec8327b65.1755624249.git.leon@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <cover.1755624249.git.leon@kernel.org>
References: <cover.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 19uogr1xcsbwkby4guj3p3khcye7sm1r
X-Rspam-User: 
X-Rspamd-Queue-Id: 16D4520007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755625122-644196
X-HE-Meta: U2FsdGVkX19iwBX/fRjvj5ceG+f00k3+unbLYq4M+n+7fufPI7S8OoeSJB6w8P4zD8ztxtST2VYekHflur0C/Jmp1Mr8zfqtL/ANWNWOVE1iS868UO6z0S2+TZ6JzJbCsZeLaDXOOYcyOkBgSPv8mn82MxcxvxSQ2uEJKxC+bvdvz7eNXvyfsq1J2j2ABZMfPW2XvhQx12WyvIXuY/V0WGishQChGQ+tLTxRSkCHBS7ECA9sKw50d01RIoPp9NdDKMWMehzGS1+aonRy/lo83wg2InGtbaG2YqD0M8cZKb8HZb7VjHmUHt+biBSEl4V98OLWejxFXSvPd85CtoXNalNSb7HlImgbVlqWNLI2YmOIPB5Zk0aflxnULW0Rk8VKnHTPEjxLL66yU3CHpE6OMf15M8wK9Lt2xhc6rIav2nYLnzfTCs4V/QfbFCmBz13LScroKpZNWb/EEPEhnqIIZueRgCYT6yLNEaaDAJI5BNRCbXTj0V8q2cBHkEErqijlNbOH8za/BsMQBM+hUnBFgShftnqehrdaD1xpaQSRtR9B8B3RD3sFlrBi9+waYC3WEy4KacygJJAqzXMlc6uiEPmjUkcTxzDyZJbEs6nYgixJKAt30TJSur+UzhsNakOQcjUZ7lJSURYGl/7T7AYgjoUuXar1wHb9UgqEEZXKJ3jUz+2d6GwumGIZ9LoI/bs0Lhc86d9B2GyDFA5hZB/Ig637N0ZQFxcd/akGUPl6TNK4uiIhMNEV2yipmXc6KF7e/De1aSc6nH9DYm9xl2BP/N+9FnNgaCFg2R+TqL+SpjciAzpti8iAVxk0NXmX3AheYV2JcAo+qMzcs6WWVFsnlMEIUhWLa/0H7y1rVKRujOGJF0aU+k5y0PiJPOLAB9liyyVytDGbeYbJaDk/iq/Rh3lIZYTl6rTlt7nzVq2/eOnFEjjQmBB6z9uECf7XS5KcLNNelSyWe3Kudy+BBVH
 IiQYZi8E
 e11PT9Pnii+v4Xf6eR7pBy3Os8cuu532diPd/gvGJnLg9XoUFYClhXt/rSfVimZywfE5lkBMSmnb9D7zk3x0CHjYe8HKFAubaocNL4h/xF+difProIaj0CNLPbX2Jyh+neCkX50/v9MgmMhTppGmbf/QEU2nHT94aEKJXyhiCAx1MndTpkTrvp/dYQ2WN5Je5nCDWTbxQycl83Uti6GDKeHiJHdqGwqJZnh/grWZJ/4OvlCXSnUpN+MZrINnzBbGvD9+SMLuDtFJ/dPkKyyAA87PEPso6C6CbA0nRiqwd9z2KGffHjvKOrFIyaZRyBof2sZt6qnMcJPOrSBvp0m6F69sfEZTnUDUJXYzb
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


