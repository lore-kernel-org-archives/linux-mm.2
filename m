Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD1E6E9A047
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 11:01:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A8916B0093; Wed, 18 Feb 2026 06:01:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 480936B0095; Wed, 18 Feb 2026 06:01:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 397926B0096; Wed, 18 Feb 2026 06:01:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 21C116B0093
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 06:01:56 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CB15313AF79
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:55 +0000 (UTC)
X-FDA: 84457287390.24.7A15C27
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 16645180006
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 11:01:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d/+TltNQ";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771412514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMbPZHjKcPTwi/7rkNe+hbCwdLCa16i3c+99UW8vyOg=;
	b=UFMVKvTGGyBOqBUm3xAhBmVFOWUUhl4rTXz78wOIZskb9D/OKIph18uoyHFY4gFlKKQ7oD
	8M+XC2C+Y3Fv4htlxIA4kRQzWSb44L1PnL9p/KCgn3kMpFpc4oJd1KCcQQOWqyv64f+8up
	aeERaKTUWbHd1ss8armefsBS5CLKDuw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="d/+TltNQ";
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771412514; a=rsa-sha256;
	cv=none;
	b=pP3TvpwEd1A//2KbNhed1Vpa1G5CDZtzF3+Wu9y4j94nyEn79780pQuIK4xpCP8CMFNZX6
	2iEAtYXRit9bSXho5BOf4SUURx/hfeNZvnpgxpBHIhPHV5yQiPjUDOCcZAmSu/iNuAFuef
	LFT2qZLmuPXUi04oqjqBcesoKnu1rRo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DED8341934;
	Wed, 18 Feb 2026 11:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E813BC19421;
	Wed, 18 Feb 2026 11:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771412512;
	bh=1bht8Tpqraf9dvK6mi+HcVvYMPfVmAZiLHiDKqSOogY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/+TltNQ8ORPSrhGXeg2bQTdrS8GNaESKLx+qAHeBox5igvAyIWqDto1u1qtJlA8u
	 XOJ96TecQzizzNqPtl3YEJbyVrgv70a+nZTUx4ScC2EeGaq1sUWdz8lDmfDoqu3Wx4
	 M7uwTR6Mk+onFiLs0uN9WuFk0GW388KFnG6qICo+9KiDJWLvSsV/zj2ap+6p2ZSZa6
	 XiFv6mW/e/0+1K/ssGcvmov2C5DKZe01d6qeAEyt6vlV5QaB8hpo64XVRgRzNthF8O
	 AlcJZV7XSECM/LFGLKd91p280FSo8llhpiocAW3N0147lXBGyF3aXJxGTQNDAVacFQ
	 qVyYSY+lg2IpA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Laurence Oberman <loberman@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Oscar Salvador <osalvador@suse.de>,
	Liu Shixin <liushixin2@huawei.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	"Uschakow, Stanislav" <suschako@amazon.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15.y 5/6] mm/rmap: fix two comments related to huge_pmd_unshare()
Date: Wed, 18 Feb 2026 12:01:28 +0100
Message-ID: <20260218110129.41578-6-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260218110129.41578-1-david@kernel.org>
References: <2026012608-tulip-moisten-c6f6@gregkh>
 <20260218110129.41578-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: igu8ni1go73iqz71cniiw6hzazsnscib
