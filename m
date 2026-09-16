Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 772F5C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2276D6B00B1; Wed, 16 Sep 2026 08:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D9F66B00B2; Wed, 16 Sep 2026 08:03:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 002D36B00B3; Wed, 16 Sep 2026 08:03:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB0136B00B1
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:35 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5600D1406FB
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:35 +0000 (UTC)
X-FDA: 85219490790.05.0A2C500
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id BD33940004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Hurb/eAm";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NE/c7IMcBZdCzVyFsxXaIo3nYpN6KWCimcqlbKV3gw0=;
	b=8meiARbeLaJ8I6B0HWTyJ1Whb2qevxT4AycPafnmcccCGKeh36UODdMl0k5/ggmenm6b2y
	KXJoAwgIeZZoT1ev09Jl8C0udy/1g4CDOBp/mammww7Ty9VhoFVIfq2lr7b9ia6yjQ23Fd
	67WC5vpCJwZ8ZyqWyHNBoMzwPhOwtHg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560213;
	b=vwcuNtMMG96BAIjyC0pShiKIZ61M259hV11aZXAMHOIcQKI3Y4GZwc157J+uXfvWDWuPpe
	rHHvLjsqZSFDCkM5re6LsyKhjB187JMeYS5r+YVEG8/14bUi3cQ8CNShbe/0/VgIkNVRfv
	Y1UYevTqSs938HlB5aoh3tvQ6vPDDWE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Hurb/eAm";
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 58B076053A;
	Wed, 16 Sep 2026 12:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C93F1F0089B;
	Wed, 16 Sep 2026 12:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560213;
	bh=NE/c7IMcBZdCzVyFsxXaIo3nYpN6KWCimcqlbKV3gw0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Hurb/eAmlQUwytzx60cR7oXIXwPA9vQ9j3r7mE5ESHPcxyZwpxAIKXedhTuem/7+4
	 k8VJcCj4MvctRgAIRQZzv9lPBK8r+oWCR9GlPv+9bM9PzG8AZKhenrd74PlzLwcoK/
	 C9iwWhoecv5nUoGvli8YQnAB6j2mMBVNl91ZnMatnQnoD06LhHPKeU/9ud6HpuHYbh
	 ZHlKMVe+PMyggGdXJmXkv8WAvH8eeUe+/6MqH1OyusTwnPoDeOy7d81H2i7l8HY2RU
	 kGMHU5sjGvBOZq8kV3KUP87V/yB7P28VA7MZuqJIeApCocYKcM5t5WgSUR6dVC5gXW
	 3G2leQwBMM50A==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:12 +0300
Subject: [PATCH v3 05/13] s390/cio: Use kzalloc() for CHSC work areas
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-5-39e4894637d6@kernel.org>
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
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 5mjk4pkx7gtkk84coqhaco11m9p6h9nq
X-Rspamd-Queue-Id: BD33940004
X-HE-Tag: 1789560213-666981
X-HE-Meta: U2FsdGVkX1+kMXJqldCZ3a0oE9sDN7Vq8kCfg+a4Ywx1Irp7F3dd4pZjyUIrT49i5XumuPmFRHqyeLWtTOwwTKkdIsaD5WJwVhObpqzd3d1WoKZVMs0nBD16ZVdbckeo9xhBelXrkRZ6oDpSuoVqd0CBc9JYjwsOzMyNmbBHz9aIEF5YXhEvozNENCLgtVcGXrALZXybdWvSFAdyVV84CQi9ZfWB7+Z/4jdZ66Wm9kovvKjKHJ4RB+XkYR0FCtHkRPiY8awsssy5TRqJQKc88DbTDlWzqSkLEte+o8Jlef0PTF+b+pIeU3sOsb9QZ7PsLyZG1zQEEUPId9eN9B3skH0TuM7sryBFJw8SWsEWwoEvJrkYnEIVQ4AhWJM6GV2DSxEXDwIFXGVQzdH+UP8gSptWH732I9LKMWRZOytiPBe3zjtYoVh3Ry6dYhjDQYRyGgU9LfNl83l7ZQhdxBvdGrZcGS4WBTh/8jGAwlZ5840p1F/T9DJD8tMlVlcAtGQ6aVT1fl3IpnUMvvgc/h1txDGoIQA12m/wLqU4jHjihy/9s93TYorBDc9rOLMeBBsOPzb4Dl67OR894A039yl9NcF3+e2hMKr1c8VotGVEpqUnjH95ueXAvGoa9aGpTL7poLAUjlNGoO1iotWXkzBgB6UaCxL+bh3zxDKJICgFhjUnF0Or5stj9mTpy7/b+azIf7XOxOTX2RJK5iZxgGXYdzXcsTvqjYJbY3ZCqNTcxKy+ItYczl8WVw2+UIdX3XVB0ZwA1R6ApMMAXO5PW7QFpIR1AqO7vTIMr+8pn26GD5Cer9QqkyeC1eeQkYRWbRgrEWoBYJTb2sgEGIjvrSjARhPLagsz5UFLzQFXZHA9y0ReLO+m2A1hv901f9okkeXSK5FA9ChpBmfjOO18ocfboUh+x51A2o9XPhAHnWPr4e6Jwiq6gq+1vSQSu9AUbaZBQh55Yg9nEFoKFoEw5yU
 jO8x1vZ0
 Wr5dDkQquLcieyKLy6oQaIZWmXzhTDBzxZS+owpnRs1bRuSPT10TB0h8vMBtb8nOdrsDPOjJ95LkKsBatBpk7ph5XH2z6mFsr5E8WP5ezHjrO+hIjGST6QPzmfXZIrOQpmLRXUJD5Tn5VFSzWjfKbIy29yiTywXvInacCb+VI19JMLHCHdYE4HS76HURZoIh0YXTWiHSmuaqU7WfLca6iEDmn7kTt7TeVRP5/dAXg2F8g7NttVVNOSEpUqC2DZ5oPVsqV7Uj5pLuBk8k=
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


