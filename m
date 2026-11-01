Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0ECB606A33E
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f3nIKHnK
Received: by kanga.kvack.org (Postfix)
	id C10056B05B6; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE7006B05B8; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD54A6B05BF; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8012E6B05B6
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:16:42 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EFD33A85C4
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:41 +0000 (UTC)
X-FDA: 85387204602.10.60266A8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 58A094000A
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:16:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f3nIKHnK;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793553400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gY/iCu9E5Cwctk0xMV73TTepjgVS26fxiMdC6yjt3qQ=;
	b=B0V4ytKaz9ffuApNiCj0CubgoUi3XThLxK6FNl9YJNA0nRNBQ2kRcWqR+EaMSiZ99i8hj3
	v5r2vQZhOazxyGvURYB3smSkTYiA1hrNqeJsSiKiN5vdXtGSB2yvnHS2dSdFXSwL/GVVdO
	OkBNnYwAVnKJjBNbgZqUikTeHYM0h7I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f3nIKHnK;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793553400;
	b=tIxehrW2eZJc9L85QVwf7hl6fkmLvzR5fHysZ6nXyfYaOQIJKuYGS9tuzOcH3RZ4Sx6+gY
	BKUZwyxFt+IUGx8DHSJKAFh1/VjLe37IkqKKvT7AR4OQU0IZjUVPOdPibHjQ6F3WemWx8J
	rwItc5mFQg+vYqbL0ccpserV18I0Eqo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B00E43EC1;
	Sun,  1 Nov 2026 17:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1876D1F00A1A;
	Sun,  1 Nov 2026 17:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793553399;
	bh=gY/iCu9E5Cwctk0xMV73TTepjgVS26fxiMdC6yjt3qQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f3nIKHnKutETK10+wjRGjPR+4SXlpJJGTlWtLynLWvfshUsh3PV7ySN632Xw3qMFZ
	 hMS620cTSQAMCEhDshe7oVfZhV3ZnFP3RphoST+FyVO17Pt6w0oXJsQBDrocAfnla8
	 f0ROXcajz7X6IxUwMHrB5ndODBkE0MJ5MOyNrUa3krHqW7QmRT53FC79vyCkpUXRti
	 xmpQE6uIKZd3LZoF6wkfhV0WQ5Fmi+xzi9tICVI1hDagPa5VFjU6FRsebw18SGsA24
	 Tme9SkcsEqDVu7mXEum26jXlGFqq0ivc+q29tNvirvytF5ECh9TrAMA6DlXIBUHCq1
	 /ZHz1h1EZZ5zg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 3/6] mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action
