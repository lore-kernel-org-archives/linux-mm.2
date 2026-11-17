Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14CBA606A337
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sB35Xv3E
Received: by kanga.kvack.org (Postfix)
	id 1BDA96B05BA; Tue, 17 Nov 2026 04:34:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 194A46B05BB; Tue, 17 Nov 2026 04:34:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D2386B05BC; Tue, 17 Nov 2026 04:34:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E37156B05BA
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:34:13 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A9F81C3A83
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:13 +0000 (UTC)
X-FDA: 85444099986.01.0F7CF8D
Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6F9D440004
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:34:11 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sB35Xv3E;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.239 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=t8qxZbn32Z12Fq2RQjI4glAnxZTD45cKMGLss9aFThM=;
	b=0CW4lin+Yp8WUcAvDu2ayxEvdLjAIvE40/SPvnkRgJd+S02qxMslupoziiayyX3XK7yXAE
	MyeYYydsfTvCX9PFI2JBRIWrxsYUUbfRIhaA8XE7b6YfAncOkaroXmErZJrO5VvKDuRwPg
	7gQilQpFFKDWYGelyCeHMANs/apEDH4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794908052;
	b=ipPC1mhtbCYbJNKXhBR5xthutkI6b4XM0bxlBB6/+jH4DuKADAYH14FNfPYAtw5JGFZgTh
	VhmYx7yIYGRk6cVZpNeyB85/TjC5CkQWoWUKdGVmeCrGFFNA6wMIDu+G1maUsAQAnqGakR
	oo1g2+LCfEnDZDxXMyEUR6VrMc2Vrg4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sB35Xv3E;
	spf=pass (imf17.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.239 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Bs39wPf+S0CB3Kx/RBYWFTHto3XWIFtM1LpZ+jEOpBw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794908049; v=1; x=1795512849;
 b=sB35Xv3Ex56vU1lX54WsCiJP6eEKywd4dviJU/jbjQ1TBsKupp08fIXohBljSflYSkd9QiCT
 wt+hkpT9PlA+bYTb3R8qlgtNiZa45wYv7fSB5UvKJrF8m9lEQUw+VWqK3fenWcIlfd6LlBy2qEF
 PHWKQhhODEf659dGdDBzxbbU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 34837426e6c7ea91;
	Tue, 17 Nov 2026 09:34:09 +0000
X-Mizu-Trace-ID: 34837426e6c7ea91
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev,
	fvdl@google.com
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 0/3] mm: hugetlb: fix CMA-related issues
Date: Tue, 17 Nov 2026 17:33:56 +0800
Message-ID: <cover.1794907279.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F9D440004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: m8bt5ccz5zonzafdxi9b9wx4q3hotqxk
X-HE-Tag: 1794908051-361302
X-HE-Meta: U2FsdGVkX1/sq0GKeCDm+AmaJjr4/MBxh3UhjL4mJMq8p0ob2c7gBfBZcwS4knHu73dKPPmEje8YWqDLrTks9A7mJoKqAenDC0XEyfLKruG5k8swsWBbh/L9p8/VFKn3v+80ipZBNpyAZ5okEmD8dq6ge+b+qoaLzRD7uPVgonTX608xow1zTMEtImFgiYI1GqO7ffW57Fx0iTRy6BNuMOVBLdccvKCTcYthrTEEyfUU5Bv9ClOHjXzY2nkGsAqZhX67c8UyvZ6F91tLmbJB0oFzy5YdeKbg+t4T5CcHHQMyfDisnIUMoGYC3v+nHKKOz7aZkAxKAJLq2mLOlMpJQLQVtv/2nN2W21eLd6SQ/neztIE0yr904chUE4Ev/YY7B6wYmJwkc+oDl2OTYW0e7ZU1VLpvnwBiKkv+BjYabbu2+J1peYmLvekatxRIdmw/Dyi+UDQ3qsDXb9rpvYSLBa4bmLoXkOXjI1WTJ64+hmh2D97fpdu6UOUP8Hkppigq3126jAktOXYKw0EnduqGMT8+tqrRvVBk+gcpO8uDB52aNaQYyYulMO5LrwSJQUD2KAmySCjgMmC2nG0lRCdFskG8ntYYuTkUs4KwvAmqheMfp8x/IrY//jq6j871xriBFmzZj6h6e+DojwnoPNl10mS6fQJeZdUrAuNR8Fnj71e/VWtXy6Du1p6eepx//2kD40qbRGLWUf6TVNYEE43VKc98x1/Pq1sYamFy+LLBajg1tglqYCLR25jWa8eozpZTvx+jvhtnpktCRaCDiwFK8v/A7Pr9uYIY/A0uJnEC7pbhft1e1Ky+2yuqIzpl0/xEJFbaO7TFqsP8tHwA35fQOsYR3kJ5umHzC9LB7N8ujtmJpRqJ4MzP5A1ygMgQYcjXDan8oIAjz0uEq43mkO9ALw8QMQ24JBd+AjQUluYRSOElOGUvRc4l4X7kAe4BVc07lieiSlVY71jC+7T87ll
 1DewwfPN
 Ct+VdPYZJpRUht4FBoZ248fPSdiK7pnouE3yW9AYSYlQ/QAcdu8p2jV5cGQNb8/WLaBE0svRH9tQhO/2qZ5LPJkdglUlO3kWD/EzsWTyDsHWG/amKTNjod7YrN5fcXegMWpYBOCL2yiSarZK7ppCKO4egF8pmvmtMddJzQvBsGc7yAJkAj2msNDdr47NK+H1KuKq8LedbN8+y8byFdjVDeEPgOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

