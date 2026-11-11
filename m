Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 26B5D60A6F72
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SUWGwlkL
Received: by kanga.kvack.org (Postfix)
	id B3CAD6B05B8; Wed, 11 Nov 2026 01:47:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B14446B05B9; Wed, 11 Nov 2026 01:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A290F6B05BA; Wed, 11 Nov 2026 01:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6396B05B8
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:27 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 190BC801EE
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:27 +0000 (UTC)
X-FDA: 85421906934.19.0128599
Received: from mta0.migadu.com (out-247.mta0.migadu.com [91.218.175.247])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0927BA0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SUWGwlkL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379645;
	b=TMvNQLnKFoEfKRmsoHKcQFXh4G4Z/zHNGAwjrzAGzgG+54S1FN8ZZ+Pezjnm7d7nT60ddH
	qI7S79ngl8CH90vbwglbK5FwYlabzWKhIHd2u5qock2R7c+mUXPST/QEIBW79IcXRqKdz2
	x9g9KrKMpSNEonn+QcCS0tsew0uy15M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2K5Lo5CC0BJazFf+COtM6z2jABCzILHmwB0Q0hAmwAo=;
	b=OUoUkCiDi8VIVYyb+e/xc5OTT7wTvjshQmeRSKW96hKiwAYzaGw6JztFaMrCdxUxPKXh1K
	a+uBiV0/LgZABxcFVSrjGYecR2Gn2OfRYuwabYq6BYy2hWxx/TO/aFLcvlWo5aqK4wp8dL
	z+4JNDWjeEZpd5zxovzyrdFKeHw9l1g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SUWGwlkL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.247 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Zhr+OZCIJ+rG7prkwF1NKaUKd7dwOdP2HKtFKrke94Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794379643; v=1; x=1794984443;
 b=SUWGwlkL6ZDFRJe6894EcZFQYnKd4hGK88rCP0v1R9QJBeD/khVFLxwEplhrQpP7cDrYv8up
 iA7OHKhsGGgyIS3+o5eZxfQ+n5jcNAT0nsFn6Qy6SZkMqgaQLs8ox2o2mlHqZSJRzDX0Af6Ql/s
 QlF46bGd7w0KE1h6OQlqzElE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c58a145eb21155fb;
	Wed, 11 Nov 2026 06:47:23 +0000
X-Mizu-Trace-ID: c58a145eb21155fb
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 0/3] mm: hugetlb: fix CMA-related issues
Date: Wed, 11 Nov 2026 14:46:49 +0800
Message-ID: <cover.1794379433.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0927BA0003
X-Rspamd-Server: rspam12
X-Stat-Signature: ubb8bc9tw4uww4sxd4j6kt5pw9a8xobe
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794379644-678426
X-HE-Meta: U2FsdGVkX19KIc33aFVIZ4xjIjiV8cMoryBRkzDE+MZ9+CiZbmUgD995kBPh1Z3tSMLHpDqQSAi7j/WQn31uhEmAUKB27trfdxqSIpJcGKJ5s80864I4EPZKavl3COcrhIRd81YIPzc5XwA6qusjdPIFhon/w+dZqfn1GYGyaOHjDBCju0s31zM3E4cmJXJLba8UnfS61xM7/qJso+lNkax7tpgFS4NYjtQ+3Gsd3iOxcYONxAMISPqGetl2lX1bg6h0qwC5qSayoTnrMQnSfRF7p0HjLo1jycKRkRKlFB+XTRJkJzz0sIfmawqyAkHsEShGH6bHmhLGVoEL6sgQHnKuN/YIalU8wvo9wkInsY/lFTJzOCRGVxjiW00DFEWg96y9Trpe8f9C9kLyxaF1tHDoEFtS70lgG0ODKKiX6+LRvSgAW1NIGzxgvKkgSSp6Qw08p7iRY5Z8g4OgMwAGxIFW/WKX+FkI3SsRgvpvCmf3AaonJQhQHftOsPXXbCwiLB1HXDH+BMAlw0yG6gFF/+nfCfXiDbXFHIqOlg8XGlcGJUOyXccrjeUF50yzjm5lny7EnXmAr/l3a2uXkLIJ2hc5btlKoEaUnMsz6lBc8xcxs7pJoZaPNPQgzEpp0iOHuOD0QQMRABfxn3/OdYTmpV12avfu2jEuOEjj0fwGfCfvXPPQ+qg6lQRAFN3rWKt7PJEHICXj8Lzmw3omKnWQghgvQCvIZoen/S5oCSCZpTTQoeD84JtKmf59rtdI2N9BAIJpbyfaQvkrYfGtzWqgsrUuBXfjnz93CfSXo5pBRDSOPS9LwBi05I5lCYrGQjYYnlNlDxAaEDFfyjkMoo8aMSfJne/Y7P3W5gqhgmgplS2iXF/aUqtgPvi2mCaQ+oTKSzMbSBSKJ0RwlcLn1qc9OhtkFnY72eMGRHDBu6YJBhwXwA7Fm3YTYx8Uz3qm6AY7qTQSitd8w5IFUUzhHc1
 uknkA9C3
 rA8U6VaugnrzxT8tce/t6rukG8wwCQP6TZEj8+qdyKwToj/wI9UYmyshTEMG4rLQHkYycvgog25Eu5pR/ocun+TNjc9F8sBEsvnFjUbVrvQ3Ej7HqXOOaV8vQhD08mZuTy/ItB3orvU3QzFBFw7DRGB/Y7bjoeMwCJqfxlOFbXvj0v85NQnZxFdfABM58HmtYa84IDNwoYwtzUZ+CbktTXaZivRg//qOGlmRJBvC/SjdTIaSjY4sqZc+lkmftlff96RkhHrVWUnJMFhn3VPdR8mXQgQr1Jx5id6MlHYGUd1c77sODCYe1tNliEiame0Dj32GBp2KTPF7LkUJzuQXgAcsV2hqxpWQWN5fRKiZpW8qy3M6VxxtyrCGQjr25oS1ctQ2P11yyCsh2w6gXZs8L9GnW3iEKKoZU3dDaJSOief9kjHU=
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
 include/linux/cma.h       |  2 +-
 include/linux/mm.h        | 29 +----------------------------
 mm/cma.c                  | 10 ++++++++--
 mm/gup.c                  | 31 +++++++++++++++++++++++++++++++
 mm/hugetlb_cma.c          |  4 ++--
 6 files changed, 44 insertions(+), 34 deletions(-)


base-commit: 793807ca13bf3072fc6d16ce6d90e9ab9beff2a5
-- 
2.54.0


