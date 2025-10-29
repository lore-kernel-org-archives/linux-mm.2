Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979DACCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 08:57:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FE9C8E0044; Wed, 29 Oct 2025 04:57:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59C988E0041; Wed, 29 Oct 2025 04:57:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3D28E0044; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC5DB8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 04:57:07 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8F20B1A07D3
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:07 +0000 (UTC)
X-FDA: 84050547294.05.38FF6C4
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6ACD31A0009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 08:57:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761728226; a=rsa-sha256;
	cv=none;
	b=M1CALwWjC3iLPB10QHDT0VAlUGONUBGR46nz33wD0fnpf9GQTtwC58xqvxcrkVS3qzmvlx
	DBS4BduvMcEuR3G/lhF70Nqt5ABR6MAYfMQEpVixsV5BMcIjNKJS2bUhg3spzshYwrimnJ
	Umv8ke6biUEqSTXyrcJ0L7bmXO/F7fw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761728226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4pjQPDH4jbcgm0rw+QL3o3k7Z730nYipqI1enGvZHlo=;
	b=ERjAHMRd/g5YBSlnHycnXFRquwUX1uhCvgYGI0/Jexl1E7FprKMry0ctJcN3rTuQsau10S
	G/J2u7XGh+mkmok+gAXcH1bYn8KtT7sVTz9GwS9cJ8FlrvVuuak3IAeZpD2xklWCaLVJXk
	D97qea+Z9ZkucANjP5u9CBKD9jv9ZmY=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 29 Oct 2025 17:57:03 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	shikemeng@huaweicloud.com,
	kasong@tencent.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	gunho.lee@lge.com
Subject: [PATCH 4/5] mm: swap: change swap_alloc_slow() to void
Date: Wed, 29 Oct 2025 17:56:58 +0900
Message-Id: <20251029085659.2005942-5-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251029085659.2005942-1-youngjun.park@lge.com>
References: <20251029085659.2005942-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: kho46wpzscrqkpcwcudf7qfqas1ye3dg
X-Rspamd-Queue-Id: 6ACD31A0009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761728225-421364
X-HE-Meta: U2FsdGVkX19kcuEeLy8KLgciysdL1dm1UB8sx3GD0cHTGKIovISPl9HgwnlwVaVivBh6tbrdSpeMSCC2f93+Jn9hr0C33dU/D6DvKpjYdf2VCqj1a+fM802lP4cnYz9GrHjrMi6quFhLBF4poeAO7Ooad9wDz8Zjq92kfv70MBawYXVJjA431qYG8b01Yp5DValpqF/uKqme6btmQCPUjypfifCpNeC+LLGsGnMnC1PXGaHRqdtfSM6UwGngVVsYRr/41LFrVqJwFk2vcsmxt2X9GTab4LyQ1t8T2BynYeYDoljggYo7ZyCOfx5hNkm2I4T/hZRL1GcJZDANG2Tf2o8CW/ujJOwjl4FTNBtZU5o29HTUrPgZDiG5utBWspYh+XfS/F2eEFz4UW71bbyymD8+Tio5y9FukB4o1If0Cg3/pyWCe9HlN/uIFHD7fNNJNBZsaPsTGavqtIT7788caWGiC5XLhL0L0/Dmf/+AMQCZBKh7W053/IgZLn/XITp/GQiCnnK2UOd0f4rlTCeG9atI6xXjzVyOCnWIwEc8yrVNrCMwGQ9AX7snuf2hnMQ0BvfGJ1hC3BJwLg+XqHHq5LGZ7UrmU7MqbP5m2aZzbZpzuQ4aW7Op6vsD7pFPsvoljPcIEY7bFvNuZ3m6KbPZHbUEcXTuEOqkq1903ur5I0DbRfL5RSmvEOF3cN37FilBmTRpbZ8J2DDy2uWDe9n4Apzx/FW3saqcvIgQb9LmoBg1vS+iqazXlBEIh7f8y3fXvaKQcMnSytWRXQL1y5MLYaAvRxj8uB3IaQ4DO/CTEacOQGPqMLk4z5+4cv81s3VTlwN+DMcGu1FOZ73jYzcmo9tVGqrT1XRiTmgbBpHKsST26YtS35JZhGGISb0Ajv1nrclLsGgGr+FoPAocce3ALt7cj5EeWGj1HILy0Po7dKW2J3cKTtQlmS5rOMRdSpo9Hq+tx4/pZ9im3jXbtjx
 SGu8Ux6x
 OJBMGCSx+8JKDTjDB/l2GVRqxHnHIz2N4z21XOAM9bCOYyBiE3xa/+QagNve0fA43bofspoYtyDtaPDNSG/9T0RYsEU4TMq0FVb7AzVOhumVgqX3m3i3+8Wkaw3/GoZfcvf3d3p4pn1W7pjJpbRBrvDnibNz1GpZCk57kH95xtJzk3mY2RBkvJQM+ZbqEa7ePHU9QNBtlefpU4wE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

swap_alloc_slow() does not need to return a bool, as all callers
handle allocation results via the entry parameter. Update the
function signature and remove return statements accordingly.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>
---
 mm/swapfile.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index b5d42918c01b..89eb57eee7f7 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1339,7 +1339,7 @@ static bool swap_alloc_fast(swp_entry_t *entry,
 }
 
 /* Rotate the device and switch to a new cluster */
-static bool swap_alloc_slow(swp_entry_t *entry,
+static void swap_alloc_slow(swp_entry_t *entry,
 			    int order)
 {
 	unsigned long offset;
@@ -1356,10 +1356,10 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 			put_swap_device(si);
 			if (offset) {
 				*entry = swp_entry(si->type, offset);
-				return true;
+				return;
 			}
 			if (order)
-				return false;
+				return;
 		}
 
 		spin_lock(&swap_avail_lock);
@@ -1378,7 +1378,6 @@ static bool swap_alloc_slow(swp_entry_t *entry,
 			goto start_over;
 	}
 	spin_unlock(&swap_avail_lock);
-	return false;
 }
 
 /*
-- 
2.34.1


