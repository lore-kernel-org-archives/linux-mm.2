Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2DA3606A337
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 12:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f5weJtFu
Received: by kanga.kvack.org (Postfix)
	id EE8766B05B1; Thu,  5 Nov 2026 07:16:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC0156B05B2; Thu,  5 Nov 2026 07:16:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFCE96B05C0; Thu,  5 Nov 2026 07:16:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C0AB56B05B1
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 07:16:18 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60848409ED
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:16:18 +0000 (UTC)
X-FDA: 85400962836.30.85ACFBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 78BED20005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:16:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f5weJtFu;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793880976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xRhIOQP7ycZj3AHtGBmP58IXy1Gmj04WWtW7XPCSAgQ=;
	b=uuwbcwUI3boeYk9XrG7jKqIzuJi+MrQk+se96RfardxGaHBnKIOnXQEJYbjcbJQLbXVTl/
	YCwDvU/jgrY0xRO4WL2hvDnBfRis22f+Y9VZflg2wczH9p/covp7V9IIC9vzQeKwDYsxSj
	q1yhprSSmFujGW55XFeqsQfVcf2+5NY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f5weJtFu;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793880976;
	b=WikzcueFDbCcwK0p5VOcpstV0UzYK8cvsN/RTs6fNoRo8pqoGBTkRhGvM3IjSm6OYyT6pv
	96v0fIHJv8qS0eNBQp3wfYwZW8wO//RwY/1cdrcBmV9b0F/EIcMct6hLvBVsqWdIN5Uy23
	xx2kTUekl8Jt7DiuZRwzk3tBf5gfJAQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 857B443285;
	Thu,  5 Nov 2026 12:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78EF1F000C1;
	Thu,  5 Nov 2026 12:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793880975;
	bh=xRhIOQP7ycZj3AHtGBmP58IXy1Gmj04WWtW7XPCSAgQ=;
	h=From:Date:Subject:To:Cc;
	b=f5weJtFuhjm0h7M6W8Hs3aNXIE5onxXNv8UIxEfi7uSgLumD+rte7uMoF/tR2ql1T
	 B6dkQ81QmyzVVL8yHNY0PNGv+/MKrcJwZzWAQnuRYFJ5CyhvS57wEvLQLe317l9k3R
	 8j9fPrL+KoXA3M3aWvW5mDu1zcS9hp2TeB9sNYCHFn5XMcnwpP4burhK4FRIQkVLzX
	 kknT9PUK01t4IrFmAQz4ZOtbjEb2eqiXCk2C5HOF0Dbhk0654WgLJc6b0/Ildn5lyb
	 BZyOBIwKtew55wrN6f7J6UcfRB7e8wikcU+xl/KCyWd/qwC41UtqcTFNSHxhgY13Io
	 vNDdsNMRhogxg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 05 Nov 2026 13:16:05 +0100
Subject: [PATCH] mm/khugepaged: free unused page table when setting a huge
 PMD fails
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-khugepaged_set_pmd-v1-1-cb79ab117199@kernel.org>
X-B4-Tracking: v=1; b=H4sIAIRz7GoC/yXM0QqCMBSH8VeRc91gG7aiV4mQ5f7OU2RjR0UQ3
 72ll7+L71tJkBlCt2qljJmFv0OBOVXU9n6IUByKyWrrjNFn9e6niOQjQiMYm/QJymmvbXcxV7i
 aSpgyOl726f1xWKbnC+34P9G2/QBjC0WYdgAAAA==
