Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEE59C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 20:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20E576B0095; Fri, 31 Jul 2026 16:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1951A6B0096; Fri, 31 Jul 2026 16:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05EB46B0098; Fri, 31 Jul 2026 16:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CAF356B0095
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:08:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 442D1A04F6
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:11 +0000 (UTC)
X-FDA: 85050158382.06.9FF27A0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf05.hostedemail.com (Postfix) with ESMTP id CE8B9100009
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 20:08:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="tK/RvxUM";
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785528489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6pjpw7CE45fm5rwUaMmq6NBeRjAsSjRlEPCJeSuv2J8=;
	b=7fS7VuaMyB4g4Q7WpHQhP4XM/Nfj1j267J3p/NUnv87kh6o0NLOg7E7RFSX+kdFZYprovq
	ymNM37upBm+EaITywjhTsFo30heH7+jbLguAXw7xbVRZiEbVBH91gO8LP4UT+7A2PQiFca
	iaFSkRR7EPsyXiui8xpufvLyAtfVRJE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="tK/RvxUM";
	spf=pass (imf05.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785528489;
	b=trr4yohvyoNJKS9xi9VMepwf6ssxRCtHVm9QX/6z0Q0XuUpakboMDhzZ3goc0CsElA7p6i
	QlHaypwzANpQEqJtCw6+HaofvEl+KIK1wHxNQXADRSffet43rMCOzUZcG9Vz1p++gZTW3U
	pJxTB5YVW5ly64rgPvQvpu4gZThUE0s=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=6pjpw7CE45fm5rwUaMmq6NBeRjAsSjRlEPCJeSuv2J8=; b=tK/RvxUMIG0VqyalMTuee1h3yL
	6qB62SBlIS64AWYMW4/BAE8i665UJD3bzYB4jVj8gPjKH0nvJovsfqNt0UdOvCY/pWB3r11qpcOrw
	MTD4MPGCRIFfE7mLnMie8h9Y46RGcUFBpkSv0NNWAOUtPlrjBjAsGWKxHIcagyk9AiFDbBcjYDIoB
	n8ircKqbCxO8KD1YsKcc2RGHYp1S3l0F8j330KQgPArm55cruwtihYPfGQShsHQasXiFe0+5SECHd
	Q057AZk6wYPC808oBQmpoZk3fJN1i8iyG2pqcZg9dSG8oOwm7mhSuIgNc1TCrs3szVNddWIX+ijfk
	vEA3wnvg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wptWW-00000002PkY-3Eny;
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
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v8 06/15] kpageflags: Use is_page_hwpoison() to set KPF_HWPOISON
Date: Fri, 31 Jul 2026 21:07:51 +0100
Message-ID: <20260731200802.574821-7-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731200802.574821-1-willy@infradead.org>
References: <20260731200802.574821-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: CE8B9100009
X-Rspamd-Server: rspam01
X-Stat-Signature: 3q6b8o95399fiyre47m5pfkdft3hffwd
X-HE-Tag: 1785528489-556798
X-HE-Meta: U2FsdGVkX18V4eCTXGUkwnI1E2A2oLosiTCmYgTHQXtYw9ZFTYbKOTkl4PgUSnl4lnAPreLdEDNbE4F/gaPQGhQJThC7TGGiA5ALcdfuEK/jv2Iz9wBEfjlvdHvYC8dl0by1LHgJTQmEouX+Leey3Uz04TK7HICiJE3j1dE/RTIlMttXaTwk74gHyw7+HgcU98kjIsgtKY7dDxO5KdAW6lLHLsGzJF+l57UvIOSWk3vxfFvWE/wlxxkEMkebK9ZiNQnd56mpVR4ncidvZpz3C2sbXMDyipi8eaiYeLK87sKMygx5em9mErYq6EZ5rBLm0yaWLy3qgi1Gad8qE0ELH73i/AFTGxdGM0oGkwjHUOGFgoqqQL+JVANZLMK0vgI3wwxdTKZn/n5eb0Xfa2nQf4VRNWzfUqK0I9L6gNNQGSZUnRGk2x7YyrVQZr0Z48HJcxB+vHyPL8hpolULaTaInZ+SoUYNXaagS4awVLRS2se59bIt+25Rb73kCj0z0yXyOSHwEVF9wi8irMZSln9YMQWMmF9VJlEQOc4t7MEWzlFj02Y7RGPq9DsJyvJsy+hnsfpSmMgpA0XcwBWVV5myVLvKMiYLhCeDCjaRRMxB53zRFLBb6v/k/Kov4Zx8WyMWjW3hoGYP4sufHHjybsy6b58c1hPXJxv+M/YcNdeSXNiWF7dmPdgO+Ysh4bjlxbizoRnAO/lRoBqmzRm8pERF3325OAUTEE0GkoyduWFYhbBmMlNI1Ocz8NHun1u1pxihvCByYVv//zIlKC21Arj5Ci8tHTi7V76DF2V3ZQZ6PBW7DXaKnm6nueMjNdpfsAwI4CDWL7hP67aYfb9oJn7QrjIW1pOaZTYwsJl5XfVOXmkvjLMltexjYyw7pQPmfi6V161cgE7fA9ZZErNc2FwPFqmSmKfwovcdxHUUQf5Nu/y6005TiPPC/+9tYZJAAm2BHBMVHj2G7x7Ods1z2Gm
 C9NcgU4B
 Td/RPqBRbmBRBPb+vQwOlDlVMxtM6ooSXCuIVDM+VZUz2MN4TIkYgnvsdem08337xwJVgt+gctFnJOIcly5uX2OLaur1W/WqJ/lcYjrSA1GS5r7yDVn0LcfbEbaPnjpn0e2h/QT3p3fVvRyrf8EjG4FC3tjnhx+cm8aT6ZvLDoyd4TDDHTLkCntk1LJ+PIMLelpIFD7zbIvwpiXvvvercLIBHwLSQtYgoQkWdCVp0ZZRMQc2de2H+1Sg+TWNX71d0L1tHIEda8CCgO6Nn5EEOyBUNXQQAUcWQVpsxjZBTu95yRxf/C0ZOlmUcRe4JjjdGa2Q8U5Xmbu/gmLhtFBZ39EHA8kmT1fvfqycJNySJmaGHfA2/n9AR32C/9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Instead of knowing how hugetlb handles hwpoison, just ask
is_page_hwpoison().  This gives us the flexibility to change how hwpoison
is handled without updating this function in the future.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
---
 fs/proc/page.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/fs/proc/page.c b/fs/proc/page.c
index 7d9387143435..28c9a7b724f3 100644
--- a/fs/proc/page.c
+++ b/fs/proc/page.c
@@ -233,12 +233,8 @@ u64 stable_page_flags(const struct page *page)
 	u |= kpf_copy_bit(k, KPF_UNEVICTABLE,	PG_unevictable);
 	u |= kpf_copy_bit(k, KPF_MLOCKED,	PG_mlocked);
 
-#ifdef CONFIG_MEMORY_FAILURE
-	if (u & (1 << KPF_HUGE))
-		u |= kpf_copy_bit(k, KPF_HWPOISON,	PG_hwpoison);
-	else
-		u |= kpf_copy_bit(ps.page_snapshot.flags.f, KPF_HWPOISON, PG_hwpoison);
-#endif
+	if (is_page_hwpoison(page))
+		u |= KPF_HWPOISON;
 
 	u |= kpf_copy_bit(k, KPF_RESERVED,	PG_reserved);
 	u |= kpf_copy_bit(k, KPF_OWNER_2,	PG_owner_2);
-- 
2.47.3


