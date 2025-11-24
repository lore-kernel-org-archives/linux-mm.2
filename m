Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14D4DCFD31C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 06:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AFC06B0010; Mon, 24 Nov 2025 01:20:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5870B6B0011; Mon, 24 Nov 2025 01:20:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4086B0027; Mon, 24 Nov 2025 01:20:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 33C136B0010
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 01:20:34 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D2BA11A0234
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:20:33 +0000 (UTC)
X-FDA: 84144501546.20.0702343
Received: from out28-122.mail.aliyun.com (out28-122.mail.aliyun.com [115.124.28.122])
	by imf29.hostedemail.com (Postfix) with ESMTP id 946A6120003
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 06:20:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=eDVBv1SB;
	spf=pass (imf29.hostedemail.com: domain of junchuan.tzh@antgroup.com designates 115.124.28.122 as permitted sender) smtp.mailfrom=junchuan.tzh@antgroup.com;
	dmarc=pass (policy=quarantine) header.from=antgroup.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763965232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=21RHootz6QRBrJkseztSpqOrZvyghcAQRZ1d5BBCZLs=;
	b=f2b82dwWPcUOPBoqLGYuV8Z87yC2l2uEk1eXs7oiHpClrCjNTHgPC5t3d5249IIG+U/oEQ
	qGzFsFBpCH1MT20whSU3oQFacnuUpPqVI/1kqREwaJbI+++LL+e94h41xAdOzdUENy3kPF
	lHk23sPmKdM7lSh2lRec3VEcE+ye7As=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=antgroup.com header.s=default header.b=eDVBv1SB;
	spf=pass (imf29.hostedemail.com: domain of junchuan.tzh@antgroup.com designates 115.124.28.122 as permitted sender) smtp.mailfrom=junchuan.tzh@antgroup.com;
	dmarc=pass (policy=quarantine) header.from=antgroup.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763965232; a=rsa-sha256;
	cv=none;
	b=WG6wKalT5XpcdDgBIqNd9M5Jb/XU/c06wCS0MZIynViIMrdMVtdB5PvZhtswCQOub9n/0P
	FP2AkHAYDojOCM7PJdW9GOEeg+mV5wDrAsbrnWg0HpDeSyApy9zcw1EOxh7Orxn2DTuc6v
	KMHPDT9KV/5SnUd4g4KIA7BJLFaYeYA=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=antgroup.com; s=default;
	t=1763965223; h=From:To:Subject:Date:Message-Id;
	bh=21RHootz6QRBrJkseztSpqOrZvyghcAQRZ1d5BBCZLs=;
	b=eDVBv1SBGkscMJpTFEH9sUgW5BF4XrtbGnwCoCj0nUhZyThRol6JUAP45n3ZiWyHfJE1Ktt0vr4i6Tm4wJGnv/xmv3po+idNewihqO5Tz1WYV50ABIBhj+Y0PwY1AtAD6VQZ3qodHm/gGYhComyJIRPHuumoiHzVziWCkokXUTI=
Received: from i85a15111.eu95sqa.tbsite.net(mailfrom:junchuan.tzh@antgroup.com fp:SMTPD_---.fUM99rp_1763965205 cluster:ay29)
          by smtp.aliyun-inc.com;
          Mon, 24 Nov 2025 14:20:21 +0800
From: Zhiheng Tao <junchuan.tzh@antgroup.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	shy828301@gmail.com,
	zokeefe@google.com,
	peterx@redhat.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhiheng Tao <junchuan.tzh@antgroup.com>
