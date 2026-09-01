Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18B77C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:44:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210516B00AC; Tue,  1 Sep 2026 01:44:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7D36B00AD; Tue,  1 Sep 2026 01:44:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D5DE6B00AE; Tue,  1 Sep 2026 01:44:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDCB76B00AC
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:44:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8CEE1602C1
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:35 +0000 (UTC)
X-FDA: 85164103710.24.CA06646
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id DBEBCA0006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oz2H0BCH;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788241474;
	b=YtIxCqh7zAFDopPbw2z4Uge8WgzHL4UnL8lE9SnBvjEm+NatFYYC2uKIwUVVnpwpBfaWGi
	/HX8B+5VS39TLgHefBK8EcOKq8t6Qr1PySE2lFoei78MxmhDlqkSMPlgpWNy86vZ/cYjrP
	/SfbMhVKH8S8823KX0RNNy2RmyR2uX0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=oz2H0BCH;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788241474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WaPg5bI7c3b0n5JJjVA9ynsso5Rjh3D73bo4S/Y7+Zw=;
	b=kEH5TNhZ4V9QloKztrMNtqh2gG4+M008GbfKxi3cpOK/R9Uk31jSN27OIj37qcTj2+xrJ1
	w32j137zOILym06cuCtOoklTUbpFHiCEjqBe9/Wl5r5hWYpIvsOHSjj8QYlNaGDyqfRjwu
	vzA7OCJ6iwjAkkSDF7AH1023BoS1KsE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 434201BCA;
	Mon, 31 Aug 2026 22:44:29 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 2C75C3F85F;
	Mon, 31 Aug 2026 22:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788241473; bh=4tS7tmRJt89rYLLLP6NkERN/c/Y1n2Ho9ctBU+vN0ME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oz2H0BCHqxgB8+EYjO1CA6z0w/3MTbwN/Bfl0F/wGW82MBejFyFiivi+atLNtZA95
	 HR7yQfq+oXKfD4NtrevQ8lbiL8cn7edktq/LjALdoUuLMssxPktPZQkewKoiMBiB0B
	 zxaU7ipCnf3gZL3SU8D2mw2zk0i9x6NZJsLc3TzU=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 3/8] mm: move anon-exclusive batch helper to mm.h
Date: Tue,  1 Sep 2026 05:43:50 +0000
Message-ID: <20260901054358.4049095-4-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901054358.4049095-1-dev.jain@arm.com>
References: <20260901054358.4049095-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wmti8ezqg7txegzam8xhkoc44ma7zty3
X-Rspamd-Queue-Id: DBEBCA0006
X-Rspamd-Server: rspam06
X-HE-Tag: 1788241473-444040
X-HE-Meta: U2FsdGVkX18C+uR4RECXlcG9QgQR8voh1fU10Xk6KDleHv9jNhT5kYwU5BtfGlX+RzYq7gyAGw30ewSEWIRjDjyisIEPpjLQGyHKKy7QeQ39dFhiQyzTtJYgyItXSArYKWrc6iApclTBe9MiyHiZXexQKq7r5hVr6PSdyBGmsPcZ0JZyguHOGDuYk/dmT0KzeG32PkX77vIjiz+wRJnvB719ENsMuIqRr6Iy4YQMFh/C/r2vDiMAYQStERDHW0UCtrqzfsviC7EQkZuJB6VLLPX6Ysunm6ufUBbrOsyXqR8bV0zOCMDs1i2NzdMfThzAVL48p5P4QL9PfTbEzUJVE/8L+tjtE6xOOCr0/Ab795L/pO05AFiFNLi0fByWoj83FNMnqRLQLli2Sn3mhfji5+mSM0qNss9GFulob6uJdjxqsNcmTq5sKIA2Cala6XYm43mt9+K0su/8RJlqVIC9y8/M4XC9nZe0D58JAezHipNwVH0w+N/lpk9Iqmf168fCd4QU/HlW7sAkkGpHnEaudUjgabagzMPuPZqp/XRmAVBHneOI6eEWhDsUcPtz+/miiMLwawpfmTU+tqQnW7sJO20lQzG0epM1K4OOLLbVKCIXaH+uUO9dPbl8q+c83xtl7l3cJQieFenUekBwlYQ2+WBsNm7h8pIvaqpwJ71HAfEJ57YfXLBXRKGvBxjFIu/Y4Elbl0c0ZvQgPXlmjDe6HZG1cRdBJcYgalCTdtYgXLyGuOOQX/xBIOcSKeDECJslhv78Yu4r9HyXfPzua+O7z8U+aMtmvBtPAHN1cQLbEwscEfRxjJD+4yfn1CxYN1W2f/ssUBfTLsQtSzENxAJGJ21wf7jingKWb3gJuft/78V1rmXXfSJKDhHiQyyjgM2Xl9gLSk+wfjqKJRK+cvOlRctNwxZEQcAnXPSs1NkinW7WTn9EEvuxC5Ie35jojPylZBIIem3BPfCx4FbOTJ7
 hYnaw23n
 wGP96MZ9SJflX76a198RjfUYBJtPLPItJmZBq+pE/ZPeUyn8B9IFTVIgsjoQ+rdynHSicu2Z6gvq9J+04TG8h/mWd/qz1otx5DEVEtMIxhzEJ7wFnm8AjvI4xEMkNn4hgCacyt8Ycac3WZK9AbP+mUKRkzU/goqzsX/e65+yrmFoqvWVQnPfbKk0PvggMghptkC6yfnv/sVUo7aq4aHCK+0cxSo4FrLgRYU6BY1lO643gd0AroJR80Z8Y7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for optimizing large folio unmapping, we need to reuse
