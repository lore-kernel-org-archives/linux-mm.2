Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C23FE7DEF7
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 15:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D15D26B0111; Mon,  2 Feb 2026 10:58:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBFFD6B0113; Mon,  2 Feb 2026 10:58:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2366B0114; Mon,  2 Feb 2026 10:58:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ABA346B0111
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:58:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F10BC095D
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:57 +0000 (UTC)
X-FDA: 84399975114.01.A737509
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 84AE61C000A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:58:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CZtz06q0;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770047935;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ZaBLJBmhdtK5AWTlqZvPeYcLY/m8rcAD9TYtu6o61E=;
	b=h9GMXdjRB1EcG3kr+xrs0pZk6s4wpP5qJDBASeSfu+f+qT9FQM/fEGcr2ckn4tbiuNqgNq
	IUHT4xNxIw2fuC0WsiXy4GKj4R87aPCzlXW+u9MeiHyQF1Zr1Xc+LNnzatpGiDk7uxAwTv
	2tNLMslJaqihc2MHZnqJ6uuU52NPnyg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CZtz06q0;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770047935; a=rsa-sha256;
	cv=none;
	b=x8bYWRZXcvbjsTiEWCoRRrlQvyYRhGal0jiBy5TSGgIMG0z3QvtzQ4L0pGBnAYBPVIgazZ
	6iqdd3NvodXcvAoyDOauM5y9NQW6J1G2qnPfJCZxuL7jWMCmrMndLi7KUZb6w4YG5/JWGo
	IrBBbLREVQSqTg32kat8h1000MSRpAU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 131DC600B0;
	Mon,  2 Feb 2026 15:58:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A693CC116C6;
	Mon,  2 Feb 2026 15:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770047934;
	bh=X0JuAHEku0e+NeEYY+UFCEJtQB+xpNwKPHNJM8wJov0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CZtz06q0vGmYwb8hRFv2Wn3BR/5FXDs0DQZEZZklnIqYSYest7pBTN3oeL/mkQ/AP
	 V2DfaLKFQJi8aF+7DtEDsyswbdtDegT4v2ZjAJvFMc0d4MWV19koG5ezMhpeT5+6Pi
	 ItIOoxr7E4I7G9gtLKd7I6Q5M4NoV3leG9aIdU1xWbBgxfsKojx0KS1MsMymYPPTQp
	 u+G6ju8jZZ7ze0zroH6RoJcGFidEw3D4h41tcP3CP8+4gatjZuNsykx3CUuiTRAg/3
	 8XNk0y2wXlRTsdql+oR+o6pQ0sURiOENnawoLQOavYKRrCAp4vIvtmOH8UWB9KMxwJ
	 FeD9CsB6LWQqA==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id CD0EBF40069;
	Mon,  2 Feb 2026 10:58:52 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Mon, 02 Feb 2026 10:58:52 -0500
X-ME-Sender: <xms:vMmAaUDs_w_QA5mqnBBoNpnBVE5aIRy1iq3_qR2b-1WGXbMU6a4XxA>
    <xme:vMmAafsg6lhBspUe0facpeZJiON4XHs_EpZZf997zRKS38d91-TojLRgBK-Ak_9Dm
    bdG4LC0Dvx9Xh9l1NM1xdE3SC08PB251cNEJBSWF__gBTyWitY-UwE>
X-ME-Received: <xmr:vMmAaRtuY0ST6mw5aOMFYZtc6RlTaLZcaiqVPBymsUCx2-1jP_uYhQgSJdcMpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddujeektdeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffkefffedugfeiudejheefleehteevtefgvefhveetheehkefhjeefhefgleej
    veenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopedvkedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhi
    ugesrhgvughhrghtrdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdp
    rhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvh
    grughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:vMmAabp2SZvoTdxbCCz7E69ywYsgb7TqE3v_IfeuILQV1FfRUXEbcQ>
    <xmx:vMmAaVOTJcNRcLHlmKirHp9JIYOhTMeULrZQ7vzRuqHmej74emzSeA>
    <xmx:vMmAaRnQKyCRRgu1ssJi3iPdXuygfi5Ur6LSNEiv4qtiy6MRbWvRng>
    <xmx:vMmAaXt4D8GLZvraqQBXo7jPv1FQaDNKhI9Wnilbtezn6_zTrM6g4Q>
    <xmx:vMmAaYmuQEOwOg4ks6Dz62QbjtRwl7nI7g8KoSABOuP99K47oWvdlCAh>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 2 Feb 2026 10:58:50 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>
