Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E329C44536
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 15:21:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736316B00B9; Wed, 22 Jul 2026 11:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D5D6B00BA; Wed, 22 Jul 2026 11:21:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FDC36B00BB; Wed, 22 Jul 2026 11:21:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C6106B00B9
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:21:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEF79140201
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:21:39 +0000 (UTC)
X-FDA: 85016777118.29.4029721
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id DE7CF80010
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 15:21:37 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PpjeU8Ai;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784733698;
	b=trsNudlP9umSGbXCPn9PcMvQN8vqMtNaeh0/ohYuNI/b0sLT+bz57nTQE/95skfxIWKJmY
	YjSyfkjwdY64UzPPmxWgY5qjN0U21oe+T4TEgISs9P1bUJhmqISJmaVSat0PJDrgQ7y4dF
	AKQUSippEHbfAePAQhpq8S6lvWLwOQc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PpjeU8Ai;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784733698;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DewUAhzakWqHnF6VoxFjXFO25R073z6cEiSODUJgVTA=;
	b=wt7BM5lk5XSlbNywoCYOZ061TxBb34ZzPz0JyBpuyUG1YwuPcigbOpaUsTi6QE47KPH/gQ
	7lT0ZrPnnMv1NDJZX5+BO9jYefX957IvNXvy/n2jI7LqjGFwdqGZEvhf//hNKVkldStIK0
	Ie490oYtdHZGxR+Ee+LQM5RKJjGez2E=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784733696;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DewUAhzakWqHnF6VoxFjXFO25R073z6cEiSODUJgVTA=;
	b=PpjeU8Ai7QJ+j1EQvdHgQBe60U5pDk1ClQ/f2mPV3ZHtKz1TlDO62fS/QgP2cBQBpxOQ/B
	19fHPYsVhaCn5QG2FvxAnuz/O9YJ0QY9YYpDyK2NDJHp6zGakyY7aOWLpMCIBcnGqfxhta
	geGN+XadjJNItwGxKgrm6BXVwYeizaU=
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
	kernel-team@meta.com,
	Alexandre Ghiti <alexghiti@fb.com>,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v5 04/11] mm: zswap: add range lookup for large-folio swapin
Date: Wed, 22 Jul 2026 08:19:35 -0700
Message-ID: <20260722152043.2273289-5-usama.arif@linux.dev>
In-Reply-To: <20260722152043.2273289-1-usama.arif@linux.dev>
References: <20260722152043.2273289-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 3e9sab1n5ijndt3xe77aswdx5c46hpw1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DE7CF80010
X-Rspam-User: 
X-HE-Tag: 1784733697-721255
X-HE-Meta: U2FsdGVkX18l2LWw6H78fw0MDGFou3/nv5PER6KOGHBu1ZE122hvte9V6XQuh4hdsI7G12XU0TyvAb8pevf02wQwVZikU2ljE7AAxO2m/bt+ACJ1zTsgyIhrw7GChkKFXcMmNU9QaMkrvDyf1GPwzRpYvx3DVGw9sJiax3rZ4aGnrSj4K5ZutLYLSKDvp1CDbBDTd2UMbR9uwD7E0MI6RwOydorwH7we8MpFuavLU6zzZTsk1IcvmBCfryeRNAZZJlJ7s9kNVq/UiZ6lAOp7sxHIwaaoy/JLPkAzXQivoZpiRPbCKrPiK5TvCcWHfZqUezKFVrfD+jSNIQf8s0F2of5cTPI76mFH8hJxkrHZYUbbLhKFYUMkL+qZsSiRs243OCWJN0rKkpXIRZR/akVMWwp7/b4/RPcVbHKE6vljDjHkeMXWxc58ndDmEXtJjuD074J9dIrBJboKAxk0mEDJvCe6MEW0whYvJvvoMZwxbXR9qFjV/7wcChL/QWh32TF++iD3RhcM/fAflPDXiizhZn93ptV3HOanw2259zm7VvGkI0NNip7u2aOwthXTunxZLeSGC++vYZ1vpF8GjH9w1ayMDIfJXljPnmwK2DTtTaWgq+cS6KSqKnf4PdZ1aPEL567i9zd1E/wBDTWVA6URrxJCR9tW2v95nIvJxx0/fc/Mx0cpPpJQSv0SHYFF2Km+KUI2qCfJFBNKRd0rEFPvCxbU0H3O8NL5n+bP50ogcM9I4/NLjg3c2LQkhM2SlFeafSOtab6YOLIcU8M1yUfO5nsbiBJ5tqYGRMjzLaFr8qf7nwq1KpbXzZb9PI97542mQeLn+DA9U5JcSMvoZeH8GWMQKOr45MTwXBLN0VJFcdkhfAF17fRMbwR+08DrI5vFk5F5TrTMLEZSianKNP4laHT3Rf9mOmZUzKthM3DOf+WCowlSnoiR+SwzF1ZcfBsRnOQXLCbquVCY5bACFGI
 q8CuRht6
 tRT+Z66fMSF+lqyR1zSh8Au3lGCrp8kWcENZWV8fWrHwvRuLGcAXtT5cTFUVU0K+QNq5SYb8wF1wVZ0eXt0s55Wd7A/a5WkXcDg/QB7nxBr7uC5fJjTAeWFVr15QJUw4ib+/ESzN71ZLg9Q632ZlDocusfQF1I25qpERiCVpPLKBSdjMZJlXDSg6jZt3kR/CCwidCG7ckykMaCA3BpYLbntIcZnEaHEha11ty
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Alexandre Ghiti <alexghiti@fb.com>

