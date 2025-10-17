Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 636B7CCD19F
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 14:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0E4F8E009C; Fri, 17 Oct 2025 10:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE5CB8E003B; Fri, 17 Oct 2025 10:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFBC18E009C; Fri, 17 Oct 2025 10:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C4B98E003B
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 10:15:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B0785708E
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:15:46 +0000 (UTC)
X-FDA: 84007804692.29.E6A8BAE
Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	by imf20.hostedemail.com (Postfix) with ESMTP id 763831C0005
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 14:15:44 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=blFZLEF+;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=CDdAk1cr;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760710544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XznzYYQp85lnz56N/CEQHyV0F4DjobXqczPLHaaXFUs=;
	b=cmAfIS4/BU+/FO/sQQf9RUV20TiMh/y1k1WapMM0AYUl0Xa1GSGVLt6asODgBRhb8RUUUl
	cjpw/Fid0uzdFemtn6l7kfPM/lDIc72AUiGW7lrDRhPtUGQ36ISjAFy1pe2bUmiqqgVLMb
	qNgCWWILVXEgxFGdlXDhY25S8Aa3VzU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b=blFZLEF+;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=CDdAk1cr;
	spf=pass (imf20.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.148 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760710544; a=rsa-sha256;
	cv=none;
	b=7AJsTgpQhUmjJS4aXSxVTmnEJpc7p78q7hNY9JBPM9qNTTWsRQaRrC4KPF/GXnbJGqUWDH
	DGhZLyfvWmEXlf5/5fGCdJmtOhmBgJubGkMCuqn7mE1PVm7PfP5UOvUmQbfM/lURHCZkp1
	te3j/3cCFVzDM58hBFePWh/EIOqW3PM=
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfout.stl.internal (Postfix) with ESMTP id 753CC1D000CC;
	Fri, 17 Oct 2025 10:15:43 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Fri, 17 Oct 2025 10:15:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:message-id:mime-version:reply-to:subject
	:subject:to:to; s=fm1; t=1760710543; x=1760796943; bh=XznzYYQp85
	lnz56N/CEQHyV0F4DjobXqczPLHaaXFUs=; b=blFZLEF+mpvwVf56IuvrB7AVZX
	YdbDzZ6d+ArFIIaW4fVC6P8+nMxEKU0AWupeGvHnh+BOdzGdeVNXEWq0r8A29X4X
	GrNwPhYdO5eYXmCNUDpXUmRrVRfkFcvGvPs40PDjyhyLtqRO1h+CyJ+NeOvLd9lu
	ent+Xml4zsWg0qeZaq8sV8HFyI12/6FSTwGOuxLhkRVcqTidAst5j/fx7iTrxDiO
	5J5c7/LPn56tzKKjnRVsV6N8Y3Ajfr+CvSTW6VV57Uh3XD0oM2rxiJWg4Z7bjVEm
	Pl3DAHocwiolq9ghNvVHBAEPC1m0GTD9mDpGeudpVJ5lKPsLP21J2Z9LedTw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:message-id:mime-version:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1760710543; x=1760796943; bh=XznzYYQp85lnz56N/CEQHyV0F4DjobXqczP
	LHaaXFUs=; b=CDdAk1crhrSRyZG3x+5D9TDJ9rvUKnN6m4OdTZS1jQK7+aFB77B
	0h7OSWFP+Q6RXaTcdkFFgv94VjhWrghxckNcEzs90ESNJHbQPREhPBJUxLAf+qzJ
	9tmr/jw+jCk+rd9sc5AG+VbybpdcsqdYg18gFML5/S2vevvzEYceYz5MMpSnRjs4
	uiFp10FGv0P0QwPEm367L6FzIS0Gx0Y4b2fA5WUCpGLcaIklejGkr+Fz5rWnoHOm
	f2CE6E79BZq36Eo+yw6vScv8axDTuryaI9LZ7t4l0B//ubuJ0ituOG6oRxBWdV2H
	HrSKaf2ub/LAJAlgf/IBQ9oRiMHfUrsgc8w==
X-ME-Sender: <xms:jk_yaF2m6WVIDny7XIol6hEXLEkVdePN_7_LHGLLizDv5Do-AUoR_w>
    <xme:jk_yaH7O4BDI_8FkSHE0-VCvJP6SttIC6cweHu_IGai2hTS5Dm3miLeYgNCJK2pb4
    nS39fNi0gi8NicJ1Cd5pEmxodACMwU5ZPunavzb-2yx9GMyQcmXTdM>
X-ME-Received: <xmr:jk_yaBRZtpFam7tIpulsSusyFkjVL5WBLTTr4n71uDGoDKitdSVJ1Rt7rO5sHQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggdduvdelfeekucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgggfestdekredtredttdenucfhrhhomhepmfhirhihlhcuufhh
    uhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecuggftrf
    grthhtvghrnhepteffudduheevjeefudegkedttdevtdfhheefheetffelteeiveehvdef
    gedtheefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomh
    epkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeduuddp
    mhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunh
    gurghtihhonhdrohhrghdprhgtphhtthhopegurghvihgusehrvgguhhgrthdrtghomhdp
    rhgtphhtthhopeifihhllhihsehinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepth
    horhhvrghlughssehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthho
    pehvihhrohesiigvnhhivhdrlhhinhhugidrohhrghdruhhkpdhrtghpthhtohepsghrrg
    hunhgvrheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhgrtghksehsuhhsvgdrtgii
    pdhrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhgpdhrtghpthhtoheplh
    hinhhugidqfhhsuggvvhgvlhesvhhgvghrrdhkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:jk_yaMUiyofeomhY943Ti4ZnJHljHkikIa7UKk8iX7uIO097WX4qMA>
    <xmx:jk_yaGFidJZ3rvuFS8PqLtZd99iXxZmg2RtVEo7RVx15ResnOqKOGw>
    <xmx:jk_yaPfaW5pE7STkkp3FGK_bVohL1Zf-y-sv3wJ_K1M0LeQevxDlgA>
    <xmx:jk_yaPoyIxdduKb_WzCQWkNwKoY9MnhsGAtrzbtC5TpJbo46_0FKXg>
    <xmx:j0_yaMr17OULJE6LWUBJZxhKURYY8TtFzUEugu4jXiTwGlAZhyR7L3PC>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Oct 2025 10:15:41 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCH] mm/filemap: Implement fast short reads
