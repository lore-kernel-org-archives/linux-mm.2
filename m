Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CD30606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 07:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=i/0E5FgU
Received: by kanga.kvack.org (Postfix)
	id 850676B05B5; Mon, 16 Nov 2026 02:13:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8283F6B05B6; Mon, 16 Nov 2026 02:13:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7656E6B05B7; Mon, 16 Nov 2026 02:13:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5B60D6B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:13:57 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0230D1606CA
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:13:56 +0000 (UTC)
X-FDA: 85440117714.24.6308CCE
Received: from mta0.migadu.com (out-208.mta0.migadu.com [91.218.175.208])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1D0EB180003
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 07:13:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/0E5FgU";
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.208 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794813235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1hTeOe7yP6jJ4PJLUPdhDcND7K7E4e0M1zKxRQII6E=;
	b=yxccEogOKPi0OdwN+o8sRS6kTFI/jr0dzGgBckELlI8CdI5yAY6vySi7peVZIM/jEF7HzN
	sw7lHdWg4x+4bK03QWGzR7RYWtrxN3fWP/OKIV76v6tbBb6rQBnHNj/fnydJ+QjDkfh5MZ
	HAI0m+cF8mZic2Ho88f2SHuXLDCOjwQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/0E5FgU";
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.208 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794813235;
	b=WtMwe1i0PW/f66l6SDHyTLfznpNVGbG0e3MW07XySt3+q+MSGzT1kGHg30BPB2GhLewRro
	5dG/ifuVxPNDcOsBdIglf6b5KsHm9ZUX3Z5Q/Sp6aUbRyBV1BScTHLBPw7ePuBbrzW5Mfe
	7vKqVikxmx/UvOrsJNNo+lQz9roJQSQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=spy9jeLw8YXOaQ6MOBiv5dZBFpPS/G4lwKbebeo0RPU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794813233; v=1; x=1795418033;
 b=i/0E5FgUNV+jOZ5pAFPftQqcUwHhD3A40dD55ehtlhiYJn2OW+ZbERWOnxZKt96wnVPKHhb7
 bvhdN8tsL/POP+SPdS+WdUQs7X5YcsUo+qyyLOH4aAHuMpHhZB7xaGFqhJhKX7NCQApD+YMpl4e
 nCEOYI1nqx0i2hHBH7YdTUdE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d04e7e5a4f33519f;
	Mon, 16 Nov 2026 07:13:53 +0000
