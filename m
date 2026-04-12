Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 111EFE937FC
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:00:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786486B0088; Sun, 12 Apr 2026 15:00:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7372E6B00A2; Sun, 12 Apr 2026 15:00:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 625C56B00A4; Sun, 12 Apr 2026 15:00:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CEDD6B0088
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:00:52 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0FE058BBCE
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:52 +0000 (UTC)
X-FDA: 84650820744.18.4B72EE4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6847EA000E
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pwkJzGsa;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020450; a=rsa-sha256;
	cv=none;
	b=gcTO7jSzLNavaqQbm9WQXGE2NCWa9EqsOY4ZzqovzDYK6uUzJQ20lDeo7QsV4IG203XjKc
	3yJYPPLz+QCYh0KEcKzVi/+eTrOXLNkjHEgKke8nWu4aUJznLJqJMu5IZSvhOqIBsc6gJG
	d0viTJhle9MPFkbsdLCSK+GnYH/qmWY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j92+OQ99Ybg09uFpo3hGXbK/dhlC/+hXdw1nkXJ7kic=;
	b=kem+jHmjpeyyrvlCaF8Co402ZbgaEQXH1x8nLZSpggRzeBO7tv8CDEbbCFVOsB5Lv16W5X
	D2EQMcehKMoNtXPwDiAV93gqgzK5WPdfMRkW+tOWdvlZnbNdLTnvHJLnkcofo4PORuR9kB
	eskKGVUvw714SUMHhL9pdWl7qOZmW2k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pwkJzGsa;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF0DF6132E;
	Sun, 12 Apr 2026 19:00:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CE0C19424;
	Sun, 12 Apr 2026 19:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020449;
	bh=TsVZ6e4sn2FbkgFq2K8DRDubBw0VwKHbpvbtJYgoQ1Y=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=pwkJzGsayS+/jZo+nmmiIQrNnaxEr+SOQh4PaqC2CP88io1g96Coj60Z0D4Va39Xv
	 NyZXxGz5tGTTYxsnqgOha8cYbv5sDXQlTLswIdukhw9BvLxMDR95awZ3m4a6UBGArO
	 rPg/u3lq52tr12XFXLMEDB0DUSc2syhebLJfmO2XYVk+IHpKpxxqAhAU9oAZIU783o
	 OHo/7Up+ti46w21INDiL1Ct4VP6JRvWvaPxOEzp6P+i7mqkiNBKoijbmul+ADOD5c3
	 nxxZXaNu8Dm36XbmFuRiFDbD87rSbhb8w2bKGvjCqcSsS/ZhvZ2LvbPxkd5lARvBS5
	 VW1YnArficdgw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:39 +0200
Subject: [PATCH RFC 08/13] mm: re-consolidate folio->_entire_mapcount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-8-05e8dfab52e0@kernel.org>
References: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
In-Reply-To: <20260412-mapcount-v1-0-05e8dfab52e0@kernel.org>
To: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Jann Horn <jannh@google.com>, Brendan Jackman <jackmanb@google.com>, 
 Zi Yan <ziy@nvidia.com>, Pedro Falcato <pfalcato@suse.de>, 
 Matthew Wilcox <willy@infradead.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6847EA000E
X-Stat-Signature: ifqfd5cesr7qjrho5g7fg1sg1ejpe3qq
X-HE-Tag: 1776020450-318650
X-HE-Meta: U2FsdGVkX1/nB7gXOqiPchycBYc7ljDJWeXi6Lg97PWmUjuNqheKgxqudlKQtO1oq7HMj8q+XM7Oa+dDRGsisjuY/NvQoskdvvAvgtvmaRJhEyV+3GHfNWr/+jTXkAQxtBQ2d1+WFiEhnbWg8GM3MzIFFhtrQAvxPhodbYl1jZHFf4RAjJ0xh+sRW8VXGbLje7GsQpV5M+LprDrStxzoI9hoiTd2qAepUt+r3b81D2wzw1ulAAzgnfMIlQD7AomrVM9afR3fZWDWXbx12RFQqCDGL3LBHr6MUL6yDaTDay0Ew5noljgtO44cYACJD/Ix+dcMBIeQcuazEAQ1442sel93nsrE6j2y/iEKB9/YKHTA/B2ZM4+mk9fhMtNw2tk0Zpv3EI96n5vtaVIIn0B8ini3PEAejY6PzfiqzW9+P6U/Osd+gsE1jWjZUfDRGqL8R/wD+Ur1B9F4zU3nwL8EQ5ciNWTXob7K5ldeaOsIThau7akAC67qcZRHV511Ghp3/rXOMnR7AvbGwKaf0QLIALDiUYQN6/g9kT5tCb3+KrPkjw/DEa5muf45uFdQ79FNOgDp7nz6oL/L+ixufhaDS0V/ZGSdkyMZfrkBq65Tr3/a+XZB2wrKjzaXb4g2PciUBcQGA5LU4bMtRTxJbmbewhG0RwzBMzL1TlW46vvSTUoC8yCwu13CENPUkKv2NlIwONnL1Y3erzj7JOY/uu6/xAoFxxqvBCJa+lwhof3pzMpHlF9LahvWczENf1Uzfct8kG9XRjl6BsbMcy3WWinwjvDI6cWTorEAjC111Lj5uKvMN5fE6Nk7s3TuNAus0CcU1FWK3jD5KkJB+6+uJXzjNF86dbuGuKiVWKDCc5AvKjOY9EeHaQJyRp6ecska47tU3hpb+XRARXr/2VN1vz9ttZr/qkY5GUS9jNLVmDQHW0b5Z5h1rVB/+ahOGLOWs/RePRmgplPKWARUK9Sv+Y1
 7hEtvf0E
 4toIXW8oZuNYS285K3LNfaBshnru1BQ6/Wq+p+u1Yko29tsgKRGLtcVQY+P8UPlJ/tsEg+F9zkhC8cNEEneYnJKZzwcA5bb/qfb58yHAjpa6kXHSfLqrX0NvK6nR0RT4EQgoZ9WCUaXNTPA6sXp1WUm9e9Kw9USSOQfwd0tJjdbyDSmrF/Y2mTO+ZNmQ+tpIN+YxPo8O5MtAZA47bmD36ruJofvIMX8y9YCIVcNS3ecuBX/pAuqARdnW3wXKqm/Rx785n0cZDUZfplYQcD7xNRPqY0cZtD1xcIHEYsQv8MbtDoT73ZN1yxu4WqWDOTnnoPiMP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have some space left in page[1] of a large folio on 32bit,