Cc: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv6 16/17] hugetlb: Update vmemmap_dedup.rst
Date: Mon,  2 Feb 2026 15:56:32 +0000
Message-ID: <20260202155634.650837-17-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260202155634.650837-1-kas@kernel.org>
References: <20260202155634.650837-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 84AE61C000A
X-Stat-Signature: xcxsesjejqppmq9xaotnf5bq1uz8fuy9
X-Rspam-User: 
X-HE-Tag: 1770047935-234117
X-HE-Meta: U2FsdGVkX18GvQ2gyYFBEpBuXN1kc6T51fuIdjKwyLpC2m6ujLyCAgiRdocJeHe0kbnqptIAcjs7Q8rjzLhttUHcFP0OFHzggSpn+2vwDYqfM2fYhL0j6/N4b+TMM1CVLw8BYa2vC2SmsnMXuQSPn3NyXhb6cvtpj3+o1Snat+cWt3k12UsZdp8+oyX0XkcdG3pWfpHvKv2gIAf/zHJBiRKVU0vGUIndTX7D0jwFmaY9PnAwsRhrmHG23gW7feIyIRPO6apL+GiURgcJ3+1XbSkHaz7hwEsXT3CFzfvPxqhC5y6KpvzcGxIlYk1cq2pxDrOlam4Thb8FhMG5UJN2LsyV/xaG5zvI/VXGuES1g7lSy+oMh2swD9Plul0ljQJ4JuMq3HjhVHPEyZPwWIWHYIRegphTxIpz8RP9Duq/0MHOKkgG6rC59981t5I0GMlYf6Tf/3xf2xLZMhgJSKRweRjAdxX3jDeyGZ6Oc4jwD6KBcm0eobrQkEOsYg5oGNACAHu4XAj2cYtXERljQiD/732ec5NbyO3+bx+wMWBedipX+oHys9z3bpkqmZPOerOaEtv63vDun01kQv8mC3fzoBEKkBLURVbDaz52aOjHEwPeHchajmr1I+96Pc97szRHeZwmA4S4cttB9w3UVy5Tyziw0h+SKctovUHt5SM1drABcIcLnjiVY3HqXX5eDhK6+j/AxLaBzlhoffaWHnbANVjMX/6xkfjzh4ZGX/pn4Yns43rySPwTldGBEXYVOgRZGTT/LBXeqsj3h2G/jTrOIrSqxQFu4t6wateY75W8YJl7g9V4YDB3IsqbpTKuG/hU9p2lO4mj0eyB0mxOlyRFI2s2HrfJCOLnamRxkrg/5gutoiN4HDkkmMl6pWvIYgdLAQufnOPMJxyIRwYcm07cISBSiRXxXE+fAPYuVeOQUeWf866vTldx7VOIe3Bfz6adFCMGQLbkHde4FWHUYYr
 IxEkRXGx
 FaHrDJ0L5X04fYZzGOy9f7HAoaRGvAKlJdAbiA2WX+4guOZpKFZgRtPP22MbyJRWdhUFL8+sllr3V0wzcn/6iM0ik7tyRZeh1kOl0dUkdcmafumKpN/wlRkWwog20HhLr8mnXKLHvWBeWw8OEhYen1PQlBvYavzfIlbwBk8mraDrIAdktkJothL46UOFe7z6zijF7feBGFkM0MdtEbyqAk2ktCnzZ4vlpv89IdfZh6kH86PTfq7F0lY/YxwlAKNwJOzlrloF8BiqwCMUdt0tBpl5PCaO4rU6eI9Rzx6I3LlJKUUlihlUP5qja/LNWbPdeqHwH46FQ91tnsqoQ5uHbGIlhtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the documentation regarding vmemmap optimization for hugetlb to
reflect the changes in how the kernel maps the tail pages.

Fake heads no longer exist. Remove their description.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
---
 Documentation/mm/vmemmap_dedup.rst | 60 +++++++++++++-----------------
 1 file changed, 26 insertions(+), 34 deletions(-)

