Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F39C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 20:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C73F6B0096; Tue, 28 Jul 2026 16:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 778346B00A0; Tue, 28 Jul 2026 16:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692756B00A1; Tue, 28 Jul 2026 16:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 48CC76B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 16:44:18 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D3536A147D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:17 +0000 (UTC)
X-FDA: 85039362954.02.92DF7DF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4A1EC4000F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 20:44:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=K485cUMJ;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785271455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iHUcX5eQpRezIMY8oJMUAXej5RLYZlD3UOUjhTOMZS0=;
	b=yNdMG1cNncfj3PwmrpJiAZzyjY6NmKUMwgrw8ppaj9pRvBBi+ERZKtBDKac6MWOmpIa9lg
	HBvz2L0Q0rqWpqIo1r8NeHj4ZQP9SGD0H3Zunoc4JV0Q5EwtO+MpLbZS3oMBJ2ZAkYRwiu
	fWUTy2/xOGOPXXxa6JGbAL6+7lO6jG4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=K485cUMJ;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785271455;
	b=FBQnnqy3VW+sIQ3J/LqCVCx6lI3UWbw/tJokZh4K202NioCTKWlpqOoIn+FWckRAK4ThZN
	U90nMFM2vVQrCKvSpalw0QG/nomVFq9BZfvxM6fAtvHF/IJridrTlmsOK4tvQKTKKI1JT3
	/iDolANJfqlnE/ksIWnkexeQD9OlHCY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=iHUcX5eQpRezIMY8oJMUAXej5RLYZlD3UOUjhTOMZS0=; b=K485cUMJTYK05DM335AN7gCaty
	e/JwtpzzGi9ROGr40RuZ34lF6YBkQqyoA44fHYlQntagxBwnQUoHF/c0Krf7qMCDicc3f3skj0cKR
	8FFxmaxgZjYY0UPniF6RxiM/vqZrn9fc/3eEZUquMxcBHW7GHYh+KAGWeBPu5boqO3cse3rSewqPe
	M/f8xxyg/8GQxlzGIlCbWqkUBHWswio9Oan5Op9JzqTpZgRt2oK8OGV2R0CC/YF7mKUHrBTDtfRvb
	fXhJcuDhDV6cDExm+0AiIuxZJV9/3HBoWyzkIGgwElBsiU36UsWqrVbc/8lJs3tAQQ82ciPvHzTC3
	GHhmluyQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wooeo-0000000EFWP-35tj;
	Tue, 28 Jul 2026 20:44:10 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	stable@vger.kernel.org
