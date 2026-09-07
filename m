Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92CDBC79FA9
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C2AF6B00AE; Mon,  7 Sep 2026 06:24:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3739B6B00AF; Mon,  7 Sep 2026 06:24:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2894A6B00B0; Mon,  7 Sep 2026 06:24:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E1BE16B00AE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:31 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CA4E406C0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:31 +0000 (UTC)
X-FDA: 85186581942.29.7B6C817
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id B1CA81C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m9w2iL9K;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776669;
	b=bVc7XDQicnu55U1bskEL7a2IjpF0ia3G2tSG7v66sv4go1Sj+KjcKgsYflhLKspg6FhpEZ
	fWUPaS/LlJipKKQbsWqM+a3GdA2YVCoq893oHQDmfzZ0GeYdaJF2RP56gJamDB490L2B0T
	iVt1FUCNm2ropp4O0pAn3/+djykgFmE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m9w2iL9K;
	spf=pass (imf21.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kjadfUkSzyOP1zHYpwk4bR2tv8NVDjjU5ZmwfJdW4t8=;
	b=t1Io5eYqdYzZh9BV0rn41AyW/hhRAn/8QR4AGa0asb9PZxWR3PNDiT8NGAdjtKJSbv1KPK
	AeeVrrut3ehgXLT1Iqvk2eaBQ/fOHNo321EyDQEYQ/LmoC8JzONYIYj2XS83xuJiZLXKcF
	v+MaQbSTgCrZkWpzW3qklBY2FuFpvhs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17ACE4097F;
	Mon,  7 Sep 2026 10:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F10A1F00A3A;
	Mon,  7 Sep 2026 10:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776669;
	bh=kjadfUkSzyOP1zHYpwk4bR2tv8NVDjjU5ZmwfJdW4t8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=m9w2iL9KmZjbnwrL0PHYradx8kYA+DJUJqja+5JXA3joouaWZ84qaThOVENwcCa0G
	 ZX6bY8ySJ/fwUO2yJnCE3LA/A73yTEii5MJR8C0IMmDBImhkpY/xFuXWkSzO58yFdB
	 FhyUiskZw/3HT9vOUJzibtohk4EtRNxoVdvw6KZwWjbqTMG2D3mdlAVlmp/Pz24EWh
	 CeuaQAW42sS3OXwyQNx5fy21WGqhT3NHmNZeup5RvDNUqgWQaWny7K1VauWJCfFYfE
	 kpqE+3wjwf8LAzcLP4fhwd6E0A6YOBWsHM68zaqFRDTVAMMuNgqiSF46JD/rzOky0q
	 lb3eJyYGR2H2w==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:52 +0300
Subject: [PATCH 11/13] s390/qdio_setup: Use kzalloc() for the storage list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-11-ca7f39806234@kernel.org>
References: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
In-Reply-To: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B1CA81C0002
X-Stat-Signature: xuw8hqw7f3fq3t5anrdmstep7sdsh33d
X-HE-Tag: 1788776669-127974
X-HE-Meta: U2FsdGVkX1/KmHzkj/JlW0WfsCqMG0crtiuF/U3UHqFVdJnhHpy37KxnrTauQQ3hcNTAo0fp09xHv7KgSU0Yihe+w/9VVshpMsEgqZTweEifZ0YJB3a5YSlIQch/O7vfVupfbmU7meCLweOyKekTTZmQoTzhkyEy5LNkdvEYx44FlaeQXTx0DWaz9PPjvXLeJ7mBVkz8P9ZwZ68By0I14dGbnsqwq5VkYsUQO2sLm23ShHwkKipZ/eaiaLU9pdIB6KfP4pvN42hgiVE77ixG19fySXjw41zwU5A+FQFnNzAhy2YEcEY9UxxKaF+F6LcqyFdo0w+vEs6RX3fgp6sdi5aul5r7iPsqKJir40eTKM+W0be8+1TGfpV+NfqRL2ylTBVnTuFqq2h4VY8ddagfGoFxn3qYuWrw0dtYpO5Oz3XQDNW0+hPoE/eFhNNXvSdN1LbrSKiw6qgD2nb2ZTd+b3UfzfhKPeh6R8HKfnnya/FHrE30ubmIJ+vy9YCGI+H9NKEBPG6+Sm1DxS4h20hsxsqTaBp3E5wnbuSPSYEUlwlD7oQ8Z8ZEBFaJYiyk9gYC+gtnyFd+jxIKdaw4ekMWIFwB56PXqOcdpQJIHflr575gH1tNdCP8iR84GjPHUW3BClEqU0G5r6XxbZE8QCHZt13hxIWNlW7LroZjFOadBcP+xf7K2YrrDRMH944TvAXgQ4QnYk4EkHSKEFjR0GqacX9m+uUk9SzemO8Vaxx+9q9YusyhB38t8MwU5UGf0uFS5vzYsfRdYK4zQYlu3GjvsZgdarx/NYsxzVvsfbOWjPnYSXfhIOpffyVIZWtSlFeGRFO6iwzeBk8hdUrX6Xsr0qVTlR5hTUd/DAYqqaLD/mFrgA5m8jjpdrHqdmZIf3UNbnvseUXzYfhtAp8cKj3zRqtHMjhJU6mNvGO3kJK9Kil9+fJSEiYSum21Yd/+ib6HfagfCBxkjJYAhuLBpZz
 x5j3Xh7F
 tSigQFqCw+bA2PPcFjc+WzyR3Hb2uYooywqeJHkwunOKMBGTi7r62yvm7KiMmCJ9PrF3j9u2IaAwSxOeF8il/CHfjbauXr7nzv1oiRW3cWeRpj2TNdDu/y25wfz3/AGEKiURC+s1kuBrI2tRchNWeEroEaG71jfKEkNj/zvAsbVBp5rChqzFv/YzpWTiqBhzo1jMzt8eMV3v95m5yxdAm8yuLObiLjfMJJIHRmHT77FGBccd7W1WQWqZFdmq9YOJVdfW+I8r20Q3oPMhGoZ+BvuP+UxmHxpXTk/O8z0+VdS++Y4T6qbP/HtrC5vMYEPEJ5497
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


