Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA77C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7F06B00AA; Mon, 27 Jul 2026 14:13:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279B66B00AB; Mon, 27 Jul 2026 14:13:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18FC76B00AC; Mon, 27 Jul 2026 14:13:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E257A6B00AA
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 77CCC160173
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:43 +0000 (UTC)
X-FDA: 85035354726.17.D6D28EF
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id EB0CDC000E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BqNC1Mb6;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vE4+w4YDu9n7GIhNK4fpCQW3h/DoqyUfQ4ETqQ3wP4Q=;
	b=S/KD8N93F+3IovHmS44YQPWzC6PnJu5StuNmfOkB+5w9zIxW7bqaiTisyx5cFkA4Uhanlt
	n2osBCLAoDe7mE8HkXfpoR5Bmp/jje8XwF9UTZX2nMMa1X25gnlwp3lbDzHmQjQY9kJ+gi
	84qS0UJoQM+CQEcqbtg8Y7XNAlh/s90=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=BqNC1Mb6;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176021;
	b=g6851SP9uCziM+Qqmz37IrGUi0sCDnqR3RoWcXvORl7qfczea/tMQQsA8Rnxm8RZyOQbZ1
	7XBR7HnnmQ9B7rq2sbCn+c2wtnjAUdEO/Ilg/fnY9owCO54EwlHt/HN1E7u/aEexmoLnH9
	GmgHeRT4rI+aFD5psc9ZgnLFF2zzpTw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=vE4+w4YDu9n7GIhNK4fpCQW3h/DoqyUfQ4ETqQ3wP4Q=; b=BqNC1Mb6CX3IpIk1sdjIoEYVIC
	gbFGrRyiDq4/7YjpjwUNc+kcaXHP2BqjV/2bdZ7A9yLz26DRiE9fuoYdtLmNZvyPSagIsejqUraoP
	2GoLp7fnEgRcdQqw6M99mi+3bZsY6Onxv2wH4W2+nr2s8iiJfIFcRIBJs9VfHFv8rhEOlLF+fvRPc
	THehUdMHBj46N/C1pBEp5xPACz2wN6ZhpDEyqiiMCBXTypnvqosZ3nG8L7HVo/nt4ltX8tkQqu8ti
	ScZg2c0fcAKg+1MMiz4Pguecc9F08lHEa/Hl6uerEc+TF6x6fKqoV0+iXk5rTkRKYMvVGvmt10qxY
	Eba/mTcw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPp9-0000000BD7O-3fkE;
	Mon, 27 Jul 2026 18:13:11 +0000
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
Subject: [PATCH v6 01/12] memory-failure: Fix hardware poison check in unpoison_memory() again
Date: Mon, 27 Jul 2026 19:12:57 +0100
Message-ID: <20260727181310.2671972-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EB0CDC000E
X-Stat-Signature: wcgkqkufktnspgk9cesa6zkfufq1qdyk
X-HE-Tag: 1785176021-924509
X-HE-Meta: U2FsdGVkX19bffp7XsliLF9tXlWV+Y7MQBO/LM3XP0YkRk/ZcFPvK7YiP8K7rBiriItMdzKdirZVm/WOeYcHceIb5GrBHve+GpnSYMFfRvRdI8hOZ/c8eYecsVIuDwy199Xr9yS+LDhrWxJoBLLUUNuKFj1CSMu7lvNihG3LBlBAoAU5/cCS9wkaKIrlRYaq1iJ7Wdsjd+RmicUnMVaCjhQxesZHb9pQib5qG5A8pwMgc0ue0dtlJWf9r8fSLC4hNuSx0UcRCDaxwWX6c8L3q3qGAMPwlCqpnLpbNVppRw5e0rXcSSBls6vjYrSn6/shmotIYmJws37M+ij56arhiUVzr18to5WGUCGLfcNPhRjuxqeE7D2fawRJLHqLlf5x2cO8PVp5fnQuRLNcGIrUd4Zqp9hIafRfO64CZp1k/EY0qNYL5s21+msuNz1Tk7Tt++fHMAnj0zhb7iT3jJ3nPmMr9Ze0V101EG7Fcme6/I6o5H1Kw/6pLOGV8wm4fUW+Oo+xicC62Tt+i51/YtaQgGJy4F036wJMpd3dwBfiez0ilsXevdYl9ABSk7CJBNXxew8nSviazdAfdner7lt0DDU9sW//5lWyALCOFnnDYD9WTWfMmNW72snOuxM6XEgDjJYILMi8CT9RCFwEVAV7zm05Xe40wTSSTCxea5Y/7V+dE5e5wILMtp4XiuirSRW2a89uC7GiO7OHlE0xFm7kI9rt0cz1GQjY1DjjeJ4l9xvoDZIOIuRaMFm6sR3+vT0kAT7bk7ArCks4GtwqGYfvI68ofjyJNbs3rLycBpyxEmb7huipJrAvpPk11sU76viBKtNhd1k49+NoeaM9z2oq/fYZnjLxqBD+5v8B01oQ9asiEio3b+Q8igbKBKFMT/RLNBbjlloV9ZUSrdeinAF2e+kLjFab1bQeykrvl23LfyA2IN6Ljpd70h8BN12yMJp+0jwUcOboe4/4a0kGKVc
 WogF5IvO
 rSU0LbLGEo+CE8zvK6yIWORskUcZbuZW2ys0EoiEYJwYS21pB0NWMPNJL7VPuCBSB3a4xOr60OA3CjeSQl1GKAppS7Axxqip7ngqs5a5kHGpWMIHuy7VQkUNEz2QhDScZ5jQZIsa06N8sUBma6dJ70M25PuRKop/DZDSZ6W/dnDhBYHmKKWNccY8Ci0t+U0eTdfzonSSxS6HUhSgCK6LGS3hPA39pBHpVStN1TgLX3cReFRxfNORxMe+4wxt2bTIz6k6Mc3KJ6rzOKKGI2+HGEJfYnRS0AIeNKEaLLPDKHszEL5hPxBNtpCzoGleMZTgiaTwi0/uEPRv8RFAM0c31uJYvneHuCDp69VCUN/ODbY9TtXcneSip5yA8vQhzBxzcP0q8R/yrSHWgbF3BwMy//2QgERkRouMaumQL+B5sgkuxHSf8LOe4FVAJceChWa72LaD9
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


