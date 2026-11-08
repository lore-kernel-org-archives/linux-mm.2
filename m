Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 524DF606D80E
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 09:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NIa8xQyk
Received: by kanga.kvack.org (Postfix)
	id 7F9956B05BB; Sun,  8 Nov 2026 04:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A91D6B05BC; Sun,  8 Nov 2026 04:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623BF6B05BD; Sun,  8 Nov 2026 04:04:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3CEAD6B05BB
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 04:04:38 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A59961A0455
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:37 +0000 (UTC)
X-FDA: 85411366194.11.F1214F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0E3A2A0005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 09:04:35 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIa8xQyk;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794128676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XT0YKqJ1crGE3lP+8+7n5IpoTabmCNV1Y/YcA5CixeE=;
	b=z/T5PtcQu5pa1EVhhnweRN4umO2DVZuWpoP56bgjPUBVFvUFB+hDtUpKitnO2uDwQ79d7X
	9NxC2ZpfcsxbaJjI/SD7VMX7QvdxC8elILM7Q+Cz8CKrJb4AvMddiVO8GmC+DsGKbLQc0J
	j9ZB7Rjd8e1M1AyYJulhYqblxJwqGQ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794128676;
	b=3WNnMBc19xL2Da06HmeucY02Q+2XHUw9JVdyj8lAb7CxEQndwwi8FtGHLLL7QdWSVlQHIi
	SFNvmLhmcD/pqFl8LlXAvRuWrShd3QDjPyMjf6plaYxtLLqYr49Ea6XnUNyTKC7d/VbgaA
	GkzEp9TzMZZSu3Rbh+1guIiqugA/TIg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NIa8xQyk;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51F9A6149B;
	Sun,  8 Nov 2026 09:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D131F0089F;
	Sun,  8 Nov 2026 09:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794128675;
	bh=XT0YKqJ1crGE3lP+8+7n5IpoTabmCNV1Y/YcA5CixeE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=NIa8xQyk8Tta+F8UoRfJBdNGf18oKMN8u1pHXsBwio3XFvkTe4yxf+rc/73jYmqwJ
	 oT0ePE/05lFOIGRnegXEGJdccMrAd1pLp6Av9QUkf077ZukvsA3Jw+dWVHN8r6+Q6I
	 Jii4oW3RQDMBBsLz96rnDdlyMhYI0gTY+swb/zQ6tHSBKgAChUMgv/4XFMZgczLvaA
	 MfyNdZVEhMtoE8OLAwTuRLPOp4YF1T1qxQuRMOsbtxEmiJFtv7VpvKHSRtAUl3mxkI
	 2ok9h1TUvwDbgUBr2nTiq1NZ4MaX3oFlzDACZiDN1qFSDYtQM1MFH0ct8w/1djl1XO
	 5mESE4n/LoPwg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 08 Nov 2026 10:58:35 +0200
Subject: [PATCH 04/14] s390/sclp_ctl: Replace get_zeroed_page() with
 kzalloc()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261108-s390-sclp-ready-v1-4-3e7c90eb6676@kernel.org>
