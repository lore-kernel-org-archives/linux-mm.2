Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1C14606A33A
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:42:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=L6jwir4L
Received: by kanga.kvack.org (Postfix)
	id 781FE6B05DC; Thu,  5 Nov 2026 13:42:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732A96B05DD; Thu,  5 Nov 2026 13:42:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 621636B05DE; Thu,  5 Nov 2026 13:42:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3F7576B05DC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:42:08 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DB1F04097C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:07 +0000 (UTC)
X-FDA: 85401935094.13.66D5493
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	by imf31.hostedemail.com (Postfix) with ESMTP id 45E6D20008
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:42:07 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L6jwir4L;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z0fJm4CjdrCfT5IXpHPP6Zmi1Pfjwt/oCSIBuUnP62M=;
	b=TwhQEktaZRg3yElpb1eAMRyq9soNPVCM0UuX4yhq+sA/YPiiFNEQ5f83DX46but7zOptnE
	hhOIaUtGadN6zifYTE/uErW/bY5nQTqZfrscaCfa4PdKl7i7bQ3/tYmw64LCs3JuE3oGZN
	f/bXlhUiNsAlXu3HSFkPniNVCmi8EeE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L6jwir4L;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904126;
	b=WnoUa8+0YldKeQaAk6VdrEYZUCcO5eXvRsmDVBoHJRl6cORge8rXRUUtAfsq+tT+qAtKZi
	q9tw2m4m4GgzWWzAEeGHj+0N1YzQqX34TSwLjrpcjyd6cYRbofr2Qbc+vpbEzu72io8jTn
	HY9ywvtQ0C9fCv6dG8xmLlF4F5JBJzM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4MFauMfvLoZ0FPm6jb4sWsILjkooRhf2DKKgeqRebo8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904125; v=1; x=1794508925;
 b=L6jwir4LMQEAZ22XcDmNgjUpAJKU1ky/Q6gVZb3mmTm5P9C0Elzoh0g7VQ/+oBUI5z7cxeFN
 8anikLSWjGeRSMpePBqmDgoLirtXghAi4D7TG15qBMQEYl8rEn4fjvMWT+m+3uK8c1XnW/SQ+HX
 XDoVeJfEN5FnTSOPh6ytR/3o=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 6e1d522fd8af9a39;
	Thu, 05 Nov 2026 18:42:04 +0000
