Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25D14FED9E8
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9256B6B0095; Tue, 17 Mar 2026 12:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D63A6B0098; Tue, 17 Mar 2026 12:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A3FC6B0095; Tue, 17 Mar 2026 12:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6580D6B0095
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:57:28 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 15CD057B53
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:28 +0000 (UTC)
X-FDA: 84556160976.05.EDA31A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9243B40012
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TfqEnA3R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773766646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7t1Jw5GjIB9edfdJuuqX9jN3Tcvwni857/ZIX3CbbFA=;
	b=mYv7eOKiy5IJnBb7+Y1Hbw/PvnEXHa3biK/55d+V58dR0JlPKaCM1hUNTocxva0LNAl0aH
	nKQ0hUzJ9MRipngCFBpa23xU0RucVlhrvJKJitDO+oTgy2Fe6//OGV60K7bXRkNeFi/uf7
	NzzCteeO2P2bktPGdcHUdNvvya8vicM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773766646; a=rsa-sha256;
	cv=none;
	b=e2Zbh+hJ8NcoaME2Z/KoqJ/Mw6651RxwosEbbWuqSEHPAEnlPec1fXUzhBqu4XZhcYHmK6
	Zst2yX1y5DPiNJrke4W2/TLaQQp6KmuR8YUfVjrH9rquPeA2Gn+Nb/Lh8YfcOBeKy0R/kh
	/DULK4ZdLJmLqASI0QVZ68oxnDbnN9Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TfqEnA3R;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0D26560128;
	Tue, 17 Mar 2026 16:57:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A106C19424;
	Tue, 17 Mar 2026 16:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773766645;
	bh=H5NeGoGk7dbqwybjxssVKWZK8p0cPYZ7svk3+pfmI+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfqEnA3RRI2GR64AaLDZJghUOrYprRGXpJO4o+UpvkWcZmVSarEz8k8fpIJgG5QbS
	 D3VfKBHRKbBTr10pB/oOmHUFA7qQ2HBQyjfDS4UeSFVudgrF/w9vGSBSY28mDGCoja
	 +rDJ2tlgF5D3Y1YwOyS1HyxhCqpw9M3zND73l+ZGBKrkOjCpRTa9OkDOtd/XwUFZ/S
	 eGr6wJTAX3t69ECmcsJkKl9IMoWP4xi5JQHPB31BQyWKRiUjD96q/i2/rmnEs3r/tk
	 z9xCdDVNjkeLWMBWrp1LMzDrZ0/fGKYSOaRd+QznYwA30aeGOAEz+vKwdBhEAShFBa
	 oT5ZjdLYAvaYQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH 06/14] mm/bootmem_info: remove handling for !CONFIG_SPARSEMEM_VMEMMAP
