Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DA2C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:42:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D3FD6B00AE; Wed,  1 Jul 2026 10:41:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 485856B00AF; Wed,  1 Jul 2026 10:41:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C3086B00B1; Wed,  1 Jul 2026 10:41:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 063896B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:41:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5F207120391
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:58 +0000 (UTC)
X-FDA: 84940472316.30.748D9A7
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	by imf17.hostedemail.com (Postfix) with ESMTP id E6FB840002
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:41:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VilkIkHI;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782916916;
	b=14i3S3b+qtMWi2wblQ/k/IY0+f1TtJrF9M0bpWvcorZdSgMePMlEdtFE3ednrrEQxsOHZV
	yAJorQqICRhZYkma1HD8HUZSlSxwQleVr4v0ZwA5/qwa0jfYqiLsiA24tZCToJGpzGGghi
	daov1C3UeYpu9zilg7WEBVe7C7wsQ3M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782916916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1Mi2NCZOh7gyuytIB4egxj5ow/4/wiyoWqiBaGzzr4=;
	b=yOPWVkXpyKAqb8HHGuZDe0+4A9BrI2D4Mlo994M02JRvVpWmuqY0yCoAOxPa74zUr7rPOg
	fZA9duC/wzgALmIKtyjAHvN1j8LeTy3W1puYIAmbIJEuyf6liOn96pbsr0fa2f9bqKNu/6
	LFAIHFfosoqYhLj233G5M5iupXqmmuc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=VilkIkHI;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.222 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=D1Mi2NCZOh7gyuytIB4egxj5ow/4/wiyoWqiBaGzzr4=;
	b=VilkIkHI4gnE20Esw2L0eQjC9H+zZaUy1C17aKWPmrN3XPkTdkjKI08tGLiH6YUQHdZPVbuZL
	FAYV0EjfXYonTtiJlcPwSTVX5Nr4g3ah1urx7WvC91d/qXdKpZ0IYAjJn15k2sKMCagjJ9n8KeK
	kREiRP63Y2L8bleP1zGdCGM=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gr2Xw5HZmzLm4d;
	Wed,  1 Jul 2026 22:32:32 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 9159A40563;
	Wed,  1 Jul 2026 22:41:42 +0800 (CST)
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
Subject: [PATCH mm-new 3/5] mm: mincore: replace __get_free_page() with kmalloc()
Date: Wed, 1 Jul 2026 22:40:45 +0800
Message-ID: <20260701144047.3786939-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
References: <20260701144047.3786939-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: pss7f7d97bhhxkn4fen9efxdq4hpnkso
X-Rspamd-Queue-Id: E6FB840002
X-Rspamd-Server: rspam06
X-HE-Tag: 1782916915-372095
X-HE-Meta: U2FsdGVkX19AXvU+vD9exlx95jtE3t3NUIhwDWzjRo85ZGqgB/q/xIooqTIyy+tPzd8daTThGgjqsP4tKcfIZhLA3+u9v3z/JEglH+FoU7R700jGcrMzxlBN8R56R6F8nLYt1tKpWUa7D5YQDupFjwNr2+YG/hWW2E+uPQRBuBbjiVLIZK5xvUYntGCRn1zOHwgnpgPyqjSAQJbX//hhITsNG3jZjlpFO7REjy8ffdalZSfdkuTZHxgg13umIj5xmcrazcukUFz0bfMSh4avUbSwYWIOIJ4M6nzDruj4L6Wmzf9MYosf9eUUYTOibsTUVXRc98pJ7NMyphktmOIfHVDO5dqzuyzZJCrwZXwr2gX1+4xvbC255c0NwUCdSvpP/IJxYMrZFgVhpGsbPm4EEe95qtDUNsqzZx7Nja4FtJ0S7qbTHhxqkmnwO8cfGULleRVfLvRUIOY4nQ0PnPgJrv+zcijk0msuiF02X+owSSkd6tiSW33rCwnsMHjcvKQrKEeyDSh12EtMDIwk+YvI9isaNvLMkaf4DBkl/Zboa+6hyTEQNMiip/iQqwEc2xrxlUnrTJPUUfNrMCqiMaDJh849a89FpuV96QKgUz4SOFeSTNb5nDdjBLGuvoc5vwiGzwUU9DMVoVjmDzHpTK3haqaPfeN2bZiN9dhEKBk4ECSllLpR/B7vkCOMnP+Y/hY/95HFCN6BqQ0U+Zbx071SlsmhqmD4wTuyI6ni23PivAkdLegpmQaxuWB3oKvuFXQz5xqWLXrLjCw7sscfy3vKIyLn0GQaWldfttN6WQNdzMX8P7iLvhP2ibIx1YDvtyeUmDP4UjkSeltSYvDE6hVvb4kiHcDA35q+7N0IHdO/IhPMI+jWXt+nkh4zFez0IuajArHu8M1shEnwcMhGJ/dbqOLfhAoFA7Q3E0m1hiCIaLyAlPScS5xC3xHgCBqpkqygKOp+z/jUe6JqAb5l2Mb
 nFtFXSmF
 KSUNrB6wwHAIJkwveMZhv/oBb+nNAOAHVbQBM+0DBu+IuVJCaQhmVFlgdAKvCKV5NRcV8fuTgpo/fi/vTkhuWKFPp1vskwYLhTKeYsKvUJR9nSiO2mT0zT/MK+9E8wTPlrGOFevQQMXFTR2Hn9F8NNHiWbzBTFAE9o7JJnk8cfOPBmRbR2Vph6TQyEtnVN6Hy7KLr1GC8wRRxiJ89+Zb/FkwgFPzL/NZ9qYA7amr62BeSjGquSB0VJxakuHC3SdDODstpDyX7/zz9LZY28s8LntDmUXDC2mTcuaGR1B4CPzj0UkDWbONTrhkgSVqpXNtVZEDR9O77UFKomftE9IIHtYYZlQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove ugly casts by using the more natural kmalloc/kfree allocation.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mincore.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/mincore.c b/mm/mincore.c
index 6374819dd5c1..d561f1e5c461 100644
--- a/mm/mincore.c
+++ b/mm/mincore.c
@@ -13,6 +13,7 @@
 #include <linux/pagewalk.h>
 #include <linux/mman.h>
 #include <linux/mmap_lock.h>
+#include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/swap.h>
 #include <linux/leafops.h>
@@ -312,7 +313,7 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
 	if (!access_ok(vec, pages))
 		return -EFAULT;
 
-	tmp = (void *) __get_free_page(GFP_USER);
+	tmp = kmalloc(PAGE_SIZE, GFP_USER);
 	if (!tmp)
 		return -EAGAIN;
 
@@ -358,6 +359,6 @@ SYSCALL_DEFINE3(mincore, unsigned long, start, size_t, len,
 		start += retval << PAGE_SHIFT;
 		retval = 0;
 	}
-	free_page((unsigned long) tmp);
+	kfree(tmp);
 	return retval;
 }
-- 
2.27.0


