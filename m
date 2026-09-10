Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0BA9C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F47A6B00AD; Thu, 10 Sep 2026 07:00:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A5636B00AE; Thu, 10 Sep 2026 07:00:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7937D6B00AF; Thu, 10 Sep 2026 07:00:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51A086B00AD
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D374C0285
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:48 +0000 (UTC)
X-FDA: 85197559776.03.DDEF881
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C795BA0004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:46 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WneeTd+w;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038046;
	b=rcF+bMqxNabXoW5Dck5uugdXLRCPOdWVaoZ9biCe01iRkiiokIZ7zm2RUd200Xb5UEvDs2
	jB40rY2xgHJ1dc4evE6av1EsbMAy16ltTPVLWyHyIIuuqZW4KrotjplOhBQw7Tm8JBJoBK
	oWdohAW+qlTw0NwP2b/y5txcKf1NQwU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WneeTd+w;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjadfUkSzyOP1zHYpwk4bR2tv8NVDjjU5ZmwfJdW4t8=;
	b=JiNr+yYVZuL94t8dYpPa0gcuGLeiCSs6HGazB9S4/fzJlyKqjsFCo/rxRrlbVzQaXin5eO
	XdivOvIPynRoeDYLzGCuxfUx/YIatBftfVraqMnjIGxt/zn/B0kfG/mvKAp/DpbkEyT5Ov
	zaVfijkVRJbjiGHdTQU+x9DyTzBRxLU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 679E1600CB;
	Thu, 10 Sep 2026 11:00:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585FC1F00893;
	Thu, 10 Sep 2026 11:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038046;
	bh=kjadfUkSzyOP1zHYpwk4bR2tv8NVDjjU5ZmwfJdW4t8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=WneeTd+wW5lN9tsU6scOlOCEQrhfC0vBt7gRnjduif9vvCU9to0xuPIZfTlS6Dj59
	 9XC6IKgQKVNJZxNAMVlJL5/ERAnBIGWIWQLC37i/RDN49rUr8/Bjdqj+/DD3AKfZiW
	 WevV+s855628UX6OBQZyFFAMmebgteXfihb29qCMH1GxVEM695LBChQXVHRs+ZQYrE
	 IsdiLWAEhvCKR9DFPeQwR7Z1QxdeC4lITBAxf7xnlhDpaeLMNxA/VAuXvicjw9Zt9x
	 NK8nr7JQqAK4TExYaI4BsXOL0GXhUiwujWRMf79BMV50dNFH86x4xTeZ5OjxoZCi60
	 PMMwO8isMufXg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:13 +0300
Subject: [PATCH v2 11/13] s390/qdio_setup: Use kzalloc() for the storage
 list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-11-e931086fdde1@kernel.org>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
In-Reply-To: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C795BA0004
X-Stat-Signature: o6qhi5ztnxnoiiqf18hefsrc6744sxsn
X-HE-Tag: 1789038046-172827
X-HE-Meta: U2FsdGVkX1/G/lm9N7i3TP9WkSuUSD00LiGtw6C6rPa1Pe/9obNGetH8Oh+GkCxTp59WvvFlSS3xEO+O8ql0y6AvKe0b9+rHLEp7wHO7G6P8D3KoB38k4zkTe1FKsHqvadPb2vBsmCORzjh38YVia8fHbMCEN2bXOEt/oip+t+lc8sJkgq5rJkBqFMQB9NJEAs6p16iLfbn/Ijl6H7NHC7LyVFDG6wGtor6QZyuPdRUxklGcXydgEggr5QJQzs4V8+JDjVpNTXq1YL6sdlX7lerVdzB5MV+kbYbvCmMgf6LpzHAFceGUYKqeHnsvle1ad2DoSnp5m7meJlq+sXek7u6Fxi199CvLuxeH6mAoU7QQrgWqlaBJdh2VXIq3Sri0YCVQ1Ge44dZ+QtQZ/zbi4IYDBnqp+8AOCJTFkqOKAS61jFiLw6W8AhlkO8GXUcMyxwyy8zx+gxuXP7giaFuRJJpJYxhl+wRXfr+lwq5iZ/6R2aYi44fvpJd6jsNO+bXe4GWdZ5BSSlg9U9ndFioAiniyKhSiUTOk4U9U9qC1sORzfRc6ath7arizGaEAhywW120HGStFRx7q/Fu7GGZNWK789A4IUVe59AUGtrtDFBd9+YDbUGiMC7I35YF0QPsVkkCftDz3QhTKuRJx77uW/04Z5VZfen2sBTV6ZSsZkfT2aWgrRLOoNGN/ozHmyzmywDsE7kkwHj/qRC5WPH0czrBY19aOk6IBVpxFutmLJyHUikDFtL2r9WhzymIDAdGdPQKt9tB59zY7GcRh+UGTnbPsir68/QyTrfBaDznCS9UteMu2rXvgi9LsHqYQq/pKEX5SPr8z+T6UNlFXXZNvBpEyawauGSqfEFxgD3gEL7OquTxBQFVGYp3lu031ynE4eVK8P6fEMF3k+k3fgkYoLjRo52gn2cR4vojOaDKzyloRGJqWPu9FnceYK97t4XOnt7RQTtiW3p1v0GqD8Iv
 TAoysguD
 zu5wEph9OqyZgHayfFNVaorRBzIcjtR1Sv6FvbcSIgfEclHhaazLWvpTjr86/T8uJJ4P581dsMD9dEmmnmG4+Bb0aXswqpY50wl/zL9X1GcRyCKEST+2cD+hatpCqbf8F3IkhVZSrbS0Pw2nPyyG5fBRGg4v5qiGFs6S+QP/IFw2rZJrh/QRtpI55+2/CJwoPhlfp+yxvO0mA5TwwLlAtj2Z/bHLhCZrcqrFpm7D4vbQopDPlomwp2tjowxk6MUQqKICH5tY9zi8S12hQzulFxK/g6kfKSf+R7EEzfVEiG8jw9dNFDWVsRGiU0g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__qdio_allocate_qs() allocates the storage list information block of a
queue.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/qdio_setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index b6f2ff202fe64..7ca8f61a2387b 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -83,7 +83,7 @@ static void __qdio_free_queues(struct qdio_q **queues, unsigned int count)
 
 	for (i = 0; i < count; i++) {
 		q = queues[i];
-		free_page((unsigned long)q->sl_page);
+		kfree(q->sl_page);
 		kmem_cache_free(qdio_q_cache, q);
 	}
 }
@@ -109,7 +109,7 @@ static int __qdio_allocate_qs(struct qdio_q **irq_ptr_qs, int nr_queues)
 			return -ENOMEM;
 		}
 
-		q->sl_page = (void *)__get_free_page(GFP_KERNEL);
+		q->sl_page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!q->sl_page) {
 			kmem_cache_free(qdio_q_cache, q);
 			__qdio_free_queues(irq_ptr_qs, i);

-- 
2.53.0


