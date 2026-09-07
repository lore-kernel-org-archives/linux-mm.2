Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA577C79FA9
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 528B56B00A9; Mon,  7 Sep 2026 06:24:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AC6B6B00AA; Mon,  7 Sep 2026 06:24:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8666B00AB; Mon,  7 Sep 2026 06:24:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01D616B00A9
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88820A06F5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:21 +0000 (UTC)
X-FDA: 85186581522.04.4D444B0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id CA9F1140003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqniO50X;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdnExtof1dKOLJGTwa/OAp5uv9yMjbL/vk77sD1NPEs=;
	b=SKf/lrHHiycyn/qmiqLAbedHLWfBNSfD2cfkqLUWvs2n9+gD0tiMe75pKS4J6gjXsC/tzw
	pRgwNdQY0VB9BGhncSE7IAbiSzm1FZBG6PfT/woZBra4Es/ZTfg6wUltxT+rA1JuLlwRh0
	JNNk40rb3S7AThhvwfTEZcTZYmBzxkg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776659;
	b=ovNmgmn225lXXxJdAJ1QBrhKgJvpTsq7S1nDwlDHXeQ8xXbVyLJudHwB934OtP1ovq/jtH
	uZVY8WgrulVJd5xBJWPf63O7cZxsKCVr71IBr0X3N9Q8aiah+HSNkHtYU5sCelgfQuZ5dq
	zgoGpBqrpyGWv8CowtyN6D2Y45FT+GU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gqniO50X;
	spf=pass (imf09.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 27E354481A;
	Mon,  7 Sep 2026 10:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 406441F00A3A;
	Mon,  7 Sep 2026 10:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776659;
	bh=HdnExtof1dKOLJGTwa/OAp5uv9yMjbL/vk77sD1NPEs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gqniO50Xnm5LZ6TI1YBZUE3boTXiiXtNpaUeMHZ1dhx2wnceBAZAlHathU9YU+5+h
	 +6XIiGTfOwr6F5D/o+vgVHo3uJ0bU6MvJvnTDYNBdrCKd3n9YniIPnO4v3HIJGtFMM
	 mnERPheRMSTGehIkkax0QzNZQXB8j9ZUw9vzWgzeeIYIYgtfYywhQG9KFvxWXRPlg+
	 E0PhUizv66lRAu5bMUZltm5s05v14CJm888V+ir6uhECVqNeWNp7j6hMi0D48l8ISx
	 WE5NJAqD9mJYOL2ONticmCrz0bJhpWcaAVOqU6hdFPGfJZHXs8cBWL1idJg+hj2Mh3
	 xpnNdGOPz4xZA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:49 +0300
Subject: [PATCH 08/13] s390/qdio_main: Use kzalloc() for the IRQ structure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-8-ca7f39806234@kernel.org>
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CA9F1140003
X-Stat-Signature: axk984nxwe5t4zme1881rrpg8guxrn3n
X-HE-Tag: 1788776659-863762
X-HE-Meta: U2FsdGVkX18o9qJ0PkidvyAUYvtJtaG6LNgw6hy8UhVDlywIgevwAXvHy4VSXv28oER0nk+A+P1tn62R4e1Jur7k0MnR5i1XktmQU6f/48uRz/Iz8RnIu7KnHhvBux2M7VzIGk//3JESEm7VK2IiEfs/UeLUo0ec8jSqbXat3pc/4urHMfx+Ec4/GEF0OlFzZ2OvCzNXNu5E4ZpEZ0gjNL9bhnKZxwT+QjmwmJkwJjg4E84NAruWcgOm+yvlUvZFkXBmXYdeA9ij7VRacbgIBQdi3PzL13UT28W1ANB8Tb/KiDV7g87ls22yQeYOl1oqnNxYMbfjgxXJS2JqVLr3lsjn3JGb+4BKm1CbiIu6nI6Y79b6hE087wY2ZxJG1cAmhbxLCOHXBROV4lxXfYLqxSci330uULad0lGaZxHwbtlwUj0T/P9pUza17SVbbR6xUIK5xX8JQzRfTAkate0ksSC9wS8vs1Dp5iQed89chfaN3HnvcVRTOQXljlzjzsGM1otOlgjYmQXmxKpjv67Mc7+OVM0y65KiVNMzQu2WQ0gEGdpEynwZRDBo2rpW+2oKx1cavweSE83jCQiGYoKrqfzJJjZbQ5WDvBx1yhjDMmFeIO77aMUpdL+AYsEWpd7WOKMZoKsCtsfsMv6BnA1HzB1ZqgCYI+O4Jd3wfVSeAkmSLZ/oKBRhJMPvY4oSqEwP4PR7CfeFTsheOvTauimLiISIDbxoLntcZmrBOvHkvKQjBIsTPokOgbVxS4RbwzMHnSM26WbhFyLuXhDfix4rTexaSE7XO09l45pEpzuLx0mpYcD6K5gi8PfcKN4eazTqZsR2y01V7/Ue2BUKI2Ft9dswT1Dkl5Yj9X45fZpiZC6MxLoiAhc92YqXeZgV7bE1OW/0f9hpOkzzWaVYsigCCwyEZptoAbxxOAVZ/hD8/O64NXY6LZVxvntfFACtjHyos984Y1gYN3u7lq5kTti
 tKEHvyFY
 dC4pzNohQtneI2nMm+bznFMt4G20rj9oBlTWbvGWdkg+jfmVrCdTQJLm1ISmPiZHk6BKs7ZX37z6MPKev1hIl3QMLOU14ILHRli7/DW+A0J7X8s+o+JN+mTM2j+6umdBBQ3ty+M3PlhyQfiWs0lmdHNnMjQhNdO5Lws2uxeXc7vxL7EfVW3i0trvlj7IG4t/XGVxDVwIHAsJrRAynXinkvBo4eSWyJLXetjjUveHN/WNImfywhmbGda87duEEu5pm/iKqUV0LMBDiFg1UIeXXxeQkk89jjfhLbcuxlOmKlv7ZnWhnQ8Ah6zuqMM9j0Mc/88jI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

qdio_allocate() allocates the QDIO irq structure.

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
 drivers/s390/cio/qdio_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index d137bf8c70664..6b9442bae7ffd 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -17,6 +17,7 @@
 #include <linux/gfp.h>
 #include <linux/io.h>
 #include <linux/atomic.h>
+#include <linux/slab.h>
 #include <asm/debug.h>
 #include <asm/qdio.h>
 #include <asm/asm.h>
@@ -936,7 +937,7 @@ int qdio_free(struct ccw_device *cdev)
 	free_page((unsigned long) irq_ptr->qdr);
 	kfree(irq_ptr->chsc_page);
 	kfree(irq_ptr->ccw);
-	free_page((unsigned long) irq_ptr);
+	kfree(irq_ptr);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qdio_free);
@@ -961,7 +962,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 	    no_output_qs > QDIO_MAX_QUEUES_PER_IRQ)
 		return -EINVAL;
 
-	irq_ptr = (void *) get_zeroed_page(GFP_KERNEL);
+	irq_ptr = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!irq_ptr)
 		return -ENOMEM;
 
@@ -1011,7 +1012,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 err_dbf:
 	kfree(irq_ptr->ccw);
 err_ccw:
-	free_page((unsigned long) irq_ptr);
+	kfree(irq_ptr);
 	return rc;
 }
 EXPORT_SYMBOL_GPL(qdio_allocate);

-- 
2.53.0