References: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
In-Reply-To: <20261108-s390-sclp-ready-v1-0-3e7c90eb6676@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Sven Schnelle <svens@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: gd4t7zz1da3whcdq8y65f71zbm7hekis
X-Rspamd-Queue-Id: 0E3A2A0005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794128675-813397
X-HE-Meta: U2FsdGVkX1/I+EfiURA4eb9kCu+6+w8iSVEWfeJaeGAl5fW+GYOMiISHwr3PhwJmCiBDbz1+nbQZT3R2jTPiEcXQCFBfKKKh/WDxofTxofE7tNeusz9aDpNKI/Q2EboYsg0uCMagguOAlCeYBUHnKr3dkeVfK5gofY4D6x0f0GNCFm0ufPnSY4RHoXHaTBb6UrgI9SKYC4ZjxbZaZFlOekiGZ/xsIOr2hqZlKc4SqgWcHjfJtVu/lcrH6pPFRJoYoOdkc2qkxWDLLp0MZxtq4zsv75Y5NpcDDxTXCkB0UC5MM3PNqieStuJEKkzph6h3EcTBk+UlLsz2INDoVprPAn9ADg2PTAgAILKKK3JwcZFNN1ZP2TXU5dISupXJRRGttaQ+z4QXEBlGs97V7YQgsU3XJnG6hIVytt9A+OjK3+Ch29kjhcUIAhpM3+HpTiumkTd7DCvRKiTO3boFWyo89pngJ9tIOWuobnqvA2ZhM/1OHWO95kKhgd7sjvT70Ljm9iln9BUy7azw87PQ8+9ajoYDntazPubxtOl2tYcfMktaxQDAv/+t9M2YK2cyRo2uOoR8A3aWzVhtMJKNiozx0puj+ZwbkxDp+1OuJsGlzuLICkKBMkeCqpZoi+DUU+Gezkf0oKPvDHAABcqQZuPdJGwnihoH3bgsgBc1iDRdUSDmHUBnV1c/msxlQgpMHMjE7vEVIVsgg4Hjkmwu3Fneqd93Mp705OL2beD6VhjGQ1T/MapqohUCPJBSJqXY8tz4PSPm3mTcvH2THYRUxQcFFAn734UyCnqubN8oYuwDgiLcCbUzKG2FCKOj/w48WoBEWYmj04RRYIivusorllfNQnWhj2RDl28nZclsNT1jNHgH4qJAc0LIcHGHAR4mN6Ove8Ds+C0UwNxD2omyaTxWM3mUsZ9Y6rMUQCfEuXloOe6gIyjt5WMNXp0FmhLl/l5k0Yc23LEeiyJnpal811Q
 GRqh2JDJ
 UjH1l8bCl8Bmz5+6TGYP8xUiDggJcH3jS4R+VHNTyYTsXKTCHsRSvMDNZnfmzLbljyNAPE9+c0eOMJgZTRY0OVpiLceWtGpYhWafNAQP3iD9SX8reRKW19E9TLumtrJl3my3kKFG2jKLSL1flkY0j/8B6mQLoz19SsC5wJDCJWylneCOUZEmhpvf2qHfgsBuaAkWoBACkEu8/2CSNAJ2ot7e0dOUjWvvg7d7N6KuuzCTEMzj4qQU5SpgCPKHHXWgn6hKgtUlyb7coTb37jy2kDNyAZblqnUDZmOOZS+1PPy4WBhoN8drMsHhbhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

sclp_ctl_ioctl_sccb() allocates the SCCB that carries a user supplied
SCLP command.

This buffer can be allocated with kmalloc() as there's nothing special
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
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/s390/char/sclp_ctl.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/sclp_ctl.c b/drivers/s390/char/sclp_ctl.c
index e23a97359286b..84aefff3be98f 100644
--- a/drivers/s390/char/sclp_ctl.c
+++ b/drivers/s390/char/sclp_ctl.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/uaccess.h>
+#include <linux/slab.h>
 #include <linux/miscdevice.h>
 #include <linux/gfp.h>
 #include <linux/init.h>
@@ -59,7 +60,7 @@ static int sclp_ctl_ioctl_sccb(void __user *user_area)
 		return -EFAULT;
 	if (!sclp_ctl_cmdw_supported(ctl_sccb.cmdw))
 		return -EOPNOTSUPP;
-	sccb = (void *) get_zeroed_page(GFP_KERNEL | GFP_DMA);
+	sccb = kzalloc(PAGE_SIZE, GFP_KERNEL | GFP_DMA);
 	if (!sccb)
 		return -ENOMEM;
 	copied = PAGE_SIZE -
@@ -79,7 +80,7 @@ static int sclp_ctl_ioctl_sccb(void __user *user_area)
 	if (copy_to_user(u64_to_uptr(ctl_sccb.sccb), sccb, sccb->length))
 		rc = -EFAULT;
 out_free:
-	free_page((unsigned long) sccb);
+	kfree(sccb);
 	return rc;
 }
 

-- 
2.53.0


