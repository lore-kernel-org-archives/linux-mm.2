Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89DFCCD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 12:57:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771CF6B008A; Tue, 23 Jun 2026 08:57:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 722776B008C; Tue, 23 Jun 2026 08:57:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6120E6B0092; Tue, 23 Jun 2026 08:57:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39FCC6B008A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:57:46 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BACCB166F05
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:57:45 +0000 (UTC)
X-FDA: 84911179290.25.D595AED
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id DADAE18000A
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 12:57:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W5LQ0LvX;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782219464;
	b=NbGF+xhsX+oE3kaHBZj5cuFNsXXFoE/jptnHWU+TbCDm3dX15CWxJ2kH6+2cEeZ5PNrm89
	wOCVkj8+2cqvyD+4C7bMK11d51GCFftln+HMjWtp1+p3jv7DRvnRXp9avJxlGjaTlmh+WX
	NcAujoPZ3vOAeEtj11fe4mrtkkmC1Og=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782219464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EL4QrO7ppBcMNaiGPjxOSzTBwTzo1VcmwUW27NduZXs=;
	b=JE1tMMGUnCPxRCmg1emcKSxGo8go/JgCEekedcPzgBoEkymtR/K2MvUQX1gwlV4CI3Y9qu
	Flc46K4wLr/etiVJFvLbWzcSmqZaBOoT4qE5Nf+qS78wehUkpZcbl6c0+NV3FX4gw0kvIl
	KRnffKpLgTwh8pGYkli0EH1cfWm9Hkg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=W5LQ0LvX;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F2B1244C;
	Tue, 23 Jun 2026 05:57:38 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E7FD93F632;
	Tue, 23 Jun 2026 05:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782219463; bh=DkUvI4H/W+JmbCbw7Jp0p0O7QapXeIB3dwVTXIwbuLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W5LQ0LvXDgaSTzdSuAeZxPMFaiCyk7BbihuLunKq4VnAuDf9877AnV5+QaYDpbJdy
	 CsF6YmoYxur2iiur7K3p9sw9iC7v8xFQKuynef0CAjxTJDsWBvyfXVG48Ffe1cnAAP
	 je9qRVX2RHWo5NMIRonb0FHnANmFJMd1ertIrS2w=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	liam@infradead.org,
	ljs@kernel.org
Cc: Dev Jain <dev.jain@arm.com>,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com,
	david@kernel.org
