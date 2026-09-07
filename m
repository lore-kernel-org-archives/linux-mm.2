Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1519C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A52D6B00AA; Mon,  7 Sep 2026 06:24:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82EEE6B00AC; Mon,  7 Sep 2026 06:24:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71D296B00AD; Mon,  7 Sep 2026 06:24:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3FA646B00AA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE4151A06EF
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:24 +0000 (UTC)
X-FDA: 85186581648.28.B832929
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 22C3580005
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJI3p6NQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IId503ozKlk3cLt2ZvHKfnW0uEA0aXfpIbl0Bze/AnQ=;
	b=X25XuHEj36yQ/72cmsQaR4gF3P4aQj7JmG22BQBoqJ5KRWd9Ins/tgVO7RPhg5CDgoOdvd
	EdoLBDdcB6O3XwrhGK7VUAPXbHYbGhdcZGpUZGPi9QQIkQJLB5oukaZH380Pcrs+EyKDs4
	/O2/q9MGuoP/u88d8ISbSBT08zZ/HHU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJI3p6NQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776663;
	b=be1kLotndxNcP9d7raoiW183P/qtzk9rsbzPqcezbK1uiY5UZJ4gAsgsysibB2RrbSwQf9
	ZY+72qNnfEFMqTYw13OeXOvLU7j9fM79kCQfxmSfnDVuAzt1UtMejZp8vbutzdGfgzDyb/
	qM+4/dBMkvU01QB/6zg+HXtNqEuYLUo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 709934481A;
	Mon,  7 Sep 2026 10:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BCCF1F00A3E;
	Mon,  7 Sep 2026 10:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776662;
	bh=IId503ozKlk3cLt2ZvHKfnW0uEA0aXfpIbl0Bze/AnQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=CJI3p6NQLSFnQpujvGnuTo3rRXUwQLT1SIbJL+qhR0l//VBMu7zVfI8MW9VVEHCD1
	 A5o8GtGZSuVUt8esWePoLVon2FWWNlFflXhI9T3ZbE+5/NZH8rfUDs+2qF/6AlcZDE
	 swiluBjtOYD42LYLyt5+KUkfPzoR1fs1LPkr3+oiqakvqoRPBDO0aW67oWImCRGAJQ
	 V7q1ry7sRho63rWNnkWZjzFKeEgnd5HH4v5VR5ZEkgU4T8RCisUntlkFgfktSOFLIv
	 A2qXHUH9wUJKLUjp4XTZ+jZR7AHfq9iTRq1U/SUUe3a0WD3Qpgn+xvQypPPC8bj/rD
	 0STxseZ4bsSCw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:50 +0300
Subject: [PATCH 09/13] s390/qdio_main: Use kzalloc() for the QDR
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-9-ca7f39806234@kernel.org>
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
X-Stat-Signature: k5u9h6jfyujupnezgmk36iqs51erqx9f
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 22C3580005
X-Rspam-User: 
X-HE-Tag: 1788776662-581261
X-HE-Meta: U2FsdGVkX193DJ6SAld7ecWnD82ot6W0+JJ8lkwKj/l5NkVmO/akf/uBQ219plva7iR4prdVQ6RpcWOjUNGdfU7GFa7wLH6kN38GEi6ip7SoTU+44Jf2/5/2YiHyRhy7Rnc0OdKeHAPZmXlgpEBzunmHy8khMJmB0uJCTmMhw3A7SnGJBCC+lK/fQkRUG4vxvp3jKuwl+WDmEyNuCmTVAPT5tLkIXcNGzS8lVis7L+sJbGKzI2jklQBgztOObHO8f7SC55uhUIOge1SHMTry5UkLEofb/89S4VTp9cRXvZhQwY6+LDxEqSt8MAft12sGheT3YW+l4RkwsdAvuU5O8M+TBvqpVa8434k6LzepsPUuNqrrEielVwhh9iu26HoSgM6QbVCuxdpQ/Iksj1UXyBh7u2Btlra7GdgaPYMubgbPse0VI9dzdRvy6KdVQnBBeeqXDw0ZYTUUSAwaScMKK4tbMs7TsTXxwbv2oXYpdBwcg7Z0VUddH1Z4YNDgj1HpTEMEgFQV6bNxwy7EvpZzSQ8AdYVo+V5jOz9pC85zR6AxWm4rV9BNUkaDqVmLfKBZqKnkX7t00IXj1p33aNmNoorX1OMW/UC/vUFki/cuao+4YhODkmlA6hnYFbkGEU87evpMZ7fCV87pg4Znfx8DpJwR9bAxYX9LmfqEenSz6hIIPK0W5G4TnkNuGS1uT+U+LtEXqCiktYZELb5J/4JGoxEmsV6FCrGBZP+3cQe+i8qQFEDPqSJUFU6ZvJbKwZfeu+Gxz8hSTJ6ZI2+PYJkWLr5TV3gzkB13/QZySH26SeQ5DbHYsaYxmKORN1NCeqoifg//GxJLQ57aDhQPWD7m8W1Y6NNjJVGlcqqxPnWiKRdt9Fuh+PMjDJyOsjyGKLGMGk5pDyrEaKPotwVXmqwIFNiqAwRYAM8JAvMltMnmjq88lYZT+71viqHyg1xgo0u8STfFO3ixwHXv7SSWr5T
 aO/j/97X
 /neHUIQVSKpCnS64WQvta4WgH2xX9YcnpfK89K6PYA1aGh+W8SfMaeeiw5szAhCED5o9y0MMyv03GmX2oaDxDwdOaKn6WkmXmQH8kZWbvhS+H2Fwv5uRSNrqQAW1s90scOX/BztLF5U/EHdx5s62xYh/xe5FWox6vJQMWFNGnxEFjp9lOO39jiBwETofXRWW3KrpDAOAum+ub2fdTmYodWDk/ccUZcLAkKXDMSJvMeOp9neZxEP+laL2/s6Mp+fyMkMMsuz0eQzIZwp+PJ1Uw6UD57hugsBhcUgaMlljJ1KrP0G7yrjCGOB4CH8hv5JoqD7ma
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
index 6b9442bae7ffd..bebc1250ebebf 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -934,7 +934,7 @@ int qdio_free(struct ccw_device *cdev)
 	mutex_unlock(&irq_ptr->setup_mutex);
 
 	qdio_free_queues(irq_ptr);
-	free_page((unsigned long) irq_ptr->qdr);
+	kfree(irq_ptr->qdr);
 	kfree(irq_ptr->chsc_page);
 	kfree(irq_ptr->ccw);
 	kfree(irq_ptr);
@@ -992,7 +992,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 		goto err_chsc;
 
 	/* qdr is used in ccw1.cda which is u32 */
-	irq_ptr->qdr = (struct qdr *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	irq_ptr->qdr = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!irq_ptr->qdr)
 		goto err_qdr;
 
@@ -1005,7 +1005,7 @@ int qdio_allocate(struct ccw_device *cdev, unsigned int no_input_qs,
 	return 0;
 
 err_queues:
-	free_page((unsigned long) irq_ptr->qdr);
+	kfree(irq_ptr->qdr);
 err_qdr:
 	kfree(irq_ptr->chsc_page);
 err_chsc:

-- 
2.53.0


