Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 581FBC531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 22:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84FD06B009B; Fri, 24 Jul 2026 18:30:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FD0D6B009E; Fri, 24 Jul 2026 18:30:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 716236B009F; Fri, 24 Jul 2026 18:30:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4054E6B009B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:30:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4F03160183
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:19 +0000 (UTC)
X-FDA: 85025114958.08.998C39A
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf16.hostedemail.com (Postfix) with ESMTP id 22F4D180016
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 22:30:17 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JcETxnSL;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784932218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tJmogI2ctJBh6SOVkxDE96kh4IjYWZ9BC1mV32p1UTU=;
	b=UIS4PfdT8W46WsgAU/Z6v+T1rGAvp8gLCpD5IpXTBKAjm2K6vQNscFIQqhTrWe/xYQdyco
	UTUscquMkN7S4R2O6L+aoFcpIya2JWdbGholcH81pneHFnwZHPp5i9Ve/gTqfsQk8RtcLM
	MabLWJucDE+9JMqOqT3fHYSeQ6nPg/k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=JcETxnSL;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784932218;
	b=iJobUxSlm8AIBhbnuOHKlOuRFYys9g9Xlr8M+ExF+0CilRWXXBJp43grFz897ksxGsWMY+
	I/oIAAUT5GyCXXiAm10e6BdAy0h2KQqRsCG1G4dmtcpiM004bj448JmHrXhwKKtTTHebCA
	CG1hsSS8sv55WFLl7OhQbyHHv6tv5Sc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tJmogI2ctJBh6SOVkxDE96kh4IjYWZ9BC1mV32p1UTU=; b=JcETxnSL13yfACuT5wJax44zN/
	afXj97fG6rxSc4BWLIay+Y+tZIvC7hP4oXzrCa+FyZx8pEAxJvp+33ydfnTYscdjvM7MfJwgTxHQK
	2LrjzIyde9cwAU8/bWQ4NypPTORvqUjoP4vsimMZr0UFALlgSRsBDZO0+AaU2773SRylr8Qard72R
	MZ3sUBNHUmv+v2qNvxULOIwbMjPWR/TnNVea+xkj6ES12y9zhfNhPM5NgpM6b3qOwlu4YSQ8Ne0FK
	HhANRkEHdiX0qFzctkUUXErkHpyLhtIAhJAw8B1pFP5f2XsjfeFP4LURMtNZxc44WeytiTkmEvAcp
	kzC47CpQ==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wnOOs-0000000027h-1rBH;
	Fri, 24 Jul 2026 18:29:50 -0400
From: Rik van Riel <riel@surriel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH RFC v4 09/12] mm/gup: build get_user_page_lookup_vma() on get_user_page_vma()
Date: Fri, 24 Jul 2026 18:29:31 -0400
Message-ID: <20260724222934.1463812-10-riel@surriel.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260724222934.1463812-1-riel@surriel.com>
References: <20260724222934.1463812-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 22F4D180016
X-Rspam-User: 
X-Stat-Signature: efw938phhyqfikh9wmsaybjzpfmbjbdy
X-HE-Tag: 1784932217-861804
X-HE-Meta: U2FsdGVkX1/UXhdSa5+IgmCtTfQzhZj2kiyTNbAON+IMsv89eX/AM6AGPzBhSRZaDiGSJ/k1tAn6cWRPoMCzYuVeH7S3wPkWV/ksvpJmkMBLkG70cQihSkKQknpPQ4E/SCu6eAs3w5Ps/F0XF2K8rj/lSCwvbcRALbv5Irmh76XCP8+MLby6aOqC/rxDUj+XEtfyyHl27whom0CR0Pv5OGKzPJPQY5cELEqrST9535KOeYjFMxvTGh1wlU1u6FYIeXLczUDHbcKrJZ0iA0dc0wnGUyBYYy0zXoiewc3D5SLTU66LhL5ZWsWABJo1BeHGlYqNHVN81/MF1oSWFXk5nDgnyJrNaO0dmG5vMzz+HG+j8ityiSekg+L9BFjtLrplio25n2czXD8ShktW0pDfzrY1AxGC66IHST8CI/ZC7twvyz6aHK1HHwkTccD7gJ/KqBeNvLAdC02hEWV0zskGO2qd6dbkTFAuQY5AQ88bcENOjx1viP+dzayQlpJgCc6jIAxbEg73q9HlVeo/WgOXcPdS6ulgeC3PhHAqBNLzDNYB6Z/yQpBmhTzrqe0nN4MhttbOUlhnyCJfW9nTIvQEnjYPEs9o5uHV/0WPaa0ibSH/yqX1otLJUyIUz7uS7PmRugInhL9Ws3q9+mXi2qBMuWbmD8C1Q25ZA05lx3QDUxM2s8yLWPjnQcb/zHixRkC1mvBmvR8WVaWR3yUEtP8uUvKZxobBDU5TO3FnZbrAfnlz0So/Bkp3x655mdgvQQMCX/3pnKT0ss6lJjn+Y4iDS2YvNKeJs/CsjtcsOW7Fg+5F9H3HNhKAiNniKvdf787rQl9Gw0VnFvO264vMDWzB+6eWjb/e+N6vjhmJGnvwl5niM5YwOaxjDkcaBTlWh6ea7QbnEW0jMizPHj7khvr3l8v0yAYegg98HkWmhjHvVAl0Wu5UajshvEgwv5w+tKxgik31IuMWiPe4on3XLon
 60diw3gj
 RSjhvVvuMuXkldcl3Pg11FtI1aD2qtoBaTgO9j9sgTDAEHjXbtnThcXNQaUh+/1BFZdy0vFG7KJVg2ynkrjHdTH41TXsVr487TfF7ir63v6izEzpcpEwNaWiw9NDp46x84dcJhsble55jcfiAXWCZN1kghOvLxtEbyhq9S5SyVY4MNi17I5Yn1jfILvlOo0FTrdyWmDOyV4z/4nQiH4sC9Z04ZzJY48L/Sk0WlJLT/CrrdBS9t2hsw8WvhAMfK3IutFWmfdHei2OjvShVmUM2ayqGb30OyBCioq6cSgsjg/TixHg6KY0jlD8jRe8NaUJf11gR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