Date: Sun,  1 Nov 2026 09:16:26 -0800
Message-ID: <20261101171630.81477-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101171630.81477-1-sj@kernel.org>
References: <20261101171630.81477-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 58A094000A
X-Stat-Signature: jxk43yzfkwo39idga34tihd1fpo1arnf
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793553400-104514
X-HE-Meta: U2FsdGVkX1/zDM8OVAmN3DZ460ndrGRryn9NRG70WeWESOZxSGKrZnLKJgJ2YqksCJ9qEYz2prNqxHrx2URPhU/c87RAPHd7J8bschf8XnYmjDnRB7J7Z8VTlWinw1PcniWgyT5zc2kIkT0w27iTnKX/PI2gC/+4ZWtF+R6NNgeNETIdPv9ckN9/NmqpRqpo31YvD3wxzMkpWE98NN5BGMtlxYndaQBDqjjqUhb0LmMEw/hyh8El0EsprzWbyrvcrNzpKT2SmuijK89gYs+xRerXAaWKLPJGl0Qb9HTLuAEZFWTc+11YRlm94d6PLhq7nLlD86+W0D6fH7Fk8Mo/s+csc7hAHVVxFuTgB2frK+dMQvPf2AO+2HIILALePUu8KRuPQtSFkpYWSKQJjeOsKVnYZxOUajQ7/HaeU/wUv7VNMW2i4peLhVpsX50XTDL6GZpL/ekSWu54uoQ/SplTwmzucSTeQCFCIINFqtPp9pz094gMU/ci/WyksaYTBKA1QJ/B71Nk88OdAcVjAUCgSuSJApot2bfXIarHSNKIw/9Is1MHEXsQhhxFjP7tcl9N7rCcJWfauiRlX8Wv4G/GTC7xtIe5CRpSdo9RhZx2ITqTCTCu4bA5IwTcdSPfxjaKsJ1zHrZ+pYUo7VM4aN97lWX8HDupm4iWEYFyHAc9ennpjE63HwWqtFlpD73BL/W9xKzkpSAsoVrmSYBEGFqWF/K3b0bGMzxIn76DNLznLoKeReRmkNzSWNt8YfkSxAilC+RsbnrYWt0UWf8XqqsGk7Bagsu1bw73a5PiIoGobCK4so0S36N9Je958aoPnwqBY/Xp5+dwaWErZOvG4KsH/k/Bg9bHbDdNwpgjOyn0wlMi7mx9+oVZ9T2vhGFeLOPge6N8c0nY+hzSx5KNen8eYB2ylQF+pVYNqKNhwPTV1jCLxrIpG1UrDiL3n5WeoSXac9HosSJDOlecp64w/AN
 GnjCbyKm
 58i6SelgZp+PrQUL4z5pSQz1+o7X1pHR/+IktgHY+vu8HxDev8eIf3XaRld287Vc/rLLWu4wlPfxf0tsjtWD/ZJ11Co566MtOy2EjclghV26WBkFyiiHdCfd19ejAQwDoUmKMjKkhQnQHIrEJQwoYC8siRzvnEFTxjNkO2DKZJfwLHWrjJytpg/2vL1GKddtYA9wE2ZDQOWWUXPx1BVW0/H+uxfOJa8AgpXldXvfFaQHYHh3fb6hXO14/fywB5RLt0UsUJm9CLtdwoeg7XUJD6cVsX5GtWJAIAXBnzZ7xE4zgyB1curUhMwwEs3tjHnIBK0VCZ9VjyVZaRDoADrmXDe9hBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Support of DAMOS ops filter and sz_filter_passed support is up to each
operation set.  DAMON_VADDR supports both for only damos_stat action.
It intentionally does not support those for madvise-based actions
because applying filters could make it unnecessarily complicated and
expensive.  The vaddr implementation of migrate_{hot,cold} action does
support DAMOS ops filters but sz_filter_passed.  There is no real reason
to not support sz_filter_passed.  Add the support.

Pass the sz_filter_passed pointer to the filter applying logic and
accumulate the number.

Closes: https://sashiko.dev/#/bug/linux-986e8b64-8e65-4e32-970f-4d3ebdf8206e
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/vaddr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index b1d7bcf7305bb..6fd0e07b60705 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -776,6 +776,7 @@ static bool damos_va_filter_out(struct damos *scheme, struct folio *folio,
 struct damos_va_migrate_private {
 	struct list_head *migration_lists;
 	struct damos *scheme;
+	unsigned long *sz_filter_passed;
 };
 
 /*
@@ -846,7 +847,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 	struct damos_va_migrate_private *priv = walk->private;
 	struct list_head *migration_lists = priv->migration_lists;
 	struct damos *s = priv->scheme;
-	struct damos_migrate_dests *dests = &s->migrate_dests;
+	unsigned long *sz_filter_passed = priv->sz_filter_passed;
 	struct folio *folio;
 	spinlock_t *ptl;
 	pte_t *start_pte, *pte, ptent;
@@ -865,6 +866,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
 			goto huge_out;
 		s->last_applied = folio;
+		*sz_filter_passed += folio_size(folio);
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
 huge_out:
@@ -893,6 +895,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
 		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
 			continue;
 		s->last_applied = folio;
+		*sz_filter_passed += folio_size(folio);
 		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
 				migration_lists);
 	}
@@ -971,6 +974,7 @@ static unsigned long damos_va_migrate(struct damon_target *target,
 	priv.migration_lists = kmalloc_objs(*priv.migration_lists, nr_dests);
 	if (!priv.migration_lists)
 		return 0;
+	priv.sz_filter_passed = sz_filter_passed;
 
 	for (int i = 0; i < nr_dests; i++)
 		INIT_LIST_HEAD(&priv.migration_lists[i]);
-- 
2.47.3