Date: Fri, 17 Oct 2025 15:15:36 +0100
Message-ID: <20251017141536.577466-1-kirill@shutemov.name>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 763831C0005
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: dwfienywog65773xyggqasjht4apkw8e
X-HE-Tag: 1760710544-828323
X-HE-Meta: U2FsdGVkX18ZbDsgG7UvZ5o6NykvOfkqS5sXBYF9bqlnvD8Y7hO+gsCkbX1XOw/F+ZR/mG6M2lgrk/6oJEwJvhVHEdDGUhxMfowEHiiTnDRj7DdNe7cUXG+sCTMI4WBrTPomTj12GdfBKZk407QssICCLoG6Ge7KlaITr2somIblF8g+kQRL3JJfDt7pxiZxcFuQrc900Z6zF/KnWBQ+JibtxfbMgCrOxH0UMRxmBX1R94H2W36tMogvchUy87UvOOAtf3uxY/l1+7Ouull2IUqDt/QWbEy6lDA9ZhMoSM0QLLcJt9RK3f40Aqt+ww3NkPseU5HIp6mp2q3luViQdbM2ZvJWyRQHDmm7xM1nX+Yx4TzNJpB8qSg1bItFEXqJg5SXzg3OxhgnrkU+Dki4EXjsHH1RHkMWBmgPUqDHWsEJTGUndbSjYSBgNRubs/qtqQHs40ASfFCaGC/0K6gGghd/HmhemRrwrZWWwXB33iswAQmfXrYuQfFHJRpL18JU7nE/fJgVZbFaGaU/MtCZrsUZ8s91ny/PqJVUbdAZa/cZrJoiyZtvch6y2CuJ55tB37diOGEAC1NHU7PiE2Kxpv6vG/aqltsfZeJZzUDZi+r5QOT1AbSOB18fxbwAc/SUQA8NZ/tfSyU4VKfqZ+sscFqz82wQ0Y7JIhFLMg0bqX75qOcUyRRr324Uc27pwrLfVl1+vXd9VhUMNDJ/YoyF/3bJD6q86FdNVfm7uck1THsEtD1oIMPvFXKvv7DSfeCIEWoz/lCpLKu0TxO3lbGZIPxD68RHUPrJcqaaEpc1kRAF4MKj1feMY6wr/vHhhC4Rgg6JuqwAmSwhZ6SNaqb/4FJD7lOyNYj2jgOKHi60GoUDoGf3O3N3xRRqFpLWWt7ZCd4y1/iXwxa6C63iQhlllCxsdguZvdtaD9OHaJ6nyisQvnyYsLpAs5mVNMA0LiFaZls3krP2J909Xidk4Zb
 1Dr8Icfa
 pHFNUa7CrfUbFQpJ8O/cKeu/ptGqTYQYDZ3EdTIu94ZP27gjIJ/utfGuQQ3F6rWyvPSGDdm9pAg+60kyK2j5H2OsWB0srQ1NnUAmW0WgHGHMqcCVJr1h3mBIwnxHrsa1WFR6f2H+kUh4IQ/h8ij+qLTXpcKWXH9HWFa+zB1r3Mug/m5ff3PJF4qE11YG2/yvW6GHVCagXHQiEsJ5rSxLKELViL8YJAhWnnvhZku18tt8oFCfI5+XEqhXseIMakU/CoXlOoFPHOWbOECcZu3CK5yZUsBPBF3tzf7mLsKzcZLqb+WtEZBExlkcgVb4nITKEcS1P9Ywudtkh/T86eCzTw0hqT0nFuInNhBU0/zpCwiMExf0OCJlZhS4f0grU3fyJEWDGkcJJxm/NJQRMsgz7rMzF3B/hGkgMrAKy4rwodpVSsjlHlzXi6r5JD8lHpbKShhtJ3T5wh5NOKF7RxsoslhXDRlXzMeivw+lMk2xStiCTPQeCRv33EZHTkefYAjKrJvse
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kiryl Shutsemau <kas@kernel.org>

