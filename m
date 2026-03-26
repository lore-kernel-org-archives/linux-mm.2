Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8733F106F2FC
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 011EA6B0098; Thu, 26 Mar 2026 04:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C196B0099; Thu, 26 Mar 2026 04:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43A16B009B; Thu, 26 Mar 2026 04:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5D636B0098
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:37:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6947F1A089A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:37:03 +0000 (UTC)
X-FDA: 84587559126.07.5073630
Received: from outbound.ci.icloud.com (ci-2005b-snip4-2.eps.apple.com [57.103.89.143])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5656D14000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:37:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="dZjRay/z";
	spf=pass (imf09.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.89.143 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774514221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWdo7Hdt7imdUj5xnZfV2DW+WMLcx/gdexYpPpAmv2g=;
	b=1QUPzO/nnhCU2sHZjmOtdyqtzsrRR34M9Q3MLjOJBxSGvksHHrklMeCGGAYTdRm5Lyo8uF
	5msDSaWTIHUmwlEEjgRcr+dCk+FP5hRbOs8jsCcmBhMvI6LtXvnJIijd+eQl73kQwbB+YH
	lKcPy92q9HGPdT5Qcp/1/xy8eCjQCiQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b="dZjRay/z";
	spf=pass (imf09.hostedemail.com: domain of zippermonkey@icloud.com designates 57.103.89.143 as permitted sender) smtp.mailfrom=zippermonkey@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774514221; a=rsa-sha256;
	cv=none;
	b=71foMLibVfcWb8vHwIkbtJv13suQFTkichQtxtQ6r/HiJ69SZEsQa5YrnhSV2+bysHCDeM
	XAjNYD14YxYqCaJK6/UWZqVxxTfIrU0dwCL88n5PC/6eVDo4QLOt9Jrf1BR07i73qXQK58
	GpDvjtFMHJOLp4Bl75EYEQ8Hv8XPe9M=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPS id 7ACBC18000B9;
	Thu, 26 Mar 2026 08:36:58 +0000 (UTC)
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1774514220; x=1777106220; bh=yWdo7Hdt7imdUj5xnZfV2DW+WMLcx/gdexYpPpAmv2g=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=dZjRay/zYVP9ZfZIq9IR9Ouux+kdLB73T3/H7PS/CxTNqUZpUrXi2SJNNnbn5U/PcZ1C8j08jwCg8iQFemd2oAbQ78zTz9GfDgiY2OChRSLTJfJeur4FSuBTaxW+xXtjeI8bw9LLzEZVhMdCDHDfCJbk2OnX1wpNlMW2S6WVwJvrlfbg7GgkOVu8Hlug2noLK+feQazD6gHFohZIt1Ou3Y/35L2skHRf7hw7kzY7ciKWWt/tdLzxGLKwt0P1Hxopw3iu1mQ4MQE09pdkWynQx6cGpTfAAQr45nWhObaoMiQiIDhySHqi1cGqIuFo+FlTt25eCyc75lH2R8uvagMjOg==
Received: from [21.6.122.162] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-11 (Postfix) with ESMTPSA id 178281800139;
	Thu, 26 Mar 2026 08:36:51 +0000 (UTC)
From: Zhang Peng <zippermonkey@icloud.com>
Date: Thu, 26 Mar 2026 16:36:20 +0800
Subject: [PATCH v2 4/5] mm/vmscan: extract folio unmap logic into
 folio_try_unmap()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260326-batch-tlb-flush-v2-4-403e523325c4@icloud.com>
References: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
In-Reply-To: <20260326-batch-tlb-flush-v2-0-403e523325c4@icloud.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Zhang Peng <bruzzhang@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774514187; l=3583;
 i=zippermonkey@icloud.com; s=20260309; h=from:subject:message-id;
 bh=Y4Ryu6QrIkBwzzotoKqlopBsSJ0saBN29iSqKN2EdmU=;
 b=Rj1I5FoCkrSh+ZfYn1ymUCAMwpL5FG1T5gr8wOnSdqruFLqr2zEJWvpWrW3tL6QnQT2lz6tyz
 ginbigcuZd0D5jDrdPi2cxV2hytVs6CDTY0uqXhgOlvIlIgPYMvP8+Q
X-Developer-Key: i=zippermonkey@icloud.com; a=ed25519;
 pk=tPCLpFnBfIyHsp0k7eaUTUREEa36bQNW/69X+NS8wBU=
X-Authority-Info-Out: v=2.4 cv=QO1lhwLL c=1 sm=1 tr=0 ts=69c4f02b
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10
 a=x7bEGLp0ZPQA:10 a=YE32fvk_ji8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=Eai1HigTdSjqxVI1HoIA:9 a=QEXdDO2ut3YA:10
 a=J82S1U87d15UFHHUFZS8:22 a=R6HnoDE5lksTgPyyjrIf:22
X-Proofpoint-ORIG-GUID: guicJJqKTU_NJdVTnchv-CoEO9VUaA9U
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI2MDA2MiBTYWx0ZWRfXzB/tM/gEjFLc
 1GlU7Mm6WDQqeTuKfWjZ5xHDGnnXO00F9FV4U5DQz4pRsng1Llcw9BTN+HSE5/UGWJPHK+/elEv
 259tQ8ZGQPdCiSE+yR9E4Lfgtt1OpI7sdQxeWeo4se7AGDx4QwMRXPLTSU0Ze5JSBQ/Yf2qzHss
 sZHV6QGF0iyxI2XOnY6Mq+W5BcbKghQp9MTtcbSRhAWKChgoZ08SWmecIx9FMsv+OLfRwv9dRgv
 wqTQIulXfpTDkVEvPV/YPhb2VoJrAjfGhoDbiGRhfJupEkz6Hh1V8B81vxZwW/iu895CAoN/S0q
 nIO1Nhoi9NkTaYVWmY+zFTAJwgnWZOE1Cotp4nx2m9500L+idmdN7p90gDnWBo=
X-Proofpoint-GUID: guicJJqKTU_NJdVTnchv-CoEO9VUaA9U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_02,2026-03-24_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 spamscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 lowpriorityscore=0 mlxlogscore=983 phishscore=0 mlxscore=0 classifier=spam
 authscore=0 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2603260062
X-Rspam-User: 
X-Rspamd-Queue-Id: 5656D14000E
X-Stat-Signature: ndaeghrkt1sbdpy85ky9ii57hhwxqwra
X-Rspamd-Server: rspam06
X-HE-Tag: 1774514221-789483
X-HE-Meta: U2FsdGVkX18cgiTrs18s+plYiLAMNYonxFwPteulDQuJXNGPmrus/oIRtdEAX7HFM2c5ccovGIEMqti/CeayXMQJS8TCKMTihBMpq1G9OE2NH7eyBA/40FRVOYjmIsNAkPHis6xoLCjwl9RfpGcE9TadIStnaGfd4KAH2vtnNLTyC6xyPL5T6FcZ6AhgIr7yuLMa/khhedZTCIvF3aad7J3AVMwFNnxexK3COuCajnHeCJEDcScDTp/r3kCnpHdSQkZIi1vvtCtZw8eCqtcie/Jf3UhRDEapvWf32OlZ6yES2ruzyNaY+ZFCBsnkTbd+vva2Xuvw9M6UPK9W2mlqPmdkgnqCZ0Soe5DI23iseAAR9w9eFwP4NsGRgABLqGZQ8olC+0m3pi4Haz2O6BcxtnxCIVDybaGyC4+UXmWQePyDD8SAkicxarQlj6xuIIV6DPnf9PcWOO6iePdEs6FrH7ALGnfrW5fE+dwQpUSt0M5/wd7hwJpU6XqXJO6j+VF7bi4DBRixFriCYqvqZXTxOaEyS5A7YJrKszes251FgoKWL5qvnYMvJUYkHsjyHcNhII/jaxssW9sxCyvbrkXhRN07auASh9FLvv+l97grfqrzlyXI/3+w2+Ge5r7wYOtm2DQf8shnWWS5Bt558M2/lN4PHNRPdSWEdu+Cy6zXQ7Z6n9Etdzt3aRywe7FWgtkFYvvaQq3iFHQ93NmHWIxweXZmEr+mG0aAmElfJW0ODTqE6NUPPJ5DS426IOgtr2b8xR23tiXPkspzx23s9cuhRltq7XyI6zjZwjoIfLH8ovV5q+VQ3mnhBrz39vXpwKTS6aLLOa3HwOuBzEOG0KGOd460UwMepFoyEYNeJy3HDY4S/5T2IFFuoIrXzFugKNb7jX5xcc5g5zU7MXNqxAiOyoajPHknIwve8B4Xm5aK+BrZcDRAWHujevRaaN2KOxreGGUiMFF6KFaJFQXPmHc
 B3zUf8ab
 hdUA3e14TVcUwdoOtxvkpN1ul8+RzSCEBeVT8Acpe69klW2XfI5uDJ4BV/6tRoW7/WBtpFJH7A30ZzXR8ka5H4fo87shKVJTCtHAmNkyuyMxk1KLVDu9ePj1YbJBuAjy4CJ31Tr98Pt2DPqNkgLn33AAtaPCKNvZj70v7Ool8wWhhpT1uXcusVDZ81iTFXugqq8Rql5YRB67dijxM0Xbjvcz1TlgJoONd7Nd22FSPioRRm0dEKoswTwQQ1d6YyPnqVXXZdpbjyx7Z2QWWFGu+iI1fvwilBNtLJDNH0SdoCGZe1J76sSu3wGhSa/Sx6BQK5rkq41/3hTDhlE6J9qbEANDsi0pxxA9b605aOuiernFwK9lSp2HWQLsFh+4v+Jlo2YF3gKdlQCLxMd7KWaXqWYLaq68os72K12N01WcIvvS1TKxvXVA+XeUZCJ4KoyHIH/IK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhang Peng <bruzzhang@tencent.com>

shrink_folio_list() contains a self-contained block that sets up
TTU flags and calls try_to_unmap(), accounting for failures via
reclaim_stat. Extract it into folio_try_unmap() to reduce the size
of shrink_folio_list() and make the unmap step independently readable.

No functional change.

Suggested-by: Kairui Song <kasong@tencent.com>
Signed-off-by: Zhang Peng <bruzzhang@tencent.com>
---
 mm/vmscan.c | 70 +++++++++++++++++++++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 30 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c8ff742ed891..63cc88c875e8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1217,6 +1217,44 @@ static void pageout_one(struct folio *folio, struct list_head *ret_folios,
 			folio_test_unevictable(folio), folio);
 }
 
