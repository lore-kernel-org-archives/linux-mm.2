Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25FC3CAC5A5
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 05:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 857C28E0008; Fri, 19 Sep 2025 01:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82F4D28000F; Fri, 19 Sep 2025 01:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7454E8E0022; Fri, 19 Sep 2025 01:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62B538E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 01:42:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 15F30C0455
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:42:41 +0000 (UTC)
X-FDA: 83904905322.17.249B7AB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf05.hostedemail.com (Postfix) with ESMTP id EDE9B100005
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 05:42:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NS28m+HF;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758260559;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1+KgxerxLR8q33qwbICgGUnERw8vpTbE/tv/zp4/Cg0=;
	b=ItIn6x+rPhYGJFCrAaL0MWw+8d4h1cvqGfDwlG9oujjyvhfcNq2JB4UCkWj26rnJRXRtL/
	ZJzVMFlvq+5pFcz5SRv074xFhz4SSzX4mRgC7YZ1XCPY4TzI0gF3r2Ynua8DGOuDNXraui
	DBjtlPzX7CQMwfTvT6T1qkNbrCEWtr0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=NS28m+HF;
	spf=none (imf05.hostedemail.com: domain of baolu.lu@linux.intel.com has no SPF policy when checking 192.198.163.13) smtp.mailfrom=baolu.lu@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758260559; a=rsa-sha256;
	cv=none;
	b=HrTMJ5JXZ26lY3qCpgG9h3qMGAcxSpagGqkxN+NZVqP0S14LUUdR2Tmunr4Yqhk4ZPwVGb
	SzWBRv0nZZgKPp9WRdQBXez3U+NirUZmc8dhpb7rFDd8F1IykWYTOED1+S2adjkig0lKti
	G01eWu3Cq94JsXF/8RMRcfHtBGsUKuc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758260559; x=1789796559;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=iUqj3COmeW15RDC5LUeEsbZGHpcevKH79WP9pbOzJHI=;
  b=NS28m+HFR0wDSxKokrqb3n1nd2ajJnOtJ2wwZvhO1YQXDtQ8LR3hL4D+
   4z9tA6lr/9Z79pZDWAHGi7hBb4n21pmEMYdwG7yGDEAgdKhC/1DuniwL/
   8oYm5soST91NzgPlaFMwYMXTpu7OcVHzdmmVbuilN4beNj0IzqQP5owVt
   YrwNvCTO9EbX0ARnk+yeIN0AuzkFuu8ymBfDQ18Ktki6ra7Q8JLXFnbqy
   Y3opnDQ1KtpMpwbMvGmTrVIU+9xD0iAYpaEMbSSOvueWR/ieOm9L/wIbk
   f/udL2NWmDyTKBFpHJHgW1ud+5nsUg6b09O6BK4ydRhueKiBeYDKb9mxb
   A==;
X-CSE-ConnectionGUID: cF3Zq9JrTyGzGlRzIDQiHA==
X-CSE-MsgGUID: ec3ZoF9NSHSYpptlbo487A==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="63235716"
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="63235716"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 22:42:39 -0700
X-CSE-ConnectionGUID: PjyqK40nSoqjLfkLARL2lA==
X-CSE-MsgGUID: 3Q1FXywFT9WI1HxLfRFxXA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,277,1751266800"; 
   d="scan'208";a="180858570"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by orviesa005.jf.intel.com with ESMTP; 18 Sep 2025 22:42:32 -0700
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>,
	Will Deacon <will@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jann Horn <jannh@google.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	Alistair Popple <apopple@nvidia.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Andy Lutomirski <luto@kernel.org>,
	Yi Lai <yi1.lai@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v5 1/8] mm: Add a ptdesc flag to mark kernel page tables
