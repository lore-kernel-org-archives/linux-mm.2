Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A26C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 08:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D55C8E0005; Fri, 29 Aug 2025 04:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 885B48E0001; Fri, 29 Aug 2025 04:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774AF8E0005; Fri, 29 Aug 2025 04:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5B2458E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 04:18:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 149D913900E
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:18:01 +0000 (UTC)
X-FDA: 83829091962.29.4927BD0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	by imf16.hostedemail.com (Postfix) with ESMTP id 42397180006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 08:17:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HJVJZuhd;
	spf=pass (imf16.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756455479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ihP4ogkVn1nCCWeIOK/pBqv5urALOSo9sfwODfkNKsU=;
	b=QMHcT46VosLLUgC7Ts2/GcoeqtU/jKoaby48V10bV1s25omPEHuRdTEYAVL9+MKvmnEY6O
	qjH7+3YmLixxjqkO3jvQJLwOIfwM0QkaTeFLw2wQxfvJMwwLpHGzhclBv2vhBEW8eiKrOS
	ZJATW/A2651+vj7107wWpKxUmyoW/J4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=HJVJZuhd;
	spf=pass (imf16.hostedemail.com: domain of francois.dugast@intel.com designates 192.198.163.7 as permitted sender) smtp.mailfrom=francois.dugast@intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756455479; a=rsa-sha256;
	cv=none;
	b=KctiReb9FJEYlYtQ8xaJATFGCF/QxaZEl0ETW9VvZUFvPiWpXWPABPELdjzXUvmt0TWatT
	hghEMbwY70qCUNK5J+QWRza6Q9OR/WiQs0PCNlxtqPcV5rKkDiN5HRmmeiCMabQBWZ6EQn
	oAbAJldmfCTlvOxNwHk4Sjpw4+vNjtk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756455478; x=1787991478;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=+rI6DshNVuVHxvxAMJf9lv0sngtwLI+fOufDE1KeYMk=;
  b=HJVJZuhdwOFwlWiae/yOYyjXR5kY8cDwMWYHKx5Uu5CjGjWikb1abZh3
   9P7b9z8z2R0NcB+/v0hHuTojPPMli4J1IJQlJml80AOmzccrG5ZiFpmew
   MAC1OKZdZmmbWDjl0YX8i9uqNeQXm61kx69nIDTIKErPJdZKui6//22tD
   oHBjHMis0SoB/k3UPAnNsrOHcaOK2fKJBsN+fTZMTU4sZjoIBzE4jqe1R
   U+H6dKZpKH2Nab53arv7FRnomLNonPCAy77izdV69EAjjdtIW5TIeBcYp
   zIziPOddrwUTS5aWTU92k14W75O/7Hz9iS5cdMCdeTf8YA6E22+7aCJk3
   g==;
X-CSE-ConnectionGUID: Qli8fPebQjecdUNktaP9KQ==
X-CSE-MsgGUID: 0o/GBuOuRFi3FUBn1/6oTQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11536"; a="84142109"
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="84142109"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 01:05:20 -0700
X-CSE-ConnectionGUID: cFH5exCaQZGX7tzbhQPrfw==
X-CSE-MsgGUID: WUSs0ov1SmmtgspQZSiyTw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,221,1751266800"; 
   d="scan'208";a="169893626"
Received: from lfiedoro-mobl.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.246.57])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2025 01:05:16 -0700
From: Francois Dugast <francois.dugast@intel.com>
To: linux-mm@kvack.org,
	intel-xe@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org
