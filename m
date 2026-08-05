Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E77F8C55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:29:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57086B00A4; Wed,  5 Aug 2026 17:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C076E6B00A6; Wed,  5 Aug 2026 17:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44BC6B00A7; Wed,  5 Aug 2026 17:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 814946B00A4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:29:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 02B1A1405CF
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:29:38 +0000 (UTC)
X-FDA: 85068507678.05.9429457
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 821F7160008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:29:37 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rRFLGEHM;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785965377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIzJYRQZPpHEWuu6W/AISPT7gNqOr/DEAar1Fg4H3OU=;
	b=W2bCmh1egc4MftIM8WOh0eh6NpVcnmbFha5YTaUeQZeOQuZCXAeyZaemL7bArk1Q4pC8Z1
	nqkW6Vot1APrFqbylzUpEekX7g5OJrXIlH7Oz54UmoRlM21k3xViXwU1HGvgRmcRQ9RYqN
	Y3mzC+SDtsOr4NfD7H3UKh0UtQURlSo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785965377;
	b=aiSJtFGnuSEgB9MgPNbybGwVHKjleUANkRMCgZjzBJFNYvTQDLjUZVjVKfjpq0UaH91C4n
	vPWBFO/zvMQQ6HWL7ykQ2pNxJ8ujXYntlhJ7A8dA7wQNNe40m8rVZ70ccPOxOr7wcADeO3
	xN/Vdex2Suo6pJn3W7X1oxCysDX59No=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=rRFLGEHM;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=hIzJYRQZPpHEWuu6W/AISPT7gNqOr/DEAar1Fg4H3OU=; b=rRFLGEHMqkRsxYpNukq9XG9Lf0
	m2iq4L3gzpuvKeJ0qLel2MCNMDT8voD0I79gAr6juu0xwloudbo7mblV5YjTs+40+vPY3mf6rbmQE
	cW96klxX3NcOSR/R0msKF1dyQKsZynohQp3nBBnRAs1FSmEkMVfh9Ib0ZqgLcOvja2JHZ0AOBwYaF
	6yS+5vwdagikB/dQi6J9CTsTfqmcKug8B7GTPyN1f+BU6aS8ZJWEAUevqB8jiZekxJcTo1ry1QnKR
	+NNSJaS9JgCMvaEvWPm+gYEIgYiE1Xl5CvyMTKWXmrCmOcEI7wZ4Z7U/zaT0wavEpwxpDTL3XBJiZ
	gIq1fZDA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioJ-00000004h69-2Hbp;
	Wed, 05 Aug 2026 21:05:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH v9 03/15] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
