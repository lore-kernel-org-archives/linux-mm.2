Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46050CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4A058E0015; Wed, 12 Nov 2025 10:42:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FAC48E0002; Wed, 12 Nov 2025 10:42:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910BC8E0015; Wed, 12 Nov 2025 10:42:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5438E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C1A61403DA
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:23 +0000 (UTC)
X-FDA: 84102371766.06.7E9EF42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 53DAB140015
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q476rGfT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962141; a=rsa-sha256;
	cv=none;
	b=T1mM1DNw1WQmIyeu2YUnD0tODVjMXWZqlrgdvJZujtRVZglFtw7AekAL9C5rgYOkL++TaO
	ZnY9H0W6TWYv3PRgePQq6Lexu4cjaa7Y8O8teg97oGrOn+MVT9bp0r1BTB6QH7vJE4OBa0
	p0Sd92TPcrToF1uo6INrNntzZ2giuTE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q476rGfT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7l7kWlaXXjGCDiC3F04ra8CKgs49uXjm136f4ME0PEk=;
	b=Q8E7i9Zf7fbcR160PgBijLkCAQXcgPK0yvUQXmVfoADD2GkmV1I+ma04hClq9DJr3lI7QC
	SBxmEFhyYxmj/OpnzpcoLJF1Aq0t8ZJewpfCmU0z3uqmpGiS+XUnrc7mQkoWRVNMgCh9/8
	s2Qk0xSs+eCfwjql6jmSaSRDEoUmGxg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 79141435D9;
	Wed, 12 Nov 2025 15:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 977D6C4CEF5;
	Wed, 12 Nov 2025 15:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762962140;
	bh=1rHJgGszkdfaLNjPQTgFPJf9bjvlypOeFoo13vrtMto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q476rGfTrYl4tz8y5mq9CS1pT/6YlSCHU1cNxcS1yQ8qnfxTacdAaWz1jFQQnceTr
	 DE6zFlkuS6mCsTM0RV0tOC9XXJ23ZVUdZA3ghKdZg2l1qT2gxRJbjIEILdLoh3AEL1
	 2sxKFoTiOAshj+O8U2L4k9I5tRmY/us7DyiDq2OdmzqQZbtILTfbgMTjKDw2hUBPuf
	 OK61rWD5sGnqkImo1IwtrkZRX5ekoiizatRueQLw0LL9bR2v/73lDx2EbZDzJ8czTq
	 yknaZdVaOadcM0nw03uf4QBB/7xIKBAljlfyuQmFHdBl9WMRG3ziJux/jJd9IWeTit
	 JdpXoNuP94qEQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Hugh Dickins <hughd@google.com>
Subject: [PATCH 3/9] mm/damon/vaddr: cleanup using pmd_trans_huge_lock()
Date: Wed, 12 Nov 2025 07:41:06 -0800
Message-ID: <20251112154114.66053-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112154114.66053-1-sj@kernel.org>
References: <20251112154114.66053-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 53DAB140015
X-Stat-Signature: xb6p7x5m9e9w9wounrjmxj37jid17rz4
X-HE-Tag: 1762962141-991360
X-HE-Meta: U2FsdGVkX1/GnAnh8ceGaGSq7MDCllvWY6sbCPhXQvwaVHp/osZEuu6NunQ1sRerZYGA5rMTucZOEXmx+JIgw6mswNgESbH9uj94py7e9vfGMo2051xBc7rvlFxLLruNADvTfRJqSJNHDek/O+60MmzqsFPnKdtXAAjdViuBcYmtcQYmYAZbElRr7SJDirw6VPxtfh+mJGv77weTzpMZS/NfdPXGzufgVcQjkJHewd5XxMAriuqoB8s9KCwK42QFmRcJC/xXd8lxo1MhxQfQARdfyngbNcs0u61IwEjbzflp8bf/ntIrQI3am6aaqIqnPJShnbviSvmZe2CLCvrXfGpMnNAOE7smfpVztpm7Fmn94EIsFibe1ZSWjpAGL2Stt4BImqYnJty7c8oZf86r3fW6ydGxpCQ+MynABhqOMs9FPT2jR3ddhB+7BHYHaH+VjFsWCdOLlF5+fAuFkpW8RHufX4ULYpgTeV/IEWGEngesTuk32D/0TJlpxMDAueXHY9p+B1rcbH1lGJKi1uwJX/G+nNOQffE8N5kmNda1ufEOgpCLshOXmEX48Xa3gUQVy3akzFFvPUVWc6Y+EnZOzFP6kWUisMv4bVTkOKfMO5AdQ6gPKK5Uq9vWoIZug3S2oRs8lcAxNjQ+gnuvfKEiVwJQo4FfT5/u+AfN2OX5lhKnKvImgxcDsIgNQqlh0xVohOnUObCfxZMRtMe4hDn4YJEs4hl7iqDfsXQuC69jFRVwGyVLBcovVRSXvGf/aJsvkZHL/f1ItjDtJr3QZc7vUtsSp+T2srdiE+uPfvxk5p0/RYW35r6NjWKbiEfUZBN13CuIhkYtQ72mUNW318s4el6+91rN3G3cR9KRCOjoDVLF6Br40i50MQhdAXGTi8ClJcw1XU46yQPtVHgPxcQaDmQuoRbK3VnhtgsiQSHsse5fVztnkqDGoosMAqcPm06diaWMoqOCrTE/hkIISO+
 T9v7IngQ
 V4okoZpo72LqjnpB3iuVPQCOqYGUQlAHUjROUlkyOhTmRnoXua1jCMlYfZNAUY3NB4nmwy/YLVZ2yVU8p1VesKmDS1G3Bz9vwlSDkKFAAokJE8QGYP9DCcr02r5eJmPDc7RhEVI186gTSYWusdBQ8+imqNNp99oyVs9yAALx7Lf6kIuNPr0bczPCh1NIerYe2PEeXHG/wWzJNt7D7Eo5f3NWYnx/7Eg1Qg5CCC+GSylY5qnF6udZduGOxB13TjPyigENfPPqvQEuy3I7v9Po7wgFTNeL+jy18wQ/MzHCRPcyiP6M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Three pmd walk functions in vaddr.c are using pmd_trans_huge() and
