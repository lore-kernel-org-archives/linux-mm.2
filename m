Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 789C0C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 13:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DEC16B0095; Thu, 24 Sep 2026 09:11:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5B46B0096; Thu, 24 Sep 2026 09:11:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AAB06B0098; Thu, 24 Sep 2026 09:11:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 467216B0095
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 09:11:59 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D49D9A03A3
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:11:58 +0000 (UTC)
X-FDA: 85248693516.21.81446E3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 25B24140008
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 13:11:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cqw+z1JR;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790255517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhqPBt30I2r+yIpq8GiFycZpjx6/0L975xVz/OPU+rg=;
	b=p5DPcfrgXlL7ACMbKRIFguzKSu1I4fyze7NPkF5oJLvFVHzMnItCxF3p7vBu6CYKmIJSAM
	wZNTCF1xv2dJ2YTPl91B2tmaj9ak8IGSoOIdNc4vnBvydAQGuvGAz/sDrgpsbFb8m6/ajl
	oV7PjHxyUkZMjFQroX/p/caRobDfISI=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Cqw+z1JR;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790255517;
	b=VnhZDkzEmC3eeQB+O7mYVCSgsIkvOWr1pIl6EC+qnA9Ese4EWaMZF4pQTZiv3/lLv1mC9Q
	h9TUKtQl+Vz7qTIDbSMK10/aYZgfDow5/047PND+CrIPW4v4xO6m3eX9yNGUJfsd2h7Omu
	Knlgt3OZTH6r6ZtgzRQesGc1nRdsKSM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D57051A32;
	Thu, 24 Sep 2026 06:11:52 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4174C3F86F;
	Thu, 24 Sep 2026 06:11:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1790255516; bh=omnc/jiGce2ioWghxdLYMfvILVqD+Qx1+Ygyy+n/n2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cqw+z1JRNnoGVg2M6BZ0XIIofy3CKrxfcxsiHv5K+w04E+MA396UFlL/9MTxcEloj
	 ud6CPr2NiTciVXHDU2JreHt0oDkzaKPTyWyHjt7MGCOjQR57BRSR//s31IDbO3h2TW
	 1507rdZMwHyYs34HsTPCcSn5rAfhP9nMsXTEXPHw=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	davem@davemloft.net,
	andreas@gaisler.com
Cc: Dev Jain <dev.jain@arm.com>,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	lance.yang@linux.dev,
	baolin.wang@linux.alibaba.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	jgg@ziepe.ca,
	thuth@redhat.com,
	sparclinux@vger.kernel.org,
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v3 4/9] mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
Date: Thu, 24 Sep 2026 13:09:32 +0000
Message-ID: <20260924131106.1730494-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924131106.1730494-1-dev.jain@arm.com>
References: <20260924131106.1730494-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 25B24140008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: tiunk3jeq8euywndffsehxhyb8dicwoo
X-HE-Tag: 1790255516-823922
X-HE-Meta: U2FsdGVkX18EZF6MNjJgEiH+u7AQSsWfX93L4L1h6nbu90KNCTPXkSa41iKxdJCx6/5JZ/Nlle5VZc7i/m7D+tFgbFhGSZBmOGWdb7zSCq2gGqA+IUuu8CXjPIe6hR5z4yDw6IrMp4bFu4rLYZwheRZkIDvtmf2yVx9XO6dUtxDMU/5Vxrp+aheseMHKViL1e3TlTbw3kJvf961fQrFYaDD40hz277udozv1831KLCCER9gB5iVFqUiWlkDFfquykbaPYg9ECGGn5S/+4+lfROv8oGIgEy1hSiN2s0S3N4exxuCA2ncORdsRnFKuz4jyqHSHJB4iaX5ZdZEI2tTtSAwXK4wONCpxog9AwT7fB9X6Ikf+5ONAO9r9FwIP728hvfjtzjD9WtZH73VN+k7dpMfqniGv6p6ftQs40DOihCqXwcTlWFfA+uOr3+MYCEeWoJPR2u2f0BSBHJG4NiclEg97pz5ENgMeTxJTlJax3rfv4/GlZ5SRpc6VpM0Lh7I9N0WpLC0tWsD2IMpRvCwO3cd0aNYNjMbRPReHrcevRVZ5yHLktv7ksYNHKAYM1BaA3aeobGIUNUq33STXovCLf7BFTskp04ZbOx3iPEnTP6VH4HfrquiqRhji+LQN0U97pDJp2z59bi/C60nkz1o8bxXPHAhtoJ4T/DKcatlvUmS5x4QcWpb/RIUEf9vDHJ4Qrv+BEl7WUAvLE98kPGPcxgJQABAF1w5VrZIzYP4fOXF+9MOG1NSoPQvRHcmvdHZExYAio0Gs4K2D9yLcwPWFbzPnlUeKJd0BVQaRqJ4jmhDn0ZZYNic77FyH86tozXgcmXo96zIpAmdE4i9yfwyPAY6e5q3lAxM+H9K+WON800+U6inuhcKGxA3DgbXrHShPHh8ptGDJZBQGn8zqi7eN4SMtLBZY6Ab9hX1oe4wDqrbc4ofzlxBjCuFxeJXLJW4S9gtlGmRuDag04UHdSmQ
 31sDs8fn
 6bS6ux9Ce4Pd9Io0Mp2o7bgCWK8ySW05SCcRVp+mYYW4H5RmqolMj44uiq0jSZsS9dN/INfIVeQ0FFTqNqCmlQCkVLp6UMEuDdeBbY4/c9hqneFQCB36XollGcCEyY0we93ckfrTmslmQ1s7vT5mvdWSanYXcu9ikoezBEXuL2+jDSmK2PlQVzHa1B3LpP85Z/0y7ZJG/h1sH93Vws6Wv97VCTtESyZzv8b7KKldhYYCFBBjodSWfRmKAxnjjAsQtQLRKXjz9rcZMaTBoyTIte/JzPQItQA/5ChcVs5tORPaozjM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To enable batched unmapping of anonymous folios, we need to handle the
