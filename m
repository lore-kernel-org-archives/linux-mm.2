Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E24D46951
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 16:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0FF66B00A1; Wed, 21 Jan 2026 11:23:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB816B00A2; Wed, 21 Jan 2026 11:23:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1D276B00A3; Wed, 21 Jan 2026 11:23:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B6C9C6B00A1
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:23:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 700EC8C4A5
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:30 +0000 (UTC)
X-FDA: 84356491380.26.E15E1AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5AB2840003
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 16:23:27 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KeqSdFyv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769012607; a=rsa-sha256;
	cv=none;
	b=PgnKkPd/NpaXUDRgjRtYTuKWY7E7NUzfx9Q/f7C9dzQTWG+k1VpeFE5evuzn1CCohNYpau
	lsQJgOvkDz2AJ6upf//SclW/C+JHjDnCWYRmVhghvWDKXoPWFn3X6BlTetlxcHNjaXPPRY
	m5yGffvWF6aRB/9aOgqwUCpYW8edl9E=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KeqSdFyv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769012607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wz4MBNlnHwH3bqPwVRbn5F23ABmEX3yOqEcelCTBQWU=;
	b=FjnuXCJL+7Cor+J51w/Kn7UKQ0rBNRaWjiNyAEjyFB47XDbRsOJcQymnhhwXWc4Xk+elD5
	GUSYpaVw1+MtQfPWiMKjSWo+hCOPUf3Thwwli/VW10sAQWI/fDEF6ajFuKie/0mmyQloYv
	pFRgazgZQcIQt89GLOhPiMF6DRyKm1g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 885AE417BD;
	Wed, 21 Jan 2026 16:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D68BC19421;
	Wed, 21 Jan 2026 16:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769012606;
	bh=HdI2DN25qqaNRHiMcOMwkD0s20/vCqB8MRYI0Frqk18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KeqSdFyvS6cNTRVxfX33UYyQG2e2Izn7CdCcnGoe8EDDoYkkxhnCrGWaQCMVwZY1A
	 VZUO3nlLmitH1EqMfaqNiQwpYihhnLRbfLc4J6u0EKuwbfMUYAf+Eo6kUFo4RchNmi
	 c+9/8A6UxInbnaf5lp1x8MPnQpSkD/+yOvNOxS15/PiyWOBJDIxESba2+Cl0I+9V67
	 5KTEbVepC9wQjSLXypDVS64YV/88SNtZXktIbDeopLkOOJzjyYOnP4h0ZURKn18W67
	 Gf06E3Ewoiqg/Ibqb5ipk3qUGJieFfnrD1EkrkGzkndxHdiaZGoVR2rVBSU536gu7n
	 mFOk2LPXVkzxw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 4489BF4006A;
	Wed, 21 Jan 2026 11:23:25 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 21 Jan 2026 11:23:25 -0500
X-ME-Sender: <xms:ff1wacgDUIwUfLG9TVwNtJLPCkn_lFU5GyryKAf2juEOLuzn8zBsVQ>
    <xme:ff1waUSEjbKEhmAWBo4QNq4RyRyfGqMW0HjHRg_b_DEWreamWoKHPCQS4cWAFeQsu
    AhO8G180OYHi8LnCOlcMsW6KcMkIRBOnV5nUznJIrPhyFE47leQmQ>
X-ME-Received: <xmr:ff1waW5dJSx60GnXnkD7cpAzjtMr3WyUQNufn0wSopU_yTM9Zax-ZS75m9LIvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddugeefjeehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhephffvvefufffkofgjfhggtgfgsehtkeertdertdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeffkefffedugfeiudejheefleehteevtefgvefhveetheehkefhjeefhefgleej
    veenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopedvtddpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtth
    hopehmuhgthhhunhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhi
    ugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrug
    drohhrghdprhgtphhtthhopehushgrmhgrrghrihhfieegvdesghhmrghilhdrtghomhdp
    rhgtphhtthhopehfvhgulhesghhoohhglhgvrdgtohhmpdhrtghpthhtohepohhsrghlvh
    grughorhesshhushgvrdguvgdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhg
    pdhrtghpthhtohepvhgsrggskhgrsehsuhhsvgdrtgii
