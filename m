Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E70CAC55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 05:55:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE9846B007B; Thu,  6 Aug 2026 01:55:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0EF6B0095; Thu,  6 Aug 2026 01:55:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFEB46B0096; Thu,  6 Aug 2026 01:55:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A247A6B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:55:24 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 92CC4C0650
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:55:23 +0000 (UTC)
X-FDA: 85069782126.30.EC64725
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1F29118000C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:55:20 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Dy6GOQcG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785995721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dGhdRgIgIMHfR7vy1rI13brOXOjVKrzvUJgGFI1i9XI=;
	b=Dr2RCGtdo9j3xY/Ljz5vl9rIoUBuJfsEcxfZBVHocREJvZlrjQYpGE2+o4CWHQChAOEkeF
	39DWlF4zdZ4xCh8xhwph0ltmQ3rQw2HRf1vc0hp0AJLbjnU9h99bBL/zUlYCZmBQPKCkH6
	7zXcOIyNaIusbxDSEr5PaDTf+tmPtLA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Dy6GOQcG;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf24.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785995721;
	b=S09SnEvSF35SkMI2RpopQMrYsH7k6wnwu4whGhywfndIy5Y2oTqCoZzoNcFLVxmrAt9PKC
	wHf/n5R2T85HDt1/CXJIy90hKtSutxJWPhG6bea/Xtb3LDflaFBfu/yR89raBLMcIu9Gtr
	qSvaIOtPDTFYvEUW9mYExMWF8AjVjEQ=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-ca766c1c9ccso1420628a12.0
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 22:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1785995720; x=1786600520; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dGhdRgIgIMHfR7vy1rI13brOXOjVKrzvUJgGFI1i9XI=;
        b=Dy6GOQcGOEyXfpC11HCMgN9N/vPu/CMUL+1UmbP5PCS1JIzDQsEk6f7/0KYR0zk3Jh
         isA1Zgu9KH7n3L2vkvrMgYthgGWR6eZzJR01VWW33CPyGPDxuegWPXPQIfp2FW51j0Ug
         7VxUm42kCQyFh3IPKjH6JZBUnUhFYDIP+nM6yHJYssY4Bu9g/izLsl62YsyT+WHIQAOo
         Lwh3ZtnQu2CqRW1eFX8uZ0KhYOt7YL6oRSZBO1Yw+0Rsd6/fMvhWpjH9v7ap2CRMK++x
         9T1NSXYw0Ep31V1Dt30n2PGfdUPm43dxW4B8wz3/Qp4sCeOYaSGUYslar9fxorjVoSSS
         m0qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785995720; x=1786600520;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dGhdRgIgIMHfR7vy1rI13brOXOjVKrzvUJgGFI1i9XI=;
        b=AHqoJ1+BE9nTT26f54EhRBELsyNXXXux+MtAsVdwKCHUI40bm5HzIA+8qsTV4atcWi
         FH4VznswQw1wm5jiESbd72L6byE7FKRYdBImUL9dJ+PY66XEVJsNXjuiEh3viMLFnRIT
         2hneAtX3QkJiInZtT5uA65gsqQtL3rIfQHnwo98kTzlDXw7aKtrQSHnlLA+6tCaTK9tU
         sC0nrqSW2DOEtpGGh505tekZakpZcwypekzDKXJj9QSUcvrVa1s8D49GRvLuzc8CQJ6O
         TfD6Wi6G7NII7/TphUCwGAVa+LSLRmNBAzUuetlz3HGfxIhE3EZ/aM8kEOwwpPuReu6g
         s0tQ==
X-Forwarded-Encrypted: i=1; AHgh+RrbNu7wF7DxEKORVlN8I4cqgEk0um6WBl0kbjBCxgTnG25aDokbl8ylb91Fy/okdAdMZa6GMeJpKA==@kvack.org
X-Gm-Message-State: AOJu0Yyi+PcFwbkqMGLNGlRED8wmlE3v5ZEv3RirjnWfYqYkPpv2VEX+
	QDwi+MSwwZ4qU0HByXwwKWXnQ+4FWoopN+KqcoiZYTJwIEiua/uOhK8MK9p2BsBsJ1o=
