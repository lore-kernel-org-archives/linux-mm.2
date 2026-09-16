Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A92BC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:04:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 386CF6B00B9; Wed, 16 Sep 2026 08:03:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 311F16B00BA; Wed, 16 Sep 2026 08:03:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B2F36B00BB; Wed, 16 Sep 2026 08:03:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7AF86B00B9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 662761A06D8
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:48 +0000 (UTC)
X-FDA: 85219491336.08.03431F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id B0742C0002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a6fFas1B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GAESRwUS4AoT8Fe9vxXzcjqr/ANwAvgo8C6M4V7pHvs=;
	b=mpbJ1jAQbzw6GWl7KBduunIlheNEHiROGr9ICIjeZXgsBOIp43gbdplTJNG9sEBCEhmnI8
	v4VEPHnomLYL6hqCxaBz1tURO2Hi1eiNJqNO7YXKEUFUwylICWDvnqy6LilJu+ck/w3CIs
	vW6AM4sycXVg76TU2S4FAwI9lpY2jos=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560226;
	b=z2MlUuYBDlcPzzFQ65ZE5Wj7/nruzrP+XooSaToJwwIwDwIx6ZEXyC4KRuNu1ezIIaZPz9
	6vH3Gj1Qp3xqCS+D/rFY4pyoDB5VJBfpB9lkgPUixc/TiJlFinlSyN+jTlLpdW061uBoPe
	flZhAYocgpz6AxsFU6/rknSwSdJom2c=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=a6fFas1B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1207743BD4;
	Wed, 16 Sep 2026 12:03:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5276F1F0089C;
	Wed, 16 Sep 2026 12:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560226;
	bh=GAESRwUS4AoT8Fe9vxXzcjqr/ANwAvgo8C6M4V7pHvs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=a6fFas1Bc27pKC1jQ/NkBXM0GYbCXSa82qImbsgbod4ilaTgi9SjJGRCtvOVYxpW/
	 qVcv9GI3uHMODJ7+tRRVAeuCE17oUOTATFrKBEAW3WmjjhF4G1pcXjCztOycunN0oM
	 279Eud8rdiIi3IZFrvyawyqJ8tqiGhG44Sr0xYOz7bG/lmqK2EPx2nXeYWxIG4W/b+
	 XV8Hi5hZn1Y2UrEMatxNrVPWUOflcK4YcrrjYkoEvVH2U6SXDf/HfhTMTifY5eP+AO
	 MCIZKAvRNX1dRS3VCu8JVKs92sxX8UQPmFBoq/R8ZgI3uO+brqUJQ/25Dg7W6liu+B
	 uwGV8ibY/dDLw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:16 +0300
Subject: [PATCH v3 09/13] s390/qdio_main: Use kzalloc() for the QDR
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-9-39e4894637d6@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B0742C0002
X-Stat-Signature: z8mans79pgknpowg5s5781q3wuxiuzsw
X-HE-Tag: 1789560226-217352
X-HE-Meta: U2FsdGVkX1/FHaRjuLB0+dJpoyZew4/w1WQ0+ndFi9/Qb46GbMgn+tITs6+H9DNawmDqhCTWWGMronhj4CvAQxTFUP68K5TqWM9UlzqI1JRZCIV1WDFD0fSo0b2JC0AnrKT8z69IhDKFRgDfOhqY0jNXYDx1U8yXx5CIppteD3fFrfj1tVQtUq1YqvJ/Pg9XOFDv0quaB/h844ppqG5z/Qf/w8Jmsg5Vpr4///ssHnFShGMoxSkgCe1PS+uNXq9TlEZYS0WdEa/XDBp3k1TvWwjFs2qUukMl1I1uOGSTRgQoY7q1BDRJxO6cZI5acWjcbQ5mDP+ifmggaNjBP9KUMzksuSenpT5p1fXPB6tjmnsstt4uUpPsiQs+yZYla6lT7NMcQEvlBPehbb7mvI2p2B7QTUD3EoAGKtX+X5kYRC1xRjA5Ss7nQKzbBp4OvopOp9HozhVHabEhsUcRtVmC17OmxugvAtoDO8maZLgNTeSQWYZ2bDZkv7AiiHMlHxsIAPmgLzhBf1mFdaMka0QbqGGzqmhF9BcE8p4nQ1x+P86kwcYhkKkpYLW7stgpO1+St/HESa2shQtkzyeAKiXlNfbk3MH3qOL8iUfNKQWFbQExIw9Jb3UnSZKG9dsY3IDSnd80Q+w/skUQ2qE+uRKN3NboHFLWgMIIE6BwZtA6439KAeIyvOGn/Lnvk9ISEHew+w1tZYL1BrIHRqyzMfK67lryVTu5hQeISR52RWHdkYIU6HrjniTF91GmweIz4SYoWVDHtjmkeE/rTLpi4m6hUqgIym1jOYSaqmBVgMsEMpFDKTsI+TgoN2MELVgqg7JPjBm6K0kYoGy/jv3RUJ29P2V8PST8fuCz87/ZNJsYocbWZIkYBzywTFujAT3EUY9UHeb0xfoYixltqr5qKJ06z+PhwA/2EBHcYojyv6Ss3Uj1h5MJk+P4dSSwA2JknmW3PuBS/V3VxcqT8fg0S4e
 V07mr2TI
 ibRS1iHR6if4D3Jw1+reFCtRTq/REwNUq/IMoSb1tdZCD+0EaLrRPXPh0qddDn9v/JQypNCcKbOIMEHu8IAWfhAuS8/Q1MPtaA8D2bf+F0J0c0hIydzQbyypG3yRVeztNdSkrcxqKUYOvlsFCYDCgHNSn3Xcb3+olLRkrsqqtz0GejhfX6Xj5kSzbuQhAGMdztDw4VZKtS+604vlpVtBR5CO2pq/pFX58jAG9AAcwHKbbVTx4J4PqEe63v9JjVB6l5KwkEPso4no79ujmQNdd1CYEB2rinOcmZJyOIwNme0rnDVBhdD8OHQZa2dqNF4uHmK2x
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


