Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D86AC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:17:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B34D6B0095; Mon, 13 Jul 2026 03:17:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63D646B0096; Mon, 13 Jul 2026 03:17:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504BB6B0098; Mon, 13 Jul 2026 03:17:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 31C306B0095
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:17:38 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC56A12052E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:37 +0000 (UTC)
X-FDA: 84982898154.28.1D91686
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 203CEC0007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IEu/n99Q";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783927056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFYeKargova8Ud8wjAeX+s1i+b6lKR01HyMHcvbV2VQ=;
	b=lrHvtawEZBekwdlXyFMOMV8FS7RGQjapw7+WMAZivAKjr+82QOUwJHV56kYqfztCij++aB
	DP361HwJgjjI2J8t1jzxn6idhCyX5D6hRAKYuZ/6MOxCDhKADcg63Lk6vEkHVGzs+8q+Pf
	H2HMDoPUBSl3Qtu806wrABu15x+s4EE=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IEu/n99Q";
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783927056;
	b=Ydst49eCD5yzfJ+zDrz3NjpMidKN8Akz0QaviWuyNJBqNbWDn1ajWDnGZht3/A3Y2iII5E
	vFIhapAUqGZxvF/Ua0iH7FEKwgRdUnuzfktDGps7PcdNb4Pji5daj5CPVGRpHRMuAFzYv1
	KG1Clb/sySlA9K/xE9RG729S/7nkOQo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 665A0437D5;
	Mon, 13 Jul 2026 07:17:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A64671F00A3D;
	Mon, 13 Jul 2026 07:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783927055;
	bh=KFYeKargova8Ud8wjAeX+s1i+b6lKR01HyMHcvbV2VQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IEu/n99QuYXkErMNPS34wGG3wPAoz82f+IKjx411LSqg1hg5PAvx1ZTiomc+LcMEa
	 0mLgjz4z8EU3xipYaZCuZ7XzAsbHNzfCpwM9Y9UA/WuFfE/uemo+5ng3eVB31CHKPE
	 INQF5CBkEc0Sqq/F/wtcEU3xoJp5eCIypyNFGX0u+b2QPeBVQ1pttYlvIMwS5cz3DP
	 0A7IEOLI6EfULdREoJj4q33cmplEHixakuAkPYaRsrViOhQxf99BE+Y1NFufAZQAfI
	 NjldmWm1CyhuI4njvRw1N1JSf9S8OcrwlTcqcoO+XkiksVyvUi7zuykHoajCIvxTBJ
	 8UXFi9SMQftrw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 13 Jul 2026 10:17:25 +0300
Subject: [PATCH v2 4/5] IB/mthca: allocate mthca_array memory with
 kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-b4-rdma-v2-4-65d2a1a5180c@kernel.org>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