X-ME-Proxy: <xmx:ff1waUxzE2AGRjlhFFdAmMEC3KgVbbdlBBPGlWnFaM0WQ-ZhKXhKfA>
    <xmx:ff1waeCnOsfMPO6qAyJT9sPAzcHVshrQ6OmHqXEo2NFT2qedCSmAGg>
    <xmx:ff1waUYJUGUjrUkQ-iFquA18JlEGjBEAINHru2S9Zb0hBRti5_AOgg>
    <xmx:ff1wadG9BFUQPI8WJZlUpl4foJOXkGvpNrRK1_llQrXsD-FWsNl_CQ>
    <xmx:ff1waQuCrQMqOh2O2lINbX025O8OGR64mnCYkCKxdda0XNZG2Tasg4AZ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 21 Jan 2026 11:23:24 -0500 (EST)
From: Kiryl Shutsemau <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
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
	kernel-team@meta.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Kiryl Shutsemau <kas@kernel.org>
Subject: [PATCHv4 14/14] hugetlb: Update vmemmap_dedup.rst
Date: Wed, 21 Jan 2026 16:22:51 +0000
Message-ID: <20260121162253.2216580-15-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260121162253.2216580-1-kas@kernel.org>
References: <20260121162253.2216580-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6nqrwdinjpoemofnziry4wszomhd16he
X-Rspamd-Queue-Id: 5AB2840003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1769012607-797729
X-HE-Meta: U2FsdGVkX1+lOQLqZFSTUHj7UA7WNQujWvFet8l+zJjuFgeBtTv/A+SdMxHeJjVkqNLz7wHY1uhCn4xAnn3I4znrVNu4wzttrAracxaA8U6vUlBnebfLF8E1zV976T2qGmuB2uRzU0D6/zi9por1s9Lsls2c7gItdlZCm6zBRvDKoVdVGIhRqr6RTK4BUGFcQAZY6d52rNAft3F7IfkPeJ6E5tU3sZ680fgo/DQPfjy46Jp+SMjEw8+N1EP67CgIh8g+3r6u/di3DVuKNVeFRLVK6SNGX3gn50D1G/uh1M1QYcs4AiyrF4/Q9h7UKQMU32GRil7rEspXjpc23SpXSIIDyEoADkIhdkjyoBJKtaNor4trMQuQEQWWn/U61vsQunk7yC+Cr7jSsXtuZ2yp+vQtJwNPTbd0vO815twjw5RYwz4O5+F4Zw803xUJjE7gtc+CQE/54lOkptv6EiAhMQo9vJsgGw753sNpH9ODLwcdzMukAiL4XlCM6+0JBBYhbVhUDU8LbaSlV4Eb+eP3GB7fnheNlx2+IpimEN5QwlyOaQyAxTcveFKS63fmyJPbxF5VzUj32OibVktT+VafBrkRBbTISKV1sfUhx4Lj/eW6jwYdSD/dccwM4ro3XBVCP2mDiANnUMUCfAxt3qDW7pLbnEygSFrl8LejC4olr6seK+zcQttZsuv27iZo4C+1gi4jjyb++mxWXUyQLsMzZ259CtGc8Px7o3VA9xVr8vgOqenImjFfZAV25I7WnbFagQugJQpRUm8JHdEPHnCZO0p8HKLNIqGV/h0jPUAm5OKP1lhJs4ysJfcCslS56UprMlTXCW6i8BZif2HR8R5EL6PPV4q0OG7Ab65h6Ek+KeBkyU+iqD1JuvvtpWxjLZQqDbDvaIN7cVPVkYn1E6oAjKqMgohQYLYU2StjT1NBNR15c2egDp6WLQe19PE9cbeTrycemgqV4IdwOT4zoI2
 4am38pcV
 7GRTMZFHFT/b/7D/wRyr33IejtPM7bOUbn5a3gOI+b5aFAmFJUD1OD2upfCW6OYcJ/S7imqVvdRKPoZesfHY8brcNFgAyGR4tu6jR0whv2gz5GZj6o1E+n+tBPXf1S9e94d+WLXe0ik2UIApNjVxj3sHw5+3AxZDukbHKQ9+xpa0+QdaTLLYBWOrwh5ixiHXC4GWfIohWqM4hh9kiv9JkNvtkrJaU4l3pAmPkbrJnbfp1xtkEAVAxx16oXMtAJGZe3Xxz4hCsP11LyWyNzilfvQbecAnDMl/AoLMPap2hByKJfuz8hFZWQ7NWi00CrMchUbQA0bIlwqLMJIj322RXXAkSXQ==
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


