Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7312CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C49C6B00BF; Fri,  2 Oct 2026 05:57:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D226B00C0; Fri,  2 Oct 2026 05:57:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED856B00C1; Fri,  2 Oct 2026 05:57:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0647B6B00BF
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7F5A61206DD
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:20 +0000 (UTC)
X-FDA: 85277233440.23.3A27943
Received: from mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf07.hostedemail.com (Postfix) with ESMTP id 972E840002
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WrgzEM+W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HLTYrJYceauVb68wySayATZIcGvYhDhoDRuO/oujqfI=;
	b=c2VBag8KpAILmqPwBj75J+TFCBxtYNlPiwguSnofOdDZKxzhvRzIBqom/zYYb5sEEbW7oU
	FaNYWERjH/9oDThQy5XpYZg4b8Rt96jgDMFyk4stnKn2hdQHpOQydEg/MtYcCRNMhuhs5c
	FoftSlAuZ03nY7LDlqVchOjemg1Owhc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WrgzEM+W;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935038;
	b=gZftIfSltgJbJCBRvLSFjvGzrmyyePMj6m64XTVRx5qMMDcsmgxUWggY1rZHKiUtZpqBRL
	r1re2HJXPfawsRtUskA067cGPwVyrVflJBXCtSyVm3SPQQNYf9mqwmaiLaBqnnBgQAigWd
	ti5gqh19zQKJBRsWEtade4yK5/PMNwM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PmpEBPMCGBePeR65tGhRvp39CU+cDN/bw2BxnAbshOU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935037; v=1; x=1791539837;
 b=WrgzEM+WqqX2w4ih9Nppu1PuXJh6gY3cTNdLTTt0viSvXSQRPpAig7v1uKhVJqNOHSX/Od0j
 KhKBXStEwPvEqoDfe8NPKUSgnrp2VRopSRcF0iq9HarykFtqh4qqEhhhg7nOKuTwJwusBApcWcV
 9ZJGJPOoCWVvWiUrqV6hCHn8=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 46590f4179113d43;
	Fri, 02 Oct 2026 09:57:17 +0000
X-Mizu-Trace-ID: 46590f4179113d43
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
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
Subject: [PATCH v8 22/30] mm/madvise: keep PMD swap entries whole for MADV_GUARD_INSTALL/REMOVE
Date: Fri,  2 Oct 2026 02:52:36 -0700
Message-ID: <20261002095503.3585565-23-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uspqiztfts7ayry74pitkz3tpeuypxwp
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 972E840002
X-HE-Tag: 1790935038-202820
X-HE-Meta: U2FsdGVkX1+3ymPV9LFEhwmLCpzPx+fT29Z/De8U9snAIhSV8N0pghlUlWw7vNAKMCuDKB23/+Yg/8qHVnRT/dkiyzZXlFHIfXpyJKtewvIb9uJLCIBbhtwXR4AEWYXWTW4AcFUXn59whNyEHHLNZebYJ+59ezXibpkLaBpwCMCMjKFanU++FOhWON/fsiVRpqPfI3Qf6Alem1HhxDQx9/teCJXUHZ1upvx12Eo+toKnY2obyPo/Vglfe6t6WMw90AFD/0Q22gdWHaS5ED7BBMaVMZ0RvBEZ0NrT6wjK3aHNZHIag/0ghxomzsz/tKaefrR3mWMUISsevUPt2yelQPSGrZ07e94coMeWxEfd52OqpxTsdxkhUpQpwFfTqR/hxqzuoQs0e5A2GiLmPpVAH4dWZqCQvxyn+t07tF9tTOUvQO3wP1nqrT4a0c2INpj1dD4NB8Y8ipdBAn+qhMR/P8s3WLk3MwWfgpXFuMt3/7CoPCjZalCnDVeK7kDsjJkDqXmkrFhjHj3r+2kJ4quhsdz5vF0AuWMgMwKOFYSmOi0N39B99HcbkWmTr9xArlU5bel3RKSk1pDv9l7T6BVmo51GHi7YoLtGWGEWbNhDk6VyjwwFvmBTB2tmqNz1dhnNB4xbvfMvTRDE8osy4gKWJj60hqmGdW0tcPRiqm1Yw0vAyrszzXaSQ3qep2tCEhrHyNR+TW1SrxSPlWq6S/rivhX4Vflm3+RIEnAvn1jaXfJRCWEVcuNJPss62Ay3PPujXaTrAjtrZH58iZnmvlaaTzPHdbCRuFdxJ4CfaP6Y3lsMUWHnKbn1YuRJ+mJweRla08y7A/cSv8mnH0GAyxaZYPhty5Nn/54d3Z3fxqoGbby7tbn173oDrA8iEk+6hY7ST5XnGdY6HSMxvDMLIF2ekBeoNsk8Zz7ExXRLiiqeeWg3pansBwjDSACk3ac4tx9UD/6QckfS1TZ0YbXkQxX
 UAyb/ghr
 aQ1DikFs4iU0koMNfL7hndvdqSpxFKV8bG0a0ZrRR0laVBCaEm4Q2EwdWsYYa3TqD+Kdnn+XDyQbI1VIkv4raLXLtu0Vdq5v+xHrYt4EMoBqV8QC3uiLGyZ7FIEI1CwFp3EM8zY1V8RRYq1S7nLsso8S5Sfg1DVLVeqkvpYTrkh80wFPt3QIO/O1hpCbz4hObL0sF8eq0nVXHy5gLCh++zyCoJz+2lt1zoLUciKQA46sw00DjA7NPQDORo0L7l79KqATxLESUaHfiNJO5+tcYpkT6eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index d3b5ed7e3cffb..64019668d69fb 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1269,8 +1269,12 @@ static int guard_install_pmd_entry(pmd_t *pmd, unsigned long addr,
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
@@ -1409,8 +1413,12 @@ static int guard_remove_pmd_entry(pmd_t *pmd, unsigned long addr,
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