pmd_lock() to handle THPs.  Simplify the code by replacing the two
function calls with a single pmd_trans_huge_lock() call.

Note that this cleanup is not only reducing the lines of code, but also
simplifies code execution flows for migration entries case, as kindly
explained [1] by Hugh, who suggested this cleanup.

[1] https://lore.kernel.org/296c2b3f-6748-158f-b85d-2952165c0588@google.com

Suggested-by: Hugh Dickins <hughd@google.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 48 ++++++++++++------------------------------------
 1 file changed, 12 insertions(+), 36 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 7e834467b2d8..0ad1ce120aa1 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -307,24 +307,14 @@ static int damon_mkold_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
 	pte_t *pte;
-	pmd_t pmde;
 	spinlock_t *ptl;
 
-	if (pmd_trans_huge(pmdp_get(pmd))) {
-		ptl = pmd_lock(walk->mm, pmd);
-		pmde = pmdp_get(pmd);
-
-		if (!pmd_present(pmde)) {
-			spin_unlock(ptl);
-			return 0;
-		}
-
-		if (pmd_trans_huge(pmde)) {
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		if (pmd_present(pmdp_get(pmd)))
 			damon_pmdp_mkold(pmd, walk->vma, addr);
-			spin_unlock(ptl);
-			return 0;
-		}
 		spin_unlock(ptl);
+		return 0;
 	}
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
@@ -446,21 +436,12 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct damon_young_walk_private *priv = walk->private;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(pmdp_get(pmd))) {
-		pmd_t pmde;
-
-		ptl = pmd_lock(walk->mm, pmd);
-		pmde = pmdp_get(pmd);
+	ptl = pmd_trans_huge_lock(pmd, walk->vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
 
-		if (!pmd_present(pmde)) {
-			spin_unlock(ptl);
-			return 0;
-		}
-
-		if (!pmd_trans_huge(pmde)) {
-			spin_unlock(ptl);
-			goto regular_page;
-		}
+		if (!pmd_present(pmde))
+			goto huge_out;
 		folio = damon_get_folio(pmd_pfn(pmde));
 		if (!folio)
 			goto huge_out;
@@ -474,8 +455,6 @@ static int damon_young_pmd_entry(pmd_t *pmd, unsigned long addr,
 		spin_unlock(ptl);
 		return 0;
 	}
-
-regular_page:
 #endif	/* CONFIG_TRANSPARENT_HUGEPAGE */
 
 	pte = pte_offset_map_lock(walk->mm, pmd, addr, &ptl);
@@ -910,13 +889,10 @@ static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 	int nr;
 
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	if (pmd_trans_huge(*pmd)) {
-		pmd_t pmde;
+	ptl = pmd_trans_huge_lock(pmd, vma);
+	if (ptl) {
+		pmd_t pmde = pmdp_get(pmd);
 
-		ptl = pmd_trans_huge_lock(pmd, vma);
-		if (!ptl)
-			return 0;
-		pmde = pmdp_get(pmd);
 		if (!pmd_present(pmde))
 			goto huge_unlock;
 
-- 
2.47.3