Date: Wed,  5 Aug 2026 22:05:43 +0100
Message-ID: <20260805210557.1118966-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 821F7160008
X-Stat-Signature: pkappztds6pogitz5wc9q658ya3bmwdi
X-Rspam-User: 
X-HE-Tag: 1785965377-755709
X-HE-Meta: U2FsdGVkX1/lsOLXTRb5vSJpVNsCCLtXvX5eWHD9WaY9yMlIEQ+7bPOXgxZZA/K/uqTQq9ORkYhO4iRwCE9CTPVaFvzB7a/UIJoW6Itqha5lhh0M642nW9KEcaW0RZx6SvjWDzuOqcvxakdi9TZqACxWhYTJKh/WD2qPqO7+T2dizBVulBL4OCSWxQyUFCQf+ZMI3fJp2I3TTB7SI5/PyQWn5LCi42QM/bq8R8Q4MSbNvb+VU8jCx2rxciALR5GHvEqg2XH9GE86pDKdqFfa5R9uhMzJgcmlfzn7iF8r+LhyXZ4mMQvOkaAjjNuNFrbc0a8vw5tuWePrbekR+r+RvldbHLbMZ6uohjvibNElIYJ9dIvJjyMpyt1j0PHEjbB5eptmdmq96VvLo/FogHM5ZNJl+UoqGPaZAtoyAw+OQ3Oa6gsj6evHP7FabNgb9d0eS+p2OiTelKdtjWAF5LYsgQ0czz91V0LW1a5uyR+Lws2K3oi3GVGuczE86X1u5ND46II4hYNA9SBSAXMTlr2rtHwBw1OUwUiDVKLvn0b4g1bn4brA+kPVzysS0Byenj7HbknG0lajV8DNZv6aVYntUZX5JJX60MhrrXkXbn0vCmAL//Nj5og4Ddz1gxxhOv0ZWk84r23O0hfutm4zy1kdrFXtOxGNhtb+wz4LBBROCfwZSZW5a+NBZzfuCpdAdTIiqD0GwXu0UDi7hhmaSwroXuTM7H7Xovw5CgA2QI/tlqpluWA4H0gLzRaOpmTyEQf0Fquuv2LSV6KuXE6vWoSrJxtkDAooNyV7Txh+1RdukkgIS8jdja4YSvGnDLg1uejGiTmEZXYKitLk6FZ8up48YgXeIASd2MRUmG+XzQBrDUNXyQy/W9t/fK23OXxw8CG2a6DWQs0tlKUO/1mcsIh1We5XuxOlO4BwVGYXmFif/Sc8c9iHCLbTgm/ingD393jfvB749LUESuQOT7aU2AX
 V4EjwaTv
 B8tdo1orCTdvrQspxmLCNmktQbwS47oKm3dbaHnqn+CQiVOuXjX2tQI0TSWDaqrQBneWZNbdY+m/UtZBvWNlaXXTDgq2YHbOXuQXB0kIoY2Qm1xtoKJ5aeUuE91ZVg8zs+YvmavRhQjP/6LzpcMKuvMBmSPbGJ2Xciy3wlIpGBjw/Zkk0RkL/UBgyDscH+Lp/FgrpLHp/bQFYI5HrPe0rX9hJkzO9OW3rIEUZJ9EiS0hsdzHB0GV/cOpF0BscdOTL1ctnSV8kUX75HlRFrT0I5ad5xJPDBbivDHcSCvzdHxTkZn8BuODfJi+jBnMmNIr6uiXLpfhV7dJCMnZApCQ4bMaC4PzAekXUADQ2qJfF646drzlPB0XA4CbZceptTjtskbEkRkWXmuQS+4SGP0EoaCMLMeJvp7yR0m+XYIrvMRDQ0cjbqwVlhP1hkHtRiFIMX4Pxs6nKPkrsM1kG33xZX1TU5I7nIV6e2jIhXgCpaGzPko0FiT3RQnqFH43F44ZCc8QJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a better name for this predicate.  Also make the argument const
to allow other callers to be made const.  No functional change.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
---
 include/linux/page-flags.h | 4 ++--
 mm/huge_memory.c           | 2 +-
 mm/memory_hotplug.c        | 2 +-
 mm/shmem.c                 | 2 +-
 mm/vmscan.c                | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 7223f6f4e2b4..4185a03a45cf 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1083,10 +1083,10 @@ static inline bool is_page_hwpoison(const struct page *page)
 	return folio_test_hugetlb(folio) && PageHWPoison(&folio->page);
 }
 
-static inline bool folio_contain_hwpoisoned_page(struct folio *folio)
+static inline bool folio_has_hwpoisoned_page(const struct folio *folio)
 {
 	return folio_test_hwpoison(folio) ||
-	    (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
+	       (folio_test_large(folio) && folio_test_has_hwpoisoned(folio));
 }
 
 bool is_free_buddy_page(const struct page *page);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2bccb0a53a0a..353340309107 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4413,7 +4413,7 @@ static bool thp_underused(struct folio *folio)
 	if (khugepaged_max_ptes_none == HPAGE_PMD_NR - 1)
 		return false;
 
-	if (folio_contain_hwpoisoned_page(folio))
+	if (folio_has_hwpoisoned_page(folio))
 		return false;
 
 	for (i = 0; i < folio_nr_pages(folio); i++) {
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 7ac19fab2263..33007e8e546a 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1813,7 +1813,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 		if (folio_test_large(folio))
 			pfn = folio_pfn(folio) + folio_nr_pages(folio) - 1;
 
-		if (folio_contain_hwpoisoned_page(folio)) {
+		if (folio_has_hwpoisoned_page(folio)) {
 			/*
 			 * unmap_poisoned_folio() cannot handle large folios
 			 * in all cases yet.
diff --git a/mm/shmem.c b/mm/shmem.c
index b51f83c970bb..492c9bef3620 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3240,7 +3240,7 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
 	if (ret)
 		return ret;
 
-	if (folio_contain_hwpoisoned_page(folio)) {
+	if (folio_has_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return -EIO;
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..70e54ace0e74 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1086,7 +1086,7 @@ static unsigned int shrink_folio_list(struct list_head *folio_list,
 		if (!folio_trylock(folio))
 			goto keep;
 
-		if (folio_contain_hwpoisoned_page(folio)) {
+		if (folio_has_hwpoisoned_page(folio)) {
 			/*
 			 * unmap_poisoned_folio() can't handle large
 			 * folio, just skip it. memory_failure() will
-- 
2.47.3


