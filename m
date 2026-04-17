Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA346F436B7
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 15:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDC876B0121; Fri, 17 Apr 2026 11:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3E4E6B0123; Fri, 17 Apr 2026 11:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C692F6B0124; Fri, 17 Apr 2026 11:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC0536B0121
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 11:46:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5EDEC57A4F
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:46:58 +0000 (UTC)
X-FDA: 84668476116.01.4BC50B2
Received: from mail-m82139.xmail.ntesmail.com (mail-m82139.xmail.ntesmail.com [156.224.82.139])
	by imf10.hostedemail.com (Postfix) with ESMTP id 22214C0011
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 15:46:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.139 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776440816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oPkrkSaS1T5GsefqN0Wdmkc9iy9v4Yv2QU8gru5IzWs=;
	b=kSAeh6AfhxQOkuBC+0Vz18IXF017xSDEZJjHf/vk1GoRXzUrab647EaqxfFSnZdzccGOhE
	nJ/wiiHXYepAucqiTTiIDj7/8znIYUqt9YJOBt+LyilbRjy7+NfcfqMswvEwPW1F3r7yza
	yIecB8hEN2MuGM1FxDH0lYma006UN3A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776440816; a=rsa-sha256;
	cv=none;
	b=iXYVOoxXfayEZTFHUqNeBK2o2Eba6s3oUIFe/MG4H7ewogerQ0R0lesTo/A93FSoyz/VNd
	y2BZgxr1YhsCqc6m/WRQAwizJIYJuYt52J3+7cKJdoRaSHZLyY5hzAmBqVKouLVL/PTtNS
	7ATMv6WX8hKLlNADGgQlfyUoWNB369E=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of zhen.ni@easystack.cn designates 156.224.82.139 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn;
	dmarc=pass (policy=none) header.from=easystack.cn
Received: from localhost.localdomain (unknown [IPV6:2409:8a20:ef7:a5b4:8810:8f74:8c26:2])
	by smtp.qiye.163.com (Hmail) with ESMTP id 190e229f6;
	Fri, 17 Apr 2026 23:46:50 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH 1/3] mm/page_owner: add filter infrastructure
Date: Fri, 17 Apr 2026 23:46:36 +0800
Message-Id: <20260417154638.22370-2-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260417154638.22370-1-zhen.ni@easystack.cn>
References: <20260417154638.22370-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9d9c1f9a3d0229kunm7c3615e318e59b
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVlCQktDVkodGRhNTU0dTEtLTFYVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJT0tCQUMaSUtBHh1MQRpOGU9BQ0NKS0FDHUxPQUMYSU1BSVlXWRYaDx
	IVHRRZQVlPS0hVSktJT09PSFVKS0tVSkJLS1kG
X-Stat-Signature: n35ywo8wprumdbob68o3n5b1h174jkpc
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 22214C0011
X-Rspam-User: 
X-HE-Tag: 1776440815-682638
X-HE-Meta: U2FsdGVkX1+Mst3ATkaIvv+4WvQr2n4k6bYOly5YFAXQZDONz7gRt47eJKZOCWfN/uXG8seSTIrAbVr6EkZ+PTSS2hoTTjGUGo8trnEIFnR2sQRj1R8q+LC/w8pssvuFZZMUmwD1KXR14kLTPSJ3Q8pj8d6Nsr8VMupCNRr/koLJnILl9gbti1H91CMlQbXKP1uXqL1iLXzR56sXkglHt4rB4s7RE01ZzdQZvcv+lsldTRhRPKkc1kkI68EAX/xaog+ywIEbhmMA+gZX5XO8CJ5a/wOZe4L9IURH73+kMUCXrAMII9yZESwePU5lGHn5if2WzBzuWFM4nq10HT9gxeaaVxa8xXU/hWWcC4NA4vWhMaMBmKnPzetvYYz+Z7c9/vtTmZoYGrC0Hp7NxJ+DGCEB+8ZDKQ867R5QzKtqqa0x82uQlWhUNadW4274xJEnZGKjflsIou0G2GQlnif8E+2f5vlgiZHAuTkEsizyxg3IAywhiF1G5YKBv8Cn5SQx6i17hcDSknfcVFNOy1g07sG8nHKB8cCSai3TfHTvtM4EoeHoW+OqgjhclPCIG9s9RYlXP5xjMCA0nQUyH60xtiv0sNrtyQT2dxwzadKAo1UANY8VLIQYHi1yql8sG6Hx6Rida9ESu0OWIkahu0UcrRXGjEPI7GgGz6rYjpAe2kV+0TLvxd/bRxAGAjrGL8P/TyEdmS2lUxqaV3QOOBupFyXN9RpALxZfMM4Azh6sI2k+3uBXTl59O7SfIiKuCRssvbw8jIHX0lisPnIBqP/MZl2/VYdUotYC+C84nBj0v9HvF3Hzp6rSXQq5iqB2w9B6tKZH8Iax/A44kyw+Kji+Na57Me1Kf/pt3XIKHHcUph4xwLlmT1yCA64gU7+BjXFaZLRa11sRdTjqRyW1uQeTF27cLVXNyZFjiusw+gjF1YkNIYiiI+qJJLT1GvpG5SeHmKPHgJRDIJ8RDXtDIXt
 ImaNMY1Z
 iI5wC0pSfLc16Zih0YMft1dGe6vvN9CRygR2hHFNTvG3oEfSMpR5N+D3BmRXGSgpRFYO9vf9EiDQCJJqxPb+Qe0jcD2ljnmQY36a5uOURIZhppaEd50a/C5G2aAVzqDW7ymif+xsojdz5wCEYrPYeIIOpZdWmNBlIeEiKaysKPskeXYU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add data structure for page_owner filtering functionality and create
debugfs directory for filter controls.

This adds:
- struct page_owner_filter with compact and nid fields
- Static owner_filter instance initialized with default values
- page_owner_filter debugfs directory

The filter infrastructure will be used to add compact mode and NUMA node
filtering capabilities in subsequent commits.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 mm/page_owner.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 8178e0be557f..6811439bf9e4 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -54,6 +54,16 @@ struct stack_print_ctx {
 	u8 flags;
 };
 
+struct page_owner_filter {
+	bool compact;
+	int nid;
+};
+
+static struct page_owner_filter owner_filter = {
+	.compact = false,
+	.nid = -1,
+};
+
 static bool page_owner_enabled __initdata;
 DEFINE_STATIC_KEY_FALSE(page_owner_inited);
 
@@ -973,7 +983,7 @@ DEFINE_SIMPLE_ATTRIBUTE(page_owner_threshold_fops, &page_owner_threshold_get,
 
 static int __init pageowner_init(void)
 {
-	struct dentry *dir;
+	struct dentry *dir, *filter_dir;
 
 	if (!static_branch_unlikely(&page_owner_inited)) {
 		pr_info("page_owner is disabled\n");
@@ -981,6 +991,9 @@ static int __init pageowner_init(void)
 	}
 
 	debugfs_create_file("page_owner", 0400, NULL, NULL, &page_owner_fops);
+
+	filter_dir = debugfs_create_dir("page_owner_filter", NULL);
+
 	dir = debugfs_create_dir("page_owner_stacks", NULL);
 	debugfs_create_file("show_stacks", 0400, dir,
 			    (void *)(STACK_PRINT_FLAG_STACK |
-- 
2.20.1