we can re-consolidate folio->_entire_mapcount.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mm.h       |  4 +---
 include/linux/mm_types.h |  5 ++---
 mm/internal.h            |  5 ++---
 mm/page_alloc.c          | 12 ++++--------
 4 files changed, 9 insertions(+), 17 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 633bbf9a184a..1715c6ed14d4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1832,9 +1832,7 @@ static inline int is_vmalloc_or_module_addr(const void *x)
  */
 static inline int folio_entire_mapcount(const struct folio *folio)
 {
-	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
-	if (!IS_ENABLED(CONFIG_64BIT) && unlikely(folio_large_order(folio) == 1))
-		return 0;
+	VM_WARN_ON_FOLIO(!folio_test_large(folio), folio);
 	return atomic_read(&folio->_entire_mapcount) + 1;
 }
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 47b2c3d05f41..1e1befe7d418 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -452,9 +452,9 @@ struct folio {
 				struct {
 	/* public: */
 					atomic_t _large_mapcount;
-					unsigned int _unused_1;
-#ifdef CONFIG_64BIT
 					atomic_t _entire_mapcount;
+#ifdef CONFIG_64BIT
+					unsigned int _unused_1;
 					atomic_t _pincount;
 #endif /* CONFIG_64BIT */
 					mm_id_mapcount_t _mm_id_mapcount[2];
@@ -483,7 +483,6 @@ struct folio {
 	/* public: */
 			struct list_head _deferred_list;
 #ifndef CONFIG_64BIT
-			atomic_t _entire_mapcount;
 			atomic_t _pincount;
 #endif /* !CONFIG_64BIT */
 	/* private: the union with struct page is transitional */
diff --git a/mm/internal.h b/mm/internal.h
index 30e48f39d2de..53b20de141b9 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -868,10 +868,9 @@ static inline void prep_compound_head(struct page *page, unsigned int order)
 		folio->_mm_id_mapcount[0] = -1;
 		folio->_mm_id_mapcount[1] = -1;
 	}
-	if (IS_ENABLED(CONFIG_64BIT) || order > 1) {
+	atomic_set(&folio->_entire_mapcount, -1);
+	if (IS_ENABLED(CONFIG_64BIT) || order > 1)
 		atomic_set(&folio->_pincount, 0);
-		atomic_set(&folio->_entire_mapcount, -1);
-	}
 	if (order > 1)
 		INIT_LIST_HEAD(&folio->_deferred_list);
 }
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 8888f31aca49..1c09d79cade3 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1121,11 +1121,11 @@ static int free_tail_page_prepare(struct page *head_page, struct page *page)
 				goto out;
 			}
 		}
+		if (folio_entire_mapcount(folio)) {
+			bad_page(page, "nonzero entire_mapcount");
+			goto out;
+		}
 		if (IS_ENABLED(CONFIG_64BIT)) {
-			if (unlikely(atomic_read(&folio->_entire_mapcount) + 1)) {
-				bad_page(page, "nonzero entire_mapcount");
-				goto out;
-			}
 			if (unlikely(atomic_read(&folio->_pincount))) {
 				bad_page(page, "nonzero pincount");
 				goto out;
@@ -1139,10 +1139,6 @@ static int free_tail_page_prepare(struct page *head_page, struct page *page)
 			goto out;
 		}
 		if (!IS_ENABLED(CONFIG_64BIT)) {
-			if (unlikely(atomic_read(&folio->_entire_mapcount) + 1)) {
-				bad_page(page, "nonzero entire_mapcount");
-				goto out;
-			}
 			if (unlikely(atomic_read(&folio->_pincount))) {
 				bad_page(page, "nonzero pincount");
 				goto out;

-- 
2.43.0


