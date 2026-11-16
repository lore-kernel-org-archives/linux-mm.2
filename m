Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D3C9606A33A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pdWIoeJK
Received: by kanga.kvack.org (Postfix)
	id 1CA266B00EF; Mon, 16 Nov 2026 01:36:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1531F6B05B0; Mon, 16 Nov 2026 01:36:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01B276B05B1; Mon, 16 Nov 2026 01:36:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBBF56B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:36:39 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A27FB1A08D6
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:37 +0000 (UTC)
X-FDA: 85440023634.23.A80A4DB
Received: from mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	by imf15.hostedemail.com (Postfix) with ESMTP id B8252A0004
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:36:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pdWIoeJK;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.33 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794810996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Oak5ZxZZQ9yAlOt97hpJszLVfzeQCeMnkPpNvWPUmfA=;
	b=hjbCubnvu6rg0jjqSZpjAyQ3CB+DeNwAkGq1+djdXYmfa15ry6fGsf+2lHenlqO37M45EI
	CFuHix1s0ZVYRA8Ulmukghmyml/1Ct1r+DiQa7piTa0DNP27QvyQ0B591LjcfVf8KSWmAv
	/QvBeyJus/a1WcFHlM1MRrB03ullP70=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794810996;
	b=6yOSZ3X/lIo3RqNhM7TvUB1N9AeLnu0ND6+k4VosVRJdotjTxxu5/AN17SZbNvZxSpGkup
	/AYtfsQx4U29+MSIhPjskBZ4aHsH9OuAJN4neApETsHAJ1Opp1NDFv0O3mYr0ssYqSO3V9
	jxwA+oR2+XH6uBQVCDzh0F4gOmvFgtI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pdWIoeJK;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.33 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=nFtAVBIgHW9ME6KU/nYjzXvPWwBZ3oZMIdJ78uXuQ5A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794810994; v=1; x=1795415794;
 b=pdWIoeJKU229pcjctC9fKotKlaTPb+qH15F4+ET7g6wfkje41+ThtZ+yLI8TNiX+dXbIYNQ7
 c9uFgnHvvibN/feGp5N/xIdj2X6W8tJKiJyMNY9FkzXMojh/AON9EATcGehDylgCBNBm4tkvaW2
 Pzdj4ZouRYC9x8ufJj+qkcmM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id f08f631b902eb383;
	Mon, 16 Nov 2026 06:36:34 +0000
X-Mizu-Trace-ID: f08f631b902eb383
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	byungchul@sk.com,
	david@kernel.org,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	liam@infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	mhocko@suse.com,
	pfalcato@suse.de,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	kas@kernel.org,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 0/4] mm: fixes for THP migration, swap-in and device-private smaps
