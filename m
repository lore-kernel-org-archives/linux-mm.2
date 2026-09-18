Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84892C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 348F16B0092; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FB976B009F; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EA4D6B0092; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDBD96B0093
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:58:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 462EBA5E25
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:59 +0000 (UTC)
X-FDA: 85225527198.11.FD506E8
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id C4411C0005
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TG4D4lbq;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8mmUDsC9rv2Qg56cTGaMzYYkxCmY4QHyGj8J02CULg0=;
	b=EgpiGZep/INaBaUdd+cUzRrDmKrc5ER+NAE0xemiUD8krmCJOywGKeIPWYVAfo118yOby5
	zxnhrLfwxIOoLscqgy5QOrIcP43jvxIVH3eyFEeuf6vy+8RgbwdAXy03Bq0FlEpSdMdJJa
	v+gS2SJuY38rGhI+3gbaVyNY7M4GcQU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TG4D4lbq;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703937;
	b=bzNCJyg2Ogg0dKVlp14cEu5QQ2hYMYmJh0+PSWDDJPm0nwGBnJBVN0s5twbLCPsfji/Xom
	fvnujpi0ajlpAqBwxsnCBQ4mzawjW+KsKaFdvFOg0rSLcpCRvvqQwFtCyUeGHEw0IFMy34
	COzat6dN78lBM8pxJj5MufmRh1FKcJM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703934; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=8mmUDsC9rv2Qg56cTGaMzYYkxCmY4QHyGj8J02CULg0=;
	b=TG4D4lbqOWZ4jnC7P5U/02gc4wY8srbpS1MLMDVaQ4o7bLLdOM+7gpa/wvdPF/NZywKIb8cevkWQ/d0le1gIRc2MrtAuptqaL2jCrEcjXAJIpv5fAX2kjCOI2ea8hsvkbuzvMAL3CFqiwmeS1dersQ9Wzp/QoHtexFkznAMBLUo=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9o3bp_1789703932;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9o3bp_1789703932 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:53 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@kernel.org
Cc: ziy@nvidia.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/12] mm: khugepaged: add an order check for PMD-sized THP statistics
Date: Fri, 18 Sep 2026 11:58:38 +0800
Message-ID: <880d5e981b8af49f956cea49074ef6dc553a575a.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C4411C0005
X-Stat-Signature: fc9zfmkc86zwgptag33rdxsns5gzgq35
X-Rspam-User: 
X-HE-Tag: 1789703936-892655
X-HE-Meta: U2FsdGVkX19O7vLQG1EyJJRZl2R2v+de/FQj6S6T/bQfN9fgo/GuZvYTIIydQHWeQETuk8Dxj4dTBTmZWp2lqsRUYZNC2bW9Y1cbXApN8/rE04AfaTEs3utZFi/5re9kMLpPBRya2JYFsohTAb6wC8QJprQJRGev/DVjdd/+MyM1x8KVmuJ5Fz3+xKI/sLFOM8HPqDsIayXZgmgHeASSDb26gFfJFHqxwm6bQ7g5kGS5yrNDZVmgFiO3AyZwMD3lFrzSn+zvNFL1qnsDqoUQsiIntR1wVytdw508Z+SPRYoxqpA56Nk4bKWcQ2wxqmXltYennHoxWebeTJE+xX6O0fMwlhIaRx6tDzyzwg6dQ208bBtUMzCDu7zYgRw/Y3SghTRSdrhe1jWSReuKAz4kD55WlIL3juWhZ7s2EXAm23h/GZmvnJMWRpvecd6+C5MSKR0YlASeCnc6H3RP7v45I9iiLSeF02QoT9d/WUuQwhQgo1luSun/InJYqa0mMGXuCqsWq/mczRs5kiRY5Db9Pu0eS9tfJvntijs23XR3gsVIVVf4aoZ/Qf6CvapSNz7FCKbvPj+mQRHLXrn9eDlyjmALL7ylYvB7PhAUHeLJ7C5kaemAdH6r84o/DfPDnYif2ZBmpZ4h1XaK+mlfey3bq6B2BN2pJhCfO+o89oH+SlSE8mhBjNB6PwsW3VNBlvAwJ2Fy3XFHiFC2esYJ14McUPD8IZK7yOlit1RkpCLjTdwgw4/tlKm4yGCZtlV8Y2OudGAxy54KmyryN/3x1T+hGs9iYP06R9QsOQbiuP82b+wHe0aGrQ+VyjyDLfu2CE6orLc2FZykrF76gQeI+KoDbVh3ltuWUGmZaAZJpb7kzrlx84QYr+4ia7S4dBw8+QJeDs2VO8e1g3nuATvJaxeeyH82ZlPew9zPBmwdeio+DhtkJMQLWRl3ChnMi1V/JE1uMEkrIhc9+o2cicbW3ty
 wNLm+uf2
 etHnQ/HhUm2tHXgw9gRFZF3cDOQ3A9gxUB7dBu8GQzd8aIxd2fScJzeWWPUqlTAOJq2NEzjCSGIgsLMsh19ZcTpNipf64w6b9KFTwYyu382WrnB2xVqotzmgRsYwng75BhPxEg+axQMYmvf+VaiqT+1/HQnJj8uAfpSTIOAXbX0O2Ojs6UKIGFL32GlrqBoislaM1v1gV9HMm1rPM/txfhEyTxjrniKb/w84wnR2mp2IXl0rVxfc3n5ncb0qMXgEc+nl2UDtVyEAQyN/z2Mj3KcS5zQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to support shmem mTHP collapse in the following patches, add
an PMD-sized THP order check to avoid PMD-sized THP statistics errors.

No functional changes.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index a987d233ec47..6c648ede24c4 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2518,8 +2518,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
 	if (is_shmem) {
 		lruvec_stat_mod_folio(new_folio, NR_SHMEM, nr_pages);
-		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
-	} else {
+		if (is_pmd_order(order))
+			lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
+	} else if (is_pmd_order(order)) {
 		lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
 	}
 	lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_pages);
-- 
2.47.3


