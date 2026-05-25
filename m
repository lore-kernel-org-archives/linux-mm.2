Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E7BDCD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 07:11:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3FFE6B0093; Mon, 25 May 2026 03:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D17DC6B0095; Mon, 25 May 2026 03:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2E186B0096; Mon, 25 May 2026 03:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ADF7F6B0093
	for <linux-mm@kvack.org>; Mon, 25 May 2026 03:11:49 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4FCE2C0616
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:11:49 +0000 (UTC)
X-FDA: 84805072338.29.7C365C4
Received: from SHSQR01.spreadtrum.com (unknown [222.66.158.135])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5786FA000C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:11:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=OsZdPPey;
	spf=pass (imf15.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779693107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WGgiuT8upSNZaz92rgjPyBJ4LtqfGYd9MIM5EPOpwOM=;
	b=wfF15R6Zf5pvPzd4QDbIpulsjRUu3hvIc4fhgnsskf0huIBfGgSXW/XHhgNCcaB+jrTgON
	Te5fSj3bFrE2kgBMnfSH71bPXITjAChiT9bLpLnVPhMz1Efnr77eKoeDcu39+85HIggKQl
	Uivwt2nI9moEKPDzJ4CHWHx+JR8vqic=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=unisoc.com header.s=default header.b=OsZdPPey;
	spf=pass (imf15.hostedemail.com: domain of zhaoyang.huang@unisoc.com designates 222.66.158.135 as permitted sender) smtp.mailfrom=zhaoyang.huang@unisoc.com;
	dmarc=pass (policy=quarantine) header.from=unisoc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779693107; a=rsa-sha256;
	cv=none;
	b=Gxh0hCBP6uEUh4cKzKpQLt8zgJ3P5hhccFr/WmCbeIvRV6OxYc65tzBNXfidRnb/KkFLQu
	Dqxbw2FNz8rUUFg5/s/BLYCL2R+ng0QPLMFJEfuaUwxXV161+KCXgartug5dLHFDKEXUqa
	UAU8mJtESv40tVLlpTkiKa6ksnaCxaY=
Received: from dlp.unisoc.com ([10.29.3.86])
	by SHSQR01.spreadtrum.com with ESMTP id 64P7Ah7Y086797;
	Mon, 25 May 2026 15:10:43 +0800 (+08)
	(envelope-from zhaoyang.huang@unisoc.com)
Received: from SHDLP.spreadtrum.com (BJMBX01.spreadtrum.com [10.0.64.7])
	by dlp.unisoc.com (SkyGuard) with ESMTPS id 4gP6Pq1vHKz2LknxW;
	Mon, 25 May 2026 15:06:55 +0800 (CST)
Received: from bj03382pcu03.spreadtrum.com (10.0.73.40) by
 BJMBX01.spreadtrum.com (10.0.64.7) with Microsoft SMTP Server (TLS) id
 15.0.1497.48; Mon, 25 May 2026 15:10:41 +0800
From: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Vlastimil Babka
	<vbabka@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko
	<mhocko@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Brendan Jackman
	<jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        Zhaoyang Huang <huangzhaoyang@gmail.com>, <steve.kang@unisoc.com>
Subject: [PATCH] mm: free HIGHATOMIC and CMA frozen pages via buddy
Date: Mon, 25 May 2026 15:10:33 +0800
Message-ID: <20260525071033.1104929-1-zhaoyang.huang@unisoc.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.0.73.40]
X-ClientProxiedBy: SHCAS03.spreadtrum.com (10.0.1.207) To
 BJMBX01.spreadtrum.com (10.0.64.7)
