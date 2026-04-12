Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3562E937FC
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:01:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38E316B00A7; Sun, 12 Apr 2026 15:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340366B00A9; Sun, 12 Apr 2026 15:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 255E16B00AA; Sun, 12 Apr 2026 15:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 10ABB6B00A7
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:01:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3F93A8CB44
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:01:12 +0000 (UTC)
X-FDA: 84650821584.12.F810AFA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7CB3D180009
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:01:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iRr9aHWa;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdOZ8YTyKF+rLP+kL4O2mcLUo041KypUkSbmo8fdz1s=;
	b=qpCo/zwan2Ja0joiP6t/h5LmkGKtqSn4szITQRymDSWCJ51jDf26lXlFdu8HtjOuh00Cla
	PCQerGRGX0MotkHp6UyzU9XtKlhSSx1h17v0UFKVpx0zuHJ7+bHJXAwNOKtW5E6r86Mfvt
	pQds8D02W4abaJr0Mdg8yueYS6+alNM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=iRr9aHWa;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020470; a=rsa-sha256;
	cv=none;
	b=QaDkTP3FzTQNClfkNR+XB87xuRMF9/XcJR8zuNGYOdyMmPn8Fjsegs2wBRfPtqz8O9qJ2O
	qLQou1XBQxorTcuS5iRsYkRg71rdLRCuh104S/Ye9S63FxuL5ZTyO5OfRQDv0XknYKnQbz
	ZrSWNzkcjTeftY65vIS9fg/5C8OtzME=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8BD3F42A5D;
	Sun, 12 Apr 2026 19:01:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EC77C19424;
	Sun, 12 Apr 2026 19:01:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020469;
	bh=JZvLJcjv2gHfduMXKfq+mJwAx6s5YsFTAkgnQcxaWZ8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=iRr9aHWahhYBJDnSK4lcL93nbxXeh1H0DOCfQ3M9PZ2xMgUj97NCkumGeDCiyxP9v
	 oT+3kt1T/dyrZHEOIZlECOMCBIEiJUpdkMSemjLbuzq7qAOpEch/qupOm6M0JiD1Dt
	 rW3TF8KL0nFUKarTNHNLta0ujwL5itdjcrL+Pj3K7cwzRmKfDQx3xiZaxYTmxD7yMr
	 FPgIb7KZk9/riNdA0ehd6LerPOaFiwbPf7y3cVArZX5v4QAwYMsisneU9NxeHwzu/G
	 Ug24HXsQ3mPwPnftLqoO+iy071bG7XdjEOopTktpsA28fJyxFeHYZmfd0cCSXr5zAW
	 kYbKmvc9lQqdQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:42 +0200
Subject: [PATCH RFC 11/13] mm/rmap: stop using the entire mapcount for
 hugetlb folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-11-05e8dfab52e0@kernel.org>
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
X-Rspamd-Queue-Id: 7CB3D180009
X-Stat-Signature: 69k73dq7sunk467e67entfn93zsu1pb7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776020470-425951
X-HE-Meta: U2FsdGVkX19O6xi2flqecNBl7EFyX/1eZcEXO0/AQLTnqL6BQHs9Mzn+5mIz06G7oqP55QUKEroXY10t/xjVypiVnf8qUHelykwX2WtPD/vBf8tjCjX/ayNEoAJFhlB+I+aHBq8I62V4tCBcQXTdgZlOmvqCaV5/Ls4maXuvd4cyllJqLYEi4Bg2mle1NOvY7UcvrwJ3yfwS0ULusSy2ZS07yf0m9+poQwsPnv/sUJeVmc4MqzSg4SW187wU2gecFuFGIWLfFrJOC3WBeev4aTovJ6rsNV3EO7CMBRE7xJidLr5akZWR4k+eF5Ghtqm9SxTrU25tq2QWQOP5lHgQ3rnwCNWuME8AIlJMDeSXbyO3T0BErDqHJqEbazfLw6vNauVA8kVpiseGq/l6xkoB+3jIlXTlKd3rfSldxH4BsVB2uBjAfLwKI4e+Gj6tyabe7tMu430obHBnqECQiyROd6N2P2t8EE3tMUqZSHXYTOslHeSsO4t+FFhGBeRm+xfBGUvX276Asv3aoZFU+7nr7lcOOQFBFA9rX2t1gkdD400TW3UamnhweFMeS5ol9hvRNGifQDoYcs2or0R7YfopPLT1YbgC1ULmBjNXgV8FObUaW3z5Yqbr17CWjYxoTSOWBQOFqO3ZapyZ8u7x53prprw8ggYvaQrVxFNTotXCyONV0Szr0jGmw/QOxlGmatbsTePhAvTxZEFYnL+CYrTC4/DKlqaR+mHpJZyeB1obYNFAgsJMDPNHISiZGgmrXmdDirUOOhtPbfqN0iI7z5w+ngx5qtNDUUZ8E00X0Kgtc+ZPE/lye+grDHo6vrvoDrdfjtiJUebZEPMSiYcHtydfYcG21QRy1AHYoFC2rpqQATryC9ncMT8myqg+3JtaOZWaZMgE2HMybr1zVW/8WEQtk4+BLcgyChBG4sts/8+J3vH5wGbQJbYcamDdwekqJ/h8sLbwYypor+jB/dr6EmZ
 6gxkcFhw
 WrKD7NUoCz3/zUAC3md1WTmCYRtV4LSVvzBIZetH3i3nKtaWu+zCLj+m99yzWJLXYa7fnMhPm+iZscvGFBPPRSsEkKz8ZUhDP6zc2c3/PrI4lcjxceCfHEK1yjxXsVjEoCpF2b2gQHK5T0zA36CaLcsRYU4AV7P29+9GNQEjoghCGUakeuGGG6PSYiMYHeVgMp4n8J4/utOTbhCN2FLT6kui9mKHahYfzY4j96nKrRuefEscbnjTO41+WAAhim3MFGKzC6CjFhRgjm5fgaObPvNymzA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no real reason why hugetlb still updates the entire mapcount:
