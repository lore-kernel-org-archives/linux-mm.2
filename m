Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A20AC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB4C56B00A9; Thu, 10 Sep 2026 07:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8B6D6B00AA; Thu, 10 Sep 2026 07:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA2386B00AB; Thu, 10 Sep 2026 07:00:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 83B726B00A9
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:39 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C48101A04D6
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:38 +0000 (UTC)
X-FDA: 85197559356.19.6E08C84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 126AA40005
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:36 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dVsepamy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038037;
	b=kb6afjkh9Bk+oJXBsXzlwhNlT/7bLBOSwzjeImC+1g2XsKyTVeSZ4ljJmcyev/BeP8LM4t
	Cswxwq7rtowUAwj1yW9wLROfo9OYktlUTwht6FOUZPyDK0uxDsmyCHj7ZGSa8u0rOe930O
	146cUwy9cVgc1CwIazei7B+dSa43hVU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dVsepamy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1G72EbqUjI9oNziOv0XdCQMAxirZYF5Q2JcgCPI+0s=;
	b=DLyw39XGmE0NMApHm6iim12J8DMh+9dDN+Qnxc4VFJrMAP6Vus5hYfY5bkheSdf7ToIfE3
	9GOev4TGVhzx89fNpYgF4eT22cIJoJfhw3jVvT7WhV0lUp/ii6rRib26PMI4JyncfKUT2F
	7Dit7wv1gae8SUiuUA8C+ie65Z/pxEw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D7D343C00;
	Thu, 10 Sep 2026 11:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF391F00898;
	Thu, 10 Sep 2026 11:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038036;
	bh=U1G72EbqUjI9oNziOv0XdCQMAxirZYF5Q2JcgCPI+0s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dVsepamyflN4CWrmX4M5jdM3tEOFYmVaGJYyPMgYyQGltoCu/UE269px5Np++ntkv
	 /aZjvuCUE4Y91WOA9Stmag4LPGRYjgNTOCzTRYxGs7+08594wADyF2AAMrR/QyKEhB
	 teZsGft7BlpW8tIJuTju3U5vUx1MUaskToroQvtiXq43rJKHRmPPRUjBvD8h1CyIsV
	 J8NDJOsqVwu36YLRUbBFcMUQ2BXbS2xOpyRGKK/pg/BHBR/+J3pCXBjxgYnS5XsYkh
	 3Q1U+9JEMdFN26kZQwGgNYEgEsxWcjbky9eG/j4fe29P/C0I52z5XlZ0e4ORSIx8wg
	 YecKXB7wpxmNg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:10 +0300
Subject: [PATCH v2 08/13] s390/qdio_main: Use kzalloc() for the IRQ
 structure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-8-e931086fdde1@kernel.org>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 126AA40005
