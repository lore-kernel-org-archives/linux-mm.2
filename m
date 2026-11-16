Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D20F606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 21:02:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=surriel.com header.i=@surriel.com header.a=rsa-sha256 header.s=mail header.b=mrsaKYkX
Received: by kanga.kvack.org (Postfix)
	id 97F0C6B05B3; Mon, 16 Nov 2026 16:01:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E1E16B05B4; Mon, 16 Nov 2026 16:01:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D0FC6B05B5; Mon, 16 Nov 2026 16:01:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BA106B05B3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:01:48 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2926A80240
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:46 +0000 (UTC)
X-FDA: 85442203812.25.CD58023
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf26.hostedemail.com (Postfix) with ESMTP id 89B1D140005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 21:01:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mrsaKY k";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794862904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNg/eN30d+0BFvF9t/QYVmNoDb1lzvAqSarbFDg/MKE=;
	b=CLC6VExC3FIKXS8fWN41nWUaOKXRuevxbGEWfWk3Oe57+iYEnZOHEXdCauOPb1nR6fRySi
	juuYzduqu5B+at//fMg+jAjf3l6nHl3fPshXxDSuf1I2+qrRH96E7iL3oKMgK88xKT+Ond
	G0J+onUkREPxe5XOt97GW0PukHSuaJk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="mrsaKY k";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf26.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794862904;
	b=Ob7TbrM0X3rug/u520J5N/vUXPg6J53uQlACcMeK9CaflI/++c5ApqURhUOES6/Y1ZHKuN
	PGFJ3pYYd+BuJHnTF3GhiD6pyUfL3jjboSiGEpFy8FBgzmArw8YIoQKCY+HT84qN/AIurL
	nlLEjiubPPLaSfI2pIPUmbxXSP/vJtY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=SNg/eN30d+0BFvF9t/QYVmNoDb1lzvAqSarbFDg/MKE=; b=mrsaKY
	kXv/n7TJSEdoqakNsKMv/0MMiRPOUVpqIP+KTWomcUu8LXPpJ8U1hHHun47Ojsy2/kxRXcnLFu8KE
	2n5O+870QbnSlgq/MMWdesn2Y4dsstadJywXaUDpKhvoGBr20yaSSFtMrG8OalzLED+WBam1YITuy
	Whs0xpbWJxcZad5rcFHod9gb4b4OWaukwQyM+hFH7w4007Xs6a3YFBz36C0bR/zx0zsyKLcRMQu5i
	Dx9JaQIG9v0GKX3+btTOUIaoZlOD5+xjt7D02f+Yld9a7XtRvRGa3AftjnQJPVEvKnd1uiOKqaPM/
	PD7h4lmtKL7Ak6ipj2m4hiNNyiqQ==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708] (helo=fangorn.surriel.com)
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1xT3pS-00000007LIv-1tGF;
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
Subject: [PATCH v5 2/8] mm/gup: break out gup_flush_pages() helper
Date: Mon, 16 Nov 2026 16:01:21 -0500
Message-ID: <20261116210127.3837898-3-riel@surriel.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261116210127.3837898-1-riel@surriel.com>
References: <20261116210127.3837898-1-riel@surriel.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 89B1D140005
X-Stat-Signature: zfq8ocmapmsca1kxszppdmwsttngzk4c
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794862903-256514
X-HE-Meta: U2FsdGVkX19By5popw8o92iuyRf39jYjh+xDunjwM+2d5YI6a9ewXegxHEo7U3u8DGjdOmCrJVVSR3FfQonbkjepk5r58bwWU6mXW6WSNS254KAj3zsK37Xz3bG9f4QMhwSlKx2wE4m6sMc4fX25bq6bJj9vOuAdK40wTjAxUryW/Ib0xWqnOQex5IhrN98W0zYE9SK2Wxnj5cmNx07H43b+qABlnEnpog4EWU4fOsQLsHkkg+2vYaAz0tCo1Toiptgog6eAOISeanTX156SEKBOhWJm1PtrtI5yU3+KhF/XmRSRaHvbPTDm/iqm3lSmtLqXyL6aSWGWXXjBD4uyaf6u96N1UmEykBiu5ZqVKgesB8NIQoCR4lL91M+T+xkY7gjKiG21KQPbMAzJ+OHoduyRfI7apMD2sSqxWJ/db6UxjCWVLk1cg1MMv2U2hNrzBTtR1+LdRL+NGkQ1h/b9ClX6709jM+T8oeoOzrBMxoQ03vlhX+sfiOtlacoYskgdo2fEHPAiSkZD7r48VbGzSYHyPsOB+6cZ6Ufix5VePlCID4FHex5nRHc4ck/MJtM3JCt4zQPt5KwUUjz2KILufI3yRy+lWFaBoLOS6AW64U923DEZJdf8pxhTE0vMac3drloMrSQGAR+S9XfhCcDeqGMwnd5jxyx4cHuA9d+QyXv27VxZdjEU74A2n0NzF7/qYbeEPZ8Oik8sSooFo4hTU0Ak9llVo/GuQ/qvph6EPsnkTtAMzpIHGJ2oPVhkoJPfNjdK+P5gUOmjI/H4wRoItty/IUa4JWUOM5lPRPizBZyH4qu8ouCY9sHaZzTmV+Hw2tD43nRGQDNpLpkewKIpf7pSCkERpLZsB8zGjKwvC9t2bsUSqMbgUUOJKcw81/cO6OWUWvM2L+73kOFQHuA/Gq6YklxXZJuEah5lRuVxMrCKxutOpFNy63D+4j2KfOj+zAiSLSnA1Uw5kbpW6ii
 WafEOZj5
 qErmtLyobQsk/igyicR0ywFUzLEF9nrSQ/viYl0zkTVM7ZfAjvavp1nDep+XdAVO6XgDbiBXMCDrbhmCcm9h+cgRiumIol/i1c7bTPkR7B3lN+XINq+u0v9ibsOXGai4IqPEtkTnlPdgDvTvTSwjaqLhGYdudnafDr9hpFPvqf82NTL8shN44ec665ychamtMLt/R1gv8dkNm9hCT7EKjm5tJyvQ31UzJ9RDpT5rP7lqdgay22+3pZZpr4MDLSg30Yxyax/uxJQGscaeXf9BSqLUo6XxVJDn+igfVZtyc8C5VqgmYACeCTguAC4RHqOWawoeABFXtH7ZIBTcGxNqc428MUQrTN5F3ULui4GXcOMnVro6DwqG2XiIgLxJDOIi0Q/w0bIGRPDIcIz0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

