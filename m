Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE9F1D262B0
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 06:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E4066B0088; Wed, 21 Jan 2026 01:27:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38DF46B0089; Wed, 21 Jan 2026 01:27:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BB086B008A; Wed, 21 Jan 2026 01:27:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9DB6B0088
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 01:27:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BE8CF1607B0
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:27:19 +0000 (UTC)
X-FDA: 84354988998.30.3EC2E85
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf25.hostedemail.com (Postfix) with ESMTP id 95C8DA000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:27:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="eb+tRD/e";
	spf=pass (imf25.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768976838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qyo1UXxvb80ZNtm/KnUth+3Ew/cM0x9cJHvAGUTak5g=;
	b=5IFMbnnfXAA3ovm/NHndBofonWudfhifx3FSFmM5zrSt10NVpPNxONl8NlodyplO10QvQP
	1kryrOPTP+7FfN+GkWuWSRjxri8mg3xCkEfcZ8MCCDzZfhSz45k2BVb6A1d+KFtd2gC1SC
	DK0w3g1NcuHT9Y/cf/MLk+PERARp+xk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="eb+tRD/e";
	spf=pass (imf25.hostedemail.com: domain of tujinjiang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768976838; a=rsa-sha256;
	cv=none;
	b=kjTRypiEQm0631AFWhkhPazbH2JPSsqfCuMpbRZYbFviXigUkCxs55VvJ+BvdZKlW7UpfY
	+rS4jyjrPB7GqzPmmGFu5FQfzWWLFxQuhpofW0Ab+NQyL3oCZRr0J/6hG9OrT0OC+R1M3P
	1fX/3FSQKaCCAcWTYS0LQImW9m5pS5c=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=qyo1UXxvb80ZNtm/KnUth+3Ew/cM0x9cJHvAGUTak5g=;
	b=eb+tRD/eivjXTKEyxjwn/9SYlw6P2b7VcP22XoR/Ovy3xm6Qht9REnU6iMn3JgkCNq/gYGpZp
	5pS0xlvCRC28HMJW1t8OHh0L1qnzoXfoP6rM5C3hPNuNPlxChTN0I1ohu2qUMyxkeer7OWlJMUq
	O+4T5QaPJcUKv8aGfJDQcbM=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dwvJT0PjSz1T4H4;
	Wed, 21 Jan 2026 14:23:05 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 8913740588;
	Wed, 21 Jan 2026 14:27:07 +0800 (CST)
Received: from huawei.com (10.50.85.135) by kwepemr500001.china.huawei.com
 (7.202.194.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 21 Jan
 2026 14:27:06 +0800
From: Jinjiang Tu <tujinjiang@huawei.com>
To: <willy@infradead.org>, <akpm@linux-foundation.org>, <david@kernel.org>,
	<lorenzo.stoakes@oracle.com>, <ziy@nvidia.com>,
	<baolin.wang@linux.alibaba.com>, <Liam.Howlett@oracle.com>,
	<npache@redhat.com>, <ryan.roberts@arm.com>, <dev.jain@arm.com>,
	<baohua@kernel.org>, <lance.yang@linux.dev>, <shardul.b@mpiricsoftware.com>,
	<linux-mm@kvack.org>, <linux-fsdevel@vger.kernel.org>
CC: <wangkefeng.wang@huawei.com>, <tujinjiang@huawei.com>
Subject: [RFC PATCH] mm/khugepaged: free empty xa_nodes when rollbacks in collapse_file
Date: Wed, 21 Jan 2026 14:22:43 +0800
Message-ID: <20260121062243.1893129-1-tujinjiang@huawei.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Queue-Id: 95C8DA000D
X-Stat-Signature: qh1rjz3qydcrmrpyb8hxpitpng9soq1x
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-HE-Tag: 1768976834-251470
X-HE-Meta: U2FsdGVkX192IitCbYh+/is/A9VSDASZm5CpXE1M3wMFsXFRI9gqkoMEfZTtT+5EO/IciMpGFzqESLoJqSVnr8gKtaVVWuJhtFKpQgVYzD8O7tivXgAYUXScpQLvbwsO8gWDFZlEtPVBECcU7D/C01YUmsoQXOa0cZW0p5VW2/83mcTpKlN5nUK9HSqMQHDzgh/txMnHCVNvR0DJ8Qr2EA8euya7DlrpLzRLjJYfGWUjtFtdCjmu6hET4E5fkvYef8LyThdqK9dFR7h6sl3GbsLdRFYcTLJIxE/qaxCCyF+aBLyblc0A0YA89vltMQzOT/1bereWKetVRgj/FQNjkbgiHBn8rEuUuTScHae+Aj9v3E3KT7DQpnYGvJP4A2HiW7ENNL9P8bGUzlxgGYEkj7sAExcAW0Js9R3zAiQ1Ol3gJWe5yr1Nhm3qjRnl//y2ZMDQ9+bTF15gKN4iFWsFo3B8xSpQ1lWyvcL6bsV5r4F3CTUJQmMLBzhiIMZHRFpFcos0V2hOusFgi/+/1rryYdm6D+h1CDPLtVyyafOEHxw6SJAQz5IooHcK8tTX0meuvlrc9fohIJ8axgMNfEAw4Wg+3qS/A0RkUpbNwJ0LLZafW+hQW5MXZX1CL5JZ0x5CD8H7bjFa/DonRNmRu/Ianluig+xElvW8wbzLNerVmO7+bDFjojZuhier1h6I/H+93RRsMTid7j5k00dXX4Y1OQwrAQAgETaZJ4H1/62MEZpOskklnJrl4uYTQsePJRT+4xDIivaM7uvgwga052SvRB9kuX8WTfRvUWZKI3liG1XerplRvaHNImLMFD7UIIV05+iNJJK63Awu2dsegLU+QtD686CxaZIxcPgh4RFhuxqJk1vX4te38QvPBpBCEG0d/aijCr/ZsvAyfIqlOAmnL1SlDCx3JmjXW5czN/se4zLlfUciHSAPVDDqmVrPv8KkPimN5NS0zRZaXsHXXeY
 yw5JcMka
 E+3VcCSoL/ZisAv47QUbcuhxV1fxR0GqYvE/UR5w2wtVz1cNWV8sjnGUjx8fDFnVBLvqJkLZYEqJRp4Xrt19qnSn/pay5g/JWsSUAw3FP7KBf4SYMAaY6PWwk2gj5VwClWBdrIDSbslhHk5btucAJVbS6HsbEDagcVNCjBDkxxl8/dZScAjoapJ/SscCza8WMZo7zESITuxn0WSXHX4XW80gsji61no6BoM7904VpzHAalNOAKKtyqB+BQ1Tm8J/LKumc+egKZK1OLO/lnpm4M4RhxDETfG6z1lPDybJERbtSAgE5yj0p66Rj4jcaNE5YAeB39ERlwHOsdSrlu1ciwNCwpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() calls xas_create_range() to pre-create all slots needed.
If collapse_file() finally fails, these pre-created slots are empty nodes
and aren't destroyed.

I can reproduce it with following steps.
1) create file /tmp/test_madvise_collapse and ftruncate to 4MB size, and
then mmap the file
2) memset for the first 2MB
3) madvise(MADV_COLLAPSE) for the second 2MB
4) unlink the file