X-Stat-Signature: hdgopypz68g6bd7d6518n1w7dnc4ke1d
X-HE-Tag: 1789038036-710983
X-HE-Meta: U2FsdGVkX19GR9Pyo1GTLMBVFnjjL9+Rtl0c8aCP5E33X/8gj208ITTRp6KmI71uO5bUDL/nb3/LF4DFvSFCJ9s6PeZg27+m6WAcAeupI15/Ug7Ijg1l/p9Pc48fpmZRN5LyukoPJnf/cjdEL+sx10EfgvBq93eykBTmlvyr3gEKcTWqIUI8JEXp5+QFvk6+QTT0I0p4pvBoeXhMszkzbpAdQ3I4PwcGOqG/1Th0Mnf/JbkuNX5eS4KQ9sq0yzYonzWfGmoog1Yj6nPvDVhFa2l5u+PVijQUy6ijCSaHVrdopgK5Taca0rQEXHrvWhgJdxs86Yj0gqbvKvZ2xgSyGlo1BwcyfwQOMOgEY7RfJHx3t5O5S/n9UD0YEObtbZ6bi+pJp91NtbBcb5Egti4ntOdu4QzpUgHLILMP5fWe6xkS4iBANzFrRdAvntWlsiPozVnJH0aqLYMh7hXYmN/Ub8QSn0vVufdn4QhJ2vsMIy1mnpnArFnBnwWrPi2Q4/pwSvqy974T7D1V20m+xMpSXs86LR9w650dsGj1adgV+bRka/2wKw2MfO1GjxXXyFQFhgOqvKg4eIAnA8CaOL2NsidNwGuC4dUjJmLYBHeja9hTx66i8Qc/WAKQ9m56ubUh4WrSUmd9IjM2ccrewrsE19oaiXtITA4eskc5jFDYiYmiDHSPoZZygmcnvlnBOQa7jB7fgWcwxuKOQ5V+APw0+MDX+SwZW8gzj6dr2f1kNLOximiLaVW59BQ2Qhdw5TaFd+wztwa/6n338fktQOgtdJ0pNxlXg6fXgXLuhwYohMRVj1g5H0R0u9U7rSrxiZ6rzXeoFeHmMgr71EK8L87T+Z9WyhLg91CgIA52Yfa7bnrKdU7htN4OBGMfFODJf3CZPwFFvOZMy5WY73hxjbj2gQYSG1WVai+8pb8CX47/g+VC0vKRkhrK0B4fuUXBm89GEARGfQ0zpE0tD0Hur+g
 Kor8iANP
 INE3hjAjGuHfGM2Kyze684mbi/73BRLQwZuqL93FEe+aUrH5drKsGAN+JoIDxV/VG+YFlGku+w89OlspB7SjtLjCpSR0ae9fK7BS9X3wDL+a7nHel+bpR5psT9YI3RPFDjtkHWtf/Mn8TQcrXd1bTRDYXCuvA+naaY8XM4qSjC3ItdgTCyzjF2eB+h3KGh+Rhnb0Uq1KHMIOKxoSxFwjVRkoP0U26y44dSZq+hY7v69YCefQifqzdDdPQWsWarcjXh3IyLiDwWyKLS+c/QWT21M7WNBA6B17PGdJFP8BG9X9tO3En085WEB+4+RxoC2tUxZZh
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

While on it, drop the kmemleak exemption for the CCW. The IRQ structure
is now tracked, so kmemleak can find its pointer to the CCW.

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/qdio_main.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index d137bf8c70664..28eb8602ca97e 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -12,11 +12,11 @@
 #include <linux/module.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/kmemleak.h>
 #include <linux/delay.h>
 #include <linux/gfp.h>
 #include <linux/io.h>
 #include <linux/atomic.h>
+#include <linux/slab.h>
 #include <asm/debug.h>
 #include <asm/qdio.h>
 #include <asm/asm.h>
@@ -936,7 +936,7 @@ int qdio_free(struct ccw_device *cdev)
 	free_page((unsigned long) irq_ptr->qdr);
 	kfree(irq_ptr->chsc_page);
 	kfree(irq_ptr->ccw);
-	free_page((unsigned long) irq_ptr);
+	kfree(irq_ptr);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(qdio_free);
@@ -961,7 +961,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 	    no_output_qs > QDIO_MAX_QUEUES_PER_IRQ)
 		return -EINVAL;
 
-	irq_ptr = (void *) get_zeroed_page(GFP_KERNEL);
+	irq_ptr = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!irq_ptr)
 		return -ENOMEM;
 
@@ -969,9 +969,6 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 	if (!irq_ptr->ccw)
 		goto err_ccw;
 
-	/* kmemleak doesn't scan the page-allocated irq_ptr: */
-	kmemleak_not_leak(irq_ptr->ccw);
-
 	irq_ptr->cdev = cdev;
 	mutex_init(&irq_ptr->setup_mutex);
 	if (qdio_allocate_dbf(irq_ptr))
@@ -1011,7 +1008,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
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