X-Mizu-Trace-ID: 6e1d522fd8af9a39
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v9 24/32] mm/madvise: keep PMD swap entries whole for MADV_GUARD_INSTALL/REMOVE
Date: Thu,  5 Nov 2026 10:39:08 -0800
Message-ID: <20261105183940.2236717-25-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 45E6D20008
X-Stat-Signature: z1odxnsehtc1g8e5q9ak9x7jotquar1j
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793904127-300492
X-HE-Meta: U2FsdGVkX18xxkTmCoD4c5oASv1xCc/SJVGa1Q+g3jM1lvSje/Nhv6lZOgER19U891xibPkPsDL/fsXsufk/zLTConF9xB6pgiMATGHLfF6///mUbebEKKfUj5G8wOomB/lYwQJgLw/0taqYFaXf9Q7IT8TQliwvztX/YBk45dFyF+cbsMZG1PcgUFADN9EmYzM2W8eJbK+QUZH3Hens7mg7XCFTmpN6QHKX5CgG4BHl01AuLAUSDjrdpm8d3pcBn0Wvrn3wGjp9YV4OpB/SY6zVNegvv4gEiuMCZPS3q1HaChcXzxNDEwwTFAwXaEusS71ePbliZzNVQyPaCg1BypHCPt3CnDVVKQ7RE2lvmgsrdRtAB6NRKgtkni27HmX3Chch4XbupJ8exsvVrD0Gl02xamnxo4a8c6mr/330MLvzpX2r5ykH1SaNnqkdTH0dS8Qb94GMtv4gyY2MdJC7auEPxZaruDMbhygN7zvmKXJzijY50yK9FftKumig21aGWVkMSl4NldgzdKl+qwkamigVCWOigwf9uMbO1TNjaeLIh285Jo+TPqdHJtsf2yAPJHmHPNqvAOLDFdwZRm/DhhUlvM7kcFIK2KjBly7Ay8uif2d9itHfwZ/VCtftonFxXHpZ46I7kUZjR3kVjrxENDfs6B51ML0gbST5o85srYzrdMZ79JPfZhnDTevlHZH6dD9kYqC9sZFEDLX2DDY4E55EQQ/wr+Pnoeo2sxLHDJv7FfPTGsmzxfxRW4uXnDf+ilZpzYWxdrWjhPMa6cCOd22pBk5mPg4clmJUvJatfLSIbkrUamkRVcgsgQgZjx9q3/ZAQ2+mxlnO101JM+vCcJleeFoynZ6iU6c4LdVYTSdaNbJcU1z6GQPDO0UxrLsOgjP/yuFswqiqJE19mMcK2n3UrI32t+u4yAoSkbci4s4qIpHDFiJ+fKEwFcZh2dDjJPbsL+jpTG5WHrfYiNA
 GhXW8hvR
 HcCBg3N+h/Lx7SRdQBohppJnh1ThZc7mhWhzB2wBWi1sNPDpGz9MRa2VGx75bN7Z2soCVtt+fnMVaL8J8hU2PvdynMzVkBmADU3F1VK3MXvjK5vrJQIJdytDc9FGgaLCCebwhryaPTt/2E9/EkUS8EbnDyQuOnqfQkbopX+EGfNY8T3yRzxNvWVBxxO0ndfXVGO8ym6e7TvWJ1KnFNmnSgAE1es7VhSpb4KuvY96OCRPGXVmCqEF6LJwcOk0JKRysD7/EwCK03fI40ICK7/ok2LNmLA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both callbacks test bare pmd_trans_huge(), which is false for a PMD swap
entry, so they return without consuming the PMD and walk_pmd_range() splits
it - only for the PTE callbacks to find the range populated and abort, or
to find no guard markers and do nothing.

Both already short-circuit at PMD level for a present THP. Do the same for
a swapped-out one: it is just as populated, and just as free of guard
markers.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/madvise.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/mm/madvise.c b/mm/madvise.c
index 576707e303cf2..f7f17efdd926d 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1109,8 +1109,12 @@ static int guard_install_pmd_entry(pmd_t *pmd, unsigned long addr,
 {
 	pmd_t pmdval = pmdp_get(pmd);
 
-	/* If huge return >0 so we abort the operation + zap. */
-	return pmd_trans_huge(pmdval);
+	/*
+	 * If huge return >0 so we abort the operation + zap. A PMD swap entry
+	 * is a swapped-out THP: also populated, and splitting it here would
+	 * only demote it before the zap.
+	 */
+	return pmd_trans_huge(pmdval) || pmd_is_swap_entry(pmdval);
 }
 
 static int guard_install_pte_entry(pte_t *pte, unsigned long addr,
@@ -1249,8 +1253,12 @@ static int guard_remove_pmd_entry(pmd_t *pmd, unsigned long addr,
 {
 	pmd_t pmdval = pmdp_get(pmd);
 
-	/* If huge, cannot have guard pages present, so no-op - skip. */
-	if (pmd_trans_huge(pmdval))
+	/*
+	 * If huge, cannot have guard pages present, so no-op - skip. The same
+	 * is true of a PMD swap entry, which must not be split just to discover
+	 * there is nothing to remove.
+	 */
+	if (pmd_trans_huge(pmdval) || pmd_is_swap_entry(pmdval))
 		walk->action = ACTION_CONTINUE;
 
 	return 0;
-- 
2.53.0-Meta