the value always corresponds to folio_mapcount().

As we want to change the semantics of the entire mapcount in a way
incompatible with hugetlb, let's just stop using the entire mapcount
for hugetlb folios entirely.

We only have to teach folio_average_page_mapcount() about the change.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 fs/proc/internal.h   | 3 +++
 include/linux/mm.h   | 2 ++
 include/linux/rmap.h | 3 ---
 mm/debug.c           | 2 +-
 mm/rmap.c            | 4 +---
 5 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index a5908167ce2d..1dd46e55c850 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -186,6 +186,9 @@ static inline int folio_average_page_mapcount(struct folio *folio)
 	mapcount = folio_large_mapcount(folio);
 	if (unlikely(mapcount <= 0))
 		return 0;
+	if (folio_test_hugetlb(folio))
+		return mapcount;
+
 	entire_mapcount = folio_entire_mapcount(folio);
 	if (mapcount <= entire_mapcount)
 		return entire_mapcount;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6dd906585420..3092db64a009 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1829,6 +1829,8 @@ static inline int is_vmalloc_or_module_addr(const void *x)
  * How many times the entire folio is mapped as a single unit (eg by a
  * PMD or PUD entry).  This is probably not what you want, except for
  * debugging purposes or implementation of other core folio_*() primitives.
+ *
+ * Always 0 for hugetlb folios.
  */
 static inline int folio_entire_mapcount(const struct folio *folio)
 {
diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 4894e43e5f52..b81b1d9e1eaa 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -443,7 +443,6 @@ static inline int hugetlb_try_dup_anon_rmap(struct folio *folio,
 			return -EBUSY;
 		ClearPageAnonExclusive(&folio->page);
 	}
-	atomic_inc(&folio->_entire_mapcount);
 	atomic_inc(&folio->_large_mapcount);
 	return 0;
 }
@@ -477,7 +476,6 @@ static inline void hugetlb_add_file_rmap(struct folio *folio)
 	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_FOLIO(folio_test_anon(folio), folio);
 
-	atomic_inc(&folio->_entire_mapcount);
 	atomic_inc(&folio->_large_mapcount);
 }
 
@@ -485,7 +483,6 @@ static inline void hugetlb_remove_rmap(struct folio *folio)
 {
 	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
 
-	atomic_dec(&folio->_entire_mapcount);
 	atomic_dec(&folio->_large_mapcount);
 }
 
diff --git a/mm/debug.c b/mm/debug.c
index 80e050bf29ba..82baaf87ef3d 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -86,7 +86,7 @@ static void __dump_folio(const struct folio *folio, const struct page *page,
 		pr_warn("head: order:%u mapcount:%d entire_mapcount:%d pincount:%d\n",
 				folio_order(folio),
 				folio_mapcount(folio),
-				folio_entire_mapcount(folio),
+				folio_entire_mapcount(folio);
 				pincount);
 	}
 
diff --git a/mm/rmap.c b/mm/rmap.c
index 27488183448b..d08927949284 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -3042,11 +3042,10 @@ void hugetlb_add_anon_rmap(struct folio *folio, struct vm_area_struct *vma,
 	VM_WARN_ON_FOLIO(!folio_test_hugetlb(folio), folio);
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 
-	atomic_inc(&folio->_entire_mapcount);
 	atomic_inc(&folio->_large_mapcount);
 	if (flags & RMAP_EXCLUSIVE)
 		SetPageAnonExclusive(&folio->page);
-	VM_WARN_ON_FOLIO(folio_entire_mapcount(folio) > 1 &&
+	VM_WARN_ON_FOLIO(folio_large_mapcount(folio) > 1 &&
 			 PageAnonExclusive(&folio->page), folio);
 }
 
@@ -3057,7 +3056,6 @@ void hugetlb_add_new_anon_rmap(struct folio *folio,
 
 	BUG_ON(address < vma->vm_start || address >= vma->vm_end);
 	/* increment count (starts at -1) */
-	atomic_set(&folio->_entire_mapcount, 0);
 	atomic_set(&folio->_large_mapcount, 0);
 	folio_clear_hugetlb_restore_reserve(folio);
 	__folio_set_anon(folio, vma, address, true);

-- 
2.43.0