X-Rspam-User: 
X-Rspamd-Queue-Id: 16645180006
X-Rspamd-Server: rspam01
X-HE-Tag: 1771412513-564322
X-HE-Meta: U2FsdGVkX18JdE+QdtYQUNAgpsJq9P9AuybFZjhIlNObUlyojCJGbMLKnbcoJQujzlbZ3/yuYpDh3nALDhU7dZ3qo2e5I0ve1X98jIU9isuLqzDUAnN9ArllbCeNzXFzFqszDnIKLVLt4eV+NkiQM2oaMqx48geBkZta6qOxAJ8fhlcHQcRpvOlBX2UFcoRBz8Ja/cwT8IXRVs9Mtax6PwG7MpHzozzKkGNYVSc0R7eRKYzBd26G6Ty6it1AsGN6PSHx0Pp8YJ/sPe4viGPRcnnyZDZvylZ3cn/PlQZnLmPXN/lbhUKEuq41i6DyjqlD2U2tLgwNju4pfNuV0hyE5dLHPKvRf2gxe0J1IASdsUXDPXwl01ZKoaSxpKNOO4uoQ46r9nw6R3BTvTvfUYzdNdLVYVwsSkw+cFGr76sBJZ389LSvMHBKeF3cfgIy4p/BqpJaRxUVWV3JI0X1ywRDpSodJcvCn6tmbVieAuNxbhhYvfCiE3PZXNqzGDoIFlWeD/9fZn89/jB9zqGFXBQpugxXdSDqcVEmtCbgnmx6/hYw32eh3n8duDvkMfd6HAsFihVBAbk32LRenxm6BehQZ9wHn1//w7wlW1B1mFwM/lGLuKQE+Vl8fXXpqh2N5D0CtgzW2+itN/5sIwymms9piujIDeLVpJaIBQ5IbwCnX9ZAyn18AHrzh7EOu+BJVkzzKpzQzBmnyjhbRoxGydN78Nn18ZC+MV8n3JSLM0uq3nahFSGZJrrj5KpJV6cFGdcvsg+3GCspGGvGuo/dUBhh/sLpMevwt/UgPuGFB5lHSBu6tBxPg6odtPL44o+U0sLFytXutHt7phCLFpkxEDdoreKdbjM5RmC24g5e6IkewctI1/ymF9HeGrvBoTtXQUg4/YxQ0wDeD8ehP9mw1JifivXSjJIrVaq2TfJI9NxHBnMT7sUN726iPtxMsG3mF6ffOetk1Ha6SC8z2LtHRJ7
 wiBjD8c3
 uTG2AD9hzBgbPtG4uPnM/wVuXOsAbN4RFuSimXT40GYQlEQVVmr7quSs1Upcc3cU1z5x/vS4tDC63CW3DnO6LuNXMw9ntvf0cpTQjDmUzniDCj9+pn+3a/xeG7efxmBwxTQJi5I3umS0M9UMZSOol34vAj+EJgltY4Utd5Z8qPl648GQiS0rU/jh6TyBxw1m0neKBVrjMfmH6WMxpDyQf74FZ3lGyDCdW+IUiDqo9i+VXgV/gx5YCQUoNw56LQc+cWcUiRw0MXJZAarr8cbTe2fRFZCCPPcCBTUTZN2O5MgTbGlZcI3ZPn7VlavwRdPauNxHtg1L2bhl29uE61kb+Q3B5BhXKyEr8RqdYwpMfgIOPL8dMbUsCBVLVxSw9hlS1Enu2loBN2zhKBRGlBKfCkj20p1I9DxdDPYoJ4Zv2aMsR3jndt1OVXt3aNaQMkCzqgHd+nIQvBOclb7PCVTg4NiOYSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "David Hildenbrand (Red Hat)" <david@kernel.org>

PMD page table unsharing no longer touches the refcount of a PMD page
table.  Also, it is not about dropping the refcount of a "PMD page" but
the "PMD page table".

Let's just simplify by saying that the PMD page table was unmapped,
consequently also unmapping the folio that was mapped into this page.

This code should be deduplicated in the future.

Link: https://lkml.kernel.org/r/20251223214037.580860-4-david@kernel.org
Fixes: 59d9094df3d7 ("mm: hugetlb: independent PMD page table shared count")
Signed-off-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Rik van Riel <riel@surriel.com>
Tested-by: Laurence Oberman <loberman@redhat.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
Cc: Liu Shixin <liushixin2@huawei.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit a8682d500f691b6dfaa16ae1502d990aeb86e8be)
[ David: We don't have 40549ba8f8e0 ("hugetlb: use new vma_lock
  for pmd sharing synchronization") so there are some contextual
  differences. ]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/rmap.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/mm/rmap.c b/mm/rmap.c
index cb133bd49e02..5093d53f196e 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1489,13 +1489,8 @@ static bool try_to_unmap_one(struct page *page, struct vm_area_struct *vma,
 							      range.end);
 
 				/*
-				 * The ref count of the PMD page was dropped
-				 * which is part of the way map counting
-				 * is done for shared PMDs.  Return 'true'
-				 * here.  When there is no other sharing,
-				 * huge_pmd_unshare returns false and we will
-				 * unmap the actual page and drop map count
-				 * to zero.
+				 * The PMD table was unmapped,
+				 * consequently unmapping the folio.
 				 */
 				page_vma_mapped_walk_done(&pvmw);
 				break;
@@ -1808,13 +1803,8 @@ static bool try_to_migrate_one(struct page *page, struct vm_area_struct *vma,
 							      range.end);
 
 				/*
-				 * The ref count of the PMD page was dropped
-				 * which is part of the way map counting
-				 * is done for shared PMDs.  Return 'true'
-				 * here.  When there is no other sharing,
-				 * huge_pmd_unshare returns false and we will
-				 * unmap the actual page and drop map count
-				 * to zero.
+				 * The PMD table was unmapped,
+				 * consequently unmapping the folio.
 				 */
 				page_vma_mapped_walk_done(&pvmw);
 				break;
-- 
2.43.0