Subject: [PATCH v7 01/13] memory-failure: Fix hardware poison check in unpoison_memory() again
Date: Tue, 28 Jul 2026 21:43:53 +0100
Message-ID: <20260728204409.3396238-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260728204409.3396238-1-willy@infradead.org>
References: <20260728204409.3396238-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4A1EC4000F
X-Rspam-User: 
X-Stat-Signature: smnazpqyidg9xbouhppsn7dhnq7sxgfn
X-Rspamd-Server: rspam04
X-HE-Tag: 1785271455-445826
X-HE-Meta: U2FsdGVkX1+KfgW/sVX3DtYX11HySjoLffhYoZkIgL8Azxca+GbDfIDqoEF44rpLteJhDnVemIreTKyZn6axIJPXAJ3BXMU4+Geo8HiYC8TdUl8PmH8umXlSHTfp4Rwkf8WFOpt/6D//J446zc3qvyvcbpasTqjYmljk3J5Nfrumpl+DHtWx6IBhJPjWqHKRYl55XcXr44um7bFimBtHqHlanOViIdsUjzpmkVoAT6DFn1qnHqKyxluUxuT47w2YsCO4dOu3ZM7Ttqn+fgC2fXEHuIke/alrtAF8CYr749tEfDpJOE7DbuRgEHGLiuN6dejh0CMRy2Jk1dOh2IW8mI+TYSLeBGyLSWpohv7NJOk4HZCuTV7eCIGCQMineIMS9jqrb4vkHoH1y5y7gyalNn6rt35x8t1dTsvmq0Ig/Se1xaJpLJqlwX86Tlj5ItlC5+s3/0m+rPvJ94esCOLif1XMsodn0AxF6Y7OzD1Ipbxk/azTwU2vKFl3tvApZEsKQdJlLPYbLW3Oi7vpojWRe+JURTefD6iha4CIBlcV8GXM/EO7NBOlNICPmhLeaIzBDlmCHRqrrhtmPpIcgyP5E7/7rz2kl0VWicdfn3xM9iQ+GcnbDi89W55ddN0arkePy4R4aBHPSW520YeZrHoVn6pNOqo3JG7UWh25NTaH0t8F2x3xDIGIFvNv9gmA8em/cu9j1bWgXS6D3HF0RJuSz9Ofskx/yGe+zcJK332jKvBn4434dIaJRq5xmVvgbtHjwYcb9SOQeBxmWXs7rBtuzazQldEYN8OR6c9xANeVic1+IUCkCwhQojrRMz/2+u78PcMvvE3o+Vv9eqxJ4+XuCGvHwul7Tdca+TE4OQ2ugYXSsF1OAiD/4owBkMvRTawOgFoWMlD+O9LiiPA0cFJ1aXcNGX29Cng/2LU1KsZMP3gkkT2VMo8DOSmOxsA4lB48sqUzHHZhdpQp25myiJa
 kFavOBWB
 F+gZsk5xrHMzxv1Iiy2TUKZDGFPOL5LIi4vd6QWQCbraKsh/9mJ3K3Jv1FcSvOQ18VuZGFSy7YiTdlqv0psjKF7Kfy3zpYkMHP7zmsqOMCL8YHwAQNVvzhdc7LBrMZcFMcOv8VE+SyiLE1h3iA9qmZe7xuAD/rV3WHfINJaD81dUmFoZjLc4xwve9xei3BqqXjTwDpzBxOpcrHW1JSecmVozBzavLhNn8lbVlWvZhjVjCEjiiJAeqL12qAUaALzuUKcgiYYuYYlodCQccOsJGN/seewbqhc41lUh381vKWVENDOPe9U5CKEravoOU4dTyEb8RAnET9cQ++19Gc5CkSuF7t231O/4SlIFe3/OlJG5SomOhokBI67rUHTXZWYsJaHfd9gCL5077EzqO/9RNh+PQrA9zOjuP1ezCeyIanOKV5aY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The earlier patch (6c54312f9689) that attempted to fix unpoison_memory()
was incorrect for hugetlb folios.  Before a6fddef49eef, we checked
the head page for poison (which was correct for hugetlb and incorrect
for THP).  We are currently incapable of unpoisoning pages (other than
the first page) in a hugetlb folio.

Use is_page_hwpoison() which handles hugetlb pages sufficiently well for
this purpose.  This is racy as we don't have a reference on the folio at
this point, but fixing that properly requires deeper surgery and this
is a CAP_SYS_ADMIN path only so this will do for the moment and can be
easily backported.  It's no worse than the situation before a6fddef49eef.

The other bug in a6fddef49eef is that we currently clear the HWPoison
flag on the precise page, which is wrong for hugetlb.  Fix that too.

Fixes: a6fddef49eef ("mm/memory-failure: convert unpoison_memory() to folios")
Cc: stable@vger.kernel.org
Cc: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/memory-failure.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 51508a55c405..944e6e1d4971 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2695,8 +2695,8 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (!PageHWPoison(p)) {
-		unpoison_pr_info("%#lx: page was already unpoisoned\n",
+	if (!is_page_hwpoison(p)) {
+		unpoison_pr_info("%#lx: page is not poisoned\n",
 				 pfn, &unpoison_rs);
 		goto unlock_mutex;
 	}
@@ -2748,6 +2748,7 @@ int unpoison_memory(unsigned long pfn)
 				folio_put(folio);
 				goto unlock_mutex;
 			}
+			p = &folio->page;
 		}
 
 		folio_put(folio);
-- 
2.47.3


