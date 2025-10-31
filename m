Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D872CCCF9EE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 06:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41E638E00B5; Fri, 31 Oct 2025 02:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F5728E0045; Fri, 31 Oct 2025 02:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B4E8E00B5; Fri, 31 Oct 2025 02:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 213858E0045
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:22:07 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BF2A91A039B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:22:06 +0000 (UTC)
X-FDA: 84057414252.08.4202D79
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf04.hostedemail.com (Postfix) with ESMTP id CBFFD40009
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:22:01 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761891725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=whdxAAgUlA022yw9mpHKoHp8bTiRbNfpFUV7U3SyuwY=;
	b=odDY56U2MWiPSzoWaxZxVCGthWRvFj0V4yHJn9GtkxFK9goA6ZCtTFfi98vdp9o5WGK1Fx
	xloxgiqW8BqXifhUp0qVGytpph9h4t1nEp5NTElcmLy5hx5yvDAuiLTRKUHRUNMpWEYVlq
	a5aG88joeLFgAIMtiD1xGITgupM0oPw=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761891725; a=rsa-sha256;
	cv=none;
	b=c793UjS3CUemIM66f9ycAg1wXfu5CaWfXSbtLKXt8alYYpYSImj5YQE6hLSWVaw/01PkEC
	titTWIf+ZNXDb2yuyr7pxLFqwQY/2GefdW0TZtQJ9+UuezRvbK0gx2J/oSEwXuxkfN8Hc9
	mZ1vG+OON3LznyfLRIRB/4jgm2M8qkM=
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cyW7r3fSszKHLxT
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 14:20:56 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 307411A083B
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 14:21:57 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBXrUWBVQRp8Z_VCA--.32270S4;
	Fri, 31 Oct 2025 14:21:55 +0800 (CST)
From: libaokun@huaweicloud.com
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	willy@infradead.org,
	jack@suse.cz,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	libaokun1@huawei.com
Subject: [PATCH RFC] mm: allow __GFP_NOFAIL allocation up to BLK_MAX_BLOCK_SIZE to support LBS
Date: Fri, 31 Oct 2025 14:13:50 +0800
Message-Id: <20251031061350.2052509-1-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBXrUWBVQRp8Z_VCA--.32270S4
X-Coremail-Antispam: 1UD129KBjvJXoWxXw17Gr45CF17ZFW7tryrZwb_yoW5Jw4kpF
	W7Ar1IvFyrtF13CanxAa1DJFWrKw18GFWUGFWSqryruw13Jr1Skr9rKFyY9F18AFn5AFy0
	qrs3trnFk3Z8A3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Yb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv67AKxVW8Jr0_Cr1UMcvjeVCFs4
	IE7xkEbVWUJVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwAKzVCY
	07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
	nIWIevJa73UjIFyTuYvjxUrq2NDUUUU
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgASBWkDOq9YDAAAs+
X-Stat-Signature: 4ou4o3xmnm67uk96egshiz6nmnhsibo7
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CBFFD40009
X-HE-Tag: 1761891721-962939
X-HE-Meta: U2FsdGVkX1/qCTu0BZVajauZvkCRQBXXp6S99FPmlmK9nozvx9ll9O85shoq9Lka3ERa8GtcDYQq28o0pTZDUnT77JRjz56+84azUqMjzGm4Jh6L+Owe4D/0HRKIuNDLhoIwCj7ZvdcOncnHv9XkMCgCuUX3SV4mZ1QMO5RYWPNOAqDwP78iL/lnzvumjYtu5CPmWxN+hV5QLCgnpSFuyGDA6pHixMU3BAbDANuSLvpWhPjY4b4oTexEr1A8cz/CGrhFAyeZDPUnu7SkNeAT7ryRbW61C+VaZoEaorUMkQguxf+khsE8t8HA10kO865YNfiR4YaaUW4FvYksmDGqVyhDT3aS6WT0GKj0TzLB4ewFvfTX0s9aBaktUwpuWJrBO1GPSA4Qr5XG04Uj2TdTIDKc/Tu8hXH8F6WCBW0MFSSl3JtyyEOd0U7vxuRaKUuJuEA2T1WbahAV0ItRZUrRwXpbJS6sgMx0c4wcU9GiVDhOyKP1GHGepqoahJoBUukDZcoMm2aofWWBkXl40++k68tI9uwEhxlY//ZGgbwwp3EUVraMQytS8SRnehETH76mZ28scgCFrtMqCMd89g3gVkrEhDnboScAgzR37ZcLQvosWuVeIClUyj8jCuaO3VT+43V77kuZjynqlsgWXXamevmrpmD/gS2Muzwxz5mJCjqNUz1Kdtlj/I2BEARLJXvILq8aPoPi1m/CJHRqE9jk53IKQzle5t9nqyE8S66R97+FIINnnlLHyhRdUon8xpTlo3cqkvIah0Ka2meAvA1SfE8QkpR7nGA5NMDDZ+9KkfEb2M2M66jG++Qv97B5kM222Rp+hC+U4oWhSe8A6vdmEYbGWmNcXw6+NPe3fIm+LIgyet0tcWy4fI5Djg9Am2TYril9CTkLJFfWuVqRMN0t36FqTQwOFROUo1darTIWr6lfkxzkzKnbhCWCHPh/3EEvWS3SmpNJsCU5d8iflde
 Pnh+bkNJ
 gKtd+x/eTl2jcC6zY5Pt67x5C2dsIM8mNNw4X5/oWU5xqQBlLY4i9AllbmBM796L1SewQ5Qyt4VlYyKZvH1C36l47diVynv9StgmA+ZAz58iLlYSFucxiRL8n+iFCbBQbXEbt3EWAFDtK8LpHExcxL1Pd+u9owRqAC+YwlZBVfl54n2UeJ4uUAG6G3GbUUjuxbUngdRZYnbdKv3vmNIPte4eVp+6R20G2wcLv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

