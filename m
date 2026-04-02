Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF9B5D6AAF7
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 18:14:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B5B6B008C; Thu,  2 Apr 2026 14:14:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4329C6B0092; Thu,  2 Apr 2026 14:14:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 370256B0093; Thu,  2 Apr 2026 14:14:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A70F6B008C
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:14:06 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id ABD9C160866
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:14:05 +0000 (UTC)
X-FDA: 84614414850.15.ECD8B71
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf09.hostedemail.com (Postfix) with ESMTP id E1A60140005
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 18:14:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wZmGPz/E";
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775153644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRxmwuc22mXtXN7oNLaBJ1zevopumUc49+eNnxlzmvs=;
	b=X4jeHRRmhD9Bk0CVzzrvKJFR0Hu27B8vsROR+IMAtYfbAmanPi3dK3NrGLyiqQgDdAMWI7
	EwRHKdb13d/aLB50uc1CE7nD4MEcdblwBUotgWKZ+4a7+I46EELsWPmXNrpOW8ovp5OUcR
	CWpU5w7n0e0DeV6wAi2nl1jCLQ0hX+Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="wZmGPz/E";
	spf=pass (imf09.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775153644; a=rsa-sha256;
	cv=none;
	b=2EPG0roIEq3hi6jQluGnENZHD8LvyF6sHqGbHIjP3QG7S4ODy2No7V+xyk2eJVsLhs1JK2
	MMENGrLeeTq6fuSBRz0h0yPYCCKrF4Ra0jwFrKmIqbOXP3mB2TMEMtIeuQnsDxCplMLv+r
	F2wB2re6ydcugvnteOYlwda02WIxi+c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775153640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lRxmwuc22mXtXN7oNLaBJ1zevopumUc49+eNnxlzmvs=;
	b=wZmGPz/E3h1QCqlt8sX2GdYj4k09LPK0QNGPYb3BVlteyZONPgM/wSFv41PdjD4AUddHEQ
	oOcjHpYxQzCi1PvsfXC2bhs3iCu2FCmJtm+N1VuxurAiQtvgeWZNr8mav9sHwyKO7sfTw7
	jxGAuXnrdImExXI92M71xlZAunfPyhg=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	willy@infradead.org,
	ryan.roberts@arm.com,
	linux-mm@kvack.org
Cc: r@hev.cc, jack@suse.cz, ajd@linux.ibm.com, apopple@nvidia.com,
	baohua@kernel.org, baolin.wang@linux.alibaba.com, brauner@kernel.org,
	catalin.marinas@arm.com, dev.jain@arm.com, kees@kernel.org,
	kevin.brodsky@arm.com, lance.yang@linux.dev, Liam.Howlett@oracle.com,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	leitao@debian.org, kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v3 3/4] elf: align ET_DYN base for PTE coalescing and PMD mapping
Date: Thu,  2 Apr 2026 11:08:24 -0700
Message-ID: <20260402181326.3107102-4-usama.arif@linux.dev>
In-Reply-To: <20260402181326.3107102-1-usama.arif@linux.dev>
References: <20260402181326.3107102-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E1A60140005
X-Stat-Signature: kqdc5unxbchg9h7icm5ek61jfaq79r36
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775153643-853119
X-HE-Meta: U2FsdGVkX1/NnGt7kGUSZ5ePIJveHa7jiInnJOSVI4ZsuUDhjG2VNTAfF5X8Ek74oMgV6GXa+xI16iLHRF/iHW2kvmFbNb/ljjs7De2FOZIWedSV71DkGHSETs365jkhQ9nQaEecwOdbI99vr+g4J+bt2OOX6B8LzmYKb6ZlhrhS/xezv4J8veVv0LQhCbi9Pgm8brvRrIY840f0Mf6EXpx/jlkBp2TWeuTUZMONILs1/VAOANzAcXLz/Jv55MysmAB+zIARD8lrvvastX/yOga5HFZylX9OfQNO2RTqzvMjYWG0wN2aBYo4aYqbv8gs7kiQP9fh/B0WRPAfUpq9kg7Izy7Nbd68cx7UtREsMAFn5hbGp0+tS57v3nkVaiRd1gL1zqcS0154jCU98BzvnMzxIAtraRDQI6kgmRB9PfJPQ4IQ09AxtfJ8TuAFhzWHSqMVzUw95AdJEKYX3Ks6UIHodLTvdGW1DUQMBKdKGe301qhN+uS3BgnaSXJqy62FNGWBxMEp2KVsVFhwSQu8TcdAm+UwtgPfMRtjucyDWuiHhvAbaKtKYB0e4qEuK3Y5jp69EnIxBhv2TfRFE2ZjwsSKLbcrFGh2Z24d5kdXLpumT54r8tMfkj+tFI7uJ9R3ULRbdOOoZWUaU1mDKQnyMfnUqXxdPg6dyK7ju/mg0I1cZ24c/v68lxbo9FAqSLmRP7EcQUU90r4cTjarm0ZzJ0bXJSt9hUkPa2Jwyx1yD8pKT4Ef2g6Kwi93l9UFiOCUhDydnk/k8bAIj9Y2yL+XEZUU4VHwBk4bzMdO7synMRhLvbmhf64Sb/u1pj54pRp+gsMxZYQSsn62760kEIve6lWOVabW76U070X5A+zP/LOaBVNTe8SMnDyo4bgkPtxjx6PWQ7TwojcZcvm30iN0agbrpEcwue/lpIhwInliqf8rW1Mw+DcCvMkbqDFsaHH84cdOvYQ4xzpD8xg2EwF
 Z7E30QZC
 sUHuQMvi/W0SuVSAI+zElzkNDAWocvrkuKQkO/aDajL3oBKFk+j1QLIqp+kOQSYfVhDdarRfqLJBE4VtWB5v7zWrD6zkt+1QHoI4jvCx0va0u2TSafK6FzX1bszaN6yKOSSZV1XFPTvtNDIFpRmjggjDwA7690jES+l4MlxASwWvBxWSnHovMRmc51W3IDnhG3qb0bBlkL7N6fiV15qEjQteRGj1m+Ha9DQfAe2MaMoCqkz4h8Mz9HwCzKQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For PIE binaries (ET_DYN), the load address is randomized at PAGE_SIZE