in 3), collapse_file() calls xas_create_range() to expand xarray depth, and
fails to collapse due to the whole 2M region is empty. collapse_file()
rollback path doesn't destroy the pre-created empty nodes.

When the file is deleted, shmem_evict_inode()->shmem_truncate_range()
traverses all entries and calls xas_store(xas, NULL) to delete, if the leaf
xa_node that stores deleted entry becomes emtry, xas_store() will
automatically delete the empty node and delete it's  parent is empty too,
until parent node isn't empty. shmem_evict_inode() won't traverse the empty
nodes created by xas_create_range() due to these nodes doesn't store any
entries. As a result, these empty nodes are leaked.

We couldn't simply destroy empty nodes in rollback path, because xarray
lock is released and re-held several times in collapse_file(). Another
collapse_file() call may take concurrently, and those empty nodes may
be needed by the another collapse_file() call.

To fix it, move xas_create_range() call just before update new_folio to
xarray, to guarantee collapse_file() doesn't unlock xarray lock
temporarily. Besides, xas_create_range() may fails too, we don't unlock
xarray lock and retry again, just destroy the new created empty xa_nodes
with xarray lock held to prevent any concurrency.

Fixes: 77da9389b9d5 ("mm: Convert collapse_shmem to XArray")
Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
---
 include/linux/xarray.h |  1 +
 lib/xarray.c           | 19 +++++++++++++++++++
 mm/khugepaged.c        | 36 +++++++++++++++++++-----------------
 3 files changed, 39 insertions(+), 17 deletions(-)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index be850174e802..972df5ceeb84 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -1555,6 +1555,7 @@ void xas_destroy(struct xa_state *);
 void xas_pause(struct xa_state *);
 
 void xas_create_range(struct xa_state *);