X-Gm-Gg: AR+sD129TxzqAPisxm5OVR88UO+9f8SMxYvBA0qIQoPVTXu3DaoVX8/ioFJzr1lL66j
	lI0se50J0rbw2tyYdKs5gWmnroemwcWPwK5QGh4OvACkck9uzQU+YF+L8vyyAjXltmNnH0E3vF5
	KyD5wc1iVg8eMfTnYiHTHjTtHYTqp8SeVBpGoMM4/R0Z7eMf0YjgGQRp03CPrs9EMZUPzFuo1XD
	0NXidKhARn5BONO86CAFon6/RQpavcNrerYysbELC9ohT6q08N0ntk2wIj/4Id7VuUPFoIdR640
	FuOrG7CNY0sjt7odQmTbvjkiKCG3mM9WnGO3lb3895dVJG8CKzU/V1U1rtS7O3hZSfqtQgWbO6E
	zaRZBM8NVnlQHfmGlH67hv5XgOTkS+img4K8knEy15CAVoyU/GJUu03vUjL+oAU7bNLZbVX3WIN
	uJg8cx9drykc/v/C2KPCnxf5VMqIRlrtmI78mRzS/GnS0rn+S0gUygve5d2Lydkw9THgo+MluWE
	Fr8DWNFZdYl0KBv7Wa0ChrllEvWjnQkAI1YJg==
X-Received: by 2002:a05:6a20:43a9:b0:3c3:8651:b302 with SMTP id adf61e73a8af0-3cb85f60443mr15100884637.28.1785995719569;
        Wed, 05 Aug 2026 22:55:19 -0700 (PDT)
Received: from FR9WL0RHKY.bytedance.net ([139.177.225.225])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3158644a195sm21906471eec.13.2026.08.05.22.55.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 05 Aug 2026 22:55:19 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	00moses.alexander00@gmail.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Yunhui Cui <cuiyunhui@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/madvise: avoid skipping pages after splitting large folios
Date: Thu,  6 Aug 2026 13:55:01 +0800
Message-Id: <20260806055501.56761-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: ozkgxcua7qyrddbe8fc6je4bpowzk8pt
X-Rspamd-Queue-Id: 1F29118000C
X-HE-Tag: 1785995720-968462
X-HE-Meta: U2FsdGVkX1+w6oXVJbIiOqGvVZ3skf0J/t/W0iKfvniQRrXI10W/D91T6VPUtD0hhWrHxMHbzrfRoTiKxq/Qq/AJAmqXL+fw2k58nAI3lpdv+/ZhZJ4na03pNunOCSr739ygOwY8dWYn32CTeO5MlBGPVNE+U6jR1pJcIcHOr2/ctCTEMwFvJaHrP7pXTqnY6mZNwNKjwKnZCw48MvKUnDYpHLeq+Z79FPaBkS+CJVQmjMUe+vL0/5X0EHkpdraC2UgqDoOGqUt0Pj+oDDDy1dyFLaSSa4tfDTZx+D54veJs0nSHfQKLirFAf3FsoCTzqL9HLTMRGS/41rDnIXdE1XFQRmwgScPyZbe5ee8TVWg2ChTQ4qM45YlV0DB0mzAq+ChF5PNtTPdeZASp+HslsP1kQIaPNtEGyBhe+n7hzJVc4ejGCu/tilDuCROvcmrysx/iI/sCjB4QWZcqk0GuybFCVMJ2dcmR54zavV0VnIicMmHb2lffAhSytNtw9j34mIkEyc1gP7lhRuor/eSQHIb2gfKwuS6uyp9aMABMDb1FD3X7go7xHm/OeNFN5N9xJXbLCTXDfTqcGxtZ/rKSvD5qTs2YWeG4dN0FyCN4MyKg0CFZVk1Yn0ARkEmMtGkWShoALSv/o/ZwtN8hw4CtNrEaMRiO1NfuXvKx5J93M6l6T/0gLcECWq67DP2uNJdQupj85pQsQRkHSaEFREUlhM8KMbTOYlJV/e4A/VWi9MrezuIvY5xD9QR6Q8UepXhVY3XBn1AkJUpUr4ypa9f33t38IgsXRTj5P9mJ1C/V5ZBQT6cGZ1QjDdaUd6hni1ks5Gs9EV8m5+baxQwTGejmNk9NNZTs8GWAPOEHUVWO2nurmQ4uNLuZ/ZBkHlcxFRRKm6ZWayt3FYTyYFs/9cc4QUXImO0+do8iFs8GRzt+Yq0bayT+GFUDj07qxBQkWchqMjV6TbWrn2U4MxTzJ9R
 g6iUOoTd
 uF5pNy+jy+vm51yfXDoGRbEPjO7PWCXaRK6pT/sJaS/Vws1wNgP28i9FvpKQymlLvyZ4DgPvtLzIMYJfzdlyjbOwMg/LfeudsAPL0lDNl19kTOyoYk+QMktArmspiZASREKel5HmdCQONBZepZKgjWRVIJxosxuSXkn42BMN4wHhOjagruDOZb4bGjzfhlZlKd0NgGpdZA8dCErVC5yiMxlMSYX7ilU1NZAL45I+GkYCeQMmJmzhwLNTksZzvImlnlWEbseuRVz3LcegU/fktFbqdB8LEwNL7ljUxo2ztIxsL+PyfQTXYAfnBtB32FqzXsrxVQ9/JjYRNih5A3+v2MPsdVHKDO110+9KcMK6AvuCTXmqsVvdpepQzlS/ZAHV7oY2qXHmUyrc/qBrEqokaj5oxgD1upSafk1km
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_inject_error() advances through the requested range using the
size of the page returned by get_user_pages_fast(). Saving the size
before error injection is required for hugetlb pages because successful
soft offlining can dissolve the source huge page.