Date: Tue, 17 Mar 2026 17:56:44 +0100
Message-ID: <20260317165652.99114-7-david@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260317165652.99114-1-david@kernel.org>
References: <20260317165652.99114-1-david@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9243B40012
X-Stat-Signature: 6k5aygpjt6h8s5sr446y9y7geydg3kct
X-Rspam-User: 
X-HE-Tag: 1773766646-511125
X-HE-Meta: U2FsdGVkX1/lakPA5beke/Cu5tfXY5e+RPjgd8VzBQFZgv/721OHdwKEB6kCnmZj6GvInx0nqU/soyyqOOmFaWSqp36hThFMTTSOxkmhgvEPMYLDI+qV54jeUxoEfk1AeBOuB2GmJLPWjjD0QYBs9ZaIBOjPbfj0vtNYFdWbmG/Pn6hzdKQ9LbD2qdp/PWdWVaDzhUfsG8iyOfKze4kELHIFwwGdze0WiA5wkYkkxm+Bj/D6qpmcszZ4TxLWQjGSQ0vRipMjPcQRODTsFPXcYxoFfg/tgRxO1BOaA1BSyKZN6E7o/OYR0JuJNy94pMx92r5WAhFexqRYbp8bcMUlPL/P5gc9933Cx3fYuIf3cJKAeQyZqUOMZbI8ChaS0vZHPu3QZ7+2FBWxfnw3WUQQFkumz16c38NVNZ5nysxWe0BbuQNMrIlBBV2lKejs9zXrNSfKJushs078LWFBNbWcBP1M0MGMibQELlxw/IOmv7NF8gyYE0skWhvTw2t5M3dS0LQoaABra47CIfjXPHeKAgnZWOcMjLVaWZMsoqHk88QvoR9116QEN4oWCmgMI+wHLE91XZj2trG5zaLWCoeeCvO4spPMlYjtCnDJ0RbypVuola4aSpNeUkEtzrBm1G35dcO4jNaNFZVrX/VkZOcCwlsWyvJ/7ExdUf3hIPWVmM2pBQDU61EEHpSOYCzjxsit8B0bJSvN5c2XgBvQZBwA2L7mZlh2E1JSrmndbz1oiCEEgdQe8CeZUYX05h8CSrG6mMt/fjXTRUAocWTiE7dEuUiWgp8Opq0bzLgKqzqIHh7ldUR7p7CxJ2o9Wtt9hT7Cxrg5RsjtAxZM2HU2io4XqgbMaeHQUr/uKHA3JPLTr3Em3Tkmad2UMIzlcoO5loDiU/d9d8ufZNZd7CA2yTqUqNwHdzOKx9QsP+Kc3kaHGv8oCB5XH2q0CX7BdcyCaRPx4CyxKiSgdXRnL/qcCn/
 5PkzaBLR
 /7n+LCLgTkz/6M8KUxR0DCnihXoFggK3jTrEDSWWMavTOySJrOa2GOuON657H0jFZf5qktFggOneB+hnKAl8+UkZQzMje3qYrnPE8j2a7xKxuazf4C0bLt3ZbdrZqV2nU5H8fqloZr9JcME//A/XlLXGd87XPIfsFPfRoLRlaUvTTABURq5pNctszZxE2ujqgSxwiNrbrsBtf2I0DtgAzovKSXIgy3nUvV+lNvgqgf1ZImM1pajNG0Po6YArSzu9jKGbsPRfmp7YczTW16zRuFkjk4aivcEA1ARxP1PPFRoXl7YbwtnNhJJxApYkoEp3PgJTwain+aDBDdms=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is not immediately obvious that CONFIG_HAVE_BOOTMEM_INFO_NODE is
only selected from CONFIG_MEMORY_HOTREMOVE, which itself depends on
CONFIG_MEMORY_HOTPLUG that ... depends on CONFIG_SPARSEMEM_VMEMMAP.

Let's remove the !CONFIG_SPARSEMEM_VMEMMAP leftovers.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/bootmem_info.c | 37 -------------------------------------
 1 file changed, 37 deletions(-)

diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
index b0e2a9fa641f..e61e08e24924 100644
--- a/mm/bootmem_info.c
+++ b/mm/bootmem_info.c
@@ -40,42 +40,6 @@ void put_page_bootmem(struct page *page)
 	}
 }
 
-#ifndef CONFIG_SPARSEMEM_VMEMMAP
-static void __init register_page_bootmem_info_section(unsigned long start_pfn)
-{
-	unsigned long mapsize, section_nr, i;
-	struct mem_section *ms;
-	struct page *page, *memmap;
-	struct mem_section_usage *usage;
-
-	section_nr = pfn_to_section_nr(start_pfn);
-	ms = __nr_to_section(section_nr);
-
-	/* Get section's memmap address */
-	memmap = sparse_decode_mem_map(ms->section_mem_map, section_nr);
-
-	/*
-	 * Get page for the memmap's phys address
-	 * XXX: need more consideration for sparse_vmemmap...
-	 */
-	page = virt_to_page(memmap);
-	mapsize = sizeof(struct page) * PAGES_PER_SECTION;
-	mapsize = PAGE_ALIGN(mapsize) >> PAGE_SHIFT;
-
-	/* remember memmap's page */
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, SECTION_INFO);
-
-	usage = ms->usage;
-	page = virt_to_page(usage);
-
-	mapsize = PAGE_ALIGN(mem_section_usage_size()) >> PAGE_SHIFT;
-
-	for (i = 0; i < mapsize; i++, page++)
-		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
-
-}
-#else /* CONFIG_SPARSEMEM_VMEMMAP */
 static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 {
 	unsigned long mapsize, section_nr, i;
@@ -100,7 +64,6 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
 	for (i = 0; i < mapsize; i++, page++)
 		get_page_bootmem(section_nr, page, MIX_SECTION_INFO);
 }
-#endif /* !CONFIG_SPARSEMEM_VMEMMAP */
 
 void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
 {
-- 
2.43.0


