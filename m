Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DEB5606A32E
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 04:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=h6bzdrvm
Received: by kanga.kvack.org (Postfix)
	id BA71C6B05B2; Wed,  4 Nov 2026 23:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57D56B05B3; Wed,  4 Nov 2026 23:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6D756B05B4; Wed,  4 Nov 2026 23:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 82B406B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:08:09 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72008C090B
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:08:08 +0000 (UTC)
X-FDA: 85399732656.18.D3AAECD
Received: from mta0.migadu.com (out-12.mta0.migadu.com [91.218.175.12])
	by imf26.hostedemail.com (Postfix) with ESMTP id 706A6140003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 04:08:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h6bzdrvm;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.12 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793851686;
	b=CNjS8dOQv9xtrTYvhPT2vD827Q3EaKlfmjJrE4UwaSI4WMwVLdvdvOUUZzwAfdFog3THsF
	Wc5GNZTqJkJ0fz2YFEXW3KQxDwlb2tjWuuQHHRW1ZQldV92DrtNlZl2127yIAsQw1YtlID
	HYqwLluTn/b/tTpIdBMH8+AuZonzyyg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h6bzdrvm;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.12 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793851686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NDjRE08wBO6pV06Ou8hAMmC9xnZwvIAddVeS9T1njfA=;
	b=2nAKWIRru14fH+BPYlRI4pKMockPL8lirYoFsEsAkaFifaPyc68Fq66G5+RL75iQrjXqyc
	nUJW1/uv/18l+YZNy2eHikiIa4e8QC1KkurzW42/9CvMwbKLAmkitydtb7wJFTDIk30p0N
	epGObdrsOLNs6gFDVOSj9YUmc1PPPko=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Dpp0QW6dxtIsgsNrKwbD1Rm5WJVVVno7NqsqAW1y3b8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793851681; v=1; x=1794456481;
 b=h6bzdrvm/Ur0kv8vbffG2xS34Jim0MONoZAaiSfCMoP9t+dVQz4zUTEF54fwZ78dSJvhBncK
 QIdn7FAGic2YhO2wZaXxdhx3ZqbPK0+wERxy7YPaxfOCfKjXiNeWsBIymcoOe4RTuTBlMSzNUrj
 TTs6TD25LbuPBJmaBEcVVKBw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id aab9737a8e26880c;
	Thu, 05 Nov 2026 04:08:01 +0000
X-Mizu-Trace-ID: aab9737a8e26880c
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
Subject: [PATCH v2 0/4] mm: hugetlb: fix CMA-related issues
Date: Thu,  5 Nov 2026 12:07:42 +0800
Message-ID: <cover.1793850539.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 706A6140003
X-Stat-Signature: qi3h9uzo5wcjypx4jff8s5b8n5suqo3m
X-Rspam-User: 
X-HE-Tag: 1793851686-38428
X-HE-Meta: U2FsdGVkX19asUb8c7Ip2TzFTTU0xUqL8WbvhgwlHYSNbU0h1LmfZGMbYUikppY7ypG1z0V/LyQKvCLh6FO/XPKezWjusO3vKydgbyLKeHW6gosBstmt3gGDIGR352ejd3gqIcDJDFublpP2kFvgXhF3rgFneggIPGBHciUYguliz6gIjdYHWuPxxWhfDXBY7PQEjHe8Dsusg8N2kGoyxBwr5pYZZRh+y1HL7K04WHcLNAgD/L3tYAhXBliii5p9tlyqNlqwoDSVvo+6ONlfbgcGo9Wo71NsAszkw/u9UbrHRgZoA60GNTYZrQU3sT+WSgAIojB4Z7MAA7kCrC5896tZ4B9p+K9RsBTmbIiFPPh4OzyEpy/FtROk2OY0A+X0k0QBrBguZKs0Dj46iu8yXkhHghcx5W8vYVvkc2HeNd0AQ2JA3AREuzPOn3wuSywWuHumnQmvJ04mBjsnOBsGlRCzeIk9hwaWLikvxlPSK2irv9R4JeRSTu+sJPXH0sC0+TR7IphECbmT08dWX+xT4Pfp94DGg0P9CS/FlCwjMPw3LKrD1+wdkS/nBvuIGzXsvDOU2yZrn0jOWFdHq9aYQm333KJ+fRAXJycDZvVa3DHXGtV3z3SvznOd/WsGqefSlrPyG6xX4nfFBOtGcFx7y9G/dcXWUv/PibvifQulyPcwd+wfMKhd4KRqdgvItaW2exedaIvjRKw3UWaQ+NxrDmJUxSPbVJcoIjC3z2IREcdYqeKkZZHpx4pAuLMsFnBl7qHYJaZQbni0Slw5vD7fNF/7xgKGEPnsvzSw3g1K6EwyGPceAkNUzIynau5J5m8CQ5EIzTn460FBe4qPbdzla0ZupBc3IPZlgBxEm1qpD6EZbBzsuvUbo5iK6GcO7r5c2BSJpjCi6DQsps1QCWYB0z9087fxzhycKERkXIGT7xoN5Ps0lD8hhLOWPm6Zd9A/8UQ42rlUxbam6lfkf3+
 BwegU1cU
 1pgRw+4pMvBxr8TSZhrAjyW1AQvhjBw5CtQz/XY3aGVkBBooxh3eisbkT2CgsLIOawfudzRcL2Mo5UrwZvw2rnrXGHmEC27tthwpW50o6FNs5X/0z51F3yLVZzDrYzFHVoTFQ0fO4a6VwQPS+Z4lTfP+IQqAZTjFvz7fU60dQAgNpPw9UX03IFxwAuGcc6S3rSzrsIso2jFG+BVA0KO1noUpbMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

Hi all,

This series fixes four CMA-related issues in HugeTLB reservation,
long-term pinning and allocation:

 - Avoid ineffective CMA reservations on 32-bit x86 kernels running on
   CPUs that advertise 1 GiB page support.
 - Allow long-term pins of explicitly CMA-allocated HugeTLB folios,
   which already own their CMA bitmap ranges.
 - Preserve the caller's GFP mask when allocating from CMA.
 - Enforce cpuset restrictions on gigantic surplus allocations while
   preserving memory policy semantics.

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

Qi Zheng (4):
  x86: hugetlb: disable default CMA reservations on 32-bit kernel
  mm: gup: allow long-term pins of CMA-allocated HugeTLB folios
  mm: hugetlb: fix GFP mask propagation to CMA
  mm: hugetlb: fix cpuset violations in gigantic surplus allocations

 arch/x86/mm/hugetlbpage.c |  2 +-
 include/linux/cma.h       |  2 +-
 include/linux/mm.h        | 29 +----------------------------
 mm/cma.c                  |  4 ++--
 mm/gup.c                  | 31 +++++++++++++++++++++++++++++++
 mm/hugetlb.c              | 25 ++++++++++++++++++-------
 mm/hugetlb_cma.c          |  4 ++--
 7 files changed, 56 insertions(+), 41 deletions(-)


base-commit: 8b7179210b22f8e48a82c5ceacb9d56a9c4cfec4
-- 
2.54.0


