Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33021C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3607D6B00BB; Wed, 16 Sep 2026 08:03:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB196B00BC; Wed, 16 Sep 2026 08:03:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D0A6B00BD; Wed, 16 Sep 2026 08:03:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DB1416B00BB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7AB73160698
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:51 +0000 (UTC)
X-FDA: 85219491462.27.3FED88F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id BAC93180012
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:49 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItwhD1Mq;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LB6kX+FFwnDBpk8VzIo69FZJtwl3A5eOSrIP15c/e4Y=;
	b=FAMrnIM0hiSWGeeZjip7zUQFl6yTyZ63GvA/RFjU4fRb9+0oThV+YDT7rzJQXMbTE4sQEs
	YuG+HbzHrXSNsDOoQ3bRY+5yimcv736a8tWPtSXk+rlea1KQwfGiOWlZ5oBJ0B0p8iJv2H
	SXP314+g5iFZcCJw/gsEQ4vFB43Rjio=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560229;
	b=euURJ3XtzpWDSgoal1C/1UGaSDdFpLk67s7BzQCVSxZtR8+mJPlRCjWUqBc1s+u4tYn5cH
	X3tm8Hfdv3r1a8/l9S/Op3VtMrHTSPxxbc64m2BXmcR6aMbnggcw8S4NjfxowhpCiw82/O
	llBkXMdatAAV4nVWWKRU6ukSvx0Jlw0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ItwhD1Mq;
	spf=pass (imf24.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BA946053A;
	Wed, 16 Sep 2026 12:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FB7D1F00893;
	Wed, 16 Sep 2026 12:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560229;
	bh=LB6kX+FFwnDBpk8VzIo69FZJtwl3A5eOSrIP15c/e4Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ItwhD1Mqn6yU8lPHx1IoQyozxF/eTvq0Qux1vlAAkedoiDk4wmAeOmF1QR5HiK+Bq
	 2XWTqo6e94n9BakGBma98xSY2SNzwlOrhv5TwZtacuWlT+dPmd1yZyaXyLtVCFlXP+
	 Ry9lHc31HrH4jv3M55dxPsnFIL48fv07CeiPA9MNMfM6cbZt7elvXntpbCuj06Eh68
	 Ih9s1GKDAJtsDZKWSroBoWB2CA7sVvwddJ+FaFZv/boIGtS1tlFGzjFgNhnSAb6rs1
	 WqtZOQaAkSIGKeHoUwv6I+mdIwJYkLwt2HCbzRTbwpugh3zYKQ0EicYcg4QzmZ6u46
	 9l912jw4GB6ig==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:17 +0300
Subject: [PATCH v3 10/13] s390/qdio_setup: Use kzalloc() for QDIO buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-10-39e4894637d6@kernel.org>
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
In-Reply-To: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
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
X-Stat-Signature: kifx1699g6hm5zs68fugry5iu9ktgmna
X-Rspam-User: 
X-Rspamd-Queue-Id: BAC93180012
X-Rspamd-Server: rspam03
X-HE-Tag: 1789560229-546163
X-HE-Meta: U2FsdGVkX1+JP18kPDLVuiUVU50or6RKHgB4xTj5KFcXkqY1TISXxMawi1jsz6aIgZrADYl7ihTOYuk9jPoU9hedUo3YODaJD3d+o5X6ja34LLejfyQFAiGSEH7JDPLXxAaPzhKqp/xHM1w0WxOpjSXd3KGdgLVJJXd5KDDPrlUWYAVbsEkg+khXQDh66fUOK4qSIea4iRZCyroTWRymeRS47sca5FouCq7oeG1lYxym+mXvUXHalXqHXznpZ6QUxmnXOj0drUV42h86zHzWDVMSxr75C0uNhFjDG9+cswApnSFg+syS9Tj9p53YOJy9CdGImQS2K9Lm3mjga+F6kM2BLV0URu2v4qFjE8pCkGluNjYEnyVnWNyzJyVoq8gLwoHsTf8aTI6IAWuvhaFxwzzjPRTSdUX0aCTyIY8+Q1FANH/vTpV6B4JN6qbuuKR66RHE6pxqEwdXaJB+ow8gDJvpPDbTA1U+t2VFhGBgjrdLq5dtv5zFwnzZ7L9ujubWj288PhJkk3PDwb4aIKdDhKJe1iViGCWT2NjVv7uTVXGWVKTTW9v83Mj86VM0kqq05uDpTl3/gTE+DPN1/eOItyXEIaHFfXq+QRYxV0JydfAJYXzL3k07GwONUD8MIJVo6AnPBKWUEAGXtMwoe1SgmCEU5BnveC7wXhI87dhxLltqWPImDoQBnlbP4O45pe3PHx6gnFx1kF/LowZAAZHUsGaUxOnLqWTNVq8dtIuf0CzJzXWt8FtBEi/uGG1WgIs6wEEDrUSCCUjIBgJbLhuXSbMknWg2eXhBV0puP3Ey/6mQRRBoLqGfoTLnqNSF9xAKmMkgW1mvgyW3d5WAzixf4ikcPY7WwJawEdXmbStje1yp1yhoGy4BA0w9icfmLDaUenEF9x/Wl4FTuRnxSNgnFDttYxavwNEVn926JA4p/f95Q3xmE0IZpREJVkydrZGiYqiKdAN9qq0uLS5Po0L
 ZI9sqwuN
 wC4Pb2HO+Rx7sC6+DvYaWnk6VZMwkIANgdyGdPUKnZEpGG1TGzlDGF0SDfmAIAO2mEXSy5mpfn2J4Oy+/pgMQqT7PRxM5bictxiVp/sGZd5qmOKVRL0DtIwtsMUnj56MbMBlYHFd+uK1yfDskrHQSWd8uFcfkMNgKnjqXLlUVOwDk1BgSaNUY5iwtp29V8mdLc7KLgkksww2hWpfJzZ/si0yEfMHWUIiKsf2I/q3FtCbkCIQs7vYjirzYGFptJd+4kBQmi07ePZLtMt/yxUEnGu+HveABmZO11WlVprOeXJFlD67GDUME4k4KEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

qdio_alloc_buffers() allocates the QDIO buffers.

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

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
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/qdio_setup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index bd80703c174c7..b6f2ff202fe64 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -35,7 +35,7 @@ void qdio_free_buffers(struct qdio_buffer **buf, unsigned int count)
 	int pos;
 
 	for (pos = 0; pos < count; pos += QBUFF_PER_PAGE)
-		free_page((unsigned long) buf[pos]);
+		kfree(buf[pos]);
 }
 EXPORT_SYMBOL_GPL(qdio_free_buffers);
 
@@ -49,7 +49,7 @@ int qdio_alloc_buffers(struct qdio_buffer **buf, unsigned int count)
 	int pos;
 
 	for (pos = 0; pos < count; pos += QBUFF_PER_PAGE) {
-		buf[pos] = (void *) get_zeroed_page(GFP_KERNEL);
+		buf[pos] = kzalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!buf[pos]) {
 			qdio_free_buffers(buf, count);
 			return -ENOMEM;

-- 
2.53.0


