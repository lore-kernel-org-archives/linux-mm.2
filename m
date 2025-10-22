Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EE18CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:29:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 796E78E0012; Wed, 22 Oct 2025 04:29:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7478D8E0002; Wed, 22 Oct 2025 04:29:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636CA8E0012; Wed, 22 Oct 2025 04:29:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4EFC18E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:29:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0E8FBAA9A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:27 +0000 (UTC)
X-FDA: 84025075974.07.4E5ABFF
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf28.hostedemail.com (Postfix) with ESMTP id CC1A9C0005
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:29:25 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DHdvt5Gv;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121766; a=rsa-sha256;
	cv=none;
	b=dzreB08XZ9aXojH/JfHS4FZUqX3UDvqtnuq7J6cnjPOBZtg3e3OKK3wrz7c5a2Ervrc+u4
	gw4pP9tlgujLZ5jCXFcWCavCWPKngmPYCkqbs+gjsix6QA/eTNrK07x4LDbBcH4Mzzro3+
	hJOU4GpPbbJrIpfFa29AaDFUVPEI7n8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=DHdvt5Gv;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf28.hostedemail.com: domain of baolu.lu@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=baolu.lu@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQsh9ULOkP1Nv9A6ASUL8IdXOZfQ2/XyDb+3LK/NYAU=;
	b=XESTPIzlLK8JQW8FZMpQSx/5T4oqN5oh4Cd4hETJXw1MbfBZt6iQuhfD2gmw7cL+/+CVpH
	LFD2NiVZF1c7KHerEoT1igWob8T4NJ0xjB2E7juzb0Ckm+eRVbKqO1yMigJdu4lk/mLCzs
	iHtpBxn05rChveLZfHeW59bdUFWONfg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1761121766; x=1792657766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=PamdCW5SIExW2MSTVmRrUvcUix6foLzr9uopaA+M2pw=;
  b=DHdvt5GvntYwXG382FUR7XpyQeSFxu8yCWt0dY0XuK/r9574wRhz8zmd
   Sq+ZPp5ERcTjQXPL5wWc8wBbuDcfX1Y075gA3QtgtpjqewFh9hNwOgHcy
   OLfFPfu9Ik4R0Km9GwQv8NnLtyXdmXEC6ffXzAJvKAcTKA+2lmPDThPEz
   6Uw0AWztDTsXSV4NoCGgpYY31LSWPFZNnHLKiKMdt/AgsP789J5PAzfLM
   qfUZeMWOhahvOPnfure01VNILrc8nGa2NfJTs4NtubhuYRnajqOPVnZXt
   fl/88YwDHpxiFDju4HKBe6oaNwD7i2qZ1XGO8AhB6f6nNA4m+hzs8/NS3
   A==;
X-CSE-ConnectionGUID: e1gf97u7SF2iRfsb5SybvA==
X-CSE-MsgGUID: JoQh2fHASsyLnOGc85imeQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11586"; a="67126987"
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="67126987"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Oct 2025 01:29:24 -0700
X-CSE-ConnectionGUID: uYNe54tGQT2jRkTDg8M2GQ==
X-CSE-MsgGUID: 96m6+PNSSlueQgOErfr6UA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,246,1754982000"; 
   d="scan'208";a="183516242"
Received: from allen-box.sh.intel.com ([10.239.159.52])
  by fmviesa007.fm.intel.com with ESMTP; 22 Oct 2025 01:29:17 -0700
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
	Yi Lai <yi1.lai@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: iommu@lists.linux.dev,
	security@kernel.org,
	x86@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v7 2/8] mm: Add a ptdesc flag to mark kernel page tables
