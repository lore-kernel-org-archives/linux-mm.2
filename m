Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13F75C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 18:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C22BD6B008A; Mon,  7 Sep 2026 14:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5016B008C; Mon,  7 Sep 2026 14:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9CEB6B009F; Mon,  7 Sep 2026 14:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 72EDC6B008A
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 14:20:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E2D43C01EE
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:20:08 +0000 (UTC)
X-FDA: 85187780496.07.4EAB575
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id CEDB240003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 18:20:06 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QQrq237+;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788805206;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ykbWAaG/piX5Q8aQYtayTOuTpGkzqxkJVHR6Dl5sFlk=;
	b=jQp1l0RcvWROti7mpNNv/hbP6MMxQJK8Hum0wkGZ0YZi4scV/hFOqk+mjXPHGDA320+3Dw
	mOi4llG9pdSFu/2cxebrm6tSDAEHDRm/DrcPPrhArXOSPViac96kyUFv7AgshnqaLrZnSn
	HGn2rBGHH89T9j2AjXE2H0X7geA0/B8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788805206;
	b=Jt4MQQS1Tk+OWTB1B6bm1w3w4xcvI3sEa4dJNZqEEzTPWvWLXPR3FGQTAT3bXqSLsppf4q
	getJjHTQRAusalhLS8W1Tmsvp8tQ5o4opNzsSOB2iBaDlJIpGlNh2OBPlEybg58fKIldYd
	d0+xf9cQbOhJUlTp2DHZ8dShKixiHLk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QQrq237+;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 241E1444E9;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06DE7C2BCC7;
	Mon,  7 Sep 2026 18:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788804737;
	bh=kkuX54NYW1o9dDD+/jciNXKhI+65D0lfRKDdNOxp11Q=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=QQrq237+I0tlz8KHBi0SILSyzD8pXJt9oxYxgvUXg6SFCh1diq/Mg7xpLdxLWHNXg
	 SAdelRX6DdWWWz9KYf3NsdFdM+HFlvVMJpI+f0Ioy2GA7wQvOclumtcbFyg/OeiTzG
	 AJ8GApA1obtyf5b8RyazxsrxURoCqoqUd+h1tOYU6gjIQ8aR1qyx3p7eWjvs02vuHE
	 pb5mhP87qyiiVzA1Cnze9FpJJ2Pr4Sv3q45Yp/Rv2O6VnaKnNgo0LTVsR7b7Z7ZpUX
	 HFqNDCmw5XoMJd2XGaQ1+OV2gxepUFs/rBUK0HVjJc+5zWYRXWS5wpQaHRDGbKM67I
	 s8IaWcVy42TeQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6703C79FAB;
	Mon,  7 Sep 2026 18:12:16 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 08 Sep 2026 02:12:18 +0800
