Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2FCDCA0EF8
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 09:07:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E31338E0009; Wed, 20 Aug 2025 05:07:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6DBD8E003F; Wed, 20 Aug 2025 05:07:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8228E0009; Wed, 20 Aug 2025 05:07:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 971648E003E
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 05:07:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5DCE51D8E42
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:44 +0000 (UTC)
X-FDA: 83796558048.03.89861FC
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf12.hostedemail.com (Postfix) with ESMTP id 400AD40008
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:07:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Af7Jzs1/";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755680862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6PS3i58fU5+0vksauhTWhV82i4mcmoyJ+bQe1x8vgv8=;
	b=o5UgfKdS4AfOiduJlpe3hMCICUGXJwDY/Mdv6GVr0xT5StAwObt6b6nyNIUNFBPyRA6W16
	Mm2mBnAfYQAXEaQAH5wJ/BMAz2zIh+NpohHdwjWEPkUsiHa9msnAL3lWMH+MyHnM/O2hwJ
	GRy0oodfbpbCPq8Ycg/byUKGStsebl8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Af7Jzs1/";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755680862; a=rsa-sha256;
	cv=none;
	b=XVi2BXaJUN6fQZ4mm6vjtJc5w3ySblTwuWv3k89CfEcIfTmPTa+785d+CAouSAxvY7BJKw
	A69pxZ2rKgVqnrVg0v0BNT/6pzRRRLsvTGaABRf2JqtHCcV9cYncojlcN9ClEVfOO8xwyc
	6mlWfYk9MOz9KMP/yFuBcGYBx8cy/rE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755680859; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=6PS3i58fU5+0vksauhTWhV82i4mcmoyJ+bQe1x8vgv8=;
	b=Af7Jzs1/dkPttubPnPjwjNlxftQiHH8FJTDDTC9zmUPQkAAeYzluJP4XIUb5FVXbDNUJa17qg5gie50/JoM0SF6MpeMkthiB3lhtD2bojyTBEnrirYVhS9jilkG89btYGdSrS5ndqyU7zKhGxKNM8olWam1LPGNlqi+0lneve3g=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmBXj5E_1755680856 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 20 Aug 2025 17:07:37 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	hughd@google.com,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH 03/11] mm: khugepaged: add an order check for THP statistics
Date: Wed, 20 Aug 2025 17:07:14 +0800
Message-ID: <7c99eb27cf98615f80f7b14af479a2d1ea56b1f1.1755677674.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
References: <cover.1755677674.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: te8o9gir5c975cisucnpngr9ogtf5qc3
X-Rspam-User: 
X-Rspamd-Queue-Id: 400AD40008
X-Rspamd-Server: rspam05
X-HE-Tag: 1755680861-913232
X-HE-Meta: U2FsdGVkX18/JSGFnAVLKUnwa9zjJF41fSITcMLAB1bSal/NfcgiSTgaAFl9hjxWhWuOCWrMO9AXGVxCYHOXRgc0G0NoxkDC55EWIeDCwEGUZGRbsH0vLriVf+G2A3mV5iOHN1IL8zbcPx/YauCcic4H0CO6KauZvCeKFPY2tzWsUVge9lUSbLYls8X22cSuL0DOTGBYVU8TqRhQJaALmlDO90qfOa3i2RqeP0cBFzpYLWLRCDN0eWDxmPX/EGbM+WCV/2I99f1rlGuI4VPI1cVtOvWv6acVBSVexn4thLFpJLDWMsIIyFpk7oK83o0usIh8Wn/zSVvrpPBrWo4noBFK8qNdQ8OYokFraRqXBdwfP0kC2rGgNxiaqO7aHKGdmeVR9UZPHKvYUQTQUmi+B2eoBXJYqL62rR52Nc2lo3+EU1CA5Brtmn0UIOK+cK+JjHAhnPe6emT7C3I3CIm0X8FDwZi2JK9R04lg9L/U9BH5V4oc8pXWaB4KghebqSWWE8LIGjXDVdvn05kiMyS1q+FdRBncIFLz9PQqQuxuLRcPa+7HAd0lF2quYmtvsqPV9MKAbtIbi/wM4fFCvy4Y9p8rxnFIUesN0dX1Enwapzr6zuT+xRy5kNj3sm53PbA8RLb5++dAlxcITwWEkhOBSOZWHsgPcBusjHVaejIkV6fyERXNlaAlbB6v1hktca2f+VmlzZIF0s/ykeB4bV0bXz1Ie6wsABzZffafTJ9AHspQofnf+KBLo7WwNB8+0y/9OiE7f5FtSaLuJToC8sM2w09BW5R4bu/MsKjZM15G0TqyJiX1jlCVjaXVolqh0qe6gTdOofkXfPU22V2X55XFbqx2dqjpTCBF0NFReyljskHGEbiRLzoyzrTiRPMMzh9rFHQKL7LgmTy0nGd3c2qdVe+9reV6e7/WzXOa/n4nzsaiffb5pkFwtjUK//+3mbYwCPD89bQB6T7+2KU88d3
 rx36QsHj
 2iTmFBMYc3PWvl3/RBrAMe2u24Z5Q5O2UVpj3+P00VvIXysntaIn5KCh4ckEmvwRnYhajbUqtKn21ben/R6qAw+ELzaa4CKmRZ5AqlC3jJQ/uXgbFXkv6NNRnD1D3treIXwztpB+OqZ9BQlaEWD7OHy2TisSseF7hFBQtM+STkG4y0I4Xh255giUN7Y6IqIObaO13mH/idco/TrErsIk80PtwVzVCJzMFTYHvuDSNB6GokdZRsFTD0OS15OOT6la+Sr/mDDxMcNrWHBZi9EAk/6brH+qCVhM+fuCF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to support file/shmem mTHP collapse in the following patches, add
an PMD-sized THP order check to avoid PMD-sized THP statistics errors.

No functional changes.

Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/khugepaged.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index e64ed86d28ca..195c26699118 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2411,10 +2411,12 @@ static int collapse_file(struct mm_struct *mm, unsigned long addr,
 		xas_lock_irq(&xas);
 	}
 
-	if (is_shmem)
-		__lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
-	else
-		__lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
+	if (order == HPAGE_PMD_ORDER) {
+		if (is_shmem)
+			__lruvec_stat_mod_folio(new_folio, NR_SHMEM_THPS, HPAGE_PMD_NR);
+		else
+			__lruvec_stat_mod_folio(new_folio, NR_FILE_THPS, HPAGE_PMD_NR);
+	}
 
 	if (nr_none) {
 		__lruvec_stat_mod_folio(new_folio, NR_FILE_PAGES, nr_none);
-- 
2.43.5


