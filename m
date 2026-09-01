Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93EF9C61DD6
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 05:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1116B00AD; Tue,  1 Sep 2026 01:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 988EA6B00B3; Tue,  1 Sep 2026 01:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8786B6B00B4; Tue,  1 Sep 2026 01:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 60A196B00AD
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 01:44:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E25FBC0316
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:42 +0000 (UTC)
X-FDA: 85164104004.09.B504575
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 40CD980007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 05:44:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tWwefnfA;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788241481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zpEeoVQvhOQMeE5+qgRGm3gx6nxfMzj9uyiGJQMO/WQ=;
	b=I07MSASrE2wo5m9IQati3dYk28KbLO0X5aKWnAQB6WqxMxKM02UbI16bUxr7w+pfWWuXEl
	RQoexBnciBNsVNXrpmL4Ej0Fe+dS4wcEmVU4KoZVBOeHbM6MvoGwiu07ArNiVRaCSmopFy
	AyM8+8Sry95MLbV19w0TkIdGUmw0olw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788241481;
	b=TonHICcjf/z9jKVsjQFtHOzvAwpUC8T/Y8F8oqPBXrgqOHdnDeEyRDTVH0hNUj3TQtBRbZ
	Vg2Ct0dvBO8R4Pwg1/pkPGTnQ3JWDg/CIA3e3PYH4XIQw0ZAf7fHT9Tlw+vx0TpLne5coV
	JMnIdq1XhKi6yB6iaGmOrAThhZjV83g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=tWwefnfA;
	spf=pass (imf02.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A294E1756;
	Mon, 31 Aug 2026 22:44:36 -0700 (PDT)
Received: from cesw-amp-gbt-1s-m12830-01.blr.arm.com (cesw-amp-gbt-1s-m12830-01.blr.arm.com [10.164.195.33])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8DF4E3F85F;
	Mon, 31 Aug 2026 22:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788241480; bh=hmuhLEjycle0vItvKp8YgT1Zsj6d4IkLCimp6M+bfX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tWwefnfAhhBIpkRqqur17UuVtt3/sSCqdPq2EY+WY4FNf1DHC36JM1Q8qvEKzdYIh
	 Gtxx0+HQorULV+ZQ69Khn+KIV3NV5xPZQSCirYE2riTZlphNNqZ8+sJv43mfhL+n4J
	 lPNgmUXmQHJXdWSxXuSl0IY2Y38ckOUv1mhy+xQo=
From: Dev Jain <dev.jain@arm.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	hughd@google.com,
	chrisl@kernel.org,
	kasong@tencent.com
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
	ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: [PATCH v2 4/8] mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
Date: Tue,  1 Sep 2026 05:43:51 +0000
Message-ID: <20260901054358.4049095-5-dev.jain@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260901054358.4049095-1-dev.jain@arm.com>
References: <20260901054358.4049095-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 40CD980007
X-Stat-Signature: buc5xzepwgof73joz8k59a8g3e5qzxnr
X-HE-Tag: 1788241481-919904
X-HE-Meta: U2FsdGVkX1/7++Et4xV+GLpTtdzSfgclEIG1FqP/OF37rKexm5ihNhr3PAqTYWCYwsXUBN1jO2G3H5jJQW0xmN7Vry5Gp/yWFTuwVC860yXZowAWgzxu840/JlMmdhwT3dveBJv2XNQXlGjkgIRib896X36UlxPoNcJ5kLin+Tc0TTEldLSn7xurxeyucyesnh06lcgnch7LuVEI7s9FCZhgSJJ/uTLoU8+JAe8cC5DtcrOVEJd3h6kjnp2n8abdO5KdwoVIFTtHXrWGmasJMLb2dxFr1lzivsMl4egP+rAnM14QPzxGae+jsykksxbs2M3w+09Pc12Eo21ifWQMis5X4UXjqM0AUGVj8ubp4xZNMrnNdSd03eDEgvVPDUld1W4SjrEgzll0m2+PPd0RZ06y+J0kfOZgplo10gcmWOL4461Zq3bvVNODqo9z31Ype10sE6s3LbSUcoBFfHRZM46IpqWTVqXjq7Ermv6SuthAsPt9IleflzD4WcP3IdsTvg7zO3SH2v43J4miefaYXdGLa6qd+PHrn5BrjqznFMV0Lnlbc2/pGPWvaREsuZKuT58jFqGhYb3/NgErmr78Wy3Ku+M8azh7coMTF0wn5pGKTZ62StgQfuLTp6gpaUqa0tmZTEVqTZYkRPq4s3vzgUzmceyFK/06KslnntwuGfcFPR6iKgBMCC2odDEqDXQs6piGZVt18wcb2kt5fmxLTSCDOIGRnWB0wUybau0f+2DlaN4Ml/Rel3VRECEBLJOf/n9eW+80C3ogBf8XuLm/vW7jtJEVjoWzwjrIuzK1lwDEnlGnsvVACdwUtT8RG19+mjG9vzJGBMLHnIszvNiC7N071MCjKeVQtD8ewGGhF83cAhDwKon8GbBfty+CLq8vyBnhu0dj5vLy8Du6u7LFC5iJR0edSJTHdXg4vA3JErKyMSb/bSZjrQyGEARwq41szKbFx8uVhB+1Eqs7Zst
 E1nmNqo6
 7bJ71JOUSCzXnL+oKd5rfk3pRrerHyQvsT0b2i8oWzopRS/yGjWVD6jMNjpzGHQO+tHHbASzS+w7XNDBaxzv9Si/vMljDI5o0IxoDm7jwpDP9QYg9WgMBuQ8wOJnEGoXWLi1/HDhyxgRhZ4/WIuIc8zgEpXP2b39UX/It6RoZ0oTyWNqWIRBAq4l/VKd3Rmv8iPdcEGwD6CXNJx5rwKc57V6LzE3prgfSGhK+dCEe41wkwRwnjoigo0WYnccZOmfYpDi4jwFXp60FTBNzJ8s/QIBylXaqnIdPnU2zCrlAO50tuh4=
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
index 0b332770abeed..320f9f14f6020 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -706,17 +706,23 @@ static inline int folio_try_dup_anon_rmap_pmd(struct folio *folio,
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
+	VM_WARN_ON_ONCE(level > PGTABLE_LEVEL_PMD);
+
+	/* We only clear anon-exclusive from head page of PMD folio. */
+	if (level == PGTABLE_LEVEL_PMD)
+		nr_pages = 1;
+
+	VM_WARN_ON_FOLIO(page_anon_exclusive_batch(0, nr_pages, page, true) != nr_pages, folio);
 
 	/*
 	 * We have to make sure that when we clear PageAnonExclusive, that
@@ -760,29 +766,38 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
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
@@ -798,10 +813,17 @@ static __always_inline int __folio_try_share_anon_rmap(struct folio *folio,
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


