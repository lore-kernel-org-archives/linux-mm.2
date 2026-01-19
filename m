Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A16BD2ECF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 23:03:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACC256B0322; Mon, 19 Jan 2026 18:03:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8D9C6B0324; Mon, 19 Jan 2026 18:03:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0C66B0325; Mon, 19 Jan 2026 18:03:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 89C5C6B0322
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 18:03:14 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 42C8B1A0305
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:14 +0000 (UTC)
X-FDA: 84350241108.25.3C50357
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id AEFBB120003
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 23:03:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=quVR+O3k;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768863792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1HcVacPZxe1iaKXunooY4kan6L5QaBRlQ69NVSE0r+c=;
	b=rXADdXtgReYECCRnvYFJgFoHNxWkGa7E5r3ouqM18dgvQ1Q0ezsUuhNYBYlSikNFvYTg7K
	YeJ19pKpRLgvG86G5ofE4/Tai3/b4F0miN7TETgOzJbA6uTH5OO+oSwzZ5HZC4Z8O734kt
	Ly9fQ6rAtA4geYuqsHDtJk8PFmQ2V+M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=quVR+O3k;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768863792; a=rsa-sha256;
	cv=none;
	b=W4P9bmyMLizXRgLmNDy9UyN0eQt7XuJsa2Nd8AJcjSUvloiDJc/Hvq7syEcekLfnVBM5/A
	mIxagY3pluwg6D6ToIA18V05iCpnJ63H+FuU5uBhuldhPX9f8Bu9O1Jukg3VYoF11BQzDv
	vGSbcAPkrY3QfkRDWBRjN0i6DBSHfqs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 27E9760152;
	Mon, 19 Jan 2026 23:03:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D84C19423;
	Mon, 19 Jan 2026 23:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768863791;
	bh=9+IQR5WDIB0jdvtNuLpX+r92qeOLZrM3xsnr4jLPT3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=quVR+O3kmNVg+5kCP3gsApos7tcKXyU5nQWErVidQm/UYqerGdPB7CnDW0Yw/Rn8U
	 DNFm9sEx96tM8FUQ5/U65G9jxtuBtKC1M+1fV5fezDXwciHUZV5PvD3+3nwa6AhUWb
	 oxHQrOO+KAmpBi7iF4WVwa8A3pr+DGuK8euvz2caPK6MEFEoQWoUrJCmRuG/3twM9l
	 pybklGrw2t4pUH6JWYfh9SbO/DubCvLonb34sekUJy/nyzBjBD16a9SK2l8pIzXpwG
	 50NkwEfYodwYwicj6e69EDG5crcButKepcpVF5GgnJTg6S6XC93tL1TGe0j/kSIWpM
	 +WYXqkWI1Z1VA==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	linux-doc@vger.kernel.org,
	virtualization@lists.linux.dev,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Jerrin Shaji George <jerrin.shaji-george@broadcom.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH v3 13/24] mm/balloon_compaction: remove balloon_page_push/pop()
