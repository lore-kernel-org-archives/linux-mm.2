Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB627C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00DE96B00CF; Thu, 16 Jul 2026 10:52:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F27116B00D0; Thu, 16 Jul 2026 10:52:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E15B36B00D1; Thu, 16 Jul 2026 10:52:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B71776B00CF
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:52:00 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 38A1F1A01E2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:52:00 +0000 (UTC)
X-FDA: 84994929600.19.6D66F17
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 757BE1C0009
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:58 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VektfMeZ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213518;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+jMCCNNe0KRBXDTzHHXxd61yFM5vtsC3u4DIa3uGDkk=;
	b=m2PDJTJcSgTBaSPzeK6xsM3IRrG0y9cKAg3Qn2wVGuJF0IRgAco8LKoI78V1+bcSAxzTbb
	DlWr94ULZiNMzrlqYSooWL5lRU/1ewLgNeiYkWxVB3O7CXt29AI0FC/gzZHfS4R8NoaoYc
	JYSqthEjyDP2YfBliSd+n1s18dfTGLA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VektfMeZ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213518;
	b=W9Y39Xk0uKMRuZWLDTcCmbtuLKcZWE8ZEJhgirQfEGT2JyA27gQxn9CyqV/f3rfQfxLzaV
	kr7G8GlEsU0IiAVy+vN/3JjBPGaezc/IcUUisrp0mFqAqdUyaZ01QWmQRKrQdc39u9U9oY
	vgXdnJ9fu+be6aivC4SEEuOhBSRhRXQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C3E6E401A0;
	Thu, 16 Jul 2026 14:51:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487C81F00ADE;
	Thu, 16 Jul 2026 14:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213517;
	bh=+jMCCNNe0KRBXDTzHHXxd61yFM5vtsC3u4DIa3uGDkk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VektfMeZ/f54Pyk7l+Rh8MLEKJrztN9Du6wijZ63JuhlVjSkJ8PyC7dQ6TJiSQHxv
	 vz3bYr01qA0ZNolCN1D3xwipGpqEqxX4qjbTyGPQA43zs+DYNcsltTcmFuAZet+xFM
	 5wvuAv/dJkPFZdNO2XdtR9H/Xih2wog/sVAiB5Zd5TrK63FS/hVYAgDYZMDrXffqJo
	 OSEFFq52d933y4Hbsgjr1fiZVr57aZSlyaFLFF4Yl4zOp5RQsN/m5l3uXxenvQJQH/
	 fyW/4EGOEq3kTdVgdB3EorKK7ptbRJ1pg4abTv9momHFA6JHS3f+hpToIEzsncoujJ
	 tqbalf0C4sxhw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 16 Jul 2026 16:51:07 +0200
Subject: [PATCH v2 08/10] mm/hugetlb_vmemmap: remove bootmem_info leftovers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-bootmem_info_part2-v2-8-4afc76c73d61@kernel.org>
References: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
In-Reply-To: <20260716-bootmem_info_part2-v2-0-4afc76c73d61@kernel.org>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 757BE1C0009
X-Stat-Signature: urwppzjyus8kee99wf45dsr6yf6dgchx
X-HE-Tag: 1784213518-932485
X-HE-Meta: U2FsdGVkX19WGFmAXAB72HrGzzX2YIvLn8vOyMfxsl30h/1eqPiQiWvUaSQeJtVOgcL+Rw4NOAHY/tz5sLApWSb0WhgOjNphEZR5DPsIGTkNOQHB9ErSEvvE9gYvJ8fWJdqC5igI5XK7+Ldqeki8GxOyRLLFU5s5NIaEPqak3wV7wnjkquBLtq13Svb+8GpSTsJVNTKRd6oajGCuCptQ8CaYQSRNalFS1yWIQtMc0c4snVty5R6yomJxdbl/2kZErlHQvB8Ed4ZfTOvUP3b1SqyD10uqP/uNrABv9j/QWPwKfuFCmRO0WDaaRt7a/SPiKQOhOAWU8UJr9ErbyigK+rXn3071yA0gIUih5X/unfPCxbw91opfxz19VkIuSrjdfeD1CtvwzLAaWVcfibIugJm9ELO1236m4uIQ+pWcAw/SpRZAJCALXn3Sl4AzyJLmEvwLPqNjxb2G5ZzC2fN2yVAyB25WfmSC5S0QJzCQPqlULGvnk9Sm0ai7mCcIVef4FKRN5wfNql7v/FCE7yE87GT8rv4EyarheYcsj6ZcdZiZkI3F4PnObUKAyCxtfaHArG0gSE4OviQKc5D7ACe4rHKAydS7UIewxXkZjNYSBRRgZvfNMwPQwWTk3HY+9JuPm4FhL5XiJXDB1QSMZ/1JzvpbsmgwgbbjEmfNjf3mKCvQwNNqnZPij9432/CAv/dWLHJrtN+sQomjuEM+sPDSH/kB4gF7noxjKxa92a1Q9LjcjpBpHA/LSGsQ7iJZe2k2rH2GoWT5kfm95EGyVH1NBfwayi7vSLvXtPbljyEArOjegxpX8V4gG1Xv4iJYeVRdEkwRhf9DTYAsChl8+gGUlchDvchOgTW2AsInl0e8kP5N62O996TGoTKzDxrCllZ00rP1/S6qb/sL3Z28X5boFCzm1EpJEWeZht/wO21SRe6WGvmWLrCryCFB+tEp/aELCAvDhcM+E4z9XZeBq5S
 uzyq3Jjb
 poNr4Jo3HyjwjKsSrKd78Dv6B1wX1aslZpjotX14vCLXIjKL+2/UKtSw/oVLsYiNJ0oB+VYtnG0p26eSfIJ3eEcdm64nTev0jkwMR1FfggtDJrbbV9hJc8YfXMKu2zkRPdq3REYebUq4JhzJ2NHxO92xGTOLHbC3K2ENjmXjA8QpjLFWZQMnqQj+jDubxDPYu3O83tijXpH8wXQFNBlN1eMZm6b9LvPxBftmXXQetssUMHui/+hqMVB2K3nJ6Cnsq3jEa5vAVxYIND08DY5k8xNBykdtLYhHre1qXKr4iEmb7aUZdV+bPyMZW0XYsms+B/r0B36bfW+1AA2I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We never set CONFIG_HAVE_BOOTMEM_INFO_NODE, so we can just switch to
free_reserved_page() and drop the register_page_bootmem_memmap() call.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
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


