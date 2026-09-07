Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 475C2C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1ED866B00A3; Mon,  7 Sep 2026 06:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177146B00A4; Mon,  7 Sep 2026 06:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 066F86B00A5; Mon,  7 Sep 2026 06:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D62F36B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6D2A61C26E1
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:11 +0000 (UTC)
X-FDA: 85186581102.04.36BB645
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C50221C0004
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aoHeM4em;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NE/c7IMcBZdCzVyFsxXaIo3nYpN6KWCimcqlbKV3gw0=;
	b=4icsG10xREAOALdrutJT0Lq6Fhij6Wa1Y3o/gydbNS1bVvFFGWlODAstKm0/9oN1DTRgcY
	2IksO13Ad0qHgb7dDdfb76HxxYsd2bZFfvZ5gtxoYK3wvT4nHFqPPc42/pG4B1vu2O/zLF
	jNbSe2HvlYytj6qHvhoykuRikEaCt80=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aoHeM4em;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776649;
	b=BhgE2YJYOMoxPnl0Rk3xd9P0tr7YEF0CiAHRkh8Brig0janzI4J/SyPOJa2ucQAdVFrf1Q
	IDHkc175VJuEHTWd6foFnitHz6YPvpO9LvkEspAfUaEL1DE5TyiryvZ/PRFd7hNlGPfeJK
	LQOohz9UWO0VPtJNHFtze7BCU4g/jUM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 642D260D8B;
	Mon,  7 Sep 2026 10:24:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521541F00A3D;
	Mon,  7 Sep 2026 10:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776649;
	bh=NE/c7IMcBZdCzVyFsxXaIo3nYpN6KWCimcqlbKV3gw0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=aoHeM4emORpWMhclCvywlqazbQ5frAqBkDcwKeVvznG5SaQO/7btyXum+zi11LO3V
	 ferVo6XUuN8HzdP6oBkuuUDL47THLj5VO+aafzPuBgybQwn9IpGSQ62Y2VzOUCqlh3
	 R0K+Q8GEx9e9Bvepo9ngdYugleEuMlYQXreqUIt6ZSJdhEFVFrpb2B6B83LY3i4zc/
	 i9Y+juUJMqY2qopO1CDzCOFUD8cGwx6l3pJwi/V6ehTilgomSbTPUlX8Ewsx2gpAs8
	 tNYNXgSadOVAjGHXAKW5cUlXIp74SzeWA5YgzwFGoeZzJFBwHt93DDERYES5AHdc0B
	 X/uTY83VzVKXA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:46 +0300
Subject: [PATCH 05/13] s390/cio: Use kzalloc() for CHSC work areas
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-5-ca7f39806234@kernel.org>
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
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: jus9yd77p9njikigp43sxaenbjuus59j
X-Rspamd-Queue-Id: C50221C0004
X-HE-Tag: 1788776649-847229
X-HE-Meta: U2FsdGVkX1/Ke8w8Ewl4JMTEoL3QNSmcnoBtXSJM6Pzl/cMh5zUGs9GWQlZtoCoavvu3eA2ems7JkTLkHcoDBXRUBU3cO6h8c+YyAfo3CPJ+fxCV4GcIkLL7Fx97MUXRhlrB7dtV7eyS+JSc1Tugrlp0UkaHIN0SAYmNnJwSf5XnpdwEf50ZT/QBoFSxZ9WAvoFJrD7WhY93xqeRNT5IbU262fHcNQXV4CzS618yk58Tiprs+60uyzgHTzWQNN7dP5xdS2ki5lf+/X3YmK+BjU7oF3FtszoS/LqB35dab9QRT3bzCSSGr5J5ABzV/8Ltek4IQ0T0RIJ4DliC2qj8N3d2xjTccgChmWocmZtBKBYSS5aVjlRYLkGcK4ELws5peWel98XYxqlvGZKFxMbCUbpAn4WiFyi44l4mzzwj3ZQjHtrhYcjfiZNAoixyOjPSwES3SvEHRbW8vymCnOWTDY/7Y5Y2nR+8eVbtVJ3S0l1AWi9DWH3LKEvysSF8jYbtiETxw4Yfq0UL7LMVEt1nX6TPlg/e79s13XQxSDLg+Rq39V66foGDy3c9R4h1t3OYaxvwNjSQFYkhOndwnTPXkH0kiS1JhouvYamNykYc181lV8a/HCEGSXL+fs7XPLkjYNGtCIMfcpejRVF4EiZHMo8KqAeRMXNMcKIoSvZ71wDTCSpOrTG0QMGoLN48+IcD4ux4Nfcmod1ynCp5ssgk0i15c2gH1w8aragWwWHpxwY8lf00WSY8JBddxAQwZKSmReANBWQohnM//ik0zj7MR8oXC4AJ46C6zg025HGJHkis0SDbAfVX+6xg4VJaNa9WSH161FyrUxWHcKP8A5EHRf3KBommU4UbqA8Ay/b9F7/POYxFTWA0YgJMFTIHtvtD8uDAmffaRounLxnKbl5D7hUrhtnNj2KabuhcVPFRBSJ6bXXA06+/S/8uyMLy3JPcTUVtjGQtWGrLzv25OoW
 ysjRYvy8
 DAsK/q9ClmSofPxfF8IR8HbKNBRxdJzRycfXJpcIGAWafOrWPg6E4okPevi9oJW23uB5N94HMmXPxEZxtrnoPi9QEVIrRZW18ipD4zB3G8GmWbNKdKZlWkozeExV/NlKV9uB4OjuKekHQD4Y2nBFIjs1Bkg1l90VcMxgJj5JPSuf2TDZrUWVz1zxpI5JLSrmlYBUXic0eD2+AhjZQsFkcY3JJpS/FK4m8t+CeSd+SHUOBRmNAkNsPJQe4Uw11axfZviU1FkUGga3M2XQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

