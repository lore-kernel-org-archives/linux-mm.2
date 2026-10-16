Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D824DCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 06:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD7C6B0092; Fri, 16 Oct 2026 02:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8E796B0095; Fri, 16 Oct 2026 02:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A2DE6B0096; Fri, 16 Oct 2026 02:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 76BF86B0092
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 02:59:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E67631402CA
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:59:34 +0000 (UTC)
X-FDA: 85327588668.03.93CA272
Received: from mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf27.hostedemail.com (Postfix) with ESMTP id C94F640004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 06:59:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PJIEvhgd;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792133973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/Nsl5X+ErWymdOhOdGEVIGmAnGXxBUu6QHrflXVx2BY=;
	b=PqXZVPUyp2a+1TRJZ4FZJ8nhrg0WHLr/uZyDVxOOBHGXOCw/LeriRwZQTafFaAuYm/iY+o
	jX7Qa3RjvRsJrMoMYTiGEN6vDtDp8WgM+U9Z0oOO77ARs/I3E3okgTFwLwLHLZhC7WFwZF
	W9ts0iAvUkRMXRz6baCbyHHz51sfiT8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PJIEvhgd;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792133973;
	b=20D8/Ydn1LvsRwjRMzeyYwID3WJeiDjanoP6ai34BLycitKRVnI6soyFJSAB8uS6DlpIIs
	182n0OmRwf0wkkNxKAMRfLGnhddxg75ZSLHl0Dcz7XKk3fgmQmQ0/l7tt9LVX/ckVv/p/F
	eHUCAmPGrktKCOB72G6eFSA7vyRjNPU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=YBk76f/Ysfi12pI6VBVZpEi5qvewc/wR/esNF7jDIek=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792133969; v=1; x=1792738769;
 b=PJIEvhgdnZ0e7C84i83ESLZLLPkWdSIND9qyqkOJz7Z+T7Yf9+cgAP9qohOAKm/cOdEKacAP
 FY73ShLvzZf6gqjzguDaWodXkl5GEqM4VUhLudHSoQl6gT1J9R4GBbvjsCtnF+mO0hEsbRc6NGz
 R0Y6mm7+DfPpVptzQ0kE0i9o=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1616bc7e3c73b510;
	Fri, 16 Oct 2026 06:59:29 +0000
X-Mizu-Trace-ID: 1616bc7e3c73b510
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: david@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	kas@kernel.org,
	jack@suse.cz,
	djwong@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hch@lst.de,
	syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com,
	ngocthang2710.1999@gmail.com,
	willy@infradead.org,
	rppt@kernel.org,
	ljs@kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v3 1/1] khugepaged: fix readahead lock inversion in collapse_file()
Date: Fri, 16 Oct 2026 14:59:20 +0800
Message-ID: <20261016065920.4153-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C94F640004
X-Rspam-User: 
X-Stat-Signature: yfpkodxka8nko3uhmofghpd4seninecw
X-HE-Tag: 1792133972-110233
X-HE-Meta: U2FsdGVkX1+mXiPtpKf/Ti97cqfdNXgxuhZxeOvDqi59xDGOUvq2lP4aPLY6ZylnQHfE8nWlQ8Kcu3d3eCeczEIDu1ZAYCqPMWxP2pXEaQ+nlKr9NPU6PNPgaDrnfmsvsrh/yp8n6Xy9wpSFDBsNI1/eXQ5x7UyIKT3lcUgTqSJHR7+xHJzKeniU/qNPSjUMAyzjQJTm/lLs4b2LBYZcyUCaDD5FNHl8vKWTw/xRwM4xBzk3QqdYEOJcv9JfbV/vLHxXOTKwk6YFXwoKyohYVwCylgVmNU/JJeyOxboSkfJVuPmKWgh076JEYYtMPbEUiPWIgmF/e9ZhBi8rQJJCKb+7Q4w72+1CLh/5DvtiebTTOiN2bo8tJw+2PRpxZIK4xRSZPqR/soM+yImAgnI1XabJwUBmAgcPgh91jhLc77LDnJORi383keHRCih9HFo/FXZS1e9gAIbxD/p8oN31Nm0dKoCS4yYa1i3s6MVRzm94Swhcj0neOKOgD05JTGrntbjvs+ezSMGr67+SmaHQNm5c7q+8lgo+UMDG0qjVwt8BRcnCPqmT4W3JTiDs16FubWPxus3p7V3AMEq0SqlS0R/y7v61+J17COKrUYPghL1F/zVdgmSTcKpgkPJ2JFw2MomY1XlFRGYjvSjPsw4eKhGCV/QzitDXiPapZlxulj/do+/IlOcOAB/pFZTmajV7BjiUFzpYGA9sE/+CWorMzE6KAiBbLAqXPFu7C32t0UySvDSfYKl2zDJ8vp+EgweeFboyBSWLGRphcIT4w+ca4qixG/cIB21884o4MTvbIM7btAwpWJAZGJJn4B2S/Qp0qALYlmhGFkqMA8PeC2uB80o7Wao7fGE9vJiHoDkaXZ+asMRepqlyFGSRaFsHlZcEvmX3yP+owjmtt6TCRHVzfrEs/KcUNuV2Mci8sthHJ0hXeMJ2ZrmZSej+0au5BZiM4Vl8FR7xz4gF9ogqjml
 ho1Jjzl/
 YxaE81ZxNuL+Be9twTrYjRYwWX0hthDCdLYHEHVJTposJ/iSPzJqI5vgCazB54Lmjb8SqmTzvtkhy7Ds/KHmfvgAQEy4rrTYI1d67gPopdNRTqWBYoNoCbgWl9+I5She8Yp63OSSYHbrZCCIy34shCI8EC/btVYDU6tInP8fpXc/1wuvZfQB9ZdVLOhLPyLAcjVucxJwsUcHyDz6xfbiLzJ46SjoTokz7c4Q1AmotBcsO3AVrpBI6UjAk/3QthVlGwpEhbCovjjDIl8Uv1A55gkLguVE9x9627NU1mhdZ/Z6P6w24sTuVk+F7rlB2dnMiMfyg7gfSPIa9yR0nsNhm86VxuxtkiqyjRBvPNXOPHO5UmgYsQmkK0fV4homcpu1UF+EbMlJoFbNVju30tKSbF0BYP5OXZsEod+NfsIDRie6bBAmP4iF20ki9DDGxCwCndvwjsdy6wDnLW/6tbwdYLxSYd/x4zUCDlFVpJmkxuXEqkcKlAbq+q5L/klJx/zJSEaUIOgbB3cGYuG7/c2xEdgifYIlVz3xw/qFR9IVQTRx0UxygknSD5qRXISEFk7bBNj/msUZuuI+97P72+jozhUS8oD4/WYDDDdhT2CsN1vGvUsM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

