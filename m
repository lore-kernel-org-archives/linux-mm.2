Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDD8BCAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:31:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 311BB8E0019; Mon,  8 Sep 2025 08:31:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29C0A8E0003; Mon,  8 Sep 2025 08:31:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 163E78E0019; Mon,  8 Sep 2025 08:31:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EF48F8E0003
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:31:39 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B99FF1D95D5
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:31:39 +0000 (UTC)
X-FDA: 83866019118.13.A125518
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 0680820005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:31:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OXRcGzi5;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757334698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lKA8CeH1Jf9s6GMGryOJofCBa7AiapRIomxST1vM7SM=;
	b=PFFYETo8xG+71LN5PQoRm9/3BPAc7dq0IYoCRWSbm6mEwmVcdm74gGGnECO+SlYlkDkX8f
	Iokrxj8KcWr6VW6sQzuRKtrBE9IrgAbYdZAAKYswEy6PfipiyFdU52qHbkxrO4S3s6p6a+
	ccfPbLpHKiX/qgIn5Oa5BWegna9u+f4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OXRcGzi5;
	spf=pass (imf03.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757334698; a=rsa-sha256;
	cv=none;
	b=zoPpQzsMKQxevDJyko4XWyvhvDgK/OGXgK5CgawHOLXhOHePy2Axq/B2iFKqufc5e1/C2x
	CK96P7ZRnWYgktmKvU1TNfRfMuFVNEhkuEsDkNP19KDDP4XVJItUU7xFPX3ZVrzfBi8J45
	yat2HJZjIMXhzd9XnsKNqspeqlWVsfw=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-24c7848519bso44130565ad.1
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 05:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757334697; x=1757939497; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=lKA8CeH1Jf9s6GMGryOJofCBa7AiapRIomxST1vM7SM=;
        b=OXRcGzi5fpDCj00tNwpBJxXjrRoDMv5lGL4Za6agKFBPiWKv0aEli+8xWw00vxU8x/
         lZYU7VqggPcyaFhV1tj681kj4hDwxfUzmTM7DG8DcUBXh97/nbXGFW8xehOzQ4zjngHk
         i9sQ6HSox8KwDxzxagWmDAihAF+jd5KfkMcmDusD+oWk4cRueeSEG8duYYRdUBjrKmZH
         oy3uuYdlJvUTSui0ZVERVpFT80mGwtCDO7Fipa7rWOkIZaq1SBKDlud80FpXhCO/2kz/
         4WtDD3T+cQYNbGlCV/MpBxF+2bV/N1qtfDognec5NDCp+3m9v5QYy9hdFz92FwxIqrf3
         IwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757334697; x=1757939497;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lKA8CeH1Jf9s6GMGryOJofCBa7AiapRIomxST1vM7SM=;
        b=D7AtcrDnRHR4bkhwj0X8a+AfCaQlU2qYcYja2m2egJKZfJP0e/EBAj2NvvDK4OsUMn
         r545r4j2ypJlOVe5RLjpAeFGNK3RJ2G8nkqsK92xWwm3getfzt4PiaoieMgx+jywEMj1
         ALuQjKhLYTjpNQkPkoIi60ztrpeVeLCqJBn8D1mTkgIjhqJZ/ZMjWRnWoF7cVF+TcSav
         3FKeIh4scbHo6a5Q6JUZOZWy9zyyOIxswZMFhAv8jjEJdj3Vb6YGLVi+DYCX+6QEcmnN
         Qu8YXMdJz2/FqmUAI7eDLlhbWGvakVGtP3SYyC+A2nDGiXUXq2pAfGoAuuMy0iTi7ovp
         8FJA==
X-Gm-Message-State: AOJu0YwF5cts70pkJ5DwK9idWx2Uwf+qj0YYp7SajoaDx+htRpdNVNqZ
	Pb0YkAY8S8vUvWJMeYNHOek0m/mpj6zXYhgXLmRYQn25mIWSDNTETbCW
X-Gm-Gg: ASbGncvsFYYuQ/zauBpzjwA8Op0K2csB+cZgacpZXb40rruyHpCzwIXhVTpNi6IQ5m7
	9fClGlZTasY6bqr//dEuGzvkh/4DArLfX7kWL4xF4Gt/pIuKWH8U8F/j7u657Hky3d+yxdiLA9u
	cPb9pCOplbRjvKqmMuJ4bqLKAa8Zm9AuGam3/DqT7NGL+P0iKhQ6mPebIZTohq7zTllVQ3GyMdW
	pHSHNkkDp+iai7zS7PkQmDi/I0sCcW4Ikuj/YnToZmBgxcTLhzdhMJxSL+VpgCkk6wvEyKNFWaB
	lbVL5BRylOyag21dOb1E1ogb8ZHgDbcQjEG3GwurD8Ygup5RwMf+EeCx+F0rYpZwtOqNfIfuELy
	TxBVvhFY7jLQ7cEcF4vXT8K97bXZZESHLk3Pr
X-Google-Smtp-Source: AGHT+IGqbl9K/vxumxwyrMQMiImYe1FTUxMy6YSu8nnGoC0kccw1+3rbsfuMZVqUmMYoE1fzMKt/8g==
X-Received: by 2002:a17:902:dad0:b0:24c:e3bf:b469 with SMTP id d9443c01a7336-2516fbdb555mr127178775ad.15.1757334696591;
        Mon, 08 Sep 2025 05:31:36 -0700 (PDT)
Received: from localhost.localdomain ([180.121.125.237])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-24c9e3909cesm136315815ad.70.2025.09.08.05.31.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Sep 2025 05:31:36 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: hughd@google.com,
	baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org,
	da.gomez@samsung.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH] mm: shmem: fix too little space for tmpfs only fallback 4KB
