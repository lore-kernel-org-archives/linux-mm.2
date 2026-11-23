Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22CAB606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 16:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=cCSzGCIE
Received: by kanga.kvack.org (Postfix)
	id 303066B05B2; Mon, 23 Nov 2026 11:33:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4146B05B5; Mon, 23 Nov 2026 11:33:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A32A6B05B6; Mon, 23 Nov 2026 11:33:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E7C3C6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 11:33:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1FFD540983
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:09 +0000 (UTC)
X-FDA: 85466928498.11.1946F19
Received: from mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0E95510000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 16:33:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cCSzGCIE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795451587;
	b=htIhPPymflJd7gJO0kvxYEVUkqQ13gnuRhUydM7xk/WZ0wLgtNe9tG22U7ahiEaQ9ewnVt
	Wsyg458io2J1J4MG8K25KBiLycqkHRBIzSMZviTiejeY+jyl4mHQ5oLRAc4CpCnP2OrRQq
	XM8qNZy8fg+IEtJPqYlon+wxS3KjJWU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795451587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Yxw4jJMrXMbkk4luKeDVY6n7aca2oniv7pBaMvqCZZo=;
	b=gto2t4YD5vBCr//gvkLNg37xb108ICylMoFsSTAzzZ3SLmih+3EjZULV3wDqS4bP2w2r73
	lpUJQP5DjEh2PIF4jhrjNz8QyXoStmn9zYpkhmNCibj2qWweWhMdMXnaosswpoOJrxsmWP
	aTZd1Y70JmfKWV69YEPpZMRMP1cX3Kc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cCSzGCIE;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=6YY+UofGcLZaF/R74H86RLjvpi/i0YIea2eJqVNxlwM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795451584; v=1; x=1796056384;
 b=cCSzGCIE/QjLliANYvylQEWazlGZm9EVizcQ4xXViyPxaB99uhPwmAHJ6wJ1UzoKk7HH3Bth
 FW3/DeedHockO6KXBwAI+A/ofoRvPLKtInKiis4G1wgy87EdbGEK/e97qPyxYpBApfOT0SJN6Yr
 VNyEovSYKItkcZr9WBeuk4NQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 3c27a325c15f0747;
	Mon, 23 Nov 2026 16:33:04 +0000
X-Mizu-Trace-ID: 3c27a325c15f0747
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
Subject: [PATCH v3 0/5] mm: fixes for THP migration, swap-in and device-private smaps
Date: Mon, 23 Nov 2026 08:32:06 -0800
Message-ID: <20261123163301.1568240-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mth5gaw8jphxw5sowokzxwpi3g6m7x59
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 0E95510000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1795451586-690753
X-HE-Meta: U2FsdGVkX1/9QLEqmUea8h0Ok4EaCLD60DJxyiEx5+5UTaeKoTuVGH6WkfP/MsBPliZsBj12lT0qDPyEzcpBsHCCWBsbEzMcnpbPMu3kJRO6/ctHRdPWLkmVGufAKPrnkRw0GQcMexxqecZizIkdYyBTcs8o9RDvORimScITOiv5/o2ud2QJn1m+/IsXoYbDbITM6w+itZpaisoubm+ep3qlvFy4xPSYNKEhHUKk/QA2PCxZYE2HtWFCK3MX2EE1S5UJ/uCPdLEk5l2T+ydR5uf7bqNlRPyPMngbmOt+dVQ2QF4i8k5V+mHNULDj7Jhe9BsryV5Zslq2QpdoufTZtKLc/pguMkiYIQDc9jdDDxnmwfn8ngg8d1PKxxJEQ9/5fQZlEKOG8jWl1NHGc5F+4BiZip3bn3/dhOdlttto+xspIHoCYQnpINRfXyzOm4BtvFOwG+vGSh5Tp2CbJjTeAdlEqIRLljHNWK8B8mZhHKVX3TT1+17P/lj/prmigocYMCvTbxxwgsXryEaRMvQTE3yo/XvYqKjuwr/d57ScIxDaJISl3ADyxTjTJvy9RbwoLiVFiriyHhBFV4iIv3N+3y6Rio9dqbUewQWmee/WyaJfW3RN6BXqaqBGt5a+8wCGOf3I8F9Le8vTr0voPczShoLaD2GVxD9uH8UPsiz9LZicUDh2OxsgUaNos6MFexR73p36ple7l0h1dSTuc/caAN/0Nv6H8/RVJWFeFCJzV09an5C6/ijnnv0TNCXbR9/+Cs3I5ys+xkswAOCfzre6+yfuuvmqrT+tg+S8ayzh4Z3Ojjw43zoPanx1L1yd4Rh+l3BqejVMRXNExVjVwkBXo6+7GXMXA5xVd47TXnw8q32gPjoAm8mtoCG8R+ajPV3RRNjx/td8Wfhc1VRSZo/NWn/RDKlNOhCIzJB9wVT4rr++qmtGA/h8x4YuU65tWoIldZWSA2D224pmVlQAteD
 0+AANfqn
 0PdqEuEbwbs0XpeFlkcRpzlrSM1XaJx+0Hx3+PCyReIsGJWafHkisMXWiFbmCbJY9iu7t0A8hcIgyFxG0w2Z+lzAp2WWuBJiGEOS6r5VEy9EgCPt3SIvbf64cixsoG4slcAQ44JDumwkeeXS5SlG+NFuWF/9UUPqZNLtz9WH2BvVLZP44OYFcLGF5CDJ8qltv/C4pXKhxkuSSkfO1U/QzB07G6w10hHkaw4iYurS4UkStAxHlMNRjwu4a5DA7sUuIxOJKlIDScfNrUD+2meDIPaoisV3Y41cmVl+ISNUs1MuEGqHvWAC7VFbU1up8cJ/8gQHia63UMi8atQGy+v5qgZT8drnhzzR4a6h0KV02lYgHXfvJCgDOH40xZKXBWgwHxrTuO/h6aE9KfEmlipcSvDEhfgqLCVLFpNp+JixfwHee6Xg4NIOfmc4ps94u9qW/37gubWQpyrGjuIu0HqA5xqmBg80GiCpqQWZq8QEuM2v6/fd0W+cU0T84DuNNTALSsD6Id839nm4mw1f40Q0s1eTy2HZeX/rchyYB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

