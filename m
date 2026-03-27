Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44B3E10A1E63
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 02:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAF576B009F; Thu, 26 Mar 2026 22:14:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A870F6B00A0; Thu, 26 Mar 2026 22:14:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C4CA6B00A1; Thu, 26 Mar 2026 22:14:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8B7636B009F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:14:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B29ED5DB42
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:33 +0000 (UTC)
X-FDA: 84590224026.14.CD8131A
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf21.hostedemail.com (Postfix) with ESMTP id 008241C0004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 02:14:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lWTo7Sxh;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774577672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HoJOR/NIUvMGOPs6vSvgMHM3cn3cr848MTO9YNsr9oY=;
	b=Xkf2wUQe/WYzhxsVsQWla1yOZbdvXG2w3ui2QpJ9niTl03ens1uBWF7kInzRV1UkEXN1Lx
	fqxm+PrpcjflOv6hwp5GvLmvn0vck1IpHV08dWjpdIQCieXlPCATv52ZzL9LTXYKJPHcRc
	AJ/QdA2ti2FsQIyXXYYaDqLyOZ+gt8w=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lWTo7Sxh;
	spf=pass (imf21.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774577672; a=rsa-sha256;
	cv=none;
	b=1KKWmZrDJVO0cPl7GVQr/Uj0qtC6zvdAwjlFD8G3w8ffc0XPcpsaFNFf/IHeHF8WaxBPP/
	5qWjmr3svnDx64D7kWzhZHUXdnInU2RWfjiFxXXMnD/BQVwL6lHRwEN7rnj2+IydMnXiwA
	8e+PnQ6wZX0XUyFguJafg+iz4gnJ0/c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774577669;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HoJOR/NIUvMGOPs6vSvgMHM3cn3cr848MTO9YNsr9oY=;
	b=lWTo7SxhC2/el6n5yFl/mHGjsk9IDwHTkAjGiFljw5zNKe4kG/HDpe+AsO9ZpB7Xn6yD+M
	lcl/hkBeI86GVj/xnEw8geiYoIXVZyBgQnR/YjKR6jzAP1uj+D4R7LeXEfle4CWzYnGNLi
	3qFtTl8j3HQslYlUdM8vuHjTd+DqRMA=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
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
Subject: [v3 03/24] mm: thp: handle split failure in copy_huge_pmd()
Date: Thu, 26 Mar 2026 19:08:45 -0700
Message-ID: <20260327021403.214713-4-usama.arif@linux.dev>
In-Reply-To: <20260327021403.214713-1-usama.arif@linux.dev>
References: <20260327021403.214713-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 008241C0004
X-Stat-Signature: ai7cknou7bh3ciqd58cedx8s3hd7ort7
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774577671-931756
X-HE-Meta: U2FsdGVkX1+loAIb0GL3eATSrRsbJMLPw16Lj9O/zOE+CMhrjaEGJzU6MKAAVaGa6SG+Q3HZCKFlzjITScWz5tdkXYiEMw47NtO3nxBdKP6mCyWnAnCOPGpZ1fd7mxPKkfcI379HmhYWGXMwTFpdZRVaHgoTxsw61yn1kYf9QI8iXCAzJPLjh1ZiGPLk97Sgbt1+G4Ya4jwOhMHuNtJDtoqaAx6jngujLlNP7EBQlaM3eKYssYPfk/IoR0fXcAxNoEOP7GMiILELH3PGAoSmPaNGvOSXeM7DZ6LFQb13dJfB3XJWqYcIOn8XizorXG9R5hOwGOsbhhKYXMsAEdDSVedDA7FxbLKI9/NYHZXP1JC+CTQQbEq1uLURl5v21ipXG9U1PYvfJd5XQXaP9uTJefhr5IdMKbZjv9f+mxEesbK2wwKL//CjsCGOXLKQAjvs42J4nns4oqMUs1FZ8VHOvFfNyxzHF1Kn+pTHY1qH1gEogPnm3gYlPXIUX/7bl+CjOd+nXrqcflNeUMbTGKNDbHnpKhnnAgbLanLQsosbPwcrP77eG18GNlgU+ng1xRjY+fYWDCUypMg+X6clsUC8pSC6bIPCtQMQ15vdg+vPElk3e868nC1gk1jiJNrPku7rMScUdgA/ujTxIpA9jk5vKC1ae5tjFR3USZ1e8A0hkoigls8kD45u6c5qN1hGycUBO7D/oQKbDPqUViUExlNyJyQdS5qwpLbrxaPNF1FLmG+ta3SqFOrGuWw8Zq2aXnWrrNElfQrHXUtn5ojmV9n0FPDyV6MS9bMWcCYmaOYuXAgD/RR4Ip1KXOa6mkqeT7Y8/x7uuKVcLeFRCT+W4OrWrqwDQErnal0OuDujInR3Ztpmn2lfQ94337Rj2qveNSteMcUf4FlpdVeKCohS8SffwlKOvCJF51uhg9zUmnEBFrJ/6nWYdp5FCD0Z36vBbiZscgLn7KRKmyTDkz0R3tY
 KUnmlbsY
 5J38ShPum9uUPbHF40gD57hXvr5FJNqzy8y7D9gaeiOMouDxQRZwrmXo6kcSjLjMCuZHYK9QiQSXZAz0F72/RzAeLYWJF26BLeQifbuX29rW2OyUURXPs7wGkw0mVJAqfSOvMHdr0gIigtXhXC8h0D9xPiQVvsqCou4QFuxq8QhQHVG41ghORDSQaTOeOVLs67ogYsQtww5jpbeA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_huge_pmd() splits the source PMD when a folio is pinned and can't
be COW-shared at PMD granularity.  It then returns -EAGAIN so
copy_pmd_range() falls through to copy_pte_range().

If the split fails, the PMD is still huge.  Returning -EAGAIN would cause
copy_pmd_range() to call copy_pte_range(), which would dereference the
huge PMD entry as if it were a pointer to a PTE page table.
Return -ENOMEM on split failure instead (which is already done in
copy_huge_pmd() if pte_alloc_one() fails), which causes copy_page_range()
to abort the fork with -ENOMEM, similar to how copy_pmd_range() would
be aborted if pmd_alloc() and copy_pte_range() fail.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 99f3b8b24c682..8ad43897bdf80 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1913,7 +1913,13 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		pte_free(dst_mm, pgtable);
 		spin_unlock(src_ptl);
 		spin_unlock(dst_ptl);
-		__split_huge_pmd(src_vma, src_pmd, addr, false);
+		/*
+		 * If split fails, the PMD is still huge so copy_pte_range
+		 * (via -EAGAIN) would misinterpret it as a page table
+		 * pointer.  Return -ENOMEM directly to copy_pmd_range.
+		 */
+		if (__split_huge_pmd(src_vma, src_pmd, addr, false))
+			return -ENOMEM;
 		return -EAGAIN;
 	}
 	add_mm_counter(dst_mm, MM_ANONPAGES, HPAGE_PMD_NR);
-- 
2.52.0


