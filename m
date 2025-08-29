Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E29CA1001
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 23:40:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D458E000C; Fri, 29 Aug 2025 19:39:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19528E0001; Fri, 29 Aug 2025 19:39:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894D38E000C; Fri, 29 Aug 2025 19:39:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 67BCE8E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 19:39:59 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DD62119DDD
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:59 +0000 (UTC)
X-FDA: 83831415318.19.9343830
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 31BA440008
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 23:39:57 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aNjeScW9;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756510797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fgzqi0XWIhbNbxLZHOGh+9AkeMfa8I23tDcpLaOZWEA=;
	b=OLVfkUgPO3at8CtOMW0p0vdOIAf4OVdGwT5Bd2GfSlWhShWWkIhSwuInLgtm02sUhFHQ1t
	EtDIeYn/k0xwvtDoV3/ZN24arDNAi+4+H+OAer2LrAD8nXfp0vzepuarRR8qmMs3RH7m6W
	r94J8tTee1ggwnNSCJFOKxuCMD50jD8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=aNjeScW9;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756510797; a=rsa-sha256;
	cv=none;
	b=aRPFqmI+P0/NpwMNyxdzlqeMqZaPgttNcVH8ws/ub43coAuinNV8/JqrL2WkBIl8z74Muz
	0KO0EabtUYVbJTMyKGlSL69BNa0DC5B4dbjPvRAJWVUrpxdB4oTBs/ElUZIVGVcMZDdRv5
	8U6jzoAkqd3PCK63TB12ibZKIAyvzKU=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7720b23a49fso2967633b3a.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 16:39:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756510796; x=1757115596; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fgzqi0XWIhbNbxLZHOGh+9AkeMfa8I23tDcpLaOZWEA=;
        b=aNjeScW9mHJkqgEUEdBUNroc9qeo0wtfy5EUoYaNmfA749lhbljQJ/Dd0/uJBSRtcF
         uzJsAGlquQuoMVoDz4M9wnR0vOQanAhFHzQkpQC+6yXgQEGrVY+cWJotJURlgSDhx6Nw
         45Uzgj4l4nA0tk1JJgUeWqhE2W2iBHbVF01anAGMHmlvdQYEPeIw87f5eGey53BHhuDz
         6mz1GcxRCix62azq9APLuf3mb/oGOqmJy5MJVpGBUNi2Cao6o30X23BB2tA+jXXe/6mL
         TQjZZRa8FdAlts3Csjsui+Pjho5j5p+MhMfhHsLpvvP1rtKA6kFciQmx5j17o8qU82uV
         Xkvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756510796; x=1757115596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fgzqi0XWIhbNbxLZHOGh+9AkeMfa8I23tDcpLaOZWEA=;
        b=gyTycxWgAptypw4ghz5y04k2R4kFSqJobU10w4MZwmJKzjCLrgu/eW16rDZJf4ax/B
         jKl5aFBPfzve0qiIOSYgZQVeoSU1+IhHRL0zmeo4FC24XsE9OqoYc+Yjw4xVk7Eugxz7
         D110RxIkHkgAaL0Sss3hC78MF+HIJ/poUwl62NMSIB89rfnjYAexTAyIwrG4qDLfX/Bw
         eKoSMPEKkqRf5ZRtqJWNMKFfU0PiIv1gsQ9kvlvFdE8QxqMK23VAlZIrhT7dTdux23AD
         15Duj5NzgCvZMmtC5ARDAPxiLnLe/v9RUHvpmC5PtYY+5HdJq/MeznHaB/zHZwwXMNHX
         ba7w==
X-Gm-Message-State: AOJu0Yxku7hY3C3HBG06BUC1MgQOhiu0vI3Z+xjUOnlxOcwgO8D1DGyJ
	4eOh20uiHWrwZMmCrz3qAbualhbH0WDTRLi0JrwZCmNCDfqHRgYvsC+NpiJsFg==
X-Gm-Gg: ASbGncuyeew3UczOLdSsdZ6hi6QryldD06qRohZkv2q4UYe5VQVgNRAG7LxKzzYzqvB
	WxPh0gaPZ40HK8uYely6Y5xbEb5vHko516MECQVLZVjIZ151YpsJPisLQaspfh7WLjilmhN6u4o
	GzVnx9VOh8BjFrETnSGk/opyY7wqDv7d11IZUDTxK36eePLYfySCS8xQ1+RsYvVtL7plcKzntg0
	7S0xhf2yIR4rLALoaKdNJOMLUMGGllPVAXDczJMkzOgxjf4kKhqv1Mb4cLAkMHYXOcBUgHBRa8e
	SLsGIan7ELpec2UhdjoO/VBvRWOmUUpe11eTv7j4PTko2GvovlG9PQppwInSqGpbEsPeyTVDFIy
	mYKEoouCMz/x9/f2mxQ==
