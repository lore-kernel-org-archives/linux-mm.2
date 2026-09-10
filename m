Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB12C79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02AAF6B00AA; Thu, 10 Sep 2026 07:00:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBF946B00AB; Thu, 10 Sep 2026 07:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6BC6B00AC; Thu, 10 Sep 2026 07:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE0C06B00AA
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 29B69C0488
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:42 +0000 (UTC)
X-FDA: 85197559524.28.B4DDBC8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4FDD3100011
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMW3QUg9;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GAESRwUS4AoT8Fe9vxXzcjqr/ANwAvgo8C6M4V7pHvs=;
	b=gmA8vnZaVCb0EXxCniPFBpdvRE8NhskatyNW+mCIfYBD4Lr5qKiBIlS7IHUAUvt6RpAIuP
	UHXeKx5DusuzksAp6lMm0ztZdUz8JCnaceO8ocBCMyxs9DHzTO4AsnY+LU5dgA0bxDKwl0
	wurxQF6QUpSpGLAFPtPEvQw9R0WP784=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TMW3QUg9;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038040;
	b=pjqE5hxl5Mj2bKpcbCWQNnfQbi4ejzV98DnucBsxOQQqyvaWwcfenXboQ6ouyP/vEftcgG
	VPhjHHFrBDiUz3AR1ZNMKGU4Eu19iVdMh5e8ovAbNc02x6AA1oeZ0UjUnQl1ubm7sDX39z
	WrDFYNFNnc6F6xKhXLjxviRod/vG2qU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D07F7600CB;
	Thu, 10 Sep 2026 11:00:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C10D51F00893;
	Thu, 10 Sep 2026 11:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038039;
	bh=GAESRwUS4AoT8Fe9vxXzcjqr/ANwAvgo8C6M4V7pHvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=TMW3QUg9PZpNiF1fxPHU4S0WuRUIHr/mwgIsWnR5QBsdnMWHEzoSCrCf6E8mrxi+b
	 n4+pJvgaO/qzIwH7pu7BlMUaHhjgLUuM7YMgV7QFahNrhpyNL9JPhMBXo5QNw4dtGu
	 AQRS/01Cj/RtuvBS9+3PxtPG1lsedpKYIPmFZ7F1qEvoRjE8uXq1jVaVD+wfOgM3c2
	 cx2IlWoIbw2Con8kBeB6SBA/BAnEL3GmCPMi3Vuqca/QUalRlrngY+Q7j70q/co++p
	 3nhRyze3rCl64S4hedKp/stcOKNStRSSdJi936bh10aBnjJchvynINrU0i3XWb+wVJ
	 pA7wWPwbOcdew==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:11 +0300
Subject: [PATCH v2 09/13] s390/qdio_main: Use kzalloc() for the QDR
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-9-e931086fdde1@kernel.org>
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
X-Stat-Signature: f4iuebykzru3s74bxpybjjei73js11e4
X-Rspamd-Queue-Id: 4FDD3100011
X-Rspamd-Server: rspam07
X-HE-Tag: 1789038040-466887
X-HE-Meta: U2FsdGVkX1+9deZmyWJGLpWlMNQ0/W1d1Z17uQxYJLrnzuewYDqiAGjIlWjcdXoxhSEtQUk8WypXQ74PQ49u0qiufWHOLJkzlvTE35qTzA4kdlBjnE9wD8MFU7QnJ0X0B1IdqkFsK/5IUfAFeHXdh47Pha3dmWW1jfq9AW2UcXahZuG5CnMbLs/svfmbNQUiLUepFDxpoh4g92OmyasPtpQGESuzdTceCy+VBdgw9luyqgmSbNcyR4oU27zXzmEPv0x7MRTTHh3paq6YlI8EYcuG9Hf5GDhzXyifOhIDrQ1/vGpqMsoU1q/SfUdemAktDIUmQzuDWELhJGAqj24DcOlHYAf4HU8nVA/dvxdePGmDg9DUWFe5iM3hoFQFd465vj7VH+usFpHPMdt2ok53oTze6P82+KR6omxn6J9GJPzFX9QMkD3dwDVb4xAFMDvCFW0D+SP7kN0Oie3/fK5qx8BfPj8vTf6F2N2iK3LBh3sPWtkV26WA3OR6qcOZ2F62kTHjMIkgA6NZh+hWsuWXzVihjsEft1wWdCb6mFPRgeVoNBQRyfLbMOBIoQkXF5DcpAdqiC/dRdxKK54OqQFge8FSC0ecGRk2W/20VjP6OtdZC/dGGjRxi6RArfB9EVx7NKaoWXr8QYxShSPN35+9u5rpnzVcMMqdx9gNRFDpQCq/q99U2ldkWOC3VzRs29UdcKXa3mgja3zjvbP89IDltanQtoX79vX4OH2kpurLQe4pEEHrZAatk1Sjr1c76zzfutblNPBYHde4BWTU+4DPkn3OY5P57DFr0KMobkN+zx/2mHmW+9jTZjLPCqidQ0fVSNUfcVZDwdMLd5IDqzytciyiBJBzxWIV7l1WQaCuDEHOnVznIB28ZDeqvsoTZ2d7x965HEiHeMiy5XLVa9NPb/YiyxqBRQRORjcluxpmKl8bgvailwarR2Ro3/BCKIYGi3DAawt2VRZ9AqLiSpC
 +ImWHeTv
 OtX0wFWWD2sQd0mYEOa6yqQVTUWp4dkXKg8pxrAy7/sT7S+rK6rzgdsGpMKfB53++eALRHzK29Nio5SWx0wNXUldYPRpL5J6NCvz/hmpU0Ka/Z3kTL0Kboms3cjxqnjfx7DYuEJ4dS2uH1ccnhg5I6gciWm2V/KUUHqmjRxgjuQPJh7jQPdaB5I9zHmc51d+ReykxA6nklQ8fXQDlTd0/yWUz3yR3NQzbS9g8EPmzmVNLQsXVRZsAp7ha6DHW9G+byIDtXYK2MztDH6fvCExzxvtgX4G+Co9FtpP6ylaYWG7Pr+kf6isTRL4ONQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

qdio_allocate() allocates the queue description record (QDR).

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
 drivers/s390/cio/qdio_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 28eb8602ca97e..889f63f94a4a7 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -933,7 +933,7 @@ int qdio_free(struct ccw_device *cdev)
 	mutex_unlock(&irq_ptr->setup_mutex);
 
 	qdio_free_queues(irq_ptr);
-	free_page((unsigned long) irq_ptr->qdr);
+	kfree(irq_ptr->qdr);
 	kfree(irq_ptr->chsc_page);
 	kfree(irq_ptr->ccw);
 	kfree(irq_ptr);
@@ -988,7 +988,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 		goto err_chsc;
 
 	/* qdr is used in ccw1.cda which is u32 */
-	irq_ptr->qdr = (struct qdr *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	irq_ptr->qdr = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!irq_ptr->qdr)
 		goto err_qdr;
 
@@ -1001,7 +1001,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 	return 0;
 
 err_queues:
-	free_page((unsigned long) irq_ptr->qdr);
+	kfree(irq_ptr->qdr);
 err_qdr:
 	kfree(irq_ptr->chsc_page);
 err_chsc:

-- 
2.53.0