The protocol for page cache lookup is as follows:

  1. Locate a folio in XArray.
  2. Obtain a reference on the folio using folio_try_get().
  3. If successful, verify that the folio still belongs to
     the mapping and has not been truncated or reclaimed.
  4. Perform operations on the folio, such as copying data
     to userspace.
  5. Release the reference.

For short reads, the overhead of atomic operations on reference
manipulation can be significant, particularly when multiple tasks access
the same folio, leading to cache line bouncing.

To address this issue, introduce i_pages_delete_seqcnt, which increments
each time a folio is deleted from the page cache and implement a modified
page cache lookup protocol for short reads:

  1. Locate a folio in XArray.
  2. Take note of the i_pages_delete_seqcnt.
  3. Copy the data to a local buffer on the stack.
  4. Verify that the i_pages_delete_seqcnt has not changed.
  5. Copy the data from the local buffer to the iterator.

If any issues arise in the fast path, fallback to the slow path that
relies on the refcount to stabilize the folio.

The new approach requires a local buffer in the stack. The size of the
buffer determines which read requests are served by the fast path. Set
the buffer to 1k. This seems to be a reasonable amount of stack usage
for the function at the bottom of the call stack.

The fast read approach demonstrates significant performance
improvements, particularly in contended cases.

16 threads, reads from 4k file(s), mean MiB/s (StdDev)

 -------------------------------------------------------------
| Block |  Baseline  |  Baseline   |  Patched   |  Patched    |
| size  |  same file |  diff files |  same file | diff files  |
 -------------------------------------------------------------
|     1 |    10.96   |     27.56   |    30.42   |     30.4    |
|       |    (0.497) |     (0.114) |    (0.130) |     (0.158) |
|    32 |   350.8    |    886.2    |   980.6    |    981.8    |
|       |   (13.64)  |     (2.863) |    (3.361) |     (1.303) |
|   256 |  2798      |   7009.6    |  7641.4    |   7653.6    |
|       |  (103.9)   |    (28.00)  |   (33.26)  |    (25.50)  |
|  1024 | 10780      |  27040      | 29280      |  29320      |
|       |  (389.8)   |    (89.44)  |  (130.3)   |    (83.66)  |
|  4096 | 43700      | 103800      | 48420      | 102000      |
|       | (1953)     |    (447.2)  | (2012)     |     (0)     |
 -------------------------------------------------------------

16 threads, reads from 1M file(s), mean MiB/s (StdDev)

 --------------------------------------------------------------
| Block |  Baseline   |  Baseline   |  Patched    |  Patched   |
| size  |  same file  |  diff files |  same file  | diff files |
 ---------------------------------------------------------