X-Google-Smtp-Source: AGHT+IG2yfv+4fw5qf3y8AXdHCC+mQ4DFzEwQ/Wp94S5UG+OdFL1J6XJ58uHN/rhdl/B2IeiHALL5g==
X-Received: by 2002:a05:6a20:394b:b0:243:25b0:2324 with SMTP id adf61e73a8af0-243d6f793b2mr491573637.50.1756510795887;
        Fri, 29 Aug 2025 16:39:55 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:13::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7722a26ac0esm3456962b3a.2.2025.08.29.16.39.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Aug 2025 16:39:55 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: linux-mm@kvack.org,
	brauner@kernel.org
Cc: willy@infradead.org,
	jack@suse.cz,
	hch@infradead.org,
	djwong@kernel.org,
	jlayton@kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 04/12] mm: pass number of pages dirtied to __folio_mark_dirty()
Date: Fri, 29 Aug 2025 16:39:34 -0700
Message-ID: <20250829233942.3607248-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250829233942.3607248-1-joannelkoong@gmail.com>
References: <20250829233942.3607248-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 31BA440008
X-Stat-Signature: 5ic4jyeocmmfskx883yz41u3az3fjdft
X-Rspam-User: 
X-HE-Tag: 1756510797-303848
X-HE-Meta: U2FsdGVkX1/15RFKQp1ZXUhRo+sqUZp0qHN6hr+9cS/WxsKg09NvGQ65mw4p607hp1lv99iOJfSCaF74W4mD2htQgCNxCq8O4dmJPTAxNDgXb1IPVfda9CETrKH9BLev16J0eYYPL8xNmNu9skUg6SwnPdbSj974q/VS9WmRFnYBejYupbxq9j2NofTJQeVnQ2UQdIXdVGNkEKvlVtNIoaKW0YogXrShztMc1s01nFIPm2ljID7EtyWSN1R27tftZDMwFm1aCa/TP2NB8yoAITugIYxpsDCFKdEXr48FnwT/Hmum9fkcIt1nPmFCf4Rjehtwoi2Vpsx5dv7szwTmJ42fjhc/F5F5y1v3LsuWJy/KXTtXrCjWGgynuOXzp5cQGT5sl3H8AKsSbe51lfTiGQ13Q9EYPbaKDmZoRL1sfyMQCAH7J4meo43vICpk8kcqvL0dkbZwF4xQveiBysNySBFR2PqrXbHdKTVHyzzdxFR59ujfQ3RBdUs1oMJ/Qd+JYuIqiFAqb9MUbQQbhrYpWnmC3VjMxAstYOfNQAICIITq/4va7C9JHqNHyiGdB1EUCsdwIN5JXcnZlJ68YkfdXbYwYPyjPuMdYX4LKrOySC4YGztPeZPXUCgisB+uAKRxKS/f5KlPrLdwx/3hHkrj4q8Gk/eg19FtQikumvPzOMzyO5wHfHA9yMfRJNn6qkTHtnArn+HH0QILaWhEjEaBLKwnX1eFXj8P4D7E7Zln0CAKlYHFoaWVc/3MZbBqk3lGRRWYBMHwUoBPa3sb26tFibDAqC/4uSivKgs9fmL+YvyObTvL7xcZgWwX/pRry9lkm2VmOal4SV76Qg3WcQiRg3OCbUFIoRY1HQhvtddSO6Jkyb+v8ZANCljJWb9ACziRJP0Ce0Edpy6YobPv12gTiGG0leym/m0j110rUxOv7S/uPlFgg4vCf+UIXl5b4iRwHrwaL4S5F1/ZbEvjFup
 mi4bd8xT
 DAmj0MsMxV2WRHA4Lkp9Vqo2cU0RhcdfhbUdhJRqWYV0gu7164KNFTMaHWmK8+ox0HO+xrjPZHAdPBmGOLK/Gt5HknccW1FLW1iFumoYDhY2LXgPisQ5SNUWH7WpbsX96Z7bfmZ5JJx8k3f+ugK+fhLFH1/4aDCCF0IDHtxq8Obq3p3FI8AX3hspC6Ckcs28F2vFKvRHiZoxFSpE4/BjwwBVxRvzvd2fbgnzYsQSo+SdF5pfhRoXdt85IbWnmCzo0cDSfzAopOQBbNd3dHkScS/i6/zOqiyjZJJIzDr43erPyOFa5fdtml8fJuvT2Y73JG9Ksxz2ZmBNraGjbm3HBpMXHh6HKwEfHsTaExxKBvfqPCv9oTjo73bjWQFwXNokaZLWV1yMtB3A95xnMGMby1CIixY/MWSsLbQi+n1m3LNhkAZ01MttgRJsweyFTMyPNKrkl71fuEt5hnlf1muWhFiQU9WlG18IpBSxayZB7S9z5ehf3MzZFZgDki/oz2DlPMQwV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an additional arg to __folio_mark_dirty() that takes in the number
