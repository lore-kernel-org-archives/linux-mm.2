Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5493606A323
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=mh5uexrq
Received: by kanga.kvack.org (Postfix)
	id 5FD186B05B6; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AD686B05B4; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B7F6B05B4; Mon, 16 Nov 2026 16:01:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CE5966B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:01:48 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9E941A01F9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:46 +0000 (UTC)
X-FDA: 85442203812.22.76381F6
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0CB1818000F
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mh5uex r";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794862905;
	b=69pUec+MHnP2NomQyLywAxq5lmvQbAEC6S0RqS3f13a4yOHUdZVg1oSn6BldQI9vTU9lcu
	W9hx1OsvdETJkK21TUhDEFlUoccv4EEZ56FG9KMpf5KPaleZJQzGgj04+I5JKC0JbsygGU
	7DqYGiyw4RFU+iZRthReICh6n/j1iLY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mh5uex r";
	spf=pass (imf24.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=pass (policy=quarantine) header.from=surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794862905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QebCm/HdUJNQJhaYSYkTX5nopMX74EmzXUpwCg5l4wY=;
	b=kP5gEuBa4L1FJyinmozZtScUAaOPfyX8wF75ARszyvK5Be6HEvpb8rncmLrW0aO7FfUVsq
	Zgs2J4JTp8oE2tT7rJ9cplZF9gfh+foBVo66Y3TXDRRgnF4DEZ1zIp+5/4t+Tb3ibwDmbl
	kGpk2NsqhHl7eLBByb5KeJzExXTtWoI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=QebCm/HdUJNQJhaYSYkTX5nopMX74EmzXUpwCg5l4wY=; b=mh5uex
	rq+tCr2ByY0nyAqrEE3CMGD5Xfr8JGsmdFw60TyRMGJVGe56e4DvRZcfQ8kj7KYvILj+lcYxQzT10
	++QFcu9W15gkQv7WBmHlBlPqrI+OgucPtbt5Wj740nF2/tKfJz33YIx5WOGIwf6A+/HE9xyht7RvQ
	qBbI2pUZKi9ljESxWbvC2zc1GmyYKfrOYUovIniaKBmUtXNjeIiZWqZJ3cu1O80et3RC63kdmV+oh
	zOn7OW6GGbXyQX6K4ZJemr5w0hEO+rdBpB0YBzljASzPqoIIlTCHSFlbgl1moQkppWQro7rjIog4J
	16YVO+7ymiJTq+AMiiSEnOCXO5qg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT3pS-00000007LIv-1mDT;
	Mon, 16 Nov 2026 21:01:30 +0000
From: Rik van Riel <riel@surriel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Yuan-Hao Hsu <aa9736195201@gmail.com>,
	John Hubbard <jhubbard@nvidia.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Peter Xu <peterx@redhat.com>,
	Rik van Riel <riel@surriel.com>
Subject: [PATCH v5 1/8] mm/gup: break out gup_fill_pages() helper
Date: Mon, 16 Nov 2026 16:01:20 -0500
Message-ID: <20261116210127.3837898-2-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116210127.3837898-1-riel@surriel.com>
References: <20261116210127.3837898-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0CB1818000F
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: g33wieha7hpyam8mpkjdzq7xons58p58
X-Rspam-User: 
X-HE-Tag: 1794862903-485486
X-HE-Meta: U2FsdGVkX19tYpt3I5UvNDBMyCx17mjzkaajQqcVt7poEkyEKSr1s4jldoarrEPEyy31Ob8zKLoelNOB9LFtK0dTI1OZDdZrfbHFJWvtocAOCcjb8PR2HDsmQNICRQCUBoVarL/KbtUFjebPMSaQkdW/mBCrorWX6a5csrMyJEuzHjEJ8+luc2D5chY4VCb/Iyl0W6AGAO84usOtyqoYb8X7wlez9q221BZaJ4csqbAsM9kUH8UQ8Gwgfk2nI4mNjctVb3bR18e6U76TCaVx07oeseH26uCZEHDk9sZ9apS5ImeNoZ/KFEYC1QraZQv5PkLYv1iaWOYV3ibQ205QyJwcOG6Du0wRXQbnpG77bJOcSFT1gQzTn26cep94RTvXc4BnoRTRrvbkKOxBoigqqdHxSIqy8tjcuEfXtZD+8yX79Fq9BAN7dBvZ5kghpIRP8QO0EMg18pWhiUq7hIWnmI1Mhx5Utqvz9Evn1EgPqX9d1/P6Jiwz3SZcofev5Ye6bI9tosorTXgli9/Uc8aiedKojX+k93Qt1ta2vG6cwPVIt0DpWh86Xd1fP0c4lOyAyLqmKmQcXW8c6zijl2SGGzy1kXKrGp96vJWcEG5FxfN4VAJKHTo0chpWJujrMRGPfKmMI6t+pHoRmOf58gVixF3emv/gXcV+rMuGc4bYUBTsw7l53w9EJn0GMDk3aI51sJHaTD1APKKAxcZeR89HtWnNQg5toLJMwq/OidX5hi80+oieNKRaz5zLLiMT+yIHbS+1WkAAFtOYq0W6hE8Hmulx/8U31nYoKROb/L9vQHCdAS6+pB1kuMV2awtovhqQcAexbNrWR57jgdZon/Eoz17vkY7riJTWHVf6XhaXTh0UucAhv8bslfmoTqsrEh1w+HyZjB8sgu8E17Bp2E4zP2tSYLgPJ12ePsmifBkmvqbvMIBdRs4iOf5sot/P8EHPAHklknT5Q1o5lCoYfJ4
 X8+/Vu/7
 CVPN10Q5ZTl17SrBIivImLaZNbm7yirC9ox9Unm5LxbFpAmQCavgvZROl54UP/5Czhza8tBYYRJsyjYNPdDVmzfFVrzHR+8EVJEHjG7vtofu/Z+Yo4JLWDAZBF6J7VE5ISeYq9xMil8QNsq42QNzwciNfHQx6xIi7yB/32V01BW73GwQGviuNQXTlqpgMEaC4zEgJ0Yv6sEJJDK2UGA4AMYFbdYLVIGOjI0qu0FjXNyxpyBi+TMMYpToQan5lez3MzbOboLEb55gaGJgB0kGKSspx2UWOcHsCpzg9UPwiOaAgsZ3dcy9Dq5nVBjcuJJTpAPkokPlJycOFiOMMvpppcOBI2DmQASJMyE74HP5nG59ajn+ODtc4sEfzprqiG9WGiRb/C1HKdatCumI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__get_user_pages() fills pages[] in an open-coded loop, and the
GUP-fast PTE, PMD and PUD leaf paths each have their own copy of
the same loop.

Move the store into a gup_fill_pages() helper, shared by the slow
and the fast paths. The helper keeps a pages==NULL check, so the
fault-in users that pass no pages array (faultin_page_range(),
populate_vma_page_range()) need no conditionals at their call
sites. Cache flushing stays open-coded for now; it moves into its
own helper in the next patch.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b0a0019de80a..e0698d2075b4 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -710,6 +710,25 @@ static inline bool gup_must_unshare(struct vm_area_struct *vma,
 	return gup_pages_not_requiring_unshare(vma, flags, folio, page, 1) != 1;
 }
 
+/*
+ * Store @nr_pages consecutive pages starting at @page into @pages.
+ * The caller must hold at least one reference on the folio, so it
+ * cannot go away, or get split while the array is filled.
+ *
+ * Some GUP users only fault pages in and pass no pages array.
+ */
+static void gup_fill_pages(struct page **pages, struct page *page,
+		unsigned long nr_pages)
+{
+	unsigned long i;
+
+	if (!pages)
+		return;
+
+	for (i = 0; i < nr_pages; i++)
+		pages[i] = page + i;
+}
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
 static inline bool can_follow_write_pud(pud_t pud, struct page *page,
@@ -1579,9 +1598,9 @@ static long __get_user_pages(struct mm_struct *mm,
 				}
 			}
 
+			gup_fill_pages(pages + i, page, page_increm);
 			for (j = 0; j < page_increm; j++) {
 				subpage = page + j;
-				pages[i + j] = subpage;
 				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
 				flush_dcache_page(subpage);
 			}
@@ -2946,7 +2965,6 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 	do {
 		pte_t pte = ptep_get_lockless(ptep);
 		struct page *page;
-		unsigned long i;
 
 		nr_batch = 1;
 
@@ -3017,8 +3035,7 @@ static unsigned long gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp,
 			nr_batch = 1;
 
 		folio_set_referenced(folio);
-		for (i = 0; i < nr_batch; i++)
-			pages[nr_pages + i] = page + i;
+		gup_fill_pages(pages + nr_pages, page, nr_batch);
 		nr_pages += nr_batch;
 		folio = NULL;
 	} while (ptep += nr_batch, addr += nr_batch * PAGE_SIZE, addr != end);
@@ -3054,7 +3071,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 {
 	struct page *mapped_page, *page;
 	struct folio *folio;
-	unsigned long nr_pages, i;
+	unsigned long nr_pages;
 
 	/* See gup_fast_pte_range() */
 	if (pmd_protnone(orig))
@@ -3089,8 +3106,7 @@ static unsigned long gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp,
 		return 0;
 	}
 
-	for (i = 0; i < nr_pages; i++)
-		*(pages++) = page++;
+	gup_fill_pages(pages, page, nr_pages);
 	folio_set_referenced(folio);
 	return nr_pages;
 }
@@ -3101,7 +3117,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 {
 	struct page *mapped_page, *page;
 	struct folio *folio;
-	unsigned long nr_pages, i;
+	unsigned long nr_pages;
 
 	if (!pud_access_permitted(orig, flags & FOLL_WRITE))
 		return 0;
@@ -3133,8 +3149,7 @@ static unsigned long gup_fast_pud_leaf(pud_t orig, pud_t *pudp,
 		return 0;
 	}
 
-	for (i = 0; i < nr_pages; i++)
-		*(pages++) = page++;
+	gup_fill_pages(pages, page, nr_pages);
 	folio_set_referenced(folio);
 	return nr_pages;
 }
-- 
2.56.0