|     1 |     26.38   |     27.34   |     30.38   |    30.36   |
|       |     (0.998) |     (0.114) |     (0.083) |    (0.089) |
|    32 |    824.4    |    877.2    |    977.8    |   975.8    |
|       |    (15.78)  |     (3.271) |     (2.683) |    (1.095) |
|   256 |   6494      |   6992.8    |   7619.8    |   7625     |
|       |   (116.0)   |    (32.39)  |    (10.66)  |    (28.19) |
|  1024 |  24960      |  26840      |  29100      |  29180     |
|       |   (606.6)   |   (151.6)   |   (122.4)   |    (83.66) |
|  4096 |  94420      | 100520      |  95260      |  99760     |
|       |  (3144)     |   (672.3)   |  (2874)     |   (134.1)  |
| 32768 | 386000      | 402400      | 368600      | 397400     |
|       | (36599)     | (10526)     | (47188)     |  (6107)    |
 --------------------------------------------------------------

There's also improvement on kernel build:

Base line: 61.3462 +- 0.0597 seconds time elapsed  ( +-  0.10% )
Patched:   60.6106 +- 0.0759 seconds time elapsed  ( +-  0.13% )

Co-developed-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
---
 fs/inode.c         |   2 +
 include/linux/fs.h |   1 +
 mm/filemap.c       | 150 ++++++++++++++++++++++++++++++++++++++-------
 3 files changed, 130 insertions(+), 23 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index ec9339024ac3..52163d28d630 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -482,6 +482,8 @@ EXPORT_SYMBOL(inc_nlink);
 static void __address_space_init_once(struct address_space *mapping)
 {
 	xa_init_flags(&mapping->i_pages, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ACCOUNT);
+	seqcount_spinlock_init(&mapping->i_pages_delete_seqcnt,
+			       &mapping->i_pages->xa_lock);
 	init_rwsem(&mapping->i_mmap_rwsem);
 	INIT_LIST_HEAD(&mapping->i_private_list);
 	spin_lock_init(&mapping->i_private_lock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c895146c1444..c9588d555f73 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -523,6 +523,7 @@ struct address_space {
 	struct list_head	i_private_list;
 	struct rw_semaphore	i_mmap_rwsem;
 	void *			i_private_data;
+	seqcount_spinlock_t	i_pages_delete_seqcnt;
 } __attribute__((aligned(sizeof(long)))) __randomize_layout;
 	/*
 	 * On most architectures that alignment is already the case; but
diff --git a/mm/filemap.c b/mm/filemap.c
index 13f0259d993c..51689c4f3773 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -138,8 +138,10 @@ static void page_cache_delete(struct address_space *mapping,
 
 	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 
+	write_seqcount_begin(&mapping->i_pages_delete_seqcnt);
 	xas_store(&xas, shadow);
 	xas_init_marks(&xas);
+	write_seqcount_end(&mapping->i_pages_delete_seqcnt);
 
 	folio->mapping = NULL;
 	/* Leave folio->index set: truncation lookup relies upon it */
@@ -2695,21 +2697,98 @@ static void filemap_end_dropbehind_read(struct folio *folio)
 	}
 }
 
