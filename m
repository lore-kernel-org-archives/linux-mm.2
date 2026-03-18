Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56D89103E164
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 11:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF82F6B0182; Wed, 18 Mar 2026 07:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCFEA6B0184; Wed, 18 Mar 2026 07:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABF2A6B0185; Wed, 18 Mar 2026 07:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B79A6B0182
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 07:00:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4510D1B86AC
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:00:15 +0000 (UTC)
X-FDA: 84558889590.23.B7E172F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7B3EF2000C
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 11:00:13 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qrp1DZft;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qc4shM6MtZIhoCZ+zF8ycWGVEtarVviYhPLaz5jTIyo=;
	b=1iDCg+/LzykAzmis9ZQPrJLt7IZLcrhD7gFUcEOeRPjJF9zBjeXgmrJmKGYQiMmyJABVqc
	9ZCEpD/2SGdw0r9IYDEMjiL8+NetMwWspz8IvSs7pbzSjn68cMdHHwL2T7UaflB+V+iOMy
	NF3//uM2DvD0peZZEtiUU5Dv5WnKOTE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831613; a=rsa-sha256;
	cv=none;
	b=APICpQ2pdgp86DtDnoS2ILzCjF9F9QEqLG4FFjQ7Zgw/iCSnDQBtWVORMx0V6QkmrQpp7J
	TZa+w0My+zouOEbuUIuLbv2ZjBWSlZSYSJbZvs6t2vE+lfyyXQ715leVEZbZoMnSnC0YKb
	YOwuJo1ISQ9r7ntJZnA4+v0PTrly3YY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qrp1DZft;
	spf=pass (imf03.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E2F1643E5B;
	Wed, 18 Mar 2026 11:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E442EC2BCB3;
	Wed, 18 Mar 2026 10:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831609;
	bh=uXF/4wNn5jtAs8jN3yAYT5aUpVgj2iPt6T43Ush51L8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qrp1DZftNL2mANGaUskZ2ndurPvv1Q5xEZdHwqNMTXTU49FdJOksisWCNrwlXC6Ur
	 af1XIUzkZN16ANirbz+13SpX4Ycz2NHapzQwFaoBxPeYsZxWBk7kNquGT+gKC0UPal
	 1odcL5f7nAH1h90rlpECzOJP2yoKQZ8CZiZWUIZGJZhr5om6GULjPnRiyF5QjirbGG
	 nNG6QPMx1+15rdYzlM0CO+nI6MMsPVBSOXQB4ZINbwOikGfe9GWbWqT3NJ+AtTnIMu
	 Wq+pDjER0gzCMZLFc44nIa/fO0bSvNdhsToGSVGPjBOVfA+qN49Eqsy8N1SkE37UMo
	 GOPaLPgqmqj5Q==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 8/8] memblock: warn when freeing reserved memory before memory map is initialized
Date: Wed, 18 Mar 2026 12:58:27 +0200
Message-ID: <20260318105827.1358927-9-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7B3EF2000C
X-Stat-Signature: ybg8ch713ayfyzffbtbrdjq71iuwfzsg
X-Rspam-User: 
X-HE-Tag: 1773831613-649012
X-HE-Meta: U2FsdGVkX18ZH1IkoMG7WkHA9VpW1vQFqgbwnd/4xOUUjwoRYfB/WGRC8EE1RSquDQ+ZzMpVJ49Oa+ysglqbLBetc2ZzNuIsmLak/rStT2x2WnXuvFLSVxqviPchQQMXu+rc6jXyPhx1MuFUedrs7QfkNrOR/ra2c8juaErxLaYRSwQyXlV3k+e2yS79OlbtmoRdB+EgZj5fXV0OmirvvHox5qwN6xn2nR0CxItRUgqJ1LTnovn0l0gKdvs5+mz1gE0JfB1/jS/uqNk8YEOL0RQMM6Q8oN1qwUZnX3ej0HlPV7Z0OvRrZXOsJvlMfr4b920P7icaNkkihBmgslKxLm0fown871MtKmgo+vXJddpWIW7c9UF5rqreVEkJg1l5mdPR9rkeKFIpxq0iEBawWrHLtJUmr3qhPgUQrWSpDncQHCBI9ueyu3kwVC5tDwRfsmaxIEMnMcWR2pW5385vSBnLOzr/veWsquSCrhUGseS7GYKVKpSx4HjOeEKq+upb7hClz4TQuFQqJptz4FWRAUmUh29JyQtgp/eWv4m39+DUOlubksZ91Il20bFAxR2a/H7LTojTVJbwFLyMKLh8MGM8cL7DGcf7fgJ5Y4oQAqWB1iiWdBsVf70pOtGaJaa7xDWmPoD4wsbBSf/dv2Un1TfeTCRmvYHhkIc7lIrW+PAr6koeyfrpztu5qH70t4pPoVu9wyCoLsN/u5oKjnc589uVJmeENuBVTxWHe+psb7XAkGp1tPMAVfbChvqoxHXgYyAPhc+7fSK/KmjxsGTsOk4EHaldgFtBFwmz4Vzg7msOTKqn3uaFnxPd/mfdRXqQS62MLU78rqTwzYCcJGyqf7mSEKeh/P4SF2UCbmgE0xFbgbb+b0Slf9Fx2Kw5RDLEMISX2uUvqiiuuM9uUm1PAnMhMHq8xjkENp2TDfuEdt3oLkc4yS62zUCOvPNiOYmm0gdutx2jCrqiqGo5iB6
 QbNOXPlw
 9vh7s3RaeJw257Ht2mOVJi66cuKszgctAkKrZQcsCeJm4oeCj47VVVovF9OUcmwh7MRsoXOb6s+s1QjCWXbryC4vTmIlVAdJ7oBN6Nq5NTRoL+HLyBc7pcCs61W0oAGBiIKKD/MD5Maq+orFSvV0pUjDoezg5aeh0SC+PGkrsEzirrMx7MJGhxUyTvsWyXYGrro+cuyz8hHlq/ZXL//A/w1YANOWlWIWw8DaV70JS0brxQJEWJLHeNq9R8e5DqKpup4gM+2lrvpSUFS34AWK6F4aDbTbajmpzjVqP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, freeing of reserved
