Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C263FC88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D0A416B00A2; Mon, 14 Sep 2026 08:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3006B00A3; Mon, 14 Sep 2026 08:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20B06B00A4; Mon, 14 Sep 2026 08:31:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A20436B00A2
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22EB8120406
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:14 +0000 (UTC)
X-FDA: 85212302868.01.06B528C
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2C3AD1C0002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K1S3Hyjz;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTvWoIy2DhT7OiAQacP6glx1Nqi6P+EO8bbCbeQM85E=;
	b=Oc6n3o9eBud1txNvqB7ZPYuSpD612ZhG0PBvOuo1r15pX+HwfAv6SW4YOkjbskp5O89fYv
	ts0XsYyf7vnMPc1JFiHbjwaEnMrEXa4j10rLMwou1wfCnwPldN7ttT/+4sTgaRf/SR+Izp
	Nq/iQmqhN1Uf54mhLXw7HNJTg8zIzas=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K1S3Hyjz;
	spf=pass (imf20.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389072;
	b=bs/P9kghdFnuuDJrS8FCh+i2QLa7YagfvQ1HPAXQF4nXMi4WNXwspRSJbNy1C8l3tCKZvq
	2NbvDsVIHJI7lFhZUyUjidom8WAI64mfQcmXGPvVAT6astDvK02UoU5Z75zcBTIhjJIZ8q
	444oD50qMY9gSuIsHD2l1toOdpKnsAE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GA4gtvHV/+JkGd0QoK3boOJtdQKcFFleMRDfJWwQDhk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389070; v=1; x=1789993870;
 b=K1S3Hyjzs95sYM6KM9PMP4stYpd7MygPoC91ljTwQWDiJZqpMY0GuzbeiyjNeDYXi68qgJvT
 VOR6E3+Bl6fzmMwrgEXiyi/CnVVIM66gRTqY+SzVhk69ePCy0e5blYDDAK5gnVjJdms0MQMU+di
 fByJneBMa2fxcfPfj+nyK+xk=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 8d6cb4f927396b23;
	Mon, 14 Sep 2026 12:31:10 +0000
X-Mizu-Trace-ID: 8d6cb4f927396b23
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
Subject: [RESEND v7 08/29] mm: recognize PMD swap entries in the softleaf layer
Date: Mon, 14 Sep 2026 05:27:58 -0700
Message-ID: <20260914122950.3283997-9-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C3AD1C0002
X-Stat-Signature: cytetqso4f78ufhmoc7h6grt338gut6z
X-Rspam-User: 
X-HE-Tag: 1789389071-919201
X-HE-Meta: U2FsdGVkX19UJ9gYPHBsR2k+gdap3HuYp1kvYHHBU8p0BS7P8k93pLfpOZqmn0mzXVdGdeiPbdsugIYT+jFG+FkfYIDseBy+miv8zE3ntuBqJRvxCuejWlvc34wsre1XqgeyMlXLXzSBF9lo1hAI8egwbRP3mxlbi6rYQFepVrwU1OFT6HNa5XJiFosUVKVoOnKWIt1c12ISRdV+/jWHS8iZJOmPCr1+JoBKzS+RY2T5TYVGpZbmgveVS0CX+vA3P7YmQWi2xlPgfcDwGuySyyeRGXESDH8Hkj4AASdzhHb4Bx8MmnEcwUdIbSGqa36SdRLHqpfCakmyM1DRDcoyZu+VTPlGNuEqPYEwDD39aBvQlHHHQd6qgAdy5uCzl9gOHQEZk3InOL8vBOLpIeeENV5KPmumsC4vEftQVEIXUSoxTmqkATbFj6kC7M3dCTJRTCKWXZArW5+Ry3DV6U6mwvd1yqeIMCseuT4uKY3Dm65n0I7Rp2xzRsDYo0AMEOPaMZQWFLw9gPYwgIHR0BXpPKU/Ii+VGzC9YAAKdGS/hdDdd/Jpa/Jukcb4lK5gCihN7rBLSa2+XncfegXfzYBvVhZ+SViw4PTn24s2KBmGmBb2dcOP33b6+wDcf7iejcFFGmfrjtOXAh3OOFTpVIETZDNemj7pAskH/E8Cejn5j3Ci0k/KBaRuqwGarbnYb0vsN8jDi2ALxiLPCuUaKsG9ZiSspyCRIYLvyxB+fOb7cFERjciTRI9kk5BCOGRCNuCwKDVBpR/Jr4qcKIkk4oj6rSr4dSah7mbWeWq6P0j3HRUpqZfLQhGcAdeSrMgnCcxGG8IcTFPwDCq+X4ZZPkyFWjC5COflw7iIzaYOs3yOBXlDtAvPSTVDtDS5EiBw0hgnhp4y/jm88si0ZOfZqClZbpI60OBGdWSYotmIIBJJVhJf3IneniFnTB1IAnbXREgyClg0eE6HGGiKDAusDXS
 1sDrXJLD
 ufDaYSWW4Xb9voDx2Bq2n+e3xzhiGrl9xWJY2JM7qwoJA8yu/ZTAhmTb5juQEWvJbuwva3IJ50DCZ+vxe9g46Vo+4igcb4vVDaqW9WQjiHa4ug2FILzKJpURaDAfvTmEONwJDweFiJfoBZe7qrOOqroiJjwH09/DXeUlZtlfQEH5hw7jI9ltHip+EST3vtkKB7FcNeL/aFbUaVhQdL7+dBn8a5ybqPrAMQspg4mVOoz+B+0M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reclaim splits a PMD-mapped anonymous THP into PTE-level swap entries
before unmapping it, so an ordinary swap entry has never had to appear in a
PMD. Later patches install one there instead, and the softleaf layer is
where every consumer decodes non-present PMDs.

Accept swap entries as valid PMD softleaves and add pmd_is_swap_entry().
A swap entry carries no PFN, so make pmd_softleaf_to_folio() warn and
return NULL rather than interpret a swap offset as a page frame number.

Unlike migration and device-private entries, a PMD swap entry can also
carry the swap-exclusive marker, which softleaf_from_pmd() has to strip
before decoding. Strip all three overlays unconditionally while we are
here: each clear is a plain bit clear, so testing first only buys a branch.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 include/linux/leafops.h | 40 ++++++++++++++++++++++++++++------------
 include/linux/pgtable.h | 17 +++++++++++++++++
 2 files changed, 45 insertions(+), 12 deletions(-)

diff --git a/include/linux/leafops.h b/include/linux/leafops.h
index 7c13c58a5e218..ce176c78cefd4 100644
--- a/include/linux/leafops.h
+++ b/include/linux/leafops.h
@@ -98,10 +98,9 @@ static inline softleaf_t softleaf_from_pmd(pmd_t pmd)
 	if (pmd_present(pmd) || pmd_none(pmd))
 		return softleaf_mk_none();
 
-	if (pmd_swp_soft_dirty(pmd))
-		pmd = pmd_swp_clear_soft_dirty(pmd);
-	if (pmd_swp_uffd(pmd))
-		pmd = pmd_swp_clear_uffd(pmd);
+	pmd = pmd_swp_clear_soft_dirty(pmd);
+	pmd = pmd_swp_clear_uffd(pmd);
+	pmd = pmd_swp_clear_exclusive(pmd);
 	arch_entry = __pmd_to_swp_entry(pmd);
 
 	/* Temporary until swp_entry_t eliminated. */
@@ -634,18 +633,29 @@ static inline bool pmd_is_migration_entry(pmd_t pmd)
  */
 static inline bool softleaf_is_valid_pmd_entry(softleaf_t entry)
 {
-	/* Only device private, migration entries valid for PMD. */
 	return softleaf_is_device_private(entry) ||
-		softleaf_is_migration(entry);
+		softleaf_is_migration(entry) ||
+		softleaf_is_swap(entry);
+}
+
+/**
+ * pmd_is_swap_entry() - Does this PMD entry encode an actual swap entry?
+ * @pmd: PMD entry.
+ *
+ * Returns: true if the PMD encodes a swap entry, otherwise false.
+ */
+static inline bool pmd_is_swap_entry(pmd_t pmd)
+{
+	return softleaf_is_swap(softleaf_from_pmd(pmd));
 }
 
 /**
  * pmd_is_valid_softleaf() - Is this PMD entry a valid softleaf entry?
  * @pmd: PMD entry.
  *
- * PMD leaf entries are valid only if they are device private or migration
- * entries. This function asserts that a PMD leaf entry is valid in this
- * respect.
+ * PMD leaf entries are valid only if they are device private, migration,
+ * or swap entries. This function asserts that a PMD leaf entry is valid
+ * in this respect.
  *
  * Returns: true if the PMD entry is a valid leaf entry, otherwise false.
  */
@@ -660,10 +670,12 @@ static inline bool pmd_is_valid_softleaf(pmd_t pmd)
  * pmd_softleaf_to_folio() - Convert the PMD softleaf entry to a folio.
  * @pmd: PMD entry.
  *
- * The PMD entry is expected to be a valid PMD softleaf entry.
+ * The PMD entry is expected to be a valid PMD softleaf entry that references a
+ * PFN, that is a migration or device private entry. A PMD swap entry is a valid
+ * softleaf entry but encodes swap slots rather than a PFN, so it has no folio.
  *
- * Returns: the folio the softleaf entry references if this is a valid softleaf
- * entry, otherwise NULL.
+ * Returns: the folio the softleaf entry references, or NULL if the entry is not
+ * a valid PMD softleaf entry or does not reference a PFN.
  */
 static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
 {
@@ -673,6 +685,10 @@ static inline struct folio *pmd_softleaf_to_folio(pmd_t pmd)
 		VM_WARN_ON_ONCE(true);
 		return NULL;
 	}
+	if (!softleaf_has_pfn(entry)) {
+		VM_WARN_ON_ONCE(true);
+		return NULL;
+	}
 	return softleaf_to_folio(entry);
 }
 
diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index e3c8ab96941c5..3f955f836abfe 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -1917,6 +1917,23 @@ static inline pmd_t pmd_swp_clear_soft_dirty(pmd_t pmd)
 }
 #endif
 
+#ifndef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pmd;
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return false;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pmd;
+}
+#endif
+
 #ifndef __HAVE_PFNMAP_TRACKING
 /*
  * Interfaces that can be used by architecture code to keep track of
-- 
2.53.0-Meta