chsc_init() allocates the work area for CHSC commands and
qdio_allocate() allocates one for CHSC calls during qdio_establish().

This memory can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

While on it, change qdio_irq.chsc_page to void * to get rid of the casts.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/chsc.c         | 6 +++---
 drivers/s390/cio/qdio.h         | 2 +-
 drivers/s390/cio/qdio_main.c    | 6 +++---
 drivers/s390/cio/qdio_setup.c   | 2 +-
 drivers/s390/cio/qdio_thinint.c | 2 +-
 5 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/s390/cio/chsc.c b/drivers/s390/cio/chsc.c
index c3186c0a372b4..d98f629e89295 100644
--- a/drivers/s390/cio/chsc.c
+++ b/drivers/s390/cio/chsc.c
@@ -1143,7 +1143,7 @@ int __init chsc_init(void)
 	int ret;
 
 	sei_page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
-	chsc_page = (void *)get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	chsc_page = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sei_page || !chsc_page) {
 		ret = -ENOMEM;
 		goto out_err;
@@ -1153,7 +1153,7 @@ int __init chsc_init(void)
 		goto out_err;
 	return ret;
 out_err:
-	free_page((unsigned long)chsc_page);
+	kfree(chsc_page);
 	kfree(sei_page);
 	return ret;
 }
@@ -1161,7 +1161,7 @@ int __init chsc_init(void)
 void __init chsc_init_cleanup(void)
 {
 	crw_unregister_handler(CRW_RSC_CSS);
-	free_page((unsigned long)chsc_page);
+	kfree(chsc_page);
 	kfree(sei_page);
 }
 
diff --git a/drivers/s390/cio/qdio.h b/drivers/s390/cio/qdio.h
index 4bd4c00c9c0ca..dff5f53a8795d 100644
--- a/drivers/s390/cio/qdio.h
+++ b/drivers/s390/cio/qdio.h
@@ -244,7 +244,7 @@ struct qdio_irq {
 	int perf_stat_enabled;
 
 	struct qdr *qdr;
-	unsigned long chsc_page;
+	void *chsc_page;
 
 	struct qdio_q *input_qs[QDIO_MAX_QUEUES_PER_IRQ];
 	struct qdio_q *output_qs[QDIO_MAX_QUEUES_PER_IRQ];
diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index c1e09fa34e774..d137bf8c70664 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -934,7 +934,7 @@ int qdio_free(struct ccw_device *cdev)
 
 	qdio_free_queues(irq_ptr);
 	free_page((unsigned long) irq_ptr->qdr);
-	free_page(irq_ptr->chsc_page);
+	kfree(irq_ptr->chsc_page);
 	kfree(irq_ptr->ccw);
 	free_page((unsigned long) irq_ptr);
 	return 0;
@@ -986,7 +986,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 	 * qdio_establish. In case of low memory and swap on a zfcp disk
 	 * we may not be able to allocate memory otherwise.
 	 */
-	irq_ptr->chsc_page = get_zeroed_page(GFP_KERNEL);
+	irq_ptr->chsc_page = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!irq_ptr->chsc_page)
 		goto err_chsc;
 
@@ -1006,7 +1006,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 err_queues:
 	free_page((unsigned long) irq_ptr->qdr);
 err_qdr:
-	free_page(irq_ptr->chsc_page);
+	kfree(irq_ptr->chsc_page);
 err_chsc:
 err_dbf:
 	kfree(irq_ptr->ccw);
diff --git a/drivers/s390/cio/qdio_setup.c b/drivers/s390/cio/qdio_setup.c
index ea09aadaae4ec..bd80703c174c7 100644
--- a/drivers/s390/cio/qdio_setup.c
+++ b/drivers/s390/cio/qdio_setup.c
@@ -253,7 +253,7 @@ int qdio_setup_get_ssqd(struct qdio_irq *irq_ptr,
 		if (!ssqd)
 			return -ENOMEM;
 	} else {
-		ssqd = (struct chsc_ssqd_area *)irq_ptr->chsc_page;
+		ssqd = irq_ptr->chsc_page;
 	}
 
 	rc = chsc_ssqd(*schid, ssqd);
diff --git a/drivers/s390/cio/qdio_thinint.c b/drivers/s390/cio/qdio_thinint.c
index e167aa75c3dff..a2ff51887537f 100644
--- a/drivers/s390/cio/qdio_thinint.c
+++ b/drivers/s390/cio/qdio_thinint.c
@@ -136,7 +136,7 @@ static struct airq_struct tiqdio_airq = {
 
 static int set_subchannel_ind(struct qdio_irq *irq_ptr, int reset)
 {
-	struct chsc_scssc_area *scssc = (void *)irq_ptr->chsc_page;
+	struct chsc_scssc_area *scssc = irq_ptr->chsc_page;
 	dma64_t summary_indicator_addr, subchannel_indicator_addr;
 	int rc;
 

-- 
2.53.0


