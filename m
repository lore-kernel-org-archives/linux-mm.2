Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 536D1E937EE
	for <linux-mm@archiver.kernel.org>; Sun, 12 Apr 2026 19:00:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA4B96B0095; Sun, 12 Apr 2026 15:00:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B54676B0096; Sun, 12 Apr 2026 15:00:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A435A6B0098; Sun, 12 Apr 2026 15:00:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 93BF56B0095
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 15:00:20 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 36F6A1B77CE
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:20 +0000 (UTC)
X-FDA: 84650819400.08.89A5855
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7CA36C0017
	for <linux-mm@kvack.org>; Sun, 12 Apr 2026 19:00:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KlL8la5a;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776020418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mvDPhYjJQDEctalHIPWdJcEKhsWypa7EAGsWXRS6rDs=;
	b=0i64iYnx9uD6z+a4cxDZoRoW825FFFhilnRSQmSCevdrL7LS4X5JctKWW5LhP8WSxjDN/0
	ycWyoVOQ6PA5SvLMFgyLpBVRmhqzMO4BX22sqrIvZ6ZJq5jY6SvN7McOemciAgc2XqVtte
	Ukqp53wifb6wO8xjEMuPFtTluTHqg/0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776020418; a=rsa-sha256;
	cv=none;
	b=NqP0LPFT0AShhR9CTifnn/WCwuTgBQ9++gvRaHPuUnWiVc9cUa1+CNluEDvV1pMtjEtE8+
	0ltuJs4sERtLiY2Ic0Cfpn9TKZsosZYFJgkgwFM773C1e0GUgKu8MCyOpZhC8Hs6Aw76jw
	/PvM2y28de5WUtcJQLniBBlYPjpAakM=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KlL8la5a;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0743B61335;
	Sun, 12 Apr 2026 19:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EA48C19425;
	Sun, 12 Apr 2026 19:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776020417;
	bh=RyVlYvHfIoEn55OlunbAh+fxrKhxnjkmlCH/p959CXc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=KlL8la5at+fHsXlDhR6jR0X5V8H6/8FVTR+yOXU5z/cWgGlf1h/WCdGPT2F0BSEA1
	 yRnvhuRzT03Eq+b8yHvSeQCl8VqiBukTYccYyaXT+mDz+nKwu5mc3TlPaO4TVG8Fiy
	 TJVILmv9J1AqmSdx+/tWwt4Vf9FkD7o5cIiVusFrRWcW2IcnUfEr17iN7rSK0pdNGk
	 8uzQ7B+xMnQKa4kyT03u/FROye8ox4fEsmxvHzRbmfBwnotP7s4GoB3+KJJLYAlFG0
	 j9SnSOjXfgC89F1+wJYGQmWoA0AheD0UP9k2HyUZDrhAbC9RPCaWQ4EP417VJrf6qz
	 N8b0m+Bb5rWjg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sun, 12 Apr 2026 20:59:34 +0200
