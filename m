Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5597EC44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:17:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F0486B0088; Mon, 13 Jul 2026 03:17:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C7676B008A; Mon, 13 Jul 2026 03:17:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 504C26B008C; Mon, 13 Jul 2026 03:17:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32F446B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:17:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C736640A52
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:31 +0000 (UTC)
X-FDA: 84982897902.25.F7627BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 20507120005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:17:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mK7Rs7Ep;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783927050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uWIVcjeEM70jyTaGHVgY1Rp3qpXgQEqVNmxGrIcRzKo=;
	b=Z793rVTCWLN/5YIULwEhwa2qP0oYkJhMGVAKWdYuG0I9HSrbZ/USHVwfsb+1zvNCPmSy4x
	gu2NOGIw36UFiOtzpU7JIhvvj6XXQxLarDkuH/BfImhz3VRdNuIsBxIUnockjJR8oib1lR
	1iHc+AFKLamg4l1Bee1hFjYd/HoFnd8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mK7Rs7Ep;
	spf=pass (imf29.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783927050;
	b=k2TkOVQcqKu4c4wuYtu0HvHHzhIiEkZ70NNwpYB0S3JsfTRAIICXdnF+Yx07XUrX0RDdWU
	v1Z2jPqq6YoC1RuJXq/emtEKzEN9NXwsa10YiPjODkKY1OGvw20i4vN1M+hIv1/K/fUcIR
	c+6S+YqXvSDn+wlvl+BW8Y91KWAgu1U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05BCE43B0F;
	Mon, 13 Jul 2026 07:17:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AE91F00A3A;
	Mon, 13 Jul 2026 07:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783927048;
	bh=uWIVcjeEM70jyTaGHVgY1Rp3qpXgQEqVNmxGrIcRzKo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mK7Rs7Ep2oHn7rc1lfqFdey6hB435+rCXTeAcd4DVnnNK0XLMIaVlziT5O8hxIvLb
	 UvjsqfP7CFqucFochDH4MO8liVKybOtB/MpvIkXF+UXRbIdgeK5cyqUJ23NnezYe4k
	 1CyVypk/ieWMmRUqBFK48kK+DdRpdDp14sqrdYo7aQhAIAwJExbfxbbxW9eBWrDNWI
	 yQ/587Sxd9rWeCacocCogH4nCaJSoq3zF4NEinV+4c66JO63tYnA1exxwVPjupPzgJ
	 re/RsnjkCnKo2BIVPEM1vSW/Y6wuKAs+uGaXcOHdG0ZdZELLsioRWTsSlTTuBeq5Sy
	 lX2LdrbLdp/4w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 13 Jul 2026 10:17:22 +0300
Subject: [PATCH v2 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260713-b4-rdma-v2-1-65d2a1a5180c@kernel.org>
References: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
In-Reply-To: <20260713-b4-rdma-v2-0-65d2a1a5180c@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.16-dev
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 20507120005
X-Stat-Signature: zhj9n8rxfb7sjtznm1c8q9dbhk79ccff
X-HE-Tag: 1783927049-584391
X-HE-Meta: U2FsdGVkX18fd5dBlJPObC1GcK3KUUtLESfhi3tulcb768nInrXF1bwLUT36zIeyb1/3RXTatXtErXAjzi4PHwFjI3buFlONXUHtuW6qfxThN4DK91EBhCBGy5GoC8gGPfa98ZCF2YillcqQC/lAYNBXgSSVdh1skyDn776De9qqWy17IdQxdrD85k1d8WKI+WkIfji+dW/i7oh/FVvoyqhUOY8Ufg7ATYx0iqz+lYcK3rYcNUzjhVKcShUISvn4JlMDfpZ8QjJY6qbEp1+lj33MDiD54iXjmh5u2EXDSjW3a4hucCR7rSvvpYh/M4OBuJJUWIRVmyt1dwfGph0DtKFRYJYEGYDWAFoCq0LmnGlnoCIp1r/WnGBD+dLnkZld0GAe3XxcKO22G+LHeHWkPmyOXSGAVqpKDYaySIS1qvqDyMSvi7ygW+6Gyi/lHIYtZKLjxjyoOixFFL7IAAi0J1nEkkfsCh8omn1Sj8MCldxrE1Qrfp+csYJxwGFzgdAkZdRADByHMMHobOgCrdD2nVN4jAoYAyzCqytSwOB3BOJHLM8PkmSoTNT8SV+5dNLzG3lCIaU+Iv1L+gdDwRe2HijgihyMrWFbl8ihcEasX6/ue1W0GxoFQdmNhZzrfxU7uuP3t2BbRBHenq6K3qd0oq+o1NTzW1ncgkATVLtrAiQrLkzAOjtYy2tjPELi3PmeuTcV+IdSj37azTRnBaYNIMP0RNgH2m54gjoBTSng27fZk8R4xUxSJGXIcIWoRlZ3BBqYJQKjav/euvMVHpRI2k4cHndU9S9Qsgscj74R2JKl4sodC+5On1GGitAiOj7PGbIt+bDjhC7QOuufoVWgWtRz3ItrkF9Q7Q5VfrF0qwXTYNPJpSZnnZbTeqNfQJW/r4bKbz66teRa65LYAotAJBxhbTW4LCd5n3nwcJxxeLEz9g5x2hHsVE410d+TxoIMrkgULwGAzXutCXxE+z1
 RavtA50L
 5YBROcT/iAeUdj3ue+cBAtJ3wfGKce/k0lXXPt8HPK6neKrz4SebAmJeYMgT2+snz/0wH9v/txJ3342uuotW8BKkaCai94LRWrnqRhvH0fwH4vRapeKqfwu1Fn7wYsTQGLkR3Q0lSNH26b/hiLhhsB/egeXjE9H41KyzDhO6jWuHJ0gFzsg9duYncSljA/85hYC8z3gOrlAw3IsiB1iuQUVZauKcW5qWP3X/3VMPykXFfmA9BG/q7NmiTj2mWSTNeZb8qeZdu/et1xT256OtDXfZwUntv4hvx9hhT01jheZbAAx/QJvvf9mZTsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ib_umem_get() allocates an array of pointers to struct page for
pin_user_pages_fast() calls during memory registration.

This array can be allocated with kmalloc() as there's nothing special
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
 drivers/infiniband/core/umem.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 73498723a5d5..81f44dadfa52 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -209,7 +209,8 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 
 	mmgrab(mm);
 
-	page_list = (struct page **) __get_free_page(GFP_KERNEL);
+	/* TODO: switch to "fast and as large as possible" allocation helper */
+	page_list = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page_list) {
 		ret = -ENOMEM;
 		goto umem_kfree;
@@ -269,7 +270,7 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 	__ib_umem_release(device, umem, 0);
 	atomic64_sub(ib_umem_num_pages(umem), &mm->pinned_vm);
 out:
-	free_page((unsigned long) page_list);
+	kfree(page_list);
 umem_kfree:
 	if (ret) {
 		mmdrop(umem->owning_mm);

-- 
2.53.0