Date: Sun, 15 Nov 2026 22:34:54 -0800
Message-ID: <20261116063624.1382944-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 34heq1mhgfrcumyxjrkcnwan817xtzry
X-Rspamd-Queue-Id: B8252A0004
X-Rspam-User: 
X-HE-Tag: 1794810995-855630
X-HE-Meta: U2FsdGVkX1942zITn0e7ybAuKObVOCeD0zYHytXiRj/WyLHPRVBb3J0hETKHk42Hs4y8nBjPTtxxByk06TXapnPD0XN8m6aSLlD03eNQomUfBJxkgbDKwKhDGAcr5JMm6GPsIMlYAxlN9yqKY5dsuzDfO4BWYA/nVWgajmFtTbB+vJVt0Vs46ckKkv2iTBJcB7DQ2f3coXRFRZvETwT8RV5fhDi4U+kIzAg4QC9snjWOS7Nndu+NTQf58tgufuqSOUkLuS0me1OSXicPG2OSfHBuk7jvPX4k7z6rfwNEyKavekW2WCcydX5dweB8CsQfXJ/hBB4UygnTxO5ZZTMyzvjAAsIk15Wc49yDgb71p3kGT5YQ8xzCTfOTrl4c2dB/5v4Y17fn08+bk+r5EmPTTpTYFwUHuwlgUHo0xfe2rsOzYIwP4lSCbk7JmS+PuRj93pxgto1e9EWjD09/G/yAFICES5Hn4nKbfyJUxaSbBKKgfPBI87jqOdkUHGHI0UEvArbHatIpPh7b8EVm6bwWlvUikoLr795iDz5Is4OK+YVka/LS65QgAI7kY0N6PkUhS6V4mm1+jIAD7sYpeW6RMfE2HwRFMl4foUQF58DFphCeDZ1bJySp7WDaQf82fU6Bh7oFNv6u72+abesxRROen1bFpwf2Zhyw5gMEZjlkFKZ+fZiFO1sG8CcOSb61Tqu1Dt/MZQcjyOdAxjddsBvnq4GQLHI/zrL6e8VEfRmc0p9FWA5MOksXjWwAm2EeMrRj7VWdXMIMG84spZI8Rf/0FmDd3YYT9XMCkzwjkShsCoAr11j6tNlyf/JhIcnmb9ryHRUHX5FhLE1xGEi0PNqWFpQzw4D31pgyNTGE/SyHF1dLzzQLWgYuY8w53/Ld89XM4F+Bo2DTpOIjfZqkmPGNHUOIZIngPgRMwXxHOY6xs5Zf3xo59GWlN3NPiimK7lgUxl5jLPF2t5zLv0YAjLp
 K8QHE+3i
 9JWSB5YtmAxo4TqL0L8KKqvw4TAVt/IQGwfywLLxfjx7dgqnBBz6laEErDbrhlYLazLYY0ecrhBEDzKUTelZhby+X/XEEDS7+GtOTzmapPBXbq/QuID5XafLoZtLxtak4k0ndTdZM0KpV5jtQqmy+61q3uNfWdmXspGR4VttG5imc9O8/CCRPS4IhjdiprAOGdZFxCwd3knvnkVodCz4jeqD9I1PaDLvzg+sXzZV/3/fJqGUeJ1NH8X6OarVA3Ytc3yu2HVUKrpWybOBYUynEKvhg4sPrpkNsBr7oMdqhR5289nYagNo8iZrgbTvgOE3M29Ir6xKfSs09Sh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series contains fixes for existing THP migration, PTE swap-in
and smaps paths. They were extracted from the work on PMD swap entries
for anonymous THPs [1] and can be merged independently.

1. Avoid a folio reference leak when concurrent MADV_DONTNEED clears
   or splits a migration PMD before the device migration split helper
   acquires the PMD lock.

2. Prevent PTE swap-in batching from mapping a hardware-poisoned page
   of a large anon swap-cache folio.

3. Stop reading the accessed and dirty bits out of a non-present PMD
   in smaps, where they encode the softleaf entry rather than
   accessed/dirty state.

4. Account device-private PMDs using mapcounts in smaps, matching the
   PTE path. Shared mappings get proportional PSS, and exclusive
   mappings are counted as private.

This applies on top of mm-new (0bce4c3c7589).

v1 -> v2: https://lore.kernel.org/r/20261111113904.650722-1-usama.arif@linux.dev/
- Patch 2: use the existing folio_contain_hwpoisoned_page()
  rather than adding a helper that scans every page of the folio
  (Lorenzo, David). Only skip batching for anon folios, since
  falling back for a freshly read folio frees it with the poisoned
  page in it, and the retried fault can get the same block back.
- Collect the Reviewed-by and Acked-by tags from v1.

[1] PMD-level swap entries for anonymous THPs:
https://lore.kernel.org/r/20261002095503.3585565-1-usama.arif@linux.dev/
 
Usama Arif (4):
  mm/migrate_device: avoid leaking folio references during THP splitting
  mm: don't PTE-batch a swap-in of a folio with a hardware-poisoned page
  fs/proc/task_mmu: don't read young/dirty from a non-present PMD in
    smaps
  fs/proc/task_mmu: account device-private PMDs as present in smaps

 fs/proc/task_mmu.c  | 12 ++++++++----
 mm/memory.c         |  5 +++++
 mm/migrate_device.c |  7 +------
 3 files changed, 14 insertions(+), 10 deletions(-)

-- 
2.53.1-Meta


