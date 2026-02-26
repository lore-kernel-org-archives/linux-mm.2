Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3EDB9FC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A53E46B0092; Thu, 26 Feb 2026 06:33:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A35506B0093; Thu, 26 Feb 2026 06:33:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903326B0095; Thu, 26 Feb 2026 06:33:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7C2166B0092
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:33:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1BC6C13C04E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:20 +0000 (UTC)
X-FDA: 84486396960.23.F79A64C
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6D946C0003
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:18 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GEvwlQop;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQlqNAg7YmGMtU2zToh4UykdOV+ZpXIvjbeNwJDuSLQ=;
	b=ZlGRXqisa3adkQ8OVkjGybGQHB9zu9a4gXlKb6Fwl6GegADGwyEe794MdfYk7BPlF79M0P
	8OyMFYp9pr4aUtgzOg508O08UrLC8zMEPKzOzZUrfu31dDZyIky9hF8guF9Pg/PqrDZ1zd
	PyjeMshiAWbF1CgM8MxIMvSY7O6ZBH0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105598; a=rsa-sha256;
	cv=none;
	b=AVmUYnT8S4SFzRHAcDclS8A0SHjObMiAfXvHOSi7IXj45fnziUS4MRTyomqKR0PsfuyDRG
	B1Ve/IkD947xjO5sKXTcLIqA5XHkiOxYO2qPw58HuwItMTNQCwadB6Jevhr6gMOXtDMZkj
	d5qqBG4SUTetHyPwKaGHlgSqEhOsTRw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GEvwlQop;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105596;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oQlqNAg7YmGMtU2zToh4UykdOV+ZpXIvjbeNwJDuSLQ=;
	b=GEvwlQopNT6g5r3qPFA3hw4hEH5lzxHgG6gobmbs2WMGHD+HZGnd7GNY/CkoXbEowidLAw
	tx81cT6J81Oodk5830V5/Eg35UClUBMuKripPGXqKWJTXSeijwrsHxbsky+sC0U5RvryLO
	fBDrl9SDTCk6keGVFJY654/48cN28Kg=
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
Subject: [RFC v2 03/21] mm: thp: handle split failure in copy_huge_pmd()
Date: Thu, 26 Feb 2026 03:23:32 -0800
Message-ID: <20260226113233.3987674-4-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 6D946C0003
X-Stat-Signature: g8bcjs49gt6gyiztp9gpk6hgtpg7pp7h
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772105598-894497
X-HE-Meta: U2FsdGVkX19byluVjwpQ78+pHAVvu6SgUFz08k4r/bL/7pjn65Vsdl3eNNYmm2ux+CLC0vePpEU9FGm1K/VLVodWQLpTbSkyyxN+KxRtwxM7vh4Rzh4grTIm5ovxG2UtUowdTI6qpOOYpOQzuULXmiEleru8YCyglXE9587trzEv+WKaIwXBfSs6MJ/uqAlQgSNW3sqT4JtRsaj0LZ+LPw1BQm5XiTT2bvWwyv2mD41p7OC6/mr2fG08uBDcjeiPGfCnk9tG2Z/hJQttWAAfcAdp1SlDJaDbtUHX/ZHa6b/jB4zS5Jz+nYaGGah7gWBE3fKH+uXwoJRc5CzoeariWTtVeTy9DL8gIuyI1b121glHMYG2M+cHGJTmql68nUYLFjkWUkFxsY7mAnXbhUWj3XO6Z7nq63ga4V7dMuKrMXjzkoJybA6x+Hc9QMLAxSXx1drzdJQ/Rul2neFuOgo7kB2fHmUg+zPoiCEzajQogwGEoY1oVvBA9y/1PYneysjPioJs8QCtNRsQIWRH9AMUgD6iwuK9olQMnVWmuzl2PutCDQcbB952NYzV5sN/inQD3Pi9h65nKc8KyLyrHTmVNK7JVrJqqMqqFoh04F4nJZHSoPe+dWqGSvnQQ9MqPpkNOyuQHvY23cT0A2y+EvJjFcBBjAHFzlZEyfFINQn9KuDVwTruVQt1ZD3vefHCwYreo6TDC2va9M49Yx138bf31WjBy46wHhFbz2iZNvxLKQSuEO9GNW1w0n/+PMBfI2Ux+uEdDXaVSpYe+JHZULuMhusKxO0L3MlGoroJbMz4QPEFZhTdDRsO84gLDcve/NCRuYwAypjaP+cMz1gzbbDd/Sg6EH8F8PlY3DORima/DDyG6kVcKlo1NGhurOGNPA5dAqX51+648zNQ4uX/FlavcfnarmSGojksoKawfTMLfMOv8N0mhEjfrLzTE2mI1y92u2134gONUbOw8ZXDbAN
 Ux0GONg4
 XULc2ANGwOHQMfM2thaeSVC6rFlKQ5mXJGu+mw9iLWdOK/fUUiy9rCkjZcZ0Un/sjOyDQp9RzrrrxHTRfPyHDBzyTiX6i6rp/GBHf1r87D8XOQgAnBL+GZ+WSbi/ESlCxx2W68cMOrcdGtlJOa1tT64qOaCH/ZefcQVCzml9tiM5w3XtwanIgY2XhEciAHiA/tR2YCKWiZLGOalk=
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
index a979aa5bd2995..d9fb5875fa59e 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1929,7 +1929,13 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
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
2.47.3


