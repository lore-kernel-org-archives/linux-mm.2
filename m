Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C91FC5937
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B80F6B0098; Thu, 26 Feb 2026 06:33:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66EF86B0099; Thu, 26 Feb 2026 06:33:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 592336B009B; Thu, 26 Feb 2026 06:33:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3CCD26B0098
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:33:39 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0B26F1B7B82
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:39 +0000 (UTC)
X-FDA: 84486397758.01.634E01B
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3F836100005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:36 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qqWTnMAd;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sEWb6ULyOrXRVye+x+KftZvBAQkL33Q0arTZiVRMt8I=;
	b=7xKR1p+DE3ZZzMGav1/qIqqur+aR9W1dk505WV9XbjinuSQKrjErRQPtKxCpg3bU25DWbu
	P3Bz4Xu2Sy2kaDgpfrwrLUskzx67AQDW+03P87tBkHPZF8HuaP5gBW+Zp7/4LFTytavMUw
	YCwqzaWDZm0c4zKLBce3EdohsLfa188=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qqWTnMAd;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105617; a=rsa-sha256;
	cv=none;
	b=NrqTddgScjqJRffJiXLSUVcgH9LNe8F/zI211uMsocpRCiT1G7iwxe1LRk3grrjAjjeJvT
	4Wdq8IBGvj4uIhTcVtqqS6hhpqTFY9YD0EdGIv5o3IJalvfIJIQb8i8pWkSMOAwc1/iMnJ
	JNucj1XhdgYX7SCLTh7im5O+E8xQ8Ho=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105615;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sEWb6ULyOrXRVye+x+KftZvBAQkL33Q0arTZiVRMt8I=;
	b=qqWTnMAdq5dg5CvpyeLbGUPbMz61dA9xpNIaerVTAxRFPXhdC6tgbMB8GUGdaSb1pEj7AQ
	+ksDSA5ARHrYo0OCNpPhXKcjyhuY8ZIczmUrM/O9mt6vELpp8Kp9v5Y2Nt8i4eNS5HVweF
	CbjSJodzFuIWJHz06nT0yacW4sZIjPs=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 06/21] mm: thp: handle split failure in wp_huge_pmd()
Date: Thu, 26 Feb 2026 03:23:35 -0800
Message-ID: <20260226113233.3987674-7-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 75jrquqyx7a5d1jr5xbcgpb1nyu1emyh
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F836100005
X-Rspamd-Server: rspam01
X-HE-Tag: 1772105616-846943
X-HE-Meta: U2FsdGVkX1/H9rType6ocLkBdlsT9P1XRqbd0392Sh3h81nUY/fsfPfgp1w8RwNbbAFvzI1xEYAmzY7OiUx4BzObDnNCJVfo2mGSZCjb60H2r3vGq3RQdtspUAdxvPaFoKUEGb4yPaWxqAtgIdkyhAwLnJr7gHCpKgkIZTNHXgxD1/rUi2eJMw/nx4hz64PFcy9+FqEwdLQOUql+lEUdayfYeAdyh6Lf5NZYSTs4Kk09c+0ZXx7wk54LRQzaJEhWQRNmexd8nUL3xWQDZNzxV1G0KNVqBzf7A9/Qx9iN0bCVcwWvlXLjA8CrgzGo6g5isx1BdS49YQ/uOAo5NElVYYc5VJt9VF7/saZB+xuQAxeOripmbgm7py0SXpKEQ9mWuagW6gyxlfeTgdycQy/PCe8GDia+OEemLrLAqwoh+AmNYO1pZu7CCw83v6UO7eMbkxEcZa6SD2TKK2+lTm+iySIccoKdcAheZA/e0o5+ReH+N5LQ6XJscydxohVYHa1dAYk5Lw6lCnnIHRI7gtibhGJ6lsM/hd1V2l/owLO3mWk7KKapyDdv4NUG2yAtrnVWDdLHVT5MllLJIXKKQLvkFvQ1CSEaYXvr/TYgvwashSj+y/XfARJsXbIcP1qHMn3RfZrs9VufaUteLlUlfJg+Z4daM0BVjz6JLYHXAUOPLvvSTgnoS5h0Clc8Dg6kfVD1lzomvUC2CdJzCem6bcOa4ra0ybpzVnPxgK9ZqHWyxC9H0zkk64z6lPjXl/jZwLHInx62mplEvqkXtx6qo/eXipnhddourm27ux9hgBIumRRwMGPWoiTlgGMAJwyKhUXRcn6focKWqw7VxC6yHxHCDkQ/h2L3rYBt00C+O0hhska13K4N9O+Qge9VAV0jUccmSxzPcTdmppBFjQrxcIxVVjGHUIVEWDJ6U5z/1JKxDY5EpK2VPt4g93OEZdA3gfnyInEVIJRyD2AwrXn+4OL
 VikBuS2L
 D7TEWVIVOeuJ0G+Kb/h9zfExuDskPfdSHze9iNbiwUpBlhVxajYPxcogdnBR07lmhE77pL8r0+PxAByc2pzWhG1GIIo2mOUd3uBlTON9CoF14OrcfTH/w24e5ZgiRpO2aNk2kyY3QzcI1VnQUTv8w5nzB1YgWNGzJzG5G15FJO2iIJGLkkdELSEUbUYATIiq2egMSymVV/o8s4QPqvBoyb3iszLBIO0TVyHg9El1shZ2b758nrR6YgzOuFbFMWrvrFDlvS04YbuLFcXeVbuwZdbJNfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

wp_huge_pmd() splits the PMD when COW or write-notify must be handled at
PTE level (e.g., shared/file VMAs, userfaultfd).  It then returns
VM_FAULT_FALLBACK so the fault handler retries at PTE granularity.
If the split fails, the PMD is still huge.  The PTE fault path cannot
handle a huge PMD entry.
Return VM_FAULT_OOM on split failure, which signals the fault handler to
invoke the OOM killer or return -ENOMEM to userspace. This is similar to
what __handle_mm_fault would do if p4d_alloc or pud_alloc fails.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/memory.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7ba1221c63792..51d2717e3f1b4 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -6161,8 +6161,13 @@ static inline vm_fault_t wp_huge_pmd(struct vm_fault *vmf)
 	}
 
 split:
-	/* COW or write-notify handled on pte level: split pmd. */
-	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
+	/*
+	 * COW or write-notify handled on pte level: split pmd.
+	 * If split fails, the PMD is still huge so falling back
+	 * to PTE handling would be incorrect.
+	 */
+	if (__split_huge_pmd(vma, vmf->pmd, vmf->address, false))
+		return VM_FAULT_OOM;
 
 	return VM_FAULT_FALLBACK;
 }
-- 
2.47.3