Subject: [PATCH] mm/khugepaged: Fix skipping of alloc sleep after second failure
Date: Mon, 24 Nov 2025 14:19:17 +0800
Message-Id: <1763965157-58413-1-git-send-email-junchuan.tzh@antgroup.com>
X-Mailer: git-send-email 1.8.3.1
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 946A6120003
X-Stat-Signature: b8siode5rrsgreu9oyhutyjp1a4zn59j
X-Rspam-User: 
X-HE-Tag: 1763965228-202779
X-HE-Meta: U2FsdGVkX1/YCYPn3+TsFqko8PT1I0gWTU4TdeDlq8Pg4mj07gtGWTNKuulbteHOjRkePhrbEML6tytaFyFr0f8k75/Rc4FgulnC3SsTE7q2PD93LCvZ4Attkb4zxLFMgWt/Ao8Ym0aljP1SOXzAGlj5PHrXVriT3L2mnNEyvGUTUJCVfsAFErfp229y4Tply18UO0LAxzy7ddZLUg1rEvDeWw0zBmGF2Px4HIApvu9n/zAQm+25D2Z1cm6DL2wdZI6W1m6a48CXkmQGoXuwZzL7heMgDcnT/v1Y5M/mymKxL/9UqId9cDLbhgN+b89BaEwRJ2xRXnv3rwQAgyALJmtILpVFf2fKYDB4uFkQFtepQVA8Q4Z2JpdK4KWwOgz3x/Qj+75yAJt5oQMHAgqhIyi+R02tuHJMXN83fI9agdBbpVbvVSQpkuOQLkh2aKO7XU7qdvdbIt1IqvO0qgm/JOvXhZPyvewa3tozEKnxmGPbAv7t6JKtl2TKlV+RbE015FV7n7HatobNTb7QlPjDsn1MkaylmWWl00IfK+nKN+dUBBDS7qXtJ1IIiMScd96kVws4aP+9hhCUdaKCCdz9NMp8Yn/zvpUEuV0x7BbYC+zUZ23WxxhA12Yj7dzMRH98yVTGl1Hbnp991WQ3CgJJ5zZ2qkJm7bbP1vwRQDjCRC6cQHVTuAnulsOjrjZeeg5TyFOS1kzVj18B7LMqTz5WL3oNLrp/hfDD6LmhFKum8cvOhOxT1FMjr6+gT9ub+odumRsAurlvCeUqOX5zHcYP29nTiciMeeuk8lh2em0xJDvr7jdwPucZ90mUEvwKp1Lvw5NCruCBS8YDosDEDX+h1pjtQiDxusXed6qMPZulOwVwseoaDweo7fWZc7h8WZ0dwdqVibtciKXdHLcuL7onojKvjRECcD1bSAB+STx9/9djJYi44BwGBQ/kPPHhYldozuP5lNiBRa0JuBwL1pI
 3xg5o7+3
 3NTo0qRhm2PUsan3YQotz65iFDMYj5KKYrW6SGRbFGKLcGgLcwiCPgrREKkglCjs4n1l1AmY5IZd+/ft+F5NF0J89z9m2D5+wTNvk/Z6eswfDlmpJ+FnPuG2RXQgWcko2bjxsiB9++KlnosAsSn4xRaDj30VKNo1NSThbe3kBxoix8Mpv61KoCKVLkAFKDS2/R/kykjf5MHe0vtMDgzGalVfSFB/6U+nxqht15e6SuWtvTHboXxQNPm+9kdLEjjwl2ELM+t/CA2T7X8ZwNsDuUpQLJilfjONrHn4GbB+gNvzG9gaQadwo/k3Wqg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In khugepaged_do_scan(), two consecutive allocation failures cause
the logic to skip the dedicated 60s throttling sleep
(khugepaged_alloc_sleep_millisecs), forcing a fallback to the
shorter 10s scanning interval via the outer loop

Since fragmentation is unlikely to resolve in 10s, this results in
wasted CPU cycles on immediate retries.

Reorder the failure logic to ensure khugepaged_alloc_sleep() is
always called on each allocation failure.

Fixes: c6a7f445a272 ("mm: khugepaged: don't carry huge page to the next loop for !CONFIG_NUMA")
Signed-off-by: Zhiheng Tao <junchuan.tzh@antgroup.com>
---
 mm/khugepaged.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0..c3f9721 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2562,12 +2562,12 @@ static void khugepaged_do_scan(struct collapse_control *cc)
 		if (result == SCAN_ALLOC_HUGE_PAGE_FAIL) {
 			/*
 			 * If fail to allocate the first time, try to sleep for
-			 * a while.  When hit again, cancel the scan.
+			 * a while.  When hit again, sleep and cancel the scan.
 			 */
+			khugepaged_alloc_sleep();
 			if (!wait)
 				break;
 			wait = false;
-			khugepaged_alloc_sleep();
 		}
 	}
 }
-- 
1.8.3.1


