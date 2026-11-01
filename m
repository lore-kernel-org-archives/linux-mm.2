Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3DD3606A32F
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mRVe0/+Y
Received: by kanga.kvack.org (Postfix)
	id D48376B05B3; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D20186B05B5; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C351A6B05B6; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A40706B05B5
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:16:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C17AA0A71
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:41 +0000 (UTC)
X-FDA: 85387204602.20.3449826
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id A4FA480003
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:39 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mRVe0/+Y";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LWF8HqqZQM/4p+lXqb/vLTu7jnbhepuFV5KLr5c8wVs=;
	b=XpESWaPDVjiusK+WMTu6z2qXiwY1dhfcZlE80UpBTAPn7cccuagdXyRXcjLlODSo5FAmay
	g4akUjkSdHuGGctJTDsKH+VoxhUlfyVPGJkkaP01RqtWxl9Mnb9wKg0c+Ufb51uEmeunHZ
	KcKyNC/uvjfUeGTv6FpQOWg9meI4XUk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="mRVe0/+Y";
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553399;
	b=Sija5tbJGDpG5WxjC+KuUhBj5WXGve4hJJagp2LVFaYeiDVNthetHTF2rxZ7xpNXsot3Am
	cYnXgJt++exMR3oXfpsWueprLfx8afvLE6dYfrgs8ZHdNF/rGvdlM+TGRJV6jfYOI9ikEu
	1pfHFUk4l+yU5CNAvrQGzR3DZH54uv8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38C1F601EE;
	Sun,  1 Nov 2026 17:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF1F31F00A1B;
	Sun,  1 Nov 2026 17:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553398;
	bh=LWF8HqqZQM/4p+lXqb/vLTu7jnbhepuFV5KLr5c8wVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mRVe0/+Ybe+Q344Ia1uQmRR0/nFDfHWg4/WCy0yK8y1JLvVyKdE9xKBbujg1iaJ3C
	 iBUYVPzMOB5Qg7xQaJv1rhZg4S5mDd4nnH0Jp8nCAMXXxDJvDwLtvw4UwRMEgHzH2J
	 Qt3HwC0z+xp/aVswXTUMNtSZeLUI+m64ng6tDUZmW6b144L/pj1+QevI3kG9vU72a8
	 L11M8hYyPZtosI6CoTbMjfL/+TyROFcK8MPkWWnC1loerqsQ1M9EmevY0EaJAImabo
	 toOn3myIwZcenoxqk6DGfXzCkrKGMp7hvC7t4meDpg5JnoGza4nU5OSGtajzKqTKog
	 U+q8HgF8QA3Pg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 2/6] mm/damon/vaddr: use damos->last_applied for migrate action
