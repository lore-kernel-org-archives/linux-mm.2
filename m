Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58029C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 718E06B0095; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CAB16B0099; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590BD6B009D; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 278DC6B0099
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:59:00 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A07D140559
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:59 +0000 (UTC)
X-FDA: 85225527198.17.DD14F60
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf12.hostedemail.com (Postfix) with ESMTP id 44A7040006
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eJiNIiVn;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIKdO5bjBZZP6x4MDEA3rAxUaYok98mp4CY02zuEzqA=;
	b=CXpTtDshvgDWyqiq2t0iXh/G+eEW2Q85cseLKvXALuy/sVrKAEF/orXJYiUUVoRBbJ0zQu
	JKxuPQYqjK/uPVYe2KMF8dYxiMDZma3iT2ymiG2dJs10FK9bsJZkE/Hs+fPxukXNodOoRz
	PFMqXzm1mgVEtFu3wd4hpBG8CmxX7kI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=eJiNIiVn;
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703937;
	b=hAmgAwZi9zecym0iw5W/IKncH8UWl7aCsssG5r5/wfi78Z2UOn84SyUpOJLIvtOZeM5WAp
	KYXQOirzlHA4LskQMCFdmBZsqNstDOMUIb7iilgb7lJPzDx8ReiA9vSKLEG4zyINwrOk5L
	tOZtKo76ZipikxYzuQQdCDo2v0INHTU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703934; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=kIKdO5bjBZZP6x4MDEA3rAxUaYok98mp4CY02zuEzqA=;
	b=eJiNIiVn4n6ersp4SK0Jw3gy2Ai2C3+JXlOjP9M5DpPGhae4hSrQLhfvweA4Ws/VXuP6peQHTs/i6exYtDQPrfbuihWzgY5MnyGSI0DSurjouOB4yqpB5h17yVzcyJfX5/CDMRecHK7vaNTmOzjojxsXtyCXzfnrW9tJqmtkaOQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R591e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9tap2_1789703933;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9tap2_1789703933 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:54 +0800
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
Subject: [PATCH 08/12] mm: khugepaged: add a helper to get the minimal collapse order
Date: Fri, 18 Sep 2026 11:58:39 +0800
Message-ID: <4b97f478b7569014ec52196a17532c4b664b97c1.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 44A7040006
X-Stat-Signature: uet3xrpaew1t6d4qiwfjc4b3f3zkdxrz
X-Rspam-User: 
X-HE-Tag: 1789703936-746502
X-HE-Meta: U2FsdGVkX18Lh6j5/ZK2HwTxP1NMhGX8JpYXrQzbQDK+XTQahGGGHmnOcvZMXZ75CMdVeI+NGIASQRX8Qs81Vmxito+iopOSwEaXV+9KiVAk0wCRyFubmnecsjwu3DwO9hchPDNx65fdt3cbMNTvE551AsXglOtSbB1yXpcsSMCRNSI0eyJc7SvKOBDSv0NkSnvZO17M+518NEXbP6AIw48aR1JPjP1VS11k+DhRVwstrpWCnfNbQ20Bt/Kho5hO6OsDzG3ztM+JO1iQ/YI1bkM7/Sn6pQNHKfKTqz7ZfESmHUeY7F3f22+Bt9pxMczIzmVuYbwvcOIcRb+2GVpXKEAO8s9pqreXMGQQLn++9R5Jb0BCoF+9C0D7MOwIXfW5bDaroEv/E2g2PN6BBIrb3YNe+KGk9vgyB6vPySs6mixBbyLjvo08Zyt+uH2761um0upsD3TgcX4fyo55GTphSDDoAVW09MVPugFiS0zZQdSne8i073tuOjlnvpF+Pp6rZv+mmmY0WYQV52vfrhxwpXGMLQc8s5voHafyqYKJw0CxhUj6BL5pOhpe99uWFBGR6Lcgi1J4sncxeJbHKQFs6q1tdpdkvXAOdI3SfZ3hFXfvWg6uNUJGYMY7pRq3u2DO6J6vmObSAmYJohSv1iZufHvaOSifim3arT8W9fjCYIukRakzFf+Gum7IsrgeKO0VEOpioOTiC1VwA9MMw+Qpc2CBmI4CJNyw1dRe5NM+Fz7WTurwMq6PRAbYP8JZfqhIIRJO5cTHRtPlaJhDYRbIFdfNs3krGCuyeurrJ0gWtu9LFbun8WaQrBi09Antf2jxx+hiFhETV1j56Y6nJIY+VhMGy3dGbqiYnqUVBmpjU86R8P/xdOkhSc9aW1slcooW0TEGM3988oHrBdPU8AmQaEvBIj4/uZGpxMWwD5fnT0SPkJf3WiKWl5K11vW5zK/zUOnCqcg4pIZ21RrQSvy
 Aea0DDfP
 Zd9g1egwyEhF7xHR2kwiBOnMzIKr9coXOi7mIzUD0+lWUyUXnKgukaP6EjLNNUaM1pG11wwaGXnMPrW5e0t/IfDel8ICHBtwIxxHZD0MCBVYHeYieD9HikHuO8pzu1nos+c4NtOPUzjSOlYE64nKsfm1QnopQlkw+F+sdYhfYfdzw+kBy0+aJ7a5ufx4RkAVyfhafjov2EJFQyWscshyqqN0U0IBf0N9f3KS/xRZF3fjlfwHeydxHrwi5rypBNwXRLeQT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

shmem mTHP collapse will need to support order-1 collapse in the future,
so add a helper to retrieve the minimal collapse order as a preparation.
Also rename KHUGEPAGED_MIN_MTHP_ORDER to KHUGEPAGED_MIN_ANON_MTHP_ORDER
for better readability, and add a new COLLAPSE_MIN_FILE_MTHP_ORDER for
the shmem minimal collapse order.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/collapse.h   |  3 ++-
 mm/khugepaged.c | 10 +++++++++-
 2 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index e52969965262..d2fff6b5e1ec 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -8,7 +8,8 @@
 #include <linux/types.h>
 
 #define COLLAPSE_MAX_PTES_LIMIT		(HPAGE_PMD_NR - 1)
-#define COLLAPSE_MIN_MTHP_ORDER		2
+#define COLLAPSE_MIN_ANON_MTHP_ORDER		2
+#define COLLAPSE_MIN_FILE_MTHP_ORDER		1
 
 enum scan_result {
 	SCAN_FAIL,
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 6c648ede24c4..64605a72ac2b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -302,6 +302,14 @@ static bool pte_none_or_zero(pte_t pte)
 	return pte_present(pte) && is_zero_pfn(pte_pfn(pte));
 }
 
+static unsigned int collapse_min_mthp_order(struct file *file)
+{
+	if (file)
+		return COLLAPSE_MIN_FILE_MTHP_ORDER;
+
+	return COLLAPSE_MIN_ANON_MTHP_ORDER;
+}
+
 /**
  * collapse_max_ptes_none - Calculate maximum allowed empty PTEs or PTEs mapping
  * the shared zeropage for the given collapse operation.
@@ -1485,7 +1493,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm, unsigned long addres
 		 * any smaller order enabled. When at the smallest order
 		 * we must always move to the next offset.
 		 */
-		if (order > COLLAPSE_MIN_MTHP_ORDER &&
+		if (order > collapse_min_mthp_order(NULL) &&
 		    (cc->scan_orders & GENMASK(order - 1, 0))) {
 			order--;
 			continue;
-- 
2.47.3