memory before the memory map is fully initialized in deferred_init_memmap()
would cause access to uninitialized struct pages and may crash when
accessing spurious list pointers, like was recently discovered during
discussion about memory leaks in x86 EFI code [1].

The trace below is from an attempt to call free_reserved_page() before
page_alloc_init_late():

[    0.076840] BUG: unable to handle page fault for address: ffffce1a005a0788
[    0.078226] #PF: supervisor read access in kernel mode
[    0.078226] #PF: error_code(0x0000) - not-present page
[    0.078226] PGD 0 P4D 0
[    0.078226] Oops: Oops: 0000 [#1] PREEMPT SMP NOPTI
[    0.078226] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.68-92.123.amzn2023.x86_64 #1
[    0.078226] Hardware name: Amazon EC2 t3a.nano/, BIOS 1.0 10/16/2017
[    0.078226] RIP: 0010:__list_del_entry_valid_or_report+0x32/0xb0
...
[    0.078226]  __free_one_page+0x170/0x520
[    0.078226]  free_pcppages_bulk+0x151/0x1e0
[    0.078226]  free_unref_page_commit+0x263/0x320
[    0.078226]  free_unref_page+0x2c8/0x5b0
[    0.078226]  ? srso_return_thunk+0x5/0x5f
[    0.078226]  free_reserved_page+0x1c/0x30
[    0.078226]  memblock_free_late+0x6c/0xc0

Currently there are not many callers of free_reserved_area() and they all
appear to be at the right timings.

Still, in order to protect against problematic code moves or additions of
new callers add a warning that will inform that reserved pages cannot be
freed until the memory map is fully initialized.

[1] https://lore.kernel.org/all/e5d5a1105d90ee1e7fe7eafaed2ed03bbad0c46b.camel@kernel.crashing.org/

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/internal.h   | 10 ++++++++++
 mm/memblock.c   |  5 +++++
 mm/page_alloc.c | 10 ----------
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index cb0af847d7d9..f60c1edb2e02 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1233,7 +1233,17 @@ static inline void vunmap_range_noflush(unsigned long start, unsigned long end)
 #ifdef CONFIG_DEFERRED_STRUCT_PAGE_INIT
 DECLARE_STATIC_KEY_TRUE(deferred_pages);
 
+static inline bool deferred_pages_enabled(void)
+{
+	return static_branch_unlikely(&deferred_pages);
+}
+
 bool __init deferred_grow_zone(struct zone *zone, unsigned int order);
+#else
+static inline bool deferred_pages_enabled(void)
+{
+	return false;
+}
 #endif /* CONFIG_DEFERRED_STRUCT_PAGE_INIT */
 
 void init_deferred_page(unsigned long pfn, int nid);
diff --git a/mm/memblock.c b/mm/memblock.c
index bd5758ff07f2..780e70d4971a 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -896,6 +896,11 @@ static unsigned long __free_reserved_area(phys_addr_t start, phys_addr_t end,
 {
 	unsigned long pages = 0, pfn;
 
+	if (deferred_pages_enabled()) {
+		WARN(1, "Cannot free reserved memory because of deferred initialization of the memory map");
+		return 0;
+	}
+
 	for_each_valid_pfn(pfn, PFN_UP(start), PFN_DOWN(end)) {
 		struct page *page = pfn_to_page(pfn);
 		void *direct_map_addr;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index df3d61253001..9ac47bab2ea7 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -331,11 +331,6 @@ int page_group_by_mobility_disabled __read_mostly;
  */
 DEFINE_STATIC_KEY_TRUE(deferred_pages);
 
-static inline bool deferred_pages_enabled(void)
-{
-	return static_branch_unlikely(&deferred_pages);
-}
-
 /*
  * deferred_grow_zone() is __init, but it is called from
  * get_page_from_freelist() during early boot until deferred_pages permanently
@@ -348,11 +343,6 @@ _deferred_grow_zone(struct zone *zone, unsigned int order)
 	return deferred_grow_zone(zone, order);
 }
 #else
-static inline bool deferred_pages_enabled(void)
-{
-	return false;
-}
-
 static inline bool _deferred_grow_zone(struct zone *zone, unsigned int order)
 {
 	return false;
-- 
2.51.0