Date: Sun,  1 Nov 2026 09:16:25 -0800
Message-ID: <20261101171630.81477-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101171630.81477-1-sj@kernel.org>
References: <20261101171630.81477-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A4FA480003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gy99hijh4kk9xmwxqrtoywmq3eoijt4m
X-HE-Tag: 1793553399-57847
X-HE-Meta: U2FsdGVkX18aBoc0EfPiRyCHLdAIoHnWBD8jjkJSJ2QllImg3XBwpAc5MKYX9uZwRBN0oA1Byz5pws1v383Qqdv6YE0vFHa6gLuBq1Z/3ZQElHAoob78T2edw1U5i/2IPwUbI8jUKgkRYFhR1LODVy6f/Xu6GGhIkTuoyJBP1c0Sb9X/pXU8m0mRs85C4uCuu4HUh6O2nn/y1Az0tg2RTRDHUIHTCD0lLLEejyikWKkEZX7fhT25Fsmg5xK/0X+BZyUds5Twgq7oueiDv2gO4MnztRGK1LYTtaeo8MRncSdUrX/YEnFQjrbE4lKkgAqReZQUlGhmfYLCiw9s2d2Y5d47jnry7EXFkSqDrUXTkSmIkQOCcHtBm3/rZTdQ2B28ZTPYdAELJ4HwpC/AhOdRrJbxLRLa8HPOtH0nBbYIrIJyS+mKnlrKTJ3XFB4ty6enBIaYsXvdzX4eBnrC0Xb3Eo/VbCPwu3pCEsRlAKLyditVCv+g0m6pP76t+R985OdQBnbVtwQ2vdUH95mPeoY1WCfISTTjl9ajgGnLfSvoZfGP6eBxqGJU73xb243VMYSGHzmk/qpIotXs6atzlVaZQP1G0lMqevYIjhkkItP4JXx8FRzbOhUBp5ZGnlwB1mOtiRvvI0qhNspLk/Ra4KxZ3RlZqx0k6J+M96TxAYr4wVOaWOyuTXnJ7mZaH+T7TnNjt55PiQdZc6lWaGgwYyGxQcrzPppFNb2QrIVizzR5tD49B+UJ8PyZUC9MIeSJhgDNEgZBAETqWQmlVsbnXBgXCbbV35hHTkQ+Z9x4jm/B4YSpOCyF7Vf26OEOS+zNzJYg2P3/d2WC/IQT/ZrYB08JgFwbMfZOfE4pWZTR+zyHnvkYFXRLRsdyTaiRM3JBdgOdc0oio3+XDgmFOt9sDJAp8pCMkfbxSKcwnlR5nO8WD02I2eTwF3qx/re15qzGSS4se+58ZACfqmIM5RP4glj
 +w/8Sp4j
 1id66NRbDz6PrxNtnd/LqfxNF4yxNh/WPOO4+iBlyyFh3w1VsprF7Z7pC+oL8w8eDaT14QuNjg8wBZwYzRGHYmqX6ghgPxM1DAKI43+L4VPm5B6Y8EZLoZGUUvmj9tyGz/OMldvAgEdRMC8WMtuJTi0tnifnY4i+YN/mb5asRL2S/Tj5HQ20gcWJsOgGT89yw3vfOJQZ46uOCAbiBSMZRmT4FSZutSt9esnTCfd71QE/nMPfN0V20pTuusuoUGzWpHAMOG/N36cnwtynl+xPLK3tbJw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

To avoid applying the same DAMOS action multiple times to folios that
are located across adjacent regions, damos->last_applied was introduced.
DAMOS_MIGRATE_{HOT,COLD} action support in vaddr is not utilizing it.
Use it to avoid unnecessarily applying the same action to the same folio
multiple times.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index c271b6d63c027..b1d7bcf7305bb 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -834,6 +834,12 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 	list_add(&folio->lru, &migration_lists[i]);
 }
 
+static inline bool damos_va_invalid_folio(struct folio *folio,
+		struct damos *s)
+{
+	return !folio || folio == s->last_applied;
+}
+
 static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
@@ -854,10 +860,11 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		if (!pmd_present(pmde))
 			goto huge_out;
 		folio = vm_normal_folio_pmd(walk->vma, addr, pmde);
-		if (!folio)
+		if (damos_va_invalid_folio(folio, s))
 			goto huge_out;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
 			goto huge_out;
+		s->last_applied = folio;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
 huge_out:
@@ -879,12 +886,13 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		if (pte_none(ptent) || !pte_present(ptent))
 			continue;
 		folio = vm_normal_folio(walk->vma, addr, ptent);
-		if (!folio)
+		if (damos_va_invalid_folio(folio, s))
 			continue;
 		page_idx = folio_page_idx(folio, pte_page(ptent));
 		nr = folio_nr_pages(folio) - page_idx;
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
+		s->last_applied = folio;
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
 	}
@@ -991,12 +999,6 @@ struct damos_va_stat_private {
 	unsigned long *sz_filter_passed;
 };
 
-static inline bool damos_va_invalid_folio(struct folio *folio,
-		struct damos *s)
-{
-	return !folio || folio == s->last_applied;
-}
-
 static int damos_va_stat_pmd_entry(pmd_t *pmd, unsigned long addr,
 		unsigned long next, struct mm_walk *walk)
 {
-- 
2.47.3

