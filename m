Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF87ECCA470
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 06:14:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B6048E002C; Thu,  9 Oct 2025 02:14:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066EC8E0002; Thu,  9 Oct 2025 02:14:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC6038E002C; Thu,  9 Oct 2025 02:14:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D61428E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 02:14:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CF48C0A34
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:14:27 +0000 (UTC)
X-FDA: 83977561374.08.C70A8E5
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1398514000A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 06:14:22 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="FYP/xBGO";
	spf=pass (imf09.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759990465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NXYc6/PKgby/hjSOUXr+j/JxsLAfBHlg+MJvQuL10CI=;
	b=lJotR0aVDeib+O54LXAxcoNRumZ/sWfHch2DEk5YKMt5dMRb4SoclTISMcbYQx7g++mZoR
	S0mQC2oOXoMLIDSz/eSkPYjam1MIok79BTd30U2tizBfBMQr29RobF9+Apljub1IdBO6kQ
	49n2pUUjjS3q7KvwOeqzsYl7fjOMcB4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="FYP/xBGO";
	spf=pass (imf09.hostedemail.com: domain of yadong.qi@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=yadong.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759990465; a=rsa-sha256;
	cv=none;
	b=Zum82jPmnfFGXxJZDacEXgv4DNHfdsCBhTiS6vTARMjsWmj4mYen1GzQprK3mEKhFpO5Do
	x2Qko7j/jm5y5uNbZS/YqZza4BUQlSjgU5eMsm94WEi9jrYW3+PwqC9cPTux3Aaxi2xPys
	2EHlND07rVCngSWztjm9ucT+m1NUYvk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1759990458; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=NXYc6/PKgby/hjSOUXr+j/JxsLAfBHlg+MJvQuL10CI=;
	b=FYP/xBGO0FGOIzPZBd/24GO17x/O2oCNrLiKc8sJ0hDqtAplyn8znOFN7bVJseo/nmFPOoJqDOGFuFks7TluFHTO2GUtil8Hx0MQ4ohOxLiML1I7HklcWbOjJ7fmYkSUYgdlbuJNikVWSaQwk3WAvbssBEvuRoZMlXhLxAxgr4k=
Received: from L-G4162440-1116.localdomain(mailfrom:yadong.qi@linux.alibaba.com fp:SMTPD_---0WpjGzvk_1759990452 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 09 Oct 2025 14:14:13 +0800
From: Yadong Qi <yadong.qi@linux.alibaba.com>
To: akpm@linux-foundation.org,
	urezki@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ying.huang@linux.alibaba.com
Cc: Yadong Qi <yadong.qi@linux.alibaba.com>
Subject: [PATCH v2] mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned
Date: Thu,  9 Oct 2025 14:14:10 +0800
Message-Id: <20251009061410.820-1-yadong.qi@linux.alibaba.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1398514000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: whp95urt35dengt7s38dyqkc85ncjmtr
X-HE-Tag: 1759990462-368830
X-HE-Meta: U2FsdGVkX1/C0t4b/vAVL/ZSLGCnYGDE0fKxrH3idVK2D+J2yC+My4mvxtnlIXBVtn2YKxNYC7BL6Nx3ShODudK2FD/01HqP0UviYyXfgTSXt7npBeZ1xEEyPasR2pmjqcRRSN/xiWsIivWNwG0tOBllLDIT/Go/Fu+mwB8p8YI0dS/5/MBlpS+YiprDgbtN48nmj/X8M3UY5WAY4zg4AdcFwe/htupeei6Ir9gQdQoiEb7pHD/gBbLRJ8Nm24Fc01ZBl7R78hCwIl+h6Sq5/RpIuPJ23tG1zAy0xzpZi8VFxm2fGKnHLvjNenukODa1hHuPswwWeynvvD1gtZdT+WPrFlqAf7xzv8JeAiIMQF6t0UWKXgXSLLgieiKvB4rwE2dF7wjQYopSIN9kApr4JKRh0lwUMHGIPAAUyqEYUa4HutceNlSFniLwGPTlTyfO3OAEp6ps3zffSBEAszgMTqTE+y7IUyL3MmtTPamsa9LJZhnKV/a4X/Zqkzigdy0JsSuSNl3r4um0Ea1Afmo7PV2sAU4F+RCOKQUZm77iVUlf9TdaDmEfpJwwEw5M3gW7HldI8DIfuTieKdEywWw5DVr6Gcgdt2JMfjHG6RsJF68GLCGdGYmWrIWUXVceztN/XcF2jQL+GQfh84oTrJZNuNNHsnVlPvA+HL/J8DeAfg1Lpr+OS7DHMQlb66o9RFFJ5i6CVEsycoPT4ffzScUfZtZQ9mc9Wwzfr4ckcJQRt32g9HvEdfq+6QXW84Ak1LuJr4rO35T9S94FoJYsmkeZxpTFHgSBR+82fpX1wRqL+0GXObPEDeyp5u/YgTN9858p+K308LnfZ1eEnmyB8gDIfe/4Fm0nKtP+z7FuPT0XkUXwNL/cOQX9kJ2UXXotrkeKndLXw1XgNw1roHv16kH+WfnBkAoPFlEo3NFaVVcualBv1LyE0l763WhOJ9L5z9BqD62+G1zMd2a48Lk4gkw
 aKuJ2EYv
 9dujW+hDeLgA3+Q8SwW9wFVIlTyigag8rkF2qSITELR/YR6kN9LfISu2XVC/OVtkR0NgZY5N2zt/YGcj5BlOw4FhFyG4wbxsqDlwMEUr0XHlhQNHLBRqa3HhWOwi0mwEH3rKVWNexZQLYcWPx0ahm9Gk87Z+K5y1VnRFLJVzgfjfKh+rvZUTwWH+nn8R/ii2ZY/2mgb435n1sSQ2N9wtJfqCx1YFJpflJ7uQjCCH+YaxRpX1eu9ti8B8AqMX68MlBidKHKOrVdNc8PuWbgbkvoeqiKrMxyCV3+WSvtbFfKjodEiupjAc7uxL/6q7oMYchJAXOgOCUtaLLbYg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In mm/vmalloc.c, the function vmap_pte_range() assumes that the
mapping size is aligned to PAGE_SIZE. If this assumption is
violated, the loop will become infinite because the termination
condition (`addr != end`) will never be met. This can lead to
overwriting other VA ranges and/or random pages physically follow
the page table.

It's the caller's responsibility to ensure that the mapping size
is aligned to PAGE_SIZE. However, the memory corruption is hard
to root cause. To identify the programming error in the caller
easier, check whether the mapping size is PAGE_SIZE aligned with
WARN_ON().

Signed-off-by: Yadong Qi <yadong.qi@linux.alibaba.com>
Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
---
v1 -> v2:
  * Use WARN_ON instead of BUG_ON
---
 mm/vmalloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 5edd536ba9d2..2cad593e4677 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -100,6 +100,9 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	struct page *page;
 	unsigned long size = PAGE_SIZE;
 
+	if (WARN_ON(!PAGE_ALIGNED(end - addr)))
+		return -ENOMEM;
+
 	pfn = phys_addr >> PAGE_SHIFT;
 	pte = pte_alloc_kernel_track(pmd, addr, mask);
 	if (!pte)
-- 
2.43.5