get_user_page_lookup_vma() faults in one page of a remote mm and returns it
together with the VMA that covers it. It open-codes that with
get_user_pages_remote() followed by vma_lookup(), duplicating the
single-page walk that get_user_page_vma() now provides.

Every caller already holds the mmap lock, and the helper needs it anyway:
get_user_pages_remote(locked=NULL) and vma_lookup() both rely on it.

Look the VMA up under the held mmap lock and fault the page in through
get_user_page_vma() without FOLL_VMA_LOCK, so the lock is held for the
whole call and never dropped. Force FOLL_REMOTE and FOLL_TOUCH to
preserve the foreign-access permission check and accessed-bit behavior
that get_user_pages_remote() applied before.

Add mmap_assert_locked() so the lock requirement is documented and any
future caller that forgets it trips the assertion rather than walking page
tables unlocked.

Reject FOLL_UNLOCKABLE alongside the existing FOLL_NOWAIT check: both let
the fault handler drop the mmap lock, which would invalidate the VMA looked
up here. get_user_page_vma() passes neither, so the lock is held for the
whole walk and the returned VMA stays valid.

The one behavioral change is that the old path could drop and retake the
mmap lock across a fault, while get_user_page_vma() holds it throughout.
None of the callers rely on the lock being dropped.

Assisted-by: Claude:claude-opus-4.8
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 include/linux/mm.h | 32 +++-----------------------------
 mm/gup.c           | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 29 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 24ead14b4790..0f66d76e6ca7 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3235,35 +3235,9 @@ long pin_user_pages_remote(struct mm_struct *mm,
 			   unsigned int gup_flags, struct page **pages,
 			   int *locked);
 
-/*
- * Retrieves a single page alongside its VMA. Does not support FOLL_NOWAIT.
- */
-static inline struct page *get_user_page_lookup_vma(struct mm_struct *mm,
-						    unsigned long addr,
-						    int gup_flags,
-						    struct vm_area_struct **vmap)
-{
-	struct page *page;
-	struct vm_area_struct *vma;
-	int got;
-
-	if (WARN_ON_ONCE(unlikely(gup_flags & FOLL_NOWAIT)))
-		return ERR_PTR(-EINVAL);
-
-	got = get_user_pages_remote(mm, addr, 1, gup_flags, &page, NULL);
-
-	if (got < 0)
-		return ERR_PTR(got);
-
-	vma = vma_lookup(mm, addr);
-	if (WARN_ON_ONCE(!vma)) {
-		put_page(page);
-		return ERR_PTR(-EINVAL);
-	}
-
-	*vmap = vma;
-	return page;
-}
+struct page *get_user_page_lookup_vma(struct mm_struct *mm, unsigned long addr,
+				      int gup_flags,
+				      struct vm_area_struct **vmap);
 
 long get_user_pages(unsigned long start, unsigned long nr_pages,
 		    unsigned int gup_flags, struct page **pages);
diff --git a/mm/gup.c b/mm/gup.c
index cb7245b7542f..7f4107f7ff10 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1288,6 +1288,41 @@ struct page *get_user_page_vma(struct vm_area_struct *vma, unsigned long addr,
 	return ERR_PTR(ret);
 }
 
+/*
+ * get_user_page_lookup_vma - fault in one page of a remote mm and hand back the
+ * page along with the VMA that covers it. The caller must hold the mmap_lock.
+ * Returns with the mmap_lock still held.
+ *
+ * Looks up the VMA, and gets a reference to the page through
+ * get_user_page_vma(), faulting in the page if needed.
+ *
+ * FOLL_NOWAIT and FOLL_UNLOCKABLE are rejected: both let the fault handler
+ * drop the mmap lock, which could invalidate the looked-up VMA.
+ */
+struct page *get_user_page_lookup_vma(struct mm_struct *mm, unsigned long addr,
+				      int gup_flags,
+				      struct vm_area_struct **vmap)
+{
+	struct vm_area_struct *vma;
+	struct page *page;
+
+	if (WARN_ON_ONCE(unlikely(gup_flags & (FOLL_NOWAIT | FOLL_UNLOCKABLE))))
+		return ERR_PTR(-EINVAL);
+
+	mmap_assert_locked(mm);
+
+	vma = vma_lookup(mm, addr);
+	if (!vma)
+		return ERR_PTR(-EFAULT);
+
+	page = get_user_page_vma(vma, addr, gup_flags | FOLL_REMOTE | FOLL_TOUCH);
+	if (IS_ERR(page))
+		return page;
+
+	*vmap = vma;
+	return page;
+}
+
 /*
  * Writing to file-backed mappings which require folio dirty tracking using GUP
  * is a fundamentally broken operation, as kernel write access to GUP mappings
-- 
2.53.0-Meta


