Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B5ADC4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:51:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 981AF6B00CB; Thu, 16 Jul 2026 10:51:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 933206B00CC; Thu, 16 Jul 2026 10:51:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 848A06B00CD; Thu, 16 Jul 2026 10:51:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5A7E36B00CB
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:51:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF6171A01C4
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:45 +0000 (UTC)
X-FDA: 84994928970.07.8F6DC45
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2CA6B4000C
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G8J8pa/1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ka6zYOXsuhzx77WYU+YoIUZ4Wz6My9SyyjFFnIK2/ts=;
	b=TYxh7C97Gq1cDpb25HRmAR+O5iSXd/AkMpv4xbTDKz4+noZx0I1hTGPdsbhMQHZXAPRkhw
	lL37F4kWXhF3Vmtq/lASVWBUhjxPH9R1YgcPFl0FIbSe4LRiON16yAtDWntPxLqoHHlpI9
	ocOZMcpt7HgsKqaRgB6i5OWJ2BOwiFA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="G8J8pa/1";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213504;
	b=1ayGIm5bIeAIt1xYGTaTIroJmic8c0sNBklJyeGMIaQplC8r/kMtzENLMzXM3mxqkdV/KK
	ZEbfhvLxMnt2lYu6PLV9EEEQl1EHM6ZLeXHSbrWLusO+paFHb5jltqacJhApTMHn7gDsrm
	78Dgt8m4LjnCVNAAcXVwY3J2YAcs1gY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CBEB42A14;
	Thu, 16 Jul 2026 14:51:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 017BF1F00A3D;
	Thu, 16 Jul 2026 14:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213503;
	bh=Ka6zYOXsuhzx77WYU+YoIUZ4Wz6My9SyyjFFnIK2/ts=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=G8J8pa/1nRI8j8oUQnulySCu96Q8xq00a5h/GkJWgx7G0Lor9V+49krSS4vZNMTpl
	 BjpBYfElp1gxBB+nFV7YEEbbFPxfd4VelehBfIC4A9Dn+mkA4B6RQsTbcFe+Gpb/CV
	 EvHE5iBlPYmRMjoMrHC246WyHB1iEwkmpkLuJWUZp1Hwo6LO1xNbVMg5mVP67XtRln
	 O+iLPelLLhHSUZbEreJXf8p7v9RlVBMtWuwuvrPsQYAQDhUfooYBBPfaolthnAojYJ
	 ZRqXakJe0kFVulTi95mGCbNQPOBmHFlsmyWIDt8VUMs/Gt1Z23gbOtjFTJNhAsgYCf
	 rKLUWk3nOUTiQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 16 Jul 2026 16:51:04 +0200
Subject: [PATCH v2 05/10] x86/mm: stop marking vmemmap as SECTION_INFO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-bootmem_info_part2-v2-5-4afc76c73d61@kernel.org>
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
X-Stat-Signature: 53s1j4a7mebwoyi1n5mgepy4riwpmk7d
X-Rspamd-Queue-Id: 2CA6B4000C
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784213504-78058
X-HE-Meta: U2FsdGVkX18Y4wZcDi8IYpG9TPovFCgEMQyo6qtVmgLFMUv213ctE6aSB6dgIQ+RqziZ6o95jMh1Fad5gQS/mgcken2cwoLD/WzGR9momfswpk5ysG4cePaSGj6ucNkb/LxeeRG2C5jcrzuCiTldnk9qReDv6PCzP2yY3o6zcf0Z6te4cUIdJBRD15rOe76y/+WjUdQ2xGvo7hTu8tbrea4PfTThB8gBFMzKpxqF9RuC+u92PyAyqEy0ZmQh2cMDtA1SZiXrQnphZdyO0l6EVb0TlTQ/Eg1jx8W4mNDjzdNL0owjGA1cqzTUGKcyXFkRVG/FASi9GSmqEtJX8xdLrJJmP2CRV8OV85SP7DrFcoaDMPwE5QbYV2DiqMGeAZK8dYLQ9YapjmLkAmQ1mWuvSgVZrIhcnwhryvPcvpPAyNlkipMy91mtFnhUmUhNTcrIrKpGs/kjhj1vA8A83ai8wYWy9Reop22/6WkgUdYmiofRdHaBrmWxMwBpm9lwW9CKKWm/Azjqw6af9hAcbDIL2dmfqg4ZyllwfeBDPx/w6ihgbPUN5qJksFKyfjAlhe5+OrqO/DM3TeXtjVWKvVxBUpyxFgHihTXHb92wiaYGGd2q8aP+U74oyJLZyzm/cilazpKY+aFR2dRxPSZo9TbbKprzGtItTnrCk03Teap6hvZsvNlHGt6EatS544syG/1Cy4rbiKys1o5B2eV6F/RQ8X+rpNOmzhq86pgD0Eq1lZq7Q66okzR7eLj7d0b8IBCPl4HIkwUE1Xfs1YPdgoWI0PrPL1q+4BbeZ9A9maSKbj1OI0Tu2Jc9TmjPQsGXlCPsV5JvRYbk6MhP+mHdnbBgbRqjF4gzdN0Y8SHo1BsWmJWTj4lsQ9xh0ysd2tDNG8kiJacpouL+31PeisBTC/DVPwE/eVO4jWNk6KAXvCXZRZIbGvnpe/ipfFV2hWNX1PvF40j2VQaCOgmBbKVwQBd
 32aKLYVj
 /by1KBuucb09trHjPsx7PZ80tnhT4NV32K+idmHYrdhMYFbfLIsOokZOrVW77r2kKqf/WcSsh4ZH1yEplzaCzXF39O7V84eaVFgpfwagRwiWW2+GseUm5BROILGu+1XuGKQKD78X6gVvjzZB7Ch6V+mVSqb6hDJiGjSA2xYR7/kTX8qSyiIE4M8aRbzAHMCfuoa0ce+0qtzOxDC9PqqZyx56CmM0B8ME894eoagb72ZG9p1vfQ1CaL9QBzwA8FMjtbCWLchqHLDs4XG912vddgp/f4vxacPErtcwlMadupGc/DZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We added the whole bootmem registration machinery in commit 04753278769f
