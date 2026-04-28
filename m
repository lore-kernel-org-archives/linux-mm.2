Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEE5DFF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 08:19:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1BF646B008C; Tue, 28 Apr 2026 04:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196C66B0092; Tue, 28 Apr 2026 04:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D40C6B0093; Tue, 28 Apr 2026 04:19:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 01E156B008C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 04:19:12 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B2348BD55
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:12 +0000 (UTC)
X-FDA: 84707264544.15.81114E7
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id C17FC14000E
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 08:19:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DPkDM4ij;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777364350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Odp+99JHCbpwHHM6ds3EE8rv22wzvZDnJ+uzSMS+VHA=;
	b=lh4jciAqiB2O1a31RwnC/bEwakSgTXLQEA/4TrAQ8zCm78hBFsnyJ4bJcGyNYaAdOkPbUb
	zr8ijZ3dCgMyh8fqOyc8Kbuo+DKRdxVOqQvfYIrnKmgLpDbaDdP5v2/eGfW1qI0XKJD0ww
	P45bTBpSW1+m8WUh0IpTIUH7kH+ZBmU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777364350; a=rsa-sha256;
	cv=none;
	b=lK5h+2O27B/FIFla9qh5HMU/E1LcEBod/977qx5KJaEwc1lcgWiQhXkzUYWQkxOKd28F0G
	RFxyFmjFJ6VB+i/KCP7rIBwtd0wMVQ79AFaetOGtM70poyowZvgwdmWkDFFybGwRzMKBb3
	YMw2GW1ZY0gSY1fVU9WVEgCpqj5UTZc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=DPkDM4ij;
	spf=pass (imf26.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-35da8d037a5so5265755a91.0
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:19:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777364349; x=1777969149; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Odp+99JHCbpwHHM6ds3EE8rv22wzvZDnJ+uzSMS+VHA=;
        b=DPkDM4ijG4PVR+jV7E8/LyMdkP7SMoGmVydx/QjVH17VZo8b09Uax640gaD41/v+bI
         TR5IPgxX/XvV6ZTSQiZxAB3mpGJhf25eWqjLa0FxltQlTnJf0dbeX2y8JOnZRyU55EnW
         /ZB91jKQTA1Ny2whiGFLRdhAG5aElSsJ92lAhYPl5KhiCpKKANeFIxInQmULzkE+/iZU
         gJRDuuBisowTGWBgDg0ijcOykLadGSJ1+ge1FtfJLpSnGKuP+N++NFcrPfFl8lpAmxDR
         9CpKGGu4/4GuyuazkwPhUrry7ej8SeO3hcdo9Jwk31o6cTI6tqGtysNdt2Hm3T0hUj6D
         BgtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777364349; x=1777969149;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Odp+99JHCbpwHHM6ds3EE8rv22wzvZDnJ+uzSMS+VHA=;
        b=kvaAkSLCeWIRN8R7EyPFMbwtFAqq05cW+QY6/GhN7XUxrbupumz+j1FC/WT9lO1QAi
         XANSLRBN0c15tVaRgdEjAAUKwB1/T7zvWFm2YpMDkyDxCYcNnMgtuynbpezqbnsautta
         hjxOM741dv3KZLApoXkLdx+F8RvAPrlS9zJedYGl19EEAiqgzLQOg7G/MD3r8gqbfXCI
         Z3LpoVduWgNxAKLibcCf+qVSOsaaZxyQtdOrumZwy5mO2GCtbeja7hIM4eYTaUr7TPyf
         YR8K53gMWWanTjG9V3RaQ526mKtqTY/5b3hqps5xto31N1Uxj6INDrsaZ8qJ/XK2wTvG
         xAxg==
X-Forwarded-Encrypted: i=1; AFNElJ+jKVz35XYTFPOgaXFdPk3uAnshdEyNRDYBvr0WrlRQZ5QrMGtHJYETLO4U5pLenILYCsDtEMDlKw==@kvack.org
X-Gm-Message-State: AOJu0YxtqKJ8t8Vu/cPDkJCFfbwuENBTlSbRxkMLswJEyagWA/xye2zx
	b+cmADaACwba6gEeBLqlMxPqDtkQuBtAj3wA6Gl5uAcR/MFY3iORuYkSqFZ7lcPLzi8=
X-Gm-Gg: AeBDiesTDfrfZX5Eirvjr+K+foZbfNsaeV/3tX044L6edlM2Xku6UBmuXyran+GfAHu
	5OIG18GlHBWgtyiCJB9YNlqDtvhWlbIjCCES1hWl1Zhsz+PrMJY9V0cSxXWoz/1ZiFvFWJ9wIrt
	SekUFWTBF6zq7REVBUARlvOOadFitMXqd6MHjnxVTlxIK1iqGfyLvak3Wy8AbilnEHduDhbVRkT
	OHPZw5BroGpEBH3wCbwx+jqppueRTNZMl2l9C4bV6fe7hkfpIMB1DsVBL8Ao0YHGhrKYl2w45WA
	5mF5Sbt10wvwxXEb/s/ICBNKhVMH4rcoeYlHPi0D50lEa01ExIxZS7G9Go32/eocrfyJ07ZRkfR
	rmTY9B8ZO4n8tiPXPcZsgz4iOgbMGfoqteF6C+8e4yvUXUKKjpquQbHqoKW3JPmYJ+zXeHIbqDG
	wtlv35dff4DVv9uYjF8puj5NGknSHldKNECgX9AADxhmxw1Ei9JcZcbAA=
X-Received: by 2002:a17:90a:d64e:b0:35d:8fdb:4f26 with SMTP id 98e67ed59e1d1-36491f89e50mr2246840a91.1.1777364349228;
        Tue, 28 Apr 2026 01:19:09 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.101])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3649003650esm2181356a91.8.2026.04.28.01.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:19:08 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v8 1/6] mm/sparse-vmemmap: Fix vmemmap accounting underflow
