Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7BA5C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:01:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B3C6B00B0; Thu, 10 Sep 2026 07:00:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFC446B00B1; Thu, 10 Sep 2026 07:00:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3A626B00B2; Thu, 10 Sep 2026 07:00:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B629A6B00B0
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:55 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4B94B404A1
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:55 +0000 (UTC)
X-FDA: 85197560070.02.B3D9ED9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8FECF20011
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRH9KEeX;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZWoW41+x+7dy6umxK1i5p5XUicgKN/VyGWTHRTGB5Jk=;
	b=BQm345/L+MEWH/ofAgqXrnd6DQ0hvHwg2L85zCKNnGxRjf6H2BkGlkWHvwzaDLheylOiDT
	oMHuof/n70RrsoTdRg9qJ9GWPMrbrV7Ir6ko6ZndwwW/Vq/GQJBmJfm+cRqcxw/sT+txWK
	qBLNScIfNCIXyh2uUyfgqc+SVDFe4NA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HRH9KEeX;
	spf=pass (imf13.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038053;
	b=3EurVDf80kmSsJZSK1Z68AujBCZA/AiBy8O7W1Z5PFFGCqwGigrkEXttxChxkG7z8f6OsF
	s2Igy+1TNXCDzDUtfUz7+1ODDICxQXkbdBIJ8J3pWDv7hQlLnuujo/zB5wBh2XJ8R1ID2n
	NycXwYnrpRvjCKiwBQPxJtx0O5uI430=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C43B04050C;
	Thu, 10 Sep 2026 11:00:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2B7D1F00893;
	Thu, 10 Sep 2026 11:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038052;
	bh=ZWoW41+x+7dy6umxK1i5p5XUicgKN/VyGWTHRTGB5Jk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HRH9KEeXmVngHNuUOWNn8xRQ7/eO7kzWYtRlf+g6+nsRcMThfVn9XAQD7WHChf76P
	 FSxx9uAhqbsd7WTBRzgkgGXMKpvQm3hhb+2UXwcaflcaa+Xq/aBK0WH2zmQmQRbl6B
	 9jBegERP4F5Lw7JkfAPVn/8+S9jcWcFxYPObvewN0Cjon4pVFmcLF6YiI5VJmBZqaG
	 NVyDFo/84Wz0EMbhl4ZudmUN0ZfhyXRjSERYm7cbU8UNzjHcE8dy0cLzEeXNTdZ+TD
	 0jU+f+UoD7kVR31vSAjE6ZloSuZhJHbQvO7kTLWD6A4ujSu36NzkNGkBu5gxrpj9Pk
	 1GxVloef6tfOA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:15 +0300
Subject: [PATCH v2 13/13] s390/scm: Use kmalloc() for SCM information
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-13-e931086fdde1@kernel.org>
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
X-Stat-Signature: 51x85doa51opfgyoihfzwrh7gcbrifn6
X-Rspamd-Queue-Id: 8FECF20011
X-Rspamd-Server: rspam07
X-HE-Tag: 1789038053-272448
X-HE-Meta: U2FsdGVkX18chLCh+ROjeZ8yzksCCYLMUvI+VFWHHxX1HdpvqMuADH43vHxDd0psUVMga/FixLO7T+O/mgOZ8CpLKuGr5+YldYMhf3VIOzBL/Kjw22Nz24uVvWuIOxN+nriuqCYkOsCTvA86xjjwonvurHoijutxLniYrhkLs/z5tqUWPbQ4a1gKodAERQ8uH9oxX/Ln/VG94NXu6YiVlE69vhkV5AM5OS0cJWTZJaLigT9OZ+eTLtSsKC8mhZmT2Lb4uGmb5dDWoR21W0n3Synq0TgflflSDMfE0MgVCAYY9Vn/EKGtpVTPgfSRFsyr4N/7RApJfI0aHdYyXjBLo/GPp9ZETmPGbRBCOEv5NXvzwNwV51fhsrNhOVdZdjadlceamnfuqQ3fP3lDKShx3hKB4PaIx2X6rdGJaa3DgjFzcn7Jej1jPVzIPF1L/5oCUJmOddaZr0uqkEs5H8Hk1MQWmYLS6tmwE51Grb4grNhYsEZTh/01tuC4j0XwDs0YYS1McI0JP+LeeICm+V1hz7P6Aa3nqbuncErbvfxiszrBPge9LBf/6wP217HFnNfvbJN3OJZlQFXxDSnYQoSCjLM4RxQ9Zmh3L6AEYBvbgjGsAYpl6smbPoCfoaTLATdTeL+S4fGcYS25kMRQK90C7AwITMwiJmx0WhANEHuF9I7DUTCl3kGEYbL+SCd5jGUT/LsRpLL6/7IeNCraEyxvk/hJeRW3gdLq+ZY/36ZAPbXxzS/yQXkWzvPLnODH2/tcMezBj+ZZ1Q24yU1zsxQi+YyGSqXPLPOH7Fa/HvuXEQaSl+d+5BoOcmuXvVm2GgRSFPlJkKhBTcU2yGjYuGx8omIx/Z1PqcYgNfPqWnughHRky8l+/vpJ3xKI67KJSmCNpCTpsMkKzFFPUNnxqzKdiPMG+3fNRnLXLKj8achdpfz8XvS+9OAW6wcFdfOj7WDt/e2AU7pQRCYip/OtOrd
 qAudeIZI
 2SdQ2i1eveFXFYWai1PvSHP/c1TbyrVcPTsXP1RA7l3/p9imqy4RhlONln2h2loOMqxwUh2uoSD9zbbdWCBENFGMqWpS+8n1jbEdNM/GdeYXaKWVeLWR+fcfN74jimFxO2XG66zQiNaAbAC1ew0HJM50rX6oZ74T/Qux6sfONEWrZ0L5wE5oFPPuFHZE3Fy9AhA7qM8J5qciBKGlcQuUZjgyc2Wu0F/s/nXQZmm3Q00f2czsBUgtt37hDy3mW0Jt6VOTrSVAGQThB8d4=
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


