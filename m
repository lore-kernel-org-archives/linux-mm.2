Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB67C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73BA06B00AF; Tue, 30 Jun 2026 06:52:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C20D6B00B1; Tue, 30 Jun 2026 06:52:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58CA86B00B2; Tue, 30 Jun 2026 06:52:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 314066B00AF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:52:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9C61A0474
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:40 +0000 (UTC)
X-FDA: 84936265680.24.9D25291
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1475D40006
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y+HU1MCE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816759;
	b=HoqswuZOO0LjcBYo9tGSG/9/XV7cZkf+NAwSA/lj8yYQqjRF8LAyu1yiK2p+Sj0gYzeurs
	VwoGKSEhh4onsYS4G31au1EX2Nnq/l34WOCd7d404V2b2EH+lMPMdWItJcILQf1dyX2jkT
	c9ZT3eECC7mn4kWuZN31RHazHIWroFU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9y4x9Z9LfAleq5MGRjUEHqlQfJrq4x0loQabN6bGIV4=;
	b=WvNq6BGqrGOvDSZ6iO17QRWA8WgP7Fh0vydT7FyIQvYJgbjfboPG55a/M7tZvJ/Gj/Oj6k
	+TNZIl3pL8cIG54WEfSznKXhspQ7YG7fyCCbcwyUW/zE3QKUryLGAV1ZmBEIo8nW1MJpSk
	N6sv5SThAZNML+j6+nxkDy09ESegh6s=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y+HU1MCE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A7E41600C3;
	Tue, 30 Jun 2026 10:52:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCBB41F00A3D;
	Tue, 30 Jun 2026 10:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816758;
	bh=9y4x9Z9LfAleq5MGRjUEHqlQfJrq4x0loQabN6bGIV4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Y+HU1MCE4pGfbvjbc9ZSs/nVI7sjDU6dz1seknt/Us0d3sLTr9zJdowDj5hBIttmN
	 guYqW4UWVgRhsGgr246USmDBhEpu+61v09ZrBf3HpO3RwdLQHBcCFlT4TRJTWN8qJo
	 rOMZtZj1Hrjd/8VUZdhpiVx53YN6SfAjoWoMNQuTFzxcxEVxLfJlu8g6oxN1eWJY0z
	 fTEUV1ZAkWf5tI/DEGaMWWHNp4KfV5Oapd/VV5CTRo8V/I9jtQ3aJ3Bwb4sJuTFUBE
	 sGR0jYPCObvA4sMpSAjxDUvwZ6knEHIaOWcH/yl6RNcytcbvCeupTEm3QFhXZEoSsM
	 aLNCXdRUf688Q==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:52:30 +0300
Subject: [PATCH 2/5] RDMA/mlx5: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-rdma-v1-2-ab42bcf0de92@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
In-Reply-To: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1475D40006
X-Rspam-User: 
X-Stat-Signature: mchx5rfmd83ehq3oek9hbhtr6u65rifm
X-HE-Tag: 1782816758-306877
X-HE-Meta: U2FsdGVkX18Vk9suzBNxQCmSlQvgjRl4+6EVsff1sLEZnUhH1mCD5g8gz99RGhuNO07chMJYMNRSba+0Gb0DPqJhAUZEDfaXjoEKlT1dRmWd7eiVVYXAQYrwEh22muvpqq2yHJoFT0G3QDrf6rnN+x/VzZHKdh2kfX7QR8aYHjn05pQtfiosRXIiU8kqO5x93PniHzwCV3AqUMA22xSIed/SJsLHWfDte7QhuMw0wQX7YLeNReK6HiMdfhi1ryMzbQqJIeWsq2U4adeXDUanjh/VOd3ry0vSuWyCidX+1V0LQ30ubV3kPns9rVOZXmzwpR+Y3O0vj1zaludNRzmID7d24u1shwnUCof/Sv/eOfCH3naKkLiYAfeLGWJv51nYldpxo06dkC7arEb7V6zYw1ws84nl+lZRKuQjgbzE+8fuvm46qM0SDt3IxqbY7yIkqXcLyIqd76Q5W53YpjdflaKgqH0N15xkXHCD06/SIJyXP5VC8JA+NLyCCw534D+IUGPLIZpOlfHcf8Ikg1zX4G6fsOFqAA0wUIUDnmITsiZU3tjh4kivr9A8TpynTaUhrWROVu5H6mYu+D0BxMhGBF+rqUlwhR+MmEA65DocI1vnhWnxh5mIh/nCrGd/T14ynHXR1gBg0uaBQHIsr1yQac21eTM4XD1Qc1yYtLCOugS6EI049UX2rhWdngRTdFLJBdyOA49RDAdNxtrp7UGocKd1Ge1TV+RMePk55bZhOMZh22gZh1PRjkTFCS6zd9L8t2GIPkL9OKH9cFs5zNAiBbVJ/jN8j70RjmCVS1p9Haf5uFCziOcvsYovU6FV2LqDX6q/EVKQGk9MSa/9xT+5+Q4yXzfUjXVG6M+t/L9DABItQHtaWYx4IhNVcKQ+bb59VlxClPd88EJlQnO7aNwCTGtr5YD9p1RC/QLTvVffdrrsdQhKHt4xBKZF30tDdjP8qT1tiWGOmYm01SPYKRE
 Rh2G/dkV
 ktAZD+8KiQhbz4cTLUhGXRJ9dOSVIb01ndl9pEk0vjcj0/YWRp454Hq0dZ8DSUUdAq9ab6WO9RqCphQ/tFU9tgeNcg7LquCRzX6Tw0Bv825ctuo7lazaLWwRARZBzK+xvgVUes5pfnf5uh98WA4XzJG0rOoMDoARf7f2LtXzwBAhUKs5CjGVdIcHDvuX2APTrjYnxp8XOlgytdP3TkdjuHNdNxRXfhuVOnGTduEoP6vbjyMZUkpo8HocLupPnQdN5unp6QvccAKmXNcdVN5IbmwwSlEdQpwfk2hFUZ7NuBYBgy0wrR4aNJjUYyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mlx5_ib_mr_wqe_pfault_handler() allocates a scratch buffer for
parsing work queue entries during page fault handling.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 1badec9bf527..90706ff7102a 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -38,6 +38,7 @@
 #include <linux/hmm-dma.h>
 #include <linux/pci-p2pdma.h>
 
+#include <linux/slab.h>
 #include "mlx5_ib.h"
 #include "cmd.h"
 #include "umr.h"
@@ -1414,7 +1415,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		goto resolve_page_fault;
 	}
 
-	wqe_start = (void *)__get_free_page(GFP_KERNEL);
+	wqe_start = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!wqe_start) {
 		mlx5_ib_err(dev, "Error allocating memory for IO page fault handling.\n");
 		goto resolve_page_fault;
@@ -1475,7 +1476,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		    pfault->wqe.wq_num, resume_with_error,
 		    pfault->type);
 	mlx5_core_res_put(res);
-	free_page((unsigned long)wqe_start);
+	kfree(wqe_start);
 }
 
 static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_dev *dev,

-- 
2.53.0