Subject: [PATCH RFC 03/13] fs/proc/page: remove CONFIG_PAGE_MAPCOUNT
 handling for kpagecount
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260412-mapcount-v1-3-05e8dfab52e0@kernel.org>
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
X-Rspamd-Server: rspam12
X-Stat-Signature: f33tnyh4esbm9xqmi4s8m8b9bkcttm9f
X-Rspamd-Queue-Id: 7CA36C0017
X-Rspam-User: 
X-HE-Tag: 1776020418-214208
X-HE-Meta: U2FsdGVkX1+rRO8ZEJmd9LmqrHi8njgoybajj6avnDU4/lDj9E6tvs5xr1vqQbJqQxfB0KJBrNcWSb73w2at+yZN2VoBd/cbCXWsJUnLe4NJjvj0FX7cw+jUM/QNxVwVDJpCfEQ/R7NXepvWu27qr25Mc35Klgosc19SbMbgTsThVufsCVWQnFFaxBJFu2fwxzmOvl8XWSD042tAqz7mBs7qvQttxyNgn6zucFSzQoUJbA1kd/J5Dq18XXs/5By5sw1aBLVAjjWKGfw+ucFQ1xKt6yNx2ipoEuRVMGORwR8CZR6/U8hvRcZ4wm99UcVw1crh4UBvS2mCXwXMwNmLa7OiMbMb6zO1YQsUBRVaEQP3o+C4MmvwPBtPFO6YBVh0VMJAEYf1c9lizMIGo5VbzsYi502S3T/iakzOELwratjszXw2H0qydF0aFT5Q84JSMsYMX7mLdGc5lo5crERMRpwZIgD8Vc7Vk04GIua6wH0qc0EBEY36OBLw4/NoepjH+zRkXtpI518lLiVHez0t7rE89LdlZoiF7Sqnit/j8p1yl0Z0lZ5JASG6tn5eYAY5HJ+M6DUG0PpCph9Zw7EJF7zWhhXMsss3dG9jkvjHN8EqkT+pAZ/4h8rnm+njsxpsNVOdO1b8YMF0xiypxnJ93Huo3sv7lYB0anCtkO6DgCIEUN7JyDVvJ7Aok3FShYFo/JM1vV3hJwkVZ1Cm/aupTimnk//gDWzFxQh6AKz1vz2A8NeLgeqsOwXf1NlPq0omU+d7Z9BACOH3Y3KmWoqsSJeFjkupnmVcWpi7hGBmZmOB7dreKGptcOSroiuX7a+EBrCC1hPhRtJzTtrzWU5VrKoLzcaddheGA5GsSwJEsAstJUUODd85A6QQqkF9mwRhTQVqyPWbuT/pkLh1YML2vcdeOeKLZcHvHrmztenuNwAEbusSFWw0YOKpFn7Jjf+C6nb+RdQ0CbrNYvP94qd
 2hytHwwH
 joZFlgTl17AiaoY8bw6U/B3Lk//NXhI0Rzh0Z2OfHReUzze2aDtNaigl4xXaGmvksqmRmrVXiNEPwcHmk9KvqWHKtzuLNn4tvexwEz+OF/PeQqB4O2pt6DumBFAeXZBFQNW9q3nBxJ2ox4NNMCPqfPVgwAGciPg1PuFWwp7Y6EPHv4/BFrC/RIL/H4f+abt4NfbhMnULF4wC3BeArKAxIG0RUef7ZbN3mr8Bku0HbZ/WElZ5GVc/jRDqXInsAn406Bsx7qNwes0BgEEwQa860KOf4nTOCOMNDqo1q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for removing CONFIG_PAGE_MAPCOUNT, let's always use a
folio's average page mapcount instead of the precise page mapcount when
calculating the kpagecount value, like we do with CONFIG_NO_PAGE_MAPCOUNT.

Update the doc to state that this behavior no longer depends on the
kernel config. While at it, improve the documentation a bit. "pagecount"
was really misnamed back in the days ...

Should we mention that the value is not actually really expressive in many
cases, such as for the shared zeropage or pages with a PFNMAP mapping?
Let's keep it simple, the hope is that this interface is not used at
all anymore, except for some weird debugging scenarios.

For small folios, or large folios that are fully-mapped everywhere, there
is no change at all.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/admin-guide/mm/pagemap.rst | 13 ++++++-------
 fs/proc/page.c                           | 10 +---------
 2 files changed, 7 insertions(+), 16 deletions(-)

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
index c57e61b5d8aa..f9478bcbb6a9 100644
--- a/Documentation/admin-guide/mm/pagemap.rst
+++ b/Documentation/admin-guide/mm/pagemap.rst
@@ -53,13 +53,12 @@ There are four components to pagemap:
    determine which areas of memory are actually mapped and llseek to
    skip over unmapped regions.
 
- * ``/proc/kpagecount``.  This file contains a 64-bit count of the number of
-   times each page is mapped, indexed by PFN. Some kernel configurations do
-   not track the precise number of times a page part of a larger allocation
-   (e.g., THP) is mapped. In these configurations, the average number of
-   mappings per page in this larger allocation is returned instead. However,
-   if any page of the large allocation is mapped, the returned value will
-   be at least 1.
+ * ``/proc/kpagecount``.  This file contains a 64-bit value for each page,
+   indexed by PFN, representing its mapcount, i.e., the number of times it
+   is mapped into page tables.  For pages that are part of larger allocations
+   (e.g., THP), the average mapcount per page in the allocation is used, since
+   precise per-page mapcounts are not available.  If any page in such an
+   allocation is mapped, the returned value will be at least 1.
 
 The page-types tool in the tools/mm directory can be used to query the
 number of times a page is mapped.
diff --git a/fs/proc/page.c b/fs/proc/page.c
index f9b2c2c906cd..bc4d7c3751de 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -45,17 +45,9 @@ static inline unsigned long get_max_dump_pfn(void)
 static u64 get_kpage_count(const struct page *page)
 {
 	struct page_snapshot ps;
-	u64 ret;
 
 	snapshot_page(&ps, page);
-
-	if (IS_ENABLED(CONFIG_PAGE_MAPCOUNT))
-		ret = folio_precise_page_mapcount(&ps.folio_snapshot,
-						  &ps.page_snapshot);
-	else
-		ret = folio_average_page_mapcount(&ps.folio_snapshot);
-
-	return ret;
+	return folio_average_page_mapcount(&ps.folio_snapshot);
 }
 
 static ssize_t kpage_read(struct file *file, char __user *buf,

-- 
2.43.0


