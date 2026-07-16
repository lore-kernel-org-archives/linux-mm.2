Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 765EEC44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9496B00C6; Thu, 16 Jul 2026 10:51:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C14D6B00C7; Thu, 16 Jul 2026 10:51:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D6936B00C8; Thu, 16 Jul 2026 10:51:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 353DB6B00C6
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:51:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9831B40201
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:26 +0000 (UTC)
X-FDA: 84994928172.27.18EB550
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 045BAA0003
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 14:51:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Df/vCrmp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784213485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VRo8YFh6zUYF3ZhnWdJ55baNXlBROoBJ18GXOIHqSYs=;
	b=ppekEQdtjFDx9BD2UUpWZN+W+CzCOlsbPnlQ1Kex3JPwnd6YarU11RksySybPsmicC47u6
	dvFVu1ik67iMsvqCeEZmm8VAjUe3SfrcNObp/Dt1rc7K1+flzbXBb7O1sg7imiu7uMpA13
	h7C+nM4kGpAyrFi3WAb77WG8icmCJWg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Df/vCrmp";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784213485;
	b=d4+KTM8nZ5VzGNG3d8JFpJyYGQKKCoT2L7y2VtCLsjO3HRWMIPEAYSzqPLpN7m2SFMVZYv
	FWinMNCowBG/hhaiMIgWzvpwxJajwpU4AXp3amQ/ZXEsTF5JNw4bxLO94zX8rpDjwE7ZgI
	J/LlzCDhZBI6T5+fjB1H3Ui2zkqUkxU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CE7C600BC;
	Thu, 16 Jul 2026 14:51:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8A931F00A3A;
	Thu, 16 Jul 2026 14:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784213484;
	bh=VRo8YFh6zUYF3ZhnWdJ55baNXlBROoBJ18GXOIHqSYs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Df/vCrmpv32e4O/AWaBKoao0h77SA7q12X1pjDs5yQOB6Rx+txHPKvk4MB9UU9J1A
	 8T6TpeC8632LXGkJwMgpTRkZVl07Dq0VUK1X8TwW0Fp5lb0d9zMokxC/fSCiZqH6DE
	 aa2OsvAb7VMXwWNSoOYuYqyy3P0QOXmI/bPUhCidtijsaTgsSxaR4kiutceuSSKZ6v
	 o2xu2KUzaYFtWYMuaQNIqmCqv1x0Obr4nqOnqZQYj0qlWWqdaE2qs9vSbxWhl8FLej
	 bUuuxuqEy0soB2BgyPAjm+LyQUXQJpkM7rmaBCWAVRiY6X0Grzdq3YsBSQdGjbE1UP
	 ApPa03RhCs8lg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 16 Jul 2026 16:51:00 +0200