+static bool folio_try_unmap(struct folio *folio, struct reclaim_stat *stat,
+			    unsigned int nr_pages)
+{
+	enum ttu_flags flags = TTU_BATCH_FLUSH;
+	bool was_swapbacked;
+
+	if (!folio_mapped(folio))
+		return true;
+
+	was_swapbacked = folio_test_swapbacked(folio);
+	if (folio_test_pmd_mappable(folio))
+		flags |= TTU_SPLIT_HUGE_PMD;
+	/*
+	 * Without TTU_SYNC, try_to_unmap will only begin to
+	 * hold PTL from the first present PTE within a large
+	 * folio. Some initial PTEs might be skipped due to
+	 * races with parallel PTE writes in which PTEs can be
+	 * cleared temporarily before being written new present
+	 * values. This will lead to a large folio is still
+	 * mapped while some subpages have been partially
+	 * unmapped after try_to_unmap; TTU_SYNC helps
+	 * try_to_unmap acquire PTL from the first PTE,
+	 * eliminating the influence of temporary PTE values.
+	 */
+	if (folio_test_large(folio))
+		flags |= TTU_SYNC;
+
+	try_to_unmap(folio, flags);
+	if (folio_mapped(folio)) {
+		stat->nr_unmap_fail += nr_pages;
+		if (!was_swapbacked &&
+		    folio_test_swapbacked(folio))
+			stat->nr_lazyfree_fail += nr_pages;
+		return false;
+	}
+	return true;
+}
+
 /*
  * Reclaimed folios are counted in stat->nr_reclaimed.
  */