+void xas_destroy_range(struct xa_state *xas, unsigned long start, unsigned long end);
 
 #ifdef CONFIG_XARRAY_MULTI
 int xa_get_order(struct xarray *, unsigned long index);
diff --git a/lib/xarray.c b/lib/xarray.c
index 9a8b4916540c..e6126052f141 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -752,6 +752,25 @@ void xas_create_range(struct xa_state *xas)
 }
 EXPORT_SYMBOL_GPL(xas_create_range);
 
+void xas_destroy_range(struct xa_state *xas, unsigned long start, unsigned long end)
+{
+	unsigned long index;
+	void *entry;
+
+	for (index = start; index < end; ++index) {
+		xas_set(xas, index);
+		entry = xas_load(xas);
+		if (entry)
+			continue;
+
+		if (!xas->xa_node || xas_invalid(xas))
+			continue;
+
+		if (!xas->xa_node->count)
+			xas_delete_node(xas);
+	}
+}
+
 static void update_node(struct xa_state *xas, struct xa_node *node,
 		int count, int values)
 {
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..969058088eee 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1863,7 +1863,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	struct folio *folio, *tmp, *new_folio;
 	pgoff_t index = 0, end = start + HPAGE_PMD_NR;
 	LIST_HEAD(pagelist);
-	XA_STATE_ORDER(xas, &mapping->i_pages, start, HPAGE_PMD_ORDER);
+	XA_STATE(xas, &mapping->i_pages, 0);
 	int nr_none = 0, result = SCAN_SUCCEED;
 	bool is_shmem = shmem_file(file);
 
@@ -1882,22 +1882,7 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 	new_folio->index = start;
 	new_folio->mapping = mapping;
 
-	/*
-	 * Ensure we have slots for all the pages in the range.  This is
-	 * almost certainly a no-op because most of the pages must be present
-	 */
-	do {
-		xas_lock_irq(&xas);
-		xas_create_range(&xas);
-		if (!xas_error(&xas))
-			break;
-		xas_unlock_irq(&xas);
-		if (!xas_nomem(&xas, GFP_KERNEL)) {
-			result = SCAN_FAIL;
-			goto rollback;
-		}
-	} while (1);
-
+	xas_lock_irq(&xas);
 	for (index = start; index < end;) {
 		xas_set(&xas, index);
 		folio = xas_load(&xas);
@@ -2194,6 +2179,23 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 		xas_lock_irq(&xas);
 	}
 
+	xas_set_order(&xas, start, HPAGE_PMD_ORDER);
+	xas_create_range(&xas);
+	if (xas_error(&xas)) {
+		xas_set_order(&xas, start, 0);
+		if (nr_none) {
+			for (index = start; index < end; index++) {
+				if (xas_next(&xas) == XA_RETRY_ENTRY)
+					xas_store(&xas, NULL);
+			}
+		}
+		xas_destroy_range(&xas, start, end);
+		xas_unlock_irq(&xas);
+		result = SCAN_FAIL;
+
+		goto rollback;
+	}
+
 	if (is_shmem)
 		lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
 	else
-- 
2.43.0