sharing of exclusive pages. Hence, a batched version of
folio_try_share_anon_rmap_pte is required.

Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap is
to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on a
batch of nr_pages. Refactor the function such that the clearing of the bit
can be done at one place without duplication.

Note that __folio_try_share_anon_rmap can receive nr_pages == HPAGE_PMD_NR
from the PMD path, but currently we only clear the bit on the head page.
Retain this behaviour by setting nr_pages = 1 in case the caller is
folio_try_share_anon_rmap_pmd.

While at it, convert nr_pages to unsigned long to future-proof from
overflow in case P4D-huge mappings etc get supported down the road.
I haven't made such a change in each function receiving nr_pages in
try_to_unmap_one - perhaps this can be done incrementally.

Add two WARN's: check that the batch is entirely exclusive (for PMD
callers, need to check only head page), and that there are only
PTE/PMD paths converging into __folio_try_share_anon_rmap.

Signed-off-by: Dev Jain <dev.jain@arm.com>
---
 include/linux/rmap.h | 56 ++++++++++++++++++++++++++++++--------------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 62ef511a6175a..91b5763ef466f 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -723,17 +723,23 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
 }
 
 static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
-		struct page *page, int nr_pages, enum pgtable_level level)
+		struct page *page, unsigned long nr_pages, enum pgtable_level level)
 {
+	/* device private folios cannot get pinned via GUP. */
+	const bool pinnable = !folio_is_device_private(folio);
+
 	VM_WARN_ON_FOLIO(!folio_test_anon(folio), folio);
 	VM_WARN_ON_FOLIO(!PageAnonExclusive(page), folio);
+
 	__folio_rmap_sanity_checks(folio, page, nr_pages, level);
 
-	/* device private folios cannot get pinned via GUP. */
-	if (unlikely(folio_is_device_private(folio))) {
-		ClearPageAnonExclusive(page);
-		return 0;
-	}
+	VM_WARN_ON_ONCE(level != PGTABLE_LEVEL_PTE && level != PGTABLE_LEVEL_PMD);
+
+	/* We only clear anon-exclusive from head page of PMD folio. */
+	if (level == PGTABLE_LEVEL_PMD)
+		nr_pages = 1;
+
+	VM_WARN_ON_FOLIO(page_anon_exclusive_batch(0, nr_pages, page, true) != nr_pages, folio);
 
 	/*
 	 * We have to make sure that when we clear PageAnonExclusive, that
@@ -777,29 +783,38 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
 	 * so we use explicit ones here.
 	 */
 
-	/* Paired with the memory barrier in try_grab_folio(). */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
-		smp_mb();
+	if (likely(pinnable)) {
+		/* Paired with the memory barrier in try_grab_folio(). */
+		if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+			smp_mb();
 
-	if (unlikely(folio_maybe_dma_pinned(folio)))
-		return -EBUSY;
-	ClearPageAnonExclusive(page);
+		if (unlikely(folio_maybe_dma_pinned(folio)))
+			return -EBUSY;
+	}
+
+	for (;;) {
+		ClearPageAnonExclusive(page);
+		if (--nr_pages == 0)
+			break;
+		page++;
+	}
 
 	/*
 	 * This is conceptually a smp_wmb() paired with the smp_rmb() in
 	 * gup_must_unshare().
 	 */
-	if (IS_ENABLED(CONFIG_HAVE_GUP_FAST))
+	if (likely(pinnable) && IS_ENABLED(CONFIG_HAVE_GUP_FAST))
 		smp_mb__after_atomic();
 	return 0;
 }
 
 /**
- * folio_try_share_anon_rmap_pte - try marking an exclusive anonymous page
- *				   mapped by a PTE possibly shared to prepare
+ * folio_try_share_anon_rmap_ptes - try marking exclusive anonymous pages
+ *				   mapped by PTEs possibly shared to prepare
  *				   for KSM or temporary unmapping
  * @folio:	The folio to share a mapping of
- * @page:	The mapped exclusive page
+ * @page:	The first mapped exclusive page of the batch in the folio
+ * @nr_pages:	The number of pages to share in the folio (batch size)
  *
  * The caller needs to hold the page table lock and has to have the page table
  * entries cleared/invalidated.
@@ -815,10 +830,17 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
  * Returns 0 if marking the mapped page possibly shared succeeded. Returns
  * -EBUSY otherwise.
  */
+static inline int folio_try_share_anon_rmap_ptes(struct folio *folio,
+		struct page *page, unsigned long nr_pages)
+{
+	return __folio_try_share_anon_rmap(folio, page, nr_pages,
+					   PGTABLE_LEVEL_PTE);
+}
+
 static inline int folio_try_share_anon_rmap_pte(struct folio *folio,
 		struct page *page)
 {
-	return __folio_try_share_anon_rmap(folio, page, 1, PGTABLE_LEVEL_PTE);
+	return folio_try_share_anon_rmap_ptes(folio, page, 1);
 }
 
 /**
-- 
2.43.0


