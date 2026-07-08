Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6DC47C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:12:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D616B00AD; Wed,  8 Jul 2026 10:12:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645676B00AE; Wed,  8 Jul 2026 10:12:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55DBF6B00AF; Wed,  8 Jul 2026 10:12:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FA766B00AD
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:12:17 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AFA86C0762
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:12:11 +0000 (UTC)
X-FDA: 84965798862.23.F363A9E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2199480007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:12:09 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVKeExoV;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519930;
	b=IolZQGxaO9GtRXzOu24Q7zNnB3RPKDuHq5t/zjNIoYcinkKSIDpJGfALm9+4KMrmg39iVD
	JznBIK/v8BTfThsU0W6KPrrDFVepxLhHZjfv62mFlfM1JHlRm3yPVXaMUwOGFw1mIm8yGN
	vJhArMrFPQwUz2ftbPM7NP1e073xkyg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VVKeExoV;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WWLUsYbDG7mGiwVJlzgDyy16xOy76zogl1g8GKgt0OE=;
	b=jyfLustqWQQi/0Wos2GqNf/rcct2eorusQvlm85yt5AT6vJ6oVHzmYx15l6w7PqvCCAgsD
	OCy6i8qUGk2eDk1cF9g23MTf3gcn9iyvHILgFDuq+W2Xo9a8f2dYr3sOc06SgmcSGNe0cC
	14mJeey8eE2j4kQ9XRJ/lt77jq4n9hg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9F1606132C;
	Wed,  8 Jul 2026 14:12:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C525E1F000E9;
	Wed,  8 Jul 2026 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519929;
	bh=WWLUsYbDG7mGiwVJlzgDyy16xOy76zogl1g8GKgt0OE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VVKeExoVskhmb7x1k+V/281l4+bx71A5EAtpLvXXnhLBnmo/wXh3+iZtgRsaaKtXV
	 SMMuJ0OkPqB7pypW7SaC8grlPMVEDZ19latunSwoGyvts5gag3mmstusguhvCkTcea
	 TfoFB2v2S486O94fWOMmjfkoBXlH6LmYdxd3OP8uMx119/akp9FSVdqORbQgjt2YIx
	 NVnukUkX+UL7vuZMnBf0DQc7cUeTJFMTMwj3YOZQWd3L50cZCpjzgbMu105rzDVcno
	 ajYPGXNTNr5g0jfiD6JIZHbRZoPUX9vS65XSFYfZWFsCyM1ESZ6iWmUjMtEw4TCkvr
	 8qn56UFNuKDjw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 08 Jul 2026 16:11:03 +0200
