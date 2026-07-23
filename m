Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2B0EC531F8
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:31:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 849CB6B00A6; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9566B00AA; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D51C6B00A9; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36C216B00A3
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:31:16 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BC8611204F1
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:15 +0000 (UTC)
X-FDA: 85020278910.01.9430DF3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4745C40016
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:31:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FWIGKo9+;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817074;
	b=7TLeuZX1DfUc7bCF0n4valAUJNmaTB1JoD45wT684C1GdnEwbQLjOjwZofWrMlhEIVTNOI
	LRfdYBlWc6NdKrQK+sSDyslW04iXuBfnJLBW8kB0FaPLO1Ii45uR1kcRDuO+4YlBuUs8S3
	MUPfnLN16n1fT+O7HW43C4nqeFn7Wek=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=FWIGKo9+;
	spf=pass (imf11.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vE4+w4YDu9n7GIhNK4fpCQW3h/DoqyUfQ4ETqQ3wP4Q=;
	b=AYQL6vbHC0QA03kaLUj7UP0h9v1B5HkuH2hVZcfvk/hd4iQe7OOHX3YOROVqoHkM4EOSV8
	YSmWym+OG3Qx7hHctbSDozVZKTFyi0RPqkNKyDHCuVL7BI1oBUE3TZTFwKARdHCqA/iwpX
	vrWVAyuwAk9VYS8l/TtbhUx1tYSrTsY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=vE4+w4YDu9n7GIhNK4fpCQW3h/DoqyUfQ4ETqQ3wP4Q=; b=FWIGKo9+zfnBtutgnryH3E5NSn
	RqNQ4rozFGMzQZf7dewKfC/HQk6yYfj6KNChiak1ZVnYyvrELs0jnIcxy2JEc4caqHRNT+ofRwEQM
	VAU2TLl2FHOP1kXkATIes6CJB4Wjc8VCI88lrMzWKj3bFrV+UJIZwMtP3itCwJfXdxCZxbGlH8jE+
	LbCb8f/ESXIRUTTxZLYCp8lL+aLU5YJSDi+w7c8Ig0/hBzVcXwJyHZbNcpP2AfdBOCotfAJ8wZPaA
	XEkvv5dZH6va+Xt0LzfcAGgdpYzzA+VMtIFMvoAnfg6PH/75Gqzd6GUbfR0+eML8e54xXTeMbeTM2
	lQ+PhiKg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRY-00000000jhp-1k2i;
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
	Jiaqi Yan <jiaqiyan@google.com>,
	stable@vger.kernel.org,
	Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: [PATCH v4 01/14] memory-failure: Fix hardware poison check in unpoison_memory() again
Date: Thu, 23 Jul 2026 15:30:18 +0100
Message-ID: <20260723143034.175661-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4745C40016
X-Stat-Signature: 533an6xudp8qgi8yu8upxxfozhc85otm
X-Rspam-User: 
X-HE-Tag: 1784817074-145880
X-HE-Meta: U2FsdGVkX1+t7WdpvdLN6IDYBDLoMHH3/QNQVe81Z7DCRCUFlrNqMDvaZmpcN1OqbC66ffrV3kQRzjEyD5VaaCDsKKEk0k8gLkEs7o7LTdvk9M+GMOf/2EdJ6SqFB5/TNZvJtv8CAow8EYH55bPfhfrgAdrgtlxdlDEKKzrmrfzBVq4vqbrZmP7r9q63TLKw9bPp4xNRVnpJkp3UJaqd+hADkW3GiJ7MhF8Wp5f9OYtz/PSugtsGvd81NoT+kz2HhYL1z18VkCdopasvL/cRpEiK2bc/xvfFtD9pnwWTidAjo2lwo++EY11FJXmH45k6SLfJkaEwv4f6BudHmWiyERJSFV5D6jUySVMSiSziSDjVxwJnQrt9vwAVodIXxm3DqQBTq7FohHLXcaW+AE0ciYUpwp04Tgphg5Di5pcKn0lTuY9R+Cqy9E5QBjs3Z1Yw7TyXG5PzR1Rv/PH4cIRenufK2gScNcapClVJEzDMyTtkGyriDuCn5TZpyjblgbJ2RaD4pd6gFoQefqWs32wpnJbDu7QkMnU/eyYSG5jI9Pw/ni2+N6CzGS4GY11tNoXG+jats9lVvSPorazhrr51jXkperki+Acf9OMiD+13rQCnGv0bzbnD7pOVc1l4XWDH50yCcwyYtz6o6N7AN0e1KVZYMDe8xbmecCB8qSC9A6GdqOzfgi0AgK6Rm23EO5/ErzA/Ov9Q0Rz+EQGCe3kU2v5svNB9gu/JrgLU2xr5sTeqjUCLd2GD/LNdV7VZ6lOyLuN/H+q9VxayPQiSQtX1mGzT2LoSyr+Xkx1HAfPqI7DEAvrWP6Q3hYox9ibeVDw7HkNr7fZGapwaWI6ETt8dSB8OlGuponLw1d+gKw4pjNod4PYzFLqIiz/AQGUhqUSHbD8q6BzRTClvhSqPaP3WEQ/kWPMJc70El4kn+QDfH7GyfUB+jksfzcM+XHcstcJFCbgXRKTpjcB2gLrxewT
 9XrPjt0x
 SbTxKD8aENhKsvSvZwMkr0vPMOQ7l5bNt9aCpgVXP+dmLIFzCGC/A441uLOO+rzCm0I9VixtDtbn7nu4BI7pH+EVxPrU5Yw4B9ItgR+HW78nPcdQeY5PldNjBvqbQmptxF+yeni4SR91eD3dCTieRbtcM2PmTn2wrrisKGwsDOVW6ybe7xA0Tdh2PBYY1Wtil4SsJRpz8hhMnUi+OvhXWsT2LCHqfWVCOImbQRik6y1XlvkMAgA/wE+devqxsNWBwTzmR8agO/gxiLGBiq570zY/wPP8x+2WdRZZ5qtNj/PQUnLYCWclNdUkCa2NyZwiiXK1iS5rKKmhvpRzUs93PHxIjXuH7FzciwJJ7SYVVycI18j/kxGwomqmiXu4yIxHxjPRov8KqsYp28dbJ1jUJ50s7tYdKd8KF5GBpB2bShrONrmCVcupREF0s0EUfqBDhru1V
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


