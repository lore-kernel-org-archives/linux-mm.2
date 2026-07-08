Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA7AAC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 14:11:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C387C6B00A0; Wed,  8 Jul 2026 10:11:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9436B00A1; Wed,  8 Jul 2026 10:11:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFEE36B00A2; Wed,  8 Jul 2026 10:11:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8AF6B00A0
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 10:11:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15E9B4019D
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:48 +0000 (UTC)
X-FDA: 84965797896.03.7B1B5A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 64D7A180006
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:11:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VBLjf+wa;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783519906;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZRvbw2JUgsEelPf8rfkDW48yS2gO+Tmg3Nh4V4fAkY=;
	b=Ddn93n8vUDPAMdHTpIfRiQJkdbEwtZbtBOsPHgI5v2aI4r4EwCb8hyLoiET5gYX1axAX94
	Jzl1J3vjoTIzZlHSrvoSQ+WPSQWVpEt7ptr0Q/sm3LwZSlwbWBQCSgSjx8tWf7tOrwKEMA
	HqRsOR4oXIykGtnVYRztGKifK2Oj4Ec=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VBLjf+wa;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783519906;
	b=VsvCKE+ypG1ObCPqhJc1yABwtiWhOLcTMx+gxmS2gpNXtoEQYpFnjI7bXUHdQGW7vzLHnn
	LTRdSmEV3P4JTr3ydbDpVhIByr+/nQH+iZaNu3XJ+t56PipYba/9l7TZNo30VLhFKcS3hH
	O3PnOvdbhMzXBUuXwf51SsI4qf5NwcI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F289260054;
	Wed,  8 Jul 2026 14:11:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963751F000E9;
	Wed,  8 Jul 2026 14:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783519905;
	bh=rZRvbw2JUgsEelPf8rfkDW48yS2gO+Tmg3Nh4V4fAkY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VBLjf+wa2OzNu5u4Ouq9WRGo6jVxPejabnf1+hTy75aECQTrHWjVDKmvO8aRlNRk3
	 maPwPVjACLBBkfBychafQYGctLEBU7dCgvneGdl4q4gEKDM/CX8RA5E/1s52WjfUhp
	 F+jYgsyetSLlcpq9NKYS7jtKgEiG0zN9mXdj2NHpiI1O/gyKDnpGVYE62bkzbxT56w
	 Ty6ehkE3DGA5x8bvPMe/eW9Lb2RUYBJuSdW1wW6mFpwel1+U5gD8CWXSReHTqnxgPQ
	 4C0OKpc3MrAdgZtaAsUdvxpJWeNj8twHDMbro/m24VcXgZRXjCEy7WLdrXJXCKUqrt
	 Lpijs2Gda3S7Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 08 Jul 2026 16:11:00 +0200
Subject: [PATCH 05/10] x86/mm: stop marking vmemmap as SECTION_INFO
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260708-bootmem_info_part2-v1-5-156ce4986598@kernel.org>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64D7A180006
X-Stat-Signature: nm7mqucwhxei7sh68rmocjxe7i5ey3gg
X-HE-Tag: 1783519906-64783
X-HE-Meta: U2FsdGVkX1/uPiWMJnDRM84f1RqvYQJ2GFCrvGj4I8gbjlFe3Pjgu/9bPlsAVni1ga0hwU54R+i1apvoDnnMHbUZaDCaYq5yp/nCZ0a/sh4G7jTpdQbNYHPSv6rtVp6t1u5YyBfYbMSpENmsIY9c6co5pMZ9BHbeBo64pfmh8xdZ72hj5ZqTM/DS15Pra8CdXNTCClmswIP7gDkEvfVbeH+8blSuAQfRRnhVx11fBUSPeo5X+yCg4oqQBVkbEMFbtlo33CSd0Jga6nyGcylHfsVK8APnMmyVYAPBd9FaQQwuG4K11kWJMmK/S308zzt5oGlhIgEbpSMr+B14fQIaPhPg4zdqpL7wRmFku0bwTcl1j3c4n33tWJlcRCMKTr35ogxPX9hzS2XfHRutJjKrnIQY1sY4mx3FZPTiuB/V/OjsT4qpIbdESaB9o0DzLvPQlk4MMQSdva2fbOb6U3m5LpsX9NrxDRqmsHhTc6yL5yF1KkTDqS8uAQlKLnWOV26ssRxw0N41y25/DDEiO90qL3ujjo+Kwo9dicGSQ0f5ZUKgcgiNnRCHcz5zhPfAOFFWk2MMFD5AAfT7NRia427CzqyX2yNz3oEX5KT5n3JCJDWPqWfYFyQaffJT809//wdNSFthtREBRACmr2ZtQFT0lSdLElMEpj5hs0afuN8IHI2NHDNd9YhSPRIKONV9CfQFAXmYaujf8IO8MsfLH3uFMhE89NrxF4KL05cgs5yOzfPndjobsgc0sCPHousfuic4Z9Zb0iqA7IYMNDcKTB8vPumVv5qrmdNMhWJZL3/L3NntyMb8D92EJXss+b6PB/uPcdYZ3mMuCXNNuxG9F1wBhICQ4a0ZS/qQ2u4aaftbiHa6CadPbAMSupbu1jOZqdqlQMSMWAlPTss+x9I3618+DPFmGGW5YoYycNq9konEMWNvMyyFryRyLvgZannxKdmsjmOJWHJPUFIWp6tYpER
 6gAXDzxB
 GIJgMULcpQgnmrn2e2PvjH0LI3C3b8b6+1aITLQkshD2UW9fQVebv+NGKMXX/MUVsVwwyJNmzUb/6JMWJs7jbj1Vuml/z1zgsZyEs2CQx6884YaRG/Ny0rz+KEr1E0hQXHeYHA5BTe8tPZ5S/ae51ssdIBOtkTV1cC/U96Yanx7Wz+YBC/IYB1Jx4B2S94a6Q7HVch9Yvb4cyS8WrkJ33oPuXZzE4VKCtMFBHbmYM3yRh8OXWs88fIumRN91D6zZkw+UhKGvKLSoz/xYYpFKM9YCdKmZ0GywJP5DF
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


