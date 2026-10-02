Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86A93CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74646B00A4; Fri,  2 Oct 2026 05:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25176B00A5; Fri,  2 Oct 2026 05:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C142C6B00A6; Fri,  2 Oct 2026 05:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 956126B00A4
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:24 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 16BDF806CB
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:24 +0000 (UTC)
X-FDA: 85277231088.25.AAA3D03
Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2B804C0009
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lW/KWW7I";
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SNDQT2V7fLj2lpfuJarX2HUSCSnigHwGk9ne6VvB0ms=;
	b=v+nOJ2FqL9rNJsdP9xxzyKCbRq9NCBHxEtS6Qh6gljVAjugd5KNc54KOS0tMfoDHmXRwq5
	3Mb6KHx+ctxgmXYrn9h6eicgFYr9HeWRpeDs0V87wi4+HbRKUuNTV33y5KkgfCZdMe26Cy
	JcDEGC/bkyhzsmNSE87bntV7H+QsRq4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lW/KWW7I";
	spf=pass (imf10.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.21 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934982;
	b=MiFgVOceF9rpFQi29pTyrjTmDMouSKyUJgYDf8quPqxfxTygYOXZAMc87YfX2hGtDALLnH
	EJorKl7Px710QKZNt6d3DTzb692LyUShwA5394pYwMBmmh3lh16A2S2gxfxccXQEc9UkS0
	9BVke8wwFBR2ayQ/N4JTv0A4XTd9x08=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QdsRcAJ82gbKmhLcQmDxpB4bv16oNUQ+u/E+v54jmFk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934980; v=1; x=1791539780;
 b=lW/KWW7ICtj+J0wVzYNLF8sRc0sWqIHJeLyQx+LXC8OhbkEn9Jem9gqpd2vKZpGuJfTKY/Sn
 PsFkNOdT8Qc0fAJjyecPATswqERDm+p3U7PKgeDVVnhWWHwW6ktKac6zAGpG1cO1tKzmHbxHzsw
 LOLNO0VMMYMrP5nQMfyNTuCQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 2ac44650fa783d0c;
	Fri, 02 Oct 2026 09:56:20 +0000
X-Mizu-Trace-ID: 2ac44650fa783d0c
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
Subject: [PATCH v8 08/30] mm: recognize PMD swap entries in the softleaf layer
Date: Fri,  2 Oct 2026 02:52:22 -0700
Message-ID: <20261002095503.3585565-9-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2B804C0009
X-Rspam-User: 
X-Stat-Signature: 5s1h87pmrwmzyn96q847un4kf6o9xqkk
X-HE-Tag: 1790934981-543667
X-HE-Meta: U2FsdGVkX1/csFpfVXrve3SQISHvaFkeMhRKNaGdOLjVeMwxzK2D9oGJ3f10wAWDLoJJrye86BnbpaANKqj3+iTNIJWGyM2bSJvbeKebiLGEVbrV1+LQ34SJaHfZnRIx2lPhN3VB2pPLayyHePSSgSSTr5fSyU46j1ZBUimxypz/dej2dw54rFvfwmzbR/bZyb2RT394T8XSCLHpm3FL5xTcwaXMPNYvkpsv4L+cV69FDpNmmLDAc3a5MHqAImSpWAnIo31P36V60QFI3XlCvne5wvqbUEItydu5C0SRxo0CF/1QMY1vkpUm0hwnQtRmCIXX3Exq2b5kCoiUbRikF8/Gw9foHsUc5YTwtyDLA/X/lR1vWLIQJWApHjopNBURpQB+deXZdpdbmEmxQkVOvm8EEfDoHvTByr1c2haSG7cIyOl+gQ78vWCDfz2vaHKuDyAtTt/muhYmjk3X4QQx+9gv77cLMtZjXiixUaRC+VSyDQZEFTfpURsU8420RDqJYIgqiO9sSSBGG9Na1XwxzmfgknBXykGTAR5advJB5l7Qmhs5wENBgcE+3vARxZcliYvoKU1pMIEqoVrGTxPjQ++rhcsBWjV5vzcreFd0/pNcZ3D6Io3RQY/D+/MmbQEFFsBuy4cbf6nfymQShf/sBBsQxyE0PNN/FVVAgSeHiFAZg7rQehlh+NHk9P/4i1B4pBsPASuwb2Iqj5MUppEEzMBKiL3aIzUPpCX5515gKFefcesTor/dliny0SuIMjTjSoBS4xUwPs8/3xqOugtiWut/KBqx7axUbGseF2Mw5BP0hOyq9hPPSsA4yV2kg72OEv7m9918J1DwmVYXNs9G7pNjs3Zw8V17VKTT3Na840h+GyUntLot8OcuLuBiOKsMEX2FXZdgSZcmjbcrR1eYck+sNvcBL+cr4YM45WcQFfxKKu0RP1PSz8dr1asik8DxrNt9Bwk1zD1i//56cRM
 NmPjlCnA
 yhET7CMw66osWDx28rNwUMiH9JfKnNqSc7V8cotBXvp0xZ/YqX+y9ZhTurzq/JIyiHGEPrgBXVQB7XQUlflQggo1qlAOZn2ruIj43FRZ4Prg4kvdifbZu1JBidFhbPVbGZ6uq8F3/Z54+sG2iekdkz5rUJwptIY6Z7DjjoOKuvDZzuBLmg+f1+Hpjfw9YFjB3Jhn0bMAYJB2CHGh34KExEqaS8hle/NPGnYvNXOB3j/jARMqvea7tE7Xzd2tzNgG/dIFV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reclaim splits a PMD-mapped anonymous THP into PTE-level swap entries
before unmapping it, so an ordinary swap entry has never had to appear in a
PMD. Prepare for installing one there instead: the softleaf layer is where
every consumer decodes non-present PMDs.

Accept swap entries as valid PMD softleaves and add pmd_is_swap_entry().
A swap entry carries no PFN, so make pmd_softleaf_to_folio() warn and
return NULL rather than interpret a swap offset as a page frame number.

Unlike migration and device-private entries, a PMD swap entry can also
carry the swap-exclusive marker, which softleaf_from_pmd() has to strip
before decoding. Strip all three overlays unconditionally while we are
here: each clear is a plain bit clear, so testing first only buys a branch.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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


