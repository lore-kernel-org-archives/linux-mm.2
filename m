Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D06D8CA601D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 16:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8624A6B008C; Fri,  9 Oct 2026 12:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83A626B0092; Fri,  9 Oct 2026 12:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 752656B0095; Fri,  9 Oct 2026 12:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55A726B008C
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 12:55:28 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BFC03140439
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:55:27 +0000 (UTC)
X-FDA: 85303688694.08.62D09BE
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id A863520008
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 16:55:25 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oauoRI4N;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791564926;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AoLrYIs+uZdnBcxRlyRMY7u3KNMZ1TUqsOhaCJEqHdM=;
	b=WFyVxLXxYLyy472pq+VU9ZZ1qHUQ6eb4PWyu+zIdwsmIzgTJdttapHgKr8qniS4aMPJrca
	tBClwAzoweU4eTSRBb+mLp5e6D3+dr0/qDPPHRT80X+LmsI1fmh5ykfnRb7Hs4+jF+Yvr1
	8rU8IZ+YxcPLUMCqJtuHuPpXiuVoKAk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=oauoRI4N;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791564926;
	b=drR/GyQZsPGY7Oz/lkX0XfzC9goalTLFJIii0ix098PUFaYtlzx1tC4dEuxZOqChjyvABi
	5shzyoHDB+cjWquk/0ZXkHKgzkgJxPk92dwaBN9A8b/hTBiwTWlKJ8gx+EemTWqzx9/Dng
	GhThYw7x3W/rWLQuOtZkTHk92kfVj6s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=AoLrYIs+uZdnBcxRlyRMY7u3KNMZ1TUqsOhaCJEqHdM=; b=oauoRI4N0hhJxGmx/jikCQ+6RJ
	0tOLYEl6b843Y7DFsLazkL2DjCN3vT9ak4F69LEkTo15dOob88O/CFWluL+BFs8KT6BeOscx+r5zw
	IkEozsyEbY5wQdBaIxWWMx9IFMIBXu0fs3Pr/w6IC63wDs+rSeWma8QxnzeLJiRx2Tp3jFco4TeQf
	pIbLFvDLx3OWK8vbyV4/qqn8HBd4GfWHB/AFNmXpBP6kj6G014rvblWrG/u41xCOoUI0ygugQP/77
	Pe9ieImqhuVNjOpukHaz35eOnAmatNtq5A3eJDWh0HEEYt4VKuwkk8nXYKe2mWU+so998q3AKmIIP
	I9Va/BMg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xFDsP-0000000GDDf-27Tf;
	Fri, 09 Oct 2026 16:55:21 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Daniel Palmer <daniel@thingy.jp>,
	Tal Zussman <tz2294@columbia.edu>,
	Lorenzo Stoakes <ljs@kernel.org>
