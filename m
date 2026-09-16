Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3325BC88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053AA6B00B7; Wed, 16 Sep 2026 08:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0063B6B00B8; Wed, 16 Sep 2026 08:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36676B00B9; Wed, 16 Sep 2026 08:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BEADD6B00B7
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5517A140700
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:45 +0000 (UTC)
X-FDA: 85219491210.21.26758BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 963DF100010
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fcm9fdtt;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560223;
	b=kXQVFDKNOUcVgr5xAFUw8IZ66wjf4DDWKSA3UWvH0U8jclNjy3vhjhGdsAV+FihxGPknOH
	YfCdz+kakHAmFYrPqQDWETVIhBAqdNEf4yy2N+PDzvfQxWjme8e0TAX2/owItkiblwY4aZ
	C2AS4kYCLy/+UUybUeWWeAGQbiGvKck=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fcm9fdtt;
	spf=pass (imf05.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U1G72EbqUjI9oNziOv0XdCQMAxirZYF5Q2JcgCPI+0s=;
	b=V4n5SKGTGIFr9CR44bRdWJMAvfPpcumBb4pa0OaNmC/UXPx9PYaQmRMKsEHXT+Ix/tNDdU
	5/el3sul4IMO7FvNypqFjaECwEk1S3wZ+63xAhJQ/LvQgppFNsYXFgUroJQlBfCda+UVs/
	7jcAzcVifEDu9S1Q1MbSEY5g0Tnm6PE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E8C7E43BCC;
	Wed, 16 Sep 2026 12:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DE01F000FF;
	Wed, 16 Sep 2026 12:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560222;
	bh=U1G72EbqUjI9oNziOv0XdCQMAxirZYF5Q2JcgCPI+0s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fcm9fdttTL0J5d54oDgnnaOXbfP4m62y8rhkTSL8Kso8AsVR22kr2n4xv6/XHwMSx
	 dS3wVkbutXH8B2SFDVIsezpqRL0A4rLC3FwhgQfoVLQAYdk8UyeeDeD1UGNmh8ws7i
	 RwE0f46pnD3le+Fbg4VsF2BERVktF0rEWHDize+t1pLKm5IenmrFkOPrvZc9ne+tr+
	 7J/jHraIIr9WUyc2UsGY0Ld7qZa9Rvw8t97K5xNZc2eJ3GtMQ8tc5484KNZUUe8U8R
	 G6eKu4er/FWQ+EerPBDSVJDjKuhU7qTM++2TSf1B654t2ZJrXj9fUQFWp9Qe484FU3
	 am52O0k6xVoHg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:15 +0300
Subject: [PATCH v3 08/13] s390/qdio_main: Use kzalloc() for the IRQ
 structure
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-8-39e4894637d6@kernel.org>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 963DF100010
X-Rspam-User: 
X-Stat-Signature: 9n38xexeafagzaag55z3jd43twgrsphm
X-HE-Tag: 1789560223-224740
X-HE-Meta: U2FsdGVkX1+sB34E+KDO0D9N08twoc1UTtK3NDw/PNmg2cRA6nD4fHqpLCxBECx2mhvPPWFKsQ3eKsQQJsL423zBCfRlHyOtFzbSOuPDFMvGyLLHrjBX+KvjsVta8JLmW1KeLBsQmElnyQQYMFpOleSMu5afJDbQ/H+6UUufyZ9RTf8eXrZ5T/mwkqh8x/Qcbmnm4pTKpxMfh51Wu1BUnqXGwaqCJHs2B9Dsod6x4htleK9LEKcoxHoTCAjUpBTnCclKaJjfJpPHpPLxrEyPsdXNCS2kbl5YmMRNok8MgdzkuHqOxygf0W7W8euNxcyo20oGg76fU7pbYynGZ+yyd5P5kX4og5TRxuzJreSIwrJLkZQUvIqkWR7Ct6XBwZd0rVXwEPWkvZk0Ui7jc7u8L6SnSJGqoKiKTGjSF/9Ku0nGsb4b18E9gWyjdYsvvj7NbWjI67ZAoKB5wZrsDO5JiHDdgkCJ2gx0I1wiVpsY3H2VmDqbyABalT83YmX54w/EhP7MzE55Z3C4lv1BUotOwb8gPuPFCnI4MARmwCi/B9qbSEZEbm/816UMTXjGfBvnHBwIl634gE3SkZBrXbUQJAn1JZA0NBOrZ6JSTalM6F/9mj4mLVLCyFSgwD25bpTAgeiFGQOc6G4I8btNfklRdTNSo6MQnbz90yjW/0mqiXBLTi+nraMkcgzJpOy8+mHeBH9Uoq2OiR37m0C3plduV4x/f4IKaob96O+fOLnugPqg/neEbHTmWFfH3FsDFX5JUIcEhMKLsQucPKmmW+ox61Xj86D1KDfDmgI0i0D3CobIOduloBCIETtdvYR3a/Ts2DG8sxdr+ToBlS0Lse7+UHAC1UBbJvueEUE0rW+a00TEi1aDZ+4IY9fglT+11rFvXTz+A5VMt4sMJPm4BNGtsKqSbURup56pUVoJ6i8FIPX5Kh89FZ/pMCY+rH4Fd3no4nmbKmP6QOT8WOVLQ8i
 dRBjXzP2
 HSh9mA+9rh7pD9iNQsO/7ObS1JBt7iEh+SA0ibZgMBddaRyO9Sph0cxujN+E7oyW4QkbLLuYjSfgXdcQGeUyfxD28mmRsPeTWL9AvKzw/zXMoxKFiYDqXRqI1x6qcG+geVdyo5Kc1z3Nig+bwG2y1/UgITd/H9nYHhW50RlabU4jzxoVYzoCowxZ/GsNeYt8mNdMx8VgD/+/JwR4ISQdx3gzX/jtknd39ZvwtPx7YAFeY62jFfCGPO84+1jUSqjVvgd+0P3GazxwUGxCEGxB9H2UY7r2bcaTAsOgP9rf8v2cydduxhgVJZqo6vsP0to0KlZFT
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


