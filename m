Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BF11C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 742E66B00A6; Sat, 25 Jul 2026 12:01:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CCCA6B00A7; Sat, 25 Jul 2026 12:01:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5946C6B00A9; Sat, 25 Jul 2026 12:01:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 238D36B00A6
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:01:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C733A037F
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:08 +0000 (UTC)
X-FDA: 85027763016.20.C3334CC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id B9D90180004
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:01:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=K0+BwlvQ;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vE4+w4YDu9n7GIhNK4fpCQW3h/DoqyUfQ4ETqQ3wP4Q=;
	b=RQhrC2rbx7/ldBCtv2sc24uRFPwdOTwxB7OQpsrpdv5LwzIv1H9pW+DbK7tT2JfwerZAMV
	hO3VUIwNQrXzGvEL7KxP4+eRgYxpdGQWtp00OgKAiIqkLqmgsmqhx+ztrmauAtOkFzJQwb
	5pyveu75fHCqV2YGxUfjCDvBlE73PnY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995266;
	b=aMa9KwcCD2oTo4DboRT1NA+4RuC608E67USAut3wcm7b9bvyVywR4MyqaeRULom3VLAAmU
	VRKoq35GP/1dU6aXkteOzV4QD/7UJ6T7E2TFP5Fm73Xb49Sjm7I5xghykpComlNj7eRWmj
	Ck9sbg5vENmNXOcvP4+FcCEWK8dBe1I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=K0+BwlvQ;
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=vE4+w4YDu9n7GIhNK4fpCQW3h/DoqyUfQ4ETqQ3wP4Q=; b=K0+BwlvQru8VRTKFdo+d8i4CLo
	WNDazIVTll6eWp2HGZ2BVShFa23keBkBpmSPHV8jhtRuwlBpNxBuhdSR7qMOPR0TwWTJ8qs7+lmOx
	VX4JtrNeCbpMlSaLgetpYoz6Hb5mVuga1itqayrx7rl3oDDoOd/cQ5aWTlHxm9Vb5H6jF8xJ7s1Q8
	ZVZx9tLgYfyEX+V08eSLaxcUjyZKwyVXAsgR6iHsxayvlXtdbgVRVbh7OonurnB6UyB1Svme0E32z
	50aqiVX49vI3gw7a1neodIFd36vFokJt5OfRQDv3eCLN8vQU24xwy86qaRyJ9XgCXngCbTSUFvJvo
	hkg/XarA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnenr-00000006X7Q-1dIR;
	Sat, 25 Jul 2026 16:00:43 +0000
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
	stable@vger.kernel.org,
	Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: [PATCH v5 01/12] memory-failure: Fix hardware poison check in unpoison_memory() again
Date: Sat, 25 Jul 2026 17:00:29 +0100
Message-ID: <20260725160042.1557264-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B9D90180004
X-Stat-Signature: ddzgeec1zzgrsusb896xmwq3gdbw8n6j
X-Rspam-User: 
X-HE-Tag: 1784995266-499848
X-HE-Meta: U2FsdGVkX18ojwE05jYtKJ5c12cvsvzZCqFrQ5YZ6IZffutlUtM/BsAZ0liKkbn8XLa83LmQSVQjykmXnD66ZtEB2jSDO/I5bPooneiqqr+5tkUxoIrDjBdjaoKYVlriyWo6rVVD5EW6nAfPc4mQDGqx4/WdXBOmEu1gn5OhZcy3rrwm6VPE1Y2eypuO5vBBH86PZU1cRDbje+EaQZ7Yz7SidkP4wvobprt5OSF7CzN1G3TGlWOlf9WZB9y9apfo5IL7iN1NrpztP2mN++aYKhy+eYdhRP59PFeKACs2NH63614YBexArrw/5jDSTB9g63oLskA0uSiUW98W+Duw/vu6ybsX593jwEB73DeD2jXTdMLIsgEbWFwXmDX6qZlsj4L6zsmJJ1Xs9UkvcKrqf4/7XgU8tMfu9N0L2G3Un/JOCEAu7Pst4Dd9biq1OKWn5ejDJZtU0m5Bwz2l+T1JRUmP0OFVdZtGjgDqPYBSHyqJyMPrsWG0x3rfZBDYofOiy36ZKV0WzNRh5tXiRJ+HUB1QSRYH68fOAhdP+l/Eg3BA2GJWxJie0F4Db7K3GKFN4QojfzkwzZ1uZSmPCLl2RS9qGrKfzvl8J1cKW3Yp4ePOoE+Ft4cfxpM5l3BFkZRhHCwC9mgk0OaVTvyu2xJcXF+fNWcQWaBT5REqTlBK7X0n4QfiUWSzCFa2h3CJiDFic+hh/lWZh4nh3dbDq6ShvCX6gdwiVzOAKeBQGwKlP7Mb1iCyWojhYKk5nSGN2rwoX8ju7nIYipi47nVC371pHbWkG1ka0TLO0oqnYb8lsnXyPaRB1m3bJK/Lg3OyPGwwxJGKImBemRM/Dv/hg2sC39r/DNWwVcFk7sM4SvyNXnMaT4kqfuu0Bi/t+tcYV2TNm3cPjIvH2Pct0T33piXbrXD2TaD7r3mFaoBfLLWPYlJBMIUhYJoYPWl/cO+h/YYYkBm2y8eDWvs7MGOARcQ
 OawjP3Qd
 AB3kZyAXZU7D1YBhH5eKZy8Uj/HKmRIG3+rK176tc/stbQk9InRrV/LFAzPiGw/ycqPbuCxPU3f5ltjAbTmum+6r56wTyhBBM2UPsyAxXGNG4F4m5zqRU55J0I0qzCT400XEytYDwWAPNuD52a+M4zSoGu/HbPHgFsVL/kYx5GyTkMtkHk9vWl1Z05Co5SAtqGcDogSCyY9JrSE8My/jC9VEm5Y9GUz8ZXywS9eO+HcI8mWvstNcF8j3cpQyFHZi5Oc58j5WQ3KgpYg0vFLZ+bJm1Rb+EcqSgI0tmGofNcD9jU2OPd1j4AiDjikq2GeoRVD6yNnvqmGpj8wXSNFn1tP357B4Ugf88qgyVgY7QNGP0rWK9eb5JCJeZMgFiyjDD8VEV4I+ibbknwWQ6qnb5oFLNzrvGRiZeZ5XIl0RQ73obTUmAlrZYfKU0JipZNrgDo6L9
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
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
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


