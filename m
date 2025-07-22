Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29073C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:36:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3BCD6B0089; Tue, 22 Jul 2025 15:36:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EC5A6B0099; Tue, 22 Jul 2025 15:36:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DB156B009B; Tue, 22 Jul 2025 15:36:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 791336B0099
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:36:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 186CF111C8F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:36:05 +0000 (UTC)
X-FDA: 83692906290.03.67043FA
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf27.hostedemail.com (Postfix) with ESMTP id E0F674000B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:36:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KK23oON5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=francois.dugast@intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753212963; a=rsa-sha256;
	cv=none;
	b=2C8UrUeLltfzLsqSXGcjiXI6Tm4LnM4O0Oc/ksCG8fs7hf0e2XEVcEMu/HymDOntg2PRdd
	yC2uzdbrlQ84q81z/lymfdO3aYCgnXkzmZPW/e/KNI13PDUUZZHAJZqytKS4hpj0ffy+qb
	a8IDhT5h0ymOfRVQ0UZdbwBhcyln2yM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=KK23oON5;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf27.hostedemail.com: domain of francois.dugast@intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=francois.dugast@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753212963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d1h84Vgi+SSeAt9fCMN4AkwcLNqlNR+0yiJ6EzHvvPU=;
	b=d/d3Lj2fWENnivWQrP8UcOEpN6esIryP8cXVDseUbnE4UcwO2Xd+0GLlprOCp5qTJhx4Hw
	zjH1P+6iDuKiaHlSHPA2iCtaD0178hG1wRrLfcCncKt4EHuVl2jW4GYd4bO6l7ea+ZKVdm
	i2Wsu53BP/U8+5hsfp6osQkvwyb7SgA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753212963; x=1784748963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0IlvhvfDrw5+9DTE/LPj4HOX+CjBvksRT2GhOo67isk=;
  b=KK23oON5ZBRVX7J5X+n/DhHiVXv36Fn3G0D+FMnA8XE4eE2SdZQYzbcb
   fa4PnL7RmFIVG9aUme678W5rDMPLzZ40SQKUM+bkcDO0XnYlLiFYoHFZm
   RmJddAb409DL3affePHQkGfrKS2F8GsUZcZqhwvDazbqNAOdGlCfLpU6V
   DCV9Eph14GxhqPRwFbKvJIj+Gwme7vOkSTXXq9etP+SnnZpOeSY7LJVOh
   b2IDD91QRFLfD73G9ni5W1PNV7cz4dUkHxGz9dS7kpj+FwWC0c9CgIwL3
   LCHKPQGdqjvtkrNbHBxr9eR4U2dlm1A/tN7D3udIC+7bljY7hbabdSh09
   A==;
X-CSE-ConnectionGUID: KD8n28TTToGygXgHDpi3Ig==
X-CSE-MsgGUID: 77LHUf1hQB6KuZd/NVff0A==
X-IronPort-AV: E=McAfee;i="6800,10657,11500"; a="59137000"
X-IronPort-AV: E=Sophos;i="6.16,332,1744095600"; 
   d="scan'208";a="59137000"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 12:36:01 -0700
X-CSE-ConnectionGUID: sgG2HkpsSwKu61a54UBRDw==
X-CSE-MsgGUID: /Knu5S8VQyuatVyQZle/zQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,332,1744095600"; 
   d="scan'208";a="164694647"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO fdugast-desk.intel.com) ([10.245.244.157])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2025 12:35:56 -0700
From: Francois Dugast <francois.dugast@intel.com>
To: balbirs@nvidia.com
Cc: airlied@gmail.com,
	akpm@linux-foundation.org,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	dakr@kernel.org,
	david@redhat.com,
	donettom@linux.ibm.com,
	francois.dugast@intel.com,
	jane.chu@oracle.com,
	jglisse@redhat.com,
	kherbst@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lyude@redhat.com,
	matthew.brost@intel.com,
	peterx@redhat.com,
	ryan.roberts@arm.com,
	shuah@kernel.org,
	simona@ffwll.ch,
	wangkefeng.wang@huawei.com,
	willy@infradead.org,
	ziy@nvidia.com