Cc: Francois Dugast <francois.dugast@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	David Airlie <airlied@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	Thomas Hellstrom <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: [PATCH] mm/hmm: Populate PFNs from PMD swap entry
Date: Fri, 29 Aug 2025 10:05:05 +0200
Message-ID: <20250829080505.1020155-1-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: j4o8s8t1zws6deom41md74gz3ywf1w3y
X-Rspam-User: 
X-Rspamd-Queue-Id: 42397180006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756455478-490890
X-HE-Meta: U2FsdGVkX192ozlwTc1H69QTcoIpDUwsiUyKd6eYlzUzYoLFKIlvWGzgbpCeJAkTEmFtSMyXj0R65FhuQtHTo59C2il7P5Qk7AnPZnBayp5X6EvwBDqBEumB4ko8D1Vi3hQWAnFPFvn5SH+keSOPTz4slprcGp+E8kr85nM41H9maD7BI11CqW4pltTHno6KfAiZyKB4ACprgLNBu/+LP/tvKSDwu1Twa+VF+Q3Kd/Yu7dNkiaGK/9sihc1G3+XH6oZyN1/A15DercIkv12Egz/uhNWDsKJV3/9XId/K3yTU5rP8W63JTjr+iqP/B5lGl83MvGgbdJ+Jv/Izhe32qm1lHurJH6PppI7TXzTC3ebvbOR9nCgMjF1bps6kQ9v2ore5Q/vmOH4g1yL/BJEEq7YPYI336DPgeeNGSCpPjlOlazv43RVOzd49vya5owjzgTmuRNQEl4rRUMROcYGYLgPjCaXiPOn0AB5EQ6GPQWzITArUrd4UCtkSPPKfLufRDmLgvBCfzMsD1u45g+dI8kiRe5OjdVhhWgnKIsWpdCsMdF7mH6HnEFsJ6LK5wME9aJ7uUHDkg3XOGdgDBjXteYI8J7mrxIxstVphySEAMv8Qtth7MYqiU98qubVICt0XzSgR3inXKs8pW9ABmHTPcwnEmBvBKyFuUejIhqt/Yl1EdN/8ZotHxwQbMaZihOEwNSSNaB344POB7LkZ5wU7nrFPDdMxqpGS7IZbJsnKOQdUI4FwNS7Dxw2NPLNT6ECFQJtmoH1lADwRX0P51JFbstYnMzWbwmTapEUcmaV3GLKC5wCF72iwv1GgfCUxjUSGRAZQB3MOfv2ZQl/RlRn2ckucAP+LHNyP93eTjQNgBCFbNjG9LLWVJdSzZeou42C68lK2srmeT6m9ag9TKJoJOjjHh6vaqjQno2iEY9j6+/yuB3UCOJTaVERFQOTKEXxNy/TgUv2QDZCmi4teGj5
 eqoXIkA9
 SJjzFOZ8AJl9xtxoaIrvW0E3uHXKjfhFeB8iuYKyMVgwxj8Mczs4ZI5KsAdewe2BMzwPA1NytGV5L8gP8nuyCeguRCirFrPizkMRgGgiBx02bRdADyPH5MuEYzOolH2caB5spkDQTYTRbOC7eH2TnCfMll6423/tGaO1ySP3lBl3YQF7oFex0b6yBOc3L8nePmZddwZUHG6uZvGkq2VO4bLhvTH95k1AS8ryyhrnVqUMm0i3dqNoeW9edKq/kkOI4uIngMUhx64++nqpVvVyeE87lEP5576Z3j/rg8sWNYaf9Ik6X8vQVyAISouXqIHRV78lfN7lfqTCKJxYNEeIRRw2C4nkmTcVejvyi94PULrx5Vrl01VCqjULmg8OXxMSICP+3U35a5emraP4oVFAYEi7yB7Ujeqh5zplDM2OhNGxbKOM74wH1LeXaTRNan1+PjeO7Mlg8Vyk8eks=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Once support for THP migration of zone device pages is enabled, device
private swap entries will be found during the walk not only for PTEs
but also for PMDs.

Therefore, it is necessary to extend to PMDs the special handling which
is already in place for PTEs when device private pages are owned by the
caller: instead of faulting or skipping the range, the correct behavior
is to use the swap entry to populate HMM PFNs.

Even though subsequent PFNs can be inferred when handling large order
PFNs, the PFN list is still fully populated because this is currently
expected by HMM users.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Christian König <christian.koenig@amd.com>
Cc: Mika Penttilä <mpenttil@redhat.com>
Cc: Thomas Hellstrom <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>
---
 mm/hmm.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/mm/hmm.c b/mm/hmm.c
index d545e2494994..d449fc4647d7 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -355,6 +355,29 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
 	}
 
 	if (!pmd_present(pmd)) {
+#ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
+		swp_entry_t entry = pmd_to_swp_entry(pmd);
+
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
+#endif  /* CONFIG_ARCH_ENABLE_THP_MIGRATION */
+
 		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
 			return -EFAULT;
 		return hmm_pfns_fill(start, end, range, HMM_PFN_ERROR);
-- 
2.43.0


