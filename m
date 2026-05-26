Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5293ACD5BCF
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:37:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3C36B0099; Tue, 26 May 2026 02:37:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B649E6B009B; Tue, 26 May 2026 02:37:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A53D56B009D; Tue, 26 May 2026 02:37:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 924966B0099
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:37:58 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BC241A02C4
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:58 +0000 (UTC)
X-FDA: 84808615836.24.5D874B2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9707620011
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:37:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dcbIL2tq;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779777476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFJfKrqLoW0E9+2ZerVqN/wH4MJaOQ3J9trPs+hh7iI=;
	b=C7G18FPLGVfs3JPrkxWpFNNCR/8pG5D1No6ma6aO70UV4QMI45k7lOvZUCkeW6XvFTRmh9
	oPxJuMNhdNey7tbSv/FaBinIQJ6FfF5Ao0MedZd93ZsaScX61rZEk9W4nKo03z35Vc3Q/3
	eVpYdqdEVKaPNj1AXqIF3DpXvey9rEE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=dcbIL2tq;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779777476; a=rsa-sha256;
	cv=none;
	b=xi3HVdub72wvM9+7CD+nRPDquvvE77V8RxqvqJmT7Ogvyd8MYIaLKHTE9r6yLFbfjAlm0T
	IkWq+rcpRb5ZQCRgF3czct7e1PnJ/7w1xGTXxWzugqIQhWXt9WUHv/ezH3d19wmkus7FZG
	w53Pws4sn+nR068O8DWtUFn6oKAuSmk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8035222E6;
	Mon, 25 May 2026 23:37:50 -0700 (PDT)
