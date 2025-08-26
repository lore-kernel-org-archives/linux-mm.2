Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9672DCA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:12:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E394A6B0258; Tue, 26 Aug 2025 09:12:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E10AF6B0260; Tue, 26 Aug 2025 09:12:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4DD36B0261; Tue, 26 Aug 2025 09:12:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C46686B0258
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:12:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F4DD5B76F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:12:16 +0000 (UTC)
X-FDA: 83818947072.20.0595308
Received: from mailout2.w1.samsung.com (mailout2.w1.samsung.com [210.118.77.12])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1E54F160004
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:12:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=H3G4vCiM;
	spf=pass (imf08.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756213934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=ytSqwcHPS5KmoFqBJtl5DsyS758vO0cD13s/5MVs99w=;
	b=UMAUiiBnSF02hBO9RoLHamxn+YATYgJ4o65i4zpLA69dIBLOR/ct5ut0XVb35hDjrKxaAK
	6CGQXSrPR1H4n7WZz7xfHtCjwujFX1nboqWoRIBLatIV9KQ1ps34qoyLL16QouocAHqfSu
	0YUgj8WtDKyDsQ2zkZ03vFtD7WNpTuI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=H3G4vCiM;
	spf=pass (imf08.hostedemail.com: domain of m.szyprowski@samsung.com designates 210.118.77.12 as permitted sender) smtp.mailfrom=m.szyprowski@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756213934; a=rsa-sha256;
	cv=none;
	b=q+/h97FvjbKaIPeLv6IUJUmh38jEpT4TEeHqKjYe6EYQf9ME4CEkPYohq3CP789+2fDUe+
	ogqFoDSQ8ptxomsl0EvOv5e3utCsFnhpXi1nYWn0RdPAnRC74w4HaUTBgz2gMNUYT69+bO
	9n/DH6Bnh6A87WtNMiRX7rvJqcEsBSU=
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
	by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20250826131211euoutp0281328793484a24443bf27127f59be72f~fU0QcDN-j0287102871euoutp02e
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:12:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20250826131211euoutp0281328793484a24443bf27127f59be72f~fU0QcDN-j0287102871euoutp02e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1756213931;
	bh=ytSqwcHPS5KmoFqBJtl5DsyS758vO0cD13s/5MVs99w=;
	h=From:To:Cc:Subject:Date:References:From;
	b=H3G4vCiMCg3qUNBmNNU341fG5gDMCNltVXV6hREPZRJXZSPIBP5D6WxK3QNyAHKwK
	 h5lfxvl0LWZxLl8pYq2AJp9Uy0b7yGOEpbfqYqDefoPEYDy72PcGrLIvdCvWzQTMnn
	 atiWfSbqWv2zs3TWL11vUvtSoSNCm71822iM0tcc=
Received: from eusmtip2.samsung.com (unknown [203.254.199.222]) by
	eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
	20250826131210eucas1p21a27a684042f37080b7a19599f479b7a~fU0PynAJh2350723507eucas1p2T;
	Tue, 26 Aug 2025 13:12:10 +0000 (GMT)
Received: from AMDC4653.digital.local (unknown [106.120.51.32]) by
	eusmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250826131210eusmtip29b9a21b0c58ecf0ce713cf25b4b45afc~fU0PXArTq0684106841eusmtip2S;
	Tue, 26 Aug 2025 13:12:10 +0000 (GMT)
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, "Matthew Wilcox (Oracle)"
	<willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, David
	Hildenbrand <david@redhat.com>, Miklos Szeredi <mszeredi@redhat.com>, Joanne
	Koong <joannelkoong@gmail.com>
Subject: [PATCH] mm: fix lockdep issues in writeback handling
Date: Tue, 26 Aug 2025 15:09:48 +0200
Message-Id: <20250826130948.1038462-1-m.szyprowski@samsung.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250826131210eucas1p21a27a684042f37080b7a19599f479b7a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20250826131210eucas1p21a27a684042f37080b7a19599f479b7a
X-EPHeader: CA
X-CMS-RootMailID: 20250826131210eucas1p21a27a684042f37080b7a19599f479b7a
References: <CGME20250826131210eucas1p21a27a684042f37080b7a19599f479b7a@eucas1p2.samsung.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1E54F160004
X-Stat-Signature: gib84t8eax3yu9weah3odz9nxeb6tf7d
X-Rspam-User: 
X-HE-Tag: 1756213933-139614
X-HE-Meta: U2FsdGVkX1/1zsABTfElK60j9n44airSlDydwOinA4tc9iDw/hIU35+NJILj1RRP33ajf5JhajCj9fQ2QQec3KyFQHnVE2FQrezazJ/avzuSI10RB+ewdY16mjFCtq9csTO2+j6VWt0jeYvIWq9NTYa4TaPNlMqY09HLxbTAy5FQiVpopV7eNE25U/auBkbz0/TBYUFNL59udcYpQ5mH3+JVw6edkSGfagrqW/ZblY1HKBAIGTjbbR2nrFvYjvdtkZ0zXPz3lqvKvcVy7m/kW+gfWFLw4CcA4W5eakYBEbGKE5EotzgCl5/ub35S7abonswV/sEZ50KRzZJHQ88N+RCLP+t66BJrlJ7TAWpAd3Hq79tchbtdizKUUArZf8AZDUJmSZZ06HYHYZk35G/H1iTiMzNWhMcDpfNfgMiVIv0tPxdaZmebth36YjPRMHq+MU/pr1yMY+IwWMBBmbrEJpjVMgpB+mOiQholr9Co2cXf2ZyE6jY+ngJOzKBxhTPc9PHu8OoXXweaSAElH8NXymP+A4nAc+P8+i00qhvk4gpwtoJBizxRHCmP0Rbb49vjp25RB0T5uQ0nk5iOnhEcWdYZDzESbY05IcwDOXpAYcLHUjWJPWp/lPxEg+cc6nYQ7CNlc7IJVnocv86nUbczOFT0FSTSYtRscwM+UcaNfnf0JM3Z7bj+2xFmGjM14Yipy7Spb2Ud2RLtX315DNZswmdyAT44qgBqJX5DieP51ildFSN86GGZPE1fCAt/POnIba3dX0C0tadV8lBRePLMllFnk9dUlfOrIoTf4mXMhhPihthNYxOLyJxi3iPdpkSUHL6c0YYk03Bx/e6dBF1dYS2CszKfti0QM4WGMzRf6rtBGz33MwktzwQXuFFa0M+o7ApbINu9Oun/MkaE0auCyhncFPF3Pw4nZfLXcf5JPfjyJKUPvG2Tfn1doYCUZEM0mT9nM3J5li3mZaPL5x1
 aB7DI7kA
 7kPAWErpInBZ2cJG41OEYtvgkpnAw1hD6eaNz5/Xg7aRX3mU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT") removed
BDI_CAP_WRITEBACK_ACCT flag and refactored code that depend on it.
Unfortunately it also moved some variable intialization out of guarded
scope in writeback handling, what triggers a true lockdep warning. Fix
this by moving initialization to the proper place.

Fixes: 167f21a81a9c ("mm: remove BDI_CAP_WRITEBACK_ACCT")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 mm/page-writeback.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 99e80bdb3084..3887ac2e6475 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2984,7 +2984,7 @@ bool __folio_end_writeback(struct folio *folio)
 
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		struct inode *inode = mapping->host;
-		struct bdi_writeback *wb = inode_to_wb(inode);
+		struct bdi_writeback *wb;
 		unsigned long flags;
 
 		xa_lock_irqsave(&mapping->i_pages, flags);
@@ -2992,6 +2992,7 @@ bool __folio_end_writeback(struct folio *folio)
 		__xa_clear_mark(&mapping->i_pages, folio_index(folio),
 					PAGECACHE_TAG_WRITEBACK);
 
+		wb = inode_to_wb(inode);
 		wb_stat_mod(wb, WB_WRITEBACK, -nr);
 		__wb_writeout_add(wb, nr);
 		if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK)) {
@@ -3024,7 +3025,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 	if (mapping && mapping_use_writeback_tags(mapping)) {
 		XA_STATE(xas, &mapping->i_pages, folio_index(folio));
 		struct inode *inode = mapping->host;
-		struct bdi_writeback *wb = inode_to_wb(inode);
+		struct bdi_writeback *wb;
 		unsigned long flags;
 		bool on_wblist;
 
@@ -3035,6 +3036,7 @@ void __folio_start_writeback(struct folio *folio, bool keep_write)
 		on_wblist = mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK);
 
 		xas_set_mark(&xas, PAGECACHE_TAG_WRITEBACK);
+		wb = inode_to_wb(inode);
 		wb_stat_mod(wb, WB_WRITEBACK, nr);
 		if (!on_wblist) {
 			wb_inode_writeback_start(wb);
-- 
2.34.1