A large folio reaches zswap_load() only when the caller expects
the whole range to be on disk. Zswap still stores large folios as
independent order-0 entries, so reconstructing a large folio from
zswap entries would risk returning partially initialized data.

Teach zswap_load() to scan the covered range. If no slot is in zswap,
return -ENOENT so swap_read_folio() reads the backing device. If any
slot is still in zswap, fail the large-folio read so the caller can
fall back to per-page swapin.

Return -EIO rather than -EINVAL for that conflict. Large-folio loads
are now valid requests; the error means zswap cannot safely satisfy
the request from partial per-page compressed state, not that the
request is unsupported. Existing callers only distinguish -ENOENT,
so this is a semantic clarification rather than a behavioral change.

Add zswap_is_present() so PMD swap-entry consumers can make the same
range decision before attempting PMD-order swapin.

Signed-off-by: Alexandre Ghiti <alexghiti@fb.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/zswap.h |  6 ++++++
 mm/zswap.c            | 42 ++++++++++++++++++++++++++++++++----------
 2 files changed, 38 insertions(+), 10 deletions(-)

diff --git a/include/linux/zswap.h b/include/linux/zswap.h
index 30c193a1207e..cd9efcf9dec9 100644
--- a/include/linux/zswap.h
+++ b/include/linux/zswap.h
@@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
 void zswap_folio_swapin(struct folio *folio);
 bool zswap_is_enabled(void);
 bool zswap_never_enabled(void);
+bool zswap_is_present(swp_entry_t entry, unsigned int nr);
 #else
 
 struct zswap_lruvec_state {};
@@ -69,6 +70,11 @@ static inline bool zswap_never_enabled(void)
 	return true;
 }
 
+static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	return false;
+}
+
 #endif
 
 #endif /* _LINUX_ZSWAP_H */
diff --git a/mm/zswap.c b/mm/zswap.c
index 4e76a4a87cdc..384492f1f696 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -1561,6 +1561,23 @@ bool zswap_store(struct folio *folio)
 	return ret;
 }
 
+/**
+ * zswap_is_present() - is any slot in [entry, entry + nr) in zswap?
+ * @entry: base swap entry of the range
+ * @nr: number of contiguous slots to check (pass 1 for a single-slot query)
+ */
+bool zswap_is_present(swp_entry_t entry, unsigned int nr)
+{
+	pgoff_t offset = swp_offset(entry);
+	struct xarray *tree = swap_zswap_tree(entry);
+	unsigned long index = offset;
+
+	if (!nr || zswap_never_enabled())
+		return false;
+
+	return xa_find(tree, &index, offset + nr - 1, XA_PRESENT);
+}
+
 /**
  * zswap_load() - load a folio from zswap
  * @folio: folio to load
@@ -1573,10 +1590,9 @@ bool zswap_store(struct folio *folio)
  *  NOT marked up-to-date, so that an IO error is emitted (e.g. do_swap_page()
  *  will SIGBUS).
  *
- *  -EINVAL: if the swapped out content was in zswap, but the page belongs
- *  to a large folio, which is not supported by zswap. The folio is unlocked,
- *  but NOT marked up-to-date, so that an IO error is emitted (e.g.
- *  do_swap_page() will SIGBUS).
+ *  -EIO: if a slot in a large-folio range is unexpectedly still in zswap.
+ *  The folio is unlocked, but NOT marked up-to-date, so that an IO
+ *  error is emitted (e.g. do_swap_page() will SIGBUS).
  *
  *  -ENOENT: if the swapped out content was not in zswap. The folio remains
  *  locked on return.
@@ -1595,13 +1611,19 @@ int zswap_load(struct folio *folio)
 		return -ENOENT;
 
 	/*
-	 * Large folios should not be swapped in while zswap is being used, as
-	 * they are not properly handled. Zswap does not properly load large
-	 * folios, and a large folio may only be partially in zswap.
+	 * A large folio reaches zswap_load() only when its whole range is
+	 * expected to be on disk: PMD swap-entry consumers split before
+	 * calling into PMD-order swapin whenever any slot is still in zswap.
+	 * Confirm the range is entirely absent from zswap and return -ENOENT
+	 * so the caller reads it from disk; if a slot is unexpectedly still in
+	 * zswap, fail the read rather than return partially-initialized data.
 	 */
-	if (WARN_ON_ONCE(folio_test_large(folio))) {
-		folio_unlock(folio);
-		return -EINVAL;
+	if (folio_test_large(folio)) {
+		if (zswap_is_present(swp, folio_nr_pages(folio))) {
+			folio_unlock(folio);
+			return -EIO;
+		}
+		return -ENOENT;
 	}
 
 	entry = xa_load(tree, offset);
-- 
2.53.0-Meta


