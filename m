Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D018CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 10:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362F56B008A; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 313E46B008C; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DB926B0095; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C0726B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 06:29:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABE1CA057D
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:41 +0000 (UTC)
X-FDA: 84863631762.06.8BF8848
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf30.hostedemail.com (Postfix) with ESMTP id DF9F180009
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 10:29:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Vr1gASMo;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781087379;
	b=eEkK9mvoJXw2L99xS0RkZKZS/TtBmKURiFaVaRVuge26wlSdVH3v2w2JIsk3zinVELcNeG
	u+LRA5TfKwsvldBMj2qk751skPIFyD2BisQXTYyTGaX4oZwypLTER0PXGxMKt6cOD0yJO7
	2qHC1G66Qxg4ClbGZFacUqc81tN5bCI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Vr1gASMo;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781087379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=73PkU5SoaImbKfw1j/NfpvTWcYJyb2ykeO+wdSwB/I8=;
	b=V+G6qz0bSVSc55XznnaHMh5Vp4HWBwo3rrxMzl1JoWh3jkHH7/YPMsNOxGwwXiJPbmZUYk
	kbjPDydDAxKysJhrssdNbmfxQy+e9UOvbExMrWIqeMc5pibtU96M4gqnV4LAnur0gjF10m
	tRcwtUiZLqwxoRhd45Co4aCFO7pdjTI=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781087373; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=73PkU5SoaImbKfw1j/NfpvTWcYJyb2ykeO+wdSwB/I8=;
	b=Vr1gASMojJYOosbN0vjN5+NnbmCr7x3j1vTVK8Qw1OXCtq1FbK4jqqyyec+PRsA80S1mSNdSzfMWnxipKy+EJyVroFcDYsx53uPSE3Al6HoAuKeKM7XZERqRNEwniJ9nyizVZxHVu2wZRcjXG6KqCwBWQb4TkWguivzO/Lx6igY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X4aU07y_1781087372;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4aU07y_1781087372 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 10 Jun 2026 18:29:32 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com
Cc: willy@infradead.org,
	ziy@nvidia.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 03/11] mm: khugepaged: add an order check for PMD-sized THP statistics
Date: Wed, 10 Jun 2026 18:29:11 +0800
Message-ID: <6e8cefeb420866a68353fe8decdb4162c877205e.1781083630.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
References: <cover.1781083630.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DF9F180009
X-Rspam-User: 
X-Stat-Signature: ayyz1dwh1tkyitimznnumswgyhz9j5qe
X-HE-Tag: 1781087377-526327
X-HE-Meta: U2FsdGVkX18g89fB028+fD23bZu6zkPhoHfPGGGT9jcyYe5Xy02hIbFaL7/OEwQvujm1ZjiAdkCDzs0zb2jLi9UK7KpHzasdDHHudBcy5CLFaZuNh37dqCjZvv/B+2WB3g98ifdoSdgeUiIBo2B7Xz27mNTjacaLdBCOGKGxQ4l8FmT0KB+Gfn2NrvhoOqv2/iKE5L9TolPjGybFCse1FXa9v0f9Y7Qf5Ft2Tr7puK0lSQ7sdc1Yyt7OB14Cuv7V9vcCZCuLHhIW8sso0d/WoZ5hyiUuPZrBx9YTkmRpb3rgWT6NNg86lcNZ4MSAOSzCicY54QOLFIBr8AZ9nHqAb857TFWos3nFXZVdofGDIN6koYz2YSrpqystrpz+srzBCBp5rGn3zCfbZyljMh8Ak8HmgMjMjq8b50KPML+DgOVHLkdIN+fuTADPuZJkPcnSOY0H6PvvBS8wP+JVl8f4WDm7RNgjJEwT3vz8vHmuZgijnjheYf4mrUYtzw7p+InUaLZxy0b5ERaR2/LTFktd5hDaaRi55EWN+gTFQr71ZD/JdIH2hbafP5kHnslX8KoTXuSYoFAYWSQ5vLzhNePNztOg7SM3izyKV2hQh1oDuh9I+cCjicdDNcvIBefOhMIqgAjkMwIbLJYSbgYWAhtg+aDGJ3Yc0PByUbGdGA8TkidjsE+CRel0ax+eqRCzIfPaGNe7r8Sqk2Ap5mOxCSc5yOpMoglCWH06b4Ol//i7S6bW3WuOEvUqwwQafxR2xLV5Xvz/l7eXj+/5LM5hOInRI315+ZPig1s2/1TQs6wpbIMMd98uW7WiKOMG9dw/nRBV+NUcQ+szwZtwhujapPo9TQxhXiOM773LXnZlL8Hns/+G5AT8O5jUfOa5pbqjwb/Rw5XOAV6ZdMy8U/e9lvAGICwYLzWI+4HJNmJAL6PUrN6SyeZyKnr1Kwq7oj6MYFTSgzqEsIgPRzv9QnY3wRs
 F8+ewBAi
 wqnb5NSStkhQ1TMwaWUtBRq+tdXgt8VWUrDIbFMNi5VOqCbZUbR8PZMa7/LgrvJ7Vq0C27G9XjkcVuDv1WsShkN4h7XUypff6vcNjPMR5dCJUTvo5qJKnu4Jwb/w4dFVJVHVM8spPh1aFQ7F8Cw7h4kRnnFSHMFrBXH9Mvv6jsNxt3Bo9n4Zk/B21x+wT1sKM1Cve5FhCNwCnyvFAX6LeHl/78OsUC6I2uFLJ497m3MQQa3EaDhwz8ItbdljpzvHowAKUSEARlUzZ/MmlXmpYU8ZVQg==
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
index 4adc8c6de062..0c8dfbd48410 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2595,8 +2595,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 
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


