Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC16C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 12:01:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 801CE6B008A; Fri, 10 Jul 2026 08:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D8986B008C; Fri, 10 Jul 2026 08:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F16B6B0092; Fri, 10 Jul 2026 08:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 441D76B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:01:09 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9BFC312044B
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:08 +0000 (UTC)
X-FDA: 84972726216.30.C453B83
Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA73114001C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 12:01:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=55VBDyCG;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jLm44ch9Z9sKOGsiFmujhyffDnqKNPjui1ZX84dqFco=;
	b=KxUuI1jAzFPmbb8vm+L8RVkMo44M6bT80e1UyqYLMrIyxOl///b+jn21c4co2eHaZTBycH
	LNsP7jV8QSGcOde8fUxOLZ0FvfZpdV/UaO5VVapxKKMX0vbQ3s+tUVC13SoNr9NtGdqkUm
	Iq+GI+DEjanDw8e2uA5r7dkJO4xop/o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=55VBDyCG;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.224 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684866;
	b=BrxAtUqSxCh5ZmC981meHkpA8faqyY07IiTtU/boiY9tBn4VuiXL7mkvSfqipuI54rRGvc
	qiDEXakFgFTH++e3OcAIK38ZpUVzxGxxjYa6e4rcAOWh4IahuQBqT2ncTVB+/eJ6gBLQ7p
	9fftleu2dle3Qt7uMS+VXnMeEpLf4o4=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=jLm44ch9Z9sKOGsiFmujhyffDnqKNPjui1ZX84dqFco=;
	b=55VBDyCGAfYsWrtgnfpC500uAWjAKCEtrlTogF3ql5FO6dy4bgRZWnkolajkPJKa33Zjtqd3K
	+85nNz83vhtShmrHqMVStZTDE6OGYR+gs7MUXfMuYKbVNkJb4afLSFu0MyzSXosPgdxu6j5z9L0
	i9+qQnP9LKYdr/GI4F32Zs0=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4gxVYF68Xsz1cypX;
	Fri, 10 Jul 2026 19:51:45 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C233840586;
	Fri, 10 Jul 2026 20:00:59 +0800 (CST)
Received: from ubuntu (10.50.87.83) by dggpemf100008.china.huawei.com
 (7.185.36.138) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 10 Jul
 2026 20:00:59 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, David Hildenbrand <david@kernel.org>, "Liam R .
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato
	<pfalcato@suse.de>, Zi Yan <ziy@nvidia.com>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 1/5] mm: mincore: remove special handling for VM_PFNMAP
Date: Fri, 10 Jul 2026 20:00:47 +0800
Message-ID: <20260710120052.103886-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
References: <20260710120052.103886-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: CA73114001C
X-Stat-Signature: bxyk1zhoud638qsgu8hked1nc385cw3e
X-Rspam-User: 
X-HE-Tag: 1783684864-474455
X-HE-Meta: U2FsdGVkX19hC7sqYJwOy+F+Ky7HaTiMKOvcsduyR6EkkSwXCEYft4Cbs/+KvaQtiGwqtHp56Um30pzYRS+1ESdCFKwzYDuQfUbj7m2hF8DYRcBNrMo4t8heH7j0X0zlD/9dugwIPpeYnBlqYpNJjqaqBUdAvXPbRGMQe9bLvkNakvWRUfK4m0f+YAC4kPzdB8ZgcE9HfR+R4d4ghMZFhTwj8ngD8S3+bG43aZlalrr1TbLTwrgz+cuiLpkSKSvQpACIYaTFuUnmzLP2aoqR3cEdOgEKXJ9QcOyDVD+hX3KK2oLvptorh6E01xEqX+kQ4xENtQS3SUSzZQJXVb6Cug8SWkVBdDToBm5sRqj2tIQp+H7xRnZPLCB4t9GuYMWgfDQR0vnmqQq1y6OdiyMK4vjux5oUSUnM14l1WMVKw7z8dnGy/i5jl0Nix4Aw2DsY1cJQBtiIbyxZOzukAY08JbE5yK5VQDGK1Hihqxpk5gZzGLeEVG2Ihx1EButdtVTTf7zWR+PL7xAxt5yx/n6/Uj5WWpmY+2RVGTACq/QguReet+SeSOczp4NMby8Fx6TLDkFZEKVW6F//HCZ5N8CIpu5KLWX4MuAPKBNrsRGjFE5gl1jIwqWsSFl719ncrubEetT99rIz+ZNofLDDvkeTiXTM7QAPExItiS0L2JjV5RMtbqCXMvnEN8365rgQCIeI22oeIKL1h5oOQCcltjG68f2c9yInKKwMMuAS/u6/9dsAUOs0Rsy1YYtAV0X1gYEwiyx3Ijw2LLHKeta4m+7iL9+XPv35ek0/ZWd2oDdXuKp59ACHTOzo2QlxNvFdfv9+8iddk7gr3aTV+/vhIDIURzqCBUJ0N3EvDO3dxUVmWCjdI4q3YJBt/8j4EepN7wuNbtFr20Xz6SK8YQZI4tF7gwm+N0n0Hn8jUAvZ/SnEsDRYQtY83ITPR3zrtDukTFQfcFg1kCsmaIn5HcIDtUQ
 LH/dMsZl
 iBHYseIly2ROW+1xAfZ78Y8/qIS8zeefRpOPcqE0wLaAzw3NijqBVCa76lvNuF2EZK8F4KOLC+K6oe+ONyaR5HbfgdQebxb4vwLtZtZ7Y4JSUPjlwhX+Ob3ttIhXOJpdxrrl5U4p0YPKrYWIGmRwNjPERIFzGSLUexb7DmW1md691tsLtaIl0rcwB2OuWEorI9WpT5VyAbKjmN89IHc82/IxUw6rQH2HquM67DKH6X9w0pjE43iJX/76esupiKYSlvBVnstaEuo8/jjl107JHsztwzB/V++drq7KzTKGoLYmGoKwX44YgDmUNzuREdEkH2KUjMqxPPcLT3Zc1tCgn9U0ov4Angxa4FOfjIPlDeJ5el8BjIhhCTAP7mvOZ9KPcEFY3GDqYOpUnfdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As David pointed out, "it’s hard to believe that someone depends
on pages in VM_PFNMAP to *not* be present", so remove the historical
behavior that always reports VM_PFNMAP pages as non-resident.
Instead, make them now reported as resident by checking the
VMA_PFNMAP_BIT, simplifying the code.

Link: https://lore.kernel.org/linux-mm/0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org/
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 53b982803771..0eb832ee0a30 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -219,7 +219,7 @@ static inline bool can_do_mincore(struct vm_area_struct *vma)
 {
 	if (vma_is_anonymous(vma))
 		return true;
-	if (!vma->vm_file)
+	if (!vma->vm_file || vma_test(vma, VMA_PFNMAP_BIT))
 		return false;
 	/*
 	 * Reveal pagecache information only for non-anonymous mappings that
@@ -259,14 +259,6 @@ static long do_mincore(unsigned long addr, unsigned long pages, unsigned char *v
 		return pages;
 	}
 
-	/*
-	 * mincore historically reports PFNMAP mappings as non-resident.
-	 */
-	if (vma->vm_flags & VM_PFNMAP) {
-		__mincore_unmapped_range(addr, end, vma, vec);
-		return (end - addr) >> PAGE_SHIFT;
-	}
-
 	err = walk_page_range_vma(vma, addr, end, &mincore_walk_ops, vec);
 	if (err < 0)
 		return err;
-- 
2.55.0