Subject: [PATCH 08/10] mm/hugetlb_vmemmap: remove bootmem_info leftovers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-bootmem_info_part2-v1-8-156ce4986598@kernel.org>
References: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
In-Reply-To: <20260708-bootmem_info_part2-v1-0-156ce4986598@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2199480007
X-Stat-Signature: 8poi7atrccyc67wkacj1xa9p19sqsdtm
X-HE-Tag: 1783519929-966116
X-HE-Meta: U2FsdGVkX1+ubZXy50YVE5V/rE9jWE4wTIE0LRCAdBxCwTx7p76fHQRLQHEEOQk11/fG1cn8R/j3TD0XOtlqCeP9gzBUvO2XpTvv4rq2Kd9pM7LuktIgLLC0kZjoxftEWihWlyaOQSy8oIxPVAE8H4BXkqy4JLjvP1JGn2y8U/RhuG3c/YdspS0/i85pBEmFhTz5pvI1rAX4NJGRlGfMYgYhVlVMilPEatCLNxivZvR2C8QdeZHPNr0r/HdMOW+crxtn1FhsChkI7V1BHcluOU7nJFgYwnXFbebWbxonfvZ4HMmNTM7pihAraekooIUyE/jSBkfRRLUTAQXPLnpDKvt73f7Hgy2ejFU4EeLS7+YnKtgnoy1Kkl+hNltqRtb/Wrar3BS8bPqb8PQYLHg4iyvQEuw1Myz2VYTyl3QtYEkujhEA+3gMUPFp4TeFX1hsxlZp3YalvE3y+Ka3JVvyF7caeeKQ1heXfXcMDoGs+gBYyaIWCwsCt+RLrguFeYKH3YILmgzyghHYIICA21RaDhI5LD0qzl+U3UTLXCKb7lxX77fYL1kZL3+XvuGd6le+BQeydzcx0QTXSSCda+NJ8uBu7zT0f7gqDYyBJVbSSfOLjZ3/PAyWp4W+fo+THO/PqDWVEB4oWED/3AGrylh3RWgzRGWDgiddSKs68J0VN4TKVSh0A74RmZk5RcjVmleap4RxLfZlQVAPA4772QypezA/DB02bRHJ1doe5MJN7Fpwh1RLH3dC/h0FkJQsTdhP2yP4AEjEFpzUVEFqY3Yx0exxJRypOQruaeFjvdeOJ3zhwv/Z64PKjcYic58MqqS+NGwznuKd1N+tCHc0RJZuIcMh1PZ4iqUgTUYCEhz+TfMFA+SZj7Xz4xuj/HWxKa12CEzHhLJumNfg7+AzV9fr0v5cvCBcJXcjlCnqQXlwawL3V5kQVCXp4yTvFmrsPDWuQYVOjAMxheVnHkk5oB+
 JVygeDtS
 T1FBBKt/0alE0bxkO4sfLPVJXz4PbIelH/OVB3mvcN+FApr2zgoYUZpYpVJtxtyb9MjRLFttgiSjwjP9wvDNfo0mLS6ExyC1s3xj1VTNXctbhLk3NrcBjv5sod0uiO5/PdHBl7BSzi++fndG9MD1eSC4Orv8HDw7tEEEVs6u49OXYHSzGu2boiXNicLr/lCPpNyLeiK1jnwOpoRm08vigKuHkerwACcF+nwvV5IVp+3YUrGfkkxOkrch8oLMdCV9ufi2TTveYFjTNnCpVIRuABzF555fhfqG9c7Jy+/lOAHHw6GZ2aJbgKgbAvCiph4+4yDFFJRkpP9QeaFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We never set CONFIG_HAVE_BOOTMEM_INFO_NODE, so we can just switch to
free_reserved_page() and drop the register_page_bootmem_memmap() call.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/hugetlb_vmemmap.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 1430a5aa2de57..917db0984143c 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -12,7 +12,6 @@
 
 #include <linux/pgtable.h>
 #include <linux/moduleparam.h>
-#include <linux/bootmem_info.h>
 #include <linux/mmdebug.h>
 #include <linux/pagewalk.h>
 #include <linux/pgalloc.h>
@@ -177,13 +176,13 @@ static int vmemmap_remap_range(unsigned long start, unsigned long end,
  * Free a vmemmap page. A vmemmap page can be allocated from the memblock
  * allocator or buddy allocator. If the PG_reserved flag is set, it means
  * that it allocated from the memblock allocator, just free it via the
- * free_bootmem_page(). Otherwise, use __free_page().
+ * free_reserved_page(). Otherwise, use __free_page().
  */
 static inline void free_vmemmap_page(struct page *page)
 {
 	if (PageReserved(page)) {
 		memmap_boot_pages_add(-1);
-		free_bootmem_page(page);
+		free_reserved_page(page);
 	} else {
 		memmap_pages_add(-1);
 		__free_page(page);
@@ -641,9 +640,6 @@ static void __hugetlb_vmemmap_optimize_folios(struct hstate *h,
 			epfn = spfn + hugetlb_vmemmap_size(h);
 			vmemmap_wrprotect_hvo(spfn, epfn, folio_nid(folio),
 					HUGETLB_VMEMMAP_RESERVE_SIZE);
-			register_page_bootmem_memmap(pfn_to_section_nr(folio_pfn(folio)),
-					&folio->page,
-					HUGETLB_VMEMMAP_RESERVE_PAGES);
 			continue;
 		}
 

-- 
2.43.0