This series fixes three CMA-related issues in HugeTLB reservation,
long-term pinning and allocation:

 - Avoid ineffective CMA reservations on 32-bit x86 kernels running on
   CPUs that advertise 1 GiB page support.
 - Allow long-term pins of explicitly CMA-allocated HugeTLB folios,
   which already own the CMA memory.
 - Preserve the caller's GFP mask when allocating from CMA.

Changes in v5:
 - Move the HugeTLB CMA ownership check into
   cma_folio_is_longterm_pinnable(), keeping folio_is_longterm_pinnable()
   inline in mm.h without a HugeTLB header dependency.
   (suggested by David Hildenbrand)
 - Clarify CMA ownership in the commit message for patch #2
   (pointed by Muchun Song)
 - Rebase onto next-20261116.

Changes in v4:
 - add comment to cma_alloc_frozen_compound().
   (suggested by Oscar Salvador)
 - collect Reviewed-by tag.
 - rebase onto next-20261110.

Changes in v3:
 - Drop the cpuset fix. A more comprehensive fix across the HugeTLB
   allocation paths will follow in a separate patchset.
 - Check for __GFP_COMP instead of adding it in
   cma_alloc_frozen_compound(), and leave __GFP_NOWARN to callers.
   (suggested by Oscar Salvador)
 - Clarify the CMA ownership comment in folio_is_longterm_pinnable().
   (suggested by Muchun Song)
 - Collect Reviewed-by and Acked-by tags.

Changes in v2:
 - Replace the PF_MEMALLOC_PIN allocation restriction with a GUP exception
   for HugeTLB folios marked HPG_cma. (suggested by Muchun Song)
 - Pass the caller's GFP mask through cma_alloc_frozen_compound() instead
   of skipping CMA when direct reclaim is disallowed.
   (suggested by sashiko)
 - Remove unnecessary revalidation of successfully allocated folios after
   cpuset changes. Retry only failed allocations.
   (pointed by Jose A. Perez de Azpillaga)
 - collect Reviewed-by and Acked-by.
 - Rebase onto next-20261104.

Thanks,
Qi


Qi Zheng (3):
  x86: hugetlb: disable default CMA reservations on 32-bit kernel
  mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
  mm: hugetlb: fix GFP mask propagation to CMA

 arch/x86/mm/hugetlbpage.c |  2 +-
 include/linux/cma.h       |  5 ++++-
 include/linux/mm.h        |  9 ++++++---
 mm/cma.c                  | 21 +++++++++++++++++++--
 mm/hugetlb_cma.c          |  4 ++--
 5 files changed, 32 insertions(+), 9 deletions(-)


base-commit: 749a4de370409464cf8501ec5b2451df45c84eb4
-- 
2.54.0