Subject: [PATCH v2 01/10] x86/mm: drop order parameter from
 free_pagetable()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260716-bootmem_info_part2-v2-1-4afc76c73d61@kernel.org>
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
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 045BAA0003
X-Stat-Signature: neaduu3jtscj7j65zk6jbjbftmsb1rs8
X-HE-Tag: 1784213484-215807
X-HE-Meta: U2FsdGVkX1/JKST+/dv4c4QarD9etbGiDTFF+MxnV871xhfxgd33HOW6gSXCmFacKao+rB3/3Zm1oRjGVWUivcwaL7NpXUdoP0pC7bDwvcwHwS1Dc/XFNqhHKMaeQQWbctNMhDt7H6MyYrz7YcqWeWjTN2Vw/GoG9ylM1/IJN9R95qsDxTSptox40TeFUBvt9kUb/kkhfQ9AfLrIgTFZ70ge7rdDVDdaEkTWHkfrGbyF/b5es6LZ+wdqGwAJr/rzNNWlieMi29951p4Gg9E9+C99TKd75+m4KDHZBZDKTRcmBZ4KMprK5vaYvtGv+vGgsUaBY4YVrB9kDtRKJQCwQbzYzzrlwtNH4rbwDLcyWlNUdxaYNVb9jZ4O5jhWhGNCEj6qpvfSRYCy+LQw5iE/nGQzBD7EWBuA4z5bEo80OsI/OfA2spJDB38XBp381oy2WaFf0cFRQoy9bCNqc5Yuh66qGKI8YbIyjn7dpa5qhxZlGuHLo6xsFm/o1hbZrt2jHa2hyV9J8g9/zMlIZ+Ft9zqt1guLD9vqymMyx/q5catIP76Hg6u2IjUAwfe2+33aeYcBYKIpa7LvyxF4t4vU1aC6Dyk27cX20CR2IpcqQmJYuB8oSh6YtlRmgMHDb+4a7DD9NBMzc4QM8br9Mcwb2p33mHiGpitkHa4ZIHNOuzaHSeQ3ZGIkITIKs85Nl1yBVlD1N9PBBwIbytnf1DfoljHXYyZzUT5PnXnHITMVpv7AnUMpioD2ePEX4pCAD+C7W8KQESUeLxk+WVK1w2tRlxMnVhpNGYM10ab7PoQzPqrstNWOmS/lGR6B1fDq65esz/sBZUGiHsAczZ1AAa65c3AzHqrzw1mc1oxerMWl96XohLbbqccvt9N6PLOT8Xz3d2n/g+kXHvc5H+5w42bQLsEQKxzoivHyZx3pysmVISQMzDlEaftCc+5a+q/O85jB/t2SKyUEwlkqdvn5NNN
 QpXAEe/x
 Hwuut2tTPTFvIk3F7RbPg0f8M2sEUTKl/VAG5O31snvSOoKqWUNjAyTDt+rPSopVxiavjUjG+Zixv7USXMwxO4Mh4Ip1fhJLffLti40AdHayZ0aWf0ymzaTF3v2+8Jx2MCl/RUoZ8W9UN5glKXXDghHu118yosrX2l9SA3Dmpyq6fDKhfiu65caGdfSIO8TpTJ/Yetazz33cg1RVRgkRhdcjIaDYYxZRdIviXnH7nhLfmc0Y8H1yvRflaKeeapR4PRWdlJYwBgPobGjo0TX+6ROiF9pfdj5phXyoa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers pass 0, so let's drop the parameter.

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/x86/mm/init_64.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index d57f29ca23a5a..69e36f02a663a 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -1006,22 +1006,19 @@ static void free_reserved_pages(struct page *page, unsigned long nr_pages)
 		free_reserved_page(page++);
 }
 
-static void __meminit free_pagetable(struct page *page, int order)
+static void __meminit free_pagetable(struct page *page)
 {
 	/* bootmem page has reserved flag */
 	if (PageReserved(page)) {
-		unsigned long nr_pages = 1 << order;
 #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 		enum bootmem_type type = bootmem_type(page);
 
-		if (type == MIX_SECTION_INFO) {
-			while (nr_pages--)
-				put_page_bootmem(page++);
-		} else {
-			free_reserved_pages(page, nr_pages);
-		}
+		if (type == MIX_SECTION_INFO)
+			put_page_bootmem(page);
+		else
+			free_reserved_page(page);
 #else
-		free_reserved_pages(page, nr_pages);
+		free_reserved_page(page);
 #endif
 	} else {
 		pagetable_free(page_ptdesc(page));
@@ -1060,7 +1057,7 @@ static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
 	}
 
 	/* free a pte table */
-	free_pagetable(pmd_page(*pmd), 0);
+	free_pagetable(pmd_page(*pmd));
 	spin_lock(&init_mm.page_table_lock);
 	pmd_clear(pmd);
 	spin_unlock(&init_mm.page_table_lock);
@@ -1078,7 +1075,7 @@ static void __meminit free_pmd_table(pmd_t *pmd_start, pud_t *pud)
 	}
 
 	/* free a pmd table */
-	free_pagetable(pud_page(*pud), 0);
+	free_pagetable(pud_page(*pud));
 	spin_lock(&init_mm.page_table_lock);
 	pud_clear(pud);
 	spin_unlock(&init_mm.page_table_lock);
@@ -1096,7 +1093,7 @@ static void __meminit free_pud_table(pud_t *pud_start, p4d_t *p4d)
 	}
 
 	/* free a pud table */
-	free_pagetable(p4d_page(*p4d), 0);
+	free_pagetable(p4d_page(*p4d));
 	spin_lock(&init_mm.page_table_lock);
 	p4d_clear(p4d);
 	spin_unlock(&init_mm.page_table_lock);

-- 
2.43.0