X-Change-ID: 20261105-khugepaged_set_pmd-60a02f718e64
To: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1769; i=david@kernel.org;
 h=from:subject:message-id; bh=x6hsSULERkoUAEHmmThvU0TJPUEgXBgWcpU2wORz2/k=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLeFLfPDkzxz3YPy/rirqUeVJXEeGOG4PHz37dGq63hu
 6SmffdKRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABN5f5eR4YBr6qY7X+58/Lli
 UR+H9sfkqHcLeVvCJSJSxXJnT51wZDHDP8sqHcUfctFmqhW/Pvw+EHbd2Ox19OHm4xlJZi6nGcp
 uMAEA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: 9j14ecidhtoc8tnoqfbwwgh3jgy6f7rx
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 78BED20005
X-HE-Tag: 1793880976-369063
X-HE-Meta: U2FsdGVkX1/6LJXBZxzoCAR/eRbaN4n/V99XFIv+2SjInOaBCNboV+Ng8VYpweuWo+NU+gQXsX+TE0LrgaN8d7/XCB+JGeKLKCW7HNGV59G+ab0zt7fobw8NGqfGNC8pSbhsU60QchNJD7Bbv8c9xNk+88CJ6uAIvmDjPRFX0TJGKFzbEYNn7xeXgKzOL1nIBqPHugQQLXCOznK3lgI3vBjUA5N9Z/S/A/9Joyv1Mx9n2fN6GYZlkGNXX7q+IhnMZfWKH5wHtqHVY8WvG1gUPPM6eNWKyOHTfAD+HkF3L2aVx1Zx6lH6gELgM5zjSp9jFsiNBdkVKfe+/siBtc0w63Y1rY1QJoO2sYdthSBFujdoxHX9a/w0PQAMMwKxo+g78XpEQXnGnID6G8kggMvXTbhHpCoxFLSDOemConDCba+oPS8/fQZSOhTXFUv9fnwRlLUP1GR495daAzYES4iFsRw54/Hw6ow/LKIUlhNiqwRkh4Cr4B84GzvfXtKJprX4NkSBjgaGwAGUctvO0AQjVuGp5Dm9sHuwHFXd1YgNqNkZtGpSE5f7XJQOl68HjQpOrspFLTBiuqxoA9hnH7ouUI5CHTdCfP1ByzhOJ9Fx3dEgK0wqhJ43cW6pv6ezvYI0rrQrhvoTZgZNoVWW6recqDfoXnHGhjc62UpGgK+7vQoYyqsJnEU2/W0mtZIxYf1TY1VdfDSAl/Sd5WDUJOrDrhbKjvtXQA+KtZgCmH4qCLYinuJ7P+7vgpLfmGhxdFTxELtpYFyzwLelumS+q6BL13r7rrU7dn2iGbWKWO8T2Zut0NeYsu6WuD5fSM/KSWhzVII31ARle6Q6eGbMuWXGTEmad2UGOozYNdakhijq+21B0IRAoCPB8NXSRj6UVAWP2NZ6HFLnTZwKjxHcG/5rQsBfnwl/SU5iDYJAbabDtFvK8RhaiqvyJe+6NF+P+0Xyzbg4VkSCfKx2VNY0kSY
 RdJug9e3
 ldAxMaYHBepyRpdtm2MWQdO5aVUvga8QRtQVgEcrsf/rDu3FpRLAfe3alVESGAk9rT/H+jNMJYBQ4T5pbJvlrod4bllgpxeye8zZPgEWrCNXAv9/tPoItzGEcWCtScyFvQNQixT/KHCDjr4BoJvErgeTa/9h1mN5d2yz3v3HrfdMwBVHuKGPsj39dpjcpNZ64Vx/9eKQEbvnZXhgQsiXdGx513v3ap1htM5GZw3S3ScdA0OnQvPj2DR7ing==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

do_set_pmd() can allocate vmf.prealloc_pte on architectures that need a
deposited page table, such as PowerPC with the hash MMU. If the PMD is
no longer empty when it takes the PMD lock, it returns VM_FAULT_FALLBACK
without consuming that table.

Since collapse_pte_mapped_thp() uses mmap_read_lock(), a concurrent
userfaultfd operation can install a PTE table before taking the folio
lock. If that races with set_huge_pmd(), the unused preallocated table
is lost when its local vm_fault goes out of scope.

Free vmf.prealloc_pte on failure, as do_fault() already does. Successful
PMD installation consumes the table and clears the pointer.

Having to do this cleanup outside of do_set_pmd() is rather nasty, but
other callers depend on it already having been allocated. This needs a
cleanup at some point.

Fixes: 1043173eb5eb ("mm/khugepaged: collapse_pte_mapped_thp() with mmap_read_lock()")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
This isn't super urgent, so it can wait for 7.5.
---
 mm/khugepaged.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 8d9f05a39afb3..213c005fa8575 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1826,8 +1826,11 @@ static enum scan_result set_huge_pmd(struct vm_area_struct *vma, unsigned long a
 	}
 
 	vmf.pmd = pmdp;
-	if (do_set_pmd(&vmf, folio, page))
+	if (do_set_pmd(&vmf, folio, page)) {
+		if (vmf.prealloc_pte)
+			pte_free(mm, vmf.prealloc_pte);
 		return SCAN_FAIL;
+	}
 
 	folio_get(folio);
 	return SCAN_SUCCEED;

---

base-commit: 02f72aa35c5e7dff443c62cd9964686396c8b201

change-id: 20261105-khugepaged_set_pmd-60a02f718e64

--

Cheers,

David


