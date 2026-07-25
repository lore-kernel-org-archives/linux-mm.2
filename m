Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDF83C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AE846B00A0; Sat, 25 Jul 2026 12:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 286D26B00A1; Sat, 25 Jul 2026 12:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19CD06B00A2; Sat, 25 Jul 2026 12:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCE8B6B00A0
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:00:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 68AF6802D5
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:56 +0000 (UTC)
X-FDA: 85027762512.20.D7A82B2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id C70AE40018
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nLAyvFAv;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cwsU3Mhrg9KcuFxTAl0Tes+dvmZix99ipM91bAbmnN8=;
	b=0CT8OBeOdR1lflP2pmMe2uFjv0pyvPZCx3GDjYLqHSkLBPAR67ZQ0k8p8ynNbrUMSmA3AL
	piYC49FvrW4hk9Fc9MfK/b9SEJFnEMpZDGO3LpScdMoZcOJDiRQxvTrF3zFzy1a4iPdNxv
	RLB2PjwLI8TSmqWWu7cqn5ZXwEXvBLY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995254;
	b=gYhFBPWjwtGzlp2z6YhvIrZquzSii1eehHhg4DjT92YKMetjmUisWdd/nqufXMJk/9xZO0
	hsMP+WwbzVTCLFirYDlV5R19AH/JwDaCIAZzaMRAId54bRhGnIp5AsovJ7O/Tup37KpVm9
	EAC1aCA8CoWVurLJEwiXQjXEtElsu7o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nLAyvFAv;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=cwsU3Mhrg9KcuFxTAl0Tes+dvmZix99ipM91bAbmnN8=; b=nLAyvFAvniBvHertjThqXOGD77
	yUSbHgNb3YTkxV5Ai6fUP86m0+etfFfCN2ARoexhEqCxop2U48snp0tJss96wgClBXfOhG5IXuZz+
	dGk5AnDuARxU+W9DU58OuPNodAxEZSTGu5F/vq/JsD2oK9Irp0zf9gdUVgLUsJ9qXSU/VH1GJWxwt
	S1vh76whef2u1Gyt2P4SR+zrFWCARU6tjywzT2fHIHdp5mLj/wBuIW6w5MPvXYCCtKBYsRfClQR2O
	mIOspCWaSIWNl7sab1MqPMNKe1wsjUeLvkTt8dVztZuNra3dKVp2aJRrVQlU/rPIVw96DcQXExhtt
	53ZfaeKQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnenr-00000006X7S-29ST;
	Sat, 25 Jul 2026 16:00:43 +0000
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
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 02/12] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
Date: Sat, 25 Jul 2026 17:00:30 +0100
Message-ID: <20260725160042.1557264-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C70AE40018
X-Stat-Signature: xnupqdif71ctprc6bx5hp8b99f1zra9u
X-HE-Tag: 1784995254-586503
X-HE-Meta: U2FsdGVkX19m2H1ZE3l0j6uYPBw3ct7WtFdqx770Mx11BjJgRYhg4mOHBeL/mj3LSJvMZ/qJKUwkYL+bdFz2iqHQ/ujl8ySdQpePXeLNdDrTtTU7jHIkUbiu1jK4r40FGvlU7XSd2WL1SAUJKKjlgdISB8CQQBO7+SKBdQpFkeoGJNyDbx88LqObBF0RFHkGtSCOTl3AZf7vDlTb6gMGIkQ5XbNmy1N5A0wryQBaKdVrQAoTipxaff7QxLkC/vlQKb2lZVp162BgE0ZWCy2WTU+L4tsg1xW9PFWguzZRYw4zIDs7pGV0OMbj56IUlzfiX+RsONZe8eP9iRH0Mphik0ZB9yz4oaRvXHSqX2Ltx4Qqg/mhPNEXcih5CIHtqZyXq4j7Xd9QB7cm3KHY1zZsG52ep/jt51i+rVkvJCpRe4k09xnqSL3YKNwSpWXPXU/03i4/3O4VLxRRQV2dtMbY0NJK3zauGyBkzfzyKVPImYnIikEMMnl55AWfWM0gVpeMYTJ6SOpXI7MRc6pity7nWnE4YJLo4qEL/TUKSqJ2qia2vpFx6yCBxRm/5GeBxMPt3qeyt/NMyI3OADdEM690/IZ8Y4zPX8Ep52OGcmkk8LW5iEcjgVsbiKUMnqP0cA5bQFmMvHXylATU1k5pvcixz9ouFsEHHeK/awim/I3rLnIoiH7JM+9Wpzm3g9bYm2v38+AHWcGRcSbKKOjsAwM4Pf6VSTS1prXTB/YcIUcDvynsGVxVzmMU/V3H/JQDg0jucFCp9Ouh0y9lwh164T/tqOK0PcYrZ5UuCi/KELbDpj8aljvHJ12dQt7dzajU7Yn63f1c66n2eeVw8O1MwrwZq4lxSouAKRDgrr4Rzonz6nzS/KmN6wx21xgD8mLkat8Hfu687Wp3+/XZup/WVYef+a4RKs2AJfwwTOEi8P9L96xmWOHHypmRpbcpUiOfIs0oOfMBSKi1dR+QPUW4JJ/
 J4ZFp3xM
 dGqoD0Jri0hgc3J3yhGMvq/hU8i9vgcvZZ1W2IfCvjQOqIH5SSkuW4XQccbdfoUhbx+ZALC235pDOhOE3N8EOG/ry9PBKyLcgkpTHom3puV0/ocfKWMcwc/eYo7p13bwaZx3DCPNfLDTod20lzV+nESYQpBVZOU9UgW1XJjAyJLJh3EtzxBM/XsctaMl1XW47XorsJ3hKsp/wUgoe+kXCMWtUQY3Zf1rVaginAOeoTrRF40ENk7XQMqV08UdvnYElipEygvx2bM8PIles5OfJu7ZMPEsGJBqlqpN7qYfuJyJsp0PLb/dF6j45UQQtgE7WG+nxvMT5FH0GhP+ZVEKI9AtdB6cag3o61d6JauM/H7MN6JWHezaecjRxIwxtYMXzzKRBKhEBxzgBwcEuqjEGHavxkQ==
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


