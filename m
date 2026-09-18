Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80E0CC982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 03:59:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF80A6B009F; Thu, 17 Sep 2026 23:59:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCEE86B00A0; Thu, 17 Sep 2026 23:59:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0BE86B00A1; Thu, 17 Sep 2026 23:59:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A893F6B009F
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:59:02 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D7D2160568
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:59:02 +0000 (UTC)
X-FDA: 85225527324.11.624FF4A
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0A42220002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 03:58:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KFcmzR5k;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=KFcmzR5k;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf13.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789703940;
	b=FZTTqHM9cKebHM+JTLTG9L3UPJ6IG/Ye+Dht/0Dd6mGQAudvqUQ1g7ktNH2MYz/jmuWRvF
	4wGca/coFLddf35XE9ryeaCAbtieIwALd51iFTUZMGOL7vwFNshuNXZovht93eljPdADTn
	fUrLbK7tiNJ3TJRjszkC8eMmTBsZ/rc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789703940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0x3dSjlUiTkXS7vb5onP0ckg+vTzpvO3+8JjOPhJO8M=;
	b=MyUZcuCd1l5NPhn+n7FSO+fYJDbvTuJLsycwpwAn42oeR+WSjVeKKEkKkpIY8Qs+sfUJ0/
	bp+uqXMt05XT+Bim8p//Do3a2I+v16VwgzHDEkfqoa08eDsBYkoMvhv0cAVqN4z8ylj0k5
	4tcmq5WGq34kOvrO8pLQyXlt2LLaEoQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1789703937; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=0x3dSjlUiTkXS7vb5onP0ckg+vTzpvO3+8JjOPhJO8M=;
	b=KFcmzR5kQpdstBc3Dq1M/4Qqp0umEOoxwgYuFSUbIQXQkbopP6NeCpzU8qCo8Jk4X1oUgastqj7onW0eTxkDjSgGehvB8pL5wG+dDMyUDr5Sp7I+I7QN/lW7EUOAKdpzLI2JiNwaNdTQ2PfTg4GKoOON4Kiz7umYRDTy5SF3XPQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0XB9o3cX_1789703935;
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XB9o3cX_1789703935 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 18 Sep 2026 11:58:55 +0800
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
Subject: [PATCH 10/12] mm: shmem: run khugepaged for all shmem mTHP orders
Date: Fri, 18 Sep 2026 11:58:41 +0800
Message-ID: <3dee70b589a0190e5e7b5c8b085a7e9da4b27f4a.1789701677.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
References: <cover.1789701677.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A42220002
X-Stat-Signature: myjzz385hmkq1tbz5qasdaug56ad7mtt
X-Rspamd-Server: rspam01
X-HE-Tag: 1789703939-69316
X-HE-Meta: U2FsdGVkX187FgliUUt0E4tEevVcsEHE2mgXlgcKc7EPOYflARLjojQKQssxTMSeGKWvywehPQJokSzst3JWsBlVRTcJNH7InBavmt5JCR3R1gU05zvIUEUSPG/PrVS+oWNxCdvoIMicxtwaZBu/vr6v7gqlNnxtlumw10EZSlxSXK3TmKsl7BYH4jEILrj/wDiPWxHyCjNhKKE9td8f/tunrBtbgN8OhHGzZ0KjViZ2KnQnX4s+TynMdXiXFV2avzNdjlVD6rOumo18CpE5UlNCi7ukA6yDKtmjTMAPrnO4hVQVldkRfLL3n4dO9geevuV9o/9mfWwdibKtyrzWWPJIGppHvHaAPGs2J3xqiGWmmWc/Nmb03vgQaLt2V105zzNgK+zgt6eBIA6oZzonshEI4fIZHp/8cW9rMkC4qo9MFDbPyGtxrgkKzc3W5/kHkNsoZMBM8L3ZaqFvi5CLf+huMn8kfYxfrLIRIKJ3kuEobe82b0xAOiODZGBpfFxvyJa0Fzsiz1EadTAx+Y87PMcqqc3WWpaKkHQeMMgMmv20fZems0bg0DG4Gy1x/HFx/cNq2toM6othQ76896jot7TJmgY2tGORuA7lgd5bXCMOIxtXx+ZP/Xs4GYjL3RnYUPWTLhUKlzZd+MkQDIIDOOOVfKoP3NlScBszf2OSJDcYG2qUPXiO2kzOOBerAQUwgNwQ0BpbLltxAHdoObOd7kon5lFyG0apt2Xm4iZA7KsRgP0JEbABS3VufMRKLxD3xKkPsi17/3ievOZBAurZ8G8dvML7QL5piYMwETBR0YT+OgiQIHTjqJfd5aRUER+PN/bi+UxzMQH9+oM0udGx4P8PE85+r6Lqk/aUHcLfANOibnDYHjL8JONa1UOjukgdOk0Qq5IIHtYcP/LmlQIylEhirzufXP4CCOpTM0eQMIO9/nAdE2NM0kkCydfrzam6AA4yjpm8lXYP5+3j+on
 YVaNeEh3
 z1ezP61TtQxzfM8lDDIwd5W69+n5tRmUrLZ/CidRgSuxD1uCTlvY6jxOSMG0L0hbhkjrUK2DSL+IqUMboIFF2Ad7RgnO2HKz8YFFftetbditQqMeivSq49bAO9Qw+d6k+QAkNvusPtOFui7jW/R08qc5QvA/DDqU+5GxWpHyIYj+EtceWJy7cDMnqtCXaloz1pps2ZG21DwQdR/6g5NDQyk1PxIJesviRV19AGtnpQaq/LilL58O62N3ereZuf1O4VPsc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When only non-PMD-sized mTHP is enabled (such as only 64K mTHP enabled),