of pages dirtied, so that this can be passed to folio_account_dirtied()
when it updates the stats.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 fs/buffer.c             |  6 ++++--
 include/linux/pagemap.h |  3 ++-
 mm/page-writeback.c     | 10 +++++-----
 3 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index 6a8752f7bbed..65c96c432800 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -751,7 +751,8 @@ bool block_dirty_folio(struct address_space *mapping, struct folio *folio)
 	spin_unlock(&mapping->i_private_lock);
 
 	if (newly_dirty)
-		__folio_mark_dirty(folio, mapping, 1);
+		__folio_mark_dirty(folio, mapping, 1,
+				   folio_nr_pages(folio));
 
 	if (newly_dirty)
 		__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
@@ -1203,7 +1204,8 @@ void mark_buffer_dirty(struct buffer_head *bh)
 		if (!folio_test_set_dirty(folio)) {
 			mapping = folio->mapping;
 			if (mapping)
-				__folio_mark_dirty(folio, mapping, 0);
+				__folio_mark_dirty(folio, mapping, 0,
+						   folio_nr_pages(folio));
 		}
 		if (mapping)
 			__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 362900730247..48745f8f6dfe 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1223,7 +1223,8 @@ void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_pages(struct folio *folio, long nr_pages);
 void folio_wait_stable(struct folio *folio);
-void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
+void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn,
+		long nr_pages);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
 void __folio_cancel_dirty(struct folio *folio);
 static inline void folio_cancel_dirty(struct folio *folio)
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 65002552458a..e66eef2d1584 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2675,7 +2675,7 @@ EXPORT_SYMBOL(noop_dirty_folio);
  * NOTE: This relies on being atomic wrt interrupts.
  */
 static void folio_account_dirtied(struct folio *folio,
-		struct address_space *mapping)
+		struct address_space *mapping, long nr)
 {
 	struct inode *inode = mapping->host;
 
@@ -2683,7 +2683,6 @@ static void folio_account_dirtied(struct folio *folio,
 
 	if (mapping_can_writeback(mapping)) {
 		struct bdi_writeback *wb;
-		long nr = folio_nr_pages(folio);
 
 		inode_attach_wb(inode, folio);
 		wb = inode_to_wb(inode);
@@ -2731,14 +2730,14 @@ void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb)
  * try_to_free_buffers() to fail.
  */
 void __folio_mark_dirty(struct folio *folio, struct address_space *mapping,
-			     int warn)
+			     int warn, long nr_pages)
 {
 	unsigned long flags;
 
 	xa_lock_irqsave(&mapping->i_pages, flags);
 	if (folio->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !folio_test_uptodate(folio));
-		folio_account_dirtied(folio, mapping);
+		folio_account_dirtied(folio, mapping, nr_pages);
 		__xa_set_mark(&mapping->i_pages, folio_index(folio),
 				PAGECACHE_TAG_DIRTY);
 	}
@@ -2769,7 +2768,8 @@ bool filemap_dirty_folio(struct address_space *mapping, struct folio *folio)
 	if (folio_test_set_dirty(folio))
 		return false;
 
-	__folio_mark_dirty(folio, mapping, !folio_test_private(folio));
+	__folio_mark_dirty(folio, mapping, !folio_test_private(folio),
+			folio_nr_pages(folio));
 
 	if (mapping->host) {
 		/* !PageAnon && !swapper_space */
-- 
2.47.3