Date: Tue, 20 Jan 2026 00:01:21 +0100
Message-ID: <20260119230133.3551867-14-david@kernel.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260119230133.3551867-1-david@kernel.org>
References: <20260119230133.3551867-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 4qyudsdudq64yuyjun7g4ykrxi4grrcn
X-Rspamd-Queue-Id: AEFBB120003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768863792-124145
X-HE-Meta: U2FsdGVkX1/zMQU6os2Qa3zN/is/kt2YMzmxf+SJbvugGFN/nhcAoe73x9WCdp/vKv1zAI3XKsES/dIai2m2ekUcudeSjfQbsA7w4GtGZG9RFPu9M9Ttq0wYHva8VdmZBMR473bLBgnfqMsyUNbCUaFSFSHtIbuHJQ/TFm3OJtIcuywM57bUfI8VolCw9ysVGKdnLq1Ixw7UiygLUPYstfFpwil6djA6zTzfA87WkFEy7Uq5UfQtz5UGcZEjjO3TH0e5EHRwsApW+2L3C6JvxUn/E6GUcidN9JKi98NcHmuaTN7xN5zNUt0gV5Zo55ATUXXwVkRz3wcougAgtqdM3yoZ4AsWBzGHWtbQViYTjoD7D6UB0pBr/Lyu/p/2xhb01a3Cn9SXFmN/W1Ny/k+/yKKX4HI5rRXhHDiEqpTNtIhPXr/X61fmPL6/OqYBYq0938EtgQvxYqWhLQari7AgIUah0OWEvbJ68MYI/DiNkD3+CW2MBErqt1LGC7tmobAzC+b+of3csbq2veAVCifjRy3Cg2xsPbyV86ZA9/XroQ6ZWUIpZPShfJ5lJKDO2V1RgBd+UNz0NVfgRpQML1egwt59BND/e9lbjx3edCB6lLMq0/yGbX6i4Qv/sOQxRuw87D5ucCbgzYXo/t3wYsL3AL4zmWaLBWTuDyGXSXqhDuwQYAxGkbflR9gFLLydZOAHDjr48m7sOWi7clIQVWNGPNfFjkRX9BS8x02fiTnBzL5b+4FtAD3fYI1WtvQY19rcOZ+nV2EsNDmlUMTXdmzJ4ZUbhAnIoORYDXsV3mawuvc/REocwrbvXcia7UEWV8lfN1V0g0pj+sFdMTm6Jv3Tu9YL/en+G6Ac772dHx1POEptBT+k6MYmzoBAuDpO6QMAYOIsh1pIrOKNfPBZfKtW+40si/jB7j9bIlcPgNM4CgNOwkh2/7EQnm6HsT0lEMSCtohpuYSUQlmYekfe6n+
 j01XGq37
 m8FXQC75FAWnZ6wJ9brXKxE33Ji4m9xqdUnWhLJj5/cV7j6JMsQKpY25K6yJ3InKu/lch7nAMgwg54hz4kIAl1B7tQwZ7UHaTL5VjQxpn+21hluv1NeDxZv3TaDCbTypfo5C1zkeQuMJnIzp0+vsD4/PQWG2ggL6mEhEQ56dl7cAusHR809JQxkic5vTONNbS83jDLD/01BriALqAEWWo+VB6jjz35XucrvuRnFYDvFN64rBmPNpJT9OPSqSuSc1dGE0rIRG9e28oJhtGcHpPCl26g7Lj2QEXSS45
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Let's remove these helpers as they are unused now.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
---
 include/linux/balloon_compaction.h | 30 ------------------------------
 mm/balloon_compaction.c            |  5 ++---
 2 files changed, 2 insertions(+), 33 deletions(-)

diff --git a/include/linux/balloon_compaction.h b/include/linux/balloon_compaction.h
index 1452ea0635245..e5451cf1f6589 100644
--- a/include/linux/balloon_compaction.h
+++ b/include/linux/balloon_compaction.h
@@ -126,34 +126,4 @@ static inline void balloon_page_finalize(struct page *page)
 		set_page_private(page, 0);
 	/* PageOffline is sticky until the page is freed to the buddy. */
 }
-
-/*
- * balloon_page_push - insert a page into a page list.
- * @head : pointer to list
- * @page : page to be added
- *
- * Caller must ensure the page is private and protect the list.
- */
-static inline void balloon_page_push(struct list_head *pages, struct page *page)
-{
-	list_add(&page->lru, pages);
-}
-
-/*
- * balloon_page_pop - remove a page from a page list.
- * @head : pointer to list
- * @page : page to be added
- *
- * Caller must ensure the page is private and protect the list.
- */
-static inline struct page *balloon_page_pop(struct list_head *pages)
-{
-	struct page *page = list_first_entry_or_null(pages, struct page, lru);
-
-	if (!page)
-		return NULL;
-
-	list_del(&page->lru);
-	return page;
-}
 #endif /* _LINUX_BALLOON_COMPACTION_H */
diff --git a/mm/balloon_compaction.c b/mm/balloon_compaction.c
index cf4d931763920..5e1507a13a52f 100644
--- a/mm/balloon_compaction.c
+++ b/mm/balloon_compaction.c
@@ -128,9 +128,8 @@ EXPORT_SYMBOL_GPL(balloon_page_alloc);
  * Drivers must call this function to properly enqueue a new allocated balloon
  * page before definitively removing the page from the guest system.
  *
- * Drivers must not call balloon_page_enqueue on pages that have been pushed to
- * a list with balloon_page_push before removing them with balloon_page_pop. To
- * enqueue a list of pages, use balloon_page_list_enqueue instead.
+ * Drivers must not enqueue pages while page->lru is still in
+ * use, and must not use page->lru until a page was unqueued again.
  */
 void balloon_page_enqueue(struct balloon_dev_info *b_dev_info,
 			  struct page *page)
-- 
2.52.0