__get_user_pages() flushes each page's caches in an open-coded loop
right after filling the array.

Move it into a gup_flush_pages() helper.

No functional changes intended.

Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Rik van Riel <riel@surriel.com>
---
 mm/gup.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index e0698d2075b4..d35fedbce7e1 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -729,6 +729,24 @@ static void gup_fill_pages(struct page **pages, struct page *page,
 		pages[i] = page + i;
 }
 
+/*
+ * Flush the caches for @nr_pages pages stored in @pages. The caller
+ * already holds folio references on the pages.
+ */
+static void gup_flush_pages(struct vm_area_struct *vma, unsigned long address,
+		struct page **pages, unsigned long nr_pages)
+{
+	unsigned long i;
+
+	if (!pages)
+		return;
+
+	for (i = 0; i < nr_pages; i++) {
+		flush_anon_page(vma, pages[i], address + i * PAGE_SIZE);
+		flush_dcache_page(pages[i]);
+	}
+}
+
 #ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
 /* FOLL_FORCE can write to even unwritable PUDs in COW mappings. */
 static inline bool can_follow_write_pud(pud_t pud, struct page *page,
@@ -1566,9 +1584,6 @@ static long __get_user_pages(struct mm_struct *mm,
 			page_increm = nr_pages;
 
 		if (pages) {
-			struct page *subpage;
-			unsigned int j;
-
 			/*
 			 * This must be a large folio (and doesn't need to
 			 * be the whole folio; it can be part of it), do
@@ -1599,11 +1614,7 @@ static long __get_user_pages(struct mm_struct *mm,
 			}
 
 			gup_fill_pages(pages + i, page, page_increm);
-			for (j = 0; j < page_increm; j++) {
-				subpage = page + j;
-				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
-				flush_dcache_page(subpage);
-			}
+			gup_flush_pages(vma, start, pages + i, page_increm);
 		}
 
 		i += page_increm;
-- 
2.56.0


