Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3275D232DB
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 04:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 405D96B008C; Thu,  8 Jan 2026 23:14:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6396B0092; Thu,  8 Jan 2026 23:14:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B3F16B0093; Thu,  8 Jan 2026 23:14:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6046B008C
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:14:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B614F1B170
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:14:00 +0000 (UTC)
X-FDA: 84311107440.09.9746F15
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1EAFD20004
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:13:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="TNIG/Gos";
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767932039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DMbIllXPZRvlt/Vq1jHDivI39JQ08MkhrR5WF1TvH2M=;
	b=rPw4TZVJL9BClCzZBQPzWw2sHMTM8sp6K4zW37k7mB2XE7ry1Zf4ZhCHb3/GW8GoJkeD+0
	1ke4Fwi5Atd2sqbPNy5zj3y577tzujWDdLguQMZXGovWdE96ixLSHseUKE0/JJtppJlusn
	5H1sruDJ1U13q7KVWa6YaovN3akn9u4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="TNIG/Gos";
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767932039; a=rsa-sha256;
	cv=none;
	b=fzGhJWh7HZ8GSo0kE7vQfivBwgp74FiYFIq9EITuVp8ub7SohvtJbqkiDXjlCettgdDpmO
	SPiak6tyKifBJPSd3x/5r0eKCm6I8DshAbpQtgq3qtYpeFXCGtI3RpAjGgv9A2mErdbK6E
	xL8ylhsNH1/JVBc2OQZa2q7oZAQNrKs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=DMbIllXPZRvlt/Vq1jHDivI39JQ08MkhrR5WF1TvH2M=; b=TNIG/Gosy2N8vxkkL1w8SxcGpu
	oYizC8kZLbTdRLqdJvWI5cPLbizAdoRPGH3i+d0Inra803EuYArZ2q1dmcNg68mszc1SiCDKC1XyR
	Th2098cnOWBF4IN3ovqmBGs5XH/eWj3ZELlAaazikFvy+xH/xKl+Y1NiA0agVANZHKiVKwMAuWSxF
	nW2wQG9Ia0YuPmuF79pfDWKc4VO9Gkj9xz7zmBl0OMkM0cKr+9nZ+mV9F1UOvb/mAgVA02SCrLnZG
	gR8fEIqhYEdpmdc5FQ2U9z3Pp14QiDqqL4KAx5UYSGXscDFP3IHJagfNmwH2zHbvRbwcW09QaTUxI
	AHweH8ig==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ve3sh-0000000GCy8-2Ucu;
	Fri, 09 Jan 2026 04:13:47 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com,
	Lance Yang <lance.yang@linux.dev>,
	stable@vger.kernel.org
Subject: [PATCH 1/2] migrate: Correct lock ordering for hugetlb file folios
Date: Fri,  9 Jan 2026 04:13:42 +0000
Message-ID: <20260109041345.3863089-2-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260109041345.3863089-1-willy@infradead.org>
References: <20260109041345.3863089-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1EAFD20004
X-Stat-Signature: c3xjixnaecqu84p9nqqzj81m6s81do1n
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1767932038-110797
X-HE-Meta: U2FsdGVkX1+/y8wvNSW94uInFd4xYAGp6SRfmYNSkUWoy92azbduktNZbShRYkaPkQTRs0eZWUxMJCYCcDlPWM+x6vHCxJLPTVsvTiybofwI5uRV9fv0eVWhm7DgsvttguhQdSg3tl2s8V8kKuMgLIklJxqt9LdrhmzvK5y//eiyF4rcgS6eZ8PaP2ZZndDwdbQelJ42b9hyKc9rUEZroAwPlpW+EkJCsSNwtUst+x61AD+HPwnYhN0yrTNsI+YI/VBxFoo72E/k1/sDZUg+qVsdVfXJMEAYwbOJDkrT/+K6rA1yysrR3UgyuTHkGGdHl50Z/ukjE+r7nZafq8dzbSEjcEkAI2YEh0EcQ+jnnw6FoJuMda7xjBG3SWEKZvS86DBcS+eOu2g6KtKF7l4JMu08ftuyJhYDijUukWX+5UL7yArbNkmeFPcyBQJTgRszDUyQzV1bz58rN4iO6jzthZFnJbKjxj+9Xd0DhBHnc25NrKX+EQxu9yI/v0k6bE7E5NfteuMk4wIZ+eouoz90N8Fx4gqgNh1PVBmH3MKVbLGdXxE7QL6W1kh/WbNZJVLoqWG02Oz6pwsWupL7Zgp+laGQjWx/nvYL+Cu2a9gg7dDMNUNl52AVdUh3hmmQG6ECh+fgGFpg6Tu64c2jTJC9JT0b9edq6VhUrSPZXX3QyLp7vpH8WbN0S2veYtwpktrxl2V9ookYXodyrGiVMbC8g2UrqjVl2UQTxkyV/u0dcFYnr68XUTtEN1yLMqObDmCzORTdX2ixJ75C0/e5A1avY3HiIQG6QCtPNlNGmbzr97JAeyqu1r21SuvUAie8kj4UXCY6Z96i9DYWQ4ZaogHHI0MfLpcbrzJDvZh3HGNo0/XRggimIY56LTQYPk3/28Juo7Ae1ihMmnp06ia3yA/FCsqTC25e7WSABoQ89AFvHQnh9n3NoI75ZAHLHeBviBMQEOr2POz+qbOg6p+KpH6
 NNBG5y7c
 vp+DLx2GpIYn72QCMIYtnUI1/gZ0EIyqz8eF+lC44bVQ2ZKyhCIRGmi7XW9WZUeAliBMPKLMhcHo3CcFpGxyb5BUaqKySMLRGiOoU54sOxeCY12x0hmCgWaq+TWYy8ESrQ/vexS71kmwZPzYOYQHb6O1y6lg7qhDC8zWMFp9KI0MRaf/qA9hhvnEJx66dh6NjeHedAV76yI8i2CiY7lWlvRNnBjH+ATOYBB3meLhHa6rESa2kOLxjNiGD2sdmRfpDV/kYgueFiDMU27JxF5stJ3Nxg39HlAvLo9VUGNwE0X+RyUCvYpFzSibYeJAPtiY1Jl1nbF1LJPS+6KOfeF2BVLiQfSIsD+k3N78zya9+oIo+1X8OPPkoFNwAOjc017XVM9OGLiUq/j3sRfvxlEv65qp5RObsWHXbUtA8kNrX3QkhEM8NcKrkcGjJyNZQkX+IIoy9f7rUax6KLrO0KvxQw0vYuA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Syzbot has found a deadlock (analyzed by Lance Yang):

