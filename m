Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81A58C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:09:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BFE76B00A3; Fri, 31 Jul 2026 16:08:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 197AA6B00A4; Fri, 31 Jul 2026 16:08:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D4F56B00A5; Fri, 31 Jul 2026 16:08:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CDA286B00A3
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:29 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4C7FBC0144
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:29 +0000 (UTC)
X-FDA: 85050159138.17.25766C2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf21.hostedemail.com (Postfix) with ESMTP id CEA0C1C0011
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="j/mFcgrg";
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57pqVUBnNmX4cL7er9o4/zfu8e545pjnuaBSHsFeFDE=;
	b=ImEmA/dYaVW5fbDJa01Ppy2r7jg2GEk76aceCHzAmfrTs9Rvt0ogqEHPL6w1+XynARUcCW
	tkNuFsfXN7xokeRv15Oxvcjy3PweRUkwsqxQoHBlv1cRC3A0yrkVlGX2+g/82L6XQ7MToG
	BqYj+dTquX+hZYeOvOFDmPMlLzAZuXo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528507;
	b=j/c1YwBpfVAEVwrBr2YWkMuA1bt1shI3o9xNT+jMObQoBZQbbi+OtLMvlvz+D/eKVrrfGG
	GyM+QldAlgVypj13SNsG8vRxTjDO7Yi4fJuZT4EnGIIhrtQA8ECrtq2gLX3G9ArsCjBTVz
	s/km069cRydMalec1c3d1B66vsfJvko=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="j/mFcgrg";
	spf=pass (imf21.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=57pqVUBnNmX4cL7er9o4/zfu8e545pjnuaBSHsFeFDE=; b=j/mFcgrgk96/N4pP6VvSdeZMQl
	2NyqLTCYAvKds2nk+fOZ1sx5/jOUoZqeZ4oFVXHhL+THSwlCuWBONdUwzjwZ5j6Ilv+c/L4A7dFYD
	8XE1T3t92jFrBs51qinTzRit/cPBv/S9L6dA5d/KHT9+yOj930ZOqV5lRRRoLiQCSnOU8QZ8ddlRW
	xm8EkHu2njpTD8UDptnBaQLU8b5VJj1jBrWwX/oouNcbQ9Ov4mYYnXtrVvBuIzN1kM1pzxGDNC3Ec
	ehsc02QYR9xiooaC+18izCsV+OzQLchs+7zfIQQBKFpIDkvK63kBXBmd0Wbu5zjhlXVoqMl9CWCaa
	XZWREUCw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWV-00000002Pey-41Nx;
	Fri, 31 Jul 2026 20:08:04 +0000
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
	"Gregory Price (Meta)" <gourry@gourry.net>
Subject: [PATCH v8 01/15] memory-failure: Fix hardware poison check in unpoison_memory() again
Date: Fri, 31 Jul 2026 21:07:46 +0100
Message-ID: <20260731200802.574821-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CEA0C1C0011
X-Stat-Signature: ya3jc5e6ozn6gpp6r7bkcfddnyph7mkt
X-Rspam-User: 
X-HE-Tag: 1785528507-698895
X-HE-Meta: U2FsdGVkX19SAUXJqZfStkKjzWmUdu30hLW/sYWtjFmhRCMbxrH5k+gbWIkIBw2YTcgWMMUEndAb3fJHYledp3lPBm47oSu1epmlESFQ98VRUs2DgXIZah+o9vm59xJ1mxMoOJyzCx6ciOzpTdm/sHoOyK6INkwrSNQX9VjmkgM1zHNSbJ2S4TXhJW9SkS3NplzTR3eJ+veFRGBgtV9XAFVZlIl4vhfn65uMjCG57SoC73CQ2Eo/1rKydxDlAo+0YvblRw1uqc1SuUbbijEW384qLA0ADTi/aU8y6KP/cqF8Fgz8Rkkz8HPDBjSsHgitl4G9cB+ZT+EREgpvlF3rb45OiQRWORY9vqNwZz1DHSparyOh4D+rYDkcDNE6RpVc/FcqR2wWEvJu/NTYBcPX5xD0vHpIj/NQhHcmw1TQfzqOjrVz62jV7ayEHfbVQCAfpUG/0nLOTIyJtzM6Jcvn0nLkWBJXjarygym5TwHug7sgqX8jyzjAgPyXVt7ZRzOi/8o6w/ZSohTMsSWjr9hN7NfgoNlKdmszUnEOouICvPPniRTYDErVTnhV6rwzctwWbLUJ6HZoris7dHNQw9s2llZxePC26ISzfTj6Sc4YyxJbU8eVLSoipv7FVtTs2wf8257s+hXNXMKusv7VCYRn4/QH1AW0YlFfqT1L6cGJqySYzkz9oqGn+23c2wYvx8z/vmAz/q3OTkR8eY/r7IkVZly93q5WeSkYITQ5Z5wdqQaIZ/bU6P0iKdeuhsf8htqP4+mr/IUDUq2puvOaeVbCr6lQ9c+tPajsyYiXb32ZDcrZdZevMeYHti07lc9gYC6L5qfToCoUXxPp9dPnEgAHXiglfV8CmYav+HC/rkpiAWnUcgUUOHAceW3B5nVFer63n6PpOaoW8uGuHVhd1TgqPSKmY0gipUx9LmnoClK0j8DrruyxKZORjsjfVHWO8suuf4HOJL27NXTKr17EPON
 5oYJKx5U
 ZTqdJXvnymmqPcmeLQUW7AF8THdSptnkUyheAalotobx09/e+zO1rj3EyHTa/iewzB9Vga0VvS07SjPN0Ukct1x35qil+/JLxn2xmkkafbgB2NvWRQ4wX0CS7sQsXlYwB7V0bj9755Poo+Z5OgLmeXzhGpVFtqUwKWmbeBri3vW0l1qcBOWNHvW0pQ+33DvQKkTIqzN6hDCQ0SBL8EJxEVYnvUlH6SmTdB9WxdlUde3lbnNBmJm81lQ3v098lnhVK2Q/YU5TRCHW1F5GmuzMvY/QS4vjZ7NHIJ53pdofs4WIcGMZv9d/1wI0LteJ7Mu959zp9jYwLNChkNL70U4ybrGwPTY2Ie/Iz6d+kHtkk1NlrhOVBykIoi2BMnfT6NTTIVtGyS51ZmINsxOdQS9mDPJePV7gXy3V7e6R1RnIbY3arbd4tsUfU820/Q+dbww3pK9XfrVVq9/6ruyrw/RDedHTLS0ZOkY4mHvVXxTZnZiRpn8nAsk6yA3bS2w==
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
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Miaohe Lin <linmiaohe@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
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


