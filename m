Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E97BEC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:04:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E0F6B00C0; Wed, 16 Sep 2026 08:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EFAB6B00C1; Wed, 16 Sep 2026 08:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAB826B00C2; Wed, 16 Sep 2026 08:04:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C824B6B00C0
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:04:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4EDF9406C8
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:04:01 +0000 (UTC)
X-FDA: 85219491882.17.313E83D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1BF014000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QHxJnvzR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWoW41+x+7dy6umxK1i5p5XUicgKN/VyGWTHRTGB5Jk=;
	b=tKj7F6T/9Mqxlfnj0dnO7affBJAAK9gQdsIeII1lP26w9BCwYPhXIHPsezse0UQZ0dB2zP
	IKHNQjzh8DI+TxNEuTpUQZImk4/4agy29u6ZQmwWzuhjZhY88AXwCzGQhVA3TcmLHitj2S
	B4WdjMch8CfOLkhv7x4sWUciS66yjI8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560239;
	b=Z3VI/Ma+vnjB2qx9sH/mAz+kuunnridjqbAL0RmU6cLULNhUraXO+KEaQlmdfE2KXEn88j
	TVHUoKIh0xL2g8jCL+u1OYIXYz7X1aNe/k1U5k+4NKpAA/7lR7ZnT34zMn4agM4UFa03Bq
	gonZ89MQVi1fZ+boWC64GCtt3gruao8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QHxJnvzR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ED07543912;
	Wed, 16 Sep 2026 12:03:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38DE61F008A0;
	Wed, 16 Sep 2026 12:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560238;
	bh=ZWoW41+x+7dy6umxK1i5p5XUicgKN/VyGWTHRTGB5Jk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QHxJnvzRpfUEd+n3mGVlS/irTae6iTFaTIK3hhK6DIJ2JzaT2Djq3MUb/dyJckJ5M
	 1vGt2k4d9JTLrmSPWbapaUQilliHh438VOXgxz19lR9UNhcjgu7pN/GfftJ0p+vLnW
	 3I4ky6B36QCn3r55dZPDkPST8k4t5TbUT0SaXJ8ZcgMjLBaZ0fe/KRbrfRlxYI5QTp
	 05c5klUSjM7Ph0ecsLfVDhbIxdb3PBhSV+la2Tl06Dw4jjalyuKVCx3YG713z/l7e8
	 BvsvxFhnJhT78sxA7W/ezHF4ApJvIomAMkAtbrCm4xUMNwn3frhYzueOgmw6if/l61
	 jOXc3qkGWMzEg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:20 +0300
Subject: [PATCH v3 13/13] s390/scm: Use kmalloc() for SCM information
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-13-39e4894637d6@kernel.org>
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
X-Rspamd-Queue-Id: A1BF014000C
X-Stat-Signature: romgsunam8ic8jxks8fzen4zziibtwz9
X-HE-Tag: 1789560239-22679
X-HE-Meta: U2FsdGVkX1+a+FExwat1ONhVQ9opQyVBOmnegjJ5fN57+UD2VF9TkNN6n94GMpmXIBPm3pYObvSRTL3XRHurwzzes6dwsfpYbC6KIFvnknDgCR+1dnWMrNn/U4o5XE/qrkUmaSlTErwrzZp5HplEASr3wdyIhou82HR6V3b20oG5cB40DM2Oy0Alm4dUxq7/lhf1PsSLHf+tsZ2/tiiROOeAfrhAeEXhFMrPkKO66U1d89UP2cNQVVjfvfsnodGbsgdUCNuBer4D0yW8Ue6z8z4vy9OXLq1RPUqm1Mihg6HWupxs0XxTk65YcCmY9EsVk4ieMwhYgCbbPfR6wI6o2Roar2fvwVSisIx26xvwJm60qOqczAvT24LYyRs5Z73/Wb4Bn1eQkDxx+UWo8OPJjAI4/gvQJ2T5OOvSxY1oLhGXY/bKnnXVAhLJSaJs5sISUGNp5eP2x+4MeNHO4Ajcx3TsGzJJWDk74MTwJT4L457Fd0inx1A+k6ttBE29hNtbTnqRfg9cC/WCxVUmHYEKZxew8PEy2FfK4RnP7EUF+O4CM8nl0v4yaqyzmTjqucSwJHVSmK9Z33oVWaAfvg9SWbifA/m2iGOf5AAI9kUX6UlJtcZXUcxdZQuYnFCXHQicS/LS10BIVtkuBaD6Db80tE1g9AVMAfHxlyX4T0QEFA8G1QiHaPZnMiW7XYmVJRtqWCK9nTeePrgM3/y7Vg4kVHD3yvm7YSFR5is6mxm2GihBGMkIy3t2Xn3L3iWCu8U8t4y3EbPunPHCHsQO+VBcuhSjSjdZpdpnr4n3mjJFbPfZ2CZMtLGWmtuguibuFIbFYFtRxq1GDpvq4wjq2pWbp0Bc+NoIVUl4ZvIPAl3Gr/SvR/23eSJ2EIK/clICTdCg8Zos1w3/V4yWJoQJ1m5fMWZUhNor8PNC8ewXtybAN35X2wSbJAobXyovbsy0xKzrUqsifxA0zDD3qIDSybd
 FYaPCOw5
 D8pKRKKijHn+UUWaWh8oc3+uv69i+qaDxgmkvlWt9lGEsR0Bc4T+tY/QEmPVod1/Set1CSYNcMrL04lBmTiPFM2WdRlLBwLt8P5Sjax8kpuk/vNC2PaMJPmnRA+fQ4VFFDyZA7zJCvQoIGkn/MlghNF7dbI9vnENwvfoMNvYivoMPTM01stKZIWzArxJJ3l5ue0Yh8jhXFVdRJSfVtHMC5Q/3AltNKHCVY5nRCAEr8uF7RY7GA9vtPSiwH/LH+xbXLRUG7id6CPK/Htw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

scm_update_information() allocates the response buffer for the CHSC
Store SCM Information command.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_page() with kmalloc() and free_page() with
kfree().

While on it, use __free(kfree) for the local response buffer.

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/cio/scm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/s390/cio/scm.c b/drivers/s390/cio/scm.c
index 171212a6d2d9c..b79fe023ab8d1 100644
--- a/drivers/s390/cio/scm.c
+++ b/drivers/s390/cio/scm.c
@@ -13,6 +13,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/err.h>
+#include <linux/cleanup.h>
 #include <asm/eadm.h>
 #include "chsc.h"
 
@@ -224,12 +225,12 @@ static int scm_add(struct chsc_scm_info *scm_info, size_t num)
 
 int scm_update_information(void)
 {
-	struct chsc_scm_info *scm_info;
+	struct chsc_scm_info *scm_info __free(kfree) = NULL;
 	u64 token = 0;
 	size_t num;
 	int ret;
 
-	scm_info = (void *)__get_free_page(GFP_KERNEL | GFP_DMA);
+	scm_info = kmalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!scm_info)
 		return -ENOMEM;
 
@@ -250,8 +251,6 @@ int scm_update_information(void)
 		token = scm_info->restok;
 	} while (token);
 
-	free_page((unsigned long)scm_info);
-
 	return ret;
 }
 

-- 
2.53.0