Subject: [RFC PATCH 2/2] mm: Remove add_to_page_cache_lru()
Date: Fri,  9 Oct 2026 17:55:12 +0100
Message-ID: <20261009165518.3863950-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261009165518.3863950-1-willy@infradead.org>
References: <20261009165518.3863950-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A863520008
X-Rspam-User: 
X-Stat-Signature: t6mj64jxpqozm383bdz6yxmjuk9dwm38
X-HE-Tag: 1791564925-97322
X-HE-Meta: U2FsdGVkX1+hrL0Y3phLO7v98P6BceooZ0+o4BnO5O1fAd0qWvkDECLKhMOm0qZH0dlLeScy/ZJGzKdkbhVYLqnP4odP6aJmG1fJkjFhRyPh3XpcrtRNeSetGdNSJpMefO3li4Ihp/n2meRk1UOaRIHbVPiXpy0AGw66AGZW3VPyDYCaglpH9SGKYHvDWKgBCOAGJvUGUOj2jq7mrM3aGMB4E/NK8FRzfmK/jobjysIBWfE296ZC01mw30hnDr9Rg2jRphaUGEPndbAt5x6c3cCshDn4HlmK3gFE/u2lc1ad+nl3gaptCN4s2zoK07fxirKrCfQN2XJ7GlgBSU4DAqCaO2FrswhmXoDDTjYmOnJJ7JUrxQ7j2SsUk1lopLBnx2VZ/Xw9QCh4RdT2/FqxIWld4NSXOAHyrpTLk+eSoTMLC3NCVZAL1IFdSJ0ZuzncWiY/2nHSmkbVsoarKMl386jRInhHO2bpCrufDq7SfT+Rzt9YyyqONT1IUx8c2AOaFupqxG9dU2gKhI1WUGiPzcfLdGn3+mggKv4gC/F0edHnQtEHYuYRkU9vdIn5Pn/DtFB8kGBykMxVy1CeQra81xwIoaSA3oGvX7NyFPiU63lez3qL5fUxxX/Knsu1ZTd2qyXCND5xAmp/TGsNOCo1Z6K4Z2P3XpEZFvwx9GG0ugEfP7UgYyEVaKY9iruu5rp8esOtDuGwbt7n32yaX5xcudDTASN9RjN2rYA6oJf00CBm3bt4K+H0Un7D0jifEGMY7w0C4eMaURmE/ixmh5A0oAr4tDtgrIgx9ccaeUe1fyXlzRyRR0U4738uE3JW2NfrZ469CLfzpQD4lq8MtPmFk26xlx5XXKagk2fFeSSxawHAKaurkQz48kmsjy0h1Q6zEMFCJnlVk0yHjgtaWBhU+WRc+ObsvNStbxK+a8gESz10H76UlBD0QDxSa1vyUUvApduBmva4uUTnz39t1dh
 XRWydZ2k
 to8E+ic75vzPdnX0LKJFby678aiDNLAjCse78GLyMhNxDWACDgaVRg/f0Zr7O0krUHpcgi77GHBb2vNN2aU9GayhEkkKVwabTImfH7SJ1QeuVYxWglgXyZCLIINHbGcx0Zi8lkeQaVpdtPvM8VkTb6/+0yjMe5RBAv5mXCBaRcil3DBHB5HZ9HDZ2bkP50X4LPjZCQvhClKawoOJu7/a+Z/8aDDp8jpT4AovvjbuHFV5vrvu19gznq/6TLqsgWKxr3HmBjzG9rJZBqKC0CDhpDKTfNO3NipwjJtRi/wsBmyRh7C0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This compatibility function has no callers left; delete it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 include/linux/pagemap.h | 2 --
 mm/folio-compat.c       | 7 -------
 2 files changed, 9 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index 0adfa6605653..42a4354352ca 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1343,8 +1343,6 @@ size_t fault_in_subpage_writeable(char __user *uaddr, size_t size);
 size_t fault_in_safe_writeable(const char __user *uaddr, size_t size);
 size_t fault_in_readable(const char __user *uaddr, size_t size);
 
-int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
-		pgoff_t index, gfp_t gfp);
 int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 		pgoff_t index, gfp_t gfp);
 void filemap_remove_folio(struct folio *folio);
diff --git a/mm/folio-compat.c b/mm/folio-compat.c
index 6212fdd6761a..054d76ff0917 100644
--- a/mm/folio-compat.c
+++ b/mm/folio-compat.c
@@ -67,13 +67,6 @@ bool redirty_page_for_writepage(struct writeback_control *wbc,
 }
 EXPORT_SYMBOL(redirty_page_for_writepage);
 
-int add_to_page_cache_lru(struct page *page, struct address_space *mapping,
-		pgoff_t index, gfp_t gfp)
-{
-	return filemap_add_folio(mapping, page_folio(page), index, gfp);
-}
-EXPORT_SYMBOL(add_to_page_cache_lru);
-
 noinline
 struct page *pagecache_get_page(struct address_space *mapping, pgoff_t index,
 		fgf_t fgp_flags, gfp_t gfp)
-- 
2.47.3


