Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8CF0C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 10:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B65F66B00A0; Fri, 10 Jul 2026 06:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18F06B00A1; Fri, 10 Jul 2026 06:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A05D36B00A2; Fri, 10 Jul 2026 06:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 829C66B00A0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:56:19 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E7EF7C22AD
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:56:18 +0000 (UTC)
X-FDA: 84972562836.02.4D54972
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id E0082C0004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 10:56:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GMDNp7E4;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783680977;
	b=c3obB3nORmtQuKSGFR/x+HO/R7j/V788GRsmC9QCmyL++EiXQLhKgJqyopu81M7axLh1OS
	mq7Uqqm2EUQOgrxfi9pLnYi7yIruXdBlBGhYFEyeIzb3KdXbhwaEndqc2rS7SRG8C3nEzx
	YQ2O7L+Y4Jp2gghgxgLs+fAG1hqzijc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GMDNp7E4;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783680977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eWvY20kWHieMA6+11z4cDiGGKYfy8NYj5myuJ6b5p2M=;
	b=KrGFVh5zPSgZCyB83wETQiqLEE1tl1OPmnLkOt9U14TS6OdgalsEvNJZGkvoKdeEU299mD
	pR526tRpcdqkIq3yeUS5OwlPdnfaDpK+6LF6vTAcfzWZ/FK7CZhMULkPw582hYwBMOplqg
	IMwq36xP5tbHDYZ1yOxaZeEX0ZuS+04=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783680972;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eWvY20kWHieMA6+11z4cDiGGKYfy8NYj5myuJ6b5p2M=;
	b=GMDNp7E4For+Kybdkgwx08aUh3OFHXLN7F7uo2eMp8sQI0HY817TzzzxUfUxtIkan7NZaC
	b6tmXAsO40mSRDdaJiT/lkt/q4MMFlzbMM+BfX6q2rorPXm4h2lr+cVYPD+M+C6/CKLuAA
	SlJ8tfq0tyi3i5rvUTIPIOKgbwGaRVg=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	npache@redhat.com,
	rakie.kim@sk.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH v3 0/3] mm: handle device-private PMDs in walk callbacks
Date: Fri, 10 Jul 2026 03:55:20 -0700
Message-ID: <20260710105557.1987433-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0082C0004
X-Stat-Signature: dicfgxu64yem8jf746z31mku65xrxsqi
X-HE-Tag: 1783680975-622160
X-HE-Meta: U2FsdGVkX1+OK4miY8PxUUnR9mZQLwmkfnt9Y9tKJczEi2VMaEzOZRmP710W831s5MPZ2d02AS8K2t+PoKQZIVq7359pQE2aEBf+BF7CEQKp49Mh590ciytMngiS2gitV9glHLprvRe3oDHJt7dRRySq0aVbgBtYkvhAxt15cGV1lA44ISlBuI7HHmTeSByDrUK6z0ueZRO4DC1Og2vnLW1LovPT9KwIw/FCfSW1awWOYjDQu3jvL9845kl2Ok5iqy848tosuyaw0jLUgfLnRgOuOSywko2OuUUm40UPU2iNeXA3HNptNtsWohUmyhOLR0UBVuRbNRc4aLEN4ZPeeHbDm8a3AZGim1gwM2yoEq7U731gd0j4iikf76jUxpaejArjMHMyLw7MNykprX1+a85HK/eI+SP04HAeZlESull8TkRrxnbAuGU2W6ENieY6YmzwJJkWa4L07JdRKfC9wOwcaxzakM8hgOs4vBRvXUFd8tyDCdDMbTgyfiYCRZlrAU7dljcWlIoNf5Bs1W8CTLit51NwY+Svrj1wTgeh1X6DKnX0JgI10jchzMHbBtf3no3/+ykpxLadUexOvJy2t6yGR7QDTTjRipiFgBH1RxZTUQszEz12qOZutBUF6UUSDbouo3m6jQgMBDh92Dj4eoYpq/KBMMvbbortKWMbjvqkXtee0XV9T/+RsEinuB2i1mrCw1Zsz/iOstVCvK+DbXP0wzRKU5vnGC8l91alYZffTZX8F+0MhDlluEnTdQCPB9HRTjoyvGBAyQcHy/pzsMHhH63FISbaIG8xb14gD6ghWjpm1djaqQ01bNPrS7R40Ldut8ZNPqbZSeuEUpul2xOcrjHTlE23XZ4BfXX/FMzdZVyNlRLq/x5g1o2VflJ1T/y0U9V5T/XdB93wb6cgmozze/DhrNHl0dSsvlvyeVrN1gwoSlMsd9r5WLy0aMXuS4+wazAayjRS9J2jV2n
 vNXwWhor
 Dnc2wWWAtmMfRk7RFuWwwUpNyaSRt4W0v9CJGqPwIW+lHyYUMBrr3UhkL9YZst4FCEeCEih81Sn6zJJ0ME2fdKQA3yef57a+JHIJH4IapEKnL38EN+eJHvN01Xx1TLETZKzu4M1dX6OR+D+QmuuiH2OjIC0x7hyZm60dqgFJxVuhjBVuJo99ZdRd8BuBhK7eNtGalX2wamDZ5GZ7fVlwS6tvymetzDpZeu1DiM7KMNaOCrHJ7eKZpr0L3mMXjOqr4fsEOTorJHzFCWbg8ee1efivNjR9WGgUiIAi43+8KFqY1Pxo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
to PMD operations") a PMD may hold a device-private swap entry whenever
an HMM-based GPU driver migrates an anonymous THP folio to device memory
via migrate_vma_pages().

pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
for any non-present, non-none huge PMD), so several MM walk callbacks
that used to assume present THP or migration entry are now reachable with
a device-private PMD. The results range from a VM_BUG_ON() firing on debug
kernels, to an oops on a bogus vmemmap dereference, to silently isolating
an unrelated live folio from LRU in the aliasing case.

---
v2 -> v3: https://lore.kernel.org/all/20260708122040.861335-1-usama.arif@linux.dev/
- Patch 1: use pmdp_get() instead of *pmd. (Zi)
- Patches 2 and 3: drop the thp_migration_supported() guard and
  downgrade VM_BUG_ON to VM_WARN_ON_ONCE(). thp_migration_supported()
  expands to IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_SOFTLEAF), and both
  pmd_is_migration_entry() and pmd_is_device_private_entry() already
  return false without that config, so the guard suppresses only the
  case where the warning would already be silent. (David)

v1 -> v2: https://lore.kernel.org/all/20260707135255.292870-1-usama.arif@linux.dev/
- Patch 1 now gates queue_folios_pmd() on !pmd_present() instead of
  checking only pmd_is_device_private_entry(). This matches the PTE path,
  keeps migration entries counted in qp->nr_failed, and skips other
  non-present PMDs such as device-private entries before calling
  pmd_folio(). (Joshua)
- Patches 2 and 3 now fold device-private PMD handling into the existing
  !pmd_present() VM_BUG_ON() condition instead of using a separate early
  pmd_is_device_private_entry() check. (Joshua)
- cc stable (Zi)
 
Usama Arif (3):
  mm/mempolicy: skip non-present PMDs when queueing folios
  mm/madvise: skip device-private PMDs in cold and pageout walks
  mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd

 mm/huge_memory.c | 4 ++--
 mm/madvise.c     | 4 ++--
 mm/mempolicy.c   | 8 +++++---
 3 files changed, 9 insertions(+), 7 deletions(-)

-- 
2.53.0-Meta