("memory hotplug: register section/node id to free").

The main use case was to remember to which memory section memmap pages
belonged, so the memmap could be handled accordingly when freeing
memory.

However, all that machinery is not required anymore: a memory section
can only get offlined if *all* pages can get offlined; and it can only
get unplugged once offline. If some of these pages are unmovable memmap
pages: bad luck, doesn't work. Offlining will fail.

Further, a lot of this machinery was required for pre-vmemmap support.
Now we only support the vmemmap with memory hotplug.

So the whole machinery is useless today. Let's start by removing the
last pieces by first stopping to mark vmemmap pages as SECTION_INFO.
In free_vmemmap_pages(), we can now always just free the reserved pages
directly.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/mm/init_64.c | 30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 320e742b0bb3f..82bb0384b8ab0 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1024,19 +1024,12 @@ static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
 {
 	unsigned long nr_pages = 1u << order;
 
-	if (altmap) {
+	if (altmap)
 		vmem_altmap_free(altmap, nr_pages);
-	} else if (PageReserved(page)) {
-		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
-		    bootmem_type(page) == SECTION_INFO) {
-			while (nr_pages--)
-				put_page_bootmem(page++);
-		} else {
-			free_reserved_pages(page, order);
-		}
-	} else {
+	else if (PageReserved(page))
+		free_reserved_pages(page, order);
+	else
 		__free_pages(page, order);
-	}
 }
 
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
@@ -1593,12 +1586,8 @@ void register_page_bootmem_memmap(unsigned long section_nr,
 	p4d_t *p4d;
 	pud_t *pud;
 	pmd_t *pmd;
-	unsigned int nr_pmd_pages;
-	struct page *page;
 
 	for (; addr < end; addr = next) {
-		pte_t *pte = NULL;
-
 		pgd = pgd_offset_k(addr);
 		if (pgd_none(*pgd)) {
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
@@ -1630,19 +1619,8 @@ void register_page_bootmem_memmap(unsigned long section_nr,
 			next = (addr + PAGE_SIZE) & PAGE_MASK;
 			get_page_bootmem(section_nr, pmd_page(*pmd),
 					 MIX_SECTION_INFO);
-
-			pte = pte_offset_kernel(pmd, addr);
-			if (pte_none(*pte))
-				continue;
-			get_page_bootmem(section_nr, pte_page(*pte),
-					 SECTION_INFO);
 		} else {
 			next = pmd_addr_end(addr, end);
-			nr_pmd_pages = (next - addr) >> PAGE_SHIFT;
-			page = pmd_page(*pmd);
-			while (nr_pmd_pages--)
-				get_page_bootmem(section_nr, page++,
-						 SECTION_INFO);
 		}
 	}
 }

-- 
2.43.0


