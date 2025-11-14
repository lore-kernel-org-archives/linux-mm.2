Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27A65CD98F7
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 00:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749B78E000E; Thu, 13 Nov 2025 19:46:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721928E0002; Thu, 13 Nov 2025 19:46:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65ECF8E000E; Thu, 13 Nov 2025 19:46:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 535A98E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:46:47 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B44E013665C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:46:46 +0000 (UTC)
X-FDA: 84107372412.06.D482DB4
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf27.hostedemail.com (Postfix) with ESMTP id F1B1D40009
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 00:46:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LQbrXt32;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763081205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=as6UwWBbq9lK8qvRYSOLDFF98BPC/QmrT66bi070wN0=;
	b=wVqJ1HvQxPqZl8/jyZGgLWVaTKGK4Mkhrne5XhI0LWuPMATfF22f4xCRvN0l+064d8BXkZ
	Y+eCMuJeUJTOkQpRREXxczm8UZgiu3kPRFh/YBSAaTdhjsTUxuOvIjh/xjx1mLpDAe9M4Z
	d9qqfrizT/gNE8Q7Kj4I+qxSR2sge7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763081205; a=rsa-sha256;
	cv=none;
	b=nhP1jWwXjlFxaLHnA0bESrePA0TBUL7cMRqcg4dgpPiBXsQsNvd7SUzYoUatn8kqBLq6mr
	JvC1LbsagmCjjVkFGVzlqDhAolMw09rC5BwlPT02bwCrPVtiyLtEpaicVbgjt4xgZYyDyo
	wY69sD6RjxhP7ivbM26pu9l2acl6LU8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LQbrXt32;
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1763081200; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=as6UwWBbq9lK8qvRYSOLDFF98BPC/QmrT66bi070wN0=;
	b=LQbrXt32aypQUAFU6bVJxtap8NuOVlyCYn1WL//AYGm3C7sIi4x1/7egTbz0I96vHN7QgXTbFaFxFey8GBH+nI7SxuA9VUpFJcivieE3LhE/HRRUmbrWrAjQZqwsJGWwzbgNogiHOTO3yA7AmiB/akwKXAyNupLUgNEMab0F6mI=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WsL3Luj_1763081198 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 14 Nov 2025 08:46:39 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com
Cc: david@redhat.com,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: shmem: allow fallback to smaller large orders for tmpfs mmap() access
Date: Fri, 14 Nov 2025 08:46:32 +0800
Message-ID: <283a0bdfd6ac7aa334a491422bcae70919c572bd.1763008453.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uqdtc8mnp7j4nksipk5co4mgf1zo5dzx
X-Rspam-User: 
X-Rspamd-Queue-Id: F1B1D40009
X-Rspamd-Server: rspam01
X-HE-Tag: 1763081203-861192
X-HE-Meta: U2FsdGVkX198PnVC3pmiZII/50hhBTKBCpVjXVcQbjZ2OBRSAGEcoLOEU5OcfXJ8Wket3hUC3Pe66vw1vokdmK+85KKGx1D9w1Wh8S4zMSiQ5ssPRigLW2rnwe3VIfFMTzNGtcLdwQ0cCZ3SWnkT+mcgfEOZ4DDz5mE4rx2FuRFsgAC2MRiVf8NHo5znlOnNdOBzS+X54lrMP2YqO8Ad0aIHKcl/Wy7kChahvZQ3hzHk35zEJg51f9v8OI/6Gwixs96VPxXh3EKW3SgZOjG457BB/Dnz0uHkHlnf/Py3/ahyERFWuPR8XuJyHw8r0bhYjy4yMPRfg72vtUPJzimMUs8P/aCAOraSUqiqQJujcjYUa8EPv5FEA/JhAp8nbbGJbXH5cAp/Sr4aYMgBkUh8Vs0ruLTuJM0P1blSoDDoFpwO0owABz5xe9w7zasWrbowP8yOZPvw7wxxVLGvdI2VFnzq8gyefSqf0/JSqU+ssyhvmaxALt9v1YPviv3rDvda8nDlmDchNGQlVEPv2BdIiRk6K3nusBj1J7idcPLqRNHq24vlv9+6lA+RPVNwTizW0stxK9qPDcqYfxDAJL+N3A0JNIyoFcQlp8ZBOYdbiMmUxx/sGJn4RR0x+gTFXjba4lhPdAcxKShrYZ1diLCxZitbH6vzCOB1jLmLEV6/khRpnhe/cqjX9uHoOQVfKlog4vt8g8hDczusp3a3EhJeOKiDFRpWbNRxv35arUi4fPF4UceW0C2aZZdKoCFv8Mw7xGYSwc7ib1/QQ8s16pPviqD0QNJwx/MSNJAFQLLbTaWlu2HJwT0fYQHdLCVNYMDMMiYhbbLvZ+998AY9gpx3ATvI5pBMsGwqTs01L8ShVrDpLdJ3kFvazqKXcafXVi14M2ZdhSaPR8NdAYXKibuEDna/C0S8NQJe4GdK8ib1y/cU4Gu1abMBwSv6JY+o2HNs9dcOK1viR9tHmNX0nAj
 /O9xxhW6
 9TLPLSPaJZLK50teBSEWbqSMp8vLHWFNLlIdwflRoME+VHua9PtR1JYeaXgSutQJxY7xJzamoaGHiVbPkDyIRe3faYWkbEW8lsU9k7whJB4A20MhWAYlZH3EQf9djaI8kket3B+tDT8PzTlDw8wsnyj71ZsFCujY/JmV/YdlUCvEcI5sFNyQbbW5FftWjlwWppScWXA/HZjdTbaKeqourR8jCaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