That stride is incorrect for non-hugetlb large folios in system memory.
The memory failure handlers split such a folio and handle only the base
page for the supplied PFN. Advancing by the pre-split folio size then
skips the remaining pages in the requested range while madvise() still
reports success.

Advance by PAGE_SIZE for non-hugetlb folios in system memory. Retain
folio_size() for hugetlb and ZONE_DEVICE folios, as compound Device DAX
folios are handled as a whole.

Fixes: 19bfbe22f59a ("mm, hugetlb, soft_offline: save compound page order before page migration")
Cc: stable@vger.kernel.org
Signed-off-by: Yunhui Cui <cuiyunhui@bytedance.com>
---
 mm/madvise.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 5a09cc24f04a0..e9d4c3bbc5290 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1455,20 +1455,25 @@ static int madvise_inject_error(struct madvise_behavior *madv_behavior)
 
 	for (; start < end; start += size) {
 		unsigned long pfn;
+		struct folio *folio;
 		struct page *page;
 		int ret;
 
 		ret = get_user_pages_fast(start, 1, 0, &page);
 		if (ret != 1)
 			return ret;
+		folio = page_folio(page);
 		pfn = page_to_pfn(page);
 
 		/*
-		 * When soft offlining hugepages, after migrating the page
-		 * we dissolve it, therefore in the second loop "page" will
-		 * no longer be a compound page.
+		 * Non-hugetlb large folios in system memory are split and only
+		 * the addressed base page is handled. Hugetlb folios may be
+		 * dissolved and ZONE_DEVICE folios may be handled as a whole,
+		 * so save their size before error injection.
 		 */
-		size = page_size(compound_head(page));
+		size = PAGE_SIZE;
+		if (folio_test_hugetlb(folio) || folio_is_zone_device(folio))
+			size = folio_size(folio);
 
 		if (madv_behavior->behavior == MADV_SOFT_OFFLINE) {
 			pr_info("Soft offlining pfn %#lx at process virtual address %#lx\n",
-- 
2.39.5


