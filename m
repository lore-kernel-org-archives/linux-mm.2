Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E30FC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:52:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D08326B00B4; Tue, 30 Jun 2026 06:52:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0856B00B6; Tue, 30 Jun 2026 06:52:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF5A76B00B7; Tue, 30 Jun 2026 06:52:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B9596B00B4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:52:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03A5EC22DE
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:44 +0000 (UTC)
X-FDA: 84936265890.20.E77EF34
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 53B0240007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:43 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oP5VcZqf;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816763;
	b=y5vZeZL60YIgvhJgGMjtyN591qJFOSYSshkTMYunhbMGKm9OcLr8BHHz3NvWg8i4aiTqQ+
	iO97xowljyU4siz47GzEaO9yojDJfagaKhCV8bjhvznuMHML2JodxllAGws98ZAsnD9ThQ
	akH7/l+rkUOoWxbiiyKwSYiCGZNKPIE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KFYeKargova8Ud8wjAeX+s1i+b6lKR01HyMHcvbV2VQ=;
	b=NEXnIL0G8IHCpjqP7w/KIHqZegmU6r5GQm2HaIfgGn/QumPM106h0cyclrFU/eYkf8L2GC
	mJijXc5k+6oo+BNVfecVxTLf2D2Y/OaZrUy4EUqcX1s629c+jYPqh5mV/7CGH26y4vvvF5
	DaHBIyNrYIZt8hy6MkuybiSLpI1h0/U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oP5VcZqf;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E5661600BB;
	Tue, 30 Jun 2026 10:52:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0681B1F00AC4;
	Tue, 30 Jun 2026 10:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816762;
	bh=KFYeKargova8Ud8wjAeX+s1i+b6lKR01HyMHcvbV2VQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oP5VcZqfFAMLfd35gIGVu/nMyRSUEy2FwfsDttuu3hvj8BtJuooi/CAVb5JzT3eF7
	 CJ35cEKFH20+mfCwfndnINoNtkhHJOhoxPHwlzcYnpq50uN3pcoD8G1G8IQApZ16pv
	 2N+A/rV0PnhQPxlqI/7lM1HoSvoh5KXDyNSHwZDiMxOQykRhPaYnXQ10Yur0Mf62gg
	 goOiumuV0aAbJaQFfgU/x92qk1P6GXmNdRxwrHMeGJMBwJGcgDKtuv4nnmacq5KMuH
	 44RYqS6ok3IMYI9R5Ec5ZP+itiQEs+Fg+Q+T4kWQFcDrUs9e3dWfM4y7HU4xs/Zh5U
	 o35V6keGB7gMQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:52:32 +0300
Subject: [PATCH 4/5] IB/mthca: allocate mthca_array memory with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-rdma-v1-4-ab42bcf0de92@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
In-Reply-To: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2
X-Stat-Signature: 1rpwnfqj58f3zy5ayapn4fp15cecq9mg
X-Rspam-User: 
X-Rspamd-Queue-Id: 53B0240007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782816763-838028
X-HE-Meta: U2FsdGVkX1/gmwvfvTRGcSCssSMGzFabEpqXMDFk3Y9QfpJxowp65r3MjWi6sZc1JXZrFC44A2V3TDrxItl7USqTJXkL24s++3KWYt8H7E2Vk/ynb5HkFGDJ4vIoJPr2jbP2gehAr2uwz+iUGVisHqB0guq22I+uXQRgaUqCSu7Hdm5A20Gf4Fi75/Xbb9v1zGXNSKsdL9QQk+OPyWZUvLpp+TVBZKf+dajuUIeWgukITrcDIwfiGI1pAd/o4wTG5ejhdIieNKQzw0rzPY1CURTijRF9q9ecri0JLse2f39hCI/vCIypW4tZYXtu6KZVfL/ys91ilZfu8Fpq8zYQmaZ5bsnUNkEgkR48ZyXvz1Yw9g52it2EyOFncoRWvR/43phT2XamZOoF/CuBOaZg8s7PtnsT1UQR4H87oipi/FH1mQbLWVKBAorR6QVdO6gb2alnbO3bFtHNagV+pNB9qjIPya6LWNfMUvpT7Sp08Os1j/Il4m4aAi30MifhxQVA8Wow9r+eZZzG7rf+fTuFil0cGkDdUw2EBS/cNLgdNmk0Urj8W0eXaz9UxWJO2MNtaQc6GT3IWhVEfCJjGno3R2ZYiyup4bYhD70TtPIYtokndCMTIygTI8yyQZKMC6ZyoGUil0Y7mMsTRECjUIdcqiyF20dv9u2y6P3nC4C7+9rjA9BgJbpS3H8KVNXUvbUvHvpu+PFmYi77xxJcvsJS6LkMsKpKVDm3FTIXrAXN2fux0/Mf6bhXo8/vKqzhoiBLY4NTszJhCUXCoegtTE2qEQMStTbhTD8DX1xIGtWgfU31P+U1fHsDaOWLQYzbuir8c1Xwc+P9VklhqSBmOl+8UqVTY7/Supi4092awL415WKlTGILb1wzSCjhehj/VqZ0yuT+Em0/y5OHAJQkNZC9WciXnjJQVFDypPtB3riHgCVEB/OY0J01pXW9PoYvvGLjxt9p891wf9CT9qO+0V9
 U6Ih2n8a
 VFYgglkFq3/xxM0C6HU4FJu0+szVdTD5N72A1b8G8KhyH2dAcxeWCjtzPDGgbW7hvICfyBNMwUBKXgF7a4sJcdQuQnAAvbxW8TDW1adXCq/ZsBMy5leYVvWsPSn5IvobZnM6ssxoP4Tw0oJFRnIl2+wHU6GG9zaanfFSC8HVRuhntEig4Jg1h/0aowtyAGVUU8rzRbPSDvLOqN+WnLtldQXzh4032KnpHTh/1nG/Or8glqzzcCcqc/JyjzO6cW2HYl240PWiM8OCUGeiICJDB5RD15LhaahEQOgXZvMH5wF6saLdQ4ixKvSFuiQ==
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


