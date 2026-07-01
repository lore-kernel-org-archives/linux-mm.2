Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDAD8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CF256B00A6; Wed,  1 Jul 2026 10:41:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A66C6B00A9; Wed,  1 Jul 2026 10:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E5706B00AB; Wed,  1 Jul 2026 10:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 304116B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:41:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9FB271A0379
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:49 +0000 (UTC)
X-FDA: 84940471938.05.8A218A7
Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5A3EB80004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ww3hwxhb;
	spf=pass (imf30.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782916907;
	b=wSxjM8uAIrJ3G+DJ6zDDA9R7u2aYvXHufaL0Z3P8lJowpnwjjBKlIJDislPpiTAx0JbNAV
	3mlE8Qotwc/Fs68OffH+SyPN1s5C9k4F3rbLmXMAWeueZWKnzhCMx7JsczSFokxnj8c8sZ
	4kdYgX0e2hEbX0ol+bIBdka6NXrLo2M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782916907;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7eEcMII2cUp70H+dX29ejpuNOhJPiaRFJzaWfwzKn4=;
	b=ppnB/qtEmrB1Y4I2RxVnEZ5O5Xp381kgr2aqaBtVguRIP33D+hIYvW6rhnXwXNdOmz8OPM
	hGE4hIo43lUUZ/fkEaHSBfYQPQh3nmu6WNr5vh4Vz37xBx/M2dBjQvytxZuxLSszI7w4Pi
	e5hMIb0si94j/aSWFLrmVvYvBV9HL9g=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=Ww3hwxhb;
	spf=pass (imf30.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.219 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=t7eEcMII2cUp70H+dX29ejpuNOhJPiaRFJzaWfwzKn4=;
	b=Ww3hwxhb3ZVa+tyUecA8bT4A2U/TzByk9aGrkiEjbUBwcTRBFG1ZYPxXTYNicTbHo4B/K7ENh
	jmjB8RWPCONqZuEwtmxOAywqWtC9aGT+Z4O8qYjlhg0197o1oraATams3EyMga6LrpGgWrQiOGn
	Df8eYii9KwtFGIhZNQIkBk8=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4gr2Xt0gs2z1prL6;
	Wed,  1 Jul 2026 22:32:30 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E41724058C;
	Wed,  1 Jul 2026 22:41:41 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 1 Jul 2026 22:41:41 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro
 Falcato <pfalcato@suse.de>, David Hildenbrand <david@kernel.org>, Zi Yan
	<ziy@nvidia.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH mm-new 2/5] mm: mincore: remove special handing for VM_PFNMAP
Date: Wed, 1 Jul 2026 22:40:44 +0800
Message-ID: <20260701144047.3786939-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
References: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5A3EB80004
X-Stat-Signature: d94zm6ympafmspa4cdfbjz1y4smn67ho
X-HE-Tag: 1782916906-763865
X-HE-Meta: U2FsdGVkX1+FFukwx1nHnWBMVfKcJ1w6lJkzKYA42f9V2/tNDQJNkNx+aA+WcaZLCgZal9Pp5QXbMdOQOT5bJgIdjt4T1ifqsTKH4oWH0M8LiASlmylgQg/bN0BbJQvdhGjUiGjIQSOV8hkQiRAUtzviCI/QTsRCcaelqahojzIwLEp1mOIKFC4Tn9EtIH594i4lqTbnLQokfZjOtXx+7H47D4X8h2WHJ0TU3+A6TT+N2i5k+7w2xv2uEbLDHLC62y9tU3QJNR/9zTL4NFTCt6Hi4MzitcMTRyiHTfmZduUJ3lU9vVDHxkByb7AXemH4Vie4uK8VTlj2GZ6XUUmI+bD/wC8EgOOr64HL6KRNhrjJBBpRPkBsGxZUyayq8JG1aKdDWMAph8GEmJD3nWaBX0kXVGX4dX14+zcdsjvkuiQaTCrG85UeAf1gIV4H4AwXXFLkvFMtvpUxlqnDQLXKYuAbeZwYcHsNIBMPXzZJ2v2pggWgQkP+PNxa7UbrXjKt/9qGnrFJwh+/nUj7ypuF6DBB0U8Z3ObAeZLTHeE/QEL5jWItAamrFTsEEAd57JIHs8lsrGihz26siXu0q95Vyh4jsjC/OK4hwmX/KFulQpUr4diBKPl/xd2j/3MhArpJBlS2T36JZMz1oYmhZ3Qfu+OMGRXKMqhMAJuevaBq8m2k7mA/umco66alfGNnneZ1czs23hRdtJCe/Iu8Ii0XUhIv9xUf50h4473ZlPUrj34OIf3TmqWNGw8KdMmp1pJZWnyj4IoTp3Lk7abg8ietXek8hYPF+5DrHKYJ/bw/pN532W9hEN76L503azjBA+apMFcSlm+qVndBHNPcOeIKZbwUZJgr6xbHJj0NLXjVdgNgSl94fyZSeXt8BS8gVHkvbYgES+Ri9ono+LPxEe8wm25UL6DQjPHV8eXavw1miUBB9bzcUT3jbRbOjLJ8wFNs06lBpvB0L48MNyFGEW6
 gKu4mCl7
 LqxRr3to5HwUD1wXLMTMspmTBXTk+cZ/xIeYSaN/+dhdOmx4D7n6/T1/FHysZqPl2QUcotEXjiB6JbKTyvwQaQ7nuwXPV7XfGePkbttc0Ev9kevh6elljNR1lXExv2a7mzE2seDN2Tl0h9jNtny+Hh07pXbf1fwpMMFglm9fkT3qg0fiO0/if4YUEmCnN+arD2vnCSLObU3uCX4zVcHX0mEeoeal/N4iEx4QzwZJTRNBu5aY1zESHWlluLzjLHbM6M+ekJdivtDl+TV0joykbTR0jlDiQPTUUvQlPYlxmECeG9hhX1SESXkTj4YtkgiJFisnqmRFPo6QWAEJJK0BDz6kYKRSyDsia7YbQnWcMv+VgUxPx60x5Fn0S0ZOI35wji1vgGZNux4Faijc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As David pointed out, "it’s hard to believe that someone depends
on pages in VM_PFNMAP to *not* be present", so remove the historical
behavior that always reports VM_PFNMAP pages as non-resident,
simplifying the code.

Link: https://lore.kernel.org/linux-mm/0e619d71-1c3d-4534-8376-2982c7348c31@kernel.org/
Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index f561d6e01052..6374819dd5c1 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -258,14 +258,6 @@ static long do_mincore(struct vm_area_struct *vma, unsigned long addr,
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
2.27.0