Date: Tue, 28 Apr 2026 16:18:50 +0800
Message-Id: <20260428081855.1249045-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260428081855.1249045-1-songmuchun@bytedance.com>
References: <20260428081855.1249045-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C17FC14000E
X-Stat-Signature: o1jt7wy11zrgft57qiyh1tt6rug9zkoj
X-Rspam-User: 
X-HE-Tag: 1777364350-35475
X-HE-Meta: U2FsdGVkX1/89RFQqYXyb+Nzd1wMMHanT6A2j41CAeJIcl+8Wmt4iuzpx0K8LsPEYXu6286k+NuVdUNjxnn3k22WHhBQd0aTuH/oPcpTI3UUY8sG6T1cYcZuRX+Kw3B9uvODQD1mLSYcCFPxI2KB5/4OZlH97njAjxsw9sdv88HrrvYXwDsWCi/k6KqeVarY4wETzkjdkiRnHSkIL9OsJ0QTVBZGeiQazOVaG6NXbtCSdjgYfiIiQpEnAYSLXfUV1FPThBzD3w3s8qN1f/Esk4bgSEFFS2fwm8BEJm9xq2ca+f2cTZhlV/irlp73qMuZ9euFFN1TS5ZCi1fod0j+OUGjxT1PYWaMs+0LUkZrPq/XfLBX6mqo4fR74ySFth/xKluyxzxUFlxLL3T24encl8cuoeQHlT4oGx8mPk7yXMa8uqwRwimjYyOj4mgeIWmmagiORdRKhAFjLOuIRR7W+RnukKeQNPYpeEy1IMSHeW6hCcqKGSWaiZnHfNlqP5MG6NVzWTQIDxPsPkXICxONfb1b50hXMJCTCfjFxE9tdTdWs4/ygHZPQQ2YFgDnWPDvpa/vAn4NnJ/VnzGKcNrW5hHt+RKD3DtbF6gOtaa1PpFpwirJsI5ruKH480Gv7IsvnjTId4LFVC3IPPQojQ0DixdzTu5yLl2qJSKwwmEQxJXrPiSgv/+qOTka4zUOy8FAbhJOkK85SPtr5cLFE3jWJP5/MFqamVLdo6mSwTsdpvCm71+e1h1K9kadn/Wcc0HFe4od6hXJ4gRY1LPwp5tjnY54ioidgwEMB6CC27QG1ZLOMQVmNtwLjsarIf6SytugjkSKnGfTrCLbmbe3+UWNIraHg8zZNsRyFfnpOepyfAcIdE/BdduChPvUYKkN2f0GdpXDgms8RWgc6dnIwJngJJx7GU+tOKGFP9YoS/KI4xHv4GHFRcJe0PZPZSP7GeoHE5tjT/eBRHiHQ0mJVh4
 ZrrO9s/w
 DUT0LiBkXepyOnAcEktxv2iNUgxfaxQcWdDBPlvI26AS71g5u7hwRQPE6UdgyIDxl6cLzvrly4iUFOyv1HLG17HKn8mZiBN4XhN5HXDFv+Lx8dcMvB2iMEVK7GfjjWbXF7AFkxyTysnPS9EvLTKMeEuw4TL+iKN2j+p+GOLLzwbfiO/j63wI5ZPuckNUtQqlv68zdFwXC7qr/cRkDv/A6/TxL/VvC8DofXGYS3pJMCIJxKUwtdkDfANwnPO2k914TW/VpTqDnFyien7UtdEgtiI5cuVxkD8fSIEah/ThmzviDqV6yEX525sfl5orT6UtAPoBmSC/Reg90JIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In section_activate(), if populate_section_memmap() fails, the error
