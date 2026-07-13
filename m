Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36147C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:17:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 490A76B008C; Mon, 13 Jul 2026 03:17:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441446B0092; Mon, 13 Jul 2026 03:17:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32FC06B0093; Mon, 13 Jul 2026 03:17:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 06DB86B008C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:17:33 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 889CC93E34
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:33 +0000 (UTC)
X-FDA: 84982897986.24.C93171F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7CFDA000D
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ejTfvo5h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783927051;
	b=f4ZtBCbhsUut3R1bw+JlhVllVmXUwJg0Ob0amOYfvLW89X2ycY/N1u+SHvW0OndCWL0vTQ
	ABZJ5elnJJoif0oVdfUU2AeQGHh8ctvv5R+wiv8m1MZB+fgCwLT+xs1jdQ0y7ja1Yb36Tz
	0+tXXG8D+2V4Z/3u7LOGsEkskZbtwdE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ejTfvo5h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783927051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B1vEwrB73ps6zpLh3UcDtCf1sAnjTUd+qckbQEIzKaA=;
	b=cHNTbsK2/GXMy8UR0beW0Fd82QeWtGLjqzkHsEVJtgEZ1hOHVO/Nca/e+GZDSdaSoKPY+S
	/gV8IXOsETSXI6qPVDDuJLJvKEVALMIgcLqre3JIritsC9kFLaP93nyLUPZqCnM2HOVnvE
	7BICTJXeRMs/qd5jAPmAr4esbcjrmSI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2672143A21;
	Mon, 13 Jul 2026 07:17:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65B741F00A3D;
	Mon, 13 Jul 2026 07:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783927051;
	bh=B1vEwrB73ps6zpLh3UcDtCf1sAnjTUd+qckbQEIzKaA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ejTfvo5hBO6cSEnRbHpIIW/r22KHDES61igHJDW9ZcPA2O0kGD7LJzCU75DARdwwL
	 2KKztVnHkqEkPpICH2r2dv+eK3rNrm0XuDve2vTjNlSgsJELEkgk/xYMTkSOhSpz3i
	 nwmH/Wa5cahWTKWCT3+NHbM+diM2aQ4m7SeDyyvui0u4QVHGU6x83GxgNbMC1LsShl
	 BZ43fDIe1DCtUQEKZQS/ryg1QvTEwQ9YXzh4WqiUgQUglFJ8WQeF6Zp9J4OxS2TWU9
	 K3S+ormK2fzUIr5b7aGnjP8909gAZjCenA7vvD2vHLiBYLNbFGCqcjK/Ua2u5QmNIt
	 6xwFaVqslyccw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 13 Jul 2026 10:17:23 +0300
Subject: [PATCH v2 2/5] RDMA/mlx5: replace __get_free_page() with kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-b4-rdma-v2-2-65d2a1a5180c@kernel.org>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
In-Reply-To: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Rspamd-Queue-Id: D7CFDA000D
X-Rspam-User: 
X-Stat-Signature: zgknqudkf7mzqkhk4sdjsawz81wucowb
X-Rspamd-Server: rspam03
X-HE-Tag: 1783927051-411627
X-HE-Meta: U2FsdGVkX1/TOgHFcN9W0N1ryrcqp2gwBnLEnJkp1Mk1QMN2Pyco2kax7LEbh5prKaMj3ymXfQzc2/rAqQDo33Dv6Viv/BVzPVk1Vn2FfDOOTbicYF5NBby/nei39F3tVujgvMefG3DtOZdXS5m1gSYBM5RcWMYi2ukhEUErcqzOd4GG5MWVe4K5ftUGiDGgbcySHrtcyYCv320BH7KPxHH730SHYliywDPSLQC/egzuf63qLjswIocaaKO0QTId+9ySnvKrghZoZmM2KuaWXZR9k5JOmnHpvhC0ejI0Jy4mf0oxZ9pOYuuVgHEwE4RyxpkucJ6gWYQyoBeALulevKV1/PY7u1FJYzPkMMVYb5MDMQoEeZAKJHKOEZ/nMex5dK9u6i6OsI0MUrRESycRs4+/j5/T6lXP1EOh6c4ZTLFeipwsqEGfcedq3X0UQw1pz01pGlzjiN+/rOdZYFGnhKkRPoUVXLOsHXqRB+yCiBnWX0BaFYGnnd2AQ6rS1Z7I4xP5UBSV7LpJWfeeAFWYMVJFCnbxSfIrqRnDftI3INIWlX+rUmgCKSwpzw6+BHxIKWOj4EtrirO3ctMKdTCLy+XlIIX+wFoaHhavk/FK6Rv1pQuFKZLk9DmIHljbZeXO9dm0IarvDcHYQyv+RZb6wYAsWz/VA0vO8tKFAFz/kqhzbqzDvU6mmEW/BWr64KAwmUuFg/vOERQSZks2YIrmv+GVO5VIWRmqkz/HVZjgnkGbxnbfNYP8AgYzPeSnxg9nDyz//IXMis06GWieVpjMdjpYBmUnnLxsn/TLQ3+8lSwVT1A7pG0EmEWYs+dGICWYyw3zn/AVuiYUe3dh6rdF0fsJPxLfNHPwQBwKJ5zz/8UdrTmbvAypVTIMcxiG5AHFa0pwxf8QBcRe096n+N8dMkgAKxdar88n3tPvbVqYyjPAIvOA3ZBgQEtBNYscb4Vzcrd6v8RIvYxPQ3k84UI
 VLQSWFYF
 EwNdjWmUTU/q7IivCai3tLMPx8OMNpVQ+d03/M/0T6eCtwuXRTnTpdIaD6xlin7kZR0SK7YvCwsF2c48z5OqBITSHWr/ioJH4XMgc6W+wzxFXDygbckUE3qbHEt+t3eVA6bFYiw+69ERxRefFP9lun1VLU+8vNA5+NKsKrJeE6Huz/9+sztExePPri8IRdozrkb5ko1rO1yYMIxZFvVVChUm9i20u8/aacp/H1IxLa/AecPqR0xv4+tCohjwpTSYJSj/+Lm9KwzJWKYIrTnrdr0sNVQgmGvehuqKuQ6KgI8VtgCkQ+meHmNefjA==
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
 drivers/infiniband/hw/mlx5/odp.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index 1badec9bf527..b8618610737a 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -37,6 +37,7 @@
 #include <linux/hmm.h>
 #include <linux/hmm-dma.h>
 #include <linux/pci-p2pdma.h>
+#include <linux/slab.h>
 
 #include "mlx5_ib.h"
 #include "cmd.h"
@@ -1414,7 +1415,8 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		goto resolve_page_fault;
 	}
 
-	wqe_start = (void *)__get_free_page(GFP_KERNEL);
+	/* TODO: switch to "fast and as large as possible" allocation helper */
+	wqe_start = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!wqe_start) {
 		mlx5_ib_err(dev, "Error allocating memory for IO page fault handling.\n");
 		goto resolve_page_fault;
@@ -1475,7 +1477,7 @@ static void mlx5_ib_mr_wqe_pfault_handler(struct mlx5_ib_dev *dev,
 		    pfault->wqe.wq_num, resume_with_error,
 		    pfault->type);
 	mlx5_core_res_put(res);
-	free_page((unsigned long)wqe_start);
+	kfree(wqe_start);
 }
 
 static void mlx5_ib_mr_rdma_pfault_handler(struct mlx5_ib_dev *dev,

-- 
2.53.0