In-Reply-To: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 203CEC0007
X-Stat-Signature: eeaoewnq7zehrm9fxe4pnygpc1dh4j9k
X-HE-Tag: 1783927055-806943
X-HE-Meta: U2FsdGVkX1+GMRV9oTz9kycyQVr3Sr4b9Ep68GRxnuWMI+9loUOki+lm/foWuRY3fGSNuKDQpHogBs+FRgcGNGKccNUPw5/WNIrXNkKWcp5RPTbIjT/sURh0F1+4L0w5Yf8JX8vXGBrZlSfRntQsUKirhJ8cI3ZmHn8ruLArFeGA7f1m/nLvcdcLPHFie2U0qp1mMllLvOvAiXl6IG+Kwx5zH/F67bWYyYWLjegbyK8iDrq9bnDnqvucp3a6REngmEizHJmFfvQY7qLKnPl6Vf1OiKBUH0sKwlmKGuI5aNy/S8l7tCKV+yG36zm0o1iYNyluCX9shqB3B6Xc90utQppgbqtebrCB+eYTcghG5NlO84D+YYMdxf324JqgErOPvxumylp2LMmVtlPFUo9pelv8dyWc9yvLVoJPbvX+649PH1H4j8vp7TXxIk/ytIhty3WD+a2pCfp7LF2/n7RwrWqIFNMjvoW20VTLtTkJVaqMi/2hIfM4z65uSoyD+VojtiBL/or/bmdsnimfLwjUd8VH9+k0qQ2uBYL/0FLOESGa0dqRafoJG7KiVIjVb7xtHDCjNzAI0zaa4lXR7fNJqrp5rRD4wb8zl/ZicE3yRYqDSVN80n23sJ6YOhGMJ45Imnz6CLwgm6dKS3iv7IRTL3kHBPnLRGmFqF9vvfNxUorP0hWAa041H7gZTTpn/wfzl0daqYIzyYbYXLF22Hi2lBmWwqSUKRDlYt9KEYM9L5f3mZbfxjs8EiGHTWL5qVjaoFCox9hi9Lzj+eNm8E7pH0W3AklDceDWLYJkY1XGw5PHCkjQr5KJfpersDEjGg2507+oOaUiCG5u/w9B4gDD9zGSJRA/rfhQvBtlxQOYGljkZlZoL1HVpZ6h33xFTbp9c+S/aJqrhkU1OJPNRNuIX4onumcL2XVYS9aMa2Z9cG3D0VJPetIzmL6z7IveFnIPh9jBiq2tDnnQB+/X3xu
 bBfY78e4
 dBAA1fVHvR8oBl8jfAzUGg4RiwMVgkJ3oLJPDmuejKYfD7F6+cepMd/9mJr8NisyDF64YwU5GdKCojQiQDmldC3QmueacC8BlSI5Rudkgn6pES1jf1d+qsYEVQHT3k+5sHFXtP5EjvZ3NcSRS0FE0azzX2ffZpfDwyZUsg8rys6WReEg0c6u/XuUSX+Tf0NZ+4hrczThGKyW27sxFSJhWPmPzS8fCWF/YPdwoJH84esfNLPhP+w8Zal5YnWdnB+I/2EC4MEHEON5Vl0fiEvyrbbkmWdv95YNhtic+uTOrLIpqAOtKI7Nx6XT0yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mthca_array is essentially a sparse array of pointers and there is no
need to allocate its memory using page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/infiniband/hw/mthca/mthca_allocator.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_allocator.c b/drivers/infiniband/hw/mthca/mthca_allocator.c
index dedc301235a0..117a070e784e 100644
--- a/drivers/infiniband/hw/mthca/mthca_allocator.c
+++ b/drivers/infiniband/hw/mthca/mthca_allocator.c
@@ -126,7 +126,7 @@ int mthca_array_set(struct mthca_array *array, int index, void *value)
 
 	/* Allocate with GFP_ATOMIC because we'll be called with locks held. */
 	if (!array->page_list[p].page)
-		array->page_list[p].page = (void **) get_zeroed_page(GFP_ATOMIC);
+		array->page_list[p].page = kzalloc(PAGE_SIZE, GFP_ATOMIC);
 
 	if (!array->page_list[p].page)
 		return -ENOMEM;
@@ -142,7 +142,7 @@ void mthca_array_clear(struct mthca_array *array, int index)
 	int p = (index * sizeof (void *)) >> PAGE_SHIFT;
 
 	if (--array->page_list[p].used == 0) {
-		free_page((unsigned long) array->page_list[p].page);
+		kfree(array->page_list[p].page);
 		array->page_list[p].page = NULL;
 	} else
 		array->page_list[p].page[index & MTHCA_ARRAY_MASK] = NULL;
@@ -174,7 +174,7 @@ void mthca_array_cleanup(struct mthca_array *array, int nent)
 	int i;
 
 	for (i = 0; i < (nent * sizeof (void *) + PAGE_SIZE - 1) / PAGE_SIZE; ++i)
-		free_page((unsigned long) array->page_list[i].page);
+		kfree(array->page_list[i].page);
 
 	kfree(array->page_list);
 }

-- 
2.53.0