After commit 69e0a3b49003 ("mm: shmem: fix the strategy for the tmpfs 'huge='
options"), we have fixed the large order allocation strategy for tmpfs, which
always tries PMD-sized large folios first, and if that fails, falls back to
smaller large folios. For tmpfs large folio allocation via mmap(), we should
maintain the same strategy as well. Let's unify the large order allocation
strategy for tmpfs.

There is no functional change for large folio allocation of anonymous shmem.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/shmem.c | 17 +++--------------
 1 file changed, 3 insertions(+), 14 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 395ca58ac4a5..fc835b3e4914 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -645,34 +645,23 @@ static unsigned int shmem_huge_global_enabled(struct inode *inode, pgoff_t index
 	 * the mTHP interface, so we still use PMD-sized huge order to
 	 * check whether global control is enabled.
 	 *
-	 * For tmpfs mmap()'s huge order, we still use PMD-sized order to
-	 * allocate huge pages due to lack of a write size hint.
-	 *
 	 * For tmpfs with 'huge=always' or 'huge=within_size' mount option,
 	 * we will always try PMD-sized order first. If that failed, it will
 	 * fall back to small large folios.
 	 */
 	switch (SHMEM_SB(inode->i_sb)->huge) {
 	case SHMEM_HUGE_ALWAYS:
-		if (vma)
-			return maybe_pmd_order;
-
 		return THP_ORDERS_ALL_FILE_DEFAULT;
 	case SHMEM_HUGE_WITHIN_SIZE:
-		if (vma)
-			within_size_orders = maybe_pmd_order;
-		else
-			within_size_orders = THP_ORDERS_ALL_FILE_DEFAULT;
-
-		within_size_orders = shmem_get_orders_within_size(inode, within_size_orders,
-								  index, write_end);
+		within_size_orders = shmem_get_orders_within_size(inode,
+				THP_ORDERS_ALL_FILE_DEFAULT, index, write_end);
 		if (within_size_orders > 0)
 			return within_size_orders;
 
 		fallthrough;
 	case SHMEM_HUGE_ADVISE:
 		if (vm_flags & VM_HUGEPAGE)
-			return maybe_pmd_order;
+			return THP_ORDERS_ALL_FILE_DEFAULT;
 		fallthrough;
 	default:
 		return 0;
-- 
2.43.7