diff --git a/Documentation/mm/vmemmap_dedup.rst b/Documentation/mm/vmemmap_dedup.rst
index 1863d88d2dcb..fca9d0ce282a 100644
--- a/Documentation/mm/vmemmap_dedup.rst
+++ b/Documentation/mm/vmemmap_dedup.rst
@@ -124,33 +124,35 @@ Here is how things look before optimization::
  |           |
  +-----------+
 
-The value of page->compound_info is the same for all tail pages. The first
-page of ``struct page`` (page 0) associated with the HugeTLB page contains the 4
-``struct page`` necessary to describe the HugeTLB. The only use of the remaining
-pages of ``struct page`` (page 1 to page 7) is to point to page->compound_info.
-Therefore, we can remap pages 1 to 7 to page 0. Only 1 page of ``struct page``
-will be used for each HugeTLB page. This will allow us to free the remaining
-7 pages to the buddy allocator.
+The first page of ``struct page`` (page 0) associated with the HugeTLB page
+contains the 4 ``struct page`` necessary to describe the HugeTLB. The remaining
+pages of ``struct page`` (page 1 to page 7) are tail pages.
+
+The optimization is only applied when the size of the struct page is a power-of-2
+In this case, all tail pages of the same order are identical. See
+compound_head(). This allows us to remap the tail pages of the vmemmap to a
+shared, read-only page. The head page is also remapped to a new page. This
+allows the original vmemmap pages to be freed.
 
 Here is how things look after remapping::
 
-    HugeTLB                  struct pages(8 pages)         page frame(8 pages)
- +-----------+ ---virt_to_page---> +-----------+   mapping to   +-----------+
- |           |                     |     0     | -------------> |     0     |
- |           |                     +-----------+                +-----------+
- |           |                     |     1     | ---------------^ ^ ^ ^ ^ ^ ^
- |           |                     +-----------+                  | | | | | |
- |           |                     |     2     | -----------------+ | | | | |
- |           |                     +-----------+                    | | | | |
- |           |                     |     3     | -------------------+ | | | |
- |           |                     +-----------+                      | | | |
- |           |                     |     4     | ---------------------+ | | |
- |    PMD    |                     +-----------+                        | | |
- |   level   |                     |     5     | -----------------------+ | |
- |  mapping  |                     +-----------+                          | |
- |           |                     |     6     | -------------------------+ |
- |           |                     +-----------+                            |
- |           |                     |     7     | ---------------------------+
+    HugeTLB                  struct pages(8 pages)                 page frame
+ +-----------+ ---virt_to_page---> +-----------+   mapping to   +----------------+
+ |           |                     |     0     | -------------> |       0        |
+ |           |                     +-----------+                +----------------+
+ |           |                     |     1     | ------┐
+ |           |                     +-----------+       |
+ |           |                     |     2     | ------┼        +----------------------------+
+ |           |                     +-----------+       |        | A single, per-node page    |
+ |           |                     |     3     | ------┼------> | frame shared among all     |
+ |           |                     +-----------+       |        | hugepages of the same size |
+ |           |                     |     4     | ------┼        +----------------------------+
+ |           |                     +-----------+       |
+ |           |                     |     5     | ------┼
+ |    PMD    |                     +-----------+       |
+ |   level   |                     |     6     | ------┼
+ |  mapping  |                     +-----------+       |
+ |           |                     |     7     | ------┘
  |           |                     +-----------+
  |           |
  |           |
@@ -172,16 +174,6 @@ The contiguous bit is used to increase the mapping size at the pmd and pte
 (last) level. So this type of HugeTLB page can be optimized only when its
 size of the ``struct page`` structs is greater than **1** page.
 
-Notice: The head vmemmap page is not freed to the buddy allocator and all
-tail vmemmap pages are mapped to the head vmemmap page frame. So we can see
-more than one ``struct page`` struct with ``PG_head`` (e.g. 8 per 2 MB HugeTLB
-page) associated with each HugeTLB page. The ``compound_head()`` can handle
-this correctly. There is only **one** head ``struct page``, the tail
-``struct page`` with ``PG_head`` are fake head ``struct page``.  We need an
-approach to distinguish between those two different types of ``struct page`` so
-that ``compound_head()`` can return the real head ``struct page`` when the
-parameter is the tail ``struct page`` but with ``PG_head``.
-
 Device DAX
 ==========
 
-- 
2.51.2