Date: Fri, 19 Sep 2025 13:39:59 +0800
Message-ID: <20250919054007.472493-2-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250919054007.472493-1-baolu.lu@linux.intel.com>
References: <20250919054007.472493-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EDE9B100005
X-Rspamd-Server: rspam05
X-Stat-Signature: 1dyybcgw4b81tb8eyggz7s9xg434pdbh
X-Rspam-User: 
X-HE-Tag: 1758260558-501267
X-HE-Meta: U2FsdGVkX19+DqDFN7PXVnG4Xs+7sswGqjIMjsMG5ULVnfcduIw7A7iTHrWOLU4B6GqOdkfjfIfz94qUbZeIeu+rFRRVwbe1WlduZBxgNgPPDoLaOnv5qTgnKYDsk0R2d0ykCj3Tgke7WwPvL3rXopwCBrdy2Mi5sG2MTSY7eA/I9wOdwE3C3PwOLnC1yTab9JEW2y7rUsq25nQeJKE9ffNXaIajtOAnLibgiNcFXscAKjhBNrj8ngjP/CMdcVdHRW7WKnouYPhfxgsAu8NKNYeoBm3X8jKCd4k1LFGVLu3UFYO+pkVsbFXkqmZWkWDkoXZyplx/avlZfggZ9wY8k5vzlKTgA1cRP3erSrAMEqaMJ6tBEy95vC7mI1BdHGiLFmFGVvh4a4/c9wvl4TQ43/NCsE0HJb6af4LW1gqHYjydKA5w6pqEYN2o+G7ObuLtM0C20B6rwAQA6Vjaw8ar3HNU45HEDMs4HqWd7ay63Kob7kcLDby4CB1aZpd+i8Qhl6uF4Nq0veXy3x/k4DHBw3zL9PAMWYh4GqPa2/5DmLwjbXktf1v8Zol8KtXClwyNV2DbMotFoNWcxNIebln+qCunBuT2J1QtVi31W843KKGcr11F9gzaAKymT4f8f99eWgD/gq4jaWtk0MoLWph45QX0d6+C4UKFxHOeNMYg2Oxfh1Hv1UMxKhJW+HBKPS/bUmRNK/kUAJrLBOVFOz95Oc3hIq2sIO+6NFXg7K9HOgKZat7yp2BrEyr1ZbfT7BDSAUR6Nne63pxuT+CEh1BRE37AT4zyhcarCCz5SnlW+YpJCPrzSWr0WvPehWcm6UT0RmlVrjylBEYd8ktubg6IZ/ZpTi+dLPGwdLrNex8wCcX0fRyA/EVdVjPy5q0TKJKQtonOTiF1dWFCqpvjNr9XvTAUhdi3QRSvqIbcw8fq9U9ks0lZTh+P7fJzG3weJEbR/8gE8MGG9gUMBWEcIbM
 F9DFg0GK
 Y3zmhmt+77xJ3XOAJ300cru3KLayslLvYhoGFakU2Y0vkG4wF3otvUB5r486/PmMuvs+4JXu/xVI7OgCsaTJbVCui+IHeQJq7umJFKGCBwrbz62+FkEiZnHx4fSStAiuR+xqfV4d0lwz2lyJmx15LfGFz/WeuoSkP4gDc5ZTfNcl5OHQ9L9/P0DviAR3LGG1S9pn56GTuckST0ClFu1ro+jHscVDklyQoXWPo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Dave Hansen <dave.hansen@linux.intel.com>

The page tables used to map the kernel and userspace often have very
different handling rules. There are frequently *_kernel() variants of
functions just for kernel page tables. That's not great and has lead
to code duplication.

Instead of having completely separate call paths, allow a 'ptdesc' to
be marked as being for kernel mappings. Introduce helpers to set and
clear this status.

Note: this uses the PG_referenced bit. Page flags are a great fit for
this since it is truly a single bit of information.  Use PG_referenced
itself because it's a fairly benign flag (as opposed to things like
PG_lock). It's also (according to Willy) unlikely to go away any time
soon.

PG_referenced is not in PAGE_FLAGS_CHECK_AT_FREE. It does not need to
be cleared before freeing the page, and pages coming out of the
allocator should have it cleared. Regardless, introduce an API to
clear it anyway. Having symmetry in the API makes it easier to change
the underlying implementation later, like if there was a need to move
to a PAGE_FLAGS_CHECK_AT_FREE bit.

Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
---
 include/linux/page-flags.h | 46 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
index 8d3fa3a91ce4..1d82fb6fffe5 100644
--- a/include/linux/page-flags.h
+++ b/include/linux/page-flags.h
@@ -1244,6 +1244,52 @@ static inline int folio_has_private(const struct folio *folio)
 	return !!(folio->flags & PAGE_FLAGS_PRIVATE);
 }
 
+/**
+ * ptdesc_set_kernel - Mark a ptdesc used to map the kernel
+ * @ptdesc: The ptdesc to be marked
+ *
+ * Kernel page tables often need special handling. Set a flag so that
+ * the handling code knows this ptdesc will not be used for userspace.
+ */
+static inline void ptdesc_set_kernel(struct ptdesc *ptdesc)
+{
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	folio_set_referenced(folio);
+}
+
+/**
+ * ptdesc_clear_kernel - Mark a ptdesc as no longer used to map the kernel
+ * @ptdesc: The ptdesc to be unmarked
+ *
+ * Use when the ptdesc is no longer used to map the kernel and no longer
+ * needs special handling.
+ */
+static inline void ptdesc_clear_kernel(struct ptdesc *ptdesc)
+{
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	/*
+	 * Note: the 'PG_referenced' bit does not strictly need to be
+	 * cleared before freeing the page. But this is nice for
+	 * symmetry.
+	 */
+	folio_clear_referenced(folio);
+}
+
+/**
+ * ptdesc_test_kernel - Check if a ptdesc is used to map the kernel
+ * @ptdesc: The ptdesc being tested
+ *
+ * Call to tell if the ptdesc used to map the kernel.
+ */
+static inline bool ptdesc_test_kernel(struct ptdesc *ptdesc)
+{
+	struct folio *folio = ptdesc_folio(ptdesc);
+
+	return folio_test_referenced(folio);
+}
+
 #undef PF_ANY
 #undef PF_HEAD
 #undef PF_NO_TAIL
-- 
2.43.0