Subject: [PATCH 1/2] mm/swap: rename subpage->page in folio_dup_swap/folio_put_swap
Date: Tue, 23 Jun 2026 12:57:21 +0000
Message-ID: <20260623125723.2503832-2-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260623125723.2503832-1-dev.jain@arm.com>
References: <20260623125723.2503832-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DADAE18000A
X-Rspam-User: 
X-Stat-Signature: nsdrcibticxdukbxyn5jj7zoqrqqqnko
X-HE-Tag: 1782219463-873357
X-HE-Meta: U2FsdGVkX1+CFywKUJcBXeDQepuRyawf0hOVPv2S0HxR9wXpbfGf7vVZ/1Fp6TxEmqyljwuf2eop6dutZgCtThA578AQG9+KhngGn1ZEvMwc2RaXg+0qjPXds6i6csyjPeW0L6rxgVooH5goN9daVfrv8Nzv7nr2sAxLd+iNhHn7x6tldJqzUAgGBsxJtlXM0Jbzgo7f97d0YdpHW3Kkdw489AV5ny7AaqNARDAYi6vbvq0Ffx6QqrHXZZDNFwaM/87S50C36UqDGoY/0Z+tTgZpUkIwMBjSR5iMOY/9bzCp9UbDGZ499Dz/aY7hVvqj9ZqDmlotyv07+x+tyPZaJEeJ7cNcXi/GXZpzvQpCtcHOSeqCxQABFmt7UbWek7WKk51mc4IKLhSJEB2SRTvuWstxGnnENIQE0GTIgbMRS6S1vfHEmfjh7jQqb8AddCb11/B2Z2C6YZnWt4SsuzwVJ/aawjVaZxhyGPTkxapnFCe+3A7dUf9T/tXou1vpF9BO+DcgSpQucYPZrQulxm6blBjLAE3nFbhCvN5uN/iC8jzkKLXk3hEw3aH8YNZpHC2ho9vCEBQYu8apHWlJxro/HYGFqxRsqHARJxBkPeuPz7IFSuG4brMRpYH5LI1blztczCGADO7BO4k/4hxtdI6oIzYJ6MxAh/0lLPeB9e4pkyUdsWy7R3RiOKkZxUYFFlQWXVogzMWHoIvng0vE1y4ETTs2sse3jTYvJ724wUbNZ3xX6qblHvcTknI9t/SAGmuhXUPMR5L4rNy/4xyLr3eGK2dhCovc+9+Vr9V1XdWCYQNt8MnKUIUMnU88xSF9dC0phofO5ZHeNVho2j5/jsnyE9PD0mnnwvPUFY+D1QVmIbKXR6LMmVaYpE3QlesMb9BZdiHwPLolFoV9xmP5blSDsDLoV6jWj8mzkB0o0FbyONQ5yz0ohDQB54/ydZ0yZ4rxPcF4qz9hL4Rxed7G8mK
 cJl2fqPo
 7XLhQRXddBpWzRn23KCQgj/eRr0NnRVCRtvVTfctG/rRi6e9pThII34hfda+97ls/lFPbrOjpWwFFB0DYC66ZrM0DUfnmyKpt4YdUB9ukn4m3NRJhr6Rqxuo/pUuwQ0hGtnThcg5RVKKCRONKRW0kFo3hBdhc2AtYbnYKx8UFqUNw2oxx9IIgWoLMHMFqXNT7O7AJBv1EJPTtBNMt233mo9ctDE9oitNMNtHplmPWxbjoo/9IUxTAx4PrzYN1/9jDXs7B8IF0Yvwv096B8f7mVTQ6BWy+P0P5QNdAD6EoW3R2IaQlWCbREgDZ7u3U3ceoxCVN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Folios have pages, not subpages. Rename 'subpage' parameters to 'page'.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 mm/swap.h     |  4 ++--
 mm/swapfile.c | 16 ++++++++--------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/mm/swap.h b/mm/swap.h
index 77d2d14eda421..44ab8e1e595b0 100644
--- a/mm/swap.h
+++ b/mm/swap.h
@@ -230,8 +230,8 @@ extern int swap_retry_table_alloc(swp_entry_t entry, gfp_t gfp);
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
index 78b49b0658add..a602e5820513a 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1781,7 +1781,7 @@ int folio_alloc_swap(struct folio *folio)
 /**
  * folio_dup_swap() - Increase swap count of swap entries of a folio.
  * @folio: folio with swap entries bounded.
- * @subpage: if not NULL, only increase the swap count of this subpage.
+ * @page: if not NULL, only increase the swap count of this page.
  *
  * Typically called when the folio is unmapped and have its swap entry to
  * take its place: Swap entries allocated to a folio has count == 0 and pinned
@@ -1795,7 +1795,7 @@ int folio_alloc_swap(struct folio *folio)
  * swap_put_entries_direct on its swap entry before this helper returns, or
  * the swap count may underflow.
  */
-int folio_dup_swap(struct folio *folio, struct page *subpage)
+int folio_dup_swap(struct folio *folio, struct page *page)
 {
 	swp_entry_t entry = folio->swap;
 	unsigned long nr_pages = folio_nr_pages(folio);
@@ -1803,8 +1803,8 @@ int folio_dup_swap(struct folio *folio, struct page *subpage)
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
+	if (page) {
+		entry.val += folio_page_idx(folio, page);
 		nr_pages = 1;
 	}
 
@@ -1815,13 +1815,13 @@ int folio_dup_swap(struct folio *folio, struct page *subpage)
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
@@ -1830,8 +1830,8 @@ void folio_put_swap(struct folio *folio, struct page *subpage)
 	VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
 
-	if (subpage) {
-		entry.val += folio_page_idx(folio, subpage);
+	if (page) {
+		entry.val += folio_page_idx(folio, page);
 		nr_pages = 1;
 	}
 
-- 
2.43.0


