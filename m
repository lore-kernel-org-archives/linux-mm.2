Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0AF7FC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15C16B00B2; Mon,  7 Sep 2026 06:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78C26B00B3; Mon,  7 Sep 2026 06:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9409D6B00B4; Mon,  7 Sep 2026 06:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6D2686B00B2
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:38 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E48DEA06E5
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:37 +0000 (UTC)
X-FDA: 85186582194.06.C720D33
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D7AC1C0002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:36 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KS75OFvs;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776676;
	b=M9Mq/d1HrOPS8d04eJjxIwowlIYyDyMpCpp0RU34oK2u8gfq4oY+k9tQaIp1aNo8f+lk9s
	h6SkpvIaW3o2rgLSN4U0/7p20XiAKFhQGkMgMd1h7GrukDWYC9TwpYoG36ZC4po1hpi8hr
	w6Z+SMQsat0HOzouiWfB+vMuUhuXzIY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KS75OFvs;
	spf=pass (imf20.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWoW41+x+7dy6umxK1i5p5XUicgKN/VyGWTHRTGB5Jk=;
	b=L/VWG2HGQATO53NM52XVn+SnvEStsWTum6vVOX7ieY00eBePTNQH14tWQG4iehJiBfVSmP
	VW5Je6sYodrztAor/GDA/tTIMT+ghg7mzHwjtDHVuT+TqFpb78jWGwJrcsxWBGOjWh5u25
	k+Zj5hp2iN1ZqN+vT0uToECFTPb+tBM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D92F860D86;
	Mon,  7 Sep 2026 10:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C692D1F00A3D;
	Mon,  7 Sep 2026 10:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776675;
	bh=ZWoW41+x+7dy6umxK1i5p5XUicgKN/VyGWTHRTGB5Jk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=KS75OFvsRCVf4saYIwM7a7NN1+hfRl9Js1UXnBdo4ejdc/JRfRr+x+8b7ByXevYcO
	 rfWjqSA17UYgRcYKmT5++U7d420TnkfJlN6/yaQ6IiwBHHni3dULFPaSNEFlHOHw2c
	 75cU9o/cuKArq7AlxXxBp5t1+KSdEJZobfXlSXI2uXLoU0e9yPaKq/Sue4Hk34mHCU
	 GofAygwswbGe7s9LY4eI5lfqP+V3h1dDpHLxgGGX/umcnKChtdrJCfoURD02QOU0Ak
	 g8d9a8fEYO5ZLLJ0aRKUoWXKJXV3FNe6Jw4y//ye/5HU1yV6B4ky0fGRSPsq4P5B2g
	 ddGOIKLVTV9eg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:54 +0300
Subject: [PATCH 13/13] s390/scm: Use kmalloc() for SCM information
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-13-ca7f39806234@kernel.org>
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
X-Stat-Signature: zeiqi9m3fpkr6ieujr1zsosotj3cw8ns
X-Rspamd-Queue-Id: 4D7AC1C0002
X-Rspamd-Server: rspam06
X-HE-Tag: 1788776676-136161
X-HE-Meta: U2FsdGVkX19f/jGbmEehQ/BBlwVMA6O6jIzjBgNv62+2F8+Xqrm0fXCJwCf+Ei/581VWVoeZ5NCpV5FhnQm3XuCe7GzBEXEFfcEaMg9hEhuuZ+GDDI5B0JuRyDK7smtOTRZL1Tz5mm8Jn+sNeUs1O7YZ5yjCCUPNQ8zjMJnhnEe9z4XGQylZYGis1WCt/baVNm+uS1xag+8eiA4j4fBdOyju+1TehoOVAGF/BNytvQ6qV+IAA2iVjq7B5Q3xgJJBQKAQVAV8TCB+cDH7OZ6Oe4fJFmHbRTbMu2utKJA+J4lrrgJ8OJ862c54sZRH0l101K7k1EEsZAiCD2OHGLI3FSESuU1O9NEvYSA/qJU7D5MkUHKpoXxLWMPh1RcIOzx5nMqEM355Q1yPz7T7ft1unm9n6z80XYmZgnEaO5AQbDl7eAyYJ0UfrkJm4Cxzopz8q4Npb0jArnHjkSF3Y3tOpyLEc735aAaItr4ENm+ZGAGzZzhas8i3QZM8D9PTQZJ5fuAkg3OvQBLLOoDXnvC5hfx0/mbzDXIpsdjuqMaBAYd+W/ocd3vJBQs5fFAQdGL+HN+5d0eTxyH4fEDvI0TowdIf2iqmQY39wbW9qjLugn1HWgVPBmoOrkxAwL+r+u7hd7locgNoGmOjMdiNbVl6WZsnkbeH0clW64CdRTuYZyobaUoWUN3M5mFGIFarYRkxVw9cFycHv3gtmSDhMd0nP2ftrIOqDRa+oZ1FivwALZDph6EUyPx282B3BG6BPJ04b3qFDQeIfGaY4r1OCX/stZ7H8twoJezIrlDc8Gaiv8ZDFFzWEpOupbEpNVkDNgfbLCOTZpwU4lg4ixadkk3RwI2aToDJOxdm8f3FlzlFTC76MDjEASmJ4pryJlkIc0R1XOEo7TTdfu8lmE3JTUeZBFWLll6USAW0iBImWO52jQU6bgVeiQWys6+UnNHqyzd+lvfQ967aYOT4l4rr65l
 HQZdIAFh
 0CM3edlJZ6iPvtDjgOb0dSka9tPEUXIN6+y4ek5+fJq9VD6UpeaveRn3uVBc2XHKrvIo/2hWV0CodLIkPV+BejWhLyMfNHC2tMnasGnFPV43cHlLnpmJ6ex8N30yiXC2bd9laRjmy5eu7op2an5NsYQsCm6tBtB3Am4jJzCRpz7cDOyHNSEaFqC7sf8Yb+sPnbbxKQBDG4LO3ho48domM8cg1R7JuUc2vyVYY25sKZ6SQCJJdytxuj8XLdzvzEe5aznnoLANjogm1mAQ=
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


