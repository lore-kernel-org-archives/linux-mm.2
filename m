Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 592FF1098786
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 14:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA1B16B0096; Fri, 20 Mar 2026 10:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B799D6B00AE; Fri, 20 Mar 2026 10:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A414E6B00C2; Fri, 20 Mar 2026 10:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93EBA6B0096
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 10:04:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 562D557356
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:04:30 +0000 (UTC)
X-FDA: 84566611500.01.B8A7136
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf02.hostedemail.com (Postfix) with ESMTP id 879308001E
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:04:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ju2NswDZ;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774015468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9emof/mSVBpZqOkniGYRmgnpg6b0NvSs2UalXz8qvvw=;
	b=EOIQX5zYRHabvM7s8y9eQn9d9Y8Ut37nPDoHgvrljuOCj2QB0JQ2PdVcSLlDNoG6TZ/7Vv
	IvSVwrq+fnHBuHSB0B/3qQL4AE1SGEY1rAxBczoIEeL/pMGDicbqcCky/CyFo1C1ZwTla9
	vFM6V5erGXDjMvMcKjuB4ZGBqZi0e9s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ju2NswDZ;
	spf=pass (imf02.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774015468; a=rsa-sha256;
	cv=none;
	b=ZNEm5jq9bePMBxJ/kP/bvCsXT525EpnQRJLU+tu0+L/lGOAsd/aXiGixH868xUMFkezrkI
	y3JrptEsVpaTP6L5jpqlY0ZFFF9JzAdlGvlcRdq4MwWNegWgOVQfOs7L2G1uzsmmVZGpIb
	6PN4jsNSMZk8JeMsOs4FWlt6L/aqF3g=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774015466;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9emof/mSVBpZqOkniGYRmgnpg6b0NvSs2UalXz8qvvw=;
	b=ju2NswDZNmjBWaAbqAUKq99Ame3jEQiyp7S3PHbaCVpSky1q0JH1sNT/whD+G/JXIaBNJb
	+Hexql1DGIbnnxSaeS0g6QazyGPdqSFYQnbeDbLItd0uV5MvgrYfJOzQOUhe0lg4oOpp1h
	cNiVUgqf28HsJvc4ZX9wsrGKXv98dok=
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
	linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com,
	mhocko@suse.com, npache@redhat.com, pasha.tatashin@soleen.com,
	rmclure@linux.ibm.com, rppt@kernel.org, surenb@google.com,
	vbabka@kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
	wilts.infradead.org@kvack.org,
	"linux-fsdevel@vger.kernel.l"@kernel.org, ziy@nvidia.com,
	hannes@cmpxchg.org, kas@kernel.org, shakeel.butt@linux.dev,
	kernel-team@meta.com, Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v2 3/4] elf: align ET_DYN base to max folio size for PTE coalescing
Date: Fri, 20 Mar 2026 06:58:53 -0700
Message-ID: <20260320140315.979307-4-usama.arif@linux.dev>
In-Reply-To: <20260320140315.979307-1-usama.arif@linux.dev>
References: <20260320140315.979307-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 879308001E
X-Stat-Signature: x836nrjchn8jf7mgi8sahxjbi1qq9s3r
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774015468-749543
X-HE-Meta: U2FsdGVkX1/C9lkKuu3A1IdvIJRLlcBcHnctKv63KDEVXhWm9Nvts5jJUAbTlYDQAABQM2zgz/Cw/TFRgtUEFgbNMrxf8yK86eDgrr5SZ8ZJTJg9zWd19pMaTVtiaGhSj91laRbTM+GNITibNZAeo082i7gEkgDHTwPob7Oi4/CiDBEOiWUcUCqKz+fMR0cEJsG+Vv13KJRtFN1RcZ0JXRuvkr67z4Vzvvi9t+gAc0GguCcHvKskVTUtWijaXOhJNgSpV9m/bmq/jQTBY77tyBNeqQ8kNhuK6STE4mAldVVq/j0si9ADXcJvlFEy9y66J855TEExR/ikBkY204fdIcddoS9pTdcV5d05upJU3ZlwkZDJxm1ivjC8Us+eL6LRTAkICBA87D6dmTIYiexH6PDGHSIKX8xzk2yIohbhtaHv+e4C6htXcySw9OuBTI6EuqRRTq6DEyTcicINl6LvJRUrr3st9iM2I8SFlZ2FMobvO4aNWJUkIU0dvnRtI13clbmtAZ03+r2iYxMq3kxFImSwOgk92mbnyYShZYScEB7AMZSXrXI1OK7w9wRVcl3dkfoVZu88gfPUNdxuIrKZxwH/WgN3Il5+nMhXdRN7g8Ms6Nl423DctMdab2PypmIMal138SyPuJ+hx0Hsr+fSrHnmS/pOTRDgQ2CrL1zfK4v1J+3PCuF/i1nEqZQ6r+kPv9SV4adhrHnyq04kBuUCoyOCuVlWp5F0OAqJiGOkMvpFtY8xst/qKBGG0HNoTkDmEoKRAlEZFEXkYamBTHoU2kavN0OM2I4DmXRcxD9jxhdpuFyjeHDYY90L1zK5/ULezoqAx/EEVEN8329wyFbeOWh5cZeUn677Mnf3rURuU0ymTU57bltR0DBp7bnIXYIlE8znIviUPPeEDnLMp/pS3ar0Ofj1dJUv0V36Mus8qRa1hnGBQuZW8Arj3c5gMJO4AF5wUYD1V6gTjx8kF/s
 poW+AqoR
 +aO41sRq2X7wI18R/Rjemx4z8xaRUN/VKzNCFSoll2WoeYIbCcXaZp9LH2OaW06cDWHPc8oq5TUbJf1Az7CjLyKHlbeQ9Yb5OK/SJVIzL8Vd+5mpz2+Qq51zXEt70ToEbQF+P38FKc0gHMr4UumB2GFEawPf4yxLtykyak6Qpo4XOLRNXXuCTshx8iV6imFPqOcEr4l7LUwl/zkjr23L/kg7nazuBSLscXSdqBmhHMCnf12mr/iFO7TRfpw==
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
allocate 2M folios with 2M-aligned file offsets and physical addresses
cannot benefit from contpte mapping, as the contpte fold check in
contpte_set_ptes() requires the virtual address to be CONT_PTE_SIZE-
aligned.

