Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34EEFC55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:29:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA0E76B009F; Wed,  5 Aug 2026 17:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E783F6B00A2; Wed,  5 Aug 2026 17:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8ECB6B00A3; Wed,  5 Aug 2026 17:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A67F46B009F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:29:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7F9351C10FD
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:29:29 +0000 (UTC)
X-FDA: 85068507258.28.403E5C4
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id BB1C016000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:29:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=b8iyLogG;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785965367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=57pqVUBnNmX4cL7er9o4/zfu8e545pjnuaBSHsFeFDE=;
	b=8F2j6gLLlG/hCmxPVpNRIJ6pnu8Am9cXUR4XnacVQfRuvUz0t7y2qzf6a6hRWZYDLJ2cvo
	VRRaAvhqs3jG8D88JdfRJSwhHqVsCdyBJ7Qz+DlWe/tzmsV4L3i+s1n98qs5IYO0jjA8JT
	lBfrmkAj6Efn5FpIgMqx4RErUJnUoTQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785965367;
	b=nnvADxjJ5ONwaYx1MovKAiliDM26YMnPAvWNxM4yigzSWzKwco1BSTm2WUPwvU2NcuCMEb
	cC37ZML0OCZX2YHtKhuWNi/EuVHNvVam4Dwue6X46GghXfannieA7fawYKGFp9+NdMkQCq
	++yZFXoLUAphNdOXDETqR/V870bKMHo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=b8iyLogG;
	spf=pass (imf08.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=57pqVUBnNmX4cL7er9o4/zfu8e545pjnuaBSHsFeFDE=; b=b8iyLogGZWsewW/fwjv9PC7QQ1
	K4q20HeVSAYmtkIesVcvUexqCSW3n98569Yc/t+a/acUUPw+brfYCuDNjkK6P9UhkLUFpkuRJGMhG
	zrsY3vxhU774pTVDkESi40r+Ihz0VJYpyGfkSPBTAwT//WTu5prLiqkEfETryGeNY0r4v9yzWK5Ii
	5Ez9efFZW14/UXRW3IQk2LX2ZuPHBnC1pIejfuapERWhujUB936JuzTbplSQRy2Ls5meXVfqpU1gu
	OHIkVVE25WG3liME5CcoVyBxKaOFdttxO1+6S1hhTARTqizWZWcijiSMQfAjUzh4+IE/6CRnkTe2Z
	8maT5eSg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioJ-00000004h65-1IK8;
	Wed, 05 Aug 2026 21:05:59 +0000
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
Subject: [PATCH v9 01/15] memory-failure: Fix hardware poison check in unpoison_memory() again
Date: Wed,  5 Aug 2026 22:05:41 +0100
Message-ID: <20260805210557.1118966-2-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB1C016000C
X-Stat-Signature: 1qu7tiu4h3neoierkibja55qp73pu7gu
X-Rspam-User: 
X-HE-Tag: 1785965367-473310
X-HE-Meta: U2FsdGVkX196kRRhLsnIvpVraJgGutWCyUlcQsawingwtgSpAo/cFfr3I20CuabpZ1mqjKxnbwIUPRKKGAxrIYFyjxXIgCEfdjsk2Bv5Q/qYzJWyfIZBDKdrqo5GPCQDSeaY+9+QLu/tTTiDX/dCL0xw7mSRThd9MX6uCBw0B/hJKwPiieefcfckVDyPwRgcuK9JWjLWsg58s28CVG6vnNzkkr5HccZjH/PvAZpHljjIUSG7cpBonqvBHEPIP3uF7D0qMWkM5c2jbXQbBmvJ+bFXCvzkef4uXUef82fBWovlkLdjOYccczZo0EWYF3J6TRuoEAAOiT0HLlmpoi7lllpjVXmpJ9CtiV6J9RkJXvxIpQ0otizFdec/YLBYv2/FihoIvv6loq4+BD4alV3ps6x1IcKw0JhkTJTzrj2kFUcR5M+lCeHSYtiRm2i+PVO40eWCajnclenGK+9Kw3MXdxtnD5MFu7QcqZymyxe1y4Pn7AywxFImsY1aYV29gYMDi5nLNduPVW6iILoiiEEWFBlc6uW5lQykvFNsBJ2pbMjCLIP4aF3fTjsLoXonGDNV5rcQdS80cLnzePepG913VwbRt2UMcneltuMAUiymC8v5BJu5hlXTZ5XsXt5YMG57zB3eZXPNxsOPY2nEAkbpyJ320e2s7acTrRDsG9CFBtChzDurCfFyP/WH1QqJC49EWDOGIGpGgdEAC+ztHEP54nTeu4F9iixGKr1FH6rl7glohnNYkEZX/ZKS2CbKvpY/a155XBnWXRDAqFVONiYM6KK2d1khH+bcVvyJijJoh26Ed621d6REjMmgTNwLAvXoQZDrCwIOWkXZeB8IY10mcPjKJ+aZj39ZGBbGx1LuGhu1MyBClnX3khA6TDuS41EiKmWryiEMeIZeWyMadLYsC4hmVXUIAQd2Pw9sRcOs4OnTAn4ao2o+Db+YDX9Qq9QTjeBDSoj0Pklko8SmeN4
 +Pas6VLW
 OzVvVTrNXdnn+uDLhhTRUH8RTdiDYxUnSwB2HTXCamoK76yiIhyqPJA34YYhYAzHUrL4eltLeJIMsboZ9MAdxjm1RYt6GuheVJvNIlpNAvAELlQHBckTJIQrF222zzfMBeWArEOP11iMx67adNT0nAVlHyt+ByU7AwWKWI3lerqKM9jGqX4apwAjy1TViuJPfDk1VU052YZf1PFnLqg7pvlxrlygccSlFf2CvlRTSDch69mLX1I10vfxkriWa6a4urSNmrglnk8kDCVERlznZH9c8/Z9uBKi5vQ0cojQECvkvOKdWIrZveNGZdqsLv7SoWxPvwUBu74mw+kliJ9/5XMx6wZKwmaFdCQA2MmeA+QD1k31ozk6x/SNl58kMLjgOn0V9F70MP19p2h0j1J3KTUxG6NbFkgnBsONtFlfYubKTdkdv4pJo9UNqVmwQZI+K676+JtmIdyztdwjSCMM7qgi14f4t4aQgL9U67X9VIN7RsbohMz4A4e2Vmw==
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