Filesystems use __GFP_NOFAIL to allocate block-sized folios for metadata
reads at critical points, since they cannot afford to go read-only,
shut down, or enter an inconsistent state due to memory pressure.

Currently, attempting to allocate page units greater than order-1 with
the __GFP_NOFAIL flag triggers a WARN_ON() in __alloc_pages_slowpath().
However, filesystems supporting large block sizes (blocksize > PAGE_SIZE)
can easily require allocations larger than order-1.

As Matthew noted, if we have a filesystem with 64KiB sectors, there will
be many clean folios in the page cache that are 64KiB or larger.

Therefore, to avoid the warning when LBS is enabled, we relax this
restriction to allow allocations up to BLK_MAX_BLOCK_SIZE. The current
maximum supported logical block size is 64KiB, meaning the maximum order
handled here is 4.

Suggested-by: Matthew Wilcox <willy@infradead.org>
Link: https://lore.kernel.org/all/aQPX1-XWQjKaMTZB@casper.infradead.org
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 mm/page_alloc.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fb91c566327c..913b9baa24b4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -4663,6 +4663,25 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
 	return false;
 }
 
+/*
+ * We most definitely don't want callers attempting to
+ * allocate greater than order-1 page units with __GFP_NOFAIL.
+ *
+ * However, folio allocations up to BLK_MAX_BLOCK_SIZE with
+ * __GFP_NOFAIL should always be supported.
+ */
+static inline void check_nofail_max_order(unsigned int order)
+{
+	unsigned int max_order = 1;
+
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	if (PAGE_SIZE << 1 < SZ_64K)
+		max_order = get_order(SZ_64K);
+#endif
+
+	WARN_ON_ONCE(order > max_order);
+}
+
 static inline struct page *
 __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 						struct alloc_context *ac)
@@ -4683,11 +4702,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
 	int reserve_flags;
 
 	if (unlikely(nofail)) {
-		/*
-		 * We most definitely don't want callers attempting to
-		 * allocate greater than order-1 page units with __GFP_NOFAIL.
-		 */
-		WARN_ON_ONCE(order > 1);
+		check_nofail_max_order(order);
 		/*
 		 * Also we don't support __GFP_NOFAIL without __GFP_DIRECT_RECLAIM,
 		 * otherwise, we may result in lockup.
-- 
2.46.1