collapse_file() can end up calling page_cache_sync_readahead() with
source folios from earlier in the range still locked. If truncate already
holds mapping->invalidate_lock exclusively and is waiting for one of
those folios, readahead blocks on the same invalidate_lock and neither
side can make progress.

Do readahead in a separate pass before we start holding source folios
locked for collapse. Keep page_cache_sync_readahead() and its existing
policy, and drop each folio's lock and reference after checking that it
is uptodate. If truncate or reclaim removes a folio between the two
passes, roll back instead of doing readahead again with source folios
locked.

Shmem handles swapin and fallocated folios through shmem_get_folio()
without taking mapping->invalidate_lock, so it isn't affected by this
lock inversion.

Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
Signed-off-by: Lance Yang <lance.yang@linux.dev>
---
Thanks to Nguyen Ngoc Thang for v2. David asked for volunteers, so I'm
happy to take this over.

Some older stable trees lack the folio infrastructure used here, and the
code will differ for each stable tree, so each backport will need quite a
bit of rework and its own review. I'm not sure whether to Cc stable here.
Once we agree on the fix, I'll send a separate backport for each maintained
stable tree except 5.10, which isn't affected.

v2 -> v3:
 - Replace the scan-wide invalidate_lock and page_cache_ra_unbounded() with
   a preparation pass using page_cache_sync_readahead().
 - Roll back on a new page cache miss during collapse.
 - https://lore.kernel.org/all/20260913163644.122133-1-ngocthang2710.1999@gmail.com/

 mm/khugepaged.c | 42 +++++++++++++++++++++++++++++++-----------
 1 file changed, 31 insertions(+), 11 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ef5cd6fda34f..b3f67617caf0 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2262,6 +2262,34 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 	new_folio->index = start;
 	new_folio->mapping = mapping;
 
+	if (!is_shmem) {
+		/*
+		 * Populate the range before accumulating locked source folios:
+		 * readahead may block on invalidate_lock.
+		 */
+		for (index = start; index < end;) {
+			folio = filemap_lock_folio(mapping, index);
+			if (IS_ERR(folio)) {
+				page_cache_sync_readahead(mapping, &file->f_ra,
+							  file, index, end - index);
+				folio = filemap_lock_folio(mapping, index);
+				if (IS_ERR(folio)) {
+					result = SCAN_FAIL;
+					goto rollback;
+				}
+			}
+			if (!folio_test_uptodate(folio))
+				result = SCAN_FAIL;
+			index = folio_next_index(folio);
+			folio_unlock(folio);
+			folio_put(folio);
+			if (result != SCAN_SUCCEED)
+				goto rollback;
+		}
+		/* drain lru cache to help folio_isolate_lru() */
+		lru_add_drain();
+	}
+
 	/*
 	 * Ensure we have slots for all the pages in the range.  This is
 	 * almost certainly a no-op because most of the pages must be present
@@ -2320,17 +2348,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
 			}
 		} else {	/* !is_shmem */
 			if (!folio || xa_is_value(folio)) {
-				xas_unlock_irq(&xas);
-				page_cache_sync_readahead(mapping, &file->f_ra,
-							  file, index,
-							  end - index);
-				/* drain lru cache to help folio_isolate_lru() */
-				lru_add_drain();
-				folio = filemap_lock_folio(mapping, index);
-				if (IS_ERR(folio)) {
-					result = SCAN_FAIL;
-					goto xa_unlocked;
-				}
+				/* The range changed after the preparation pass. */
+				result = SCAN_PAGE_LOCK;
+				goto xa_locked;
 			} else if (folio_test_dirty(folio)) {
 				/*
 				 * This page is dirty because it hasn't
-- 
2.49.0


