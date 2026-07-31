Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CA27C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:09:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 124196B00A2; Fri, 31 Jul 2026 16:08:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D5516B00A4; Fri, 31 Jul 2026 16:08:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40E86B00A2; Fri, 31 Jul 2026 16:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D052C6B00A2
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 589E2A012B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:26 +0000 (UTC)
X-FDA: 85050159012.20.7D036FE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id D8F138000E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fw+l9rno;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528504;
	b=stNDjHIaIVFD42N03GaJW8l3uAae576YVmwKpzr5apckJZPCtZIe+b976dxfBF15nmmB/I
	g60/PJDFUG9Fw6tSnA7Hxf+2Nd8auBz7WzTYxMMPOUDrP01S6Dh4FBftxWuNgFhx2dVcCO
	3U3HgbvfoOKHtOLfapFRBF+TxRZpovQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=fw+l9rno;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hIzJYRQZPpHEWuu6W/AISPT7gNqOr/DEAar1Fg4H3OU=;
	b=2s4jUkFMU1CuerQuK3e+v34jdGbPHkWVLotMyCcrnUUYQU5Ja+NTbb0HGyzneNPrHo20ld
	2iw0ywdm715HuhSmulOV9gT3TnmajUy57hVEl7b7COXh5kIHxKTiax8gcflxzTkfhpoeUk
	6aIamHtB82glGU/JbEGgjdB95afxqP4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=hIzJYRQZPpHEWuu6W/AISPT7gNqOr/DEAar1Fg4H3OU=; b=fw+l9rnokR1JrAunKCwKK1qypD
	NpXEnItcaTxMD173aSHPmeiQ61ukkYe54RoPsTvAi5kpxWIid8y2voyY+4+/BHGBg99YfqUfpjQ1T
	9m/Bm4GoEcWLPS5Uwvw7k3uySov3aKmF47uhHd8S4mc9dcMRqB1qWJP1UgivEhJy/N0gdKMxYCyrT
	NMy0L2lWu030gifCcfxDfUxgH/ej5mlYVHWhLwfJnsxTfAT+EOS6lCs5xZkDOWwjKGb4L3XiUb3iQ
	orWTKu8guUAGqN0ZJpgfUU4xoulahiz3Qn+cOIw76rNpRs1T4Rs+btzo7dsheWUeb7BX7cSScMgez
	fxwpO7Ng==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWW-00000002Pfr-11Ya;
	Fri, 31 Jul 2026 20:08:04 +0000
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
Subject: [PATCH v8 03/15] mm: Rename folio_contain_hwpoison_page() to folio_has_hwpoison_page()
Date: Fri, 31 Jul 2026 21:07:48 +0100
Message-ID: <20260731200802.574821-4-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D8F138000E
X-Stat-Signature: xrj1feea9pwtwyiycxpubh5egcf1dfpq
X-Rspam-User: 
X-HE-Tag: 1785528504-982283
X-HE-Meta: U2FsdGVkX1+DyEAp+/rh6GGBwowNXcAIss0NB23ozhbbsl4NsJ+Fej0jQDK50hugHY2+EFsp96tKfsc6Hnia+fnzS8+0kTEGtxzzEyTctpdm5hyKxyrPn+EDHifXcbNYlgSU9eKYNvL4K7PKsBkkLTV3ltSjC2NaLLef79gxPtlTESef2FDrWOtpyeOzkqe8KKs7sJlvcU/u0bo9/XfmcSI8x7+c5oslkBfF3+xZvotMMWdjNWU44c82DQn6lCJfRTXPh1+8JZnFsudGqazHvqVZVGsMGM38srtXCNZYsC/uLNtxkNXekR+lx7xwwsFQtSS5rZ/cjivoz9spfA80AiW1AV6AEqijNLUKi5qHu7sor36hogcY3YxKSmUqx5Ib7bxD9aHF0OVq5fgyQ/95lwAgyPG2Gkt/0iXHcVWv621KtL9eACvjox+pg72/RbotN52fYbCkMo+sG4qeLHsGxMgqV6Uja1ywVqQmhoK7aRbyKg2PwbyCoZ0pXFKU7eOBEEhgyWJFuk9V4HxXimnX0rncVgg6HsDnlb4wguHSAdohilnjtQpNtS8lUhvexNy7gDS4jvmalhCkF2sr/wtbAURXxKl1j3wEbGOmNqjet099nqcZOnMQFGKzCtDm+zu3VciL4R1RXE2taXmRSRRrvTYgaxEmcrdhXNd83YVgWltkbV86aDNNWSj5V3UzlfyOzRFilnb2aDkCDy0jUc3b1DEQRxZChjahGvQ9LhbFrF5sAv0WTGfdjwK2lqGoG23Kem4Mv2Pa/WmtsY9WmNlS9rCmEH7flFnBuyvuEbwIWENmhieDBkHQq4LdxDuuPwyLxCME9t2t5g4+GFoPb4i5xkzTmyEHoX11b9Ejpa2scxr00+kLuAtwQD5DOYE9HUkE53gkdFulZSbt3Sn5wylxUP+gSfmi0SnVYHoJTnibDo93dFV1HCW9KSQQ7x/xmsnc9nqadEiG6S/kOWJbptj
 vBxcJC9H
 kS6mgnbLaMsx6DwPGXG8+fo5/7d0SCtx1wpVSGe6kjsKGKNiUfGcZyZpoS+cqYEIUEwDK/y7yKabLnWt6NF2AnJJ10ZW98xp4frgOFMZJPZaP7HfEpy2jokEmsijN+evSrzfQAPGo/Uwz/x1YWi4xafoMitXOOUQnRdrR3En8Fop7xEpuuLzRuNfUw12bFZYnmQVJPdVXhUK7EcY+s4Jd9EyAOyhlc67qQ9FgTSo29hjYoVY6Qm4meDfRxzbmA25mdXZ9iwlr9CJqmUvC7o4OVyEC3hCnOB8cwJWdXj050YEWq///3n3ELhZrkb9cbMb48fGVifq3r9hqEl9su7JvgbbSMd28WWcAENG+uoC7UL/toVkk5/W4hbOHCe4VxEa1zE7swW4s78DwohhHGHK1qYqtvSOzm7zzvvSwgWk1abRdqmfF3PBm7a8RVx11UR0oOKIdPgOdRUXMYq/5B6e3Ydgq08pCVFF+4g/kECSY0CgQafy7PTkDVxzTzXiLQ0Ns0rZ3
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


