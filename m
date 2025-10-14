Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E2E3CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 18:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9243E8E0148; Tue, 14 Oct 2025 14:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AD2E8E0090; Tue, 14 Oct 2025 14:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74E248E0148; Tue, 14 Oct 2025 14:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 54ECC8E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:28:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D125C5C3F5
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:28:01 +0000 (UTC)
X-FDA: 83997553962.30.076EF8E
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf20.hostedemail.com (Postfix) with ESMTP id 168151C0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 18:27:59 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V6UMqDTj;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760466480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=LBBmR5pAf4HbXTBeQ1kPK+D1rmObAEhbuan+OuQ0JhE=;
	b=YjM8HjzgKVkg6fen30VKuFbfMGpmtjl72G5UonV958BD8fQW0MzBnleGUe5WtFpAS81ANc
	44f2BDVMPquK5QyZe3fGzDZ3zYi5pzwyT6+VPApAxez713PW5ZKkcflOTfldbv+GwH1iuP
	dH3x4EqNcw2mXEkHjsKxunhVVu2v9Ig=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=V6UMqDTj;
	spf=pass (imf20.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760466480; a=rsa-sha256;
	cv=none;
	b=QvsQUaFTHKnu9yYYhQ4+jZlRyUO80/W3BhQaETtA4WEUGSMvz26WnStp4WxiDajmJvv2Xu
	HiNQ4M/iTthRekN37QBD+V737g65osMH2v4PXsBN4PsQJIVQVmPmMaOa40avmy++csjata
	mt5oJtbdMC9OInZuYjzCYm4xNkViztQ=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-46b303f755aso49719445e9.1
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760466478; x=1761071278; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LBBmR5pAf4HbXTBeQ1kPK+D1rmObAEhbuan+OuQ0JhE=;
        b=V6UMqDTjNcCajZRm+HAZQcB1hOTuP+eSVO+epgLC8LBNQ6hw5kIl38qURw3R0qVWm3
         +J46RqChLPeE192YCguV1oCcSD9wjcbIEpkmoy9k35GzsVn3AP+aGhjnIPC+1+tZ95f1
         /HPUmC74RYmyuta3/22qi8uBeIBBfpeMCV4QP/QyY5o78r1tB0/GFvokInOhqGa0C6co
         7SRVQ0cLN3rWtFyVPUCY1LptG2ed7ifHxVjCzDabh4gRxD1pGFMGtM3d260yxHFNR5AU
         euIaC/b3Dk9MXrPHqDvf9ufhAekwliteWRR1Te+vb5zwpqqQYPtpA+c0SNEzmUOHHdo6
         24Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760466478; x=1761071278;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LBBmR5pAf4HbXTBeQ1kPK+D1rmObAEhbuan+OuQ0JhE=;
        b=Ql3vKhOBfq6isTOi/B3hCNmXiv4XTmo3RFNbqBFXBwdhaRSbTMbDshUAmMose4n2iP
         UpI4mkNrlSv1qWBFwhNLsu8vlb3kGeuAa/LX4bhgvbSwlPAjxUQw5DJh23DTBIha4Zw1
         vZMyrzRCS2n63qXKPvxc5SJQO8KFysKw0e48enkO5uVDZm8knW9ca1ZyFTfPpjfgRfo8
         UeUZK36P2wlhO946r68Pjvv7lAU7Dlgq9V8OnKX3iOPEBvJ0dzi0bGTc2W+ZULSIn75B
         uDpVUPlXb7m0cAFqdLTuZ6AJqMx/P9RMi7wQhYon8pdERLrVaMqq2mws4ZRllhAVhy2Z
         ZJ/g==
X-Gm-Message-State: AOJu0YwEnv4C9isYxLFpt1+WUR0W1u+I6Rk7CigSFNWOdlzh+t4R/PN4
	ssh8tn4FfBRfTuXUY9wTnghJFF/r2s4z8RAMj1MSNm09KRLa4ZxMVUUZGb4DJ8Nd8rE=
X-Gm-Gg: ASbGncvICoJoL5ndnjGKHJReu+1HFAipwSP5zdayIq2OKfr3TI+wWZY0hY+zUrS7mjb
	azj1Z+Pot48bGlFYoadnENT92lhHntUpWrvW3b6geOskd9IcP/yKEJQUPDMIcbKJyin6wVUvySN
	Im1YT6La7BFLUzyfzwYjY3LbOlOEudvfcq9nOJGXgq2iKlsBT2NlWLndHYHwspnD8y+6ADU8PnS
	Xz9I6loN8zji9Kg+lw2PZVf089w93hPnj/ZSlS8hgduzQiTVqnCX0EZu5YTV7tb651Axjuc2l9x
	RNlUBjsnW30OC+GyewI+cOPGw4qfxSH2+x6cBRuwfuLjHsq8d3VWowrLnJttiAVOEAbGvGuhaFB
	zBHvTojxyLWXWuBHDUWO4C+pYsndPtDVvpDcMoYawdG3ZfhS0GrT+4vQ/99OE8er0Lgw=
X-Google-Smtp-Source: AGHT+IHSJpI2+SslPqhOIWr8+fra5n1+waQpCkYtL5Nh0y1DMOBU4t5TaQtKsalwtXTnAPToZ83UfQ==
X-Received: by 2002:a5d:584b:0:b0:3ee:1461:1654 with SMTP id ffacd0b85a97d-4266e8d92e8mr18056477f8f.50.1760466477644;
        Tue, 14 Oct 2025 11:27:57 -0700 (PDT)
Received: from fedora.castlerock.net ([31.94.68.142])
        by smtp.googlemail.com with ESMTPSA id ffacd0b85a97d-426ce5833dcsm24789309f8f.19.2025.10.14.11.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 11:27:57 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Subject: [RFC PATCH] mm/vmalloc: request large order pages from buddy allocator
Date: Tue, 14 Oct 2025 11:27:54 -0700
Message-ID: <20251014182754.4329-1-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ey8nxu1m7rpoeefre84iifor8j17975q
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 168151C0005
X-HE-Tag: 1760466479-466175
X-HE-Meta: U2FsdGVkX18feVOIcku3g4SKN1OZs6L7csKHRja/l9rMr3bKHX0idwE5y4JzV/m0QoRrL5p6MtA7yKuj2+jCsjRmWj4Eu9ipfGg6wHs7oT6AcYnDh2iq1RMQf17ISONaNk5wnpQBbJqXHD4BqUEfhzxSTiEyTzp7JNABHA/dp3AC+uUwKuq1kX1WRdbNuoGPWh2k7EXDZskOt9fn3Uz/FIZhPEriVuCHSv1tJJnWHAfj2xP5BW3KVZia7iCMxzxyEZAZ6atgtr+G9FGxde6u35g4tfbZl+FN1NuOdmg4CUyI4mkyqN9mRpo5xiDWgczZFKwpgQJByPNbZGWqTaA1rekJ+lif9uvaUfguGQkVU+x3TdYMkV9HziSVd1ANbLCEKUVgA0rpCPQPYOuvmiaKLjUa0oHFJMBDWTzKcly4E3QLUzPS/3Pb60NkNM26++j3FbToDldAlBBgcmIUNb/v+d3cTy9F6x68ERAS3EsFZZfCX44nrEIDQr5SGYAAdyLntXtB+HlB3i/DqJT07TKRfV6V9/FZc0UNbQCeYOKijSzDlphzw8F6OfoSSEq4hwG13zy37Phu9ggAjUQViBdlNlbdEdYjSZAD6l0B/pPxK3RNdEvofFuccGNRIRfgd3S5HB1xtHx+ZntxDfzIFvbjEsWtiOwhnbtHKrnJKJ2O3/seOOcEExWLNQu6EPkHDpqbvybQJsei5LU0iw8I/ynAvFPCw6bNXr3JMqyjW9wtjwDZB3VudF4VEHKsMh5SMl2nSOJws1ZB2Zh8XGlnErYHiMprau08J4DKi1ClPnd2iDUnQN/ezKjV1r+9+N8OiC8kkHDS+qdFLg2Z1BKLrlfK0j5QqDvjaF32Z51uQL7DND1hkRY4M3eiL043dd7Q+5qfitY9ysNM+oWJvTOWolTO7+XDM7EI2etKK+aPUJRoweRNpEIxdSTE0wbG4JIC0HCE1XvKiQv5Er40VSCQUg6
 NFuLnt9l
 f0V3cMqIk0gZ+J5x1AhYkehcmvp0wU6Yu7w5CyvQzfroMAOvRMrxD9I9WtDUgNvRY2mANA9Uox2W2YOd2W7YBiPkIdQZiRvEirqiwpKO+h1/mWZhC5MwUTjwBtga/IhaCN3/jADgnYg+ulp6N/yp38OZ+/07tBhSvNaLT9bcHHa8BET8+cHCwgAAWaxpiQs0IdXNPdO0e7I/g1mFI23wCb2PhiRCOlK+LEr5Zr2ldA14sCUYqY+bppXCCWsPWLS7q3EyXvJFvr5whihkEPw/HDy6+fxilhTfCPbxr7Wu4z95DUFE6Y86E3e2YXjAixxiqnO9NxFTb5UfFFk2dTJFPYIRAkSZpxsjg9s6EeD2dcDQtEqnWta6rvBMjBJx9g84p7nD8PLMj5Ot4BEbNcSY0/5Y5KdumYkTQAaYex02GBeHEVNzoc+1vsLOZZHB9TgOMqobAa629U7ELQeQ83THbUbCyjB/5JCQ+2Rc6Ngy4nGZg+oPaow6OJ/JhXVEJP6CSjYH6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sometimes, vm_area_alloc_pages() will want many pages from the buddy
allocator. Rather than making requests to the buddy allocator for at
most 100 pages at a time, we can eagerly request large order pages a
smaller number of times.

We still split the large order pages down to order-0 as the rest of the
vmalloc code (and some callers) depend on it. We still defer to the bulk
allocator and fallback path in case of order-0 pages or failure.

Running 1000 iterations of allocations on a small 4GB system finds:

1000 2mb allocations:
	[Baseline]			[This patch]
	real    46.310s			real    34.380s
	user    0.001s			user    0.008s
	sys     46.058s			sys     34.152s

10000 200kb allocations:
	[Baseline]			[This patch]
	real    56.104s			real    43.946s
	user    0.001s			user    0.003s
	sys     55.375s			sys     43.259s

10000 20kb allocations:
	[Baseline]			[This patch]
	real    0m8.438s		real    0m9.160s
	user    0m0.001s		user    0m0.002s
	sys     0m7.936s		sys     0m8.671s

This is an RFC, comments and thoughts are welcomed. There is a
clear benefit to be had for large allocations, but there is
some regression for smaller allocations.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 mm/vmalloc.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 97cef2cc14d3..0a25e5cf841c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3621,6 +3621,38 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 	unsigned int nr_allocated = 0;
 	struct page *page;
 	int i;
+	gfp_t large_gfp = (gfp & ~__GFP_DIRECT_RECLAIM) | __GFP_NOWARN;
+	unsigned int large_order = ilog2(nr_pages - nr_allocated);
+
+	/*
+	 * Initially, attempt to have the page allocator give us large order
+	 * pages. Do not attempt allocating smaller than order chunks since
+	 * __vmap_pages_range() expects physically contigous pages of exactly
+	 * order long chunks.
+	 */
+	while (large_order > order && nr_allocated < nr_pages) {
+		/*
+		 * High-order nofail allocations are really expensive and
+		 * potentially dangerous (pre-mature OOM, disruptive reclaim
+		 * and compaction etc.
+		 */
+		if (gfp & __GFP_NOFAIL)
+			break;
+		if (nid == NUMA_NO_NODE)
+			page = alloc_pages_noprof(large_gfp, large_order);
+		else
+			page = alloc_pages_node_noprof(nid, large_gfp, large_order);
+
+		if (unlikely(!page))
+			break;
+
+		split_page(page, large_order);
+		for (i = 0; i < (1U << large_order); i++)
+			pages[nr_allocated + i] = page + i;
+
+		nr_allocated += 1U << large_order;
+		large_order = ilog2(nr_pages - nr_allocated);
+	}
 
 	/*
 	 * For order-0 pages we make use of bulk allocator, if
@@ -3665,7 +3697,7 @@ vm_area_alloc_pages(gfp_t gfp, int nid,
 		}
 	}
 
-	/* High-order pages or fallback path if "bulk" fails. */
+	/* High-order arch pages or fallback path if "bulk" fails. */
 	while (nr_allocated < nr_pages) {
 		if (!(gfp & __GFP_NOFAIL) && fatal_signal_pending(current))
 			break;
-- 
2.51.0


