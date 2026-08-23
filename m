Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB7B2C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 03:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F26E6B0092; Sat, 22 Aug 2026 23:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C9AB6B009B; Sat, 22 Aug 2026 23:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DF5B6B009D; Sat, 22 Aug 2026 23:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F15AD6B0092
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 23:43:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 629E6A027A
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 03:43:38 +0000 (UTC)
X-FDA: 85131139716.14.844D2E9
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf04.hostedemail.com (Postfix) with ESMTP id 8086D40004
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 03:43:35 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="Ok/Ua7GT";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787456616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pTMxwqiqizhxGvWUlHv/KW6PwYGh9ucvSLauqAzTYaM=;
	b=vME7xAiQamDB54Kejn44pOKX3uYW49Bk9Gr86pvlOLNzWYy4AfU2RQbJADHDEEzRM9uvY0
	qqEa47+BdencAbIVnXO6eAYtoMkI9VrIS95eLIerlZHJCaNdHd2KWDypDcgxPS2xidcJ0N
	lSaFseQLxtGpdDkU5ZbmonkjzJ5Z+t4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="Ok/Ua7GT";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf04.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787456616;
	b=HGiBc5x4rWw50WuRUSkJJPu0whb+ZDqgqMERVdoZWyGrl5o1Ba4bUG+Yhsak97uZYZxbSz
	R5ecbKRMV2nqy7zw7S/h6+m+brWizpmCUTqVZ2SOWjtimHfKsKZgj8lhpENg9jBrufX3Pl
	TEeJLSNUg0xe5S+aUrAifCkzX1QcsMs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=pT
	MxwqiqizhxGvWUlHv/KW6PwYGh9ucvSLauqAzTYaM=; b=Ok/Ua7GTq6EZ0RgisJ
	hrKqORn3Mqq1bt47a3i5mL9qsuTNTVCBpVyQVxT3kcqzgBw6ug++Ntst+sHPabJg
	5SyweZzAXmXAnTEMnRjmt5v3gmpCtauIZjUm64rH87kTJw7jx73u4HPs2YUrGaWi
	QonIeSwvqwINwWaWnSNcwry0M=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wCH5exMbIpqBB8uQw--.11509S4;
	Sun, 23 Aug 2026 11:43:12 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org,
	mike.kravetz@oracle.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH 2/2] mm/hugetlb: cap demotion at currently available free pages
Date: Sun, 23 Aug 2026 11:43:07 +0800
Message-ID: <20260823034307.1072415-3-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260823034307.1072415-1-xialonglong2025@163.com>
References: <20260823034307.1072415-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCH5exMbIpqBB8uQw--.11509S4
X-Coremail-Antispam: 1Uf129KBjvJXoWxZr17Cw1xArW5Aw45tF1rCrg_yoW5Zr1rpr
	W8tr1Sk3yUZF9xWr1Sq3WDJ3W5Zw4xKFW8A3yxArWfZw13X3sI9r1xGryUZa4xuFWfJanF
	9F4DZ3yDXry5XaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j2yxiUUUUU=
X-Originating-IP: [2409:8d1e:e12:7fe:fc27:3a72:bb72:5709]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC9xBsZWqKbFDtpQAA36
X-Rspamd-Queue-Id: 8086D40004
X-Stat-Signature: zogok9euasc9uudzdmqird9usczasu39
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787456615-848737
X-HE-Meta: U2FsdGVkX1+j0Vuz5OpnFhszHgZZIgy3+wU2YnemqfY0/hHLarN1floIwbVq2NW8wsehhnQZwXzM0U1Sq4tlwcxb4bBoo+JkeXJKIxExmGuHuib/3oemvdQ1mENOFHsuCEhUGeFLwLvKa1FLS5yFH8V/+mispS+nFf3UTX+ZJYtZ2hwDe+dvhWyxPGvX+YfYDjUMU08J61Hw4As2cwT+9HDsHKJm78ZAStwTVJ/HRBK0/szeFjf3ecNb+eqkZ5mFGdg7nqNxweVrTudXZe2Z9Sl7KNydRlqA0Hbeafz33KJA7bG7nvAakm6lGOesJkz2aAKymV+etARuPmke3x5GfQiw8MyT8s5OJKQMe0/qXtKP8/isdZ4o08X466LT42kaDx/dzUX3t8uJ/26yDL4Km5t3fkN3vcqfomuS+Rtj7M9zQgKMyP+iUenkjepgqyoK937sXRofgrm7hMXb2Uk7JGPLITmpK9iVSM1JN2tzLyZOOOSSEsolTn12kCitH2Bx/1rI8b2tfy0pip+3Gx1X/Q2UCfajsIrtkPTdGQyGPVVJDv4RYOY4dQ1LLhyNwFwyyl8U4xCauJTIUJ+jfvrQgaQEvPjTTPr9WhACIeWfJk7n0QHMQ1thTtnX7QBp1hAoXmx+/4YAICd2QSXm1tus3HPX6E7Cm0knCoTRGXWczyBpzAaa1iAqnAP2ZpyUA9WaZ7WqnIiOdvEjeGPdMHTRy6D6On5JCNtbagfu8VBtXu6WDCiCoPZdrV4FmKO/R8KqDuYWGSnmKd4oz+KBkhv3cEUZsMMyugU/l8rcONl7ztEJOm7RvmkyYTosRDcFCraVI5znDp0RIRa4kH2VICboaZ6IdcOcsbUzAgh52yglVJZ7gAz1CID+6fry0kUGy/aXt+JtgIKeJfXRdEwxAUcL/jvQO71O+hIP5lnYOSFrZ1gbSxXRvEAAftHXTW1oJ09KQ4zo9pgyvPIo08bxXKV
 apC6SDKK
 kS2kzgzhHl5bxP1GNrAbygT8oDvktoZ2XR1Vjf03TR4Qy238Hbo99F2my5cCXooksmgFCMBJEFV+fuCD9I+Gzr2IPLqXoR5+mDok4wO2DNScNi6wjEaZTKr1JFDvvfgZlQOkYeJhZb4I230sc6pVvr8MBRkCA5+YJpyK9sTac2F2C0bjMwtoyo1U72cOn5Jldt503tyXV90bp+PS5l18w7jlWSGA22eFrVStHE0LN48FwWLa7qy3rhlH2F5nRWvWwDpLylNSTH4zzPtBlhsKLOk5lk3yV+zPW9C48V9p8ODC0eO13lg3Ey+GTmybk1eJmmAdOykR4FXSSPb8F2/rN45LS1I0ly/VvrSjviH0DrihBC9enDjpAiryd7pG6bc0AZHtYwwG8nOBhtRU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Demotion must not remove free huge pages that back existing
