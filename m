Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7C98C43327
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58CF36B00AD; Tue, 30 Jun 2026 06:52:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564B36B00AF; Tue, 30 Jun 2026 06:52:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DE3E6B00B0; Tue, 30 Jun 2026 06:52:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D34B6B00AD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:52:39 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8D8E1167AC1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:38 +0000 (UTC)
X-FDA: 84936265596.29.2456213
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 000721C000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:52:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3BTn0r4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816757;
	b=JPvJIYuUG2FmGeQHFbbGX/pwopJIIvKY4+R+1Y8aumrCtc5AY3/+SzhlcmlyjhRV83fnz3
	uGypTH2ZYBR+cuD+u1Aln2Fmx6nKhmHSJOGmjQjlDv07kiKhUAt3q+RyD2n5kNyINqGDn6
	CdiJcCGX1eH4hiTbUaSMNS1lX1nKwzw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RgvAPeibeFQxp8pOU9O5j9nPVFhn3WJwFhauJ32wTvY=;
	b=yTJyQhcttdQuT5i6vLDCQLkl4sE507dGYiUzXouIqRndCrKmVVHo/rSqRJj3sSR3f6ZLX8
	pdmX7J8R+eaMmEb+IvWGrDaUXx97J/BCc7UUkER2lJBhAL0V0VBQul8B9nCJe2Ygj0FXfh
	ekVucpoAKrddghPkKdrEA5iYw5PNXrU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M3BTn0r4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88B97600C3;
	Tue, 30 Jun 2026 10:52:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D1891F00A3A;
	Tue, 30 Jun 2026 10:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782816756;
	bh=RgvAPeibeFQxp8pOU9O5j9nPVFhn3WJwFhauJ32wTvY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=M3BTn0r4NqPQw3QUITJfljAld7kLxy1+/Qd1XPHB/Ud0Lg5c2vBkpXMAm8+VLxt6z
	 IOUy+k5i3XRwFPP0UVKOblQHyU41gg3SPV/7gGa+CUzcA8KBYg6jyfklZCy2Vh8U1/
	 wg0IRuZzXv+7muzS1ObXYiteA8vilrXM0lpE+Yqg9pZLGmvFO/p77tOu2U/hLmf1V9
	 DKYHK/QMrc/GSlBd6DfNpJit+3y125TPx0r/zLn5nKYlXpVrVWbUnIYYkEpmFaxZNR
	 bRv8DBb/NUhsPQDRZPbjRXLL9EdGIUjv/SJ8/VxcRsXq7DL2E3hoggvLeuS1YKUsEi
	 kQbDKNhNge/mQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 13:52:29 +0300
Subject: [PATCH 1/5] RDMA/umem: ib_umem_get(): use kmalloc() to allocate
 page array
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-rdma-v1-1-ab42bcf0de92@kernel.org>
References: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
In-Reply-To: <20260630-b4-rdma-v1-0-ab42bcf0de92@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-rdma@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 000721C000D
X-Rspam-User: 
X-Stat-Signature: o1nq56eq7s7wh61jhtt61cfhsij37dnc
X-HE-Tag: 1782816756-764189
X-HE-Meta: U2FsdGVkX18UzwmxmEBiU0CVcNrL/ZMi8GDVxn+OVYuX8ukL6dMbftiT1i2/ZoQUNgfemtpESNbtMFTeXCCaxfKj9QC7snbOCb5+OWzTpjIAGxcaoD7fW6nF/Ih3EfIsaJh4zUzlmqTtUJ7u2787rG4Q+30HzcpnjUC5cSbzAg0DXQaQCcAsBzn6XB9EsqUHdCW5v+IW7fmLno9u2GOrDPpCTjL/1jcuNkqoGHyjf8DoTIz8FHlIIWVo/RR3XZp/KPvstsnACv0jPvQpJXsCWwPPF1kiTg/DgjpMxvfRH2QAMk43VeD4qFBPA36sOuP4dezLQ2qBery+7LJmNhwktVauIpw/FyqBQg6rK7E+EbOHoNAGchUGk+KQCQTzdfihPEgZtf8KksDk5/kTdypQ1jEwbz7xc3R6FrAJv737Eqrh8R7na4IiLXk0DtN3BNuVHoWznJyR0oob9XOCIcPVwbgFJ27dfOiOXky/OLaxI7cQ3RuKi9BUI7YHn3C+qDjixLlwOGLUCTk4wYZbsUnX2D8sMG5EnO3FbFWQx/qLYs22enHfh+sMqnQGXchoGc0znbp953jpDiJz38xYUkMvBNTc8R0ywq6sGza+guehy6e6417O8UkxNTba3oARjU99ourtgV8PqwnPoKEOaXrqqIC7nN7t8xBB2trE6Rc5zNSld3ZhHdLuvRb6rCBkSoyWEPWVd8XYURvCjNMeZdNRYjKW2CJFgqj8ttbqXAc2U3SlNXIhUO4acZQv2zQXBksSAeN9NmKass8BplAzPITPUZ0yi54n0XEKVIj3Zfx/UbeVUzYobsrjPErOE3sw5FvLostXxwACzX83ZGqLfeJfspRfFiVgjHXWOx27EZ0ICS/ysgBNKiXnGkgqlWeM1D/rcgFtxOXwDhATjcKFff7iRD3KfRW3VH4YB1sDtRbBGdGcMZYc3azQtILBVvca9TozvelqEhRbFl8A2qq22Sh
 RdbSBPNK
 K0fCWbEK9LMfw7a+6RbkSfNopQ4f0KCmvDFmb1YdyVgICgSBci187CmOzKD1k/8AuN3rDh+BCHkhCKOh3pGz3YRJwZ28UV8hKS9HPS6bEoc2WdgxAcItOyD/CSpqMWKs1a3tvlqrkyKHBwrHp1JJLCYbx/MHSL99UGqHUU6hYnM5/yCeHZc7/sYmpVsFK4c+unSK3SuHvn2aShFjMtxKc3jjiVZUl8ojQ6UxCGiq1zyX/bhdxnBMXHMbS78QvWqG+63cv1gRcFZypjaQ17x69lRMOEStuMjyNK4J6xP3w/Ifb06rs/OswuwpjCg==
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
 drivers/infiniband/core/umem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 73498723a5d5..5c42497f32e2 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -209,7 +209,7 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
 
 	mmgrab(mm);
 
-	page_list = (struct page **) __get_free_page(GFP_KERNEL);
+	page_list = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!page_list) {
 		ret = -ENOMEM;
 		goto umem_kfree;
@@ -269,7 +269,7 @@ static struct ib_umem *__ib_umem_get_va(struct ib_device *device,
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


