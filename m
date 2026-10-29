Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C608606A323
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 09:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SAgxGMu6
Received: by kanga.kvack.org (Postfix)
	id BF70A6B05B5; Thu, 29 Oct 2026 05:19:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7006B05B6; Thu, 29 Oct 2026 05:19:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE4116B05B7; Thu, 29 Oct 2026 05:19:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 84EC16B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 05:19:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03701A7B47
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:19:37 +0000 (UTC)
X-FDA: 85375116036.30.C6EB56A
Received: from mta1.migadu.com (out-23.mta1.migadu.com [95.215.58.23])
	by imf31.hostedemail.com (Postfix) with ESMTP id CF20020002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:19:36 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SAgxGMu6;
	spf=pass (imf31.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793265576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y5DqlsJSx2CSlkUE3Z3n+eOvU/xLg1QHNnFKNsbZwxk=;
	b=PkOIMJgVj25UzepTbgSetOOU0gu6UfTVTBotGxuvm9cp4sMSkQSDSSLQwh+ZL8RNCqkJx4
	OaMY14bNz4vCj1OnTOPbJmmTvPzj9A1q30bD3BLipHQQeq0xDiEUdSoE2InUsSJa2nfL+r
	CAn2UrG5RB8mMee+yDWnWI04umndlAM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793265576;
	b=l9qrwHkpSH/FGUimxI9LFOvnZnm/H26lnUWfY/NCqG1ATGO2kI7HgbAWg5vHiSJQSmToIr
	3XmuaW/S3jNIw2rnsjRn11PJuBapGlJDY9m2MMRJMMhzD8i4UftT69cDoo2FrI3Wotv0aL
	x4s+m/2EBBR7k32hY7Q30ESaybPeOJg=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SAgxGMu6;
	spf=pass (imf31.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.23 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=x+a08qcEFqHo1AnX2XXnBe1LfbWeC5gjyBYD6IqL6uA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793265574; v=1; x=1793870374;
 b=SAgxGMu6K35FpvtoFJPfIi1yqhcDA5ylbYtXeldUjoSuZy4yzEg72HQie0vwuFbccfXNSVl1
 LYm2+U4R9uSQCmrE8Thtqh8MUjmf+HzaK2rGbqan4EOVlipx7/RruguDTkCr9rEiFLb/md9sKLq
 WBDBOIFEX8BY8I7a7jQ1/oxc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2165cf4afd9a859f;
	Thu, 29 Oct 2026 09:19:34 +0000
X-Mizu-Trace-ID: 2165cf4afd9a859f
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
Date: Thu, 29 Oct 2026 17:19:08 +0800
Subject: [PATCH v2 2/2] mm/vmalloc: reject NULL pages in
 remap_vmalloc_range_partial
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-vmalloc_remap-v2-2-c4705cbf26c2@linux.dev>
References: <20261029-vmalloc_remap-v2-0-c4705cbf26c2@linux.dev>
In-Reply-To: <20261029-vmalloc_remap-v2-0-c4705cbf26c2@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Ye Liu <liuye@kylinos.cn>, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.17-dev-39d60
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CF20020002
X-Stat-Signature: jbhuqkar4b3gf87j4zmasx6cyrq8hdgh
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793265576-578643
X-HE-Meta: U2FsdGVkX1+LrARPMVWAy2NsRXLowOLHNEOIBI3wSTJH4BkO3RBQI9mUPVVj/YtH6Ls8ekNPDZ0QyFBHdh6gbSUPXBuePf3207LualgA06LimMiTafO9cT/DNxZUonURO9xnHuPveSHKZZ7hiCGg/VxC/HgI6PMluUDWQrasXbaQoG91YntzD+YBS+YUAnBl4UUezPx0IHVIg53aAGP/M0wTjj3OBpfCvIJO6rf9GbDHk1agjV9JxeGjeX9fSVHQJyDHW4RmgntHteOeQLZJKJJP17ik/l/yGqmhUaOo8TpL/BcCI7YMamB+hhSwOda8o1kCjTWVcmWEp6wFO8odX3oQ/i9D65u4gmwkwqnKi717u308kyilaBagw+57HmzIco9dh4aEf537XO23mQQbhX32w2ZPvpdZ3zudcx/iYDy24j5HsefikCe1ru9bQGMnUsGziRjYYEPLIFpegnyz0iuIPkT+urRIDIQgVYjg8ZO0/7OieeN6m9OukJVNzud+lwThKpW+0bNzJr1BeZv1kZnBrScMTdcueuYKYyjpDWznYq5YYwVLllW/UCP0RFceK/pYiyyyangSdy3Y0xpRqQZiq9p7UaRSrMf1oxMdcUtIE4wyAdxgJBiFMgusk5UqIGlr4U6r21HAff3DwBKh791kmWbUg0MK1DxmjJuUyRpFw0qNS8Yeg2sJas7RKW9mzp2j6B19Gq9J0dP6BS2RWaF69HmL8c5tDOxrDfSpvfLrUp1diF0hXtzLbPukZLMvKkgMa64Fur3Bh1nNL8M7NMZAypdM31WElQK1i5rA8FxaGq9203GR8n19BLG35gn1ZHluZDT3bCEWw3/BdRzh+jhxvlgNGcKlL1eInvjt6dvrROE88hzX562jmHxmYVj/jlrE/UIOp1hc6sifuhWtdYYAX8DsllegG8FM+zFm48IYWmbUQ6Czvryz62Rtvc/cuU9EtUx0gAfXFoStIW2
 XO0lIX4H
 +W5sRk+M+h6luvIkbGPfqqsOokXe7CnAYtHJghKM7R+ZcIXFuCGQrWbWpDQmmlnoraUN7+APWX+PdehLQ7ge5GGt2dgUZwY/QT55YEPzK25fgsROs9snKR3bKbqy8EgJTHGgX2RraRBvDzqTB7+W9z9KIZlA8D4KGBA+kw7paYIhvH1ETa/cG/18ReqRK4P+rAMs08mfG/041FjCRI2PtS/wZcH4NqU4Aa68S1DONaDv8Hh6jZN83Zf3wG6tM0CvbPlYv95h3tAc9HROVAOzpdLTGUsMCLe/3g/FeX5kElVhIPSs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ye Liu <liuye@kylinos.cn>

remap_vmalloc_range_partial() passes vmalloc_to_page()'s result to
vm_insert_page() unchecked, oopsing via page_folio() on a NULL page.
The NULL case cannot happen today because VM_USERMAP areas keep every
page mapped, but nothing enforces that invariant. Warn once and fail
the mapping with -EINVAL instead of oopsing if it is ever broken.

Suggested-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 mm/vmalloc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index a888eca016a8..dabef40ea88b 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4906,6 +4906,9 @@ int remap_vmalloc_range_partial(struct vm_area_struct *vma, unsigned long uaddr,
 		struct page *page = vmalloc_to_page(kaddr);
 		int ret;
 
+		if (WARN_ON_ONCE(!page))
+			return -EINVAL;
+
 		ret = vm_insert_page(vma, uaddr, page);
 		if (ret)
 			return ret;

-- 
2.43.0