-/**
- * filemap_read - Read data from the page cache.
- * @iocb: The iocb to read.
- * @iter: Destination for the data.
- * @already_read: Number of bytes already read by the caller.
- *
- * Copies data from the page cache.  If the data is not currently present,
- * uses the readahead and read_folio address_space operations to fetch it.
- *
- * Return: Total number of bytes copied, including those already read by
- * the caller.  If an error happens before any bytes are copied, returns
- * a negative error number.
- */
-ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
-		ssize_t already_read)
+static inline unsigned long filemap_read_fast_rcu(struct address_space *mapping,
+						  loff_t pos, char *buffer,
+						  size_t size)
+{
+	XA_STATE(xas, &mapping->i_pages, pos >> PAGE_SHIFT);
+	struct folio *folio;
+	loff_t file_size;
+	unsigned int seq;
+
+	lockdep_assert_in_rcu_read_lock();
+
+	/* Give up and go to slow path if raced with page_cache_delete() */
+	if (!raw_seqcount_try_begin(&mapping->i_pages_delete_seqcnt, seq))
+		return false;
+
+	folio = xas_load(&xas);
+	if (xas_retry(&xas, folio))
+		return 0;
+
+	if (!folio || xa_is_value(folio))
+		return 0;
+
+	if (!folio_test_uptodate(folio))
+		return 0;
+
+	/* No fast-case if readahead is supposed to started */
+	if (folio_test_readahead(folio))
+		return 0;
+	/* .. or mark it accessed */
+	if (!folio_test_referenced(folio))
+		return 0;
+
+	/* i_size check must be after folio_test_uptodate() */
+	file_size = i_size_read(mapping->host);
+	if (unlikely(pos >= file_size))
+		return 0;
+	if (size > file_size - pos)
+		size = file_size - pos;
+
+	/* Do the data copy */
+	size = memcpy_from_file_folio(buffer, folio, pos, size);
+	if (!size)
+		return 0;
+
+	/* Give up and go to slow path if raced with page_cache_delete() */
+	if (read_seqcount_retry(&mapping->i_pages_delete_seqcnt, seq))
+		return 0;
+
+	return size;
+}
+
+#define FAST_READ_BUF_SIZE 1024
+
+static noinline bool filemap_read_fast(struct kiocb *iocb, struct iov_iter *iter,
+				       ssize_t *already_read)
+{
+	struct address_space *mapping = iocb->ki_filp->f_mapping;
+	struct file_ra_state *ra = &iocb->ki_filp->f_ra;
+	char buffer[FAST_READ_BUF_SIZE];
+	size_t count;
+
+	if (ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE)
+		return false;
+
+	if (iov_iter_count(iter) > sizeof(buffer))
+		return false;
+
+	count = iov_iter_count(iter);
+
+	/* Let's see if we can just do the read under RCU */
+	rcu_read_lock();
+	count = filemap_read_fast_rcu(mapping, iocb->ki_pos, buffer, count);
+	rcu_read_unlock();
+
+	if (!count)
+		return false;
+
+	count = copy_to_iter(buffer, count, iter);
+	if (unlikely(!count))
+		return false;
+
+	iocb->ki_pos += count;
+	ra->prev_pos = iocb->ki_pos;
+	file_accessed(iocb->ki_filp);
+	*already_read += count;
+
+	return !iov_iter_count(iter);
+}
+
+static noinline ssize_t filemap_read_slow(struct kiocb *iocb,
+					  struct iov_iter *iter,
+					  ssize_t already_read)
 {
 	struct file *filp = iocb->ki_filp;
 	struct file_ra_state *ra = &filp->f_ra;
@@ -2721,14 +2800,6 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	loff_t isize, end_offset;
 	loff_t last_pos = ra->prev_pos;
 
-	if (unlikely(iocb->ki_pos < 0))
-		return -EINVAL;
-	if (unlikely(iocb->ki_pos >= inode->i_sb->s_maxbytes))
-		return 0;
-	if (unlikely(!iov_iter_count(iter)))
-		return 0;
-
-	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
 	folio_batch_init(&fbatch);
 
 	do {
@@ -2821,6 +2892,39 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	ra->prev_pos = last_pos;
 	return already_read ? already_read : error;
 }
+
+/**
+ * filemap_read - Read data from the page cache.
+ * @iocb: The iocb to read.
+ * @iter: Destination for the data.
+ * @already_read: Number of bytes already read by the caller.
+ *
+ * Copies data from the page cache.  If the data is not currently present,
+ * uses the readahead and read_folio address_space operations to fetch it.
+ *
+ * Return: Total number of bytes copied, including those already read by
+ * the caller.  If an error happens before any bytes are copied, returns
+ * a negative error number.
+ */
+ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
+		     ssize_t already_read)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+
+	if (unlikely(iocb->ki_pos < 0))
+		return -EINVAL;
+	if (unlikely(iocb->ki_pos >= inode->i_sb->s_maxbytes))
+		return 0;
+	if (unlikely(!iov_iter_count(iter)))
+		return 0;
+
+	iov_iter_truncate(iter, inode->i_sb->s_maxbytes - iocb->ki_pos);
+
+	if (filemap_read_fast(iocb, iter, &already_read))
+		return already_read;
+
+	return filemap_read_slow(iocb, iter, already_read);
+}
 EXPORT_SYMBOL_GPL(filemap_read);
 
 int kiocb_write_and_wait(struct kiocb *iocb, size_t count)
-- 
2.50.1


