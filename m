Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F062C982C1
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:24:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 582946B009E; Tue, 15 Sep 2026 11:24:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55AA66B009F; Tue, 15 Sep 2026 11:24:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 498BE6B00A4; Tue, 15 Sep 2026 11:24:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C3DB6B009E
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:24:24 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6B250160449
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:24:23 +0000 (UTC)
X-FDA: 85216368006.18.5F1F5A3
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7584318000A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:24:20 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WpFtdi1k;
	spf=pass (imf16.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I+EDjYdUiVp47imiKeO3dfc9fxyKX7XcOzgelislojA=;
	b=cznDjWevT4ET30h/0cGsa1iqbY3LPBO8jd5wlm4Jj7CwPpBIJh/dbjzqL5QOBwd5A1K2q5
	8dmG/8NAH4kARUefBbYI4nPu4WDAIBEfD/tHeZbek+0XuHNXKZqFoh5LPoGyBcfvOOH0AH
	+CcarRoXdCTzL3VfxeqvAGH7hozjwFA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485861;
	b=gsxmgHFvrBvYzjycDwrNwTmhVPrRuUwl8Jsjv00iABlwzUVo8X8EQU1fE6Bhk6Cjg/qvjY
	lBAsAdh7SRZoPc8dx30ySdWUx1yeBfYrDdGOM6nxp4Oe2bRdOydb9LCS/m0gvGYoSHdkNM
	sVlAf5cGvCYSTfDUxj/HamB0xrQiMds=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WpFtdi1k;
	spf=pass (imf16.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=I+
	EDjYdUiVp47imiKeO3dfc9fxyKX7XcOzgelislojA=; b=WpFtdi1kkpqGrSKW5z
	9kmemIcYj4hWSDkCRiqij3OogB3ekvGwvisBCNQ+WrT1Y8qtIVEwdS0zIVq0ZU51
	II9/hbduMCdb+W96ei/JRzFOSakFa5NJ0TgPAaPP+a5R+FMB4ednD87cpOxWs5Sx
	SoA++PXVuEWvJrJ4QGfW+XD+E=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g1-0 (Coremail) with SMTP id _____wDHvVwYY6lqm28iAw--.18968S5;
	Tue, 15 Sep 2026 23:24:10 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 14/14] mm/ksm: update merge helper comments for folios
Date: Tue, 15 Sep 2026 23:23:50 +0800
Message-ID: <20260915152351.7955-4-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915152351.7955-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
 <20260915152351.7955-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDHvVwYY6lqm28iAw--.18968S5
X-Coremail-Antispam: 1Uf129KBjvJXoWxGw1ftw4UAryrur13KF4kWFg_yoWrJr47p3
	ZF93sIyrZ5JryxWw1xtrW09343Z397tr4UArWDC34fC3Z8tryvgF12v34YvFy5JFW8Ca1Y
	vr4jqF109a1vy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jHCJPUUUUU=
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+Brj3GqpYxp+IAAA35
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 1df3zeyahmtghkwfmjiba9pdbnpwaqyh
X-Rspamd-Queue-Id: 7584318000A
X-HE-Tag: 1789485860-478191
X-HE-Meta: U2FsdGVkX1+pTm0r367oW9ogdXj2L+yEALDP6xFv1xpB8KpmIoGIuKB2kqmxq29nEfoz2tfiebomDlSG4lmxmPahTjzdgItx9m3obHnER2gf7h9u1mOX9l5ZHFeknzEsYwMND3ukSJ4tY74QLSVghtV2rfZapp4Lbdp42/SBtjB4zv8nMghdpPp9/CsQjbzlms7abzCNpxZXkvltmo/L0TdxMGX97rrUKWVgsGR+qvEDapUqW53ccCvcPA+l7sxVpDB9tic4nODL6GEsJjfkFvhgz4S8m1+f7UVB4Ty94v7tuf/ja2qlDhMnY7zHD8pRVMHVJGjGp13oy+Xg7EHVEsF1/YZAF+eietikAXGTIhxyWcN3hDCGuxbLC5D6I6JFcBHN0X345nGIwtcipuDQxswigPLHU/9/KLB56Xf4BFybs2agove+vRLvI1ybS3l2oa3Fj2JcOrlOGcRmH5k56egcMkh5XLzLpsDr7fGu3RMaWq3v4zyi+tAHCuPRaZn7sdCsTpp8m/Kf+2v5SGk4wSTqq8OrZfYOvwJEpFgPwxuzWBUvALjSi1bspLQgAYqWjiKkJFSqpF+vzyFYqAc3x+Kc1SxdAvP3LgRTXYP1SUJ7sxYARtm3GEsXIkjR4qWzgG3UqLUKT0y7wsOpC4HMLMtg270nryAUd0G6DwtS8AGhMkdhuM/x82oYDMSjETOIXAHKPe6syQGZVR0KgiPb+XzEMKk2j1th+/7rtbZw7qANC/gB8DkO/X/6B5NBuKOzVGZroIc+n5ak4btqL1hlbCWcCBPfEQYRldohZtDfFGtwadU/tQvurRtksHVrbSaTxZWwDY5jspUGphaQ0SAnWPhI5ES1c0uBv2dx2u8ecLIu/YoB4DhJKLsjzHfc3z3zC2rfJWTeBXrKWhpRu2kepx/Zsz4EBc4wAY+ky/Mjm1BiU///HqMJfA9awgrVYbcEyzXQlqrdncT4UhZnSoj
 /4QoU7TR
 aDG6Lb/3TITKmZSCYJpCLiprLWezphQhmBZW6/K0Sf760M5wLPdTRYaj+VRzljiE7/hRist8Q5hCWw8Tt5VXdAGv+fl73jwh/S+ImFuQ/f/gUfayM3OdUPaOhq/f98MgQFHBXmYAqmJNs4C0DPy/9cr4jAgXBPIkqc/4tQLJOm/vhgnITW6GF5jOrJ8J9/I96PlKMn3/vVYDVxE9bKgOyO6ZgfC2DYd/+eDbKZb80S//unQs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Update stale page names and the put_page() reference in the folio
helpers' comments. Correct stable_tree_search()'s return-value
description to match its folio and error-pointer results.

Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 937d1ffea4cc..8deb1abd64c2 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1707,8 +1707,8 @@ static int try_to_merge_with_ksm_folio(struct ksm_rmap_item *rmap_item,
  * try_to_merge_two_pages - take two identical pages and prepare them
  * to be merged into one page.
  *
- * This function returns the kpage if we successfully merged two identical
- * pages into one ksm page, NULL otherwise.
+ * This function returns the KSM folio if we successfully merged two
+ * identical pages into one, NULL otherwise.
  *
  * Note that this function upgrades page to ksm page: if one of the pages
  * is already a ksm page, try_to_merge_with_ksm_folio should be used.
@@ -1797,7 +1797,7 @@ static struct folio *stable_node_dup(struct ksm_stable_node **_stable_node_dup,
 			found = dup;
 			found_rmap_hlist_len = found->rmap_hlist_len;
 			tree_folio = folio;
-			/* skip put_page for found candidate */
+			/* Skip folio_put() for the selected candidate. */
 			if (!prune_stale_stable_nodes &&
 			    is_page_sharing_candidate(found))
 				break;
@@ -1870,13 +1870,13 @@ static struct folio *stable_node_dup(struct ksm_stable_node **_stable_node_dup,
 
 /*
  * Like for ksm_get_folio, this function can free the *_stable_node and
- * *_stable_node_dup if the returned tree_page is NULL.
+ * *_stable_node_dup if the returned folio is NULL.
  *
  * It can also free and overwrite *_stable_node with the found
  * stable_node_dup if the chain is collapsed (in which case
  * *_stable_node will be equal to *_stable_node_dup like if the chain
- * never existed). It's up to the caller to verify tree_page is not
- * NULL before dereferencing *_stable_node or *_stable_node_dup.
+ * never existed). It's up to the caller to verify the returned folio is
+ * not NULL before dereferencing *_stable_node or *_stable_node_dup.
  *
  * *_stable_node_dup is really a second output parameter of this
  * function and will be overwritten in all cases, the caller doesn't
@@ -1917,8 +1917,8 @@ static __always_inline struct folio *chain(struct ksm_stable_node **s_n_d,
  * This function checks if there is a page inside the stable tree
  * with identical content to the page that we are scanning right now.
  *
- * This function returns the stable tree node of identical content if found,
- * -EBUSY if the stable node's page is being migrated, NULL otherwise.
+ * This function returns a referenced folio with identical content if found,
+ * ERR_PTR(-EBUSY) if the matching folio could not be locked, NULL otherwise.
  */
 static struct folio *stable_tree_search(struct page *page)
 {
@@ -2005,11 +2005,11 @@ static struct folio *stable_tree_search(struct page *page)
 			}
 
 			/*
-			 * Lock and unlock the stable_node's page (which
-			 * might already have been migrated) so that page
-			 * migration is sure to notice its raised count.
+			 * Lock and unlock the stable_node's folio (which
+			 * might already have been migrated) so that
+			 * folio migration is sure to notice its raised count.
 			 * It would be more elegant to return stable_node
-			 * than kpage, but that involves more changes.
+			 * than tree_folio, but that involves more changes.
 			 */
 			tree_folio = ksm_get_folio(stable_node_dup,
 						   KSM_GET_FOLIO_TRYLOCK);
-- 
2.43.0