Subject: [PATCH v4 14/17] mm/huge_memory: drop the unused do_lru argument
 of the file split helper
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-swap-thp-cleanup-v4-14-b532a3f20e71@tencent.com>
References: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
In-Reply-To: <20260908-swap-thp-cleanup-v4-0-b532a3f20e71@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788804732; l=2439;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=a/jf5N0ceVT9ic/8DVL2LfIrSgCiaeltQ7+TGC4eqog=;
 b=UUxTwZ1zaeh+CLxeq2MurhCTVbY3kFNfbJnrl2RetkKuvrSFYHsrIxGIEj+I4hCcBR+FgAiGf
 0Gh6OORkTjmDxX0ae4Ym/nKlUhGjPAytxiXOqn5vI+jhtP/yJcvAduz
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CEDB240003
X-Stat-Signature: 4z47yd7dz7ud558ryf7mbbw6qa4x1bcf
X-HE-Tag: 1788805206-687157
X-HE-Meta: U2FsdGVkX1/pE19f70Q1MP5TbAjdQcJqNXsVil5SMv+nMNqJvVhRE7MG4nMBHVk2kUnsjpDR/iCXeEkvopK79s+G1E5EztQpetztuiWKUlxyXNWvnU8uGwrrgmh7kvzHVgft0mYOAYV2NlBQtRg/illo4wzznbd5GBx/sCcU36vyK+xYibcpD8Mmh2bfx8UglRYwVan7ttKTQcfkyEk0xZUOsccR42SVJIORGFBECmxs6CtsuHDS9EddIRJTcjNpbzqqtG7dOBm/2mi8P934hEIh8lbVdY7ma/uzkwXKx/DFtySLfJ2LvlyO1XUjPPETDXOJNj6L64ODMl5E1UmRitjFVjYfpaus83PGXYxivjh0IcTLdaPIldcZqs83wI9FhvBknnjTAiuM36wftzSCCgyPcTk9/9IWg1Kc7MDf/baqbnRDc38/7YbGpKtAkjdEaRzvH9z0PgRHOZs5U1R+bmSxHkTn4qxDYN3+i6jPRKA76txqTk+IONtu95AINVRRbnDjb4I93ysXlWlC0ptehAhKejmfVHA7a8XPQD6mvm+qMf6YKogxKshNKZnzGiFgsTQ+CNU08aAoYmEqtRacD4dW7xic7qp6o0wxjMCwMEZP+tXnyQaGOFYfjUfKYHPzmeVfG2Nu7v29XA4Hbc83Lr8GbayaIxpOPXmTmMdE7Bb2A70Jj2DmgSLVTPqZTjmSIlxtb6Xf8vtunsid3vmAVRlOsVmU54Fcpueq4OOmrr0k13W5no47ie0iEpB0nwRm64Srw0lnaIBQm7QemC/nOhfhtP+oe5vz08UrhyRYUDC2UXVbO335ih23T3slJloDbsMA4tJXudnxZvaKUZlY06NY9YjKHWOysTNgVJRgegtaeiCvnLsmiQDvt6U1Wf60cDsG/+2yssEVqtGEV6UBR25oQtO2SgObKU4bxZg0e6YhNDBtledB+SZ82gFCCkz6ftoMMk0njBOfl3kToSf
 yqjmfOke
 lfEe02dIRMwr0KYK0kFMo073BtXJ/uQ/orF3uAyoB/3uDuhf3mVDx9O9pvw4N5PPla58Kr12JxLv1Is+TPoiEzbGbPjkedH+4sZUJ29zbulbvpIAHszBT8h5WluP5b/fZEA41Z31lS4d0UTv8II0EBz1EXq5NDd9nuaUrMtvMBQH6nAe/6fRn6wPpwah0HvDpmbW39Vk4yZnqBBtr3zFvOHYoMwxUrNE5o9pnQc4AqQDHx/2aMS/WM8FFgqa1rvxWfzlS89BEo4HyWH4HXjVaP18HhpH3kQFa4gWVdvTmXYKXqYTTg6/d61HKDbE7ywUYla8PCIXLCZIExnWhUx+QU76S3HY29Eq1iuhkestXu5oZojCHutwHgvcH8IMhocTkOdozA5Qu2NHNnow8amkf/Wk9CwCDsiCL75gfl05FhIE6v13Nn7QCqk3qPku9zFQZIPwOC40v+hLQ+aS39QjKJY9Np81QAzpaRvkLe5xvvHLo6DnziAh4xrHacdQLxF728Y+V3Qr8DBV3iiUwVN9xAUnqDO3t7Lum9ZJcPREhKXQTB3mPiFDNHMvBEw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The only caller of __folio_freeze_split_file() always passes do_lru as
true, so the argument and the branches gated on it are dead code.
Drop it.

Reviewed-by: Zi Yan <ziy@nvidia.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index ccd48cd5f94b..6ce58a5d93d8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4107,8 +4107,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 
 static int __folio_freeze_split_file(struct folio *folio,
 		unsigned int new_order, struct page *split_at,
-		bool do_lru, struct list_head *list,
-		enum split_type split_type)
+		struct list_head *list, enum split_type split_type)
 {
 	struct address_space *mapping = folio->mapping;
 	XA_STATE(xas, &mapping->i_pages, folio->index);
@@ -4202,9 +4201,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	}
 
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
-	if (do_lru)
-		lruvec = folio_lruvec_lock(folio);
-
+	lruvec = folio_lruvec_lock(folio);
 	ret = __split_frozen_folio(folio, new_order, split_at, &xas,
 				   mapping, split_type);
 
@@ -4226,8 +4223,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
-		if (do_lru)
-			lru_add_split_folio(folio, new_folio, lruvec, list);
+		lru_add_split_folio(folio, new_folio, lruvec, list);
 
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
@@ -4253,9 +4249,7 @@ static int __folio_freeze_split_file(struct folio *folio,
 	 * and its caller can see stale page cache entries.
 	 */
 	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
-
-	if (do_lru)
-		lruvec_unlock(lruvec);
+	lruvec_unlock(lruvec);
 fail:
 	/*
 	 * If we want to use try_to_migrate() on file in unmap_folio,
@@ -4335,7 +4329,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 						true, list, split_type);
 	else
 		ret = __folio_freeze_split_file(folio, new_order, split_at,
-						true, list, split_type);
+						list, split_type);
 
 	/*
 	 * Unlock all after-split folios except the one containing

-- 
2.55.0