the page_anon_exclusive_batch helper in rmap.c and rmap.h and obey the
existing use in mprotect.c .

Therefore, move it from mprotect.c to mm.h. Gate with CONFIG_MMU since
both rmap and mprotect users are built only for CONFIG_MMU.

While at it, change start_idx and max_len to unsigned long type for
future proofing against THP support at >= PUD level. Also shorten
expected_anon_exclusive -> anon_exclusive.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/mm.h | 19 +++++++++++++++++++
 mm/mprotect.c      | 17 -----------------
 2 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index dd09c438fa23e..63da8813bc5df 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -244,6 +244,25 @@ static inline unsigned long folio_page_idx(const struct folio *folio,
 	return page - &folio->page;
 }
 
+#ifdef CONFIG_MMU
+/*
+ * Get max length of consecutive PTEs pointing to PageAnonExclusive() pages or
+ * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
+ * that the PTEs point to consecutive pages of the same anon large folio.
+ */
+static __always_inline int page_anon_exclusive_batch(unsigned long start_idx,
+		unsigned long max_len, struct page *first_page, bool anon_exclusive)
+{
+	int idx;
+
+	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
+		if (anon_exclusive != PageAnonExclusive(first_page + idx))
+			break;
+	}
+	return idx - start_idx;
+}
+#endif
+
 static inline struct folio *lru_to_folio(struct list_head *head)
 {
 	return list_entry((head)->prev, struct folio, lru);
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 2888ee638d872..75c2b1a00eb36 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -138,23 +138,6 @@ static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
 		tlb_flush_pte_range(tlb, addr, nr_ptes * PAGE_SIZE);
 }
 
-/*
- * Get max length of consecutive ptes pointing to PageAnonExclusive() pages or
- * !PageAnonExclusive() pages, starting from start_idx. Caller must enforce
- * that the ptes point to consecutive pages of the same anon large folio.
- */
-static __always_inline int page_anon_exclusive_batch(int start_idx, int max_len,
-		struct page *first_page, bool expected_anon_exclusive)
-{
-	int idx;
-
-	for (idx = start_idx + 1; idx < start_idx + max_len; ++idx) {
-		if (expected_anon_exclusive != PageAnonExclusive(first_page + idx))
-			break;
-	}
-	return idx - start_idx;
-}
-
 /*
  * This function is a result of trying our very best to retain the
  * "avoid the write-fault handler" optimization. In can_change_pte_writable(),
-- 
2.43.0