Date: Mon,  8 Sep 2025 20:31:28 +0800
Message-ID: <20250908123128.900254-1-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0680820005
X-Stat-Signature: ynbz7nw4o36s16ofuwbfihox1rkyff3t
X-Rspam-User: 
X-HE-Tag: 1757334697-612906
X-HE-Meta: U2FsdGVkX18DyAa0xLBdQuvM+adoiGm6otiJOnsrojexBuQMTmLNAGZyABdmsJ5txjBoRw6DHblf2OHpE6+PMNgt6wuXWEWKr64D0a4upDV6GS2oZtMtR5mk/o744eaIQ0olxUoWyCRA/TioQk+3DuyKad0MA5X23O8Dd3NY5/4yqIjUlZDjkmZbHmB3ZgOoMSbaklTc8xSCjtDSehC3iEWEDYhtLZ/ERPp0Y6XLs5PDwbWXcZJ6TKufaP7DACQ6V6qPwUU6Zqxc3XmCt5/GsJdYitc/NEx+LnMLGtUEb0jN85kerf5yyYhFray9bpH9saoep8ac5PH1ULPnp6+SdrfmNyhmuU8+kaNy8kDJmE7tGw8sDMXIDrSKe17cDCUP+0UJjT3XX/L6wOFxzV264IxllPO5FxgIPiDIT8aNmRSvEzLaevdkgWnZhSeHQ4ihsIaKqTn+eo5nQQ5jmtMvwG48Usg7MJtebsJ+Z4RqbE0uOmxbfDr0Zh1bb4wNdIN1cFsf49fujP1UgrJx2rxkWs/ym5vjLgWEi0ijiQQgtzuh2Jqv0lE+1Y+UuP7cJWk1FOM22JHDyhPfrCL4GD4IcCt2GdxNlaK3pUYpw6h7j5snoI+pgN7UBNNdsjW50spEoc4lSLivbNrkSJQb0KT7JBJWDI7jx/Y370IqS8Se1WNe2YURxHySM6WVCYgRNF9u9w5pv/G26v9fUCvuI4cc/c6Mhd6ln/G/y3/zMvrsE6Vc5lumSDzGAvaqjfjZCOr5/36kBckjS5dde+62xIpY+/8C/3Zj/cMZygRnj44JRGAw9S5G0o9LPy7WI8a2KG2bBC7wQqOwICiXegYobB6JcpVeOT1o/ofybXX/SmTXiKK0zOyQpq0nsCCiun67EQkvV9g7rUrA6MHVqA1d8pzTT4QcawRTXOQtIqQqFyCOU0N8Gtuz48fGCoRY3iMOpJi77yVI9KWWIthfxvgHGeT
 V9w6QES6
 k2bq/z6YYSEWrAA6gfpdV7aT2ubf63MyT7OIZ4muQXGc+liT2FsoL/U1wv6Ypg14XdKD3E3yX+tqygrV+uNLhSKtMVc0KGEMC4wYfswEWpSp2M+QHEBLyZhFvMBHy8Q9Lt35jQNTUy/gBT86bjpSXNo4gitkblcA6hj3ENgJlkDwQtfBATWcOQpSdxUSHgx0SWXdirmcQlocHPw1DMMcIlS9CiB0DToJ9GBtCiGSnWzYHhEKnBoqaA6PwFZVO8+uDS0lkGA7MViX8Zbwxh+g9UPg6atVAAhjHEX6pLFPMWXtD3s2IOyfTaoPKYk6MYeRMSIwt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

When the system memory is sufficient, allocating memory is always
successful, but when tmpfs size is low (e.g. 1MB), it falls back
directly from 2MB to 4KB, and other small granularity (8KB ~ 1024KB)
will not be tried.

Therefore add check whether the remaining space of tmpfs is sufficient
for allocation. If there is too little space left, try smaller large
folio.

Fixes: acd7ccb284b8 ("mm: shmem: add large folio support for tmpfs")
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/shmem.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index 8c592c6db2a0..b20affd57b23 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1820,6 +1820,7 @@ static unsigned long shmem_suitable_orders(struct inode *inode, struct vm_fault
 					   unsigned long orders)
 {
 	struct vm_area_struct *vma = vmf ? vmf->vma : NULL;
+	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 	pgoff_t aligned_index;
 	unsigned long pages;
 	int order;
@@ -1835,6 +1836,18 @@ static unsigned long shmem_suitable_orders(struct inode *inode, struct vm_fault
 	while (orders) {
 		pages = 1UL << order;
 		aligned_index = round_down(index, pages);
+
+		/*
+		 * Check whether the remaining space of tmpfs is sufficient for
+		 * allocation. If there is too little space left, try smaller
+		 * large folio.
+		 */
+		if (sbinfo->max_blocks && percpu_counter_read(&sbinfo->used_blocks)
+						+ pages > sbinfo->max_blocks) {
+			order = next_order(&orders, order);
+			continue;
+		}
+
 		/*
 		 * Check for conflict before waiting on a huge allocation.
 		 * Conflict might be that a huge page has just been allocated
-- 
2.51.0