X-MAIL:SHSQR01.spreadtrum.com 64P7Ah7Y086797
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=unisoc.com;
	s=default; t=1779693065;
	bh=WGgiuT8upSNZaz92rgjPyBJ4LtqfGYd9MIM5EPOpwOM=;
	h=From:To:Subject:Date;
	b=OsZdPPeyEJDrQjPsTNy96LVO4gRLZ6kk67Y2fvbUiqoVAZe53IS6VPpWC90BG1yNc
	 jDVOz0jWcjS89UPotFkGUH+rd8GMb8M6O99HTdNUkaIxqdPbPBRxKN2NZl62lfWoXO
	 BMHTl6zdM1XfBVcVUoP0B6sWmT1s/8DONVLfFzCGDVWHrgpQEkCwOhn0Os/2yeSzkl
	 C8iku1bn6Zc2cvQZTtM62YoRFN1QicyCrqcLiDNECZmgMUFULhHWKILwfajCz+/84C
	 RMFhTWmlq30PfzBTmnSPkCVFlhNw6/3bg2s8JSoANms6kdN1UzhiHQlLIHFsxD/JcH
	 BjVoWIk3YnY1A==
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5786FA000C
X-Rspam-User: 
X-Stat-Signature: hxfmchy7p3bww4fu3sxmwnyargpzgj4g
X-HE-Tag: 1779693104-818113
X-HE-Meta: U2FsdGVkX18mFTdO19M/WGsB83bipLFqKSAsmgc6KfHlNklSBDuVy6T/AMaJd1jk0s/yvnBhkDi28w5jALqijDfboZ4z1ekeGFtQJzo2nXPze3v74wWQN0WuRvGc+PBTwt4+mLC8qtSFclvV/O7gPmm+L9pCd0uq6u8KVD6HsMZajgzP/AjS8vT33DSawHYtaXvK8tKfV19un9AAckCC5M+/qwnArUi/zcmswhkMMdrGu9pWnQCC415xldHEFERZpe+tIlRR3RIhK8Q1rN7BYU97J4aFrdHz50KHSvymOxqauwD7/C/C4tQIVRR6kStjZRae/3OBX7JjCBw9wxToo5+ytqcPRPB0oG07SVGhXYhGvEOAAV8Fozb2goMODF/LhJneRFEok/hsCKaa0/fXU0OUsU7/vCe3mWycYDBwHN04plvaU9wOEhrMptKXtTVVxuoPC52wPf5pdcYZYduVe6Lag58bbzJES+Kh6S6I0qIevNWOWtrGSu4mRnwDx/5jrb5M4Hxytf9EBt6bppxg8Jxp+ph0TvkoIMZ48CJ1THpEyhnuAAtq+T/li4ooh50rPUA2CeQ18l5xeH1RF+PpNWDQ/jK5a9VYR+yFkqMYr7gPoYQR2Ehtf+cNXu3rSY8V14WPMoEqA4qTurAwk48jzvfH60nwO/Xio+TZTakAax5xIEfkUw4UwKJnnHLWdZB40jHIxPEJlSEGH9JjhtidTLOiY9qNuKbndFFXzoIP57+CLNbwmtS3U6CwKXZof0K/rshCYsDThCkcTIRq0WDB6q0Ejg+DGKb9pAZtuCeVsNyj4DQDYtoLSWabvbsj78rlc9QqyGZKP+Wr0vgY79m//JHnhxxwjQpRKrZXnpCaLFD+MaOrUKJ+kWLDaDnDks+yA+XewFyRGGQWQiTT5b34wHtggDziai47Azv8hU/yAU7YJWdihXu1PiQIMsU9VjbxrsGZklKbp04vZM0N1lR
 sVkoZhH7
 RBVnbKsC80KBYXdROAZ8m//I9HbItVEbk1238cGVaFlz5aU01OfJhnrKazjKIp9EqK2rx020T9QwPfUeHqFUk4ekQ4KZB2OPd1VqCDnNTjP5h6QNUT/3eDO4JCwC3PsQmz5z5tWWbGKfnyJh1+QbesXF6w3Q+xS3rEsihECEFUKu0ZI+BGtLlOXavdEgV1+Kay7/47gSI89Os8daPzChEGuWsLEEkDWTwY3uCaCAmOi+vufrD4AlImbVh3Ea6SwfptmqmjXeui6aWj5ruOnxdAyn3X0eV7eGImhhM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

Pages in pageblocks above MIGRATE_PCPTYPES were remapped to
MIGRATE_MOVABLE on the per-CPU lists, so order-9 GFP_ATOMIC
allocations could consume CMA physical blocks which may lead to
cma_alloc failed.
This commit would like to free them through free_one_page() simply.

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
---
 mm/page_alloc.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 65e205111553..94b79db8da2f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2945,19 +2945,15 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
 
 	/*
 	 * We only track unmovable, reclaimable and movable on pcp lists.
-	 * Place ISOLATE pages on the isolated list because they are being
-	 * offlined but treat HIGHATOMIC and CMA as movable pages so we can
-	 * get those areas back if necessary. Otherwise, we may have to free
-	 * excessively into the page allocator
+	 * ISOLATE, HIGHATOMIC and CMA pageblocks are freed directly to the
+	 * buddy allocator so their migratetype is not misrouted on PCP lists
+	 * (e.g. order-9 pages must not share the MIGRATE_MOVABLE THP list).
 	 */
 	zone = page_zone(page);
 	migratetype = get_pfnblock_migratetype(page, pfn);
 	if (unlikely(migratetype >= MIGRATE_PCPTYPES)) {
-		if (unlikely(is_migrate_isolate(migratetype))) {
-			free_one_page(zone, page, pfn, order, fpi_flags);
-			return;
-		}
-		migratetype = MIGRATE_MOVABLE;
+		free_one_page(zone, page, pfn, order, fpi_flags);
+		return;
 	}
 
 	if (unlikely((fpi_flags & FPI_TRYLOCK) && IS_ENABLED(CONFIG_PREEMPT_RT)
@@ -3029,6 +3025,17 @@ void free_unref_folios(struct folio_batch *folios)
 		folio->private = NULL;
 		migratetype = get_pfnblock_migratetype(&folio->page, pfn);
 
+		if (unlikely(!is_migrate_isolate(migratetype) &&
+			     migratetype >= MIGRATE_PCPTYPES)) {
+			if (pcp) {
+				pcp_spin_unlock(pcp);
+				locked_zone = NULL;
+				pcp = NULL;
+			}
+			free_one_page(zone, &folio->page, pfn, order, FPI_NONE);
+			continue;
+		}
+
 		/* Different zone requires a different pcp lock */
 		if (zone != locked_zone ||
 		    is_migrate_isolate(migratetype)) {
@@ -3061,13 +3068,6 @@ void free_unref_folios(struct folio_batch *folios)
 			locked_zone = zone;
 		}
 
-		/*
-		 * Non-isolated types over MIGRATE_PCPTYPES get added
-		 * to the MIGRATE_MOVABLE pcp list.
-		 */
-		if (unlikely(migratetype >= MIGRATE_PCPTYPES))
-			migratetype = MIGRATE_MOVABLE;
-
 		trace_mm_page_free_batched(&folio->page);
 		if (!free_frozen_page_commit(zone, pcp, &folio->page,
 				migratetype, order, FPI_NONE)) {
-- 
2.25.1