1) Task (5749): Holds folio_lock, then tries to acquire i_mmap_rwsem(read lock).
2) Task (5754): Holds i_mmap_rwsem(write lock), then tries to acquire
folio_lock.

migrate_pages()
  -> migrate_hugetlbs()
    -> unmap_and_move_huge_page()     <- Takes folio_lock!
      -> remove_migration_ptes()
        -> __rmap_walk_file()
          -> i_mmap_lock_read()       <- Waits for i_mmap_rwsem(read lock)!

hugetlbfs_fallocate()
  -> hugetlbfs_punch_hole()           <- Takes i_mmap_rwsem(write lock)!
    -> hugetlbfs_zero_partial_page()
     -> filemap_lock_hugetlb_folio()
      -> filemap_lock_folio()
        -> __filemap_get_folio        <- Waits for folio_lock!

The migration path is the one taking locks in the wrong order according
to the documentation at the top of mm/rmap.c.  So expand the scope of the
existing i_mmap_lock to cover the calls to remove_migration_ptes() too.

This is (mostly) how it used to be after commit c0d0381ade79.  That was
removed by 336bf30eb765 for both file & anon hugetlb pages when it should
only have been removed for anon hugetlb pages.

Fixes: 336bf30eb765 (hugetlbfs: fix anon huge page migration race)
Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Link: https://lore.kernel.org/all/68e9715a.050a0220.1186a4.000d.GAE@google.com
Debugged-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org
---
 mm/migrate.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 5169f9717f60..4688b9e38cd2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -1458,6 +1458,7 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 	int page_was_mapped = 0;
 	struct anon_vma *anon_vma = NULL;
 	struct address_space *mapping = NULL;
+	enum ttu_flags ttu = 0;
 
 	if (folio_ref_count(src) == 1) {
 		/* page was freed from under us. So we are done. */
@@ -1498,8 +1499,6 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 		goto put_anon;
 
 	if (folio_mapped(src)) {
-		enum ttu_flags ttu = 0;
-
 		if (!folio_test_anon(src)) {
 			/*
 			 * In shared mappings, try_to_unmap could potentially
@@ -1516,16 +1515,17 @@ static int unmap_and_move_huge_page(new_folio_t get_new_folio,
 
 		try_to_migrate(src, ttu);
 		page_was_mapped = 1;
-
-		if (ttu & TTU_RMAP_LOCKED)
-			i_mmap_unlock_write(mapping);
 	}
 
 	if (!folio_mapped(src))
 		rc = move_to_new_folio(dst, src, mode);
 
 	if (page_was_mapped)
-		remove_migration_ptes(src, !rc ? dst : src, 0);
+		remove_migration_ptes(src, !rc ? dst : src,
+				ttu ? RMP_LOCKED : 0);
+
+	if (ttu & TTU_RMAP_LOCKED)
+		i_mmap_unlock_write(mapping);
 
 unlock_put_anon:
 	folio_unlock(dst);
-- 
2.47.3