we should also allow kicking khugepaged to attempt scanning and collapsing
64K shmem mTHP. Modify shmem_hpage_pmd_enabled() to support shmem mTHP
collapse, and while we are at it, rename it to make the function name
more clear.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 include/linux/shmem_fs.h |  4 ++--
 mm/khugepaged.c          |  2 +-
 mm/shmem.c               | 10 +++++-----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
index a7c7a96a7cbf..9f2036f58bb8 100644
--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -135,7 +135,7 @@ int shmem_unuse(unsigned int type);
 unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
 				loff_t write_end, bool shmem_huge_force);
-bool shmem_hpage_pmd_enabled(void);
+bool shmem_hpage_enabled(void);
 #else
 static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
 				struct vm_area_struct *vma, pgoff_t index,
@@ -144,7 +144,7 @@ static inline unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	return 0;
 }
 
-static inline bool shmem_hpage_pmd_enabled(void)
+static inline bool shmem_hpage_enabled(void)
 {
 	return false;
 }
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index dba747442461..5c477ea16c6f 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -447,7 +447,7 @@ static bool hugepage_enabled(void)
 		return true;
 	if (anon_hpage_enabled())
 		return true;
-	if (shmem_hpage_pmd_enabled())
+	if (shmem_hpage_enabled())
 		return true;
 	return false;
 }
diff --git a/mm/shmem.c b/mm/shmem.c
index 951e922091fe..6567bd4cdc07 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2018,17 +2018,17 @@ static struct folio *shmem_swapin_cluster(swp_entry_t swap, gfp_t gfp,
 }
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-bool shmem_hpage_pmd_enabled(void)
+bool shmem_hpage_enabled(void)
 {
 	if (shmem_huge == SHMEM_HUGE_DENY)
 		return false;
-	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_always))
+	if (READ_ONCE(huge_shmem_orders_always))
 		return true;
-	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_madvise))
+	if (READ_ONCE(huge_shmem_orders_madvise))
 		return true;
-	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_within_size))
+	if (READ_ONCE(huge_shmem_orders_within_size))
 		return true;
-	if (test_bit(HPAGE_PMD_ORDER, &huge_shmem_orders_inherit) &&
+	if (READ_ONCE(huge_shmem_orders_inherit) &&
 	    shmem_huge != SHMEM_HUGE_NEVER)
 		return true;
 
-- 
2.47.3


