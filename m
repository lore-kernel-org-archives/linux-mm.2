Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCDEC531D2
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D01396B009B; Thu, 23 Jul 2026 10:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB1D06B009D; Thu, 23 Jul 2026 10:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC80F6B009E; Thu, 23 Jul 2026 10:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97B726B009B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 227241204EF
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:01 +0000 (UTC)
X-FDA: 85020278322.20.3E0D532
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7361A40007
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pwhzavDe;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/n4jiazelLpiTgYJB0ZgYwXnBRq/UdX89CcaDIshP9o=;
	b=FNUQvnhwTZ33VO1xP2YoLM0ld7ZqHPU+Y/6Mvd25qK7bwwlDde+rvUdbucZorLYI53Zr/y
	ZiwuPSzNQZFxJQ3+2LQa4wAzJipbP5iRw5ojbyOxhfwcmkJAsVgqtfeP4Ng4Eu07QHyfT0
	+79yrmfsppf/6ywF2vEJZ1SfCW+tKJc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pwhzavDe;
	spf=pass (imf27.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817059;
	b=R1udBUTAxOSt7Lkxvt4uVLGdn3IKtLa8OkhRcDf/pANFxLvUfkDQb7m05sBlMQBMiuIzGh
	QlY0qjTt/g7rZOznhxSvfsRHWLF6Vfj4veYrb4ukqqcFTy2Dn8JaYi2rBW6ikHBVSqTtAB
	4Xi26Co1Hm71gILm4hyfAxK6kRfBsNY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=/n4jiazelLpiTgYJB0ZgYwXnBRq/UdX89CcaDIshP9o=; b=pwhzavDe1yyHZzQJCVdREF8yIt
	6dvKRVzMTPV+l2cjAPuACtx32smDj/C62oBXEd9i+DwYc5E2la2Ldrpp8jiEBkdatDYilBfGOBpuP
	AddBdsAmU4yO4YIqFRL6j+LlmR7vcilPhS3U/X5ebYbA7zl96cvvMP5TnwiOq5O0TbbcxvIUkdPs0
	hg1qHnZlDL5nvjDkGYgKpJX2/oYqRtGB130tL7E9oUU91iTZlRdSC+ygsUEZPbnm18h0G+q8pbGZS
	gs4jdkPs80QwKhjbrplR7QQAorekprvbckspydlVINDaBO8EsHgdq3/FcyPMonB9b/gpXrrrVOxlH
	gNaDbUqQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRY-00000000jhr-2If2;
	Thu, 23 Jul 2026 14:30:36 +0000
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
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v4 02/14] memory-failure: Test the page is hwpoison before taking the mutex
Date: Thu, 23 Jul 2026 15:30:19 +0100
Message-ID: <20260723143034.175661-3-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7361A40007
X-Rspam-User: 
X-Stat-Signature: i655zunu7idcgnamhzd367pjs8zod73c
X-Rspamd-Server: rspam04
X-HE-Tag: 1784817059-432974
X-HE-Meta: U2FsdGVkX1/6YSaqJDRFaYFqMgso2bT3w7m6ebhdskySFbhrKgTXIPpo11TlO6C4AJ5+KfLYpXACg71Xsk22TaPet3q2vPCJrMIR/sZIwrdYSa3AJeESIKtn6PbsL95+CiRxzr8zWlrx+5UOZvX574cgU8kixMGq419GBncNQjty/cEwyxwjT9Vb2RLHtGfL0jwyfpFKxMcauqLQQxKvatc9w8mr82dXPFjm7TNJKvIN68CY+3i0mw2MbxCArEaq8BkbuVRU8JthvUpBFn74VmQAV0XPLQ36D3anxWe+Q6EbPequDKeZxrHFKli1JsZ2iyqaiVDvIWJRNFtUFj6N1/oSnIv5oCxsZnrN52DFJxUoOW34Yb6zwjK0GwOKjS8uNGuQBO3cnUB4ZD6fWNIkJvlfjWWemWR5XQejpgxu2JsZ5CfvQV8orZmk4Kcbwi1evry5HeOWjCR9laxrMWiYK7QEB+WQiY5oEDUdgQwvmbTJTHiHwfudmCPyOhpdp5SP+vn+9WkaK42IhggFvb1xGqf9Fq2clnIJ8rZ3VL41ZRmNmPW39nqAgobejS3IxKnmG0/LgGBvcnPXMqjQQ75pLC0uuBiqa0/v+/S2SS5/wLXq3v/xuk5D5nOtXWdtHs8Smj8gZwpAzmZuMc3T0UIVrZQjjxX7TZ6B2vDnsRjy0fPx3ST3lbA3+D4w4I2dxv5KUiiPH7rHyszf6h3AtfWvWRrTqWuSJy0mbTZU63hiwvbA7oLGSyzQCSv2ZViphZIqFtgyDvQZVthm6r7N0vMe0ZUFSimH8mffr/AvtDkHH7XoCCGIr7G6WroTK5WujI3FYtoB9+63fwWM9LBkTMe66B4yWVqfEHd5YZUKgeK+xnA/bUiGt9cC1Pf9Rez7lQPr55svCmmZWnVF7wE0nyh5AE3Jwi08RP0c8UbYnh+EN9fu7pFkXaYOLuYMP9k9/PCU49uH2tl2Hx4r3OyFk3t
 cVkkq2R2
 9MfdfC/AufI4FMVSig8sJBLRuJebzTZawLB9Ncfrr+8X3ItuPOKcMR2GymtMHQxv+8C47KIjY55QZDW54R0LKRW3jHqnRM/iFsm9OI99nLnZDkdZ+8CFwjbOLiKABAJ/pNWzVsbFg6k0DQD5eOKU3gyvSzFIp8sR7175/imve38kw119XbfXR5OQRFSaBxJ8cCcJ3sK4rbRmw5pvDJS5dmxYwlBMGluHnRiRyJpQ8BPLbCTUNritz7sfHPx3ZrNCRxJTK9dqyCOeQtv63OGeDbz3UwNU054gDtU9ittlg403w+OKy4VdXwGihYj3QPdmvAFuYjY2Vb5wyY/DTAqrsmGZs4GzBteZHjVLloMmAlnCuLkI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We don't need to synchronize with memory failure to filter out pages