Received: from a080796.blr.arm.com (a080796.arm.com [10.164.21.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D9D353F7D8;
	Mon, 25 May 2026 23:37:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1779777475; bh=JX+ixgDgIJlpjIKhZEbaNcddWomvk8UmR+JpoxTI/ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dcbIL2tq9CQXB4XAAxexn9mqPM4gdBhe7dMAkblxDaNCuZkoqqPbsW44vE8FyhyuG
	 bYwsXgW9w8KDlIEHMtcLeNOsw4ncoGHamuJRY770DGM7bS/AqwsZLJmpz4gBhjaaej
	 BzPNrBj2QBnZR7bD8H3ekBBSky5SwxwKlnzaIyAk=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hughd@google.com,
	liam@infradead.org
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	baolin.wang@linux.alibaba.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v4 06/12] mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
Date: Tue, 26 May 2026 12:06:29 +0530
Message-Id: <20260526063635.61721-7-dev.jain@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260526063635.61721-1-dev.jain@arm.com>
References: <20260526063635.61721-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9707620011
X-Stat-Signature: 5byssxs7buw7g5ckghfh9r6j8s8a8tgi
X-HE-Tag: 1779777476-821602
X-HE-Meta: U2FsdGVkX1/gw9yX/4sdtvixlyCGzW0B9xBkfUVBmoZJ8CIbbZaW4IR89+bAaHkVOA9dBBq7veQsqP/yKjvd4D7JYrrnhDZKOPfINBfQRLjkeC8+kXwX2gPWFeJHuB7AKvZ4z1s9i25r87HRL0J3E9aLoVIMllTFTVM+IYDspd6erAfkBJ0gK45+xYi073oEQs0GeLZ5mR0VHuIAIGHGMBhI52CezK1/HIxiCh1uTuuKeUsUzBaFFADcmnK3xruoQNFduextjOK1yaFyxb+1WDl5VcohkfkSzKcE/Q4xmAMekftVY3qAZl9CscMH/Xo78IANaPg37KZBrhNdNyjB2O6Y0PXiGFb1iRBhACoJ0KPvRElllk+lB82TTeyEC99EhXCzuBxPPTtXZwOVVuAa/mSx3966fuQlw6guFJ8F1JZfz6AUZm5qS/OKNRkN5JQJazpVsQYjAv5m/fyIdo12kZAsmDC3mdQ6u4PzaGD9I69xXYpU4XBY5bG2yuWQvDTccaKNPZERw7dNjtRvNc8JB+cpZtLcYbAGObQdQEM7Y09MvSKFZjfwW3bFRPhusnXwPwPjhSHWT45U6y496U8/Co9xERJNS5OhljU0OeYSLkyDlNvYh38I2C2OyqRe7Whr1SPKPl1Bl6eS8DfKcmeMnUHAgpcPm+4UtnzHZUob1PULVef6yLbxt6gr62dOMFVcQUfziCV2z0mS/jJr7qbVsP08sZmXwEZTZRRXB03bJuXHmvzJuqcjTVjWkaN4XRT+wu631FA0+hAr8/aWiuTiomYv3sHGjzUIgB0e9uLzvc+xf84os+dBQSRBfwTB50CameoIW/I94fBSfAPrys9vptOxFF7ICxRomtgLbhXpLVGkUTdGQLJnqkX9WNIY4XB8WGbp0dHa4ddOrOn6pxMULEyhsZ6qplTAClGr7WbLrdphoOk5bykp30Fgc8uT82LcdPbQJpT9q6poePMD2Bh
 hgzRfCKr
 55BbkhrjQrQ7Xrd5lSr2J40jIAkvN2Wl7PqR+0MXeJhbHP+ag1DVnv7brdnhxPJGoxobEmIzfrAZ/30pwwiPWIq3oXAwk6HE5mgR1enQ62cXGf45D2S2UytQgDuWqihawPOjkO8vGNODQJ8n/sniMt73HwG7iY7dBHqW3UQEJEQIe4yNjFwXIlU/kiPh06GNS7gk+A0hkFqSyKQcffXwtlfmxNsp1bv460xfpsUEPtgPyrKEDyfxVbnIFS1YBLNqjO8pRuLCD+jH1EGkXhZnA8ta6SgMc8fKIF4US
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/swap.h     |  4 ++--
 mm/swapfile.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index a77016f2423b9..b57547c25ffc9 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -206,8 +206,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
  * folio_put_swap(): does the opposite thing of folio_dup_swap().
  */
 int folio_alloc_swap(struct folio *folio);
-int folio_dup_swap(struct folio *folio, struct page *subpage);
-void folio_put_swap(struct folio *folio, struct page *subpage);
+int folio_dup_swap(struct folio *folio, struct page *page);
+void folio_put_swap(struct folio *folio, struct page *page);
 
 /* For internal use */
 extern void __swap_cluster_free_entries(struct swap_info_struct *si,
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 08309c1dafa3b..62f083cff75eb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1743,7 +1743,7 @@ int folio_alloc_swap(struct folio *folio)
 /**
  * folio_dup_swap() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
- * @subpage: if not NULL, only increase the swap count of this subpage.
+ * @page: if not NULL, only increase the swap count of this page.
  *
  * Typically called when the folio is unmapped and have its swap entry to
  * take its place: Swap entries allocated to a folio has count == 0 and pinned
@@ -1757,7 +1757,7 @@ int folio_alloc_swap(struct folio *folio)
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *subpage)
+int folio_dup_swap(struct folio *folio, struct page *page)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -1765,8 +1765,8 @@ int folio_dup_swap(struct folio *folio, struct page *subpage)
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
+	if (page) {
+		entry.val += folio_page_idx(folio, page);
 		nr_pages = 1;
 	}
 
@@ -1777,13 +1777,13 @@ int folio_dup_swap(struct folio *folio, struct page *subpage)
 /**
  * folio_put_swap() - Decrease swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded, must be in swap cache and locked.
- * @subpage: if not NULL, only decrease the swap count of this subpage.
+ * @page: if not NULL, only decrease the swap count of this page.
  *
  * This won't free the swap slots even if swap count drops to zero, they are
  * still pinned by the swap cache. User may call folio_free_swap to free them.
  * Context: Caller must ensure the folio is locked and in the swap cache.
  */
-void folio_put_swap(struct folio *folio, struct page *subpage)
+void folio_put_swap(struct folio *folio, struct page *page)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -1792,8 +1792,8 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
+	if (page) {
+		entry.val += folio_page_idx(folio, page);
 		nr_pages = 1;
 	}
 
-- 
2.34.1


