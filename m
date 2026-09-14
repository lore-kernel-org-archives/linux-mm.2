Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16C87C88E67
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 08:05:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC3856B0092; Mon, 14 Sep 2026 04:05:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C73FD6B0093; Mon, 14 Sep 2026 04:05:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CE96B0095; Mon, 14 Sep 2026 04:05:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8F8D36B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 04:05:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1B0FE160FE2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:05:04 +0000 (UTC)
X-FDA: 85211632128.06.683DB67
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf15.hostedemail.com (Postfix) with ESMTP id F359EA0004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:05:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789373102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=6H0qSda6YlF1cCOr2wv1NyggSpI2I02oHT/J3TcgXs8=;
	b=S+ZRRft0mhIo+6RkOq+RvxFqDYAr6mLqdXZGgCDRCDntglPnqfwtn9QruBnlqDIjl9dd1N
	Knlfn1OXdW23YIOSHKf8/KpIu26/DpIhqT1Yks6wzb262BosKTon45jCOoV53p+AN31tdc
	j6bh+1yM9BXmtY5L79XF5UCzstdiIcQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789373102;
	b=FGwzgq5gcmFJPyGzhi47y5KOYTTYhGHFTOqbDk9LTcD1+vJNZ8bHjy+ZGkBqL2V1yi43xT
	wro0L0iZGggcoZSVm0D4iHxLbCmBtbFpinHEz5wkx9+p8tB/TvBV0wdzc61QlMjtH2oZqr
	w4wfqdEKpyueoqzgFE63fxlsL1PER1w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of liuqiqi@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=liuqiqi@kylinos.cn;
	dmarc=none
X-UUID: f87bc8d0b01211f19a56ed5b684f684d-20260914
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:a3771e0c-53e6-4c4f-922d-0948eb8dba23,IP:0,U
	RL:5,TC:0,Content:-25,EDM:25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTI
	ON:release,TS:5
X-CID-META: VersionHash:7db8b62,CLOUDID:f7d32dfd53290b8c3cc408f3885045e8,BulkI
	D:nil,BulkQuantity:0,SF:102|850|865|898,TC:nil,Content:0|15|50|99,EDM:5,IP
	:nil,URL:99|95|82|11|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR,TF_CID_SPAM_ULN
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f87bc8d0b01211f19a56ed5b684f684d-20260914
X-User: liuqiqi@kylinos.cn
Received: from localhost.localdomain [(10.44.16.150)] by mailgw.kylinos.cn
	(envelope-from <liuqiqi@kylinos.cn>)
	(Generic MTA with TLSv1.3 TLS_AES_256_GCM_SHA384 256/256)
	with ESMTP id 873099512; Mon, 14 Sep 2026 16:04:54 +0800
From: Qiqi Liu <liuqiqi@kylinos.cn>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiqi Liu <liuqiqi@kylinos.cn>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/page_alloc: apply per-task GFP context in bulk allocator
Date: Mon, 14 Sep 2026 16:04:51 +0800
Message-Id: <20260914080451.294896-1-liuqiqi@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pec653dkxnmpusajh3gcwkssosjmikfa
X-Rspam-User: 
X-Rspamd-Queue-Id: F359EA0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789373100-688685
X-HE-Meta: U2FsdGVkX18piLyc8NY7xvTryfFt2H+XrdGBMy6gSPcfrXtPGWvwusJnLp9eNvHLFq8fSBvqrXTFJcmpf5GgwcpdiMzQhpNLwYNY3Aq+qTUoXKjLSfxRo+YXIbSrpidR8ShJwQJhaWpD6jetTJJ2v46SvlxFMUwsJn1nT75gp3bvj7vaBCQZ+XbwHbl6LwHNTNGtThNeaVczG0nDvdZ1D56+ROA0pbXiWxTgMvu35o/TnaX5FyKCANtBkiYLuHMdPYBO5NeoK/ODnEVgitMe7OGWc2KgKP5pjHTLp2cizvP9k4I4Rv/yGHGWV3kZybjM0kPGLtkkyWFAZazqLCNTumGOBTutcFD9wWQ1ZYov88LfLFPqqfOd/sVo/Arls+BZ3QmPtXtKDU52u+iZD0924hKbR7yi+C18dalsW7lzZrYgo+25C+h87d9vJrw10gs5X24H18r2JBVhLY0Xrc4duU371dyWaCuJ/ps5xTJpcbrLljdD68tUu+/Eae6paHDTLI8B8FFhYuH22xHtCM6wmI2AwxQGPqL6kEZh7mKQfHAcFEvV8Mur/5T+E15NVj7yfesC0RVreIkufP3aT1GtOE7IClmhNxq7vTY+YeUrdrI2aCuqzBos7QV2/LWe4Ag+hC1xvaYlcNFq/NHoSXfr7YRbQHy6rKJ9rHh+2sSwR19EUiIH+k+Z8PnPKZdU/K+nIMYwfa/aotDu7fthHRw5dgnAsEddjRbMYuOh9at3YG+YeUAoX9okC+FcGveSr6U8qLnh3khwq7aZ1jJuXedkzFAU+IPectm22OOiW++QsqAzHO6g2AhgwpTJ/ZZogCE+JEgmO3x7xf984CsCKmTlRV3wdka5ugKF3xLS0j8+DRtbfGvLNdrlvSdVmU02Dt1eparsUzThjO7mR9NFrDkcqXAWjlTHLCBes+2RUF49CEgAsprFDOYlAghG288EOhov/YZ0E/vB1FTXXGoGFRc
 2TkPRXZa
 7H/OL+6+AGDxBkn0b0ksenD6lAL3xLZpNq1z17upYVC2RoNbWWo2YOTlxlL91Bsi2lcv/JKT2jQXHQVdgBtjk2DvQMwphwTLH4MD6JAM+HAIXMtqdyuLPdW494eVlg6XlpnPs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

alloc_pages_bulk_noprof() does not call current_gfp_context(), so
per-task scoped allocation constraints (PF_MEMALLOC_NOIO,
PF_MEMALLOC_NOFS, PF_MEMALLOC_PIN) are not applied on the bulk fast
path.

The most direct consequence is PF_MEMALLOC_PIN: without clearing
__GFP_MOVABLE, prepare_alloc_pages() selects MIGRATE_MOVABLE for
the PCP list, and a task with PF_MEMALLOC_PIN set receives movable
pages from the bulk allocator.  Once pinned, these pages can no
longer be migrated but remain in MOVABLE pageblocks, violating the
mobility contract.  This can increase fragmentation and interfere
with compaction or contiguous-memory allocations, eventually
surfacing as higher allocation latency or allocation failures under
memory pressure.

Found via review of the bulk allocation tracepoint hooks [1].

[1] https://lore.kernel.org/all/20260907120949.418450-1-liuqiqi@kylinos.cn/
Link: https://sashiko.dev/#/patchset/20260907120949.418450-1-liuqiqi%40kylinos.cn
Fixes: 387ba26fb1cb ("mm/page_alloc: add a bulk page allocator")
Cc: stable@vger.kernel.org
Signed-off-by: Qiqi Liu <liuqiqi@kylinos.cn>
---
 mm/page_alloc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 12fac9084c48..3be7288a1aa7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5207,6 +5207,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 
 	/* May set ALLOC_NOFRAGMENT, fragmentation will return 1 page. */
 	gfp &= gfp_allowed_mask;
+	gfp = current_gfp_context(gfp);
 	if (!prepare_alloc_pages(gfp, 0, preferred_nid, nodemask, &ac, &gfp, &alloc_flags))
 		goto out;
 
-- 
2.25.1


