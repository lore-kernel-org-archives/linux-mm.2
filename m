Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87AF4CAC587
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 13:29:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4ECE8E001C; Tue,  9 Sep 2025 09:29:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFD4D8E000F; Tue,  9 Sep 2025 09:29:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC4CC8E001C; Tue,  9 Sep 2025 09:29:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9C59D8E000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 09:29:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A1E482A8E
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:29:12 +0000 (UTC)
X-FDA: 83869792944.23.32AB9D5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 8C3781C0007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 13:29:10 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHwsQe9p;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757424550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wthMQG/5mxISW1GKlke+e7Nh6K6PI26zWXKnxv2AL9I=;
	b=ZygLYkJQ3kkyUdVU/qI6Gn4E+NAOYVlxXKbyjdtRI9Yi+2I3UUBy8TOXExGmriucWEnoP3
	m0aOi5WTTPA5P00EUfSPfscrQKETLrI+JTlhMszbopNmAhmp8RWHgp8Mn1vDTyysRIKx4Y
	rgzC7FpWjz+fISi3YjlRpThQvDM74dY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nHwsQe9p;
	spf=pass (imf18.hostedemail.com: domain of leon@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757424550; a=rsa-sha256;
	cv=none;
	b=Ou+UDf2dYaa8RMRPkjw7AHDo4JiAizgmOJDQalWdplHNN8dmP1VeWHUq1xEMo0FRqDESsb
	GvF3D81WHGOKVXEnqW/kv+2DwyVFVeEEwFhGXt8pbRgRM1iblK8ymQWz6ZPp/lrHdF7iHF
	jrmhysG7MrbidMVDgZrHixRyx8x+Psg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FDB94411F;
	Tue,  9 Sep 2025 13:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74DAC4CEF4;
	Tue,  9 Sep 2025 13:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757424549;
	bh=jQ3T/brRUziOQrtl/kGVlBSfi2tE0bxT371ZOGgDim4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nHwsQe9pTWoBdpjmDo2+n+5/JjBFwg/dIJmlZq+/ndbthLybHRer7dXzwBpSuEQ7i
	 WpgZESFOSYk0vymXIf70Ka4LsYpVS5vQw8F7smlUhzgUae5YWqaRUFJM4IwK3XdPU8
	 nQd69kJNsmstJsXKlBgipLCGMWJfYYqJE2rU2FkxR/cKCJArJmyICbqTFiX7qT52P6
	 bFJt/DsWpz8Ho6ieuoZtZR1VMlsPp35ivfkfFmrDlxi+gYH4TXCDlS/zFwml2ISjyT
	 4kyTMDiyaDIt3S9mhvAvhapMGPAO3w0XKnS9A0uiBpYOSAAbYn+JofRb8t5SlIv8X4
	 Nu/sGhPGyBQ1g==
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
	David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v6 14/16] block-dma: migrate to dma_map_phys instead of map_page
Date: Tue,  9 Sep 2025 16:27:42 +0300
Message-ID: <0efc4a06258eb1cbedcee642263d8ba24c5e97e6.1757423202.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1757423202.git.leonro@nvidia.com>
References: <cover.1757423202.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8C3781C0007
X-Stat-Signature: 3i8a4sespxtkirbto4bbiurgn7s9g1qe
X-HE-Tag: 1757424550-51542
X-HE-Meta: U2FsdGVkX18iXt+cFMxqK0YknH+hhNJMpihBvo4IGxuhySmI+E0Rz7bj9ayN6oZ0ebNXF2xpKSTa7+cohDAEEhh+dlN3aYoerUSzjyb4mdVk0wHdD63A5GdWxCyIWDB7r0MYDawZa+URC6yk5KVbVd/aaXj/F/M00cIm6GSAf4lrEuZcp8oCqV/2i9/H/aQ2k9y8cResNKwcvlrr/3Q7wX+2lvZ+MuRuHWmG/U2RaeGRqxwdbVRTp9SuN/plUlHTOui3tvpPsOImIT4rqGhFXIP5KNjvchQRD/NdwkGvEcYGRvzgWy1ttgNsSmS0Hl4AUQXh+g5tl/U+QWLDCLabU1s1p8mwcPgCG40TD9pqtdluuKeOkE5DKe2xbl9FfG0q22wsVVCIzaX574pb5AclU8MM3XCydy2t0DRnTW3Yt2a4SZFznZ3cmwdpMPKXeGQ2Dh7dep4BmC9dygEUrK+iHXKCb1A1RJcNoDXgn4V6FkMWaieq3NB6s6EQvIWCRvSIJ2VbPrPSg5mItWCVuPWdzgvoJZdfoiwSanafVCLkq96DXC6+o11sQZMnzqS9WwT+PMVL/9Dv+nQMJzcQQPeYJWdC3qJckGIZeZRXk8+CAavDWUiJEqRwRJiZ1EwHnYiaFm71i22PjRr0RqmHjf66XkOKyHMwxISRuMVuSo0b2wBF536oy3KBGvJqJHavRiZt5fazVFdYGF/nWONWAvM81IjnVySWoSec3VEhZyG3l+X0ZEAzFixtjRJ3NRKGBkVzgqP4QskJcZjf9Q+UJWKAxmS0m3Z66sMvdhuuVk7PCrkMQBXAkH6+Vpz9U5uGrLjm6lMk1SVS8LOycUz7TxqrLyWNAssuAfKQfTSJ+hx7FyaW65+a0Y118mFGB4P9BEiTniHKgPqnFc+6ksTeKOQ+DhNFRKasLiWBASuNQU0h5cqQoAfBytldqD0fiiP4dkl7I3hk3eNpCxbno/yvfVe
 YlWQtZ+5
 HK1IPP4oth7ss/lioy5ACtJMPu43RIXb64DKCxzDLpMvtUk1y/wSpczJxGmTfDXnfLW6lJGDpVum+bNA8Onwj/q4nYKLSHYYGO3CCiLm1LDh8CpbQ+WzUL9OGNn7VGj1uY+F9KUr4LhX/y/UdMELtq1WBYvIb69wnbRTGKeeah0J6eWb1f05T0AS7VQ36DGlRUauZx7BgLwwkFKJklUjWQtiART/UXus/Fkpy+u3asqNu7RI8Fhgy6bO7WLWrP3TJaAJ/TQmDM+hXhfKEbd7nizixWOnilhXLOO8pDVFFaDktN/cvRUsfqxE2LLqp5zA7T1z2BJxrXZDR2Xx+FrTP266usg==
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

Reviewed-by: Keith Busch <kbusch@kernel.org>
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
2.51.0