reservations. The sysfs path checks whether any page is available, but
passes the entire request to demote_pool_huge_page(). For example, with
two free pages and one reservation, a request for two pages removes both
and leaves the reservation without a backing page.

Cap the sysfs request by both global availability and the selected
node's free pages. Recheck global availability in
demote_pool_huge_page() before each node batch because that function
drops hugetlb_lock while restoring vmemmap and reservations can change
before the next batch.

Fixes: c0f398c3b2cf ("mm/hugetlb_vmemmap: batch HVO work when demoting")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/hugetlb.c       | 22 +++++++++++++++++++++-
 mm/hugetlb_sysfs.c | 10 +++++-----
 2 files changed, 26 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 640df58be4e5..ae26d400ad31 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3998,6 +3998,26 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 		LIST_HEAD(list);
 		LIST_HEAD(surplus_list);
 		struct folio *folio, *next;
+		unsigned long nr_available, nr_target;
+
+		/*
+		 * Re-check available each node batch: the previous
+		 * batch released hugetlb_lock for vmemmap restore/split,
+		 * and a new reservation could have been added in that
+		 * window, shrinking the budget.  available is global
+		 * (resv is not per-node), so 0 means no node can
+		 * contribute -- stop the whole scan.
+		 */
+		nr_available = available_huge_pages(src);
+		if (!nr_available)
+			break;
+
+		/*
+		 * Cap this batch at the current budget; expressed as a
+		 * cumulative stop point because nr_demoted is running.
+		 */
+		nr_target = nr_demoted + min_t(unsigned long,
+				nr_to_demote - nr_demoted, nr_available);
 
 		list_for_each_entry_safe(folio, next, &src->hugepage_freelists[node], lru) {
 			bool adjust_surplus;
@@ -4012,7 +4032,7 @@ long demote_pool_huge_page(struct hstate *src, nodemask_t *nodes_allowed,
 			if (!adjust_surplus)
 				nr_persistent++;
 
-			if (++nr_demoted == nr_to_demote)
+			if (++nr_demoted == nr_target)
 				break;
 		}
 
diff --git a/mm/hugetlb_sysfs.c b/mm/hugetlb_sysfs.c
index 79ece91406bf..326a54b4d991 100644
--- a/mm/hugetlb_sysfs.c
+++ b/mm/hugetlb_sysfs.c
@@ -211,15 +211,15 @@ static ssize_t demote_store(struct kobject *kobj,
 		 * Check for available pages to demote each time thorough the
 		 * loop as demote_pool_huge_page will drop hugetlb_lock.
 		 */
+		nr_available = h->free_huge_pages - h->resv_huge_pages;
 		if (nid != NUMA_NO_NODE)
-			nr_available = h->free_huge_pages_node[nid];
-		else
-			nr_available = h->free_huge_pages;
-		nr_available -= h->resv_huge_pages;
+			nr_available = min(nr_available,
+					   h->free_huge_pages_node[nid]);
 		if (!nr_available)
 			break;
 
-		rc = demote_pool_huge_page(h, n_mask, nr_demote);
+		rc = demote_pool_huge_page(h, n_mask,
+					   min(nr_demote, nr_available));
 		if (rc < 0) {
 			err = rc;
 			break;
-- 
2.43.0