@@ -1491,36 +1529,8 @@ static void shrink_folio_list(struct list_head *folio_list,
 		 * The folio is mapped into the page tables of one or more
 		 * processes. Try to unmap it here.
 		 */
-		if (folio_mapped(folio)) {
-			enum ttu_flags flags = TTU_BATCH_FLUSH;
-			bool was_swapbacked = folio_test_swapbacked(folio);
-
-			if (folio_test_pmd_mappable(folio))
-				flags |= TTU_SPLIT_HUGE_PMD;
-			/*
-			 * Without TTU_SYNC, try_to_unmap will only begin to
-			 * hold PTL from the first present PTE within a large
-			 * folio. Some initial PTEs might be skipped due to
-			 * races with parallel PTE writes in which PTEs can be
-			 * cleared temporarily before being written new present
-			 * values. This will lead to a large folio is still
-			 * mapped while some subpages have been partially
-			 * unmapped after try_to_unmap; TTU_SYNC helps
-			 * try_to_unmap acquire PTL from the first PTE,
-			 * eliminating the influence of temporary PTE values.
-			 */
-			if (folio_test_large(folio))
-				flags |= TTU_SYNC;
-
-			try_to_unmap(folio, flags);
-			if (folio_mapped(folio)) {
-				stat->nr_unmap_fail += nr_pages;
-				if (!was_swapbacked &&
-				    folio_test_swapbacked(folio))
-					stat->nr_lazyfree_fail += nr_pages;
-				goto activate_locked;
-			}
-		}
+		if (!folio_try_unmap(folio, stat, nr_pages))
+			goto activate_locked;
 
 		/*
 		 * Folio is unmapped now so it cannot be newly pinned anymore.

-- 
2.43.7