This series contains four fixes for existing THP migration, PTE swap-in
and smaps paths, plus one cleanup. They were extracted from the work on
PMD swap entries for anonymous THPs [1] and can be merged independently.

1. Avoid a folio reference leak when concurrent MADV_DONTNEED clears
   or splits a migration PMD before the device migration split helper
   acquires the PMD lock.

2. Prevent PTE swap-in batching from mapping a hardware-poisoned page
   of a large anon swap-cache folio.

3. Read the PMD once in smaps_pmd_entry(), the way smaps_pte_entry()
   already does. No functional change.

4. Stop reading the accessed and dirty bits out of a non-present PMD
   in smaps, where they encode the softleaf entry rather than
   accessed/dirty state.

5. Account device-private PMDs using mapcounts in smaps, matching the
   PTE path. Shared mappings get proportional PSS, and exclusive
   mappings are counted as private.

This applies on top of mm-new (87cdbd9bd631).

v2 -> v3: https://lore.kernel.org/r/20261116063624.1382944-1-usama.arif@linux.dev/
- Patch 2: move the hwpoison check to the top of the batching block, so
  the two bit tests run before the page table scan rather than after
  it (David, Zi Yan, Kiryl).
- Patch 3 is new: read the PMD once with pmdp_get(), so patch 4 only
  has to move pmd_young() and pmd_dirty() under the present branch
  (Kiryl). Patch 4 is unchanged in effect and keeps its v2 tags.
- Collect the Reviewed-by tags from v2.

v1 -> v2: https://lore.kernel.org/r/20261111113904.650722-1-usama.arif@linux.dev/
- Patch 2: use the existing folio_contain_hwpoisoned_page()
  rather than adding a helper that scans every page of the folio
  (Lorenzo, David). Only skip batching for anon folios, since
  falling back for a freshly read folio frees it with the poisoned
  page in it, and the retried fault can get the same block back.
- Collect the Reviewed-by and Acked-by tags from v1.

[1] PMD-level swap entries for anonymous THPs:
https://lore.kernel.org/r/20261002095503.3585565-1-usama.arif@linux.dev/
 
Usama Arif (5):
  mm/migrate_device: avoid leaking folio references during THP splitting
  mm: don't PTE-batch a swap-in of a folio with a hardware-poisoned page
  fs/proc/task_mmu: read the PMD once in smaps_pmd_entry()
  fs/proc/task_mmu: don't read young/dirty from a non-present PMD in
    smaps
  fs/proc/task_mmu: account device-private PMDs as present in smaps

 fs/proc/task_mmu.c  | 21 +++++++++++++--------
 mm/memory.c         |  5 +++++
 mm/migrate_device.c |  7 +------
 3 files changed, 19 insertions(+), 14 deletions(-)

-- 
2.53.1-Meta