Fix this by extending maximum_alignment() to consider the maximum folio
size supported by the page cache (via mapping_max_folio_size()). For
each PT_LOAD segment, the alignment is bumped to the largest
power-of-2 that fits within the segment size, capped by the max folio
size the filesystem will allocate, if:

  - Both p_vaddr and p_offset are aligned to that size
  - The segment is large enough (p_filesz >= size)

This ensures load_bias is folio-aligned so that file-offset-aligned
folios map to properly aligned virtual addresses, enabling hardware PTE
coalescing (e.g. arm64 contpte) and PMD mappings for large folios.

The segment size check avoids reducing ASLR entropy for small binaries
that cannot benefit from large folio alignment.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 fs/binfmt_elf.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 8e89cc5b28200..042af81766fcd 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -49,6 +49,7 @@
 #include <uapi/linux/rseq.h>
 #include <asm/param.h>
 #include <asm/page.h>
+#include <linux/pagemap.h>
 
 #ifndef ELF_COMPAT
 #define ELF_COMPAT 0
@@ -488,19 +489,51 @@ static int elf_read(struct file *file, void *buf, size_t len, loff_t pos)
 	return 0;
 }
 
-static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
+static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr,
+				       struct file *filp)
 {
 	unsigned long alignment = 0;
+	unsigned long max_folio_size = PAGE_SIZE;
 	int i;
 
+	if (filp && filp->f_mapping)
+		max_folio_size = mapping_max_folio_size(filp->f_mapping);
+
 	for (i = 0; i < nr; i++) {
 		if (cmds[i].p_type == PT_LOAD) {
 			unsigned long p_align = cmds[i].p_align;
+			unsigned long size;
 
 			/* skip non-power of two alignments as invalid */
 			if (!is_power_of_2(p_align))
 				continue;
 			alignment = max(alignment, p_align);
+
+			/*
+			 * Try to align the binary to the largest folio
+			 * size that the page cache supports, so the
+			 * hardware can coalesce PTEs (e.g. arm64
+			 * contpte) or use PMD mappings for large folios.
+			 *
+			 * Use the largest power-of-2 that fits within
+			 * the segment size, capped by what the page
+			 * cache will allocate. Only align when the
+			 * segment's virtual address and file offset are
+			 * already aligned to the folio size, as
+			 * misalignment would prevent coalescing anyway.
+			 *
+			 * The segment size check avoids reducing ASLR
+			 * entropy for small binaries that cannot
+			 * benefit.
+			 */
+			if (!cmds[i].p_filesz)
+				continue;
+			size = rounddown_pow_of_two(cmds[i].p_filesz);
+			size = min(size, max_folio_size);
+			if (size > PAGE_SIZE &&
+			    IS_ALIGNED(cmds[i].p_vaddr, size) &&
+			    IS_ALIGNED(cmds[i].p_offset, size))
+				alignment = max(alignment, size);
 		}
 	}
 
@@ -1104,7 +1137,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			}
 
 			/* Calculate any requested alignment. */
-			alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
+			alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum,
+						      bprm->file);
 
 			/**
 			 * DOC: PIE handling
-- 
2.52.0