Date: Wed, 22 Oct 2025 16:26:28 +0800
Message-ID: <20251022082635.2462433-3-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
References: <20251022082635.2462433-1-baolu.lu@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CC1A9C0005
X-Stat-Signature: 7375yjggozjktcq4g7yqu63fewwaqrtb
X-HE-Tag: 1761121765-443327
X-HE-Meta: U2FsdGVkX186hIjBXlIsXncfBDUfi4tgwSpuNxsn+Ok1Jr3JYYUAZGcisdxlcibmAyJdtZuq+nyC1y0Ic8LqWEt/B7679W7fpC6u3dQUwMez5518MsObUvZj42KkwCZAw69cFioz+RejCieoABGaqdCHmcD8KYkvcXqDJMH5Ur++FYVGw1qbEYDtDBNPahLRKMM45qb9eLUenAuNhX2V7NlLXbc2oWncnqTtbAUegBBM8YqtS5XOO6obOHa3pS/Y9JOIcLY0sV6Tanv7Npv7irgL+H/H6RoSol063dO5ryWcYTmJXhiJufek1X24Qx2erAFXBD5F+3VqS5iPEIIhFG5qbsJ+5MuAcYWd09tsPA8J4p7DISG+Mm7sW++aUW5uuFM6o/GbRA4xF1N4SNWoGfQCEQte2vMtd61Jg+fhinV0VDzbYpYQGwRFTluKP12W5wE4c5ukfpYZiV+TrUcCNB9+DdI81gH9j1rauzcpZxoEsfbGIDsL41zFfTo1+Zerz7VyUfiE86wZ4PqPPqTdJQTFf49yN+fc8G1BxK2TpPGK2SXpiTUb7pjgxLJdfJ01LOOM2QwI9XGIOvfwKGi8IcmfkepuA9OjjkX5hLWn8hYnTCSrFUpgsEB+b+k7Yl6i6Xu/sj/ew1+YdPr9oCfUL9EFLSK223FN23yd/+pKe1AAXfzMnUZMHCpY2LatIycrMu7buD6OSQS++CQWzdfT0/xYtr6Li1Y3vyyTaoPS20ZVPtRq2gFb8VQf+0sRxORRn/8CskWVZ7s+pa8lqKwMMPNZuVccyD9/2h8HIdRgb3OsLjYvbQR5w/P/qwHU603cJSr3LzHIKzI3EiK7ZnM5nnxlcx9xu1/dhKFZHS4DD+kZBe+inYZtatrGxWUXgG02qneAHOBpOaQzMuGToOJl4nFGgYsIuU9NGjXxoPM4e7uDgF19jr2L/10vpMX5Q5+haC5U4bNy7UWi1TxxT2a
 yxYnedAP
 mhlTvLyqEoTJS3S7J5OY8I3wZcuxM1ZAip9db5wImmLx0Brcfk/dW7aMqDRPRGx0vMxmEupyICMRKm2bZW3oTGaSwOBxQFc8nwsrDSns9MRj649EB7eY/kmVkCCgff6AK8G6F0HtbBanvTCaWvveuc1Mhl44yNsyBvquW5XvSYcR043x4BRFEkF5i5som1HKAiG1B4hAnkZxXvPewNBDfckfCO3P+jzP8+Y7rqPr/JLzKhzlKS9xFPyOwZN6pItDOt8Wm
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
Acked-by: David Hildenbrand <david@redhat.com>
---
 include/linux/mm.h | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..354d7925bf77 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2940,6 +2940,7 @@ static inline pmd_t *pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long a
 #endif /* CONFIG_MMU */
 
 enum pt_flags {
+	PT_kernel = PG_referenced,
 	PT_reserved = PG_reserved,
 	/* High bits are used for zone/node/section */
 };
@@ -2965,6 +2966,46 @@ static inline bool pagetable_is_reserved(struct ptdesc *pt)
 	return test_bit(PT_reserved, &pt->pt_flags.f);
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
+	set_bit(PT_kernel, &ptdesc->pt_flags.f);
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
+	/*
+	 * Note: the 'PG_referenced' bit does not strictly need to be
+	 * cleared before freeing the page. But this is nice for
+	 * symmetry.
+	 */
+	clear_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
+/**
+ * ptdesc_test_kernel - Check if a ptdesc is used to map the kernel
+ * @ptdesc: The ptdesc being tested
+ *
+ * Call to tell if the ptdesc used to map the kernel.
+ */
+static inline bool ptdesc_test_kernel(const struct ptdesc *ptdesc)
+{
+	return test_bit(PT_kernel, &ptdesc->pt_flags.f);
+}
+
 /**
  * pagetable_alloc - Allocate pagetables
  * @gfp:    GFP flags
-- 
2.43.0