Subject: [PATCH] mm/hmm: Do not fault in device private pages owned by the caller
Date: Tue, 22 Jul 2025 21:34:45 +0200
Message-ID: <20250722193445.1588348-1-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
References: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E0F674000B
X-Stat-Signature: 89g8yyk8inpsgnj4hc7m69659thws9ua
X-Rspam-User: 
X-HE-Tag: 1753212962-661419
X-HE-Meta: U2FsdGVkX19mrtTxtrQNzg6xcbR95iDYxkgYPYnzvJ8WmHsY7CoIoJNIKnLXVM194o0FsLdeqh75VT0KzAZFF2HO4XX7bSFqyvYAnNGMpBdShCI6IsxW6zT5X8KdSYqbECCbzRFhNEwfH9JRsE8LSDi7AT8kKRxeNga5w2Govv8LakWMPnVvLmRATLih4j3Y+kg/+FQKRVDglcoA0AYWAUrH0lMNfyWJeG1g/jV5FITtIJ39qo9QnKBX4ojF8FUq3ARS/9IfdeayRRbATd7ynf8rtepXrDVJcC7JhrTFanvMmYuOV+dl0rsrc1iy52SypY9TxiAWs67AQy9ppSQJbwPaOwFMPbmzpLrrgi2Afy7NKXl4PCOMgpZlINbX1YzpYgueyn3IHSYskLPH63utKubQlKZjI5RQwkkIXgq96ho0QwoPXnfFrRxBa0bj9GECtsahmv7OeDqSBRDZPe5EamishoG5DvmwJkDJbiCyz+ZM8WqzLC1n+lGv7e+1d1lF93DlHybQUhO5+MnDQXXTWLh7sTyQ3pD9rr6u8rPUwvldxc3Bly+d0FcB8gQqk7jxlxcPZUjYr1a753hpiuSMT0wK5L8XRJnv6OPgJwE/eeCN1p3lsTcena0zK7jikFsivgI+Wis0B1Ig/56WvRSdyUhqbJAXmXpFg2/J5fKHegm+AM4EmBvfRpfd5167f7GuEK77mlwh/yszF40AgEBOPoA/UoChE+/VD8RPX28pKKyb6Gq4mqDuv7FqYHT4gDWY9syYMi6zSOR6rvseDCCqhE5W/GAPIdPa6Xe+1Ozj8o9a2oEFvStiDMosl+JWm3Wby+vVox/0yB8t52i88ALAzxk0+Ht0mo2PiHb9auigSlSPXFReN/icxyX9TupmIrMiEYf2+TXojc9VYkks32WJ/2KNWaL6teLmUSULJ9DmDj6vTRegXIfC1eFjnk+2s9t9+DVtKJtlL/bUMoryokc
 wW5sPmM2
 omiHFTsGzar+33cA5BoI1llgx7/IJHRErMzXiKvOM86zh5efEwYrewZ4y35H1L1j8ZvJ8A9xrU3rvL3sK/3vPebHz3n1uFcPqs9dbF8nQJyMH1HCoWcskgKoNP2S8ae/N2cMF1ZTtLHf4P69L2M7OsAST0lcF6YKObPc6MdAVSyYYeNZwTqGmtSOlMbp7goIU6yBgxmSTKLIfcsr4tqQ+2624Cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When the PMD swap entry is device private and owned by the caller,
skip the range faulting and instead just set the correct HMM PFNs.
This is similar to the logic for PTEs in hmm_vma_handle_pte().

For now, each hmm_pfns[i] entry is populated as it is currently done
in hmm_vma_handle_pmd() but this might not be necessary. A follow-up
optimization could be to make use of the order and skip populating
subsequent PFNs.

Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 mm/hmm.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/mm/hmm.c b/mm/hmm.c
index f2415b4b2cdd..63ec1b18a656 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -355,6 +355,31 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 	}
 
 	if (!pmd_present(pmd)) {
+		swp_entry_t entry = pmd_to_swp_entry(pmd);
+
+		/*
+		 * Don't fault in device private pages owned by the caller,
+		 * just report the PFNs.
+		 */
+		if (is_device_private_entry(entry) &&
+		    pfn_swap_entry_folio(entry)->pgmap->owner ==
+		    range->dev_private_owner) {
+			unsigned long cpu_flags = HMM_PFN_VALID |
+				hmm_pfn_flags_order(PMD_SHIFT - PAGE_SHIFT);
+			unsigned long pfn = swp_offset_pfn(entry);
+			unsigned long i;
+
+			if (is_writable_device_private_entry(entry))
+				cpu_flags |= HMM_PFN_WRITE;
+
+			for (i = 0; addr < end; addr += PAGE_SIZE, i++, pfn++) {
+				hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
+				hmm_pfns[i] |= pfn | cpu_flags;
+			}
+
+			return 0;
+		}
+
 		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
 			return -EFAULT;
 		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
-- 
2.43.0