X-Mizu-Trace-ID: d04e7e5a4f33519f
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Suren Baghdasaryan <surenb@google.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Hao Ge <hao.ge@linux.dev>
Subject: [PATCH v5 03/11] mm/vmalloc: reject an unaligned range in vmap_page_range()
Date: Mon, 16 Nov 2026 15:13:17 +0800
Message-Id: <20261116071325.263682-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261116071325.263682-1-hao.ge@linux.dev>
References: <20261116071325.263682-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zpckg1n3r4mxcq4e1ghfperxsxbipssc
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1D0EB180003
X-HE-Tag: 1794813234-814906
X-HE-Meta: U2FsdGVkX1/poPg9CUsAy1BkzXx47G/2AP/7buXXoz/zMrxkuG4znEfyvTDp7z0rpU9gwIseIzhmrnojA3bj/Kb4mgXr+E1VZLor01Lxlj0LsBW/RdNa81esxolSmv1VuFfzwqjCPzhB5Y0YKzZwqEgO00/hoEY3+kvqR2sqWlJ+M+zOWIkPrXStmz8Nvkx2v6ysW2eFLCPxatBUigZHzEtgq031sryMarXydvB5xxN6pQieN/mRazag4aia9zycp6lvXae8FG2DqHsxS2ziCIeUQaawQVFYO0ZTA/FsTVUdjhjn5N/ME+UWm14UTIZOi4jz3pdjoe02l47c6Hg5E/529tfMKNzCduMPlLuTkk+F6XVrmbuOGZsKuT75pGMsKvCvS7cvNdQiN5cLSEenOAQeUog2Dcv3PDz/WPUoVddcCK5kGUSBOQ/OPyp9GSuujLoWs9wHqQCaPIntHj1mQTdwTi6FmLKUm0sAFDq3zuLidgAbMpkdM8xmduiW+BlWrQNp0rkS3qb4SY0VHveXkLZWRvtuaN+AbdClc3645Nz2Wd89dT9iSBlKYfDbENaFrS7e/B8D4Opdz8qmrfjWixsklEDLKyo3Iw8gny7fCH9Blqxs2/rpKCmgF5X1Qh6yemr1a5kqyrV5lciM/LF8sSdoGcrBHD/yBN8AUF9t0KQHnIoMCa3baLpm36h9k8tjIfFB74yWmJwRjlnie/BrRlRbOccTucjU5Bw27VyPsIJXH9Ocqs5KEB9ar4Y5depTXb+QVrsY/eJCV3an2Mtc+vt2mXVoXEg9ZKPqq4YEFR3zdejs74WeTOKa5+frujRuNqoi8XJS/dJvRs/OMIbZTH5Qxfs4PCtFAIkEfI0iz+TK32Cqdqys7zRaTyMvSdQ65ZmszrOwLWD86C/BpjSEzdzTQuoQSfeivbmz2KQ8FyOcjaeK4RQzlO/jdC3+MQTtBp3IUIZ//qu67pGOTn2
 8A3jwNt3
 T2UyH0j6TQDn6556wubNx6f6XoAcSepEGsO83qeoIuxIDcHOfQjOsSUVpkTcXVLMNqUaJCi9lDLWjagv1Cjani7rXW6pORpsL2yVe1XPKukXBSRJ7DvpiGgz+z/0IVtFGwGs2XktYDuqnvvCPPd+8o/RBmmMDuPoXadTLPquVmsf8pHWMIT9GR2YG4PaI8dEON7NifVmD7v0aHyAY7ppjcZjRZooUl2NFQlyYNLvq4DHkq370af7BjrnCpp0PlwjUcydWEzpe7axeWs7SzfsCP9eVnKgzwxhx3tjb2dfAL8LEqLf7q8fnEG7YLJg5ufRCA8/8O1evnXkKQyAsflr5xNWiJEu9l6UtPV3oKIIjrj+2KKjV2A4XIZF/5OWuIQ1rRIAHRvQWk0gx/j5UK0OGi/ncbQ8COvEtn4m0s/r0y43mXFFI2MMJvob71g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
PAGE_SIZE aligned") put the check in vmap_pte_range(), which is too
late, because the upper levels may already have installed page tables
for a range that is rejected anyway.

The pte loop maps whole pages and stops only when addr lands exactly
on end. An unaligned end lets addr jump over it and the loop keeps
mapping past the range. An unaligned start maps the page below the
range and usually misses end too. Such a range is never a legitimate
request.

vmap_range_noflush() has a single caller, vmap_page_range(). Warn on
addr and end there and bail out with -EINVAL before any page table is
installed, and drop the check from vmap_pte_range().

Suggested-by: Suren Baghdasaryan <surenb@google.com>
Suggested-by: Dev Jain <dev.jain@arm.com>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3c0d9e69b886..a168f6f20f4f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -125,9 +125,6 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	unsigned long size;
 	unsigned int nr_pages;
 
-	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
-		return -EINVAL;
-
 	pfn = phys_addr >> PAGE_SHIFT;
 	pte = pte_alloc_kernel_track(pmd, addr, mask);
 	if (!pte)
@@ -369,6 +366,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
 {
 	int err;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end)))
+		return -EINVAL;
+
 	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
 				 ioremap_max_page_shift);
 	flush_cache_vmap(addr, end);
-- 
2.25.1