granularity via arch_mmap_rnd(). On arm64 with 64K base pages, this
means the binary is 64K-aligned, but contpte mapping requires 2M
(CONT_PTE_SIZE) alignment.

Without proper virtual address alignment, readahead patches that
allocate large folios with aligned file offsets and physical addresses
cannot benefit from contpte mapping, as the contpte fold check in
contpte_set_ptes() requires the virtual address to be CONT_PTE_SIZE-
aligned.

Fix this by extending maximum_alignment() to consider folio alignment
at two tiers, matching the readahead allocation strategy:

- HPAGE_PMD_SIZE, so large folios can be PMD-mapped on
  architectures where PMD_SIZE is reasonable (e.g. 2M on x86-64
  and arm64 with 4K pages).

- exec_folio_order(), the minimum order for hardware TLB
  coalescing (e.g. arm64 contpte/HPA).

For each PT_LOAD segment, folio_alignment() tries both tiers and
returns the largest power-of-2 alignment that fits within the segment
size, with both p_vaddr and p_offset aligned to that size. This
ensures load_bias is folio-aligned so that file-offset-aligned folios
map to properly aligned virtual addresses, enabling hardware PTE
coalescing and PMD mappings for large folios.

The segment size check in folio_alignment() avoids reducing ASLR
entropy for small binaries that cannot benefit from large folio
alignment.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/binfmt_elf.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 16a56b6b3f6c..f84fae6daf23 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -488,6 +488,54 @@ static int elf_read(struct file *file, void *buf, size_t len, loff_t pos)
 	return 0;
 }
 
+/*
+ * Return the largest folio alignment for a PT_LOAD segment, so the
+ * hardware can coalesce PTEs (e.g. arm64 contpte) or use PMD mappings
+ * for large folios.
+ *
+ * Try PMD alignment so large folios can be PMD-mapped. Then try
+ * exec_folio_order() alignment for hardware TLB coalescing (e.g.
+ * arm64 contpte/HPA).
+ *
+ * Use the largest power-of-2 that fits within the segment size, capped
+ * by the target folio size.
+ * Only align when the segment's virtual address and file offset are
+ * already aligned to that size, as misalignment would prevent coalescing
+ * anyway.
+ *
+ * The segment size check avoids reducing ASLR entropy for small binaries
+ * that cannot benefit.
+ */
+static unsigned long folio_alignment(struct elf_phdr *cmd)
+{
+	unsigned long alignment = 0;
+	unsigned long seg_size;
+
+	if (!cmd->p_filesz)
+		return 0;
+
+	seg_size = rounddown_pow_of_two(cmd->p_filesz);
+
+	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
+		unsigned long size = min(seg_size, HPAGE_PMD_SIZE);
+
+		if (size > PAGE_SIZE &&
+		    IS_ALIGNED(cmd->p_vaddr | cmd->p_offset, size))
+			alignment = size;
+	}
+
+	if (!alignment && exec_folio_order()) {
+		unsigned long size = min(seg_size,
+					PAGE_SIZE << exec_folio_order());
+
+		if (size > PAGE_SIZE &&
+		    IS_ALIGNED(cmd->p_vaddr | cmd->p_offset, size))
+			alignment = size;
+	}
+
+	return alignment;
+}
+
 static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
 {
 	unsigned long alignment = 0;
@@ -501,6 +549,8 @@ static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
 			if (!is_power_of_2(p_align))
 				continue;
 			alignment = max(alignment, p_align);
+			alignment = max(alignment,
+					folio_alignment(&cmds[i]));
 		}
 	}
 
-- 
2.52.0