which are not hwpoisoned.  It's inherently racy, so it doesn't matter.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 mm/memory-failure.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 944e6e1d4971..3615ced0a11b 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2677,7 +2677,12 @@ int unpoison_memory(unsigned long pfn)
 	p = pfn_to_online_page(pfn);
 	if (!p)
 		return -EIO;
-	folio = page_folio(p);
+
+	if (!is_page_hwpoison(p)) {
+		unpoison_pr_info("%#lx: page is not poisoned\n",
+				 pfn, &unpoison_rs);
+		return -EBUSY;
+	}
 
 	mutex_lock(&mf_mutex);
 
@@ -2688,6 +2693,8 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
+	folio = page_folio(p);
+
 	if (is_huge_zero_folio(folio)) {
 		unpoison_pr_info("%#lx: huge zero page is not supported\n",
 				 pfn, &unpoison_rs);
@@ -2695,12 +2702,6 @@ int unpoison_memory(unsigned long pfn)
 		goto unlock_mutex;
 	}
 
-	if (!is_page_hwpoison(p)) {
-		unpoison_pr_info("%#lx: page is not poisoned\n",
-				 pfn, &unpoison_rs);
-		goto unlock_mutex;
-	}
-
 	if (folio_ref_count(folio) > 1) {
 		unpoison_pr_info("%#lx: someone grabs the hwpoison page\n",
 				 pfn, &unpoison_rs);
-- 
2.47.3