handling path calls section_deactivate() to roll back the state. This
causes a vmemmap accounting imbalance.

Since commit c3576889d87b ("mm: fix accounting of memmap pages"),
memmap pages are accounted for only after populate_section_memmap()
succeeds. However, the failure path unconditionally calls
section_deactivate(), which decreases the vmemmap count. Consequently,
a failure in populate_section_memmap() leads to an accounting underflow,
incorrectly reducing the system's tracked vmemmap usage.

Fix this more thoroughly by moving all accounting calls into the lower
level functions that actually perform the vmemmap allocation and freeing:

  - populate_section_memmap() accounts for newly allocated vmemmap pages
  - depopulate_section_memmap() unaccounts when vmemmap is freed

This ensures proper accounting in all code paths, including error
handling and early section cases.

Fixes: c3576889d87b ("mm: fix accounting of memmap pages")
Cc: stable@vger.kernel.org
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Oscar Salvador <osalvador@suse.de>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse-vmemmap.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 6eadb9d116e4..a7b11248b989 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -656,7 +656,12 @@ static struct page * __meminit populate_section_memmap(unsigned long pfn,
 		unsigned long nr_pages, int nid, struct vmem_altmap *altmap,
 		struct dev_pagemap *pgmap)
 {
-	return __populate_section_memmap(pfn, nr_pages, nid, altmap, pgmap);
+	struct page *page = __populate_section_memmap(pfn, nr_pages, nid, altmap,
+						      pgmap);
+
+	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
+
+	return page;
 }
 
 static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
@@ -665,13 +670,17 @@ static void depopulate_section_memmap(unsigned long pfn, unsigned long nr_pages,
 	unsigned long start = (unsigned long) pfn_to_page(pfn);
 	unsigned long end = start + nr_pages * sizeof(struct page);
 
+	memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
 	vmemmap_free(start, end, altmap);
 }
+
 static void free_map_bootmem(struct page *memmap)
 {
 	unsigned long start = (unsigned long)memmap;
 	unsigned long end = (unsigned long)(memmap + PAGES_PER_SECTION);
 
+	memmap_boot_pages_add(-1L * (DIV_ROUND_UP(PAGES_PER_SECTION * sizeof(struct page),
+						  PAGE_SIZE)));
 	vmemmap_free(start, end, NULL);
 }
 
@@ -774,14 +783,10 @@ static void section_deactivate(unsigned long pfn, unsigned long nr_pages,
 	 * The memmap of early sections is always fully populated. See
 	 * section_activate() and pfn_valid() .
 	 */
-	if (!section_is_early) {
-		memmap_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE)));
+	if (!section_is_early)
 		depopulate_section_memmap(pfn, nr_pages, altmap);
-	} else if (memmap) {
-		memmap_boot_pages_add(-1L * (DIV_ROUND_UP(nr_pages * sizeof(struct page),
-							  PAGE_SIZE)));
+	else if (memmap)
 		free_map_bootmem(memmap);
-	}
 
 	if (empty)
 		ms->section_mem_map = (unsigned long)NULL;
@@ -826,7 +831,6 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
 		section_deactivate(pfn, nr_pages, altmap);
 		return ERR_PTR(-ENOMEM);
 	}
-	memmap_pages_add(DIV_ROUND_UP(nr_pages * sizeof(struct page), PAGE_SIZE));
 
 	return memmap;
 }
-- 
2.20.1


